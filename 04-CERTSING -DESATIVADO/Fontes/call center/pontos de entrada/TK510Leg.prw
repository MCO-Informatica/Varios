#include "protheus.ch"

/*
-------------------------------------------------------------------------------
| Rotina     | TK510Leg     | Autor | Gustavo Prudente   | Data | 20.04.2015  |
|-----------------------------------------------------------------------------|
| Descricao  | Permite realizar alteracoes ou acrescentar novas legendas dos  |
|			 | atendimentos.                                                  |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
User Function TK510Leg

Local aCores := ParamIxb[ 1 ]

AAdd( aCores, { "CERTI_VERDE_ESCURO", "Reabertura de atendimento" } )

Return( aCores )