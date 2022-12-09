#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOSSONRO  �Autor  Thiago Queiroz       � Data �  02/09/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � FUN��O QUE CRIA O NOSSO NUMERO NO CAMPO E1_NUMBCO PARA     ���
���          � IMPRESS�O DO BOLETO DO BRADESCO 							  ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - LINCIPLAS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NOSSONRO

Private cRet := ""


IF EMPTY(SE1->E1_NUMBCO)
//	cRet := "00" + SUBSTR(NOSSONUM(),4,9)
	cRet := "00" + NOSSONUM()
ELSE
//	cRet := "00" + SUBSTR(SE1->E1_NUMBCO,4,9)
	cRet := "00" + SE1->E1_NUMBCO
ENDIF

Return(cRet)

