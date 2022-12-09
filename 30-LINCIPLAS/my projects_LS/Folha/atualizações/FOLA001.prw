#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FOLA001  º Autor ³ Ricardo Felipelli  º Data ³  04/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Integracao da folha de pagamento na contabilidade          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FOLA001
/////////////////////
Local _Opcao := .f.
                                    
_cQuery := "SELECT MAX(R_E_C_N_O_) R_E_C_N_O_ FROM SIGAMAT (NOLOCK)"
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SM0', .F., .T.)
If SM0->(LastRec()) > _SM0->R_E_C_N_O_
	DbCloseArea()      
	DbSelectArea('SM0')
	_nRecno := Recno()
	DbGoTop()
	TcSqlExec('DROP TABLE SIGAMAT')
	copy to SIGAMAT VIA 'TOPCONN' //for recno() > _nLastRec
	DbGoto(_nRecno)
EndIf       
DbCloseArea()      

If MsgYesNO("Confirma Processamento?","Importação Folha de Pagamento SOCIN - MICROSIGA")
	Processa({|| Impfolha()},"Importando Dados...")
	MsgInfo("Importação Finalizada!!!")
	
EndIf

Return nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ImpFolha()
//////////////////////////

cArqLog := Criatrab(nil,.f.) + '.txt'

nHdlArq:=FCreate(cArqLOG)
PAGI  :=  1
li    := 80
cLine := ""
cCRLF := CHR(13)+CHR(10)
If nHdlArq==-1
	tone(5000,1)
	alert("Impossivel Criar Arquivo LOG " + cArqLog + " VerIficar...")
	Return nil
EndIf
nCtErro:=0

cLine := "INICIANDO O LOG - INTEGRACAO FOLHA DE PAGAMENTO - CONTABILIDADE" + cCRLF
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

dbselectarea("CT8")
dbsetorder(01)
dbselectarea("SZF")
dbsetorder(01)
dbselectarea("CTT")
dbsetorder(01)
dbselectarea("SZG")
dbsetorder(02)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA / Abre os Arquivos de Trabalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArquivo  := Directory("\system\Integracao\FolhaPag\*.TXT","D")
cDiretorio:= "\system\Integracao\FolhaPag\"


//empresa, ano,  mes, codigo evento,desc evento,  conta credito, conta debito, historico, centro custo, filial, valor, grupo contabil
//10;      2008; 7;   0001;         SALARIO BASE; 51111001;      21510001;     263;       11267;        81;     9684; 4

_cQuery := "SELECT FILIAL, CASE WHEN ISNULL(CT2_SEQUEN,'') = '' THEN '0000000001' ELSE CT2_SEQUEN END CT2_SEQUEN"
_cQuery += _cEnter + "FROM ("
_cQuery += _cEnter + "SELECT M0_CODFIL FILIAL, max(ISNULL(CT2.R_E_C_N_O_,0)) RECNO "
_cQuery += _cEnter + "FROM SIGAMAT SM0 (NOLOCK)"
_cQuery += _cEnter + "LEFT JOIN " + RetSqlName('CT2') + " CT2 (NOLOCK)"
_cQuery += _cEnter + "ON CT2_FILIAL = M0_CODFIL "
_cQuery += _cEnter + "AND CT2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "WHERE SM0.D_E_L_E_T_ = ''  "
_cQuery += _cEnter + "AND M0_CODIGO = '01'"
_cQuery += _cEnter + "GROUP BY M0_CODFIL"
_cQuery += _cEnter + ") A"
_cQuery += _cEnter + "LEFT JOIN " + RetSqlName('CT2') + " CT2 (NOLOCK)"
_cQuery += _cEnter + "ON CT2.R_E_C_N_O_ = RECNO "
_cQuery += _cEnter + "AND CT2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + "AND FILIAL <> ''"
_cQuery += _cEnter + "AND CT2_FILIAL = FILIAL "
_cQuery += _cEnter + "ORDER BY FILIAL"

dbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), "TMP", .F., .T.)
_aSeq := {} // filial, sequencia, linha, doc
Do While !EOF()
	aAdd(_aSeq,{TMP->FILIAL,Soma1(TMP->CT2_SEQUEN),'000','000001'})
	DbSkip()
EndDo
DbCloseArea()

