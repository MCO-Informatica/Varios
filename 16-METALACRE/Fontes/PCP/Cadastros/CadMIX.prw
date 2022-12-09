#include 'protheus.ch'
#include 'parmtype.ch'
#include 'fwmvcdef.ch'

/*/
Autor:		Klaus Wolfgram
Data:			19/07/2017
Descricao:	Cadastro para armazenamento de dados de parametrizacao para integracao com RM.
				Utiliza a tabela SZ9 para armazenar os registros.
/*/

User Function CadMix()

	Local oBrowse   
	                                    
	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()
	
	// Definição da tabela do Browse
	oBrowse:SetAlias('PWJ')
	
	// Titulo da Browse
	oBrowse:SetDescription('Cadastro de Mix de Grupos')
	
	// Duplo click
	oBrowse:SetExecuteDef(2)
	
	// Walkthru
	oBrowse:SetWalkThru(.T.)
	
	// Ativação da Classe
	oBrowse:Activate()

Return Nil

Static Function MenuDef

	Local aRotina := {}
	
	ADD OPTION aRotina Title 'Pesquisar' 		Action 'AxPesqui'			OPERATION 1 ACCESS 0
	ADD OPTION aRotina Title 'Visualizar' 		Action 'VIEWDEF.CadMix'		OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir' 			Action 'VIEWDEF.CadMix'		OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar' 	   		ACTION 'VIEWDEF.CadMix'		OPERATION 4 ACCESS 0 
	ADD OPTION aRotina TITLE 'Excluir' 			ACTION 'VIEWDEF.CadMix'		OPERATION 5 ACCESS 0 
	ADD OPTION aRotina TITLE 'Relatorio' 		ACTION 'U_RelMix'	  		OPERATION 8 ACCESS 0	

Return aRotina

//--------------------------------------------------------------------------------------------------------
Static Function ModelDef()

   // Cria as estruturas a serem usadas no Modelo de Dados
   Local oStruPWJ := FWFormStruct( 1, 'PWJ' )
        
   Local oModel // Modelo de dados 
        
   // Cria o objeto do Modelo de Dados
   oModel := MPFormModel():New('CadMixDef')
        
   // Adiciona ao modelo um componente de formulario
   oModel:AddFields( 'PWJMASTER', /*cOwner*/, oStruPWJ )

   // Adiciona a descricao do Modelo de Dados
   oModel:SetDescription( 'Cadastro de Mix de Grupos' )
        
   // Adiciona a descricao dos Componentes do Modelo de Dados
   oModel:GetModel( 'PWJMASTER' ):SetDescription( 'Formulario' )
   oModel:SetPrimaryKey( {"PWJ_FILIAL","PWJ_COD"} )
        
    // Retorna o Modelo de dados
Return oModel

//--------------------------------------------------------------------------------------------------------
Static Function ViewDef()

   // Cria um objeto de Modelo de dados baseado no ModelDef do fonte informado
   Local oModel := FWLoadModel('CadMix')
        
   // Cria as estruturas a serem usadas na View
   Local oStruPWJ := FWFormStruct( 2, 'PWJ' )
        
   // Interface de visualizacaoo constru
   Local oView
        
   // Cria o objeto de View
   oView := FWFormView():New()
        
   // Define qual Modelo de dados sera utilizado
   oView:SetModel( oModel )
   
   oView:EnableControlBar(.T.)
        
   // Adiciona no nosso View um controle do tipo formulario (antiga Enchoice)
   oView:AddField( 'VIEW_PWJ', oStruPWJ, 'PWJMASTER' )
        
   // Cria um "box" horizontal para receber cada elemento da view
   oView:CreateHorizontalBox( 'FORMULARIO', 90 )
        
   // Relaciona o identificador (ID) da View com o "box" 
   oView:SetOwnerView( 'VIEW_PWJ', 'FORMULARIO' )
        
// Retorna o objeto de View criado
Return oView
