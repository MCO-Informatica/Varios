#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ICALCPRC  � Autor � junior Carvalho    � Data �  29/09/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � funcao traz o preco unitario do produto na moeda, da tabela���
���          � de precos, qdo usuario digita qtde no orcamento ou pedido  ���
���          � FONTE ICMS - BASEADO NO MATXFIS - MaAliqIcms               ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI  - orcamento e faturamento               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ICALCPRC(cAlias,cSeq)

	Local nPMoeda	:= 0
	Local nPreco	:= 0
	Local nPUm		:= 0
	Local cOrigem	:= ""
	Local cTabela	:= ""
	Local nAliqImp 	:= 0
	Local nCusto	:= 0
	Local nVlrInf	:= 0
	Local dDataOrc := dDataBase
	Local aArea:= GetArea()
	Local xRet
	Local nAliqICMS := 0
	Local nAliqPCC := 0

	Private cMsgCst := 'N�o h� custo para fazer o comparativo, Atualize a Tabela de Pre�os'
	Default cSeq := '000'

	if cAlias == "SCK"

		if isInCallStack("U_IMPQUOTE")
			M->CJ_CLIENTE := cCliQuote
			M->CJ_LOJA    := cLojQuote
		endif

		cProd		:=	TMP1->CK_PRODUTO
		nQtd		:=	TMP1->CK_QTDVEN
		nPMoeda		:=	TMP1->CK_XMOEDA
		nPPreco		:=	TMP1->CK_PRCVEN
		nPUm		:=	TMP1->CK_UM
		nPrcTab		:=	TMP1->CK_XPRTABR
		nAliqImp	:=	TMP1->CK_XICMEST + TMP1->CK_XPISCOF
		nTaxa		:=	TMP1->CK_XTAXA
		nVlrInf		:=	TMP1->CK_XVLRINF
		nCusto		:=	TMP1->CK_XCUSTO
		cTabela 	:= 	M->CJ_TABELA
		cCliente 	:=	M->CJ_CLIENTE
		cLoja 		:=	M->CJ_LOJA
		dDataOrc	:=  M->CJ_EMISSAO
		cTipoCli	:=	M->CJ_TIPOCLI

		SA1->( dbSetOrder( 1 ) )
		SA1->( dbSeek( xFilial( "SA1" )+cCliente+cLoja) )

		IF cSeq = '001' // CK_XICMEST
			//ALERT("SEQUENCIA CK_XICMEST "+cSeq )
			nAliqIcms := 0
			if !(SA1->A1_EST =='EX')

				IF SM0->M0_ESTCOB == SA1->A1_EST
					nAliqIcms := SuperGetMV("MV_ICMPAD")
				Else
					If ( SA1->A1_EST $ SuperGetMV("MV_NORTE") )
						nAliqIcms := 7
					Else
						nAliqIcms := 12
					Endif
				Endif

				cOrigem:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_ORIGEM")

				If cOrigem $ "1|2|3|8" .and. SA1->A1_EST <> SuperGetMV("MV_ESTADO")
					If nAliqIcms <> SuperGetMV("MV_ICMPAD")
						nAliqIcms	:= 4
					elseif cfilant == '06'
						nAliqIcms	:= 4
					Endif
				Endif
			ENDIF

			TMP1->CK_IPI := SB1->B1_IPI

			aRet := {}

			aRet := TESTEIMP(cCliente, cLoja, cTipoCli,TMP1->CK_ITEM , cProd,TMP1->CK_TES,;
				TMP1->CK_QTDVEN,TMP1->CK_PRCVEN,TMP1->CK_XICMEST,TMP1->CK_XPISCOF,.F.)

			xRet := aRet[1]

		ELSEif cSeq = '002' // CK_XPRTABR   - VALOR TABELA EM REAIS

			xRet	:=  a415Tabela(cProd,cTabela,nQtd)

		ELSEif cSeq = '003' // CK_XPRTABO
			xRet := U_BSCMARG(cTabela,cProd,nQtd,1)

		ELSEif cSeq = '004' // CK_XPRUNIT

			xRet := MaTabPrVen(cTabela,cProd,nQtd,cCliente, cLoja, nPMoeda ,dDataBase)

		ELSEif cSeq = '005' //CK_PRCVEN

			nPreco := MaTabPrVen(cTabela,cProd,nQtd,cCliente, cLoja, nPMoeda ,dDataBase)
			IF nPreco <= 0 .and. !EMPTY(cTabela) .AND. ( SUBSTR(CPROD,1,2) $ 'MR|PA')
				ALERT("Produto "+cProd+" n�o encontradado na Tabela "+cTabela+"."+CRLF+"Solicitar Inclus�o" )
			ENDIF

			If nVlrInf > 0
				nPreco :=  nVlrInf
			Endif

			IF(nAliqIMP > 0)
				nAliqIMP := ( nAliqImp / 100 )
			Endif
			nPreco := Round( (nPreco / (1- nAliqImp) ) * nTaxa, TamSx3("CK_PRCVEN")[2] )

			TMP1->CK_VALOR := Round( nQtd * nPreco , TamSx3("CK_VALOR")[2] )

			xRet := (nPreco)
		/*
		ELSEif cSeq = '006' // CK_XMEDIO
			xCampo := 'M2_MOEDA' + ALLTRIM(str(nPMoeda,1) )
			cRet := iif(nTaxa <> SM2->(&xCampo) ,"S" ,"N")
			xRet := cRet
		*/
		ELSEif cSeq = '007' // CK_XCUSTO
			if nQtd > 0
				xRet := U_BSCMARG(cTabela,cProd,nQtd,2)
			else
				ALERT("Para o Calculo correto, digite primeiro a quantidade!" )
				xRet := 0
			Endif

		ELSEif cSeq = '008' // CK_XVRMARG
			xRet := 0
			nTaxa := IIF(nTaxa > 0, nTaxa, 1)
			IF nCusto > 0
				nPrcVen := ROUND( nPPreco * ((100-nAliqIMP)/100) ,2 )
				nPrcCust := ROUND( nCusto  * nTaxa,2 )
				nLucro := ROUND(((nPrcVen - nPrcCust) / nPrcVen)*100,0)

				TMP1->CK_XPRMARG := nLucro

				TMP1->CK_XOBSMAR := IIF(nLucro >= TMP1->CK_XPRTABO,"Lucro maior ou igual em ","Lucro menor em " );
					+ alltrim(TransForm(nLucro,PesqPict("SCK","CK_VALOR")))+"%."

			Else
				TMP1->CK_XOBSMAR := cMsgCst
				TMP1->CK_XPRMARG := 0
				nPrcVen := 0
				nPrcCust:= 0
			Endif

			xRet := ROUND( (nPrcVen - nPrcCust) ,2) * nQtd

		ELSEif cSeq = '009' // CK_XPISCOF
			//IIF(n>1,aCols[n-1,GdFieldPos("CK_XPISCOF",aHeader)],IIF(EMPTY(SA1->A1_SUFRAMA),9.25,0))
			xRet := 9.25

			nPis:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_PPIS")
			nCof:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_PCOFINS")
			nMVPis := iif(nPis == 0,SuperGetMV("MV_TXPIS"),nPis)
			nMVCof := iif(nCof == 0,SuperGetMV("MV_TXCOFIN"),nCof)


			IF cEmpAnt == '02'
				xRet := nPis + nCof
			/*ELSEIF cEmpAnt == '04'
				nPis := iif(nPis == 0, nMVPis ,nPis)
				nCof := iif(nCof == 0, nMVCof ,nCof)
				xRet := nPis + nCof
			*/
			ELSEIF  cEmpAnt == '01'
				aRet := {}

				aRet := TESTEIMP(cCliente, cLoja, cTipoCli,TMP1->CK_ITEM , cProd,TMP1->CK_TES,;
					TMP1->CK_QTDVEN,TMP1->CK_PRCVEN,TMP1->CK_XICMEST,TMP1->CK_XPISCOF,.F.)
				xRet := aRet[2]

			ENDIF

		ENDIF

	ELSEIF cAlias == "SC6"

		cProd		:= GDFieldGet("C6_PRODUTO",N)
		nQtd		:= GDFieldGet("C6_QTDVEN",N)
		nPMoeda		:= GDFieldGet("C6_XMOEDA",N)
		nPPreco		:= GDFieldGet("C6_PRCVEN",N)
		nPUm		:= GDFieldGet("C6_UM",N)
		nPrcTab		:= GDFieldGet("C6_XPRTAB",N)
		nAliqICMS	:= GDFieldGet("C6_XICMEST",N)
		nAliqPCC	:= GDFieldGet("C6_XPISCOF",N)
		nTaxa		:= GDFieldGet("C6_XTAXA",N)
		nVlrInf		:= GDFieldGet("C6_XVLRINF",N)
		cTes		:= GDFieldGet("C6_TES",N)

		cTabela		:= M->C5_TABELA
		cCliente 	:= M->C5_CLIENTE
		cLoja 		:= M->C5_LOJACLI
		cTipoCli	:= M->C5_TIPOCLI
		nAliqIMP 	:= nAliqICMS + nAliqPCC

		IF cSeq = '001' // XICMEST
			//ALERT("SEQUENCIA XICMEST "+cSeq )
			nAliqIcms := 0
			SA1->( dbSetOrder( 1 ) )
			SA1->( dbSeek( xFilial( "SA1" )+cCliente+cLoja) )
			if !(SA1->A1_EST =='EX')
				IF SM0->M0_ESTCOB == SA1->A1_EST
					nAliqIcms := SuperGetMV("MV_ICMPAD")
				Else
					If ( SA1->A1_EST $ SuperGetMV("MV_NORTE") )
						nAliqIcms := 7
					Else
						nAliqIcms := 12
					Endif
				Endif

				cOrigem:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_ORIGEM")

				If cOrigem $ "1|2|3|8" .and. SA1->A1_EST <> SuperGetMV("MV_ESTADO")
					If nAliqIcms <> SuperGetMV("MV_ICMPAD")
						nAliqIcms	:= 4
					elseif cfilant == '06'
						nAliqIcms	:= 4
					Endif
				Endif
			Endif

			//xRet := (nAliqIcms)
			aRet := TESTEIMP(cCliente, cLoja, cTipoCli,N , cProd,cTes, nQtd,nPPreco, nAliqICMS, nAliqPCC,.F.)

			xRet := aRet[1]
			
		ELSEif cSeq = '002' // C6_XPRTABR   - VALOR TABELA EM REAIS
			nPPreco	:=  A410Tabela(cProd,cTabela,N,nQtd)
			xRet := (nPPreco)

		ELSEif cSeq = '003' // C6_XPRTABO
			xRet := U_BSCMARG(cTabela,cProd,nQtd,1)

		ELSEif cSeq = '004' // C6_XPRUNIT

			nPreco := MaTabPrVen(cTabela,cProd,nQtd,cCliente, cLoja, nPMoeda ,dDataBase)
			xRet := (nPreco)

		ELSEif cSeq = '005' //C6_PRCVEN

			nPreco := MaTabPrVen(cTabela,cProd,nQtd,cCliente, cLoja, nPMoeda ,dDataBase)
			IF nPreco <= 0 .and. !EMPTY(cTabela) .AND. ( SUBSTR(CPROD,1,2) $ 'MR|PA')
				ALERT("Produto "+cProd+" n�o encontradado na Tabela "+cTabela+"."+CRLF+"Solicitar Inclus�o" )
			ENDIF

			If nVlrInf > 0
				nPreco :=  nVlrInf
			Endif

			IF(nAliqIMP > 0)
				nAliqIMP := ( nAliqImp / 100 )
			Endif
			nPreco := Round( (nPreco / (1- nAliqImp)) * nTaxa, TamSx3("C6_PRCVEN")[2] )
			GDFieldPut ( "C6_VALOR",Round(nQtd * nPreco, TamSx3("C6_VALOR")[2] ) , N)
			xRet := (nPreco)

		/*ELSEif cSeq = '006' // C6_XMEDIO
			xCampo := 'M2_MOEDA' + ALLTRIM(str(nPMoeda,1) )
			cRet := iif(nTaxa <> SM2->(&xCampo) ,"S" ,"N")
			xRet := (cRet) */
		ELSEif cSeq = '007' // C6_XCUSTO N�O FOI CRIADO // CRIADO 11/02/2018.
			xRet := U_BSCMARG(cTabela,cProd,nQtd,2)

		ELSEif cSeq = '008' // C6_XVRMARG
			xRet := 0
			nPRTABO	:= GDFieldGet("C6_XPRTABO",N)
			nTaxa 	:= IIF(nTaxa > 0, nTaxa, 1)
			nCusto	:= U_BSCMARG(cTabela,cProd,nQtd,2)

			IF nCusto > 0
				nPrcVen := ROUND( nPPreco * ((100-nAliqIMP)/100) ,2 )
				nPrcCust := ROUND( nCusto  * nTaxa,2 )
				nLucro := ROUND(((nPrcVen - nPrcCust) / nPrcVen)*100,0)

				cMsgCst := IIF(nLucro >= nPRTABO ,"Lucro maior ou igual em ","Lucro menor em " );
					+ alltrim(TransForm(nLucro,PesqPict("SC6","C6_VALOR")))+"%."

				GdFieldPut("C6_XPRMARG",nLucro,N)
				GdFieldPut("C6_XOBSMAR",cMsgCst,N)
				xRet := ROUND( (nPrcVen - nPrcCust) ,2) * nQtd //luiz
			Else
				GdFieldPut("C6_XPRMARG",0,N)
				GdFieldPut("C6_XOBSMAR",cMsgCst,N)
			Endif

			//xRet := ROUND( (nPrcVen - nPrcCust) ,2) * nQtd
		ELSEif cSeq = '009' // C6_XPISCOF
			//IIF(n>1,aCols[n-1,GdFieldPos("C6_XPISCOF",aHeader)],IIF(EMPTY(SA1->A1_SUFRAMA),9.25,0))
			xRet := 9.25

			nPis:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_PPIS")
			nCof:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_PCOFINS")
			nMVPis := iif(nPis == 0,SuperGetMV("MV_TXPIS"),nPis)
			nMVCof := iif(nCof == 0,SuperGetMV("MV_TXCOFIN"),nCof)

			IF cEmpAnt == '02'
					xRet := nPis + nCof
				/*
					ELSEIF cEmpAnt == '04'
						nPis := iif(nPis == 0, nMVPis ,nPis)
						nCof := iif(nCof == 0, nMVCof ,nCof)
						xRet := nPis + nCof
					*/
			ELSEIF  cEmpAnt == '01'
				aRet := {}
				aRet := TESTEIMP(cCliente, cLoja, cTipoCli,N , cProd,cTes, nQtd,nPPreco, nAliqICMS, nAliqPCC,.F.)
				xRet := aRet[2]
			ENDIF

			IF !(EMPTY(SA1->A1_SUFRAMA))
				xRet := 0
			ENDIF

		IF SB1->B1_TIPO == 'MA'
			xRet := 0
		ENDIF

	ENDIF
