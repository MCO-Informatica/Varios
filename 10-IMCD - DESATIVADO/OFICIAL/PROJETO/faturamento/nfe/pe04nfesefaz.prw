#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} PE04NFESEFAZ
Programa complemnetar do Fonte NFESEFAZ, para customizações
@author  Junior Carvalho
@since   01/05/2019
@version 3.0
/*/
//-------------------------------------------------------------------

USER FUNCTION PE04NFESEFAZ()

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
	private cInfAdic	:= ""
	PRIVATE aEspVolPE  	:= PARAMIXB[14]

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
		
				// Inclui na mensagem da nota a formula existente no produto
				If !AllTrim(Formula(SB1->B1_FORMULA)) $ cMensCli .and. !(Empty(AllTrim(Formula(SB1->B1_FORMULA))))
					cMensCli += " | " + AllTrim(Formula(SB1->B1_FORMULA))
				EndIf

				If !EMPTY(SA1->A1_HORAENT)
					cMensCli += " " +ALLTRIM(SA1->A1_HORAENT)
				Endif

				IF ( lFirst )
					cNFePE := SF2->(GetArea())
					U_M512AGRV()
					aEspVolPE :={}
					cScan := "1"
					While ( !Empty(cScan) )
						cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
						If !Empty(cEspecie)
							nScan := aScan(aEspVolPE,{|x| x[1] == cEspecie})
							If ( nScan==0 .AND.cScan == "1" )
								aadd(aEspVolPE,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
							ElseIf ( nScan<>0 .AND.cScan == "1" )
								aEspVolPE[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
							Else
								aadd(aEspVolPE,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , 0 , 0})
							EndIf
						EndIf
						cScan := Soma1(cScan,1)
						If ( FieldPos("F2_ESPECI"+cScan) == 0 )
							cScan := ""
						EndIf
					EndDo
					RestArea(cNFePE)

				Endif

				If !Empty(SC5->C5_CENT) .and. SC5->C5_CENT + SC5->C5_LENT <> SC5->C5_CLIENTE + SC5->C5_LOJACLI .and. lFirst
					SA1->(dbSetOrder(1))
					SA1->(dbSeek(xFilial("SA1") + SC5->C5_CENT + SC5->C5_LENT))
					cMensCli += " | " + IIF(SD2->D2_TES $ "517/518","Mercadoria remetida por conta e ordem de ","Local Entrega: ") + AllTrim(SA1->A1_NOME) + " CNPJ: " +;
						Transform(SA1->A1_CGC,"@R 99.999.999/9999-99") + "I.E.:" + AllTrim(SA1->A1_INSCR) + "Endereço: " + AllTrim(SA1->A1_END) + " " + AllTrim(SA1->A1_BAIRRO) +;
						" " + AllTrim(SA1->A1_MUN) + " " + AllTrim(SA1->A1_EST) + " " + AllTrim(SA1->A1_CEP)

				Endif

				lFirst := .F.

				cDescCien 	:= AllTrim(Posicione("SB5",1,xFilial("SB5") + cCodPrd,"B5_CEME"))

				cCodCli		:= AllTrim(Posicione("SA7",1,xFilial("SA7") + SD2->D2_CLIENTE + SD2->D2_LOJA + cCodPrd,"A7_CODCLI"))

				_cDesPro    := AllTrim(SB1->B1_DESC)

				_cDesPro    := AllTrim(SB1->B1_DESC)

				dbSelectArea("SB8")
				dbSetOrder(3)
				DbSeek(xFilial("SB8") + cCodPrd + SD2->D2_LOCAL + SD2->D2_LOTECTL + space(TamSX3("B8_NUMLOTE")[1]) +DTOS(SD2->D2_DTVALID) )

				nSd2  	:= SD2->D2_QUANT
				dFabric	:= SB8->B8_DFABRIC
				cFabric := DTOC(dFabric)
				cValid  := DTOC(SB8->B8_DTVALID)

				if empty(SD2->D2_DFABRIC) .AND. !EMPTY(dFabric)
					reclock("SD2",.F.)
					SD2->D2_DFABRIC := dFabric
					SD2->(msUnlock())
				endif

				IF !Empty(SD2->D2_LOTECTL)
					cNumLotForn := " Lote: " + AllTrim(SD2->D2_LOTECTL)
					cNumLotForn += Iif(Rastro(SD2->D2_COD,"L")," Dt Validade: " + cValid + " Dt Fabricacao: " + cFabric + " ","")

					if !Empty(cNumLotForn)
						cInfAdic := cNumLotForn //aprod 25
						aLote[nPrd] := { Alltrim(SD2->D2_LOTECTL) ,nSd2 ,ctod(cFabric),ctod(cValid),""}
					Endif

				Endif

				cInfAdic += IIF(Empty(cCodCli),"","Cod Cliente: " + cCodCli)

				If !EMPTY(SC6->C6_NUMPCOM)
					cInfAdic += " Pedido de compras do cliente: " + Alltrim(SC6->C6_NUMPCOM) +'-'+ Alltrim(SC6->C6_ITEMPC) +'.'
				ENDIF

			ENDIF

			aProd[nPrd, 4] := cDescProd+" "+cMSGONU
			aProd[nPrd,25] := Alltrim( cInfAdic+" "+aProd[nPrd, 25] )

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
	aadd(aRetorno,aEspVolPE)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,aDetPag)
	aadd(aRetorno,aObsCotAux)
	aadd(aRetorno,aLote)

	aEval(aAreasRst, {|aArea|restArea(aArea)})
	aSize(aAreasRst,0)

Return aRetorno
