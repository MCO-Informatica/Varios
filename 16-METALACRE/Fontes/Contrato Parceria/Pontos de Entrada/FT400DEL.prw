#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FT400DEL | Autor � Luiz Alberto        � Data � 22/02/16 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  � Ponto de Entrada na Exclus�o do Contrato de Parceria
				para valida��o de apenas supervisores possam excluir
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                        ���
��                                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FT400DEL() 
Local lRet := .T. 
Local aArea 	:= 	GetArea()
Local cLibUser  :=	GetNewPar('MV_USLBCTR','000000*000001*000020*000033*000194*000012')

If !__cUserId$cLibUser
	MsgStop("Aten��o Usu�rio N�o Autorizado a Efetuar Exclus�o de Contratos de Parcerias !")
	lRet = .f.
Endif                  

RestArea(aArea)
Return ( lRet )