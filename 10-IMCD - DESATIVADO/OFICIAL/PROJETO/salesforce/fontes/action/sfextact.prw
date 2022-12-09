#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SFEXTACT
Classe de action utilizada para a extra��o de dados para o Sales Force
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFEXTACT


    method new() constructor
    method extract()
    method writeFile()
    method destroy()

    data oSfUtil    as object //objeto utils 
    data cViewName  as string //prefixo da view a ser utilizada
    data lJob       as boolean//indica se o processamento � via job
    data lEnd       as boolean//flag de cancelamento
    data cTableName as string //C�digo da tabela principal
    data cArquivo   as string //Arquivo a ser extraido
    data cSFJob     as string //job que est� sendo processado
endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
M�todo construtor
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   cViewName, character, prefixo da view
@return  object, self
/*/
//-------------------------------------------------------------------
method new(cViewName,cSFJob,lJob, lEnd) class SFEXTACT

    default lJob := .T.
    //------------------------------------
    //Inicializa��o dos atributos
    //------------------------------------
    self:oSfUtil := SFUTILS():new()
    self:cViewName := cViewName
    self:cTableName := substr(self:cViewName,1,3)
    self:lJob      := lJob
    self:lEnd      := lEnd
    self:cSFJob    := cSFJob
return

//-------------------------------------------------------------------
/*/{Protheus.doc} extract
Extra��o de dados e retorna um model.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
@param   dDataIni, date, data inicial de extra��o
@param   dDataFim, date, data final de extra��o
@param   lOkProc , boolean, processamento realizado com sucesso?
@param   cMsgErro, character, mensagem de erro
@param   lUseMsExp,character, usa o campo MSEXP da tabela como par�metro de extra��o
@return  object, model 
/*/
//-------------------------------------------------------------------
method extract(dDataIni, dDataFim,lOkProc,lUseMsExp,cMsgErro) class SFEXTACT
    local oSfDao as object     //Objeto DAO (data access object)
    local oSfMod as object     //Objeto Model
    local aLogSet as array     //array de dataset para a grava��o da tabela de logs ZNP
    local oSfLog as object     //objeto para grava��o das tabelas ZNO e ZNP (logs)


    default dDataFim := stod("")


    //Inicializa��o de vari�vel
    aLogSet := {}


    //---------------------------
    //Inst�ncia do DAO
    //---------------------------
    oSfDao := SFGENDAO():new(self:cViewName,self:cTableName, aLogSet, self:lJob, self:lEnd)

    //-------------------------------------------
    //Extra��o de dados utilizando o campo MSEXP
    //-------------------------------------------
    if lUseMsExp
        oSfMod := oSfDao:getByMsExp(@lOkProc, @cMsgErro)
    else
        //----------------------------------------------------------
        //Caso n�o esteja preenchido a data final de processameto,
        //utilizar o processamento por data, utilizando a data
        //inicial de processamento.
        //----------------------------------------------------------
        if empty(dDataFim)
            oSfMod := oSfDao:getByDay(dDataIni,@lOkProc, @cMsgErro)
        else
            //--------------------------------------------------------------
            //Caso esteja preenchido a data inicial/final de processameto,
            //utilizar o processamento de intervalo de datas 
            //--------------------------------------------------------------
            oSfMod := oSfDao:getBtDates(dDataIni,dDataFim,@lOkProc, @cMsgErro)
        endif
    endif


    if lOkProc
        //------------------------------
        //Realiza a grava��o do arquivo
        //na pasta de pendentes de envio
        //via FTP/SFTP
        //------------------------------
        if lOkProc := self:writeFile(oSfMod, @cMsgErro)
        
            //----------------------------------
            //Realiza a grava��o do LOG ZNO/ZNP
            //----------------------------------
            oSfLog  := SFLOGWRT():new(self:cTableName , self:cArquivo)
            oSfLog:writeLine (aLogSet)
            oSfLog:save() 
            //----------------------------------------------------------
            //Realiza o update da flag MSEXP da tabela correspondente
            //----------------------------------------------------------
            oSfLog:updMSExp(cMsgErro)
            oSfLog:destroy()
            freeObj(oSfLog)
        ENDIF


        
    endif
    //Limpeza de array e objeto
    aSize(aLogSet,0)

    //-----------------------------------
    //Limpa a inst�ncia do objeto criado
    //-----------------------------------
    freeObj(oSfDao)
    freeObj(oSfMod)


return 

//-------------------------------------------------------------------
/*/{Protheus.doc} writeFile
Realiza a escrita do arquivo a ser exportado.
@author  marcio.katsumata
@since   10/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method writeFile(oSfMod,cMsgErro) class SFEXTACT
    local oSfLyBuild as object    //Objeto layout builder, respons�vel pela grava��o do arquivo 
    local cPath      as character //Caminho do arquivo a ser gravado
    local aDataSet   as character //Dados da linha a ser gravada
    local lRet       as logical   //Retorno da grava��o. Sucesso? 
    local nIndLine   as numeric   //Indice da linha
    local nTotLine   as numeric   //N�mero total de registros 
    local cProcesso  as character //Processo. Accounts/Orders/Products 
    local cAccountTp as character
    //-------------------------------
    //Inicializando vari�veis
    //--------------------------------
    nIndLine := 1
    lRet  := .T.
    cProcesso := substr(self:cSFJob,1,at("_",self:cSFJob)-1)
    cProcesso := iif ("ORDER"$cProcesso, "Orders", capital(cProcesso))  
    cPath := self:oSfUtil:expPendPrc(cProcesso)
    cAccountTp := iif("SA1" $self:cViewName, "_AR", iif("SA2" $self:cViewName , "_AP", iif("SA4" $self:cViewName , "_AC","")))
    //Montagem do nome do arquivo a ser exportado
    self:cArquivo := substr(self:cViewName,5,len(self:cViewName))+cAccountTp+"_"+fwtimestamp(1,date(),time())+".csv"
    //Inst�ncia do layout builder, objeto respons�vel pela grava��o do arquivo
    oSfLyBuild := SFLYBUILD():new(cPath, self:cArquivo, @cMsgErro, @lRet)
    //Dataset para a grava��o do arquivo
    aDataSet := aClone(oSfMod:getDataSet())

    if lRet
        //-----------------------------------------
        //Realiza a escrita do cabe�alho do arquivo
        //-----------------------------------------
        oSfLyBuild:wrtContent(oSfMod:getStruct())

        //------------------------------------------
        //Realiza a escrita dos itens do arquivo
        //------------------------------------------
        nTotLine := len(aDataSet) 
        while nIndLine <= nTotLine .and. lRet
            lRet:= oSfLyBuild:wrtContent(aDataSet[nIndLine])
            nIndLine++
        endDo

        oSfLyBuild:saveFile()    

        //----------------------------------------
        //Se existir erro na grava��o do arquivo,
        //apaga ele e grava no log
        //----------------------------------------
        if !lRet
            FErase(cPath+"\"+self:cArquivo)
            cMsgErro := "Erro na gera��o do arquivo"
        endif
    endif
    
    //-------------------------------------
    //Realizando limpeza do objeto e array
    //-------------------------------------
    oSfMod:destroy()
    aSize(aDataSet,0)

return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Realiza a limpeza de objetos
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class SFEXTACT
    freeObJ(self:oSfUtil)
return

user function sfextact()
return