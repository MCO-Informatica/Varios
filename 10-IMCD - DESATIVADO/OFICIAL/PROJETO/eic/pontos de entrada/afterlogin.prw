#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

User Function AfterLogin()
	Local cId	:= ParamIXB[1]
	Local cNome := ParamIXB[2]
	Local vhora := TIME()
	Local cQueryA := " "
	Local cQueryB := " "
	Local cQueryC := " "
	Local vQtdflw1 := vQtdflw2 := vQtdflw3 := 0
	Local vData := DTOC(ddatabase)
	Local cUserFLW := Alltrim(SuperGetMV("ES_USRFLW", .T., ""))
	IF Len(vData) > 8
        vData := DTOS(ddatabase)
	ELSE
		vData := "20"+substr(vData,7,2) + substr(vData,4,2) + substr(vData,1,2)
	ENDIF

	If cId $ cUserFLW  .and. CMODULO == "EIC"

		If Select("QRYA") > 0
			QRYA->( dbCloseArea() )
		EndIf

		If Select("QRYB") > 0
			QRYA->( dbCloseArea() )
		EndIf

		If Select("QRYC") > 0
			QRYA->( dbCloseArea() )
		EndIf

		cQueryA :=   "SELECT COUNT(ZE1_HAWB) AS QTDFLW FROM "+RetSqlName("ZE1")+" ZE1 WHERE ZE1_DT_PRO < '"+vData+"' AND ZE1_DT_CON = ' ' AND D_E_L_E_T_ <> '*' "
		TCQUERY cQueryA NEW ALIAS "QRYA"
		DbSelectArea("QRYA")
		DbGotop()

		If Select("QRYA") > 0
			vQtdflw1 := QRYA->QTDFLW
		Endif


		cQueryB :=   "SELECT COUNT(ZE1_HAWB) AS QTDFLW FROM "+RetSqlName("ZE1")+" ZE1 WHERE ZE1_DT_PRO = '"+vData+"' AND ZE1_DT_CON = ' ' AND D_E_L_E_T_ <> '*'"
		TCQUERY cQueryB NEW ALIAS "QRYB"
		DbSelectArea("QRYB")
		DbGotop()

		If Select("QRYB") > 0
			vQtdflw2 := QRYB->QTDFLW
		Endif

		cQueryC :=   "SELECT COUNT(ZE1_HAWB) AS QTDFLW FROM "+RetSqlName("ZE1")+" ZE1 WHERE ZE1_DT_PRO > '"+vData+"' AND ZE1_DT_CON = ' ' AND D_E_L_E_T_ <> '*'"
		TCQUERY cQueryC NEW ALIAS "QRYC"
		DbSelectArea("QRYC")
		DbGotop()

		If Select("QRYC") > 0
			vQtdflw3 := QRYC->QTDFLW
		Endif

		AVISO("Posição Follow-Ups Diária - "+ DTOC(DATE()), cValToChar(vQtdflw1)+" - Follow-ups Atrasados" + Chr(13) + Chr(10)  + cValToChar(vQtdflw2)+" - Follow-ups para hoje" + Chr(13) + Chr(10)  + cValToChar(vQtdflw3)+" - Follow-ups dentro do prazo", { "Fechar" }, 1)


        /*	ApMsgAlert(cValToChar(vQtdflw1)+" - Follow-ups Atrasados                                                                                    "+ ;
        	           cValToChar(vQtdflw2)+" - Follow-ups para hoje                                                                                    "+ ;
        	           cValToChar(vQtdflw3)+" - Follow-ups dentro do prazo" )
        */
	Endif

	//-----------------------------------------
	//Realiza a alimentação da tabela SM2 com
	//a ptax do dia útil anterior
	//------------------------------------------
	u_ptaxFeeder()
Return
