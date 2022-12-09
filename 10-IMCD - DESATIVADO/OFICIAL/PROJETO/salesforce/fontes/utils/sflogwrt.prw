#include 'protheus.ch'
#include "fwmvcdef.ch"



//-------------------------------------------------------------------
/*/{Protheus.doc} SFLOGWRT
Realiza a gravação/consulta da tabela de LOGS (ZNO/ZNP)
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFLOGWRT

    method new() constructor
    method writeLine()
    method updateHead()
    method getStatusH()
    method getStatusL()
    method isStatusL()
    method destroy()
    method save() 
    method updMSExp()
    method getTable()

    data oModelLog  as object  //Objeto do model das tabelas ZNO/ZNP
    data cProcessID as string  //ID do processo de exportação
    data cFileID    as string  //ID do arquivo de exportação
    data lNew       as boolean //Registro novo

ENDCLASS

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor 
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@param   cTableName, character, nome da tabela
@param   cFileID   , character, nome do arquivo
@param   cProcessID, character, ID do processo
@param   lSeekOK   , boolean  , registro ZNO encontrado? Utilizado apenas
                                para update de registros
@param   lNew       , boolean , registro novo? 
/*/  
//-------------------------------------------------------------------
method new(cTableName,cFileID,cProcessID,lSeekOK, lNew) class SFLOGWRT
    

    default cProcessID := ""
    default cFileId    := ""
    default lSeekOK    := .F.
    default lNew       := .T.

    self:cProcessID     := PADR(cProcessID, tamSx3("ZNO_CODPRC")[1])
    self:cFileID        := lower(PADR(cFileID, tamSx3("ZNO_FILE")[1]))
    self:lNew           := lNew


    dbSelectArea("ZNO")

    //---------------------------------------------------------
    //Caso o registro não seja novo realizar o seek do registro
    //---------------------------------------------------------
    if !lNew
        //---------------------
        //Seek pelo ID processo
        //---------------------
        if !empty(cProcessID) 
            ZNO->(dbSetOrder(1))
            lSeekOK := ZNO->(dbSeek(xFilial("ZNO")+PADR(self:cProcessID,tamSx3("ZNO_CODPRC")[1])))
        else
            //-----------------------
            //Seek pelo ID do arquivo
            //-----------------------
            ZNO->(dbSetOrder(2))
            lSeekOK := ZNO->(dbSeek(xFilial("ZNO")+padr(self:cFileID, tamSX3("ZNO_FILE")[1])))
        endif
    endif

    //----------------------------------
    //Inicialização do model
    //----------------------------------
    if (!lNew .and. lSeekOK) .or. lNew     
        self:oModelLog :=  FWLoadModel("SFINTMOD") 
        self:oModelLog:setOperation(iif(lNew, MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE))
        self:oModelLog:activate()

        //--------------------------------------------------
        //Caso seja um novo registro
        //--------------------------------------------------
        if lNew
            self:cProcessID := getSxeNum("ZNO", "ZNO_CODPRC")
            self:oModelLog:setValue( 'ZNOMASTER'    , 'ZNO_CODPRC'  , self:cProcessID  )
            self:oModelLog:setValue( 'ZNOMASTER'    , 'ZNO_ENTITY'  , cTableName)
            self:oModelLog:setValue( 'ZNOMASTER'    , 'ZNO_FILE'    , self:cFileID )
            self:oModelLog:setValue( 'ZNOMASTER'    , 'ZNO_EXDATE'  , date())
            self:oModelLog:setValue( 'ZNOMASTER'    , 'ZNO_EXHOUR'  , time())
            self:oModelLog:setValue( 'ZNOMASTER'    , 'ZNO_STATUS'  , "1")
        endif
    endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} writeLine
