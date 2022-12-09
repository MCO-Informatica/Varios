#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg016  			 Ricardo Felipelli   º Data ³  12/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ corrige natureza na tabela se2 a partir da entrada sd1     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg016()
Local _Opcao := .f.

If MsgYesNO("Corrige SE2 a partir da nf de entrada ??  ","executa")
	Processa({|| CorrSE2()},"Processando...")
EndIf

Return nil


Static Function CorrSE2()

DbSelectArea("SD1")
Dbsetorder(01)
DbSelectArea("SE2")
Dbsetorder(01)
DbSelectArea("SED")
Dbsetorder(01)

cArqSaida := CriaTrab( , .F. )
nHdlArq   := FCreate(cArqSaida)
cCRLF     := CHR(13)+CHR(10)

If nHdlArq==-1
	MsgStop("Nao foi possivel criar o arquivo "+cArqSaida+", Verificar...")
	Return nil
EndIf

cLine := "INICIANDO O LOG - Ajuste da Naturezas do SE2 a partir do Fornecedor da SD1 " + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "-------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))


ProcRegua( LastRec() )

//E2_FORNECE=D1_FORNECE AND E2_LOJA=D1_LOJA AND E2_NUM = D1_DOC
while se2->(!eof())
	IncProc( SE2->E2_FILIAL+' - '+SE2->E2_NUM )
	cQuery := " SELECT * FROM "
	cQuery += RetSqlName("SD1")+" SD1 (NOLOCK),  "
	cQuery += " WHERE SD1.D1_FILIAL = '" + SE2->E2_FILORIG + "'"
	cQuery += " AND SD1.D1_FORNECE = '" + SE2->E2_FORNECE + "'"
	cQuery += " AND SD1.D1_LOJA = '" +  SE2->E2_LOJA + "'"
	cQuery += " AND SD1.D1_DOC = '" + SE2->E2_NUM + "'"
	cQuery += " AND SD1.D_E_L_E_T_ = '' "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
	
	if TRB->(!eof())
		SA2->(dbseek(XFILIAL("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA))
		if SA2->(found())
			IF !EMPTY(SA2->A2_NATUREZ)
				SED->(dbseek(xfilial("SED"+SA2->A2_NATUREZ)))
				cLine := "Anterior: " + SE2->E2_NATUREZ + " Depois: " + SA2->A2_NATUREZ + cCRLF
				fWrite(nHdlArq,cLine,Len(cLine))
				RecLock("SE2",.F.)
				SE2->E2_NATUREZ := SA2->A2_NATUREZ
				if SED->(found())
					SE2->E2_DEBITO := SED->ED_CONTA
				endif
				MsUnLock()
			ENDIF
		endif
	endif
	
	TRB->(DBCLOSEAREA())
	
	se2->(dbskip())
enddo

return nil

