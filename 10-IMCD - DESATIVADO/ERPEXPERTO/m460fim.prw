#INCLUDE "PROTHEUS.CH"
#INCLUDE "SET.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Marcos J.           º Data ³  11/27/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado no final da geracao da NF. Se existir um item º±±
±±º          ³com a informacao de EMBALAGEM RET. gera uma nova nota de re-º±±
±±º          ³messa da EMBALAGEM.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460FIM()

	Local aAlias    := GetArea()
	Local aAliasSD2 := GetArea("SD2")
	Local aAliasSF2 := GetArea("SF2")
	Local aAliasQEK := GetArea("QEK")

	Local aItens := {}
	Local aItSD2 := {}
	Local aStrut := {}
	Local aLinha := {}
	Local aCabec := {}
	Local aItSC6 := {}
	Local aJaFoi := {}

	Local cNumPed:= ""
	Local cQuery := ""
	Local cTabela:= ""
	Local cFrete := ""
	Local cNat := ""
	Local cDescri:= ""
	Local cVeic1	:= cVeic2	:= cVeic3	:= ""
	Local cMsgPed:= "CONTAINER DE NOSSA PROPRIEDADE QUE SEGUE ACONDICIONANDO O PRODUTO FATURADO ATRAVES DA NF " + SF2->F2_DOC +;
		". ISENTO DE ICMS CONF. ART 8 ANEXO I ART 82 INCISO I DECRETO 45490/00. VALVULA DE POLIPROPILENO. ESTA EMBALAGEM DEVE RETORNAR NO MAXIMO EM 20 DIAS."
	Local nI     := 0
	Local cGrpRem:= Alltrim(SuperGetMV("MV_GRPREM", .T., "0099"))
	Local cTESRem:= Alltrim(SuperGetMV("MV_TESREM", .T., "998"))
	Local cTESCont:= Alltrim(SuperGetMV("MV_TESCONT", .T., ""))
