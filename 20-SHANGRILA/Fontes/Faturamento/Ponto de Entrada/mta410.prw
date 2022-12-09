
//'#include "rwmake.ch"
#Include "Topconn.ch"
/*
------------------------------------------------------------------------------
Programa : MTA410			| Tipo: Ponto de Entrada		| Rotina: MATA410
Data     : 19/03/07
------------------------------------------------------------------------------
Descricao: - Validacao do Pedido de Venda
- Verifica se o PV deve ser Recalculado para aplicaï¿½ï¿½o das Regras de Desconto
------------------------------------------------------------------------------
*/
User Function MTA410()

	Local _lRet     := .T.
	Local _lContem  := .F.
	Local _aArea    := GetArea()
	Local cEstNorte := GETMV("MV_NORTE")
	Local nValMin   := GETMV("MV_XVALMIN")
	Local cGrupo
	Local cCodreg   := M->C5_X_CODRE
	Local cCondPag  := M->C5_CONDPAG
	Local cTipoPed  := M->C5_TIPO
	Local cTabela   := M->C5_TABELA  		//ALT. 22/09/07
	Local cCodPro   := ""
	Local nTotalPed := 0
	Local lOper	    := .T.

	Local nPosTotal := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
	Local nPosDesc  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
	Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
	Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
	Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
	Local nPosTes   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
	Local nPosDscC  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"}) //Desconto Concedido no Item
	Local nPosDscR  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_DESCO"}) //Desconto Maximo permitido pela regra
	Local nPosProd  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
	Local nPPrLst2  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_PRLST"})
	Local lCondVst	:= .F.

	Local _x
	Local _nValProm := 0
	Local _nValNorm := 0
	Local _cLog  := ""
	Local _cLogBlq  := ""

	Private cUFDestino:= SA1->A1_EST
	Private cRegiao

	Public _xlBlqRegra := .F.		//Pedido serï¿½ bloqueado por Regra Desconto
	Public _xlBlqPed   := .F.     	//Pedido serï¿½ bloqueado
	Public _xlBlqVerba := .F. 	   	//Pedido serï¿½ bloqueado por verba

	Public nPesoLiqT := 0
	Public nPesoBrtT := 0
	/*
	----------------------------------------------------------
	Somente pedidos tipo "N" deverao ser validados
	----------------------------------------------------------*/
	//Add Joï¿½o Zabotto 13/02/2017 - Validar regras pela rotina padrï¿½o
	If cTipoPed != "N"
		Return(_lRet)
	EndIf
	/*
	------------------------------------------------------------
	Incializa variaveis publicas para validar bloqueio do pedido
	------------------------------------------------------------*/
	//If Altera
	//	If existTrigger("C5_CLIENTE")
	//		RunTrigger(1,,"C5_CLIENTE","C5_CLIENTE")
	//	EndIf


	//EndIf
	/*
	-------------------------------------------------------------------------------------
	Verifica se o pedido sera bloqueado por Regra ou Verba
	-------------------------------------------------------------------------------------
	*/
	If .T.
		For _x := 1 to Len(aCols)
			GdFieldPut("C6_DTENTR" ,M->C5_DTENTR,_x)
			GdFieldPut("C6_ENTREG" ,M->C5_DTENTR,_x)
			GdFieldPut("C6_SUGENTR",M->C5_DTENTR,_x)
		Next
		_aParc := Condicao(10000,M->C5_CONDPAG,,dDataBase)
		_nDias := 0
		_nPMed := 0
		_nParc := Len(_aParc)
		If cUFDestino == 'SP'
			cRegDA0  := '1'
			cRegSZ0  := '1'
		Else
			If cUFDestino $ cEstNorte
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
		M->C5_XPRZMED := _nPMed
		If !Empty(M->C5_X_CODRE)
			For _x := 1 to len(acols)
				If !aCols[_x,Len(aHeader)+1]
					_cCod := GdFieldGet("C6_PRODUTO",_x)
					DbSelectArea("SF4")
					DbSetOrder(1)
					DbSeek(xFilial("SF4")+GdFieldGet("C6_TES",_x))
					cQry := "SELECT TOP 1 DA1_TIPPRE,DA1_QTDLOT "
					cQry += "FROM DA1010 DA1 "
					cQry += "WHERE DA1.D_E_L_E_T_<>'*' "
					cQry += "AND DA1_CODTAB='"+M->C5_TABELA+"' "
					_nAlqIpi := 0
					DbSelectArea("SB4")
					DbSetOrder(1)
					If DbSeek(xFilial("SB4")+Padr(Substr(_cCod,1,6),TamSX3("B4_COD")[1]))
						cQry += "AND (DA1_REFGRD='"+Substr(_cCod,1,6)+"' OR DA1_CODPRO='"+_cCod+"') "
						_nAlqIpi := SB4->B4_IPI
					Else
						DbSelectArea("SB1")
						DbSetOrder(1)
						DbSeek(xFilial("SB1")+GdFieldGet("C6_PRODUTO",_x))
						_nAlqIpi := SB1->B1_IPI
						cQry += "AND DA1_CODPRO='"+_cCod+"' "
					EndIf
					cQry += "AND DA1_TPOPER='"+cRegDA0+"' "
					cQry += "AND DA1_QTDLOT>"+cValToChar(GdFieldGet("C6_QTDVEN",_x))+" "
					cQry += "ORDER BY DA1_QTDLOT "
					memowrite("mta410_da1x.txt",cQry)
