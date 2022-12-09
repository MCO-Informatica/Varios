#Include "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: fGFrete  | Autor: Celso Ferrone Martins   | Data: 23/05/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | Danilo Alves Del Busso					| Data: 20/10/2015 |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function fGFrete(cCpoSua)

Local cRetCpo    := ""
Local aParamCst  := {}
Local aRetCusto  := {}
Local nZ01FTonel := 0
Local nValFrete  := 0
Local aValFrete  := {}
Local nFatorFret := 1
Local nZ03FreEnt := 0

Local nPosProd   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // Produto
Local nPosMP     := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MP"})   // Materia Prima
Local nPosEM     := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_EM"})   // Embalagem
Local nPosCapa   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"}) // Capacidade
Local nPosDens   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_DENS"}) // Densidade
Local nPosVal    := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VAL"})  // Valor tabela
Local nPosTabe   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TABE"}) // Tabela
Local nPosMoed   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MOED"}) // Moeda
Local nPosIpi    := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_IPI"})  // IPI
Local nPosMark   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MARK"}) // MarkUp
Local nPosVqUm   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_UM"})   // Unidade de Medida Verquimica
Local nPosTemt   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TEMT"}) // Tem Tabela ?

Local nPosVRTb   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRCTAB"})  // Tabela de Preço
Local nPosUmVq   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_UMVQ"}) // Unidade de Medida Padrao
Local nPosMoVq   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_MOVQ"}) // Moeda Padrao

Local nPQtdVer   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"}) // Quantidade
Local nPUniVer   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"}) // Valor Unitário
Local nPTotVer   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_VLRI"}) // Valor Total

Local nPQtdUm1   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})   // 1a-Quantidade
Local nPUniUm1   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT"})  // 1a-Valor Unitário
Local nPTotUm1   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"}) // 1a-Valor Total

Local nPQtdUm2   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT2"})  // 2a-Quantidade
Local nPUniUm2   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT2"}) // 2a-Valor Unitário
Local nPTotUm2   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITE2"}) // 2a-Valor Total

Local nPosTICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TICM"}) // Tipo de Icms
Local nPosPICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PICM"}) // Percentual de ICMS
Local nPosPPis   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PPIS"}) // Percentual de Pis
Local nPosPCof   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PCOF"}) // Percentual de Cof

Local nPosSICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_SICM"}) // ICMS Substituicao Triburaria
Local nPosVIPI   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VIPI"}) // Valor do IPI

Local nPosTax2   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TAX2"}) // Taxa Utilizada na M2

Local nPosVolum  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VOLU"}) // VOLUME

Local nPosTes    := aScan(aHeader,{|x| Alltrim(x[2])=="UB_TES"})     // TES                                

Local nPosPrcA 	 := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_A"}) // PREÇO TABELA A Cassio Lima 18/10/2016 MCINFOTEC 
Local nPosPrcB   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_B"}) // PREÇO TABELA B Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcC   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_C"}) // PREÇO TABELA C Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcD   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_D"}) // PREÇO TABELA D Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcE   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_E"}) // PREÇO TABELA E Cassio Lima 18/10/2016 MCINFOTEC


Local nFatorDens  := 1
Local lDensidade  := .F.
Local lMoeda      := .F.

Local aAreaZ02   := Z01->(GetArea())
Local aAreaZ03   := Z03->(GetArea())
Local aAreaSb1   := SB1->(GetArea())
Local aAreaSe4   := SE4->(GetArea())
Local aAreaSa1   := SA1->(GetArea())
Local aAreaSf7   := SF7->(GetArea())
Local aAreaSu7   := SU7->(GetArea())
Local aAreaSA3   := SA3->(GetArea())
Local aAreaSf4   := SF4->(GetArea())

Local nPesoTot   := 0
Local nPesoTBr	 := 0 //DANILO BUSSO 20/10/2015
Local nQtdEmb    := 0    
Local nSe4Indice := 1
Local nSa1Indice := 0


Local aIcmsAli   := {}
Local aIcmsOri   := {}
Local cIcmsTipo  := "N"  // Tipo de Icms Aplicado / N=Normal / C=Cliente / P=Produto
Local nIcmsCliVq := 18   // ICMS Do Estado do Cliente
Local nPisCCliVq := 9.25 // Pis Cofins
//Local nIcmsCalPr := 18   // ICMS Base de Calculo Tabela de Preco
Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco

Local _nIcmPerc   := 0
Local _nIcmBase   := 0
Local _nIcmValor  := 0

Local _nIpiValor  := 0
Local _nIcmsSt    := 0

Local _nPisPerc   := 0
Local _nPIsBase   := 0
Local _nPisValor  := 0

Local _nCofPerc   := 0
Local _nCofBase   := 0
Local _nCofValor  := 0

DbSelectArea("Z02")
DbSetOrder(1)

DbSelectArea("Z03")
DbSetOrder(2)

DbSelectArea("SE4")
DbSetOrder(1)

DbSelectArea("SA1")
DbSetOrder(1)

DbSelectArea("SF7")
DbSetOrder(1)

DbSelectArea("SF4")
DbSetOrder(1)

DbSelectArea("SB1")
DbSetOrder(1)

If SA1->A1_VQ_CMAD > 0
	nSa1Indice := SA1->A1_VQ_CMAD
EndIf

If SE4->(DbSeek(xFilial("SE4")+M->UA_CONDPG))
	If SE4->E4_VQ_INDI > 0
		nSe4Indice := SE4->E4_VQ_INDI
	EndIf
EndIf

If AllTrim(cCpoSua) == "UA_VQ_FRET"
	cRetCpo := M->UA_VQ_FRET
ElseIf AllTrim(cCpoSua) == "UA_VQ_FCLI"
	cRetCpo := M->UA_VQ_FCLI
ElseIf AllTrim(cCpoSua) == "UA_VQ_FVER"
	cRetCpo := M->UA_VQ_FVER
ElseIf AllTrim(cCpoSua) == "UA_VQ_FVAL"
	cRetCpo := M->UA_VQ_FVAL
ElseIf AllTrim(cCpoSua) == "UA_CONDPG"
	cRetCpo := M->UA_CONDPG
ElseIf AllTrim(cCpoSua) == "UA_CLIENTE"
	cRetCpo := M->UA_CLIENTE
ElseIf AllTrim(cCpoSua) == "UA_LOJA"
	cRetCpo := M->UA_LOJA
ElseIf AllTrim(cCpoSua) == "UB_TES"
	cRetCpo := M->UB_TES
EndIf

AjustaSx6()

aIcmsAli := &(StrTran(StrTran(FormatIn(AllTrim(GetMv("VQ_ICMSALI")),"|"),"(","{"),")","}"))
aIcmsOri := &("{{'"+StrTran(StrTran(AllTrim(GetMv("VQ_ICMSORI")),"-","',"),"|","},{'")+"}}")

For Nx := 1 To Len(aIcmsAli)
	If SubStr(aIcmsAli[nX],1,2) == SA1->A1_EST
		cIcmsTipo  := "C"
		nIcmsCliVq := Val(SubStr(aIcmsAli[nX],3,2))
	EndIf
Next Nx

For nX := 1 To Len(aCols)
	If !GdDeleted(nX,aHeader,aCols)
		If !Empty(aCols[nX][nPosProd])
			If aCols[nX][nPosVqUm] == "KG"
				nPesoTot += aCols[nX][nPQtdVer]  
			Else
				nPesoTot += aCols[nX][nPQtdVer] * aCols[nX][nPosDens]
			EndIf
			If AllTrim(aCols[nx][nPosEM]) != "03000"
				nQtdEmb              += aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
				aCols[nx][nPosVolum] := aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
			EndIf
		EndIf
	EndIf
Next nX
M->UA_PESOL := nPesoTot // DANILO BUSSO 20/10/2015   
M->UA_VQ_QEMB := nQtdEmb