//Private aRet := {}
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private nEstru      := 0

	If SF2->F2_TIPO == "N"  //Somente nota normal

		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE)
		do While SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE

			U_BAIXASC4( SD2->D2_COD, SD2->D2_QUANT,.T.)

			If SD2->D2_TES $ cTESCont .and. Empty(SD2->D2_FLAGCT)       // Verifica se já gerou para aquele item
				RecLock("SD2",.F.)                                                 // Marca item como já gerado
				SD2->D2_FLAGCT := "S"                                              // Para evitar duplicitade de NF de container
				msUnlock()
				If Ascan(aJaFoi, SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_ITEM) == 0
					Aadd(aJaFoi, SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_ITEM)

					SG1->(DbSetOrder(1))
					SB1->(DbSetOrder(1))

					cQuery := "SELECT D2_FILIAL, D2_SERIE, D2_DOC, D2_ITEM, D2_COD, D2_QUANT, D2_PEDIDO, D2_ITEMPV, C6_EMBRET"
					cQuery += " FROM " + RetSqlName("SD2") + " SD2"
					cQuery += " RIGHT JOIN " + RetSqlName("SC6") + " SC6 ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_EMBRET = '1' AND SC6.D_E_L_E_T_ <> '*'"
					cQuery += " WHERE D2_FILIAL = '" + SF2->F2_FILIAL + "'"
					cQuery += "   AND D2_SERIE = '" + SF2->F2_SERIE + "'"
					cQuery += "   AND D2_DOC = '" + SF2->F2_DOC + "'"
					cQuery += "   AND D2_ITEM = '" + SD2->D2_ITEM + "'"
					cQuery += "   AND SD2.D_E_L_E_T_ <> '*'"
					cQuery := ChangeQuery(cQuery)
					DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB1", .F., .F.)

					TRB1->(DbGoTop())
					While TRB1->(!Eof())
						If SG1->(DbSeek(xFilial("SG1") + TRB1->D2_COD, .F.))
							nEstru := 0
							aStrut := Estrut(TRB1->D2_COD, TRB1->D2_QUANT, .T., .F.)
							If !Empty(aStrut)
								For nI := 1 To Len(aStrut)
									SB1->(DbSeek(xFilial("SB1") + aStrut[nI,3], .F.))
									If SB1->B1_GRUPO $ cGrpRem
										If aScan(aItens, TRB1->(D2_PEDIDO + D2_ITEM)) == 0
											aAdd(aItens, {TRB1->(D2_PEDIDO + D2_ITEM), aStrut[nI,3], aStrut[nI,4], cTESRem, TRB1->D2_COD})
										EndIf
									EndIf
								Next nI
							EndIf
						EndIf
						TRB1->(DbSkip())
					EndDo
					TRB1->(DbCloseArea())
				EndIf
			ENDIF

			dbSelectArea("SD2")
			dbSkip()
		Enddo

	Endif

	If !Empty(aItens)
		cNumPed := getNxtPed()
		For nI := 1 To Len(aItens)
			SB1->(DbSeek(xFilial("SB1") + aItens[nI, 2], .F.))  //posiciona no produto

			//Carrega o item a ser faturado
			aLinha  := {}
			cDescri := Alltrim(Posicione("SB1", 1, xFilial("SB1") + aItens[nI, 2], "B1_DESC")) + " CONTENDO " + Alltrim(Posicione("SB5", 1, xFilial("SB5") + aItens[nI, 5]	, "B5_CEME"))

			aAdd(aLinha, { "C6_ITEM"    , StrZero(nI, 2, 0), Nil})
			aAdd(aLinha, { "C6_PRODUTO" , aItens[nI, 2]    , Nil})
			aAdd(aLinha, { "C6_XMOEDA"  , 1                , Nil})
			aAdd(aLinha, { "C6_UM"      , SB1->B1_UM       , Nil})
			aAdd(aLinha, { "C6_QTDVEN"  , aItens[nI, 3]    , Nil})
			aAdd(aLinha, { "C6_PRCVEN"  , SB1->B1_VLRREM   , Nil})
			aAdd(aLinha, { "C6_PRUNIT"  , SB1->B1_VLRREM   , Nil})
			aAdd(aLinha, { "C6_VALOR"   , noRound(aItens[nI, 3] * SB1->B1_VLRREM,2), Nil})
			aAdd(aLinha, { "C6_QTDLIB"  , aItens[nI, 3]    , Nil})
			aAdd(aLinha, { "C6_TES"     , cTESRem          , Nil})
			aAdd(aLinha, { "C6_CLI"     , SF2->F2_CLIENTE  , Nil})
			aAdd(aLinha, { "C6_LOJA"    , SF2->F2_LOJA     , Nil})
			aAdd(aLinha, { "C6_PEDCLI"  , aItens[nI, 1]    , Nil})
			aAdd(aLinha, { "C6_DESCRI"  , cDescri          , Nil})
			aAdd(aItSC6, aLinha )

			cTabela := Posicione("SC5", 1, xFilial("SC5") + SubStr( aItens[nI, 1], 1, 6), "C5_TABELA")
			cFrete  := Posicione("SC5", 1, xFilial("SC5") + SubStr( aItens[nI, 1], 1, 6), "C5_TPFRETE")
			cNat    := Posicione("SC5", 1, xFilial("SC5") + SubStr( aItens[nI, 1], 1, 6), "C5_NATUREZ")
			aAdd(aItSD2, cNumPed + StrZero(nI, 2, 0))
		Next nI

		//Carrega o cabeçalho do pedido
		aAdd(aCabec, { "C5_NUM"      , cNumPed        , Nil})
		aAdd(aCabec, { "C5_TIPO"     , "N"            , Nil})
		aAdd(aCabec, { "C5_CLIENTE"  , SF2->F2_CLIENTE, Nil})
		aAdd(aCabec, { "C5_LOJACLI"  , SF2->F2_LOJA   , Nil})
		aAdd(aCabec, { "C5_CLIENT"   , SF2->F2_CLIENTE, Nil})
		aAdd(aCabec, { "C5_LOJAENT"  , SF2->F2_LOJA   , Nil})
		aAdd(aCabec, { "C5_TIPOCLI"  , SF2->F2_TIPOCLI, Nil})
		//		aAdd(aCabec, { "C5_CONDPAG"  , SF2->F2_COND   , Nil})
		aAdd(aCabec, { "C5_CONDPAG"  , "100"   , Nil})
		aAdd(aCabec, { "C5_EMISSAO"  , SF2->F2_EMISSAO, Nil})
		aAdd(aCabec, { "C5_TRANSP"   , SF2->F2_TRANSP , Nil})
		aAdd(aCabec, { "C5_TPFRETE"  , cFrete         , Nil})
		aAdd(aCabec, { "C5_TABELA"   , cTabela        , Nil})
		aAdd(aCabec, { "C5_MOEDA"    , 1              , Nil})
		aAdd(aCabec, { "C5_MENNOTA"  , cMsgPed        , Nil})
		aAdd(aCabec, { "C5_NATUREZ"  , cNat           , Nil})
		aAdd(aCabec, { "C5_XVENDOR"  , "N"			  , Nil})

		cVeic1	:= SF2->F2_VEICUL1
		cVeic2	:= SF2->F2_VEICUL2
		cVeic3	:= SF2->F2_VEICUL3
		//Efetua a gravação do pedido
		MsExecAuto({|x, y, z| Mata410(x, y, z) }, aCabec, aItSC6, 3)
		If lMsErroAuto
			MostraErro()
		Else
		/*/Efetua a liberação de credito
			DbSelectArea("SC9")
			DbSetOrder(1)
			DbSeek(xFilial("SC9") + cNumPed, .F.)
			While !Eof() .and. SC9->(C9_FILIAL + C9_PEDIDO) == xFilial("SC9") + cNumPed
				A450Grava( 1, .T., .F. )  //mudando de 1 para 2 bloqueia o pedido
				A450Grava( 1, .F., .T. )  //mudando de 1 para 2 bloqueia o pedido
				DbSkip()
			EndDo*/
			cNFOrig := SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL)

			If GERNOTA(SF2->F2_CLIENTE, SF2->F2_LOJA, aItSD2, SF2->F2_DOC, SF2->F2_SERIE,cVeic1,cVeic2,cVeic3)
				If (__lSX8)
					ConfirmSX8()
				EndIf
				//Marcar na NF de origem o numero da NF de remessa de embalagem
				cNFRem := SF2->(F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL)
				If cNFOrig != cNFRem
					SF2->(DbSetOrder(1))
					If SF2->(DbSeek(cNFOrig, .F.))
						SF2->(RecLock("SF2", .F.))
						SF2->F2_NFEMB	:= cNFRem
						SF2->F2_VEICUL1	:= cVeic1
						SF2->F2_VEICUL2	:= cVeic2
						SF2->F2_VEICUL3	:= cVeic3
						SF2->(MsUnLock())
					EndIf
				ELSE
					SF2->(RecLock("SF2", .F.))
					SF2->F2_VEICUL1	:= cVeic1
					SF2->F2_VEICUL2	:= cVeic2
					SF2->F2_VEICUL3	:= cVeic3
					SF2->(MsUnLock())
				EndIf
			Else
				If (__lSX8)
					RollBackSX8()
				EndIf
				Aviso("Erro na geração do pedido " + SC5->C5_NUM, "Problemas na emissao da Nota Fiscal", {"Ok"})
			EndIf
		EndIf
	EndIf

	SD2->(RestArea(aAliasSD2))
	SF2->(RestArea(aAliasSF2))

	RestArea(aAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chama função para impressao certificado de analise  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa({|| U_CertAnalis()},"Verificando Necessidade impressão dos Certificados de Análise")

	QEK->(RestArea(aAliasQEK))
	SD2->(RestArea(aAliasSD2))
	SF2->(RestArea(aAliasSF2))
	RestArea(aAlias)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Marcos J.           º Data ³  11/27/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a geração da nota fiscal de remessa                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GERNOTA( cCodCli, cLoja, aPedido, cNumNF, cSerNF,cVeic1,cVeic2,cVeic3 )

Local aAreaAnt := GetArea()
Local aAreaSC5 := SC5->( GetArea() )
Local aAreaSC6 := SC6->( GetArea() )
Local aAreaSC9 := SC9->( GetArea() )
Local aAreaSE4 := SE4->( GetArea() )
Local aAreaSB1 := SB1->( GetArea() )
Local aAreaSB2 := SB2->( GetArea() )
Local aAreaSF4 := SF4->( GetArea() )

Local aPvlNfs	 	:= {}
Local _nRegDAK   	:= 0
Local lMostraCtb 	:= .F.
Local lAglutCtb  	:= .F.
Local lCtbOnLine 	:= .F.
Local lCtbCusto  	:= .F.
Local lReajuste  	:= .F.
Local lAtuSA7    	:= .F.
Local lECF       	:= .F.
Local nCalAcrs   	:= 1
Local nArredPrcLis 	:= 1
Local nI            := 0
Local cFiltroSC9    := SC9->(DbFilter())
Local _cNota        := Space(1)

// PREPARANDO A NOTA FISCAL
MV_PAR01 := 2           // Mostra Lan‡.Contab ?  Sim/Nao
MV_PAR02 := 2           // Aglut. Lan‡amentos ?  Sim/Nao
MV_PAR03 := 2           // Lan‡.Contab.On-Line?  Sim/Nao
MV_PAR04 := 2           // Contb.Custo On-Line?  Sim/Nao
MV_PAR05 := 2           // Reaj. na mesma N.F.?  Sim/Nao
MV_PAR06 := 0           // Taxa deflacao ICMS ?  Numerico
MV_PAR07 := 3           // Metodo calc.acr.fin?  Taxa defl/Dif.lista/% Acrs.ped
MV_PAR08 := 3           // Arred.prc unit vist?  Sempre/Nunca/Consumid.final
MV_PAR09 := Space( 04 ) // Agreg. liberac. de ?  Caracter
MV_PAR10 := Space( 04 ) // Agreg. liberac. ate?  Caracter
MV_PAR11 := 2           // Aglut.Ped. Iguais  ?  Sim/Nao
MV_PAR12 := 0           // Valor Minimo p/fatu?
MV_PAR13 := Space( 06 ) // Transportadora de  ?
MV_PAR14 := 'ZZZZZZ'    // Transportadora ate ?
MV_PAR15 := 2           // Atualiza Cli.X Prod?  Sim/Nao
MV_PAR16 := 1           // Emitir             ?  Nota/Cupom Fiscal

lMostraCtb  := MV_PAR01 == 1
lAglutCtb   := MV_PAR02 == 1
lCtbOnLine  := MV_PAR03 == 1
lCtbCusto   := MV_PAR04 == 1
lReajuste   := MV_PAR05 == 1

LAtuSA7lECF := .F.

// Gera nota.
SC9->(DbClearFilter())
SC5->(DBSetOrder(3))
For nI := 1 To Len(aPedido)
	If SC5->(DbSeek(xFilial('SC5') + cCodCli + cLoja + SubStr(aPedido[nI], 1, 6)))
		SC6->(DBSetOrder(1))
		SC6->(DbSeek(xFilial('SC6') + aPedido[nI]))
		
		SC9->(DbSetOrder(2))
		SC9->(DbGoTop())
		If SC9->(DbSeek(xFilial('SC9') + cCodCli + cLoja + aPedido[nI], .F.))
			// Posiciona na condicao de pagamento
			SE4->(DbSetOrder(1))
			SE4->(DbSeek(xFilial('SE4') + "100"))
			
			// Posiciona no produto
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial('SB1') + SC6->C6_PRODUTO))
			
			// Posiciona no saldo em estoque
			SB2->(DbSetOrder(1))
			SB2->(DbSeek(xFilial('SB2') + SC6->(C6_PRODUTO + C6_LOCAL)))
			
			// Posiciona no TES
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial('SF4') + SC6->C6_TES))
			
			// Monta array para gerar a nota fiscal
			aAdd(aPvlNfs,{SC9->C9_PEDIDO , ;
			SC9->C9_ITEM   , ;
			SC9->C9_SEQUEN , ;
			SC9->C9_QTDLIB , ;
			SC9->C9_PRCVEN , ;
			SC9->C9_PRODUTO, ;
			.F.            , ;
			SC9->(RecNo()) , ;
			SC5->(RecNo()) , ;
			SC6->(RecNo()) , ;
			SE4->(RecNo()) , ;
			SB1->(RecNo()) , ;
			SB2->(RecNo()) , ;
			SF4->(RecNo()) , ;
			SC6->C6_LOCAL  , ;
			_nRegDAK       , ;
			SC9->C9_QTDLIB2})
		EndIf
	EndIf
