// **************************************************************************
// ****                                                                  ****
// ****                 Serviços Protheus Webservice REST                ****
// ****                                                                  ****
// **************************************************************************

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'
#include 'tbiconn.ch'

#define nQTD_PARAMETRO 4

STATIC oWsGAR := NIL

//*********************************************************
//*** SERVIÇOS PROTHEUS WEBSERVICE REST PARA CONSULTAR  *** 
//***                                                   ***  
//*********************************************************

WSRESTFUL eventoNoDia DESCRIPTION 'Consultar certificado com algum evento no dia Protheus/GAR'
WSDATA cToken       AS STRING OPTIONAL
WSDATA cLocalizador AS STRING OPTIONAL
WSDATA cDataEvento  AS STRING OPTIONAL
WSDATA CodAr   		AS STRING OPTIONAL

WSMETHOD GET DESCRIPTION 'Consultar certificado com algum evento no dia Protheus/GAR' WSSYNTAX '/eventoNoDia/{token/id/cCodAr}'
END WSRESTFUL

WSMETHOD GET WSRECEIVE cToken, cLocalizador, cDataEvento, CodAr WSSERVICE eventoNoDia
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cData := ''
	Local cDoc := ''
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_890_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: eventoNoDia()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()

	Local lRet := .T.

	Private cWhoAreYou := ''

	DEFAULT cToken := 'x'
	DEFAULT cLocalizador := 'x'
	DEFAULT cDataEvento := 'x'
	DEFAULT CodAr := 'x'


	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif

	lLigaLog := GetMv( cLigaLog, .F. )

	/*
	If lLigaLog
	aParLog[ 1 ] := 'CONSULTAR'
	aParLog[ 2 ] := 'EVENTONODIA [input]'
	aParLog[ 3 ] := VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) + CRLF + cStack
	aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA AENET.'
	aParLog[ 5 ] := U_rnGetNow()
	aParLog[ 6 ] := U_rnGetNow()
	aParLog[ 7 ] := cValToChar( Seconds() - nTimeIni )

	// Antes de processar gerar log da requisição recebida.
	StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	*/

	// Define o tipo de retorno do método
	::SetContentType('application/json')

	lRet := U_validAut( ::aURLParms, @cReturn, @aRet, @cStack, cThread, nQTD_PARAMETRO )

	// Autenticação bem sucedida.
	If lRet
		cDoc  := ::aURLParms[2]
		cData := ::aURLParms[3] // Data recebida no formato AAAAMMDD
		cCodAr:= ::aURLParms[4] // Data recebida no formato AAAAMMDD

		varinfo("::aURLParms", ::aURLParms)

		cReturn := getEvento( cDoc, cData, @aRet, @cStack, @cThread, cCodAr )
		::SetResponse( cReturn )
	Else
		// Autenticação mal sucedida.
		::SetResponse( '{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }' )
	Endif

	/*
	If lLigaLog
	aParLog[ 2 ] := 'EVENTONODIA [output]'
	aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
	aParLog[ 4 ] := LTrim( Str( aRet[ 1 ] ) ) + ' - ' + aRet[ 2 ] + ' - ' + Iif(Len(aRet)>2,aRet[3],'') + ' - ' + cReturn 
	aParLog[ 6 ] := U_rnGetNow()
	aParLog[ 7 ] := cValToChar( Seconds() - nTimeIni )

	// Após processar gerar log da requisição entregue.
	StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	*/

	DelClassIntf()
Return(.T.)

