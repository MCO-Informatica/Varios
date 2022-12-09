#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA300   ºAutor  ³Darcio R. Sporl     º Data ³  08/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte criado para no retorno do Cnab, o sistema procurar o  º±±
±±º          ³titulo provisorio gerado pela venda no site, pegar as infor º±±
±±º          ³macoes do mesmo, exclui-lo gerar o faturamento do pedido,   º±±
±±º          ³para que seja gerado o novo titulo conforme faturamento,    º±±
±±º          ³e baixado o mesmo via Cnab.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 1 - cNosso - Nosso numero                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA300(cIdPed,cNosso,dCred,nValTit,cBanco)

Local aArea		:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSF2	:= SF2->(GetArea())
Local aAreaSZQ	:= SZQ->(GetArea())
Local cQRYTRB	:= ""
Local cQrySC5	:= ""
Local sQrySC6	:= ""
Local cQrySF2	:= ""
Local cPrefix	:= GetNewPar("MV_XPREFHD", "VDI")
Local cNumPed	:= ""
Local cNumGar	:= ""
Local cXnpSite	:= ""
Local aRetFat	:= {}
Local cGerPR	:= GetNewPar("MV_XSITEPR", "0") 
Local cAliasTrb	:= ""   
Local lLog 		:= .F.
Local aRet      := {}
Local cOperNPF	:= GetNewPar("MV_XOPENPF", "61,62")
Local cOperDeliv:= GetNewPar("MV_XOPDELI", "01")
Local lOper 	:= .F.
Local cNatProcAnt:= GetNewPar("MV_XNATANT", "FT010015" )//natureza referente a operações antes do novo ponto de faturamento
Local cNaturez	:= GetNewPar("MV_XNATBOL", "FT010010" )//natureza referente a boleto
Local cCondPag	:= GetNewPar("MV_XCNDBOL", "000" )//condição de pagamento para boleto 

Default dCred	:= Date()
Default nValTit := 0
Default cBanco	:= '341'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorno o titulo referente ao nosso numero³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("QRYTRB") > 0
	DbSelectArea("QRYTRB")
	QRYTRB->(DbCloseArea())
EndIf

If cGerPR == "1" 
	cQRYTRB := "SELECT R_E_C_N_O_ RECTRB "
	cQRYTRB += "FROM " + RetSqlName("SE1") + " "
	cQRYTRB += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
	cQRYTRB += "  AND E1_NUMBCO = '" + cNosso + "' "
	cQRYTRB += "  AND E1_XNPSITE <> '" + Space(TamSX3("E1_XNPSITE")[1]) + "' "
	cQRYTRB += "  AND E1_PREFIXO = '" + cPrefix + "' "
	cQRYTRB += "  AND E1_TIPO = 'PR ' "
	cQRYTRB += "  AND D_E_L_E_T_ = ' ' "
	cAliasTrb	:= "SE1"
Else
	cQRYTRB := "SELECT R_E_C_N_O_ RECTRB "
	cQRYTRB += "FROM " + RetSqlName("SC5") + " "
	cQRYTRB	+= "WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
	cQRYTRB += "  AND C5_XNPSITE = '" + cIdPed + "' "
	cQRYTRB += "  AND D_E_L_E_T_ = ' ' "
	cAliasTrb	:= "SC5"
EndIf
	
cQRYTRB := ChangeQuery(cQRYTRB)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQRYTRB),"QRYTRB",.F.,.T.)
	
