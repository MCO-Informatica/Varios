#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} PE01NFESEFAZ
Programa complemnetar do Fonte NFESEFAZ, para customizações
@author  Junior Carvalho
@since   01/05/2019
@version 3.0
/*/
//-------------------------------------------------------------------

USER FUNCTION PE01NFESEFAZ()

	Local aProd   		:= PARAMIXB[1]
	Local cMensCli		:= PARAMIXB[2]
	Local cMensFis		:= PARAMIXB[3]
	Local aDest   		:= PARAMIXB[4]
	Local aNota   		:= PARAMIXB[5]
	Local aInfoItem		:= PARAMIXB[6]
	Local aDupl	  		:= PARAMIXB[7]
	Local aTransp		:= PARAMIXB[8]
	Local aEntrega		:= PARAMIXB[9]
	Local aRetirada		:= PARAMIXB[10]
	Local aVeiculo		:= PARAMIXB[11]
	Local aReboque		:= PARAMIXB[12]
	Local aNfVincRur	:= PARAMIXB[13]
	Local aEspVol     	:= PARAMIXB[14]
	Local aNfVinc 		:= PARAMIXB[15]
	Local aDetPag 		:= PARAMIXB[16]
	Local aObsCotAux	:= PARAMIXB[17]
	Local aPedido     	:= PARAMIXB[18]
	Local aLote     	:= PARAMIXB[19]
	Local nScan 	 := 0
	Local aRetorno      := {}
	Local cDescProd		:= ""
	Local nX := 0
	Local nPrd := 0
	local nTamPrd := 0
	local aLoteOri      := {}
	local cRedespSC5       := ""
	local cRazaoSA4  := ""
	local cEndSA4    := ""
	local cBairroSA4 := ""
	local cCidadeSA4 := ""
	local cEstadoSA4 := ""
	local cCepSA4    := ""
	local cDDDSA4    := ""
	local nSizeTel   := 0
	local cTelSA4    := ""
	local cCnpjSA4   := ""
	local cIeSA4     := ""
	local cMsgTranSec := ""
	local aAreasRst   := {SA4->(getArea())}
	Private lFirst      :=.T.
	Private lSecond     :=.T.
	Private lThird      :=.T.
	private cCodCli     := ""
	private cInfAdic		:= ""

	cMSGDANF := Alltrim( UPPER(SuperGetMV("ES_MSGDANF", ," ") ))
	cMensCli := cMSGDANF+". "+cMensCli
	nTamPrd := Len(aProd)

	if aNota[4] == '0'

		For nX := 1 TO nTamPrd
			cProd := aProd[nX][2]
			IF(Rastro(cProd)) .and. !EMPTY(aLote[nX])
				cInfAdic := " Lote: " +Alltrim(aLote[nX,1]) + " Dt Validade: " + DTOC(aLote[nX,4]) + " Dt Fabricacao: " + DTOC(aLote[nX,3])
				aProd[nX,25] := Alltrim( cInfAdic+" "+aProd[nX, 25] )
			Endif
		Next nX

		IF !Empty(SF1->F1_OBSNFE)
			cMensCli += AllTrim( SF1->F1_OBSNFE )+"."
		Endif
		If !Empty(SF1->F1_II)
			cMensCli += " II R$ " + Transform(SF1->F1_II, "@e 99,999.99")
		Endif
		If !Empty(SF1->F1_VALIMP6)
			cMensCli += " | PIS R$ " + Transform(SF1->F1_VALIMP6, "@e 99,999.99")
		Endif
		If !Empty(SF1->F1_VALIMP5)
			cMensCli += " | COFINS R$ " + Transform(SF1->F1_VALIMP5, "@e 99,999.99")
		Endif

	ELSE

		dbSelectArea("SB5")
		SB5->(dbSetOrder(1))

		dbSelectArea("SA4")
		SA4->(dbSetOrder(1))

		aSize(aLote,0)

		aLote := array( nTamPrd)

		For nPrd := 1 to nTamPrd
			cPtax := ""
			cInfAdic	:= ""
			cCodPrd 	:= aProd[nPrd, 2]
			cDescProd	:= Alltrim(aProd[nPrd, 4])

			nQtdLim := 0        // Tratamento da Quantidade Limitada
			nMenor  := 999999   // Tratamento da Quantitada Limitada
			cNumitem := aInfoItem[nPrd][4]
			dbSelectArea("SD2")
			dbSetOrder(3)
			IF MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+cCodPrd+cNumitem)

				dbSelectArea("SC6")
				dbSetOrder(1)
				MsSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)

				IF SC6->C6_XMOEDA == 2
					cPtax	:= 	' - PTAX US$ '+ALLTRIM(Transform(SC6->C6_XTAXA, "@E 999.9999"))+" - "
				ELSEIF SC6->C6_XMOEDA == 4
					cPtax	:= 	' - PTAX EUR'+ALLTRIM(Transform(SC6->C6_XTAXA, "@E 999.9999"))+" - "
				ENDIF
				cMensCli +=  cPtax

				SC5->(dbSetOrder(1))
				SC5->(MsSeek(xFilial("SC5")+SC6->C6_NUM))

				if SC5->C5_XTRASEC == 'S' .and. empty(cRedespSC5)
					cRedespSC5 := SC5->C5_REDESP

					if SA4->(dbSeek(xFilial("SA4")+SC5->C5_REDESP))

						cRazaoSA4 := alltrim(SA4->A4_NOME)
						cEndSA4   := alltrim(SA4->A4_END)
						cBairroSA4:= alltrim(SA4->A4_BAIRRO)
						cCidadeSA4:= alltrim(SA4->A4_MUN)
						cEstadoSA4:= alltrim(SA4->A4_EST)
						cCepSA4   := transform(SA4->A4_CEP, "@R 99.999-99")
						cDDDSA4   := iif(!empty(SA4->A4_DDD), PADL(SA4->A4_DDD, 3, "0"), "")
						nSizeTel  := len(alltrim(SA4->A4_TEL))
						cTelSA4   := iif(!empty(SA4->A4_TEL), transform(SA4->A4_TEL, iif(nSizeTel==8, "@R 9999 9999", "@R 99999 9999")), "")
						cCnpjSA4  := transform(SA4->A4_CGC, "@R 99.999.999/9999-99")
						cIeSA4    := alltrim(SA4->A4_INSEST)

						cMsgTranSec:= " Transporte Seccionado  (CONSULTA 5749/2015 DE 14/09/15) Segundo trecho, que devera ser pago pelo cliente (FOB), "
						cMsgTranSec+= "sera efetuado pela :"+ cRazaoSA4+", " +cEndSA4+" "
						cMsgTranSec+= "Bairro "+cBairroSA4+", "+cCidadeSA4+" - "+cEstadoSA4+". CEP " +cCepSA4+ " –  "+iif(!empty(cTelSA4), "Tel "+"("+cDDDSA4+")" +cTelSA4, "")+" - CNPJ:" +cCnpjSA4+ " "
						cMsgTranSec+= "I.E: " +cIeSA4+ " horario de recebimento das 08hs as 17hs"
					endif
				endif

				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial("SB1")+cCodPrd )

				dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

				// IMCD INICIO -  Tratamento da QUANTIDADE LIMITADA solicitado por Igor e implementado por Daniel em 13/07/11
				cMSGONU := ""
				cCodUN := ALLTRIM(SB1->B1__CODONU)
				IF !EMPTY(cCodUN)

					If SB1->B1_QTDLIM > 0
						nQtdLim  += aProd[nPrd, 9] //(cAliasSD2)->D2_QUANT
						If SB1->B1_QTDLIM < nMenor
							nMenor := SB1->B1_QTDLIM
						Endif

						If nQtdLim < nMenor .AND. nQtdLim > 0
							//cMensCli += " QUANTIDADE LIMITADA"
							cMSGONU := " QUANT. LTDA "
						Endif
					Endif


					cMSGONU :=" UN "+cCodUN+" "+cMSGONU
			/*
			dbSelectArea("SB5")
			dbSetOrder(1)
					If MsSeek(xFilial("SB5")+cCodPrd )
			cDescProd +=" "+ALLTRIM(SB5->B5_CEME)
					Endif
			*/
				Endif
				IF  SA1->A1_EST <> 'EX'
					cEmb  	 := SB1->B1_EMB
					cUm		 := SB1->B1_UM
					cEspecie := Posicione("SZ2", 1, xFilial("SZ2") + cEmb, "Z2_DESC")
					cEspecie := Substr(cEspecie, 1, At(" ", cEspecie))
					nScan 	 := aScan(aEspVol, {|x| x[1] == cEspecie})

					If cEmb == "G01"
						nQ := 1
					ElseIf "CONTAINER" $ aProd[nPrd, 4]
						nQ := aProd[nPrd, 9] / SB1->B1_QB
					Else
						If aProd[nPrd, 9] > 1
							nQ := ( aProd[nPrd, 9] * IIF( cUm == "KG", SB1->B1_PESO, 1)  / SB1->B1_QB  )
						Else
							nQ := 1
						EndIf
					Endif

					nPesBrt := (aProd[nPrd, 9] * SB1->B1_PESBRU)
					aadd(aEspVol, { cEspecie, nQ , (aProd[nPrd, 9] * SB1->B1_PESO) , (aProd[nPrd, 9] * SB1->B1_PESBRU)})
					if nPesBrt > 0
						cDescProd += " - PESO BRUTO "+aLLTRIM(Transform(nPesBrt, "@E 999,999.99")) +" KG."
					endif
				Endif
				//IMCD INICIO 02/05/2015
				// RG do Container
				cRG := ""
				dbSelectArea("SZ9")
				dbSetOrder(2)
				If dbSeek(xFilial("SZ9") + SF2->F2_DOC + SF2->F2_SERIE + cCodPrd )
					do While !Eof() .and. SZ9->Z9_FILIAL == xFilial("SZ9") .and. SZ9->Z9_NFSAI == SF2->F2_DOC .and.;
							SZ9->Z9_SERSAI == SF2->F2_SERIE.and. SZ9->Z9_PRODUTO == cCodPrd
						cRG += AllTrim(SZ9->Z9_NUMSER) + " / "
						dbSkip()
					Enddo
				Endif
				cRg := AllTrim(cRg)
				If !Empty(cRG) .AND. ! ( " RG Container: " + cRG $ cMensCli )
					cMensCli += " RG Container: " + cRG
				Endif

				cLacre := ""
				dbSelectArea("ZX2")
				dbSetOrder(1)
				If MsSeek(xFilial("ZX2") + SF2->F2_DOC + SF2->F2_SERIE)
					cLacre := AllTrim(ZX2_NLACRE)
				Endif

				// Inclui mensagem sobre nota fiscal complementar de ICMS
				If SD2->D2_TES $ "537/548/558/678" .AND. lSecond
					nRecnoSF2 := SF2->(Recno())
					cMensCli += " Nota fiscal complementar ref. NF N. " + SD2->D2_NFORI + " serie " + SD2->D2_SERIORI + " de " + ;
						Dtoc(Posicione("SF2",1,SD2->(D2_FILIAL + D2_NFORI + D2_SERIORI),"F2_EMISSAO")) +;
						" Base de calculo: R$ " + AllTrim( Transform(SD2->D2_TOTAL / ( SD2->D2_PICM / 100 ) , "@E 999,999,999.99") )
					SF2->(dbGoto(nRecnoSF2))
					lSecond := .F.
				Endif
				// Inclui na mensagem da nota o lacre
				If !Empty(cLacre)
					If ! " | Lacre: " + AllTrim(cLacre) $ cMensCli
						cMensCli += " | Lacre: " + AllTrim(cLacre)
					Endif
				Endif

				// Inclui na mensagem da nota a formula existente no produto
				If !AllTrim(Formula(SB1->B1_FORMULA)) $ cMensCli .and. !(Empty(AllTrim(Formula(SB1->B1_FORMULA))))
					cMensCli += " | " + AllTrim(Formula(SB1->B1_FORMULA))
				EndIf

				If !EMPTY(SA1->A1_HORAENT)
					cMensCli += " " +ALLTRIM(SA1->A1_HORAENT)
				Endif

				// Inclui na mensagem a formula da TES
				// SE a formula for a da consignacao, busca os numeros das notas do campo novo do SC6: C6_XNFORIG
				If SF4->F4_FORMULA == "320"
					If lThird
						cMensAux := ""
						nRegSC6  := SC6->(Recno())
						dbSelectArea("SC6")
						dbSetOrder(1)
						MsSeek(xFilial("SC6") + SD2->D2_PEDIDO )
						do While !Eof() .and. SC6->C6_FILIAL == xFIlial("SC6") .and. SC6->C6_NUM == SD2->D2_PEDIDO
							If SC6->C6_TES $ "684" .and. !Empty(SC6->C6_XNFORIG)                                                     // TES informadas pela Nathalia
								cMensAux += SC6->C6_XNFORIG + " / "
							Endif
							SC6->(dbSkip())
						Enddo
						IF LEN(cMensAux) > 2
							cMensAux := Substr(cMensAux,1,Len(cMensAux)-2)
							cMensCli += "FATURAMENTO DE PRODUTO ENVIADO A TITULO DE CONSIGNACAO CONFORME NF(s): " + cMensAux + " ONDE OS IMPOSTOS FORAM SATISFEITOS."
							lThird := .F.
						Endif
						SC6->(dbGoto(nRegSC6))
					Endif
				Else

				Endif

				If !Empty(SC5->C5_CENT) .and. SC5->C5_CENT + SC5->C5_LENT <> SC5->C5_CLIENTE + SC5->C5_LOJACLI .and. lFirst
					SA1->(dbSetOrder(1))
					SA1->(dbSeek(xFilial("SA1") + SC5->C5_CENT + SC5->C5_LENT))
					cMensCli += " | " + IIF(SD2->D2_TES $ "517/518","Mercadoria remetida por conta e ordem de ","Local Entrega: ") + AllTrim(SA1->A1_NOME) + " CNPJ: " +;
						Transform(SA1->A1_CGC,"@R 99.999.999/9999-99") + "I.E.:" + AllTrim(SA1->A1_INSCR) + "Endereço: " + AllTrim(SA1->A1_END) + " " + AllTrim(SA1->A1_BAIRRO) +;
						" " + AllTrim(SA1->A1_MUN) + " " + AllTrim(SA1->A1_EST) + " " + AllTrim(SA1->A1_CEP)
					//					If (cAliasSD2)->D2_TES $ "517/518"
					//						nRecnoSF2 := SF2->(Recno())
					//						cMensCli += " NF Venda no. " + (cAliasSD2)->D2_NFORI + " serie " + (cAliasSD2)->D2_SERIORI + " emitida em " + Dtoc(Posicione("SF2",1,(cAliasSD2)->(D2_FILIAL + D2_NFORI + D2_SERIORI),"F2_EMISSAO"))
					//						SF2->(dbGoto(nRecnoSF2))
					//					Endif
					lFirst := .F.
				Endif

				cDescCien 	:= AllTrim(Posicione("SB5",1,xFilial("SB5") + cCodPrd,"B5_CEME"))

				cCodCli		:= AllTrim(Posicione("SA7",1,xFilial("SA7") + SD2->D2_CLIENTE + SD2->D2_LOJA + cCodPrd,"A7_CODCLI"))

				_cDesPro    := AllTrim(SB1->B1_DESC)

				_cNacion	:= AllTrim(SB1->B1_NACION)

				// retirado em 09.02.16 por sandra nishida - eata com informacao duplicada na tag InfAdProd
				//If !Empty(cCodCli)
				//	If !" Cod. Produto no Cliente = " + AllTrim(cCodCli) $ cMensCli
				//		cMensCli += " Cod. Produto no Cliente = " + AllTrim(cCodCli)
				//	Endif
				//Endif

				//If "GRANEL" $ UPPER(_cDesPro) .AND. (cAliasSD2)->D2_DOC <> "000041733"
				IF _cNacion == '3'
					aRat := XSEPSLD( SD2->D2_FILIAL, cCodPrd, cNumitem, SD2->D2_LOCAL, SD2->D2_DOC, SD2->D2_SERIE )
				Else
					aRat := {}
				EndIf

				If len(aRat) > 0
					If SD2->D2_QUANT <> aRat[1,2]
						aRat[1,2] := SD2->D2_QUANT
					Endif
				Endif

				nArat 	:= 0
				nSd2  	:= SD2->D2_QUANT

				//--------------------------------------------------
				//Realiza a verificação do lote a granel se existir
				//--------------------------------------------------
				aLoteOri := staticcall(M460FIM, procAnalise,,.T.)

				if empty(aLoteOri)
					dFabric	:= Posicione("SB8" , 3 , xFilial("SB8") + cCodPrd + SD2->D2_LOCAL + SD2->D2_LOTECTL , "B8_DFABRIC")
					cFabric := Dtos(dFabric)
					cFabric := Substr(cFabric,1,4) + "-" + Substr(cFabric,5,2) + "-" + Substr(cFabric,7,2)
					cValid  := DTOS(SD2->D2_DTVALID)
					cValid  := Substr(cValid,1,4) + "-" + Substr(cValid,5,2) + "-" + Substr(cValid,7,2)
				else
					dFabric := aLoteOri[1]
					cFabric := Dtos(aLoteOri[1])
					cFabric := Substr(cFabric,1,4) + "-" + Substr(cFabric,5,2) + "-" + Substr(cFabric,7,2)
					cValid  := DTOS(aLoteOri[2])
					cValid  := Substr(cValid,1,4) + "-" + Substr(cValid,5,2) + "-" + Substr(cValid,7,2)
				endif

				if empty(SD2->D2_DFABRIC) .AND. !EMPTY(dFabric)
					reclock("SD2",.F.)
					SD2->D2_DFABRIC := dFabric
					SD2->(msUnlock())
				endif
				//aSize(aLoteOri,0)

				// ESPECIFICO IMCD --- INSERIDO CONDICAO DE IMPRESSAO DE LOTE
				//If lCpoMsgLT .And. lCpoLoteFor .And. SF4->F4_MSGLT $ "1"
				//	cNumLotForn := Alltrim(Posicione("SB8",2,xFilial("SB8")+(cAliasSD2)->D2_NUMLOTE+(cAliasSD2)->D2_LOTECTL+cCodProd,"B8_LOTEFOR"))
				IF !Empty(SD2->D2_LOTECTL)
					cNumLotForn := " Lote: " + AllTrim(SD2->D2_LOTECTL)
					cNumLotForn += Iif(Rastro(SD2->D2_COD,"L")," Dt Validade: " + cValid + " Dt Fabricacao: " + cFabric + " ","")
					cNumLotForn += IIF(Empty(cCodCli),"","Cod Cliente: " + cCodCli)

					if !Empty(cNumLotForn)
						cInfAdic := cNumLotForn //aprod 25
						aLote[nPrd] := { Alltrim(SD2->D2_LOTECTL) ,nSd2  ,cFabric,cValid,""}
					Endif

				Endif

				If !EMPTY(SC6->C6_NUMPCOM)
					cInfAdic += " Pedido de compras do cliente: " + Alltrim(SC6->C6_NUMPCOM) +'-'+ Alltrim(SC6->C6_ITEMPC) +'.'
				ENDIF

			ENDIF

			aProd[nPrd, 4] := cDescProd+" "+cMSGONU
			aProd[nPrd,25] := Alltrim( cInfAdic+" "+aProd[nPrd, 25] )

			//-----------------------------------------
			//Tag específica do cliente para informar o
			//código de produto dele
			//-----------------------------------------
			if !empty(cCodCli) .and. !empty(SA1->A1_XTAGAD ) .and. !(SC5->C5_TIPO $ "B/D")
				aProd[nPrd,25] := &(SA1->A1_XTAGAD)
			endif


			If  SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
				if !empty(SB5->B5_XOBSNF) .and. !(cMensCli $ SB5->B5_XOBSNF)
					cMensCli += " "+alltrim(SB5->B5_XOBSNF)+" "
				endif
			endif

		Next nPrd

		If !Empty(aPedido[2])
			If !" No. Pedido Cliente = " + AllTrim(aPedido[2]) $ cMensCli
				cMensCli += " No. Pedido Cliente = " + AllTrim(aPedido[2])
			Endif
		Endif

		if !empty(cMsgTranSec)
			cMensCli += " "+cMsgTranSec
		endif
	ENDIF
	aadd(aRetorno,aProd)
	aadd(aRetorno,FwCutOff(cMensCli, .T.) )
	aadd(aRetorno,FwCutOff(cMensFis, .T.) )
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,aDetPag)
	aadd(aRetorno,aObsCotAux)
	aadd(aRetorno,aLote)

	aEval(aAreasRst, {|aArea|restArea(aArea)})
	aSize(aAreasRst,0)

