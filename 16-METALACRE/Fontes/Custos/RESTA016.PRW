#include "rwmake.ch"
#include "protheus.ch"

User Function RESTA016()        
Local _nValor	:= 0                                                             
Local aArea     := GetArea()

_nValor := aCustos[aScan(aCustos,{|x|AllTrim(x[1])=="016"}),4]

If _nValor < 0
	_nValor := _nValor * (-1)
EndIf

RestArea(aArea)            
Return _nValor
