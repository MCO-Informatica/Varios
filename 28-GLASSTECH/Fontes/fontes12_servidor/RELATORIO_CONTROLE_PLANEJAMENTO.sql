

SELECT E2_FILIAL, 	
	   CASE 
			WHEN ZA0_NATURE IS NULL THEN 'N�O CLASSIFICADO'
			ELSE ZA0_NATURE
	   END						 AS CLASSIFICACAO,
	   MIN(E2_EMISSAO)				DT_EMISSAO, 
	   A2_COD+'\'+A2_LOJA			COD_FORNEC, 
	   A2_NOME						RAZAO_SOCIAL, 
	   A2_NREDUZ					NOME_REDUZIDO,
	   SUM(CONVERT(MONEY,E2_VALOR)) VALOR_BRUTO,
	   SUBSTRING(E2_EMISSAO,1,4)	ANO, 
	   SUBSTRING(E2_EMISSAO,5,2)	MES
FROM SE2010 A
		INNER JOIN SA2010 B
			ON(    A.E2_FORNECE = B.A2_COD
			   AND A.E2_LOJA    = B.A2_LOJA
			   AND A.D_E_L_E_T_ = ''
			   AND B.D_E_L_E_T_ = '')
		INNER JOIN ZA0010 D
			ON(    A2_XCLASS    = ZA0_CODIGO
			   AND A2_FILIAL    = '    '
			   AND D.D_E_L_E_T_ = '')
where E2_EMISSAO >= '20210101'
GROUP BY E2_FILIAL, 	
	   CASE 
			WHEN ZA0_NATURE IS NULL THEN 'N�O CLASSIFICADO'
			ELSE ZA0_NATURE
	   END , 
	   A2_COD+'\'+A2_LOJA,
	   A2_NOME,
	   A2_NREDUZ,
	   SUBSTRING(E2_EMISSAO,1,4),
	   SUBSTRING(E2_EMISSAO,5,2)
ORDER BY 8, 9