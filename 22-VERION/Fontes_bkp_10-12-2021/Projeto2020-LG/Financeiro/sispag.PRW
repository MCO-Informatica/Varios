#include "rwmake.ch"

/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVCBConc    บ Autor ณ Andrea Martins     บ Data ณ  23/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFaz validacao digito verificador da linha digitavel (Itau)   บฑฑ
ฑฑบ          ณConcessionarias                                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function VCBConc()

SetPrvt("_lRet,_cCBarr")

_lRet 	:= .t.
_cCBarr	:= ""

If M->E2_XCBCONC <> " "
	
	If Len(Alltrim(Subs(M->E2_XCBCONC,1,44))) < 44
		Help(" ",1,"INVALCODBAR")
		Return(.f.)
	EndIf
	
	_cCBarr := M->E2_XCBCONC
	
	_cVar1	:= Val(Subs(_cCBarr,1,1))*2; _cVar2  := Val(Subs(_cCBarr,2,1))
	_cVar3	:= Val(Subs(_cCBarr,3,1))*2; _cVar5  := Val(Subs(_cCBarr,5,1))
	_cVar6  := Val(Subs(_cCBarr,6,1))*2; _cVar7	:= Val(Subs(_cCBarr,7,1))
	_cVar8  := Val(Subs(_cCBarr,8,1))*2; _cVar9	:= Val(Subs(_cCBarr,9,1))
	_cVar10 := Val(Subs(_cCBarr,10,1))*2;_cVar11 := Val(Subs(_cCBarr,11,1))
	_cVar12 := Val(Subs(_cCBarr,12,1))*2;	_cVar13	:= Val(Subs(_cCBarr,13,1))
	_cVar14 := Val(Subs(_cCBarr,14,1))*2;	_cVar15	:= Val(Subs(_cCBarr,15,1))
	_cVar16 := Val(Subs(_cCBarr,16,1))*2;	_cVar17	:= Val(Subs(_cCBarr,17,1))
	_cVar18 := Val(Subs(_cCBarr,18,1))*2;	_cVar19	:= Val(Subs(_cCBarr,19,1))
	_cVar20 := Val(Subs(_cCBarr,20,1))*2;	_cVar21	:= Val(Subs(_cCBarr,21,1))
	_cVar22 := Val(Subs(_cCBarr,22,1))*2;	_cVar23	:= Val(Subs(_cCBarr,23,1))
	_cVar24 := Val(Subs(_cCBarr,24,1))*2;	_cVar25	:= Val(Subs(_cCBarr,25,1))
	_cVar26 := Val(Subs(_cCBarr,26,1))*2;	_cVar27	:= Val(Subs(_cCBarr,27,1))
	_cVar28 := Val(Subs(_cCBarr,28,1))*2;	_cVar29	:= Val(Subs(_cCBarr,29,1))
	_cVar30 := Val(Subs(_cCBarr,30,1))*2;	_cVar31	:= Val(Subs(_cCBarr,31,1))
	_cVar32 := Val(Subs(_cCBarr,32,1))*2;	_cVar33	:= Val(Subs(_cCBarr,33,1))
	_cVar34 := Val(Subs(_cCBarr,34,1))*2;	_cVar35	:= Val(Subs(_cCBarr,35,1))
	_cVar36 := Val(Subs(_cCBarr,36,1))*2;	_cVar37	:= Val(Subs(_cCBarr,37,1))
	_cVar38 := Val(Subs(_cCBarr,38,1))*2;	_cVar39	:= Val(Subs(_cCBarr,39,1))
	_cVar40 := Val(Subs(_cCBarr,40,1))*2;	_cVar41	:= Val(Subs(_cCBarr,41,1))
	_cVar42 := Val(Subs(_cCBarr,42,1))*2;	_cVar43	:= Val(Subs(_cCBarr,43,1))
	_cVar44 := Val(Subs(_cCBarr,44,1))*2
	
	If _cVar1 > 9
		_cVar1 := Val(Subs(Str(_cVar1,2),1,1))+Val(Subs(Str(_cVar1,2),2,1))
	EndIf
	If _cVar3 > 9
		_cVar3 := Val(Subs(Str(_cVar3,2),1,1))+Val(Subs(Str(_cVar3,2),2,1))
	EndIf
	If _cVar6 > 9
		_cVar6 := Val(Subs(Str(_cVar6,2),1,1))+Val(Subs(Str(_cVar6,2),2,1))
	EndIf
	If _cVar8 > 9
		_cVar8 := Val(Subs(Str(_cVar8,2),1,1))+Val(Subs(Str(_cVar8,2),2,1))
	EndIf
	If _cVar10 > 9
       _cVar10 := Val(Subs(Str(_cVar10,2),1,1))+Val(Subs(Str(_cVar10,2),2,1))
	EndIf
	If _cVar12 > 9
		_cVar12 := Val(Subs(Str(_cVar12,2),1,1))+Val(Subs(Str(_cVar12,2),2,1))
	EndIf
	If _cVar14 > 9
		_cVar14 := Val(Subs(Str(_cVar14,2),1,1))+Val(Subs(Str(_cVar14,2),2,1))
	EndIf
	If _cVar16 > 9
		_cVar16 := Val(Subs(Str(_cVar16,2),1,1))+Val(Subs(Str(_cVar16,2),2,1))
	EndIf
	If _cVar18 > 9
		_cVar18 := Val(Subs(Str(_cVar18,2),1,1))+Val(Subs(Str(_cVar18,2),2,1))
	EndIf
	If _cVar20 > 9
		_cVar20 := Val(Subs(Str(_cVar20,2),1,1))+Val(Subs(Str(_cVar20,2),2,1))
	EndIf
	If _cVar22 > 9
		_cVar22 := Val(Subs(Str(_cVar22,2),1,1))+Val(Subs(Str(_cVar22,2),2,1))
	EndIf
	If _cVar24 > 9
		_cVar24 := Val(Subs(Str(_cVar24,2),1,1))+Val(Subs(Str(_cVar24,2),2,1))
	EndIf
	If _cVar26 > 9
		_cVar26 := Val(Subs(Str(_cVar26,2),1,1))+Val(Subs(Str(_cVar26,2),2,1))
	EndIf
	If _cVar28 > 9
		_cVar28 := Val(Subs(Str(_cVar28,2),1,1))+Val(Subs(Str(_cVar28,2),2,1))
	EndIf
	If _cVar30 > 9
		_cVar30 := Val(Subs(Str(_cVar30,2),1,1))+Val(Subs(Str(_cVar30,2),2,1))
	EndIf
	If _cVar32 > 9
		_cVar32 := Val(Subs(Str(_cVar32,2),1,1))+Val(Subs(Str(_cVar32,2),2,1))
	EndIf
	If _cVar34 > 9
		_cVar34 := Val(Subs(Str(_cVar34,2),1,1))+Val(Subs(Str(_cVar34,2),2,1))
	EndIf
	If _cVar36 > 9
		_cVar36 := Val(Subs(Str(_cVar36,2),1,1))+Val(Subs(Str(_cVar36,2),2,1))
	EndIf
	If _cVar38 > 9
		_cVar38 := Val(Subs(Str(_cVar38,2),1,1))+Val(Subs(Str(_cVar38,2),2,1))
	EndIf
	If _cVar40 > 9
		_cVar40 := Val(Subs(Str(_cVar40,2),1,1))+Val(Subs(Str(_cVar40,2),2,1))
	EndIf
	If _cVar42 > 9
		_cVar42 := Val(Subs(Str(_cVar42,2),1,1))+Val(Subs(Str(_cVar42,2),2,1))
	EndIf
	If _cVar44 > 9
		_cVar44 := Val(Subs(Str(_cVar44,2),1,1))+Val(Subs(Str(_cVar44,2),2,1))
	EndIf

		
	_cCampo1 := _cVar1+_cVar2+_cVar3+_cVar5+_cVar6+_cVar7+_cVar8+_cVar9+_cVar10+;
				 _cVar11+_cVar12+_cVar13+_cVar14+_cVar15+_cVar16+_cVar17+_cVar18+;
				 _cVar19+_cVar20+_cVar21+_cVar22+_cVar23+_cVar24+_cVar25+_cVar26+;
				 _cVar27+_cVar28+_cVar29+_cVar30+_cVar31+_cVar32+_cVar33+_cVar34+;
				 _cVar35+_cVar36+_cVar37+_cVar38+_cVar39+_cVar40+_cVar41+_cVar42+;
				 _cVar43+_cVar44
	   
	_cDivid1 := (_cCampo1 % 10)		
	_cCampo1 := 10 - _cDivid1
	_cCampo1 := If(_cCampo1 == 10,0,_cCampo1)
	_cCampo1 := StrZero(_cCampo1,1,0)
		
	If _cCampo1 <> SubStr(_cCBarr,4,1)
	   Help(" ",1,"INVALCODBAR")
	   _lRet := .F.
	Else
	   _lRet := .T.
	EndIf
		
