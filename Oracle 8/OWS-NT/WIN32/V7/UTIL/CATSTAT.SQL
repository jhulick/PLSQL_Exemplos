rem 
rem $Header: catstat.sql,v 1.2 1995/02/14 12:35:36 glumpkin Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      dictstat.sql
Rem    DESCRIPTION
Rem      Compute statistics for all dictionary clusters and tables.
Rem    NOTES
Rem      Must be connected as sys or internal.
Rem    MODIFIED   (MM/DD/YY)
Rem     glumpkin   02/14/95 -  Fix for new data dictionary tables
Rem     glumpkin   10/26/92 -  Renamed from DICTSTAT.SQL 
Rem     tpystyne   09/18/92 -  use estimate instead of compute 
Rem     tpystyne   08/19/92 -  Creation 

analyze cluster C_COBJ# estimate statistics;                       
analyze cluster C_FILE#_BLOCK# estimate statistics;                
analyze cluster C_MLOG# estimate statistics;                       
analyze cluster C_OBJ# estimate statistics;                        
analyze cluster C_OBJ#_COL# estimate statistics;                        
analyze cluster C_RG# estimate statistics;                         
analyze cluster C_TS# estimate statistics;                         
analyze cluster C_USER# estimate statistics;                       

analyze table ACCESS$ estimate statistics;                       
analyze table ARGUMENT$ estimate statistics;
analyze table AUD$ estimate statistics;                          
analyze table AUDIT$ estimate statistics;                        
analyze table BOOTSTRAP$ estimate statistics;                    
analyze table COM$ estimate statistics;                          
analyze table CON$ estimate statistics;                          
analyze table DEFROLE$ estimate statistics;                      
analyze table DEPENDENCY$ estimate statistics;                   
analyze table DUAL estimate statistics;                          
analyze table DUC$ estimate statistics;                   
analyze table ERROR$ estimate statistics;                        
analyze table FILE$ estimate statistics;                         
analyze table HIST_HEAD$ estimate statistics;                   
analyze table IDL_CHAR$ estimate statistics;                     
analyze table IDL_SB4$ estimate statistics;                      
analyze table IDL_UB1$ estimate statistics;                      
analyze table IDL_UB2$ estimate statistics;                      
analyze table INCEXP estimate statistics;                        
analyze table INCFIL estimate statistics;                        
analyze table INCVID estimate statistics;                        
analyze table JOB$ estimate statistics;                   
analyze table LAB$ estimate statistics;                          
analyze table LINK$ estimate statistics;                         
analyze table OBJ$ estimate statistics;                          
analyze table OBJAUTH$ estimate statistics;                      
analyze table OBJPRIV$ estimate statistics;                   
analyze table PENDING_SESSIONS$ estimate statistics;             
analyze table PENDING_SUB_SESSIONS$ estimate statistics;         
analyze table PENDING_TRANS$ estimate statistics;                
analyze table PROCEDURE$ estimate statistics;                    
analyze table PROFILE$ estimate statistics;                      
analyze table PROFNAME$ estimate statistics;                     
analyze table PROPS$ estimate statistics;                        
analyze table RESOURCE_COST$ estimate statistics;                
analyze table SEQ$ estimate statistics;                          
analyze table SNAP$ estimate statistics;                         
analyze table SOURCE$ estimate statistics;                       
analyze table SYN$ estimate statistics;                          
analyze table SYSAUTH$ estimate statistics;                      
analyze table TRIGGER$ estimate statistics;                      
analyze table TRIGGERCOL$ estimate statistics;                   
analyze table UNDO$ estimate statistics;                         
analyze table VIEW$ estimate statistics;                         
analyze table "_default_auditing_options_" estimate statistics;    
