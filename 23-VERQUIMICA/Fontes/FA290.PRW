#include "rwmake.ch"

User Function FA290()

/*
__________________________________________________________________________________________
Data		: 23/06/2016
Autor		: Nilza Men
Pto Entrada	: FA290 - Geracacao de bordero a pagar  - FINA290.
Descricao	: Executado para gravar o valor do PCC e IRRF na fatura.
__________________________________________________________________________________________
*/  

_AreaAnt  := Alias()

dbSelectArea("SE2")
_nReg   := Recno()
_nOrder := indexord()
_cFatura := SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
_nValPIS := 0
_nValCOF := 0
_nValCSL := 0
_nValIRRF:= 0

dbSetOrder(9) // ordem de fornecedor + fatura
dbSeek(_cFatura)
While _cFatura == SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_FATPREF+E2_FATURA) .and. !Eof()
	_nValPIS  += SE2->E2_PIS
	_nValCOF  += SE2->E2_COFINS
	_nValCSL  += SE2->E2_CSLL
	_nValIRRF += SE2->E2_IRRF
	dbSkip()
	Loop
End
	
dbSelectArea("SE2")
dbSetOrder(_nOrder)
dbGoTo(_nReg)      
If SE2->E2_PARCELA = '01'
	RecLock("SE2",.f.)
	SE2->E2_XPIS	:= _nValPIS 
	SE2->E2_XCOFINS	:= _nValCOF
	SE2->E2_XCSLL	:= _nValCSL 
	SE2->E2_IRRF	:= _nValIRRF    
	MsUnlock()
Endif



Return

