#include 'protheus.ch'
#include "fwmvcdef.ch"

static oModelIn
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


	aAdd( aRotina, { 'Cadastrar' , 'U_CADSFINC'      , 0, 4, 0, NIL } )
    aAdd( aRotina, { 'Visualizar', 'VIEWDEF.SFINRMOD', 0, 2, 0, NIL } )

Return aRotina


//-------------------------------------------------------------------
/*/{Protheus.doc} modeldef
Modeldef da tabela ZNR e ZNF 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@return  object, model da tabela ZZ2
/*/
//-------------------------------------------------------------------
static function modeldef() as object

    Local oStruZNR  as object
    Local oStruZNS  as object
    Local oModel    as object

    oStruZNR  := FWFormStruct( 1, 'ZNR')
    oStruZNS := FWFormStruct( 1, 'ZNS',{|cCampo| !AllTRim(cCampo) $ "ZNS_FILIAL|ZNS_CODPRC" })

    
                                                             
    oStruZNS:AddField(  AllTrim('') , ; 			// [01] C Titulo do campo
                        AllTrim('') , ; 			// [02] C ToolTip do campo
                        'ZNS_LEGEN' , ;             // [03] C identificador (ID) do Field
                        'C' , ;                     // [04] C Tipo do campo
                        50 , ;                      // [05] N Tamanho do campo
                        0 , ;                       // [06] N Decimal do campo
                        NIL , ;                     // [07] B Code-block de validação do campo
                        NIL , ;                     // [08] B Code-block de validação When do campo
                        NIL , ;                     // [09] A Lista de valores permitido do campo
                        NIL , ;                     // [10] L Indica se o campo tem preenchimento obrigatório
                        { || Iif(ZNS->ZNS_STATUS=="1", "BR_AMARELO", "BR_VERDE") } , ; // [11] B Code-block de inicializacao do campo
                        NIL , ;                     // [12] L Indica se trata de um campo chave
                        NIL , ;                     // [13] L Indica se o campo pode receber valor em uma operação de update.
                        .T. )                       // [14] L Indica se o campo é virtual
    oModel := MPFormModel():New( 'SFINRMOD')
    oModel:AddFields( 'ZNRMASTER', NIL, oStruZNR )
    oModel:AddGrid( 'ZNSDETAIL', 'ZNRMASTER', oStruZNS )

    oModel:SetRelation( 'ZNSDETAIL', { { 'ZNS_FILIAL' ,'xFilial( "ZNR" )'} , { 'ZNS_CODPRC', 'ZNR_CODPRC' }} , ZNS->( IndexKey( 1 ) ) )


    
    oModel:SetDescription( 'Integração SF' )
    oModel:GetModel( 'ZNRMASTER' ):SetDescription( 'Cabeçalho' )
    oModel:GetModel( 'ZNSDETAIL' ):SetDescription( 'Dados dos arquivos'  )
    oModel:GetModel( 'ZNSDETAIL' ):SetMaxLine(10000)

    oModel:SetPrimaryKey( {} )   
     
return oModel



//-------------------------------------------------------------------
/*/{Protheus.doc} viewdef
Viewdef da tabela ZNR e ZNS 
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@return  object, view da tabela ZZ2
/*/
//-------------------------------------------------------------------

