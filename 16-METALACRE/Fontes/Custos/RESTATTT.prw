#include "rwmake.ch"
#include "protheus.ch"

User Function RESTATTT(aCustos,lTitulo)
Local _nValor	:= 0                                                             
Local aArea     := GetArea()
Private oProcess

DEFAULT lTitulo := .F.


oProcess := MsNewProcess():New( { || aCustos:=fRestaTTT(aCustos) } , Iif(!lTitulo,'Processando Custos',"Custos - Prd/Opc: ("+AllTrim(SB1->B1_COD)+')('+AllTrim(SGA->GA_OPC)+')')  , "Aguarde..." , .F. )
oProcess:Activate()

RestArea(aArea)
Return aCustos

Static Function fRestaTTT(aCustos)

Local _nValor	:= 0
Local _nFator	:= 1
Local _nResc1	:= 0
Local _nResc2	:= 0
Local _dData 	:= _dDataCtb //LastDate(MonthSub(dDataBase,1))

//Seu codigo
//sua primeira query
oProcess:SetRegua1( Len(aCustos) ) //Alimenta a primeira barra de progresso
For nCusto := 1 To Len(aCustos)
	oProcess:IncRegua1("Processando Centro de Custo")
	
	_cCustoIni 	:= aCustos[nCusto,2]
	_cCustoFim 	:= aCustos[nCusto,3]
	_nValor		:= 0.00
	_nResc1		:= 0.00
	_nResc2		:= 0.00
	
	dbSelectArea("CTT")
	dbSetOrder(1)           
	If dbSeek(xFilial("CTT")+_cCustoIni,.f.)
        oProcess:SetRegua2( 0 ) //Alimenta a segunda barra de progresso
		While CTT->(!Eof()) .And. CTT->CTT_CUSTO <= _cCustoFim .And. CTT->CTT_FILIAL == xFilial("CTT")
            oProcess:IncRegua2("Processando ("+AllTrim(Str(nCusto))+'/'+AllTrim(Str(Len(aCustos)))+") C.Custo -> " + CTT->CTT_CUSTO)
			
			If aCustos[nCusto,1]$"004.005.006"
				If Subs(CTT->CTT_CUSTO,9,3)$"000.001"
					_nValor:= _nValor + MovCusto("ZZZZZZZZZZZZZZZZZZZZ",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
				
					If Subs(CTT->CTT_CUSTO,1,3)$"1.1"
						_nResc1:= _nResc1 + MovCusto("41122013",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
						_nResc2:= _nResc2 + MovCusto("41122026",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
					Else
						_nResc1:= _nResc1 + MovCusto("42110013",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
						_nResc2:= _nResc2 + MovCusto("42110026",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
					EndIf
					
					//Alert(CTT->CTT_CUSTO+" - "+Str(_nResc1)+" - "+Str(_nResc2))
				EndIf
			ElseIf aCustos[nCusto,1]$"014.015.016"
				If Subs(CTT->CTT_CUSTO,9,3)$"999"
					_nValor:= _nValor + MovCusto("ZZZZZZZZZZZZZZZZZZZZ",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3) 
				EndIf
			Else
				_nValor:= _nValor + MovCusto("ZZZZZZZZZZZZZZZZZZZZ",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3) 
				_nResc1:= _nResc1 + MovCusto("41121013",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
				_nResc2:= _nResc2 + MovCusto("41121026",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
			EndIf
			
			If aCustos[nCusto,1]$"XXX"
				If Subs(CTT->CTT_CUSTO,9,3)$"000.001"
				
					If Subs(CTT->CTT_CUSTO,1,3)$"1.1"
						_nComis:= _nComis + MovCusto("41122017",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
					Else
						_nComis:= _nComis + MovCusto("42110017",CTT->CTT_CUSTO,FirstDate(_dData),LastDate(_dData),"01","1",3)
					EndIf
					
				EndIf
			
			
			
			CTT->(dbSkip(1))
			
		EndDo         
	EndIf   
	
	If _nValor < 0
		_nValor := _nValor * (-1)
	EndIf

	If _nResc1 < 0
		_nResc1 := _nResc1 * (-1)
	EndIf
	
	If _nResc2 < 0
		_nResc2 := _nResc2 * (-1)
	EndIf
	
	_nValor := _nValor - Iif(_nRescisao=1,_nResc1,0) - Iif(_nRescisao=1,_nResc2,0)
	
	aCustos[nCusto,4] := Round(_nValor * _nFator,8)

Next

Return(aCustos)
