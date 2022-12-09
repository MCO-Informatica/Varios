#Include 'Protheus.ch'
#include "rwmake.ch"

User Function filtroSZA()
	Local aGetArea := GetArea()
	Local oBrowCons
	Local aMat:={}
	Local lOpc:=.F.
	Local aInd:={}
	
	SZA->(DbClearFilter())
	 
	Aadd(aMat,{"ZA_ID" 		, "ID"					, "@!" , "C", 06, 0})
	Aadd(aMat,{"ZA_TIPO" 	, "Tipo"				, "@!" , "C", 02, 0})
	Aadd(aMat,{"ZA_EQUIP" 	, "Equipamento/Servico"	, "@!" , "C", 40, 0})
	
	cCondicao:= "SZA->ZA_TIPO==M->CTD_XTIPO "
	bFiltraBrw := {|| FilBrowse("SZA",@aInd,@cCondicao) }
	Eval(bFiltraBrw)
	
	
	@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Padronizacao Item Conta "
	@ 006, 005 TO 190, 370 BROWSE "SZA" FIELDS aMat OBJECT oBrowCons
	
	@ 200, 120 BUTTON "_Pesq Equipamento" SIZE 60, 13 ACTION PesqCodSZA()
	//@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomCTT()
	@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
	@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)
	
	oDlgPrd:lCentered := .t.
	oDlgPrd:Activate()


Return lOpc

Static Function PesqCodSZA()

Local cCondicao:=''
Local cGet:=Space(06)
Local aInd:={}
 
DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa Equipamento/Servico:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
SZA->(dbSetOrder(1))
SZA->(dbSeek(xFilial("SZA")+cGet))

Endif


return

