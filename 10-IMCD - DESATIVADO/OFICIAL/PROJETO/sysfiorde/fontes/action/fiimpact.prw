#include 'protheus.ch'
#include 'json.ch'
#INCLUDE 'FWMVCDEF.CH'
//-------------------------------------------------------------------
/*/{Protheus.doc} FIIMPACT
Classe de action utilizada para a extração de dados para o FIORDE
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class FIIMPACT
    method new()constructor
    method process()
    method import()
    method selFiles()
    method execLay()
    method destroy()
    method readFile()
    method validFile()

    data oSysFiUtl   as object //objeto utils 
    data lJob        as boolean//indica se o processamento é via job
    data lEnd        as boolean//flag de cancelamento
    data aImporting  as array  //array de arquivos a serem enviados via FTP
    data cFIJOB      as string //nome do job 
    data aFiliais    as array  //vetor 
    data lResult     as boolean //importa apenas os resultados
endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@param   cFIJob, character, nome do JOB que está sendo executada.
@param   lJob, boolean, indica a rotina está sendo executada por job
@param   lEnd, boolean, flag de cancelamento do processo.
@param   aImporting, array, arquivos a serem importados.
@param   lResult, boolean, realiza processamento do resultado
@return  object, self
/*/
//-------------------------------------------------------------------
method new(cFIJob, lJob, lEnd,aImporting, lResult) class FIIMPACT

    default lJob  := .T.
    default aImporting := {}
    default lResult := .F.
    //------------------------------------
    //Inicialização dos atributos
    //------------------------------------
    self:oSysFiUtl := SYSFIUTL():new()
    self:lJob      := lJob
    self:lEnd      := lEnd
    self:cFIJob    := cFIJob
    self:aImporting := aClone(aImporting)
    self:lResult   := lResult

    aSize(aImporting,0)
    //-------------------------------
    //Filiais da empresa logada
    //Retorna codigo da filial e CNPJ
    //--------------------------------
    self:aFiliais  := self:oSysFiUtl:getFilCnpj()


return

//-------------------------------------------------------------------
/*/{Protheus.doc} process
Importação dos arquivos que estão na pasta pending
@author  marcio.katsumata
@since   02/09/2019
@version 1.0
@param   cMsgErro, character, mensagem de erro
/*/
//-------------------------------------------------------------------
method process(lRetProc) class FIIMPACT

    local nIndImp as numeric
    local nInsSta as numeric
    local cStatus as character
    local lProcessa as logical
    local nIndSta   as numeric
    local nIndOrd   as array
    local aOrdem     as array     //Ordenação da importação de arquivos
    private cCnpjs as character
    private cPasta as character
    default lRetProc := .T.

    lProcessa := .F.
    //---------------------------------------------------
    //Inicializando variáveis
    //---------------------------------------------------
    cCnpjs   := ""
    aOrdem      := {"epo", "edi", "rli", "rft", "rlt", "rbo", "rnm", "rdi", "rcb","rnd" }

    //------------------------------------------------------
    //Verificando os CNPJ´s das filiais da empresa corrente
    //------------------------------------------------------
    aEval(self:aFiliais, {|aFilial| cCnpjs +=aFilial[2]+"/"})
    
    cCnpjs := substr(cCnpjs,1,len(cCnpjs)-1)
    
    //-----------------------------------------------------------------------------
    //Verifica se o vetor aImporting está preenchido(processamento manual)
    //caso não esteja preenchido aciona o método selFiles(processamento automatico)
    //------------------------------------------------------------------------------
    lProcessa := !empty(self:aImporting) .or. self:selFiles(cCnpjs)

    //---------------------------------------
    //Realiza a leitura dos diretórios pending
    //para montar o array aImporting com os
    //arquivos pendentes de importação
    //----------------------------------------
    if lProcessa

        for nIndOrd := 1 to len (aOrdem)
            cPasta :=  aOrdem[nIndOrd] 
            nIndImp := aScan (self:aImporting, {|aPasta| lower(aPasta[1]) == cPasta })
            //----------------------------------------------
            //Realiza a validação para verificar se existem
            //as pastas Success e Error para prosseguir com o 
            //processamento
            //----------------------------------------------
            if nIndImp > 0 .and. len(self:aImporting[nIndImp]) >= 1
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
                        cStatus := iif(lower(alltrim(self:aImporting[nIndImp][nIndSta][1])) == "success", "2", iif(lower(alltrim(self:aImporting[nIndImp][nIndSta][1])) == "error","3","4") )
                        lRetProc := self:import(self:aImporting[nIndImp][nIndSta][2], self:aImporting[nIndImp][1], cStatus)

                    endif

                next nIndSta
            endif
                
        next nIndImp

        //Limpeza do array
        aSize(self:aImporting, 0)

    endif
