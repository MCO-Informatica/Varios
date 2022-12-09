#include 'protheus.ch'
#include "fwmvcdef.ch"


/*/{Protheus.doc} modelDef
Modeldef da tabela AIA x AIB (cadastro de tabela de preços)
@type function
@version 1.0
@author marcio.katsumata
@since 18/03/2020
@return object, FormModel
/*/
static function modelDef()
	local oStrAIA as object
	local oStrAIB as object
	local nPosNomFor as numeric
	Local oModel   as object


	oStrAIA := FWFormStruct( 1, "AIA")
	oStrAIB := FWFormStruct( 1, "AIB")
	oModel := MPFormModel():New( "TBPRCCMP",,{|oModel|U_TBPRCTOK(oModel)} )

	//-----------------------------------------------------------------------------------------
	//Tratativa para o nome do fornecedor para que retorne sempre .T. a validação de sistema
	//-----------------------------------------------------------------------------------------
	nPosNomFor := aScan(oStrAIA:aFields, {|aField| alltrim(aField[3]) == "AIA_NOMFOR"})

	if nPosNomFor > 0
		oStrAIA:aFields[nPosNomFor][7] := {|a,b,c,d| FWInitCpo(a,b,c),lRet:=((.T.)),FWCloseCpo(a,b,c,lRet),lRet  }
	endif


	oModel:AddFields( "AIAMASTER", NIL, oStrAIA )
	oModel:AddGrid( "AIBDETAIL", "AIAMASTER", oStrAIB )

	oModel:SetRelation( "AIBDETAIL", { { "AIB_FILIAL", "xFilial( 'AIA' )" } ,;
		{ "AIB_CODFOR", "AIA_CODFOR" },;
		{ "AIB_LOJFOR", "AIA_LOJFOR" },;
		{ "AIB_CODTAB", "AIA_CODTAB" }} , AIB->( IndexKey( 1 ) ) )

	oModel:getModel("AIBDETAIL"):setUniqueLine({"AIB_CODPRO", "AIB_XINCOT", "AIB_XVIAEM","AIB_QTDLOT" ,"AIB_INDLOT"})
	oModel:getModel("AIBDETAIL"):SetMaxLine(9999)

	oModel:SetDescription( "Tabela de preços" )
	oModel:GetModel( "AIAMASTER" ):SetDescription( "Dados do Cabecalho" )
	oModel:GetModel( "AIBDETAIL" ):SetDescription( "Dados dos itens"  )

	oModel:SetPrimaryKey( {} )



return oModel


/*/{Protheus.doc} ViewDef
Definições da View da tabela AIA E AIB. (Cadastro de tabela de preço)
@author marcio.katsumata
@since 18/03/2019
@version 1.0
@return object, view do modelo de dados
/*/
Static Function ViewDef()
	Local oStrAIA as object
	Local oStrAIB  as object
	Local oView    as object
	Local oModel   as object

	oModel   := FWLoadModel( "TBPRCCMP" )

	oStrAIA := FWFormStruct( 2, "AIA")
	oStrAIB := FWFormStruct( 2, "AIB",{|cCampo| ! AllTRim(cCampo) $ "|AIB_FILIAL|AIB_CODFOR|AIB_LOJFOR|AIB_CODTAB|"  })

	oView := FWFormView():New()
	oView:SetModel( oModel )

	oView:AddField( "VIEW_AIA" , oStrAIA, "AIAMASTER")
	oView:AddGrid(  "VIEW_AIB" , oStrAIB, "AIBDETAIL")

	oView:CreateHorizontalBox( "BOX1",  30 )
	oView:CreateHorizontalBox( "BOX2",  70 )

	oView:SetOwnerView( "VIEW_AIA" , "BOX1" )
	oView:SetOwnerView( "VIEW_AIB" , "BOX2" )

	oView:AddIncrementField("VIEW_AIB", "AIB_ITEM")

	oView:AddUserButton("Alterar Data Vigencia","",{|oView|U_ReplicaDataVigenciaTabelaPrecoCompras(oView)},"Altera data vigência de todos os itens")

Return oView

/*/{Protheus.doc} MenuDef
//Definições de menu da rotina de cadastro de tabela de preços.
@author marcio.katsumata
@since 18/03/2020
@version 1.0
@return array, rotinas.
/*/
Static Function MenuDef()
	Local aRotina := {}
	Private CUSERTABCOMP := SuperGetMv("ES_TABCOMP",,'000315')

	aAdd( aRotina, { "Visualizar", "VIEWDEF.TBPRCCMP", 0, 2, 0, NIL } )
	iF (__cUserId $ CUSERTABCOMP ) 

		aAdd( aRotina, { "Incluir"   , "VIEWDEF.TBPRCCMP", 0, 3, 0, NIL } )
		aAdd( aRotina, { "Alterar"   , "VIEWDEF.TBPRCCMP", 0, 4, 0, NIL } )
		aAdd( aRotina, { "Excluir"   , "VIEWDEF.TBPRCCMP", 0, 5, 0, NIL } )
		aAdd( aRotina, { "Copiar"    , "U_CopiaTabelaDePrecosCompras", 0, 9, 0, NIL } )
		aAdd( aRotina, { "Reajuste"  , "Com010Rej", 0, 5, 0, NIL } )
		aadd( aRotina, { "Importar"  , "U_ImportaTabelaPrecoCompras", 0, 3, 0, NIL })

	endif

	aAdd( aRotina, { "Exportar"  , "U_ExportaTabelaPrecoCompras", 0, 2, 0, NIL } )
Return aRotina

/*/{Protheus.doc} TBPRCTOK
Validação total do modelo
@type function
@version 1.0
@author marcio.katsumata
@since 18/03/2020
@return logical, validado?
/*/
user function TBPRCTOK()

	Local aArea     := GetArea()
	Local lRetorno  := .T.

	//---------------------------------------------
	//Validação de data de vigência inicial e final
	//---------------------------------------------
	If !Empty( FwFldGet("AIA_DATDE")) .And. !Empty(FwFldGet("AIA_DATATE")) .And. (FwFldGet("AIA_DATDE") > FwFldGet("AIA_DATATE"))
		Help(" ",1,"DATA2INVAL")
		lRetorno := .F.
	Endif

	If lRetorno .And. (ExistBlock("CM010TOK"))
		lRetorno := ExecBlock("CM010TOK",.F.,.F.,{lRetorno})
		If ValType(lRetorno) <> "L"
			lRetorno := .T.
		EndIf
	EndIf

	RestArea(aArea)

Return(lRetorno)

/*/{Protheus.doc} TBPRCCMP
Ponto de entrada do model AIA x AIB
@type function
@version 1.0
@author marcio.katsumata
@since 23/04/2020
@return return_type, return_description
/*/
user function TBPRCCMP()
	local aParam as array
	local xRet


	aParam := PARAMIXB
	xRet   := .T.

	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := alltrim(aParam[2])
		cIdModel   := alltrim(aParam[3])

		if cIdPonto == 'FORMLINEPOS'
			oModelPrc  := FWModelActive()
			oModAIB := oModelPrc:GetModel('AIBDETAIL')

			if !empty(oModAIB:getValue("AIB_XVIAEM"))
				if !(xRet := !empty(oModAIB:getValue("AIB_XINCOT")))
					oModelPrc:SetErrorMessage("AIBDETAIL","AIB_XINCOT" ,"AIBDETAIL","AIB_XINCOT",;
						"Tabela Preço Compras","Validação Incoterm",;
						"Incoterm obrigatório, pois a via de transporte está preenchida.")
				endif
			endif

		endif

	endif

return xRet
