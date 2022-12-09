#include "PROTHEUS.CH"

/*
---------------------------------------------------------------------------
| Rotina    | UPDSDK04    | Autor | Gustavo Prudente | Data | 17.04.2015  |
|-------------------------------------------------------------------------|
| Descricao | Cria dicionario para utilizacao na rotina de atendimentos   |
|           | no Service Desk.                                            |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function UPDSDK04

Local cModulo := "TMK"
Local bPrepar := { || UPDSDK04Ini() }
Local nVersao := 1.0

Private aSX3  := {}
Private aSXB  := {}
Private aHelp := {}

NGCriaUpd( cModulo, bPrepar, nVersao )

Return


/*
---------------------------------------------------------------------------
| Rotina    | UPDSDK04Ini | Autor | Gustavo Prudente | Data | 17.04.2015  |
|-------------------------------------------------------------------------|
| Descricao | Cria dicionario para utilizacao na rotina de atendimentos   |
|           | do modulo Service-Desk.                                     |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function UPDSDK04Ini()

Local cLog := ""

// ADE - Atendimentos Service-Desk                  
AAdd( aSX3, {	"ADE", "", "ADE_XSTOPE", "C", 1, 0, "Status Oper.", "Status Oper.", "Status Oper.", ;
				"Status Oper. x Atend.", "Status Oper. x Atend.", "Status Oper. x Atend.", ;
				"9","","€€€€€€€€€€€€€€ ",'"2"',"", 1,"þÀ","","","U","N","A","R", ;
				"","","1=Atribuido;2=Não Atribuido","","","","","","","9","","","","","","","","" } )

AAdd( aHelp, { "ADE_XSTOPE" , "Status Oper. x Atend." } )

cLog += "(SX3) Tabela ADE - Novo campo ADE_XSTOPE" + CRLF + CRLF
cLog += "(HELP) Tabela ADE - Novo help do campo ADE_XSTOPE"

NGUpdObserv( cLog )

Return( .T. )