Endif
	
Return(_lRet)


/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAgenCta    บ Autor ณ Andrea Martins     บ Data ณ  22/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFaz leitura da agencia conforme modalidade de pagamento      บฑฑ
ฑฑบ          ณselecionada                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function AgenCta

SetPrvt("_cZeros1,_cAgc341,_cBranco1,_cZeros2,_cCta341,_cBranco2,_cDigt341")
SetPrvt("_cAgencia,_cBranco3,_cConta,_cBranco4,_cDigito")
SetPrvt("_cCtaFavo")

_cZeros1  := "0"
_cAgc341  := Space(4)
_cBranco1 := Space(1)
_cZeros2  := "0000000"
_cCta341  := Space(5)
_cBranco2 := Space(1)
_cDigt341 := Space(1)

_cAgencia := Space(5)
_cBranco3 := Space(1)
_cConta   := Space(12)
_cBranco4 := Space(1)
_cDigito  := Space(1)

_cCtaFavo := Space(20)


If SE2->E2_XBANCO == "341"
	If SE2->E2_XMODPA $ "02,10"
		_cCtaFavo := _cZeros1+STRZERO(VAL(SE2->E2_XAGEN),4)+_cBranco1+_cZeros2+"00000"+_cBranco2+"0"
	Else
		_cAgc341  := STRZERO(VAL(SE2->E2_XAGEN),4)
		_cCta341  := STRZERO(VAL(SE2->E2_XCONTA),5)
		_cDigt341 := STRZERO(VAL(SE2->E2_XDVCONT),1)
		_cCtaFavo := _cZeros1+_cAgc341+_cBranco1+_cZeros2+_cCta341+_cBranco2+_cDigt341
	EndIf
