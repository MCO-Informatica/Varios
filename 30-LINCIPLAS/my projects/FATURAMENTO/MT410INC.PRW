#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410INC  ºAutor  ³Sidney Oliveira     º Data ³  02/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se contem a chave da NF-e de origem na inclusao do º±±
±±º          ³documento de devolucao                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Linciplas                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT410INC()

Private _aArea := GetArea()
Private _lRet  := .T.
Private aCOLS  := {}

//If Empty( aNfeDanfe[ 13 ] ) .And. AllTrim( cEspecie ) $ "SPED_CTE" 
DbSelectArea("SC6")
If (SC6->C6_NFORI) 	<>  "         "
	Alert( 'Deve ser informada a Chave da NFE' )
	nPosDoc		:= aScan(aHeader,{ |x| AllTrim(x[2]) == 'C6_NFORI'} )
	nPosSeri	:= aScan(aHeader,{ |x| AllTrim(x[2]) == 'C6_SERIORI'} ) 

   	For I:= 1 To Len(aCols)
		u_CHKCHV1(aCols[I,nPosDoc],aCols[I,nPosSeri])
	Next I
	
Endif

Return



User Function CHKCHV1(cDocOri, cSerieOri)

//+----------------------------------------------------------------------------

//| Declarações das varáveis

//+----------------------------------------------------------------------------

Local oFld    := Nil
Local dData   := Ctod(Space(8))
Local cChave   := Space(44)
Local cCombo  := Space(10)
Local cViaF3  := Space(10)
Local lChk    := .F.
Private oDlg    := Nil
//+----------------------------------------------------------------------------

//| Definição da janela e seus conteúdos

//+----------------------------------------------------------------------------

DEFINE MSDIALOG oDlg TITLE "Chave da NF-e de Origem Vazia" FROM 0,0 TO 200,552 OF oDlg PIXEL

@ 06,06 TO 46,271 LABEL "Digite a Chave NF-e Valida" OF oDlg PIXEL
@ 15, 15 Say   "Nota Fiscal/Serie: "+cDocOri+" / "+cSerieOri
@ 20, 15 SAY   "Chave NF-e" SIZE 45,8 PIXEL OF oDlg
@ 25, 15 MSGET cChave PICTURE "@!" WHEN .T. VALID chave(cChave) SIZE 80,10 PIXEL OF oDlg

//+----------------------------------------------------------------------------

//| Botoes da MSDialog

//+----------------------------------------------------------------------------

@ 080,230 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION PrepSair(1)
//@ 093,235 BUTTON "&Ok"       SIZE 36,16 PIXEL ACTION oDlg:End()
//@ 113,235 BUTTON "&Cancelar" SIZE 36,16 PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER

If lRet
	RecLock("SF1",.F.)
	SF1->F1_CHVNFE:= cChave
	SF1->(MsUnLock())
	
	DbSelectArea("SFT")
	DbSetOrder(4)
	If DbSeek(xFilial("SFT")+"E"+cA100For+cLoja+cDocOri+cSerieOri) // ACRESCENTADO O IF QUE VERIFICA A EXISTENCIA DA NOTA FISCAL
		While !(EoF()).And. SFT->FT_NFISCAL+SFT->FT_SERIE == cNFiscal+cSerie .And. SFT->FT_CLIEFOR+SFT->FT_LOJA == cA100For+cLoja
			RecLock("SFT",.F.)
			SFT->FT_CHVNFE:= cChave
			SFT->(MsUnLock())
			SFT->(DbSkip())
		EndDo
	Else
		Alert("Nota Fiscal não Existe") // ACRESCENTADO A MENSAGEM EM CASO NÃO EXISTA A NOTA FISCAL
	EndIf	
	DbSelectArea("SF3")
	DbSetOrder(5)
	If DbSeek(xFilial("SF3")+cSerieOri+cDocOri+cA100For+cLoja)
		RecLock("SF3",.F.)
		SF3->F3_CHVNFE:= cChave
		SF3->(MsUnLock())
	EndIf
EndIf

Return

Static Function PrepSair (nOpc)

Public lRet := .T.

If nOpc == 1
	lRet := .T.
	Close(oDlg)
Else
	lRet := .F.
EndIf

Return lRet

Static Function CHAVE (cChave)

If Empty(ALLTRIM(cChave))
	Alert("CHAVE NÃO PODE SER EM BRANCO")
	lRet1 := .F.
Else
	lRet1 := .T.
EndIf

Return lRet1
