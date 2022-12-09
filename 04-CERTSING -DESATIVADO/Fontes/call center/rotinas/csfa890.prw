// **************************************************************************
// ****                                                                  ****
// ****                 Serviços Protheus Webservice REST                ****
// ****                                                                  ****
// **************************************************************************

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'
#include 'tbiconn.ch'

//*********************************************************
//*** SERVIÇOS PROTHEUS WEBSERVICE REST PARA AUTENTICAR *** 
//***                                                   ***  
//*********************************************************

WSRESTFUL arAutenticar DESCRIPTION 'Autenticação no TOTVS Protheus x AENET'
	WSDATA cUser     AS STRING OPTIONAL
	WSDATA cPassWord AS STRING OPTIONAL
	 
	WSMETHOD GET DESCRIPTION 'Autenticação no TOTVS Protheus x AENET' WSSYNTAX '/arAutenticar/{id/code}'
END WSRESTFUL

WSMETHOD GET WSRECEIVE cUser, cPassWord WSSERVICE arAutenticar
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_890_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: arAutenticar()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()
	
	Local lRet := .T.
	
	DEFAULT cUser := 'x'
	DEFAULT cPassWord := 'x'
	
	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X AENET', '.T.' )
	Endif
	
	lLigaLog := GetMv( cLigaLog, .F. )
	
	If lLigaLog
		aParLog[ 1 ] := 'AUTENTICAR'
		aParLog[ 2 ] := 'ARAUTENTICAR [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA AENET.'
		aParLog[ 5 ] := U_rnGetNow()
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	// Define o tipo de retorno do método.
	::SetContentType('application/json')
	
	// Tentativa de autenticar o usuário e senha.
	lRet := procAutent( ::aURLParms, @cReturn, @aRet, @cStack, cThread )
	
	If lRet
		::SetResponse( cReturn )
	Else
		::SetResponse( '{"codigo": ' + LTrim( Str( aRet[ 1 ] ) ) + ',"mensagem": "' + aRet[ 2 ] +'" }' )
	Endif
	
	If lLigaLog
		aParLog[ 2 ] := 'ARAUTENTICAR [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := LTrim( Str( aRet[ 1 ] ) ) + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Após processar gerar log da requisição entregue.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	DelClassIntf()
Return(.T.)

Static Function procAutent( aParam, cReturn, aRet, cStack, cThread )
	Local lRet := .F.
	
	cStack += 'PROCAUTENT()' + CRLF
	
	If Len( aParam ) == 2
		If ValType( aParam[ 1 ] ) == 'C' .AND. ValType( aParam[ 2 ] ) == 'C'
			aRet := authUser( aParam[ 1 ], aParam[ 2 ], @cStack, @cReturn, cThread )
			If aRet[ 1 ] == 100
				lRet := .T.
			Endif
		Else
			U_arErro( 105, @aRet, @cReturn )
		Endif
	Else
		U_arErro( 101, @aRet, @cReturn )
	Endif
	
	U_arConout( cReturn + ' ' + cThread )
Return( lRet )

Static Function authUser( cLogin, cPassWord, cStack, cReturn, cThread )
	Local aRet := {'',''}
	Local cUsuario := ''
	Local cSenha := ''
	
	cStack += 'AUTHUSER()' + CRLF
	
	cUsuario := deCode64( AllTrim( cLogin ) )
	cSenha   := deCode64( AllTrim( cPassWord ) )
	
	PswOrder( 2 )
	
	If	PswSeek( cUsuario )
		If PswRet()[ 1, 17 ]
			U_arErro( 103, @aRet, @cReturn )
		Else 
			If PswName( cSenha )
				aRet[ 1 ] := 100
				aRet[ 2 ] := '{"mensagem":"Autenticacao bem sucedida."}'
				cReturn   := '{"token":"' + enCode64( getToken( @cStack ) + cUsuario ) + '"}'
			Else
				U_arErro( 104, @aRet, @cReturn )
			Endif
		Endif
	Else
		U_arErro( 102, @aRet, @cReturn )
	Endif
Return( aRet )

Static Function getToken( cStack )
	Local aSeed := {8,9,8,9,8,9}
	Local cHr1 := StrTran( Time(), ':', '' )
	Local cHr2 := ''
	DEFAULT cStack := ''
	cStack += 'GETTOKEN()' + CRLF
	AEval( aSeed, { |v,i| cHr2 += LTrim( Str( v - Val( SubStr( cHr1, i, 1 ) ) ) ) } )
Return( LTrim( Str( Date() - Ctod( '01/01/96','DDMMYYYY') ) ) + cHr2 )

//***************************************************************************************
//***                                                                                 ***
//*** AS ROTINAS ABAIXO SÃO PARA EFEUTAR TESTES DAS ROTINAS AUXILIARES DO WEB SERVICE ***
//***                                                                                 ***
//***************************************************************************************

// Testar a autenticação.
User Function My890a()
	Local aPar := {'aenet\integracao','q#6PlA&*m@uB4yhm'}
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_890_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: My890a()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()
	
	Local lRet := .T.
	
	RpcSetType( 3 )
	RpcSetEnv( '01', '02' )
	
	aPar[ 1 ] := enCode64( aPar[ 1 ] )
	aPar[ 2 ] := enCode64( aPar[ 2 ] )
	
	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X AENET.', '.F.' )
	Endif
	
	lLigaLog := GetMv( cLigaLog, .F. )
	
	If lLigaLog
		aParLog[ 1 ] := 'AUTENTICAR'
		aParLog[ 2 ] := 'ARAUTENTICAR [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', aPar, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO AENET.'
		aParLog[ 5 ] := U_rnGetNow()
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	// Tentativa de autenticar o usuário e senha.
	lRet := procAutent( aPar, @cReturn, @aRet, @cStack, cThread )
	
	If lRet
		// Autenticação bem sucedida.
		CopytoClipboard( cReturn )
		MsgAlert( cReturn, 'TOTVS' )
	Else
		// Autenticação mal sucedida.
		cReturn := 'user: ' + aRet[ 1 ] + ' password: ' + aRet[ 2 ]
		CopytoClipboard( cReturn )
		MsgAlert( cReturn, 'TOTVS' )
	Endif
	
	If lLigaLog
		aParLog[ 2 ] := 'ARAUTENTICAR [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := LTrim( Str( aRet[ 1 ] ) )+ ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Após processar gerar log da requisição entregue.
		StartJob( 'U_arPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	DelClassIntf()
Return