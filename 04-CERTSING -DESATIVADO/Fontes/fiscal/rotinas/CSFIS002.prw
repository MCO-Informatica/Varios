//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Alteração de Estados(UF) para NFs de Saída"

/*/{Protheus.doc} CSFIS002
Função para alteração do Estado UF da NF envolvendo as tabelas SF2/SD2 e SF3/SFT
@author Luciano A Oliveira
@since 14/08/2020
@version 1.0
	@return Nil, Função não tem retorno
	u_CSFIS003()
	@obs Não se pode executar função MVC dentro do fórmulas
/*/

User Function CSFIS002()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	
	oBrowse:SetAlias("SF3")
	oBrowse:SetDescription(cTitulo)
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando opções
	//ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.CSFIS003' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	//ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
	//ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.CSFIS003' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'u_AlterSF3' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	//ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.CSFIS003' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
	Local oModel 	:= Nil
	Local oStPai 	:= FWFormStruct(1, 'SF3')
	Private nOper   := oModel:getOperation()	
		
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('zMVCSF3')
	oModel:AddFields('SBMMASTER',/*cOwner*/,oStPai)
		
	//Setando as descrições
	oModel:SetDescription("Alteração de Tipo")
	oModel:GetModel('SBMMASTER'):SetDescription('Dados Fiscais')
	
Return oModel

Static Function ViewDef()
	Local oModel	:= ModelDef()
    Local oView
	Local oStPai	:= FWFormStruct(2, 'SF3')
		
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_SBM',oStPai,'SBMMASTER')
		
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',100)
		
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_SBM','CABEC')
		
	//Habilitando título
	oView:EnableTitleView('VIEW_SBM','Grupo')
	
Return oView

user function AlterSF3()

Local oModal
Local oContainer
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSay10
Local oSay12
Local oSay13

Local oFont := TFont():New('Courier new',,-16,.T.,.T.)
Local oFont2:= TFont():New('Courier new',,-14,.T.)
Local oFolder
Local lHasButton := .F.
Local oESt
Private cGet1 := " " 
Private cGet2 := "         "
    
    oModal := FWDialogModal():New()       
    oModal:SetEscClose(.T.)
    oModal:setTitle("Alterando Dados Fiscais")
         
    //Seta a largura e altura da janela em pixel
    oModal:setSize(180, 320)
 
    oModal:createDialog()


    oModal:addExitPageButton({||},{||BGravar()})
	//{|| SELF:OOWNER:END()
	
    oContainer := TPanel():New( ,,, oModal:getPanelMain())
    oContainer:SetCss("TPanel{background-color : white;}")
    oContainer:Align := CONTROL_ALIGN_ALLCLIENT

	oFolder := TFolder():New(2,2,{'Dados Fiscais'},{},oContainer,,,,.T.,,315,50)
    
    @ 005, 005 SAY "NF" SIZE 052,50 FONT oFont OF oFolder:aDialogs[1] PIXEL
	@ 015, 005 SAY SF3->F3_NFISCAL SIZE 052,050 FONT oFont2 OF oFolder:aDialogs[1] PIXEL
	@ 005, 060 SAY "Série" SIZE 052,050 FONT oFont OF oFolder:aDialogs[1] PIXEL
	@ 015, 060 SAY SF3->F3_SERIE SIZE 052,050 FONT oFont2 OF oFolder:aDialogs[1] PIXEL
	@ 005, 105 SAY "Cliente/Lj" SIZE 100,050 FONT oFont OF oFolder:aDialogs[1] PIXEL
	@ 015, 105 SAY SF3->F3_CLIEFOR + "/" + SF3->F3_LOJA SIZE 052,050 FONT oFont2 OF oFolder:aDialogs[1] PIXEL
	@ 005, 185 SAY "Descrição" SIZE 052,050 FONT oFont OF oFolder:aDialogs[1] PIXEL
	@ 015, 185 SAY Posicione("SA1",1,xFilial("SA1") + SF3->F3_CLIEFOR + SF3->F3_LOJA, "SA1->A1_NREDUZ")  SIZE 200,050 FONT oFont2 OF oFolder:aDialogs[1] PIXEL


	/*oSay1:=Say():New(10,5,{|| "NF "},oFolder,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,50,50,,,,,.T.)
	oSay2:=TSay():New(18,5,{|| "999999999 "},oFolder,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,50,50,,,,,,.T.)
    oSay3:=TSay():New(10,60,{|| "Serie "},oFolder,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,30,50,,,,,,.T.)
	oSay4:=TSay():New(18,60,{|| "123 "},oFolder,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,50,50,,,,,,.T.)
	oSay5:=TSay():New(10,95,{|| "Cliente/Loja "},oFolder,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,50,,,,,,.T.)
	oSay6:=TSay():New(18,95,{|| "123456/01 "},oFolder,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,50,50,,,,,,.T.)
	oSay7:=TSay():New(18,155,{|| "Nome Reduzido do Cliente "},oFolder,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,50,,,,,,.T.)*/

    oSay8:=TSay():New(75,75,{|| "Tipo Atual"},oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,50,,,,,,.T.)
	oSay9:=TSay():New(85,75,{|| SF3->F3_TIPO},oContainer,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,200,50,,,,,,.T.)

	oSay10:=TSay():New(75,165,{|| "Tipo Novo"},oContainer,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,50,,,,,,.T.)
    
	@ 85, 165 MSGET cGet1 PICTURE "@!" SIZE 060,010 OF oContainer PIXEL Valid EMPTY(cGet1) .OR. Pertence('LSBDCPI') 
	/*cGet1 :=TGet():New(85,175,{|u|If( PCount() == 0, cGet1, cGet1 := u )},oContainer, ;
     60, 10, "@D",, 0, 16777215,oFont2,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet1",,,,lHasButton)*/


    oSay11:=TSay():New(110,75,{|| "Código ISS Atual"},oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,50,,,,,,.T.)
	oSay12:=TSay():New(120,75,{|| SF3->F3_CODISS},oContainer,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,200,50,,,,,,.T.)

	oSay13:=TSay():New(110,165,{|| "Código ISS Novo"},oContainer,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,50,,,,,,.T.)
    
	@ 120, 165 MSGET cGet2 PICTURE "@!" SIZE 060,010 OF oContainer PIXEL Valid EMPTY(cGet2) .OR. ExistCpo("SX5", + "60" + cGet2) F3 "60"

    oModal:Activate()
return

static Function BGravar()
Local aArea := getArea()

if ApMsgYesNo("Tem certeza que deseja alterar???","Atenção")
	BEGIN TRANSACTION
		Reclock("SF3",.F.)
		SF3->F3_TIPO := cGet1
        SF3->F3_TIPO := cGet2
		MSUNLOCK("SF3")

	END TRANSACTION

    ApMsgInfo("Alteração Finalizada com sucesso!!!", "Informação")

endif

RestArea(aArea)

Return 
