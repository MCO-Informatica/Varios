#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

Static aIndSZF
Static lCopia


User Function SHFAT013()

	Local oBrowse	:= Nil
	Private cCadastro := 'Metas'  //"Meta de Venda"
	Private bGeraMeta := {|| U_SHFAT012() }
	Private bEfetMeta := {|| U_SHFAT014() }


	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SZE')
	oBrowse:SetDescription(cCadastro)  //"Meta de Venda"
	oBrowse:Activate()

	Return(.T.)


Static Function ModelDef()

	Local oModel
	&&Local oStruCab := FWFormStruct(1,'SZF',{|cCampo| AllTrim(UPPER(cCampo))+"|" $ "Z6_CODIGO|Z6_DESCRIC|Z6_TOTAL|Z6_VLRPRE|Z6_ANO|"})
	Local oStruCab := FWFormStruct(1,'SZE')
	Local oStruGrid := FWFormStruct(1,'SZF')

	Local bActivate     := {|oMdl|SHFT013ACT(oMdl)}
	Local bPosValidacao := {|oMdl|SHFT013Pos(oMdl)}
	Local bLinePost 	:= {||SHFTLinOk()}

	oModel := MPFormModel():New('SHFT013',/*bPreValidacao*/,bPosValidacao,/*bCommit*/,/*bCancel*/)
	oModel:AddFields('SZECAB',/*cOwner*/,oStruCab,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/)
	oModel:AddGrid( 'SZFGRID','SZECAB',oStruGrid,/*bLinePre*/,bLinePost,/*bPreVal*/,/*bPosVal*/)


	oModel:SetRelation("SZFGRID",{{"ZF_FILIAL",'xFilial("SZF")'},{"ZF_DOC","ZE_MESANO"}},SZF->(IndexKey(1)))
	oModel:SetPrimaryKey({'ZF_FILIAL','ZF_DOC','ZF_SEQUEN'})
	oModel:GetModel( 'SZFGRID' ):SetUniqueLine( { 'ZF_DOC','ZF_REGIAO','ZF_DATA','ZF_PRODUTO' } )

	oModel:SetActivate(bActivate)
	oModel:SetDescription(cCadastro)

	Return(oModel)

Static Function ViewDef()

	Local oView

	Local oModel     := FWLoadModel('SHFAT013')
	&&Local oStruCab   := FWFormStruct(2,'SZF',{|cCampo| AllTrim(UPPER(cCampo))+"|" $ "Z6_CODIGO|Z6_DESCRIC|Z6_TOTAL|Z6_VLRPRE|Z6_ANO|"})
	Local oStruCab   := FWFormStruct(2,'SZE')
	Local oStruGrid  := FWFormStruct(2,'SZF')
	Local aCabExcel  := SHFT013Cab()  			// Cria o cabecalho para utilizacao no Microsoft Excel
	Local aUsrBut    := {}     					// recebe o ponto de entrada
	Local aButtons	 := {}                      // botoes da enchoicebar
	Local nAuxFor    := 0                       // auxiliar do For , contador da Array aUsrBut
	Local oMdlCab    := oModel:GetModel('SZECAB')
	Local oMdlGrid   := oModel:GetModel('SZFGRID')
	Local aAux       := {}
	Local oCalc1

	oView:= FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('VIEW_CABZE',oStruCab,'SZECAB')
	oView:AddGrid('VIEW_GRIDZF',oStruGrid,'SZFGRID' )


	oView:AddIncrementField('VIEW_GRIDZF','ZF_SEQUEN')

	oView:CreateHorizontalBox('SUPERIOR',20)
	oView:CreateHorizontalBox('INFERIOR',80)


	oView:SetOwnerView( 'VIEW_CABZE','SUPERIOR' )
	oView:SetOwnerView( 'VIEW_GRIDZF','INFERIOR' )



	Return(oView)