For nX := 1 To Len(aCols)
	If !GdDeleted(nX,aHeader,aCols)
		If !Empty(aCols[nX][nPosProd])
			
			Z02->(DbSeek(xFilial("Z02")+aCols[nX][nPosProd]))
			Z03->(DbSeek(xFilial("Z03")+aCols[nX][nPosProd]+Z02->Z02_REVISA+aCols[nX][nPosTabe]))
			
			If Z02->Z02_UM == aCols[nX][nPosVqUm] .And. Z02->Z02_MOEDA == aCols[nX][nPosMoed]
				nZ03FreEnt := Z03->Z03_FREENT
			Else
				nZ03FreEnt := Z03->Z03_FREENT
			EndIf
			
			_cIcmsTipo  := cIcmsTipo
			/*
			_nIcmPerc := nIcmsCliVq
			
			SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
			If SA1->A1_EST != "SP"
				For nY := 1 To Len(aIcmsOri)
					If aIcmsOri[nY][1] == SB1->B1_ORIGEM
						_cIcmsTipo  := "O"
						_nIcmPerc := aIcmsOri[nY][2]
						Exit
					EndIf
				Next nY
			EndIf
			
			If !Empty(SB1->B1_GRTRIB)
				If SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB))
					While !SF7->(Eof()) .And. SF7->(F7_FILIAL+F7_GRTRIB) == xFilial("SF7")+SB1->B1_GRTRIB
						If SF7->F7_EST == SA1->A1_EST .And. SF7->F7_TIPOCLI $ M->UA_TIPOCLI+"|*"
							_cIcmsTipo  := "P"
							If AllTrim(SB1->B1_GRTRIB) == "001"
								_nIcmPerc := SF7->F7_ALIQINT // VERIFICAR - CELSO MARTINS 05/01/2015
							Else
								_nIcmPerc := SF7->F7_ALIQEXT // VERIFICAR - CELSO MARTINS 05/01/2015
							EndIf
							Exit
						EndIf
						SF7->(DbSkip())
					EndDo
				EndIf
			EndIf
			*/
			
			//*******************************************************************//
			//************* Validar esse trecho // Celso Martins ****************//
			//*******************************************************************//
			
			//_nIcmPerc := nIcmsCliVq
			
			_nIcmPerc  := 0
			_nIcmBase  := 0
			_nIcmValor := 0
			
			_nPisPerc  := 0
			_nPIsBase  := 0
			_nPisValor := 0
			
			_nCofPerc  := 0
			_nCofBase  := 0
			_nCofValor := 0
			
			If !Empty(aCols[nX][nPosTes])
				
				If SF4->(DbSeek(xFilial("SF4")+aCols[nX][nPosTes]))
					cDifal := cValToChar(SF4->F4_DIFAL)                      
				    If(cDifal == '1')  					
						_nIcmPerc := MaFisRet(nX,"IT_ALIQSOL")					
					Else                                
						_nIcmPerc  := MaFisRet(nX,"IT_ALIQICM")			    
				    EndIf
				   
					_nIcmBase  := MaFisRet(nX,"IT_BASEPIS")
					_nIcmValor := MaFisRet(nX,"IT_VALPIS")
					
					_nIpiValor := MaFisRet(nX,"IT_VALIPI")
					_nIcmsSt   := 0

					If !SF4->F4_CSTPIS $ "06/07"
						_nPisPerc  := MaFisRet(nX,"IT_ALIQPIS")
						_nPIsBase  := MaFisRet(nX,"IT_BASEPIS")
						_nPisValor := MaFisRet(nX,"IT_VALPIS")
					EndIf

					If !SF4->F4_CSTCOF $ "06/07"
						_nCofPerc  := MaFisRet(nX,"IT_ALIQCOF")
						_nCofBase  := MaFisRet(nX,"IT_BASECOF")
						_nCofValor := MaFisRet(nX,"IT_VALCOF")
					EndIf

				EndIf
				
			EndIf
			
			SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
			
			nFatorFret := iIf(M->UA_VQ_QEMB<=1.And.SB1->B1_VQ_FRT2=="S",2,1)
			
			/*
			||||||||||||||||||||||||||||||||||||||||||||||
			||| V=Verquimica - N=Normal                |||
			||||||||||||||||||||||||||||||||||||||||||||||
			*/
			If      M->UA_VQ_FRET == "V" .And. M->UA_VQ_FVER == "N"
				nValFrete := nZ03FreEnt * nFatorFret
				/*
				||||||||||||||||||||||||||||||||||||||||||||||
				||| V=Verquimica - N=Negociada Retira      |||
				||||||||||||||||||||||||||||||||||||||||||||||
				*/
			ElseIf  M->UA_VQ_FRET == "V" .And. M->UA_VQ_FVER == "R"
				nValFrete := (M->UA_VQ_FVAL / nPesoTot) * 1000
				//ALERT("1 - "+STR(nValFrete))
				If Z02->Z02_UM != "KG"
					nValFrete := nValFrete * aCols[nX][nPosDens]
					//ALERT("2 - "+STR(nValFrete))
				EndIf
				If Z02->Z02_MOEDA == "2"
					nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
					nValFrete := nValFrete / nVqTaxaM2
					//ALERT("3 - "+STR(nValFrete))

				EndIf
				//nValFrete += (nZ03FreEnt * nFatorFret)
				/*
				||||||||||||||||||||||||||||||||||||||||||||||
				||| V=Verquimica - D=Negociada Redespacho  |||
				||||||||||||||||||||||||||||||||||||||||||||||
				*/
			ElseIf  M->UA_VQ_FRET == "V" .And. M->UA_VQ_FVER == "D"
				nValFrete := (M->UA_VQ_FVAL / nPesoTot) * 1000
				If Z02->Z02_UM != "KG"
					nValFrete := nValFrete * aCols[nX][nPosDens]
				EndIf
				If Z02->Z02_MOEDA == "2"
					nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
					nValFrete := nValFrete / nVqTaxaM2
				EndIf
				nValFrete += (nZ03FreEnt * nFatorFret)
				/*
				||||||||||||||||||||||||||||||||||||||||||||||
				||| C=Cliente - R=Retira                   |||
				||||||||||||||||||||||||||||||||||||||||||||||
				*/
			ElseIf M->UA_VQ_FRET == "C" .And. M->UA_VQ_FCLI == "R"
				nValFrete := 0
				/*
				||||||||||||||||||||||||||||||||||||||||||||||
				||| C=Cliente - D= Redespacho              |||
				||||||||||||||||||||||||||||||||||||||||||||||
				*/
			ElseIf  M->UA_VQ_FRET == "C" .And. M->UA_VQ_FCLI == "D"
				nValFrete := nZ03FreEnt * nFatorFret
			EndIf
			
			//			If Z02->Z02_UM != "KG"
			//				nValFrete := nValFrete * aCols[nX][nPosDens]
			//			EndIf
			
			If aCols[nX][nPosUmVq] == aCols[nX][nPosVqUm]
				lTrocaUm := .F.
			Else
				lTrocaUm := .T.
				aCols[nX][nPosUmVq] := aCols[nX][nPosVqUm]
			EndIf
			
			If aCols[nx][nPosMoVq] == aCols[nx][nPosMoed]
				lTrocaMo := .F.
			Else
				lTrocaMo := .T.
				aCols[nx][nPosMoVq] := aCols[nx][nPosMoed]
			EndIf
			
			aParamCst := {}
			Aadd(aParamCst,aCols[nX][nPosProd])	// 01 - Produto
			Aadd(aParamCst,aCols[nX][nPosMoed])	// 02 - Moeda
			Aadd(aParamCst,aCols[nX][nPosVqUm])	// 03 - Unidade de Medida
			Aadd(aParamCst,aCols[nX][nPosTabe])	// 04 - Tabela de Preco
			Aadd(aParamCst,nValFrete)			// 05 - Valor do Frete
			Aadd(aParamCst,aCols[nX][nPQtdVer])	// 06 - Quantidade - Calc.
			Aadd(aParamCst,aCols[nX][nPUniVer])	// 07 - Valor Unitario Digitado
			Aadd(aParamCst,lTrocaUm)			// 08 - Troca UM
			Aadd(aParamCst,lTrocaMo)            // 09 - Troca Mo
			Aadd(aParamCst,_nIcmPerc)			// 10 - Icms do Cliente
			Aadd(aParamCst,nSe4Indice)			// 11 - Fator Cond. Pagamento
			Aadd(aParamCst,nSa1Indice)			// 12 - Fator Cliente
			
			Aadd(aParamCst,_nPisPerc)			// 13 - Pis
			Aadd(aParamCst,_nCofPerc)			// 14 - Cofins

			aRetCusto := U_fCfmCusto(aParamCst)

			aRetCustA := U_fCfmCA(aParamCst)
			aRetCustB := U_fCfmCB(aParamCst)
			aRetCustC := U_fCfmCC(aParamCst)
			aRetCustD := U_fCfmCD(aParamCst)
			aRetCustE := U_fCfmCE(aParamCst)
			
			/*
			If Alltrim(aCols[nX][nPosEM]) == '03000'
				If Z02->Z02_UM != aCols[nX][nPosVqUm]
					If Z02->Z02_UM == "K"
						aRetCusto[1] := aRetCusto[1] / aCols[nX][nPosDens]
					Else
						aRetCusto[1] := aRetCusto[1] * aCols[nX][nPosDens]
					EndIf
				EndIf
			EndIf
			*/
			
			aCols[nX][nPosVal]  := aRetCusto[1]
			aCols[nX][nPosTICM] := _cIcmsTipo
			aCols[nX][nPosPICM] := _nIcmPerc
			aCols[nX][nPosPPis] := _nPisPerc
			aCols[nX][nPosPCof] := _nCofPerc
			aCols[nX][nPosVIPI] := _nIpiValor     
			aCols[nX][nPosPrcA]  := aRetCustA[1]
			aCols[nX][nPosPrcB]  := aRetCustB[1]
			aCols[nX][nPosPrcC]  := aRetCustC[1]
			aCols[nX][nPosPrcD]  := aRetCustD[1]
			aCols[nX][nPosPrcE]  := aRetCustE[1]
		           
			nPesoTBr := nPesoTBr + (aRetCusto[4] * (aCols[nx][nPQtdVer] / aCols[nx][nPosCapa])) // DANILO BUSSO 20/10/2015
		EndIf      
	EndIf
Next Nx         
M->UA_PESOB := nPesoTot + nPesoTBr // DANILO BUSSO 20/10/2015

If AllTrim(cCpoSua) == "UA_CLIENTE"
	
	DbSelectArea("SU7") ; DbSetOrder(4)
	DbSelectArea("SA3") ; DbSetOrder(1)
	If SU7->(DbSeek(xFilial("SU7") + __cUserId))
		If SA3->(DbSeek(xFilial("SA3")+SU7->U7_CODVEN))
			M->UA_VEND    := SA3->A3_COD
			M->UA_DESCVEN := SA3->A3_NOME
		EndIf
	EndIf
	
EndIf

Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))
SB1->(RestArea(aAreaSb1))
SE4->(RestArea(aAreaSe4))
SA1->(RestArea(aAreaSa1))
SF7->(RestArea(aAreaSf7))

SA3->(RestArea(aAreaSa3))
SU7->(RestArea(aAreaSu7))
SF4->(RestArea(aAreaSf4))

oGetTLV:Refresh()
TK273DesCab()

//ALERT("4 - "+STR(nValFrete))

Return(cRetCpo)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmTaxm2 | Autor: Celso Ferrone Martins   | Data: 23/07/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Retorna a taxa da moeda 2                                  |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmTaxm2()

Local nRet := 1
Local aAreaSm2 := SM2->(GetArea())

DbSelectArea("SM2") ; DbSetOrder(1)
If SM2->(DbSeek(dTos(dDataBase)))
	nRet := SM2->M2_MOEDA2
Else
	RecLock("SM2",.T.)
	SM2->M2_DATA := dDataBase
	MsUnLock()
EndIf

If nRet == 0
	nRet := 1
EndIf

SM2->(RestArea(aAreaSm2))

