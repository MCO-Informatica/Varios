#include "protheus.ch"
#Include "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATG01  ³ Autor ³ Luiz Alberto V Alves    ³ Data ³ 19/02/2014 ³±±
±±³          ³          ³       ³     3L Systems          ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajusta o Preco de Venda Com Base Tabela Precos Quantidade Mts. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ C6_PRCVEN C6_QTDVEN                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Metalacre Ind e Com Lacres Ltda                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATG01(nRetorno,lAtualiza,lRec,lSql) // Igual a 1 Retorna Quantidade, Igual a 2 Retorna Valor Unitario, .t. atualiza linha, .f. nao atualiza, .t. Posicionado na SG1, .f. Não Posicionado
Local _nQtdVen	:=	Iif(aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0,aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})],aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_QUANT"})])
Local _nPrcVen	:=	Iif(aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0,aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VRUNIT"})])
Local _cProduto	:=	Iif(aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0,aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRODUTO"})],aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_PRODUTO"})])
Local _cTES		:=	Iif(aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0,aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_TES"})],aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_TES"})])
Local _nValor	:=	Iif(aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0,aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"})],aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VLRITEM"})])
Local _nDescont	:=	Iif(aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0,aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_DESCONT"})],aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_DESC"})])
Local _nValDes	:=	Iif(aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0,aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALDESC"})],aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VALDESC"})])
Local _cOpcio	:= 	Iif(aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0,aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_OPC"})],aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_OPC"})])
Local cTabPadrao:=  SuperGetMV("MV_TBQPAD", ,'0001')
Local aArea		:=  GetArea()
Local cCampo	:=  ReadVar()
Local nDscCEsp	:=  SuperGetMV("MV_MTLDSC", ,70)	// Desconto Cliente Especial - Exemplo METALSEAL
Local cDscCli	:=  GetNewPar("MV_MTLDCL",'00132001*01140401') // Clientes Especiais - Exemplo METALSEAL

DEFAULT nRetorno := 1
DEFAULT lAtualiza := .t.
DEFAULT lRec := .F.
DEFAULT lSql := .F.

nPrcTab := _nPrcVen

If cEmpAnt <> '01'	// TRATAMENTO APENAS PARA METALACRE
	Return _nValor
Endif

//----> SO EXECUTA O GATILHO SE A FUNCAO FOR MATA410 (PEDIDO DE VENDA)
If aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0
	
	// Se a Tes Não Gerar Duplicata então Ignora Informação da Tabela

	If SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+_cTES))
		If SF4->F4_DUPLIC <> 'S'
			Return Iif(nRetorno==1,_nQtdVen,_nPrcVen)
		Endif
	Endif

	If Empty(cTabPadrao)
		Alert("Atenção Parâmetro da Tabela Quantidade Está Vazio, Verifique MV_TBQPAD !!!")
		RestArea(aArea)
		Return Iif(nRetorno==1,_nQtdVen,_nPrcVen)
	Endif  

	// Consulta Estrutura de Produtos para ver se o produto atual tem opcionais
		
	nPerc := 0.00	// Percentual de Grupo de Opcionais Padrao
	
	If !lRec
		If !Empty(_cOpcio)      // Se Selecionou Opcionais
			If SG1->(dbSetOrder(3), dbSeek(xFilial("SG1")+_cProduto+SGA->GA_GROPC+SGA->GA_OPC))
				nPerc := SG1->G1_PERC
			Endif
		Endif
	Else
		nPerc := SG1->G1_PERC
	Endif
	
    // Busca Valor do Produto com Base na Quantidade Tabela de Preços Quantidades
	
	If SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8")+cTabPadrao+_cProduto))
		If _nQtdVen <= 1000
			nPrcTab := SZ8->Z8_P00500
		ElseIf _nQtdVen >= 1001 .And. _nQtdVen <= 5000
			nPrcTab := SZ8->Z8_P03000
		ElseIf _nQtdVen >= 5001 .And. _nQtdVen <= 10000
			nPrcTab := SZ8->Z8_P05000
		ElseIf _nQtdVen >= 10001 .And. _nQtdVen <= 50000
			nPrcTab := SZ8->Z8_P20000
		ElseIf _nQtdVen >= 50001// .And. _nQtdVen <= 30000
			nPrcTab := SZ8->Z8_P20001
		Else
			nPrcTab := _nPrcVen
		Endif			
		
		If !Empty(nPerc)
			nPerc 	:= ((nPerc/100)+1)
			nPrcTab := Round((nPrcTab * nPerc),2)
		Endif

		// Tratamento de Desconto para Clientes Especiais Exemplo: MetalSeal

		If SA1->A1_COD+SA1->A1_LOJA $ cDscCli
			nPrcTab := Round((nPrcTab * (nDscCesp/100)),2)
		Endif

		If lAtualiza
			If aScan(aHeader,{|x| Alltrim(x[2])== "C6_XTAB"}) > 0
				aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XTAB"})]	:=	nPrcTab
			Endif
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT"})]	:=	nPrcTab
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})]	:=	FtDescCab(nPrcTab,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4})
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR" })]	:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN"})],"C6_VALOR")
		Endif
	Endif

