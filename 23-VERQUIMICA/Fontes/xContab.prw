#Include "Protheus.Ch"
#Include "RwMake.Ch"
#Include "Topconn.Ch"


User Function xContab(_Tipo)

LOCAL aArea := GetArea()

_lRet := .T.

IF _Tipo == "S"   // Saída
	DbSelectArea("SF4")
	DbSetOrder(1)
	IF DbSeek(xFilial("SF4")+SD2->D2_TES)
		IF SF4->F4_XCONTAB <> "S"
			_lRet := .F.
		EndIF
	EndIF
EndIF

IF _Tipo == "I"  // Impostos
	DbSelectArea("SF4")
	DbSetOrder(1)
	IF SF4->F4_CODIGO >= "500"
		IF DbSeek(xFilial("SF4")+SD2->D2_TES)
			IF SF4->F4_XCONTAB <> "S" .and. SF4->F4_XCONTAB <> "I"
				_lRet := .F.
			EndIF
		EndIF
	Else
		IF DbSeek(xFilial("SF4")+SD1->D1_TES)
			IF SF4->F4_XCONTAB <> "S" .and. SF4->F4_XCONTAB <> "I"
				_lRet := .F.
			EndIF
		EndIF
	EndIF
EndIF

IF _Tipo == "E"  // Entrada
	DbSelectArea("SF4")
	DbSetOrder(1)
	IF DbSeek(xFilial("SF4")+SD1->D1_TES)
		IF SF4->F4_XCONTAB <> "S"
			_lRet := .F.
		EndIF
	EndIF
EndIF

IF _Tipo == "M"  // Servico
	DbSelectArea("SF4")
	DbSetOrder(1)
	IF DbSeek(xFilial("SF4")+SD1->D1_TES)
		IF SF4->F4_XCONTAB <> "M"
			_lRet := .F.
		EndIF
	EndIF
EndIF     

RestArea(aArea)

Return(_lRet)


// Utilizado nos lançamentos padronizados do Compras - 650
// Desenvolvimento: ARMI Consultoria
// Data: 09/01/14
// Define os valores de contabilização do PCC

User Function _xPCC(WTIP)

Local aAreaSE2 := SE2->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local aArea    := GetArea()
Local WCHAV    := ""
Local nVAL     := 0

IF VAL(IF(WTIP=1,CTBANFE->D1_ITEM,SD1->D1_ITEM)) = 1
	IF !(IF(WTIP=1,CTBANFE->D1_TIPO,SD1->D1_TIPO) $ "BD")
		SE2->(DBSETORDER(6))
		IF WTIP = 1
			WCHAV := xFILIAL("SE2")+CTBANFE->D1_FORNECE+CTBANFE->D1_LOJA+CTBANFE->D1_SERIE+CTBANFE->D1_DOC
		ELSE
			WCHAV := xFILIAL("SE2")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC
		ENDIF
		IF SE2->(DBSEEK(WCHAV))
			DO WHILE !SE2->(EOF()) .AND. (WCHAV) == (SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM)
				nVAL += (SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL)
				SE2->(DBSKIP())
			ENDDO
		ENDIF
	ENDIF
ENDIF

RestArea(aAreaSE2)
RestArea(aAreaSD1)
RestArea(aArea)

RETURN(nVAL)


// Utilizado nos lançamentos contábeis do financeiro
// Desenvolvimento: ARMI Consultoria
// Data: 09/01/14
// Utilizado para padronizar o histórico dos lançamentos
// Tipos
// E1 - Receber
// E2 - Fornecedor
// E5 - MB

User Function FinHist(_cTipo)

IF _cTipo == "E1"
	
	_PREFIXO := SE1->E1_PREFIXO
	_NUM  := SE1->E1_NUM
	_PARCELA := SE1->E1_PARCELA
	_NREDUZ  := SA1->A1_NREDUZ
	
ElseIF _cTipo == "E2"
	
	_PREFIXO := SE2->E2_PREFIXO
	_NUM  := SE2->E2_NUM
	_PARCELA := SE2->E2_PARCELA
	_NREDUZ  := SA2->A2_NREDUZ
	
ElseIF _cTipo == "EZ"
	
	_PREFIXO := SEZ->EZ_PREFIXO
	_NUM  := SEZ->EZ_NUM
	_PARCELA := SEZ->EZ_PARCELA
	_NREDUZ  := SA2->A2_NREDUZ
	
