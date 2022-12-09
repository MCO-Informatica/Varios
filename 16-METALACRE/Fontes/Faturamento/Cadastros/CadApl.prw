//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TopConn.ch"


//Variáveis Estáticas
Static cTitulo  := "Cadastro de Aplicação Lacre"


/*/{Protheus.doc} zMod1b
Exemplo de Modelo 1 para cadastro de Artistas com validações
@author Atilio
@since 03/09/2016
@version 1.0
	@return Nil, Função não tem retorno
	@example
	u_zMod1b()
/*/
User Function CadApl()
	Local aArea   := GetArea()
	Local oBrowse
	Local cFunBkp := FunName()
	
	SetFunName("CadApl")
	
	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("SZ6")
	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Ativa a Browse
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)
Return Nil
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CadApl' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1s
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CadApl' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.CadApl' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.CadApl' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	//Blocos de código nas validações
	Local bVldCom := {|| u_zM1bCom()} //Função chamadao ao cancelar
	
	//Criação do objeto do modelo de dados
	Local oModel := Nil
	
	//Criação da estrutura de dados utilizada na interface
	Local oStSZ6 := FWFormStruct(1, "SZ6")
	
	//Editando características do dicionário
	
	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("CadAplM", , , bVldCom,) 
	
	//Atribuindo formulários para o modelo
	oModel:AddFields("FORMSZ6",/*cOwner*/,oStSZ6)
	
	//Setando a chave primária da rotina
	oModel:SetPrimaryKey({'SZ6_FILIAL','Z6_COD'})
	
	//Adicionando descrição ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descrição do formulário
	oModel:GetModel("FORMSZ6"):SetDescription("Formulário do Cadastro "+cTitulo)
	
Return oModel
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
Static Function ViewDef()
	Local aStruSZ6	:= SZ6->(DbStruct())
	
	//Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("CadApl")
	
	//Criação da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStSZ6 := FWFormStruct(2, "SZ6")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SSZ6_NOME|SSZ6_DTAFAL|'}
	
	//Criando oView como nulo
	Local oView := Nil
	//Criando a view que será o retorno da função e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formulários para interface
	oView:AddField("VIEW_SZ6", oStSZ6, "FORMSZ6")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando título do formulário
	oView:EnableTitleView('VIEW_SZ6', 'Dados - '+cTitulo )  
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
	//O formulário da interface será colocado dentro do container
	oView:SetOwnerView("VIEW_SZ6","TELA")
Return oView

/*/{Protheus.doc} zM1bCom
Função chamada após validar o ok da rotina para os dados serem salvos
@type function
@author Atilio
@since 03/09/2016
@version 1.0
/*/
User Function zM1bCom()
	Local oModelPad  := FWModelActive()
	Local cCodigo    := oModelPad:GetValue('FORMSZ6', 'Z6_COD')
	Local cDescri    := oModelPad:GetValue('FORMSZ6', 'Z6_DESCR')
	Local nOpc       := oModelPad:GetOperation()
	Local lRet       := .T.
	
	//Se for Inclusão
	If nOpc == MODEL_OPERATION_INSERT
		If RecLock('SZ6', .T.)
			SZ6->Z6_FILIAL := FWxFilial('SZ6')
			SZ6->Z6_COD  	:= cCodigo
			SZ6->Z6_DESCR   := cDescri
			SZ6->(MsUnlock())
			ConfirmSX8()
		Endif
	//Se for Alteração
	ElseIf nOpc == MODEL_OPERATION_UPDATE
		If RecLock('SZ6', .F.)
			SZ6->Z6_DESCR := cDescri
			SZ6->(MsUnlock())
		Endif
	//Se for Exclusão
	ElseIf nOpc == MODEL_OPERATION_DELETE
		
		aArea	:=	GetArea()
	
		cQry:= " SELECT 1 ACHOU " 
		cQry+= " FROM "+RETSQLNAME("SC6")+" SC6"
		cQry+= " WHERE C6_XAPLC = '" + SZ6->Z6_COD + "' "
		cQry+= " AND SC6.D_E_L_E_T_=''"
		
		TCQUERY cQry New Alias "TRD"
		
		If !Empty(TRD->ACHOU)
			MsgStop("Atenção Aplicação Não Poderá ser Excluida, pois já foi utilizada em Pedidos de Vendas !")
			TRD->(dbCloseArea())
			RestArea(aArea)
			Return .f.
		Endif
		TRD->(dbCloseArea())
		RestArea(aArea)
		
		cQry:= " SELECT 1 ACHOU " 
		cQry+= " FROM "+RETSQLNAME("SUB")+" SUB"
		cQry+= " WHERE UB_XAPLIC = '" + SZ6->Z6_COD + "' "
		cQry+= " AND SUB.D_E_L_E_T_=''"
		
		TCQUERY cQry New Alias "TRD"
		
		If !Empty(TRD->ACHOU)
			MsgStop("Atenção Aplicação Não Poderá ser Excluida, pois já foi utilizada em Orçamentos de Vendas !")
			TRD->(dbCloseArea())
			RestArea(aArea)
			Return .f.
		Endif
		TRD->(dbCloseArea())
		
		cQry:= " SELECT 1 ACHOU " 
		cQry+= " FROM "+RETSQLNAME("SZ0")+" Z0 "
		cQry+= " WHERE Z0_COD = '" + SZ6->Z6_COD + "' "
		cQry+= " AND Z0.D_E_L_E_T_=''"
		
		TCQUERY cQry New Alias "TRD"
		
		If !Empty(TRD->ACHOU)
			MsgStop("Atenção Aplicação Não Poderá ser Excluida, pois já foi utilizada em Aplicacao x Grupo!")
			TRD->(dbCloseArea())
			RestArea(aArea)
			Return .f.
		Endif
		TRD->(dbCloseArea())

		If RecLock('SZ6', .F.)
			SZ6->(DbDelete())
			SZ6->(MsUnlock())
		Endif	
		RestArea(aArea)
	EndIf
Return lRet


