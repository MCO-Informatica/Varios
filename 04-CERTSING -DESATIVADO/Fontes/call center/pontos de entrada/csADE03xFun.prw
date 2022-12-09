#include "PROTHEUS.CH"
#include "TOPCONN.CH"

Static cRetorno := ""

//-----------------------------------------------------------------------
/*/{Protheus.doc} csADE03xFun()
Este fonte tem por objetivo realizar a exibicao de uma Tela para o 
usuario com dados do Grupo/Produto.
Pois eh um fonte generico de funcoes para ser chamado pelos fontes
csADE01Send e csADE02Send. 

@param	nOpc		Opcao qual processo sera executado
						1-Query a ser realizada
						2-Exibicao da Tela	
		cDados		Dados a ser exibido conforme a Opcao.
		aDados		Array contendo o retorno conforme Query herdada.	
		cProcesso	Processo que sera realizado (Produto ou Grupo).

@author	Douglas Parreja
@since	16/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csADE03xFun( nOpc, cDados, aDados, cProcesso )

	local cRetQuery		:= ""
	local nX			:= 0
	private cExec 		:= "Service-Desk x Checkout"
	private cProcExp	:= "Consulta Padrao (ADE_KGRUPO)"	
	private xObj
	private xRet
	
	default nOpc		:= 0
	default cDados		:= ""
	default cProcesso	:= ""
	default aDados		:= {}

	if nOpc > 0	
		if nOpc == 1
			cRetQuery := ExecuteQuery( cDados )
			return (cRetQuery)
		elseif nOpc == 2
			csMontaTela( cDados, aDados, cProcesso )
		elseif nOpc == 3	
			csGridItem( aDados )
		elseif nOpc == 4
			csTelaProd( cDados, aDados ) 				
		endif
	endif
					
return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csMontaTela
Funcao responsavel para receber os dados e exibir a Tela para o usuario.

@param	cCabecalho	Cabecalho a ser exibido na tela
		aDados		Array contendo o retorno conforme Query herdada.
		cProcesso	Processo que sera realizado (Produto ou Grupo).

@author	Douglas Parreja
@since	16/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csMontaTela( cCabecalho, aDados, cProcesso )

	local oDlg, oLbx, oOrdem, oSeek, oPesq, oPnlTop, oPnlAll, oPnlBot, ONOMRK, oMrk
	local cRet, cOrdem, cRet2 := ''
	local cSeek   		:= Space(60)
	local aIndice 		:= {}	
	local nOrd    		:= 1
	local nOpc    		:= 0
	
	default aDados 	:= {}
	default cCabecalho	:= ""
	
	if alltrim( UPPER(cProcesso) ) == "PROD"
		AAdd( aIndice, 'Cod. Produto'	)
		AAdd( aIndice, 'Desc. Produto'	)
	elseif alltrim( UPPER(cProcesso) ) == "GRUPO"
		AAdd( aIndice, 'Cod. Entidade'	)
		AAdd( aIndice, 'Desc. Grupo'	)
	endif
	
	if len( aDados ) > 0
	
		DEFINE MSDIALOG oDlg TITLE cCabecalho FROM 0,0 TO 308,770 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
		
		oDlg:lEscClose := .F.
		
		oPnlTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlTop:Align := CONTROL_ALIGN_TOP
		
		@ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aIndice SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPnlTop
		@ 1,247 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 50,11 PIXEL OF oPnlTop ACTION (csPesq(nOrd,cSeek,@oLbx))
		
		oPnlAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		if alltrim( UPPER(cProcesso) ) == "PROD"
			oLbx := TwBrowse():New(0,0,1000,1020,,{'Descrição Produto','Campanha','Código Produto'},,oPnlAll,,,,,,,,,,,,.F.,,.T.,,.F.)
		elseif alltrim( UPPER(cProcesso) ) == "GRUPO"
			oLbx := TwBrowse():New(0,0,1000,1020,,{'Código Entidade','Descrição','Código Tabela','Código GAR'},,oPnlAll,,,,,,,,,,,,.F.,,.T.,,.F.)
		endif
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDados )
		if alltrim( UPPER(cProcesso) ) == "PROD"
			if len(aDados[oLbx:nAt]) > 3
				oLbx:bLine := {|| { aDados[oLbx:nAt,2], aDados[oLbx:nAt,3], aDados[oLbx:nAt,4], aDados[oLbx:nAt,1] } }
			endif
		elseif alltrim( UPPER(cProcesso) ) == "GRUPO"
			if len(aDados[oLbx:nAt]) > 3
				oLbx:bLine := {|| { padc(aDados[oLbx:nAt,1],5), padc(aDados[oLbx:nAt,2],50), padc(aDados[oLbx:nAt,4],50), alltrim(aDados[oLbx:nAt,3]) } }
			endif
		endif	
		oLbx:bLDblClick := {|| Iif(csSeek(oLbx,@nOpc,@cRet,oLbx:nAt,@cRet2,cProcesso),oDlg:End(),NIL) }
		   
		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPnlBot ACTION Iif(csSeek(oLbx,@nOpc,@cRet,oLbx:nAt,@cRet2,cProcesso),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPnlBot ACTION (oDlg:End())
		
		ACTIVATE MSDIALOG oDlg CENTER
		
		if nOpc == 1	
			if alltrim( UPPER(cProcesso) ) == "PROD"
				M->ADE_KPROD 	:= cRet
				M->ADE_KCDPRO	:= cRet2
			elseif alltrim( UPPER(cProcesso) ) == "GRUPO"
				cGrupo	:= cRet2
				cRetorno:= cRet2		
			endif
		endif
	
	endif

return 

//-----------------------------------------------------------------------
/*/{Protheus.doc} csSeek
Funcao para retornar a descricao do Produto conforme posicionado.

@param	oLbx		Objeto da tela.
		nOpc		Opcao.
		cRet		Retorna descricao do registro posicionado.
		nLin		Linha posicionada na Tela.
		cRet2		Utilizado para obter o retorno do cod tabela para 
					quando for utilizado para o GRUPO.
		cProcesso	Processo que sera realizado (Produto ou Grupo).

@return	lRet	Retorna se foi selecionado registro na tela.				

@author	Douglas Parreja
@since	16/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csSeek( oLbx, nOpc, cRet, nLin, cRet2, cProcesso )

	local lRet := .T.
	
	if ValType( oLbx ) <> "U"
		if len( oLbx:aArray ) > 0 
			if alltrim( UPPER(cProcesso) ) == "PROD"
				if (len(oLbx:aArray[nLin] ) > 0)
					if (len(oLbx:aArray[nLin,2]) > 0)
						cRet 	:= alltrim( oLbx:aArray[nLin,2] )
					endif
					if (len(oLbx:aArray[nLin,6]) > 0) 						
						cRet2	:= alltrim( oLbx:aArray[nLin,6] )
					endif
				endif
			elseif alltrim( UPPER(cProcesso) ) == "GRUPO"
				if (len(oLbx:aArray[nLin] ) > 0) 
					if (len(oLbx:aArray[nLin,2]) > 0) 
						cRet 	:= alltrim( oLbx:aArray[nLin,2] )
					endif
					if	(len(oLbx:aArray[nLin,3]) > 0)
						cRet2	:= alltrim( oLbx:aArray[nLin,3] )
					endif
				endif
			endif
		endif
	endif
	nOpc := Iif(lRet,1,0)

return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} executeQuery
Funcao executa a query.

@param	cQuery		Query que sera executada
@return cAlias		Alias da query executada

@author  Douglas Parreja
@since   26/06/2015
@version 11.8
/*/
//-------------------------------------------------------------------
static function ExecuteQuery( cQuery )

	Local cAlias	:= getNextAlias()
	local cExec, cProcExp
	Default cQuery	:= ""
	
	If ( !Empty(cQuery) )
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
			
		If ( (cAlias)->(eof()) )
		
			(cAlias)->(dbCloseArea())
			
			cAlias := ""
			u_autoMsg(cExec,cProcExp,"Query nao retornou registros" )
		//Else
		//	u_autoMsg(cExec,cProcExp, "Executando query" )
		Endif
	Else
		
		cAlias := ""
		u_autoMsg(cExec,cProcExp, "Query nao retornou registros" )
	
	Endif

Return cAlias

//-----------------------------------------------------------------------
/*/{Protheus.doc} csPesq
Funcao para posicionar no registro conforme o indice de busca informado.

@param	nOrd		Ordem de indice solicitado.
		cPesq		Pavalra digitada para busca.
		oLbx		Objeto da tela.

@author	Douglas Parreja
@since	16/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csPesq( nOrd,cPesq,oLbx )
	
	local nCol	:= nOrd
	local nP 	:= 0
	
	cPesq := Upper( alltrim( cPesq ) )
		
	if nCol > 0		
		//------------------------------
		// Indice por Codigo
		//------------------------------
		if nOrd == 1
			nP:= Ascan( oLbx:aArray, { |x| alltrim(x[1]) $ cPesq } )
		//------------------------------
		// Indice por Descricao
		//------------------------------			
		elseif nOrd == 2
			nP:= Ascan( oLbx:aArray, { |x| cPesq $ alltrim(x[2]) } )
		endif
		
		if nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		else
			msgInfo('Informação não localizada.','Pesquisar')
		endif
	else
		msgAlert('Opção de pesquisa inválida.','Pesquisar')
	endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} csTK510END
Funcao responsavel pela gravacao dos registros na ADF.


