#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTGRVEMP  ³ Autor ³ GENILSON LUCAS - MVG	³ Data ³ 02/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para apagar a OP se necessário.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Shangri-la                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
PARAMIXB[1] Caracter Código do Produto que será gravado
PARAMIXB[2] Caracter Armazém selecionado para o produto
PARAMIXB[3] Numérico Quantidade do produto a ser gravada no empenho
PARAMIXB[4] Numérico Quantidade na Segunda Unidade de Medida
PARAMIXB[5] Caracter Número do lote que será gravado
PARAMIXB[6] Caracter Número do sub-lote que será gravado
PARAMIXB[7] Caracter Endereço do produto
PARAMIXB[8] Caracter Número de Série do produto
PARAMIXB[9] Caracter Número da OP
PARAMIXB[10] Caracter Sequencia do produto na estrutura
PARAMIXB[11] Caracter Número do Pedido de Vendas
PARAMIXB[12] Caracter Item do Pedido de Vendas
PARAMIXB[13] Caracter Origem do Empenho
PARAMIXB[14] Lógico Variavel Lógica - Determina se a operação é um estorno
PARAMIXB[15] Vetor Vetor de campos que foi carregado na alteração de empenhos
PARAMIXB[16] Numérico Posição do elemento do vetor de campos
*/

User Function MTGRVEMP()

Local lGeraMSG  := .F.
Local cMP		:= ""

Public nOP		:= Substr(PARAMIXB[9],1,6)
Public nItem		:= Substr(PARAMIXB[9],7,2)
Public nSequen	:= Substr(PARAMIXB[9],9,3)

IF FUNNAME() = "MATA650"
	If inclui
		If PARAMIXB[16] == len(PARAMIXB[15])
			for i:= 1 to len(PARAMIXB[15])
				
				nSaldo		:= 0
				
				//Carrego saldo atual do componente sem os empenhos
				DbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek(xFilial("SB2") + PARAMIXB[15][i][1])
				
				While !Eof() .and. PARAMIXB[15][i][1] = SB2->B2_COD
					
					nSaldo += SaldoSB2()
					
					DbSkip()
				End
				
				nSaldo += PARAMIXB[15][i][2]
				
				If nSaldo < PARAMIXB[15][i][2] .and. posicione("SB1",1,xFilial("SB1")+padr(PARAMIXB[15][i][1],tamSX3("B1_COD")[1]),"B1_TIPO")<>"MO"
					cMP			+= alltrim(PARAMIXB[15][i][1]) + ", "
					lGeraMSG	:= .T.
				Endif
			Next
			
			If lGeraMSG
				If MsgYesNo("Não existe saldo suficiente da(s) MPs " + cMP +" para atender a OP " + nOP + nItem + nSequen + ". Deseja excluir a OP?")
					aadd(aDelOP,{nOp,nItem,nSequen})
					lApagaOP		:= .T.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
Return()
