#INCLUDE "protheus.ch"

/////////////////////////////////////////////////////////////////////////////////////
//+-------------------------------------------------------------------------------+//
//| PROGRAMA  | M460QRY.PRW          | AUTOR | rdSolution     | DATA | 09/02/2007 |//
//+-------------------------------------------------------------------------------+//
//| DESCRICAO | Ponto de Entrada - M460QRY()                                      |//
//|           | Valida os Itens Marcados.                                         |//
//+-------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////
User Function M460QRY()

Local _cRet := Paramixb[1]    //retorna a query
Local cSplit := split(Alltrim(Mv_Par19),';')
/*--- CRIADO A PERGUNTA MV_PAR13 NO SX1-> MT461A ---(PADRAO MICROSIGA) --- EM 14/08/07 ---*/

If !Empty(cSplit)
	_cRet += " AND Substring(SC9.C9_X_TES,1,1) IN (" + Alltrim(cSplit) + ")"
Endif

Return(_cRet) 


Static Function split(cTexto,cIndicador) 
Local aRet := {}
local aArray  := {}
local nContOPc  := 0

if !Empty(cTexto)
	while At(cIndicador,cTexto) > 0
		nContOPc  := At(cIndicador,cTexto) // Achando a posiÁ„o do cIndicador
		AADD(aRet, subStr(cTexto,1,nContOPc-1)) //Adiciona no array o trecho encontrado
		cTexto  := subStr(cTexto,nContOPc+1,len(cTexto)) //Adiciona o restante do texto, que est· depois do cIndicador
	endDo
	if len(cTexto)>0
		AADD(aRet, cTexto)
	endIf
endIf    
        
cTexto := ''
For nX := 1 to Len(aRet)
       cTexto += If(!Empty(cTexto),",",'') + "'" + aRet[nX] + "'" 
Next

Return(cTexto)
