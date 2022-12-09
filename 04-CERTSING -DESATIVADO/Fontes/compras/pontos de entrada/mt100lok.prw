#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100LOK  �Autor  �Henio Brasil        � Data �  07/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para tratar dados na linha da Nota Fiscal  ���
���          �de Entrada.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificadora Digital                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT100LOK()
/*
���������������������������������������������������������������������Ŀ
� Declaracao de Variaveis                                             �
�����������������������������������������������������������������������*/  
Local lRet		:= .t.       
Local aArea		:= GetArea()
Local aAreaCT1	:= CT1->(GetArea())

Local cMen		:= " Aten��o!! � preciso inserir C.Custo, Item Contabil e Classe de Valor para este item."
Local cCtaConta	:= aCols[n, (aScan(aHeader,{|x| AllTrim(x[2])=="D1_CONTA"}))] 
Local cCCusto	:= aCols[n, (aScan(aHeader,{|x| AllTrim(x[2])=="D1_CC"	}))]
Local cItemCta	:= aCols[n, (aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMCTA"}))]
Local cClasVlr	:= aCols[n, (aScan(aHeader,{|x| AllTrim(x[2])=="D1_CLVL"}))]

Local lVazioCC	:= If(Empty(cCCusto) .or. Empty(cItemCta) .or. Empty(cClasVlr), .t., .f.) 

/*             
���������������������������������������������������������������������Ŀ
� Pesquisa no Plano de Contas se a Conta e' obrigatoria               �
�����������������������������������������������������������������������*/ 
If lVazioCC           
	DbSelectArea("CT1")                        	// precisa ver esta funcao aqui, origem CT2_CCD 
 	If DbSeek(xFilial("CT1")+cCtaConta, .f.) ;	// .and. Ctb105CC(cCCusto, "1") 
  	   	.And. (CT1->CT1_CCOBRG=='1' .Or. CT1->CT1_ITOBRG=='1' .Or. CT1->CT1_CLOBRG=='1') 
		MsgAlert(cMen)           
		lRet:= .f.
	Endif 
EndIf
/*
���������������������������������������������������������������������Ŀ
� Volta os ambientes por conta da abertura de area do CT1             �
�����������������������������������������������������������������������*/ 
RestArea(aAreaCT1)
RestArea(aArea)
Return(lRet)