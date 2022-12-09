#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: fGSubPrd | Autor: Celso Ferrone Martins   | Data: 07/05/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | Revisado 12/08/2014 - Celso Martins                        |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function fGSubPrd()

Local aAreaSb1 := SB1->(GetArea())
Local aAreaZ02 := Z02->(GetArea())
Local aAreaZ03 := Z03->(GetArea())
Local aAreaSf7 := SF7->(GetArea())
Local cRetSb1  := ""

Local nPosEM    := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_EM"})   // Embalagem
Local nPosCapa  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_CAPA"}) // Capacidade
Local nPosDens  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_DENS"}) // Densidade
Local nPosVal   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VAL"})  // Valor tabela
Local nPosTabe  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TABE"}) // Tabela
Local nPosMoed  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MOED"}) // Moeda
Local nPosIpi   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_IPI"})  // IPI
Local nPosMark  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_MARK"}) // MarkUp
Local nPosVqUm  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_UM"})   // Unidade de Medida Verquimica
Local nPosUmVq  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_UMVQ"}) // Unidade de Medida Padrao
Local nPosMoVq  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_MOVQ"}) // Moeda Padrao
Local nPosTemt  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TEMT"}) // Tem Tabela ?

Local nPQtdUm1  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT"})   // Quantidade
Local nPQtdUm2  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_QUANT2"})  // Quantidade

Local nPQtdVer  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"}) // Quantidade
Local nPUniVer  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VRUN"}) // Valor Unitário
Local nPTotVer  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_VLRI"}) // Valor Total

Local nPosVRTb  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRCTAB"})  // Tabela de Preço
Local nPosTICM  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_TICM"}) // Tipo de Icms
Local nPosPICM  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PICM"}) // Percentual de ICMS
Local nPosPPis  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PPIS"}) // Percentual de Pis
Local nPosPCof  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PCOF"}) // Percentual de Cof

Local nPosSICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_SICM"}) // ICMS Substituicao Triburaria
Local nPosVIPI   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VIPI"}) // Valor do IPI

Local nPosUm    := aScan(aHeader,{|x| Alltrim(x[2])=="UB_UM"})      // Unidade de Medida Padrap
Local nPosSegUm := aScan(aHeader,{|x| Alltrim(x[2])=="UB_SEGUM"})   // Segunda Unidade de Medida

Local nPosVolum := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VOLU"}) // VOLUME

Local nPosPrcA := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_A"}) // PREÇO TABELA A Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcB := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_B"}) // PREÇO TABELA B Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcC := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_C"}) // PREÇO TABELA C Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcD := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_D"}) // PREÇO TABELA D Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcE := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_E"}) // PREÇO TABELA E Cassio Lima 18/10/2016 MCINFOTEC
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // PREÇO TABELA E Cassio Lima 18/10/2016 MCINFOTEC


Local nQtdEmb  := 0

Local _nIcmPerc   := 0
Local _nIcmBase   := 0
Local _nIcmValor  := 0

Local _nPisPerc   := 0
Local _nPIsBase   := 0
Local _nPisValor  := 0

Local _nCofPerc   := 0
Local _nCofBase   := 0
Local _nCofValor  := 0

Local nMult	:=1

DbSelectArea("SB1") ; DbSetOrder(1)
DbSelectArea("Z02") ; DbSetOrder(1)
DbSelectArea("Z03") ; DbSetOrder(2)

//RunTrigger(2,n,"",,"UB_PRODUTO")

