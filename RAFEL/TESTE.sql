CREATE OR REPLACE PROCEDURE TESTE IS
   TYPE CTYPE_PPESSOA IS REF CURSOR;
   TYPE RTYPE_PPESSOA IS RECORD ( CODIGO   PPESSOA.codigo%TYPE,
                            NOME     PPESSOA.NOME%TYPE);
   
   C1           CTYPE_PPESSOA;
   BFLAG        BOOLEAN := FALSE;
   RC1          RTYPE_PPESSOA;
   SSAIDA       VARCHAR2(1000);
BEGIN
   DBMS_OUTPUT.put_line('CORRIGINDO RELACIONAMENTOS DUPLICADOS');
   WHILE BFLAG = FALSE LOOP
      OPEN C1 FOR
         SELECT CODIGO, NOME FROM (
         SELECT codigo, nome,
         (SELECT count(*) FROM PFUNC B WHERE B.codpessoa = A.CODIGO) as funcionario,
         (SELECT count(*) FROM EALUNOS B WHERE B.codpessoa = A.CODIGO) as alunos,
         (SELECT count(*) FROM EPROFES B WHERE B.codpessoa = A.CODIGO) as profes,
         (SELECT count(*) FROM VUSUARIOCURRICULO B WHERE B.codpessoa = A.CODIGO) as USUARIOCURRICULO
         FROM PPESSOA A
         WHERE NOME IN
           (
              SELECT B.nome FROM PPESSOA B GROUP BY B.NOME HAVING COUNT(*) > 1
           )
           AND
              (
                 exists (SELECT 0 FROM AUSOPROV B WHERE B.codpessoa = A.CODIGO)
                 OR  exists (SELECT 0 FROM AVISITA B WHERE B.codpessoa = A.CODIGO)
   	  		     OR  exists (SELECT 0 FROM BEXECPROVA B WHERE B.codpessoa = A.CODIGO)
	 		     OR  exists (SELECT 0 FROM BEXECPROVA B WHERE B.codavaliado = A.CODIGO)
  	 	  	     OR  exists (SELECT 0 FROM BHISTORICO B WHERE B.codpessoa = A.CODIGO)
	 		     OR  exists (SELECT 0 FROM BHISTORICO B WHERE B.codavaliado = A.CODIGO)
	 		     OR  exists (SELECT 0 FROM EALUNOS B WHERE B.codpessoa = A.CODIGO)
	 		     OR  exists (SELECT 0 FROM EALUNOS B WHERE B.pai = A.CODIGO)
	 		     OR  exists (SELECT 0 FROM EALUNOS B WHERE B.mae = A.CODIGO)
	 		     OR  exists (SELECT 0 FROM EALUNOS B WHERE B.respacad = A.CODIGO)
 	 		     OR  exists (SELECT 0 FROM EATENDIMENTO B WHERE B.codpessoa = A.CODIGO)
 	 		     OR  exists (SELECT 0 FROM EPROFES B WHERE B.codpessoa = A.CODIGO)
 	 		     OR  exists (SELECT 0 FROM HATENDENTE B WHERE B.codpessoa = A.CODIGO)
 			     OR  exists (SELECT 0 FROM HATENDIMENTOESP B WHERE B.codpessoa = A.CODIGO)
 			     OR  exists (SELECT 0 FROM KMAOOBRA B WHERE B.codpessoa = A.CODIGO)
 			     OR  exists (SELECT 0 FROM KREGISTROPRODUCAOQUALIDADE B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM LUSUARIO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM MISMAPROP B WHERE B.codpessoaresp = A.CODIGO)
			     OR  exists (SELECT 0 FROM MISMAPROP B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM MMAOOBRAPDO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM MMEDPALM B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM OFDESEMPENHOMENSAL B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM OFMAOOBRA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM OFOBJINSTAL B WHERE B.idvendedor = A.CODIGO)
			     OR  exists (SELECT 0 FROM OFOBJINSTAL B WHERE B.idtecnico = A.CODIGO)
			     OR  exists (SELECT 0 FROM PANOTAC B WHERE B.codpessoaaut = A.CODIGO)
			     OR  exists (SELECT 0 FROM PANOTAC B WHERE B.codpessoa = A.CODIGO)
		 	     OR  exists (SELECT 0 FROM PENDPESSOA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM PEXTERNO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM PFHSTEND B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM PFUNC B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM PPESSOAPT B WHERE B.codigo = A.CODIGO)
			     OR  exists (SELECT 0 FROM SALUNO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM SALUNO B WHERE B.codpessoaraca = A.CODIGO)
			     OR  exists (SELECT 0 FROM SCOORDENADOR B WHERE B.codpessoavice = A.CODIGO)
			     OR  exists (SELECT 0 FROM SCOORDENADOR B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM SDIRECAOFILIAL B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM SDIRECAOFILIAL B WHERE B.codpessoasec1 = A.CODIGO)
		 	     OR  exists (SELECT 0 FROM SDIRECAOFILIAL B WHERE B.codpessoasec2 = A.CODIGO)
			     OR  exists (SELECT 0 FROM SDIRETORDPTO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM SDIRETORESCOLA B WHERE B.codpessoa = A.CODIGO)
		         OR  exists (SELECT 0 FROM SPESSOA B WHERE B.codpessoapai = A.CODIGO)
			     OR  exists (SELECT 0 FROM SPESSOA B WHERE B.codpessoamae = A.CODIGO)
			     OR  exists (SELECT 0 FROM SPESSOA B WHERE B.codigo = A.CODIGO)
			     OR  exists (SELECT 0 FROM SPROFESSOR B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM SPSINSCRICAOAREAOFERTADA B WHERE B.codpessoaresponsavel = A.CODIGO)
			     OR  exists (SELECT 0 FROM TVEN B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VACOESVINCULADAS B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VADACAOAVALIADA B WHERE B.codavaliado = A.CODIGO)
			     OR  exists (SELECT 0 FROM VADVERTENCIA B WHERE B.codtestemun2 = A.CODIGO)
			     OR  exists (SELECT 0 FROM VADVERTENCIA B WHERE B.codtestemun1 = A.CODIGO)
			     OR  exists (SELECT 0 FROM VADVOGADO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VAGENDAEXAM B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VAUSENCIA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VAVALIADOAD B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VAVALIADORAD B WHERE B.codavaliador = A.CODIGO)
			     OR  exists (SELECT 0 FROM VBIBRIGADISTA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VCANDIDATOS B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VCANDIDATOSCIPA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VCOMPETENCIAPESSOA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VCOMPETENCIAPESSOA B WHERE B.codcompetencia = A.CODIGO)
			     OR  exists (SELECT 0 FROM VCOMPETENCIAPESSOAHIST B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VCONSULTASPRONT B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VCTRLVACINAL B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VDESPESASREQSEL B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VEMPRESTIMOEPI B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VENVOLVIDOSCAT B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VEXPPROF B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VFUNCAOPRETENDIDA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VGRAFICOS B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VHABILIDADESPESSOAIS B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VINDICACOES B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VINVESTIGACAO B WHERE B.codpessoaresp = A.CODIGO)
			     OR  exists (SELECT 0 FROM VLNTPESSOAS B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VMETAS B WHERE B.codpessoaresp = A.CODIGO)
			     OR  exists (SELECT 0 FROM VMODTURMA B WHERE B.codinstrutor = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPARECERREQUISICAO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPARTICIPANTES B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPCOMPL B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPESSOAREQUISICAO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPESSOAREQUISITADA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPESSOASINSCTURMA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPLANEJCURSOPESSOA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPLANILHATURMA B WHERE B.codinstrutor = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPLANORECRUTAMENTO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPLANOTREIN B WHERE B.codinstrutor = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPPRAMEDICOES B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPREPOSTO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPVV B WHERE B.codpessoaresp = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPVVEVENTO B WHERE B.codpessoaresp = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPVVGASTOEVENTO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPVVPARTICIPANTE B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VPVVPARTICIPANTEEVENTO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VRECLAMADO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VRECLAMANTE B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VRECRUTAMENTO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VREPRESENTANTE B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VREQUISICAOADMISSAO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VREQUISICAOADMISSAO B WHERE B.codrequisitante = A.CODIGO)
			     OR  exists (SELECT 0 FROM VREQUISITOPESSOAHIST B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VRESPMONBIOLOGICA B WHERE B.codigo = A.CODIGO)
			     OR  exists (SELECT 0 FROM VRESPREGAMBIENTAL B WHERE B.codigo = A.CODIGO)
			     OR  exists (SELECT 0 FROM VREUNIAOSPAT B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VRNTREGDEMANDAS B WHERE B.codpessoaverif = A.CODIGO)
			     OR  exists (SELECT 0 FROM VRNTREGDEMANDAS B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VSELECAO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VTESTEMUNHACAT B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VTESTEMUNHACTRAB B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VTUAVCONHLACTO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VTUAVQUALIDPESSOA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VTURMA B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VTURMAS B WHERE B.codinstrutor = A.CODIGO)
			     OR  exists (SELECT 0 FROM VUSUARIOCURRICULO B WHERE B.codpessoa = A.CODIGO)
			     OR  exists (SELECT 0 FROM VVAGAPESSOA B WHERE B.codpessoa = A.CODIGO)
              )
           /*and nome like 'CARLOS RAFAEL C%'*/)
         ORDER BY nome, funcionario desc,alunos desc,profes desc, USUARIOCURRICULO desc;
      FETCH C1 INTO RC1.CODIGO, RC1.NOME;
      IF C1%FOUND  THEN
         SSAIDA := RC1.CODIGO || ' - ' || RC1.NOME || MUDAPESSOA(RC1.CODIGO, RC1.NOME);
         REMOVERG(FALSE);
         DBMS_OUTPUT.put_line(SSAIDA);
      ELSE
         BFLAG := TRUE;
      END IF;
      SSAIDA := '';
      CLOSE C1;
   END LOOP;
END; -- Procedure
/

