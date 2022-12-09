#Include "Protheus.ch"
#Include "Ap5Mail.ch"
#Include "TbiConn.ch"
#Include "Totvs.ch"

#Define lGTOUT_NOK					.F.
#Define lHUB_MENSAGEM				.T.
#Define nTOTAL_TENTATIVA			30
#Define nTEMPO_AGUARDO				2000
#Define cGT_TIPO_S   				"S" 
#Define cGT_TIPO_E   				"E" 
#Define cSTATUS_ERRO				"0"
#Define cSTATUS_OK 					"1"
#Define cSTATUS_FILA 				"2"
#Define cGT_GAR_METODO 				"SENDMESSAGE"
#Define cERRO_FILA_DISTRIBUICAO 	"Inconsistência realizar distribuição"
#Define cERRO_GTOUT_00001 			"E00001"
#Define cERRO_GTOUT_00002 			"E00002"
#Define cERRO_GTOUT_00023 			"E00023"
#Define cMSG_GTOUT_00001 			"M00001"
#Define cROTINA_GRAVA_SZ5			"U_GARA130J"
#Define cEVENTO_VERIFICACAO 		"GETVERGAR"
#Define cEVENTO_VALIDACAO 			"GETVLDGAR"
#Define cEVENTO_EMISSAO 			"GETEMIGAR"
#Define cEVENTO_ENVIA_PEDIDO_GAR	"ENVIA-PEDIDO-GAR"
#Define cEVENTO_VERIFICACAO_SZ5		"VERIFI"
#Define cEVENTO_VALIDACAO_SZ5		"VALIDA"
#Define cEVENTO_EMISSAO_SZ5			"EMISSA"
#Define cXML_VERSION 				'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
#Define cXML_RETORNO_OK 	 		cXML_VERSION + CRLF + ;
				 					'<confirmaType>' + CRLF + ;
									'		<code>1</code>' + CRLF	 + ;
									'		<msg>Pedido Distribuido para Processamento</msg>' + CRLF + ;
									'		<exception></exception>' + CRLF + ;
									'</confirmaType>' + CRLF // 1=sucesso na operação; 0=erro
#Define cXML_RETORNO_ERRO_1 		cXML_VERSION + CRLF + ;
									'<confirmaType>' + CRLF + ;
									'		<code>0</code>' + CRLF + ;
									'		<msg>Pedido não foi processado</msg>' + CRLF + ;
									'		<exception>Código de Pedido Gar não enviado</exception>' + CRLF + ;
									'</confirmaType>' + CRLF // 1=sucesso na operação; 0=erro
#Define cXML_RETORNO_ERRO_2 		cXML_VERSION + CRLF + ; 
									'<confirmaType>' + CRLF + ; 
									'		<code>0</code>' + CRLF + ; 	// 1=sucesso na operação; 0=erro
									'		<msg>Pedidos não foram faturados.</msg>' + CRLF + ; 
									'		<exception>Falha de comunicação.</exception>' + CRLF + ; 
									'</confirmaType>' + CRLF
#Define cXML_RETORNO_ERRO_3 		cXML_VERSION + CRLF + ; 
									'<confirmaType>' + CRLF + ; 
									'		<code>0</code>' + CRLF + ; 	// 1=sucesso na operação; 0=erro
									'		<msg>Pedido não foi processado</msg>' + CRLF + ; 
									'		<exception>%ERRO%</exception>' + CRLF + ; 
									'</confirmaType>' + CRLF 
#Define cXML_RETORNO_ERRO_4 		cXML_VERSION + CRLF + ;
									'<confirmaType>' + CRLF + ;
									'		<code>0</code>' + CRLF + ;
									'		<msg>Pedido não foi processado</msg>' + CRLF + ;
									'		<exception>Não conseguiu travar registro</exception>' + CRLF + ;
									'</confirmaType>' + CRLF // 1=sucesso na operação; 0=erro									