Return aRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³NFESEFAZ  ºAutor  ³     Ivan Tore      º Data ³  04/13/10   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Rateio de produtos que utilizam codigo generico            º±±
±±º          ³                                                            º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XSEPSLD( cCodFil, cCodProd, cNumitem, cLocal, cDoc, cSerie )

	Local aAreaAtu := GetArea()
	Local aAreaSB1 := SB1->( GetArea() )
	Local cQuery   := ""
	Local aSaldo   := {}
	Local aRetFun  := {}
	Local nPos     := 0
	Local nAux     := 0
	Local lExit	   := .F.

	SB1->( dbSetOrder( 1 ) )

	cQuery += "SELECT 'SD1' TIPO, D1_SERIE SERIE, D1_DOC DOC, D1_NUMSEQ NUMSEQ, D1_COD COD, D1_QUANT QUANT, D1_CLASFIS CLASFIS, ' ' CODORI, D1_LOTECTL LOTECTL "
	cQuery += "  FROM " + RetSQLName( "SD1" )
	cQuery += " WHERE D1_FILIAL  = '" + cCodFil + "' "
	cQuery += "   AND D1_COD     = '" + cCodProd + "' "
//cQuery += "   AND D1_LOCAL   = '" + cLocal + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += "SELECT D3_CF TIPO, ' ' SERIE, D3_DOC DOC, D3_NUMSEQ NUMSEQ, D3_COD COD, D3_QUANT QUANT, D3_CLASFIS CLASFIS, ' ' CODORI, D3_LOTECTL LOTECTL "
	cQuery += "  FROM " + RetSQLName( "SD3" )
	cQuery += " WHERE D3_FILIAL  = '" + cCodFil + "' "
	cQuery += "   AND D3_COD     = '" + cCodProd + "' "
