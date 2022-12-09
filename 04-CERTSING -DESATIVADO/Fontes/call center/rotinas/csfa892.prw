// **************************************************************************
// ****                                                                  ****
// ****                 Serviços Protheus Webservice REST                ****
// ****                                                                  ****
// **************************************************************************

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'
#include 'tbiconn.ch'

#define nQTD_PARAMETRO 3

//*********************************************************
//*** SERVIÇOS PROTHEUS WEBSERVICE REST PARA CONSULTAR  *** 
//***                                                   ***  
//*********************************************************

WSRESTFUL arAgendamento DESCRIPTION 'Consultar agendamento Protheus/GAR'
WSDATA cToken       AS STRING OPTIONAL
WSDATA cLocalizador AS STRING OPTIONAL
WSDATA cDataAged    AS STRING OPTIONAL

WSMETHOD GET DESCRIPTION 'Consultar agendamento Prothueus/GAR' WSSYNTAX '/arAgendamento/{token/id/date}'
END WSRESTFUL

WSMETHOD GET WSRECEIVE cToken, cLocalizador, cDataAged WSSERVICE arAgendamento
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cData := ''
	Local cDoc := ''
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_890_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: arAgendamento()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()

	Local lRet := .T.

	Private cWhoAreYou := ''

	DEFAULT cToken := 'x'
	DEFAULT cLocalizador := 'x'
	DEFAULT cDataAged := 'x'

	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif

	lLigaLog := GetMv( cLigaLog, .F. )

	If lLigaLog
		aParLog[ 1 ] := 'CONSULTAR'
		aParLog[ 2 ] := 'ARAGENDAMENTO [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA AENET.'
		aParLog[ 5 ] := U_rnGetNow()
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := cValToChar( Seconds() - nTimeIni )

		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif

	// Define o tipo de retorno do método
	::SetContentType('application/json')

	lRet := U_validAut( ::aURLParms, @cReturn, @aRet, @cStack, cThread, nQTD_PARAMETRO )

	// Autenticação bem sucedida.
	If lRet
		cDoc  := ::aURLParms[2]
		cData := ::aURLParms[3] // Data recebida no formato AAAAMMDD

		cReturn := getAgendamento( cDoc, cData, @aRet, @cStack, cThread )

		::SetResponse( cReturn )
	Else
		::SetResponse( '[{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }]' )
	Endif

	If lLigaLog
		aParLog[ 2 ] := 'ARAGENDAMENTO [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := LTrim( Str( aRet[ 1 ] ) ) + ' - ' + aRet[ 2 ] + ' - ' + Iif(Len(aRet)>2,aRet[3],'') + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := cValToChar( Seconds() - nTimeIni )

		// Após processar gerar log da requisição entregue.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif

	DelClassIntf()
Return(.T.)

Static Function getAgendamento( cDoc, cData, aRet, cStack, cThread )
	Local cMV_892_05 := 'MV_892_05'
	Local jSon := ''
	Local nOPC := 0

	If .NOT. GetMv( cMV_892_05, .T. )
		CriarSX6( cMV_892_05, 'N', 'CONSULTAR DIRETO NO 1=GAR-REST OU POR MEIO DO 2=CHECK-OUT + PROTHEUS COMO CONTINGÊNCIA.','1' )
	Endif

	nOPC := GetMv( cMV_892_05, .F. )

	cStack += 'GETAGENDAMENTO() - OPCAO (MV_892_05) = ' + LTrim( Str( nOPC ) ) + CRLF

	If nOPC == 1
		jSon := getAgend1( cDoc, cData, @aRet, @cStack, cThread )
	Elseif nOPC == 2
		jSon := getAgend2( cDoc, cData, @aRet, @cStack, cThread )
	Else
		jSon := '[{"codigo": 209,"mensagem": "OPCAO DE CONSULTA DO PARAMETRO MV_892_05 INDISPONIVEL." }]'
	Endif 

Return( jSon )