If Z02->(DbSeek(xFilial("Z02")+aCols[n][nPosProd]))
	SB1->(DbSeek(xFilial("SB1")+aCols[n][nPosProd]))
	Z03->(DbSeek(xFilial("Z03")+aCols[n][nPosProd]+Z02->Z02_REVISA))
	nCapaci:=Z03->Z03_Capaci
	//MHS - 26/12/2016
	If aCols[n][nPosVqUm]<>Z02->Z02_UM .And. !Empty(aCols[n][nPosVqUm])
		If aCols[n][nPosVqUm]=Sb1->B1_Um
			If Sb1->B1_TipConv="D"
				nCapaci:=Z03->Z03_Capaci*Sb1->b1_Conv
				
			Else
				nCapaci:=Z03->Z03_Capaci/Sb1->b1_Conv
				
			EndIf
			
		Else
			If Sb1->B1_TipConv="M"
				nCapaci:=Z03->Z03_Capaci/Sb1->b1_Conv
				
			Else
				nCapaci:=Z03->Z03_Capaci*Sb1->b1_Conv
				
			EndIf
			
		EndIf
		
	EndIf
	
	cRetSb1             := Z02->Z02_CODMP
	aCols[n][nPosTemt]  := "S"
	aCols[n][nPosEM]    := Z02->Z02_CODEM
	aCols[n][nPosDens]  := Z02->Z02_DENSID
	aCols[n][nPosMark]  := Z03->Z03_MARKUP
	aCols[n][nPosVal]   := Z03->Z03_VALCAL
	aCols[n][nPosMoed]  := Z02->Z02_MOEDA	//If(Empty(aCols[n][nPosMoed]), If(n>1, aCols[1][nPosMoed], Z02->Z02_MOEDA), aCols[n][nPosMoed])
	aCols[n][nPosMoVq]  := Z02->Z02_MOEDA
	aCols[n][nPosVqUm]  := Z02->Z02_UM		//Empty(aCols[n][nPosVqUm]), Z02->Z02_UM, aCols[n][nPosVqUm])
	aCols[n][nPosUmVq]  := Z02->Z02_UM
	aCols[n][nPosTabe]  := Z03->Z03_TABELA	//If(Empty(aCols[n][nPosTabe]), Z03->Z03_TABELA, aCols[n][nPosTabe])
	aCols[n][nPosVRTb]  := Z03->Z03_VALCAL
	aCols[n][nPosCapa]  := Z03->Z03_CAPACI	//nCapaci // Z03->Z03_CAPACI - MHS - 26/12/2016
	
	//	aCols[n][nPQtdVer]  := 0//Z03->Z03_CAPACI
	//	aCols[n][nPUniVer]  := 0//Z03->Z03_VALCAL
	//	aCols[n][nPTotVer]  := 0//Z03->Z03_VALCAL * Z03->Z03_CAPACI
	
	aCols[n][nPosTICM]  := "T"
	
	//*******************************************************************//
	//************* Validar esse trecho // Celso Martins ****************//
	//*******************************************************************//
	
	//	_nIcmPerc := Z02->Z02_PICMMP
	_nIcmPerc	:= MaFisRet(n,"IT_ALIQICM")
	_nPisPerc   := MaFisRet(n,"IT_ALIQPIS")
	_nCofPerc   := MaFisRet(n,"IT_ALIQCOF")
	
	_nIpiValor  := MaFisRet(n,"IT_VALIPI")
	
	aCols[n][nPosPICM]  := _nIcmPerc
	aCols[n][nPosPPis]  := _nPisPerc
	aCols[n][nPosPCof]  := _nCofPerc
	aCols[n][nPosVIPI]  := _nIpiValor
	
	aCols[n][nPosUm]    := SB1->B1_UM
	aCols[n][nPosSegUm] := SB1->B1_SEGUM
	//Validar  preco de cada tabela do produto Cassio Lima 18/10/2016
	
	// MHS - 21/12/2016 - Correção dos valore atribuidos nos campos referente preços de tabela A,B,C,D e E, conforme solicitdo por Danilo
	
	aTbPrc:=CalcTab(aCols[n][nPosProd])
	aCols[n][nPosprcA]:=aTbPrc[1] // /If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), If(aCols[n][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1))
	aCols[n][nPosprcB]:=aTbPrc[2] // /If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), If(aCols[n][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1))
	aCols[n][nPosprcC]:=aTbPrc[3] // /If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), If(aCols[n][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1))
	aCols[n][nPosprcD]:=aTbPrc[4] // /If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), If(aCols[n][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1))
	aCols[n][nPosprcE]:=aTbPrc[5] // /If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), If(aCols[n][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1))
	
	/*
	aCols[n][nPosprcA]:=aTbPrc[1]/If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), aTbPrc[1])
	aCols[n][nPosprcB]:=aTbPrc[2]/If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), aTbPrc[2])
	aCols[n][nPosprcC]:=aTbPrc[3]/If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), aTbPrc[3])
	aCols[n][nPosprcD]:=aTbPrc[4]/If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), aTbPrc[4])
	aCols[n][nPosprcE]:=aTbPrc[5]/If(ReadVar()=="M->UB_VQ_MOED", If(m->Ub_Vq_Moed="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1), aTbPrc[5])
	*/
	/*
	//	Z03_FILIAL+Z03_COD+Z03_UM+Z03_MOEDA+Z03_REVISA+Z03_TABELA
	DbSelectArea("Z03") ; DbSetOrder(2); Z03->(DBGOTOP())
	Z03->(DbSeek(xFilial("Z03")+M->UB_PRODUTO+Z02->Z02_REVISA+"A"))
	aCols[n][nPosprcA] :=Z03->Z03_VALCAL
	DbSelectArea("Z03") ; DbSetOrder(2); Z03->(DBGOTOP())
	Z03->(DbSeek(xFilial("Z03")+M->UB_PRODUTO+Z02->Z02_REVISA+"B"))
	aCols[n][nPosprcB]:=Z03->Z03_VALCAL
	DbSelectArea("Z03") ; DbSetOrder(2); Z03->(DBGOTOP())
	Z03->(DbSeek(xFilial("Z03")+M->UB_PRODUTO+Z02->Z02_REVISA+"C"))
	aCols[n][nPosprcC]:=Z03->Z03_VALCAL
	DbSelectArea("Z03") ; DbSetOrder(2); Z03->(DBGOTOP())
	Z03->(DbSeek(xFilial("Z03")+M->UB_PRODUTO+Z02->Z02_REVISA+"D"))
	aCols[n][nPosprcD]:=Z03->Z03_VALCAL
	DbSelectArea("Z03") ; DbSetOrder(2); Z03->(DBGOTOP())
	Z03->(DbSeek(xFilial("Z03")+M->UB_PRODUTO+Z02->Z02_REVISA+"E"))
	aCols[n][nPosprcE]:=Z03->Z03_VALCAL
	*/
