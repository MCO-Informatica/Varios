#INCLUDE "Totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA028    º Autor ³ Renato Ruy	     º Data ³  12/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz atualização de valores no lançamento de remuneração.   º±±
±±º          ³ 					                      					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA028


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oDlg
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.

Private cRemPer		:= AllTrim(GetMV("MV_REMMES"))

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Leitura de Dados do GAR e Atualização via WebService" PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 25,10 SAY "Periodo" OF oDlg PIXEL
@ 25,70 MSGET cRemPer SIZE 072,010 OF oDlg PIXEL

@ 45,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CRPA028A(@aDirIn,@cDirIn)
@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1
	Return(.F.)
EndIf

If len(aDirIn) = 0
	MsgAlert("Não Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

Proc2BarGauge({|| OkLeTxt(cDirIn,aDirIn) },"Processamento de Arquivo TXT")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  12/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt(cDirIn,aDirIn)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nIGeral := 0

Private cArqTxt := ""
Private nHdl    := ""

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nIGeral:= 1 to len(aDirIn)
	cArqTxt := cDirIn+aDirIn[nIGeral][1]
	nHdl    := fOpen(cArqTxt,68)
	//	If nHdl == -1
	//    	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	//	Endif
	IncProcG1("Proc. Arquivo "+aDirIn[nIGeral][1])
	ProcessMessage()
	RunCont()
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  12/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos, xBuff, aLin, cTipLin
Local nRecAtu 		:= 1
Local cPedido 		:= ""
Local cProduto		:= ""
Local nValSoft		:= 0
Local nValHard		:= 0
Local cProjeto		:= ""
Local cPosto		:= ""
Local cPedTipo		:= ""
Local cTipEnt		:= ""
Local cObs			:= ""
Local cRecPost		:= ""
Local cCodPar		:= ""
Local cCodPosto		:= ""
Local cCodAR		:= ""
Local cQuebra		:= ""
Local cCodAC		:= ""
Local cCodCanal		:= ""
Local cCodCanal2	:= ""
Local cCodFeder		:= ""
Local aStrucSZ6		:= SZ6->( DbStruct() )
Local aDadosSZ6		:= {}
Local nI			:= 0
Local nJ			:= 0
Local nK			:= 0
Local nX			:= 0
Local nZ			:= 0
Local cCampo		:= ""
Local cStEntid		:= ""
Local nBaseSw		:= 0
Local nValSw		:= 0
Local cRegSw		:= 0
Local nBaseHw		:= 0
Local nValHw		:= 0
Local cRegHw		:= ""
Local cTipoGar		:= GetMV("MV_TIPGAR") // VERIFI;EMISSA;HWAVUL;ENTMID;CAMPCO;CLUBRE
Local cCalcRem		:= ""
Local nQtdReg		:= 0
Local cFxCodEnt		:= ""
Local cChaveSZ4		:= ""
Local cFaixa		:= ""
Local lProdConta	:= .F.
Local lVoucher		:= .F.
Local lPed			:= .F.
Local nValorSw		:= 0
Local nValorHw		:= 0
Local nValSoft 		:= 0
Local nValHard 		:= 0
Local nValTot       := 0
Local nValTotHW     := 0
Local nValTotSW     := 0
Local nAbtCamH 	    := 0
Local nAbtCamS      := 0
Local cTipPar       := ""
Local cCodPar       := ""
Local cDesPar       := ""
Local cCodVen 		:= ""
Local cNomVen 		:= ""
Local cObs			:= ""
Local cDesRede		:= ""
Local nPorSfw		:= 0
Local nPorHdw		:= 0
Local nImpCamp		:= 0
Local cDescPrd		:= ""
Local cTipo			:= ""
Local cOABSP		:= "8DSAS6/GAOAB"//SuperGetMv("MV_OABSPCL",.F.,"")
Local nValOAB		:= 77.50//SuperGetMv("MV_VALOAB",.F.,77.50)
Local lMidiaAvulsa  := .F.
Local cAbateCcrAC	:= "" //Variável para gravar se abate CCR e GRUPO\Rede(AC) do Canal 1 e 2.
Local nAbtAR		:= 0 //Variável para gravar se abate CCR e GRUPO\Rede(AC) do Canal 1 e 2.
Local nAbtAC		:= 0 //Variável para gravar se abate CCR e GRUPO\Rede(AC) do Canal 1 e 2.
Local cAbateCamp	:= "" //Variável para gravar se campanha do contator do Canal 1 e 2.
Local nValorAbtHw	:= 0  //Armazena Valor da CCR para abatimento
Local nValorAbtSw	:= 0  //Armazena Valor da AC para abatimento
Local dDataIRenov   := MV_PAR01 //Armazena data inicio para calculo da renovação.
Local dDataFRenov   := MV_PAR02 //Armazena data fim para calculo da renovação.
Local lProdCalc		:= .T. //Indica se efetua calculo para AC, Canal, Canal 2 e Remunera o dono do Produto.
Local cAcPropri		:= "" //Caso o produto seja especifico de uma AC, guarda entidade proprietária.
Local cDescProd	:= ""
Local nRecSZ3		:= 0
Local lTemHard		:= .F.
Local nRecnoZ5		:= 0
Local lNaoPagou		:= .T.
Local lCalcCam		:= .F.
Local lOriCamp		:= .F.
Local cVouAnt		:= ""
Local cCodCCR			:= ""
Local cDesCCR			:= ""
Local nPerc			:= 0
Local nCiclo		:= 0
Local nI,nJ,nK,nZ,nX
Private lLogErr		:= .F.
Private ltemFaixa   := .F.

//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
//º Lay-Out do arquivo Texto gerado:                                º
//ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
//ºCampo           ³ Inicio ³ Tamanho                               º
//ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
//º ??_FILIAL      ³ 01     ³ 02                                    º
//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

FT_FUSE(cArqTxt)

nTotRec := FT_FLASTREC()
BarGauge2Set( nTotRec )

FT_FGOTOP()

While !FT_FEOF()
	
	xBuff	:= alltrim(FT_FREADLN())
	
	//Faço tratamento para não gerar erro nas colunas
	While ";;" $ xBuff
		xBuff	:= StrTran(xBuff,";;",";-;")
	EndDo
	
	aLin 	:= StrTokArr(xBuff,";")
	
 	cPedido 	:= Iif(Len(aLin)>0,aLin[1],"ZZZZZZZZZZ")	   			//aLin[1] = Pedido Gar
	nValSoft	:= Val(AllTrim(StrTran(Iif(Len(aLin)>1,aLin[2],"0"),",",".")))	   //aLin[2] = Valor Software
	nValHard	:= Val(AllTrim(StrTran(Iif(Len(aLin)>2,aLin[3],"0"),",",".")))	   //aLin[3] = Valor Hardware
	//"G" = Pedido Gar e "S" Pedido Site
	cPedTipo	:= Iif(Len(aLin)>3,aLin[4],"") 			   				//aLin[4] = Classifica o tipo de Pedido
	cTipEnt		:= Iif(Len(aLin)>4,aLin[5],"")			   				//aLin[5] = Tipo de Entidade
	cObs		:= Iif(Len(aLin)>5,aLin[6],"")			   				//aLin[6] = Observacao da retificacao
	nPerc		:= Val(Iif(Len(aLin)>6,aLin[7],""))			   			//aLin[7] = Percentual
	cPosto 		:= Iif(Len(aLin)>7,aLin[8],SZ5->Z5_CODPOS)				//aLin[8] = Código do Posto
	cDesRede	:= Iif(Len(aLin)>9,aLin[10],SZ5->Z5_DESREDE)			//aLin[10] = Descricao da rede
	
	/* 	Tipos de Entidade
	 	1 = Canal 			(Ni = 3 e 4)
	 	2 = RedeGrupo		(Ni = 2)
	 	3 = AR				(Ni = 7)
	 	4 = Posto			(Ni = 1)
	 	5 = Grupo			(Ni = 2)
	 	6 = Rede			(Ni = 2)
	 	7 = Campanha		(Ni = 6)
	 	8 = Federação		(Ni = 5)
	 	9 = CCR				(Sem Ni)
	 	10 = Revendedor		(Ni = 6)
	 	11 = SAGE			(Ni = 8)
	*/
	
	If !Empty(cTipEnt)
		nCiclo := CRP028Seq(cTipEnt)
	EndIf
	
	//Não faço calculo para pedido em branco.
	If Val(cPedido)==0
		FT_FSKIP()
		Loop
	EndIf
	
	IncprocG2( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
	ProcessMessage()
	
	dbSelectArea("SZ6")
	SZ6->(dbSetOrder(1))
	SZ6->(dbSeek(xFilial("SZ6") + cPedido))
	
	/*While SZ6->(!EOF()) .And. AllTrim(SZ6->Z6_PEDGAR) == AllTrim(cPedido)
		If SZ6->Z6_TIPO == "RETIFI" 
			RecLock("SZ6",.F.)
				dbDelete()
			SZ6->(MsUnlock())
		EndIf
		SZ6->(dbSkip())
	EndDo */
	
	//Faço Tratamento para pedido site.
	DbSelectArea("SZ5")
	DbSetOrder(1)
	If cPedTipo == "S"
		
		DbSelectArea("SC5")
		DbOrderNickName("PEDSITE")
		If DbSeek( xFilial("SC5")+AllTrim(cPedido) )
			
			DbSelectArea("SZ5")
			DbSetOrder(3)
			If !DbSeek(xFilial("SZ5") + SC5->C5_NUM)
				FT_FSKIP()
				Loop
			EndIf
		EndIf
	Elseif !DbSeek(xFilial("SZ5")+AllTrim(cPedido))
		If AllTrim(Str(Val(cPedido))) == "0" .And. nRecAtu > 1
			MsgInfo("Pedido gar não formatado corretamente para o pedido: " + AllTrim(cPedido) + " verifique espaços e caracteres incorretos")
		EndIf
		FT_FSKIP()
		Loop
	EndIf
	
	If Upper(cProjeto) == "Z"
		cProjeto := SZ5->Z5_DESGRU
	EndIf
	
	If Upper(cPosto) == "Z" .And. !(AllTrim(cTipEnt) $ "R/S")
		cPosto := Posicione("SZ3",4,xFilial("SZ3")+SZ5->Z5_CODPOS,"Z3_CODENT")
	Elseif !(AllTrim(cTipEnt) $ "R/S")
		//Renato Ruy - 03/03/2017
		//Formata o código do posto.
		cPosto := Iif(Val(cPosto)>0,PadL(AllTrim(cPosto),6,"0"),cPosto)
	EndIf
	
	// Verifico para se o conteúdo não é Texto.
	If cPedido < "9999999999" .And. AllTrim(SZ5->Z5_CODAC) != "NAOREM" //.And. !("SINRJ" $ AllTrim(SZ5->Z5_PRODGAR))
		
		DbSelectArea("SZ5")
		DbSetOrder(1)
		If DbSeek(xFilial("SZ5")+AllTrim(cPedido)) .And. (cPedTipo == "G" .Or. Empty(cPedTipo))
			
			//Me Posiciono Na Entidade para iniciar calculo
			SZ3->(DbSetOrder(1))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR
			If SZ3->(DbSeek(xFilial("SZ3") + cPosto))
				nRecSZ3 := SZ3->(Recno())
			Elseif !(AllTrim(cTipEnt) $ "R/S")
				MsgInfo("A entidade: " + cPosto + " do pedido: " + cPedido + " não pode ser localizada!")
			Endif
			
			nRecnoZ5		:= SZ5->(Recno())
		Else
			DbSelectArea("SC5")
			SC5->(DbOrderNickName("PEDSITE"))
			If DbSeek( xFilial("SC5")+AllTrim(cPedido) )
				
				DbSelectArea("SZ5")
				DbSetOrder(3)
				If !DbSeek(xFilial("SZ5") + SC5->C5_NUM)
					FT_FSKIP()
					Loop
				Else
					//Me Posiciono Na Entidade para iniciar calculo
					SZ3->(DbSetOrder(1))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR
					If SZ3->(DbSeek(xFilial("SZ3") + cPosto))
						nRecSZ3 := SZ3->(Recno())
					Else
						MsgInfo("A entidade: " + cPosto + " do pedido: " + cPedido + " não pode ser localizada!")
					Endif
				EndIf
			EndIf
		EndIf
		
		
		//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
		// Pesquisa se existe calculo anterior e limpa para recalcular //
		//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
		lMidiaAvulsa := (SZ5->Z5_TIPO == 'ENTHAR')
		
		// Limpa campo de observacao do calculo de comissao na SZ5
		CRP020GrvErro("")
		
		// Verifica o tipo de processo Gar gera remuneracao e trata-se de uma verificacao
		If !Alltrim(SZ5->Z5_TIPO) $ cTipoGar
			FT_FSKIP()
			Loop
		Endif
		lTemHard := .F.
		If !(lMidiaAvulsa)
			//Identifica a categoria do produto para posicionamento na tabela de regras de cálculo da entidade
			PA8->( DbSetOrder(1) )		// PA8_FILIAL + PA8_CODBPG
			If PA8->( !MsSeek( xFilial("PA8") + SZ5->Z5_PRODGAR ) )
				CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> PRODUTO NAO LOCALIZADO NO CADASTRO DE CLASSIFICAÇÃO DE PRODUTOS: " + AllTrim(SZ5->Z5_PRODGAR) )
				cCatProd :='NE' //Não encontrado
				//SZ5TMP->( DbSkip() )
				//Loop
			Else
				
				SG1->(DbsetOrder(1))
				If SG1->(DbSeek( xFilial("SG1") + PA8->PA8_CODMP8))
					lTemHard := .T.
				EndIf
				
				If Empty(PA8->PA8_CATPRO)
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> PRODUTO NAO CLASSIFICADO PARA REMUNERACAO DE PARCEIROS: " + AllTrim(PA8->PA8_CODBPG) )
					cCatProd :='NE' //Não encontrado
					//SZ5TMP->( DbSkip() )
					//Loop
				ELSE
					cCatProd := PA8->PA8_CATPRO
				Endif
				//Verifica se deve realizar contagem do produto para faixa de remuneração.
				If PA8->PA8_CONCER == "1"
					lProdConta := .T.
				Endif
				
			Endif
		Else
			cCatProd:='01' //Produtos Certisign
		Endif
		
		
		
		/*
		BEGINDOC
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tipos de entidades existentes                                                  ³
		//³                                                                               ³
		//³1=Canal;                                                                       ³
		//³2=AC;                                                                          ³
		//³3=AR;                                                                          ³
		//³4=Posto;                                                                       ³
		//³5=Grupo;                                                                       ³
		//³6=Rede                                                                         ³
		//³7=Revendedor                                                                   ³
		//³8=Federação                                                                    ³
		//³9=CCR                                                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ENDDOC
		*/
		
		//Identifica o código CCR de comissão amarrado ao posto
		cCodPosto	:= SZ5->Z5_CODPOS  //Posto
		cCodCCR	:= SZ3->Z3_CODCCR
		cCodAr		:= SZ3->Z3_CODAR 			//AR associado ao posto
		cQuebra	:= SZ3->Z3_QUEBRA			//2-CARTORIO OU 1=CCR
		If Empty(SZ3->Z3_CODCCR)
			cCodFeder	:= SZ3->Z3_CODFED			//Federação. Entidade politica associada ao posto de atendimento
			cCodAC		:= SZ3->Z3_CODAC			//Grupo/Rede. Entidade que agrupa vários postos de redes GAR.
			cCodCanal	:= SZ3->Z3_CODCAN 		//Canal  associado ao posto
			cCodCanal2	:= SZ3->Z3_CODCAN2		//Canal2 associado ao posto
			cDesCCR	:= ""
		Else
			SZ3->(DbSetOrder(1))
			SZ3->(MsSeek(xFilial("SZ3") + cCodCCR))
			cDesCCR    := SZ3->Z3_DESENT
			cCodFeder	:= SZ3->Z3_CODFED			//Federação. Entidade politica associada ao posto de atendimento
			cCodAC		:= SZ3->Z3_CODAC			//Grupo/Rede. Entidade que agrupa vários postos de redes GAR.
			cCodCanal	:= SZ3->Z3_CODCAN 		//Canal  associado ao posto
			cCodCanal2	:= SZ3->Z3_CODCAN2		//Canal2 associado ao posto
		Endif
		cCodParc	:= SZ5->Z5_CODPAR  //Parceiro Revendedor que deve ser remunerado (- Buscar código no cadastro de parceiros - não está amarrado ao posto)
		cTipPar     := ""
		cCodPar     := ""
		cDesPar     := ""
		cCodVen 	:= ""
		cNomVen 	:= ""
		cAcPropri   := ""
		
		//Solicitante: Suzane / Tânia - 23/04/15
		//Me posiciono no Canal para verificar se faço abatimento.
		SZ3->(DbSetOrder(1))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR
		SZ3->(!MsSeek(xFilial("SZ3") + AllTrim(cCodCanal) ))
		
		//Gravo através da AC, se deverá descontar os valores da AC e CCR na remuneração do Canal.
		//Solicitante: Priscila Kuhn - Data: 02/01/2015 - Valida através do produto para calcula o abatimento para calculo do canal.
		If SubStr(SZ5->Z5_PRODGAR,1,3) $ "REG/NOT/SIN" .Or. SZ3->Z3_DEVLAR == "1"
			cAbateCcrAC := "1"
		Else
			cAbateCcrAC := "0"
		EndIf
		
		//Me Posiciono Novamente no posto para dar continuidade nas atividades
		SZ3->(DbGoTo(nRecSZ3))
		
		//Priscila Kuhn - 12/03/15
		//Buscar posto de verificação para casos onde foi validado pela Central de Verificação
		If "CENTRAL" $ Upper(SZ3->Z3_DESENT)
			If !Empty(SZ5->Z5_POSVER)
				cCodPosto := SZ5->Z5_POSVER
				
				//Me Posiciono Novamente no posto verificação para dar continuidade nas atividades
				SZ3->(DbSetOrder(6))//Z3_FILIAL+Z3_TIPENT+Z3_CODGAR
				SZ3->(!MsSeek(xFilial("SZ3") + "4" + cCodPosto))
				
				cCodCCR		:= SZ3->Z3_CODCCR
				cCodFeder	:= SZ3->Z3_CODFED	//Federação. Entidade politica associada ao posto de atendimento
				cCodAC      := SZ3->Z3_CODAC    //Grupo/Rede. Entidade que agrupa vários postos de redes GAR.
				cCodCanal   := SZ3->Z3_CODCAN   //Canal  associado ao posto
				cCodCanal2  := SZ3->Z3_CODCAN2  //Canal2 associado ao posto
				cCodParc	:= SZ5->Z5_CODPAR  //Parceiro Revendedor que deve ser remunerado (- Buscar código no cadastro de parceiros - não está amarrado ao posto)
				
			EndIf
		EndIf
		
		//Valido se o produto e da AC ou pertence a outra.
		
		lProdCalc := .T. //Alimento a variável com .T. e será validada em seguida.
		cCalcRem  := ""
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Cálculo de remuneracao conforme "piramide" definida no cadastro de entidade          ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		// Sequência de comissao de baixo para cima onde;
		// nI == 1  --> Posto /CCRcomissão
		// nI == 2  --> Grupo/Rede
		// nI == 3  --> Canal
		// nI == 4  --> Canal2
		// nI == 5  --> Federacao
		// nI == 6  --> Verificacao Campanha do Contador / Clube do Revendedor
		// nI == 7  --> Verificacao Campanha do Contador / Clube do Revendedor
		
		//Zerar o valor acumulado de abatimento no Canal 1 e 2.
		nAbtAR	:= 0
		nAbtAC  := 0
		nAbtImp := 0
		cCalcIFEN := "" //Variavel para armazena se calcula o produto IFEN.
		nValorAbtHw := 0
		nValorAbtSw := 0
		
		For nI := 1 To 7
			
			nQtdReg	:= 0
			nValSw  := 0
			nValHw  := 0
			nBaseSw := 0
			nBaseHw := 0
			nValTot := 0
			nValTotHW:= SZ5->Z5_VALORHW
			nValTotSW:= SZ5->Z5_VALORSW
			cTipPar := ""
			cCodPar := ""
			cDesPar := ""
			cAbateCcrAC := ""
			lOriCamp	:= .F.
			cAbateCamp 	:= "" //25/06/15 - faltou declarar a variável. Será atualizada somente no laço FOR da entidade que necessita desta condição.
			ltemFaixa:=.f.
			
			If AllTrim(cTipEnt) == "T"
				nCiclo := Ni
			EndIf
			
			//Solicitante: Priscila Kuhn - 24/07/15
			//Tratamento para produto IFEN
			If SubStr(AllTrim(SZ5->Z5_PRODGAR),1,4) == "IFEN"
				
				//Renato Ruy - Atualiza valores conforme tabela de preço IFEN - ZZ9.
				ZZ9->(DbSetOrder(2))
				If ZZ9->(DbSeek(xFilial("ZZ9")+SZ5->Z5_PRODGAR))
				    
					While AllTrim(ZZ9->ZZ9_PROD) == AllTrim(SZ5->Z5_PRODGAR)
						If ZZ9->ZZ9_DTINI <= SZ5->Z5_DATPED .And. ZZ9->ZZ9_DTFIM >= SZ5->Z5_DATPED
							If 'RENOVACAO' $ UPPER(SZ5->Z5_DESGRU)
								nValTotHW:= 0
								nValTotSW:= ZZ9->ZZ9_VLRENO
							Else
								nValTotHW:= ZZ9->ZZ9_VALHW
								nValTotSW:= ZZ9->ZZ9_VALSW
							EndIf
						EndIf
					EndDo
				
				EndIf
				
				//Caso não encontre o valor preenchido, uso valor importado para SZ5.
				If nValTotHW + nValTotSW == 0
					nValTotHW:= SZ5->Z5_VALORHW
					nValTotSW:= SZ5->Z5_VALORSW
				EndIf
				
				//Renato Ruy - 03/02/16
				//Alteração para validar Tabela de Voucher IFEN.
				ZZ4->(DbSetOrder(1))
				If ZZ4->(DbSeek(xFilial("ZZ4")+SZ5->Z5_PEDGAR)) .And.;
				   ((DtoS(ZZ4->ZZ4_DATVER) > " " .And. Empty(ZZ4->ZZ4_PEDORI)) .Or.;
				    (DtoS(ZZ4->ZZ4_DATVER) == " " .And. !Empty(ZZ4->ZZ4_PEDORI)))
				    
				    nValTotHW:= 0
					nValTotSW:= 0 
					cTiped	 := "RECEBANT"
					
				EndIf
				
			EndIf
			
			If nValSoft+nValHard <> 0
				nValTotSW:= nValSoft
				nValTotHW:= nValHard
				If nValTotHw <> 0
					lTemHard := .T.
				EndIf
			EndIf
			
			Do Case
				Case nI == 1 //Posto ou CCR
				
					//Efetua busca dos dados de percentual
					IF !EMPTY(cCodCCR)
						
						SZ3->(DbSetOrder(1)) // Z3_FILIAL + Z3_TIPENT + CÓDIGO CCR
						IF SZ3->(MsSeek(xFilial("SZ3") + cCodCCR))
							cCalcRem	:= SZ3->Z3_TIPCOM   //Define de deve calcular comissão para a CCRCOMISSAO do posto e a estrutura de parceiros associados a ele.
							cAbateCamp	:= SZ3->Z3_REMCAM   //Define se abate valor no calculo da campanha.
						ENDIF
					ELSE
						If Empty(cCalcRem)
							cCalcRem	:= SZ3->Z3_TIPCOM   //Define de deve calcular comissão para ao posto e a estrutura de parceiros associados a ele.
							cAbateCamp	:= SZ3->Z3_REMCAM   //Define se abate valor no calculo da campanha.
						Else
							//Posiciona no posto para remunerar a verificação.
							SZ3->(DbGoTo(nRecSZ3))
							cAbateCamp	:= SZ3->Z3_REMCAM   //Define se abate valor no calculo da campanha.
						EndIf
					ENDIF
					
					If !AllTrim(cTipEnt) $ "P|T"
						Loop
					Endif
					
					//Yuri Volpe - 03/12/2018
					//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
					If Substr(AllTrim(SZ5->Z5_PRODGAR),1,4) != "IFEN"
						//Renato Ruy - 22/03/2018
						//Bloqueio de recalculo de faixa quando existe planilha ativa
						ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
						If ZZG->(DbSeek(xFilial("ZZG")+cRemPer+cCodCCR+"1"))
							MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
							Return	.F.
						Endif
					EndIf
					
					If cCalcRem <> "1" // Calcula comissao (Z3_TIPCOM) diferente de Sim (1)
						CRP020GrvErro("PEDIDO GAR: " + SZ5->Z5_PEDGAR +" ---> NAO CALCULA REMUNERACAO PARA O POSTO " + cCodPosto+"/ CCR: "+cCodCCR)
						//Calcula apenas comissão sobre a venda.
						//Vai direto para o calculo do parceiro (revendedor/contator) nI RECEBE 6
						//nI:=6 //Removido para calcular remuneração para o posto mesmo zerada.
					Endif
					
				Case nI == 2  //Grupo/Rede
					
					//Valido se o produto e da AC ou pertence a outra.
					lProdCalc := .T. //Alimento a variável com .T. e será validada em seguida.
					cAcPropri := ""
		
					
					//Solicitante: Priscila Kuhn
					//Valida se o produto pertence ao Produtos REG, SIN ou NOT.
					If "REG" $ SZ5->Z5_PRODGAR .OR. "NOT" $ SZ5->Z5_PRODGAR	.OR. "SIN" $ SZ5->Z5_PRODGAR .OR. "SINRJ" $ SZ5->Z5_PRODGAR
						//Caso o produto não pertença ao Grupo/Rede
						If !(("REG" $ SZ5->Z5_PRODGAR .And. !"SERVEREG" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "BR")  .OR. ;
							("NOT" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "NOT") .OR. ;
							("SIN" $ SZ5->Z5_PRODGAR .And. !"SINRJ" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "SIN") .OR. ;
							("SINRJ" $ SZ5->Z5_PRODGAR .And. AllTrim(cCodAC) == "SINRJ"))
							
							//produto não pertence ao grupo/rede paga o "dono" do produto controlado pela variavel lProdCalc e cAcPropri na geração do registro na SZ6.
							lProdCalc := .F. 
							
							If "REG" $ SZ5->Z5_PRODGAR
								cAcPropri := Padr("BR",6," ")
							ElseIf "NOT" $ SZ5->Z5_PRODGAR
								cAcPropri := Padr("NOT",6," ")
							ElseIf "SINRJ" $ SZ5->Z5_PRODGAR
								cAcPropri := Padr("SINRJ",6," ")
							ElseIf  "SIN" $ SZ5->Z5_PRODGAR
								cAcPropri := Padr("SIN",6," ")
							EndIf
						EndIf
					EndIf
					//Fim da Validação de Produto x AC.
					
					If cCalcRem <> "1" .or. (Empty(cCodAc) .And. Empty(cAcPropri)) .or. !AllTrim(cTipEnt) $ "A|T|" // Calcula comissao (Z3_TIPCOM) diferente de Sim (1)
						Loop
					Endif
					
					SZ3->( DbSetOrder(1) )
					If Empty(cAcPropri)
						If SZ3->( !MsSeek( xFilial("SZ3") + cCodAc ) )
							CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> NÃO FOI ENCONTRADO O CADASTRO DO GRUPO/REDE "+cCodAc+" DO POSTO " + cCodPosto)
							Loop
						Endif
					Else
						If SZ3->( !MsSeek( xFilial("SZ3") + cAcPropri ) )
							CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> NÃO FOI ENCONTRADO O CADASTRO DO GRUPO/REDE "+cCodAc+" DO POSTO " + cCodPosto)
							Loop
						Endif
					EndIf
					// TRATAR FAIXA DE PRODUTOS DEPOIS DO FECHAMENTO DE JULHO. GIOVANNI 26/06/2015
					//SZV->(DbSetOrder(1) )
					//ltemFaixa:=SZV->( DbSeek( xFilial("SZV")+ cCodAc + Left( cRemPer, 4 ) ) )
					
					//Yuri Volpe - 03/12/2018
					//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
					If Substr(AllTrim(SZ5->Z5_PRODGAR),1,4) != "IFEN"
						//Renato Ruy - 22/03/2018
						//Bloqueio de recalculo de faixa quando existe planilha ativa
						cCodAc := Iif(Empty(cAcPropri),cCodAc,cAcPropri)
						ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
						If ZZG->(DbSeek(xFilial("ZZG")+cRemPer+cCodAc+"1"))
							MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
							Return	.F.
						Endif
					EndIf
					
				Case nI == 3 //Canal
					
					//Solicitante: Priscila - 26/12/14
					//Valida Canal remunerado x Tipo de produto
					//Solicitante: Priscila Kuhn - Data: 02/01/2015 - Valida através do produto para calcula o abatimento para calculo do canal.
					// Desconta do canal valores pagos para o grupo/Rede e CCR/POSTO
					If ("REG" $ SZ5->Z5_PRODGAR .And. !"SERVEREG" $ SZ5->Z5_PRODGAR) .Or. "NOT" $ SZ5->Z5_PRODGAR
						cCodCanal := "CA0002" //Produto com inicio REG e NOT remuneram a PP Consultoria
						cAbateCcrAC := "1"
					ElseIf "SIN" $ SZ5->Z5_PRODGAR
						cCodCanal := "CA0001" //Produto com início SIN remuneram a VIA
						cAbateCcrAC := "1"
					ElseIf "IFEN" $ SZ5->Z5_PRODGAR
						cCodCanal := "CA0009"
					EndIf
					
					//Fim da alteração - 26/12/14
					If cCalcRem <> "1" .OR. Empty(cCodCanal) .OR. !AllTrim(cTipEnt) $ "C|T|"//.OR. !lProdCalc // Calcula comissao (Z3_TIPCOM) diferente de Sim (1) e se o produto é da AC.
						Loop
					EndIf
					
					//Yuri Volpe - 03/12/2018
					//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
					If Substr(AllTrim(SZ5->Z5_PRODGAR),1,4) != "IFEN"
						//Renato Ruy - 22/03/2018
						//Bloqueio de recalculo de faixa quando existe planilha ativa
						ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
						If ZZG->(DbSeek(xFilial("ZZG")+cRemPer+cCodCanal+"1"))
							MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
							Return	.F.
						Endif
					EndIf
					
					SZ3->( DbSetOrder(1) )
					If SZ3->( !MsSeek( xFilial("SZ3") + cCodCanal ) )
						CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> NÃO FOI ENCONTRADO O CADASTRO DO CANAL" +cCodCanal+" DO POSTO " + cCodPosto)
						Loop
					Endif
					
					//Solicitante: Suzane / Tânia - 23/04/15
					//Gravo através da AC, se deverá descontar os valores da AC e CCR na remuneração do Canal.
					If  SZ3->Z3_DEVLAR == "1"
						cAbateCcrAC := "1"
					EndIf
					
				Case nI == 4 //Canal2
					If cCalcRem <> "1" .OR. Empty(cCodCanal2) .OR. !AllTrim(cTipEnt) $ "C|T|" //.OR. !lProdCalc // Calcula comissao (Z3_TIPCOM) diferente de Sim (1) e se o produto é da AC.
						Loop
					EndIf
					
					//Yuri Volpe - 03/12/2018
					//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
					If Substr(AllTrim(SZ5->Z5_PRODGAR),1,4) != "IFEN"					
						//Renato Ruy - 22/03/2018
						//Bloqueio de recalculo de faixa quando existe planilha ativa
						ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
						If ZZG->(DbSeek(xFilial("ZZG")+cRemPer+cCodCanal2+"1"))
							MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
							Return	.F.
						Endif
					EndIf
					
					SZ3->( DbSetOrder(1) )
					If SZ3->( !MsSeek( xFilial("SZ3") + cCodCanal2 ) )
						CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> NÃO FOI ENCONTRADO O CADASTRO DO CANAL2" +cCodCanal2+" DO POSTO " + cCodPosto)
						Loop
					Endif
					
				Case nI == 5 //Federação
					If cCalcRem <> "1" .OR. Empty(cCodFeder) .OR. !AllTrim(cTipEnt) $ "F|T|" //.OR. !lProdCalc// Calcula comissao (Z3_TIPCOM) diferente de Sim (1) e se o produto é da AC.
						Loop
					Endif
					
					//Yuri Volpe - 03/12/2018
					//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
					If Substr(AllTrim(SZ5->Z5_PRODGAR),1,4) != "IFEN"
						//Renato Ruy - 22/03/2018
						//Bloqueio de recalculo de faixa quando existe planilha ativa
						ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
						If ZZG->(DbSeek(xFilial("ZZG")+cRemPer+cCodCCR+"1"))
							MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
							Return	.F.
						Endif
					EndIf
					
					SZ3->( DbSetOrder(1) )
					If SZ3->( !MsSeek( xFilial("SZ3") + cCodFeder ) ) //Analisar
						CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> NÃO FOI ENCONTRADO O CADASTRO DA FEDERAÇÃO" +cCodFeder+" DO POSTO " + cCodPosto)
						Loop
					EndIf
					
				Case nI == 6 //Parceiro
					// Não existe necessidade de posicionamento. Serão utilizadas informações do SZ5 para remunerar o parceiro revendedor/contator
					If !(AllTrim(cTipEnt) $ "R/S/T")
						Loop
					EndIf
					
					//Renato Ruy - 22/03/2018
					//Bloqueio de recalculo de faixa quando existe planilha ativa
					cCodPar := Iif(Len(aLin)>7,aLin[8],SZ5->Z5_CODPAR)
					
					//Buscar entidade pai
					Beginsql Alias "TMPPOR"
						SELECT Z3_CODENT CODCCR FROM %Table:SZ3%
						WHERE
						Z3_FILIAL = ' ' AND
						Z3_CODPAR||Z3_CODPAR2 LIKE %Exp:cCodPar% AND
						Z3_TIPENT = '9' AND
						%NOTDEL%
					Endsql
					
					cCodCCR := TMPPOR->CODCCR
					
					TMPPOR->(DbCloseArea())
					
					//Yuri Volpe - 03/12/2018
					//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
					If Substr(AllTrim(SZ5->Z5_PRODGAR),1,4) != "IFEN"
						ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
						If ZZG->(DbSeek(xFilial("ZZG")+cRemPer+cCodCCR+"1"))
							MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
							Return	.F.
						Endif
					EndIf
					
				//Renato Ruy - 06/09/2017
			//Regra para remunerar a AR conforme percentual cadastrado.
			Case nI == 7 //Federação
			
				If !AllTrim(cTipEnt) $ "B|T|"
					Loop
				Endif
				
				//Yuri Volpe - 03/12/2018
				//OTRS 2018112610000585 - Não bloquear recálculo caso produto seja IFEN
				If Substr(AllTrim(SZ5->Z5_PRODGAR),1,4) != "IFEN"				
					ZZG->(DbSetOrder(2)) // Filial + Periodo + Entidade + (1-Ativo ou 2-Inativo)
					If ZZG->(DbSeek(xFilial("ZZG")+cRemPer+cCodCCR+"1"))
						MsgInfo("O Pedido não poderá ser recalculado, já existe planilha ativa no portal da rede!")
						Return	.F.
					Endif
				EndIf
			
				//Quando tem campanha os pedidos não serão remunerados
				//Para renovacao apenas considera os links abaixo para nao gerar a validacao incorreta
				cAbateCamp := "S"
				cAcPropri := CRR20RD(SZ5->Z5_DESREDE)
				If !(cAcPropri $ "BR/SIN/NOT/SINRJ") .And. (!Empty(SZ5->Z5_PEDGANT) .OR. AllTrim(SZ5->Z5_TIPVOU) == 'H')
					cAbateCamp := "N"
				EndIf
				
				If cAbateCamp == "S" .And. nI != 6 .And. ("CAMPANHA DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE)) .And.;
					SZ5->Z5_COMSW > 0 .And. SZ5->Z5_BLQVEN != "0"
					Loop
				EndIf

				//Verifica se tem o cadastro da AR no sistema
				SZ3->( DbSetOrder(1) )
				If SZ3->( !MsSeek( xFilial("SZ3") + cCodAr ) ) .OR. Empty(cCodAr) .OR. cQuebra != "2" //Analisar
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> NÃO FOI ENCONTRADO O CADASTRO DA AR" +cCodAr+" DO POSTO " + cCodAr)
					Loop
				EndIf
				
				//Para AR somente recebe para produtos com categoria cadastrada
				SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
				If SZ4->( !MsSeek( xFilial("SZ4") + SZ3->Z3_CODENT + cCatProd ) )
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> ENTIDADE " + SZ3->Z3_CODENT + " NÃO POSSUI REGRA DE REMUNERACAO DE ACORDO COM PRODUTO ")
					Loop
				EndIf
			Endcase
			
			
			If nI <> 6 // Verificação normal
				
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Trata a faixa de remuneracao dde acordo com quantidade de centificados verificados
				somente para ni=2 (grupo/rede) com faixa cadastrada e que não seja companha do contatdor
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				*/
				
				
				If lProdConta .and. ni=2 .and. lTemFaixa //.and. !(SZ5->Z5_CODVEND>'0' .and. SZ5->Z5_CODPAR>'0')
					// Produto Realiza Contagem (Sim)
					
					/*
					BEGINDOC
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³No cadastro de produtos GAR (De/Para - PA8)             ³
					//³deve informar se  faz contagem de validações do produto ³
					//³para remuneração por faixa de validações.               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ENDDOC
					*/
					
					//se existir contagem de cetificados, a faixa substituirá a categoria do produto.
					//If mv_par06 == 1 //Conta certificados validados
					SZV->( DbSetOrder(1) )	// ZV_FILIAL+ZV_CODENT+ZV_SALANO
					SZV->( DbGoTop() )
					If SZV->( MsSeek( xFilial("SZV")+ SZ3->Z3_CODENT + Left( cRemPer, 4 ) ) )
						SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
						SZ4->( DbGoTop() )
						If SZ4->( MsSeek( xFilial("SZ4")+SZ3->Z3_CODENT ) )
							cFxCodEnt	:= SZ4->Z4_CODENT
							While SZ4->( !Eof() ) .AND. (cFxCodEnt == SZ4->Z4_CODENT)
								If SZ4->Z4_CATPROD $ "F1F2F3F4F5F6"
									If SZV->ZV_SALACU >= SZ4->Z4_QTDMIN .AND. SZV->ZV_SALACU <= SZ4->Z4_QTDMAX
										cFaixa	:=	SZ4->Z4_CATPROD
									Endif
								Endif
								SZ4->( DbSkip() )
							End
						Else
							
						Endif
						
					Endif
					
					//Endif
					
				Endif
				
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Calculo do valor da comissao e a origem da regra									   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				*/
				
				nQtdReg	:= 0
				nValSw  := 0
				nValHw  := 0
				nBaseSw := 0
				nBaseHw := 0
				
				// 1- Definir percentuais de SoftWare e Hardware conforme categoria de produtos
				
				// IF Tratamento para Ni=2 (grupo Rede) e Existir Faixa,
				
				//Para software Utilizar as Faixas (F1F2F3) para posicionar posicionar SZ4.
				//Para hardware utilizar categoria do produto para posicionar SZ4
				
				
				// Else Tratamento para Ni<>2
				
				//Utilizar sempre a categoria do produto para posicionar na SZ4.
				
				// EndIf
				
				//A faixa substitui a Categoria do produto.
				
				If !Empty(cFaixa) .And. nI == 2
					cChaveSZ4 := SZ3->Z3_CODENT + cFaixa
				Else
					cChaveSZ4 := SZ3->Z3_CODENT + cCatProd
				Endif
				
				SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
				SZ4->( DbGoTop() )
				If SZ4->( !MsSeek( xFilial("SZ4") + cChaveSZ4 ) )
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> ENTIDADE " + SZ3->Z3_CODENT + " NÃO POSSUI REGRA DE REMUNERACAO DE ACORDO COM PRODUTO ")
					//	Loop
				EndIf
				
				
				// Define porcentagens de remuneracao que serão consideradas
				//Solicitante: Giovanni - 14/08/14 - Retiro a validação do Parceiro
				/*If !Empty(cCodParc) .AND. ( !EMPTY(SZ4->Z4_PARSW) .OR. !EMPTY(SZ4->Z4_PARHW)) // Verificacao Camp.Contador / Clube do Revendedor
				
				nPorSfw := SZ4->Z4_PARSW / 100
				nPorHdw := SZ4->Z4_PARHW / 100
				cTipo	:= 'VERPAR'
			Else*/
			//Caso seja calculado faixa buscará software da faixa e hardware da categoria.
			cAcPropri := CRR20RD(SZ5->Z5_DESREDE)
			
			//Renato Ruy - 28/08/15
			//Tratamento para campanha na renovação
			lCamRen := .T.
			If !(cAcPropri $ "BR/SIN/SINRJ/NOT") .And. !Empty(SZ5->Z5_PEDGANT)
				lCamRen := .F.
			EndIf
			
			cTipo	:= IIF(lMidiaAvulsa, 'ENTHAR','VERIFI')
			
			//Renato Ruy - 02/01/2018
			//OTRS: 2017121410001231 - Paga percentual de campanha para BR, quando tem origem do revendedor
			If (cAbateCamp == "S" .Or. nI == 2) .And. SZ5->Z5_COMSW > 0 .And. SZ5->Z5_BLQVEN != "0" .And. lCamRen .And.;
			   ("ENTIDADE DE CLASSE" $ UPPER(SZ5->Z5_DESREDE) .Or. "CAMPANHA DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE) .Or.;
			    ("REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE) .And. AllTrim(cAcPropri)$GetNewPar("MV_XACREV","BR")))
			    //Se reposiciona na SZ4, sem a faixa
			    cChaveSZ4 := SZ3->Z3_CODENT + cCatProd
			    SZ4->( !MsSeek( xFilial("SZ4") + cChaveSZ4 ) )
			    //se tem percentual da campanha para o produto
			   	nPorSfw := Iif(SZ4->Z4_PARSW>0,SZ4->Z4_PARSW,SZ4->Z4_PORSOFT) / 100     //Percentual de Sofware
				nPorHdw := Iif(SZ4->Z4_PARHW>0,SZ4->Z4_PARHW,SZ4->Z4_PORHARD) / 100     //Percentual de Hardware
			Elseif "CONTROLE DE VENDAS - CACB" $ UPPER(SZ5->Z5_DESREDE).And. SZ5->Z5_BLQVEN != "0" .And. SZ4->Z4_PARSW > 0
				nPorSfw := SZ4->Z4_PARSW / 100     //Percentual de Sofware
				nPorHdw := SZ4->Z4_PARHW / 100     //Percentual de Hardware
			Elseif nI == 2 .And. !Empty(cCodAr) .And. cQuebra == "2"
				aAreaSZ4  := SZ4->(GetArea())
				nPorSfw := SZ4->Z4_PORSOFT / 100     //Percentual de Sofware
				nPorHdw := SZ4->Z4_PORHARD / 100     //Percentual de Hardware
				SZ4->( DbSetOrder(1) )	// Z4_FILIAL+Z4_CODENT+Z4_CATPROD
				If SZ4->(MsSeek( xFilial("SZ4") + cCodAr + cCatProd ))
					nPorSfw := 0.03     //Percentual de Sofware
					nPorHdw := 0.02     //Percentual de Hardware
				Endif
				RestArea(aAreaSZ4)
			Else
				nPorSfw := SZ4->Z4_PORSOFT / 100     //Percentual de Sofware
				nPorHdw := SZ4->Z4_PORHARD / 100     //Percentual de Hardware
			EndIf
			//Endif
			
			If (nPerc > 0 .And. nPerc <> nPorSfw) .And. nCiclo == Ni
				nPorSfw := nPerc / 100
			EndIf
				
				// 2- Tratar Base de cálculo e valores de comissão fixos por produtos
				
				//If !(SZ3->Z3_CODENT $ cOABSP) .And. SZ5->Z5_VALOR <> nValOAB//Tratamento efetuado para entidade OAB-SP quando o valor for num total de R$ 77.50
				
				//Alguns produtos tem valor de comissão fixo. Mas para isso a na entidade deve indicar usar regra do produto.
				If (SZ3->Z3_RGVLPRD == "1" .And. PA8->PA8_VLSOFT <> 0 ) .And. !lMidiaAvulsa//.And. (nI == 1 .Or. nI == 2 .Or. nI == 3 .Or. nI == 4))
					nValSw  := PA8->PA8_VLSOFT
					nValHw  := 0
					nBaseSw := 0
					nBaseHw := 0
				Else
					
					//Trata produtos de Conectividade social.
					//Solicitante: Priscila - Data: 16/03/15 - Aglutina valores para Conectividade e mantém valores para outros
					DbSelectArea("PA8")
					DbSetOrder(1)
					DbSeek( xFilial("PA8") + PadR(AllTrim(SZ5->Z5_PRODGAR),32," ") ) //Me posiciono no produto para verificar se e conectividade
					
					//IF '18' $ SZ5->Z5_PRODGAR .or. 'SIMPLES'$UPPER(SZ5->Z5_DESPRO) //Se o produto é conectividade social.
					//If PA8->PA8_PRDCON == "S" .And. !(cCodCanal $ "CA0001/CA0002" .And. nI == 4) //25/06/2015 - Giovanni
					If PA8->PA8_PRDCON == "S" .And. !(cCodCanal $ "CA0001/CA0002" .And. nI == 3)
						nValTotSW:= nValTotSW +nValTotHW
						nValTotHW:= 0
						//ElseIf PA8->PA8_PRDCON == "S" .And. cCodCanal $ "CA0001/CA0002" .And. nI == 4  //25/06/2015 - Giovanni
					ElseIf PA8->PA8_PRDCON == "S" .And. cCodCanal $ "CA0001/CA0002" .And. nI == 3
						If nValTotSW +nValTotHW == 155
							nValTotSW:= 46.5
							nValTotHW:= 0
						ElseIf nValTotSW +nValTotHW == 165
							nValTotSW:= 56.5
							nValTotHW:= 0
						ElseIf nValTotSW +nValTotHW == 189
							nValTotSW:= 56.65
							nValTotHW:= 0
						ElseIf nValTotSW +nValTotHW == 199
							nValTotSW:= 66.65
							nValTotHW:= 0
						ElseIf nValTotSW +nValTotHW == 209
							nValTotSW:= 76.65
							nValTotHW:= 0
						Else
							nValTotHW:= 0
							SC5->(DbOrderNickName("NUMPEDGAR"))
							If SC5->(DbSeek( xFilial("SC5") + SZ5->Z5_PEDGAR ))
								SC6->(DbSetOrder(1))
								If SC6->(DbSeek( xFilial("SC6") + SC5->C5_NUM ))
									
									While SC6->C6_FILIAL = SC5->C5_FILIAL .AND. SC6->C6_NUM == SC5->C5_NUM
										
										SB1->(DbSetOrder(1))
										If SB1->(DbSeek( xFilial("SB1") + SC6->C6_PRODUTO ))
											
											If SB1->B1_CATEGO == "2" .And. SC6->C6_XOPER != "53"
												nValTotSw += SC6->C6_PRCVEN
											EndIf
											
										EndIf
										
										SC6->(DbSkip())
									EndDo
									
								EndIf
								
							EndIf
							
						EndIf
					//Renato Ruy - 07/07/2015
					//Solicitante: Priscila Kuhn
					//Zera valor de hardware e valor de abatimento 
					ElseIf cCodCanal $ "CA0001/CA0002" .And. nI == 3
						nValTotHW	:= 0
						nValorAbtHw := 0
					Endif
					
					//Trata Voucher
					//Se Posiciona SZF, se existir pedido, faz loop
					//Busca valor do pedido anterior.
					// H = Voucher de renovaçao automatica
					// B = Substituição de voucher
					
					//Verifica se pedido de origem do voucher foi verificado, está rejeitado ou pronto para emitir. Nestes casos não paga comissão pois foi pago anteriormnete
					If !Empty(SZ5->Z5_CODVOU) .And. AllTrim(SZ5->Z5_TIPVOU) != "H" .And. AllTrim(SZ5->Z5_TIPVOU) != "B"
						
						DbSelectArea("SZF")
						DbSetOrder(2)
						If DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU)
							
							//Atenção: Criar um laço para verificar se pedido anterior é voucher de substituição
							
							DbSelectArea("SZ5")
							DbSetOrder(1)
							If DbSeek(xFilial("SZ5")+PADR(AllTrim(StrTran(SZF->ZF_PEDIDO,"-"," ")),10," "))
								// 3 = Pronto para emitir
								// 4 = Rejeitado
								If ( (!Empty(SZ5->Z5_DATVER) .OR. !Empty(SZ5->Z5_DATEMIS)) .And. AllTrim(SZ5->Z5_STATUS) $ "3/4" .And. Empty(SZ5->Z5_PEDGANT) ) .Or.;
									AllTrim(SZ5->Z5_TIPVOU) == "1" .OR. (!Empty(SZ5->Z5_PEDGANT) .And. !Empty(SZ5->Z5_DATEMIS))
									SZ5->( DbGoTo( nRecnoZ5 ) )
									nValTotSw := 0
									nValTotHw := 0
								EndIf
								
							EndIf
							
							SZ5->( DbGoTo( nRecnoZ5 ) )
							
						EndIf
					ElseIf AllTrim(SZ5->Z5_TIPVOU) == "B"
						//Solicitante: Suzane - 05/05/2015
						//Validação para voucher de substituição
						//ZF_PEDIDO - Pedido Anterior
						//ZF_PEDIDOV - Pedido Atual do Voucher
						
						DbSelectArea("SZF")
						DbSetOrder(2)
						If DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU)
							
							cVouAnt   := ""
							lNaoPagou := .T.
							
							//Renato Ruy - 29/06/15
							//Faço o Loop enquanto o tipo é B para encontrar a origem e se algum foi verificado anteriormente, zero o pedido.
							While AllTrim(SZF->ZF_TIPOVOU) == "B" .And. lNaoPagou .AND. cVouAnt<>SZF->ZF_CODORIG
								
								cVouAnt := SZF->ZF_CODORIG
								
								
								SZF->(DbSetOrder(2))
								If SZF->(DbSeek(xFilial("SZF")+cVouAnt))
									
									
									//Se o voucher já foi usado busco a qual pedido o mesmo está vinculado
									If SZF->ZF_SALDO == 0
										
										If Select("QCRPA022") > 0
											QCRPA022->(DbCloseArea())
										EndIf
										
										BeginSql Alias "QCRPA022"
											SELECT ZG_NUMPED FROM PROTHEUS.SZG010
											WHERE
											ZG_FILIAL = ' ' AND
											ZG_NUMVOUC = %Exp:SZF->ZF_COD% AND
											D_E_L_E_T_ = ' '
										EndSql
										
										SZ5->(DbSetOrder(1))
										If SZ5->(DbSeek( xFilial("SZ5") + QCRPA022->ZG_NUMPED ))
											
											//Se o pedido já estiver verificado não continuo o loop e zero o pedido.
											If !Empty(SZ5->Z5_DATVER)
												nValTotSw := 0
												nValTotHw := 0
												lNaoPagou	:= .F.
											EndIf
										EndIf
										
										SZ5->( DbGoTo( nRecnoZ5 ) )
										
									EndIf
								ELSE
									Exit
								EndIf
							EndDo
						EndIf
						
					EndIf
					
					//Tratamento OAB SP E Valor igual a 77,50 e pertenca a OAB SP e zerado ou tipo de voucher cortesia/funcionario.
					If (AllTrim(SZ5->Z5_PRODGAR) == "OABA3PFSCHV2" .And. SZ5->Z5_VALOR == 77.50 .And. cCodCcr == "054599") .OR. AllTrim(SZ5->Z5_TIPVOU) $ "1/3/6/G" .OR. AllTrim(SZ5->Z5_PRODGAR) = 'SRFA3PFSCFUNCHV2'
						nValTotSw  	:= 0
						nValTotHw  	:= 0
					ElseIf AllTrim(SZ5->Z5_PRODGAR) == "OABA3PFSCHV2" .And. nValTotSW +nValTotHW == 99
						nValTotSW:= 115
						nValTotHW:= 0
					ElseIf AllTrim(SZ5->Z5_PRODGAR) == "OABA3PFLEHV2" .And. nValTotSW +nValTotHW == 219
						nValTotSW:= 115
						nValTotHW:= 120
					ElseIf AllTrim(SZ5->Z5_PRODGAR) $ "/OABA3PFLEHV2/OABA3PFTOHV2/" .And. nValTotSW +nValTotHW == 235
						nValTotSW:= 115
						nValTotHW:= 120
					ElseIf AllTrim(SZ5->Z5_PRODGAR) $ "/OABA3PFLEHV2/OABA3PFTOHV2/" .And. nValTotSW +nValTotHW == 240
						nValTotSW:= 120
						nValTotHW:= 120
					EndIf
					
					//If !lMidiaAvulsa
						
						/* Giovanni e Priscila em 26/06/2015
						
						// Calcula Software
						// Do valor Base deve-se retirar os valores de impostos sobre venda
						
						If (nI == 3 .Or. nI == 4) .And. cAbateCcrAC == "1" //Caso seja Canal 1 ou 2 e esteja determinado na AC, faz abatimento do valor da AC e CCR.
						nBaseSw := (nValTotSw-nValorAbtSw) - ((nValTotSw-nValorAbtSw) * SZ4->Z4_IMPSOFT / 100)
						Else
						nBaseSw := nValTotSw - (nValTotSw * SZ4->Z4_IMPSOFT / 100)
						EndIf
						
						// Calcula Hardware
						If (nI == 3 .Or. nI == 4) .And. cAbateCcrAC == "1" //Caso seja Canal 1 ou 2 e esteja determinado na AC, faz abatimento do valor da AC e CCR.
						nBaseHw := (nValTotHw-nValorAbtHw) - ((nValTotHw-nValorAbtHw) * SZ4->Z4_IMPHARD / 100)
						Else
						nBaseHw := nValTotHw - (nValTotHw * SZ4->Z4_IMPHARD / 100)
						EndIf
						
						If !Empty(SZ4->Z4_PORIR) //.AND. Empty(cCodParc)
						nBaseHw	:= nBaseHw - (nBaseHw * SZ4->Z4_PORIR / 100)
						Endif
						*/
						
						//Priscila Kuhn - OTRS: 2015040210000915 - 02/14/2015
						//Abater valores da Campanha quando especificado no Posto
						//Cancelado 06/04/15 - Solicitante: Tânia
						//Solicitado novamente pela Priscila e e-mail encaminhado pelo Giovanni - 16/06/2015
						nAbtCamH := 0
						nAbtCamS := 0
						
						//Tratamento para não descontar de todas as redes o valor da campanha nos casos de renovação.
						cAcPropri := ""
						If !Empty(SZ5->Z5_DESREDE) .And. !Empty(SZ5->Z5_PEDGANT)
							cAcPropri := CRR20RD(SZ5->Z5_DESREDE)
							cAbateCamp := Iif(cAcPropri $ "BR/SIN/NOT","S","N")						
						EndIf
						
						If cAbateCamp == "S" .And. nI != 6 .And. ("CAMPANHA DO CONTADOR" $ UPPER(SZ5->Z5_DESREDE) .Or. "REVENDEDOR" $ UPPER(SZ5->Z5_DESREDE))
							nAbtCamH :=  (nValTotHW * SZ5->Z5_COMSW) / 100
							nAbtCamS :=  (nValTotSW * SZ5->Z5_COMSW) / 100
						EndIf
						// Fim - Priscila Kuhn - OTRS: 2015040210000915 - 02/14/2015
						
						//Caso seja Canal 1 ou 2 e esteja determinado na AC, faz abatimento do valor de softw pagos para  rede e CCR.
						//O Valor de abatimento de imposto é calculado sobre o total independente da entidade
						// Renato Ruy - 30/06/15 - Adicionei as variáveis nAbtCamH e nAbtCamS para fazer o abatimento da campanha do contato
						If (nI == 3 .Or. nI == 4) .And. cAbateCcrAC == "1"
							//Solicitante: Priscila Kuhn - 23/07/15
							//Calcula o desconto encima do valor base, não soma valor pago para AR e AC.
							PA8->( DbSetOrder(1) )
							If PA8->(MsSeek(xFilial("PA8")+SZ5->Z5_PRODGAR)) .And. SZ5->Z5_DATPED >= CtoD("01/12/15") .And.;
								nValTotSw > 0 .And. !("SERVER" $ SZ5->Z5_PRODGAR .Or. "OAB" $ SZ5->Z5_PRODGAR .Or.;
								(PA8->PA8_PRDCON == "S" .And. ("18" $ SZ5->Z5_PRODGAR .Or. "SIMPLES" $ UPPER(PA8->PA8_DESBPG)  .Or.;
						 		"SMART CARD E LEITORA VALIDADE 3 ANOS" $ UPPER(PA8->PA8_DESBPG) )) ) .And.;
								AllTrim(SZ3->Z3_CODENT) $ "CA0001/CA0002" .And. AllTrim(SZ5->Z5_PRODGAR) != "ACMA3PJNFECSRHV2"
								
								nAbtAR  := (nValTotSw - 10) * nAbtAR
								nAbtAC  := (nValTotSw - 10) * nAbtAC
							Else
								nAbtAR  := nValTotSw * nAbtAR
								nAbtAC  := nValTotSw * nAbtAC
							EndIf
							
							nAbtImp := nValTotSw * (SZ4->Z4_IMPSOFT / 100)
							nBaseSw := nValTotSw - nAbtAC- nAbtAR - nAbtImp - nAbtCamS
							nBaseHw := (nValTotHw - (nValTotHw * SZ4->Z4_IMPHARD/ 100)) - nAbtCamH
						Else
							nBaseSw := (nValTotSw - (nValTotSw * SZ4->Z4_IMPSOFT / 100)) - nAbtCamS
							nBaseHw := (nValTotHw - (nValTotHw * SZ4->Z4_IMPHARD / 100)) - nAbtCamH
						EndIf
						
						
						//Retira-se em seguida o imposto de renda
						If !Empty(SZ4->Z4_PORIR) //.AND. Empty(cCodParc)
							nBaseSw	:= nBaseSw - (nBaseSw * SZ4->Z4_PORIR / 100)
							nBaseHw	:= nBaseHw - (nBaseHw * SZ4->Z4_PORIR / 100)
						Endif  
						
						// Solicitante: Priscila Kuhn - 29/12/2015
						// Desconta biometria para calculo do valor do SW para NOT, REG, SIN e SINRJ.
						// Não serão considerados os produtos Conectividade 18 meses/ E-Simples / OAB / SERVEREG
						// Somente Verificação e renovação.
						// Considera através da data do Pedido (Z5_DATPED) maior ou igual 01/12/2015.
						If nI == 1
							//Armazeno recno da entidade atual.
							nRecEnt := SZ3->(Recno())
							
							SZ3->(DbSetOrder(4))
							SZ3->(DbSeek(xFilial("SZ3")+SubStr(SZ5->Z5_CODPOS,1,6)))
							
						EndIf
						
						PA8->( DbSetOrder(1) )
						cTiped := ""
						If PA8->(MsSeek(xFilial("PA8")+SZ5->Z5_PRODGAR)) .And. SZ5->Z5_DATPED >= CtoD("01/12/15") .And.;
							nBaseSw > 0 .And. !(AllTrim(Str(nI)) $ "3/4") .And. !("SERVER" $ SZ5->Z5_PRODGAR .Or. "OAB" $ SZ5->Z5_PRODGAR .Or.;
							(PA8->PA8_PRDCON == "S" .And. ("18" $ SZ5->Z5_PRODGAR .Or. "SIMPLES" $ UPPER(PA8->PA8_DESBPG) .Or.;
						    "SMART CARD E LEITORA VALIDADE 3 ANOS" $ UPPER(PA8->PA8_DESBPG) )) ) .And.;
							(AllTrim(SZ3->Z3_CODENT) $ "/SIN/" .OR. AllTrim(SZ3->Z3_CODAC) $ "/SIN/") .And.;
							AllTrim(SZ5->Z5_PRODGAR) != "ACMA3PJNFECSRHV2"
							//"ACMA3PJNFECSRHV2" - Produto servidor e nao contem na descrição
							//("NOT" $ SZ5->Z5_PRODGAR .OR. "REG" $ SZ5->Z5_PRODGAR .OR. "SIN" $ SZ5->Z5_PRODGAR) .And.;
							
							nBaseSw := nBaseSw - 10
							cTiped	:= "BIOMETRIA"
						EndIf
						
						//Restauro a conexao na entidade anterior para postos.
						If nI == 1
							SZ3->(DbGoTo(nRecEnt))
						EndIf
						
						// Fim da alteração de biometria.
						
						
						If !Empty(nPorSfw)
							nValSw	:= nBaseSw * nPorSfw
							//If Empty(cCodParc)
							cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")"
							//Else
							//	cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE SOFTWARE - PARCEIRO) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")"
							//Endif
						Else
							nValSw	:= SZ4->Z4_VALSOFT
							cRegSw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (VALOR FIXO SOBRE SOFTWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")"
						Endif
						
					//Endif
					
					
					
					If !Empty(nPorHdw)
						nValHw	:= nBaseHw * nPorHdw
						//If Empty(cCodParc)
						cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE HARDWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")"
						//Else
						//	cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (PERCENTUAL SOBRE HARDWARE - PARCEIRO) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")"
						//Endif
					Else
						nValHw	:= SZ4->Z4_VALHARD
						cRegHw	:= ">>> (" + Alltrim(SZ3->Z3_CODENT) + ") >>> (VALOR FIXO SOBRE HARDWARE) >>> (" + Alltrim(SZ4->Z4_CATDESC) + ")"
					EndIf
				EndIf
				//EndIf
				
				
				
				// Verificacao Camp.Contador / Clube do Revendedor
			ElseIf nI == 6  .And. !Empty(cDesRede) //.And. Empty(SZ5->Z5_PEDGANT)
				//Rafael Beghini 16.03.2016 - Com as variaveis sendo limpadas, estava pegando o valor
				//da SZ5 que é o incorreto.
				/*
				nValTot  := 0
				nValTotSw:= 0
				nValTotHw:= 0
				nPorSfw  := 0
				*/
				
				//Renato Ruy - 07/06/2016
				//Sistema nao estava considerando os dados que estavam na planilha.
				cCodPar := Iif(Len(aLin)>7,aLin[8],SZ5->Z5_CODPAR)
				cDesPar := Iif(Len(aLin)>8,aLin[9],SZ5->Z5_NOMPAR)
				cCodVen := Iif(Len(aLin)>10,aLin[11],SZ5->Z5_CODVEND)
				cNomVen := Iif(Len(aLin)>11,aLin[12],SZ5->Z5_NOMVEND)
				
				//cDescPrd:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG"))
				// Solicitação: Priscila - 24/09/14 - Produtos da Conectividade Social será realizado o Skip.
				//Como não existe cadastro para campanha do contador, faço tratamento manual.
				//If "/"+AllTrim(SZ5->Z5_CODPAR) +"/" $ "/0/72/75/89/90/99/101/102/206/253/262/270/335/335/337/356/440/463/468/555/567/568/586/913/999/1108/1186/1434/1435/1574" .OR. AllTrim(SZ5->Z5_CODVEND) = "19431" .OR. "CONECTIVIDADE SOCIAL DE 18 MESES" $ Upper(cDescPrd)
				//Renato Ruy - 25/08/2015
				//Tratamento para Bortolim, busco no cadastro de entidade e gravo se o tratamento sera atraves do cadastro da entidade.
				SZ4->( DbSetOrder(1) )
				lCalcCam := SZ4->(DbSeek(xFilial("SZ4")+SubStr(cCodPar,1,6) ))
				
				If !("CAMPANHA DO CONTADOR" $ UPPER(cDesRede)) .And. !("REVENDEDOR" $ UPPER(cDesRede)) .And.;
				   !("ENTIDADE DE CLASSE" $ UPPER(cDesRede)) .And. !lCalcCam
					Loop
				EndIf
				
				//Gera Campanha do Contador e/ou [ Clube do Revendedor (Incluido Rafael Beghini 22.03.2016) ]
				If ( "CAMPANHA DO CONTADOR" $ UPPER(cDesRede) .OR. "CLUBE DO REVENDEDOR" $ UPPER(cDesRede) ) .Or.;
					("ENTIDADE DE CLASSE" $ UPPER(cDesRede)) .Or. lCalcCam
					nQtdReg	:= 0
					nValSw  := 0
					nValHw  := 0
					nBaseSw := 0
					nBaseHw := 0
					nPorSfw := 0
					cTipPar := Iif("REVENDEDOR" $ UPPER(cDesrede),"10","7")
					//Rafael Beghini 16.03.2016 - Com as variaveis sendo limpadas, estava pegando o valor
					//da SZ5 que é o incorreto.
					//nValTotSw:= SZ5->Z5_VALORSW
					//nValTotHw:= SZ5->Z5_VALORHW
					
					If Empty(cCodPar)
						cCodPar := SZ5->Z5_CODPAR
						cDesPar := SZ5->Z5_NOMPAR
					EndIf
										
					If Val(Iif(Len(aLin)>6,aLin[7],"0")) > 0
						nPorSfw := Val(Iif(Len(aLin)>6,aLin[7],"0")) / 100
					Elseif lCalcCam
					
						SZ3->( DbSetOrder(1) )
						SZ3->(DbSeek(xFilial("SZ3")+SZ5->Z5_CODPAR))
						
						If PA8->PA8_PRDCON == "S"
							nValTotSW:= nValTotSW +nValTotHW
						EndIf
						
						nPorSfw  := SZ4->Z4_PORSOFT / 100
						nImpCamp := nValTotSW * (SZ4->Z4_IMPSOFT / 100)
						
					ElseIf SZ5->Z5_COMSW > 0
						nPorSfw := SZ5->Z5_COMSW / 100
					Elseif SZ5->Z5_COMHW > 0
						nPorSfw := SZ5->Z5_COMHW / 100
					ElseIf (nPerc > 0 .And. nPerc <> nPorSfw)
						nPorSfw := nPerc / 100
					Else
						cDesPar := "" //Quando não recebemos percentual do GAR, não calcula comissão para o revendedor.
					EndIf
					cTipo	:= 'PARCEI'
					
					// Calcula Remuneração sobre venda
					//If !(SZ3->Z3_CODENT $ cOABSP) .And. SZ5->Z5_VALOR <> nValOAB//Tratamento efetuado para entidade OAB-SP quando o valor for num total de R$ 77.50
					
					//Renato Ruy - 25/08/15
					//Tratamento generico para entidades cadastradas na SZ3
					//Priscila Kuhn - 11/01/2016
					//Desmembrar valor para campanha e clube.
					/*
					If lCalcCam
					nValTot := nValTotSW
					nValTotHW := 0
					ElseIf SZ5->Z5_VALORSW > 0 .AND. SZ5->Z5_VALORHW > 0 .And. nValTot == 0
					nValTot := SZ5->Z5_VALORSW + SZ5->Z5_VALORHW
					ElseIf SZ5->Z5_VALOR > 0 .And. nValTot == 0
					nValTot := SZ5->Z5_VALOR
					ElseIf SZ5->Z5_VALORSW > 0 .And. nValTot == 0
					nValTot := SZ5->Z5_VALORSW
					ElseIf SZ5->Z5_VALORHW > 0  .And. nValTot == 0
					nValTot := SZ5->Z5_VALORHW
					
					Else
					
					If !Empty(SZ5->Z5_CODVOU)
					
					//Caso seja Voucher, se posiciona para retornar o valor
					SZF->(DbSetOrder(2))
					SZF->(DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU))
					
					nValTot := SZF->ZF_VALOR
					
					Else
					
					SC5->(DbSetOrder(5))
					SC5->(DbSeek(xFilial("SC5")+SZ5->Z5_PEDGAR))
					
					nValTot := SC5->C5_TOTPED
					
					EndIf
					
					EndIf
					*/
					
					//Se Posiciona SZF, se existir pedido, faz loop
					//Busca valor do pedido anterior.
					If !Empty(SZ5->Z5_CODVOU) .And. AllTrim(SZ5->Z5_TIPVOU) != "H" .And. AllTrim(SZ5->Z5_TIPVOU) != "B"
						DbSelectArea("SZF")
						DbSetOrder(2)
						If DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU)
							
							If !lCalcCam .Or. PA8->PA8_PRDCON == "S"
								//nValTot := nValTotHW + nValTotSW
								nValTotSw:= nValTotHW + nValTotSW
								nValTotHw:= 0
								//Else
								//	nValTot := nValTotSW
							EndIf
							
							//Se o pedido atual pertencer ao voucher que não paga, zera o valor da campanha.
							If (AllTrim(SZ5->Z5_TIPVOU) $ "1/3/5/6/7/C/D" .OR. (AllTrim(SZ5->Z5_TIPVOU) == "E" .And. !("CERTIFIQUE ON LINE" $ UPPER(SZ5->Z5_NOMPAR)))) .And. SZF->ZF_CAMPANH != "1" 
								//nValTot := 0 // Priscila - 26/09/14 - Não faz loop, zera valor
								nValTotSw:= 0
								nValTotHw:= 0
								nImpCamp:= 0
							EndIf
							
							DbSelectArea("SZ5")
							DbSetOrder(1)
							If DbSeek(xFilial("SZ5")+PADR(AllTrim(StrTran(SZF->ZF_PEDIDO,"-"," ")),10," ")) .And. !Empty(SZF->ZF_PEDIDO)
								//Solicitante: Priscila Kuhn - 14/09/15
								//Somente o primeiro pedido verificado será pago.
								If ( ( (!Empty(SZ5->Z5_DATVER) .OR. !Empty(SZ5->Z5_DATEMIS)) .And. AllTrim(SZ5->Z5_STATUS) $ "3/4" ) .OR.;
									AllTrim(SZF->ZF_TIPOVOU) $ "1/3/5/6/C/D" .OR. (AllTrim(SZF->ZF_TIPOVOU) == "E" .And. !("CERTIFIQUE ON LINE" $ UPPER(SZ5->Z5_NOMPAR)) ) ) .And.;
									SZF->ZF_CAMPANH != "1"
									
									//nValTot := 0 // Priscila - 26/09/14 - Não faz loop, zera valor
									nValTotSw:= 0
									nValTotHw:= 0
									nImpCamp:= 0
									
									SZ5->( DbGoTo( nRecnoZ5) )
								EndIf
								
							EndIf
							
							SZ5->( DbGoTo( nRecnoZ5 ) )
							
						EndIf
						
					ElseIf AllTrim(SZ5->Z5_TIPVOU) == "B"
						
						//Solicitante: Suzane - 05/05/2015
						//Validação para voucher de substituição
						//ZF_PEDIDO - Pedido Anterior
						//ZF_PEDIDOV - Pedido Atual do Voucher
						
						cVouAnt := ""
						lNaoPagou := .T.
						
						If !lCalcCam .Or. PA8->PA8_PRDCON == "S"
							//nValTot := nValTotHW + nValTotSW
							nValTotSw:= nValTotHW + nValTotSW
							nValTotHw:= 0
							//Else
							//	nValTot := nValTotSW
						EndIf
						
						DbSelectArea("SZF")
						DbSetOrder(2)
						If DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU)
							
							//Renato Ruy - 29/06/15
							//Faço o Loop enquanto o tipo é B para encontrar a origem e se algum foi verificado anteriormente, zero o pedido.
							While AllTrim(SZF->ZF_TIPOVOU) == "B" .And. lNaoPagou .AND. cVouAnt<>SZF->ZF_CODORIG
								
								cVouAnt := SZF->ZF_CODORIG
								
								SZF->(DbSetOrder(2))
								If SZF->(DbSeek(xFilial("SZF")+cVouAnt))
									
									
									//Se o voucher já foi usado busco a qual pedido o mesmo está vinculado
									If SZF->ZF_SALDO == 0
										
										If Select("QCRPA022") > 0
											QCRPA022->(DbCloseArea())
										EndIf
										
										BeginSql Alias "QCRPA022"
											SELECT ZG_NUMPED FROM PROTHEUS.SZG010
											WHERE
											ZG_FILIAL = ' ' AND
											ZG_NUMVOUC = %Exp:SZF->ZF_COD% AND
											D_E_L_E_T_ = ' '
										EndSql
										
										SZ5->(DbSetOrder(1))
										If SZ5->(DbSeek( xFilial("SZ5") + QCRPA022->ZG_NUMPED ))
											
											//Se o pedido já estiver verificado não continuo o loop e zero o pedido.
											//Priscila Kuhn - 02/07/2015
											//Validação para não pagar campanha e clube para voucher dos tipos 3 / 5 / 6 / C / D  e Tipo E paga para Certifique.
											If !Empty(SZ5->Z5_DATVER) .OR. AllTrim(SZF->ZF_TIPOVOU) $ "1/3/5/6/C/D" .OR. (AllTrim(SZF->ZF_TIPOVOU) == "E" .And. !("CERTIFIQUE ON LINE" $ UPPER(SZ5->Z5_NOMPAR)) )
												//nValTot := 0
												nValTotSW := 0
												nValTotHW := 0
												nImpCamp:= 0
												lNaoPagou	:= .F.
											EndIf
										EndIf
										
										SZ5->( DbGoTo(nRecnoZ5 ) )
										
									ElseIf AllTrim(SZF->ZF_TIPOVOU) == "1"
										//nValTot := 0
										nValTotSw := 0
										nValTotHw := 0
										nImpCamp:= 0
									EndIf
								ELSE
									Exit
								EndIf
							EndDo
						EndIf
						
					EndIf
					
					//Tratamento OAB SP E Valor igual a 77,50 e pertenca a OAB SP e zerado ou tipo de voucher cortesia/funcionario.
					If (AllTrim(SZ5->Z5_PRODGAR) == "OABA3PFSCHV2" .And. SZ5->Z5_VALOR == 77.50 .And. cCodCcr == "054599") .OR. AllTrim(SZ5->Z5_TIPVOU) $ "1/3/8/7/6/G"
						//nValTot := 0
						nValTotSw := 0
						nValTotHw := 0
						nImpCamp:= 0
					EndIf
					
					// Solicitante: Priscila Kuhn - 31/03/15
					// Alteração para não pagar remuneração produtos ECPF e que tenham valor de R$ 200
					cDescProd := Upper(Posicione("PA8",1,xFilial("PA8")+PadR(AllTrim(SZ5->Z5_PRODGAR),32," "),"PA8_DESBPG"))
					If "CPF" $ UPPER(cDescProd) .And. "SMART CARD" $ UPPER(cDescProd) .And. SZ5->Z5_VALOR == 200
						//nValTot := 0
						nValTotSw := 0
						nValTotHw := 0
						nImpCamp:= 0
					EndIf
					
					//Comentado, divisao entre SW e HW.
					//nValSw	:= (nValTot-nImpCamp) * nPorSfw
					nBaseSw	:= nValTotSw-nImpCamp
					nBaseHw	:= nValTotHw-nImpCamp
					
					//Gero comissao com divisao de valores.
					nValSw	:= nBaseSw * nPorSfw
					nValHw	:= nBaseHw * nPorSfw
					
					cRegSw	:= ">>> (" + Alltrim(cCodParc) + ") >>> (PERCENTUAL SOBRE VENDA CAMPANHA CONTADOR) >>> "
					//EndIf
					
					//Faço tratamento para gravar através do Z5_DESREDE a AC proprietaria da campanha.
					lProdCalc := .F.
					cAcPropri := ""
					
					If !lCalcCam
						cAcPropri := CRR20RD(cDesRede)
					Else
						cAcPropri := AllTrim(SZ3->Z3_CODAC)
					EndIf
					
					//Zera valores para produtos que não são remunerados.
					//Renato Ruy - 13/01/2016
					//Parceiro  3179 do link BR recebe por produto SRF.
					/*If ("/"+AllTrim(SZ5->Z5_PRODGAR)+"/" $ "/REGSRFA3PF1AESHV2/NOTSRFA3PF1AESHV2/SINSRFA3PFSC1AESHV2/REGSRFA3PJTO18MCNSESHV2/SINSRFA3PJTO18MCNSESHV2/NOTSRFA3PJTO18MCNSESHV2/NOTSRFA3PJSC18MCNSESHV2/REGSRFA3PJSC18MCNSESHV2/SINSRFA3PJSC18MCNSESHV2/";
				    	.Or. ("/"+AllTrim(SZ5->Z5_PRODGAR)+"/" $ "/SRFA3PJSC18MCNSESHV2/SRFA3PJSC18MCNSESHV5/SRFA3PJSL18MCNSESHV5/SRFA3PJTO18MCNSESBVLEGHV5/SRFA3PJTO18MCNSESHV2/SRFA3PJTO18MCNSESHV5/" .And. !cAcPropri $ "CACB/CNC/CRD");
						.Or. (SubStr(SZ5->Z5_PRODGAR,1,3) == "SRF" .And. !cAcPropri $ "CNC/CRD/CACB/BR/SIN/NOT/SINRJ/BV/ACP-PR" .And. AllTrim(cCodPar) != "3179" .And. !lCalcCam);
						.Or. SubStr(SZ5->Z5_PRODGAR,1,3) == "OAB") .And. !("REVENDEDOR" $ UPPER(cDesrede))
						nValSw := 0
						nValHw := 0
						cDesPar := ""
						//Tratamento Valores para campanha, quando produto não faz parte da AC, não remunera.
						//Priscila Kuhn -05/08/15
						//Adiciona a ICP para remunerar produtos REG
					ElseIf "REG" $ SZ5->Z5_PRODGAR .And. cAcPropri <> "BR" .And. cAcPropri <> "NOT" .And. cAcPropri <> "ICP"  .And. !("REVENDEDOR" $ UPPER(cDesrede))
						nValSw := 0
						nValHw := 0
						cDesPar := ""
					ElseIf "NOT" $ SZ5->Z5_PRODGAR .And. cAcPropri <> "NOT" .And. cAcPropri <> "BR" .And. cAcPropri <> "ICP" .And. !("REVENDEDOR" $ UPPER(cDesrede))
						nValSw := 0
						nValHw := 0
						cDesPar := ""
					ElseIf "SIN" $ SZ5->Z5_PRODGAR .And. cAcPropri <> "SIN" .And. !("REVENDEDOR" $ UPPER(cDesrede))
						nValSw := 0
						nValHw := 0
						cDesPar := ""
					EndIf*/
					
					// Solicitante: Priscila Kuhn - 24/06/2015
					// Zera pedido de renovação para casos que não são REG/SIN/NOT.
					/*If !(cAcPropri $ "BR/SIN/NOT") .And. (!Empty(SZ5->Z5_PEDGANT) .OR. AllTrim(SZ5->Z5_TIPVOU) == 'H')
						nValSw := 0
						nValHw := 0
						cDesPar := ""
					EndIf*/
					
				EndIf
				
				
				//PREPARAÇÃO PARA GRAVAÇÃO DA TABELA SZ6 DE RESULTADO DO CALCULO DA COMISSÃO.
				If cTipPar == "7" .And. Empty(cAcPropri)
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> Parceiro " + cCodParc +" PARCEIRO NAO POSSUI LINK PARA CALCULO.")			
				ElseIf SZ5->Z5_COMSW <= 0
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> Parceiro " + cCodParc +" NAO POSSUI PERCENTUAL PARA CALCULO.")
				ElseIf SZ5->Z5_BLQVEN == "0"
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> Parceiro " + cCodParc +" O PARCEIRO ESTA BLOQUEADO, NAO CALCULA REMUNERACAO.")
				ElseIf SZ5->Z5_VALORSW < 1
					CRP020GrvErro(SZ5->Z5_PEDGAR+" ---> Parceiro " + cCodParc +" NAO POSSUI VALOR DE SW PARA CALCULO.")
				EndIf
			EndIf
			
			
			If (!lMidiaAvulsa .And. nI <> 6) .OR. (!Empty(cDesPar) .And. nI == 6)
				nQtdReg	:= nQtdReg + 1
			Endif
			
			// Solicitante: Priscila Kuhn - 11/05/2015
			// Foi retirada validação do tipo 3 e 4 para calcular hardware para canais
			//If !(nI == 3 .Or. nI == 4 .Or. nI == 6) .And. (lTemHard .Or. lMidiaAvulsa)
			If !(nI == 6) .And. (lTemHard .Or. lMidiaAvulsa) .OR. (!Empty(cDesPar) .And. nI == 6 .And. nBaseHw > 0)
				nQtdReg	:= nQtdReg + 1
			Endif
			
			// Cria a matriz e inicializa as variaveis
			
			For nX :=1 To nQtdReg
				Aadd( aDadosSZ6, Array(Len(aStrucSZ6)) )
				For nJ := 1 To Len(aStrucSZ6)
					Do Case
						Case aStrucSZ6[nJ][2] == "C"
							aDadosSZ6[Len(aDadosSZ6)][nJ] := ""
						Case aStrucSZ6[nJ][2] == "N"
							aDadosSZ6[Len(aDadosSZ6)][nJ] := 0
						Case aStrucSZ6[nJ][2] == "D"
							aDadosSZ6[Len(aDadosSZ6)][nJ] := CtoD("//")
						Otherwise
							aDadosSZ6[Len(aDadosSZ6)][nJ] := ""
					Endcase
				Next nJ
			Next nX
			
			
			//Forço Reposicionamento no cadastro do Posto. Isso é necessário devido ao uso do código de CCR
			If nI==1
				SZ3->(DbGoTo(nRecSZ3))
			Endif
			
			For nX := 1 To nQtdReg
				nZ	:=	nZ	+	1
				For nK := 1 To Len(aStrucSZ6)
					cCampo := AllTrim(aStrucSZ6[nK][1])
					Do Case
						Case cCampo == "Z6_FILIAL"
							aDadosSZ6[nZ][nK]	:= xFilial("SZ6")
						Case cCampo == "Z6_PERIODO"
							aDadosSZ6[nZ][nK]	:= cRemPer
						Case cCampo == "Z6_TPENTID"
							aDadosSZ6[nZ][nK]	:= IIF(nI<>6, Iif(SZ3->Z3_TIPENT=="9","4",SZ3->Z3_TIPENT),cTipPar)
						Case cCampo == "Z6_CODENT"
							aDadosSZ6[nZ][nK]	:= IIF(nI<>6, SZ3->Z3_CODENT, cCodPar)
						Case cCampo == "Z6_DESENT"
							aDadosSZ6[nZ][nK]	:= IIF(nI<>6, SZ3->Z3_DESENT, cDesPar)
						Case cCampo == "Z6_PRODUTO"
							aDadosSZ6[nZ][nK]	:= iF(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR), SZ5->Z5_PRODUTO,SZ5->Z5_PRODGAR)
						Case cCampo == "Z6_CATPROD"
							aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,"2","1") // 2=Software,1=Hardware
						Case cCampo == "Z6_DESCRPR"
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa .And. EMPTY(SZ5->Z5_PRODGAR),SZ5->Z5_DESPRO, Posicione("PA8",1,xFilial("PA8")+SZ5->Z5_PRODGAR,"PA8_DESBPG"))
						Case cCampo == "Z6_PEDGAR"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGAR
						Case cCampo == "Z6_DTPEDI"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATPED
						Case cCampo == "Z6_VERIFIC"
							aDadosSZ6[nZ][nK]	:= Iif(lMidiaAvulsa,SZ5->Z5_EMISSAO,SZ5->Z5_DATVER)
						Case cCampo == "Z6_VALIDA"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATVAL
						Case cCampo == "Z6_DTEMISS"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_DATEMIS
						Case cCampo == "Z6_TIPVOU"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_TIPVOU
						Case cCampo == "Z6_CODVOU"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODVOU
						Case cCampo == "Z6_DESCVOU"
							aDadosSZ6[nZ][nK]	:= ""
						Case cCampo == "Z6_VLRPROD"
							aDadosSZ6[nZ][nK]	:= Iif(!lMidiaAvulsa .And. nX == 1,nValTotSw,nValTotHw)
						Case cCampo == "Z6_BASECOM"
							aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nBaseSw,nBaseHw)
						Case cCampo == "Z6_VALCOM"
								aDadosSZ6[nZ][nK]	:= IF(!lMidiaAvulsa .And. nX == 1,nValSw,nValHw)
						Case cCampo == "Z6_REGCOM"
							//Gravo a observacao da retificacao.
							aDadosSZ6[nZ][nK]	:= "RETIFICACAO-" + DtoC(dDataBase) + "-" + Time() +"-"+AllTrim(cUserName)+"-CRPA028-"+ cObs
						Case cCampo == "Z6_CODCAN"
							aDadosSZ6[nZ][nK]	:= cCodCanal
						Case cCampo == "Z6_CODAC"
							aDadosSZ6[nZ][nK]	:= Iif(lProdCalc .Or. nI==1,cCodAc,cAcPropri) //Grupo/Rede
						Case cCampo == "Z6_CODAR"
							aDadosSZ6[nZ][nK]	:= cCodAR
						Case cCampo == "Z6_CODPOS"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODPOS
						Case cCampo == "Z6_CODCCR"
							aDadosSZ6[nZ][nK]	:= Iif(SZ3->Z3_TIPENT=="9",SZ3->Z3_CODENT,cCodCcr)
						Case cCampo == "Z6_CCRCOM"
							aDadosSZ6[nZ][nK]	:= Iif(SZ3->Z3_TIPENT=="9",SZ3->Z3_DESENT,cDesCcr)
						Case cCampo == "Z6_CODPAR"
							aDadosSZ6[nZ][nK]	:= cCodParc
						Case cCampo == "Z6_CODFED"
							aDadosSZ6[nZ][nK]	:= cCodFeder
						Case cCampo == "Z6_CODVEND"
							aDadosSZ6[nZ][nK]	:= IIF(nI<>6 .Or. Empty(cCodVen), SZ5->Z5_CODVEND, cCodVen)
						Case cCampo == "Z6_NOMVEND"
							aDadosSZ6[nZ][nK]	:= IIF(nI<>6 .Or. Empty(cNomVen), SZ5->Z5_NOMVEND, cNomVen)
						Case cCampo == "Z6_TIPO"
							aDadosSZ6[nZ][nK]	:= "RETIFI" //cTipo - Gravo a mesma informação da SZ5
						Case cCampo == "Z6_PEDSITE"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDSITE
						Case cCampo == "Z6_REDE"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_REDE
						Case cCampo == "Z6_GRUPO"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_GRUPO
						Case cCampo == "Z6_DESGRU"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESGRU
						Case cCampo == "Z6_CODAGE"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_CODAGE
						Case cCampo == "Z6_NOMEAGE"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOMAGE
						Case cCampo == "Z6_AGVER"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_AGVER
						Case cCampo == "Z6_NOAGVER"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_NOAGVER
						Case cCampo == "Z6_NTITULA"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_NTITULA
						Case cCampo == "Z6_DESREDE"
							aDadosSZ6[nZ][nK]	:= cDesRede
							//Case cCampo == "Z6_DESPOS"
							//	aDadosSZ6[nZ][nK]	:= SZ5->Z5_DESPOS
						Case cCampo == "Z6_PEDORI"
							aDadosSZ6[nZ][nK]	:= SZ5->Z5_PEDGANT
						Case cCampo == "Z6_VLRABT"
							aDadosSZ6[nZ][nK]	:= Iif ((nI == 3 .Or. nI == 4) .And. cAbateCcrAC == "1",nValorAbtHw + nValorAbtSw,0)
						Case cCampo == "Z6_ACLCTO"
							aDadosSZ6[nZ][nK] 	:= SZ5->Z5_REDE
						Case cCampo == "Z6_ARLCTO"
							aDadosSZ6[nZ][nK] 	:= SZ5->Z5_CODAR 							
					Endcase
				Next nK
			Next nX
			
			cFaixa 	  := ""
			cFxCodEnt := ""
			
			//Gravo valores para serem abatidos no CANAL 1 e 2.
			//If (nI == 1 .Or. nI == 2) .And. cAbateCcrAC == "1" 26/06/2015
			If (nI == 1 .Or. nI == 2) //O Valor de Hard e Softw (de Posto e Rede) será acumulado para uso abatimento da base de cálculo do canal
				nValorAbtHw += nValHw
				nValorAbtSw += nValSw
			EndIf
		Next nI
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Grava todos lancamentos de remuneracao calculados na tabela SZ6   			    	   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		//If Empty(SZ5->Z5_OBSCOM) .OR. SubStr(SZ5->Z5_OBSCOM,1,2) == "OK"
		
		Begin Transaction
		
		For nI := 1 To Len(aDadosSZ6)
			SZ6->( RecLock("SZ6",.T.) )
			For nJ := 1 To Len(aStrucSZ6)
				cCampo := AllTrim(aStrucSZ6[nJ][1])
				&("SZ6->"+cCampo) := aDadosSZ6[nI][nJ]
			Next nJ
			SZ6->Z6_RECORI := AllTrim(Str(SZ5->(Recno())))
			SZ6->( MsUnLock() )
		Next nI
		
		If Len(aDadosSZ6) > 0
			SZ5->( RecLock("SZ5",.F.) )
			//SZ5->Z5_COMISS := IIF(Empty(SZ5->Z5_OBSCOM) .OR. SubStr(SZ5->Z5_OBSCOM,1,2) == "OK",  "2", SZ5->Z5_COMISS)
			SZ5->Z5_COMISS := "2"
			SZ5->Z5_OBSCOM := IIF(Empty(SZ5->Z5_OBSCOM) .OR. SubStr(SZ5->Z5_OBSCOM,1,2) == "OK", "OK", SZ5->Z5_OBSCOM)
			SZ5->( MsUnLock() )
		EndIf
		
		End Transaction
		
		//Endif
		
		aDadosSZ6 := {}
		nZ := 0
		
		
	EndIf
	
	FT_FSKIP()
