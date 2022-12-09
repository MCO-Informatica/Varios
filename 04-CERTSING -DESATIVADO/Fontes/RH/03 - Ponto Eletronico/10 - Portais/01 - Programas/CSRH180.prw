#INCLUDE "Protheus.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE LOG001	"FALHA UserAuthenticate"
#DEFINE LOG002	"FALHA StartFlow"
#DEFINE LOG003	"FALHA FinalizeFlow"
#DEFINE LOG004	"FALHA FlowDetails"
#DEFINE LOG005	"FALHA ConsultReceivedExternalAction"
#DEFINE LOG006	"ERRO PARSER"
#DEFINE LOG007	"FORMULARIO NAO RECEBIDO E/OU NAO PREENCHIDO"

#DEFINE nVALIDA_AUTENTICACAO 1
#DEFINE nVALIDA_UPLOAD 		 2

#DEFINE cTITULO 			"Aceite do Banco de Horas Certiflow"
#DEFINE cCERTIFLOW_FLUXO 	"597"

#DEFINE cNOME_SUBPASTA	 "\aceite_bh\"
#DEFINE cNOME_PASTA_CERTIFLOW "\certiflow_protheus\"

User Function CSRH180( aLista )
	if !empty( aLista )
		processa( {|| CSRH180p( aLista ) }, cTITULO, "Enviando Ceriflow",.F.)
	else
		Aviso( cTITULO, 'Não registros para serem enviados para o Certiflow', { 'Ok' }, 3 )
	endif
Return


Static Function CSRH180p( aLista )
	Local cFunProc     	:= ""
	Local cToken   		:= ""
	Local aParametros 	:= {}
	Local aFunProc 		:= {}
	Local aErro        	:= {}
	Local aListErr		:= {}
	Local i				:= 1

	Default aLista := {}

	if empty(aLista)
		return
	endif

	procRegua( len( aLista ) )
	CriarLista(@aParametros, @aFunProc, aLista)	//Cria lista de parametros para enviar o certiflow para a pessoa com pdf

	oWsdl := WSFluxosExternos():New() //Estancimanto
    xRet := oWsdl:UserAuthenticate()  //Autenticação - handshake

	If !xRet
		aAdd( aListErr, { cTITULO + " - FALHA DE AUTENTICACAO PELO METODO oWsdl:UserAuthenticate().VERIFIQUE!" } )
	Else
		oWsdl:oWSparameters      := FluxosExternos_ArrayOfString():NEW() //Cria objeto de parametros
    	oWsdl:cflowCode          := cCERTIFLOW_FLUXO	//Informa o código do fluxo certiflow
    	oWsdl:CAUTHENTICATETOKEN := cToken			//Informa o código do token

		BEGIN TRANSACTION

      	For i := 1 To Len(aParametros)
      		incProc()
			cFunProc := AllTrim( aFunProc[i][01] + aFunProc[i][02] )
      		If !ValidaXML( nVALIDA_AUTENTICACAO, oWsdl, @oWsdl:CUSERAUTHENTICATERESULT, @cToken, @aErro, cFunProc )
            	aAdd( aListErr,	{ cTITULO + " - Fil./Mat.: " + aFunProc[i][01] + "/" + aFunProc[i][02] + "FALHA NA AUTENTICAÇÃO DO ACESSO AO CERTIFLOW.VERIFIQUE!"})
          	EndIf

          	//string com o email do funcionário, nome do arquivo, matrícula
	      	//do funcionário, período e o código do controle
	      	oWsdl:oWSparameters:cString := aParametros[i] //Informa parametros
			xRet := oWsdl:StartFlowUploadingFile() //Executa o upload do arquivo

	      	ValidaXML( nVALIDA_UPLOAD, oWsdl, @oWsdl:CSTARTFLOWUPLOADINGFILERESULT, @cToken, @aErro, cFunProc )
			TrataErro( @aErro, aFunProc[i][01] +"/"+ aFunProc[i][02] ) //Ajusta array de erro.
			aAdd( aListErr, aErro )
      	Next i

      	END TRANSACTION

	EndIf

	FreeObj(oWsdl)

	If Empty(aListErr)
		aAdd(aListErr,{"ESPFLOW.PRW - ESPELHOS DE PONTO ENVIADOS COM SUCESSO."})
	EndIf

	LogProc(aListErr)

Return(.T.)