Next

If !Empty(aPvlNfs)
	SX5->(DbSetOrder(1))
	SX5->(DbSeek(xFilial("SX5") + "01" + cSerNF, .F.))
	
	LimpaMoeda()
	
	_cNota := MaPvlNfs(	aPvlNfs,;
	cSerNF,;
	lMostraCtb,;
	lAglutCtb,;
	lCtbOnLine,;
	lCtbCusto,;
	lReajuste,;
	nCalAcrs,;
	nArredPrcLis,;
	lAtuSA7,;
	lECF,;
	'',, )
	SF2->(RecLock("SF2", .F.))
	SF2->F2_VEICUL1	:= cVeic1
	SF2->F2_VEICUL2	:= cVeic2
	SF2->F2_VEICUL3	:= cVeic3
	SF2->(MsUnLock())
EndIf
// Retorna as areas originais
SC9->(MsFilter(cFiltroSC9))
RestArea( aAreaSF4 )
RestArea( aAreaSB2 )
RestArea( aAreaSB1 )
RestArea( aAreaSE4 )
RestArea( aAreaSC9 )
RestArea( aAreaSC6 )
RestArea( aAreaSC5 )
RestArea( aAreaAnt )

Return(Iif(Empty(_cNota), .F., .T. ))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CertAnalisº Autor ³Richard N. Cabral   º Data ³  04/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Chama funcao para emissao dos certificados de analise      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CertAnalis(lRetValid)

	Local aRet	:= {}				//Acrescentado em 09/01/2014, analista Marcus Barros (Totvs), para comtemplar as variaveis Private criadas no inicio

	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	Do While SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) .And. ! SD2->(Eof())

		If Empty(SD2->D2_LOTECTL)
			SD2->(DbSkip())
			Loop
		Endif

		procAnalise(@aRet)


		SD2->(DbSkip())

	EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaSD3  ºAutor  ³Richard Nahas Cabralº Data ³  21/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca as movimentacoes no SD3 para descobrir qual lote houveº±±
