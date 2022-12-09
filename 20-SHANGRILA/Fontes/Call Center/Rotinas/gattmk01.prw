#Include "RwMake.Ch"

&&========================================================================================================================================================
&&Nelson Hammel - 27/07/11 - Rotina para calculo de desconto no orçamento TMK
&&========================================================================================================================================================

User Function GATTMK01()


	&&==========================================================================================================================================================
	&&Só dispara a calculadora para linhas não excluidas
	If acols[n,Len(aCols[n])] == .T.
		Return()
	EndIf

	&&==========================================================================================================================================================
	&&Salva WorArea atual
	_cAlias := Alias()
	_nRecno := Recno()
	_nIndex := IndexOrd()


	&&==========================================================================================================================================================
	&&Variaveis
	xPosVLRITEM  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VLRITEM"})
	xPosValDesc  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_VALDESC"})
	xPosItemD	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_DESC"})
	xPosProduto	 := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})

	xEstNorte 	:= GETMV("MV_NORTE")
	xGrupo		:=Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[n,xPosProduto],"B1_GRUPO"))
	xEst		:=Alltrim(Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_EST"))
	Iif (xEst=='SP', xRegiao := '1',Iif(xEst $ xEstNorte,xRegiao := '2',xRegiao := '3'))
	xRegra		:=Alltrim(M->UA_X_CODRE)
	xTotItem	:=aCols[n,xPosVlrItem]+aCols[n,xPosValDesc]

	xAux1		:=0
	xDescMax 	:=0
	nDesc1		:=0
	nDesc2		:=0
	nDesc3		:=0
	nDesc4		:=0
	nDesc5		:=0
	nDesc6		:=0
	xTotA		:=0
	xTotB		:=0
	xTotal		:=0
	xDescCom	:=0
	xDescIcm	:=0
	xDescCond	:=0

	&&==========================================================================================================================================================
	&&Valida se abre tela de desconto
	&&If acols[N,Len(aCols[N])] == .F.
	&&	If aCols[n,xPosItemD] > 0
	&&	lOk := ApMsgNoYes("Recalcular Desconto ?","Aviso")
	&&		If !lOk
	&&		xDescMax := aCols[n,xPosItemD]
	&&		Return(xDescMax)
	&&		EndIf
	&&	EndIf
	&&Else
	&&Return(xDescMax)
	&&EndIf


	&&==========================================================================================================================================================
	&&Calcula o valor bruto do orçamento
	For C := 1 TO Len(aCols)
		If acols[C,Len(aCols[C])] == .F.
			xTotA	:=aCols[C,xPosVlrItem]
			xTotB	:=aCols[C,xPosValDesc]
			xTotal	:=xTotal+(xTotA+xTotB)
		EndIf
	Next


	&&==========================================================================================================================================================
	&&Busca dados da tabela de desconto conforme parametros para apresentação

	CQuery := "SELECT * FROM " + RetSqlName("SZ1") + " SZ1 "
	CQuery += "WHERE 	Z1_CODIGO	='"+Alltrim(xRegra)+"' "
	CQuery += "AND 		Z1_REGIAO	='"+Alltrim(xRegiao)+"' "
	CQuery += "AND 		Z1_GRUPO	='"+Alltrim(xGrupo)+"' "
	CQuery += "AND SZ1.D_E_L_E_T_ = '' "
	CQuery += "ORDER BY Z1_ITEM "
	cQuery := ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'TABSZ1', .F., .T.)},"Teste")

	DbSelectArea("TABSZ1")
	DbGoTop()
	While ! Eof() .And. xAux1=0
		If TABSZ1->Z1_VALATE >  xTotal
			xDescCom	:=TABSZ1->Z1_DESC1
			xDesc2		:=TABSZ1->Z1_DESC2
			xDesc3		:=TABSZ1->Z1_DESC3
			xDesc4		:=TABSZ1->Z1_DESC4
			xDescICM	:=TABSZ1->Z1_DESC5
			xDescCond	:=TABSZ1->Z1_DESC6
			xAux1:=1
		EndIf
		DbSkip()
	EndDo()
	xAux1:=0
	DbCloseArea("TABSZ1")


	&&========================================================================================================================================================
	&&Janela para digitação de descontos

	@10,10 to 340,410 Dialog oDlg1 Title "Regras de Desconto"
	@05,07 to 165,195
	@30,14 Say "Digite os percentuais de desconto: " size 150,15
	@45,14  Say "Dif. ICM      " size 35,10
	@45,50  get nDesc5 PICTURE "@E 99.99"
	@45,104 Say "Desconto      " size 35,10
	@45,140 get nDesc1 PICTURE "@E 99.99"
	@60,14  Say "Desc. a Vista     " size 35,10
	@60,50  get nDesc6 PICTURE "@E 99.99"
	@95,14  Say "Valores Possiveis de Desconto (Regra):" size 150,15
	@105,14 Say "Desconto"+Space(2)+Transform(xDescCom,"@E 99.99")
	@115,14 Say "Dif. ICMS"+Space(2)+Transform(xDescIcm	,"@E 99.99")
	@125,14 Say "Desc a Vista "+Space(2)+Transform(xDescCond	,"@E 99.99")
	@130,165 bmpbutton type 1  action OkProc()

	&&@15,14 Say cGrupo + " - " + cDesGr
	&&@60,104 Say "Desconto 4     " size 35,10
	&&@60,140 get nDesc2 PICTURE "@E 99.99"
	&&@75,14  Say "Desc Dif. ICM  " size 35,10
	&&@75,50  get nDesc3 PICTURE "@E 99.99"
	&&@75,104 Say "Desc a Vista  "  size 35,10
	&&@75,140 get nDesc4 PICTURE "@E 99.99"
	&&Transform(xDesc2	,"@E 99.99")+Space(2)+"|D3"+Space(2)+;
		&&Transform(xDesc3	,"@E 99.99")+Space(2)+"|D4"+Space(2)+;
		&&Transform(xDesc4	,"@E 99.99")+


	&&===========================================================================================================================================================
	&&Calculo dos descontos aplicados
	Activate dialog oDlg1 centered

	xValPar	:= xTotItem
	xValPar	:= (xValPar-((xValPar*nDesc5)/100))
	xValPar	:= (xValPar-((xValPar*nDesc1)/100))
	xValPar	:= (xValPar-((xValPar*nDesc6)/100))
	xValPar	:= (xValPar-((xValPar*nDesc2)/100))
	xValPar	:= (xValPar-((xValPar*nDesc3)/100))
	xValPar	:= (xValPar-((xValPar*nDesc4)/100))
	&&xDescMax:= Str((100-((100*xValPar)/xTotItem)),5,2)
	xDescMax:= (100-((100*xValPar)/xTotItem))

	&&===========================================================================================================================================================
	&&Isso faz com que tudo funcione....
	&&M->UB_DESC:=xDescMax
	&&GDFIELDPUT("UB_DESC",xDescMax,N)
	&&TK273Calcula("UB_DESC")

	If MsgYesNo("Deseja atualizar os valores conforme o desconto calculado")

		&&h:=n

		For nX:= 1 to Len(Acols)

			&&n := nX
			M->UB_DESC:=xDescMax

			aCols[nX,xPosItemD] := xDescMax

			GDFIELDPUT("UB_DESC",xDescMax,nX)

			TK273Calcula("UB_DESC",nX)

		Next nX



		&&n:=h

	EndIf

	DbSelectArea(_cAlias)
	DbSetorder(_nIndex)
	Dbgoto(_nRecno)

	Return(xDescMax)

	&&===========================================================================================================================================================
Static Function OkProc()

	lOk := ApMsgYesNo("Percentuais Digitados Ok ?","Regra de Desconto","STOP")
	If !lOk
		GDFIELDPUT("UB_DESC",xDescMax,N)
		&&TK273Calcula("UB_DESC")
	Else
		Close(oDlg1)
	EndIf

	Return()