/*/{Protheus.doc} MensagemHUB
@author    bruno.nunes
@since     09/01/2021
@version   P12
/*/   
class MensagemHUB
	data cPedidoGar	 		as string
	data cPedidoSite 		as string
	data cPedidoEcommerce 	as string
	data cPedidoProtheus 	as string
	data cPedidoItemPedido 	as string
	data cPedidoLog			as string
	data cProtocolo			as string
	data lVinculo			as logical
	data cCodigoMensagemGT	as string
	data cCodigoAssuntoGT	as string
	data cMensagemGT	    as string
	data cXML				as string
	data oXml				as object
	data cEvento			as string
	data cEventoSZ5 		as string
	data aListaSZ5			as array
	data cXMLError			as string
	data cXMLWarning		as string
	data cMensagemRetorno	as string
	data oGTMsg 			as object
	data lGravouSZ5			as logical

	method New( pcXML ) constructor
	method InicializaListaSZ5()
	method ParseXML()
	method GravarXMLHUB( pcEvento )
	method SetListaSZ5()
	method GetXMLPedidoGAR()
	method GetXMLHUB( cpEvento )	
	method GravarSZ5()
	method GravarPC3()
	method SetStatus( pcStatus )
	method GravarGTIN()
	method GravarGTOUT()
	method MensagemTerminal()
	method EnviarEmail()
	method ProcessarXML( pcEvento )
	method EnviarPedidoGAR()
	method ExcedeuGTOutE00023()
	method AtualizarData()
endclass

/*/{Protheus.doc} New
Metodo construtor
@author    bruno.nunes
@since     15/05/2020
@version   P12
/*/
method New( pcXML ) class MensagemHUB as object
	::oGTMsg			:= MensagemGT():New()
	::cXML				:= pcXML
	::cPedidoGar	 	:= ""
	::cPedidoSite 		:= ""
	::cPedidoItemPedido := ""
	::cPedidoLog        := ""
	::cCodigoMensagemGT	:= ""
	::cCodigoAssuntoGT  := ""
	::cMensagemGT	    := ""
	::cProtocolo 		:= ""
	::lVinculo          := .F.	
	::cEvento			:= ""
	::aListaSZ5			:= {}
	::cXMLError			:= ""
	::cXMLWarning		:= ""
	::cMensagemRetorno	:= ""
	::lGravouSZ5		:= .F.
	::cEventoSZ5		:= ""
return self

/*/{Protheus.doc} GravarXMLHUB
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method GravarXMLHUB( pcEvento ) class MensagemHUB as String
	::cMensagemRetorno := ""
	::cEvento          := pcEvento
	//U_GTPutRet( Lower( ::cEvento ) ,'A') //##TODO - Passar para classe

	if ::cEvento == cEVENTO_ENVIA_PEDIDO_GAR
		::cEventoSZ5 := ""
	elseif ::cEvento == cEVENTO_VERIFICACAO
		::cEventoSZ5 := cEVENTO_VERIFICACAO_SZ5
	elseif ::cEvento == cEVENTO_VALIDACAO
		::cEventoSZ5 := cEVENTO_VALIDACAO_SZ5
	elseif ::cEvento == cEVENTO_EMISSAO
		::cEventoSZ5 := cEVENTO_EMISSAO_SZ5
	endif

	::ParseXML() //Grava log de erro do parse
	::GetXMLPedidoGAR() //Pedidgo GAR
	::MensagemTerminal( "GravarXMLHUB: " + ::cPedidoGar )

	if empty( ::cMensagemRetorno )
		::GravarPC3()
	endif
return ::cMensagemRetorno

/*/{Protheus.doc} ParseXML
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method ParseXML() class MensagemHUB as String
	local cXml 		:=  ""
	Local bVldPed	:= {|a,b| IIf(!Empty(a),a,b)} 

	if ::cEvento == cEVENTO_ENVIA_PEDIDO_GAR
		::oXml := XmlParser( cXml, "_", @::cXMLError, @::cXMLWarning )
		If !empty( ::cXMLError )
			::cMensagemRetorno := Replace( cXML_RETORNO_ERRO_3, "%ERRO%", ::cXMLError )
		else
			::oXml := XmlGetChild( ::oXml:_LISTPEDIDOGARTYPE:_PEDIDO, 1 )
			::cPedidoSite := ::oXml:_NUMERO:TEXT 
			::cPedidoLog  := Eval(bVldPed, ::cPedidoGar, ::cPedidoSite ) 
			::cPedidoItemPedido := ::oXml:_NUMEROPEDIDOITEM:TEXT
			if ValType( XmlChildEx( ::oXml, "_PROTOCOLO") ) == 'O' 
				::cProtocolo := Alltrim( ::oXml:_PROTOCOLO:TEXT ) 
			endif 
		EndIf
	else
		cXml   := cXML_VERSION + ::cXML
		cXml   := Replace( cXml, '&', 'E')
		::oXml := XmlParser( cXml, "_", @::cXMLError, @::cXMLWarning )
		If !empty( ::cXMLError )
			::cMensagemRetorno := Replace( cXML_RETORNO_ERRO_3, "%ERRO%", ::cXMLError )
		else
			::oXml := XmlGetChild( ::oXml:_PURCHASEORDER:_ADDITIONALINFORMATION, 1 )
		EndIf
	endif
