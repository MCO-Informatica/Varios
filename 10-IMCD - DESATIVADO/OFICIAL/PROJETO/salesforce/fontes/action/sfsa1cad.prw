#include 'protheus.ch'
#include "fwmvcdef.ch"
#include 'json.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SFSA1CAD
Rotina de cadastro de clientes através do JSON cadastrado na tabela
intermediária de integração de registros criados no Sales Force
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@param   oJson, object, json object
@param   oSfInLy, object, objeto da classe SFINLYMOD (layout de integração)
/*/
//-------------------------------------------------------------------
user function SFSA1CAD (oJson, oSfInLy, oModelIn)
    
    local nTamLy as numeric
    local oModelSA1 as object
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
    //Prepara o model da tabela SA1
    //------------------------------------------------------
    oModelSA1 :=  FWLoadModel("MATA030") 
    oModelSA1:setOperation( MODEL_OPERATION_INSERT)
    oModelSA1:activate()

    //-----------------------------------------------------------
    //Popula o model da tabela SA1 de acordo com o JSON 
    //do registro da tabela ZNS (tabela intermediaria)
    //posicionada
    //-----------------------------------------------------------
    for nInd := 1 to nTamLy
        oSfInLy:getModel('ZNQDETAIL'):goLine(nInd)
        cColumn := alltrim(oSfInLy:getValue("ZNQDETAIL", "ZNQ_CMPPRT"))
        xValue  := oJson[#cColumn]
        oModelSA1:getModel("MATA030_SA1"):setValue(cColumn, xValue)
    next nInd
    

    //---------------------------------------------------------------
    //Realiza a montagem da tela de cadastro de cliente
    //---------------------------------------------------------------
    aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
    nOpc := MODEL_OPERATION_INSERT
    if FWExecView('','SFSA1CAD', nOpc, , { || .T. }, , ,aButtons,,,,oModelSA1 ) == 0
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
    oModelSA1:deActivate() 
    oModelSA1:destroy()    
    freeObj(oModelSA1)

return

//-------------------------------------------------------------------
/*/{Protheus.doc} viewdef
Implementação do viewdef do model MATA030
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@return  object, view
/*/
//-------------------------------------------------------------------
static function viewdef()

    local oStruSA1  as object
    local oStruZNS  as object
    local oModel    as object
    local oView     as object


    oStruSA1  := FWFormStruct( 2, 'SA1')
    oModel   := FWLoadModel( 'MATA030' )

	oView := FWFormView():New()
	oView:SetModel( oModel )
	
	oView:AddField('VIEW_SA1' , oStruSA1, 'MATA030_SA1')

	oView:CreateHorizontalBox( "BOX1",  100 )

	oView:SetOwnerView( 'VIEW_SA1' , "BOX1" )

return oView

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

/*/{Protheus.doc} SFGTIBGE
//Função utilizada para verificar o código do municipio.
@author marcio.katsumata
@since 01/03/2018
@version 1.0
@return characters, código IBGE
@param cEstado, characters, estado
@param cMunicipio, characters, município
/*/
user function SFGTIBGE(cEstado, cMunicipio) 

	Local aArea   := GetArea()  //Salva a area atual
	Local cCodMun := ""         //Codigo municipal da tabela CC2
    local nTamZNQ :=0
    local nLinePos := 0
    Local nInd := 0
    
	Default cEstado    := ""
	Default cMunicipio := alltrim(xValue)

    if !empty(oModelLy) .and. !empty(aDadAux) .and. !empty(aHeadAux)

        nTamZNQ := oModelLy:getModel("ZNQDETAIL"):length() 
        nLinePos := oModelLy:getModel("ZNQDETAIL"):getLine()

        for nInd := 1 to  nTamZNQ
            oModelLy:getModel("ZNQDETAIL"):goLine(nInd)
            if alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_CMPPRT")) == 'A1_EST'
                cEstado :=  STRTRAN(aDadAux[nIndLin1][aHeadAux[nInd][2]],'"','')
            endif
        next nInd 

        oModelLy:getModel("ZNQDETAIL"):goLine(nLinePos)

    endif

	cEstado    := Upper(cEstado)
	cMunicipio := Alltrim(Upper(ftAcento(cMunicipio)))


	DbSelectArea("CC2")
	CC2->(DbSetOrder(2))  //CC2_FILIAL+CC2_MUN        

	CC2->(DbSeek(xFilial("CC2")+cMunicipio))

	While !CC2->( Eof() ) .And. (CC2->CC2_FILIAL == xFilial("CC2")) .And. (Alltrim(CC2->CC2_MUN) == cMunicipio)

		If  (CC2->CC2_EST == cEstado)
			cCodMun := CC2->CC2_CODMUN
			Exit
		EndIf   

		CC2->(DbSkip())
	End
	
	DbSelectArea("CC2")
	CC2->(DbSetOrder(1))  //CC2_FILIAL+CC2_MUN      

	RestArea(aArea)

Return cCodMun

/*/{Protheus.doc} SFCODVEN
//Função utilizada para verificar o codigo do vendedor
@author marcio.katsumata
@since 25/07/2019
@version 1.0
@return characters, código 
/*/
user function SFCODVEN() 

    local cAliasSA3 as character
    local cSA3Cod   as character
    local cLike     as character

    cAliasSA3 := getNextAlias()
    cSA3Cod   := ""
    cLike := "%'%"+upper(substr(xValue,1,at("_",xValue)-1))+"%'%"
    beginSql alias cAliasSA3
        SELECT SA3.A3_COD FROM %table:SA3% SA3
        WHERE upper(SA3.A3_USUCORP) LIKE %exp:cLike% AND
              SA3.%notDel%
          
    endSql

    if (cAliasSA3)->(!eof())
        cSA3Cod := (cAliasSA3)->A3_COD
    endif

    (cAliasSA3)->(dbCloseArea())
Return cSA3Cod
