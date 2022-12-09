#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

//Variáveis Estáticas
Static cTitulo := "Categorias eCommerce"

User Function CSSIS010()
	Local oBrowse 
	oBrowse := FwmBrowse():NEW() 
	oBrowse:SetAlias("PBZ")
	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate() // Ativando a classe obrigatorio
Return( NIL )

//-----------------------------------------------------------------------
// Rotina | MenuDef  | Autor | Rafael Beghini     | Data | 02.09.2019
//-----------------------------------------------------------------------
// Descr. | Monta as opções do browse
//-----------------------------------------------------------------------
Static Function MenuDef()
	Local aBotao := {}
	aAdd(aBotao,{ "Visualizar", "VIEWDEF.CSSIS010", 0, 2, 0, NIL } )
	aAdd(aBotao,{ "Incluir"   , "VIEWDEF.CSSIS010", 0, 3, 0, NIL } )
	aAdd(aBotao,{ "Alterar"   , "VIEWDEF.CSSIS010", 0, 4, 0, NIL } )
	aAdd(aBotao,{ "Excluir"   , "VIEWDEF.CSSIS010", 0, 5, 0, NIL } )
	aAdd(aBotao,{ "Imprimir"  , "VIEWDEF.CSSIS010", 0, 8, 0, NIL } )
Return aBotao

//-----------------------------------------------------------------------
// Rotina | ModelDef  | Autor | Rafael Beghini     | Data | 02.09.2019
//-----------------------------------------------------------------------
// Descr. | Definição do modelo de Dados
//-----------------------------------------------------------------------
Static Function ModelDef()
	Local oModel
	Local oStr1		:= FWFormStruct(1,'PBZ')
	Local bPost		:= {|| TudoOk(oModel) }
	Local bCommit	:= {|| fGrava(oModel) }

	oModel := MPFormModel():New("MODELPBZ",  , bPost, bCommit, )

	oModel:AddFields('PBZMASTER',/*cOwner*/,oStr1)
    
    oModel:SetPrimaryKey({})
    
    //Setando as descrições
    oModel:SetDescription("Categoria")
    oModel:GetModel('PBZMASTER'):SetDescription('Categorias Utilizadas nos dados da PA8')

    //Campos obrigatórios
    oStr1:SetProperty('PBZ_CATEG' ,MODEL_FIELD_OBRIGAT, .T. )
    oStr1:SetProperty('PBZ_COD'   ,MODEL_FIELD_OBRIGAT, .T. )
    oStr1:SetProperty('PBZ_DESC'  ,MODEL_FIELD_OBRIGAT, .T. )
Return oModel

//-----------------------------------------------------------------------
// Rotina | ViewDef  | Autor | Rafael Beghini     | Data | 02.09.2019
//-----------------------------------------------------------------------
// Descr. | Definição da visualização dos dados
//-----------------------------------------------------------------------
Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr1	:= FWFormStruct(2, 'PBZ')
	
	oView := FWFormView():New()

	oView:SetModel(oModel)
     
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_PBZ',oStr1,'PBZMASTER')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',50)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_PBZ','CABEC')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_PBZ','Categorias Utilizadas nos dados da PA8')   
   
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

Static Function TudoOk(oModel)
    Local lRet  := .T.
    Local cTRB  := GetNextAlias()
    Local cCateg:= oModel:GetValue("PBZMASTER","PBZ_CATEG")
    Local cCod  := oModel:GetValue("PBZMASTER","PBZ_COD")

    Beginsql Alias cTRB
        SELECT 
            COUNT(*) AS QTDE
        FROM %Table:PBZ% PBZ
        WHERE PBZ.%NOTDEL%
            AND PBZ_FILIAL = %xFilial:PBZ%
            AND PBZ_CATEG = %Exp:cCateg%
            AND PBZ_COD = %Exp:cCod%
    EndSql

    IF (cTRB)->QTDE > 0
        HS_MsgInf("Código já existente para esta categoria","Atenção","[CSSIS010] " + cTitulo)
        lRet := .F.
    EndIF
    (cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return lRet