#INCLUDE "PROTHEUS.CH"

USER FUNCTION V150AUTO()

Local aRet  := PARAMIXB[1]   
Local nx := 0

If cEmpAnt $ '02'
/* Customiza��o de usu�rio */
For nx := 2 To Len(aRet) 
	If nQtde < 1
	nQtde := aRet[2][16][2] 
	else
	aRet[2][16][2] := nQtde
	Endif
  
Next             

Endif

Return aRet
