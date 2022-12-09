#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP006   º Autor ³ Antonio Carlos     º Data ³  23/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pelo toque dos itens via leitor de codi-º±±
±±º          ³ go de barras no pedido de venda.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATP006()
///////////////////////

Local _lTela 		:= .T.

Private oDlg
Private cTitulo		:= "Romaneio Lojas"
Private cGetProd	:= Space(19)
Private oGetProd
Private cArm		:= '01' //Space(2)
Private oGetArm

Private nQtd		:= Space(5)
Private oGetQtd

Private oLbx
Private aEstru		:= {}
Private _cDocB6
Private _cSerB6
Private _cIdeB6

Aadd(aEstru,{Space(15),Space(50),Space(5),Space(8),Space(3),Space(6),Space(4)})

IF !EMPTY(aCols[n,2])
	Aviso("Romaneios","Adicione mais uma linha, em branco, de produtos antes de prosseguir!",{"Ok"})
ELSEIf !Empty(M->C5_CLIENTE) .And. !Empty(M->C5_LOJACLI)
	
	While _lTela
		
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 450,650 OF oMainWnd PIXEL
		
		@ 010,008 Say "Armazem:" Size 051,008 COLOR CLR_BLACK PIXEL OF oDlg
		@ 010,070 MsGet oGetArm  Var cArm  		Size 20,009 COLOR CLR_BLACK Picture "99" PIXEL OF oDlg  when .f.
		
		@ 025,008 Say "Qtde:" Size 051,008 COLOR CLR_BLACK PIXEL OF oDlg
		@ 025,070 MsGet oGetQtd  Var nQtd  		Size 20,009 COLOR CLR_BLACK Picture "@E 99999" PIXEL OF oDlg
		
		@ 040,008 Say "Codigo do Produto:" 		Size 051,008 COLOR CLR_BLACK PIXEL OF oDlg
		@ 040,070 MsGet oGetProd Var cGetProd F3 "SB1" Size 115,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  Valid  (Empty(cGetProd) .OR. (U_LS_C6QTD(100,cGetProd,iif(empty(M->C5_TES),'xxx',M->C5_TES), 'xxx',iif(val(nQtd) == 0,1,val(nQtd)),_nQtdAcum(), '01') .and. LS03REFRES()))
		
		@ 55,8 LISTBOX oLbx FIELDS HEADER "Produto","Descricao","Qtde Romaneio","Nota","Serie","Ident.","Item Ori" SIZE 305,130 NOSCROLL OF oDlg PIXEL
		
		oLbx:SetArray(aEstru)
		oLbx:bLine:={|| {aEstru[oLbx:nAt,1],aEstru[oLbx:nAt,2],aEstru[oLbx:nAt,3],aEstru[oLbx:nAt,4],aEstru[oLbx:nAt,5],aEstru[oLbx:nAt,6],aEstru[oLbx:nAt,7] }}
		oLbx:Refresh()
		oDlg:Refresh()
		
		@ 200,151 Button "Ok" 			Size 037,012 PIXEL OF oDlg ACTION(GrvRom(aEstru),_lTela := .F.,oDlg:End())
		@ 200,195 Button "Cancelar" 	Size 037,012 PIXEL OF oDlg ACTION(_lTela := .F.,oDlg:End())
		@ 200,239 Button "Estorna" 		Size 037,012 PIXEL OF oDlg ACTION(DelItem())
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
	End
	
Else
	Aviso("Romaneios","Informe os campos Cliente/Loja!",{"Ok"})
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function _nQtdAcum()
//////////////////////////
Local _nI := _nPosic := _nQtdAcum := 0   

_nPosic := aScan(aEstru,{|x| alltrim(x[1]) == alltrim(cGetProd) }) 
If _nPosic > 0
	_nQtdAcum += val(aEstru[_nPosic,3])
EndIf	
For _nI := 1 to len(aCols)
	If alltrim(GdFieldGet('C6_PRODUTO',_nI)) == alltrim(cGetProd) .and. !GdDeleted(_nI)
		_nQtdAcum += GdFieldGet('C6_QTDVEN',_nI)
	EndIf
Next
Return(_nQtdAcum)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS03REFRES()
////////////////////////////

Local aArea		:= GetArea()
Local nQtde		:= 1
Local _nQuant	:= 0
Local _nQuant	:= 0
Local _nTeste	:= Space(5)
                     
If val(nQtd) < 0
	MsgBox('Quantidade não pode ser menor que zero','ATENÇÃO!!!','ALERT')
	Return(.f.)
EndIf

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

If ( Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ") .And. M->C5_TIPO == "N" ) //.Or. SM0->M0_CODFIL == "R0"
	
	If Empty(aEstru[1,1])
		aEstru[1,1] := cGetProd
		aEstru[1,2] := Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC")
		aEstru[1,3] := IIf(!Empty(nQtd),nQtd,Str(nQtde))
	Else
		nPos := aScan(aEstru,{|x| x[1] == cGetProd })
		
		If nPos > 0
			aEstru[nPos,3] := IIf(!Empty(nQtd),Str(Val(aEstru[nPos,3])+Val(nQtd)),Str(Val(aEstru[nPos,3])+1))
		Else
			Aadd(aEstru,{cGetProd,;
			Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC"),;
			IIf(!Empty(nQtd),nQtd,Str(nQtde)),;
			"",;
			"",;
			"",;
			""})
		EndIf
	EndIf
	
Else
	
	If Select("TMPSB6") > 0
		DbSelectArea("TMPSB6")
		DbCloseArea()
	EndIf
	/*
	cQuery1 := " SELECT SUM(B6_SALDO) AS SLDSB6 "
	cQuery1 += _cEnter + " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
	cQuery1 += _cEnter + " WHERE "
	cQuery1 += _cEnter + " B6_FILIAL 		= '"+xFilial("SB6")	+"' AND "
	cQuery1 += _cEnter + " B6_PRODUTO 		= '"+cGetProd		+"' AND "
	cQuery1 += _cEnter + " B6_CLIFOR 		= '"+M->C5_CLIENTE	+"' AND "
	cQuery1 += _cEnter + " B6_LOJA 			= '"+M->C5_LOJACLI	+"' AND "
	cQuery1 += _cEnter + " B6_PODER3 		= 'R' AND B6_SALDO > 0  AND "
	cQuery1 += _cEnter + " SB6.D_E_L_E_T_ 	= '' "
	*/
	cQuery1 := " SELECT SUM(B6_SALDO) AS SLDSB6 "
	cQuery1 += _cEnter + " , B6_CLIFOR "
	cQuery1 += _cEnter + " , B6_LOJA "
	cQuery1 += _cEnter + " , B6_DOC "
	cQuery1 += _cEnter + " , B6_SERIE "
	cQuery1 += _cEnter + " , B6_EMISSAO "
	cQuery1 += _cEnter + " , B6_PRUNIT "
	cQuery1 += _cEnter + " , '' B6_IDENT "
	cQuery1 += _cEnter + " , '' D1_ITEM "
	cQuery1 += _cEnter + " , D1_VUNIT "
	cQuery1 += _cEnter + " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK) "
 	cQuery1 += _cEnter + " INNER JOIN "+RetSqlName("SD1")+" SD1 (NOLOCK) ON D1_FILIAL 			= B6_FILIAL  "
	cQuery1 += _cEnter + " 													AND D1_DOC 			= B6_DOC "
	cQuery1 += _cEnter + " 													AND D1_SERIE 		= B6_SERIE "
	cQuery1 += _cEnter + " 													AND D1_COD 			= B6_PRODUTO "
	cQuery1 += _cEnter + " 													AND D1_FORNECE 		= B6_CLIFOR  "
	cQuery1 += _cEnter + " 													AND D1_LOJA 		= B6_LOJA "
	cQuery1 += _cEnter + "													AND D1_LOCAL		= B6_LOCAL
	cQuery1 += _cEnter + "													AND D1_NUMSEQ		= B6_IDENT
	cQuery1 += _cEnter + "													AND SD1.D_E_L_E_T_	= ''
	cQuery1 += _cEnter + " WHERE B6_FILIAL 		= '"+xFilial("SB6")	+"' "
	cQuery1 += _cEnter + " AND B6_PRODUTO 		= '"+cGetProd		+"' "
	cQuery1 += _cEnter + " AND B6_CLIFOR 		= '"+M->C5_CLIENTE	+"' "
	cQuery1 += _cEnter + " AND B6_LOJA 			= '"+M->C5_LOJACLI	+"' "
	cQuery1 += _cEnter + " AND B6_PODER3 		= 'R' 
	cQuery1 += _cEnter + " AND B6_SALDO 		> 0  "
	cQuery1 += _cEnter + " AND SB6.D_E_L_E_T_ 	= '' "
	//cQuery1 += _cEnter + " GROUP BY B6_CLIFOR , B6_LOJA , B6_DOC , B6_SERIE , B6_EMISSAO , B6_PRUNIT , B6_IDENT , D1_ITEM , D1_VUNIT "
	cQuery1 += _cEnter + " GROUP BY B6_CLIFOR , B6_LOJA , B6_DOC , B6_SERIE , B6_EMISSAO , B6_PRUNIT , D1_VUNIT "
	cQuery1 += _cEnter + " ORDER BY B6_EMISSAO ASC "
	
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery1), "TMPSB6", .F., .T.)
	
	TMPSB6->( DbGoTop() )
	If TMPSB6->( !Eof() )
		
		If Empty(aEstru[1,1])
			
			_nTeste := IIf(!Empty(nQtd),nQtd,Str(nQtde))
			
			_nQuant := Val(_nTeste)
			
			If _nQuant <= TMPSB6->SLDSB6
				aEstru[1,1] := cGetProd
				aEstru[1,2] := Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC")
				aEstru[1,3] := Str(_nQuant)
				aEstru[1,4] := TMPSB6->B6_DOC
				aEstru[1,5] := TMPSB6->B6_SERIE
				aEstru[1,6] := TMPSB6->B6_IDENT
				aEstru[1,7] := TMPSB6->D1_ITEM
			ElseIf MsgYesNo("Saldo de terceiros (SB6) insuficiente para devolução (" + alltrim(str(TMPSB6->SLDSB6)) + "), confirma ?")
				aEstru[1,1] := cGetProd
				aEstru[1,2] := Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC")
				aEstru[1,3] := Str(_nQuant)
				aEstru[1,4] := TMPSB6->B6_DOC
				aEstru[1,5] := TMPSB6->B6_SERIE
				aEstru[1,6] := TMPSB6->B6_IDENT
				aEstru[1,7] := TMPSB6->D1_ITEM
				//MsgStop("Saldo invalido!")
			EndIf
			
		Else
			
			nPos := aScan(aEstru,{|x| x[1] == cGetProd })
			
			If nPos > 0
				
				_nTeste := IIf(!Empty(nQtd),Str(Val(aEstru[nPos,3])+Val(nQtd)),Str(Val(aEstru[nPos,3])+1))
				
				_nQuant := Val(_nTeste)
				
				If _nQuant <= TMPSB6->SLDSB6
					aEstru[nPos,3] := Str(_nQuant)
				ElseIf MsgYesNo("Saldo de terceiros (SB6) insuficiente para devolução (" + alltrim(str(TMPSB6->SLDSB6)) + "), confirma ?")
					aEstru[1,3] := Str(_nQuant)
				EndIf
				
			Else
				
				_nTeste := IIf(!Empty(nQtd),nQtd,Str(nQtde))
				
				_nQuant := Val(_nTeste)
				
				If _nQuant <= TMPSB6->SLDSB6
					
					Aadd(aEstru,{cGetProd,;
					Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC"),;
					Str(_nQuant),;
					TMPSB6->B6_DOC,;
					TMPSB6->B6_SERIE,;
					TMPSB6->B6_IDENT,;
					TMPSB6->D1_ITEM})
				
				ElseIf  MsgYesNo("Saldo de terceiros (SB6) insuficiente para devolução (" + alltrim(str(TMPSB6->SLDSB6)) + "), confirma ?")
					Aadd(aEstru,{cGetProd,;
					Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC"),;
					Str(_nQuant),;
					TMPSB6->B6_DOC,;
					TMPSB6->B6_SERIE,;
					TMPSB6->B6_IDENT,;
					TMPSB6->D1_ITEM})
				EndIf
				
			EndIf
			
		EndIf
		
	ElseIf  MsgYesNo("Saldo de terceiros (SB6) insuficiente para devolução (" + alltrim(str(TMPSB6->SLDSB6)) + "), confirma ?")
			Aadd(aEstru,{cGetProd,;
			Posicione("SB1",1,xFilial("SB1")+cGetProd,"B1_DESC"),;
			Str(_nQuant),;
			TMPSB6->B6_DOC,;
			TMPSB6->B6_SERIE,;
			TMPSB6->B6_IDENT,;
			TMPSB6->D1_ITEM})
	EndIf
	
