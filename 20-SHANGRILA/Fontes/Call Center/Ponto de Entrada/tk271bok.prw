#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#Include "Topconn.ch"

//==========================================================================================================================================================
//Nelson Hammel - 21/07/11 - Validação de regras de desconto no TMK

USER FUNCTION TK271BOK()
	Local _x
	Local _nValProm := 0
	Local _nValNorm := 0
	Local nTotalPed := 0
	Local xPVLRITEM := 0 //Adicao Marcos Floridi 24092020
	Local nValMin   := GETMV("MV_XVALMIN")
	//Local PassValid := .F.//Marcos Floridi 13102021
	Private _U := 0
	Private cMsg := ""
	Private nPBrut	:= 0
	Public _xlBlqRegra := .F.		//Pedido serï¿½ bloqueado por Regra Desconto
//================================
//Roda rotina para cancelar orçamentos vencidos!
	xDtOrc 	:= GETMV("MV_DTORC")
	If dDataBase>xDtOrc
		//U_CANCORCS()
		PUTMV("MV_DTORC",dDataBase)
	EndIf
	xPosVrUnit	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VRUNIT"})
	xPDescMax	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESCMAX"})
	xPVLRITEM 	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"})
	xPValDesc 	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_VALDESC"})
	xPosItemD	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESC"})
	xPProduto	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})
	xPMtBlok2	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK2"})
	xPMtBlok3	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK3"})
	xPMtBlok4	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK4"})
	xPosPBrut	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_X_PBRUT"})
	nPBrut		:= 0
	xDescMax	:= 0
	If M->UA_OPER<>"3"
		For _x := 1 to Len(aCols)
			GdFieldPut("UB_DTENTRE",M->UA_ENTREGA,_x)
		Next

		If M->UA_OPER=="2"
			M->UA_OPER:="3"
			M->UA_FLAG:="4"
			Return .T.
		EndIf
		xEstNorte 	:= GETMV("MV_NORTE")
		xValMin   	:= GETMV("MV_XVALMIN")
		xGGF		:= GETMV("MV_XPERCUS")
		xEst		:=Alltrim(Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_EST"))
		xRegra		:=Alltrim(M->UA_X_CODRE)
		xTotA		:=0
		xTotB		:=0
		xTotal		:=0
		xAux1		:=0
		xTab		:=Alltrim(M->UA_TABELA)
		xCondPag	:=M->UA_CONDPG
		xEntrega	:=M->UA_ENTREGA
		xAUXBLOK	:=""
		xValPar		:=0

		If .T.
			_cLogBlq := ""
			_cLog	:= ""
			_aParc := Condicao(10000,M->UA_CONDPG,,DataValida(dDataBase))
			_nDias := 0
			_nPMed := 0
			_nParc := Len(_aParc)

			If xEst == 'SP'
				cRegDA0  := '1'
				cRegSZ0  := '1'
			Else
				If xEst $ xEstNorte
					cRegDA0  := '3'
					cRegSZ0  := '2'
				Else
					cRegDA0  := '2'
					cRegSZ0  := '3'
				EndIf
			EndIf

			For _i := 1 to _nParc
				_nDias += (_aParc[_i,1] - dDataBase)
			Next

			_nPMed := _nDias/_nParc
			If !Empty(M->UA_X_CODRE)
				If M->UA_MTBLOK5=="X"
					M->UA_MTBLOK5:=""
				EndIf
				For _x := 1 to len(acols)
					If !aCols[_x,Len(aHeader)+1]
						_cCod := GdFieldGet("UB_PRODUTO",_x)

						DbSelectArea("SF4")
						DbSetOrder(1)
						DbSeek(xFilial("SF4")+GdFieldGet("UB_TES",_x))

						cQry := "SELECT TOP 1 DA1_TIPPRE,DA1_QTDLOT "
						cQry += "FROM DA1010 DA1 "
						cQry += "WHERE DA1.D_E_L_E_T_<>'*' "
						cQry += "AND DA1_CODTAB='"+M->UA_TABELA+"' "
						_nAlqIpi := 0
						DbSelectArea("SB4")
						DbSetOrder(1)
						If DbSeek(xFilial("SB4")+Padr(Substr(_cCod,1,6),TamSX3("B4_COD")[1]))
							cQry += "AND (DA1_REFGRD='"+Substr(_cCod,1,6)+"' OR DA1_CODPRO='"+_cCod+"') "
							_nAlqIpi := SB4->B4_IPI
						Else
							DbSelectArea("SB1")
							DbSetOrder(1)
							DbSeek(xFilial("SB1")+GdFieldGet("UB_PRODUTO",_x))
							_nAlqIpi := SB1->B1_IPI
							cQry += "AND DA1_CODPRO='"+_cCod+"' "
						EndIf
						cQry += "AND DA1_TPOPER='"+cRegDA0+"' "
						cQry += "AND DA1_QTDLOT>"+cValToChar(GdFieldGet("UB_QUANT",_x))+" "
						cQry += "ORDER BY DA1_QTDLOT "
						memowrite("mta410_da1x.txt",cQry)

						TcQuery cQry New Alias "DA1X"
						DbSelectArea("DA1X")
						DBGoTop()
						If !DA1X->(Eof())
							If DA1X->DA1_TIPPRE=='5'
							//	If GdFieldGet("UB_VALDESC",_x) > 3 0 + IIF(Alltrim(M->UA_CONDPG) == "003",3,0)
								If GdFieldGet("UB_DESC",_x) > 0 + IIF(Alltrim(M->UA_CONDPG) == "003",3,0)
								//Alert(cvaltochar(IIF(Alltrim(M->UA_CONDPG) == "003",3,0)))
									_xlBlqRegra := .T.
									_cLogBlq += "Bloqueio - Item promocional nao pode ter desconto algum. Foi digitado "+cValToChar(GdFieldGet("UB_DESC",_x))+" %. Item: "+GdFieldGet("UB_ITEM",_x)+Chr(13)+Chr(10)
								EndIf
								_nValProm += GdFieldGet("UB_VLRITEM",_x)+GdFieldGet("UB_VALDESC",_x)
								If SF4->F4_IPI == "S"
									_nValProm += GdFieldGet("UB_VLRITEM",_x)*(_nAlqIpi/100)
								EndIf
							Else
								_nValNorm += GdFieldGet("UB_VLRITEM",_x)+GdFieldGet("UB_VALDESC",_x)
								If SF4->F4_IPI == "S"
									_nValNorm += GdFieldGet("UB_VLRITEM",_x)*(_nAlqIpi/100)
								EndIf
							EndIf
						Else
							_xlBlqRegra := .T.
							_cLogBlq += "Bloqueio - Nao encontrado na tabela de preco. Produto: "+_cCod+" Item: "+GdFieldGet("UB_ITEM",_x)+Chr(13)+Chr(10)
						EndIf
						DA1X->(DbCloseArea())
						If SF4->F4_IPI == "S"
							nTotalPed += GdFieldGet("UB_VLRITEM",_x)*(_nAlqIpi/100)
						EndIf
						nTotalPed += GdFieldGet("UB_VLRITEM",_x)
					EndIf
				Next
				_nPrazo	  := 0
				_nValAte  := 0
				_nDescMax := 0
				_nDescAvi := 0

				cQry := "SELECT TOP 1 Z1_VALATE,Z1_DESC1,Z1_DESC6,Z1_PRZMED "
				cQry += "FROM SZ0010 SZ0 "
				cQry += "	INNER JOIN SZ1010 SZ1 ON SZ1.D_E_L_E_T_<>'*' AND Z0_CODIGO=Z1_CODIGO AND Z0_TABELA=Z1_TABPRC AND Z1_REGIAO=Z0_CODREG AND Z1_GRUPO=Z0_GRUPO "
				cQry += "WHERE SZ0.D_E_L_E_T_<>'*' AND Z0_CODIGO='"+M->UA_X_CODRE+"' "
				cQry += "AND Z0_CODREG='"+cRegSZ0+"' AND Z0_TIPOPER='50' AND Z0_GRUPO='0100' "
				cQry += "AND Z0_TABELA='"+M->UA_TABELA+"' "
				cQry += "AND Z1_VALATE>"+cValToChar(_nValNorm)
				cQry += "ORDER BY Z1_VALATE "
				memowrite("mta410_sz1.txt",cQry)
				TcQuery cQry New Alias "SZ1X"
				DbSelectArea("SZ1X")
				DBGoTop()
				If !SZ1X->(Eof())
					//_nPrazo	 := SZ1X->Z1_PRZMED
					_nValAte := SZ1X->Z1_VALATE
					_nDescMax := SZ1X->Z1_DESC1
					_nDescAvi := SZ1X->Z1_DESC6
				Else
					_xlBlqRegra := .T.
					_cLogBlq += "Bloqueio - Nao encontrada regra de desconto. "+Chr(13)+Chr(10)
				EndIf
				SZ1X->(DbCloseArea())

				cQry := "SELECT TOP 1 Z1_VALATE,Z1_DESC1,Z1_DESC6,Z1_PRZMED "
				cQry += "FROM SZ0010 SZ0 "
				cQry += "	INNER JOIN SZ1010 SZ1 ON SZ1.D_E_L_E_T_<>'*' AND Z0_CODIGO=Z1_CODIGO AND Z0_TABELA=Z1_TABPRC AND Z1_REGIAO=Z0_CODREG AND Z1_GRUPO=Z0_GRUPO "
				cQry += "WHERE SZ0.D_E_L_E_T_<>'*' AND Z0_CODIGO='"+M->UA_X_CODRE+"' "
				cQry += "AND Z0_CODREG='"+cRegSZ0+"' AND Z0_TIPOPER='50' AND Z0_GRUPO='0100' "
				cQry += "AND Z0_TABELA='"+M->UA_TABELA+"' "
				cQry += "AND Z1_VALATE>"+cValToChar(_nValNorm+_nValProm)
				cQry += "ORDER BY Z1_VALATE "
				memowrite("mta410_sz1.txt",cQry)
				TcQuery cQry New Alias "SZ1X"
				DbSelectArea("SZ1X")
				DBGoTop()
				If !SZ1X->(Eof())
					_nPrazo	 := SZ1X->Z1_PRZMED
					//_nValAte := SZ1X->Z1_VALATE
					//_nDescMax := SZ1X->Z1_DESC1
					_nDescAvi := SZ1X->Z1_DESC6
				Else
					_xlBlqRegra := .T.
					_cLogBlq += "Bloqueio - Nao encontrada regra de desconto. "+Chr(13)+Chr(10)
				EndIf
				SZ1X->(DbCloseArea())

				_cLog := "Valor Promocional: "+cValToChar(_nValProm)+Chr(13)+Chr(10)
				_cLog += "Valor Tabela: "+cValToChar(_nValNorm)+Chr(13)+Chr(10)
				_cLog += "Valor Bruto: "+cValToChar(_nValNorm+_nValProm)+Chr(13)+Chr(10)
				_cLog += Chr(13)+Chr(10)
				//_cLog += "Prazo Medio da Regra: "+cValToChar(_nPrazo)+Chr(13)+Chr(10)
				//_cLog += "Prazo Pedido: "+cValToChar(_nPMed)+Chr(13)+Chr(10)
				//_cLog += "Valor ate Regra: "+cValToChar(_nValAte)+Chr(13)+Chr(10)
				//_cLog += "Desc Max Regra: "+cValToChar(_nDescMax)+" %"+Chr(13)+Chr(10)
				//_cLog += "Desc Avist Regra: "+cValToChar(_nDescAvi)+Chr(13)+Chr(10)
				//If _nPMed <= 1 .AND. (_nDescMax+_nDescAvi) > 3
				If _nPMed == 0 //.AND. (_nDescMax+_nDescAvi) > 3
					_cLog += Chr(13)+Chr(10)
					_cLog += "Bloqueio - Desc Max Regra + A vista: "+cValToChar(_nDescMax+_nDescAvi)+" %"+Chr(13)+Chr(10)
				Else
//					If SUA->UA_CONDPG = '003'
//						_nDescAvi := 3
//					Else
//						_nDescAvi := 0
//					Endif
					_nDescAvi := 0
				EndIf
				_cLog += Chr(13)+Chr(10)
				For _x := 1 to Len(aCols)
					_U := _x
					If !aCols[_x,Len(aHeader)+1]
						xCustd		:=(Posicione("SB1",1,xFilial("SB1")+aCols[_x,xPProduto],"B1_CUSTD"))
						xVrUnit		:=aCols[_x,xPosVrUnit]
						If (xGGF*xCustd)>(xVrUnit)
							If M->UA_MTBLOK3<>"X"
								_xlBlqRegra := .T.
								_cLogBlq += "Valor do produto abaixo do custo. Orçamento bloqueado"+chr(13)
							EndIf
							xMotBlok:="3"
							Block()
						Else
							If M->UA_MTBLOK3=="X"
								M->UA_MTBLOK3:=""
							EndIf
						EndIf
						If GdFieldGet("UB_DESC",_x) > (_nDescMax+_nDescAvi)
							_xlBlqRegra := .T.
							_cLogBlq += "Bloqueio - Desconto de "+cValToChar(GdFieldGet("UB_DESC",_x))+" % acima da regra de "+cValToChar(_nDescMax)+" %. Item: "+GdFieldGet("UB_ITEM",_x)+Chr(13)+Chr(10)
							xMotBlok:="2"
							Block()
						EndIf
						If GdFieldGet("UB_OPER",_x) # "50"
							_xlBlqRegra := .T.
							_cLogBlq += "Bloqueio - Operacao "+GdFieldGet("UB_OPER",_x)+" gerou bloqueio. Item: "+GdFieldGet("UB_ITEM",_x)+Chr(13)+Chr(10)
							xMotBlok:="2"
							Block()
						EndIf
					EndIf
				Next
				//MsgAlert(cValToChar(_nPMed))
				//MsgAlert(cValToChar(_nPrazo))
				If _nPMed > _nPrazo
					_xlBlqRegra := .T.
					_cLogBlq += "Bloqueio - Prazo medio do pedido de "+Cvaltochar(_nPMed)+" dias superir a regra. "+Cvaltochar(_nPrazo)+Chr(13)+Chr(10)
					xMotBlok:="4"
					Block()
				Else
					If M->UA_MTBLOK4=="X"
						M->UA_MTBLOK4:=""
					EndIf
				EndIf
				If nTotalPed < nValMin
					If M->UA_MTBLOK1<>"X"
						_xlBlqRegra := .T.
						_cLogBlq += "Bloqueio - Pedido minimo de "+cValToChar(nValMin)+" nao atingido"+Chr(13)+Chr(10)
						xMotBlok:="1"
						Block()
					EndIf
				Else
					If M->UA_MTBLOK4=="X"
						M->UA_MTBLOK4:=""
					EndIf
				EndIf
			Else
				_xlBlqRegra := .T.
				_xlBlqPed   := .T.
				_lRet       := .T.    	//grava o pedido com bloqueio de regra - (PE MTA410T)
				_cLogBlq 	+= "Pedido Sem Regra - Bloqueado"
				xMotBlok:="5"
				Block()
			EndIf
			If M->UA_OPER=="2"
				M->UA_OPER:="3"
				M->UA_FLAG:="4"
			Else
				If _xlBlqRegra  
					If !MsgYesNo(_cLog+_cLogBlq,"Confirma gravacao fora da regra?"+M->UA_OPER+'-'+M->UA_FLAG)
						Return .F.
					EndIf
					If M->UA_FLAG # "3" //se não estiver liberado pela adriana
						M->UA_OPER	:="3" //altera pra orçamento novamente
						M->UA_FLAG	:="1" //Altera flag para revalidar (laranja)
					Else //Se estiver liberado pela adriana
						M->UA_1OPER	:="1"
					EndIf
					///M->C5_XBLQ	:= "S"
					M->UA_XLOGBLQ	:= _cLog
					M->UA_XLOGBLQ	+= _cLogBlq
				Else
					///M->C5_XBLQ	:= "N"
					//M->UA_XLOGBLQ	:= "" Realizado a desativação da limpeza do Log 20/07/2021
					Iif (M->UA_OPER$"1",M->UA_FLAG :='3',)
					//Iif (M->UA_1OPER=="1",M->UA_FLAG :='3',)
					//Iif (M->UA_1OPER=="1",M->UA_OPER :='1',)
					//Iif (M->UA_1OPER=="2",M->UA_FLAG :='3',)
					M->UA_IMP:=""
					M->UA_MTBLOK1 	:=""
					M->UA_MTBLOK2 	:=""
					M->UA_MTBLOK3 	:=""
					M->UA_MTBLOK4 	:=""
					M->UA_MTBLOK5 	:=""
					M->UA_MTBLOK6 	:=""
					M->UA_MTBLOK7 	:=""
					xPMtBlok2	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK2"})
					xPMtBlok3	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK3"})
					xPMtBlok4	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK4"})

					For _R:=1 to Len(Acols)
						aCols[_R,xPMtBlok2]:=""
						aCols[_R,xPMtBlok3]:=""
						aCols[_R,xPMtBlok4]:=""
					Next
				EndIf
			Endif
			///////////////////////////////////////////////////////////////////////////////////////////
		Else
			If !Empty(aCols[1,2])
				Iif (xEst=='SP', xRegiao := '1',Iif(xEst $ xEstNorte,xRegiao := '2',xRegiao := '3'))
				If xRegra<>""
					If M->UA_MTBLOK5=="X"
						M->UA_MTBLOK5:=""
					EndIf
					Iif (M->UA_FLAG=="3",,M->UA_FLAG:="2")
					M->UA_IMP:=""
					For _A := 1 TO Len(aCols)
						If acols[_A,Len(aCols[_A])] == .F.
							xTotA	+=aCols[_A,xPVLRITEM]
							xTotB	+=aCols[_A,xPValDesc]
						EndIf
					Next
					xTotal	:=(xTotA+xTotB)
					If xTotal<xValMin
						If M->UA_MTBLOK1<>"X"
							//Alert("Valor de faturamento é menor que o mínimo estabelecido. Orçamento bloqueado")
							cMsg += "Valor de faturamento é menor que o mínimo estabelecido. Orçamento bloqueado"+chr(13)
						EndIf
						xMotBlok:="1"
						Block()
					Else
						If M->UA_MTBLOK1=="X"
							M->UA_MTBLOK1:=""
						EndIf
					EndIf
					For _U := 1 TO Len(aCols)
						If acols[_U,Len(aCols[_U])] == .F.
							xVrUnit		:=aCols[_U,xPosVrUnit]
							xTotItem	:=aCols[_U,xPVLRITEM]+aCols[_U,xPValDesc]
							xDescItem	:=aCols[_U,xPosItemD]
							xVlrItem	:=aCols[_U,xPVLRITEM]
							xGrupo		:=Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[_U,xPProduto],"B1_GRUPO"))
							xCustd		:=(Posicione("SB1",1,xFilial("SB1")+aCols[_U,xPProduto],"B1_CUSTD"))
							nPBrut		:=nPBrut +aCols[_U,xPosPBrut]

							cQuery := "SELECT SZ0.*, SZ1.* "
							cQuery += "FROM "
							cQuery += RetSqlName("SZ1")+" SZ1, "
							cQuery += RetSqlName("SZ0")+" SZ0 "
							cQuery += "WHERE "
							cQuery += "SZ0.Z0_FILIAL = '"+xFilial("SZ0")+"' AND "
							cQuery += "SZ1.Z1_FILIAL = '"+xFilial("SZ1")+"' AND "
							cQuery += "SZ0.Z0_CODIGO = '" + Alltrim(xRegra)  + "' AND "
							cQuery += "SZ0.Z0_GRUPO  = '" + Alltrim(xGrupo)  + "' AND "
							cQuery += "SZ0.Z0_CODREG = '" + Alltrim(xRegiao) + "' AND "
							cQuery += "SZ0.Z0_TABELA = '" + Alltrim(xTab)    + "' AND "
							cQuery += "SZ1.Z1_CODIGO = SZ0.Z0_CODIGO AND "
							cQuery += "SZ1.Z1_GRUPO  = SZ0.Z0_GRUPO  AND "
							cQuery += "SZ1.Z1_REGIAO = SZ0.Z0_CODREG AND "
							cQuery += "SZ1.Z1_TABPRC = SZ0.Z0_TABELA AND "
							cQuery += "SZ0.Z0_ATIVO  = '1' AND "
							cQuery += "SZ0.D_E_L_E_T_= ' ' AND "
							cQuery += "SZ1.D_E_L_E_T_= ' ' "
							cQuery += "ORDER BY Z1_ITEM "

							cQuery := ChangeQuery(cQuery)
							MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TABSZ1', .F., .T.)},"Aguarde")

							DbSelectArea("TABSZ1")
							DbGoTop()
