#Include "Protheus.ch"
#Include "Folder.ch"
#Include "Colors.ch"
#Include "Font.ch"
//#Include "Ctba101.ch"         

#DEFINE D_PRELAN	"9"

STATIC __lCusto:= .F.             
STATIC __lItem	:= .F.
STATIC __lClVL := .F.
STATIC __aMedias[99]
STATIC __aDtMedias := {}
STATIC __dData
STATIC __nValor                    
STATIC lCtbLanc
STATIC cNumManLin	
STATIC lCT101CNV	
STATIC cPictVal  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ GravaLanc³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Lancamento Contabil  - CT2                           ³±±
±±³          ³ ROTINA CHAMADA EXTERNAMENTE - Atencao para criar parametros³±±
±±³          ³ e sempre tratar valor DEFAULT                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GravaLanc(dData,cLote,cSubLote,cDoc,cLinha,cTipo,cMoeda,    ³±±
±±³          ³cHistPad,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,     ³±±
±±³          ³cItemCrd,cClVlDeb,cClVlCrd,nValor,cTexto,cTpSald,cSeqLan,   ³±±
±±³			 ³nOpc)                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC1 = Lote do Lancamento Contabil                        ³±±
±±³          ³ ExpC3 = Sub_Lote do Lancamento Contabil                    ³±±
±±³          ³ ExpC4 = Documento do Lancamento Contabil                   ³±±
±±³          ³ ExpC5 = Linha Inicial do Lancamento Contabil               ³±±
±±³          ³ ExpC6 = Tipo do Lancamento Contabil                        ³±±
±±³          ³ ExpC7 = Moeda do Lancamento Contabil                  	  ³±±
±±³          ³ ExpC8 = Historico Padrao                                   ³±±
±±³          ³ ExpC9 = Conta debito                                       ³±±
±±³          ³ ExpC10= Conta Credito                                      ³±±
±±³          ³ ExpC11= Centro Custo Debito                                ³±±
±±³          ³ ExpC12= Centro Custo Credito                               ³±±
±±³          ³ ExpC13= Item Debito                                        ³±±
±±³          ³ ExpC14= Item Credito                                       ³±±
±±³          ³ ExpC15= Classe de Valor Debito                             ³±±
±±³          ³ ExpC16= Classe de Valor Credito                            ³±±
±±³          ³ ExpN1 = Valor do Lancamento Contabil                       ³±±
±±³          ³ ExpC17= Conteudo do Historico                              ³±±
±±³          ³ ExpC18= Tipo de Saldo                                      ³±±
±±³          ³ ExpC19= Sequencia do Lancamento Contabil                   ³±±
±±³          ³ ExpN2 = Opcao do Menu (Inclusao/Alteracao/Exclusao )       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GravAsie(dData, cLote, cSubLote, cDoc, cLinha, cTipo, cMoeda, cHistPad, cDebito,;
					cCredito, cCustoDeb, cCustoCrd, cItemDeb, cItemCrd, cClVlDeb,;
					cClVlCrd, nValor, cTexto, cTpSald, cSeqLan, nOpc, lAtSldBase, aCols,;
					cEmpOri, cFilOri, nForaCols, cDCD, cDCC, cDCDAnt, cDCCAnt, cRotina,;
					lAltTpSald, cTpSaldAnt, aOutros, dDataLP, nRecLan, cCodSeq, lSeqCorr, cSeqCorr, dDataCA, dDataCR)

Local aSaveArea		:= GetArea()
Local aSaveSx3		:= GetArea()
Local cDescricao	:= ""
Local lInclui		:= .F.
Local nPasso		:= 0
Local nLinTotal		:= 0
Local nLinhasAnt	:= 0
Local nTamHist		:= Len(CriaVar("CT2_HIST"))
Local nContaLinhas	:= 1		// Para o loop de gravacao de lancamento - Contador de linhas
Local nContador
Local lFirstHist	:= .T.
Local cAliasAnt		:= ""
Local nRecCt1		:= CT1->(Recno()), nIndCt1	:= CT1->(IndexOrd())
Local lCtbGrv 		:= IIf(ExistBlock("CTBGRV"),.T.,.F.)
Local cChave		:= ""
Local nOutros		:= 0
Local nCont			:= 0

