#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MT410INC ³ Autor ³ Marcio Almenara       ³ Data ³ 12/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Transfere saldo do produto original para o produto alterna-³±±
±±³          ³ tivo, mo momento da inclusao do Pedido de Vendas           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ponto de entrada especifico MT410INC                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION TW1F003(lEstorna)
	Local cPrdaux := ''
	Local nQtdLib := 0
	Local nQtdNec := 0
	Local lTroca  := .T.

	SetPrvt("LRETORNO,CTIPO,NCONT")
	SetPrvt("NPOSLOTE,NPOSSUBLOTE,NPOSPROD,NPOSTES,NPOSALM,NPOSLOC,NPOSQLIB,nPosQLib2")
	SetPrvt("NPOSSUM,NPOSTUM,NPOSIT,CL,NQTDLIB,CTES")
	SetPrvt("CLOTE,CSUBLOTE,CPROD,CLOCAL,CALM,CITEM,NQTDQTS")
	SetPrvt("NQTDQTT,CPEDIDO,CTIPOPROD,ADADOS,APAPRET,NSALDOQTS")
	SetPrvt("NSALDOQTT,NSALDOQTD,")

	xArea := GetArea()

	Default lEstorna := .F.

	lRetorno := .T.
	cTipo := If(INCLUI,M->C5_TIPO,SC5->C5_TIPO)

	If cTipo <> "C"
		For nCont := 1 to Len(aHeader)

			Do Case
			Case AllTrim(aHeader[nCont][2]) == "C6_LOTECTL"
				nPosLote := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_NUMLOTE"
				nPosSubLote := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_PRODUTO"
				nPosProd := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_TES"
				nPosTES  := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_LOCAL"
				nPosAlm  := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_LOCALIZ"
				nPosLoc  := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_QTDLIB"
				nPosQLib  := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_QTDLIB2"
				nPosQLib2  := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_QTSEGUM"
				nPosSUM   := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_QTTERUM"
				nPosTUM   := nCont
			Case AllTrim(aHeader[nCont][2]) == "C6_ITEM"
				nPosIT    := nCont
			EndCase
		Next

		For cL := 1 To Len(aCols)
			nQtdLbib   := aCols[cL][nPosQLib]

			If nQtdLbib == 0
				Loop
			EndIf

			cTES      := aCols[cL][nPosTES]

			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+cTes))

			If SF4->F4_ESTOQUE <> "S"
				Loop
			EndIf

			cLote     := aCols[cL][nPosLote]
			cSubLote  := aCols[cL][nPosSubLote]
			cProd     := aCols[cL][nPosProd]
			cLocal    := aCols[cL][nPosAlm]
			cAlm      := aCols[cL][nPosAlm]
			cItem     := aCols[cL][nPosIT]
			lRetorno  := .T.

			cPrdaux := TWPTROCA(cProd,@lTroca)

			If !Empty(cPrdaux) .And. lTroca
				xRESERVA := POSICIONE("SB2",1,xFILIAL("SB2")+cProd+cLocal,"B2_RESERVA")
				nSaldo := SldAtuEst(cProd,cLocal,999999999999,nil,nil,nil,nil,nil ,nil,nil,nil,nil,nil)
				nSaldo := If(nSaldo < 0,0,nSaldo)

				nQtdNec := ABS(nSaldo - nQtdLbib)

				If nQtdNec > 0

					xRESERVA1 := SB2->B2_RESERVA
					nSaldo1 := SldAtuEst(cPrdaux,cLocal,999999999999,nil,nil,nil,nil,nil ,nil,nil,nil,nil,nil)
					nSaldo1 := If(nSaldo1 < 0,0,nSaldo1)

					If nQtdNec > nSaldo1
						nQtdNec := nSaldo1
					End

					If nSaldo1 > 0
						xOKMOV := .T.
						xSALDOSEST:={}
						
						If xRETSALDO(cPrdaux,cLocal,nQtdNec)   //almenara   //se nao houver saldo total nao transfere

						
							For xA:= 1 TO LEN(xSALDOSEST)
						   		If xSALDOSEST[xA,3] > 0   //almenara
									cCodOrig    := xSALDOSEST[xA,1]
									cLocOrig    := xSALDOSEST[xA,2]
									nQuant260   := xSALDOSEST[xA,3]
									cDocto      := SC5->C5_NUM
									dEmis260    := dDataBase
									nQuant260D  := (aCols[cL][nPosQLib2]/aCols[cL][nPosQLib]) * xSALDOSEST[xA,3]
									cNumLote    := xSALDOSEST[xA,6]
									cLoteDigi   := xSALDOSEST[xA,5]
									dDtValid    := xSALDOSEST[xA,7]
									cNumSerie   := ""
									cLoclzOrig  := xSALDOSEST[xA,4]
									cCodDest    := cProd
									cLocDest    := cLocal
									cLocLzDest  := xSALDOSEST[xA,4]
									cServico    := ""
									nPotencia   := 0
									cLoteDigiD  := xSALDOSEST[xA,5]
									dDtVldDest  := xSALDOSEST[xA,7]
									cCAT83O     := ""
									cCAT83D     := ""
									cCusmed     := GetMv("MV_CUSMED")
									aRegSD3     := {}

									xOK:= a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,.F.,Nil,Nil,"MATA260",Nil,cServico,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,nPotencia,cLoteDigiD,dDtVldDest,cCAT83O,cCAT83D)
									xOKMOV := IF(xOKMOV,xOK,xOKMOV)    && SE FICAR COM T  SIGNIFICA QUE TODAS AS TRANSFERENCIAS FORAM BEM SUCEDIDADS E LIBERA O PEDIDO
						  		Endif
							Next
                    	Endif
					EndIf
				Endif
			EndIF
		Next cL
	EndIf

	RestArea(xArea)

	Return lRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ XRETSALDO³ Autor ³ Marcio Almenara       ³ Data ³ 12/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna array dos saldos, de um produto, por Localizacao + ³±±
