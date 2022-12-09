#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg003  			 Ricardo Felipelli   º Data ³  20/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de catalogo do Ativo                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg003()
Local _Opcao := .f.

If MsgYesNO("Valida o arquivo PRO_SN3 antes de integração ? PLANO DE CONTAS ","executa")
	Processa({|| ImpAtiv()},"Processando...")
EndIf

Return nil


Static Function ImpAtiv()
Local aATFA010 := {}
Local aItens   := {}
Local aLinha   := {}
Local _arquivo := "e:\DBF_CUST.dtc"
Local _arquivo2:= "\system\PRO_SN3.dtc"

dbselectarea("CT1")
dbsetorder(01)

DBUseArea( .T.,,"PRO_SN3", "TMPSN3", .F., .F. )
cChave := "N3_CCONTAB"
cindex := Criatrab(Nil,.F.)
IndRegua("TMPSN3",cindex,cChave,,,"Selecionando Registros")


cArqSaida := CriaTrab( , .F. )
nHdlArq   := FCreate(cArqSaida)
cCRLF     := CHR(13)+CHR(10)

If nHdlArq==-1
	MsgStop("Nao foi possivel criar o arquivo "+cArqSaida+", Verificar...")
	Return nil
EndIf

cLine := "INICIANDO O LOG - ATIVO FIXO - PLANO DE CONTAS" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "-------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))



while TMPSN3->(!eof())                                                                                      

	if empty(TMPSN3->N3_CCONTAB)
		TMPSN3->(dbskip())
		loop
	endif
	_conta := TMPSN3->N3_CCONTAB
	CT1->(dbseek(space(02)+TMPSN3->N3_CCONTAB))
	if CT1->(!found())
		cLine := 	TMPSN3->N3_CCONTAB + cCRLF
		fWrite(nHdlArq,cLine,Len(cLine)) 
		cLine := space(50) + cCRLF
		fWrite(nHdlArq,cLine,Len(cLine))
	endif
	while _conta == TMPSN3->N3_CCONTAB
		TMPSN3->(dbskip())
		loop
	enddo
enddo

dbselectarea("TMPSN3")
TMPSN3->(dbclosearea())   
MsgStop("Temporario: "+cArqSaida)


return nil


