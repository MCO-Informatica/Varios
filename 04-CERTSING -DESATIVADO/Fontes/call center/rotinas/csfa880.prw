// **************************************************************************
// ****                                                                  ****
// **** Serviços Protheus Webservice REST para integrar RightNow com GAR ****
// ****                                                                  ****
// **************************************************************************

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'restful.ch'
#include 'tbiconn.ch'

//*********************************************************
//*** SERVIÇOS PROTHEUS WEBSERVICE REST PARA AUTENTICAR *** 
//*** O USUÁRIO PROTHEUS E DEVOLVER UM TOKEN            ***  
//*********************************************************

WSRESTFUL RNAutenticar DESCRIPTION 'Autenticação RightNow x ERP Protheus'
	WSDATA cUser     AS STRING OPTIONAL
	WSDATA cPassWord AS STRING OPTIONAL
	 
	WSMETHOD GET DESCRIPTION 'Autenticação do RightNow Cloud Service Orcale x ERP Protheus' WSSYNTAX '/rightnow/{id}'
END WSRESTFUL

WSMETHOD GET WSRECEIVE cUser, cPassWord WSSERVICE RNAutenticar
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_880_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: RNAUTENTICAR()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()
	
	Local lRet := .T.
	
	DEFAULT cUser := 'x'
	DEFAULT cPassWord := 'x'
	
	conout("######Iniciou o metodo RNAutenticar")
	
	U_rnConout( 'Parametros recebidos: ' + VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) )
	
	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif
	
	lLigaLog := GetMv( cLigaLog, .F. )
	
	If lLigaLog
		aParLog[ 1 ] := 'AUTENTICAR'
		aParLog[ 2 ] := 'RNAUTENTICAR [input]'
		aParLog[ 3 ] := VarInfo( '::aURLParms', ::aURLParms, ,.F., .F. ) + CRLF + cStack
		aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA EXTERNO.'
		aParLog[ 5 ] := U_rnGetNow()
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
	
		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	// Define o tipo de retorno do método.
	::SetContentType('application/json')
	
	// Tentativa de autenticar o usuário e senha.
	lRet := procAutent( ::aURLParms, @cReturn, @aRet, @cStack, cThread )
	
	If lRet
		// Autenticação bem sucedida.
		::SetResponse( cReturn )
	Else
		// Autenticação mal sucedida.
		cReturn := '{"codigo": ' + aRet[ 1 ] + ',"menssagem": "' + aRet[ 2 ] +'" }'
		::SetResponse( cReturn )
		
		U_rnConout( 'Retorno inconsistente: ' + cReturn )
	Endif
	
	If lLigaLog
		aParLog[ 2 ] := 'RNAUTENTICAR [output]'
		aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
		aParLog[ 4 ] := aRet[ 1 ] + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
		aParLog[ 6 ] := U_rnGetNow()
		aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
		// Após processar gerar log da requisição entregue.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	DelClassIntf()
	
	conout("######Finalizou o metodo RNAutenticar")
Return( .T. )

Static Function procAutent( aParam, cReturn, aRet, cStack, cThread )
	Local lRet := .T.
	
	cStack += 'PROCAUTENT()' + CRLF
	
	If Len( aParam ) == 2
		If ValType( aParam[ 1 ] ) == 'C' .AND. ValType( aParam[ 2 ] ) == 'C'
			aRet := authUser( aParam[ 1 ], aParam[ 2 ], @cStack )
			If aRet[ 1 ] == '300'
				cReturn := '{"token":"' + aRet[ 2 ] + '"}'
				U_rnConout( 'Autenticacao bem sucedida, [token: ' + aRet[ 2 ] + '] ' + cThread )
				aRet[ 2 ] := 'Autenticacao bem sucedida.'
			Else
				lRet := .F.
				U_rnConout( 'Autenticacao mal sucedida: ' + aRet[ 1 ] + '-' + aRet[ 2 ] + ' ' + cThread)
				cReturn := aRet[ 1 ]+' '+aRet[ 2 ]
			Endif
		Else
			If ValType( aParam[ 1 ] ) <> 'C'
				aRet[ 1 ] := '331'
				aRet[ 2 ] := 'Parametro 1 diferente do tipo caractere. '
				cReturn := aRet[ 1 ]+' '+aRet[ 2 ]
			Endif
			If ValType( aParam[ 1 ] ) <> 'C'
				If Empty( aRet[ 1 ] )
					aRet[ 1 ] := '332'
				Endif
				aRet[ 2 ] := Iif( Empty( aRet[ 2 ] ), '', CRLF ) + 'Parametro 2 diferente do tipo caractere. '
				cReturn := aRet[ 1 ]+' '+aRet[ 2 ]
			Endif
		Endif
	Else
		aRet[ 1 ] := '301'
		aRet[ 2 ] := 'Quantidade de parametro invalido, usuario e senha de acesso.'
		lRet := .F.
		cReturn := aRet[ 2 ]
		U_rnConout( cReturn + ' ' + cThread )
	Endif
