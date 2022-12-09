#Include "Protheus.Ch"

/*
===================================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+-----------------------+||
||| Programa: TMKVFIM  | Autor: Celso Ferrone Martins   | Data: 06/08/2014 		|||
||+-----------+--------+--------------------------------+-----------------------+||
||| Descricao | PE Apos a gravacao so Pedido de Vendas - SC5 / SC6         		|||
||+-----------+-----------------------------------------------------------------+||
||| Alterado Por:| Danilo Alves Del Busso 				|Data: 30/07/2015 		|||
||| Descriação:	 | Alterado valor SC5->C5_BLQ := "2" para SC5->C5_BLQ := "1"	|||
||+-----------+-----------------------------------------------------------------+||
||| Uso       |                                                            		|||
||+-----------+-----------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===================================================================================
*/

User Function TMKVFIM(cSuaNum,cSc5Num)

Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSUA := SUA->(GetArea())
Local aAreaSUB := SUB->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local cEspecie := ""
Local dDtEntVq := cTod("")
Local _lBlq	   := .F.

AjustaSx6()

DbSelectArea("SC5") ; DbSetOrder(1)	// Pedido De Vendas - Itens
DbSelectArea("SC6") ; DbSetOrder(1)	// Pedido De Vendas - Itens
DbSelectArea("SUA") ; DbSetOrder(1)	// CallCenter - Cabecalho
DbSelectArea("SUB") ; DbSetOrder(1)	// CallCenter - Itens

