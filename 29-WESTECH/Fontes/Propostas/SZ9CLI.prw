#Include 'Protheus.ch'
#include "rwmake.ch"


User Function SZ9CLI()   

Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}




	SA1->(DbClearFilter())
	
	Aadd(aMat,{"A1_COD" 	, "Codigo" 			, "@!" , "C", 10, 0})
	Aadd(aMat,{"A1_NOME"	, "Nome" 			, "@!" , "C", 40, 0})
	Aadd(aMat,{"A1_NREDUZ"	, "Nome Reduzido" 	, "@!" , "C", 40, 0})
	
	cCondicao:= "!EMPTY(SA1->A1_COD) "
	bFiltraBrw := {|| FilBrowse("SA1",@aInd,@cCondicao) }
	Eval(bFiltraBrw)
	
	@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Cliente "
	@ 006, 005 TO 190, 370 BROWSE  "SA1" FIELDS aMat OBJECT oBrowCons
	


SA1->(DbClearFilter())


@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)
@ 200, 120 BUTTON "_Pesq Codigo" SIZE 60, 13 ACTION PesqCod()
@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNome()


oDlgPrd:lCentered := .t.
oDlgPrd:Activate()


Return lOpc

Static Function PesqCod()

Local cCondicao:=''
Local cGet:=Space(10)
Local aInd:={}

 
DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Codigo:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered


	If !Empty(cGet)
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+cGet))
	Endif



return


Static Function PesqNOME()
	Local cCondicao:=''
	Local cGet:=Space(40)
	Local aInd:={}

	 
	DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Nome:" PIXEL OF oMainWnd
	@ 8,11 TO 71,122
	@ 13,15 SAY "Expressão: "
	@ 13,50 GET cGet picture "@!" SIZE 60,30
	@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()
	
	Activate MsDialog oDlgPesq Centered
	

		If !Empty(cGet)
			SA1->(dbSetOrder(2))
			SA1->(dbSeek(xFilial("SA1")+cGet,.T.))
		Endif


Return