Static Function getEvento( cDoc, cData, aRet, cStack, cThread, cCodAr )
	Local cMV_893_01 := 'MV_893_01'
	Local cReturn    := ''
	Local jSon       := ''
	Local nOPC       := 0

	If .NOT. GetMv( cMV_893_01, .T. )
		CriarSX6( cMV_893_01, 'N', 'CONSULTAR DIRETO NO 1=GAR-REST OU POR MEIO DO PROTHEUS COMO CONTINGÊNCIA.','1' )
	Endif

	nOPC := GetMv( cMV_893_01, .F. )

	cStack += 'GETEVENTO() - OPCAO (MV_893_01) = ' + LTrim( Str( nOPC ) ) + CRLF

	If nOPC == 1
		jSon := getEvent1( cDoc, cData, @aRet, @cStack, @cThread, cCodAr )
	Elseif nOPC == 2
		jSon := getEvent2( cDoc, cData, @aRet, @cStack, @cThread, cCodAr )
	Else
		U_arErro( 209, @aRet, @cReturn )
		jSon := '[{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }]'
	Endif 
Return( jSon )

Static Function getEvent1( cDoc, cData, aRet, cStack, cThread, cCodAr )
	Local aDadosZ5 := {}
	Local aHeadStr := {}
	Local aStatus := {}
	Local aTrilha := {}
	Local cDtFormat := ''
	Local cEndpoint := ''
	Local cGetResult := ''
	Local cMV_892_06 := 'MV_892_06'
	Local cMV_892_07 := 'MV_892_07'
	Local cParam := ''
	Local cPedidoGAR := ''
	Local cReturn := ''
	Local cStatus := ''
	Local cURL := ''
	Local i := 0
	Local jSon := ''
	Local lDeserialize := .T.
	Local lGet := .T.
	Local oResp 
	Local oRest 
	Local oResult
	Local p := 0 
	local nTempo  := Seconds()
	local nTempoR := 0

	Private aStatusPed := {}
	Private oObj

	cStack += 'GETEVENT1()' + CRLF

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

	cParam := '/status/cnpj/' + cDoc + '/' + cDtFormat

	AAdd( aHeadStr, "Content-Type: application/json" )
	AAdd( aHeadStr, "Accept: application/json" )

	conout(  "***********************"  )
	conout(  cURL +cEndpoint + cParam  )
	oRest := FWRest():New( cURL )
	oRest:setPath( cEndpoint + cParam )
	conout(  "*********************** antes do get"  )
	lGet := oRest:Get( aHeadStr )
	conout(  oRest:GetResult() )
	conout(  "***********************d depois do get"  )
	If lGet
		cGetResult := oRest:GetResult()
		If cGetResult <> '[ ]' .OR. cGetResult <> '[]'
			conout(  "*********************** antes do FwJsonDeserialize"  )
			lDeserialize := FwJsonDeserialize( cGetResult, @oResult )
			conout(  "*********************** depoois do FwJsonDeserialize"  )
		Endif
	Endif

	varinfo("lDeserialize", lDeserialize)
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

				For i := 1 To Len( oObj )
					nTempoR := Seconds()
					AAdd( oResp, jSonObject():New() )

					cDataEvent := Iif(Type('oObj['+Str(i)+']:dataEvento')=='U','',cValToChar(oObj[i]:dataEvento))
					cHoraEvent := SubStr( cDataEvent, 12, 5 )
					cDataEvent := StrTran( SubStr( cDataEvent, 1, 10 ), '-', '' )

					cPedidoGAR := Iif(Type('oObj['+Str(i)+']:pedido'      ) == 'U','',cValToChar(oObj[i]:pedido      ))
					cStatus    := Iif(Type('oObj['+Str(i)+']:statusPedido') == 'U','',cValToChar(oObj[i]:statusPedido)) //Aguardando Pagamento; Aguardando Validação; Aguardando Verificação; Aprovado; Rejeitado; Aguardando Autorização; Bloqueado; Excluído

					//conout("**********laco repeticao pedido " + cPedidoGAR)
					// Tentar localizar o status do pedido e sua descrição.
					/*
					nTempoS := Seconds()
					p := AScan( aStatusPed, {|e| e[ 1 ] == cStatus } )
					conout("** Tempo aScan .......................: "+cValToChar( seconds() - nTempoS ) )
					// Se achou, atribuir.
					If p > 0
					aStatus := { aStatusPed[ p, 1 ], aStatusPed[ p, 2 ] }
					Else
					// Se não achou, montar o vetor para futuras pesquisas e atribuir.
					p := getStatusGAR( cStatus )
					aStatus := { aStatusPed[ p, 1 ], aStatusPed[ p, 2 ] }
					Endif
					*/

					oResp[i]['numeroPedidoGAR']    := cPedidoGAR
					oResp[i]['codigoProduto']      := ''
					oResp[i]['evento']             := ''
					oResp[i]['descricaoEvento']    := ''
					oResp[i]['emissaoPedido']      := ''
					oResp[i]['dataValidacao']      := ''
					oResp[i]['dataVerificacao']    := ''
					oResp[i]['dataEmissao']        := ''
					oResp[i]['ultimoEventoTrilha'] := ''
					//oResp[i]['status']             := aStatus[ 1 ] + ' ' + aStatus[ 2 ]
					oResp[i]['status']             := cStatus //aStatus[ 1 ] + ' ' + aStatus[ 2 ]
					oResp[i]['dataEvento']         := cDataEvent
					oResp[i]['horaEvento']         := cHoraEvent
					oResp[i]['contingencia']       := 'NAO'

					If !Empty( cPedidoGAR ) 
						aDadosZ5 := seekSZ5( cPedidoGAR )

						oResp[i]['codigoProduto']      := rtrim(aDadosZ5[ 1 ]) 
						oResp[i]['evento']             := aDadosZ5[ 2 ]
						oResp[i]['descricaoEvento']    := rtrim(aDadosZ5[ 3 ]) 
						oResp[i]['emissaoPedido']      := aDadosZ5[ 4 ]
						oResp[i]['dataValidacao']      := aDadosZ5[ 5 ]
						oResp[i]['dataVerificacao']    := aDadosZ5[ 6 ]
						oResp[i]['dataEmissao']        := aDadosZ5[ 7 ]
					Endif

					//toConGAR( 'trilhasDeAuditoria', cPedidoGAR, @aTrilha )
					//oResp[i]['ultimoEventoTrilha'] := aTrilha[ 1 ] + '-' + Upper( U_RnNoAcento( aTrilha[ 2 ] ) )
					oResp[i]['ultimoEventoTrilha'] := ""

					aDadosZ5 := {}
					aStatus := {}
					aTrilha := {}
					conout("** Tempo por registro processado......: "+cValToChar( (seconds() - nTempoR) ) )
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
		U_arErro( 213, @aRet, @cReturn )
		jSon := '[{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }]'
	Endif

	conout("** Tempo total de getEvent1...........: "+cValToChar( ( seconds() - nTempo ) ) )
	//conout("** Quantidade de registros ...........: "+cValToChar( Len( oObj ) ) )
