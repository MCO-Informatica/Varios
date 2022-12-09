#Include 'Protheus.ch'
#include "rwmake.ch"

User Function CTT2_FILTRO()

Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}
Local cCustoInterval1 := val(M->Z4_XXCC) + 1000
Local cCustoInterval2 := str(cCustoInterval1)
Local cCondicao
Local bFiltraBrw
Local oDlgPrd

CTT->(DbClearFilter())

Aadd(aMat,{"CTT_CUSTO" , "Centro de Custo" , "@!" , "C", 13, 0})
Aadd(aMat,{"CTT_DESC01" , "Descricao" , "@!" , "C", 40, 0})

cCondicao:= "substr(CTT->CTT_CUSTO,1,1) = substr(M->Z4_XXCC,1,1) .AND. CTT->CTT_CLASSE = '2'  "
bFiltraBrw := {|| FilBrowse("CTT",@aInd,@cCondicao) }
Eval(bFiltraBrw)

@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Centro de Custo Analítico"
@ 006, 005 TO 190, 370 BROWSE "CTT" FIELDS aMat OBJECT oBrowCons

@ 200, 120 BUTTON "_Pesq Centro de Custo" SIZE 60, 13 ACTION PesqCodCTT()
//@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomCTT()
@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

oDlgPrd:lCentered := .t.
oDlgPrd:Activate()

CTT->(DbClearFilter())

Return lOpc

