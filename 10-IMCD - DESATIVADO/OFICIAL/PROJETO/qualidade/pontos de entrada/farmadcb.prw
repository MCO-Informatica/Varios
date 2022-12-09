#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
//
USER Function FARMADCB()
Local oBrowse
Private cTitulo := 'CADASTRO DCB'

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("ZDC")
oBrowse:SetDescription( cTitulo )
oBrowse:Activate()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Junior Carvalho

@since 06/01/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,"ZDC")

oModel := MPFormModel():New('CTBA018',/*PreValidacao*/,{ |oModel| U_ZDCTDOK(oModel)}/*PosValidacao*/,)

oModel:SetDescription( cTitulo )

oModel:addFields('ModelZDC',,oStr1)
oModel:SetPrimaryKey({ 'ZDC_FILIAL', 'ZDC_CODDCB' })

oModel:getModel('ModelZDC'):SetOnlyQuery(.F.)

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Junior Carvalho

@since 17/03/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
Local oStr1:= FWFormStruct(2,'ZDC')

oView := FWFormView():New()
oView:SetModel(oModel)

oView:AddField('Master_ZDC' , oStr1,'ModelZDC' )

oView:EnableTitleView('Master_ZDC' , cTitulo )

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} MENUDEF()
Função para criar do menu

@author Junior Carvalho
@since 29/08/2013
@version 1.0
@return aRotina
/*/
//-------------------------------------------------------------------

Static Function MenuDef()
Local aRotina := {} //Array utilizado para controlar opcao selecionada

ADD OPTION aRotina TITLE "Visualizar" 	ACTION "VIEWDEF.FARMAZDC"		OPERATION 2 	ACCESS 0  //
ADD OPTION aRotina TITLE "Incluir" 	ACTION "VIEWDEF.FARMAZDC"		OPERATION 3  	ACCESS 0      //
ADD OPTION aRotina TITLE "Alterar" 	ACTION "VIEWDEF.FARMAZDC"		OPERATION 4 	ACCESS 0      //
//ADD OPTION aRotina TITLE "Excluir" 	ACTION "VIEWDEF.FARMAZDC"		OPERATION 5  	ACCESS 3 	   //
//ADD OPTION aRotina TITLE "Imprimir" 	ACTION "VIEWDEF.FARMAZDC" 	OPERATION 8 	ACCESS 0 	   //

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} MENUDEF()
Função para validar formulario

@author Junior Carvalho

@since 17/03/2015
@version 1.0
@return lRet
/*/
//-------------------------------------------------------------------

uSER Function ZDCTDOK(oModel)
Local lRet := .F.

If oModel:GetOperation() == MODEL_OPERATION_INSERT .OR. ;//Incluir
	oModel:GetOperation() == MODEL_OPERATION_UPDATE //Alterar
	cCodDCB := oModel:GetValue( 'ModelZDC', "ZDC_CODDCB" )
	cDesc := ALLTRIM(oModel:GetValue( 'ModelZDC', "ZDC_DESC" ))
	lRet := !Empty( cCodDCB ) .And. !Empty( cDesc )
	
	If !lRet
		Help( ,, 'Help',, "Codigo/Nome DCB não preenchido.", 1, 0 , NIL, NIL, NIL, NIL, NIL, {"Cancelar a operação"})
	Endif
	
	//nao permitir mudar o codigo do SCP na alteracao
	If	lRet .And. oModel:GetOperation() == MODEL_OPERATION_UPDATE //Alterar
		
		lRet := ( cCodDCB == ZDC->ZDC_CODDCB )
		
		If !lRet
			Help(NIL, NIL, "Help", NIL,"Codigo DCB não pode ser alterado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Cancelar a operação"})
		Endif
		
	Endif
	
	//nao permitir incluir novo registro com DCB ja existente
	If	lRet .And. oModel:GetOperation() == MODEL_OPERATION_INSERT
		
		lRet := ZDC->( ! dbSeek( xFilial("ZDC")+cCodDCB) )
		
		If !lRet
			Help( ,, 'Help',, "Codigo DCB ja existe na Tabela.", 1, 0 , NIL, NIL, NIL, NIL, NIL, {"Cancelar a operação"})
		Endif
		
	Endif
Else
	
	lRet := .T.
	
Endif

Return(lRet)