If SUA->(DbSeek(xFilial("SUA")+cSuaNum))
	If SUA->UA_OPER == "1"
	
		If SUA->UA_VQ_FCLI$"D" .OR. SUA->UA_VQ_FVER$"D"
			MsgAlert("REDESPACHO - Favor entrar em contato com a transportadora para confirmação de transporte de produtos químocos")
		EndIf
	
		SUB->(DbSeek(xFilial("SUB")+cSuaNum))
		While !SUB->(Eof()) .And. SUB->(UB_FILIAL+UB_NUM) == xFilial("SUB")+cSuaNum
			If SC6->(DbSeek(xFilial("SC6")+SUB->(UB_NUMPV + UB_ITEMPV)))
				SB1->(DbSeek(xFilial("SB1")+SUB->UB_VQ_EM))
				nPosEsp := At(" ",SB1->B1_DESC)
				If Empty(cEspecie)
					cEspecie := AllTrim(SubStr(SB1->B1_DESC,1,nPosEsp-1))
				Else
					If AllTrim(cEspecie) != AllTrim(SubStr(SB1->B1_DESC,1,nPosEsp-1))
						cEspecie := "DIVERSOS"
					EndIf
				EndIf
				If Empty(dDtEntVq)
					dDtEntVq := SC6->C6_ENTREG
				Else
					If dDtEntVq > SC6->C6_ENTREG
						dDtEntVq := SC6->C6_ENTREG
					EndIf
				EndIf
				RecLock("SC6",.F.)
				SC6->C6_VQ_CAPA := SUB->UB_VQ_CAPA // Capacidade
				SC6->C6_VQ_DENS := SUB->UB_VQ_DENS // Densidade
				SC6->C6_VQ_TABE := SUB->UB_VQ_TABE // Tabela
				SC6->C6_VQ_UM   := SUB->UB_VQ_UM   // Volume
				SC6->C6_VQ_MOED := SUB->UB_VQ_MOED // Moeda
				SC6->C6_VQ_QTDE := SUB->UB_VQ_QTDE // Qtde. Orcam.
				SC6->C6_VQ_UNIT := SUB->UB_VQ_VRUN // Vlr.Unit Orc
				SC6->C6_VQ_TOTA := SUB->UB_VQ_VLRI // Total Orcam.
				SC6->C6_VQ_VAL  := SUB->UB_VQ_VAL  // Preco Verq.
				SC6->C6_VQ_MARK := SUB->UB_VQ_MARK // MarkUp
				SC6->C6_VQ_MP   := SUB->UB_VQ_MP   // Mat. Prima
				SC6->C6_VQ_EM   := SUB->UB_VQ_EM   // Embalagem
				SC6->C6_VQ_TEMT := SUB->UB_VQ_TEMT // Tab.Prc
				SC6->C6_VQ_TAX2 := SUB->UB_VQ_TAX2 // Taxa Utilizada na M2
				SC6->C6_VQ_VOLU := SUB->UB_VQ_VOLU // VOLUME
				SC6->C6_COMIS1  := GetMv("VQ_COMIST"+SUB->UB_VQ_TABE)
				SC6->C6_VQCPCLI := SUB->UB_VQCPCLI		//Danilo Busso 17/08/2016 -- codigo do produto do cliente que vai na DANFE
				SC6->C6_VQ_PICM := SUB->UB_VQ_PICM
				SC6->C6_VQ_PPIS := SUB->UB_VQ_PPIS
				SC6->C6_VQ_PCOF := SUB->UB_VQ_PCOF
				
				SC6->(MsUnLock())
			EndIf
			SUB->(DbSkip())
		EndDo
		
		If SC5->(DbSeek(xFilial("SC5")+SUA->UA_NUMSC5))
			//
			_lDevCom := If(AllTrim(SC5->C5_TIPO) == "D", .T., .F.)
			//
			RecLock("SC5",.F.)
			SC5->C5_ESPECI1 := cEspecie
			SC5->C5_VOLUME1 := SUA->UA_VQ_QEMB
			SC5->C5_PESOL   := SUA->UA_PESOL
			SC5->C5_PBRUTO  := SUA->UA_PESOB
			SC5->C5_VQ_FRET := SUA->UA_VQ_FRET
			SC5->C5_VQ_FCLI := SUA->UA_VQ_FCLI
			SC5->C5_VQ_FVER := SUA->UA_VQ_FVER
			SC5->C5_VQ_FVAL := SUA->UA_VQ_FVAL
			SC5->C5_VQ_TPCO := SUA->UA_VQ_TPCO
			SC5->C5_MENNOTA := SUA->UA_MENNOTA
			SC5->C5_MENNOT1 := SUA->UA_MENNOT1
			SC5->C5_MENNOT2 := SUA->UA_MENNOT2
			SC5->C5_MENNOT3 := SUA->UA_MENNOT3
			SC5->C5_MENPAD  := SUA->UA_MENPAD
			SC5->C5_MODANP	:= "01"
			SC5->C5_VQ_TXMO := Iif(SUA->UA_VQ_TXDO>1,SUA->UA_VQ_TXDO,1)
			//
			If !Empty(_cCodMot) .And. !_lDevCom
				SC5->C5_BLQ := "1" //Alterado para 1 por Danilo Alves Del Busso - 30/07/2015
			Else
				SC5->C5_BLQ := ""
			EndIf
			
			If AllTrim(SC5->C5_TIPO) $ "D/B"
				SC5->C5_VQ_CLID := Posicione("SA2",1,xFilial("SA2")+SC5->(C5_CLIENTE+C5_LOJACLI),"A2_NOME")
			Else
				SC5->C5_VQ_CLID := Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")
			EndIf
			
			SC5->C5_ENTREG  := dDtEntVq      
			SC5->C5_VQ_FVRE := SUA->UA_VQ_FVRE 
			If !Empty(_cCodMot)
				SC5->C5_VQ_MOT	:=	Alltrim(_cCodMot)    
				SC5->C5_VQ_USL1 := ""
				SC5->C5_VQ_DTL1 := ctod("  /  /  ")
				SC5->C5_VQ_HRL1 := ""
				/* 
				SC5->C5_VQ_USL2 := ""
				SC5->C5_VQ_DTL2 := ctod("  /  /  ")
				SC5->C5_VQ_HRL2 := ""
				*/
			EndIf
				
			//----> SE NAO HOUVER NENHUM BLOQUEIO, O PEDIDO GRAVA LIBERADO
			If Empty(SC5->C5_BLQ) .And. Empty(SC5->C5_VQ_MOT)
				SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
			    Begin Transaction
			    While SC6->C6_NUM == SC5->C5_NUM .AND. SC6->(!EOF())
          			MaLibDoFat(SC6->(RecNo()),(SC6->C6_QTDVEN-SC6->C6_QTDENT),.T.,.T.,.T.,.T.)
			        RecLock("SC6",.F.)
			        	SC6->C6_FCICOD	:=	POSICIONE("SD1",26,xFilial("SD1")+SC9->C9_LOTECTL,"D1_FCICOD")                                        
			        MsUnLock()
			        SC6->(dBSkip())
			     EndDo
			    MaLiberOk({ SC5->C5_NUM },.T.)
			    End Transaction				
				
				RecLock("SC5",.f.)
				SC5->C5_BLQ	:=	""
				SC5->C5_VQ_USL1  := "AUTOMATICO"
				SC5->C5_VQ_DTL1  := Date()
				SC5->C5_VQ_HRL1  := Time()

				SC5->(MsUnLock())
				
				dbSelectArea("SC9")
				dbSetOrder(1)
				If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)
					While Eof() = .f. .And. SC9->C9_FILIAL == SC5->C5_FILIAL .AND. SC9->C9_PEDIDO == SC5->C5_NUM
						//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
						//ALERT("SC9-> "+SC9->C9_PEDIDO+" "+SC9->C9_ITEM+" "+SC9->C9_PRODUTO)
						RecLock("SC9",.f.)
						SC9->C9_VQ_TRAN		:=	SC5->C5_TRANSP
						SC9->C9_VQ_NTRA		:=	POSICIONE("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
						SC9->C9_VQ_NCLI		:=	POSICIONE("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_NOME")
						SC9->C9_VQ_FVER		:=	SC5->C5_VQ_FVER
						SC9->C9_VQ_FCLI		:=	SC5->C5_VQ_FCLI
						MsUnLock()
						//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
						
						SC9->(dbSkip())
					EndDo
				EndIf
			EndIf
			
			SC5->(MsUnLock())
		EndIf
	EndIf
EndIf

SC5->(RestArea(aAreaSC5))
SC6->(RestArea(aAreaSC6))
SUA->(RestArea(aAreaSUA))
SUB->(RestArea(aAreaSUB))
SB1->(RestArea(aAreaSB1))

Return()


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

Local aSx6Var := {}

Aadd(aSx6Var,{"VQ_COMISTA","N","Comissao vendedor tabela A","","TMKVFIM.PRW","0.75"})
Aadd(aSx6Var,{"VQ_COMISTB","N","Comissao vendedor tabela B","","TMKVFIM.PRW","0.50"})
Aadd(aSx6Var,{"VQ_COMISTC","N","Comissao vendedor tabela C","","TMKVFIM.PRW","0.35"})
Aadd(aSx6Var,{"VQ_COMISTD","N","Comissao vendedor tabela D","","TMKVFIM.PRW","0.20"})
Aadd(aSx6Var,{"VQ_COMISTE","N","Comissao vendedor tabela E","","TMKVFIM.PRW","0.00"})

DbSelectArea("SX6") ; DbSetOrder(1)

For nX := 1 to Len(aSx6Var)
	If !SX6->(DbSeek(Space(2) + aSx6Var[nX][1]))
		If !SX6->(DbSeek( cFilAnt + aSx6Var[nX][1]))
			RecLock("SX6",.T.)
			SX6->X6_FIL     := cFilAnt
			SX6->X6_VAR     := aSx6Var[nX][1]
			SX6->X6_TIPO    := aSx6Var[nX][2]
			SX6->X6_DESCRIC := aSx6Var[nX][3]
			SX6->X6_DSCSPA  := aSx6Var[nX][3]
			SX6->X6_DSCENG  := aSx6Var[nX][3]
			SX6->X6_DESC1   := aSx6Var[nX][4]
			SX6->X6_DSCSPA1 := aSx6Var[nX][4]
			SX6->X6_DSCENG1 := aSx6Var[nX][4]
			SX6->X6_DESC2   := aSx6Var[nX][5]
			SX6->X6_DSCSPA2 := aSx6Var[nX][5]
			SX6->X6_DSCENG2 := aSx6Var[nX][5]
			SX6->X6_CONTEUD := aSx6Var[nX][6]
			SX6->X6_PROPRI  := "U"
			SX6->X6_PYME    := "N"
			MsUnlock()
		EndIf
	EndIf
Next

Return()

/***********************/
User Function MHSTabela()
/***********************/
Local nPosPrcA := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_A"}) // PREÇO TABELA A Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcB := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_B"}) // PREÇO TABELA B Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcC := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_C"}) // PREÇO TABELA C Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcD := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_D"}) // PREÇO TABELA D Cassio Lima 18/10/2016 MCINFOTEC
Local nPosPrcE := aScan(aHeader,{|x| Alltrim(x[2])=="UB_VQ_PR_E"}) // PREÇO TABELA E Cassio Lima 18/10/2016 MCINFOTEC
Local nPosProd := aScan(aHeader,{|x| Alltrim(x[2])=="UB_PRODUTO"}) // PREÇO TABELA E Cassio Lima 18/10/2016 MCINFOTEC
Local nPosMoed:=aScan(aHeader, {|Z|AllTrim(Z[2])=="UB_VQ_MOED"})
Local nPosProd:=aScan(aHeader, {|Z|AllTrim(Z[2])=="UB_PRODUTO"})
Local nXX