//==========================================================================================================================================================
//Caso não encontre item na tabela SZ1, interrompe processamento
							If Eof()
								Alert("Regra de desconto não cadastrada")
								DbCloseArea("TABSZ1")
								Return(.F.)
							EndIf
							While ! Eof() .And. xAux1=0
								If TABSZ1->Z1_VALATE >  xTotal
									xDescICM	:=TABSZ1->Z1_DESC5
									xDescCom	:=TABSZ1->Z1_DESC1
									xDescCond	:=TABSZ1->Z1_DESC6
									xCondRegra	:=TABSZ1->Z1_PRZMED
									xAux1:=1
								EndIf
								DbSkip()
							EndDo()
							xAux1:=0
							DbCloseArea("TABSZ1")
							//===========================================================================================================================================================
							//Desconto Dif. ICMS
							xValPar		:= (xTotItem-((xTotItem*xDescICM)/100))
							//===========================================================================================================================================================
							//Desconto Comercial
							//If xTab =="1N" VER SE É ISSO MESMO
							xValPar	:= (xValPar-((xValPar*xDescCom)/100))
							//EndIf
							//===========================================================================================================================================================
							//Desconto Condição de Pagto
							If xCondPag $ "003/007/027/031"
								xValPar		:= (xValPar-((xValPar*xDescCond)/100))
							EndIf
							//===========================================================================================================================================================
							//Validação do desconto
							Iif (xValPar>0,xDescMax := (100-((100*xValPar)/xTotItem)),xDescMax :=0)
							If xDescMax<xDescItem
								If M->UA_MTBLOK2<>"X"
									//Alert("Desconto concedido acima do máximo permitido. Orçamento bloqueado")
									cMsg += "Desconto concedido acima do máximo permitido. Orçamento bloqueado"+chr(13)
								EndIf
								xMotBlok:="2"
								Block()
							Else
								If M->UA_MTBLOK2=="X"
									M->UA_MTBLOK2:=""
								EndIf
							EndIf
							//===========================================================================================================================================================
							//Validação de custo do produto
							If (xGGF*xCustd)>(xVrUnit)
								If M->UA_MTBLOK3<>"X"
									//Alert("Valor do produto abaixo do custo. Orçamento bloqueado")
									cMsg += "Valor do produto abaixo do custo. Orçamento bloqueado"+chr(13)
								EndIf
								xMotBlok:="3"
								Block()
							Else
								If M->UA_MTBLOK3=="X"
									M->UA_MTBLOK3:=""
								EndIf
							EndIf
							//===========================================================================================================================================================
							//Validação de prazo médio
							If xCondRegra>0
								If Prazo(xCondPag)>xCondRegra
									If M->UA_MTBLOK4<>"X"
										cMsg += "Prazo médio da condição de pagamento maior que o estabelecido. Orçamento bloqueado"+chr(13)
									EndIf
									xMotBlok:="4"
									Block()
								Else
									If M->UA_MTBLOK4=="X"
										M->UA_MTBLOK4:=""
									EndIf
								EndIf
							EndIf
						EndIf
					Next
					//===========================================================================================================================================================
					//Validação de regra não informada
				Else
					If M->UA_MTBLOK5<>"X"
						//Alert("Condição não informada. Orçamento bloqueado")
						cMsg += "Condição não informada. Orçamento bloqueado"+chr(13)
					EndIf
					xMotBlok:="5"
					Block()
				EndIf
				//===========================================================================================================================================================
				//Validação do desconto
				If M->UA_OPER=="1" .Or. M->UA_OPER=="2"
					If M->UA_FLAG=="1"
						Alert("Orçamento bloqueado para faturamento. Deverá ser liberado pelo responsável")
						Return(.F.)
					ElseIf M->UA_FLAG=="3"
						//Alert("Orçamento fora de regra autorizado pelo responsável")
						cMsg += "Orçamento fora de regra autorizado pelo responsável"+chr(13)
					EndIf
				EndIf
				//===========================================================================================================================================================
				//Validação de condição de pagamento 999
				If !Empty(cMsg)
					MsgBox(cMsg,"ATENCAO","Info")
				Endif
				//===========================================================================================================================================================
				//Envia Email quando bloqueado
				If M->UA_FLAG=="1"
					U_TMKMAIL()
				EndIf
				//===========================================================================================================================================================
				//Grava desconto maximo na tabela
				For L := 1 TO Len(aCols)
					aCols[L,xPDescMax]:=xDescMax
				Next
			EndIf
		EndIf
		If M->UA_CONDPG=="999"
			IF xTotA == 0
				For _A := 1 TO Len(aCols)
					If acols[_A,Len(aCols[_A])] == .F.
						xTotA	+= GdFieldGet("UB_VLRITEM",_A) //aCols[_A,xPVLRITEM]
					EndIf
				Next
			EndIf
			xSumParc:=(M->UA_PARC1+M->UA_PARC2+M->UA_PARC3+M->UA_PARC4)
			If xTotA<>xSumParc
				Alert("Valor total de parcelas não confere com valor total do orçamento!")
				Return(.F.)
			EndIf
		EndIf
	Else
		If Empty(aCols[1,2])
			M->UA_FLAG := "2"
		EndIf
	EndIf
	//===========================================================================================================================================================
	//Limpa dados de proxima chamada conforme retorno da pergunta
	If M->UA_OPER<>"1" .And. Alltrim(DtoS(M->UA_PROXLIG))<>""
		If !MsgYesNo("Confirma agendamento de ligação para esse contato?")
			M->UA_PROXLIG	:=StoD("")
			M->UA_HRPEND	:=""
		EndIf
	EndIf
	M->UA_X_PBRUT	:= nPBrut