@author  Douglas Parreja
@since   13/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
user function csTK510END()
	
	local cMVLink 		:= alltrim(getMv("MV_LINKCHK"))
	local cMVChkOcor	:= alltrim(getMv('MV_CHKOCOR'))
	local cMVChkAcao	:= alltrim(getMv('MV_CHKACAO'))
	local cString		:= ""
	local cMsgCrip		:= ""
	local cMsgTitulo	:= ""
	local cDataPed		:= ""
	local cNumPed		:= ""
	local cMsgPgto		:= ""
	local cLinkTroca	:= ""
	local nItem			:= 0	
	local lGravou		:= .F.	
	local lRestOk		:= .F.
	local lErro			:= .F.
	local lExibeTela	:= .T.
	local aErro			:= {}
	
	//----------------------------------------------------------
	// Projeto Protheus x REST (Checkout)
	// Realizado alteracao para que agora o Protheus passa
	// a consumir o Rest do Checkout e obtenha o retorno 
	// da Data, Numero Pedido e Link a ser processado.
	// Caso o Processamento do Rest nao execute corretamente,
	// ou tenha algum dado incorreto, eh retornado a mensagem 
	// no Objeto para ser tratado (tela, conout, etc).	
	//
	// *Funcoes abaixo Legado
	// cString		:= csDadosFat()
	// cMsgCrip	:= csCriptografia(cString)
	//----------------------------------------------------------
	aDadosFat := csArrayDados()
	xRet := u_restBusiness( 1, aDadosFat )
	if type( "xRet" ) <> "U"
		if type( "xRet[1]" ) <> "U"
			lRestOk := iif( type("xRet[1]") == "L", xRet[1], .F. )
			if type( "xRet[2]" ) <> "U"
				if type( "xRet[2]" ) == "O"
					//----------------------------------------------------------
					// Valido se possui mensagem de Erro no Processamento
					// Caso tenha sera exibido a tela de validacao de Schema
					//----------------------------------------------------------
					if ( (type( "xRet[2]:cCodErr" ) <> "U") .and. (type( "xRet[2]:cMsgErr" ) <> "U") )
						if !empty(xRet[2]:cCodErr) .or. !empty(xRet[2]:cMsgErr)							
							if type( "xRet[2]:oRestClient" ) <> "U"
								if type( "xRet[2]:oRestClient" ) == "A"
									aErro := u_restViewSchema( xRet[2]:oRestClient, lExibeTela )	
									lErro := iif( len(aErro) > 0, aErro[1], .T. )
									cMsgCrip := iif( len(aErro) > 1, aErro[2], "" ) 				
								endif
							//----------------------------------------------------------
							// Caso retorne uma mensagem inexperada no REST, ou seja,
							// que nao possua tratamento, eu gravo no campo MEMO o
							// erro para ser identificado. 
							//----------------------------------------------------------
							elseif (type("xRet[2]:cCodErr") <> "U" .and. type("xRet[2]:cMsgErr") <> "U"	 .and. type("xRet[2]:cJson") <> "U") 							
								cMsgCrip	:= "------------------------------------------------------------------------------------------" + CRLF
								cMsgCrip 	+= iif( type("xRet[2]:cCodErr") == "C", "1) Codigo Erro: " + alltrim(xRet[2]:cCodErr) + CRLF, "" )
								cMsgCrip	+= "------------------------------------------------------------------------------------------" + CRLF
								cMsgCrip	+= iif( type("xRet[2]:cCodErr") == "C", "2) Mensagem Erro: " + alltrim(xRet[2]:cMsgErr) + CRLF, "" )
								cMsgCrip	+= "------------------------------------------------------------------------------------------" + CRLF
								cMsgCrip	+= iif( type("xRet[2]:cJson") == "C", 	 "3) JSON enviado: " + alltrim(xRet[2]:cJson) + CRLF, "" )
								cMsgCrip	+= "------------------------------------------------------------------------------------------" + CRLF
								lErro		:= .T.
							endif
						endif
					endif
					//----------------------------------------------------------
					// Caso nao tenha erro, sera atribuido nas variaveis o
					// retorno do REST, para ser exibido ao usuario e gravado
					// nos campos corretos.
					//----------------------------------------------------------
					if .NOT. lErro		
						if type( "xRet[2]:oRestClient:Data" ) <> "U" .and. ;
								type( "xRet[2]:oRestClient:Numero" ) <> "U" .and. ;
									type( "xRet[2]:oRestClient:url" ) <> "U"
										cDataPed 	:= iif( type( "xRet[2]:oRestClient:Data" ) == "C", xRet[2]:oRestClient:Data, "" )
										cNumPed		:= iif( type( "xRet[2]:oRestClient:Numero" ) == "N", alltrim(str(xRet[2]:oRestClient:Numero)),;
															iif( type( "xRet[2]:oRestClient:Numero" ) == "C", xRet[2]:oRestClient:Numero, "" ))
										cMsgCrip 	:= iif( type( "xRet[2]:oRestClient:url" ) == "C", xRet[2]:oRestClient:url, "" )						
						else
							//----------------------------------------------------------
							// Tela exibida para quando for troca de Forma Pagto.							
							//----------------------------------------------------------
							cDataPed 	:= dtoc(ADE->(ADE_DATUSO))
							cNumPed		:= alltrim( ADE->(ADE_XPSITE) )
							cMsgCrip	:= iif( ADE->(FieldPos("ADE_LINK")) > 0, alltrim(ADE->(ADE_LINK)), "" )
							if type( "xRet[2]:oRestClient:url" ) <> "U"
								cMsgPgto := iif( type( "xRet[2]:oRestClient:url" ) == "C", xRet[2]:oRestClient:url, "" )
								cLinkTroca := cMsgPgto
							endif
						endif
					endif
				endif
			endif
		endif
	endif
	
	//----------------------------------------------------------
	// lRestOk - Valida se 
	//----------------------------------------------------------
	if lRestOk		
		cItem := alltrim(ADF->ADF_ITEM)		  		
		BEGIN TRANSACTION
		ADF->( RecLock("ADF",.T.) )
			ADF->(ADF_FILIAL) 	:= xFilial("ADF")
			ADF->(ADF_FILORI) 	:= xFilial("ADF")
			ADF->(ADF_CODIGO) 	:= ADE->(ADE_CODIGO)
			nItem 				:= VAL(cItem) + 1
			ADF->(ADF_ITEM)	  	:= StrZero( nItem, 3, 0 )
			ADF->(ADF_CODSU9)	:= cMVChkOcor   
			ADF->(ADF_CODSUQ)	:= cMVChkAcao  
			ADF->(ADF_CODSU7)	:= ADE->(ADE_OPERAD) 
			ADF->(ADF_CODSU0)	:= ADE->(ADE_GRUPO) 	
			ADF->(ADF_DATA)		:= DATE()
			ADF->(ADF_HORA)		:= TIME()
			ADF->(ADF_HORAF)	:= TIME()				
			cMsgTitulo	:= iif( lErro, "Nao foi gerado o Link, devido as inconsistencias abaixo:" ,"Segue Link gerado Checkout:" )
			cMsgPgto	:= iif( (.not. lErro) .and. (!empty(cMsgPgto)), +CRLF+"---------------------------------------------"+CRLF+ CRLF+"Link troca de Pagamento:"+CRLF+alltrim(cMsgPgto), "" )  
			MSMM(,,,cMsgTitulo + CRLF+ CRLF + cMsgCrip + cMsgPgto , 1,,,"ADF","ADF_CODOBS") //Campo MEMO eh gravado na SYP010.
			ADF->( MsUnlock() )
			lGravou := .T.
			
		if (.NOT. lErro .and. !empty(cNumPed) )
			ADE->( RecLock("ADE",.F.) )
			ADE->ADE_XPSITE := alltrim(cNumPed)
			if 	ADE->(FieldPos("ADE_LINK")) > 0
				ADE->ADE_LINK := iif( !empty(cMsgCrip), alltrim(cMsgCrip), "" )
			endif	
			ADE->( MsUnlock() ) 
		endif 
		
		END TRANSACTION
		
		//----------------------------------------------------------
		// Exibicao de Mensagem para usuario, Tela ou Alert
		//----------------------------------------------------------
		if lErro
			if (empty(cDataPed) .and. empty(cNumPed) .and. (len(aErro) == 0) )				
				msgStop("Não foi possível gerar o Link Checkout, erro inexperado Web Service REST." + CRLF + "No campo Observação consta os dados de retorno.","Checkout REST")
			endif
		else
			//csTK510Tela( alltrim(cDataPed), alltrim(cNumPed), alltrim(cMsgCrip) )
			
			//Nova forma de apresentação - Abrir os dados via TXT
			//Motivo: Não dar o TimeOut e a transação realizar o rollback. 
			//Casos em que envia o link mas não grava o protocolo - Rbeghini 19.06.2018
			//Otrs: [2018061110001988] Protocolo de compra não encontrado
			csShowLink( alltrim(cDataPed), ADE->(ADE_CODIGO), alltrim(cNumPed), alltrim(cMsgCrip), alltrim(cLinkTroca) )
		endif		
	else
		msgAlert("Não foi possivel comunicação com Checkout." + CRLF+ CRLF + "Favor verificar, caso persista, contate Sistemas Corporativos.", "Atenção")	
	endif
	
	
	
return lGravou

//-------------------------------------------------------------------
/*/{Protheus.doc} csTK510Tela
Funcao responsavel por criar Tela de log com o link gerado.

@param	cLink	Link do checkout que foi gerado e sera exibido na tela.


@author  Douglas Parreja
@since   13/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csTK510Tela( cData, cPedido, cLink )
	
	local _aAreaPV1		:= GetArea()
	local lRet 		:= .F.
	
	default cData		:= ""
	default cPedido	:= ""
	default cLink		:= ""
	
	private oDlg1                    
	
	DEFINE MSDIALOG oDlg1 TITLE OemToAnsi( 'Geração Link - Carrinho Checkout' ) OF oMainWnd FROM 00,00 TO 200,900 PIXEL
	@ 006,003 SAY OemToAnsi( 'Por gentileza, clique no Link abaixo para ser direcionado ao Checkout.' ) OF oDlg1 PIXEL
	@ 024,011 SAY OemToAnsi( 'Data / Hora:' ) OF oDlg1 PIXEL	
	@ 022,042 MSGET cData OF oDlg1 PIXEL SIZE 070,10 WHEN .F.
	@ 044,003 SAY OemToAnsi( 'Número Pedido:' ) OF oDlg1 PIXEL	
	@ 042,042 MSGET cPedido OF oDlg1 PIXEL SIZE 070,10 WHEN .T.
	@ 064,005 SAY OemToAnsi( 'Link Checkout:' ) OF oDlg1 PIXEL	
	@ 062,042 MSGET cLink OF oDlg1 PIXEL SIZE 398,10 WHEN .F.  
	@ 085,010 BUTTON "&Confirma" SIZE 30,12 PIXEL OF oDlg1 ACTION Iif( csLink( cLink, _aAreaPV1 ),oDlg1:End(),NIL )	
	Activate msDialog oDlg1 Center

return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} csLink
Funcao responsavel por criar Tela de log com o link gerado.

@param	cLink	Link do checkout que foi gerado e sera exibido na tela.


@author  Douglas Parreja
@since   13/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csLink( cLink, _aAreaPV1)
	
	default cLink := ""
	if !empty( cLink )
		ShellExecute( "Open", cLink , "", "C:\", 1 )
	endif
	
return .T.
	
//-------------------------------------------------------------------
/*/{Protheus.doc} csDadosFat
Funcao responsavel por capturar os dados digitados na 
na Aba Dados Faturamento

-----------------------------------
 Exemplo JSON com Pessoa Fisica:
----------------------------------- 

{
  "carrinho" : [ {
    "produto" : "ACMA1PFHV2",
    "grupo" : "PUBLI",
    "ac" : "",
    "ar" : "CRSNT",
    "qtd" : "1"
  } ],
  "origem" : "9",
  "protocolo" : "123456",
  "codigoAnalista" : "123456",
  "nomeAnalista" : "JOAO DA SILVA",
  "identificacao" : {
                "email":"integracaosac@certisign.com.br"
  },
  "faturamento" : {
    "pessoaFisica" : {
      "nome" : "THIAGO ASSUMPCAO DA COSTA",
      "cpf" : "34628470820",
      "rg" : "12345678-5",
      "orgaoExpedidor" : "SSP",
      "dataNascimento" : "01012016",
      "sexo" : "M",
      "email" : "teste@certisign.com.br",
      "telefoneCelular" : "11996369636",
      "telefoneContato" : "11996369636",
      "cep" : "06150000",
      "logradouro" : "AV SARAH VELOSO",
      "bairro" : "VELOSO",
      "numero" : "1200",
      "complemento" : "BL 1 AP 25",
      "estado" : "SP",
      "cidade" : "OSASCO"
    }
  },
  "pagamento" : {
                "forma":"BOLETO"
  }
}

-----------------------------------
 Exemplo JSON com Pessoa Juridica:
-----------------------------------

{
  "carrinho" : [ {
    "produto" : "ACMA3PFSCHV2",
    "grupo" : "PUBLI",
    "ac" : "",
    "ar" : "CRSNT",
    "qtd" : "1"
  } ],
  "origem" : "9",
  "protocolo" : "123456",
  "codigoAnalista" : "123456",
  "nomeAnalista" : "JOAO DA SILVA",
  "identificacao" : {
    "email":"integracaosac@certisign.com.br"
  },
  "faturamento" : {
    "pessoaJuridica" : {
      "estado" : "SP",
      "cnpj" : "01001001000189",
      "razaoSocial" : "TESTE THIAGO",
      "cep" : "06150000",
      "logradouro" : "AV SARAH VELOSO",
      "bairro" : "VELOSO",
      "numero" : "1200",
      "complemento" : "BL 1 AP 25",
      "estado" : "SP",
      "cidade" : "OSASCO",
      "inscricaoEstadual" : "123456",
      "inscricaoMunicipal" : "123456",,
      "email":"thiago.costa@certisign.com.br",
      "telefoneEmpresa" : "1145012203",
      "nomeContato":"THIAGO",
      "telefoneContato" : "1145012203"
    }
  },
  "pagamento" : {
                "forma":"BOLETO"
  }
}


@return cAlias		Alias da query executada

