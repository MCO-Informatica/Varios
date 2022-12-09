//---------------------------------------------------------------------------
// Rotina | FeedBackAutenticar | Autor | Robson Gonçalves | Data | 19.04.2017
//---------------------------------------------------------------------------
// Descr. | WebService REST para integração com o sistema FeedBack.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------

#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL FeedBackAutenticar DESCRIPTION "Integração Protheus x Feedback"
	WSDATA cUser			AS STRING OPTIONAL
	WSDATA cPassWord	AS STRING OPTIONAL
	 
	WSMETHOD GET DESCRIPTION "Integração dos dados de colaboradores com o sistema de Feedback" WSSYNTAX "/colaborador || /colaborador/{id}"
END WSRESTFUL
 
WSMETHOD GET WSRECEIVE cUser, cPassWord WSSERVICE FeedBackAutenticar
	Local lRet := .T.
	 
	If Len(::aURLParms) > 0
		cToken := AuthUser( ::aURLParms[1], ::aURLParms[2] )
		If SubStr( cToken, 1, 3 ) $ '201|202|203'
			U_FBConout( 'FeedBackAutenticar | Tentativa de autenticar sem sucesso. Erro: ' + cToken ) 
			SetRestFault(Val( SubStr( cToken, 1, 3 ) ), SubStr( cToken, 4 ), .T.)
			lRet := .F.
		Else
			U_FBConout( 'FeedBackAutenticar | Autenticacao bem sucedida. Token: ' + cToken )
			::SetResponse('{"token":"' + cToken + '"}')
		Endif
	Else
		U_FBConout( 'FeedBackAutenticar | Parametro invalido. Erro: aURLParam.' )
		SetRestFault(101, 'Parametro invalido', .T.)
		lRet := .F.
	Endif
Return lRet

//---------------------------------------------------------------------------
// Rotina | AuthUser           | Autor | Robson Gonçalves | Data | 19.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para autenticar o usuário e senha.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function AuthUser( cLogin, cPassW )
	Local cRet := ''
	Local cToken := ''
	
	cLogin := Decode64( AllTrim( cLogin ) )
	cPassW := Decode64( AllTrim( cPassW ) )
	
	PswOrder( 2 )
	
	If	PswSeek( cLogin )
		If PswRet()[ 1, 17 ]
			cRet := '202Usuario com acesso bloqueado.'
		Else 
			If	PswName( cPassW )
				cRet := Encode64( U_GetToken() + cLogin )
			Else
				cRet := '203Senha invalida.'
			Endif
		Endif
	Else
		cRet := '201Usuario nao existe.'
	Endif
Return( cRet )

//---------------------------------------------------------------------------
// Rotina | GetToken           | Autor | Robson Gonçalves | Data | 19.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para retornar um Token baseado em data + hora.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
User Function GetToken()
Return( LTrim( Str( MsDate() - Ctod( '01/01/96','DDMMYYYY') ) ) + StrTran( Time(), ':', '' ) )

//---------------------------------------------------------------------------
// Rotina | FBConout           | Autor | Robson Gonçalves | Data | 19.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para imprimir uma string no console do Server.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
User Function FBConout( cString )
	Conout( '[' + Dtoc(MsDate()) + ' ' + Time() + '] ' + cString )
Return