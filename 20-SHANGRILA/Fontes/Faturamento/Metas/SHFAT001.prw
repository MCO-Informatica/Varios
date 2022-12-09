#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

Static aIndSZ6
Static lCopia


User Function SHFAT001()

	Local oBrowse	:= Nil
	Private cCadastro := 'Budget Anual'  //"Meta de Venda"
	Private bRateio   	:= {|| SHFTRateio(SZ5->Z5_CODIGO,SZ5->Z5_ANO)}
	Private bReajuste  	:= {|| U_SHFAT007(SZ5->Z5_CODIGO,SZ5->Z5_ANO)}
	Private bGera   	:= {|| U_SHFAT008()}
	Private bCopia   	:= {|| U_SHFAT016()}

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SZ5')
	oBrowse:SetDescription('Budget Anual')  //"Meta de Venda"
	oBrowse:Activate()

Return(.T.)


Static Function ModelDef()

	Local oModel
&&Local oStruCab := FWFormStruct(1,'SZ6',{|cCampo| AllTrim(UPPER(cCampo))+"|" $ "Z6_CODIGO|Z6_DESCRIC|Z6_TOTAL|Z6_VLRPRE|Z6_ANO|"})
	Local oStruCab := FWFormStruct(1,'SZ5')
	Local oStruGrid := FWFormStruct(1,'SZ6')

	Local bActivate     := {|oMdl|SHFT001ACT(oMdl)}
	Local bPosValidacao := {|oMdl|SHFT001Pos(oMdl)}
	Local bCommit		:= {|oMdl|SHFT001Cmt(oMdl)}
	Local bCancel   	:= {|oMdl|SHFT001Can(oMdl)}
	Local bLinePost 	:= {||SHFTLinOk()}
	Local bLinePre      := {||SHFTDELOk()}

	oStruGrid:RemoveField('Z6_CODIGO')

	oModel := MPFormModel():New('SHFT001',/*bPreValidacao*/,bPosValidacao,/*bCommit*/,/*bCancel*/)
	oModel:AddFields('SZ5CAB',/*cOwner*/,oStruCab,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:AddGrid( 'SZ6GRID','SZ5CAB',oStruGrid,bLinePre,bLinePost,/*bLinePre*/,/*bLinePre*/)


	oModel:SetRelation("SZ6GRID",{{"Z6_FILIAL",'xFilial("SZ6")'},{"Z6_CODIGO","Z5_CODIGO"}},SZ6->(IndexKey(1)))
	oModel:SetPrimaryKey({'Z6_FILIAL','Z6_CODIGO','Z6_SEQUEN'})
	oModel:GetModel( 'SZ6GRID' ):SetUniqueLine( { 'Z6_PRODUTO' } )

	oModel:SetActivate(bActivate)
	oModel:SetDescription('Budget Anual')

Return(oModel)

Static Function ViewDef()

	Local oView

	Local oModel     := FWLoadModel('SHFAT001')
	&&Local oStruCab := FWFormStruct(2,'SZ6',{|cCampo| AllTrim(UPPER(cCampo))+"|" $ "Z6_CODIGO|Z6_DESCRIC|Z6_TOTAL|Z6_VLRPRE|Z6_ANO|"})
	Local oStruCab   := FWFormStruct(2,'SZ5')
	Local oStruGrid  := FWFormStruct(2,'SZ6')
	Local aCabExcel  := SHFT001Cab()  			// Cria o cabecalho para utilizacao no Microsoft Excel
	Local aUsrBut    := {}     					// recebe o ponto de entrada
	Local aButtons	 := {}                      // botoes da enchoicebar
	Local nAuxFor    := 0                       // auxiliar do For , contador da Array aUsrBut
	Local oMdlCab    := oModel:GetModel('SZ5CAB')
	Local oMdlGrid   := oModel:GetModel('SZ6GRID')
	Local aAux       := {}
	Local oCalc1

	oStruGrid:RemoveField('Z6_CODIGO')

	oView:= FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('VIEW_CABZ5',oStruCab,'SZ5CAB')
	oView:AddGrid('VIEW_GRIDZ6',oStruGrid,'SZ6GRID' )


	oView:AddIncrementField('VIEW_GRIDZ6','Z6_SEQUEN')

	oView:CreateHorizontalBox('SUPERIOR',20)
	oView:CreateHorizontalBox('INFERIOR',80)


	oView:SetOwnerView( 'VIEW_CABZ5','SUPERIOR' )
	oView:SetOwnerView( 'VIEW_GRIDZ6','INFERIOR' )



Return(oView)


Static Function MenuDef()
	Local aRotina :={}
	Local aUsrBut :={}
	Local nX := 0


	ADD OPTION aRotina TITLE 'Pesqusiar'  		ACTION 'PesqBrw' 			OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.SHFAT001'	OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    		ACTION 'VIEWDEF.SHFAT001'	OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    		ACTION 'VIEWDEF.SHFAT001'	OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'   		ACTION 'VIEWDEF.SHFAT001'	OPERATION 5	ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Reajuste'   ACTION 'Eval(bReajuste)'  	OPERATION 6	ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar BudGet'		ACTION 'Eval(bGera)'      	OPERATION 7	ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Rateio'     ACTION 'U_SHFTRateio()'		OPERATION 8	ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     		ACTION 'Eval(bCopia)' 	OPERATION 9 ACCESS 0
	

Return(aRotina)


Static Function SHFT001Act(oMdl)
	Local lRet := .T.

	Local nOperation := oMdl:GetOperation()
	Local oMdlGrid := oMdl:GetModel('SZ6GRID')
	Local nX := 0

	if nOperation == 3
		For nX:= 1 to oMdlGrid:GetQtdLine()
			oMdlGrid:GoLine(nX)
			oMdlGrid:SetValue("Z6_SEQUEN",cValToChar(StrZero(nX,TamSx3("Z6_SEQUEN")[1])),.T.)
		Next nX
		lCopia := .F.
	EndIf

Return lRet

Static Function SHFT001CAL( oFW, lPar )
	Local lRet := .T.

	If lPar
		lRet := .T.
	Else
		lRet := .F.
	EndIf
Return lRet


Static Function SHFT001Pos(oMdl)
	Local lRet := .T.
	Local nOperation := oMdl:GetOperation()

	If nOperation == 5
		SZA->(DbSetORder(1))
		If SZA->(DbSeek(xFilial('SZA') + SZ5->Z5_CODIGO))
			Aviso('Previsão já Gerada','Não é possível excluir o cadastro de Budget pois já foi executada a rotina de geração de previsão',{'OK'})
			lRet := .F.
		EndIf
	EndIf

Return(lRet)

Static Function SHFT001Cmt(oMdl)
	Local nOperation := oMdl:GetOperation()

	If nOperation == 3  .Or. nOperation == 5
		FWModelActive(oMdl)
		FWFormCommit(oMdl)
	Endif

	If nOperation == 4
		FWModelActive(oMdl)
		FWFormCommit(oMdl)
		SHFTGrvDesc(oMdl)
	EndIf

Return(.T.)

Static Function SHFT001Can(oMdl)

	Local nOperation:= oMdl:GetOperation()

	If nOperation == 3
		RollBackSX8()
	EndIf

Return(.T.)

Static Function SHFTCopia()

	Local cTitulo		:= 'Copia'
	Local nOperation 	:= 9 // Define o modo de operacao como copia
	lCopia := .T.

	FWExecView(cTitulo,'VIEWDEF.SHFT001',nOperation,/*oDlg*/,/*bCloseOnOk*/,/*bOk*/,/*nPercReducao*/)

Return Nil

User Function SHFTRateio()

	U_SHFAT002(SZ5->Z5_CODIGO,SZ5->Z5_ANO,SZ5->Z5_VLRPRE)

Return Nil

Static Function SHFTGrvDesc(oMdl)

	Local oMdlCab := oMdl:GetModel('SZ5CAB')
	Local oMdlGrid := oMdl:GetModel('SZ6GRID')
	Local nX := 0

	dbSelectArea("SZ6")
	dbSetOrder(1)
	For nX:= 1 to oMdlGrid:GetQtdLine()
		oMdlGrid:GoLine(nX)
		If DbSeek(xFilial("SZ6")+oMdlCab:GetValue("Z6_CODIGO")+oMdlGrid:GetValue("Z6_SEQUEN"))
			RecLock("SZ6",.F.)
			SZ6->Z6_DESCRIC := oMdlCab:GetValue("Z6_DESCRIC")
			MsUnlock()
		Endif
	Next nX

Return Nil

Static Function SHFT001Cab()

	Local aCabec := {}

	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("Z5_CODIGO")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("Z5_DESCRIC")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("Z5_TOTAL")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("Z5_VLRPRE")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX4")
	dbSetOrder(2)
	dbSeek("Z5_ANO")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})