Else
	_cAgencia := STRZERO(VAL(SE2->E2_XAGEN),5)
	_cConta   := STRZERO(VAL(SE2->E2_XCONTA),12)
	_cDigito  := STRZERO(VAL(SE2->E2_XDVCONT),1)
	_cCtaFavo := _cAgencia+_cBranco3+_cConta+_cBranco4+_cDigito
EndIf	

Return(_cCtaFavo)


/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBConc     บ Autor ณ Andrea Martins     บ Data ณ  22/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMonta codigo de barras dependendo se foi digitada ou nao.    บฑฑ
ฑฑบ          ณVerifica Modulos 10 e 11. (Concessionarias)                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function CBConc()

SetPrvt("_cLDConc,_cCBConc,_cResult")

_cLDConc := Space(48)
_cCBConc := Space(48)
_cResult := Space(48)


If SE2->E2_XCBCONC == Space(48)
    _cResul1 := Space(48)
Else
	_cResul1 := SUBSTR(SE2->E2_XCBCONC,1,44) + Space(4)
EndIf

If SE2->E2_XLDCONC == Space(48)
	_cResul2 := Space (48)    
Else
	_cResul2 := SUBSTR(SE2->E2_XLDCONC,1,48)
EndIf

If _cResul1 == Space(48)
	_cResult := _cResul2
Else
	_cResult := _cResul1
EndIf

Return(_cResult)

/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLDConc     บ Autor ณ Andrea Martins     บ Data ณ  22/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFaz validacao digito verificador da linha digitavel (Itau)   บฑฑ
ฑฑบ          ณConcessionarias                                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function LDConc()

SetPrvt("_lRet,_cLDigt")

_lRet 	:= .t.
_cLDigt	:= ""

