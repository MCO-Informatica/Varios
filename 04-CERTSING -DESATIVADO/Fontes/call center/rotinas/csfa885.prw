#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include 'restful.ch'

User Function CSFA885()	
Return

/*/{Protheus.doc} RNLiberaPagto
//WebService REST para ser consumido pelo RightNow
@author robson.goncalves
@since 08/11/2018
@version 1.0
@type class
/*/
WSRESTFUL RNLiberaPagto DESCRIPTION "Liberação de Pagamento - Integração Protheus x RightNow"
WSDATA receiveJson AS String //Json Recebido no corpo da requição

WSMETHOD PUT DESCRIPTION "Liberar Pagamento" WSSYNTAX "/RNLIBERAPAGTO || /RNLIBERAPAGTO/{NIL}"
END WSRESTFUL

/*/{Protheus.doc} PUT
//Método PUT
@author robson.goncalves
@since 08/11/2018
@version 1.0

@type function
/*/
WSMETHOD PUT WSRECEIVE receiveJson WSSERVICE RNLiberaPagto
	Local aHeadStr 		:= {}
	Local aJson 		:= {}
	Local aRet 			:= {'',''}
	Local cEndPoint 	:= ''
	Local cGetResult 	:= ''
	Local cJson 		:= Self:GetContent() // --> Pega a string do JSON

	Local cMV_881_01 	:= 'MV_881_01'
	Local cMV_881_02 	:= 'MV_881_02'
	Local cMV_881_03 	:= 'MV_881_03'
	Local cMV_881_04 	:= 'MV_881_04'
	Local cMV_885_01 	:= 'MV_885_01'
	
	Local cPassword 		:= ''
	Local cPSiteInformado 	:= ''
	Local cPSitePesquisado 	:= ''
	Local cStack 			:= 'Pilha de chamada: RNLIBERAPAGTO()' + CRLF
	Local cReturn 			:= ''
	Local cThread 			:= 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local cToken 			:= ''
	Local cURL 				:= ''
	Local cUser 			:= ''
	Local cXML 				:= ''

	Local lDeserialize
	Local lGet

	Local oFWRest := NIL

	Private o885Result
	Private oJson 	:= NIL
	Private oPSite 	:= Nil 
	Private oObj 	:= {}
	Private lLigaXml := .F.
	 
	// --> Define o tipo de retorno do método.
	::SetContentType("application/json")

	// --> Deserializa a string JSON
	FWJsonDeserialize( cJson, @oJson )

	// --------------------------------------------------------------------------------------------------------
	// --> Ler os dados do objeto para as devidas ações.
	// --> 1º verificar se o token é válido.
	// --> 2º verificar se o número do pedido site existe no Check-Out.
	// --> 3º se token e pedidosite OK. 
	// --> ..abrir um processo paralelo para:
	// --> ....fazer processo para liberar o pagamento.
	// --> ....registrar a ocorrência na tabela PBP.
	// --> ....retornar mensagem de OK.
	// --> ....do contrário, caso não esteja OK uma das duas verificações, devolver mensagem de inconsistência.
	// --------------------------------------------------------------------------------------------------------
	If ValType( oJson )<>'O'
		cReturn := '{"codigo":"303", "mensagem":"Problemas com a estrutura do Json informado."}'
		lbConout( cReturn )
		::SetResponse( cReturn )
		Return .T.
	Endif

	If Type( 'oJson:liberaPagto:token' )<>'C'
		cReturn := '{"codigo":"304", "mensagem":"Problemas ao ler a TAG do token informado."}'
		lbConout( cReturn )
		::SetResponse( cReturn )
		Return .T.
	Endif

	cToken := oJson:liberaPagto:token

	If .NOT. U_rnVldToken( cToken, @aRet, @cStack, cThread )
		cReturn := '{"codigo":"302", "mensagem":"Token invalido, tente novamente. ' + aRet[ 2 ] + ' "}'
		lbConout( cReturn )
		::SetResponse( cReturn )
		Return .T.
	Endif

	If .NOT. GetMv( cMV_881_01, .T. )
		CriarSX6( cMV_881_01, 'C', 'HOST P/ COMUNICACAO COM SERV REST DO CHECK-OUT. CSFA881.','https://checkout.certisign.com.br' )
	Endif

	If .NOT. GetMv( cMV_881_02, .T. )
		CriarSX6( cMV_881_02, 'C', 'ENDPOINT DE COMUNICACAO SERV REST CHECK-OUT. CSFA881.','/rest/api/pedidos' )
	Endif

	If .NOT. GetMv( cMV_881_03, .T. )
		CriarSX6( cMV_881_03, 'C', 'USUARIO DE AUTENTICACAO SERV REST CHECK-OUT. CSFA881.','7516d708-b733-4f5a-aae5-fbb2955c0c45' )
	Endif

	If .NOT. GetMv( cMV_881_04, .T. )
		CriarSX6( cMV_881_04, 'C', 'PASSWORD DE AUTENTICACAO SERV REST CHECK-OUT. CSFA881.','SOwY3RCA9sOSgtM68MxmQQ==' )
	Endif
	
	If .NOT. GetMv( cMV_885_01, .T. )
		CriarSX6( cMV_885_01, 'L', 'LIGAR/DESLIGAR XML NOTIFICA-PEDIDO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif
	
	lLigaXml := GetMv( cMV_885_01 )

	cURL      := GetMv( cMV_881_01, .F. )
	cEndPoint := GetMv( cMV_881_02, .F. )
	cUser     := GetMv( cMV_881_03, .F. )
	cPassword := GetMv( cMV_881_04, .F. )

	If Type( 'oJson:liberaPagto:numeroPedidoSite' )<>'C'
		cReturn := '{"codigo":"305", "mensagem":"Problemas ao ler a TAG do numeroPedidoSite informado."}'
		lbConout( cReturn )
		::SetResponse( cReturn )
		Return .T.
	Endif

	cPSiteInformado := oJson:liberaPagto:numeroPedidoSite

	If ValType( cPSiteInformado )<>'C' .OR. Empty( cPSiteInformado )
		cReturn := '{"codigo":"306", "mensagem":"Nao identificado o pedido site."}'
		lbConout( cReturn )
		::SetResponse( cReturn )
		Return .T.
	Endif
	
	AAdd( aHeadStr, "Content-Type: application/json" )
	AAdd( aHeadStr, "Accept: application/json" )
	AAdd( aHeadStr, "Authorization: Basic " + EnCode64( cUser + ":" + cPassword ) )

	oFWRest := FWRest():New( cURL )
	oFWRest:setPath( cEndPoint + '/' + cPSiteInformado )
	lGet := oFWRest:Get( aHeadStr )

	If lGet
		cGetResult := oFWRest:GetResult()
		If FwJsonDeserialize( cGetResult, @oPSite) .AND. ValType( oPSite )=='A' .AND. Len( oPSite )==1 .AND. Type( 'oPSite[1]:codigo' )=='N'
			If oPSite[ 1 ]:codigo == 500
				cGetResult := '[ ]'
			Endif
		Endif
	Endif

	If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }'
		lDeserialize := FWJsonDeserialize( cGetResult, @o885Result )
	Endif

	If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '{ }' .AND. lDeserialize
		AAdd( oObj, o885Result )
		cPSitePesquisado := Iif(Type("oObj["+Str(1)+"]:numero")=="U","",cValToChar(oObj[1]:numero))

		If cPSitePesquisado <> ''
			AAdd(aJson,{'numero'           ,Iif( Type("oObj[" + Str(1) + "]:numero")          =="U","",cValToChar(oObj[1]:numero))})
			AAdd(aJson,{'linkNFProd'       ,Iif( Type("oObj[" + Str(1) + "]:linkNotaProduto") =="U","",cValToChar(oObj[1]:linkNotaProduto))})
			AAdd(aJson,{'linkNFServ'       ,Iif( Type("oObj[" + Str(1) + "]:linkNotaServico") =="U","",cValToChar(oObj[1]:linkNotaServico))})
			AAdd(aJson,{'linkNFProdEntrega',Iif( Type("oObj[" + Str(1) + "]:linkNotaEntrega") =="U","",cValToChar(oObj[1]:linkNotaEntrega))})
			AAdd(aJson,{'linkReciboPgto'   ,Iif( Type("oObj[" + Str(1) + "]:linkRecibo")      =="U","",cValToChar(oObj[1]:linkRecibo))})
			AAdd(aJson,{'dataFatura'       ,Iif( Type("oObj[" + Str(1) + "]:dataFaturamento") =="U","",cValToChar(oObj[1]:dataFaturamento))})
			AAdd(aJson,{'IDRN'   ,cValToChar(oJson:rightNow:numeroProtocolo)})
			AAdd(aJson,{'IDUSR'  ,cValToChar(oJson:rightNow:userId)})
			AAdd(aJson,{'DATA'   ,Date()})
			AAdd(aJson,{'HORA'   ,Time()})
			AAdd(aJson,{'STATUS' ,'0'})

			/*ALTERAÇÃO EFETUADA POR RAFAEL DOMINGUES EM 19/03/2019*/
			//aqui, analisar se está consultando da forma antiga ou se é da forma nova
			//se for da forma antiga é enviado um XML para NOTIFICA-STATUS-PEDIDO
			//se for da forma nova é enviado um JSON para o NOTIFICA-PAGAMENTO-PEDIDO

			If lLigaXml
				cXML := '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
				cXML += '<listPedidoStatus xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">'
				cXML += '	<code>1</code>'
				cXML += '	<msg></msg>'
				cXML += '	<exception></exception>'
				cXML += '	<pedido>'
				cXML += '		<numero>' + aJson[ 1, 2 ] + '</numero>'
				cXML += '		<status>2</status>'
				cXML += '		<linkNFProd>' + aJson[ 2, 2 ] + '</linkNFProd>'
				cXML += '		<linkNFServ>' + aJson[ 3, 2 ] + '</linkNFServ>'
				cXML += '		<linkNFProdEntrega>' + aJson[ 4, 2 ] + '</linkNFProdEntrega>'
				cXML += '		<linkReciboPgto>' + aJson[ 5, 2 ] + '</linkReciboPgto>'
				cXML += '		<dataFatura>' + aJson[ 6, 2 ] + '</dataFatura>'
				cXML += '		<dataCancelamento></dataCancelamento>'
				cXML += '		<rastreamento></rastreamento>'
				cXML += '	</pedido>'
				cXML += '</listPedidoStatus>'

				lbConout('LIBERA PAGTO ' + cThread + ' WS SOAP NOTIFICA-STATUS-PEDIDO')
				// Fase1 - enviar para HUB liberar.
				// StartJob( 'U_RNLIBPAG', GetEnvServer(), .F., cPSitePesquisado, cXML )
				U_RNLIBPAG( cPSitePesquisado, cXML )

				// Fase2 - gravar o log.
				lbConout('LIBERA PAGTO ' + cThread + ' GRAVAR DADOS EM PBP')
				StartJob( 'U_RNGRLBPG', GetEnvServer(), .F., cJson, aJson, cXML )
			Else//SE NOVO - NOTIFICA-PAGAMENTO-PEDIDO
				cXML := '<?xml version="1.0" encoding="UTF-8"?>'
				cXML += '<NotificaPagamentoPedido xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">'
				cXML += '	<Pagamento>'
				cXML += '		<pedido>'+aJson[1,2]+'</pedido>'
				cXML += '		<observacao>Liberação de Pagamento Automatica ao Gerar Recibo de Pagamento</observacao>'
				//cXML += '		<observacao>Liberação de pagamento manual executada por: '+AllTrim(oJson:rightNow:userId)+' - '+AllTrim(oJson:rightNow:userNome)+', Protocolo: '+AllTrim(oJson:rightNow:numeroProtocolo)+' a pedido do '+AllTrim(oJson:agenteRegistro:agenteId)+' - '+AllTrim(oJson:agenteRegistro:agenteNome)+'</observacao>'
				cXML += '		<linkReciboPgto>'+aJson[5,2]+'</linkReciboPgto>'
				cXML += '	</Pagamento>'
				cXML += '</NotificaPagamentoPedido>'

				lbConout('LIBERA PAGTO ' + cThread + ' WS SOAP NOTIFICA-PAGAMENTO-PEDIDO')
				// Fase1 - enviar para HUB liberar.
				// StartJob( 'U_RNLIBPAG', GetEnvServer(), .F., cPSitePesquisado, cXML )
				U_RNLIBPAG( cPSitePesquisado, cXML )

				// Fase2 - gravar o log.
				lbConout('LIBERA PAGTO ' + cThread + ' GRAVAR DADOS EM PBP')
				StartJob( 'U_RNGRLBPG', GetEnvServer(), .F., cJson, aJson, cXML )
			EndIf
		Else
			cReturn := '{"codigo":"308", "mensagem":"Nao foi possivel compreender o conteudo do Pedido Site informado."}'
			lbConout( cReturn )
			::SetResponse( cReturn )
			Return .T.
		Endif
	Else
		If .NOT. lGet
			lbConout('NAO CONSEGUI FAZER O GET NO CHECK-OUT ' + cThread)
			lbConout('GETLASTERRO: ' + o881Rest:GetLastError() )
		Endif
		If cGetResult == '[ ]'
			lbConout('NAO CONSEGUI OBTER O GETRESULT NO CHECK-OUT ' + cThread)
			lbConout('GETLASTERRO: ' + o881Rest:GetLastError() )
		Endif
		If .NOT. lDeserialize
			lbConout('NA THREAD ' + cThread + ' HOUVE ERRO NA SINTAXE JSON ENTREGUE PELO CHECK-OUT')
			lbConout('GETRESULT: ' + cGetResult )
		Endif
		cReturn := '{"codigo":"307", "mensagem":"Nao foi possivel validar o Pedido Site informado."}'
		lbConout( cReturn )
		::SetResponse( cReturn )
		Return .T.
	Endif

	/*
	oJson:liberaPagto:numeroPedidoSite
	oJson:liberaPagto:token

	oJson:rightNow:numeroProtocolo
	oJson:rightNow:userId
	oJson:rightNow:userNome

	oJson:agenteRegistro:agenteId
	oJson:agenteRegistro:agenteNome
	oJson:agenteRegistro:agenteCPF
	oJson:agenteRegistro:agenteEmail

	oJson:agenteRegistro:entidade:acDescricao
	oJson:agenteRegistro:entidade:arCNPJ
	oJson:agenteRegistro:entidade:arDescricao
	oJson:agenteRegistro:entidade:arId
	oJson:agenteRegistro:entidade:arMunicipio
	oJson:agenteRegistro:entidade:arUF
	oJson:agenteRegistro:entidade:postoId
	oJson:agenteRegistro:entidade:postoDescricao
	oJson:agenteRegistro:entidade:postoCNPJ
	oJson:agenteRegistro:entidade:postoEndereco
	oJson:agenteRegistro:entidade:postoCEP
	oJson:agenteRegistro:entidade:postoCidade
	oJson:agenteRegistro:entidade:postoUF
	oJson:agenteRegistro:entidade:postoOrganizacional
	*/

	// --> Retorno de um objeto Json.
	cReturn := '{"codigo":"301", "mensagem":"Autenticacao valida e processo de liberacao de pagamento iniciado."}'
	lbConout( cReturn )
	::SetResponse( cReturn )

	lbConout('Processo "RNLiberaPagto" finalizado.')
