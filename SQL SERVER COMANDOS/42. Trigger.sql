--INSERTED = VALOR NOVO
--DELETED  = VALOR ANTIGO
--AFTER    = DEPOIS DE
CREATE TRIGGER [NOME_TRIGGER] ON [DBO].[TABELA_ONDE_SE_EXECUTAR�_A_TRIGGER]
FOR INSERT, UPDATE, DELETE -- AO INSERIR, ALTERAR, DELETAR O REGISTRO NA TABELA
AS
	DECLARE --DECLARA��O DE VARIAVEIS
	@VARIAVEL1 INT,
	@VARIAVEL2 NUMERIC(15,6) --@VARIAVEL TIPO, VER TIPOS DE VARIAVEIS NO HELP EM integer constants.

BEGIN TRANSACTION 
		-- INICIALIZA��O DAS VARIAVES
		SELECT 
			@IDPROD=INSERTED.IDPRD, 
			@FTCONVC=C.FATORCONVERSAO,
			@PERCSUFR=TMOV.PERCENTUALEXTRA1,
			@SITUACAO=(CASE INSERTED.CODTB1FAT WHEN 'N' THEN 2 ELSE 3 END), 
		FROM INSERTED, TMOV, TPRD, TUND C, TUND V
		WHERE (INSERTED.IDMOV=TMOV.IDMOV) AND 
              (INSERTED.IDPRD=TPRD.IDPRD) AND 
              (TPRD.CODUNDCOMPRA=C.CODUND) AND 
              (TPRD.CODUNDVENDA=V.CODUND)
        
      --SET � NECESSARIO PARA ATRIBUI��O DE VALOR A VARIAVEL.
		SET @SEQUENC=(SELECT MAX(Y.COD_ENT)+1 FROM TPRDCOMPL_AJUSTE Y WHERE Y.IDPRD=@IDPROD)

	  -- VERIFICA SE � O MOVIMENTO DE COMPRAS DE MERCADORIA REVENDA
		IF @TIPOMOV = '1.2.05'
		BEGIN	
				-- VERIFICA SE JA EXISTE O ITEM DE NF NA TPRDCOMPL_AJUSTE
				IF NOT EXISTS (SELECT * FROM TPRDCOMPL_AJUSTE WHERE IDMOV = @NF AND IDPRD=@IDPROD)					
						-- NAO EXISTINDO, INCLUI ITEM DE MOVIMENTO
						INSERT INTO TPRDCOMPL_AJUSTE
						SELECT
						  1 --CODCOLIGADA
						  ,@IDPROD --IDPRD
						  ,@SEQUENC --COD_ENT
						  ,0 --X.CUBAGEMCOMPRA
						  ,ROUND(@CUSTOUNIT,2) --X.CSTPRODUTOV
						FROM TPRDCOMPL_AJUSTE X
                        -- PEGA DEFAULTS DO ULTIMO REGISTRO DO PRODUTO COM SITU_CODIGO=1						
                        WHERE X.IDPRD=@IDPROD AND 
                              X.COD_ENT=(SELECT MAX(Z.COD_ENT) 
							             FROM TPRDCOMPL_AJUSTE Z 
										 WHERE Z.IDPRD=@IDPROD AND 
                                               Z.SITU_CODIGO=1)
					-- JA EXISTINDO O ITEM DA NF FAZ ALTERACAO (UPDATE)
					ELSE 
						UPDATE TPRDCOMPL_AJUSTE SET CSTPRODUTOV=ROUND(@CUSTOUNIT,2), DATA=@DATA
						WHERE IDPRD=@IDPROD AND IDMOV=@NF
				
				-- EM CASO DE ERRO
				IF @@ERROR<>0 
				BEGIN
					ROLLBACK TRANSACTION
				END
		END -- FIM DO IF PRINCIPAL

COMMIT TRANSACTION
