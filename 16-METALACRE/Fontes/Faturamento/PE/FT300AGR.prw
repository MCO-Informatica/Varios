#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
#INCLUDE "FWMVCDEF.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FT300AGR   �Autor  � Luiz Alberto     � Data �  29/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE executado ANTES da Gravacao da Oportunidade de Vendas   ���
���          � tratar status Encerrado na Alteracao					      ���
�������������������������������������������������������������������������͹��
���OBS       � Antigo A410EXC                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FT300AGR()                                                 
Local aArea := GetArea()
Local oModel := PARAMIXB[1]
Local oMdlAD1 := oModel:GetModel("AD1MASTER")
Local nOperation := oModel:GetOperation()
Local lRet := .T.


If nOperation == MODEL_OPERATION_UPDATE
	If M->AD1_STATUS == '9' .And. Empty(M->AD1_FIDEL)	// Status de Encerramento
		MsgStop("Aten��o Ap�s Encerramento de Oportunidades � Necess�rio o Prenchimento do Campo Fidelidade ! - Verifique !!!")
		RestArea(aArea)
		Return .f.
	Endif                     
	M->AD1_COPIA	:=	'N'
Endif

RestArea(aArea)
Return .t.



