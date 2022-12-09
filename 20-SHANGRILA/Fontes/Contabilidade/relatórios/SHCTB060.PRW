#Include "Ctbr060.Ch"
#Include "PROTHEUS.Ch"

#DEFINE 	TAM_VALOR    TAMSX3('CT7_DEBITO')[1] + 6

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	09/04/2014
* Descricao		:	
* Retorno		: 	
*/
User Function SHCTB060()

	Local oReport

	Local aSetOfBook
	Local aCtbMoeda 	:= {}
	Local lOk			:= .T.
	Local nDivide		:= 1
	Local nQuadro

	Private cPerg	 := "CTR060"
	Private aQuadro := { "","","","","","","",""}
	PRIVATE nomeProg  := "EXCTB060"
	PRIVATE titulo
	PRIVATE aSelFil	:= {}

	CtAjustSx1('CTR060')

	If FindFunction("TRepInUse") .And. TRepInUse()

		If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
			lOk	:= .F.
		EndIf

		For nQuadro :=1 To Len(aQuadro)
			aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
		Next

		CtbCarTxt()

		Pergunte("CTR060",.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
	//³ Gerencial -> montagem especifica para impressao)		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !ct040Valid(mv_par06)
			lOk	:= .F.
		Else
			aSetOfBook := CTBSetOf(mv_par06)
		Endif
	
		If lOk .And. mv_par30 == 1 .And. Len( aSelFil ) <= 0
			aSelFil := AdmGetFil()
			If Len( aSelFil ) <= 0
				lOk	:= .F.
			EndIf
		EndIf
	
		If mv_par21 == 2			// Divide por cem
			nDivide := 100
		ElseIf mv_par21 == 3		// Divide por mil
			nDivide := 1000
		ElseIf mv_par21 == 4		// Divide por milhao
			nDivide := 1000000
		EndIf
	
		If lOk
			aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
			If Empty(aCtbMoeda[1])
				Help(" ",1,"NOMOEDA")
				lOk := .F.
			Endif
		Endif
	
		If lOk
			If (mv_par26 == 1) .and. ( Empty(mv_par27) .or. Empty(mv_par28) )// Rec./Desp. Anterior Zeradas? ## Grupo Receitas/Despesas? ## Data de Zeramento Receita/Despesas?
				cMensagem	:= STR0024	// "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
				cMensagem	+= STR0025	// "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
				MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")
				lOk	:= .F.
			EndIf
		EndIf

		If lOk
			oReport := ReportDef(aSetOfBook,aQuadro,aCtbMoeda,nDivide)
			oReport:PrintDialog()
		EndIf
	Else
		EXCtbR60R3() // Executa versão anterior do fonte
	Endif

Return

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	09/04/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function ReportDef(aSetOfBook,aQuadro,aCtbMoeda,nDivide)

	Local oReport
	Local oPlcontas
	Local oTotais

	Local nDecimais
	Local cSeparador	:= ""
	Local cMascara		:= ""
	Local cPicture		:= ""

	Local cDescMoeda
	Local dDataFim 		:= mv_par02
	Local lImpSint		:= Iif(mv_par05==1 .Or. mv_par05 ==3,.T.,.F.)// Imprime Contas: 1=Sintet/2=Analit/3=Ambas
	Local lImpConta		:= Iif(mv_par11==1,.T.,.F.) // Imprime da Conta? Codigo / Descricao
	Local lMov			:= Iif(mv_par17==1,.T.,.F.) // Imprime Coluna Mov ?
	Local lNormal		:= Iif(mv_par20==1,.T.,.F.)	// Imprimir Codigo? Normal / Reduzido
	Local aTamConta		:= TAMSX3("CT1_CONTA")
	Local aTamCtaRes	:= TAMSX3("CT1_RES")
	Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+mv_par08))
	Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
	Local nTamDescr		:= 0

//"Este programa ira imprimir o Balancete de Verificacao Modelo 3 (132 Colunas), e"
//"opcional a impressao do codigo da conta ou sua descricao, sao tambem impressos,"
//"saldo anterior, debito, credito e saldo atual do periodo."
	Local cDesc			:= STR0001+STR0002+STR0016

// Retorna Decimais
	cDescMoeda 	:= Alltrim(aCtbMoeda[2])
	nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

	If Empty(aSetOfBook[2])
		cMascara := GetMv("MV_MASCARA")
	Else
		cMascara := RetMasCtb(aSetOfBook[2],@cSeparador)
	EndIf
	cPicture := aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF mv_par05 == 1
		titulo := STR0035  // "Balancete de Verificacao Sintetico de "
	ElseIf mv_par05 == 2
		titulo := STR0034  // "Balancete de Verificacao Analitico de "
	ElseIf mv_par05 == 3
		titulo := STR0036  // "Balancete de Verificacao de "
	EndIf

	titulo += DTOC(mv_par01)+ OemToAnsi(STR0037)+ Dtoc(mv_par02)+Lower(OemToAnsi(STR0008))+cDescMoeda
	titulo += IIF (mv_par10 > "1"," (" + Tabela("SL", mv_par10, .F.) + ")","")
	titulo += IIF (nDivide  >  1 ," (" + OemToAnsi(STR0023) + Alltrim(Str(nDivide)) + ")", "")

	oReport := TReport():New(nomeProg,titulo,,{|oReport| ReportPrint(oReport,aSetOfBook,aQuadro,aCtbMoeda,nDivide,cMascara,cPicture)},cDesc)


	If lMov
		oReport:SetLandScape(.T.)
	Else
		oReport:SetPortrait(.T.)
	EndIf

