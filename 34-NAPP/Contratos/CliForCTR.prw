#Include "Protheus.ch"
#Include "TopConn.ch"

User Function CLiForCTR(cTipo)
	Local aArea := GetArea()
	Local cRet := ""
	Local cSql := ""
	Local cCod := ""

	Default cTipo := 'C'


	If cTipo == 'C'
		cSql := "SELECT CNC_CODIGO+CNC_LOJA FORNECEDOR, CNC_CLIENT+CNC_LOJACL CLIENTE FROM CNC010 WHERE CNC_FILIAL = '"+CN9->CN9_FILIAL+"' AND CNC_NUMERO+CNC_REVISA = '"+CN9->(CN9_NUMERO+CN9_REVISA)+"' AND D_E_L_E_T_ <> '*' "
	ElseIf cTipo == 'D'
		cSql := "SELECT CNC_CODIGO+CNC_LOJA FORNECEDOR, CNC_CLIENT+CNC_LOJACL CLIENTE FROM CNC010 WHERE CNC_FILIAL = '"+M->CND_FILIAL+"' AND CNC_NUMERO+CNC_REVISA = '"+M->(CND_CONTRA+CND_REVISA)+"' AND D_E_L_E_T_ <> '*' "
	Else
		cSql := "SELECT CNC_CODIGO+CNC_LOJA FORNECEDOR, CNC_CLIENT+CNC_LOJACL CLIENTE FROM CNC010 WHERE CNC_FILIAL = '"+CND->CND_FILIAL+"' AND CNC_NUMERO+CNC_REVISA = '"+CND->(CND_CONTRA+CND_REVISA)+"' AND D_E_L_E_T_ <> '*' "
	EndIf

	cSql := ChangeQuery(cSql)

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	TCQuery cSql New Alias "QRY"

	If !Empty(QRY->FORNECEDOR)
		cCod := QRY->FORNECEDOR
		cRet := Posicione("SA2",1,xFilial("SA2")+cCod,"A2_NOME")
	ElseIf !Empty(QRY->CLIENTE)
		cCod := QRY->CLIENTE
		cRet := Posicione("SA1",1,xFilial("SA1")+cCod,"A1_NOME")
	EndIf

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	RestArea(aArea)

Return cRet
