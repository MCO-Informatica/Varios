/*
------------------------------------------------------------------------------
Programa : M410LIOK			| Tipo: Ponto de Entrada		| Rotina: MATA410
Data     : 19/03/07
------------------------------------------------------------------------------
Descricao: 
Duplicar a linha anterior do item conforme TES e a Regra de Faturamento
------------------------------------------------------------------------------
*/
User Function M410LIOK()
Local _nLin, _nItem,_aNewLin, _nPosItem,_nPosProd,_nPosQtVen,_nPosQtLib,_nPosSdLib,_nPosLote,_cCodPro,_cLote,_cRegiao
Local _nSaldoLote := _nQtdVen := _nQtdLib := _nSldLib := 0
Local _lDupLinha := .F. 
Local _nPerc := 0
//-- Alt. 04.09.07-TES INTELIGENTE
Local _cGrupo,cCodReg	 					
Local cUFDestino:= SA1->A1_EST
Local cEstNorte := GETMV("MV_NORTE")

Public _lRegraDsc := .F.
Public cAlqIcms
Public nTotalPed   

_aAlias := Alias()
_nRecno := Recno()
_nOrder := IndexOrd()
_nLin   := Len(aCols)             

_nPosItem := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_ITEM"})
_nPosQtVen:= aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_QTDVEN" })
_nPosPrVen:= aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_PRCVEN"})
_nPosValor:= aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_VALOR"})
_nPosTes  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_TES"})
_nPosDesc := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_DESCONT"})
_nPosVlrD := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_VALDESC"})
_nPosPLst := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_PRUNIT"})
_nPosPLst2:= aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_X_PRLST"})
_nPosProd := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_PRODUTO"})	//	-- Alt. 04.09.07-TES INTELIGENTE
_nPosOper := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_OPER"})		//	-- Alt. 04.09.07-TES INTELIGENTE
_nPosCFO  := aScan(aHeader,{|x|Upper(AllTrim(x[2])) == "C6_CF"})		//	-- Alt. 06.09.07-TES INTELIGENTE

_cTES	  := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_TES"})]
_cProduto := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRODUTO"})]
_cLocal	  := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_LOCAL"})]
_lRet	  := .t.

_nPrcTab  := aCols[n,_nPosPrVen]    

//Add João Zabotto 13/02/2017 - Validar regras pela rotina padrão
//Return (.T.)


If Subs(_cProduto,1,1)$"Z"
 	If _cTES < '600' .Or. _cTES > '699'
   		MsgStop("TES informada fora do range 600 à 699 não é permitido.","TES Errada")
   		_lRet := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. !Subs(_cLocal,1,1)$"P"
   		MsgStop("Armazém informado fora do range P0 à P9 não é permitido.","Armazém Errado")
   		_lRet := .f.
   	EndIf
ElseIf !Subs(_cProduto,1,1)$"Z" .And. Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S"
 	If _cTES >= '600' .And. _cTES <= '699'
   		MsgStop("TES informada dentro do range 600 à 699 não permitido.","TES Errada")
   		_lRet := .f.
   	EndIf
   	
   	If Posicione("SF4",1,xFilial("SF4")+_cTES,"F4_ESTOQUE")$"S" .and. Subs(_cLocal,1,1)$"P"
   		MsgStop("Armazém informado dentro do range P0 à P9 não é permitido.","Armazém Errado")
   		_lRet := .f.
   	EndIf
EndIf



/*
-----------------------------------------------
Verifica se foi digitado desconto para o item 
sem ter sido informado o código da Regra
-----------------------------------------------*/            
If Empty(M->C5_X_CODRE) 
	If acols[N,Len(aCols[N])] == .F.	//Verifica se linha esta deletada
		If M->C5_TIPO == "N"   
			_xlBlqPed   := .T.	  //Pedido será bloqueado
			_xlBlqRegra := .T.    //Pedido será bloqueado por Regra
		EndIf
	Else
		Return(.T.)
	EndIf
EndIf

/*
----------------------------------
Atualiza variaveis
----------------------------------*/
If N < Len(aCols)
	Return(.T.)
EndIf

If !Empty(M->C5_X_CODRE)
	If acols[N,Len(aCols[N])] == .F.				//Verifica se linha esta deletada
//		If aCols[N,_nPosTes] $ '601/602/603'  		-- Alt. 04.09.07-TES INTELIGENTE
		If Substr(aCols[N,_nPosTes],1,1) $ '6'		//linha nao devera ser clonada
			Return(.T.)
		EndIf
	Else
		Return(.T.)
	EndIf