// Sessao 1
	oPlcontas := TRSection():New(oReport,STR0033,{"cArqTmp","CT1"},/*aOrder*/,.F./*lLoadCells*/,.F./*lLoadOrder*/)	//"Plano de contas"

	TRCell():New(oPlcontas,"CONTA"		,"cArqTmp",	STR0026,/*Picture*/,aTamConta[1],/*lPixel*/,{|| EntidadeCTB(cArqTmp->CONTA ,0,0,70,.F.,cMascara,cSeparador,,,,,.F.) })// "C O D I G O   D A   C O N T A"
	TRCell():New(oPlcontas,"CTARES"		,"cArqTmp", STR0026,/*Picture*/,aTamCtaRes[1],/*lPixel*/,{|| EntidadeCTB(cArqTmp->CTARES,0,0,70,.F.,cMascara,cSeparador,,,,,.F.) })// "C O D I G O   D A   C O N T A"
	TRCell():New(oPlcontas,"DESCCTA"	,"cArqTmp", STR0027,/*Picture*/,nTamCta,/*lPixel*/,/*{|| }*/)// "D E S C R I C A O  D A  C O N T A"
	TRCell():New(oPlcontas,"SALDOANT"	,"cArqTmp", STR0028,/*Picture*/,TAM_VALOR+2,/*lPixel*/,,/*"RIGHT"*/,,"RIGHT",,,.F.)// "SALDO ANTERIOR"
	TRCell():New(oPlcontas,"SALDODEB"	,"cArqTmp", STR0029,/*Picture*/,TAM_VALOR+2,/*lPixel*/,,/*"RIGHT"*/,,"RIGHT",,,.F.)// "DEBITO"
	TRCell():New(oPlcontas,"SALDOCRD"	,"cArqTmp", STR0030,/*Picture*/,TAM_VALOR+2,/*lPixel*/,,/*"RIGHT"*/,,"RIGHT",,,.F.)// "CREDITO"
	TRCell():New(oPlcontas,"MOVIMENTO"	,"cArqTmp", STR0031,/*Picture*/,TAM_VALOR+2,/*lPixel*/,,/*"RIGHT"*/,,"RIGHT",,,.F.)// "MOVIMENTO PERIODO"
	TRCell():New(oPlcontas,"SALDOATU"	,"cArqTmp", STR0032,/*Picture*/,TAM_VALOR+2,/*lPixel*/,,/*"RIGHT"*/,,"RIGHT",,,.F.)// "SALDO ATUAL"

	oPlcontas:Cell("SALDOANT"):lHeaderSize  := .F.
	oPlcontas:Cell("SALDODEB"):lHeaderSize  := .F.
	oPlcontas:Cell("SALDOCRD"):lHeaderSize  := .F.
	oPlcontas:Cell("MOVIMENTO"):lHeaderSize := .F.
	oPlcontas:Cell("SALDOATU"):lHeaderSize  := .F.

	TRPosition():New( oPlcontas, "CT1", 1, {|| xFilial("CT1") + cArqTMP->CONTA })
    
	nTamDescr := oPlcontas:Cell("CONTA"):GetSize() + oPlcontas:Cell("CTARES"):GetSize() + oPlcontas:Cell("DESCCTA"):GetSize() + oPlcontas:Cell("SALDOANT"):GetSize() + 1

	If lNormal
		oPlcontas:Cell("CTARES"):Disable()
		nTamDescr -= oPlcontas:Cell("CTARES"):GetSize()
	Else
		oPlcontas:Cell("CONTA" ):Disable()
		nTamDescr -= oPlcontas:Cell("CONTA"):GetSize()
	EndIf

	If lImpConta
		oPlcontas:Cell("DESCCTA"):Disable()
		nTamDescr -= oPlcontas:Cell("DESCCTA"):GetSize()
	Else
		oPlcontas:Cell("CONTA"  ):Disable()
		oPlcontas:Cell("CTARES" ):Disable()
		nTamDescr -= (oPlcontas:Cell("CONTA"):GetSize() + oPlcontas:Cell("CTARES"):GetSize())
	EndIf

// Sessao totalizadora 
	oTotais := TRSection():New(oReport,STR0038,{""},/*aOrder*/,.F./*lLoadCells*/,.F./*lLoadOrder*/)	//"Totais"

	TRCell():New(oTotais,"DESCRICAO"	,"", STR0039,/*Picture*/,nTamDescr ,/*lPixel*/,)
	TRCell():New(oTotais,"DEBITO"		,"", STR0029,/*Picture*/,TAM_VALOR+2 ,/*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
	TRCell():New(oTotais,"CREDITO"		,"", STR0030,/*Picture*/,TAM_VALOR+2 ,/*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
	TRCell():New(oTotais,"MOVIMENTO"	,"", STR0031,/*Picture*/,TAM_VALOR+2 ,/*lPixel*/, /*CodeBlock*/, /*"RIGHT"*/,,"RIGHT",,,.F.)
	oTotais:SetHeaderSection(.F.)

	If !lMov
		oPlcontas:Cell("MOVIMENTO"):Disable()
		oTotais:Cell("MOVIMENTO"):Disable()
	EndIf

	oPlcontas:SetHeaderPage()
	oReport:ParamReadOnly()

Return oReport

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	09/04/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function ReportPrint(oReport,aSetOfBook,aQuadro,aCtbMoeda,nDivide,cMascara,cPicture)

	Local oPlcontas := oReport:Section(1)
	Local oTotais := oReport:Section(2)

	Local lOk			:= .T.
	Local cArqTmp
	Local nDigitAte		:= 0
	Local nTotDeb		:= 0
	Local nTotCrd		:= 0
	Local nTotMov		:= 0
	Local nGrpDeb		:= 0
	Local nGrpCrd		:= 0
	Local cTpContaAnt  := "1"
	Local cGrupoAnt		:= ""

	Local cFiltro	:= oPlcontas:GetAdvplExp()

	Local lFirstPage	:= .T.
	Local lJaPulou		:= .F.
	Local dDataFim 		:= mv_par02
	Local lImpSint		:= (mv_par05=1 .Or. mv_par05 ==3)// Imprime Contas: Sintet/Analit/Ambas
	Local lVlrZerado	:= (mv_par07==1)	// Saldos Zerados?
	Local lImpConta		:= (mv_par11==1)	// Imprime da Conta? Codigo / Descricao
	Local lMov			:= (mv_par17==1)	// Imprime Coluna Mov ?
	Local lPula			:= (mv_par18==1)	// Salta linha sintetica ?
	Local lPrintZero	:= (mv_par19==1)	// Imprime valor 0.00?
	Local cSegAte   	:= mv_par22						// Imprimir Ate o segmento?
	Local lImpAntLP		:= (mv_par23==1)	// Posicao Ant. L/P? Sim / Nao
	Local dDataLP		:= mv_par24						// Data Lucros/Perdas?
	Local lRecDesp0		:= (mv_par26==1)	// Rec./Desp. Anterior Zeradas?
	Local cRecDesp		:= mv_par27						// Grupo Receitas/Despesas?
	Local dDtZeraRD		:= mv_par28						// Data de Zeramento Receita/Despesas?
	Local cMoedaDsc		:= mv_par29
	Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)
	Local nSizeDeb		:=	oPlContas:Cell("SALDODEB"):nSize
	Local nSizeCrd		:=	oPlContas:Cell("SALDOCRD"):nSize
	Local nSizeMov		:=	oPlContas:Cell("MOVIMENTO"):nSize
	Local lFinaliza		:= .F.
	Local cCondicao		:= ''
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Davi Torchio - 10/07/2007                                     ³
//³Controle de numeração de pagina para o relatorio personalizado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private nPagIni		:= MV_PAR09 // parametro da pagina inicial
	Private nPagFim		:= 999999 	// parametro da pagina final
	Private nReinicia	:= 0    	// parametro de reinicio de pagina
	Private l1StQb		:= .T.		// primeira quebra
	Private lNewVars	:= .T.		// inicializa as variaveis
	Private m_pag		:= MV_PAR09 // controle de numeração de pagina
	Private nBloco      := 1		// controle do bloco a ser impresso
	Private nBlCount	:= 0		// contador do bloco impresso

	Pergunte(cPerg,.F.)

	#IFNDEF TOP
		If ! Empty(cFiltro)
			CT1->( dbSetFilter( { || &cFiltro }, cFiltro ) )
		EndIf
	#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao	    			     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
		CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
		mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
		mv_par10,aSetOfBook,mv_par13,mv_par14,mv_par15,mv_par16,;
		.F.,.F.,mv_par12,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFiltro,lRecDesp0,;
		cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,aSelFil)},;
		OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor rio..."
	OemToAnsi(STR0003))  				//"Balancete Verificacao"

