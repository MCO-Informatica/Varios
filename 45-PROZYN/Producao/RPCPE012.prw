#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPCPE012  ºAutor ³ DERIK SANTOS           º Data ³ 11/11/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para retornar o lote de Destino com base no parametro±±
±±ºDesc.     ³ MV_LOTEPA - executado no campo D3_SUGLOTE                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Prozyn                                     º±±        
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCPE012()

_pSuglote := aScan(aHeader,{|x| AllTrim(x[1]) == "Sugere Lote"})
_cSuglote := aCols[1][_pSuglote]
_pLote    := aScan(aHeader,{|x| AllTrim(x[1]) == "Lote Destino"})
_cLote    := aCols[1][_pLote]
_cItens   := Len(aCols)

If _cSuglote == "S" .AND. _cItens = 1
	dbSelectArea("SX6")
	dBSetOrder(1)
		If dBSeek(xfilial("SX6") +"MV_LOTEPA")
			_cLote:= alltrim(SX6->X6_CONTEUD)     //resultado do parâmetro
			aCols[1][_pLote] := _cLote
			_cLotepa := SOMA1(_cLote)
			_cLoteok := SUBSTR(_cLotepa,1,6)

			Reclock("SX6",.F.)
			SX6->X6_CONTEUD := _cLoteok
			msUnLock()
		Endif 
Endif

Return (_cSuglote)