#Include 'Protheus.ch'
#include "rwmake.ch"

User Function FILTROIC()
Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}

Local cCondicao
Local bFiltraBrw
Local oDlgPrd
SC5->(DbClearFilter())
 
Aadd(aMat,{"C5_XXIC" , "Item Contábil" , "@!" , "C", 13, 0})
Aadd(aMat,{"C5_XXCLVL" , "Classe Valor" , "@!" , "C", 13, 0})


cCondicao:= "!EMPTY(SC5->C5_XXIC) "
bFiltraBrw := {|| FilBrowse("SC5",@aInd,@cCondicao) }
Eval(bFiltraBrw)


@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Item Contábil "
@ 006, 005 TO 190, 370 BROWSE "SC5" FIELDS aMat OBJECT oBrowCons

@ 200, 120 BUTTON "_Pesq Item Contábil" SIZE 60, 13 ACTION PesqCodSC5()
//@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomCTT()
@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

oDlgPrd:lCentered := .t.
oDlgPrd:Activate()



//U_CLASSEAPT()

Return lOpc

/*
Static Function PesqCodSC5()

Local cCondicao:=''
Local cGet:=Space(13)
Local aInd:={}

DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Item:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+cGet))

Endif
return

Static Function CLASSEAPT()

	Local aAreaSC5     := SC5->( GetArea() )

	Local cItemCC   := M->Z4_ITEMCTA
	Local cClasse
	
	msginfo ( cItemCC )
	
	dbSelectArea("SC5")
	
	_Retorno2 := Posicione("SC5",5,xFilial("SC5") + cItemCC,"SC5->C5_XXCLVL")
	
	msginfo ( cClasse )
	
	RestArea(aAreaSC5)

Return ( _Retorno2 )
*/