// Verifica Se existe filtragem Ate o Segmento
	If !Empty(cSegAte)
		nDigitAte := CtbRelDig(cSegAte,cMascara)
	EndIf

	oReport:SetPageNumber( mv_par09 )
	oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport,/*.T.controle do cabeçalho pela rotina*/) } )

	dbSelectArea("cArqTmp")
	dbSetOrder(1)
	dbGoTop()
	oReport:SetMeter( RecCount() )

	If RecCount() == 0
		lOk := .F.
	Endif

	oReport:NoUserFilter()

	If lOk
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia a impressao do relatorio                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cGrupoAnt := cArqTmp->GRUPO

		oPlContas:Cell("SALDOANT" ):SetBlock( { || Iif( !lPrintZero .And. cArqTmp->SALDOANT == 0, "",;
			EXValorCtb(cArqTmp->SALDOANT ,,,oPlContas:Cell("SALDOANT" ):nSize,nDecimais,.T.,aSetOfBook[4],cArqTmp->NORMAL,,,,,,lPrintZero,.F.) ) } )
		oPlContas:Cell("SALDODEB" ):SetBlock( { || Iif( !lPrintZero .And. cArqTmp->SALDODEB == 0, "",;
			EXValorCtb(cArqTmp->SALDODEB ,,,nSizeDeb,nDecimais,.F.,aSetOfBook[4],cArqTmp->NORMAL,,,,,,lPrintZero,.F.) ) } )
		oPlContas:Cell("SALDOCRD" ):SetBlock( { || Iif( !lPrintZero .And. cArqTmp->SALDOCRD == 0, "",;
			EXValorCtb(cArqTmp->SALDOCRD ,,,nSizeCrd,nDecimais,.F.,aSetOfBook[4],cArqTmp->NORMAL,,,,,,lPrintZero,.F.) ) } )
		oPlContas:Cell("MOVIMENTO"):SetBlock( { || Iif( !lPrintZero .And. cArqTmp->MOVIMENTO == 0, "",;
			EXValorCtb(cArqTmp->MOVIMENTO,,,nSizeMov,nDecimais,.T.,aSetOfBook[4],cArqTmp->NORMAL,,,,,,lPrintZero,.F.) ) } )
		oPlContas:Cell("SALDOATU" ):SetBlock( { || Iif( !lPrintZero .And. cArqTmp->SALDOATU == 0, "",;
			EXValorCtb(cArqTmp->SALDOATU ,,,oPlContas:Cell("SALDOATU" ):nSize,nDecimais,.T.,aSetOfBook[4],cArqTmp->NORMAL,,,,,,lPrintZero,.F.) ) } )
		oPlContas:Cell("SALDOANT" ):SetAlign("RIGHT")
		oPlContas:Cell("SALDODEB" ):SetAlign("RIGHT")
		oPlContas:Cell("SALDOCRD" ):SetAlign("RIGHT")
//	oPlContas:Cell("MOVIMENTO"):SetAlign("RIGHT")	
//	oPlContas:Cell("SALDOATU" ):SetAlign("RIGHT")			
		oTotais:Cell("DESCRICAO" ):SetBlock( { || Iif(lFinaliza, OemToAnsi(STR0011), OemToAnsi(STR0020) + cGrupoAnt + ") : ") } )
		oTotais:Cell("DEBITO"):SetBlock( { || EXValorCtb(Iif(lFinaliza, nTotDeb,nGrpDeb),,,nSizeDeb,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.)})
		oTotais:Cell("CREDITO"):SetBlock( { || EXValorCtb(Iif(lFinaliza,nTotCrd,nGrpCrd),,,nSizeCrd,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)})
		oTotais:Cell("MOVIMENTO"):SetBlock( { || EXValorCtb(nTotMov,,,nSizeCrd,nDecimais,.F.,cPicture,Iif(Round(NoRound(nTotMov,3),2) < 0,"1","2"),,,,,,lPrintZero,.F.)})
		oTotais:Cell("DEBITO"):SetAlign("RIGHT")
		oTotais:Cell("CREDITO"):SetAlign("RIGHT")