Else
	aCols[n][nPosTemt] := "N"
	aCols[n][nPosEM]   := ""
	aCols[n][nPosDens] := 0
	aCols[n][nPosMark] := 0
	aCols[n][nPosVal]  := 0
	aCols[n][nPosMoed] := ""
	aCols[n][nPosMoVq] := ""
	aCols[n][nPosVqUm] := ""
	aCols[n][nPosUmVq] := ""
	aCols[n][nPosTabe] := ""
	aCols[n][nPosVRTb] := 0
	aCols[n][nPosCapa] := 0
	
	aCols[n][nPQtdVer] := 0
	aCols[n][nPUniVer] := 0
	aCols[n][nPTotVer] := 0
	
	aCols[n][nPosTICM] := ""
	aCols[n][nPosPICM] := 0
	aCols[n][nPosPPis] := 0
	aCols[n][nPosPCof] := 0
	aCols[n][nPosVIPI] := 0
	
	aCols[n][nPQtdUm1] := 1
	aCols[n][nPQtdUm2] := 1
	
	aCols[n][nPosprcA]:=0//Cassio Lima 18/10/2016 zerar campos dos precos de cada tabela
	aCols[n][nPosprcB]:=0//Cassio Lima 18/10/2016 zerar campos dos precos de cada tabela
	aCols[n][nPosprcC]:=0//Cassio Lima 18/10/2016 zerar campos dos precos de cada tabela
	aCols[n][nPosprcD]:=0//Cassio Lima 18/10/2016 zerar campos dos precos de cada tabela
	aCols[n][nPosprcE]:=0//Cassio Lima 18/10/2016 zerar campos dos precos de cada tabela
	
	
