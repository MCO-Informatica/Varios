#INCLUDE "rwmake.ch"
/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘�
臼�Programa  �NOVO2     � Autor � AP6 IDE            � Data �  03/10/05   艮�
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Descricao � Atualiza as pastas                                         艮�
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Uso       � AP6 IDE                                                    艮�
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識�
*/
User Function PrXX()
tk273desconto("NF_DESCONTO",10)
_nPosDSC := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRDESC"})
_nqtd    := acols[n,_nPosDSC]  
tk273desconto("NF_DESCONTO",00)
	
RETURN(_nqtd)
