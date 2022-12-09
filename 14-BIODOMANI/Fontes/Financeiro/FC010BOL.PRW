User Function FC010BOL(nBrowse,aAlias,aParam,lExibe,aGet,lRelat)

    Local aArea		:= GetArea()
    Local aAreaSC5	:= SC5->(GetArea())
    Local aAreaSC6	:= SC6->(GetArea())
    Local aAreaSC9	:= SC9->(GetArea())
    Local aAreaSF4	:= SF4->(GetArea())
    Local aStru		:= {}
    Local aQuery	:= {}
    Local aSay		:= {"","","","","","","",""}
    Local oGetDb
    Local oScrPanel
    Local oBold
    Local oDlg
    Local oBtn
    Local bVisual
    Local bWhile
    Local bFiltro
    Local cAlias	:= ""
    Local cArquivo	:= ""
    Local cCadastro	:= ""
    Local cQuery	:= ""
    Local cDbMs
    Local cQry		:= ""
    Local cChave	:= ""
    Local lQuery	:= .F.
    Local nCntFor	:= 0
    Local nSalped	:= 0
    Local nSalpedl	:= 0
    Local nSalpedb	:= 0
    Local nQtdPed	:= 0
    Local nTotAbat	:= 0
    Local cAnterior	:= ""
    Local nTaxaM	:= 0
    Local nMoeda
    Local oTipo
    Local nTipo		:= 1
    Local bTipo
    Local oCheq
    Local aTotRec	:= {{0,1,0,0}} // Totalizador de titulos a receber por por moeda
    Local aTotPag	:= {{0,1,0,0}} // Totalizador de titulos recebidos por por moeda
    Local nAscan
    Local nTotalRec	:=0
    Local aSize		:= MsAdvSize( .F. )
    Local aPosObj1	:= {}
    Local aObjects	:= {}
    Local aCpos		:= {}
    Local aCpoVlr	:= {}
    Local cCheques	:=	IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE)
    Local nI := 0
    Local lPosClFt	:= (SuperGetMv("MV_POSCLFT",.F.,"N") == "S")
    Local bCond
    Local cOrdem	:= ""
    Local cNumAnt	:= ""
    Local cTpDocAnt	:= ""
    Local cParcAnt	:= ""
    Local lFC010Head := ExistBlock("FC010HEAD")
    Local cSaldo := ""
    Local lFC010Pedi := ExistBlock("FC010Pedi")
    Local aRetAux	:= {}
    Local lFC0101FAT	:= ExistBlock("FC0101FAT")
    Local lFC0102FAT	:= ExistBlock("FC0102FAT")
    Local lFC0103FAT	:= ExistBlock("FC0103FAT")
    Local aAuxCpo		:= {}
    Local aHeader1		:= {}
    Local nA			:= 0
    Local nMulta		:= 0                            //Valor da Multa
    Local nJuros		:= 0
    Local cMvJurTipo 	:= SuperGetMv("MV_JURTIPO",,"") //Tipo de Calculo de Juros do Financeiro
    Local lLojxRMul  	:= .T.        //Funcao que calcula a Multa do Financeiro
    Local lMvLjIntFS	:= SuperGetMv("MV_LJINTFS", ,.F.) //Habilita Integração com o Financial Services
    Local lFC010bxhe	:= ExistBlock("FC010bxhe")//Ponto de entrada para incluir campo no Head dos Tit. Baixados
    Local nTamFil		:= 0
    Local lFilF4		:= .F.
    Local lFilF4C6		:= .F.
    Local cChaveFK7		:= ""
    Local cChaveTit		:= ""
    Local lSigaGE 		:= GetNewPar( "MV_ACATIVO", .F. )
    Local lValAcess   	:= ExistFunc("FValAcess")
    Local cCmpFilE1		:= ""
    Local cCompSE1		:= ""
    Local cCmpFilE5		:= ""
    Local cCompSE5		:= ""
    Local cSepNeg   	:= If("|"$MV_CPNEG,"|",",")
    Local cSepPag   	:= If("|"$MVPAGANT,"|",",")
    Local cSepRec   	:= If("|"$MVRECANT,"|",",")
    Local aSE5AllFilEmp	:= {}
    Local cTmpFil		:= ""
    Local cMVCRNEG  	:= SuperGetMv("MV_CRNEG",.F.,MVRECANT+"/"+MV_CRNEG)  /*23/11/2018 Diogo Melo*
    Valiavel criada para atender base Agentina trazendo valores negativos de acordo com o conteudo do paramentro
										   */
	/*
	GESTAO - inicio */
	Local nPosAlias	:= 0
	Local cCompSC5	:= ""
	/* GESTAO - fim
	*/
    Local aStrTmp	:= {}
    Local lF010CQTA	:= ExistBlock("F010CQTA")
    Local nPos		:= 0
    Local lFilial	:= ""
    Local lFilOri	:= ""

    Private aHeader	:= {}
    Private cFilCorr:= cFilAnt

    //DEFAULT lRelat	:= .F.

    If MV_PAR17 == 1 .AND. Len(aSelFil) <= 0 .AND. FWModeAccess("SA1",3) == "C"	// Chamar a tela de seleção de filiais caso não tenha sido chamada anteriormente. Quando chamado o botão diretamente.
        If  FindFunction("AdmSelecFil")
            AdmSelecFil("FIC010",17,.F.,@aSelFil,"SE1",(FwModeAccess("SE1",1) == "E"),(FwModeAccess("SE1",2) == "E"),cFilCorr)
        Else
            aSelFil := AdmGetFil(.F.,.F.,"SE1")
        Endif
    Endif
    If Empty(aSelFil)
        Aadd(aSelFil,cFilCorr)
    Endif

    aGet := {"","","","","","","",""}

    cCadastro := "Titulos em Aberto"
    cAlias    := "FC010QRY01"
    aSay[1]   := "Qtd.Tit."
    aSay[2]   := "Principal"
    aSay[3]   := "Saldo a Receber"
    aSay[4]   := "Juros"
    aSay[5]   := "Acresc."
    aSay[6]   := "Decresc."
    aSay[7]   := "Abatimentos"
    aSay[8]   := "Tot.Geral"
    aSay[9]   := "Saldo Atrasado"
    bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }

    If !lRelat .And. (cPaisLoc == "BRA" .Or. cPaisLoc == "MEX" )
        Aadd(aHeader,{"",	"XX_LEGEND","@BMP",10,0,"","","C","",""})
        Aadd(aStru,{"XX_LEGEND","C",12,0})
    Endif
    dbSelectArea("SX3")
    dbSetOrder(2)
    dbSeek("E1_LOJA")
    If aParam[13] == 2  //Considera loja
        aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    Endif
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		/* 
		GESTAO - inicio */
		dbSeek("E1_FILORIG")
    If !lRelat
			nTamFil := Len(SM0->(AllTrim(M0_CODFIL) + " - " + M0_NOME))
    else
			nTamFil := Len(SM0->(AllTrim(M0_CODFIL)))
    Endif
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,nTamFil,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,nTamFil,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,nTamFil,SX3->X3_DECIMAL})
		/* GESTAO - fim
		*/
    dbSeek("E1_PREFIXO")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_NUM")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_PARCELA")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_TIPO")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    If !lRelat .and. cPaisLoc == 'BRA'
        dbSeek("E1_NFELETR")
        aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
        aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
        aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    Endif

    dbSeek("E1_CLIENTE")
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_EMISSAO")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_VENCTO")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_BAIXA")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_VENCREA")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    If !lRelat
        dbSeek("E1_MOEDA")
        aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )

        dbSeek("E1_VALOR")
        aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
        aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
        aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    Endif

    dbSeek("E1_VLCRUZ")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    aadd(aHeader,{STR0086,"E1_ABT","@E 999,999,999.99",14,2,"","","N","","V" } ) //"Abatimentos"
    aadd(aStru ,{"E1_ABT","N",14,2})

    dbSeek("E1_SDACRES")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_SDDECRE")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    dbSeek("E1_VALJUR")
    aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
    aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ 11/Ago/2005 Rafael E. Rodrigues                             ³
    //³ Quando o modulo Gestao Educacional estiver em uso, inclui a ³
    //³ coluna com a provisao de multa de titulos em atraso.        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lSigaGE
        dbSeek("E1_VLMULTA")
        aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
        aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
        aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

        dbSeek("E1_MULTA")
        aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
        aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    Else
        //Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Inicio
			/*BEGINDOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calculo de juros e multas, segundo o controle de loja³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    ENDDOC*/
    If (cMVJurTipo == "L" .OR. lMvLjIntFS).AND. lLojxRMul
				dbSeek("E1_MULTA")		
				aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
				aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    EndIf
			//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Final
