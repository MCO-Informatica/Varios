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
User Function A010TOK()
/*
lRet := .T.

cCodTipo := AllTrim(M->B1_TIPO)
cCodRet  := AllTrim(SubStr(M->B1_COD,3,15))

While SB1->(dbSeek(xfilial("SB1")+cCodTipo+cCodRet))
	cCodRet := Soma1(cCodRet)
	M->B1_COD := cCodRet
EndDo

If SX5->(dbSeek(xFilial("SX5")+"W0"+cCodTipo))

	RecLock("SX5",.F.)
	SX5->X5_DESCRI	:= cCodRet 
	SX5->X5_DESCSPA	:= cCodRet 
	SX5->X5_DESCENG	:= cCodRet 
	MsUnLock()

Else

	RecLock("SX5",.T.)
	SX5->X5_FILIAL	:= xFilial("SX5")
	SX5->X5_TABELA	:= "W0"
	SX5->X5_CHAVE	:= cCodTipo
	SX5->X5_DESCRI	:= cCodRet
	SX5->X5_DESCSPA	:= cCodRet 
	SX5->X5_DESCENG	:= cCodRet  
	MsUnlock()
	
EndIf	
                     
Return(lRet)