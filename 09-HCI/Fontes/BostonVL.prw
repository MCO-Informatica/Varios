#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BOSTONVL  �Autor  �Bruna Sandri        � Data �  11/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calcula valor liquido do titulo para ser enviado pelo Cnab  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Option                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BostonVL(cOpcao)

Local nValAbat  := 0
Local nValor    := 0

If cOpcao == "1"  // Obtem o valor liquido do titulo   Banco Boston

nValAbat	:= SOMAABAT(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)  
cValor		:= STRZERO((SE1->E1_VALOR-nValAbat-SE1->E1_DECRESC+SE1->E1_ACRESC)*100,13)
 
 
EndIf

Return(cValor) 

