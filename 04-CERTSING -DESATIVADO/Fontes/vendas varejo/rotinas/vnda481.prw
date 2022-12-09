#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA340   �Autor  �Darcio R. Sporl     � Data �  31/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte criado para informar ao HUB sobre as notificacoes de  ���
���          �pagamentos dos titulos baixados no Protheus referente aos   ���
���          �pedidos provenientes do GAR.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VNDA481(aRecPed,aRecTit,cObserv,aVouch)
Local cCategory := "NOTIFICA-PAGAMENTO-PEDIDO"
Local cError	:= ""
Local cWarning	:= ""
Local lOk		:= .T.
Local oWsObj
Local oWsRes
Local cQuery	:= ""
Local cEndCli	:= ""
Local aEndCli	:= {}
Local cEnd		:= ""
Local cNumero	:= ""
Local cComple	:= ""
Local cBairro	:= ""
Local cCidade	:= ""
Local cCep		:= ""
Local cEstado	:= ""
Local cPais		:= ""
Local cNomPais	:= ""
Local cNota		:= ""
Local cSerie	:= ""
Local cXml		:= ""
Local cData		:= ""
Local cAno		:= ""
Local cDia		:= ""
Local cMes		:= ""
Local nI		:= 0
//De-Para [1]Origem Protheus x [2]Origem HUB
Local aOrigemPv := {	{"2","1"},; //2=Varejo
						{"3","2"},; //3=Hard.Avulso
						{"7","3"},; //7=Port.Assinat.
						{"8","4"},; //8=Cursos
						{"9","5"},; //9=Port.SSL
						{"0","6"},; //0=Pto.Movel
						{"A","7"},; //A=GAR Novo
						{"B","8"}	}//B=Prodest
Local nPosOrig	:= 0

Default aRecPed	:= {}
Default aRecTit	:= {}
Default aVouch	:= {}
Default cObserv := 'Libera��o manual'