Return(nRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: AjustaSx6 | Autor: Celso Ferrone Martins  | Data: 30/07/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Ajuste de Parametros SX6                                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function AjustaSx6()

Local cX6Desc1  := ""
Local cX6Desc2  := ""
Local cX6Desc3  := ""
Local nTamSx3   := 0
Local cConteud  := ""

cX6Var    := "VQ_ICMSALI"
cX6Desc1  := "ICMS Utilizado na venda entre estados.            "
cX6Desc2  := "                                                  "
cX6Desc3  := "FGFRETE.PRW                                       "
cConteud  := "AC07|AL07|AM07|AP07|BA07|CE07|DF07|ES07|GO07|MA07|MG12|MS07|MT07|PA07|PB07|PE07|PI07|PR12|RJ12|RN07|RO07|RR07|RS12|SC12|SE07|SP18|TO07"

DbSelectArea("SX6") ; DbSetOrder(1)

If !SX6->(DbSeek(Space(2) + cX6Var))
	If !SX6->(DbSeek( cFilAnt + cX6Var))
		RecLock("SX6",.T.)
		SX6->X6_FIL     := cFilAnt
		SX6->X6_VAR     := cX6Var
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := cX6Desc1
		SX6->X6_DSCSPA  := cX6Desc1
		SX6->X6_DSCENG  := cX6Desc1
		SX6->X6_DESC1   := cX6Desc2
		SX6->X6_DSCSPA1 := cX6Desc2
		SX6->X6_DSCENG1 := cX6Desc2
		SX6->X6_DESC2   := cX6Desc3
		SX6->X6_DSCSPA2 := cX6Desc3
		SX6->X6_DSCENG2 := cX6Desc3
		SX6->X6_CONTEUD := cConteud
		SX6->X6_PROPRI  := "U"
		SX6->X6_PYME    := "N"
		MsUnlock()
	EndIf
EndIf

cX6Var    := "VQ_ICMSORI"
cX6Desc1  := "ICMS entre estados conforme origem de produto     "
cX6Desc2  := "Exemplo: 1-4|2-4.5|3-4  onde origem-icms          "
cX6Desc3  := "FGFRETE.PRW                                       "
cConteud  := "1-4|2-4|3-4|8-4"

DbSelectArea("SX6") ; DbSetOrder(1)

If !SX6->(DbSeek(Space(2) + cX6Var))
	If !SX6->(DbSeek( cFilAnt + cX6Var))
		RecLock("SX6",.T.)
		SX6->X6_FIL     := cFilAnt
		SX6->X6_VAR     := cX6Var
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := cX6Desc1
		SX6->X6_DSCSPA  := cX6Desc1
		SX6->X6_DSCENG  := cX6Desc1
		SX6->X6_DESC1   := cX6Desc2
		SX6->X6_DSCSPA1 := cX6Desc2
		SX6->X6_DSCENG1 := cX6Desc2
		SX6->X6_DESC2   := cX6Desc3
		SX6->X6_DSCSPA2 := cX6Desc3
		SX6->X6_DSCENG2 := cX6Desc3
		SX6->X6_CONTEUD := cConteud
		SX6->X6_PROPRI  := "U"
		SX6->X6_PYME    := "N"
		MsUnlock()
	EndIf
EndIf

Return()



/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fCfmCusto | Autor: Celso Ferrone Martins  | Data: 28/04/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Calcula o custo do Produto                                 |||
|||           |                                                            |||
|||           | aCfmParam[01] // Produto            // 01VERTBRN0          |||
|||           | aCfmParam[02] // Moeda              // 01-Real  - 02-Dolar |||
|||           | aCfmParam[03] // Unidade de Medida  // 01-Litro - 02-Kilo  |||
|||           | aCfmParam[04] // Tabela de Preco    // A-B-C-D-E           |||
|||           | aCfmParam[05] // Valor do Frete     //                     |||
|||           | aCfmParam[06] // Quantidade - Calc. //                     |||
|||           | aCfmParam[07] // Vlr Digitado       //                     |||
|||           | aCfmParam[08] // Troca UM           //                     |||
|||           | aCfmParam[09] // Troca Moeda        //                     |||
|||           | aCfmParam[10] // Icms do Cliente    //                     |||
|||           | aCfmParam[11] // Indice Cond.Pagto. //                     |||
|||           |                                                            |||
|||           | aCfmParam[12] // Indice do Cliente  //                     |||
|||           |                                                            |||
|||           | aCfmParam[13] // Pis                //                     |||
|||           | aCfmParam[14] // Cofins             //                     |||
|||           |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function fCfmCusto(aCfmParam)

Local aRetValor   := {}
Local aAreaSb1    := SB1->(GetArea("SB1"))
Local nFatorMoed  := CfmTaxm2()

Local cParamCod  := aCfmParam[01]
Local cParamMoe  := aCfmParam[02]
Local cParamUni  := aCfmParam[03]
Local cParamTab  := aCfmParam[04]
Local nParamFre  := aCfmParam[05]
Local nParamQtd  := aCfmParam[06]
Local nVlrUnit   := aCfmParam[07]
Local lTrocaUm   := aCfmParam[08]
Local lTrocaMo   := aCfmParam[09]
Local nIcmsCliVq := aCfmParam[10]   // Icms Padrao da Tabela
Local nIndSe4    := aCfmParam[11]

Local nIndSa1    := aCfmParam[12]

Local nTxPisVq   := aCfmParam[13]
Local nTxCofVq   := aCfmParam[14]

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // nsTxPisVq+nTxCofVq//9.25 // Pis Cofins // nTxPisVq+nTxCofVq // VERIFICAR PIS E COFINS // CELSO MARTINS

Local nCusOpera  := 0		// Custo Operacional
Local nFatorMp   := 0		// Fator
Local nIcmsMp    := 0		// ICMS Materia Prima
Local nIcmsEm    := 0		// ICMS Embalagem
Local nIcmsPa    := 0		// ICMS Produto Pai
Local nIpiMp     := 0		// IPI Materia Prima
Local nIpiEm     := 0		// IPI Embalagem
Local nIpiPa     := 0		// IPI Produto Pai
Local nCapacid   := 0		// Capacidade da embalagem
Local nReComMp   := 0		// Referencia de Compra Materia Prima
Local nReComEm   := 0		// Referencia de Compra Embalagem
Local nTxMoed2   := 0		// Taxa Moeda 2
Local nFreteTon  := 0		// Frete por Tonelada
Local nFreteMet  := 0		// Frete por Metro Cubico
Local nBasCalc   := 0		// Base para calculo de conversao
Local nPercExt   := 0		// Percentual Extra da Embalagem
Local nFreteMp   := 0		// Frete de Compras
Local nPesoEm    := 0		// Peso da Embalagem
Local nBasCalcKg := 0		//
Local cRevAtua   := ""		//
Local cRevNova   := ""		//
Local nPercPis   := 1.65	// % Pis
Local nPercCof   := 7.60	// % Cofins
Local nPercIR    := 2.00	// % IR

Local nIcmInd    := 0		// Indice de Icms Tabela
Local nIcmIndPrd := 0		// Indice de Icms Produto
Local nIcmDif    := 0		// Diferencial de Icms

Private nMargemA := 0		// Margem Tabela A
Private nMargemB := 0		// Margem Tabela B
Private nMargemC := 0		// Margem Tabela C
Private nMargemD := 0		// Margem Tabela D
Private nMargemE := 0		// Margem Tabela E

If GetMV("VQ_DTCOTAC", .F.) <= dDataBase
	nFreteTon := GetMV("VQ_FRETONE", .F.)
	nFreteMet := GetMV("VQ_FRETMET", .F.)
	nBasCalc  := Z01->Z01_BASECA
EndIf

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
nFatorMp := SB1->B1_CONV
cUmPai   := SB1->B1_UM

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
nCapacid := SB1->B1_VQ_ECAP // ok

If SB1->B1_COD != "03000"
	aAreaNow := SG1->(GetArea())
	SG1->(DbSeek(xFilial("SG1")+Z02->(Z02_COD+Z02_CODMP)))
	If SB1->B1_VQ_UMEM == cUmPai
		nCapacid := SG1->G1_QUANT
	ElseIf cUmPai == "KG"
		nCapacid := SG1->G1_QUANT/nFatorMp
	Else
		nCapacid := SG1->G1_QUANT*nFatorMp
	EndIf
	SG1->(RestArea(aAreaNow))
EndIf

nPesoEm  := SB1->B1_PESO //DANILO BUSSO 20/10/2015       

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))

nFatorMp  := Z02->Z02_DENSID
nTxMoed2  := Z02->Z02_TXMOED
nReComMp  := Z02->Z02_REFCOM
nFreteMp  := Z02->Z02_FRETEC
nMargemA  := Z02->Z02_MARGEA
nMargemB  := Z02->Z02_MARGEB
nMargemC  := Z02->Z02_MARGEC
nMargemD  := Z02->Z02_MARGED
nMargemE  := Z02->Z02_MARGEE
nCusOpera := Z02->Z02_CUSOPE
nIcmsMp   := Z02->Z02_PICMMP
nIpiMp    := Z02->Z02_PIPIMP
nIcmsEm   := Z02->Z02_PICMEM
nIpiEm    := Z02->Z02_PIPIEM
nReComEm  := Z02->Z02_CUSTO
nPercExt  := Z02->Z02_PEXTRA

nIcmInd    := 1-(Z02->Z02_PICMMP/100)
nIcmIndPrd := 1-(nIcmsMp/100)
nIcmDif    := ((nReComMp*(nIcmInd))/nIcmIndPrd)-nReComMp
nBasCalcKg := nBasCalc*nFatorMp

nZ03Capaci := nCapacid
nZ03CustoE := Z03->Z03_CUSTOE //( nReComEm + ((nReComEm*nIpiEm)/100) ) * (nBasCalc/nCapacid)
nZ03FreEnt := nParamFre       //Round(((nFreteTon*(((nBasCalc/nCapacid)*nPesoEm)+nBasCalcKg))/nBasCalc),2) // Alterar esse campo
nZ03Custo1 := Round(nReComMp+nFreteMp+nZ03CustoE+((nReComMp*nPercExt)/100),2)

cZ03Tabela  := cParamTab
If Empty(cZ03Tabela)
	MsgStop("Não existe tabela para esse item !","Sem informação obrigatória!")
	Return aRetValor

EndIf

nZ03Margem  := &("nMargem"+If(Empty(cZ03Tabela), "A", cZ03Tabela))
nValExtr   := (Round((nReComMp*nPercExt)/100,2))
nCalc01    := (nReComMp*(1-nIcmsMp/100))+nFreteMp+nValExtr+nZ03FreEnt
nCalc02    := (nReComMp+nFreteMp+nZ03CustoE+nZ03FreEnt)*((nPercPis+nPercCof)/100)
nCalc03    := nZ03CustoE*((100-nIcmsEm)/100)
nCalc04    := 100-nIcmsMp-nPercPis-nPercCof-nPercIR-(nCusOpera+nZ03Margem)
nCalc05    := ((nCAlc01-nCalc02+nCalc03)/nCalc04)*100
nZ03Markup := nZ03Custo1/nCalc05
nZ03Markup := Round(nZ03Markup,4)

nZ03ValVen := nZ03Custo1/nZ03Markup
nZ03ValCal := nZ03ValVen/nBasCalc
nZ03ValIcm := (nZ03ValVen-(nReComMp+nIcmDif+nZ03CustoE))*(nIcmsMp/100)
nZ03PisCof := (nZ03ValVen-(nReComMp+nIcmDif+nFreteMp+nZ03CustoE+nZ03FreEnt))*((nPercPis+nPercCof)/100)
nZ03CusOpe := nZ03ValVen*(nCusOpera/100)
nZ03Custo2 := nZ03FreEnt+nZ03Custo1+nZ03ValIcm+nZ03PisCof+nZ03CusOpe
nZ03LucBru := nZ03ValVen-nZ03Custo2
nZ03ValIr  := nZ03ValVen*(nPercIR/100)
nZ03LucLiq := nZ03LucBru-nZ03ValIr

If SB1->B1_UM == Z02->Z02_UM
	nValUnt1 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt2 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt2 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
Else
	nValUnt2 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt1 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt1 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
EndIf

If AllTrim(cParamUni) != AllTrim(Z02->Z02_UM)
	If Z02->Z02_UM == "KG"
		nZ03ValCal := nZ03ValCal * Z02->Z02_DENSID
	Else
		nZ03ValCal := nZ03ValCal / Z02->Z02_DENSID
	EndIf
EndIf

If cParamMoe != Z02->Z02_MOEDA
	If Z02->Z02_MOEDA == "1"
		nZ03ValCal := nZ03ValCal / nFatorMoed
	Else
		nZ03ValCal := nZ03ValCal * nFatorMoed
	EndIf
EndIf

nZ03ValCal := nZ03ValCal
nVlrUnit   := nVlrUnit
nZ03Markup := Round(nZ03Markup,4)

If cParamMoe == "2"
	_nVlrUnit := Round(nVlrUnit * nFatorMoed,6)