Realiza a população da grid tabela ZNP
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@param   aDataSet, array, dados a serem populados
@param   lUpdate , boolean, é uma ação de update?
@param   xSeekKey, character, chave para a procura do registro caso seja um update.
@return  nil, nil
/*/
//-------------------------------------------------------------------
method writeLine (aDataSet, lUpdate, xSeekKey, cSeekChv) class SFLOGWRT
    local nIndData  as numeric
    local nIndLine  as numeric
    local nLine     as numeric
    local nLines    as numeric 
    local xValue
    local cStatus   as character

    default lUpdate := .F.
    default xSeekKey := ""
    default cSeekChv := "ZNP_CHVSF"

    nIndData := 0
    nIndLine := 0

    if !lUpdate
        for nIndLine := 1 to len(aDataSet)

            for nIndData := 1 to len(aDataSet[nIndLine])
                if valtype(aDataSet[nIndLine][nIndData][1]) $ 'C/D/N/L' .and. valType(aDataSet[nIndLine][nIndData][2] ) $ 'C/D/N/L'
                    self:oModelLog:setValue('ZNPDETAIL', aDataSet[nIndLine][nIndData][1], aDataSet[nIndLine][nIndData][2])
                endif
            next nIndData

            if nIndLine+1 <= len(aDataSet)
                self:oModelLog:getModel("ZNPDETAIL"):addLine()
            endif

        next nIndLine
    else

        if self:oModelLog:getModel("ZNPDETAIL"):SeekLine({{cSeekChv,xSeekKey}}, .F., .T.)
            for nIndData := 1 to len(aDataSet)
                self:oModelLog:setValue("ZNPDETAIL", aDataSet[nIndData][1], aDataSet[nIndData][2] )
            next nIndData
        endif


    endif
return

//-------------------------------------------------------------------
/*/{Protheus.doc} updateHead
Realiza o update de informações no cabeçalho (tabela ZNO)
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@param   aDataSet, array, vetor com informações das colunas x valores
@return  nil, nil
/*/
//-------------------------------------------------------------------
method updateHead(aDataSet) class SFLOGWRT
    local nIndData  as numeric


    nIndData := 0


    for nIndData := 1 to len(aDataSet)
        self:oModelLog:setValue('ZNOMASTER', aDataSet[nIndData][1], aDataSet[nIndData][2])
    next nIndData


return

//-------------------------------------------------------------------
/*/{Protheus.doc} getStatusH
Retorna o status do processo.
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@return  character, status do processo.
/*/
//-------------------------------------------------------------------
method getStatusH() class SFLOGWRT


return self:oModelLog:getValue( 'ZNOMASTER'    , 'ZNO_STATUS')


//-------------------------------------------------------------------
/*/{Protheus.doc} getTable
Retorna a tabela.
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@return  character, status do processo.
/*/
//-------------------------------------------------------------------
method getTable() class SFLOGWRT


return self:oModelLog:getValue( 'ZNOMASTER'    , 'ZNO_ENTITY')

//-------------------------------------------------------------------
/*/{Protheus.doc} getStatusL
Status das linhas da grid.(Tabela ZNP)
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
@param   cColumn, character, coluna a ser considerada no seek
@param   xValue, any, valor a ser considerado no seek
@param   character, status da linha
/*/
//-------------------------------------------------------------------
method getStatusL(cColumn,xSeekKey) class SFLOGWRT
    local nLines as numeric
    local nLine  as numeric

    nLine := 1
    nLines := self:oModelLog:getModel("ZNPDETAIL"):Length()

    for nLine:=1 to nLines
        self:oModelLog:getModel("ZNPDETAIL"):goLine(nLine)
        xValue := self:oModelLog:getValue("ZNPDETAIL", cColumn)
        if xValue == xSeekKey
            cStatus := self:oModelLog:getValue("ZNPDETAIL", "ZNP_STATUS")
        endif
    next nLine

return cStatus


//-------------------------------------------------------------------
/*/{Protheus.doc} getPendingL
Existem linhas com determinado status?
@author  marcio.katsumata
@since   16/07/2019
@version 1.0
@param   cStatusChk, character, status a ser checado.
@return  boolean, existência de linhas
/*/
//-------------------------------------------------------------------
method isStatusL(cStatusChk) class SFLOGWRT
    local nLines as numeric
    local nLine  as numeric
    local lPending as logical

    lPending := .F.
    nLine := 1
    nLines := self:oModelLog:getModel("ZNPDETAIL"):Length()

    for nLine:=1 to nLines
        self:oModelLog:getModel("ZNPDETAIL"):goLine(nLine)
        if self:oModelLog:getValue("ZNPDETAIL", "ZNP_STATUS") == cStatusChk
            lPending := .T.
        endif
    next nLine

return lPending

//-------------------------------------------------------------------
/*/{Protheus.doc} save
Realiza a gravação do model
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method save()  class SFLOGWRT
    //Validação e Gravação do Modelo
    If self:oModelLog:VldData()
        self:oModelLog:CommitData()
    EndIf