If M->E2_XLDCONC <> " "
	
	If Len(Alltrim(Subs(M->E2_XLDCONC,1,48))) < 48
		Help(" ",1,"INVALCODBAR")
		Return(.f.)
	EndIf
	
	_cLDigit := M->E2_XLDCONC
	
	_cVar1	:= Val(Subs(_cLDigit,1,1))*2; _cVar2  := Val(Subs(_cLDigit,2,1))
	_cVar3	:= Val(Subs(_cLDigit,3,1))*2; _cVar4  := Val(Subs(_cLDigit,4,1))
	_cVar5	:= Val(Subs(_cLDigit,5,1))*2; _cVar6  := Val(Subs(_cLDigit,6,1))
	_cVar7	:= Val(Subs(_cLDigit,7,1))*2; _cVar8  := Val(Subs(_cLDigit,8,1))
	_cVar9	:= Val(Subs(_cLDigit,9,1))*2; _cVar10 := Val(Subs(_cLDigit,10,1))
	_cVar11 := Val(Subs(_cLDigit,11,1))*2
	
	_cVar13	:= Val(Subs(_cLDigit,13,1))*2; _cVar14 := Val(Subs(_cLDigit,14,1))
	_cVar15	:= Val(Subs(_cLDigit,15,1))*2; _cVar16 := Val(Subs(_cLDigit,16,1))
	_cVar17	:= Val(Subs(_cLDigit,17,1))*2; _cVar18 := Val(Subs(_cLDigit,18,1))
	_cVar19	:= Val(Subs(_cLDigit,19,1))*2; _cVar20 := Val(Subs(_cLDigit,20,1))
	_cVar21	:= Val(Subs(_cLDigit,21,1))*2; _cVar22 := Val(Subs(_cLDigit,22,1))
	_cVar23	:= Val(Subs(_cLDigit,23,1))*2
	
	_cVar25	:= Val(Subs(_cLDigit,25,1))*2; _cVar26 := Val(Subs(_cLDigit,26,1))
	_cVar27	:= Val(Subs(_cLDigit,27,1))*2; _cVar28 := Val(Subs(_cLDigit,28,1))
	_cVar29	:= Val(Subs(_cLDigit,29,1))*2; _cVar30 := Val(Subs(_cLDigit,30,1))
	_cVar31	:= Val(Subs(_cLDigit,31,1))*2; _cVar32 := Val(Subs(_cLDigit,32,1))
	_cVar33	:= Val(Subs(_cLDigit,33,1))*2; _cVar34 := Val(Subs(_cLDigit,34,1))
	_cVar35	:= Val(Subs(_cLDigit,35,1))*2
	
	_cVar37	:= Val(Subs(_cLDigit,37,1))*2; _cVar38 := Val(Subs(_cLDigit,38,1))
	_cVar39	:= Val(Subs(_cLDigit,39,1))*2; _cVar40 := Val(Subs(_cLDigit,40,1))
	_cVar41	:= Val(Subs(_cLDigit,41,1))*2; _cVar42 := Val(Subs(_cLDigit,42,1))
	_cVar43	:= Val(Subs(_cLDigit,43,1))*2; _cVar44 := Val(Subs(_cLDigit,44,1))
	_cVar45	:= Val(Subs(_cLDigit,45,1))*2; _cVar46 := Val(Subs(_cLDigit,46,1))
	_cVar47	:= Val(Subs(_cLDigit,47,1))*2
	
	If _cVar1 > 9
		_cVar1 := Val(Subs(Str(_cVar1,2),1,1))+Val(Subs(Str(_cVar1,2),2,1))
	EndIf
	If _cVar3 > 9
		_cVar3 := Val(Subs(Str(_cVar3,2),1,1))+Val(Subs(Str(_cVar3,2),2,1))
	EndIf
	If _cVar5 > 9
		_cVar5 := Val(Subs(Str(_cVar5,2),1,1))+Val(Subs(Str(_cVar5,2),2,1))
	EndIf
	If _cVar7 > 9
		_cVar7 := Val(Subs(Str(_cVar7,2),1,1))+Val(Subs(Str(_cVar7,2),2,1))
	EndIf
	If _cVar9 > 9
		_cVar9 := Val(Subs(Str(_cVar9,2),1,1))+Val(Subs(Str(_cVar9,2),2,1))
	EndIf
	If _cVar11 > 9
		_cVar11 := Val(Subs(Str(_cVar11,2),1,1))+Val(Subs(Str(_cVar11,2),2,1))
	EndIf
	If _cVar13 > 9
		_cVar13 := Val(Subs(Str(_cVar13,2),1,1))+Val(Subs(Str(_cVar13,2),2,1))
	EndIf
	If _cVar15 > 9
		_cVar15 := Val(Subs(Str(_cVar15,2),1,1))+Val(Subs(Str(_cVar15,2),2,1))
	EndIf
	If _cVar17 > 9
		_cVar17 := Val(Subs(Str(_cVar17,2),1,1))+Val(Subs(Str(_cVar17,2),2,1))
	EndIf
	If _cVar19 > 9
		_cVar19 := Val(Subs(Str(_cVar19,2),1,1))+Val(Subs(Str(_cVar19,2),2,1))
	EndIf
	If _cVar21 > 9
		_cVar21 := Val(Subs(Str(_cVar21,2),1,1))+Val(Subs(Str(_cVar21,2),2,1))
	EndIf
	If _cVar23 > 9
		_cVar23 := Val(Subs(Str(_cVar23,2),1,1))+Val(Subs(Str(_cVar23,2),2,1))
	EndIf
	If _cVar25 > 9
		_cVar25 := Val(Subs(Str(_cVar25,2),1,1))+Val(Subs(Str(_cVar25,2),2,1))
	EndIf
	If _cVar27 > 9
		_cVar27 := Val(Subs(Str(_cVar27,2),1,1))+Val(Subs(Str(_cVar27,2),2,1))
	EndIf
	If _cVar29 > 9
		_cVar29 := Val(Subs(Str(_cVar29,2),1,1))+Val(Subs(Str(_cVar29,2),2,1))
	EndIf
	If _cVar31 > 9
		_cVar31 := Val(Subs(Str(_cVar31,2),1,1))+Val(Subs(Str(_cVar31,2),2,1))
	EndIf
	If _cVar33 > 9
		_cVar33 := Val(Subs(Str(_cVar33,2),1,1))+Val(Subs(Str(_cVar33,2),2,1))
	EndIf
	If _cVar35 > 9
		_cVar35 := Val(Subs(Str(_cVar35,2),1,1))+Val(Subs(Str(_cVar35,2),2,1))
	EndIf
	If _cVar37 > 9
		_cVar37 := Val(Subs(Str(_cVar37,2),1,1))+Val(Subs(Str(_cVar37,2),2,1))
	EndIf
	If _cVar39 > 9
		_cVar39 := Val(Subs(Str(_cVar39,2),1,1))+Val(Subs(Str(_cVar39,2),2,1))
	EndIf
	If _cVar41 > 9
		_cVar41 := Val(Subs(Str(_cVar41,2),1,1))+Val(Subs(Str(_cVar41,2),2,1))
	EndIf
	If _cVar43 > 9
		_cVar43 := Val(Subs(Str(_cVar43,2),1,1))+Val(Subs(Str(_cVar43,2),2,1))
	EndIf
	If _cVar45 > 9
		_cVar45 := Val(Subs(Str(_cVar45,2),1,1))+Val(Subs(Str(_cVar45,2),2,1))
	EndIf
	If _cVar47 > 9
		_cVar47 := Val(Subs(Str(_cVar47,2),1,1))+Val(Subs(Str(_cVar47,2),2,1))
	EndIf
		
		_cCampo1 := _cVar1+_cVar2+_cVar3+_cVar4+_cVar5+_cVar6+_cVar7+_cVar8+_cVar9+_cVar10+_cVar11
		_cDivid1 := (_cCampo1 % 10)		
		_cCampo1 := 10 - _cDivid1
		_cCampo1 := If(_cCampo1 == 10,0,_cCampo1)
		_cCampo1 := StrZero(_cCampo1,1,0)
		
		_cCampo2 := _cVar13+_cVar14+_cVar15+_cVar16+_cVar17+_cVar18+_cVar19+_cVar20+_cVar21+_cVar22+_cVar23
		_cDivid2 := (_cCampo2 % 10)		
		_cCampo2 := 10 - _cDivid2
		_cCampo2 := If(_cCampo2 == 10,0,_cCampo2)
		_cCampo2 := StrZero(_cCampo2,1,0)
		
		_cCampo3 := _cVar25+_cVar26+_cVar27+_cVar28+_cVar29+_cVar30+_cVar31+_cVar32+_cVar33+_cVar34+_cVar35
		_cDivid3 := (_cCampo3 % 10)		
		_cCampo3 := 10 - _cDivid3
		_cCampo3 := If(_cCampo3 == 10,0,_cCampo3)
		_cCampo3 := StrZero(_cCampo3,1,0)
				
		_cCampo4 := _cVar37+_cVar38+_cVar39+_cVar40+_cVar41+_cVar42+_cVar43+_cVar44+_cVar45+_cVar46+_cVar47
		_cDivid4 := (_cCampo4 % 10)		
		_cCampo4 := 10 - _cDivid4
		_cCampo4 := If(_cCampo4 == 10,0,_cCampo4)
		_cCampo4 := StrZero(_cCampo4,1,0)

		
		If _cCampo1 <> SubStr(_cLDigit,12,1) .or. _cCampo2 <> SubStr(_cLDigit,24,1) .or.;
		   _cCampo3 <> SubStr(_cLDigit,36,1) .or. _cCampo4 <> SubStr(_cLDigit,48,1)
		   Help(" ",1,"INVALCODBAR")
		   _lRet := .F.
		Else
		   _lRet := .T.
		EndIf
		