static function viewdef() as object
    local oStruZNR  as object
    local oStruZNS  as object
    local oModel    as object
    local oView     as object


    oStruZNR  := FWFormStruct( 2, 'ZNR')
    oStruZNS := FWFormStruct( 2, 'ZNS',{|cCampo| !AllTRim(cCampo) $ "ZNS_FILIAL|ZNS_CODPRC" })


    oStruZNS:AddField(  'ZNS_LEGEN'                   	, ;   	// [01]  C   Nome do Campo
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

    oModel   := FWLoadModel( 'SFINRMOD' )


	oView := FWFormView():New()
	oView:SetModel( oModel )
	
	
	oView:AddField('VIEW_ZNR' , oStruZNR, 'ZNRMASTER')
	oView:AddGrid( 'VIEW_ZNS' , oStruZNS, 'ZNSDETAIL')

	
	oView:SetViewProperty("VIEW_ZNS", "GRIDDOUBLECLICK", {{|oFormulario,cFieldName,nLineGrid,nLineModel| CallExecAut(oFormulario,cFieldName,nLineGrid,nLineModel)}}) 
	oView:CreateHorizontalBox( "BOX1",  40 )
	oView:CreateHorizontalBox( "BOX2",  60 )

    oView:AddUserButton( 'Cadastrar Linha', '' , {|oView| CallExecAut() } )  

	oView:SetOwnerView( 'VIEW_ZNR' , "BOX1" )
	oView:SetOwnerView( 'VIEW_ZNS' , "BOX2" )


return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} CallExecAut
Prepara a execução da rotina de cadastro e a executa.
@author  marcio.katsumata
@since   25/07/2019
@version 1.0
@param   oFormulario, object, objeto view da GRID
@param   cFieldName, character, campo posicionado
@param   nLineGrid , numeric, linha posicionada
@param   nLineModel, numeric, linha posicionada no model
@return  boolean, permite edição?
/*/
//-------------------------------------------------------------------
static function CallExecAut (oFormulario,cFieldName,nLineGrid,nLineModel)
    local cEntity as character
    local cJson   as character
    local oSfInLy as character
    local cExecAut as character
    local lRet     as logical
    local cChvAlias as character
    local nIndAlias as numeric
    local cAliasEnt as character
    local lProssegue as logical
    local oJson    as object
    local nTamZNQ  as numeric
    local nLinePos as numeric
    local nIndAlias as numeric
    local nInd  as numeric

    default oFormulario:= nil
    default cFieldName := ""
    default nLineGrid  := 0
    default nLineModel := 0

    lRet := .T.
    lProssegue := .T.
    //----------------------------------------------------
    //Realiza a exeução da rotina caso o usuário
    //não tenha clicado duas vezes no campo ZNS_JSON
    //pois se este campo deve estar livre para que
    //o usuário possa visualizar o conteúdo do campo MEMO
    //-----------------------------------------------------
    if alltrim(cFieldName) <> 'ZNS_JSON'
        
        lRet := .F.
        cEntity := ZNR->ZNR_ENTITY

        if empty(oModelIn) .or. !(oModelIn:isActive())
            oModelIn := FwModelActive()
        endif

        //Verifica a linha do registro posicionado em tela
        nLinePos := oModelIn:getModel("ZNSDETAIL"):GetLine()
        
        //-------------------------------------------------------------
        //Verificar o status de processamento do registro ZNS
        //Apenas registros pendentes de cadastro podem prosseguir
        //com o processamento.
        //-------------------------------------------------------------
        if oModelIn:getValue("ZNSDETAIL","ZNS_STATUS",nLinePos ) == '1'
            dbSelectArea("ZNQ")
            ZNQ->(dbSetOrder(1))

            if ZNQ->(dbSeek(xFilial("ZNQ")+cEntity+'S'))

                oSfInLy := FwLoadModel("SFINLYMOD")
                oSfInLy:setOperation(MODEL_OPERATION_VIEW)
                oSfInLy:activate()


        
                //--------------------------------------------------------
                //Realiza o parse da STRING JSON para Json Object
                //--------------------------------------------------------
                cJson := oModelIn:getValue("ZNSDETAIL","ZNS_JSON",nLinePos )
	            oParser   := JSON():New( cJson)
	            oParser := oParser:Parse()

                //-------------------------------------------------------
                //Se o JSON for válido realiza a execução da rotina de 
                //cadastro da entidade
                //-------------------------------------------------------
                if oParser:IsJSON()
                    oJson   := oParser:object()

                    //------------------------------------------------------------
                    //Validação chave de procura na tabela , se existir registro
                    //não prossegue
                    //------------------------------------------------------------
                    if !empty(cChvAlias := oModelIn:getValue("ZNSDETAIL","ZNS_CHAVE",nLinePos ))
                        cAliasEnt := ZNR->ZNR_ALIAS
                        nTamZNQ := oModelLy:getModel("ZNQDETAIL"):length() 
                        nLinePos := oModelLy:getModel("ZNQDETAIL"):getLine()
                        
                        for nInd := 1 to  nTamZNQ
                            oModelLy:getModel("ZNQDETAIL"):goLine(nInd)
                            if alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_KEY")) == 'S'
                                nIndAlias := oModelLy:getValue("ZNQDETAIL", "ZNQ_INDICE")
                            endif
                        next nInd 

                        if nIndAlias > 0
                            dbSelectArea(cAliasEnt)
                            (cAliasEnt)->(dbSetOrder(nIndAlias))
                            if (cAliasEnt)->(dbSeek(xFilial(cAliasEnt)+cChvAlias))
                                lProssegue := .F.
                            endif
                        endif

                    endif

                    if lProssegue
                        cExecAut := alltrim(ZNQ->ZNQ_EXEAUT)
                        &cExecAut.(oJson,oSfInLy,oModelIn)
                    endif
                        
                    freeObj(oJson)
                endif
                //--------------------------------------
                //Realiza a limpeza dos objetos e models
                //--------------------------------------
                oSfInLy:Deactivate()
                oSfInLy:destroy()
                freeObj(oSfInLy)
                freeObj(oParser)
               
            endif
            //---------------------------
            //Realiza um refresh na tela
            //---------------------------
            oFormulario:refresh()
        else
            aviso ("JÁ CADASTRADO", "Este registro já está cadastrado", {"Cancelar"},1)        
        endif
    endif
     
return lRet 

//-------------------------------------------------------------------
/*/{Protheus.doc} CADSFINC
Realiza chamada da tela de alteração customizada da tabela ZNR/ZNS
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
user function CADSFINC()
    local aButtons as array

    aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
    FWExecView('','SFINRMOD', MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons,{||U_CHKSFIN()} ) 

return

//-------------------------------------------------------------------
/*/{Protheus.doc} CHKSFIN
Validação do botão cancelar da tela de alteração da tabela ZNR/ZNS
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@return  boolean, retorno
/*/
//-------------------------------------------------------------------
user function CHKSFIN ()
    local lRet as logical

    lRet := .T.

    if!empty(oModelIn)
        if !(lRet := !(oModelIn:getModel("ZNRMASTER"):isModified() .or.;
                       oModelIn:getModel("ZNSDETAIL"):isModified() ))
            aviso("Cancelamento", "Não é possível cancelar, pois houve modificações.", {"OK"}, 1)
        endif
    endif

return lRet