return empty( ::cMensagemRetorno ) 

/*/{Protheus.doc} GetXMLPedidoGAR
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method GetXMLPedidoGAR() class MensagemHUB as logical
	if ::cEvento == cEVENTO_ENVIA_PEDIDO_GAR
		if Valtype(oXml:_LISTPEDIDOGARTYPE:_PEDIDO) != "A" 
			XmlNode2Arr( oXml:_LISTPEDIDOGARTYPE:_PEDIDO , "_PEDIDO" ) 
		endif 
		::cPedidoGar := AllTrim( ::oXml:_NUMEROPEDIDOGAR:TEXT )
	else
		::cPedidoGar := AllTrim( ::oXml:_Z5PEDGAR:TEXT )
	endif
	If Empty( ::cPedidoGar )
		::cMensagemRetorno := cXML_RETORNO_ERRO_1
	EndIf
return empty( ::cMensagemRetorno )

/*/{Protheus.doc} SetListaSZ5
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method SetListaSZ5() class MensagemHUB as Undefinied
	local oXMLAux := ::oXml
	local oCampo  := nil
	local cNode   := ""
	local i	  := 0

	//Adiciona dados do XML para array
	For i := 1 to Len( ::aListaSZ5 )
	
		XmlNode2Arr( oXMLAux, "" )
		cNode     := "_" + StrTran( ::aListaSZ5[ i, 1 ], "_", "" )
		oCampo    := XmlChildEx( oXMLAux, cNode )
		cTipoDado := Valtype( ::aListaSZ5[ i, 2 ] )
		If ValType( oCampo ) != "U"
			//Tratamento especial para esse tipo de campo em emissao
			If cNode == "_Z5VLDCERT"
				oCampo    := XmlChildEx( oXMLAux, "_Z5DATEXP" )
				if ValType( oCampo ) != "U"
					::aInfoSZ5[ i, 2 ] := StoD( StrTran( oCampo:TEXT, "-", "" ) )
				endif
			ElseIf cNode == "_Z5PEDGAR"
				::aListaSZ5[ i, 2 ] := Padr( oCampo:TEXT , TamSX3( "Z5_PEDGAR" )[ 1 ] ) 
			Else
				If cTipoDado == "C"
					::aListaSZ5[ i, 2 ] := oCampo:TEXT
				ElseIf cTipoDado == "N"
					::aListaSZ5[ i, 2 ] := Val( oCampo:TEXT )
				ElseIf cTipoDado == "D"
					::aListaSZ5[ i, 2 ] :=  StoD( StrTran( oCampo:TEXT, "-", "" ) )
				EndIf
			EndIf
		EndIf
	Next
return 