return

//-------------------------------------------------------------------
/*/{Protheus.doc} import
Realiza a importação do arquivo
@author  marcio.katsumata
@since   05/09/2019
@version 1.0
@param   aFiles, array, arquivos a serem processados
@param   cType , character, tipo do arquivo (entidade)
@param   cStatus, character, status (success, error ou um novo registro)
/*/
//-------------------------------------------------------------------
method import (aFiles,cType,cStatus) class FIIMPACT
    local lFileOk    as logical   //Leitura do arquivo OK
    local nInd       as numeric   //Indice     
    local oFiLogWrt  as object    //Objeto de gravação da tabela de log ZNT    
    local aStrFile   as array     //Vetor com as informações do arquivo 
    local aLogSet    as array     //Vetor com as informações serem gravados na tabela ZNT     
    local cErrorFile as character //Retorno de erros dos processos EDI/EPO retornados pela SYSFIORDE
    local cErrorExec as character //Retorno de erros na rotina de gravação de dados
    local aConteudo  as array     //Conteudo retorna pela leitura do arquivo 
    local lSeekOk    as logical   //Achou o registro na tabela ZNT? 
    local cMsgErro   as character //Mensagem de erro
    local cResult    as character //Resultado da gravação
    local lMantem    as logical   //Verifica se mantem intacto o arquivo no local de origem para posterior reintegraão.
    local cRetFile   as character //Conteúdo de retorno para a fiorde.
    local lStruFile  as logical   //Verifica a estrutura do nome do arquivo
    local cFileLog   as character //Arquivo do log
    local lSendArq   as logical   //Envia arquivos de retorno para a fiorde.



    //--------------------------
    //Inicialização de variáveis
    //--------------------------
    aStrFile    := {}
    aLogSet     := {}
    aConteudo   := {}
    lSeekOk     := .F.
    cErrorFile  := ""
    cErrorExec  := ""
    cMsgErro    := ""
    cResult     := ""
    lMantem     := .F.
    lOk         := .F.
    cRetFile    := ""
    lStruFile   := .F.
    lSendArq    := .T.

    for nInd := 1 to len(aFiles)
        lSeekOk     := .F.
        cErrorFile  := ""
        cErrorExec  := ""
        cMsgErro    := ""
        //-----------------------------------------------
        //Processamento de arquivo EDI/EPO
        //-----------------------------------------------
        if cStatus == '2' .or. cStatus == '3'

            cFileLog := strtran(aFiles[nInd][1], ".txt_success", "")
            cFileLog := strtran(cFileLog, ".txt_error", "")
            
            oFiLogWrt := FILOGWRT():new(cFileLog,.F.,cType,aFiles[nInd][4], @lSeekOk,@cMsgErro)
            
            aadd(aLogSet, {"ZNT_STATUS", cStatus})

            if cStatus=='3'
                cErrorFile := memoread(aFiles[nInd][2])
                aadd(aLogSet, {"ZNT_MSGERR", cErrorFile})
            endif
            lStruFile := .T.
            lSendArq  := .F.
            lOk       := .T.
        else
            //------------------------------------------------
            //Processamento de arquivos gerados pelo SYSFIORDE
            //------------------------------------------------
            //Verifica a estrutura do arquivo para resgatar 
            //informações de CNPJ e numero PO
            //------------------------------------------------
            aStrFile := Strtokarr2( aFiles[nInd][1], "_", .T.)

            //---------------------------------------------------
            //Verifica através do CNPJ qual a filial do arquivo
            //---------------------------------------------------
            nPosFil := aScan(self:aFiliais, {|aFilial| aFilial[2] == alltrim(aStrFile[2])})
            
            if (lStruFile := nPosFil > 0 .and. len(aStrFile) >= 4)
                //-----------------------------------
                //Instância da classe que grava a ZNT
                //-----------------------------------
                oFiLogWrt := FILOGWRT():new(aFiles[nInd][1],.F.,cType,self:aFiliais[nPosFil][1], @lSeekOk,@cMsgErro)
                
                //------------------------------
                //Realiza a leitura do arquivo
                //------------------------------
                aConteudo := self:readFile(aFiles[nInd][2])
                lOk :=  !empty(aConteudo)

                if lOk

                    //-----------------------------
                    //Realiza a gravação de dados
                    //-----------------------------
                    lOk := self:execLay(cType, aConteudo,self:aFiliais[nPosFil][1], lower(aFiles[nInd][1]), @cErrorExec, @cErrorFile, @lMantem, @cRetFile, lower(aFiles[nInd][2]))

                    aSize(aConteudo,0)
                else
                    cErrorExec += "Erro na leitura do arquivo"+CRLF
                    lMantem    := .T.
                endif    

                aadd(aLogSet,{"ZNT_NUMPO", alltrim(upper(aStrFile[3]))})
                aadd(aLogSet,{"ZNT_ETAPA", cType}  )
                aadd(aLogSet,{"ZNT_STATUS", iif(lOk,"2", "3")})
                aadd(aLogSet,{"ZNT_FILE", aFiles[nInd][1]} )

                if !lOk
                    aadd(aLogSet,{"ZNT_MSGERR", cErrorExec} )
                    cResult := "error"
                else
                    cResult := "success"
                endif

            endif    
            lSendArq    := .T.    
            aSize(aStrFile,0)     
        endif

        if lStruFile     
            aadd(aLogSet,{"ZNT_RCDATE", date()})
            aadd(aLogSet,{"ZNT_RCHOUR", time()})

            if (lSeekOk .and.(cStatus == '2' .or. cStatus == '3') ) .or. (!(cStatus $ "2/3"))

                //--------------------------
                //Grava o log na tabela ZNT
                //--------------------------
                oFiLogWrt:update(aLogSet)
                if self:lJob
                    oFiLogWrt:destroy()
                endif
                if !lMantem .and. (self:lJob .or. lOk)
                    //----------------------------------------------------------
                    //Gravação do retorno ao SYSFIORDE    
                    //----------------------------------------------------------
                    if lSendArq
                        cPathDest := self:oSysFiUtl:expPendPrc(lower(cType), cResult)
                        memowrite(cPathDest+"\"+lower(aFiles[nInd][1])+"_"+cResult+".txt",iif(cResult=='success', cRetFile,cErrorFile))
                    endif       
                    //----------------------------------------
                    //Move os arquivos de pending para readed
                    //----------------------------------------
                    __copyFile(aFiles[nInd][2],aFiles[nInd][3])
                    FErase(aFiles[nInd][2]) 
                endif   
            endif
        endif
        


        freeObj(oFiLogWrt)
        aSize(aLogSet,0)

    next nInd

return lOk
//-------------------------------------------------------------------
/*/{Protheus.doc} execLay
Realiza a checagem de layout, monta o arquivo JSON e chama a rotina
responsável pela gravação dos dados.
@author  marcio.katsumata
@since   05/09/2019
@version 1.0
@param   cType, character, tipo de arquivos
@param   aHeader, array, cabeçalho
@param   aDados, array, dados do arquivo
@param   cFilProc, character, filial do arquivo
@param   cErroExec, character, erro de execução
@param   cFileName, character, nome do arquivo
@param   lMantem  , logical, verifica se mantem o arquivo no local origem e não grava log.
@return  boolean, executado com sucesso?
/*/
//-------------------------------------------------------------------

method execLay(cType,aConteudo,cFilProc,cFileName, cErroExec, cErrorFile, lMantem, cRetFile, cCompPth) class FIIMPACT

    local oModelLy   as object  //Objeto da classe model da tabela ZNU(layout)
    local aHeadAux   as array   //Vetor de cabeçalho auxiliar
    local oJson      as object  //Json Object
    local oJsonAux   as object  //Json Object auxiliar 
    local nTamDados  as numeric //Tamanho do array de dados 
    local nTamZNQ    as numeric //Tamanho da grid ZNU
    local nInd       as numeric //Indice
    local lRet       as logical //Retorno da função
    local lPadrao    as logical //Utiliza o padrão para importar arquivo
    local lHeader    as logical //O arquivo utiliza cabeçalho
    local aHeader    as array     //Informações do cabeçalho do  arquivo
    local aDados     as array     //Informações de dados 
    local nIndLine
    local nStart     as numeric
    local cColCsv    as character //Nome coluna no arquivo CSV
    private xValue                //Valor da coluna
    private cExecAut as character //Rotina de gravação de dados a ser macroexecutada

    //--------------------------
    //Inicialização de variáveis
    //--------------------------
    aHeadAux := {}
    lRet     := .T.
    nIndLine := 1
    aHeader  := {}
    aDados   := {}
    nStart   := 1
    //------------------------------
    //Posiciona no layout tabela ZNU
    //------------------------------
    ZNU->(dbSetOrder(1))
    if ZNU->(dbSeek(xFilial("ZNU")+padr(cType, tamSx3("ZNU_ENTITY")[1])))

            
        //--------------------------------------------
        //Prepara o model da tabela ZNU para consulta
        //--------------------------------------------
        oModelLy := FWLoadModel("FILAYMOD")
        oModelLy:setOperation(MODEL_OPERATION_VIEW)
        oModelLy:activate()

        //------------------------------
        //Verifica a rotina de gravação
        //------------------------------
        cExecAut := alltrim(oModelLy:getValue("ZNUMASTER", "ZNU_EXEAUT") )
        lPadrao  := alltrim(oModelLy:getValue("ZNUMASTER", "ZNU_PADRAO") ) == 'S'
        lHeader  := alltrim(oModelLy:getValue("ZNUMASTER", "ZNU_HEADER") ) == 'S'
        
        //-------------------------------------------------
        //Caso o arquivo possua cabeçalho em sua estrutura
        //-------------------------------------------------
        if lHeader
            aHeader := aClone(aConteudo[1])
            nStart  := 2
        endif    

        for nIndLine := nStart to len(aConteudo)
            aadd(aDados, aClone(aConteudo[nIndLine]) )
        next nIndLine
        
        

        //--------------------------------------------------------
        //Prepara JSON e executa a rotina de gravação de dados
        //que não utilizam o padrão para a ação.
        //---------------------------------------------------------   
        if !empty(cExecAut) .and. !lPadrao .and. !empty(aDados)

            oJson    := JsonBld():new()
            oJson[#'arquivo']  := cFileName
            oJson[#'conteudo'] := {}
            //------------------------------------------------
            //Verifica a quantidade de registros da tabela ZNQ 
            //referente à entidade posicionada
            //------------------------------------------------
            nTamZNQ := oModelLy:getModel("ZNUDETAIL"):Length()
            
            for nInd:= 1 to nTamZNQ 
                oModelLy:getModel("ZNUDETAIL"):goLine(nInd)
                //-------------------------------------------------
                //Caso o arquivo possua cabeçalho em sua estrutura
                //Verifica a posição de cada informação dentro do
                //arquivo, pois pode ser que ela não esteja na 
                //ordem do layout da documentação.
                //-------------------------------------------------
                if lHeader
                    nPosH := aScan (aHeader,{|cColumn| alltrim(upper(cColumn)) == alltrim(oModelLy:getValue("ZNUDETAIL", "ZNU_CMPFI"))})
                    
                    if nPosH > 0
                        aadd(aHeadAux, {alltrim(aHeader[nPosH]), nPosH, alltrim(oModelLy:getValue("ZNUDETAIL", "ZNU_CMPPRT"))})
                    endif
                else
                //-------------------------------------------------------
                //Caso o arquivo não possua o cabeçalho deve se seguir
                //a estrutura do layout da documentação
                //-------------------------------------------------------
                    aadd(aHeadAux, {alltrim(oModelLy:getValue("ZNUDETAIL", "ZNU_CMPFI")), nInd, alltrim(oModelLy:getValue("ZNUDETAIL", "ZNU_CMPPRT"))})
                endif
            next nInd

            //----------------------------------------------
            //Realiza a checagem da quantidade de colunas
            //layout x arquivo
            //----------------------------------------------
            if (lHeader .and. len(aHeadAux) == nTamZNQ) .or. (!lHeader .and. len(aDados[1]) == nTamZNQ)
                aSize(aHeader,0)

                nTamDados := len(aDados)
                nIndLine  := 1
                //------------------------------------------------------
                //Gera o arquivo JSON de cada linha do arquivo integrado
                //------------------------------------------------------
                while nIndLine <= nTamDados .and. lRet
                    oJsonAux := JsonBld():new()

                    nInd := 1 

                    //-----------------------------------------------------------
                    //Normaliza dados e executa formulas do layout antes da 
                    //geração do JSON
                    //------------------------------------------------------------
                    while nInd <= nTamZNQ .and. lRet

                        oModelLy:getModel("ZNUDETAIL"):goLine(nInd)
                        xValue  := alltrim(STRTRAN(aDados[nIndLine][aHeadAux[nInd][2]],'"',''))
                        cForm   := alltrim(oModelLy:getValue("ZNUDETAIL", "ZNU_FORM1"))
                        cColumn := alltrim(oModelLy:getValue("ZNUDETAIL", "ZNU_CMPPRT"))
                        cValid  := alltrim(oModelLy:getValue("ZNUDETAIL", "ZNU_CONDIC")) 
                        cColCsv := alltrim(oModelLy:getValue("ZNUDETAIL", "ZNU_CMPFI"))
                        //--------------------------------------------------
                        //Aplica a função que está dentro do campo ZNU_FORM1
                        //--------------------------------------------------
                        if !empty(cForm) 
                            xValue := &(cForm)
                        endif


                        //--------------------------------------
                        //Realiza validação informada no campo
                        //--------------------------------------
                        if !empty(cValid) 
                            if ! &(cValid)
                                cErroExec += cErrorFile+="Erro na validação do campo: "+cColCsv+" linha:"+alltrim(cValToChar(nIndLine))+". Verifique se o campo está preenchido corretamente."+ CRLF
                                lRet := .F.
                                lMantem := .F.
                                loop
                            endif
                        endif
                            
                        //--------------------------------
                        //Atribui o valor no atributo JSON
                        //--------------------------------   
                        oJsonAux[#cColumn] := xValue
                        nInd++
                    enddo

                    aadd(oJson[#'conteudo'] ,oJsonAux)

                    nIndLine++
                enddo
                if lRet 
                    //-------------------------------------------
                    //Realiza a execução da gravação dos dados
                    //--------------------------------------------
                    aRetFunc  := &cExecAut.(oJson, aHeadAux,cFilProc,cErroExec, cErrorFile)
                    lRet      := aRetFunc[1]
                    cErroExec := aRetFunc[2]
                    cErrorFile:= aRetFunc[3]
                    lMantem   := aRetFunc[4]
                endif    
            else
                cErroExec += "Quantidade de colunas incorreta , verifique o arquivo." +CRLF
                lRet      := .F.
            endif

            freeObj(oJson)
            aSize(aHeadAux,0)    
        else
            //--------------------------------------------------------------
            //Aciona rotinas que utilizam a classe FIEICINT a qual herda a 
            //classe EICIDESPAC do padrão para a importação de dados
            //--------------------------------------------------------------
            if lPadrao
                aRetFunc  := &cExecAut.(cFileName,cFilProc,cErroExec, cErrorFile, cCompPth)
                lRet      := aRetFunc[1]
                cErroExec := aRetFunc[2]
                cErrorFile:= aRetFunc[3]
                lMantem   := aRetFunc[4]
                if len(aRetFunc) > 4
                    cRetFile  := aRetFunc[5]
                endif
            endif
        endif
        freeObj(oModelLy)
    else
        cErroExec += "Layout não encontrado "+cType +CRLF
        lRet      := .F.
    endif

    aSize(aHeader,0 )
    aSize(aDados ,0 ) 
return lRet

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
method readFile(cFile) class FIIMPACT
    local cLineRead as character //Linha do arquivo
    local aAux      as array     //Vetor auxiliar
    local aLido     as array     //Vetor da linha lida 

    aLido := {}

    nHandle := FT_FUse(cFile)

    If nHandle <= 0 
      Return
    Endif

    While !(FT_FEOF())
        cLineRead := FT_FREADLN()
        aAux := StrTokArr2(cLineRead,";", .T.)
        aadd(aLido, aClone(aAux))
        aSize(aAux,0)

        FT_FSKIP( )
    Enddo

    FT_FUSE( )


return aLido
//-------------------------------------------------------------------
/*/{Protheus.doc} destroy
Realiza a limpeza de objetos
@author  marcio.katsumata
@since   12/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method destroy() class FIIMPACT


    freeObJ(self:oSysFiUtl)

return


//-------------------------------------------------------------------
/*/{Protheus.doc} selFiles
Seleciona os arquivos do diretório success e error de cada entidade
@author  marcio.katsumata
@since   05/09/2019
@version 1.0
@param   cGroupCGC, character, CNPJs a serem consideradas da leitura
                               de arquivos EDI e EPO.
@return  boolean, existe arquivo para leitura? .T. = Sim, .F. = Não
/*/
//-------------------------------------------------------------------
method selFiles(cGroupCGC) class FIIMPACT

    local aDirPend  as array     //Lista de diretórios da pasta pending
    local cPath     as character //Caminho da pasta pending
    local cRootPath as character //RootPath do Protheus
    local aDirAux   as array     //Diretório auxiliar para naveção entre as pastas do diretório pending
    local nInd      as numeric   //Indice 
    local nInd2     as numeric   //Indice  
    local lOk       as logical   //Retorno de sucesso   
    local cReaded   as character //Diretório da pasta de arquivos enviados.  
    local cFilReg   as character //Filial do arquivo
    local aStatus   as array     //status do registro
    local lProc     as logical
    local nIndSta   as numeric
    //--------------------------------------------
    //Inicialização de variáveis
    //--------------------------------------------
    cRootPath := GetSrvProfString ("ROOTPATH","")
    aDirAux  := {}
    aDirPend := {}
    self:aImporting := {}
    lOk      := .F.
    cReaded  := ""
    cDestiny := self:oSysFiUtl:getImpRead() 
    cPath    := self:oSysFiUtl:getImpPend()
    cFilReg  := ""
    lProc    := .T.
    aDirPend := Directory(cPath+"\*.*","D")

    for nInd := 1 to len(aDirPend)

        if self:lResult
            lProc := UPPER(aDirPend[nInd][1]) $ 'EDI/EPO' 
        endif

        if aDirPend[nInd][1] <> '.' .and. aDirPend[nInd][1] <> '..' .and. lProc

            //-------------------------------------------------------------------
            //Verifica se existem arquivos nos subdiretórios da pasta pendentes.
            //-------------------------------------------------------------------
            cPathAux := cPath+"\"+aDirPend[nInd][1]

            //-------------------------------
            //Realiza a inserção da entidade
            //no array de arquivos
            //-------------------------------
            //Estrtura do array
            //- Entidade
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
            aadd(self:aImporting[nPos],aDirPend[nInd][1])

            aStatus := iif (UPPER(aDirPend[nInd][1]) $ 'EDI/EPO', {"success", "error"}, {""})

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
                cReaded := self:oSysFiUtl:impReadPrc (lower(alltrim(aDirPend[nInd][1])), aStatus[nIndSta])

                //Realiza a verificação de arquivos dentro do diretorio 
                aDirAux  := directory(cPathAux+"\"+aStatus[nIndSta]+"\*.*")

                //Se existir arquivos no subdiretório armazena-los no array de arquivos a processar
                for nInd2 :=1 to len(aDirAux)
                    cFilReg := ""
                    if aDirAux[nInd2][1] <> '.' .and. aDirAux[nInd2][1] <> '..'
                        if (substr(aDirAux[nInd2][1],5,14) $  cGroupCGC) .and. (empty(aStatus[nIndSta])  .or. (!empty(aStatus[nIndSta]) .and. self:validFile(lower(aDirAux[nInd2][1]), @cFilReg)))
                            aadd(self:aImporting[nPos][nPosSta][2], {lower(aDirAux[nInd2][1]), lower(cPathAux+"\"+aStatus[nIndSta]+"\"+aDirAux[nInd2][1]), lower(cReaded+"\"+aDirAux[nInd2][1]), cFilReg})    
                            lOk := .T.
                        endif
                    endif
                next nInd2

            next nIndSta
        endif
    next nInd


return lOk


//-------------------------------------------------------------------
/*/{Protheus.doc} validFile
Validação de arquivos EDI/EPO e retorna também a filial do registro
por parâmetro referência.
@author  marcio.katsumata
@since   05/09/2019
@version 1.0
@param   cFile, character, arquivo
@param   cFilReg, character, filial do processamento
@return  boolean, arquivo válido?
/*/
//-------------------------------------------------------------------
method validFile(cFile, cFilReg) class FIIMPACT
    local lValid as logical
    local cAliasFile as character
    local cFileAux   as character


    cFileAux   := strtran(cFile, ".txt_success","")
    cFileAux   := strtran(cFileAux, ".txt_error","")

    cAliasFile := getNextAlias()

    lValid := .F.

    beginSql alias cAliasFile

        SELECT * FROM %table:ZNT% ZNT
        WHERE ZNT.ZNT_FILE = %exp:cFileAux% AND
              ZNT.%notDel%
    endSql


    if (cAliasFile)->(!eof())
        cFilReg := (cAliasFile)->ZNT_FILIAL
        lValid := .T.
    endif

    (cAliasFile)->(dbCloseArea())

return lValid

user function FIIMPACT()
return