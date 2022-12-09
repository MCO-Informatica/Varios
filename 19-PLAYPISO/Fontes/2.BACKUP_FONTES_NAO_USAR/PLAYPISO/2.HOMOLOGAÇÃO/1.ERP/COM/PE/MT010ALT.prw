/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Ponto de  �MT010ALT  �Autor  �Cosme da Silva Nunes   �Data  �07/08/2008���
���Entrada   �          �       �                       �      |          ���
�������������������������������������������������������������������������Ĵ��
���Programa  �MATA010                                                     ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Apos a alteracao do produto.                                ���
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