Local nXRecCT2 := 0
Local cXMoedLC := ""
Local cXTPSald := ""
Local cOldAlias := ""
Local dXDtCT2  := ctod("")

#IFNDEF TOP
	Local nRecnoAnt		:= 0
#ENDIF           

Local lDtTxUso		:= .F.
Local lMltSld		:= CT2->( FieldPos( "CT2_CTLSLD" ) ) > 0
Local aLinhas		:=	{}
Local nFKinUse		:= 0
Local nSoma  		:= GetMv("MV_SOMA")
Local lPcoLanc

Default cCodSeq 	:= ''
Default lSeqCorr	:= ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )

Private dDataLanc := dData

If lSeqCorr .And. ValType(cSeqCorr) == "U"
	cSeqCorr := space(TamSx3("CT2_NODIA")[1])
EndIf

#IFDEF TOP
	If TcSrvType() != "AS/400"
		cOldAlias := Alias()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a integridade referencial está ativa                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT count(*) TOTAL FROM TOP_PARAM WHERE PARAM_NAME = 'FKINUSE" + SM0->M0_CODIGO + "'"
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'INTEGR', .F., .T.)
		nFKInUse := INTEGR->TOTAL
		INTEGR->( dbCloseArea() )

		dbSelectArea(cOldAlias)
	EndIf
#ENDIF

//****************************
// Controle do Correlativo   *
//****************************
IF lSeqCorr .AND. Empty(cSeqCorr)
	IF (nOpc == 3 .Or. nOpc == 7) .AND. Val(cLinha) < 2  // a partir da segunda linha do lanc., o correlativo eh o mesmo
		cSeqCorr := CTBSqCor( CTBSubToPad(cSubLote), cCodSeq, dData  )
	ElseIF nOpc <> 3
		cSeqCorr := CT2->CT2_SEGOFI
	EndIf	
EndIf

//inicio do lancamento para modulo SIGAPCO
PcoIniLan("000082")

For nCont	:= 2 to __nQuantas
	If CtbUso("CT2_DTTX"+StrZero(nCont,2))			
		lDtTxUso		:= .T.
		Exit		
	EndIf
Next   
	
DEFAULT nForaCols	:= 1
DEFAULT cRotina		:= "CTBA101"
DEFAULT lAltTpSald	:= .F.
DEFAULT cTpSaldAnt	:= cTpSald
DEFAULT aOutros		:= {}
DEFAULT dDataLP		:= CTOD("  /  /  ")
DEFAULT dDataCA		:= CTOD("  /  /  ")
DEFAULT dDataCR		:= CTOD("  /  /  ")
DEFAULT nRecLan		:= 0 		/// PASSADO POR REFERENCIA PARA RETORNAR O RECNO DO REG. DE LANCTO (CTBA211 C/CT.PONTE)

cSeqCorr  := If(ValType(cSeqCorr) != "C","",cSeqCorr)

CT1->(DbSetOrder(1))
DbSelectArea( "CT2" )

