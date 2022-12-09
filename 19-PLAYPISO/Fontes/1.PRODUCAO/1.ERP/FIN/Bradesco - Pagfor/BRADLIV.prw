#include "rwmake.ch"  

//Pos 374 a 398 //
User Function BRADLIV() 

SetPrvt("_AMODEL,")

IF !EMPTY(SE2->E2_CODBAR)
/////  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO POS.264-265
_Campo1:=' '
_Campo2:=' '
_Campo3:=' '
_cLivre:= ''          
_agencia:= ' '
_digitoAg:= ' '
_carteira:=' '
_nossoNum:=' '
_contaCor:=' '
_zero:= ' '

 If SubStr(SE2->E2_CODBAR,1,3) # '237' .AND. SEA->EA_MODELO $ "31"
 _Campo1:= substr(SE2->E2_LINDIG,5,5)
 _Campo2:= substr(SE2->E2_LINDIG,11,10)
 _Campo3:= substr(SE2->E2_LINDIG,22,10)
 _cLivre := _Campo1 + _Campo2 + _Campo3
 Else               
 _agencia   := SUBSTR(SE2->E2_LINDIG,5,4)
 _digitoAg  := SUBSTR(SE2->E2_LINDIG,10,1)
 _carteira  := SUBSTR(SE2->E2_LINDIG,09,1)+SUBSTR(SE2->E2_LINDIG,11,1)
 _nossoNum  :=SUBSTR(SE2->E2_LINDIG,12,09) //*
 _contaCor  :=SUBSTR(SE2->E2_LINDIG,24,7)
 _nossoNum1 :=SUBSTR(SE2->E2_LINDIG,22,2)  //*
 _zero  := "0"
 _cLivre :=  _agencia + _carteira +_nossoNum + _nossoNum1 +_contaCor + _zero //SPACE(25)
 Endif
Endif


If empty(SE2->E2_CODBAR)
  Do Case
   Case SEA->EA_MODELO $ "01/02/06"
   _cLivre := space(40)
   Case SEA->EA_MODELO $ "03/05/41/43"
   _cLivre := "C"+"000000"+"01"+"01"+SPACE(29)
  EndCase	
Endif


Return(_cLivre)
