/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Ponto de  ³MT010ALT  ³Autor  ³Cosme da Silva Nunes   ³Data  ³07/08/2008³±±
±±³Entrada   ³          ³       ³                       ³      |          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa  ³MATA010                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Apos a alteracao do produto.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³Chamado apos a alteraçao de um produto no SB1.              ³±±
±±³          ³Nem confirma nem cancela a operaçao, so usado para          ³±±
±±³          ³acrescentar dados.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³UPAR do tipo X.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³URET do tipo X.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observac. ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualizacoes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³	     	   |          |	                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT010ALT()

// Variaveis da Funcao de Controle GetArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local unZA3_CSATU   := 0

// Defina aqui a chamada dos Aliases para o GetArea
U_CtrlArea(1,@_aArea,@_aAlias,{"SB1","ZA3"}) // GetArea

RecLock("SB1",.F.)
SB1->B1_UPRC := SB1->B1_CUSTD
SB1->B1_PRV1 := SB1->B1_CUSTD
MsUnlock()

dbSelectArea("ZA3")
ZA3->( DbSetOrder(1) )
If DbSeek(xFilial("ZA3")+SB1->B1_COD) //TEM QUE SER O ULTIMO***
	ZA3->( DbSeek(xFilial("ZA3")+(AllTrim(SB1->B1_COD)+"ZZZZZZZZZZZZZZZ")) ) //TEM QUE SER O ULTIMO***
	ZA3->(DbSkip(-1)) //TEM QUE SER O ULTIMO***
	unZA3_CSATU := ZA3->ZA3_CSATU
	If ZA3->ZA3_CSATU <> SB1->B1_CUSTD
		//Atualiza o historico de atualizacao do custo standard do produto
		RecLock("ZA3",.T.)
			ZA3_ZA3_FILIAL  := xFilial("SB1")
			ZA3->ZA3_PROD 	:= SB1->B1_COD
			ZA3->ZA3_CSANT 	:= unZA3_CSATU
			ZA3->ZA3_CSATU 	:= SB1->B1_CUSTD
			ZA3->ZA3_DATA  	:= dDataBase
			ZA3->ZA3_HORA  	:= SubStr(Time(),1,5)
			ZA3->ZA3_USUAR	:= SubStr(cUsuario,7,15)
			ZA3->ZA3_ORIG   := FunName()
		MsUnlock()
	EndIf
Else
	If SB1->B1_CUSTD > 0
		//Atualiza o historico de atualizacao do custo standard do produto
		dbSelectArea("ZA3")
		RecLock("ZA3",.T.)
			ZA3_ZA3_FILIAL  := xFilial("SB1")
			ZA3->ZA3_PROD 	:= SB1->B1_COD
			ZA3->ZA3_CSANT 	:= 0
			ZA3->ZA3_CSATU 	:= SB1->B1_CUSTD
			ZA3->ZA3_DATA  	:= dDataBase
			ZA3->ZA3_HORA  	:= SubStr(Time(),1,5)
			ZA3->ZA3_USUAR	:= SubStr(cUsuario,7,15)
			ZA3->ZA3_ORIG 	:= FunName()
		MsUnlock()
	EndIf
EndIf

U_CtrlArea(2,_aArea,_aAlias) // RestArea

Return()