#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

Static cTitulo := "Inclusão/Alteração de Área Responsável para Gestão de Contratos"

/*/{Protheus.doc} CSCNT001
Inclusão/Alteração de Área Responsável para Gestão de Contratos
@author Luciano A Oliveira
@since 28/08/2020
@version 1.0
	@return Nil, Função não tem retorno
	u_CSCNT001()
	@obs Não se pode executar função MVC dentro do fórmulas
/*/
User Function CSCNT001()
	Local aArea   := GetArea()
	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	
	oBrowse:SetAlias("CN9")
	oBrowse:SetDescription(cTitulo)
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}
	
	
	//ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CSFIS003' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	//ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
	//ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CSFIS003' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'u_AlterCN9' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	//ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.CSFIS003' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
	Local oModel 	:= Nil
    Local oStPai 	:= FWFormStruct(1,'CN9')
	//Private nOper   := oModel:getOperation()	
		
	
	oModel := MPFormModel():New('zMVCCN9')
	oModel:AddFields('CN9MASTER',/*cOwner*/,oStPai)
		
	oModel:SetDescription(OemToAnsi("ManutenÃ§Ã£o do Campo Ãrea ResponsÃ¡vel"))
	oModel:GetModel('CN9MASTER'):SetDescription(OemToAnsi('ManutenÃ§Ã£o de Contratos'))
                          
    oModel:SetActivate()
	
Return oModel

Static Function ViewDef()
	Local oModel	:= FWLoadModel("CSCNT001")
    Local oView
	Local oStPai	:= FWFormStruct(2,'CN9')
		
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	
	oView:AddField('VIEW_CN9',oStPai,'CN9MASTER')
		
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',100)
		
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_CN9','CABEC')
		
	
	oView:EnableTitleView('VIEW_CN9','Grupo')
	
Return oView

user function AlterCN9()

Local oModal
Local oContainer
Local oSay8
Local oSay9
Local oSay10
Local oFont := TFont():New('Courier new',,-12,.T.,.T.)
Local oFont2:= TFont():New('Courier new',,-10,.T.)
Local oFolder
Private cGet1 := cGetIni := Space(TamSX3('CN9_XAREA')[01])

    oModal := FWDialogModal():New()       
    oModal:SetEscClose(.T.)

    oModal:setTitle("Alterando Área Responsável")
    oModal:enableAllClient()
    oModal:createDialog()

    oModal:addNoYesButton()
    
    oContainer := TPanel():New( ,,, oModal:getPanelMain())
    oContainer:SetCss("TPanel{background-color : white;}")
    oContainer:Align := CONTROL_ALIGN_ALLCLIENT
	
    oFolder := TFolder():New(2,2,{'Dados do Contrato'},{},oContainer,,,,.T.,,673,50)
    
    @ 005, 005 SAY "Filial" SIZE 052,50 FONT oFont OF oFolder:aDialogs[1] PIXEL
	@ 015, 005 SAY CN9->CN9_FILIAL SIZE 052,050 FONT oFont2 OF oFolder:aDialogs[1] PIXEL
	@ 005, 060 SAY "Nr. Contrato" SIZE 100,100 FONT oFont OF oFolder:aDialogs[1] PIXEL
	@ 015, 060 SAY CN9->CN9_NUMERO SIZE 100,050 FONT oFont2 OF oFolder:aDialogs[1] PIXEL
	@ 005, 135 SAY "Descrição" SIZE 100,100 FONT oFont OF oFolder:aDialogs[1] PIXEL
	@ 015, 135 SAY CN9->CN9_DESCRI SIZE 400,100 FONT oFont2 OF oFolder:aDialogs[1] PIXEL
	//@ 005, 365 SAY "Data de Inicio" SIZE 100,100 FONT oFont OF oFolder:aDialogs[1] PIXEL
	//@ 015, 365 SAY STOD(DTOS(CN9->CN9_DTINIC))  SIZE 100,100 FONT oFont2 OF oFolder:aDialogs[1] PIXEL

    oSay8 := TSay():New(75,5,{|| "Área Resp. Atual"},oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,100,,,,,,.T.)
	oSay9 := TSay():New(85,5,{|| CN9->CN9_XAREA},oContainer,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,200,100,,,,,,.T.)

	oSay10 := TSay():New(75,100,{|| "Área Resp. Nova"},oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,100,,,,,,.T.)
    @ 85, 100 MSGET cGet1 PICTURE "@!" SIZE 060,010 OF oContainer PIXEL Valid EMPTY(cGet1) .OR. ExistCpo("SX5", + "Z5" + cGet1) F3 "Z5"

    oModal:Activate()

    if oModal:getButtonSelected() = 1 
	    if cGetIni <> cGet1
			bGravar()
		else
			ApMsgInfo("Não houve mudança, nada foi gravado!!!", "Informação")
		endif
	endif
return

static Function BGravar()
Local aArea := getArea()

if ApMsgYesNo("Tem certeza que deseja alterar???","Atenção")
	BEGIN TRANSACTION
		Reclock("CN9",.F.)
		CN9->CN9_XAREA := cGet1
        MSUNLOCK("CN9")
	END TRANSACTION

    ApMsgInfo("Alteração Finalizada com sucesso!!!", "Informação")

endif

RestArea(aArea)

Return 
