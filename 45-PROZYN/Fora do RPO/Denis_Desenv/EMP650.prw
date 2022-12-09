#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ EMP650   ³ Autor ³ Adriano Leonardo    ³ Data ³ 07/07/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na geração de empenhos, utilizado para    º±±
±±ºDesc.     ³ manipular as quantidades de acordo com a atividade enzimá- º±±
±±ºDesc.     ³ tica do produto e forçar lote quando a chamada for da roti-º±±
±±ºDesc.     ³ na RPCPE003.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function EMP650()

	Local _aSavArea := GetArea()
	Local _nCont	:= 1
	Local _nItens 	:= 1
	Local _nBkpIt	:= 1
	Local nA		:= 0
	Local _cProduto	:= ""
	Local _nQuant	:= ""
	Local _cSequen	:= ""
	Local _nQtdTot	:= 0
	Local _nQtdAux  := 0
	Local _cLote    := ""
	Local _cPrd     := ""    
	Local _lAbort2  := .F.    
	Local _nTmp,_nAux    
	Local _cAlias   := GetNextAlias()
	Local _cAliasDil := GetNextAlias()    
	Local _cAliasAlt := GetNextAlias()
	Local cAliasDil2 	:= "" 
	Local _cQryDil2 	:= ""	
	Local cProdProc		:= ""


	Private  _cRotina	:= "EMP650"                                 
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posicões do aCols para manipulação                                                                                      ³
	//³ aCols[n,x] - Onde o n e o  número da linha  e x pode ser:                                                               ³
	//³ [01] Código do Produto a ser empenhado                                                                                  ³
	//³ [02] Quantidade do empenho                                                                                              ³
	//³ [03] Almoxarifado do empenho                                                                                            ³
	//³ [04] Sequência do componente na estrutura (Campo G1_TRT)                                                                ³
	//³ [05] Sub-Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade do tipo "S")      ³
	//³ [06] Lote utilizado no empenho (Somente deve ser preenchido se o produto utilizar rastreabilidade)                      ³
	//³ [07] Data de validade do Lote (Somente deve ser preenchido se o  produto utilizar rastreabilidade)                      ³
	//³ [08] Localização utilizada no empenho (Somente deve ser preenchido se o produto utilizar controle de localização física)³
	//³ [09] Número de Série (Somente deve ser preenchido se o produto utilizar controle de localização física)                 ³
	//³ [10] 1a. Unidade de Medida do Produto                                                                                   ³
	//³ [11] Quantidade do Empenho na 2a. Unidade de Medida                                                                     ³
	//³ [12] 2a. Unidade de Medida do Produto                                                                                   ³
	//³ [13] Coluna com valor lógico que indica se a linha está deletada (.T.) ou não (.F.)                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	If FunName() == "RPCPE004" //Rotina de reprocessamento de produtos

		If Type("_aEmp650P")=="A"

			_aColsAux := {}

			For _nCont := 1 To Len(_aEmp650P)

				If Len(aCols)==0                   
					Exit
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ignorar produtos do tipo MOD ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AllTrim(Substr(_aEmp650P[_nCont,01],1,3)) == "MOD"
					Loop
				EndIf

				_aColsIte := aClone(aCols[1])

				If _nCont == 1
					_nPosProd		:= 2
					_aColsIte[01]	:= _aEmp650P[_nCont,02]
					_aColsIte[02]	:= _aEmp650P[_nCont,05]
					_aColsIte[03] 	:= _aEmp650P[_nCont,03]
					_aColsIte[06] 	:= _aEmp650P[_nCont,04]
					_aColsIte[07] 	:= _aEmp650P[_nCont,06]
				Else
					_nPosProd		:= 1
					_aColsIte[01] 	:= _aEmp650P[_nCont,01]
					_aColsIte[02] 	:= _aEmp650P[_nCont,02]

					If _aEmp650P[_nCont,03] == '2' //Somente considera enzima

						_nAtivida	:= _aEmp650P[_nCont,04] * _aEmp650P[_nCont,02]

						//Faço uma consulta no banco de dados para retornar todos os lotes disponíveis do enzima para empenho na produção, considerando o conceito FEFO (First Expired First Out)
						_cQuery := "SELECT B8_PRODUTO,B8_DTVALID, round(B8_SALDO-B8_EMPENHO-B8_QACLASS,5) B8_SLDDISP, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE, B8_LOTEFOR, Z1_ATIVIDA, Z1_UNIDADE, ISNULL((SELECT B1_BASE FROM " + RetSqlName("SB1") + " SB1 WHERE SB1.D_E_L_E_T_=''  AND SB1.B1_FILIAL='" + xFilial("SB1") + "' AND SB1.B1_COD='" + SC2->C2_PRODUTO + "'),0) B1_BASE FROM " + RetSqlName("SB8") + " SB8 "
						_cQuery += "INNER JOIN " + RetSqlName("SZ1") + " SZ1 "
						_cQuery += "ON SB8.D_E_L_E_T_='' "
						_cQuery += "AND SB8.B8_FILIAL='" + xFilial("SB8") + "' "
						_cQuery += "AND SZ1.D_E_L_E_T_='' "
						_cQuery += "AND SZ1.Z1_FILIAL='" + xFilial("SZ1") + "' "
						_cQuery += "AND SB8.B8_PRODUTO=SZ1.Z1_PRODUTO "
						_cQuery += "AND SB8.B8_LOCAL=SZ1.Z1_LOCAL "
						_cQuery += "AND SB8.B8_LOTECTL=SZ1.Z1_LOTECTL "
						_cQuery += "AND SB8.B8_NUMLOTE=SZ1.Z1_NUMLOTE "
						_cQuery += "AND SB8.B8_PRODUTO='" + _aEmp650P[_nCont,01] + "' "
						//						_cQuery += "AND SB8.B8_LOCAL<>'98' "
						_cQuery += "AND SB8.B8_LOCAL NOT IN ('98','00','92','10') "
						_cQuery += "AND SB8.B8_DTVALID>='" + DTOS(dDataBase) + "' "
						_cQuery += "WHERE round(B8_SALDO-B8_EMPENHO-B8_QACLASS,5)>0 "
						_cQuery += "ORDER BY B8_DTVALID,B8_LOTECTL "

						//_cAlias := GetNextAlias()

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)

						//dbSelectArea(_cAlias)
						//dbSetOrder(0)

						_nPercAtiv	:= 0

						if _aEmp650P[_nCont,04]<=(_cAlias)->Z1_ATIVIDA

							// FA		
							While (_cAlias)->(!EOF())
								_nQtdAux := round(((_aEmp650P[_nCont,04]/(_cAlias)->Z1_ATIVIDA)*_aEmp650P[_nCont,02])*(IIF(_nPercAtiv==0,1,(100-_nPercAtiv)/100)),5)

								// LFSS - 10-08-2017 - Captura de dados de inconsistencia

								If _nQtdAux > 10  

									_cPrd  := 	(_cAlias)->B8_PRODUTO
									_cLote :=   (_cAlias)->B8_LOTECTL                                                   

								Endif 

								If _nPercAtiv <> 0
									_aColsAux := aClone(_aColsIte)
									AAdd(aCols,_aColsAux)
									_nItens := Len(aCols)
								EndIf

								//							_nQtdAux := ((_aEmp650P[_nCont,04]/(_cAlias)->Z1_ATIVIDA)*_aEmp650P[_nCont,02])*(IIF((100-_nPercAtiv)/100==0,1,(100-_nPercAtiv)/100))

								If (_cAlias)->B8_SLDDISP >= _nQtdAux
									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"		})] := _nQtdAux
									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"	})]	:= (_cAlias)->B8_LOTECTL
									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= STOD((_cAlias)->B8_DTVALID)

									If !Empty((_cAlias)->B8_NUMLOTE)
										_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_NUMLOTE"	})]	:= (_cAlias)->B8_NUMLOTE
									EndIf

									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= STOD((_cAlias)->B8_DTVALID)
									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"		})]	:= (_cAlias)->B8_LOCAL
									_aColsIte[Len(_aColsIte)] := .F. //Flag para linha não deletada no aCols


									//Verifico o array de linhas deletadas, caso a linha em questão esteja deletada, restauro a mesma
									If aScan(aColsDele,_nItens) > 0

										_nPosDel := aScan(aColsDele,_nItens)

										_aDelAux := aClone(aColsDele)

										aColsDele := {}
										For _nCont := 1 To Len(_aDelAux)
											If _nCont <> _nPosDel
												aAdd(aColsDele,_aDelAux[_nCont])
											EndIf
										Next
									EndIf        

									Exit
								Else
									// LFSS - 10-08-2017 - 182 - Saldo de estoque
									_lAbort2 := ShowErr( (_cAlias)->B8_PRODUTO,(_cAlias)->B8_LOTECTL,_nQtdAux,(_cAlias)->B8_SLDDISP,1 )  
									// FA
									//Armazeno o percentual do enzima ainda a ser empenhado
									//_nPercAtiv -= (((SC2->C2_QUANT * (_cAlias)->B8_SLDDISP))/_nQtdAux) 

									//_nPercAtiv := ((_cAlias)->B8_SLDDISP/ _nQtdAux ) * 100
									_nPercAtiv += ((_cAlias)->Z1_ATIVIDA * (_cAlias)->B8_SLDDISP) / _nAtivida * 100

									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"		})] := round((_cAlias)->B8_SLDDISP,5)
									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"	})]	:= (_cAlias)->B8_LOTECTL
									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= STOD((_cAlias)->B8_DTVALID)								

									If !Empty((_cAlias)->B8_NUMLOTE)
										aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_NUMLOTE"	})]	:= (_cAlias)->B8_NUMLOTE
									EndIf

									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= STOD((_cAlias)->B8_DTVALID)
									_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"		})]	:= (_cAlias)->B8_LOCAL
									_aColsIte[Len(aCols)] := .F. //Flag para linha não deletada no aCols

									//Verifico o array de linhas deletadas, caso a linha em questão esteja deletada, restauro a mesma
									If aScan(aColsDele,_nItens) > 0

										_nPosDel := aScan(aColsDele,_nItens)

										_aDelAux := aClone(aColsDele)

										aColsDele := {}
										For _nCont := 1 To Len(_aDelAux)
											If _nCont <> _nPosDel
												aAdd(aColsDele,_aDelAux[_nCont])
											EndIf
										Next
									EndIf

									_nQtdAux -= round((_cAlias)->B8_SLDDISP,5)
								EndIf   
								// LFSS - 14-08-2017
								If _nQtdAux > 1   

									_cPrd  := 	(_cAlias)->B8_PRODUTO
									_cLote :=   (_cAlias)->B8_LOTECTL                                                   

								Endif               
								// FA

								//dbSelectArea(_cAlias)
								//dbSetOrder(0)
								(_cAlias)->(DbSkip())

							EndDo

							//Atualizo a descrição do produto no empenho
							_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "B1_DESC"	})] := Posicione("SB1",1,xFilial("SB1")+_aEmp650P[_nCont,_nPosProd],"B1_DESC"	)
							_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"	})] := Posicione("SB1",1,xFilial("SB1")+_aEmp650P[_nCont,_nPosProd],"B1_LOCPAD"	)

							AAdd(_aColsAux,aClone(_aColsIte)) 
						Else      
							_lAbort2 := .t.

						Endif // Lfss

						If Select(_cAlias) > 0
							(_cAlias)->(dbCloseArea())
						EndIf

					Else
						_cQry := "SELECT B8_PRODUTO,B8_DTVALID, (B8_SALDO-B8_EMPENHO-B8_QACLASS) B8_SLDDISP, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE FROM " + RetSqlName("SB8") + " SB8 "
						_cQry += "WHERE SB8.D_E_L_E_T_='' "
						_cQry += "AND SB8.B8_FILIAL='" + xFilial("SB8") + "' "
						_cQry += "AND SB8.B8_PRODUTO='" + _aEmp650P[_nCont,01] + "' "
						_cQry += "AND (B8_SALDO-B8_EMPENHO-B8_QACLASS)>0 "
						//_cQry += "AND SB8.B8_LOCAL<>'98' "  
						_cQry += "AND SB8.B8_LOCAL NOT IN ('98','00','92','10') "
						_cQry += "AND SB8.B8_DTVALID>='" + DTOS(dDataBase) + "' "
						_cQry += "ORDER BY B8_DTVALID,B8_LOTECTL "

						//_cAlias := GetNextAlias()

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAlias,.T.,.F.)

						//dbSelectArea(_cAlias)
						//dbSetOrder(0)

						_nSldAux := _aEmp650P[_nCont,02]

						While (_cAlias)->(!EOF()) .And. _nSldAux > 0


							If _nSldAux <= (_cAlias)->B8_SLDDISP
								_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"		})] := _nSldAux
								_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"	})]	:= (_cAlias)->B8_LOTECTL
								_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= STOD((_cAlias)->B8_DTVALID)

								_nSldAux := 0
							Else
								_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"		})] := (_cAlias)->B8_SLDDISP
								_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"	})]	:= (_cAlias)->B8_LOTECTL
								_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= STOD((_cAlias)->B8_DTVALID)								

								_nSldAux -= (_cAlias)->B8_SLDDISP
							EndIf  


							//Atualizo a descrição do produto no empenho
							_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "B1_DESC"	})] := Posicione("SB1",1,xFilial("SB1")+_aEmp650P[_nCont,_nPosProd],"B1_DESC"	)
							_aColsIte[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"	})] := Posicione("SB1",1,xFilial("SB1")+_aEmp650P[_nCont,_nPosProd],"B1_LOCPAD"	)

							AAdd(_aColsAux,aClone(_aColsIte))

							//dbSelectArea(_cAlias)

							(_cAlias)->(dbSkip())

						EndDo

						//dbSelectArea(_cAlias)
						If Select(_cAlias) > 0
							(_cAlias)->(dbCloseArea())
						EndIf

					EndIf
				EndIf				
			Next
		EndIf

		aCols 		:= aClone(_aColsAux)
		aColsDele	:= {}

		//Segunda etapa, cálculo da quantidade total da OP
		For _nItens := 1 To Len(aCols)

			_cProduto	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})]
			_nQuant		:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})]
			_cSequen	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_TRT"	})]

			// tratar produto alternativo - Daniel 09/08/2018   

			_cQryalt := "SELECT  TOP 1 GI_PRODORI, GI_PRODALT, G1_TIPO, G1_QUANT, G1_ATIVIDA FROM " + RetSqlName("SGI") + " GI "
			_cQryalt += "INNER JOIN " + RetSqlName("SG1") + " G1 ON GI_PRODORI = G1_COMP AND G1.D_E_L_E_T_<> '*' "
			_cQryalt += "WHERE GI_PRODALT = '"+_cProduto+"' AND G1_COD = '"+SC2->C2_PRODUTO+"' AND GI.D_E_L_E_T_<> '*' "

			If select (_cAliasAlt) > 0                           
				(_cAliasAlt)->(dbCloseArea()) 
			EndIf 

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryalt),_cAliasAlt,.T.,.F.)


			IF 	(_cAliasAlt)->GI_PRODORI <> " "


				_cProduto :=  	(_cAliasAlt)->GI_PRODORI
				_cTipo:= 		(_cAliasAlt)->G1_TIPO
			Endif


			dbSelectArea("SG1")
			dbSetOrder(1) //Filial + Produto + Componente + Sequencia
			If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+_cProduto+_cSequen)
				If !(SG1->G1_TIPO $ '1/3/5') //Somente considera enzima ou ingrediente
					_nQtdTot += _nQuant
				EndIf
			Else
				_nQtdTot += _nQuant
			EndIf
		Next

		//Terceira etapa, cálculo do diluente
		For _nItens := 1 To Len(aCols)

			_cProduto	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})]
			_nQuant		:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})]
			_cSequen	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_TRT"	})]


			// tratar produto alternativo - Daniel 09/08/2018   

			_cQryalt := "SELECT  TOP 1 GI_PRODORI, GI_PRODALT, G1_TIPO, G1_QUANT, G1_ATIVIDA FROM " + RetSqlName("SGI") + " GI "
			_cQryalt += "INNER JOIN " + RetSqlName("SG1") + " G1 ON GI_PRODORI = G1_COMP AND G1.D_E_L_E_T_<> '*' "
			_cQryalt += "WHERE GI_PRODALT = '"+_cProduto+"' AND G1_COD = '"+SC2->C2_PRODUTO+"' AND GI.D_E_L_E_T_<> '*' "

			If select (_cAliasAlt) > 0                           
				(_cAliasAlt)->(dbCloseArea()) 
			EndIf 

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryalt),_cAliasAlt,.T.,.F.)


			IF 	(_cAliasAlt)->GI_PRODORI <> " "


				_cProduto :=  	(_cAliasAlt)->GI_PRODORI
				_cTipo:= 		(_cAliasAlt)->G1_TIPO
			Endif


			dbSelectArea("SG1")
			dbSetOrder(1) //Filial + Produto + Componente + Sequencia
			If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+_cProduto+_cSequen)
				If SG1->G1_TIPO == '1' //Diluente

					//Percentual de rateio do diluente (para casos em que há mais de um diluente na fórmula)
					_nPercDil := SG1->G1_PERCDIL

					If _nPercDil == 0
						_nPercDil := 100
					EndIf

					_nPercDil := (_nPercDil/100)

					aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := ((SC2->C2_QUANT - _nQtdTot) * _nPercDil)
					If aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] < 0
						aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := 0
						// LFSS - 14/08/2017 - 182 - Cálculo de diluente Negativando 						
						_lAbort2 := Showerr(SG1->G1_COMP,_cLote,_nQtdAux,(_cAlias)->B8_SLDDISP,2 )   
						// FA
						//EstonarOP()
						//Return()
					EndIf
				EndIf
			EndIf
		Next

		Return()
	EndIf

	//Rotina que Limpa os Empenhos automáticos duplicados - CR-Valdimari Martins - 09/02/2017
	_nTamAcols := Len(aCols) //Preservo o tamanho original do aCols, porque as quebras de lote, geraram itens adicionais, mas não interferirão no cálculo

	_aColsTmp := {}     
	_aColsDel := {}
	_aCols2   := {}

	For _nCont := 1 To _nTamAcols       
		_cProduto	:= aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})]
		_cSequen	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_TRT"	})]
		if _nCont == 1
			aadd(_aColsTmp,_CProduto)
		else  
			_achou := .F.
			For _nTmp := 1 To Len(_aColsTmp)
				If _aColsTmp[_nTmp] == _cProduto
					_achou := .T.   

					// tratar produto alternativo - Daniel 09/08/2018   

					_cQryalt := "SELECT  TOP 1 GI_PRODORI, GI_PRODALT, G1_TIPO, G1_QUANT, G1_ATIVIDA FROM " + RetSqlName("SGI") + " GI "
					_cQryalt += "INNER JOIN " + RetSqlName("SG1") + " G1 ON GI_PRODORI = G1_COMP AND G1.D_E_L_E_T_<> '*' "
					_cQryalt += "WHERE GI_PRODALT = '"+_cProduto+"' AND G1_COD = '"+SC2->C2_PRODUTO+"' AND GI.D_E_L_E_T_<> '*' "

					If select (_cAliasAlt) > 0                           
						(_cAliasAlt)->(dbCloseArea()) 
					EndIf 

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryalt),_cAliasAlt,.T.,.F.)


					IF 	(_cAliasAlt)->GI_PRODORI <> " "


						_cProduto :=  	(_cAliasAlt)->GI_PRODORI
						_cTipo:= 		(_cAliasAlt)->G1_TIPO
					Endif

					dbSelectArea("SG1")
					dbSetOrder(1) //Filial + Produto + Componente + Sequencia
					If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+_cProduto+_cSequen)
						If SG1->G1_TIPO $ '125'
							aadd(_aColsDel,_nCont)
						Endif
					Endif
				Else	
					_achou := .F.
				EndIf
			Next
			if _Achou == .F.
				aadd(_aColsTmp,_CProduto)
			Endif
		Endif	
	Next

	For _nCont := 1 To Len(aCols)
		If aScan(_aColsDel,_nCont)==0
			AAdd(_aCols2,aClone(aCols[_nCont]))
		EndIf
	Next

	aCols := aClone(_aCols2)

	//Primeira etapa, cálculo da atividade enzimática
	_nTamAcols := Len(aCols)

	For _nItens := 1 To _nTamAcols

		_nBkpIt := _nItens

		_cProduto	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})]
		_nQuant		:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})]
		_cSequen	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_TRT"	})]


		// tratar produto alternativo - Daniel 09/08/2018

		// tratar produto alternativo - Daniel 09/08/2018   

		_cQryalt := "SELECT  TOP 1 GI_PRODORI, GI_PRODALT, G1_TIPO, G1_QUANT, G1_ATIVIDA FROM " + RetSqlName("SGI") + " GI "
		_cQryalt += "INNER JOIN " + RetSqlName("SG1") + " G1 ON GI_PRODORI = G1_COMP AND G1.D_E_L_E_T_<> '*' "
		_cQryalt += "WHERE GI_PRODALT = '"+_cProduto+"' AND G1_COD = '"+SC2->C2_PRODUTO+"' AND GI.D_E_L_E_T_<> '*' "

		If select (_cAliasAlt) > 0                           
			(_cAliasAlt)->(dbCloseArea()) 
		EndIf 

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryalt),_cAliasAlt,.T.,.F.)


		IF 	(_cAliasAlt)->GI_PRODORI <> " "


			_cProduto :=  	(_cAliasAlt)->GI_PRODORI
			_cTipo:= 		(_cAliasAlt)->G1_TIPO
		Endif



		dbSelectArea("SG1")
		dbSetOrder(1) //Filial + Produto + Componente + Sequencia
		If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+_cProduto+_cSequen) 
			If SG1->G1_TIPO == '2' //Somente considera enzima

				_nAtivida	:= SG1->G1_ATIVIDA * SC2->C2_QUANT

				//Faço uma consulta no banco de dados para retornar todos os lotes disponíveis do enzima para empenho na produção, considerando o conceito FEFO (First Expired First Out)
				_cQuery := "SELECT B8_PRODUTO,B8_DTVALID, round(B8_SALDO-B8_EMPENHO-B8_QACLASS,5) B8_SLDDISP, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE, B8_LOTEFOR, Z1_ATIVIDA, Z1_UNIDADE, ISNULL((SELECT B1_BASE FROM " + RetSqlName("SB1") + " SB1 WHERE SB1.D_E_L_E_T_=''  AND SB1.B1_FILIAL='" + xFilial("SB1") + "' AND SB1.B1_COD='" + SC2->C2_PRODUTO + "'),0) B1_BASE FROM " + RetSqlName("SB8") + " SB8 "
				_cQuery += "INNER JOIN " + RetSqlName("SZ1") + " SZ1 "
				_cQuery += "ON SB8.D_E_L_E_T_='' "
				_cQuery += "AND SB8.B8_FILIAL='" + xFilial("SB8") + "' "
				_cQuery += "AND SZ1.D_E_L_E_T_='' "
				//_cQuery += "AND SB8.B8_LOCAL<>'98' "
				_cQuery += "AND SB8.B8_LOCAL NOT IN ('98','00','92','10') "
				_cQuery += "AND SZ1.Z1_FILIAL='" + xFilial("SZ1") + "' "
				_cQuery += "AND SB8.B8_PRODUTO=SZ1.Z1_PRODUTO "
				_cQuery += "AND SB8.B8_LOCAL=SZ1.Z1_LOCAL "
				_cQuery += "AND SB8.B8_LOTECTL=SZ1.Z1_LOTECTL "
				_cQuery += "AND SB8.B8_NUMLOTE=SZ1.Z1_NUMLOTE "

				IF 	(_cAliasAlt)->GI_PRODORI <> " "

					_cQuery += "AND SB8.B8_PRODUTO='" + (_cAliasAlt)->GI_PRODALT + "' "

				Else
					_cQuery += "AND SB8.B8_PRODUTO='" + _cProduto + "' "

				Endif

				_cQuery += "WHERE round(B8_SALDO-B8_EMPENHO-B8_QACLASS,5)>0.00000 "
				_cQuery += "AND SB8.B8_DTVALID>='" + DTOS(dDataBase) + "' "
				_cQuery += "ORDER BY B8_DTVALID,B8_LOTECTL "


				If select (_cAlias) > 0                           
					(_cAlias)->(dbCloseArea()) 
				EndIf 

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)


				_nPercAtiv	:= 0          
				if SG1->G1_ATIVIDA<=(_cAlias)->Z1_ATIVIDA

					//FA
					While (_cAlias)->(!EOF()) 
						_nQtdAux := round(((SG1->G1_ATIVIDA/(_cAlias)->Z1_ATIVIDA)*SC2->C2_QUANT)*(IIF(_nPercAtiv==0,1,(100-_nPercAtiv)/100)),5)

						// LFSS - 14-08-2017 - 182 
						If _nQtdAux > 1   

							_cPrd  := 	(_cAlias)->B8_PRODUTO
							_cLote :=   (_cAlias)->B8_LOTECTL                                                   

						Endif  

						If _nPercAtiv <> 0
							_aColsAux := aClone(aCols[_nItens])
							AAdd(aCols,_aColsAux)
							_nItens := Len(aCols)  
							if _nPercAtiv>=(_cAlias)->Z1_ATIVIDA
								_nQtdAux := ((_nPercAtiv/(_cAlias)->Z1_ATIVIDA)*SC2->C2_QUANT)
								Alert('Atividade do Lote menor que atividade calculada !!' )
							Endif 

							// LFSS - 10-08-2017 - Captura de dados de inconsistencia
							If _nQtdAux > 1   

								_cPrd  := 	(_cAlias)->B8_PRODUTO
								_cLote :=   (_cAlias)->B8_LOTECTL                                                   

							Endif 
							// FA	
						EndIf


						//Verifico se o array foi criado no fonte RPCPE003
						If Type("_aEmp650")=="A"
							//Verifico se o array tem algum lote a ser priorizado no empenho
							If Len(_aEmp650)>0
								//Verifico se a OP em questão existe no array
								If aScan(_aEmp650,{|x|Alltrim(x[1]) == AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))})>0
									//Verifico se o componente corrente possui prioridade de lote para essa ordem de produção
									If _aEmp650[aScan(_aEmp650,{|x|Alltrim(x[1]) == AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))}),1] == SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) .And. _aEmp650[aScan(_aEmp650,{|x|Alltrim(x[1]) == AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))}),2] == SG1->G1_COMP

										//Dpefino o lote riorizado no empenho
										aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"		})] := _aEmp650[aScan(_aEmp650,{|x|Alltrim(x[1]) == AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))}),5]
										aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"	})]	:= _aEmp650[aScan(_aEmp650,{|x|Alltrim(x[1]) == AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))}),4]
										aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= _aEmp650[aScan(_aEmp650,{|x|Alltrim(x[1]) == AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))}),6]
										aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"		})]	:= _aEmp650[aScan(_aEmp650,{|x|Alltrim(x[1]) == AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))}),3]
										aCols[_nItens][Len(aCols[_nItens])] := .F. //Flag para linha não deletada no aCols

										//Verifico o array de linhas deletadas, caso a linha em questão esteja deletada, restauro a mesma
										If aScan(aColsDele,_nItens) > 0

											_nPosDel := aScan(aColsDele,_nItens)

											_aDelAux := aClone(aColsDele)

											aColsDele := {}
											For _nCont := 1 To Len(_aDelAux)
												If _nCont <> _nPosDel
													aAdd(aColsDele,_aDelAux[_nCont])
												EndIf
											Next
										EndIf

										//Deleto do array o empenho já utilizado
										Adel(_aEmp650,aScan(_aEmp650,{|x|Alltrim(x[1]) == AllTrim(SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))}))

										Exit
									EndIf
								EndIf
							EndIf
						EndIf
						If (_cAlias)->B8_SLDDISP >= _nQtdAux
							aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"		})] := _nQtdAux
							aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"	})]	:= (_cAlias)->B8_LOTECTL

							If !Empty((_cAlias)->B8_NUMLOTE)
								aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_NUMLOTE"	})]	:= (_cAlias)->B8_NUMLOTE
							EndIf

							aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= STOD((_cAlias)->B8_DTVALID)
							aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"		})]	:= (_cAlias)->B8_LOCAL
							aCols[_nItens][Len(aCols[_nItens])] := .F. //Flag para linha não deletada no aCols

							_nQtdAux:=0
							//Verifico o array de linhas deletadas, caso a linha em questão esteja deletada, restauro a mesma
							If aScan(aColsDele,_nItens) > 0

								_nPosDel := aScan(aColsDele,_nItens)

								_aDelAux := aClone(aColsDele)

								aColsDele := {}
								For _nCont := 1 To Len(_aDelAux)
									If _nCont <> _nPosDel
										aAdd(aColsDele,_aDelAux[_nCont])
									EndIf
								Next
							EndIf

							Exit
						Else

							//_nPercAtiv := (SG1->G1_ATIVIDA - (( (_cAlias)->Z1_ATIVIDA * (_cAlias)->B8_SLDDISP)/ _nQtdAux ))//(((SC2->C2_QUANT * (_cAlias)->B8_SLDDISP))/_nQtdAux)
							//_nPercAtiv += ((_cAlias)->B8_SLDDISP/ _nQtdAux ) * 100
							_nPercAtiv += ((_cAlias)->Z1_ATIVIDA * (_cAlias)->B8_SLDDISP) / _nAtivida * 100
							aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"		})] := round((_cAlias)->B8_SLDDISP,5)
							aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"	})]	:= (_cAlias)->B8_LOTECTL

							If !Empty((_cAlias)->B8_NUMLOTE)
								aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_NUMLOTE"	})]	:= (_cAlias)->B8_NUMLOTE
							EndIf

							aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"	})]	:= STOD((_cAlias)->B8_DTVALID)
							aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"		})]	:= (_cAlias)->B8_LOCAL
							aCols[_nItens][Len(aCols[_nItens])] := .F. //Flag para linha não deletada no aCols

							//Verifico o array de linhas deletadas, caso a linha em questão esteja deletada, restauro a mesma
							If aScan(aColsDele,_nItens) > 0

								_nPosDel := aScan(aColsDele,_nItens)

								_aDelAux := aClone(aColsDele)

								aColsDele := {}
								For _nCont := 1 To Len(_aDelAux)
									If _nCont <> _nPosDel
										aAdd(aColsDele,_aDelAux[_nCont])
									EndIf
								Next
							EndIf

							//_nQtdAux -= round((_cAlias)->B8_SLDDISP,5)

						EndIf
						// LFSS - 14-08-2017 - 182        
						If _nQtdAux > 1   

							_cPrd  := 	(_cAlias)->B8_PRODUTO
							_cLote :=   (_cAlias)->B8_LOTECTL                                                   

						Endif                      
						//FA 


						(_cAlias)->(dbSkip())


					EndDo 
				Else
					_lAbort2 := .T.
					Aviso("Atenção","Produto sem saldo em estoque: "+Alltrim(_cProduto)+".",{"Ok"},2)

				Endif 

			EndIf
		Else     
			// LFSS - 09-08-2017 182 - Estoque   
			_lAbort2 := ShowErr( _cProduto,(_cAlias)->B8_LOTECTL,_nQtdAux,(_cAlias)->B8_SLDDISP,1 )
			// FA
		EndIf           
		// Tratar produto alternativo  - Daniel 09/08/2018

		If SG1->G1_TIPO == '2' .and._nQtdAux > 0 
			aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"		})] := 0 
			//	MsgStop("Falha no cálculo dos empenhos para Enzima, Sem Saldo para essa quantidade de Enzima!" + " Verificar o Produto: "+ SD4->D4_COD + " Lote: "+ SD4->D4_LOTECTL ,_cRotina+"_002")
			// LFSS - 10-08-2017 - 182 - Calculo Enzimatico 
			_lAbort2 :=	ShowErr( /*_cPrd*/_cProduto,_cLote,_nQtdAux,0,3 )
			// FA
			//	EstonarOP()
			//	Return()
			//FA
		EndIf      
		//Restauro o posicionamento real dentro do laço de repetição (For)
		_nItens := _nBkpIt
	Next

	//Segunda etapa, cálculo da quantidade total da OP
	For _nItens := 1 To Len(aCols)

		_cProduto	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})]
		_nQuant		:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})]
		_cSequen	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_TRT"	})]


		// tratar produto alternativo - Daniel 09/08/2018   

		_cQryalt := "SELECT  TOP 1 GI_PRODORI, GI_PRODALT, G1_TIPO, G1_QUANT, G1_ATIVIDA FROM " + RetSqlName("SGI") + " GI "
		_cQryalt += "INNER JOIN " + RetSqlName("SG1") + " G1 ON GI_PRODORI = G1_COMP AND G1.D_E_L_E_T_<> '*' "
		_cQryalt += "WHERE GI_PRODALT = '"+_cProduto+"' AND G1_COD = '"+SC2->C2_PRODUTO+"' AND GI.D_E_L_E_T_<> '*' "

		If select (_cAliasAlt) > 0                           
			(_cAliasAlt)->(dbCloseArea()) 
		EndIf 

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryalt),_cAliasAlt,.T.,.F.)


		IF 	(_cAliasAlt)->GI_PRODORI <> " "


			_cProduto :=  	(_cAliasAlt)->GI_PRODORI
			_cTipo:= 		(_cAliasAlt)->G1_TIPO
		Endif

		//	            If select (_cAliasAlt) > 0                           
		//				  (_cAliasAlt)->(dbCloseArea()) 
		//				EndIf

		dbSelectArea("SG1")
		dbSetOrder(1) //Filial + Produto + Componente + Sequencia
		If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+_cProduto+_cSequen)
			If !(SG1->G1_TIPO $ '1/3/5') //Somente considera enzima ou ingrediente
				_nQtdTot += _nQuant
			EndIf
		Else      
			// LFSS - 14/08/2017 - 182 - Erro no emprenho 
			ShowErr( SG1->G1_COMP,_cLote,_nQtdAux,0,6 )
			// FA 
		EndIf
	Next

	_aDelProd := {}
	_aColsTmp := {}

	//Terceira etapa, cálculo do diluente
	For _nItens := 1 To Len(aCols)

		_cProduto	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})]
		_nQuant		:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})]
		_cSequen	:= aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_TRT"	})]

		// tratar produto alternativo - Daniel 09/08/2018   

		_cQryalt := "SELECT  TOP 1 GI_PRODORI, GI_PRODALT, G1_TIPO, G1_QUANT, G1_ATIVIDA FROM " + RetSqlName("SGI") + " GI "
		_cQryalt += "INNER JOIN " + RetSqlName("SG1") + " G1 ON GI_PRODORI = G1_COMP AND G1.D_E_L_E_T_<> '*' "
		_cQryalt += "WHERE GI_PRODALT = '"+_cProduto+"' AND G1_COD = '"+SC2->C2_PRODUTO+"' AND GI.D_E_L_E_T_<> '*' "

		If select (_cAliasAlt) > 0                           
			(_cAliasAlt)->(dbCloseArea()) 
		EndIf 

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryalt),_cAliasAlt,.T.,.F.)


		IF 	(_cAliasAlt)->GI_PRODORI <> " "


			_cProduto :=  	(_cAliasAlt)->GI_PRODORI
			_cTipo:= 		(_cAliasAlt)->G1_TIPO
		Endif


		dbSelectArea("SG1")
		dbSetOrder(1) //Filial + Produto + Componente + Sequencia
		If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+_cProduto+_cSequen)
			If SG1->G1_TIPO == '1' //Diluente

				//Removido endereçamento para diluentes ~ Denis Varella 14/05/21
				aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "DC_LOCALIZ"	})] := ""

				//Percentual de rateio do diluente (para casos em que há mais de um diluente na fórmula)
				_nPercDil := SG1->G1_PERCDIL

				If _nPercDil == 0
					_nPercDil := 100
				EndIf

				_nPercDil := (_nPercDil/100)

				///////////////////////
				_nQtdDil := ((SC2->C2_QUANT - _nQtdTot) * _nPercDil)

				_aDilTmp := {}

				For _nAux := 1 To Len(aCols)
					If _cProduto == aCols[_nAux,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"})]
						If Len(_aDilTmp)==0
							_aDilTmp := aClone(aCols[_nItens])
						EndIf
					EndIf
				Next

				_cQryDil := "SELECT B8_DTVALID, round(B8_SALDO-B8_EMPENHO-B8_QACLASS, 5) B8_SLDDISP, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE FROM " + RetSqlName("SB8") + " SB8 "
				_cQryDil += "WHERE SB8.D_E_L_E_T_='' "
				_cQryDil += "AND SB8.B8_FILIAL='" + xFilial("SB8") + "' "
				_cQryDil += "AND SB8.B8_PRODUTO='" + _cProduto + "' "
				//				_cQryDil += "AND SB8.B8_LOCAL<>'98' " 
				_cQryDil += "AND SB8.B8_LOCAL NOT IN ('98','00','92','10') " 
				_cQryDil += "AND round(B8_SALDO-B8_EMPENHO-B8_QACLASS, 5)>0 "
				_cQryDil += "AND SB8.B8_DTVALID>='" + DTOS(dDataBase) + "' "
				_cQryDil += "ORDER BY B8_DTVALID,B8_LOTECTL "

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryDil),_cAliasDil,.T.,.F.)

				//dbSelectArea(_cAliasDil)

				While (_cAliasDil)->(!EOF()) .And. _nQtdDil > 0 .And. !(Alltrim(_cProduto) $ Alltrim(cProdProc))

					If (_cAliasDil)->(B8_SLDDISP) >= _nQtdDil

						If Len(_aDilTmp)==0
							_aDilTmp := aClone(aCols[_nItens])
						EndIf

						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP" 	})] := _cProduto
						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := _nQtdDil
						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"	})] := (_cAliasDil)->(B8_LOCAL	)
						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"})] := (_cAliasDil)->(B8_LOTECTL)
						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"})] := STOD((_cAliasDil)->(B8_DTVALID))
						_nQtdDil := 0
					Else
						If Len(_aDilTmp)==0
							_aDilTmp := aClone(aCols[_nItens])
						EndIf

						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP" 	})] := _cProduto
						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := (_cAliasDil)->(B8_SLDDISP)
						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"	})] := (_cAliasDil)->(B8_LOCAL	)
						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"})] := (_cAliasDil)->(B8_LOTECTL)
						_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"})] := STOD((_cAliasDil)->(B8_DTVALID))
						_nQtdDil -= (_cAliasDil)->(B8_SLDDISP)
					EndIf

					AAdd(_aColsTmp,aClone(_aDilTmp))
					//					AAdd(aCols,aClone(_aDilTmp))

					//dbSelectArea(_cAliasDil)
					(_cAliasDil)->(dbSkip())
				EndDo

				//Produto alternativo
				If _nQtdDil > 0 .And. !IsEstrut(SC2->C2_PRODUTO, aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})])

					cAliasDil2 := GetNextAlias() 
					_cQryDil2 := ""

					_cQryDil2 := " SELECT  GI_PRODORI, GI_PRODALT, "+CRLF 
					_cQryDil2 += " B8_DTVALID, round(B8_SALDO-B8_EMPENHO-B8_QACLASS, 5) B8_SLDDISP, B8_LOCAL, B8_LOTECTL, B8_NUMLOTE "+CRLF
					_cQryDil2 += " FROM "+RetSqlName("SGI")+" GI " +CRLF

					_cQryDil2 += " INNER JOIN "+RetSqlName("SB8")+" SB8 "+CRLF 
					_cQryDil2 += " ON SB8.B8_FILIAL = '"+xFilial("SB8")+"' " +CRLF
					_cQryDil2 += " AND SB8.B8_PRODUTO = GI.GI_PRODALT "+CRLF
					_cQryDil2 += " AND SB8.B8_LOCAL NOT IN ('98','00','92','10') "+CRLF
					_cQryDil2 += " AND round(B8_SALDO-B8_EMPENHO-B8_QACLASS, 5)>0 "+CRLF
					_cQryDil2 += " AND SB8.B8_DTVALID >= '"+DTOS(MsDate())+"' " +CRLF
					_cQryDil2 += " AND SB8.D_E_L_E_T_ = ' ' "+CRLF 

					_cQryDil2 += " INNER JOIN "+RetSqlName("SG1")+" SG1 "+CRLF
					_cQryDil2 += " ON SG1.G1_FILIAL= '"+xFilial("SG1")+"' "+CRLF
					_cQryDil2 += " AND SG1.G1_COD = '"+SC2->C2_PRODUTO+"' "+CRLF
					_cQryDil2 += " AND SG1.G1_COMP = GI.GI_PRODORI "+CRLF
					_cQryDil2 += " AND SG1.D_E_L_E_T_ = ' ' "					

					_cQryDil2 += " WHERE GI.GI_FILIAL = '"+xFilial("SGI")+"' "+CRLF 
					_cQryDil2 += " AND GI.GI_PRODORI = '"+_cProduto+"' "+CRLF 
					_cQryDil2 += " AND GI.D_E_L_E_T_<> '*' "+CRLF
					_cQryDil2 += " ORDER BY GI_PRODALT, B8_DTVALID, B8_LOTECTL "+CRLF

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryDil2),cAliasDil2,.T.,.F.)

					While (cAliasDil2)->(!Eof())

						If (cAliasDil2)->(B8_SLDDISP) >= _nQtdDil
							If Len(_aDilTmp)==0
								_aDilTmp := aClone(aCols[_nItens])
							EndIf						

							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP" 	})] := (_cAliasAlt)->GI_PRODALT
							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := _nQtdDil
							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"	})] := (cAliasDil2)->(B8_LOCAL	)
							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"})] := (cAliasDil2)->(B8_LOTECTL)
							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"})] := STOD((cAliasDil2)->(B8_DTVALID))
							_nQtdDil := 0
						Else
							If Len(_aDilTmp)==0
								_aDilTmp := aClone(aCols[_nItens])
							EndIf

							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP" 	})] := (_cAliasAlt)->GI_PRODALT
							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := (cAliasDil2)->(B8_SLDDISP)
							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"	})] := (cAliasDil2)->(B8_LOCAL	)
							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"})] := (cAliasDil2)->(B8_LOTECTL)
							_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"})] := STOD((cAliasDil2)->(B8_DTVALID))
							_nQtdDil -= (cAliasDil2)->(B8_SLDDISP)
						EndIf					

						AAdd(_aColsTmp,aClone(_aDilTmp))
						AAdd(_aDelProd,(_cAliasAlt)->GI_PRODALT)

						(cAliasDil2)->(DbSkip())
					EndDo
				EndIf

				If _nQtdDil > 0 .And. IsEstrut(SC2->C2_PRODUTO, _cProduto) .And. !(Alltrim(_cProduto) $ Alltrim(cProdProc))

					cProdProc += _cProduto+";"
					If Len(_aDilTmp)==0
						_aDilTmp := aClone(aCols[_nItens])
					EndIf	

					_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP" 	})] := _cProduto
					_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := _nQtdDil
					_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"	})] := (_cAliasDil2)->(B8_LOCAL	)
					_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"})] := ""
					_aDilTmp[aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"})] := STOD("")

					AAdd(_aColsTmp,aClone(_aDilTmp))
				EndIf

				AAdd(_aDelProd,_cProduto)

				If Select(_cAliasDil2) > 0
					(_cAliasDil2)->(DbCloseArea())
				EndIf

				//dbSelectArea(_cAliasDil)
				If Select(_cAliasDil) > 0
					(_cAliasDil)->(dbCloseArea())
				EndIf

				//////////////////////

				//aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := ((SC2->C2_QUANT - _nQtdTot) * _nPercDil)

				If aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] < 0
					aCols[_nItens,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})] := 0                 
					// LFSS 14/08/2017 - 182 - Dileunte Negativando					
					_lAbort2 := ShowErr( (_cAlias)->B8_PRODUTO,(_cAlias)->B8_LOTECTL,_nQtdAux,(_cAlias)->B8_SLDDISP,2 ) 
					//EstonarOP()
					//Return()
					// FA

				EndIf
			EndIf
		Else       
			// LFSS - 14/08/2017 - 182 - Erro no Diluente 
			_lAbort2 := ShowErr( (_cAlias)->B8_PRODUTO,(_cAlias)->B8_LOTECTL,_nQtdAux,(_cAlias)->B8_SLDDISP,5 )
			// FA
		EndIf
	Next

	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf

	// LFSS - 09-08-2017 - 182  - Caso de erro abortar 
	if  _lAbort2   
		//MsgStop('Cancelando op: '+SC2->C2_NUM)         
		IF EstonarOP()                
			Return()   
		EndIf 
	Endif                                               
	// FA

	_aCols2 := {}

	For _nCont := 1 To Len(aCols)
		
		//Início Análise do Saldo no endereço 199.AMOSTRA para priorizar ~ Denis Varella 01/06/2021
		If cLocal == '10' .OR. SC2->C2_YAMOSTR == '2'

			_cProduto := aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})]
			_nQuant   := aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})]
			cQry := " SELECT ISNULL(BF_QUANT-BF_EMPENHO,0) SALDO,BF_LOTECTL,BF_LOCAL,B8_DTVALID FROM SBF010 BF
			cQry += " INNER JOIN SB8010 B8 ON B8_PRODUTO = BF_PRODUTO AND B8_LOTECTL = BF_LOTECTL AND B8_LOCAL = BF_LOCAL AND B8.D_E_L_E_T_ = ''
			cQry += " WHERE BF_LOCALIZ = '199.AMOSTRA' and BF_PRODUTO = '"+trim(_cProduto)+"' AND BF.D_E_L_E_T_ = '' "
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"BFSALDO",.T.,.F.)
			nSaldo := 0
			If BFSALDO->(!EOF())
				nSaldo := BFSALDO->SALDO
			EndIf
			If nSaldo >= _nQuant
				aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "DC_LOCALIZ"})] := "199.AMOSTRA    "
				aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"})] := BFSALDO->BF_LOTECTL
				aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"})] 	:= BFSALDO->BF_LOCAL
				aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"})] := StoD(BFSALDO->B8_DTVALID)
			EndIf
			BFSALDO->(DbCloseArea())

		EndIf
		//Fim Análise do Saldo no endereço 199.AMOSTRA para priorizar ~ Denis Varella 01/06/2021

		//Comentado dia 12/04 por Denis por erro causado na rotina
		If aScan(_aDelProd,aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"})])==0
			If aCols[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"})]>0
				AAdd(_aCols2,aClone(aCols[_nCont]))
			else
				aCols[_nCont,len(aHeader)+1] := .t.
				AAdd(_aCols2,aClone(aCols[_nCont]))
			EndIf
		EndIf
	Next

	For _nCont := 1 To Len(_aColsTmp)
		If _aColsTmp[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"})]==0
			aCols[_nCont,len(aHeader)+1] := .t.
			AAdd(_aCols2,aClone(aCols[_nCont]))
		else
		
			//Início Análise do Saldo no endereço 199.AMOSTRA para priorizar ~ Denis Varella 01/06/2021
			If cLocal == '10' .OR. SC2->C2_YAMOSTR == '1'

				_cProduto := _aColsTmp[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "G1_COMP"	})]
				_nQuant   := _aColsTmp[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_QUANT"	})]
				cQry := " SELECT ISNULL(BF_QUANT-BF_EMPENHO,0) SALDO,BF_LOTECTL,BF_LOCAL,B8_DTVALID FROM SBF010 BF
				cQry += " INNER JOIN SB8010 B8 ON B8_PRODUTO = BF_PRODUTO AND B8_LOTECTL = BF_LOTECTL AND B8_LOCAL = BF_LOCAL AND B8.D_E_L_E_T_ = ''
				cQry += " WHERE BF_LOCALIZ = '199.AMOSTRA' and BF_PRODUTO = '"+trim(_cProduto)+"' AND BF.D_E_L_E_T_ = '' "
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"BFSALDO",.T.,.F.)
				nSaldo := 0
				If BFSALDO->(!EOF())
					nSaldo := BFSALDO->SALDO
				EndIf
				If nSaldo >= _nQuant
					_aColsTmp[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "DC_LOCALIZ"})] := "199.AMOSTRA    "
					_aColsTmp[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOTECTL"})] := BFSALDO->BF_LOTECTL
					_aColsTmp[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_LOCAL"})] 	:= BFSALDO->BF_LOCAL
					_aColsTmp[_nCont,aScan(aHeader,{|x|Alltrim(x[2]) == "D4_DTVALID"})] := StoD(BFSALDO->B8_DTVALID)
				EndIf
				BFSALDO->(DbCloseArea())

			EndIf
			//Fim Análise do Saldo no endereço 199.AMOSTRA para priorizar ~ Denis Varella 01/06/2021

			AAdd(_aCols2,aClone(_aColsTmp[_nCont]))
		EndIf
	Next

	//Comentado dia 12/04 por Denis por erro causado na rotina
	aCols := aClone(_aCols2)
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	For nA := 1 to len(aCols)
		If SB1->(DbSeek(xFilial("SB1")+Trim(aCols[nA,GdFieldPos("G1_COMP")])))
			If SB1->B1_TIPCONV == 'M'
				aCols[nA,GdFieldPos("D4_QTSEGUM")] := Round(aCols[nA,GdFieldPos("D4_QUANT")] * SB1->B1_CONV,4)
			ElseIf SB1->B1_TIPCONV == 'D'
				aCols[nA,GdFieldPos("D4_QTSEGUM")] := Round(aCols[nA,GdFieldPos("D4_QUANT")] / SB1->B1_CONV,4)
			EndIf
		EndIf
	Next nA

	RestArea(_aSavArea)

Return()

Static Function EstonarOP()

	Local aMATA650	:= {} //Array com os campos
	Local _nCont	:= 1
	lMsErroAuto 	:= .F.

	aCols:={}

	aMata650  	:= {{'C2_FILIAL'   ,xFilial("SC2")													,NIL},;
	{'C2_PRODUTO'  ,SC2->C2_PRODUTO													,NIL},;
	{'C2_NUM'      ,SC2->C2_NUM                     								,NIL},;
	{'C2_ITEM'     ,SC2->C2_ITEM													,NIL},;
	{'C2_SEQUEN'   ,SC2->C2_SEQUEN													,NIL},;
	{'C2_ITEMGRD'  ,SC2->C2_ITEMGRD													,NIL}} 

	SC2->(DbSetOrder(1)) // FILIAL + NUM + ITEM + SEQUEN + ITEMGRD
	SC2->(DbSeek(xFilial("SC2")+SC2->C2_NUM  +SC2->C2_ITEM+SC2->C2_SEQUEN + SC2->C2_ITEMGRD ))
	//LFSS - 14-08-2017l Analisar para virar execauto abaixo  
	/*RecLock("SC2",.F.)
	Sc2->(DbDelete())
	MsUnlock()  
	*/

	If MsgYesNo("Enzima(s) com problema no calculo enzimatico, deseja excluir a OP ?","COMA001E_A")  
		_lAbort := .t.
		MsExecAuto({|x,Y| Mata650(x,Y)},aMata650,5) //Exclusão da OP
	Else 
		sc2->(RecLock('SC2',.F.))
		// SC2->C2_XNEXCO := cUserName 
		SC2->(MsUNlock())
	Endif 
	//FA

	If lMsErroAuto
		// RollbackSx8()
		MostraErro()
	EndIf

	For _nCont := 1 To Len(aCols)
		aCols[_nCont,Len(aCols[_nCont])] := .T.
	Next

	_lConti004 := .T. 

Return(_lAbort)

//--------------------------------
// Mostra Erro do processamento, MsStop, e ConOut  
// Autor: LFSS
// Data : 14-08-2017
Static Function ShowErr(cProd,cLot,nQtd,NSaldo,cTip) 

	//-----------------------------  
	Local cMsg := ""
	Local aArea := getArea()

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial('SB1')+cProd))


	cMsg := 	If( cTip == 1 /* Saldo Estoque */						, "Saldo em estoque insuficiente  ("+alltrim(SB1->B1_COD)+'-'+alltrim(SB1->B1_DESC)+"), Lote ("+cLot+"), Saldo: "+alltrim(str(nQtd))+"! [Saldo Estoque] "+alltrim(str(NSaldo))+" ! "  ,;                                                                                                                                                      
	If( cTip == 2 /* Calculo de diluente  - Negativando */, "Falha no cálculo dos empenhos para diluente, para essa quantidade base o diluente ficaria negativo! [Calculo de Diluente  - Negativando]!" ,;
	If( cTip == 3 /* Calculo Enzimatico */ 				, "Falha no cálculo dos empenhos para Enzima ("+alltrim(SB1->B1_COD)+'-'+alltrim(SB1->B1_DESC)+"), Lote ("+Alltrim(cLot)+"), Qtd.Aux:"+alltrim(str(nQtd))+"! [Calculo Enzimatico]! " ,;
	If( cTip == 5 /* Erro no diluente */					, "Falha no cálculo dos empenhos para diluente, informe ao Administrador do sistema! [Erro no diluente]!" ,;
	If( cTip == 6 /* Falha empenho */						, "Falha no cálculo dos empenhos, informe ao Administrador do sistema! [Falha Empenho] !","Erro")))))                                                                                 

	ConOut(cMsg + " Produto:"+SC2->C2_PRODUTO+" Quant: "+alltrim(Str(SC2->C2_QUANT)))
	MsgStop(cMsg,_cRotina+"_"+strZero(cTip,3))

	RestArea(aArea)

Return(.T.)    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IsEstrut	  ºAutor  ³Microsiga	      º Data ³  30/08/2019º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o produto existe na estrutura                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IsEstrut(cCodProd, cCodPrdCom)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local lRet		:= .F.

	Default cCodProd	:= "" 
	Default cCodPrdCom	:= "" 

	cQuery	:= " SELECT COUNT(*) CONTADOR FROM "+RetSqlName("SG1")+" SG1 "+CRLF
	cQuery	+= " WHERE SG1.G1_FILIAL = '"+xFilial("SG1")+"' "+CRLF 
	cQuery	+= " AND SG1.G1_COD = '"+cCodProd+"' "+CRLF
	cQuery	+= " AND SG1.G1_COMP = '"+cCodPrdCom+"' "+CRLF
	cQuery	+= " AND SG1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof()) .And. (cArqTmp)->CONTADOR>0
		lRet := .T.
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return lRet
