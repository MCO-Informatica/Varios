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
//*** SERVIÇOS PROTHEUS WEBSERVICE REST PARA AUTENTICAR *** 
//***                                                   ***  
//*********************************************************

WSRESTFUL arConsultar DESCRIPTION 'Consultar dados de pedido Protheus/GAR'
WSDATA cToken       AS STRING OPTIONAL
WSDATA cLocalizador AS STRING OPTIONAL
WSDATA cNumPedido   AS STRING OPTIONAL

WSMETHOD GET DESCRIPTION 'Consulta dados de pedido Protheus/GAR' WSSYNTAX '/arConsultar/{token/id}'
END WSRESTFUL

WSMETHOD GET WSRECEIVE cToken, cLocalizador, cNumPedido WSSERVICE arConsultar
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_890_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: arConsultar()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()

	Local lRet := .T.

	Private cWhoAreYou := ''

	DEFAULT cToken := 'x'
	DEFAULT cLocalizador := 'x'
	DEFAULT cNumPedido := 'x'

	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif

	lLigaLog := GetMv( cLigaLog, .F. )

	If lLigaLog
		aParLog[ 1 ] := 'CONSULTAR'
		aParLog[ 2 ] := 'ARCONSULTAR [input]'
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

	// Validar a autenticação e se o CNPJ pode efetuar a consulta.
	lRet := U_validAut( ::aURLParms, @cReturn, @aRet, @cStack, cThread, nQTD_PARAMETRO )

	If lRet
		// Verificar se o CNPJ informado corresponde ao posto de validação ou verificação.
		//lRet := U_cnpjMatch( ::aURLParms[ 2 ], ::aURLParms[ 3 ], @cReturn, @aRet, @cStack, cThread )
	Endif

	// Autenticação bem sucedida.
	If lRet
		cReturn := getConsulta( ::aURLParms[3], @aRet, @cStack, ::aURLParms[2] )

		::SetResponse( cReturn )
	Else
		// Autenticação mal sucedida.
		::SetResponse( '{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }' )
	Endif

	If lLigaLog
		aParLog[ 2 ] := 'ARCONSULTAR [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := LTrim( Str( aRet[ 1 ] ) ) + ' - ' + aRet[ 2 ] + ' - ' + Iif(Len(aRet)>2,aRet[3],'') + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := cValToChar( Seconds() - nTimeIni )

		// Após processar gerar log da requisição entregue.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif

	DelClassIntf()
Return(.T.)

