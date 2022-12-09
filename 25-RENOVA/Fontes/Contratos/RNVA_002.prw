#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO15    ºAutor  ³Microsiga           º Data ³  04/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  rotina permite efetuar filtros nas compras diretas e zerar ±±
±±º          ³  os saldos das compra diretas já utilizadas                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Renova Energia                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RNVA_002
Private cCadastro  := "Compra Direta"
Private cAlias 	   := "PA2"
Private aRotina    := { }
Private cUsrFilter := ""

AADD (aRotina, {"Pesquisar"     , "AxPesqui" ,0,1})
AADD (aRotina, {"Filtrar"       , "U_RNA002F",0,2})
AADD (aRotina, {"Visualizar"    , "U_RNA002" ,0,3})
AADD (aRotina, {"Alterar"       , "U_RNA002" ,0,4})
AADD (aRotina, {"Excluir"       , "U_RNA002" ,0,5})
AADD (aRotina, {"Zerar Valor"   , "U_RNA002X",0,6})
AADD (aRotina, {"Retornar Valor", "U_RNA002X",0,7})
AADD (aRotina, {"Update SX3"    , "U_RNA002U",0,7})

dbSelectArea("PA2")
dbSetOrder(1)
dbGoTop()

Set Filter to .T. // para desabilitar o botão padrão de filtro

mBrowse ( 6, 1,22 ,75 ,cAlias)

Return

User Function RNA002F(cAlias, nReg, nOpc)
Local cOldUsrFilter := cUsrFilter
Local oMbrowse      := GetMBrowse()

Set Filter To

cUsrFilter := BuildExpr("PA2")

If ! Empty(cUsrFilter)
	PA2->(dbGoBottom())
	Set Filter to &(cUsrFilter)
Else
	Set Filter to
Endif		

PA2->(dbGoTop())
oMbrowse:UpdateTopBot()
oMbrowse:GoBottom()
oMbrowse:GoTop()
oMbrowse:Refresh(.T.)
ProcessMessages()

Return

User Function RNA002X(cAlias, nReg, nOpc)

U_RNA002R(nOpc == 7)
Return

User Function RNA002R(lRetorna)
Local aSavAre := SaveArea1({"PA2"})
Local cSeek   := Nil
Local bFilter := {|| .T. }

If ! Empty(cUsrFilter)
	bFilter := &("{|| " + cUsrFilter + "}")
Else
	Alert("Opcao disponivel apenas com aplicação de filtro")
	Return
Endif	

dbSelectArea("PA2")
dbSeek(cSeek := xFilial("PA2"))

Do While ! Eof() .And. PA2->PA2_FILIAL == cSeek
	If Eval(bFilter)
		RecLock("PA2", .F.)
		If lRetorna
			PA2->PA2_SALDO := PA2->PA2_VALOR
		Else
			PA2->PA2_SALDO := 0
		Endif
	Endif
	dbSkip()
Enddo

If ! Empty(cUsrFilter)
	Set Filter to &(cUsrFilter)
Endif

RestArea1(aSavAre)

Return	

User Function RNA002(cAlias, nReg, nOpc)
/*
AADD (aRotina, {"Visualizar"    , "U_RNA002" ,0,3})
AADD (aRotina, {"Alterar"       , "U_RNA002" ,0,4})
AADD (aRotina, {"Excluir"       , "U_RNA002" ,0,5})
*/

If nOpc == 3
	AxVisual(cAlias, nReg, nOpc)
ElseIf nOpc == 4
	AxAltera(cAlias, nReg, nOpc)
ElseIf nOpc == 5
	AxDeleta(cAlias, nReg, nOpc)		
Endif

Return

User Function RNA002U(cAlias, nReg, nOpc)
Local aSavAre := SaveArea1({"PA2"})

dbSelectArea("SX3")
dbSetOrder(1)

dbSeek("PA2")
Do While ! Eof() .And. SX3->X3_ARQUIVO == "PA2"
	If ! "PA2_FILIAL" $ SX3->X3_CAMPO
		RecLock("SX3", .F.)
		SX3->X3_BROWSE := "S"
		MsUnlock()
	Endif
	If Alltrim(SX3->X3_CAMPO) == "PA2_CONTRA"
		RecLock("SX3", .F.)
		SX3->X3_VLDUSER := 'ExistCpo("CN9")'
		SX3->X3_F3      := "CN9"
		MsUnlock()
	Endif	
	dbSkip()
Enddo

RestArea1(aSavAre)	
