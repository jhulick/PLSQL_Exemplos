REM
REM $Header$                                                                 *
REM
 
REM Copyright (c) Oracle Corporation Canada Inc. 1992,1995 All Right Reserved.
  
REM
REM NAME:
REM    md_wex - MultiDimension Window EXtract package
REM DESCRIPTION:
REM    This package encapsulate the logic required to extract data from an
REM    md table.  Two target type are supported - TABLE or VIEW.
REM    A table target implies that an MD table is created and the target
REM    set is copied into that target. A view target creates a view that
REM    returns the result set.
REM PRIVATE FUNCTIONS:
REM PUBLIC FUNCTIONS:
REM    reset_globals
REM    set_target_type
REM    set_hhcode_type
REM    set_sql_filter
REM    set_storage_clause
REM    set_dimension_list
REM    set_range_window
REM    set_proximity_window
REM    set_polygon_window
REM    extract
REM    drop_target
REM
REM NOTES:
REM
REM MODIFIED     (DD-MON-YY)  DESCRIPTION
REM pvretano      15-AUG-95   Add this header
REM pvretano      11-AUG-95   Add DROP_TARGET function
REM pvretano      09-APR-95   Split spec and body of MD_WEX.
REM cgoyette      14-NOV-94   Creation
REM

create or replace package md_wex as

   procedure reset_globals;

   procedure set_target_type( type varchar2 );

   procedure set_hhcode_type ( hht varchar2 );

   procedure set_sql_filter( sqlf varchar2 );

   procedure set_storage_clause ( strg varchar2 );

   procedure set_dimension_list ( d1 integer  := null, d2 integer  := null,
                                  d3 integer  := null, d4 integer  := null,
                                  d5 integer  := null, d6 integer  := null,
                                  d7 integer  := null, d8 integer  := null,
                                  d9 integer  := null, d10 integer := null,
                                  d11 integer := null, d12 integer := null,
                                  d13 integer := null, d14 integer := null,
                                  d15 integer := null, d16 integer := null,
                                  d17 integer := null, d18 integer := null,
                                  d19 integer := null, d20 integer := null,
                                  d21 integer := null, d22 integer := null,
                                  d23 integer := null, d24 integer := null,
                                  d25 integer := null, d26 integer := null,
                                  d27 integer := null, d28 integer := null,
                                  d29 integer := null, d30 integer := null,
                                  d31 integer := null, d32 integer := null);

   procedure set_range_window ( lb1 number := null, ub1 number := null,
                                lb2 number := null, ub2 number := null,
                                lb3 number := null, ub3 number := null,
                                lb4 number := null, ub4 number := null,
                                lb5 number := null, ub5 number := null,
                                lb6 number := null, ub6 number := null,
                                lb7 number := null, ub7 number := null,
                                lb8 number := null, ub8 number := null,
                                lb9 number := null, ub9 number := null,
                                lb10 number := null, ub10 number := null,
                                lb11 number := null, ub11 number := null,
                                lb12 number := null, ub12 number := null,
                                lb13 number := null, ub13 number := null,
                                lb14 number := null, ub14 number := null,
                                lb15 number := null, ub15 number := null,
                                lb16 number := null, ub16 number := null,
                                lb17 number := null, ub17 number := null,
                                lb18 number := null, ub18 number := null,
                                lb19 number := null, ub19 number := null,
                                lb20 number := null, ub20 number := null,
                                lb21 number := null, ub21 number := null,
                                lb22 number := null, ub22 number := null,
                                lb23 number := null, ub23 number := null,
                                lb24 number := null, ub24 number := null,
                                lb25 number := null, ub25 number := null,
                                lb26 number := null, ub26 number := null,
                                lb27 number := null, ub27 number := null,
                                lb28 number := null, ub28 number := null,
                                lb29 number := null, ub29 number := null,
                                lb30 number := null, ub30 number := null,
                                lb31 number := null, ub31 number := null,
                                lb32 number := null, ub32 number := null);

   procedure set_proximity_window ( x1 number := null, x2 number := null,
                                    x3 number := null, x4 number := null,
                                    x5 number := null, x6 number := null,
                                    x7 number := null, x8 number := null,
                                    x9 number := null, x10 number := null,
                                    x11 number := null, x12 number := null,
                                    x13 number := null, x14 number := null,
                                    x16 number := null, x15 number := null,
                                    x17 number := null, x18 number := null,
                                    x19 number := null, x20 number := null,
                                    x21 number := null, x22 number := null,
                                    x23 number := null, x24 number := null,
                                    x25 number := null, x26 number := null,
                                    x27 number := null, x28 number := null,
                                    x29 number := null, x30 number := null,
                                    x31 number := null, x32 number := null,
                                    x33 number := null);

   procedure set_polygon_window ( x1 number := null, y1 number := null,
                                  x2 number := null, y2 number := null,
                                  x3 number := null, y3 number := null,
                                  x4 number := null, y4 number := null,
                                  x5 number := null, y5 number := null,
                                  x6 number := null, y6 number := null,
                                  x7 number := null, y7 number := null,
                                  x8 number := null, y8 number := null,
                                  x9 number := null, y9 number := null,
                                  x10 number := null, y10 number := null,
                                  x11 number := null, y11 number := null,
                                  x12 number := null, y12 number := null,
                                  x13 number := null, y13 number := null,
                                  x14 number := null, y14 number := null,
                                  x15 number := null, y15 number := null,
                                  x16 number := null, y16 number := null,
                                  x17 number := null, y17 number := null,
                                  x18 number := null, y18 number := null,
                                  x19 number := null, y19 number := null,
                                  x20 number := null, y20 number := null,
                                  x21 number := null, y21 number := null,
                                  x22 number := null, y22 number := null,
                                  x23 number := null, y23 number := null,
                                  x24 number := null, y24 number := null,
                                  x25 number := null, y25 number := null,
                                  x26 number := null, y26 number := null,
                                  x27 number := null, y27 number := null,
                                  x28 number := null, y28 number := null,
                                  x29 number := null, y29 number := null,
                                  x30 number := null, y30 number := null,
                                  x31 number := null, y31 number := null,
                                  x32 number := null, y32 number := null,
                                  x33 number := null, y33 number := null,
                                  x34 number := null, y34 number := null,
                                  x35 number := null, y35 number := null,
                                  x36 number := null, y36 number := null,
                                  x37 number := null, y37 number := null,
                                  x38 number := null, y38 number := null,
                                  x39 number := null, y39 number := null,
                                  x40 number := null, y40 number := null,
                                  x41 number := null, y41 number := null,
                                  x42 number := null, y42 number := null,
                                  x43 number := null, y43 number := null,
                                  x44 number := null, y44 number := null,
                                  x45 number := null, y45 number := null,
                                  x46 number := null, y46 number := null,
                                  x47 number := null, y47 number := null,
                                  x48 number := null, y48 number := null,
                                  x49 number := null, y49 number := null,
                                  x50 number := null, y50 number := null,
                                  x51 number := null, y51 number := null,
                                  x52 number := null, y52 number := null,
                                  x53 number := null, y53 number := null,
                                  x54 number := null, y54 number := null,
                                  x55 number := null, y55 number := null,
                                  x56 number := null, y56 number := null,
                                  x57 number := null, y57 number := null,
                                  x58 number := null, y58 number := null,
                                  x59 number := null, y59 number := null,
                                  x60 number := null, y60 number := null,
                                  x61 number := null, y61 number := null,
                                  x62 number := null, y62 number := null,
                                  x63 number := null, y63 number := null,
                                  x64 number := null, y64 number := null,
                                  x65 number := null, y65 number := null,
                                  x66 number := null, y66 number := null,
                                  x67 number := null, y67 number := null,
                                  x68 number := null, y68 number := null,
                                  x69 number := null, y69 number := null,
                                  x70 number := null, y70 number := null,
                                  x71 number := null, y71 number := null,
                                  x72 number := null, y72 number := null,
                                  x73 number := null, y73 number := null,
                                  x74 number := null, y74 number := null,
                                  x75 number := null, y75 number := null,
                                  x76 number := null, y76 number := null,
                                  x77 number := null, y77 number := null,
                                  x78 number := null, y78 number := null,
                                  x79 number := null, y79 number := null,
                                  x80 number := null, y80 number := null,
                                  x81 number := null, y81 number := null,
                                  x82 number := null, y82 number := null,
                                  x83 number := null, y83 number := null,
                                  x84 number := null, y84 number := null,
                                  x85 number := null, y85 number := null,
                                  x86 number := null, y86 number := null,
                                  x87 number := null, y87 number := null,
                                  x88 number := null, y88 number := null,
                                  x89 number := null, y89 number := null,
                                  x90 number := null, y90 number := null,
                                  x91 number := null, y91 number := null,
                                  x92 number := null, y92 number := null,
                                  x93 number := null, y93 number := null,
                                  x94 number := null, y94 number := null,
                                  x95 number := null, y95 number := null,
                                  x96 number := null, y96 number := null,
                                  x97 number := null, y97 number := null,
                                  x98 number := null, y98 number := null,
                                  x99 number := null, y99 number := null,
                                 x100 number := null,y100 number := null,
                                 x101 number := null,y101 number := null,
                                 x102 number := null,y102 number := null,
                                 x103 number := null,y103 number := null,
                                 x104 number := null,y104 number := null,
                                 x105 number := null,y105 number := null,
                                 x106 number := null,y106 number := null,
                                 x107 number := null,y107 number := null,
                                 x108 number := null,y108 number := null,
                                 x109 number := null,y109 number := null,
                                 x110 number := null,y110 number := null,
                                 x111 number := null,y111 number := null,
                                 x112 number := null,y112 number := null,
                                 x113 number := null,y113 number := null,
                                 x114 number := null,y114 number := null,
                                 x115 number := null,y115 number := null,
                                 x116 number := null,y116 number := null,
                                 x117 number := null,y117 number := null,
                                 x118 number := null,y118 number := null,
                                 x119 number := null,y119 number := null,
                                 x120 number := null,y120 number := null,
                                 x121 number := null,y121 number := null,
                                 x122 number := null,y122 number := null,
                                 x123 number := null,y123 number := null,
                                 x124 number := null,y124 number := null);


   procedure extract(ssn varchar2,smdtn varchar2,tsn varchar2,tmdtn varchar2);

   procedure drop_target ( tmdtn varchar2 );
   procedure drop_target ( tsn varchar2, tmdtn varchar2 );
                      
   procedure dump_mbr;

end md_wex;
/

drop public synonym md_wex;
create public synonym md_wex for mdsys.md_wex;
grant execute on md_wex to public;

