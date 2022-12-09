#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

/*/{Protheus.doc} VNDA331

Funcao criada para enviar a notificacao do Status dos Pedidos ao HUB para pedidos
cancelados através da rotina do Service Desk e/ou Consumo de Voucher  

@author Rafael Beghini - Totvs
@since 15.04.2016
@version P11

/*/

User Function VNDA331(aParSch)

Local cCategory := ""
Local cError	:= ""
Local cWarning	:= ""
Local lOk		:= .T.
Local oWsObj
Local oWsRes
Local cQrySC5	:= ""
Local cData		:= ""
Local cAno		:= ""
Local cMes		:= ""
Local cDia		:= ""
Local cQryCAN	:= ""
Local cDataC	:= ""
Local cAnoC		:= ""
Local cMesC		:= ""
Local cDiaC		:= ""
Local cDocument	:= ""
Local cRet		:= ""
Local aPedidos	:= {}
Local cJobEmp	:= aParSch[1]
Local cJobFil	:= aParSch[2]
Local cXNPSITE := aParSch[3]
Local cPEDSITE := ''
Local cNUMPED := ''
Local cTIPO   := ''
Local cDataProc := ""
Local _lJob 	:= (Select('SX6')==0)

Local aDADOS   := StrToKarr( cXNPSITE, ';' )
cPEDSITE := aDADOS[1]
cNUMPED  := aDADOS[2]
cTIPO    := aDADOS[3]
cTPMSG   := aDADOS[4]
cOBS	 := aDADOS[5]

If _lJob
	RpcSetType(3)
	RpcSetEnv(cJobEmp, cJobFil)
EndIf
	                 
cDataProc := SuperGetMV( "MV_X330DTP",, "" )

