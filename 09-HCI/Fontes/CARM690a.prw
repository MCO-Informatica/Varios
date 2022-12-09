#Include "Protheus.ch"
#Include "DBTREE.CH"      

#DEFINE REMOTE_LINUX	2

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data         |BOPS:             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³ROBSON BUENO DA SILVA     ³18/04/2017    |XXXXXXXXXXX       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A690Processa³ Autor ³ Robson Bueno Silv   ³ Data ³ 05/09/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Alocacao                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parâmetro ³ aRet     : Array com dados da Carga Máquina e dos Recursos ³±±
±±³          ³            que serão utilizados                            ³±±
±±³          ³ aRecursos: Array com dados de cada recurso                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
User Function C690Proc(aRet,aRecursos,oCenterPanel)
Local j, i, k, l, nKey, aAlter, aSecun, nBit, aAloc := {}, aFerram
Local cRecurso, nTempo, nFimIdeal, nDur, aSubDiv, aRegFerr       // , nBitIni
Local aOpcoes, aDtHrIni, aDtHrFim, nInicio, nFim, nSubDiv, cNumDes
Local nNumDesdob, nDurDesdob,nTmpDesdob,nQuebra:=0
Local cCondTRB,nDurTotal,nSetup,aOcorre5:={},nNumdes,nLigados,nSetUpOrig,nTempEnd,nTempEndOrig
Local nIniSubDiv, nSubDivHdl, cSubDivFile, cSubDiv, nIndSubDiv := 0
Local nBitAjust, lFirstAjust, lDica1 := .T., lDica2 := .T.
Local cCalStr:=Pad("", aRet[4]), cUltFerr := "", aOcorre10 := {}, aOcorre11 := {}
Local nTemp:=0,nTempAjust:=0,nPosSH6:=0
Local lMt690Time := (ExistBlock("MT690TIME"))
Local lC690GrvTrb:= (ExistBlock("A690GTRB"))
Local lMt690Alter:= (Existblock("M690RALT"))
Local aMt690Time:={}
Local nQuantAloc:=0
Local bCampo 	:= {|nCPO| Field(nCPO) }
Local lOtimSecun:= GetMV("MV_OTIMSEC") == "S"
Local lAlternativo
LOCAL nDec:=Set(3,4)
LOCAL lMudouRec:=.F.

// Variaveis utilizadas para roteiro de operacoes alternativo
Local cSeekRotAlt:="",nSeqOperac:=0,nSeqAloc:=0,aRegs:={{}}
Local cSeekWhile
Local nSoma:=0,nAchou:=0
Local cH6Tempo
Local cRecDep := "", nRecDep := 0

Local lMt690BitIni:= (Existblock("M690BITINI"))
Local lA690Setup  := (ExistBlock("A690Setup"))
Local a690RetSet
Local c690Recurso
Local nOldSetupOrig
Local nOldTempEnd
Local nOldDurDesdob
Local nRetTemp
Local nRetBit
Local nx
Local nTQtdDesdobr
Local xRetBlock
Local lBlockAltDesd := ExistBlock("C690ALTDESD")
Local aRetPEAloc := {}

PRIVATE aRecAlter:={}
PRIVATE aRecSecun:={}                 
PRIVATE nSetupAnt:= 0

u_C690Qst(.F.)

u_ASHICaln(,,, .T.)

// Caso utilize recurso ilimitado posiciona SH1 na ordem correta para pesquisa
dbSelectArea("SH1")
dbSetOrder(1)

If mv_par01 == 1
	cSubDivFile := cDirPcp+cNameCarga+".SBD"
	nSubDivHdl := MSFCREATE(cSubDivFile)
	If nSubDivHdl = -1
		If !lShowOCR
			Help(" ",1,"C690In",,Str(FError(),2,0),05,38)
		EndIf
		Return .F.
	Endif
EndIf

Private nBitLimit, nBit1Peca, lMudapraFim := .F.

dbSelectArea("TRB")
dbGotop()

// Prepara a Regua de processamento de registros
nRegua:=0
If !u_C690IsBt()
	If (oCenterPanel==Nil)
		oRegua:nTotal:=nTotRegua:=LastRec()
	Else
		oCenterPanel:SetRegua1(LastRec())	
	EndIf
EndIf

u_C690NAl(,, .T.)

