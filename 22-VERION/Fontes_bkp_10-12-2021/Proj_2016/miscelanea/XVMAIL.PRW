#include "Protheus.ch"
#include "TopConn.ch"
#include "Colors.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XVMAIL    ºAutor  ³Fernando Macieira   º Data ³  14/Mar/07  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Interface para gerenciar o parametro MV_XVMAIL, utilizado  º±±
±±º          ³ para envio de email de Clientes Risco E.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Verion                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XVMAIL()

Local cVMail 
Local cParam    := "MV_XVMAIL"
Local cTitulo   := "Atualizacao do Parametro " + cParam
Local cTxt1     := ""
Local cTxt2     := ""
Local cTxt3     := ""
Local cTipo     := ""
Local cConteudo := ""
Local aAreaAtu  := GetArea()
Local aAreaSX6  := SX6->(GetArea())

dbSelectArea("SX6")
dbSetOrder(1)

// Checa e carrega as propriedades do parametro
If !msSeek(xFilial()+cParam)
	Aviso(cTitulo, "Parametro nao localizado. Contate o Adminstrador", {"&Ok"},, "Parametro " + cParam)
Else
	cTxt1     := X6_DESCRIC
	cTxt2     := X6_DESC1
	cTxt3     := X6_DESC2
	cTipo     := X6_TIPO
	cConteudo := X6_CONTEUDO
EndIf

// Cria a interface c/ usuario
Define msDialog oDlg Title cTitulo From 0,0 To 015,100 of oMainWnd
@ 001, 003 Say cTxt1 of oDlg
@ 002, 003 Say cTxt2 of oDlg
@ 003, 003 Say cTxt3 of oDlg
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
RecLock("SX6",.F.)
 X6_CONTEUDO := cConteudo
MsUnLock("SX6")
Return Nil