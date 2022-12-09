/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Ponto de  ³PMA200DEL ³Autor  ³Cosme da Silva Nunes   ³Data  ³14/08/2008³±±
±±³Entrada   ³          ³       ³                       ³      |          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa  ³PMSA410                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Validacao de exclusao                                       ³±±
±±³          ³Verifica possibilidade de exclusao de projetos com aponta-  ³±±
±±³          ³mentos.                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³Habilitacao do paramentro MV_PMSTEXC com "N"                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Variavel logica, validando (.T.) ou nao (.F.) a exclusao    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observac. ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualizacoes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PMA200DEL()

Local uaArea   	:= {}
Local uaAlias  	:= {}
//Local ucGetMV 	:= AllTrim(GETMV("MV_PMSTEXC"))
Local ulRet 	:= .T.
Local ulWhile		:= .T.

U_CtrlArea(1,@uaArea,@uaAlias,{"AFF","AFG","AFH","AFI","AFJ","AFK","AFL","AFM","AFN","AFO","AFQ","AFR","AFS","AFT","AFU","AJ7","AJ9","AJA","AJC","AJE"})

//If ucGetMV == "N"

	While ulWhile

		dbSelectArea("AFG")//PROJETO X SOLIC. DE COMPRAS
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFH")//PROJETO X SOLIC. AO ARMAZEM
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFI")//PROJETO X MOV. INTERNOS
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFJ")//EMPENHOS DO PROJETO
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFK")//PLANEJAMENTOS DO PROJETO
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFL")//PROJETO X CONTRATO DE PARCERIA
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFM")//PROJETO X ORDENS DE PRODUCAO
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFN")//PROJETO X N.F. ENTRADA
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFO")//PROJETO X LIBERACOES CQ
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFR")//PROJETO X DESPESAS FINANCEIRAS
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFS")//PROJETO X N.F. SAIDA
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFT")//PROJETO X RECEITAS FINANCEIRAS
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AFU")//APONTAMENTO (RECURSOS)
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AJ7")//PROJETO x PEDIDO DE COMPRA
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AJ9")//CONFIRMACOES X AUT. ENTREGA
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AJA")//CONFIRMACOES X LIB. PED.VENDAS
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AJC")//APONTAMENTO DIRETO
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		dbSelectArea("AJE")//Projetos x Mov.Bancaria
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
		
		ulWhile := .F.

	EndDo
/*
Else
		dbSelectArea("AFQ")//CONFIRMACOES (EDT)
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf

		dbSelectArea("AFF")//CONFIRMACOES
		dbSetOrder(1)
		If dbSeek(xFilial()+AF8->AF8_PROJET)
			ulWhile := ulRet := .F.
		EndIf
*/

//EndIf



If !ulRet
	MsgInfo("Projetos com apontamentos realizados. Exclusão desabilitada.")
EndIf

U_CtrlArea(2,uaArea,uaAlias)


Return(ulRet)