Else
	_nVlrUnit := nVlrUnit
EndIf

nFatPrd  := 1-((nIcmsMp/100)   +(nPisCCalPr/100))
nFatCli  := 1-((nIcmsCliVq/100)+(nPisCCliVq/100))

nZ03ValCal := Round(((nZ03ValCal*nFatPrd) /nFatCli),6)
nValUnt1   := Round(((nValUnt1  *nFatPrd) /nFatCli),2)
nValUnt2   := Round(((nValUnt2  *nFatPrd) /nFatCli),2)

nZ03ValCal := nZ03ValCal * nIndSe4
nValUnt1   := nValUnt1   * nIndSe4
nValUnt2   := nValUnt2   * nIndSe4

If nIndSa1 > 0
	nZ03ValCal := nZ03ValCal+(nZ03ValCal*(nIndSa1/100))
	nValUnt1   := nValUnt1  +(nValUnt1  *(nIndSa1/100))
	nValUnt2   := nValUnt2  +(nValUnt2  *(nIndSa1/100))
EndIf

Aadd(aRetValor,nZ03ValCal)	// 01-Valor Calculado
Aadd(aRetValor,nValUnt1)	// 12-Prc Unitario - Primeira Unidade
Aadd(aRetValor,nValUnt2)	// 13-Prc Unitário - Segunda Unidade
Aadd(aRetValor,nPesoEm)		// DANILO BUSSO 20/10/2015


SB1->(RestArea(aAreaSb1))

Return(aRetValor)



User Function fCfmCA(aCfmParam)

Local aRetValor   := {}
Local aAreaSb1    := SB1->(GetArea("SB1"))
Local nFatorMoed  := CfmTaxm2()

Local cParamCod  := aCfmParam[01]
Local cParamMoe  := aCfmParam[02]
Local cParamUni  := aCfmParam[03]
Local cParamTab  := aCfmParam[04]
Local nParamFre  := aCfmParam[05]
Local nParamQtd  := aCfmParam[06]
Local nVlrUnit   := aCfmParam[07]
Local lTrocaUm   := aCfmParam[08]
Local lTrocaMo   := aCfmParam[09]
Local nIcmsCliVq := aCfmParam[10]   // Icms Padrao da Tabela
Local nIndSe4    := aCfmParam[11]

Local nIndSa1    := aCfmParam[12]

Local nTxPisVq   := aCfmParam[13]
Local nTxCofVq   := aCfmParam[14]

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // nsTxPisVq+nTxCofVq//9.25 // Pis Cofins // nTxPisVq+nTxCofVq // VERIFICAR PIS E COFINS // CELSO MARTINS

Local nCusOpera  := 0		// Custo Operacional
Local nFatorMp   := 0		// Fator
Local nIcmsMp    := 0		// ICMS Materia Prima
Local nIcmsEm    := 0		// ICMS Embalagem
Local nIcmsPa    := 0		// ICMS Produto Pai
Local nIpiMp     := 0		// IPI Materia Prima
Local nIpiEm     := 0		// IPI Embalagem
Local nIpiPa     := 0		// IPI Produto Pai
Local nCapacid   := 0		// Capacidade da embalagem
Local nReComMp   := 0		// Referencia de Compra Materia Prima
Local nReComEm   := 0		// Referencia de Compra Embalagem
Local nTxMoed2   := 0		// Taxa Moeda 2
Local nFreteTon  := 0		// Frete por Tonelada
Local nFreteMet  := 0		// Frete por Metro Cubico
Local nBasCalc   := 0		// Base para calculo de conversao
Local nPercExt   := 0		// Percentual Extra da Embalagem
Local nFreteMp   := 0		// Frete de Compras
Local nPesoEm    := 0		// Peso da Embalagem
Local nBasCalcKg := 0		//
Local cRevAtua   := ""		//
Local cRevNova   := ""		//
Local nPercPis   := 1.65	// % Pis
Local nPercCof   := 7.60	// % Cofins
Local nPercIR    := 2.00	// % IR

Local nIcmInd    := 0		// Indice de Icms Tabela
Local nIcmIndPrd := 0		// Indice de Icms Produto
Local nIcmDif    := 0		// Diferencial de Icms

Private nMargemA := 0		// Margem Tabela A
Private nMargemB := 0		// Margem Tabela B
Private nMargemC := 0		// Margem Tabela C
Private nMargemD := 0		// Margem Tabela D
Private nMargemE := 0		// Margem Tabela E

If GetMV("VQ_DTCOTAC", .F.) <= dDataBase
	nFreteTon := GetMV("VQ_FRETONE", .F.)
	nFreteMet := GetMV("VQ_FRETMET", .F.)
	nBasCalc  := Z01->Z01_BASECA
EndIf

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
nFatorMp := SB1->B1_CONV
cUmPai   := SB1->B1_UM

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
nCapacid := SB1->B1_VQ_ECAP // ok

If SB1->B1_COD != "03000"
	aAreaNow := SG1->(GetArea())
	SG1->(DbSeek(xFilial("SG1")+Z02->(Z02_COD+Z02_CODMP)))
	If SB1->B1_VQ_UMEM == cUmPai
		nCapacid := SG1->G1_QUANT
	ElseIf cUmPai == "KG"
		nCapacid := SG1->G1_QUANT/nFatorMp
	Else
		nCapacid := SG1->G1_QUANT*nFatorMp
	EndIf
	SG1->(RestArea(aAreaNow))
EndIf

nPesoEm  := SB1->B1_PESO //DANILO BUSSO 20/10/2015       

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))

nFatorMp  := Z02->Z02_DENSID
nTxMoed2  := Z02->Z02_TXMOED
nReComMp  := Z02->Z02_REFCOM
nFreteMp  := Z02->Z02_FRETEC
nMargemA  := Z02->Z02_MARGEA
nMargemB  := Z02->Z02_MARGEB
nMargemC  := Z02->Z02_MARGEC
nMargemD  := Z02->Z02_MARGED
nMargemE  := Z02->Z02_MARGEE
nCusOpera := Z02->Z02_CUSOPE
nIcmsMp   := Z02->Z02_PICMMP
nIpiMp    := Z02->Z02_PIPIMP
nIcmsEm   := Z02->Z02_PICMEM
nIpiEm    := Z02->Z02_PIPIEM
nReComEm  := Z02->Z02_CUSTO
nPercExt  := Z02->Z02_PEXTRA

nIcmInd    := 1-(Z02->Z02_PICMMP/100)
nIcmIndPrd := 1-(nIcmsMp/100)
nIcmDif    := ((nReComMp*(nIcmInd))/nIcmIndPrd)-nReComMp
nBasCalcKg := nBasCalc*nFatorMp

nZ03Capaci := nCapacid
nZ03CustoE := Z03->Z03_CUSTOE //( nReComEm + ((nReComEm*nIpiEm)/100) ) * (nBasCalc/nCapacid)
nZ03FreEnt := nParamFre       //Round(((nFreteTon*(((nBasCalc/nCapacid)*nPesoEm)+nBasCalcKg))/nBasCalc),2) // Alterar esse campo
nZ03Custo1 := Round(nReComMp+nFreteMp+nZ03CustoE+((nReComMp*nPercExt)/100),2)

cZ03Tabela  := cParamTab
If Empty(cZ03Tabela)
	MsgStop("Não existe tabela para esse item !","Sem informação obrigatória!")
	Return aRetValor

EndIf

nZ03Margem  := &("nMargemA")
nValExtr   := (Round((nReComMp*nPercExt)/100,2))
nCalc01    := (nReComMp*(1-nIcmsMp/100))+nFreteMp+nValExtr+nZ03FreEnt
nCalc02    := (nReComMp+nFreteMp+nZ03CustoE+nZ03FreEnt)*((nPercPis+nPercCof)/100)
nCalc03    := nZ03CustoE*((100-nIcmsEm)/100)
nCalc04    := 100-nIcmsMp-nPercPis-nPercCof-nPercIR-(nCusOpera+nZ03Margem)
nCalc05    := ((nCAlc01-nCalc02+nCalc03)/nCalc04)*100
nZ03Markup := nZ03Custo1/nCalc05
nZ03Markup := Round(nZ03Markup,4)

nZ03ValVen := nZ03Custo1/nZ03Markup
nZ03ValCal := nZ03ValVen/nBasCalc
nZ03ValIcm := (nZ03ValVen-(nReComMp+nIcmDif+nZ03CustoE))*(nIcmsMp/100)
nZ03PisCof := (nZ03ValVen-(nReComMp+nIcmDif+nFreteMp+nZ03CustoE+nZ03FreEnt))*((nPercPis+nPercCof)/100)
nZ03CusOpe := nZ03ValVen*(nCusOpera/100)
nZ03Custo2 := nZ03FreEnt+nZ03Custo1+nZ03ValIcm+nZ03PisCof+nZ03CusOpe
nZ03LucBru := nZ03ValVen-nZ03Custo2
nZ03ValIr  := nZ03ValVen*(nPercIR/100)
nZ03LucLiq := nZ03LucBru-nZ03ValIr

If SB1->B1_UM == Z02->Z02_UM
	nValUnt1 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt2 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt2 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
Else
	nValUnt2 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt1 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt1 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
EndIf

If AllTrim(cParamUni) != AllTrim(Z02->Z02_UM)
	If Z02->Z02_UM == "KG"
		nZ03ValCal := nZ03ValCal * Z02->Z02_DENSID
	Else
		nZ03ValCal := nZ03ValCal / Z02->Z02_DENSID
	EndIf
EndIf

If cParamMoe != Z02->Z02_MOEDA
	If Z02->Z02_MOEDA == "1"
		nZ03ValCal := nZ03ValCal / nFatorMoed
	Else
		nZ03ValCal := nZ03ValCal * nFatorMoed
	EndIf
EndIf

nZ03ValCal := nZ03ValCal
nVlrUnit   := nVlrUnit
nZ03Markup := Round(nZ03Markup,4)

If cParamMoe == "2"
	_nVlrUnit := Round(nVlrUnit * nFatorMoed,6)
Else
	_nVlrUnit := nVlrUnit
EndIf

nFatPrd  := 1-((nIcmsMp/100)   +(nPisCCalPr/100))
nFatCli  := 1-((nIcmsCliVq/100)+(nPisCCliVq/100))

nZ03ValCal := Round(((nZ03ValCal*nFatPrd) /nFatCli),6)
nValUnt1   := Round(((nValUnt1  *nFatPrd) /nFatCli),2)
nValUnt2   := Round(((nValUnt2  *nFatPrd) /nFatCli),2)

nZ03ValCal := nZ03ValCal * nIndSe4
nValUnt1   := nValUnt1   * nIndSe4
nValUnt2   := nValUnt2   * nIndSe4

If nIndSa1 > 0
	nZ03ValCal := nZ03ValCal+(nZ03ValCal*(nIndSa1/100))
	nValUnt1   := nValUnt1  +(nValUnt1  *(nIndSa1/100))
	nValUnt2   := nValUnt2  +(nValUnt2  *(nIndSa1/100))
