#include "PROTHEUS.CH"
                               
/*
---------------------------------------------------------------------------
| Rotina    | TK510ATL     | Autor | Gustavo Prudente | Data | 11.09.2013 |
|-------------------------------------------------------------------------|
| Descricao | Permitir chamadas de rotinas customizadas por tecla de      |
|           | atalho na tela de atendimento do Service-Desk.              |
|-------------------------------------------------------------------------|
| Uso       | Tela de atendimento do modulo Service-Desk                  |
---------------------------------------------------------------------------
*/
User Function TK510ATL
                                                                   
// Chamada do banco de conhecimento
SetKey( VK_F4, { || } )
SetKey( VK_F4, { || XSDKBanco() } )

// Pesquisa de historico de atendimentos
SetKey( VK_F6, { || } )
SetKey( VK_F6, { || U_PESQHIST() } )

// Copia de protocolo de atendimento
SetKey( VK_F7, { || } )
SetKey( VK_F7, { || Iif( Type( "AROTINA" ) <> "U", u_XSDKCProt(), .T. ) } )

Return .T.


/*
---------------------------------------------------------------------------
| Rotina    | SDKBanco     | Autor | Gustavo Prudente | Data | 23.02.2015 |
|-------------------------------------------------------------------------|
| Descricao | Rotina para chamar o banco de conhecimento do atendimento   |
|-------------------------------------------------------------------------|
| Uso       | Tela de atendimento do modulo Service-Desk                  |
---------------------------------------------------------------------------
*/
Static Function XSDKBanco()

If ! IsInCallStack( "MSDOCUMENT" ) .And. Type( "AROTINA" ) <> "U"
	MsDocument( "ADE", ADE->( Recno() ), 3 )
EndIf

Return .T.