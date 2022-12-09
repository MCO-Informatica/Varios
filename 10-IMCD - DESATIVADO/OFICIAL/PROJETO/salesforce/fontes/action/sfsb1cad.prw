#include 'protheus.ch'
#include "fwmvcdef.ch"
#include 'json.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SFSB1CAD
Rotina de cadastro de clientes através do JSON cadastrado na tabela
intermediária de integração de registros criados no Sales Force
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@param   oJson, object, json object
@param   oSfInLy, object, objeto da classe SFINLYMOD (layout de integração)
/*/
//-------------------------------------------------------------------
user function SFSB1CAD (oJson, oSfInLy, oModelIn)
    
    local nTamLy as numeric
    local oModelSB1 as object
    local cColumn   as character
    local xValue
    local aButtons as array
    local nOpc as numeric
    Local nInd as numeric

    //------------------------------------------------------
    //Verifica a quantidade de registros da tabela de layout
    //da entidade ACCOUNT
    //------------------------------------------------------
    nTamLy := oSfInLy:getModel("ZNQDETAIL"):length()
    
    //------------------------------------------------------
    //Prepara o model da tabela SB1
    //------------------------------------------------------
    oModelSB1 :=  FWLoadModel("MATA010") 
    oModelSB1:setOperation( MODEL_OPERATION_INSERT)
    oModelSB1:activate()

    //-----------------------------------------------------------
    //Popula o model da tabela SA1 de acordo com o JSON 
    //do registro da tabela ZNS (tabela intermediaria)
    //posicionada
    //-----------------------------------------------------------
    for nInd := 1 to nTamLy
        oSfInLy:getModel('ZNQDETAIL'):goLine(nInd)
        cColumn := alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPPRT"))
        xValue  := oJson[#cColumn]
        oModelSB1:getModel("SB1MASTER"):setValue(cColumn, xValue)
    next nInd
    
    //---------------------------------------------------------------
    //Realiza a montagem da tela de cadastro de cliente
    //---------------------------------------------------------------
    aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
    nOpc := MODEL_OPERATION_INSERT
    if FWExecView('','MATA010', nOpc, , { || .T. }, , ,aButtons,,,,oModelSB1 ) == 0
        //--------------------------------------------------------------------------
        //Realiza a mudança de status e grava as data de cadastro na tabela ZNR/ZNS
        //tabela intermdiária de integração de registros criados no Sales Force
        //--------------------------------------------------------------------------
        oModelIn:setValue("ZNSDETAIL","ZNS_STATUS", "2")
        oModelIn:setValue("ZNSDETAIL","ZNS_LEGEN", "BR_VERDE")
        oModelIn:setValue("ZNSDETAIL","ZNS_CDDATE", date())
        oModelIn:setValue("ZNSDETAIL","ZNS_CDTIME", time())
        checkStatus(oModelIn)
    endif

    //---------------------------------
    //Realiza a limpeza do model SA1.
    //---------------------------------
    oModelSB1:deActivate() 
    oModelSB1:destroy()    
    freeObj(oModelSB1)

return


//-------------------------------------------------------------------
/*/{Protheus.doc} checkStatus
Realiza checagem de status das linhas da tabela ZNS para realizar
a mudança de status da tabela ZNR.
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@param   oModelIn, object, model
@return  nil, nil
/*/
//-------------------------------------------------------------------
static function checkStatus(oModelIn)
    local nQtd as numeric
    local nInd as numeric
    local lStatus as logical
    local lProcOk as logical

    lStatus := .T.
    lProcOk := .F.


    nQtd := oModelIn:getModel("ZNSDETAIL"):length()
    
    for nInd := 1 to nQtd
        
        oModelIn:getModel("ZNSDETAIL"):goLine(nInd)
        //----------------------------------------------------------------
        //Verifica se existe alguma linha com o status 1 = Não cadastrado.
        //----------------------------------------------------------------
        if oModelIn:getValue("ZNSDETAIL", "ZNS_STATUS") == '1'
            lStatus := .F.
        else
            //------------------------------------------------------------------
            //Se caso existir um ou mais registros com o status 2 = Cadastrado
            //marca a flag lProcOk.
            //------------------------------------------------------------------
            lProcOk := .T.
        endif

        oModelIn:setValue("ZNRMASTER", "ZNR_STATUS", iif(lStatus, "3", iif(lProcOk, "2", "1") ))
    next 

return