Static Function getConsulta( cDoc, aRet, cStack, cCNPJ )
	Local aCertif := {}
	Local aERP := {}
	Local aFindDPed := {}
	Local aHead0 := {}
	Local aHead1 := {}
	Local aHead2 := {}
	Local aHead3 := {}
	Local aHead4 := {}
	Local aTrilha := {}
	Local aHead1A := {}

	Local i 		:= 0
	Local j 		:= 0
	Local l 		:= 0
	Local nLenPed	:= 0
	local cReturn := ""
	Local cJson := ''
	LOCAL oResp 

	cStack += 'GETCONSULTA()' + CRLF

	AAdd( aHead0, '"retorno"' )
	AAdd( aHead0, '"msgRetorno"' )
	//--------------------------------------------------------------------------------	
	//findDadosPedido (13).
	AAdd( aHead1, '"idPedido"' )
	AAdd( aHead1, '"nomeProduto"' )
	AAdd( aHead1, '"nomeAR"' )
	AAdd( aHead1, '"nomePosto"' )
	AAdd( aHead1, '"grupo"' )
	AAdd( aHead1, '"dataPedido"' )
	AAdd( aHead1, '"descricaoCertificado"' )
	AAdd( aHead1, '"emissaoAR"' )
	AAdd( aHead1, '"nomeCompleto"' )
	AAdd( aHead1, '"cpf"' )
	AAdd( aHead1, '"email"' )
	AAdd( aHead1, '"cnpj"' )
	AAdd( aHead1, '"statusPed"' )
	AAdd( aHead1, '"estado"' )//ufTitular
	AAdd( aHead1, '"dataNascimento"' )
	AAdd( aHead1, '"numeroRG"' )
	AAdd( aHead1, '"orgaoEmissorRG"' )
	AAdd( aHead1, '"ufRG"' )
	AAdd( aHead1, '"pisPasep"' )
	AAdd( aHead1, '"razaoSocial"' )
	AAdd( aHead1, '"cidadeEmpresa"' )//cidadeCnpj
	AAdd( aHead1, '"estadoEmpresa"' )//ufCnpj
	AAdd( aHead1, '"ceiPJ"' )
	AAdd( aHead1, '"tituloEleitor"' )
	AAdd( aHead1, '"zonaEleitoral"' )
	AAdd( aHead1, '"secao"' )
	AAdd( aHead1, '"validoDe"' )
	AAdd( aHead1, '"validoAte"' )
	AAdd( aHead1, '"serial"' )
	AAdd( aHead1, '"datavalidacao"' ) 
	AAdd( aHead1, '"nomeAgenteValidacao"' )
	AAdd( aHead1, '"codigoAR"' )
	AAdd( aHead1, '"biometria"' )
	AAdd( aHead1, '"online"' )
	AAdd( aHead1, '"descricaoAcao"' )
	//--------------------------------------------------------------------------------
	//REPRESENTANTES		
	AAdd( aHead1A, '"pedido"' )
	AAdd( aHead1A, '"cpf"' )
	AAdd( aHead1A, '"nome"' )
	AAdd( aHead1A, '"datanascimento"' )
	AAdd( aHead1A, '"RG"' )
	AAdd( aHead1A, '"orgaoemissorRg"' )
	AAdd( aHead1A, '"ufRG"' )
	AAdd( aHead1A, '"dataEmissaoRg"' )
	AAdd( aHead1A, '"incapaz"' )
	AAdd( aHead1A, '"codUsuario"' )
	AAdd( aHead1A, '"dataultimaAtualizacao"' )
	AAdd( aHead1A, '"dataInsercao"' )
	//--------------------------------------------------------------------------------		
	//dadosCertificados (17).
	AAdd( aHead2, '"statusCertificado"' )
	AAdd( aHead2, '"cidade"' )//cidadeTitular

	//--------------------------------------------------------------------------------			
	//trilhaDeAuditoria (1).
	AAdd( aHead3, '"descriStatusPedido"' )
	//--------------------------------------------------------------------------------			
	//remuneracaoParceiro ERP (31).
	AAdd( aHead4, '"dataVerificacaoEmissao"' )
	AAdd( aHead4, '"nomeAgenteVerificacaoEmissao"' )
	AAdd( aHead4, '"dataEmissao"' )
	AAdd( aHead4, '"statusPedido"' )
	AAdd( aHead4, '"valorTotalBase"' )
	AAdd( aHead4, '"valorBaseSoftware"' )
	AAdd( aHead4, '"valorBaseHardware"' )
	AAdd( aHead4, '"tipoVoucher"' )
	AAdd( aHead4, '"pedidoAnterior"' )
	AAdd( aHead4, '"dataPedidoAnterior"' )
	AAdd( aHead4, '"valorAbatimento"' )
	AAdd( aHead4, '"valorBrutoSoftware"' )
	AAdd( aHead4, '"valorBrutoHardware"' )
	AAdd( aHead4, '"valorBrutoTotal"' )
	AAdd( aHead4, '"valorComissaoSoftware"' )
	AAdd( aHead4, '"valorComissaoHardware"' )
	AAdd( aHead4, '"valorComissaoTotal"' )
	AAdd( aHead4, '"valorComissaoFederacao"' )
	AAdd( aHead4, '"valorTotalComissaoSomaFederacao"' )
	AAdd( aHead4, '"contagemGeral"' )
	AAdd( aHead4, '"contagemSoftware"' )
	AAdd( aHead4, '"contagemHardware"' )
	AAdd( aHead4, '"codigoProduto"' )
	AAdd( aHead4, '"codigoPosto"' )
	AAdd( aHead4, '"codigoVendedor"' )
	AAdd( aHead4, '"nomeVendedor"' )
	AAdd( aHead4, '"linkCampanha"' )
	AAdd( aHead4, '"valorBruto"' )
	AAdd( aHead4, '"valorFaturamento"' )
	AAdd( aHead4, '"valorTotalComissao"' )
	AAdd( aHead4, '"contagemCampanha"' )
	AAdd( aHead4, '"codigoEntidade"' )
	
	//--------------------------------------------------------------------------------		
	if !getFindPedido( cDoc, @aFindDPed, @cStack, cCNPJ )
		U_arErro( 214, @aRet, @cReturn )
		oResp := {}
		aAdd( oResp, jSonObject():New() )
		oResp[1]["codigo"]  := LTrim( Str( aRet[ 1 ] ) )
		oResp[1]["mensagem"] := aRet[ 2 ]
		return FWJsonSerialize( oResp )

	endif 
	getCertificado( cDoc, @aCertif, @cStack )
	getTrilhaAudit( cDoc, @aTrilha, @cStack )
	getErpProtheus( cDoc, @aERP, @cStack )

	nLenPed := Len( aFindDPed )

	cJson := '{'
	cJson += aHead0[1] + ':"' + aFindDPed[1] +'",'

	If aFindDPed[1] == 'true'
		cJson += aHead0[2] + ':"Dados localizados com sucesso",'
	Else
		cJson += aHead0[2] + ':"Dados nao localizados",'
	Endif

	i := 0
	j := 0

	For i := 2 To Len( aFindDPed ) - 1
		j++
		cJson += aHead1[j] + ':"' + aFindDPed[i] + '",'
	Next i	

	i := 0
	j := 0

	cJson += '"Representantes":['
	For i := 1 To Len( aFindDPed[nLenPed] )
		cJson += '{'
		j := 0
		For l := 1 To Len( aFindDPed[ nLenPed, i ] )
			j++
			cJson += aHead1A[j] + ':"' + aFindDPed[ nLenPed, i, l ] + '",'
		Next l
		cJson := SubStr( cJson, 1, Len( cJson )-1 )
		cJson += "},"
	Next i
	cJson := SubStr( cJson, 1, Len( cJson )-1 )
	cJson += "],"

	i := 0
	j := 0

	For i := 2 To Len( aCertif )
		j++
		cJson += aHead2[j] + ':"' + aCertif[ i ] + '",'
	Next i

	If Len( aTrilha ) > 0 .AND. Len( aTrilha[ 1 ] ) > 0 .AND. aTrilha[ 1, 1 ] == 'true'
		cJson += aHead3[ 1 ] + ':"' + aTrilha[ 1, 2 ] + '",'
	Else
		cJson += aHead3[ 1 ] + ':" ",'
	Endif

	i := 0
	j := 0 

	For i := 2 To Len( aERP )
		j++
		cJson += aHead4[j] + ':"' + aERP[ i, 2 ] + '",'
	Next i

	if aERP[1][2] == "false"
		cJson += '"codigoEntidade" : "",'
	endif

	cJson := SubStr( cJson, 1, Len( cJson )-1 ) + '}'