ElseIF _cTipo == "E5"
	
	_PREFIXO := SE5->E5_PREFIXO
	_NUM  := SE5->E5_NUMERO
	_PARCELA := SE5->E5_PARCELA
	
	IF Alltrim(SE5->E5_RECPAG) == "R"
		_NREDUZ  := SA1->A1_NREDUZ
	ElseIF Alltrim(SE5->E5_RECPAG) == "P"
		_NREDUZ  := SA2->A2_NREDUZ
	Else
		_NREDUZ := ""
	EndIF
	
	
EndIF

_cHist := "-"

IF AllTrim(_PREFIXO) <> ""
	_cHist += AllTrim(_PREFIXO) + "-"
EndIF

IF AllTrim(_NUM) <> ""
	_cHist += AllTrim(_NUM) + "-"
EndIF

IF AllTrim(_PARCELA) <> ""
	_cHist += AllTrim(_PARCELA) + "-"
EndIF

IF AllTrim(_NREDUZ) <> ""
	_cHist += Alltrim(Substr(_NREDUZ,1,15))
EndIF

Return(_cHist)


// Programa que permite alterar o parametro MV_DATAFIN através do menu do usuário

User Function _dFIN()

Local _aArea := GetArea()

Private dataf    := GETMV("MV_DATAFIN")

@ 148,102 To 300,440 Dialog janela Title OemToAnsi("Bloqueio de movimentos ate a data informada")
@ 015,015 Say OemToAnsi("Nova Data Financeiro")
@ 014,080 Get dataf Valid .t. SIZE 35,15
@ 030,015 Say OemToAnsi("Obs.: Lancamentos permitidos a partir da nova data")
@ 040,085 BmpButton Type 2 Action close(janela)
@ 040,130 BmpButton Type 1 Action (acerto(),close(janela))

Activate Dialog janela Centered

RestArea(_aArea)

Return

Static Function acerto()

putmv("MV_DATAFIN",dtoc(DATAf))
msgbox("Lancamentos financeiros bloqueados até a data: "+dtoc(dataf) )

Return()

User Function Cria_It(_ES,_Tipo)

_Return := ""
_aArea := GetArea()
_lItem := .t.
			
IF _ES == "S"
	IF _Tipo == "C"
		_Codigo  := SA1->A1_COD
		_Loja     := SA1->A1_LOJA
		_Nome      := SA1->A1_NOME
		_ItemSup := "C000000"
	ElseIF _Tipo == "F"
		_Codigo  := SA2->A2_COD
		_Loja     := SA2->A2_LOJA
		_Nome   := SA2->A2_NOME
		_ItemSup := "F000000"
		If Empty(SA2->A2_CONTA) .OR. !Left(SA2->A2_CONTA,7) $ "2110101/2110102"
			_lItem := .f.
		Else
			_lItem := .t.
		Endif
	EndIF
Else
	IF _Tipo == "C"                  
		_Codigo  := SA1->A1_COD
		_Loja     := SA1->A1_LOJA
		_Nome      := SA1->A1_NOME
		_ItemSup := "C000000"
	ElseIF _Tipo == "F"
		_Codigo  := SA2->A2_COD
		_Loja     := SA2->A2_LOJA
		_Nome   := SA2->A2_NOME
		_ItemSup := "F000000"
		If Empty(SA2->A2_CONTA) .OR. !Left(SA2->A2_CONTA,7) $ "2110101/2110102"
			_lItem := .f.
		Else
			_lItem := .t.
		Endif
	EndIF
EndIF

If _lItem
	_Item := _Tipo + _Codigo + _Loja   
Else
	_Item := ""
Endif
	
DbSelectArea("CTD")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial("CTD")+_Item)

IF !CTD->(Found())
	Reclock ( "CTD",.T. )
	CTD->CTD_FILIAL := xFilial("CTD")
	CTD->CTD_ITEM  := _Item
	CTD->CTD_DESC01 := Substr(AllTrim(_Nome),1,40)
	CTD->CTD_CLASSE := "2"
	CTD->CTD_ITSUP  := _ItemSup
	MsUnlock()
EndIF

_Return := CTD->CTD_ITEM

RestArea(_aArea)

Return(_Return)


// Cria Item Contabil

User Function CriaIt()

DbSelectArea("SA1")
DbGoTop()

While SA1->(!EOF())
	
	_ItemSup := "C000000"
	_Item   := "C" + SA1->A1_COD + SA1->A1_LOJA
	_Nome   := A1_NOME
	
	DbSelectArea("CTD")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("CTD")+_Item)
	
	IF !CTD->(Found())
		Reclock ( "CTD",.T. )
		CTD->CTD_FILIAL  := xFilial("CTD")
		CTD->CTD_ITEM  := _Item
		CTD->CTD_DESC01  := Substr(AllTrim(_Nome),1,40)
		CTD->CTD_CLASSE  := "2"
		CTD->CTD_ITSUP  := _ItemSup
		MsUnlock()
	EndIF
	
	SA1->(DbSkip())
