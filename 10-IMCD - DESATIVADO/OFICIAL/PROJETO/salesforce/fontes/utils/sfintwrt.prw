#include 'protheus.ch'
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} SFINTWRT
Realiza a gravação/consulta da tabela de LOGS (ZNR/ZNS)
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFINTWRT

    method new() constructor
    method writeLine()
    method destroy()
    method save() 
    method getTable()

    data oModelSfin  as object  //Objeto do model das tabelas ZNR/ZNS
    data cProcessID as string  //ID do processo de exportação
    data cFileID    as string  //ID do arquivo de exportação

ENDCLASS

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor 
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@param   cEntity   , character, nome da entidade
@param   cFileID   , character, nome do arquivo
@param   cAliasName, character, alias 
@param   lNew       , boolean , registro novo? 
/*/  
//-------------------------------------------------------------------
method new(cEntity,cFileID,cAliasName) class SFINTWRT

    self:cFileID        := lower(PADR(cFileID, tamSx3("ZNR_FILE")[1]))

    dbSelectArea("ZNR")

    //---------------------
    //Seek pelo ID processo
    //---------------------
    if !empty(cFileID) 
        ZNR->(dbSetOrder(1))
        lOK := !ZNR->(dbSeek(xFilial("ZNR")+PADR( self:cFileID ,tamSx3("ZNR_FILE")[1])))
    endif
    

    //----------------------------------
    //Inicialização do model
    //----------------------------------
   
        self:oModelSfin :=  FWLoadModel("SFINRMOD") 
    if  lOk
        self:oModelSfin:setOperation(MODEL_OPERATION_INSERT)
    else
        self:oModelSfin:setOperation(MODEL_OPERATION_UPDATE)
    endif

    self:oModelSfin:activate()

    if  lOk
        self:cProcessID := getSxeNum("ZNR", "ZNR_CODPRC")
        self:oModelSfin:setValue( 'ZNRMASTER'    , 'ZNR_CODPRC'  , self:cProcessID  )
        self:oModelSfin:setValue( 'ZNRMASTER'    , 'ZNR_ENTITY'  , cEntity)
        self:oModelSfin:setValue( 'ZNRMASTER'    , 'ZNR_FILE'    , self:cFileID )
        self:oModelSfin:setValue( 'ZNRMASTER'    , 'ZNR_ALIAS'    , cAliasName )
    endif
    
    self:oModelSfin:setValue( 'ZNRMASTER'    , 'ZNR_INDATE'  , date())
    self:oModelSfin:setValue( 'ZNRMASTER'    , 'ZNR_INHOUR'  , time())
    self:oModelSfin:setValue( 'ZNRMASTER'    , 'ZNR_STATUS'  , "1")
        
    

return

//-------------------------------------------------------------------
/*/{Protheus.doc} writeLine
Realiza a população da grid tabela ZNS
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@param   aDataSet, array, dados a serem populados
@return  nil, nil
/*/
//-------------------------------------------------------------------
method writeLine (aDataSet) class SFINTWRT
    local nIndData  as numeric
    local nIndLine  as numeric
    local nLine     as numeric
    local nLines    as numeric 
    local xValue
    local cStatus   as character


    nIndData := 0
    nIndLine := 0


    for nIndLine := 1 to len(aDataSet)

        for nIndData := 1 to len(aDataSet[nIndLine])
            if valtype(aDataSet[nIndLine][nIndData][1]) == 'C' .and. valType(aDataSet[nIndLine][nIndData][2] ) $ 'C/D/N/L'
                    self:oModelSfin:setValue('ZNSDETAIL', aDataSet[nIndLine][nIndData][1], aDataSet[nIndLine][nIndData][2])
            endif
        next nIndData

        if nIndLine+1 <= len(aDataSet)
            self:oModelSfin:getModel("ZNSDETAIL"):addLine()
        endif

    next nIndLine


    
return
//-------------------------------------------------------------------
/*/{Protheus.doc} getTable
Retorna a tabela.
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@return  character, nome da tabela
/*/
//-------------------------------------------------------------------
method getTable() class SFINTWRT


return self:oModelSfin:getValue( 'ZNRMASTER'    , 'ZNR_ENTITY')
//-------------------------------------------------------------------
/*/{Protheus.doc} save
Realiza a gravação do model
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method save()  class SFINTWRT
    //Validação e Gravação do Modelo
    If self:oModelSfin:VldData()
        self:oModelSfin:CommitData()
    EndIf

return
//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Realiza a limpeza de objetos
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class SFINTWRT
    self:oModelSfin:deActivate()
    freeObj(self:oModelSfin)

return

user function sfintwrt()
return

