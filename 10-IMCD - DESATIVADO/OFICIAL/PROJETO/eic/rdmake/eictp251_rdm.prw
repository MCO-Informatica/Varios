#include "protheus.ch"
#define CRLF chr(13)+chr(10)
#define cSim "1YS"

Static nFret_T_R, nFret_T_P, nFret_U_R, nFret_U_P
Static nTotBRL_CIF, nTotUSD_CIF, nTotBRL_Desp, nTotUSD_Desp, nTotBRL_II, nTotUSD_II
//Static nVal101_Old, nVal102_Old

User Function EICTP251

	Local xRet   := NIL
	Local cParam := ""
	Local cAlias := Alias()
	Local nFrete := 0
	Local nParidade := 1
	Local nRateio

	IF Type("ParamIXB") == "C" 
		cParam := Upper(Alltrim(ParamIXB)) 
	Elseif Type("ParamIXB") == "A" .And. Type("ParamIXB[1]") == "C"
		cParam := Upper(Alltrim(ParamIXB[1])) 
	Endif      

	Begin Sequence

		Do Case        
			Case cParam == "IMPRIRDESP"
			Do Case
				/*
				Case (cAlias)->WKDESPESA == "101" // fob
				IF AllTrim(SW2->W2_FREPPCC) == "PP" .And. SW2->W2_FRETEIN > 0
				nQtd := (cAlias)->(WKCUS_T_R/WKCUS_U_R)
				nParidade := Round((cAlias)->WKCUS_T_P/(cAlias)->WKCUS_T_R,4)

				(cAlias)->WKCUS_T_P  -= SW2->W2_FRETEIN * nParidade
				(cAlias)->WKCUS_T_R  -= SW2->W2_FRETEIN                  
				IF nQtd > 0
				(cAlias)->WKCUS_U_R  := (cAlias)->WKCUS_T_R / nQtd
				(cAlias)->WKCUS_U_P  := (cAlias)->WKCUS_T_P / nQtd                                    
				Endif
				Endif
				*/

				Case (cAlias)->WKDESPESA == "102" // frete

				nFret_T_R := 0
				nFret_T_P := 0
				nFret_U_R := 0
				nFret_U_P := 0

				SW2->(dbSetOrder(1))
				SW2->(dbSeek(xFilial()+TNR_PO))
				IF SW2->(!Eof() .And. W2_FREINC $ cSim) //.Or. SW2->W2_FRETEIN > 0
					nFret_T_R := (cAlias)->WKCUS_T_R
					nFret_T_P := (cAlias)->WKCUS_T_P
					nFret_U_R := (cAlias)->WKCUS_U_R
					nFret_U_P := (cAlias)->WKCUS_U_P
				Endif

				/*
				IF SW2->W2_FRETEIN > 0
				nQtd := (cAlias)->(WKCUS_T_R/WKCUS_U_R)
				nParidade := Round((cAlias)->WKCUS_T_P/(cAlias)->WKCUS_T_R,4)

				(cAlias)->WKCUS_T_P  := SW2->W2_FRETEIN * nParidade
				(cAlias)->WKCUS_T_R  := SW2->W2_FRETEIN                  
				IF nQtd > 0
				(cAlias)->WKCUS_U_R  := (cAlias)->WKCUS_T_R / nQtd
				(cAlias)->WKCUS_U_P  := (cAlias)->WKCUS_T_P / nQtd                                    
				Endif
				Endif
				*/

				Case (cAlias)->WKDESPESA == "1R9" .Or.; // CIF
				(cAlias)->WKDESPESA $ "T98/T96/T97TR9/T93/T94/T95/T90/000"

				IF Valtype(nFret_T_R) <> "N"   
					nFret_T_R := 0
					nFret_T_P := 0
					nFret_U_R := 0
					nFret_U_P := 0
				Endif

				/*
				IF AllTrim(SW2->W2_FREPPCC) == "PP" .And. SW2->W2_FRETEIN > 0 .And. SW2->W2_FREINC $ cSim
				nQtd := (cAlias)->(WKCUS_T_R/WKCUS_U_R)
				nParidade := Round((cAlias)->WKCUS_T_P/(cAlias)->WKCUS_T_R,4)

				(cAlias)->WKCUS_T_P  -= SW2->W2_FRETEIN * nParidade
				(cAlias)->WKCUS_T_R  -= SW2->W2_FRETEIN                  
				IF nQtd > 0
				(cAlias)->WKCUS_U_R  := (cAlias)->WKCUS_T_R / nQtd
				(cAlias)->WKCUS_U_P  := (cAlias)->WKCUS_T_P / nQtd                                    
				Endif
				Endif
				*/

				(cAlias)->WKCUS_T_R -= nFret_T_R
				(cAlias)->WKCUS_T_P -= nFret_T_P
				(cAlias)->WKCUS_U_R -= nFret_U_R
				(cAlias)->WKCUS_U_P -= nFret_U_P
			End Case                   

			// ACERTAR TOTAL DO CUSTO DO ITEM...
			Do Case
				Case Work_2->WKDESPESA == "101" //FOB
				nTotBRL_CIF  := 0
				nTotUSD_CIF  := 0

				nTotBRL_Desp := 0
				nTotUSD_Desp := 0

				nTotBRL_II := 0
				nTotUSD_II := 0

				Case Work_2->WKDESPESA == "1R9"
				nTotBRL_CIF  := Work_2->WKCUS_T_P
				nTotUSD_CIF  := Work_2->WKCUS_T_R

				Case Work_2->WKDESPESA == "201"
				nTotBRL_II  := Work_2->WKCUS_T_P
				nTotUSD_II  := Work_2->WKCUS_T_R

				Case Work_2->WKDESPESA == "4R9" //Total Desp
				nTotBRL_Desp  := Work_2->WKCUS_T_P
				nTotUSD_Desp  := Work_2->WKCUS_T_R

				nRecWK1 := Work_1->(Recno())
				nTotFOB := 0
				Work_1->(dbGoTop())
				While Work_1->(!Eof())
					nTotFob += Work_1->WKFOB_TOT
					Work_1->(dbSkip())
				Enddo          
				Work_1->(dbGoTo(nRecWK1))


				aAreaWK2 := Work_2->(GetArea())

				lRegTriPO := (Work_1->(FieldPos("WKGRUPORT")) > 0)

				Work_1->(dbGotop())
				While Work_1->(!Eof())
					nRateio := Round(Work_1->WKFOB_TOT / nTotFOB,4)
					Work_2->(dbSetOrder(1))
					IF Work_2->(dbSeek(Work_1->WKCOD_I+IF(lRegTriPO,Work_1->WKGRUPORT,"")+"000"))
						Work_2->WKCUS_T_P := (nTotBRL_CIF+nTotBRL_Desp+nTotBRL_II)*nRateio
						Work_2->WKCUS_T_R := (nTotUSD_CIF+nTotUSD_Desp+nTotUSD_II)*nRateio	           
						Work_2->WKCUS_U_P := IF(Work_1->WKQTD_ACU>0,WKCUS_T_P / Work_1->WKQTD_ACU,0)
						Work_2->WKCUS_U_R := IF(Work_1->WKQTD_ACU>0,WKCUS_T_R / Work_1->WKQTD_ACU,0)           
					Endif

					Work_1->(dbSkip())
				Enddo          
				Work_1->(dbGoTo(nRecWK1))

				Work_2->(RestArea(aAreaWK2))
			End CAse

			Case cParam == "POS_GRAVA_TPC"           
			nVal101_Old := 0
			nVal102_Old := 0

			//nVal101 := GetSWHOld(SWH->WH_PO_NUM, "101")
			//nVal405 := GetSWHOld(SWH->WH_PO_NUM, "405")

			IF SW2->W2_FRETEIN > 0
				IF SWH->(dbSeek(xFilial()+SW2->W2_PO_NUM))
					While SWH->(!Eof() .And. WH_FILIAL == xFilial("SWH") .And. WH_PO_NUM == SW2->W2_PO_NUM)                  
						IF SWH->WH_DESPESA == "102"
							SWH->(RecLock("SWH",.F.))
							//nRateio := Round(SWH->WH_VALOR/nVal101,4)
							nRateio := GetRateio(SWH->WH_PO_NUM, SWH->WH_NR_CONT, SW2->W2_FOB_TOT)
							nParidade := Round(SWH->WH_VALOR_R/SWH->WH_VALOR,4)                  
							SWH->WH_VALOR_R  := SW2->W2_FRETEIN * nParidade * nRateio
							SWH->WH_VALOR    := SW2->W2_FRETEIN * nRateio                 	   	        
							SWH->(MsUnlock())
						Endif

						IF SWH->WH_DESPESA == "405"
							IF SWI->(dbSeek(xFilial()+SW2->W2_TAB_PC+SWH->WH_DESPESA))
								IF SWI->WI_IDVL = "2"
									SWH->(RecLock("SWH",.F.))
									//nRateio := Round(SWH->WH_VALOR/nVal405,4) 	                       
									nRateio := GetRateio(SWH->WH_PO_NUM, SWH->WH_NR_CONT, SW2->W2_FOB_TOT)
									nParidade := Round(SWH->WH_VALOR_R/SWH->WH_VALOR,4)                  
									SWH->WH_VALOR_R  := (SWI->WI_PERCAPL/100) * SW2->W2_FRETEIN * nParidade * nRateio
									SWH->WH_VALOR    := (SWI->WI_PERCAPL/100) * SW2->W2_FRETEIN * nRateio                  	   	        	                       
									SWH->(MsUnlock())
								Endif
							Endif
						Endif

						SWH->(dbSkip())	                  
					Enddo
				Endif
			Endif

			Case cParam == "TPC251GRAVA_GRV_SWH"
			Do Case
				Case SWH->WH_DESPESA == "101" // fob            
				IF AllTrim(SW2->W2_FREPPCC) == "PP" .And. SW2->W2_FRETEIN > 0
					nRateio := GetRateio(SWH->WH_PO_NUM, SWH->WH_NR_CONT, SW2->W2_FOB_TOT)
					nParidade := Round(SWH->WH_VALOR_R/SWH->WH_VALOR,4)

					SWH->WH_VALOR_R  -= SW2->W2_FRETEIN * nParidade * nRateio
					SWH->WH_VALOR    -= SW2->W2_FRETEIN * nRateio
				Endif

				Case SWH->WH_DESPESA == "102"

				IF Type("lAvFluxo") == "L" .And. lAvFluxo
					IF cAlias == "SW7"
						SW2->(dbSetOrder(1))
						SW2->(dbSeek(xFilial()+SW6->W6_PO_NUM))
						lFreteInc := (SW2->W2_FREINC == "1")
					Else
						lFreteInc := (SW2->W2_FREINC == "1")
					Endif        

					IF lFreteInc
						SWH->(dbDelete())
					Endif
				Else
					nRateio := GetRateio(SWH->WH_PO_NUM, SWH->WH_NR_CONT, SW2->W2_FOB_TOT)
					nParidade := Round(SWH->WH_VALOR_R/SWH->WH_VALOR,4)

					if SW2->W2_FRETEIN > 0
						SWH->WH_VALOR_R  := SW2->W2_FRETEIN * nParidade * nRateio
						SWH->WH_VALOR    := SW2->W2_FRETEIN * nRateio
					Endif
				Endif
			End Case                           
		End case
	End Sequence