Endif

		//Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Inicio	
		/*BEGINDOC
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calculo de juros e multas, segundo o controle de loja³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
If (cMVJurTipo == "L" .OR. lMvLjIntFs) .and. lLojxRMul
			dbSeek("E1_ACRES")		
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

			dbSeek("E1_JUROS")		
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf
		//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Final
		
		//Valores Acessorios
If __lExisFKD
    If dbSeek("FKD_VALOR")
				aadd(aHeader,{ AllTrim(STR0139),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )//"Valores Acessorios"
				aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
    Endif
Endif

		dbSeek("E1_SALDO")
		aadd(aHeader,{STR0120,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )	//"Saldo a Receber"
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aHeader,{ STR0103,"E1_SALDO2",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) // "Saldo na moeda tit"
		aadd(aStru ,{"E1_SALDO2",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

If !lRelat
			dbSeek("E1_NATUREZ")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
Endif
		
		dbSeek("E1_PORTADO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})		

		dbSeek("E1_NUMBCO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

If !lRelat
			dbSeek("E1_NUMLIQ")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
Endif

		dbSeek("E1_HIST")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aHeader,{STR0035,"E1_ATR","9999999999",10,0,"","","N","","V" } ) //"Atraso"
		aadd(aStru ,{"E1_ATR","N",10,0})

If !lRelat
			dbSeek("E1_CHQDEV")
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf
		//sitcob
		dbSeek("E1_SITUACA")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
If cPaisLoc == "BRA"
		    Aadd(aStru,{"ZZ_STATUS","C",40,0})
EndIf
		Aadd(aStru,{"FRV_DESCRI","C",40,0})
		aadd(aStru,{"XX_RECNO","N",12,0})
		aadd(aStru,{"E1_MOEDA","N",02,0})

		aadd(aQuery,{"E1_PORCJUR","N",12,4})
		aadd(aQuery,{"E1_MOEDA","N",02,0})
		aadd(aQuery,{"E1_VALOR","N",16,2})

If cPaisLoc == "BRA"
			aadd(aQuery,{"E1_TXMOEDA","N",17,4})
EndIf

If !lRelat .and. cPaisLoc == "BRA"
			Aadd(aHeader,{STR0137,"ZZ_STATUS","@!",40,0,"","","C","","V" } ) //"Status Serasa"
			//sitcob
			Aadd(aHeader,{STR0045,"FRV_DESCRI","@!",40,0,"","","C","FRV","" } ) //"Situacao"
EndIf

IF lFC010Head
			aHeader1 :=	aHeader			
			aHeader 	:=	ExecBlock("FC010HEAD",.F.,.F.,aHeader)							

    For nA:=1 to Len(aHeader)
        If Ascan(aHeader1,{|e| e[2] = aHeader[nA,2]}) = 0//Campo nao estava no header incluir tambem nestes vetores.
					aadd(aStru ,{aHeader[nA,2],aHeader[nA,8],aHeader[nA,4],aHeader[nA,5]})
					aadd(aQuery,{aHeader[nA,2],aHeader[nA,8],aHeader[nA,4],aHeader[nA,5]})												
        Endif
    Next
EndIf

		SX3->(dbSetOrder(1))

If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})

    If _oFINC0101 <> Nil
				_oFINC0101:Delete()
				_oFINC0101 := Nil
    Endif

			_oFINC0101 := FWTemporaryTable():New( cAlias )  
			_oFINC0101:SetFields(aStru) 
			_oFINC0101:AddIndex("1", {"E1_FILORIG","E1_CLIENTE","E1_LOJA","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO"})

			//------------------
			//Criação da tabela temporaria
			//------------------
			_oFINC0101:Create()  


    #IFDEF TOP
        If ( TcSrvType()!="AS/400" )
				lQuery := .T.
				cQuery := ""
				aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
				cQuery := "SELECT "+SubStr(cQuery,2)
				cQuery +=         ",SE1.R_E_C_N_O_ SE1RECNO"
				cQuery +=         ",FRV.FRV_DESCRI "
				cQuery +=		  ",SE1.E1_FILIAL "
				cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
				cQuery +=         RetSqlName("FRV")+" FRV "
				cQuery += "WHERE "
				/*
				GESTAO - inicio */
				nPosAlias := FC010QFil(1,"SE1")
				cQuery += "SE1.E1_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
				/* GESTAO - fim
				*/
            cQuery +=       "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
            If aParam[13] == 1  //Considera loja
                cQuery +=       "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
            Endif
            cQuery +=       "SE1.E1_EMISSAO>='"+Dtos(aParam[1])+"' AND "
            cQuery +=       "SE1.E1_EMISSAO<='"+Dtos(aParam[2])+"' AND "
            cQuery +=       "SE1.E1_VENCREA>='"+Dtos(aParam[3])+"' AND "
            cQuery +=       "SE1.E1_VENCREA<='"+Dtos(aParam[4])+"' AND "
            If ( aParam[5] == 2 )
                cQuery +=   "SE1.E1_TIPO<>'PR ' AND "
            EndIf
            If ( aParam[15] == 2 )
                cQuery +=   "SE1.E1_TIPO<>'RA ' AND "
            Endif
            cQuery += "SE1.E1_PREFIXO>='"+aParam[6]+"' AND "
            cQuery += "SE1.E1_PREFIXO<='"+aParam[7]+"' AND "
            If cPaisLoc != "BRA"
                cQuery += "SE1.E1_TIPO NOT IN" + FormatIn(cCheques,"|") + " AND "
            Endif
            cQuery += "SE1.E1_SALDO > 0 AND "

            If aParam[11] == 2 // Se nao considera titulos gerados pela liquidacao
                If aParam[09] == 1
                    cQuery += "SE1.E1_NUMLIQ ='"+Space(Len(SE1->E1_NUMLIQ))+"' AND "
                Else
                    cQuery += "SE1.E1_TIPOLIQ='"+Space(Len(SE1->E1_TIPOLIQ))+"' AND "
                    cQuery += "SE1.E1_NUMLIQ ='"+Space(Len(SE1->E1_NUMLIQ))+"' AND "
                Endif
            Else
                If aParam[09] == 2
                    cQuery += "SE1.E1_TIPOLIQ='"+Space(Len(SE1->E1_TIPOLIQ))+"' AND "
                Endif
            Endif

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Ponto de entrada para filtrar pelo MSFIL em caso de ³
            //³ arquivo compartilhado.  Titulos em aberto           ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If (ExistBlock("FO10FILT"))
                cQuery += ExecBlock("FO10FILT",.F.,.F.)
            Endif

            //SITCOB
            cQuery +=		"SE1.D_E_L_E_T_<>'*' AND "
            cQuery +=    	"FRV.FRV_FILIAL = '"+xFilial("FRV")+"' AND "
            cQuery +=		"FRV.FRV_CODIGO = SE1.E1_SITUACA AND "
            cQuery +=		"FRV.D_E_L_E_T_<>'*' "

            cQuery += "AND SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM,"|")

            If UPPER(TcGetDb()) != "INFORMIX"
                cQuery   += " ORDER BY  " + SqlOrder("E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+SE1RECNO")
            Endif

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Ponto de entrada para alteracao da cQuery na consulta Titulos em Aberto ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lF010CQTA
                cQuery := ExecBlock("F010CQTA",.F.,.F.,{cQuery})
            EndIf

            cQuery := ChangeQuery(cQuery)
            cQry   := cArquivo+"A"

            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

            If lF010CQTA
                aStrTmp := (cQry)->(DBSTRUCT())
            EndIf

            aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
        Else
        #ENDIF
        cQry := "SE1"
        #IFDEF TOP
        EndIf
    #ENDIF
    dbSelectArea(cQry)
    If ( !lQuery )
        dbSetOrder(2)
        If aParam[13] == 1 //Considera loja
            dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
            bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
                SA1->A1_COD    == SE1->E1_CLIENTE .And.;
                SA1->A1_LOJA   == SE1->E1_LOJA }
        Else
            dbSeek(xFilial("SE1")+SA1->A1_COD)
            bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
                SA1->A1_COD    == SE1->E1_CLIENTE }
        Endif

        bFiltro:= {|| !(SE1->E1_TIPO $ MVABATIM) .And.;
            SE1->E1_EMISSAO >= aParam[1] .And.;
            SE1->E1_EMISSAO <= aParam[2] .And.;
            SE1->E1_VENCREA >= aParam[3] .And.;
            SE1->E1_VENCREA <= aParam[4] .And.;
            If(aParam[5]==2,SE1->E1_TIPO!="PR ",.T.) .And.;
                If(aParam[15]==2,!SE1->E1_TIPO$MVRECANT,.T.) .And.;
                    SE1->E1_PREFIXO >= aParam[6] .And.;
                    SE1->E1_PREFIXO <= aParam[7] .And.;
                    SE1->E1_SALDO   > 0 .And.;
                    IIf(cPaisLoc == "BRA",.T.,!(SE1->E1_TIPO$cCheques)) .And.;
                    IIF(aParam[11] == 2, Empty(SE1->E1_NUMLIQ) .And. Empty(SE1->E1_TIPOLIQ),.T.)}
            Else
                bWhile := {|| !Eof() }
                bFiltro:= {|| .T. }
            EndIf

            cFilAux := cFilAnt

            If lF010CQTA
                lFilial	:= "U" $ Type("(cQry)->E1_FILIAL")
                lFilOri	:= "U" $ Type("(cQry)->E1_FILORIG")
            EndIf

            While ( Eval(bWhile) )
                If ( Eval(bFiltro) )
                    // SETA A FILIAL DO TITULO
                    If lF010CQTA
                        If !lFilOri
                            cFilAnt := (cQry)->E1_FILORIG
                        EndIf
                    Else
                        cFilAnt := (cQry)->E1_FILORIG
                    EndIf
                    dbSelectArea(cAlias)
                    dbSetOrder(1)
                    cChave := Iif( lF010CQTA, Iif( !lFilOri, (cQry)->E1_FILORIG, cFilAnt), (cQry)->E1_FILORIG)+(cQry)->(E1_CLIENTE)+(cQry)->(E1_LOJA) +;
                        (cQry)->(E1_PREFIXO)+(cQry)->(E1_NUM)+;
                        (cQry)->(E1_PARCELA)
                    cChave += If((cQry)->(E1_TIPO)	$ MVABATIM, "",;
                        (cQry)->(E1_TIPO))
                    If ( !dbSeek(cChave) )
                        RecLock(cAlias,.T.)
                    Else
                        RecLock(cAlias,.F.)
                    EndIf
                    DbSetOrder(1)
                    nTotAbat := 0

                    //Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Inicio
                    nMulta := 0
                    nJuros := 0
                    nVA := 0		//Valores Acessórios
                    //Saldo Corrigido - Calcula juros e multa
                    If aParam[12] == 2
                        If !( (cQry)->E1_TIPO $ MVRECANT + "|" + MV_CRNEG ) .And. (cMVJurTipo == "L" .OR. lMvLjIntFS) .AND. lLojxRMul .and. (cQry)->E1_SALDO == (cQry)->E1_VALOR
                            nMulta := LojxRMul( , , ,(cQry)->E1_SALDO, (cQry)->E1_ACRESC, (cQry)->E1_VENCREA,  , , (cQry)->E1_MULTA, ,;
                                (cQry)->E1_PREFIXO, (cQry)->E1_NUM, (cQry)->E1_PARCELA, (cQry)->E1_TIPO, (cQry)->E1_CLIENTE, (cQry)->E1_LOJA,, .T.  )
                        EndIf

                        nJuros := xMoeda(FaJuros((cQry)->E1_VALOR,(cQry)->E1_SALDO,(cQry)->E1_VENCTO,(cQry)->E1_VALJUR,(cQry)->E1_PORCJUR,;
                            (cQry)->E1_MOEDA,(cQry)->E1_EMISSAO,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0),(cQry)->E1_BAIXA,;
                            (cQry)->E1_VENCREA,,(cQry)->E1_PREFIXO, (cQry)->E1_NUM, (cQry)->E1_PARCELA,(cQry)->E1_TIPO),;
                            (cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))

                        //Chamar calculo Valores Acessorios
                        If lValAcess
                            nVa := FValAcess(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA, SE1->E1_NATUREZ,!Empty(SE1->E1_BAIXA),,"R",SE1->E1_BAIXA,,SE1->E1_MOEDA)
                        EndIf
                    EndIf
                    //Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Final

                    For nCntFor := 1 To Len(aStru)
                        Do Case
                        Case ( AllTrim(aStru[nCntFor][1])=="FRV_DESCRI" )
                            If !( (cQry)->(E1_TIPO)	$ MVABATIM )
                                If ( lQuery )
                                    If ( aScan(aStrTmp, {|x| x[1] == "E1_SITUACA" }) ) > 0
                                        (cAlias)->FRV_DESCRI := FN022SITCB((cQry)->E1_SITUACA)[9]
                                    Else
                                        (cAlias)->FRV_DESCRI := ""
                                    EndIf
                                Else
                                    (cAlias)->FRV_DESCRI := FN022SITCB(SE1->E1_SITUACA)[9]
                                EndIf
                            Endif
                        Case ( AllTrim( aStru[nCntFor][1] ) == "ZZ_STATUS" )
                            If !( (cQry)->(E1_TIPO) $ MVABATIM )
                                If ( lQuery )
                                    cChaveTit	:=	(cQry)->(	xFilial('SE1',Iif( lF010CQTA, Iif( !lFilOri, E1_FILORIG, cFilAnt), E1_FILORIG))	+"|"+;
                                        E1_PREFIXO					+"|"+;
                                        E1_NUM						+"|"+;
                                        E1_PARCELA					+"|"+;
                                        E1_TIPO						+"|"+;
                                        E1_CLIENTE					+"|"+;
                                        E1_LOJA)

                                    cIdDoc	:= FINGRVFK7("SE1", cChaveTit, Iif( lF010CQTA, Iif( !lFilOri, (cQry)->E1_FILORIG, cFilAnt), (cQry)->E1_FILORIG))
                                    If cPaisLoc == "BRA"
                                        (cAlias)->ZZ_STATUS := GetStatus(.F., cIdDoc)
                                    EndIf
                                EndIf
                            Endif
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_VALJUR" )
                            (cAlias)->E1_VALJUR := nJuros
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_MULTA" )
                            (cAlias)->E1_MULTA := nMulta
                            //Valores Acessorios
                        Case ( AllTrim(aStru[nCntFor][1])=="FKD_VALOR" )
                            If __lExisfkd .and. lValAcess
                                nVa := FValAcess((calias)->E1_PREFIXO,(calias)->E1_NUM,(calias)->E1_PARCELA,(calias)->E1_TIPO,(calias)->E1_CLIENTE,(calias)->E1_LOJA, iif(!lRelat,(calias)->E1_NATUREZ,),!Empty((calias)->E1_BAIXA),,"R",(calias)->E1_BAIXA,,(calias)->E1_MOEDA)
                                (cAlias)->FKD_VALOR := nVa
                            EndIf
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_ABT" )
                            If cPaisLoc == "BRA"
                                nTaxaM := (cQry)->E1_TXMOEDA
                            Else
                                nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclusão do titulo
                            EndIf
                            If ( lQuery )
                                nTotAbat := SomaAbat((cQry)->E1_PREFIXO,(cQry)->E1_NUM,(cQry)->E1_PARCELA,"R",1,,(cQry)->E1_CLIENTE,(cQry)->E1_LOJA,If( !lFilial, (cQry)->E1_FILIAL, Nil),/*DATA REF.*/,(cQry)->E1_TIPO)
                                dbSelectArea(cAlias)
                                (cAlias)->E1_ABT := nTotAbat
                            Else
                                (cAlias)->E1_ABT := (nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL,/*DATA REF.*/,(cQry)->E1_TIPO))
                            Endif

                        Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO" )
                            If cPaisLoc == "BRA"
                                nTaxaM := (cQry)->E1_TXMOEDA
                            Else
                                nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclusão do titulo
                            Endif
                            (cAlias)->E1_SALDO += xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
                            (cAlias)->E1_SALDO -= nTotAbat
                            (cAlias)->E1_SALDO += xMoeda((cQry)->(E1_SDACRES) - (cQry)->(E1_SDDECRE),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)

                            If aParam[12] == 2 // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.

                                If !( (cAlias)->E1_TIPO $ MVRECANT + "|" + MV_CRNEG )
                                    (cAlias)->E1_SALDO += nJuros
                                    (cAlias)->E1_SALDO += nVA
                                    (cAlias)->E1_SALDO += xMoeda(nMulta,(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))

                                    //-------------------------------------------------------------------------------------------------
                                    // Quando o modulo Gestao Educacional estiver em uso, inclui a
                                    // provisao de multa no saldo de titulos em atraso.
                                    //-------------------------------------------------------------------------------------------------
                                    If lSigaGE
                                        (cAlias)->E1_SALDO += xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
                                    Endif
                                EndIf
                            EndIf
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO2" )

                            (cAlias)->E1_SALDO2 += (cQry)->(E1_SALDO)
                            (cAlias)->E1_SALDO2 -= nTotAbat
                            (cAlias)->E1_SALDO2 += (cAlias)->E1_SDACRES - (cAlias)->E1_SDDECRE

                            If !( (cAlias)->E1_TIPO $ MVRECANT + "|" + MV_CRNEG )
                                //Calculo de Juros e Multas: SIGALOJA x SIGAFIN   -Inicio
                                (cAlias)->E1_VALJUR := nJuros


                            EndIf
                            //Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Final
                            If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.

                                If !( (cAlias)->E1_TIPO $ MVRECANT + "|" + MV_CRNEG )
                                    (cAlias)->E1_SALDO2 += xMoeda((cAlias)->E1_VALJUR,1,(cQry)->(E1_MOEDA),dDataBase,,ntaxaM)
                                    IF __lExisFKD .and. !lRelat
                                        (cAlias)->E1_SALDO2 += xMoeda((cAlias)->FKD_VALOR,1,(cQry)->(E1_MOEDA),dDataBase,,ntaxaM) //Valores Acessorios
                                    Endif
                                    If (cMVJurTipo == "L" .OR. lMvLjIntFS) .and. lLojxRMul
                                        (cAlias)->E1_SALDO2 += xMoeda((cAlias)->E1_MULTA,1,(cQry)->(E1_MOEDA),dDataBase,,ntaxaM)
                                    EndIf

                                    //-------------------------------------------------------------------------------------------------
                                    // Quando o modulo Gestao Educacional estiver em uso, inclui a
                                    // provisao de multa no saldo de titulos em atraso.
                                    //-------------------------------------------------------------------------------------------------
                                    If lSigaGE
                                        (cAlias)->E1_SALDO2 += xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
                                    Endif
                                EndIf
                            Endif
                        Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
                            If !( (cQry)->(E1_TIPO)	$ MVABATIM )
                                If ( lQuery )
                                    (cAlias)->XX_RECNO := (cQry)->SE1RECNO
                                Else
                                    (cAlias)->XX_RECNO := SE1->(RecNo())
                                EndIf
                            Endif
                            //Tabela FWA - Situação de título Serasa, não existe em países localizados
                        Case (cPaisLoc == "BRA" .Or. cPaisLoc == "MEX") .And. ( !lRelat .And. AllTrim(aStru[nCntFor][1])=="XX_LEGEND" )//Rodrigo

                            If cPaisLoc != "MEX"
                                DbSelectArea("FWA")
                                FWA->( DbSetOrder(3) )

                                If 	FWA->(DbSeek((cQry)->(Iif( lF010CQTA, Iif( !lFilOri, E1_FILORIG, cFilAnt), E1_FILORIG)+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))) .AND. FWA->(FWA_STATUS) == "3"
                                    (cAlias)->XX_LEGEND  := 	"DISABLE"
                                ElseIf (cQry)->E1_CHQDEV == "1"
                                    (cAlias)->XX_LEGEND  := 	"BR_AMARELO"
                                Else
                                    If !((cQry)->E1_TIPO $ MVABATIM)
                                        (cAlias)->XX_LEGEND := If(ROUND((cQry)->E1_SALDO,2) != ROUND((cQry)->E1_VALOR,2),"BR_AZUL","BR_VERDE")
                                    EndIf
                                Endif
                                FWA->(DbCloseArea())
                            Else
                                If (cQry)->E1_CHQDEV == "1"
                                    (cAlias)->XX_LEGEND := "BR_AMARELO"
                                Else
                                    (cAlias)->XX_LEGEND := If(ROUND((cQry)->E1_SALDO,2) != ROUND((cQry)->E1_VALOR,2),"BR_AZUL","BR_VERDE")
                                Endif
                            Endif
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_TIPO" )
                            If ( Empty((cAlias)->E1_TIPO) )
                                (cAlias)->E1_TIPO := (cQry)->E1_TIPO
                            EndIf
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
                            //Se o título estiver atrasado, faz o calculo dos dias de atraso
                            If dDataBase > (cQry)->E1_VENCREA
                                If (((cAlias)->E1_TIPO) $ MVRECANT+"/"+MV_CRNEG)
                                    (cAlias)->E1_ATR := 0
                                Else
                                    (cAlias)->E1_ATR := dDataBase - (cAlias)->E1_VENCTO
                                EndIf
                            Else
                                If MV_PAR16 == 2 //Se o título NÃO estiver atrasado, então tem ATRASO = 0
                                    (cAlias)->E1_ATR := 0
                                Else
                                    (cAlias)->E1_ATR := dDataBase - DataValida((cAlias)->E1_VENCREA,.T.)
                                EndIf
                            Endif
                        Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_FILORIG" )
                            (cAlias)->E1_FILORIG := AllTrim(Iif( lF010CQTA, Iif( !lFilOri, (cQry)->E1_FILORIG, cFilAnt), (cQry)->E1_FILORIG)) + " - " + FWFilialName(/*Grupo*/,Iif( lF010CQTA, Iif( !lFilOri, (cQry)->E1_FILORIG, cFilAnt), (cQry)->E1_FILORIG),1)
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
                            If !((cQry)->(E1_TIPO)	$ MVABATIM)
                                (cAlias)->E1_VLCRUZ := xMoeda((cQry)->(E1_VALOR),(cQry)->(E1_MOEDA),1,dDataBase,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
                                If Alltrim((cQry)->(E1_TIPO)) $ Alltrim(cMVCRNEG)
                                    (cAlias)->E1_VLCRUZ := (cAlias)->E1_VLCRUZ * (-1)
                                EndIf
                            Endif
                        Case ( AllTrim(aStru[nCntFor][1])=="E1_VLMULTA" )
                            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                            //³ 11/Ago/2005 Rafael E. Rodrigues                              ³
                            //³ Quando o modulo Gestao Educacional estiver em uso eh exibida ³
                            //³ a provisao de multa no saldo de titulos em atraso.           ³
                            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            (cAlias)->E1_VLMULTA := xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)

                        OtherWise
                            If lF010CQTA
                                If ( nPos := aScan(aStrTmp, {|x| x[1] == aStru[nCntFor][1] }) ) > 0
                                    If !( (cQry)->(E1_TIPO)	$ MVABATIM )
                                        (cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
                                    EndIf
                                Else
                                    If !( (cQry)->(E1_TIPO)	$ MVABATIM )
                                        If aStru[nCntFor][2] == 'N'
                                            (cAlias)->(FieldPut(nCntFor, 0 ))
                                        Else
                                            (cAlias)->(FieldPut(nCntFor, "" ))
                                        EndIf
                                    EndIf
                                EndIf
                                nPos	:= 0
                            Else
                                If !( (cQry)->(E1_TIPO)	$ MVABATIM )
                                    (cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
                                EndIf
                            EndIf
                        EndCase
                    Next nCntFor
                    dbSelectArea(cAlias)
                    If nTotAbat = 0
                        If ( (cAlias)->E1_SALDO <= 0 )
                            dbDelete()
                        EndIf
                    Endif
                    MsUnLock()
                EndIf
                dbSelectArea(cQry)
                dbSkip()
            EndDo

            cFilAnt := cFilAux

            If ( lQuery )
                dbSelectArea(cQry)
                dbCloseArea()
            EndIf
            cOrdem := "DTOS(E1_VENCREA)"

            If (ExistBlock("F010ORD1"))
                //Retornar chave no formato "E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PREFIXO+E1_NUM+E1_PARCELA+SE1RECNO"
                cOrdem := ExecBlock("F010ORD1",.F.,.F.)
            Endif

            dbSelectArea(cAlias)
            IndRegua(cAlias,cArquivo,cOrdem)
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Totais da Consulta ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aGet[1] := 0
        aGet[2] := 0
        aGet[3] := 0
        aGet[4] := 0
        aGet[5] := 0
        aGet[6] := 0
        aGet[7] := 0
        aGet[8] := 0
        aTotRec := {{0,1,0,0}} // Totalizador de titulos a receber por moeda
        dbSelectArea(cAlias)
        dbGotop()
        While !EOF()
            aGet[1]++
            If !lRelat
                SE1->(DbGoto((cAlias)->XX_RECNO))	// Posiciona no arquivo original para obter os valores
                // em outras moedas e em R$
                nAscan := Ascan(aTotRec,{|e| e[MOEDATIT] == E1_MOEDA})
            Endif

            //Calcular o abatimento para visualização em tela
            If (cAlias)->E1_ABT > 0
                //(cAlias)->E1_SALDO -= (cAlias)->E1_ABT
                (cAlias)->E1_SALDO2 := xMoeda((cAlias)->E1_SALDO,E1_MOEDA,1,dDataBase,,ntaxaM)
            Endif

            If E1_TIPO $ "RA #"+MV_CRNEG
                aGet[2] -= E1_VLCRUZ
                aGet[3] -= E1_SALDO
                aGet[4] -= E1_VALJUR

                nAcresc := nDecres := 0
                If !lRelat
                    nAcresc := xMoeda(E1_SDACRES,E1_MOEDA,1,dDataBase,,ntaxaM)
                    nDecres := xMoeda(E1_SDDECRE,E1_MOEDA,1,dDataBase,,ntaxaM)
                    aGet[5] -= nAcresc
                    aGet[6] -= nDecres
                    If nAscan = 0
                        Aadd(aTotRec,{1,E1_MOEDA,SE1->E1_SALDO*(-1),If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)*(-1)})
                    Else
                        aTotRec[nAscan][QTDETITULOS]--
                        aTotRec[nAscan][VALORTIT]	-= SE1->E1_SALDO
                        aTotRec[nAscan][VALORREAIS]	-= If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)
                    Endif
                Endif
                If aParam[12] == 1 //Saldo sem correcao
                    aGet[8] -= E1_SALDO-E1_ABT+E1_VALJUR+nAcresc-nDecres
                Else
                    aGet[8] -= E1_SALDO
                Endif
            Else
                aGet[2] += E1_VLCRUZ
                aGet[3] += E1_SALDO
                aGet[4] += E1_VALJUR
                aGet[7] += E1_ABT
                nAcresc := nDecres := 0
                If !lRelat
                    nAcresc := xMoeda(E1_SDACRES,E1_MOEDA,1,dDataBase,,ntaxaM)
                    nDecres := xMoeda(E1_SDDECRE,E1_MOEDA,1,dDataBase,,ntaxaM)
                    aGet[5] += nAcresc
                    aGet[6] += nDecres
                    If nAscan = 0
                        Aadd(aTotRec,{1,E1_MOEDA,SE1->E1_SALDO,If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)})
                    Else
                        aTotRec[nAscan][QTDETITULOS]++
                        aTotRec[nAscan][VALORTIT]	+= SE1->E1_SALDO
                        aTotRec[nAscan][VALORREAIS]	+= If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)
                    Endif
                Endif
                If aParam[12] == 1 //Saldo sem correcao
                    aGet[8] += E1_SALDO-E1_ABT+E1_VALJUR+nAcresc-nDecres
                Else
                    aGet[8] += E1_SALDO
                Endif
            Endif
            dbSkip()
        Enddo
        If !lRelat
            nTotalRec:=0
            aEval(aTotRec,{|e| nTotalRec+=e[VALORREAIS]})
            Aadd(aTotRec,{"","",STR0096,nTotalRec}) //"Total ====>>"
            // Formata as colunas
            aEval(aTotRec,{|e|	If(ValType(e[VALORTIT]) == "N"	, e[VALORTIT]		:= Transform(e[VALORTIT],Tm(e[VALORTIT],16,nCasas)),Nil),;
                If(ValType(e[VALORREAIS]) == "N"	, e[VALORREAIS]	:= Transform(e[VALORREAIS],Tm(e[VALORREAIS],16,nCasas)),Nil)})
            Endif

            aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
            aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))
            aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,nCasas))
            aGet[4] := TransForm(aGet[4],Tm(aGet[4],16,nCasas))
            aGet[5] := TransForm(aGet[5],Tm(aGet[5],16,nCasas))
            aGet[6] := TransForm(aGet[6],Tm(aGet[6],16,nCasas))
            aGet[7] := TransForm(aGet[7],Tm(aGet[7],16,nCasas))
            aGet[8] := TransForm(aGet[8],Tm(aGet[8],16,nCasas))
            aGet[9] := TransForm(aGet[9],Tm(aGet[9],16,nCasas))
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Exibe os dados Gerados ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If ( lExibe )
                dbSelectArea(cAlias)
                dbGotop()
                If ( !Eof() )

                    aObjects := {}
                    AAdd( aObjects, { 100, 35,  .t., .f., .t. } )
                    AAdd( aObjects, { 100, 100 , .t., .t. } )
                    AAdd( aObjects, { 100, 50 , .t., .f. } )

                    aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
                    aPosObj1 := MsObjSize( aInfo, aObjects)

                    DEFINE FONT oBold    NAME "Arial" SIZE 0, -12 BOLD

                    DEFINE MSDIALOG oDlg FROM	aSize[7],0 TO aSize[6],aSize[5] TITLE cCadastro OF oMainWnd PIXEL
                    @ aPosObj1[1,1], aPosObj1[1,2] MSPANEL oScrPanel PROMPT "" SIZE aPosObj1[1,3],aPosObj1[1,4] OF oDlg LOWERED

                    @ 04,004 SAY OemToAnsi(STR0006) SIZE 025,07          OF oScrPanel PIXEL //"Codigo"
                    @ 12,004 SAY SA1->A1_COD  SIZE 060,09  OF oScrPanel PIXEL FONT oBold

                    If aParam[13] == 1  //Considera loja
                        @ 04,067 SAY OemToAnsi(STR0007) SIZE 020,07          OF oScrPanel PIXEL //"Loja"
                        @ 12,067 SAY SA1->A1_LOJA SIZE 021,09 OF oScrPanel PIXEL FONT oBold
                    Endif

                    @ 04,090 SAY OemToAnsi(STR0008) SIZE 025,07 OF oScrPanel PIXEL //"Nome"
                    @ 12,090 SAY SA1->A1_NOME SIZE 165,09 OF oScrPanel PIXEL FONT oBold

                    oGetDb:=MsGetDB():New(aPosObj1[2,1],aPosObj1[2,2],aPosObj1[2,3],aPosObj1[2,4],2,"",,,.F.,,,.F.,,cAlias,,,,,,.T.)
                    oGetdb:lDeleta:=NIL
                    dbSelectArea(cAlias)
                    dbGotop()

                    @ aPosObj1[3,1]+04,005 SAY aSay[1] SIZE 045,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+04,175 SAY aSay[2] SIZE 045,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+15,005 SAY aSay[3] SIZE 045,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+15,175 SAY aSay[4] SIZE 045,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+26,005 SAY aSay[5] SIZE 045,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+26,175 SAY aSay[6] SIZE 045,07 OF oDlg PIXEL

                    @ aPosObj1[3,1]+04,060 SAY aGet[1] SIZE 060,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+04,215 SAY aGet[2] SIZE 060,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+15,060 SAY aGet[3] SIZE 060,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+15,215 SAY aGet[4] SIZE 060,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+26,060 SAY aGet[5] SIZE 060,07 OF oDlg PIXEL
                    @ aPosObj1[3,1]+26,215 SAY aGet[6] SIZE 060,07 OF oDlg PIXEL

                    If ( nBrowse == 1 ) // Para titulos em aberto, mostra legenda.
                        Fc010Legenda(oDlg,aPosObj1,aSay,aGet)
                    Endif

                    DEFINE SBUTTON 		FROM 04,aPosObj1[1,3]-If(nBrowse <= 2,60,30) TYPE  1  ENABLE OF oScrPanel ACTION ( oDlg:End() )
                    // Exibe o botao de distribuicao por moedas, apenas na consulta de titulos
                    // em aberto e recebidos
                    If nBrowse <= 2
                        SButton():New(04, aPosObj1[1,3]-30, 18,{||Fc010Moeda(If(nBrowse==1,aTotRec,aTotPag),oScrPanel)},oScrPanel,.T.,STR0097) //"Consulta distribuição por moedas"
                        TButton():New(19, aPosObj1[1,3]-60,'Excel',oScrPanel,{||Fc010Excel(cAlias,aHeader,aParam,nBrowse)},26,10,,,,.T.)
                    Endif

                    DEFINE SBUTTON oBtn 	FROM 19,aPosObj1[1,3]-30 TYPE 15 ENABLE OF oScrPanel

                    oBtn:lAutDisable := .F.
                    If ( bVisual != Nil )
                        oBtn:bAction := bVisual
                    Else
                        oBtn:SetDisable(.T.)
                    EndIf
                    ACTIVATE MSDIALOG oDlg
                Else
                    Help(" ",1,"REGNOIS")
                EndIf
                If nBrowse == 5
                    (cAlias)->(dbCloseArea()) //;Ferase(cArquivo+GetDBExtension());Ferase(cArquivo+OrdBagExt())
                    If _oFINC0105 <> Nil
                        _oFINC0105:Delete()
                        _oFINC0105 := Nil
                    Endif
                Endif
            EndIf

            CtbTmpErase(cTmpFil)

            RestArea(aAreaSC5)
            RestArea(aAreaSC6)
            RestArea(aAreaSC9)
            RestArea(aAreaSF4)
            RestArea(aArea)

            Return(aHeader)