EndIf

oLbx:Refresh()
oDlg:Refresh()

nQtde 		:= 1
cGetProd	:= Space(19)
nQtd 		:= Space(5)
oGetProd:SetFocus()

oDlg:Refresh()

If Select("TMPSB6") > 0
	DbSelectArea("TMPSB6")
	DbCloseArea()
EndIf

RestArea(aArea)

Return(.t.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvRom(aOpc)
////////////////////////////
Local nHeader
Local nPos
Local _lFaz		:= .T.
Local nItem		:= "0001" 
Local nItOri	:= "0001"
Local nPrcUni	:= 0
Local nPrcTot	:= 0
Local _nQtdAux	:= 0
Local _nQtdBx	:= 0
Local nValDesc	:= 0
Local _aPedVen	:= {}
Local nPosDel	:= Len(aHeader)+1
Local aArea 	:= GetArea()
Local cEstado   := '  '                   

For nPos:=1 to Len(aOpc)
	
	If ( Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ") .And. M->C5_TIPO == "N" )
		
		nProd 		:= aScan(aCols  ,{|x| x[2] == aOpc[nPos,1] })

		nPosQtd		:= aScan(aHeader,{|x| alltrim(x[2]) == "C6_QTDVEN" })
		nPosQtdLib	:= aScan(aHeader,{|x| alltrim(x[2]) == "C6_QTDLIB" })
		nPosVlrUnit	:= aScan(aHeader,{|x| alltrim(x[2]) == "C6_PRCVEN" })
		nPosVlrTot	:= aScan(aHeader,{|x| alltrim(x[2]) == "C6_VALOR" })
		nPosTes		:= aScan(aHeader,{|x| alltrim(x[2]) == "C6_TES" })
		nPosCFOP	:= aScan(aHeader,{|x| alltrim(x[2]) == "C6_CF" })
		
		If nProd > 0 .And. !aCols[nProd,nPosDel]
			
			cTes	:= Posicione("SBZ",1,SA1->A1_LOJA+aOpc[nPos][1],"BZ_TS")
			cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
			
			cEstado := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
			
			If SM0->M0_ESTENT <> cEstado
				cCf := "6"+Substr(cCf,2,3)
				If !empty(SF4->F4_CF_FORA)
					cCf := SF4->F4_CF_FORA
				EndIf
			EndIf
			
			aCols[nProd,nPosQtd]	+= Val(aOpc[nPos,3])										// quantidade
			aCols[nProd,nPosVlrTot]	:= Round(aCols[nProd,nPosQtd]*aCols[nProd,nPosVlrUnit],4)	// valor total = QTD * VALOR UNITARIO
			aCols[nProd,nPosQtdLib]	+= Val(aOpc[nPos,3])                        				// qtd liberada
			aCols[nProd,nPosTes]	:= cTes                                     				// tes
			aCols[nProd,nPosCFOP]	:= cCf                                      				// cfop
			
		Else
			/*			
			If !aCols[Len(aCols),nPosDel]
				If !Empty(aCols[Len(aCols),2])
					Aadd(aCols,Array(Len(aHeader)+1))
				EndIf
			EndIf

			For nHeader := 1 To Len(aHeader) - 2
				aCols[Len(aCols)][nHeader] := CriaVar(aHeader[nHeader][2])
				If ( AllTrim(aHeader[nHeader][2]) == "C6_ITEM" )
					
					If Len(aCols) == 1
						aCols[Len(aCols)][nHeader] := nItem
					Else
						nItem := aCols[Len(aCols)-1][nHeader]
						aCols[Len(aCols)][nHeader] := Soma1(nItem)
					EndIf
					
				EndIf
			Next nHeader
			*/
			If nPos > 1
				If !oGetDad:AddLine()
					Alert("Erro ao adicionar uma nova linha!")
				EndIf
			EndIf

			For nHeader := 1 to len(aHeader)
				If AllTrim(aHeader[nHeader,2]) == "C6_ITEM"
					//aCols[Len(aCols),nHeader] := cItem
					If Len(aCols) == 1
						aCols[Len(aCols)][nHeader] := nItem
 					Else
 						nItem := StrZero(len(aCols),TAMSX3("C6_ITEM")[1]) //nItem := aCols[Len(aCols)-1][nHeader]
 						aCols[Len(aCols)][nHeader] := Soma1(nItem)
 					EndIf
				ElseIf IsHeadRec(aHeader[nHeader,2])
					aCols[Len(aCols),nHeader] := 0
				ElseIf IsHeadAlias(aHeader[nHeader,2])
					aCols[Len(aCols),nHeader] := "SC6"
				ELSE
					aCols[Len(aCols)][nHeader] := CriaVar(aHeader[nHeader][2])
				EndIf
				aCols[Len(aCols),len(aHeader)+1] := .F.
			Next
			
			cEstado := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
			
			cTes	:= Posicione("SBZ",1,SA1->A1_LOJA+aOpc[nPos][1],"BZ_TS")
			cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
			
			If SM0->M0_ESTENT <> cEstado
				cCf := "6"+Substr(cCf,2,3)
				If !empty(SF4->F4_CF_FORA)
					cCf := SF4->F4_CF_FORA
				EndIf
			EndIf
			
			_nUprc	 	:= Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UPRC")
			_nPRCCOM 	:= Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_PRCCOM")
			_nPrcUni 	:= IIF(_nPRCCOM==0,_nUprc,_nPRCCOM)
			_nPDec   	:= GETMV("LS_INDTRNF") //If(SB1->B1_GRUPO == "0010",15,20)
			//nPrcUni		:= _nPrcUni
			
			_nPrcVen	:= noround(_nPrcUni + (_nPrcUni * _nPDec) / 100,2)
			nPrcUni		:= _nPrcVen
			nPrcTot		:= Round(Val(aOpc[nPos][3])*nPrcUni,2)
			
			GdFieldPut("C6_PRODUTO"	, aOpc[nPos][1]													, Len(aCols) )
			GdFieldPut("C6_DESCRI"	, Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_DESC")		, Len(aCols) )
			GdFieldPut("C6_UM"		, Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UM")		, Len(aCols) )
			GdFieldPut("C6_QTDVEN"	, Val(aOpc[nPos][3])											, Len(aCols) )
			GdFieldPut("C6_QTDEMP"	, Val(aOpc[nPos][3])											, Len(aCols) )
			GdFieldPut("C6_QTDLIB"	, Val(aOpc[nPos][3])											, Len(aCols) )
			GdFieldPut("C6_SEGUM"	, Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_SEGUM")	, Len(aCols) )
			GdFieldPut("C6_LOCAL"	, Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_LOCPAD")   , Len(aCols) )
			
			GdFieldPut("C6_TES"		, cTes 															, Len(aCols) )
			GdFieldPut("C6_CF"		, cCf 															, Len(aCols) )
			GdFieldPut("C6_PRCVEN"	, nPrcUni														, Len(aCols) )
			GdFieldPut("C6_PRUNIT"	, nPrcUni														, Len(aCols) )
			GdFieldPut("C6_VALOR"	, nPrcTot														, Len(aCols) )
			
			GdFieldPut("C6_NFORI"	, aOpc[nPos][4]													, Len(aCols) )
			GdFieldPut("C6_SERIORI"	, aOpc[nPos][5]													, Len(aCols) )
			GdFieldPut("C6_IDENTB6"	, aOpc[nPos][6]													, Len(aCols) )
			GdFieldPut("C6_ITEMORI"	, aOpc[nPos][7]													, Len(aCols) )
			
			If ExistTrigger("C6_PRODUTO")
				RunTrigger(2,Len(aCols),,"C6_PRODUTO")
			EndIf
			
			If ExistTrigger("C6_QTDVEN")
				RunTrigger(2,Len(aCols),,"C6_QTDVEN")
			EndIf
			
			If ExistTrigger("C6_QTDEMP")
				RunTrigger(2,Len(aCols),,"C6_QTDEMP")
			EndIf
			
			If ExistTrigger("C6_QTDLIB")
				RunTrigger(2,Len(aCols),,"C6_QTDLIB")
			EndIf
			
			If ExistTrigger("C6_PRCVEN")
				RunTrigger(2,Len(aCols),,"C6_PRCVEN")
			EndIf
			
			If ExistTrigger("C6_PRUNIT")
				RunTrigger(2,Len(aCols),,"C6_PRUNIT")
			EndIf
			
			If ExistTrigger("C6_VALOR")
				RunTrigger(2,Len(aCols),,"C6_VALOR")
			EndIf
			
			If ExistTrigger("C6_TES")
				RunTrigger(2,Len(aCols),,"C6_TES")
			EndIf
			
			If ExistTrigger("C6_CF")
				RunTrigger(2,Len(aCols),,"C6_CF")
			EndIf
			
			If ExistTrigger("C6_NFORI")
				RunTrigger(2,Len(aCols),,"C6_NFORI")
			EndIf
			
			If ExistTrigger("C6_SERIORI")
				RunTrigger(2,Len(aCols),,"C6_SERIORI")
			EndIf
			
			If ExistTrigger("C6_IDENTB6")
				RunTrigger(2,Len(aCols),,"C6_IDENTB6")
			EndIf
			
			If ExistTrigger("C6_ITEMORI")
				RunTrigger(2,Len(aCols),,"C6_ITEMORI")
			EndIf
			
		EndIf
		
	Else
		
		If Select("TRBSB6") > 0
			DbSelectArea("TRBSB6")
			DbCloseArea()
		EndIf
		
		cQry := " SELECT B6_DOC
		cQry += _cEnter + " , B6_SERIE
		cQry += _cEnter + " , B6_IDENT
		cQry += _cEnter + " , B6_PRUNIT
		cQry += _cEnter + " , B6_SALDO
		cQry += _cEnter + " , D1_IDENTB6
		cQry += _cEnter + " , D1_DESC
		cQry += _cEnter + " , D1_ITEM
		cQry += _cEnter + " , D1_FORNECE
		cQry += _cEnter + " , D1_LOJA
		cQry += _cEnter + " , D1_COD
		cQry += _cEnter + " , D1_VALDESC "
		cQry += _cEnter + " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
		cQry += _cEnter + " LEFT JOIN "+RetSqlName("SD1")+" SD1 (NOLOCK) ON D1_FILIAL 			= '"+xFilial("SD1")+"' 
		cQry += _cEnter + " 												AND D1_DOC 			= B6_DOC 
		cQry += _cEnter + " 												AND D1_SERIE 		= B6_SERIE 
		cQry += _cEnter + " 												AND D1_FORNECE 		= B6_CLIFOR 
		cQry += _cEnter + " 												AND D1_LOJA 		= B6_LOJA 
		cQry += _cEnter + " 												AND D1_IDENTB6 		= B6_IDENT 
		cQry += _cEnter + " 												AND SD1.D_E_L_E_T_ 	= '' "
		cQry += _cEnter + " WHERE B6_FILIAL 	= '"+xFilial("SB6")	+"'  "
		cQry += _cEnter + " AND B6_PRODUTO 		= '"+aOpc[nPos][1]	+"'  "
		cQry += _cEnter + " AND B6_CLIFOR 		= '"+M->C5_CLIENTE	+"'  "
		cQry += _cEnter + " AND B6_LOJA 		= '"+M->C5_LOJACLI	+"'  "
		cQry += _cEnter + " AND B6_PODER3 		= 'R' "
		cQry += _cEnter + " AND B6_SALDO 		> 0   "
		cQry += _cEnter + " AND SB6.D_E_L_E_T_ 	= '' "
		
		dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "TRBSB6", .F., .T.)
		
		DbSelectArea("TRBSB6")
		TRBSB6->( DbGoTop() )
		
		If TRBSB6->( !Eof() )
			
			_nQtdAux := Val(aOpc[nPos][3])
			
			While TRBSB6->( !Eof() ) .And. _lFaz
				
				If !Empty(TRBSB6->D1_IDENTB6)
					
					nValDesc := 0
					
					If M->C5_TIPO == "N"
						cEstado := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
					ElseIf M->C5_TIPO <> "N"
						cEstado := Posicione("SA2",1,xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_EST")
					EndIf
					
					DbSelectArea("SB1")
					SB1->( DbSetOrder(1) )
					Dbseek( xFilial("SB1")+aOpc[nPos][1] )
					
					If Substr(SA1->A1_CGC,1,8) $ GetMv("MV_CNPJLSV")
						cTes	:= Posicione("SBZ",1,SA1->A1_LOJA+aOpc[nPos][1],"BZ_TS")
						cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
					Else
						cTes	:= Posicione("SBZ",1,xFilial("SBZ")+aOpc[nPos][1],"BZ_TS")
						cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
					EndIf
					
					If !Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ") .Or. M->C5_TIPO == "B"
						If SB1->B1_GRUPO $ "0003/0004/0006/0007"
							cTes := GetMv("MV_TESDCOL")
							cCf	:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
						EndIf
					EndIf
					
					If SM0->M0_ESTENT <> cEstado  ///*******///////
						cCf := "6"+Substr(cCf,2,3)
						If !empty(SF4->F4_CF_FORA)
							cCf := SF4->F4_CF_FORA
						EndIf
					EndIf
					
					If _nQtdAux <= TRBSB6->B6_SALDO
						_nQtdBx	:= _nQtdAux
						_lFaz	:= .F.
						_nQtdAux := 0
					Else
						_nQtdBx := TRBSB6->B6_SALDO
						_nQtdAux -= _nQtdBx
					EndIf
					
					_cDocB6	:= TRBSB6->B6_DOC
					_cSerB6	:= TRBSB6->B6_SERIE
					_cIdeB6	:= TRBSB6->B6_IDENT
					
					//aValor := A410SNfOri(TRBSB6->D1_FORNECE,TRBSB6->D1_LOJA,TRBSB6->B6_DOC,TRBSB6->B6_SERIE,TRBSB6->D1_ITEM,TRBSB6->D1_COD,,"01","SD1")
					
					nValDesc := TRBSB6->D1_VALDESC
					//nValDesc:= ( TRBSB6->B6_PRUNIT * TRBSB6->D1_DESC ) / 100
					
					//nPrcUni := Round( TRBSB6->B6_PRUNIT - nValDesc,2 )
					//nPrcUni := aValor[2] / _nQtdBx
					//nPrcUni := aValor[2] / aValor[1]
					
					nPrcUni := TRBSB6->B6_PRUNIT
					nPrcVen := TRBSB6->B6_PRUNIT
					
					//nItOri	:= Soma1(nItOri)
					nItOri	:= TRBSB6->D1_ITEM
					
					nPrcTot	:= _nQtdBx*nPrcUni
					//nPrcTot	:= aValor[2]
					
					Aadd(_aPedVen, { aOpc[nPos][1],;
					Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_DESC"),;
					Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UM"),;
					_nQtdBx,;
					_nQtdBx,;
					_nQtdBx,;
					Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_SEGUM"),;
					Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_LOCPAD"),;
					cTes,;
					cCf,;
					nPrcUni,;
					nPrcUni,;
					nPrcTot,;
					_cDocB6,;
					_cSerB6,;
					_cIdeB6,;
					nItOri })
					
					//nPrcUni := 0
					//nPrcTot	:= 0
					
				EndIf
				
				TRBSB6->( DbSkip() )
				
			EndDo
			
		Else
			
			nPrcUni := Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UPRC")
			
			cTes	:= "888"
			cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
			
			_nQtdBx := Val(aOpc[nPos][3])
			
			nPrcTot	:= Round(_nQtdBx*nPrcUni,4)
			
			Aadd(_aPedVen, { aOpc[nPos][1],;
			Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_DESC"),;
			Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UM"),;
			Val(aOpc[nPos][3]),;
			Val(aOpc[nPos][3]),;
			Val(aOpc[nPos][3]),;
			Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_SEGUM"),;
			Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_LOCPAD"),;
			cTes,;
			cCf,;
			nPrcUni,;
			nPrcUni,;
			nPrcTot,;
			"",;
			"",;
			"",;
			""	} )
			
		EndIf
		
	EndIf
	
	
	If _nQtdAux > 0
		cTes	:= "888"
		cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
		
		nPrcUni := Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UPRC")
		nPrcTot	:= Round(_nQtdAux*nPrcUni,4)
		
		Aadd(_aPedVen, { aOpc[nPos][1],;
		Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_DESC"),;
		Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_UM"),;
		_nQtdAux,;
		_nQtdAux,;
		_nQtdAux,;
		Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_SEGUM"),;
		Posicione("SB1",1,xFilial("SB1")+aOpc[nPos][1],"B1_LOCPAD"),;
		cTes,;
		cCf,;
		nPrcUni,;
		nPrcUni,;
		nPrcTot,;
		"",;
		"",;
		"",;
		""	} )
	EndIf
	
	
	nPrcUni := 0
	nPrcTot	:= 0
	_lFaz	:= .T.
	nItOri	:= "0001"
	
	oGetDad:oBrowse:Refresh()
	oGetDad:Refresh()
	
Next nPos

If Len(_aPedVen) > 0
	
	_n1 := _nQtdAux
	_n2 := _nQtdBx
	
	For _nI := 1 To Len(_aPedVen)
		
		If !aCols[Len(aCols),nPosDel]
			If !Empty(aCols[Len(aCols),2])
				Aadd(aCols,Array(Len(aHeader)+1))
			EndIf
			IF _nI > 1 .AND. _nI <= Len(_aPedVen) //LEN(_aPedVen) > 1//LEN(aCols) > 1
				//n++
			ENDIF
		EndIf
		
		For nHeader := 1 To Len(aHeader) - 2
			aCols[Len(aCols)][nHeader] := CriaVar(aHeader[nHeader][2])
			If ( AllTrim(aHeader[nHeader][2]) == "C6_ITEM" )
				
				If Len(aCols) == 1
					aCols[Len(aCols)][nHeader] := nItem
				Else
					nItem := aCols[Len(aCols)-1][nHeader]
					aCols[Len(aCols)][nHeader] := Soma1(nItem)
				EndIf
				
			EndIf
		Next nHeader
		
		//oGetDad:oBrowse:Refresh()
		//eval( oGetDad:obrowse:BGOBOTTOM )
		                                        
		n := len(aCols)
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		
		GdFieldPut("C6_PRODUTO"		, _aPedVen[_nI][1]		, Len(aCols) )
		GdFieldPut("C6_DESCRI"		, _aPedVen[_nI][2]		, Len(aCols) )
		GdFieldPut("C6_UM"			, _aPedVen[_nI][3]		, Len(aCols) )
		GdFieldPut("C6_QTDVEN"		, _aPedVen[_nI][4]		, Len(aCols) )
		GdFieldPut("C6_QTDEMP"		, _aPedVen[_nI][4]		, Len(aCols) )
		GdFieldPut("C6_QTDLIB"		, _aPedVen[_nI][4]		, Len(aCols) )
		GdFieldPut("C6_SEGUM"		, Posicione("SB1",1,xFilial("SB1")+_aPedVen[_nI][1],"B1_SEGUM")	, Len(aCols) )
		If Empty(cArm)
			GdFieldPut("C6_LOCAL"	, "01"   				, Len(aCols) )
		Else
			GdFieldPut("C6_LOCAL"	, cArm   				, Len(aCols) )
		EndIf
		GdFieldPut("C6_TES"			, _aPedVen[_nI][9] 		, Len(aCols) )
		GdFieldPut("C6_CF"			, _aPedVen[_nI][10] 	, Len(aCols) )
		GdFieldPut("C6_PRCVEN"		, _aPedVen[_nI][11]		, Len(aCols) )
		GdFieldPut("C6_PRUNIT"		, _aPedVen[_nI][12]		, Len(aCols) )
		GdFieldPut("C6_VALOR"		, _aPedVen[_nI][13]		, Len(aCols) )
		
		GdFieldPut("C6_NFORI"		, _aPedVen[_nI][14]		, Len(aCols) )
		GdFieldPut("C6_SERIORI"		, _aPedVen[_nI][15]		, Len(aCols) )
		GdFieldPut("C6_IDENTB6"		, _aPedVen[_nI][16]		, Len(aCols) )
		GdFieldPut("C6_ITEMORI"		, _aPedVen[_nI][17]		, Len(aCols) )
		
		//aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
		//If ExistTrigger("C6_PRODUTO")
		//RunTrigger(2,Len(aCols),,"C6_PRODUTO")
		//EndIf
		
		If ExistTrigger("C6_QTDVEN")
			RunTrigger(2,Len(aCols),,"C6_QTDVEN")
		EndIf
		
		If ExistTrigger("C6_QTDEMP")
			RunTrigger(2,Len(aCols),,"C6_QTDEMP")
		EndIf
		
		If ExistTrigger("C6_QTDLIB")
			RunTrigger(2,Len(aCols),,"C6_QTDLIB")
		EndIf
		
		If ExistTrigger("C6_PRCVEN")
			RunTrigger(2,Len(aCols),,"C6_PRCVEN")
		EndIf
		
		If ExistTrigger("C6_PRUNIT")
			RunTrigger(2,Len(aCols),,"C6_PRUNIT")
		EndIf
		
		If ExistTrigger("C6_VALOR")
			RunTrigger(2,Len(aCols),,"C6_VALOR")
		EndIf
		
		If ExistTrigger("C6_TES")
			RunTrigger(2,Len(aCols),,"C6_TES")
		EndIf
		
		If ExistTrigger("C6_CF")
			RunTrigger(2,Len(aCols),,"C6_CF")
		EndIf
		
		If ExistTrigger("C6_NFORI")
			RunTrigger(2,Len(aCols),,"C6_NFORI")
		EndIf
		
		If ExistTrigger("C6_SERIORI")
			RunTrigger(2,Len(aCols),,"C6_SERIORI")
		EndIf
		
		If ExistTrigger("C6_IDENTB6")
			RunTrigger(2,Len(aCols),,"C6_IDENTB6")
		EndIf
		
		If ExistTrigger("C6_ITEMORI")
			RunTrigger(2,Len(aCols),,"C6_ITEMORI")
		EndIf
		
		/*
		//oGetDad:oBrowse:Refresh()
		IF TYPE("oGetDad") == "O"
			//eval( oGetDad:obrowse:BGOTOP )
			oGetDad:oBrowse:Refresh()
			oGetDad:Refresh()
		ENDIF
		*/
		
	Next _nI
	
EndIf

//n := len(aCols)
IF TYPE("oGetDad") == "O"
	//eval( oGetDad:obrowse:BGOTOP )
	oGetDad:oBrowse:Refresh()
	//oGetDad:Refresh()
ENDIF

If Select("TRBSB6") > 0
	DbSelectArea("TRBSB6")
	DbCloseArea()
EndIf

RestArea(aArea)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function DelItem()
/////////////////////////

nPos := oLbx:nAt

If !Empty(aEstru[nPos,1])
	ADel(aEstru,nPos)
	ASize(aEstru,Len(aEstru)-1)
	oLbx:Refresh()
	
	If Len(aEstru) == 0
		Aadd(aEstru,{Space(15),Space(50),Space(5),Space(8),Space(3),Space(6),Space(4)})
		oLbx:Refresh()
	EndIf
Else
	MsgStop("Nao existe registro para estorno!")
EndIf

Return

//////////////////////////////////////////////////////////////////////////////////////////
// ************************************************************************************ //
// UTILIZADO EM GATILHO NA SC6 PARA BUSCAR O PRECO INTERCOMPANY ACRESCIDO DE INDICE     //
// THIAGO - 17/01/2014                                                                  //
// ************************************************************************************ //
//////////////////////////////////////////////////////////////////////////////////////////
USER FUNCTION INDTRNF()

Private __nPosPrc	:= aScan(aHEADER,{|x| alltrim(x[2]) == "C6_PRCVEN" }) 
Private __nPosPrd	:= aScan(aHEADER,{|x| alltrim(x[2]) == "C6_PRODUTO" }) 
Private __nUprc		:= 0
Private __nPRCCOM	:= 0
Private __nPrcUni	:= 0
Private __nPDec		:= 0
Private __nPrcVen	:= 0

IF (Substr(SM0->M0_CGC,1,8)$GetMv("MV_LSVCNPJ").And.M->C5_TIPO=="N")
	__nUprc	 	:= Posicione("SB1",1,xFilial("SB1")+aCols[n][__nPosPrd],"B1_UPRC")
	__nPRCCOM 	:= Posicione("SB1",1,xFilial("SB1")+aCols[n][__nPosPrd],"B1_PRCCOM")
	__nPrcUni 	:= IIF(__nPRCCOM==0,__nUprc,__nPRCCOM)
	__nPDec   	:= GETMV("LS_INDTRNF") //If(SB1->B1_GRUPO == "0010",15,20)
	__nPrcVen	:= noround(__nPrcUni + (__nPrcUni * __nPDec) / 100,2)
ELSE
	__nPrcVen	:= aCols[n][__nPosPrc]
ENDIF

RETURN __nPrcVen