//	oTotais:Cell("MOVIMENTO"):SetAlign("RIGHT")				
		oPlcontas:Init()
	
		Do While !Eof() .And. !oReport:Cancel()

			oReport:IncMeter()
			cCondicao := cArqTmp->NORMAL
			If oReport:Cancel()
				Exit
			EndIf
	       
			If mv_par05 == 1					// So imprime Sinteticas
				If cArqTmp->TIPOCONTA == "2"
					dbSkip()
					Loop
				EndIf
			ElseIf mv_par05 == 2				// So imprime Analiticas
				If cArqTmp->TIPOCONTA == "1"
					dbSkip()
					Loop
				EndIf
			EndIf

		//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
			If !Empty(cSegAte)
				If Len(Alltrim(cArqTmp->CONTA)) > nDigitAte
					dbSkip()
					Loop
				Endif
			EndIf

		
			oPlcontas:PrintLine() //Section(1)

			If mv_par05 == 1 // So imprime Sinteticas - Soma Sinteticas
				If cArqTmp->TIPOCONTA == "1"
					If cArqTmp->NIVEL1
						nTotDeb += cArqTmp->SALDODEB
						nTotCrd += cArqTmp->SALDOCRD
						nGrpDeb += cArqTmp->SALDODEB
						nGrpCrd += cArqTmp->SALDOCRD
					EndIf
				EndIf
			Else			// Soma Analiticas
				If Empty(cSegAte)	//Se nao tiver filtragem ate o nivel
					If cArqTmp->TIPOCONTA == "2"
						nTotDeb += cArqTmp->SALDODEB
						nTotCrd += cArqTmp->SALDOCRD
						nGrpDeb += cArqTmp->SALDODEB
						nGrpCrd += cArqTmp->SALDOCRD
					EndIf
				Else	//Se tiver filtragem, somo somente as sinteticas
					If cArqTmp->TIPOCONTA == "1"
						If cArqTmp->NIVEL1
							nTotDeb += cArqTmp->SALDODEB
							nTotCrd += cArqTmp->SALDOCRD
							nGrpDeb += cArqTmp->SALDODEB
							nGrpCrd += cArqTmp->SALDOCRD
						EndIf
					EndIf
				Endif
			EndIf

			dbSkip()

			If lPula
				If cArqTmp->TIPOCONTA == "1"
					oReport:SkipLine()
					cTpContaAnt := cArqTmp->TIPOCONTA
				ElseIf cTpContaAnt == "1"
					oReport:SkipLine()
					cTpContaAnt := cArqTmp->TIPOCONTA
				EndIf
			EndIf

			If mv_par12 == 1
				If cGrupoAnt <> cArqTmp->GRUPO	// Grupo Diferente - Totaliza e Quebra

					oReport:SkipLine()
					oReport:ThinLine()
					oReport:SkipLine()
				
					nTotMov := nGrpCrd - nGrpDeb
  
					If cCondicao == '1'
						nTotMov := nTotMov * 1
					Else
						nTotMov := nTotMov *(-1)
					EndIf

					oTotais:Init()
					oTotais:PrintLine()
					oReport:ThinLine()
					oTotais:Finish()

					cGrupoAnt	:= cArqTmp->GRUPO
					nGrpDeb		:= 0
					nGrpCrd		:= 0
                
					If cArqTmp->( !EoF() )
						oReport:EndPage() // Quebra direto - Comando .T. retirado para corrigir contador das paginas
					EndIf

				EndIf
			Else
				If cArqTmp->( !EoF() ) .And. cArqTmp->NIVEL1 	// Sintetica de 1o. grupo
					oReport:EndPage() // Quebra direto - Comando .T. retirado para corrigir contador das paginas
				EndIf
			EndIf
		EndDo

		oPlcontas:Finish()

		oReport:ThinLine()
		oReport:SkipLine()

		If mv_par12 == 1 .And. cGrupoAnt <> cArqTmp->GRUPO // Grupo Diferente - Totaliza e Quebra

			nTotMov :=  nGrpCrd - nGrpDeb
			
	
			oTotais:Init()
			oTotais:PrintLine()
			oReport:ThinLine()
			oReport:SkipLine()
			oTotais:Finish()

		EndIf
	
		lFinaliza := .T.

		nTotMov :=  nTotCrd - nTotDeb
		
		oTotais:Init()
		oTotais:PrintLine()
		oReport:ThinLine()
		oTotais:Finish()

		If mv_par25 ==1
			oReport:Section(1):SetHeaderSection(.F.)
			ImpQuadro(0,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,Alltrim(aCtbMoeda[2]),oReport:ClassName(),(IIF(lImpAntLP,dDataLP,CtoD(""))),cPicture,DecimalCTB(aSetOfBook,mv_par08),lPrintZero,mv_par10,oReport)
		EndIf

	EndIf

	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIF
	dbselectArea("CT2")

Return