Return( jSon )

Static Function getEvent2( cDoc, cData, aRet, cStack, cThread, cCodAr )
	Local aDados  := {}
	Local cReturn := ''
	Local cSQL    := ''
	Local cTRB    := ''
	Local dDate   := Ctod( SubStr( cData, 1, 2 ) + '/' + SubStr( cData, 3, 2 ) + '/' + SubStr( cData, 5, 4 ) ) 
	Local i       := 0
	Local jSon    := ''
	Local oResp
	local nTempo := seconds()
	local nTempoR := 0
	local nTempoQ := 0
	local aResp := {}

	cStack += 'GETEVENTO2()' + CRLF
	if !empty(cCodAr) .and. !empty(cData)

		if !u_vldCodAR( cDoc, cCodAr )
			U_arErro( 215, @aRet, @cReturn )

			aAdd( aResp, jSonObject():New() )
			aResp[1]["codigo"]   := cValToChar( aRet[ 1 ] )
			aResp[1]["mensagem"] := aRet[ 2 ]
			return FWJsonSerialize( aResp )
		endif	

		cSQL += "SELECT "
		cSQL += "       Z5_TIPO, "
		cSQL += "       Z5_CODAR, "
		cSQL += "       Z5_TIPODES, "
		cSQL += "       Z5_PEDGAR, "
		cSQL += "       Z5_PRODGAR, "
		cSQL += "       Z5_EMISSAO, "
		cSQL += "       Z5_DATVAL, "
		cSQL += "       Z5_DATVER, "
		cSQL += "       Z5_DATEMIS, "
		cSQL += "       Z5_STATUS, "
		cSQL += "       Z5_HORVAL "
		cSQL += "FROM   " + RetSqlName("SZ5") + " SZ5 "
		cSQL += "WHERE  "
		cSQL += "			SZ5.Z5_FILIAL   = " + ValToSql( xFilial( "SZ5" ) ) + " "
		cSQL += "       AND SZ5.D_E_L_E_T_  = ' ' "
		cSQL += " 		AND SZ5.Z5_CODAR    = '" + cCodAr + "' "
		cSQL += "       AND ( 	   SZ5.Z5_DATVAL  = '"  + cData + "' "
		cSQL += "       		OR SZ5.Z5_DATEMIS = '"  + cData + "' "
		cSQL += "       		OR SZ5.Z5_DATVER  = '"  + cData + "' )"

		cSQL := ChangeQuery( cSQL )
		cTRB := GetNextAlias()
		nTempoQ := seconds()
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
		//varinfo("cSQL",cSQL )
		conout("** Thread["+cThread+"] - Tempo Query.........................................: "+cValToChar( ( seconds() - nTempoQ ) ) + " - parcial: "+cValToChar( ( seconds() - nTempo ) ) )

		If (cTRB)->( BOF() ) .AND. (cTRB)->( EOF() )
			U_arErro( 207, @aRet, @cReturn )
			oResp := jSonObject():New()
			oResp["codigo"]  := LTrim( Str( aRet[ 1 ] ) )
			oResp["mensagem"] := aRet[ 2 ]
			return FWJsonSerialize( oResp )
		Else
			nTempoQ := seconds()
			oResp := jSonObject():New()
			oResp := {}
			While !(cTRB)->( EOF() )
				if RTrim((cTRB)->Z5_CODAR) == cCodAr
					toConGAR( 'trilhasDeAuditoria', (cTRB)->Z5_PEDGAR, @aDados )
					//nTempoR := seconds()

					i++
					AAdd( oResp, jSonObject():New() )

					oResp[i]['codigoAR']           := RTrim((cTRB)->Z5_CODAR)
					oResp[i]['numeroPedidoGAR']    := RTrim((cTRB)->Z5_PEDGAR)
					oResp[i]['codigoProduto']      := RTrim((cTRB)->Z5_PRODGAR)
					oResp[i]['evento']             := RTrim((cTRB)->Z5_TIPO)
					oResp[i]['descricaoEvento']    := RTrim((cTRB)->Z5_TIPODES)
					oResp[i]['emissaoPedido']      := RTrim((cTRB)->Z5_EMISSAO)
					oResp[i]['dataValidacao']      := RTrim((cTRB)->Z5_DATVAL)
					oResp[i]['dataVerificacao']    := RTrim((cTRB)->Z5_DATVER)
					oResp[i]['dataEmissao']        := RTrim((cTRB)->Z5_DATEMIS)
					//oResp[i]['ultimoEventoTrilha'] := "" 
					oResp[i]['status']             := RTrim(aDados[2])
					oResp[i]['dataEvento']         := RTrim((cTRB)->Z5_EMISSAO)
					oResp[i]['horaEvento']         := RTrim((cTRB)->Z5_HORVAL)
					oResp[i]['contingencia']       := 'SIM'
					//aDados := {}

					//conout("** Tempo por registro["+cValtochar(i)+"]: "+cValToChar( ( seconds() - nTempoR ) ) )
				endif
				(cTRB)->( dbSkip() )
			End
			conout("** Thread["+cThread+"] - Total de registros processados......................: "+cValToChar( i ) )
			conout("** Thread["+cThread+"] - Tempo montagem objejto JSON.........................: "+cValToChar( ( seconds() - nTempoQ ) ) + " - parcial: "+cValToChar( ( seconds() - nTempo ) ) )
			nTempoR := seconds()
			//varinfo("oResp", oResp)
			jSon := FWJsonSerialize( oResp, .F., .F., .T.)
			conout("** Thread["+cThread+"] - Tempo FWJsonSerialize...............................: "+cValToChar( ( seconds() - nTempoR ) ) + " - parcial: "+cValToChar( ( seconds() - nTempo ) ) )
		Endif
		(cTRB)->( dbCloseArea() )
	endif

	If empty(jSon) 
		U_arErro( 213, @aRet, @cReturn )
		jSon := '[{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }]'
	Endif
	conout("** Thread["+cThread+"] - Tempo total de getEvent2............................: "+cValToChar( ( seconds() - nTempo ) ) )
