#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RPCPC002 ³ Autor ³ Adriano Leonardo    ³ Data ³ 02/08/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de cadastro de amarração entre as famílias de produ-º±±
±±º          ³ tos (matriz cruzada)                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPC002()

Local _aSavArea := GetArea()
Local _aSavSZ4	:= SZ4->(GetArea())
Local _aSavSZ5	:= SZ5->(GetArea())

Local _aPergs	:={}
Static oDlg
Private _cRotina:= "RPCPC002"
Private _aSize  := MsAdvSize()
Private _cTipo	:= ""
  
aAdd( _aPergs ,{2,"Tipo de Família", "Po", {"Po","Liquido"},100,'.T.',.T.})

If ParamBox(@_aPergs, "Selecione a matriz desejada", NIL, NIL, NIL, .T.)
	_cTipo	:= SubStr(MV_PAR01,1,1)
Else
	Return()
EndIf

DEFINE MSDIALOG oDlg TITLE "Matriz Cruzada" FROM _aSize[1], _aSize[1]  TO _aSize[6], _aSize[5] COLORS 0, 16777215 PIXEL

	If !fMSNewGe1()
		Return()
	EndIf

	// Don't change the Align Order 
	oMSNewGe1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED

RestArea(_aSavSZ4)
RestArea(_aSavSZ5)
RestArea(_aSavArea)

Return()

//------------------------------------------------ 
Static Function fMSNewGe1()
//------------------------------------------------ 
Local nX
Local aHeaderEx 	:= {}
Local aColsEx		:= {}
Local aFieldFill	:= {}
Local aFields 		:= {"Família"}
Local aAlterFields 	:= {"Z5_ACAO"}
Local nFreeze		:= 1
Static oMSNewGe1

dbSelectArea("SZ4")
dbSetOrder(2)
dbSeek(xFilial("SZ4")+_cTipo)

While SZ4->(!EOF()) .And. xFilial("SZ4")==SZ4->Z4_FILIAL .And. SZ4->Z4_TIPO==_cTipo
    
	//Ignoro famílias bloqueadas
	If SF4->F4_MSBLQL <> "1" .And. SZ4->Z4_TIPO==_cTipo
		AAdd(aFields, AllTrim(SZ4->Z4_COD))
	EndIf
	
	dbSelectArea("SZ4")
	dbSetOrder(2)
	dbSkip()
EndDo

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If nX == 1
		If SX3->(DbSeek("Z5_COD1"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	Else
		If SX3->(DbSeek("Z5_ACAO"))
			Aadd(aHeaderEx, {AllTrim(aFields[nX]),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	EndIf
Next nX


dbSelectArea("SZ4")
dbSetOrder(2)
If dbSeek(xFilial("SZ4")+_cTipo)

	While SZ4->(!EOF()) .And. SZ4->Z4_FILIAL==xFilial("SZ4") .And. SZ4->Z4_TIPO==_cTipo
		
		aFieldFill := {}
		
		//Ignoro famílias bloqueadas
		If SF4->F4_MSBLQL <> "1"
			// Define field values
			For nX := 1 to Len(aFields)
				If nX == 1
					Aadd(aFieldFill, SZ4->Z4_COD)
				Else
					If SX3->(DbSeek("Z5_ACAO"))
						Aadd(aFieldFill, VldCruza(SZ4->Z4_COD,aFields[nX]))
					Endif
				EndIf
			Next nX
			
			Aadd(aFieldFill, .F.)
			Aadd(aColsEx, aFieldFill)
		EndIf
		
		dbSelectArea("SZ4")
		dbSetOrder(2)
		dbSkip()
	EndDo
Else
	MsgStop("Nenhuma família cadastrada para o tipo escolhido!",_cRotina+"_002")
	Return(.F.)
EndIf

oMSNewGe1 := MsNewGetDados():New( 000, 000, 250, 250, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,nFreeze, Len(aColsEx), "U_RPCPC02A", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return(.T.)

Static Function VldCruza(_cCod1, _cCod2)

Local _cRet		:= CriaVar(SX3->X3_CAMPO)
Default _cCod1	:= ""
Default _cCod2	:= ""

If !Empty(_cCod1) .And. !Empty(_cCod2)
	dbSelectArea("SZ5")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ5")+PadR(_cCod1,TamSx3("Z5_COD1")[01])+PadR(_cCod2,TamSx3("Z5_COD2")[01])+_cTipo)
		_cRet := SZ5->Z5_ACAO
	Else
		RecLock("SZ5",.T.)
			SZ5->Z5_FILIAL	:= xFilial("SZ5")
			SZ5->Z5_COD1	:= _cCod1
			SZ5->Z5_COD2	:= _cCod2
			SZ5->Z5_ACAO	:= _cRet
			SZ5->Z5_TIPO	:= _cTipo
		SZ5->(MsUnlock())
	EndIf
EndIf

Return(_cRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RPCPC02A ³ Autor ³ Adriano Leonardo    ³ Data ³ 04/08/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável por validar a opção definida pelo usuá- º±±
±±º          ³ rio (ação no cruzamento de família) e gravar a informação. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPC02A()

Local _lRet		:= .T.
Local _cCod1	:= oMsNewGe1:aCols[oMsNewGe1:oBrowse:nAt,1]
Local _cCod2	:= aHeader[oMsNewGe1:oBrowse:ColPos,1]

If !Empty(_cCod1) .And. !Empty(_cCod2)
	dbSelectArea("SZ5")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ5")+PadR(_cCod1,TamSx3("Z5_COD1")[01])+PadR(_cCod2,TamSx3("Z5_COD2")[01])+_cTipo)
		If (SZ5->Z5_TIPO=="P" .And. AllTrim(&(ReadVar()))=="AG") .Or. Empty(&(ReadVar())) .Or. (SZ5->Z5_TIPO=="L" .And. AllTrim(&(ReadVar())) $ "CC|AC|AM")
			MsgStop("Opção inválida para essa matriz!",_cRotina+"_001")
			_lRet := .F.
		Else
			RecLock("SZ5",.F.)
				SZ5->Z5_ACAO := &(ReadVar())
			SZ5->(MsUnlock())
		EndIf
	EndIf
EndIf

Return(_lRet)