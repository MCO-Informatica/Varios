#Include "Protheus.ch"
#Include "TopConn.ch"


User Function VldCC(cTab,cConta)
	Local lRet  := .T.
	Local cProd := ""

	Default cTab   := ""
	Default cConta := ""

	If Empty(cConta)
		If cTab == "SC1"
			cProd  := M->C1_PRODUTO
			cConta := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_CONTA")
            lRet   := !VldConta(cConta)

		ElseIf cTab == "SC7"
			cProd  := M->C7_PRODUTO
            cConta := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_CONTA")
            lRet   := !VldConta(cConta)

		ElseIf cTab == "SD1"
			cProd  := M->D1_COD
            cConta := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_CONTA")
            lRet   := !VldConta(cConta)

		Else

        MsgAlert("Parametros invalidos","Atencao")
        Return lRet			

		EndIf
	Else

        lRet := !VldConta(cConta)

	EndIf


Return lRet



Static Function VldConta(cConta)
	Local lRet := .F.
	Local cSql := ""

	cSql := "SELECT * FROM "+RetSqlName("CT1")+" CT1 WHERE CT1.D_E_L_E_T_=' ' AND CT1_CONTA = '"+cConta+"' "

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	TcQuery cSql New Alias "QRY"

	If !Empty(QRY->CT1_CCOBRG) .AND. QRY->CT1_CCOBRG == "1"
		lRet := .T.
		MsgInfo("É Obrigatório informar o centro de custo para esta conta contabil!","Atenção")
	EndIf

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

Return lRet
