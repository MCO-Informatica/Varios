// **************************************************************************
// ****                                                                  ****
// **** Serviços Protheus Webservice REST para integrar RightNow com GAR ****
// ****                                                                  ****
// **************************************************************************

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'
#include 'tbiconn.ch'

STATIC lPostgres := ( Upper( GetEnvServer() ) == 'POSTGRES' )

//********************************************************
//*** SERVIÇO PROTHEUS PARA CONFERIR O TOKEN E         *** 
//*** DEVOLVER DADOS DO AGENTE/GAR FORMATO JSON        *** 
//********************************************************

WSRESTFUL RNAgente DESCRIPTION 'Integração ERP Protheus x RightNow - GAR/Agente'
	WSDATA cToken       AS STRING OPTIONAL
	WSDATA cLocalizador AS STRING OPTIONAL
	WSDATA cOpcConsulta AS STRING OPTIONAL
	
	WSMETHOD GET DESCRIPTION 'Integração ERP Prothueus x RightNow Cloud Service Orcale' WSSYNTAX '/rightnow/{id}'
END WSRESTFUL

WSMETHOD GET WSRECEIVE cToken, cLocalizador, cOpcConsulta WSSERVICE RNAgente
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_880_02'
	Local cReturn := ''	
	Local cStack := 'Pilha de chamada: RNAGENTE()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()
		
	Local lRet := .T.
	
	DEFAULT cToken := 'x'
	DEFAULT cLocalizador := 'x'
	DEFAULT cOpcConsulta := 'x'
	
	U_rnConout('Parametros recebidos: ' + VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) )

	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif
	
	lLigaLog := GetMv( cLigaLog, .F. )
	
	If lLigaLog
		aParLog[ 1 ] := 'CONSULTARAGENTE'
		aParLog[ 2 ] := 'RNAGENTE [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA EXTERNO.'
		aParLog[ 5 ] := U_rnGetNow()	
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	// Define o tipo de retorno do método
	::SetContentType('application/json')

	U_rnConout('Entrei no RNAgente.')

	lRet := U_validParam( ::aURLParms, @aRet )
	
	If lRet
		lRet := procAgente( ::aURLParms, @cReturn, @aRet, @cStack, cThread )
	Endif
	
	U_rnConout('Sai do RNAgente. ' + cThread)
	
	If lRet
		::SetResponse( cReturn )
	Else
		cReturn := '{"codigo": ' + aRet[ 1 ] + ',"menssagem": "' + aRet[ 2 ] +'" }'
		::SetResponse( cReturn )
		
		U_rnConout( 'Retorno inconsistente: ' + cReturn )
	Endif
		
	If lLigaLog
		aParLog[ 2 ] := 'RNAGENTE [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := aRet[ 1 ] + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Após processar gerar log da requisição entregue.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	DelClassIntf()
Return( .T. )

Static Function procAgente( aParam, cReturn, aRet, cStack, cThread )
	Local cDoc := ''
	Local cKey := ''
	Local cOpc := ''
	Local lRet := .T.
	
	U_rnConout('Entrei no procAgente. ' + cThread)
	
	cStack += 'PROCAGENTE()' + CRLF
	
	If Len( aParam ) == 3
		
		U_rnConout('Entrei na primeira condicao. ' + cThread)
		
		cKey := aParam[ 1 ]
		cDoc := aParam[ 2 ]
		cOpc := aParam[ 3 ]
		
		U_rnConout('Entrei no validToken. ' + cThread )
		
		lRet := U_rnVldToken( cKey, aRet, @cStack, cThread )
		
		U_rnConout('Sai do validToken. ' + cThread)
		
		If lRet 
			U_rnConout( 'Token homologado. ' + cThread )
			If cOpc == '3'
			
				U_rnConout('Entrei no getAgente. ' + cThread )
				
				cReturn := getAgente( cDoc, @cStack, cThread )
				
				U_rnConout('Sai no getAgente. ' + cThread)
			Else
				lRet := .F.
				aRet[ 1 ] := '321'
				aRet[ 2 ] := 'Conteudo do parametro invalido. Esperado o valor 3.'
				U_rnConout( aRet[ 2 ] + cThread )
			Endif
		Else
			U_rnConout( aRet[ 2 ] + cThread )
		Endif
	Else
		lRet := .F.
		aRet[ 1 ] := '320'
		aRet[ 2 ] := 'Quantidade de parametro invalido. Esperado: token/documento/type.' + cThread
		U_rnConout( aRet[ 2 ] + ' ' + cThread )	
	Endif
