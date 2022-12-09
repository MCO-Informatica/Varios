#INCLUDE "PROTHEUS.CH"

/*
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RGOLDH01  � Autor � HEITOR XAROPE         � Data �12.04.2017���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Numera os produtos                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Especifico GOLD HAIR                                        ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RGOLDH01()
/*
cCodTipo := AllTrim(M->B1_TIPO)
cCodRet  := ""

If SX5->(dbSeek(xFilial("SX5")+"W0"+cCodTipo))
	cCodRet := Soma1( AllTrim(SX5->X5_DESCRI) )
Else
	RecLock("SX5",.T.)
	SX5->X5_FILIAL	:= xFilial("SX5")
	SX5->X5_TABELA	:= "W0"
	SX5->X5_CHAVE	:= cCodTipo
	SX5->X5_DESCRI	:= "0000" 
	SX5->X5_DESCSPA	:= "0000" 
	SX5->X5_DESCENG	:= "0000"
	
	cCodRet := "0001"
EndIf	
	
While SB1->(dbSeek(xfilial("SB1")+cCodTipo+cCodRet))
	cCodRet := Soma1(cCodRet)
EndDo
                     
Return(cCodTipo+cCodRet)