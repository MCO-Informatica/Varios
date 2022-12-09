#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} SFGETACT
Classe action utilizada para importação de arquivos do sales force
@author  marcio.katsumata
@since   19/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFGETACT

    method new() constructor
    method getFiles()
    method selEntities()

    data aEntities as array
    data oSfUtil   as object
    data lJob      as logical 
    data lEnd      as logical
    
endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   19/07/2019
@version 1.0
@param   lJob, boolean, indica a rotina está sendo executada por job
@param   lEnd, boolean, flag de cancelamento do processo.
@return  object, self
/*/
//-------------------------------------------------------------------
method new(lJob, lEnd) class SFGETACT

    default lJob := .T.
    //------------------------------------
    //Inicialização dos atributos
    //------------------------------------
    self:oSfUtil := SFUTILS():new()
    self:lJob      := lJob
    self:lEnd      := lEnd
    self:aEntities := {}
return

//-------------------------------------------------------------------
/*/{Protheus.doc} function
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
method getFiles(lOk,cMsgErro, lNewSFReg) class SFGETACT
    local oSfSFTP as object
    local nIndImp as numeric
    local nInsSta as numeric
    local cStatus as character


    default lNewSFReg := .F.

    cMsgErro := ""
    
    //Seleciona as entidades
    self:selEntities(lNewSfReg)

    //-----------------------------------------------
    //Realiza o get dos arquivos no SFTP Sales Force
    //pasta Success e Error de cada entidade
    //-----------------------------------------------
    oSfSftp := SFFTPUtil():New()
    oSfSftp:getUrl()
    oSfSftp:getAuth()
    lOk := oSfSftp:getFile(self:aEntities, @cMsgErro, lNewSFReg)

    aSize(self:aEntities,0)
    freeObj(oSfSftp)
    freeObj(self:oSfUtil)
return


//-------------------------------------------------------------------
/*/{Protheus.doc} selEntities
Verifica as entidades disponiveis para realizar o get no SFTP
@author  marcio.katsumata
@since   19/07/2019
@version 1.0
@return  array, entidades
/*/
//-------------------------------------------------------------------
method selEntities(lNewSfReg) class SFGETACT

    local aDirPend as array      //Lista de diretórios da pasta pending
    local cPath    as character  //Caminho da pasta pending
    local cRootPath as character //RootPath do Protheus
    local aDirAux   as array     //Diretório auxiliar para naveção entre as pastas do diretório pending
    local nInd      as numeric   //Indice 
    local nInd2     as numeric   //Indice  
    local lOk       as logical   //Retorno de sucesso   
    local cReaded     as character //Diretório da pasta de arquivos enviados.  
    local cAliasZNQ   as character //alias temporário

    if lNewSfReg
        cAliasZNQ := getNextAlias()
        beginSql alias cAliasZNQ
            SELECT DISTINCT (ZNQ.ZNQ_ENTITY) FROM %table:ZNQ% ZNQ
            WHERE ZNQ.%notDel% AND ZNQ.ZNQ_XML <>'S'
        endSql

        while (cAliasZNQ)->(!eof())
            aadd(self:aEntities, UPPER(alltrim((cAliasZNQ)->ZNQ_ENTITY)))
            (cAliasZNQ)->(dbSkip())        
        enddo
        (cAliasZNQ)->(dbCloseArea())
    else
        //--------------------------------------------
        //Inicialização de variáveis
        //--------------------------------------------
        cRootPath := GetSrvProfString ("ROOTPATH","")
        aDirPend := {}
        self:aEntities := {}
        lOk      := .F.
        cReaded    := ""
        cPath    := self:oSfUtil:getExpPend()
        aDirPend := Directory(cPath+"\*.*","D")
        
        cAliasZNQ := getNextAlias()
        beginSql alias cAliasZNQ
            SELECT DISTINCT (ZNQ.ZNQ_ENTITY) FROM %table:ZNQ% ZNQ
            WHERE ZNQ.%notDel% AND ZNQ.ZNQ_XML = 'S'
        endSql

        while (cAliasZNQ)->(!eof())
            aadd(self:aEntities, lower(alltrim((cAliasZNQ)->ZNQ_ENTITY)))
            (cAliasZNQ)->(dbSkip())        
        enddo
        (cAliasZNQ)->(dbCloseArea())
        
        for nInd := 1 to len(aDirPend)

            if aDirPend[nInd][1] <> '.' .and. aDirPend[nInd][1] <> '..'
                if aDirPend[nInd][5] == "D"
                    aadd(self:aEntities, capital(alltrim(aDirPend[nInd][1])))
                endif

            endif
        next
    endif
return self:aEntities


user function sfgetact()
return