Return lRet

Static Function getAgente( cDoc, cStack, cThread )
	Local aAgente := {}
	Local aHead := {}
	
	Local cJson := ''
	Local cMV_881_06 := 'MV_881_06'
	
	Local lVarInfo := .F.
	
	Local nCPF := Val( cDoc )
	Local nElem := 0
	Local nI := 0
	
	Local oWsGar
	Local oObj
	
	If .NOT. GetMv( cMV_881_06, .T. )
		CriarSX6( cMV_881_06, 'L', '1=HABILITAR, 0=DESABILITAR VARINFO P/ OBJETOS CHECKOUT/GAR. CSFA881.','.F.' )
	Endif
	
	lVarInfo := GetMv( cMV_881_06, .F. )
	
	cStack += 'GETAGENTE()' + CRLF
	
	U_rnConout('Vou conectar no consultaCadastroCompletoAgente. ' + cThread )
	
	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:consultaCadastroCompletoAgente( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
										   eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
										   nCPF )
	
	U_rnConout('Vou ler os dados do consultaCadastroCompletoAgente. ' + cThread)
	
	If oWsGAR == NIL .OR. oWsGAR:oWsAgente[1]:cCPF == NIL 
		ConOut('_____________________________________________________________________________________________')
		ConOut('_______________### NAO CONSEGUI CONSULTAR O consultaCadastroCompletoAgente ###_______________')
		ConOut(VarInfo( 'consultaCadastroCompletoAgente', cDoc, ,.F., .F. ))
		If lVarInfo
			ConOut(VarInfo( 'WSIntegracaoGARERPImplService', oWsGAR, ,.F., .F. ))
			ConOut(VarInfo( 'consultaCadastroCompletoAgente - numero do CPF: ' + cDoc, oWsGAR, ,.F., .F. ))
		Endif
		ConOut('_____________________________________________________________________________________________')
			
		aAgente := Array( 6 )
		aFILL( aAgente, '' )
		
		aAgente[ 1 ] := 'Agente de registro nao encontrado no GAR-AgenteRegistro'
		aAgente[ 6 ] := {}

		AAdd( aAgente[ 6 ], '' )
		nElem := Len( aAgente[ 6 ] )
		aAgente[ 6, nElem ] := {}
		aAgente[ 6, nElem ] := Array( 20 )
		aFILL( aAgente[ 6, nElem ], '' )
	Else
		U_rnConout('Vou iniciar o processamento do consultaCadastroCompletoAgente. ' + cThread)
		aAgente := Array( 6 )
		aAgente[ 1 ] := 'Agente de registro localizado no GAR-AgenteRegistro'
		aAgente[ 2 ] := cValToChar( oWsGar:oWsAgente[1]:nId )
		aAgente[ 3 ] := cValToChar( oWsGar:oWsAgente[1]:cNome )
		aAgente[ 4 ] := U_rnLeftZero( cValToChar( oWsGar:oWsAgente[1]:cCPF ), 'CPF' )
		aAgente[ 5 ] := U_rnNoAcento( cValToChar( oWsGar:oWsAgente[1]:cEMail ) )
		aAgente[ 6 ] := {}
		
		If Len( oWsGar:oWsAgente[1]:oWsHabilitacao ) == 0
			AAdd( aAgente[ 6 ], '' )
			nElem := Len( aAgente[ 6 ] )
			aAgente[ 6, nElem ] := {}
			aAgente[ 6, nElem ] := Array( 20 )
			aFill( aAgente[ 6, nElem ], '' )
			
			aAgente[ 6, nElem, 1 ] := '*** SEM HABILITACAO ***'
		Else
			For nI := 1 To Len( oWsGar:oWsAgente[1]:oWsHabilitacao )
				AAdd( aAgente[ 6 ], '' )
				nElem := Len( aAgente[ 6 ] )
				aAgente[ 6, nElem ] := {}
				aAgente[ 6, nElem ] := Array( 20 )
				
				// AC --------------------------------------------------------------------------------------------------------------------
				aAgente[ 6, nElem,  1 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsAC:cDescricao )
				// AR --------------------------------------------------------------------------------------------------------------------
				aAgente[ 6, nElem,  2 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsAR:cId )
				aAgente[ 6, nElem,  3 ] := U_rnNoAcento( cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsAR:cDescricao ) )
				aAgente[ 6, nElem,  4 ] := U_rnLeftZero( cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsAR:nCNPJ ), 'CNPJ' )
				aAgente[ 6, nElem,  5 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsAR:cMunicipio )
				aAgente[ 6, nElem,  6 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsAR:cUF )
				aAgente[ 6, nElem,  7 ] := Iif( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsAR:lAtendimento , 'true', 'false' )
				aAgente[ 6, nElem,  8 ] := Iif( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsAR:lAtivo , 'true', 'false' )
				// POSTO -----------------------------------------------------------------------------------------------------------------
				aAgente[ 6, nElem,  9 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:nId )
				aAgente[ 6, nElem, 10 ] := U_rnNoAcento( cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:cDescricao ) )
				aAgente[ 6, nElem, 11 ] := U_rnLeftZero( cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:cCNPJ ), 'CNPJ' )
				aAgente[ 6, nElem, 12 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:cCidade )
				aAgente[ 6, nElem, 13 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:cUF )
				aAgente[ 6, nElem, 14 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:nCEP )
				aAgente[ 6, nElem, 15 ] := Iif( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:lAtendimento, 'true', 'false' )
				aAgente[ 6, nElem, 16 ] := Iif( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:lAtivo, 'true', 'false' )
				aAgente[ 6, nElem, 17 ] := U_rnNoAcento( cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:cEndereco ) )
				aAgente[ 6, nElem, 18 ] := cValToChar( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:nPostoOrganizacional )
				aAgente[ 6, nElem, 19 ] := Iif( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:lVendasHw, 'true', 'false' )
				aAgente[ 6, nElem, 20 ] := Iif( oWsGar:oWsAgente[1]:oWsHabilitacao[ nI ]:oWsPosto:lVisibilidade, 'true', 'false' )
				//------------------------------------------------------------------------------------------------------------------------
			Next nI
		Endif
	Endif
	
	AAdd( aHead, 'acDescricao' )
	AAdd( aHead, 'arId' )
	AAdd( aHead, 'arDescricao' )
	AAdd( aHead, 'arCNPJ' )
	AAdd( aHead, 'arMunicipio' )
	AAdd( aHead, 'arUF' )
	AAdd( aHead, 'arAtendimento' )
	AAdd( aHead, 'arAtivo' )
	AAdd( aHead, 'postoId' )
	AAdd( aHead, 'postoDescricao' )
	AAdd( aHead, 'postoCNPJ' )
	AAdd( aHead, 'postoCidade' )
	AAdd( aHead, 'postoUF' )
	AAdd( aHead, 'postoCEP' )
	AAdd( aHead, 'postoAtendimento' )
	AAdd( aHead, 'postoAtivo' )
	AAdd( aHead, 'postoEndereco' )
	AAdd( aHead, 'postoOrganizacional' )
	AAdd( aHead, 'postoVendasHw' )
	AAdd( aHead, 'postoVisibilidade' )
	
	cJson := '{ "dadosAgenteRegistro":{ '
	cJson += '"msgRetorno": "'  + aAgente[ 1 ] + '",' 
	cJson += '"agenteId": "'    + aAgente[ 2 ] + '",' 
	cJson += '"agenteNome": "'  + U_RnNoAcento( aAgente[ 3 ] ) + '",'
	cJson += '"agenteCPF": "'   + aAgente[ 4 ] + '",'
	cJson += '"agenteEmail": "' + aAgente[ 5 ] + '",'
	cJson += '"habilitacao":[' 
	
	For nI := 1 To Len( aAgente[ 6 ] )
		cJson += '{'
		cJson += '"' + aHead[ 1 ] + '": "' + aAgente[ 6, nI, 1 ] + '",'
		cJson += '"' + aHead[ 2 ] + '": "' + cValToChar( aAgente[ 6, nI, 2 ] ) + '",'
		cJson += '"' + aHead[ 3 ] + '": "' + aAgente[ 6, nI, 3 ] + '",'
		cJson += '"' + aHead[ 4 ] + '": "' + aAgente[ 6, nI, 4 ] + '",'
		cJson += '"' + aHead[ 5 ] + '": "' + aAgente[ 6, nI, 5 ] + '",'
		cJson += '"' + aHead[ 6 ] + '": "' + aAgente[ 6, nI, 6 ] + '",'
		cJson += '"' + aHead[ 7 ] + '": "' + aAgente[ 6, nI, 7 ] + '",'
		cJson += '"' + aHead[ 8 ] + '": "' + aAgente[ 6, nI, 8 ] + '",'
		cJson += '"' + aHead[ 9 ] + '": "' + aAgente[ 6, nI, 9 ] + '",'
		cJson += '"' + aHead[ 10] + '": "' + aAgente[ 6, nI, 10] + '",'
		cJson += '"' + aHead[ 11] + '": "' + aAgente[ 6, nI, 11] + '",'
		cJson += '"' + aHead[ 12] + '": "' + aAgente[ 6, nI, 12] + '",'
		cJson += '"' + aHead[ 13] + '": "' + aAgente[ 6, nI, 13] + '",'
		cJson += '"' + aHead[ 14] + '": "' + aAgente[ 6, nI, 14] + '",'
		cJson += '"' + aHead[ 15] + '": "' + aAgente[ 6, nI, 15] + '",'
		cJson += '"' + aHead[ 16] + '": "' + aAgente[ 6, nI, 16] + '",'
		cJson += '"' + aHead[ 17] + '": "' + aAgente[ 6, nI, 17] + '",'
		cJson += '"' + aHead[ 18] + '": "' + aAgente[ 6, nI, 18] + '",'
		cJson += '"' + aHead[ 19] + '": "' + aAgente[ 6, nI, 19] + '",'
		cJson += '"' + aHead[ 20] + '": "' + aAgente[ 6, nI, 20] + '" '
		cJson += '},'
	Next nI
	
	cJson := SubStr( cJson, 1, Len( cJson )-1 ) + '] } }'
	
	U_rnConout('Finalizei a leitura dos dados consultaCadastroCompletoAgente e montei o Json: ' + cJson )
	U_rnConout('Finalizei o processamento do getAgente. ' + cThread )