Return xRet

//-------------------------------------------------------------------------------
Static Function GetSWHOld(cPO, cDesp)

	Local aAreaSWH := SWH->(GetArea())
	Local nValor   := 0

	Begin Sequence
		SWH->(dbSetOrder(1))
		IF SWH->(dbSeek(xFilial()+SW2->W2_PO_NUM))
			While SWH->(!Eof() .And. WH_FILIAL == xFilial("SWH") .And. WH_PO_NUM == SW2->W2_PO_NUM)                  
				IF SWH->WH_DESPESA == cDesp
					nValor += SWH->WH_VALOR
				Endif

				SWH->(dbSkip())	                  
			Enddo
		Endif
	End Sequence

	SWH->(RestArea(aAreaSWH))

Return nValor

//-------------------------------------------------------------------------------
Static Function GetRateio(cPO, cNr_cont, nFobTot)

	Local aAreaSW3 := SW3->(GetArea())
	Local nValor   := 0
	Local nRAteio  := 1

	Begin Sequence
		SW3->(dbSetOrder(1))
		SW3->(dbSeek(xFilial()+cPO))

		While SW3->(!Eof() .And. W3_FILIAL == xFilial("SW3") .And. W3_PO_NUM == cPO)                 
			IF SW3->W3_SEQ <> 0
				SW3->(dbSkip())	                  
				Loop
			Endif

			IF SW3->W3_NR_CONT <> cNr_Cont
				SW3->(dbSkip())	                  
				Loop
			Endif

			nValor  := SW3->W3_PRECO * SW3->W3_QTDE
			nRateio := nValor/nFobTot

			Exit
		Enddo

	End Sequence

	SW3->(RestArea(aAreaSW3))

Return Round(nRateio,4)