Return( jSon )

Static Function toConGAR( cService, cId, aDados )
	Local i := 0
	Local oDados
	//local nTempo := Seconds()

	default cService := ""
	default cId 	 := ""
	default aDados   := {}

	aDados := {}
	aDados := Array( 2 )

	If oWsGAR == NIL
		oWsGAR := WSIntegracaoGARERPImplService():New()
	Endif

	If Upper( cService ) == 'TRILHASDEAUDITORIA'
		oWsGAR:listarTrilhasDeAuditoriaParaIdPedido( 'erp', 'password123', Val( cId ) )
		oDados := oWsGAR:oWsAuditoriaInfo

		If ( oDados == NIL .AND. oDados[1]:nCpfUsuario == NIL )
			aDados[ 1 ] := 'XXX'
			aDados[ 2 ] := 'TRILHA NAO LOCALIZADA'
		Else
			// Pegar o último status da trilha de auditoria.
			i := Len( oDados )
			aDados[ 1 ] := cValToChar( oDados[i]:cAcao ) 
			aDados[ 2 ] := cValToChar( oDados[i]:cDescricaoAcao )
		Endif
	Endif
	//conout("** Tempo toConGAR ................: "+cValToChar( seconds() - nTempo ) )
Return

Static Function seekSZ5( cPedidoGAR )
	Local aDADOS := {}
	Local cSQL := ''
	Local cTRB := 'SEEKSZ5'
	Local i := 0
	Local nFCount := 0
	local nTempoR := Seconds()

	cSQL += "SELECT Z5_PRODGAR, "
	cSQL += "       Z5_TIPO, "
	cSQL += "       Z5_TIPODES, "
	cSQL += "       Z5_EMISSAO, "
	cSQL += "       Z5_DATVAL, "
	cSQL += "       Z5_DATVER, "
	cSQL += "       Z5_DATEMIS "
	cSQL += "FROM   " + RetSqlName("SZ5") + " SZ5 "
	cSQL += "WHERE  Z5_FILIAL = ' ' "
	cSQL += "       AND Z5_PEDGAR = " + ValToSql( cPedidoGAR ) + " "
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY R_E_C_N_O_ "

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )

	nFCount := (cTRB)->( FCount() )
	aDADOS := Array( nFCount )
	aFill( aDADOS, '' )

	While (cTRB)->( .NOT. EOF() )
		For i := 1 To nFCount
			aDADOS[ i ] := (cTRB)->( FieldGet( i ) )
		Next i
		(cTRB)->( dbSkip() )
	End

	(cTRB)->( dbCloseArea() )
	conout("** Tempo por registro query consultada: "+cValToChar( seconds() - nTempoR ) )