Endif
	
Return(_lRet)

/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCodBar     บ Autor ณ Andrea Martins     บ Data ณ  22/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMonta codigo de barras dependendo se foi digitada ou nao.    บฑฑ
ฑฑบ          ณVerifica Modulos 10 e 11.                                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function CodBar()

SetPrvt("_cLinDig,_cCodBar,_cResult")

_cLinDig := Space(43)
_cCodBar := Space(43)
_cResult := Space(44)


If SE2->E2_XLINDIG == Space(47)
    _cResul1 := Space(44)
Else
	_cResul1 :=	SubStr(SE2->E2_XLINDIG,1,4) + SubStr(SE2->E2_XLINDIG,33,1) +;
	            SubStr(SE2->E2_XLINDIG,34,4) + SubStr(SE2->E2_XLINDIG,38,10)+;
	            SubStr(SE2->E2_XLINDIG,5,5) + SubStr(SE2->E2_XLINDIG,11,10)+;
   	            SubStr(SE2->E2_XLINDIG,22,10)
EndIf

If SE2->E2_CODBAR == Space(44)
	_cResul2 := Space (44)    
Else
	_cResul2 := SUBSTR(SE2->E2_CODBAR,1,44)
EndIf

If _cResul1 == Space(44)
	_cResult := _cResul2
Else
	_cResult := _cResul1
EndIf