Static Function getAgend1( cDoc, cData, aRet, cStack, cThread )
	Local aHeadStr := {}
	Local cDataAgend := ''
	Local cDataReg := ''
	Local cDtFormat := ''
	Local cEndpoint := ''
	Local cGetResult := ''
	Local cMV_892_06 := 'MV_892_06'
	Local cMV_892_07 := 'MV_892_07'
	Local cParam := ''
	Local cReturn := ''
	Local cURL := ''
	Local i := 0
	Local jSon := ''
	Local lDeserialize := .T.
	Local lGet := .T.
	Local oResp 
	Local oRest 
	Local oResult 
	local cCodPosto := ""

	Private oObj

	cStack += 'GETAGEND1()' + CRLF

	// A data deverá ser entregue para o prottheus no formato AAAAMMDD
	// Esta mesma data deverá ser entregue para o GAR no formato AAAA-MM-DD
	cDtFormat := SubStr( cData, 1, 4 ) + '-' + SubStr( cData, 5, 2 ) + '-' + SubStr( cData, 7, 2 )

	// url teste...: http://192.168.15.74:8080
	// url homolog.: http://integracao-ar-homolog.certisign.com.br:8080
	// url producao: http://integracao-ar.certisign.com.br
	If .NOT. GetMv( cMV_892_06, .T. )
		CriarSX6( cMV_892_06, 'C', 'HOST P/ COMUNICACAO COM SERV REST DO GAR. CSFA892.',;
		'http://192.168.15.74:8080' )
	Endif
	cURL := GetMv( cMV_892_06, .F. )

	If .NOT. GetMv( cMV_892_07, .T. )
		CriarSX6( cMV_892_07, 'C', 'ENDPOINT DE COMUNICACAO SERV REST DO GAR. CSFA892.',;
		'/consulta-pedido' )
	Endif
	cEndpoint := GetMv( cMV_892_07, .F. )

	cParam := + '/agendamentos/cnpj/' + cDoc + '/' + cDtFormat //A data deve ser enviada no formato AAAA-MM-DD

	AAdd( aHeadStr, "Content-Type: application/json" )
	AAdd( aHeadStr, "Accept: application/json" )

	oRest := FWRest():New( cURL )
	oRest:setPath( cEndpoint + cParam )
	lGet := oRest:Get( aHeadStr )

	If lGet
		cGetResult := oRest:GetResult()
		If cGetResult <> '[ ]' .OR. cGetResult <> '[]'
			lDeserialize := FwJsonDeserialize( cGetResult, @oResult )
		Endif
	Endif

	If lGet .AND. cGetResult <> '[ ]' .AND. cGetResult <> '[]' .AND. lDeserialize
		If ValType( oResult ) == 'A'
			oObj := AClone( oResult )
		Else
			oObj := {}
			AAdd( oObj, oResult )
		Endif

		// Tem as TAG <title>,<status>,<detail> então não conseguiu localizar os dados.
		If Type('oObj[1]:title') <> 'U' .AND. Type('oObj[1]:status') <> 'U' .AND. Type('oObj[1]:detail') <> 'U'
			jSon := '[{"codigo": 210,"mensagem": "'+cValToChar(oObj[1]:title)+' '+cValToChar(oObj[1]:status)+' '+cValToChar(oObj[1]:detail)+'" }]'
		Else
			// Com o CNPJ informado pesquisar se o primeiro pedido é corresponentes ao CNPJ em questão.
			// Se for prosseguir, do contrário devolver uma mensagem de crítica.
			If .NOT. U_cnpjMatch( cDoc, cValToChar(oObj[1]:pedido), @aRet, @cReturn, cStack )
				jSon := '[{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }]'

			Else
				oResp := jSonObject():New()
				oResp := {}
				varinfo("oObj", oObj)

				For i := 1 To Len( oObj )
					AAdd( oResp, jSonObject():New() )

					cDataAgend := Iif(Type('oObj['+Str(i)+']:dataAgendamento')=='U','',cValToChar(oObj[i]:dataAgendamento))
					cDataAgend := StrTran( SubStr( cDataAgend, 1, 10 ), '-', '' )

					cDataReg := Iif(Type('oObj['+Str(i)+']:dataRegistroAgendamento')=='U','',cValToChar(oObj[i]:dataRegistroAgendamento))
					cDataReg := StrTran( SubStr( cDataReg, 1, 10 ), '-', '' )

					oResp[i]['numeroPedidoGAR'] := Iif(Type('oObj['+Str(i)+']:pedido')=='U','',cValToChar(oObj[i]:pedido))

					cCodPosto := retCodPosto( oResp[i]['numeroPedidoGAR'] )	 

					//#TODO Codigo Posto
					oResp[i]['nomePonto']       := Iif(Type('oObj['+Str(i)+']:nomePosto')=='U','',cValToChar(oObj[i]:nomePosto))
					oResp[i]['endereco']        := ''
					oResp[i]['dataAgendamento'] := u_fDtAENET(cDataAgend)
					oResp[i]['horaAgendamento'] := Iif(Type('oObj['+Str(i)+']:horaAgendamento')=='U','',cValToChar(oObj[i]:horaAgendamento))
					oResp[i]['dataRegistro']    := u_fDtAENET(cDataReg)
					oResp[i]['nomeCliente']     := Iif(Type('oObj['+Str(i)+']:nomeTitular')=='U','',cValToChar(oObj[i]:nomeTitular))
					oResp[i]['codigoProduto']   := Iif(Type('oObj['+Str(i)+']:produto')=='U','',cValToChar(oObj[i]:produto))
					oResp[i]['descriProduto']   := Iif(Type('oObj['+Str(i)+']:descricaoProduto')=='U','',cValToChar(oObj[i]:descricaoProduto))
					oResp[i]['cpfTitular']      := Iif(Type('oObj['+Str(i)+']:cpf')=='U','',cValToChar(oObj[i]:cpf))
					oResp[i]['emailTitular']    := Iif(Type('oObj['+Str(i)+']:email')=='U','',cValToChar(oObj[i]:email))
					oResp[i]['nomeAR']          := Iif(Type('oObj['+Str(i)+']:nomeAR')=='U','',cValToChar(oObj[i]:nomeAR))
					oResp[i]['status']          := Iif(Type('oObj['+Str(i)+']:status')=='U','',Upper(U_RnNoAcento(cValToChar(oObj[i]:status)))) // agendado; cancelado; reagendado; realizado
					oResp[i]['telefone']        := Iif(Type('oObj['+Str(i)+']:telefone')=='U','',cValToChar(oObj[i]:telefone))
					oResp[i]['contingencia']    := "NAO"
					oResp[i]['codigoPosto']     := ""
					oResp[i]['contatoNome']     := ""
					oResp[i]['contatoEmail']    := ""
					oResp[i]['contatoTelefone'] := ""
				Next i
				jSon := FWJsonSerialize( oResp )
			Endif
		Endif
	Else
		If .NOT. lGet
			U_arConout('NAO CONSEGUI FAZER O GET NO GAR DOC[' + cDOC + '] DATA[' + cDtFormat + '] THREAD[' + cThread + ']')
			U_arConout('GETLASTERRO: ' + oRest:GetLastError() )
		Endif
		If cGetResult == '[ ]' .OR. cGetResult == '[]'
			U_arConout('NAO CONSEGUI O GETRESULT NO GAR DOC[' + cDOC + '] DATA[' + cDtFormat + '] THREAD[' + cThread + ']')
			U_arConout('GETLASTERRO: ' + oRest:GetLastError() )
		Endif
		If ValType(lDeserialize) == 'L' .AND. .NOT. lDeserialize
			U_arConout('ERRO NO JSON ENTREGUE PELO GAR DOC[' + cDOC + '] DATA[' + cDtFormat + '] THREAD[' + cThread + ']')
			U_arConout('GETRESULT: ' + cGetResult )
		Endif
	Endif

	If jSon == ''
		U_arErro( 208, @aRet, @cReturn )
		jSon := '[{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }]'
	Endif

