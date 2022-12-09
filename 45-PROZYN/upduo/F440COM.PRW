#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F440COM   º Autor ³ Denis Varella      Data ³ 23/11/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Customização de comissão para preenchimento correteo da SE3 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function F440COM(dDataDe,dDataAte,cVendDe,cVendAte, cParcela)   
	Local nFreteNF 	:= 0
	Local nFreteD1 	:= 0
	Local lDescont	:= .F.
	Local aRet		:= {0,0}
    Private nPercParc := 0
	Private aNFSProc := {} 
	Default dDataDe	:= CtoD("  /  /    ")
	Default dDataAte:= CtoD("  /  /    ")
	Default cVendDe := ""
	Default cVendAte:= ""
	Default cParcela:= ""

    If ValType("aNFSProc") == 'U'
        aNFSProc := {}
    EndIf

    If aScan(aNFSProc,SF2->F2_DOC) > 0
        return
    EndIf

    aAdd(aNFSProc, SF2->F2_DOC)
                                                                         
	nFreteNF := SF2->F2_FRETE  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Contabilizar todos os fretes vinculados a esta nota³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DbSelectArea("SD1")
    DbOrderNickName("COMIFRE") //D1_FILIAL+D1_NFSAIDA+D1_FORNECE+D1_LOJA+D1_DOC+D1_ITEM  
    If SD1->(DbSeek(xFilial("SD1")+SF2->F2_DOC))
    	While !SD1->(Eof()) .AND. SD1->(D1_FILIAL+D1_NFSAIDA) == xFilial("SD1")+SF2->F2_DOC
    		nFreteD1 += SD1->D1_TOTAL
    		SD1->(DbSkip())
    	EndDo
    EndIf

	If select("tVEND") > 0 
		tVEND->(DBCloseArea())
	EndIf
	
	If !Empty(dDataDe) .and. !Empty(dDataAte)
		BeginSql alias "tVEND"
			Select E3_VEND,R_E_C_N_O_,E3_EMISSAO FROM %Table:SE3%
			WHERE E3_NUM = %Exp:SF2->F2_DOC% and
			E3_PREFIXO = %Exp:SF2->F2_SERIE% and 
			E3_TIPO != 'AB-' and
			E3_CODCLI = %Exp:SF2->F2_CLIENTE% and
			E3_LOJA = %Exp:SF2->F2_LOJA% and 
			E3_PARCELA = %Exp:cParcela% and
			E3_DATA = '' and
			E3_EMISSAO between %Exp:DtoS(dDataDe)% and %Exp:DtoS(dDataAte)% and
			E3_VEND between %Exp:cVendDe% and %Exp:cVendAte% and
			%notDel%
		EndSql
	Else
		BeginSql alias "tVEND"
			Select E3_VEND,R_E_C_N_O_,E3_EMISSAO FROM %Table:SE3%
			WHERE E3_NUM = %Exp:SF2->F2_DOC% and
			E3_PREFIXO = %Exp:SF2->F2_SERIE% and 
			E3_TIPO != 'AB-' and
			E3_CODCLI = %Exp:SF2->F2_CLIENTE% and
			E3_LOJA = %Exp:SF2->F2_LOJA% and 
			E3_PARCELA = %Exp:cParcela% and
			E3_DATA = '' and
			// E3_EMISSAO between %Exp:DtoS(dDataDe)% and %Exp:DtoS(dDataAte)% and
			// E3_VEND between %Exp:cVendDe% and %Exp:cVendAte% and
			%notDel%
		EndSql
	EndIf

	lDescont := .F.
	While tVEND->(!Eof())
			DbSelectArea("SE3")
			SE3->(DbGoTo(tVEND->R_E_C_N_O_))
			aAreaE3 := SE3->(GetArea())
			DbSelectArea("SE1")
			SE1->(DbSetOrder(1))
			SE1->(DbSeek(xFilial("SE1")+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA+SE3->E3_TIPO))

            nPercParc := SE1->E1_VALOR * 100 / SF2->F2_VALBRUT

			aRet := VerifTipo(tVEND->E3_VEND,SF2->F2_VALBRUT,SE3->E3_PORC,nFreteNF,nFreteD1, SE3->E3_XTPCOMI)
			RestArea(aAreaE3)
			// aRet := VerifyComod(tVEND->E3_VEND,SF2->F2_VALBRUT,SE3->E3_PORC,nFreteNF,nFreteD1)
			SE3->(RecLock("SE3",.F.))
				SE3->E3_PIS		:= aRet[3][1]
				SE3->E3_COFINS	:= aRet[3][2]
				SE3->E3_IPI		:= aRet[3][3]
				SE3->E3_ICMS	:= aRet[3][4]
				SE3->E3_ACRVEN1	:= aRet[3][5]
				
				SE3->E3_FRETENF := aRet[4][1]
				SE3->E3_FRETED1 := aRet[4][2]
				
				SE3->E3_XTPCOMI := aRet[5]

				SE3->E3_BASEBRU	:= SF2->F2_VALBRUT * nPercParc / 100

				nDescontos := SE3->E3_PIS + SE3->E3_COFINS + SE3->E3_ICMS + SE3->E3_IPI + SE3->E3_FRETENF + SE3->E3_FRETED1 + SE3->E3_ACRVEN1

				SE3->E3_BASE	:= aRet[1] - nDescontos

				SE3->E3_PORC	:= aRet[2]
				SE3->E3_COMIS	:= (aRet[1] - nDescontos) / 100 * aRet[2]
			SE3->(MsUnlock())

		tVEND->(dbskip())
	EndDo
   
	tVEND->(DBCloseArea())