EndIf

For nX := 1 To Len(aCols)
	If !GdDeleted(nX,aHeader,aCols) .And. AllTrim(aCols[nx][nPosEM]) != "03000"
		nQtdEmb              += aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
		aCols[nx][nPosVolum] := aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
	EndIf
Next Nx

M->UA_VQ_QEMB := nQtdEmb

U_fGFrete()
U_CfmVPrc(2)

SB1->(RestArea(aAreaSb1))
Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))

TK273DesCab(n,.F.)

Return(cRetSb1)

/*******************************/
Static Function CalcTab(cProduto) // MHS - 21/12/2016 - Calcular os valores das Tabelas A,B,C,D e E, para o produto que estiver na linha de edição.
/*******************************/
aTabela := {}
If Z02->(DbSeek(xFilial("Z02")+cProduto))
	cTabela := "A"
	For nTabela := 1 To 5
		If Z03->(DbSeek(xFilial("Z03")+cProduto+Z02->Z02_REVISA+cTabela))
			nZ03ValCal := 0
			If AllTrim(Upper(FunName())) == "TMKA271"
				nSe4Indice := 1
				nSa1Indice := 0
				If SE4->(DbSeek(xFilial("SE4")+M->UA_CONDPG))
					If SE4->E4_VQ_INDI > 0
						nSe4Indice := SE4->E4_VQ_INDI
					EndIf
				EndIf
				If SA1->(DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA))
					If SA1->A1_VQ_CMAD > 0
						nSa1Indice := SA1->A1_VQ_CMAD
					EndIf
				EndIf
				If !GdDeleted(n,aHeader,aCols)
					nZ03ValCal := CfmValCal(cTabela,nSe4Indice,nSa1Indice)
					//						nZ03ValCal := nZ03ValCal*nSe4Indice
				EndIf
			ElseIf SubStr(AllTrim(Upper(FunName())),1,4) $ "MATA|FATA"
				nSe4Indice := 1
				nSa1Indice := 0
				If SE4->(DbSeek(xFilial("SE4")+M->C5_CONDPAG))
					If SE4->E4_VQ_INDI > 0
						nSe4Indice := SE4->E4_VQ_INDI
					EndIf
				EndIf
				If SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
					If SA1->A1_VQ_CMAD > 0
						nSa1Indice := SA1->A1_VQ_CMAD
					EndIf
				EndIf
				If !GdDeleted(n,aHeader,aCols)
					nZ03ValCal := CfmVal2Cal(cTabela,nSe4Indice,nSa1Indice)
					//						nZ03ValCal := nZ03ValCal*nSe4Indice
				EndIf
			Else
				nZ03ValCal := Z03->Z03_VALCAL
			EndIf
			AAdd(aTabela, nZ03ValCal)
		EndIf
		cTabela := Soma1(cTabela)
	Next
EndIf

Return aTabela

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmValCal | Autor: Celso Ferrone Martins  | Data: 01/04/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmValCal(cTabela,nSe4Indice,nSa1Indice)

Local cRetValCl  := 0
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
Local nPUniUm1   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VRUNIT"})  // Valor Unitário
Local nPQtdVer   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_QTDE"}) // Quantidade
Local nPTotUm1   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"}) // Valor Total
Local nPosUm     := aScan(aHeader,{|x| AllTrim(x[2])=="UB_UM"})      // Unidade de Medida Padrao
Local nPosMoVq   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VQ_MOVQ"}) // Moeda padrao

Local nPosVolum  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VOLU"}) // VOLUME

Local nPosPICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PICM"}) // Percentual de ICMS
Local nPosPPis   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PPIS"}) // Percentual de Pis
Local nPosPCof   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PCOF"}) // Percentual de Cof