Return(.T.)
//===========================================================================================================================================================
//Procedimentos para quando atendimento bloqueado

//1-Valor total menor que o mínimo permitido
//2-Desconto concedido fora da regra
//3-Valor venda menor que custo
//4-Valor abaixo do prazo médio
//5-Regra de desconto não informada

Static Function Block()
	xPMtBlok2	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK2"})
	xPMtBlok3	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK3"})
	xPMtBlok4	:= aScan(aHeader,{|x| AllTrim(x[2])=="UB_MTBLOK4"})

	If !M->UA_FLAG$"3"
		M->UA_OPER		:= "3"
		M->UA_FLAG		:="1"
		Iif (M->UA_1OPER=="2",M->UA_IMP:="N",)
		&("M->UA_MTBLOK"+xMotBlok):="X"

		If xMotBlok $ "2"
			aCols[_U,xPMtBlok2]:="X"
		ElseIf xMotBlok $ "3"
			aCols[_U,xPMtBlok3]:="X"
		ElseIf xMotBlok $ "4"
			aCols[_U,xPMtBlok4]:="X"
		EndIf
//GDFIELDPUT(&("UB_MTBLOK"+xMotBlok),"X",_U)
	EndIf
Return

//===========================================================================================================================================================
//Retorna prazo médio


Static Function Prazo(CP)

	_aParc := Condicao(10000,CP,,dDataBase)
	_nDias := 0
	_nPMed := 0
	_nParc := Len(_aParc)

	For _i := 1 to _nParc
		_nDias += (_aParc[_i,1] - dDataBase)
	Next

	_nPMed := _nDias/_nParc

Return(_nPMed)


Return(.T.)