Static Function ValidaXML( nOpcX, oSelf, cXML, cToken, aErro, cFunProc )
	Local lRet					:= .F.
	Local cErro			   		:= ""
	Local cWarning		   		:= ""
	Local oRetXML		   		:= Nil
	Local oChildXML		   		:= Nil
	Local oNodXML		   		:= Nil

	Default nOpcX				:= 0
	Default cXML				:= ''
	Default cToken              := ''
	Default aErro               := {}
	Default cFunProc            := ''

	oRetXML := XMLParser(cXML, "_", @cErro, @cWarning )		//Transforma o XML de retorno em objeto

	If !Empty(AllTrim(cErro)) .Or. ValType(oRetXML) != "O" //Verifica se ocorreu um ao fazer parse do XML
   		aAdd(aErro,	;
   				{ 	cTITULO +" - " + LOG006 + " " + ;
                	iif( !Empty( cErro ), cErro, ;
                 		iif( ValType(oRetXML) != "O",cFunProc+" - Falhou na conversão dos dados do XML em Objeto"+cWarning,"." );
                 	);
                };
			)
   	Else
		oChildXML := XmlGetchild(oRetXML,XmlChildCount(oRetXML))
		If Upper(AllTrim(oChildXML:REALNAME)) == "WSRESPONSE"		//Verifica se o nó existente contém a resposta do web service Certiflow
			If (oNodXML := XmlChildEx(oChildXML,"_ERROR")) != Nil		//Verifica se o retorno contém um erro
				aAdd(aErro,{cTITULO+" - "+LOG006+" - "+cFunProc+" - Falha no retorno de resposta do CERTIFLOW. Execute novamente a rotina."/*+ oNodXML:_CODE:TEXT +" "+ oNodXML:_MESSAGE:TEXT*/})
			Else
				if nOpcX == nVALIDA_AUTENTICACAO		//Autenticação
					If (oNodXML := XmlChildEx( oChildXML, "_TOKENAUTHENTICATE" ) ) != Nil
						oSelf:CAUTHENTICATETOKEN := AllTrim( oNodXML:TEXT )
						cToken 	:=  AllTrim( oNodXML:TEXT )
						lRet 	:= .T.
					EndIf
				elseif nOpcX == nVALIDA_UPLOAD
					lRet := .T.
				endif
			EndIf
		EndIf
	EndIf

	If oRetXML != Nil
		FreeObj(oRetXML)		//Elimina a instancia do objeto utilizado
	EndIf

	If oChildXML != Nil
		FreeObj(oChildXML)		//Elimina a instancia do objeto utilizado
	EndIf

	If oNodXML != Nil
		FreeObj(oNodXML)		//Elimina a instancia do objeto utilizado
	EndIf

Return lRet


Static Function LogProc(aListErr)
	Local aTitle := {}
	Local aLog   := {}
	Local i      := 0

	aAdd(aTitle, cTITULO)

	For i := 1 To Len( aListErr )
	    aAdd( aLog, aListErr[i] )
	Next

	fMakeLog( aLog, aTitle,,, cTITULO, "LOG DE PROCESAMENTO - ENVIO CERTIFLOW", "G", "L",, .F.)
Return

Static Function CriarLista(aParametro, aFunProc, aLista)
	local i 		:= 0
	local cParam 	:= ""
	local cArquivo 	:= ""
	local aArquivo 	:= {}

	default aParametro 	:= {}
	default aFunProc 	:= {}
	default aLista 		:= {}

	if !ExistDir( cNOME_PASTA_CERTIFLOW )
		MakeDir( cNOME_PASTA_CERTIFLOW )
	endif

	if !ExistDir( cNOME_PASTA_CERTIFLOW+cNOME_SUBPASTA )
		MakeDir( cNOME_PASTA_CERTIFLOW+cNOME_SUBPASTA )
	endif

	for i := 1 to len(aLista)
 		aArquivo := StrTokArr( aLista[i][4], "\" )
		cArquivo := aArquivo[len(aArquivo)]

		cParam := aLista[i][3]+";" 				//Email
		cParam += cNOME_SUBPASTA+cArquivo+";"	//Nome do arquivo
		cParam += FWCodEmp()+aLista[i][1]+";"	//Empresa e Filial
		cParam += aLista[i][2]+";"+dtos(dDataBase)+"; 0" //Matricula

		aAdd(aParametro, { cParam } )
		aAdd(aFunProc  , { aLista[i][1], aLista[i][2] } )
		CpyT2S( aLista[i][4], cNOME_PASTA_CERTIFLOW+cNOME_SUBPASTA, .F.)
	next i

Return

Static Function TrataErro(aErro, cMatLog)
	local aRet 	:= {}
	local i 	:= 0
	If !Empty(aErro)
		If ValType(aErro) == "O"
	    	aRet  := aErro
	    	aErro := {}
	    	aAdd(aErro, aRet:TEXT +" - "+ cMatLog  )
	 	ElseIf ValType(aErro) == "A"
	    	aRet := {}
	    	For i := 1 To Len(aErro)
	        	If ValType( aErro[i] ) == "O" .And. Empty( aRet )
	           		aAdd(aRet, aErro[i]:TEXT +" - "+ cMatLog )
	        	EndIf
	    	Next i
	    	aErro := aRet
	 	EndIf
	EndIf
	aErro := {}
Return