ElseIf IsInCallStack("TMKA271")	// CRM
	
	// Se a Tes Não Gerar Duplicata então Ignora Informação da Tabela

	If SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+_cTES))
		If SF4->F4_DUPLIC <> 'S'
			Return Iif(nRetorno==1,_nQtdVen,_nPrcVen)
		Endif
	Endif

	If Empty(cTabPadrao)
		Alert("Atenção Parâmetro da Tabela Quantidade Está Vazio, Verifique MV_TBQPAD !!!")
		RestArea(aArea)
		Return Iif(nRetorno==1,_nQtdVen,_nPrcVen)
	Endif  

	// Consulta Estrutura de Produtos para ver se o produto atual tem opcionais
		
	nPerc := 0.00	// Percentual de Grupo de Opcionais Padrao
	
	If !'UB_QUANT'$cCampo .And. !lSql
		If !lRec
			If !Empty(_cOpcio)      // Se Selecionou Opcionais
				If SG1->(dbSetOrder(3), dbSeek(xFilial("SG1")+_cProduto+SGA->GA_GROPC+SGA->GA_OPC))
					nPerc := SG1->G1_PERC
				Endif
			Endif
		Else
			nPerc := SG1->G1_PERC
		Endif
	ElseIf lSql .Or. 'UB_QUANT'$cCampo
		aAreaSG1 := GetArea()
		
		cQuery := 	 " SELECT TOP 1 R_E_C_N_O_ REG "
		cQuery +=	 " FROM " + RetSqlName("SG1") + " SG1 (NOLOCK) "
		cQuery +=	 " WHERE  "
		cQuery +=	 " G1_FILIAL = '" + xFilial("SG1") + "' "
		cQuery +=	 " AND SG1.D_E_L_E_T_ = '' "      
		cQuery +=	 " AND SG1.G1_COD = '" + _cProduto + "' "
		cQuery += 	 " AND G1_OPC = '" + AllTrim(SubStr(_cOpcio,4,4)) + "' "  // VERIFICA SE TEM ALGUM COMPRIMENTO
		cQuery +=	 " ORDER BY G1_OPC "       //
				
		TCQUERY cQuery NEW ALIAS "CHK1"
		
		SG1->(dbGoTo(CHK1->REG))
		
		CHK1->(dbCloseArea())
		RestArea(aAreaSG1)       
		
		nPerc := SG1->G1_PERC
	Endif	
    // Busca Valor do Produto com Base na Quantidade Tabela de Preços Quantidades
	
	If SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8")+cTabPadrao+_cProduto))
		If _nQtdVen <= 1000
			nPrcTab := SZ8->Z8_P00500
		ElseIf _nQtdVen >= 1001 .And. _nQtdVen <= 5000
			nPrcTab := SZ8->Z8_P03000
		ElseIf _nQtdVen >= 5001 .And. _nQtdVen <= 10000
			nPrcTab := SZ8->Z8_P05000
		ElseIf _nQtdVen >= 10001 .And. _nQtdVen <= 50000
			nPrcTab := SZ8->Z8_P20000
		ElseIf _nQtdVen >= 50001 
			nPrcTab := SZ8->Z8_P20001
		Else
			nPrcTab := _nPrcVen
		Endif			
		
		If !Empty(nPerc)
			nPerc 	:= ((nPerc/100)+1)
			nPrcTab := Round((nPrcTab * nPerc),2)
		Endif

		// Tratamento de Desconto para Clientes Especiais Exemplo: MetalSeal

		If SA1->A1_COD+SA1->A1_LOJA $ cDscCli
			nPrcTab := Round((nPrcTab * (nDscCesp/100)),2)
		Endif

		If lAtualiza
			If aScan(aHeader,{|x| Alltrim(x[2])== "UB_XTAB"}) > 0
				aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XTAB"})]	:=	nPrcTab
			Endif
			
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_PERCLES"})]	:=	nDscCesp	// Desconto Cliente Especial
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_PEROPC"})]	:=	nPerc		// Desconto Baseado em Opcional
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VRUNIT"})]	:=	nPrcTab
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_PRCTAB"})]	:=	nPrcTab
			aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VLRITEM" })]	:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_QUANT"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VRUNIT"})],"UB_VLRITEM")

			MaFisAlt("IT_PRCUNI",aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VRUNIT"})],n)
			MaFisAlt("IT_VALMERC",aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VLRITEM" })],n)
	
			M->UB_VRUNIT           										:=	nPrcTab
			M->UB_VLRITEM           									:=	A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_QUANT"})] * aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_VRUNIT"})],"UB_VLRITEM")
		
			Tk273trigger("UB_VRUNIT")
		Endif
	Endif
EndIf
If aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})>0 .And. lAtualiza .And. Type("oGetDad") <> "U"
	oGetDad:oBrowse:Refresh()
EndIf
RestArea(aArea)
Return Iif(nRetorno==1,_nQtdVen,nPrcTab)