/*/{Protheus.doc} InicializaListaSZ5
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method InicializaListaSZ5() class MensagemHUB as Undefinied
	::aListaSZ5 := {}

	//Validacao - Dados Gerais
	aadd( ::aListaSZ5,{"Z5_PEDGAR" ,""})
	aadd( ::aListaSZ5,{"Z5_DATPED" ,StoD("")})
	aadd( ::aListaSZ5,{"Z5_EMISSAO",StoD("")})
	aadd( ::aListaSZ5,{"Z5_RENOVA" ,StoD("")})
	aadd( ::aListaSZ5,{"Z5_REVOGA" ,StoD("")})
	aadd( ::aListaSZ5,{"Z5_DATVAL" ,StoD("")})
	aadd( ::aListaSZ5,{"Z5_HORVAL" ,""})
	aadd( ::aListaSZ5,{"Z5_CNPJ"   ,""})
	aadd( ::aListaSZ5,{"Z5_CNPJCER",""})
	aadd( ::aListaSZ5,{"Z5_NOMREC" ,""})
	aadd( ::aListaSZ5,{"Z5_DATPAG" ,StoD("")})
	aadd( ::aListaSZ5,{"Z5_VALOR"  ,0})
	aadd( ::aListaSZ5,{"Z5_TIPMOV" ,""})
	aadd( ::aListaSZ5,{"Z5_STATUS" ,""})
	aadd( ::aListaSZ5,{"Z5_CODAR"  ,""})
	aadd( ::aListaSZ5,{"Z5_DESCAR" ,""})
	aadd( ::aListaSZ5,{"Z5_CODPOS" ,""})
	aadd( ::aListaSZ5,{"Z5_DESPOS" ,""})
	aadd( ::aListaSZ5,{"Z5_CODAGE" ,""})
	aadd( ::aListaSZ5,{"Z5_NOMAGE" ,""})
	aadd( ::aListaSZ5,{"Z5_CPFAGE" ,""})
	aadd( ::aListaSZ5,{"Z5_CERTIF" ,""})
	aadd( ::aListaSZ5,{"Z5_PRODUTO",""})
	aadd( ::aListaSZ5,{"Z5_DESPRO" ,""})
	aadd( ::aListaSZ5,{"Z5_GRUPO"  ,""})
	aadd( ::aListaSZ5,{"Z5_DESGRU" ,""})
	aadd( ::aListaSZ5,{"Z5_STATUS" ,""})
	aadd( ::aListaSZ5,{"Z5_GARANT" ,""})
	aadd( ::aListaSZ5,{"Z5_TIPVOU" ,""})
	aadd( ::aListaSZ5,{"Z5_CODVOU" ,""})
	aadd( ::aListaSZ5,{"Z5_CODAC"  ,""})
	aadd( ::aListaSZ5,{"Z5_DESCAC" ,""})
	aadd( ::aListaSZ5,{"Z5_CODARP" ,""})
	aadd( ::aListaSZ5,{"Z5_DESCARP",""})
	aadd( ::aListaSZ5,{"Z5_REDE"   ,""})
	aadd( ::aListaSZ5,{"Z5_CPFT"   ,""})
	aadd( ::aListaSZ5,{"Z5_NTITULA",""})
	aadd( ::aListaSZ5,{"Z5_CNPJV"  ,0})
	aadd( ::aListaSZ5,{"Z5_TABELA" ,""})
	aadd( ::aListaSZ5,{"Z5_VALORSW",0})
	aadd( ::aListaSZ5,{"Z5_VALORHW",0})

	if ::cEvento == cEVENTO_VERIFICACAO
		//Verificacao
		aadd( ::aListaSZ5,{"Z5_DATVER" ,StoD("")})
		aadd( ::aListaSZ5,{"Z5_HORVER" ,""})
		aadd( ::aListaSZ5,{"Z5_POSVER" ,""})
		aadd( ::aListaSZ5,{"Z5_AGVER"  ,""})
		aadd( ::aListaSZ5,{"Z5_NOAGVER",""})
		aadd( ::aListaSZ5,{"Z5_CODPAR" ,""})
		aadd( ::aListaSZ5,{"Z5_NOMPAR" ,""})
		aadd( ::aListaSZ5,{"Z5_CODVEND",""})
		aadd( ::aListaSZ5,{"Z5_NOMVEND",""})
		aadd( ::aListaSZ5,{"Z5_VENATV" ,""})
	elseif ::cEvento == cEVENTO_EMISSAO
		//Verificacao
		aadd( ::aListaSZ5,{"Z5_DATVER",StoD("")})
		aadd( ::aListaSZ5,{"Z5_HORVER",""})
		aadd( ::aListaSZ5,{"Z5_POSVER",""})
		aadd( ::aListaSZ5,{"Z5_AGVER",""})
		aadd( ::aListaSZ5,{"Z5_NOAGVER",""})

		//Emissao
		aadd( ::aListaSZ5,{"Z5_DATEMIS",StoD("")})
		aadd( ::aListaSZ5,{"Z5_HOREMIS",""})
		aadd( ::aListaSZ5,{"Z5_POSEMIS",""})
		aadd( ::aListaSZ5,{"Z5_AGEMIS",""})
		aadd( ::aListaSZ5,{"Z5_NOAGEMI",""})
		aadd( ::aListaSZ5,{"Z5_ORIEMIS",""})
		aadd( ::aListaSZ5,{"Z5_UFDOCTI",""})
		aadd( ::aListaSZ5,{"Z5_VLDCERT",StoD("")})
		aadd( ::aListaSZ5,{"Z5_TELTIT",""})
		aadd( ::aListaSZ5,{"Z5_NOMCTO",""})
		aadd( ::aListaSZ5,{"Z5_TELCTO",""})
		aadd( ::aListaSZ5,{"Z5_MAICTO",""})
		aadd( ::aListaSZ5,{"Z5_PEDGANT" ,""})
	endif
return

/*/{Protheus.doc} GravarSZ5
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method GravarSZ5() class MensagemHUB as logical
	local i     := 0

	//Tenta gravar
	for i := 1 to nTOTAL_TENTATIVA
		//If U_Send2Proc( ::cPedidoGar, cROTINA_GRAVA_SZ5, ::cPedidoGar, ::aListaSZ5, lHUB_MENSAGEM, ::cEventoSZ5 )
		If U_GARA130J( ::cPedidoGar, ::cPedidoGar, ::aListaSZ5, lHUB_MENSAGEM, ::cEventoSZ5 )
			::GravarGTIN() 
			::cMensagemRetorno := cXML_RETORNO_OK
			::lGravouSZ5 := .T.
			::SetStatus( cSTATUS_OK )
			Exit
		EndIf

		// Espera um pouco ( 5 segundos ) para tentar novamente
		Sleep( nTEMPO_AGUARDO )
	next i

	If !( ::lGravouSZ5 ) 
		::GravarGTOUT()
		::cMensagemRetorno := cXML_RETORNO_ERRO_2
		::SetStatus( cSTATUS_ERRO  )
	Endif
