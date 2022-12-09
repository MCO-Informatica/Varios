#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RENREVAPROV    � Autor � WELLINGTON MENDES  � Data �  23/01/18   ���
�������������������������������������������������������������������������͹��
���Descricao � GATILHO NA REVIS�O PARA DEFINIR SE A MESMA VAI OU N�O PARA
APROVA��O
REGRA
CN9_APROV = 'BRANCO' - NAO VAI
CN9_APROV = 'GRUPO DE APROVA��O - VAI PARA APROVA��O                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RENREVAPROV(_cTipRev,_UnidReqs)

Local _RetGroup := ''
Local _TipoRev:= GETMV("MV_XAPROV")//Tipos de Revis�o que n�o tem necessidade de WorkFlow
Local _aArea   	:= GetArea()

IF 'REVCON'+_cTipRev $ _TipoRev .OR. 	M->CN9_ESPCTR == '2'
	_RetGroup:= '     ' //Sem grupo, n�o gera SCR para aprova��o por WF.
Else //Volta o Grupo de aprova��o da unidade requisitante. Foi feito dessa forma, pois o usuario pode digitar o tipo de revis�o errado e trocar sem sair da tela.
	DbSelectArea("SY3")
	DbSetOrder(1)
	SY3->(DbSeek(xFilial("SY3")+ Alltrim(_UnidReqs)))
	_RetGroup := SY3->Y3_GRAPROV
Endif
RestArea(_aArea)
Return(_RetGroup)