Return( cJson )

Static Function getFindPedido( cPedido, aFindDPed, cStack, cCNPJ )
	Local oDados
	Local oWsGAR
	Local nL	:= 0
	Local nLen	:= 0

	cStack += 'GETFINDPEDIDO()' + CRLF

	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:findDadosPedido( 'erp', 'password123', Val( cPedido ) )
	oDados := oWsGAR:oWsDadosPedido
	varinfo("oDados", oDados)
	aFindDPed := Array( 37 )
	aFill( aFindDPed, '' )
	nLen := Len( aFindDPed )

	If oDados == NIL .OR. oDados:nPedido == NIL
		aFindDPed[ 1 ] := 'false'
		Return .f.
	Endif

	//RETIRADA POR CONTA DA ULTIMA CALL COM AENTE - BRUNO - ALINE M. - GIOVANNI - PATRICK - FLAVIO
	//if !u_vldCodAR( cCNPJ, oDados:cArId )
		//if oDados:cStatus != "0" .and. oDados:cStatus != "1" 
			//aFindDPed[ 1 ] := 'false'
			//return .f.
		//endif	
	//endif
	
	aFindDPed[  1 ] := 'true'
	aFindDPed[  2 ] := cValToChar( oDados:nPedido )
	aFindDPed[  3 ] := cValToChar( oDados:cProdutoDesc )
	aFindDPed[  4 ] := cValToChar( oDados:cArDesc )
	aFindDPed[  5 ] := cValToChar( oDados:cPostoValidacaoDesc )
	aFindDPed[  6 ] := AllTrim( cValToChar( oDados:cGrupo ) ) + ' ' + AllTrim( cValToChar( oDados:cGrupoDescricao ) )
	aFindDPed[  7 ] := u_fDtAENET( oDados:cDataPedido )
	aFindDPed[  8 ] := cValToChar( oDados:cProdutoDesc )
	aFindDPed[  9 ] := u_fDtAENET( oDados:cDataEmissao )
	aFindDPed[ 10 ] := cValToChar( oDados:cNomeTitular )
	aFindDPed[ 11 ] := cValToChar( oDados:nCpfTitular )
	aFindDPed[ 12 ] := cValToChar( oDados:cEmailTitular )
	aFindDPed[ 13 ] := cValToChar( oDados:nCnpjCert )
	aFindDPed[ 14 ] := cValToChar( oDados:cStatus ) + ' ' + Upper( U_RnNoAcento( cValToChar( oDados:cStatusDesc) ) )

	aFindDPed[ 15 ] := cValToChar( oDados:cufTitular )
	aFindDPed[ 16 ] := u_fDtAENET( oDados:cDataNascimento )
	aFindDPed[ 17 ] := cValToChar( oDados:cRg )
	aFindDPed[ 18 ] := cValToChar( oDados:cOrgaoExpedidorRg )
	aFindDPed[ 19 ] := cValToChar( oDados:cUf )
	aFindDPed[ 20 ] := cValToChar( oDados:cPisPasep )
	aFindDPed[ 21 ] := iIF( Empty(cValToChar( oDados:cRazaoSocial )), cValToChar( oDados:cRazaoSocialCert ), cValToChar( oDados:cRazaoSocial ) )
	aFindDPed[ 22 ] := cValToChar( oDados:ccidadeCnpj )
	aFindDPed[ 23 ] := cValToChar( oDados:cufCnpj )
	aFindDPed[ 24 ] := cValToChar( oDados:cCeiPJ )
	aFindDPed[ 25 ] := cValToChar( oDados:ctituloEleitor )
	aFindDPed[ 26 ] := cValToChar( oDados:ctituloEleitorZona )
	aFindDPed[ 27 ] := cValToChar( oDados:ctituloEleitorSecao )
	aFindDPed[ 28 ] := cValToChar( oDados:cvalidoDe )
	aFindDPed[ 29 ] := cValToChar( oDados:cvalidoAte )
	aFindDPed[ 30 ] := cValToChar( oDados:cnumeroSerie )
	aFindDPed[ 31 ] := u_fDtAENET( oDados:cdataValidacao, "DD/MM/AA" )
	aFindDPed[ 32 ] := cValToChar( oDados:cnomeAgenteValidacao )
	aFindDPed[ 33 ] := cValToChar( oDados:cArId )
	aFindDPed[ 34 ] := "" //codigoAR
	aFindDPed[ 35 ] := "" //biometria
	aFindDPed[ 36 ] := "" //online
	aFindDPed[ 37 ] := "" //descricaoAcao

	// Atribuir os dados dos Representantes
	If oDados:OWSREPRESENTANTES <> NIL .AND. Len( oDados:OWSREPRESENTANTES:OWSREPRESENTANTE ) > 0
		// Numero de representantes tem neste Json do check-out?
		nQtd := Len( oDados:OWSREPRESENTANTES:OWSREPRESENTANTE )
		// Atribuir o elemento 61 como vetor.
		aFindDPed[ nLen ] := {}

		// Laço para processar todas as NF do objeto Json do check-out.
		For nL := 1 To nQtd
			aRepresentante := {}
			AAdd( aRepresentante, oDados:OWSREPRESENTANTES:OWSREPRESENTANTE[nL] )

			// Atribuir um dado no elemento do array criado em questão.
			AAdd( aFindDPed[ nLen ], ' ' )
			// Qual o valor do elemento criado?
			m := Len( aFindDPed[ nLen ] )
			// Atribuir no elemento em questão como vetor.
			aFindDPed[ nLen, m ] := {}
			// Definir dois elemento para esta dimensão.
			aFindDPed[ nLen, m ] := Array( 12 )
			// Atribuir os dados as dimensões criadas.
			aFindDPed[ nLen, m, 01 ] := IIF( aRepresentante[1]:nPEDIDO == NIL 				, '', cValToChar( aRepresentante[1]:nPEDIDO ) )
			aFindDPed[ nLen, m, 02 ] := IIf( aRepresentante[1]:nCPF == NIL 					, '', cValToChar( aRepresentante[1]:nCPF ) )
			aFindDPed[ nLen, m, 03 ] := IIf( aRepresentante[1]:cNOME == NIL					, '', cValToChar( aRepresentante[1]:cNOME ) )
			aFindDPed[ nLen, m, 04 ] := IIf( aRepresentante[1]:cDATANASCIMENTO == NIL		, '', cValToChar( aRepresentante[1]:cDATANASCIMENTO ) )
			aFindDPed[ nLen, m, 05 ] := IIf( aRepresentante[1]:cRG == NIL					, '', cValToChar( aRepresentante[1]:cRG ) )
			aFindDPed[ nLen, m, 06 ] := IIf( aRepresentante[1]:cORGAREMISSORG == NIL		, '', cValToChar( aRepresentante[1]:cORGAREMISSORG ) )
			aFindDPed[ nLen, m, 07 ] := IIf( aRepresentante[1]:cUFRG == NIL					, '', cValToChar( aRepresentante[1]:cUFRG ) )
			aFindDPed[ nLen, m, 08 ] := IIf( aRepresentante[1]:cDATAEMISSAORG == NIL		, '', cValToChar( aRepresentante[1]:cDATAEMISSAORG ) )
			aFindDPed[ nLen, m, 09 ] := IIf( aRepresentante[1]:cINCAPAZ == NIL				, '', iIF( aRepresentante[1]:cINCAPAZ == '0', 'NAO', 'SIM' ) )
			aFindDPed[ nLen, m, 10 ] := IIf( aRepresentante[1]:cCODUSUARIO == NIL			, '', cValToChar( aRepresentante[1]:cCODUSUARIO ) )
			aFindDPed[ nLen, m, 11 ] := IIf( aRepresentante[1]:cDATAULTIMAATUALIZACAO == NIL, '', cValToChar( aRepresentante[1]:cDATAULTIMAATUALIZACAO ) )
			aFindDPed[ nLen, m, 12 ] := IIf( aRepresentante[1]:cDATAINSERCAO == NIL			, '', cValToChar( aRepresentante[1]:cDATAINSERCAO ) )
		Next nL
	Else
		aFindDPed[ nLen ] := {}
		AAdd( aFindDPed[ nLen ], ' ' )
		m := Len( aFindDPed[ nLen ] )
		aFindDPed[ nLen, m ] := {}
		aFindDPed[ nLen, m ] := Array( 12 )
		aFill( aFindDPed[ nLen, m ], '' )					
	Endif

