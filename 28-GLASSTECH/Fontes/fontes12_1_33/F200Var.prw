#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF200VAR   บAutor  ณ Rodrigo Pirolo     บ Data ณ  15/05/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada no retorno do cnab de contas a receber.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F200Var()
//Local aArea	:= GetArea()        
Local cE1_NUM	:= ""
Local cE1_PARC	:= ""
Local _aValores := ParamIxb
Local cAux		:= ""

//Se for CNAB Recebimento
If AllTrim(Upper(mv_par05))$ "BRDFAC.RET|"
    If cTipo <> "NF"
       cTipo   := RIGHT("00"+RTRIM(cTipo),2)
    EndIf
	cTipo	:= PegaTipoTit(cTipo)
	
	If At("/", _aValores[1,1]) > 0
		cE1_NUM 	:=	StrZero(Val(Substring(_aValores[1,1], 1, At("/", _aValores[1,1])-1)),TamSx3("E1_NUM")[1])
		cE1_PARC	:=	ConvParc(_aValores[1,1])
		
		cE1_NUM := TrataNumTit(cE1_NUM)
		
		_aValores[1,1]	:=	U_AchaTitu(cE1_NUM, cE1_PARC, _aValores[1,3], _aValores[1,8], _aValores[1,9])
		cNumTit 		:= _aValores[1,1]
		
		
	Else
		cE1_NUM 	:=	StrZero(Val(Substring(_aValores[1,1], 1, 7)),TamSx3("E1_NUM")[1])
		cE1_PARC	:=	Right(AllTrim(_aValores[1,1]), 1)
		
		//cE1_NUM 	:= TrataNumTit(cE1_NUM)
		
		cAux		:= U_AchaTitu(cE1_NUM, cE1_PARC, cTipo, _aValores[1,8], _aValores[1,9])
		
		//Algumas FIDCs enviam numero 2 na frente do titulo, por este motivo, se nใo encontrar o titulo, tenta localizar desconsiderando o "2 " 
		/*
		If Empty(cAux) .AND. Substring(_aValores[1,1], 1, 1) == "2"
			cE1_NUM 	:=	StrZero(Val(Substring(_aValores[1,1], 2, 6)),TamSx3("E1_NUM")[1])
			cE1_PARC	:=	Right(AllTrim(_aValores[1,1]), 1)
			
			cAux		:=	U_AchaTitu(cE1_NUM, cE1_PARC, cTipo, _aValores[1,8], _aValores[1,9])
		EndIf
		*/
		If ( Empty(cAux) .or. se1->e1_valor != 0 .AND. se1->e1_valor != (_aValores[1,8]-_aValores[1,9]) ) .AND. Substring(_aValores[1,1], 1, 1) $ "2/1"
			cE1_NUM 	:=	StrZero(Val(Substring(_aValores[1,1], 2, LEN(AllTrim(_aValores[1,1]))-2)),TamSx3("E1_NUM")[1])
			cE1_PARC	:=	Right(AllTrim(_aValores[1,1]), 1)
			
			cAux		:=	U_AchaTitu(cE1_NUM, cE1_PARC, cTipo, _aValores[1,8], _aValores[1,9])
		EndIf

		If Empty(cAux)
			If At("SB", MV_PAR04)>0 .AND. At("AG.RET", UPPER(MV_PAR04))>0
				cE1_NUM	:=	StrZero(Val(Substring(_aValores[1,1], 1, Len(_aValores[1,1])-5)),TamSx3("E1_NUM")[1])

			elseif At("SB", MV_PAR04)>0 .AND. At("TW.RET", UPPER(MV_PAR04))>0
				cE1_NUM	:=	StrZero(Val(Substring(_aValores[1,1], 1, Len(_aValores[1,1])-4)),TamSx3("E1_NUM")[1])
			EndIf
				
			cE1_PARC	:=	ConvPar2(Right(AllTrim(_aValores[1,1]), 1))

			cAux		:=	U_AchaTitu(cE1_NUM, cE1_PARC, cTipo, _aValores[1,8], _aValores[1,9])
		EndIf
		
		cNumTit 		:= cAux
		_aValores[1,1]	:= cAux
	EndIf

EndIf

//RestArea(aArea)

Return _aValores[1]

Static Function ConvParc(cNum)
Local cRet		:= "A"
Local nI		:= 0
Local nParc		:= Val(Substring(cNum, At("/", cNum)+1, 3))

For nI := 1 to nParc
	If nI > 1
		cRet := Soma1(cRet)
	EndIf
Next nI

Return cRet


Static Function ConvPar2(cPar)
Local cRet		:= "A"
Local nI		:= 0
Local nParc		:= Val(Substring(cPar, At("/", cPar)+1, 3))

For nI := 1 to nParc
	If nI > 1
		cRet := Soma1(cRet)
	EndIf
Next nI

Return cRet


Static Function PegaTipoTit(cTipo)
Local cRet := cTipo

If cTipo <> "NF"
	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	
	If SX5->(DbSeek(xFilial("SX5")+"17"))
		While SX5->(!Eof() .AND. X5_FILIAL+X5_TABELA == xFilial("SX5")+"17")
			If AllTrim(SX5->X5_DESCRI) == AllTrim(cTipo)
				cRet := SX5->X5_CHAVE
			EndIf
			SX5->(DbSkip())
		End
	EndIf
EndIf
Return cRet

Static Function TrataNumTit(cNum)

//Para 
If AllTrim(MV_PAR06) == "237" .AND. AllTrim(MV_PAR07) == "0000" .AND. Alltrim(MV_PAR08) == "00002"
	cNum := StrZero(val(Substring(cNum, 5, 9)),TamSx3("E1_NUM")[1])	
EndIf

Return cNum
