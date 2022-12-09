#Include 'Protheus.ch'
#Include 'Protheus.ch'
#include "rwmake.ch"


User Function FltProp()   

Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}




	SZ9->(DbClearFilter())
	
	Aadd(aMat,{"Z9_NPROP" 	, "No. Proposta"	, "@!" , "C", 9, 0})
	Aadd(aMat,{"Z9_CONTR"	, "Contratante"		, "@!" , "C", 40, 0})
	Aadd(aMat,{"Z9_CLIFIN"	, "Cliente Final" 	, "@!" , "C", 40, 0})
	
	cCondicao:= "SZ9->Z9_STATUS = '7' "
	bFiltraBrw := {|| FilBrowse("SZ9",@aInd,@cCondicao) }
	Eval(bFiltraBrw)
	
	@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Proposta "
	@ 006, 005 TO 190, 370 BROWSE  "SZ9" FIELDS aMat OBJECT oBrowCons
	


SA1->(DbClearFilter())


@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)
@ 200, 120 BUTTON "_Pesq No. Proposta" SIZE 60, 13 ACTION PesqCod()
@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNome()


oDlgPrd:lCentered := .t.
oDlgPrd:Activate()


Return lOpc

Static Function PesqCod()

Local cCondicao:=''
Local cGet:=Space(9)
Local aInd:={}

 
DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por No. Proposta:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered


	If !Empty(cGet)
		SZ9->(dbSetOrder(1))
		SZ9->(dbSeek(xFilial("SZ9")+cGet))
	Endif



return


Static Function PesqNOME()
	Local cCondicao:=''
	Local cGet:=Space(40)
	Local aInd:={}

	 
	DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Contrante:" PIXEL OF oMainWnd
	@ 8,11 TO 71,122
	@ 13,15 SAY "Expressão: "
	@ 13,50 GET cGet picture "@!" SIZE 60,30
	@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()
	
	Activate MsDialog oDlgPesq Centered
	

		If !Empty(cGet)
			SA1->(dbSetOrder(2))
			SA1->(dbSeek(xFilial("SZ9")+cGet,.T.))
		Endif


Return


