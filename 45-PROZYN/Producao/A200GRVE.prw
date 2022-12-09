
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'DBTREE.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ A200GRVE ³ Autor ³ Adriano Leonardo    ³ Data ³ 14/07/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar a confirmação da estrutura e º±±
±±º          ³ recalcular as quantiadades das enzimas e dos diluentes.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function A200GRVE()

Local _aSavArea 	:= GetArea()
Local _cRotina		:= "A200GRVE"
Local _cOpc			:= PARAMIXB[1]
// Local _lShowMap		:= PARAMIXB[2]
// Local _aRecDel		:= PARAMIXB[3]
// Local _aRecOper		:= PARAMIXB[4]
// Local _lRet			:= .T.
Local _aRecDil		:= {}
Local _nQtdTot		:= 0
Local _nCont		:= 1
Local _nQtdDil		:= 0
Local _nQtdComp		:= 0
// Local _aSize		:= MsAdvSize()
// Local _cTitulo		:= "Mapa de estrutura"
Private _oTree
Public _oDlg

If _cOpc == 3 .Or. _cOpc == 4 //Inclusão ou alteração
	dbSelectArea("SG1")
	dbSetOrder(1)
	If dbSeek(xFilial("SG1")+cProduto)
		While SG1->(!EOF()) .And. SG1->G1_FILIAL==xFilial("SG1") .And. SG1->G1_COD==cProduto
			If (SG1->G1_INI <= dDataBase .And. SG1->G1_FIM >= dDataBase)
				If SG1->G1_TIPO = '1' //Diluente
					AAdd(_aRecDil,{SG1->(Recno()),SG1->G1_PERCDIL})
				ElseIf SG1->G1_TIPO=='2' //Enzima
					RecLock("SG1",.F.)
						SG1->G1_QUANT	:= (SG1->G1_ATIVIDA/U_RPCPE001(SG1->G1_COMP))*nQtdBase
					SG1->(MsUnlock())
					_nQtdTot	+= SG1->G1_QUANT
					_nQtdComp	+= SG1->G1_QUANT
				ElseIf SG1->G1_TIPO = '4' //Ingrediente
					_nQtdTot	+= SG1->G1_QUANT
					_nQtdComp	+= SG1->G1_QUANT
				EndIf
			EndIf
			
			dbSelectArea("SG1")
			dbSetOrder(1)
			dbSkip()
		EndDo
		
		_nQtdDil := nQtdBase - _nQtdTot
		
		//Valido se o cálculo do diluente ficou negativo
		If _nQtdDil < 0
			MsgStop("Atenção, a soma dos componentes (exceto embalagem) ultrapassam a quantidade base da estrutura!",_cRotina+"_001")
			Return()
		EndIf
		
		_nSomPerc := 0
		
		For _nCont := 1 To Len(_aRecDil)
			_nSomPerc += _aRecDil[_nCont,2]
		Next
		
		//Valido se o rateio de diluentes completa 100%
		If _nSomPerc <> 100 .And. Len(_aRecDil)>1
			MsgStop("Atenção, a soma dos percentuais dos diluentes não representa 100%!",_cRotina+"_002")
			Return()
		EndIf
		
		For _nCont := 1 To Len(_aRecDil)
			dbSelectArea("SG1")
			dbGoto(_aRecDil[_nCont][1])
			
			//Percentual de rateio do diluente (para casos em que há mais de um diluente na fórmula)
			_nPercDil := SG1->G1_PERCDIL
			
			If _nPercDil == 0
				_nPercDil := 100
			EndIf
			
			RecLock("SG1",.F.)
				SG1->G1_QUANT := _nQtdDil * (_nPercDil/100)
				_nQtdComp += SG1->G1_QUANT
				If SG1->G1_PERCDIL == 0
					SG1->G1_PERCDIL := 100
				EndIf
			SG1->(MsUnlock())
		Next
		
		//Valido se o rateio de diluentes completa 100%
		If _nQtdComp <> nQtdBase
			MsgStop("Atenção, a soma dos componentes (exceto embalagens), não confere com a quantidade base da estrutura!",_cRotina+"_003")
			Return()
		EndIf
		
		//Chamada da rotina de mapa da estrutura
		If ExistBlock("RPCPE002") .and. ValType(oTree) != 'U'
			U_RPCPE002(nQtdBase, oTree)
		EndIf
		
	EndIf
EndIf

RestArea(_aSavArea)

Return()