±±º          ³a entrada e a inspecao de entrada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaSD3(cCod, cLote, aLotes)

	Local cQuery
	Local cAliasCodLote	:= GetNextAlias()
	Local cAliasDocSeq	:= GetNextAlias()

	cQuery := ""
	cQuery += " SELECT * FROM " + RetSqlName("SD3") + " SD3 "
	cQuery += " WHERE D3_FILIAL = '" + xFilial("SD3") + "' "
	cQuery += " AND (D3_COD = '" + cCod + "' ) "
	cQuery += " AND D3_LOTECTL = '" + cLote + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasCodLote,.T.,.F.)

	(cAliasCodLote)->(DbGotop())

	Do While ! (cAliasCodLote)->(Eof())

		cQuery := ""
		cQuery += " SELECT * FROM " + RetSqlName("SD3") + " SD3 "
		cQuery += " WHERE D3_FILIAL = '" + xFilial("SD3") + "' "
		cQuery += " AND D3_DOC = '" + (cAliasCodLote)->D3_DOC + "' "
		cQuery += " AND D3_NUMSEQ = '" + (cAliasCodLote)->D3_NUMSEQ + "' "
		cQuery += " AND D3_LOTECTL <> ' ' "
		cQuery += " AND D_E_L_E_T_ = ' ' "

		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasDocSeq, .F., .F.)

		(cAliasDocSeq)->(DbGotop())

		Do While ! (cAliasDocSeq)->(Eof())

			If Empty(Ascan(aLotes,{|x| x[1] = (cAliasDocSeq)->D3_COD .And. x[2] = (cAliasDocSeq)->D3_LOTECTL}))
				XDATA:=CTOD(SUBSTR((CALIASDOCSEQ)->D3_EMISSAO,7,2)+"/"+SUBSTR((CALIASDOCSEQ)->D3_EMISSAO,5,2)+"/"+SUBSTR((CALIASDOCSEQ)->D3_EMISSAO,1,4))   // Limitador de tamanho da query recursiva
				If SF2->F2_EMISSAO - XDATA < 120                                                                                                            // estava dando erro: Too Many Cursors
					Aadd(aLotes,{(cAliasDocSeq)->D3_COD, (cAliasDocSeq)->D3_LOTECTL})
					BuscaSD3((cAliasDocSeq)->D3_COD, (cAliasDocSeq)->D3_LOTECTL, @aLotes)
				Endif
			Endif

			(cAliasDocSeq)->(DbSkip())

		EndDo

		(cAliasDocSeq)->(DbCloseArea())
		Ferase(cAliasDocSeq)

		(cAliasCodLote)->(DbSkip())

	EndDo

	(cAliasCodLote)->(DbCloseArea())
	Ferase(cAliasCodLote)