@author  Douglas Parreja
@since   13/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csDadosFat()

	local cString := ""
	
	if csValidTabela()
		
		cString += '{'
		cString += '"carrinho" : [ {'
       cString +=	'"produto"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KCDPRO)))+'",'
       cString +=  '"grupo"' 	+ ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KGRTAB)))+'",'
       cString +=  '"ac"'		+ ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KAC)))+'",'
       cString +=  '"ar"'		+ ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KAR)))+'",'
       cString +=  '"qtd":"1"'
       cString +=  '}],'              
       cString +=	'"origem":"9",'
       cString +=	'"protocolo"' + ":" + '"'+u_removeCaracEspecial(alltrim(ADE->(ADE_CODIGO)))+'",'
       cString +=	'"codigoAnalista"' + ":" + '"'+ iif( alltrim(SU7->(U7_COD)) == alltrim(ADE->(ADE_OPERAD)), u_removeCaracEspecial(alltrim(SU7->(U7_COD))), u_removeCaracEspecial(alltrim(ADE->(ADE_OPERAD))) ) + '",'
       cString +=	'"nomeAnalista"' + ":" + '"'+ u_removeCaracEspecial(alltrim(SU7->(U7_NOME)))+'",'
     	cString +=	'"identificacao":{'
     	cString +=	'"email":"integracaosac@certisign.com.br"
     	cString +=	'},'
     	cString +=	'"faturamento":{'
      	cString +=	iif( (alltrim(ADE->(ADE_KTIPO))) == "F",'"pessoaFisica"', '"pessoaJuridica"' )
       	cString +=	":{"
       	if( alltrim(ADE->(ADE_KTIPO)) == "F" )
	       	cString +=	'"nome"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KNOME)))+'",'
	         	cString +=	'"cpf"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KCGC)))+'",'
	         	cString +=	'"rg"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KRG)))+'",'
	          	cString +=	'"orgaoExpedidor"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KORGEX)))+'",'
	          	cString +=	'"dataNascimento"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KDTNAS)))+'",'
	          	cString +=	'"sexo"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KSEXO)))+'",'
	          	if "-" $ FisGetEnd(alltrim(ADE->(ADE_KCEL)),alltrim(ADE->(ADE_KCEL)))[3]
					cString +=	'"telefoneCelular"' + ":" + '"'+ StrTran(u_removeCaracEspecial(alltrim(ADE->(ADE_KCEL))),"-","") +'",'
				else	
					cString +=	'"telefoneCelular"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KCEL)))+'",'
				endif
				if "-" $ FisGetEnd(alltrim(ADE->(ADE_KTEL)),alltrim(ADE->(ADE_KTEL)))[3]
					cString +=	'"telefoneContato"' + ":" + '"'+ StrTran(u_removeCaracEspecial(alltrim(ADE->(ADE_KTEL))),"-","") +'",'
				else	
					cString +=	'"telefoneContato"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KTEL)))+'",'
				endif
			else
				cString +=	'"razaoSocial"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KNOME)))+'",'
	         	cString +=	'"cnpj"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KCGC)))+'",'
				cString +=	'"inscricaoEstadual"' + ":" + '"'+iif( alltrim(ADE->(ADE_KINSCE)) $ "ISE|ISEN|ISENT|ISENTO|ISENTA", "", u_removeCaracEspecial(alltrim(ADE->(ADE_KINSCE))) )+'",'
				cString +=	'"inscricaoMunicipal"' + ":" + '"'+iif( alltrim(ADE->(ADE_KINSCM)) $ "ISE|ISEN|ISENT|ISENTO|ISENTA", "", u_removeCaracEspecial(alltrim(ADE->(ADE_KINSCM))) )+'",'
	         	cString +=	'"telefoneEmpresa"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KTEL)))+'",'
	         	if "-" $ FisGetEnd(alltrim(ADE->(ADE_KTELCT)),alltrim(ADE->(ADE_KTELCT)))[3]
	         		cString +=	'"telefoneContato"' + ":" + '"'+ StrTran(u_removeCaracEspecial(alltrim(ADE->(ADE_KTELCT))),"-","") +'",'
	         	else
	         		cString +=	'"telefoneContato"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KTELCT)))+'",'
	         	endif
				cString +=	'"nomeContato"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KNOMCT)))+'",'	 				        		
			endif
			cString +=	'"email"' + ":" + '"'+ (alltrim(ADE->(ADE_KEMAIL)))+'",'			
			cString +=	'"cep"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KCEP)))+'",'
			cString +=	'"logradouro"' + ":" + '"'+ u_removeCaracEspecial(alltrim(FisGetEnd(ADE->(ADE_KEND),"ADE")[1]))+'",'
			cString +=	'"bairro"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KBAIRR)))+'",'		
			if "/" $ FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[3]
				cString +=	'"numero"' + ":" + '"' + iif(!empty(ADE->(ADE_KEND)), alltrim(iif(FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[3]<>"",FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[3],"SN")), alltrim(ADE->(ADE_KEND)) )+'",'
			else 					
 				cString +=	'"numero"' + ":" + '"' + iif(!empty(ADE->(ADE_KEND)), alltrim(iif(FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[2]<>0, Str(FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[2]), "SN")), alltrim(ADE->(ADE_KEND)) )+'",'
			endIf
			cString +=	'"complemento"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KCOMPL)))+'",'
			cString +=	'"estado"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KUF)))+'",'
			cString +=	'"cidade"' + ":" + '"'+ u_removeCaracEspecial(alltrim(ADE->(ADE_KCIDAD)))+'"'
          	cString +=	'}'
		cString +=	'},'
		cString += '"pagamento":{'
		cString += '"forma":"BOLETO"'
		cString += '}'
		cString += '}'
			
	
	endif

return	cString

//-------------------------------------------------------------------
/*/{Protheus.doc} csValidTabela
Funcao responsavel por verificar se as tabelas estao em uso, caso
nao esteja, realizo a abertura das mesmas.

@return 	lRet	Retorna se as tabelas estao prontas para uso.

@author  Douglas Parreja
@since   15/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csValidTabela()

	local lRet,lRet1,lRet2,lRet3,lRet4,lRet5 := .F.
	
	if select("ADE") > 0 
		lRet1 := .T.
	else
		dbSelectArea("ADE")
		if select("ADE") > 0 
			lRet1 := .T.
		endif 		
	endif
	if select("ADF") > 0 
		lRet2 := .T.
	else
		dbSelectArea("ADF")
		if select("ADF") > 0 
			lRet2 := .T.
		endif
	endif
	if select("SU7") > 0 
		lRet3 := .T.
	else
		dbSelectArea("SU7")
		if select("SU7") > 0 
			lRet3 := .T.
		endif
	endif
	if select("SA1") > 0 
		lRet4 := .T.
	else
		dbSelectArea("SA1")
		if select("SA1") > 0 
			lRet4 := .T.
		endif
	endif
	if select("PA7") > 0 
		lRet5 := .T.
	else
		dbSelectArea("PA7")
		if select("PA7") > 0 
			lRet5 := .T.
		endif
	endif
	
	if lRet1 .and. lRet2 .and. lRet3 .and. lRet4 .and. lRet5
		lRet := .T.
	endif
	
return	lRet	

//-------------------------------------------------------------------
/*/{Protheus.doc} csCriptografia
Funcao responsavel por realizar a Criptografia da URL

@param	cMsg		String da URL.
@return cRet		Retorno da String Criptografado.


@author  Douglas Parreja
@since   15/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------	
static function csCriptografia( cMsg )

	default cMsg := ""

	if !empty( cMsg )
		cRet := Encode64( cMsg )
		//------------------------------
		// Funcao Escape URL Encoding 
		//------------------------------
		cRet := Escape( cRet )
	endif
	
return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} csGridItem
Funcao responsavel por carregar o Grid no Dialog (modelo2).

@param	aDados		Array contendo os dados da Query.
@return lRet		Retorno .T. por default.


@author  Douglas Parreja
@since   15/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csGridItem( aDados )

	local cItens   := "ZZR_ITEM|ZZR_GRUPO|ZZR_CDPROD|ZZR_CDGAR|ZZR_DESC|ZZR_CODTAB"
	local nX 		:= 0
	local nUsado	:= 0
	local nItem		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_ITEM" 	})
	local nGrupo	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_GRUPO"	})
	local nCodProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_CDPROD"	})
	local nCodGAR	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_CDGAR"	})
	local nDesc		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_DESC" 	})
//	local nValor	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_VALOR"	})
	local nCodTab	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_CODTAB"	})
	local lRet 	:= .T.
	//local xObj, oListBox
	
	default aDados := {}
	
	if len( aDados ) > 0 
		if empty( cProd )	
		
			aCols := {}
			aCols := Array( len( aDados ), 8 )		
			
			for nX := 1 to len( aDados )		
				dbSelectArea("SX3")
				dbSetOrder(1)		
				//SX3->(dbGoTop())
				dbSeek("ZZR")
				
				while !eof() .and. ( X3_ARQUIVO == "ZZR" )
					if ( X3USO(SX3->X3_USADO) .and. alltrim(SX3->X3_CAMPO) $ cItens )
						nUsado:=nUsado+1
						if alltrim( SX3->X3_CAMPO ) == "ZZR_ITEM"			//1-Item
							aCols[nX][nItem] := aDados[nX][5]
						elseif alltrim( SX3->X3_CAMPO ) == "ZZR_GRUPO"		//2-Grupo
							aCols[nX][nGrupo] := aDados[nX][3]
						elseif alltrim( SX3->X3_CAMPO ) == "ZZR_CDPROD"	//3-Cod. Produto
							aCols[nX][nCodProd] := aDados[nX][6]
						elseif alltrim( SX3->X3_CAMPO ) == "ZZR_CDGAR"		//4-Cod. Prod. GAR
							aCols[nX][nCodGAR] := aDados[nX][1]
						elseif alltrim( SX3->X3_CAMPO ) == "ZZR_DESC"		//5-Desc. Produto
							aCols[nX][nDesc] := aDados[nX][2]
//						elseif alltrim( SX3->X3_CAMPO ) == "ZZR_VALOR"		//6-Valor
//							aCols[nX][nValor] := aDados[nX][4]
						elseif alltrim( SX3->X3_CAMPO ) == "ZZR_CODTAB"	//7-Cod. Tabela Grupo
							aCols[nX][nCodTab] := aDados[nX][7]
						endif
					endif	
					dbSkip()
				enddo
				
				aCols[nX][nUsado+1] := .F.
	    		nUsado := 0
	    	next		
			//------------------------------
			//Atualiza o Browse do modelo 2
			//------------------------------	
			xObj := CallMod2Obj()
			xObj:oBrowse:Refresh()					
		else
			nPos := Ascan( aDados, { |x| x[5] == alltrim(cProd) } )
			if nPos > 0
				U_CSADE04V(aCols[nPos][3],aCols[nPos][4], aCols[nPos][5], aCols[nPos][6])
				cCodGAR		:= aCols[nPos][3]
				cCodProd 	:= aCols[nPos][4]	
				cDescProd	:= aCols[nPos][5]	
//				cValor		:= aCols[nPos][6] 	
				cCodTab		:= aCols[nPos][6]
			else
				msgInfo("Favor preencher um Código de ITEM do produto correto.", "Atenção",)
				U_CSADE04V(" "," ", " ", " ", " ") 
				cCodProd 	:= ""
				cCodGAR		:= ""	
				cDescProd	:= ""
			endif
		endif	
	else
		msgInfo("Não consta dados de Produto")
	endif

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} csADEOrig
Funcao responsavel por retornar a Origem do Cadastro da tabela ZZR.
Realizado esta funcao para caso outro programa precise utilizar 
a mesma tabela, eh possivel chama-la por ser uma User Function e
atribuir qual origem estara sendo gravado.

@return cCodOrig		Retorno do codigo Origem

@author  Douglas Parreja
@since   17/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
user function csADEOrig()	
	local cCodOrig := ""
	cCodOrig := "1" //1 - Projeto Service-Desk x Checkout	
return cCodOrig

//-------------------------------------------------------------------
/*/{Protheus.doc} csZZRProcess
Funcao responsavel por realizar o Processamento do cadastro da 
rotina de cadastro da ZZR. 

@param	nOpc			Opcao que usuario escolheu
							3-Inclusao
							4-Alteracao
							5-Exclusao

@author  Douglas Parreja
@since   20/06/2016
@version 11.8
/*/
//-------------------------------------------------------------------
user function csZZRProcess( nOpc )

	default nOpc := 0
	
	if nOpc > 0
		//--------------------------------------
		// Inclusao
		//--------------------------------------
		if nOpc == 3
			csZZRIncl()
		//--------------------------------------	
		// Alteracao
		//--------------------------------------
		elseif nOpc == 4
			csZZRAlter()
		//--------------------------------------
		// Exclusao
		//--------------------------------------
		elseif nOpc == 5
			csZZRExcl()
		endif
	endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} csZZRIncl
Funcao responsavel por Incluir o cadastro. 

@author  Douglas Parreja
@since   13/07/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csZZRIncl()

	local aRet 	:= {}
	local lContinua	:= .T.
	
	lGravou := csGravaZZR( .T. , "1" )
	if !lGravou
		msgAlert("Não foi possível realizar a Inclusão do Registro. Favor verificar.", "Atenção")
	endif	
	
