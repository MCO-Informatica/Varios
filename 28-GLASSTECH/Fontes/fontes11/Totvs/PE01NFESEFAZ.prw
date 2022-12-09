#include "Protheus.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor  ³João Zabotto      º Data ³  23/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mensagens adicionais para a danfe.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PE01NFESEFAZ
	Local xArea	    := GetArea()
	Local aProd		:= PARAMIXB[1]
	Local cMensCli	:= PARAMIXB[2]
	Local cMensFis	:= PARAMIXB[3]
	Local aDest 	:= PARAMIXB[4]
	Local aNota 	:= PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl		:= PARAMIXB[7]
	Local aTransp	:= PARAMIXB[8]
	Local aEntrega	:= PARAMIXB[9]
	Local aRetirada	:= PARAMIXB[10]
	Local aVeiculo	:= PARAMIXB[11]
	Local aReboque	:= PARAMIXB[12]
	Local aRet      := {}
	Local aCaixa    := {}
	Local cDescaux  := ''
	Local nP        := 0

	Local aAglut     := aClone(aProd)
	Local nScan      := 0

	Local aICMS      := PARAMIXB[13,1]
	Local aICMSST    := PARAMIXB[13,2]
	Local aIPI       := PARAMIXB[13,3]
	Local aPIS       := PARAMIXB[13,4]
	Local aPISST     := PARAMIXB[13,5]
	Local aCOFINS    := PARAMIXB[13,6]
	Local aCOFINSST  := PARAMIXB[13,7]
	Local aISSQN     := PARAMIXB[13,8]
	Local aCST       := PARAMIXB[13,9]
	Local aMed       := PARAMIXB[13,10]
	Local aArma      := PARAMIXB[13,11]
	Local aveicProd  := PARAMIXB[13,12]
	Local aDI        := PARAMIXB[13,13]
	Local aAdi	     := PARAMIXB[13,14]
	Local aExp	     := PARAMIXB[13,15]
	Local aPisAlqZ   := PARAMIXB[13,16]
	Local aCofAlqZ   := PARAMIXB[13,17]
	Local aAnfI	 	 := PARAMIXB[13,18]
	Local aComb	     := PARAMIXB[13,19]
	Local aCsosn	 := PARAMIXB[13,20]
	Local aArray     := {}
	Local _nNota     := 0
	Local _lGap      := .F.
	Local cNcm       := ''
	Local cTpVidro   := ''
	Local cSuframa   := ''
	Local cUf        := ''

	If aNota[4] == "1"     && Mensagens para as notas ficais de SAIDA.

		&& Adiciono o codigo + loja do cliente a razão social do cliente impressa na danfe
		aDest[2]:= SF2->(F2_CLIENTE + "/" + F2_LOJA) + "-"  + aDest[2]

		&&Adiciona a mensagem do endereco de entrega
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			cSuframa := Alltrim(SA1->A1_SUFRAMA)
			cUf      := Alltrim(SA1->A1_EST)
			If !Empty(SA1->A1_ENDENT)
				If Alltrim(SA1->A1_END) != Alltrim(SA1->A1_ENDENT)

					cMensCli += " LOCAL DE ENTREGA: "+Alltrim(SA1->A1_ENDENT)

					If !Empty(SA1->A1_BAIRROE)
						cMensCli += " Bairro: "+Alltrim(SA1->A1_BAIRROE)
					EndIf

					If !EMpty(SA1->A1_MUN)
						cMensCli += " Mun: "+Alltrim(SA1->A1_MUN)
					EndIf

					If !EMpty(SA1->A1_EST)
						cMensCli += " UF: "+Alltrim(SA1->A1_EST)
					EndIf

					If !Empty(SA1->A1_CEP)
						cMensCli += " CEP:"+Alltrim(SA1->A1_CEP)
					EndIf
				EndIf
			EndIf
		EndIf
		&&Fim mensagem do endereco de entrega

		&&Bloco de codigo para trazer o valor liquido do titulos
		nX := 0
		For nX := 1 to Len(aDupl)
			nAbatim := 0

			SE1->(DbSetOrder(1))
			If SE1->(DbSeek(xFilial("SE1")+aDupl[nX][1]))

				while SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA == aDupl[nX][1]

					If Alltrim(SE1->E1_TIPO) == "NF"
						nAbatim := (SE1->E1_VALOR - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA))
					EndIf

					SE1->(DbSkip())
				End

				if nAbatim > 0
					aDupl[nX][3] := nAbatim
				EndIf

			EndIf
		Next nX

		If aNota[5] == "N"
			lAddMsg := .F.

			&& Adiciona mensagem de PIS e COFINS RETIDO
			For nX := 1 to Len(aProd)
				If Alltrim(aProd[nX][7]) == "5101"
					lAddMsg := .T.
				EndIf
				If SB1->(DbSeek(xFilial('SB1') + aProd[nX,2]))
					If SB1->B1_GRUPO = '0027'
						cDescaux:= U_GETPDESC(aProd[nX,2])
						If !Empty(cDescaux)
							aProd[nX,4]:= cDescaux
						EndIf
					EndIF
				EndIf
			Next nX

			If lAddMsg
				If SF2->F2_VALPIS > 0 .AND. SF2->F2_VALCOFI > 0
					cMensFis += " RETENÇÃO de 0,10% PIS R$ " + Alltrim(Transform(SF2->F2_VALPIS, "@999,999,999.99"))
					cMensFis += " RETENÇÃO de 0,50% COFINS R$ " + Alltrim(Transform(SF2->F2_VALCOFI, "@999,999,999.99"))
				EndIf
			EndIf
			&& Fim mensagem de PIS e COFINS RETIDO.

			nX:= 0
			For nX := 1 to Len(aInfoItem)
				If !aInfoItem[nX,1] $ cMensFis
					If !"Ped.Venda: " $ cMensFis
						cMensFis += "Ped.Venda: " + aInfoItem[nX,1]
					Else
						cMensFis+= '/' +  aInfoItem[nX,1]
					EndIf
				EndIf
				SD2->(DbSetOrder(8))
				If SD2->(DbSeek(xFilial('SD2') + aInfoItem[nX][1] + aInfoItem[nX][2]))
					If !Empty(SD2->D2_NUMLOTE) .And. !Empty(SD2->D2_DTVALID)
						aProd[nX,4]+= '-Lote.:' + Alltrim(SD2->D2_NUMLOTE)
						aProd[nX,4]+= '/ Dt.Valid.:' + Alltrim(SD2->D2_DTVALID)
					EndIf
					SB1->(DBSetOrder(1))
					If SB1->(DbSeek(xFilial('SB1') + SD2->D2_COD))
						If SB1->B1_GRUPO $ '0027,0003'
							ZZ5->(DbSetOrder(2))
							If ZZ5->(Dbseek(xFilial('ZZ5') + SB1->B1_ZZTVIDR))
								cTpVidro := ZZ5->ZZ5_TIPO
								If cTpVidro == '1'
									cNcm := '70072100'
								ElseIf cTpVidro = '2'
									cNcm := '70071100'
								EndIf
								If cUf == 'EX' .Or. SD2->D2_CF = '5501' .Or. (SD2->D2_DESCZFR > 0 .And. !Empty(cSuframa))
									aProd[nX,5] := cNcm
								EndIf
							EndIf
						EndIF
					EndIf
				EndIf
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek(xFilial('SC6') + aInfoItem[nX][1] + aInfoItem[nX][2]))
					If !Empty(SC6->C6_PEDCLI)
						aProd[nX,4] += '-Ped.Cli' + SC6->C6_PEDCLI
					EndIf
				EndIf
			Next nX
		EndIf

		SZZ->(DbSetOrder(1))
		If SZZ->(DbSeek(xFilial('SZZ') + SF2->('S' + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)))
			While !SZZ->(Eof()) .And. SF2->('S' + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) == ;
					SZZ->(ZZ_TIPODOC + ZZ_DOC + ZZ_SERIE + ZZ_CLIFOR + ZZ_LOJA)

				nP := aScan(aCaixa, {|x| x[1] == SZZ->ZZ_CODMENS})
				If nP == 0
					AaDd(aCaixa,{SZZ->ZZ_CODMENS,1,AllTrim(SZZ->ZZ_TXTMENS)})
				Else
					aCaixa[nP,2] := aCaixa[nP,2]+1
				EndIf
				SZZ->(DbSkip())
			EndDo
		EndIf
		For nX:= 1 To Len(aCaixa)
			cMensCli += CvaltoChar(aCaixa[nX,2]) + '-' +aCaixa[nX,3] + '/'
		Next


		AglutItens(@aProd, @aICMS, @aICMSST, @aIPI, @aPIS, @aPISST, @aCOFINS, @aCOFINSST, @aISSQN, @aCST, @aMed, @aArma, @aveicProd, @aDI, @aAdi, @aExp, @aPisAlqZ, @aCofAlqZ, @aAnfI, @aComb, @aCsosn, @aInfoItem)

	Else && Mensagens para as notas ficais de ENTRADA.

	EndIf

	RestArea(xArea)

	aArray := {aICMS, aICMSST, aIPI, aPIS, aPISST, aCOFINS, aCOFINSST, aISSQN, aCST, aMed, aArma, aveicProd, aDI, aAdi, aExp, aPisAlqZ, aCofAlqZ, aAnfI, aComb, aCsosn}

	Return({aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aArray})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor  ³Microsiga           º Data ³  06/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                              º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AglutItens(aProd, aICMS, aICMSST, aIPI, aPIS, aPISST, aCOFINS, aCOFINSST, aISSQN, aCST, aMed, aArma, aveicProd, aDI, aAdi, aExp, aPisAlqZ, aCofAlqZ, aAnfI, aComb, aCsosn)
	Local aProd2		:= {}
	Local aICMS2		:= {}
	Local aICMSST2		:= {}
	Local aIPI2			:= {}
	Local aPIS2			:= {}
	Local aPISST2		:= {}
	Local aCOFINS2		:= {}
	Local aCOFINSST2	:= {}
	Local aISSQN2		:= {}
	Local aCST2			:= {}
	Local aMed2			:= {}
	Local aArma2		:= {}
	Local aveicProd2	:= {}
	Local aDI2			:= {}
	Local aAdi2			:= {}
	Local aExp2			:= {}
	Local aPisAlqZ2		:= {}
	Local aCofAlqZ2		:= {}
	Local aAnfI2		:= {}
	Local aComb2		:= {}
	Local aCsosn2		:= {}
	Local aTemp			:= {}
	Local nI			:= 0
	Local nJ			:= 0
	Local nMaxInd		:= 0
	Local nInd			:= 0
	Local lTrocou		:= .T.

	For nI := 1 To Len(aProd)
		If lTrocou
