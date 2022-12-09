#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.CH"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
#IFNDEF ENTER
	#Define ENTER Chr(13) + Chr(10)
#ENDIF
User Function TWFAT43()
	Local cPerg         := 'TWFAT43'
	Local aIndArq       := {}
	Local cString       := 'TTRB'
	Private cCondicao	:= ""
	Private aCposBrw  := {}
	Private cArqTMP := ''
	Private aRotina := {}
	Private aCores    := {}

	aRotina := { { "Pesquisar","AxPesqui",0,1},;
		{ 'Legenda',"U_TWLEG43", 0 , 5}}


	ValidPerg(cPerg)
	If !Pergunte (cPerg,.T.)
		Return()
	Endif

	MontaTrb()

	DbSelectArea("TTRB")
	DbGotop()

	aCores := {{ "TTRB->STATUS == '9'", "ENABLE"   },;
		{ "TTRB->STATUS == 'C'", "BR_AZUL"   },;
		{ "TTRB->STATUS == 'E'", "BR_CINZA"   },;
		{ "TTRB->STATUS == 'F'", "BR_LARANJA"   },;
		{ "TTRB->STATUS == ' ' .Or. TTRB->STATUS == '0' ", "DISABLE"   },;
		{ "TTRB->STATUS $ '12345678'","BR_AMARELO" }}


	mBrowse( 6, 1,22,75,cString,aCposBrw,,,,,aCores)

	TTRB->(dbCloseArea())

	&& Fecha arquivos de trabalho
	fErase(cArqTMP + OrdBagExt())

	Return

User Function TWLEG43()
	Local aCores := {}

	aCores := {	{"ENABLE",'Ordem Separação Gerada'},;
		{"BR_AZUL",'Pedido Com Bloqueio Credito'},;
		{"BR_CINZA",'Pedido Com Bloqueio Estoque'},;
		{"DISABLE",'Ordem Separação Não Inciada'},;
		{"BR_LARANJA",'Pedido Faturado'},;
		{"BR_AMARELO",'Ordem Separação em Andamento'}}

	BrwLegenda('Documento','Legenda',aCores)

	Return(.T.)


