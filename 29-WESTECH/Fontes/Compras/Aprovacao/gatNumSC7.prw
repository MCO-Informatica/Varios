#include 'protheus.ch'
#include 'parmtype.ch'

user function gatNumSC7()
	
Local _cRetorno 


IF     !EMPTY(ALLTRIM(SC7->C7_NUM)) 

     _cRetorno := Posicione("SC7",1,xFilial("SC7")+SC7->C7_NUM,"SC7->C7_NUM")      
      
Else 

    _cRetorno := SPACE(06)
      
Endif 

Return _cRetorno