#INCLUDE "totvs.ch" 

#DEFINE XML_VERSION 		'<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSTA070   ºAutor  ³Renato Ruy	         º Data ³  10/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio de mensagem para o HUB de vinculo                    º±±
±±º          ³ Grupo + Tabela de preço			                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSTA070(cGrupo,cTabAnt,cTabAtu,lMsg,cEstado)

	Local cXml 			:= ""
	Local cSvcError   	:= ""  // Resumo do erro
	Local cSoapFCode  	:= ""  // Soap Fault Code
	Local cSoapFDescr 	:= ""  // Soap Fault Description 
	
	Local cProdDup := ""
	Local cTabin   := "% " + FormatIn(AllTrim(cTabAtu),",") + " %"
	Local cProdin  := ""
	Local cTabDup  := ""
	Local lTemDup  := .F.
		
	Local aTabAnt	 	:= {}
	Local aTabAtu	 	:= {}
	
	Default cGrupo	 := ""
	Default cTabAnt	 := ""
	Default cTabAtu	 := ""
	Default lMsg	 := .T.
	
    aTabAnt := StrToArray(cTabAnt,",")
    aTabAtu := StrToArray(cTabAtu,",")
    
    If lMsg
	    //Renato Ruy - 13/04/2017
	    //Validacao para duplicidade entre tabelas
	    //Primeiro levanta todos os produtos duplicados
	    If Select("TMPPRD") > 0
	    	DbSelectArea("TMPPRD")
	    	TMPPRD->(DbCloseArea())
	    Endif
    
	    BeginSql Alias "TMPPRD"
	        
	    	%NoParser%
	    	
			SELECT DA1_CODGAR FROM (
			SELECT DA1_CODTAB, DA1_CODGAR FROM %Table:DA1%
			WHERE
			DA1_FILIAL = %xFilial:DA1% AND
			DA1_CODTAB IN %Exp:cTabin% AND
			DA1_ATIVO = '1' AND
			%NOTDEL%
			GROUP BY DA1_CODTAB, DA1_CODGAR)
			GROUP BY DA1_CODGAR
			HAVING COUNT(*) > 1
			ORDER BY DA1_CODGAR
			
		Endsql
		
		While !TMPPRD->(EOF())
			cProdDup += Iif(Empty(cProdDup),"",",")+RTrim(TMPPRD->DA1_CODGAR)
			TMPPRD->(DbSkip())
		Enddo
		
		If !Empty(cProdDup)
			lTemDup := .T.
			
			If select("TMPTAB") > 0
				DbSelectArea("TMPTAB")
		    	TMPTAB->(DbCloseArea())
		    Endif
			
			cProdin := "% " + FormatIn(cProdDup,",") + " %"
			
			Beginsql Alias "TMPTAB"
				SELECT DA1_CODTAB FROM %Table:DA1%
				WHERE
				DA1_FILIAL = %xFilial:DA1% AND
				DA1_CODTAB IN %Exp:cTabin% AND
				%NOTDEL% AND
				DA1_CODGAR IN %Exp:cProdin%
				GROUP BY DA1_CODTAB
			Endsql
			
			While !TMPTAB->(EOF())
				cTabDup += Iif(Empty(cTabDup),"",",")+RTrim(TMPTAB->DA1_CODTAB)
				TMPTAB->(DbSkip())
			Enddo
			
			Alert("EXISTEM DUPLICIDADES NAS TABELAS "+RTrim(cTabDup)+" E O HUB NÃO SERÁ NOTIFICADO!"+chr(13)+chr(10)+;
			      "ITENS DUPLICADOS:"+chr(13)+chr(10)+STRTRAN(cProdDup,",",chr(13)+chr(10)))
			
			//Restauro o conteudo anterior e informo que nao foi enviado 
			SZ3->(RecLock("SZ3",.F.))
				SZ3->Z3_CODTAB := cTabAnt
			SZ3->(MsUnlock())
			
		Endif
	
	Endif	
    
    If !lTemDup
	
		//Monta cabecalho
		cXml := XML_VERSION + CRLF
		cXml += '<grupoType xmlns:ns2="http://www.opvs.com.br/certisign/HardwareAvulsoSchema/">'+ CRLF
		cXml += '	<code>1</code>'+ CRLF
	    cXml += '	<msg>Obtida Lista com Sucesso</msg>'	+ CRLF
	    cXml += '	<usuarioprotheus>' + __cUserID + '</usuarioprotheus>' + CRLF
		cXml += '	<nomeusuario>' + cUserName + '</nomeusuario>' + CRLF 
	    cXml += '	<grupo>'+Iif(Len(AllTrim(cGrupo))==0," ",AllTrim(cGrupo))+'</grupo>' 	+ CRLF
	    cXml += '	<estado>'+AllTrim(cEstado)+'</estado>'	+ CRLF
		
		//Incluir itens
		for nI:= 1 To Len(aTabAtu)
			
			If !Empty(aTabAtu[nI])
				cXml += '	<tabelaPreco>'+AllTrim(aTabAtu[nI])+'</tabelaPreco>'+ CRLF
			Endif
		    
	    Next
		
		cXml += '</grupoType>'+ CRLF
		
		oWsObj := WSVVHubServiceService():New()
						
		lOk := oWsObj:sendMessage("ATUALIZA-GRUPO",cXml)
								
		cSvcError   := GetWSCError()  // Resumo do erro
		cSoapFCode  := GetWSCError(2)  // Soap Fault Code
		cSoapFDescr := GetWSCError(3)  // Soap Fault Description
	
		If !empty(cSoapFCode)
			//Caso a ocorrência de erro esteja com o fault_code preenchido ,
			//a mesma teve relação com a chamada do serviço .
			
			//Restauro o conteudo anterior e informo que nao foi enviado
			If lMsg 
				SZ3->(RecLock("SZ3",.F.))
					SZ3->Z3_CODTAB := cTabAnt
				SZ3->(MsUnlock())
			Endif
			
			cSoapFDescr := "ERRO DE COMUNICACAO COM O HUB, AS TABELAS NÃO SERÃO GRAVADAS!"+chr(13)+chr(10)+cSoapFDescr
			
			MsgStop(cSoapFDescr,cSoapFCode)
			Conout(cSoapFDescr + " " + cSoapFCode)
			Return(.F.)
		ElseIf !Empty(cSvcError)
			//Caso a ocorrência não tenha o soap_code preenchido 
			//Ela está relacionada a uma outra falha , 
			//provavelmente local ou interna. 
			//Restauro o conteudo anterior e informo que nao foi enviado
			If lMsg 
				SZ3->(RecLock("SZ3",.F.))
					SZ3->Z3_CODTAB := cTabAnt
				SZ3->(MsUnlock())
			Endif
			
			cSvcError := "ERRO DE COMUNICACAO COM O HUB, AS TABELAS NÃO SERÃO GRAVADAS!"+chr(13)+chr(10)+cSvcError
			
			MsgStop(cSvcError,'FALHA INTERNA DE EXECUCAO DO SERVIÇO')
			Conout('FALHA INTERNA DE EXECUCAO DO SERVIÇO ' + cSvcError)
			Return(.F.)
		Endif							
    Endif
Return .T.