/*

--------------------------------------------------------V RELESE 3 V---------------------------------------------------------------- 

*/

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_SALDO_ANT    	4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_VLR_DEBITO   	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_CREDITO  	8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_MOVIMENTO 		10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_SALDO_ATU 		12
#DEFINE 	COL_SEPARA7			13

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	09/04/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function EXCtbR60R3()

	Local aSetOfBook
	Local aCtbMoeda	:= {}
	LOCAL cDesc1 		:= OemToAnsi(STR0001)	//"Este programa ira imprimir o Balancete de Verificacao Modelo 3 (132 Colunas), e"
	LOCAL cDesc2 		:= OemToansi(STR0002)   //"opcional a impressao do codigo da conta ou sua descricao, sao tambem impressos,"
	LOCAL cDesc3		:= OemToansi(STR0016)   //"saldo anterior, debito, credito e saldo atual do periodo."
	LOCAL wnrel
	LOCAL cString		:= "CT1"
	Local titulo 		:= OemToAnsi(STR0003) 	//"Balancete de Verificacao"
	Local lRet			:= .T.
	Local nDivide		:= 1
	Local nQuadro

	PRIVATE Tamanho		:="M"
	PRIVATE nLastKey 	:= 0
	PRIVATE aReturn 	:= { OemToAnsi(STR0013), 1,OemToAnsi(STR0014), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
	PRIVATE aLinha		:= {}
	PRIVATE nomeProg  := "CTBR060"

	If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
		Return
	EndIf

	li 		:= 80
	m_pag	:= 1

//Private aQuadro := { "","","","","","","",""}// foi definida na rotina anterior

	For nQuadro :=1 To Len(aQuadro)
		aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
	Next

	CtbCarTxt()

	Pergunte("CTR060",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros							 ³
//³ mv_par01				// Data Inicial                  		 ³
//³ mv_par02				// Data Final                        	 ³
//³ mv_par03				// Conta Inicial                         ³
//³ mv_par04				// Conta Final  						 ³
//³ mv_par05				// Imprime Contas: Sintet/Analit/Ambas   ³
//³ mv_par06				// Set Of Books				    		 ³
//³ mv_par07				// Saldos Zerados?			     		 ³	
//³ mv_par08				// Moeda?          			     		 ³
//³ mv_par09				// Pagina Inicial  		     		     ³
//³ mv_par10				// Saldos? Reais / Orcados			     ³
//³ mv_par11				// Imprime da Conta? Codigo / Descricao  ³
//³ mv_par12				// Quebra por Grupo Contabil?		     ³
//³ mv_par13				// Filtra Segmento No.?				     ³
//³ mv_par14				// Conteudo Ini Segmen?				     ³
//³ mv_par15				// Conteudo Fim Segmen?				     ³
//³ mv_par16				// Conteudo Contido em?				     ³
//³ mv_par17				// Imprime Coluna Mov ?				     ³
//³ mv_par18				// Salta linha sintetica ?			     ³
//³ mv_par19				// Imprime valor 0.00    ?			     ³
//³ mv_par20				// Imprimir Codigo? Normal / Reduzido ³
//³ mv_par21				// Divide por ?                   	  ³
//³ mv_par22				// Imprimir Ate o segmento?			  ³
//³ mv_par23				// Posicao Ant. L/P? Sim / Nao        ³
//³ mv_par24				// Data Lucros/Perdas?					  ³
//³ mv_par25				// Imprime Quadros Contabeis?			  ³
//³ mv_par26				// Rec./Desp. Anterior Zeradas?			 ³		
//³ mv_par27				// Grupo Receitas/Despesas?      		 ³		
//³ mv_par28				// Data de Zeramento Receita/Despesas?	 ³		
//³ mv_par29				// Descricao na moeda?						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lRet .And. mv_par30 == 1 .And. Len( aSelFil ) <= 0
		aSelFil := AdmGetFil()
		If Len( aSelFil ) <= 0
			lRet := .F.
		EndIf
	EndIf

	wnrel	:= "CTBR060"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

	If nLastKey == 27
		Set Filter To
		Return
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !ct040Valid(mv_par06)
		lRet := .F.
	Else
		aSetOfBook := CTBSetOf(mv_par06)
	Endif

	If mv_par21 == 2			// Divide por cem
		nDivide := 100
	ElseIf mv_par21 == 3		// Divide por mil
		nDivide := 1000
	ElseIf mv_par21 == 4		// Divide por milhao
		nDivide := 1000000
	EndIf

	If lRet
		aCtbMoeda  	:= CtbMoeda(mv_par08,nDivide)
		If Empty(aCtbMoeda[1])
			Help(" ",1,"NOMOEDA")
			lRet := .F.
		Endif
	Endif

	If lRet
		If (mv_par26 == 1) .and. ( Empty(mv_par27) .or. Empty(mv_par28) )
			cMensagem	:= STR0024	// "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
			cMensagem	+= STR0025	// "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
			MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")
			lRet    	:= .F.
		EndIf
	EndIf

	If !lRet
		Set Filter To
		Return
	EndIf

	If mv_par17 == 1			// Imprime coluna movimento -> relatorio 220 colunas
		Tamanho := "G"
	EndIf

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	RptStatus({|lEnd| CTR060Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,nDivide)})

Return

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	09/04/2014
* Descricao		:	
* Retorno		: 	
*/
Static Function CTR060Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,nDivide)

	Local aColunas		:= {}
	LOCAL CbTxt			:= Space(10)
	Local CbCont		:= 0
	LOCAL limite		:= 132
	Local cabec1   		:= ""
	Local cabec2   		:= ""
	Local cSeparador	:= ""
	Local cPicture
	Local cDescMoeda
	Local cCodMasc
	Local cMascara
	Local cGrupo		:= ""
	Local cArqTmp
	Local dDataFim 		:= mv_par02
	Local lFirstPage	:= .T.
	Local lJaPulou		:= .F.
	Local lPrintZero	:= Iif(mv_par19==1,.T.,.F.)
	Local lPula			:= Iif(mv_par18==1,.T.,.F.)
	Local lNormal		:= Iif(mv_par20==1,.T.,.F.)
	Local lVlrZerado	:= Iif(mv_par07==1,.T.,.F.)
	Local lMov			:= Iif(mv_par17==1,.T.,.F.)
	Local nDecimais
	Local nTotDeb		:= 0
	Local nTotCrd		:= 0
	Local nTotMov		:= 0
	Local nGrpDeb		:= 0
	Local nGrpCrd		:= 0
	Local n
	Local cSegAte   	:= mv_par22
	Local nDigitAte		:= 0
	Local lImpAntLP		:= Iif(mv_par23 == 1,.T.,.F.)
	Local dDataLP		:= mv_par24
	Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)
	Local lRecDesp0		:= Iif(mv_par26==1,.T.,.F.)
	Local cRecDesp		:= mv_par27
	Local dDtZeraRD		:= mv_par28
	Local cMoedaDsc		:= mv_par29

	cDescMoeda 	:= Alltrim(aCtbMoeda[2])
	nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

	If Empty(aSetOfBook[2])
		cMascara := GetMv("MV_MASCARA")
	Else
		cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
	EndIf
	cPicture 		:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF mv_par05 == 1
		Titulo:=	OemToAnsi(STR0009)	//"BALANCETE DE VERIFICACAO SINTETICO DE "
	ElseIf mv_par05 == 2
		Titulo:=	OemToAnsi(STR0006)	//"BALANCETE DE VERIFICACAO ANALITICO DE "
	ElseIf mv_par05 == 3
		Titulo:=	OemToAnsi(STR0017)	//"BALANCETE DE VERIFICACAO DE "
	EndIf

	Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ;
		OemToAnsi(STR0008) + cDescMoeda

	If mv_par10 > "1"
		Titulo += " (" + Tabela("SL", mv_par10, .F.) + ")"
	Endif

	If nDivide > 1
		Titulo += " (" + OemToAnsi(STR0023) + Alltrim(Str(nDivide)) + ")"
	EndIf

	If !lMov
	/*
	01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	|       C O D I G O   D A   C O N T A                    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
    |       D E S C R I C A O  D A  C O N T A                |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"	
	*/
		Cabec1 := OemToAnsi(STR0004)
		If mv_par11 == 1		// Imprime codigo da conta
			Cabec2 	:= OemToAnsi(STR0005) //"|       C O D I G O   D A   C O N T A                    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
		Else
			Cabec2 := OemToAnsi(STR0019)  //"|       D E S C R I C A O  D A  C O N T A                |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
		EndIf
		aColunas:= {000,001,057,058,077,078,094,095,111, , ,112,131}
	Else
	/*
	01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	|                  C O D I G O   D A   C O N T A                                     |      SALDO ANTERIOR     |         DEBITO           |          CREDITO         |      MOVIMENTO PERIODO     |       SALDO ATUAL      |"
    |                  D E S C R I C A O  D A  C O N T A                                 |      SALDO ANTERIOR     |         DEBITO           |          CREDITO         |      MOVIMENTO PERIODO     |       SALDO ATUAL      |"	
	*/	
		If mv_par11 == 1
			Cabec1 := OemToAnsi(STR0021) 	//"|                  C O D I G O   D A   C O N T A                                     |      SALDO ANTERIOR     |         DEBITO           |          CREDITO         |      MOVIMENTO PERIODO     |       SALDO ATUAL      |"
		Else
			Cabec1 := OemToAnsi(STR0022)	//"|                  D E S C R I C A O  D A  C O N T A                                 |      SALDO ANTERIOR     |         DEBITO           |          CREDITO         |      MOVIMENTO PERIODO     |       SALDO ATUAL      |"
		EndIf
		Cabec2 := ""
		limite := 220
		Tamanho:= "G"
		aColunas := {000,001,085,086,111,112,138,139,165,166,194,195,219}
	Endif

	SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))

	m_pag := mv_par09
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
		CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
		mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
		mv_par10,aSetOfBook,mv_par13,mv_par14,mv_par15,mv_par16,;
		.F.,.F.,mv_par12,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7],lRecDesp0,;
		cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,aSelFil)},;
		OemToAnsi(OemToAnsi(STR0015)),;  //"Criando Arquivo Tempor rio..."
	OemToAnsi(STR0003))  				//"Balancete Verificacao"