±±³          ³ Lote, ou so Lote ou so o Saldo                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Parte do Ponto de entrada especifico MT410INC              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION xRETSALDO(xCODPROD,xCODLOC,xSALDOL)


	&&PRODUTO COM LOCALIZACAO
	IF Localiza(xCODPROD)
		Dbselectarea("SBF")
		DbsetOrder(2)
		If Dbseek(xFILIAL("SBF")+xCODPROD+xCODLOC)

			While !eof() .and. xCODPROD+xCODLOC == SBF->BF_PRODUTO + SBF->BF_LOCAL  .AND. xSALDOL > 0   //ALMENARA
				If (SBF->BF_QUANT-SBF->BF_EMPENHO) <= 0    //ALMENARA
					SBF->(Dbskip())
					Loop
				EndIf
				xQTDLOCAL := IIF((SBF->BF_QUANT-SBF->BF_EMPENHO) >=xSALDOL,xSALDOL,(SBF->BF_QUANT-SBF->BF_EMPENHO))   //ALMENARA
				AADD(xSALDOSEST,{SBF->BF_PRODUTO,SBF->BF_LOCAL,xQTDLOCAL,SBF->BF_LOCALIZ,SBF->BF_LOTECTL,SBF->BF_NUMLOTE,;
					IIF(Rastro(xCODPROD),POSICIONE("SB8",3,xFILIAL("SB8")+xCODPROD+xCODLOC+SBF->BF_LOTECTL+SBF->BF_NUMLOTE,"B8_DTVALID"),CTOD("  /  /  "))})
				xSALDOL := xSALDOL - xQTDLOCAL
				Dbselectarea("SBF")
				Dbskip()
			Enddo
		Endif
	Endif

	&&PRODUTO SEM LOCALIZACAO E COM RASTRO
	If !Localiza(xCODPROD) .and. Rastro(xCODPROD)
		Dbselectarea("SB8")
		DbsetOrder(1)
		If Dbseek(xFILIAL("SB8")+xCODPROD+xCODLOC)

			While !eof() .and. xCODPROD+xCODLOC == SB8->B8_PRODUTO + SB8->B8_LOCAL .AND. xSALDOL > 0  //ALMENARA
				If (SB8->B8_SALDO-SB8->B8_EMPENHO) <= 0   //ALMENARA
					SB8->(Dbskip())
					Loop
				EndIf
				xQTDLOCAL := IIF((SB8->B8_SALDO-SB8->B8_EMPENHO) >=xSALDOL,xSALDOL,(SB8->B8_SALDO-SB8->B8_EMPENHO))    //ALMENARA
				AADD(xSALDOSEST,{SB8->B8_PRODUTO,SB8->B8_LOCAL,xQTDLOCAL,"",SB8->B8_LOTECTL,SB8->B8_NUMLOTE,SB8->B8_DTVALID})
				xSALDOL := xSALDOL - xQTDLOCAL
				Dbselectarea("SB8")
				Dbskip()
			Enddo
		Endif
	Endif

	&&PRODUTO SEM LOCALIZACAO E SEM RASTRO
	If !Localiza(xCODPROD) .and. !Rastro(xCODPROD)
        xQTDLOCAL := POSICIONE("SB2",1,xFILIAL("SB2")+xDODPROD+xCODLOC,"B2_QATU")  //ALMENARA
        xQTDLOCAL := xQTDLOCAL - POSICIONE("SB2",1,xFILIAL("SB2")+xDODPROD+xCODLOC,"B2_RESERVA")  //ALMENARA
        xQTDLOCAL := IF(xQTDLOCAL >= xSALDOL,xSALDOL,xQTDLOCAL) //ALMENARA
        
         AADD(xSALDOSEST,{xCODPROD,xCODLOC,xQTDLOCAL,"","","",CTOD("  /  /  ")})  //ALMENARA
	
	     xSALDOL := xSALDOL - xQTDLOCAL
	Endif

    
	Return( IIf(xSALDOL > 0 ,.F.,.T.))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TWPTROCA ³ Autor ³ Joao Zabotto          ³ Data ³ 12/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Codigo do Produto Original, a partir do codigo   ³±±
±±³          ³ do produto alternativo                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ponto de entrada especifico MT410INC                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TWPTROCA(cProduto,lTroca)
	Local cPrdTransf := ''
	Local cSerie     := ''
	Local lOnibus    := .F.

	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial('SA1') + SC5->(C5_CLIENTE + C5_LOJACLI)))
		If SA1->A1_ZZRAATV = '2'
			SB1->(DbSetOrder(1))
			If SB1->(DbSeek(xFilial('SB1') + cProduto))
				cPrdTransf:= SB1->B1_ZZPRDRE    //ALMENARA  B1_ZZPRDREF
			EndIF
		Else
			SB1->(dbOrderNickName('PRDREFEREN'))
			If SB1->(DbSeek(xFilial('SB1') + cProduto))
				If SUBSTR(SB1->B1_ITEMCC,1,1) != 'O'
					cPrdTransf:= SB1->B1_COD
				EndIF
			EndIf
		EndIf
	EndIf

	Return cPrdTransf




