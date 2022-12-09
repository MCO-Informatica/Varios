#Include "Protheus.ch"

/*                     
+===========================================================+
|Programa: ESTP003 |Autor: Antonio Carlos |Data: 08/07/08   |
+===========================================================+
|Descricao: Rotina responsavel em capturar os produtos      |
|digitados pelo leitor de codigo de barras na Pre-Nota.     |
+===========================================================+
|Uso: Laselva                                               |
+===========================================================+
*/

User Function ESTP003()

Private oDlg
Private cTitulo		:= "Recebimento Laselva"
Private cGetProd	:= Space(19)
Private oGetProd

Private nQtd		:= Space(5)
Private oGetQtd

Private oLbx
Private aEstru		:= {}
Private _aPedidos	:= {}

Aadd(aEstru,{Space(15),Space(50),Space(5),Space(6),Space(4)})

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 500,650 OF oMainWnd PIXEL

@ 020,008 Say "Qtde:" Size 051,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 020,070 MsGet oGetQtd  Var nQtd  		Size 20,009 COLOR CLR_BLACK Picture "@E 99999" PIXEL OF oDlg
@ 040,008 Say "Codigo do Produto:" 		Size 051,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 040,070 MsGet oGetProd Var cGetProd F3 "SB1" Size 115,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  Valid ( Empty(cGetProd) .OR. LS03REFRES() )

@ 060,8 LISTBOX oLbx FIELDS HEADER "Produto","Descricao","Qtde","Pedido","Item" SIZE 305,150 NOSCROLL OF oDlg PIXEL
oLbx:SetArray(aEstru)
oLbx:bLine:={|| {aEstru[oLbx:nAt,1],aEstru[oLbx:nAt,2],aEstru[oLbx:nAt,3],aEstru[oLbx:nAt,4],aEstru[oLbx:nAt,5]}}
oLbx:Refresh()

@ 220,258 Button "Estorna" 	Size 037,012 PIXEL OF oDlg ACTION(DelItem())

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| GrvRom(aEstru),oDlg:End()}, {|| oDlg:End()}, , {{"BMPINCLUIR",{|| LSVPesq()},"Pedidos"}})

Return

Static Function LS03REFRES()

Local aArea	:= GetArea()
Local nQtde	:= 1

/*
DbSelectArea("SB1")
SB1->(DbSetOrder(1))
If SB1->(Dbseek(xFilial("SB1")+cGetProd))
cGetProd := SB1->B1_COD
Else
DbSelectArea("SB1")
SB1->(DbSetOrder(5))
If SB1->(Dbseek(xFilial("SB1")+cGetProd))
cGetProd := SB1->B1_COD
Else
MsgStop("Produto nao cadastrado!")
Return(.F.)
EndIf
EndIf
*/

DbSelectArea("SB1")
SB1->(DbSetOrder(5))
If SB1->(Dbseek(xFilial("SB1")+cGetProd))
	cGetProd := SB1->B1_COD
Else
	MsgStop("Produto nao cadastrado!")
	Return(.F.)
EndIf

nPosPed := aScan(_aPedidos,{|x| x[1] == .T. })

If nPosPed > 0
	DbSelectArea("SC7")
	SC7->(DbSetOrder(2))
	If SC7->(!DbSeek(xFilial("SC7")+cGetProd+CA100FOR+CLOJA+_aPedidos[nPosPed,2]))
		MsgStop("Produto nao esta no pedido!")
		Return(.F.)
	EndIf
EndIf

If Empty(aEstru[1,1])
	
	aEstru[1,1] := cGetProd
	aEstru[1,2] := Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC")
	aEstru[1,3] := IIf(!Empty(nQtd),Transform(Val(nQtd),"@E 99999"),Transform(nQtde,"@E 99999"))
	If nPosPed > 0
		aEstru[1,4] := SC7->C7_NUM
		aEstru[1,5] := SC7->C7_ITEM
	Else
		aEstru[1,4] := Space(6)
		aEstru[1,5]	:= Space(4)
	EndIf
	
