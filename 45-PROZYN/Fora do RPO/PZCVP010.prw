#include 'protheus.ch'

User function PZCVP010(cPedido, nOpc, lEnvPvFin)

	Local aArea	:= GetArea()
	Local lRet	:= .F.

	Default cPedido		:= ""
	Default nOpc		:= 1	//1=Liberação do Pedido /2=Estorna liberação
	Default lEnvPvFin	:= .F.  //Libera o pedido para analise do financeiro

	If nOpc == 1//Liberação do pedido
		lRet	:= LibPedVen(cPedido, lEnvPvFin)
	ElseIf nOpc == 2//Estorno da liberação
		lRet	:= EstPedido(cPedido)
	EndIf


	RestArea(aArea)	
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LibPedVen ºAutor  ³Microsiga  	      º Data ³ 07/04/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Liberação do pedido de venda								  º±±
±±º          ³												    		  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LibPedVen(cPedido, lEnvPvFin)

	Local aArea 	:= GetArea()
	Local nQtdLib   := 0
	Local lCredito	:= .F.
	Local lAvCred	:= .T.
	Local lAvEst	:= .T.
	Local lEstoque	:= .F.
	Local lLibPar	:= .F.
	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cPedido		:= ""
	Default lEnvPvFin	:= .F.


	cQuery	:= " SELECT SC5.R_E_C_N_O_ RECSC5, SC6.R_E_C_N_O_ RECSC6, "+CRLF 
	cQuery	+= " 		SA1.R_E_C_N_O_ RECSA1, SB1.R_E_C_N_O_ RECSB1, "+CRLF  
	cQuery	+= " 		SF4.R_E_C_N_O_ RECSF4, SE4.R_E_C_N_O_ RECSE4, "+CRLF 
	cQuery	+= " 		SB2.R_E_C_N_O_ RECSB2 "+CRLF
	cQuery	+= " 		FROM "+RetSqlName("SC5")+" SC5 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SC6")+" SC6 "+CRLF
	cQuery	+= " ON SC6.C6_FILIAL = SC5.C5_FILIAL "+CRLF
	cQuery	+= " AND SC6.C6_NUM = SC5.C5_NUM "+CRLF
	cQuery	+= " AND SC6.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL= '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SC5.C5_CLIENTE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SC5.C5_LOJACLI "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SC6.C6_PRODUTO "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SC6.C6_TES "+CRLF
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SE4")+" SE4 "+CRLF
	cQuery	+= " ON SE4.E4_FILIAL = '"+xFilial("SE4")+"' "+CRLF
	cQuery	+= " AND SE4.E4_CODIGO = SC5.C5_CONDPAG "+CRLF
	cQuery	+= " AND SE4.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SB2")+" SB2 "+CRLF
	cQuery	+= " ON SB2.B2_FILIAL = SC6.C6_FILIAL "+CRLF
	cQuery	+= " AND SB2.B2_COD = SC6.C6_PRODUTO "+CRLF
	cQuery	+= " AND SB2.B2_LOCAL = SC6.C6_LOCAL "+CRLF
	cQuery	+= " AND SB2.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' "+CRLF
	cQuery	+= " AND SC5.C5_NUM = '"+cPedido+"' "+CRLF
	cQuery	+= " AND SC5.D_E_L_E_T_ = ' ' "	+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea("SC6")
	DbSetOrder(1)

	DbSelectArea("SC5")
	DbSetOrder(1)

	DbSelectArea("SB1")
	DbSetOrder(1)

	DbSelectArea("SA1")
	DbSetOrder(1)

	DbSelectArea("SF4")
	DbSetOrder(1)

	DbSelectArea("SE4")
	DbSetOrder(1)

	DbSelectArea("SB2")
	DbSetOrder(1)

	If !Empty(cPedido) 

		SC6->(MsUnLock())
		While (cArqTmp)->(!EOF())  

			SC5->(MsGoto((cArqTmp)->RECSC5))
			SC6->(MsGoto((cArqTmp)->RECSC6))
			SA1->(MsGoto((cArqTmp)->RECSA1))
			SB1->(MsGoto((cArqTmp)->RECSB1))
			SB2->(MsGoto((cArqTmp)->RECSB2))
			SE4->(MsGoto((cArqTmp)->RECSE4))
			SF4->(MsGoto((cArqTmp)->RECSF4))

			If SC5->C5_XBLQMRG == 'S'
				lRet := .F.
				MsgAlert("Pedido com bloqueio de margem, solicitar análise para prosseguir.","Atenção!")
				RestArea(aArea)
				Return lRet
			EndIf

			If SC5->C5_XBLQFIN == 'B'
				lRet := .F.
				MsgAlert("Pedido com bloqueio financeiro, solicitar análise do financeiro para prosseguir.","Atenção!")
				RestArea(aArea)
				Return lRet
			EndIf

			// If SC5->C5_XBLQMIN == 'S'
			// 	lRet := .F.
			// 	MsgAlert("Pedido com bloqueio de preço mínimo, solicitar análise do financeiro para prosseguir.","Atenção!")
			// 	RestArea(aArea)
			// 	Return lRet
			// EndIf

			If !Empty(SC5->C5_BLQ)
				RecLock("SC5",.F.)
				SC5->C5_BLQ := "" 
				SC5->C5_LIBEROK := ""
				SC5->(MsUnLock())
			EndIf

			//Não permito novo bloqueio de crédito novamente ~ Denis Varella 01/06/2021
			If SC5->C5_XBLQFIN == 'L'
				lCredito := .T.
				lAvCred := .F.
			EndIf

			nQtdLib := SC6->C6_QTDVEN	

			//MaLibDoFat(nRegSC6		,nQtdaLib	,lCredito	,lEstoque	,lAvCred	,lAvEst		,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lGeraDCF,nVlrCred,nQtdalib2)
			Begin Transaction
				MaLibDoFat(SC6->(Recno())	,nQtdLib	,lCredito    ,lEstoque  	,lAvCred   	,lAvEst    	, lLibPar	) 
				SC6->(MaLiberOk({cPedido},.F.))
			End Transaction

			(cArqTmp)->(DbSkip())	
		EndDo
		If Select(cArqTmp) > 0
			(cArqTmp)->(DbCloseArea())
		EndIf

	EndIf


	//Verifica se existe bloqueio de credito para analise do financeiro
	If IsBlqCrd(cPedido) .And. !lEnvPvFin 

		//Realiza o estorno da liberação
		If EstPedido(cPedido)

			//Realiza o bloqueio do pedido
			BlqPedido(cPedido) 

			lRet := .F.
		EndIf
	EndIf

	RestArea(aArea)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IsBlqEst ºAutor  ³Microsiga  	      º Data ³ 07/04/20		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o pedido esta com bloqueio de estoque			  º±±
