#include "rwmake.ch" 

User Function KFIN21M()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN21M  ³ Autor ³Ricardo Correa de Souza³ Data ³13/09/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica os Titulos Vencidos e Ajusta o Risco dos Clientes ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

_cPerg      := "FIN21M    "
_cRisco     := "B"
_DifLim     := 0
_LimiteB 	:= 2	//----> 02 dias de atraso para risco B
_LimiteC 	:= 10	//----> 10 dias de atraso para risco C
_LimiteD 	:= 30	//----> 30 dias de atraso para risco D


ValidPerg()     //----> verifica se existe grupo de perguntas no SX1

Pergunte( _cPerg, .t. )

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
			_cRisco := "B"
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
				_cRisco := "B"
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
		SA1->A1_RISCO     :=  "B"
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

