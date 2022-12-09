#include "protheus.ch"
#include "topconn.ch"

/*/
+-----------------------------------------------------------------------
----------------------------------------------------------------------
/*/
User Function MPFRETE()
	Local aCabExcel   :={}
	Local aItensExcel :={}

	Local N
	Local cPorta := "LPT1"
	Local cCodNot
	Local cCodVol
	Local lConf :=  .F.
	LOCAL oButton := {}
	LOCAL oDlg, oSay
	LOCAL oFont:= TFont():New("Courier New",,-12,.T.,.T.)
	LOCAL aFont:= TFont():New("Arial",,-12,.T.)
	LOCAL bFont:= TFont():New("Arial",,-14,.T.,.T.)
	PRIVATE cLoteOrig := " "

	EmDe		:= date()
	EmAte		:= date()
	TPDe		:= SPACE(2)
	TPAte		:= SPACE(2)

	// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
	AADD(aCabExcel, {"FILIAL" ,"C", 02, 0})
	AADD(aCabExcel, {"PEDIDO" ,"C", 06, 0})
	AADD(aCabExcel, {"DATA_DIGITACAO_NF_ENTRADA" ,"C", 10, 0})
	AADD(aCabExcel, {"CLIENTE_FORNECEDOR" ,"C", 06, 0})
	AADD(aCabExcel, {"LOJA" ,"C", 02, 0})

	AADD(aCabExcel, {"NOTA_FISCAL" ,   "C", 09, 0})
	AADD(aCabExcel, {"ITEM" ,"C", 02, 0})
	AADD(aCabExcel, {"TIPO_NOTA" ,"C", 01, 0})
	AADD(aCabExcel, {"DATA_EMISSAO_NF_SAIDA" ,"C", 10, 0})
	AADD(aCabExcel, {"DATA_ENTREGA_PED" ,"C", 10, 0})
	AADD(aCabExcel, {"CLIENTE_ENTREGA" ,"C", 06, 0})
	AADD(aCabExcel, {"RAZAO_SOCIAL" ,"C", 45, 0})
	AADD(aCabExcel, {"CIDADE" ,"C", 50, 0})
	AADD(aCabExcel, {"ESTADO" ,"C",02, 0})
	AADD(aCabExcel, {"PAIS" ,"C",30, 0})

	AADD(aCabExcel, {"COD_PRODUTO" ,"C", 15, 0})
	AADD(aCabExcel, {"PRODUTO" ,"C", 100, 0})
	AADD(aCabExcel, {"PESO_LIQUIDO" ,"N", 16, 2})
	AADD(aCabExcel, {"PESO_BRUTO" ,"N", 16, 2})
	AADD(aCabExcel, {"VALOR" ,"N", 16, 2})

	AADD(aCabExcel, {"TIPO_PRODUTO" ,"C", 02, 0})
	AADD(aCabExcel, {"LOTE" ,"C", 15, 0})
	AADD(aCabExcel, {"COD_TRANSP" ,"C", 06, 0})
	AADD(aCabExcel, {"TRANSPORTADORA" ,"C", 50, 0})
	AADD(aCabExcel, {"NUM_RISCO" ,"C", 05, 0})
	AADD(aCabExcel, {"COD_ONU" ,"C", 10, 0})
	AADD(aCabExcel, {"TES" ,"C", 4, 0})
	AADD(aCabExcel, {"NAT_OPERACAO" ,"C", 100, 0})
	AADD(aCabExcel, {"MOV_ESTOQUE" ,"C", 3, 0})
	AADD(aCabExcel, {"LOTE_MULTIPLO" ,"C", 2, 0})
	AADD(aCabExcel, {"EMBALAGEM" ,"C", 15, 0})
	AADD(aCabExcel, {"INCOTERM" ,"C", 01, 0})
	AADD(aCabExcel, {"TIPO_CARGA" ,"C", 10, 0})
	AADD(aCabExcel, {"CHAVE_NF" ,"C", 50, 0})
	//AADD(aCabExcel, {"FABRICANTE"  ,"C",50, 0})
	//AADD(aCabExcel, {"ORIGEM_LOTE" ,"C",20, 0})
	AADD(aCabExcel, {" " ,"C",1, 0})

	DEFINE MSDIALOG oDlg FROM 0,0 TO 190,280 PIXEL TITLE "Preencha os parametros"
	@ 010, 07  SAY OemToAnsi("Emissão De:")  FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 010, 075 MSGET oGet VAR EmDe			SIZE 50,10 OF oDlg  PIXEL
	@ 025, 07  SAY OemToAnsi("Emissão Ate:")	FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 025, 075 MSGET oGet VAR EmAte			SIZE 50,10 OF oDlg PIXEL
	@ 040, 07  SAY OemToAnsi("Tipo De:")  FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 040, 075 MSGET oGet VAR TPDe			F3 '02' SIZE 15,10 OF oDlg  PIXEL
	@ 055, 07  SAY OemToAnsi("Tipo Ate:")	FONT aFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 055, 075 MSGET oGet VAR TPAte			F3 '02' SIZE 15,10 OF oDlg PIXEL

	//oButton:=tButton():New(070,65,"CONFIRMA",oDlg,(lConf := .T., {||oDlg:End()}),60,20,,,,.T.)   
	@75, 65 BUTTON "CONFIRMA" SIZE 50,15 OF oDlg PIXEL ACTION (lConf := .T.,oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED

	IF lConf
		MsgRun("Favor Aguardar Processando dados....", "Selecionando os Registros",{|| GProcItens(aCabExcel, @aItensExcel)})
		MsgRun("Favor Aguardar Gerando dados....", "Exportando os Registros para o Excel",{||DlgToExcel({{"GETDADOS","MAPA DE ANALISE DE FRETE - ENTRADAS E SAIDAS",aCabExcel,aItensExcel}})})
	Else
		Alert("Cancelado pelo Operador!")
	Endif
Return()


Static Function GProcItens(aHeader, aCols)
	Local aItem
	Local nX

	CQUERY := " SELECT * FROM ( SELECT F2_FILIAL FILIAL,SF2.F2_DOC NOTA_FISCAL,SD2.D2_ITEM ITEM, F2_TIPO TIPO_NOTA, "
	CQUERY += " '  ' DATA_DIGITACAO_NF_ENTRADA, "
	CQUERY += " RTRIM((substr(SF2.F2_EMISSAO,7,2))||'/'||(substr(SF2.F2_EMISSAO,5,2))||'/'||(substr(SF2.F2_EMISSAO,0,4))) DATA_EMISSAO_NF_SAIDA,  "
	CQUERY += " RTRIM((substr(SC5.C5_XENTREG,7,2))||'/'||(substr(SC5.C5_XENTREG,5,2))||'/'||(substr(SC5.C5_XENTREG,0,4))) DATA_ENTREGA_PED,   "
	CQUERY += " SF2.F2_CLIENTE CLIENTE_FORNECEDOR , F2_LOJA LOJA , SF2.F2_CLIENT CLIENTE_ENTREGA,   "
	CQUERY += " SF2.F2_LOJENT LOJA_ENTREGA,  "
	CQUERY += " A1_NOME RAZAO_SOCIAL,A1_MUN CIDADE, A1_EST ESTADO,A1_CODPAIS PAIS,   "
	CQUERY += " SD2.D2_PEDIDO PEDIDO,  "
	CQUERY += " SD2.D2_COD COD_PRODUTO,PRD.B1_DESC PRODUTO,    "
	CQUERY += " PRD.B1_TIPO TIPO_PRODUTO,  "
	CQUERY += " SF2.F2_TPFRETE INCOTERM, D2_TOTAL VALOR, "
	CQUERY += " SD2.D2_QUANT PESO_LIQUIDO, (SD2.D2_QUANT * PRD.B1_PESBRU) PESO_BRUTO,   "
	CQUERY += " SD2.D2_LOTECTL LOTE,     "
	CQUERY += " SF2.F2_TRANSP COD_TRANSP, SA4.A4_NOME TRANSPORTADORA, PRD.B1_NUMRIS NUM_RISCO, PRD.B1__CODONU COD_ONU, SD2.D2_TES AS TES , "
	CQUERY += " SF4.F4_TEXTO NAT_OPERACAO, F4_ESTOQUE MOV_ESTOQUE, B1_LOTEMUL LOTE_MULTIPLO, B1_EMB EMBALAGEM,B1_TIPCAR TIPO_CARGA, F2_CHVNFE CHAVE_NF   "
	CQUERY += " FROM "+RETSQLNAME("SD2")+" SD2  "
	CQUERY += " INNER JOIN "+RETSQLNAME("SF2")+" SF2 ON F2_FILIAL||F2_DOC||F2_CLIENTE||F2_LOJA = D2_FILIAL||D2_DOC||D2_CLIENTE||D2_LOJA AND F2_TIPO  = 'N' AND SF2.D_E_L_E_T_ <> '*' "
	CQUERY += " INNER JOIN "+RETSQLNAME("SA1")+" CLI ON F2_CLIENT||SF2.F2_LOJENT = A1_COD||A1_LOJA AND CLI.D_E_L_E_T_ <> '*' "
	CQUERY += " INNER JOIN "+RETSQLNAME("SC5")+" SC5 ON D2_FILIAL||D2_PEDIDO||D2_CLIENTE||D2_LOJA = C5_FILIAL||C5_NUM||C5_CLIENTE||SC5.C5_LOJACLI AND SC5.D_E_L_E_T_ <> '*' "
	CQUERY += " INNER JOIN "+RETSQLNAME("SB1")+" PRD ON PRD.B1_COD = D2_COD AND PRD.D_E_L_E_T_ <> '*'  "
	CQUERY += " INNER JOIN "+RETSQLNAME("SF4")+" SF4 ON SF4.F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = SD2.D2_FILIAL "
	CQUERY += " LEFT JOIN  "+RETSQLNAME("SA4")+" SA4 ON SA4.A4_COD = SF2.F2_TRANSP  AND SA4.D_E_L_E_T_ <> '*'  "
	CQUERY += " WHERE D2_EMISSAO BETWEEN '"+ DTOS(emDe) +"' and '"+ DTOS(emAte) +"' AND  PRD.B1_TIPO BETWEEN '"+(TPDe) +"' and '"+(TPAte) +"' "
	CQUERY += " AND SD2.D_E_L_E_T_ <> '*'  "
	CQUERY += " UNION ALL  "
	CQUERY += " SELECT F2_FILIAL FILIAL, "
	CQUERY += " SF2.F2_DOC NOTA_FISCAL, SD2.D2_ITEM ITEM, F2_TIPO TIPO_NOTA,  "
	CQUERY += " '  ' DATA_DIGITACAO_NF_ENTRADA, "
	CQUERY += " RTRIM((substr(SF2.F2_EMISSAO,7,2))||'/'||(substr(SF2.F2_EMISSAO,5,2))||'/'||(substr(SF2.F2_EMISSAO,0,4))) DATA_EMISSAO_NF_SAIDA, "
	CQUERY += " RTRIM((substr(SC5.C5_XENTREG,7,2))||'/'||(substr(SC5.C5_XENTREG,5,2))||'/'||(substr(SC5.C5_XENTREG,0,4))) DATA_ENTREGA_PED,   "
	CQUERY += " SF2.F2_CLIENTE CLIENTE_FORNECEDOR, F2_LOJA LOJA , SF2.F2_CLIENT CLIENTE_ENTREGA,  "
	CQUERY += " SF2.F2_LOJENT LOJA_ENTREGA,   "
	CQUERY += " A2_NOME RAZAO_SOCIAL,A2_MUN CIDADE, A2_EST ESTADO, A2_CODPAIS PAIS, "
	CQUERY += " SD2.D2_PEDIDO PEDIDO,  "
	CQUERY += " SD2.D2_COD COD_PRODUTO,PRD.B1_DESC PRODUTO,  "
	CQUERY += " PRD.B1_TIPO TIPO_PRODUTO,  "
	CQUERY += " SF2.F2_TPFRETE INCOTERM, D2_TOTAL VALOR, "
	CQUERY += " SD2.D2_QUANT PESO_LIQUIDO, (SD2.D2_QUANT* PRD.B1_PESBRU) PESO_BRUTO,   "
	CQUERY += " SD2.D2_LOTECTL LOTE,      "
	CQUERY += " SF2.F2_TRANSP COD_TRANSP, SA4.A4_NOME TRANSPORTADORA, PRD.B1_NUMRIS NUM_RISCO, PRD.B1__CODONU CODONU, SD2.D2_TES AS TES , "
	CQUERY += " SF4.F4_TEXTO NAT_OPERACAO, F4_ESTOQUE MOV_ESTOQUE, B1_LOTEMUL LOTE_MULTIPLO, B1_EMB EMBALAGEM,B1_TIPCAR TIPO_CARGA, F2_CHVNFE CHAVE_NF   "
	CQUERY += " FROM "+RETSQLNAME("SD2")+" SD2  "
	CQUERY += " INNER JOIN "+RETSQLNAME("SF2")+" SF2 ON F2_FILIAL||F2_DOC||F2_CLIENTE||F2_LOJA = D2_FILIAL||D2_DOC||D2_CLIENTE||D2_LOJA AND F2_TIPO  = 'B' AND SF2.D_E_L_E_T_ <> '*'"
	CQUERY += " INNER JOIN "+RETSQLNAME("SA2")+" FORN ON F2_CLIENT||SF2.F2_LOJENT = A2_COD||A2_LOJA AND FORN.D_E_L_E_T_ <> '*'    "
	CQUERY += " INNER JOIN "+RETSQLNAME("SC5")+" SC5 ON D2_FILIAL||D2_PEDIDO||D2_CLIENTE||D2_LOJA = C5_FILIAL||C5_NUM||C5_CLIENTE||SC5.C5_LOJACLI AND SC5.D_E_L_E_T_ <> '*'    "
	CQUERY += " INNER JOIN "+RETSQLNAME("SB1")+" PRD ON PRD.B1_COD = D2_COD AND PRD.D_E_L_E_T_ <> '*'   "
	CQUERY += " INNER JOIN "+RETSQLNAME("SF4")+" SF4 ON SF4.F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = SD2.D2_FILIAL "
	CQUERY += " LEFT JOIN  "+RETSQLNAME("SA4")+" SA4 ON SA4.A4_COD = SF2.F2_TRANSP  AND SA4.D_E_L_E_T_ <> '*' "
	CQUERY += " WHERE D2_EMISSAO BETWEEN '"+ DTOS(emDe) +"' and '"+ DTOS(emAte) +"' AND  PRD.B1_TIPO BETWEEN '"+(TPDe) +"' and '"+(TPAte) +"' "
	CQUERY += " AND SD2.D_E_L_E_T_ <> '*'  "
	CQUERY += " UNION ALL  "
	CQUERY += "    SELECT F1_FILIAL FILIAL,  "
	CQUERY += "    SF1.F1_DOC NOTA_FISCAL, SD1.D1_ITEM ITEM, F1_TIPO TIPO_NOTA, "
	CQUERY += "    RTRIM((substr(SF1.F1_DTDIGIT,7,2))||'/'||(substr(SF1.F1_DTDIGIT,5,2))||'/'||(substr(SF1.F1_DTDIGIT,0,4))) DATA_DIGITACAO_NF_ENTRADA,  "
	CQUERY += "    '      ' DATA_EMISSAO_NF,   "
	CQUERY += "    '      ' DATA_ENTREGA_PED,   "
	CQUERY += "    SF1.F1_FORNECE CLIENTE_FORNECEDOR, F1_LOJA LOJA , 'IMCD ENTRADA' CLIENTE_ENTREGA, "
	CQUERY += "    SF1.F1_LOJA LOJA_ENTREGA, "
	CQUERY += "    A2_NOME RAZAO_SOCIAL,A2_MUN CIDADE, A2_EST ESTADO, A2_CODPAIS PAIS,"
	CQUERY += "    SD1.D1_PEDIDO PEDIDO,  "
	CQUERY += "    SD1.D1_COD COD_PRODUTO,PRD.B1_DESC PRODUTO,   "
	CQUERY += "    PRD.B1_TIPO TIPO_PRODUTO,  "
	CQUERY += "    SF1.F1_TPFRETE INCOTERM, D1_TOTAL VALOR, "
	CQUERY += "    SD1.D1_QUANT PESO_LIQUIDO, (SD1.D1_QUANT*PRD.B1_PESBRU) PESO_BRUTO, "
	CQUERY += "    SD1.D1_LOTECTL LOTE, "
	CQUERY += "    SF1.F1_TRANSP COD_TRANSP, SA4.A4_NOME TRANSPORTADORA, PRD.B1_NUMRIS NUM_RISCO, PRD.B1__CODONU COD_ONU, SD1.D1_TES AS TES , "
	CQUERY += "    SF4.F4_TEXTO NAT_OPERACAO, F4_ESTOQUE MOV_ESTOQUE, B1_LOTEMUL LOTE_MULTIPLO, B1_EMB EMBALAGEM,B1_TIPCAR TIPO_CARGA, F1_CHVNFE CHAVE_NF   "
	CQUERY += "    FROM "+RETSQLNAME("SD1")+" SD1  "
	CQUERY += "    INNER JOIN "+RETSQLNAME("SF1")+" SF1 ON F1_FILIAL||F1_DOC||F1_FORNECE||F1_LOJA = D1_FILIAL||D1_DOC||D1_FORNECE||D1_LOJA AND F1_TIPO IN ('N') AND SF1.D_E_L_E_T_ <> '*' "
	CQUERY += "    INNER JOIN "+RETSQLNAME("SA2")+" FORN ON F1_FORNECE||SF1.F1_LOJA = A2_COD||A2_LOJA AND FORN.D_E_L_E_T_ <> '*'  "
	CQUERY += "    INNER JOIN "+RETSQLNAME("SB1")+" PRD ON PRD.B1_COD = D1_COD AND PRD.D_E_L_E_T_ <> '*' "
	CQUERY += "    INNER JOIN "+RETSQLNAME("SF4")+" SF4 ON SF4.F4_CODIGO = D1_TES AND SF4.D_E_L_E_T_ <> '*' AND SF4.F4_FILIAL = D1_FILIAL "
	CQUERY += "    LEFT JOIN  "+RETSQLNAME("SA4")+" SA4 ON SA4.A4_COD = SF1.F1_TRANSP  AND SA4.D_E_L_E_T_ <> '*' "
	CQUERY += "    WHERE F1_DTDIGIT BETWEEN '"+ DTOS(emDe) +"' and '"+ DTOS(emAte) +"' AND  PRD.B1_TIPO BETWEEN '"+(TPDe) +"' and '"+(TPAte) +"' "
	CQUERY += "    AND SD1.D_E_L_E_T_ <> '*' ) "
	CQUERY += " ORDER BY 1,2,3  "

	cQuery := ChangeQuery(cQuery)
	TCQUERY CQUERY NEW ALIAS TRB


	DbSelectArea("TRB")
	DbGotop()
	'
	While TRB->(!EOF())

		aItem := Array(Len(aHeader))
		For nX := 1 to Len(aHeader)

			IF aHeader[nX][1] $ "PAIS|EMBALAGEM| TIPO_CARGA"
				aItem[nX] := BSCDESC( aHeader[nX][1] , TRB->&(aHeader[nX][1]))
				/*		ELSEIF aHeader[nX][1] == "FABRICANTE"
				aItem[nX] := BSCLOTE( TRB->COD_PRODUTO ,TRB->LOTE)
				ELSEIF aHeader[nX][1] == "ORIGEM_LOTE"
				aItem[nX] := cLoteOrig
				cLoteOrig := ' '
				*/
			ELSEIF aHeader[nX][1] == "CHAVE_NF"
				aItem[nX] := CHR(160)+TRB->&(aHeader[nX][1])
			ELSEIF aHeader[nX][1] == " "
				aItem[nX] := ' '
			ELSE
				aItem[nX] := TRB->&(aHeader[nX][1])
			ENDIF

		Next nX

		AADD(aCols,aItem)   ////aitem= campo

		aItem := {}
		TRB->(dbSkip())
	EndDO

	DbSelectArea("TRB")
	Dbclosearea("TRB")

Return()

STATIC FUNCTION BSCDESC(CCAMPO,cValor)
	Local cRet := " "

	IF CCAMPO == "PAIS"
		cRet := Posicione("CCH",1,xFilial("CCH") + cValor,"CCH->CCH_PAIS")
	ELSEIF CCAMPO == "EMBALAGEM"
		cRet :=  Posicione("SZ2", 1, xFilial("SZ2") + cValor, "Z2_DESC")
	ELSEIF CCAMPO == "TIPO_CARGA"
		//cRet := Posicione("DB0",1,xFilial( "DB0" ) + cValor,"DB0->DB0_DESMOD" )
		IF cValor == '000001'
			cRet := 'GRANEIS'
		ELSEIF cValor == '000002'
			cRet := 'SECA'
		ELSEIF cValor =='000003'
			cRet := 'AMOSTRA'
		ENDIF
	ENDIF

Return(cRet)


STATIC FUNCTION BSCLOTE(cPrd,cLote)

	Local cRet   := ""
	Local cAlias := ''

	cPrd := SUBSTR(cPrd,1,9)

	IF TRB->TES >= '500'
		cAlias := GetNextAlias()
		cQry := " SELECT D1_FABRIC,D1_LOJFABR,  D1_FORNECE, D1_LOJA "
		cQry += " FROM "+RETSQLNAME("SD1")+" "
		cQry += " WHERE  D1_LOTECTL = '"+cLote+"' "
		cQry += " AND SUBSTR(D1_COD,1,9) = '"+cPrd+"' "
		cQry += " AND D_E_L_E_T_ <> '*' "
		cQry += " ORDER BY R_E_C_N_O_ "

		cQry := ChangeQuery(cQry)

		TcQuery cQry ALIAS (cAlias) NEW

		IF !EMPTY( (cAlias)->D1_FABRIC)
			cCHVSA2 := (cAlias)->D1_FABRIC + (cAlias)->D1_LOJFABR
		ELSE
			cCHVSA2 := (cAlias)->D1_FORNECE + (cAlias)->D1_LOJA
		ENDIF

		If Select(cAlias) > 0
			(cAlias)->( dbCloseArea() )
		EndIf
	ELSE

		cCHVSA2 := TRB->CLIENTE_FORNECEDOR+TRB->LOJA

	Endif
	DbSelectArea("SA2")
	DbSetOrder(1)

	if DbSeek(xFilial("SA2") + cCHVSA2 )

		cRet	:= SA2->A2_NOME
		cLoteOrig := SA2->A2_CODPAIS
		cLoteOrig := Posicione("CCH",1,xFilial("CCH") + cLoteOrig,"CCH->CCH_PAIS")

	Endif

Return(cRet)
