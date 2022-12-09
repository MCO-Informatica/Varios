#INCLUDE "PROTHEUS.CH"

USER Function BSCSA5(cProduto)
Local aAreaAtual := {}
Local aRet := {}
Default cProduto :=""

aAreaAtual := GETAREA()
if !Empty(cProduto)
	
	cAliasX := GetNextAlias()
	
	BeginSql alias cAliasX
		
		SELECT A2_COD, A2_LOJA, A2_NOME,SA2.A2_NREDUZ FROM SA2020 FORN
		WHERE A2_COD||A2_LOJA IN (
		SELECT DISTINCT A5_FABR||A5_FALOJA FABR  FROM SA5020 FABR
		WHERE A5_PRODUTO = cProduto
		AND FABR.D_E_L_E_T_ <> '*' )
		AND FORN.D_E_L_E_T_ <> '*'
		
		
	EndSql
	
	CursorWait()
	
	aCat := {}
	
	While (cAliasX)->(!Eof())
		
//		aAdd(aRet , { (cAliasX)->A2_COD,(cAliasX)->A2_LOJA,Alltrim((cAliasX)->A2_NOME),Alltrim((cAliasX)->SA2.A2_NREDUZ) })
		aAdd( aLinha, {"C6_VALOR"   , NOROUND(ZX4->ZX4_VALOR,2)       		,Nil})

		(cAliasX)->(DBSKIP())
		
	Enddo
	CursorArrow()
	
	
Endif


RestArea(aAreaAtual)

RETURN(aRet)