If !(Len(aCols)>0 .And. !Empty(aCols[n][nPosProd]))
	Return
	
EndIf

For nXX:=1 To Len(aCols)
	aTbPrc:=CalcTab(aCols[nXX][nPosProd],nXX)
	aCols[nXX][nPosprcA]:=aTbPrc[1] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	aCols[nXX][nPosprcB]:=aTbPrc[2] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	aCols[nXX][nPosprcC]:=aTbPrc[3] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	aCols[nXX][nPosprcD]:=aTbPrc[4] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	aCols[nXX][nPosprcE]:=aTbPrc[5] ///If(aCols[nXX][nPosMoed]="2", Posicione("SM2", 1, Dtos(dDataBase), "M2_MOEDA2"), 1)
	
Next

oGetTLV:Refresh()
Return

/*******************************/
Static Function CalcTab(cProduto,nXC) // MHS - 21/12/2016 - Calcular os valores das Tabelas A,B,C,D e E, para o produto que estiver na linha de edição.
/*******************************/
Local nOrdZ03:=Z03->(IndexOrd())
Z03->(DbSetOrder(2))
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
					nZ03ValCal := CfmValCal(cTabela,nSe4Indice,nSa1Indice,nXC)
					//						nZ03ValCal := nZ03ValCal*nSe4Indice
					
				EndIf
				
			EndIf
			
			AAdd(aTabela, nZ03ValCal)
			
		EndIf
		
		cTabela := Soma1(cTabela)
		
	Next
	
