#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} SFLAYCAD
//Rotina de cadastro DE-PARA atributos SF x campos Protheus.
@author marcio.katsumata
@since 23/07/2019
@version 1.0
@return nil, nil
/*/
user function FILAYCAD()
	local oBrowse
	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()
	
	dbSelectArea("ZNU")
	//Alias
	oBrowse:SetAlias('ZNU')
	oBrowse:addLegend("ZNU_ATIVO=='S'", "GREEN"  ,"Ativo")
	oBrowse:addLegend("ZNU_ATIVO=='N'", "RED","N�o ativo")

	// Titulo da Browse
	oBrowse:SetDescription('Sysfiorde Layout Integra��o')


	//Define o menu do Browse
	oBrowse:setMenuDef('FILAYMOD')
	oBrowse:setFilterDefault('uniqueKey({"ZNU_ENTITY"})')
	//Habilita o bot�o para fechar a janela
	oBrowse:ForceQuitButton()

	
return oBrowse