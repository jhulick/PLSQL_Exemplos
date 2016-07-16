Rem
Rem $Header: diutil.sql rel73/8 08-dec-95.15:47:32 usundara Exp $ 
Rem
Rem Copyright (c) 1992, 1995 by Oracle Corporation
Rem   NAME
Rem     diutil.pls - package DIUTIL
Rem   DESCRIPTION
Rem Diana application routines
Rem
Rem   RETURNS
Rem
Rem   NOTES
Rem     <other useful comments, qualifications, etc.>
Rem   MODIFIED    (MM/DD/YY)
Rem      usundara  12/08/95 - minor formatting - sync with pidubdy.pls
Rem      usundara  12/08/95 - more on DEFAULTED - defValOption
Rem      cbarclay  12/08/95 - commented DEFAULTED
Rem      cbarclay  12/08/95 - defaulted output for default arguments
Rem      cbarclay  11/14/95 - keep in  synch -- more text rearranging for p2icd
Rem      cbarclay  11/10/95 - fix is_v6_compatible type
Rem      usundara  07/28/95 - bugfix 264375 (mrg from 2.2) - add load_source
Rem                           modify eText : include D_NUMERI and D_NULL_A.
Rem     zwalcott   06/18/95 -  merge from 2.2.  Bug 268956.  fix in normalName
Rem     zwalcott   06/14/95 -  fix bug : 268956.  var firstChar   in function n
Rem     usundara   10/01/94 -  merge from 1.23.720.5: PSTUBI,PSTUBQ,PSTUBR
Rem     usundara   06/07/94 -  merge 1.20.710.3 and 1.20.710.4 (bug #196374);
Rem                            also, don't pass in PUBLIC cos kgl does this.
Rem     usundara   04/08/94 -  merge changes from branch 1.20.710.2
Rem                            fix traversals (161306,147036) add libunit_type
Rem     usundara   01/06/94 -  fix #190597; deal with %type; reindent (merge)
Rem     smuench    05/26/93 -  fix problems w/ boolean support
Rem     pshaw      10/21/92 -  modify script for bug 131187 
Rem     gclossma   09/28/92 -  sanitize 
Rem     gclossma   09/07/92 -  logic error (as if there's some other kind?) 
Rem     gclossma   09/04/92 -  no more to-varchar2 
Rem     gclossma   08/05/92 -  source-control Steve M's changes for booleans 
Rem     smuench    07/17/92 -  add boolean param supt, int_to_bool/bool_to_int
Rem     gclossma   07/14/92 -  pstubT: add constraints to CHARs; bigger pkgs 
Rem     gclossma   05/08/92 -  simplify; check buffer lengths 
Rem     gclossma   04/10/92 -  gen CHAR stead of VARCHAR2 for sqlforms3 for v6 
Rem     ahong      03/25/92 -  fix synonym expansion for pstub
Rem     ahong      03/20/92 -  add s_notInPackage
Rem     ahong      03/12/92 -  synonym
Rem     ahong      03/10/92 -  no s_noPriv
Rem     ahong      03/03/92 -  return empty instead of null
Rem     ahong      02/21/92 -  upper names
Rem     ahong      02/11/92 -  Creation


Rem  NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
Rem  NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
Rem  NOTE: you must be connected "internal" (i.e. as user SYS) to run this
Rem  script.
Rem  NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
Rem  NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE


drop table sys.pstubtbl;

create table sys.pstubtbl (
  username varchar2(30),
  dbname   varchar2(128),
  lun      varchar2(30),
  lutype   varchar2(3),
  lineno   number,
  line     varchar2(1800) 
);

grant select,delete on sys.pstubtbl to public;

drop package body sys.diutil;
drop package sys.diutil;



create or replace package sys.diutil is

  e_subpNotFound exception;
  e_notInPackage exception;
  e_noPriv exception;
  e_stubTooLong exception;
  e_notv6compat exception;
  e_other exception;

  subtype ptnod is pidl.ptnod;
  subtype ub4 is pidl.ub4;

  --   Return code from diutil functions
  --
  s_ok constant number := 0;            -- successful
  s_notInPackage constant number := 6;  -- package found, proc not found
  s_subpNotFound constant number := 1;  -- subprogram not found
  s_stubTooLong constant number := 3;   -- text to be returned is too long
  s_logic constant number := 4;         -- logic error
  s_other constant number := 5;         -- other error
  s_defaultVal constant number := 8;    -- true iff parameters have default
                                        --   values.  Applicable to pstub
  s_notv6compat constant number := 7;   -- found non v6 type or construct

  char_for_varchar2 boolean;            -- set from flags for v6 compatibility

  libunit_type_spec constant number := 1;
  libunit_type_body constant number := 2;

  load_source_yes constant number := 1;
  load_source_no  constant number := 2;

  -- get_d: returns the root of the diana of a libunit, given name and usr.
  --    name will be first folded to upper case if not in quotes, else stripped
  --    of quotes.
  --    In:  name = subprogram name
  --         usr  = user name
  --         dbname = database name, null for current
  --         dbowner = null for current
  --         libunit_type = libunit_type_spec for spec,
  --                      = libunit_type_body for body
  --    Out: status = s_ok(0): diana root returned in nod
  --                  s_subpNotFound:  nod null
  --                  s_other:   other error, nod null
  --
  procedure get_d(name varchar2, usr varchar2, dbname varchar2,
         dbowner varchar2, status in out ub4, nod OUT ptnod, 
         libunit_type number := libunit_type_spec,
         load_source number := load_source_no);

  -- get_diana: returns the root of the diana of a libunit, given name and usr.
  --    name will be first folded to upper case if not in quotes, else stripped
  --    of quotes.  Will trace synonym links.
  --    In:  name = subprogram name
  --         usr  = user name
  --         dbname = database name, null for current
  --         dbowner = null for current
  --         libunit_type = libunit_type_spec for spec,
  --                      = libunit_type_body for body
  --    Out: status = s_ok(0): diana root returned in nod
  --                  s_subpNotFound:  nod null
  --                  s_other:   other error, nod null
  --
  procedure get_diana(name varchar2, usr varchar2, dbname varchar2,
         dbowner varchar2, status in out ub4, nod in out ptnod,
         libunit_type number := libunit_type_spec,
         load_source number := load_source_no);

  -- subptxt: returns the text of a subprogram source (DESCRIBE).
  --    In:  name - package or toplevel proc/func name;
  --         subname - non-null to specify proc/func in package <name>.
  --         dbname - database name
  --         dbowner - dbase owner
  --    Out:  status = s_ok (0): text returned in txt
  --                   s_subpNotFound: txt empty
  --                   s_notInPackagte: txt empty
  --                   s_stubTooLong: txt len too small; txt empty
  --                   s_logic: logic error; txt empty
  --                   s_other: other failure; txt empty
  --
  procedure subptxt(name varchar2, subname varchar2, usr varchar2, 
                    dbname varchar2, dbowner varchar2, txt in out varchar2,
                    status in out ub4);

  -- pstub:  procedure returning stub text of a subprogram
  --         In:  pname - subprogram name
  --              subname - NULL or member name (if pname is a package
  --                        spec)
  --              uname - user name, NULL or '' to mean current user
  --              dbname - database name
  --              dbowner - dbase owner
  --         Out: status - s_ok (0): stub text in return val
  --                       s_subpNotFound: stubSpec, stubText empty
  --                       s_stubTooLong: stub text too long; stubSpec, 
  --                                                    stubText empty
  --                       s_logic: logic error; stubSpec, stubText empty
  --                       s_other failure; stubSpec, stubText empty
  --                       s_defaultVal: proc/func default parm values; 
  --                            stubSpec,  stubText partial
  --              stubSpec - empty if subprogram is a top level proc/func
  --                         or if subname is specified for package pname,
  --                         else contain package spec
  --              stubText - contains stub body
  --
  procedure pstub(pname varchar2, subname varchar2, 
                  uname varchar2, dabaname varchar2, dbowner varchar2,
                  status in out ub4, flags varchar2, stubtype in out varchar2);

  -- bool_to_int:  Translates 3-valued boolean to NUMBER for use
  --               in sending boolean parameter / return values
  --               between PLS v1 (client) and PLS v2. Since SQLNET
  --               has no boolean bind variable type, we encode 
  --               booleans as FALSE = 0, TRUE = 1, NULL = NULL for
  --               network transfer as NUMBER
  --
  function bool_to_int( b BOOLEAN) return number;

  -- int_to_bool:  Translates 3-valued NUMBER encoding to BOOLEAN for use
  --               in sending boolean parameter / return values
  --               between PLS v1 (client) and PLS v2. Since SQLNET
  --               has no boolean bind variable type, we encode 
  --               booleans as FALSE = 0, TRUE = 1, NULL = NULL for
  --               network transfer as NUMBER
  --
  function int_to_bool( n NUMBER) return boolean;

end diutil;
/



Rem
Rem  Package body DIUTIL:
Rem
Rem
create or replace package body sys.diutil is

  defValOption_ignore constant number := 0;
  defValOption_full constant number := 1;
  defValOption_DEFAULT_comment constant number := 2;

  -----------------------
  --  Private members
  -----------------------

  procedure diugdn(name varchar2, usr varchar2, dbname varchar2,
                   dbowner varchar2, status out ub4, nod OUT ptnod,
                   libunit_type binary_integer,
                   load_source binary_integer);
    pragma interface(c,diugdn);
  procedure diustx(n ptnod, txt out varchar2, status out ub4);
    pragma interface(c,diustx);

  assertVal constant boolean := TRUE;

  -----------------------
  -- assert
  -----------------------
  procedure assert(v boolean, str varchar2) is
    x integer;
  begin
    if (assertVal and not v) then
      raise program_error;
    end if;
  end assert;

  -----------------------
  -- assert
  -----------------------
  procedure assert(v boolean) is
  begin
    assert(v, '');
  end;

  -----------------------
  -- last_elt
  -----------------------
  function last_elt (seq pidl.ptseqnd) return pidl.ptnod is
    len binary_integer;
  begin
    len := pidl.ptslen(seq);
    assert(len > 0);
    return pidl.ptgend(seq, len - 1);
  end last_elt;

  -----------------------
  -- normalName: return a normalized name.  Fold up if not in quotes,
  -- else strip quotes.
  -----------------------
  function normalName(name varchar2) return varchar2 is
    firstChar varchar2(4);
    len number;
  begin
    if (name is null or name = '') then return name; end if;
    firstChar := substr(name, 1, 1);
    if (firstChar = '"') then
      len := length(name);
      if (len > 1 and substr(name, len, 1) = '"') then
        if (len > 33) then
          len := 31;
        else
          len := len-2;
        end if;
        return substr(name, 2, len);
      end if;
     end if;
     return upper(name);
  end normalName;

  -----------------------
  -- coatName: Enquote name if necessary
  -----------------------
  function coatName(name varchar2) return varchar2 is
  begin
    if (name <> upper(name)) then
      return '"' || name || '"';
    elsif char_for_varchar2 and name = 'VARCHAR2' then
      return 'CHAR';
    else
      return name;
    end if;
  end coatName;

  -----------------------
  -- idName
  -----------------------
  function idName(n ptnod) return varchar2 is
    -- return the text of an ID node.  This function is also
    -- used to limit the recursion in exprText() below.
    -- Should have the semantics of listText(diana.as_list(n), ',');
    seq pidl.ptseqnd;
  begin
    assert(pidl.ptkin(n) = diana.DS_ID);
    seq := diana.as_list(n);
    return coatName(diana.l_symrep(last_elt(seq)));
  end idName;

  -----------------------
  -- exprText: General unparsing function
  -----------------------
  procedure exprText(x ptnod, rv in out varchar2);

  -----------------------
  -- genProcSpec
  --  Append the spec for a top-level node n to sText.
  --  defValOption controls whether parm default vals should be ignored,
  --    printed fully or flagged in comments as "DEFAULTED"
  --  hasDefVal returned true iff parm default vals exist.
  --  Toplevel name returned in pName.  
  --  If function, function string returned in returnVal.
  -----------------------
  procedure genProcSpec(n ptnod, 
                        defValOption number,
                        hasDefVal in out boolean,
                        pName in out varchar2, 
                        returnVal in out varchar2, 
                        flags varchar2,
                        sText in out varchar2);


  -----------------------
  -- procName
  -----------------------
  function procName(k ptnod) return varchar2 is
    x ptnod; xKind pidl.ptnty;
  begin
    if (k is null or k = 0) then return null; end if;
    if (pidl.ptkin(k) <> diana.D_S_DECL) then return null; end if;
    x := diana.a_d_(k);
    xKind := pidl.ptkin(x);
    if (    xKind <> diana.DI_FUNCT
        and xKind <> diana.DI_PROC
        and xKind <> diana.D_DEF_OP) then
      return null;
    end if;
    return diana.l_symrep(x);
  end;


  -----------------------
  --  Private members
  -----------------------


  -----------------------
  -- get_d
  -----------------------
  procedure get_d (name varchar2, usr varchar2, dbname varchar2,
                   dbowner varchar2, status in out ub4, nod OUT ptnod,
                   libunit_type number := libunit_type_spec,
                   load_source number := load_source_no) is
    nName varchar2(100);
    nUsr varchar2(100);
    nDbname varchar2(100);
    nDbowner varchar2(100);
  begin -- get_d
    nod := null;
    begin
      nName := normalName(name);
      nUsr := normalName(usr);
      nDbname := normalName(dbname);
      nDbowner := normalName(dbowner);
      if (nName is null or nName = '') then
        raise e_subpNotFound;
      end if;
      diugdn(nName, nUsr, nDbname, nDbowner, status, nod,
             libunit_type, load_source);

      if (status = 1) then
        diugdn(nName, '', nDbname, nDbowner, status, nod,
               libunit_type, load_source);
      end if;

      if (status = 1) then
        raise e_subpNotFound;
      elsif (status = 2) then
        raise e_noPriv;
      elsif (status <> 0) then
        raise e_other;
      end if;
      status := s_ok;
    exception
      when e_subpNotFound then
        status := s_subpNotFound;
      when e_noPriv then
        status := s_subpNotFound;
      when others then
        status := s_other;
    end;
  end get_d;

  -----------------------
  -- get_diana
  -----------------------
  procedure get_diana (name varchar2, usr varchar2, dbname varchar2,
                       dbowner varchar2,
                       status in out ub4, nod in out ptnod,
                       libunit_type number := libunit_type_spec,
                       load_source number := load_source_no) is
    t ptnod;
  begin -- get_diana
    nod := null;
    begin
      get_d(name, usr, dbname, dbowner, status, nod,
            libunit_type, load_source);
      if (status = s_ok) then
        t := diana.a_unit_b(nod);
        assert(pidl.ptkin(t) <> diana.Q_CREATE);
      end if;
    exception
      when program_error then
	status := s_other;
      when others then
	status := s_other;
    end;
  end get_diana;


  -----------------------
  -- subptxt
  -----------------------
  procedure subptxt(name varchar2, subname varchar2, usr varchar2,
                    dbname varchar2, dbowner varchar2, txt in out varchar2, 
                    status in out ub4) is
    e_defaultVal boolean := FALSE;

    -----------------------
    -- describeProc
    -----------------------
    procedure describeProc(n ptnod, s in out varchar2) is
      tmpVal varchar2(100);
      rVal varchar2(500);
    begin -- describeProc
      -- We call genProcSpec here because it is not
      -- possible to get the text reliably for arbitrary node
      -- through diustx
      --
      tmpVal := null;
      genProcSpec(n, defValOption_DEFAULT_comment,
                  e_defaultVal, tmpVal, rVal, '', s);
      s := s || '; ';
    end describeProc;

  begin -- subptxt
    txt := '';

    declare
      troot ptnod;
      n ptnod;
      nSubName varchar2(100);
    begin
      get_diana(name, usr, dbname, dbowner, status, troot,
                libunit_type_spec, load_source_yes);
      if (troot is null or troot = 0) then return; end if;

      nSubname := normalName(subname);
      n := diana.a_unit_b(troot);

      if (nSubname is null or nSubname = '') then
        if (pidl.ptkin(n) = diana.D_P_DECL) then
          diustx(troot, txt, status);
        else
          describeProc(n, txt);
        end if;
      else
        -- search for subname among all func/proc in the package
        if (pidl.ptkin(n) <> diana.D_P_DECL) then
          status := s_subpNotFound;
          return;
        end if;
        n := diana.a_packag(n);
        declare
          seq pidl.ptseqnd := diana.as_list(diana.as_decl1(n));
          len integer := pidl.ptslen(seq) - 1;
          tmp integer;
        begin
          for i in 0..len loop --for each member of the package
            n := pidl.ptgend(seq, i);
            if (procName(n) = nSubname) then
              describeProc(n, txt);
            end if;
          end loop;
        end;
        if (txt is null or txt = '') then
          status := s_notInPackage;
        end if;
      end if;

    exception   -- txt reset to null
      when value_error then
        status := s_stubTooLong;
      when program_error then
        status := s_logic;
      when e_other then
        status := s_other;
      when others then
        status := s_other;
    end;
  end subptxt;


  --------------------
  -- pstub
  --------------------
  procedure pstub(pname varchar2, subname varchar2, uname varchar2,
                  dabaname varchar2, dbowner varchar2, status in out ub4,
                  flags varchar2, stubtype in out varchar2) is

    defValOpt constant number := defValOption_ignore;

    subtype ptnod is pidl.ptnod;
    lubptr ptnod;
    e_defaultVal boolean := FALSE;
    tsubName varchar2(100);

    stubSpec varchar2(32700);
    stubText varchar2(32700);
    specLine binary_integer := 1;
    textLine binary_integer := 1;

    --------------------
    -- flushStubs
    --------------------
    procedure flushStubs (partial_lines_ok boolean) is
      len binary_integer;
      pos binary_integer;
      luty varchar2(3);
      rowbuf varchar2(1820);
    begin
      pos := 1;
      len := length(stubSpec);
      if len > 0 then
        -- we have a package spec
        assert(stubtype = 'PKG');
        luty := 'PKS'; 
      end if;
      while (len - pos > 1800 or 
             (partial_lines_ok and pos <= len)) loop
        rowbuf := substr(stubSpec, pos, 1800);
        insert into sys.pstubtbl (username, dbname, lun, lutype, lineno, line)
          values (uname, dabaname, pname, luty, specLine, rowbuf);
        pos := pos + 1800;
        specLine := specLine + 1;
      end loop;
      if pos > 1 then stubSpec := substr(stubSpec, pos); end if;

      pos := 1;
      len := length(stubText);
      if len > 0 then
        -- a subprogram or package body
        if stubtype = 'PKG' then luty := 'PKB'; else luty := 'SUB'; end if;
      end if;
      while (len - pos > 1800 or 
             (partial_lines_ok and pos <= len)) loop
        rowbuf := substr(stubText, pos, 1800);
        insert into sys.pstubtbl (username, dbname, lun, lutype, lineno, line)
            values (uname, dabaname, pname, luty, textLine, rowbuf);
        pos := pos + 1800;
        textLine := textLine + 1;
      end loop;
      if pos > 1 then stubText := substr(stubText, pos); end if;
    end flushStubs;

    --------------------
    -- genStubBody
    --------------------
    procedure genStubBody(x ptnod, pName varchar2, returnVal varchar2) is
      -------------------------------------------------------
      -- append the text for the stub body to stubText buffer
      -------------------------------------------------------
      MAXVCSLEN  varchar2(4) := '2000';
      Type bindArr is Table of varchar2(30) index by binary_integer;
      parmSeq    pidl.ptseqnd;
      parmNum    natural;
      k          ptnod;
      knd        pidl.ptnty;
      uniq_id    varchar2(80);              
      parmname   varchar2(80);
      digit      integer;
      BoolPrm    Boolean := FALSE;
      bindVarLst BindArr;
      bindVarTyp BindArr;
      lstptr     integer  := 0;

      -- push_bindvar
      --
      procedure push_bindvar( v_name varchar2, v_type varchar2 ) is
      begin
        lstptr := lstptr + 1;
        bindVarLst(lstptr) := v_name;
        bindVarTyp(lstptr) := UPPER(v_type);
      end push_bindvar;

      -- get_bindvar
      --
      procedure get_bindvar( i integer, 
                             v_name OUT varchar2, 
                             v_type OUT varchar2) is
      begin
        v_name := bindVarLst(i);
        v_type := bindVarTyp(i);
      end get_bindvar;

      -- is_boolean
      --
      function is_boolean( typenode ptnod ) return boolean is
        typename varchar2(100);
      begin
        typename := '';
        exprText(typenode,typename);
        return( ltrim(rtrim(typename))='BOOLEAN');
      end is_boolean;

    begin -- genStubBody

      assert(x is not null);
      k := diana.a_header(x); assert(k is not null);
      parmSeq := diana.as_list(diana.as_p_(k));
      assert(parmSeq is not null);
      parmNum := pidl.ptslen(parmSeq);

      uniq_id := '';
      digit := 0;
      if returnVal is not null then
        -- gen a unique id, dift from any parm id, for the return-value
        -- variable
        loop
          uniq_id := 'X'||to_char(digit);
          for i in 1 .. parmNum loop
            k := pidl.ptgend(parmSeq, i-1);
            parmname := idName(diana.as_id(k));
            if parmname = uniq_id then exit; end if;
          end loop;
          if parmNum = 0 or parmname <> uniq_id then exit; end if;
          digit := digit + 1;
        end loop;
      end if;

      stubText := stubText || ' is ';
      if (returnVal is not null) then
        stubText := stubText || uniq_id || ' ';
        if (returnVal = 'CHAR' or
            returnVal = 'VARCHAR2' or
            returnVal = 'VARCHAR' or
            returnVal = 'RAW') then
          stubText := stubText || returnVal || '('||MAXVCSLEN||'); ';
        else
          stubText := stubText || returnVal || '; ';
        end if;
      end if;
      stubText  := stubText || 'begin stproc.init(''';

      If (returnVal = 'BOOLEAN') then
        stubText := stubText || 'declare '||uniq_id||'rv BOOLEAN; ';
        BoolPrm := TRUE;
      End If;

      -- Local BOOL
      if (parmNum > 0) then
        for i in 1..parmNum loop
          k := pidl.ptgend(parmSeq, i-1);
          if ( is_boolean(diana.a_name(k)) ) then
            if (NOT BoolPrm) then
              stubText := stubText || 'declare ';
              BoolPrm := TRUE;
            end if;
            stubText := stubText||uniq_id||
                 idName(diana.as_id(k))||' BOOLEAN; ';
          end if;
        end loop;
      end if;

      stubText := stubText || 'begin ';

      -- Init all BOOL params
      if (parmNum > 0) then
        for i in 1..parmNum loop
          k := pidl.ptgend(parmSeq, i-1);
          if ( is_boolean(diana.a_name(k)) ) then
            stubText := stubText||uniq_id||idName(diana.as_id(k))||
                ' := sys.diutil.int_to_bool(:'||
                idName(diana.as_id(k))||'); ';
          end if;
        end loop;
      end if;

      -- Non-BOOL Return Val
      if (returnVal is not null) then
        if (returnVal = 'BOOLEAN') then
          stubText := stubText || uniq_id ||'rv := ' || pName;
        else
          stubText := stubText || ':'||uniq_id||' := ' || pName;
        end if;
      else
        stubText := stubText ||  pName;
      end if;

      if (parmNum > 0) then
        k := pidl.ptgend(parmSeq, 0);
        -- Pass local BOOL, non-BOOL binds
        if ( is_boolean(diana.a_name(k)) ) then
          stubText := stubText || '(' || uniq_id||idName(diana.as_id(k));
        else
          stubText := stubText || '(:' || idName(diana.as_id(k));
        end if;

        for i in 2..parmNum loop
          k := pidl.ptgend(parmSeq, i-1);
          if ( is_boolean(diana.a_name(k)) ) then
            stubText := stubText || ', ' || uniq_id||idName(diana.as_id(k));
          else
            stubText := stubText || ', :' || idName(diana.as_id(k));
          end if;
        end loop;
        stubText := stubText || ')';
      end if;
      stubText := stubText || '; ';

      -- Convert OUT booleans (including return value)
      if (returnVal is not null and returnVal = 'BOOLEAN' ) then
        stubText := stubText ||':'||uniq_id||
             ' := sys.diutil.bool_to_int('||uniq_id||'rv); ';
      end if;
      if (parmNum > 0) then
        for i in 1..parmNum loop
          k := pidl.ptgend(parmSeq, i-1);
          if ( is_boolean(diana.a_name(k)) ) then
            knd := pidl.ptkin(k);
            if (knd = diana.D_OUT or knd = diana.D_IN_OUT) then
              stubText := stubText||':'||idName(diana.as_id(k))||
                    ' := sys.diutil.bool_to_int('||
                    uniq_id||idName(diana.as_id(k))||'); ';
            end if;
          end if;
        end loop;
      end if;

      stubText := stubText || 'end;''); ';

      -- Bind order according to bind var appearance in stub
      for i in 1..parmNum loop
        k := pidl.ptgend(parmSeq, i-1);
        if ( is_boolean(diana.a_name(k))) then
          knd := pidl.ptkin(k);
          declare
            tmp varchar2(100);
          begin
            if (knd = diana.D_IN) then
              tmp := 'bind_i';
              push_bindvar(IdName(diana.as_id(k)),'IN');
            elsif (knd = diana.D_OUT) then
              tmp := 'bind_o';
              push_bindvar(IdName(diana.as_id(k)),'OUT');
            else tmp := 'bind_io';
              push_bindvar(IdName(diana.as_id(k)),'IN OUT');
            end if;
            stubText := stubText || 'stproc.' || tmp || '('
              || idName(diana.as_id(k)) || '); ';
          end;
        end if;
      end loop;
      if (returnVal is not null and returnVal <> 'BOOLEAN') then
        stubText := stubText || 'stproc.bind_o(' || uniq_id || '); ';
            push_bindvar(uniq_id,'OUT');
      end if;
      for i in 1..parmNum loop
        k := pidl.ptgend(parmSeq, i-1);
        if ( NOT is_boolean(diana.a_name(k))) then
          knd := pidl.ptkin(k);
          declare
            tmp varchar2(100);
          begin
            if (knd = diana.D_IN) then
              tmp := 'bind_i';
              push_bindvar(IdName(diana.as_id(k)),'IN');
            elsif (knd = diana.D_OUT) then
              tmp := 'bind_o';
              push_bindvar(IdName(diana.as_id(k)),'OUT');
            else tmp := 'bind_io';
              push_bindvar(IdName(diana.as_id(k)),'IN OUT');
            end if;
            stubText := stubText || 'stproc.' || tmp || '('
                 || idName(diana.as_id(k)) || '); ';
          end;
        end if;
      end loop;
      if (returnVal is not null and returnVal = 'BOOLEAN') then
        stubText := stubText || 'stproc.bind_o(' || uniq_id || '); ';
        push_bindvar(uniq_id,'OUT');
      end if;

      stubText := stubText || 'stproc.execute; ';

      -- Retrieve all out bind variables
      declare
        bvarname varchar2(30);
        bvartype varchar2(30);
      begin
        for i in 1..lstptr loop
          get_bindvar(i,bvarname,bvartype);
          if (bvartype in ('OUT','IN OUT')) then
            stubText := stubText || 'stproc.retrieve(' || to_char(i)
                        || ', ' || bvarname || '); ';
          end if;
        end loop;
      end;        

      if (returnVal is not null) then
        stubText := stubText || 'return '|| uniq_id || '; ';
      end if;

      stubText := stubText || 'end; ';
    end genStubBody;

    --------------------
    -- genStub
    --------------------
    procedure genStub(x ptnod) is
      -- generate the stub for a subprogram
      -- if a Proc/Func, generate the stub into stubText
      -- if a Package, stuff the spec into stubSpec,
      -- the body into stubText
      n ptnod;
      nKind pidl.ptnty; 
      tKind  pidl.ptnty;
      subpName varchar2(100);
      returnVal varchar2(500);
      isPackage boolean;
      saverow varchar2(1800);
    begin
      assert(x is not null);
      n := diana.a_unit_b(x); assert(n is not null);
      tKind := pidl.ptkin(n);
      subpName := pName;  -- assume top-level synonym
      isPackage := false;  stubType := 'SUB'; -- assume subprg, not pkg

      if (tKind = diana.D_P_DECL) then   --package
        -- stubSpec := 'package ' || exprText(diana.a_id(n)) || ' is ';
        -- stubText := 'package body ' || exprText(diana.a_id(n)) || ' is ';
        isPackage := true; stubType := 'PKG';

        if (tsubName is null or tsubName = '') then
          stubSpec := 'package ' || pName || ' is ';
          stubText := 'package body ' || pName || ' is ';
        end if;

        n := diana.a_packag(n);

        declare
          seq pidl.ptseqnd := diana.as_list(diana.as_decl1(n));
          len integer := pidl.ptslen(seq) - 1;
          tmp integer; 
        begin   -- this loop should be factored out with the Describe loop
          for i in 0..len loop -- for each member of the package
            saverow := stubSpec; -- save in case of rollback
            begin
              n := pidl.ptgend(seq, i); assert(n is not null);
              nKind := pidl.ptkin(n);

              if (nKind = diana.D_S_DECL) then  --proc/func
                if (tsubName is null or tsubName = '') then
                  tmp := length(stubText);
                  subpName := null;
                  genProcSpec(n, defValOpt, e_defaultVal,
                              subpName, returnVal, flags, stubText);
                  stubSpec := stubSpec || substr(stubText, tmp+1) 
                                        || '; ';
                  genStubBody(n, pName || '.' || subpName, returnVal);
                else
                  if (procName(n) = tsubName) then
                    subpName := null;
                    exit;
                  end if;
                end if;
              --else
              --  if (tsubName is null or tsubName = '') then
              --    exprText(n, stubSpec);
              --    stubSpec := stubSpec || '; ';
              --  end if;
              end if;
              n := null;
              flushstubs(false);
            exception
              when e_notv6compat 
                then stubSpec := saverow; -- rollback
            end;
          end loop;
        end;

        if (tsubName is null or tsubName = '') then
          stubSpec := stubSpec || ' end;';
          stubText := stubText || 'end;';
        end if;
      end if;

      if (stubSpec is null or stubSpec = '') then
        if (n is null) then
          raise e_notInPackage;
        end if;
        genProcSpec(n, defValOpt, e_defaultVal,
                    subpName, returnVal, flags, stubText);
        if (isPackage) then
          genStubBody(n, pName || '.' || subpName, returnVal);
        else
          genStubBody(n, subpName, returnVal);
        end if;
      end if;
    end genstub;

  begin -- pstub
    status := s_ok;
    stubText := '';
    stubSpec := '';

    char_for_varchar2 := 0 < instr(flags, '6');
    begin
      get_diana(pname, uname, dabaname, dbowner, status, lubptr,
                libunit_type_spec, load_source_no);
      if (lubptr is null or lubptr = 0) then return; end if;
      tSubName := normalName(subname);
      genStub(lubptr);
      if (e_defaultVal) then
        status := s_defaultVal;
      end if;

    exception   -- stubText, stubSpec reset to null
      when value_error then
        status := s_stubTooLong;
      when e_other then
        status := s_other;
      when program_error then
        status := s_logic;
      when e_notInPackage then
        status := s_notInPackage;
      when e_notv6compat then
        status := s_notv6Compat;
      when others then
        status := s_other;
    end;

    flushstubs(true);

  end pstub;


  -----------------------------------------------------------------------
  --     Private implementations
  -----------------------------------------------------------------------


  --------------------
  -- exprText:
  --  General unparsing function
  --------------------
  procedure exprText(x ptnod, rv IN OUT varchar2) is

    --------------------
    -- eText:
    --------------------
    procedure eText(n ptnod);

    --------------------
    -- listText
    --------------------
    procedure listText(seq pidl.ptseqnd, spc varchar2) is
      len integer;
    begin
      len := pidl.ptslen(seq);
      if (len >= 1) then
        eText(pidl.ptgend(seq, 0));
        len := len - 1;
        for i in 1..len loop
          rv := rv || spc;
          eText(pidl.ptgend(seq, i));
        end loop;
      end if;
    end;

    --------------------
    -- eText:
    --------------------
    procedure eText(n ptnod) is
      nKind pidl.ptnty;
    begin
      if (n is not null) then
        nKind := pidl.ptkin(n);

        -- simple expr
        if (nKind = diana.DI_U_NAM or nKind = diana.D_USED_B
        or nKind = diana.DI_U_BLT or nKind = diana.DI_FUNCT
        or nKind = diana.DI_PROC or nKind = diana.DI_PACKA
        or nKind = diana.DI_VAR or nKind = diana.DI_TYPE
        or nKind = diana.DI_SUBTY or nKind = diana.DI_IN
        or nKind = diana.DI_OUT or nKind = diana.DI_IN_OU) then
          rv := rv ||  coatName(diana.l_symrep(n));

        elsif (nKind = diana.D_S_ED) then
          -- x.y
          eText(diana.a_name(n));
          rv := rv || '.';
          eText(diana.a_d_char(n));

        elsif (nKind = diana.D_STRING or nKind = diana.D_USED_C 
        or nKind = diana.D_DEF_OP) then
          rv := rv || '''' || diana.l_symrep(n) || '''';

        elsif (nKind = diana.D_ATTRIB) then
          -- x.y%type
          -- simply add the %type text rather than try to resolve
          -- it to get the name of the type
          --
          eText(diana.a_name(n));
          rv := rv || '%';
          eText(diana.a_id(n));

        elsif (nKind = diana.D_NUMERI) then
          rv := rv ||  diana.l_numrep(n);

        elsif (nKind = diana.D_NULL_A) then
          rv := rv ||  'null';

        /*
        -- 14jul92 =G=> Many of these remaining cases by An work,
        -- but aren't needed.

        -- implicit conversion
        elsif (nKind = diana.D_PARM_C) then
          declare seq pidl.ptseqnd := diana.as_list(diana.as_p_ass(n));
          begin
            eText(last_elt(seq));
          end; 

        -- arglist
        elsif (nKind = diana.DS_APPLY) then
          declare aseq ptnod := diana.as_list(n); begin
            rv := rv || '(';
            listText(aseq, ',');
            rv := rv || ')';
          end;

        -- d_f_call
        elsif (nKind = diana.D_F_CALL) then
          declare args ptnod := diana.as_p_ass(n);
          begin
            if (pidl.ptkin(args) <> diana.DS_PARAM) then
              -- ordinary function call
              eText(diana.a_name(n));
              eText(args);
            else  -- operator functions, determine if unary or n-ary
              declare s pidl.ptseqnd := diana.as_list(args);
                nameNode ptnod := diana.a_name(n);
              begin
                if (pidl.ptslen(s) = 1) then -- unary
                  eText(nameNode);
                  rv := rv || ' ';
                  eText(pidl.ptgend(s, 0));
                else exprText(nameNode, rv); listText(s, rv);
                end if;
              end;
            end if;
          end;

        -- parenthesized expr
        -- whenever this gets uncommented, we must fully support the
        -- D_F_CALL case as well (Usha - 6/28/95)
        elsif (nKind = diana.D_PARENT) then
          rv := rv || '(';
          eText(diana.a_exp(n));
          rv := rv || ')';

        -- binary logical operation
        elsif (nKind = diana.D_BINARY) then
          eText(diana.a_exp1(n));
          rv := rv || ' '; 
          eText(diana.a_binary(n));
          rv := rv || ' '; 
          eText(diana.a_exp2(n));
        elsif (nKind = diana.D_AND_TH) then
          rv := rv || 'and';
        elsif (nKind = diana.D_OR_ELS) then
          rv := rv || 'or';

        elsif (nKind = diana.DS_ID) then  -- idList
          -- listText(diana.as_list(n), ','); causes PL/SQL Check #21037.
          declare seq pidl.ptseqnd := diana.as_list(n);
          begin       
            rv := rv || coatName(diana.l_symrep(last_elt(seq)));
          end;

        elsif (nKind = diana.DS_D_RAN) then
          declare seq pidl.ptseqnd := diana.as_list(n);
            x ptnod;
          begin
            x := last_elt(seq);
            eText(diana.a_name(x));
          end;

        -- declarations
        elsif (nKind = diana.D_VAR or nKind = diana.D_CONSTA) then 
          -- var and const
          eText(diana.as_id(n));
          rv := rv || ' ';
          if (nKind = diana.D_CONSTA) then
            rv := rv || 'constant ';
          end if;
          eText(diana.a_type_s(n));
          if (diana.a_object(n) is not null and diana.a_object(n) <> 0) then
            rv := rv || ' := ';
            eText(diana.a_object(n));
          else assert(nKind <> diana.D_CONSTA);
          end if;

        elsif (nKind = diana.D_CONSTR) then  -- constraint
          eText(diana.a_name(n));
          if (diana.a_constt(n) is not null and diana.a_constt(n) <> 0) then
            rv := rv || ' ';
            eText(diana.a_constt(n));
          end if;
        elsif (nKind = diana.D_INTEGE) then
          eText(diana.a_range(n));
        elsif (nKind = diana.D_RANGE) then
          if (diana.a_exp1(n) is not null and diana.a_exp1(n) <> 0) then
            -- in case of array single index;
            rv := rv || 'range ';
            eText(diana.a_exp1(n));
            rv := rv || '..';
          end if;
          eText(diana.a_exp2(n));

        elsif (nKind = diana.D_TYPE) then -- type declaration
          rv := rv || 'type ';
          eText(diana.a_id(n));
          if (diana.a_type_s(n) is not null and diana.a_type_s(n) <> 0) then
            rv := rv || ' is ';
            eText(diana.a_type_s(n));
          end if;
        elsif (nKind = diana.D_SUBTYP) then -- subtype declaration
          rv := rv || 'subtype ';
          eText(diana.a_id(n));
          rv := rv || ' is ';
          eText(diana.a_constd(n));
        elsif (nKind = diana.D_R_) then -- record type
          rv := rv || 'record (';
          -- listText(diana.as_list(n), ','); causes PL/SQL Check #21037.
          declare seq pidl.ptseqnd := diana.as_list(n);
          begin
            listText(seq, ', ');
          end;
          rv := rv || ')';
        elsif (nKind = diana.D_ARRAY) then
          rv := rv || 'table of ';
          eText(diana.a_name(diana.a_constd(n)));
          rv := rv || '(';
          eText(diana.a_constt(diana.a_constd(n)));
          rv := rv || ') indexed by ';
          eText(diana.as_dscrt(n));
        elsif (nKind = diana.D_EXCEPT) then
          eText(diana.as_id(n));
          rv := rv || ' exception';

        */

        else
          raise e_notv6compat;
        end if;

      end if;
    end eText;

  begin -- exprText
    eText(x);
  end exprText;


  --------------------
  -- is_v6_type
  --
  -- check whether given D_NAME node (from an a_NAME(parm)) names a
  -- v6-compatible type, e.g., DATE, NUMBER, or CHAR
  --------------------
  function is_v6_type (typenode ptnod) return boolean is
    typename varchar2(100);
    percenttype boolean;
  begin
    typename := '';
    exprText(typenode, typename);
    typename := ltrim(rtrim(typename));
    percenttype := ( length(typename) > 5 and 
                    substr(typename, -5, 5) = '%TYPE' );
    /* check length as else will get null as substr result */
    if  (typename = '' or typename is null) or
    not (   typename = 'DATE'
         or typename = 'NUMBER'
         or typename = 'BINARY_INTEGER'
         or typename = 'PLS_INTEGER'
         or typename = 'CHAR'
         or typename = 'VARCHAR2'
         or typename = 'VARCHAR'
         or typename = 'INTEGER'
         or typename = 'BOOLEAN'
         or percenttype 
    --   or typename = 'RAW'
    --   or typename = 'CHARN'
    --   or typename = 'STRING'
    --   or typename = 'STRINGN'
    --   or typename = 'DATEN'
    --   or typename = 'NUMBERN'
    --   or typename = 'PLS_INTEGERN'
    --   or typename = 'NATURAL'
    --   or typename = 'NATURALN'
    --   or typename = 'POSITIVE'
    --   or typename = 'POSITIVEN'
    --   or typename = 'SIGNTYPE'
    --   or typename = 'BOOLEANN'
    --   or typename = 'REAL'
    --   or typename = 'DECIMAL'
    --   or typename = 'FLOAT'
        )
    then
      return false;
    else
      return true;
    end if;
  end is_v6_type;


  --------------------
  -- genProcSpec:
  --  Append the spec for a top-level node n to sText.
  --  defValOption controls whether parm default vals should be ignored,
  --    printed fully or flagged in comments as "DEFAULTED"
  --  hasDefVal returned true iff parm default vals exist.
  --  Toplevel name returned in pName.  If function, function
  --  string returned in returnVal.
  --------------------
  procedure genProcSpec(n ptnod,
                        defValOption number,
                        hasDefVal in out boolean,
                        pName in out varchar2, 
                        returnVal in out varchar2,
                        flags varchar2,
                        sText in out varchar2) is
    nodeKind pidl.ptnty;
    leftChild ptnod;
    rightChild ptnod;
    returnTypeNode ptnod;

    --------------------
    -- genParmText
    --------------------
    procedure genParmText(parmSeq pidl.ptseqnd) is
      -- append text for param list sText
      parmNum natural;
      k ptnod;
      knd pidl.ptnty;
    begin
      parmNum := pidl.ptslen(parmSeq);
      if (parmNum > 0) then
        sText := sText || ' (';
        for i in 1 .. parmNum loop
          k := pidl.ptgend(parmSeq, i-1);
          assert(k is not null);
          sText := sText || idName(diana.as_id(k)) || ' ';
          knd := pidl.ptkin(k);
          if (knd = diana.D_OUT) then
            sText := sText || 'out ';
          elsif (knd = diana.D_IN_OUT) then
            sText := sText || 'in out ';
          else
            assert(knd = diana.D_IN);
          end if;
          exprText(diana.a_name(k), sText);

          if 0 < instr(flags, '6') and not is_v6_type(diana.a_name(k)) then
            raise e_notv6compat;
          end if;

          k := diana.a_exp_vo(k);
          if (k is not null and k <> 0) then
            hasDefVal := TRUE;
            if defValOption = defValOption_full then
              sText := sText || ' := ';
              exprText(k, sText);
            elsif defValOption = defValOption_DEFAULT_comment then
              sText := sText || ' /* DEFAULTED */';
            else
              assert(defValOption = defValOption_ignore);
            end if;
          end if;

          if (i < parmNum) then
            sText := sText || ', ';
          end if;
        end loop;

      sText := sText || ')';
      end if;
    end genParmText;

  begin -- genProcSpec
    -- generate a procedure declaration into sText spec

    returnVal := '';
    assert(n is not null);
    leftChild := diana.a_d_(n);
    assert(leftChild is not null);
    nodeKind := pidl.ptkin(leftChild);

    rightChild := diana.a_header(n);
    if (nodeKind = diana.DI_FUNCT or nodeKind = diana.D_DEF_OP) then
      sText := sText || 'function ';
      returnTypeNode := diana.a_name_v(rightChild);
      exprText(returnTypeNode, returnVal);
      -- ?? returnVal := substr(exprText(diana.a_name_v(rightChild)), 1, 511);
    else
      sText := sText || 'procedure ';
      returnVal := null;
      assert(nodeKind = diana.DI_PROC);
    end if;
    if (pName is null) then
      exprText(leftChild, pName);
    end if;
    sText := sText || pName;

    rightChild := diana.as_p_(rightChild);
    assert(rightChild is not null);
    genParmText(diana.as_list(rightChild));

    if (returnVal is not null) then
      if 0 < instr(flags, '6') and not is_v6_type(returnTypeNode) 
        then raise e_notv6compat;
      end if;
      sText := sText || ' return ' || returnVal;
    end if;
  end genProcSpec;

  --------------------
  -- bool_to_int
  --------------------
  function bool_to_int(b BOOLEAN) return number is
  begin
    if b then
      return 1;
    elsif not b then
      return 0;
    else
      return NULL;
    end if;
  end bool_to_int;

  --------------------
  -- int_to_bool
  --------------------
  function int_to_bool(n NUMBER) return boolean is
  begin
    if n is null then
      return NULL;
    elsif n = 1 then
      return TRUE;
    elsif n = 0 then
      return FALSE;
    else
      raise VALUE_ERROR;
    end if;
  end int_to_bool;

end diutil;
/

grant execute on diutil to public;