return
//-------------------------------------------------------------------
/*/{Protheus.doc} csZZRAlter
Funcao responsavel por Alterar o cadastro. 

@author  Douglas Parreja
@since   14/07/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csZZRAlter()

	aRet := csZZRValid()
	
	if len( aRet ) > 0
		if msgYesNo( "Divergências no cadastro devido a alteração. Deseja realizar a alteração mesmo assim ?","Atenção" )
			//csLogTela( aRet )
			u_csTelaAlt( aRet )
			lContinua := .T.
		else
			msgInfo( "Cancelado a Alteração do cadastro.")
		endif
	else
		lContinua := .F.
	endif
	
	if lContinua
		csGravaZZR( .F. , "2" )
	endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} csZZRExcl
Funcao responsavel por Excluir o cadastro. 

@author  Douglas Parreja
@since   14/07/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csZZRExcl()
	
	if MsgYesNo("Você realmente deseja excluir este cadastro?")    
		Begin Transaction
			//ZZR->(dbSetOrder(2)) //ZZR_FILIAL+ZZR_ORIGEM+ZZR_CDPROD+ZZR_CDGAR
			//if ZZR->( dbSeek( xFilial("ZZR") + alltrim( cOrigem ) + alltrim( cCodProd ) ))
				ZZR->( RecLock('ZZR',.F. ))
				ZZR->ZZR_STATUS	:= "3"
				ZZR->ZZR_USER	:= "User: " + logusername() + " | " + "Data: " + dtoc(Date()) + " - " + Time() + " | " + "IPClient: " + getClientIP()
				ZZR->( dbDelete() )
				ZZR->( MsUnLock() )					
			//else
			//	msgAlert("Não foi possível Excluir o registro. Favor verificar.","Atenção")
			//endif
		End Transaction	
		// Para posicionar no Grid apos qualquer gravacao, ordernar por Item.
		ZZR->( dbSetOrder(1) )	
	endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} csZZRValid
Funcao responsavel por validar o que esta sendo alterado no cadastro.

@author  Douglas Parreja
@since   13/07/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csZZRValid()

	local aLog			:= {}
	local lCampo		:= .T.
	local cLegenda		:= ""
	local cNotCampo		:= "Nao encontrado campo"
	local nPosOrigem 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_ORIGEM"	})
	local nPosGrupo 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_GRUPO"	})
	local nPosCdProd	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_CDPROD"	})
	local nPosCdGAR 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_CDGAR"	})
	local nPosDesc 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_DESC" 	})
	local nPosValor 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_VALOR"	})
	local nPosCodTab 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_CODTAB"	})
	local nPosAR	 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_AR"		})
	local nPosAC	 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_AC"		})
	local nPosStatus 	:= aScan(aCampos,{|x| AllTrim(x[2]) == "ZZR_STATUS"	})

	//-----------------------------------------------------------------
	// Orientacao posicoes Array aLog 
	// aLog[1] : Campo 
	// aLog[2] : 1.Se Tem Campo  -> Informacao que ja esta gravada na tabela.
	//			 2.Nao tem Campo -> Informando que nao tem o campo.
	// aLog[3] : 1.Se Tem Campo  -> Informacao que o usuario alterou.
	//			 2.Nao tem Campo -> Em branco		
	//-----------------------------------------------------------------
	
	if nPosOrigem > 0
		if (alltrim( ZZR->ZZR_ORIGEM ) == alltrim( cOrigem ))
			cLegenda := "1"
		else
			cLegenda := "2"			 
		endif
		aAdd( aLog, {"Origem", cLegenda, alltrim( ZZR->ZZR_ORIGEM ), alltrim( cOrigem )} )
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_ORIGEM", cLegenda, cNotCampo, "" } )
	endif
	
	if nPosGrupo > 0
		if (alltrim( ZZR->ZZR_GRUPO ) == alltrim( cGrupo ))
			cLegenda := "1"
		else
			cLegenda := "2"			 
		endif
		aAdd( aLog, {"Grupo", cLegenda, alltrim( ZZR->ZZR_GRUPO ), alltrim( cGrupo )} ) 		
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_GRUPO", cLegenda, cNotCampo, "" } )
	endif
	
	if nPosCdProd > 0
		if (alltrim( ZZR->ZZR_CDPROD ) == alltrim( cCodProd ))
			cLegenda := "1"
		else
			cLegenda := "2"	
		endif
		aAdd( aLog, {"Cod.Prod. Protheus", cLegenda, alltrim( ZZR->ZZR_CDPROD ), alltrim( cCodProd )} )
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_CDPROD", cLegenda, cNotCampo, "" } )
	endif
	
	if nPosCdGAR > 0	
		if (alltrim( ZZR->ZZR_CDGAR ) == alltrim( cCodGAR ))
			cLegenda := "1"
		else
			cLegenda := "2"	
		endif
		aAdd( aLog, {"Cod.Prod. GAR", cLegenda, alltrim( ZZR->ZZR_CDGAR ), alltrim( cCodGAR )} ) 		
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_CDGAR", cLegenda, cNotCampo, "" } )
	endif
	
	if nPosDesc > 0
		if (alltrim( ZZR->ZZR_DESC ) == alltrim( cDescProd ))
			cLegenda := "1"
		else
			cLegenda := "2"				 
		endif
		aAdd( aLog, {"Descricao Produto", cLegenda, alltrim( ZZR->ZZR_DESC ), alltrim( cDescProd )} )
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_DESC", cLegenda, cNotCampo, "" } )
	endif
/*	
	if nPosValor > 0
		if (alltrim( ZZR->ZZR_VALOR ) == alltrim( cValor ))
			cLegenda := "1"
		else
			cLegenda := "2"			 
		endif
		aAdd( aLog, {"Valor R$", cLegenda, alltrim( ZZR->ZZR_VALOR ), alltrim( cValor )} )
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_VALOR", cLegenda, cNotCampo, "" } )
	endif
*/	
	if nPosAR > 0
		if (alltrim( ZZR->ZZR_AR ) == alltrim( cAR ))
			cLegenda := "1"
		else
			cLegenda := "2"			 
		endif
		aAdd( aLog, {"AR", cLegenda, alltrim( ZZR->ZZR_AR ), alltrim( cAR )} )
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_AR", cLegenda, cNotCampo, "" } )
	endif
	
	if nPosAC > 0
		if (alltrim( ZZR->ZZR_AC ) == alltrim( cAC ))
			cLegenda := "1"
		else
			cLegenda := "2"			 
		endif
		aAdd( aLog, {"AC", cLegenda, alltrim( ZZR->ZZR_AC ), alltrim( cAC )} )
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_AC", cLegenda, cNotCampo, "" } )
	endif
	
	if nPosCodTab > 0
		if (alltrim( ZZR->ZZR_CODTAB ) == alltrim( cCodTab ))
			cLegenda := "1"
		else
			cLegenda := "2"					 
		endif
		aAdd( aLog, {"Cod. Tabela", cLegenda, alltrim( ZZR->ZZR_CODTAB ), alltrim( cCodTab )} )
	else
		cLegenda := "3"
		aAdd( aLog, {"ZZR_CODTAB", cLegenda, cNotCampo, "" } )
	endif
	
	if nPosStatus == 0
		cLegenda := "3"
		aAdd( aLog, {"ZZR_STATUS", cLegenda, cNotCampo, "" } )
	endif	

return aLog 

//-------------------------------------------------------------------
/*/{Protheus.doc} csGravaZZR
Funcao responsavel para gravacao na tabela ZZR.

@param	lReclock	Identifica se eh novo registro ou sera alterado.
		cStatus		Status do Cadastro
					1 = Novo Cadastro
					2 = Alterado
					3 = Exclusao
					
@return	lProcessa	Retorna se foi processado com sucesso ou nao.

@author  Douglas Parreja
@since   01/07/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csGravaZZR( lReclock, cStatus )

	local lGrava		:= .F.
	default lReclock 	:= .T.
	default cStatus	:= ""

	if csValidDados()
	
		Begin Transaction		
			dbSelectArea("ZZR")
			//ZZR->(dbSetOrder(2))	//ZZR_FILIAL+ZZR_ORIGEM+ZZR_CDPROD+ZZR_CDGAR
			ZZR->(dbSetOrder(3))	//ZZR_FILIAL+ZZR_CDGAR+ZZR_GRUPO+ZZR_CDPROD		
			//-------------------------------------------------------------
			// Inclusao
			//-------------------------------------------------------------	
			if lReclock						
				//-----------------------------------------------------------------
				// Verificar se consta ja o cadastro na base, caso ja tenha, 
				// nao realizo a inclusao e exibo a mensagem para o usuario 
				// verificar e nesse caso, localizar e acessar como "Alterar".
				//-----------------------------------------------------------------
				//if !ZZR->( dbSeek( xFilial("ZZR") + alltrim( cOrigem ) + alltrim( cCodProd ) ))			
				 cChave := ( xFilial("ZZR") + alltrim( cCodGar ) + alltrim( cGrupo ) + alltrim( cCodProd ) )
				 if !ZZR->( dbSeek( xFilial("ZZR") + alltrim( ZZR->ZZR_CDGAR ) + alltrim( ZZR->ZZR_GRUPO ) + alltrim( ZZR->ZZR_CDPROD ) ))
					lGrava := .T.
				else
					if ZZR->( dbSeek( xFilial("ZZR") + alltrim( ZZR->ZZR_CDGAR ) + alltrim( ZZR->ZZR_GRUPO ) + alltrim( ZZR->ZZR_CDPROD ) ))
						while !ZZR->(eof()) .and.  cChave == ZZR->(dbSeek(xFilial("ZZR")+alltrim(ZZR->ZZR_CDGAR)+alltrim(ZZR->ZZR_GRUPO)+alltrim(ZZR->ZZR_CDPROD) ))  
							aAdd( aZZR, {alltrim(ZZR->ZZR_CDGAR), alltrim(ZZR->ZZR_GRUPO), alltrim(ZZR->ZZR_CDPROD) } )
						end
						//if ascan( aZZR, {|x| x+x[5]== alltrim(cValor) } )
						//	msgInfo("Para este Produto '" + alltrim(cCodProd) +"' já consta na Base. " + Chr(13)+Chr(10) + ;
						//	"Favor localizar o Cadastro e acessar como 'Alterar'. ", "Atenção" )
						//else							
						//	lGrava := .T.
						//endif
					endif																			
				endif
				if lGrava
					ZZR->( Reclock( 'ZZR', lReclock ))
					ZZR->ZZR_FILIAL := xFilial("ZZR")
					ZZR->ZZR_ORIGEM	:= alltrim( cOrigem	 )
					ZZR->ZZR_ITEM	:= csGetNum( 'ZZR', 'ZZR_ITEM' )
					ZZR->ZZR_GRUPO	:= alltrim( cGrupo	 )
					ZZR->ZZR_CDPROD	:= alltrim( cCodProd )		
					ZZR->ZZR_CDGAR	:= alltrim( cCodGar	 )
					ZZR->ZZR_DESC	:= alltrim( cDescProd)
//					ZZR->ZZR_VALOR	:= alltrim( cValor	 )
					ZZR->ZZR_CODTAB := alltrim( cCodTab	 )
					ZZR->ZZR_AR		:= alltrim( cAR		 )
					ZZR->ZZR_AC		:= alltrim( cAC		 )	
					ZZR->ZZR_STATUS	:= alltrim( cStatus	 )
					ZZR->ZZR_USER	:= "User: " + logusername() + " | " + "Data: " + dtoc(Date()) + " - " + Time() + " | " + "IPClient: " + getClientIP()
					ZZR->( MsUnlock() ) 
				endif					
			//-------------------------------------------------------------
			// Alteracao
			//-------------------------------------------------------------
			else
				if ZZR->( dbSeek( xFilial("ZZR") + alltrim( cOrigem ) + alltrim( cCodProd ) ))			
					ZZR->( Reclock( 'ZZR', lReclock ))
					ZZR->ZZR_FILIAL := xFilial("ZZR")
					ZZR->ZZR_ORIGEM	:= alltrim( cOrigem	 )
					ZZR->ZZR_GRUPO	:= alltrim( cGrupo	 )
					ZZR->ZZR_CDPROD	:= alltrim( cCodProd )		
					ZZR->ZZR_CDGAR	:= alltrim( cCodGar	 )
					ZZR->ZZR_DESC	:= alltrim( cDescProd)
//					ZZR->ZZR_VALOR	:= alltrim( cValor	 )
					ZZR->ZZR_CODTAB := alltrim( cCodTab	 )
					ZZR->ZZR_AR		:= alltrim( cAR		 )
					ZZR->ZZR_AC		:= alltrim( cAC		 )	
					ZZR->ZZR_STATUS	:= alltrim( cStatus	 )
					ZZR->ZZR_USER	:= "User: " + logusername() + " | " + "Data: " + dtoc(Date()) + " - " + Time() + " | " + "IPClient: " + getClientIP()
					ZZR->( MsUnlock() ) 	
					lGrava := .T.										
				endif
			endif
			 
		End Transaction	
		// Para posicionar no Grid apos qualquer gravacao, ordernar por Item.
		ZZR->( dbSetOrder(1) )	  		
	endif
		
return lGrava

//-------------------------------------------------------------------
/*/{Protheus.doc} csValidDados
Valida dados enviado da Rotina. 

@author  Douglas Parreja
@since   01/07/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csValidDados()
	local lRet := .F.
	if ( !empty( cOrigem ) .and. !empty( cCodProd ) .and. !empty( cCodGAR ) ) 
		lRet := .T.
	endif
return lRet

//---------------------------------------------------------------
/*/{Protheus.doc} csGetNum
Funcao responsavel para retornar numero da SXE
				  
@param	cAlias		Alias da tabela 
		cCampo		Campo a ser validado para numeracao				  
@return	cNum		Retorna o numero valido para ser gerado na tabela.						

@author	Douglas Parreja
@since	31/07/2016
@version	11.8
/*/
//---------------------------------------------------------------
static function csGetNum( cAlias, cCampo )
	local aArea    	:= GetArea()
	local cNum		:= GetSXENum( cAlias, cCampo )
	local cNumOk	:= ""	
	local cNumProx	:= ""	
	local nSaveSx8 	:= GetSX8Len()
	local nI		:= 0	
	
	default cAlias	:= ""
	default cCampo 	:= ""
	
	DbSelectArea( cAlias )
	DbSetOrder( 1 )
	
	if !dbSeek( xFilial( cAlias ) + cNum )
		if !Empty(cNum) .and. nSaveSx8 > 0
			ConfirmSX8()
		endif
	else
		while empty(cNumOk)
			n1 := Iif( nI == 0, val(cNum), val(cNumProx) )
			n2 := n1 + 1
			cNumProx := StrZero( n2,6,0 )
			while !DbSeek( xFilial( cAlias ) + cNumProx )
				cNumOk 	:= cNumProx
				cNum 	:= cNumOk	
				ConfirmSX8()
				exit
			end
			nI ++ 
		end
	endif
	RestArea( aArea )
	
Return( cNum )

//---------------------------------------------------------------
/*/{Protheus.doc} csLogTela
Funcao que exibe um LOG para usuario informando divergencia
de dados.
				  					

@author	Douglas Parreja
@since	13/07/2016
@version 11.8
/*/
//---------------------------------------------------------------
static function csLogTela( aLog )

	local nX		:= 0
	default aLog	:= {}
	
	Help( ,, 'Help',, 'teste', 1, 0 )
	
	AutoGrLog("------------------------------------------------------------------------------------")
	AutoGrLog("LOG - CADASTRO PROJETO SAC x CHECKOUT ")
	AutoGrLog("------------------------------------------------------------------------------------")
	AutoGrLog("Segue abaixo dados do log: ")
	AutoGrLog("DATA......................: "+Dtoc(MsDate()))
	AutoGrLog("HORA......................: "+Time())
	AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
	AutoGrLog("MÓDULO.................: "+"SIGA"+cModulo)
	AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
	AutoGrLog("NOME EMPRESA.....: "+Capital(Trim(SM0->M0_NOME)))
	AutoGrLog("NOME FILIAL............: "+Capital(Trim(SM0->M0_FILIAL)))
	AutoGrLog("USUÁRIO..................: "+SubStr(cUsuario,7,15))

	if len(aLog) > 0
		for nX := 1 to len(aLog)    
			AutoGrLog("------------------------------------------------------------")
			if len(aLog[nX]) > 1
				AutoGrLog("Data geração ...: "+aLog[nX][2]  )      
			endif
		next
	endif
	
	// Exibe a tela de log	
	MostraErro()
		
