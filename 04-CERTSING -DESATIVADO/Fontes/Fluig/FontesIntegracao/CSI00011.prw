#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"

#DEFINE nTIPO_REQUISICAO_GET  	1
#DEFINE nTIPO_REQUISICAO_POST 	2
#DEFINE nTIPO_REQUISICAO_PUT 	3
#DEFINE nTIPO_REQUISICAO_DELETE	4

user function CSI00011( nTipoRequi, params, token )
	local cRetorno := ""
	default nTipoRequi := 0
	if nTipoRequi == nTIPO_REQUISICAO_POST
		cRetorno := CSIPost( nTipoRequi, params, token )
	endif
return cRetorno

static function CSIPost( nTipoRequi, params, token )
	local cRetorno := ""
	local aHeader := {}

	default nTipoRequi := nTIPO_REQUISICAO_POST
	default params := ""
	default token  := ""
	
	aAdd( aHeader, 'Content-Type: application/json')
	aAdd( aHeader, 'Token : '+token )

	oRestClient := FWRest():New( "https://api-sbx.portaldeassinaturas.com.br/" )
	oRestClient:setPath( "/api/v2/document/upload" )
	oRestClient:SetPostParams( params )
	
	cRetorno := iif ( oRestClient:Post( @aHeader ), oRestClient:GetResult(), oRestClient:GetLastError() ) 
	conout( space(10)+u_JsonPrettify(cRetorno) )
Return( cRetorno )