Return

User Function GravaZAO(cDoc,cSerie,cCliente,cLoja,cEst,dEmissao,nValor,nValfre,cTransp,cFrete)
	cPerg:= "GRVZAO"

	DEFAULT cDoc := ""

	If Empty(cDoc)
		If Pergunte(cperg,.T.)
			SF2->(DbSetOrder(4))
			SF2->(DbSeek(xFilial("SF2")+"1  "+DTOS(MV_PAR01)))
			While SF2->(!Eof()) .AND. SF2->(F2_FILIAL+F2_SERIE+F2_EMISSAO)==xFilial("SF2")+"1  "+DTOS(MV_PAR01)
				If ZAO->(!DbSeek(xFilial("ZAO")+SF2->F2_DOC+SF2->F2_SERIE))
					Reclock("ZAO",.T.)
					ZAO->ZAO_FILIAL	:= xFilial("ZAO")
					ZAO->ZAO_DOC	:= SF2->F2_DOC
					ZAO->ZAO_SERIE	:= SF2->F2_SERIE
					ZAO->ZAO_CLIENT	:= SF2->F2_CLIENTE
					ZAO->ZAO_LOJA	:= SF2->F2_LOJA
					ZAO->ZAO_EST	:= cEST
					ZAO->ZAO_EMISSA	:= dEmissao
					ZAO->ZAO_VALOR	:= nValor
					ZAO->ZAO_TRANSP	:= cTransp
					ZAO->ZAO_TPFRETE:= cFrete
					ZAO->ZAO_VALFRE	:= nValfre
					ZAO->(MsUnLock())
				EndIf
				SF2->(DbSkip())
			End
		EndIf
	Else

		Reclock("ZAO",.T.)
		ZAO->ZAO_FILIAL:= xFilial("ZAO")
		ZAO->ZAO_DOC:= cDoc
		ZAO->ZAO_CLIENT:= cCliente
		ZAO->ZAO_LOJA:= cLoja
		ZAO->ZAO_EST:= cEST
		ZAO->ZAO_EMISSA:= dEmissao
		ZAO->ZAO_VALOR:= nValor
		ZAO->ZAO_TRANSP:= cTransp
		ZAO->ZAO_TPFRETE:= cFrete
		ZAO->ZAO_VALFRE:= nValfre
		ZAO->(MsUnLock())
	EndIf

