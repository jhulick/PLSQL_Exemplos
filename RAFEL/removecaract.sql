CREATE OR REPLACE PROCEDURE REMOVECARACT
   IS
CURSOR C1 IS
   select CODIGO, NOME
      from ppessoa a where nome like '%�%' or nome like '%�%' or nome like '%�%'
         or nome like '%�%' or nome like '%�%' or nome like '%�%' or nome like '%�%'
         or nome like '%�%' or nome like '%�%' or nome like '%�%' or nome like '%�%'
         or nome like '%�%' or nome like '%�%' or nome like '%�%' or nome like '%�%'
         OR nome like '%�%' or nome like '%�%'
   order by NOME
   FOR UPDATE OF CODIGO;
   BFLAG   BOOLEAN := FALSE;
   NVEZES  NUMBER(3,0) := 0;
   NRETRABALHO   NUMBER(3,0) := 0;
   NNOME   NUMBER(3,0) := 0;
   SSTRING_SAIDA VARCHAR2(1000) := '';
BEGIN
   --ALTER TRIGGER logupdateealunos DISABLE;
   DBMS_OUTPUT.put_line('REMO��O DOS CARACTERES ESPECIAIS DO NOME');
   WHILE NOT BFLAG LOOP
      NVEZES := NVEZES + 1;
      DBMS_OUTPUT.put_line('EXECU��O ' || NVEZES);
      FOR RC1 IN C1 LOOP
         NNOME := 0;
         SSTRING_SAIDA := RC1.CODIGO || ' - ' || RC1.NOME || '( PPESSOA - ';
         SELECT COUNT(NOME) INTO NNOME FROM VUSUARIOCURRICULO WHERE RC1.CODIGO = CODPESSOA;
         IF NNOME > 0 THEN
            NNOME := 0;
            SELECT COUNT(NOME) INTO NNOME FROM VUSUARIOCURRICULO WHERE RC1.CODIGO = CODPESSOA AND NOME <> RC1.NOME;
            IF NNOME > 0 THEN
               SSTRING_SAIDA := SSTRING_SAIDA || 'USUARIO DO CURRICULO EXTERNO COM NOME DIFERENTE DA PESSOA - ';
            ELSE
               UPDATE VUSUARIOCURRICULO SET NOME = TRANSLATE(NOME,'�����������������','AAAAEEEIIOOOOUUUC') WHERE codpessoa = RC1.CODIGO;
               SSTRING_SAIDA := SSTRING_SAIDA || 'VUSUARIOCURRICULO - ';
            END IF;
         END IF;
         
         NNOME := 0;
         SELECT COUNT(NOME) INTO NNOME FROM PFUNC WHERE RC1.CODIGO = CODPESSOA;
         IF NNOME > 0 THEN
            NNOME := 0;
            SELECT COUNT(NOME) INTO NNOME FROM PFUNC WHERE RC1.CODIGO = CODPESSOA AND NOME <> RC1.NOME;
            IF NNOME > 0 THEN
               SSTRING_SAIDA := SSTRING_SAIDA || 'FUNCIONARIO COM NOME DIFERENTE DA PESSOA - ';
            ELSE
               UPDATE PFUNC SET NOME = TRANSLATE(NOME,'�����������������','AAAAEEEIIOOOOUUUC') WHERE codpessoa = RC1.CODIGO;
               SSTRING_SAIDA := SSTRING_SAIDA || 'PFUNC - ';
            END IF;
         END IF;
         
         NNOME := 0;
         SELECT COUNT(NOME) INTO NNOME FROM EALUNOS WHERE RC1.CODIGO = CODPESSOA;
         IF NNOME > 0 THEN
            NNOME := 0;
            SELECT COUNT(NOME) INTO NNOME FROM EALUNOS WHERE RC1.CODIGO = CODPESSOA AND NOME <> RC1.NOME;
            IF NNOME > 0 THEN
               SSTRING_SAIDA := SSTRING_SAIDA || 'ALUNO COM NOME DIFERENTE DA PESSOA - ';
            ELSE
               UPDATE EALUNOS SET NOME = TRANSLATE(NOME,'�����������������','AAAAEEEIIOOOOUUUC') WHERE codpessoa = RC1.CODIGO;
               SSTRING_SAIDA := SSTRING_SAIDA || 'EALUNOS - ';
            END IF;
         END IF;
         
         NNOME := 0;
         SELECT COUNT(NOME) INTO NNOME FROM EPROFES WHERE RC1.CODIGO = CODPESSOA;
         IF NNOME > 0 THEN
            NNOME := 0;
            SELECT COUNT(NOME) INTO NNOME FROM EPROFES WHERE RC1.CODIGO = CODPESSOA AND NOME <> RC1.NOME;
            IF NNOME > 0 THEN
               SSTRING_SAIDA := SSTRING_SAIDA || 'PROFESSOR COM NOME DIFERENTE DA PESSOA - ';
            ELSE
               UPDATE EPROFES SET NOME = TRANSLATE(NOME,'�����������������','AAAAEEEIIOOOOUUUC') WHERE codpessoa = RC1.CODIGO;
               SSTRING_SAIDA := SSTRING_SAIDA || 'EPROFES - ';
            END IF;
         END IF;
         UPDATE PPESSOA SET NOME = TRANSLATE(NOME,'�����������������','AAAAEEEIIOOOOUUUC') WHERE CURRENT OF C1;
         DBMS_OUTPUT.put_line(SSTRING_SAIDA || ')');
      END LOOP;
      DBMS_OUTPUT.put_line(' ');
      --COMMIT;
      SELECT COUNT(*) INTO NRETRABALHO
         from ppessoa a where nome like '%�%' or nome like '%�%' or nome like '%�%'
            or nome like '%�%' or nome like '%�%' or nome like '%�%' or nome like '%�%'
            or nome like '%�%' or nome like '%�%' or nome like '%�%' or nome like '%�%'
            or nome like '%�%' or nome like '%�%' or nome like '%�%' or nome like '%�%'
            OR nome like '%�%' or nome like '%�%';
      IF NRETRABALHO = 0 THEN
         BFLAG := TRUE;
      END IF;
   END LOOP;
   --ALTER TRIGGER logupdateealunos ENABLE;
END; -- Procedure
/