EndIf

/*
-------------------------------------------
Valida a Validade da Tabela de Preço - 24092020 - Marcos Floridi - Fix System
-------------------------------------------
*/
If M->C5_TIPO == "N"

	_cCodTab := M->C5_TABELA

	_dDtVal  := Posicione("DA0",1,xfilial("DA0")+_cCodTab,"DA0_DATATE")

	If _dDtVal < DDATABASE
		MsgStop("Tabela fora de Vigencia, Favor Verificar !!!! ","Tabela fora de Vigencia")
		_lRet := .f.
	Endif
Endif

/*		
------------------------------------------
Alterado para contemplar o TES INTELIGENTE
------------------------------------------*/
If cUFDestino == 'SP'
	cCodReg  := '1'   
Else
	If cUFDestino $ cEstNorte
		cCodReg  := '2'  
	Else
		cCodReg  := '3'
	EndIf
EndIf
_cGrupo  := Posicione("SB1",1,xFilial("SB1")+aCols[n,_nPosProd],"B1_GRUPO")
_cNewTes := Posicione("SZ0",1,xFilial("SZ0")+M->C5_X_CODRE+_cGrupo+cCodReg,"Z0_TESOPER")

If !Empty(M->C5_X_CODRE)   
	If Alltrim(M->C5_X_CODRE) == '5130'	
		_lDupLinha := .T.

		_nPerc   := Round(((100/3)/100),5) 	
		_nQtdVen := aCols[n,_nPosQtVen]
		_nPrcVen := Round((aCols[n,_nPosPrVen] * _nPerc ),3)
		_nValor  := Round(_nQtdVen * _nPrcVen,2)

		aCols[n,_nPosPLst] := Round((aCols[n,_nPosPLst2] * _nPerc ),3)

    ElseIf Alltrim(M->C5_X_CODRE) == '5150'	
		_lDupLinha := .T.

		_nPerc   := Round((Val(Right(Alltrim(M->C5_X_CODRE),2))/100),2)
		_nQtdVen := aCols[n,_nPosQtVen]
		_nPrcVen := Round((aCols[n,_nPosPrVen] * _nPerc ),3)
		_nValor  := Round(_nQtdVen * _nPrcVen,2)

		aCols[n,_nPosPLst] := Round((aCols[n,_nPosPLst2] * _nPerc ),3)
    EndIf

	If _lDupLinha 
		/*
		----------------------------
		Clona a linha corrente      
		----------------------------*/
	   	aCols[n,_nPosPrVen]:= _nPrcVen
		aCols[n,_nPosValor]:= _nValor

        aCols[n,_nPosVlrD] := Round((aCols[n,_nPosPLst] - _nPrcVen) * _nQtdVen,3)
		
		_nItem   := aCols[n,_nPosItem]
   		_aNewLin := Aclone(acols[n])       
/* 		----------------------------
	 	Atualiza o item clonado
 		----------------------------*/
		_nPrcVen2 := _nPrcTab - _nPrcVen
		_nValor   := Round(_nQtdVen * _nPrcVen2,2)

//	   	_aNewLin[_nPosItem ] := STRZERO((_nLin + 1),2)
	   	_aNewLin[_nPosItem ] := Soma1(_nItem)       //Alterado em 29.11.07
   		_aNewLin[_nPosPrVen] := _nPrcVen2
	   	_aNewLin[_nPosValor] := _nValor 
   		_aNewLin[_nPosTes  ] := _cNewTes
		_aNewLin[_nPosPLst ] := Round((aCols[n,_nPosPLst2] * (1 - _nPerc)),3)
        _aNewLin[_nPosVlrD ] := Round((_aNewLin[_nPosPLst] - _nPrcVen2) * _nQtdVen,2)
		_aNewLin[_nPosOper ] := ""		//Tipo de Operacao - deve ser branco na linha clonada
		_aNewLin[_nPosCFO  ] := Posicione("SF4",1,xFilial("SF4")+_cNewTes,"F4_CF")	//Atualiza CFO para o TES

		If cUFDestino == "EX"
			_aNewLin[_nPosCFO]:= "7" + Substr(_aNewLin[_nPosCFO],2,3)
		ElseIf cUFDestino != "SP"
			_aNewLin[_nPosCFO]:= "6" + Substr(_aNewLin[_nPosCFO],2,3)
		EndIf
/*    	----------------------------
    	Adiciona nova linha ao aCols
	    ----------------------------*/
	   	AADD(acols,_aNewLin)      
	EndIf
EndIf
Return(_lRet)
