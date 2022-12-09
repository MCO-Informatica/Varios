#include 'protheus.ch'
#include 'json.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} RNDEXEC
Realiza o processamento dos registros RND (Nota de despesas)
@author  marcio.katsumata
@since   17/09/2019
@version 1.0
@param   cFilePrc, character, nome do arquivo
@param   cFilProc, character, filial em que deve ser processado
@param   cMsgError, character, mensagem de erro
@param   cErrorFile, character, mensagem de erro para arquivo de retorno proc. sysfiorde
@param   cComPth   , character, caminho completo do arquivo processado
@return  logical, retorno do processamento.
/*/
//-------------------------------------------------------------------
user function RNDEXEC(cFilePrc ,cFilProc,cErroExec, cErrorFile,cCompPth)
    local nIndJson as numeric   //Indice do JSON 
    local nTamJson as numeric   //Quantidade de registros no JSON
    local nIndStr  as numeric   //Indice do aStrDef
    local nTamStr  as numeric   //Tamanho do aStrDef
    local lInsere  as logical   //Insere ou altera?
    local cNumDesp as character //Código do despachante
    local lRet     as logical   //Retorno do processamento  
    private oJson   as object   //Json object  
    private aStrDef as array    //Estrutura do layout 



    //--------------------------
    //Inicializando variáveis
    //--------------------------
    oJson    := JsonBld():new()
    oJson[#'conteudo'] := {}
    aStrDef := {}
    lInsere := .T.
    lRet    := .T.

    //-------------------------------
    //Realiza o tramamento de filial
    //-------------------------------
    cFilBkp := cFilAnt
    cFilAnt := cFilProc


    //---------------------------------------------------
    //O módulo deve ser o EIC para o processamento padrão
    //---------------------------------------------------
    cModulo   := "EIC"

    //------------------------------
    //Verifica a estrutura do layout
    //------------------------------
    getStrDef()

    //--------------------
    //Leitura do arquivo
    //--------------------
    readNdFile(cCompPth)

    nTamJson := len(oJson[#'conteudo'])
    nTamStr  := len(aStrDef)

    //-----------------------
    //Numero do despachante
    //-----------------------
    cNumDesp := padr(alltrim(superGetMv("ES_FIDESPC", .F., "")), tamSx3("Y5_COD")[1])

    if nTamJson > 0
        cHawb := oJson[#"conteudo"][1][#'WD_HAWB']
        //----------------------
        //Validação do processo
        //----------------------
        dbSelectArea("SW6")
        SW6->(dbSetOrder(1))
        if !SW6->(dbSeek(xFilial("SW6")+ Avkey(cHawb,"W6_HAWB")))
            lRet := .F.
            cErroExec += "Processo de embarque "+alltrim(cHawb)+" não existe na base ."+CRLF
        endif

        SW6->(dbCloseArea())
        
        dbSelectArea("SY5")
        SY5->(dbSetOrder(1))
        SY5->(DbSeek(xFilial("SY5")+ cNumDesp))

        nIndJson := 1

        while nIndJson <= nTamJson .and. lRet
            if (lRet := validDesp(nIndJson, @lInsere, @cErroExec))

                reclock("SWD", lInsere)

                SWD->WD_FILIAL := xFilial ("SWD")

                for nIndStr := 1 to nTamStr
                    if 'ADIANTAMENTO'  ==  aStrDef[nIndStr][1]
                        SWD->WD_BASEADI := iif(upper(oJson[#"conteudo"][nIndJson][#aStrDef[nIndStr][1]])=='S', "1", "2")
                    else
                        SWD->&(aStrDef[nIndStr][1]) := oJson[#"conteudo"][nIndJson][#aStrDef[nIndStr][1]]
                    endif
                next nIndStr

                SWD->WD_INTEGRA := .T.
                SWD->WD_FORN    := SY5->Y5_FORNECE
                SWD->WD_LOJA    := SY5->Y5_LOJAF

                SWD->(msUnlock())
            endif
            nIndJson++
        enddo
        
        SY5->(dbCloseArea())
        SWD->(dbCloseArea())
    endif
    //-------------------
    //Restaura filial
    //-------------------
    cFilAnt    := cFilBkp

    //-----------------------------------------
    //Replicação das mensagens de erro
    //----------------------------------------
    cErrorFile += cErroExec   


    freeObj(oJson)
    aSize(aStrDef,0)

return {lRet, cErroExec, cErrorFile, .F.}


//-------------------------------------------------------------------
/*/{Protheus.doc} validDesp
Valida as informações de despesa.
@author  marcio.katsumata
@since   27/10/2019
@version 1.0
@param   nIndJson, numeric, indice do JSON
@param   lInsere , logical, insere na tabela SWD ou altera?
@return  despesa, válida?
/*/
//-------------------------------------------------------------------
static function validDesp(nIndJson, lInsere, cErroExec)
    local lRet as logical
    local cDesp as character
    local cHawb as character

    lInsere := .T.
    lRet    := .T.
    cDesp   := oJson[#"conteudo"][nIndJson][#'WD_DESPESA']
    cHawb   := oJson[#"conteudo"][nIndJson][#'WD_HAWB']
    cDtDesp := oJson[#"conteudo"][nIndJson][#'WD_DES_ADI']

    dbSelectArea("EIC")
    EIC->(DbSetOrder(1))
    //-----------------------
    //Validações de despesas
    //-----------------------
    If cDesp $ '102,103' 
        lRet := .F.
        cErroExec += "Despesa inválida :"+cDesp+CRLF
    EndIf

    //Validação de data da despesa
    If empty(cDtDesp)
        lRet := .F.
        cErroExec += "Data inválida para a despesa :"+cDesp+CRLF
    EndIf

    dbSelectArea("SWD")
    SWD->(DbSetOrder(1))
    IF SWD->(DbSeek(xFilial()+Avkey(cHawb,"W6_HAWB")+Avkey(cDesp,"WD_DESPESA") )) 
        lInsere := .F.
        if !empty(SWD->WD_DOC)
            lRet := .F.
            cErroExec += "Despesa inválida, existe nota para a despesa:"+cDesp+CRLF
        endif
        IF EIC->(DbSeek(xFilial("EIC")+Avkey(cHawb,"W6_HAWB")+AvKey(cDesp,"EIC_DESPES") ))       
            IF !EMPTY(SWD->WD_CTRFIN1)
                If EasyGParam("MV_EASYFIN",,"N") == "S"
                    lRet := .F.
                    cErroExec += "Despesa inválida, existe título para a despesa :"+cDesp+CRLF
                EndIf
            EndIF
        ENDIF
    EndIF

return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} readNdFile
Realiza a leitura do arquivo antes para verificar as linhas de despesa.
@author  marcio.katsumata
@since   24/10/2019
@version 1.0
@param   cFile, characte, arquivo
@return  nil, nil
/*/
//-------------------------------------------------------------------
static function readNdFile(cFile) 

    local cLineRead as character //Linha do arquivo
    local nHandle   as numeric
    local oJsonAux as object
    local nIndStr as numeric

    nHandle  := FT_FUse(cFile)
 
    If nHandle <= 0 
      Return
    Endif

 
    While !(FT_FEOF())
       cLineRead := FT_FREADLN()
        
        //Linhas da despesa
        if substr(cLineRead,1,2) == "DE"

            //Json object auxiliar 
            oJsonAux := JsonBld():new()

            for nIndStr := 1 to len(aStrDef)

                xValue := substr(cLineRead, aStrDef[nIndStr][3], aStrDef[nIndStr][4])
                //-------------------------------
                //Se o valor é numérico, realiza
                //a conversão
                //-------------------------------
                if aStrDef[nIndStr][2] == 'N'
                    xValue := val(xValue)
                //-------------------------------
                //Se o valor é data, realiza
                //a conversão
                //-------------------------------
                elseif aStrDef[nIndStr][2] == 'D'    
                    xValue := stod(substr(xValue, 5,4)+substr(xValue,3,2)+substr(xValue,1,2))
                endif

                oJsonAux[#aStrDef[nIndStr][1]] := xValue


            next nIndStr

            aadd(oJson[#'conteudo'],oJsonAux )
        endif
        FT_FSKIP( )
    Enddo
   
    FT_FUSE( )

return


//-------------------------------------------------------------------
/*/{Protheus.doc} getStrDef
Resgata o layout do arquivo
@author  marcio.katsumata
@since   27/10/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function getStrDef()

    
    /*
    ***********************layout da linha DE******************************
    Campo                                          Tamanho          Posição
    TIPO DO REGISTRO                                 2                 1
    NR. DO PROCESSO                                  18                3
    DATA DO PAGAMENTO                                8                 21
    CÓDIGO DA DESPESA                                3                 29
    VALOR DA DESPESA                                 17(decimal 2)     32
    EFETIVO OU PREVISTO                              1                 49
    DESPESA PAGA PELO DESPACHANTE OU IMPORTADOR      1                 50
    ADIANTAMENTO (S/N)                               1                 51
    FILLER                                           277               52
    */

    aadd(aStrDef, {"WD_HAWB"      ,"C",3, 18})
    aadd(aStrDef, {"WD_DES_ADI"   ,"D",21,8})
    aadd(aStrDef, {"WD_DESPESA"   ,"C",29,3})
    aadd(aStrDef, {"WD_VALOR_R"   ,"N",32,17,2})
    aadd(aStrDef, {"WD_PAGOPOR"   ,"C",50,1})
    aadd(aStrDef, {"ADIANTAMENTO" ,"C",51,1})
  

return
