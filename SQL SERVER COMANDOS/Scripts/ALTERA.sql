set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER TRIGGER [AlteraPrecos]
ON [dbo].[TPRD]
AFTER UPDATE, INSERT
NOT FOR REPLICATION

AS 

BEGIN

-- Declara variáveis

	DECLARE 
	@produto INT,
	@precocheio NUMERIC(15,4)

-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.

	SET NOCOUNT ON;

-- Inicializa variáveis

	SELECT @produto=INSERTED.idprd FROM INSERTED;

-- Calcula preço cheio

	SELECT @precocheio=(INSERTED.preco1 * INSERTED.preco2) FROM INSERTED;
	UPDATE tprd SET tprd.preco3=@precocheio WHERE tprd.codcoligada=1 AND tprd.idprd=@produto;

-- Calcula tabela de descontos

	UPDATE tprdcompl SET
		PRCCHEIO=@precocheio,
		PRC20=@precocheio*(1-0.20),
		PRC25=@precocheio*(1-0.25),
		PRC30=@precocheio*(1-0.3),
		PRC40=@precocheio*(1-0.4),
		PRC40E5=@precocheio*(1-0.4)*(1-0.05),
		PRC40E10=@precocheio*(1-0.4)*(1-0.1),
		PRC15=@precocheio*(1-0.15),
		PRC40E20=@precocheio*(1-0.4)*(1-0.2),
		PRC10=@precocheio*(1-0.1),
		PRC35=@precocheio*(1-0.35),
		PRC5940=@precocheio*(1-0.594),
		PRC35E5=@precocheio*(1-0.35)*(1-0.05),
		PRC35E10=@precocheio*(1-0.35)*(1-0.1),
		PRC30E5=@precocheio*(1-0.2),
		PRC30E10=@precocheio*(1-0.3)*(1-0.1),
		PRC50E10=@precocheio*(1-0.5)*(1-0.1),
		PRC45=@precocheio*(1-0.45),
        PRC50E15=@precocheio*(1-0.5)*(1-0.15)
	WHERE tprdcompl.codcoligada=1 AND tprdcompl.idprd=@produto;		

END


