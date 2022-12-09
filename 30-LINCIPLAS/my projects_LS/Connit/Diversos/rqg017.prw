#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg017  			 Ricardo Felipelli   º Data ³  24/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ corrige SX6 duplicado                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg017()
Local _Opcao := .f.

If MsgYesNO("Remove registros duplicados na tabela SX6 ??  ","executa")
	Processa({|| CorrSX6()},"Processando...")
EndIf

Return nil


Static Function CorrSX6()

DbSelectArea("SX6")     
--Dbsetorder(01)
cChave := "X6_FIL + X6_VAR + X6_DESCRIC"
cindex := Criatrab(Nil,.F.)
IndRegua("SX6",cindex,cChave,,,"Selecionando Registros")


cArqSaida := CriaTrab( , .F. )
nHdlArq   := FCreate(cArqSaida)
cCRLF     := CHR(13)+CHR(10)

If nHdlArq==-1
	MsgStop("Nao foi possivel criar o arquivo "+cArqSaida+", Verificar...")
	Return nil
EndIf

cLine := "INICIANDO O LOG - Remocao de registros duplicados na SX6 " + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "-------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))


ProcRegua( LastRec() )
                             
while SX6->(!eof())
	IncProc( SX6->X6_FIL + "-" + SX6->X6_VAR )
	_filial := SX6->X6_FIL 
	_var    := SX6->X6_VAR
	_desc   := SX6->X6_DESCRIC
                              
	SX6->(dbskip())
	_qtddel:=0
	while SX6->(!eof()) .and. _filial==SX6->X6_FIL .and. _var==SX6->X6_VAR .and. _desc==SX6->X6_DESCRIC   
			RecLock("SX6",.F.)
			SX6->(DbDelete())
			MsUnLock()    
			_qtddel++
			SX6->(dbskip())
	enddo

	if _qtddel <> 0
		cLine := "Filial: " + SX6->X6_FIL + " Variavel: " + SX6->X6_VAR + "-" + SX6->X6_DESCRIC + "DELETOU: " +STR(_qtddel,3) + cCRLF
		fWrite(nHdlArq,cLine,Len(cLine)) 
	endif

enddo

                               
alert(cArqSaida)


return nil


