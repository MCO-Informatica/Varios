
#include "Protheus.ch"
#include "TopConn.ch"
#include "Colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XVTS      ºAutor  ³Fernando Macieira   º Data ³  16/Mar/07  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Interface para gerenciar o parametro MV_XVTS, utilizado    º±±
±±º          ³ para preenchimento do campo B1_TS, pela regra definida.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Verion                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function XVTS()

Local cVMail 
Local cParam := "MV_XVTS"
Local cTitulo := "Atualizacao do Parametro " + cParam
Local cTxt1 := ""
Local cTxt2 := ""
Local cTxt3 := ""
Local cTipo := ""
Local cConteudo := ""
Local aAreaAtu := GetArea()
Local aAreaSX6 := SX6->(GetArea())

dbSelectArea("SX6")
dbSetOrder(1)

// Checa e carrega as propriedades do parametro
If !msSeek(xFilial()+cParam)
	Aviso(cTitulo, "Parametro nao localizado. Contate o Adminstrador", {"&Ok"},, "Parametro " + cParam)
Else
	cTxt1 := X6_DESCRIC
	cTxt2 := X6_DESC1
	cTxt3 := X6_DESC2
	cTipo := X6_TIPO
	cConteudo := AllTrim(X6_CONTEUDO)
EndIf

// Cria a interface c/ usuario
Define msDialog oDlg Title cTitulo From 0,0 To 015,050 of oMainWnd
@ 001, 003 Say cTxt1 of oDlg
@ 002, 003 Say cTxt2 of oDlg
@ 003, 003 Say cTxt3 of oDlg
//oLinha:=TGroup():New( 004, 003, 004, 025,,,,,.F., ) //@ 004, 003 to 004,35 
//oLinha:lvisible:=.f.
@ 004, 003 Say "-------------------------------------------------------------------"
@ 005, 003 Say "Informe o novo conteudo: " of oDlg
@ 005, 012 Get cConteudo Valid !Empty(cConteudo)

Define sButton oBut1 From 088,058 Type 1 Enable of oDlg Action {|| Atualiza(cConteudo), oDlg:End()}
Define sButton oBut2 From 088,108 Type 2 Enable of oDlg Action {|| oDlg:End()}
Activate msDialog oDlg Centered

// Restaura arquivos
RestArea(aAreaAtu)
RestArea(aAreaSX6)

//-----------------------------------
Static Function Atualiza(cConteudo)
//-----------------------------------

RecLock("SX6",.f.)
X6_CONTEUDO := cConteudo
msUnLock()

Return Nil

//-----------------------------------

Return Nil
