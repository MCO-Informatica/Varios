#include 'protheus.ch'
#include 'json.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} RLIEXEC
Processamento da integração LI
@author  marcio.katsumata
@since   05/09/2019
@version 1.0
@param   oJson, object, objeto JSON
@param   aHeader, array, vetor com os nomes dos campos(atributos)
@param   cFilProc, character, filial em que deve ser processado
@param   cMsgError, character, mensagem de erro
@param   cErrorFile, character, mensagem de erro para arquivo de retorno proc. sysfiorde
@return  logical, retorno do processamento.
/*/
//-------------------------------------------------------------------
user function RLIEXEC(oJson,aHeader,cFilProc,cMsgErro,cErrorFile)
    local nTamJson   as numeric   //Quantidade de registros no JSON
    local nInd       as numeric   //Indice  
    local cNUMPO     as character //Numero do PO
    local cPosicao   as character //Posição do PO
    local nQtd       as numeric   //Quantidade do produto 
    local cNumLI     as character //Numero do LI 
    local dVencLI    as date      //Vencimento do LI 
    local lErro      as logical   //Flag de erro  
    local cChaveSW3  as character //Chave na tabela SW3
    local lMantem    as logical   //Mantem o arquivo?
    //--------------------------------
    //Inicialização de variáveis
    //--------------------------------
    nTamJson := len(oJson[#'conteudo'])
    lErro := .F.
    cFilProc := PADR(cFilProc, tamSx3("W3_FILIAL")[1])
    lMantem  := .F.
    //------------------------------------
    //Abertura da tabela dos itens do PO
    //------------------------------------
    dbSelectArea("SW3")
    SW3->(dbSetOrder(8))
    //W3_FILIAL+W3_PO_NUM+W3_POSICAO

    //---------------------------------
    //Abertura da tabela da capa de PLI
    //---------------------------------
    dbSelectArea("SWP")
    SWP->(dbSetOrder(1))
    //WP_FILIAL+WP_PGI_NUM+WP_SEQ_LI+WP_NR_MAQ


    BEGIN TRANSACTION

        for nInd := 1 to nTamJson

            cNUMPO   := PADR(oJson[#'conteudo'][nInd][#'PO'], tamSx3("W3_PO_NUM")[1])
            cPosicao := PADR(oJson[#'conteudo'][nInd][#'POSICAO'], tamSx3("W3_POSICAO")[1])
            nQtd     := oJson[#'conteudo'][nInd][#'QTD']
            
            //---------------------------------------------------
            //Validação se existe a posição informada no arquivo
            //---------------------------------------------------
            cChaveSW3 := cFilProc+cNUMPO+cPosicao
            IF SW3->(dbSeek(cChaveSW3))
                //Posiciona na ultima sequência da SW3.
                while SW3->(W3_FILIAL+W3_PO_NUM+W3_POSICAO) == cChaveSW3 

                    SW3->(dbSkip())
                enddo
                SW3->(dbSkip(-1))
                //--------------------------------------------
                //Validação se o numero da PLI está preenchida
                //---------------------------------------------
                if empty(SW3->W3_PGI_NUM)
                    cErrorFile+= cMsgErro += "O campo No. da PLI da PO não está preechido para a posição: "+cPosicao+CRLF
                    lErro    := .T.
                endif
                //------------------------------------------------------------------------------
                //Validação se a quantidade do PO está igual à quantidade informada no arquivo
                //------------------------------------------------------------------------------
                if  nQtd <> SW3->W3_QTDE
                    cErrorFile+= cMsgErro += "Quantidade divergente da PO para a posição: "+cPosicao+CRLF
                    lErro    := .T.
                endif
                //------------------------------------------
                //Validação se o saldo da PLI não está zerada
                //------------------------------------------
                if !empty(SW3->SW3_SALDO_Q)
                    cErrorFile+= cMsgErro += "O saldo da PLI na PO está zerado para a posição: "+cPosicao+CRLF
                    lErro    := .T.
                endif
            else
                cErrorFile+= cMsgErro += "Não existe posicao correspondente na PO: "+cPosicao+CRLF
                lErro    := .T.
            endif
            
            //-------------------------------------------------
            //Realiza a gravação das informação de numero de LI
            //e numero de vencimento do LI na tabela de capa PLI
            //-------------------------------------------------
            if !lErro
                if SWP->(dbSeek(cFilProc+SW3->W3_PGI_NUM))

                    //Chave SWP
                    cChvSWP := SWP->(WP_FILIAL+WP_PGI_NUM) 
                    
                    //Verifica qual é a última sequência da PLI
                    while SWP->(WP_FILIAL+WP_PGI_NUM) == cChvSWP
                        SWP->(dbSkip())
                    enddo

                    SWP->(dbSkip(-1))
                    //-------------------------------------------------------
                    //Realiza a gravação das informações na última sequência
                    //-------------------------------------------------------
                    recLock("SWP", .F.)
                    SWP->WP_REGIST := PADR(oJson[#'conteudo'][nInd][#'NUMEROLI'], tamSx3("WP_REGIST")[1])
                    SWP->WP_VENCTO := oJson[#'conteudo'][nInd][#'VENCTOLI']
                    SWP->(msUnlock())
                else
                    cErrorFile+= cMsgErro += "Não existe registro correspondente na tabela de LI "+CRLF
                    lErro    := .T.
                    lMantem  := .T.                    
                endif
            endif
        next nInd

        //--------------------------------------------
        //Caso exista algum erro em qualquer posição 
        //realiza o rollback da gravação de todas
        //as informações
        //--------------------------------------------
        if lErro
            disarmTransaction()
            break
        endif

    END TRANSACTION


               
    
return {!lErro, cMsgErro, cErrorFile,lMantem}