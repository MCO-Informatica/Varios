#include "rwmake.ch"
#include "protheus.ch"

User Function RESTA010()
Local _nValor	:= 0    
Local aArea     := GetArea()                                                         

_nValor := aCustos[aScan(aCustos,{|x|AllTrim(x[1])=="010"}),4]

RestArea(aArea)            
Return _nValor