return      
			
//-----------------------------------------------------------------------
/*/{Protheus.doc} csCheckUpd()
Funcao que verifica se o update do foi aplicado.

@return	lUpdOK		Verdadeiro se estiver ok o Update.

@author	Douglas Parreja
@since	14/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csCheckUpd()
 
	local lUpdOK	:= .F. 
	local cExec		:= "Cadastro ServiceDesk x Checkout"
	
	u_autoMsg(cExec, , "Inicio verificacao base")
	
	if AliasIndic("ZZR")
		lUpdOk := csValidBase()
		u_autoMsg(cExec, , "Termino verificacao base")
	else
		(cExec, ,'Nao eh possível continuar. Não existe a tabela ZZR.' ) 
	endif 
	
	
return lUpdOK	

//-----------------------------------------------------------------------
/*/{Protheus.doc} csValidBase
Funcao que verifica se consta/configurado parametros e tabela.

@return	lOk		Retorna se o ambiente esta preparado para prosseguir.

@author	Douglas Parreja
@since	14/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csValidBase()

	local cBarra			:= IIf(IsSrvUnix(),'/','\')	
	local cSystem			:= cBarra + 'system' + cBarra
	local lOk				:= .T.
	local cMVGrupo			:= 'MV_SERVGRU'
	local cMVLink			:= 'MV_LINKCHK'			
	local cMVChkGrupo		:= 'MV_CHKGRUP'
	local cMVChkVendaOcorr	:= 'MV_CHKOCVD'
	local cMVChkOcor		:= 'MV_CHKOCOR'
	local cMVChkAcao		:= 'MV_CHKACAO'	
	local cMVChkUser		:= 'MV_CHKUSER'
	local cMVPcdUser		:= 'MV_PCDUSER'
	local cExec				:= "Service-Desk x Checkout"

	//-------------------------------------------------------------------------------------------
	// MV_SERVGRU - Define o código do Grupo de Entidades para pesquisa rapida na SZ3.
	// Neste parametro, eh preciso informar o Nome do Grupo conforme o campo Z3_CODGAR. 
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVGrupo, .T. )
		CriarSX6( cMVGrupo, 'C', 'Informe Grupo pesquisa rapida-(Z3_CODGAR)PJSAC', 'PJSAC' )
		u_autoMsg(cExec, , "criado parametro MV_SERVGRU - Informe Grupo pesquisa rapida - Proj SAC")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_LINKCHK - Define o Link do Checkout que sera realizado a comunicacao com o Protheus.
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVLink, .T. )
		CriarSX6( cMVLink, 'C', 'Informe Link do Checkout x Protheus', 'http://10.100.0.52:8080/vendas/geraPedido?ticket=' )
		u_autoMsg(cExec, , "criado parametro MV_LINKCHK - Informe Link do Checkout x Protheus - Proj SAC")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_CHKGRUP - Define o Grupo que tera acesso a rotina para geracao da integracao com Checkout
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVChkGrupo, .T. )
		CriarSX6( cMVChkGrupo, 'C', 'Grupo ServDesk integracao Checkout', '' )
		u_autoMsg(cExec, , "criado parametro MV_CHKGRUP - Define o Grupo que tera acesso a rotina para geracao da integracao com Checkout - Proj SAC")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_CHKOCVD - Ocorrencia definida da Venda Checkout, com esta ocorrencia que o Service-Desk
	// entendera que se trata da Integracao.
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVChkVendaOcorr, .T. )
		CriarSX6( cMVChkVendaOcorr, 'C', 'Ocorrencia Venda Checkout (ADF)', '' )
		u_autoMsg(cExec, , "criado parametro MV_CHKOCVD - Ocorrencia definida da Venda Checkout, com esta ocorrencia que o Service-Desk entendera que se trata da Integracao. - Proj SAC")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_CHKOCOR - Define qual Ocorrencia sera realizada na integracao com Checkout (ADF)
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVChkOcor, .T. )
		CriarSX6( cMVChkOcor, 'C', 'Ocorrencia gerada integracao Checkout (ADF)', '' )
		u_autoMsg(cExec, , "criado parametro MV_CHKOCOR - Define qual Ocorrencia sera realizada na integracao com Checkout ADF - Proj SAC")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_CHKACAO - Define qual Acao sera realizada na integracao com Checkout (ADF)
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVChkAcao, .T. )
		CriarSX6( cMVChkAcao, 'C', 'Acao gerada integracao Checkout (ADF)', '' )
		u_autoMsg(cExec, , "criado parametro MV_CHKACAO - Define qual Acao sera realizada na integracao com Checkout ADF - Proj SAC")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_CHKUSER - Define qual usuario tera acesso a rotina de Cadastro Produto x Checkout. 
	// Este parametro eh para restringir os acessos a essa rotina devido ser uma
	// rotina de Gerenciamento e apenas algumas pessoas autorizadas poderao ter acesso. 
	// Fonte: csADE04Cad.prw
	// Tabela: ZZR
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVChkUser, .T. )
		CriarSX6( cMVChkUser, 'C', 'Usuarios com acesso Cad.Prod x Checkout-csADE04Cad', 'douglas.parreja' )
		u_autoMsg(cExec, , "criado parametro MV_CHKUSER - Define qual usuario tera acesso a rotina de Cadastro Produto x Checkout - Proj SAC")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_PCDUSER - Define qual usuario tera acesso a rotina com a Legenda alterado.
	// Este parametro faz com que a legenda que eh exibida para o usuario que possui PCD visual
	// seja diferente, ou seja, nao consta as cores e sim desenhos, para melhor facilitar a
	// visualizacao.	
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVPcdUser, .T. )
		CriarSX6( cMVPcdUser, 'C', 'Usuarios PCD Visual, legenda alterada', 'douglas.parreja' )
		u_autoMsg(cExec, , "criado parametro MV_PCDUSER - Define qual usuario tera acesso a rotina com a Legenda alterado.")
	endif
	
	//-------------------------------------------------------------------------------------------
	// TABELA ZZR
	//-------------------------------------------------------------------------------------------
	if AliasIndic("ZZR")  
		cNome:= SubStr(Posicione('SX2',1,'ZZR','X2_ARQUIVO'),4,5)
		if !( posicione("SX2",1,"ZZR","X2_ARQUIVO") == ("ZZR" + cNome) )			
			msgAlert('Não é possível continuar. Existe a tabela ZZR, mas obteve falha na validação.' )
			lOk := .F.	
		endif
		DbSelectArea("SX3")
		DbSetOrder(2)	//X3_CAMPO
		if 	!dbSeek("ZZR_ORIGEM") .Or. !dbSeek("ZZR_ITEM") .Or. !dbSeek("ZZR_GRUPO") .Or.;
			!dbSeek("ZZR_CDPROD") .Or. !dbSeek("ZZR_CDGAR") .Or. !dbSeek("ZZR_DESC") .Or. ;
			!dbSeek("ZZR_VALOR") .Or. !dbSeek("ZZR_CODTAB") .Or. !dbSeek("ZZR_AR") .Or. ;
			!dbSeek("ZZR_AC") .Or. !dbSeek("ZZR_STATUS")
			msgAlert('Não é possível continuar. Favor executar o compatibilizador updcsSAC01 para criação dos campos abaixo: ' + Chr(13)+Chr(10) + ;
			  		 'ZZR_ORIGEM, ZZR_ITEM, ZZR_GRUPO, ZZR_CDPROD, ZZR_CDGAR, ZZR_DESC, ZZR_VALOR, ZZR_CODTAB, ZZR_AR, ZZR_AC, ZZR_STATUS.','Compatibilizador updcsSAC01' )
			lOk := .F.
		endif
	else
		msgAlert('Não é possível continuar. Não existe a tabela ZZR. Favor executar o compatibilizador updcsSAC01.' )
		lOk := .F.
	endif	
	
	//-------------------------------------------------------------------------------------------
	// TABELA ADE
	//-------------------------------------------------------------------------------------------
	if AliasIndic("ADE")  
		cNome:= SubStr(Posicione('SX2',1,'ADE','X2_ARQUIVO'),4,5)
		if !( posicione("SX2",1,"ADE","X2_ARQUIVO") == ("ADE" + cNome) )			
			msgAlert('Não é possível continuar. Existe a tabela ADE, mas obteve falha na validação.' )
			lOk := .F.	
		endif
		DbSelectArea("SX3")
		DbSetOrder(2)	//X3_CAMPO
		if 	!dbSeek("ADE_KTIPO"	) .Or. !dbSeek("ADE_KPROD "	) .Or. !dbSeek("ADE_KNOME"	) .Or.;
			!dbSeek("ZZR_CDPROD") .Or. !dbSeek("ZZR_CDGAR"	) .Or. !dbSeek("ZZR_DESC"	) .Or. ;
			!dbSeek("ADE_KCGC"	) .Or. !dbSeek("ADE_KRG"	) .Or. !dbSeek("ADE_KORGEX"	) .Or. ;
			!dbSeek("ADE_KDTNAS") .Or. !dbSeek("ADE_KSEXO"	) .Or. !dbSeek("ADE_KEMAIL"	) .Or. ;
			!dbSeek("ADE_KCMAIL") .Or. !dbSeek("ADE_KTEL"	) .Or. !dbSeek("ADE_KCEL"	) .Or. ;
			!dbSeek("ADE_KCEP"	) .Or. !dbSeek("ADE_KEND"	) .Or. !dbSeek("ADE_KCOMPL"	) .Or. ;
			!dbSeek("ADE_KBAIRR") .Or. !dbSeek("ADE_KCIDAD"	) .Or. !dbSeek("ADE_KUF"	) .Or. ;
			!dbSeek("ADE_KEST"	) .Or. !dbSeek("ADE_KINSCE"	) .Or. !dbSeek("ADE_KINSCM"	) .Or. ;
			!dbSeek("ADE_KNOMCT") .Or. !dbSeek("ADE_KTELCT"	) .Or. !dbSeek("ADE_KTRIB"	) .Or. ;
			!dbSeek("ADE_KMOTCP") .Or. !dbSeek("ADE_KGRTAB"	) .Or. !dbSeek("ADE_KCDPRO"	) .Or. ;
			!dbSeek("ADE_KAR"	) .Or. !dbSeek("ADE_KAC"	) .Or. !dbSeek("ADE_KC5NUM"	) 
			msgAlert('Não é possível continuar. Favor executar o compatibilizador updcsSAC01 para criação dos campos abaixo: ' + Chr(13)+Chr(10) + ;
			  		 'ADE_KTIPO, ADE_KPROD,ADE_KNOME, ADE_KCGC, ADE_KRG, ADE_KORGEX, ADE_KDTNAS, ADE_KSEXO, '+ Chr(13)+Chr(10) + ;
			  		 'ADE_KEMAIL, ADE_KCMAIL, ADE_KTEL, ADE_KCEL, ADE_KCEP, ADE_KEND, ADE_KCOMPL, ADE_KBAIRR, ADE_KCIDAD, ADE_KUF, ADE_KEST, '+ Chr(13)+Chr(10) + ;
			  		 'ADE_KINSCE, ADE_KINSCM, ADE_KNOMCT, ADE_KTELCT, ADE_KTRIB, ADE_KMOTCP, ADE_KGRTAB, ADE_KCDPRO, ADE_KAR, ADE_KAC, ADE_KC5NUM.' ,'Compatibilizador updcsSAC01' )
			lOk := .F.
		endif
	else
		msgAlert('Não é possível continuar. Não existe a tabela ZZR. Favor executar o compatibilizador updcsSAC01.' )
		lOk := .F.
	endif	
	
return lOk

