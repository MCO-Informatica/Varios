#include 'protheus.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} FILOGWRT
Classe responsável pela gravação de log na tabela EWZ
@author  marcio.katsumata
@since   03/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class FILOGWRT

    method new() constructor
    method update() 
    method destroy()
    method getFiLog()
    method getNumPo()

    data cFilLog as string
    data lEWZLog as boolean
    data lNewReg as boolean
    data cLogAlias as string
    data cNumPO  as string
endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   03/09/2019
@version 1.0
@param   cFileName, character, nome do arquivo
@param   cType    , character, tipo do arquivo
@param   lSeekOk  , character, resultado do seek na tabela
@param   cMsgErro , character, mensagem de erro
@return  object, self
/*/
//-------------------------------------------------------------------
method new(cFileName,lEwz,cType,cFilLog, lSeekOk,cMsgErro) class FILOGWRT
    local cAliasLog as character
    local cAliasZNT as character
    
    default lSeekOk := .F.
    default cFilLog := ""

    self:lEwzLog := lEwz
    self:lNewReg := .F.
    self:cFilLog := cFilLog
    self:cNumPO  := ""

    cAliasLog := getNextAlias()

    if self:lEwzLog 
        beginSql alias cAliasLog
            SELECT EWZ.R_E_C_N_O_ RECNUM FROM %table:EWZ% EWZ
            WHERE EWZ.EWZ_ARQUIV = %exp:PADR(lower(cFileName), tamSx3("EWZ_ARQUIV")[1])% AND
                  EWZ.EWZ_SERVIC = %exp:cType% AND
                  EWZ.%notDel%
        endSql

        if (lSeekOk := (cAliasLog)->(!eof()))
            self:cLogAlias := "EWZ"
            dbSelectArea("EWZ")
            EWZ->(dbGoTo( (cAliasLog)->RECNUM))
            self:cFilLog := EWZ->EWZ_FILIAL
            self:cNumPO := iif(!empty(EWZ->EWZ_PO_NUM), EWZ->EWZ_PO_NUM, EWZ->EWZ_HAWB)
        else
            cMsgErro+="[FILOGWRT] Registro não encontrado :"+cFileName
        endif

    else
        dbSelectArea("ZNT")

        beginSql alias cAliasLog
            SELECT ZNT.R_E_C_N_O_ RECNUM FROM %table:ZNT% ZNT
            WHERE ZNT.ZNT_FILE = %exp:PADR(cFileName, tamSx3("ZNT_FILE")[1])% AND
                  ZNT.ZNT_ETAPA = %exp:cType% AND
                  ZNT.%notDel%
        endSql

        if  !(self:lNewReg  := (cAliasLog)->(eof()))
            ZNT->(dbGoTo( (cAliasLog)->RECNUM))
            lSeekOk := .T.
        endif

        self:cLogAlias := "ZNT"

    endif

    (cAliasLog)->(dbCloseArea())
return

//-------------------------------------------------------------------
/*/{Protheus.doc} update
Update nos campos da tabela EWZ.
@author  marcio.katsumata
@since   03/09/2019
@version 1.0
@param   aLogSet, array, vetor com nome do campo x valor .
@return  nil, nil   
/*/
//-------------------------------------------------------------------
method update(aLogSet) class FILOGWRT
    local nInd as numeric

    reclock(self:cLogAlias,self:lNewReg)

    if self:lNewReg
        (self:cLogAlias)->&(self:cLogAlias+"_FILIAL") := self:cFilLog
        if (self:cLogAlias) == "ZNT"
            ZNT->ZNT_CODPRC := GetSxeNum("ZNT", "ZNT_CODPRC")
        endif
    endif
    for nInd := 1 to len(aLogSet)
        (self:cLogAlias)->&(aLogSet[nInd][1]) := aLogSet[nInd][2]
    next nInd
    //--------------------------------------------------------------
    //O usuário que gerou o arquivo deve ser o que enviou o arquivo
    //--------------------------------------------------------------
    if self:cLogAlias == "EWZ"
        EWZ->EWZ_USEREN := EWZ->EWZ_USERGE
    endif

    (self:cLogAlias)->(msUnlock())

return

//-------------------------------------------------------------------
/*/{Protheus.doc} getFiLog
Retorna a filial da tabela EWZ/ZNT
@author  marcio.katsumata
@since   04/09/2019
@version 1.0
@return  character, filial EWZ/ZNT
/*/
//-------------------------------------------------------------------
method getFiLog() class FILOGWRT

return self:cFilLog

//-------------------------------------------------------------------
/*/{Protheus.doc} getNumPo
Retorna o numero da PO da tabela EWZ/ZNT
@author  marcio.katsumata
@since   04/09/2019
@version 1.0
@return  character, numero PO EWZ/ZNT
/*/
//-------------------------------------------------------------------
method getNumPo() class FILOGWRT

return self:cNumPO
//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Limpeza de objetos e fechamento de alias
@author  marcio.katsumata
@since   03/09/2019
@version 1.0
@return  nil, nil
/*/
//-------------------------------------------------------------------
method destroy() class FILOGWRT
    if self:cLogAlias == 'ZNT'
        confirmSX8()
    endif
    if !empty(self:cLogAlias)
        (self:cLogAlias)->(dbCloseArea())
    endif
return

user function FILOGWRT()
return
