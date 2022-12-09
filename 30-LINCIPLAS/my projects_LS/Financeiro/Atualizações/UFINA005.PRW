#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FINA005  º Autor ³ Ricardo Felipelli  º Data ³  14/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Integracao do extrato eletronico                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UFINA005
Local _Opcao := .f.

If MsgYesNO("Confirma Importação dos Extrato Bancarios ?","Arquivos deverão estar no diretorio I:\FINANCEIRO\EXTRATO_IN")
	Processa({|| ExtratoBco()},"Importando Extratos...")
	MsgStop("Importação Finalizada!!!")
	
EndIf

Return nil



Static Function ExtratoBco()

cArqLog := Criatrab(nil,.f.)

nHdlArq:=FCreate(cArqLOG)
PAGI  :=  1
li    := 80
cLine := ""
cCRLF := CHR(13)+CHR(10)
If nHdlArq==-1
	tone(5000,1)
	alert("Impossivel Criar Arquivo LOG " + cArqLog + " Verificar...")
	Return nil
Endif
nCtErro:=0

cLine := "INICIANDO O LOG - INTEGRACAO EXTRATO BANCARIOS" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "-------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "DataBase...........: "+Dtoc(dDataBase) + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Data...............: "+Dtoc(MsDate()) + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Hora...............: "+Time() + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Environment........: "+GetEnvServer() + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))


cLine := "" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))
cLine := "" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

dbselectarea("SE5")
dbsetorder(01)
dbselectarea("SE2")
dbsetorder(01)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA / Abre os Arquivos de Trabalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArquivo  := Directory("\system\Integracao\Financeiro\Extrato_in\CCG*.DAT","D")
cDiretorio:= "\system\Integracao\Financeiro\Extrato_in\"