Return .T.

Static Function getCertificado( cPedido, aCertif, cStack )
	Local oDados
	Local oWsGAR

	DEFAULT cStack := ''

	cStack += 'GETCERTIFICADO()' + CRLF

	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:consultaDadosCertificadoPorPedido( 'erp', 'password123', Val( cPedido ) )
	oDados := oWsGAR:oWsDadosCertificado

	aCertif := Array( 03 )
	aFill( aCertif, '' )

	If oDados == NIL .OR. oDados:nPedido == NIL
		aCertif[ 1 ] := 'false'
		Return
	Endif

	aCertif[  1 ] := 'true'
	aCertif[  2 ] := cValToChar( oDados:cStatus )
	aCertif[  3 ] := '' //cidadeTitular (Em construição GAR)
	/*aCertif[  3 ] := NoAcento( cValToChar( oDados:cAssunto ) )
	aCertif[  4 ] := NoAcento( cValToChar( oDados:cAssunto ) )
	aCertif[  5 ] := cValToChar( oDados:cDataNascimento )
	aCertif[  6 ] := cValToChar( oDados:cRg )
	aCertif[  7 ] := cValToChar( oDados:cOrgaoExpedidorRg )
	aCertif[  8 ] := cValToChar( oDados:cUf )
	aCertif[  9 ] := cValToChar( oDados:cPisPasep )
	aCertif[ 10 ] := cValToChar( oDados:cRazaoSocial )
	aCertif[ 11 ] := NoAcento( cValToChar( oDados:cAssunto ) )
	aCertif[ 12 ] := NoAcento( cValToChar( oDados:cAssunto ) )
	aCertif[ 13 ] := cValToChar( oDados:cCeiPJ )
	aCertif[ 14 ] := cValToChar( oDados:ctituloEleitor )
	aCertif[ 15 ] := cValToChar( oDados:ctituloEleitorZona )
	aCertif[ 16 ] := cValToChar( oDados:ctituloEleitorSecao )
	aCertif[ 17 ] := cValToChar( oDados:cvalidoDe )
	aCertif[ 18 ] := cValToChar( oDados:cvalidoAte )
	aCertif[ 19 ] := cValToChar( oDados:cnumeroSerie )*/