End


DbSelectArea("SA2")
DbGoTop()

While SA2->(!EOF())
	
	_ItemSup:= "F000000"
	_Item  := "F" + SA2->A2_COD + SA2->A2_LOJA
	_Nome  := A2_NOME
	
	DbSelectArea("CTD")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("CTD")+_Item)
	
	IF !CTD->(Found())
		Reclock ( "CTD",.T. )
		CTD->CTD_FILIAL := xFilial("CTD")
		CTD->CTD_ITEM              := _Item
		CTD->CTD_DESC01 := Substr(AllTrim(_Nome),1,40)
		CTD->CTD_CLASSE         := "2"
		CTD->CTD_ITSUP            := _ItemSup
		MsUnlock()
	EndIF
	
	SA2->(DbSkip())
End

Return()

user Function Acha_Abat()

If SE2->E2_FATURA = "NOTFAT"  //é um titulo de fatura
	_cQry :=	" SELECT SUM(E2_VALOR) AS ABATIM FROM "+RetSqlName("SE2")+" SE2 "
	_cQry +=	" WHERE D_E_L_E_T_ = '' "
	_cQry +=	" AND E2_FATURA = '"+SE2->E2_NUM+"' "
	_cQry +=	" AND E2_FATPREF= '"+SE2->E2_PREFIXO+"' "
	_cQry +=	" AND E2_TIPO   = 'AB-' "
	_cQry := ChangeQuery(_cQry)
	TCQUERY _cQry NEW ALIAS "TRE2"
	DbSelectArea("TRE2")
	TRE2->(DbGoTop())
	_nValAbat := TRE2->ABATIM
	TRE2->(DbCloseArea())

	_cQry :=	" SELECT SUM(E2_VALOR) AS TOTAL FROM "+RetSqlName("SE2")+" SE2 "
	_cQry +=	" WHERE D_E_L_E_T_ = '' "
	_cQry +=	" AND E2_FATURA = '"+SE2->E2_NUM+"' "
	_cQry +=	" AND E2_FATPREF= '"+SE2->E2_PREFIXO+"' "
	_cQry +=	" AND E2_TIPO   <> 'AB-' "
	_cQry := ChangeQuery(_cQry)
	TCQUERY _cQry NEW ALIAS "TRE2"
	DbSelectArea("TRE2")
	TRE2->(DbGoTop())
	_nValTot := TRE2->TOTAL
	TRE2->(DbCloseArea())

	_nLiquido := _nValTot - _nValAbat
	
	_nAbatim := SE5->E5_VALOR / _nLiquido * _nValAbat	

else
	_nAbatim := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA)
Endif

Return(_nAbatim)          


User Function Flag_SF2()

/*
Permite tirar o flag contabil das saidas
Nilza - 07/07/2016
*/  

cString   := "SF2"
cCadastro := "Tira flag de contabilizacao NF Saida"
aRotina   := { { "Pesquisa" , "AxPesqui", 0 , 1 } ,;
               { "Visualiza", "AxVisual", 0 , 2 } ,;
               { "Tira Flag", 'ExecBlock("Flag_F2A")', 0 , 3 } }

dbSelectArea("SF2")
dbSetOrder(1)
aCampos := { {"Data Contabil.","F2_DTLANC"} } 

mBrowse( 6,1,22,75,cString,aCampos)

Return


User Function Flag_F2A()

_dDataAnt := SF2->F2_DTLANC

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Tira flag Contabil"
@ 8,10 TO 84,222
@ 23,14  SAY "NF"
@ 23,64  SAY "Emissao"
@ 23,114 SAY "Cliente   "
@ 23,164 SAY "Data Cont."

@ 33,14  GET SF2->F2_DOC     when .f. Size 50,20
@ 33,64  GET SF2->F2_EMISSAO when .f. Size 50,20
@ 33,114 GET SF2->F2_FORNECE when .f. Size 50,20
@ 33,164 GET _dDataAnt       when .t. Size 50,20

@ 50,75  BMPBUTTON TYPE 1 ACTION OkProc2()
@ 50,130 BMPBUTTON TYPE 2 ACTION Close(oDlg5)

ACTIVATE DIALOG oDlg5

Static Function OkProc2()

Reclock("SF2",.f.)
Replace F2_DTLANC with _dDataAnt
MsUnlock()

Close(oDlg5)

Return

user Function VQAbatV2()
	_nAbatim := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA)
return (_nAbatim)
