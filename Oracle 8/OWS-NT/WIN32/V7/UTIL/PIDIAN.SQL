rem 
rem $Header: pidian.sql,v 1.6 1992/10/28 18:15:22 PSHAW Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      pidian.sql - <one-line expansion of the name>
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem    RETURNS
Rem 
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem    MODIFIED   (MM/DD/YY)
Rem     pshaw      10/21/92 -  modify script for bug 131187 
Rem     gclossma   05/08/92 -  add L_Q_HINT 
Rem     gclossma   01/14/92 -  remove diana SET-method procedures 
Rem     pdufour    01/03/92 -  remove connect internal and add drop package 
Rem     gclossma   12/02/91 -  make smaller 
Rem     gclossma   12/02/91 -  Creation 
-- NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
-- NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
-- NOTE: you must be connected "internal" (i.e. as user SYS) to run this
-- script.
-- NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
-- NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
-- PIDI : Package Diana

-- MODIFIED
--    gclossma   10/23/91 -  regen via GENIDL.PLS 
--  Clare      03/16/91 - Creation


drop package body sys.diana;
drop package sys.diana;

create package sys.diana is

  D_ABORT    constant pidl.ptnty := 1;
  D_ACCEPT   constant pidl.ptnty := 2;
  D_ACCESS   constant pidl.ptnty := 3;
  D_ADDRES   constant pidl.ptnty := 4;
  D_AGGREG   constant pidl.ptnty := 5;
  D_ALIGNM   constant pidl.ptnty := 6;
  D_ALL      constant pidl.ptnty := 7;
  D_ALLOCA   constant pidl.ptnty := 8;
  D_ALTERN   constant pidl.ptnty := 9;
  D_AND_TH   constant pidl.ptnty := 10;
  D_APPLY    constant pidl.ptnty := 11;
  D_ARRAY    constant pidl.ptnty := 12;
  D_ASSIGN   constant pidl.ptnty := 13;
  D_ASSOC    constant pidl.ptnty := 14;
  D_ATTRIB   constant pidl.ptnty := 15;
  D_BINARY   constant pidl.ptnty := 16;
  D_BLOCK    constant pidl.ptnty := 17;
  D_BOX      constant pidl.ptnty := 18;
  D_C_ATTR   constant pidl.ptnty := 19;
  D_CASE     constant pidl.ptnty := 20;
  D_CODE     constant pidl.ptnty := 21;
  D_COMP_R   constant pidl.ptnty := 22;
  D_COMP_U   constant pidl.ptnty := 23;
  D_COMPIL   constant pidl.ptnty := 24;
  D_COND_C   constant pidl.ptnty := 25;
  D_COND_E   constant pidl.ptnty := 26;
  D_CONSTA   constant pidl.ptnty := 27;
  D_CONSTR   constant pidl.ptnty := 28;
  D_CONTEX   constant pidl.ptnty := 29;
  D_CONVER   constant pidl.ptnty := 30;
  D_D_AGGR   constant pidl.ptnty := 31;
  D_D_VAR    constant pidl.ptnty := 32;
  D_DECL     constant pidl.ptnty := 33;
  D_DEF_CH   constant pidl.ptnty := 34;
  D_DEF_OP   constant pidl.ptnty := 35;
  D_DEFERR   constant pidl.ptnty := 36;
  D_DELAY    constant pidl.ptnty := 37;
  D_DERIVE   constant pidl.ptnty := 38;
  D_ENTRY    constant pidl.ptnty := 39;
  D_ENTRY_   constant pidl.ptnty := 40;
  D_ERROR    constant pidl.ptnty := 41;
  D_EXCEPT   constant pidl.ptnty := 42;
  D_EXIT     constant pidl.ptnty := 43;
  D_F_       constant pidl.ptnty := 44;
  D_F_BODY   constant pidl.ptnty := 45;
  D_F_CALL   constant pidl.ptnty := 46;
  D_F_DECL   constant pidl.ptnty := 47;
  D_F_DSCR   constant pidl.ptnty := 48;
  D_F_FIXE   constant pidl.ptnty := 49;
  D_F_FLOA   constant pidl.ptnty := 50;
  D_F_INTE   constant pidl.ptnty := 51;
  D_F_SPEC   constant pidl.ptnty := 52;
  D_FIXED    constant pidl.ptnty := 53;
  D_FLOAT    constant pidl.ptnty := 54;
  D_FOR      constant pidl.ptnty := 55;
  D_FORM     constant pidl.ptnty := 56;
  D_FORM_C   constant pidl.ptnty := 57;
  D_GENERI   constant pidl.ptnty := 58;
  D_GOTO     constant pidl.ptnty := 59;
  D_IF       constant pidl.ptnty := 60;
  D_IN       constant pidl.ptnty := 61;
  D_IN_OP    constant pidl.ptnty := 62;
  D_IN_OUT   constant pidl.ptnty := 63;
  D_INDEX    constant pidl.ptnty := 64;
  D_INDEXE   constant pidl.ptnty := 65;
  D_INNER_   constant pidl.ptnty := 66;
  D_INSTAN   constant pidl.ptnty := 67;
  D_INTEGE   constant pidl.ptnty := 68;
  D_L_PRIV   constant pidl.ptnty := 69;
  D_LABELE   constant pidl.ptnty := 70;
  D_LOOP     constant pidl.ptnty := 71;
  D_MEMBER   constant pidl.ptnty := 72;
  D_NAMED    constant pidl.ptnty := 73;
  D_NAMED_   constant pidl.ptnty := 74;
  D_NO_DEF   constant pidl.ptnty := 75;
  D_NOT_IN   constant pidl.ptnty := 76;
  D_NULL_A   constant pidl.ptnty := 77;
  D_NULL_C   constant pidl.ptnty := 78;
  D_NULL_S   constant pidl.ptnty := 79;
  D_NUMBER   constant pidl.ptnty := 80;
  D_NUMERI   constant pidl.ptnty := 81;
  D_OR_ELS   constant pidl.ptnty := 82;
  D_OTHERS   constant pidl.ptnty := 83;
  D_OUT      constant pidl.ptnty := 84;
  D_P_       constant pidl.ptnty := 85;
  D_P_BODY   constant pidl.ptnty := 86;
  D_P_CALL   constant pidl.ptnty := 87;
  D_P_DECL   constant pidl.ptnty := 88;
  D_P_SPEC   constant pidl.ptnty := 89;
  D_PARENT   constant pidl.ptnty := 90;
  D_PARM_C   constant pidl.ptnty := 91;
  D_PARM_F   constant pidl.ptnty := 92;
  D_PRAGMA   constant pidl.ptnty := 93;
  D_PRIVAT   constant pidl.ptnty := 94;
  D_QUALIF   constant pidl.ptnty := 95;
  D_R_       constant pidl.ptnty := 96;
  D_R_REP    constant pidl.ptnty := 97;
  D_RAISE    constant pidl.ptnty := 98;
  D_RANGE    constant pidl.ptnty := 99;
  D_RENAME   constant pidl.ptnty := 100;
  D_RETURN   constant pidl.ptnty := 101;
  D_REVERS   constant pidl.ptnty := 102;
  D_S_       constant pidl.ptnty := 103;
  D_S_BODY   constant pidl.ptnty := 104;
  D_S_CLAU   constant pidl.ptnty := 105;
  D_S_DECL   constant pidl.ptnty := 106;
  D_S_ED     constant pidl.ptnty := 107;
  D_SIMPLE   constant pidl.ptnty := 108;
  D_SLICE    constant pidl.ptnty := 109;
  D_STRING   constant pidl.ptnty := 110;
  D_STUB     constant pidl.ptnty := 111;
  D_SUBTYP   constant pidl.ptnty := 112;
  D_SUBUNI   constant pidl.ptnty := 113;
  D_T_BODY   constant pidl.ptnty := 114;
  D_T_DECL   constant pidl.ptnty := 115;
  D_T_SPEC   constant pidl.ptnty := 116;
  D_TERMIN   constant pidl.ptnty := 117;
  D_TIMED_   constant pidl.ptnty := 118;
  D_TYPE     constant pidl.ptnty := 119;
  D_U_FIXE   constant pidl.ptnty := 120;
  D_U_INTE   constant pidl.ptnty := 121;
  D_U_REAL   constant pidl.ptnty := 122;
  D_USE      constant pidl.ptnty := 123;
  D_USED_B   constant pidl.ptnty := 124;
  D_USED_C   constant pidl.ptnty := 125;
  D_USED_O   constant pidl.ptnty := 126;
  D_V_       constant pidl.ptnty := 127;
  D_V_PART   constant pidl.ptnty := 128;
  D_VAR      constant pidl.ptnty := 129;
  D_WHILE    constant pidl.ptnty := 130;
  D_WITH     constant pidl.ptnty := 131;
  DI_ARGUM   constant pidl.ptnty := 132;
  DI_ATTR_   constant pidl.ptnty := 133;
  DI_COMP_   constant pidl.ptnty := 134;
  DI_CONST   constant pidl.ptnty := 135;
  DI_DSCRM   constant pidl.ptnty := 136;
  DI_ENTRY   constant pidl.ptnty := 137;
  DI_ENUM    constant pidl.ptnty := 138;
  DI_EXCEP   constant pidl.ptnty := 139;
  DI_FORM    constant pidl.ptnty := 140;
  DI_FUNCT   constant pidl.ptnty := 141;
  DI_GENER   constant pidl.ptnty := 142;
  DI_IN      constant pidl.ptnty := 143;
  DI_IN_OU   constant pidl.ptnty := 144;
  DI_ITERA   constant pidl.ptnty := 145;
  DI_L_PRI   constant pidl.ptnty := 146;
  DI_LABEL   constant pidl.ptnty := 147;
  DI_NAMED   constant pidl.ptnty := 148;
  DI_NUMBE   constant pidl.ptnty := 149;
  DI_OUT     constant pidl.ptnty := 150;
  DI_PACKA   constant pidl.ptnty := 151;
  DI_PRAGM   constant pidl.ptnty := 152;
  DI_PRIVA   constant pidl.ptnty := 153;
  DI_PROC    constant pidl.ptnty := 154;
  DI_SUBTY   constant pidl.ptnty := 155;
  DI_TASK_   constant pidl.ptnty := 156;
  DI_TYPE    constant pidl.ptnty := 157;
  DI_U_ALY   constant pidl.ptnty := 158;
  DI_U_BLT   constant pidl.ptnty := 159;
  DI_U_NAM   constant pidl.ptnty := 160;
  DI_U_OBJ   constant pidl.ptnty := 161;
  DI_USER    constant pidl.ptnty := 162;
  DI_VAR     constant pidl.ptnty := 163;
  DS_ALTER   constant pidl.ptnty := 164;
  DS_APPLY   constant pidl.ptnty := 165;
  DS_CHOIC   constant pidl.ptnty := 166;
  DS_COMP_   constant pidl.ptnty := 167;
  DS_D_RAN   constant pidl.ptnty := 168;
  DS_D_VAR   constant pidl.ptnty := 169;
  DS_DECL    constant pidl.ptnty := 170;
  DS_ENUM_   constant pidl.ptnty := 171;
  DS_EXP     constant pidl.ptnty := 172;
  DS_FORUP   constant pidl.ptnty := 173;
  DS_G_ASS   constant pidl.ptnty := 174;
  DS_G_PAR   constant pidl.ptnty := 175;
  DS_ID      constant pidl.ptnty := 176;
  DS_ITEM    constant pidl.ptnty := 177;
  DS_NAME    constant pidl.ptnty := 178;
  DS_P_ASS   constant pidl.ptnty := 179;
  DS_PARAM   constant pidl.ptnty := 180;
  DS_PRAGM   constant pidl.ptnty := 181;
  DS_SELEC   constant pidl.ptnty := 182;
  DS_STM     constant pidl.ptnty := 183;
  DS_UPDNW   constant pidl.ptnty := 184;
  Q_ALIAS_   constant pidl.ptnty := 185;
  Q_AT_STM   constant pidl.ptnty := 186;
  Q_BINARY   constant pidl.ptnty := 187;
  Q_BIND     constant pidl.ptnty := 188;
  Q_C_BODY   constant pidl.ptnty := 189;
  Q_C_CALL   constant pidl.ptnty := 190;
  Q_C_DECL   constant pidl.ptnty := 191;
  Q_CHAR     constant pidl.ptnty := 192;
  Q_CLOSE_   constant pidl.ptnty := 193;
  Q_CLUSTE   constant pidl.ptnty := 194;
  Q_COMMIT   constant pidl.ptnty := 195;
  Q_COMMNT   constant pidl.ptnty := 196;
  Q_CONNEC   constant pidl.ptnty := 197;
  Q_CREATE   constant pidl.ptnty := 198;
  Q_CURREN   constant pidl.ptnty := 199;
  Q_CURSOR   constant pidl.ptnty := 200;
  Q_DATABA   constant pidl.ptnty := 201;
  Q_DATE     constant pidl.ptnty := 202;
  Q_DB_COM   constant pidl.ptnty := 203;
  Q_DECIMA   constant pidl.ptnty := 204;
  Q_DELETE   constant pidl.ptnty := 205;
  Q_DICTIO   constant pidl.ptnty := 206;
  Q_DROP_S   constant pidl.ptnty := 207;
  Q_EXP      constant pidl.ptnty := 208;
  Q_EXPR_S   constant pidl.ptnty := 209;
  Q_F_CALL   constant pidl.ptnty := 210;
  Q_FETCH_   constant pidl.ptnty := 211;
  Q_FLOAT    constant pidl.ptnty := 212;
  Q_FRCTRN   constant pidl.ptnty := 213;
  Q_GENSQL   constant pidl.ptnty := 214;
  Q_INSERT   constant pidl.ptnty := 215;
  Q_LEVEL    constant pidl.ptnty := 216;
  Q_LINK     constant pidl.ptnty := 217;
  Q_LOCK_T   constant pidl.ptnty := 218;
  Q_LONG_V   constant pidl.ptnty := 219;
  Q_NUMBER   constant pidl.ptnty := 220;
  Q_OPEN_S   constant pidl.ptnty := 221;
  Q_ORDER_   constant pidl.ptnty := 222;
  Q_RLLBCK   constant pidl.ptnty := 223;
  Q_ROLLBA   constant pidl.ptnty := 224;
  Q_ROWNUM   constant pidl.ptnty := 225;
  Q_S_TYPE   constant pidl.ptnty := 226;
  Q_SAVEPO   constant pidl.ptnty := 227;
  Q_SCHEMA   constant pidl.ptnty := 228;
  Q_SELECT   constant pidl.ptnty := 229;
  Q_SEQUE    constant pidl.ptnty := 230;
  Q_SET_CL   constant pidl.ptnty := 231;
  Q_SMALLI   constant pidl.ptnty := 232;
  Q_SQL_ST   constant pidl.ptnty := 233;
  Q_STATEM   constant pidl.ptnty := 234;
  Q_SUBQUE   constant pidl.ptnty := 235;
  Q_SYNON    constant pidl.ptnty := 236;
  Q_TABLE    constant pidl.ptnty := 237;
  Q_TBL_EX   constant pidl.ptnty := 238;
  Q_UPDATE   constant pidl.ptnty := 239;
  Q_VAR      constant pidl.ptnty := 240;
  Q_VARCHA   constant pidl.ptnty := 241;
  Q_VIEW     constant pidl.ptnty := 242;
  QI_BIND_   constant pidl.ptnty := 243;
  QI_CURSO   constant pidl.ptnty := 244;
  QI_DATAB   constant pidl.ptnty := 245;
  QI_SCHEM   constant pidl.ptnty := 246;
  QI_TABLE   constant pidl.ptnty := 247;
  QS_AGGR    constant pidl.ptnty := 248;
  QS_SET_C   constant pidl.ptnty := 249;


  function  a_ACTUAL(node pidl.ptnod) return pidl.ptnod;

  function  a_ALIGNM(node pidl.ptnod) return pidl.ptnod;

  function  a_BINARY(node pidl.ptnod) return pidl.ptnod;

  function  a_BLOCK_(node pidl.ptnod) return pidl.ptnod;

  function  a_CLUSTE(node pidl.ptnod) return pidl.ptnod;

  function  a_CONNEC(node pidl.ptnod) return pidl.ptnod;

  function  a_CONSTD(node pidl.ptnod) return pidl.ptnod;

  function  a_CONSTT(node pidl.ptnod) return pidl.ptnod;

  function  a_CONTEX(node pidl.ptnod) return pidl.ptnod;

  function  a_D_(node pidl.ptnod) return pidl.ptnod;

  function  a_D_CHAR(node pidl.ptnod) return pidl.ptnod;

  function  a_D_R_(node pidl.ptnod) return pidl.ptnod;

  function  a_D_R_VO(node pidl.ptnod) return pidl.ptnod;

  function  a_EXCEPT(node pidl.ptnod) return pidl.ptnod;

  function  a_EXP(node pidl.ptnod) return pidl.ptnod;

  function  a_EXP1(node pidl.ptnod) return pidl.ptnod;

  function  a_EXP2(node pidl.ptnod) return pidl.ptnod;

  function  a_EXP_VO(node pidl.ptnod) return pidl.ptnod;

  function  a_FORM_D(node pidl.ptnod) return pidl.ptnod;

  function  a_HAVING(node pidl.ptnod) return pidl.ptnod;

  function  a_HEADER(node pidl.ptnod) return pidl.ptnod;

  function  a_ID(node pidl.ptnod) return pidl.ptnod;

  function  a_INDICA(node pidl.ptnod) return pidl.ptnod;

  function  a_ITERAT(node pidl.ptnod) return pidl.ptnod;

  function  a_MEMBER(node pidl.ptnod) return pidl.ptnod;

  function  a_NAME(node pidl.ptnod) return pidl.ptnod;

  function  a_NAME_V(node pidl.ptnod) return pidl.ptnod;

  function  a_NOT_NU(node pidl.ptnod) return pidl.ub2;

  function  a_OBJECT(node pidl.ptnod) return pidl.ptnod;

  function  a_P_IFC(node pidl.ptnod) return pidl.ptnod;

  function  a_PACKAG(node pidl.ptnod) return pidl.ptnod;

  function  a_RANGE(node pidl.ptnod) return pidl.ptnod;

  function  a_SPACE(node pidl.ptnod) return pidl.ptnod;

  function  a_STM(node pidl.ptnod) return pidl.ptnod;

  function  a_SUBPRO(node pidl.ptnod) return pidl.ptnod;

  function  a_SUBUNI(node pidl.ptnod) return pidl.ptnod;

  function  a_TRANS(node pidl.ptnod) return pidl.ptnod;

  function  a_TYPE_R(node pidl.ptnod) return pidl.ptnod;

  function  a_TYPE_S(node pidl.ptnod) return pidl.ptnod;

  function  a_UNIT_B(node pidl.ptnod) return pidl.ptnod;

  function  a_UP(node pidl.ptnod) return pidl.ptnod;

  function  a_WHERE(node pidl.ptnod) return pidl.ptnod;

  function  as_ALTER(node pidl.ptnod) return pidl.ptnod;

  function  as_APPLY(node pidl.ptnod) return pidl.ptnod;

  function  as_CHOIC(node pidl.ptnod) return pidl.ptnod;

  function  as_COMP_(node pidl.ptnod) return pidl.ptnod;

  function  as_DECL1(node pidl.ptnod) return pidl.ptnod;

  function  as_DECL2(node pidl.ptnod) return pidl.ptnod;

  function  as_DSCRM(node pidl.ptnod) return pidl.ptnod;

  function  as_DSCRT(node pidl.ptnod) return pidl.ptnod;

  function  as_EXP(node pidl.ptnod) return pidl.ptnod;

  function  as_FROM(node pidl.ptnod) return pidl.ptnod;

  function  as_GROUP(node pidl.ptnod) return pidl.ptnod;

  function  as_ID(node pidl.ptnod) return pidl.ptnod;

  function  as_INTO_(node pidl.ptnod) return pidl.ptnod;

  function  as_ITEM(node pidl.ptnod) return pidl.ptnod;

  function  as_LIST(node pidl.ptnod) return pidl.ptseqnd;

  function  as_NAME(node pidl.ptnod) return pidl.ptnod;

  function  as_ORDER(node pidl.ptnod) return pidl.ptnod;

  function  as_P_(node pidl.ptnod) return pidl.ptnod;

  function  as_P_ASS(node pidl.ptnod) return pidl.ptnod;

  function  as_PRAGM(node pidl.ptnod) return pidl.ptnod;

  function  as_SET_C(node pidl.ptnod) return pidl.ptnod;

  function  as_STM(node pidl.ptnod) return pidl.ptnod;

  function  c_ENTRY_(node pidl.ptnod) return pidl.byte4;

  function  c_FIXUP(node pidl.ptnod) return pidl.ptr_t;

  function  c_FRAME_(node pidl.ptnod) return pidl.ub4;

  function  c_LABEL(node pidl.ptnod) return pidl.ub4;

  function  c_OFFSET(node pidl.ptnod) return pidl.byte4;

  function  c_VAR(node pidl.ptnod) return pidl.ptr_t;

  function  l_DEFAUL(node pidl.ptnod) return pidl.ub4;

  function  l_INDREP(node pidl.ptnod) return varchar2;

  function  l_NUMREP(node pidl.ptnod) return varchar2;

  function  l_Q_HINT(node pidl.ptnod) return varchar2;

  function  l_SYMREP(node pidl.ptnod) return varchar2;

  function  s_ADDRES(node pidl.ptnod) return pidl.sb4;

  function  s_ADEFN(node pidl.ptnod) return pidl.ptnod;

  function  s_BASE_T(node pidl.ptnod) return pidl.ptnod;

  function  s_BLOCK(node pidl.ptnod) return pidl.ptnod;

  function  s_BODY(node pidl.ptnod) return pidl.ptnod;

  function  s_COMP_S(node pidl.ptnod) return pidl.ptnod;

  function  s_CONSTR(node pidl.ptnod) return pidl.ptnod;

  function  s_DEFN(node pidl.ptnod) return pidl.ptnod;

  function  s_DISCRI(node pidl.ptnod) return pidl.ptnod;

  function  s_EXCEPT(node pidl.ptnod) return pidl.ptnod;

  function  s_EXP_TY(node pidl.ptnod) return pidl.ptnod;

  function  s_FIRST(node pidl.ptnod) return pidl.ptnod;

  function  s_FRAME(node pidl.ptnod) return pidl.ptnod;

  function  s_IN_OUT(node pidl.ptnod) return pidl.ub4;

  function  s_INIT_E(node pidl.ptnod) return pidl.ptnod;

  function  s_INTERF(node pidl.ptnod) return pidl.ptnod;

  function  s_LAYER(node pidl.ptnod) return pidl.sb4;

  function  s_LOCATI(node pidl.ptnod) return pidl.sb4;

  function  s_NORMAL(node pidl.ptnod) return pidl.ptnod;

  function  s_NOT_NU(node pidl.ptnod) return pidl.ub2;

  function  s_OBJ_DE(node pidl.ptnod) return pidl.ptnod;

  function  s_OBJ_TY(node pidl.ptnod) return pidl.ptnod;

  function  s_OPERAT(node pidl.ptnod) return pidl.ub4;

  function  s_PACKIN(node pidl.ptnod) return pidl.ptnod;

  function  s_POS(node pidl.ptnod) return pidl.ub4;

  function  s_RECORD(node pidl.ptnod) return pidl.ptnod;

  function  s_REP(node pidl.ptnod) return pidl.ub4;

  function  s_SCOPE(node pidl.ptnod) return pidl.ptnod;

  function  s_SIZE(node pidl.ptnod) return pidl.ptnod;

  function  s_SPEC(node pidl.ptnod) return pidl.ptnod;

  function  s_STM(node pidl.ptnod) return pidl.ptnod;

  function  s_STUB(node pidl.ptnod) return pidl.ptnod;

  function  s_T_SPEC(node pidl.ptnod) return pidl.ptnod;

  function  s_T_STRU(node pidl.ptnod) return pidl.ptnod;

  function  s_VALUE(node pidl.ptnod) return pidl.ub2;

  function  ss_BINDS(node pidl.ptnod) return pidl.ptseqnd;

  function  ss_BUCKE(node pidl.ptnod) return pidl.ptr_t;

  function  ss_EXLST(node pidl.ptnod) return pidl.ptseqnd;

  function  ss_SQL(node pidl.ptnod) return pidl.ptseqnd;

