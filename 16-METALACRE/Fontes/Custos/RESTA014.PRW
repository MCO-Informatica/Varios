#include "rwmake.ch"
#include "protheus.ch"

User Function RESTA014()        
Local _nValor	:= 0                                                             
Local aArea     := GetArea()

_nValor := aCustos[aScan(aCustos,{|x|AllTrim(x[1])=="014"}),4]

If _nValor < 0
	_nValor := _nValor * (-1)
EndIf

RestArea(aArea)            
Return _nValor

