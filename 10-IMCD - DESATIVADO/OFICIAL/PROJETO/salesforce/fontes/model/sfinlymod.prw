#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} ModelDef
Definições do modelo da tabela ZNQ. (Cadastro DE-PARA atributos SF x campos Protheus)
@author marcio.katsumata
@since 23/07/2018
@version 1.0
@return object, modelo de dados
@example
(examples)
@see (links_or_references)
/*/
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados

	Local oStruZNQ as object
	Local oStrFil  as object
	Local oModel   as object

	oStruZNQ := FWFormStruct( 1, 'ZNQ',{|cCampo| !AllTRim(cCampo) $ "|ZNQ_CMPSF|ZNQ_CMPPRT|ZNQ_FORM1|ZNQ_CONDIC|ZNQ_KEY|ZNQ_INDEX|ZNQ_INDEX2|ZNQ_DISPLY|ZNQ_TYPE"  })
	oStrFil  := FWFormStruct( 1, 'ZNQ',{|cCampo|  AllTRim(cCampo) $ "|ZNQ_CMPSF|ZNQ_CMPPRT|ZNQ_FORM1|ZNQ_CONDIC|ZNQ_KEY|ZNQ_INDEX|ZNQ_INDEX2|ZNQ_DISPLY|ZNQ_TYPE"  })

	oModel := MPFormModel():New( 'SFINLYMOD')

	oModel:AddFields( 'ZNQMASTER', NIL, oStruZNQ )
	oModel:AddGrid( 'ZNQDETAIL', 'ZNQMASTER', oStrFil )

	oModel:SetRelation( 'ZNQDETAIL', { { 'ZNQ_FILIAL', 'xFilial( "ZNQ" )' } , { 'ZNQ_ENTITY', 'ZNQ_ENTITY' } } , ZNQ->( IndexKey( 1 ) ) )

	oModel:SetDescription( 'Sales Force Layout' )
	oModel:GetModel( 'ZNQMASTER' ):SetDescription( 'Dados do Cabecalho' )
	oModel:GetModel( 'ZNQDETAIL' ):SetDescription( 'Dados do layout'  )

	oModel:SetPrimaryKey( {} )

return oModel


/*/{Protheus.doc} ViewDef
Definições da View da tabela ZNQ. (Cadastro DE-PARA atributos EccoSys x campos Protheus)
@author marcio.katsumata
@since 23/07/2018
@version 1.0
@return object, view do modelo de dados
/*/
Static Function ViewDef()
	Local oStruZNQ as object
	Local oStrFil  as object
	Local oView    as object
	Local oModel   as object

	oModel   := FWLoadModel( 'SFINLYMOD' )
	oStruZNQ := FWFormStruct( 2, 'ZNQ',{|cCampo| !AllTRim(cCampo) $ "|ZNQ_CMPSF|ZNQ_CMPPRT|ZNQ_FORM1|ZNQ_CONDIC|ZNQ_KEY|ZNQ_INDEX|ZNQ_INDEX2|ZNQ_DISPLY|ZNQ_TYPE"  })
	oStrFil  := FWFormStruct( 2, 'ZNQ',{|cCampo|  AllTRim(cCampo) $ "|ZNQ_CMPSF|ZNQ_CMPPRT|ZNQ_FORM1|ZNQ_CONDIC|ZNQ_KEY|ZNQ_INDEX|ZNQ_INDEX2|ZNQ_DISPLY|ZNQ_TYPE"  })
	oView := FWFormView():New()
	oView:SetModel( oModel )
	
	
	oView:AddField(  'VIEW_ZNQ' , oStruZNQ, 'ZNQMASTER')
	oView:AddGrid(  'VIEW_FIL' , oStrFil, 'ZNQDETAIL' )

	
	
	oView:CreateHorizontalBox( "BOX1",  20 )
	oView:CreateHorizontalBox( "BOX2",  80 )
	
	oView:SetOwnerView( 'VIEW_ZNQ' , "BOX1" )
	oView:SetOwnerView( 'VIEW_FIL' , "BOX2" )



Return oView	 

/*/{Protheus.doc} MenuDef
//Definições de menu da rotina de cadastro DE-PARA atributos Sales Force x campos Protheus.
@author ERPSERV
@since 23/07/2018
@version 1.0
@return array, rotinas.
/*/
Static Function MenuDef()
	Local aRotina := {}
	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.SFINLYMOD', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.SFINLYMOD', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.SFINLYMOD', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.SFINLYMOD', 0, 5, 0, NIL } )
Return aRotina


user function modelsfly()
return