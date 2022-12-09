#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F470ATRBºAutor  ³Eugenio Arcanjo  º Data ³  29/06/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Complementa gravação da SE5 após a efetivação da Conciliação º±±
±±º          ³ Bancária Automática						.  				   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION F470ATRB()
Local _aAreaX  := GetArea()
Local _cNatur := "" //PadR(TRB->NUMMOV,10)
Local _lRet := .T.
Local cCCD			:= CRIAVAR("E5_CCD")	// Centro Custo Debito
Local cCCC			:= CRIAVAR("E5_CCC") // Centro Custo Credito
Local cItemD		:= CRIAVAR("E5_ITEMD")  //Item contabil Debito
Local cItemC		:= CRIAVAR("E5_ITEMC")  //Item contabil Credito
Local cClVlDb		:= CRIAVAR("E5_CLVLDB")  //Classe de Valor Debito
Local cClVlCr		:= CRIAVAR("E5_CLVLCR")  //Classe de Valor Credito
Local cCDeb			:= CRIAVAR("E5_DEBITO")	// Conta Contábil Debito
Local cCCrd			:= CRIAVAR("E5_CREDITO") // Conta Contábil Credito


If MsgYesNo('Deseja efetivar todos os lançamentos com naturezas válidas?',"Atenção")
	dbSelectArea("TRB")
	dbGoTop()
	While TRB->(!EOF()) 
		_cNatur := PadR(TRB->NUMMOV,10)
		DbSelectArea("SED")
		DbSetOrder(1)
		If DbSeek(xFilial("SED")+_cNatur)
			//criar sma inteligência do FA470Efet
		    //FA470GrvEf(cNaturEfet,cCCC,cCCD,cItemD,cItemC,cClVlDb,cClVlCr,cCCrd,cCDeb,cHistor)
             cHistor		:= TRB->DESCRMOV // Historico do movimento
		    u_EfetivaT(_cNatur,TRB->DEBCRED,cCCD,cItemD,cItemC,cClVlDb,cClVlCr,cCCrd,cCDeb,cHistor)
		    
		Endif
	    TRB->(DbSkip())
	EndDo    
Endif
RestArea(_aAreaX)
RETURN

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470GrvEf³ Autor ³ Mauricio Pequim Jr	  ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava Efetivacao                                  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470GrvEf()															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EfetivaT(cNaturEfet,cCCC,cCCD,cItemD,cItemC,cClVlDb,cClVlCr,cCCrd,cCDeb,cHistor)

Local cValorMov	:= ""
Local aAreaSE5	:= {}
Local lContab	:= .F.
Local nRecno	:= 0
Local aArea		:= {}
Local lRet		:= .T.
Local lAtuSldNat := FindFunction("AtuSldNat") .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma TRB->VALORMOV (em formato europeu) para formato Americano  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cValorMov := ConValor(TRB->VALORMOV,18)

