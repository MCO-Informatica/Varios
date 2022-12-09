#INCLUDE "rwmake.ch"
/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บ Autor ณ AP6 IDE            บ Data ณ  03/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
User Function GVRcal01()
_nSldAtual := 0
_nSldPen   := 0
_nPosLDb   := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_QTDLIB"})
_nPosPrd   := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_PRODUTO"})
_nPosLcl   := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_LOCAL"})
_nPosQtd   := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_QUANT"})
_nPosSld   := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRSLDPR"})
_nPosVun   := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRUNIT"})

_cPrdPv    := acols[n,_nPosprd]
_clclpv    := acols[n,_nPoslcl]

DbSelectArea("SB2")
DbSetOrder(1)
If DbSeek(Xfilial("SB2")+_cPrdPv+_clclpv)
   _nSldAtual := (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))
Endif

If acols[n,_nPosQtd] > _nSldAtual  // qtdade Pv > SB2
   acols[n,_nPosldb] := _nSldAtual
   _nSldPen := (acols[n,_nPosQtd] - _nSldAtual)   
ElseIf acols[n,_nPosQtd] < _nSldAtual // Qtdade PV < SB2
   acols[n,_nPosldb] := acols[n,_nPosQtd]
ElseIf acols[n,_nPosQtd] = _nSldAtual // QTdade PV = SB2
   acols[n,_nPosldb] := acols[n,_nPosQtd]
Endif

//M->UB_VRUNIT := acols[n,_nPosVun]
//TK273CALCULA("UB_VRUNIT")
                       
Return(_nSldPen)