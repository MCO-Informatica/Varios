#include "rwmake.ch" 

User Function RFINA99()

_cPerg      := "FIN21M    "
_cRisco     := "A"
_DifLim     := 0
_LimiteB 	:= 2	//----> 02 dias de atraso para risco B
_LimiteC 	:= 10	//----> 10 dias de atraso para risco C
_LimiteD 	:= 30	//----> 30 dias de atraso para risco D
mv_par01    := 60   //----> 60 dias de atraso para cima risco E  

//ValidPerg()     //----> verifica se existe grupo de perguntas no SX1

//Pergunte( _cPerg, .t. )

Processa({||Clientes()},"Administração do Risco de Crédito do Clientes")
Return

Static Function Clientes()


dbSelectArea("SA1")
dbSetOrder(1)
dbGoTop()

ProcRegua(RecCount())
While Eof() == .f.

	IncProc("Processando Cliente: "+SA1->A1_COD+"/"+SA1->A1_LOJA+" "+ALLTRIM(SA1->A1_NREDUZ))

	dbSelectArea("SE1")
	dbSetOrder(8)
	If dbSeek(xFilial("SE1")+SA1->(A1_COD+A1_LOJA),.F.)	
	
		If SE1->E1_TIPO $ "NCC AB- IN- IS- IR- PI- CS- CF-" .Or. SE1->E1_STATUS == 'B' .Or. SE1->E1_VENCREA >= dDataBase
			_cRisco := "A"
		Else
		
			_DifLim 	:=	dDataBase - SE1->E1_VENCREA
		
			//----> verifica se o tempo de atraso encaixa-se no risco E
			If _DifLim >= mv_par01
				_cRisco := "E"
			
			//----> verifica se o tempo de atraso encaixa-se no risco D
			ElseIf _DifLim < mv_par01 .And. _DifLim >= _LimiteD
				_cRisco := "D"
				
			//----> verifica se o tempo de atraso encaixa-se no risco C
			ElseIf _DifLim < _LimiteD .And. _DifLim >= _LimiteC
				_cRisco := "C"
				
			//----> verifica se o tempo de atraso encaixa-se no risco B
			ElseIf _DifLim < _LimiteC .And. _DifLim >= _LimiteB
				_cRisco := "B"
				
			//----> verifica se encaixa-se no risco A
			ElseIf _DifLim < _LimiteB
				_cRisco := "A"
			EndIf
		
		EndIf
	
		dbSelectArea("SA1")
		RecLock("SA1",.f.)
		SA1->A1_RISCO     :=  _cRisco
		MsUnLock()
	
	//----> caso nao exista contas a receber o risco sempre sera A
	Else
		dbSelectArea("SA1")
		RecLock("SA1",.f.)
		SA1->A1_RISCO     :=  "A"
		MsUnLock()
	EndIf
	
	dbSelectArea("SA1")
	dbSkip()
EndDo

Return



Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(_cPerg)
	
	aRegs := {}
	
	aadd(aRegs,{_cPerg,'01','Nr. Dias Risco E ? ','mv_ch1','N',03, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
	
	For i:=1 to Len(aRegs)
		Dbseek(_cPerg+StrZero(i,2))
		If found() == .f.
			RecLock("SX1",.t.)
			For j:=1 to Fcount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnLock()
		EndIf
	Next
EndIf

Return()