//-----------------------------------------------------------------------
/*/{Protheus.doc} csTelaProd()
Rotina para exibicao da tela do Produto na Rotina Service-Desk.

@param	aDados		Dados enviados da Query a ser exibido na tela.

@author	Douglas Parreja
@since	19/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csTelaProd( cCabec, aDados )
 
	local aACampos  	:= {"CODIGO"} 	//Variável contendo o campo editável no Grid
	local aBotoes		:= {}        	//Variável onde será incluido o botão para a legenda
	local aCabecalho	:= {}        	//Variavel que montará o aHeader do grid
	local aColsEx 		:= {}        	//Variável que receberá os dados
	
	private oLista                	//Declarando o objeto do browser
	private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")
	private oAzul  	:= LoadBitmap( GetResources(), "BR_AZUL")
	private oLaranja  	:= LoadBitmap( GetResources(), "BR_LARANJA")
	private oVermelho 	:= LoadBitmap( GetResources(), "BR_VERMELHO")
	private oAmarelo  	:= LoadBitmap( GetResources(), "BR_AMARELO")
	private oPink  	:= LoadBitmap( GetResources(), "BR_PINK")
	private oVerdeEsc 	:= LoadBitmap( GetResources(), "BR_VERDE_ESCURO")
	private oVioleta  	:= LoadBitmap( GetResources(), "BR_VIOLETA")
	private oPreto  	:= LoadBitmap( GetResources(), "BR_PRETO")
	private oAzulCla  	:= LoadBitmap( GetResources(), "BR_AZUL_CLARO")
	private oCinza  	:= LoadBitmap( GetResources(), "BR_CINZA")
	private oBranco  	:= LoadBitmap( GetResources(), "BR_BRANCO")
	
	private oPcdVerde 		:= LoadBitmap( GetResources(), "S4WB001N")
	private oPcdAzul  		:= LoadBitmap( GetResources(), "GRAF3D")
	private oPcdLaranja  	:= LoadBitmap( GetResources(), "VENDEDOR")
	private oPcdAmarelo  	:= LoadBitmap( GetResources(), "DBG06")
	private oPcdPink  		:= LoadBitmap( GetResources(), "AUTOM")
	private oPcdVerdeEsc 	:= LoadBitmap( GetResources(), "OBJETIVO")
	private oPesq
	private cPesq				:= space(200)
	private cCombo1			:= ""
	private aItems			:= {"Descrição","Grupo"}
	private oCombo1
		
	default cCabec		:= ""
	default aDados		:= {}
	
	DEFINE MSDIALOG oDlg TITLE cCabec FROM 000, 000  TO 350, 1000  PIXEL
		
		//------------------
		// Tipo de Pesquisa
		//------------------
       cCombo1:= aItems[1]
       oCombo1 := TComboBox():New(37,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
       aItems,50,14,oDlg,,{||},,,,.T.,,,,,,,,,'cCombo1')
		//------------------
		// Texto de pesquisa
		//------------------
		@ 37,62 MSGET oPesq VAR cPesq SIZE 120,11 COLOR CLR_BLACK PIXEL OF oDlg PICTURE "@!"
		//------------------------------------------
		// Interface para selecao de indice e filtro
		//------------------------------------------
		@ 37,188 BUTTON "Filtrar" SIZE 37,12 PIXEL OF oDlg ACTION(xlocaliza(cPesq))
	
		//---------------------------------------------------------
		//chamar a função que cria a estrutura do aHeader
		//---------------------------------------------------------
		aCabecalho := csCriaCabec()
		
		//---------------------------------------------------------	
		//Monta o browser com inclusão, remoção e atualização
		//---------------------------------------------------------
		oLista := MsNewGetDados():New( 053, 001, 170, 500, GD_INSERT+GD_DELETE+GD_UPDATE, /*{|| Iif( TesteOla(aColsEx), oDlg:End(), .F.) }*/"AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)
		
		//---------------------------------------------------------
		//Carregar os itens que irão compor o conteudo do grid
		//---------------------------------------------------------
		aColsEx := csCarregar( aDados )
		
		//---------------------------------------------------------
		//Alinho o grid para ocupar todo o meu formulário
		//---------------------------------------------------------
		//oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		//---------------------------------------------------------
		//Ao abrir a janela o cursor está posicionado no meu objeto
		//---------------------------------------------------------
		oLista:oBrowse:SetFocus()
		
		//---------------------------------------------------------
		//Crio o menu que irá aparece no botão Ações relacionadas
		//---------------------------------------------------------
		aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})
		
		EnchoiceBar(oDlg, {|| Iif( csTelaProcess(), oDlg:End(), .F.) }, {|| oDlg:End() },,aBotoes)
			
	ACTIVATE MSDIALOG oDlg CENTERED
    
Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csTelaProcess()
Funcao para verificar qual linha foi selecionada e retornar a descricao
no campo posicionado.

@return	.T.		Return eh .T. para nao ocorrer error.log devido a uma 
				condicao que estou fazendo na chamada dele.

@author	Douglas Parreja
@since	20/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csTelaProcess()
	
	Local oRestClient
	Local aHeader := {"tenantId: 01,02"}
	Local cRenov	:= ""
	Private aDados
	
	if valtype( oLista ) <> "U"	
		if oLista:nAt > 0
			u_csADEKPROD(alltrim( oLista:aCols[oLista:nAt][4] ))
			M->ADE_KPROD 	:= alltrim( oLista:aCols[oLista:nAt][4] )
			M->ADE_KGRTAB	:= alltrim( oLista:aCols[oLista:nAt][5] )
			M->ADE_KCDPRO	:= alltrim( oLista:aCols[oLista:nAt][3] )
			M->ADE_KAR		:= alltrim( oLista:aCols[oLista:nAt][7] )
			M->ADE_KAC		:= alltrim( oLista:aCols[oLista:nAt][8] )
			
			// 15/05/2018 - Renato Ruy
			// 2018042010002811 ] Campo "Produto" do grupo 42
			// Tratamento para retornar valor para o novo campo virtual
			// Na URI - Informar se e renovacao '&renovacao=true'
			DbSelectArea("ZZW")
			If ZZW->(DbSeek(xFilial("ZZW")+"001"))
				
				//Busca preço de renovação
				If M->ADE_KRENOV == "1"
					cRenov := "&renovacao=true"
				Endif
			
				oRestClient :=FWRest():New(AllTrim(ZZW->ZZW_HTTP)) //Link Base
				oRestClient:setPath("/rest/api/carrinho?codigo="+alltrim( oLista:aCols[oLista:nAt][3] )+"&quantidade=1&grupo="+alltrim( oLista:aCols[oLista:nAt][5] )+"&codigoOrigem=9&ar="+alltrim( oLista:aCols[oLista:nAt][7] )+cRenov) //Pasta das imagens
				oRestClient:cPath := "/rest/api/carrinho?codigo="+alltrim( oLista:aCols[oLista:nAt][3] )+"&quantidade=1&grupo="+alltrim( oLista:aCols[oLista:nAt][5] )+"&codigoOrigem=9&ar="+alltrim( oLista:aCols[oLista:nAt][7] )+cRenov
				Aadd(aHeader, "Authorization: Basic " + Encode64(AllTrim(ZZW->ZZW_USER)+":"+AllTrim(ZZW->ZZW_SENHA)))
				
				//Verifica se conseguiu fazer o get com o JSON
				If oRestClient:Get(aHeader)
				   FWJsonDeserialize(oRestClient:GetResult(),@aDados) //Adiciona retorno para um array
				   M->ADE_KVALOR := aDados:ValorTotal
				Else
				   Alert("Não foi possível se conectar ao serviço para consultar preço, erro: " +oRestClient:GetLastError())
				   M->ADE_KVALOR := 0
				   Return .F.
				Endif
			Else
				MsgInfo("Não foi possível localizar a tabela de cadastro Rest!")
				M->ADE_KVALOR := 0
			Endif
		endif
	endif
		