Return(aCabec)

Static Function SHFTDELOk()

	Local oMdl		:= FWModelActive()
	Local oMdlCab	:= oMdl:GetModel('SZ5CAB')
	Local oMdlGrid	:= oMdl:GetModel('SZ6GRID')
	Local nPValor	:= 0
	Local nPQuant	:= oMdlGrid:GetValue('Z6_QUANT') // quantidade
	Local lRet	:= .T.
	Local nVlrPrev :=  0
	Local aSaveLines  := FWSaveRows()

	SZ6->(DbSetOrder(1))

	nPValor	:= oMdlGrid:GetValue('Z6_QUANT')  * oMdlGrid:GetValue('Z6_VLRPMV') &&oMdlGrid:GetValue('Z6_VALOR') // valor
	If Empty(nPValor) .Or. Empty(nPQuant)   .Or. nPValor < 0  .Or. nPQuant < 0
		nPValor := 0
	EndIf
	nVlrPrev := Round(nPValor,2)

	IF oMdlGrid:IsDeleted()
		oMdlCab:LoadValue('Z5_VLRPRE', oMdlCab:GetValue('Z5_VLRPRE') + nVlrPrev )
	Else
		If Empty(Readvar())
			oMdlCab:LoadValue('Z5_VLRPRE', oMdlCab:GetValue('Z5_VLRPRE') - nVlrPrev )
		Else
			SHFTLinOk()
		EndIf
	EndIf
	FWRestRows( aSaveLines )