return

//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Realiza a limpeza de objetos
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class SFLOGWRT
    self:oModelLog:deActivate()
    freeObj(self:oModelLog)

return

//-------------------------------------------------------------------
/*/{Protheus.doc} updMSExp
Método responsável pela atualização da flag MSEXP da tabela extraida
@author  marcio.katsumata
@since   13/07/2019
@version 1.0
@param   cMsgErro, character, mensagem de erro
@return  boolean, character, retorno de sucesso da atualização
/*/
//-------------------------------------------------------------------
method updMSExp(cMsgErro) class SFLOGWRT

    local cChvPrt as character
    local nLine   as numeric
    local nLines  as numeric
    local cEntity as character
    local cScript as character
    local aChvColumns as array
    local lOracle   as logical
    local aChvPrt  as array
    local nInd     as numeric 
    private cChave  as character
    private nTamInd as numeric

    //Inicialização de variáveis
    cChvPrt := ""
    nLine := 0
    nLines := 0
    cScript := ""
    aChvColumns:= {}
    cChave   := ""
    nTamInd  := 0
    lOracle  := upper(alltrim(TCGetDB())) == "ORACLE"	
    aChvPrt  := {}
    //Verifica o tamanho do indice
    cEntity := self:oModelLog:getValue("ZNOMASTER", 'ZNO_ENTITY')
    aChvColumns := StrTokArr2( FwX2Unico(cEntity),"+", .F.)
    aEval(aChvColumns, {|cColumn| nTamInd += tamSx3(cColumn)[1] })
    aEval(aChvColumns, {|cColumn| cChave +=  cColumn+ iif(lOracle, " || ", "+" )})

    if lOracle
        cChave := substr(cChave,1,len(cChave)-3)
    else
        cChave := substr(cChave,1,len(cChave)-1)
    endif 

    nLine := 1
    nLines := self:oModelLog:getModel("ZNPDETAIL"):Length()

    dbSelectArea(cEntity) 

    for nLine:=1 to nLines
        self:oModelLog:getModel("ZNPDETAIL"):goLine(nLine)
        cChvPrt := PADR(self:oModelLog:getValue("ZNPDETAIL", 'ZNP_CHVPRT'), nTamInd)

        if "/" $ cChvPrt
            aChvPrt := StrTokArr2(cChvPrt,"/", .F.)
        else
            aChvPrt := {cChvPrt}
        endif

        if !empty(aChvPrt)
            for nInd := 1 to len(aChvPrt)
                cChvPrt := alltrim(aChvPrt[nInd])
                if isDigit(cChvPrt)
                    //Tenta realizar lock via RLock
                    //Se não conseguir, realiza UPDATE via script.
                    (cEntity)->(dbGoTo(val(cChvPrt)))
                    If RLock()
                        (cEntity)->&(substr(cEntity,2,2)+"_MSEXP") := dtos(date())
                        (cEntity)->(DbrUnlock(val(cChvPrt)))
                    else
                        cScript := "UPDATE "+retSqlName(cEntity)+" SET "+substr(cEntity,2,2)+"_MSEXP"+" = '"+dtos(date())+"' WHERE R_E_C_N_O_ = "+alltrim(cChvPrt)
                        if tcSqlExec(cScript) < 0
                            cMsgErro := " ERRO UPDMSEXP: " +CRLF+ TCSQLError()
                        endif
                    endif
                endif
            next nInd 
        endif

    next nLine
    
    (cEntity)->(dbCloseArea())
return

user function sflogwrt()

return