#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

User Function MSD2460()
	Local cSql    := ""
	Local cSqlErr := ""
	Local aArea   := GetArea()
	Local cNfOri  := ""
	Local cSerOri := ""
	Local cOrigem := ""

	/*========================================================================
	Comandos abaixo gravam o numero da NF e Serie para os casos de venda em
	consignacao. O usuario digita o numero e serie no item do pedido de vendas
	e este P.E. deve passar as informacoes para o SD2.
	========================================================================*/ 
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV)

	cNFOri  := SC6->C6_XNFORIG
	cSerOri := SC6->C6_XSERORI
	cCCusto := SA1->A1_XCUSTO
	cItemCC := SA1->A1_XITEMCC                          

	cCodFCI := " "
	
	dbSelectArea("SD2")
	cOrigem:= SubStr(SD2->D2_CLASFIS,1,1)
	cCSTrib:= SubStr(SD2->D2_CLASFIS,2,2)

	If ( cOrigem $"1-2-3-4-5-6-8" .And. cCSTrib $ "00-10-20-30-40-41-50-51-60-70-90" )
	
		cCodFCI := SC6->C6_FCICOD

		if !empty(SD2->D2_LOTECTL) .and. empty(SD2->D2_FCICOD)
			cCodFCI := FCIUTILS():getFciCode(SD2->D2_COD,SD2->D2_LOTECTL)
		endif

	endif

	RecLock("SD2",.F.) 
	SD2->D2_XNFORI  := cNfOri
	SD2->D2_XSERORI := cSerOri                      
	SD2->D2_CCUSTO  :=  cCCusto
	SD2->D2_ITEMCC  :=  cItemCC
	IF EMPTY(SD2->D2_FCICOD)
		SD2->D2_FCICOD  := cCodFCI
	ENDIF
	//SD2->D2_CLASFIS := IIF(LEN(ALLTRIM(SD2->D2_CLASFIS))==2,cOrigem+cClasfis,cClasfis)//GRAVAÇÃO DO CST COM A ORIGEM DO PRODUTO OTACILIO 25/10/12 COMENTADO EM 08/05/2013 POR OTACILIO
	MsUnlock()

	// Gravar numero da nota na amostra
	// Gravar comprando na amostra
	cSql := "UPDATE " + RetSqlName("ZX3") + " "
	cSql += "SET "
	cSql += "  ZX3_DOC   = '" + SD2->D2_DOC   + "', "
	cSql += "  ZX3_SERIE = '" + SD2->D2_SERIE + "' "
	cSql += "WHERE "
	cSql += "  D_E_L_E_T_ = ' ' "
	cSql += "  AND ZX3_FILIAL = '" + xFilial("ZX3") + "' "
	cSql += "  AND ZX3_PEDIDO = '" + SD2->D2_PEDIDO + "' "
	If TCSqlExec(cSql) < 0
		cSqlErr := TCSqlError()
		HS_MsgInf("Ocorreu um erro na gravação do número e serie da nota no controle de amostras." + Chr(10) + Chr(13) + cSqlErr, "Atenção!!!", "Controle de amostras (MSD2460)")
	EndIf

	cSql := "UPDATE " + RetSqlName("ZX3") + " ZX3UPD "
	cSql += "SET ZX3_COMP = '1' "
	cSql += "WHERE "
	cSql += "  D_E_L_E_T_ = ' ' "
	cSql += "  AND ZX3_FILIAL =  '" + xFilial("ZX3")  + "' "
	cSql += "  AND ZX3_CLIENT =  '" + SD2->D2_CLIENTE + "' " // Só para peformance
	cSql += "  AND ZX3_LOJA   =  '" + SD2->D2_LOJA    + "' " // Só para peformance
	cSql += "  AND EXISTS "
	cSql += "  ( "
	cSql += "   SELECT 'X' "  // Verifica se para o cliente e familia em questão, se existe um envio de amostra
	cSql += "   FROM "
	cSql += "     " + RetSqlName("ZX3") + " ZX3 JOIN " + RetSqlName("ZX4") + " ZX4 ON "
	cSql += "       ZX3.D_E_L_E_T_ = ' ' AND "
	cSql += "       ZX4.D_E_L_E_T_ = ' ' AND "
	cSql += "       ZX3.ZX3_FILIAL = '" + xFilial("ZX3") + "' AND "
	cSql += "       ZX4.ZX4_FILIAL = '" + xFilial("ZX4") + "' AND "
	cSql += "       ZX4.ZX4_NUM    = ZX4.ZX4_NUM "
	cSql += "     JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql += "       SB1.D_E_L_E_T_ = ' ' AND "
	cSql += "       SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
	cSql += "       SB1.B1_COD     = ZX4.ZX4_PRODUT "
	cSql += "   WHERE "
	cSql += "     ZX3.ZX3_CLIENT = '" + SD2->D2_CLIENTE + "' "
	cSql += "     AND ZX3.ZX3_LOJA   = '" + SD2->D2_LOJA    + "' "
	cSql += "     AND ZX3.ZX3_PEDIDO <> '" + Space(Len(SD2->D2_PEDIDO)) + "' "
	cSql += "     AND SB1.B1_FAM     =  '" + SB1->B1_FAM + "' "
	cSql += "  ) "
	cSql += "  AND EXISTS " // Verifica se o item da ZX3 é da mesma familia 
	cSql += "  ( "
	cSql += "   SELECT 'X' "
	cSql += "   FROM "
	cSql += "     " + RetSqlName("ZX4") + " ZX4 JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql += "       SB1.D_E_L_E_T_ = ' '  AND "
	cSql += "       SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
	cSql += "       SB1.B1_COD     = ZX4.ZX4_PRODUT "
	cSql += "   WHERE "
	cSql += "     ZX4.ZX4_NUM =  ZX3UPD.ZX3_NUM "
	cSql += "     AND SB1.B1_FAM =  '" + SB1->B1_FAM + "' "
	cSql += "  ) "
	cSql += "  AND NOT EXISTS " // Verifica se o item que esta sendo faturado não é um envio de amostra
	cSql += "  ( "
	cSql += "   SELECT 'X' "
	cSql += "   FROM "
	cSql += "     " + RetSqlName("ZX3") + " ZX3 "
	cSql += "   WHERE "
	cSql += "     ZX3.D_E_L_E_T_ = ' ' "
	cSql += "     AND ZX3.ZX3_FILIAL = '" + xFilial("ZX3")  + "' "
	cSql += "     AND ZX3.ZX3_CLIENT = '" + SD2->D2_CLIENTE + "' "
	cSql += "     AND ZX3.ZX3_LOJA   = '" + SD2->D2_LOJA    + "' "
	cSql += "     AND ZX3.ZX3_PEDIDO = '" + SD2->D2_PEDIDO  + "' "
	cSql += "  ) "
	If TCSqlExec(cSql) < 0
		cSqlErr := TCSqlError()
		HS_MsgInf("Ocorreu um erro na gravação do status 'comprando' do controle de amostras." + Chr(10) + Chr(13) + cSqlErr, "Atenção!!!", "Controle de amostras (MSD2460)")
	EndIf

	// Tratamento da eliminacao de residuos

	nPerc := GetMV("MV_PERCRES")
	If ( SD2->D2_QUANT / SC6->C6_QTDVEN ) * 100 >= nPerc
		MaResdoFat(,.T.,.F.)
		SC6->(MaLiberOk({ SC6->C6_NUM },.T.))
	Endif


	RestArea(aArea)
Return
