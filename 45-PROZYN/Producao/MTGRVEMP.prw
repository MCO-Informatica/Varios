#include 'protheus.ch'
#include 'parmtype.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTGRVEMP �Autor  �Microsiga 	          � Data � 05/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada ap�s o bloqueio do lote					  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function MTGRVEMP()

Local aArea		:= GetArea()	
Local cProd		:= ParamixB[1]
Local cLocal	:= ParamixB[2]
Local cLote		:= ParamixB[5]
Local cSubLote	:= ParamixB[6]

//Atualiza��o do saldo bloqueado por lote
MsgRun( 'Atualizando saldo bloqueado...' , '', { || U_PZCVA001(cProd, cProd, cLocal, cLocal, cLote, cLote, cSubLote, cSubLote ) } )

RestArea(aArea)	
Return
