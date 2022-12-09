#include "protheus.ch"      

#DEFINE false .F.  
#DEFINE AREA_BRUTA 1
#DEFINE AREA_REAL 2
#DEFINE PESO_LIQ 3                        
          
// Função que realiza tratativa nos calculos de área
// Usada somente no cadastro de produtos   
// Param: nIndiceRetorno
// Deve-se informar um número que representa o campo para retorno
user function MAT1F003(nIndiceRetorno)
	// Define variáveis
	local nValorDimA := 0
	local nValorDimB := 0
	local nValorDimC := 0     
	local cAreaNeg   := ""
	local bModelado  := false       
	local aRetorno   := {0,0,0}
	
	// Seta valores da memória
	nValorDimA := M->B1_ZZLARGU/1000
	nValorDimB := M->B1_ZZCOMPR/1000
	nValorDimC := M->B1_ZZDIMEC/1000
	bModelado  := M->B1_ZZMODEL       
	cAreaNeg   := M->B1_ITEMCC
	
	// Realiza cálculo 
	aRetorno[AREA_REAL] := nValorDimA * nValorDimB
	
	if (nValorDimC > 0)
		aRetorno[AREA_REAL] := ((nValorDimA + nValorDimB) * nValorDimC)/2
	endIf
	    
	if (bModelado)
		nValorDimA += 0.04
		nValorDimB += 0.04
	endIf       
	
	aRetorno[AREA_BRUTA] := nValorDimA * nValorDimB
	
	if (nValorDimC > 0)
		aRetorno[AREA_BRUTA] := ((nValorDimA + nValorDimB) * nValorDimC)/2
	endIf   
	
	if (cAreaNeg $ "LBF LBM LBQ")
		if (aRetorno[AREA_BRUTA] < 0.07)
			aRetorno[AREA_BRUTA] := 0.07
		endif
	else
		if (aRetorno[AREA_BRUTA] < 0.09)
			aRetorno[AREA_BRUTA] := 0.09
		endif
	endif
	
	aRetorno[AREA_BRUTA] := aRetorno[AREA_BRUTA] 
	aRetorno[AREA_REAL]  := aRetorno[AREA_REAL]                                       
	
	M->B1_ZZBRUTA := aRetorno[AREA_BRUTA]
	M->B1_ZZREAL  := aRetorno[AREA_REAL]                             
	
	if (SB1->B1_TIPO == "MP" .or. SB1->B1_GRUPO == "BLNK")
		aRetorno[PESO_LIQ] := (aRetorno[AREA_REAL] * 2.5 * (M->B1_ZZESPES))
	else	
		// P.V.B pesa 820 gramas (Fonte: Esequiel)
		// Quando laminado, ZZ5_TIPO == 1, realiza conta com PVB, caso contrario, nao considera PVB
		if (Posicione("ZZ5", 2, xFilial("ZZ5") + M->B1_ZZTVIDR, "ZZ5_TIPO") == "1")
			aRetorno[PESO_LIQ] := ((aRetorno[AREA_REAL] * 2.5 * (M->B1_ZZESPES-1)) + 0.82)
		else
			aRetorno[PESO_LIQ] := (aRetorno[AREA_REAL] * 2.5 * M->B1_ZZESPES)
		endif
	endIf
	
	M->B1_PESO  := aRetorno[PESO_LIQ]
return aRetorno[nIndiceRetorno]