Static Function MenuDef()
	Local aRotina :={}
	Local aUsrBut :={}
	Local nX := 0


	ADD OPTION aRotina TITLE 'Pesqusiar'  		ACTION 'PesqBrw' 			OPERATION 1	ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.SHFAT013'	OPERATION 2	ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    		ACTION 'VIEWDEF.SHFAT013'	OPERATION 4	ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'   		ACTION 'VIEWDEF.SHFAT013'	OPERATION 5	ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar Metas'		ACTION 'Eval(bGeraMeta)'   	OPERATION 3	ACCESS 0
	ADD OPTION aRotina TITLE 'Efetivar Metas'	ACTION 'Eval(bEfetMeta)'   	OPERATION 3	ACCESS 0

	Return(aRotina)


Static Function SHFT013Act(oMdl)
	Local lRet := .T.

	Local nOperation := oMdl:GetOperation()
	Local oMdlGrid := oMdl:GetModel('SZFGRID')
	Local nX := 0

	if nOperation == 3
		For nX:= 1 to oMdlGrid:GetQtdLine()
			oMdlGrid:GoLine(nX)
			oMdlGrid:SetValue("ZF_SEQUEN",cValToChar(StrZero(nX,TamSx3("ZF_SEQUEN")[1])),.T.)
		Next nX
		lCopia := .F.
	EndIf

	Return lRet

Static Function SHFT013CAL( oFW, lPar )
	Local lRet := .T.

	If lPar
		lRet := .T.
	Else
		lRet := .F.
	EndIf
	Return lRet


Static Function SHFT013Pos(oMdl)
	Local lRet := .T.
	Local nOperation := oMdl:GetOperation()

	If nOperation == 5
		If Subs(SZE->ZE_MESANO,3,4) + Subs(SZE->ZE_MESANO,1,2) < Anomes(Date())
			Aviso('Meta já Gerada','Não é possível excluir este cadastro de metas',{'OK'})
			lRet := .F.
		Else
			SCT->(DbSetORder(1))
			If SCT->(DbSeek(xFilial('SCT') + SZE->ZE_MESANO))
				While !SCT->(Eof()) .And. Alltrim(SCT->CT_DOC) == SZE->ZE_MESANO
					If RecLock("SCT",.f.,.t.)
						SCT->(DbDelete())
						MsUnlock("SCT")
					EndIF
					SCT->(DbSkip())
				EndDo
				lRet := .T.
			EndIf
		EndIf
	EndIF

	Return(lRet)

Static Function SHFT013Cmt(oMdl)
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

Static Function SHFT013Can(oMdl)

	Local nOperation:= oMdl:GetOperation()

	If nOperation == 3
		RollBackSX8()
	EndIf

	Return(.T.)

Static Function SHFTCopia()

	Local cTitulo		:= 'Copia'
	Local nOperation 	:= 9 // Define o modo de operacao como copia
	lCopia := .T.

	FWExecView(cTitulo,'VIEWDEF.SHFT013',nOperation,/*oDlg*/,/*bCloseOnOk*/,/*bOk*/,/*nPercReducao*/)

	Return Nil


Static Function SHFT013Cab()

	Local aCabec := {}

	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZE_DOC")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZE_ANOMES")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("ZE_DESCRI")
	aadd(aCabec,{OemToAnsi(X3Titulo()),SX3->X3_PICTURE,Nil})

	Return(aCabec)

Static Function SHFTLinOk()

	Local oMdl		:= FWModelActive()
	Local oMdlCab	:= oMdl:GetModel('SZECAB')
	Local oMdlGrid	:= oMdl:GetModel('SZFGRID')
	Local nPValor	:= 0
	Local nPQuant	:= oMdlGrid:GetValue('ZF_QUANT') // quantidade
	Local lRet	:= .T.
	Local nVlrPrev :=  0
	Local aSaveLines  := FWSaveRows()

	Return(lRet)

