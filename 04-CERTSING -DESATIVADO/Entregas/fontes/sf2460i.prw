#INCLUDE 'Protheus.ch'

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½SF2460I   ï¿½Autor  ï¿½Darcio R. Sporl     ï¿½ Data ï¿½  27/07/11   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½Ponto de Entrada desenvolvido para recuperar o nosso numero ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½do titulo provisorio, e gravar no titulo real, e excluir o  ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½titulo provisorio, pra cada pedido cujo pagamento foi boletoï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc. 2   ï¿½Ponto de Entrada para gravar no Titulo do Financeiro o tipo ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½de Pagamento do cliente                                     ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½1=Manual / 2=Bpag / 3=Amarelinhas                           ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ Opvs x Certisign                                           ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
User Function SF2460I()
Local aArea 	:= GetArea()		//Salva a area atual
Local aAreaSE1	:= SE1->(GetArea())	//Salva a area atual da tabela SE1
Local aAreaSD2	:= SD2->(GetArea())	//Salva a area atual da tabela SD2
Local aAreaSF2	:= SF2->(GetArea())	//Salva a area atual da tabela SF2
Local aAreaSC5	:= SC5->(GetArea())	//Salva a area atual da tabela SC5
Local cQrySD2	:= ""
Local cQrySE1	:= ""
Local cPrefix	:= GetNewPar("MV_XPREFHD", "VDI")
Local cNossoNum	:= ""
Local cXNPSITE	:= ""
Local cGerPR		:= GetNewPar("MV_XSITEPR", "0")
Local lRec := .T.
Local cRec := " " 
Local cPedido := " "  

Local cIdentPed := '1'
Local cNumAR    := SC5->C5_AR			// precisa ver se esta posicionado 
Local cNumBpag  := SC5->C5_CHVBPAG
Local cCondPag  := SC5->C5_CONDPAG 
Local cOrigPV	:= SC5->C5_XORIGPV

If !Empty(SF2->F2_DUPL) .and. SF2->F2_TIPO == 'N' 
	DbSelectArea("SE1")
	DbSetOrder(1)              
	
	IF Empty(cNumAR) .And. Empty(cNumBpag) .And. cCondPag == '000'
		cIdentPed := '1'
	ElseIF .NOT. Empty(cNumAR) .And. Empty(cNumBpag) .And. cCondPag <> '000'
		cIdentPed := '3'
	ElseIF Empty(cNumAR) .And. Empty(cNumBpag) .And. cCondPag <> '000'
		cIdentPed := '4'
	ElseIF Empty(cNumAR) .And. .NOT. Empty(cNumBpag)
		cIdentPed := '2'
	EndIF
				
	//----> 30/03/2021 - INICIO DA ALTERACAO - ROGERIO BISPO (UPDUO) - LAÇO PARA GRAVAR DADOS EM TODAS AS PARCELAS
	If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
		While se1->(!Eof()) .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO .And. SE1->E1_NUM == SF2->F2_DUPL
			
			if SE1->E1_TIPO == 'NF '
				SE1->(RecLock("SE1", .F.))
				SE1->E1_ORIGPV := cOrigPV 
				SE1->E1_NUMREG := cNumAr 
				SE1->E1_INSTR1 := If(cIdentPed=='3' , '93', '') 		// para gerar Mensg no Boleto 
				SE1->(MsUnLock())
			endif

			SE1->(dbSkip())
		EndDo
	endif
	//----> 30/03/2021 - FINAL DA ALTERACAO - ROGERIO BISPO (UPDUO) - LAÇO PARA GRAVAR DADOS EM TODAS AS PARCELAS

EndIf 