Return(_cResult)


/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณModulo10   บ Autor ณ Andrea MArtins     บ Data ณ  22/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFaz leitura do Digito Verificador da Linha Digitavel.        บฑฑ
ฑฑบ          ณModulo10                                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function Modulo10(_cVar)

SetPrvt("_cVar")

nMult	:= 2
nModulo	:= 0
nVal	:= 0

For i := Len(_cVar) to 1 Step -1
	
	_cChar := Substr(_cVar,i,1)
	
	If isAlpha(_cChar)
		Help(" ", 1, "ONLYNUM")
		Return(.f.)
	Endif
	
	nModulo := Val(_cChar)* nMult
	
	If nModulo >= 10
		nVal := nVal + 1
		nVal := nVal + (nModulo-10)
	Else
		nVal := nVal + nModulo
	EndIf
	
	nMult:= If(nMult == 2,1,2)
	
Next

_nCalc := 10 - (nVal % 10)


Return(_nCalc)

/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDvLinDig   บ Autor ณ Andrea Martins     บ Data ณ  22/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFaz validacao digito verificador da linha digitavel (Itau)   บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function DvLinDig

SetPrvt("_lRet","_cVar")

_lRet := .t.

If Subs(M->E2_XLINDIG,1,3) == "341"
	
	If Len(Alltrim(Subs(M->E2_XLINDIG,1,32))) < 32
		Help(" ",1,"INVALCODBAR")
		Return(.f.)
	EndIf
	
	_cVar := M->E2_XLINDIG
	
	If AT(".",_cVar) > 0 .or. AT(" ",Alltrim(_cVar)) > 0
		For n := 1 to Len(_cVar)
			If AT(".",_cVar) > 0
				_nPos := AT(".",_cVar)
				_cVar := Subs(_cVar,1,_nPos-1) + Subs(_cVar,_nPos+1,Len(_cVar)-_nPos)
			EndIf
			
			If AT(" ",_cVar) > 0
				_nPos := AT(" ",_cVar)
				_cVar := Subs(_cVar,1,_nPos-1) + Subs(_cVar,_nPos+1,Len(_cVar)-_nPos)
			EndIf
		Next
	EndIf
	
	_cDv1 := U_Modulo10(Subs(_cVar,1,9))
	_cDv2 := U_Modulo10(Subs(_cVar,11,10))
	_cDv3 := U_Modulo10(Subs(_cVar,22,10))
	
	If _cDv1 > 9
		_cDv1 := Val(Subs(Str(_cDv1,2),1,1))+Val(Subs(Str(_cDv1,2),2,1))
	EndIf
	
	If _cDv2 > 9
		_cDv2 := Val(Subs(Str(_cDv2,2),1,1))+Val(Subs(Str(_cDv2,2),2,1))
	EndIf
	
	If _cDv3 > 9
		_cDv3 := Val(Subs(Str(_cDv3,2),1,1))+Val(Subs(Str(_cDv3,2),2,1))
	EndIf
	
	If  _cDv1 <> Val(Subs(_cVar,10,1)) .or.;
		_cDv2 <> Val(Subs(_cVar,21,1)) .or.;
		_cDv3 <> Val(Subs(_cVar,32,1))
		
		Help(" ",1,"INVALCODBAR")
		_lRet := .f.
	EndIf
EndIf

Return(_lRet)

/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTribut     บ Autor ณ Andrea Martins     บ Data ณ  22/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMonta sequencia 18 a 195 SISPAG para pagto de Tributos.      บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function Tribut()

SetPrvt("_cTribut,_cTotal")

_cTribut := Space(178)
_cTotal	 := SE2->E2_SALDO + SE2->E2_MULTA + SE2->E2_JUROS - SE2->E2_DESCONT

If     Substr(SE2->E2_XTRIBUT,1,2) == "01"  // GPS

       _cTribut := Substr(SE2->E2_XTRIBUT,1,2)+;
                   SE2->E2_XCGPS+;
                   Substr(SE2->E2_XCOMPGP,1,6)+;
				   IIF(SE2->E2_XCGPS!="2631",SUBSTR(SM0->M0_CGC,1,14),ExecBlock("CNPJFORN"))+;
				   STRZERO(SE2->E2_SALDO*100,14)+;
				   REPLICATE("0",14)+;
				   REPLICATE("0",14)+;
				   STRZERO(SE2->E2_SALDO*100,14)+;
				   STRZERO(DAY(DDATABASE),2)+;
				   STRZERO(MONTH(DDATABASE),2)+;
				   STR(YEAR(DDATABASE),4)+;
				   SPACE(58)+;
				   IIF(SE2->E2_XCGPS!="2631",SUBSTR(SM0->M0_NOMECOM,1,30),ExecBlock("NOMEFORN"))
	