EndIf

Aadd(aRetValor,nZ03ValCal)	// 01-Valor Calculado
Aadd(aRetValor,nValUnt1)	// 12-Prc Unitario - Primeira Unidade
Aadd(aRetValor,nValUnt2)	// 13-Prc Unitário - Segunda Unidade
Aadd(aRetValor,nPesoEm)		// DANILO BUSSO 20/10/2015


SB1->(RestArea(aAreaSb1))

Return(aRetValor)




User Function fCfmCB(aCfmParam)

Local aRetValor   := {}
Local aAreaSb1    := SB1->(GetArea("SB1"))
Local nFatorMoed  := CfmTaxm2()

Local cParamCod  := aCfmParam[01]
Local cParamMoe  := aCfmParam[02]
Local cParamUni  := aCfmParam[03]
Local cParamTab  := aCfmParam[04]
Local nParamFre  := aCfmParam[05]
Local nParamQtd  := aCfmParam[06]
Local nVlrUnit   := aCfmParam[07]
Local lTrocaUm   := aCfmParam[08]
Local lTrocaMo   := aCfmParam[09]
Local nIcmsCliVq := aCfmParam[10]   // Icms Padrao da Tabela
Local nIndSe4    := aCfmParam[11]

Local nIndSa1    := aCfmParam[12]

Local nTxPisVq   := aCfmParam[13]
Local nTxCofVq   := aCfmParam[14]

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // nsTxPisVq+nTxCofVq//9.25 // Pis Cofins // nTxPisVq+nTxCofVq // VERIFICAR PIS E COFINS // CELSO MARTINS

Local nCusOpera  := 0		// Custo Operacional
Local nFatorMp   := 0		// Fator
Local nIcmsMp    := 0		// ICMS Materia Prima
Local nIcmsEm    := 0		// ICMS Embalagem
Local nIcmsPa    := 0		// ICMS Produto Pai
Local nIpiMp     := 0		// IPI Materia Prima
Local nIpiEm     := 0		// IPI Embalagem
Local nIpiPa     := 0		// IPI Produto Pai
Local nCapacid   := 0		// Capacidade da embalagem
Local nReComMp   := 0		// Referencia de Compra Materia Prima
Local nReComEm   := 0		// Referencia de Compra Embalagem
Local nTxMoed2   := 0		// Taxa Moeda 2
Local nFreteTon  := 0		// Frete por Tonelada
Local nFreteMet  := 0		// Frete por Metro Cubico
Local nBasCalc   := 0		// Base para calculo de conversao
Local nPercExt   := 0		// Percentual Extra da Embalagem
Local nFreteMp   := 0		// Frete de Compras
Local nPesoEm    := 0		// Peso da Embalagem
Local nBasCalcKg := 0		//
Local cRevAtua   := ""		//
Local cRevNova   := ""		//
Local nPercPis   := 1.65	// % Pis
Local nPercCof   := 7.60	// % Cofins
Local nPercIR    := 2.00	// % IR

Local nIcmInd    := 0		// Indice de Icms Tabela
Local nIcmIndPrd := 0		// Indice de Icms Produto
Local nIcmDif    := 0		// Diferencial de Icms

Private nMargemA := 0		// Margem Tabela A
Private nMargemB := 0		// Margem Tabela B
Private nMargemC := 0		// Margem Tabela C
Private nMargemD := 0		// Margem Tabela D
Private nMargemE := 0		// Margem Tabela E

If GetMV("VQ_DTCOTAC", .F.) <= dDataBase
	nFreteTon := GetMV("VQ_FRETONE", .F.)
	nFreteMet := GetMV("VQ_FRETMET", .F.)
	nBasCalc  := Z01->Z01_BASECA
EndIf

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
nFatorMp := SB1->B1_CONV
cUmPai   := SB1->B1_UM

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
nCapacid := SB1->B1_VQ_ECAP // ok

If SB1->B1_COD != "03000"
	aAreaNow := SG1->(GetArea())
	SG1->(DbSeek(xFilial("SG1")+Z02->(Z02_COD+Z02_CODMP)))
	If SB1->B1_VQ_UMEM == cUmPai
		nCapacid := SG1->G1_QUANT
	ElseIf cUmPai == "KG"
		nCapacid := SG1->G1_QUANT/nFatorMp
	Else
		nCapacid := SG1->G1_QUANT*nFatorMp
	EndIf
	SG1->(RestArea(aAreaNow))
EndIf

nPesoEm  := SB1->B1_PESO //DANILO BUSSO 20/10/2015       

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))

nFatorMp  := Z02->Z02_DENSID
nTxMoed2  := Z02->Z02_TXMOED
nReComMp  := Z02->Z02_REFCOM
nFreteMp  := Z02->Z02_FRETEC
nMargemA  := Z02->Z02_MARGEA
nMargemB  := Z02->Z02_MARGEB
nMargemC  := Z02->Z02_MARGEC
nMargemD  := Z02->Z02_MARGED
nMargemE  := Z02->Z02_MARGEE
nCusOpera := Z02->Z02_CUSOPE
nIcmsMp   := Z02->Z02_PICMMP
nIpiMp    := Z02->Z02_PIPIMP
nIcmsEm   := Z02->Z02_PICMEM
nIpiEm    := Z02->Z02_PIPIEM
nReComEm  := Z02->Z02_CUSTO
nPercExt  := Z02->Z02_PEXTRA

nIcmInd    := 1-(Z02->Z02_PICMMP/100)
nIcmIndPrd := 1-(nIcmsMp/100)
nIcmDif    := ((nReComMp*(nIcmInd))/nIcmIndPrd)-nReComMp
nBasCalcKg := nBasCalc*nFatorMp

nZ03Capaci := nCapacid
nZ03CustoE := Z03->Z03_CUSTOE //( nReComEm + ((nReComEm*nIpiEm)/100) ) * (nBasCalc/nCapacid)
nZ03FreEnt := nParamFre       //Round(((nFreteTon*(((nBasCalc/nCapacid)*nPesoEm)+nBasCalcKg))/nBasCalc),2) // Alterar esse campo
nZ03Custo1 := Round(nReComMp+nFreteMp+nZ03CustoE+((nReComMp*nPercExt)/100),2)

cZ03Tabela  := cParamTab
If Empty(cZ03Tabela)
	MsgStop("Não existe tabela para esse item !","Sem informação obrigatória!")
	Return aRetValor

EndIf

nZ03Margem  := &("nMargemB")
nValExtr   := (Round((nReComMp*nPercExt)/100,2))
nCalc01    := (nReComMp*(1-nIcmsMp/100))+nFreteMp+nValExtr+nZ03FreEnt
nCalc02    := (nReComMp+nFreteMp+nZ03CustoE+nZ03FreEnt)*((nPercPis+nPercCof)/100)
nCalc03    := nZ03CustoE*((100-nIcmsEm)/100)
nCalc04    := 100-nIcmsMp-nPercPis-nPercCof-nPercIR-(nCusOpera+nZ03Margem)
nCalc05    := ((nCAlc01-nCalc02+nCalc03)/nCalc04)*100
nZ03Markup := nZ03Custo1/nCalc05
nZ03Markup := Round(nZ03Markup,4)

nZ03ValVen := nZ03Custo1/nZ03Markup
nZ03ValCal := nZ03ValVen/nBasCalc
nZ03ValIcm := (nZ03ValVen-(nReComMp+nIcmDif+nZ03CustoE))*(nIcmsMp/100)
nZ03PisCof := (nZ03ValVen-(nReComMp+nIcmDif+nFreteMp+nZ03CustoE+nZ03FreEnt))*((nPercPis+nPercCof)/100)
nZ03CusOpe := nZ03ValVen*(nCusOpera/100)
nZ03Custo2 := nZ03FreEnt+nZ03Custo1+nZ03ValIcm+nZ03PisCof+nZ03CusOpe
nZ03LucBru := nZ03ValVen-nZ03Custo2
nZ03ValIr  := nZ03ValVen*(nPercIR/100)
nZ03LucLiq := nZ03LucBru-nZ03ValIr

If SB1->B1_UM == Z02->Z02_UM
	nValUnt1 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt2 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt2 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
Else
	nValUnt2 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt1 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt1 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
EndIf

If AllTrim(cParamUni) != AllTrim(Z02->Z02_UM)
	If Z02->Z02_UM == "KG"
		nZ03ValCal := nZ03ValCal * Z02->Z02_DENSID
	Else
		nZ03ValCal := nZ03ValCal / Z02->Z02_DENSID
	EndIf
EndIf

If cParamMoe != Z02->Z02_MOEDA
	If Z02->Z02_MOEDA == "1"
		nZ03ValCal := nZ03ValCal / nFatorMoed
	Else
		nZ03ValCal := nZ03ValCal * nFatorMoed
	EndIf
EndIf

nZ03ValCal := nZ03ValCal
nVlrUnit   := nVlrUnit
nZ03Markup := Round(nZ03Markup,4)

If cParamMoe == "2"
	_nVlrUnit := Round(nVlrUnit * nFatorMoed,6)
Else
	_nVlrUnit := nVlrUnit
EndIf

nFatPrd  := 1-((nIcmsMp/100)   +(nPisCCalPr/100))
nFatCli  := 1-((nIcmsCliVq/100)+(nPisCCliVq/100))

nZ03ValCal := Round(((nZ03ValCal*nFatPrd) /nFatCli),6)
nValUnt1   := Round(((nValUnt1  *nFatPrd) /nFatCli),2)
nValUnt2   := Round(((nValUnt2  *nFatPrd) /nFatCli),2)

nZ03ValCal := nZ03ValCal * nIndSe4
nValUnt1   := nValUnt1   * nIndSe4
nValUnt2   := nValUnt2   * nIndSe4

If nIndSa1 > 0
	nZ03ValCal := nZ03ValCal+(nZ03ValCal*(nIndSa1/100))
	nValUnt1   := nValUnt1  +(nValUnt1  *(nIndSa1/100))
	nValUnt2   := nValUnt2  +(nValUnt2  *(nIndSa1/100))
EndIf

Aadd(aRetValor,nZ03ValCal)	// 01-Valor Calculado
Aadd(aRetValor,nValUnt1)	// 12-Prc Unitario - Primeira Unidade
Aadd(aRetValor,nValUnt2)	// 13-Prc Unitário - Segunda Unidade
Aadd(aRetValor,nPesoEm)		// DANILO BUSSO 20/10/2015


SB1->(RestArea(aAreaSb1))

Return(aRetValor)




User Function fCfmCC(aCfmParam)

Local aRetValor   := {}
Local aAreaSb1    := SB1->(GetArea("SB1"))
Local nFatorMoed  := CfmTaxm2()

Local cParamCod  := aCfmParam[01]
Local cParamMoe  := aCfmParam[02]
Local cParamUni  := aCfmParam[03]
Local cParamTab  := aCfmParam[04]
Local nParamFre  := aCfmParam[05]
Local nParamQtd  := aCfmParam[06]
Local nVlrUnit   := aCfmParam[07]
Local lTrocaUm   := aCfmParam[08]
Local lTrocaMo   := aCfmParam[09]
Local nIcmsCliVq := aCfmParam[10]   // Icms Padrao da Tabela
Local nIndSe4    := aCfmParam[11]

