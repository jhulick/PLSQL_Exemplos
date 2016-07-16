CREATE OR REPLACE PROCEDURE REMOVECARACT
   IS
CURSOR C1 IS
   select CODIGO, NOME
      from ppessoa a where nome like '%а%' or nome like '%ц%' or nome like '%б%'
         or nome like '%и%' or nome like '%й%' or nome like '%х%' or nome like '%м%'
         or nome like '%л%' or nome like '%с%' or nome like '%р%' or nome like '%т%'
         or nome like '%у%' or nome like '%з%' or nome like '%ы%' or nome like '%ш%'
         OR nome like '%г%' or nome like '%ю%'
   order by NOME
   FOR UPDATE OF CODIGO;
   BFLAG   BOOLEAN := FALSE;
   NVEZES  NUMBER(3,0) := 0;
   NRETRABALHO   NUMBER(3,0) := 0;
   NNOME   NUMBER(3,0) := 0;
   SSTRING_SAIDA VARCHAR2(1000) := '';
BEGIN
   --ALTER TRIGGER logupdateealunos DISABLE;
   DBMS_OUTPUT.put_line('REMOгцO DOS CARACTERES ESPECIAIS DO NOME');
   WHILE NOT BFLAG LOOP
      NVEZES := NVEZES + 1;
      DBMS_OUTPUT.put_line('EXECUгцO ' || NVEZES);
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
               UPDATE VUSUARIOCURRICULO SET NOME = TRANSLATE(NOME,'ацбюийхмлсртузышг','AAAAEEEIIOOOOUUUC') WHERE codpessoa = RC1.CODIGO;
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
               UPDATE PFUNC SET NOME = TRANSLATE(NOME,'ацбюийхмлсртузышг','AAAAEEEIIOOOOUUUC') WHERE codpessoa = RC1.CODIGO;
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
               UPDATE EALUNOS SET NOME = TRANSLATE(NOME,'ацбюийхмлсртузышг','AAAAEEEIIOOOOUUUC') WHERE codpessoa = RC1.CODIGO;
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
               UPDATE EPROFES SET NOME = TRANSLATE(NOME,'ацбюийхмлсртузышг','AAAAEEEIIOOOOUUUC') WHERE codpessoa = RC1.CODIGO;
               SSTRING_SAIDA := SSTRING_SAIDA || 'EPROFES - ';
            END IF;
         END IF;
         UPDATE PPESSOA SET NOME = TRANSLATE(NOME,'ацбюийхмлсртузышг','AAAAEEEIIOOOOUUUC') WHERE CURRENT OF C1;
         DBMS_OUTPUT.put_line(SSTRING_SAIDA || ')');
      END LOOP;
      DBMS_OUTPUT.put_line(' ');
      --COMMIT;
      SELECT COUNT(*) INTO NRETRABALHO
         from ppessoa a where nome like '%а%' or nome like '%ц%' or nome like '%б%'
            or nome like '%и%' or nome like '%й%' or nome like '%х%' or nome like '%м%'
            or nome like '%л%' or nome like '%с%' or nome like '%р%' or nome like '%т%'
            or nome like '%у%' or nome like '%з%' or nome like '%ы%' or nome like '%ш%'
            OR nome like '%г%' or nome like '%ю%';
      IF NRETRABALHO = 0 THEN
         BFLAG := TRUE;
      END IF;
   END LOOP;
   --ALTER TRIGGER logupdateealunos ENABLE;
END; -- Procedure
/