Return

Static Function getTrilhaAudit( cPedido, aTrilha, cStack )
	Local nElem := 0
	Local nI := 0
	Local oWsGAR
	Local oWsAud

	DEFAULT cStack := ''

	cStack += 'GETTRILHAAUDIT()' + CRLF

	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:listarTrilhasDeAuditoriaParaIdPedido( 'erp', 'password123', Val( cPedido ) )
	oWsAud := oWsGAR:oWsAuditoriaInfo

	AAdd( aTrilha, '' )
	nElem := Len( aTrilha )
	aTrilha[ nElem ] := {}
	aTrilha[ nElem ] := Array( 2 )
	aFill( aTrilha[ nElem ], '' )

	If oWsAud == NIL .OR. oWsAud[ 1 ]:nCpfUsuario == NIL
		aTrilha[ nElem, 1 ] := 'false'
		Return
	Endif

	// Buscar o último passo da trilha de auditoria.
	nI := Len( oWsAud ) 

	aTrilha[ nElem,  1 ] := 'true'
	aTrilha[ nElem,  2 ] := cValToChar( oWsAud[ nI ]:cAcao ) + ' ' + cValToChar( oWsAud[ nI ]:cDescricaoAcao )	
Return

Static Function getErpProtheus( cPedido, aERP, cStack )
	Local cTRB := GetNextAlias()

	DEFAULT cStack := ''

	cStack += 'GETERPPROTHEUS()' + CRLF

	BeginSql Alias cTRB

		Column DATVAL		As Date
		Column DATVER		As Date
		Column DATEMIS		As Date
		Column DATA_PEDIDO	As Date
		Column Z6_DTPEDI	As Date

		%NoParser%

		//Valor da Federação
		WITH QFED AS
		(SELECT Z6_PEDGAR PEDIDO_FED,
		SUM(Z6_VALCOM) VALOR_FED
		FROM %TABLE:SZ6% Z6 
		JOIN %TABLE:SZ3% Z3
		ON Z3_FILIAL = %XFILIAL:SZ3% AND
		Z3_CODENT = Z6.Z6_CODFED AND 
		Z3_RETPOS != 'N' AND 
		Z6.%NOTDEL%
		WHERE 
		Z6_FILIAL = %XFILIAL:SZ6% AND
		Z6_PEDGAR = %Exp:cPedido% AND
		Z6_TPENTID = '8' AND
		Z6.%NOTDEL%
		GROUP BY Z6_PEDGAR),
		//VALOR DA CAMPANHA
		QCAM AS
		(SELECT  Z6_PEDGAR PEDIDO_CAMP,
		Z6_CODVEND CODIGO_VENDEDOR,
		Z6_NOMVEND NOME_VENDEDOR,
		SUM(Z6_VLRPROD) BRUTO_CAMP,
		SUM(Z6_BASECOM) FAT_CAMP,
		SUM(Z6_VALCOM) COMIS_CAMPANHA,
		Z6_DESREDE LINK_CAMPANHA,
		CASE WHEN  SUM(Z6_VLRPROD) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CAMP
		FROM %TABLE:SZ6% Z6 
		WHERE 
		Z6_FILIAL = %XFILIAL:SZ6% AND
		Z6_PEDGAR = %Exp:cPedido% AND
		Z6_TPENTID IN ('7','10') AND
		Z6.%NOTDEL%
		GROUP BY Z6_PEDGAR,Z6_CODVEND,Z6_NOMVEND,Z6_DESREDE,Z6_TIPO),
		QANT AS
		(SELECT Z6_PEDGAR PEDIDO_ANT, ZF_PEDIDO PEDORI, Z5_DATEMIS DATA_PEDIDO FROM %TABLE:SZ6% SZ6
		JOIN %TABLE:SZF% SZF ON ZF_FILIAL = %XFILIAL:SZF% AND ZF_COD = Z6_CODVOU AND ZF_PEDIDO > ' ' AND SZF.%NOTDEL%
		JOIN %TABLE:SZ5% SZ5 ON Z5_FILIAL = %XFILIAL:SZ5% AND Z5_PEDGAR = ZF_PEDIDO AND SZ5.%NOTDEL%
		WHERE
		Z6_FILIAL = %XFILIAL:SZ6% AND
		Z6_PEDGAR = %Exp:cPedido% AND
		SZ6.%NOTDEL%
		GROUP BY Z6_PEDGAR, ZF_PEDIDO, Z5_DATEMIS
		UNION ALL
		SELECT SZ5.Z5_PEDGAR PEDIDO_ANT, SZ5.Z5_PEDGANT PEDORI, SZ51.Z5_DATEMIS DATA_PEDIDO FROM %TABLE:SZ5% SZ5
		JOIN %TABLE:SZ5% SZ51 ON SZ51.Z5_FILIAL = %XFILIAL:SZ5% AND SZ51.Z5_PEDGAR = SZ5.Z5_PEDGAR AND SZ51.%NOTDEL%
		where
		SZ5.Z5_FILIAL = %XFILIAL:SZ5% and 
		SZ5.Z5_PEDGAR = %Exp:cPedido% and
		SZ5.Z5_PEDGANT > ' ' AND
		SZ5.%NOTDEL%
		GROUP BY SZ5.Z5_PEDGAR, SZ5.Z5_PEDGANT, SZ51.Z5_DATEMIS)

		//DADOS DE VERIFICACAO
		SELECT  DECODE(Z6_TIPO,    	'RECANT','RECEBIDO ANTERIORMENTE',
		'REEMBO', 'REEMBOLSO',
		'NAOPAG', 'VOUCHER ORIGEM NAO REMUNERADO',
		'RETIFI', 'RETIFICACAO',
		'RENOVA', 'RENOVACAO',
		'ENTHAR', 'HARDWARE AVULSO',
		'SERVER', 'PRODUTO SERVIDOR',
		'PAGANT', 'PAGO ANTERIORMENTE',
		'VERIFI', 'VERIFICACAO') STATPED,
		CASE WHEN  (SUM(Z6_VLRPROD) = 0 AND SUM(Z6_VALCOM) = 0) OR Z6_TIPO IN ('RETIFI','PAGANT','EXTRA') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,
		CASE WHEN SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0 WHEN Z6_TIPO = 'REEMBO' THEN -1  ELSE 1 END CONT_CERHW,
		CASE WHEN SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT','ENTHAR') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CERSW,
		Z6_CODENT CODIGO_POSTO,
		Z6_DESENT DESCRICAO_POSTO,
		Z6_CODPOS CODIGO_POSTO_GAR,
		Z6_PRODUTO PRODUTO,
		SUM(DECODE(Z6_CATPROD,'1',Z6_VLRPROD,0)) VALOR_HARDWARE,
		SUM(DECODE(Z6_CATPROD,'1',Z6_BASECOM,0)) BASE_HARDWARE,
		SUM(DECODE(Z6_CATPROD,'1',Z6_VALCOM ,0)) COMHAR,
		SUM(DECODE(Z6_CATPROD,'2',Z6_VLRPROD,0)) VALOR_SOFTWARE,
		SUM(DECODE(Z6_CATPROD,'2',Z6_BASECOM,0)) BASE_SOFTWARE,
		SUM(DECODE(Z6_CATPROD,'2',Z6_VALCOM ,0)) COMSOF,
		SUM(Z6_VLRABT) VLR_ABATIMENTO,
		SUM(Z6_VLRPROD) VALOR_PRODUTO,
		SUM(Z6_BASECOM) BASE_COMISSAO,
		SUM(Z6_VALCOM) VALOR_COMISSAO,
		Z6_VALIDA DATVAL,				
		Z6_VERIFIC	DATVER,
		Z6_DTEMISS	DATEMIS,
		ZH_DESCRI TIPO_VOUCHER,
		Z6_NOMEAGE AGENTE_VALIDACAO,
		Z6_NOAGVER AGENTE_VERIFICACAO,
		VALOR_FED,
		SUM(Z6_VALCOM)+NVL(VALOR_FED,0) VLR_FED_COMISS,
		CODIGO_VENDEDOR,
		NOME_VENDEDOR,
		BRUTO_CAMP,
		FAT_CAMP,
		COMIS_CAMPANHA,
		LINK_CAMPANHA,
		CONT_CAMP,
		PEDORI,
		DATA_PEDIDO
		FROM %TABLE:SZ6% SZ6
		LEFT JOIN %TABLE:SZH% SZH ON ZH_FILIAL = %XFILIAL:SZH% AND ZH_TIPO = Z6_TIPVOU AND SZH.%NOTDEL%
		LEFT JOIN QFED ON PEDIDO_FED = Z6_PEDGAR
		LEFT JOIN QCAM ON PEDIDO_CAMP = Z6_PEDGAR
		LEFT JOIN QANT ON PEDIDO_ANT = Z6_PEDGAR
		WHERE
		Z6_FILIAL = %XFILIAL:SZ6% AND
		Z6_PEDGAR = %Exp:cPedido% AND
		Z6_TPENTID = '4' AND
		SZ6.%NOTDEL%
		GROUP BY  Z6_TIPO,
		Z6_CODENT,
		Z6_DESENT,
		Z6_CODPOS,
		Z6_PRODUTO,
		Z6_VALIDA,
		Z6_VERIFIC,
		Z6_DTEMISS,
		ZH_DESCRI,
		Z6_NOMEAGE,
		Z6_NOAGVER,
		VALOR_FED,
		CODIGO_VENDEDOR,
		NOME_VENDEDOR,
		BRUTO_CAMP,
		FAT_CAMP,
		COMIS_CAMPANHA,
		LINK_CAMPANHA,
		CONT_CAMP,
		PEDORI,
		DATA_PEDIDO
	EndSql

	// Retonar um array sem dados.
	If (cTRB)->(EOF())
		(cTRB)->( dbCloseArea() )
		aERP := Array( 32, 2 )
		AEval( aERP, {|e| e[1] := '', e[2] := '' } )
		aERP[ 1, 1 ] := 'retorno'
		aERP[ 1, 2 ] := 'false'
		Return
	Endif

	AADD( aERP ,{"retorno"							, "true" })
	//AADD( aERP ,{"dataValidacao"					, Dtoc((cTRB)->DATVAL)})
	//AADD( aERP ,{"nomeAgenteValidacao"				, RTrim((cTRB)->AGENTE_VALIDACAO)})
	AADD( aERP ,{"dataVerificacaoEmissao"			, u_fDtAENET(Dtoc((cTRB)->DATVER))})
	AADD( aERP ,{"nomeAgenteVerificaçãoEmissao"		, RTrim((cTRB)->AGENTE_VERIFICACAO)})
	AADD( aERP ,{"dataEmissaoRenovacao"				, u_fDtAENET(Dtoc((cTRB)->DATEMIS))})
	AADD( aERP ,{"statusPedido"						, RTrim((cTRB)->STATPED)})
	AADD( aERP ,{"valorTotalBase"					, LTrim(Str((cTRB)->BASE_COMISSAO))})
	AADD( aERP ,{"valorBaseSoftware"				, LTrim(Str((cTRB)->BASE_SOFTWARE))})
	AADD( aERP ,{"valorBaseHardware"				, LTrim(Str((cTRB)->BASE_HARDWARE))})
	AADD( aERP ,{"tipoVoucher"						, RTrim((cTRB)->TIPO_VOUCHER)})
	AADD( aERP ,{"pedidoAnterior"					, RTrim((cTRB)->PEDORI)})
	AADD( aERP ,{"dataPedidoAnterior"				, u_fDtAENET(Dtoc((cTRB)->DATA_PEDIDO))})
	AADD( aERP ,{"valorAbatimento"					, LTrim(Str((cTRB)->VLR_ABATIMENTO))})
	AADD( aERP ,{"valorBrutoSoftware"				, LTrim(Str((cTRB)->VALOR_SOFTWARE))})
	AADD( aERP ,{"valorBrutoHardware"				, LTrim(Str((cTRB)->VALOR_HARDWARE))})
	AADD( aERP ,{"valorBrutoTotal"					, LTrim(Str((cTRB)->VALOR_PRODUTO))})
	AADD( aERP ,{"valorComissaoSoftware"			, LTrim(Str((cTRB)->COMSOF))})
	AADD( aERP ,{"valorComissaoHardware"			, LTrim(Str((cTRB)->COMHAR))})
	AADD( aERP ,{"valorComissaoTotal"				, LTrim(Str((cTRB)->VALOR_COMISSAO))})
	AADD( aERP ,{"valorComissaoFederacao"			, LTrim(Str((cTRB)->VALOR_FED))})
	AADD( aERP ,{"valorTotalComissaoSomaFederacao"	, LTrim(Str((cTRB)->VLR_FED_COMISS))})
	AADD( aERP ,{"contagemGeral"					, LTrim(Str((cTRB)->CONT_CER))})
	AADD( aERP ,{"contagemSoftware"					, LTrim(Str((cTRB)->CONT_CERSW))})
	AADD( aERP ,{"contagemHardware"					, LTrim(Str((cTRB)->CONT_CERHW))})
	AADD( aERP ,{"codigoProduto"					, RTrim((cTRB)->PRODUTO)})
	AADD( aERP ,{"codigoPosto"						, RTrim((cTRB)->CODIGO_POSTO_GAR)})
	AADD( aERP ,{"codigoVendedor"					, RTrim((cTRB)->CODIGO_VENDEDOR)})
	AADD( aERP ,{"nomeVendedor"						, RTrim((cTRB)->NOME_VENDEDOR)})
	AADD( aERP ,{"linkCampanha"						, RTrim((cTRB)->LINK_CAMPANHA)})
	AADD( aERP ,{"valorBruto"						, LTrim(Str((cTRB)->BRUTO_CAMP))})
	AADD( aERP ,{"valorFaturamento"					, LTrim(Str((cTRB)->FAT_CAMP))})
	AADD( aERP ,{"valorTotalComissao"				, LTrim(Str((cTRB)->COMIS_CAMPANHA))})
	AADD( aERP ,{"contagemCampanha"					, LTrim(Str((cTRB)->CONT_CAMP))})
	AADD( aERP ,{"codigoEntidade"					, RTrim((cTRB)->CODIGO_POSTO)})
	

	(cTRB)->( dbCloseArea() )