// Conta numero de linhas do lancamento no caso de alteracao
If nOpc == 4 
	If cMoeda = '01'
		CT2->(dbSetOrder(10))
		If CT2->( MsSeek( xFilial("CT2") + Dtos( dData ) + AvKey(cLote, "CT2_LOTE") + AvKey(cSubLote, "CT2_SBLOTE") + AvKey(cDoc, "CT2_DOC") + AvKey(cSeqLan, "CT2_SEQLAN") + AvKey(cEmpOri, "CT2_EMPORI") + AvKey(cFilOri, "CT2_FILORI") + '01' ) )
			nRec := Recno()
			While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
								DTOS(CT2->CT2_DATA) == Dtos(dData) 	.And.;
								CT2->CT2_LOTE == cLote 					.And.;
								CT2->CT2_SBLOTE == cSubLote 			.And.;
								CT2->CT2_DOC == cDoc 					.And.;
								CT2->CT2_SEQLAN == cSeqLan				.And.;
								CT2->CT2_EMPORI	== cEmpOri				.And.;
								CT2->CT2_FILORI	== cFilOri				.And.;
								CT2->CT2_MOEDLC == '01'
				nLinhasAnt++
				dbSkip()
			EndDo
		EndIf
	EndIf
ElseIf nOpc == 5			// Exclusao de lancamento
	dbSelectArea("CT2")
	dbSetOrder(1)
	If CT2->( MsSeek( xFilial("CT2") + dtos(dData) + AvKey(cLote, "CT2_LOTE") + AvKey(cSublote, "CT2_SBLOTE") + AvKey(cDoc, "CT2_DOC") + AvKey(cLinha, "CT2_LINHA") + AvKey(cTpSald, "CT2_TPSALD") + AvKey(cEmpOri, "CT2_EMPORI") + AvKey(cFilOri, "CT2_FILORI") + AvKey(cMoeda, "CT2_MOEDLC") ) )
		//Chama rotina para atualizar os flags de saldos a partir da data 
		//para frente.
		cAliasAnt	:= Alias()					
		nRecnoAnt	:= Recno() 	
		dbSelectArea(cAliasAnt)
		dbGoto(nRecnoAnt)
			
		// Exclui lancamento principal
		PcoDetLan("000082","01","CTBA101",.T.)
				
		RecLock("CT2",.F.,.T.)
		dbDelete()
		MsUnlock()             								
	EndIf	

	If cMoeda = '01'
		//Atualiza arquivo CTF 	
		cAliasAnt := Alias()
		dbSelectAREA("CTF")
		CTF->( MsSeek( xFilial("CTF") + Dtos(dData) + AvKey(cLote,"CTF_LOTE") + AvKey(cSubLote,"CTF_SBLOTE") + AvKey(cDoc,"CTF_DOC") ) )                    
		//dbSeek(xFilial("CTF")+Dtos(dData)+cLote+cSubLote+cDoc)
		CTF_LOCK := CTF->(Recno())                        
		CtbDestrava(dData,cLote,cSubLote,cDoc,@CTF_LOCK)	
		dbSelectArea(cAliasAnt)	 							    	
		
		// Exclui continuacao de historico		
		dbSelectArea("CT2")
		dbSetOrder(10)
		If CT2->( MsSeek( xFilial("CT2") + Dtos( dData ) + AvKey(cLote, "CT2_LOTE") + AvKey(cSubLote, "CT2_SBLOTE") + AvKey(cDoc, "CT2_DOC") + AvKey(cSeqLan, "CT2_SEQLAN") + AvKey(cEmpOri, "CT2_EMPORI") + AvKey(cFilOri, "CT2_FILORI") + '01' ) )
			//CT2->( MsSeek( xFilial("CT2") + Dtos( dData ) + cLote + cSubLote + cDoc + cSeqLan + cEmpOri + cFilOri + '01' ) )
			While !Eof() .And. CT2->CT2_FILIAL == xFilial() 			.And.;
								DTOS(CT2->CT2_DATA) == Dtos(dData) 	.And.;
								CT2->CT2_LOTE == cLote 				.And.;
								CT2->CT2_SBLOTE == cSubLote 			.And.;
								CT2->CT2_DOC == cDoc 					.And.;
								CT2->CT2_SEQLAN == cSeqLan				.And.;
								CT2->CT2_EMPORI	== cEmpOri				.And.;
								CT2->CT2_FILORI	== cFilOri				.And.;
								CT2->CT2_MOEDLC == '01'							
				PcoDetLan("000082","01","CTBA101",.T.)
				RecLock("CT2",.F.,.T.)
				dbDelete()
				MsUnLock()
				dbSkip()
			EndDo
		EndIf
	EndIf
