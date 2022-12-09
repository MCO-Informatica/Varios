#include "protheus.ch"
                        
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200DB1   �Autor  �Microsiga           � Data �  15/01/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �ponto de entrada na gravacao das despesas de cobranca       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Verion                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F200DB1()	

Local aArea	:= GetArea()
Local aArSa6:= SA6->(GetArea())
Local nRecSa6 := SA6->(Recno())                                                       
   
//���������������������������������������������������Ŀ
//�Tratamento para despesa de cobranca, que devera ser�
//�incluido em outra conta corrente                   �
//�(Cobranca Caucao Boston)                           �
//�����������������������������������������������������
If !Empty(SEE->EE_BCODESP) .and. !Empty(SEE->EE_AGDESP) .and. !Empty(SEE->EE_CCDESP)
	DbSelectArea("SA6")
	DbSetOrder(1)
	If MsSeek(xFilial("SA6")+SEE->EE_BCODESP+SEE->EE_AGDESP+SEE->EE_CCDESP)
	    RecLock("SE5",.F.)
	    SE5->E5_BANCO	:= SEE->EE_BCODESP
	    SE5->E5_AGENCIA := SEE->EE_AGDESP
	    SE5->E5_CONTA	:= SEE->EE_CCDESP
	    MsUnlock()	
		//�������������������������������������������������������������estaL�
		//�N�o ser� necess�rio alterar a AtuSalBco pois no FINA200 esta�
		//�rotina e chamada passando-se o banco, agencia e conta       �
		//�do proprio SE5                                              �
		//�������������������������������������������������������������estaL�	   	
	Else
		Aviso("Comunica��o banc�ria",;
		      "Banco designado para baixa das despesas de cobran�a inv�lido. Verifique cadastro Par�metros Bancos",;
		      {"&Ok"},,;
		      "Despesas Banc�rias")
	EndIf
EndIf                           
               
// Reposiciona no SA6 de origem
DbSelectArea("SA6")
DbgoTo(nRecSa6)

RestArea(aArSa6)
RestArea(aArea)

Return()