Local nPosSICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_SICM"}) // ICMS Substituicao Triburaria
Local nPosVIPI   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VIPI"}) // Valor do IPI

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // Pis Cofins
Local nIcmsCliVq := 18   // Icms Padrao da Tabela
Local _nPisCliVq := 0
Local _nCofCliVq := 0

Local nFatorDens  := 1
Local lDensidade  := .F.
Local lMoeda      := .F.

Local aAreaZ02   := Z01->(GetArea())
Local aAreaZ03   := Z03->(GetArea())
Local aAreaSb1   := SB1->(GetArea())

Local nPesoTot   := 0
Local nQtdEmb    := 0

DbSelectArea("Z02") ; DbSetOrder(1)
DbSelectArea("Z03") ; DbSetOrder(2)

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

//M->UA_VQ_QEMB := nQtdEmb

//StaticCall(fGFrete,AjustaSx6)

U_FGFRETE()

aIcmsAli := &(StrTran(StrTran(FormatIn(AllTrim(GetMv("VQ_ICMSALI")),"|"),"(","{"),")","}"))
aIcmsOri := &("{{'"+StrTran(StrTran(AllTrim(GetMv("VQ_ICMSORI")),"-","',"),"|","},{'")+"}}")

For Nx := 1 To Len(aIcmsAli)
	If SubStr(aIcmsAli[nX],1,2) == SA1->A1_EST
		nIcmsCliVq := Val(SubStr(aIcmsAli[nX],3,2))
	EndIf
Next Nx


If !Empty(aCols[n][nPosProd])
	
	Z02->(DbSeek(xFilial("Z02")+aCols[n][nPosProd]))
	Z03->(DbSeek(xFilial("Z03")+aCols[n][nPosProd]+Z02->Z02_REVISA+cTabela))
	
	If Z02->Z02_UM == aCols[n][nPosVqUm] .And. Z02->Z02_MOEDA == aCols[n][nPosMoed]
		nZ03FreEnt := Z03->Z03_FREENT
	Else
		nZ03FreEnt := Z03->Z03_FREENT
	EndIf
	/*
	If Empty(aCols[n][nPosProd])
	
	SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
	If SA1->A1_EST != "SP"
	For nY := 1 To Len(aIcmsOri)
	If aIcmsOri[nY][1] == SB1->B1_ORIGEM
	nIcmsCliVq := aIcmsOri[nY][2]
	Exit
	EndIf
	Next nY
	EndIf
	
	If !Empty(SB1->B1_GRTRIB)
	If SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB))
	While !SF7->(Eof()) .And. SF7->(F7_FILIAL+F7_GRTRIB) == xFilial("SF7")+SB1->B1_GRTRIB
	If SF7->F7_EST == SA1->A1_EST  .And. SF7->F7_TIPOCLI $ M->UA_TIPOCLI+"|*"
	If AllTrim(SB1->B1_GRTRIB) == "001"
	nIcmsCliVq := SF7->F7_ALIQINT // VERIFICAR - CELSO MARTINS 05/01/2015
	Else
	nIcmsCliVq := SF7->F7_ALIQEXT // VERIFICAR - CELSO MARTINS 05/01/2015
	EndIf
	Exit
	EndIf
	SF7->(DbSkip())
	EndDo
	EndIf
	EndIf
	Else
	nIcmsCliVq := aCols[n][nPosPICM]
	EndIf
	*/
	nIcmsCliVq := aCols[n][nPosPICM]
	_nPisCliVq := aCols[n][nPosPPis]
	_nCofCliVq := aCols[n][nPosPCof]
	
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
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * aCols[n][nPosDens]
		EndIf
		If Z02->Z02_MOEDA == "2"
			nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
			nValFrete := nValFrete / nVqTaxaM2
		EndIf
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| V=Verquimica - D=Negociada Redespacho  |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->UA_VQ_FRET == "V" .And. M->UA_VQ_FVER == "D"
		nValFrete := (M->UA_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * aCols[n][nPosDens]
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
	
	If aCols[n][nPosUm] == aCols[n][nPosVqUm]
		lTrocaUm := .F.
	Else
		lTrocaUm := .T.
	EndIf
	
	If aCols[n][nPosMoVq] == aCols[n][nPosMoed]
		lTrocaMo := .F.
	Else
		lTrocaMo := .T.
		aCols[n][nPosMoVq] := aCols[n][nPosMoed]
	EndIf
	
	//	If aCols[n][nPosMoed] == "2" .And. Z02->Z02_MOEDA == "2"
	//		nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
	//		nValFrete := nValFrete / nVqTaxaM2
	//	EndIf
	
	aParamCst := {}
	Aadd(aParamCst,aCols[n][nPosProd])	// Produto
	Aadd(aParamCst,aCols[n][nPosMoed])	// Moeda
	Aadd(aParamCst,aCols[n][nPosVqUm])	// Unidade de Medida
	Aadd(aParamCst,cTabela)				// Tabela de Preco
	Aadd(aParamCst,nValFrete)			// Valor do Frete
	Aadd(aParamCst,aCols[n][nPQtdVer])	// Quantidade - Calc.
	Aadd(aParamCst,aCols[n][nPUniUm1])	// Valor Unitario Digitado
	Aadd(aParamCst,lTrocaUm)			// Troca UM
	Aadd(aParamCst,lTrocaMo)            // Troca Mo
	Aadd(aParamCst,nIcmsCliVq)			// Icms Cliente
	Aadd(aParamCst,nSe4Indice)			// Indice Cond. Pagamento
	Aadd(aParamCst,nSa1Indice)			// Indice Cliente
	
	Aadd(aParamCst,_nPisCliVq)			// Pis
	Aadd(aParamCst,_nCofCliVq)			// Cofins
	
	aRetCusto := U_fCfmCusto(aParamCst)
	
	cRetValCl  := aRetCusto[1] // Valor Tabela
	
EndIf

Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))
SB1->(RestArea(aAreaSb1))