Local nIndSa1    := aCfmParam[12]

Local nTxPisVq   := aCfmParam[13]
Local nTxCofVq   := aCfmParam[14]

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // nsTxPisVq+nTxCofVq//9.25 // Pis Cofins // nTxPisVq+nTxCofVq // VERIFICAR PIS E COFINS // CELSO MARTINS

Local nCusOpera  := 0		// Custo Operacional
Local nFatorMp   := 0		// Fator
Local nIcmsMp    := 0		// ICMS Materia Prima
Local nIcmsEm    := 0		// ICMS Embalagem
Local nIcmsPa    := 0		// ICMS Produto Pai
Local nIpiMp     := 0		// IPI Materia Prima
Local nIpiEm     := 0		// IPI Embalagem
Local nIpiPa     := 0		// IPI Produto Pai
Local nCapacid   := 0		// Capacidade da embalagem
Local nReComMp   := 0		// Referencia de Compra Materia Prima
Local nReComEm   := 0		// Referencia de Compra Embalagem
Local nTxMoed2   := 0		// Taxa Moeda 2
Local nFreteTon  := 0		// Frete por Tonelada
Local nFreteMet  := 0		// Frete por Metro Cubico
Local nBasCalc   := 0		// Base para calculo de conversao
Local nPercExt   := 0		// Percentual Extra da Embalagem
Local nFreteMp   := 0		// Frete de Compras
Local nPesoEm    := 0		// Peso da Embalagem
Local nBasCalcKg := 0		//
Local cRevAtua   := ""		//
Local cRevNova   := ""		//
Local nPercPis   := 1.65	// % Pis
Local nPercCof   := 7.60	// % Cofins
Local nPercIR    := 2.00	// % IR

Local nIcmInd    := 0		// Indice de Icms Tabela
Local nIcmIndPrd := 0		// Indice de Icms Produto
Local nIcmDif    := 0		// Diferencial de Icms

Private nMargemA := 0		// Margem Tabela A
Private nMargemB := 0		// Margem Tabela B
Private nMargemC := 0		// Margem Tabela C
Private nMargemD := 0		// Margem Tabela D
Private nMargemE := 0		// Margem Tabela E

If GetMV("VQ_DTCOTAC", .F.) <= dDataBase
	nFreteTon := GetMV("VQ_FRETONE", .F.)
	nFreteMet := GetMV("VQ_FRETMET", .F.)
	nBasCalc  := Z01->Z01_BASECA
EndIf

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
nFatorMp := SB1->B1_CONV
cUmPai   := SB1->B1_UM

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
nCapacid := SB1->B1_VQ_ECAP // ok

If SB1->B1_COD != "03000"
	aAreaNow := SG1->(GetArea())
	SG1->(DbSeek(xFilial("SG1")+Z02->(Z02_COD+Z02_CODMP)))
	If SB1->B1_VQ_UMEM == cUmPai
		nCapacid := SG1->G1_QUANT
	ElseIf cUmPai == "KG"
		nCapacid := SG1->G1_QUANT/nFatorMp
	Else
		nCapacid := SG1->G1_QUANT*nFatorMp
	EndIf
	SG1->(RestArea(aAreaNow))
EndIf

nPesoEm  := SB1->B1_PESO //DANILO BUSSO 20/10/2015       

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))

nFatorMp  := Z02->Z02_DENSID
nTxMoed2  := Z02->Z02_TXMOED
nReComMp  := Z02->Z02_REFCOM
nFreteMp  := Z02->Z02_FRETEC
nMargemA  := Z02->Z02_MARGEA
nMargemB  := Z02->Z02_MARGEB
nMargemC  := Z02->Z02_MARGEC
nMargemD  := Z02->Z02_MARGED
nMargemE  := Z02->Z02_MARGEE
nCusOpera := Z02->Z02_CUSOPE
nIcmsMp   := Z02->Z02_PICMMP
nIpiMp    := Z02->Z02_PIPIMP
nIcmsEm   := Z02->Z02_PICMEM
nIpiEm    := Z02->Z02_PIPIEM
nReComEm  := Z02->Z02_CUSTO
nPercExt  := Z02->Z02_PEXTRA

nIcmInd    := 1-(Z02->Z02_PICMMP/100)
nIcmIndPrd := 1-(nIcmsMp/100)
nIcmDif    := ((nReComMp*(nIcmInd))/nIcmIndPrd)-nReComMp
nBasCalcKg := nBasCalc*nFatorMp

nZ03Capaci := nCapacid
nZ03CustoE := Z03->Z03_CUSTOE //( nReComEm + ((nReComEm*nIpiEm)/100) ) * (nBasCalc/nCapacid)
nZ03FreEnt := nParamFre       //Round(((nFreteTon*(((nBasCalc/nCapacid)*nPesoEm)+nBasCalcKg))/nBasCalc),2) // Alterar esse campo
nZ03Custo1 := Round(nReComMp+nFreteMp+nZ03CustoE+((nReComMp*nPercExt)/100),2)

cZ03Tabela  := cParamTab
If Empty(cZ03Tabela)
	MsgStop("Não existe tabela para esse item !","Sem informação obrigatória!")
	Return aRetValor

EndIf

nZ03Margem  := &("nMargemC")
nValExtr   := (Round((nReComMp*nPercExt)/100,2))
nCalc01    := (nReComMp*(1-nIcmsMp/100))+nFreteMp+nValExtr+nZ03FreEnt
nCalc02    := (nReComMp+nFreteMp+nZ03CustoE+nZ03FreEnt)*((nPercPis+nPercCof)/100)
nCalc03    := nZ03CustoE*((100-nIcmsEm)/100)
nCalc04    := 100-nIcmsMp-nPercPis-nPercCof-nPercIR-(nCusOpera+nZ03Margem)
nCalc05    := ((nCAlc01-nCalc02+nCalc03)/nCalc04)*100
nZ03Markup := nZ03Custo1/nCalc05
nZ03Markup := Round(nZ03Markup,4)

nZ03ValVen := nZ03Custo1/nZ03Markup
nZ03ValCal := nZ03ValVen/nBasCalc
nZ03ValIcm := (nZ03ValVen-(nReComMp+nIcmDif+nZ03CustoE))*(nIcmsMp/100)
nZ03PisCof := (nZ03ValVen-(nReComMp+nIcmDif+nFreteMp+nZ03CustoE+nZ03FreEnt))*((nPercPis+nPercCof)/100)
nZ03CusOpe := nZ03ValVen*(nCusOpera/100)
nZ03Custo2 := nZ03FreEnt+nZ03Custo1+nZ03ValIcm+nZ03PisCof+nZ03CusOpe
nZ03LucBru := nZ03ValVen-nZ03Custo2
nZ03ValIr  := nZ03ValVen*(nPercIR/100)
nZ03LucLiq := nZ03LucBru-nZ03ValIr

If SB1->B1_UM == Z02->Z02_UM
	nValUnt1 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt2 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt2 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
Else
	nValUnt2 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt1 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt1 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
EndIf

If AllTrim(cParamUni) != AllTrim(Z02->Z02_UM)
	If Z02->Z02_UM == "KG"
		nZ03ValCal := nZ03ValCal * Z02->Z02_DENSID
	Else
		nZ03ValCal := nZ03ValCal / Z02->Z02_DENSID
	EndIf
EndIf

If cParamMoe != Z02->Z02_MOEDA
	If Z02->Z02_MOEDA == "1"
		nZ03ValCal := nZ03ValCal / nFatorMoed
	Else
		nZ03ValCal := nZ03ValCal * nFatorMoed
	EndIf
EndIf

nZ03ValCal := nZ03ValCal
nVlrUnit   := nVlrUnit
nZ03Markup := Round(nZ03Markup,4)

If cParamMoe == "2"
	_nVlrUnit := Round(nVlrUnit * nFatorMoed,6)
Else
	_nVlrUnit := nVlrUnit
EndIf

nFatPrd  := 1-((nIcmsMp/100)   +(nPisCCalPr/100))
nFatCli  := 1-((nIcmsCliVq/100)+(nPisCCliVq/100))

nZ03ValCal := Round(((nZ03ValCal*nFatPrd) /nFatCli),6)
nValUnt1   := Round(((nValUnt1  *nFatPrd) /nFatCli),2)
nValUnt2   := Round(((nValUnt2  *nFatPrd) /nFatCli),2)

nZ03ValCal := nZ03ValCal * nIndSe4
nValUnt1   := nValUnt1   * nIndSe4
nValUnt2   := nValUnt2   * nIndSe4

If nIndSa1 > 0
	nZ03ValCal := nZ03ValCal+(nZ03ValCal*(nIndSa1/100))
	nValUnt1   := nValUnt1  +(nValUnt1  *(nIndSa1/100))
	nValUnt2   := nValUnt2  +(nValUnt2  *(nIndSa1/100))
EndIf

Aadd(aRetValor,nZ03ValCal)	// 01-Valor Calculado
Aadd(aRetValor,nValUnt1)	// 12-Prc Unitario - Primeira Unidade
Aadd(aRetValor,nValUnt2)	// 13-Prc Unitário - Segunda Unidade
Aadd(aRetValor,nPesoEm)		// DANILO BUSSO 20/10/2015


SB1->(RestArea(aAreaSb1))

Return(aRetValor)




User Function fCfmCD(aCfmParam)

Local aRetValor   := {}
Local aAreaSb1    := SB1->(GetArea("SB1"))
Local nFatorMoed  := CfmTaxm2()

Local cParamCod  := aCfmParam[01]
Local cParamMoe  := aCfmParam[02]
Local cParamUni  := aCfmParam[03]
Local cParamTab  := aCfmParam[04]
Local nParamFre  := aCfmParam[05]
Local nParamQtd  := aCfmParam[06]
Local nVlrUnit   := aCfmParam[07]
Local lTrocaUm   := aCfmParam[08]
Local lTrocaMo   := aCfmParam[09]
Local nIcmsCliVq := aCfmParam[10]   // Icms Padrao da Tabela
Local nIndSe4    := aCfmParam[11]

Local nIndSa1    := aCfmParam[12]

Local nTxPisVq   := aCfmParam[13]
Local nTxCofVq   := aCfmParam[14]

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // nsTxPisVq+nTxCofVq//9.25 // Pis Cofins // nTxPisVq+nTxCofVq // VERIFICAR PIS E COFINS // CELSO MARTINS

