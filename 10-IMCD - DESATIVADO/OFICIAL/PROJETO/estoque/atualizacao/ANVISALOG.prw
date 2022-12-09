#include 'protheus.ch'
#include "fwmvcdef.ch"

/*/{Protheus.doc} ANVISALOG
Mostra log de alterações dos campos Cota Anvida e
Qtd. Liberada da tabela SB1
@type function
@version 1.0
@author marcio.katsumata
@since 17/03/2020
@return return_type, return_description
/*/
user function ANVISALOG()

    local aButtons as array
    local oModelZAO as object
    local nOpcLog   as numeric

    dbSelectArea("ZAO")



    oModelZAO := FwLoadModel("ANVISALOG")
    oModelZAO:setOperation( MODEL_OPERATION_VIEW)
    oModelZAO:activate()

    aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
    nOpcLog := MODEL_OPERATION_VIEW
    FWExecView('','ANVISALOG', nOpcLog, , { || .T. }, , ,aButtons,,,,oModelZAO ) 

    aSize(aButtons,0)



return
//-------------------------------------------------------------------
/*/{Protheus.doc} modeldef
Modeldef da tabela ZAO
@author  marcio.katsumata
@since   06/08/2019
@version 1.0
@return  object, model da tabela ZAO
/*/
//-------------------------------------------------------------------
static function modeldef() as object

    Local oStruZAO  as object
    Local oStruZAOFil  as object
    Local oModel    as object

    oStruZAO := FWFormStruct( 1, 'ZAO', {|cCampo| AllTRim(cCampo) $ "|ZAO_COD|" })
    oStruZAOFil := FWFormStruct( 1, 'ZAO', {|cCampo| !AllTRim(cCampo) $ "|ZAO_COD|" })
    
                                                             
    oModel := MPFormModel():New( 'ANVISALG')

    oModel:AddFields( 'ZAOMASTER', NIL, oStruZAO )
    oModel:AddGrid( 'ZAODETAIL', 'ZAOMASTER', oStruZAOFil, , , , ,{|oModel|LoadZAO(oModel)} )


	oModel:SetRelation( 'ZAODETAIL', { { 'ZAO_FILIAL', 'xFilial( "ZAO" )' }} , ZAO->( IndexKey( 1 ) ) )

	
    
    oModel:SetDescription( 'Log de alteração campos anvisa' )
    oModel:GetModel( 'ZAOMASTER' ):SetDescription( 'Dados do Cabecalho' )
    oModel:GetModel( 'ZAODETAIL' ):SetDescription( 'Dados dos arquivos'  )
    oModel:GetModel( 'ZAODETAIL' ):SetMaxLine(900000)

    oModel:SetPrimaryKey( {} )   
return oModel



//-------------------------------------------------------------------
/*/{Protheus.doc} viewdef
Viewdef da tabela ZAO e ZAO 
@author  marcio.katsumata
@since   06/08/2019
@version 1.0
@return  object, view da tabela ZAO e ZAO 
/*/
//-------------------------------------------------------------------

static function viewdef() as object
    local oStruZAOFil  as object
    local oModel    as object
    local oView     as object

    oStruZAOFil := FWFormStruct( 2, 'ZAO', {|cCampo| !AllTRim(cCampo) $ "|ZAO_COD|" })

    oModel   := FWLoadModel( 'ANVISALOG' )


	oView := FWFormView():New()
	oView:SetModel( oModel )
	
	
	oView:AddGrid( 'VIEW_ZAO' , oStruZAOFil, 'ZAODETAIL')

	
	
	oView:CreateHorizontalBox( "BOX1",  100 )


    
	oView:SetOwnerView( 'VIEW_ZAO' , "BOX1" )


return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} LoadZAO
Carrega os registros da tabela ZAO de acordo com o RECNO posicionado
@author  marcio.katsumata
@since   06/08/2019
@version 1.0
@param   oObj, object, model
@param   array, array com os registros
/*/
//-------------------------------------------------------------------
static Function LoadZAO (oObj )
    Local aRet as array
    Local cAliasTmp as character
    Local cQuery as character
    
    cAliasTmp := getNextAlias()

    beginSql alias cAliasTmp
        SELECT ZAO.*, ZAO.R_E_C_N_O_ AS RECNO  FROM %table:ZAO% ZAO
        WHERE ZAO.ZAO_COD = %exp:SB1->B1_COD% AND
              ZAO.%notDel%

    endSql


    // Como tem o campo R_E_C_N_O_, nao é preciso informar qual o campo contem o Recno() real
    aRet := FWLoadByAlias( oObj, cAliasTmp, 'ZAO' ) 

    (cAliasTmp)->( dbCloseArea() )


Return aRet 