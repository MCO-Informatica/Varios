#include "rwmake.ch"  

//Pos. 118-118 //
User function bradgcc()

local cDigito

If SEA->EA_MODELO $ '30' .AND. substr(SE2->E2_CODBAR,1,3)=="237" 
cNossoNum  := SUBSTR(SE2->E2_LINDIG,24,7)
nDigSoma   := 0
nModulo    := 11               // Variaveis conseguidas atraves do
nBase      := 7                // Manual do banco
cDigito1   := 0
cDigito    := 0                // Determina o metodo do Calculo
nBaseAtual := 2

For nCont := Len(cNossoNum) To 1 Step -1
	nDigSoma := nDigSoma + (Val(SubStr(cNossoNum, nCont, 1)) * nBaseAtual)
	
	nBaseAtual := IIf(nBaseAtual < 7, nBaseAtual + 1, 2)
Next

cDigito1    := val(Str(Mod(nDigSoma, nModulo), 0))
cDigito     :=  nModulo - cDigito1
cDigito3    := str(cDigito,0)
If (cDigito)=0 .or. (cDigito)>=10
	cDigito:= 0
elseif (cDigito)=1
	cDigito:=0
Endif
Endif

If SEA->EA_MODELO $ '31' .AND. substr(SE2->E2_CODBAR,1,3)<>"237"
   cDigito :="0"
Endif 
   
If Empty(SE2->E2_CODBAR)
   cDigito := SA2->A2_DIGCTA
Endif   

Return(cDigito)