Return(cRetValCl)
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmVal2Cal| Autor: Celso Ferrone Martins  | Data: 15/12/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function CfmVal2Cal(cTabela,nSe4Indice,nSa1Indice)

Local cRetValCl  := 0
Local aParamCst  := {}
Local aRetCusto  := {}
Local nZ01FTonel := 0
Local nValFrete  := 0
Local aValFrete  := {}
Local nFatorFret := 1
Local nZ03FreEnt := 0

Local nPosProd   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_PRODUTO"}) // Produto
Local nPosMP     := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_MP"})   // Materia Prima
Local nPosEM     := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_EM"})   // Embalagem
Local nPosCapa   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_CAPA"}) // Capacidade
Local nPosDens   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_DENS"}) // Densidade
Local nPosVal    := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_VAL"})  // Valor tabela
Local nPosTabe   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_TABE"}) // Tabela
Local nPosMoed   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_MOED"}) // Moeda
Local nPosIpi    := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_IPI"})  // IPI
Local nPosMark   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_MARK"}) // MarkUp
Local nPosVqUm   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_UM"})   // Unidade de Medida Verquimica
Local nPosTemt   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_TEMT"}) // Tem Tabela ?

Local nPUniUm1   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_PRCVEN"})  // Valor Unitário
Local nPQtdVer   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_QTDE"}) // Quantidade
Local nPosUm     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"})      // Unidade de Medida Padrao
//Local nPosMoVq   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VQ_MOVQ"}) // Moeda padrao

//Local nPosVolum  := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VOLU"}) // VOLUME

Local nPosPICM   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_PICM"}) // Percentual de ICMS
Local nPosPPis   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_PPIS"}) // Percentual de Pis
Local nPosPCof   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VQ_PCOF"}) // Percentual de Cof

