#Include 'Protheus.ch'
#include "rwmake.ch"


User Function FILCTDAP()

Local aGetArea := GetArea()
Local oBrowCons
Local aMat:={}
Local lOpc:=.F.
Local aInd:={}
Local cCondicao
Local bFiltraBrw
Local oDlgPrd

Private cGrupo	 := PSWRET()[1][12] //GRPRetName(UsrRetGRP()[1])
//msginfo (cGrupo)
CTD->(DbClearFilter())

Aadd(aMat,{"CTD_ITEM" , "Item Conta" , "@!" , "C", 13, 0})
Aadd(aMat,{"CTD_DESC01" , "Descricao" , "@!" , "C", 40, 0})

if cGrupo == "Contratos"
	cCondicao:= "! alltrim(CTD->CTD_ITEM) $ 'ADMINISTRACAO/ATIVO/ZZZZZZZZZZZZZ/XXXXXX/ESTOQUE' .AND. CTD_DTEXSF >= DDATABASE "
elseif Empty(cGrupo)
	cCondicao:= "!alltrim(CTD->CTD_ITEM) $ 'ATIVO/ZZZZZZZZZZZZZ/XXXXXX/ESTOQUE' .AND. CTD_DTEXSF >= DDATABASE "
else
	cCondicao:= "!alltrim(CTD->CTD_ITEM) $ 'ATIVO/ZZZZZZZZZZZZZ/XXXXXX/ESTOQUE' .AND. CTD_DTEXSF >= DDATABASE "
endif
bFiltraBrw := {|| FilBrowse("CTD",@aInd,@cCondicao) }
Eval(bFiltraBrw)

@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Item Conta "
@ 006, 005 TO 190, 370 BROWSE "CTD" FIELDS aMat OBJECT oBrowCons

@ 200, 120 BUTTON "_Pesq Item Conta" SIZE 60, 13 ACTION PesqCodCTD()
//@ 200, 190 BUTTON "_Pesq Nome" SIZE 60, 13 ACTION PesqNomCTT()
@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

oDlgPrd:lCentered := .t.
oDlgPrd:Activate()


CTD->(DbClearFilter())


Return lOpc

Static Function PesqCodCTD()

Local cCondicao:=''
Local cGet:=Space(13)
Local aInd:={}

DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Item Conta:" PIXEL OF oMainWnd
@ 8,11 TO 71,122
@ 13,15 SAY "Expressão: "
@ 13,50 GET cGet picture "@!" SIZE 60,30
@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

Activate MsDialog oDlgPesq Centered

If !Empty(cGet)
CTD->(dbSetOrder(1))
CTD->(dbSeek(xFilial("CTD")+cGet))

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