return ::lGravouSZ5

/*/{Protheus.doc} GravaGTIN
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method GravarGTIN() class MensagemHUB as logical
	::oGTMsg:SetMensagem( { ::cEvento, ::cPedidoGar, ::cXML } )
	::oGTMsg:AddGTIn( ::cPedidoGar, cGT_TIPO_E, ::cPedidoGar )
return

/*/{Protheus.doc} GravaGTOUT
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method GravarGTOUT() class MensagemHUB as logical
	::oGTMsg:SetMensagem( { ::cEvento, { lGTOUT_NOK, cERRO_GTOUT_00002, ::cPedidoGar, cERRO_FILA_DISTRIBUICAO } } )
	::oGTMsg:AddGTOut( ::cPedidoGar, cGT_TIPO_E, ::cPedidoGar )
return

/*/{Protheus.doc} GravarPC3
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method GravarPC3() class MensagemHUB as logical
	local cChavePC3 := ""
	local lGravou   := .F.
	local nTry 		:=  0
	local nTotTry 	:=  3
	local lTravou 	:= .F.
	local cSemaforo := "PC3" + ::cPedidoGar

	if empty( ::cPedidoGar )
		return lGravou
	endif 

	//Conseguiu travar o pedido GAR
	while nTry < nTotTry 
		nTry++
		if lTravou := LockByName( cSemaforo, .F., .F. ) 
			exit
		endif
		sleep(1000)
	end

	if lTravou
		cChavePC3 := xFilial( "PC3" ) + ::cPedidoGar

		PC3->( dbSetOrder( 1 ) )
		if PC3->( dbSeek( cChavePC3 ) )
			RecLock( "PC3", .F. )
		else
			RecLock( "PC3", .T. )
			PC3->PC3_PEDGAR := ::cPedidoGar
			PC3->PC3_DATINC := dDatabase
			PC3->PC3_HORINC := Time()
		endif
		PC3->PC3_PEDSIT := ::cPedidoSite
		PC3->PC3_PEDECO	:= ::cPedidoEcommerce
		PC3->PC3_DATALT := dDatabase
		PC3->PC3_HORALT := Time()
		if ::cEvento == cEVENTO_ENVIA_PEDIDO_GAR
			PC3->PC3_ENPEGA := ::cXML
			PC3->PC3_STPEGA := cSTATUS_FILA
		elseif ::cEvento == cEVENTO_VALIDACAO
			PC3->PC3_VLDGAR := ::cXML
			PC3->PC3_STAVLD := cSTATUS_FILA
		elseif ::cEvento == cEVENTO_VERIFICACAO
			PC3->PC3_VERGAR := ::cXML
			PC3->PC3_STAVER := cSTATUS_FILA
		elseif ::cEvento == cEVENTO_EMISSAO
			PC3->PC3_EMIGAR := ::cXML
			PC3->PC3_STAEMI := cSTATUS_FILA
		elseif ::cEvento == cEVENTO_ENVIA_PEDIDO_GAR
			PC3->PC3_ENPEGA := ::cXML
		endif
		PC3->(MsUnLock())
		::AtualizarData()
		::cMensagemRetorno := cXML_RETORNO_OK
		UnLockByName( cSemaforo ) 
	else
		::cMensagemRetorno := cXML_RETORNO_ERRO_4
	endif
return lGravou

/*/{Protheus.doc} GetXMLHUB
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method GetXMLHUB( cpEvento ) class MensagemHUB as Undefinied
	local cXML := ""
	local lXML    := .F.
	if !empty( ::cPedidoGar )
		PC3->( dbSetOrder( 1 ) )
		if PC3->( dbSeek( xFilial("PC3") + ::cPedidoGar ) )
			if cpEvento == cEVENTO_VERIFICACAO
				cXML := PC3->PC3_VERGAR
			elseif cpEvento == cEVENTO_VALIDACAO
				cXML := PC3->PC3_VLDGAR
			elseif cpEvento == cEVENTO_EMISSAO
				cXML := PC3->PC3_EMIGAR
			endif	
			if lXML := !empty( cXML )
				::cXML := cXML
			endif
		endif
	endif
