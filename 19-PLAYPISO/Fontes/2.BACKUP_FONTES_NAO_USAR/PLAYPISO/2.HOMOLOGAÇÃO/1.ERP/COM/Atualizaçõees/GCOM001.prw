#Include "PROTHEUS.CH"   
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GCOM001   ºAutor  ³Mauro Nagata        º Data ³  28/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Disponibilizar o campo F1_XOBSNF para que possa adicionar   º±±
±±º          ³informação na DANFE de entrada                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GCOM001()    
Local oObsAdic
Local oSay1   
//Private cObsAdic := SF1->F1_XOBSNF  - comentado pois a rotina sera tratada pelo campo SF1->F1_XOBSNF2     
Private c_texto := ''
Static oDlg


  DEFINE MSDIALOG oDlg TITLE "Observação Adicional" FROM 000, 000  TO 150, 900 COLORS 0, 16777215 PIXEL
  
   // @ 024, 026 MSGET oObsAdic VAR cObsAdic     SIZE 400, 015 OF oDlg PICTURE "@!" COLORS 0, 16777215 PIXEL  - comentado substituido pela linha abaixo LH Actual 28/04/2017
    @ 024, 026 GET c_texto MEMO SIZE 400, 015 COLORS 0, 16777215 PIXEL // incluido linha com variavel tipo MEMO LH ACTUAL 28/04/2017
    @ 055, 300 BUTTON oBt_Ok   PROMPT "Salvar" SIZE 050, 020 OF oDlg ACTION( Bt_Ok(),oDlg:End())    PIXEL MESSAGE "Salvando a Observação Adicional"
    @ 055, 378 BUTTON oBt_Canc PROMPT "Sair"   SIZE 050, 020 OF oDlg ACTION oDlg:End()               PIXEL MESSAGE "Saindo sem alterar a Observação Adicional"

  ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function Bt_ok()  

SF1->(RecLock("SF1",.F.))
//SF1->F1_XOBSNF := cObsAdic  comentado substituido pela linha abaixo LH ACTUAL 28/04/2017
SF1->F1_XOBSNF2 := c_texto 
SF1->(MsUnLock())
MsgBox("Observação Adicional gravada com Sucesso","Salvar","INFO")
Return.T.