Return

Static Function VerifTipo(cVend,nValBruto,nPerc,nFreteNF,nFreteD1, cTipo)
	Local nTotal := 0
    Local nBase := 0
    Local nNegoc := 0
    Local nComod := 0
	Local aRet := { nValBruto, nPerc, { 0,0,0,0,0 }, { nFreteNF,nFreteD1 }, cTipo }
	Local aImpCom := { 0,0,0,0,0 }
	Local aImpNeg := { 0,0,0,0,0 }
	Local aArea := GetArea()
	Local nFreteNF2 := nFreteD12 := 0
	Local nArcVen1 := ""
	Local cTst := "000090626"
	nArcVen1 := POSICIONE("SE4",1,xFilial("SE4")+SF2->F2_COND,"E4_ACRVEN1")

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	SD2->(DbGoTop())
	SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))

	If AllTrim(SF2->F2_DOC) == cTst
		cTst := ""
	EndIf

    aRet[1] := aRet[1] * nPercParc / 100

	While SD2->(!EOF()) .AND. SD2->D2_FILIAL == xFilial("SD2") .AND. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE .AND. SD2->D2_CLIENTE == SF2->F2_CLIENTE .AND. SD2->D2_LOJA == SF2->F2_LOJA

		If SD2->D2_TES $ SuperGetMV("MV_PRDCOM0",,"627")
			SD2->(DbSkip())
			LOOP
		EndIf
		
		If Trim(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_COMOD")) == 'S'
			nComod += SD2->D2_VALBRUT * nPercParc / 100
			aImpCom[1] += SD2->D2_VALIMP6 * nPercParc / 100
			aImpCom[2] += SD2->D2_VALIMP5 * nPercParc / 100
			aImpCom[3] += SD2->D2_VALIPI * nPercParc / 100
			aImpCom[4] += SD2->D2_VALICM * nPercParc / 100
			aImpCom[5] += SD2->D2_VALBRUT * nPercParc / 100 * nArcVen1 / 100

		ElseIf Trim(Posicione("SA7",1,xFilial("SA7")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD,"A7_XTPNEGO")) != ""
			nNegoc += SD2->D2_VALBRUT * nPercParc / 100
			aImpNeg[1] += SD2->D2_VALIMP6 * nPercParc / 100
			aImpNeg[2] += SD2->D2_VALIMP5 * nPercParc / 100
			aImpNeg[3] += SD2->D2_VALIPI * nPercParc / 100
			aImpNeg[4] += SD2->D2_VALICM * nPercParc / 100
			aImpNeg[5] += SD2->D2_VALBRUT * nPercParc / 100 * nArcVen1 / 100
			
		Else
			nBase += SD2->D2_VALBRUT * nPercParc / 100
			aRet[3][1] += SD2->D2_VALIMP6 * nPercParc / 100
			aRet[3][2] += SD2->D2_VALIMP5 * nPercParc / 100
			aRet[3][3] += SD2->D2_VALIPI * nPercParc / 100
			aRet[3][4] += SD2->D2_VALICM * nPercParc / 100
			aRet[3][5] += SD2->D2_VALBRUT * nPercParc / 100 * nArcVen1 / 100
		EndIf
		nTotal += SD2->D2_VALBRUT * nPercParc / 100
		SD2->(DbSkip())
	EndDo

	lBase := .T.
	lNegoc := .F.
	lComod := .F.
	aRet[5] := "NORMAL"
	If nBase == 0
		lBase := .F.
		If nComod > 0
			aRet[1] := nComod
			aRet[3] := aImpCom
			aRet[2] := Posicione("SA3",1,xFilial("SA3")+trim(SE3->E3_VEND),"A3_XCOMCOM")
			aRet[5] := "COMMODITY"
			lComod := .T.
		Else
			If nNegoc > 0
				aRet[1] := nNegoc
				aRet[2] := 0.25
				aRet[3] := aImpNeg
				aRet[5] := "NEGOCIACAO"
				lNegoc := .T.
			EndIf
		EndIf
	EndIf

	//NEGOCIAÇÃO
	// If trim(Posicione("SA3",1,xFilial("SA3")+cVend,"A3_REGIAO")) == 'V'
		If !lNegoc .and. nNegoc > 0
			nPercTot := nNegoc / SF2->F2_VALBRUT
			nFreteNF2 := aRet[4][1] * nPercTot * nPercParc / 100
			nFreteD12 := aRet[4][2] * nPercTot * nPercParc / 100
			GeraSE3(nNegoc, aImpNeg, nFreteNF2, nFreteD12,"NEGOCIACAO")
			If lBase
				nTotal -= nNegoc
				aRet[1] := nTotal
				aRet[4][1] -= nFreteNF2
				aRet[4][2] -= nFreteD12
			EndIf
		EndIf
	// EndIf

	//COMMODITY
	// If trim(Posicione("SA3",1,xFilial("SA3")+cVend,"A3_REGIAO")) == 'V'
		If !lComod .and. nComod > 0
			nPercTot := nComod / SF2->F2_VALBRUT
			nFreteNF2 := aRet[4][1] * nPercTot * nPercParc / 100
			nFreteD12 := aRet[4][2] * nPercTot * nPercParc / 100
			GeraSE3(nComod, aImpCom, nFreteNF2, nFreteD12,"COMMODITY")
			If lBase
				nTotal -= nComod
				aRet[1] := nTotal
				aRet[4][1] -= nFreteNF2
				aRet[4][2] -= nFreteD12
			EndIf
		EndIf
	// EndIf

	RestArea(aArea)

Return aRet

Static Function GeraSE3(nBase, aImpostos, nFreteNF, nFreteD1, cTipo)
	Local aAuto := {}
	Local nArcVen1 := ""
	Local nDescontos := 0
	Local nPerc := 0
	Private lMsErroAuto := .F.

	If cTipo == 'COMMODITY'
		nPerc := Posicione("SA3",1,xFilial("SA3")+trim(SE3->E3_VEND),"A3_XCOMCOM")
	ElseIf cTipo == 'NEGOCIACAO'
		nPerc := 0.25
	EndIf

	If nPerc == 0
		return
	EndIf
		
	nArcVen1 := POSICIONE("SE4",1,xFilial("SE4")+SF2->F2_COND,"E4_ACRVEN1")

	//Posiciona no Cliente/Loja
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SE3->E3_CODCLI+SE3->E3_LOJA))

	//Posiciona no Vendedor
	SA3->(dbSetOrder(1))
	SA3->(dbSeek(xFilial("SA3")+SE3->E3_VEND))

	aAdd(aAuto,{"E3_VEND" ,SE3->E3_VEND,Nil})
	aAdd(aAuto,{"E3_NUM" ,SE3->E3_NUM ,Nil})
	aAdd(aAuto,{"E3_EMISSAO" ,SE3->E3_EMISSAO ,Nil})
	aAdd(aAuto,{"E3_SERIE" ,SE3->E3_SERIE ,Nil})
	aAdd(aAuto,{"E3_CODCLI" ,SE3->E3_CODCLI ,Nil})
	aAdd(aAuto,{"E3_LOJA" ,SE3->E3_LOJA ,Nil})
	

	nDescontos := (aImpostos[1]+aImpostos[2]+aImpostos[3]+aImpostos[4]+aImpostos[5]+nFreteNF+nFreteD1)
	aAdd(aAuto,{"E3_BASE" ,nBase - nDescontos ,Nil})
	aAdd(aAuto,{"E3_PORC" ,nPerc ,Nil})
	aAdd(aAuto,{"E3_FRETENF" ,nFreteNF ,Nil})
	aAdd(aAuto,{"E3_FRETED1" ,nFreteD1 ,Nil})
	
	aAdd(aAuto,{"E3_PIS" 	,aImpostos[1] ,Nil})
	aAdd(aAuto,{"E3_COFINS" ,aImpostos[2] ,Nil})
	aAdd(aAuto,{"E3_IPI" 	,aImpostos[3] ,Nil})
	aAdd(aAuto,{"E3_ICMS" 	,aImpostos[4] ,Nil})
	aAdd(aAuto,{"E3_ACRVEN1",aImpostos[5] ,Nil})
	aAdd(aAuto,{"E3_XTPCOMI",cTipo ,Nil})

	aAdd(aAuto,{"E3_BASEBRU" ,SF2->F2_VALBRUT * nPercParc / 100 ,Nil})
	aAdd(aAuto,{"E3_DATA" ,SE3->E3_DATA ,Nil})
	aAdd(aAuto,{"E3_PREFIXO" ,SE3->E3_PREFIXO ,Nil})
	aAdd(aAuto,{"E3_PARCELA" ,SE3->E3_PARCELA ,Nil})
	aAdd(aAuto,{"E3_SEQ" ,"  " ,Nil})
	aAdd(aAuto,{"E3_TIPO" ,SE3->E3_TIPO ,Nil})
	aAdd(aAuto,{"E3_PEDIDO" ,SE3->E3_PEDIDO ,Nil})
	aAdd(aAuto,{"E3_VENCTO" ,SE3->E3_VENCTO ,Nil})
	aAdd(aAuto,{"E3_PROCCOM" ,SE3->E3_PROCCOM ,Nil})
	aAdd(aAuto,{"E3_MOEDA" ,SE3->E3_MOEDA ,Nil})
	aAdd(aAuto,{"E3_BAIEMI" ,SE3->E3_BAIEMI ,Nil})
	aAdd(aAuto,{"E3_ORIGEM" ,SE3->E3_ORIGEM ,Nil})
	aAdd(aAuto,{"E3_SDOC" ,SE3->E3_SDOC ,Nil})
	aAdd(aAuto,{"E3_ORIGEM" ,SE3->E3_ORIGEM ,Nil})

	MSExecAuto({|x,y| Mata490(x,y)},aAuto,3)

	If lMsErroAuto
		MostraErro()
	EndIf
Return
