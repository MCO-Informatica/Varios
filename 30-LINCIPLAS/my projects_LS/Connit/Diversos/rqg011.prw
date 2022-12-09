#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg011  			 Ricardo Felipelli   º Data ³  19/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige a conta contabil no cadastro de clientes          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg011()
Local _Opcao := .f.

If MsgYesNO("Corrige as contas no cadastro de clientes  ??  ","executa")
	Processa({|| CorrSA1()},"Processando...")
EndIf


Return nil

Static Function CorrSA1()

DbSelectArea("SX5")
Dbsetorder(01)

Dbselectarea("SA1")
dbsetorder(1)

DBUseArea( .T.,,"CLI1", "TRBCLI", .F., .F. )
cChave := "N1"
cindex := Criatrab(Nil,.F.)
IndRegua("TRBCLI",cindex,cChave,,,"Selecionando Registros")
ProcRegua( LastRec() )


cArqSaida := CriaTrab( , .F. )
nHdlArq   := FCreate(cArqSaida)
cCRLF     := CHR(13)+CHR(10)

If nHdlArq==-1
	MsgStop("Nao foi possivel criar o arquivo "+cArqSaida+", Verificar...")
	Return nil
EndIf

cLine := "INICIANDO O LOG - Correcao SA1010 " + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "-------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))


while TRBCLI->(!eof())                                                                                      

    _ccod   := strzero(TRBCLI->N1,6)
//    _cloja  := strzero(TRBCLI->LOJA,2)  
    _cloja  := subst(TRBCLI->LOJA,1,2)
    _cconta := str(TRBCLI->CONTA,8)
	IncProc( _ccod )

	SA1->(dbseek(space(02)+_ccod+_cloja))
	if SA1->(FOUND())               
		RecLock("SA1",.F.)
		SA1->A1_CONTA := _cconta
		if _cconta == '11260006'
			SA1->A1_NATUREZ := "CIA"
		endif
		MsUnlock()
		cLine := "Alterado: " +_ccod +"/"+_cloja +" Conta: " + _cconta + cCRLF
		fWrite(nHdlArq,cLine,Len(cLine))
	endif
		
	TRBCLI->(dbskip())
	
enddo

dbselectarea("TRBCLI")
dbclosearea()

return nil