Return(lRet)

Static Function SHFTLinOk()

	Local oMdl		:= FWModelActive()
	Local oMdlCab	:= oMdl:GetModel('SZ5CAB')
	Local oMdlGrid	:= oMdl:GetModel('SZ6GRID')
	Local nPValor	:= 0
	Local nPQuant	:= oMdlGrid:GetValue('Z6_QUANT') // quantidade
	Local lRet	:= .T.
	Local nVlrPrev :=  0
	Local aSaveLines  := FWSaveRows()

	For nX:= 1 to oMdlGrid:GetQtdLine()
		If !oMdlGrid:IsDeleted()
			oMdlGrid:GoLine(nX)
			nPValor	:= oMdlGrid:GetValue('Z6_QUANT')  * oMdlGrid:GetValue('Z6_VLRPMV') &&oMdlGrid:GetValue('Z6_VALOR') // valor
			If Empty(nPValor) .Or. Empty(nPQuant)   .Or. nPValor < 0  .Or. nPQuant < 0
				nPValor := 0
			EndIf
			nVlrPrev += Round(nPValor,2)
		Else
			oMdlGrid:GoLine(nX)
			nPValor	:= oMdlGrid:GetValue('Z6_QUANT')  * oMdlGrid:GetValue('Z6_VLRPMV') &&oMdlGrid:GetValue('Z6_VALOR') // valor
			If Empty(nPValor) .Or. Empty(nPQuant)   .Or. nPValor < 0  .Or. nPQuant < 0
				nPValor := 0
			EndIf
			nVlrPrev -= Round(nPValor,2)
		EndIf
	Next
	oMdlCab:LoadValue('Z5_VLRPRE', nVlrPrev )
	FWRestRows( aSaveLines )