Return .T. 

STATIC aEnv := Iif( ( Lower( GetEnvServer() ) == 'postgres' ), {'99','01'}, {'01','02'} )

/*/{Protheus.doc} RnLibPag
//Função acionada por StartJob para liberar o pagamento junto ao HUB.
@author robson.goncalves
@since 08/11/2018
@version 1.0

@type function
/*/
User Function RnLibPag( cNumPedSite, cXML )
	Local cCategory 	:= Iif(lLigaXml,'NOTIFICA-STATUS-PEDIDO','NOTIFICA-PAGAMENTO-PEDIDO')
	Local cError 		:= ''
	Local cSoapFCode 	:= ''
	Local cSoapFDescr 	:= ''
	Local cSvcError 	:= ''
	Local cWarning 		:= ''
	Local lOk 			:= .T.
	Local oWsRes 		:= Nil
	Local oWsObj 		:= Nil

	If aEnv[ 1 ] == '99'
		lbConout('Warning - Configured for company [99] branch [01]')
	Endif

	oWsObj 		:= WSVVHubServiceService():New()
	lOk 		:= oWsObj:sendMessage( cCategory, cXML )
	cSvcError 	:= GetWSCError() 	// Resumo do erro
	cSoapFCode 	:= GetWSCError(2) 	// Soap Fault Code
	cSoapFDescr := GetWSCError(3) 	// Soap Fault Description

	If .NOT. Empty( cSoapFCode )
		//Caso a ocorrência de erro esteja com o fault_code preenchido, a mesma teve relação com a chamada do serviço . 
		Conout( cSoapFDescr + ' ' + cSoapFCode )
		U_GTPutOUT( cNumPedSite,"G",cNumPedSite,{"U_CSFA885",{.F.,"A885-4",cNumPedSite,"Inconsistência ao informar pagamento ao HUB. Não foi possível comunicação com o HUB: " + cSoapFDescr + ' ' + cSoapFCode }},cNumPedSite)
		Return( .F. )
	Elseif .NOT. Empty( cSvcError )
		//Caso a ocorrência não tenha o soap_code preenchido ela está relacionada a uma outra falha, provavelmente local ou interna.
		Conout( cSvcError + ' FALHA INTERNA DE EXECUCAO DO SERVIÇO' )
		U_GTPutOUT( cNumPedSite,"G",cNumPedSite,{"U_CSFA885",{.F.,"A885-5",cNumPedSite,"Inconsistência ao informar pagamento ao HUB. Não foi possível comunicação com o HUB: " + cSvcError }},cNumPedSite)
		Return( .F. )
	Endif

	If lOk
		oWsRes := XmlParser( oWsObj:CSENDMESSAGERESPONSE, "_", @cError, @cWarning )
		If 'confirmaType' $ oWSObj:CSENDMESSAGERESPONSE
			If oWsRes:_CONFIRMATYPE:_CODE:TEXT == '1'
				U_GTPutOUT( cNumPedSite,"G",cNumPedSite,{"U_CSFA885",{.T.,"A885-0",cNumPedSite,"Pagamento enviado ao HUB com sucesso"}},cNumPedSite )
			Else
				U_GTPutOUT( cNumPedSite,"G",cNumPedSite,{"U_CSFA885",{.F.,"A885-3",cNumPedSite,"Inconsistência ao informar pagamento ao HUB "+oWsRes:_CONFIRMATYPE:_MSG:TEXT}},cNumPedSite)
			Endif
		Else
			U_GTPutOUT( cNumPedSite,"G",cNumPedSite,{"U_CSFA885",{.F.,"A885-2",cNumPedSite,"Inconsistência ao informar pagamento ao HUB. Não foi possível comunicação com o HUB"}},cNumPedSite)
		Endif
	Else
		U_GTPutOUT( cNumPedSite,"G",cNumPedSite,{"U_CSFA885",{.F.,"A885-1",cNumPedSite,"Inconsistência ao informar pagamento ao HUB. Não foi possível comunicação com o HUB"}},cNumPedSite)
	Endif

	lbConout('Processo "RnLibPag" finalizado.')
