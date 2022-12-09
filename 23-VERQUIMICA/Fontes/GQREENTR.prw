#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: GQREENTR  | Autor: Celso Ferrone Martins  | Data: 29/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE executado na geração da NF de entrada                   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function GQREENTR()

Processa({||fZ04Exec()},"Gravando Ajustes...")

If Len(aCfmDaCte) > 0
	Processa({|| fCteExec()},"Ajustando CTE...")
	aCfmDaCte := {}
EndIf

If SF1->F1_TIPO == "I"
	Processa({|| fIcmExec()},"Ajustando Complemento de ICMS...")
EndIf     

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fAtualiza | Autor: Celso Ferrone Martins  | Data: 29/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Grava Conhecimento de Frete na NFe de Saida                |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fCteExec()

Local aAreaSf2 := SF2->(GetArea())
Local aAreaSd1 := SD1->(GetArea())
Local aAreaSd2 := SD2->(GetArea())

DbSelectArea("SF2") ; DbSetOrder(1)
DbSelectArea("SD1") ; DbSetOrder(1)
DbSelectArea("SD2") ; DbSetOrder(3)

For nX := 1 To Len(aCfmDaCte[2])
	If !Empty(aCfmDaCte[2][nX][1])
		/*
		If SF2->(DbSeek(xFilial("SF2")+aCfmDaCte[2][nX][2]+aCfmDaCte[2][nX][3]))
		RecLock("SF2",.F.)
		MsUnLock()
		EndIf
		*/
		
		cNumSc5 := ""
		If SD2->(DbSeek(xFilial("SD2")+aCfmDaCte[2][nX][02]+aCfmDaCte[2][nX][03]))
			cNumSc5 := SD2->D2_PEDIDO
		EndIf
		
		RecLock("Z11",.T.)
		Z11->Z11_FILIAL := xFilial("Z11")
		Z11->Z11_DOC    := SF1->F1_DOC         // Numero CTE
		Z11->Z11_SERIE  := SF1->F1_SERIE       // Serie CTE
		Z11->Z11_CLIFOR := SF1->F1_FORNECE     // Fornec. CTE
		Z11->Z11_LOJA   := SF1->F1_LOJA        // Loja CTE
		Z11->Z11_TIPO   := SF1->F1_TIPO        // Tipo CTE
		Z11->Z11_EMISSA := SF1->F1_EMISSAO     // Emissao CTE
		Z11->Z11_VALOR  := SF1->F1_VALBRUT     // Valor CTE
		Z11->Z11_ICMS   := SF1->F1_VALICM      // Valor Icms CTE
		Z11->Z11_ISS    := SF1->F1_ISS         // Valor Icms CTE
		Z11->Z11_PLACA  := SF1->F1_PLACA       // Placa
		Z11->Z11_DOCORI := aCfmDaCte[2][nX][02]
		Z11->Z11_SERORI := aCfmDaCte[2][nX][03]
		Z11->Z11_CLFORI := aCfmDaCte[2][nX][04]
		Z11->Z11_LOJORI := aCfmDaCte[2][nX][05]
		Z11->Z11_EMIORI := aCfmDaCte[2][nX][06]
		Z11->Z11_TRANSP := aCfmDaCte[2][nX][07]
		Z11->Z11_VALORI := aCfmDaCte[2][nX][08]
		Z11->Z11_FRETE  := aCfmDaCte[2][nX][09]
		Z11->Z11_TIPORI := aCfmDaCte[2][nX][10]
		Z11->Z11_COMPLE := SF1->F1_TPCTE
		Z11->Z11_NUMPV   := cNumSc5
		MsUnLock()
	EndIf
Next Nx