±±º          ³												    		  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IsBlqCrd(cPedido)

	Local aArea 	:= GetArea()
	Local lRet		:= .F.
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cPedido := ""

	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("SC9")+" SC9 "+CRLF
	cQuery	+= " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' "+CRLF 
	cQuery	+= " AND SC9.C9_PEDIDO = '"+cPedido+"' "+CRLF
	cQuery	+= " AND SC9.C9_BLCRED IN('01','04','05') "+CRLF
	cQuery	+= " AND SC9.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR > 0
		lRet := .T.
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BlqPedido ºAutor  ³Microsiga 	      º Data ³ 07/04/20		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Bloqueio do pedido de venda								  º±±
±±º          ³												    		  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BlqPedido(cPedido)

	Local aArea	:= GetArea()

	Default cPedido := ""

	DbSelectArea("SC5")
	DbSetOrder(1)
	If SC5->(DbSeek(xFilial("SC5") + PadR(cPedido, tamsx3("C5_NUM")[1])))
		RecLock("SC5", .F.)
		SC5->C5_BLQ 	:= "9"
		SC5->C5_YTPBLQ 	:= "C"//Bloqueio por credito
		SC5->(MsUnLock())
	EndIf

	RestArea(aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EstPedido	ºAutor  ³Microsiga		     º Data ³ 07/04/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Estorno da liberação do pedido					          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 													          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EstPedido(cPedido)

	Local cQuery    := ""
	Local cArqTmp	:= GetNextAlias()
	Local lRet		:= .F.

	Default cPedido	:= ""

	cQuery    := " SELECT R_E_C_N_O_ AS RECNOSC9 FROM "+RetSqlName("SC9")+" SC9 "
	cQuery    += " WHERE  SC9.C9_FILIAL = '"+xFilial("SC9")+"' "
	cQuery    += " AND SC9.C9_PEDIDO = '"+cPedido+"' "
	cQuery    += " AND D_E_L_E_T_ = ' ' "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	DbSelectArea("SC9")
	While (cArqTmp)->(!Eof())

		SC9->(	DbGoto((cArqTmp)->RECNOSC9))

		//Estorno da liberação
		SC9->(a460Estorna())

		(cArqTmp)->(DbSkip())
	EndDo

	DbSelectArea("SC9")
	DbSetOrder(1)
	If SC9->(DbSeek(xFilial("SC9") + cPedido ))
		lRet		:= .F.
	Else
		lRet		:= .T.
	EndIf

	If Select(cArqTmp)>0
		(cArqTmp)->(DbCloseArea())	
	EndIf

Return lRet    