Return

/*/{Protheus.doc} RnGrLbPg
//Função acionada por StartJob para gravar o registro de liberar o pagamento. 
@author robson.goncalves
@since 08/11/2018
@version 1.0

@type function
/*/
User Function RnGrLbPg( cJson, aJson, cXML )
	Local nP_Data := 0
	Local nP_Hora := 0

	Private oMyJson

	If aEnv[ 1 ] == '99'
		lbConout('Warning - Configured for company [99] branch [01]')
	Endif

	RpcSetType( 3 )
	RpcSetEnv( aEnv[1], aEnv[2] )

	If Select( 'PBP' ) == 0
		ChkFile( 'PBP', .F. )
	Endif

	nP_Data := AScan(aJson,{|e| e[1]=='DATA'})
	nP_Hora := AScan(aJson,{|e| e[1]=='HORA'})

	FWJsonDeserialize( cJson, @oMyJson )

	dbSelectArea('PBP')
	PBP->( dbSetOrder( 1 ) )
	PBP->( RecLock( 'PBP', .T. ) )
	PBP->PBP_FILIAL := xFilial( 'PBP' )
	PBP->PBP_PSITE  := Iif(Type('oMyJson:liberaPagto:numeroPedidoSite')=='U','',cValToChar(oMyJson:liberaPagto:numeroPedidoSite))
	PBP->PBP_ID_RN  := Iif(Type('oMyJson:rightNow:numeroProtocolo')=='U','',cValToChar(oMyJson:rightNow:numeroProtocolo))
	PBP->PBP_DATA   := Iif(nP_Data>0,aJson[nP_Data,2],Date())
	PBP->PBP_HORA   := Iif(nP_Hora>0,aJson[nP_Hora,2],Time())
	PBP->PBP_STATUS := '0'        //0       ; 1                  ; 2
	PBP->PBP_DESCRI := 'INSERIDO' //INSERIDO; PROCESSADO LIBERADO; PROCESSADO E NAO LIBERADO.
	PBP->PBP_ID_USR := Iif(Type('oMyJson:rightNow:userId')=='U','',cValToChar(oMyJson:rightNow:userId))
	PBP->PBP_NOMUSR := Iif(Type('oMyJson:rightNow:userNome')=='U','',cValToChar(oMyJson:rightNow:userNome))
	PBP->PBP_RECEBI := cJson
	PBP->PBP_ENVIAD := cXML
	PBP->(MsUnLock())

	RpcClearEnv()

	lbConout('Processo "RnGrLbPg" finalizado.')