ENDIF

RestArea(aArea)

Return xRet

USER Function BSCMARG(cTabPreco,cProduto,nQtde,nTipo)
	Local xRet := 0
	Local aAreaDA1 := DA1->(GetArea())
	Local cAliasDA1:= ""

	if !Empty(cTabPreco)

		cAliasDA1:= GetNextAlias()

		cQuery := "SELECT DA1_MMIN, DA1_CUSTD, DA1_PRCVEN, DA1_MIDEAL, DA1_MOEDA "
		cQuery += "FROM "+RetSqlName("DA1")+ " DA1 "
		cQuery += "WHERE "
		cQuery += "DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND "
		cQuery += "DA1.DA1_CODTAB = '"+cTabPreco+"' AND "
		cQuery += "DA1.DA1_CODPRO = '"+cProduto+"' AND "
		cQuery += "DA1.DA1_QTDLOT >= "+Str(nQtde,15,6)+" AND "
		cQuery += "DA1.DA1_ATIVO = '1' AND  "
		cQuery += "DA1.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY DA1_QTDLOT "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDA1,.T.,.T.)

		if Select(cAliasDA1) > 0  .and. (cAliasDA1)->(!eof())
			if nTipo == 1 // Margem de Lucro
				xRet := (cAliasDA1)->DA1_MMIN
			elseIF nTipo == 2 // Valor do Custo
				xRet := (cAliasDA1)->DA1_CUSTD
			elseif nTipo == 3
				xRet := {}
				cMoeda := 'BRL'
				Do Case
				Case (cAliasDA1)->DA1_MOEDA = 1 //REAL
					cMoeda := 'BRL'
				Case (cAliasDA1)->DA1_MOEDA = 2  //DOLAR
					cMoeda := 'USD'
				Case (cAliasDA1)->DA1_MOEDA = 3  //UFIR
					cMoeda := 'UFIR'
				Case (cAliasDA1)->DA1_MOEDA = 4 //EURO
					cMoeda := 'EUR'
				Case (cAliasDA1)->DA1_MOEDA = 5 //DOLAR CANADENSE
					cMoeda := 'CAD'
				Case (cAliasDA1)->DA1_MOEDA = 6 // LIBRA
					cMoeda := 'GBP'
				Case (cAliasDA1)->DA1_MOEDA = 7 //FRANCO SUICO
					cMoeda := 'CHF'
				EndCase
				aadd(xRet, cMoeda)
				aadd(xRet, (cAliasDA1)->DA1_PRCVEN)
				aadd(xRet, (cAliasDA1)->DA1_CUSTD)
				aadd(xRet, (cAliasDA1)->DA1_MIDEAL)
				aadd(xRet, (cAliasDA1)->DA1_MMIN)
			Endif
		Endif

		dbSelectArea(cAliasDA1)
		dbCloseArea()

	Endif

	RestArea(aAreaDA1)

