#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} SFINRCAD
//Rotina de cadastro DE-PARA atributos SF x campos Protheus.
@author marcio.katsumata
@since 23/07/2019
@version 1.0
@return nil, nil
/*/
user function SFINRCAD()
	local oBrowse
	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()
	
	//Alias
	oBrowse:SetAlias('ZNR')

	// Titulo da Browse
	oBrowse:SetDescription('Sales Force Integração')

	oBrowse:addLegend("ZNR_STATUS=='1'", "BLUE"  ,"Pendente cadastro")
	oBrowse:addLegend("ZNR_STATUS=='2'", "YELLOW","Cadastro parcial")
	oBrowse:addLegend("ZNR_STATUS=='3'", "GREEN" ,"Finalizado")
	
	//Define o menu do Browse
	oBrowse:setMenuDef('SFINRMOD')

	//Habilita o botão para fechar a janela
	oBrowse:ForceQuitButton()
	// Ativao da Classe
	oBrowse:Activate()
	
	freeObj(oBrowse)
return