//					Alert()
					TcQuery cQry New Alias "DA1X"
					DbSelectArea("DA1X")
					DBGoTop()
					If !DA1X->(Eof())
						If DA1X->DA1_TIPPRE == '5'
						//	If GdFieldGet("C6_VALDESC",_x) > 0 + IIF(Alltrim(M->C5_CONDPAG) == "003",3,0)
							If GdFieldGet("C6_DESCONT",_x) > 0 + IIF(Alltrim(M->C5_CONDPAG) == "003",3,0)
								_xlBlqRegra := .T.
								_cLogBlq += "Bloqueio - Item promocional nao pode ter desconto algum. Foi digitado "+cValToChar(GdFieldGet("C6_DESCONT",_x))+" %. Item: "+GdFieldGet("C6_ITEM",_x)+Chr(13)+Chr(10)
							EndIf
							_nValProm += GdFieldGet("C6_VALOR",_x)+GdFieldGet("C6_VALDESC",_x)
							If SF4->F4_IPI == "S"
								_nValProm += GdFieldGet("C6_VALOR",_x)*(_nAlqIpi/100)
							EndIf
						Else
							_nValNorm += GdFieldGet("C6_VALOR",_x)+GdFieldGet("C6_VALDESC",_x)
							If SF4->F4_IPI == "S"
								_nValNorm += GdFieldGet("C6_VALOR",_x)*(_nAlqIpi/100)
							EndIf
						EndIf
					Else
						_xlBlqRegra := .T.
						_cLogBlq += "Bloqueio - Nao encontrado na tabela de preco. Produto: "+_cCod+" Item: "+GdFieldGet("C6_ITEM",_x)+Chr(13)+Chr(10)
					EndIf
					DA1X->(DbCloseArea())
					If SF4->F4_IPI == "S"
						nTotalPed += GdFieldGet("C6_VALOR",_x)*(_nAlqIpi/100)
					EndIf
					nTotalPed += GdFieldGet("C6_VALOR",_x)
				EndIf
			Next
			_nPrazo	  := 0
			_nValAte  := 0
			_nDescMax := 0
			_nDescAvi := 0

			cQry := "SELECT TOP 1 Z1_VALATE,Z1_DESC1,Z1_DESC6,Z1_PRZMED "
			cQry += "FROM SZ0010 SZ0 "
			cQry += "	INNER JOIN SZ1010 SZ1 ON SZ1.D_E_L_E_T_<>'*' AND Z0_CODIGO=Z1_CODIGO AND Z0_TABELA=Z1_TABPRC AND Z1_REGIAO=Z0_CODREG AND Z1_GRUPO=Z0_GRUPO "
			cQry += "WHERE SZ0.D_E_L_E_T_<>'*' AND Z0_CODIGO='"+M->C5_X_CODRE+"' "
			cQry += "AND Z0_CODREG='"+cRegSZ0+"' AND Z0_TIPOPER='50' AND Z0_GRUPO='0100' "
			cQry += "AND Z0_TABELA='"+M->C5_TABELA+"' "
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
			cQry := "SELECT TOP 1 Z1_VALATE,Z1_DESC1,Z1_DESC6,Z1_PRZMED "
			cQry += "FROM SZ0010 SZ0 "
			cQry += "	INNER JOIN SZ1010 SZ1 ON SZ1.D_E_L_E_T_<>'*' AND Z0_CODIGO=Z1_CODIGO AND Z0_TABELA=Z1_TABPRC AND Z1_REGIAO=Z0_CODREG AND Z1_GRUPO=Z0_GRUPO "
			cQry += "WHERE SZ0.D_E_L_E_T_<>'*' AND Z0_CODIGO='"+M->C5_X_CODRE+"' "
			cQry += "AND Z0_CODREG='"+cRegSZ0+"' AND Z0_TIPOPER='50' AND Z0_GRUPO='0100' "
			cQry += "AND Z0_TABELA='"+M->C5_TABELA+"' "
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

			_cLog := "Valor Promocional: "+cValToChar(_nValProm)+Chr(13)+Chr(10)
			_cLog += "Valor Tabela: "+cValToChar(_nValNorm)+Chr(13)+Chr(10)
			_cLog += "Valor Bruto: "+cValToChar(_nValNorm+_nValProm)+Chr(13)+Chr(10)
			_cLog += Chr(13)+Chr(10)
			//_cLog += "Prazo Medio da Regra: "+cValToChar(_nPrazo)+Chr(13)+Chr(10)
			//_cLog += "Prazo Pedido: "+cValToChar(_nPMed)+Chr(13)+Chr(10)
			//_cLog += "Valor ate Regra: "+cValToChar(_nValAte)+Chr(13)+Chr(10)
			//_cLog += "Desc Max Regra: "+cValToChar(_nDescMax)+" %"+Chr(13)+Chr(10)
			//_cLog += "Desc Avist Regra: "+cValToChar(_nDescAvi)+Chr(13)+Chr(10)
			If _nPMed == 0
				_cLog += Chr(13)+Chr(10)
				_cLog += "Bloqueio - Desc Max Regra + A vista: "+cValToChar(_nDescMax+_nDescAvi)+" %"+Chr(13)+Chr(10)
			Else
				_nDescAvi := 0
			EndIf
			_cLog += Chr(13)+Chr(10)
			For _x := 1 to Len(aCols)
				If Empty(GdFieldGet("C6_OPER",_x))
					GdfieldPut("C6_OPER",GdFieldGet("C6_X_TO",_x),_x)
				EndIf
				If !aCols[_x,Len(aHeader)+1]
					If GdFieldGet("C6_DESCONT",_x) > (_nDescMax+_nDescAvi)
						_xlBlqRegra := .T.
						_cLogBlq += "Bloqueio - Desconto de "+cValToChar(GdFieldGet("C6_DESCONT",_x))+" % acima da regra de "+cValToChar(_nDescMax)+" %. Item: "+GdFieldGet("C6_ITEM",_x)+Chr(13)+Chr(10)
					EndIf
					If GdFieldGet("C6_OPER",_x) # "50"
						_xlBlqRegra := .T.
						_cLogBlq += "Bloqueio - Operacao "+GdFieldGet("C6_OPER",_x)+" gerou bloqueio. Item: "+GdFieldGet("C6_ITEM",_x)+Chr(13)+Chr(10)
					EndIf
				EndIf
			Next

			If _nPMed > _nPrazo
				_xlBlqRegra := .T.
				_cLogBlq += "Bloqueio - Prazo medio do pedido de "+Cvaltochar(_nPMed)+" dias superir a regra. "+Cvaltochar(_nPrazo)+Chr(13)+Chr(10)
			EndIf
			If nTotalPed < nValMin
				_xlBlqRegra := .T.
				_cLogBlq += "Bloqueio - Pedido minimo de "+cValToChar(nValMin)+" nao atingido"+Chr(13)+Chr(10)
			EndIf
		Else
			_xlBlqRegra := .T.
			_xlBlqPed   := .T.
			_lRet       := .T.    	//grava o pedido com bloqueio de regra - (PE MTA410T)
			_cLogBlq 	+= "Pedido Sem Regra - Bloqueado"
		EndIf
		If _xlBlqRegra
			If FUNNAME() == "RGUAX001" .OR. !MsgYesNo(_cLog+_cLogBlq,"Confirma gravacao fora da regra?") //Adicionado a regra de entrada da rotina de gravação do pedido do Guarani 19/08/2021.
				Return .F.
			EndIf
			M->C5_XBLQ	:= "S"
			M->C5_XLOGBLQ	:= _cLog
			M->C5_XLOGBLQ	+= _cLogBlq
		Else
			M->C5_XBLQ	:= "N"
		//	M->C5_XLOGBLQ	:= "" Desativado a limpeza do Log da Regra - Marcos Floridi - 20/07/2021
		EndIf
	Else
		If !Empty(M->C5_X_CODRE)
				/*  ---------------------------
			Identifica a UF destino
			---------------------------*/
			If cUFDestino == 'SP'
				cRegiao  := '1'
			Else
				If cUFDestino $ cEstNorte
					cRegiao  := '3'
				Else
					cRegiao  := '2'
				EndIf
			EndIf
			/*	----------------------------------------------------------------------------------
			Recalcula o valor do Pedido pelo Preco de Lista para identificar o desconto maximo
			----------------------------------------------------------------------------------*/
			nTotalPed := 0
			/*
			For _nCnt := 1 To Len(aCols)
				If acols[_nCnt,Len(aCols[_nCnt])] == .F.	//Verifica se linha esta deletada
					If cCodPro != aCols[_nCnt,nPosProd]
						cCodPro := aCols[_nCnt,nPosProd]
						
						nTotalPed += aCols[_nCnt,nPQtdVen] * aCols[_nCnt,nPPrLst2]
					EndIf
					
					If Substr(aCols[_nCnt,nPosProd],1,1) == 'Z' .And. !aCols[_nCnt,nPosProd] $ '200'
						lOper := .F.
					EndIf
					If Substr(aCols[_nCnt,nPosProd],1,1) <> 'Z' .And. aCols[_nCnt,nPosProd] $ '200'
						lOper := .F.
					EndIf
				EndIf
			Next
			*/

			/* 	----------------------------------------------
			Seleciona a Regra de desconto
			----------------------------------------------*/
			For _nCnt := 1 To Len(aCols)
				If acols[_nCnt,Len(aCols[_nCnt])] == .F.	//Verifica se linha esta deletada
					cGrupo := Posicione("SB1",1,xFilial("SB1")+aCols[_nCnt,nPosProd],"B1_GRUPO")
					
					cQuery := "SELECT SZ0.*, SZ1.* "
					cQuery += "FROM "
					cQuery += RetSqlName("SZ1")+" SZ1, "
					cQuery += RetSqlName("SZ0")+" SZ0 "
					cQuery += "WHERE "
					cQuery += "SZ0.Z0_FILIAL = '"+xFilial("SZ0")+"' AND "
					cQuery += "SZ1.Z1_FILIAL = '"+xFilial("SZ1")+"' AND "
					cQuery += "SZ0.Z0_CODIGO = '" + cCodreg + "' AND "
					cQuery += "SZ0.Z0_GRUPO  = '" + cGrupo + "' AND "
					cQuery += "SZ0.Z0_CODREG = '" + cRegiao + "' AND "
					cQuery += "SZ0.Z0_TABELA = '" + cTabela + "' AND "
					cQuery += "SZ1.Z1_CODIGO = SZ0.Z0_CODIGO AND "
					cQuery += "SZ1.Z1_GRUPO  = SZ0.Z0_GRUPO  AND "
					cQuery += "SZ1.Z1_REGIAO = SZ0.Z0_CODREG AND "
					cQuery += "SZ0.Z0_ATIVO  = '1' AND "
					cQuery += "SZ0.D_E_L_E_T_= ' ' AND "
					cQuery += "SZ1.D_E_L_E_T_= ' ' "
					cQuery += "ORDER BY Z1_CODIGO,Z1_GRUPO,Z1_REGIAO,Z1_ITEM "
					
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
					
					dbSelectArea("TMP")
					TMP->(dbGoTop())
					
					nRegs     := 0
					nDescCalc := 0
					
					While TMP->(!Eof())
						nRegs := 1
						If nTotalPed > TMP->Z1_VALATE
							TMP->(dbSkip())
							Loop
						Else
							nDescCalc := 0
							If nTotalPed >= nValMin
								nValD1 := TMP->Z1_DESC1      	//Desconto 1
								nValD2 := TMP->Z1_DESC2         //Desconto 2
								nValD3 := TMP->Z1_DESC3			//Desconto 3
								nValD4 := TMP->Z1_DESC4			//Desconto 4
								nValD5 := TMP->Z1_DESC5			//Desconto 5 - DIF ICMS
								nValD6 := TMP->Z1_DESC6			//Desconto 6 - A VISTA
								/*						------------------------------------------------
								Calculo do Desconto Maximo Permitido pela Regra
								DescLiq = (1 - (ValLiqN / Total )) * 100
								------------------------------------------------*/
								If cCondPag $ "003/007/027/031"
									lCondVst:= .T.
									aDescC  := {nValD1,nValD2,nValD3,nValD4,nValD5,nValD6}
								Else
									aDescC  := {nValD1,nValD2,nValD3,nValD4,nValD5}
									
								EndIf
								nValLiq := nTotalPed
								
								For nX := 1 To Len(aDescC)
									If aDescC[nX] != 0
										nValLiq := nValLiq - (nValLiq * (aDescC[nX]/100))
									EndIf
								Next
								
								If nValLiq != 0
									nDescCalc := Round((1 - (nValLiq / nTotalPed)) * 100, 2)
								EndIf
								/*						--------------------------------------------------
								Verifica se o PV serï¿½ bloqueado por Regra
								--------------------------------------------------*/
								aCols[_nCnt,nPosDscR] := nDescCalc
								
								If aCols[_nCnt,nPosDscC] > aCols[_nCnt,nPosDscR]
									_xlBlqRegra := .T.		//Pedido serï¿½ bloqueado por Regra Desconto
									_lRet       := .T.    	//grava o pedido com bloqueio de regra - (PE MTA410T)
								EndIf
								/*						--------------------------------------------------
								Verifica se o PV serï¿½ bloqueado por Regra
								Tabela de Preco # 1N c/ Desconto - Bloqueia
								--------------------------------------------------*/
								If 	!lCondVst			//.T. - Cond PAgt A Vista // .F. - Cond Pagt A Prazo
									If nDescCalc > 0
										_xlBlqRegra := .T.		//Pedido serï¿½ bloqueado por Regra Desconto
										_lRet       := .T.    	//grava o pedido com bloqueio de regra - (PE MTA410T)
									EndIf
								EndIf
								Exit
							EndIf
						EndIf
						TMP->(dbSkip())
					End
					TMP->(dbCloseArea())
				EndIf
			Next
			/*	----------------------------------------------------------
			Recalcula o valor do Pedido pelo Preco Liquido - C6_PRCVEN
			----------------------------------------------------------*/
			nTotalPed := 0
			For _nCnt := 1 To Len(aCols)
				If acols[_nCnt,Len(aCols[_nCnt])] == .F.	//Verifica se linha esta deletada
				nTotalPed += aCols[_nCnt,nPQtdVen] * aCols[_nCnt,nPPrcVen]
				EndIf
			Next
			/*	------------------------------------------------------------------
			Verifica se o pedido sera bloqueado por Verba ou Regra de Desconto
			------------------------------------------------------------------*/
			If !_xlBlqRegra
				/*		------------------------------------------------
				Verifica se o Pedido serï¿½ bloqueado por Verba
				------------------------------------------------*/
				If nTotalPed < nValMin
					If ApMsgYesNo("Valor abaixo do minimo. Redigitar quantidade(s) (S/N)?",,"INFO")
						_lRet := .F.    //Nao grava o pedido e retorna para a tela para Redigitar quantidade
					Else
						ApMsgAlert("Pedido serï¿½ gravado com Bloqueio de Verba","Bloqueio de Verba")
						_xlBlqVerba := .T.		//Pedido serï¿½ bloqueado por verba
						_lRet       := .T.    	//grava o pedido com bloqueio de Valor - (PE MTA410T)
					EndIf
				EndIf
			Else
				/*		-----------------------------------------------
				Verifica se o Pedido serï¿½ bloqueado por Regra
				-----------------------------------------------*/
				If ApMsgYesNo("Desconto Concedido estï¿½ acima do Permitido pela Regra. Redigitar Descontos (S/N)?",,"INFO")
					_lRet := .F.    //Nao grava o pedido e retorna para a tela para mudancas no valor
				Else
					ApMsgAlert("Pedido serï¿½ gravado com Bloqueio de Regra","Bloqueio de Regra")
					_lRet       := .T.    	//grava o pedido com bloqueio de regra - (PE MTA410T)
				EndIf
			EndIf
		Else //Alterado para tratar bloqueio de pedido sem regra na alteracao - 24.10.07
			_xlBlqRegra := .T.
			_xlBlqPed   := .T.
			_lRet       := .T.    	//grava o pedido com bloqueio de regra - (PE MTA410T)
			ApMsgAlert("Pedido Sem Regra - Bloqueado","Bloqueio de Regra")
		EndIf

		If !lOper
			_lRet  := lOper
		EndIf
		RestArea(_aArea)
	EndIf
	/*
	----------------------------------------------
	Calcula o Peso Liquido e Bruto Total do Pedido
	----------------------------------------------*/
	cCodPro := ""
	For _nCnt := 1 To Len(aCols)
		If acols[_nCnt,Len(aCols[_nCnt])] == .F.	//Verifica se linha esta deletada
			If cCodPro != aCols[_nCnt,nPosProd]
				cCodPro := aCols[_nCnt,nPosProd]
				nPesoLiqT += (Posicione("SB1",1,xFilial("SB1")+aCols[_nCnt,nPosProd],"B1_PESO") * aCols[_nCnt,nPQtdVen])
				nPesoBrtT += (Posicione("SB1",1,xFilial("SB1")+aCols[_nCnt,nPosProd],"B1_PESBRU") * aCols[_nCnt,nPQtdVen])
			EndIf
		EndIf
	Next
	M->C5_X_PBRUT := nPesoBrtT

	If M->C5_TIPO $ "NCIP"
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+M->(C5_CLIENTE+C5_LOJACLI))

//		DbSelectArea("SB1")
//		DbSetOrder(1)
//		DbSeek(xFilial("SB1")+M->(C6_PRODUTO))

		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+M->C5_VEND1)
			For _x := 1 to Len(aCols)

				//If SA3->A3_TIPO == 'I' .AND. SA1->A1_COMIS == 0
				If SA3->A3_TIPO == 'I' .AND. SA1->A1_COMIS == 0
					GdFieldPut("C6_COMIS1",M->C5_COMIS1,_x)
					M->C5_XNCOMIS := '2'
				//Elseif M->XCOMCLI <> 0
				Elseif SA1->A1_COMIS <> 0
					//GdFieldPut("C6_COMIS1",M->C5_XCOMCLI,_x)
					GdFieldPut("C6_COMIS1",SA1->A1_COMIS,_x)
					M->C5_XNCOMIS := '3'
				Else
					M->C5_XNCOMIS := '1'
					GdFieldPut("C6_COMIS1",Posicione("SB1",1,xFilial("SB1")+aCols[_x,nPosProd],"B1_COMIS"),_x)
				Endif

			Next
		EndIf
	EndIf


Return(_lRet)