EndIf

If nOpc != 5					// Inclusao / Alteracao
	DbSetOrder( 1 )
	If cMoeda = '01'
		// Conta numero total de linhas a serem gravadas
		// o historico indica quantas linhas existirao
		cTexto		:= strtran(cTexto, chr(13), ' ')
		cTexto		:= strtran(cTexto, chr(10), ' ')
		nLinTotal:= mlCount( cTexto , nTamHist)

   		For nContador := 1 To nLinTotal
			cDescricao := MemoLine(cTexto, nTamHist, nContador)
			If Empty(cDescricao)
				Loop
			EndIf
			nPasso++
		Next nContador

		nLinTotal 	:= nPasso		// Numero total de linhas do lancamento
		nPasso		:= 1
	Else
		nLintotal	:= 1
	EndIf
	
	While nContaLinhas <= nLinTotal

		cDescricao := MemoLine(cTexto, nTamHist, nPasso)

		If Empty(cDescricao)
			nPasso++						//  Contador para leitura do Memoline		
			Loop
		EndIf

		If nContaLinhas == 1				// Grava primeira linha de informacoes -> debito/credito etc
			/*If cMoeda <> '01'
				//No aCols nao tem a moeda 01. 
				If aCols[Val(cMoeda)-nForaCols][4] = "5"		// Moeda do lancamento ou bloqueada nao tem conversao
					Return									
				EndIf
			EndIf			
			 */		
			If nOpc == 3 .Or. nOpc == 6	// Inclusao
				If !CT2->( MsSeek( xFilial("CT2") + dtos(dData) + AvKey(cLote, "CT2_LOTE") + AvKey(cSublote, "CT2_SBLOTE") + AvKey(cDoc, "CT2_DOC") + AvKey(cLinha, "CT2_LINHA") + AvKey(cTpSald, "CT2_TPSALD") + AvKey(cEmpOri, "CT2_EMPORI") + AvKey(cFilOri, "CT2_FILORI") + AvKey(cMoeda, "CT2_MOEDLC") ) )
					//MsSeek( xFilial()+Dtos(dData)+cLote+cSubLote+cDoc+cLinha+cTpSald+cEmpOri+cFilOri+cMoeda)
					lInclui := .T.
				Else 					// Alteracao
					RecLock("CT2",.F.)	
					lInclui := .F.
				EndIf
			Else
				If nOpc == 4  .And. lAltTpSald //Se for alteracao de tipo de Saldo
					cChave	:= xFilial("CT2") + dtos(dData) + AvKey(cLote, "CT2_LOTE") + AvKey(cSublote, "CT2_SBLOTE") + AvKey(cDoc, "CT2_DOC") + AvKey(cLinha, "CT2_LINHA") + AvKey(cTpSaldAnt, "CT2_TPSALD") + AvKey(cEmpOri, "CT2_EMPORI") + AvKey(cFilOri, "CT2_FILORI") + AvKey(cMoeda, "CT2_MOEDLC")
					//cChave	:= xFilial()+Dtos(dData)+cLote+cSubLote+cDoc+cLinha+cTpSaldAnt+cEmpOri+cFilOri+cMoeda
				Else
					cChave	:= xFilial("CT2") + dtos(dData) + AvKey(cLote, "CT2_LOTE") + AvKey(cSublote, "CT2_SBLOTE") + AvKey(cDoc, "CT2_DOC") + AvKey(cLinha, "CT2_LINHA") + AvKey(cTpSald, "CT2_TPSALD") + AvKey(cEmpOri, "CT2_EMPORI") + AvKey(cFilOri, "CT2_FILORI") + AvKey(cMoeda, "CT2_MOEDLC")
					//cChave	:= xFilial()+Dtos(dData)+cLote+cSubLote+cDoc+cLinha+cTpSald+cEmpOri+cFilOri+cMoeda				
				EndIf
				If CT2->( MsSeek( cChave ) )
					lInclui := .F.
				Else
					lInclui := .T.
				EndIf
			EndiF
			RecLock("CT2",lInclui)
			CT2->CT2_FILIAL		:= xFilial()
			CT2->CT2_DATA		:= dData
			CT2->CT2_LOTE		:= cLote
			CT2->CT2_SBLOTE		:= cSubLote
			CT2->CT2_DOC		:= cDoc
			CT2->CT2_LINHA		:= cLinha
			CT2->CT2_FILORI		:= cFilOri
			CT2->CT2_EMPORI		:= cEmpOri
			CT2->CT2_DC			:= cTipo
			CT2->CT2_DEBITO		:= cDebito
			CT2->CT2_CREDIT		:= cCredito
			CT2->CT2_MOEDLC		:= cMoeda 
			If CT2->( FieldPos( "CT2_XDTVAL" ) > 0 )
				CT2->CT2_XDTVAL		:= dData
			EndIf
			/*If cMoeda == '01'
				CT2->CT2_VALOR := nValor
			ElseIf cMoeda == '02'
				CT2->CT2_VALOR02 := nValor
			ElseIf cMoeda == '03'
				CT2->CT2_VALOR03 := nValor
			ElseIf cMoeda == '04'
				CT2->CT2_VALOR04 := nValor
			ElseIf cMoeda == '05'
				CT2->CT2_VALOR05 := nValor
			EndIf*/
			CT2->CT2_VALOR := nValor
			/*If cMoeda = '01'
				CT2->CT2_VALOR		:= nValor
			Else
				CT2->CT2_VALOR		:= aCols[Val(cMoeda)-nForaCols][3]
			EndIf*/
			CT2->CT2_HP			:= cHistPad
			CT2->CT2_CCD		:= cCustoDeb
			CT2->CT2_CCC		:= cCustoCrd
			CT2->CT2_ITEMD		:= cItemDeb
			CT2->CT2_ITEMC		:= cItemCrd
			CT2->CT2_CLVLDB		:= cClVlDeb
			CT2->CT2_CLVLCR		:= cClVlCrd
			CT2->CT2_HIST		:= cDescricao
			CT2->CT2_SEQHIST	:= StrZero(nContaLinhas,3)
			CT2->CT2_TPSALD		:= cTpSald
			CT2->CT2_SEQLAN		:= cSeqLan
			CT2->CT2_ROTINA		:= cRotina			// Indica qual o programa gerador
			CT2->CT2_MANUAL		:= "1"				// Lancamento manual
			CT2->CT2_AGLUT		:= "2"				// Nao aglutina
					
			If !Empty(dDataLP)
				CT2->CT2_DTLP	:= dDataLP
			EndIf
			
			If !Empty(dDataCA) .And. CT2->( FieldPos( "CT2_XDTCA" ) > 0 )
				CT2->CT2_XDTCA	:= dDataCA
			EndIf
			
			If !Empty(dDataCR) .And. CT2->( FieldPos( "CT2_XDTCR" ) > 0 )
				CT2->CT2_XDTCR	:= dDataCR
			EndIf

			aSaveSx3 := SX3->(GetArea())
			If Len(aOutros) > 0 
				For nOutros	:= 1 to Len(aOutros)
					If Posicione("SX3",2,AllTrim(aoutros[nOutros]),"X3_CONTEXT") != "V"
						&("CT2->"+(aoutros[nOutros]))	:= &("M->"+(aoutros[nOutros]))
					EndIf									
				Next
			EndIf
			RestArea(aSaveSx3)
			
			If CtbUso("CT2_DCD")
				If cDCD = Nil
					If CT2->CT2_DC $ "13"
						CT1->(MSSeek(xFilial("CT1") + CT2->CT2_DEBITO))
						cDCD := CT1->CT1_DC
					Else
						cDCD := ""
					Endif
				Endif
				CT2->CT2_DCD	:= cDCD
			EndIf
			If CtbUso("CT2_DCC")
				If cDCC = Nil
					If CT2->CT2_DC $ "23"
						CT1->(MSSeek(xFilial("CT1") + CT2->CT2_CREDIT))
						cDCC := CT1->CT1_DC
					Else
						cDCD := ""
					Endif
				Endif
				CT2->CT2_DCC	:= cDCC
			EndIf

			If lSeqCorr			
			
				IF Val(cLinha) < 2
					// Grava sequancia do correlativo
					cSeqCorr := CTBSQGrv( cSeqCorr, dData ) // efetua a gravação do numero gerado, caso já exista o numero, ele  irá gerar um novo.
				Endif

				CT2->CT2_SEGOFI	:= cSeqCorr
				CT2->CT2_NODIA 	:= cSeqCorr

				// Efetua a gravação do codigo do diario no ct2
				IF CT2->( FieldPos( "CT2_DIACTB" ) > 0 ) .And. !Empty(cSeqCorr) 
					CT2->CT2_DIACTB := cCodSeq
				ENDIF

				FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
			EndIf   
			
			//Agregado MT
			If CT2->CT2_VALOR = 0
				CT2->CT2_CRCONV := "5"
			Else
				CT2->CT2_CRCONV	:= "1"
				CT2->CT2_DATATX := dData
			EndIf
			IF CT2->( FieldPos( "CT2_XCONV" ) > 0 )
				CT2->CT2_XCONV := "5"
			Endif
		   /*	If cMoeda = '01' 
				If CT2->CT2_VALOR = 0 
					CT2->CT2_CRCONV := "5"
				Else
					CT2->CT2_CRCONV	:= "1"				
			    EndIf
			Else
				If (Empty(aCols[Val(cMoeda)-nForaCols][2]) .And. CT2->CT2_VALOR = 0)
					CT2->CT2_CRCONV		:= "5"
				Else			
					CT2->CT2_CRCONV		:= aCols[Val(cMoeda)-nForaCols][2]
				EndIf      
				
				If lDtTxUso .And. ValType(aCols[Val(cMoeda)-nForaCols][5]) == "D"
					CT2->CT2_DATATX	:= 	aCols[Val(cMoeda)-nForaCols][5]
				EndIf        
				
			EndIf*/

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³grava o status do lancamento contabil para que o mesmo seja³
			//³validado na rotina de copia de saldos                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lMltSld
				CT2->CT2_CTLSLD	:= "0"
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³adiciona a fila o novo lancamento  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If FindFunction( "IsCtbJob" ) .And. IsCtbJob()
				aAdd( aLinhas, { SM0->M0_CODFIL,;
								 cLote,;
								 cSublote,;
								 cDoc,;
								 dData,;
								 StrZero( Iif( nOpc == 6 .OR. nOpc == 7, 3, nOpc ) ,1),;
								 StrZero( nSoma, 1 ),;
								 cLinha,;
								 cMoeda,;
				 				 '0',; 
				 				 IIf( nFKInUse > 0, '1' , '0' ) } )

				CTBGrvCVO( aLinhas )
			EndIf

			//Ponto de Entrada para Gravacao de lancamentos contabeis
			If lCtbGrv
				ExecBlock("CTBGRV",.f.,.f.,{ nOpc,cRotina,dData,cLote,cSubLote,cDoc } )
			EndIf

			MsUnlock()
			nRecLan	:= CT2->(Recno())

			lPcoLanc := .T.
			lCtbPco := IIf(ExistBlock("CTBPCO"),.T.,.F.)
			If lCtbPco
				//Ponto de entrada para verificar se entra na pcodetlan()
				lPcoLanc  := ExecBlock("CTBPCO",.f.,.f.,{ "000082","01","CTBA101" } )
			EndIf
			
			If lPcolanc
            	lPcoLanc := ( CT2->CT2_DC != "4" ) //"4" eh continuacao do historico
            EndIf
            
			If lPcolanc
				PcoDetLan("000082","01","CTBA101")
			EndIf	

			//Chama rotina para atualizar os flags de saldos a partir da data 
			//para frente.           		
		Else		// Continuacao de historico
			If cMoeda = '01'//O historico complementar sera gravado somente e sempre na moeda 01!!! 
				If nOpc == 3             
					lInclui := .T.
				Else        
					dbSelectArea("CT2")
					dbSetOrder(10)
					dbSkip()
					If  CT2->CT2_SEQLAN == cSeqLan .And. CT2->CT2_LOTE == cLote .And. ;
						CT2->CT2_SBLOTE == cSubLote .And. CT2->CT2_DOC == cDoc .And. ;
						DTOS(CT2_DATA) == DTOS(dData) .And. CT2->CT2_MOEDLC == '01' .And.; 
						CT2->CT2_EMPORI == cEmpOri .And. CT2->CT2_FILORI == cFilOri
						lInclui := .F.           
						cLinha	:= CT2->CT2_LINHA
					Else     
						//Se o Seqlan for diferente e ainda existir lancamentos gravados
						//com a mesma sequencia, pulo para o proximo lancamento. 
						If nContaLinhas <= nLinhasAnt 
							While CT2->CT2_SEQLAN <> cSeqLan .And. !Eof()
								dbSkip()
								Loop
							End     
							cLinha := CT2->CT2_LINHA                   
						Else					 
							lInclui := .T.
							If lFirstHist //Se for a primeira linha de historico complementar
								dbSelectArea("CT2")
								dbSetOrder(1)
								CT2->( MsSeek( xFilial("CT2") + Dtos(dData) + AvKey(cLote, "CT2_LOTE") + AvKey(cSubLote, "CT2_SBLOTE") + AvKey(cDoc, "CT2_DOC") + 'ZZZ', .T. ) )
								CT2->(dbSkip(-1))
								cLinha	:= Soma1(CT2->CT2_LINHA)
								lFirstHist := .F.
							EndIf
						EndIf
					EndIf
				EndIf                
				RecLock("CT2",lInclui)
				CT2->CT2_FILIAL		:= xFilial()
				CT2->CT2_DATA		:= dData
				CT2->CT2_LOTE		:= cLote
				CT2->CT2_SBLOTE		:= cSubLote
				CT2->CT2_DOC		:= cDoc
				CT2->CT2_LINHA		:= cLinha
				CT2->CT2_FILORI		:= cFilOri
				CT2->CT2_EMPORI		:= cEmpOri
				CT2->CT2_HIST		:= cDescricao
				CT2->CT2_DC			:= "4"				// Continuacao de Historico
				CT2->CT2_SEQHIST	:= StrZero(nContaLinhas,3)
				CT2->CT2_SEQLAN		:= cSeqLan
				CT2->CT2_TPSALD		:= cTpSald			
				CT2->CT2_MOEDLC		:= cMoeda
				CT2->CT2_ROTINA		:= cRotina			// Indica qual o programa gerador
				CT2->CT2_MANUAL		:= "1"				// Lancamento manual
				CT2->CT2_AGLUT		:= "2"				// Nao aglutina
				CT2->CT2_SLBASE		:= "S"				// Flag de saldo basico
				If CT2->( FieldPos( "CT2_XDTVAL" ) > 0 )
					CT2->CT2_XDTVAL		:= dData
				EndIf
				
				If !Empty(dDataLP)
					CT2->CT2_DTLP	:= dDataLP
				EndIf
				
				If !Empty(dDataCA) .And. CT2->( FieldPos( "CT2_XDTCA" ) > 0 )
					CT2->CT2_XDTCA	:= dDataCA
				EndIf
				
				If !Empty(dDataCR) .And. CT2->( FieldPos( "CT2_XDTCR" ) > 0 )
					CT2->CT2_XDTCR	:= dDataCR
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³adiciona a fila o novo lancamento  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If FindFunction( "IsCtbJob" ) .And. IsCtbJob()
					aAdd( aLinhas, { SM0->M0_CODFIL,;
									 cLote,;
									 cSublote,;
									 cDoc,;
									 dData,;
									 StrZero( Iif( nOpc == 6 .OR. nOpc == 7, 3, nOpc ) ,1),;
									 StrZero( nSoma, 1 ),;
									 cLinha,;
									 cMoeda,;
					 				 '0',; 
					 				 IIf( nFKInUse > 0, '1' , '0' ) } )

					CTBGrvCVO( aLinhas )
				EndIf

				//Ponto de Entrada para Gravacao de lancamentos contabeis
				If lCtbGrv
					ExecBlock("CTBGRV",.f.,.f.,{nOpc,cRotina})
				EndIf				
				MsUnLock()
			EndIf
		EndIf
		nPasso++						//  Contador para leitura do Memoline		
		cLinha  := Soma1(cLinha)		
		If (AllTrim(cRotina) == "CTBA211") .And. (nOpc == 3)
			cSeqLan := Soma1(cSeqLan)
		EndIf
		nContaLinhas++   
	EndDo

	// Volta Numeracao da linha -> para que no proximo documento comece corretamente!
	nContaLinhas--

	// Deletar registros excedentes de historico
	If cMoeda = '01'
		If nContaLinhas < nLinhasAnt
			dbSelectArea("CT2")
			dbSetOrder(10)
			dbSkip()
			While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") 			.And.;
								DTOS(CT2->CT2_DATA) == Dtos(dData) 	.And.;
								CT2->CT2_LOTE == cLote 					.And.;
								CT2->CT2_SBLOTE == cSubLote 			.And.;
								CT2->CT2_DOC == cDoc 					.And.;
								CT2->CT2_SEQLAN == cSeqLan				.And.;
								CT2->CT2_EMPORI	== cEmpOri				.And.;
								CT2->CT2_FILORI	== cFilOri				.And.;
								CT2->CT2_MOEDLC == cMoeda	
				If CT2->CT2_DC != "4"
					dbskip()
					Loop
				Endif
				RecLock("CT2",.F.,.T.)
				dbDelete()
				dbSkip()
				MsUnlock()
			EndDo
			DbSetOrder(1)
		EndIf
	EndIf

	// AQUI - Outros campos de usuario
EndIf

// Grava numero da ultima linha no arquivo de controle (CTF)
// Registro já foi travado no início do lançamento.
If cMoeda == '01'
	dbSelectAREA("CTF")                    
	If !CTF->( MsSeek( xFilial("CTF") + Dtos(dData) + AvKey(cLote,"CTF_LOTE") + AvKey(cSubLote,"CTF_SBLOTE") + AvKey(cDoc,"CTF_DOC") ) )
		RecLock("CTF",.T.)
		CTF->CTF_FILIAL		:= xFilial("CTF")
		CTF->CTF_DATA		:= dData
		CTF->CTF_LOTE		:= cLote
		CTF->CTF_SBLOTE		:= cSubLote
		CTF->CTF_DOC		:= cDoc 	       
	Else
		RecLock("CTF",.F.)	
	EndIf
	CTF->CTF_LINHA	:= CT2->CT2_LINHA
	MsUnlock()
EndIf

//finalizacao do lancamento no modulo SIGAPCO
PcoFinLan("000082")	

RestArea(aSaveArea)

CT1->(DbGoto(nRecCt1))
CT1->(DbSetOrder(nIndCt1))

Return .t.
