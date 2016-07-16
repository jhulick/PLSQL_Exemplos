------- Generated by SYS.DBMS_METADATA on 28-jan-2010 at 14:20:04 -------

  CREATE OR REPLACE PACKAGE "RM"."BUSCA_TABELAS" 
  IS
--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE 
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------       
   -- Enter package declarations as shown below

   PROCEDURE lista_filhas
     ( tabela IN varchar2);

   PROCEDURE lista_filhas_aux
     ( identador IN varchar2, tabela IN varchar2, nivel IN number, p_nivel IN number);
 
END; -- Package spec
 
CREATE OR REPLACE PACKAGE BODY "RM"."BUSCA_TABELAS" 
IS
--
-- To modify this template, edit file PKGBODY.TXT in TEMPLATE 
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package body
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------      
   -- Enter procedure, function bodies as shown below

    

   PROCEDURE lista_filhas
     ( tabela IN varchar2 )
   IS
      -- Enter the procedure variables here. As shown below
   BEGIN
    lista_filhas_aux('-',tabela,3,0);
   END;
    

   PROCEDURE lista_filhas_aux
     ( identador IN varchar2, tabela IN varchar2, nivel IN number, p_nivel IN number )
   IS
   BEGIN
        if (p_nivel <= nivel) then
            for r in (select distinct table_name from all_constraints where r_constraint_name =
                        (select constraint_name from all_constraints where table_name = tabela
                        and constraint_type='P'))
            loop
                --insert into AAAA_TABELA values (identador||r.table_name);
                lista_filhas_aux('-'||identador,r.table_name, nivel, p_nivel+1);
            end loop;
            commit;
        end if;
   END;

END; 
 
/