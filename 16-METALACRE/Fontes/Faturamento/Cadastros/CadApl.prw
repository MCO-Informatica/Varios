//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TopConn.ch"


//Vari�veis Est�ticas
Static cTitulo  := "Cadastro de Aplica��o Lacre"


/*/{Protheus.doc} zMod1b
Exemplo de Modelo 1 para cadastro de Artistas com valida��es
@author Atilio
@since 03/09/2016
@version 1.0
	@return Nil, Fun��o n�o tem retorno
	@example
	u_zMod1b()
/*/
User Function CadApl()
	Local aArea   := GetArea()
	Local oBrowse
	Local cFunBkp := FunName()
	
	SetFunName("CadApl")
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("SZ6")
	//Setando a descri��o da rotina
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
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CadApl' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1s
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CadApl' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.CadApl' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.CadApl' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	//Blocos de c�digo nas valida��es
	Local bVldCom := {|| u_zM1bCom()} //Fun��o chamadao ao cancelar
	
	//Cria��o do objeto do modelo de dados
	Local oModel := Nil
	
	//Cria��o da estrutura de dados utilizada na interface
	Local oStSZ6 := FWFormStruct(1, "SZ6")
	
	//Editando caracter�sticas do dicion�rio
	
	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("CadAplM", , , bVldCom,) 
	
	//Atribuindo formul�rios para o modelo
	oModel:AddFields("FORMSZ6",/*cOwner*/,oStSZ6)
	
	//Setando a chave prim�ria da rotina
	oModel:SetPrimaryKey({'SZ6_FILIAL','Z6_COD'})
	
	//Adicionando descri��o ao modelo
	oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
	
	//Setando a descri��o do formul�rio
	oModel:GetModel("FORMSZ6"):SetDescription("Formul�rio do Cadastro "+cTitulo)
	
Return oModel
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/
Static Function ViewDef()
	Local aStruSZ6	:= SZ6->(DbStruct())
	
	//Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("CadApl")
	
	//Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
	Local oStSZ6 := FWFormStruct(2, "SZ6")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SSZ6_NOME|SSZ6_DTAFAL|'}
	
	//Criando oView como nulo
	Local oView := Nil
	//Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Atribuindo formul�rios para interface
	oView:AddField("VIEW_SZ6", oStSZ6, "FORMSZ6")
	
	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox("TELA",100)
	
	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_SZ6', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	oView:SetOwnerView("VIEW_SZ6","TELA")
Return oView

/*/{Protheus.doc} zM1bCom
Fun��o chamada ap�s validar o ok da rotina para os dados serem salvos
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
	
	//Se for Inclus�o
	If nOpc == MODEL_OPERATION_INSERT
		If RecLock('SZ6', .T.)
			SZ6->Z6_FILIAL := FWxFilial('SZ6')
			SZ6->Z6_COD  	:= cCodigo
			SZ6->Z6_DESCR   := cDescri
			SZ6->(MsUnlock())
			ConfirmSX8()
		Endif
	//Se for Altera��o
	ElseIf nOpc == MODEL_OPERATION_UPDATE
		If RecLock('SZ6', .F.)
			SZ6->Z6_DESCR := cDescri
			SZ6->(MsUnlock())
		Endif
	//Se for Exclus�o
	ElseIf nOpc == MODEL_OPERATION_DELETE
		
		aArea	:=	GetArea()
	
		cQry:= " SELECT 1 ACHOU " 
		cQry+= " FROM "+RETSQLNAME("SC6")+" SC6"
		cQry+= " WHERE C6_XAPLC = '" + SZ6->Z6_COD + "' "
		cQry+= " AND SC6.D_E_L_E_T_=''"
		
		TCQUERY cQry New Alias "TRD"
		
		If !Empty(TRD->ACHOU)
			MsgStop("Aten��o Aplica��o N�o Poder� ser Excluida, pois j� foi utilizada em Pedidos de Vendas !")
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
			MsgStop("Aten��o Aplica��o N�o Poder� ser Excluida, pois j� foi utilizada em Or�amentos de Vendas !")
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
			MsgStop("Aten��o Aplica��o N�o Poder� ser Excluida, pois j� foi utilizada em Aplicacao x Grupo!")
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