Enddo

FT_FUSE()
fClose(nHdl)

MsgInfo("Os registros foram recalculados com sucesso")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTSA01   ºAutor  ³Microsiga           º Data ³  01/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CRPA028A(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diretórios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.CSV")

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRP020GrvErro º Autor ³ Tatiana Pontes  º Data ³ 10/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava observacao do calculo de comissao no processo		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßb
*/

Static Function CRP020GrvErro(cObsCom)

Begin Transaction

SZ5->( RecLock("SZ5",.F.) )
SZ5->Z5_OBSCOM := cObsCom
SZ5->( MsUnLock() )

If !Empty(cObsCom) .AND. cObsCom <> "OK"
	lLogErr	:= .T.
Endif

End Transaction

Return(.T.)

// Renato Ruy - 03/07/15
//Função para retornar a rede da campanha do contador
Static Function CRR20RD(Desrede)

Local cCodigoR 	:= ""
Local cDescRede := AllTrim(Upper(Desrede))
Local cRede		:= ""

cDescRede := AllTrim(StrTran(cDescRede,"CAMPANHA DO CONTADOR - ",""))
cDescRede := AllTrim(StrTran(cDescRede,"CAMAPNHA DO CONTADOR - ",""))                                               
cDescRede := AllTrim(StrTran(cDescRede,"CAMAPANHA DO CONTADOR - ",""))

Do Case
	Case cDescRede == "AC BR" .Or. cDescRede == "AR BR"
		cCodigoR := "BR"
	Case cDescRede == "AC FENACOR"
		cCodigoR := "FENCR"
	Case cDescRede == "AC SINCOR"
		cCodigoR := "SIN"
	Case cDescRede == "REDE FACESP"
		cCodigoR := "FACES"
	Case cDescRede == "AC BR CREDENCIADA"
		cCodigoR := "BRC"
	Case cDescRede == "REDE CREDENCIADA"
		cCodigoR := "CRD"
	Case cDescRede == "AC SINCOR ENTIDADE DE CLASSE"
		cCodigoR := "SIN"
	Case cDescRede == "AR POLOMASTHER 15%"
		cCodigoR := "SIN"
	Case cDescRede == "AC BOA VISTA"
		cCodigoR := "BV"
	Case cDescRede == "AC SINCOR RIO"
		cCodigoR := "SINRJ"
	Case cDescRede == "AC NOTARIAL"
		cCodigoR := "NOT"
	Case cDescRede == "REDE CACB"
		cCodigoR := "CACB"
	Case cDescRede == "REDE CNC"
		cCodigoR := "CNC"
	Case cDescRede == "AC SINCOR RIO ENTIDADE DE CLASSE"
		cCodigoR := "SINRJ"
	Case cDescRede == "REDE CNC VENDAS PELO SITE"
		cCodigoR := "CNC"
	Case cDescRede $ "SAGE"
		cCodigoR := "SAGE"
	Otherwise
		cCodigoR := " "
EndCase


Return (cCodigoR)

Static Function CRP028Seq(cEntReti)

Local nCiclo := 0

/*		DE-PARA Entidades/Ciclo de Remuneração
		A = 2  = AC
		C = 3  = Canal
		F = 5  = Federação
		P = 1  = Posto
		R = 10 = Clube Revendedor
		S = 6  = Campanha do Contador
		B = 7  = AR
		G = 11 = SAGE
	 	
*/

Do Case
	Case cEntReti == "C"
		nCiclo := 3
	Case cEntReti == "A"
		nCiclo := 2
	Case cEntReti == "S"
		nCiclo := 6
	Case cEntReti == "P" 
		nCiclo := 1
	Case cEntReti == "R" 
		nCiclo := 10
	Case cEntReti == "F" 
		nCiclo := 5
	Case cEntReti == "G" 
		nCiclo := 8						
EndCase

Return nCiclo