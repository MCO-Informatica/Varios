#Include "Protheus.ch"
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Mod10     ºAutor  ³Thiago Queiroz      º Data ³  22/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do digito verificador do nosso numero.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Uso especifico para o Itau	                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³01-_cNum - Numero do Titulo (Nosso Numero)                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mod10(cStr,nMultIni,nMultFim)
Local i, nCont := nModulo := 0, cChar, nMult

nMultIni := Iif( nMultIni==Nil,1,nMultIni )
nMultFim := Iif( nMultFim==Nil,2,nMultFim )
nMult := nMultIni
cStr := AllTrim(cStr)

For i := 1 to Len(cStr) Step 1
	cChar := Substr(cStr,i,1)
	If isAlpha( cChar )
		Help(" ", 1, "ONLYNUM")
		Return .f.
	End
	nCont	:= Val(cChar)*nMult
	
	IF nCont >= 10
		nModulo += VAL(SUBSTR(ALLTRIM(STR(NCONT)),1,1)) + VAL(SUBSTR(ALLTRIM(STR(NCONT)),2,1))
	ELSE
		nModulo += nCont //Val(cChar)*nMult
	ENDIF
	
	nMult:= IIf(nMult==nMultfim,1,nMult+1)
Next
nRest := nModulo % 10
IF nRest == 0
	nRest := 0
ELSEIF nRest == 1
	nRest := 10
ELSE
	nRest := 10-nRest
	//nRest := IIf(nRest==0 .or. nRest==1,0,11-nRest)
ENDIF

Return(Str(nRest,2))

