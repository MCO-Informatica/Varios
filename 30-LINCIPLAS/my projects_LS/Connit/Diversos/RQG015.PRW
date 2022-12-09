#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg015  			 Ricardo Felipelli   º Data ³  19/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige natureza e conta contabil no cadastro de fornecedorº±±
±±º          ³ de servicos                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg015()
Local _Opcao := .f.

If MsgYesNO("Corrige Cad.Fornecedor de Servicos","executa")
	Processa({|| CorrSA2()},"Processando...")
EndIf

Return nil


Static Function CorrSA2()
Local aATFA010 := {}
Local aItens   := {}
Local aLinha   := {}
Local _arquivo := ""
Local _arquivo2:= "\system\FORSERV1.dtc"

dbselectarea("SA2")
dbsetorder(01)

DBUseArea( .T.,,"FORSERV1", "TMPFOR", .F., .F. )
cChave := "FORN"
cindex := Criatrab(Nil,.F.)
IndRegua("TMPFOR",cindex,cChave,,,"Selecionando Registros")
dbGoTop()

cArqSaida := CriaTrab( , .F. ) + '.log'
nHdlArq   := FCreate(cArqSaida)
cCRLF     := CHR(13)+CHR(10)

If nHdlArq==-1
	MsgStop("Nao foi possivel criar o arquivo "+cArqSaida+", Verificar...")
	Return nil
EndIf

cLine := "INICIANDO O LOG - Corrige Natureza/Contas do cadastro de Fornecedores de Servicos" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "---------------------------------------------------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))



while TMPFOR->(!eof())   
	if empty(TMPFOR->FORN)
		TMPFOR->(DBSKIP())
		LOOP
	endif
	_codfor := strzero(TMPFOR->FORN,6)
	_lojfor := strzero(TMPFOR->LOJA,2)


	SA2->(dbseek(xfilial("SA2")+_codfor+_lojfor))
	if SA2->(found())
		if TMPFOR->NATUR <> space(15)          
			if alltrim(SA2->A2_NATUREZ) <> alltrim(TMPFOR->NATUR)
				cLine := "Forn: " + SA2->A2_COD +"-"+ SA2->A2_LOJA +" "+ SA2->A2_NREDUZ +" Old Naturea: "+ SA2->A2_NATUREZ +" New Naturea: "+ TMPFOR->NATUR
				cLine += " Old Conta: " + SA2->A2_CONTA + " New Conta: " + TMPFOR->NEWCTA + cCRLF
				fWrite(nHdlArq,cLine,Len(cLine)) 
				RecLock("SA2",.F.)
				SA2->A2_NATUREZ := TMPFOR->NATUR
				SA2->A2_CONTA := TMPFOR->NEWCTA
				MsUnLock()
			endif
		endif
	endif
	dbselectarea("TMPFOR")
	TMPFOR->(dbskip())
enddo

dbselectarea("TMPFOR")
TMPFOR->(dbclosearea())
                            
fclose(nHdlArq)

LjMsgRun("Aguarde a exibicao do Log.",,{|| WaitRun("WRITE "+cArqSaida) } )


return nil


