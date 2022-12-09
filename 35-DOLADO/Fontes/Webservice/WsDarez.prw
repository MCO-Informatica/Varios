#include 'totvs.ch'
#include 'restful.ch'

WSRESTFUL DAREZ DESCRIPTION "Web Service de Integração com o Protheus e Sistemas legados da DAREZ" FORMAT APPLICATION_JSON

	WSDATA Rotina AS STRING
	WSDATA Id     AS STRING

	WSMETHOD POST            DESCRIPTION 'Adiciona dados a serem processados por rotinas específicas do protheus.' WSSYNTAX '/' PATH '/'
	WSMETHOD GET  ID         DESCRIPTION 'Consulta o status de um processamento enviado ao protheus.' WSSYNTAX '/' PATH '/'
	WSMETHOD GET  CLIENTE    DESCRIPTION 'Consulta os endereços de um cliente.' WSSYNTAX '/CLIENTE/' PATH '/CLIENTE/'
	WSMETHOD GET  PEDIDOFAT  DESCRIPTION 'Consulta se um pedido foi faturado.' WSSYNTAX '/PEDIDOFAT/' PATH '/PEDIDOFAT/'

END WSRESTFUL

/** 

POST 
Adiciona dados a serem processados por rotinas específicas do protheus.

**/

WSMETHOD POST WSRECEIVE Rotina WsService DAREZ

local cId   := FwUUIDV4(.F.)
local cBody := ''
local aCol  := {}
local nI    := 0
local lAchou := .f.
local cPEDSHPF := ""
local jPedido

Default ::Rotina := ''

::SetContentType( 'application/json' )

if Empty( ::Rotina )

	SetRestFault( 400, FWhttpEncode( 'É obrigatório indicar a rotina a ser processada.' ) )

	return .F.

end if

jPedido := jsonObject():new()
jPedido:fromJson( DecodeUtf8( ::GetContent() ) )
aCol := jPedido:GetNames()
for nI := 1 to len(aCol)
	if acol[nI] == "C5_XPEDSHP"
		lAchou := .t.
	endif
next
if lAchou
	cPEDSHPF := jPedido:C5_XPEDSHP
endif

RecLock( 'SZ1', .T. )

SZ1->Z1_FILIAL  := SM0->M0_CODFIL
SZ1->Z1_UUID    := cId
SZ1->Z1_DATAINC := Date()
SZ1->Z1_HORAINC := Time()
SZ1->Z1_ROTINA  := ::Rotina
SZ1->Z1_BODYMSG := DecodeUtf8( ::GetContent() )
SZ1->Z1_STATUS  := '0'
SZ1->Z1_PEDSHPF := cPEDSHPF

SZ1->( MsUnlock() )

if lower( AllTrim( ::GetHeader( 'Communication' ) ) ) == 'sync'

	U_pWsDarez( cId )

end if

if getPrcStat( cId, @cBody )

	::SetResponse( cBody )

else

	SetRestFault( 404, FWhttpEncode( 'id não localizado na base.' ) )

return .F.

end if

Return .T.

/** 

GET ID 
Consulta o status de um processamento enviado ao protheus.

**/

WSMETHOD GET ID WSRECEIVE Id WsService DAREZ

Local cBody := ''

::SetContentType( 'application/json' )

if getPrcStat( ::id, @cBody )

	::SetResponse( cBody )

else

	SetRestFault( 404, FWhttpEncode( 'id não localizado na base.' ) )

return .F.

end if

return .T.

/** 

GET CLINETE 
Consulta os endereços de um cliente.

**/

WSMETHOD GET CLIENTE WSRECEIVE Id WsService DAREZ

local oJsonGet := jsonObject():new()
local oJsonRet := jsonObject():new()
local aRet     := {}
local cCampo   := ''
local xValor   := nil
local nX       := 0
local cSeek    := xFilial( 'SA1' ) + ::id

DbSelectArea( 'SA1' )
SA1->( DbSetOrder( 1 ) )
SX3->( DbSetOrder( 2 ) )

::SetContentType( 'application/json' )

if DbSeek( cSeek ) .And. AllTrim( cSeek ) == AllTrim( SA1->( A1_FILIAL + A1_COD ) )

	oJsonGet:fromJson( DecodeUtf8( ::GetContent() ) )

	while AllTrim( SA1->A1_COD ) == AllTrim( ::id )

			aAdd( aRet, jsonObject():new() )

		for nX := 1 to len( oJsonGet )

			if SX3->( DbSeek( oJsonGet[ nX ] ) .And. AllTrim( oJsonGet[ nX ] ) == AllTrim( X3_CAMPO ) )

				cCampo := oJsonGet[ nX ]

				if SX3->X3_TIPO = 'C'

					xValor := AllTrim( SA1->( &(oJsonGet[ nX ] ) ) )

				else

					xValor := SA1->( &(oJsonGet[ nX ] ) )

				end if

				aTail( aRet )[ cCampo ] := xValor

			end if

		next nX

		SA1->( DbSkip() )

	end

	oJsonRet:set( aRet )

	::SetResponse( FWhttpEncode( oJsonRet:toJson() ) )

else

	SetRestFault( 404, FWhttpEncode( 'id não localizado na base.' ) )

return .F.

end

return .T.

/** 

GET CLINETE 
Consulta os endereços de um cliente.

**/
WSMETHOD GET PEDIDOFAT WSRECEIVE Id WsService DAREZ

	DbSelectArea( 'SC5' )
	SC5->( DBOrderNickname( 'PEDSHP' ) )
	
	::SetContentType( 'application/json' )

	if SC5->( DbSeek( ::id ) .And. allTrim( ::id ) == allTrim( C5_XPEDSHP ) )

		::SetResponse( if( Empty( SC5->C5_NOTA ), 'false', 'true' ) )

	else

		SetRestFault( 404, FWhttpEncode( 'id não localizado na base.' ) )

		return .F.

	end

return .T.


/*/{Protheus.doc} getPrcStat
Busca na tabela SZ1 os dados de um processamento e popula a variável
cBody recebida por referência
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 14/04/2022
@param cId, character, Id do processamento da busca
@param cBody, character, Variável recebida por referência a ser populado com os dados do processamento
@return logical, indica se o id do processamento foi localizado
/*/
static function getPrcStat( cId, cBody )

	local nX    := 0
	local oJson := jsonObject():New()
	local cseek := xFilial( 'SZ1' ) + cId

	DbSelectArea( 'SZ1' )
	SZ1->( DbSetOrder( 1 ) )

	if DbSeek( cSeek ) .And. AllTrim( cSeek ) == AllTrim( SZ1->( Z1_FILIAL + Z1_UUID ) )

		For nX := 1 To SZ1->( FCount() )

			SZ1->( oJson[FieldName( nX )] := &( FieldName( nX ) ) )

		Next nX

	else

		return .F.

	end if

	cBody := FWhttpEncode( oJson:toJson() )

return .T.
