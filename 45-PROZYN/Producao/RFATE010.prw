#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RFATE010 ³ Autor ³ Adriano Leonardo    ³ Data ³ 14/11/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para cálculo da previsão de entrega do produto no   º±±
±±º          ³ pedido de vendas.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RFATE010(_cProduto,_nQuant)   
	
	Local _aSavArea 	:= GetArea()
	Local _aSavSB1	 	:= SB1->(GetArea())
	Local _aSavSG1	 	:= SG1->(GetArea())
	Local _cRotina		:= "RFATE010"
	Local _nTotPrazo	:= 0  // Prazo de Entrega total do produto
	Local nPrazoNiv		:= 0  // Prazo de Entrega deste Nivel
	Local nTestPrazo	:= 0  // Prazo de Entrega teste (se maior que o atual, se torna o atual)
	Local nNivel		:= "" // Nivel da Estrutura em que esta sendo feito o calculo
	Local cNomeArq		:= ""
	Local i				:= 0
	Local _nSldDisp		:= 0
	Default _cProduto	:= ""
	Default _nQuant		:= 0
	Private _dDtEnt		:= dDataBase
	Private nEstru		:= 0
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If dbSeek(xFilial("SB2")+_cProduto)
		While SB2->(!EOF()) .And. SB2->B2_FILIAL==xFilial("SB2") .And. SB2->B2_COD==PADR(_cProduto,TAMSX3("B1_COD")[01])
			If SB2->B2_LOCAL <> SuperGetMV("MV_CQ",,"98")
				_nSldDisp += SaldoSB2()
			EndIf
			
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSkip()
		EndDo
	EndIf
	
	If _nSldDisp < _nQuant
		cNomeArq := Estrut2(PADR(_cProduto,TAMSX3("B1_COD")[01]),_nQuant)
		
		dbSelectArea("ESTRUT")
		For i := ESTRUT->(LastRec()) to 1 Step -1
			ESTRUT->(dbGoto(i))
	
			_nSldDisp := 0
			
			dbSelectArea("SB2")
			dbSetOrder(1) //Filial + Produto + Armazém
			dbSeek(xFilial("SB2")+ESTRUT->COMP)
			
			While SB2->(!EOF()) .And. SB2->B2_FILIAL==xFilial("SB2") .And. AllTrim(SB2->B2_COD)==AllTrim(ESTRUT->COMP)
				
				If SB2->B2_LOCAL <> SuperGetMV("MV_CQ",,"98")
					_nSldDisp += SaldoSB2()
				EndIf
				
				dbSelectArea("SB2")
				dbSetOrder(1) //Filial + Produto + Armazém
				dbSkip()
			EndDo
			
			If Empty(nNivel)
				nNivel    := ESTRUT->NIVEL
				
				If  _nSldDisp < ESTRUT->QUANT
					nPrazoNiv := CalcPrazo(ESTRUT->COMP, ESTRUT->QUANT)
				EndIf
			ElseIf !Empty(nNivel)
				If ESTRUT->NIVEL < nNivel
					nNivel    := ESTRUT->NIVEL
					_nTotPrazo += nPrazoNiv
					
					If _nSldDisp < ESTRUT->QUANT
						nPrazoNiv := CalcPrazo(ESTRUT->COMP, ESTRUT->QUANT)
					EndIf
				Else
					If _nSldDisp < ESTRUT->QUANT
						nTestPrazo := CalcPrazo(ESTRUT->COMP, ESTRUT->QUANT)
					Else
						nTestPrazo := 0
					EndIf
					
					If nTestPrazo > nPrazoNiv
						nPrazoNiv := nTestPrazo
					EndIf
				EndIf
			EndIf
			// Soma Prazo do Ultimo
			If i == 1
				_nTotPrazo += nPrazoNiv
			EndIf
		Next i
	EndIf
	
	RestArea(_aSavSB1)
	RestArea(_aSavSG1)
	RestArea(_aSavArea)
	
Return(_nTotPrazo)