Return(lRet)


Static Function SHFTMsg(oTree,oSay1,oSay2,aSoma)

	Local nPSoma := 0
	Local cSeek  := oTree:GetCargo()

	nPSoma := aScan(aSoma,{|x| x[1]==cSeek })

	oSay1:SetText(AllTRim( TransForm(aSoma[nPSoma,2],PesqPict("SZ6","Z6_QUANT",18))))
	oSay2:SetText(AllTRim( TransForm(aSoma[nPSoma,3],PesqPict("SZ6","Z6_VALOR",18))))


Return(.T.)


User Function SHFTCLEAR( nType )

	Local oModel := FWModelActive()
	Local aArea  := GetArea()
	Local aAreaSB1 := SB1->( GetArea() )
	local nQuant := 0
	Local nValor := 0
	Local nValPmv:= 0
	Local nTotalPmv := 0
	Local nQuantPmv := 0
	Local aRetVen   := {}
	Local aRetVenQ  := {}
	Local aRetDev  	:= {}
	Local aRetDevQ  := {}
	Local cDescr    := ''
	Local cDataAnt  := cToD('01/01/' + oModel:GetValue( 'SZ5CAB', 'Z5_ANO' ))
	If nType == 1
		SB1->( dbSetOrder( 1 ) )
		If SB1->( dbSeek( xFilial("SB1") + M->Z6_PRODUTO ) )
		
			cDescr := Alltrim(SB1->B1_DESC)
			oModel:LoadValue( 'SZ6GRID', 'Z6_PRDDESC', cDescr )
			oModel:LoadValue( 'SZ6GRID', 'Z6_GRUPO', SB1->B1_GRUPO )
			oModel:LoadValue( 'SZ6GRID', 'Z6_TIPO' , SB1->B1_TIPO  )
		
			aRetVen  := U_SHFATPMV(1,oModel:GetValue( 'SZ6GRID', 'Z6_PRODUTO' ),oModel:GetValue( 'SZ6GRID', 'Z6_GRUPO' ),oModel:GetValue( 'SZ5CAB', 'Z5_PERINI' ),oModel:GetValue( 'SZ5CAB', 'Z5_PERFIM' ))
			aRetVenQ := U_SHFATPMV(2,oModel:GetValue( 'SZ6GRID', 'Z6_PRODUTO' ),oModel:GetValue( 'SZ6GRID', 'Z6_GRUPO' ),oModel:GetValue( 'SZ5CAB', 'Z5_PERINI' ),oModel:GetValue( 'SZ5CAB', 'Z5_PERFIM' ))
			aRetDev  := U_SHFATPMV(3,oModel:GetValue( 'SZ6GRID', 'Z6_PRODUTO' ),oModel:GetValue( 'SZ6GRID', 'Z6_GRUPO' ),oModel:GetValue( 'SZ5CAB', 'Z5_PERINI' ),oModel:GetValue( 'SZ5CAB', 'Z5_PERFIM' ))
			aRetDevQ := U_SHFATPMV(4,oModel:GetValue( 'SZ6GRID', 'Z6_PRODUTO' ),oModel:GetValue( 'SZ6GRID', 'Z6_GRUPO' ),oModel:GetValue( 'SZ5CAB', 'Z5_PERINI' ),oModel:GetValue( 'SZ5CAB', 'Z5_PERFIM' ))
		
			nValPmv := If(aRetVen[1] > 0 ,Round((aRetVen[1] - aRetDev[1])/(aRetVenQ[2] - aRetDevQ[2]),2),0)
			If nValPmv <= 0
				nValPmv := SB1->B1_PRV1
			Endif
			oModel:LoadValue( 'SZ6GRID', 'Z6_VLRPMV' , nValPmv )
			oModel:LoadValue( 'SZ6GRID', 'Z6_TOTANT' , Round((aRetVen[1] - aRetDev[1]),2) )
			oModel:LoadValue( 'SZ6GRID', 'Z6_QTDANT' , Round((aRetVenQ[2] - aRetDevQ[2]),2))
			oModel:LoadValue( 'SZ6GRID', 'Z6_VALOR'  , Round(oModel:GetValue( 'SZ6GRID', 'Z6_QUANT' ) * nValPmv,2)  )
		Else
			oModel:ClearField( 'SZ6GRID', 'Z6_PRODUTO' )
			oModel:ClearField( 'SZ6GRID', 'Z6_TIPO'    )
			oModel:ClearField( 'SZ6GRID', 'Z6_PRDDESC'    )
			oModel:ClearField( 'SZ6GRID', 'Z6_GRUPO'    )
			oModel:ClearField( 'SZ6GRID', 'Z6_VLRPMV'    )
			oModel:ClearField( 'SZ6GRID', 'Z6_TOTANT'    )
			oModel:ClearField( 'SZ6GRID', 'Z6_QTDANT'    )
			oModel:ClearField( 'SZ6GRID', 'Z6_VALOR'    )
			oModel:ClearField( 'SZ6GRID', 'Z6_QUANT'    )
		EndIf
	ElseIf  nType == 2
		oModel:ClearField( 'SZ6GRID', 'Z6_PRODUTO' )
		oModel:ClearField( 'SZ6GRID', 'Z6_TIPO'    )
	
	ElseIf nType == 3
		oModel:ClearField( 'SZ6GRID', 'Z6_PRODUTO' )
		oModel:ClearField( 'SZ6GRID', 'Z6_GRUPO'   )
	
	ElseIf nType == 4
		nQuant  := oModel:GetValue( 'SZ6GRID', 'Z6_QUANT' )
		nValPmv  := oModel:GetValue( 'SZ6GRID', 'Z6_VLRPMV' )
		oModel:LoadValue( 'SZ6GRID', 'Z6_VALOR', nQuant *  nValPmv )
		nValor  := oModel:GetValue( 'SZ6GRID', 'Z6_VALOR' )
		oModel:LoadValue( 'SZ6GRID', 'Z6_QUANT', nValor /  nValPmv )
	ElseIf nType == 5
		nValor  := oModel:GetValue( 'SZ6GRID', 'Z6_VALOR' )
		nValPmv  := oModel:GetValue( 'SZ6GRID', 'Z6_VLRPMV' )
		oModel:LoadValue( 'SZ6GRID', 'Z6_QUANT', nValor /  nValPmv )
	EndIf

	SHFTLinOk()

	RestArea(aAreaSB1)
	RestArea(aArea)

