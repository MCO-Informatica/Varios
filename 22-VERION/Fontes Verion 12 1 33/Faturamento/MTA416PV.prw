/*
PONTO DE ENTRADA USADO NO ORCAMENTO - MATA416- FATURAMENTO
APOS GERACAO DO ACOLS NA BAIXA ORCAMENTO
Executado apos o preenchimento do aCols na Baixa do Orcamento de Vendas.
Usar as variaveis _aCols e _aHeader
*/
user function MTA416PV()

M->C5_NOMCLI := SA1->A1_NOME

dbselectarea("SC6")
_nPosCON   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_DESCONT"})
_nPosVLR   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_VALDESC"})
_nPosDSC   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_VRDESC"})
_nPosVLD   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_VRVLRDE"})
_nPosLBD   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_QTDLIB"})
_nPosPrd   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_PRODUTO"})
_nPosLcl   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_LOCAL"})
_nPosQtd   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_QTDVEN"})
_nPosSld   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_VRSLDPR"})
_nPosSB2   := ascan(_aHeader,{|_vAux|alltrim(_vAux[2])=="C6_VRSB2"})

For r:= 1 to Len(_acols)
    _nSldAtual := 0
	_acols[r,_nPosDSC] := _acols[r,_nPosCON]  // alimenta campo criado
	_acols[r,_nPosVLD] := _acols[r,_nPosVLR]  // alimenta campo criado           
//	_acols[r,_nPosCON] := 0  // zera campo oficial
//	_acols[r,_nPosVLR] := 0  // zera campo oficial          

	DbSelectArea("SB2")
	DbSetOrder(1)
	If DbSeek(Xfilial("SB2")+_acols[r,_nPosPrd]+_acols[r,_nPosLcl])
	   _nSldAtual := (SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QEMP))
	Endif

	_acols[r,_nPosSB2] := _nSldAtual // zera campo oficial

    If _acols[r,_nPosQtd] > _nSldAtual  // qtdade Pv > SB2
		_acols[r,_nPosLBD] := _nSldAtual
		_acols[r,_nPosSld] := (_acols[r,_nPosQtd] - _nSldAtual)
    ElseIf _acols[r,_nPosQtd] < _nSldAtual // Qtdade PV < SB2
		_acols[r,_nPosLBD] := _acols[r,_nPosQtd] 
    ElseIf _acols[r,_nPosQtd] = _nSldAtual // QTdade PV = SB2
		_acols[r,_nPosLBD] := _acols[r,_nPosQtd]
    Endif

Next r
return