Return( aDADOS )

Static Function getStatusGAR( cStatus )
	Local aStatusGAR := {}
	Local cFile := 'statusgar.ini'
	Local cLine := ''
	Local nHdl := 0
	Local nRet := 0
	Local p := 0
	local nTempo := seconds()

	If File( cFile )
		FT_FUSE( cFile )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cLine := FT_FREADLN()
			p := At( '#', cLine )
			AAdd( aStatusPed, { SubStr( cLine, 1, p-1 ), Upper( U_RnNoAcento( SubStr( cLine, p+1 ) ) )} )
			If SubStr( cLine, 1, p-1 ) == cStatus
				nRet := Len( aStatusPed )
			Endif
			FT_FSKIP()
		End
		FT_FUSE()

		If nRet == 0
			AAdd( aStatusPed, { 'XXX', 'STATUS NAO LOCALIZADO' } )
			nRet := Len( aStatusPed )
		Endif
	Else
		AAdd( aStatusGAR, { 'ADB', 'DADOS BIOMETRICOS AUSENTES' } )
		AAdd( aStatusGAR, { 'AFC', 'ANALISE DE SEGURANCA CONCLUIDA - FRAUDE' } )
		AAdd( aStatusGAR, { 'AFI', 'ANALISE DE SEGURANCA INICIADA - FRAUDE' } )
		AAdd( aStatusGAR, { 'AFP', 'ANALISE DE SEGURANCA PARCIAL - FRAUDE' } )
		AAdd( aStatusGAR, { 'ATV', 'ATIVACAO' } )
		AAdd( aStatusGAR, { 'AUT', 'REGISTRO DE AUTORIZACAO' } )
		AAdd( aStatusGAR, { 'BLQ', 'BLOQUEIO DE PEDIDO - FRAUDE' } )
		AAdd( aStatusGAR, { 'CEA', 'CLIQUE BOTAO ANALISE' } )
		AAdd( aStatusGAR, { 'CIR', 'CONSULTA ITI REALIZADA' } )
		AAdd( aStatusGAR, { 'CSA', 'CONSULTA OAB' } )
		AAdd( aStatusGAR, { 'DBL', 'DESBLOQUEAR' } )
		AAdd( aStatusGAR, { 'DBQ', 'DESBLOQUEIO DE PEDIDO - FRAUDE' } )
		AAdd( aStatusGAR, { 'DEL', 'DELETE' } )
		AAdd( aStatusGAR, { 'DTV', 'DESATIVACAO' } )
		AAdd( aStatusGAR, { 'ECB', 'CERTIBIO INDISPONIVEL' } )
		AAdd( aStatusGAR, { 'EMI', 'EMISSAO' } )
		AAdd( aStatusGAR, { 'ERP', 'EDITAR REPRESENTANTES' } )
		AAdd( aStatusGAR, { 'EXT', 'EXIBIR TERMO' } )
		AAdd( aStatusGAR, { 'IAT', 'INICIAR ATENDIMENTO' } )
		AAdd( aStatusGAR, { 'INS', 'INSCRICAO' } )
		AAdd( aStatusGAR, { 'IPV', 'LIBERAR VALIDACAO' } )
		AAdd( aStatusGAR, { 'LOG', 'ACESSAR' } )
		AAdd( aStatusGAR, { 'OBS', 'OBSERVACAO' } )
		AAdd( aStatusGAR, { 'PAT', 'INTERROMPER ATENDIMENTO' } )
		AAdd( aStatusGAR, { 'RCI', 'REGISTRAR COMO INTEGRADO' } )
		AAdd( aStatusGAR, { 'REM', 'APROVAR' } )
		AAdd( aStatusGAR, { 'REP', 'ENVIO PAGAMENTO' } )
		AAdd( aStatusGAR, { 'RJT', 'REJEITAR PEDIDO' } )
		AAdd( aStatusGAR, { 'RPG', 'REGISTRO PAGAMENTO' } )
		AAdd( aStatusGAR, { 'RRG', 'VALIDAR' } )
		AAdd( aStatusGAR, { 'RRN', 'PEDIDO DE RENOVACAO' } )
		AAdd( aStatusGAR, { 'RRV', 'REVOGACAO' } )
		AAdd( aStatusGAR, { 'RVD', 'REVALIDAR PEDIDO' } )
		AAdd( aStatusGAR, { 'TRS', 'ALTERAR SENHA' } )
		AAdd( aStatusGAR, { 'UPD', 'ALTERACAO CADASTRO' } )
		AAdd( aStatusGAR, { 'WBL', 'BLOQUEADO WORKFLOW' } )
		AAdd( aStatusGAR, { 'WLA', 'ACESSO A VERIFICACAO WORKFLOW' } )
		AAdd( aStatusGAR, { 'WLV', 'ACESSO A VALIDACAO WORKFLOW' } )

		nHdl := FCreate( cFile )
		For p := 1 To Len( aStatusGAR )
			If cStatus == aStatusGAR[ p, 1 ]
				nRet := p
			Endif
			AAdd( aStatusPed, { aStatusGAR[ p, 1 ], aStatusGAR[ p, 2 ] } )
			FWrite( nHdl, aStatusGAR[ p, 1 ] + '#' + aStatusGAR[ p, 2 ] + CRLF )
		Next p
		FClose( nHdl )
		If nRet == 0 
			AAdd( aStatusPed, { 'XXX', 'STATUS NAO LOCALIZADO' } )
		Endif
	Endif
	conout("** Tempo getStatusGAR.................: "+cValToChar( seconds() - nTempo ) )