// Verifica Se existe filtragem Ate o Segmento
	If !Empty(cSegAte)
		nDigitAte := CtbRelDig(cSegAte,cMascara)
	EndIf
				

	dbSelectArea("cArqTmp")
//dbSetOrder(1)
	dbGoTop()

	SetRegua(RecCount())

	cGrupo := GRUPO

	While !Eof()

		If lEnd
			@Prow()+1,0 PSAY OemToAnsi(STR0010)   //"***** CANCELADO PELO OPERADOR *****"
			Exit
		EndIF

		IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

		If mv_par05 == 1					// So imprime Sinteticas
			If TIPOCONTA == "2"
				dbSkip()
				Loop
			EndIf
		ElseIf mv_par05 == 2				// So imprime Analiticas
			If TIPOCONTA == "1"
				dbSkip()
				Loop
			EndIf
		EndIf

	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
		If !Empty(cSegAte)
			If Len(Alltrim(CONTA)) > nDigitAte
				dbSkip()
				Loop
			Endif
		EndIf
	

	************************* ROTINA DE IMPRESSAO *************************

		If mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
			If cGrupo != GRUPO
				@li,00 PSAY REPLICATE("-",limite)
				li+=2
				@li,00 PSAY REPLICATE("-",limite)
				li++
				@li,aColunas[COL_SEPARA1] PSAY "|"
				@li,39 PSAY OemToAnsi(STR0018) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
				@li,aColunas[COL_SEPARA3] PSAY "|"
				EXValorCtb(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
				@li,aColunas[COL_SEPARA4] PSAY "|"
				EXValorCtb(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
				@li,aColunas[COL_SEPARA5] PSAY "|"
				@li,aColunas[COL_SEPARA7] PSAY "|"
				li++
				li			:= 60
				cGrupo	:= GRUPO
				nGrpDeb	:= 0
				nGrpCrd	:= 0
			EndIf
		Else
			If NIVEL1				// Sintetica de 1o. grupo
				li 	:= 60
			EndIf
		EndIf

		IF li > 58
			If !lFirstPage
				@Prow()+1,00 PSAY	Replicate("-",limite)
			EndIf
			CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
			lFirstPage := .F.
		End

		@ li,aColunas[COL_SEPARA1] 		PSAY "|"
		If mv_par11 == 1					// Imprime codigo da conta
			If lNormal
				If TIPOCONTA == "2" 		// Analitica -> Desloca 2 posicoes
					If lMov	//Se Imprime coluna de movimento, considera ate 70 digitos no cod. da conta
						EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,70,.F.,cMascara,cSeparador)
					Else   //Se nao imprime coluna de movimento, considera ate 56 dig. no cod. da conta (para imprimir em retrato)
						EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,54,.F.,cMascara,cSeparador)
					EndIf
				Else
					If lMov
						EntidadeCTB(CONTA,li,aColunas[COL_CONTA],70,.F.,cMascara,cSeparador)
					Else
						EntidadeCTB(CONTA,li,aColunas[COL_CONTA],56,.F.,cMascara,cSeparador)
					EndIf
				EndIf
			Else
				If TIPOCONTA == "2"		// Analitica -> Desloca 2 posicoes
					@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
				Else
					@li,aColunas[COL_CONTA] PSAY Alltrim(CONTA)
				EndIf
			EndIf
		Else
			@li,aColunas[COL_CONTA] PSAY DESCCTA
		EndIf

		@ li,aColunas[COL_SEPARA2] 		PSAY "|"
		EXValorCtb(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA3]		PSAY "|"
		EXValorCtb(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA4]		PSAY "|"
		EXValorCtb(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5]		PSAY "|"
		If lMov
			EXValorCtb(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA6] PSAY "|"
		Endif
		EXValorCtb(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
	
		lJaPulou := .F.
	
		If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
			li++
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			If lMov
				@ li,aColunas[COL_SEPARA6] PSAY "|"
				@ li,aColunas[COL_SEPARA7] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA7] PSAY "|"
			EndIf
			li++
			lJaPulou := .T.
		Else
			li++
		EndIf

	************************* FIM   DA  IMPRESSAO *************************

		If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					nTotDeb += SALDODEB
					nTotCrd += SALDOCRD
					nGrpDeb += SALDODEB
					nGrpCrd += SALDOCRD
				EndIf
			EndIf
		Else									// Soma Analiticas
			If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
				If TIPOCONTA == "2"
					nTotDeb += SALDODEB
					nTotCrd += SALDOCRD
					nGrpDeb += SALDODEB
					nGrpCrd += SALDOCRD
				EndIf
			Else							//Se tiver filtragem, somo somente as sinteticas
				If TIPOCONTA == "1"
					If NIVEL1
						nTotDeb += SALDODEB
						nTotCrd += SALDOCRD
						nGrpDeb += SALDODEB
						nGrpCrd += SALDOCRD
					EndIf
				EndIf
			Endif
		EndIf

		dbSkip()
		If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
			If !lJaPulou
				@ li,aColunas[COL_SEPARA1] PSAY "|"
				@ li,aColunas[COL_SEPARA2] PSAY "|"
				@ li,aColunas[COL_SEPARA3] PSAY "|"
				@ li,aColunas[COL_SEPARA4] PSAY "|"
				@ li,aColunas[COL_SEPARA5] PSAY "|"
				If lMov
					@ li,aColunas[COL_SEPARA6] PSAY "|"
					@ li,aColunas[COL_SEPARA7] PSAY "|"
				Else
					@ li,aColunas[COL_SEPARA7] PSAY "|"
				EndIf
				li++
			EndIf
		EndIf
	EndDO

	IF li != 80 .And. !lEnd
		IF li > 58
			@Prow()+1,00 PSAY	Replicate("-",limite)
			CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
			li++
		End
		If mv_par12 == 1							// Grupo Diferente - Totaliza e Quebra
			If cGrupo != GRUPO
				@li,00 PSAY REPLICATE("-",limite)
				li++
				@li,aColunas[COL_SEPARA1] PSAY "|"
				@li,39 PSAY OemToAnsi(STR0018) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
				@li,aColunas[COL_SEPARA3] PSAY "|"
				EXValorCtb(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
				@li,aColunas[COL_SEPARA4] PSAY "|"
				EXValorCtb(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
				@li,aColunas[COL_SEPARA5] PSAY "|"
				If lMov
					nTotMov := nTotMov + (nGrpCrd - nGrpDeb)
					If Round(NoRound(nTotMov,3),2) < 0
						EXValorCtb(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
					ElseIf Round(NoRound(nTotMov,3),2) > 0
						EXValorCtb(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
					EndIf
					@ li,aColunas[COL_SEPARA6] PSAY "|"
				Endif
				@li,aColunas[COL_SEPARA7] PSAY "|"
				li++
				@li,00 PSAY REPLICATE("-",limite)
				li+=2
			EndIf
		EndIf

		@li,00 PSAY REPLICATE("-",limite)
		li++
		@li,aColunas[COL_SEPARA1] PSAY "|"
		@li,39 PSAY OemToAnsi(STR0011)  		//"T O T A I S  D O  M E S : "
		@li,aColunas[COL_SEPARA3] PSAY "|"
		EXValorCtb(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
		@li,aColunas[COL_SEPARA4] PSAY "|"
		EXValorCtb(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
		@li,aColunas[COL_SEPARA5] PSAY "|"
		If lMov
			nTotMov := nTotMov + (nTotCrd - nTotDeb)
			If Round(NoRound(nTotMov,3),2) < 0
				EXValorCtb(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
			ElseIf Round(NoRound(nTotMov,3),2) > 0
				EXValorCtb(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
			EndIf
			@li,aColunas[COL_SEPARA6] PSAY "|"
		EndIf
		@li,aColunas[COL_SEPARA7] PSAY "|"
		li++
		@li,00 PSAY REPLICATE("-",limite)
		li++
		@li,0 PSAY " "
		roda(cbcont,cbtxt,"M")
		Set Filter To
	EndIF

	If mv_par25 ==1
		ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,mv_par08,aQuadro,cDescMoeda,nomeprog,(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,mv_par10)
	EndIf

	If aReturn[5] = 1
		Set Printer To
		Commit
		Ourspool(wnrel)
	EndIf

	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIF
	dbselectArea("CT2")

	MS_FLUSH()

	
Return
	
	
Static Function EXValorCtb(	nSaldo,nLin,nCol,nTamanho,nDecimais,lSinal,cPicture,;
		cTipo,cConta,lGraf,oPrint,cTipoSinal, cIdentifi,lPrintZero,lSay)

	Local aSaveArea	:= GetArea()
	Local cImpSaldo := ""
	Local lDifZero	:= .T.
	Local lInformada:= .T.
	Local cCharSinal:= ""
	Local lEstouro  := IF(Posicione('CT1',1,xFilial('CT1') + CT1->CT1_CONTA,'CT1_ESTOUR') == '1',.T.,.F.)

	lPrintZero := Iif(lPrintZero==Nil,.T.,lPrintZero)

// Nao imprime o valor 0,00
	If !lPrintZero
		If (Int(nSaldo*100)/100) == 0
			lDifZero := .F.			// O saldo nao eh diferente de zero
		EndIf
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipo D -> Default (D/C)												  ³
//³ Tipo S -> Imprime saldo com sinal									  ³
//³ Tipo P -> Imprime saldo entre parenteses (qdo. negativo)	  ³
//³ Tipo C -> So imprime "C" (o "D" nao e impresso)              ³
//³ Tipo N -> Imprime saldo com sinal (-) se o saldo for credor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFAULT cTipoSinal := GetMV("MV_TPVALOR")       // Assume valor default

	DEFAULT lSay := .T.

	cTipo 		:= Iif(cTipo == Nil, Space(1), cTipo)
	nDecimais	:= Iif(nDecimais==Nil,GetMv("MV_CENT"),nDecimais)

	dbSelectArea("CT1")
	dbSetOrder(1)

	If !Empty(cConta) .And. Empty(cTipo)
		If MsSeek(cFilial+cConta)
			cTipo := CT1->CT1_NORMAL
		Endif
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a picture. Caso nao exista espaco, retira os pontos  ³
//³ separadores de dezenas, centenas e milhares 					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cPicture)
		If cTipoSinal $ "D/C"
			cPicture := TmContab(Abs(nSaldo),nTamanho,nDecimais)
		Else
			cPicture := TmContab(nSaldo,nTamanho,nDecimais)
		EndIf
		lInformada  := .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³* Alguns valores, apesar de  terem sinal devem ser impressos  ³
//³ sem sinal (lSinal). Ex: valores de colunas Debito e Credito  ³
//³* Se estiver com a opcao de lingua estrangeira (lEstrang) a   ³
//³ picture sera invertida para exibir valores: 999,999,999.99   ³
//³* O tipo de sinal "D" - default nao leva em consideracao a    ³
//³ a natureza da conta. Dessa forma valores negativos serao	  ³
//³ impressos sem sinal, e ao seu lado "D" (Devedor) e valores   ³
//³ positivos terao um "C" (Credito) impresso ao seu lado.       ³
//³* O tipo de Sinal "P" - Parenteses, imprimira valores de saldo³
//³  invertidos da condicao normal da conta entre parenteses.	  ³
//³* O tipo de Sinal "S" - Sinal, imprimira valores de saldo in- ³
//³  vertidos da condicao normal da conta com sinal - 			  ³
//³EXEMPLOS  -  EXEMPLOS  -  EXEMPLOS	-	EXEMPLOS  - EXEMPLOS   ³
//³Cond Normal 	Saldo 	Default      Sinal   Parenteses		  ³
//³	D			   -1000	   1000 D 		 1000		 1000			  	  ³
//³	D				 1000 	1000 C		-1000 	(1000)			  ³
//³	C				-1000 	1000 D		-1000 	(1000)			  ³
//³	C				 1000 	1000 C		 1000 	 1000 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// So imprime valor se for diferente de zero!
	If lDifZero
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Neste caso (Default), nao importa a natureza da conta! Saldos³
	//³ devedores serao impressos com "D" e credores com "C".        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Neste caso, nao importa a natureza da conta!!
		If cTipoSinal == "D" .Or. cTipoSinal == "C" .Or. cTipoSinal == "N"			// D(Default) ou C(so Credito)
			If !lInformada
				cPicture := "@E " + cPicture
			Endif
			If lSinal
				If nSaldo < 0
					If lGraf
						If cTipoSinal == "D"
							cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
						EndIf
					Else
					// No Tipo C -> so sao impressos os "C´s"
						If cTipoSinal == "D"
							cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
						EndIf
					Endif
				ElseIf nSaldo > 0
					If lGraf
						If cIdentifi # Nil .And. cIdentifi $ "34"
							If cTipoSinal == "D"
								cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
							EndIf
						Else
							cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
						Endif
					Else
						cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
					Endif
				EndIf
				cCharSinal := " "+cCharSinal
			EndIf
		                           
		//Se o parametro MV_TPVALOR == "N" => nao considera a condicao normal da conta. 
		//So imprime sinal (-) se o saldo for credor. 
			If cTipoSinal == "N"
				If lSinal
					cImpSaldo := Transform(nSaldo*(-1),cPicture)
				Else
					cImpSaldo := Transform(ABS(nSaldo),cPicture)
				EndIf
			Else
				cImpSaldo := Transform(Abs(nSaldo),cPicture)+cCharSinal
			EndIf
		
			If lGraf
				If cIdentifi # Nil .And. cIdentifi $ "34"
					If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
						oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
					Else
						oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
					EndIf
				Else
					oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
				Endif
			ElseIf lSay
				@ nLin, nCol pSay cImpSaldo
			Endif
		
		Else
		//Utiliza conceito de conta estourada e a conta eh redutora.
			If Select("cArqTmp") > 0 .And. cArqTmp->(FieldPos("ESTOUR")) <> 0 .And.  CT1->CT1_ESTOUR == '1'
				If cTipo == "1" 								// Conta Devedora
					If cTipoSinal == "S"              			// Sinal
						If !lSinal
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Else
							cImpSaldo := Transform(nSaldo,cPicture)
						Endif
					ElseIf (cTipoSinal) == "P"              	// Parenteses
						If !lSinal
							nSaldo := Abs(nSaldo)
						EndIf

						If !lInformada
							cPicture := "@E( " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol pSay nSaldo Picture cPicture
						Else
							cImpSaldo := Transform(nSaldo,cPicture)
						Endif
					EndIf
				Else
					If (cTipoSinal) == "S"                  	// Sinal
						If lSinal
							nSaldo := nSaldo * (-1)
						Else
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Else
							cImpSaldo := Transform(nSaldo,cPicture)
						Endif
					ElseIf (cTipoSinal) == "P"              // Parenteses
						If lSinal
							nSaldo := nSaldo * (-1)
//					If !lSinal .And. cTipo == "2" 			// Conta Credora
						Else
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E( " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			// Debito
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol pSay nSaldo Picture cPicture
						Else
							cImpSaldo := Transform(nSaldo,cPicture)
						Endif
					EndIf
				EndIf
			Else	//Se nao utiliza conceito de conta estourada
				If cTipo == "1" 								// Conta Devedora
					If cTipoSinal == "S"              			// Sinal
						If lSinal
							nSaldo := nSaldo * (-1)
						Else
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Else
							cImpSaldo := Transform(nSaldo,cPicture)
						Endif
					ElseIf (cTipoSinal) == "P"              	// Parenteses
						If lSinal
							nSaldo := nSaldo * (-1) 		  		// a Picture so exibe parenteses para numeros negativos
						Else
							nSaldo := Abs(nSaldo)
						EndIf
        	
						If !lInformada
							cPicture := "@E( " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol pSay nSaldo Picture cPicture
						Else
							cImpSaldo := AllTrim(Transform(nSaldo,cPicture))
						Endif
					EndIf
				Else
					If (cTipoSinal) == "S"                  	// Sinal
						If !lSinal .And. cTipo == "2" 			// Conta Credora
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Else
							cImpSaldo := Transform(nSaldo,cPicture)
						Endif
					ElseIf (cTipoSinal) == "P"              // Parenteses
						If !lSinal .And. cTipo == "2" 			// Conta Credora
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E( " + cPicture
						EndIf
						If lGraf
							cImpSaldo := Transform(nSaldo,cPicture)			// Debito
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,cImpSaldo,oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol pSay nSaldo Picture cPicture
						Else
							cImpSaldo := Transform(nSaldo,cPicture)
						Endif
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	RestArea(aSaveArea)
         
	If lSay
		Return
	Else
		If Empty( cImpSaldo )
			If lPrintZero
				cImpSaldo := Transform(nSaldo,cPicture)
			EndIf
		EndIf
		Return cImpSaldo
	EndIf

	
	