Local nPosSICM   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_SICM"}) // ICMS Substituicao Triburaria
Local nPosVIPI   := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_VIPI"}) // Valor do IPI

Local nPisCCalPr := 9.25 // Pis/Cofins Base de Calculo Tabela de Preco
Local nPisCCliVq := 9.25 // Pis Cofins
Local nIcmsCliVq := 18   // Icms Padrao da Tabela

Local _nPisCliVq := 0
Local _nCofCliVq := 0

Local nFatorDens  := 1
Local lDensidade  := .F.
Local lMoeda      := .F.

Local aAreaZ02   := Z01->(GetArea())
Local aAreaZ03   := Z03->(GetArea())
Local aAreaSb1   := SB1->(GetArea())

Local nPesoTot   := 0
Local nQtdEmb    := 0

DbSelectArea("Z02") ; DbSetOrder(1)
DbSelectArea("Z03") ; DbSetOrder(2)

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
				//				aCols[nx][nPosVolum] := aCols[nx][nPQtdVer] / aCols[nx][nPosCapa]
			EndIf
		EndIf
	EndIf
Next nX

//M->C5_VOLUME1 := nQtdEmb

//StaticCall(fGFrete,AjustaSx6)

//U_fGFrete()

aIcmsAli := &(StrTran(StrTran(FormatIn(AllTrim(GetMv("VQ_ICMSALI")),"|"),"(","{"),")","}"))
aIcmsOri := &("{{'"+StrTran(StrTran(AllTrim(GetMv("VQ_ICMSORI")),"-","',"),"|","},{'")+"}}")

For Nx := 1 To Len(aIcmsAli)
	If SubStr(aIcmsAli[nX],1,2) == SA1->A1_EST
		nIcmsCliVq := Val(SubStr(aIcmsAli[nX],3,2))
	EndIf
Next Nx


