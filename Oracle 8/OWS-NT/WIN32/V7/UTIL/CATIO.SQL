REM 
REM $Header: catio.sql,v 1.2 1993/02/23 15:25:12 HRIZVI Exp $ 
REM 
REM  Copyright (c) 1991 by Oracle Corporation 
REM    NAME
REM      catio.sql - I/O per table statistics
REM    DESCRIPTION
REM      Collect I/O per table (actually object) statistics by statistical
REM      sampling
REM    NOTES
REM      This works by sampling the buffer at the end of the buffer cache LRU
REM      list.  The theory is that this buffer was read in at some point and
REM      therefore counts as a an IO.  All buffers that are read in will
REM      eventually find themselves at the end of the LRU list. There is a
REM      stored procedure that periodically samples the buffer at the end of
REM      the lru list and a view that generates a database object name given
REM      the block number of the buffer.
REM
REM      Note that this file will tell you the distribution of IOs 
REM      between tables, but it will not tell you the exact number of IOs.
REM
REM      The DBMSLOCK file must be loaded before this is loaded in order to
REM      get the definition of sleep().
REM    MODIFIED   (MM/DD/YY)
Rem     hrizvi     02/09/93 -  apply changes to x$bh 
REM     jloaiza    11/03/92 -  Creation 



/* Map an extent to a base object (table, index, ...) */

drop view extent_to_object;
create view extent_to_object as
  select uet$.file# file# 
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb
       , obj$.name name 
       , 'TABLE' kind
  from tab$, uet$, obj$
  where tab$.clu# is null
    and tab$.file# = uet$.segfile#
    and tab$.block# = uet$.segblock#
    and tab$.obj# = obj$.obj#
union all
  select distinct
         uet$.file# file# 
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb
       , obj$.name name 
       , 'CLUSTER' kind
  from tab$, uet$, obj$
  where tab$.clu# is not null
    and tab$.file# = uet$.segfile#
    and tab$.block# = uet$.segblock#
    and tab$.clu# = obj$.obj#
union all
  select uet$.file# file# 
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb 
       , obj$.name name 
       , 'INDEX' kind
  from ind$, uet$, obj$
  where ind$.file# = uet$.segfile#
    and ind$.block# = uet$.segblock#
    and ind$.obj# = obj$.obj#
union all
  select uet$.file# file#
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb
       , undo$.name name
       , 'ROLLBACK SEGMENT' kind
  from undo$, uet$
  where undo$.file# = uet$.segfile#
    and undo$.block# = uet$.segblock#
union all
  select uet$.file# file#
       , uet$.block# lowb
       , uet$.block# + uet$.length - 1 highb
       , 'TEMP SEGMENT' name
       , 'TEMP SEGMENT' kind
  from uet$, seg$
  where seg$.file# = uet$.segfile#
   and  seg$.block# = uet$.block#
   and  seg$.type = 3
union all
  select file#
       , block#
       , length + block#
       , 'FREE EXTENT'
       , 'FREE EXTENT'
  from fet$;


REM  This table maps extents to database objects. This table must be 
REM  dropped and recreated to include any new extents that are added 
REM  after the last time it was created.  Its purpose is to speedup
REM  the views created below.

drop table extent_to_object_tab;
create table extent_to_object_tab as select * from extent_to_object;
create unique index extent_to_object_ind on extent_to_object_tab (file#, lowb);


REM  The IO_HISTOGRAM table contains samples of the block number of the block
REM  that is at the end of the buffer cache LRU list.

drop table io_histogram;
create table io_histogram (fileid number,blockid number, io_type varchar2(20));


REM This procedure periodically samples the buffer at the end of the lru list
REM and then writes its blockid into the IO_HISTOGRAM table.

drop procedure sample_io;

create procedure sample_io
  (duration number,     -- total sampling time in minutes
   sleep_time number    -- time to sleep between taking samples in seconds
  )
is
   time_so_far number;
   tail_of_lru number;
   this_tail_of_lru number;
   last_file_id number;
   this_file_id number;
   last_block_id number;
   this_block_id number;
   block_flag    number;
begin
   time_so_far := 0;
   last_file_id := 0;
   last_block_id := 0;

   -- Get the tail of lru value, this can be in flux, so try it several times
   -- to be sure.
   tail_of_lru := 4000000000;          -- init to very large value
   for i in 1..5 loop
     select min(nxt_lru) into this_tail_of_lru from x$bh;
     if (this_tail_of_lru < tail_of_lru) 
     then 
       tail_of_lru := this_tail_of_lru;
     end if;
   end loop;

   -- loop until time runs out
   while (time_so_far < duration * 60) loop

     -- get buffer at the end of the lru list
     begin
      select dbafil, dbablk, flag into this_file_id, this_block_id, block_flag 
         from x$bh 
         where ((nxt_lru = tail_of_lru) and 
		(state = 1 or state = 2) and
		(rownum = 1));
     exception when no_data_found then null;
     end;

     -- don't insert same buffer twice, this means no activity on lru list
     if (this_file_id != last_file_id AND this_block_id != last_block_id)
     then
       insert into io_histogram 
            values (this_file_id, this_block_id, 
	            decode(bitand(block_flag,524288),0,'random','sequential'));
     end if;

     last_file_id := this_file_id;	
     last_block_id := this_block_id;

     dbms_lock.sleep(sleep_time);             -- go to sleep for a while
     time_so_far := time_so_far + sleep_time;    
   end loop;
end;
/



REM Create a view that summarizes the IO information per database object. 

drop view io_per_object;

create view io_per_object as
select name, kind, io_type, count(*) blocks_read
 from extent_to_object_tab e, io_histogram io
 where e.file# = io.fileid
  and  blockid between e.lowb and e.highb
  group by name, kind, io_type;