//cQuery += "   AND D3_LOCAL   = '" + cLocal + "' "
	cQuery += "   AND SUBSTR( D3_CF, 2, 2 ) != 'E4' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += "SELECT A.D3_CF TIPO, '   ' SERIE, A.D3_DOC DOC, A.D3_NUMSEQ NUMSEQ, A.D3_COD COD, A.D3_QUANT QUANT, A.D3_CLASFIS CLASFIS, B.D3_COD CODORI, A.D3_LOTECTL LOTECTL "
	cQuery += "  FROM " + RetSQLName( "SD3" ) + " A "
	cQuery += "  JOIN " + RetSQLName( "SD3" ) + " B ON B.D3_FILIAL = A.D3_FILIAL AND B.D3_NUMSEQ = A.D3_NUMSEQ AND B.D3_COD != A.D3_COD AND B.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE A.D3_FILIAL  = '" + cCodFil + "' "
	cQuery += "   AND A.D3_COD     = '" + cCodProd + "' "
//cQuery += "   AND A.D3_LOCAL   = '" + cLocal + "' "
	cQuery += "   AND SUBSTR( A.D3_CF, 2, 2 ) = 'E4' "
	cQuery += "   AND A.D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += "SELECT 'SD2' TIPO, D2_SERIE SERIE, D2_DOC DOC, D2_NUMSEQ NUMSEQ, D2_COD COD, D2_QUANT QUANT, D2_CLASFIS CLASFIS, ' ' CODORI, D2_LOTECTL LOTECTL "
	cQuery += "  FROM " + RetSQLName( "SD2" )
	cQuery += " WHERE D2_FILIAL  = '" + cCodFil + "' "
	cQuery += "   AND D2_COD     = '" + cCodProd + "' "
	cQuery += "   AND D2_ITEM   = '" + cNumitem + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY NUMSEQ "
	If Select( "TMP_SLD" ) > 0
		TMP_SLD->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SLD", .T., .F. )
	TMP_SLD->( dbGoTop() )
	While TMP_SLD->( !Eof() ) .and. !lExit

		If Left( TMP_SLD->TIPO, 1 ) = "D" .OR. TMP_SLD->TIPO = "SD1"
			cOrigem := ""
			If SubStr( TMP_SLD->TIPO, 2, 2 ) != "E4"
				If Substr ( TMP_SLD->TIPO, 2, 2 ) == "E6" .OR. TMP_SLD->TIPO = "SD1"
					cOrigem := Substr( TMP_SLD->CLASFIS, 1, 1 )
				Else
					SB1->( dbSeek( xFilial( "SB1" ) + TMP_SLD->COD ) )
					cOrigem := SB1->B1_ORIGEM
				Endif
			Else
				SB1->( dbSeek( xFilial( "SB1" ) + TMP_SLD->CODORI ) )
				cOrigem := SB1->B1_ORIGEM
			Endif

			aAdd( aSaldo, { cOrigem, TMP_SLD->QUANT } )

		Endif

		If Left( TMP_SLD->TIPO, 1 ) = "R" .OR. TMP_SLD->TIPO = "SD2"

			nAux := TMP_SLD->QUANT

			While nAux > 0

				nPos := aScan( aSaldo, { |x| x[2] > 0 } )
				If nPos > 0
					If aSaldo[nPos][2] >= nAux
						aSaldo[nPos][2] := aSaldo[nPos][2] - nAux

						If TMP_SLD->DOC == cDoc .and. TMP_SLD->SERIE == cSerie
							nPosRetFun := aScan (aRetFun, { |x| x[1] == aSaldo[nPos,1] } )
							If nPosRetFun == 0
								aAdd( aRetFun, { aSaldo[nPos][1], nAux } )
							Else
								aRetFun[nPosRetFun,2] += nAux
							Endif
							lExit := .T.
							Exit
						Else
							nAux := 0
						Endif
					Else
						If TMP_SLD->DOC == cDoc .and. TMP_SLD->SERIE == cSerie
							nPosRetFun := aScan (aRetFun, { |x| x[1] == aSaldo[nPos,1] } )
							If nPosRetFun == 0
								aAdd( aRetFun, { aSaldo[nPos][1], aSaldo[nPos][2] } )
							Else
								aRetFun[nPosRetFun,2] += aSaldo[nPos][2]
							Endif
						Endif
						nAux := nAux - aSaldo[nPos][2]
						aSaldo[nPos][2] := 0
					Endif
				Else
					nAux := 0
				Endif
			End

		Endif

		TMP_SLD->( dbSkip() )
	End

	RestArea( aAreaSB1 )
	RestArea( aAreaAtu )

Return aRetFun