While !Eof()
	// Movimenta a Regua de processamento de registros
	If !u_C690IsBt()
	 	//EVAL(bBlock)
	EndIf

	If (mv_par27 == 1 .Or. mv_par28 == 1) .And. u_C690NAl(TRB->(OPNUM+ITEM+SEQUEN+ITEMGRD))
		dbSkip()
		Loop
	Endif

	aAlter  := {}
	aSecun  := {}
	aFerram := {}
	aOpcoes := {}
	aAloc   := {}
	aSubDiv := {}
	aRegFerr:= {}

	// Monta Arrays com Maquinas Alternativas e Secundarias
	If !C690Altr(@aAlter,@aSecun,aRecursos,@aFerram)
		If mv_par01 == 1
			FClose(nSubDivHdl)
		EndIf
		Return .F.
	EndIf
	aRecAlter:=ACLONE(aAlter)
	aRecSecun:=ACLONE(aSecun)

	// Executa PE para alterar recursos alternativos / secundarios disponiveis
	If lMt690Alter
		lMudouRec:=.F.
		ExecBlock("M690RALT",.F.,.F.,{TRB->OPNUM+TRB->ITEM+TRB->SEQUEN,TRB->PRODUTO,TRB->OPERAC,TRB->RECURSO})
		If Valtype(aRecAlter) == "A"
			If Len(aRecAlter) == Len(aAlter)
				For nx:=1 to Len(aRecAlter)
					If aAlter[nx] # aRecAlter[nx]
						lMudouRec:=.T.
						Exit
					EndIf
				Next nx
			Else
				lMudouRec:=.T.
			EndIf
			// Verifica existencia dos recursos
			If lMudouRec
				dbSelectArea("SH1")
				dbSetOrder(1)
				For nx:=1 to Len(aRecAlter)
					If !dbSeek(xFilial("SH1")+aRecAlter[nx])
						lMudouRec:=.F.
						Exit
					EndIf
				Next nx
				dbSelectArea("TRB")
			EndIf
			If lMudouRec
				aAlter:=ACLONE(aRecAlter)
			EndIf
		EndIf

		lMudouRec:=.F.
		If Valtype(aRecSecun) == "A"
			If Len(aRecSecun) == Len(aSecun)
				For nx:=1 to Len(aRecSecun)
					If aSecun[nx] # aRecSecun[nx]
						lMudouRec:=.T.
						Exit
					EndIf
				Next nx
			Else
				lMudouRec:=.T.
			EndIf
			// Verifica existencia dos recursos
			If lMudouRec
				dbSelectArea("SH1")
				dbSetOrder(1)
				For nx:=1 to Len(aRecSecun)
					If !dbSeek(xFilial("SH1")+aRecSecun[nx])
						lMudouRec:=.F.
						Exit
					EndIf
				Next nx
				dbSelectArea("TRB")
			EndIf
			If lMudouRec
				aSecun:=ACLONE(aRecSecun)
			EndIf
		EndIf
	EndIf

	// Calcula Tempo de Dura‡„o baseado no Tipo de Operacao
	If TRB->TPOPER $ " 1"
		nTemp := Round(TRB->QTDPROD * ( IIf( TRB->TEMPAD == 0, 1, TRB->TEMPAD) / IIf( TRB->LOTEPAD == 0, 1, TRB->LOTEPAD ) ),5)
		dbSelectArea("SH1")
		dbSeek(xFilial("SH1")+TRB->RECURSO)
		If Found() .And. H1_MAOOBRA # 0
			nTemp :=Round( nTemp / H1_MAOOBRA,5)
		EndIf
	ElseIf TRB->TPOPER == "4"
		nQuantAloc:=TRB->QTDPROD % IIf(TRB->LOTEPAD == 0, 1, TRB->LOTEPAD)
		nQuantAloc:=Int(TRB->QTDPROD)+If(nQuantAloc>0,IIf(TRB->LOTEPAD == 0, 1, TRB->LOTEPAD)-nQuantAloc,0)
		nTemp := Round(nQuantAloc * ( IIf( TRB->TEMPAD == 0, 1, TRB->TEMPAD) / IIf( TRB->LOTEPAD == 0, 1, TRB->LOTEPAD ) ),5)
		dbSelectArea("SH1")
		dbSeek(xFilial("SH1")+TRB->RECURSO)
		If Found() .And. H1_MAOOBRA # 0
			nTemp :=Round( nTemp / H1_MAOOBRA,5)
		EndIf
	ElseIf TRB->TPOPER == "2" .Or. TRB->TPOPER == "3"
		nTemp := IIf( TRB->TEMPAD == 0 , 1 , TRB->TEMPAD )
	EndIf
    dbSelectArea("SHB")
	dbSeek(xFilial("SHB")+TRB->CTRAB) 
	If Found() .And. SHB->HB_REND<>100
	  nTemp:=nTemp*(((100-SHB->HB_REND)/100)+1)
	ENDIF  
	// Ajusta tempo a ser alocado de acordo com apontamentos
	// ja realizados
	If mv_par04 == 3
		//Recalcula nTemp somente se tipo de operacao for diferente de tempo fixo
		If TRB->TPOPER # "2"
			SC2->(dbSeek(xFilial("SC2")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD))
			nTemp := Round(SC2->C2_QUANT * ( IIf( TRB->TEMPAD == 0, 1, TRB->TEMPAD) / IIf( TRB->LOTEPAD == 0, 1, TRB->LOTEPAD ) ),5)				
			dbSelectArea("SH1")
			dbSeek(xFilial("SH1")+TRB->RECURSO)
			If Found() .And. H1_MAOOBRA # 0
				nTemp :=Round( nTemp / H1_MAOOBRA,5)
			EndIf
			nTempAjust:=0;nPosSH6:=0
		EndIf
		dbSelectArea("SH6")
		cSeekSH6 := xFilial("SH6")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD+TRB->PRODUTO+TRB->OPERAC
		dbSeek(cSeekSH6)
		Do While !Eof() .And. cSeekSH6 == H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC
			nPosSH6:=AT(":",SH6->H6_TEMPO)
			If nPosSH6 == 0
				nPosSH6:=AT(":",PesqPict("SH6","H6_TEMPO"))
			EndIf
			cH6Tempo := TimeH6("N")    // Converte H6_TEMPO para normal se preciso
			nTempAjust+=Val(Substr(cH6Tempo,1,nPosSH6-1))+(Val(Substr(cH6Tempo,nPosSH6+1))/60)
			dbSkip()
		EndDo
		nTemp := Max(nTemp - nTempAjust, 0)
	EndIf
	dbSelectArea("TRB")
	If lMt690Time
		aMt690Time:={TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,nTemp,aRet}
		nRetTemp := ExecBlock("MT690TIME",.F.,.F.,aMt690Time)
		If ValType(nRetTemp) == "N"
			nTemp := nRetTemp
		Endif
	EndIf
	nSetUp      := U_C690T2B(TRB->SETUP)
	nTempEnd    := U_C690T2B(TRB->TEMPEND)
	nDurTotal   := U_C690T2B(nTemp)
	nDurTotal   += nSetUp+nTempEnd
	nSetUpOrig  := nSetUp
	nTempEndOrig:= nTempEnd
	If nDurTotal == 0
		If SH1->(Found()) .And. SH1->H1_MAOOBRA > 1
			u_C690Ocor(14,.F.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,TRB->LOTEPAD,TRB->TEMPAD,SH1->H1_MAOOBRA,nTemp*60,TRB->QTDPROD)
		Else
			u_C690Ocor(15,.F.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,TRB->LOTEPAD,TRB->TEMPAD,nTemp*60,TRB->QTDPROD)
		EndIf
		If mv_par27 == 1 .And. mv_par01 == 1
			u_C690DSH8(nSubDivHdl,aRet,aRegFerr,aSubDiv,aFerram)
		Endif	
		dbSkip()
		Loop
	EndIf
	// Calcula Bit Inicial
	nBitLimit 	:= 0
	nBit1Peca 	:= 0                   
	nBit 		:= C690PrBt(aRet, @aOcorre5, @lDica1,nSetupAnt,nDurTotal)
	nSetupAnt	:= nSetUp

	If lMt690BitIni
		nRetBit :=ExecBlock("M690BITINI",.F.,.F., {nBit, TRB->(OPNUM + ITEM + SEQUEN), TRB->OPERAC, TRB->DATPRI, TRB->DATPRF})
		If ValType(nRetBit) == "N"
			nBit := nRetBit
		Endif
	EndIf

	If nBit == -99999
		If mv_par01 == 1
			If mv_par27 == 1
				u_C690DSH8(nSubDivHdl,aRet,aRegFerr,aSubDiv,aFerram)
			Endif	
			FClose(nSubDivHdl)
		EndIf
		Return .F.
	EndIf

	If nBit > 0

		nTmpDesdob := 0

		// Calcula numero de desdobramentos e tempo de cada desdobramento
		If (TRB->TEMPDES > 0 .Or. !Empty(TRB->TPDESD) .Or. (TRB->DESPROP == "S")) .And. ( !Empty( aAlter ) .Or. !Empty( aSecun ) )
			If TRB->DESPROP == "S"
				If (! Empty(TRB->FERRAM)) .And. mv_par03 == 1
					SH4->(dbSeek(xFilial("SH4") + TRB->FERRAM))
					nTmpDesdob := Round( (nDurTotal-(nSetup+nTempEnd)) / Min(SH4->H4_QUANT, If(Len(aAlter)>0,Len(aAlter)+1,Len(aSecun)+1)),5)
				Else
					nTmpDesdob := Round( (nDurTotal-(nSetup+nTempEnd)) / (If(Len(aAlter)>0,Len(aAlter)+1,Len(aSecun)+1)),5)
				Endif
			ElseIf TRB->TPDESD == "1"
				nTmpDesdob := Int( (nDurTotal-(nSetup+nTempEnd)) / ( TRB->QTDPROD / TRB->TEMPDES ))
			ElseIf TRB->TPDESD == "2" .Or. TRB->TPDESD == " "
				nTmpDesdob := U_C690T2B( TRB->TEMPDES )
			EndIf
			// Nao pode haver desdobramento que dure menos de 1 bit
			nTmpDesdob:=If(nTmpDesdob <=0,1,Int(nTmpDesdob))
			If nDurTotal > nTmpDesdob
				nNumDesdob := Int( (nDurTotal-(nSetup+nTempEnd)) / nTmpDesdob )
				If nNumDesdob == 1
					nDurDesdob := nDurTotal
				Else
					// Acerta diferenca de Bits para primeira operacao
					nQuebra:=(nDurTotal-(nSetup+nTempEnd))%nTmpDesdob
					nQuebra:=IF(nQuebra > 0 .And. nQuebra < 1,1,Int(nQuebra))
				EndIf
			Else
				nDurDesdob := nDurTotal
				nNumDesdob := 1
			EndIf
		Else
			nDurDesdob := nDurTotal
			nNumDesdob := 1  
		EndIf              
		
		nBitAjust := 1
		lFirstAjust := .T.

		While .T.

			nOldSetupOrig := nSetupOrig
			nOldTempEnd   := nTempEndOrig

			If mv_par01 == 2			// Aloca‡„o pelo In¡cio
				nNumDes := IIf( nNumDesdob > 1, 0, -1 )
                nTQtdDesdobr := TRB->QTDPROD
				For k := 1 to nNumDesdob

					aOpcoes := {}
					aSubDiv := {}
					aAloc   := {}
					aRegFerr:= {}

					// Acresce … primeira aloca‡„o, o valor quebrado resultante da divis„o
					// da opera‡„o em desdobramentos.
					If nNumDesdob > 1
						nDurDesdob := nTmpDesdob
						If k == 1
							nDurDesdob+=nQuebra
						EndIf
						nDurDesdob+=(nSetupOrig+nTempEndOrig)
					EndIf

					nOldDurDesdob := nDurDesdob

					If lBlockAltDesd
						xRetBlock := ExecBlock("C690ALTDESD", .F., .F., {TRB->RECURSO, nDurDesdob, k, aAlter, aSecun})
						If ValType(xRetBlock) == "A"
							If ValType(xRetBlock[1]) == "A" .And. ValType(xRetBlock[2]) == "A"
								aAlter := aClone(xRetBlock[1])
								aSecun := aClone(xRetBlock[2])
							EndIf
						EndIf
					EndIf

					// A partir do Bit de inicio, busca melhor recurso para alocar
					//Principal,alternativos e secundarios
					lAlternativo := Len(aAlter)>0
					For i := 1 to If(lAlternativo,Len(aAlter)+1,Len(aSecun)+1)
						nSetUp:=nSetupOrig

						If lA690Setup
							nDurDesdob  := nOldDurDesdob
							c690Recurso := If(i == 1, TRB->RECURSO, If(Len(aAlter)>0,aAlter[i-1],aSecun[i-1]))
							C690RetSet  := ExecBlock("u_C690Stp", .F., .F., {TRB->RECURSO, c690Recurso, nDurDesdob - (nOldSetupOrig+nOldTempEnd), nOldSetupOrig, nSetup, k})
							If ValType(C690RetSet) == "A" .And. Len(C690RetSet) == 2 .And. Valtype(C690RetSet[1]) == "N" .And. Valtype(C690RetSet[2]) == "N"
								nDurDesdob := C690RetSet[1] + C690RetSet[2]
								nSetup     := C690RetSet[2]
								nSetupOrig := C690RetSet[2]
							Endif
						Endif
						If i == 1
							If (nRecDep := aScan(aRecDepend, {|x| x[1] == TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD})	) > 0
								cRecDep := aRecDepend[nRecDep, 3]
							Endif
							If (! (mv_par01 == 2 .And. TRB->TPLINHA == "D" .And. u_C690RcLn(TRB->RECURSO) # cRecDep)) .Or. ! (mv_par01 == 1 .And. nRecDepend # 0 .And. aRecDepend[nRecDepend, 4] == "D")
								aAloc := C690BsAl(TRB->RECURSO, nBit, nDurDesdob, cUltFerr, aRet, @aOcorre10, @aOcorre11, aRecursos, aFerram,@nSetUp,"P")
							Endif
						Else
							nSetUp:=nSetupOrig
							// Caso so tenha recurso secundario e nao queira otimizar
							// alocacao, abandona laco
							If Len(aAlter) <= 0 .And. !lOtimSecun
								Exit
							EndIf
							aAloc := C690BsAl(If(Len(aAlter)>0,aAlter[i-1],aSecun[i-1]), nBit,nDurDesdob,cUltFerr, aRet, @aOcorre10, @aOcorre11, aRecursos, aFerram,@nSetUp,If(lAlternativo,"A","S"))
						EndIf
						If lMudapraFim
							Exit
						EndIf

						// Armazena a melhor data fim de cada Recurso
						If Len(aAloc) > 0
							Aadd(aOpcoes,{aAloc[1][1],aAloc[1][2],aAloc[1][3],aAloc[1][4],aAloc[1][5],aAloc[1][6],aAloc[1][7],aAloc[1][8],aAloc[1][9]})
						Endif

					Next i

					If lMudapraFim
						Exit
					EndIf

					// Se nao conseguiu alocar nem no Recurso Principal e nem nos alternativos
					// tenta os recursos secundarios:
					If Empty(aOpcoes) .And. !Empty(aSecun) .And. lOtimSecun

						For i := 1 to Len(aSecun) // secundarios
							nSetUp:=nSetupOrig

							If nTmpDesdob == 0
								nTmpDesdob:=nDurDesdob
							EndIf

							If lA690Setup
								C690RetSet  := ExecBlock("u_C690Stp", .F., .F., {TRB->RECURSO, aSecun[i], nTmpDesdob, nOldSetupOrig, nSetup, k})
								If ValType(C690RetSet) == "A" .And. Len(C690RetSet) == 2 .And. Valtype(C690RetSet[1]) == "N" .And. Valtype(C690RetSet[2]) == "N"
									nTmpDesdob := C690RetSet[1] + C690RetSet[2]
									nSetup     := C690RetSet[2]
								Endif
							Endif

							aAloc := C690BsAl(aSecun[i] , nBit, nTmpDesdob, cUltFerr, aRet, @aOcorre10, @aOcorre11, aRecursos, aFerram,@nSetUp,"S")

							// Armazena a melhor data fim de cada Recurso
							If Len(aAloc) > 0
								Aadd(aOpcoes,{aAloc[1][1],aAloc[1][2],aAloc[1][3],aAloc[1][4],aAloc[1][5],aAloc[1][6],aAloc[1][7],aAloc[1][8],aAloc[1][9]})
							Endif

							If lMudapraFim
								Exit
							EndIf
						Next i
					EndIf

					If lMudapraFim
						Exit
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Seleciona a melhor data fim entre os recursos disponiveis       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(aOpcoes)
						cRecurso := aOpcoes[1,1]
						nTempo   := Round(aOpcoes[1,2],5)
						nFimIdeal:= aOpcoes[1,3]
						nDur     := aOpcoes[1,4]
						aSubDiv  := aOpcoes[1,5]
						aRegFerr := aOpcoes[1,6]
						// Acerto na quebra desdobramento
						If nNumDesdob > 1
							nQuantAloc:=u_C690QtAl(cRecurso,aRecursos,nDur,aOpcoes,1,nNumDesdob)
						Else
							nQuantAloc	:=TRB->QTDPROD
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ O primeiro apontamento ja esta calculado pois contem a³
						//³ diferenca do calculo ref aos outros apontamentos      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For i := 1 to Len(aOpcoes)
							If aOpcoes[i,3] < nFimIdeal .Or. ( aOpcoes[i,3] == nFimIdeal .And. nTempo < aOpcoes[i,2] )
								cRecurso := aOpcoes[i,1]
								nTempo   := Round(aOpcoes[i,2],5)
								nFimIdeal:= aOpcoes[i,3]
								nDur     := aOpcoes[i,4]
								aSubDiv  := aOpcoes[i,5]
								aRegFerr := aOpcoes[i,6]
								// Acerto na quebra desdobramento
								If nNumDesdob > 1
									nQuantAloc:=u_C690QtAl(cRecurso,aRecursos,nDur,aOpcoes,i,nNumDesdob)
								Else
									nQuantAloc	:=TRB->QTDPROD
								EndIf
							Endif
						Next i
					EndIf

					// Se Conseguir
					If !Empty(aSubDiv)
					
						If ExistBlock("U_C690ALOC")
							aRetPEAloc := ExecBlock("U_C690ALOC",.F.,.F.,{nSetup,nTempEnd,aSubDiv,k,nNumDesdob})
							If Len(aRetPEAloc) == 3 .And. ValType(aRetPEAloc[1]) == "N" .And. ValType(aRetPEAloc[2]) == "N" .And. ValType(aRetPEAloc[3]) == "A"
								nSetup   := aRetPEAloc[1]
								nTempEnd := aRetPEAloc[2]
								aSubDiv  := aClone(aRetPEAloc[3])
							EndIf
						EndIf

						// Fun‡„o que atualiza os Arquivos Bin rios da Carga e de Ferramentas
						u_C690AtCg(@cCalStr, @aRecursos, @cUltFerr, aRet, cRecurso, aSubDiv, aFerram, aRegFerr ,TRB->ILIMITADO == "S")

						nSubDiv := 0
						If Len(aSubDiv) > 1
							// Avalia se ha' alguma alocacao no meio desta, se houver divide esta em mais de uma
							nIniSubDiv := 1
							nDur := 0
							nNumDes++
							For i:= 1 to Len(aSubDiv)-1
								nLigados := Look4Bit( cCalStr, aSubDiv[i][1], (aSubDiv[i+1][1]-1)-aSubDiv[i][1], aRet[4] )
								nDur += aSubDiv[i][2]
								If ( (aSubDiv[i+1][1]-1)-aSubDiv[i][1] ) - nLigados # aSubDiv[i][2] .And. ! u_C690Ilim(cRecurso)
									nInicio := aSubDiv[nIniSubDiv][1]
									nFim    := aSubDiv[i][1]+aSubDiv[i][2]
									aDtHrIni:=u_Bit2DtHr(nInicio,dDataPar)
									aDtHrFim:=u_Bit2DtHr(nFim,dDataPar)
									nSubDiv++
									C690ASH8(cRecurso,aDtHrIni,aDtHrFim,nInicio,nFim,nNumDes,nSubDiv,nDur,nIndSubDiv,nQuantAloc,nSetup,nTempEnd)
									nIniSubDiv := i+1
									nDur := 0
								EndIf
							Next i
							i := Len(aSubDiv)
							nDur += aSubDiv[i][2]
							nDur -= nSetup
							nInicio := aSubDiv[nIniSubDiv][1]
							nFim    := aSubDiv[i][1]+aSubDiv[i][2]
							aDtHrIni:=u_Bit2DtHr(nInicio,dDataPar)
							aDtHrFim:=u_Bit2DtHr(nFim,dDataPar)
							nSubDiv := IIf( nSubDiv # 0, nSubDiv++, 0 )
							U_C690ASH8(cRecurso,aDtHrIni,aDtHrFim,nInicio,nFim,nNumDes,nSubDiv,nDur,nIndSubDiv,nQuantAloc,nSetup,nTempEnd)
						Else
							nInicio := aSubDiv[1][1]
							nFim    := aSubDiv[Len(aSubDiv)][1]+aSubDiv[Len(aSubDiv)][2]
							aDtHrIni:=u_Bit2DtHr(nInicio,dDataPar)
							aDtHrFim:=u_Bit2DtHr(nFim,dDataPar)
							nDur    -= nSetup
							nNumDes++
							U_C690ASH8(cRecurso,aDtHrIni,aDtHrFim,nInicio,nFim,nNumDes,nSubDiv,nDur,,nQuantAloc,nSetup,nTempEnd)
						EndIf
						
						//-- Garante que em desdobramentos a divisao seja efetuada corretamente, conforme  a eficiencia do recurso
						If nNumDesdob > 1
							nTQtdDesdobr -= nQuantAloc
						EndIf

					Else

						// Se nao conseguiu alocar VERIFICA se a operacao utiliza
						// roteiro de operacoes alternativo
						If Empty(aOpcoes) .And. !Empty(TRB->ROTALT)
							Exit
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Se estourou o calendario                              ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Len(aSubDiv) == 0
							If mv_par27 == 1
								u_C690DSH8(nSubDivHdl,aRet,aRegFerr,aSubDiv,aFerram)
							Endif

							If mv_par01 == 2 .And. mv_par28 == 1
								u_C690NAl(TRB->(OPNUM+ITEM+SEQUEN+ITEMGRD), .T.)
							Endif

							If !u_C690Ocor(9,.T.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
								If mv_par01 == 1
									FClose(nSubDivHdl)
								EndIf
								Return .F.
							Else
								Exit
							EndIf
						Endif

					EndIf
                	       
                	//-- Caso a quantidade do Desdobramento seja menor ou igual a Zero assume que ja foi atendida a quantidade
                	If nTQtdDesdobr <= 0
						Exit                	
                	EndIf
				Next k

				// Se nao conseguiu alocar VERIFICA se a operacao utiliza
				// roteiro de operacoes alternativo
				If Empty(aOpcoes) .And. !Empty(TRB->ROTALT)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Salva a integridade dos campos de Bancos de Dados  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("TRB")
					aRegs:={{}};nSeqOperac:=Val(TRB->OPERAC);nSeqAloc:=Val(TRB->SEQALOC);nSoma:=0
					If Len(aRegs[Len(aRegs)]) > 4095
						AADD(aRegs,{})
					EndIf
					AADD(aRegs[Len(aRegs)],{Recno(),.F.})
					For i := 1 TO FCount()
						M->&(EVAL(bCampo,i)) := FieldGet(i)
					Next i
					dbSelectArea("SG2")
					cSeekRotAlt	:= xFilial("SG2")+TRB->PRODUTO+TRB->ROTALT  
					cSeekWhile	:= "G2_FILIAL+G2_PRODUTO+G2_CODIGO"
					If a630SeekSG2(1,TRB->PRODUTO,cSeekRotAlt,@cSeekWhile) 
						Do While !Eof() .And. Eval(&cSeekWhile)
							nSoma++
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Inclui registros do roteiro alternativo        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SH1->(dbSeek(xFilial("SH1")+SG2->G2_RECURSO))
							RecLock("TRB",.T.)
							For i := 1 TO FCount()
								FieldPut(i,M->&(EVAL(bCampo,i)))
							Next i
							Replace  CODIGO With SG2->G2_CODIGO,;
								OPERAC With SG2->G2_OPERAC,;
								RECURSO With SG2->G2_RECURSO,;
								FERRAM With SG2->G2_FERRAM,;
								LINHAPR With SG2->G2_LINHAPR,;
								TPLINHA With SG2->G2_TPLINHA,;
								SETUP With u_C690HrCt(If(Empty(SG2->G2_FORMSTP),SG2->G2_SETUP,Formula(SG2->G2_FORMSTP))),;
								LOTEPAD With SG2->G2_LOTEPAD,;
								TEMPAD With u_C690HrCt(SG2->G2_TEMPAD),;
								TPOPER With SG2->G2_TPOPER,;
								TEMPSOB With u_C690HrCt(SG2->G2_TEMPSOB),;
								TPSOBRE With SG2->G2_TPSOBRE,;
								TEMPDES With u_C690HrCt(SG2->G2_TEMPDES),;
								TPDESD With SG2->G2_TPDESD,;
								DESPROP With SG2->G2_DESPROP,;
								CTRAB	With SG2->G2_CTRAB,;
								SEQROTA With SG2->G2_OPERAC,;
								SEQALOC With StrZero(Val(SEQALOC)+nSoma,7),;
								ROTALT With SG2->G2_ROTALT,;
								TPALOCF With If(SG2->(FieldPos("G2_TPALOCF"))>0,SG2->G2_TPALOCF,"3"),; //Valor Default eh 3
								ILIMITADO With SH1->H1_ILIMITA,;
								TEMPEND	With u_C690HrCt(If(SG2->(FieldPos("G2_TEMPEND"))>0,SG2->G2_TEMPEND,0)) 	//Valor Default eh Zero
							MsUnLock()
							If lC690GrvTrb
								ExecBlock("C690GTRB",.F.,.F.)
							EndIf
							If Len(aRegs[Len(aRegs)]) > 4095
								AADD(aRegs,{})
							EndIf
							AADD(aRegs[Len(aRegs)],{Recno(),.F.})
							dbSelectArea("SG2")
							dbSkip()
						EndDo
					EndIf
					// Renumera as sequencias de alocacao corretamente
					dbSelectArea("TRB")
					dbGotop()
					While !Eof()
						nAchou:=0
						For i:=1 to Len(aRegs)
							nAchou:=ASCAN(aRegs[i],{|x| x[1] == Recno()})
							If nAchou > 0
								Exit
							EndIf
						Next i
						If nAchou == 0 .And. Val(TRB->OPERAC) >= nSeqOperac .And. Val(TRB->SEQALOC) >= nSeqAloc
							If Len(aRegs[Len(aRegs)]) > 4095
								AADD(aRegs,{})
							EndIf
							AADD(aRegs[Len(aRegs)],{Recno(),.T.})
						EndIf
						dbSkip()
					EndDo
					For j:=1 to Len(aRegs)
						For i:=1 to Len(aRegs[j])
							If aRegs[j,i,2]
								dbGoto(aRegs[j,i,1])
								Replace SEQALOC With StrZero(Val(SEQALOC)+nSoma,7)
							EndIf
						Next i
					Next j
					// Apaga registro original
					dbGoto(aRegs[1,1,1])
					RecLock("TRB",.F.,.T.)
					dbDelete()
					Exit
				EndIf

			ElseIf mv_par01 == 1	// Aloca‡„o Pelo Fim

				nNumDes := IIf( nNumDesdob > 1, 0, -1 )

				For k := 1 to nNumDesdob

					aOpcoes := {}
					aSubDiv := {}
					aAloc   := {}
					aRegFerr:= {}

					// Acresce … primeira aloca‡„o, o valor quebrado resultante da divis„o
					// da opera‡„o em desdobramentos.
					If nNumDesdob > 1
						nDurDesdob := nTmpDesdob
						If k == 1
							nDurDesdob+=nQuebra
						EndIf
						nDurDesdob+=nSetupOrig
					EndIf

					nOldDurDesdob := nDurDesdob

					If lBlockAltDesd
						xRetBlock := ExecBlock("C690ALTDESD", .F., .F., {TRB->RECURSO, nDurDesdob, k, aAlter, aSecun})
						If ValType(xRetBlock) == "A"
							If ValType(xRetBlock[1]) == "A" .And. ValType(xRetBlock[2]) == "A"
								aAlter := aClone(xRetBlock[1])
								aSecun := aClone(xRetBlock[2])
							Endif
						Endif
					Endif

					// A partir do Bit de inicio, busca melhor recurso para alocar
					//Principal,alternativos e secundarios
					lAlternativo := Len(aAlter)>0
					For i := 1 to If(lAlternativo,Len(aAlter)+1,Len(aSecun)+1)
						If lA690Setup
							nDurDesdob  := nOldDurDesdob
							c690Recurso := If(i == 1, TRB->RECURSO, If(Len(aAlter)>0,aAlter[i-1],aSecun[i-1]))
							C690RetSet  := ExecBlock("u_C690Stp", .F., .F., {TRB->RECURSO, c690Recurso, nDurDesdob - nOldSetupOrig, nOldSetupOrig, nSetup, k})
							If ValType(C690RetSet) == "A" .And. Len(C690RetSet) == 2 .And. Valtype(C690RetSet[1]) == "N" .And. Valtype(C690RetSet[2]) == "N"
								nDurDesdob := C690RetSet[1] + C690RetSet[2]
								nSetup     := C690RetSet[2]
								nSetupOrig := C690RetSet[2]
							Endif
						Endif
						If i == 1
							aAloc := C690BsAl(TRB->RECURSO, nBit, nDurDesdob, cUltFerr, aRet, @aOcorre10, @aOcorre11, aRecursos, aFerram,@nSetUp,"P" )
						Else
							nSetUp:=nSetupOrig
							// Caso so tenha recurso secundario e nao queira otimizar
							// alocacao, abandona laco
							If Len(aAlter) <= 0 .And. !lOtimSecun
								Exit
							EndIf
							aAloc := C690BsAl(If(Len(aAlter)>0,aAlter[i-1],aSecun[i-1]), nBit, nDurDesdob, cUltFerr, aRet, @aOcorre10, @aOcorre11, aRecursos, aFerram,@nSetUp,If(lAlternativo,"A","S"))
						EndIf

						// Armazena a melhor data fim de cada Recurso
						If Len(aAloc) > 0
							Aadd(aOpcoes,{aAloc[1][1],aAloc[1][2],aAloc[1][3],aAloc[1][4],aAloc[1][5],aAloc[1][6],aAloc[1][7],aAloc[1][8],aAloc[1][9]})
						Endif
					Next i
					// Se nao conseguiu alocar nem no Recurso Principal e nem nos alternativos
					// tenta os recursos secundarios:
					If Empty(aOpcoes) .And. !Empty(aSecun) .And. lOtimSecun

						For i := 1 to Len(aSecun) // secundarios

							If lA690Setup
								C690RetSet  := ExecBlock("C690Stp", .F., .F., {TRB->RECURSO, aSecun[i], nDurDesdob, nOldSetupOrig, nSetup, k})
								If ValType(C690RetSet) == "A" .And. Len(C690RetSet) == 2 .And. Valtype(C690RetSet[1]) == "N" .And. Valtype(C690RetSet[2]) == "N"
									nDurDesdob := C690RetSet[1] + C690RetSet[2]
									nSetup     := C690RetSet[2]
								Endif
							Endif

							aAloc := C690BsAl(aSecun[i] , nBit, nDurDesdob, cUltFerr, aRet, @aOcorre10, @aOcorre11, aRecursos, aFerram ,@nSetUp,"S" )

							// Armazena a melhor data fim de cada Recurso
							If Len(aAloc) > 0
								Aadd(aOpcoes,{aAloc[1][1],aAloc[1][2],aAloc[1][3],aAloc[1][4],aAloc[1][5],aAloc[1][6],aAloc[1][7],aAloc[1][8],aAloc[1][9]})
							Endif

						Next i

					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Seleciona a melhor data fim entre os recursos disponiveis ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(aOpcoes)
						cRecurso := aOpcoes[1,1]
						nTempo   := Round(aOpcoes[1,2],5)
						nFimIdeal:= aOpcoes[1,3]
						nDur     := aOpcoes[1,4]
						aSubDiv  := aOpcoes[1,5]
						aRegFerr := aOpcoes[1,6]
						// Acerto na quebra desdobramento
						If nNumDesdob > 1
							nQuantAloc:=u_C690QtAl(cRecurso,aRecursos,nDur,aOpcoes,1,nNumDesdob)
						Else
							nQuantAloc	:=TRB->QTDPROD
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ O primeiro apontamento ja esta calculado pois contem a³
						//³ diferenca do calculo ref aos outros apontamentos      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For i := 1 to Len(aOpcoes)
							If aOpcoes[i,3] > nFimIdeal
								cRecurso := aOpcoes[i,1]
								nTempo   := Round(aOpcoes[i,2],5)
								nFimIdeal:= aOpcoes[i,3]
								nDur     := aOpcoes[i,4]
								aSubDiv  := aOpcoes[i,5]
								aRegFerr := aOpcoes[i,6]
								// Acerto na quebra desdobramento
								If nNumDesdob > 1
									nQuantAloc:=u_C690QtAl(cRecurso,aRecursos,nDur,aOpcoes,i,nNumDesdob)
								Else
									nQuantAloc	:=TRB->QTDPROD
								EndIf
							Endif
						Next i
					EndIf

					// Se Conseguir
					If !Empty(aSubDiv)

						If ExistBlock("U_C690ALOC")
							aRetPEAloc := ExecBlock("U_C690ALOC",.F.,.F.,{nSetup,nTempEnd,aSubDiv,k,nNumDesdob})
							If Len(aRetPEAloc) == 3 .And. ValType(aRetPEAloc[1]) == "N" .And. ValType(aRetPEAloc[2]) == "N" .And. ValType(aRetPEAloc[3]) == "A"
								nSetup   := aRetPEAloc[1]
								nTempEnd := aRetPEAloc[2]
								aSubDiv  := aClone(aRetPEAloc[3])
							EndIf
						EndIf
					
						// Fun‡„o que atualiza os Arquivos Bin rios da Carga e de Ferramentas
						u_C690AtCg(@cCalStr, @aRecursos, @cUltFerr, aRet, cRecurso, aSubDiv, aFerram, aRegFerr,TRB->ILIMITADO == "S")

						If !lMudaPrafim
							cSubDiv := ""
							For i := Len(aSubDiv) to 1 Step -1
								cSubDiv += StrZero(aSubDiv[i][1],6)+StrZero(aSubDiv[i][2],6)
							Next i
							nIndSubDiv := FSeek( nSubDivHdl, 0, 2)
							FWrite( nSubDivHdl, TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD+cRecurso+StrZero(Len(aSubDiv),3)+cSubDiv+Chr(13)+Chr(10))
						EndIf
						nSubDiv := 0
						If Len(aSubDiv) > 1
							// Avalia se ha' alguma alocacao no meio desta, se houver divide esta em mais de uma
							nIniSubDiv := Len(aSubDiv)
							nDur := 0
							nNumDes++
							For i:= Len(aSubDiv) to 2 Step -1
								nLigados := Look4Bit( cCalStr, aSubDiv[i][1], (aSubDiv[i-1][1]-1)-aSubDiv[i][1], aRet[4] )
								nDur += aSubDiv[i][2]
								If ( (aSubDiv[i-1][1]-1)-aSubDiv[i][1] ) - nLigados # aSubDiv[i][2]
									nInicio := aSubDiv[nIniSubDiv][1]
									nFim    := aSubDiv[i][1]+aSubDiv[i][2]
									aDtHrIni:=u_Bit2DtHr(nInicio,dDataPar)
									aDtHrFim:=u_Bit2DtHr(nFim,dDataPar)
									nSubDiv++
									U_C690ASH8(cRecurso,aDtHrIni,aDtHrFim,nInicio,nFim,nNumDes,nSubDiv,nDur,nIndSubDiv,nQuantAloc,nSetup,nTempEnd)
									nIniSubDiv := i-1
									nDur := 0
								EndIf
							Next i
							i := 1
							nDur += aSubDiv[i][2]
							nDur -= nSetUp
							nInicio := aSubDiv[nIniSubDiv][1]
							nFim := aSubDiv[i][1]+aSubDiv[i][2]
							aDtHrIni := u_Bit2DtHr(nInicio,dDataPar)
							aDtHrFim := u_Bit2DtHr(nFim,dDataPar)
							nSubDiv := IIf( nSubDiv # 0, nSubDiv++, 0 )
							U_C690ASH8(cRecurso,aDtHrIni,aDtHrFim,nInicio,nFim,nNumDes,nSubDiv,nDur,nIndSubDiv,nQuantAloc,nSetup,nTempEnd)
						Else
							nInicio := aSubDiv[Len(aSubDiv)][1]
							nFim    := aSubDiv[1][1]+aSubDiv[1][2]
							aDtHrIni:=u_Bit2DtHr(nInicio,dDataPar)
							aDtHrFim:=u_Bit2DtHr(nFim,dDataPar)
							nNumDes++
							nDur    -= nSetUp
							U_C690ASH8(cRecurso,aDtHrIni,aDtHrFim,nInicio,nFim,nNumDes,nSubDiv,nDur,nIndSubDiv,nQuantAloc,nSetup,nTempEnd)
						EndIf

					Else

						// Se nao conseguiu alocar VERIFICA se a operacao utiliza
						// roteiro de operacoes alternativo
						If Empty(aOpcoes) .And. !Empty(TRB->ROTALT)
							Exit
						EndIf

						If mv_par27 == 1
							u_C690DSH8(nSubDivHdl,aRet,aRegFerr,aSubDiv,aFerram)
						Endif

						If TRB->DATPRF < dDataPar + mv_par02 .Or. lMudapraFim
							If lMudapraFim .And. If(Len(aAlter)>0,Len(aAlter)+3,Len(aSecun)+3) < nNumDesdob
								If !u_C690Ocor(12,.T.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,@lDica2,nNumDesdob,Len(aAlter))
									Return .F.
								Else
									Exit
								EndIf
							EndIf
							If !u_C690Ocor(8,.T.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,@lDica1)
								If !lMudapraFim
									FClose(nSubDivHdl)
								EndIf
								Return .F.
							Else
								Exit
							EndIf
						Else
							If !u_C690Ocor(9,.T.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
								If !lMudapraFim
									FClose(nSubDivHdl)
								EndIf
								Return .F.
							Else
								Exit
							EndIf
						Endif

					EndIf

				Next k

				If lMudapraFim
					lMudapraFim := .F.
					mv_par01 := 2
				Else
					If !u_C690Ajst(aRet,@lFirstAjust,@nBitAjust)
						u_C690DSH8(nSubDivHdl,aRet,aRegFerr,aSubDiv,aFerram)
						nBit -= nBitAjust
						Loop
					Else
						If nBitAjust # 1
							u_C690DSH8(nSubDivHdl,aRet,aRegFerr,aSubDiv,aFerram)
							nBit += nBitAjust+1
							nBitAjust := 1
							Loop
						EndIf
					EndIf
				EndIf

				// Se nao conseguiu alocar VERIFICA se a operacao utiliza
				// roteiro de operacoes alternativo
				If Empty(aOpcoes) .And. !Empty(TRB->ROTALT)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Salva a integridade dos campos de Bancos de Dados  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("TRB")
					aRegs:={{}};nSeqOperac:=Val(TRB->OPERAC);nSeqAloc:=Val(TRB->SEQALOC);nSoma:=0
					If Len(aRegs[Len(aRegs)]) > 4095
						AADD(aRegs,{})
					EndIf
					AADD(aRegs[Len(aRegs)],{Recno(),.F.})
					For i := 1 TO FCount()
						M->&(EVAL(bCampo,i)) := FieldGet(i)
					Next i
					dbSelectArea("SG2")
					dbSetOrder(1)
					cSeekRotAlt	:=xFilial("SG2")+TRB->PRODUTO+TRB->ROTALT
					cSeekWhile	:= "G2_FILIAL+G2_PRODUTO+G2_CODIGO"
					a630SeekSG2(1,TRB->PRODUTO,cSeekRotAlt+"z",@cSeekWhile,,.T.) 
					dbSkip(-1)
					Do While !Bof() .And. &cSeekWhile == cSeekRotAlt
						nSoma++
						SH1->(dbSeek(xFilial("SH1")+SG2->G2_RECURSO))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inclui registros do roteiro alternativo        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RecLock("TRB",.T.)
						For i := 1 TO FCount()
							FieldPut(i,M->&(EVAL(bCampo,i)))
						Next i
						Replace  CODIGO With SG2->G2_CODIGO,;
							OPERAC With SG2->G2_OPERAC,;
							RECURSO With SG2->G2_RECURSO,;
							FERRAM With SG2->G2_FERRAM,;
							LINHAPR With SG2->G2_LINHAPR,;
							TPLINHA With SG2->G2_TPLINHA,;
							SETUP With u_C690HrCt(If(Empty(SG2->G2_FORMSTP),SG2->G2_SETUP,Formula(SG2->G2_FORMSTP))),;
							LOTEPAD With SG2->G2_LOTEPAD,;
							TEMPAD With u_C690HrCt(SG2->G2_TEMPAD),;
							TPOPER With SG2->G2_TPOPER,;
							TEMPSOB With u_C690HrCt(SG2->G2_TEMPSOB),;
							TPSOBRE With SG2->G2_TPSOBRE,;
							TEMPDES With u_C690HrCt(SG2->G2_TEMPDES),;
							TPDESD With SG2->G2_TPDESD,;
							DESPROP With SG2->G2_DESPROP,;
							CTRAB	With SG2->G2_CTRAB,;
							SEQROTA With SG2->G2_OPERAC,;
							SEQALOC With StrZero(Val(SEQALOC)+nSoma,7),;
							ROTALT With SG2->G2_ROTALT,;
							TPALOCF With If(SG2->(FieldPos("G2_TPALOCF"))>0,SG2->G2_TPALOCF,"3"),; //Valor Default							
							ILIMITADO With SH1->H1_ILIMITA,;
							TEMPEND	With u_C690HrCt(If(SG2->(FieldPos("G2_TEMPEND"))>0,SG2->G2_TEMPEND,0)) 	//Valor Default eh Zero
						MsUnLock()
						If lC690GrvTrb
							ExecBlock("C690GTRB",.F.,.F.)
						EndIf
						If Len(aRegs[Len(aRegs)]) > 4095
							AADD(aRegs,{})
						EndIf
						AADD(aRegs[Len(aRegs)],{Recno(),.F.})
						dbSelectArea("SG2")
						dbSkip(-1)
					EndDo
					// Renumera as sequencias de alocacao corretamente
					dbSelectArea("TRB")
					dbGotop()
					While !Eof()              
						For i:=1 to Len(aRegs)
							nAchou:=ASCAN(aRegs[i],{|x| x[1] == Recno()})
							If nAchou > 0
								Exit
							EndIf
						Next i
						If nAchou == 0 .And. Val(TRB->OPERAC) <= nSeqOperac .And. Val(TRB->SEQALOC) >= nSeqAloc
							If Len(aRegs[Len(aRegs)]) > 4095
								AADD(aRegs,{})
							EndIf
							AADD(aRegs[Len(aRegs)],{Recno(),.T.})
						EndIf
						dbSkip()
					EndDo
					For j:=1 to Len(aRegs)
						For i:=1 to Len(aRegs[j])
							If aRegs[j,i,2]
								dbGoto(aRegs[j,i,1])
								Replace SEQALOC With StrZero(Val(SEQALOC)+nSoma,7)
							EndIf
						Next i
					Next j
					// Apaga registro original
					dbGoto(aRegs[1,1,1])
					RecLock("TRB",.F.,.T.)
					dbDelete()                   
					Exit
				EndIf

			EndIf		// mv_par01 (Pelo Fim ou Pelo In¡cio)
			If lMudapraFim
				mv_par01 := 1
				nBit := U_C690CalB(aAlter,aSecun,aRet)
				If nBit == -1
					If mv_par27 == 1
						u_C690DSH8(nSubDivHdl,aRet,aRegFerr,aSubDiv,aFerram)
					Endif
					lMudapraFim := .F.
					If !u_C690Ocor(8,.T.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,@lDica1)
						Return .F.
					Else
						Exit
					EndIf
				EndIf
			Else
				Exit
			EndIf
		End
	EndIf
	dbSelectArea("TRB")
	dbSkip()
End

If mv_par01 == 1
	FClose(nSubDivHdl)
EndIf

Set(3,nDec)
A690CheckSC2(.T.)

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C690Aloc ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 02/07/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Aloca‡„o da Carga M quina  (Processamento DOS/WINDOWS)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Aloc(aRet,aRecursos,lOk,nI,oCenterPanel)
Local cArqTrab:="",cIndSC2:="",aIndTrb:={}
Local nTempoIni  := Seconds(),nTempoFim:=0,cTempo:=""
Local cSeek := Nil
Local nX := 0
Local lA609SH8D := ExistBlock("C690SH8D")
#IFDEF TOP
	Local cFile
#ENDIF

Private aNaoMuda := {{}}

cSeqCarga:=GetMV("MV_SEQCARG",,Space(6))
PutMV("MV_SEQCARG",Soma1(cSeqCarga))

Do While .T.
	
	If OpenSemSH8()
		If (oCenterPanel <> NIL)
			oCenterPanel:SaveLog(OemToAnsi(""))
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Flag que indica se rodou alocacao ou nao                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lAlocou:=.T.
		// Atualiza Flag (MV_FLAGPCP) indicando se, na Carga M quina est„o sendo
		// consideradas as OPs Sacramentadas ou n„o.
		A690AtuFlag(2,IIf(mv_par05 == 1, 1, 0))
		If File(cDirPcp+cNameCarga+".OCR")
			Ferase(cDirPcp+cNameCarga+".OCR")
		EndIf
		If Select("CARGA") > 0
			dbSelectArea("CARGA")
			dbCloseArea()
		EndIf
		If Select("FER") > 0
			dbSelectArea("FER")
			dbCloseArea()
		EndIf
		FErase(cDirPcp+cNameCarga+".FER")
		FErase(cDirPcp+cNameCarga+".FID")
		FErase(cDirPcp+cNameCarga+".OPE")
		FErase(cDirPcp+cNameCarga+"1" + OrdBagExt())
		FErase(cDirPcp+cNameCarga+"2" + OrdBagExt())
		FErase(cDirPcp+cNameCarga+"3" + OrdBagExt())
		FErase(cDirPcp+cNameCarga+"4" + OrdBagExt())
		FErase(cDirPcp+cNameCarga+"5" + OrdBagExt())
		FErase(cDirPcp+cNameCarga+"6" + OrdBagExt())
				
		dbSelectArea("SH8")
		aCampSH8 := dbStruct()

		dbSeek(cSeek := xFilial("SH8"))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazeno operacoes que nao serao reprocessadas               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		Do While ! Eof() .And. H8_FILIAL == xFilial("SH8")

			nOldOrdC2 := SC2->(IndexOrd())
			dbSetOrder(1)
			SC2->(dbSeek(xFilial("SC2") + SH8->H8_OP))
			SC2->(dbSetOrder(nOldOrdC2))

			If ! u_C690Lnn()
				If Len(aNaoMuda[Len(aNaoMuda)]) > 4090
					Aadd(aNaoMuda, {})
				Endif
				Aadd(aNaoMuda[Len(aNaoMuda)], {})
				aEval(dbStruct(), {|z,w| Aadd(aNaoMuda[Len(aNaoMuda), Len(aNaoMuda[Len(aNaoMuda)])], FieldGet(w))})
			Endif
			dbSkip()
		Enddo

		cArqSH8 := u_NewCrTb(aCampSH8,.T.,cDirPcp)
		If mv_par03 == 1
			dbSelectArea("SHE")
			cKeyFerram := IndexKey()
			aCampSHE := dbStruct()
			cArqFerram := u_NewCrTb(aCampSHE,.T.,cDirPcp)
		EndIf
		dbCommitAll()
		If FRename(cArqSH8+GetDBExtension(),cDirPcp+cNameCarga+".OPE") == 0
			// Avaliar rotina para funcionar no AS400 E TOPCONN
			dbUseArea(.T.,cDrvCarga,cDirPcp+cNameCarga+".OPE","CARGA",.F.,.F.)
			dbSelectArea("SH8")
			dbSetOrder(1)
			cKeySH8 := IndexKey()
			IndRegua("CARGA",cDirPcp+cNameCarga+"1",cKeySH8,cDrvCarga,,"Criando Indices .........")	//"Criando Indices ........."
			dbSelectArea("SH8")
			dbSetOrder(2)
			cKeySH8 := IndexKey()
			IndRegua("CARGA",cDirPcp+cNameCarga+"2",cKeySH8,cDrvCarga,,"Criando Indices .........")	//"Criando Indices ........."
			dbSelectArea("SH8")
			dbSetOrder(3)
			cKeySH8 := IndexKey()
			IndRegua("CARGA",cDirPcp+cNameCarga+"3",cKeySH8,cDrvCarga,,"Criando Indices .........")	//"Criando Indices ........."
			dbSelectArea("SH8")
			cKeySH8 := "H8_FILIAL+SubStr(H8_OP,1,8)+H8_SEQPAI+Substr(H8_OP,12, 2)+H8_OPER"
			IndRegua("CARGA",cDirPcp+cNameCarga+"4",cKeySH8,cDrvCarga,,"Criando Indices .........")	//"Criando Indices ........."
			dbSelectArea("SH8")
			cKeySH8 := "H8_FILIAL+H8_OP+H8_RECURSO+STR(H8_BITFIM,8)"
			IndRegua("CARGA",cDirPcp+cNameCarga+"5",cKeySH8,cDrvCarga,,"Criando Indices .........")	//"Criando Indices ........."
			dbSelectArea("SH8")
			cKeySH8 := "H8_FILIAL+H8_OP+H8_OPER+DTOS(H8_DTFIM)"
			IndRegua("CARGA",cDirPcp+cNameCarga+"6",cKeySH8,cDrvCarga,,"Criando Indices .........")	//"Criando Indices ........."

			dbClearIndex()
			dbSetIndex(cDirPcp+cNameCarga+"1")
			dbSetIndex(cDirPcp+cNameCarga+"2")
			dbSetIndex(cDirPcp+cNameCarga+"3")
			dbSetIndex(cDirPcp+cNameCarga+"4") 
			dbSetIndex(cDirPcp+cNameCarga+"5")
			dbSetIndex(cDirPcp+cNameCarga+"6")
			dbGotop()
		EndIf
		If mv_par03 == 1
			If FRename(cArqFerram+GetDBExtension(),cDirPcp+cNameCarga+".FER") == 0
				dbUseArea(.T.,cDrvCarga,cDirPcp+cNameCarga+".FER","FER",.F.,.F.)
				IndRegua("FER",cDirPcp+cNameCarga+".FID",cKeyFerram,,,"Criando Indices .........")	//"Criando Indices ........."
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PE executado antes de apagar o arquivo/registros do SH8      ³
		//³ conforme solicitado no bops 00000097154                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 		If lA609SH8D
			ExecBlock("C690SH8D",.F.,.F.)
		EndIf

		dbSelectArea("SH8")
		#IFNDEF TOP
			// Em arquivo compartilhado apaga todo o arquivo
			If Empty(xFilial("SH8"))
				If MA280FLock("SH8")
					Zap
				EndIf
			Else
				C690DlRg()
			EndIf
		#ELSE
			// Em arquivo compartilhado apaga todo o arquivo
			If Empty(xFilial("SH8"))
				cFile := RetSqlName("SH8")
				TCSQLEXEC("DELETE FROM "+cFile)
				dbCloseArea()
			Else
				// funcao que deleta os registros da SH8
				C690DlRg()
			EndIf
			dbSelectArea("SH8")
			dbGotop()
		#ENDIF
		// Montagem dos Arquivos Binarios utilizados na Carga Maquina
		lOk := u_C690MtBn(@aRet,@aRecursos,oCenterPanel)
		If lOk
			// Montagem do Arquivo de Trabalho da Carga Maquina
			lOk := C690Mtrb(@cArqTrab,@cIndSC2,@aIndTRB,aRecursos,oCenterPanel)
		EndIf
		If lOk
			// Alocacao
			lOk := u_C690Proc(aRet,aRecursos,oCenterPanel)
		EndIf
		If aRet[1] # NIL
			FClose(aRet[1])
		EndIf
		If aRet[5] # NIL
			FClose(aRet[5])
		EndIf
		If aRet[9] # NIL
			FClose(aRet[9])
		EndIf
		If mv_par03 == 1
			If aRet[6] # NIL
				FClose(aRet[6])
			EndIf
			If aRet[7] # NIL
				FClose(aRet[7])
			EndIf
		EndIf
		If !Empty(cIndSC2)
			RetIndex("SC2")
			dbClearFilter()
			dbSetOrder(1)
			Ferase(cIndSC2+OrdBagExt())
			cIndSC2 := ""
		EndIf
		If !u_C690IsBt() .And. (lShowOCR .Or. lOcorreu)
			lShowOCR := .F.
			lOcorreu := .F.
			u_C690ShOc()
			If !lOk
				If File(cDirPcp+cNameCarga+".MAQ")
					FErase(cDirPcp+cNameCarga+".MAQ")
				EndIf
				If File(cDirPcp+cNameCarga+".CAL")
					FErase(cDirPcp+cNameCarga+".CAL")
				EndIf
				If File(cDirPcp+cNameCarga+".COP")
					FErase(cDirPcp+cNameCarga+".COP")
				EndIf
				If File(cDirPcp+cNameFerr+".ARQ")
					FErase(cDirPcp+cNameFerr+".ARQ")
				EndIf
				If File(cDirPcp+cNameFerr+".IND")
					FErase(cDirPcp+cNameFerr+".IND")
				EndIf
			EndIf
		EndIf
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
			For nX := 1 To Len (aIndTRB)
				FErase(aIndTRB[nX]+OrdBagExt())
			Next nX
		EndIf
		dbSelectArea("SH8")
		RetIndex("SH8")
		nRegua:=0
		nTotRegua:=0
		If !u_C690IsBt()
			If (oCenterPanel==Nil)
				oRegua:Set(nRegua)
				SysRefresh()
			Else
				oCenterPanel:IncRegua1()
			EndIf
		EndIf

		If lOk
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia mensagem de aviso apos termino da rotina               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTempoFim:=Seconds()
			cTempo:=StrZero((nTempoFim-nTempoIni)/60,5,0)
			MEnviaMail("024",{CUSERNAME,SubStr(cNumEmp,1,2),SubStr(cNumEmp,3,2),cTempo})
			If !u_C690IsBt() .AND. mv_par22 == 1
				u_C690Vis(oCenterPanel)
			Else
				lReprocessa := .F.
			Endif
			If ! lReprocessa
				If Select("CARGA") == 0
					If !File(cDirPcp+cNameCarga+".OPE") .Or. !File(cDirPcp+cNameCarga+"1" + OrdBagName()) .Or. ;
						!File(cDirPcp+cNameCarga+"2" + OrdBagName()) .Or. !File(cDirPcp+cNameCarga+"3" + OrdBagName()) .Or. ;
						!File(cDirPcp+cNameCarga+"4" + OrdBagName()) .Or. !File(cDirPcp+cNameCarga+"5" + OrdBagName()) .Or. ;
						!File(cDirPcp+cNameCarga+"6" + OrdBagExt())
						// Apaga indicador de Atualiza‡„o dos Arquivos SC2, SC1, SD4, etc a partir da Carga
						A690CheckSC2(.F.)
						
						//-- Fecha Semaforo do SH8
						ClosSemSH8()
						
						If (oCenterPanel <> NIL)
							oCenterPanel:SaveLog(OemToAnsi(""))
						EndIf
						
						Return NIL
					EndIf
					dbUseArea(.T.,cDrvCarga,cDirPcp+cNameCarga+".OPE","CARGA",.F.,.F.)
					dbSetIndex(cDirPcp+cNameCarga+"1")
					dbSetIndex(cDirPcp+cNameCarga+"2")
					dbSetIndex(cDirPcp+cNameCarga+"3")
					dbSetIndex(cDirPcp+cNameCarga+"4")
					dbSetIndex(cDirPcp+cNameCarga+"5")
					dbSetIndex(cDirPcp+cNameCarga+"6")
					dbGotop()
				EndIf
				dbSelectArea("CARGA")
				Pack
				dbGotop()
				If (Bof() .And. Eof())
					// Apaga indicador de Atualiza‡„o dos Arquivos SC2, SC1, SD4, etc a partir da Carga
					A690CheckSC2(.F.)

					//-- Fecha Semaforo do SH8
					ClosSemSH8()
					
					If (oCenterPanel <> NIL)
						oCenterPanel:SaveLog(OemToAnsi(""))
					EndIf

					Return NIL
				EndIf
				If A690CheckSC2()
					A690AtuSC2()
				EndIf
			Endif
		EndIf

		If ! lReprocessa
			If Select("FER") > 0
				dbSelectArea("FER")
				dbCloseArea()
			EndIf

			If Select("CARGA") > 0
				dbSelectArea("CARGA")
				dbCloseArea()
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Copia arquivos de processamento para diretorio dos dados               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cDirPCP != cDirDados .And. lOk
				u_C690CpFl()
			EndIf  
		EndIf      
		
		//-- Fecha Semaforo do Sh8
		ClosSemSH8()
		
		If (oCenterPanel <> NIL)
			oCenterPanel:SaveLog(OemToAnsi(""))
		EndIf
	Else
		lReprocessa := .F.		
	EndIf                 
	
	If ! lReprocessa
		Exit
	Endif
Enddo


Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690Qst     ³ Autor ³Rodrigo de A Sartorio³ Data ³ 18/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada da pergunte na Carga Maquina                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parâmetro ³ lOpen : variável lógica que habilita ou não a tela de edi- ³±±
±±³          ³ ção das perguntas do SX1                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Qst(lOpen)
Local cPeriodo  := "",;
	nPrecisao  := GetMV("MV_PRECISA"),;
	nMaxPrdo  := 0,;
	lContinue := .T.
dbSelectArea("SB1")

While lContinue
	Pergunte("MTC690",lOpen)

	// Limita ate 512 K de memoria (PROTHEUS)

	If (MV_PAR02*nPrecisao*24) <= ((512*1024)-1)
		lContinue := .F.
	Else
		nMaxPrdo := Int((512*1024)/(nPrecisao*24))
		cPeriodo := Str(nMaxPrdo,4)+" dias a "+Str((60/nPrecisao),2)+" min." //" dias a "###" min."
		Help(" ",1,"FORAPERIOD",,"Maior Periodo : "+cPeriodo,5,1)	//"Maior Periodo : "
		MV_PAR02  := u_C690MXDO(nMaxPrdo)
		lContinue := .F.
	EndIf
EndDo
dDataPar:=IIF(Empty(mv_par15),dDataBase,mv_par15)
If mv_par01 == 2 .And. mv_par27 == 1
	mv_par27 := 2
Endif
If mv_par01 == 1 .And. mv_par28 == 1
	mv_par28 := 2
Endif	

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690MXDO    ³ Autor ³Robson Bueno Silva   ³ Data ³ 18/07/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que grava o periodo de alocacao da carga maquina,   ³±±
±±³          ³ corrigido automaticamente para o periodo maximo.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parâmetro ³ Número equivalente ao período que será gravado no SX1      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690MXDO(nMaxPrdo)

Local cAlias := Alias(),;
	nRecNo := 0           
Local nTamSX1 := Len(SX1->X1_GRUPO)

DbSelectArea("SX1") ; nRecNo := RecNo()

If DbSeek(PADR("MTC690",nTamSX1)+"02",.F.)
	RecLock("SX1")
	SX1->X1_CNT01 := StrZero(nMaxPrdo, 3)
	MsUnLock()
Endif

DbGoto(nRecNo) ; DbSelectArea(cAlias)

Return(nMaxPrdo)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690Mtrb    ³ Autor ³ Robson Bueno Silv   ³ Data ³ 05/09/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que monta arquivo de trabalho com operacoes a serem ³±±
±±³          ³ alocadas.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parâmetros³ cArqTrab : Nome do arquivo de trabalho                     ³±±
±±³          ³ cIndSC2  : Nome do arquivo de indice a ser gerado para SC2 ³±±
±±³          ³ aIndTRB  : Indice adicional que será criado para cArqTRB   ³±±
±±³          ³ aRecursos: Informações sobre o uso do recurso e calendário ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C690Mtrb(cArqTrab,cIndSC2,aIndTRB,aRecursos,oCenterPanel)
Local aCampos := {}, cKeySC2, nQuant, cSeekSH6, lOk := .T.
Local aRetPE		:= {}
Local nIndSC2
Local nTamSetup, nDecSetup, nTamLotepad, nDecLotepad, nTamTempad, nDecTempad
Local nTamTempsob, nDecTempsob, nTamTempdes, nDecTempdes, nTamQtdProd
Local nDecQtdProd, aOcorre3 := {}
Local lNaoOP		:= .T., nPosAsBin
Local nSeqAloc		:= 1
Local cRoteiro		:= ""   
Local cSeekWhile	:= "G2_FILIAL+G2_PRODUTO+G2_CODIGO"
Local nQtdAloc		:= 0
Local lTotal		:=.F.
Local lFoundSH1		:=.F.,nOldOrderSH1:=0
Local lC690GrvTrb	:= (ExistBlock("C690GTRB"))
Local lC690FimTrb   := (ExistBlock("C690FTRB"))

// Caso utilize recurso ilimitado posiciona SH1 na ordem correta para pesquisa
dbSelectArea("SH1")
dbSetOrder(1)

// Busca tamanho de campos no SX3 (utiliza While para ganhar velocidade):
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SG2")
While !Eof() .And. X3_ARQUIVO == "SG2"
	If Alltrim(X3_CAMPO) == "G2_SETUP"
		nTamSetup := X3_TAMANHO
		nDecSetup := X3_DECIMAL
	ElseIf Alltrim(X3_CAMPO) == "G2_LOTEPAD"
		nTamLotepad := X3_TAMANHO
		nDecLotepad := X3_DECIMAL
	ElseIf Alltrim(X3_CAMPO) == "G2_TEMPAD"
		nTamTempad := X3_TAMANHO
		nDecTempad := X3_DECIMAL
	ElseIf Alltrim(X3_CAMPO) == "G2_TEMPSOB"
		nTamTempsob := X3_TAMANHO
		nDecTempsob := X3_DECIMAL
	ElseIf Alltrim(X3_CAMPO) == "G2_TEMPDES"
		nTamTempdes := X3_TAMANHO
		nDecTempdes := X3_DECIMAL
	EndIf
	dbSkip()
End
dbSetOrder(2)
dbSeek("C2_QUANT")
If Found()
	nTamQtdProd := X3_TAMANHO
	nDecQtdProd := X3_DECIMAL
EndIf
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta arquivo de trabalho                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCampos, {"OPNUM"    ,"C", 6,0 })	// C2_NUM
Aadd(aCampos, {"ITEM"     ,"C", 2,0 })	// C2_ITEM
Aadd(aCampos, {"ITEMGRD"  ,"C", 2,0 })	// C2_ITEMGRD
Aadd(aCampos, {"NIVEL"    ,"C", 2,0 })	// C2_NIVEL
Aadd(aCampos, {"SEQPAI"   ,"C", 3,0 })	// C2_SEQPAI
Aadd(aCampos, {"IDXSEQPAI","C", 3,0 })	// C2_SEQPAI
Aadd(aCampos, {"SEQUEN"   ,"C", 3,0 })	// C2_SEQUEN
Aadd(aCampos, {"PRIOR"    ,"C", 3,0 })	// C2_PRIOR
Aadd(aCampos, {"PRODUTO"  ,"C",TamSX3("B1_COD")[1],0 })	// C2_PRODUTO
Aadd(aCampos, {"DATPRF"   ,"D", 8,0 })	// C2_DATPRF
Aadd(aCampos, {"DATPRI"   ,"D", 8,0 })	// C2_DATPRI

Aadd(aCampos, {"CODIGO"   ,"C", TamSX3("G2_CODIGO")[1],0 })
Aadd(aCampos, {"OPERAC"   ,"C", TamSX3("G2_OPERAC")[1],0 })
Aadd(aCampos, {"RECURSO"  ,"C", TamSX3("G2_RECURSO")[1],0 })
Aadd(aCampos, {"FERRAM"   ,"C", TamSX3("G2_FERRAM")[1],0 })
Aadd(aCampos, {"LINHAPR"  ,"C", TamSX3("G2_LINHAPR")[1],0 })
Aadd(aCampos, {"TPLINHA"  ,"C", TamSX3("G2_TPLINHA")[1],0 })
Aadd(aCampos, {"TPOPER"   ,"C", TamSX3("G2_TPOPER")[1],0 })
Aadd(aCampos, {"TPSOBRE"  ,"C", TamSX3("G2_TPSOBRE")[1],0 })
Aadd(aCampos, {"TPDESD"   ,"C", TamSX3("G2_TPDESD")[1],0 })
Aadd(aCampos, {"DESPROP"  ,"C", TamSX3("G2_DESPROP")[1],0 })
Aadd(aCampos, {"CTRAB"    ,"C", TamSx3("G2_CTRAB")[1],0 })
Aadd(aCampos, {"SETUP"    ,"N", nTamSetup+4  , nDecSetup+4   })	// G2_SETUP
Aadd(aCampos, {"LOTEPAD"  ,"N", nTamLotepad, nDecLotepad })	// G2_LOTEPAD
Aadd(aCampos, {"TEMPAD"   ,"N", nTamTempad+4 , nDecTempad+4  })	// G2_TEMPAD
Aadd(aCampos, {"TEMPSOB"  ,"N", nTamTempsob+4, nDecTempsob+4 }) // G2_TEMPSOB
Aadd(aCampos, {"TEMPDES"  ,"N", nTamTempdes+4, nDecTempdes+4 })	// G2_TEMPDES
Aadd(aCampos, {"QTDPROD"  ,"N", nTamQtdProd, nDecQtdProd })
Aadd(aCampos, {"QTDALOC"  ,"N", nTamQtdProd, nDecQtdProd })

Aadd(aCampos, {"SEQALOC"  ,"C", 7,0 })
Aadd(aCampos, {"OPERALOC" ,"L", 1,0 })
Aadd(aCampos, {"REGRA"    ,"C", 3,0 })
Aadd(aCampos, {"ITEMPAD"  ,"C", 3,0 })
Aadd(aCampos, {"OPAGLUT"  ,"C",11,0 })
Aadd(aCampos, {"RECAGLUT" ,"C", 6,0 })

// Campos criados para utilizacao com Roteiro Alternativo
Aadd(aCampos, {"ROTALT"   ,"C", 2,0 })
Aadd(aCampos, {"SEQROTA"  ,"C", 2,0 })

// Campo criado para utilizacao com Recurso Ilimitado
Aadd(aCampos, {"ILIMITADO"   ,"C", 1,0 })

Aadd(aCampos,{"INIVFIM" ,"C",14,0})
Aadd(aCampos,{"IDATAFIM","C",10,0})

//Campo criado para considerar a locacao da ferramenta durante:
// - setup (1)
// - operacao (2)
// - setup+operacao (3)
Aadd(aCampos, {"TPALOCF"  ,"C", 1, 0 }) //G2_TPALOCF

//Campo criado para considerar a alocacao no final do Recurso com
//tempo fixado, com as mesmas caracteristicas do SETUP
Aadd(aCampos, {"TEMPEND"  ,"N", nTamSetup+4  , nDecSetup+4   }) //G2_TEMPEND

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para adicionar campos na tabela temporaria  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("C690ADTRB")
	aRetPE  := ExecBlock("C690ADTRB", .F., .F., {aCampos})
	If ValType(aRetPE) == "A"
		aCampos := aClone(aRetPE)
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par07/08 - Data de Entrega de/ate                              ³
//³ mv_par09/10 - Ordens de Producao de/ate                           ³
//³ mv_par11/12 - Produto de/ate                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC2")
dbSetOrder(1)
cKeySC2 := IndexKey()
cIndSC2 := Left(CriaTrab(NIL,.F.),7)+"H"
IndRegua("SC2",cIndSC2,cKeySC2,,u_C690FSC2(),"Selecionando OPs.........")	//"Selecionando OPs........."
nIndSC2 := RetIndex("SC2")
#IFNDEF TOP
	dbSetIndex(cIndSC2+OrdBagExt())
#ENDIF
dbSetOrder(nIndSC2+1)
dbSeek(xFilial("SC2") + mv_par09, .T.)

If !Eof()
	lNaoOp := .F.
EndIf

If Select("CARGA") > 0
	If CARGA->(LastRec()) > 0
		lNaoOP := .F.
	EndIf
Endif
If lNaoOP
	u_C690Ocor(4)
	lOk := .F.
EndIf

cArqTrab := cDirPCP + cNameCarga + "TRB"
dbCreate(cArqTrab, aCampos, cDrvCarga)

dbUseArea(.T.,cDrvCarga,cArqTrab,"TRB",.F.,.F.)

dbSelectArea("SH6")
dbSetOrder(1)

dbSelectArea("SC2")
// Prepara a Regua de processamento de registros
nRegua:=0
If !u_C690IsBt()
	If (oCenterPanel==Nil)
		oRegua:nTotal:=nTotRegua:=LastRec()
	Else
		oCenterPanel:SetRegua1( LastRec() )	
	EndIf
EndIf

While !Eof() .And. C2_FILIAL == xFilial("SC2") .And. C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= mv_par10

	If ! u_C690Lnn()
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acerta os niveis do arquivo de OPs (SC2)                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SG1-> ( dbSeek(xFilial("SG1")+SC2->C2_PRODUTO) )
	If SG1->( Found() )
		RecLock("SC2",.F.)
		Replace C2_NIVEL With StrZero( 100 - Val( SG1->G1_NIV ) , 2 )
		MsUnLock()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par13/14 - Grupo de/ate                                        ³
	//³ mv_par16/17 - Tipo produto de/ate                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	If Found() .And. B1_GRUPO >= mv_par13 .And. B1_GRUPO <= mv_par14 .And.;
			B1_TIPO  >= mv_par16 .And. B1_TIPO  <= mv_par17
		If Empty(SC2->C2_ROTEIRO)
			dbSelectArea("SB1")
			dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
			If !Empty(SB1->B1_OPERPAD)
				cRoteiro:=SB1->B1_OPERPAD
			Else
				dbSelectArea("SG2")
				If a630SeekSG2(1,SC2->C2_PRODUTO,xFilial("SG2")+SC2->C2_PRODUTO+"01") 
					RecLock("SB1")
					Replace B1_OPERPAD With "01"
					MsUnLock()
					cRoteiro:="01"
				EndIf
			EndIf
		Else
			cRoteiro:=SC2->C2_ROTEIRO
		EndIf
		If !lMaqXQuant
			dbSelectArea("SG2")
			cSeekWhile	:= "G2_FILIAL+G2_PRODUTO+G2_CODIGO"
			If !a630SeekSG2(1,SC2->C2_PRODUTO,xFilial("SG2")+SC2->C2_PRODUTO+cRoteiro,@cSeekWhile) 
				If Ascan( aOcorre3, cRoteiro+SC2->C2_PRODUTO ) == 0
					Aadd( aOcorre3, cRoteiro+SC2->C2_PRODUTO )
					lOk := u_C690Ocor(3,.T.,cRoteiro,SC2->C2_PRODUTO,SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
					If !lOk
						Exit
					EndIf
				EndIf
			EndIf
		Else
			dbSelectArea("SZ1")
			dbSeek(xFilial("SZ1")+SB1->B1_REGRA)
			If !Found()
				If Ascan( aOcorre3,"01"+SC2->C2_PRODUTO ) == 0
					Aadd( aOcorre3,"01"+SC2->C2_PRODUTO )
					lOk := u_C690Ocor(3,.T.,"01",SC2->C2_PRODUTO,SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD)
					If !lOk
						Exit
					EndIf
				EndIf
			EndIf
		Endif
		If !lMaqXQuant
			dbSelectArea("SG2")
			Do While !Eof() .And. Eval(&cSeekWhile)
				nQuant := 0
				lTotal:=.F.
				// Verifica quantidade a ser produzida (antiga fun‡„o C690QtdOp())
				If mv_par04 == 1
					nQuant := SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
				Else
					dbSelectArea("SH6")
					cSeekSH6 := xFilial("SH6")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SC2->C2_PRODUTO+SG2->G2_OPERAC
					dbSeek(cSeekSH6)
					While !Eof() .And. cSeekSH6 == H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC
						If H6_PT == "T"
							lTotal:=.T.
							Exit
						EndIf
						nQuant += H6_QTDPROD+H6_QTDPERD
						dbSkip()
					End
					nQuant := SC2->C2_QUANT - nQuant
				Endif
				If nQuant > 0 .And. !lTotal
					dbSelectArea("SG2")
					// Caso filtre Recursos, verifica existencia no cadastro
					// sem o filtro
					If mv_par19 == 1
						nOldOrderSH1:=SH1->(IndexOrd())
						SH1->(dbSetOrder(1))
						lFoundSH1:=SH1->(dbSeek(xFilial("SH1")+SG2->G2_RECURSO))
						SH1->(dbSetOrder(nOldOrderSH1))
						// Se nao achou no SH1 sem o filtro, manda para ocorrencias
						If !lFoundSH1
							lOk := u_C690Ocor(6,.T.,G2_RECURSO,G2_OPERAC,SC2->C2_PRODUTO)
							If !lOk
								Exit
							EndIf
							dbSkip()
							Loop
							// Se o recurso nao esta selecionado, pula operacao
						ElseIf !(SG2->G2_RECURSO $ cRecSele)
							dbSkip()
							Loop
						EndIf
					Else
						nPosAsBin := u_C690AsBn( aRecursos, G2_RECURSO )
						If nPosAsBin == 0
							lOk := u_C690Ocor(6,.T.,G2_RECURSO,G2_OPERAC,SC2->C2_PRODUTO)
							If !lOk
								Exit
							EndIf
							dbSkip()
							Loop
						EndIf
					EndIf
					SH1->(dbSeek(xFilial("SH1")+SG2->G2_RECURSO))
					dbSelectArea("TRB")
					dbAppend()
					Replace  OPNUM With SC2->C2_NUM,;
						ITEM With SC2->C2_ITEM,;
						ITEMGRD With SC2->C2_ITEMGRD,;
						NIVEL With SC2->C2_NIVEL,;
						SEQPAI With SC2->C2_SEQPAI,;
						IDXSEQPAI With IIf( Empty(SC2->C2_SEQPAI), "000", SC2->C2_SEQPAI),;
						SEQUEN With SC2->C2_SEQUEN,;
						PRIOR With SC2->C2_PRIOR,;
						PRODUTO With SC2->C2_PRODUTO,;
						DATPRF With SC2->C2_DATPRF,;
						DATPRI With SC2->C2_DATPRI
					Replace  CODIGO With SG2->G2_CODIGO,;
						OPERAC With SG2->G2_OPERAC,;
						RECURSO With SG2->G2_RECURSO,;
						FERRAM With SG2->G2_FERRAM,;
						LINHAPR With SG2->G2_LINHAPR,;
						TPLINHA With SG2->G2_TPLINHA,;
						SETUP With u_C690HrCt(If(Empty(SG2->G2_FORMSTP),SG2->G2_SETUP,Formula(SG2->G2_FORMSTP))),;
						LOTEPAD With SG2->G2_LOTEPAD,;
						TEMPAD With u_C690HrCt(SG2->G2_TEMPAD),;
						TPOPER With SG2->G2_TPOPER,;
						TEMPSOB With u_C690HrCt(SG2->G2_TEMPSOB),;
						TPSOBRE With SG2->G2_TPSOBRE,;
						TEMPDES With u_C690HrCt(SG2->G2_TEMPDES),;
						TPDESD With SG2->G2_TPDESD,;
						DESPROP With SG2->G2_DESPROP,;
						CTRAB	With SG2->G2_CTRAB,;
						ROTALT With SG2->G2_ROTALT,;
						TPALOCF With If(SG2->(FieldPos("G2_TPALOCF"))>0,SG2->G2_TPALOCF,"3"),; //Valor Default						
						ILIMITADO With SH1->H1_ILIMITA,;
						TEMPEND	With u_C690HrCt(If(SG2->(FieldPos("G2_TEMPEND"))>0,SG2->G2_TEMPEND,0)) 	//Valor Default eh Zero
					Replace QTDPROD With nQuant
					Replace OPERALOC With .F.

					Replace INIVFIM  With StrZero(10000000000000-Val(NIVEL+IDXSEQPAI+SEQUEN+OPERAC),14)
					Replace IDATAFIM With StrZero(CTOD('31/12/49') - DATPRF,10)

					If lC690GrvTrb
						ExecBlock("C690GTRB",.F.,.F.)
					EndIf
				EndIf
				dbSelectArea("SG2")
				dbSkip()
			EndDo
		Else
			cOperac := "01"
			nQuant := 0
			lTotal:=.F.
			// Verifica quantidade a ser produzida (antiga fun‡„o C690QtdOp())
			If mv_par04 == 1
				nQuant := SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
			Else
				dbSelectArea("SH6")
				cSeekSH6 := xFilial("SH6")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SC2->C2_PRODUTO+cOperac
				dbSeek(cSeekSH6)
				While !Eof() .And. cSeekSH6 == H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC
					If H6_PT == "T"
						lTotal:=.T.
						Exit
					EndIf
					nQuant += H6_QTDPROD+H6_QTDPERD
					dbSkip()
				End
				nQuant := SC2->C2_QUANT - nQuant
			Endif
			If nQuant > 0 .And. !lTotal
				dbSelectArea("SZ1")
				dbSetOrder(1)
				nQtdAloc := IIF(SC2->C2_QTDALOC != 0,SC2->C2_QTDALOC,nQuant)
				dbSeek(xFilial("SZ1")+SB1->B1_REGRA+StrZero(nQtdAloc,9,2),.T.)
				nPosAsBin := u_C690AsBn( aRecursos, Z1_MAQUINA )
				If nPosAsBin == 0
					lOk := u_C690Ocor(6,.T.,Z1_MAQUINA,cOperac,SC2->C2_PRODUTO)
					If !lOk
						Exit
					EndIf
				EndIf
				SH1->(dbSeek(xFilial("SH1")+SZ1->Z1_MAQUINA))
				dbSelectArea("TRB")
				dbAppend()
				Replace  OPNUM With SC2->C2_NUM,;
					ITEM With SC2->C2_ITEM,;
					ITEMGRD With SC2->C2_ITEMGRD,;
					NIVEL With SC2->C2_NIVEL,;
					SEQPAI With SC2->C2_SEQPAI,;
					IDXSEQPAI With IIf( Empty(SC2->C2_SEQPAI), "000", SC2->C2_SEQPAI),;
					SEQUEN With SC2->C2_SEQUEN,;
					PRIOR With SC2->C2_PRIOR,;
					PRODUTO With SC2->C2_PRODUTO,;
					DATPRF With SC2->C2_DATPRF,;
					DATPRI With SC2->C2_DATPRI

				Replace  CODIGO With SG2->G2_CODIGO,;
					OPERAC With "01",;
					RECURSO With SZ1->Z1_MAQUINA,;
					FERRAM With CriaVar("SG2->G2_FERRAM"),;
					LINHAPR With CriaVar("SG2->G2_LINHAPR"),;
					TPLINHA With CriaVar("SG2->G2_TPLINHA"),;
					SETUP With CriaVar("SG2->G2_SETUP"),;
					LOTEPAD With nQuant,;
					TEMPAD With SZ1->Z1_TEMPO,;
					TPOPER With "1",;
					TEMPSOB With CriaVar("SG2->G2_TEMPSOB"),;
					TPSOBRE With CriaVar("SG2->G2_TPSOBRE"),;
					TEMPDES With CriaVar("SG2->G2_TEMPDES"),;
					TPDESD With CriaVar("SG2->G2_TPDESD"),;
					DESPROP With CriaVar("SG2->G2_DESPROP"),;
					CTRAB	With SG2->G2_CTRAB,;
					ROTALT With SG2->G2_ROTALT,;
					TPALOCF With If(SG2->(FieldPos("G2_TPALOCF"))>0,SG2->G2_TPALOCF,"3"),; //Valor Default							
					ILIMITADO With SH1->H1_ILIMITA,;
					TEMPEND	With If(SG2->(FieldPos("G2_TEMPEND"))>0,CriaVar("SG2->G2_TEMPEND"),CriaVar("SG2->G2_SETUP")) 	//Valor Default eh G2_SETUP

				Replace REGRA  With SB1->B1_REGRA,;
					ITEMPAD  With SZ1->Z1_ITEM,;
					QTDALOC  With SC2->C2_QTDALOC,;
					OPAGLUT  With SC2->C2_OPAGLUT,;
					RECAGLUT With CriaVar("SG2->G2_RECURSO")

				Replace QTDPROD  With nQuant

				Replace OPERALOC With .F.

				Replace INIVFIM With StrZero(10000000000000-Val(NIVEL+IDXSEQPAI+SEQUEN+OPERAC),14)
				Replace IDATAFIM With StrZero(CTOD('31/12/49') - DATPRF,10)
			EndIf
		Endif
	EndIf
	dbSelectArea("SC2")

	If !u_C690IsBt()
		// Movimenta a Regua de processamento de registros
		//EVAL(bBlock)
	EndIf
	dbSkip()
End

aAdd(aIndTRB,cEmpAnt+cFilAnt+"01")
aAdd(aIndTRB,cEmpAnt+cFilAnt+"02")

If lOk
	If mv_par01 == 2
		IndRegua("TRB",cArqTrab,"OPNUM+ITEM+NIVEL+SEQPAI+SEQUEN+ITEMGRD+OPERAC+SEQALOC",cDrvCarga,,"Ordenando Registros......")	//"Ordenando Registros......"
		dbGotop()
		While !Eof()
			Replace SEQALOC With StrZero( nSeqAloc++, 7)
			dbSkip()
		End
		dbClearIndex()
		FErase(cArqTrab+OrdBagExt())
		IndRegua("TRB",aIndTRB[1],"PRIOR+DTOS(DATPRF)+OPNUM+ITEM+NIVEL+SEQPAI+SEQUEN+ITEMGRD+SEQALOC+OPERAC",cDrvCarga,,"Ordenando Registros......")	//"Ordenando Registros......"		
	Else
		IndRegua("TRB",cArqTrab,"OPNUM+ITEM+INIVFIM+SEQALOC",,,"Ordenando Registros......")	//"Ordenando Registros......"
		dbGotop()
		While !Eof()
			Replace SEQALOC With StrZero( nSeqAloc++, 7)
			dbSkip()
		End
		dbClearIndex()
		FErase(cArqTrab+OrdBagExt())
		IndRegua("TRB",aIndTRB[1],"PRIOR+IDATAFIM+OPNUM+ITEM+INIVFIM+SEQALOC",,,"Ordenando Registros......")	//"Ordenando Registros......"
	EndIf
	IndRegua("TRB",aIndTRB[2],"SEQALOC",,,"Ordenando Registros......")	//"Ordenando Registros......"
	dbClearIndex()
	dbSetIndex(aIndTRB[1]+OrdBagExt())
	dbSetIndex(aIndTRB[2]+OrdBagExt())
	dbSetOrder(1)
EndIf

If lC690FimTrb
	ExecBlock("C690FTRB",.F.,.F.)
EndIf

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690Altr  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 05/09/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Montagem de Arrays com maquinas alternativas e secundarias ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C690Altr(aAlter,aSecun,aRecursos,aFerram)
Local cAlias := Alias(), nPosAsBin, aTmpAlter, aTmpSecun, i, cTmp
Local nRecDep := 0, cRecDep := ""

// Altera a duracao da operacao considerando a eficiencia do recurso principal
nPosAsBin := u_C690AsBn( aRecursos, TRB->RECURSO )
If nPosAsBin > 0
	aRecursos [ nPosAsBin ][ 2 ] := 1
EndIf

If !lMaqXQuant
	dbSelectArea("SH2")
	dbSetOrder(3)
	dbSeek(xFilial("SH2")+TRB->RECURSO)
	If (nRecDep := aScan(aRecDepend, {|x| x[1] == TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD})	) > 0
		cRecDep := aRecDepend[nRecDep, 3]
	Endif		
	While !Eof() .And. xFilial("SH2")+TRB->RECURSO == H2_FILIAL+H2_RECPRIN .And. MV_PAR30 # 2
		If (mv_par01 == 2 .And. TRB->TPLINHA == "D" .And. u_C690RcLn(H2_RECALTE) # cRecDep) .Or. (mv_par01 == 1 .And. nRecDep # 0 .And. aRecDepend[nRecDep, 4] == "D" .And. u_C690RcLn(H2_RECALTE) # cRecDep)
			dbSkip()
			Loop
		Endif
		If !Empty(TRB->LINHAPR) .And. TRB->TPLINHA == "O"
			nPosAsBin := u_C690AsBn( aRecursos, H2_RECALTE )
			If nPosAsBin > 0
				If aRecursos[ nPosAsBin ][3] # TRB->LINHAPR
					dbSkip()
					Loop
				EndIf
			EndIf
		EndIf
		If Ascan( aAlter , H2_RECALTE ) == 0 .And. Ascan( aSecun , H2_RECALTE ) == 0
			If H2_TIPO == "A" .And. (MV_PAR30 # 3)
				Aadd( aAlter , H2_RECALTE )
			ElseIf H2_TIPO == "S".And. (MV_PAR30 # 4)
				Aadd( aSecun , H2_RECALTE )
			EndIf
		EndIf
		dbSkip()
	End
	If mv_par03 == 1 .And. !Empty(TRB->FERRAM)
		Aadd( aFerram, TRB->FERRAM )
	EndIf
	dbSetOrder(1)
	dbSelectArea("SH3")
	dbSeek(xFilial("SH3")+TRB->PRODUTO+TRB->CODIGO+TRB->OPERAC)
	While !Eof() .And. xFilial("SH3")+TRB->PRODUTO+TRB->CODIGO+TRB->OPERAC == H3_FILIAL+H3_PRODUTO+H3_CODIGO+H3_OPERAC
		If mv_par03 == 1 .And. H3_TIPO == "F" .And. Empty(H3_RECALTE) .And. Empty(H3_RECPRIN) .And. !Empty(H3_FERRAM)
			If Ascan( aFerram, H3_FERRAM ) == 0
				Aadd( aFerram, H3_FERRAM )
			EndIf
		ElseIf H3_TIPO $ "AS" .And. !Empty(H3_RECALTE) .And. !Empty(H3_RECPRIN) .And. Empty(H3_FERRAM) .And. ;
			(MV_PAR30 # 2) .And. ((H3_TIPO=="A" .And. MV_PAR30 # 3).Or.(H3_TIPO=="S" .And. MV_PAR30 # 4))
			nPosAsBin := u_C690AsBn( aRecursos, H3_RECALTE )
			If nPosAsBin > 0
				If aRecursos[ nPosAsBin ][3] # TRB->LINHAPR .And.;
						!Empty(TRB->LINHAPR) .And. TRB->TPLINHA == "O"
					dbSkip()
					Loop
				EndIf
			Else
				If !u_C690Ocor(7,.T.,H3_TIPO,H3_RECALTE,TRB->OPERAC,TRB->PRODUTO)
					Return .F.
				EndIf
				dbSkip()
				Loop
			EndIf
			If Ascan( aAlter , H3_RECALTE ) == 0 .And. Ascan( aSecun , H3_RECALTE ) == 0
				If H3_TIPO == "A"
					Aadd( aAlter , H3_RECALTE )
				ElseIf H3_TIPO == "S"
					Aadd( aSecun , H3_RECALTE )
				EndIf
			EndIf
			aRecursos[ nPosAsBin ][2] := IIf( H3_EFICIEN > 0 , H3_EFICIEN / 100 , 1 )
		EndIf
		dbSkip()
	End

	If !Empty(TRB->LINHAPR) .And. TRB->TPLINHA == "P"
		If Len(aAlter) > 0
			aTmpAlter := {}
			For i := 1 to Len(aAlter)
				If aAlter[i] == TRB->LINHAPR
					cTmp := aAlter[i]
					Aadd( aTmpAlter , cTmp )
					Exit
				Endif
			Next i
			For i := 1 to Len(aAlter)
				If aAlter[i] # TRB->LINHAPR
					cTmp := aAlter[i]
					Aadd( aTmpAlter , cTmp )
				Endif
			Next i
		EndIf
		If Len(aSecun) > 0
			aTmpSecun := {}
			For i := 1 to Len(aSecun)
				If aSecun[i] == TRB->LINHAPR
					cTmp := aSecun[i]
					Aadd( aTmpSecun , cTmp )
					Exit
				Endif
			Next i
			For i := 1 to Len(aSecun)
				If aSecun[i] # TRB->LINHAPR
					cTmp := aSecun[i]
					Aadd( aTmpSecun , cTmp )
				Endif
			Next i
		EndIf

		If Len(aAlter) > 0
			If aTmpAlter # NIL
				aAlter := {}
				aAlter := IIf( Len(aTmpAlter) > 0, AClone(aTmpAlter), {})
			EndIf
		EndIf

		If Len(aSecun) > 0
			If aTmpSecun # NIL
				aSecun := {}
				aSecun := IIf( Len(aTmpSecun) > 0, AClone(aTmpSecun), {})
			EndIf
		EndIf

	EndIf
Else
	If TRB->QTDALOC = 0 .Or. Empty(TRB->RECAGLUT)
		dbSelectArea("SZ3")
		dbSetOrder(1)
		dbSeek(xFilial("SZ3")+TRB->REGRA+TRB->ITEMPAD)
		While !Eof() .And. xFilial("SZ3")+TRB->REGRA+TRB->ITEMPAD == Z3_FILIAL+Z3_REGRA+Z3_ITEMPAD
			nPosAsBin := u_C690AsBn( aRecursos, Z3_MAQUINA )
			If nPosAsBin > 0
				If Ascan( aAlter , Z3_MAQUINA ) == 0
					Aadd( aAlter , Z3_MAQUINA )
				EndIf
			Else
				If !u_C690Ocor(7,.T.,"A",Z3_MAQUINA,TRB->OPERAC,TRB->PRODUTO)
					Return .F.
				EndIf
				dbSkip()
				Loop
			EndIf
			aRecursos[ nPosAsBin ][2] := IIf( Z3_TEMPO > 0 , TRB->TEMPAD / Z3_TEMPO , 1 )
			dbSkip()
		End
	Endif

Endif

dbSelectArea(cAlias)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690PrBt      ³ Autor ³ Robson Bueno Silv ³ Data ³ 07/09/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Busca no Arquivo de Operacoes Alocadas a proxima posicao   ³±±
±±³          ³ para alocacao.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C690PrBt(aRet, aOcorre5,lDica1,nSetupAnt,nDurTotal)
Local nRet, cAlias := Alias(), nRecTRB, lAchou, nSeqAloc, nTempSob, cTpSobre
Local cOp, nNewRet, nNewBitLimit, nNewBit1Peca, cOpAnt

If mv_par01 == 2
	If TRB->TEMPSOB == 0 .And. Empty(TRB->TPSOBRE)
		dbSelectArea("CARGA")
		dbSetOrder(1)
		If ! dbSeek(xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
			dbSetOrder(4)
			dbSeek(xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
			If !Found()
				nRet := 1
			Else
				nRet := H8_BITFIM
				While !Eof() .And. H8_FILIAL+Substr(H8_OP,1,8)+H8_SEQPAI == xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN
					If nRet < H8_BITFIM
						nRet := H8_BITFIM
					Endif
					dbSkip()
				End
			Endif
		Else
			nRet := H8_BITFIM
			While !Eof() .And. H8_FILIAL+H8_OP == xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD
				If nRet < H8_BITFIM
					nRet := H8_BITFIM
				Endif
				dbSkip()
			End
		Endif
	Else
		lAchou := .F.
		nSeqAloc := Val(TRB->SEQALOC)
		nTempSob :=	C690AjSb()
		cTpSobre := "3"
		cTpSobre := iif (TRB->TPSOBRE # " " .And. TRB->TPSOBRE # "1" .And. TRB->OPERAC == "01",TRB->TPSOBRE,"3") 
		cOp := TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD
		dbSelectArea("TRB")
		nRecTRB := Recno()
		dbSetOrder(2)
		dbSeek(StrZero(nSeqAloc-1,7),.T.)
		While !Bof()
			If OPERALOC .And. ( cOp == TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD .Or. cOp == TRB->OPNUM+TRB->ITEM+TRB->SEQPAI+TRB->ITEMGRD )
				lAchou := .T.
				If cOp == TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD
					nRet := C690SobrIni(OPNUM+ITEM+SEQUEN+ITEMGRD+OPERAC,nTempSob,cTpSobre,aRet)
					Exit
				Else
					nRet := 1
					nNewBitLimit := 1
					While !Bof()
						If OPERALOC .And. cOp == TRB->OPNUM+TRB->ITEM+TRB->SEQPAI+TRB->ITEMGRD
							nNewRet := C690SobrIni(OPNUM+ITEM+SEQUEN+ITEMGRD+OPERAC,nTempSob,cTpSobre,aRet)
							If nNewRet > nRet
								nRet := nNewRet
							EndIf
							If nBitLimit > nNewBitLimit
								nNewBitLimit := nBitLimit
								nNewBit1Peca := nBit1Peca
							EndIf
						EndIf
						dbSelectArea("TRB")
						dbSkip(-1)
					End
					If nNewBit1Peca # NIL
						nBit1Peca := nNewBit1Peca
					EndIf
				EndIf
			EndIf
			dbSkip(-1)
		End
		dbSelectArea("TRB")
		dbSetOrder(1)
		dbGoto(nRecTRB)	
			
		If !lAchou
			nRet := 1    
		Else            
			//-- Verifica se existe setup na operacao anterior e soma a sobreposicao
			nRet += nSetupAnt		
		EndIf
	EndIf
Else
	nSeqAloc := Val(TRB->SEQALOC)
	cOpAnt := TRB->OPNUM+TRB->ITEM+TRB->SEQPAI+TRB->ITEMGRD
	cOp := TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD
	dbSelectArea("TRB")
	nRecTRB := Recno()
	dbSetOrder(2)
	dbSeek(StrZero(nSeqAloc-1,7),.T.)
	While !Bof()
		If OPERALOC .And. ( cOp == TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD .Or. cOpAnt == TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD )
			If TEMPSOB # 0 .Or. !Empty(TPSOBRE)
				nRet := C690SobrFim(OPNUM+ITEM+SEQUEN+ITEMGRD,OPERAC,aRet,nRecTRB)
				//-- Verifica se existe setup na operacao anterior e soma a sobreposicao
				nRet += nSetupAnt
			EndIf
			Exit
		EndIf
		dbSkip(-1)
	End
	nRet := IIf( nRet == NIL, -1, nRet )
	dbSelectArea("TRB")
	dbSetOrder(1)
	dbGoto(nRecTRB)
	If nRet == -1
		dbSelectArea("CARGA")
		dbSetOrder(1)
		dbSeek(xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
		If !Found()
			dbSeek(xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQPAI+TRB->ITEMGRD)
			If !Found()
				nRet := U_DtHr2Bit( IIf( TRB->DATPRF > dDataPar + mv_par02 , dDataPar + mv_par02 , TRB->DATPRF ) , 0.00 ) - 1 // Ultimo bit do dia anterior
				If nRet <= 0
					If Ascan( aOcorre5 , TRB->OPNUM+TRB->ITEM+TRB->ITEMGRD ) == 0
						Aadd( aOcorre5 , TRB->OPNUM+TRB->ITEM+TRB->ITEMGRD )
						If TRB->DATPRF <= dDataPar
							If !u_C690Ocor(5,.T.,TRB->OPNUM+TRB->ITEM,TRB->DATPRF)
								Return -99999
							EndIf
						EndIf
					EndIf
				EndIf
			Else
				nRet := H8_BITINI - 1
				While !Eof() .And. H8_FILIAL+H8_OP == xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQPAI+TRB->ITEMGRD
					If nRet > ( H8_BITINI - 1 )
						nRet := H8_BITINI - 1
					Endif
					dbSkip()
				End
				If nRet <= 0
					If !u_C690Ocor(8,.T.,TRB->OPERAC,TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD,@lDica1)
						Return -99999
					EndIf
				EndIf
			Endif
		Else
			nRet := H8_BITINI
			While !Eof() .And. H8_FILIAL+H8_OP == xFilial("SH8")+TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD
				If nRet > ( H8_BITINI - 1 )
					nRet := H8_BITINI - 1
				Endif
				dbSkip()
			End
		Endif
	EndIf
EndIf

dbSelectArea(cAlias)
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690BsAl    ³ Autor ³ Robson Bueno        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao de alocacao de uma operacao.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³ Waldemiro L. Lustosa                     ³ Data ³ 08/09/95 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C690BsAl(cRecurso,nBitIni,nDuracao,cUltFerr,aRet,aOcorre10,aOcorre11,aRecursos,aFerram,nSetup,cTipRec)
Local i, k, nPosAsBin, nBit, aSubDiv, aRegFerr, nOk, nDur, nFim, nBitSet
Local aAloc := {}, nLigados, cString, cCalStr, cCalCop, lFlag := .F., aTotRegFerr := {}
Local lMudaPraIni := .F.
Local nOldBit
Local lMT690TAloc := (ExistBlock("MT690TALOC"))
Local aMT690TAloc := {}
Local aNaoDisp    := {}
Local aRetorno    := {}
Local nPos        := 0
Local nX          := 0

If mv_par19 == 1 .And. ! cRecurso $ cRecSele
	Return(aAloc)
Endif

cString  := Space(aRet[4])
cCalStr  := Space(aRet[4])
cCalCop  := Space(aRet[4])
nBit     := 0

FSeek(aRet[1],PosiMaq(cRecurso,aRet[2])*aRet[4])
If FRead(aRet[1],@cString,aRet[4]) # aRet[4] .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf
FSeek(aRet[5],Posimaq(cRecurso,aRet[2])*aRet[4])
If FRead(aRet[5],@cCalStr,aRet[4]) # aRet[4] .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf
FSeek(aRet[9],Posimaq(cRecurso,aRet[2])*aRet[4])
If FRead(aRet[9],@cCalCop,aRet[4]) # aRet[4] .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf

// Altera a duracao da operacao considerando a eficiencia do recurso
nPosAsBin := u_C690AsBn( aRecursos, cRecurso )
If nPosAsBin > 0
	nDuracao := nDuracao * ( 1 / aRecursos[ nPosAsBin ][ 2 ] )
	// Impede que calcule o numero de bits quebrado (com decimais)
	IF nDuracao - Int(nDuracao) > 0
		nDuracao := Int(nDuracao) + 1
	EndIf
EndIf

nDur := nDuracao

While .T.
	lMudaPraIni:=lMudaPrafim .And. (u_Bit2On(cCalStr,nBitIni,1,aRet[4]) # 1 )
	nOldBit := nBit
	nBit := u_NextBtFr(cString, nBitIni, aRet,lMudaPraIni)
	If nBit # -1
		If lMT690TAloc
			aMT690TAloc := ExecBlock("MT690TALOC",.F.,.F.,{TRB->PRODUTO,cRecurso,nDuracao,nSetup})
			If ValType(aMT690TAloc) == "A" .And. Len(aMT690TALOC) == 3
				If ValType(aMT690TAloc[1]) == "C"
					// Verifica se o recurso e valido
					If Ascan(aRecursos,{ |x| x[1] == aMT690TAloc[1] } ) > 0
						cRecurso := aMT690TAloc[1]
						If ValType(aMT690TAloc[2]) == "N"
							nDuracao := aMT690TAloc[2]
						EndIf
						If ValType(aMT690TAloc[3]) == "N"
							nSetup   := aMT690TAloc[3]
						EndIf
					EndIf	
				EndIf
			EndIf
		EndIf

		If nSetUp > 0          
			// Verifica se, na opera‡„o anterior, h  uma opera‡„o do mesmo tipo, se houver
			// n„o utiliza Setup:
			If !u_C690Stp(cRecurso,nBit-1,aRecursos,cString,cCalStr,aRet)         
				nDuracao -= nSetUp
				//-- Ajusta a duracao para o mesmo nunca ser igual a zero apos subtraido o setup
				If nDuracao == 0
					nDuracao := 1
				EndIf
				nSetup:=0        
			EndIf

			//Atualiza variavel statica com conteudo do setup
			u_C690SupG(nSetup)
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Sub-Divide operacao de acordo com disponibilidade do calendario ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSubDiv := u_C690Sdv(cString,nBit,nDuracao,aRet[4],cCalCop)
		If Len(aSubDiv) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa o array dos registros das ferramentas          ³
			//³                                                           ³
			//³ Estrutura do array aRegFerr:                              ³
			//³ aRegFerr[][1] = numero do registro da ferramenta utilizado³
			//³ aRegFerr[][2] = bit de alocacao escolhido                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par03 == 1
				aRegFerr := Array(Len(aSubDiv),2)  // 1 registro por subdivisao da operacao
			Endif
			nBitSet := nSetUp
			nBitIni := -1
			aTotRegFerr := Array(Len(aSubDiv),Len(aFerram)) 
			For i:= 1 to Len(aSubDiv)
				nOk := u_Bit2On(cString,aSubDiv[i][1],aSubDiv[i][2],aRet[4])
				If nOk # 1
					Exit
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Busca qual o primeiro Bit de alocacao sem setup        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nSetUp > 0 .And. nBitSet > 0
					nBitSet -= aSubDiv[i][2]
				Endif
				If nBitSet <= 0 .And. nBitIni == -1    
					nBitIni := aSubDiv[i][1] + aSubDiv[i][2]
					If nSetUp > 0
						nBitIni += nBitSet
					EndIf
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se faz verificacao de ferramenta                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par03 == 1 .And. !Empty( aFerram )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Obtem a disponibilidade da ferramenta                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aNaoDisp := {}
					For nX:=1 To Len(aFerram)
						aRetorno := C690FerrDisp( aFerram[nX],aSubDiv[i,1],aSubDiv[i,2],cUltFerr,aRet,cCalcOP)
						If aRetorno[1] == 0
							aAdd(aNaoDisp,aFerram[nX])
						EndIf
					Next nX
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Analisa se devera utilizar Ferramenta Alternativa		³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Len(aNaoDisp) > 0 .And. Len(aFerram) > 1
						If Len(aFerram) > Len(aNaoDisp)
							For nX:= 1 to Len(aNaoDisp)
								nPos :=  aScan(aFerram, {|x| x == aNaoDisp[nX]})
								If nPos > 0
									aDel(aFerram, nPos); aSize(aFerram, Len(aFerram)-1)
								EndIf	
							Next nX
						ElseIf Len(aFerram) == Len(aNaoDisp)
							For nX:= 1 to Len(aNaoDisp)
								If nX > 1
									nPos :=  aScan(aFerram, {|x| x == aNaoDisp[nX]}) 
									If nPos > 0
										aDel(aFerram, nPos); aSize(aFerram, Len(aFerram)-1)
									EndIf
								EndIf	
							Next nX	
						EndIf
					EndIf	
					// Cuidado: Note que este For/Next avalia cada item da aSubDiv para cada Ferramenta
					// (n„o verifica todo o aSubDiv para cada Ferramenta, e sim todas as Ferramentas para
					// cada item do aSubDiv).
					For k := 1 to Len( aFerram )
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Obtem a disponibilidade da ferramenta                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aRegFerr[i] := C690FerrDisp( aFerram[k],aSubDiv[i,1],aSubDiv[i,2],cUltFerr,aRet,cCalcOP)
						If aRegFerr[i,1] == 0
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Se nao ha' ferramenta dispon. para o resto do calendario³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Ascan( aOcorre10 , TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD+TRB->OPERAC ) == 0
								Aadd( aOcorre10 , TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD+TRB->OPERAC )
								u_C690Ocor(10,.F., aFerram[k], TRB->OPERAC, TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
							EndIf
							nOk := -1
							aSubDiv := {}
							lFlag := .T.
							aTotRegFerr := {}
							Exit
						Elseif aRegFerr[i,2] # aSubDiv[i,1]
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Se o primeiro bit disponivel for diferente do desejado  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Ascan( aOcorre11 , TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD+TRB->OPERAC+cRecurso+aFerram[k] ) == 0
								Aadd( aOcorre11 , TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD+TRB->OPERAC+cRecurso+aFerram[k] )
								u_C690Ocor(11,.F., TRB->OPERAC, cRecurso, aFerram[k], TRB->OPNUM+TRB->ITEM+TRB->SEQUEN+TRB->ITEMGRD)
							EndIf
							If nBit = nOldBit
								nOk := -1
								aSubDiv := {}
							Else
								nOk := 0  // for‡a navega‡„o
								nBit:= aRegFerr[i,2]	// nova posicao para navegacao
							Endif
							lFlag := .T.
							aTotRegFerr := {}
							Exit
						Endif
						// Armazena que Ferramenta (posi‡„o do Arquivo Bin rio) foi utilizada.
						aTotRegFerr[i][k] := aRegFerr[i,1]
					Next k
				EndIf
				If nOk == -1 .Or. lFlag
					lFlag := .F.
					Exit
				EndIf
			Next i
		Else
			nOk := -1
		Endif
		If nOk == 1
			// Lembre-se que o aSubDiv, quando Carga pelo fim, esta invertido (do fim para o come‡o) !
			nFim   := IIf(mv_par01 == 1,aSubDiv[Len(aSubDiv)][1],aSubDiv[Len(aSubDiv)][1]+aSubDiv[Len(aSubDiv)][2])
			
			If mv_par01 == 2 .And. nFim < nBitLimit //  .And. Empty(TRB->TPSOBRE) --> Isso pode gerar problemas para o cliente BEL CHOCOLATES
				lMudapraFim := .T.
			Else 
				nBitIni:= IIf(nBitIni  == -1,IIf(mv_par01 == 1,aSubDiv[Len(aSubDiv)][1],aSubDiv[1][1]),nBitIni)
				Aadd(aAloc,{cRecurso,nBit,nFim,nDuracao,aSubDiv,aTotRegFerr,nBitIni,nSetUp,{cTipRec,aRecursos[ nPosAsBin ][ 2 ]}})
			EndIf
		Elseif nOk == 0
			nDuracao := nDur
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ajeita nBit pois sera incrementado/decrementado na navegacao³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nBitIni := nBit
			Loop
		Endif
		Exit
	Else
		Exit
	Endif
End
Return aAloc

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690CpFl    ³ Autor ³Rodrigo de A Sartorio³ Data ³ 07/10/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Copia arquivos do diretorio de process. para diret. dados  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690CpFl()
_CopyFile(cDirPcp+cNameCarga+".FER",cDirDados+cNameCarga+".FER")
_CopyFile(cDirPcp+cNameCarga+".OCR",cDirDados+cNameCarga+".OCR")
_CopyFile(cDirPcp+cNameCarga+".FID",cDirDados+cNameCarga+".FID")
_CopyFile(cDirPcp+cNameCarga+".OPE",cDirDados+cNameCarga+".OPE")
_CopyFile(cDirPcp+cNameCarga+"1" + OrdBagExt(),cDirDados+cNameCarga+"1" + OrdBagExt())
_CopyFile(cDirPcp+cNameCarga+"2" + OrdBagExt(),cDirDados+cNameCarga+"2" + OrdBagExt())
_CopyFile(cDirPcp+cNameCarga+"3" + OrdBagExt(),cDirDados+cNameCarga+"3" + OrdBagExt())
_CopyFile(cDirPcp+cNameCarga+"4" + OrdBagExt(),cDirDados+cNameCarga+"4" + OrdBagExt())
_CopyFile(cDirPcp+cNameCarga+".MAQ",cDirDados+cNameCarga+".MAQ")
_CopyFile(cDirPcp+cNameCarga+".CAL",cDirDados+cNameCarga+".CAL")
_CopyFile(cDirPcp+cNameCarga+".COP",cDirDados+cNameCarga+".COP")
_CopyFile(cDirPcp+cNameFerr+".ARQ",cDirDados+cNameFerr+".ARQ")
_CopyFile(cDirPcp+cNameFerr+".IND",cDirDados+cNameFerr+".IND")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690DrPr    ³ Autor ³Rodrigo de A Sartorio³ Data ³ 07/10/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica a existencia do diretorio de processamento do PCP ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690DrPr()
Local cArqPCP:="",nHdlProc:=0,lRet:=.T.
cArqPCP:=cDirPcp+"X"
nHdlProc:=MSFCREATE(cArqPCP,0)
If nHdlProc <= -1
	If !u_C690IsBt()
		MSGAlert("Diretorio de Processamento nao Existe !!!") //"Diretorio de Processamento nao Existe !!!"
	EndIf
	lRet:=.F.
Else
	FClose(nHdlProc)
	FErase(cArqPCP)
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690ImOc    ³ Autor ³Rodrigo de A Sartorio³ Data ³ 08/10/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio que imprime as ocorrencias                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690ImOc(aOcorr)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL titulo   := "Relatorio de Ocorrencias"	//"Relatorio de Ocorrencias"
LOCAL cDesc1   := "Emite a relacao das ocorrencias encontradas durante o processamento"	//"Emite a relacao das ocorrencias encontradas durante o processamento"
LOCAL cDesc2   := "da rotina Carga Maquina."	//"da rotina Carga Maquina."
LOCAL cDesc3   := ""
LOCAL cString  := "SB1"
LOCAL wnrel    := "u_C690Ocor"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn:= {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }   //"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,,.F.)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C690Imp(@lEnd,wnRel,titulo,aOcorr)},titulo)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C690Imp  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 08/10/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C690Imp(lEnd,WnRel,titulo,aOcorr)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "P"
LOCAL nTipo    := 0
LOCAL cRodaTxt := OemToAnsi("Linha(s) de Ocorrencia")   //"Linha(s) de Ocorrencia"
LOCAL nLinhas  := 0
LOCAL i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis para controlar cursor de progressao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(Len(aOcorr))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := OemToAnsi("     OCORRENCIA")	//"     OCORRENCIA"

For i:=1 To Len(aOcorr)
	If li > 58
		cabec(titulo,cabec1,"",wnrel,Tamanho,nTipo)
	EndIf
	If Empty(aOcorr[i])
		@ li,00 PSay __PrtThinLine()
	Else
		@ li,05 PSay aOcorr[i]
	EndIf
	nLinhas++
	li++
Next i

IF li != 80
	Roda(nLinhas,cRodaTxt,Tamanho)
EndIF

Set Device to Screen

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690CaSb  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 12/01/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para trocar calendario substituto                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690CaSb(nIt,aArray)
LOCAL oDlgTroca
LOCAL nOpca:=0
LOCAL cCalend:=CriaVar("H7_CODIGO")
cCalend:=aSeleCal[nIt,3]
DEFINE MSDIALOG oDlgTroca TITLE OemToAnsi("Substitui‡„o") From 145,0 To 230,300 OF oMainWnd PIXEL	//"Substitui‡„o"
@ 10,10 SAY OemToAnsi("Calend rio Substituto") SIZE 60,8 OF oDlgTroca PIXEL	//"Calend rio Substituto"
@ 10,70 MSGET cCalend F3 "SH7" Valid NaoVazio(cCalend) .And. ExistCpo("SH7",cCalend) OF oDlgTroca PIXEL
DEFINE SBUTTON FROM 30,050 TYPE 1 ACTION (nOpca:=1,oDlgTroca:End()) ENABLE OF oDlgTroca
DEFINE SBUTTON FROM 30,077 TYPE 2 ACTION (nOpca:=0,oDlgTroca:End()) ENABLE OF oDlgTroca
ACTIVATE MSDIALOG oDlgTroca CENTERED
If nOpca == 1
	SH7->(dbSetOrder(1))
	If SH7->(dbSeek(xFilial("SH7")+cCalend))
		aArray[nIt,3]:=cCalend
		aArray[nIt,4]:=Substr(SH7->H7_DESCRI,1,23)
	EndIf
EndIf
Return aArray

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690MtBn    ³ Autor ³ Robson Bueno Silv   ³ Data ³ 24/08/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que cria os Arquivos Binarios utilizados na aloca   ³±±
±±³          ³ cao de Recursos da Carga Maquina.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690MtBn(aRet,aRecursos,oCenterPanel)
Local lSeqCarg   := SH8->(FieldPos("H8_SEQCARG")) > 0
Local k, nKey, i, cCargaFile, cCalFile, cCCalFile, nCargaHdl, nCalHdl, nCCalHdl, cIndex := ""
Local nIndexLen := 0, dDia, nBufferSize, aDia := Array(7), cBuffer
Local nPerDia, cIndSH9, cKeySH9, cCondSH9, nPosAsBin, sCalend
Local aExcRec := {}, aExcCCus := {}, aExcGer := {}
Local aBloRec := {}, aBloCCus := {}, aBloGer := {}
Local aBloFer := {}, aRegs := {}, aFerBloq := {}, lFerBloq
Local nFerrHdl, nFerrIndHdl, cFerrInd, nNumFerr, cFerrPos
Local cCalend, nInicio, nFim, cAloc, lFlag, lContinua := .T.
Local cIndSHD, cKeySHD, nIndSHD, cCondSHD, cRecurso, nHora, nRecSHD
Local cIndSHE, cKeySHE, nIndSHE, cCondSHE, cCondExBl
Local aStruSHD, aStruSH8, aStruAppend := {}, nPosAscan
Local nOpca:=0
Local aCalendarios:={}
Local cCalendario:=""
Local oDlg
Local oOk := LoadBitmap( GetResources(), "LBOK")
Local oNo := LoadBitmap( GetResources(), "LBNO")
Local cVarQ :="  "
Local nBitFinal:=MV_PAR02*nPrecisao*24
Local nPosCal
Local oChk, lAll := .T. // Usadas na seleção de recursos
Local l690DtSac := ExistBlock("C690DTSAC")
Local lVldDtSac := .T.
Local nI
Local aOPxProd	 := {}
Local aChkBlocRec := {}      
Local cHoraIni	:= "00:00"
Local cHoraFim	:= "00:00"
Local nTamanho	:= 0          
Local nDurac	:= 0
Local nTempo1	:= 0
Local nTempo2	:= 0       
Local nCount	:= 0
Local nDtNewIni	:= dDataPar
Local nDtNewFim	:= dDataPar
Local cM690AFIL	:=""
Local nLoop1, nLoop2

PRIVATE aSeleRec:={}
PRIVATE aSeleCal:={}

If mv_par07 > mv_par08 .Or. mv_par09 > mv_par10 .Or. mv_par11 > mv_par12 .Or.;
		mv_par13 > mv_par14 .Or. mv_par16 > mv_par17
	Help(" ",1,"PARAMINV")
	Return .F.
EndIf

dbSelectArea("SH1")
dbGotop()
If Bof() .And. Eof()
	u_C690Ocor(1)
	Return .F.
EndIf

cCargaFile := cDirPcp+cNameCarga+".MAQ"
cCalFile   := cDirPcp+cNameCarga+".CAL"
cCCalFile  := cDirPcp+cNameCarga+".COP"

nCargaHdl := MSFCREATE(cCargaFile)
If nCargaHdl = -1
	If !lShowOCR
		Help(" ",1,"C690IN2",,Str(FError(),2,0),05,38)
	EndIf
	Return .F.
Endif
nCalHdl := MSFCREATE(cCalFile)
If nCalHdl = -1
	If !lShowOCR
		Help(" ",1,"C690In",,Str(FError(),2,0),05,38)
	EndIf
	u_C690FArq({{nCargaHdl,cCargaFile}})
	Return .F.
Endif
nCCalHdl := MSFCREATE(cCCalFile)
If nCalHdl = -1
	If !lShowOCR
		Help(" ",1,"C690In",,Str(FError(),2,0),05,38)
	EndIf
	u_C690FArq({{nCargaHdl,cCargaFile},;
		{nCalHdl  ,cCalFile}})
	Return .F.
Endif
dbSelectArea("SH9")
dbGotop()
If !( Bof() .And. Eof() )

	cKeySH9 := IndexKey()


	// Monta 3 Arrays contendo as Excecoes ao Calendario, um para Excecoes
	// especificas para Recursos, um para Excecoes em um Centro de Custo e outro
	// Geral `a Fabrica (para que nao ocorra estouro do limite de registros em um
	// array - 4096 em cada um).
	cIndSH9 := Left(CriaTrab(NIL,.F.),7)+"B"
	#IFNDEF TOP
	cCondSH9 := 'H9_FILIAL == "'+xFilial("SH9")+'" .And. H9_TIPO == "E" .And. H9_DTFIM >= CTOD("'+Dtoc(dDataPar)+'")'
	#ELSE
	cCondSH9 := 'H9_FILIAL = "'+xFilial("SH9")+'" .And. H9_TIPO = "E" .And. DTOS(H9_DTFIM) >= "'+Dtos(dDataPar)+'"'
	#ENDIF
	IndRegua("SH9",cIndSH9,cKeySH9,,cCondSH9,OemToAnsi("Selecionando Exce‡”es...."))	//"Selecionando Exce‡”es...."
	dbGotop()
	While !Eof()
		If H9_DTFIM == dDataPar .And. H9_HRFIM == "00:00"
			dbSkip()
			Loop
		EndIf
		cAloc := H9_ALOC
		NotBit(@cAloc,(24 * nPrecisao)/8)
		If !Empty(H9_RECURSO)
			Aadd(aExcRec,{Dtos(H9_DTINI)+H9_RECURSO, cAloc })
		ElseIf !Empty(H9_CCUSTO)
			Aadd(aExcCCus,{Dtos(H9_DTINI)+H9_CCUSTO, cAloc })
		Else
			Aadd(aExcGer,{Dtos(H9_DTINI), cAloc })
		EndIf
		dbSkip()
	End
	// Ordena os arrays para que o Ascan Binario funcione corretamente
	// (o aExcCCus ja esta ordenado por causa do indice do SH9).
	If !Empty(aExcRec)
		aExcRec := ASort(aExcRec,,, { |x, y| x[1] < y[1] } )
	EndIf
	If !Empty(aExcGer)
		aExcGer := ASort(aExcGer,,, { |x, y| x[1] < y[1] } )
	EndIf
	dbClearFilter()
	Ferase(cIndSH9+OrdBagExt())
	// Monta 3 Arrays contendo os Bloqueios do Calendario, um para especificos
	// para Recursos, um para Bloqueios de um Centro de Custo e outro
	// Geral `a Fabrica (para que nao ocorra estouro do limite de registros em um
	// array - 4096 em cada um).
	cIndSH9 := Left(CriaTrab(NIL,.F.),7)+"C"
	#IFNDEF TOP
	cCondSH9 := 'H9_FILIAL == "'+xFilial("SH9")+'" .And. H9_TIPO == "B" .And. H9_DTFIM >= CTOD("'+Dtoc(dDataPar)+'")'
	#ELSE
	cCondSH9 := 'H9_FILIAL = "'+xFilial("SH9")+'" .And. H9_TIPO = "B" .And. DTOS(H9_DTFIM) >= "'+Dtos(dDataPar)+'"'
	#ENDIF
	IndRegua("SH9",cIndSH9,cKeySH9,,cCondSH9,"Selecionando Bloqueios...")	//"Selecionando Bloqueios..."
	dbGotop()
	While !Eof()
		If H9_DTFIM == dDataPar .And. H9_HRFIM == "00:00"
			dbSkip()
			Loop
		EndIf
		If !Empty(H9_RECURSO)
			Aadd(aBloRec,{ H9_RECURSO,H9_DTINI,Val(Substr(H9_HRINI,1,2)+".";
				+Substr(H9_HRINI,4,2)),H9_DTFIM,Val(Substr(H9_HRFIM,1,2)+".";
				+Substr(H9_HRFIM,4,2))})
		ElseIf !Empty(H9_CCUSTO)
			Aadd(aBloCCus,{ H9_CCUSTO,H9_DTINI,Val(Substr(H9_HRINI,1,2)+".";
				+Substr(H9_HRINI,4,2)),H9_DTFIM,Val(Substr(H9_HRFIM,1,2)+".";
				+Substr(H9_HRFIM,4,2))})
		Else
			Aadd(aBloGer,{ H9_DTINI,Val(Substr(H9_HRINI,1,2)+".";
				+Substr(H9_HRINI,4,2)),H9_DTFIM,Val(Substr(H9_HRFIM,1,2)+".";
				+Substr(H9_HRFIM,4,2))})
		EndIf
		dbSkip()
	End
	dbClearFilter()
	Ferase(cIndSH9+OrdBagExt())
	If mv_par03 == 1
		// Monta Array contendo os Bloqueios de Ferramentas
		cIndSH9 := Left(CriaTrab(NIL,.F.),7)+"D"
		#IFNDEF TOP
		cCondSH9 := 'H9_FILIAL == "'+xFilial("SH9")+'" .And. H9_TIPO == "F" .And. H9_DTFIM >= CTOD("'+Dtoc(dDataPar)+'")'
		#ELSE
		cCondSH9 := 'H9_FILIAL = "'+xFilial("SH9")+'" .And. H9_TIPO = "F" .And. DTOS(H9_DTFIM) >= "'+Dtos(dDataPar)+'"'
		#ENDIF
		IndRegua("SH9",cIndSH9,cKeySH9,,cCondSH9,"Selecionando Bloqueios...")	//"Selecionando Bloqueios..."
		dbGotop()
		While !Eof()
			If H9_DTFIM == dDataPar .And. H9_HRFIM == "00:00"
				dbSkip()
				Loop
			EndIf
			If !Empty(H9_FERRAM) .And. H9_HRINI # "  :  " .And. H9_HRFIM # "  :  "
				Aadd(aBloFer,{ H9_FERRAM,H9_QUANT,H9_DTINI,Val(Substr(H9_HRINI,1,2)+".";
					+Substr(H9_HRINI,4,2)),H9_DTFIM,Val(Substr(H9_HRFIM,1,2)+".";
					+Substr(H9_HRFIM,4,2))})
			EndIf
			dbSkip()
		End
		dbClearFilter()
		Ferase(cIndSH9+OrdBagExt())
		// Insere a Utilizacao de Ferramentas por OPs. Sacramentadas no Array
		// de bloqueios
		dbSelectArea("SHE")
		cKeySHE := IndexKey()
		cIndSHE := Left(CriaTrab(NIL,.F.),7)+"E"
		#IFNDEF TOP
		cCondSHE := 'HE_FILIAL == "'+xFilial("SHE")+'" .And. HE_DTFIM >= CTOD("'+Dtoc(dDataPar)+'")'
		#ELSE
		cCondSHE := 'HE_FILIAL = "'+xFilial("SHE")+'" .And. DTOS(HE_DTFIM) >= "'+Dtos(dDataPar)+'"'
		#ENDIF
		IndRegua("SHE",cIndSHE,cKeySHE,,cCondSHE,"Selecionando Bloqueios...")	//"Selecionando Bloqueios..."
		dbGotop()
		While !Eof()
			If HE_DTFIM == dDataPar .And. HE_HRFIM == "00:00"
				dbSkip()
				Loop
			EndIf
			If HE_HRINI # "  :  " .And. HE_HRFIM # "  :  "
				Aadd(aBloFer,{ HE_FERRAM,1,HE_DTINI,Val(Substr(HE_HRINI,1,2)+".";
					+Substr(HE_HRINI,4,2)),HE_DTFIM,Val(Substr(HE_HRFIM,1,2)+".";
					+Substr(HE_HRFIM,4,2))})
			EndIf
			dbSkip()
		End
		dbClearFilter()
		Ferase(cIndSHE+OrdBagExt())
		RetIndex("SHE")
	EndIf
	RetIndex("SH9")
	dbSetOrder(1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso selecione cal. alternativos, varre SH7 para montar array de selecao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par20 == 1
	dbSelectArea("SH7")
	dbSetOrder(1)
	dbSeek(xFilial("SH7"))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta array com todos calendarios                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. H7_FILIAL == xFilial("SH7")
		AADD(aSeleCal,{H7_CODIGO,H7_DESCRI,H7_CODIGO,H7_DESCRI})
		dbSkip()
	EndDo
	If Len(aSeleCal) > 0
		If !u_C690IsBt()
			aCalendarios:=AClone(aSeleCal)
			DEFINE MSDIALOG oDlg TITLE OemToAnsi("Substitui‡„o de Calend rios") From 145,0 To 360,500 OF oMainWnd PIXEL	//"Substitui‡„o de Calend rios"
			@ 10,10 SAY OemToAnsi("Relacione o calend rio original e seu substituto clicando na linha desejada") SIZE 190,8 OF oDlg PIXEL	//"Relacione o calend rio original e seu substituto clicando na linha desejada"
			@ 20,10 LISTBOX oQual VAR cVarQ Fields HEADER "Cod. Original","Descricao","Cod. Substituto","Descricao" SIZE 230,070 ON DBLCLICK (aSeleCal:=u_C690CaSb(oQual:nAt,aSeleCal),oQual:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual,oOk,oNo,@aSeleCal) NOSCROLL OF oDlg PIXEL	//"Cod. Original"###"Descricao"###"Cod. Substituto"###"Descricao"
			oQual:SetArray(aSeleCal)
			oQual:bLine := { || {aSeleCal[oQual:nAt,1],aSeleCal[oQual:nAt,2],aSeleCal[oQual:nAt,3],aSeleCal[oQual:nAt,4]}}
			DEFINE SBUTTON FROM 095,070 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
			DEFINE SBUTTON FROM 095,097 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg
			ACTIVATE MSDIALOG oDlg CENTERED
			// Caso tenha cancelado
			If nOpca # 1
				aSeleCal:=AClone(aCalendarios)
			EndIf
		EndIf
		// Monta Array bidimensional unico p/ DOS E WINDOWS
		aCalendarios:={}
		For i:=1 to Len(aSeleCal)
			AADD(aCalendarios,{aSelecal[i,1],aSelecal[i,3]})
		Next i
	EndIf
EndIf

dbSelectArea("SH1")
dbSetOrder(1)
dbSeek(xFilial("SH1"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso filtre recursos, MONTA STRING p/ selecao de recursos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par19 == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta array com todos recursos                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. H1_FILIAL == xFilial("SH1")
		AADD(aSeleRec,{H1_CODIGO$cRecSele .or. Empty(cRecSele),H1_CODIGO,H1_DESCRI})
		dbSkip()
	EndDo
	nOpca := 0
	If !u_C690IsBt() .And. Len(aSeleRec) > 0
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Utiliza‡„o de Recursos") From 145,0 To 430,436 OF oMainWnd PIXEL	//"Utiliza‡„o de Recursos"
		@ 10,10 SAY OemToAnsi("Marque os Recursos que deverao ser utilizados") SIZE 140,8 OF oDlg PIXEL	//"Marque os Recursos que deverao ser utilizados"
		@ 20,10 LISTBOX oQual VAR cVarQ Fields HEADER "","Cod. Recurso","Descricao" SIZE 200,100 ON DBLCLICK (aSeleRec:=CA710Troca(oQual:nAt,aSeleRec),oQual:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oQual,oOk,oNo,@aSeleRec) NOSCROLL OF oDlg PIXEL	//"Cod. Recurso"###"Descricao"
		oQual:SetArray(aSeleRec)
		oQual:bLine := { || {If(aSeleRec[oQual:nAt,1],oOk,oNo),aSeleRec[oQual:nAt,2],aSeleRec[oQual:nAt,3]}}
		DEFINE SBUTTON FROM 125,010 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 125,040 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg

		@ 125, 080 CHECKBOX oChk VAR lAll PROMPT OemtoAnsi("") SIZE 66, 10 OF oDlg PIXEL ON CLICK (AEval(aSeleRec, {|z| z[1] := lAll}), oQual:Refresh(.F.))

		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf
	// Caso tenha confirmado
	cRecSele := ""
	If nOpca == 1
		For i:=1 to Len(aSeleRec)
			If aSeleRec[i,1]
				cRecSele+=aSeleRec[i,2]+"/"
			EndIf
		Next i
	Else
		dbSeek(xFilial("SH1"))
		dbEval({|| cRecSele += H1_CODIGO},, {|| xFilial("SH1") == H1_FILIAL})
	EndIf
    If u_C690IsBt()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para filtragem de Recursos "via BAT"        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock( "M690AFIL" )
			cM690AFIL:=ExecBlock("M690AFIL",.F.,.F.,{aSeleRec})
		    If ValType(cM690AFIL) == "C"                       	
				cRecSele:=cM690AFIL
			EndIf
		EndIf
	EndIf	
	If Empty(cRecSele)
		u_C690FArq({{nCargaHdl,cCargaFile},{nCalHdl,cCalFile},{nCCalHdl,cCCalFile}})
		Help(" ",1,"C690NAOCA1")
		Return(.F.)
	Endif
EndIf

// Prepara a Regua de processamento de registros
nRegua:=0
If !u_C690IsBt()
	If (oCenterPanel==Nil)
		oRegua:nTotal:=nTotRegua:=LastRec()
	Else
		oCenterPanel:SetRegua1( LastRec() )
	Endif
EndIf

dbSeek(xFilial("SH1"))
While !Eof() .And. H1_FILIAL == xFilial("SH1")
	If !u_C690IsBt()
		// Movimenta a Regua de processamento de registros
		// EVAL(bBlock) ------verificar erro depois-------
	EndIf
	// So considera recursos selecionados
	If mv_par19 == 1 .And. !(H1_CODIGO $ cRecSele)
		dbSkip()
		Loop
	EndIf

	If Empty(H1_CALEND)
		If !lShowOCR
			Help(" ",1,"C690NAOCAL",,H1_CODIGO,01,11)
		EndIf
		u_C690FArq({{nCargaHdl,cCargaFile},;
			{nCalHdl  ,cCalFile},;
			{nCCalHdl ,cCCalFile}})
		Return .F.
	Endif

	cIndex += H1_CODIGO + "|"
	nIndexLen++
	dbSelectArea("SH7")
	If mv_par20 == 1
		If (nPosCal := ASCAN(aCalendarios,{|x| x[1] == SH1->H1_CALEND})) > 0
			cCalendario:=aCalendarios[nPosCal,2]
		Else
			cCalendario:=SH1->H1_CALEND
			If !u_C690IsBt()
				MsgStop("Impossível trocar o calendário do recurso." + Chr(13) + Chr(10) + ; //"Impossível trocar o calendário do recurso."
				AllTrim(RetTitle("H1_CODIGO")) + ": " + AllTrim(SH1->H1_CODIGO) + " / " + ;
				AllTrim(RetTitle("H1_DESCRI")) + ": " + AllTrim(SH1->H1_DESCRI) + " / " + ;
				AllTrim(RetTitle("H1_CALEND")) + ": " + AllTrim(SH1->H1_CALEND))
			EndIf
		Endif
	Else
		cCalendario:=SH1->H1_CALEND
	EndIf
	dbSetOrder(1)
	dbSeek(xFilial("SH7")+cCalendario)
	If !Found() .And. !Empty(cCalendario)
		u_C690Ocor(2,.F.,cCalendario,SH1->H1_CODIGO)
		u_C690FArq({{nCargaHdl,cCargaFile},;
			{nCalHdl  ,cCalFile},;
			{nCCalHdl ,cCCalFile}})
		Return .F.
	Else
		dDia := dDataPar
		nBufferSize := ( 24 * nPrecisao * mv_par02 ) / 8
		// Monta Arrays com Calendario diario deste Recurso
		nPerDia := ( 24 * nPrecisao ) / 8   // Periodos em um dia (binario)
		cBuffer := ""

		// Monta string binaria a ser gravada consultando os arrays com Excecoes
		// (os Bloqueios serao consultados posteriormente)
		dbSelectArea("SH1")
		For i:= 1 to mv_par02
			If !Empty(aExcRec)
				nPosAsBin := u_C690AsBn( aExcRec , Dtos(dDia)+H1_CODIGO )
			Else
				nPosAsBin := 0
			EndIf
			If nPosAsBin == 0
				If !Empty(aExcCCus)
					nPosAsBin := u_C690AsBn( aExcCCus , Dtos(dDia)+H1_CCUSTO )
				Else
					nPosAsBin := 0
				EndIf
				If nPosAsBin == 0
					If !Empty(aExcGer)
						nPosAsBin := u_C690AsBn( aExcGer , Dtos(dDia) )
					Else
						nPosAsBin := 0
					EndIf
					If nPosAsBin == 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Tratamento para Vigencia de Calendario                                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aDia    := u_ASHICaln(SH1->H1_CODIGO, dDia)
						cBuffer += aDia[ Dow(dDia) ]
					Else
						cBuffer += aExcGer[nPosAsBin][2]
					EndIf
				Else
					cBuffer += aExcCCus[nPosAsBin][2]
				EndIf
			Else
				cBuffer += aExcRec[nPosAsBin][2]
			EndIf
			dDia++
		Next i
		Aadd( aRecursos , { SH1->H1_CODIGO , 1 , SH1->H1_LINHAPR , {} } )
		If FWrite(nCargaHdl,cBuffer,nBufferSize) < nBufferSize .And. !lShowOCR
			Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
		EndIf
		If FWrite(nCalHdl,cBuffer,nBufferSize) < nBufferSize .And. !lShowOCR
			Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
		EndIf
		If FWrite(nCCalHdl,cBuffer,nBufferSize) < nBufferSize .And. !lShowOCR
			Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
		EndIf
	EndIf
	dbSkip()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se Utilizar Ferramenta, Cria e Monta os Arquivos Binarios  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbGotop()
If mv_par03 == 1 .And. !( Bof() .And. Eof() )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Arquivo Binario das Ferramentas Disponiveis      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFerrHdl := MSFCREATE(cDirPcp+cNameFerr+".ARQ")
	If nFerrHdl = -1
		If !lShowOCR
			Help(" ",1,"C690In",,Str(FError(),2,0),05,38)
		EndIf
		u_C690FArq({{nCargaHdl,cCargaFile},;
			{nCalHdl  ,cCalFile},;
			{nCCalHdl ,cCCalFile}})
		Return .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Arquivo Binario do Indice das Ferramentas        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nFerrIndHdl := MSFCREATE(cDirPcp+cNameFerr+".IND")
	If nFerrIndHdl = -1
		If !lShowOCR
			Help(" ",1,"C690In",,Str(FError(),2,0),05,38)
		EndIf
		u_C690FArq({{nCargaHdl,cCargaFile},;
			{nCalHdl  ,cCalFile},;
			{nCCalHdl ,cCCalFile},;
			{nFerrHdl ,cDirPcp+cNameFerr+".ARQ"}})
		Return .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o arquivo das ferramentas disponiveis.            ³
	//³ Cada registro ‚ do tamanho do periodo (nBufferSize) e   ³
	//³ existem tantos registros quanto for a quantidade dispo- ³
	//³ nivel para a ferramenta.                                ³
	//³ Os bits sao inicializados com 0 (disponivel)            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SH4")
	dbSeek(xFilial("SH4"))
	cFerrInd := ""
	cFerrPos := ""
	k := 1
	nNumFerr := 0
	While !Eof() .And. H4_FILIAL == xFilial("SH4")
		cFerrInd += H4_CODIGO+"|"
		cFerrPos += I2Bin(k)
		k--
		For i:= 1 to IIf(H4_QUANT>0,H4_QUANT,1)
			If FWrite(nFerrHdl,Replicate(Chr(0),nBufferSize),nBufferSize) < nBufferSize .And. !lShowOCR
				Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
			EndIf
			k++
		Next
		cFerrPos += I2Bin(k)
		nNumFerr++
		dbSkip()
		k++
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ O arquivo de indice e composto pela estrutura:                 ³
	//³        CODIG1|CODIG2|...CODIGn|P1F1P2F2P3F3...PnFn             ³
	//³ CODIG1-CODIGn - codigos das ferramentas (7 bytes cada)         ³
	//³ I1-In - posicao do primeiro registro da ferramenta (2 bytes)   ³
	//³ F1-Fn - posicao do ultimo registro da ferramenta (2 bytes)     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FWrite(nFerrIndHdl,cFerrInd+cFerrPos,nNumFerr * 11) < (nNumFerr*11) .And. !lShowOCR
		Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
	EndIf
Endif

FSeek(nCargaHdl,0,2)
If FWrite(nCargaHdl,cIndex,Len(cIndex)) < Len(cIndex) .And. !lShowOCR
	Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
EndIf
FWrite(nCargaHdl,I2Bin(nIndexLen))
FWrite(nCargaHdl,I2Bin(nPrecisao))
FWrite(nCargaHdl,I2Bin(mv_par02))
FWrite(nCargaHdl,DtoS(dDataPar))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ C690MtBn monta um Array com dados do arquivo           ³
//³ aRet[1] := Handler do arquivo carga.maq                   ³
//³ aRet[2] := String com o indice do arquivo                 ³
//³ aRet[3] := Numero de Registros                            ³
//³ aRet[4] := Tamanho do Registro                            ³
//³ aRet[5] := Handler do arquivo carga.cal                   ³
//³ aRet[6] := Handler do arquivo ferr.arq                    ³
//³ aRet[7] := Handler do arquivo ferr.ind                    ³
//³ aRet[8] := Numero de ferramentas cadastradas no indice    ³
//³ aRet[9] := Handler do arquivo carga.cop                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
aRet[1] := nCargaHdl
aRet[2] := cIndex
aRet[3] := nIndexLen
aRet[4] := IIf( nBufferSize # NIL, nBufferSize, 0 )
aRet[5] := nCalHdl
aRet[6] := nFerrHdl
aRet[7] := nFerrIndHdl
aRet[8] := nNumFerr
aRet[9] := nCCalHdl

// Grava os bloqueios e gera uma operacao alocada para cada bloqueio
If !Empty(aBloGer)

	For k := 1 to Len(aRecursos)
		For i := 1 to Len(aBloGer)
			cCalend := Space(nBufferSize)
			FSeek(nCalHdl,PosiMaq(aRecursos[k][1],cIndex)*nBufferSize)
			If FRead(nCalHdl,@cCalend,nBufferSize) # nBufferSize .And. !lShowOCR
				Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
			EndIf
			nInicio:= U_DtHr2Bit(aBloGer[i][1],aBloGer[i][2])
			If nInicio < 1
				nInicio := 1
			Endif
			nFim := U_DtHr2Bit(aBloGer[i][3],aBloGer[i][4])-nInicio
			StuffBit(@cCalend,nInicio,Min(nBitFinal,nFim),nBufferSize)
			FSeek(nCargaHdl,PosiMaq(aRecursos[k][1],cIndex)*nBufferSize)
			If FWrite(nCargaHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
				Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
			EndIf
			FSeek(nCalHdl,PosiMaq(aRecursos[k][1],cIndex)*nBufferSize)
			If FWrite(nCalHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
				Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
			EndIf
			FSeek(nCCalHdl,PosiMaq(aRecursos[k][1],cIndex)*nBufferSize)
			If FWrite(nCCalHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
				Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
			EndIf
			dbSkip()
		Next i
	Next k
Endif

If !Empty(aBloCCus)
	dbSelectArea("SH1")
	dbSetOrder(2)
	For i := 1 to Len(aBloCCus)
		dbSeek(xFilial("SH1")+aBloCCus[i][1])
		While !Eof() .And. xFilial("SH1")+aBloCCus[i][1] == H1_FILIAL+H1_CCUSTO
			cCalend := Space(nBufferSize)
			FSeek(nCalHdl,PosiMaq(H1_CODIGO,cIndex)*nBufferSize)
			If FRead(nCalHdl,@cCalend,nBufferSize) # nBufferSize .And. !lShowOCR
				Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
			EndIf
			nInicio:= U_DtHr2Bit(aBloCCus[i][2],aBloCCus[i][3])
			If nInicio < 1
				nInicio := 1
			Endif
			nFim := U_DtHr2Bit(aBloCCus[i][4],aBloCCus[i][5])-nInicio
			StuffBit(@cCalend,nInicio,Min(nBitFinal,nFim),nBufferSize)
			FSeek(nCargaHdl,PosiMaq(H1_CODIGO,cIndex)*nBufferSize)
			If FWrite(nCargaHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
				Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
			EndIf
			FSeek(nCalHdl,PosiMaq(H1_CODIGO,cIndex)*nBufferSize)
			If FWrite(nCalHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
				Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
			EndIf
			FSeek(nCCalHdl,PosiMaq(H1_CODIGO,cIndex)*nBufferSize)
			If FWrite(nCCalHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
				Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
			EndIf
			dbSkip()
		End
	Next i
	dbSetOrder(1)
Endif

If !Empty(aBloRec)  

    //-- Carrega Produtos usados nas ordens de Producao filtrados pela parametrizacao
	aOPxProd := GtPrdOp()                           
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisa se existe recurso bloqueado que  possua tipo de linha  ³
	//³obrigatoria, e analisa se possui recursos com sobreposicao     ³
	//³dependentes. Se achar inclui bloqueio para os mesmo respeitando³
	//³o Bloquei do recurso obritatorio.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Definicao dos recursos que devem ser bloqueados a partir da linha obrigatoria.
	DbSelectArea("SG2")
	DbSetOrder(4)
	For i := 1 to Len(aBloRec)
		If ! (aBloRec[i, 1] $ cIndex)
			Loop
		Endif

		DbSeek(xFilial("SG2")+aBloRec[i,1])
		While SG2->(!Eof() .And. G2_FILIAL+G2_RECURSO==xFilial("SG2")+aBloRec[i,1])				
			If SG2->G2_TPLINHA == 'O' .And. AsCan(aOpxProd,{|x| x[2]+x[3]==SG2->(If(Empty(G2_REFGRD),G2_PRODUTO,G2_REFGRD)+G2_CODIGO)}) > 0  //LINHA OBRIGATORIO E FAZ PARTE DO FILTRO
				Aadd(aChkBlocRec,{aClone(aBloRec[i]),SG2->( RecNo() ),SG2->(If(Empty(G2_REFGRD),G2_PRODUTO,G2_REFGRD)),SG2->G2_CODIGO,SG2->G2_OPERAC})
			EndIf
		 	SG2->( DbSkip() )
		EndDo			
	Next i
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisa recursos dependentes que estao em operacoes abaixo    ³
	//³de recurso obrigatorio. Se existir realiza o bloqueio conforme³
	//³recurso obrigatorio.                                          ³
	//³Atencao: So bloqueia recursos dependentes em sobreposicao.    ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SG2->(DbSetOrder(1))
	For i := 1 To Len(aChkBlocRec)        

		SG2->( DbGoto(aChkBlocRec[i,2]) )
		SG2->( DbSkip() )     
		
		//-- Verifica se esta trabalhando com familia de produtos referencia de grada para o cadastro de operacoes
		//-- se estiver troca a chave de pesquisa.
		cSeekWhile	:= 	a630CondSG2(!Empty(SG2->G2_REFGRD),xFilial("SG2")+MaGetGrdRef(aChkBlocRec[i,3])+aChkBlocRec[i,4],"G2_FILIAL+G2_PRODUTO+G2_CODIGO")
		
		While SG2->(!Eof() .And. Eval(&cSeekWhile))
					
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se a proxima operacao analisada nao possuir sobreposicao³
			//³abandona analise do recurso obritatorio posicionado     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(SG2->G2_TPSOBRE)
				Exit
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se a proxima operacao analisada nao for dependente salta³
			//³para proxima.                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If SG2->G2_TPLINHA # 'D'  //LINHA DEPENDENTE
				SG2->( DbSkip() )
				Loop
			EndIf
			
			//Analisa o tipo de sobreposicao
			DO CASE
            	CASE SG2->G2_TPSOBRE == "1" // Por quantidade
            		nTempSobr :=  SG2->(G2_TEMPAD/G2_LOTEPAD)            	
            	CASE SG2->G2_TPSOBRE == "2" // Por Percentual
	                nTempSobr :=  ( SG2->(G2_TEMPAD/G2_LOTEPAD)* SG2->G2_TEMPSOB)/100
	            CASE SG2->G2_TPSOBRE == "3" // Por tempo 
	            	nTempSobr := SG2->G2_TEMPSOB	            
            ENDCASE                             
             
			//Identifica calendario
			DbSelectArea("SH1")
			DbSetOrder(1)
			DbSeek(xFilial("SH1")+SG2->G2_RECURSO)                
			cHoraIni := StrZero(Int(aChkBlocRec[i,1,3]),2) + ":" + StrZero(Mod(aChkBlocRec[i,1,3], 1) * 100, 2)
			cHoraFim := StrZero(Int(aChkBlocRec[i,1,5]),2) + ":" + StrZero(Mod(aChkBlocRec[i,1,5], 1) * 100, 2)
                
			dbSelectArea("SH7")
			If MsSeek(xFilial("SH7")+SH1->H1_CALEND)
				cAloc    := Bin2Str(SH7->H7_ALOC)
				nTamanho := Len(cAloc) / 7
			Else
				Aviso("Inconsistencia na base de dados", "O Calendario Cod. "+SH1->H1_CALEND+" nao existe no cadastro de calendarios.. Verifique a base de dados.",{"Ok"},2) // ###Inconsistencia na base de dados ### "O Calendario Cod. " ### " nao existe no cadastro de calendarios.. Verifique a base de dados."
				cAloc	:= ""
				nTamanho:= 0
			EndIf           
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o tempo que o recurso ficou bloqueado+calendario³
			//³Exemplo: horario de almoco.                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  		nDurac := A680Tempo(aChkBlocRec[i,1,2],cHoraIni, aChkBlocRec[i,1,4], cHoraFim)		  		

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ajuste de tempo de sobreposicao                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	  		
	  		If nTempSobr > nDurac
	  			nTempSobr := nDurac
	  		EndIf
	  		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o tempo restante do turno de trabalho para o recurso³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTempo2 := PmsHrUtil(aChkBlocRec[i,1,2],"00"+cHoraIni,"0024:00",SH1->H1_CALEND,,,SG2->G2_RECURSO,.t.)
					
			nDtNewIni := aChkBlocRec[i,1,2]
			nDtNewFim := aChkBlocRec[i,1,4]
            
               
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se o tempo do bloqueio for maior que o tempo util restante do³
			//³dia, analisa turnos dos proximos dias para definir bloqueio. ³
			//³Caso contrario bloqueia no mesmo turno.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (nDurac-nTempSobr) >= nTempo2
				nTempo1 := nTempo2                    
				nCount	:= 0
				While nCount < 1000                               
					nDtNewIni 	+= 1
					nDtNewFim 	+= 1						
					nDayWeek	:= DOW(nDtNewIni)
					nDayWeek 	:= If(nDayWeek==1,7,nDayWeek-1)

					cAloc := Substr(cAloc,(nTamanho*(nDayWeek-1))+1,nTamanho)
					If !Empty(StrTran(cAloc," ",""))
						Exit						
					EndIf         
					nCount++
				EndDo                                                     
				
				If nCount >= 1000
					Aviso("Atencao","Erro de analise de calendario",{"Ok"})    // ### Atenção ### "Erro de analise de calendario" ###
				EndIf
				
				nTempo2 := ((At("X",UPPER(cAloc))-1)*(60/nPrecisao))/60
				nTempo1	+= nTempo2            
				nTempo1 := Val(StrTran(A680ConvHora(Str(nTempo1), "C", "N"),":","."))             
				nTempo2 := Val(StrTran(A680ConvHora(Str(nTempo2), "C", "N"),":","."))             
			Else               
				                      
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se existem intervalos de calendario durante o bloqueio³
				//³para ser desconsiderado no bloqueio dos recursos dependentes.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nInicio := U_DtHr2Bit(aChkBlocRec[i,1,2],aChkBlocRec[i,1,3])
				nFim	:= U_DtHr2Bit(aChkBlocRec[i,1,4],aChkBlocRec[i,1,5])
				nFim 	:= If(nFim > Len(cAloc),Len(cAloc),nFim)
				nCount 	:= 0
				If (nInicio := At(SubStr(cAloc,nInicio,nFim-nInicio)," ") ) > 0     
					For nI:=nInicio To nFim
						If Empty(SubStr(cAloc,nI,1)	)
							nCount++
						EndIf 
					Next nI                                          					

					If nCount > 0
						nCount++
						nCount := Val(StrTran(u_Bit2DtHr(nCount,aChkBlocRec[i,1,4])[2],":","."))
					EndIf
				EndIf	
				nTempo1 := Val(StrTran(A680ConvHora(Str(nDurac), "C", "N"),":",".")) - nCount
				nTempo2 := aChkBlocRec[i,1,3]+ nTempSobr
				nTempo1 := nTempo2+nTempo1				
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se este bloquei ja foi realizado por ³
			//³outra alocacao.                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   					 
			If (nPosRec := Ascan(aBloRec,{ |x| x[1] == SG2->G2_RECURSO})) > 0 .And. ;
				aBloRec[nPosRec,2] == nDtNewIni .And. aBloRec[nPosRec,3] == Round(nTempo2,2) .And. ;
				aBloRec[nPosRec,4] == nDtNewFim .And. aBloRec[nPosRec,5] == Round(nTempo1,2)
				
				SG2->( DbSkip() )
				Loop				
				
			EndIf                                                  
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inclui novo bloqueio para recursos dependentes³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   
			Aadd(aBloRec,{SG2->G2_RECURSO,nDtNewIni,Round(nTempo2,2),nDtNewFim,Round(nTempo1,2)})
			SG2->( DbSkip() )
		EndDo
	Next i

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Firma o bloqueio dos recursos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i := 1 to Len(aBloRec)
		If ! (aBloRec[i, 1] $ cIndex)
			Loop
		Endif
		cCalend := Space(nBufferSize)
		FSeek(nCalHdl,PosiMaq(aBloRec[i][1],cIndex)*nBufferSize)
		If FRead(nCalHdl,@cCalend,nBufferSize) # nBufferSize .And. !lShowOCR
			Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		EndIf
		nInicio:= U_DtHr2Bit(aBloRec[i][2],aBloRec[i][3])
		If nInicio < 1
			nInicio := 1
		Endif
		nFim := U_DtHr2Bit(aBloRec[i][4],aBloRec[i][5])-nInicio
		StuffBit(@cCalend,nInicio,Min(nBitFinal,nFim),nBufferSize)
		FSeek(nCargaHdl,PosiMaq(aBloRec[i][1],cIndex)*nBufferSize)
		If FWrite(nCargaHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
			Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
		EndIf
		FSeek(nCalHdl,PosiMaq(aBloRec[i][1],cIndex)*nBufferSize)
		If FWrite(nCalHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
			Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
		EndIf
		FSeek(nCCalHdl,PosiMaq(aBloRec[i][1],cIndex)*nBufferSize)
		If FWrite(nCCalHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
			Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
		EndIf
		dbSkip()
	Next i
Endif

If !Empty(aBloFer) .And. mv_par03 == 1
	For i := 1 to Len(aBloFer)
		aRegs := C690FerrRegs(aBloFer[i][1],aRet)
		aFerBloq := {}
		lFerBloq := .F.
		// Le cada Pe‡a da Ferramenta e Grava bloqueio somente nas disponiveis
		For k:= aRegs[1] To aRegs[2]		// para cada registro da ferramenta
			cBuffer := Space(aRet[4])
			// Le o registro atual da ferramenta
			FSeek(aRet[6],(k - 1) * aRet[4],0)
			If FRead(aRet[6],@cBuffer,aRet[4]) # aRet[4] .And. !lShowOCR
				Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
			EndIf
			nInicio:= U_DtHr2Bit(aBloFer[i][3],aBloFer[i][4])
			If nInicio < 1
				nInicio := 1
			Endif
			nFim := U_DtHr2Bit(aBloFer[i][5],aBloFer[i][6])-nInicio
			// Avalia se a ferramenta esta disponivel no periodo do bloqueio
			If u_Bit2On(cBuffer,nInicio,nFim,aRet[4]) == 1
				StuffBit(@cBuffer,nInicio,Min(nBitFinal,nFim),aRet[4])
				FSeek(aRet[6],(k - 1) * aRet[4],0)
				If FWrite(aRet[6],cBuffer,aRet[4]) < aRet[4] .And. !lShowOCR
					Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
				EndIf
				Aadd(aFerBloq,k)
				If Len(aFerBloq) == aBloFer[i][2]
					lFerBloq := .T.
					Exit
				EndIf
			EndIf
		Next k
		If !lFerBloq
			// Le cada Pe‡a da Ferramenta e Grava bloqueio somente nas disponiveis
			For k:= aRegs[1] To aRegs[2]		// para cada registro da ferramenta
				If Ascan(aFerBloq,k) == 0
					cBuffer := Space(aRet[4])
					// Le o registro atual da ferramenta
					FSeek(aRet[6],(k - 1) * aRet[4],0)
					If FRead(aRet[6],@cBuffer,aRet[4]) # aRet[4] .And. !lShowOCR
						Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
					EndIf
					nInicio:= U_DtHr2Bit(aBloFer[i][3],aBloFer[i][4])
					If nInicio < 1
						nInicio := 1
					Endif
					nFim := U_DtHr2Bit(aBloFer[i][5],aBloFer[i][6])-nInicio
					// Avalia se a ferramenta esta disponivel no periodo do bloqueio
					If u_Bit2On(cBuffer,nInicio,nFim,aRet[4]) == 1
						StuffBit(@cBuffer,nInicio,Min(nBitFinal,nFim),aRet[4])
						FSeek(aRet[6],(k - 1) * aRet[4],0)
						If FWrite(aRet[6],cBuffer,aRet[4]) < aRet[4] .And. !lShowOCR
							Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
						EndIf
						Aadd(aFerBloq,k)
						If Len(aFerBloq) == aBloFer[i][2]
							lFerBloq := .T.
							Exit
						EndIf
					EndIf
				EndIf
			Next k
			If !lFerBloq
				u_C690Ocor(13,.F.,aBloFer[i],Len(aFerBloq))
			EndIf
		EndIf
	Next i
EndIf

dbSelectArea("SHD")
dbSeek(xFilial("SHD"))
// Prepara a Regua de processamento de registros
nRegua:=0
If !u_C690IsBt()
	If (oCenterPanel==Nil)
		oRegua:nTotal:=nTotRegua:=LastRec()
	Else
		oCenterPanel:SetRegua1( LastRec() )
	EndIf
EndIf

If (!( Bof() .And. Eof() )) .Or. Len(aNaoMuda) > 0
	// Se considera OPs Sacramentadas.
	If mv_par05 == 1
		aStruSHD := dbStruct()
		dbSelectArea("SH8")
		aStruSH8 := dbStruct()
		For i := 1 to Len( aStruSH8 )
			nPosAscan := Ascan( aStruSHD, { |x| x[1] == Stuff(aStruSH8[i][1], 2, 1, "D") } )
			If nPosAscan # 0 .And. aStruSH8[i][1] # "H8_FILIAL"
				Aadd( aStruAppend, aStruSH8[i][1] )
			EndIf
		Next i
		dbSelectArea("SHD")
		While !Eof() .And. SHD->HD_FILIAL == xFilial("SHD")
			If !u_C690IsBt()
				// Movimenta a Regua de processamento de registros
				//EVAL(bBlock)
			EndIf
			lVldDtSac := .T.
			If l690DtSac
				lVldDtSac := ExecBlock("C690DTSAC",.F.,.F.,dDataPar)
				If ValType(lVldDtSac)#'L'
					lVldDtSac := .T.
				EndIf
			EndIf
			If lVldDtSac .And. SHD->HD_DTFIM < dDataPar
				dbSkip()
				Loop
			EndIf
			If ! u_c690PrTo(SHD->HD_OP, SHD->HD_OPER)
				dbSkip()
				Loop
			Endif
			dbSelectArea("SH8")
			RecLock("SH8",.T.)
			For i := 1 to Len( aStruAppend )
				Replace &(aStruAppend[i]) With &("SHD->"+Stuff(aStruAppend[i], 2, 1, "D"))
			Next i
			// Grava a sequencia
			// Grava a filial corretamente
			Replace SH8->H8_FILIAL With xFilial("SH8")
			If lSeqCarg
				Replace SH8->H8_SEQCARG With cSeqCarga
			EndIf
			Replace SH8->H8_STATUS With "S"
			MsUnLock()
			dbSelectArea("SHD")
			dbSkip()
		End
		dbSelectArea("SHD")
		dbSetOrder(2)
		cKeySHD := IndexKey()
		#IFNDEF TOP
		cCondSHD := "HD_FILIAL=='"+xFilial('SHD')+"'.And.Empty(HD_DATRF).And."
		#ELSE
		cCondSHD := "HD_FILIAL='"+xFilial('SHD')+"'.And.DTOS(HD_DATRF)='"+DTOS(CriaVar('HD_DATRF'))+"'.And."
		#ENDIF
		cCondSHD += "DTOS(HD_DTFIM)>='"+DTOS(mv_par15)+"'.And.DTOS(HD_DTINI)<='"+DTOS(mv_par15+mv_par02)+"'"
		// Executa ponto para montar filtro da INDREGUA
		If ExistBlock("C690FSHD")
			cCondExBl:=ExecBlock("C690FSHD",.F.,.F.,cCondSHD)
			If ValType(cCondExbl) == "C"
				cCondSHD:=cCondExBl
			EndIf
		EndIf
		cIndSHD := Left(CriaTrab(NIL,.F.),7)+"G"
		IndRegua("SHD",cIndSHD,cKeySHD,,cCondSHD,"OPs Sacramentadas........")	//"OPs Sacramentadas........"
		dbGotop()
		dbSelectArea("SHD")
		While !Eof() .And. lContinua
			lVldDtSac := .T.
			If l690DtSac
				lVldDtSac := ExecBlock("C690DTSAC",.F.,.F.,dDataPar)
				If ValType(lVldDtSac)#'L'
					lVldDtSac := .T.
				EndIf
			EndIf
			If lVldDtSac .And. HD_DTFIM < dDataPar
				dbSkip()
				Loop
			EndIf
			If ! u_c690PrTo(SHD->HD_OP, SHD->HD_OPER)
				dbSkip()
				Loop
			Endif
			nPosAsBin := u_C690AsBn( aRecursos, HD_RECURSO )
			If nPosAsBin == 0
				cRecurso := HD_RECURSO
				While !Eof() .And. HD_RECURSO == cRecurso
					dbSkip()
				End
			Else
				cRecurso := HD_RECURSO
				While !Eof() .And. HD_RECURSO == cRecurso .And. lContinua
					cCalend := Space(nBufferSize)
					If !u_C690Ilim(SHD->HD_RECURSO)
						FSeek(nCargaHdl,PosiMaq(HD_RECURSO,cIndex)*nBufferSize)
						If FRead(nCargaHdl,@cCalend,nBufferSize) # nBufferSize .And. !lShowOCR
							Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
						EndIf
					EndIf
					nHora := Val(Substr(HD_HRINI,1,2)+"."+Substr(HD_HRINI,4,2))
					nInicio:= U_DtHr2Bit(HD_DTINI,nHora)
					If nInicio < 1
						nInicio := 1
					Endif
					nHora := Val(Substr(HD_HRFIM,1,2)+"."+Substr(HD_HRFIM,4,2))
					nFim := U_DtHr2Bit(HD_DTFIM,nHora)-nInicio
					If !u_C690Ilim(SHD->HD_RECURSO)
						StuffBit(@cCalend,nInicio,Min(nBitFinal,nFim),nBufferSize)
						FSeek(nCargaHdl,PosiMaq(HD_RECURSO,cIndex)*nBufferSize)
						If FWrite(nCargaHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
							Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
						EndIf
					EndIf
					dbSelectArea("CARGA")
					dbAppend()
					Replace  H8_FILIAL With xFilial("SH8"),;
						H8_OP With SHD->HD_OP,;
						H8_OPER With SHD->HD_OPER,;
						H8_RECURSO With SHD->HD_RECURSO,;
						H8_FERRAM With SHD->HD_FERRAM,;
						H8_DTINI With SHD->HD_DTINI,;
						H8_HRINI With SHD->HD_HRINI,;
						H8_DTFIM With SHD->HD_DTFIM,;
						H8_HRFIM With SHD->HD_HRFIM,;
						H8_BITINI With nInicio,;
						H8_BITFIM With nInicio+nFim,;
						H8_SEQPAI With SHD->HD_SEQPAI,;
						H8_QUANT With SHD->HD_QUANT,;
						H8_DESDOBR With SHD->HD_DESDOBR,;
						H8_BITUSO With SHD->HD_BITUSO,;
						H8_STATUS With "S"
					dbSelectArea("SHD")
					dbSkip()
				End
			EndIf
		End

		If lContinua
			dbSelectArea("SHD")
			nRecSHD := Recno()
			dbSeek(Dtos(dDataPar),.T.)
			If Recno() # nRecSHD
				lFlag := .T.
			EndIf
		Else
			u_C690FArq({{nCargaHdl,cCargaFile},;
				{nCalHdl  ,cCalFile},;
				{nCCalHdl ,cCCalFile},;
				{nFerrHdl ,cDirPcp+cNameFerr+".ARQ"},;
				{nFerrIndHdl ,cDirPcp+cNameFerr+".IND"}})
		EndIf
		RetIndex("SHD")
		dbClearFilter()
		FErase(cIndSHD+OrdBagExt())
		dbSetOrder(1)
	EndIf
	For nLoop1 := 1 to Len(aNaoMuda)
		For nLoop2   := 1 to Len(aNaoMuda[nLoop1])
			dH8DtFim   := aNaoMuda[nLoop1, nLoop2, SH8->(FieldPos("H8_DTFIM"))]
			cH8Op      := aNaoMuda[nLoop1, nLoop2, SH8->(FieldPos("H8_OP"))]
			cH8Oper    := aNaoMuda[nLoop1, nLoop2, SH8->(FieldPos("H8_OPER"))]
			cH8Recurso := aNaoMuda[nLoop1, nLoop2, SH8->(FieldPos("H8_RECURSO"))]

			cH8HrIni   := aNaoMuda[nLoop1, nLoop2, SH8->(FieldPos("H8_HRINI"))]
			dH8DtIni   := aNaoMuda[nLoop1, nLoop2, SH8->(FieldPos("H8_DTINI"))]
			cH8HrFim   := aNaoMuda[nLoop1, nLoop2, SH8->(FieldPos("H8_HRFIM"))]
			dH8DtFim   := aNaoMuda[nLoop1, nLoop2, SH8->(FieldPos("H8_DTFIM"))]

			If dH8DtFim < dDataPar
				dbSkip()
				Loop
			EndIf
			If ! u_c690PrTo(cH8Op, cH8Oper)
				Loop
			Endif
			nPosAsBin := u_C690AsBn( aRecursos, cH8Recurso )
			If nPosAsBin == 0
				Loop
			Else
				cRecurso := cH8Recurso
				cCalend := Space(nBufferSize)
				If !u_C690Ilim(cH8Recurso)
					FSeek(nCargaHdl,PosiMaq(cH8Recurso,cIndex)*nBufferSize)
					If FRead(nCargaHdl,@cCalend,nBufferSize) # nBufferSize .And. !lShowOCR
						Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
					EndIf
				EndIf
				nHora := Val(Substr(cH8HrIni,1,2)+"."+Substr(cH8HrIni,4,2))
				nInicio:= U_DtHr2Bit(dH8DtIni,nHora)
				If nInicio < 1
					nInicio := 1
				Endif
				nHora := Val(Substr(cH8HrFim,1,2)+"."+Substr(cH8HrFim,4,2))
				nFim := U_DtHr2Bit(dH8DtFim,nHora)-nInicio
				If !u_C690Ilim(cH8Recurso)
					StuffBit(@cCalend,nInicio,Min(nBitFinal,nFim),nBufferSize)
					FSeek(nCargaHdl,PosiMaq(cH8Recurso,cIndex)*nBufferSize)
					If FWrite(nCargaHdl,cCalend,nBufferSize) < nBufferSize .And. !lShowOCR
						Help(" ",1,"FWRITERROR",,Str(FError(),2,0),05,38)
					EndIf
				EndIf
				dbSelectArea("SH8")
				dbAppend()
				aEval(aNaoMuda[nLoop1, nLoop2],    {|z,w| FieldPut(w, z)})
				SH8->H8_FILIAL := xFilial("SH8")
				dbSelectArea("CARGA")
				dbAppend()
				aEval(aNaoMuda[nLoop1, nLoop2],    {|z,w| FieldPut(w, z)})
				CARGA->H8_FILIAL := xFilial("SH8")
			EndIf
		Next
	Next
EndIf
Return lContinua

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DtHr2Bit ³ Autor ³ Robson Bueno          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Transforma um Data e hora em um bit do arquivo binario     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1=DtHr2Bit(ExpD2,ExpN3)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Retorna a numero do bit dentro do arquivo binario  ³±±
±±³          ³ ExpD2 = Data                                               ³±±
±±³          ³ ExpN3 = Hora                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DtHr2Bit(dDia,nHora)
Local dDiaIni := dDataPar
Local nRet
nRet := ( 24 * nPrecisao * ( dDia - dDiaIni ) )
nRet += nPrecisao * Int(nHora)
nRet += ( Val( Substr( Str(nHora,20,2) , At( "." , Str(nHora,20,2) ) + 1 ,Len( Str(nHora,20,2) ))) / ( 60 / nPrecisao) ) + 1
Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Bit2DtHr ³ Autor ³ Robson Bueno          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Transforma o numero de um Bit do arquivop binario em       ³±±
±±³          ³ data e hora                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1=Bit2DtHr(ExpN2,ExpD3)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Retorna array de 2 elementos 1-Dia 2-Hora          ³±±
±±³          ³ ExpN2 = Numero do bit a ser transformado                   ³±±
±±³          ³ ExpD3 = Data Base                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Bit2DtHr(nBit,dDiaIni)
Local aReturn := Array(2), nDias, nHoras, nMinutos
nBit--
If nBit <= 0
	aReturn[1] := dDiaIni
	aReturn[2] := "00:00"
Else
	nHoras   := Int( nBit / nPrecisao )
	nMinutos := nBit % nPrecisao
	nDias    := Int( nHoras / 24 )
	nHoras   := nHoras % 24
	aReturn[1]  := dDiaIni + nDias
	aReturn[2]  := StrZero( nHoras, 2)+":"+StrZero(nMinutos * ( 60 / nPrecisao ), 2)
Endif
Return aReturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³U_C690T2B ³ Autor ³ Robson Bueno          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tranforma o tempo centesimal de uma operacao em numero de  ³±±
±±³          ³ bits                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpN1=U_C690T2B(ExpC2)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Retorna o numero de bits                           ³±±
±±³          ³ ExpC2 = Tempo a ser transformado Ex. "02.50"               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690T2B(nTempo)
Static lUsaPrcs := NIL
Local nRet,nRet2,nTempo2
Local nMinimo := 0

If (lUsaPrcs == NIL)
	lUsaPrcs := (GetMV("MV_USAPRCS") == "S")
EndIf

nTempo2 := nTempo
nTempo  := Int(nTempo)
If cTipoTemp # "C"
	nTempo  += NoRound(Round(((nTempo2-nTempo)/100)*60,2),2)
Else
	nTempo  += NoRound(((nTempo2-nTempo)/100)*60,2)
EndIf

If ( nTempo < 1 .And. lUsaPrcs ) // Para acertar quando o tempo for menor que 1minuto
	nMinimo := If(nTempo2 > 0.00,1/nPrecisao,0)
	If nMinimo > nTempo
		nTempo := Noround(nMinimo,2)
	EndIf
EndIf

nRet:= Int(nTempo)*nPrecisao+Int(Val(Substr(Str(nTempo,20,2),AT(".",Str(nTempo,20,2))+1,Len(Str(nTempo,20,2))))/(60/nPrecisao))
nRet2:=Int(nTempo)*nPrecisao+(Val(Substr(Str(nTempo,20,2),AT(".",Str(nTempo,20,2))+1,Len(Str(nTempo,20,2))))/(60/nPrecisao))

If (nRet > 0 .And. nRet < 1) .Or. (lUsaPrcs .And. nRet2 > 0 .And. nRet2 < 1)
	If (Val(Substr(Str(nTempo,20,2),AT(".",Str(nTempo,20,2))+1,Len(Str(nTempo,20,2)))) > 8 .Or. lUsaPrcs)
		nRet := 1
	Else
		nRet := 0
	Endif
Endif
Return nRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ NextBtFr   ³ Autor ³ Robson Bueno        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que retorna o proximo bit 0 em uma string binaria   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³ Waldemiro L. Lustosa                     ³ Data ³ 08/09/95 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NextBtFr(cString,nStart,aRet,lFlag)
Local nBit := nStart, nOk := 0, nLigados, nTest := 10 * nPrecisao
Local nLimite:=(aRet[4]*8)-nTest

// Flag criada para, durante uma Carga pelo Fim, esta fun‡„o seja executada
// pelo in¡cio.
lFlag := IIf( lFlag == NIL, .F., lFlag)

// Busca em blocos para agilizar processamento:
While nBit <= nLimite
	If mv_par01 == 2 .Or. lFlag
		nLigados := Look4Bit( cString, nBit, nTest, aRet[4] )
	Else
		If (nTest - 1) < nBit
			nLigados := Look4Bit( cString, nBit-(nTest-1), nTest, aRet[4] )
		Else
			Exit
		Endif
	EndIf
	If nTest == nLigados
		If mv_par01 == 2 .Or. lFlag
			nBit := nBit + nTest
		Else
			nBit := nBit - nTest
		Endif
	Else
		Exit
	EndIf
End

While nBit <= nLimite
	nOk := u_Bit2On(cString,nBit,1,aRet[4])
	If nOk == 0
		If mv_par01 == 2 .Or. lFlag
			nBit++
		Else
			nBit--
		Endif
	ElseIf nOk == 1
		Exit
	ElseIf nOk == -1
		nBit := -1
		Exit
	Endif
End
Return nBit

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ C690Stp   ³ Autor ³ Waldemiro L. Lustosa ³ Data ³ 08/09/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que define a necessidade de setup ou nao no inicio  ³±±
±±³          ³ da alocacao de uma operacao.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Stp(cRecurso,nBit,aRecursos,cString,cCalStr,aRet)
Local aArrayRec, nPosAsBin, cChave, cAlias := Alias(), lRet := .T., nPosArray,nPosRec
Local aContrRec := {}
Local i
Local nBitOld := nBit

nPosAsBin := u_C690AsBn( aRecursos, TRB->RECURSO )
If nPosAsBin > 0

	aArrayRec := aRecursos[ nPosAsBin ][4]

	If !Empty( aArrayRec)                 
		nPosArray := Ascan( aArrayRec , { |x| x[1]+x[2] == TRB->PRODUTO+TRB->OPERAC } )
		If (nPosArray > 0)
			Aadd(aContrRec, aArrayRec[nPosArray][3] )
			If (nPosRec := Ascan( aContrRec , { |x| x[2] == nBit .And. x[4] == cRecurso } ) ) > 0			
				lRet := .F.
			EndIf
		EndIf
	EndIf

	If lRet		
		dbSelectArea("CARGA")
		dbSetOrder(3)
		cChave := TRB->RECURSO+Str(nBit+1,8,0)	// Lembre-se que o Bit Final sempre ‚ o posterior no CARGA
		If u_Bit2On(cCalStr,nBit,1,aRet[4]) == 1 .And. u_Bit2On(cString,nBit,1,aRet[4]) == 0
			dbSeek(xFilial("SH8")+cChave)
			If Found() .And. (TRB->OPERAC == CARGA->H8_OPER )
				lRet := u_C690Sup2( CARGA->H8_OP,TRB->PRODUTO )
			EndIf
		EndIf
		dbSetOrder(1)
	EndIf
	
	If lRet 
	  	While u_Bit2On(cCalStr,nBit,1,aRet[4]) == 0 .And. nBit > 0
			nBit--
	 	End
	 	
	 	If nBitOld # nBit .And. nBit > 1
			lRet := u_C690Stp(cRecurso,nBit,aRecursos,cString,cCalStr,aRet)				 	
	 	EndIf	
	EndIf	
EndIf

dbSelectArea(cAlias)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690Ilim    ³ Autor ³Rodrigo de A Sartorio³ Data ³ 05/05/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que retorna se recurso e' ilimitado (T) ou nao (F)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Ilim(cRecurso)
Local aArea:=GetArea()
Local aAreaSH1:={}
Local lIlimita:=.F.
dbSelectArea("SH1")
aAreaSH1:=GetArea()
dbSetOrder(1)
If dbSeek(xFilial("SH1")+cRecurso)
	lIlimita:=SH1->H1_ILIMITA == "S"
EndIf
RestArea(aAreaSH1)
RestArea(aArea)
Return lIlimita

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690QtAl    ³ Autor ³Rodrigo de A Sartorio³ Data ³ 24/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao que retorna qdo a ser alocada na operacao           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690QtAl(cRecurso,aRecursos,nDur,aOpcoes,i,nNumDesdob)
Local nQuantAloc := 0

If TRB->DESPROP == "S"
	nQuantAloc:=TRB->QTDPROD/nNumDesdob
ElseIf !Empty(TRB->TEMPDES)
	nQuantAloc:=TRB->QTDPROD/nNumDesdob
EndIf
              
//-- Se o recurso for alternativo ou secundario realiza o calculo da eficiencia
If aOpcoes[i][9][1]<> "P" .And. aOpcoes[i][9][2] # 1
	nQuantAloc := nQuantAloc * aOpcoes[i][9][2] //(aOpcoes[i][9][2]/100)	
EndIf

Return nQuantAloc

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690AsBn  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 01/09/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua uma busca bin ria em um Array (substitui o Ascan).  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Pr‚-      ³ Os dados do Array devem estar ordenados e serem unicos.    ³±±
±±³Requisitos³ (caso nao sejam unicos, esta funcao s¢ serve para detectar ³±±
±±³          ³ a existencia, pois nao tr s na posicao do primeiro).       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690AsBn(aArray,Elemento)
Local nMedia, nPosIni, nPosFim

nPosIni := 1
nPosFim := Len(aArray)

If nPosIni <= nPosFim
	While nPosIni <= nPosFim
		nMedia := Int( ( nPosIni + nPosFim ) / 2 )
		If Elemento < aArray[nMedia][1]
			nPosFim := nMedia - 1
		ElseIf Elemento > aArray[nMedia][1]
			nPosIni := nMedia + 1
		Else
			Exit
		EndIf
	End
EndIf

Return IIf( nPosIni <= nPosFim , nMedia , 0 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690Vis   ³ Autor ³ Robson Bueno          ³ Data ³18/06/00  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualizacao da carga maquina                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C690Vis()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Vis(oCenterPanel)
Local nBit := 1, nCol := 19
Local cCargaFile, nHdl
Local cBuffer, aCarga := Array(8), aMaq, dDia
Local nB1Len, nB1Fat, nB1Pos, nB1UltPos, nB1Rec := 1
Local cCalFile, nCalHdl
Local nFaixa
Local aCampos, cArqaOPs, cArqaCorOPs
Local cOldDirPcp:=cDirPcp
Local cArqTrab := cDirPCP + cNameCarga + "TRB"

Private aCalendGrid := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A visualizacao ‚ sempre sobre o diretorio de dados se nao    ³
//³ processou a Carga Maquina                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lAlocou
	cDirPcp := cDirDados
EndIf

If Empty(cDirPcp)
	dbSelectArea("SX2")
	dbSeek("SH8")
	If Found()
		cDirPcp := Alltrim(SX2->X2_PATH)
	EndIf
Else
	cDirPcp += IIf( Right(cDirPcp,1) # "\" , "\" , "" )
EndIf

cCargaFile := cDirPcp+cNameCarga+".MAQ"
cCalFile := cDirPcp+cNameCarga+".CAL"

If Select("CARGA") == 0
	If !File(cDirPcp+cNameCarga+".OPE") .Or. !File(cDirPcp+cNameCarga+"1" + OrdBagExt()) .Or. ;
			!File(cDirPcp+cNameCarga+"2" + OrdBagExt()) .Or. !File(cDirPcp+cNameCarga+"3" + OrdBagExt()) .Or. ;
			!File(cDirPcp+cNameCarga+"4" + OrdBagExt()) .Or. !File(cDirPcp+cNameCarga+"5" + OrdBagExt()) .Or. ;
			!File(cDirPcp+cNameCarga+"6" + OrdBagExt())
		Help(" ",1,"C690NAOCA1")
		// Apaga indicador de Atualiza‡„o dos Arquivos SC2, SC1, SD4, etc a partir da Carga
		A690CheckSC2(.F.)
		Return NIL
	EndIf
	dbUseArea(.T.,cDrvCarga,cDirPcp+cNameCarga+".OPE","CARGA",.F.,.F.)
	dbSetIndex(cDirPcp+cNameCarga+"1")
	dbSetIndex(cDirPcp+cNameCarga+"2")
	dbSetIndex(cDirPcp+cNameCarga+"3")
	dbSetIndex(cDirPcp+cNameCarga+"4")
	dbSetIndex(cDirPcp+cNameCarga+"5")
	dbSetIndex(cDirPcp+cNameCarga+"6")
	dbGotop()
EndIf

dbSelectArea("CARGA")
Pack
dbGotop()
If (Bof() .And. Eof())
	Help(" ",1,"C690NAOCA1")
	// Apaga indicador de Atualiza‡„o dos Arquivos SC2, SC1, SD4, etc a partir da Carga
	A690CheckSC2(.F.)
	Return NIL
ElseIf !File(cCargaFile) .Or. !File(cCalFile)
	Help(" ",1,"C690NAOCA2")
	// Apaga indicador de Atualiza‡„o dos Arquivos SC2, SC1, SD4, etc a partir da Carga
	A690CheckSC2(.F.)
	Return NIL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le arquivo CARGA.MAQ para montar array de controle           ³
//³ aCarga[1] := Handler do arquivo                              ³
//³ aCarga[2] := Dia da geracao da carga maquina                 ³
//³ aCarga[3] := Periodo                                         ³
//³ aCarga[4] := Precisao                                        ³
//³ aCarga[5] := Numero maquina                                  ³
//³ aCarga[6] := Indice                                          ³
//³ aCarga[7] := Tamanho do registro                             ³
//³ aCarga[8] := Handler do arquivo de calendario                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nHdl := FOpen(cCargaFile,0+64)
If nHdl == -1
	If !lShowOCR
		Help(" ",1,"SemCarga",,Str(FError(),2,0),05,38)
	EndIf
	Return NIL
Endif

nCalHdl  := FOpen(cCalFile,0+64)
If nCalHdl == -1
	If !lShowOCR
		Help(" ",1,"SemCarga",,Str(FError(),2,0),05,38)
	EndIf
	Return NIL
Endif
cBuffer := Space(8)
aCarga[1] := nHdl
Fseek(nHdl,-8,2)
If FRead(nHdl,@cBuffer,8) # 8 .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf
If "/"$cBuffer
	aCarga[2] := CtoD(cBuffer) // Dia da carga
Else
	aCarga[2] := Ctod(Subs(cBuffer,7,2)+"/"+Subs(cBuffer,5,2)+"/"+Subs(cBuffer,3,2))
EndIf
cBuffer := Space(2)
Fseek(nHdl,-10,2)
If Fread(nHdl,@cBuffer,2) # 2 .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf
aCarga[3] := Bin2I(cBuffer) // Periodo
Fseek(nHdl,-12,2)
If Fread(nHdl,@cBuffer,2) # 2 .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf
aCarga[4] := Bin2I(cBuffer) // Precisao
FSeek(nHdl,-14,2)
If FRead(nHdl,@cBuffer,2) # 2 .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf
aCarga[5] := Bin2I(cBuffer) // Numero de maquinas
cBuffer := Space(7*aCarga[5])
FSeek(nHdl,-14-(7*aCarga[5]),2)
If FRead(nHdl,@cBuffer,7*aCarga[5]) # ( 7*aCarga[5] ) .And. !lShowOCR
	Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
EndIf
aCarga[6] := cBuffer // Indice da carga maquina
aCarga[7] := (24 * aCarga[3] * aCarga[4]) / 8 // Tamanho do registro
aCarga[8] := nCalHdl

If mv_par03 == 1 .And. Select("FER") == 0
	dbUseArea(.T.,cDrvCarga,cDirPcp+cNameCarga+".FER","FER",.F.,.F.)
	dbSetIndex(cDirPcp+cNameCarga+".FID")
	dbReIndex()
EndIf

aCampos := {}

Aadd(aCampos, {"RECURSO", "C", 6, 0 })
Aadd(aCampos, {"BITINI", "C", 6, 0 })
Aadd(aCampos, {"COR", "C", 3, 0 })

cArqaOPs := CriaTrab(aCampos)
dbUseArea(.T.,cDrvCarga,cArqaOPs,"aOPs",.F.,.F.)
IndRegua("aOPs",cArqaOPs,"RECURSO+BITINI",,,"Criando Indices .........")  // "Criando Indices ........."
aCampos := {}

Aadd(aCampos, {"OP", "C", 13, 0 })
Aadd(aCampos, {"COR", "C", 3, 0 })
Aadd(aCampos, {"PRODUTO", "C", TamSX3("B1_COD")[1], 0 })
Aadd(aCampos, {"STATUS", "C", 1, 0 })

cArqaCorOPs := CriaTrab(aCampos)
dbUseArea(.T.,cDrvCarga,cArqaCorOPs,"aCorOPs",.F.,.F.)
IndRegua("aCorOPs",cArqaCorOPs,"OP",,,"Criando Indices .........")  // "Criando Indices ........."
If aCarga[3] < 68
	nB1Len:= 69 - aCarga[3]
	nB1Fat:= 1
Else
	nB1Len := 1
	nB1Fat := 69 / aCarga[3]
Endif

If dDataBrowse # NIL .And. aCarga[2] < dDataBrowse
	nB1Rec := ( dDataBrowse - aCarga[2] ) + 1
ElseIf aCarga[2] > dDataBrowse  // Permite visualizar somente a partir da data do calculo
	If dDataBrowse # NIL
		Aviso(" Atenção ","Data de inicio menor que data do cálculo. Será considerada a data do cálculo para a Visualização.","",{"Ok"})    // ### Atenção ### "Data de inicio menor que data do cálculo. Será considerada a data do cálculo para a Visualização." ###
	EndIf
	dDataPar	:= aCarga[2]
	dDataBrowse	:= aCarga[2]
EndIf

nB1Pos := nB1Rec * nB1Fat
nB1UltPos := nB1Pos

aMaq := u_C690VrIn(aCarga)

If Empty(aMaq)
	dbSelectArea("aOPs")
	dbCloseArea()
	FErase(cArqaOPs+GetDBExtension())
	FErase(cArqaOPs+OrdBagExt())
	dbSelectArea("aCorOPs")
	dbCloseArea()
	FErase(cArqaCorOPs+GetDBExtension())
	FErase(cArqaCorOPs+OrdBagExt())
	dbSelectArea("SC2")
	Return NIL
EndIf

If dDataBrowse # NIL .And. aCarga[2] < dDataBrowse
	dDia := dDataBrowse
	nBit := 1 + ( 24 * aCarga[4] ) * ( nB1Rec - 1 )
Else
	dDia := aCarga[2]
EndIf

dbUseArea(.T.,cDrvCarga,cArqTrab,"TRB",.F.,.F.)
IndRegua("TRB",cArqTrab,"OPNUM+ITEM+SEQUEN+ITEMGRD+RECURSO+OPERAC",cDrvCarga,,"Criando Indices .........")	//"Criando Indices ........."

u_C690ScCl(nBit,58*aCarga[4]+(nBit-1),nCol,aCarga,aMaq,.T.,oCenterPanel)

nFaixa := nCol - 19
nFaixa := IIf( nFaixa >= 24, nFaixa - 24, nFaixa )
nFaixa := IIf( nFaixa >= 24, nFaixa - 24, nFaixa )

dbSelectArea("aOPs")
dbCloseArea()
FErase(cArqaOPs+GetDBExtension())
FErase(cArqaOPs+OrdBagExt())
dbSelectArea("aCorOPs")
dbCloseArea()
FErase(cArqaCorOPs+GetDBExtension())
FErase(cArqaCorOPs+OrdBagExt())
dbSelectArea("SC2")
cDirPcp:=cOldDirPcp
dbSelectArea("TRB")
dbCloseArea()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690VrIn  ³ Autor ³ Robson Bueno          ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualizacao da carga maquina                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := C690VrIn(ExpA1)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1:= Array com maquinas a serem exibidas                ³±±
±±³          ³ ExpA2:= Array com dados do arquivo da carga maquina        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690VrIn(aCarga)
Local aMaq := {} ,cBuffer,sCalend, dDia
Local cAlocSacr, aCor := {}, nCor := 1, cCores, nPosAt
cCores := Alltrim(GetMV("MV_CORPCP"))
If Empty(cCores)
	Help(" ",1,"C690CORPCP")
	Return({})
EndIf
cCores := IIf( Right(cCores,1) == "/", Left(cCores,Len(cCores)-1), cCores )
cCores := IIf( Left(cCores,1) == "/", Right(cCores,Len(cCores)-1), cCores )

While !Empty(cCores)
	nPosAt := At("/",cCores)
	If nPosAt > 0
		Aadd(aCor,Substr(cCores,1,nPosAt-1))
		cCores := Right(cCores,Len(cCores)-nPosAt)
	ElseIf !Empty(cCores)
		Aadd(aCor,cCores)
		cCores := ""
	EndIf
End

dDia := aCarga[2]

dbSelectArea("SH1")
dbSetOrder(1)
dbSeek(xFilial("SH1"))
While !Eof() .And. H1_FILIAL == xFilial("SH1")
	// So considera recursos selecionados
	If mv_par19 == 1 .And. ! (H1_CODIGO $ cRecSele) .and. ! Empty(cRecSele)
		dbSkip()
		Loop
	EndIf
	cBuffer := Space(aCarga[7])
	sCalend := Space(aCarga[7])
	cAlocSacr := Space(aCarga[7])
	FSeek(aCarga[8],PosiMaq(H1_CODIGO,aCarga[6])*aCarga[7])
	If FRead(aCarga[8],@sCalend,aCarga[7]) # aCarga[7] .And. !lShowOCR
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		Return({})
	EndIf
	FSeek(aCarga[1],PosiMaq(H1_CODIGO,aCarga[6])*aCarga[7])
	If FRead(aCarga[1],@cBuffer,aCarga[7]) # aCarga[7] .And. !lShowOCR
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		Return({})
	EndIf
	FSeek(aCarga[8],PosiMaq(H1_CODIGO,aCarga[6])*aCarga[7])
	If FRead(aCarga[8],@cAlocSacr,aCarga[7]) # aCarga[7] .And. !lShowOCR
		Help(" ",1,"FREADERROR",,Str(FError(),2,0),05,38)
		Return({})
	EndIf
	dbSelectArea("CARGA")
	dbSetOrder(2)
	dbSeek(xFilial("SH8")+SH1->H1_CODIGO)
	While !Eof() .And. H8_FILIAL+H8_RECURSO == xFilial("SH8")+SH1->H1_CODIGO
		If H8_STATUS == "S"
			StuffBit(@cAlocSacr,H8_BITINI,H8_BITFIM-H8_BITINI,aCarga[7])
		EndIf
		dbSelectArea("aOPs")
		dbAppend()
		Replace  RECURSO With CARGA->H8_RECURSO,;
			BITINI With StrZero(CARGA->H8_BITINI,6,0)
		dbSelectArea("aCorOPs")
		dbSeek(Substr(CARGA->H8_OP,1,8))
		If !Found()
			dbSelectArea("SC2")
			dbSeek(xFilial("SC2")+CARGA->H8_OP)
			If Found()
				nCor := IIf( nCor > Len(aCor), 1, nCor )
				dbSelectArea("aCorOPs")
				dbAppend()
				Replace  OP With CARGA->H8_OP,;
					COR With aCor[nCor],;
					PRODUTO With SC2->C2_PRODUTO,;
					STATUS With CARGA->H8_STATUS
				dbSelectArea("aOPs")
				Replace COR With aCor[nCor]
				nCor++
			Else
				Help(" ",1,"C690NAOOP",,CARGA->H8_OP,01,21)
				Return({})
			EndIf
		Else
			dbSelectArea("aOPs")
			Replace COR With aCorOPs->COR
			If Val(Substr(CARGA->H8_OP,9,3)) < Val(Substr(aCorOPs->OP,9,3))
				dbSelectArea("SC2")
				dbSeek(xFilial("SC2")+CARGA->H8_OP)
				If Found()
					dbSelectArea("aCorOPs")
					Replace PRODUTO With SC2->C2_PRODUTO
				EndIf
			EndIf
		EndIf
		dbSelectArea("CARGA")
		dbSkip()
	End
	dbSetOrder(1)
	// na descricao, foi incluido o codigo
	dbSelectArea("SH1")
	Aadd(aMaq,{H1_CODIGO, Alltrim(H1_CODIGO)+" "+Alltrim(H1_DESCRI), sCalend, cBuffer, cAlocSacr})
	dbSkip()
End


Return aMaq

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690ScCl  ³ Autor ³ Robson Bueno/Erike    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Scroll horizontal da tela de alocacao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C690ScCl(ExpN1,ExpN2,ExpN3,ExpA5,ExpA6,ExpL7)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 := Bit Inicial a ser exibido                         ³±±
±±³          ³ ExpN2 := Bit final a ser exibido                           ³±±
±±³          ³ ExpN3 := Coluna inicial da tela                            ³±±
±±³          ³ ExpA5 := Array com dados do arquivo da carga maquina       ³±±
±±³          ³ ExpA6 := Array com as maquinas a serem exibidas            ³±±
±±³          ³ ExpL7 := Caso .T. imprime descricao dos recursos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690ScCl(nBitIni,nBitFim,nCol,aCarga,aMaq,lNew,oCenterPanel)
Local x,i, j, nOk, aDia := Array(7), nCurCol, cCor := SetColor(), nStep

Local oDlg
Local oCalendGrid
Local cMenu := If(MV_PAR01 == 1, "", "")

Local aSize			:= MsAdvSize()
Local aGridAloc		:= {}
Local aGridMaq		:= {}
Local aGridSave		:= {}
Local nNewLine		:= 0
Local cSeek			:= Nil
Local nPos			:= Nil
Local nLineRec		:= 1
Local nPrecisa		:= GetMV("MV_PRECISA")
Local aOpIni		:= {}                 
Local aOpLeng		:= {}
Local lPaint		:= Nil
Local aPopUpM		:= {}
Local cTitRecurso	:= ""
Local lC690TitRec	:= ExistBlock("C690TITREC")
Local aOpers        := {}
Private aObjDet		:= Array(19)
Private aRec		:= {}                      
Private oTree,oMenu


lReprocessa := .F.
lAlterou    := .F.

If ExistBlock("u_C690Pait")
	lPaint := ExecBlock("u_C690Pait",.F.,.F.)
	If ValType(lPaint) == "L" .And. ! lPaint
		fClose(aCarga[1])
		fClose(aCarga[8])
		Return
	Endif
Endif

If u_SelePrj()
	fClose(aCarga[1])
	fClose(aCarga[8])
	C690Project()
	Return
Endif

nStep := Round(aCarga[4]/2,0)

nRegua:=0
If (oCenterPanel==Nil)
	oRegua:nTotal:=nTotRegua:=Len(aMaq) * Len(aMaq[1, 3]) * 8
Else
	oCenterPanel:SetRegua1( Len(aMaq) * Len(aMaq[1, 3]) * 8 )
EndIf

For i := 1 to Len(aMaq)
	Eval(bBlock)
	nCurCol := nCol
	If Len(aMaq) >= i
		u_C690Pait(nBitIni, nBitFim+nStep, nStep, aMaq[i], aCarga[7], @nCurCol, i, oCenterPanel)
	Else
		For j := nBitIni to nBitFim Step aCarga[4]
			nCurCol++
		Next j
	Endif
Next

nRegua += 20
Eval(bBlock)

MENU oMenu POPUP
MENUITEM cMenu    Action u_C690Pror(oCalendGrid, 1)           // "Alterar Data Prevista de Fim/Inicio
MENUITEM "Alterar Prioridade"  Action u_C690Pror(oCalendGrid, 2)           // "Alterar Prioridade"
MENUITEM  "Recalcular Carga Maquina"  Action (lReprocessa := .T., oDlg:End()) // "Recalcular Carga Maquina"
If ExistBlock("C690POPUP")
	If Valtype(aPopUpM := ExecBlock("C690POPUP",.F.,.F.))== 'A'
		For i := 1 To Len(aPopUpM)
			If ValType(aPopUpM[i,1])#"C" .Or. ValType(aPopUpM[i,2])#"C"
				Loop
			EndIf
			MenuAddItem( aPopUpM[i,1],,,,,,,oMenu, &('{||'+aPopUpM[i,2]+'}'))
		Next
	EndIf
EndIf
ENDMENU

DEFINE MSDIALOG oDlg TITLE "Carga Máquina" FROM  0,0 TO aSize[6],aSize[5] PIXEL STYLE 128 //"Carga Máquina"

	//-- Ajusta Janela para o tamanho correto
	oDlg:lMaximized := .T.

	oPanel2 := tPanel():New( 00,00,"",oDlg,,.T.,.T.,,,10,10,.F.,.F.)
	oPanel2:Align := CONTROL_ALIGN_BOTTOM

	@1,1 BTNBMP oBmp1 RESOURCE "BMPSEP1"   SIZE 6,25 WHEN .F. Of oPanel2	
	oBmp1:Align := CONTROL_ALIGN_LEFT

	@1,1 BTNBMP oBmp1 RESOURCE "BMPSXB"   SIZE 25,25 ACTION (oFolder:lVisible := !oFolder:lVisible) Of oPanel2	
	oBmp1:Align := CONTROL_ALIGN_LEFT

	@1,1 BTNBMP oBmp1 RESOURCE "PMSCOLOR"   SIZE 25,25 ACTION (LegOp(aOpLeng)) When (mv_par06 == 1) Of oPanel2	
	oBmp1:Align := CONTROL_ALIGN_LEFT

	@1,1 BTNBMP oBmp1 RESOURCE "PMSZOOMOUT"   SIZE 25,25 ACTION (If(oCalendGrid:nZoom> -12,oCalendGrid:nZoom-=4,.T.),oCalendGrid:Refresh()) WHEN (oCalendGrid:nZoom> -11) Of oPanel2	
	oBmp1:Align := CONTROL_ALIGN_LEFT

	@1,1 BTNBMP oBmp1 RESOURCE "PMSZOOMIN"   SIZE 25,25 ACTION (If(oCalendGrid:nZoom< 20,oCalendGrid:nZoom+=4,.T.),oCalendGrid:Refresh()) WHEN (oCalendGrid:nZoom < 19) Of oPanel2
	oBmp1:Align := CONTROL_ALIGN_LEFT                                               
	
	@1,1 BTNBMP oBmp1 RESOURCE "FINAL" SIZE 25,25 ACTION (oDlg:End()) WHEN .T. Of oPanel2
	oBmp1:Align := CONTROL_ALIGN_RIGHT
	
	oFolder			:= TFolder():New(0,0,{"Alocações","Roteiro"},{"_Aloc","_Rot"},oDlg,,,, .F., .F.,1,100,) //"Alocações" ### "Roteiro"
	oFolder:align 	:= CONTROL_ALIGN_BOTTOM
	oFolder:Refresh()
	
	           	
	@ 0,0 CALENDGRID oCalendGrid SIZE 800,600 OF oDlg PIXEL RESOLUTION 4 DATEINI dDataPar DEFCOLOR RGB(255,255,225) FillAllLines
	oCalendGrid:bRClicked := {|o,x,y| If( u_C690RMnu(aCalendGrid,StrZero(oCalendGrid:nLineAtu,8),StrZero(oCalendGrid:nIntervIni,8),StrZero(oCalendGrid:nIntervFim,8)) , oMenu:Activate(x,y,oCalendGrid),)} // Posição x,y em relação a Dialog
	oCalendGrid:Align := CONTROL_ALIGN_ALLCLIENT
	
	oCalendGrid:bLClicked := {|| If(oFolder:lVisible, u_C690Clik(oCalendGrid:nLineAtu, oCalendGrid:nIntervIni, oCalendGrid:nIntervFim, aMaq, aCarga, oCalendGrid), )}

	//-- Se a saida for Protheus Simpl. forca a eliminacao de recursos sem alocacao	
	If mv_par24 == 2 .Or. mv_par23 == 4
		aGridSave := {aClone(aCalendGrid), aClone(aMaq), aClone(aCarga)}
		u_C690RcAl()
		For x := 1 to Len(aCalendGrid)
			If (nNewLine := u_C690RcAl(aCalendGrid[x, 1])) > 0
				aCalendGrid[x, 2] := nNewLine
				Aadd(aGridAloc, aCalendGrid[x])
			Endif
		Next
		aCalendGrid := aClone(aGridAloc)
		For x := 1 to Len(aMaq)
			If aScan(aCalendGrid, {|z| z[1] == aMaq[x, 2]}) > 0
				AAdd(aGridMaq, aMaq[x])
			Endif
		Next
		aMaq := aClone(aGridMaq)
		aCarga[5] := Len(aMaq)
		aCarga[6] := ""
		aEval(aMaq, {|z| aCarga[6] += z[1] + "|"})
	Endif

	//-- Se a saida for Protheus Simpl. elimina dados que nao sejam referentes a alocacoes	
	If mv_par23 == 4
		aEval(aCalendGrid,{|x| If(Substr(x[6],1,2)=="OP",aAdd(aOpers,x),NIL) })
		aCalendGrid := aClone(aOpers)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³P.E. que permite alterar o titulo dos recursos apresendados na tela ³
	//³do carga maquina.                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lC690TitRec
		For x := 1 To Len(aCalendGrid)
			cTitRecurso := ExecBlock("C690TITREC",.F.,.F.,{aCalendGrid[x,1]})
			If Valtype(cTitRecurso)=='C'
				aCalendGrid[x,1] := cTitRecurso
			EndIf
		Next
	EndIf
	
	// Prepara a Regua de processamento de registros
	nRegua:=0
	If (oCenterPanel==Nil)
		oRegua:Set(nRegua)
		oRegua:nTotal:=nTotRegua:=Len(aCalendGrid)
	Else
		oCenterPanel:IncRegua1()
		oCenterPanel:SetRegua1( Len(aCalendGrid) )
	EndIf	

	aLinhas := {}  
	aOpLeng := {}
	For x := 1 to Len(aCalendGrid)
		Eval(bBlock)
		oCalendGrid:Add(aCalendGrid[x][1], aCalendGrid[x][2], Max(1, aCalendGrid[x][3]), aCalendGrid[x][4], aCalendGrid[x][5], aCalendGrid[x][6])
		
		If !Empty(aCalendGrid[x][9]) .And. ( AsCan( aOpLeng ,aCalendGrid[x][9]) == 0 )
			Aadd(aOpLeng, aCalendGrid[x][9])
		EndIf
		
		//-- Atualiza aqui os tipos do aCalendGrid. Nao eh feito antes devido os calculos
		aCalendGrid[x,2] := StrZero(aCalendGrid[x,2],8)
		aCalendGrid[x,3] := StrZero(aCalendGrid[x,3],8)
		aCalendGrid[x,4] := StrZero(aCalendGrid[x,4],8)    
	Next
	
	nRegua += 20
	Eval(bBlock)
	

	aCalendGrid := ASort(aCalendGrid,,, { |x, y| x[2]+x[3]+x[4] < y[2]+y[3]+y[4]} )
    
    //-- Inicializa array aRec com valores default
	C690RecI()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ aRec comtem as informacaoes da OP no recurso consultado      ³
	//³ aRec[01] := Numero da OP + Item + Sequencia                  ³
	//³ aRec[02] := Roteiro de Operacao                              ³
	//³ aRec[03] := Codigo do Produto + Descricao                    ³
	//³ aRec[04] := Recurso + Descricao                              ³
	//³ aRec[05] := Operacao + Descricao                             ³
	//³ aRec[06] := Quantidade da Alocacao                           ³
	//³ aRec[07] := Data prevista de Termino da OP                   ³
	//³ aRec[08] := Reprogramada                                     ³
	//³ aRec[09] := Data Inicial+ Hora de inicio                     ³
	//³ aRec[10] := Data Final + Hora Final                          ³
	//³ aRec[11] := Setup                                            ³
	//³ aRec[12] := Tempo da Operacao                                ³
	//³ aRec[13] := Tempo Final de Operacao                          ³
	//³ aRec[14] := Desdobramento                                    ³
	//³ aRec[15] := Status da OP                                     ³
	//³ aRec[16] := Indica se usa ferramenta                         ³
	//³ aRec[17] := Tempo de utilizacao da ferramenta                ³		
	//³ aRec[18] := Ferramental                                      ³		
	//³ aRec[19] := Prioridade                                       ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	//-- Detalhes da Op         
	@ 002, 002 TO 085, 270 Label "Dados da Operação" OF oFolder:aDialogs[1] PIXEL  //"Dados da Operação"

	@ 013, 005 Say "Op"      	 Of oFolder:aDialogs[1] PIXEL	 //"Op"  
	@ 013, 090 Say "Roteiro"	 Of oFolder:aDialogs[1] PIXEL	 //"Roteiro"
	@ 025, 005 Say "Produto" 	 Of oFolder:aDialogs[1] PIXEL	 //"Produto"
	@ 037, 005 Say "Recurso" 	 Of oFolder:aDialogs[1] PIXEL	 //"Recurso"
	@ 049, 005 Say "Operação"	 Of oFolder:aDialogs[1] PIXEL	 //"Operação"
	@ 061, 005 Say "Quantidade"	 Of oFolder:aDialogs[1] PIXEL	 //"Quantidade"
	@ 061, 090 Say "Prioridade"	 Of oFolder:aDialogs[1] PIXEL	 //"Prioridade"  
	@ 073, 005 Say "Ferramentas" Of oFolder:aDialogs[1] PIXEL	 //"Ferramentas"
			         
	@ 011, 037 MsGet aObjDet[01] Var aRec[01]  When .F. Size  50, 5 Of oFolder:aDialogs[1] PIXEL
	@ 011, 122 MsGet aObjDet[02] Var aRec[02]  When .F. Size  15, 5 Of oFolder:aDialogs[1] PIXEL	
	@ 023, 037 MsGet aObjDet[03] Var aRec[03]  When .F. Size 230, 5 Of oFolder:aDialogs[1] PIXEL
	@ 035, 037 MsGet aObjDet[04] Var aRec[04]  When .F. Size 230, 5 Of oFolder:aDialogs[1] PIXEL
	@ 047, 037 MsGet aObjDet[05] Var aRec[05]  When .F. Size 230, 5 Of oFolder:aDialogs[1] PIXEL
	@ 059, 037 MsGet aObjDet[06] Var aRec[06]  When .F. Size  50, 5 Of oFolder:aDialogs[1] PIXEL
	@ 059, 122 MsGet aObjDet[19] Var aRec[19]  When .F. Size  50, 5 Of oFolder:aDialogs[1] PIXEL
	@ 071, 037 MsGet aObjDet[18] Var aRec[18]  When .F. Size 230, 5 Of oFolder:aDialogs[1] PIXEL
			
	//-- Datas
	@ 002, 272 TO 085, 475 Label "Datas" OF oFolder:aDialogs[1] PIXEL //"Datas"

	@ 013,275 Say "Entrega"      	Of oFolder:aDialogs[1] PIXEL //"Entrega"
	@ 013,378 Say "Reprogramada" 	Of oFolder:aDialogs[1] PIXEL //"Reprogramada"
	@ 025,275 Say "Início"  		Of oFolder:aDialogs[1] PIXEL	 //"Início"
	@ 025,378 Say "Fim"				Of oFolder:aDialogs[1] PIXEL	 //"Fim"
	@ 037,275 Say "Preparação" 		Of oFolder:aDialogs[1] PIXEL //"Preparação"  
	@ 037,345 Say "Execução"        Of oFolder:aDialogs[1] PIXEL //"Execução"
	@ 037,408 Say "Pós-Prep."       Of oFolder:aDialogs[1] PIXEL //"Pós-Prep."
	@ 049,275 Say "Util.Recuso"     Of oFolder:aDialogs[1] PIXEL //"Util.Recuso"

	@ 011,305 MsGet aObjDet[07] Var aRec[07] When .F. Size 054, 5 Of oFolder:aDialogs[1] PIXEL
	@ 011,418 MsGet aObjDet[08] Var aRec[08] When .F. Size 054, 5 Of oFolder:aDialogs[1] PIXEL	
	@ 023,305 MsGet aObjDet[09] Var aRec[09] When .F. Size 054, 5 Of oFolder:aDialogs[1] PIXEL
	@ 023,418 MsGet aObjDet[10] Var aRec[10] When .F. Size 054, 5 Of oFolder:aDialogs[1] PIXEL
	@ 035,305 MsGet aObjDet[11] Var aRec[11] When .F. Size 035, 5 Of oFolder:aDialogs[1] PIXEL
	@ 035,370 MsGet aObjDet[12] Var aRec[12] When .F. Size 035, 5 Of oFolder:aDialogs[1] PIXEL
	@ 035,435 MsGet aObjDet[13] Var aRec[13] When .F. Size 037, 5 Of oFolder:aDialogs[1] PIXEL
	@ 047,305 MsGet aObjDet[14] Var aRec[14] When .F. Size 100, 5 Of oFolder:aDialogs[1] PIXEL
	
	//Operacoes
	oTree:= dbTree():New(0, 0,20,0,oFolder:aDialogs[2],,,.T.)
	oTree:Align := CONTROL_ALIGN_ALLCLIENT
	oTree:bChange := {|| .t.}	

ACTIVATE MSDIALOG oDlg

//-- Se a saida for Protheus Simpl. forca a eliminacao de recursos sem alocacao
If mv_par24 == 2 .Or. mv_par23 == 4
	aCalendGrid := aClone(aGridSave[1])
	aMaq        := aClone(aGridSave[2])
	aCarga      := aClone(aGridSave[3])
Endif

fClose(aCarga[1])
fClose(aCarga[8])

return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690RcAl   ³ Autor ³ Robson Bueno         ³ Data ³20/07/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se recurso tem alocacao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cRecurso: Recurso a ser verificada existencia de alocacao   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP - Grafico da Carga Maquina                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690RcAl(cRecurso)
Local nSeek     := 0
Local nSkip     := 0
Static aRecAloc := Nil

If cRecurso == Nil
	aRecAloc := {}
	Return(.T.)
Endif

If aRecAloc == Nil
	aRecAloc := {}
Endif

If (nSeek := aScan(aRecAloc, {|z| nSkip += If(z[2], 0, 1), z[1] == cRecurso})) == 0
	Aadd(aRecAloc, {cRecurso, aScan(aCalendGrid, {|z| z[1] == cRecurso .And. ! Empty(z[9])}) > 0, nSkip})
	nSeek := Len(aRecAloc)
Endif

Return(If(aRecAloc[nSeek, 2], nSeek - nSkip, 0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690Pait  ³ Autor ³ Robson Bueno          ³ Data ³13/06/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pinta o Browse da Carga M quina.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³nInicio : Ponto inicial que será pintado                    ³±±
±±³          ³nFinal  : Ponto final que será pintado                      ³±±
±±³          ³nStep   : Variável usado par adequar a string do carga      ³±±
±±³          ³          obitida no arquivo binário com a tela de acordo   ³±±
±±³          ³          com o parametro mv_precisa                        ³±±
±±³          ³aMaquina: Array com dados do recurso a ser exibido          ³±±
±±³          ³nTamanho: Tamanho do string com a operação ou não do recurso³±±
±±³          ³nCurCol : Coluna inicial a ser impressa                     ³±±
±±³          ³nPos    : Posição relativa na string                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Pait(nInicio, nFinal, nStep, aMaquina, nTamanho, nCurCol , nPos, oCenterPanel)
Local j, nPosArray, cAloc := "", aCorAloc := {}, cCor, cLastCor
Local cChave, lEof
Local nCorAloc := 0, nOldCorAloc := 0
Local xxx1     := 1
Local lFree    := .F.
Local nAjuste  := 0
Local nOcorr   := 0
Local zzw
Local cDesDobr := ""

cCor := SetColor()

If nPrecisao >= 4
	nStep /= 2
Else
	nStep := 1
Endif

if nPrecisao = 1 .or. nPrecisao = 2
	nSoma := If(nPrecisao = 1, 4, 2)
Else
	nSoma := 1
Endif
cOpAtual1 := ""
cSeqAtual := ""

aOpIni := {}

aSavSH8 := {Alias(), sh8->(IndexOrd()), sh8->(RecNo())}
dbSelectArea("SH8")
dbSetOrder(2)
dbSeek(xFilial("SH8") + aMaquina[1])
do While ! Eof() .and. 	xFilial("SH8") == SH8->H8_FILIAL .AND. ;
	SH8->H8_RECURSO == aMaquina[1]
	Aadd(aOpIni, {SH8->H8_BITINI, SH8->H8_BITFIM, SH8->H8_OP, SH8->H8_OPER, SH8->H8_DESDOBR})
	dbSkip()
Enddo

dbGoto(aSavSH8[3])
dbSetOrder(aSavSH8[2])
dbSelectArea(aSavSH8[1])

For j:= nInicio to Len(aMaquina[3]) * 8 Step nStep
	nRegua += nStep - 1
	Eval(bBlock)
	cOpAtual := ""
	nBitOp   := 0
	For zzw := 1 to Len(aOpIni)
		If j >= aOpIni[zzw, 1] .and. j <= aOpIni[zzw, 2]
			cOpAtual := aOpIni[zzw, 3]
			cSeqAtual:= aOpIni[zzw, 4]
			nBitOp   := aOpIni[zzw, 1]
			cDesdobr := aOpIni[zzw, 5]
			// Não colocar exit aqui, pois preciso
			// da ultima ocorrência
		Endif
	Next

	cHint  := "" + cOpAtual + "-" + cSeqAtual //"OP "

	If u_Bit2On(aMaquina[3],j,nStep,nTamanho) = 0 // Pelo calendario, maquina nao opera
		Aadd(aCorAloc,"NO")
		cHint  := "Maquina não opera" //"Maquina não opera"
	ElseIf u_Bit2On(aMaquina[4],j,nStep,nTamanho) = 0
		lEof := .F.
		dbSelectArea("aOPs")
		dbSeek(aMaquina[1]+StrZero(j,6,0),.T.)
		If Eof()
			lEof := .T.
			dbSkip(-1)
		EndIf

		If aMaquina[1] == RECURSO
			If Val(BITINI) == j .Or. lEof
				cLastCor := COR
			Else
				dbSkip(-1)
				cLastCor := COR
			EndIf
		Else
			If Empty(cLastCor)
				dbSkip(-1)
				If aMaquina[1] == RECURSO
					cLastCor := COR
				EndIf
			EndIf
		EndIf
		If mv_par06 == 2
			If u_Bit2On(aMaquina[5],j,nStep,nTamanho) = 0
				// OPs Sacr. em Verde e Normais em Azul
				Aadd(aCorAloc,"G")
				If (nOcorr := aScan(aOcorrencia, {|_1| _1[1] = cOpAtual})) > 0
					aOcorrencia[nOcorr, 3] := .T.
				Endif
			Else
				Aadd(aCorAloc,"B")
			EndIf
		Else
			If u_Bit2On(aMaquina[5],j,nStep,nTamanho) = 0
				// OPs Sacr. em Verde
				Aadd(aCorAloc,"G")
				If (nOcorr := aScan(aOcorrencia, {|_1| _1[1] = cOpAtual})) > 0
					aOcorrencia[nOcorr, 3] := .T.
				Endif
			Else
				Aadd(aCorAloc,cLastCor)
			Endif
		EndIf
	Else
		Aadd(aCorAloc,"W-") // Maquina em horario normal de funcionamento porem nao alocada
		cHint  := "Horário Livre" //"Horário Livre"
	Endif

	lFree := cHint $ "" + ";" + ""

	nOldCorAloc := nCorAloc
	cCorAloc := aCorAloc[Len(aCorAloc)]
	nCorAloc := u_C690Cor(cCorAloc)
	nCorAloc := If(ValType(nCorAloc) # "N", 0, nCorAloc)
	aCorAloc := {}
	nCurCol++
	nLen := Len(aCalendGrid)

		If nLen > 0 .And. aCalendGrid[nLen][2]  = nPos .and. ;
			cOpAtual + cSeqAtual + cDesdobr == aCalendGrid[nLen][7] .and. ;
			aCalendGrid[nLen][5] == nOldCorAloc
			aCalendGrid[nLen][4] := xxx1 + nSoma
		Else
			nAjuste := 0
			If ! lFree
				If Len(aCalendGrid) > 2
					If aCalendGrid[Len(aCalendGrid)-1, 7] == cOpAtual+cSeqAtual
						aCalendGrid[Len(aCalendGrid), 4] -= nSoma
						nAjuste := -nSoma
					Endif
			Endif
		Endif
		Aadd(aCalendGrid, {aMaquina[2], nPos, xxx1 + If(lFree,-nSoma,0)+nAjuste, xxx1 + If(lFree,-nSoma,0) + nSoma, nCorAloc, cHint, cOpAtual + cSeqAtual + cDesdobr, lFree, cOpAtual})
	EndIf

	xxx1 += nSoma

Next j

For j := 1 to Len(aCalendGrid)
	If ! aCalendGrid[j, 8]
		If ! (nOcorr := aScan(aOcorrencia, {|_1| _1[1] = aCalendGrid[j, 9]})) = 0
			If aOcorrencia[nOcorr, 2] = 9 .and. (! aOcorrencia[nOcorr, 3])  // Se sacramentada, não altera cor
				aCalendGrid[j, 5] := u_C690Cor("R")
			Endif
		Endif
	Endif
Next

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³C690Cor   ³ Autor ³ Robson Bueno          ³ Data ³ 03.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna a cor no formato numerico no padrao usado pelo      ³±±
±±³          ³Protheus em alguns componentes                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Numero correspondente a cor fornecida como parametro        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Cor no Padrao xBase Ex: R, BG etc  - Obrigatorio     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Cor(cCor)
LOCAL x, aCores, nRet := 0
* cCor = If(cCor = "BG", "N+", cCor)

aCores := {{"B"   ,   14745600}, ;
           {"G"   ,      57600}, ;
           {"R"   ,        225}, ;
           {"N+"  ,   12632256}, ;
           {"BG"  ,   14276864}, ;
           {"RB"  ,   16733695}, ;
           {"GR"  ,      25800}, ;
           {"N"   ,          0}, ;
           {"B+"  ,   16758711}, ;
           {"G+"  ,      65280}, ;
           {"R+"  ,   11448063}, ;
           {"BG+" ,   16777107}, ;
           {"RB+" ,   16759295}, ;
           {"GR+" ,      65535}, ;
           {"GR++",   12910591}, ;
           {"W"   ,   16777215}, ;
           {"W-"  ,   14211288}, ;
           {"B-"  , RGB(157,255,255)}, ;
           {"GR-" , RGB(224,217,188)},;
           {"NO"  , RGB(255,255,225)}}

For x := 1 to Len(aCores)
	If AllTrim(Upper(aCores[x][1])) == AllTrim(Upper(cCor))
		nRet := aCores[x][2]
	Endif
Next
Return(nRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690Clik  ³ Autor ³ Robson Bueno Silva    ³ Data ³20/12/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualizacao da alocacao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nLinha : Variável que identifica o recurso no array aMaq   ³±±
±±³          ³ nInicio: Bit inicial do trecho que foi clicado pelo usuário³±±
±±³          ³ aMaq   : Array com dados dos recursos                      ³±±
±±³          ³ aCarga : Array com dados geris da carga máquina            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static nPosSelGantt := 0
User Function C690Clik(nLinha, nInicio, nFim, aMaq, aCarga, oCalendGrid)      
Local nPos := u_C690ASBX(aCalendGrid,'{|x| x[nMedia][2]+x[nMedia][3]+x[nMedia][4] == "'+StrZero(oCalendGrid:nLineAtu,8)+StrZero(oCalendGrid:nIntervIni,8)+StrZero(oCalendGrid:nIntervFim,8)+'"}')

If nPos > 0 .And. nPosSelGantt <> nPos .And. !Empty(aCalendGrid[nPos, 7]) .And. Left(aCalendGrid[nPos, 6],Len(""))==""
	u_C690AtDt(aMaq,nLinha,nInicio,aCarga, nFim,SubStr(aCalendGrid[nPos, 1],1,Len(SH8->H8_RECURSO)),aCalendGrid[nPos, 9],aCalendGrid[nPos, 7] )		   	
	nPosSelGantt := nPos 
ElseIf nPosSelGantt <> nPos
	nPosSelGantt := 0
	C690RecI()	
EndIf               

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690AtDt  ³ Autor ³ Robson Bueno Silva    ³ Data ³14/12/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizacao da alocacao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aMaq  : Array com dados dos recursos                       ³±±
±±³          ³ nElem : Variável que identifica o recurso no array aMaq    ³±±
±±³          ³ nBit  : Bit inicial do trecho que foi clicado pelo usuário ³±±
±±³          ³ aCarga: Array com dados geris da carga máquina             ³±±
±±³          ³ cRecurso: Codigo do Recurso posicionado                    ³±±
±±³          ³ cOpOper: Codigo da Ordem de Producao + operacao            ³±±
±±³          ³ cKeyOper: Codigo da OP + operacao + cod. desdobramento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAPCP                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690AtDt(aMaq,nElem,nBit,aCarga, nFim,cRecurso,cOpOper,cKeyOper)
Local cChave, i, nLin, nCol, nKey, cSeekSH6
Local nQuant := 0, cDesdobr, aFerram := {},nQuantAloc:=0,nTemp:=0
Local nIniFerr := 0, nFimFerr := 0
Local nRecSG2
Local cABC 		:= "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Local cRoteiro	:= ""
Local cOperacao	:= ""
Local cFerr		:= ""
Local dReprog	:= CTOD('')
Local aPeriodo
Local lDiff		:= .T. 
Local cSeekWhile

Static lSh8Setup  := Nil
Static lSh8TempEnd:= Nil

If lSh8Setup == Nil
	lSh8Setup := (SH8->(FieldPos("H8_SETUP")) > 0) .And. (CARGA->(FieldPos("H8_SETUP")) > 0) .And. (SHD->(FieldPos("HD_SETUP")) > 0)
Endif

If lSh8TempEnd == Nil
	lSh8TempEnd := (SH8->(FieldPos("H8_TEMPEND")) > 0) .And. (CARGA->(FieldPos("H8_TEMPEND")) > 0) .And. (SHD->(FieldPos("HD_TEMPEND")) > 0)
Endif

If nElem > Len(aMaq) .or. nElem <= 0
	C690RecI()
	Return Nil
Endif

nPrecisao := GetMv("MV_PRECISA")

aFator := {{1, 0.25}, {2, 0.50}, {4, 1.00}, {6, 1.5}, {12, 3}, {60, 15}}

If Empty( nPos   := aScan(aFator, {|a| a[1] == nPrecisao}) )
	nFator := 1
Else
	nFator := aFator[nPos, 2]
EndIf

nBit := (nBit * nFator)
nFim := (nFim * nFator)

If nElem <= Len(aMaq)
	
	If u_Bit2On(aMaq[nElem][3],nBit,1,aCarga[7]) == 0
		If u_Bit2On(aMaq[nElem][3],nBit+Round(aCarga[4]/2,0),1,aCarga[7]) == 0
			C690RecI()
			Return NIL
		EndIf
	EndIf
           
	//-- Definicao da data reprogramada
	dbSelectArea("CARGA")
	dbSetOrder(6)
	CARGA->( DbSeek(xFilial("SH8")+cOpOper+Repl('Z',Len(CARGA->H8_OPER))+'99999999',.T.) )
	Skip -1	
	dReprog	:= CARGA->H8_DTFIM
   
   	dbSelectArea("CARGA")
	dbSetOrder(1)
	cChave := xFilial("SH8")+cKeyOper
	CARGA->( DbSeek(cChave,.T.) )
	If !Empty( aMaq[nElem][1] ) .And. Alltrim( CARGA->H8_RECURSO ) <> Alltrim( aMaq[nElem][1] )
		While CARGA->(!Eof()) .And. CARGA->(H8_FILIAL+H8_OP+H8_OPER+H8_DESDOBR) == cChave
			If xFilial("SH8")+Alltrim( CARGA->H8_RECURSO ) == CARGA->H8_FILIAL+Alltrim( aMaq[nElem][1] )
				Exit
			Endif
			CARGA->(dbSkip())
		Enddo
		If xFilial("SH8")+Alltrim( CARGA->H8_RECURSO ) <> CARGA->H8_FILIAL+Alltrim( aMaq[nElem][1] )
			CARGA->( DbSeek(cChave,.T.) )
		Endif
	Endif
	
	aRec := {}
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbSelectArea("CARGA")            
	
	If SC2->C2_FILIAL+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD # xFilial("SC2")+CARGA->H8_OP
		If !SC2->( dbSeek(xFilial("SC2")+CARGA->H8_OP) )
			C690RecI()
			If !lShowOCR
				Help(" ",1,"C690NAOOP",,CARGA->H8_OP,01,21)
			EndIf
			Return NIL
		EndIf
	EndIf
	If SH1->H1_FILIAL+SH1->H1_CODIGO # xFilial("SH1")+CARGA->H8_RECURSO
		dbSelectArea("SH1")
		dbSeek(xFilial("SH1")+CARGA->H8_RECURSO)
	EndIf
	cRoteiro:=CARGA->H8_ROTEIRO
	If Empty(cRoteiro)
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
		If !Empty(SB1->B1_OPERPAD)
			cRoteiro:=SB1->B1_OPERPAD
		Else
			cRoteiro:="01"
		EndIf
	EndIf
	If SB1->B1_FILIAL+SB1->B1_COD # xFilial("SB1")+SC2->C2_PRODUTO
		If !SB1->( dbSeek(xFilial("SB1")+SC2->C2_PRODUTO) )
			C690RecI()
			If !lShowOCR
				Help(" ",1,"C690NAOPRD",,SC2->C2_PRODUTO,01,11)
			EndIf
			Return NIL
		EndIf
	EndIf
	If !lMaqXQuant
		cOperacao:=IF(!Empty(CARGA->H8_SEQROTA),CARGA->H8_SEQROTA,CARGA->H8_OPER)
		//-- Verifica se o roteiro cadastrado eh referencia de grade (familia)
		If Empty(SG2->G2_REFGRD)
			lDiff := SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC) # xFilial("SG2")+SC2->C2_PRODUTO+cRoteiro+cOperacao
		Else
			lDiff := SG2->(G2_FILIAL+G2_REFGRD+G2_CODIGO+G2_OPERAC) # xFilial("SG2")+PadR(SubStr(SC2->C2_PRODUTO,1,Len(Trim(SG2->G2_REFGRD))),Len(SG2->G2_REFGRD))+cRoteiro+cOperacao					
		EndIf

		If lDiff
			dbSelectArea("SG2")
			If !a630SeekSG2(1,SC2->C2_PRODUTO,xFilial("SG2")+SC2->C2_PRODUTO+cRoteiro+cOperacao) 
				C690RecI()
				If !lShowOCR
					Help(" ",1,"C690NAOOPR",,SC2->C2_PRODUTO+"              "+CARGA->H8_OPER,05,01)
				EndIf
				Return NIL
			EndIf
		EndIf
	EndIf

	If mv_par04 == 1
		nQuant := SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA
	Else
		dbSelectArea("SH6")
		cSeekSH6 := xFilial("SH6")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SC2->C2_PRODUTO+SG2->G2_OPERAC
		dbSeek(cSeekSH6)
		While !Eof() .And. cSeekSH6 == H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC
			nQuant += H6_QTDPROD+H6_QTDPERD
			dbSkip()
		End
		nQuant := SC2->C2_QUANT - nQuant
	Endif

	cDesdobr := Bit2Tempo(CARGA->H8_BITUSO,.T.)

	If CARGA->H8_DESDOBR == "000 "
		cDesdobr += " (Oper. Completa no Rec.)" //" (Oper. Completa no Rec.)"
	ElseIf CARGA->H8_DESDOBR = "000"
		cDesdobr += " ("+Alltrim(Str(At(Substr(CARGA->H8_DESDOBR,4,1),cABC),3))+"o. Parte Oper. Compl.)" //"o. Parte Oper. Compl.)"
	ElseIf Substr(CARGA->H8_DESDOBR,4,1) == " "
		cDesdobr += " ( "+Alltrim(Str(Val(Substr(CARGA->H8_DESDOBR,1,3)),3))+OemToAnsi("o. Desd. desta Opera‡„o)") //"o. Desd. desta Opera‡„o)"
	Else
		cDesdobr += " ("+Alltrim(Str(At(Substr(CARGA->H8_DESDOBR,4,1),cABC),3))+"o. Parte do  ( "+Str(Val(Substr(CARGA->H8_DESDOBR,1,3)),3)+"o. Desd.)" //"o. Parte do  ( "###"o. Desd.)"
	EndIf

	TRB->(dbSeek(CARGA->H8_OP+CARGA->H8_RECURSO+CARGA->H8_OPER))
	If SG2->G2_TPOPER == "2"
		nTemp:=SG2->G2_TEMPAD
	ElseIf SG2->G2_TPOPER == "4"
		nQuantAloc:=nQuant % IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)
		nQuantAloc:=Int(nQuant)+If(nQuantAloc>0,IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)-nQuantAloc,0)
		nTemp := Round(nQuantAloc * ( IIf( SG2->G2_TEMPAD == 0, 1, SG2->G2_TEMPAD) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ) ),5)
	Else
		nTemp:=nQuant * IIf( u_C690HrCt(SG2->G2_TEMPAD) == 0, 1, u_C690HrCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD )
	EndIf


	If mv_par03 == 1
		dbSelectArea("FER")
		If dbSeek(xFilial("SHE")+CARGA->H8_OP+SG2->G2_PRODUTO+SG2->G2_CODIGO+SG2->G2_OPERAC)
			dbSelectArea("SH4")
			If dbSeek(xFilial("SH4")+FER->HE_FERRAM)
				cFerr := FER->HE_FERRAM +' - '+ SH4->H4_DESCRI					
			Else
				If !lShowOCR
					Help(" ",1,"C690NAOFER",,FER->HE_FERRAM,01,14)
				EndIf    
			EndIf
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ aRec comtem as informacaoes da OP no recurso consultado      ³
	//³ aRec[01] := Numero da OP + Item + Sequencia                  ³
	//³ aRec[02] := Roteiro de Operacao                              ³
	//³ aRec[03] := Codigo do Produto + Descricao                    ³
	//³ aRec[04] := Recurso + Descricao                              ³
	//³ aRec[05] := Operacao + Descricao                             ³
	//³ aRec[06] := Quantidade da Alocacao                           ³
	//³ aRec[07] := Data prevista de Termino da OP                   ³
	//³ aRec[08] := Reprogramada                                     ³
	//³ aRec[09] := Data Inicial+ Hora de inicio                     ³
	//³ aRec[10] := Data Final + Hora Final                          ³
	//³ aRec[11] := Setup                                            ³
	//³ aRec[12] := Tempo da Operacao                                ³
	//³ aRec[13] := Tempo Final de Operacao                          ³
	//³ aRec[14] := Desdobramento                                    ³
	//³ aRec[15] := Status da OP                                     ³
	//³ aRec[16] := Indica se usa ferramenta                         ³
	//³ aRec[17] := Tempo de utilizacao da ferramenta                ³		
	//³ aRec[18] := Ferramenta                                       ³		
	//³ aRec[19] := Prioridade da OP                                 ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Aadd(aRec,{CARGA->H8_OP,;  
		CARGA->H8_ROTEIRO,;
		Substr(Alltrim(SB1->B1_COD)+" - "+Alltrim(SB1->B1_DESC),1,65),;
		Substr(Alltrim(SH1->H1_CODIGO)+" - "+Alltrim(SH1->H1_DESCRI),1,65),;
		CARGA->H8_OPER+" - "+SubStr(Alltrim(SG2->G2_DESCRI),1,20),;
		Transform(CARGA->H8_QUANT,PesqPict("CARGA","H8_QUANT",14)),;
		Transform(SC2->C2_DATPRF, PesqPict("SC2", "C2_DATPRF")),;
		Transform(dReprog,PesqPict("SC2", "C2_DATPRF")),;
		Transform(CARGA->H8_DTINI, PesqPict("SH8", "H8_DTINI")) + " - "+	CARGA->H8_HRINI,;
		Transform(CARGA->H8_DTFIM, PesqPict("SH8", "H8_DTFIM")) + " - "+	CARGA->H8_HRFIM,;
		If(lSh8Setup, Bit2Tempo(CARGA->H8_SETUP),Bit2Tempo(U_C690T2B(u_C690HrCt(If(Empty(SG2->G2_FORMSTP), SG2->G2_SETUP, FORMULA(SG2->G2_FORMSTP)))),.T.)),;
		Bit2Tempo(U_C690T2B(nTemp),.T.),;
		If(lSh8TempEnd,Bit2Tempo(CARGA->H8_TEMPEND),"000:00"), ;						
		cDesdobr,;
		CARGA->H8_STATUS,;
		"N",;
		TpUtFer(nTemp),;
		Substr(cFerr,1,65),;
		SC2->C2_PRIOR })

	If Len(aRec) > 0  
		aRec := aClone(aRec[Len(aRec)])   
		For i:=1 To Len(aObjDet)
			If aObjDet[i] <> NIL
				aObjDet[i]:Refresh()
			EndIf
		Next i
	EndIf
Endif      

oTree:BeginUpdate()
oTree:Reset()
oTree:EndUpdate()

If Empty(aRec)
	C690RecI()
Else                 
	//-- Salva posicao SG2
	nRecSG2 := SG2->( RecNo() )
	
	oTree:BeginUpdate()

	dbAddTree oTree PROMPT "Roteiro de Operação:"+" "+aRec[02] RESOURCE "ROTEIRO", "ROTEIRO" CARGO "RAIZ"+SPACE(10) OPEN //"Roteiro de Operação:"

	cSeekWhile	:= "G2_FILIAL+G2_PRODUTO+G2_CODIGO"
	If a630SeekSG2(1,SC2->C2_PRODUTO,xFilial("SG2")+SC2->C2_PRODUTO+cRoteiro,@cSeekWhile)                                
		Do While SG2->( !Eof() .And. Eval(&cSeekWhile) )
			dbAddItem oTree Prompt (SG2->G2_OPERAC + " - " +  SG2->G2_DESCRI) RESOURCE If(cOperacao==SG2->G2_OPERAC,/*"next"*/"br_verde","CLOCK01") CARGO "SH8" + Space(8)
			SG2->( dbSkip() )
		Enddo 
	EndIf
		
	oTree:EndTree()	
	
	oTree:EndUpdate()
	oTree:Refresh()
    
    //-- Restaura SG2
	SG2->( DbGoto(nRecSG2) )
EndIf

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C690Pror  ºAutor  ³Robson Bueno        º Data ³  17/09/2000 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Altera prioridade de OP acionado por menu de contexto no    º±±
±±º          ³CalendGrid                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³oCalendGrid - Objeto CalendGrid                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Pror(oCalendGrid, nTipo)
Local oDlgOP
Local nOption   := 2
Local uVarEdit  := Nil
Local aRetPE	:= Nil
Local uRetPE    := Nil
Local nDifdia   := Nil
Local lFim      := MV_PAR01 == 1
Local lC690PRIOP:= ExistBlock("C690PRIOP")
Local lC690DATPR:= ExistBlock("C690DATPR")
Local cNum      := Nil
Local cItem		:= Nil
Local cSeq      := Nil
Local cSeqPai   := Nil
Local cItemGrd  := Nil
Local dDATPRI	:= Nil
Local dDATPRF	:= Nil
Local nTamSX1   := Len(SX1->X1_GRUPO)
Local lAltEmp   := posicione("SX1", 1, PADR("MTA650",nTamSX1)+"07", "X1_PRESEL") == 1
Local lAltGra   := posicione("SX1", 1, PADR("MTA650",nTamSX1)+"01", "X1_PRESEL") == 1
Local cCampoEdit:= If(nTipo == 1, If(lFim, "C2_DATPRF", "C2_DATPRI"), "C2_PRIOR")
Local x

u_CalendRg(oCalendGrid)

If SC2->(Eof())
	Return(.F.)
Endif	

cNum    := SC2->C2_NUM
cItem   := SC2->C2_ITEM
cSeqPai := SC2->C2_SEQPAI
cSeq 	:= SC2->C2_SEQUEN
cItemGrd:= SC2->C2_ITEMGRD

DEFINE MSDIALOG oDlgOp TITLE "Carga Máquina" FROM 1,1 TO 260,380 PIXEL STYLE 128 //"Carga Máquina"

aExibir := {"C2_NUM", "C2_ITEM", "C2_SEQUEN", "C2_ITEMGRD", "C2_PRODUTO", "C2_QUANT", "C2_DATAJI", "C2_HORAJI"}

If nTipo == 1
	Aadd(aExibir, "C2_PRIOR")
Else  // If nTipo == 2	
	Aadd(aExibir, If(lFim, "C2_DATPRF", "C2_DATPRI"))
Endif

aCampos := {}
For x := 1 to Len(aExibir)
	Aadd(aCampos, {aExibir[x], posicione("SX3", 2, aExibir[x], "x3descric()"), ;
				Transform(SC2->(FieldGet(SC2->(FieldPos(aExibir[x])))), AllTrim(SX3->X3_PICTURE)), Nil, Nil})
Next

For x := 1 to Len(aCampos)
	@ (x * 10), 15 say aCampos[x, 4] Prompt space(40) Of oDlgOp Pixel
	@ (x * 10), 95 say aCampos[x, 5] Prompt space(40) Of oDlgOp Pixel
	aCampos[x, 4]:bSetGet := &("{|u| If(pCount() == 0, aCampos["+Str(x)+",2], aCampos["+Str(x)+",2]:=u)}")
	aCampos[x, 5]:bSetGet := &("{|u| If(pCount() == 0, aCampos["+Str(x)+",3], aCampos["+Str(x)+",3]:=u)}")	
	aCampos[x, 4]:SetText(aCampos[x,2])
	aCampos[x, 5]:SetText(aCampos[x,3])
Next

@ (x * 10), 15 say oSayPrior Prompt posicione("SX3", 2, cCampoEdit, "x3descric()") Of oDlgOp Pixel

cPrior   := SC2->C2_PRIOR
uVarEdit := SC2->(FieldGet(FieldPos(cCampoEdit)))

@ (x * 10), 95 MsGet uVarEdit Picture AllTrim(SX3->X3_PICTURE) Size 50,6 Of oDlgOp Pixel


DEFINE SBUTTON FROM 115,130 TYPE  1 ACTION (oDlgOp:End(), nOption := 1) ENABLE OF oDlgOp PIXEL
DEFINE SBUTTON FROM 115,160 TYPE  2 ACTION (oDlgOp:End(), nOption := 2) ENABLE OF oDlgOp PIXEL

ACTIVATE MSDIALOG oDlgOp CENTER

If (lAlterou := nOption == 1)

    If nTipo == 1
		nDifDia := uVarEdit - SC2->(FieldGet(FieldPos(cCampoEdit)))
		If lFim
			dDATPRI := SC2->C2_DATPRI + nDifDia
			dDATPRF := uVarEdit
		Else
			dDATPRI := uVarEdit
			dDATPRF := SC2->C2_DATPRF + nDifDia
		Endif
		If lC690DATPR
			aRetPE := ExecBlock("C690DATPR",.F.,.F.,{SC2->C2_NUM,SC2->C2_ITEM,SC2->C2_SEQUEN,dDATPRI,dDATPRF,lFim})
			If Valtype(aRetPE) == "A" .And. Len(aRetPE)==2
				If Valtype(aRetPE[1])=="D" .And. Valtype(aRetPE[2])=="D" .And. aRetPE[1] <= aRetPE[2]
					dDATPRI := aRetPE[1]
					dDATPRF := aRetPE[2]
				EndIf
			EndIf
		EndIf
		RecLock("SC2", .F.)
		SC2->C2_DATPRI := dDATPRI
		SC2->C2_DATPRF := dDATPRF
		MsUnlock()
		If lAltEmp
			u_C690Emp()
		Endif
		dbSkip()
		Do While !Eof() .And. SC2->(C2_FILIAL+C2_NUM+C2_ITEM) == xFilial("SC2")+cNum+cItem .And. C2_SEQUEN > cSeq .And. C2_SEQPAI > cSeqPai

			If !lAltGra .And. SC2->C2_ITEMGRD!=cItemGrd
				dbSkip()
				loop
			EndIf

			If Empty(C2_DATRF)
				RecLock("SC2",.F.)
				Replace C2_DATPRI With C2_DATPRI + nDifDia
				Replace C2_DATPRF With C2_DATPRF + nDifDia
				MsUnlock()
			EndIf
			If lAltEmp
				u_C690Emp()
			Endif
			dbSkip()
		EndDo
	Else
		dbSelectArea("SC2")
		dbSeek(xFilial("SC2")+cNum+cItem, .T.)	
		While !Eof() .And. C2_FILIAL+C2_NUM+C2_ITEM == xFilial("SC2")+cNum+cItem
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para Alterar a prioridade³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
			If lC690PRIOP
				uRetPE := ExecBlock("C690PRIOP",.F.,.F.,{C2_NUM,C2_ITEM,C2_SEQUEN,uVarEdit}) 
				If Valtype(uRetPE) <> "C"
					uRetPE  := uVarEdit
				EndIf
		   	EndIf 
			RecLock("SC2",.F.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava Prioridade nas OPs Intermed.                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lC690PRIOP
				Replace C2_PRIOR With uRetPE
			Else
				Replace C2_PRIOR With uVarEdit
			EndIf	
			MsUnLock() 
			dbSkip()
		Enddo
	Endif
Endif
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalendReg ºAutor  ³Robson Bueno /Erike º Data ³  17/09/2000 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Posiciona SC2 de acordo com a operacao selecionada no       º±±
±±º          ³CalendGrid                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³oCalendGrid - Objeto CalendGrid                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function u_CalendRg(oCalendGrid)
Local nPos := u_C690ASBX(aCalendGrid,'{|x| x[nMedia][2]+x[nMedia][3]+x[nMedia][4] == "'+StrZero(oCalendGrid:nLineAtu,8)+StrZero(oCalendGrid:nIntervIni,8)+StrZero(oCalendGrid:nIntervFim,8)+'"}')

If nPos > 0 .And. Empty(aCalendGrid[nPos, 7])
	CARGA->(dbGoto(CARGA->(LastRec()) + 1))
	SC2->(dbGoto(SC2->(LastRec()) + 1))
	Return(.F.)
Endif

If nPos = 0
	CARGA->(dbGoto(CARGA->(LastRec()) + 1))
Else
	aSavCarga := {CARGA->(IndexOrd()), CARGA->(RecNo()), Alias()}
	dbSelectArea("CARGA")
	dbSetOrder(1)
	If dbSeek(xFilial("SH8") + aCalendGrid[nPos, 7], .T.)
		aSavCarga[2] := CARGA->(RecNo())
		dbSetOrder(1)
		SC2->(dbSeek(xFilial("SC2") + CARGA->H8_OP))
	Endif	
	dbSetOrder(aSavCarga[1])
	dbGoto(aSavCarga[2])
	dbSelectArea(aSavCarga[3])
Endif
Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C690RMnu  ºAutor  ³Robson Bueno /Erike º Data ³  18/04/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Apresenta menu de contexto ao acionar o botao direito do    º±±
±±º          ³Mouse sobre determinada operacao representada no grafico    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690RMnu(aCalendGrid,cLin,cIni,cFim)
Local nPos := u_C690ASBX(aCalendGrid,'{|x| x[nMedia][2]+x[nMedia][3]+x[nMedia][4] == "'+cLin+cIni+cFim+'"}')
Return (nPos > 0 .And. !aCalendGrid[nPos, 8])


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C690Clnd  ºAutor  ³Robson Bueno        º Data ³  18/04/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Transforma os dados binarios referente calendario do SH7    º±±
±±º          ³para o formato hora (hh:mm) e os retorna em um array        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Clnd(cCalend)
Local aArray := {}, aRet := {}
Local nTamanho
Local cAloc, x, y
Local cAlias  := Alias()
Local nRecSH7 := SH7->(RecNo())
Local cHoraFim
dbSelectArea("SH7")
If ! dbSeek(xFilial("SH7")+cCalend)
	dbGoto(nRecSH7)
	dbSelectArea(cAlias)
	Return(aArray)
Endif
cAloc    := Bin2Str(SH7->H7_ALOC)
nTamanho := Len(cAloc) / 7
Aadd(aArray, "")
While Len(cAloc) > 0
	Aadd(aArray, SubStr(cAloc, 1, nTamanho) + " ")
	cAloc := SubStr(cAloc, nTamanho + 1)
Enddo
aArray[1] := aArray[8]
aDel(aArray, 8)
aSize(aArray, 7)
For x := 1 to Len(aArray)
	nPos1 := 0
	nPos2 := 0
	Aadd(aRet, {x})
	For y := 1 to Len(aArray[x])
		If substr(aArray[x], y, 1) == "x" .and. nPos1 = 0
			nPos1 := y
		ElseIf substr(aArray[x], y, 1) == " " .And. nPos1 # 0
			nPos2 := y
			If Len(aRet[Len(aRet)]) < 10
				Aadd(aRet[Len(aRet)], Bit2Tempo(nPos1-1))
				cHoraFim := SubStr(Bit2Tempo(nPos2-1), 3) + ":00"
				cHoraFim := C690Sec2Time(Secs(cHoraFim) - 60)
				Aadd(aRet[Len(aRet)], cHoraFim)
			Endif
			nPos1 := 0
		Endif
	Next
	aSize(aRet[Len(aRet)], 11)
Next
dbGoto(nRecSH7)
dbSelectArea(cAlias)
Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C690Exce  ºAutor  ³Robson Bueno        º Data ³  18/04/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Transforma os dados binarios referente a excecao de         º±±
±±º          ³calendario e retorna em array                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Exce(cStrBin)
Local cStr     := Bin2Str(cStrBin) + " "
Local aRet     := {}
Local nPos1    := 0, nPos2 := 0
Local cHoraFim
Local y

For y := 1 to Len(cStr)
	If substr(cStr, y, 1) == "x" .and. nPos1 = 0
		nPos1 := y
	ElseIf substr(cStr, y, 1) == " " .And. nPos1 # 0
		nPos2 := y
		If Len(aRet) < 10
			Aadd(aRet, substr(Bit2Tempo(nPos1-1),3))
			cHoraFim := SubStr(Bit2Tempo(nPos2-1), 3) + ":00"
			cHoraFim := C690Sec2Time(Secs(cHoraFim) - 60)
			Aadd(aRet, cHoraFim)
		Endif
		nPos1 := 0
	Endif
Next
aSize(aRet, 10)
Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATC690A  ºAutor  ³Robson Bueno        º Data ³  17/05/2001 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Checa a existencia ou nao do project                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³,T. para usar o project ou .f. exibir no Protheus           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SelePrj
Local oDlg, nOpt :=2, cCombo1 := "MsProject 2000"
Local lProject
Local nCombo := 1
Local aItems := {"Protheus", "Protheus Simplificado"} // "Protheus Simplificado"
Local aRet   := {1, 4, 3} // Valores assumidos para mv_par23

If mv_par23 == 2 .Or. mv_par23 == 3
	If GetRemoteType() != REMOTE_LINUX .And. (lProject := ApOleClient( 'MsProject' ))
		Aadd(aItems, "MsProject 2000")
	Endif
Endif

If mv_par23 == 1 .Or. mv_par23 == 4 .Or. (mv_par23 == 3 .And. lProject)
	Return(mv_par23 == 3 .And. lProject)
Endif	

DEFINE MSDIALOG oDlg TITLE "Carga Máquina" From 145,0 To 230,300 OF oMainWnd PIXEL //"Carga Máquina"
@ 10,06 SAY "Saída do Gráfico:" SIZE 60,8 OF oDlg PIXEL //"Saída do Gráfico:"
@ 08,55 MSCOMBOBOX oCombo1 VAR cCombo1 ITEMS aItems SIZE 80,34 Of oDlg Pixel
DEFINE SBUTTON FROM 30,120 TYPE 1 ACTION (nCombo := oCombo1:nAt, oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
If nCombo > 0 .And. nCombo <= Len(aItems)
	mv_par23 := aRet[nCombo]
Endif
Return(mv_par23 == 3)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATC690A  ºAutor  ³Robson Bueno        º Data ³  17/05/2001 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Transforma string de hora em um numero (total de minutos)   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³String tipo hora ("10:40" ou "10:40:00")                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Numero de minutos da string fornecida                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HrToBit(cHora)
Return(If(Empty(cHora), 0, Val(SubStr(cHora, 1, 2)) * 60 + Val(SubStr(cHora, 3, 2))))

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ C690Emp    ³ Autor ³ Robson Bueno        ³ Data ³ 20/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Troca a data do empenho na alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690Emp()
Local aSavArea := {SD4->(RecNo()), SD4->(IndexOrd()), Alias()}
dbSelectArea("SD4")
dbSetOrder(2)
If dbSeek(xFilial("SD4")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
	Do While !Eof() .And. SD4->(D4_FILIAL + D4_OP) == xFilial("SD4") + SC2->(C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+C2_ITEMGRD)
		Reclock("SD4",.F.)
		SD4->D4_DATA := SC2->C2_DATPRI
		MsUnlock()
		dbSkip()
	EndDo
EndIf
dbGoto(      aSavArea[1])
dbSetOrder(  aSavArea[2])
dbSelectArea(aSavArea[3])
Return(.T.)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ c690PrTo   ³ Autor ³ Robson Bueno        ³ Data ³ 12/02/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica se a Operacao foi totalmente produzida            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function c690PrTo(cOp, cOperacao)
Local aArea    := {Alias(), SC2->(GetArea()), SH6->(GetArea())}
Local cproduto := Nil
Local cSeek    := Nil
Local lRet     := .T.
dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2") + cOp)
cProduto := SC2->C2_PRODUTO
RestArea(aArea[2])
dbSelectArea("SH6")
dbSetOrder(1)
If dbSeek(cSeek:=xFilial("SH6")+cOp+cProduto+cOperacao)
	Do While ! Eof() .And. lRet .And. SH6->(H6_FILIAL + H6_OP + H6_PRODUTO + H6_OPERAC) == cSeek
		If H6_PT == "T"
			lRet:=.F.
		EndIf
		dbSkip()
	EndDo
EndIf
RestArea(aArea[3])
dbSelectArea(aArea[1])
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690DlRg    ³ Autor ³Rodrigo A Sartorio   ³ Data ³ 14/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Apaga os registros da filial de processamento no SH8       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
Static Function C690DlRg()

#IFDEF TOP
	Local nx:=0
	Local nMin:=0,nMax:=0
	Local cQuery:="",cChave:=""
	Local cAliasSH8:="MATC690H8"
#ENDIF

#IFNDEF TOP
dbSeek(xFilial("SH8"))
While !EOF() .And. H8_FILIAL == xFilial("SH8")
	Reclock("SH8",.F.)
	dbdelete()
	MsUnlock()
	dbSkip()
End
#ELSE
	cQuery := "SELECT MIN(R_E_C_N_O_) MINRECNO,"
	cQuery += "MAX(R_E_C_N_O_) MAXRECNO "
	cQuery += "FROM "+RetSqlName("SH8")+" "
	cQuery += "WHERE H8_FILIAL='"+xFilial("SH8")+"' AND "
	cQuery += "D_E_L_E_T_=' '"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSH8)
	nMax := (cAliasSH8)->MAXRECNO
	nMin := (cAliasSH8)->MINRECNO
	dbCloseArea()
	dbSelectArea("SH8")
	cQuery := "DELETE FROM "
	cQuery += RetSqlName("SH8")+" "	
	cQuery += "WHERE H8_FILIAL='"+xFilial("SH8")+"' AND "
	For nX := nMin To nMax STEP 1024
		cChave := "R_E_C_N_O_>="+Str(nX,10,0)+" AND R_E_C_N_O_<="+Str(nX+1023,10,0)+""
		TcSqlExec(cQuery+cChave)
	Next nX
#ENDIF
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ASHICaln    ³ Autor ³Marcelo A. Iuspa     ³ Data ³ 13/11/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna calendario do recurso na data especificada         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
User Function ASHICaln(cRecurso, dData, lCalend, lRelease)
Static aRecCalen := {}

Local aSavAre    := {}
Local nSeek      := 0
Local dDatIni    := Nil
Local dDatFin    := Nil
Local nMvPrecisa := SuperGetMV("MV_PRECISA",, 4)
Local cCalend    := ""
Local nPosCal    := Nil

Default lRelease := .F.
Default lCalend  := .F.

If lRelease
	aRecCalen := {}
	Return(.T.)
Endif

If (nSeek := aScan(aRecCalen, {|z| z[1] == cRecurso .And. z[2] <= dData .And. dData <= z[3]})) == 0
	aSavAre := {SH1->(GetArea()), SH7->(GetArea()), SHI->(GetArea()), GetArea()}
	dbSelectArea("SHI")
	If ! dbSeek(xFilial("SHI") + cRecurso)
		SH1->(dbSeek(xFilial("SH1") + cRecurso))
		SH7->(dbSeek(xFilial("SH7") + SH1->H1_CALEND))
		dDatIni := ctod("01/01/" + StrZero(Mod(Set(5)    , 100), 2))
		dDatFin := ctod("12/12/" + StrZero(Mod(Set(5) - 1, 100), 2)) + 19
		Aadd(aRecCalen, {cRecurso, dDatIni, dDatFin, SH1->H1_CALEND, {}})
	Else
		dbSetOrder(2)
		If dbSeek(xFilial("SHI") + cRecurso + Dtos(dData))
			SH7->(dbSeek(xFilial("SH7") + SHI->HI_CALEND))
			Aadd(aRecCalen, {cRecurso, SHI->HI_DTVGINI, SHI->HI_DTVGFIM, SHI->HI_CALEND, {}})
		Else 
			dbSeek(xFilial("SHI") + cRecurso)
			While cRecurso == HI_RECURSO 
				If HI_DTVGINI <= dData .And. dData <= HI_DTVGFIM
					SH7->(dbSeek(xFilial("SH7") + SHI->HI_CALEND))
		   			Aadd(aRecCalen, {cRecurso, SHI->HI_DTVGINI, SHI->HI_DTVGFIM, SHI->HI_CALEND, {}})
		   		EndIf
		   		SHI->(DbSkip())
		   	EndDo
		EndIf  
		If Len (aRecCalen) <= 0
			SH1->(dbSeek(xFilial("SH1") + cRecurso))
			SH7->(dbSeek(xFilial("SH7") + SH1->H1_CALEND))
			dDatIni := ctod("01/01/" + StrZero(Mod(Set(5)    , 100), 2))
			dDatFin := ctod("12/12/" + StrZero(Mod(Set(5) - 1, 100), 2)) + 19
			Aadd(aRecCalen, {cRecurso, dDatIni, dDatFin, SH1->H1_CALEND, {}})
		EndIf
	Endif
	nSeek := Len(aRecCalen)
	cCalend := SH7->H7_ALOC
	If ! lCalend
		If mv_par20 == 1
			If (nPosCal := ASCAN(aSeleCal,{|x| x[1] == SH7->H7_CODIGO})) > 0
				SH7->(dbSeek(xFilial("SH7") + aSeleCal[nPosCal, 3]))
				cCalend := SH7->H7_ALOC
				aRecCalen[nSeek, 4] := SH7->H7_CODIGO
			Endif
		Endif		
		NotBit(@cCalend, ( 24 * 7 * nMvPrecisa ) / 8 )
		nPerDia := ( 24 * nMvPrecisa ) / 8   // Periodos em um dia (binario)
		aRecCalen[nSeek, 5] := Array(7)
		aRecCalen[nSeek, 5, 2] := Substr(cCalend, 1 , nPerDia )
		aRecCalen[nSeek, 5, 3] := Substr(cCalend, 1 + ( nPerDia * 1 ) , nPerDia )
		aRecCalen[nSeek, 5, 4] := Substr(cCalend, 1 + ( nPerDia * 2 ) , nPerDia )
		aRecCalen[nSeek, 5, 5] := Substr(cCalend, 1 + ( nPerDia * 3 ) , nPerDia )
		aRecCalen[nSeek, 5, 6] := Substr(cCalend, 1 + ( nPerDia * 4 ) , nPerDia )
		aRecCalen[nSeek, 5, 7] := Substr(cCalend, 1 + ( nPerDia * 5 ) , nPerDia )
		aRecCalen[nSeek, 5, 1] := Substr(cCalend, 1 + ( nPerDia * 6 ) , nPerDia )
		aEval(aSavAre, {|z| RestArea(z)})
	Endif
Endif
If lCalend
	Return(aRecCalen[nSeek, 4])
Endif
Return(aRecCalen[nSeek, 5])	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690D2B     ³ Autor ³Robson Bueno         ³ Data ³ 14/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Converte a data fornecida em bits de acordo com a precisao ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
User Function C690D2B(dData)
Local nPrecisa := SuperGetMV("MV_PRECISA")
Local nBit     := (dData - mv_par15) * nPrecisa * 24
Return(nBit)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690B2D     ³ Autor ³Robson Bueno         ³ Data ³ 14/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Converte bit fornecido em data de acordo com a precisao    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
User Function C690B2D(nBit)
Local nPrecisa := SuperGetMV("MV_PRECISA")
Local dData    := mv_par15 + ( nBit / 24 / nPrecisa)
Return(dData)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690Lnn     ³ Autor ³Robson Bueno         ³ Data ³ 28/10/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna se filtra por linha de producao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
User Function C690Lnn()
Local lRet := .T.
Static lFiltraLinha := Nil

If lFiltraLinha == Nil
	lFiltraLinha := (SC2->(FieldPos("C2_LINHA")) > 0) .And. (ValType(mv_par25) + ValType(mv_par26) == "CC")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abaixo chumbado para teste. Depois tratar pelo MV_PARXX      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lFiltraLinha
	lRet := SC2->C2_LINHA >= mv_par25 .And. SC2->C2_LINHA <= mv_par26
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690ArCr    ³ Autor ³ Robson Bueno        ³ Data ³ 18/10/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna array de cores de acordo com MV_CORPCP             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ aCores := C690ArCr()                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lRgb (Se .T. retorna numero RGB das cores / Default .F.    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690ArCr(lRgb)
Local cCores := Alltrim(GetMV("MV_CORPCP"))
Local aCores := {}
Local nPos   := 0

Default lRgb := .F.

If Empty(cCores)
	Help(" ",1,"C690CORPCP")
	Return({})
EndIf
cCores := IIf( Right(cCores,1) == "/", Left(cCores,Len(cCores)-1), cCores )
cCores := IIf( Left(cCores,1) == "/", Right(cCores,Len(cCores)-1), cCores )

While !Empty(cCores)
	nPos := At("/",cCores)
	If nPos > 0
		Aadd(aCores,Substr(cCores,1,nPos-1))
		cCores := Right(cCores,Len(cCores)-nPos)
	ElseIf !Empty(cCores)
		Aadd(aCores,cCores)
		cCores := ""
	EndIf
End

If lRgb
	aEval(aCores, {|z,w| aCores[w] := u_C690Cor(z)})
Endif

Return(aCores)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³C690CrOp    ³ Autor ³ Robson Bueno        ³ Data ³ 18/10/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna cor da OP informada baseada em MV_CORPCP e MV_PAR06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ cCor := C690CrOp(cOp)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cOp - OP a ter a cor retornada/Nil reseta variaveis static ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690CrOp(cOp)
Static aCores  := Nil
Static aCorOp  := Nil
Static nIndCor := Nil
Local aArea    := Nil
Local nPos     := Nil
Local cCor     := Nil

If cOp == Nil
	aCorOp  := {}
	aCores  := u_C690ArCr(.T.)
	nIndCor := 1
	Return(.T.)
Endif

If (nPos := aScan(aCorOp, {|z| z[1] == cOp})) > 0
	Return(aCorOp[nPos, 2])
Endif

aArea := {GetArea(), SC2->(GetArea())}
SC2->(dbSetOrder(1))
SC2->(dbSeek(xFilial("SC2") + cOp))
If mv_par06 == 2 // OPs Sacr. em Verde e Normais em Azul
	If SC2->C2_STATUS == "S"
		cCor := u_C690Cor("G")
	Else
		cCor := u_C690Cor("B")
	Endif
Else
	If SC2->C2_STATUS == "S"
		cCor := u_C690Cor("R")
	Else
		cCor := aCores[nIndCor ++]
	Endif
Endif

If nIndCor > Len(aCores)
	nIndCor := 1
Endif

Aadd(aCorOp, {cOp, cCor})

RestArea(aArea[2])
RestArea(aArea[1])

Return(cCor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TpUtFer     ³ Autor ³ Robson Bueno Silva  ³ Data ³ 31/08/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o tempo de utilizacao da ferramenta                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nTemp - Tempo de alocacao do recurso sem setup             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
OBSERVACAO: As areas SG2 e CARGA devem estar possicionadas.
*/
Static Function TpUtFer(nTemp)
Local nTempoTRB := 0

If lSh8Setup
	nTempoTRB := CARGA->H8_SETUP+U_C690T2B(nTemp)
Else
	nTempoTRB := U_C690T2B(nTemp+u_C690HrCt(If(Empty(SG2->G2_FORMSTP), SG2->G2_SETUP, FORMULA(SG2->G2_FORMSTP))))
EndIf

If lSh8TempEnd
	nTempoTRB += CARGA->H8_TEMPEND
EndIf

Return If(Empty(nTempoTRB),"00:00",Bit2Tempo(nTempoTRB))



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GtPrdOp     ³ Autor ³ Robson Bueno Silva  ³ Data ³ 16/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna os produtos e as ops definidas no range do filtro  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GtPrdOp()
Local lQuery 	:= .F.
Local cQuery 	:= ""
#IFDEF TOP
Local cIndSC2	:= ""  
#ENDIF
Local cAliasTop := "SC2"
Local cTmp		:= ""	             
Local nInd		:= 0
Local aArea		:= GetArea()
Local cNumDe	:= Substr(mv_par09,1,Len(SC2->C2_NUM))
Local cIteDe	:= Substr(mv_par09,Len(SC2->C2_NUM)+1,Len(SC2->C2_ITEM))
Local cSeqDe	:= Substr(mv_par09,Len(SC2->C2_NUM)+Len(SC2->C2_ITEM)+1,Len(SC2->C2_SEQUEN))
Local cNumAte	:= Substr(mv_par10,1,Len(SC2->C2_NUM))
Local cIteAte	:= Substr(mv_par10,Len(SC2->C2_NUM)+1,Len(SC2->C2_ITEM))
Local cSeqAte	:= Substr(mv_par10,Len(SC2->C2_NUM)+Len(SC2->C2_ITEM)+1,Len(SC2->C2_SEQUEN))
Local cTipoOp	:= If(mv_par21==1," F",If(mv_par21==2,"P"," FP"))
Local cItGrDe	:= Right(mv_par09,Len(SC2->C2_ITEMGRD))
Local cItGrAte	:= Right(mv_par10,Len(SC2->C2_ITEMGRD))
Local cStatus	:= If(mv_par05==1,"N ","NS ")
Local aRet		:= {}

dbSelectArea("SC2")
              
#IFDEF TOP
	If TcSrvType()<>"AS/400"
		lQuery := .T.
		cAliasTop := CriaTrab(NIL,.f.)
		cQuery := "SELECT SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SC2.C2_ITEMGRD, SC2.C2_PRODUTO, SC2.C2_ROTEIRO,SC2.R_E_C_N_O_ C2REC"
		cQuery += "FROM "+RetSqlName("SC2")+" SC2 "
		cQuery += "WHERE SC2.C2_FILIAL='"+xFilial("SC2")+"' AND "
		cQuery += "SC2.C2_DATRF = '"+Space(08)+"' AND "
		cQuery += "SC2.C2_QUJE+SC2.C2_PERDA < SC2.C2_QUANT AND " 
		If mv_par05==1
			cQuery += "( SC2.C2_STATUS ='N' OR SC2.C2_STATUS = ' ' ) AND "
		EndIf
		cQuery += "SC2.C2_DATPRF >= '"+DTOS(mv_par07)+"'  AND "
		cQuery += "SC2.C2_DATPRF <= '"+DTOS(mv_par08)+"'	AND "
		cQuery += "SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD >= '" + cNumDe +cIteDe +cSeqDe +cItGrDe  + "' AND "
		cQuery += "SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD <= '" + cNumAte+cIteAte+cSeqAte+cItGrAte + "' AND "
		cQuery += "SC2.C2_PRODUTO >= '"+mv_par11+"' AND "
		cQuery += "SC2.C2_PRODUTO <= '"+mv_par12+"' AND "
		cQuery += "SC2.C2_TPOP IN("+If(mv_par21==1,"' ','F'",If(mv_par21==2,"'P'","' ','F','P'"))+") AND "		
		cQuery += "SC2.D_E_L_E_T_=' '"
		cQuery += "ORDER BY "+SqlOrder(SC2->(IndexKey(1)))
		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
		aEval(SC2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasTop,x[1],x[2],x[3],x[4]),Nil)})
	EndIf
#ELSE
	cTmp:=CriaTrab(,.F.)		
	dbSelectArea("SC2")
	dbSetOrder(1)
	cQuery := 'DTOS(C2_DATRF) == "'+Space(08)+'"'
	cQuery += '.And.C2_QUJE+C2_PERDA < C2_QUANT .And. C2_STATUS $ "'+cStatus+'"'
	cQuery += '.And.DTOS(C2_DATPRF) >= "'+DTOS(mv_par07)+'" .And. DTOS(C2_DATPRF) <= "'+DTOS(mv_par08)+'"'
	cQuery += '.And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD >= "' + cNumDe +cIteDe +cSeqDe +cItGrDe  + '"'
	cQuery += '.And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= "' + cNumAte+cIteAte+cSeqAte+cItGrAte + '"'
	cQuery += '.And.C2_PRODUTO >= "'+mv_par11+'" .And. C2_PRODUTO <= "'+mv_par12+'" .And. C2_TPOP $ "'+cTipoOp+'"'

	IndRegua("SC2",cTmp,IndexKey(),,cQuery)
	nInd := RetIndex("SC2")
	dbSetIndex(cTmp+OrdBagExt())
	dbSetOrder(nInd+1)
	dbGotop()
#ENDIF

dbSelectArea(cAliasTop)
While !Eof()
	Aadd(aRet,{C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD,C2_PRODUTO,C2_ROTEIRO })	
	dbSkip()
End

dbSelectArea(cAliasTop)
If lQuery
	dbCloseArea()
Else
	RetIndex("SC1")
	dbClearFilter()
	Ferase(cTmp+OrdBagExt())
EndIf

RestArea(aArea)
Return aRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LegOp     ³ Autor ³ Robson Bueno Silva    ³ Data ³ 18/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Apresenta legenda em tela com as ops e suas cores, conforme³±±
±±³          ³ definicao do parametro MV_CORPCP.						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Pr‚-      ³ O parametro MV_PAR06 de estar configurado para cada op pos-³±±
±±³Requisitos³ suir uma cor.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LegOp(aOps)
Local oDlg,oSbr,oSay,oPnl
Local bBlock
Local nI
Local nLin := -5

DEFINE FONT oArialBold NAME "Arial" SIZE 0, -13 BOLD

DEFINE DIALOG oDlg TITLE "STR0174" FROM  0,0 TO 200,175 PIXEL
	@ 00,00 SCROLLBOX oSbr VERTICAL SIZE 84,205 OF oDlg BORDER	
	oSbr:Align := CONTROL_ALIGN_ALLCLIENT
	
	DbSelectArea("aCorOPs")                                      
	For nI:=1 To Len(aOps)
		If DbSeek(aOps[nI])
			bBlock:= &("u_MsVwOP('"+aOps[nI]+"')")
			nLin += 10                                                             
			TPanel():New(nLin-1,04,"",oSbr,, .T., .T.,,RGB(235,235,235),75,12,.T.,.T. )
			
			oPnl := TPanel():New(nLin,05,"",oSbr,, .T., .T.,,u_C690Cor(COR),09,09,.T.,.T. )
			oPnl:bLClicked:= bBlock

   			oSay := TSay():New( nLin+1,20, NIL,oSbr,,oArialBold,,,,.T.,,, 50, 10)		
   			oSay:cCaption := aOps[nI]  
   			oSay:bLClicked:= bBlock
   			
   		EndIf
	Next nI
ACTIVATE DIALOG oDlg CENTERED

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ViewOp    ºAutor  ³Robson Bueno Silva  º Data ³  17/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Permite vizualizr o cadastro de uma ordem de producao       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATC690A                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ViewOp(cOp)
Local aArea := GetArea()
Private cCadastro := "Cadastro de Ordens de Producao" //"Cadastro de Ordens de Producao"

DbSelectArea("SC2")
DbSetOrder(1)
If MsSeek(xFilial("SC2")+cOp)
	A650View("SC2",SC2->( Recno() ),2)
EndIf

RestArea(aArea)
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³C690RecI  ºAutor  ³Robson Bueno Silva  º Data ³  17/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa array aRec com valores default                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATC690A                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C690RecI()
Local nI
aRec := Array(20)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aRec comtem as informacaoes da OP no recurso consultado      ³
//³ aRec[01] := Numero da OP + Item + Sequencia                  ³
//³ aRec[02] := Roteiro de Operacao                              ³
//³ aRec[03] := Codigo do Produto + Descricao                    ³
//³ aRec[04] := Recurso + Descricao                              ³
//³ aRec[05] := Operacao + Descricao                             ³
//³ aRec[06] := Quantidade da Alocacao                           ³
//³ aRec[07] := Data prevista de Termino da OP                   ³
//³ aRec[08] := Reprogramada                                     ³
//³ aRec[09] := Data Inicial+ Hora de inicio                     ³
//³ aRec[10] := Data Final + Hora Final                          ³
//³ aRec[11] := Setup                                            ³
//³ aRec[12] := Tempo da Operacao                                ³
//³ aRec[13] := Tempo Final de Operacao                          ³
//³ aRec[14] := Desdobramento                                    ³
//³ aRec[15] := Status da OP                                     ³
//³ aRec[16] := Indica se usa ferramenta                         ³
//³ aRec[17] := Tempo de utilizacao da ferramenta                ³		
//³ aRec[18] := Ferramentas Utilizada                            ³		
//³ aRec[19] := Prioridade da OP                                 ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRec[01]	:= Space(13)
aRec[02]	:= Space(2)
aRec[03]	:= " "
aRec[04]	:= " "
aRec[05]	:= " "
aRec[06]	:= 0
aRec[07]	:= CTOD("")
aRec[08]	:= CTOD("")
aRec[09]	:= "  /  /   - 00:00"
aRec[10]	:= "  /  /   - 00:00"
aRec[11]	:= 0
aRec[12]	:= 0
aRec[13]	:= 0
aRec[14]	:= 0
aRec[15]	:= " "
aRec[16]	:= "N"
aRec[17]	:= "00:00"    
aRec[18]	:= " "
aRec[19]	:= Space(Len(SC2->C2_PRIOR))

//-- Atualiza objetos
For nI:=1 To Len(aObjDet)
	If aObjDet[nI] <> NIL
		aObjDet[nI]:Refresh()
	EndIf
Next nI

Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³C690ASBX  ³ Autor ³ Robson Bueno Silva    ³ Data ³ 18/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua uma busca bin ria em um Array Multidimencional	  ³±±
±±³          ³ (substitui o Ascan)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Pr‚-      ³ Os dados do Array devem estar ordenados e serem unicos.    ³±±
±±³Requisitos³ (caso nao sejam unicos, esta funcao s¢ serve para detectar ³±±
±±³          ³ a existencia, pois nao tr s na posicao do primeiro).       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function C690ASBX(aArray,cBlocCond)
Local nMedia	:= 0
Local nPosIni	:= 0
Local nPosFim	:= 0
Local bCondMenor
Local bCondMaior
                
If !Empty(aArray) .And. !Empty(cBlocCond)
	bCondMenor := &(StrTran(cBlocCond,"==",">"))
	bCondMaior := &(StrTran(cBlocCond,"==","<"))
	
	nPosIni := 1
	nPosFim := Len(aArray)
	
	If nPosIni <= nPosFim
		While nPosIni <= nPosFim
			nMedia := Int( ( nPosIni + nPosFim ) / 2 )
			If Eval(bCondMenor,aArray)
				nPosFim := nMedia - 1
			ElseIf Eval(bCondMaior,aArray)
				nPosIni := nMedia + 1
			Else
				Exit
			EndIf
		End
	EndIf
EndIf	
Return IIf( nPosIni <= nPosFim , nMedia , 0 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MsVwOP    ³ Autor ³ Felipe Nunes Toledo   ³ Data ³ 03/08/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta bloco de codigo para visualizacao das OPs            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC690                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MsVwOP(cNumOP)
Return bReturn := {|| MsgRun('Processando ...', 'Aguarde', {|| ViewOp(cNumOP) })} //'Processando ...'##'Aguarde'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C690AjSb  ºAutor  ³Andre Anjos	     º Data ³  16/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que garante a correta sobreposicao em casos onde a  º±±
±±º          ³ operacao a sobrepor terminaria antes da sobreposta.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cProduto: Produto em alocacao.							  º±±
±±º			 ³ cRoteiro: Roteiro em alocacao.							  º±±
±±º			 ³ cOperacao: Operacao em alocacao.							  º±±
±±º			 ³ nTemp: Tempo de sobreposicao da operacao.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nTempSob: Tempo de sobreposicao da operacao.				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATC690A                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C690AjSb()
Local aAreaAtu := GetArea()
Local aAreaSG2 := SG2->(GetArea())
Local aAreaSH8 := CARGA->(GetArea())
Local nTempAnt := 0
Local nSobMin  := 0
Local nTempSob := 0

dbSelectArea("SG2")
dbSetOrder(1)
dbSeek(xFilial("SG2")+TRB->(PRODUTO+CODIGO+OPERAC))
dbSkip(-1) //Pega operacao anterior
If Empty(SG2->G2_FORMSTP)
                nSetup := SG2->G2_SETUP
Else
                nSetup := Formula(SG2->G2_FORMSTP)
EndIf

dbSelectArea("CARGA")
dbSetOrder(1)
dbSeek(xFilial("SH8")+TRB->(OPNUM+ITEM+SEQUEN+ITEMGRD)+SG2->G2_OPERAC)
While !EOF() .And. CARGA->(H8_FILIAL+H8_OP+H8_OPER) == xFilial("SH8")+TRB->(OPNUM+ITEM+SEQUEN+ITEMGRD)+SG2->G2_OPERAC
                nTempAnt += Int(CARGA->H8_BITUSO / SuperGetMV("MV_PRECISA",.F.,4)) + ((CARGA->H8_BITUSO/nPrecisao) - Int(CARGA->H8_BITUSO/nPrecisao))
                dbSkip()
End

nSobMin := Max(SG2->(u_C690HrCt(G2_TEMPAD)/G2_LOTEPAD) + u_C690HrCt(nSetup),(60/SuperGetMV("MV_PRECISA",.F.,4))/60)

//Calcula tempo de sobreposicao de acordo com a operacao anterior
Do Case
                Case TRB->TPSOBRE == "1" //Sobreposicao por qtde
                               nTempSob := SG2->(u_C690HrCt(G2_TEMPAD)/G2_LOTEPAD)
                Case TRB->TPSOBRE == "2" //Sobreposicao por percentual  
                			   if nTempAnt == 0 
                			      nTempAnt := 1
                			   EndIf
                               nTempSob := (nTempAnt * TRB->TEMPSOB)/100
                			   If mv_par01 == 2
                			      nSobMin:=nTempSob
                			   EndIf
                Case TRB->TPSOBRE == "3" //Sobreposicao por tempo
                               nTempSob := TRB->TEMPSOB
EndCase

RestArea(aAreaSH8)
RestArea(aAreaSG2)
RestArea(aAreaAtu)
Return Max(nTempSob,nSobMin)
