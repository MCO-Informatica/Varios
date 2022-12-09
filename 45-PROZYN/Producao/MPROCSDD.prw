#include 'protheus.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MPROCSDD �Autor  �Microsiga 	          � Data � 05/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada no processamento do bloqueio e desbloqueio ���
���          �do lote										    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MPROCSDD()

Local aArea 	:= GetArea()
Local lLibera	:= ParamixB[1]

If lLibera
	
	MsgRun( 'Atualizando saldo bloqueado...' , '', { ||U_PZCVA001(SDD->DD_PRODUTO, SDD->DD_PRODUTO,; 
															SDD->DD_LOCAL, SDD->DD_LOCAL, SDD->DD_LOTECTL,; 
															SDD->DD_LOTECTL, SDD->DD_NUMLOTE, SDD->DD_NUMLOTE ) } )	
EndIf

RestArea(aArea)	
Return