#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³RCOMM02   ³Autor  ³Cosme da Silva Nunes   ³Data  ³06/08/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Programa p/ atualizar o custo standard do produto e atuali- ³±±
±±³          |zar a tabela de historico de alteracao do custo standard    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Gestao de Projetos                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cosme da    |13/08/2008|Atualizacao dos campos ultimo preco de compra e³±±
±±³Silva Nunes |          |preco de venda simultaneamente a alteracao do  ³±±
±±³            |          |campo custo standard.                          ³±±
±±³            |          |                                               ³±±
±±³            |          |                                               ³±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCOMM02(cEdit1,nEdit2,nEdit3)
// Variaveis da Funcao de Controle e GertArea/RestArea

Local ucPro     := cEdit1
Local unCSAn	:= nEdit2
Local unCSAt	:= nEdit3
Local _aArea   		:= {}
Local _aAlias  		:= {}

// Defina aqui a chamada dos Aliases para o GetArea
U_CtrlArea(1,@_aArea,@_aAlias,{"SB1"}) // GetArea

If unCSAt > 0
	//Atualiza o cadatro de produtos
	dbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+ucPro)
		RecLock("SB1",.F.)
		SB1->B1_CUSTD := unCSAt
		SB1->B1_UPRC := unCSAt
		SB1->B1_PRV1 := unCSAt
		MsUnlock()
	EndIf

	//Atualiza o historico de atualizacao do custo standard do produto
	dbSelectArea("ZA3")
	RecLock("ZA3",.T.)
		ZA3->ZA3_PROD 	:= ucPro
		ZA3->ZA3_CSANT 	:= unCSAn
		ZA3->ZA3_CSATU 	:= unCSAt
		ZA3->ZA3_DATA  	:= dDataBase
		ZA3->ZA3_HORA  	:= SubStr(Time(),1,5)
		ZA3->ZA3_USUAR	:= SubStr(cUsuario,7,15)
		ZA3->ZA3_ORIG   := FunName()
	MsUnlock()
EndIf

U_CtrlArea(2,_aArea,_aAlias) // RestArea

Return()