//Valida se existe Banco Agencia e Conta
//Posiciono o Banco para a contabilizacao
If !Empty(TRB->AGEMOV)
	SA6->(DBSetOrder(1))
	If !SA6->(DbSeek(xFilial("SA6")+mv_par03+TRB->AGEMOV+TRB->CTAMOV)) 
		IF !MsgYesNo("A conta corrente da efetivação ("+mv_par03+"-"+TRB->AGEMOV+"-"+TRB->CTAMOV+") "+; //"A conta corrente da efetivação ("
						 "não existe no seu cadastro de bancos. Caso prossiga a conta será criada no cadastro de bancos. "+chr(10)+;  //"não existe no seu cadastro de bancos. Caso prossiga a conta será criada no cadastro de bancos. "
						 " Prosseguir?","Atenção") //" Prosseguir?"###"Atenção"
			lRet := .F.
		Endif		
	Endif 
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Movimentacao da efetivacao no SE5.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("NEWSE5")
_aArea  := GetArea()
If lRet
	DbSelectArea("SED") //só efetiva lançamento que existir natureza
	DbSetOrder(1)
	If DbSeek(xFilial("SED")+cNaturEfet)
		//SO VAI INCLUIR SE O MOVIMENTO BANCARIO NÃO EXISTIR
		//DbSelectArea("NEWSE5") //só efetiva lançamento que existir natureza
		//DbSetOrder(1)
		
		_cDatMov := DTOS(CTOD(TRB->DATAMOV))
		//SÓ EFETIVA MOVIMENTOS NÃO CONCILIADO
		If  TRB->OK == 2
			dbSelectArea("NEWSE5")
			RecLock("NEWSE5",.T.)
			NEWSE5->E5_FILIAL	:= xFilial("SE5")
			NEWSE5->E5_BANCO	:= mv_par03
			NEWSE5->E5_AGENCIA	:= TRB->AGEMOV
			NEWSE5->E5_CONTA	:= TRB->CTAMOV
			NEWSE5->E5_DATA		:= CTOD(TRB->DATAMOV,"ddmmyy")
			NEWSE5->E5_DTDISPO	:= CTOD(TRB->DATAMOV,"ddmmyy")
			NEWSE5->E5_VENCTO	:= CTOD(TRB->DATAMOV,"ddmmyy")
			NEWSE5->E5_DTDIGIT	:= CTOD(TRB->DATAMOV,"ddmmyy")
			NEWSE5->E5_HISTOR 	:= IIF(Empty(cHistor),TRB->DESCRMOV,cHistor)
			NEWSE5->E5_VALOR	:= Val(cValorMov)
			NEWSE5->E5_NATUREZ	:= cNaturEfet
			NEWSE5->E5_MOEDA  	:= IIF(TRB->TIPOMOV=="CHQ","C1","M1")
			NEWSE5->E5_RECPAG 	:= IIF(TRB->DEBCRED=="D","P","R")
			NEWSE5->E5_CCC		:= cCCC
			NEWSE5->E5_CCD		:= cCCD
			NEWSE5->E5_CREDITO	:= cCCrd
			NEWSE5->E5_DEBITO	:= cCDeb
			NEWSE5->E5_DEBITO	:= cCDeb
			NEWSE5->E5_RECONC   := "x"
			If CtbInUse()
				NEWSE5->E5_ITEMD	:= cItemD
				NEWSE5->E5_ITEMC	:= cItemC
				NEWSE5->E5_CLVLDB	:= cClVlDb
				NEWSE5->E5_CLVLCR	:= cClVlCr
			Endif
			nRecno:=NEWSE5->(Recno()) 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o movimento ‚ referente a um cheque e grava nro do cheque.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF TRB->TIPOMOV $ "CHQ"  
				NEWSE5->E5_NUMCHEQ	:= TRB->NUMMOV
			Endif
			//NEWSE5->(MsUnlock())
			MsUnlock()
	//	Else
	//		TRBSE5->(DBCLOSEAREA())
		
		Endif
		RestArea(_aArea)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza saldo bancario quando da efetivação de movimento             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  TRB->OK == 2
	
		AtuSalBco(mv_par03,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DATA,NEWSE5->E5_VALOR,iif(NEWSE5->E5_RECPAG == "R","+","-"))
		
		If lAtuSldNat
			If lAtuSldNat
				AtuSldNat(NEWSE5->E5_NATUREZ, NEWSE5->E5_DATA, "01", "3", NEWSE5->E5_RECPAG, NEWSE5->E5_VALOR, 0, "+",,FunName(),"NEWSE5", NEWSE5->(Recno()),0)
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava dados da Reconciliacao no TRB											  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("TRB")
		Replace TRB->RECSE5		With NEWSE5->(RECNO())
		Replace TRB->OK 		With 1
		Replace TRB->VALORSE5	With Transform(NEWSE5->E5_VALOR,"@E 999,999,999,999.99")
		Replace TRB->NUMSE5		With NEWSE5->E5_NUMCHEQ
		Replace TRB->AGESE5		With NEWSE5->E5_AGENCIA
		Replace TRB->CTASE5		With NEWSE5->E5_CONTA
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se gera lancamento na contabilidade.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If NEWSE5->E5_RECPAG =="R"
			cPadrao:= "563"
			If VerPadrao(cPadrao)
				lContab:=.T.
			EndIf
		Else 
			cPadrao:= "562"
			If VerPadrao(cPadrao)
				lContab:=.T.
			EndIf
		EndIf
	                
		If lContab .and. lGeraLanc
			//Posiciono o Banco para a contabilizacao
			SA6->(DBSetOrder(1))
			SA6->(MSSeek(xFilial("SA6")+mv_par03+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
			aAreaSE5:=SE5->(GetArea())
			aArea:=GetArea()
			DbSelectArea("SE5")
			DbGoTo(nRecno)
			If nHdlPrv <= 0 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa Lancamento Contabil                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nHdlPrv := HeadProva( cLote,;
					                      "FINA470" /*cPrograma*/,;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )
				
		   	LoteCont("FIN")
			Endif 
			If nHdlPrv > 0 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Prepara Lancamento Contabil                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil 
						//aAdd( aFlagCTB, {"E5_LA", "S", "NEWSE5", NEWSE5->( Recno() ), 0, 0, 0} )
						aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA470" /*cPrograma*/,;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )
			Endif
			SE5->(RestArea(aAreaSE5))
			RestArea(aArea)
			If !lUsaFlag
				RecLock("NEWSE5",.F.)      
				NEWSE5->E5_LA := "S"
				MsUnlock()
			Endif
		EndIf
	Endif	
Endif	
//dbSelectArea("NEWSE5")

Return .T.
