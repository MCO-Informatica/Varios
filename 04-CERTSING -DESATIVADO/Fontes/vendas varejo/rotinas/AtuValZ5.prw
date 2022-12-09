#Include "Totvs.ch"

User Function AtuValZ5(cPedSZ5, cForca)

Local nValTotHW	:= 0
Local nValTotSW	:= 0
Local nValTot	:= 0
Local cVouAnt	:= ""
Local cPedAnt	:= ""
Local cPeriodo	:= ""
Local cPedGar	:= ""
Local cPedSite	:= ""
Local cVouAnt	:= ""
Local lNaoPagou	:= .T.
Local lHardFix	:= .T.
Local lPedSite	:= .T.
Local lPosicao	:= .T.
Local lPosic12	:= .T.
Local lUsaSC5	:= .F.
Local aAreaSZ5	:= SZ5->(GetArea())
Local aAreaSZF	:= SZF->(GetArea())
Local aAreaSZG	:= SZG->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaZ12	:= Z12->(GetArea())
Local aAreaZ5Ped	:= {}
Local lManut		:= .F.
Local lFound		:= .F.
Local nConta		:= 0
Local lVoucher	:= .F.

Default cPedSZ5 := "ZZZZZZZZ"
Default cForca  := "1"

//Me posiciono no pedido e gero valores através do sistema.
SZ5->(DbSetOrder(1))
If SZ5->(DbSeek( xFilial("SZ5") + PadR(cPedSZ5,10," ") ))
	
	//Armazena o recno para se posiciona apos efetuar outras alteracoes.
	nRecnoZ5 := SZ5->(Recno())
	
	//Solicitante: Suzane - 06/05/2015
	//Sempre busca para atualizar o campo de voucher
	SZG->(DbSetOrder(1))
	SZF->(DbSetOrder(2))
	
	If SZG->(DbSeek( xFilial("SZG") + cPedSZ5 )) .And. !Empty(cPedSZ5)

		lVoucher := .T.
		
		SZF->(DbSeek( xFilial("SZF") + SZG->ZG_NUMVOUC ))
		
		If SZ5->(Reclock("SZ5",.F.))
			SZ5->Z5_CODVOU := SZG->ZG_NUMVOUC
			SZ5->Z5_TIPVOU := SZF->ZF_TIPOVOU
			SZ5->(MsUnlock())
		EndIf
	//Renato Ruy - 09/02/2017
	//Se tem voucher na SZ5, nao encontrou vinculo, o sistema efetua validacoes.
	ElseIf !Empty(SZ5->Z5_CODVOU)

		If Select("TMPVOU") > 0
			DbSelectArea("TMPVOU")
			TMPVOU->(DbCloseArea())
		Endif
		
		//Busca na GTIN se tem voucher vinculado ao pedido site.
		Beginsql Alias "TMPVOU"

			SELECT MAX(ZF_COD) VOUCHER, MAX(ZF_TIPOVOU) TIPO
			FROM GTIN GTIN
			JOIN %Table:SZG% SZG
			ON ZG_FILIAL       = %xFilial:SZG%
			AND ZG_PEDSITE     = GT_XNPSITE
			AND ZG_PEDSITE     > '0'
			AND SZG.%Notdel% 
			JOIN PROTHEUS.SZF010 SZF
			ON ZF_FILIAL = %xFilial:SZF% AND
			ZF_COD = ZG_NUMVOUC AND
			SZF.%Notdel% 
			WHERE GT_PEDGAR = %Exp:cPedSZ5%
		
		Endsql
			//Nao efetuo novamente a validacao da SZ5, pois nao entrou anteriormente.
			If Empty(TMPVOU->VOUCHER)  
				If SZ5->(Reclock("SZ5",.F.))
					SZ5->Z5_CODVOU := " "
					SZ5->Z5_TIPVOU := " "
				SZ5->(MsUnlock())
			EndIf
		Endif
	
	// Renato Ruy - 25/10/16
	// Tratamento para voucher sem notificação de pedido gar no consumo do voucher.
	ElseIf Empty(SZ5->Z5_CODVOU) .And. SZ5->Z5_VALORSW+SZ5->Z5_VALORHW == 0 .And. !Empty(cPedSZ5)
	    
		If Select("TMPVOU") > 0
			DbSelectArea("TMPVOU")
			TMPVOU->(DbCloseArea())
		Endif
		
		Beginsql Alias "TMPVOU"

			SELECT MAX(ZF_COD) VOUCHER, MAX(ZF_TIPOVOU) TIPO
			FROM GTIN GTIN
			JOIN %Table:SZG% SZG
			ON ZG_FILIAL       = %xFilial:SZG%
			AND ZG_PEDSITE     = GT_XNPSITE
			AND ZG_PEDSITE     > '0'
			AND SZG.%Notdel% 
			JOIN PROTHEUS.SZF010 SZF
			ON ZF_FILIAL = %xFilial:SZF% AND
			ZF_COD = ZG_NUMVOUC AND
			SZF.%Notdel% 
			WHERE GT_PEDGAR = %Exp:cPedSZ5%
		
		Endsql
		
		If !Empty(TMPVOU->VOUCHER)
			If SZ5->(Reclock("SZ5",.F.))
				SZ5->Z5_CODVOU := TMPVOU->VOUCHER
				SZ5->Z5_TIPVOU := TMPVOU->TIPO
				SZ5->(MsUnlock())
			EndIf
		Endif
		
	EndIf
	
	//Busca valor do pedido anterior.
	If !Empty(SZ5->Z5_CODVOU) .And. RTRIM(SZ5->Z5_TIPVOU) != "F"
		
		cVouAnt		:= ""
		lNaoPagou	:= .T.
		
		DbSelectArea("SZF")
		DbSetOrder(2)
		If DbSeek(xFilial("SZF")+SZ5->Z5_CODVOU)
			
			//Vouchers que não são pagos e que os usuários deverao informar o valor.
			If !(SZF->ZF_TIPOVOU$"2/A/B/H")
				nValTotSW := SZF->ZF_VALORSW
				nValTotHW := SZF->ZF_VALORHW
			//Voucher que tem origem em pedido ou através de outro voucher.
			Elseif SZF->ZF_TIPOVOU$"2/A/B/H"
			
				cPedGar  := Iif(Val(SZF->ZF_PEDIDO)>0,AllTrim(Str(Val(SZF->ZF_PEDIDO)))," ")
				cPedSite := Iif(Val(SZF->ZF_PEDSITE)>0,AllTrim(Str(Val(SZF->ZF_PEDSITE)))," ")
				cVouAnt  := SZF->ZF_CODORIG 
				
				While (!Empty(cPedGar) .Or. !Empty(cPedSite) .Or. !Empty(cVouAnt)) .And. nValTotSw+nValTotHw == 0 .And. nConta <= 12
				
					lPosicao := .F.
					nConta++
					
					If !Empty(cPedGar)
						//Indice - Filial + Pedido Gar
						SZG->(DbSetOrder(1))
						lPosicao := SZG->(DbSeek(xFilial("SZG")+cPedGar))
	                    
						If lPosicao
							//Indice - Filial + Voucher
							SZF->(DbSetOrder(2))
							lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC))
							nValTotSW := SZF->ZF_VALORSW
							nValTotHW := SZF->ZF_VALORHW
						Endif
					Endif
						
					If !Empty(cPedSite) .And. !lPosicao
						//Indice - Filial + Pedido Site 
						SZG->(DbSetOrder(3))
						lPosicao := SZG->(DbSeek(xFilial("SZG")+cPedSite))	
						
						If lPosicao
							//Indice - Filial + Voucher
							SZF->(DbSetOrder(2))
							lPosicao := SZF->(DbSeek(xFilial("SZF")+SZG->ZG_NUMVOUC))
							nValTotSW := SZF->ZF_VALORSW
							nValTotHW := SZF->ZF_VALORHW
						Endif
					Endif
					
					If !Empty(cVouAnt) .And. !lPosicao
						//Indice - Filial + Voucher
						SZF->(DbSetOrder(2))
						lPosicao := SZF->(DbSeek(xFilial("SZF")+cVouAnt))
						nValTotSW := SZF->ZF_VALORSW
						nValTotHW := SZF->ZF_VALORHW
					Endif
					
					If !lPosicao
						if !Empty(cPedGar) 
							//Indice - Filial + Pedido Gar
							DbSelectArea("SC6")
							DbOrderNickName("NUMPEDGAR")
							lPosicao := SC6->(DbSeek(xFilial("SC6")+cPedGar))
							
							If SC6->(Found())
								dbSelectArea("SC5")
								SC5->(dbSetOrder(1))
								lPosicao := SC5->(dbSeek(xFilial("SC5") + SC6->C6_NUM))
							EndIf
							
							If !lPosicao
								dbSelectArea("SC5")
								SC5->(dbOrderNickname("NUMPEDGAR"))
								lPosicao := SC5->(dbSeek(xFilial("SC5") + cPedGar))
								
								If lPosicao
									SC6->(DbSetOrder(1))
									SC6->(DbSeek( xFilial("SC6") + SC5->C5_NUM ))
									lUsaSC5 := .T.
								EndIf
								
							EndIf
							
						Endif
						
						If Empty(cPedSite) .And. !Empty(cPedGar) .And. !lPosicao
							//Fecha se o Alias esta aberto
							If Select("TMPVOU") > 0
								DbSelectArea("TMPVOU")
								TMPVOU->(DbCloseArea())
							EndIf
							//Caso nao encontre o pedido no sistema, procura possiveis problemas na GTIN
							Beginsql Alias "TMPVOU"
								%NoParser%
								SELECT Max(GT_XNPSITE) PEDSITE
								FROM GTIN
								WHERE GT_ID = %Exp:cPedGar%
							Endsql
							cPedSite := TMPVOU->PEDSITE
						Endif
						
						if !Empty(cPedSite)
							//Indice - Filial + Pedido Site
							DbSelectArea("SC5")
							DbOrderNickName("PEDSITE")
							lPosicao := SC5->(DbSeek(xFilial("SC5")+cPedSite))
							
							If lPosicao
								SC6->(dbSetOrder(1))
								SC6->(dbSeek( xFilial("SC6") + SC5->C5_NUM ))
								lUsaSC5 := .T.
							EndIf
							
						Endif
						
						
						If lPosicao
							nValTotSw := 0
							nValTotHw := 0
								
								lHardFix:=.F.
								While SC6->C6_FILIAL == SC5->C5_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM .And. AllTrim(SC6->C6_PEDGAR) == cPedGar
									
									DbSelectArea("SB1")
									DbSetOrder(1)
									If DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )
									
										//Renato Ruy - 11/01/2018
										//Busca se tem taxa de manutenção, para não remunerar este produto.
										lManut := .F.
										SZJ->(DbSetOrder(1))
										If SZJ->(DbSeek(xFilial("SZJ")+SC6->C6_XCDPRCO))
											While !SZJ->(EOF()) .And. SC6->C6_XCDPRCO == SZJ->ZJ_COMBO
												
												If SZJ->ZJ_CODPROD == SC6->C6_PRODUTO .And.  SZJ->ZJ_TXMANU > 0
													lManut := .T.
												Endif
												
												SZJ->(DbSkip())
											Enddo
										Endif
										
										If SB1->B1_CATEGO == "2" .And. SC6->C6_XOPER != "53" .And. !lManut //.And. lHardFix
											nValTotSw += SC6->C6_PRCVEN
											nValTot   += SC6->C6_PRCVEN
											
										ElseIf SB1->B1_CATEGO == "1" .And. SC6->C6_XOPER != "53" .And. SZ5->Z5_TIPVOU != "H"
											
											SB5->(DbSetOrder(1))
											If SB5->(DbSeek( xFilial("SB5") + SB1->B1_COD )) .And. GetMv("MV_XREMFIX")
												
												// Solicitante: Priscila Kuhn - 08/04/2016
												// Não desmembra o valor se o total é igual valor fixo.
												If SC5->C5_TOTPED > SB5->B5_PRV7
													nValTotHw += Iif(SB5->B5_PRV7+nValTotHw > SC5->C5_TOTPED .And. SC5->C5_TOTPED > 0, SC5->C5_TOTPED,SB5->B5_PRV7)
													nValTot   += SC6->C6_PRCVEN
													// Priscila Kuhn - Geração de valores superiores, faço o controle através da variavel
													lHardFix := .T.
													//ElseIf AllTrim(SB1->B1_COD) $ cCodHard
												Else
													nValTotHw += SC6->C6_PRCVEN
													nValTot   += SC6->C6_PRCVEN
												EndIf
												
											Else
												nValTotHw += SC6->C6_PRCVEN
												nValTot   += SC6->C6_PRCVEN
											EndIf
											
										EndIf
										
									EndIf
									DbSelectArea("SC6")
									SC6->(DbSkip())
								EndDo
								
								if lHardFix
									
									nValTotSw:=IIF(nValTot-nValTotHw>0,nValTot-nValTotHw,0)
									
								endif
								
							//EndIf
						Endif
							
					EndIf
					
					If !Empty(cPedGar)
						//Indice - Filial + Pedido Gar
						Z12->(DbSetOrder(3)) //FILIAL + PEDGAR
						lPosic12 := Z12->(DbSeek(xFilial("Z12")+ cPedGar))
					Elseif !Empty(cPedSite)
						//Indice - Filial + Pedido Site
						Z12->(DbSetOrder(2)) //FILIAL + PEDGAR
						lPosic12 := Z12->(DbSeek(xFilial("Z12")+ cPedSite))
					Endif					
					
					//Enquanto e o mesmo pedido Gar, armazena valores.
					While !Z12->(EOF()) .And. lPosic12 .And. AllTrim(Z12->Z12_PEDGAR) == AllTrim(cPedGar) .And. AllTrim(Z12->Z12_PEDSIT) == AllTrim(cPedSite)
						
						//Se posiciona na tabela de produto para descobrir tipo
						SB1->(DbSetOrder(1))
						If SB1->(DbSeek( xFilial("SB1") + Z12->Z12_PRODUT ))
							If SB1->B1_CATEGO == "2"
								nValTotSw += Z12->Z12_PRUNIT
							ElseIf SB1->B1_CATEGO == "1"
								nValTotHW += Z12->Z12_PRUNIT
							EndIf
						EndIf
						Z12->(DbSkip())
					Enddo
					
					If (!lPosicao .And. nValTotSw+nValTotHw == 0) .Or. nValTotSw+nValTotHw > 0
						cPedGar  := " "
						cPedSite := " "
						cVouAnt  := " "
					Elseif nValTotSw+nValTotHw == 0 
						cPedGar  := SZF->ZF_PEDIDO
						cPedSite := SZF->ZF_PEDSITE
						cVouAnt  := SZF->ZF_CODORIG
					Endif
					
					lPosicao := .F.		
				Enddo
							
			EndIf
			
			SZ5->( DbGoTo( nRecnoZ5 ) )
		EndIf
		
	ELSEIf !Empty(SZ5->Z5_PEDGAR)
	
		//Renato Ruy - 10/04/2017
		//Busca mesmo que o pedido gar nao tenha entrado no sistema.
		lPosicao := .T.

		//Fecha se o Alias esta aberto
		If Select("TMPVOU") > 0
			DbSelectArea("TMPVOU")
			TMPVOU->(DbCloseArea())
		EndIf
		//Caso nao encontre o pedido no sistema, procura possiveis problemas na GTIN
		Beginsql Alias "TMPVOU"
			%NoParser%
			SELECT Max(GT_XNPSITE) PEDSITE
			FROM GTIN
			WHERE GT_ID = %Exp:SZ5->Z5_PEDGAR%
		Endsql
		//Busca pelo pedido site.
		DbSelectArea("SC5")
		DbOrderNickName("PEDSITE")
		lPosicao := SC5->(DbSeek( xFilial("SC5") + TMPVOU->PEDSITE )) .And. !Empty(TMPVOU->PEDSITE)
		
		If !lPosicao
			SC5->(dbOrderNickname("NUMPEDGAR"))
			lPosicao := SC5->(dbSeek(xFilial("SC5") + SZ5->Z5_PEDGAR))
		EndIf

		If !lPosicao .And. AllTrim(SZ5->Z5_TIPVOU) == "F"
			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			lPosicao := SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
		EndIf

		If !lPosicao
			DbSelectArea("SC6")
			DbOrderNickName("NUMPEDGAR")
			lPosicao := SC6->(DbSeek( xFilial("SC6") + SZ5->Z5_PEDGAR ))				
		Endif

	
		If lPosicao
			nValTotSw := 0
			nValTotHw := 0
			
			If SC6->(Found())
				dbSelectArea("SC5")
				dbSetOrder(1)
				lFound := SC5->(dbSeek( xFilial("SC5") + SC6->C6_NUM )) 
			ElseIf SC5->(Found())
				dbSelectArea("SC6")
				dbSetOrder(1)
				lFound := SC6->(dbSeek( xFilial("SC6") + SC5->C5_NUM ))
			EndIf
			
			If SC6->C6_PEDGAR != SZ5->Z5_PEDGAR .And. AllTrim(SZ5->Z5_TIPVOU) != "F"
				SC6->(dbOrderNickname("NUMPEDGAR"))
				lFound := SC6->(dbSeek(xFilial("SC6") + SZ5->Z5_PEDGAR)) .And. SC6->C6_NUM == SC5->C5_NUM
			EndIf	

				
			If lFound
				
				lHardFix:=.F.
				While SC6->C6_FILIAL == SC5->C5_FILIAL .And. SC6->C6_NUM == SC5->C5_NUM 

				 	If !Empty(SC6->C6_PEDGAR) .And. SC6->C6_PEDGAR != SZ5->Z5_PEDGAR .And. AllTrim(SZ5->Z5_TIPVOU) != "F"
				 		SC6->(dbSkip())
				 		Loop
				 	EndIf
					
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )
					
						//Renato Ruy - 11/01/2018
						//Busca se tem taxa de manutenção, para não remunerar este produto.
						lManut := .F.
						SZJ->(DbSetOrder(1))
						If SZJ->(DbSeek(xFilial("SZJ")+SC6->C6_XCDPRCO))
							While !SZJ->(EOF()) .And. SC6->C6_XCDPRCO == SZJ->ZJ_COMBO
								
								If SZJ->ZJ_CODPROD == SC6->C6_PRODUTO .And.  SZJ->ZJ_TXMANU > 0
									lManut := .T.
								Endif
								
								SZJ->(DbSkip())
							Enddo
						Endif
						
						If SB1->B1_CATEGO == "2" .And. SC6->C6_XOPER != "53" .And. !lManut //.And. lHardFix
							nValTotSw += SC6->C6_PRCVEN
							nValTot   += SC6->C6_PRCVEN
							
						ElseIf SB1->B1_CATEGO == "1" .And. SC6->C6_XOPER != "53" .And. SZ5->Z5_TIPVOU != "H"
							
							SB5->(DbSetOrder(1))
							If SB5->(DbSeek( xFilial("SB5") + SB1->B1_COD )) .And. GetMv("MV_XREMFIX")
								
								// Solicitante: Priscila Kuhn - 08/04/2016
								// Não desmembra o valor se o total é igual valor fixo.
								If SC5->C5_TOTPED > SB5->B5_PRV7
									nValTotHw += Iif(SB5->B5_PRV7+nValTotHw > SC5->C5_TOTPED .And. SC5->C5_TOTPED > 0, SC5->C5_TOTPED,SB5->B5_PRV7)
									nValTot   += SC6->C6_PRCVEN
									// Priscila Kuhn - Geração de valores superiores, faço o controle através da variavel
									lHardFix := .T.
									//ElseIf AllTrim(SB1->B1_COD) $ cCodHard
								Else
									nValTotHw += SC6->C6_PRCVEN
									nValTot   += SC6->C6_PRCVEN
								EndIf
								
							Else
								nValTotHw += SC6->C6_PRCVEN
								nValTot   += SC6->C6_PRCVEN
							EndIf
							
						EndIf
						
					EndIf
					DbSelectArea("SC6")
					SC6->(DbSkip())
				EndDo
				
				if lHardFix
					
					nValTotSw:=IIF(nValTot-nValTotHw>0,nValTot-nValTotHw,0)
					
				endif
				
				If nValTotHw + nValTotSw == 0
					
				EndIf
			EndIf
			
		EndIf
		
	EndIf
	
	//Renato Ruy - 09/09/2016
	//Buscar valores da DUA - Documento Unico de Arrecadacao - Espirito Santo
	//Quando pedido não tem valor, busca o valor na tabela.
	If nValTotSW + nValTotHW == 0
		
		Z12->(DbSetOrder(3)) //FILIAL + PEDGAR
		If Z12->(DbSeek(xFilial("Z12")+ SZ5->Z5_PEDGAR))
			
			//Enquanto e o mesmo pedido Gar, armazena valores.
			While !Z12->(EOF()) .And. Z12->Z12_PEDGAR == SZ5->Z5_PEDGAR
				
				//Se posiciona na tabela de produto para descobrir tipo
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek( xFilial("SB1") + Z12->Z12_PRODUT ))
					If SB1->B1_CATEGO == "2"
						nValTotSw += Z12->Z12_PRUNIT
					ElseIf SB1->B1_CATEGO == "1"
						nValTotHW += Z12->Z12_PRUNIT
					EndIf
				EndIf
				Z12->(DbSkip())
			Enddo
		Elseif Z12->(DbSeek(xFilial("Z12")+ cPedant))
			//Enquanto e o mesmo pedido Gar, armazena valores.
			While !Z12->(EOF()) .And. Z12->Z12_PEDGAR == cPedant
				
				//Se posiciona na tabela de produto para descobrir tipo
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek( xFilial("SB1") + Z12->Z12_PRODUT ))
					If SB1->B1_CATEGO == "2"
						nValTotSw += Z12->Z12_PRUNIT
					ElseIf SB1->B1_CATEGO == "1"
						nValTotHW += Z12->Z12_PRUNIT
					EndIf
				EndIf
				Z12->(DbSkip())
			Enddo
		EndIf
		
	Endif
	
	If nValTotHw + nValTotSw == 0
		
	EndIf
	
	//Renato Ruy - 18/07/2017
	//Integracao Gar Corporativo
	If Type("SZ5->Z5_CONTRA") != "U"
	
		If Val(SZ5->Z5_CONTRA) > 0
			
			Beginsql Alias "TMPCTR"
				SELECT CNB_VLSOFT, CNB_VLHARD
				FROM %TABLE:CNB%
				WHERE
				CNB_FILIAL = %XFILIAL:CNB% AND
				CNB_CONTRA = %EXP:SZ5->Z5_CONTRA% AND
				CNB_PROGAR = %EXP:SZ5->Z5_PRODGAR% AND 
				CNB_NUMERO = (SELECT MAX(CNB_NUMERO) FROM %TABLE:CNB% WHERE CNB_FILIAL = %XFILIAL:CNB% AND CNB_CONTRA = %EXP:SZ5->Z5_CONTRA% AND %NOTDEL%) AND
				%NOTDEL%
			Endsql 
			
			nValTotSW := TMPCTR->CNB_VLSOFT
			nValTotHW := TMPCTR->CNB_VLHARD
			
			TMPCTR->(DbCloseArea())
		Endif
	
	Endif
	
	//Considerar valor do pedido origem, em caso de renovação
	If !lVoucher .And. nValTotHw + nValTotSw == 0 .And. !Empty(SZ5->Z5_PEDGANT)
		aAreaZ5Ped := SZ5->(getArea())
		If SZ5->(dbSeek(xFilial("SZ5") + SZ5->Z5_PEDGANT))
			nValTotSw := SZ5->Z5_VALORSW
			nValTotHw := SZ5->Z5_VALORHW
		EndIf
		RestArea(aAreaZ5Ped)
	EndIf
	
	If nValTotHw + nValTotSw == 0 .And. !Empty(SZ5->Z5_CODVOU)
		DbSelectArea("SZF")
		SZF->(DbSetOrder(2))
		If SZF->(dbSeek(xFilial("SZF")+SZ5->Z5_CODVOU))
		
			If !Empty(SZF->ZF_PEDIDO)
				aAreaZ5Ped := SZ5->(GetArea())
				If SZ5->(dbSeek(xFilial("SZ5") + SZF->ZF_PEDIDO))
					nValTotSw := SZ5->Z5_VALORSW
					nValTotHw := SZ5->Z5_VALORHW
				EndIf
				RestArea(aAreaZ5Ped)
			EndIf

			If nValTotSw + nValTotHw == 0
				dbSelectArea("SC6")
				SC6->(dbSetOrder(1))
				If SC6->(dbSeek(xFilial("SC6") + SC6->C6_NUM)) .And. !Empty(SC6->C6_NUM)
					If Substr(SC6->C6_PRODUTO,1,2) == "CC"
						nValTotSw := SC6->C6_VALOR
					ElseIf Substr(SC6->C6_PRODUTO,1,2) == "MR"
						nValTotHw := SC6->C6_VALOR
					EndIf
				EndIf
			EndIf

		EndIf
	EndIf
	
	
	//Renato Ruy - 14/09/16
	//Somente altera valores de pedidos superior ao periodo em aberto no MV_REMMES ou se forcado na importacao.
	cPeriodo := Iif(Empty(SZ5->Z5_PEDGANT),SubStr(DtoS(SZ5->Z5_DATVER),1,6),SubStr(DtoS(SZ5->Z5_DATEMIS),1,6))
	
	//Renato Ruy - 05/05/2016
	//Opcao para forcar atualizacao.
	If AllTrim(SZ5->Z5_COMISS) != "2" .And. (cPeriodo > getmv("MV_REMMES") .Or. Empty(cPeriodo))
		If !(SZ5->(Reclock("SZ5",.F.)))
			Return
		EndIf
		SZ5->Z5_VALORHW := nValTotHW
		SZ5->Z5_VALORSW := nValTotSW
		SZ5->Z5_VALOR   := nValTotSW + nValTotHW
		
		SZ5->(MsUnlock())
		//Renato Ruy - 17/09/2015
		//Validação para manter os valores em caso de projetos.
		//If SZ5->Z5_COMISS != "2" .And. nValTotSW + nValTotHW > 0
	ElseIf AllTrim(cForca) == "2"
		If !(SZ5->(Reclock("SZ5",.F.)))
			Return
		EndIf
		SZ5->Z5_VALORHW := nValTotHW
		SZ5->Z5_VALORSW := nValTotSW
		SZ5->Z5_VALOR   := nValTotSW + nValTotHW
		SZ5->Z5_COMISS  := "1"
		
		SZ5->(MsUnlock())
		//Atualiza dados dos pedidos zerados e solicita que seja recalculado limpando Z5_COMISS.
	ElseIf  SZ5->Z5_VALORHW+SZ5->Z5_VALORSW <> nValTotSW+nValTotHW .And. nValTotSW + nValTotHW > 0 .And. cPeriodo > getmv("MV_REMMES")
		
		If !(SZ5->(Reclock("SZ5",.F.)))
			Return
		EndIf
		SZ5->Z5_VALORHW := nValTotHW
		SZ5->Z5_VALORSW := nValTotSW
		SZ5->Z5_VALOR   := nValTotSW + nValTotHW
		SZ5->Z5_COMISS  := "1"
		
		SZ5->(MsUnlock())
	EndIf
EndIf

RestArea(aAreaSZ5)
RestArea(aAreaSZF)
RestArea(aAreaSZG)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaZ12)

Return