Local nCusOpera  := 0		// Custo Operacional
Local nFatorMp   := 0		// Fator
Local nIcmsMp    := 0		// ICMS Materia Prima
Local nIcmsEm    := 0		// ICMS Embalagem
Local nIcmsPa    := 0		// ICMS Produto Pai
Local nIpiMp     := 0		// IPI Materia Prima
Local nIpiEm     := 0		// IPI Embalagem
Local nIpiPa     := 0		// IPI Produto Pai
Local nCapacid   := 0		// Capacidade da embalagem
Local nReComMp   := 0		// Referencia de Compra Materia Prima
Local nReComEm   := 0		// Referencia de Compra Embalagem
Local nTxMoed2   := 0		// Taxa Moeda 2
Local nFreteTon  := 0		// Frete por Tonelada
Local nFreteMet  := 0		// Frete por Metro Cubico
Local nBasCalc   := 0		// Base para calculo de conversao
Local nPercExt   := 0		// Percentual Extra da Embalagem
Local nFreteMp   := 0		// Frete de Compras
Local nPesoEm    := 0		// Peso da Embalagem
Local nBasCalcKg := 0		//
Local cRevAtua   := ""		//
Local cRevNova   := ""		//
Local nPercPis   := 1.65	// % Pis
Local nPercCof   := 7.60	// % Cofins
Local nPercIR    := 2.00	// % IR

Local nIcmInd    := 0		// Indice de Icms Tabela
Local nIcmIndPrd := 0		// Indice de Icms Produto
Local nIcmDif    := 0		// Diferencial de Icms

Private nMargemA := 0		// Margem Tabela A
Private nMargemB := 0		// Margem Tabela B
Private nMargemC := 0		// Margem Tabela C
Private nMargemD := 0		// Margem Tabela D
Private nMargemE := 0		// Margem Tabela E

If GetMV("VQ_DTCOTAC", .F.) <= dDataBase
	nFreteTon := GetMV("VQ_FRETONE", .F.)
	nFreteMet := GetMV("VQ_FRETMET", .F.)
	nBasCalc  := Z01->Z01_BASECA
EndIf

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
nFatorMp := SB1->B1_CONV
cUmPai   := SB1->B1_UM

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
nCapacid := SB1->B1_VQ_ECAP // ok

If SB1->B1_COD != "03000"
	aAreaNow := SG1->(GetArea())
	SG1->(DbSeek(xFilial("SG1")+Z02->(Z02_COD+Z02_CODMP)))
	If SB1->B1_VQ_UMEM == cUmPai
		nCapacid := SG1->G1_QUANT
	ElseIf cUmPai == "KG"
		nCapacid := SG1->G1_QUANT/nFatorMp
	Else
		nCapacid := SG1->G1_QUANT*nFatorMp
	EndIf
	SG1->(RestArea(aAreaNow))
EndIf

nPesoEm  := SB1->B1_PESO //DANILO BUSSO 20/10/2015       

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))

nFatorMp  := Z02->Z02_DENSID
nTxMoed2  := Z02->Z02_TXMOED
nReComMp  := Z02->Z02_REFCOM
nFreteMp  := Z02->Z02_FRETEC
nMargemA  := Z02->Z02_MARGEA
nMargemB  := Z02->Z02_MARGEB
nMargemC  := Z02->Z02_MARGEC
nMargemD  := Z02->Z02_MARGED
nMargemE  := Z02->Z02_MARGEE
nCusOpera := Z02->Z02_CUSOPE
nIcmsMp   := Z02->Z02_PICMMP
nIpiMp    := Z02->Z02_PIPIMP
nIcmsEm   := Z02->Z02_PICMEM
nIpiEm    := Z02->Z02_PIPIEM
nReComEm  := Z02->Z02_CUSTO
nPercExt  := Z02->Z02_PEXTRA

nIcmInd    := 1-(Z02->Z02_PICMMP/100)
nIcmIndPrd := 1-(nIcmsMp/100)
nIcmDif    := ((nReComMp*(nIcmInd))/nIcmIndPrd)-nReComMp
nBasCalcKg := nBasCalc*nFatorMp

nZ03Capaci := nCapacid
nZ03CustoE := Z03->Z03_CUSTOE //( nReComEm + ((nReComEm*nIpiEm)/100) ) * (nBasCalc/nCapacid)
nZ03FreEnt := nParamFre       //Round(((nFreteTon*(((nBasCalc/nCapacid)*nPesoEm)+nBasCalcKg))/nBasCalc),2) // Alterar esse campo
nZ03Custo1 := Round(nReComMp+nFreteMp+nZ03CustoE+((nReComMp*nPercExt)/100),2)

cZ03Tabela  := cParamTab
If Empty(cZ03Tabela)
	MsgStop("Não existe tabela para esse item !","Sem informação obrigatória!")
	Return aRetValor

EndIf

nZ03Margem  := &("nMargemD")
nValExtr   := (Round((nReComMp*nPercExt)/100,2))
nCalc01    := (nReComMp*(1-nIcmsMp/100))+nFreteMp+nValExtr+nZ03FreEnt
nCalc02    := (nReComMp+nFreteMp+nZ03CustoE+nZ03FreEnt)*((nPercPis+nPercCof)/100)
nCalc03    := nZ03CustoE*((100-nIcmsEm)/100)
nCalc04    := 100-nIcmsMp-nPercPis-nPercCof-nPercIR-(nCusOpera+nZ03Margem)
nCalc05    := ((nCAlc01-nCalc02+nCalc03)/nCalc04)*100
nZ03Markup := nZ03Custo1/nCalc05
nZ03Markup := Round(nZ03Markup,4)

nZ03ValVen := nZ03Custo1/nZ03Markup
nZ03ValCal := nZ03ValVen/nBasCalc
nZ03ValIcm := (nZ03ValVen-(nReComMp+nIcmDif+nZ03CustoE))*(nIcmsMp/100)
nZ03PisCof := (nZ03ValVen-(nReComMp+nIcmDif+nFreteMp+nZ03CustoE+nZ03FreEnt))*((nPercPis+nPercCof)/100)
nZ03CusOpe := nZ03ValVen*(nCusOpera/100)
nZ03Custo2 := nZ03FreEnt+nZ03Custo1+nZ03ValIcm+nZ03PisCof+nZ03CusOpe
nZ03LucBru := nZ03ValVen-nZ03Custo2
nZ03ValIr  := nZ03ValVen*(nPercIR/100)
nZ03LucLiq := nZ03LucBru-nZ03ValIr

If SB1->B1_UM == Z02->Z02_UM
	nValUnt1 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt2 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt2 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
Else
	nValUnt2 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt1 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt1 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
EndIf

If AllTrim(cParamUni) != AllTrim(Z02->Z02_UM)
	If Z02->Z02_UM == "KG"
		nZ03ValCal := nZ03ValCal * Z02->Z02_DENSID
	Else
		nZ03ValCal := nZ03ValCal / Z02->Z02_DENSID
	EndIf
EndIf

If cParamMoe != Z02->Z02_MOEDA
	If Z02->Z02_MOEDA == "1"
		nZ03ValCal := nZ03ValCal / nFatorMoed
	Else
		nZ03ValCal := nZ03ValCal * nFatorMoed
	EndIf
EndIf

nZ03ValCal := nZ03ValCal
nVlrUnit   := nVlrUnit
nZ03Markup := Round(nZ03Markup,4)

If cParamMoe == "2"
	_nVlrUnit := Round(nVlrUnit * nFatorMoed,6)
Else
	_nVlrUnit := nVlrUnit
EndIf

nFatPrd  := 1-((nIcmsMp/100)   +(nPisCCalPr/100))
nFatCli  := 1-((nIcmsCliVq/100)+(nPisCCliVq/100))

nZ03ValCal := Round(((nZ03ValCal*nFatPrd) /nFatCli),6)
nValUnt1   := Round(((nValUnt1  *nFatPrd) /nFatCli),2)
nValUnt2   := Round(((nValUnt2  *nFatPrd) /nFatCli),2)

nZ03ValCal := nZ03ValCal * nIndSe4
nValUnt1   := nValUnt1   * nIndSe4
nValUnt2   := nValUnt2   * nIndSe4

If nIndSa1 > 0
	nZ03ValCal := nZ03ValCal+(nZ03ValCal*(nIndSa1/100))
	nValUnt1   := nValUnt1  +(nValUnt1  *(nIndSa1/100))
	nValUnt2   := nValUnt2  +(nValUnt2  *(nIndSa1/100))
EndIf

Aadd(aRetValor,nZ03ValCal)	// 01-Valor Calculado
Aadd(aRetValor,nValUnt1)	// 12-Prc Unitario - Primeira Unidade
Aadd(aRetValor,nValUnt2)	// 13-Prc Unitário - Segunda Unidade
Aadd(aRetValor,nPesoEm)		// DANILO BUSSO 20/10/2015


SB1->(RestArea(aAreaSb1))

Return(aRetValor)




User Function fCfmCE(aCfmParam)

Local aRetValor   := {}
Local aAreaSb1    := SB1->(GetArea("SB1"))
Local nFatorMoed  := CfmTaxm2()

Local cParamCod  := aCfmParam[01]
Local cParamMoe  := aCfmParam[02]
Local cParamUni  := aCfmParam[03]
Local cParamTab  := aCfmParam[04]
Local nParamFre  := aCfmParam[05]
Local nParamQtd  := aCfmParam[06]
Local nVlrUnit   := aCfmParam[07]
Local lTrocaUm   := aCfmParam[08]
Local lTrocaMo   := aCfmParam[09]
Local nIcmsCliVq := aCfmParam[10]   // Icms Padrao da Tabela
Local nIndSe4    := aCfmParam[11]

Local nIndSa1    := aCfmParam[12]

Local nTxPisVq   := aCfmParam[13]
Local nTxCofVq   := aCfmParam[14]

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // nsTxPisVq+nTxCofVq//9.25 // Pis Cofins // nTxPisVq+nTxCofVq // VERIFICAR PIS E COFINS // CELSO MARTINS

Local nCusOpera  := 0		// Custo Operacional
Local nFatorMp   := 0		// Fator
Local nIcmsMp    := 0		// ICMS Materia Prima
Local nIcmsEm    := 0		// ICMS Embalagem
Local nIcmsPa    := 0		// ICMS Produto Pai
Local nIpiMp     := 0		// IPI Materia Prima
Local nIpiEm     := 0		// IPI Embalagem
Local nIpiPa     := 0		// IPI Produto Pai
Local nCapacid   := 0		// Capacidade da embalagem
Local nReComMp   := 0		// Referencia de Compra Materia Prima
Local nReComEm   := 0		// Referencia de Compra Embalagem
Local nTxMoed2   := 0		// Taxa Moeda 2
Local nFreteTon  := 0		// Frete por Tonelada
Local nFreteMet  := 0		// Frete por Metro Cubico
Local nBasCalc   := 0		// Base para calculo de conversao
Local nPercExt   := 0		// Percentual Extra da Embalagem
Local nFreteMp   := 0		// Frete de Compras
Local nPesoEm    := 0		// Peso da Embalagem
Local nBasCalcKg := 0		//
Local cRevAtua   := ""		//
Local cRevNova   := ""		//
Local nPercPis   := 1.65	// % Pis
Local nPercCof   := 7.60	// % Cofins
Local nPercIR    := 2.00	// % IR