//inicio tratamento de gravação de Validade do lote na SD2

	CQUERY := " SELECT D2_FILIAL, D2_PEDIDO, D2_COD,B8_LOTECTL, SB8010.B8_DTVALID FROM SD2010 SD2  "
	CQUERY += " INNER JOIN SB8010 ON D2_FILIAL = B8_FILIAL AND D2_COD = B8_PRODUTO AND D2_LOTECTL = SB8010.B8_LOTECTL  "
	CQUERY += "	WHERE D2_DOC = '"+SF2->F2_DOC+"' AND D2_SERIE =  '"+SF2->F2_SERIE+"' AND D2_FILIAL =  '"+SF2->F2_FILIAL+"'    "
	CQUERY += "	and SB8010.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND D2_LOCAL = B8_LOCAL  "
	CQUERY += " GROUP BY D2_FILIAL, D2_PEDIDO, D2_COD, B8_LOTECTL, SB8010.B8_DTVALID   "
	TCQUERY CQUERY NEW ALIAS TRB2

	dbselectarea("TRB2")
	dbgotop()
	do while !eof()

		dbselectarea("SD2")
		dbsetorder(3)
		dbgotop()
		dbseek(xfilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2LOJA + TRB2->D2_COD)
		while !EOF() .and. SD2->D2_COD = TRB2->D2_COD .and. SD2->D2_LOTECTL = TRB2->B8_LOTECTL

			RECLOCK("SD2",.F.)
			SD2->D2_DTVALID := TRB->B8_DTVALID
			MSUNLOCK()

			dbskip()
			dbselectarea("SD2")
			dbsetorder(3)
			dbgotop()
			dbseek(xfilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2LOJA + TRB2->D2_COD)
		end

		dbskip()
	enddo

	TRB2->(dbclosearea())
