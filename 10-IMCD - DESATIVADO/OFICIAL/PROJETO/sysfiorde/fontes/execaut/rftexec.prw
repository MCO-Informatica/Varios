#include 'protheus.ch'
#include 'json.ch'
#include "EEC.CH"
#include "EECAF200.ch"
//-------------------------------------------------------------------
/*/{Protheus.doc} RFTEXEC
Processamento da integração fatura.
@author  marcio.katsumata
@since   06/09/2019
@version 1.0
@param   oJson, object, objeto JSON
@param   aHeader, array, vetor com os nomes dos campos(atributos)
@param   cFilProc, character, filial em que deve ser processado
@param   cMsgErro, character, mensagem de erro
@param   cErrorFile, character, mensagem de erro para arquivo de retorno proc. sysfiorde
@return  logical, retorno do processamento.
/*/
//-------------------------------------------------------------------
user function RFTEXEC(oJson,aHeader,cFilProc,cMsgErro,cErrorFile)

    local nTamJson as numeric   //Quantidade de registros no json object
    local nTamCols as numeric   //Quantiade de colunas(atributos) do json object
    local nIndCol  as numeric   //Indice
    local cArquivo as character //Nome do arquivo
    local aStrFile as array     //Estrutura do arquivo(entidade, cnpj, Nro Processo, data)
    local nIndJson as numeric   //Indice
    local nInd     as numeric   //Indice
    local lOk      as logical   //Retorno da função
    local nTotFob  as numeric   //Total da fatura
    local nFretIn  as numeric   //Total do frete
    local nDescont as numeric   //Total de desconto
    local nSeguro  as numeric   //Total de seguro
    local oSysFiUtl as object   //Classe utils
    local lMantem  as logical   //Mantem o arquivo ?
    local cRetFile as character //Mensagem de retorno para a fiorde
    local cNumDesp as character //Código do despachante
    local cMoeFob  as character //Moeda FOB
    local cCondPag as character //Condição de pagamento
    local nIndSW8  as numeric  //indice da SW8
    local cTecNCM  as character //Código NCM 
    local cCodFab  as character //Código Fabricante 
    local cFabLoj  as character //Código da loja fabricante 
    local cCodCC   as character //Unidade requisitante 
    private aRegsSW8 as array  //Recnos da SW8
    private nRecSW9 as numeric //Recno SW9
    private nRecSWA as numeric //Recno SWA

    //-----------------------
    //Numero do despachante
    //-----------------------
    cNumDesp := padr(alltrim(superGetMv("ES_FIDESPC", .F., "")), tamSx3("YU_DESP")[1])

    //--------------------------------
    //Inicializa variáveis
    //--------------------------------- 
    nTamJson := len(oJson[#'conteudo'])
    cArquivo := oJson[#'arquivo']
    aStrFile := strTokArr2(cArquivo, "_", .T.)
    lOk  := .T.
    nTotFob  := 0
    nFretIn  := 0
    nDescont := 0
    nSeguro  := 0
    nIndJson := 1
    lMantem  := .F.
    cRetFile := ""
    nRecSW9  := 0
    nRecSWA  := 0
    aRegsSW8 := {}
    cForn    := ""
    cLoja    := ""
    oSysFiUtl := SYSFIUTL():new()
    //-----------------------------------------------------------------------------
    //As informações de embarque devem estar integrados na plataforma da SYSFIORDE
    //para prosseguir com a integração do arquivo de booking
    //-----------------------------------------------------------------------------
    if  oSysFiUtl:checkEDI(alltrim(upper(aStrFile[3])))

        cInvoice  := oJson[#'conteudo'][1][#'W9_INVOICE']

        dbSelectArea("SYU")
        SYU->(dbSetOrder(2))
        
        //------------------------------------------------------------------------------
        //Tratamento para fornecedor realiza busca na tabela SYU para realiza o DE/PARA
        //------------------------------------------------------------------------------
        If SYU->(DBSEEK(xFilial("SYU")+cNumDesp+"2"+PADR(oJson[#'conteudo'][1][#'W9_FORN'], tamSx3("YU_GIP_1")[1])))
            cForn     := SYU->YU_EASY
            cLoja     := SYU->YU_LOJA
        else
            lOk := .F.
            cErrorFile+= cMsgErro +="Código de fornecedor inválido . Verifique DE/PARA! Codigo de referencia do fornecedor :"+oJson[#'conteudo'][1][#'W9_FORN']+CRLF      
        endif
        
        SYU->(dbCloseArea())

        dDataEmis := oJson[#'conteudo'][1][#'W9_DT_EMIS']
        cNumProc  := oJson[#'conteudo'][1][#'W9_HAWB']
        cMoeFob   := oJson[#'conteudo'][1][#'W9_MOE_FOB']
        cCondPag  := oJson[#'conteudo'][1][#'W9_COND_PA']
        
        //-------------------------------------
        //Verifica os atributos do JSON
        //-------------------------------------
        nTamCols := len(aHeader)

        //-----------------------------------------------
        //Realiza a gravação da tabela Capa de Invoices
        //-----------------------------------------------
        dbSelectArea("SW9")
        SW9->(dbSetOrder(1))

        dbSelectArea("SW8")
        SW8->(dbSetOrder(6))

        dbSelectArea("SW7")
        SW7->(dbSetOrder(4))
        //W7_FILIAL+W7_HAWB+W7_PO_NUM+W7_POSICAO+W7_PGI_NUM     

        dbSelectArea("SA2")
        SA2->(dbSetOrder(1))

        dbSelectArea("SYF")
        SYF->(dbSetOrder(3))

        dbSelectArea("SY6")
        SY6->(dbSetOrder(1))

        dbSelectArea("SW3")
        SW3->(dbSetOrder(8))
        
        if !SA2->(dbSeek(xFilial("SA2")+cForn+cLoja))
            lOk := .F.
            cErrorFile+= cMsgErro +="Código de fornecedor :"+cForn +" loja:"+cLoja+" inválido . Codigo de referencia :"+oJson[#'conteudo'][1][#'W9_FORN']+CRLF  
        endif

        //-----------------------------------------------------------------------
        //Tratamento e validação para moeda , realiza a busca na tabela SYF.
        //através do código da moeda siscomex
        //-----------------------------------------------------------------------
        if !SYF->(dbSeek(xFilial("SYF")+cMoeFob))
            lOk := .F.
            cErrorFile+= cMsgErro +="Código de moeda :"+cMoeFob +" inválido ."+CRLF  
        else
            cMoeFob := SYF->YF_MOEDA
        endif
            
        //---------------------------------------
        //Validação da condição de pagamento
        //---------------------------------------
        if !SY6->(dbSeek(xFilial("SY6")+cCondPag))
            lOk := .F.
            cErrorFile+= cMsgErro +="Condição de pagamento  :"+cCondPag +" inválido ."+CRLF  
        endif

        BEGIN TRANSACTION 

            if !SW9->(dbSeek(cFilProc+cInvoice+cForn+cLoja+cNumProc)) .and. lOk

                //-----------------------------------------------
                //Realiza a gravação da tabela Itens de Invoices
                //-----------------------------------------------
                while  nIndJson <= nTamJson .and. lOk

                    //W8_FILIAL+W8_HAWB+W8_INVOICE+W8_PO_NUM+W8_POSICAO+W8_PGI_NUM
                    if!SW8->(dbSeek(cFilProc+cNumProc+cInvoice+oJson[#'conteudo'][nIndJson][#'W8_PO_NUM']+oJson[#'conteudo'][nIndJson][#'W8_POSICAO']))
                        //---------------------------------------------
                        //Posiciona no item da PO para resgatar NCM
                        //W3_FILIAL+W3_PO_NUM+W3_POSICAO
                        //---------------------------------------------
                        cChaveSW3 := cFilProc+oJson[#'conteudo'][nIndJson][#'W8_PO_NUM']+oJson[#'conteudo'][nIndJson][#'W8_POSICAO']
                        SW3->(dbSeek(cChaveSW3))

                        //-----------------------------
                        //Armazena as informações da
                        //primeira sequencia de cada
                        //linha da PO
                        //-----------------------------
                        cTecNCM := SW3->W3_TEC
                        cCodFab := SW3->W3_FABR
                        cFabLoj := SW3->W3_FABLOJ
                        cCodCC  := SW3->W3_CC

                        //Posiciona na ultima sequência da SW3.
                        while SW3->(W3_FILIAL+W3_PO_NUM+W3_POSICAO) == cChaveSW3 

                            SW3->(dbSkip())
                        enddo

                        SW3->(dbSkip(-1))

                        oJson[#'conteudo'][nIndJson][#'W8_PGI_NUM'] := SW3->W3_PGI_NUM

                        recLock("SW8", .T.)   
                        //-----------------------------------------------------
                        //Gravação dos itens comuns entre as tabelas SW9 e SW8
                        //-----------------------------------------------------
                        SW8->W8_FILIAL  := cFilProc
                        SW8->W8_INVOICE := cInvoice  
                        SW8->W8_FORN    := cForn     
                        SW8->W8_FORLOJ  := cLoja     
                        SW8->W8_DT_EMIS := dDataEmis 
                        SW8->W8_HAWB    := cNumProc  
                        SW8->W8_TEC     := cTecNCM
                        SW8->W8_FABR    := cCodFab
                        SW8->W8_FABLOJ  := cFabLoj
                        SW8->W8_CC      := cCodCC
                        
                        for nIndCol := 1 to nTamCols
                            if "W8_" $ aHeader[nIndCol][3]
                                SW8->&(aHeader[nIndCol][3]) := oJson[#'conteudo'][nIndJson][#aHeader[nIndCol][3]]
                            endif

                        next nIndCol


                        //-------------------------------------------------
                        //Realiza a validação se o item existe na tabela SW7 
                        //(itens da declaração de importação)
                        //-------------------------------------------------
                        //W7_FILIAL+W7_HAWB+W7_PO_NUM+W7_POSICAO+W7_PGI_NUM     
                        if SW7->(dbSeek(SW8->(W8_FILIAL+W8_HAWB+W8_PO_NUM+W8_POSICAO)))
                            //---------------------------------------
                            //Verifica a quantidade SW7 x SW8
                            //---------------------------------------
                            if !(SW7->W7_QTDE == SW8->W8_QTDE)
                                cErrorFile+= cMsgErro += "Inconsistência na quantidade PO: "+SW8->W8_PO_NUM+" Posição:"+SW8->W8_POSICAO+CRLF
                                lOk      := .F.
                            else
                                SW8->W8_REG     := SW7->W7_REG
                                SW8->W8_SI_NUM  := SW7->W7_SI_NUM
                                SW8->W8_PGI_NUM := SW7->W7_PGI_NUM
                            endif
                        else
                            cErrorFile+= cMsgErro += "Não existe registro de embarque PO: "+SW8->W8_PO_NUM+" Posição:"+SW8->W8_POSICAO+CRLF  
                            lOk      := .F.
                        endif

                        SW8->(msUnlock())

                        aadd(aRegsSW8, SW8->(recno())) 

                        nTotFob  += SW8->W8_QTDE * SW8->W8_PRECO
                        nFretIn  += SW8->W8_FRETEIN 
                        nDescont += SW8->W8_DESCONT
                        nSeguro  += SW8->W8_SEGURO
                    else
                        lOk := .F.
                        cErrorFile+= cMsgErro += "Já existe um registro na tabela (SW8 -Itens Invoice ) Invoice: "+cInvoice+" , PO: "+oJson[#'conteudo'][1][#'W8_PO_NUM']+", Posição:"+oJson[#'conteudo'][1][#'W8_POSICAO']+CRLF  
                    endif
                    nIndJson++
                enddo

                if lOk 

                    //-----------------------------------------------
                    //Realiza a gravação da tabela Capa de Invoices
                    //-----------------------------------------------
                    recLock("SW9", .T.)
                    SW9->W9_FILIAL := cFilProc
                    for nIndCol := 1 to nTamCols
                        //-----------------------------------------
                        //Grava fornecedor e loja 
                        //-----------------------------------------
                        if "W9_FORN" == alltrim(aHeader[nIndCol][3])
                            SW9->W9_FORN   := cForn
                            SW9->W9_FORLOJ :=  cLoja
                        //-----------------------------------------
                        //Grava moeda
                        //-----------------------------------------
                        elseif "W9_MOE_FOB" == alltrim(aHeader[nIndCol][3])
                            SW9->W9_MOE_FOB   := cMoeFob

                        elseif "W9_" $ aHeader[nIndCol][3] 
                            SW9->&(aHeader[nIndCol][3]) := oJson[#'conteudo'][1][#aHeader[nIndCol][3]]
                        endif

                    next nIndCol
                    
                    SW9->W9_DIAS_PA := SY6->Y6_DIAS_PA
                    //--------------------------------
                    //Gravando o totalizador do preço
                    //--------------------------------
                    SW9->W9_FOB_TOT := nTotFob

                    SW9->W9_NOM_FOR:= SA2->A2_NREDUZ
                        
                    //Validação de totais  SW8 x SW9
                    if !(lOk := SW9->W9_FRETEIN  == nFretIn  .and.;
                                SW9->W9_DESCONT == nDescont .and.;
                                SW9->W9_SEGURO  == nSeguro)

                        cErrorFile+= cMsgErro  += "Validação entre itens e cabeçalho divergente, verifique o total de frete/desconto/seguro "+CRLF
                
                    else
                        lOk := gravaCamb(@cMsgErro, @cRetFile)
                    endif

                    SW9->(msUnlock())
                    nRecSW9 := SW9->(recno())
                endif
            else
                if lOk 
                    lOk := .F.
                    cErrorFile+= cMsgErro += "Já existe um registro na tabela (SW9 -Capa Invoice ) Invoice: "+cInvoice+" No Processo:"+cNumProc+CRLF  
                endif
            endif        
            if !lOk
                disarmTransaction()

                if nRecSWA > 0
                    SWA->(dbGoTo(nRecSWA))
                    if SWA->(!EOF())
                        reclock("SWA", .F.)
                        SWA->(dbDelete())
                        SWA->(msUnlock())
                    endif
                endif

                if !empty(aRegsSW8)
                    for nIndSW8 := 1 to len(aRegsSW8)
                        SW8->(dbGoTo(aRegsSW8[nIndSW8]))
                        if SW8->(!EOF())
                            reclock("SW8", .F.)
                            SW8->(dbDelete())  
                            SW8->(msUnlock())   
                        endif                   
                    next nIndSW8 
                endif  

                if nRecSW9 > 0
                    SW9->(dbGoTo(nRecSW9))
                    if SW9->(!EOF())
                        reclock("SW9", .F.)
                        SW9->(dbDelete())
                        SW9->(msUnlock())  
                    endif
                endif

                BREAK

            endif

        END TRANSACTION

        SW9->(dbCloseArea())
        SW8->(dbCloseArea())
        SW7->(dbCloseArea())
        SA2->(dbCloseArea())
        SYF->(dbCloseArea())        
        SW3->(dbCloseArea())
        
    else
        cMsgErro += "O arquivo de embarque EDI não foi integrado ainda na plataforma SYSFIORDE ." +CRLF
        lOk      := .F.
        lMantem  := .T.
    endif

    aSize(aStrFile,0)
    aSize(aRegsSW8,0)
    freeObj(oSysFiUtl)

return {lOk,cMsgErro,cErrorFile,lMantem }


//-------------------------------------------------------------------
/*/{Protheus.doc} gravaCamb
Grava informações de câmbio nas tabelas SWA/SWB
@author  marcio.katsumata
@since   06/09/2019
@version 1.0
@param   cMsgErro, character, mensagem de erro
/*/
//-------------------------------------------------------------------
static function gravaCamb(cMsgErro,cRetFile)

    local cFilBkp   as character //Backup do código da filial corrente.        
    local aParc     as array     //Array com as informações das parcelas conforme condição de pagamento   
    local lRet      as logical   //Retorno da função      
    local cPrefixo  as character //Prefixo do titulo       
    local cTipo     as character //Tipo do titulo       
    local cNatureza as character //Natureza do titulo       
    local cFornece  as character //Fornecedor do titulo       
    local cLoja     as character //Loja do fornecedor       
    local cParcela  as character //Parcela do titulo       
    local dVencto   as date      //Data de vencimento da parcela  
    local nValor    as numeric   //Valor da parcela     
    local nIndParc  as numeric   //Indice     
    local nMoeda    as numeric   //Moeda     

    //--------------------------
    //Inicialização de variáveis
    //--------------------------
    lRet    := .F.
    cFilBkp := cFilAnt
    cFilAnt := SW9->W9_FILIAL
    nIndParc := 1


    //-----------------------------------
    //Abre a tabela de capa de câmbio e 
    //realiza a gravação de informações
    //-----------------------------------
    dbSelectArea("SWA")
    SWA->(dbSetOrder(1))

   If !SWA->(dbSeek(SW9->(W9_FILIAL+W9_HAWB)+"D"))
        reclock("SWA", .T.)
        SWA->WA_FILIAL := SW9->W9_FILIAL
        SWA->WA_PO_DI  := "D"
        SWA->WA_CEDENTE := SW9->W9_NOM_FOR
        SWA->WA_CODCEDE := "1"
        SWA->WA_FB_NOME := SW9->W9_NOM_FOR
        SWA->WA_HAWB    := SW9->W9_HAWB
        SWA->(msUnlock())
        nRecSWA := SWA->(recno())
    endif

    
    //-----------------------------------
    //Abre a tabela de itens de cambio e
    //realiza a gravação de informações 
    //-----------------------------------
    dbSelectArea("SWB")
    SWB->(dbSetOrder(1))
    if (lRet:= !SWB->(dbSeek(SW9->(W9_FILIAL+W9_HAWB)+"D"+SW9->(W9_INVOICE+W9_FORN+W9_FORLOJ)+STRZERO(1,tamSx3("WB_LINHA")[1]))))
            
        cPrefixo  := "EIC" 
        cTipo     := "INV"
        cNatureza := "211001"
        cFornece  := SW9->W9_FORN
        cLoja     := SW9->W9_FORLOJ
        cNumTit   := AvgNumSeq("SW9","W9_NUM")             
        //--------------------------------------------------------------------------
        //Função de condição de pagamento AF200GPCD
        /*Parametros  :  Valor(n)
                         Condição de Pagamento(c)
                         Data Base(d)
                         Evento(c)
                         Fornecedor (c)
                         Loja (c)
                         Empresa (c)
                         Número da Invoice (c) 
                         cNatureza
          Retorno     : Array bidimensional, com a(s) parcela(s) de cambio.
                        aArray[1] = Valor da Parcela.
                        aArray[2] = Dt. de Vencimento.
                        aArray[3] = Evento.*/
        //--------------------------------------------------------------------------
        aParc := AF200GPCD(SW9->W9_FOB_TOT,SW9->W9_COND_PA, SW9->W9_XDTBAS, "", ;
                          SW9->W9_FORN, SW9->W9_FORLOJ, SW9->W9_NOM_FOR, SW9->W9_INVOICE, cNatureza)
        
        If !(lRet := len(aParc) > 0)
            cMsgErro += " Condição de pagamento: "+W9_COND_PA+" não retornou nenhuma parcela para a invoice : "+ SW9->W9_INVOICE +CRLF
        endif

        while  nIndParc <= len(aParc) .and. lRet

            cParcela  := strzero(nIndParc, tamSx3("E2_PARCELA")[1])
            dVencto   := aParc[nIndParc][2]
            nValor    := aParc[nIndParc][1] 
            nMoeda    := SimbToMoeda(SW9->W9_MOE_FOB)

            if (lRet := criaTitulo(cPrefixo, cNumTit, cParcela, cTipo, cNatureza,cFornece, cLoja, dVencto, nValor,nMoeda,@cMsgErro))
                if (lRet:= !SWB->(dbSeek(SW9->(W9_FILIAL+W9_HAWB)+"D"+SW9->(W9_INVOICE+W9_FORN+W9_FORLOJ)+STRZERO(nIndParc,tamSx3("WB_LINHA")[1])))) 
                    reclock("SWB", .T.)
                    SWB->WB_FILIAL  := SW9->W9_FILIAL
                    SWB->WB_HAWB    := SW9->W9_HAWB
                    SWB->WB_DT_DIG  := dDataBase
                    SWB->WB_TIPOREG := "1"
                    SWB->WB_INVOICE := SW9->W9_INVOICE
                    SWB->WB_MOEDA   := SW9->W9_MOE_FOB
                    SWB->WB_PO_DI   := "D"
                    SWB->WB_DT_VEN  := dVencto
                    SWB->WB_FOBMOE  := nValor
                    SWB->WB_NUMDUP  := cNumTit
                    SWB->WB_PARCELA := cParcela
                    SWB->WB_FORN    := cFornece
                    SWB->WB_LOJA    := cLoja
                    SWB->WB_LINHA   := strzero(nIndParc, tamSx3("WB_LINHA")[1])
                    SWB->WB_EVENT  := "101"
                    SWB->WB_TIPOTIT := "INV"
                    SWB->WB_PREFIXO := "EIC"
                    SWB->WB_TP_CON  := "2"
                    SWB->(msUnlock())
                else
                    cMsgErro += " Já existe registros de câmbio (SWB) para a invoice : "+ SW9->W9_INVOICE +CRLF
                endif
            endif
            nIndParc++
        endDo
        aSize(aParc,0)
    else
        cMsgErro += " Já existe registros de câmbio (SWB) para a invoice : "+ SW9->W9_INVOICE +CRLF
    endif

    cFilAnt   := cFilBkp

return lRet 

//-------------------------------------------------------------------
/*/{Protheus.doc} criaTitulo
Cria titulo utilizando o execauto FINA050.
@author  marcio.katsumata
@since   09/09/2019
@version 1.0
@param   cPrefixo, character, prefixo do titulo
@param   cNumTit , character, numero do titulo
@param   cParcela, character, parcela do titulo
@param   cTipo   , character, tipo do titulo
@param   cNatureza, character, natureza do titulo
@param   cFornece , character, codigo do fornecedor
@param   cLoja    , character, código da loja
@param   dVecnto  , date     , data de vencimento
@param   nValor   , numeric  , valor do titulo
@param   cMsgErro, character, mensagem de erro
@return  boolean  , retorno da criação do titulo.
/*/
//-------------------------------------------------------------------
static function criaTitulo(cPrefixo, cNumTit, cParcela, cTipo, cNatureza,cFornece, cLoja, dVencto, nValor,nMoeda,cMsgErro)

    local aTitFat          := {}                                //Dados do titulo
    local cArqLog          := ""                                //Arquivo de log do mostraerro
    local cLogPath         := SuperGetMV("MV_LOGPATH",,"logs")  //Pasta para gravacao do log de erro pela funcao Mostraerro().  
    private lMsErroAuto    := .F.                               //Variável que indica se ocorreu erro no execauto do FINA460
    private lMsHelpAuto    := .T.                               //Variável interna do execauto 
    
    aTitFat :=    { { "E2_PREFIXO"  , cPrefixo           , NIL },;
                    { "E2_NUM"      , cNumTit            , NIL },;
                    { "E2_PARCELA"  , cParcela           , NIL },;
                    { "E2_TIPO"     , cTipo              , NIL },;
                    { "E2_NATUREZ"  , cNatureza          , NIL },;
                    { "E2_FORNECE"  , cFornece           , NIL },;
                    { "E2_LOJA"     , cLoja              , NIL },;
                    { "E2_EMISSAO"  , dDataBase          , NIL },;
                    { "E2_MOEDA"    , nMoeda             , NIL },;
                    { "E2_VENCTO"   , dVencto            , NIL },;
                    { "E2_VENCREA"  , dVencto            , NIL },;
                    { "E2_VALOR"    , nValor             , NIL } }
    
    MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aTitFat,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
    
    
    If lMsErroAuto
		//Mensagem de erro do execauto
		cArqLog   := GetNextAlias()+".log"
		cMsgErro :=  MostraErro(cLogPath,cArqLog)

		//Apaga o arquivo de LOG.
		if file(cLogPath+"\"+cArqLog)
			FErase(cLogPath+"\"+cArqLog)
		endif
    Endif

    aSize(aTitFat,0)

return !lMsErroAuto


/*
Função      : AF200GPCD
Parametros  : Valor(n)
              Condição de Pagamento(c)
              Data Base(d)
              Evento(c)
              Fornecedor (c)
              Loja (c)
              Empresa (c)
              Número da Invoice (c) (JPM - 02/08/05)
              cNatureza
Objetivo    : Geração de parcelas de cambio para Comissão por Agente(s) e Despesas Internacionais.
Retorno     : Array bidimensional, com a(s) parcela(s) de cambio.
              aArray[1] = Valor da Parcela.
              aArray[2] = Dt. de Vencimento.
              aArray[3] = Evento.
Autor       : Alexsander Martins dos Santos
Data e Hora : 27/09/2004 às 14:17.
*/

Static Function AF200GPCD(nValor, cCondPagto, dDtBase, cEvento, cFornecedor, cLoja, cEmpresa, cNrInvo, cNat)

Local aParcelas   := {}
Local nParcela    := 0
Local nPercentual := 0
Local nDias       := 0
Local nTotal      := 0
Local aSaveOrd    := SaveOrd({"SY6","EC6"}, 1)  // By JPP - 02/06/2005 - 13:50
Local cRecDesp    := Space(3) // By JPP - 02/06/2005 - 13:50
Local nParcs := 0, nVlParc := 0
Local nDecParc := AvSX3("EEQ_VL",AV_DECIMAL)

Default cEvento := EV_PRINC2
Default cNrInvo := EEC->EEC_NRINVO
Default cNat:= ""

Private lRetPE := .F., nValorPE := 0  // GFP - 17/12/2013

Begin Sequence

   IF(EasyEntryPoint("EECAF200"),Execblock("EECAF200",.F.,.F.,"VALIDA_PARCELA"),)  // GFP - 13/12/2013

   If nValorPE <> 0  // GFP - 17/12/2013
      nValor := nValorPE
   EndIf

   //RMD - 23/08/05 - Impede que sejam geradas parcelas quando o valor total é igual a 0.
   If nValor == 0 .AND. !lRetPE  // GFP - 13/12/2013
      Break
   EndIf

   //ER - 04/12/2007 - Verifica se existe mais que 10 parcelas de cambio.
   SX3->(DbSetOrder(2))
   If SX3->(DbSeek("Y6_PERC_01"))
      While SX3->(!EOF()) .and. Left(SX3->X3_CAMPO,8) == "Y6_PERC_"
         nParcs ++
         SX3->(DbSkip())
      EndDo
   EndIf

   EC6->(DbSetOrder(1))   // By JPP - 02/06/2005 - 13:50 - Define se a parcela de Cambio é receita ou despesa.
   EC6->(DbSeek(xFilial("EC6")+AvKey("EXPORT","EC6_TPMODU")+AvKey(cEvento,"EC6_ID_CAM")))
   cRecDesp :=EC6->EC6_RECDES

   SY6->(dbSeek(xFilial()+cCondPagto))

   Do Case

      Case SY6->Y6_TIPO = "1"

         dDtEMBNew:=EECProximoMes(dDtBase,SY6->Y6_COD,SY6->Y6_DIAS_PA)

         aAdd(aParcelas, {nValor, dDtEMBNew+SY6->Y6_DIAS_PA, cEvento, cFornecedor, cLoja, cEmpresa, cRecDesp, cNrInvo, cNat}) // By JPP - 02/06/2005 - 13:50 - Inclusão do parametro cRecDesp.

      Case SY6->Y6_TIPO = "2"

         aAdd(aParcelas, {nValor, dDtBase, cEvento, cFornecedor, cLoja, cEmpresa,cRecDesp, cNrInvo, cNat})  // By JPP - 02/06/2005 - 13:50 - Inclusão do parametro cRecDesp.

      Otherwise

         dDtEMBNew:=EECProximoMes(dDtBase,SY6->Y6_COD,SY6->Y6_DIAS_PA)

         //For nParcela := 1 To 10
         For nParcela := 1 To nParcs //ER - 04/12/2007

            nPercentual := SY6->&("Y6_PERC_"+StrZero(nParcela, 2))
            nDias       := SY6->&("Y6_DIAS_"+StrZero(nParcela, 2))
            /* By JPP - 13/09/2005 - 15:45 - Permitir Gerar parcelas de cambio quando existir adiantamento.
            If nDias < 0
               lParcdeAdiant := .T.
            EndIf */

            If nPercentual = 0
               Exit
            EndIf

            nVlParc := Round(nValor*(nPercentual/100),nDecParc)

            If nDias >= 0  // By JPP - 13/09/2005 - 15:45
               aAdd(aParcelas, {nVlParc, dDtEMBNew+nDias, cEvento, cFornecedor, cLoja, cEmpresa,cRecDesp, cNrInvo, cNat}) // By JPP - 02/06/2005 - 13:50 - Inclusão do parametro cRecDesp.
            EndIf

            // nTotal += aParcelas[nParcela][1]
            nTotal += nVlParc

         Next

         If Len(aParcelas) > 0
            If nValor <> nTotal
               aParcelas[nParcela-1][1] += (nValor-nTotal)
            EndIf
         Else
          //HELP(" ", 1, "AVG0005086",, AllTrim(cCondPagto), 1, 31)
         EndIf

   End Case

End Sequence

RestOrd(aSaveOrd)

Return(aParcelas)