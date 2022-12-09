#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �vldxokeng   Autor � TOTALIT AP6 IDE    � Data �  30/09/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida se o produto foi liberado pela engenharia.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CARMAR - Abertura da Ordem de Produ��o                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function vldlfiscal(cproduto)


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _xAlias := GetArea()
Local _lRet := .T.
Local _VlEmp := GetNewPar("ES_VALEMP","02")
Local _cParAtiv := GetNewPar("ES_VALPROD",.T.)

DbSelectArea("SB1")

If _cParAtiv .And. Alltrim(cEmpAnt)$ _VlEmp
	
	If Alltrim(cModulo) $ "EST/PCP"     
		If SB1->(FieldPos("B1_XOKENGE")) > 0
			SB1->(DbSeek(xFilial("SB1")+cproduto))
			If Alltrim(SB1->B1_XOKENGE) != "1"
				MsgAlert("PRODUTO N�O LIBERADO PARA MOVIMENTA��O, POR FAVOR VERIFIQUE COM A ENGENHARIA RESPONSAVEL PELO CADASTRO!!!",ReadVar())
				_lRet := .F.
			EndIf
		EndIf
	Endif
	
	If Alltrim(cModulo) $ "COM" 
		If SB1->(FieldPos("B1_XOKSUPR")) > 0
			SB1->(DbSeek(xFilial("SB1")+cproduto))
			If  Alltrim(SB1->B1_XOKSUPR) != "1"
				MsgAlert("PRODUTO N�O LIBERADO PARA MOVIMENTA��O, POR FAVOR VERIFIQUE COM A AREA FISCAL RESPONSAVEL PELO CADASTRO!!!",ReadVar())
				_lRet := .F.
			EndIf
		EndIf
	Endif
	
EndIf

RestArea(_xAlias)

Return(_lRet)
