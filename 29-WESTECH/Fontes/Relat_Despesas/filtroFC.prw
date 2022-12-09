#Include 'Protheus.ch'
#include "rwmake.ch"

User Function FILTROFC()
Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}

SRA->(DbClearFilter())
 
Aadd(aMat,{"RA_MAT" 	, "Matricula" 	, "@!" , "C", 06, 0})
Aadd(aMat,{"RA_NOME" 	, "Nome" 		, "@!" , "C", 30, 0})
Aadd(aMat,{"RA_CC"	 	, "Nome" 		, "@!" , "C", 13, 0})

cCondicao:= "!EMPTY(SRA->RA_MAT) "
bFiltraBrw := {|| FilBrowse("SRA",@aInd,@cCondicao) }
Eval(bFiltraBrw)


@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta de Colaboradores "
@ 006, 005 TO 190, 370 BROWSE "SRA" FIELDS aMat OBJECT oBrowCons

@ 200, 120 BUTTON "_Pesq Colaborador" SIZE 60, 13 ACTION PesqCodSRA()
//@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomCTT()
@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

oDlgPrd:lCentered := .t.
oDlgPrd:Activate()



//U_CLASSEAPT()

Return lOpc

Static Function PesqCodSRA()

Local cCondicao:=''
Local cGet:=Space(13)
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