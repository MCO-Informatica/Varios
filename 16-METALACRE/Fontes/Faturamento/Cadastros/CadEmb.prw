#include 'protheus.ch'
#include 'parmtype.ch'
#include 'fwmvcdef.ch'

/*/
Autor:		Klaus Wolfgram
Data:			19/07/2017
Descricao:	Cadastro para armazenamento de dados de parametrizacao para integracao com RM.
				Utiliza a tabela SZ9 para armazenar os registros.
/*/

User Function CadEmb()

	Local oBrowse   
	                                    
	// Instanciamento da Classe de Browse
	oBrowse := FWMBrowse():New()
	
	// Definição da tabela do Browse
	oBrowse:SetAlias('Z05')
	
	// Titulo da Browse
	oBrowse:SetDescription('Cadastro de Embalagens')
	
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
	ADD OPTION aRotina Title 'Visualizar' 		Action 'VIEWDEF.CadEmb'		OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir' 			Action 'VIEWDEF.CadEmb'		OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar' 	   		ACTION 'VIEWDEF.CadEmb'		OPERATION 4 ACCESS 0 
	ADD OPTION aRotina TITLE 'Excluir' 			ACTION 'VIEWDEF.CadEmb'		OPERATION 5 ACCESS 0 
	ADD OPTION aRotina TITLE 'Relatorio' 		ACTION 'U_RelEmb'	  		OPERATION 8 ACCESS 0	

Return aRotina

//--------------------------------------------------------------------------------------------------------
Static Function ModelDef()

   // Cria as estruturas a serem usadas no Modelo de Dados
   Local oStruZ05 := FWFormStruct( 1, 'Z05' )
        
   Local oModel // Modelo de dados 
        
   // Cria o objeto do Modelo de Dados
   oModel := MPFormModel():New('CADEMBDEF')
        
   // Adiciona ao modelo um componente de formulario
   oModel:AddFields( 'Z05MASTER', /*cOwner*/, oStruZ05 )

   // Adiciona a descricao do Modelo de Dados
   oModel:SetDescription( 'Cadastro de Embalagens' )
        
   // Adiciona a descricao dos Componentes do Modelo de Dados
   oModel:GetModel( 'Z05MASTER' ):SetDescription( 'Formulario' )
   oModel:SetPrimaryKey( {"Z05_FILIAL","Z05_COD"} )
        
    // Retorna o Modelo de dados
Return oModel

//--------------------------------------------------------------------------------------------------------
Static Function ViewDef()

   // Cria um objeto de Modelo de dados baseado no ModelDef do fonte informado
   Local oModel := FWLoadModel('CADEMB')
        
   // Cria as estruturas a serem usadas na View
   Local oStruZ05 := FWFormStruct( 2, 'Z05' )
        
   // Interface de visualizacaoo constru
   Local oView
        
   // Cria o objeto de View
   oView := FWFormView():New()
        
   // Define qual Modelo de dados sera utilizado
   oView:SetModel( oModel )
   
   oView:EnableControlBar(.T.)
        
   // Adiciona no nosso View um controle do tipo formulario (antiga Enchoice)
   oView:AddField( 'VIEW_Z05', oStruZ05, 'Z05MASTER' )
        
   // Cria um "box" horizontal para receber cada elemento da view
   oView:CreateHorizontalBox( 'FORMULARIO', 90 )
        
   // Relaciona o identificador (ID) da View com o "box" 
   oView:SetOwnerView( 'VIEW_Z05', 'FORMULARIO' )
        
// Retorna o objeto de View criado
Return oView