#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} ModelDef
Definições do modelo da tabela ZNU. (Cadastro DE-PARA atributos SF x campos Protheus)
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

	Local oStruZNU as object
	Local oStrFil  as object
	Local oModel   as object

	oStruZNU := FWFormStruct( 1, 'ZNU',{|cCampo| !AllTRim(cCampo) $ "|ZNU_SEQ|ZNU_CMPFI|ZNU_CMPPRT|ZNU_FORM1|ZNU_CONDIC|ZNU_KEY|ZNU_INDEX|ZNU_INDEX2|ZNU_DISPLY"  })
	oStrFil  := FWFormStruct( 1, 'ZNU',{|cCampo|  AllTRim(cCampo) $ "|ZNU_SEQ|ZNU_CMPFI|ZNU_CMPPRT|ZNU_FORM1|ZNU_CONDIC|ZNU_KEY|ZNU_INDEX|ZNU_INDEX2|ZNU_DISPLY"  })

	oModel := MPFormModel():New( 'FILYMOD')

	oModel:AddFields( 'ZNUMASTER', NIL, oStruZNU )
	oModel:AddGrid( 'ZNUDETAIL', 'ZNUMASTER', oStrFil )

	oModel:SetRelation( 'ZNUDETAIL', { { 'ZNU_FILIAL', 'xFilial( "ZNU" )' } , { 'ZNU_ENTITY', 'ZNU_ENTITY' } } , ZNU->( IndexKey( 5 ) ) )
	
	oModel:SetOptional('ZNUDETAIL', .T.)
	
	oModel:SetDescription( 'Fiorde Layout' )
	oModel:GetModel( 'ZNUMASTER' ):SetDescription( 'Dados do Cabecalho' )
	oModel:GetModel( 'ZNUDETAIL' ):SetDescription( 'Dados do layout'  )

	oModel:SetPrimaryKey( {} )

return oModel


/*/{Protheus.doc} ViewDef
Definições da View da tabela ZNU. (Cadastro DE-PARA atributos EccoSys x campos Protheus)
@author marcio.katsumata
@since 23/07/2018
@version 1.0
@return object, view do modelo de dados
/*/
Static Function ViewDef()
	Local oStruZNU as object
	Local oStrFil  as object
	Local oView    as object
	Local oModel   as object

	oModel   := FWLoadModel( 'FILAYMOD' )
	oStruZNU := FWFormStruct( 2, 'ZNU',{|cCampo| !AllTRim(cCampo) $ "|ZNU_SEQ|ZNU_CMPFI|ZNU_CMPPRT|ZNU_FORM1|ZNU_CONDIC|ZNU_KEY|ZNU_INDEX|ZNU_INDEX2|ZNU_DISPLY"  })
	oStrFil  := FWFormStruct( 2, 'ZNU',{|cCampo|  AllTRim(cCampo) $ "|ZNU_SEQ|ZNU_CMPFI|ZNU_CMPPRT|ZNU_FORM1|ZNU_CONDIC|ZNU_KEY|ZNU_INDEX|ZNU_INDEX2|ZNU_DISPLY"  })
	oView := FWFormView():New()
	oView:SetModel( oModel )
	

	oView:AddField(  'VIEW_ZNU' , oStruZNU, 'ZNUMASTER')
	oView:AddGrid(  'VIEW_FIL' , oStrFil, 'ZNUDETAIL' )

	
	
	oView:CreateHorizontalBox( "BOX1",  20 )
	oView:CreateHorizontalBox( "BOX2",  80 )
	
	oView:SetOwnerView( 'VIEW_ZNU' , "BOX1" )
	oView:SetOwnerView( 'VIEW_FIL' , "BOX2" )

	oView:AddIncrementField("VIEW_FIL", "ZNU_SEQ")

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
	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.FILAYMOD', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.FILAYMOD', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.FILAYMOD', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.FILAYMOD', 0, 5, 0, NIL } )
Return aRotina


user function modelfily()
return