For n:=1 to Len(cArquivo)
	
	IncProc("Importando... Aguarde...")
	
	cLine := "Arquivo............: "+cArquivo[n][1]+cCRLF
	fWrite(nHdlArq,cLine,Len(cLine))
	
	// Validar lancamento se não tem no banco
	SZI->(DBSEEK(space(02)+cArquivo[n][1]))
	
	if SZI->(found())
		cLine := "  JA PROCESSADO EM: "+ SZI->ZI_DIA + ' AS ' + SZI->ZI_HORA+cCRLF
		fWrite(nHdlArq,cLine,Len(cLine))
		
	else
		
		_cArqOpen := cArquivo[n][1]
		cArqTrab  := "EXTRATO"
		aStru     := {}
		
		aStru	  := { {"TX_",    "C", 240, 0 } }
		
		dbCreate(cArqTrab,aStru)
		
		dbUseArea(.T.,,cArqTrab,"TXT",.F.,.F.)
		cChave := "TX_FILIAL"
		Append From &(cDiretorio+_cArqOpen) SDF
		
		//	IndRegua("TXT",cArqTrab,cChave,,,"Selecionando Registros...!")
		TXT->(dbGoTop())
		_linha   := 1
		_linha   := strzero(_linha,3)
		_doc     := 1
		
		
		DbSelectArea("TXT")
		ProcRegua(LastRec())
		
		// verifica se o arquivo disponivel trata-se de receita, pois os cartoes serão processados posteriormente.
		_banco     := subst(TXT->TX_,1,3)
		_agencia   := subst(TXT->TX_,53,5)
		_digagen   := subst(TXT->TX_,58,1)
		_conta     := subst(TXT->TX_,59,12)
		_digconta  := subst(TXT->TX_,71,1)
		_digctag   := subst(TXT->TX_,72,1)
		_cnpj      := subst(TXT->TX_,19,14)
		_E5_FILIAL := '  '
		dbselectarea('SM0')
		SM0->(dbgotop())
		while SM0->(!eof())
			if alltrim(SM0->M0_CGC) == alltrim(_cnpj)
				_E5_FILIAL := SM0->M0_CODFIL  
				exit
			endif
			SM0->(dbskip())
		enddo
		_bcoreceita := 0
		
		if _banco == '399' // HSBC
			if subs(_conta,8,5)+_digconta+_digctag == '1698398'
				_bcoreceita++
			endif
		elseif _banco == '001' // BANCO DO BRASIL
		elseif _banco == '341' // ITAU
		elseif _banco == '356' // REAL
		elseif _banco == '033' // SANTANDER
		elseif _banco == '104' // CAIXA ECONOMICA FEDERAL
		elseif _banco == '409' // UNIBANCO
		endif
		TXT->(dbskip())
		
		if _bcoreceita>0

			while TXT->(!eof())
				IncProc()
				if subs(TXT->TX_,8,1) <> '3'
					TXT->(dbskip())
					loop
				endif
				
				_datamov := ctod(subst(TXT->TX_,143,2)+'/'+subst(TXT->TX_,145,2)+'/'+subst(TXT->TX_,149,2))
				
				cQuery := " SELECT * FROM PAT010 (NOLOCK)  "
				cQuery += " WHERE PAT_FILIAL = '" + _E5_FILIAL + "'"
				cQuery += " AND PAT_DTFECH = '" + DTOS(_datamov) + "'"
				cQuery += " AND D_E_L_E_T_ = '' "

				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBPAT', .F., .T.)
				
				_totpat := 0
				WHILE TRBPAT->(!EOF())
					_totpat+=TRBPAT->PAT_VLRDIG
					TRBPAT->(dbskip())
				ENDDO
				
				// prepara os registro migrados da tabela txt
				_E5_DATA	:= subst(TXT->TX_,143,8)
				_E5_MOEDA	:= "R$"
				_E5_VALOR	:= subst(TXT->TX_,151,16)
				_E5_NATUREZ	:= "DEPOSITO"
				_E5_BANCO 	:= _banco
				_E5_AGENCIA	:= _agencia
				_E5_CONTA	:= _conta + digconta + _digctag
				_E5_DOCUMEN	:= xfilial("SE5")+subst(TXT->TX_,143,8)  //  + TMP->E_TURNO como fazer...
				_E5_VENCTO  := subst(TXT->TX_,143,8)
				_E5_RECPAG 	:= "R"
				_E5_BENEF   := Alltrim(GetAdvFVal("SM0","M0_NOME",cEmpAnt + xfilial("SE5"),1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + xfilial("SE5"),1))
				_E5_HISTOR  := "MOVTO BANCARIO DE TODOS FECHAMENTOS EM: "+DTOC(SE5->E5_DATA)+" PER.: "+TMP->E_TURNO
				_E5_DTDIGIT	:= subst(TXT->TX_,143,8)
				_E5_DTDISPO	:= subst(TXT->TX_,143,8)
				_E5_FILORIG := xfilial("SE5")
				_E5_MODSPB  := "4"
				
				Begin Transaction
				
				RecLock("SE5",.T.)
				SE5->E5_FILIAL 	    := _E5_FILIAL
				SE5->E5_DATA 		:= _E5_DATA
				SE5->E5_MOEDA 		:= _E5_MOEDA
				SE5->E5_VALOR 		:= _E5_VALOR
				SE5->E5_NATUREZ 	:= _E5_NATUREZ
				SE5->E5_BANCO 		:= _E5_BANCO
				SE5->E5_AGENCIA 	:= _E5_AGENCIA
				SE5->E5_CONTA 		:= _E5_CONTA
				SE5->E5_DOCUMEN		:= _E5_DOCUMEN
				SE5->E5_VENCTO      := _E5_VENCTO
				SE5->E5_RECPAG   	:= _E5_RECPAG
				SE5->E5_BENEF 		:= _E5_BENEF
				SE5->E5_HISTOR      := _E5_HISTOR
				SE5->E5_DTDIGIT		:= _E5_DTDIGIT
				SE5->E5_DTDISPO		:= _E5_DTDISPO
				SE5->E5_FILORIG	    := _E5_FILORIG
				SE5->E5_MODSPB	    := _E5_MODSPB
				SE5->(MsUnlock())
				
				End Transaction
				
				dbselectarea("TXT")
				TXT->(dbskip())
				
				TRBPAT->(dbclosearea())
				
				
				
				
			enddo
		endif
		
		dbselectarea("TXT")
		TXT->(DBCLOSEAREA())
		
		dbselectarea("SZI")
//		RecLock("SZI",.T.)
//		SZI->ZI_ARQUIVO  := _cArqOpen
//		SZI->ZI_DIA      := dtoc(dDatabase)
//		SZI->ZI_HORA     := TIME()		
//		MsUnLock()
		
		// MOVE ARQUIVO DE DIRETORIO
		cPathOrig:="\system\Integracao\Financeiro\Extrato_in\" + _cArqOpen
		cPathDest:="system\Integracao\Financeiro\Extrato_out\" + _cArqOpen
//		__CopyFile(cPathOrig,cPathDest)
//		fErase(cPathOrig)
		
	endif
	
next

fclose(nHdlArq)

_abre_arq := "\system\" + cArqLog
LjMsgRun("Aguarde a exibicao do Log.",,{|| WaitRun("WRITE "+&_abre_arq+'"') } )



return nil


