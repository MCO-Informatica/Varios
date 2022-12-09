#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OS010GRV	 �Autor  �Microsiga           � Data � 12/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na grava��o da tabela de pre�o			  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function OS010GRV()

Local aArea := GetArea()
Local nOpc	:= ParamixB[2]

//Atualiza��o da tabela de pre�o no cadastro do cliente
AtuTabPrc(DA0->DA0_YCODCL, DA0->DA0_YLJCLI, DA0->DA0_CODTAB, nOpc, (Alltrim(DA0->DA0_ATIVO) == '1') )

RestArea(aArea)	
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuTabPrc	 �Autor  �Microsiga           � Data � 12/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza tabela de pre�o no cadastro de clientes			  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function AtuTabPrc(cCodCli, cLojaCli, cCodTab, nOpc, lAtiva)

Local aArea := GetArea()

Default cCodCli		:= "" 
Default cLojaCli	:= "" 
Default cCodTab		:= "" 
Default nOpc		:= 1
Default lAtiva		:= .T.

DbSelectArea("SA1")
DbSetOrder(1)
If SA1->(DbSeek(xFilial("SA1")+cCodCli+cLojaCli ))
	If (nOpc == 3 .Or. nOpc == 4) .And. lAtiva //Inclus�o altera��o
		RecLock("SA1",.F.)
		SA1->A1_TABELA := cCodTab
		SA1->(MsUnLock())
	ElseIf (nOpc == 5 .Or. !lAtiva ) .And. Alltrim(SA1->A1_TABELA) == Alltrim(cCodTab)//Exlus�o
		RecLock("SA1",.F.)
		SA1->A1_TABELA := ""
		SA1->(MsUnLock())
	EndIf
EndIf
RestArea(aArea)
Return