DbSelectArea("QRYTRB")
If QRYTRB->(!Eof())
	DbSelectArea(cAliasTrb)
	DbGoTo(QRYTRB->RECTRB)
	
	If cGerPR == "1"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4¿
		//³Pego o numero do pedido criado pelo site³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4Ù
		cXnpSite := SE1->E1_XNPSITE
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
		//³Pego o recno do pedido feito pelo site, para pegar as informacoes do pedido protheus³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù
		cQrySC5 := "SELECT R_E_C_N_O_ RECPED "
		cQrySC5 += "FROM " + RetSqlName("SC5") + " "
		cQrySC5	+= "WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
		cQrySC5 += "  AND C5_XNPSITE = '" + cXnpSite + "' "
		cQrySC5 += "  AND D_E_L_E_T_ = ' ' "
	
		cQrySC5 := ChangeQuery(cQrySC5)
	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC5),"QRYSC5",.F.,.T.)
		DbSelectArea("QRYSC5")
	
		If QRYSC5->(!Eof())
			DbSelectArea("SC5")
			DbGoTo(QRYSC5->RECPED)
			
			cNumPed := SC5->C5_NUM	
			cNumGar := SC5->C5_CHVBPAG
		EndIf
		DbSelectArea("QRYSC5")
		QRYSC5->(DbCloseArea())
	Else
		cXnpSite 	:= SC5->C5_XNPSITE
		cNumPed 	:= SC5->C5_NUM	
		cNumGar 	:= SC5->C5_CHVBPAG	
	EndIf
	
	SC6->( dbSetOrder( 1 ) )
	SC6->( dbSeek( xFilial( 'SC6' ) + SC5->C5_NUM ) )
	While .NOT. SC6->( EOF() ) .AND. SC6->C6_FILIAL == xFilial('SC6') .AND. SC6->C6_NUM == SC5->C5_NUM	
   		If SC6->C6_XOPER $ cOperNPF .OR. SC6->C6_XOPER $ cOperDeliv
   			lOper := .T.
   		Endif
   		SC6->( dbSkip() )
	End
	
	RecLock("SC5",.F.)
	
	If SC5->C5_TIPMOV == "2" //pedido esta como cartão de credito
			SC5->C5_TIPMOV	:= "1"
			If lOper
				SC5->C5_XNATURE := cNaturez
			Else
				SC5->C5_XNATURE := cNatProcAnt
			Endif
			If Empty(SC5->C5_NOTA)
				SC5->C5_CONDPAG	:= cCondPag
			Endif
			SC5->C5_XLINDIG := IIF( cBanco == '237', '237', '341' )
			cObs := SC5->C5_XOBS 
			SC5->C5_XOBS 	:= cObs+CRLF+"Alteração de forma de pagamento devido identificação de pagamento via CNAB, banco: " + cBanco
	ELSE
	
		If lOper
				SC5->C5_XNATURE := cNaturez
		Else
				SC5->C5_XNATURE := cNatProcAnt
		Endif
	
	EndIf

	SC5->(MsUnLock())

	oWsObj := WSHARDWAREAVULSOPROVIDER():New()
	
 	If lOper
	   	lGeraRecibo := .T.
	   	lOk := oWsObj:reciboCnab( cNumPed, Alltrim(cXnpSite), cNosso,DtoS(dCred),lGeraRecibo, nValTit, cBanco )
  	Else
		//Conecta no WS para Distribuir em thread o Faturamento do Pedido
		lOk := oWsObj:faturaCnab(cNumPed, Alltrim(cXnpSite), cNosso, DtoS(dCred), nValTit, cBanco )		
	EndIf

	cSvcError   := GetWSCError()  // Resumo do erro
	cSoapFCode  := GetWSCError(2)  // Soap Fault Code
	cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
	SZQ->(DbSelectArea("SZQ"))
	SZQ->(DbSetOrder(2))
	lLog 	:= SZQ->(DbSeek(xFilial("SZQ")+cIdPed))
	cPedLog := iif(!Empty(cNumGar),cNumGar,cXnpSite) 
	
	If !empty(cSoapFCode)
		//Caso a ocorrência de erro esteja com o fault_code preenchido ,
		//a mesma teve relação com a chamada do serviço . 
		Conout(cSoapFDescr + ' ' + cSoapFCode)
		
		aRet := {}
		Aadd( aRet, .F.)
		Aadd( aRet, "E00016" )
		Aadd( aRet, cPedLog )
		Aadd( aRet, "Falha ao tentar gerar o faturamento")
		U_GTPutOUT(cPedLog,"N",cPedLog,{"GERAÇÃO CNAB",aRet},cXnpSite)
		
		If lLog
			SZQ->(Reclock("SZQ"))
			SZQ->ZQ_OCORREN := "Erro do servidor ao distribuir. FaultCode: "+ cSoapFCode
			SZQ->ZQ_DATA := ddatabase
			SZQ->ZQ_HORA:=time()
			SZQ->(MsUnlock())
			lConsist := .F.
		Endif
		Return
	ElseIf !Empty(cSvcError)
		//Caso a ocorrência não tenha o soap_code preenchido 
		//Ela está relacionada a uma outra falha , 
		//provavelmente local ou interna.                 
		aRet := {}
		Aadd( aRet, .F.)
		Aadd( aRet, "E00016" )
		Aadd( aRet, cPedLog )
		Aadd( aRet, "Falha ao tentar gerar o faturamento "+cSvcError )
		U_GTPutOUT(cPedLog,"N",cPedLog,{"GERAÇÃO CNAB",aRet},cXnpSite)

		Conout(cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVIÇO')
		If lLog
			SZQ->(Reclock("SZQ"))
			SZQ->ZQ_OCORREN := "Falha interna ao distribuir. "
			SZQ->ZQ_DATA := ddatabase
			SZQ->ZQ_HORA:=time()
			SZQ->(MsUnlock())
			lConsist := .F.
		Endif
		Return
	Endif

	If lOk
		U_GTPutIN(cPedLog,"N",cPedLog,.T.,{"U_VNDA190",cXNPSite,cNumPed},cXNPSite)

		If cGerPR == "1"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Garanto que esta posicionado no titulo provisorio³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SE1")
			DbGoTo(QRYTRB->RECTRB)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Excluo o titulo provisorio³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SE1", .F.)
				SE1->(DbDelete())
			SE1->(MsUnLock())
        EndIf   
        
		If lLog
			SZQ->(Reclock("SZQ"))
			SZQ->ZQ_STATUS := "2"
			SZQ->ZQ_OCORREN := "Distribuido com sucesso."
			SZQ->ZQ_DATA := ddatabase
			SZQ->ZQ_HORA:=time()
			SZQ->(MsUnlock())
		Endif

	Else                  
	
		aRet := {}
		Aadd( aRet, .F.)
		Aadd( aRet, "E00016" )
		Aadd( aRet, PedLog )
		Aadd( aRet, "Falha ao tentar gerar o faturamento" )
		U_GTPutOUT(cPedLog,"N",cPedLog,{"GERAÇÃO CNAB",aRet},cXnpSite)

		Conout('Não foi possível comunicação com o Webservice, tentativa de execução de faturamento do CNAB. Favor contatar o Administrador do sistema.')
		If lLog
			SZQ->(Reclock("SZQ"))
			SZQ->ZQ_OCORREN := "Erro de comunicao ao distribuir."
			SZQ->ZQ_DATA := ddatabase
			SZQ->ZQ_HORA:=time()
			SZQ->(MsUnlock())
			lConsist := .F.
		Endif

	EndIf

EndIf

DbSelectArea("QRYTRB")
QRYTRB->(DbCloseArea())

RestArea(aArea)
RestArea(aAreaSZQ)
RestArea(aAreaSE1)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSF2)
Return