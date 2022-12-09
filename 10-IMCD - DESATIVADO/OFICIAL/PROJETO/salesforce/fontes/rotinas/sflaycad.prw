#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} SFLAYCAD
//Rotina de cadastro DE-PARA atributos SF x campos Protheus.
@author marcio.katsumata
@since 23/07/2019
@version 1.0
@return nil, nil
/*/
user function SFLAYCAD()
	local oBrowse
	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()
	
	//Alias
	oBrowse:SetAlias('ZNQ')
	oBrowse:addLegend("ZNQ_ATIVO=='S'", "GREEN"  ,"Pendente SFTP")
	oBrowse:addLegend("ZNQ_ATIVO=='N'", "RED","Aguardando retorno SF")

	// Titulo da Browse
	oBrowse:SetDescription('Sales Force Layout Integração')


	//Define o menu do Browse
	oBrowse:setMenuDef('SFINLYMOD')
	oBrowse:setFilterDefault('uniqueKey({"ZNQ_ENTITY"})')
	//Habilita o botão para fechar a janela
	oBrowse:ForceQuitButton()
	// Ativao da Classe
	oBrowse:Activate()
	
	freeObj(oBrowse)
return