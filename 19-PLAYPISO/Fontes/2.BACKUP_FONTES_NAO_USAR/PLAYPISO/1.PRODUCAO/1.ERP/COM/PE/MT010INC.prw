/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Ponto de  �MT010INC  �Autor  �Cosme da Silva Nunes   �Data  �07/08/2008���
���Entrada   �          �       �                       �      |          ���
�������������������������������������������������������������������������Ĵ��
���Programa  �MATA010                                                     ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Apos a inclusao do produto.                                 ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao�Chamado apos a altera�ao de um produto no SB1.              ���
���          �Nem confirma nem cancela a opera�ao, so usado para          ���
���          �acrescentar dados.                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�UPAR do tipo X.                                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �URET do tipo X.                                             ���
�������������������������������������������������������������������������Ĵ��
���Observac. �                                                            ���
�������������������������������������������������������������������������Ĵ��
���           Atualizacoes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���	     	   |          |	                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT010INC()

// Variaveis da Funcao de Controle GetArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}

// Defina aqui a chamada dos Aliases para o GetArea
U_CtrlArea(1,@_aArea,@_aAlias,{"SB1","ZA3"}) // GetArea

If SB1->B1_CUSTD > 0

	RecLock("SB1",.F.)
	SB1->B1_UPRC := SB1->B1_CUSTD
	SB1->B1_PRV1 := SB1->B1_CUSTD
	MsUnlock()

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

U_CtrlArea(2,_aArea,_aAlias) // RestArea

Return()