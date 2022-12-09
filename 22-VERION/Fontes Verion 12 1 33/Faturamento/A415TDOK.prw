
#include "Protheus.ch"
#include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A415TDOK  �Autor  �Fernando Macieira   � Data � 14/Mar/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para tratar a Condicao de Pagamento, no   ���
���          � Orcamento, NEGOCIADA (TIPO 9).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Verion                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A415TDOK()

Local lRetorno, cCondPag, cTpCondPag, nParc1, dParc1

lRetorno   := .t.
nParc1     := M->CJ_PARC1
dParc1     := M->CJ_DATA1
cCondPag   := M->CJ_CONDPAG
cTpCondPag := Posicione("SE4",1,xFilial("SCJ")+cCondPag,"E4_TIPO")

If cTpCondPag == "9"
	Iif(nParc1<=0,Processa({||msgStop("Condi��o de Pagamento Tipo 9. Informe o Valor na Parcela!","Aten��o"),lRetorno:=.f.}),)
	Iif(Empty(dParc1),Processa({||msgStop("Condi��o de Pagamento Tipo 9. Informe a Data de Vencimento!"),lRetorno:=.f.}),)
EndIf

Return lRetorno