Else
	
	nPos := aScan(aEstru,{|x| x[1] == cGetProd })
	
	If nPos > 0
		aEstru[nPos,3] := IIf(!Empty(nQtd),Transform(Val(aEstru[nPos,3])+Val(nQtd),"@E 99999"),Transform(Val(aEstru[nPos,3])+1,"@E 99999"))
	Else
		Aadd(aEstru,{cGetProd,;
		Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC"),;
		IIf(!Empty(nQtd),Transform(Val(nQtd),"@E 99999"),Transform(nQtde,"@E 99999")),;
		"",;
		""})
	EndIf
	
EndIf

oLbx:Refresh()
oDlg:Refresh()

nQtde		:= 1
cGetProd	:= Space(19)
nQtd		:= Space(5)
//oGetQtd:SetFocus()
oGetProd:SetFocus()

RestArea(aArea)

Return

Static Function GrvRom(aOpc)

Local n
Local nPos
Local nPrcUni	:= 0
Local nPrcTot	:= 0
Local nPosDel	:= Len(aHeader)+1
Local aArea 	:= GetArea()

For nPos:=1 to Len(aOpc)
	
	If Val(aOpc[nPos][3]) > 0
		
		nProd := aScan(aCols,{|x| x[2] == aOpc[nPos,1] }) 
		
		If nProd > 0 .And. !aCols[nProd,nPosDel] .And. Empty(aOpc[nPos,4]) 
			aCols[nProd,7] += Val(aOpc[nPos,3])
			aCols[nProd,9] := Round(aCols[nProd,7]*aCols[nProd,8],2)
		Else
	
			If !aCols[Len(aCols),nPosDel]
				If !Empty(aCols[Len(aCols),2])
					Aadd(aCols,Array(Len(aHeader)+1))
				EndIf	
			EndIf
	                       
			For n := 1 To Len(aHeader) -2
				aCols[Len(aCols)][n] := CriaVar(aHeader[n][2])
				If ( AllTrim(aHeader[n][2]) == "D1_ITEM" )
					aCols[Len(aCols)][n] := StrZero(Len(aCols),4)
				EndIf
			Next n
                               
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
                               
			nPrcUni := Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UPRC")
			nPrcTot	:= Round(Val(aOpc[nPos][3])*nPrcUni,2)
			
			/*
			If !Empty(aOpc[nPos,6])
			nPrcUni := aOpc[nPos,6]
			Else
			nPrcUni := Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UPRC")
			EndIf
			*/
			nPrcUni := Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UPRC")
			nPrcTot	:= Round(Val(aOpc[nPos][3])*nPrcUni,2)
			
			GdFieldPut("D1_COD"		, aOpc[nPos][1]		, Len(aCols) )
			GdFieldPut("D1_QUANT"	, Val(aOpc[nPos][3]), Len(aCols) )
			GdFieldPut("D1_VUNIT"	, nPrcUni			, Len(aCols) )
			GdFieldPut("D1_TOTAL"	, nPrcTot			, Len(aCols) )
			GdFieldPut("D1_TES	"	, Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_TE")  		, Len(aCols) )
			GdFieldPut("D1_LOCAL"	, Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_LOCPAD")   , Len(aCols) )
			GdFieldPut("D1_PEDIDO"	, aOpc[nPos][4]		, Len(aCols) )
			GdFieldPut("D1_ITEMPC"	, aOpc[nPos][5]		, Len(aCols) )
			
			//MaFisIniLoad(Len(aCols))
			//For nX := 1 To Len(aAuxRefSD1)
			//MaFisRef("IT_TES","MT100",M->D1_TES)
			//MaFisLoad(aAuxRefSD1[nX][2],(cAliasSD1)->(FieldGet(FieldPos(aAuxRefSD1[nX][1]))),Len(aCols))
			//Next nX
			//MaFisEndLoad(Len(aCols),2)
			
			//MaFisRef("IT_QUANT","MT100",M->D1_QUANT)
			//MaFisRef("IT_PRCUNI","MT100",M->D1_VUNIT)
			//MaFisRef("IT_VALMERC","MT100",M->D1_TOTAL)
			
			If ExistTrigger("D1_COD")
				RunTrigger(2,Len(aCols),,"D1_COD")
				//MaFisRef("IT_PRODUTO","MT100",aCols[Len(aCols),nPosCod])
			EndIf
			
			If ExistTrigger("D1_QUANT")
				RunTrigger(2,Len(aCols),,"D1_QUANT")
				//MaFisRef("IT_QUANT","MT100",aCols[Len(aCols),nPosQtd])
			EndIf
			
			If ExistTrigger("D1_VUNIT")
				RunTrigger(2,Len(aCols),,"D1_VUNIT")
				//MaFisRef("IT_PRCUNI","MT100",aCols[Len(aCols),nPosUnit])
			EndIf
			
			If ExistTrigger("D1_TOTAL")
				RunTrigger(2,Len(aCols),,"D1_TOTAL")
				//MaFisRef("IT_VALMERC","MT100",aCols[Len(aCols),nPosUnit])
			EndIf
			
			If ExistTrigger("D1_LOCAL")
				RunTrigger(2,Len(aCols),,"D1_LOCAL")
			EndIf
			
			If ExistTrigger("D1_PEDIDO")
				RunTrigger(2,Len(aCols),,"D1_PEDIDO")
			EndIf
			
			If ExistTrigger("D1_ITEMPC")
				RunTrigger(2,Len(aCols),,"D1_ITEMPC")
			EndIf
			
			oGetDados:oBrowse:Refresh()
			
			nPrcUni := 0
			nPrcTot	:= 0
			
		EndIf
		
	EndIf
	
Next nPos

RestArea(aArea)

Return

Static Function DelItem()

Local nQuant := 0

nPos := oLbx:nAt

//ADel(aEstru,nPos)
//ASize(aEstru,Len(aEstru)-1)
aEstru[nPos,3] := Transform(nQuant,"@E 99999")
oLbx:Refresh()

If Len(aEstru) == 0
	Aadd(aEstru,{Space(15),Space(50),Space(5),Space(6),Space(4)})
	oLbx:Refresh()
EndIf

Return

Static Function LSVTroca(nIt,aArray)

nPos := aScan(_aPedidos,{|x| x[1] == .T. })

If nPos > 1
	MsgStop("Selecione um pedido por vez!")
	_aPedidos[nPos,1] := .F.
Else
	aArray[nIt,1] := !aArray[nIt,1]
EndIf

Return aArray

Static Function LSVPesq()

Local aArea	:= GetArea()
Local oOk	:= LoadBitmap( GetResources(), "LBOK")
Local oNo	:= LoadBitmap( GetResources(), "LBNO")

cQry := " SELECT DISTINCT (C7_NUM), C7_EMISSAO, C7_FORNECE, C7_LOJA, A2_NOME "
cQry += " FROM " + RetSqlName("SC7") + " SC7 (NOLOCK)"
cQry += " INNER JOIN " + RetSqlName("SA2") + " SA2 (NOLOCK)"
cQry += " ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA AND SA2.D_E_L_E_T_ = '' "
cQry += " WHERE "
cQry += " C7_FILIAL = '"+xFilial("SC7")+"' AND "
cQry += " C7_FORNECE = '"+CA100FOR+"' AND "
cQry += " C7_LOJA = '"+CLOJA+"' AND "
cQry += " C7_RESIDUO = '' AND "  				// Filtro de pedidos não eliminados inserido através da solicitação 54394 - Rodrigo - 10/04/12
cQry += " (C7_QUANT-C7_QUJE-C7_QTDACLA)>0 AND "
cQry += " SC7.D_E_L_E_T_ = '' "
cQry += " ORDER BY C7_EMISSAO DESC "   			// Ordem inserida através da solicitação 54394 - Rodrigo - 10/04/12

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "TMP", .F., .T.)

_aPedidos := {}

DbSelectArea("TMP")
TMP->(DbGoTop())
If TMP->(!Eof())
	While TMP->(!Eof())
		Aadd(_aPedidos,{.F.,TMP->C7_NUM,;
		Substr(TMP->C7_EMISSAO,7,2)+"/"+Substr(TMP->C7_EMISSAO,5,2)+"/"+Substr(TMP->C7_EMISSAO,1,4),;
		TMP->C7_FORNECE,;
		TMP->C7_LOJA,;
		TMP->A2_NOME})
		
		TMP->(DbSkip())
	EndDo
	
	
	DEFINE MSDIALOG oDlgP TITLE cTitulo FROM 200,000 TO 400,650 OF oMainWnd PIXEL
	
	@ 020,008 LISTBOX  oLstPed VAR cVarFil Fields HEADER "","Pedido","Emissao","Fornecedor","Loja","Nome" SIZE 300,70;
	ON DBLCLICK (_aPedidos:=LSVTroca(oLstPed:nAt,_aPedidos),oLstPed:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstPed,oOk,oNo,@_aPedidos) OF oDlgP PIXEL
	oLstPed:SetArray(_aPedidos)
	oLstPed:bLine := { || {If(_aPedidos[oLstPed:nAt,1],oOk,oNo),_aPedidos[oLstPed:nAt,2],_aPedidos[oLstPed:nAt,3],_aPedidos[oLstPed:nAt,4],_aPedidos[oLstPed:nAt,5],_aPedidos[oLstPed:nAt,6]}}
	oLstPed:Refresh()
	
	ACTIVATE MSDIALOG oDlgP CENTERED ON INIT EnchoiceBar(oDlgP,{|| Importa(),oDlgP:End()}, {|| oDlgP:End()})
	
Else
	MsgStop("Nao ha pedidos de compra para o Fornecedor!")
EndIf

DbSelectArea("TMP")
DbCloseArea()

RestArea(aArea)

Return

Static Function Importa()

Local aArea	:= GetArea()
Local nQtde	:= 0
aEstru	:= {}

nPos := aScan(_aPedidos,{|x| x[1] == .T. })

If nPos > 0
	
	cQry := " SELECT * "
	cQry += " FROM " +RetSqlName("SC7")+" SC7 (NOLOCK)"
	cQry += " WHERE "
	cQry += " C7_FILIAL = '"+xFilial("SC7")+"' AND "
	cQry += " C7_NUM = '"+_aPedidos[nPos,2]+"' AND "
	cQry += " C7_FORNECE = '"+CA100FOR+"' AND "
	cQry += " C7_LOJA = '"+CLOJA+"' AND "
	cQry += " (C7_QUANT-C7_QUJE-C7_QTDACLA)>0 AND "
	cQry += " SC7.D_E_L_E_T_ = '' "
	
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "TRB", .F., .T.)
	
	DbSelectArea("TRB")
	TRB->(DbGoTop())
	If TRB->(!Eof())
		While TRB->(!Eof())
			Aadd(aEStru,{TRB->C7_PRODUTO,TRB->C7_DESCRI,Transform(nQtde,"@E 99999"),TRB->C7_NUM,TRB->C7_ITEM,TRB->C7_PRECO})
			TRB->(DbSkip())
		EndDo
	EndIf
	
	oLbx:SetArray(aEstru)
	oLbx:bLine:={|| {aEstru[oLbx:nAt,1],aEstru[oLbx:nAt,2],aEstru[oLbx:nAt,3],aEstru[oLbx:nAt,4],aEstru[oLbx:nAt,5]}}
	oLbx:Refresh()
	
	DbSelectArea("TRB")
	DbCloseArea()
	
EndIf

RestArea(aArea)

Return    
