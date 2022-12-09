#INCLUDE "PROTHEUS.CH" 
#INCLUDE 'FWMVCDEF.CH'   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVA008		�Autor  �Microsiga	     � Data �  30/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de impressoras para impress�o de rotulo colorido   ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVA008()
Local oBrowse  

DbSelectArea('PZ1')

//Cria o objeto do tipo FWMBrowse
oBrowse := FWMBrowse():New()     

//Alias ta tabela a ser utilizada no browse
oBrowse:SetAlias('PZ1') 

//Descri��o da rotina
oBrowse:SetDescription("Cadastro de impressoras")

oBrowse:Activate()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ModelDef		�Autor  �Microsiga	     � Data �  30/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Define o modelo de dados									  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef() 

// Cria a estrutura a ser usada no Model
Local oStruPZ1 := FWFormStruct( 1, 'PZ1', /*bAvalCampo*/, /*lViewUsado*/ ) 
Local oModel


//Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'PZCVA08M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ ) 

//Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo (antiga enchoice)
oModel:AddFields( 'PZ1MASTER', /*cOwner*/, oStruPZ1, ) 

//Chave Primaria
oModel:SetPrimaryKey({"PZ1_COD"}) 

//Adiciona a descricao do Modelo de Dados
oModel:SetDescription("Cadastro de impressoras") 

//Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'PZ1MASTER' ):SetDescription( 'Master' ) 

Return oModel

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ViewDef		�Autor  �Microsiga	     � Data �  30/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Interface do cadastro										  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()      

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado 
Local oModel   	 :=  FWLoadModel( 'PZCVA008' ) 
Local oView

// Cria a estrutura a ser usada na View
Local oStruPZ1 	:= FWFormStruct( 2, 'PZ1' ) 

// Cria o objeto de View
oView := FWFormView():New() 

// Define qual o Modelo de dados ser� utilizado
oView:SetModel( oModel ) 

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_PZ1', oStruPZ1, 'PZ1MASTER' )                     

// Criar "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR'  	, 100)


// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_PZ1', 'SUPERIOR') 

Return oView        


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �MenuDef		�Autor  �Microsiga	     � Data �  30/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Menu com a defini��o das rotinas							  ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef() 
Local aRotina := {} 

ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.PZCVA008' 	OPERATION 2 ACCESS 0
ADD OPTION aRotina Title "Incluir"	    			Action 'VIEWDEF.PZCVA008' 	OPERATION 3 ACCESS 0
ADD OPTION aRotina Title "Alterar"  				Action 'VIEWDEF.PZCVA008' 	OPERATION 4 ACCESS 0
ADD OPTION aRotina Title "Excluir"					Action 'VIEWDEF.PZCVA008'	OPERATION 5 ACCESS 0 

Return aRotina 