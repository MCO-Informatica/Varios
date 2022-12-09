#INCLUDE "totvs.ch" 
#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSTA060   ºAutor  ³Renato Ruy          º Data ³  06/22/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio de mensagem para o HUB de vinculo                    º±±
±±º          ³ Produto Origem + Produto Protheus                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSTA060(cProduto,cProdOri,cOper,cDescricao,lMsg,cJpgPeq,cJpgMedia,cJpgGrande,nRecnoPA8,lExportXml,lInclui)

Private lRet := .T.

Default lMsg := .T.
Default lInclui := .F.

If Alltrim(cOper) == "A"
	//10/07/2019 - Caso se refira a alteração envia a exclusão depois a inclusão
	MsAguarde({|| CSTA060A(cProduto,cProdOri,"E",cDescricao,lMsg,cJpgPeq,cJpgMedia,cJpgGrande,nRecnoPA8,lExportXml,lInclui)	},"Comunicando com o HUB")
	//MsAguarde({|| CSTA060A(cProduto,cProdOri,"A",cDescricao,lMsg,cJpgPeq,cJpgMedia,cJpgGrande,nRecnoPA8,lExportXml,lInclui)	},"Comunicando com o HUB")
	
	If lRet
		MsAguarde({|| CSTA060A(cProduto,cProdOri,"I",cDescricao,lMsg,cJpgPeq,cJpgMedia,cJpgGrande,nRecnoPA8,lExportXml,lInclui)	},"Comunicando com o HUB")	
	Endif
	
Else
	MsAguarde({|| CSTA060A(cProduto,cProdOri,cOper,cDescricao,lMsg,cJpgPeq,cJpgMedia,cJpgGrande,nRecnoPA8,lExportXml,lInclui)	},"Comunicando com o HUB")
Endif

Return lRet

