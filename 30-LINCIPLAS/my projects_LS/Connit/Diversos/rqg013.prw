#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg013			 Ricardo Felipelli   º Data ³  28/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige campos e5_filial, e5_filorig, e5_moeda, e5_tipodoc º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg013()

Local _Opcao := .f.

If MsgYesNO("Corrige o processo de tranferencia bancaria  ??  ","executa")
	Processa({|| CorrSA1()},"Processando...")
EndIf


Return nil

Static Function CorrSA1()

Dbselectarea("SA6")
dbsetorder(1)
Dbselectarea("SE5")
dbsetorder(1)

cArqSaida := CriaTrab( , .F. )
nHdlArq   := FCreate(cArqSaida)
cCRLF     := CHR(13)+CHR(10)

If nHdlArq==-1
	MsgStop("Nao foi possivel criar o arquivo "+cArqSaida+", Verificar...")
	Return nil
EndIf

cLine := "INICIANDO O LOG - Correcao das Transferencias Bancarias " + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "-------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))


while SE5->(!eof())
	
	IncProc( SE5->E5_VALOR )
	
	if SE5->E5_TIPODOC <> 'TRC'
		SE5->(DBSKIP())
		LOOP
	endif
	if SE5->E5_TIPODOC <> 'TR'
		SE5->(DBSKIP())
		LOOP
	endif
	if SE5->E5_MOEDA <> 'TB'
		SE5->(DBSKIP())
		LOOP
	endif
	if SE5->E5_RECPAG <> 'P'
		SE5->(DBSKIP())
		LOOP
	endif
	
	cLine := "Filial Origem: " + SE5->E5_FILIAL
	cLine += " Banco: " + SE5->E5_BANCO
	cLine += " Agencia: " + SE5->E5_AGENCIA
	cLine += " Conta: " + SE5->E5_CONTA
	cLine += " Documento: " + SE5->E5_NUMCHEQ
	cLine += " Data: " + dtos(SE5->E5_DATA)
	cLine += " Valor: " + str(SE5->E5_VALOR)
	cLine += cCRLF
	fWrite(nHdlArq,cLine,Len(cLine))
	
	_nRecno  := SE5->(Recno())
	_filial  := SE5->E5_FILIAL
	_banco   := SE5->E5_BANCO
	_agencia := SE5->E5_AGENCIA
	_conta   := SE5->E5_CONTA
	_doc     := SE5->E5_NUMCHEQ
	_data    := SE5->E5_DATA
	_valor   := SE5->E5_VALOR
	
	
	cQuery := " SELECT * FROM "
	cQuery += RetSqlName("SE5")+" SE5 (NOLOCK),  "
	cQuery += " WHERE E5_FILIAL = '" + _filial + "'"
	cQuery += " AND E5_DATA = '" + dtos(_data) + "'"
	cQuery += " AND E5_VALOR = " + str(_valor)
	cQuery += " AND E5_DOCUMEN = '" + _doc + "'"
	cQuery += " AND D_E_L_E_T_ = '' "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
	
	//E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ
	SE5->(dbseek(TRB->E5_FILIAL + TRB->E5_DATA + TRB->E5_BANCO + TRB->E5_AGENCIA + TRB->E5_CONTA + TRB->E5_NUMCHEQ))
	
	
	if SE5->(found())
		if SE5->E5_RECPAG == 'R'
			//A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
			SA6->(DBSEEK(xfilial("SA6") + TRB->E5_BANCO + TRB->E5_AGENCIA + TRB->E5_CONTA))
			if SA6->(found())
				cLine := "Filial Destino: " + SE5->E5_FILIAL
				cLine += " Banco: " + SE5->E5_BANCO
				cLine += " Agencia: " + SE5->E5_AGENCIA
				cLine += " Conta: " + SE5->E5_CONTA
				cLine += " Documento: " + SE5->E5_NUMCHEQ
				cLine += " Data: " + dtos(SE5->E5_DATA)
				cLine += " Valor: " + str(SE5->E5_VALOR)
				cLine += cCRLF
				fWrite(nHdlArq,cLine,Len(cLine))
				
				RecLock("SE5",.F.)
				SE5->E5_FILORIG := SA6->A6_DEPTO
				SE5->E5_MOEDA   := 'M1'
				SE5->E5_TIPODOC := '  '
				SE5->E5_FILIAL  := SA6->A6_DEPTO
				MsUnLock()
				
				cLine := "** Alterado: Filial Destino: " + SE5->E5_FILIAL
				cLine += " Moeda: M1,  TipoDoc: '  '" + SE5->E5_BANCO
				cLine += cCRLF
				fWrite(nHdlArq,cLine,Len(cLine))
			endif
		endif
	endif
	SE5->(DbGoto(_nRecno))
	SE5->(DBSKIP())
	TRB->(DBCLOSEAREA())
	
	
enddo


return nil
