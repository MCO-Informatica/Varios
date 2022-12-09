#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} SFIMPACT
Classe action utilizada para importação de arquivos do sales force
@author  marcio.katsumata
@since   19/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFIMPACT

    method new() constructor
    method import()
    method selFiles()
    method setRegStatus()
    method readFile()
    method destroy()

    data oSfUtil   as object
    data lJob      as logical 
    data aImporting as array
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
method new(lJob, lEnd) class SFIMPACT

    default lJob := .T.
    //------------------------------------
    //Inicialização dos atributos
    //------------------------------------
    self:oSfUtil := SFUTILS():new()
    self:lJob      := lJob
    self:lEnd      := lEnd
    
return

//-------------------------------------------------------------------
/*/{Protheus.doc} import
Método responsável pela importação dos arquivos retornados do Sales
Force. Este método realiza a leitura dos arquivos que se encontram
na pasta sffiles/imp/pending, grava na tabela de logs ZNO/ZNP e 
em seguida move os arquivos para a pasta sffiles/imp/readed.
@author  marcio.katsumata
@since   23/07/2019
@version 1.0
@param   lOk,  boolean, status do processamento
@param   cMsgErro, character, mensagem de erro
/*/
//-------------------------------------------------------------------
method import(lOk,cMsgErro,lSFNewReg) class SFIMPACT
    local oSfSFTP as object
    local nIndImp as numeric
    local nInsSta as numeric
    local cStatus as character
    local cEmpSF as character
    local nIndSta as numeric

    default lSFNewReg := .F.
    //---------------------------------------------------
    //Inicializando variáveis
    //---------------------------------------------------
    cEmpSF   := "69"+PADR(cValToChar(val(cEmpAnt)),3,"0") // Código da empresa SF.
    cMsgErro := ""
    lSeekOk  := .T.
    lOk      := .T.
    //---------------------------------------
    //Realiza a leitura dos diretórios pending
    //para montar o array aImporting com os
    //arquivos pendentes de importação
    //----------------------------------------
    if self:selFiles(cEmpSF)

        for nIndImp := 1 to len (self:aImporting)
            //----------------------------------------------
            //Realiza a validação para verificar se existem
            //as pastas Success e Error para prosseguir com o 
            //processamento
            //----------------------------------------------
            if len(self:aImporting[nIndImp]) >= 2
                //---------------------------------------------
                //Navega entre as pastas success e error
                //---------------------------------------------
                for nIndSta := 2 to len(self:aImporting[nIndImp])
                    //-----------------------------------------------
                    //Verifica se existem arquivos na pasta corrente
                    //para prosseguir
                    //------------------------------------------------
                     if !empty(self:aImporting[nIndImp][nIndSta][2])
                        //Definindo o status
                        cStatus := iif(capital(alltrim(self:aImporting[nIndImp][nIndSta][1])) == "Success", "2", "3")
                        self:setRegStatus(self:aImporting[nIndImp][nIndSta][2], cStatus)
                    endif

                next nIndSta
            endif
                
        next nIndImp

        //Limpeza do array
        aSize(self:aImporting, 0)

    endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} setRegStatus
