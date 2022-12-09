#INCLUDE "protheus.ch"
/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | M460FIL.PRW          | AUTOR | rdSolution     | DATA | 09/02/2007 |//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - M460FIL()                                      |//
//|           | Valida os Itens Marcados.                                         |//
//|           |                                                                   |//
//|           |                                                                   |//
//+-------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////
User Function M460FIL()

Local _cRet := ""

//Pergunte("ZHTES1",.F.) 

/*--- CRIADO A PERGUNTA MV_PAR17 NO SX1-> MT461A ---(PADRAO MICROSIGA) --- EM 14/08/07 ---*/
If !Empty(Mv_Par19)
	_cRet := " Substr(SC9->C9_X_TES,1,1) $ '" + Alltrim(Mv_Par19) + "'"
//Else
//	_cRet := " Substr(SC9->C9_X_TES,1,1) >= ' '"	
Endif


/*
If !Empty(mv_par01)
	_cRet := " Substr(SC9->C9_X_TES,1,1) $ '" + Alltrim(mv_par01) + "'"
Else
	_cRet := " Substr(SC9->C9_X_TES,1,1) >= ' '"	
Endif

If !Empty(mv_par02)
	_cRet += " .And. SC9->C9_X_TES $ '" + Alltrim(mv_par02) + "'"
Endif	
*/                
Return(_cRet)