Local nIcmInd    := 0		// Indice de Icms Tabela
Local nIcmIndPrd := 0		// Indice de Icms Produto
Local nIcmDif    := 0		// Diferencial de Icms

Private nMargemA := 0		// Margem Tabela A
Private nMargemB := 0		// Margem Tabela B
Private nMargemC := 0		// Margem Tabela C
Private nMargemD := 0		// Margem Tabela D
Private nMargemE := 0		// Margem Tabela E

If GetMV("VQ_DTCOTAC", .F.) <= dDataBase
	nFreteTon := GetMV("VQ_FRETONE", .F.)
	nFreteMet := GetMV("VQ_FRETMET", .F.)
	nBasCalc  := Z01->Z01_BASECA
EndIf

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
nFatorMp := SB1->B1_CONV
cUmPai   := SB1->B1_UM

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
nCapacid := SB1->B1_VQ_ECAP // ok

If SB1->B1_COD != "03000"
	aAreaNow := SG1->(GetArea())
	SG1->(DbSeek(xFilial("SG1")+Z02->(Z02_COD+Z02_CODMP)))
	If SB1->B1_VQ_UMEM == cUmPai
		nCapacid := SG1->G1_QUANT
	ElseIf cUmPai == "KG"
		nCapacid := SG1->G1_QUANT/nFatorMp
	Else
		nCapacid := SG1->G1_QUANT*nFatorMp
	EndIf
	SG1->(RestArea(aAreaNow))
EndIf

nPesoEm  := SB1->B1_PESO //DANILO BUSSO 20/10/2015       

SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))

nFatorMp  := Z02->Z02_DENSID
nTxMoed2  := Z02->Z02_TXMOED
nReComMp  := Z02->Z02_REFCOM
nFreteMp  := Z02->Z02_FRETEC
nMargemA  := Z02->Z02_MARGEA
nMargemB  := Z02->Z02_MARGEB
nMargemC  := Z02->Z02_MARGEC
nMargemD  := Z02->Z02_MARGED
nMargemE  := Z02->Z02_MARGEE
nCusOpera := Z02->Z02_CUSOPE
nIcmsMp   := Z02->Z02_PICMMP
nIpiMp    := Z02->Z02_PIPIMP
nIcmsEm   := Z02->Z02_PICMEM
nIpiEm    := Z02->Z02_PIPIEM
nReComEm  := Z02->Z02_CUSTO
nPercExt  := Z02->Z02_PEXTRA

nIcmInd    := 1-(Z02->Z02_PICMMP/100)
nIcmIndPrd := 1-(nIcmsMp/100)
nIcmDif    := ((nReComMp*(nIcmInd))/nIcmIndPrd)-nReComMp
nBasCalcKg := nBasCalc*nFatorMp

nZ03Capaci := nCapacid
nZ03CustoE := Z03->Z03_CUSTOE //( nReComEm + ((nReComEm*nIpiEm)/100) ) * (nBasCalc/nCapacid)
nZ03FreEnt := nParamFre       //Round(((nFreteTon*(((nBasCalc/nCapacid)*nPesoEm)+nBasCalcKg))/nBasCalc),2) // Alterar esse campo
nZ03Custo1 := Round(nReComMp+nFreteMp+nZ03CustoE+((nReComMp*nPercExt)/100),2)

cZ03Tabela  := cParamTab
If Empty(cZ03Tabela)
	MsgStop("Não existe tabela para esse item !","Sem informação obrigatória!")
	Return aRetValor

EndIf

nZ03Margem  := &("nMargemE")
nValExtr   := (Round((nReComMp*nPercExt)/100,2))
nCalc01    := (nReComMp*(1-nIcmsMp/100))+nFreteMp+nValExtr+nZ03FreEnt
nCalc02    := (nReComMp+nFreteMp+nZ03CustoE+nZ03FreEnt)*((nPercPis+nPercCof)/100)
nCalc03    := nZ03CustoE*((100-nIcmsEm)/100)
nCalc04    := 100-nIcmsMp-nPercPis-nPercCof-nPercIR-(nCusOpera+nZ03Margem)
nCalc05    := ((nCAlc01-nCalc02+nCalc03)/nCalc04)*100
nZ03Markup := nZ03Custo1/nCalc05
nZ03Markup := Round(nZ03Markup,4)

nZ03ValVen := nZ03Custo1/nZ03Markup
nZ03ValCal := nZ03ValVen/nBasCalc
nZ03ValIcm := (nZ03ValVen-(nReComMp+nIcmDif+nZ03CustoE))*(nIcmsMp/100)
nZ03PisCof := (nZ03ValVen-(nReComMp+nIcmDif+nFreteMp+nZ03CustoE+nZ03FreEnt))*((nPercPis+nPercCof)/100)
nZ03CusOpe := nZ03ValVen*(nCusOpera/100)
nZ03Custo2 := nZ03FreEnt+nZ03Custo1+nZ03ValIcm+nZ03PisCof+nZ03CusOpe
nZ03LucBru := nZ03ValVen-nZ03Custo2
nZ03ValIr  := nZ03ValVen*(nPercIR/100)
nZ03LucLiq := nZ03LucBru-nZ03ValIr

If SB1->B1_UM == Z02->Z02_UM
	nValUnt1 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt2 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt2 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
Else
	nValUnt2 := Round(nZ03ValCal,2)
	If SB1->B1_UM == "KG"
		nValUnt1 := Round(nZ03ValCal,2) * Z02->Z02_DENSID
	Else
		nValUnt1 := Round(nZ03ValCal,2) / Z02->Z02_DENSID
	EndIf
EndIf

If AllTrim(cParamUni) != AllTrim(Z02->Z02_UM)
	If Z02->Z02_UM == "KG"
		nZ03ValCal := nZ03ValCal * Z02->Z02_DENSID
	Else
		nZ03ValCal := nZ03ValCal / Z02->Z02_DENSID
	EndIf
EndIf

If cParamMoe != Z02->Z02_MOEDA
	If Z02->Z02_MOEDA == "1"
		nZ03ValCal := nZ03ValCal / nFatorMoed
	Else
		nZ03ValCal := nZ03ValCal * nFatorMoed
	EndIf
EndIf

nZ03ValCal := nZ03ValCal
nVlrUnit   := nVlrUnit
nZ03Markup := Round(nZ03Markup,4)

If cParamMoe == "2"
	_nVlrUnit := Round(nVlrUnit * nFatorMoed,6)
Else
	_nVlrUnit := nVlrUnit
EndIf

nFatPrd  := 1-((nIcmsMp/100)   +(nPisCCalPr/100))
nFatCli  := 1-((nIcmsCliVq/100)+(nPisCCliVq/100))

nZ03ValCal := Round(((nZ03ValCal*nFatPrd) /nFatCli),6)
nValUnt1   := Round(((nValUnt1  *nFatPrd) /nFatCli),2)
nValUnt2   := Round(((nValUnt2  *nFatPrd) /nFatCli),2)

nZ03ValCal := nZ03ValCal * nIndSe4
nValUnt1   := nValUnt1   * nIndSe4
nValUnt2   := nValUnt2   * nIndSe4

If nIndSa1 > 0
	nZ03ValCal := nZ03ValCal+(nZ03ValCal*(nIndSa1/100))
	nValUnt1   := nValUnt1  +(nValUnt1  *(nIndSa1/100))
	nValUnt2   := nValUnt2  +(nValUnt2  *(nIndSa1/100))
EndIf

Aadd(aRetValor,nZ03ValCal)	// 01-Valor Calculado
Aadd(aRetValor,nValUnt1)	// 12-Prc Unitario - Primeira Unidade
Aadd(aRetValor,nValUnt2)	// 13-Prc Unitário - Segunda Unidade
Aadd(aRetValor,nPesoEm)		// DANILO BUSSO 20/10/2015


SB1->(RestArea(aAreaSb1))

Return(aRetValor)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: AjustaSx6 | Autor: Celso Ferrone Martins  | Data: 30/07/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Ajuste de Parametros SX6                                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function AjustaSx6()

	Local cX6Desc1  := ""
	Local cX6Desc2  := ""
	Local cX6Desc3  := ""
	Local nTamSx3   := 0
	Local cConteud  := ""

	cX6Var    := "VQ_ICMSALI"
	cX6Desc1  := "ICMS Utilizado na venda entre estados.            "
	cX6Desc2  := "                                                  "
	cX6Desc3  := "FGFRETE.PRW                                       "
	cConteud  := "AC07|AL07|AM07|AP07|BA07|CE07|DF07|ES07|GO07|MA07|MG12|MS07|MT07|PA07|PB07|PE07|PI07|PR12|RJ12|RN07|RO07|RR07|RS12|SC12|SE07|SP18|TO07"

	DbSelectArea("SX6") ; DbSetOrder(1)

	If !SX6->(DbSeek(Space(2) + cX6Var))
		If !SX6->(DbSeek( cFilAnt + cX6Var))
			RecLock("SX6",.T.)
			SX6->X6_FIL     := cFilAnt
			SX6->X6_VAR     := cX6Var
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := cX6Desc1
			SX6->X6_DSCSPA  := cX6Desc1
			SX6->X6_DSCENG  := cX6Desc1
			SX6->X6_DESC1   := cX6Desc2
			SX6->X6_DSCSPA1 := cX6Desc2
			SX6->X6_DSCENG1 := cX6Desc2
			SX6->X6_DESC2   := cX6Desc3
			SX6->X6_DSCSPA2 := cX6Desc3
			SX6->X6_DSCENG2 := cX6Desc3
			SX6->X6_CONTEUD := cConteud
			SX6->X6_PROPRI  := "U"
			SX6->X6_PYME    := "N"
			MsUnlock()
		EndIf
	EndIf

	cX6Var    := "VQ_ICMSORI"
	cX6Desc1  := "ICMS entre estados conforme origem de produto     "
	cX6Desc2  := "Exemplo: 1-4|2-4.5|3-4  onde origem-icms          "
	cX6Desc3  := "FGFRETE.PRW                                       "
	cConteud  := "1-4|2-4|3-4|8-4"

	DbSelectArea("SX6") ; DbSetOrder(1)

	If !SX6->(DbSeek(Space(2) + cX6Var))
		If !SX6->(DbSeek( cFilAnt + cX6Var))
			RecLock("SX6",.T.)
			SX6->X6_FIL     := cFilAnt
			SX6->X6_VAR     := cX6Var
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := cX6Desc1
			SX6->X6_DSCSPA  := cX6Desc1
			SX6->X6_DSCENG  := cX6Desc1
			SX6->X6_DESC1   := cX6Desc2
			SX6->X6_DSCSPA1 := cX6Desc2
			SX6->X6_DSCENG1 := cX6Desc2
			SX6->X6_DESC2   := cX6Desc3
			SX6->X6_DSCSPA2 := cX6Desc3
			SX6->X6_DSCENG2 := cX6Desc3
			SX6->X6_CONTEUD := cConteud
			SX6->X6_PROPRI  := "U"
			SX6->X6_PYME    := "N"
			MsUnlock()
		EndIf
	EndIf

Return()