Return( jSon )

Static Function getAgend2( cDoc, cData, aRet, cStack, cThread )
	Local aDados := {}
	Local aHeadStr := {}

	Local cEndPoint := ''
	Local cGetResult := ''
	Local cMV_892_01 := 'MV_892_01'
	Local cMV_892_02 := 'MV_892_02'
	Local cMV_892_03 := 'MV_892_03'
	Local cMV_892_04 := 'MV_892_04'
	Local cParam := ''
	Local cPassword := ''
	Local cReturn := ''
	Local cSQL := ''
	Local cTRB := ''
	Local cURL := ''
	Local cUser := ''
	Local cZ3_NMFANT := ''

	Local i := 0
	Local jSon := ''

	Local lDeserialize
	Local lGet

	Local o892Rest
	Local o892Result
	Local oObj
	Local oResp

	cStack += 'GETAGEND2()' + CRLF

	// Homolog.: https://checkout-homolog.certisign.com.br
	// Produção: https://checkout.certisign.com.br
	If .NOT. GetMv( cMV_892_01, .T. )
		CriarSX6( cMV_892_01, 'C', 'HOST P/ COMUNICACAO COM SERV REST DO CHECK-OUT. CSFA892.',;
		'https://checkout.certisign.com.br' )
	Endif
	cURL := GetMv( cMV_892_01, .F. )

	If .NOT. GetMv( cMV_892_02, .T. )
		CriarSX6( cMV_892_02, 'C', 'ENDPOINT DE COMUNICACAO SERV REST CHECK-OUT. CSFA892.',;
		'/rest/api/agendamentos' )
	Endif
	cEndPoint := GetMv( cMV_892_02, .F. )

	// Homolog.: 0cfda315-4a15-4708-bad1-f87deb24b49b
	// Produção: 7516d708-b733-4f5a-aae5-fbb2955c0c45
	If .NOT. GetMv( cMV_892_03, .T. )
		CriarSX6( cMV_892_03, 'C', 'USUARIO DE AUTENTICACAO SERV REST CHECK-OUT. CSFA892.',;
		'7516d708-b733-4f5a-aae5-fbb2955c0c45' )
	Endif
	cUser := GetMv( cMV_892_03, .F. )

	// Homolog.: xcflRpM5AGmG7GukTYA5OQ==
	// Produção: SOwY3RCA9sOSgtM68MxmQQ==
	If .NOT. GetMv( cMV_892_04, .T. )
		CriarSX6( cMV_892_04, 'C', 'PASSWORD DE AUTENTICACAO SERV REST CHECK-OUT. CSFA892.',;
		'SOwY3RCA9sOSgtM68MxmQQ==' )
	Endif
	cPassword := GetMv( cMV_892_04, .F. )	

	cSQL := "SELECT Z3_NMFANT "
	cSQL += "FROM   " + RetSqlName("SZ3") + " SZ3 "
	cSQL += "WHERE  Z3_FILIAL = " + ValToSql( xFilial( "SZ3" ) ) + " "
	cSQL += "       AND Z3_CGC = " + ValToSql( cDoc ) + " "
	cSQL += "       AND Z3_TIPENT = '4' "
	cSQL += "       AND Z3_NMFANT <> ' ' "
	cSQL += "       AND SZ3.D_E_L_E_T_ = ' ' "
	cSQL += "GROUP BY Z3_NMFANT "

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )

	If (cTRB)->( BOF() ) .AND. (cTRB)->( EOF() )
		U_arErro( 207, @aRet, @cReturn )
		jSon := '[{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }]'
	Else
		AAdd( aHeadStr, "Content-Type: application/json" )
		AAdd( aHeadStr, "Accept: application/json" )
		AAdd( aHeadStr, "Authorization: Basic " + EnCode64( cUser + ":" + cPassword ) )

		// Host para consumo REST.
		o892Rest := FWRest():New( cURL )

		While .NOT. (cTRB)->( EOF() )
			cZ3_NMFANT := RTrim( (cTRB)->Z3_NMFANT )

			// dataAgendamento no formato ( ddMMyyyy )
			cParam := '?nomePonto=' + Escape( cZ3_NMFANT ) +'&dataAgendamento=' + cData

			// Path aonde será feito a requisição
			o892Rest:setPath( cEndPoint + cParam )

			// Efetuar o GET para completar a conexão.
			lGet := o892Rest:Get( aHeadStr )

			// Conseguiu fazer o GET?
			If lGet
				// Captura o resultado.
				cGetResult := o892Rest:GetResult()
				// O resultado tem conteúdo?
				If cGetResult <> '[ ]'
					// Deserializar o Json.
					lDeserialize := FwJsonDeserialize( cGetResult, @o892Result )
				Endif
			Endif

			// Conseguiu fazer o GET, o resultado tem conteúdo e foi possível deserializar, então...
			If lGet .AND. cGetResult <> '[ ]' .AND. lDeserialize
				If ValType( o892Result ) == 'A'
					oObj := AClone( o892Result )
				Else
					oObj := {}
					AAdd( oObj, o892Result )
				Endif

				oResp := jSonObject():New()
				oResp := {}

				For i := 1 To Len( oObj )
					If toConnectGAR( 'findDadosPedido', oObj[i]:numeroPedidoGAR )
						aDados := getGAR('findDadosPedido',{'cnomeTitular','cproduto','cprodutoDesc','ncpfTitular','cemailTitular'})
					Else
						aDados := Array(5)
						aFill( aDados, '' )
					Endif

					AAdd( oResp, jSonObject():New() )

					oResp[i]['numeroPedidoGAR'] := oObj[i]:numeroPedidoGAR
					oResp[i]['nomePonto']       := oObj[i]:nomePonto
					oResp[i]['endereco']        := oObj[i]:endereco
					oResp[i]['dataAgendamento'] := u_fDtAENET(oObj[i]:dataAgendamento)
					oResp[i]['horaAgendamento'] := oObj[i]:horaAgendamento
					oResp[i]['dataRegistro']    := u_fDtAENET(oObj[i]:dataRegistro)
					oResp[i]['nomeCliente']     := aDados[1]
					oResp[i]['codigoProduto']   := aDados[2]
					oResp[i]['descriProduto']   := aDados[3]
					oResp[i]['cpfTitular']      := aDados[4]
					oResp[i]['emailTitular']    := aDados[5]
					oResp[i]['nomeAR']          := ''
					oResp[i]['status']          := ''
					oResp[i]['telefone']        := ''
					oResp[i]['contingencia']    := 'SIM'

				Next i
				jSon := FWJsonSerialize( oResp )
			Else
				If .NOT. lGet
					U_arConout('NAO CONSEGUI FAZER O GET NO CHECK-OUT DOC[' + cZ3_NMFANT + '] DATA[' + cData + '] THREAD[' + cThread + ']')
					U_arConout('GETLASTERRO: ' + o892Rest:GetLastError() )
				Endif
				If cGetResult == '[ ]'
					U_arConout('NAO CONSEGUI O GETRESULT CHECK-OUT DOC[' + cZ3_NMFANT + '] DATA[' + cData + '] THREAD[' + cThread + ']')
					U_arConout('GETLASTERRO: ' + o892Rest:GetLastError() )
				Endif
				If ValType(lDeserialize) == 'L' .AND. .NOT. lDeserialize
					U_arConout('ERRO NO JSON ENTREGUE PELO CHECK-OUT DOC[' + cZ3_NMFANT + '] DATA[' + cData + '] THREAD[' + cThread + ']')
					U_arConout('GETRESULT: ' + cGetResult )
				Endif
			Endif

			(cTRB)->( dbSkip() )

			cGetResult := ''
			lDeserialize := NIL
			lGet := NIL
		End
	Endif
	(cTRB)->( dbCloseArea() )

	If jSon == ''
		U_arErro( 208, @aRet, @cReturn )
		jSon := '[{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }]'
	Endif

