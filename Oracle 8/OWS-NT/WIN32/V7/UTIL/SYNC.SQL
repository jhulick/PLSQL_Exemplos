rem
rem $Header: sync.sql,v 1.12 1992/09/30 11:33:27 RKOOI Stab $ 
rem
rem Copyright (c) 1991 by Oracle Corporation 
rem  NAME
rem    sync.sql - synchronization primitives to help write multi-user tests
rem  DESCRIPTION
rem    Call these routines to synchronize multiple test scripts.
rem  RETURNS
rem
rem  NOTES
rem    Several test scripts (such as sqldba scripts) can keep themselves
rem    synchronized in order to test concurrent activity.  These might be
rem    different scripts or multiple instances of the same script. For
rem    example, suppose you want to test the concurrent execution of
rem    the stmt 'select * from dual' by three processes, followed by the
rem    concurrent execution of 'grant select on dual to public' by three
rem    processes.  You would use the test mechanism to fork three 
rem    instances of the sqldba script:
rem		execute sync.init(3)
rem		execute sync.wait
rem		select * from dual
rem		execute sync.wait
rem		grant select on dual to public;
rem    or suppose you wanted to test the concurrent execution of 
rem    'select * from dual' and 'grant select on dual to public'  Then you
rem    have the test mechanism fork the two scripts:
rem        execute sync.init(2)                execute syn.init(2)
rem        execute sync.wait                   execute sync.wait
rem        grant select on dual to public      select * from dual
rem    You can also force ordering of stmts between two scripts.  Suppose
rem    you want to update from one script and then delete from another
rem    script.  You would fork the scripts:
rem        execute sync.init(2)                execute syn.init(2)
rem        execute sync.wait                   execute sync.wait
rem        update emp set sal=1000 where id=3  execute sync.wait
rem        execute sync.wait                   delete emp where id=3
rem
rem    setdefaults - choose which sequence of lockids to use (defaults to
rem		     lockids 1,2,3 and 4.  Also can specify the timeout in
rem		     seconds (defaults to forever)
rem    init - assumes you hold no locks upon entry.  It busywaits until all
rem           cohorts (the number of which you specify as its parameter)
rem           arrive.  Upon exit you will hold a share lock on the front door.
rem    wait - assumes you hold a share lock on the front door.  It waits
rem           (not busywait) until all cohorts arrive.  Upon exit you will
rem           hold a share lock on the front door of the next house.
rem    cleanup - releases any locks still held
rem
rem    The first synchronization point in the scripts must be done with the
rem    'init' call and all subsequent synchronization points must be done with
rem    the 'wait' call.  All cohorts must agree on the number of cohorts (the
rem    value passed to the init call).
rem
rem    Lockids 1, 2 and 3 are used by these routines.  The timeout is 
rem    essentially forever.  You can change the lockids or the timeout with
rem    setdefaults.  If you choose lockid n, then lockids n, n+1 and n+2 will
rem    be used.  Currently changing the timeout is not supported.
rem
rem    This package assumes table 'sync$blocker(cnt number)' exists and has one
rem    row.  It does not matter what the value of the row is.
rem
rem  MODIFIED   (MM/DD/YY)
Rem     rkooi      09/02/92 -  change ORU errors 
Rem     rkooi      06/10/92 -  add rae errors 
Rem     tpystyne   06/02/92 -  grant execute to public 
Rem     mmoore     02/06/92 -  remove references to standard_extensions 
Rem     rkooi      07/24/91 -  check for null before calling release due t
rem   rkooi      07/08/91 - enable timeout setting 
rem   rkooi      06/28/91 - enable setdefaults of lockid 
rem   rkooi      05/06/91 - change references from lok to user_lock 
rem                         and improve init so only one user busy-waits
rem                         instead of all (thx to Steve Faris)
rem   rkooi      04/29/91 - change name of blocker table 
rem   rkooi      04/23/91 - Creation 

drop table sync$blocker;
create table sync$blocker(cnt number);
comment on table sync$blocker is
'Used by stored procedure sys.sync.init to coordinate the multiple user initialization of this package';
insert into sync$blocker values(0);
commit;

drop package sync;

create package sync is
  procedure setdefaults(timeout  number, lockid  number);
  procedure init(numprocs  number);
  procedure wait;
  procedure cleanup;
end;
/
create package body sync is
  frontdoor        number;
  backdoor         number;
  nextfront        number;
  nextback         number;
  tmo              number := user_lock.maxwait;
  lid              number := 1;
  disable          boolean;

  procedure request(id number, lockmode number, timeout number, global number,
                    msg char) is
    status  number;
  begin
    status := user_lock.request(id, lockmode, timeout, global);
    if status <> 0 then
      disable := TRUE;
      if status = 1 then
        raise_application_error(-20995,
          'ORU-10004: timeout on lock request: ' || msg);
      end if;
      raise_application_error(-20000,
        'ORU-10005: lock request error: ' || msg || ' Status: '
        || to_char(status));
    end if;
  end;   
  
  procedure convert(id number, lockmode number, timeout number, msg char) is
    status  number;
  begin
    status := user_lock.convert(id, lockmode, timeout);
    if status <> 0 then
      disable := TRUE;
      if status = 1 then
        raise_application_error(-20995, 
          'ORU-10006: timeout on convert request: ' || msg);
      end if;
      raise_application_error(-20000,
        'ORU-10007: lock convert error: ' || msg || ' Status: '
        || to_char(status));
    end if;
  end;   
  
  procedure release (id number, msg char) is
    status  number;
  begin
    status := user_lock.release(id);
    if status <> 0 then
      disable := TRUE;
      raise_application_error(-20000, 
        'ORU-10008: lock release error: ' || msg || ' Status: '
        || to_char(status));
    end if;
  end;

  -- allow client to specify timeout period and lockid's to user
  procedure setdefaults(timeout  number, lockid number) is
  begin
    if timeout > 0 then
      tmo := timeout;
    end if;
    if lockid > 0 then
      lid := lockid;
    end if;
  end;

  -- 'init' causes us to wait until everyone is in the house for the first
  -- time.  it does busywaiting.  After everyone does 'init' once, they can
  -- thereafter do 'wait'.
  procedure init(numprocs  number) is
    tmp    number;
    status number;
    cursor getcnt is select cnt from sync$blocker;
  begin
    disable   := FALSE;
    frontdoor := lid;
    backdoor  := lid + 1;
    nextfront := lid + 2;
    nextback  := lid + 3;

    status := user_lock.request(frontdoor, user_lock.x_mode, 0,
                                user_lock.global);
    if status = 0 then 

      -- we got the exclusive lock so we are first, and only, one in 
      -- the house. initialize the cnt of people in the house to 1
      update sync$blocker set cnt = 1;
      commit;

      -- get exclusive lock on nextfront.  This scheme is so that only
      -- WE have to busywait and all of the others can just do a regular
      -- wait on nextfront.
      request(nextfront, user_lock.x_mode, tmo, user_lock.global,
              'sync.init: nextfront x_mode');

      -- now open the front door to allow rest of people to come in the 
      -- house and update the cnt
      convert(frontdoor, user_lock.s_mode, tmo,'sync.init: convert frontdoor');

      -- now busy wait until everyone is in the house
      <<again>>
      -- should just use regular select but currently pl/sql bug where they
      -- don't close the cursor properly and we run out of cursors
      open getcnt;
      fetch getcnt into tmp;
      close getcnt;
      if tmp < numprocs then
        user_lock.sleep(100);  -- sleep for one second
        goto again;
      end if;

      -- release nextfront lock
      release(nextfront, 'sync.initfirst: nextfront');

    elsif status = 1 then -- timed out

      -- wait for front door to open
      request(frontdoor, user_lock.s_mode, tmo, user_lock.global,
              'sync.init: frontdoor s_mode');

      -- now update cnt of people in the house so the first person in the 
      -- house will know that we are here
      update sync$blocker set cnt = cnt+1;
      commit;

      -- get shared lock on nextfront.  this will cause us to wait until
      -- the first person in the house detects that we are all here
      request(nextfront, user_lock.s_mode, tmo, user_lock.global,
              'sync.init: nextfront s_mode');

      -- release nextfront lock
      release(nextfront, 'sync.init: nextfront');

    else
      disable := TRUE;
      raise_application_error(-20000,
        'ORU-10009: request x_mode error: ' || to_char(status));
    end if;
  end;

  -- wait is much more efficient than 'init' since it does not busy wait.
  -- however it does require that all people hold share locks on the front
  -- door before proceeding.
  procedure wait is
    tmp    number;
    status number;
  begin
    -- if fatal error then don't want to hang forever
    if disable IS NULL then
      raise_application_error(-20000, 
        'ORU-10010: package "sync" not initialized.' || 
        '  Use "sync.init(<num concurrent users>)"');
    end if;
    if disable then
      raise_application_error(-20000,
        'ORU-10011: Package "sync" disabled.  ' ||
        'Use "sync.cleanup", then "sync.init"');
    end if;

    -- at this point everyone has a shared lock on the front door and we
    -- don't know if anyone has closed the back door yet (X lock)

    status := user_lock.request(backdoor, user_lock.x_mode, 0,
			        user_lock.global);
    if status = 0 then

      -- we are first one in the house and we have just shut the back door.
      -- now try to shut the front door, this can only happen after
      -- everyone is inside.
      convert(frontdoor, user_lock.x_mode, tmo, 'sync.wait: frontdoor');

      -- now the front door is shut and everyone is inside.
      -- free this lock since don't need anymore.
      release(frontdoor, 'sync.wait: frontdoor');

      -- get s lock on frontdoor of next house to keep the door open till
      -- we get there.
      request(nextfront, user_lock.s_mode, tmo, user_lock.global,
              'sync.wait: nextfront s_mode');

      -- now open the back door and let everyone out to race to the next 
      -- house!
      release(backdoor, 'sync.wait: backdoor');

    elsif status = 1 then

      -- we are not the first one in the house.
      -- get s lock on frontdoor of next house to keep the door open till
      -- we get there.
      request(nextfront, user_lock.s_mode, tmo, user_lock.global,
              'sync.wait: nextfront s_mode');

      -- free our lock on the front door of this house to indicate that we are
      -- inside.  Back door won't open until we do this.
      release(frontdoor, 'sync.wait: frontdoor');

      -- wait for the back door to open
      request(backdoor, user_lock.s_mode, tmo, user_lock.global,
              'sync.wait: backdoor s_mode');

      -- release backdoor lock since no longer needed
      release(backdoor, 'sync.wait: backdoor');

      -- now race to next house!
    else
      disable := TRUE;
      raise_application_error(-20000,
        'ORU-10012: request x_mode error: ' || to_char(status));
    end if;

    -- swap frontdoor with nextfront
    tmp := frontdoor;
    frontdoor := nextfront;
    nextfront := tmp;
    -- swap backdoor with nextback
    tmp := backdoor;
    backdoor := nextback;
    nextback := tmp;
  end;

  procedure cleanup is
    status  number;
  begin
    -- release all locks
    if frontdoor IS NOT NULL then
      status := user_lock.release(frontdoor);
    end if;
    if backdoor IS NOT NULL then
      status := user_lock.release(backdoor);
    end if;
    if nextfront IS NOT NULL then
      status := user_lock.release(nextfront);
    end if;
    if nextback IS NOT NULL then
      status := user_lock.release(nextback);
    end if;
    disable := NULL;
  end;

end;
/

drop public synonym sync
/
create public synonym sync for sys.sync
/
grant execute on sync to public
/
