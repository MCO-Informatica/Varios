#include 'protheus.ch'
#include 'json.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} RLTEXEC
Processamento da integração Lote
@author  marcio.katsumata
@since   11/09/2019
@version 1.0
@param   oJson, object, objeto JSON
@param   aHeader, array, vetor com os nomes dos campos(atributos)
@param   cFilProc, character, filial em que deve ser processado
@param   cMsgError, character, mensagem de erro 
@param   cErrorFile, character, mensagem de erro para arquivo de retorno proc. sysfiorde
@return  logical, retorno do processamento.
/*/
//-------------------------------------------------------------------
user function RLTEXEC(oJson,aHeader,cFilProc,cMsgError,cErrorFile)

    local oSysFiUtl as object    //Classe utils           
    local nTamJson  as numeric   //Quantidade de registros no json      
    local aStrFile  as array     //Estrutura do arquivo recebido(entidade,cnpj, numero do processo, data)         
    local nIndJson  as numeric   //Indice de navegação entre os registros do JSON      
    local lFind     as logical   //Flag de existência de um registro com o mesmo numero de lote.      
    local lRecInv   as logical   //Flag de exitência de registro com a seguinte chave //W8_FILIAL+W8_HAWB+W8_INVOICE+W8_PO_NUM+W8_POSICAO+W8_PGI_NUM      
    local lRet      as logical   //Retorno de sucesso no processo          
    local lMantem   as logical   //Mantem o arquivo processado por erro      
    local cChaveSWV as character //Chave SWV            
    local nTotalQtd as numeric   //Quantidade total da posição      
    local aQtdTot   as array     //Vetor com os totais por posição do processo    
    local cChvQtd   as character //Chave da posição para a aglutinação de qtd por posição.     
    local cForn     as character //Codigo fornecedor 
    local cLoja     as character //Loja fornecedor 
    local lOk      as logical    //Retorno da função
    local cNumDesp as character  //Código do despachante
    local nSeq     as numeric    //Sequencia
    local cChaveSW3 as character //Chave da SW3
    local cChaveSW9 as character //Chave da SW9
    local nIndCol   as numeric
    //--------------------------------
    //Incialização de variáveis
    //--------------------------------
    nTamJson := len(oJson[#'conteudo'])
    cArquivo := oJson[#'arquivo']
    aStrFile := strTokArr2(cArquivo, "_", .T.)
    lRet     := .T.
    nIndJson := 1
    lMantem   := .F.
    cChaveSWV := ""
    aQtdTot   := {}
    cChvQtd   := ""
    lOk       := .T.
    cNumDesp := padr(alltrim(superGetMv("ES_FIDESPC", .F., "")), tamSx3("YU_DESP")[1])
    nSeq     := 0
    cForn    := ""
    cLoja    := ""
    oSysFiUtl := SYSFIUTL():new()
   
    //-----------------------------------------------------------------------------
    //As informações de embarque devem estar integrados na plataforma da SYSFIORDE
    //para prosseguir com a integração do arquivo de booking
    //-----------------------------------------------------------------------------
    if  oSysFiUtl:checkEDI(alltrim(upper(aStrFile[3])))

        //-------------------------------------
        //Verifica os atributos do JSON
        //-------------------------------------
        nTamCols := len(aHeader)

        dbSelectArea("SYU")
        SYU->(dbSetOrder(2))
        
        //------------------------------------------------------------------------------
        //Tratamento para fornecedor realiza busca na tabela SYU para realiza o DE/PARA
        //------------------------------------------------------------------------------
        If SYU->(DBSEEK(xFilial("SYU")+cNumDesp+"2"+PADR(oJson[#'conteudo'][1][#'WV_FORN'], tamSx3("YU_GIP_1")[1])))
            cForn     := SYU->YU_EASY
            cLoja     := SYU->YU_LOJA
        else
            lOk := .F.
            cErrorFile+= cMsgError +="Código de fornecedor inválido . Verifique DE/PARA! Codigo de referencia do fornecedor :"+oJson[#'conteudo'][1][#'W9_FORN']+CRLF      
        endif
        

        SYU->(dbCloseArea())    
        
        dbSelectArea ("SA2")
        SA2->(dbSetOrder(1))
        if !SA2->(dbSeek(xFilial("SA2")+cForn+cLoja))
            lOk := .F.
            cErrorFile+= cMsgError +="Código de fornecedor :"+cForn +" loja:"+cLoja+" inválido . Codigo de referencia :"+oJson[#'conteudo'][1][#'W9_FORN']+CRLF  
        endif

        BEGIN TRANSACTION 
            //-----------------------------------------------
            //Realiza a gravação da tabela Capa de Invoices
            //-----------------------------------------------
            dbSelectArea("SWV")
            SWV->(dbSetOrder(2))

            dbSelectArea("SW8")
            SW8->(dbSetOrder(6))

            dbSelectArea("SW3")
            SW3->(dbSetOrder(8))

            dbSelectArea("SW9")
            SW9->(dbSetOrder(1))

            while  nIndJson <= nTamJson .and. lOk
                //Chave da SW3 
                cChaveSW3 := cFilProc+;
                            oJson[#'conteudo'][nIndJson][#'WV_PO_NUM']+;
                            oJson[#'conteudo'][nIndJson][#'WV_POSICAO'] 
                //Chave SW9
                cChaveSW9  := cFilProc+;
                            oJson[#'conteudo'][nIndJson][#'WV_INVOICE']

                //---------------------------------------------------
                //Verifica a existência dos itens da PO e da invoice
                //---------------------------------------------------
                if (lRet:= lOk:= SW3->(dbSeek(cChaveSW3)) .and.;
                                 SW9->(dbSeek(cChaveSW9)))
                    lFind := .F.
                    nSeq  := 0

                    //Posiciona na ultima sequência da SW3.
                    while SW3->(W3_FILIAL+W3_PO_NUM+W3_POSICAO) == cChaveSW3 

                        SW3->(dbSkip())
                    enddo

                    SW3->(dbSkip(-1))

                    oJson[#'conteudo'][nIndJson][#'WV_PGI_NUM'] := SW3->W3_PGI_NUM

                    //----------------------------------------------------
                    //Monta a chave de procura de registros na tabela SWV
                    //----------------------------------------------------
                    cChaveSWV := cFilProc+;
                                 oJson[#'conteudo'][nIndJson][#'WV_HAWB']+;
                                 oJson[#'conteudo'][nIndJson][#'WV_INVOICE']+;
                                 oJson[#'conteudo'][nIndJson][#'WV_PGI_NUM']+;
                                 oJson[#'conteudo'][nIndJson][#'WV_PO_NUM']+;
                                 oJson[#'conteudo'][nIndJson][#'WV_POSICAO'] //W8_FILIAL+W8_HAWB+W8_INVOICE+W8_PO_NUM+W8_POSICAO+W8_PGI_NUM                                                                                                    
                    //-------------------------------             
                    //Realiza a procura na tabela SWV
                    //-------------------------------
                    lRecInv :=  SWV->(dbSeek(cChaveSWV))

                    //-----------------------------------------------------------
                    //Verifica se já existe um lote cadastrado para este registro
                    //-----------------------------------------------------------
                    if lRecInv 
                        while cChaveSWV == SWV->(WV_FILIAL+WV_HAWB+WV_INVOICE+WV_PGI_NUM+WV_PO_NUM+WV_POSICAO) .and. !lFind

                            lFind := SWV->WV_LOTE == oJson[#'conteudo'][nIndJson][#'WV_LOTE'] 

                            //-------------------------------------
                            //Realiza o tratamento para sequencias
                            //caso tenha mais de um lote para uma
                            //mesma posição de PO
                            //-------------------------------------
                            if lFind
                                nSeq := SWV->WV_REG
                            else
                                if SWV->WV_REG > nSeq
                                    nSeq := SWV->WV_REG
                                endif
                            endif    
                            SWV->(dbSkip())
                        enddo
                    endif

                    //---------------------------------
                    //Incrementa a sequencia caso não
                    //seja substituição das informações
                    //do registro
                    //---------------------------------
                    if !lFind
                        nSeq++
                    else
                        SWV->(dbSkip(-1))
                    endif

                    //--------------------------------------------
                    //Realiza a gravação do registro na tabela SWV
                    //--------------------------------------------
                    reclock("SWV", !lFind)  
                    SWV->WV_FILIAL := cFilProc

                    for nIndCol := 1 to nTamCols
                        if "WV_FORN" == alltrim(aHeader[nIndCol][3])
                            SWV->WV_FORN   := cForn
                            SWV->WV_FORLOJ := cLoja  
                        elseif "WV_" $ aHeader[nIndCol][3]
                            SWV->&(aHeader[nIndCol][3]) := oJson[#'conteudo'][nIndJson][#aHeader[nIndCol][3]]
                        endif
                    next nIndCol

                
                    if SW3->(dbSeek(xFilial("SW3")+SWV->(WV_PO_NUM+WV_POSICAO))) 
                        SWV->WV_CC     := SW3->W3_CC
                        SWV->WV_SI_NUM := SW3->W3_SI_NUM
                    endif

                    SWV->WV_REG := nSeq

                    //-----------------------------------------
                    //Armazena informaçções de Quantidade total
                    //independente do lote.
                    //------------------------------------------
                    //Chave para aglutinar a quantidade
                    cChvQtd := cFilProc+;
                               oJson[#'conteudo'][nIndJson][#'WV_HAWB']+;
                               oJson[#'conteudo'][nIndJson][#'WV_INVOICE']+;
                               oJson[#'conteudo'][nIndJson][#'WV_PO_NUM']+;
                               oJson[#'conteudo'][nIndJson][#'WV_POSICAO']+;
                               oJson[#'conteudo'][nIndJson][#'WV_PGI_NUM']

                    if !empty(aQtdTot)
                        nPosChv := aScan(aQtdTot, {|aQtdLine|aQtdLine[1] == cChvQtd})
                        if nPosChv > 0
                            aQtdTot[nPosChv][2] += oJson[#'conteudo'][nIndJson][#'WV_QTDE'] 
                        else
                            aadd(aQtdTot, {cChvQtd, oJson[#'conteudo'][nIndJson][#'WV_QTDE'] })
                        endif
                    else
                        aadd(aQtdTot, {cChvQtd, oJson[#'conteudo'][nIndJson][#'WV_QTDE'] })
                    endif

                    SWV->(msUnlock())

                    nIndJson++
                else
                    cErrorFile+= cMsgError += "Numero da PO/Invoice:"+oJson[#'conteudo'][nIndJson][#'WV_PO_NUM'] +"/"+;
                                              oJson[#'conteudo'][nIndJson][#'WV_INVOICE'] +;
                                              ", posição :"+oJson[#'conteudo'][nIndJson][#'WV_POSICAO']+" não encontrado."
                endif
            enddo 


            //--------------------------------------------------------
            //Validação da quantidade total de cada item com a Invoice
            //independente do lote
            //--------------------------------------------------------
            nInd := 1

            if lRet
                while nInd <= len(aQtdTot)
                    cChaveSWV := aQtdTot[nInd][1]
                    nTotalQtd := aQtdTot[nInd][2]
                    if SW8->(dbSeek(cChaveSWV))
                        if ! nTotalQtd == SW8->W8_QTDE
                            lRet := .F.
                            cErrorFile+= cMsgError += "Quantidade total do item :"+SW8->W8_COD_I +;
                                                      ", posição :"+SW8->W8_POSICAO+" está divergente da invoice."
                        endif
                    endif 
                    nInd++     
                enddo
            endif

            aSize(aQtdTot,0)

            if !lRet
                disarmTransaction()
                break
            endif
        
        END TRANSACTION        
    else
        cMsgError += "O arquivo de embarque EDI não foi integrado ainda na plataforma SYSFIORDE ." +CRLF
        lOk      := .F.
        lMantem  := .T.
    endif
    SA2->(dbCloseArea())
    SWV->(dbCloseArea())
    SW9->(dbCloseArea())
    SW3->(dbCloseArea())
    SW8->(dbCloseArea())

return {lRet, cMsgError, cErrorFile, lMantem}