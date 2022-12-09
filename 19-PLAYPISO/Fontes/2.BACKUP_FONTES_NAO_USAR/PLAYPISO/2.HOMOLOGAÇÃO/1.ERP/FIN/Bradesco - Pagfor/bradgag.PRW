#include "rwmake.ch"  

//Pos 104 a 104 - digito agencia fornecedor//
User function bradgag()

IF !Empty(SE2->E2_CODBAR)
cNossoNum  := SUBSTR(SE2->E2_LINDIG,5,4)
nDigSoma   := 0
nModulo    := 11               // Variaveis conseguidas atraves do
nBase      := 7                // Manual do banco
cDigito1   := 0
cDigito    := 0                // Determina o metodo do Calculo
nBaseAtual := 2
_bco:= substr(SE2->E2_CODBAR,1,3)

If _bco =='237' 
	
	For nCont := Len(cNossoNum) To 1 Step -1
		nDigSoma := nDigSoma + (Val(SubStr(cNossoNum, nCont, 1)) * nBaseAtual)
		nBaseAtual := IIf(nBaseAtual < 7, nBaseAtual + 1, 2)
	Next
	
	cDigito1    := VAL(Str(Mod(nDigSoma, nModulo), 0))
	cDigito     :=  nModulo - cDigito1
	if (cDigito)=0 .or. (cDigito)>=10
		cDigito:=0
	elseif (cDigito)=1
		cDigito:=0
	endif
Endif 
Endif

If !Empty(SE2->E2_CODBAR) .and. _bco <> '237'
   cDigito := " "
Endif

If EMPTY(SE2->E2_CODBAR)
   cDigito := SA2->A2_DIGAGE
Endif
   
Return(cDigito)