Return( jSon )

STATIC oDadosGAR := NIL
STATIC oWsGAR := NIL

Static Function toConnectGAR( cService, cId )
	Local lRet := .T. 
	Local oDados

	If oWsGAR == NIL
		oWsGAR := WSIntegracaoGARERPImplService():New()
	Endif

	If Upper( cService ) == 'FINDDADOSPEDIDO'
		oWsGAR:findDadosPedido( 'erp', 'password123', Val( cId ) )
		oDados := oWsGAR:oWsDadosPedido
		If ( oDados == NIL .OR. oDados:nPedido == NIL )
			lRet := .F.
		Else 
			saveDataGAR( oDados )
		Endif
	Endif
Return( lRet )

Static Function getGAR( cService, aTag )
	Local aMyObj := {}
	Local oMyObj := NIL
	Local i := 0
	Local uMacro := NIL

	aMyObj := Array( Len( aTag ) )

	If Upper( cService ) == 'FINDDADOSPEDIDO'
		oMyObj := restDataGAR()
		For i := 1 To Len( aTag )
			uMacro := '{|| oMyObj:' + aTag[i] + '}'
			uMacro := Eval(&uMacro)
			aMyObj[i] := cValToChar(uMacro)
		Next i
	Endif
Return( aMyObj )

Static Function saveDataGAR( oDados )
	oDadosGAR := NIL
	oDadosGAR := oDados
