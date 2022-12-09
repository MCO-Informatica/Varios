//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Constantes
#Define cTABELA_GENERICA 		'U00A'
#Define cPERG_BAIXADO	 		'BHBAIXADO'
#Define cPERG_BAIXADO_SIMULA	'BHSIMULA'
#Define cPERG_BAIXADO_EFETUA	'BHEFETUA'
#Define cCAMINHO_SIMULA			'c:\temp\simula_##.xml'
#Define cCAMINHO_EFETUA			'c:\temp\efetua_##.xml'
#Define cABA_SIMULACAO			'Simula��o'
#Define cABA_EFETIVACAO			'Efetivado'
#Define cSEMANA					'01'
#Define nPARCELA				1
#Define cTIPO_1					'H'
#Define cTIPO_2					'G'
#Define cSTATUS_BAIXA			'B'
#Define cSELECIONADO			'1'
#Define lFECHAMENTO				.T.
//Vari�veis Est�ticas
Static cTitulo := "Hist�rico do Fechamento do banco de horas PLT-RCH-0008"


/*/{Protheus.doc} CSRH160
Rotina do fechamento de banco horas visando a pol�tica PLT-RCH-0008 - Acumulados
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return Nil, Fun��o n�o tem retorno
@example
u_CSRH160()
@obs N�o se pode executar fun��o MVC dentro do f�rmulas
/*/
User Function CSRH160()
    Local aArea   := GetArea()
    Local oBrowse

    if u_VldU00A(lFECHAMENTO)
	    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	    oBrowse := FWMBrowse():New()

	    //Setando a tabela de cadastro de Autor/Interprete
	    oBrowse:SetAlias("SRA")

	    //Setando a descri��o da rotina
	    oBrowse:SetDescription(cTitulo)

	    //Desabilita detalhes
	    oBrowse:DisableDetails()

	    //Ativa a Browse
	    oBrowse:Activate()

	    RestArea(aArea)
	endif
Return Nil

/*/{Protheus.doc} MenuDef
Lista do menu, podendo visualizar, simular o c�lculo e emitir relat�rio.
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return lista, Lista do menu
@obs N�o foi implentando a op��o incluir, alterar e excluir, pois se trata de simula��o dos dados,
	 mais parecido com um calculo do que com um cadastro
/*/
Static Function MenuDef()
    Local aRot := {}

    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CSRH160' 	OPERATION MODEL_OPERATION_VIEW ACCESS 0 //OPERATION 1

Return aRot

/*/{Protheus.doc} ModelDef
Modelo MVC
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return objeto, Objeto modelo
/*/
Static Function ModelDef()
    Local oModel    := Nil
    Local oStPai    := FWFormStruct(1, 'SRA')
    Local oStFilho  := FWFormStruct(1, 'PBG')
    Local aRel      := {}

    //Monta Gatilho de nome do aprovador no grid
	//aGatilho := FwStruTrigger( 'PBG_APROV' , 'PBG_APRNOM' , 'RD0->RD0_NOME' , .T. , 'RD0' , 1 , 'xFilial("RD0")+M->PBG_APROV' )
	//oStFilho:AddTrigger( aGatilho[1] , aGatilho[2] , aGatilho[3] ,aGatilho[4] )

    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('CSRH160M', , /*{|| validGrupo(oModel)}*/   )
    oModel:AddFields('SRAMASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('PBGDETAIL','SRAMASTER',oStFilho, /*{ |oModelGrid| ValidLin(oModelGrid) }*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence

    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aRel, {'PBG_FILIAL', 'RA_FILIAL'} )
    aAdd(aRel, {'PBG_MAT'	, 'RA_MAT'})

    oModel:SetRelation('PBGDETAIL', aRel, PBG->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
    oModel:GetModel('PBGDETAIL'):SetUniqueLine({ 'PBG_BAIXA', 'PBG_EVENTO' })  //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})

    //Setando as descri��es
    oModel:SetDescription("Fechamento do banco de horas")
    oModel:GetModel('SRAMASTER'):SetDescription('Colaborador')
    oModel:GetModel('PBGDETAIL'):SetDescription('Eventos de fechamento do banco de horas')
Return oModel

/*/{Protheus.doc} ModelDef
View MVC
@author Bruno Nunes
@since 12/04/2018
@version P12 1.12.17
@return objeto, Objeto view
/*/
Static Function ViewDef()
    Local oView     := Nil
    Local oModel    := FWLoadModel('CSRH160')
    Local oStPai    := FWFormStruct(2, 'SRA')
    Local oStFilho  := FWFormStruct(2, 'PBG')

    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)

	//Retira campo de relacionamento da tela
    oStFilho:RemoveField( 'PBG_FILIAL' )
    oStFilho:RemoveField( 'PBG_MAT' )
    oStFilho:RemoveField( 'PBG_NOME' )
    oStFilho:RemoveField( 'PBG_CC' )
    oStFilho:RemoveField( 'PBG_CCDESC' )

    //Adicionando os campos do cabe�alho e o grid dos filhos
    oView:AddField( 'VIEW_SRA' , oStPai   , 'SRAMASTER' )
    oView:AddGrid(  'VIEW_PBG' , oStFilho , 'PBGDETAIL' )

    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox( 'CABEC', 50 )
    oView:CreateHorizontalBox( 'GRID' , 50 )

    //Amarrando a view com as box
    oView:SetOwnerView( 'VIEW_SRA' , 'CABEC' )
    oView:SetOwnerView( 'VIEW_PBG' , 'GRID' )

    //Habilitando t�tulo
    oView:EnableTitleView( 'VIEW_SRA' , 'Colaboradores' )
    oView:EnableTitleView( 'VIEW_PBG' , 'Fechamento Banco de Horas' )
Return oView