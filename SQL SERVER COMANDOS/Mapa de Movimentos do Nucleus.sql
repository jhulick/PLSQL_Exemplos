SELECT Distinct
 CASE 
	WHEN (TCNTPAR.CODTMV = TTMV.CODTMV OR TCNTPAR.CODTMVCOMPRA = TTMV.CODTMV) AND TCNTPAR.EDICAOCODTMV=1  THEN 'Contratos (Editavel)' 
	WHEN (TCNTPAR.CODTMV = TTMV.CODTMV OR TCNTPAR.CODTMVCOMPRA = TTMV.CODTMV) AND TCNTPAR.EDICAOCODTMV=0  THEN 'Contratos'
 END AS ORIGEM
,TTMV.CODTMV
--,';'
, TTMV.NOME + ' [' +
CASE TTMV.CLASSIFICACAO
	WHEN '04.04.03' THEN 'Ajuste de Estoque'
	WHEN '04.04.04' THEN 'Requisicao de Materiais'
	WHEN '04.04.05' THEN 'Baixa de Estoque'
	WHEN '04.04.06' THEN 'Transferencias'
	WHEN '04.04.07' THEN 'Inventario'
	WHEN '04.06.01' THEN 'Solicitacao de Compra'
	WHEN '04.06.04' THEN 'Ordem de Compra'
	WHEN '04.06.05' THEN 'Recebimento de Materiais'
	WHEN '04.06.07' THEN 'Aquisicao de Servicos'
	WHEN '04.06.08' THEN 'Devolucao de Compra'
	WHEN '04.07' THEN 'Controle de Imobilizado'
	WHEN '04.08.01' THEN 'Pedido de Venda'
	WHEN '04.08.02' THEN 'Faturamento'
	WHEN '04.09' THEN 'Outras Movimentacoes'
	ELSE ISNULL(TTMV.CLASSIFICACAO,'')
END + ']' AS NOME
--MVTOS DE DESTINO
--,';'
,TTMVFATURAMENTO.CODTMVFAT
--SALDO FISICO
,CASE WHEN TITMTMV.EFEITOSALDOA1 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA1 END AS "SALDO DE BALAN�O"
--,';'
,CASE WHEN TITMTMV.EFEITOSALDOA2 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA2 END AS "SALDO ATUAL"
,CASE WHEN TITMTMV.EFEITOSALDOA3 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA3 END AS "PEDIDOS A FORNECEDORES"
,CASE WHEN TITMTMV.EFEITOSALDOA4 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA4 END AS "PEDIDOS A CLIENTES"
--,';'
,CASE WHEN TITMTMV.EFEITOSALDOA5 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA5 END AS "ABASTECIMENTO"
--,';'
,CASE WHEN TITMTMV.EFEITOSALDOA6 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA6 END AS "EQUIPAMENTO"
,CASE WHEN TITMTMV.EFEITOSALDOA7 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA7 END AS EFEITOSALDOA7
,CASE WHEN TITMTMV.EFEITOSALDOA8 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA8 END AS EFEITOSALDOA8
,CASE WHEN TITMTMV.EFEITOSALDOA9 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA9 END AS EFEITOSALDOA9
,CASE WHEN TITMTMV.EFEITOSALDOA10 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOA10 END AS EFEITOSALDOA10
--SALDO FINANCEIRO
--,';'
,CASE WHEN TITMTMV.EFEITOSALDOB2 = 'N' THEN NULL ELSE TITMTMV.EFEITOSALDOB2 END AS "SALDO FINANCEIRO"
--FINANCEIRO
--,';'
,CASE WHEN TTMV.FATURA = 0 THEN NULL ELSE CASE WHEN TTMV.PAGOURECLAN = 2 THEN 'A Pagar' ELSE 'A Receber' END + ' ('+FTDO.DESCRICAO+' ['+
CASE FTDO.EDEVOLUCAO 
	WHEN 0  THEN 'Sem Classifica��o'
	WHEN 1  THEN 'Devolu��o'
	WHEN 2  THEN 'Adiantamento'
	WHEN 3  THEN 'Nota de Cr�dito'
	WHEN 4  THEN 'Previs�o {Nao baixavel}'
	WHEN 5  THEN 'Gerador de IRRF'
	WHEN 6  THEN 'Vendor'
	WHEN 7  THEN 'Letra (Portugal)'
	WHEN 9  THEN 'Gerador de INSS'
	WHEN 10  THEN 'Gerador de IRRF e INSS'
END +'])'
 END FATURA 
,CASE 
	WHEN TTMV.FATURA = 1 AND TTMV.CANCELALCTPED = 0 THEN NULL
	WHEN TTMV.FATURA = 1 AND TTMV.CANCELALCTPED = 1 THEN 'Cancela'
	WHEN TTMV.FATURA = 1 AND TTMV.CANCELALCTPED = 2 THEN 'Exclui'
 END AS LACTOFIN_APOS_GERACAR_PROX_MVTO
--,';'
,CASE WHEN TTMV.CONTABILLAN = 'N' THEN NULL WHEN TTMV.CONTABILLAN = 'B' THEN 'Baixa Cont�bil' ELSE TTMV.CONTABILLAN END CONTABILLAN
--CONTABIL
--,';'
,CASE WHEN TTMV.USAREVC = 0 THEN NULL ELSE TTMV.USAREVC END AS CONTABILMVTO
--ESCRITURACAO
--,';'
,CASE WHEN TITMTMV.GERAESCRITURACAO = 0 THEN NULL ELSE TITMTMV.GERAESCRITURACAO END AS GERAESCRITURACAO
--,';'
,CASE TTMV.EDICAOTB1FLXMOV
	WHEN 0 THEN 'Nao Edita'
	WHEN 1 THEN 'Edita'
	WHEN 2 THEN 'Mostra'
 END AS EDITAR_NATUREZA_FINANCEIRA
,TITMTMV.OBRIGATB1FLXMOV AS OBRIG_NAT_FIN
,(SELECT MAX(RECCREATEDON) FROM TMOV WHERE CODTMV = TTMV.CODTMV) AS CRIADOPELAULTIMAVEZ
FROM TTMV
	INNER JOIN TITMTMV ON TTMV.CODCOLIGADA = TITMTMV.CODCOLIGADA
					  AND TTMV.CODTMV = TITMTMV.CODTMV
	LEFT JOIN TTMVFATURAMENTO ON TTMVFATURAMENTO.CODCOLIGADA = TTMV.CODCOLIGADA
							 AND TTMVFATURAMENTO.CODTMV = TTMV.CODTMV
	LEFT JOIN FTDO ON FTDO.CODCOLIGADA = TTMV.CODCOLIGADA
				  AND (FTDO.CODTDO = TTMV.CODTDOLANDUP OR FTDO.CODTDO = TTMV.CODTDOLANNF)
	LEFT JOIN TCNTPAR ON TCNTPAR.CODCOLIGADA = TTMV.CODCOLIGADA
					 AND (TCNTPAR.CODTMV = TTMV.CODTMV
						  OR TCNTPAR.CODTMVCOMPRA = TTMV.CODTMV)
WHERE --TTMV.CODTMV LIKE '1.2.01' AND 
TTMV.NOME not LIKE '%#Inativo%'
ORDER BY TTMV.CODTMV