Return( nRet )

//***************************************************************************************
//***                                                                                 ***
//*** AS ROTINAS ABAIXO SÃO PARA EFEUTAR TESTES DAS ROTINAS AUXILIARES DO WEB SERVICE ***
//***                                                                                 ***
//***************************************************************************************
User Function My893a()
	Local aEnv := {}
	Local aPar := {'','',''}
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_890_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: My893a()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()

	Local lRet := .T.

	Private cWhoAreYou := ''

	aEnv := {'01','02'}

	RpcSetType( 3 )
	RpcSetEnv( aEnv[1], aEnv[2] )

	aPar[ 1 ] := enCode64( StaticCall( CSFA880, GETTOKEN, @cStack ) + 'aenet\integracao' )
	aPar[ 2 ] := '57210053000154'	//'56282924000182'
	aPar[ 3 ] := '20190213'	//'20190128' 

	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif

	lLigaLog := GetMv( cLigaLog, .F. )

	If lLigaLog
		aParLog[ 1 ] := 'CONSULTAR'
		aParLog[ 2 ] := 'EVENTONODIA [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', aPar, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA AENET.'
		aParLog[ 5 ] := U_rnGetNow()	
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )

		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif

	U_arConout('Entrei no eventoNoDia. ' + cThread )

	lRet := U_validAut( aPar, @cReturn, @aRet, @cStack, cThread, nQTD_PARAMETRO )

	If lRet
		cReturn := getEvento( aPar[2], aPar[3], @aRet, @cStack, @cThread )
	Endif

	U_arConout('Sai do eventoNoDia. ' + cThread )

	If lRet
		CopytoClipboard( cReturn )
		MsgAlert( cReturn, 'TOTVS' )
	Else
		cReturn := '{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }'
		CopytoClipboard( cReturn )
		MsgAlert( cReturn, 'TOTVS' )
	Endif

	If lLigaLog
		aParLog[ 2 ] := 'EVENTONODIA [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := LTrim( Str( aRet[ 1 ] ) ) + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )

		// Após processar gerar log da requisição entregue.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif

	DelClassIntf()
Return