#Include 'Protheus.ch'
#include "rwmake.ch"


User Function FILTROCTT()   

Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}
Local cCondicao
Local bFiltraBrw
Local oDlgPrd

CTT->(DbClearFilter())

Aadd(aMat,{"CTT_CUSTO" , "Centro de Custo" , "@!" , "C", 13, 0})
Aadd(aMat,{"CTT_DESC01" , "Descricao" , "@!" , "C", 40, 0})

cCondicao:= "CTT->CTT_CLASSE = '1' "
bFiltraBrw := {|| FilBrowse("CTT",@aInd,@cCondicao) }
Eval(bFiltraBrw)

@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Centro de Custo Sintético "
@ 006, 005 TO 190, 370 BROWSE "CTT" FIELDS aMat OBJECT oBrowCons

@ 200, 120 BUTTON "_Pesq Centro de Custo" SIZE 60, 13 ACTION PesqCodCTT()
//@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomCTT()
@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

oDlgPrd:lCentered := .t.
oDlgPrd:Activate()

//alert('Produto escolhido: '+SB1->B1_DESC)

CTT->(DbClearFilter())


Return lOpc

Static Function PesqCodCTT()

Local cCondicao:=''
Local cGet:=Space(13)
Local aInd:={}
 
DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Codigo:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
CTT->(dbSetOrder(1))
CTT->(dbSeek(xFilial("CTT")+cGet))

Endif
return


Static Function PesqNOMCTT()
Local cGet:=Space(40)

DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Nome:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
CTT->(DBSetOrder(1))
CTT->(DBseek(xFilial("CTT")+Rtrim(cGet)))
Endif


Return