return .T.
//-----------------------------------------------------------------------
/*/{Protheus.doc} csCriaCabec()
Rotina para criacao do Cabecalho da rotina.
Obs.:Utilizado outro nome de variavel para diferenciar acima.

@author	Douglas Parreja
@since	15/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csCriaCabec()
    
    local aCabec := {}
    
    Aadd(aCabec, {;
			"",;			//X3Titulo()
	       "IMAGEM",;  	//X3_CAMPO
	       "@BMP",;		//X3_PICTURE
	       3,;				//X3_TAMANHO
	       0,;				//X3_DECIMAL
	       ".F.",;			//X3_VALID
	       "",;			//X3_USADO
	       "C",;			//X3_TIPO
	       "",; 			//X3_F3
			"V",;			//X3_CONTEXT
	       "",;			//X3_CBOX
	       "",;			//X3_RELACAO
	       "",;			//X3_WHEN
	       "V"})			//
    Aadd(aCabec, {;
			"Item",;		//X3Titulo()
           "ITEM",;  		//X3_CAMPO
           "@!",;			//X3_PICTURE
           5,;				//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
    Aadd(aCabec, {;
           "Cod. Prod. Site",;	//X3Titulo()
           "CODPRO",; 	 	//X3_CAMPO
           "@!",;			//X3_PICTURE
           20,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
    Aadd(aCabec, {;
           "Descricao",;	//X3Titulo()
           "DESC",;  		//X3_CAMPO
           "@!",;			//X3_PICTURE
           90,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",;			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN             
    Aadd(aCabec, {;
           "Grupo",;		//X3Titulo()
           "GRUPO",;  		//X3_CAMPO
           "@!",;			//X3_PICTURE
           20,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",;			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
           
	Aadd(aCabec, {;
           "Cod. Prod.Protheus",;	//X3Titulo()
           "CODPRO",; 	 	//X3_CAMPO
           "@!",;			//X3_PICTURE
           20,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
	/*Aadd(aCabec, {;
           "Valor R$",;	//X3Titulo()
           "VALOR",; 	 	//X3_CAMPO
           "@!",;			//X3_PICTURE
           20,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN*/
	Aadd(aCabec, {;
           "AR",;			//X3Titulo()
           "AR",; 	 		//X3_CAMPO
           "@!",;			//X3_PICTURE
           30,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
	Aadd(aCabec, {;
           "AC",;			//X3Titulo()
           "AC",; 	 		//X3_CAMPO
           "@!",;			//X3_PICTURE
           30,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
	Aadd(aCabec, {;
           "Cod. Tabela Grupo",;	//X3Titulo()
           "CODGRU",; 	 	//X3_CAMPO
           "@!",;			//X3_PICTURE
           10,;			//X3_TAMANHO
           0,;				//X3_DECIMAL
           "",;			//X3_VALID
           "",;			//X3_USADO
           "C",;			//X3_TIPO
           "",; 			//X3_F3
           "R",;			//X3_CONTEXT
           "",;			//X3_CBOX
           "",;			//X3_RELACAO
           ""})			//X3_WHEN
            

return aCabec
//-----------------------------------------------------------------------
/*/{Protheus.doc} csCriaCabec()
Rotina para criacao do Cabecalho da rotina.
Obs.:Utilizado outro nome de variavel para diferenciar acima.

@param	aDados		Consta as informacoes gravadas e alteradas.


@author	Douglas Parreja
@since	15/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csCarregar( aDados )

	local aColsEx 		:= {}
	local aMVServGrupo	:= {}
	local nX 			:= 0
	local cMVServGrupo := alltrim(getMv("MV_SERVGRU"))
	local lObj			:= .F.
	local cMVPcdUser 	:= "MV_PCDUSER"
	local lUserPCD 	:= u_csUserAcesso(cMVPcdUser)
	
	default aDados		:= {}
	
	//----------------------------------------
	// STATUS ARRAY
	// aColsEx[1]  - Legenda
	// aColsEx[2]  - Item
	// aColsEx[3]  - Cod. Produto
	// aColsEx[4]  - Descricao
	// aColsEx[5]  - Grupo
	// aColsEx[6]  - Cod.Prod.GAR
	// aColsEx[7]  - Valor
	// aColsEx[8]  - AR
	// aColsEx[9]  - AC
	// aColsEx[10] - Cod.Tabela	
	//
	// Legenda: 
	// Verde -> Registro consta no Grupo - MV_SERVGRU.
	// Azul  -> Registro NAO consta no Grupo.		
	//----------------------------------------
	if len( aDados ) > 0
		for nX := 1 to len( aDados )	
			if( alltrim( aDados[nX,4] ) $ cMVServGrupo )
				lObj := .T.							
			else
				lObj := .F. 
			endif							
			aadd(aColsEx, { iif( lObj, csCoresGrupo(alltrim(aDados[nX,4]), cMVServGrupo) , iif( lUserPCD, oPcdAzul, oAzul ) )	,;	//1
							StrZero(nX,3)				,;	//2
							aDados[nX,2]				,;	//3
							aDados[nX,3]				,;	//4
							aDados[nX,4]				,;	//5
							aDados[nX,5]				,;	//6
							aDados[nX,6]				,;	//7
							aDados[nX,7]				,;	//8
							aDados[nX,8]				,;	//9
							.F. })								
		next
	endif
	
	//----------------------------------------
	//Setar array do aCols do Objeto
	//----------------------------------------
	oLista:SetArray(aColsEx,.T.)
	
	//----------------------------------------
	//Atualizo as informacoes no grid
	//----------------------------------------
	oLista:Refresh()
	
Return aColsEx

//-----------------------------------------------------------------------
/*/{Protheus.doc} Legenda()
Funcao para obter as cores da Legenda.

@author	Douglas Parreja
@since	15/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function Legenda()

    local aLegenda := {}
    
    aAdd( aLegenda,{"BR_VERDE"    	,"   Produto consta no Grupo Parametrizado." 		})
    aAdd( aLegenda,{"BR_AZUL"    	,"   Produto NAO consta no Grupo Parametrizado." 	})    
    aAdd( aLegenda,{"BR_MARRON"    	,"Cores diferentes a partir do Grupo" 	})

    BrwLegenda("Legenda", "Legenda", aLegenda)

Return Nil

//-----------------------------------------------------------------------
/*/{Protheus.doc} csValidCGC()
Funcao responsavel por validar se existe o Cliente na Base, caso exista,
retorna com os dados automaticamente, preenchendo os campos.

@author	Douglas Parreja
@since	20/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csValidCGC()
	
	local cCGC		:= alltrim(M->ADE_KCGC) 
	Local nTamTel	:= Tamsx3("ADE_KTEL")[1]
	
	if csValidTabela() .and. alltrim(cCGC) <> ""
		
		aHeaderRet := u_HeaderSX3( "ADE" )
		
		dbSelectArea("SA1")
		SA1->(dbSetOrder(3)) //A1_FILIAL+A1_CGC
		if SA1->( dbSeek( xFilial("SA1") + U_CSFMTSA1(cCGC) ))
			if cCGC == alltrim( SA1->A1_CGC )						
				M->ADE_KCGC 	:= cCGC																								//CNPJ ou CPF
				M->ADE_KNOME	:= iif( !empty(SA1->A1_NOME)	, SA1->A1_NOME			, u_HeaderTam(aHeaderRet,"ADE_KNOME"	) )	//Nome
				M->ADE_KEMAIL	:= iif( !empty(SA1->A1_EMAIL)	, SA1->A1_EMAIL			, u_HeaderTam(aHeaderRet,"ADE_KEMAIL"	) )	//E-mail
				M->ADE_KTEL		:= iif( !empty(SA1->A1_TEL)		, PadR( alltrim(SA1->A1_DDD)+alltrim(SA1->A1_TEL), nTamTel, ' ' )	, u_HeaderTam(aHeaderRet,"ADE_KTEL"		) )	//Telefone 
				M->ADE_KCEP		:= iif( !empty(SA1->A1_CEP)		, SA1->A1_CEP			, u_HeaderTam(aHeaderRet,"ADE_KCEP"		) )	//CEP
				M->ADE_KEND		:= iif( !empty(SA1->A1_END)		, SA1->A1_END			, u_HeaderTam(aHeaderRet,"ADE_KEND"		) )	//Endereco
				M->ADE_KCOMPL	:= iif( !empty(SA1->A1_COMPLEM)	, SA1->A1_COMPLEM		, u_HeaderTam(aHeaderRet,"ADE_KCOMPL"	) )//Complemento
				M->ADE_KBAIRR	:= iif( !empty(SA1->A1_BAIRRO)	, SA1->A1_BAIRRO		, u_HeaderTam(aHeaderRet,"ADE_KBAIRR"	) )	//Bairro
				M->ADE_KCIDAD	:= iif( !empty(SA1->A1_MUN)		, SA1->A1_MUN			, u_HeaderTam(aHeaderRet,"ADE_KCIDAD"	) )	//Cidade
				M->ADE_KUF		:= iif( !empty(SA1->A1_EST)		, SA1->A1_EST			, u_HeaderTam(aHeaderRet,"ADE_KUF"		) ) //UF
				M->ADE_KEST		:= iif( !empty(SA1->A1_ESTADO)	, SA1->A1_ESTADO		, u_HeaderTam(aHeaderRet,"ADE_KEST"		) )	//Estado
				M->ADE_KINSCE	:= iif( !empty(SA1->A1_INSCR)	, SA1->A1_INSCR			, u_HeaderTam(aHeaderRet,"ADE_KINSCE"	) )	//Insc. Estadual
				M->ADE_KINSCM	:= iif( !empty(SA1->A1_INSCRM)	, SA1->A1_INSCRM		, u_HeaderTam(aHeaderRet,"ADE_KINSCM"	) )	//Insc. Municipal									
			endif	
		else
			msgInfo("Cliente não localizado no Cadastro de Cliente. Por gentileza, preenche os campos abaixo.","Atenção")
			limpaade()
		endif 			
	else
		limpaade()
	endif	
	
return cCGC

Static Function limpaade()
			M->ADE_KCGC 	:= space(tamsx3("ADE_KCGC")[1])
			M->ADE_KRG		:= space(tamsx3("ADE_KRG")[1])
			M->ADE_KORGEX	:= space(tamsx3("ADE_KORGEX")[1])
			M->ADE_KDTNAS	:= space(tamsx3("ADE_KDTNAS")[1])
			M->ADE_KSEXO	:= space(tamsx3("ADE_KSEXO")[1])			
			M->ADE_KNOME	:= space(tamsx3("ADE_KNOME")[1])
			M->ADE_KEMAIL	:= space(tamsx3("ADE_KEMAIL")[1])
			M->ADE_KCMAIL	:= space(tamsx3("ADE_KCMAIL")[1])
			M->ADE_KTEL		:= space(tamsx3("ADE_KTEL")[1])
			M->ADE_KCEL		:= space(tamsx3("ADE_KCEL")[1])
			M->ADE_KCEP		:= space(tamsx3("ADE_KCEP")[1])
			M->ADE_KEND		:= space(tamsx3("ADE_KEND")[1])
			M->ADE_KCOMPL	:= space(tamsx3("ADE_KCOMPL")[1])
			M->ADE_KBAIRR	:= space(tamsx3("ADE_KBAIRR")[1])
			M->ADE_KCIDAD	:= space(tamsx3("ADE_KCIDAD")[1])
			M->ADE_KUF		:= space(tamsx3("ADE_KUF")[1])
			M->ADE_KEST		:= space(tamsx3("ADE_KEST")[1])
			M->ADE_KINSCE	:= space(tamsx3("ADE_KINSCE")[1])
			M->ADE_KINSCM	:= space(tamsx3("ADE_KINSCM")[1])
return
//-----------------------------------------------------------------------
/*/{Protheus.doc} csValidEnd()
Funcao responsavel por validar se existe o CEP digitado consta na base.
Somente sera populado os campos, se caso ao preencher o CPF do cliente
nao localizou o cadastro, o campo Endereco estara em branco, e com isso
ele populara com o CEP informado.
Realizado esta validacao para evitar caso ja esteja populado o campo do
endereco, como o campo do CEP vira preenchido, para q no gatilho ele 
nao realize a nova consulta e popule novamente os campos, principalmente
do endereco e apagando no qual ja estaria cadastrado.

@author	Douglas Parreja
@since	20/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csValidEnd()

	local cCEP := alltrim(M->ADE_KCEP)
	
	if csValidTabela()
		dbSelectArea("PA7")
		PA7->(dbSetOrder(1)) //PA7_FILIAL+PA7_CODCEP
		if PA7->( dbSeek( xFilial("PA7") + cCEP ))
			if cCEP == alltrim(PA7->PA7_CODCEP) //.and. empty(M->ADE_KEND)
				M->ADE_KEND 	:= PA7->PA7_LOGRA
				M->ADE_KCEP		:= PA7->PA7_CODCEP
				M->ADE_KBAIRR 	:= PA7->PA7_BAIRRO
				M->ADE_KUF 		:= PA7->PA7_ESTADO
				M->ADE_KCIDAD 	:= PA7->PA7_MUNIC				 
			endif
		endif
	endif
	
return cCEP
		
//-----------------------------------------------------------------------
/*/{Protheus.doc} HeaderSX3()
Funcao responsavel por retornar os dados dos campos de uma determinada
tabela no SX3.

@param	cTabela			Nome da tabela a ser realizada a consulta.
@return	aHeaderNew		Array contendo os campos da SX3.

@author	Douglas Parreja
@since	20/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function HeaderSX3( cTabela )

	local aHeaderNew	:={}
	default cTabela 	:= ""
	
	if !empty( cTabela )
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek(cTabela)		
		
		
		while !eof() .And. (SX3->X3_ARQUIVO == cTabela)
			
			if X3USO(SX3->X3_USADO) 											
				aAdd(aHeaderNew,{ 	TRIM(X3_TITULO)	,;
								X3_CAMPO		,;
								X3_PICTURE		,;
								X3_TAMANHO		,;
								X3_DECIMAL		,;
								X3_VALID		,;
								X3_USADO		,;
								X3_TIPO			,; 
								X3_ARQUIVO		,;
								X3_CONTEXT 		})
			endif
			dbSkip()
		end
	endif

return aHeaderNew

//-----------------------------------------------------------------------
/*/{Protheus.doc} HeaderTam()
Funcao responsavel por retornar o tamanho do campo da SX3.

@param	cCampo			Campo a ser validado.
@return	cTamSpace		Retorna ja em formato de Space.

@author	Douglas Parreja
@since	21/07/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function HeaderTam( aHeaderRet, cCampo )

	local cTamSpace		:= ""
	default aHeaderRet	:= {}
	default cCampo 	:= ""	

	if ( (len( aHeaderRet ) > 0) .and. (!empty( cCampo )) )
		cTamSpace := iif( ascan( aHeaderRet, {|x| alltrim(x[2]) == alltrim(cCampo) }) > 0 ,;
			  				space(aHeaderRet[ascan( aHeaderRet, {|x| alltrim(x[2]) == alltrim(cCampo) })][4]) ,;
			  				.F. )	
	endif	

return cTamSpace

//-----------------------------------------------------------------------
/*/{Protheus.doc} csUserAcesso()
Funcao responsavel por verificar se usuario logado tem permissao conforme
o parametro.

@param	cMV			Parametro a ser consultado.
@return	lRet		Retorna se tem permissao ou nao.

@author	Douglas Parreja
@since	02/09/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csUserAcesso( cMV )

	local lRet			:= .F.
	local cMVChkUser	:= ""
	
	default cMV		:= ""
	
	cMVChkUser	:= iif( !empty(cMV), alltrim(getMv(cMV)), cMV )
	
	if !empty( cMVChkUser )
		lRet := Iif( cUserName $ cMVChkUser, .T. , .F. )	
	endif
	
return lRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} csValor()
Funcao responsavel por transformar a exibicao do campo de Valor de Moeda
na tela, ou seja, ao inves de trazer '110' neste caso trazera '110,00'.

@param	cValor		Conteudo do valor na tabela.
@return	cValor		Retorna o valor correto para exibicao.

@author	Douglas Parreja
@since	05/09/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csValor( nValor )

	local nX		:= 0
	local cValor	:= ""
	local lOk		:= .F.
	
	default nValor := 0
	
	cValor := alltrim(Str( nValor ))
	
	if !empty( cValor ) 
		for nX := 1 to len( cValor )
			if (substr(cValor,nX,1)) $ ",|."
				if empty(substr(cValor,nX+1,1))  
					cValor := alltrim( cValor + "00" )
					lOk	 := .T.	
				endif
				if empty(substr(cValor,nX+2,1))
					cValor := alltrim( cValor + "0" )
					lOk  := .T.
				else 
					lOk := .T.
				endif				
			else
				if (nX == len(cValor) ) .and. (.NOT. lOk)
					cValor := alltrim( cValor + ",00" )
				endif
			endif
		next
	endif

return cValor

//-----------------------------------------------------------------------
/*/{Protheus.doc} csCoresGrupo()
Funcao responsavel por exibir a legenda com cores ou desenho para o 
usuario.

@author	Douglas Parreja
@since	05/09/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csCoresGrupo( cGrpMV, cMVServGrupo )
	
	local oCor				:= oBranco		
	local nY				:= 0
	local aMVServGrupo 	:= {}
	local cMVPcdUser 		:= "MV_PCDUSER"
	local lUserPCD 		:= u_csUserAcesso(cMVPcdUser)	
	default cGrpMV 		:= ""
	default cMVServGrupo	:= ""
					 
	aMVServGrupo := StrTokArr2( cMVServGrupo, "," )
	if len( aMVServGrupo ) > 0
		for nY := 1 to len( aMVServGrupo )
			if aMVServGrupo[1] == cGrpMV 
				oCor := iif( lUserPCD, oPcdVerde, oVerde )
				exit
			endif
			if len(aMVServGrupo) > 1				
				if aMVServGrupo[2] == cGrpMV   
					oCor := iif( lUserPCD, oPcdLaranja, oLaranja )
					exit
				endif				
			endif
			if len(aMVServGrupo) > 2				
				if aMVServGrupo[3] == cGrpMV
					oCor := iif( lUserPCD, oPcdAmarelo, oAmarelo )
					exit
				endif
			endif
			if len(aMVServGrupo) > 3				
				if aMVServGrupo[4] == cGrpMV
					oCor := iif( lUserPCD, oPcdVerdeEsc, oVerdeEsc )
					exit
				endif
			endif
			if len(aMVServGrupo) > 4				
				if aMVServGrupo[5] == cGrpMV
					oCor := iif( lUserPCD, oPcdAmarelo, oAmarelo )
					exit
				endif
			endif
			if len(aMVServGrupo) > 5				
				if aMVServGrupo[6] == cGrpMV
					oCor := iif( lUserPCD, oPcdPink, oPink ) 
					exit
				endif
			endif
			if len(aMVServGrupo) > 6				
				if aMVServGrupo[7] == cGrpMV
					oCor := oVioleta
					exit
				endif
			endif
			if len(aMVServGrupo) > 7				
				if aMVServGrupo[8] == cGrpMV
					oCor := oPreto
					exit
				endif
			endif
			if len(aMVServGrupo) > 8				
				if aMVServGrupo[9] == cGrpMV
					oCor := oAzulCla
					exit
				endif
			endif
			if len(aMVServGrupo) > 9				
				if aMVServGrupo[10] == cGrpMV
					oCor := oCinza
					exit
				endif
			endif																							
		next 					
	endif

return oCor


//-----------------------------------------------------------------------
/*{Protheus.doc} csArrayDados()
Funcao responsavel por preparar o Array contendo 

@author	Douglas Parreja
@since	05/09/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csArrayDados()

	local aDados := {}
	
	if csValidTabela()		
		aAdd( aDados, {"pedSite"			,alltrim(ADE->(ADE_XPSITE))							})		
		aAdd( aDados, {"codigoProdutoGAR"	,alltrim(ADE->(ADE_KCDPRO))							})		
    	aAdd( aDados, {"grupo"				,alltrim(ADE->(ADE_KGRTAB))							})
       	aAdd( aDados, {"ac"					,alltrim(ADE->(ADE_KAC)) 							})
       	aAdd( aDados, {"ar"					,alltrim(ADE->(ADE_KAR)) 							})
       	aAdd( aDados, {"quantidade"			,1	 												})                     
       	aAdd( aDados, {"codigoOrigem"		,9  												})
       	aAdd( aDados, {"renovacao"			,iif( ADE->ADE_KRENOV == "1", "true", "false"	)	}) //true ou false		
       	aAdd( aDados, {"protocolo"			,alltrim(ADE->(ADE_CODIGO)) 						})
       	aAdd( aDados, {"codigoAnalista"		,iif( alltrim(SU7->(U7_COD)) == alltrim(ADE->(ADE_OPERAD)), alltrim(SU7->(U7_COD)), alltrim(ADE->(ADE_OPERAD)))  })
       	aAdd( aDados, {"nomeAnalista"		,alltrim(SU7->(U7_NOME)) 							})
     	aAdd( aDados, {"email"				,alltrim(ADE->(ADE_KEMAIL)) 	 					}) //legado: "integracaosac@certisign.com.br"
     	aAdd( aDados, {"faturamento"		,iif( alltrim(ADE->(ADE_KTIPO)) == "F","faturamentoPF", "faturamentoPJ" )	})       
		if( alltrim(ADE->(ADE_KTIPO)) == "F" )
			aAdd( aDados, {"tipo"			,alltrim(ADE->(ADE_KTIPO))							})
	      	aAdd( aDados, {"nome"			,alltrim(ADE->(ADE_KNOME))							})
	    	aAdd( aDados, {"cpf"			,alltrim(ADE->(ADE_KCGC))							})
	       	aAdd( aDados, {"rg"				,alltrim(ADE->(ADE_KRG))							})
          	aAdd( aDados, {"orgaoExpedidor"	,alltrim(ADE->(ADE_KORGEX))							})
          	aAdd( aDados, {"dataNascimento"	,alltrim(ADE->(ADE_KDTNAS))							})
          	aAdd( aDados, {"sexo"			,alltrim(ADE->(ADE_KSEXO))							})
          	if "-" $ FisGetEnd(alltrim(ADE->(ADE_KCEL)),alltrim(ADE->(ADE_KCEL)))[3]
				aAdd( aDados, {"telefoneCelular"	,StrTran(alltrim(ADE->(ADE_KCEL)),"-","") 	})
			else	
				aAdd( aDados, {"telefoneCelular"	,alltrim(ADE->(ADE_KCEL))					})
			endif
			if "-" $ FisGetEnd(alltrim(ADE->(ADE_KTEL)),alltrim(ADE->(ADE_KTEL)))[3]
				aAdd( aDados, {"telefoneContato"	,StrTran(alltrim(ADE->(ADE_KTEL)),"-","")	})
			else	
				aAdd( aDados, {"telefoneContato"	,alltrim(ADE->(ADE_KTEL))					})
			endif
		else
			aAdd( aDados, {"tipo"			,alltrim(ADE->(ADE_KTIPO))							})
			aAdd( aDados, {"razaoSocial"		,alltrim(ADE->(ADE_KNOME))						})
         	aAdd( aDados, {"cnpj"				,alltrim(ADE->(ADE_KCGC))						})
			aAdd( aDados, {"inscricaoEstadual"	,iif( alltrim(ADE->(ADE_KINSCE)) $ "ISE|ISEN|ISENT|ISENTO|ISENTA", "", alltrim(ADE->(ADE_KINSCE))) })
			aAdd( aDados, {"inscricaoMunicipal"	,iif( alltrim(ADE->(ADE_KINSCM)) $ "ISE|ISEN|ISENT|ISENTO|ISENTA", "", alltrim(ADE->(ADE_KINSCM))) })
         	
         	if "-" $ FisGetEnd(alltrim(ADE->(ADE_KTELCT)),alltrim(ADE->(ADE_KTELCT)))[3]
         		aAdd( aDados, {"telefoneContato",StrTran(alltrim(ADE->(ADE_KTELCT)),"-","") 	})
         	else
         		aAdd( aDados, {"telefoneContato"	,alltrim(ADE->(ADE_KTELCT))					}) 
         	endif
			aAdd( aDados, {"nomeContato"		,alltrim(ADE->(ADE_KNOMCT)) 					})	 				        		
		endif
		aAdd( aDados, {"email"					,alltrim(ADE->(ADE_KEMAIL)) 					})			
		aAdd( aDados, {"cep"					,alltrim(ADE->(ADE_KCEP))						})
		aAdd( aDados, {"logradouro"				,alltrim(FisGetEnd(ADE->(ADE_KEND),"ADE")[1]) 	})
		aAdd( aDados, {"bairro"					,alltrim(ADE->(ADE_KBAIRR))						})		
		if "/" $ FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[3]
			aAdd( aDados, {"numero"				,iif(!empty(ADE->(ADE_KEND)), alltrim(iif(FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[3]<>"",FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[3],"SN")), alltrim(ADE->(ADE_KEND))) })
		else 					
 				aAdd( aDados, {"numero"			,iif(!empty(ADE->(ADE_KEND)), alltrim(iif(FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[2]<>0, Str(FisGetEnd(ADE->(ADE_KEND),ADE->(ADE_KEND))[2]), "SN")), alltrim(ADE->(ADE_KEND))) }	)
		endIf
		aAdd( aDados, {"complemento"			,alltrim(ADE->(ADE_KCOMPL))						})
		aAdd( aDados, {"estado"					,alltrim(ADE->(ADE_KUF)) 						})
		aAdd( aDados, {"cidade"					,alltrim(ADE->(ADE_KCIDAD))						})
		aAdd( aDados, {"fone"					,alltrim(ADE->(ADE_KTEL))						})
       	aAdd( aDados, {"formaPagamento"			,iif( alltrim(ADE->(ADE_TIPMOV))=="1", "BOLETO", iif( alltrim(ADE->(ADE_TIPMOV))=="2", "CARTAO", ""))		})
		aAdd( aDados, {"enviaEmail"				,'true'											})
		aAdd( aDados, {"parcelas"				,'1'											})
		aAdd( aDados, {"motivoCompra"			,alltrim(ADE->ADE_KMOTCP)						})
		aAdd( aDados, {"contatoEmail"			,alltrim(ADE->ADE_TO)							})
		aAdd( aDados, {"contatoTel"				,alltrim(ADE->ADE_DDDRET) + alltrim(ADE->ADE_TELRET) })
		
		dbSelectArea('SU5')
		dbSetOrder(1)
		IF dbSeek( xFilial('SU5') + alltrim(ADE->ADE_CODCON) )
			aAdd( aDados, {"contatoSU5" , Alltrim( SU5->U5_CONTAT )	} )
			aAdd( aDados, {"cpfSU5" 	, Alltrim( SU5->U5_CPF )	} )
		EndIF
	endif

return	( aDados )

User Function csADE03G()

Return cRetorno

//Renato Ruy - 15/05/2018
//Funcao para localizar o produto para o rest
Static Function xlocaliza(cFiltro)

Local lRet 		:= .T.
Local nColDesc	:= aScan(oLista:aHeader, {|x| "Descr" $ AllTrim(x[1])})
Local nColGrup	:= aScan(oLista:aHeader, {|x| "Grupo" $ AllTrim(x[1])})
Local nAtual	:= oLista:oBrowse:nAt+1
Local nColuna 	:= 0
Local nNum		:= 0

//Seleciona coluna em que efetuara pesquisa
nColuna := Iif(oCombo1:nAt==1,nColDesc, nColGrup)

For nNum := nAtual to Len(oLista:aCols)
	
	//Verifica se a linha atual contem o valor
	If AllTrim(cFiltro) $ UPPER(oLista:aCols[nNum,nColuna])
		//Altera a linha atual
		oLista:oBrowse:nAt := nNum
		lRet := .F.
		Exit
	Endif
Next

If lRet
	MsgInfo("Não foi possível localizar novos resultados!")
Endif

oLista:oBrowse:refresh()	

Return

Static Function csShowLink( cData, cProtocolo, cPedido, cLink, cAltPgto )
	Local cPath := GetTempPath()
	Local cFile	 := cPath + "Venda_Checkout_pedido_" + cPedido + ".TXT"
	Local cMsg   := ''	

	Default cAltPgto := ''

	IF File( cFile )
		Ferase( cFile )
	EndIF			              		
	
	If (nHandle := MSFCreate(cFile,0)) <> -1				
		lRet := .T.			
	EndIf		
			
	If	lRet
		cMsg += 'Geração Link - Carrinho Checkout' + CRLF + CRLF
		cMsg += 'Por gentileza, clique no Link abaixo para ser direcionado ao Checkout.' + CRLF + CRLF
		cMsg += 'Protocolo: ' + cProtocolo + ' | Nº pedido: ' + cPedido + ' | Data: ' + cData + CRLF + CRLF
		cMsg += 'Link Checkout: ' + cLink + CRLF + CRLF
		IF .NOT. Empty(cAltPgto)
			cMsg += 'Alteração de pagamento' + CRLF
			cMsg += 'Link Checkout: ' + cAltPgto
		EndIF

		FWrite( nHandle, cMsg )		
		FClose(nHandle)	
		ShellExecute( "Open", cFile , '', '', 1 )	
		ShellExecute( "Open", iIF( Empty(cAltPgto), cLink, cAltPgto) , '', '', 1 )
	EndIf		
Return

/*/{Protheus.doc} csADE03ValX7
//Gatilho para alterar o valor do Produto sem a necessidade
//de seleciona-lo novamente.
@author yuri.volpe
@since 26/11/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function csADE03ValX7()
	
	Local oRestClient
	Local aHeader 	:= {"tenantId: 01,02"}
	Local cRenov	:= ""
	Local nRet		:= 0
	Private aDados
	
	/*u_csADEKPROD(alltrim( oLista:aCols[oLista:nAt][4] ))
	M->ADE_KPROD 	:= alltrim( oLista:aCols[oLista:nAt][4] )
	M->ADE_KGRTAB	:= alltrim( oLista:aCols[oLista:nAt][5] )
	M->ADE_KCDPRO	:= alltrim( oLista:aCols[oLista:nAt][3] )
	M->ADE_KAR		:= alltrim( oLista:aCols[oLista:nAt][7] )
	M->ADE_KAC		:= alltrim( oLista:aCols[oLista:nAt][8] )*/

	If !Empty(AllTrim(M->ADE_KPROD))
		M->ADE_KVALOR := 0
			
		// 15/05/2018 - Renato Ruy
		// 2018042010002811 ] Campo "Produto" do grupo 42
		// Tratamento para retornar valor para o novo campo virtual
		// Na URI - Informar se e renovacao '&renovacao=true'
		DbSelectArea("ZZW")
		If ZZW->(DbSeek(xFilial("ZZW")+"001"))
			
			//Busca preço de renovação
			If M->ADE_KRENOV == "1"
				cRenov := "&renovacao=true"
			Endif
		
			oRestClient :=FWRest():New(AllTrim(ZZW->ZZW_HTTP)) //Link Base
			oRestClient:setPath("/rest/api/carrinho?codigo="+alltrim( M->ADE_KCDPRO )+"&quantidade=1&grupo="+alltrim( M->ADE_KGRTAB )+"&codigoOrigem=9&ar="+alltrim( M->ADE_KAR )+cRenov) //Pasta das imagens
			oRestClient:cPath := "/rest/api/carrinho?codigo="+alltrim( M->ADE_KCDPRO )+"&quantidade=1&grupo="+alltrim( M->ADE_KGRTAB )+"&codigoOrigem=9&ar="+alltrim( M->ADE_KAR )+cRenov
			Aadd(aHeader, "Authorization: Basic " + Encode64(AllTrim(ZZW->ZZW_USER)+":"+AllTrim(ZZW->ZZW_SENHA)))
			
			//Verifica se conseguiu fazer o get com o JSON
			If oRestClient:Get(aHeader)
			   FWJsonDeserialize(oRestClient:GetResult(),@aDados) //Adiciona retorno para um array
			   nRet := aDados:ValorTotal
			   M->ADE_KVALOR := nRet
			Else
			   Alert("Não foi possível se conectar ao serviço para consultar preço, erro: " +oRestClient:GetLastError())
			   nRet := 0	   
			Endif
		Else
			MsgInfo("Não foi possível localizar a tabela de cadastro Rest!")
			nRet := 0
		Endif
	Else
		nRet := 0
	EndIf
		
return nRet