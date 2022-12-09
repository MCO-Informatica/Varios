#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

//Variáveis Estáticas
Static cTitulo := "Cadastro Exceções PCO"

//-----------------------------------------------------------------------------
// Rotina | CSPCO011  | Autor | Joao Goncalves de Oliveira | Data | 19.01.2016
//-----------------------------------------------------------------------------
// Descr. | Rotina para cadastro de Exceções do PCO
//-----------------------------------------------------------------------------
// Update | Transformação da rotina para MVC - Rafael Beghini 28.08.2018
//-----------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------------
User Function CSPCO011()
	Local oBrowse 
	oBrowse := FwmBrowse():NEW() 
	oBrowse:SetAlias("PB3")
	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate() // Ativando a classe obrigatorio
Return( NIL )

//-----------------------------------------------------------------------
// Rotina | CSPCO011  | Autor | Rafael Beghini     | Data | 28.08.2018
//-----------------------------------------------------------------------
// Descr. | Monta as opções do browse
//-----------------------------------------------------------------------
Static Function MenuDef()
	Local aBotao := {}
	aAdd(aBotao,{ "Visualizar", "VIEWDEF.CSPCO011", 0, 2, 0, NIL } )
	aAdd(aBotao,{ "Incluir"   , "VIEWDEF.CSPCO011", 0, 3, 0, NIL } )
	aAdd(aBotao,{ "Alterar"   , "VIEWDEF.CSPCO011", 0, 4, 0, NIL } )
	aAdd(aBotao,{ "Excluir"   , "VIEWDEF.CSPCO011", 0, 5, 0, NIL } )
	aAdd(aBotao,{ "Imprimir"  , "VIEWDEF.CSPCO011", 0, 8, 0, NIL } )
Return aBotao

//-----------------------------------------------------------------------
// Rotina | CSPCO011  | Autor | Rafael Beghini     | Data | 28.08.2018
//-----------------------------------------------------------------------
// Descr. | Definição do modelo de Dados
//-----------------------------------------------------------------------
Static Function ModelDef()
	Local oModel
	Local oStr1		:= FWFormStruct(1,'PB3')
	Local oStr2		:= FWFormStruct(1,'PB4')
	Local aPB4Rel	:= {}
	Local bPost		:= {|| .T. }
	Local bCommit	:= {|| fGrava(oModel) }
	Local bSair		:= {|| fSair(oModel) }

	oModel := MPFormModel():New("MODELPB3",  , bPost, bCommit, bSair)

	oModel:AddFields('PB3MASTER',/*cOwner*/,oStr1)
    oModel:AddGrid('PB4DETAIL','PB3MASTER',oStr2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
    
    oStr1:SetProperty('PB3_FILIAL' , MODEL_FIELD_INIT,{|| xFilial('PB3') } )
    oStr1:SetProperty('PB3_CODIGO' , MODEL_FIELD_INIT,{|| GetSXeNum('PB3', 'PB3_CODIGO') } )
    oStr2:SetProperty('PB4_FILIAL' , MODEL_FIELD_INIT,{|| xFilial('PB3') } )
	oStr2:SetProperty('PB4_CODIGO' , MODEL_FIELD_INIT,{|| PB3->PB3_CODIGO } )
	
	oModel:SetDescription('Descrição')
	 
    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aPB4Rel, {'PB4_FILIAL',    'PB3_FILIAL'} )
    aAdd(aPB4Rel, {'PB4_CODIGO',    'PB3_CODIGO'} )
     
    oModel:SetRelation('PB4DETAIL', aPB4Rel, PB4->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('PB4DETAIL'):SetUniqueLine({"PB4_FILIAL","PB4_CODIGO","PB4_SEQUEN"})
    oModel:SetPrimaryKey({})
    
    //Setando para utilizar aCOLS
    oModel:GetModel('PB4DETAIL'):lUseCols := .T. 

    //Setando as descrições
    oModel:SetDescription("Exceções PCO")
    oModel:GetModel('PB3MASTER'):SetDescription('Modelo Descrição')
    oModel:GetModel('PB4DETAIL'):SetDescription('Modelo Transferências')
Return oModel

//-----------------------------------------------------------------------
// Rotina | CSPCO011  | Autor | Rafael Beghini     | Data | 28.08.2018
//-----------------------------------------------------------------------
// Descr. | Definição da visualização dos dados
//-----------------------------------------------------------------------
Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1	:= FWFormStruct(2, 'PB3')
	Local oStr2 := FWFormStruct(2, 'PB4')
	oView := FWFormView():New()

	oView:SetModel(oModel)
     
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_PB3',oStr1,'PB3MASTER')
    oView:AddGrid('VIEW_PB4',oStr2,'PB4DETAIL')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',50)
    oView:CreateHorizontalBox('GRID',50)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_PB3','CABEC')
    oView:SetOwnerView('VIEW_PB4','GRID')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_PB3','Exceções PCO')
    oView:EnableTitleView('VIEW_PB4','Detalhamento')
    
    //Campos incrementais
    oView:AddIncrementField('VIEW_PB4','PB4_SEQUEN')
    
    //Remove campos da GRID
    oStr2:RemoveField("PB4_FILIAL")
    oStr2:RemoveField("PB4_CODIGO")
Return oView
//-----------------------------------------------------------------------
// Rotina | CSPCO011  | Autor | Rafael Beghini     | Data | 28.08.2018
//-----------------------------------------------------------------------
// Descr. | Função para o Commit
//-----------------------------------------------------------------------
Static Function fGrava(oModel)
	Local lRet := .T.
	Begin Transaction
		If FwFormCommit(oModel)
			If oModel:GetOperation() == MODEL_OPERATION_INSERT // MODEL_OPERATION_UPDATE | MODEL_OPERATION_DELETE
				ConfirmSX8()
			EndIf
		Else
			If oModel:GetOperation() == MODEL_OPERATION_INSERT // MODEL_OPERATION_UPDATE | MODEL_OPERATION_DELETE
				RollBackSX8()
			EndIf
			Help(,,"Atenção !!!",,"Problema na gravação dos dados",1,0)
			lRet := .F.
			DisarmTransaction()
		EndIf
	End Transaction 
Return lRet

//-----------------------------------------------------------------------
// Rotina | fSair  | Autor | Rafael Beghini     | Data | 11.11.2019
//-----------------------------------------------------------------------
// Descr. | Função para o Rollback na numeração
//-----------------------------------------------------------------------
Static Function fSair(oModel)
	Local lRet := .T.

	If oModel:GetOperation() == MODEL_OPERATION_INSERT // MODEL_OPERATION_UPDATE | MODEL_OPERATION_DELETE
		RollBackSX8()
	EndIf
	
Return lRet