#include 'protheus.ch'
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFAT006   บ Autor ณ Giane - ADV Brasil บ Data ณ  24/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para rodar automatico uma vez por dia, atualiza os  บฑฑ
ฑฑบ          ณ valores tx.moeda, unitario e total do pedido de venda,     บฑฑ
ฑฑบ          ณ e orcamentos que nao tiverem sido faturados ainda.         บฑฑ
ฑฑบ          ณ Somente moeda <> R$. Atualiza com a taxa da moeda do dia.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico MAKENI / orcamento epedido de vendas            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User function AFAT006()
	Local _aArea := GetArea()
	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local _nTaxa := 0
	Local cCampo := ""
	Local cAltera := ""

	Private lAutoUPD := IsInCallStack("U_VLDMOEDA")

	//Atualiza a moeda nos pedidos de venda nใo faturados.
	//Se o item do pedido estiver liberado ou bloqueado tambem atualiza a moeda, so nao atualiza para o item totalmente faturado.
	cQuery := "Select DISTINCT C5_CLIENTE, C5_LOJACLI, C5_TABELA, C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, C6_XTAXA, C6_XMEDIO, C6_QTDVEN, "
	cQuery += " C6_XPRUNIT, C6_PRCVEN, C6_VALOR, C6_XMOEDA, C6_XPRUNIT, C6_XICMEST+ C6_XPISCOF NALIQIMP "
	cQuery += " FROM " + RETSQLNAME("SC6") + " SC6, " + RETSQLNAME("SC5") + " SC5 "
	cQuery += " WHERE SC5.C5_NOTA = '" + Space(TamSX3("C5_NOTA")[1]) + "' "
	cQuery += " AND SC5.C5_NUM = SC6.C6_NUM  "
	cQuery += " AND SC5.C5_CLIENTE || SC5.C5_LOJACLI = SC6.C6_CLI || SC6.C6_LOJA  "
	cQuery += " AND SC5.C5_FILIAL = SC6.C6_FILIAL "
	cQuery += " AND SC6.C6_QTDENT < SC6.C6_QTDVEN " //se a qtd.entregue for menor que a qtde, significa que o item nใo estแ totalmente faturado
	//AND SC5.C5_LIBEROK <> 'E'
	cQuery += " AND SC6.C6_XMOEDA > 1 AND SC5.C5_X_CANC <> 'C' AND SC5.C5_X_REP <> 'R' "
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += " AND SC6.C6_NUMORC <> ' ' "
	cQuery += " ORDER BY SC6.C6_NUM, SC6.C6_ITEM "

	cQuery := ChangeQuery(cQuery)

	If Select(cAlias) > 0
		(cAlias)->(DbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	(cAlias)->(DbGotop())
	ProcRegua(0)

	Do while !eof()

		IF (cAlias)->C6_XMOEDA > 1
			nPMoeda := (cAlias)->C6_XMOEDA

			IncProc("Manuten็ใo no Pedido nบ " + (cAlias)->C6_NUM + " . . .")

			_nTaxa := 0
			IF lAutoUPD
				_nTaxa := aValores[ nPMoeda - 1  ,2]
			else
				cCampo := 'M2_MOEDA' + ALLTRIM(STR((cAlias)->C6_XMOEDA,1))
				DbSelectArea("SM2")
				DbSetOrder(1)
				If DbSeek(dDataBase)
					_nTaxa := &cCampo
				endif
			endif

			//altera valores no pedido de vendas
			if _nTaxa != 0 .and. (_nTaxa != (cAlias)->C6_XTAXA)

				DbSelectArea("SC6")
				DbSetorder(1)
				if dbseek((cAlias)->C6_FILIAL + (cAlias)->C6_NUM + (cAlias)->C6_ITEM + (cAlias)->C6_PRODUTO)


					IF (cAlias)->C6_XMEDIO <> 'S'

						cCliente := (cAlias)->C5_CLIENTE
						cLoja := (cAlias)->C5_LOJACLI

						cTabela	:= (cAlias)->C5_TABELA
						cProd	:= (cAlias)->C6_PRODUTO
						nQtd	:= (cAlias)->C6_QTDVEN

						IF((cAlias)->NALIQIMP > 0)
							nAliqIMP := ((cAlias)->NALIQIMP/100)
						Endif

						nXPRTABR	:= MaTabPrVen(cTabela,cProd,nQtd,cCliente, cLoja, nPMoeda ,dDataBase)
						nXPRTABO	:= U_BSCMARG( cTabela, cProd ,nQtd ,1)

						nPRCVEN		:= Round( (nXPRTABR / (1- nAliqImp)) * _nTaxa, TamSx3("C6_PRCVEN")[2] )

						nCusto		:= U_BSCMARG(cTabela,cProd,nQtd,2)
						IF nCusto > 0
							nPrcTot  := ROUND( nPRCVEN  * ((1-nAliqIMP)) ,2 ) 
							nPrcCust := ROUND( nCusto  * _nTaxa,2 )
							nLucro	 := ROUND(((nPrcTot - nPrcCust) / nPrcTot)*100,0)

							cOBSMARG := IIF(nLucro >= nXPRTABO,"Lucro maior ou igual em ","Lucro menor em " );
							+ alltrim(TransForm(nLucro,PesqPict("SC6","C6_VALOR")))+"%."

							nXVRMARG := ROUND( (nPrcTot - nPrcCust) ,2)
						Else
							nLucro		:= 0
							cOBSMARG	:= " "
						Endif

						cAltera := 'Taxa de: ' + alltrim(str(SC6->C6_XTAXA)) + ' Para: ' + alltrim( STR(_nTaxa ) )

						RecLock("SC6")
						SC6->C6_XTAXA  := _nTaxa
						SC6->C6_PRCVEN := nPRCVEN
						SC6->C6_PRUNIT := nPRCVEN
						SC6->C6_XPRTABR	:= nXPRTABR
						SC6->C6_XPRTABO	:= nXPRTABO
						SC6->C6_XCUSTO	:= nCusto
						SC6->C6_XVRMARG	:= nXVRMARG
						SC6->C6_XPRMARG := nLucro
						SC6->C6_XOBSMAR := cOBSMARG+" alterado "+DTOC(dDataBase)

						SC6->C6_VALOR  := NoRound(nPRCVEN * nQtd ,TamSx3("C6_VALOR")[2])
						MsUnlock()

						//gravar o log de alteracao do pedido, com o motivo ref.atualizacao moeda automatica
						U_GrvLogPd(SC6->C6_NUM,SC6->C6_CLI,SC6->C6_LOJA,'Alteracao','Atualizou Taxa Moeda - AFAT060',SC6->C6_ITEM,cAltera)

						DbSelectArea("SC9")
						DbSetOrder(1)
						dbseek((cAlias)->C6_FILIAL + (cAlias)->C6_NUM + (cAlias)->C6_ITEM)
						Do while SC9->(!eof()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == (cAlias)->C6_FILIAL + (cAlias)->C6_NUM + (cAlias)->C6_ITEM
							If !(SC9->C9_BLEST == '10' .and. SC9->C9_BLCRED == '10') //so altera o preco de venda, se o item nao estiver faturado
								Reclock("SC9")
								SC9->C9_PRCVEN := SC6->C6_PRCVEN
								MsUnlock()
							Endif
							SC9->(DbSkip())
						Enddo
					endif
				endif

			endif
		endif


		DbSelectArea(cAlias)

		Dbskip()
	Enddo

	(cAlias)->(DbCloseArea())


	/**********************************************************************************************
	Atualiza moeda nos orcamentos que estiverem sem pedido de venda, ou com pedido mas que nao
	esteja faturado.
	***********************************************************************************************/
	nAliqIMP := 0
	nCusto := 0

	cQuery := " SELECT CJ_FILIAL, CJ_NUM, CJ_EMISSAO, CJ_CLIENTE, CJ_LOJA,CJ_CONDPAG, CJ_TABELA,CJ_VALIDA, "
	cQuery += " CK_FILIAL, CK_ITEM, CK_PRODUTO, CK_UM, CK_QTDVEN, CK_PRCVEN, CK_VALOR,CK_XPRTABR, CK_XPRTABO, "
	cQuery += " CK_XICMEST+CK_XPISCOF NALIQIMP, CK_XMOEDA, CK_XCUSTO, CK_XTAXA "
	cQuery += " FROM " + RETSQLNAME("SCJ") + " SCJ, " + RETSQLNAME("SCK") + " SCK "
	cQuery += " WHERE CK_NUM = CJ_NUM "
	cQuery += " AND CK_CLIENTE||CK_LOJA = CJ_CLIENTE||CJ_LOJA "
	cQuery += " AND CK_FILIAL = CJ_FILIAL "
	cQuery += " AND SCK.D_E_L_E_T_ <> '*' "
	//cQuery += " AND CJ_FILIAL = '"+XFILIAL("SCJ")+"' "
	cQuery += " AND CK_XMOEDA > 1 "
	cQuery += " AND CJ_STATUS = 'A' "
	cQuery += " AND SCJ.D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY CJ_FILIAL,CJ_NUM,CK_ITEM "
	cQuery := ChangeQuery(cQuery)

	cAlias := GetNextAlias()

	If Select(cAlias) > 0
		(cAlias)->(DbCloseArea())
	EndIf

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	(cAlias)->(DbGotop())
	ProcRegua(0)
	Do while !eof()

		IncProc("Manuten็ใo no 'Orcamento nบ " + (cAlias)->CJ_NUM + " . . .")

		IF (cAlias)->CK_XMOEDA > 1
			nPMoeda := (cAlias)->CK_XMOEDA

			_nTaxa := 0

			IF lAutoUPD
				_nTaxa := aValores[ nPMoeda - 1  ,2]
			else
				cCampo := 'M2_MOEDA' + ALLTRIM(STR(nPMoeda,1))
				DbSelectArea("SM2")
				DbSetOrder(1)
				If DbSeek(dDataBase)
					_nTaxa := &cCampo
				endif
			endif
			/*
			if _nTaxa <> (cAlias)->CK_XTAXA
			MSGYESNO( "Or็amento "+(cAlias)->CJ_NUM , "taxa diferente " )
			endif
			*/
			if _nTaxa != 0 .and. (_nTaxa != (cAlias)->CK_XTAXA)

				cCliente := (cAlias)->CJ_CLIENTE
				cLoja := (cAlias)->CJ_LOJA

				cTabela	:= (cAlias)->CJ_TABELA
				cProd	:= (cAlias)->CK_PRODUTO
				nQtd	:= (cAlias)->CK_QTDVEN

				DbSelectArea("SCK")
				DbSetorder(1)
				if dbseek((cAlias)->CK_FILIAL + (cAlias)->CJ_NUM + (cAlias)->CK_ITEM + cProd)

					if SCK->CK_XMEDIO <> 'S'

						IF((cAlias)->NALIQIMP > 0)
							nAliqIMP := ((cAlias)->NALIQIMP/100)
						Endif

						nXPRTABR	:= MaTabPrVen(cTabela,cProd,nQtd,cCliente, cLoja, nPMoeda ,dDataBase)
						nXPRTABO	:= U_BSCMARG( cTabela, cProd ,nQtd ,1)

						nPRCVEN		:= Round( (nXPRTABR / (1- nAliqImp)) * _nTaxa, TamSx3("CK_PRCVEN")[2] )

						nCusto		:= U_BSCMARG(cTabela,cProd,nQtd,2)
						IF nCusto > 0
							nPrcTot  := ROUND( nPRCVEN  * ((1-nAliqIMP)) ,2 )
							nPrcCust := ROUND( nCusto  * _nTaxa,2 ) 
							nLucro	 := ROUND(((nPrcTot - nPrcCust) / nPrcTot)*100,0)

							cOBSMARG := IIF(nLucro >= nXPRTABO,"Lucro maior ou igual em ","Lucro menor em " );
							+ alltrim(TransForm(nLucro,PesqPict("SCK","CK_VALOR")))+"%."

							nXVRMARG := ROUND( (nPrcTot - nPrcCust) ,2)
						Else
							nLucro		:= 0
							cOBSMARG	:= " "
						Endif

						RecLock("SCK",.F.)
						SCK->CK_XTAXA	:= _nTaxa
						SCK->CK_XPRTABR	:= nXPRTABR
						SCK->CK_XPRTABO	:= nXPRTABO
						SCK->CK_PRCVEN	:= nPRCVEN
						SCK->CK_PRUNIT	:= nPRCVEN
						SCK->CK_XCUSTO	:= nCusto
						SCK->CK_XVRMARG	:= nXVRMARG

						SCK->CK_XPRMARG := nLucro
						SCK->CK_XOBSMAR := cOBSMARG+" alterado "+DTOC(dDataBase)

						SCK->CK_VALOR := NORound( nQtd * nPRCVEN , TamSx3("CK_VALOR")[2] )

						MsUnlock()
					endif
				endif
			endif
		endif

		DbSelectArea(cAlias)
		Dbskip()
	Enddo

	(cAlias)->(DbCloseArea())
	Ferase(cAlias)
	RestArea(_aArea)

RETURN()