ElseIf Substr(SE2->E2_XTRIBUT,1,2) == "02"  // DARF
	
	   _cTribut := Substr(SE2->E2_XTRIBUT,1,2)+;
	               SE2->E2_XCDARF+;
	               "2"+;
	               SUBSTR(SM0->M0_CGC,1,14)+;
				   SE2->E2_XCOMPGP+;
				   SUBSTR(SE2->E2_XNUMREF,1,17)+;
				   STRZERO(SE2->E2_SALDO*100,14)+;
				   STRZERO(SE2->E2_MULTA*100,14)+;
				   STRZERO(SE2->E2_JUROS*100,14)+;
				   STRZERO(_cTotal*100,14)+;
				   STRZERO(DAY(SE2->E2_VENCREA),2)+;
				   STRZERO(MONTH(SE2->E2_VENCREA),2)+;
				   STRZERO(YEAR(SE2->E2_VENCREA),4)+;
				   STRZERO(DAY(DDATABASE),2)+;
				   STRZERO(MONTH(DDATABASE),2)+;
				   STR(YEAR(DDATABASE),4)+;
				   SPACE(30)+;
				   SUBSTR(SM0->M0_NOMECOM,1,30)
	
ElseIf Substr(SE2->E2_XTRIBUT,1,2) == "05"  // GARE - ICMS

	   _cTribut := Substr(SE2->E2_XTRIBUT,1,2)+;
	               SE2->E2_XCGARE+;
	               "2"+;
	               SUBSTR(SM0->M0_CGC,1,14)+;
	               Substr(SM0->M0_INSC,1,12)+;
	               IIF(Empty(SE2->E2_DIVIATV),Replicate("0",13),STRZERO(Val(SE2->E2_DIVIATV),13))+;
	               Substr(SE2->E2_XCOMPGP,1,6)+;
	               IIF(Empty(SE2->E2_NOTIFIC),Replicate("0",13),STRZERO(Val(SE2->E2_NOTIFIC),13))+;
				   STRZERO(SE2->E2_SALDO*100,14)+;
				   STRZERO(SE2->E2_JUROS*100,14)+;
				   STRZERO(SE2->E2_MULTA*100,14)+;
				   STRZERO(_cTotal*100,14)+;
				   STRZERO(DAY(SE2->E2_VENCREA),2)+;
				   STRZERO(MONTH(SE2->E2_VENCREA),2)+;
				   STRZERO(YEAR(SE2->E2_VENCREA),4)+;
				   STRZERO(DAY(DDATABASE),2)+;
				   STRZERO(MONTH(DDATABASE),2)+;
				   STR(YEAR(DDATABASE),4)+;
				   Substr(SM0->M0_CNAE,1,5)+;
				   SPACE(06)+;
				   SUBSTR(SM0->M0_NOMECOM,1,30)

ElseIf Substr(SE2->E2_XTRIBUT,1,2) == "07" .or. Substr(SE2->E2_XTRIBUT,1,2) == "08" // IPVA - SP ou DPVAT

	   _cTribut := Substr(SE2->E2_XTRIBUT,1,2)+;
	               SPACE(04)+;
	               "2"+;
	               SUBSTR(SM0->M0_CGC,1,14)+;
	               Substr(SE2->E2_XCOMPGP,1,4)+;
	               IIF(Empty(SE2->E2_RENAVAM),Replicate("0",09),STRZERO(Val(SE2->E2_RENAVAM),09))+;
	               SE2->E2_UNIDFED+;
	               IIF(Empty(SE2->E2_MUNICIP),Replicate("0",05),STRZERO(Val(SE2->E2_MUNICIP),05))+;
	               SE2->E2_PLACA+;
	               SE2->E2_PAGTO+;
	               STRZERO(SE2->E2_SALDO*100,14)+;
	               STRZERO(SE2->E2_DESCONT*100,14)+;
				   STRZERO(_cTotal*100,14)+;
				   STRZERO(DAY(SE2->E2_VENCREA),2)+;
				   STRZERO(MONTH(SE2->E2_VENCREA),2)+;
				   STRZERO(YEAR(SE2->E2_VENCREA),4)+;
				   STRZERO(DAY(DDATABASE),2)+;
				   STRZERO(MONTH(DDATABASE),2)+;
 				   STR(YEAR(DDATABASE),4)+;
				   SPACE(41)+;
				   SUBSTR(SM0->M0_NOMECOM,1,30)

EndIf

Return(_cTribut)

/*/
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVCBBole    บ Autor ณ Andrea Martins     บ Data ณ  28/04/03   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFaz validacao digito verificador da linha digitavel (Itau)   บฑฑ
ฑฑบ          ณConcessionarias                                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTyco                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
/*/

User Function VCBBole()

SetPrvt("_lRet,_cCBarr")

