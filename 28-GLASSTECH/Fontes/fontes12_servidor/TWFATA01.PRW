#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FwMBrowse.ch"
#INCLUDE "FwMVCDef.ch" 

/*/{Protheus.doc} User Function TWFATA01
    (Cadastro de Amarração Cliente x Cond Pagto)
    @type  Function
    @author Pirolo
    @since 23/07/2021
    @return Nil
    /*/
User Function TWFATA01()
Local aLegenda  := {}
Local oBrowse   := NIL
Local oLeg      := Nil

Private cCadastr    := Posicione("SX2", 1, "PA1", "X2_NOME")
Private aRotina     := MenuDef()

DbSelectArea("PA1")
PA1->(DbSetOrder(1))

oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'PA1' )
oBrowse:SetDescription( cCadastr )
// DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
oBrowse:SetMenuDef("TWFATA01")
oBrowse:Activate()

Return 

/*/{Protheus.doc} MenuDef
    (MenuDef)
    @type  Static Function
    @author Pirolo
    @since 23/07/2021
    @return aRotina, Array, Array com a estrutura de botões MVC
    /*/
Static Function MenuDef()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis locais.                                  	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*Local aRotina := {} //Array utilizado para controlar opcao selecionada

ADD OPTION aRotina TITLE "Pesquisar" 	ACTION 'PesqBrw'         OPERATION 1 ACCESS 0 //'Pesquisar'
ADD OPTION aRotina TITLE "Visualizar" 	ACTION 'VIEWDEF.TWFATA01' OPERATION MODEL_OPERATION_VIEW ACCESS 0 //'Visualizar'
ADD OPTION aRotina TITLE "Incluir" 		ACTION 'VIEWDEF.TWFATA01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //'Incluir'
ADD OPTION aRotina TITLE "Alterar" 		ACTION 'VIEWDEF.TWFATA01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //'Alterar'
ADD OPTION aRotina TITLE "Excluir" 		ACTION 'VIEWDEF.TWFATA01' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //'Excluir'
*/
Local aRotina := FwMVCMenu("TWFATA01")

Return aRotina

/*/{Protheus.doc} ModelDef
    (ModelDef)
    @type  Static Function
    @author Pirolo
    @since 23/07/2021
    @version version
    @return oModel, Objeto, Objeto MVC
    /*/
Static Function ModelDef()
// Cria as estruturas a serem usadas no Modelo de Dados
Local oStruPA1 := FWFormStruct( 1, 'PA1' )
Local oStruPA2 := FWFormStruct( 1, 'PA2' )

Local oModel // Modelo de dados construído

//Monta a inicialização do grid
Local bLoad     := {|oGridModel| CarregGrd(oGridModel)}
Local bLinePre  := {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| linePreGrid(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)}
Local bLinPOS   := {|oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue| linePOSGrid(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)}
Local bPost     := {|oGridModel| PosVldModel( oGridModel ) }

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'MODFATA01', , bPost, /*bCommit*/,)

// Adiciona ao modelo um componente de formulário
oModel:AddFields( 'PA1MASTER', /*cOwner*/, oStruPA1 )

// Adiciona ao modelo uma componente de grid
oModel:AddGrid( 'PA2DETAIL', 'PA1MASTER', oStruPA2, bLinePre, bLinPOS, , , /*bLoad*/)

// Faz relacionamento entre os componentes do model
oModel:SetRelation( 'PA2DETAIL', {  { 'PA2_FILIAL', 'xFilial( "PA2" )'  },;
                                    { 'PA2_CLIENT', 'PA1_CLIENT'        } }, PA2->( IndexKey( 1 ) ) )

// Adiciona a descrição do Modelo de Dados
oModel:SetDescription( 'Amarração Cliente x Cond Pagamento' )

// Adiciona a descrição dos Componentes do Modelo de Dados
oModel:GetModel( 'PA1MASTER' ):SetDescription( 'Cliente' )

oModel:GetModel( 'PA2DETAIL' ):SetDescription( 'Condições de Pagamento' )
oModel:GetModel("PA2DETAIL"):SetUniqueLine( { "PA2_FILIAL", "PA2_CLIENT", "PA2_CONDPA" } )
oModel:GetModel("PA2DETAIL"):SetOptional(.F.)

oModel:SetPrimaryKey( { "PA1_FILIAL", "PA1_CLIENT" } )

oModel:SetActivate()
// Retorna o Modelo de dados
Return oModel

