#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} PE02NFESEFAZ
Programa complemnetar do Fonte NFESEFAZ, para customizações
@author  Junior Carvalho
@since   01/05/2019
@version 3.0
/*/
//-------------------------------------------------------------------

USER FUNCTION PE02NFESEFAZ()

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
	Local aRetorno      := {}
	Local nTamPrd 		:= 0
	Local nX			:= 0
	Local nPrd			:= 0
	Local cDescProd		:= ""
	Local cInfAdic		:= ""
	local aAreasRst   := {SA4->(getArea())}
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

	Private lFirst      :=.T.
	Private lSecond     :=.T.
	Private lThird      :=.T.
	Private aProd   	:= PARAMIXB[1]

	private aICMS      := paramixb[19]
	private aICMSST    := paramixb[20]
	private aIPI       := paramixb[21]
	private aPIS       := paramixb[22]
	private aPISST     := paramixb[23]
	private aCOFINS    := paramixb[24]
	private aCOFINSST  := paramixb[25]
	private aISSQN     := paramixb[26]
	private aCST       := paramixb[27]

	Private  aMed := paramixb[28]
	Private  aArma := paramixb[29]
	Private  aveicProd := paramixb[30]
	Private  aDI := paramixb[31]
	Private  aAdi := paramixb[32]
	Private  aExp := paramixb[33]
	Private  aPisAlqZ := paramixb[34]
	Private  aCofAlqZ := paramixb[35]
	Private  aAnfI := paramixb[36]
	Private  aComb := paramixb[37]
	Private  aCsosn := paramixb[38]
	Private  aPedCom := paramixb[39]
	Private  aICMSZFM := paramixb[40]
	Private  aFCI := paramixb[41]
	Private  aAgrPis := paramixb[42]
	Private  aAgrCofins := paramixb[43]
	Private  aICMUFDest := paramixb[44]
	Private  aIPIDevol := paramixb[45]
	Private  aItemVinc := paramixb[46]
	Private  aLote := paramixb[47]

	if aNota[4] == '0'

		nTamPrd := len(aProd)

		For nX:= 1 TO nTamPrd
			cProd := aProd[nX][2]
			IF(Rastro(cProd)) .and. !EMPTY(aLote[nX])
				cInfAdic := " Lote: " +Alltrim(aLote[nX,1]) + " Dt Validade: " + DTOC(aLote[nX,4]) + " Dt Fabricacao: " + DTOC(aLote[nX,3])
				aProd[nX,25] := Alltrim( cInfAdic+" "+aProd[nX, 25] )
			Endif
		Next nX

		cMensCli += " " + F1OBSNFE()

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
		dbSelectArea("SA4")
		SA4->(dbSetOrder(1))

		cMSGDANF := Alltrim( UPPER(SuperGetMV("ES_MSGDANF", ," ") ))
		cMensCli := cMSGDANF+". "+cMensCli

		aProd:= AGLPRD(aProd,aInfoItem)

		aSize(aLote,0)

		nTamPrd := LEN(aProd)

		aLote := array( nTamPrd)

		For nPrd := 1 to nTamPrd
			cPtax := ""
			cInfAdic	:= ""
			cCodPrd 	:= aProd[nPrd, 2]

			//--------------------------------------
			//Descrição do produto campo específico
			//--------------------------------------
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+cCodPrd )

			if !empty(SB1->B1_ESPECIF)
				aProd[nPrd, 4] := SB1->B1_ESPECIF
			endif

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

						cMsgTranSec:= "Transporte Seccionado  (CONSULTA 5749/2015 DE 14/09/15) Segundo trecho, que devera ser pago pelo cliente (FOB), "
						cMsgTranSec+= "sera efetuado pela :"+ cRazaoSA4+", " +cEndSA4+" "
						cMsgTranSec+= "Bairro "+cBairroSA4+", "+cCidadeSA4+" - "+cEstadoSA4+". CEP " +cCepSA4+ " –  "+iif(!empty(cTelSA4), "Tel "+"("+cDDDSA4+")" +cTelSA4, "")+" - CNPJ:" +cCnpjSA4+ " "
						cMsgTranSec+= "I.E: " +cIeSA4+ " horario de recebimento das 08hs as 17hs. "
					endif
				endif

				dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

				cMSGONU := ""
				cCodUN := ALLTRIM(SB1->B1__CODONU)
				IF !EMPTY(cCodUN)
					cMSGONU :=" UN "+cCodUN
				Endif

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
					aEspVol :={}
					cScan := "1"
					While ( !Empty(cScan) )
						cEspecie := Upper(FieldGet(FieldPos("F2_ESPECI"+cScan)))
						If !Empty(cEspecie)
							nScan := aScan(aEspVol,{|x| x[1] == cEspecie})
							If ( nScan==0 .AND.cScan == "1" )
								aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , SF2->F2_PLIQUI , SF2->F2_PBRUTO})
							ElseIf ( nScan<>0 .AND.cScan == "1" )
								aEspVol[nScan][2] += FieldGet(FieldPos("F2_VOLUME"+cScan))
							Else
								aadd(aEspVol,{ cEspecie, FieldGet(FieldPos("F2_VOLUME"+cScan)) , 0 , 0})
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
					cMensCli += " | " + IIF(SD2->D2_TES $ "517/518","Mercadoria remetida por conta e ordem de ","Local Entrega: ") + AllTrim(SA1->A1_NOME)
					cMensCli += " CNPJ: " +	Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
					cMensCli += " I.E.:" + AllTrim(SA1->A1_INSCR)
					cMensCli += " Endereco: " + AllTrim(SA1->A1_END) + " " + AllTrim(SA1->A1_BAIRRO)
					cMensCli += " " + AllTrim(SA1->A1_MUN) + " " + AllTrim(SA1->A1_EST) + " " + AllTrim(SA1->A1_CEP)

				Endif
				
				lFirst := .F.
				
				cDescCien 	:= AllTrim(Posicione("SB5",1,xFilial("SB5") + cCodPrd,"B5_CEME"))

				cCodCli		:= AllTrim(Posicione("SA7",1,xFilial("SA7") + SD2->D2_CLIENTE + SD2->D2_LOJA + cCodPrd,"A7_CODCLI"))

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

			aProd[nPrd, 4] := cDescProd +" "+cMSGONU
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
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,aDetPag)
	aadd(aRetorno,aObsCotAux)

	aadd(aRetorno,aPedido)
	aadd(aRetorno,aICMS)
	aadd(aRetorno,aICMSST)
	aadd(aRetorno,aIPI)
	aadd(aRetorno,aPIS)
	aadd(aRetorno,aPISST)
	aadd(aRetorno,aCOFINS)
	aadd(aRetorno,aCOFINSST)
	aadd(aRetorno,aISSQN)
	aadd(aRetorno,aCST)

	aadd(aRetorno,aMed)
	aadd(aRetorno,aArma)
	aadd(aRetorno,aveicProd)
	aadd(aRetorno,aDI)
	aadd(aRetorno,aAdi)
	aadd(aRetorno,aExp)
	aadd(aRetorno,aPisAlqZ)
	aadd(aRetorno,aCofAlqZ)
	aadd(aRetorno,aAnfI)
	aadd(aRetorno,aComb)
	aadd(aRetorno,aCsosn)
	aadd(aRetorno,aPedCom)
	aadd(aRetorno,aICMSZFM)
	aadd(aRetorno,aFCI)
	aadd(aRetorno,aAgrPis)
	aadd(aRetorno,aAgrCofins)
	aadd(aRetorno,aICMUFDest)
	aadd(aRetorno,aIPIDevol)
	aadd(aRetorno,aItemVinc)
	aadd(aRetorno,aLote)

	aEval(aAreasRst, {|aArea|restArea(aArea)})
	aSize(aAreasRst,0)

Return aRetorno

Static Function AGLPRD(aProd,aInfoItem)

	Local aProdTmp := aProd
	Local nTamPrd := Len(aProd)
	Local nX := 0

	if len(aProdTmp) > 1
		aProdTmp 	:= {}
		aICMSTmp	:=  {}
		aICMSSTTmp	:=  {}
		aIPITmp     :=  {}
		aPISTmp     :=  {}
		aPISSTTmp   :=  {}
		aCOFINSTmp  :=  {}
		aCOFINSSTTmp:=  {}
		aISSQNTmp   :=  {}
		aCSTTmp     :=  {}
		aMedtmp := {}
		aArmatmp := {}
		aveicProdtmp := {}
		aDItmp := {}
		aAditmp := {}
		aExptmp := {}
		aPisAlqZtmp := {}
		aCofAlqZtmp := {}
		aAnfItmp := {}
		aCombtmp := {}
		aCsosntmp := {}
		aPedComtmp := {}
		aICMSZFMtmp := {}
		aFCItmp := {}
		aAgrPistmp := {}
		aAgrCoftmp := {}
		aICMDesttmp := {}
		aIPIDtmp := {}
		aItemVinctmp := {}
		aLotetmp := {}
		aInfoItemTP := {}

		for nX:= 1 TO nTamPrd

			cProd := aProd[nX][2]
			cLote := aProd[nX][19]
			cNumitem := aInfoItem[nX][4]

			dbSelectArea("SD2")
			dbSetOrder(3)
			MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+cProd+cNumitem)

			dbSelectArea("SB8")
			dbSetOrder(3)
			MSSeek(xFilial("SB8") + cProd + SD2->D2_LOCAL + SD2->D2_LOTECTL + space(TamSX3("B8_NUMLOTE")[1]) +DTOS(SD2->D2_DTVALID) )

			nScan := aScan(aProdTmp ,{|x| x[2] == cProd  .and. x[19] == SB8->B8_LOTECTL} )

			If ( nScan == 0 )
				aadd(aProdTmp,aProd[nX])
				aProdTmp[len(aProdTmp)][1]  := len(aProdTmp)
				aProdTmp[len(aProdTmp)][19]  := SB8->B8_LOTECTL

				aadd(aInfoItemTP , aInfoItem[nX])
				aInfoItemTP[len(aInfoItemTP)][1]  := len(aInfoItemTP)

				aadd(aIcmsTmp,aICMS[nX])

				aadd(aICMSSTTmp,aICMSST[nX])

				aadd(aIPITmp,aIPI[nX])

				aadd(aPISTmp,aPIS[nX])

				aadd(aPISSTTmp,aPISST[nX])

				aadd(aCOFINSTmp,aCOFINS[nX])

				aadd(aCOFINSSTTmp,aCOFINSST[nX])

				aadd(aISSQNTmp,aISSQN[nX])

				aadd(aCSTTmp,aCST[nX])

				aadd(aMedtmp,aMed[nX])
				aadd(aArmatmp,aArma[nX])
				aadd(aveicProdtmp,aveicProd[nX])
				aadd(aDItmp,aDI[nX])
				aadd(aAditmp,aAdi[nX])
				aadd(aExptmp,aExp[nX])
				aadd(aPisAlqZtmp,aPisAlqZ[nX])
				aadd(aCofAlqZtmp,aCofAlqZ[nX])
				aadd(aAnfItmp,aAnfI[nX])
				aadd(aCombtmp,aComb[nX])
				aadd(aCsosntmp,aCsosn[nX])
				aadd(aPedComtmp,aPedCom[nX])
				aadd(aICMSZFMtmp,aICMSZFM[nX])
				aadd(aFCItmp,aFCI[nX])
				aadd(aAgrPistmp,aAgrPis[nX])
				aadd(aAgrCoftmp,aAgrCofins[nX])
				aadd(aICMDesttmp,aICMUFDest[nX])
				aadd(aIPIDtmp,aIPIDevol[nX])
				aadd(aItemVinctmp,aItemVinc[nX])
				aadd(aLotetmp,aLote[nX])

			Else
				//Produto
				aProdTmp[nScan,09] += aProd[nX,09]
				aProdTmp[nScan,10] += aProd[nX,10]
				aProdTmp[nScan,12] += aProd[nX,12]

				//icms
				if 	len(aIcmsTmp[nScan] )  > 0
					aIcmsTmp[nScan,05] += aIcms[nX,05]
					aIcmsTmp[nScan,07] += aIcms[nX,07]
				endif

				//ipi
				if 	len(aIPITmp[nScan] )  > 0
					aIPITmp[nScan,06] += aIPI[nX,06]
					aIPITmp[nScan,07] += aIPI[nX,07]
					aIPITmp[nScan,10] += aIPI[nX,10]
				endif

				//Pis
				if 	len(aPISTmp[nScan] )  > 0
					aPISTmp[nScan,02] += aPIS[nX,02]
					aPISTmp[nScan,04] += aPIS[nX,04]
					aPISTmp[nScan,05] += aPIS[nX,05]
				endif

				//Cofins
				if 	len(aCOFINSTmp[nScan] )  > 0
					aCOFINSTmp[nScan,02] += aCOFINS[nX,02]
					aCOFINSTmp[nScan,04] += aCOFINS[nX,04]
					aCOFINSTmp[nScan,05] += aCOFINS[nX,05]
				endif

				//Pis ST
				if 	len(aPISSTTmp[nScan] )  > 0
					aPISSTTmp[nScan,02] += aPISST[nX,02]
					aPISSTTmp[nScan,04] += aPISST[nX,04]
					aPISSTTmp[nScan,05] += aPISST[nX,05]
				endif
				//Cofins ST
				if 	len(aCOFINSSTTmp[nScan] )  > 0
					aCOFINSSTTmp[nScan,02] += aCOFINSST[nX,02]
					aCOFINSSTTmp[nScan,04] += aCOFINSST[nX,04]
					aCOFINSSTTmp[nScan,05] += aCOFINSST[nX,05]
				endif

			EndIf

		Next nX
		aProd		:=	aProdTmp
		aICMS		:=	aICMSTmp
		aICMSST		:=	aICMSSTTmp
		aIPI		:=	aIPITmp
		aPIS		:=	aPISTmp
		aPISST		:=	aPISSTTmp
		aCOFINS		:=	aCOFINSTmp
		aCOFINSST	:=	aCOFINSSTTmp
		aISSQN		:=	aISSQNTmp
		aCST		:=	aCSTTmp

		aMed := aMedtmp
		aArma := aArmatmp
		aveicProd := aveicProdtmp
		aDI := aDItmp
		aAdi := aAditmp
		aExp := aExptmp
		aPisAlqZ := aPisAlqZtmp
		aCofAlqZ := aCofAlqZtmp
		aAnfI := aAnfItmp
		aComb := aCombtmp
		aCsosn := aCsosntmp
		aPedCom := aPedComtmp
		aICMSZFM := aICMSZFMtmp
		aFCI := aFCItmp
		aAgrPis := aAgrPistmp
		aAgrCofins := aAgrCoftmp
		aICMUFDest := aICMDesttmp
		aIPIDevol := aIPIDtmp
		aItemVinc := aItemVinctmp
		aLote := aLotetmp
		aInfoItem := aInfoItemTP

	endif

Return(aProd)

Static Function F1OBSNFE()
	Local om_Obs
	Local cm_Obs := ""
	Local lOk := .F.
	Local aButtons	:= {}
	Private oDlg				// Dialog Principal

	While !lOk
		DEFINE MSDIALOG oDlg TITLE "Observações da NFe" FROM 0,0 TO 195,400 PIXEL
		// Cria as Groups do Sistema
		@ 35,5 TO 100,195 LABEL " Observações: (máximo 1500)" PIXEL OF oDlg
		// Cria Componentes Padroes do Sistema
		@ 45,10 GET om_Obs Var cm_Obs MEMO Size 180,50 PIXEL OF oDlg

		ACTIVATE MSDIALOG oDlg CENTERED  ON INIT EnchoiceBar(oDlg, {|| if( ValObs(cm_Obs),(lOk := .t., oDlg:End()),nil) },{|| lOk := .f.,oDlg:End()},,aButtons)

		if ( lOk )
			RecLock("SF1", .f.)
			SF1->F1_OBSNFE := Substr(cm_Obs,1,200)
			SF1->(MsUnlock())
		endIf
	EndDo

Return(cm_Obs)

static function ValObs( cObs )
	Local lRet  := .T.
	if len( cObs ) > 1500
		msgAlert( "O conteúdo da observação deverá conter no máximo 1500 caracterers. Você digitou até o momento " + alltrim(str(len(cObs))) + " caracteres.","Atencao")
		lRet :=  .f.
	endIf

	if empty(cObs)
		msgAlert( "Campo obrigatório","Atencao")
		lRet :=  .f.
	endIf

Return lRet
