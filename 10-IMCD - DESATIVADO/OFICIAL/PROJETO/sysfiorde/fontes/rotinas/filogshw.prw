#include 'protheus.ch'
#include "fwmvcdef.ch"


//-------------------------------------------------------------------
/*/{Protheus.doc} FILOGSHW
Log do registro selecionado
@author  marcio.katsumata
@since   18/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function FILOGSHW ()
    private cEntity as character
    private cFilProc as character
    private cNumProc as character

    //---------------------------------------
    //Chamada pela rotina de manutenção de PO
    //---------------------------------------
    if IsInCallStack("EICPO400")
        cFilProc := SW2->W2_FILIAL
        cNumProc := SW2->W2_PO_NUM
        cEntity  := "EPO/EDI"
    else
    //-------------------------------------------
    //Chamada pela rotina de manutenção Embarque
    //-------------------------------------------
        cFilProc := SW6->W6_FILIAL
        cNumProc := SW6->W6_HAWB
        cEntity  := "RLI/RBO/RFT/RLT/RNM/RDI/RCB"
    endif

    dbSelectArea("ZNT")
    //--------------------------------
    //Cria uma instância do model ZNT
    //--------------------------------
    oModelZNT := FwLoadModel("FILOGSHW")
    oModelZNT:setOperation( MODEL_OPERATION_VIEW)
    oModelZNT:activate()

    //--------------------------
    //Realiza a abertura da TELA
    //--------------------------
    aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
    nOpc := MODEL_OPERATION_VIEW
    FWExecView('','FILOGSHW', nOpc, , { || .T. }, , ,aButtons,,,,oModelZNT ) 
    

return



//-------------------------------------------------------------------
/*/{Protheus.doc} modeldef
Modeldef da tabela ZNT
@author  marcio.katsumata
@since   18/09/2019
@version 1.0
@return  object, model da tabela ZNT
/*/
//-------------------------------------------------------------------
static function modeldef() as object

    Local oStruZNT   as object
    Local oStrGrdZNT as object
    Local oModel     as object

    oStruZNT   := FWFormStruct( 1, 'ZNT')
    oStrGrdZNT := FWFormStruct( 1, 'ZNT')
    
                                                             
    oStrGrdZNT:AddField(  AllTrim('') , ; 			// [01] C Titulo do campo
                        AllTrim('') , ; 			// [02] C ToolTip do campo
                        'ZNT_LEGEN' , ;             // [03] C identificador (ID) do Field
                        'C' , ;                     // [04] C Tipo do campo
                        50 , ;                      // [05] N Tamanho do campo
                        0 , ;                       // [06] N Decimal do campo
                        NIL , ;                     // [07] B Code-block de validação do campo
                        NIL , ;                     // [08] B Code-block de validação When do campo
                        NIL , ;                     // [09] A Lista de valores permitido do campo
                        NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatório
                        { || Iif(ZNT->ZNT_STATUS=="1", "BR_AMARELO",;
                             iif(ZNT->ZNT_STATUS=="2", "BR_VERDE", ;
                             iif(ZNT->ZNT_STATUS=="3","BR_VERMELHO","BR_BRANCO"))) } , ; // [11] B Code-block de inicializacao do campo
                        NIL , ;                     // [12] L Indica se trata de um campo chave
                        NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
                        .T. )                       // [14] L Indica se o campo é virtual


    oModel := MPFormModel():New( 'FILOG')

    oModel:AddFields( 'ZNTMASTER', NIL, oStruZNT )
    oModel:AddGrid( 'ZNTDETAIL', 'ZNTMASTER', oStrGrdZNT, , , , ,{|oModel|LoadZNT(oModel)} )


	oModel:SetRelation( 'ZNTDETAIL', { { 'ZNT_FILIAL', 'xFilial( "ZNT" )' }} , ZNT->( IndexKey( 1 ) ) )

	
    
    oModel:SetDescription( 'Log de integração FIORDE' )
    oModel:GetModel( 'ZNTMASTER' ):SetDescription( 'Dados do Cabecalho' )
    oModel:GetModel( 'ZNTDETAIL' ):SetDescription( 'Dados dos arquivos'  )
    oModel:GetModel( 'ZNTDETAIL' ):SetMaxLine(900000)

    oModel:SetPrimaryKey( {} )   
return oModel



//-------------------------------------------------------------------
/*/{Protheus.doc} viewdef
Viewdef da tabela ZNT 
@author  marcio.katsumata
@since   18/09/2019
@version 1.0
@return  object, view da tabela ZNT
/*/
//-------------------------------------------------------------------

static function viewdef() as object
    local oStrGrdZNT  as object
    local oModel    as object
    local oView     as object

    oStrGrdZNT := FWFormStruct( 2, 'ZNT',{|cCampo| !AllTRim(cCampo) $ "ZNT_FILIAL|ZNT_CODPRC" })


    oStrGrdZNT:AddField(  'ZNT_LEGEN'                   	, ;   	// [01]  C   Nome do Campo
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
    

    oModel   := FWLoadModel( 'FILOGSHW' )

	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddGrid( 'VIEW_ZNT' , oStrGrdZNT, 'ZNTDETAIL')
	oView:CreateHorizontalBox( "BOX1",  100 )
    oView:SetOwnerView( 'VIEW_ZNT' , "BOX1" )
    
    //-------------------------------------------------
    //Disponibilização de barra de procura.
    //-------------------------------------------------
    oView:SetViewProperty("VIEW_ZNT", "GRIDSEEK", {.T.})
    oView:SetViewProperty("VIEW_ZNT", "GRIDFILTER", {.T.})

return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} LoadZNT
Carrega os registros da tabela ZNP de acordo com o RECNO posicionado
@author  marcio.katsumata
@since   18/09/2019
@version 1.0
@param   oObj, object, model
@param   array, array com os registros
/*/
//-------------------------------------------------------------------
static Function LoadZNT (oObj )
    Local aRet as array
    Local cAliasTmp as character
    Local cQuery as character

    cEntIn  := "%" + FormatIn(cEntity,"/") + "%"

    cAliasTmp := getNextAlias()

    beginSql alias cAliasTmp
        SELECT ZNT.*, ZNT.R_E_C_N_O_ AS RECNO FROM %table:ZNT% ZNT
        WHERE ZNT.ZNT_ETAPA IN %exp:cEntIn% AND
              ZNT.ZNT_FILIAL = %exp:cFilProc% AND
              ZNT.ZNT_NUMPO  = %exp:cNumProc% AND
              ZNT.%notDel%

    endSql


    // Como tem o campo R_E_C_N_O_, nao é preciso informar qual o campo contem o Recno() real
    aRet := FWLoadByAlias( oObj, cAliasTmp, 'ZNT' ) 

    (cAliasTmp)->( dbCloseArea() )


Return aRet 