// Carrega as informações que são comuns e não aglutinadas.
// aProd
			nMaxInd	:= Len(aProd[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				If nJ == 10
					aTemp[nJ] := Round(aProd[nI, nJ], 02)
				Else
					aTemp[nJ] := aProd[nI, nJ]
				EndIf
			Next nJ
			aAdd(aProd2, aTemp)

// aICMS
			nMaxInd	:= Len(aICMS[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aICMS[nI, nJ]
			Next nJ
			aAdd(aICMS2, aTemp)

// aICMSST
			nMaxInd	:= Len(aICMSST[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aICMSST[nI, nJ]
			Next nJ
			aAdd(aICMSST2, aTemp)

// aIPI
			nMaxInd	:= Len(aIPI[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aIPI[nI, nJ]
			Next nJ
			aAdd(aIPI2, aTemp)

// aPIS
			nMaxInd	:= Len(aPIS[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aPIS[nI, nJ]
			Next nJ
			aAdd(aPIS2, aTemp)

// aPISST
			nMaxInd	:= Len(aPISST[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aPISST[nI, nJ]
			Next nJ
			aAdd(aPISST2, aTemp)

// aCOFINS
			nMaxInd	:= Len(aCOFINS[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aCOFINS[nI, nJ]
			Next nJ
			aAdd(aCOFINS2, aTemp)

// aCOFINSST
			nMaxInd	:= Len(aCOFINSST[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aCOFINSST[nI, nJ]
			Next nJ
			aAdd(aCOFINSST2, aTemp)

// aISSQN
			nMaxInd	:= Len(aISSQN[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aISSQN[nI, nJ]
			Next nJ
			aAdd(aISSQN2, aTemp)

// aCST
			nMaxInd	:= Len(aCST[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aCST[nI, nJ]
			Next nJ
			aAdd(aCST2, aTemp)

// aMed
			nMaxInd	:= Len(aMed[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aMed[nI, nJ]
			Next nJ
			aAdd(aMed2, aTemp)

// aArma
			nMaxInd	:= Len(aArma[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aArma[nI, nJ]
			Next nJ
			aAdd(aArma2, aTemp)

// aveicProd
			nMaxInd	:= Len(aveicProd[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aveicProd[nI, nJ]
			Next nJ
			aAdd(aveicProd2, aTemp)

// aDI
			nMaxInd	:= Len(aDI[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aDI[nI, nJ]
			Next nJ
			aAdd(aDI2, aTemp)

// aAdi
			nMaxInd	:= Len(aAdi[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aAdi[nI, nJ]
			Next nJ
			aAdd(aAdi2, aTemp)

// aExp
			nMaxInd	:= Len(aExp[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aExp[nI, nJ]
			Next nJ
			aAdd(aExp2, aTemp)

// aPisAlqZ
			nMaxInd	:= Len(aPisAlqZ[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aPisAlqZ[nI, nJ]
			Next nJ
			aAdd(aPisAlqZ2, aTemp)

// aCofAlqZ
			nMaxInd	:= Len(aCofAlqZ[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aCofAlqZ[nI, nJ]
			Next nJ
			aAdd(aCofAlqZ2, aTemp)

// aAnfI
			nMaxInd	:= Len(aAnfI[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aAnfI[nI, nJ]
			Next nJ
			aAdd(aAnfI2, aTemp)

// aComb
			nMaxInd	:= Len(aComb[nI])
			aTemp	:= Array(nMaxInd)

			For nJ := 1 To nMaxInd
				aTemp[nJ] := aComb[nI, nJ]
			Next nJ
			aAdd(aComb2, aTemp)

// aCsosn - Esse array não tem sub-níveis, portanto não usa o array temporário.
			aAdd(aCsosn2, aCsosn[nI])

			lTrocou := .F.
		Else
			nInd := Len(aProd2)

// Campos do aProd que devem ser acumulados: 09, 10, 12, 13, 14, 15, 16 e 21
			If Len(aProd2[nInd]) > 0
				aProd2[nInd, 09]		+= aProd[nI, 09]
				aProd2[nInd, 10]		+= Round(aProd[nI, 10], 02)
				aProd2[nInd, 12]		+= aProd[nI, 12]
				aProd2[nInd, 13]		+= aProd[nI, 13]
				aProd2[nInd, 14]		+= aProd[nI, 14]
				aProd2[nInd, 15]		+= aProd[nI, 15]
//aProd2[nInd, 16]		+= aProd[nI, 16]	Preço Unitário
				aProd2[nInd, 21]		+= aProd[nI, 21]
				aProd2[nInd, 26]		+= aProd[nI, 26]
			EndIf

// Campos do aICMS que devem ser acumulados: 05, 07 e 09
			If Len(aICMS2[nInd]) > 0
				aICMS2[nInd, 05]		+= aICMS[nI, 05]
				aICMS2[nInd, 07]		+= aICMS[nI, 07]
				aICMS2[nInd, 09]		+= aICMS[nI, 09]
			EndIf

// Campos do aIPI que devem ser acumulados: 06, 07 e 10
			If Len(aIPI2[nInd]) > 0
				aIPI2[nInd, 06]			+= aIPI[nI, 06]
				aIPI2[nInd, 07]			+= aIPI[nI, 07]
				aIPI2[nInd, 10]			+= aIPI[nI, 10]
			EndIf

// Campos do aICMSST que devem ser acumulados: 05, 07 e 09
			If Len(aICMSST2[nInd]) > 0
				aICMSST2[nInd, 05]		+= aICMSST[nI, 05]
				aICMSST2[nInd, 07]		+= aICMSST[nI, 07]
				aICMSST2[nInd, 09]		+= aICMSST[nI, 09]
			EndIf

// Campos do aPIS que devem ser acumulados: 02, 04 e 05
			If Len(aPIS2[nInd]) > 0
				aPIS2[nInd, 02]			+= aPIS[nI, 02]
				aPIS2[nInd, 04]			+= aPIS[nI, 04]
				aPIS2[nInd, 05]			+= aPIS[nI, 05]
			EndIf

// Campos do aPISST que devem ser acumulados: 02, 04 e 05
			If Len(aPISST2[nInd]) > 0
				aPISST2[nInd, 02]		+= aPISST[nI, 02]
				aPISST2[nInd, 04]		+= aPISST[nI, 04]
				aPISST2[nInd, 05]		+= aPISST[nI, 05]
			EndIf

// Campos do aCofins que devem ser acumulados: 02, 04 e 05
			If Len(aCofins2[nInd]) > 0
				aCofins2[nInd, 02]		+= aCofins[nI, 02]
				aCofins2[nInd, 04]		+= aCofins[nI, 04]
				aCofins2[nInd, 05]		+= aCofins[nI, 05]
			EndIf

// Campos do aCOFINSST que devem ser acumulados: 02, 04 e 05
			If Len(aCOFINSST2[nInd]) > 0
				aCOFINSST2[nInd, 02]	+= aCOFINSST[nI, 02]
				aCOFINSST2[nInd, 04]	+= aCOFINSST[nI, 04]
				aCOFINSST2[nInd, 05]	+= aCOFINSST[nI, 05]
			EndIf

// Campos do aISSQN que devem ser acumulados: 02, 05, 06 e 08
			If Len(aISSQN2[nInd]) > 0
				aISSQN2[nInd, 02]		+= aISSQN[nI, 02]
				aISSQN2[nInd, 05]		+= aISSQN[nI, 05]
				aISSQN2[nInd, 06]		+= aISSQN[nI, 06]
				aISSQN2[nInd, 08]		+= aISSQN[nI, 08]
			EndIf
// Os demais arrays, não possuem campos a serem acumulados e já foram movimentados na primeira parte deste "If".
		EndIf

		If nI + 1 <= Len(aProd)
			If aProd[nI + 1, 02] != aProd[nI, 02] .Or. aProd[nI + 1, 16] != aProd[nI, 16] .Or. aProd[nI + 1, 22] != aProd[nI, 22]
				lTrocou := .T.
			EndIf
		EndIf
	Next nI

// Aqui refazer a coluna "itens" do aProd2 ( aProd2[nI, 01] )
	For nI := 1 To Len(aProd2)
		aProd2[nI, 01] := nI
	Next nI

// Agora que está montado os aglutinados, devolve aos originais.
	aProd		:= aClone(aProd2	)
	aICMS		:= aClone(aICMS2	)
	aICMSST		:= aClone(aICMSST2	)
	aIPI		:= aClone(aIPI2		)
	aPIS		:= aClone(aPIS2		)
	aPISST		:= aClone(aPISST2	)
	aCOFINS		:= aClone(aCOFINS2	)
	aCOFINSST	:= aClone(aCOFINSST2)
	aISSQN		:= aClone(aISSQN2	)
	aCST		:= aClone(aCST2		)
	aMed		:= aClone(aMed2		)
	aArma		:= aClone(aArma2	)
	aveicProd	:= aClone(aveicProd2)
	aDI			:= aClone(aDI2		)
	aAdi		:= aClone(aAdi2		)
	aExp		:= aClone(aExp2		)
	aPisAlqZ	:= aClone(aPisAlqZ2	)
	aCofAlqZ	:= aClone(aCofAlqZ2	)
	aAnfI		:= aClone(aAnfI2	)
	aComb		:= aClone(aComb2	)
	aCsosn		:= aClone(aCsosn2	)
	Return