/*/{Protheus.doc} ViewDef
    (ViewDef)
    @type  Static Function
    @author Pirolo
    @since 23/07/2021
    @version version
    @return oView, Objeto, Objeto de View
    /*/
Static Function ViewDef()
// Cria um objeto de Modelo de dados baseado no ModelDef do fonte informado
Local oModel := nil
// Cria as estruturas a serem usadas na View
Local oStruPA1 := FWFormStruct( 2, 'PA1' )
Local oStruPA2 := FWFormStruct( 2, 'PA2' )
// Interface de visualização construída
Local oView := Nil

// Cria o objeto de View
oView  := FWFormView():New()
oModel := FWLoadModel( 'TWFATA01' )
// Define qual Modelo de dados será utilizado
oView:SetModel( oModel )

// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)
oView:AddField( 'VIEW_PA1', oStruPA1, 'PA1MASTER' )

//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
oView:AddGrid( 'VIEW_PA2', oStruPA2, 'PA2DETAIL' )

// Cria um "box" horizontal para receber cada elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 30 )
oView:CreateHorizontalBox( 'INFERIOR', 70 )

// Relaciona o identificador (ID) da View com o "box" para exibição
oView:SetOwnerView( 'VIEW_PA1', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_PA2', 'INFERIOR' )

// Retorna o objeto de View criado
Return oView

/*/{Protheus.doc} CarregGrd
    (Inicializador do Grid de Condições de Pagamentos)
    @type  Static Function
    @author Pirolo
    @since 27/07/2021
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function CarregGrd(oGridModel)
Local aLoad		:= {}

If     oGridModel:GetOperation() == 1 //Visualização

elseif oGridModel:GetOperation() == 3 //Insert

elseif oGridModel:GetOperation() == 4 //Update

elseif oGridModel:GetOperation() == 5 //Delete

elseif oGridModel:GetOperation() == 6 //Only Update

EndIf

Return aLoad

/*/{Protheus.doc} linePreGrid
    (long_description)
    @type  Static Function
    @author user
    @since 27/07/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function linePreGrid(oGridModel, nLine, cAction, cIDField, xValue, xCurrentValue)
Local lRet          := .T.
Local oModel        := oGridModel:GetModel("PA1MASTER")
Local nOperation    := oModel:GetOperation()

//Replica o campo de Client para o Grid
If nOperation == 3 .OR. nOperation == 4
    oModel:GetModel("PA2DETAIL"):GoLine(nLine)
    oModel:GetModel("PA2DETAIL"):LoadValue("PA2_CLIENT" , oModel:GetModel("PA1MASTER"):GetValue("PA1_CLIENT"))
    oModel:GetModel("PA2DETAIL"):LoadValue("PA2_LOJA"   , oModel:GetModel("PA1MASTER"):GetValue("PA1_LOJA"  ))
EndIf
Return lRet

/*/{Protheus.doc} linePOSGrid
    (long_description)
    @type  Static Function
    @author user
    @since 27/07/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
/*/
Static Function linePOSGrid(oModelGrid, nLine, cAction, cIDField, xValue, xCurrentValue)
Local lRet := .T.
Local oModel := oModelGrid:GetModel()
Local nOperation := oModel:GetOperation()

// Valida se pode ou não apagar uma linha do Grid
If cAction == 'DELETE' .AND. nOperation == MODEL_OPERATION_UPDATE
    lRet := .F.
    Help( ,, 'Help',, 'Não permitido apagar linhas na alteração.' +CRLF+;
             'Você esta na linha ' + Alltrim( Str( nLinha ) ), 1, 0 )
EndIf

Return lRet

/*/{Protheus.doc} PosVldModel
    (long_description)
    @type  Static Function
    @author user
    @since 28/07/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function PosVldModel( oGridModel )
Local lRet          := .T.
Local nOperation    := oGridModel:GetOperation()
Local nI           := 0
Local oModelPA2     := oGridModel:GetModel( 'PA2DETAIL' )

If nOperation == 3 .OR. nOperation == 4
    
    For nI := 1 to oModelPA2:Length()
        oGridModel:GetModel("PA2DETAIL"):GoLine(nI)
        oGridModel:GetModel("PA2DETAIL"):LoadValue("PA2_CLIENT" , oGridModel:GetModel("PA1MASTER"):GetValue("PA1_CLIENT"))
        oGridModel:GetModel("PA2DETAIL"):LoadValue("PA2_LOJA"   , oGridModel:GetModel("PA1MASTER"):GetValue("PA1_LOJA"))
    Next nI
EndIf

Return lRet


User Function TWFATA1A

Return
