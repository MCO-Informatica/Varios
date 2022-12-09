#Include 'Protheus.ch'

User Function MT416FIM()
	Local cNiv := Alltrim(SC5->C5_ZZNIVEL)
	Local _aArea  		:=  _aAreaSC5 := _aAreaSC6 := {}
	Local nValIPI:= 0
	Local aDadoIMP := {}
	Local cTipCli:= Posicione('SA1',1,xFilial('SA1') + M->(C5_CLIENTE + C5_LOJACLI),'A1_TIPO')
	Local nX       := 0
	Local nValTot1 := 0
	Local nValTot2 := 0
	Local nPosPrd := 0
	Local nPosTes := 0
	Local nPosQtd := 0
	Local nPosLst := 0
	Local nPosDes := 0
	Local nPosMer := 0


	_aArSC5 := SC5-> ( GetArea() )
	_aArSC6 := SC6-> ( GetArea() )

	If Alltrim(M->C5_CONDPAG) = '001'
		MaFisSave()
		MaFisEnd()

		MaFisIni(M->C5_CLIENTE,;&& 1-Codigo Cliente/Fornecedor
		M->C5_LOJACLI,;		&& 2-Loja do Cliente/Fornecedor
		"C",;				&& 3-C:Cliente , F:Fornecedor
		"N",;				&& 4-Tipo da NF
		cTipCli,;		&& 5-Tipo do Cliente/Fornecedor
		Nil,;
			Nil,;
			Nil,;
			Nil,;
			"MATA461")

		For nX := 1 To Len(aCols)
			nPosPrd := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_PRODUTO"})
			nPosTes := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_TES"})
			nPosQtd := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_QTDVEN"})
			nPosLst := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_PRCVEN"})
			nPosDes := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_DESCONT"})
			nPosMer := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_VALOR"})

			MaFisAdd(aCols[nX,nPosPrd],;   	&& 1-Codigo do Produto ( Obrigatorio )
			aCols[nX,nPosTes],;	   	&& 2-Codigo do TES ( Opcional )
			aCols[nX,nPosQtd],;  	&& 3-Quantidade ( Obrigatorio )
			aCols[nX,nPosLst],;		  	&& 4-Preco Unitario ( Obrigatorio )
			aCols[nX,nPosDes],; 	&& 5-Valor do Desconto ( Opcional )
			"",;	   			&& 6-Numero da NF Original ( Devolucao/Benef )
			"",;				&& 7-Serie da NF Original ( Devolucao/Benef )
			0,;					&& 8-RecNo da NF Original no arq SD1/SD2
			0,;					&& 9-Valor do Frete do Item ( Opcional )
			0,;					&& 10-Valor da Despesa do item ( Opcional )
			0,;					&& 11-Valor do Seguro do item ( Opcional )
			0,;					&& 12-Valor do Frete Autonomo ( Opcional )
			aCols[nX,nPosLst] * aCols[nX,nPosQtd] ,;			&& 13-Valor da Mercadoria ( Obrigatorio )
			0)					&& 14-Valor da Embalagem ( Opiconal )

		Next nX

		nValTot1 := MaFisRet(,"NF_TOTAL")

		MaFisSave()
		MaFisEnd()

		MaFisIni(M->C5_CLIENTE,;&& 1-Codigo Cliente/Fornecedor
		M->C5_LOJACLI,;		&& 2-Loja do Cliente/Fornecedor
		"C",;				&& 3-C:Cliente , F:Fornecedor
		"N",;				&& 4-Tipo da NF
		cTipCli,;		&& 5-Tipo do Cliente/Fornecedor
		Nil,;
			Nil,;
			Nil,;
			Nil,;
			"MATA461")

		For nX := 1 To Len(aCols)
			nPosPrd := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_PRODUTO"})
			nPosTes := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_TES"})
			nPosQtd := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_QTDVEN"})
			nPosLst := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_ZZPRCF"})
			nPosDes := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_DESCONT"})
			nPosMer := Ascan(AHeader,{|X| Upper(AllTrim(X[2]))=="C6_VALOR"})

			MaFisAdd(aCols[nX,nPosPrd],;   	&& 1-Codigo do Produto ( Obrigatorio )
			aCols[nX,nPosTes],;	   	&& 2-Codigo do TES ( Opcional )
			aCols[nX,nPosQtd],;  	&& 3-Quantidade ( Obrigatorio )
			aCols[nX,nPosLst],;		  	&& 4-Preco Unitario ( Obrigatorio )
			aCols[nX,nPosDes],; 	&& 5-Valor do Desconto ( Opcional )
			"",;	   			&& 6-Numero da NF Original ( Devolucao/Benef )
			"",;				&& 7-Serie da NF Original ( Devolucao/Benef )
			0,;					&& 8-RecNo da NF Original no arq SD1/SD2
			0,;					&& 9-Valor do Frete do Item ( Opcional )
			0,;					&& 10-Valor da Despesa do item ( Opcional )
			0,;					&& 11-Valor do Seguro do item ( Opcional )
			0,;					&& 12-Valor do Frete Autonomo ( Opcional )
			aCols[nX,nPosLst] * aCols[nX,nPosQtd] ,;			&& 13-Valor da Mercadoria ( Obrigatorio )
			0)					&& 14-Valor da Embalagem ( Opiconal )

		Next nX

		nValTot2 := MaFisRet(1,"IT_VALMERC")

		If Reclock('SC5',.F.)
			SC5->C5_ZZTOTA1 := nValTot1
			SC5->C5_ZZTOTA2 := nValTot2
			MsUnlock()
		EndIf

	EndIf

	If cFilAnt == '0202'
		TWPRDAUT()
	EndIf

	RestArea(_aArSC5)
	RestArea(_aArSC6)

	Return .T.


