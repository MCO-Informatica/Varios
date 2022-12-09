#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTGRVEMP  � Autor � GENILSON LUCAS - MVG	� Data � 02/07/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para apagar a OP se necess�rio.			  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Shangri-la                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
PARAMIXB[1] Caracter C�digo do Produto que ser� gravado
PARAMIXB[2] Caracter Armaz�m selecionado para o produto
PARAMIXB[3] Num�rico Quantidade do produto a ser gravada no empenho
PARAMIXB[4] Num�rico Quantidade na Segunda Unidade de Medida
PARAMIXB[5] Caracter N�mero do lote que ser� gravado
PARAMIXB[6] Caracter N�mero do sub-lote que ser� gravado
PARAMIXB[7] Caracter Endere�o do produto
PARAMIXB[8] Caracter N�mero de S�rie do produto
PARAMIXB[9] Caracter N�mero da OP
PARAMIXB[10] Caracter Sequencia do produto na estrutura
PARAMIXB[11] Caracter N�mero do Pedido de Vendas
PARAMIXB[12] Caracter Item do Pedido de Vendas
PARAMIXB[13] Caracter Origem do Empenho
PARAMIXB[14] L�gico Variavel L�gica - Determina se a opera��o � um estorno
PARAMIXB[15] Vetor Vetor de campos que foi carregado na altera��o de empenhos
PARAMIXB[16] Num�rico Posi��o do elemento do vetor de campos
*/

User Function MTGRVEMP()

Local lGeraMSG  := .F.
Local cMP		:= ""

Public nOP		:= Substr(PARAMIXB[9],1,6)
Public nItem		:= Substr(PARAMIXB[9],7,2)
Public nSequen	:= Substr(PARAMIXB[9],9,3)
Public lApagaOP		:= .f.     

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
				
				If nSaldo < PARAMIXB[15][i][2]
					cMP			+= alltrim(PARAMIXB[15][i][1]) + ", "
					lGeraMSG	:= .T.
				Endif
			Next
			
			If lGeraMSG
				If MsgYesNo("N�o existe saldo suficiente da(s) MPs " + cMP +" para atender a OP " + nOP + nItem + nSequen + ". Deseja excluir a OP?")
					lApagaOP		:= .T.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
Return()