Return lRet

Static Function authUser( cLogin, cPassWord, cStack )
	Local aRet := {'',''}
	Local cUsuario := ''
	Local cSenha := ''
	
	cStack += 'AUTHUSER()' + CRLF
	
	cUsuario := deCode64( AllTrim( cLogin ) )
	cSenha := deCode64( AllTrim( cPassWord ) )
	
	PswOrder( 2 )
	
	If	PswSeek( cUsuario )
		If PswRet()[ 1, 17 ]
			aRet[ 1 ] := '302'
 			aRet[ 2 ] := 'Usuario com acesso bloqueado. '
		Else 
			If PswName( cSenha )
				aRet[ 1 ] := '300'
				aRet[ 2 ] := enCode64( getToken( @cStack ) + cUsuario )
			Else
				aRet[ 1 ] := '303'
				aRet[ 2 ] := 'Senha invalida. '
			Endif
		Endif
	Else
		aRet[ 1 ] := '304'
		aRet[ 2 ] := 'Usuario nao existe. '
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
User Function My880a()
	Local aPar := {'Protheus.RightNow','4b#8YPD!F_Qm'}
	Local aParLog := Array( 7 )
	Local aRet := {'',''}
	Local cEnvSrv := GetEnvServer()
	Local cLigaLog := 'MV_880_02'
	Local cReturn := ''
	Local cStack := 'Pilha de chamada: My880a()' + CRLF
	Local cThread := 'Thread: ' + LTrim( Str( ThreadID() ) )
	Local lLigaLog := .F.
	Local nTimeIni := Seconds()
	
	Local lRet := .T.
	
	RpcSetType( 3 )
	RpcSetEnv( '01', '02' )
	
	aPar[ 1 ] := enCode64( aPar[ 1 ] )
	aPar[ 2 ] := enCode64( aPar[ 2 ] )
	
	aParLog[ 1 ] := 'AUTENTICAR'
	aParLog[ 2 ] := 'RNAUTENTICAR [input]'
	aParLog[ 3 ] := VarInfo( '::aURLParms', aPar, ,.F., .F. ) + CRLF + cStack
	aParLog[ 4 ] := 'PARAMETROS RECEBIDOS DO SISTEMA EXTERNO.'
	aParLog[ 5 ] := U_rnGetNow()
	aParLog[ 6 ] := U_rnGetNow()
	aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
	
	U_rnConout(VarInfo( 'aParLog', aParLog, ,.F., .F. ))
		
	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif
	
	lLigaLog := GetMv( cLigaLog, .F. )

	If lLigaLog
		// Antes de processar gerar log da requisição recebida.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	// Tentativa de autenticar o usuário e senha.
	lRet := procAutent( aPar, @cReturn, @aRet, @cStack, cThread )
	
	If lRet
		// Autenticação bem sucedida.
		MsgAlert( cReturn, 'TOTVS' )
	Else
		// Autenticação mal sucedida.
		MsgAlert( '{"codigo": ' + aRet[ 1 ] + ',"menssagem": "' + aRet[ 2 ] +'" }', 'TOTVS' )
	Endif
	
	aParLog[ 2 ] := 'RNAUTENTICAR [output]'
	aParLog[ 3 ] := SubStr( aParLog[ 3 ], 1, Len( AllTrim( aParLog[ 3 ] ) )-1 ) + CRLF + cStack
	aParLog[ 4 ] := aRet[ 1 ] + ' - ' + aRet[ 2 ] + ' - ' + cReturn 
	aParLog[ 6 ] := U_rnGetNow()
	aParLog[ 7 ] := CValToChar( Seconds() - nTimeIni )
		
	U_rnConout(VarInfo( 'aParLog', aParLog, ,.F., .F. ))

	If lLigaLog
		// Após processar gerar log da requisição entregue.
		StartJob( 'U_rnPutLog', cEnvSrv, .F., aParLog, .T. )
	Endif
	
	DelClassIntf()
Return