
#include "protheus.ch"
#Include "TopConn.ch"

User Function VALIDTAB()

	Local aArea := GetArea()
	Local cSql  := ""
	_cTab 		:= M->C7_CODTAB


	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+CA120FORN+CA120LOJ,.f.))

	If SA2->A2_X_TABPR$"S"

		/*dbSelectArea("AIA")
		dbSetOrder(1)
		If dbSeek(xFilial("AIA")+CA120FORN+CA120LOJ+"VL",.f.)
		
		If !AIA->AIA_X_APRO$"S"
			
			MsgAlert("Tabela de preco nao aprovada pela diretoria. Nao serao permitido digitar o pedido de compra.")
			
			_cTab	:=	""
			
		EndIf
		EndIf*/
	
		cSql := "SELECT * FROM "+RetSqlName("AIB")+" AIB WHERE AIB.D_E_L_E_T_=' ' AND AIB.AIB_CODFOR = '"+CA120FORN+"' AND AIB.AIB_LOJFOR = '"+CA120LOJ+"' AND AIB.AIB_CODPRO = '"+IIf(ValType(M->C7_PRODUTO)<>"U",M->C7_PRODUTO,aCols[n][2])+"' "
		
		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf

		TCQuery cSql New Alias "QRY"

		If Empty(QRY->AIB_XSTATS) .OR. QRY->AIB_XSTATS <> "S" 

		MsgAlert("Tabela de preço não aprovada pela diretoria. Não será permitido digitar o pedido de compra.")
		_cTab	:=	" "

		Else 

		_cTab		:= QRY->AIB_CODTAB
		aCols[n][aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRECO"})] := QRY->AIB_PRCCOM

		EndIf

		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf	

Else
	MsgAlert("Fornecedor nao controlado por tabela de precos")
	_cTab := " "
EndIf

RestArea(aArea)

Return _cTab
