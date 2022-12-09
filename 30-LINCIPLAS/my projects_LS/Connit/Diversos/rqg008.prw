#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg008  			 Ricardo Felipelli   º Data ³  12/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige tabela se5 com natureza DEPOSITO      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg008()
Local _Opcao := .f.

If MsgYesNO("Corrige as contas da natureza (DEPOSITO)  ??  ","executa")
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


while SE5->(!eof())
	IncProc( SE5->E5_HISTOR )
	IF SE5->E5_NATUREZ <> 'DEPOSITO'
		SE5->(dbskip())
		LOOP
	ENDIF
	
	SX5->(dbseek(space(02)+'ZD'+SE5->E5_FILIAL))
	if SX5->(found())
		_conta := alltrim(SX5->X5_DESCRI)
	else
		_conta := ''
	endif
	
//	if SE5->E5_DEBITO <> _conta
		if subst(SE5->E5_HISTOR,1,14) == 'MOVTO EM REAIS'
			if _conta <> ''
				RecLock("SE5",.F.)
				SE5->E5_DEBITO := _conta
				MsUnLock()
			endif
		elseif subst(SE5->E5_HISTOR,1,14) == 'SOBRA EM REAIS'
			RecLock("SE5",.F.)
			SE5->E5_DEBITO := '55512002'
			MsUnLock()
		elseif subst(SE5->E5_HISTOR,1,14) == 'FALTA EM REAIS'
			RecLock("SE5",.F.)
			SE5->E5_DEBITO := '43011009'
			MsUnLock()
		endif
//	endif
	SE5->(dbskip())
	
	
enddo

return nil
