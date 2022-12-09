#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} FILOGROT
Rotina de visualização geral do LOG de integração (tabela ZNT)
@author  marcio.katsumata
@since   18/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function FILOGROT()

    local oBrowse as object

	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()
	
	dbSelectArea("ZNT")
	//Alias
	oBrowse:SetAlias('ZNT')

	//Legendas
	oBrowse:addLegend("ZNT_STATUS=='1'", "YELLOW"      ,"Pendente")
	oBrowse:addLegend("ZNT_STATUS=='2'", "GREEN"   	   ,"Processado")
    oBrowse:addLegend("ZNT_STATUS=='3'", "RED"         ,"Erro")
	oBrowse:addLegend("ZNT_STATUS=='4'", "BR_CANCEL"   ,"Excluido")

	// Titulo da Browse
	oBrowse:SetDescription('Fiorde - Log Integração')

	oBrowse:setMenuDef('FILOGROT')
	oBrowse:setSeek(.t.)
	//Habilita o botão para fechar a janela
	oBrowse:ForceQuitButton()

	
return oBrowse

//-------------------------------------------------------------------
/*/{Protheus.doc} menudef
menudef da rotina 
@author  marcio.katsumata
@since   date
@version version
/*/
//-------------------------------------------------------------------
static function menudef()
    local aRotina as array

    aRotina := {}
    
    aAdd( aRotina, { 'Visualizar', 'AxVisual', 0, 2, 0, NIL } )

return aRotina