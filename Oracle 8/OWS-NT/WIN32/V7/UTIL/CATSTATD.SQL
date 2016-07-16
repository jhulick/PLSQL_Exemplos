rem 
rem $Header: catstatd.sql,v 1.2 1995/02/14 12:41:23 glumpkin Exp $ 
rem 
Rem  Copyright (c) 1991 by Oracle Corporation 
Rem    NAME
Rem      catstatd.sql
Rem    DESCRIPTION
Rem      Delete statistics from all dictionary clusters and tables.
Rem    NOTES
Rem      Must be connected as sys or internal.
Rem    MODIFIED   (MM/DD/YY)
Rem     glumpkin   02/13/95 -  Add new tables
Rem     tpystyne   11/06/92 -  Creation 

analyze cluster C_COBJ# delete statistics;                       
analyze cluster C_FILE#_BLOCK# delete statistics;                
analyze cluster C_MLOG# delete statistics;                       
analyze cluster C_OBJ# delete statistics;                        
analyze cluster C_OBJ#_COL# delete statistics;                        
analyze cluster C_RG# delete statistics;                         
analyze cluster C_TS# delete statistics;                         
analyze cluster C_USER# delete statistics;                       

analyze table ACCESS$ delete statistics;                       
analyze table ARGUMENT$ delete statistics;
analyze table AUD$ delete statistics;                          
analyze table AUDIT$ delete statistics;                        
analyze table BOOTSTRAP$ delete statistics;                    
analyze table COM$ delete statistics;                          
analyze table CON$ delete statistics;                          
analyze table DEFROLE$ delete statistics;                      
analyze table DEPENDENCY$ delete statistics;                   
analyze table DUAL delete statistics;                          
analyze table DUC$ delete statistics;                   
analyze table ERROR$ delete statistics;                        
analyze table FILE$ delete statistics;                         
analyze table HIST_HEAD$ delete statistics;                   
analyze table IDL_CHAR$ delete statistics;                     
analyze table IDL_SB4$ delete statistics;                      
analyze table IDL_UB1$ delete statistics;                      
analyze table IDL_UB2$ delete statistics;                      
analyze table INCEXP delete statistics;                        
analyze table INCFIL delete statistics;                        
analyze table INCVID delete statistics;                        
analyze table JOB$ delete statistics;                   
analyze table LAB$ delete statistics;                          
analyze table LINK$ delete statistics;                         
analyze table OBJ$ delete statistics;                          
analyze table OBJAUTH$ delete statistics;                      
analyze table OBJPRIV$ delete statistics;                   
analyze table PENDING_SESSIONS$ delete statistics;             
analyze table PENDING_SUB_SESSIONS$ delete statistics;         
analyze table PENDING_TRANS$ delete statistics;                
analyze table PROCEDURE$ delete statistics;                    
analyze table PROFILE$ delete statistics;                      
analyze table PROFNAME$ delete statistics;                     
analyze table PROPS$ delete statistics;                        
analyze table RESOURCE_COST$ delete statistics;                
analyze table SEQ$ delete statistics;                          
analyze table SNAP$ delete statistics;                         
analyze table SOURCE$ delete statistics;                       
analyze table SYN$ delete statistics;                          
analyze table SYSAUTH$ delete statistics;                      
analyze table TRIGGER$ delete statistics;                      
analyze table TRIGGERCOL$ delete statistics;                   
analyze table UNDO$ delete statistics;                         
analyze table VIEW$ delete statistics;                         
analyze table "_default_auditing_options_" delete statistics;    