_lRet 	:= .t.
_cCBarr	:= ""

If M->E2_CODBAR <> " "
	
	If Len(Alltrim(Subs(M->E2_CODBAR,1,43))) < 43
		Help(" ",1,"INVALCODBAR")
		Return(.f.)
	EndIf
	
	_cCBarr := M->E2_CODBAR
	
	_cVar1	:= Val(Subs(_cCBarr,1,1))*4; _cVar2  := Val(Subs(_cCBarr,2,1))*3
	_cVar3	:= Val(Subs(_cCBarr,3,1))*2; _cVar4  := Val(Subs(_cCBarr,4,1))*9
	_cVar6  := Val(Subs(_cCBarr,6,1))*8; _cVar7	:= Val(Subs(_cCBarr,7,1))*7
	_cVar8  := Val(Subs(_cCBarr,8,1))*6;	_cVar9	:= Val(Subs(_cCBarr,9,1))*5
	_cVar10 := Val(Subs(_cCBarr,10,1))*4;	_cVar11 := Val(Subs(_cCBarr,11,1))*3
	_cVar12 := Val(Subs(_cCBarr,12,1))*2;	_cVar13	:= Val(Subs(_cCBarr,13,1))*9
	_cVar14 := Val(Subs(_cCBarr,14,1))*8;	_cVar15	:= Val(Subs(_cCBarr,15,1))*7
	_cVar16 := Val(Subs(_cCBarr,16,1))*6;	_cVar17	:= Val(Subs(_cCBarr,17,1))*5
	_cVar18 := Val(Subs(_cCBarr,18,1))*4;	_cVar19	:= Val(Subs(_cCBarr,19,1))*3
	_cVar20 := Val(Subs(_cCBarr,20,1))*2;	_cVar21	:= Val(Subs(_cCBarr,21,1))*9
	_cVar22 := Val(Subs(_cCBarr,22,1))*8;	_cVar23	:= Val(Subs(_cCBarr,23,1))*7
	_cVar24 := Val(Subs(_cCBarr,24,1))*6;	_cVar25	:= Val(Subs(_cCBarr,25,1))*5
	_cVar26 := Val(Subs(_cCBarr,26,1))*4;	_cVar27	:= Val(Subs(_cCBarr,27,1))*3
	_cVar28 := Val(Subs(_cCBarr,28,1))*2;	_cVar29	:= Val(Subs(_cCBarr,29,1))*9
	_cVar30 := Val(Subs(_cCBarr,30,1))*8;	_cVar31	:= Val(Subs(_cCBarr,31,1))*7
	_cVar32 := Val(Subs(_cCBarr,32,1))*6;	_cVar33	:= Val(Subs(_cCBarr,33,1))*5	
	_cVar34 := Val(Subs(_cCBarr,34,1))*4;	_cVar35	:= Val(Subs(_cCBarr,35,1))*3
	_cVar36 := Val(Subs(_cCBarr,36,1))*2;	_cVar37	:= Val(Subs(_cCBarr,37,1))*9
	_cVar38 := Val(Subs(_cCBarr,38,1))*8;	_cVar39	:= Val(Subs(_cCBarr,39,1))*7
	_cVar40 := Val(Subs(_cCBarr,40,1))*6;	_cVar41	:= Val(Subs(_cCBarr,41,1))*5
	_cVar42 := Val(Subs(_cCBarr,42,1))*4;	_cVar43	:= Val(Subs(_cCBarr,43,1))*3
	_cVar44 := Val(Subs(_cCBarr,44,1))*2	

	_cCampo1 := _cVar1+_cVar2+_cVar3+_cVar4+_cVar6+_cVar7+_cVar8+_cVar9+_cVar10+;
				 _cVar11+_cVar12+_cVar13+_cVar14+_cVar15+_cVar16+_cVar17+_cVar18+;
				 _cVar19+_cVar20+_cVar21+_cVar22+_cVar23+_cVar24+_cVar25+_cVar26+;
				 _cVar27+_cVar28+_cVar29+_cVar30+_cVar31+_cVar32+_cVar33+_cVar34+;
				 _cVar35+_cVar36+_cVar37+_cVar38+_cVar39+_cVar40+_cVar41+_cVar42+;
				 _cVar43+_cVar44
	   
	_cDivid1 := (_cCampo1 % 11)		
	_cCampo1 := 11 - _cDivid1
//	_cCampo1 := If(_cCampo1 == 10,0,_cCampo1)
	_cCampo1 := StrZero(_cCampo1,1,0)
		
	If _cCampo1 <> SubStr(_cCBarr,5,1)
	   Help(" ",1,"INVALCODBAR")
	   _lRet := .F.
	Else
	   _lRet := .T.
	EndIf
		
Endif
	
Return(_lRet)