return lXML

/*/{Protheus.doc} SetStatus
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method SetStatus( pcStatus ) class MensagemHUB as string
	if !empty( pcStatus )
		PC3->( dbSetOrder( 1 ) )
		if PC3->( dbSeek( xFilial("PC3") + ::cPedidoGar ) )
			RecLock( "PC3", .F. )
			if ::cEvento == cEVENTO_VERIFICACAO
				PC3->PC3_STAVER := pcStatus
			elseif ::cEvento == cEVENTO_VALIDACAO
				PC3->PC3_STAVLD := pcStatus
			elseif ::cEvento == cEVENTO_EMISSAO
				PC3->PC3_STAEMI := pcStatus
			elseif ::cEvento == cEVENTO_ENVIA_PEDIDO_GAR
				PC3->PC3_STPEGA  := pcStatus
			endif	
			PC3->(MsUnLock())
			::AtualizarData()
		endif
	endif
return 

/*/{Protheus.doc} MensagemTerminal
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method MensagemTerminal( cMsg ) class MensagemHUB as Undefinied
	local cMsgCompleta := "[ MensagemHUB ]"
	cMsgCompleta += "[ Thread: " + cValToChar( ThreadId() ) + " ]"
	cMsgCompleta += "[ Time: " + Time() + " ]" 
	cMsgCompleta += "[ Evento: " + ::cEvento + " ]" 
	cMsgCompleta += "[ " + cMsg + " ]"
	conout( cMsgCompleta )
return

/*/{Protheus.doc} EnviarEmail
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method EnviarEmail() class MensagemHUB as Undefinied
	oLog := CSLog():New()
	oLog:SetAssunto( "[ MensagemHUB ]" )
	oLog:AddLog( "Processado o pedido GAR:" + ::cPedidoGar  )
	oLog:AddLog( "Evento:" + ::cEvento  )
	oLog:EnviarLog()
return

/*/{Protheus.doc} ProcessarXML
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method ProcessarXML( pcEvento ) class MensagemHUB as String
	::cMensagemRetorno := ""
	::cEvento          := pcEvento

	if ::cEvento == cEVENTO_VERIFICACAO
		::cEventoSZ5 := cEVENTO_VERIFICACAO_SZ5
	elseif ::cEvento == cEVENTO_VALIDACAO
		::cEventoSZ5 := cEVENTO_VALIDACAO_SZ5
	elseif ::cEvento == cEVENTO_EMISSAO
		::cEventoSZ5 := cEVENTO_EMISSAO_SZ5
	endif

	::ParseXML() //Grava log de erro do parse
	::GetXMLPedidoGAR() //Pedidgo GAR
	::InicializaListaSZ5()
	::MensagemTerminal( "ProcessarXML: " + ::cPedidoGar )

	if empty( ::cMensagemRetorno )
		//Formata e carrega dados para gravar na SZ5
		::SetListaSZ5()

		//Grava dados na SZ5
		::GravarSZ5()
	endif
return ::cMensagemRetorno