Return .T.

User Function SHFATPMV(nOp,cProduto,cGrupo,dDataIni,dDataFim)
	Local cAlias		:= GetNextAlias()
	Local aQuery        := {}
	Local nTotal		:= 0
	Local nQuant		:= 0
	Local aArea  := GetArea()

	If nOp == 1 && Vendas Valor
	
		BeginSql Alias cAlias
			SELECT SD2.D2_COD, SB1.B1_DESC, SB1.B1_GRUPO, SUM(SD2.D2_QUANT) AS D2_QUANT, SUM(SD2.D2_TOTAL) AS D2_TOTAL
			FROM %TABLE:SD2% SD2
			INNER JOIN %TABLE:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD
			INNER JOIN %TABLE:SF4% SF4 ON SD2.D2_TES = SF4.F4_CODIGO
			INNER JOIN %TABLE:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D2_DOC = SF2.F2_DOC AND	SD2.D2_SERIE = SF2.F2_SERIE
			INNER JOIN %TABLE:SA3% SA3 ON SF2.F2_VEND1 = SA3.A3_COD
			WHERE
			SD2.D2_FILIAL = %xfilial:SD2%
			AND SF2.F2_FILIAL = %xfilial:SF2%
			AND SF4.F4_FILIAL = %xfilial:SF4%
			AND SA3.A3_FILIAL = %xfilial:SA3%
			AND SB1.B1_FILIAL = %xfilial:SB1%
			AND (SD2.D2_EMISSAO BETWEEN %EXP:dDataIni% AND %EXP:dDataFim%)
			AND (SD2.D2_COD BETWEEN %EXP:cProduto% AND %EXP:cProduto%)
			AND (SB1.B1_GRUPO = %EXP:cGrupo% )
			AND (SF2.F2_EST BETWEEN %EXP:""% AND %EXP:"ZZZZZ"%)
			AND (SF2.F2_VEND1 BETWEEN %EXP:""% AND %EXP:"ZZZZ"%)
			AND SF4.F4_DUPLIC = 'S'
			AND SD2.%NOTDEL%
			AND SB1.%NOTDEL%
			AND SA3.%NOTDEL%
			AND SF2.%NOTDEL%
			AND SF4.%NOTDEL%
			GROUP BY SB1.B1_GRUPO, SD2.D2_COD, SB1.B1_DESC
			ORDER BY SB1.B1_GRUPO, SD2.D2_COD, SB1.B1_DESC
		
		EndSql
	
		aQuery := GETLastQuery()
	
		If !(cAlias)->(Eof())
			nTotal := (cAlias)->D2_TOTAL
			nQuant := 0
		EndIf
	
		(cAlias)->(DbCloseArea())
	ElseIf nOp == 2  && Vendas Quantidade
	
		BeginSql Alias cAlias
			SELECT SD2.D2_COD, SB1.B1_DESC, SB1.B1_GRUPO, SUM(SD2.D2_QUANT) AS D2_QUANT, SUM(SD2.D2_TOTAL) AS D2_TOTAL
			FROM %TABLE:SD2% SD2
			INNER JOIN %TABLE:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD
			INNER JOIN %TABLE:SF4% SF4 ON SD2.D2_TES = SF4.F4_CODIGO
			INNER JOIN %TABLE:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D2_DOC = SF2.F2_DOC AND	SD2.D2_SERIE = SF2.F2_SERIE
			INNER JOIN %TABLE:SA3% SA3 ON SF2.F2_VEND1 = SA3.A3_COD
			WHERE
			SD2.D2_FILIAL = %xfilial:SD2%
			AND SF2.F2_FILIAL = %xfilial:SF2%
			AND SF4.F4_FILIAL = %xfilial:SF4%
			AND SA3.A3_FILIAL = %xfilial:SA3%
			AND SB1.B1_FILIAL = %xfilial:SB1%
			AND (SD2.D2_EMISSAO BETWEEN %EXP:dDataIni% AND %EXP:dDataFim%)
			AND (SD2.D2_COD BETWEEN %EXP:cProduto% AND %EXP:cProduto%)
			AND (SB1.B1_GRUPO = %EXP:cGrupo%)
			AND (SF2.F2_EST BETWEEN %EXP:""% AND %EXP:"ZZZZZ"%)
			AND (SF2.F2_VEND1 BETWEEN %EXP:""% AND %EXP:"ZZZZ"%)
			AND SF4.F4_ESTOQUE = 'S'
			AND SD2.%NOTDEL%
			AND SB1.%NOTDEL%
			AND SA3.%NOTDEL%
			AND SF2.%NOTDEL%
			AND SF4.%NOTDEL%
			GROUP BY SB1.B1_GRUPO, SD2.D2_COD, SB1.B1_DESC
			ORDER BY SB1.B1_GRUPO, SD2.D2_COD, SB1.B1_DESC
		
		EndSql
	
		aQuery := GETLastQuery()
	
		If !(cAlias)->(Eof())
			nTotal := 0
			nQuant := (cAlias)->D2_QUANT
		EndIf
	
		(cAlias)->(DbCloseArea())
	
	ElseIf nOp == 3  && Devoluções
		BeginSql Alias cAlias
			SELECT SB1.B1_GRUPO, SD1.D1_COD, SUM(SD1.D1_QUANT) AS D1_QUANT, SUM(SD1.D1_TOTAL - SD1.D1_VALDESC) AS D1_TOTAL, D1_DTDIGIT
			FROM %TABLE:SD1% SD1
			INNER JOIN %TABLE:SB1% SB1 ON SD1.D1_COD = SB1.B1_COD
			INNER JOIN %TABLE:SF4% SF4 ON SD1.D1_TES = SF4.F4_CODIGO
			WHERE
			SD1.D1_FILIAL = %xfilial:SD1%
			AND SF4.F4_FILIAL = %xfilial:SF4%
			AND SB1.B1_FILIAL = %xfilial:SB1%
			AND (SD1.D1_DTDIGIT BETWEEN %EXP:dDataIni% AND %EXP:dDataFim%)
			AND (SD1.D1_COD BETWEEN %EXP:cProduto% AND %EXP:cProduto%)
			AND (SB1.B1_GRUPO BETWEEN %EXP:cGrupo% AND %EXP:'ZZZZZZ'%)
			AND SD1.D1_TIPO = 'D'
			AND SD1.%NOTDEL%
			AND SB1.%NOTDEL%
			AND SF4.%NOTDEL%
			GROUP BY SB1.B1_GRUPO, SD1.D1_COD, SD1.D1_DTDIGIT
			ORDER BY SB1.B1_GRUPO, SD1.D1_COD, SD1.D1_DTDIGIT
		
		EndSql
	
		aQuery := GETLastQuery()
	
		If !(cAlias)->(Eof())
			nTotal := (cAlias)->D1_TOTAL
			nQuant := 0
		EndIf
	
		(cAlias)->(DbCloseArea())
	ElseIf nOp == 4  && Devoluções quantidades
		BeginSql Alias cAlias
			SELECT SB1.B1_GRUPO, SD1.D1_COD, SUM(SD1.D1_QUANT) AS D1_QUANT, SUM(SD1.D1_TOTAL - SD1.D1_VALDESC) AS D1_TOTAL
			FROM %TABLE:SD1% SD1
			INNER JOIN %TABLE:SB1% SB1 ON SD1.D1_COD = SB1.B1_COD
			INNER JOIN %TABLE:SF4% SF4 ON SD1.D1_TES = SF4.F4_CODIGO
			WHERE
			SD1.D1_FILIAL = %xfilial:SD1%
			AND SF4.F4_FILIAL = %xfilial:SF4%
			AND SB1.B1_FILIAL = %xfilial:SB1%
			AND (SD1.D1_DTDIGIT BETWEEN %EXP:dDataIni% AND %EXP:dDataFim%)
			AND (SD1.D1_COD BETWEEN %EXP:cProduto% AND %EXP:cProduto%)
			AND (SB1.B1_GRUPO BETWEEN %EXP:cGrupo% AND %EXP:'ZZZZZZ'%)
			AND SD1.D1_TIPO = 'D'
			AND SF4.F4_ESTOQUE = 'S'
			AND SD1.%NOTDEL%
			AND SB1.%NOTDEL%
			AND SF4.%NOTDEL%
			GROUP BY SB1.B1_GRUPO, SD1.D1_COD 
			ORDER BY SB1.B1_GRUPO, SD1.D1_COD
		
		EndSql
	
		aQuery := GETLastQuery()
	
		If !(cAlias)->(Eof())
			nTotal := 0
			nQuant := (cAlias)->D1_QUANT
		EndIf
	
		(cAlias)->(DbCloseArea())
	EndIf

	RestArea(aArea)

