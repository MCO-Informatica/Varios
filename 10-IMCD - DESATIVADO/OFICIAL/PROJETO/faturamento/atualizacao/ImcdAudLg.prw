#include 'protheus.ch'
#include 'FWMVCDEF.CH'



//-------------------------------------------------------------------
/*/{Protheus.doc} modeldef
Modeldef da tabela ZAK
@author  marcio.katsumata
@since   16/06/2020
@version 1.0
@return  object, model da tabela ZAK
/*/
//-------------------------------------------------------------------
static function modeldef() as object

    Local oStruZAKM  as object
    Local oStruZAKD  as object
    Local oModel    as object

    oStruZAKM := FWFormStruct( 1, 'ZAK')
    oStruZAKD := FWFormStruct( 1, 'ZAK')
                                              
    oModel := MPFormModel():New( 'IMCDLGAUD')

    oModel:AddFields( 'ZAKMASTER', NIL, oStruZAKM )
    oModel:AddGrid( 'ZAKDETAIL', 'ZAKMASTER', oStruZAKD, , , , ,{|oModel|LoadZAK(oModel)} )

	oModel:SetRelation( 'ZAKDETAIL', { { 'ZAK_FILIAL', 'xFilial( "ZAK" )' }} , ZAK->( IndexKey( 1 ) ) )
    
    oModel:SetDescription( 'Log audit IMCD' )
    oModel:GetModel( 'ZAKMASTER' ):SetDescription( 'Dados do Cabecalho' )
    oModel:GetModel( 'ZAKDETAIL' ):SetDescription( 'Dados dos arquivos'  )
    oModel:GetModel( 'ZAKDETAIL' ):SetMaxLine(900000)

    oModel:SetPrimaryKey( {} )   
return oModel



//-------------------------------------------------------------------
/*/{Protheus.doc} viewdef
Viewdef da tabela ZNO e ZNP 
@author  marcio.katsumata
@since   16/06/2020
@version 1.0
@return  object, view da tabela ZNO e ZNP 
/*/
//-------------------------------------------------------------------

static function viewdef() as object
    local oStruZAKD  as object
    local oModel    as object
    local oView     as object

    oStruZAKD := FWFormStruct( 2, 'ZAK',{|cCampo| !AllTRim(cCampo) $ "ZAK_KEY|" })
    oModel   := FWLoadModel( 'IMCDAUDLG' )

	oView := FWFormView():New()
	oView:SetModel( oModel )

	oView:AddGrid( 'VIEW_ZAK' , oStruZAKD, 'ZAKDETAIL')
	oView:CreateHorizontalBox( "BOX1",  100 )
	oView:SetOwnerView( 'VIEW_ZAK' , "BOX1" )


return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} LoadZAK
Carrega os registros da tabela ZNP de acordo com o RECNO posicionado
@author  marcio.katsumata
@since   16/06/2020
@version 1.0
@param   oObj, object, model
@param   array, array com os registros
/*/
//-------------------------------------------------------------------
static Function LoadZAK (oObj )
    Local aRet as array
    Local cAliasTmp as character
    Local cQuery as character
    
    cAliasTmp := getNextAlias()

    beginSql alias cAliasTmp
        SELECT ZAK.* ,ZAK.R_E_C_N_O_ as RECNO FROM %table:ZAK% ZAK
        WHERE ZAK.ZAK_ENTITY = %exp:cEntity% AND
              ZAK.ZAK_INDEX  = %exp:cValToChar(nZakIndex)% AND
              ZAK.ZAK_KEY = %exp:cZAKKey%    AND
              ZAK.%notDel%

    endSql

    TcSetField(cAliasTmp,'ZAK_DATE','D',8,0)
    // Como tem o campo R_E_C_N_O_, nao é preciso informar qual o campo contem o Recno() real
    aRet := FWLoadByAlias( oObj, cAliasTmp, 'ZAK' ) 

    (cAliasTmp)->( dbCloseArea() )


Return aRet 


