#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  mta410OK  ³ Autor ³ Denis Varella       ³ Data ³ 02/08/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para calculo do total de volumes          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 															  ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT410TOK()
	Local aArea := GetArea()
	Local nOpc := ''
	Local nW := 0
	Local nB := nNewV := 0
	Local aST := {}
	Local _lRet		:= .T.
	Local cCodULib	:= U_MyNewSX6("CV_USLBAPV", ""	,"C","Usuarios liberados a alterar pedido, sem interferir no bloqueio", "", "", .F. )
	Local cCodUsr	:= Alltrim(RetCodUsr())
	Local lAtcl  	:= SuperGetMv('MV_ATICL',,.T.)  // ativar ou não o calculo do ciclo do pedido
	Local nX		:= 0
	Local i 		:= 0
	Local _nDiasTol := SuperGetMV("MV_DIASTOL",,15) //Dias para tolerância de atraso médio para liberação do pedido
	Local nOldValor := 0
	Local nNewValor := 0
	local lBlqFin := .F.

	Local nOldQtd := 0
	Local nNewQtd := 0
	Local lDuplic := .F.
	

	Private lNbRet := .F.
	Private oDlgPvt
	//Says e Gets
	Private oSayUsr
	Private oGetUsr, cGetUsr := Space(25)
	Private oSayPsw
	Private oGetPsw, cGetPsw := Space(20)
	Private oGetErr, cGetErr := ""
	//Dimensões da janela
	Private nJanLarg := 200
	Private nJanAltu := 200
	nOpc := PARAMIXB[1]
	SetPrvt("_CNUMPED,_NTOTAL,I,_NPOSPEC,_NVALOR,M->C5_VOLUME1")

	//Validação da data de faturamento
	/*If !VldDtFat()
	Return .F.
	EndIf*/

	If AllTrim(FunName()) == 'FCIATU'
		return .t.
	EndIf

	If ALTERA
		cQry := "SELECT CB7_ORDSEP FROM CB7010 WHERE CB7_PEDIDO = '"+M->C5_NUM+"' and D_E_L_E_T_ = '' "
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),'PEDSEP',.T.,.T.)

		If PEDSEP->(!Eof())
			If !empty(trim(PEDSEP->CB7_ORDSEP))
				MsgAlert("Este pedido possui ordem de separação: "+trim(PEDSEP->CB7_ORDSEP)+", impossível realizar alteração.","Atenção!")
				PEDSEP->(DbCloseArea())
				Return .F.
			EndIf
		EndIf

		PEDSEP->(DbCloseArea())
	EndIf

	If !(Alltrim(cCodUsr) $ Alltrim(cCodULib)) .And. lAtcl
			//Validação da data do PCP
		If !U_PZ410PCP()
				Return .F.
		EndIf

			//Validação do forecast
		If !U_PZCVV204()
				Return .F.
		EndIf
	EndIf

		//Validação do armazem CQ
	If !VldArmzCq()
			Return .F.
	EndIf
		nPosITEM   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
		nPosTES    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
		nPosCFOP   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})

		_nPosPec  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })
		_nPosLib  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB" })
		_nPosPro  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
		_nPosUm	  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM" })
		_nPosArm	  	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL" })

		nPosDesc	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCRI" })

		_cNumPed := M->C5_NUM
		_cCodCli := M->C5_CLIENTE
		_cLjCli  := M->C5_LOJACLI

		_nTotal  := 0         //M->C5_VOLUME1
		_nPesoT	 := 0		  //M->C5_PESOL
		_nPesoTB := 0		  //M->C5_PESBRU
		_cEspc 	 := ""
		cProd	 := ""


	IF SM0->M0_CODFIL == "02"
		RETURN(.T.)
	Endif

	IF SM0->M0_ESTCOB ==  "PA"
		RETURN(.T.)
	EndIf

	If  INCLUI .OR. ALTERA     //MODIFICADO EM 02/07/2001

		For I := 1 to len(aCols)
			If aCols[I,Len(aHeader)+1] == .F.  //verifica se nao esta deletado
				If !lDuplic
				
					If Posicione("SF4",1,xFilial("SF4")+aCols[I,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_TES"})],"F4_DUPLIC") == 'S'
						
						DbSelectArea("SE4")
						DbSetOrder(1)
						If DbSeek(xFilial("SE4")+M->C5_CONDPAG,.f.)
							If !Alltrim(SE4->E4_COND )=="0" // NAO BLOQUEAR CREDITO PARA PEDIDOS COM CONDICAO DE PAGAMENTO A VISTA
								lDuplic := .T.
							EndIf
						EndIf
					EndIf
				EndIf
					nNewValor += aCols[I,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_VALOR"})]
					If Trim(FunName()) != 'MATA310'
						If AllTrim(GetAdvFVal("SA7","A7_XSEGMEN",xFilial("SA7")+_cCodCli+_cLjCli+aCols[I,_nPosPro],1))  == "" .And. ((M->C5_TIPO <> 'B') .And. (M->C5_TIPO <> 'D'))
								MsgStop("Segmento não preenchido na amarração:"+Chr(13) + Chr(10)+Chr(13) + Chr(10)+"Cliente: "+AllTrim(M->C5_NOMECLI)+Chr(13) + Chr(10)+"Produto: "+AllTrim(aCols[I,nPosDesc]),"BLOQUEIO")
								Return .F.
						EndIf
					EndIf
					_nValor   := (Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_PESO") * aCols[I,_nPosPec]) / Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_QE")
					_nPesoL	  := (Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_PESO") * aCols[I,_nPosPec])
					_nPesoT	  += _nPesoL
					_nPesoB	  := _nPesoL + (_nValor * (Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_PESOEMB")))
					_nPesoTB  += _nPesoB
					_nTotal   += _nValor
				If _cEspc != "" .AND. _cEspc != Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_ESPVEND")
						_cEspc	  := "VOLUMES"
				Else
						_cEspc 	  := Posicione("SB1",1,xFilial("SB1") + aCols[I,_nPosPro],"B1_ESPVEND")
				Endif
				If len(aST) > 0
					For nX := 1 to len(aST)
						If aST[nX][1] == aCols[I,_nPosPro] .and. aST[nX][2] != aCols[I,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_CLASFIS" })]
								MsgStop("Situação Tributária divergente entre itens do pedido.","BLOQUEIO")
								Return .F.
						EndIf
					Next
				EndIf
					aAdd(aST,{aCols[I,_nPosPro],aCols[I,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_CLASFIS" })]})
			EndIf
		Next

		If !M->C5_YESPPES
				//If(ALLTRIM(M->C5_ESPECI1)) == ''
				M->C5_ESPECI1 := _cEspc
			If _nTotal < 1
					_nTotal := 1
			Endif
				M->C5_VOLUME1 := _nTotal
				//Endif

			If _nPesoT != 0
					M->C5_PESOL   := _nPesoT  
					M->C5_PBRUTO  := _nPesoTB 
			Endif
		EndIf
	Endif

	If Altera

		M->C5_ALTDT:= dDatabase                  
		M->C5_ALTHORA:= TIME()
		M->C5_ALTUSER:= USRRETNAME(__CUSERID)

	EndIf

	If Inclui .Or. Altera

		If ExistBlock("RFATE007")
				_lRet := ExecBlock("RFATE007") //Chamada de rotina para atualização dos percentuais de comissão para vendedor nos itens do pedido de venda
		EndIf

		For nW := 1 To len(aCols)
				// nDiasLau  := POsicione("SA7",1,xFilial("SA7") + M->C5_CLIENTE + M->C5_LOJACLI + acols[nW,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})] , 'A7_ANTEMPO' )   
				// nDiasProd := POsicione("SB1",1,xFilial("SB1") + acols[nW,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})],'B1_PE' )
				aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_CC" })] := Posicione('SB1',1,xfilial('SB1')+aCols[nW,_nPosPro], 'B1_CC')   
				aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_CONTA" })] := Posicione('SB1',1,xfilial('SB1')+aCols[nW,_nPosPro], 'B1_CONTA')   
				aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_ITEMCTA" })] := Posicione('SB1',1,xfilial('SB1')+aCols[nW,_nPosPro], 'B1_ITEMCC')   
				aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_CLVL" })] := Posicione('SB1',1,xfilial('SB1')+aCols[nW,_nPosPro], 'B1_CLVL')    

		Next


	EndIf

	If lAtcl == .T. .And. !(Alltrim(cCodUsr) $ Alltrim(cCodULib))

		If Inclui .Or. Altera // bloqueio valor minimo de faturamento.

				nMinFt := SuperGetMv('MV_VLMIFAT',,2000)  

			If M->C5_MOEDA == 1
					nTxmd:= 1
			else
				If M->C5_TXMOEDA == 0
						Aviso("Atenção-Tx.Moeda","Por gentileza, preencher a Tx.PTAX. ",{"Ok"},2)
						Return .F.
				Else
						nTxmd:= M->C5_TXMOEDA
				EndIf
			endif

				nValor:= aCols[1,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_VALOR"})] * nTxmd 

			For nW := 2 To len(aCols)
					nValor+= aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_VALOR"})]* nTxmd		
			Next
				
				

			If Alltrim(Posicione("SF4",1,xFilial("SF4") + aCols[1,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_TES"})] , 'F4_DUPLIC' )) == "S"

				IF nValor < nMinFt
					If !IsBLind() //Ajuste para não dar erro na Execauto da loja integrada. Gustavo Gonzalez - 05/11/2021
						If Aviso("Atenção-Faturamento Mínimo"," Este pedido não atingiu o valor mínimo de Faturamento!!"+CRLF+"Deseja Continuar? ",{"Sim","Não"},2)==2
							Return(.F.)
						EndIf
					EndIf
				Endif

			Endif
		Endif
	Endif

	If Altera


		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		If SC6->(DbSeek(xFilial("SC6")+M->C5_NUM))
			While SC6->(!EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == M->C5_NUM
					nOldValor += SC6->C6_VALOR
					nOldQtd += SC6->C6_QTDVEN
					SC6->(DbSkip())
			EndDo
		EndIf
		For nNewV := 1 To len(aCols)
			If !aCols[nNewV,Len(aHeader)+1]
					nNewQtd += aCols[nNewV,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})]
			EndIf
		Next nNewV

		If (nNewQtd > 0 .and. (nNewQtd != nOldQtd .or. M->C5_FECENT != SC5->C5_FECENT))
			If trim(M->C5_YTPBLQ) == 'OK'
					M->C5_YTPBLQ := ""
			EndIf
				U_WFALTPED(nNewQtd != nOldQtd,M->C5_FECENT != SC5->C5_FECENT)
		EndIf
			
	EndIf

	If Inclui .Or. Altera

		//Novo bloqueio financeiro ~ Denis Varella 01/06/2021
		If M->C5_TIPO == 'N' .and. lDuplic
			If (Inclui .or. (Altera .and. (nNewQtd != nOldQtd .or. M->C5_FECENT != SC5->C5_FECENT .or. nNewValor != nOldValor)))

				If Trim(M->C5_XBLQFIN) != 'L'
					M->C5_XBLQFIN := ''
					M->C5_XBLQMOT := ''
					cQry := " SELECT ISNULL((SELECT SUM(E1_VALOR) FROM SE1010 E1 WITH (NOLOCK) 
					cQry += " WHERE E1_CLIENTE = '"+M->C5_CLIENTE+"' AND E1_LOJA = '"+M->C5_LOJACLI+"' AND E1.D_E_L_E_T_ = '' 
					cQry += " AND E1_STATUS = 'A' AND E1_TIPO = 'NF' AND E1_VENCREA < '"+DtoS(DaySub(date(),_nDiasTol))+"'),0) ATRASO "
    				dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),'QRYATRASO',.T.,.T.)

					If (QRYATRASO->ATRASO > 0)
							M->C5_XBLQMOT := "XInadimplência"
							lBlqFin := .T.
					ElseIf (nNewValor > SA1->A1_LC - SA1->A1_SALDUP)
							M->C5_XBLQMOT := "XLimite de Crédito"
							lBlqFin := .T.
					ElseIf M->C5_CONDPAG $ GetMv("MV_BLQFCND")
							M->C5_XBLQMOT := "XAntecipado"
							lBlqFin := .T.
					EndIf

					QRYATRASO->(DbCloseArea())

					If lBlqFin
						MsgAlert("Cliente passará por análise financeira para liberação.","Bloqueio Financeiro")
						M->C5_XBLQFIN := 'B'
						For nB := 1 to len(aCols)
							aCols[nB,_nPosLib] := 0
						Next nB
					EndIf
					
				EndIf

			EndIf
		EndIf

		// Nova análise de Margem
		If M->C5_TIPO == 'N' .and. Trim(M->C5_XBLQMRG) != 'L'
			M->C5_XBLQMRG := ''
			//M->C5_XBLQMIN := ''
			DbSelectArea("SE4")
			SE4->(DbSetOrder(1))
			SE4->(DbSeek(xFilial("SE4")+M->C5_CONDPAG))

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))

			nNewV := 0
			nMargemLim := SuperGetMV("MV_XMARGEM",,15)
					
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
					
			DbSelectArea("SA4")
			SA4->(DbSetOrder(1))
			SA4->(DbSeek(xFilial("SA4")+M->C5_TRANSP))

			DbSelectArea("SF4")
			SF4->(DbSetOrder(1))

			DbSelectArea("DA1")
			DA1->(DbSetOrder(1))

			nTxMoeda := U_GetMoeda()

			For nNewV := 1 To len(aCols)
				If !aCols[nNewV,Len(aHeader)+1] .and. aCols[nNewV,GDFieldPos("C6_XPRCNET")] > 0 .and. !(M->C5_CLIENTE $ SuperGetMV("MV_CLINMRG",,""))
					If SF4->(DbSeek(xFilial("SF4")+aCols[nNewV,GDFieldPos("C6_TES")])) .and. SF4->F4_DUPLIC == 'S'

						DA1->(DbSeek(xFilial("DA1")+M->C5_TABELA+SB1->B1_COD))

						/*If aCols[nNewV,GDFieldPos("C6_PRCVEN")] < DA1->DA1_XPRCMI
							M->C5_XBLQMIN := 'S'
							U_WFPRCMIN(aCols[nNewV])
						EndIf*/
						
						SB1->(DbSeek(xFilial("SB1") + aCols[nNewV,_nPosPro]))
						SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+aCols[nNewV,_nPosArm]))
						aImpostos := GetImpostos(aCols[nNewV])
						

						CUSTOVND := GetB9Custo(SB1->B1_COD,aCols[nNewV,GDFieldPos("C6_LOCAL")])
						nGGF := GetGGF(SB1->B1_COD, aCols[nNewV,GDFieldPos("C6_LOTECTL")])
						nGGFFixo := SuperGetMv("MV_GGFFIXO",,0.25)

						If !(SB1->B1_TIPO $ 'ME') //Apenas para produtos que não são de revenda
							CUSTOVND := CUSTOVND - nGGF + (nGGFFixo * nTxMoeda)
						EndIf

						TOTALFAT :=	(aCols[nNewV,GDFieldPos("C6_VALOR")] + aImpostos[1]) * M->C5_TXMOEDA

						PRCNET 	 := aCols[nNewV,GDFieldPos("C6_XPRCNET")]
						QTDVEN 	 := aCols[nNewV,GDFieldPos("C6_QTDVEN")]
						NETSALES := PRCNET * QTDVEN * M->C5_TXMOEDA
						IMPOSTOS := TOTALFAT - NETSALES

						CUSTOFIN := (TOTALFAT * (SE4->E4_ACRVEN1 / 100))
						FRTCIF   := Iif(M->C5_TPFRETE == 'C', Round(SA4->A4_XMEDIAF * QTDVEN,2), 0)
						MARGBRUT := (NETSALES - ((CUSTOVND * QTDVEN) + FRTCIF + CUSTOFIN))
						MARGPORC := ((NETSALES - ((CUSTOVND * QTDVEN) + FRTCIF + CUSTOFIN))/NETSALES)*100
						CUSTOKG  := CUSTOVND + ((FRTCIF + CUSTOFIN) / QTDVEN)

						If MARGPORC < nMargemLim
							M->C5_XBLQMRG := "S"
							aInfo := {aImpostos,TOTALFAT,IMPOSTOS,NETSALES,CUSTOFIN,FRTCIF,MARGBRUT,MARGPORC,CUSTOKG,QTDVEN,PRCNET,M->C5_TXMOEDA}
							U_WFMARGEM(aCols[nNewV], aInfo, nMargemLim)
						else
							
							If Trim(SC5->C5_XBLQMRG) == 'B'
								SC5->(RecLock("SC5",.F.))
								SC5->C5_LGLIBCO := "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
								SC5->(MsUnlock())
							EndIf

						EndIf

					EndIf
				EndIf
			Next nNewV

			//If M->C5_XBLQMIN == 'S'
			//	MsgAlert("Pedido bloqueado por haver produto com preço de venda inferior ao preço mínimo estipulado na tabela de preço.","Atenção!")
			//EndIf
		EndIf

	EndIf
	
	RestArea(aArea)

Return(.T.)

Static Function GetImpostos(aCol)
	MaFisIni(M->C5_CLIENTE,M->C5_LOJACLI,If(M->C5_TIPO$'DB',"F","C"),M->C5_TIPO,M->C5_TIPOCLI,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700")
	MaFisAdd(aCol[GDFieldPos("C6_PRODUTO")],;
		aCol[GDFieldPos("C6_TES")],;
		aCol[GDFieldPos("C6_QTDVEN")],;
		aCol[GDFieldPos("C6_PRCVEN")],;
		(aCol[GDFieldPos("C6_PRUNIT")] - aCol[GDFieldPos("C6_PRCVEN")]),;
		"",;
		"",;
		0,;
		0,;
		0,;
		0,;
		0,;
		aCol[GDFieldPos("C6_VALOR")],;
		0,;
		0,;
		0)
	nValIpi        := MaFisRet(1,"IT_VALIPI" )
	nValIcm        := MaFisRet(1,"IT_VALICM" )
	nValCom        := MaFisRet(1,"IT_VALCMP" )
	nValPis   		:= MaFisRet(1,"IT_VALPS2")
	nValCof   		:= MaFisRet(1,"IT_VALCF2" )
	MaFisEnd()
Return { nValIpi, nValIcm, nValCom, nValPis, nValCof}

Static Function GetB9Custo(cCod,cLocal)
    Local nCusto := 0
    Default cCod := ""
    Default cLocal := "01"

	DbSelectArea("SB9")
	SB9->(DbSetOrder(1))
	If SB9->(DbSeek(xFilial("SB9")+cCod+cLocal+DtoS(SuperGetMV("MV_ULMES",,CtoD("30/09/2021")))))
		nCusto := SB9->B9_CM1
	EndIf


Return nCusto

Static Function GetGGF(cCodProd, cLote)
	Local nRet		:= 0
	Local nCust		:= 0
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
    Local nQtdItens := 0

	Default cCodProd	:= "" 
	Default cLote		:= "" 

	cQuery	:= " SELECT D3_EMISSAO, D3_COD, D3_LOTECTL, D3_OP, SUM(D3_QUANT) D3_QUANT FROM "+RetSqlName("SD3")+" SD3 "+CRLF
	cQuery	+= " WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' "+CRLF
	cQuery	+= " AND D3_COD = '"+cCodProd+"' "+CRLF
    cQuery  += " AND SD3.D3_EMISSAO BETWEEN '"+ DTos(MonthSub(FirstDate(dDatabase),1))+"' AND '"+ DTos(LastDate(MonthSub(FirstDate(dDatabase),1)))+"' "
	cQuery	+= " AND SD3.D3_CF = 'PR0' "+CRLF
	cQuery	+= " AND SD3.D3_ESTORNO != 'S' "+CRLF
	cQuery	+= " AND SD3.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY D3_EMISSAO, D3_COD, D3_LOTECTL, D3_OP "+CRLF 
	cQuery	+= " ORDER BY D3_EMISSAO DESC "
	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

    (cArqTmp)->(DbGoTop())

	While (cArqTmp)->(!Eof())
		nCust := GetCusMod((cArqTmp)->D3_OP, (cArqTmp)->D3_EMISSAO)
		If nCust > 0
            nQtdItens++
			If (cArqTmp)->D3_QUANT != 0
                nRet += (nCust/(cArqTmp)->D3_QUANT)
			EndIf
		EndIf
		(cArqTmp)->(DbSkip())
	EndDo
    (cArqTmp)->(DbCloseArea())
Return nRet / nQtdItens

Static Function GetCusMod(cOp, cEmissao)
	Local nRet		:= 0
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()

	Default cOp 		:= ""
	Default cEmissao	:= ""

	cQuery := " SELECT SUM(D3_CUSTO1) D3_CUSTO1 FROM "+RetSqlName("SD3")+" SD3 "+CRLF
	cQuery += " WHERE SD3.D3_FILIAL = '"+xFilial("SD3")+"' "+CRLF
	cQuery += " AND D3_COD LIKE '%MOD%' "+CRLF
	cQuery += " AND D3_EMISSAO = '"+cEmissao+"' "+CRLF
	cQuery += " AND D3_OP = '"+cOp+"' "+CRLF
	cQuery += " AND SD3.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		nRet := (cArqTmp)->D3_CUSTO1
	EndIf

	(cArqTmp)->(DbCloseArea())

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³VldDtFat		ºAutor  ³Microsiga	     º Data ³  27/02/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação da data de previsão de faturamento				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Static Function VldDtFat()

// 	Local nX			:= 0
// 	Local dDtPrevFat	:= M->C5_FECENT
// 	Local nPosDt		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG" })
// 	Local lRet			:= .T.

// 	For nX := 1 To Len(aCols)
// 		If dDtPrevFat < aCols[nX][nPosDt]
// 			Aviso("Atenção","A data 'Prev. Fat.' não pode ser menor que a data 'Entrega PCP'",{"Ok"},2)
// 			lRet	:= .F.
// 			Exit
// 		EndIf
// 	Next

// 	If !U_PZCVV004(dDtPrevFat)
// 		lRet := .F.
// 	EndIf

// Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³VldArmzCq		ºAutor  ³Microsiga	     º Data ³  29/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação de armazem										  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldArmzCq()

	Local aArea 	:= GetArea()
	Local lRet		:= .T.
	Local cArmCq  	:= SuperGetMv('MV_CQ',,"98")
	Local nPosLoc   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})
	Local nX		:= 0

	For nX := 1 To Len(aCols)
		If Alltrim(aCols[nX][nPosLoc]) == Alltrim(cArmCq)
			lRet := .F.
			Help(" ",1,"ARMZCQ",,GetMv("MV_CQ"),2,15)
			exit
		EndIf
	Next

	RestArea(aArea)
Return lRet