SD1->(DbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
While !SD1->(Eof()) .And. xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
	RecLock("SD1",.F.)
	SD1->D1_NFORI   := ""
	SD1->D1_SERIORI := ""
	MsUnLock()
	SD1->(DbSkip())
EndDo

SF2->(RestArea(aAreaSf2))
SD1->(RestArea(aAreaSd1))
SD2->(RestArea(aAreaSd2))

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fZ04Exec  ºAutor  ³Nelson Junior       º Data ³  04/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fZ04Exec()

Local aAreaSc6 := SC6->(GetArea())
Local aAreaSd1 := SD1->(GetArea())
Local aAreaSd2 := SD2->(GetArea())
Local aAreaSf2 := SF2->(GetArea())
Local aAreaSa1 := SA1->(GetArea())

If AllTrim(SF1->F1_TIPO) == "D"
	//
	SD1->(DbSetOrder(1))
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	//
	While !SD1->(EoF()) .And. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		//
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		//
		If SD2->(DbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI))
			//
			DbSelectArea("SF2")
			SF2->(DbSetOrder(1))
			SF2->(DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE))
			//
			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			//
			If SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
				//
				_nValTab := Round(SC6->C6_VQ_VAL , 2)
				_nValNot := Round(SD2->D2_VQ_UNIT, 2)
				//
				If _nValTab <> _nValNot .And. AllTrim(Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC")) == "S" .And. !Empty(SF2->F2_VEND1)
					
					
					DbSelectArea("SB1") ; DbSetOrder(1)
					If  SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
						If SC6->C6_VQ_UM == "KG"
							nQtdSd2 := SD1->D1_QUANT
						Else
							nQtdSd2 := SD1->D1_QUANT/SB1->B1_CONV
						EndIf
						
						nTxMoed2 := 1
						
						If SC6->C6_VQ_MOED == "2"
							DbSelectArea("SM2") ; DbSetOrder(1)
							If SM2->(DbSeek(dTos(SF2->F2_EMISSAO)))
								nTxMoed2 := SM2->M2_MOEDA2
							EndIf
						EndIf
						
						_nValTab := Round(SC6->C6_VQ_VAL *nTxMoed2, 2)
						_nValNot := Round(SD2->D2_VQ_UNIT*nTxMoed2, 2)
						
						DbSelectArea("Z04")
						RecLock("Z04", .T.)
						Z04->Z04_FILIAL		:= xFilial("Z04")
						Z04->Z04_VENDED		:= SF2->F2_VEND1
						Z04->Z04_EMISSA		:= SF2->F2_EMISSAO
						Z04->Z04_DOC		:= SF2->F2_DOC
						Z04->Z04_SERIE		:= SF2->F2_SERIE
						Z04->Z04_TIPO		:= SF2->F2_TIPO
						Z04->Z04_CLIENT		:= SF2->F2_CLIENTE
						Z04->Z04_LOJA		:= SF2->F2_LOJA
						Z04->Z04_ITEM		:= SD2->D2_ITEM
						Z04->Z04_COD		:= SD2->D2_COD
						Z04->Z04_TABELA		:= SD2->D2_VQ_TABE
						Z04->Z04_UM			:= SD2->D2_VQ_UM
						Z04->Z04_MOEDA		:= SC6->C6_VQ_MOED
						Z04->Z04_QUANT  	:= nQtdSd2//SD2->D2_VQ_QTDE //SD1->D1_QUANT
						Z04->Z04_VALTAB 	:= _nValTab
						Z04->Z04_VALNOT 	:= _nValNot
						Z04->Z04_TIPODC		:= If(_nValTab > _nValNot, "C", "D")
						Z04->Z04_VALOR		:= Abs(_nValTab-_nValNot)*nQtdSd2
						Z04->Z04_OBSERV		:= If(_nValTab > _nValNot, "CREDITO GERADO AUTOMATICAMENTE - GQREENTR.", "DEBITO GERADO AUTOMATICAMENTE - GQREENTR.") //Lógica reversa para a devolução (utilizando a mesma concepção da saída)
						Z04->Z04_USER		:= __cUserId
						Z04->Z04_DTLANC		:= Date()
						Z04->Z04_HRLANC		:= Time()
						Z04->Z04_STATUS		:= "D"
						Z04->Z04_DOCDEV		:= SF1->F1_DOC
						Z04->Z04_SERDEV		:= SF1->F1_SERIE
						Z04->Z04_FORDEV		:= SF1->F1_FORNECE
						Z04->Z04_LOJDEV		:= SF1->F1_LOJA
						Z04->Z04_FOMDEV		:= If(SF1->F1_FORMUL <> "S", "N", SF1->F1_FORMUL)
						Z04->Z04_REGIAO 	:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_REGIAO") //08/12/2014
						Z04->Z04_GRPVEN 	:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_GRPVEN") //08/12/2014
						Z04->(MsUnlock())
						//
					EndIf
					//
				EndIf
			EndIf
			//
		EndIf
		//
		SD1->(DbSkip())
		//
	EndDo
	//
EndIf

SC6->(RestArea(aAreaSc6))
SD1->(RestArea(aAreaSd1))
SD2->(RestArea(aAreaSd2))
SF2->(RestArea(aAreaSf2))
SA1->(RestArea(aAreaSa1))

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fIcmExec  | Autor: Celso Ferrone Martins  | Data: 14/04/2015 |||
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
Static Function fIcmExec()

DbSelectArea("Z11") ; DbSetOrder(1)
If Z11->(DbSeek(xFilial("Z11")+SD1->(D1_NFORI+D1_SERIORI)))
	
	cZ11DocOri := Z11->Z11_DOCORI
	cZ11SerOri := Z11->Z11_SERORI
	cZ11ClFOri := Z11->Z11_CLFORI
	cZ11LojOri := Z11->Z11_LOJORI
	cZ11TipOri := Z11->Z11_TIPORI
	dZ11EmiOri := Z11->Z11_EMIORI
	nZ11ValOri := Z11->Z11_VALORI
	nZ11IcmOri := Z11->Z11_ICMORI
	nZ11IssOri := Z11->Z11_ISSORI
	cZ11NumPv  := Z11->Z11_NUMPV
	cZ11Transp := Z11->Z11_TRANSP
	cZ11Placa  := Z11->Z11_PLACA
	nZ11Frete  := Z11->Z11_FRETE
	
	RecLock("Z11",.T.)
	Z11->Z11_FILIAL := xFilial("Z11")
	Z11->Z11_DOC    := SF1->F1_DOC
	Z11->Z11_SERIE  := SF1->F1_SERIE
	Z11->Z11_CLIFOR := SF1->F1_FORNECE
	Z11->Z11_LOJA   := SF1->F1_LOJA
	Z11->Z11_TIPO   := SF1->F1_TIPO
	Z11->Z11_EMISSA := SF1->F1_EMISSAO
	//Z11->Z11_VALOR  :=
	Z11->Z11_ICMS   := SF1->F1_VALICM
	//Z11->Z11_ISS    :=
	Z11->Z11_COMPLE := "S"
	Z11->Z11_DOCORI := cZ11DocOri
	Z11->Z11_SERORI := cZ11SerOri
	Z11->Z11_CLFORI := cZ11ClFOri
	Z11->Z11_LOJORI := cZ11LojOri
	Z11->Z11_TIPORI := cZ11TipOri
	Z11->Z11_EMIORI := dZ11EmiOri
	Z11->Z11_VALORI := nZ11ValOri
	Z11->Z11_ICMORI := nZ11IcmOri
	Z11->Z11_ISSORI := nZ11IssOri
	Z11->Z11_NUMPV  := cZ11NumPv
	Z11->Z11_TRANSP := cZ11Transp
	Z11->Z11_PLACA  := cZ11Placa
	Z11->Z11_FRETE  := nZ11Frete
	MsUnLock()
	
EndIf

Return()