If Len(aRecPed) > 0

	For nI:=1 to Len(aRecPed)
	    
	    SC5->(DbGoTo(aRecPed[nI]))
		cPedLog := SC5->C5_XNPSITE
		
			cXml := XML_VERSION + CRLF
			cXml += '<NotificaPagamentoPedido xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF
			
			U_GTPutIN(cPedLog,"G",cPedLog,.T.,{"U_VNDA481",cPedLog,SC5->C5_NUM},SC5->C5_XNPSITE)
			
			cXml += '	<Pagamento>' + CRLF
			cXml += '		<pedido>' + Alltrim(SC5->C5_XNPSITE) + '</pedido>' + CRLF
			If Len(aRecTit) >= nI
				SE1->(DbGoTo(aRecTit[nI]))
				cXml += '		<observacao>' +cObserv+'. Historico do Titulo: '+Alltrim(SE1->E1_HIST) + '</observacao>' + CRLF
			Else
				cXml += '		<observacao>' +cObserv+'</observacao>' + CRLF		
			EndIf
			cXml += '		<linkReciboPgto>'+Alltrim(SC5->C5_XRECPG)+'</linkReciboPgto>' + CRLF
						
			cXml += '	</Pagamento>' + CRLF
			cXml += '</NotificaPagamentoPedido>' + CRLF
		
			oWsObj := WSVVHubServiceService():New()
		
			lOk := oWsObj:sendMessage(cCategory,cXml)
		
			cSvcError   := GetWSCError()  // Resumo do erro
			cSoapFCode  := GetWSCError(2)  // Soap Fault Code
			cSoapFDescr := GetWSCError(3)  // Soap Fault Description
			
			If !empty(cSoapFCode)
				//Caso a ocorr�ncia de erro esteja com o fault_code preenchido ,
				//a mesma teve rela��o com a chamada do servi�o . 
				Conout(cSoapFDescr + ' ' + cSoapFCode)
			ElseIf !Empty(cSvcError)      
				//Caso a ocorr�ncia n�o tenha o soap_code preenchido 
				//Ela est� relacionada a uma outra falha , 
				//provavelmente local ou interna.
				Conout(cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVI�O')
			Endif
		
			If lOk
				oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
		
				If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
					If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
						lOk :=.T.
						U_GTPutOUT(cPedLog,"G",cPedLog,{"U_VNDA481",{.T.,"M00001",cPedLog,"Pagamento Informado ao Gar enviado ao HUB com Sucesso"}},SC5->C5_XNPSITE)
					Else
						Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
						lOk :=.F.
						U_GTPutOUT(cPedLog,"G",cPedLog,{"U_VNDA481",{.F.,"E00001",cPedLog,"Inconsist�ncia ao informar Pagamento ao Gar "+oWsRes:_CONFIRMATYPE:_MSG:TEXT}},SC5->C5_XNPSITE)
					EndIf
				Else
					lOk :=.F.
					U_GTPutOUT(cPedLog,"G",cPedLog,{"U_VNDA481",{.F.,"E00001",cPedLog,"Inconsist�ncia ao informar Pagamento ao Gar. N�o foi poss�vel comunica��o com o HUB"}},SC5->C5_XNPSITE)
					Conout('N�o foi poss�vel comunica��o com o HUB, ent�o n�o foi poss�vel notificar os pagamentos dos pedidos no site Vendas Varejo. Favor contatar o Administrador do sistema.')
				EndIf
			Else
				U_GTPutOUT(cPedLog,"G",cPedLog,{"U_VNDA481",{.F.,"E00001",cPedLog,"Inconsist�ncia ao informar Pagamento ao Gar. N�o foi poss�vel comunica��o com o HUB"}},SC5->C5_XNPSITE)
				lOk :=.F.
				Conout('N�o foi poss�vel comunica��o com o HUB, ent�o n�o foi poss�vel notificar os pagamentos dos pedidos no site Vendas Varejo. Favor contatar o Administrador do sistema.')
			EndIf
		
	Next

ElseIf Len(aVouch) >= 5
	
	cXml := XML_VERSION + CRLF
	cXml += '<NotificaPagamentoPedido xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">' + CRLF
	U_GTPutIN(aVouch[3],"G",aVouch[3],.T.,{"U_VNDA481",aVouch[3],aVouch[4]},aVouch[4])
	
	cXml += '	<Pagamento>' + CRLF
	cXml += '		<pedido>' + Alltrim(aVouch[4]) + '</pedido>' + CRLF
	cXml += '		<observacao>'+cObserv+'</observacao>' + CRLF
	cXml += '		<linkReciboPgto></linkReciboPgto>' + CRLF		
	cXml += '	</Pagamento>' + CRLF
	
	cXml += '</NotificaPagamentoPedido>' + CRLF
	
	oWsObj := WSVVHubServiceService():New()

	lOk := oWsObj:sendMessage(cCategory,cXml)

	cSvcError   := GetWSCError()  // Resumo do erro
	cSoapFCode  := GetWSCError(2)  // Soap Fault Code
	cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
	If !empty(cSoapFCode)
		//Caso a ocorr�ncia de erro esteja com o fault_code preenchido ,
		//a mesma teve rela��o com a chamada do servi�o . 
		Conout(cSoapFDescr + ' ' + cSoapFCode)
		Return(.f.)
	ElseIf !Empty(cSvcError)
		//Caso a ocorr�ncia n�o tenha o soap_code preenchido 
		//Ela est� relacionada a uma outra falha , 
		//provavelmente local ou interna.
		Conout(cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVI�O')
		Return(.F.)
	Endif

	If lOk
		oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )

		If "confirmaType" $ oWSObj:CSENDMESSAGERESPONSE
			If oWsRes:_CONFIRMATYPE:_CODE:TEXT == "1"
				lOk :=.T.
				U_GTPutOUT(aVouch[3],"G",aVouch[3],{"U_VNDA481",{.T.,"M00001",aVouch[3],"Pagamento Informado ao Gar enviado ao HUB com Sucesso"}},aVouch[4])
			Else
				Conout(oWsRes:_CONFIRMATYPE:_MSG:TEXT)
				lOk :=.F.
				U_GTPutOUT(aVouch[3],"G",aVouch[3],{"U_VNDA481",{.F.,"E00001",aVouch[3],"Inconsist�ncia ao informar Pagamento ao Gar "+oWsRes:_CONFIRMATYPE:_MSG:TEXT}},aVouch[4])
			EndIf
		Else
			lOk :=.F.
			U_GTPutOUT(aVouch[3],"G",aVouch[3],{"U_VNDA481",{.F.,"E00001",aVouch[3],"Inconsist�ncia ao informar Pagamento ao Gar. N�o foi poss�vel comunica��o com o HUB"}},aVouch[4])
			Conout('N�o foi poss�vel comunica��o com o HUB, ent�o n�o foi poss�vel notificar os pagamentos dos pedidos no site Vendas Varejo. Favor contatar o Administrador do sistema.')
		EndIf
	Else
		U_GTPutOUT(aVouch[3],"G",aVouch[3],{"U_VNDA481",{.F.,"E00001",aVouch[3],"Inconsist�ncia ao informar Pagamento ao Gar. N�o foi poss�vel comunica��o com o HUB"}},aVouch[4])
		lOk :=.F.
		Conout('N�o foi poss�vel comunica��o com o HUB, ent�o n�o foi poss�vel notificar os pagamentos dos pedidos no site Vendas Varejo. Favor contatar o Administrador do sistema.')
	EndIf

EndIf

Return(lOk)