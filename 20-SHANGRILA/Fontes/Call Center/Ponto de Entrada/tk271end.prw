#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"

//==========================================================================================================================================================
//Nelson Hammel - 14/09/11 - Ponto de entrada para gravar transportadora 

User Function TK271END()

xTransp:=M->UA_TRANSP
xRedesp:=M->UA_REDESP
xTpFret:=M->UA_TPFRETE
xTpRede:=M->UA_TPREDES
xTemRed:=M->UA_XTEMRED

_cAlias_  := Alias()
_nRec_    := Recno()
_cIndex_  := IndexOrd()

DbSelectArea("SUA")
DbSetOrder(1)
DbSeek(xFilial("SUA")+M->UA_NUM)
                                
                               
RecLock("SUA",.F.)
SUA->UA_TRANSP :=xTransp
SUA->UA_REDESP :=xRedesp
SUA->UA_TPFRETE:=xTpFret
SUA->UA_TPREDES:=xTpRede
SUA->UA_XTEMRED:=xTemRed
MsUnLock()

DbCloseArea("SUA")

dbSelectArea(_cAlias_)
dbSetOrder(_cIndex_)
dbGoto(_nRec_)

Return()
