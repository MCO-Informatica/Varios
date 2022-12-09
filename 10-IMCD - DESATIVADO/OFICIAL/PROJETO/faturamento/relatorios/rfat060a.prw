#include "protheus.ch"
#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFAT060A  � Autor � Eneovaldo Roveri Jr� Data �  21/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Margem de Contribui��o                        ���
���          � RFAT060A - CUSTOMIZA��O DENIS, PARA TRAZER OS FRETES        ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFAT060A()
Local cPerg := 'RFAT060A'

//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT060" , __cUserID )

if .not. Pergunte( cPerg, .T.)
	return
endif

MsgRun("Processando Relat�rio de Margem em excel, aguarde...","",{|| U_IMPR060A() })

Return

/*/
�����������������������������������������������������������������������������
���Programa  � IMPR060A  � Autor � Eneovaldo Roveri Jr� Data �  21/12/09   ���
�����������������������������������������������������������������������������
/*/

User Function IMPR060A()
Local cAlias, cQuery
Local aCabec := {}
Local aDados := {}
Local dEmissao, nVlrImp, nPerImp, nLiquido
Local nCstTot , nPerBrut, nCusto,  nVlBrut
Local nPrcSeg, nMrgSeg
Local cObs := ""
Local _lSeg := .f.
Local nIcmOri := 0
Local nPeso, nTotFrete, nUniFrete, nFrete, nTotPeso
Local cTpFrete := ""
local cChaveD1 := ""
local nVUNIT      := 0
local nD1_QUANT   := 0
local nD1_TOTAL   := 0
local nD1_VALIPI  := 0
local nD1_VALICM  := 0
local nD1_VLIMP5 := 0
local nD1_VLIMP6 := 0
local nD1_CUSTO   := 0
local cA3_NOME    := ""
local cD1_DOC     := ""
local cF1_EST     := ""
local cD1_FORNEC := ""
local cA1_NREDUZ  := ""
local cD1_COD     := ""
local cB1_DESC    := ""
local cD1_NFORI   := ""
local cD1_SERIOR := ""
local cZA0_NAME   := ""
Local cNumPedCli	:=""
Local cItemPedCli 	:= """



DbSelectArea("SB1")
DbSetOrder(1)

cAlias:= GetNextAlias()

cQuery := " SELECT "
cQuery += " SA1.A1_GRPVEN,SA3.A3_NREDUZ,SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_EMISSAO,SD2.D2_CLIENTE,SD2.D2_LOJA,SA1.A1_NREDUZ,SD2.D2_COD,SD2.D2_FILIAL,SB1.B1_DESC, "
cQuery += " SD2.D2_QUANT AS D2_QUANT,SD2.D2_VALBRUT AS D2_VALBRUT,SD2.D2_IPI,SD2.D2_PICM,SD2.D2_ALQIMP5,SD2.D2_ALQIMP6,SA1.A1_SATIV1,"
cQuery += " SD2.D2_VALIPI AS D2_VALIPI,SD2.D2_VALICM AS D2_VALICM,SD2.D2_VALIMP5 AS D2_VALIMP5,SD2.D2_VALIMP6 AS D2_VALIMP6,"
cQuery += " SD2.D2_PRCVEN AS D2_PRCVEN,SD2.D2_LOJA,SD2.D2_NFORI,SD2.D2_SERIORI,SF2.F2_EST,SB1.B1_SEGMENT,SA3.A3_NOME,SB1.B1_CUSTD,SD2.D2_PEDIDO,"
cQuery += " SD2.D2_ITEMPV,SC6.C6_COMIS1,SD2.D2_CUSTO1 AS D2_CUSTO1,SC5.C5_TPFRETE,C5_GRPVEN,SD2.D2_CF,XORI.D2_CUSTO1 AS CUSTOORI,"
cQuery += " XORI.D2_PICM AS PICMORI,SD2.D2_XNFORI,SD2.D2_XSERORI,XORI.D2_VALICM AS VICMORI,SD2.D2_TOTAL AS D2_TOTAL,XORI.D2_QUANT AS XQUANT,"
cQuery += " XORI.D2_PEDIDO AS XPEDIDO,XORI.D2_ITEMPV XITEMPV,SC6.C6_NUM,SC6.C6_NUMORC,SC6.C6_PRODUTO,SC6.C6_XPRTABR,SD2.D2_XTAXA,SD2.D2_XMOEDA,"
cQuery += " C6_XMEDIO,C5_EMISSAO,ZA0_NAME, SC6.C6_NUMPCOM, SC6.C6_ITEMPC,  "
cQuery += " SD2.D2_DESPESA,SD2.D2_VALFRE,SD2.D2_SEGURO ,SD2.D2_CF,SD2.D2_LOTECTL "
cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
cQuery += "    SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cQuery += "    SD2.D2_COD = SB1.B1_COD AND "
cQuery += "    SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "    SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "    SD2.D2_CLIENTE = SA1.A1_COD AND "
cQuery += "    SD2.D2_LOJA = SA1.A1_LOJA AND "
cQuery += "    SA1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SF2") + " SF2 ON "
cQuery += "    SF2.F2_FILIAL = SD2.D2_FILIAL AND "
cQuery += "    SD2.D2_DOC = SF2.F2_DOC AND "
cQuery += "    SD2.D2_SERIE = SF2.F2_SERIE AND "
cQuery += "    SF2.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON "
cQuery += "    SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND "
cQuery += "    SF2.F2_VEND1 = SA3.A3_COD AND "
cQuery += "    SA3.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
cquery += "    SF4.F4_FILIAL = '" + xFilial( "SF4" ) + "' AND "
cQuery += "    SD2.D2_TES = SF4.F4_CODIGO AND "
cQuery += "    SF4.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("ZA0") + " ZA0 ON "
cquery += "    ZA0.ZA0_FILIAL = '" + xFilial( "ZA0" ) + "' AND "
cQuery += "    ZA0.ZA0_CODPRI = SB1.B1_X_PRINC  AND "
cQuery += "    ZA0.D_E_L_E_T_ = ' ' "
/*cQuery += "  LEFT JOIN " + RetSqlName("SB2") + " SB2 ON "
cQuery += "    SD2.D2_FILIAL = SB2.B2_FILIAL AND "
cQuery += "    SD2.D2_COD = SB2.B2_COD AND "
cQuery += "    SD2.D2_LOCAL = SB2.B2_LOCAL AND "
cQuery += "    SB2.D_E_L_E_T_ = ' ' "
*/
cQuery += "  LEFT JOIN " + RetSqlName("SC6") + " SC6 ON "
cQuery += "    SC6.C6_FILIAL = SD2.D2_FILIAL AND "
cQuery += "    SC6.C6_NUM = SD2.D2_PEDIDO AND "
cQuery += "    SC6.C6_ITEM = SD2.D2_ITEMPV AND "
cQuery += "    SC6.C6_PRODUTO = SD2.D2_COD AND "
cQuery += "    SC6.C6_NOTA = SD2.D2_DOC AND "
cQuery += "    SC6.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SC5") + " SC5 ON "
cQuery += "     SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ = ' ' "
// JOIN COM O PROPRIO SD2 LOCALIZANDO DADOS DA NOTA DE REMESSA LIGADA A NF VENDA CONSIGNACAO
cQuery += "  LEFT JOIN ( SELECT DISTINCT D2_FILIAL, D2_DOC, D2_SERIE, D2_COD, SUM( D2_CUSTO1 ) D2_CUSTO1, AVG( D2_PICM ) D2_PICM, AVG( D2_VALICM ) D2_VALICM, SUM( D2_QUANT ) D2_QUANT, MAX( D2_PEDIDO ) D2_PEDIDO, MAX( D2_ITEMPV ) D2_ITEMPV "
cQuery += "                FROM " + RetSQLName( "SD2" )
cQuery += "               WHERE D_E_L_E_T_ = ' ' "
cQuery += "               GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_COD ) XORI "
cQuery += "       ON XORI.D2_FILIAL = '" + xFilial( "SD2" ) + "' "
cQuery += "      AND SC6.C6_XNFORIG = XORI.D2_DOC "
cQuery += "      AND SC6.C6_XSERORI = XORI.D2_SERIE "
cQuery += "      AND SC6.C6_PRODUTO = XORI.D2_COD "
cQuery += "      AND SC6.C6_CF IN('5112','6112') "
cQuery += " WHERE "
cQuery += "  SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery += "  AND SD2.D2_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND SD2.D2_EMISSAO <= '" + DTOS(MV_PAR02) + "' "
cQuery += "  AND SD2.D2_CLIENTE||SD2.D2_LOJA >= '" + MV_PAR03+ MV_PAR04 +"' AND SD2.D2_CLIENTE||SD2.D2_LOJA <= '" + MV_PAR05+ MV_PAR06 + "' "
cQuery += "  AND SF2.F2_VEND1 >= '" + MV_PAR09 + "' AND SF2.F2_VEND1 <= '" + MV_PAR10 + "'"
cQuery += "  AND SD2.D2_COD >= '" + MV_PAR11 + "' AND SD2.D2_COD <= '" + MV_PAR12 + "'"
cQuery += "  AND SA1.A1_SATIV1 >= '" + MV_PAR07 + "' AND SA1.A1_SATIV1 <='" + MV_PAR08 + "' "
cQuery += "  AND SB1.B1_SEGMENT >= '" + MV_PAR13 + "' AND SB1.B1_SEGMENT <='" + MV_PAR14 + "' "
cQuery += "  AND SB1.B1_X_PRINC >= '" + MV_PAR16 + "' AND SB1.B1_X_PRINC <= '" + MV_PAR17 + "' "
cQuery += "  AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVI�O
cQuery += "  AND SD2.D_E_L_E_T_ = ' ' AND SD2.D2_TIPO IN ('N','C','I','P') "
cQuery += "  AND SD2.D2_TP <> 'AI' "

//SA1.A1_SATIV1 -> SEGMENTO DE VENDAS
//SB1.B1_SEGMENT -> SEGMENTO DE RESPONSABILIDADE

//MEMOWRITE("C:\QUERY.SQL",cQuery)

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)


dbSelectArea(cAlias)


AADD(aCabec, {"Status" ,"C", 10, 0})
AADD(aCabec, {"Grp. Vendas" ,"C", 30, 0})
AADD(aCabec, {"Segto. Vendas" ,"C", 30, 0})
AADD(aCabec, {"Nome do Representante" ,"C", 30, 0})
AADD(aCabec, {"Pedid de Venda" ,"C", 06, 0})
AADD(aCabec, {"Nr. Nota" ,"C", 09, 0})
AADD(aCabec, {"Data Emiss�o" ,"D", 08, 0})
AADD(aCabec, {"Tipo Frete" ,"C", 03, 0})
AADD(aCabec, {"UF" ,"C", 02, 0})
AADD(aCabec, {"Cliente" ,"C", 06, 0})
AADD(aCabec, {"Loja" ,"C", 02, 0})
AADD(aCabec, {"Nome Fantasia" ,"C", 40, 0})
AADD(aCabec, {"Item" ,"C", 15, 0})

AADD(aCabec, {"Descri��o Item" ,"C", 40, 0})
AADD(aCabec, {"Quantidade" ,"N", 18, 4})
AADD(aCabec, {"Valor Total" ,"N", 18, 2})
AADD(aCabec, {"Pre�o Unitario" ,"N", 18, 6})

aadd(aCabec, {"Valor ICM","N", 18, 4})
aadd(aCabec, {"Valor IPI","N", 18, 4})
aadd(aCabec, {"Valor PIS","N", 18, 4})
aadd(aCabec, {"Valor COF","N", 18, 4})
aadd(aCabec, {"Impostos" ,"N", 18, 4})
aadd(aCabec, {"%Impostos" ,"N", 18, 4})
aadd(aCabec, {"Valor Liquido" ,"N", 18, 4})
aadd(aCabec, {"Custo Unit.Sem Imp" ,"N", 18, 4})
aadd(aCabec, {"Custo Total" ,"N", 18, 4})
aadd(aCabec, {"Margem Bruta" ,"N", 18, 4})
aadd(aCabec, {"%Margem Bruta" ,"N", 18, 4})
aadd(aCabec, {"NF Origem" ,"C", 10, 0})
aadd(aCabec, {"Serie Orig" ,"C", 3, 0})
aadd(aCabec, {"%ICMS Orig" ,"N", 18, 4})
aadd(aCabec, {"Seg.Responsavel" ,"C", 40, 0})
aadd(aCabec, {"Valor Frete" ,"N", 18, 4})
aadd(aCabec, {"Comissao Repr.","N", 18, 4})
aadd(aCabec, {"Pre�o Seg." ,"N", 18, 4})
aadd(aCabec, {"Margem Seg." ,"N", 18, 4})
aadd(aCabec, {"Obs Aprovador" ,"C", 40, 0})
aadd(aCabec, {"Preco Liquido Tab.Pre�o" ,"N", 18, 4})
aadd(aCabec, {"%Taxa Moeda" ,"N", 18, 4})
aadd(aCabec, {"Moeda" ,"C", 5, 0})
aadd(aCabec, {"Custo Standard" ,"N", 18, 4})
aadd(aCabec, {"principal" ,"C", 40, 0})
aadd(aCabec, {"CFOP" ,"C", 5, 0})
aadd(aCabec, {"Outras Despesas" ,"N", 18, 4})
aadd(aCabec, {"Lote"  ,"C", 20, 0})
AADD(aCabec, {"Num. Pedido Cliente" ,"C", 20, 0})
AADD(aCabec, {"Item Pedido Cliente" ,"C", 6, 0})

dbGoTop()
While !EOF()

	If (MV_PAR15 == 3 .and. nMrgBrut <= 0) .or.; //imprimir somente os registros com margem bruta negativa
		(MV_PAR15 == 2 .and. _lSeg ) .or.; // imprimir somente os registro com valor abaixo da margem de seguran�a
		MV_PAR15 == 1  //todos os registros

		cSegVen := ""
		DbSelectArea("SX5")
		DbSetOrder(1)
		If DbSeek(xFilial("SX5")+"T3"+(cAlias)->A1_SATIV1)
			cSegVen := X5DESCRI()
		Endif

		cSegResp := ""
		DbSelectArea("ACY")
		DbSetOrder(1)
		If DbSeek(xFilial("ACY")+(cAlias)->B1_SEGMENT)
			cSegResp := ACY->ACY_DESCRI
		endif

		cGrpVen := iif( EMPTY((cAlias)->C5_GRPVEN), (cAlias)->A1_GRPVEN, (cAlias)->C5_GRPVEN )
		DbSelectArea("ACY")
		DbSetOrder(1)
		If DbSeek(xFilial("ACY")+cGrpVen)
			cGrpVen := ACY->ACY_DESCRI
		endif

		DbSelectArea(cAlias)

		dEmissao := strzero(val( right((cAlias)->D2_EMISSAO,2)), 2) + '/' + ;
		strzero(val( substr((cAlias)->D2_EMISSAO,5,2)),2)  + '/'+  left((cAlias)->D2_EMISSAO,4)


		nPerImp := (cAlias)->D2_IPI + (cAlias)->D2_PICM + (cAlias)->D2_ALQIMP5 + (cAlias)->D2_ALQIMP6 + (cAlias)->PICMORI
		//nVlrImp := (cAlias)->D2_TOTAL * ( nPerImp / 100 )
		//Altera��o da variavel nVlrImp para considerar o valor do imposto j� calculado. Weskley Silva 11/11/2019
        //nVlrImp := (cAlias)->D2_VALICM + (cAlias)->D2_VALIPI + (cAlias)->D2_VALIMP5 + (cAlias)->D2_VALIMP6 + (cAlias)->VICMORI
        
        nVlrImp := (cAlias)->D2_VALICM + (cAlias)->D2_VALIPI + (cAlias)->D2_VALIMP5 + (cAlias)->D2_VALIMP6
        nVlrImp +=  ( (cAlias)->D2_TOTAL * ( (cAlias)->PICMORI  / 100 ) )
		nLiquido := (cAlias)->D2_VALBRUT - nVlrImp

		nVlrICM := (cAlias)->D2_VALICM
		nVlrIPI := (cAlias)->D2_VALIPI
		nVlrPIS := (cAlias)->D2_VALIMP6
		nVlrCOF := (cAlias)->D2_VALIMP5


		If ALLTRIM((cAlias)->D2_CF) $ '5112/6112' .and. (!empty((cAlias)->D2_XNFORI) )
			nCusto := ((cAlias)->CUSTOORI / (cAlias)->XQUANT) //nota de venda em consignacao, pegar o custo da nota de origem
			nCstTot := ( (cAlias)->CUSTOORI / (cAlias)->XQUANT ) * (cAlias)->D2_QUANT
		Else
			nCusto := ( (cAlias)->D2_CUSTO1 / (cAlias)->D2_QUANT  )
			nCstTot := (cAlias)->D2_CUSTO1
		Endif

		nMrgBrut := nLiquido - nCstTot
		nPerBrut := NOROUND( (nMrgBrut / nLiquido) * 100,2)

		//verificar se o item esteve abaixo da margem de seguran�a e foi aprovado na libera��o do pedido:
		cObs := ""
		nPrcSeg := 0
		nMrgSeg := 0
		_lSeg 	:= .f.
		_nXCUSTO:=0
		_cXGPAR	:=""

		//Alterado por Marcos Andrade para n�o buscar da ZA4 Apos 25/01/2018
		If Ctod(dEmissao) <= CTOD("25/01/2017")
			If nPerBrut <= 10
				DbSelectArea("ZA4")
				DbSetOrder(1)
				If DbSeek( (cAlias)->D2_FILIAL + (cAlias)->D2_PEDIDO + (cAlias)->D2_ITEMPV + (cAlias)->D2_COD )

					_lSeg := .t.
					nPrcSeg := ZA4->ZA4_VMSEG
					nMrgSeg := ZA4->ZA4_MSEG

					While ZA4->( !Eof() ) .and. ZA4->( ZA4_FILIAL + ZA4_PEDIDO + ZA4_ITEPED + ZA4_PROD ) == (cAlias)->D2_FILIAL + (cAlias)->D2_PEDIDO + (cAlias)->D2_ITEMPV + (cAlias)->D2_COD
						cObs += " Usu�rio: " + AllTrim( UsrRetName(ZA4->ZA4_USUARI) ) + " Motivo: " + alltrim(ZA4->ZA4_MOTIVO) + " / "
						ZA4->( dbSkip() )
					End
				Endif

				DbSelectArea("ZA4")
				DbSetOrder(1)
				If DbSeek( (cAlias)->D2_FILIAL + (cAlias)->XPEDIDO + (cAlias)->XITEMPV + (cAlias)->D2_COD )

					_lSeg := .t.
					nPrcSeg := ZA4->ZA4_VMSEG
					nMrgSeg := ZA4->ZA4_MSEG

					While ZA4->( !Eof() ) .and. ZA4->( ZA4_FILIAL + ZA4_PEDIDO + ZA4_ITEPED + ZA4_PROD ) == (cAlias)->D2_FILIAL + (cAlias)->D2_PEDIDO + (cAlias)->D2_ITEMPV + (cAlias)->D2_COD
						cObs += " Usu�rio: " + AllTrim( UsrRetName(ZA4->ZA4_USUARI) ) + " Motivo: " + alltrim(ZA4->ZA4_MOTIVO) + " / "
						ZA4->( dbSkip() )
					End
				Endif

			Endif
		Else

			DbSelectArea("SCJ")
			DbSetOrder(1)
			If DbSeek(xFilial("SCJ")+Substr((cAlias)->C6_NUMORC,1,6))
				cObs	:=  SCJ->CJ_XGERAPR
			Endif

			DbSelectArea("SCK")
			DbSetOrder(1)
			If DbSeek(xFilial("SCK")+(cAlias)->C6_NUMORC+(cAlias)->C6_PRODUTO)
				_nXCUSTO	:= SCK->CK_XCUSTO
			Endif

		Endif
		//=================================================================================================

		//se tem nf origem � porque � venda consignacao, entao buscar o icms que est� na nf de origem
		nIcmOri := 0

		If ALLTRIM((cAlias)->D2_CF) $ '5112/6112' .and. ( !empty((cAlias)->D2_XNFORI)  )
			nIcmOri := (cAlias)->PICMORI
		endif

		dbSelectArea(cAlias)

		//===================================================
		//fazer rateio do valor do frete :

		nTotFrete := 0
		/*
		DbSelectArea("DAI")
		DbSetOrder(4)
		if DbSeek(xFilial("DAI")+ (cAlias)->D2_PEDIDO)
		nTotFrete := DAI->DAI_VALFRE
		Endif
		*/

		cAliasSD1 := GetNextAlias()
		/*
		cQuery := "SELECT D1_CUSTO FROM SD1010 "
		cQuery += " WHERE D1_NFRSAI = '"+(cAlias)->D2_DOC+"' "
		cQuery += " AND D1_SERSAI = '"+(cAlias)->D2_SERIE+"' "
		cQuery += " AND D1_FILIAL = '"+(cAlias)->D2_FILIAL+"' "
		cQuery += " AND D_E_L_E_T_ <> '*' "

		cQuery := ChangeQuery(cQuery)

		PLSQuery(cQuery,cAliasSD1)
		*/

		BeginSql alias cAliasSD1
			SELECT D1_CUSTO
			FROM %table:SD1%
			WHERE D1_NFRSAI = %Exp:(cAlias)->D2_DOC%
			AND D1_SERSAI = %Exp:(cAlias)->D2_SERIE%
			AND D1_FILIAL = %Exp:(cAlias)->D2_FILIAL%
			AND D_E_L_E_T_ <> '*'
		EndSql

		DbSelectArea(cAliasSD1)
		(cAliasSD1)->(DbGoTop())
		While !(cAliasSD1)->(EOF())
			nTotFrete += 	(cAliasSD1)->D1_CUSTO
			(cAliasSD1)->(DbSkip())
		EndDo
		(cAliasSD1)->(DbCloseArea())
		MsErase(cAliasSD1)

		//somar os pesos dos itens do pedido, para depois dividir pelo total do frete:
		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+(cAlias)->D2_PEDIDO)
		nTotPeso := 0
		nPeso := 0
		Do While SC9->(!EOF()) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9")+(cAlias)->D2_PEDIDO
			If SC9->C9_NFISCAL == (cAlias)->D2_DOC
				If cEmpAnt $ '02|04'
					nTotPeso += SC9->C9_QTDLIB
				Else
					nPeso := Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_PESO")
					nTotPeso += (nPeso * SC9->C9_QTDLIB)
				Endif
			Endif
			SC9->(DbSkip())
		Enddo

		//nUniFrete := (nTotFrete / (cAlias)->F2_PBRUTO)
		nUniFrete := (nTotFrete / nTotPeso )
		nFrete := nUniFrete * (cAlias)->D2_QUANT
		//====================================================

		cTpFrete :=""
		if (cAlias)->C5_TPFRETE == 'C'
			cTpFrete := 'CIF'
		elseif (cAlias)->C5_TPFRETE == 'F'
			cTpFrete := 'FOB'
		endif

		DbSelectArea(cAlias)

		aadd(aDados, {"Venda",;
		cGrpVen,;
		cSegVen,;
		(cAlias)->A3_NOME,;
		(cAlias)->D2_PEDIDO,;
		(cAlias)->D2_DOC,;
		ctod(dEmissao),;
		cTpFrete,;
		(cAlias)->F2_EST,;
		(cAlias)->D2_CLIENTE,;
		(cAlias)->D2_LOJA,;
		(cAlias)->A1_NREDUZ,;
		(cAlias)->D2_COD,;
		(cAlias)->B1_DESC,;
		transform((cAlias)->D2_QUANT,"@E 9,999,999.9999"),;
		transform((cAlias)->D2_VALBRUT,"@E 999,999,999.99"),;
		transform((cAlias)->D2_PRCVEN,"@E 99,999.999999"),;
		transform(nVlrICM,"@E 999,999,999.99"),;
		transform(nVlrIPI,"@E 999,999,999.99"),;
		transform(nVlrPIS,"@E 999,999,999.99"),;
		transform(nVlrCOF,"@E 999,999,999.99"),;
		transform(nVlrImp,"@E 999,999,999.99"),;
		transform(nPerImp,"@E 999.99" ),;
		transform(nLiquido,"@E 999,999,999.99" ),;
		transform(nCusto,"@E 999,999.9999" ),;
		transform(nCstTot, "@E 999,999,999.99"),;
		transform(nMrgBrut, "@E 999,999,999.99"),;
		transform(nPerBrut, "@E 9,999.9999"),;   //GIANE
		(cAlias)->D2_XNFORI,;
		(cAlias)->D2_XSERORI,;
		iif(nIcmOri > 0, transform(nIcmOri, "@E 999.99"),"" ),;
		cSegResp,;
		transform(nFrete, "@E 999,999,999.99"),;
		transform((cAlias)->C6_COMIS1,"@E 999.99" ),;
		iif(nPrcSeg > 0 ,transform(nPrcSeg, "@E 999,999.99"),""),;
		iif(nMrgSeg > 0, transform(nMrgSeg, "@E 999.99"),"") ,;
		cObs,;
		transform((cAlias)->C6_XPRTABR, "@E 999,999,999.99") ,;
		transform((cAlias)->D2_XTAXA, "@E 999,999,999.99") ,;
		(cAlias)->D2_XMOEDA,;
		transform(_nXCUSTO, "@E 999,999,999.99"), ;
		(cAlias)->ZA0_NAME,;
		(cAlias)->D2_CF,;
		transform( (cAlias)->(D2_DESPESA + D2_SEGURO), "@E 999,999,999.99") ,;
		(cAlias)->D2_LOTECTL,;
		(cAlias)->C6_NUMPCOM,;
		(cAlias)->C6_ITEMPC,; 
		""} ) 
	Endif


	(cAlias)->(dbSkip())
EndDo

(cAlias)->(DbCloseArea())

/* =========================================================================================================
// Emitir tambem as notas de devolu��o:
// ========================================================================================================*/

cQuery := " SELECT DISTINCT SA1.A1_GRPVEN,SA3.A3_NREDUZ,SD1.D1_DOC,SD1.D1_EMISSAO,SD1.D1_DTDIGIT,SD1.D1_FORNECE,SA1.A1_NREDUZ,SD1.D1_COD, "
cQuery += " SB1.B1_DESC,SD1.D1_QUANT,SD1.D1_TOTAL,SD1.D1_IPI,SD1.D1_PICM,SD1.D1_ALQIMP5,SD1.D1_ALQIMP6, "
cQuery += " SA1.A1_SATIV1,D1_VALIPI,SD1.D1_VALICM,SD1.D1_VALIMP5,SD1.D1_VALIMP6, "
cQuery += " SD1.D1_VUNIT,SD1.D1_LOJA,SD1.D1_NFORI,SD1.D1_SERIORI,SB1.B1_SEGMENT,SA3.A3_NOME,SD1.D1_CUSTO, "
cQuery += " SC5.C5_TPFRETE,SF1.F1_EST,C5_GRPVEN,D2_EMISSAO,D2_XTAXA,D2_XMOEDA,C6_XMEDIO,C5_EMISSAO,ZA0.ZA0_NAME, "
cQuery += " SC6.C6_NUMPCOM, SC6.C6_ITEMPC, SD1.D1_ITEM, SD1.D1_DESPESA,SD1.D1_VALFRE,SD1.D1_SEGURO ,SD1.D1_CF,SD1.D1_LOTECTL "
cQuery += " FROM " + RetSqlName("SD1") + " SD1 "
cQuery += "  LEFT JOIN " + RetSqlName("SB1") + " SB1 ON "
cQuery += "    SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cQuery += "    SB1.B1_COD = SD1.D1_COD AND "
cQuery += "    SB1.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "    SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "    SA1.A1_COD = SD1.D1_FORNECE AND "
cQuery += "    SA1.A1_LOJA = SD1.D1_LOJA AND "
cQuery += "    SA1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SF1") + " SF1 ON "
cQuery += "    SF1.F1_FILIAL = SD1.D1_FILIAL AND "
cQuery += "    SF1.F1_DOC = SD1.D1_DOC AND "
cQuery += "    SF1.F1_SERIE = SD1.D1_SERIE AND "
cQuery += "    SF1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SF2") + " SF2 ON "
cQuery += "    SF2.F2_FILIAL = SD1.D1_FILIAL AND "
cQuery += "    SF2.F2_DOC = SD1.D1_NFORI AND "
cQuery += "    SF2.F2_SERIE = SD1.D1_SERIORI AND "
cQuery += "    SF2.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSqlName("SD2") + " SD2 ON "
cQuery += "    SD2.D2_COD = SD1.D1_COD AND "
cQuery += "    SD2.D2_ITEM = SD1.D1_ITEMORI AND " 
cQuery += "    SD2.D2_SERIE = SF2.F2_SERIE AND "
cQuery += "    SD2.D2_DOC = SF2.F2_DOC AND "
cQuery += "    SD2.D2_FILIAL = SF2.F2_FILIAL AND "
cQuery += "    SD2.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON "
cQuery += "    SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND "
cQuery += "    SA3.A3_COD = SF2.F2_VEND1 AND "
cQuery += "    SA3.D_E_L_E_T_ = ' ' "
cQuery += "  LEFT JOIN " + RetSqlName("SF4") + " SF4 ON "
cquery += "    SF4.F4_FILIAL = '" + xFilial( "SF4" ) + "' AND "
cQuery += "    SF4.D_E_L_E_T_ = ' ' AND "
cQuery += "    SD1.D1_TES = SF4.F4_CODIGO "

cQuery += "    JOIN "+RetSqlName("SC9")+" SC9 ON SC9.C9_NFISCAL = SD2.D2_DOC "
cQuery += "    AND SC9.C9_PEDIDO = SD2.D2_PEDIDO "
cQuery += "    AND SC9.C9_ITEM = SD2.D2_ITEMPV "
cQuery += "	   AND SC9.C9_PRODUTO = SD2.D2_COD	"
cQuery += "    AND SC9.C9_FILIAL = SD2.D2_FILIAL "
cQuery += "    AND SC9.D_E_L_E_T_ <> '*' "

cQuery += "    JOIN " + RetSqlName("SC6") + " SC6 ON "
cQuery += "    SC6.C6_PRODUTO = SC9.C9_PRODUTO AND "
cQuery += "    SC6.C6_ITEM = SC9.C9_ITEM AND "
cQuery += "    SC6.C6_NUM = SC9.C9_PEDIDO AND "
cQuery += "    SC6.C6_FILIAL = SC9.C9_FILIAL AND "
cQuery += "    SC6.D_E_L_E_T_ = ' ' "

cQuery += "  LEFT JOIN " + RetSqlName("ZA0") + " ZA0 ON "
cQuery += "    ZA0.ZA0_CODPRI = SB1.B1_X_PRINC AND "
cquery += "    ZA0.ZA0_FILIAL = '" + xFilial( "ZA0" ) + "' AND "
cQuery += "    ZA0.D_E_L_E_T_ = ' ' "

cQuery += "  JOIN " + RetSqlName("SC5") + " SC5 ON "
cQuery += "     SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "     SC5.C5_FILIAL = SC6.C6_FILIAL AND  "
cQuery += "     SC5.D_E_L_E_T_ = ' ' "

cQuery += "WHERE "
cQuery += "  SD1.D1_FILIAL = '" + xFilial("SD1") + "' "+" "
cQuery += "  AND SD1.D1_DTDIGIT >= '" + DTOS(MV_PAR01) + "' AND SD1.D1_DTDIGIT <= '" + DTOS(MV_PAR02) + "' "
cQuery += "  AND SD1.D1_FORNECE >= '" + MV_PAR03 +"' AND SD1.D1_FORNECE <= '" + MV_PAR05 + "' "
cQuery += "  AND SD1.D1_LOJA >= '" + MV_PAR04 + "' AND SD1.D1_LOJA <= '" + MV_PAR06 + "'"
cQuery += "  AND SF2.F2_VEND1 >= '" + MV_PAR09 + "' AND SF2.F2_VEND1 <= '" + MV_PAR10 + "'"
cQuery += "  AND SD1.D1_COD >= '" + MV_PAR11 + "' AND SD1.D1_COD <= '" + MV_PAR12 + "'"
cQuery += "  AND SA1.A1_SATIV1 >= '" + MV_PAR07 + "' AND SA1.A1_SATIV1 <='" + MV_PAR08 + "' "
cQuery += "  AND SB1.B1_SEGMENT >= '" + MV_PAR13 + "' AND SB1.B1_SEGMENT <='" + MV_PAR14 + "' "
cQuery += "  AND SB1.B1_X_PRINC >= '" + MV_PAR16 + "' AND SB1.B1_X_PRINC <= '" + MV_PAR17 + "' "
cQuery += "  AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "  //somente notas fiscais que geram duplicatas e nao de SERVI�O
cQuery += "  AND SD1.D_E_L_E_T_ = ' ' AND SF1.F1_TIPO = 'D' "
cQuery += " ORDER BY SD1.D1_DOC,SD1.D1_COD "

cAlias:= GetNextAlias()
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

dbSelectArea(cAlias)
//dbGoTop()
While !EOF()
	cChaveD1 := (cAlias)->(D1_DOC+D1_EMISSAO+D1_NFORI+D1_SERIORI+D1_COD)
	nD1_QUANT   := 0  
	nD1_TOTAL   := 0  
	nD1_VALIPI  := 0  
	nD1_VALICM  := 0  
	nD1_VLIMP5 := 0  
	nD1_VLIMP6 := 0  
	nD1_CUSTO   := 0 
	nDespesa := 0
	
	If (MV_PAR15 == 3 .and. nMrgBrut <= 0) .or.; //imprimir somente os registros com margem bruta negativa
		MV_PAR15 == 1  //todos os registros

		cSegVen := ""
		DbSelectArea("SX5")
		DbSetOrder(1)
		If DbSeek(xFilial("SX5")+"T3"+(cAlias)->A1_SATIV1)
			cSegVen := X5DESCRI()
		Endif

		cSegResp := ""
		DbSelectArea("ACY")
		DbSetOrder(1)
		If DbSeek(xFilial("ACY")+(cAlias)->B1_SEGMENT)
			cSegResp := ACY->ACY_DESCRI
		endif

		cGrpVen := iif( EMPTY((cAlias)->C5_GRPVEN), (cAlias)->A1_GRPVEN, (cAlias)->C5_GRPVEN )
		DbSelectArea("ACY")
		DbSetOrder(1)
		If DbSeek(xFilial("ACY")+cGrpVen)
			cGrpVen := ACY->ACY_DESCRI
		endif

		DbSelectArea(cAlias)

		dEmissao := strzero(val( right((cAlias)->D1_DTDIGIT,2)), 2) + '/' + ;
		strzero(val( substr((cAlias)->D1_DTDIGIT,5,2)),2)  + '/'+  left((cAlias)->D1_DTDIGIT,4)
		
		nPerImp  := (cAlias)->D1_IPI + (cAlias)->D1_PICM + (cAlias)->D1_ALQIMP5 + (cAlias)->D1_ALQIMP6
		nVUNIT	:= (cAlias)->D1_VUNIT

		cTpFrete :=""
		if (cAlias)->C5_TPFRETE == 'C'
			cTpFrete := 'CIF'
		elseif (cAlias)->C5_TPFRETE == 'F'
			cTpFrete := 'FOB'
		endif

		cA3_NOME    := (cAlias)->A3_NOME
		cD1_DOC     := (cAlias)->D1_DOC
		cF1_EST     := (cAlias)->F1_EST
		cD1_FORNECE := (cAlias)->D1_FORNECE
		cD1_LOJA     := (cAlias)->D1_LOJA
		cA1_NREDUZ  := (cAlias)->A1_NREDUZ
		cD1_COD     := (cAlias)->D1_COD
		cB1_DESC    := (cAlias)->B1_DESC
		cD1_NFORI   := (cAlias)->D1_NFORI
		cD1_SERIOR := (cAlias)->D1_SERIORI
		cZA0_NAME   := (cAlias)->ZA0_NAME
		cNumPedCli   := (cAlias)->C6_NUMPCOM
		cItemPedCli   := (cAlias)->C6_ITEMPC

		cCF := 	(cAlias)->D1_CF
		nDespesa := (cAlias)->(D1_DESPESA+D1_SEGURO)
		cLote :=	(cAlias)->D1_LOTECTL		

		//-----------------------------------------------
		//Aglutina��o de produtos
		//-----------------------------------------------
		//IF !EMPTY((cAlias)->(D1_DOC+D1_EMISSAO+D1_NFORI+D1_SERIORI+D1_COD))
		//	while cChaveD1 == (cAlias)->(D1_DOC+D1_EMISSAO+D1_NFORI+D1_SERIORI+D1_COD)
				nD1_QUANT    := (cAlias)->D1_QUANT   
				nD1_TOTAL    := (cAlias)->D1_TOTAL   
				nD1_VALIPI   := (cAlias)->D1_VALIPI  
				nD1_VALICM   := (cAlias)->D1_VALICM  
				nD1_VLIMP5   := (cAlias)->D1_VALIMP5 
				nD1_VLIMP6   := (cAlias)->D1_VALIMP6 
				nD1_CUSTO    := (cAlias)->D1_CUSTO 
		//		if cChaveD1 != (cAlias)->(D1_DOC+D1_EMISSAO+D1_NFORI+D1_SERIORI+D1_COD)
		//			exit
		//		else 
		//			(cAlias)->(dbSkip())	
		//		endif
		//	enddo
		//ENDIF

		
		nVlrImp  := nD1_VALICM  + nD1_VLIMP5 + nD1_VLIMP6    // + (cAlias)->D1_VALIPI, ipi nao esta embutido no d1_total
		nLiquido := ( nD1_TOTAL - nVlrImp ) * -1
		nCusto   := nD1_CUSTO / nD1_QUANT   //(cAlias)->B2_CM1
		nVlBrut  := ( nD1_TOTAL + nD1_VALIPI ) * (-1)
		
		nVlrICM := (cAlias)->D1_VALICM
		nVlrIPI := (cAlias)->D1_VALIPI
		nVlrPIS := (cAlias)->D1_VALIMP6
		nVlrCOF := (cAlias)->D1_VALIMP5


		nCstTot  := (nD1_CUSTO * -1) //((cAlias)->D1_QUANT * -1) *  nCusto
		nMrgBrut := nLiquido - nCstTot
		nPerBrut := NOROUND( (nMrgBrut / nLiquido) * 100,2)

		aadd(aDados, {"Devolu��o",;
		cGrpVen,;
		cSegVen,;
		cA3_NOME,;
		cD1_DOC ,;
		ctod(dEmissao),;
		cTpFrete,;
		cF1_EST     ,;
		cD1_FORNEC ,;
		cD1_LOJA ,;
		cA1_NREDUZ  ,;
		cD1_COD     ,;
		cB1_DESC    ,;
		transform(nD1_QUANT * (-1),"@E 9,999,999.9999"),;
		transform(nVlBrut, "@E 999,999,999.99"),;
		transform( nVUNIT, "@E 99,999.999999"),;
		transform(nVlrICM * (-1),"@E 999,999,999.99"),;
		transform(nVlrIPI * (-1),"@E 999,999,999.99"),;
		transform(nVlrPIS * (-1),"@E 999,999,999.99"),;
		transform(nVlrCOF * (-1),"@E 999,999,999.99"),;
		transform(nVlrImp * (-1),"@E 999,999,999.99"),;
		transform(nPerImp, "@E 999.99" ),;
		transform(nLiquido, "@E 999,999,999.99" ),;
		transform(nCusto, "@E 999,999.9999" ),;
		transform(nCstTot, "@E 999,999,999.99"),;
		transform(nMrgBrut, "@E 999,999,999.99"),;
		transform(nPerBrut, "@E 9,999.99"),;
		cD1_NFORI,;
		cD1_SERIOR,;
		"",;
		cSegResp,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		cZA0_NAME,;
		cCF,;
		transform( nDespesa, "@E 999,999,999.99"),;
		cLote ,;
		cNumPedCli,;
		cItemPedCli,;
		""} ) 		
	Endif

	dbSelectArea(cAlias)
	(cAlias)->(dbSkip())
EndDo

If len(aDados) == 0
	MsgInfo("N�o existem notas a serem impressas, de acordo com os par�metros informados!","Aten��o")
Else
	DlgToExcel({ {"GETDADOS", "Relatorio de Margem", aCabec, aDados} })
Endif

(cAlias)->(DbCloseArea())

Return
