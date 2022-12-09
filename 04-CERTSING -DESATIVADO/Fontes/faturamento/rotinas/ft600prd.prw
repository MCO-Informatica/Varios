#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT600PRD  �Autor  �Opvs (David)        � Data �  16/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para Validacao do Produto informado na     ���
���          �Rotina de Inclusao de Propostas                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FT600PRD 
Local _lRet 	:= .T.
Local _cInsCli	:= ""
Local _cAlias	:= iif(M->ADY_ENTIDA == "1","SA1","SUS")

_cInsCli := Posicione(_cAlias,1,xFilial(_cAlias)+M->(ADY_CODIGO+ADY_LOJA),Right(_cAlias,2)+"_INSCR")

If Empty(_cInsCli)
	_lRet 	:= .F.	
	MsgStop("Inconformidade no Cadastro do "+iif(M->ADY_ENTIDA == "1","Cliente","Prospect")+" da Proposta. Por favor, revise o Cadastro do mesmo!!! ")
EndIf

Return(_lRet)