#include "rwmake.ch"
#include "protheus.ch"

User Function RESTA011()
Local _nValor	:= 0                              
Local aArea     := GetArea()

_nValor := aCustos[aScan(aCustos,{|x|AllTrim(x[1])=="011"}),4]

RestArea(aArea)            
Return _nValor