Return

Static Function RestDataGAR()
	Local oMyObj
	oMyObj := oDadosGAR
	oDadosGAR := NIL
Return ( oMyObj )

//***************************************************************************************
//***                                                                                 ***
//*** AS ROTINAS ABAIXO SÃO PARA EFEUTAR TESTES DAS ROTINAS AUXILIARES DO WEB SERVICE ***
//***                                                                                 ***
//***************************************************************************************
User Function My892a()
	Local aEnv := {}
	Local aPar := {'','',''}
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_890_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: My892a()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()

	Local lRet := .T.

	Private cWhoAreYou := ''

	aEnv := {'01','02'}

	RpcSetType( 3 )
	RpcSetEnv( aEnv[1], aEnv[2] )

	aPar[ 1 ] := enCode64( StaticCall( CSFA880, GETTOKEN, @cStack ) + 'aenet\integracao' )
	aPar[ 2 ] := '56282924000182'
	aPar[ 3 ] := '20190115'

	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif

	lLigaLog := GetMv( cLigaLog, .F. )

	If lLigaLog
		aParLog[ 1 ] := 'CONSULTAR'
		aParLog[ 2 ] := 'ARAGENDAMENTO [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', aPar, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA AENET.'
		aParLog[ 5 ] := U_rnGetNow()	
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )

		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif

	U_arConout('Entrei no arAgendamento. ' + cThread )

	lRet := U_validAut( aPar, @cReturn, @aRet, @cStack, cThread, nQTD_PARAMETRO )

	If lRet
		cReturn := getAgendamento( aPar[2], aPar[3], @aRet, @cStack, cThread )
	Endif

	U_arConout('Sai do arAgendamento. ' + cThread )

	If lRet
		CopytoClipboard( cReturn )
		MsgAlert( cReturn, 'TOTVS' )
	Else
		cReturn := '{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }'
		CopytoClipboard( cReturn )
		MsgAlert( cReturn, 'TOTVS' )
	Endif

	If lLigaLog
		aParLog[ 2 ] := 'ARAGENDAMENTO [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := LTrim( Str( aRet[ 1 ] ) ) + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )

		// Após processar gerar log da requisição entregue.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif

	DelClassIntf()
Return

static function retCodPosto( cPedGar )
	default cPedGar := ""

	if!empty( cPedGar )
		oWsGAR := WSIntegracaoGARERPImplService():New()
		oWsGAR:findDadosPedido( 'erp', 'password123', Val( cPedGar ) )
		oDados := oWsGAR:oWsDadosPedido
		varinfo("oDados", oDados)
	endif				
return