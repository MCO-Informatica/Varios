#include 'protheus.ch'
#include 'json.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} RBOEXEC
Processamento da integração Booking
@author  marcio.katsumata
@since   06/09/2019
@version 1.0
@param   oJson, object, objeto JSON
@param   aHeader, array, vetor com os nomes dos campos(atributos)
@param   cFilProc, character, filial em que deve ser processado
@param   cMsgError, character, mensagem de erro
@param   cErrorFile, character, mensagem de erro para arquivo de retorno proc. sysfiorde
@return  logical, retorno do processamento.
/*/
//-------------------------------------------------------------------
user function RBOEXEC(oJson,aHeader,cFilProc,cMsgError,cErrorFile)
    local nTamJson as numeric
    local cArquivo as character
    local aStrFile as array
    local lEDI     as logical
    local lNewReg  as logical
    local nIndJson as numeric
    local nInd     as numeric
    local lRet     as logical
    local oSysFiUtl as object
    local lMantem  as logical
    local lSW9     as logical
    local cNumDesp as character
    local cAgente  as character
    //-------------------------------
    //Inicialização de variáveis
    //-------------------------------
    nTamJson := len(oJson[#'conteudo'])
    cArquivo := oJson[#'arquivo']
    aStrFile := strTokArr2(cArquivo, "_", .T.)
    lRet := .T.
    lMantem := .F.
    lSW9 := .F.
    cNumDesp := padr(alltrim(superGetMv("ES_FIDESPC", .F., "")), tamSx3("YU_DESP")[1])
    cAgente  := ""

    oSysFiUtl := SYSFIUTL():new()
    dbSelectArea("SYU")
    SYU->(dbSetOrder(2))


    dbSelectArea("SW6")
    SW6->(dbSetOrder(1))
    //-----------------------------------------------------------------------------
    //As informações de embarque devem estar integrados na plataforma da SYSFIORDE
    //para prosseguir com a integração do arquivo de booking
    //-----------------------------------------------------------------------------
    if  oSysFiUtl:checkEDI(alltrim(upper(aStrFile[3])))

        BEGIN TRANSACTION
            for nIndJson := 1 to nTamJson

                cAgente := ""

                //------------------------------------------------------------------------------
                //Tratamento para agente realiza busca na tabela SYU para realiza o DE/PARA
                //------------------------------------------------------------------------------
                If SYU->(DBSEEK(xFilial("SYU")+cNumDesp+"3"+PADR(oJson[#'conteudo'][nIndJson][#'W6_AGENTE'], tamSx3("YU_GIP_1")[1])))
                    cAgente     := SYU->YU_EASY
                else
                    lRet := .F.
                    cErrorFile+= cMsgError +="Código de agente inválido . Verifique DE/PARA! Codigo de referencia do agente :"+oJson[#'conteudo'][nIndJson][#'W6_AGENTE']+CRLF      
                endif

                //---------------------------------
                //Verifica a existência de invoice
                //para o processo
                //---------------------------------    
                dbSelectArea("SW9")
                SW9->(dbSetOrder(3))
                lSW9 := SW9->(dbSeek(cFilProc+oJson[#'conteudo'][nIndJson][#'W6_HAWB']))

                if SW6->(dbSeek(cFilProc+oJson[#'conteudo'][nIndJson][#'W6_HAWB']))
                    recLock("SW6",.F.)


                    for nInd := 1 to len(aHeader)
                        if "W6_" $ aHeader[nInd][3]  .and. !(alltrim(aHeader[nInd][3]) $ "W6_DT_EMB/W6_AGENTE")

                            SW6->&(aHeader[nInd][3]) := oJson[#'conteudo'][nIndJson][#aHeader[nInd][3]]
                        else
                            //---------------------------------------
                            //Realiza validação da data de embarque
                            //não deve ser preenchida se invoice não
                            //foi integrada
                            //---------------------------------------
                            if "W6_DT_EMB" == alltrim(aHeader[nInd][3] )
                                if lSW9
                                    SW6->&(aHeader[nInd][3]) := oJson[#'conteudo'][nIndJson][#aHeader[nInd][3]]
                                else
                                    cErrorFile+= cMsgError += "Data de embarque não deve ser preenchido para o número de processo: " +;
                                                               oJson[#'conteudo'][nIndJson][#'W6_HAWB']+;
                                                               ", pois não existe registro de invoice até o momento"+CRLF
                                    lRet    := .F.                                  
                                endif
                            elseif "W6_AGENTE" == alltrim(aHeader[nInd][3] )
                                SW6->&(aHeader[nInd][3]) := cAgente
                            endif
                        endif
                    next nInd
                
                    SW6->(msUnlock())
                else
                    cErrorFile+= cMsgError += "Registro de embarque não encontrado para o número de processo: " +oJson[#'conteudo'][nInd][#'W6_HAWB']+CRLF
                    lRet    := .F.
                endif

            next nIndJson

            if !lRet
                disarmtransaction()
                break
            endif
        END TRANSACTION

        
    else
        cMsgError += "O arquivo de embarque EDI não foi integrado ainda na plataforma SYSFIORDE ." +CRLF
        lRet := .F.
        lMantem := .T.
    endif
    
    freeObj(oSysFiUtl)
    

return {lRet, cMsgError, cErrorFile, lMantem}