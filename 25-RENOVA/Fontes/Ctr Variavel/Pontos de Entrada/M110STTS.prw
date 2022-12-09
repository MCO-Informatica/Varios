#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} M110STTS
Função executada ao confirmar a solicitação de compra, vai verificar os campos de contrato e ajustar o FLAG
@type User_function
@version  1
@author Junior Placido
@since 28/05/2021
/*/
User Function M110STTS()
	Local cNumSol   := Paramixb[1]
	Local aArea     := GetArea()
	Local cSql      := ""
	//Local cContra  := ""
	cSql := "SELECT * FROM "+RetSqlName("SC1")+" SC1 WHERE SC1.C1_NUM = '"+cNumSol+"' AND SC1.D_E_L_E_T_<> '*' AND SC1.C1_XCONTRA <> ' ' AND SC1.C1_FLAGGCT <> '1' " //Busca solicitação
	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	TCQuery cSql New Alias "QRY"

	If !lCopia .AND. FunName() == "ALTESP"
		cSql := "UPDATE "+RetSqlName("SC1")+" SC1 SET SC1.C1_FLAGGCT = '1', SC1.C1_XCONTRA = '"+QRY->C1_XCONTRA+"' WHERE SC1.C1_NUM = '"+QRY->C1_NUM+"' AND SC1.D_E_L_E_T_<> '*' " //Busca solicitação
		TcSqlExec(cSql)
	EndIf

	/*
	While !QRY->(EOF())
		If !Empty(QRY->C1_XCONTRA)
            cContra := QRY->C1_XCONTRA
		EndIf
		RecLock("SC1",.F.)
		SC1->C1_FLAGGCT := "1"
        SC1->C1_XCONTRA := cContra
		SC1->(MsUnlock())
		QRY->(DbSkip())
	End
	*/

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	RestArea(aArea)
Return Nil