Static Function TWPRDAUT()
	Local aArea    := GetArea()
	local lRet := .T.
	Local cNumPed  := ''
	Private oObjAC	:= TWAC002():New()
	Private oObjFC:= TWFC002():New()

	oObjFC:cEmpOri := cEmpAnt
	oObjFC:cFilOri := cFilAnt

	lRet := TWPDVPRD()

	If lRet
		oObjAC:cProcessEmp	:= '01'
		oObjAC:cProcessFil	:= '0101'
		oObjAC:changeEmpFil()

		cNumPed := GetSx8Num("SC5","C5_NUM")

		aAdd(oObjFC:aDataCabec,{"C5_NUM"                 ,cNumPed			, Nil})

		oObjFC:TWGRVPDV(.F.)

		oObjAC:cProcessEmp	:= oObjFC:cEmpOri
		oObjAC:cProcessFil	:= oObjFC:cFilOri
		oObjAC:changeEmpFil()
	EndIF
	RestArea(aArea)

	Return lRet

	&& Monta pedido para gerar op dos produtos temperado.
Static Function TWPDVPRD()
	Local lRet := .T.
	Local aArea    := GetArea()
	Local cfilEmp  := POSICIONE('SA1',1,xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI, 'A1_ZZFIL')
	Local cNumPed  := GetSx8Num("SC5","C5_NUM")
	oObjFC:aDataCabec := {}
	oObjFC:cCliente := SC5->C5_CLIENTE
	oObjFC:cLoja :=  SC5->C5_LOJACLI
	oObjFC:cNumPDx := SCJ->CJ_NUM

	aAdd(oObjFC:aDataCabec,{"C5_TIPO"					,SC5->C5_TIPO		, Nil})
	aAdd(oObjFC:aDataCabec,{"C5_CLIENTE"             ,'003916'			, Nil})
	aAdd(oObjFC:aDataCabec,{"C5_LOJACLI"             ,'00'				, Nil})
	aAdd(oObjFC:aDataCabec,{"C5_TIPOCLI"             ,'F'			  	, Nil})
	aAdd(oObjFC:aDataCabec,{"C5_ZZNIVEL"             ,SC5->C5_ZZNIVEL	, Nil})
	aAdd(oObjFC:aDataCabec,{"C5_CONDPAG"             ,SC5->C5_CONDPAG	, Nil})
	aAdd(oObjFC:aDataCabec,{"C5_PRDAUTO"             ,'1'				, Nil})

	ConfirmSX8()

	SCK->(dbSetOrder(2))
	SCK->(dbSeek(xFilial("SC6")+oObjFC:cCliente+oObjFC:cLoja +oObjFC:cNumPDx ))
	oObjFC:aDataItem:= {}
	Do While !SCK->(EOF()) .and. SCK->CK_FILIAL == xFilial("SCK") .and. SCK->(CK_NUM+CK_CLIENTE+CK_LOJA) == ;
			oObjFC:cNumPDx + oObjFC:cCliente + oObjFC:cLoja


		SB1->(DbSetOrder(1))
		ZZ5->(DbSetOrder(2))
		If SB1->(DbSeek(xFilial('SB1') +  SCK->CK_PRODUTO))
			If Alltrim(SB1->B1_GRUPO) != '0003' .Or. Alltrim(SB1->B1_GRUPO) != '0027' .And. cfilEmp = '0202'
				If ZZ5->(Dbseek(xFilial('ZZ5') + SB1->B1_ZZTVIDR))
					If ZZ5->ZZ5_TIPO <> '2'
						lRet := .F.
						Return lRet
					EndIf
				EndIF
			Else
				SCK->(DbSkip())
				Loop
			EndIf
		EndIF

		oObjFC:aMata410i := {}
		AADD(oObjFC:aMata410i,            {"C6_ITEM"		,SCK->CK_ITEM									,NIL})
		AADD(oObjFC:aMata410i,            {"C6_PRODUTO"	,SCK->CK_PRODUTO								,NIL})
		AADD(oObjFC:aMata410i,            {"C6_QTDVEN"	,SCK->CK_QTDVEN								,NIL})
		AADD(oObjFC:aMata410i,            {"C6_QTDLIB"	,0 												,NIL})
		AADD(oObjFC:aMata410i,            {"C6_PRCVEN"   ,SCK->CK_PRCVEN    							,NIL})
		AADD(oObjFC:aMata410i,            {"C6_VALOR"   	,SCK->CK_VALOR								,NIL})
		AADD(oObjFC:aMata410i,            {"C6_TES"		,SCK->CK_TES									,NIL})
		AADD(oObjFC:aMata410i,            {"C6_PRUNIT"   ,SCK->CK_PRUNIT								,NIL})
		AADD(oObjFC:aMata410i,            {"C6_ZZNUMPD"  ,SC5->C5_NUM										,NIL})

		AADD(oObjFC:aDataItem, oObjFC:aMata410i)
		SCK->(DbSkip())
	EndDo

	RestArea(aArea)

	Return lRet