If !Empty(aCols[n][nPosProd])
	
	Z02->(DbSeek(xFilial("Z02")+aCols[n][nPosProd]))
	Z03->(DbSeek(xFilial("Z03")+aCols[n][nPosProd]+Z02->Z02_REVISA+cTabela))
	
	If Z02->Z02_UM == aCols[n][nPosVqUm] .And. Z02->Z02_MOEDA == aCols[n][nPosMoed]
		nZ03FreEnt := Z03->Z03_FREENT
	Else
		nZ03FreEnt := Z03->Z03_FREENT
	EndIf
	/*
	If Empty(aCols[n][nPosProd])
	
	SB1->(DbSeek(xFilial("SB1")+Z02->Z02_COD))
	If SA1->A1_EST != "SP"
	For nY := 1 To Len(aIcmsOri)
	If aIcmsOri[nY][1] == SB1->B1_ORIGEM
	nIcmsCliVq := aIcmsOri[nY][2]
	Exit
	EndIf
	Next nY
	EndIf
	
	If !Empty(SB1->B1_GRTRIB)
	If SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB))
	While !SF7->(Eof()) .And. SF7->(F7_FILIAL+F7_GRTRIB) == xFilial("SF7")+SB1->B1_GRTRIB
	If SF7->F7_EST == SA1->A1_EST
	If AllTrim(SB1->B1_GRTRIB) == "001"
	nIcmsCliVq := SF7->F7_ALIQINT // VERIFICAR - CELSO MARTINS 05/01/2015
	Else
	nIcmsCliVq := SF7->F7_ALIQEXT // VERIFICAR - CELSO MARTINS 05/01/2015
	EndIf
	Exit
	EndIf
	SF7->(DbSkip())
	EndDo
	EndIf
	EndIf
	Else
	nIcmsCliVq := aCols[n][nPosPICM]
	EndIf
	*/
	
	nIcmsCliVq := aCols[n][nPosPICM]
	_nPisCliVq := aCols[n][nPosPPis]
	_nCofCliVq := aCols[n][nPosPCof]
	
	SB1->(DbSeek(xFilial("SB1")+Z02->Z02_CODEM))
	
	nFatorFret := iIf(M->C5_VOLUME1<=1.And.SB1->B1_VQ_FRT2=="S",2,1)
	
	/*
	||||||||||||||||||||||||||||||||||||||||||||||
	||| V=Verquimica - N=Normal                |||
	||||||||||||||||||||||||||||||||||||||||||||||
	*/
	If      M->C5_VQ_FRET == "V" .And. M->C5_VQ_FVER == "N"
		nValFrete := nZ03FreEnt * nFatorFret
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| V=Verquimica - N=Negociada Retira      |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->C5_VQ_FRET == "V" .And. M->C5_VQ_FVER == "R"
		nValFrete := (M->C5_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * aCols[n][nPosDens]
		EndIf
		If Z02->Z02_MOEDA == "2"
			nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
			nValFrete := nValFrete / nVqTaxaM2
		EndIf
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| V=Verquimica - D=Negociada Redespacho  |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->C5_VQ_FRET == "V" .And. M->C5_VQ_FVER == "D"
		nValFrete := (M->C5_VQ_FVAL / nPesoTot) * 1000
		If Z02->Z02_UM != "KG"
			nValFrete := nValFrete * aCols[n][nPosDens]
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
	ElseIf M->C5_VQ_FRET == "C" .And. M->C5_VQ_FCLI == "R"
		nValFrete := 0
		/*
		||||||||||||||||||||||||||||||||||||||||||||||
		||| C=Cliente - D= Redespacho              |||
		||||||||||||||||||||||||||||||||||||||||||||||
		*/
	ElseIf  M->C5_VQ_FRET == "C" .And. M->C5_VQ_FCLI == "D"
		nValFrete := nZ03FreEnt * nFatorFret
	EndIf
	
	If aCols[n][nPosUm] == aCols[n][nPosVqUm]
		lTrocaUm := .F.
	Else
		lTrocaUm := .T.
	EndIf
	
	//	If aCols[n][nPosMoVq] == aCols[n][nPosMoed]
	lTrocaMo := .F.
	//	Else
	//		lTrocaMo := .T.
	//		aCols[n][nPosMoVq] := aCols[n][nPosMoed]
	//	EndIf
	
	//	If aCols[n][nPosMoed] == "2" .And. Z02->Z02_MOEDA == "2"
	//		nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
	//		nValFrete := nValFrete / nVqTaxaM2
	//	EndIf
	
	aParamCst := {}
	Aadd(aParamCst,aCols[n][nPosProd])	// Produto
	Aadd(aParamCst,aCols[n][nPosMoed])	// Moeda
	Aadd(aParamCst,aCols[n][nPosVqUm])	// Unidade de Medida
	Aadd(aParamCst,cTabela)				// Tabela de Preco
	Aadd(aParamCst,nValFrete)			// Valor do Frete
	Aadd(aParamCst,aCols[n][nPQtdVer])	// Quantidade - Calc.
	Aadd(aParamCst,aCols[n][nPUniUm1])	// Valor Unitario Digitado
	Aadd(aParamCst,lTrocaUm)			// Troca UM
	Aadd(aParamCst,lTrocaMo)            // Troca Mo
	Aadd(aParamCst,nIcmsCliVq)			// Icms Cliente
	Aadd(aParamCst,nSe4Indice)			// Indice Cond. Pagamento
	Aadd(aParamCst,nSa1Indice)			// Indice Cliente
	
	Aadd(aParamCst,_nPisCliVq)			// Pis
	Aadd(aParamCst,_nCofCliVq)			// Cofins
	
	aRetCusto := U_fCfmCusto(aParamCst)
	
	cRetValCl  := aRetCusto[1] // Valor Tabela
	
EndIf

Z02->(RestArea(aAreaZ02))
Z03->(RestArea(aAreaZ03))
SB1->(RestArea(aAreaSb1))


Return(cRetValCl)
