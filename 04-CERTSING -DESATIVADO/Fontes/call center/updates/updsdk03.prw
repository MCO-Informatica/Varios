#include "PROTHEUS.CH"

/*
---------------------------------------------------------------------------
| Rotina    | UPDSDK03    | Autor | Gustavo Prudente | Data | 11.07.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria dicionario para utilizacao na rotina de pesquisa de    |
|           | historico de atendimentos (PESQHIST) - Service Desk         |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function UPDSDK03                

Local cModulo := "TMK"
Local bPrepar := { || UPDSDK03Ini() }
Local nVersao := 1.4

Private aSX3  := {}
Private aSXB  := {}
Private aHelp := {}

NGCriaUpd( cModulo, bPrepar, nVersao )

Return       


/*
---------------------------------------------------------------------------
| Rotina    | UPDSDK03Ini | Autor | Gustavo Prudente | Data | 11.07.2014  |
|-------------------------------------------------------------------------|
| Descricao | Cria dicionario para utilizacao na rotina de pesquisa de    |
|           | historico de atendimentos (PESQHIST) - Service Desk         |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function UPDSDK03Ini()

Local cLog := ""

// ADE - Atendimentos Service-Desk
AAdd( aSX3, {	"SU0", "","U0_XGRPHIS","C", 100, 0, "Grp Pesquisa", "Grp Pesquisa", "Grp Pesquisas", ;
				"Grupos Pesquisa Historico", "Grupos Pesquisa Historico", "Grupos Pesquisa Historico", ;
				"@!","","€€€€€€€€€€€€€€ ","","XGRPAT",1,"þÀ","","","U","N","A","R", ;
				"","","","","","","","","","9","","","","","","","","" } )
             
AAdd( aSX3, {	"SU0", "", "U0_XGRPBLQ", "C", 100, 0, "Blq Pesquisa", "Blq Pesquisa", "Blq Pesquisa", ;
				"Grupos Pesquisa Historico" ,"Grupos Pesquisa Historico", "Grupos Pesquisa Historico", ;
				"@!","","€€€€€€€€€€€€€€ ","","XGRPAT",1,"þÀ","","","U","N","A","R", ;
				"","","","","","","","","","9","","","","","","","","" } )

AAdd( aSX3, {	"SU0", "", "U0_XASSAUT", "C", 1, 0, "Assume Aut.?", "Assume Aut.?", "Assume Aut.?", ;
				"Assume autom. atendimento", "Assume autom. atendimento", "Assume autom. atendimento", ;
				"@!","","€€€€€€€€€€€€€€ ",'"2"',"", 1,"þÀ","","","U","N","A","R", ;
				"","","1=Sim; 2=Nao","","","","","","","9","","","","","","","","" } )

AAdd( aSX3, {	"SU0", "", "U0_XEXBGAR", "C", 1, 0, "Exibe GAR ?", "Exibe GAR ?", "Exibe GAR ?", ;
				"Exibir dados do pedido GAR", "Exibir dados do pedido GAR", "Exibir dados do pedido GAR", ;
				"@!","","€€€€€€€€€€€€€€ ",'"1"',"", 1,"þÀ","","","U","N","A","R", ;
				"","","1=Sim; 2=Nao","","","","","","","9","","","","","","","","" } )

AAdd( aSX3, {	"SU0", "", "U0_XCONOCO", "C", 1, 0, "Cons.Ocor.?", "Cons.Ocor.?", "Cons.Ocor.?", ;
				"Consulta Assuntos x Ocor.", "Consulta Assuntos x Ocor.", "Consulta Assuntos x Ocor.", ;
				"@!","","€€€€€€€€€€€€€€ ",'"2"',"", 1,"þÀ","","","U","N","A","R", ;
				"","","1=Sim; 2=Nao","","","","","","","9","","","","","","","","" } )

AAdd( aSX3, {	"SU0", "", "U0_XMAILAD", "C", 1, 0, "Email Adic.?", "Email Adic.?", "Email Adic.?", ;
				"Exibe email adicional-WF", "Exibe email adicional-WF", "Exibe email adicional-WF", ;
				"@!","","€€€€€€€€€€€€€€ ",'"1"',"", 1,"þÀ","","","U","N","A","R", ;
				"","","1=Sim; 2=Nao","","","","","","","9","","","","","","","","" } )

AAdd( aHelp, { "U0_XGRPHIS" , "Grupos Pesquisa Historico."	} )
AAdd( aHelp, { "U0_XGRPBLQ" , "Grupos Bloqueados Pesquisa." } )
AAdd( aHelp, { "U0_XASSAUT" , "Assume o atendimento automaticamente ao alterar." } )
AAdd( aHelp, { "U0_XEXBGAR" , "Exibir dados ao informar o pedido GAR." } )
AAdd( aHelp, { "U0_XCONOCO" , "Consulta Assuntos x Ocorrências" } )
AAdd( aHelp, { "U0_XMAILAD" , "Exibe e-mail adicional (CC) no workflow." } )

cLog := "(SX3) Tabela SU0 - Novo campo U0_XGRPHIS" + CRLF
cLog += "(SX3) Tabela SU0 - Novo campo U0_XGRPBLQ" + CRLF  
cLog += "(SX3) Tabela SU0 - Novo campo U0_XASSAUT" + CRLF
cLog += "(SX3) Tabela SU0 - Novo campo U0_XEXBGAR" + CRLF 
cLog += "(SX3) Tabela SU0 - Novo campo U0_XCONOCO" + CRLF 
cLog += "(SX3) Tabela SU0 - Novo campo U0_XMAILAD" + CRLF + CRLF

cLog += "(HELP) Tabela SU0 - Novo help do campo U0_XGRPHIS" + CRLF
cLog += "(HELP) Tabela SU0 - Novo help do campo U0_XGRPBLQ" + CRLF
cLog += "(HELP) Tabela SU0 - Novo help do campo U0_XASSAUT" + CRLF
cLog += "(HELP) Tabela SU0 - Novo help do campo U0_XEXBGAR" + CRLF
cLog += "(HELP) Tabela SU0 - Novo help do campo U0_XCONOCO" + CRLF
cLog += "(HELP) Tabela SU0 - Novo help do campo U0_XMAILAD" + CRLF

NGUpdObserv( cLog )

Return( .T. )