//fim gravação de validade do lote

Return

/*/{Protheus.doc} procAnalise
Realiza o processamento do certificado de análise
ou retorna a data de validade/fabricação do produto
granel (parâmetro lRetValid)
@type function
@version 
@author marcio.katsumata
@since 29/05/2020
@param aRet, array, array de retorno dos lotes
@param lRetValid, logical, retorna apenas a data de validade/fabricação do produto granel?
@return array, retorno da data fabricação/validade do produto granel
/*/
static function procAnalise(aRet, lRetValid)
	local aLotes as array
	local cQuery as character
	local nMaxQ  as numeric
	local nX     as numeric
	local nRegTRB as numeric
	local aRetValid as array

	default lRetValid := .F.
	default aRet      := {}

	nMaxQ := 230
	aLotes := {}
	aRetValid := {}
	Aadd(aLotes,{SD2->D2_COD, SD2->D2_LOTECTL})
	//	BuscaSD3(SD2->D2_COD, SD2->D2_LOTECTL, @aLotes)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Prioridades                                    ³
	//³1- Verifica direto no QEK                      ³
	//³2- Proprio Produto e Lote                      ³
	//³3- Produtos do Grupo e Lote                    ³
	//³4- Pesquisa Transferencias de Lote             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := ""
	cQuery += " SELECT QEK_PRODUT AS D1_COD, QEK_FORNEC AS D1_FORNECE, QEK_LOJFOR AS D1_LOJA, QEK_NTFISC AS D1_DOC, QEK_SERINF AS D1_SERIE, QEK_ITEMNF AS D1_ITEM, QEK_TIPONF AS D1_TIPO, QEK_DTNFIS AS D1_EMISSAO, QEK_LOTE AS D1_LOTECTL, '1' AS PRIORI FROM " + RetSqlName("QEK") + " QEK "
	cQuery += " WHERE QEK_PRODUT = '" + SD2->D2_COD + "' "
	cQuery += " AND QEK_LOTE = '" + SD2->D2_LOTECTL + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION ALL "
	cQuery += " SELECT D1_COD,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_TIPO,D1_EMISSAO, D1_LOTECTL, '2' AS PRIORI FROM " + RetSqlName("SD1") + " SD1 "
	cQuery += " WHERE D1_COD = '" + SD2->D2_COD + "' "
	cQuery += " AND D1_LOTECTL = '" + SD2->D2_LOTECTL + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION ALL "
	cQuery += " SELECT D1_COD,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_TIPO,D1_EMISSAO, D1_LOTECTL, '3' AS PRIORI FROM " + RetSqlName("SD1") + " SD1 "
	cQuery += " LEFT OUTER JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += " ON B1_COD = D1_COD "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE B1_GRUPO = '" + SD2->D2_GRUPO + "' "
	cQuery += " AND D1_LOTECTL = '" + SD2->D2_LOTECTL + "' "
	//cQuery += " AND B1_DESC LIKE '%GRANEL%' "
	cQuery += " AND SD1.D_E_L_E_T_ = ' ' "
	If Len(aLotes) > 1		// O 1o Lote eh o proprio do doc. saida. so entra aqui se houver outros.
		cQuery += " UNION ALL "
		cQuery += " SELECT D1_COD,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE,D1_ITEM,D1_TIPO,D1_EMISSAO, D1_LOTECTL, '4' AS PRIORI  FROM " + RetSqlName("SD1") + " SD1 "
		//		cQuery += " LEFT OUTER JOIN " + RetSqlName("SB1") + " SB1 "
		//		cQuery += " ON B1_COD = D1_COD "
		//		cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE ( "
		If Len(aLotes) < nMaxQ
			nMaxQ := Len(aLotes)
		Endif
		For nX := 1 to nMaxQ
			cQuery += " (D1_LOTECTL = '"+aLotes[nX,2]+"' AND D1_COD = '"+aLotes[nX,1]+"')"+If(nX < nMaxQ," OR "," ")
		Next nX
		cQuery += " ) AND SD1.D_E_L_E_T_ = ' '  "
	EndIf
	cQuery += " ORDER BY PRIORI, D1_EMISSAO DESC "
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .F., .F.)

	Count to nRegTRB

	TRB->(DbGoTop())

	Do While ! TRB->(Eof())
		dbSelectArea("QEK")
		dbSetOrder(11)
		If dbSeek(xFilial("QEK")+TRB->D1_FORNECE+TRB->D1_LOJA+TRB->D1_DOC+TRB->D1_SERIE+TRB->D1_ITEM+TRB->D1_TIPO+TRB->D1_LOTECTL)
			nScan := aScan(aRet,{|x| alltrim(x[1]) == alltrim(TRB->D1_LOTECTL) .AND. alltrim(x[2]) == alltrim(SD2->D2_COD)})
			If ! Empty(QEK->QEK_CERQUA) .AND. nScan = 0
				AADD(aRet,{alltrim(TRB->D1_LOTECTL),alltrim(SD2->D2_COD)})

				if lRetValid
					aRetValid := getValidQEK()
				else
					U_RQUA002({TRB->D1_FORNECE,TRB->D1_LOJA,TRB->D1_DOC,TRB->D1_SERIE,TRB->D1_ITEM,TRB->D1_TIPO,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_LOTECTL,SD2->D2_COD})
				endif

				Exit
			EndIf
		EndIf

		TRB->(DbSkip())
	Enddo

	TRB->(DbCloseArea())

	aSize(aLotes,0)

