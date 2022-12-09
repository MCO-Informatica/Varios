#Include 'Protheus.ch'
#include "rwmake.ch"

User Function filtroSB1()

	Local aGetArea := GetArea()
	Local oBrowCons
	Local aMat:={}
	Local lOpc:=.F.
	Local aInd:={}
	
	SB1->(DbClearFilter())
	
	Aadd(aMat,{"B1_COD" , "Codigo Produto" , "@!" , "C", 30, 0})
	Aadd(aMat,{"B1_DESC" , "Descricao" , "@!" , "C", 80, 0})
	Aadd(aMat,{"B1_UCOM" , "Ultima Compra" , "@!" , "D", 8, 0})
	
	cCondicao:= "! EMPTY(SB1->B1_UCOM) "
	bFiltraBrw := {|| FilBrowse("SB1",@aInd,@cCondicao) }
	Eval(bFiltraBrw)
	
	@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Produtos "
	@ 006, 005 TO 190, 370 BROWSE "SB1" FIELDS aMat OBJECT oBrowCons
	
	@ 200, 120 BUTTON "_Pesq Codigo" SIZE 60, 13 ACTION PesqCodSB1()
	@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomSB1()
	@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
	@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)
	
	oDlgPrd:lCentered := .t.
	oDlgPrd:Activate()
	
	//alert('Produto escolhido: '+SB1->B1_DESC)
	
	SB1->(DbClearFilter())


Return lOpc

Static Function PesqCodSB1()

Local cCondicao:=''
Local cGet:=Space(30)
Local aInd:={}
 
DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Codigo:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+cGet))

Endif


return


Static Function PesqNOMSB1()
Local cGet:=Space(80)

DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Nome:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
SB1->(DBSetOrder(1))
SB1->(DBseek(xFilial("SB1")+Rtrim(cGet)))
Endif


Return