Return {nTotal,nQuant}

Static Function AjustaHlp()

	Local aArea		:= Getarea()
	Local aAreaSX3	:= SX3->(Getarea())
	Local aHelpPor	:= {}
	Local aHelpSpa	:= {}
	Local aHelpEng	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³HELP na Inclusao  		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Problema												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aHelpPor,"Nao ha registros a serem gravados na " )
	Aadd(aHelpPor,"tabela SCT - Metas de Venda."  )
// Espanhol
	Aadd(aHelpSpa,"No existen registros para grabar " )
	Aadd(aHelpSpa,"en la tabla SCT - Metas de venta."  )
// Ingles
	Aadd(aHelpEng,"No records are to be recorded " )
	Aadd(aHelpEng,"in the table SCT - Sales Goals"  )
	PutHelp("PA050NAOREG",aHelpPor,aHelpEng,aHelpSpa,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Solucao 												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}

	Aadd(aHelpPor,"Verifique a sequencia das Metas de Venda." )
// Espanhol
	Aadd(aHelpSpa,"Verifique la sequencia de las Metas de" )
	Aadd(aHelpSpa,"venta." )
// Ingles
	Aadd(aHelpEng,"Check the sequence of Sales Goals." )
	PutHelp("SA050NAOREG",aHelpPor,aHelpEng,aHelpSpa,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³HELP na Alteracao                               		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Problema												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}

	Aadd(aHelpPor,"Para excluir todos os itens utilize" )
	Aadd(aHelpPor,"a opcao Excluir Metas de Venda."  )