Static Function CSTA060A(cProduto,cProdOri,cOper,cDescricao,lMsg,cJpgPeq,cJpgMedia,cJpgGrande,nRecnoPA8,lExportXml,lInclui)

	Local cXml 			:= ""
	Local cSvcError   	:= ""  // Resumo do erro
	Local cSoapFCode  	:= ""  // Soap Fault Code
	Local cSoapFDescr 	:= ""  // Soap Fault Description 
	Local cDirImagem	:= Alltrim( GetMv( 'MV_CSTA60A', .F. ) )
	Local lProd		 	:= .F.
	
	Default cProduto 	:= ""
	Default cDescricao	:= ""
	Default cProdOri 	:= ""
	Default cOper	 	:= "I"
	Default cJpgPeq	 	:= ''
	Default cJpgMedia	:= ''
	Default cJpgGrande	:= ''
	Default nRecnoPA8	:= 0
	Default lExportXml  := .F.
	Default lInclui		:= .F.
	//Envia mensagem para criação do produto no Checkout
	If cOper $ "I/A" .And. lMsg
		MsProcTxt("Comunicando HUB - ATUALIZA-PRODUTO")
		lRet := U_CSTA080(cProduto)
	Endif
	
	If lRet
		PA8->( dbGotop() )
		PA8->( dbGoto(nRecnoPA8) )
	    //Envia mensagem para criação do de-para no checkout
		MsProcTxt("Comunicando HUB - ATUALIZA-PRODUTO-ORIGEM")
		
		//Monta cabecalho
		cXml := XML_VERSION + CRLF
		cXml += '<produtoOrigemType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">'+ CRLF
		cXml += '	<code>1</code>'+ CRLF
	    cXml += '	<msg>Obtida Lista com Sucesso</msg>'+ CRLF
	
		//Dados dos itens
		cXml += '	<codigo>'			+AllTrim(cProdOri)  			+'</codigo>'+ CRLF
		cXml += '	<descricao>'		+AllTrim(cDescricao)			+'</descricao>'+ CRLF
		cXml += '	<codigoProtheus>'	+AllTrim(cProduto)  			+'</codigoProtheus>'+ CRLF
		cXml += '	<operacao>'		+cOper							+'</operacao>'+ CRLF
		cXml += '	<plataforma>'	+ IIF( lInclui, M->PA8_PLATAF, PA8->PA8_PLATAF ) +'</plataforma>'+ CRLF
		
		cXml += '	<ac>' + CRLF
		cXml += '		<codigo>' 	 + AllTrim( IIF( lInclui, M->PA8_AC, PA8->PA8_AC ) ) + '</codigo>' + CRLF
		IF .NOT. Empty( IIF( lInclui, M->PA8_AC, PA8->PA8_AC ) )
			cXml += '		<descricao>' + rTrim( Posicione( "PBZ", 1, xFilial("PBZ") + '01' + AllTrim( IIF( lInclui, M->PA8_AC, PA8->PA8_AC ) ), 'PBZ_DESC' ) ) + '</descricao>' + CRLF
		Else
			cXml += '       <descricao></descricao>' + CRLF
		EndIF
		cXml += '	</ac>' + CRLF

		cXml += '	<seguranca>' + CRLF
		cXml += '		<codigo>' 	 + AllTrim( IIF( lInclui, M->PA8_SEG, PA8->PA8_SEG ) ) + '</codigo>' + CRLF
		IF .NOT. Empty( IIF( lInclui, M->PA8_SEG, PA8->PA8_SEG ) )
			cXml += '		<descricao>' + rTrim( Posicione( "PBZ", 1, xFilial("PBZ") + '02' + AllTrim( IIF( lInclui, M->PA8_SEG, PA8->PA8_SEG ) ), 'PBZ_DESC' ) ) + '</descricao>' + CRLF
		Else
			cXml += '       <descricao></descricao>' + CRLF
		EndIF
		cXml += '	</seguranca>' + CRLF
		
		cXml += '	<cadeia>' + CRLF
		cXml += '		<codigo>' 	 + AllTrim( IIF( lInclui, M->PA8_CADEIA, PA8->PA8_CADEIA ) ) + '</codigo>' + CRLF
		IF .NOT. Empty( IIF( lInclui, M->PA8_CADEIA, PA8->PA8_CADEIA ) )
			cXml += '		<descricao>' + rTrim( Posicione( "PBZ", 1, xFilial("PBZ") + '03' + AllTrim( IIF( lInclui, M->PA8_CADEIA, PA8->PA8_CADEIA ) ), 'PBZ_DESC' ) ) + '</descricao>' + CRLF
		Else
			cXml += '       <descricao></descricao>' + CRLF
		EndIF
		cXml += '	</cadeia>' + CRLF
		
		cXml += '	<indicacao>' + CRLF
		cXml += '		<codigo>' 	 + AllTrim( IIF( lInclui, M->PA8_INDICA, PA8->PA8_INDICA ) ) + '</codigo>' + CRLF
		IF .NOT. Empty( IIF( lInclui, M->PA8_INDICA, PA8->PA8_INDICA ) )
			cXml += '		<descricao>' + rTrim( Posicione( "PBZ", 1, xFilial("PBZ") + '04' + AllTrim( IIF( lInclui, M->PA8_INDICA, PA8->PA8_INDICA ) ), 'PBZ_DESC' ) ) + '</descricao>' + CRLF
		Else
			cXml += '       <descricao></descricao>' + CRLF
		EndIF
		cXml += '	</indicacao>' + CRLF

		cXml += '	<variacao>' + CRLF
		cXml += '		<codigo>' 	 + AllTrim( IIF( lInclui, M->PA8_VARIAC, PA8->PA8_VARIAC ) ) + '</codigo>' + CRLF
		IF .NOT. Empty( IIF( lInclui, M->PA8_VARIAC, PA8->PA8_VARIAC ) )
			cXml += '		<descricao>' + rTrim( Posicione( "PBZ", 1, xFilial("PBZ") + '05' + AllTrim( IIF( lInclui, M->PA8_VARIAC, PA8->PA8_VARIAC ) ), 'PBZ_DESC' ) ) + '</descricao>' + CRLF
		Else
			cXml += '       <descricao></descricao>' + CRLF
		EndIF
		cXml += '	</variacao>' + CRLF

		cXml += '	<validade>' + CRLF
		cXml += '		<codigo>' 	 + AllTrim( IIF( lInclui, M->PA8_VALIDA, PA8->PA8_VALIDA ) ) + '</codigo>' + CRLF
		IF .NOT. Empty( IIF( lInclui, M->PA8_VALIDA, PA8->PA8_VALIDA ) )
			cXml += '		<descricao>' + rTrim( Posicione( "PBZ", 1, xFilial("PBZ") + '06' + AllTrim( IIF( lInclui, M->PA8_VALIDA, PA8->PA8_VALIDA ) ), 'PBZ_DESC' ) ) + '</descricao>' + CRLF
		Else
			cXml += '       <descricao></descricao>' + CRLF
		EndIF
		cXml += '	</validade>' + CRLF

		cXml += '	<midia>' + CRLF
		cXml += '		<codigo>' 	 + AllTrim( IIF( lInclui, M->PA8_MIDIA, PA8->PA8_MIDIA ) ) + '</codigo>' + CRLF
		IF .NOT. Empty( IIF( lInclui, M->PA8_MIDIA, PA8->PA8_MIDIA ) )
			cXml += '		<descricao>' + rTrim( Posicione( "PBZ", 1, xFilial("PBZ") + '07' + AllTrim( IIF( lInclui, M->PA8_MIDIA, PA8->PA8_MIDIA ) ), 'PBZ_DESC' ) ) + '</descricao>' + CRLF
		Else
			cXml += '       <descricao></descricao>' + CRLF
		EndIF
		cXml += '	</midia>' + CRLF

		cXml += '	<tpvalidacao>' + CRLF
		cXml += '		<codigo>' 	 + AllTrim( IIF( lInclui, M->PA8_TPVALI, PA8->PA8_TPVALI ) ) + '</codigo>' + CRLF
		IF .NOT. Empty( IIF( lInclui, M->PA8_TPVALI, PA8->PA8_TPVALI ) )
			cXml += '		<descricao>' + rTrim( Posicione( "PBZ", 1, xFilial("PBZ") + '08' + AllTrim( IIF( lInclui, M->PA8_TPVALI, PA8->PA8_TPVALI ) ), 'PBZ_DESC' ) ) + '</descricao>' + CRLF
		Else
			cXml += '       <descricao></descricao>' + CRLF
		EndIF
		cXml += '	</tpvalidacao>' + CRLF
		
		cXml += '	<imagemPequena>'+ cDirImagem + AllTrim(cJpgPeq) + '</imagemPequena>' + CRLF
		cXml += '	<imagemMedia>'  + cDirImagem + AllTrim(cJpgMedia) + '</imagemMedia>' + CRLF
		cXml += '	<imagemGrande>' + cDirImagem + AllTrim(cJpgGrande) + '</imagemGrande>' + CRLF
		cXml += '	<detalheEcomm>' + AllTrim( IIF( lInclui, M->PA8_DTECOM, PA8->PA8_DTECOM ) ) + '</detalheEcomm>' + CRLF
		
		cXml += '</produtoOrigemType>'+ CRLF
		
		IF lExportXml
			CopyToClipBoard( cXml )
			MsgInfo( cXml, 'CTRL+C para copiar o XML' )
		EndIF

		oWsObj := WSVVHubServiceService():New()
						
		lOk := oWsObj:sendMessage("ATUALIZA-PRODUTO-ORIGEM",cXml)
								
		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2)  // Soap Fault Code
		cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
		If !empty(cSoapFCode)
			//Caso a ocorrência de erro esteja com o fault_code preenchido ,
			//a mesma teve relação com a chamada do serviço .
			cSoapFDescr := "A AÇÃO NÃO PODE SER CONCLUIDA E POR ESTE MOTIVO A ALTERAÇÃO NÃO SERÁ GRAVADA!" +chr(13)+chr(10)+cSoapFDescr 
			MsgStop(cSoapFDescr,cSoapFCode)
			Conout(cSoapFDescr + " " + cSoapFCode)
			lRet := .F.
		ElseIf !Empty(cSvcError)
			//Caso a ocorrência não tenha o soap_code preenchido 
			//Ela está relacionada a uma outra falha , 
			//provavelmente local ou interna.
			cSvcError := "A AÇÃO NÃO PODE SER CONCLUIDA E POR ESTE MOTIVO A ALTERAÇÃO NÃO SERÁ GRAVADA!" +chr(13)+chr(10)+cSvcError
			MsgStop(cSvcError,'FALHA INTERNA DE EXECUCAO DO SERVIÇO')
			Conout('FALHA INTERNA DE EXECUCAO DO SERVIÇO ' + cSvcError)
			lRet := .F.
		Endif
	
	Endif							

Return lRet