Realiza a troca de status das tabela ZNO/ZNP de acordo com o
arquivo importado.
@author  marcio.katsumata
@since   22/07/2019
@version 1.0
@param   aFiles, array, vetor de arquivos
@param   cStatus, character, status que deve ser gravado no LOG.
@return  nil, nil
/*/
//-------------------------------------------------------------------
method setRegStatus(aFiles, cStatus) class SFIMPACT
    local nIndFil as numeric
    local nIndLido as numeric
    local nPosChv  as numeric
    local aLido   as array
    local aDataSet as array
    local lSeekOk as logical
    local cChvSF  as character
    local cChave  as character
    local oLogWrt as object
    local cFile   as character
    local nQtdLido as numeric
    local aChvSf  as array
    local lXml    as logical


    nQtdLido := 0
    lSeekOk := .F.
    aChvSf   := {}
    //-------------------------------------------------------
    //Realiza a leitura dos arquivos
    //-------------------------------------------------------
    for nIndFil := 1 to len(aFiles)

        lXml := ".xml" $ aFiles[nIndFil][1] 
        if !lXml
        
            cFile := strtran(lower(aFiles[nIndFil][1]),"_upserted.csv","")
            cFile := strtran(lower(cFile),"_rejected.csv","")
            //---------------------------------------------------------
            //Instancia objeto de gravação de log na tabela ZNO/ZNP
            //Realiza a procura do registro pelo nome do arquivo
            //---------------------------------------------------------
            oLogWrt   := SFLOGWRT():new(,cFile,,@lSeekOk, .F.)
            
            //-------------------------------------------------------------
            //Caso a procura do registro no método construtor 
            //tenha encontrado o registro na ZNO através do nome do arquivo
            //prossegue com o processamento.
            //--------------------------------------------------------------
            if lSeekOk


                //Leitura do arquivo
                aLido := self:readFile(aFiles[nIndFil][2])

                if !empty(aLido)
                    //-------------------------------------------------------------------------------------------
                    //Chave de procura registro do arquivo x log de registros(tabela ZNP)
                    //-------------------------------------------------------------------------------------------
                    //cChvSF    := alltrim(FWGetSX5 ("Z7", PADR(oLogWrt:getTable() , tamSx3("X5_CHAVE")[1]))[1][4]) 
                    aSX5Z7 := FWGetSX5("Z7")
                    
                    if "|" $ cChvSf
                        aChvSf := StrTokArr2(cChvSF,"|", .F.) 
                        if len(aChvSf) == 2
                            if cStatus == '2'
                                cChvSF := aChvSF[1]
                            else
                                cChvSF := aChvSF[2]
                            endif
                        endif
                    endif

                    nPosChv   := aScan(aLido[1], {|cColumn| upper(alltrim(cColumn)) == upper(alltrim(cChvSF))})

                    if nPosChv == 0
                        cChvSF := strtran(cChvSF,"__C", "")
                        nPosChv   := aScan(aLido[1], {|cColumn| upper(alltrim(cColumn)) == upper(alltrim(cChvSF))})
                    endif
                    //------------------------------------------------------------
                    //Gravando a mudança de status na tabela ZNP(Itens do arquivo)
                    //------------------------------------------------------------
                    nQtdLido := len(aLido)
                    for nIndLido := 2 to nQtdLido
                        if len(aLido[nIndLido]) >= nPosChv
                            cChave  := aLido[nIndLido][nPosChv]  
                            if  cStatus == '2'  
                                aDataSet := {{"ZNP_STATUS", cStatus}}
                            else
                                aDataSet := {{"ZNP_STATUS", cStatus},{"ZNP_MSGPRC", aLido[nIndLido][len(aLido[nIndLido])-1]+" : "+aLido[nIndLido][len(aLido[nIndLido])]}}
                            endif

                            oLogWrt:writeLine(aDataSet, .T., cChave)
                            aSize(aDataSet,0)
                        endif
                    next nIndLido


                    //-----------------------------------------------------------------
                    //Checagem de pendências e erros para atualizar o cabeçalho do log
                    //-----------------------------------------------------------------
                    lErroProc := oLogWrt:isStatusL("3")
                    lPendente := oLogWrt:isStatusL("1")

                    cStatusH := iif (lPendente, "3", iif(lErroProc, "5", "4"))

                    oLogWrt:updateHead({{"ZNO_STATUS", cStatusH}, {"ZNO_RCDATE", date()}, {"ZNO_RCHOUR", time()}})
                    //---------------
                    //Salvando o LOG
                    //---------------
                    oLogWrt:save()

                    //----------------------------------------------
                    //Move o arquivo processado para a pasta readed
                    //----------------------------------------------
                    __copyfile(aFiles[nIndFil][2], aFiles[nIndFil][3])
                    FErase(aFiles[nIndFil][2])
                    aSize(aLido,0)   
                endif
            
            endif
        endif

        freeObj(oLogWrt)
     
    next nIndFil

return 

//-------------------------------------------------------------------
/*/{Protheus.doc} readFile
Realiza a leitura do arquivo
@author  marcio.katsumata
@since   22/07/2019
@version 1.0
@param   cFile, character, arquivo
@return  array, conteudo lido.
/*/
//-------------------------------------------------------------------
method readFile(cFile) class SFIMPACT
    local cLineRead as character
    local aAux      as array
    local aLido     as array
    Local oTxtFile  as object

    aLido := {}
    aAux  := {}

    oTxtFile := SFFILEREADER():New(cFile)
    If !oTxtFile:Open()
      Return
    Endif

    While oTxtFile:ReadLine(@cLineRead)
        if !empty(cLineRead)
            aAux := StrTokArr2(cLineRead,"|", .T.)
            aadd(aLido, aClone(aAux))
        endif
        aSize(aAux,0)
    Enddo

    oTxtFile:Close()

    freeObj(oTxtFile)
return aLido



//-------------------------------------------------------------------
/*/{Protheus.doc} selFiles
Seleciona os arquivos do diretório success e error de cada entidade
@author  marcio.katsumata
@since   22/07/2019
@version 1.0
@return  boolean, existe arquivo para leitura? .T. = Sim, .F. = Não
/*/
//-------------------------------------------------------------------
method selFiles(cEmpSF) class SFIMPACT

    local aDirPend as array      //Lista de diretórios da pasta pending
    local cPath    as character  //Caminho da pasta pending
    local cRootPath as character //RootPath do Protheus
    local aDirAux   as array     //Diretório auxiliar para naveção entre as pastas do diretório pending
    local nInd      as numeric   //Indice 
    local nInd2     as numeric   //Indice  
    local lOk       as logical   //Retorno de sucesso   
    local cReaded     as character //Diretório da pasta de arquivos enviados.  
    local cImpAuto  as character //Pastas que contem arquivos para a importação automatica.
    local nIndSta   as numeric
    //--------------------------------------------
    //Inicialização de variáveis
    //--------------------------------------------
    cRootPath := GetSrvProfString ("ROOTPATH","")
    aDirAux  := {}
    aDirPend := {}
    self:aImporting := {}
    lOk      := .F.
    cReaded    := ""
    cDestiny := self:oSfUtil:getImpRead() 
    cPath    := self:oSfUtil:getImpPend()
    aStatus  := {"Success", "Error"}
    cImpAuto := superGetMv("ES_XSFIMAT",.F.,"QUOTE/")
    aDirPend := Directory(cPath+"\*.*","D")

    for nInd := 1 to len(aDirPend)

        if aDirPend[nInd][1] <> '.' .and. aDirPend[nInd][1] <> '..' .and. !(aDirPend[nInd][1] $ cImpAuto)

            //-------------------------------------------------------------------
            //Verifica se existem arquivos nos subdiretórios da pasta pendentes.
            //-------------------------------------------------------------------
            cPathAux := cPath+"\"+aDirPend[nInd][1]

            //-------------------------------
            //Realiza a inserção da entidade
            //no array de arquivos
            //-------------------------------
            //Estrtura do array
            //- Accounts (Entidade)
            //  -Success
            //  -Arquivos do Success
            //      -Nome do arquivo
            //      -Caminho origem (onde o arquivo se encontra)
            //      -Caminho destino (onde o arquivo deve ser movido após o processamento)
            //  -Error
            //  -Arquivos do Error
            //      -Nome do arquivo
            //      -Caminho origem (onde o arquivo se encontra)
            //      -Caminho destino (onde o arquivo deve ser movido após o processamento)
            //--------------------------------------------------------------------------------
            aadd(self:aImporting,{} )
            nPos:= len(self:aImporting)
            aadd(self:aImporting[nPos],capital(aDirPend[nInd][1]))
            

            //Navega entre as pastas Success e Error
            for nIndSta := 1 to len(aStatus)
                //Limpeza do array auxiliar
                aSize(aDirAux,0)

                //--------------------------------------------------
                //Realiza a inserção do status "Success" ou "Error"
                //dentro do array de arquivos
                //--------------------------------------------------
                aadd(self:aImporting[nPos],{})
                nPosSta := len(self:aImporting[nPos])
                aadd(self:aImporting[nPos][nPosSta], aStatus[nIndSta])
                aadd(self:aImporting[nPos][nPosSta],{})

                //Verifica o diretório de arquivos pendentes por tipo de arquivo
                cReaded := self:oSfUtil:impReadPrc (lower(alltrim(aDirPend[nInd][1])), aStatus[nIndSta])

                //Realiza a verificação de arquivos dentro do diretorio 
                aDirAux  := directory(cPathAux+"\"+aStatus[nIndSta]+"\*.*")

                //Se existir arquivos no subdiretório armazena-los no array de arquivos a enviar
                for nInd2 :=1 to len(aDirAux)
                    if aDirAux[nInd2][1] <> '.' .and. aDirAux[nInd2][1] <> '..'
                        if cEmpSF $ aDirAux[nInd2][1]
                            aadd(self:aImporting[nPos][nPosSta][2], {aDirAux[nInd2][1], cPathAux+"\"+aStatus[nIndSta]+"\"+aDirAux[nInd2][1], cReaded+"\"+aDirAux[nInd2][1]})    
                            lOk := .T.
                        endif
                    endif
                next nInd2
            next nIndSta
        endif
    next nInd


return lOk


method destroy() class SFIMPACT
    freeObj(self:oSfUtil)
return

user function sfimpact()

return
