#INCLUDE "rwmake.ch"
/*
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  03/10/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Atualiza as pastas                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
*/
User Function PrXX()
tk273desconto("NF_DESCONTO",10)
_nPosDSC := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRDESC"})
_nqtd    := acols[n,_nPosDSC]  
tk273desconto("NF_DESCONTO",00)
	
RETURN(_nqtd)