EndIf

Z03->(DbSetOrder(nOrdZ03))
Return aTabela


/********************************************************/
Static Function CfmValCal(cTabela,nSe4Indice,nSa1Indice, NN)
/********************************************************/
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

If !Empty(aCols[NN][nPosProd])
	Z02->(DbSeek(xFilial("Z02")+aCols[NN][nPosProd]))
	Z03->(DbSeek(xFilial("Z03")+aCols[NN][nPosProd]+Z02->Z02_REVISA+cTabela))
	If Z02->Z02_UM == aCols[NN][nPosVqUm] .And. Z02->Z02_MOEDA == aCols[NN][nPosMoed]
		nZ03FreEnt := Z03->Z03_FREENT
	Else
		nZ03FreEnt := Z03->Z03_FREENT
	EndIf
	
	nIcmsCliVq := aCols[NN][nPosPICM]
	_nPisCliVq := aCols[NN][nPosPPis]
	_nCofCliVq := aCols[NN][nPosPCof]
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
			nValFrete := nValFrete * aCols[NN][nPosDens]
			
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
	
	If aCols[NN][nPosUm] == aCols[NN][nPosVqUm]
		lTrocaUm := .F.
	Else
		lTrocaUm := .T.
	EndIf
	
	If aCols[NN][nPosMoVq] == aCols[NN][nPosMoed]
		lTrocaMo := .F.
	Else
		lTrocaMo := .T.
		aCols[NN][nPosMoVq] := aCols[NN][nPosMoed]
	EndIf
	
	//	If aCols[n][nPosMoed] == "2" .And. Z02->Z02_MOEDA == "2"
	//		nVqTaxaM2 := GetMV("VQ_TXMOED2", .F.)
	//		nValFrete := nValFrete / nVqTaxaM2
	//	EndIf
	
	aParamCst := {}
	Aadd(aParamCst,aCols[NN][nPosProd])	// Produto
	Aadd(aParamCst,aCols[NN][nPosMoed])	// Moeda
	Aadd(aParamCst,aCols[NN][nPosVqUm])	// Unidade de Medida
	Aadd(aParamCst,cTabela)				// Tabela de Preco
	Aadd(aParamCst,nValFrete)			// Valor do Frete
	Aadd(aParamCst,aCols[NN][nPQtdVer])	// Quantidade - Calc.
	Aadd(aParamCst,aCols[NN][nPUniUm1])	// Valor Unitario Digitado
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
