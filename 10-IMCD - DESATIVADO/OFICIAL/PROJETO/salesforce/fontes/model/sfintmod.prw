#include 'protheus.ch'
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} SFINTMOD
Rotina de log processamento Sales Force
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function SFINTMOD()
    local oBrowse as object

	oBrowse := FWMBrowse():New()
    oBrowse:setAlias('ZNO')
                     
    oBrowse:addLegend("ZNO_STATUS=='1'", "BLUE"  ,"Pendente SFTP")
    oBrowse:addLegend("ZNO_STATUS=='2'", "YELLOW","Aguardando retorno SF")
    oBrowse:addLegend("ZNO_STATUS=='3'", "BROWN" ,"Retorno parcial SF")
    oBrowse:addLegend("ZNO_STATUS=='4'", "GREEN" ,"Finalizado")
    oBrowse:addLegend("ZNO_STATUS=='5'", "RED"   ,"Finalizado com erros")
    oBrowse:addLegend("ZNO_STATUS=='6'", "BLACK" ,"Erro envio SFTP") 

	oBrowse:setDescription('Log de integração Sales Force')
    oBrowse:Activate()
    
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} menuDef
Definição de menu da rotina
@author  marcio.katsumata
@since   16/07/2019
@version 1.0
@return  array, menu das rotinas
/*/
//-------------------------------------------------------------------
static function menuDef()
    local aRotina as array

    aRotina := {}
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'u_vSfIntMod()' OPERATION 2 ACCESS 0


Return aRotina


//-------------------------------------------------------------------
/*/{Protheus.doc} modeldef
Modeldef da tabela ZNO e ZNF 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@return  object, model da tabela ZZ2
/*/
//-------------------------------------------------------------------
static function modeldef() as object

    Local oStruZNO  as object
    Local oStruZNP  as object
    Local oModel    as object

    oStruZNO  := FWFormStruct( 1, 'ZNO')
    oStruZNP := FWFormStruct( 1, 'ZNP',{|cCampo| !AllTRim(cCampo) $ "ZNP_FILIAL|ZNP_CODPRC" })

    
                                                             
    oStruZNP:AddField(  AllTrim('') , ; 			// [01] C Titulo do campo
                        AllTrim('') , ; 			// [02] C ToolTip do campo
                        'ZN0_LEGEN' , ;             // [03] C identificador (ID) do Field
                        'C' , ;                     // [04] C Tipo do campo
                        50 , ;                      // [05] N Tamanho do campo
                        0 , ;                       // [06] N Decimal do campo
                        NIL , ;                     // [07] B Code-block de validação do campo
                        NIL , ;                     // [08] B Code-block de validação When do campo
                        NIL , ;                     // [09] A Lista de valores permitido do campo
                        NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatório
                        { || Iif(ZNP->ZNP_STATUS=="1", "BR_AMARELO",;
                             iif(ZNP->ZNP_STATUS=="2", "BR_VERDE", ;
                             iif(ZNP->ZNP_STATUS=="3","BR_VERMELHO","BR_BRANCO"))) } , ; // [11] B Code-block de inicializacao do campo
                        NIL , ;                     // [12] L Indica se trata de um campo chave
                        NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
                        .T. )                       // [14] L Indica se o campo é virtual
    oModel := MPFormModel():New( 'LOGZNO')
    oModel:AddFields( 'ZNOMASTER', NIL, oStruZNO )
    oModel:AddGrid( 'ZNPDETAIL', 'ZNOMASTER', oStruZNP )

    oModel:SetRelation( 'ZNPDETAIL', { { 'ZNP_FILIAL' ,'xFilial( "ZNO" )'} , { 'ZNP_CODPRC', 'ZNO_CODPRC' }} , ZNP->( IndexKey( 1 ) ) )


    
    oModel:SetDescription( 'Log de integração SF' )
    oModel:GetModel( 'ZNOMASTER' ):SetDescription( 'Cabeçalho' )
    oModel:GetModel( 'ZNPDETAIL' ):SetDescription( 'Dados dos arquivos'  )
    oModel:GetModel( 'ZNPDETAIL' ):SetMaxLine(900000)

    oModel:SetPrimaryKey( {} )   
     
return oModel



//-------------------------------------------------------------------
/*/{Protheus.doc} viewdef
Viewdef da tabela ZNO e ZNP 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@return  object, view da tabela ZZ2
/*/
//-------------------------------------------------------------------

static function viewdef() as object
    local oStruZNO  as object
    local oStruZNP  as object
    local oModel    as object
    local oView     as object


    oStruZNO  := FWFormStruct( 2, 'ZNO')
    oStruZNP := FWFormStruct( 2, 'ZNP',{|cCampo| !AllTRim(cCampo) $ "ZNP_FILIAL|ZNP_CODPRC" })


    oStruZNP:AddField(  'ZN0_LEGEN'                   	, ;   	// [01]  C   Nome do Campo
                        "01"                         	, ;     // [02]  C   Ordem
                        AllTrim( ''    )                , ;     // [03]  C   Titulo do campo
                        AllTrim( '' )                   , ;     // [04]  C   Descricao do campo
                        { 'Legenda' } 		            , ;     // [05]  A   Array com Help
                        'C'                             , ;     // [06]  C   Tipo do campo
                        '@BMP'                          , ;     // [07]  C   Picture
                        NIL                             , ;     // [08]  B   Bloco de Picture Var
                        ''                              , ;     // [09]  C   Consulta F3
                        .T.                             , ;     // [10]  L   Indica se o campo é alteravel
                        NIL                             , ;     // [11]  C   Pasta do campo
                        NIL                             , ;     // [12]  C   Agrupamento do campo
                        NIL				               	, ;     // [13]  A   Lista de valores permitido do campo (Combo)
                        NIL                             , ;     // [14]  N   Tamanho maximo da maior opção do combo
                        NIL                             , ;     // [15]  C   Inicializador de Browse
                        .T.                             , ;     // [16]  L   Indica se o campo é virtual
                        NIL                             , ;     // [17]  C   Picture Variavel
                        NIL                             )       // [18]  L   Indica pulo de linha após o campo

    oModel   := FWLoadModel( 'SFINTMOD' )


	oView := FWFormView():New()
	oView:SetModel( oModel )
	
	
	oView:AddField('VIEW_ZNO' , oStruZNO, 'ZNOMASTER')
	oView:AddGrid( 'VIEW_ZNP' , oStruZNP, 'ZNPDETAIL')

	
    oView:SetViewProperty("VIEW_ZNP", "GRIDSEEK", {.T.}) 
    oView:SetViewProperty("VIEW_ZNP", "GRIDFILTER", {.T.}) 
    
	oView:CreateHorizontalBox( "BOX1",  40 )
	oView:CreateHorizontalBox( "BOX2",  60 )

    
	oView:SetOwnerView( 'VIEW_ZNO' , "BOX1" )
	oView:SetOwnerView( 'VIEW_ZNP' , "BOX2" )


return oView

user function vSfIntMod()

    local aButtons as array
    local nOpc as numeric
    local oModelInt as object
    
    //------------------------------------------------------
    //Prepara o model da tabela SA1
    //------------------------------------------------------
    oModelInt :=  FWLoadModel("SFINTMOD") 
    oModelInt:setOperation( MODEL_OPERATION_VIEW)
   

    nOpc := Aviso ("Filtro ",;
                   "Deseja filtrar os registros por status :"+CRLF+CRLF+; 
                    " 1. Pendente : Pendente integração SF "+CRLF+CRLF+;
                    " 2. Integrado: Integrado com sucesso  "+CRLF+CRLF+;
                    " 3. Erro: Integrado com erro  "+CRLF+CRLF+;
                    " 4. Nenhum: Sem filtro  "+CRLF+CRLF;
                    , {"Pendente", "Integrado", "Erro","Nenhum"}, 3)
    if nOpc ==3
        oModelInt:GetModel( 'ZNPDETAIL' ):SetLoadFilter( { { 'ZNP_STATUS', "'3'" } } )
    elseif nOpc==2
        oModelInt:GetModel( 'ZNPDETAIL' ):SetLoadFilter( { { 'ZNP_STATUS', "'2'" } } )
    elseif nOpc==1
        oModelInt:GetModel( 'ZNPDETAIL' ):SetLoadFilter( { { 'ZNP_STATUS', "'1'" } } )
    endif

    oModelInt:activate()
    //---------------------------------------------------------------
    //Realiza a montagem da tela de cadastro de cliente
    //---------------------------------------------------------------
    aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Confirmar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
    nOpc := MODEL_OPERATION_VIEW
    FWExecView('','SFINTMOD', nOpc, , { || .T. }, , ,aButtons,,,,oModelInt ) == 0


    //---------------------------------
    //Realiza a limpeza do model SA1.
    //---------------------------------
    oModelInt:deActivate() 
    oModelInt:destroy()    
    freeObj(oModelInt)

return
