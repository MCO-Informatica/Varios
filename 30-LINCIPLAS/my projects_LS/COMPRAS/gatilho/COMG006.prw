#Include "Protheus.ch"

/*##################################################*\
||                                               	||
||                                               	||
\*##################################################*/

User Function COMG006

Local _dDtEnt  := ctod('')
Local _cTabela := '   '   
Local _GrAprov := '      '  
Local _nI, _nJ

For _nI := 1 to len(aCols)
	If !GdDeleted(_nI)    // verifica se a linha atual esta apagada (linha apagada parametro = .T.)
		_dDtEnt   := GdFieldGet('C7_DATPRF',_nI)
		_cTabela  := GdFieldGet('C7_CODTAB',_nI)
		_cGrAprov := GdFieldGet('C7_APROV' ,_nI)
		Exit
	EndIf
Next

For _nJ := _nI+1 to len(aCols)
	If !GdDeleted(_nJ)
		GdFieldPut('C7_DATPRF',_dDtEnt  ,_nJ)
		GdFieldPut('C7_CODTAB',_cTabela ,_nJ)
		GdFieldPut('C7_APROV' ,_cGrAprov,_nJ)
	EndIf
Next

GetDRefresh()

Return(_dDtEnt)

//if(!(GetMv('MV_ESTADO')$AIA->AIA_UFS,(Aviso('Pedido de compras','Tabela invalida para esta filial.',{'OK'},3,'!')==9),.T.)        