end diana;
/
create package body sys.diana is

  function  a_ACTUAL(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,1);
  end;

  function  a_ALIGNM(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,2);
  end;

  function  a_BINARY(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,3);
  end;

  function  a_BLOCK_(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,4);
  end;

  function  a_CLUSTE(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,5);
  end;

  function  a_CONNEC(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,6);
  end;

  function  a_CONSTD(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,7);
  end;

  function  a_CONSTT(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,8);
  end;

  function  a_CONTEX(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,9);
  end;

  function  a_D_(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,10);
  end;

  function  a_D_CHAR(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,11);
  end;

  function  a_D_R_(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,12);
  end;

  function  a_D_R_VO(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,13);
  end;

  function  a_EXCEPT(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,14);
  end;

  function  a_EXP(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,15);
  end;

  function  a_EXP1(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,16);
  end;

  function  a_EXP2(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,17);
  end;

  function  a_EXP_VO(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,18);
  end;

  function  a_FORM_D(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,19);
  end;

  function  a_HAVING(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,20);
  end;

  function  a_HEADER(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,21);
  end;

  function  a_ID(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,22);
  end;

  function  a_INDICA(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,23);
  end;

  function  a_ITERAT(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,24);
  end;

  function  a_MEMBER(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,25);
  end;

  function  a_NAME(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,26);
  end;

  function  a_NAME_V(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,27);
  end;

  function  a_NOT_NU(node pidl.ptnod) return pidl.ub2 is
  begin
    return pidl.ptg_u2(node,28);
  end;

  function  a_OBJECT(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,29);
  end;

  function  a_P_IFC(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,30);
  end;

  function  a_PACKAG(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,31);
  end;

  function  a_RANGE(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,32);
  end;

  function  a_SPACE(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,33);
  end;

  function  a_STM(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,34);
  end;

  function  a_SUBPRO(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,35);
  end;

  function  a_SUBUNI(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,36);
  end;

  function  a_TRANS(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,37);
  end;

  function  a_TYPE_R(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,38);
  end;

  function  a_TYPE_S(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,39);
  end;

  function  a_UNIT_B(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,40);
  end;

  function  a_UP(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,41);
  end;

  function  a_WHERE(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,42);
  end;

  function  as_ALTER(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,43);
  end;

  function  as_APPLY(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,44);
  end;

  function  as_CHOIC(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,45);
  end;

  function  as_COMP_(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,46);
  end;

  function  as_DECL1(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,47);
  end;

  function  as_DECL2(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,48);
  end;

  function  as_DSCRM(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,49);
  end;

  function  as_DSCRT(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,50);
  end;

  function  as_EXP(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,51);
  end;

  function  as_FROM(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,52);
  end;

  function  as_GROUP(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,53);
  end;

  function  as_ID(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,54);
  end;

  function  as_INTO_(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,55);
  end;

  function  as_ITEM(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,56);
  end;

  function  as_LIST(node pidl.ptnod) return pidl.ptseqnd is
  begin
    return pidl.ptgsnd(node,57);
  end;

  function  as_NAME(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,58);
  end;

  function  as_ORDER(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,59);
  end;

  function  as_P_(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,60);
  end;

  function  as_P_ASS(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,61);
  end;

  function  as_PRAGM(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,62);
  end;

  function  as_SET_C(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,63);
  end;

  function  as_STM(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,64);
  end;

  function  c_ENTRY_(node pidl.ptnod) return pidl.byte4 is
  begin
    return pidl.ptg_b4(node,65);
  end;

  function  c_FIXUP(node pidl.ptnod) return pidl.ptr_t is
  begin
    return pidl.ptg_pt(node,66);
  end;

  function  c_FRAME_(node pidl.ptnod) return pidl.ub4 is
  begin
    return pidl.ptg_u4(node,67);
  end;

  function  c_LABEL(node pidl.ptnod) return pidl.ub4 is
  begin
    return pidl.ptg_u4(node,68);
  end;

  function  c_OFFSET(node pidl.ptnod) return pidl.byte4 is
  begin
    return pidl.ptg_b4(node,69);
  end;

  function  c_VAR(node pidl.ptnod) return pidl.ptr_t is
  begin
    return pidl.ptg_pt(node,70);
  end;

  function  l_DEFAUL(node pidl.ptnod) return pidl.ub4 is
  begin
    return pidl.ptg_u4(node,71);
  end;

  function  l_INDREP(node pidl.ptnod) return varchar2 is
  begin
    return pidl.ptg_tx(node,72);
  end;

  function  l_NUMREP(node pidl.ptnod) return varchar2 is
  begin
    return pidl.ptg_tx(node,73);
  end;

  function  l_Q_HINT(node pidl.ptnod) return varchar2 is
  begin
    return pidl.ptg_tx(node,74);
  end;

  function  l_SYMREP(node pidl.ptnod) return varchar2 is
  begin
    return pidl.ptg_tx(node,75);
  end;

  function  s_ADDRES(node pidl.ptnod) return pidl.sb4 is
  begin
    return pidl.ptg_s4(node,76);
  end;

  function  s_ADEFN(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,77);
  end;

  function  s_BASE_T(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,78);
  end;

  function  s_BLOCK(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,79);
  end;

  function  s_BODY(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,80);
  end;

  function  s_COMP_S(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,81);
  end;

  function  s_CONSTR(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,82);
  end;

  function  s_DEFN(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,83);
  end;

  function  s_DISCRI(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,84);
  end;

  function  s_EXCEPT(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,85);
  end;

  function  s_EXP_TY(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,86);
  end;

  function  s_FIRST(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,87);
  end;

  function  s_FRAME(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,88);
  end;

  function  s_IN_OUT(node pidl.ptnod) return pidl.ub4 is
  begin
    return pidl.ptg_u4(node,89);
  end;

  function  s_INIT_E(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,90);
  end;

  function  s_INTERF(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,91);
  end;

  function  s_LAYER(node pidl.ptnod) return pidl.sb4 is
  begin
    return pidl.ptg_s4(node,92);
  end;

  function  s_LOCATI(node pidl.ptnod) return pidl.sb4 is
  begin
    return pidl.ptg_s4(node,93);
  end;

  function  s_NORMAL(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,94);
  end;

  function  s_NOT_NU(node pidl.ptnod) return pidl.ub2 is
  begin
    return pidl.ptg_u2(node,95);
  end;

  function  s_OBJ_DE(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,96);
  end;

  function  s_OBJ_TY(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,97);
  end;

  function  s_OPERAT(node pidl.ptnod) return pidl.ub4 is
  begin
    return pidl.ptg_u4(node,98);
  end;

  function  s_PACKIN(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,99);
  end;

  function  s_POS(node pidl.ptnod) return pidl.ub4 is
  begin
    return pidl.ptg_u4(node,100);
  end;

  function  s_RECORD(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,101);
  end;

  function  s_REP(node pidl.ptnod) return pidl.ub4 is
  begin
    return pidl.ptg_u4(node,102);
  end;

  function  s_SCOPE(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,103);
  end;

  function  s_SIZE(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,104);
  end;

  function  s_SPEC(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,105);
  end;

  function  s_STM(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,106);
  end;

  function  s_STUB(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,107);
  end;

  function  s_T_SPEC(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,108);
  end;

  function  s_T_STRU(node pidl.ptnod) return pidl.ptnod is
  begin
    return pidl.ptg_nd(node,109);
  end;

  function  s_VALUE(node pidl.ptnod) return pidl.ub2 is
  begin
    return pidl.ptg_u2(node,110);
  end;

  function  ss_BINDS(node pidl.ptnod) return pidl.ptseqnd is
  begin
    return pidl.ptgsnd(node,111);
  end;

  function  ss_BUCKE(node pidl.ptnod) return pidl.ptr_t is
  begin
    return pidl.ptg_pt(node,112);
  end;

  function  ss_EXLST(node pidl.ptnod) return pidl.ptseqnd is
  begin
    return pidl.ptgsnd(node,113);
  end;

  function  ss_SQL(node pidl.ptnod) return pidl.ptseqnd is
  begin
    return pidl.ptgsnd(node,114);
  end;

end diana;
/