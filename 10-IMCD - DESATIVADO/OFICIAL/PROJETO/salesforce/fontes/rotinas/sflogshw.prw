#include 'protheus.ch'
#include "fwmvcdef.ch"


//-------------------------------------------------------------------
/*/{Protheus.doc} SFLOGSHW
Log do registro selecionado
@author  marcio.katsumata
@since   06/08/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function SFLOGSHW (cTabela)
    private cEntity as character
    private nRecEnt as numeric

    default cTabela := alias()
    cEntity := cTabela
    nRecEnt := (cTabela)->(recno())
    dbSelectArea("ZNO")
    if nRecEnt > 0
        oModelZNP := FwLoadModel("SFLOGSHW")
        oModelZNP:setOperation( MODEL_OPERATION_VIEW)
        oModelZNP:activate()

        aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
        nOpc := MODEL_OPERATION_VIEW
        FWExecView('','SFLOGSHW', nOpc, , { || .T. }, , ,aButtons,,,,oModelZNP ) 
    endif

return



//-------------------------------------------------------------------
/*/{Protheus.doc} modeldef
Modeldef da tabela ZNO e ZNP 
@author  marcio.katsumata
@since   06/08/2019
@version 1.0
@return  object, model da tabela ZNO e ZNP 
/*/
//-------------------------------------------------------------------
static function modeldef() as object

    Local oStruZNO  as object
    Local oStruZNP  as object
    Local oModel    as object

    oStruZNO := FWFormStruct( 1, 'ZNO')
    oStruZNP := FWFormStruct( 1, 'ZNP')
    
                                                             
    oStruZNP:AddField(  AllTrim('') , ; 			// [01] C Titulo do campo
                        AllTrim('') , ; 			// [02] C ToolTip do campo
                        'ZNP_LEGEN' , ;             // [03] C identificador (ID) do Field
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

    oStruZNP:AddField(  AllTrim('') , ; 			// [01] C Titulo do campo
                AllTrim('') , ; 			// [02] C ToolTip do campo
                'ZNO_FILE' , ;             // [03] C identificador (ID) do Field
                'C' , ;                     // [04] C Tipo do campo
                50 , ;                      // [05] N Tamanho do campo
                0 , ;                       // [06] N Decimal do campo
                NIL , ;                     // [07] B Code-block de validação do campo
                NIL , ;                     // [08] B Code-block de validação When do campo
                NIL , ;                     // [09] A Lista de valores permitido do campo
                NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatório
                NIL , ; // [11] B Code-block de inicializacao do campo
                NIL , ;                     // [12] L Indica se trata de um campo chave
                NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
                .T. )                       // [14] L Indica se o campo é virtual
    oModel := MPFormModel():New( 'LOGSHW')

    oModel:AddFields( 'ZNOMASTER', NIL, oStruZNO )
    oModel:AddGrid( 'ZNPDETAIL', 'ZNOMASTER', oStruZNP, , , , ,{|oModel|LoadZNP(oModel)} )


	oModel:SetRelation( 'ZNPDETAIL', { { 'ZNP_FILIAL', 'xFilial( "ZNO" )' }} , ZNP->( IndexKey( 1 ) ) )

	
    
    oModel:SetDescription( 'Log de integração SF' )
    oModel:GetModel( 'ZNOMASTER' ):SetDescription( 'Dados do Cabecalho' )
    oModel:GetModel( 'ZNPDETAIL' ):SetDescription( 'Dados dos arquivos'  )
    oModel:GetModel( 'ZNPDETAIL' ):SetMaxLine(900000)

    oModel:SetPrimaryKey( {} )   
return oModel



//-------------------------------------------------------------------
/*/{Protheus.doc} viewdef
Viewdef da tabela ZNO e ZNP 
@author  marcio.katsumata
@since   06/08/2019
@version 1.0
@return  object, view da tabela ZNO e ZNP 
/*/
//-------------------------------------------------------------------

static function viewdef() as object
    local oStruZNP  as object
    local oModel    as object
    local oView     as object

    oStruZNP := FWFormStruct( 2, 'ZNP',{|cCampo| !AllTRim(cCampo) $ "ZNP_FILIAL|ZNP_CODPRC" })


    oStruZNP:AddField(  'ZNP_LEGEN'                   	, ;   	// [01]  C   Nome do Campo
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
    oStruZNP:AddField(  'ZNO_FILE'                   	, ;   	// [01]  C   Nome do Campo
                    "03"                         	, ;     // [02]  C   Ordem
                    AllTrim( ''    )                , ;     // [03]  C   Titulo do campo
                    AllTrim( '' )                   , ;     // [04]  C   Descricao do campo
                    { 'Arquivo' } 		            , ;     // [05]  A   Array com Help
                    'C'                             , ;     // [06]  C   Tipo do campo
                    ''                              , ;     // [07]  C   Picture
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

    oModel   := FWLoadModel( 'SFLOGSHW' )


	oView := FWFormView():New()
	oView:SetModel( oModel )
	
	
	oView:AddGrid( 'VIEW_ZNP' , oStruZNP, 'ZNPDETAIL')

	
	
	oView:CreateHorizontalBox( "BOX1",  100 )


    
	oView:SetOwnerView( 'VIEW_ZNP' , "BOX1" )


return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} LoadZNP
Carrega os registros da tabela ZNP de acordo com o RECNO posicionado
@author  marcio.katsumata
@since   06/08/2019
@version 1.0
@param   oObj, object, model
@param   array, array com os registros
/*/
//-------------------------------------------------------------------
static Function LoadZNP (oObj )
    Local aRet as array
    Local cAliasTmp as character
    Local cQuery as character
    
    cAliasTmp := getNextAlias()

    beginSql alias cAliasTmp
        SELECT ZNP.*, ZNO.ZNO_FILIAL, ZNO.ZNO_FILE, ZNP.R_E_C_N_O_ AS RECNO  FROM %table:ZNO% ZNO
        INNER JOIN %table:ZNP% ZNP ON (ZNP.ZNP_FILIAL = ZNO.ZNO_FILIAL AND
                                       ZNP.ZNP_CODPRC = ZNO.ZNO_CODPRC AND
                                       ZNP.%notDel%)
        WHERE ZNO.ZNO_ENTITY = %exp:cEntity% AND
              ZNP.ZNP_CHVPRT = %exp:alltrim(cValToChar(nRecEnt))% AND
              ZNO.%notDel%

    endSql


    // Como tem o campo R_E_C_N_O_, nao é preciso informar qual o campo contem o Recno() real
    aRet := FWLoadByAlias( oObj, cAliasTmp, 'ZNP' ) 

    (cAliasTmp)->( dbCloseArea() )


Return aRet 