RETURN(xRet)

/*/{Protheus.doc} TESTEIMP
	(on)
	
	@since 05/07/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function TESTEIMP(cCli, cLoja, cTpCli, nLin,cPrd,cTES,nQTD,nPrcUni,nAliqICMS, nAliqPCC, lValid)

	Local aRet := {}
	DEFAULT nAliqICMS	:= 0
	DEFAULT nAliqPCC	:= 0

	nLin  := 1 //TMP1->(Recno())

	MaFisSave()
	MaFisEnd()
	IF IsInCallStack("MATA415")

		MaFisIni(cCli,;// 1-Codigo Cliente/Fornecedor
		cLoja,;	// 2-Loja do Cliente/Fornecedor
		"C",;	// 3-C:Cliente , F:Fornecedor
		"N",;	// 4-Tipo da NF
		cTpCli,;// 5-Tipo do Cliente/Fornecedor
		Nil,;
			Nil,;
			Nil,;
			Nil,;
			"MATA461",;
			Nil,;
			Nil,;
			"")
		MaFisAdd( cPrd,	cTES, nQTD,	nPrcUni,0,"","",0,0,0,0,0,(nQTD*nPrcUni),0,0,0)

		_BASEICM    := MaFisRet(nLin,"IT_BASEICM")
		_nAliqIcm    := MaFisRet(nLin,"IT_ALIQICM")
		_QUANTIDADE := MaFisRet(nLin,"IT_QUANT")
		_VALICM     := MaFisRet(nLin,"IT_VALICM")
		_FRETE      := MaFisRet(nLin,"IT_FRETE")
		_VALICMFRETE:= MaFisRet(nLin,"IT_ICMFRETE")
		_DESCONTO   := MaFisRet(nLin,"IT_DESCONTO")
		_nValPis	:= MaFisRet(nLin,"IT_VALPS2")
		_nValCof	:= MaFisRet(nLin,"IT_VALCF2")
		_nAliqPCC 	:= MaFisRet(nLin,"IT_ALIQPS2") + MaFisRet(nLin,"IT_ALIQCF2")

	ELSE
		// Calculo ST e Outros Impostos
		MaFisIni(cCli, cLoja, "C","N",cTpCli,MaFisRelImp("MATA410",{"SC5","SC6"}),,,"SB1","MATA410")
		MaFisAdd( cPrd,	cTES, nQTD,	nPrcUni,0,"","",0,0,0,0,0,(nQTD*nPrcUni),0,0,0)

		_nAliqPCC 	:= MaFisRet(nLin,"IT_ALIQPS2") + MaFisRet(nLin,"IT_ALIQCF2")
		_nAliqIcm	:= MaFisRet(nLin,"IT_ALIQICM")
		_nValIcm	:= MaFisRet(nLin,"IT_VALICM" )
		_nAliqIpi	:= MaFisRet(nLin,"IT_ALIQIPI")
		_nValIpi	:= MaFisRet(nLin,"IT_VALIPI")
		_nValPis	:= MaFisRet(nLin,"IT_VALPS2")
		_nValCof	:= MaFisRet(nLin,"IT_VALCF2")
	ENDIF

	MaFisEndLoad(nLin,1)

	if lValid
		IF _nAliqIcm <> nAliqICMS
			MSGALERT("Aliquota de ICMS Informada "+TRANSFORM(nAliqICMS,"@E 99.99") +;
				" � Diferente do Calculado (Planilha) "+TRANSFORM(_nAliqIcm,"@E 99.99") ,"ITEM "+TRANSFORM(nLin,"@E 9999"))
		ENDIF

		IF _nAliqPCC <> nAliqPCC
			MSGALERT("Aliquota de PIS / COFINS Informada "+TRANSFORM(nAliqPCC,"@E 99.99") +;
				" � Diferente do Calculado (Planilha) "+TRANSFORM(_nAliqPCC,"@E 99.99") ,"ITEM "+TRANSFORM(nLin,"@E 9999"))
		ENDIF

	ELSE

		IF !(EMPTY(SA1->A1_SUFRAMA))
			_nAliqIcm := 0
		ENDIF

		IF SB1->B1_TIPO == 'MA'
			_nAliqIcm := 0
		ENDIF

	ENDIF

	aRet := {_nAliqIcm, _nAliqPCC}

RETURN(aRet)