Static Function MontaTrb()
	Local cQuery := " "
	Local aEstrut     := {}
	Local aComb    := {}
	Local cStatus  := ''

	aAdd(aCposBrw,      { "Filial"           , "FILIAL"          ,     "C"     , TamSx3("C6_FILIAL")[1]  , 0, ""})
	aAdd(aCposBrw,      { "Pedido"           , "PED"             ,     "C"     , TamSx3("C6_NUM")[1]     , 0, ""})
	aAdd(aCposBrw,      { "Item"             , "ITEM"            ,     "C"     , TamSx3("C6_ITEM")[1]    , 0, ""})
	aAdd(aCposBrw,      { "Produto"          , "PROD"            ,     "C"     , TamSx3("C6_PRODUTO")[1] , 0, ""})
	aAdd(aCposBrw,      { "Qtd. Ven"         , "QTDVEN"          ,     "N"     , TamSx3("C9_QTDLIB")[1]  ,TamSX3("C9_QTDLIB")[2], ""})
	aAdd(aCposBrw,      { "Qtd. Lib"         , "QTDLIB"          ,     "N"     , TamSx3("C9_QTDLIB")[1]  ,TamSX3("C9_QTDLIB")[2], ""})
	aAdd(aCposBrw,      { "Dt. Libera"       , "DATALIB"         ,     "D"     , 8                       , 0, ""})
	aAdd(aCposBrw,      { "Nota Fiscal"      , "NOTA"            ,     "C"     , TamSx3("D2_DOC")[1]     , 0, ""})
	aAdd(aCposBrw,      { "Ord. Separa"      , "ORDSEP"          ,     "C"     , TamSx3("C9_ORDSEP")[1]  , 0, ""})
	aAdd(aCposBrw,      { "Status"           , "STATUS"          ,     "C"     , TamSx3("CB7_STATUS")[1] , 0, ""})

	aAdd(aEstrut,     { "ORDEM" , "C", 1, 0})

	For nX := 1 To Len(aCposBrw)
		aAdd(aEstrut,     { aCposBrw[nX,2], aCposBrw[nX,3], aCposBrw[nX,4], aCposBrw[nX,5]})
	Next nX

	cArqTMP := CriaTrab(aEstrut, .T.)
	dbUseArea(.T.,, cArqTMP, "TTRB", .T., .F.)
	IndRegua( "TTRB", cArqTMP, "ORDEM",,,"Indexando registros..." )

	DbSelectArea("TTRB")
	TTRB->(dbClearIndex())
	TTRB->(dbSetIndex(cArqTMP + OrdBagExt()))

	cQuery := " SELECT C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO,C6_QTDVEN,C9_QTDLIB,C9_DATALIB,C9_BLCRED,C9_BLEST,C9_ORDSEP,C9_NFISCAL FROM " + RetsqlTab("SC6") "
	cQuery += " INNER JOIN " + RetsqlTab("SC9") + " ON C6_FILIAL = C9_FILIAL AND  C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND C6_CLI = C9_CLIENTE AND C6_LOJA = C9_LOJA AND  SC9.D_E_L_E_T_ = '' "
	cQuery += " WHERE C6_FILIAL = '" + xFilial("SF2") + "' "
	cQuery += " AND C6_QTDENT < C6_QTDVEN AND C6_BLQ <> 'R' "
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " AND C6_NUM >= '" + MV_PAR01 + "' "
	cQuery += " AND C6_NUM <= '" + MV_PAR02 + "' "
	cQuery += " AND C9_DATALIB >= '" + DTOS(Mv_Par03) + "' "
	cQuery += " AND C9_DATALIB <= '" + DTOS(Mv_Par04)+ "' "
	cQuery += " AND C9_CLIENTE >= '" + MV_PAR05 + "' "
	cQuery += " AND C9_CLIENTE <= '" + MV_PAR06 + "' "
	cQuery += " AND C9_LOJA >= '" + MV_PAR07 + "' "
	cQuery += " AND C9_LOJA <= '" + MV_PAR08 + "' "
	cQuery += " ORDER BY C6_NUM + C6_CLI + C6_LOJA + C9_DATALIB  "

	Queryy := ChangeQuery(cQuery)

	TCQuery Queryy NEW ALIAS "TRB"

	While TRB->(!Eof())
		DbSelectArea("TTRB")
		IF RecLock("TTRB",.T.)
			TTRB->FILIAL   :=  TRB->C6_FILIAL
			TTRB->PED      :=  TRB->C6_NUM
			TTRB->ITEM     :=  TRB->C6_ITEM
			TTRB->PROD     :=  TRB->C6_PRODUTO
			TTRB->QTDVEN   :=  TRB->C6_QTDVEN
			TTRB->QTDLIB   :=  TRB->C9_QTDLIB
			TTRB->DATALIB  :=  STOD(TRB->C9_DATALIB)
			TTRB->NOTA     :=  ''
			TTRB->ORDSEP   :=  ''
			If !EmpTy(TRB->C9_ORDSEP) .And. Empty(TRB->C9_NFISCAL)
				CB7->(DbSetOrder(1))
				If CB7->(DbSeek(xFilial('CB7') + TRB->C9_ORDSEP))
					cStatus := CB7->CB7_STATUS
					TTRB->ORDSEP := TRB->C9_ORDSEP
				EndIf
			ElseIf !Empty(TRB->C9_NFISCAL)
				cStatus := 'F'
				TTRB->NOTA  := TRB->C9_NFISCAL
			ElseIf TRB->C9_BLCRED == '01'
				cStatus := 'C'
			ElseIf TRB->C9_BLEST  == '02'
				cStatus := 'E'
			ElseIf EmpTy(TRB->C9_ORDSEP) .And. Empty(TRB->C9_NFISCAL) .And. Empty(TRB->C9_BLCRED)  .And. Empty(TRB->C9_BLEST)
			EndIF
			TTRB->STATUS  := cStatus
			MsunLock()
			TRB->(DbSkip())
		EndIf
	Enddo
	TRB->( DbCloseArea() )

	Return


Static Function ValidPerg(cPerg)

	Local sAlias 	:= Alias()
	Local aRegs 	:= {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	aAdd(aRegs,{cPerg,"01","Pedido De:"  ,"Pedido De:"  ,"Pedido De:" ,"MV_CH1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Pedido Ate:" ,"Pedido Ate:" ,"Pedido Ate:","MV_CH2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Data De:"    ,"Data De:"    ,"Data De:"    ,"MV_CH3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Data Ate:"   ,"Data Ate:"   ,"Data Ate:"   ,"MV_CH4","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Cliente De:" ,"Cliente De:" ,"Cliente De:" ,"MV_CH5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Cliente Ate:","Cliente Ate:","Cliente Ate:","MV_CH6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Loja De:"    ,"Loja De:"    ,"Loja De:"    ,"MV_CH7","C",02,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","Loja Ate:"   ,"Loja Ate:"   ,"Loja Ate:"   ,"MV_CH8","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i := 1 to Len(aRegs)
		If !dbSeek (cPerg + aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(sAlias)
	Return()