IF cTIPO == 'F'	
	
	cQryCAN := "SELECT C5_XNPSITE, C6_XNFCANC, C6_XDTCANC, C6_XHRCANC, SC6.R_E_C_N_O_ C6REC, SC5.R_E_C_N_O_ C5REC "
	cQryCAN += "FROM " + RetSqlName("SC5") + " SC5 "
	cQryCAN += "INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' AND SC6.C6_XNFCANC = 'S' "
	cQryCAN += "WHERE SC5.C5_FILIAL = '" + xFilial("SC5") + "' "
	cQryCAN += "  AND C5_XNPSITE = '" + cPEDSITE + "' "
	cQryCAN += "  AND SC5.D_E_L_E_T_ = ' ' "

	cQryCAN := ChangeQuery(cQryCAN)
	
	If Select("QRYCAN") > 0
		DbSelectArea("QRYCAN")
		QRYCAN->(DbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryCAN),"QRYCAN",.F.,.T.)
	
	TCSETFIELD("QRYCAN","C6_XDTCANC","D",8,0)
	
	DbSelectArea("QRYCAN")
	
	If QRYCAN->(!Eof())
		oWsObj := WSVVHubServiceService():New()
		cCategory := "NOTIFICA-CANCELAMENTO-PEDIDO"
		
		While QRYCAN->(!Eof())
			cJsonCan:= ""
			
			SC5->(DbGoTo(QRYCAN->C5REC))
			SC6->(DbGoTo(QRYCAN->C6REC))
			
			cJsonCan:= '{"pedido":'+QRYCAN->C5_XNPSITE+',"data":"'+Left(DtoS(QRYCAN->C6_XDTCANC),4)+'-'+SubStr(DtoS(QRYCAN->C6_XDTCANC),5,2)+'-'+Right(DtoS(QRYCAN->C6_XDTCANC),2)+'T'+QRYCAN->C6_XHRCANC+'","motivo":"'+cTPMSG+'","observacao":"'+Alltrim(cOBS)+'"}'
			lOk := oWsObj:sendMessage(cCategory,cJsonCan)

			cSvcError   := GetWSCError()  // Resumo do erro
			cSoapFCode  := GetWSCError(2)  // Soap Fault Code
			cSoapFDescr := GetWSCError(3)  // Soap Fault Description
			
			If !empty(cSoapFCode)
				//Caso a ocorrência de erro esteja com o fault_code preenchido ,
				//a mesma teve relação com a chamada do serviço . 
				Conout('VNDA330 > ' + cSoapFDescr + ' ' + cSoapFCode)
				Return
			ElseIf !Empty(cSvcError)
				//Caso a ocorrência não tenha o soap_code preenchido 
				//Ela está relacionada a uma outra falha , 
				//provavelmente local ou interna.
				Conout('VNDA330 > ' + cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVIÇO')
				Return
			Endif
			
			If lOk
				oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
				If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
					If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
						RecLock("SC6", .F.)
							Replace SC6->C6_XFLAGEN With "X"
						SC6->(MsUnLock())
						
						RecLock("SC5", .F.)
							Replace SC5->C5_XFLAGEN With "X"
						SC5->(MsUnLock())
						
						Conout('VNDA330 > ' + oWsRes:_CONFIRMATYPE:_MSG:TEXT)
					Else	
						Conout('VNDA330 > ' + oWsRes:_CONFIRMATYPE:_MSG:TEXT)
					EndIf
				Else
					Conout('VNDA330 > Não foi possível comunicação com o HUB, então não foi notificar os status dos pedidos no site Vendas Varejo (CANCELAMENTO VOUCHER). Favor contatar o Administrador do sistema.')
				EndIf
			Else
				Conout('VNDA330 > Não foi possível comunicação com o HUB, então não foi notificar os status dos pedidos no site Vendas Varejo (CANCELAMENTO VOUCHER). Favor contatar o Administrador do sistema.')
			EndIf
				
			QRYCAN->(DbSkip())
		EndDo
		
		FreeObj(oWsObj)
	EndIf
	QRYCAN->(DbCloseArea())

Else
	oWsObj := WSVVHubServiceService():New()
	cCategory := "NOTIFICA-CANCELAMENTO-PEDIDO"
		
	aPedidos := {}
	aAdd(aPedidos, cPEDSITE)
	
	cAnoC	:= StrZero(Year(DdataBase),4)
	cMesC	:= StrZero(Month(DdataBase),2)
	cDiaC	:= StrZero(Day(DdataBase),2)
	cDataC	:= cAnoC + "-" + cMesC + "-" + cDiaC 
	
	cJsonCan:= '{"pedido":'+cPEDSITE+',"data":"'+cDataC+'T'+Time()+'","motivo":"'+cTPMSG+'","observacao":"'+cOBS+'"}'
	lOk := oWsObj:sendMessage(cCategory,cJsonCan)
		
	cSvcError   := GetWSCError()  // Resumo do erro
	cSoapFCode  := GetWSCError(2)  // Soap Fault Code
	cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
	If !empty(cSoapFCode)
		//Caso a ocorrência de erro esteja com o fault_code preenchido ,
		//a mesma teve relação com a chamada do serviço . 
		Conout('VNDA331 > ' + cSoapFDescr + ' ' + cSoapFCode)
		Return
	ElseIf !Empty(cSvcError)
		//Caso a ocorrência não tenha o soap_code preenchido 
		//Ela está relacionada a uma outra falha , 
		//provavelmente local ou interna.
		Conout('VNDA331 > ' + cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVIÇO')
		Return
	Endif

	If lOk
		oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
		If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
			If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
				DbSelectArea("SC5")
				SC5->(DbOrderNickName("PEDSITE"))
				If DbSeek(xFilial("SC5") + cPEDSITE)
					SC5->( RecLock("SC5", .F.) )
						Replace SC5->C5_XFLAGEN With "X"
					SC5->( MsUnLock() )	
				EndIf
				
				SZG->( dbSetOrder(3) )
				SZG->( dbSeek( xFilial('SZG') + cPEDSITE ) )
				IF SZG->( Found() )
					SZG->( RecLock("SZG", .F.) )
						Replace SZG->ZG_XFLAGEN With "X"
					SZG->( MsUnLock() )	 
				Endif
				Conout('VNDA331 > ' + oWsRes:_CONFIRMATYPE:_MSG:TEXT)
			Else	
				Conout('VNDA331 > ' + oWsRes:_CONFIRMATYPE:_MSG:TEXT)
			EndIf
		Else
			Conout('VNDA331 > Não foi possível comunicação com o HUB, então não foi notificar os status dos pedidos no site Vendas Varejo (CANCELAMENTO VOUCHER). Favor contatar o Administrador do sistema.')
		EndIf
	Else
		Conout('VNDA331 > Não foi possível comunicação com o HUB, então não foi notificar os status dos pedidos no site Vendas Varejo (CANCELAMENTO VOUCHER). Favor contatar o Administrador do sistema.')
	EndIf
	
EndIF

Return