#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ BuscaFu Autor ³ Luiz Alberto ³ Data ³ 26/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo ³ Tela de Pesquisa Especifica Cadastro de Funcionarios ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso ³ ³±±
±± ³±±
±± ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function BUSCAFU()
Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}

SRA->(DbClearFilter())

Aadd(aMat,{"RA_MAT" , "Matricula" , "@!" , "C", 06, 0})
Aadd(aMat,{"RA_NOME" , "Nome Funcionario" , "@!" , "C", 40, 0})

cCondicao:= "SRA->RA_DEMISSA = CtoD('') "
bFiltraBrw := {|| FilBrowse("SRA",@aInd,@cCondicao) }
Eval(bFiltraBrw)

@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Funcionarios"
@ 006, 005 TO 190, 370 BROWSE "SRA" FIELDS aMat OBJECT oBrowCons

@ 200, 120 BUTTON "_Pesq Codigo" SIZE 60, 13 ACTION PesqCodSRA()
@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomSRA()
@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

oDlgPrd:lCentered := .t.
oDlgPrd:Activate()

//alert('Produto escolhido: '+SB1->B1_DESC)

SRA->(DbClearFilter())

Return lOpc

Static Function PesqCodSRA()

Local cCondicao:=''
Local cGet:=Space(06)
Local aInd:={}

DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Matricula:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
SRA->(dbSetOrder(1))
SRA->(dbSeek(xFilial("SRA")+cGet))

Endif
return


Static Function PesqNOMSRA()
Local cGet:=Space(40)

DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Nome:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
SRA->(DBSetOrder(3))
SRA->(DBseek(xFilial("SRA")+Rtrim(cGet)))
Endif

return