return aRetValid

/*/{Protheus.doc} getValidQEK
Retorna a data de validade e fabricação do lote 
original, produto a granel.
@type function
@version 1.0
@author marcio.katsumata
@since 29/05/2020
@return array, data de fabricação e validade 
/*/
static function getValidQEK()

	local dDtValB8 as date
	local dDtFabB8 as date
	local aAreaSB8 as array
	local aRetValid as array

	aRetValid := {}
	aAreaSB8 := SB8->(getArea())

	dbSelectArea("SB8")
	SB8->(DbSetOrder(5))
	SB8->(DbSeek(xFilial("SB8")+QEK->QEK_PRODUT+SUBSTR(QEK->QEK_LOTE,1,18)))

	Do While SB8->(B8_FILIAL + B8_PRODUTO + B8_LOTECTL) = xFilial("SB8")+QEK->QEK_PRODUT+SUBSTR(QEK->QEK_LOTE,1,18) .And. ! SB8->(Eof())
		If !empty( SB8->B8_DFABRIC) .And. ! Empty(SB8->B8_DTVALID)
			dDtFabB8 := SB8->B8_DFABRIC
			dDtValB8 := SB8->B8_DTVALID
			aRetValid := {dDtFabB8, dDtValB8}
		EndIf
		If SB8->B8_LOCAL = "01" .And. ! Empty(dDtFabB8) .And. ! Empty(dDtValB8)
			Exit
		Endif
		SB8->(DbSkip())
	EndDo


	restArea(aAreaSB8)
	aSize(aAreaSB8,0)

return aRetValid

/*/{Protheus.doc} getNxtPed
Numeração da SC5
@type function
@version 1.0
@author marcio.katsumata
@since 09/07/2020
@return character, numero do pedido
/*/
static function getNxtPed()

	local cNumPed as character
	local aAreaSC5 as array

	aAreaSC5 := SC5->(getArea())

	cNumPed := GETSXENUM("SC5","C5_NUM")

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))

	while SC5->(DbSeek(xFilial("SC5")+padr(cNumPed, tamSx3("C5_NUM")[1])))
		cNumPed := GETSXENUM("SC5","C5_NUM")
		confirmSx8()
	enddo

	restArea(aAreaSC5)
	aSize(aAreaSC5,0)
return cNumPed