// Espanhol
	Aadd(aHelpSpa,"Para borrar todos los items use  " )
	Aadd(aHelpSpa,"la rotina Borrar Meta de Venta."  )
// Ingles
	Aadd(aHelpEng,"To delete all items use the" )
	Aadd(aHelpEng,"Delete option Sales Goals."  )
	PutHelp("PA050EXCL",aHelpPor,aHelpEng,aHelpSpa,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Solucao 												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}

	Aadd(aHelpPor,"Posicione Meta de Venda e clique" )
	Aadd(aHelpPor,"no botao excluir." )
// Espanhol
	Aadd(aHelpSpa,"Posicione Meta de Venta y clique" )
	Aadd(aHelpSpa,"en el botao borrar." )
// Ingles
	Aadd(aHelpEng,"Position Sales Goals and click" )
	Aadd(aHelpEng,"on the delete button." )
	PutHelp("SA050EXCL",aHelpPor,aHelpEng,aHelpSpa,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajusta o dicionario de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SX3")
	DbSetOrder(2)

	If Dbseek("Z6_PRODUTO") .AND. AllTrim(SX3->X3_VALID) <> '( Vazio() .Or. ExistCpo("SB1") ) .and. U_SHFTCLEAR( 1 )'
		RecLock("SX3",.F.)
		SX3->X3_VALID	:= '( Vazio() .Or. ExistCpo("SB1") ) .and. U_SHFTCLEAR( 1 )'
		MsUnLock()
	EndIf

	If Dbseek("Z6_GRUPO") .AND. AllTrim(SX3->X3_VALID) <> '( Vazio() .Or. ExistCpo("SBM") ) .and. U_SHFTCLEAR( 2 )'
		RecLock("SX3",.F.)
		SX3->X3_VALID	:= '( Vazio() .Or. ExistCpo("SBM") ) .and. U_SHFTCLEAR( 2 )'
		MsUnLock()
	EndIf

	If Dbseek("Z6_TIPO") .AND. AllTrim(SX3->X3_VALID) <> '( Vazio() .Or. ExistCpo("SX5","02"+M->Z6_TIPO) ) .and. U_SHFTCLEAR( 3 )'
		RecLock("SX3",.F.)
		SX3->X3_VALID	:= '( Vazio() .Or. ExistCpo("SX5","02"+M->Z6_TIPO) ) .and. U_SHFTCLEAR( 3 )'
		MsUnLock()
	EndIf

	RestArea(aAreaSX3)
	RestArea(aArea)

Return