For n:=1 to Len(cArquivo)
	
	_aLanc := {}	// vetor com os lançamentos aglutinados
	// filial
	// conta debito
	// conta credito
	// cc debito
	// cc credito
	// valor
	
	_nCredito := 0
	_nDebito  := 0
	
	IncProc("Importando... Aguarde...")
	
	cLine := "Arquivo............: "+cArquivo[n,1]+cCRLF
	fWrite(nHdlArq,cLine,Len(cLine))
	
	// Validar lancamento se não tem no banco
	SZF->(DBSEEK(xFilial('SZF') + cArquivo[n,1]))
	
	If SZF->(found())
		cLine := "  JA PROCESSADO EM: "+ dtoc(SZF->ZF_DIA) + ' AS ' + SZF->ZF_HORA+_cEnter
		fWrite(nHdlArq,cLine,Len(cLine))
		
		cPathOrig:="\system\Integracao\FolhaPag\" + SZF->ZF_ARQUIVO
		fErase(cPathOrig)
		
	Else
		
		_cArqOpen := '\system\Integracao\FolhaPag\' + cArquivo[n,1]
		FT_FUSE(_cArqOpen)

		ProcRegua(FT_FLastRec())
		FT_FGotop()
		_cFilAnt := ''
		_nLinha  := 0
		Do	While ( !FT_FEof() )
			++_nLinha
			_cLinha  := alltrim(U_ClearAcentos(alltrim(FT_FREADLN())))
			FT_FSkip()                                                
			If empty(_cLinha)
				loop
			EndIf
			__campo   := 1
			
			IncProc('Aglutinando valores contábeis...')
			
			// prepara os registro migrados da tabela txt delimitado por ;
			_tx_empresa    := ''
			_tx_ano        := ''
			_tx_mes        := ''
			_tx_cod_eve    := ''
			_tx_desc_eve   := ''
			_tx_cont_cred  := ''
			_tx_cont_deb   := ''
			_tx_cod_hist   := ''
			_tx_cent_custo := ''
			_tx_filial     := ''
			_tx_valor      := ''
			
			For __campo := 1 to 12
				_nPos := at(';',_cLinha)
				If __campo ==  1 // empresa
					_tx_empresa := left(_cLinha,_nPos-1)
					If left(_tx_empresa,3) == '555'
						exit
					EndIf
				ElseIf __campo	==  2 // mes
					_tx_mes := left(_cLinha,_nPos-1)
				ElseIf __campo	==  3 // ano
					_tx_ano := left(_cLinha,_nPos-1)
				ElseIf __campo	==  4 // codigo do evento
					_tx_cod_eve := left(_cLinha,_nPos-1)
				ElseIf __campo	==  5 // descricao do envento
					_tx_desc_eve := left(_cLinha,_nPos-1)
					Do While '  ' $ _tx_desc_eve
						_tx_desc_eve := strtran(_tx_desc_eve,'  ',' ')
					EndDo
				ElseIf __campo	==  6 // conta cred
					_tx_cont_cred := left(_cLinha,_nPos-1)
				ElseIf __campo	==  7 // conta debito
					_tx_cont_deb := left(_cLinha,_nPos-1)
				ElseIf __campo	==  8 	// codigo do historico
					_tx_cod_hist := left(_cLinha,_nPos-1)
				ElseIf __campo	==  9 // centro de custo
					_tx_cent_custo := left(_cLinha,_nPos-1)
				ElseIf __campo	== 10 // filial
					_tx_filial := left(_cLinha,_nPos-1)
				ElseIf __campo	== 11 // valor
					_tx_valor := strtran(left(_cLinha,_nPos-1),',','.')
				ElseIf __campo	== 12 // grupo
					_tx_grupo := left(_cLinha,_nPos-1)
				EndIf
				_cLinha := substr(_cLinha,_nPos+1)
				
			Next
	
			If left(_tx_empresa,3) == '555'
				loop
			Else
				
				CT2->(Dbseek(_tx_filial))
				
				_tx_histor := ''
				CT8->(Dbseek(space(02)+_tx_cod_hist))
				If CT8->(found())
					_tx_histor := Alltrim(CT8->CT8_DESC)
				EndIf
				
				_tx_data := LastDay(ctod('01/'+_tx_mes + '/' + _tx_ano))
                  
				_nPos := aScan(_aLanc,{|x| x[1] == _tx_filial .and. x[2] == _tx_cont_deb .and. x[3] == _tx_cont_cred .and. x[4] == _tx_cent_custo .and. x[5] == _tx_cent_custo .and. x[7] == upper(left('FOL ' + left(Mes(_tx_data),3) + '/' + str(year(_tx_data),4) + ' - ' + _tx_desc_eve,40))})
				If _nPos == 0
					aAdd(_aLanc,{_tx_filial, _tx_cont_deb, _tx_cont_cred, _tx_cent_custo, _tx_cent_custo, val(_tx_valor), upper(left('FOL ' + left(Mes(_tx_data),3) + '/' + str(year(_tx_data),4) + ' - ' + _tx_desc_eve,40)),_tx_empresa, _tx_grupo,_nLinha})
				Else                                  
					_aLanc[_nPos,6] += val(_tx_valor)
				EndIf
			EndIf
			
		enddo
 		FT_FUSE()
		_aLanc := aSort(_aLanc,,,{|x,y| x[1] < y[1]})
		
		ProcRegua(Len(_aLanc))		
		_cErros := _cEnter + _cEnter + 'Filiais não localizadas: ' + _cEnter + _cEnter
		For _nI := 1 to len(_aLanc)
				IncProc('Gravando lançamentos de partida dobrada...')
				
				_nPos := aScan(_aSeq,{|x| x[1] == _aLanc[_nI,1]}) 
				If _nPos == 0
					If !('Filial: ' + _aLanc[_nI,1] $ _cErros)
						_cErros += 'Filial: ' + _aLanc[_nI,1] + ' empresa: ' + _aLanc[_nI,8] + '  grupo: ' + _aLanc[_nI,9] + _cEnter
					EndIf
					loop
				EndIf
				_aSeq[_nPos,3] := Soma1(_aSeq[_nPos,3])	// linha
				If _aSeq[_nPos,3] > '999'
					_aSeq[_nPos,3] := '001'
					_aSeq[_nPos,4] := Soma1(_aSeq[_nPos,4])
				EndIf
				
				// INCLUI LANÇAMENTO DE PARTIDAS DOBRADAS
				dbselectarea("CT2")
				RecLock("CT2",.t.)
				CT2->CT2_FILIAL  := _aLanc[_nI,1]
				CT2->CT2_DATA    := _tx_data
				CT2->CT2_LOTE    := '008890'
				CT2->CT2_SBLOTE  := '001'
				CT2->CT2_DOC     := _aSeq[_nPos,4]
				CT2->CT2_LINHA   := _aSeq[_nPos,3]
				CT2->CT2_MOEDLC  := '01"
				CT2->CT2_DC      := '3'
				CT2->CT2_DEBITO  := _aLanc[_nI,2]
				CT2->CT2_CREDIT  := _aLanc[_nI,3]
				CT2->CT2_VALOR   := _aLanc[_nI,6]
				CT2->CT2_HIST    := upper(U_ClearAcento(_aLanc[_nI,7],'S'))
				CT2->CT2_CCD     := _aLanc[_nI,4]
				CT2->CT2_CCC     := _aLanc[_nI,5]
				CT2->CT2_EMPORI  := '01'
				CT2->CT2_FILORI  := _aLanc[_nI,1]
				CT2->CT2_TPSALD  := '1'
				CT2->CT2_SEQUEN  := _aSeq[_nPos,2]
				CT2->CT2_MANUAL  := '2'
				CT2->CT2_ORIGEM  := 'F001 - ' + upper(U_ClearAcento(_cArqOpen,'S')) + ' - Linha: ' + str(_aLanc[_nI,10],5)
				CT2->CT2_ROTINA  := 'FOLA001'
				CT2->CT2_AGLUT   := '1'
				CT2->CT2_LP      := 'F001'
				CT2->CT2_SEQHIS  := '001'
				CT2->CT2_SEQLAN  := '001'
				CT2->CT2_CRCONV  := '1'
				CT2->CT2_DTCV3   := DDATABASE
				MsUnLock()

		Next		

		dbselectarea("SZF")
		RecLock("SZF",.T.)
		SZF->ZF_ARQUIVO  := _cArqOpen
		SZF->ZF_DIA      := dDatabase
		SZF->ZF_HORA     := TIME()
		
		MsUnLock()
		
		// MOVE ARQUIVO DE DIRETORIO
		cPathOrig:="\system\Integracao\FolhaPag\" + _cArqOpen
		cPathDest:="\system\Integracao\FolhaPag\IMPORT\" + _cArqOpen
		__CopyFile(cPathOrig,cPathDest)
		fErase(cPathOrig)
		
		cLine := 'Arquivo ' + _cArqOpen + _cEnter
		fWrite(nHdlArq,cLine,Len(cLine))
		cLine := "Lançamentos de partidas dobradas " + str(len(_aLanc),7) + _cEnter
		fWrite(nHdlArq,cLine,Len(cLine))
		fWrite(nHdlArq,_cErros,Len(_cErros))
		
	EndIf
	
next

fclose(nHdlArq)

Aviso('Integração Folha de Pagamento',MemoRead(cArqLog),{'OK'},3,'Log da integração')
fErase(cArqLog)

return nil

//V:\PROTHEUS_DATA\SYSTEM\Integracao\FolhaPag\EXPORTACAO_PROTHEUS_07_2011.txt

