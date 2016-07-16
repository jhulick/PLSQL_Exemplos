rem 
rem $Header: catstatc.sql,v 1.2 1995/02/14 12:42:16 glumpkin Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      catstatc.sql
Rem    DESCRIPTION
Rem      Compute statistics for all dictionary clusters and tables.
Rem    NOTES
Rem      Must be connected as sys or internal.
Rem    MODIFIED   (MM/DD/YY)
Rem     glumpkin   02/13/95 -  Fix for new data dictionary tables
Rem     tpystyne   11/06/92 -  Creation

analyze cluster C_COBJ# compute statistics;                       
analyze cluster C_FILE#_BLOCK# compute statistics;                
analyze cluster C_MLOG# compute statistics;                       
analyze cluster C_OBJ# compute statistics;                        
analyze cluster C_OBJ#_COL# compute statistics;                        
analyze cluster C_RG# compute statistics;                         
analyze cluster C_TS# compute statistics;                         
analyze cluster C_USER# compute statistics;                       

analyze table ACCESS$ compute statistics;                       
analyze table ARGUMENT$ compute statistics;
analyze table AUD$ compute statistics;                          
analyze table AUDIT$ compute statistics;                        
analyze table BOOTSTRAP$ compute statistics;                    
analyze table COM$ compute statistics;                          
analyze table CON$ compute statistics;                          
analyze table DEFROLE$ compute statistics;                      
analyze table DEPENDENCY$ compute statistics;                   
analyze table DUAL compute statistics;                          
analyze table DUC$ compute statistics;                   
analyze table ERROR$ compute statistics;                        
analyze table FILE$ compute statistics;                         
analyze table HIST_HEAD$ compute statistics;                   
analyze table IDL_CHAR$ compute statistics;                     
analyze table IDL_SB4$ compute statistics;                      
analyze table IDL_UB1$ compute statistics;                      
analyze table IDL_UB2$ compute statistics;                      
analyze table INCEXP compute statistics;                        
analyze table INCFIL compute statistics;                        
analyze table INCVID compute statistics;                        
analyze table JOB$ compute statistics;                   
analyze table LAB$ compute statistics;                          
analyze table LINK$ compute statistics;                         
analyze table OBJ$ compute statistics;                          
analyze table OBJAUTH$ compute statistics;                      
analyze table OBJPRIV$ compute statistics;                   
analyze table PENDING_SESSIONS$ compute statistics;             
analyze table PENDING_SUB_SESSIONS$ compute statistics;         
analyze table PENDING_TRANS$ compute statistics;                
analyze table PROCEDURE$ compute statistics;                    
analyze table PROFILE$ compute statistics;                      
analyze table PROFNAME$ compute statistics;                     
analyze table PROPS$ compute statistics;                        
analyze table RESOURCE_COST$ compute statistics;                
analyze table SEQ$ compute statistics;                          
analyze table SNAP$ compute statistics;                         
analyze table SOURCE$ compute statistics;                       
analyze table SYN$ compute statistics;                          
analyze table SYSAUTH$ compute statistics;                      
analyze table TRIGGER$ compute statistics;                      
analyze table TRIGGERCOL$ compute statistics;                   
analyze table UNDO$ compute statistics;                         
analyze table VIEW$ compute statistics;                         
analyze table "_default_auditing_options_" compute statistics;    