If cGerPR == "1"
               
	//Pega o numero do pedido referente a nota posicionada
	cQrySD2 := "SELECT D2_PEDIDO "
	cQrySD2 += "FROM " + RetSqlName("SD2") + " "
	cQrySD2 += "WHERE D2_FILIAL = '" + xFilial("SD2") + "' "
	cQrySD2 += "  AND D2_DOC = '" + SF2->F2_DOC + "' "
	cQrySD2 += "  AND D2_SERIE = '" + SF2->F2_SERIE + "' "
	cQrySD2 += "  AND D_E_L_E_T_ = ' ' "
	
	cQrySD2 := ChangeQuery(cQrySD2)
	
	If Select("QRYSD2") > 0
		DbSelectArea("QRYSD2")
		QRYSD2->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySD2),"QRYSD2",.F.,.T.)
	
	//Pega o recno, o nosso numero e o numero do pedido do site, do titulo do tipo provisorio, que foi incluido pelo site pela forma de pagamento boleto
	DbSelectArea("QRYSD2")
	QRYSD2->(DbGoTop())
	If QRYSD2->(!Eof())
		cQrySE1 := "SELECT R_E_C_N_O_ NRECE1, E1_NUMBCO, E1_XNPSITE "
		cQrySE1 += "FROM " + RetSqlName("SE1") + " "
		cQrySE1 += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
		cQrySE1 += "  AND E1_PREFIXO = '" + cPrefix + "' "
		cQrySE1 += "  AND E1_NUM = '" + QRYSD2->D2_PEDIDO + "' "
		cQrySE1 += "  AND E1_XNPSITE <> '" + Space(TamSX3("E1_XNPSITE")[1]) + "' "
		cQrySE1 += "  AND E1_TIPO = 'PR ' "
		cQrySE1 += "  AND D_E_L_E_T_ = ' ' "
		
		cQrySE1 := ChangeQuery(cQrySE1)
		
		If Select("QRYSE1") > 0
			DbSelectArea("QRYSE1")
			QRYSE1->(DbCloseArea())
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySE1),"QRYSE1",.F.,.T.)
		
		DbSelectArea("QRYSE1")
		If QRYSE1->(!Eof())	
			cNossoNum := AllTrim(QRYSE1->E1_NUMBCO)
			cXNPSITE := AllTrim(QRYSE1->E1_XNPSITE)
			
			DbSelectArea("SE1")
			SE1->(DbGoto(QRYSE1->NRECE1))
			
			//Excluo o titulo provisorio
			RecLock("SE1", .F.)
				SE1->(DbDelete())
			SE1->(MsUnLock())                                         
			
		    
			//Posiciono no novo titulo gerado pelo faturamento, e gavo nele o nosso numero e o numero do pedido gerado pelo site
			DbSelectArea("SE1")
			DbSetOrder(1)	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If MsSeek(xFilial("SE1") + SF2->F2_PREFIXO + SF2->F2_DUPL)
				//----> 30/03/2021 - INICIO DA ALTERACAO - ROGERIO BISPO (UPDUO) - LAÇO PARA GRAVAR DADOS EM TODAS AS PARCELAS
				While se1->(!Eof()) .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO .And. SE1->E1_NUM == SF2->F2_DUPL
					
					if SE1->E1_TIPO == 'NF '
						SE1->(RecLock("SE1", .F.))
						Replace SE1->E1_NUMBCO With cNossoNum
						Replace SE1->E1_XNPSITE With cXNPSITE
						SE1->(MsUnLock())
					endif

					SE1->(dbSkip())
				EndDo
				//----> 30/03/2021 - FINAL DA ALTERACAO - ROGERIO BISPO (UPDUO) - LAÇO PARA GRAVAR DADOS EM TODAS AS PARCELAS

			EndIf
			
			If Select("QRYSE1") > 0
				DbSelectArea("QRYSE1")
				QRYSE1->(DbCloseArea())
			EndIf
		EndIf
	EndIf
	
	If Select("QRYSD2") > 0
		DbSelectArea("QRYSD2")
		QRYSD2->(DbCloseArea())
	EndIf
Endif

RestArea(aArea)		//Restaura a area
RestArea(aAreaSE1)	//Restaura a area da tabela SE1
RestArea(aAreaSD2)	//Restaura a area da tabela SD2
RestArea(aAreaSC5)	//Restaura a area da tabela SC5
RestArea(aAreaSF2)	//Restaura a area da tabela SF2

Return