Return

user function fDtAENET( cDate, cFormat )
	local cRetorno := ""
	default cDate := ""
	default cFormat := ""

	cRetorno := cDate
	if cFormat == "DD/MM/AA"
		if valtype(cDate) == "C"
			cRetorno := ctod(cDate)
		endif
		cRetorno :=  Day2Str(cRetorno)+"/"+Month2Str(cRetorno)+"/"+right(Year2Str(cRetorno), 2)
	endif
return cRetorno

user function vldCodAR( cCNPJ, cCodAr )
	local lValido  := .F.
	local cAlias   := GetNextAlias()
	default cCNPJ  := ""
	default cCodAr := ""

	if !empty( cCNPJ ) .and. !empty( cCodAr ) 

		cQuery := " SELECT  "
		cQuery += " 	SZ3ENT.Z3_CODGAR "
		cQuery += " FROM SA2010 SA2 "
		cQuery += " INNER JOIN " + RetSqlName("SZ3") + " SZ3FOR ON "
		cQuery += " 	SZ3FOR.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND SZ3FOR.Z3_CODFOR = SA2.A2_COD "
		cQuery += " 	AND SZ3FOR.Z3_CODAR <> '' "
		cQuery += " INNER JOIN SZ3010 SZ3ENT ON  "
		cQuery += " 	SZ3ENT.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND SZ3ENT.Z3_CODENT = SZ3FOR.Z3_CODAR "
		cQuery += " WHERE  "
		cQuery += " 	SA2.D_E_L_E_T_ = ' ' "
		cQuery += " 	AND SA2.A2_CGC = '"+cCNPJ+"' "
		
		cQuery := ChangeQuery( cQuery )
		conout(cQuery)
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQuery ), cAlias, .F., .T. )

		While (cAlias)->( .NOT. EOF() )
			if rtrim((cAlias)->Z3_CODGAR) == rtrim( cCodAr )
				lValido := .T.
			endif
			(cAlias)->( dbSkip() )
		End
		(cAlias)->( dbCloseArea() )	
	endif
return lValido