Return( cJson )

//***************************************************************************************
//***                                                                                 ***
//*** AS ROTINAS ABAIXO SÃO PARA EFEUTAR TESTES DAS ROTINAS AUXILIARES DO WEB SERVICE ***
//***                                                                                 ***
//***************************************************************************************
/*
CPF Danilo -> 42781448818
CPF Léo ----> 32845914865
*/
// Testar a busca de dados de agente de registro
User Function My882a( cCPF )
	Local aEnv := {}
	Local aPar := { '', cCPF, '3' }
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_880_02'
	Local cReturn := ''	
	Local cStack := 'Pilha de chamada: My882a()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()
		
	Local lRet := .T.
	
	DEFAULT cCPF := '42781448818'
	
	aPar := { '', cCPF, '3' }
	
	aEnv := Iif( lPostgres, {'99','01'}, {'01','02'} )
	
	RpcSetType( 3 )
	RpcSetEnv( aEnv[ 1 ], aEnv[ 2 ] )

	aPar[ 1 ] := enCode64( StaticCall( CSFA880, GETTOKEN, @cStack ) + 'Protheus.RightNow' )
	
	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif
	
	lLigaLog := GetMv( cLigaLog, .F. )
	
	If lLigaLog
		aParLog[ 1 ] := 'CONSULTARAGENTE'
		aParLog[ 2 ] := 'RNAGENTE [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', aPar, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA EXTERNO.'
		aParLog[ 5 ] := U_rnGetNow()	
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	U_rnConout('Entrei no RNAgente. ' + cThread)

	lRet := U_validParam( aPar, @aRet )
	
	If lRet
		lRet := procAgente( aPar, @cReturn, @aRet, @cStack, cThread )
	Endif
	
	U_rnConout('Sai do RNAgente. ' + cThread)
	
	If lRet
		MsgAlert( cReturn, 'TOTVS' )
	Else
		MsgAlert( '{"codigo": ' + aRet[ 1 ] + ',"menssagem": "' + aRet[ 2 ] +'" }', 'TOTVS' )
	Endif
	
	If lLigaLog
		aParLog[ 2 ] := 'RNAGENTE [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := aRet[ 1 ] + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Após processar gerar log da requisição entregue.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	DelClassIntf()
Return