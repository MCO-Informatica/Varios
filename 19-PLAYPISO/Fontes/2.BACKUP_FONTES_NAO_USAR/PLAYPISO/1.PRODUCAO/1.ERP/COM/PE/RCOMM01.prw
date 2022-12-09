#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³RCOMM01   ³Autor  ³Cosme da Silva Nunes   ³Data  ³06/08/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Programa p/ construcao da tela de checkup do custo standard ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Gestao de Projetos                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCOMM01(ucProduto,unCuStd,ucNovCS)

// Variaveis Locais da Funcao
Local cEdit1	 := ucProduto
Local ucDescProd := Posicione("SB1",1,xFilial("SB1")+cEdit1,"B1_DESC")
Local nEdit2	 := unCuStd
Local nEdit3	 := ucNovCS
Local oEdit1
Local oEdit2
Local oEdit3

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal

// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        

DEFINE MSDIALOG _oDlg TITLE "Checkup do Custo Standard" FROM U_C(204),U_C(192) TO U_C(322),U_C(531) PIXEL
	// Cria as Groups do Sistema
	@ U_C(020),U_C(008) TO U_C(038),U_C(080) LABEL " Custo Standard Atual " PIXEL OF _oDlg
	@ U_C(020),U_C(089) TO U_C(038),U_C(161) LABEL " Novo Custo standard " PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ U_C(006),U_C(008) Say OemToansi("Produto: ")+OemToansi(AllTrim(cEdit1))+"-"+OemToansi(AllTrim(ucDescProd)) Size U_C(100),U_C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	//@ U_C(004),U_C(036) MsGet oEdit1 Var cEdit1 Size U_C(124),U_C(009) COLOR CLR_BLACK PIXEL OF _oDlg

	@ U_C(026),U_C(014) MsGet oEdit2 Var nEdit2 Size U_C(060),U_C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@R 999,999,999.99"
	@ U_C(026),U_C(095) MsGet oEdit3 Var nEdit3 Size U_C(060),U_C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@R 999,999,999.99"   

	@ U_C(045),U_C(080) Button "Ok" Size U_C(037),U_C(012) PIXEL OF _oDlg 	Action (U_RCOMM02(cEdit1,nEdit2,nEdit3),_oDlg:End())
	@ U_C(045),U_C(123) Button "Cancela" Size U_C(037),U_C(012) PIXEL OF _oDlg 	Action (_oDlg:End())

ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)