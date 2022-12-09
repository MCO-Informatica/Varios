#include 'protheus.ch'
#include 'json.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} RCBEXEC
Processamento da integração liquidação cambio
@author  marcio.katsumata
@since   13/09/2019
@version 1.0
@param   oJson, object, objeto JSON
@param   aHeader, array, vetor com os nomes dos campos(atributos)
@param   cFilProc, character, filial em que deve ser processado
@param   cMsgError, character, mensagem de erro
@param   cErrorFile, character, mensagem de erro para arquivo de retorno proc. sysfiorde
@return  logical, retorno do processamento.
/*/
//-------------------------------------------------------------------
user function RCBEXEC(oJson,aHeader,cFilProc,cMsgError,cErrorFile)


    local oSysFiUtl as object    //Classe utils           
    local nTamJson  as numeric   //Quantidade de registros no json      
    local aStrFile  as array     //Estrutura do arquivo recebido(entidade,cnpj, numero do processo, data)         
    local nIndJson  as numeric   //Indice de navegação entre os registros do JSON      
    local lRet      as logical   //Retorno de sucesso no processo          
    local lMantem   as logical   //Mantem o arquivo processado por erro       
    local nIndCol   as numeric   //Indice 
    local cLinhaWb  as character //Linha da SWB
    
    //--------------------------------
    //Incialização de variáveis
    //--------------------------------
    nTamJson := len(oJson[#'conteudo'])
    cArquivo := oJson[#'arquivo']
    aStrFile := strTokArr2(cArquivo, "_", .T.)
    lRet     := .T.
    nIndJson := 1
    lMantem   := .F.
    nIndCol  := 1
    cLinhaWb := StrZero(val(oJson[#'conteudo'][nIndJson][#'WB_LINHA']), tamSx3("WB_LINHA")[1])

    oSysFiUtl := SYSFIUTL():new()

    dbSelectArea("SW8")
    SW8->(dbSetOrder(6))
    //W8_FILIAL+W8_HAWB+W8_INVOICE+W8_PO_NUM+W8_POSICAO+W8_PGI_NUM                   

    dbSelectArea("SWB")
    SWB->(dbSetOrder(8))

    //-------------------------------------
    //Verifica os atributos do JSON
    //-------------------------------------
    nTamCols := len(aHeader)

    if nTamJson >= 1 
        cInvoice  := oJson[#'conteudo'][1][#'W8_INVOICE']
        cProcesso := oJson[#'conteudo'][1][#'W8_HAWB'] 

        //---------------------------------------------------------
        //Validação se existe invoice para a liquidação de câmbio
        //---------------------------------------------------------
        if (lRet := SW8->(dbSeek(cFilProc+cProcesso+cInvoice)))
            BEGIN TRANSACTION

                for nIndJson:=1 to nTamJson 

                    //----------------------------------------------------------------------
                    //Posiciona e realiza a gravação da liquidação de câmbio na tabela SWB
                    //----------------------------------------------------------------------
                    if SWB->(dbSeek(cFilProc+cProcesso+cInvoice+cLinhaWb))

                        reclock("SWB", .F.)
                        for nIndCol := 1 to nTamCols
                            if "WB_LINHA" == alltrim(aHeader[nIndCol][3])
                                SWB->WB_LINHA := cLinhaWb
                            elseif "WB_" $ aHeader[nIndCol][3]
                                SWB->&(aHeader[nIndCol][3]) := oJson[#'conteudo'][nIndJson][#aHeader[nIndCol][3]]
                            endif
                        next nIndCol

                    else
                        lRet := .F.
                        cErrorFile += cMsgError+= "Registro de item de câmbio invoice: "+cInvoice + ;
                                                  ", linha: "+oJson[#'conteudo'][nIndJson][#'WB_LINHA']+" não encontrada "+CRLF
                    endif
                    
                next nIndJson 

                if !lRet
                    disarmtransaction()
                    break
                endif
            END TRANSACTION
        else
            cErrorFile += cMsgError+= "Registro de invoice Numero: "+cInvoice + ;
                                      ", processo: "+cProcesso+" não encontrado "+CRLF      
            lMantem := .T.     
        endif
        
        
    endif



return {lRet,cMsgError,cErrorFile,lMantem }