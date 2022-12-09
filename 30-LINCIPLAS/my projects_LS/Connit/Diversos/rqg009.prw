#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg009  			 Ricardo Felipelli   º Data ³  13/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige tabela se5 com natureza DEPOSITO      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg009()
Local _Opcao := .f.

If MsgYesNO("Corrige as contas da natureza (SANGRIA)  ??  ","executa")
	Processa({|| CorrSE5()},"Processando...")
EndIf


Return nil

Static Function CorrSE5()

DbSelectArea("SX5")
Dbsetorder(01)

Dbselectarea("SE5")
dbsetorder(1)
SE5->(dbgotop())
ProcRegua( LastRec() )

_proc:=0
_atual:=0

while SE5->(!eof())
	IncProc( SE5->E5_HISTOR )
	IF SE5->E5_NATUREZ <> 'SANGRIA'    
		_proc++
		SE5->(dbskip())
		LOOP
	ENDIF

	if SE5->E5_FILIAL $  ("A0,A1,A2") // aerolivros
		RecLock("SE5",.F.)
		SE5->E5_DEBITO := '11111001'
		MsUnLock()                    
		                     
	elseif SE5->E5_FILIAL $ ("CO,C1,C2,C3,C4,C5,C6,C7,C8,C9,CA")  // clio
		RecLock("SE5",.F.)
		SE5->E5_DEBITO := '11111002'
		MsUnLock()                                         
		
	elseif SE5->E5_FILIAL $ ("G0,G1,G2,G3,G4,G5,G6,G7,G8,G9,GA,GB,GC,GD,GF,GG")  // guanabara
		RecLock("SE5",.F.)
		SE5->E5_DEBITO := '11111003'
		MsUnLock()                                         

	elseif SE5->E5_FILIAL $ ("01,02,04,05,10,14,15,16,17,20,22,25,26,27,28,29,38,56,81,83,85,89")  // laselva
		RecLock("SE5",.F.)
		SE5->E5_DEBITO := '11111004'
		MsUnLock()                                         

	elseif SE5->E5_FILIAL $ ("BH")  // pampulha
		RecLock("SE5",.F.)
		SE5->E5_DEBITO := '11111005'
		MsUnLock()                                         

	elseif SE5->E5_FILIAL $ ("R0,R1,R2,R3,R4,R5")  // rede lss
		RecLock("SE5",.F.)
		SE5->E5_DEBITO := '11111006'
		MsUnLock()                                         

	elseif SE5->E5_FILIAL $ ("T0,T1,T2,T3,T4")  // torcan
		RecLock("SE5",.F.)
		SE5->E5_DEBITO := '11111007'
		MsUnLock()                                         

	endif
                    
	_proc++
	_atual++

	SE5->(dbskip())
	
enddo

Alert("Processou: "+str(_proc) + " Atualizou: "+str(_atual))            

return nil