Return

Static Function lbConout( cString )
	Conout( '[' + Dtoc(Date()) + ' ' + Time() + '] P12xRN-Lib.Pag.: ' + cString )
Return




//***************************************************************************************
//***                                                                                 ***
//*** AS ROTINAS ABAIXO SÃO PARA EFEUTAR TESTES DAS ROTINAS AUXILIARES DO WEB SERVICE ***
//***                                                                                 ***
//***************************************************************************************

User Function My885a()
	Local cJsonTst 		:= ""
	Local cToken 		:= ""
	Local cUser 		:= enCode64('Protheus.RightNow')
	Local cPass 		:= enCode64('4b#8YPD!F_Qm')
	Local o885Rst 		:= NIL
	Local o885Rslt	 	:= NIL
	Local oObj 			:= ""
	Local aHead 		:= {}
		
	// Fazer conexão de autenticação para obter o token.
	AAdd( aHead, "Content-Type: application/json" )
	AAdd( aHead, "Accept: application/json" )

	o885Rst := FWRest():New( "http://localhost:8084/RightNow" )
	o885Rst:setPath( "/RNAUTENTICAR/UHJvdGhldXMuUmlnaHROb3c=/NGIjOFlQRCFGX1Ft" )

	If o885Rst:Get(aHead)
		cGetResult := o885Rst:GetResult()

		If cGetResult <> '[ ]'
			If FWJsonDeserialize( cGetResult, @o885Rslt )
				If ValType( o885Rslt ) == 'A'
					oObj := AClone( o885Rslt )
				Else
					oObj := {}
					AAdd( oObj, o885Rslt )
				Endif

				cToken := oObj[1]:token

				cJsonTst += '{' 
				cJsonTst += '	"liberaPagto":{' 
				cJsonTst += '		"token":"'+cToken+'",' 
				cJsonTst += '		"numeroPedidoSite":"9082601"' 
				cJsonTst += '	},' 
				cJsonTst += '	"rightNow":{' 
				cJsonTst += '		"numeroProtocolo":"19032800271",' 
				cJsonTst += '		"userId":"2311",' 
				cJsonTst += '		"userNome":"Alessandra Borin Rodrigues" '
				cJsonTst += '	},' 
				cJsonTst += '	"agenteRegistro":{' 
				cJsonTst += '		"agenteId":"000002",' 
				cJsonTst += '		"agenteNome":"Jose da  Silva",' 
				cJsonTst += '		"agenteCPF":"29865031876",' 
				cJsonTst += '		"agenteEmail":"valor",' 
				cJsonTst += '		"entidade":{' 
				cJsonTst += '			"acDescricao":"valor",' 
				cJsonTst += '			"arId":"valor",' 
				cJsonTst += '			"arDescricao":"valor",' 
				cJsonTst += '			"arCNPJ":"valor",' 
				cJsonTst += '			"arMunicipio":"valor",' 
				cJsonTst += '			"arUF":"valor",'
				cJsonTst += '			"postoId":"valor",' 
				cJsonTst += '			"postoDescricao":"valor",' 
				cJsonTst += '			"postoCNPJ":"valor",' 
				cJsonTst += '			"postoCidade":"valor",' 
				cJsonTst += '			"postoUF":"valor",' 
				cJsonTst += '			"postoCEP":"valor", '
				cJsonTst += '			"postoEndereco":"valor",' 
				cJsonTst += '			"postoOrganizacional":"valor"' 
				cJsonTst += '		}' 
				cJsonTst += '	}' 
				cJsonTst += '}'

			EndIf
		EndIf
	EndIf
	
	o885Rst := FWRest():New( "http://localhost:8084/RightNow" )
	o885Rst:setPath( "/RNLIBERAPAGTO/" )
	//o885Rst:SetPostParams(cJsonTst)
		
	If o885Rst:Put(aHead,cJsonTst)
		cGetResult := o885Rst:GetResult()
	Else
		cGetResult := o885Rst:GetLastError()
	EndIf
	
	MsgInfo(cGetResult)
		
Return
