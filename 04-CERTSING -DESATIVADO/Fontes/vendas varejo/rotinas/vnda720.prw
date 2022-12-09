#Include 'Protheus.ch'
#Include 'Fwmvcdef.ch'

User Function VNDA720()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('Z11')
	oBrowse:SetDescription('Manutenção de DUA')
	oBrowse:SetMenuDef("VNDA720")
	oBrowse:DisableDetails()
	oBrowse:Activate()

Return(nil)

Static Function MenuDef()

Return FWMVCMenu( "VNDA720" )

Static Function ModelDef()
	Local oStruZ11 := FWFormStruct( 1, 'Z11' )
	Local oStruZ12 := FWFormStruct( 1, 'Z12' )
	Local oModel

	oModel := MPFormModel():New( 'VNDA720M' )
	oModel:AddFields( 'Z11MASTER', /*cOwner*/, oStruZ11 )
	oModel:AddGrid( 'Z12DETAIL', 'Z11MASTER', oStruZ12  )
	oModel:SetRelation( 'Z12DETAIL', { { 'Z12_FILIAL', 'xFilial( "Z12" )' }, {'Z12_CODDUA', 'Z11_CODDUA' } }, Z12->( IndexKey( 1 ) ) )
	oModel:SetDescription( 'Manutenção de DUA' )
	oModel:GetModel( 'Z11MASTER' ):SetDescription( 'DUA' )
	oModel:GetModel( 'Z12DETAIL' ):SetDescription( 'Itens' )
	oModel:SetPrimaryKey( { "Z11_FILIAL", "Z11_CODDUA" } )

Return oModel

Static Function ViewDef()
	Local oModel 	:= FWLoadModel( 'VNDA720' )
	Local oView 	:= FWFormView():New()
	Local oStruZ11 	:= FWFormStruct( 2, 'Z11' )
	Local oStruZ12 	:= FWFormStruct( 2, 'Z12' )

	//oStruZ12:RemoveField('Z12_CODDUA')

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_Z11', oStruZ11, 'Z11MASTER' )
	oView:AddGrid( 'VIEW_Z12', oStruZ12, 'Z12DETAIL' )
	oView:CreateHorizontalBox( 'SUPERIOR', 40 )
	oView:CreateHorizontalBox( 'INFERIOR', 60 )
	oView:SetOwnerView( 'VIEW_Z11', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_Z12', 'INFERIOR' )
	oView:AddIncrementField( 'VIEW_Z12', 'Z12_ITEM' )
	oView:EnableTitleView('VIEW_Z12')

Return oView

User Function VNDA720A(aCpCab, aCpItem)
	Local aRet		:= {.F.,"Erro Processamento Padrão"}
	Local nI,nJ		:= 0
	Local cMsgErro	:= ""
	Local oModel	:= nil
	Local oAux		:= nil

	oModel := FWLoadModel( 'VNDA720' )
	oModel:SetOperation( 3 )
	oModel:Activate()

	oAux 	:= oModel:GetModel( 'Z11MASTER' )
	cMsgErro:= ""

	For nI:=1 to Len(aCpCab)
		If !oModel:SetValue( 'Z11MASTER',aCpCab[nI][1],aCpCab[nI][2] )
			cMsgErro := "Erro validação "+aCpCab[nI][1]+"-"+aCpCab[nI][2]+CRLF
		EndIf
	Next

	If Empty(cMsgErro)
		oAux := oModel:GetModel( 'Z12DETAIL' )

		For nI:=1 to Len(aCpItem)
			If nI > 1
			  oAux:AddLine()
			EndIf

			For nJ:=1 to Len(aCpItem[nI])
				If !oModel:SetValue( 'Z12DETAIL',aCpItem[nI][nJ][1],aCpItem[nI][nJ][2] )
					cMsgErro := "Erro validação item "+StrZero(nI,3)+" campo "+aCpItem[nI][nJ][1]+"-"+aCpItem[nI][nJ][2]+CRLF
				EndIf
			Next nJ
		Next nI

		If Empty(cMsgErro)
			If oModel:VldData()
				oModel:CommitData()

				aRet	:= {.T.,"DUA inserida com sucesso" }
			Else
				aErro	:= oModel:GetErrorMessage()

				aRet	:= {.F.,"Erro:"+CRLF+aErro[6]+CRLF+"Solução"+CRLF+aErro[7]}

			Endif

		Else
			aRet := {.F.,cMsgErro}
		EndIf

	Else
		aRet := {.F.,cMsgErro}
	EndIf

Return(aRet)