/*/{Protheus.doc} EnviarPedidoGAR
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method EnviarPedidoGAR() class MensagemHUB as Undefinied
	local lOk := .F.
	local cMsgAux := ""
	local cMsgTipo := ""
	local cItemAnt := SC6->C6_XIDPED 
	local cXIDPedo := "" 
	local lAtuSC5  := .T. 	

	::ParseXML()
	::GetXMLPedidoGAR()
	::MensagemTerminal( "[ EnviarPedidoGAR ][ PedidoGar: " + ::cPedidoGar + " ][ Pedido Site: " + ::cPedidoSite + " ] " )	
	
	if !empty( ::cMensagemRetorno )
		Return
	endif
	
	//Grava GTIN
	::oGTMsg:SetMensagem( { cGT_GAR_METODO, ::cPedidoLog, cEVENTO_ENVIA_PEDIDO_GAR, ::cXML } )
	::oGTMsg:AddGTIn( ::cPedidoLog, cGT_TIPO_S, ::cPedidoSite )

	If !Empty( ::cPedidoGar ) .and. !Empty( ::cPedidoSite ) 
		//Posicionar indices
		SC5->(DbOrderNickName("PEDSITE")) 
		SZG->( DbSetOrder(3) )
		If PLSALIASEX("Z11") 
			Z11->(DbSetOrder(2)) 
		EndIf 

		If SC5->( DbSeek(xFilial('SC5') + ::cPedidoSite ) ) 
			If Empty(::cPedidoItemPedido) 
				If lOk := Empty(SC5->C5_CHVBPAG) 

					SC5->(Reclock("SC5",.F.)) 
					SC5->C5_CHVBPAG := ::cPedidoGAR 
					SC5->(MsUnlock()) 

					cMsgAux := "Informado pedido GAR com Sucesso"
				Else 
					cMsgAux := "Pedido GAR já informado"
				EndIf 
				cMsgTipo := cMSG_GTOUT_00001
			Else 
				SC6->(DbSetOrder(1)) 
				If lOk := SC6->(DbSeeK(xFilial("SC6")+SC5->C5_NUM)) 
					cItemAnt := SC6->C6_XIDPED 
					cXIDPedo := "" 
					lAtuSC5  := .T. 

					While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM 
						//Garante que não ï¿½ legado 
						If !Empty(SC6->C6_XIDPED) .and. Alltrim(SC6->C6_XIDPED) <> Alltrim(cItemAnt)  
							lAtuSC5 := .F. 
						EndIf 

						//Para SKU sem composicao (ex. KT) ira atualizar todos os itens. 
						//Pï¿½ra SKU com composicao (ex. CER) ira atulizar um item e guarda o numero do ID do pai. 
						If Empty(SC6->C6_XIDPED) .or. Alltrim(SC6->C6_XIDPED) == Alltrim(::cPedidoItemPedido) 
							SC6->(RecLock("SC6",.F.)) 
							SC6->C6_PEDGAR	:= ::cPedidoGar 
							cXIDPedo		:= SC6->C6_XIDPEDO //Id do item pai 
							SC6->(MsUnlock()) 
						EndIf 

						SC6->(DbSkip()) 
					End 

					//Nesse caso ï¿½ um SKU com composicao entï¿½o atualiza os demais itens do SKU. 
					IF !Empty( cXIDPedo ) 
						SC6->( dbGotop() ) 
						SC6->( DbSetOrder(1) ) 
						IF SC6->(DbSeeK(xFilial("SC6")+SC5->C5_NUM)) 
							While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6")+SC5->C5_NUM 
								IF SC6->C6_XIDPEDO == cXIDPedo 
									SC6->(RecLock("SC6",.F.)) 
									SC6->C6_PEDGAR := ::cPedidoGar	 
									SC6->(MsUnlock()) 
								EndIF 
								SC6->( DbSkip() ) 
							End 
						EndIF 
					EndIF 

					//Legado 
					If lAtuSC5 
						SC5->(Reclock("SC5",.F.)) 
						SC5->C5_CHVBPAG := ::cPedidoGar 
						SC5->(MsUnlock()) 
					Endif 

					cMsgAux := "Informado pedido GAR com Sucesso"
					cMsgTipo := cMSG_GTOUT_00001
					//U_GTPutOUT(cID,"S",::cPedidoLog,{"SENDMESSAGE",{.T.,"M00001",::cPedidoLog, "ENVIA-PEDIDO-GAR", "Informado pedido GAR com Sucesso",::xml}},::cPedidoSite) 
				EndIf 
			EndIf 
		ElseIf SZG->(DbSeek(xFilial("SZG") + ::cPedidoSite ) ) 

			If lOk := Empty(SZG->ZG_NUMPED) 
				SZG->(Reclock("SZG",.F.)) 
				SZG->ZG_NUMPED := ::cPedidoGar 
				SZG->(MsUnlock()) 

				cMsgAux := "Informado pedido GAR com Sucesso para o voucher "+SZG->ZG_NUMVOUC

				//U_GTPutOUT(cID,"S",::cPedidoLog,{"SENDMESSAGE",{.T.,"M00001",::cPedidoLog, "ENVIA-PEDIDO-GAR", ,::xml}},::cPedidoSite) 
			Else 
				cMsgAux := "Pedido GAR já informado para o voucher "+SZG->ZG_NUMVOUC
				//U_GTPutOUT(cID,"S",::cPedidoLog,{"SENDMESSAGE",{.F.,"M00001",::cPedidoLog, "ENVIA-PEDIDO-GAR","Pedido GAR já informado para o voucher "+SZG->ZG_NUMVOUC,::xml}},::cPedidoSite) 
			EndIf 
			cMsgTipo := cMSG_GTOUT_00001

		ElseIf PLSALIASEX("Z11") .and. Z11->(DbSeek(xFilial("Z11")+::cPedidoSite)) 
			If lOk := Empty(Z11->Z11_PEDGAR) 

				Z11->(Reclock("Z11",.F.)) 
				Z11->Z11_PEDGAR := ::cPedidoGar 
				Z11->(MsUnlock()) 

				Z12->(DbSetOrder(2)) 
				Z12->(DbSeek(xFilial("Z12")+::cPedidoSite)) 

				While !Z12->(EoF()) .and. Alltrim(Z12->(Z12_FILIAL+Z12_PEDSIT)) == Alltrim(xFilial("Z12")+::cPedidoSite) 
					Z12->(Reclock("Z12",.F.)) 
					Z12->Z12_PEDGAR := ::cPedidoGar 
					Z12->(MsUnlock()) 
					Z12->(DbSkip()) 
				EndDo 

				cMsgAux := "Informado pedido GAR com Sucesso"
				//U_GTPutOUT(cID,"S",::cPedidoLog,{"SENDMESSAGE",{.T.,"M00001",::cPedidoLog, "ENVIA-PEDIDO-GAR","Informado pedido GAR com Sucesso",::xml}},::cPedidoSite) 
			Else 
				cMsgAux := "Pedido GAR já informado na DUA"
				//U_GTPutOUT(cID,"S",::cPedidoLog,{"SENDMESSAGE",{.F.,"M00001",::cPedidoLog, "ENVIA-PEDIDO-GAR","Pedido GAR já informado na DUA",::xml}},::cPedidoSite) 
			EndIf 
			cMsgTipo := cMSG_GTOUT_00001
		Else
			lOk := .F.
			cMsgAux := "Pedido GAR não encontrado" 
			If ExcedeuGTOutE00023()
				cMsgTipo := cERRO_GTOUT_00001 
			else
				cMsgTipo := cERRO_GTOUT_00023 
			EndIf 

			cMsgRet:= "Pedido GAR não encontrado" 
			cPedOut+= ::cPedidoSite+"," 
			cStatus:= "0" 
		EndIf 

		IF !Empty( ::cProtocolo ) 
			ADE->( dbSetOrder(1) ) 
			IF ADE->( dbSeek(xFilial('ADE') + ::cProtocolo) ) 
				msgCon( 'PEDIGO GAR ORIGEM 9(SAC), Gravando protocolo ' + ::cProtocolo) 
				ADE->( Reclock("ADE",.F.) ) 
				ADE->ADE_PEDGAR := ::cPedidoGar 
				ADE->(MsUnlock()) 
			EndIF 
		EndIF						 
	else 
		lOk := .F.
		cMsgAux := "Pedido GAR não informado no xml" 
		cMsgTipo := cERRO_GTOUT_00001 
	EndIf 
	::oGTMsg:SetMensagem( { cGT_GAR_METODO, { lOk, cMsgTipo, ::cPedidoLog, cEVENTO_ENVIA_PEDIDO_GAR, cMsgAux, ::cXML} } )
	::oGTMsg:AddGTOut( ::cPedidoLog, cGT_TIPO_E, ::cPedidoSite )
Return

/*/{Protheus.doc} ExcedeuGTOutE00023
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method ExcedeuGTOutE00023() class MensagemHUB as Undefinied
	local cQuery := ""
	local cAliasGTIN := ""
	local lRetorno := .F.
	local oSQL   := CSQuerySQL():New()

	cQuery := " SELECT COUNT(*) QTDOUT " 
	cQuery += " FROM GTOUT " 
	cQuery += " WHERE GT_XNPSITE = '" + ::cPedidoSite + "' " 
	cQuery += "   AND GT_TYPE = 'S' " 
	cQuery += "   AND GT_CODMSG = 'E00023' " 
	cQuery += "   AND D_E_L_E_T_ = ' ' " 

	if oSQL:Consultar( cQuery )
		cAliasGTIN := oSQL:GetAlias()
		lRetorno :=  !( cAliasGTIN )->(EoF()) .and. ( cAliasGTIN )->QTDOUT >= 4 
		( cAliasGTIN )->( dbCloseArea() )
	endif	
	
return lRetorno

/*/{Protheus.doc} AtualizarData
Metodo construtor
@author    bruno.nunes
@since     19/05/2021
@version   P12
/*/
method AtualizarData() class MensagemHUB as Undefinied
	PC3->( dbSetOrder( 1 ) )
	if PC3->( dbSeek( xFilial("PC3") + ::cPedidoGar ) )
		RecLock( "PC3", .F. )
		PC3->PC3_DATALT := dDatabase
		PC3->PC3_HORALT := Time()
		PC3->(MsUnLock())
	endif
return
