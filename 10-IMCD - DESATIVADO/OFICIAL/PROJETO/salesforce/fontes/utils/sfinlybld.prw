#include 'protheus.ch'
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} SFINLYBLD
Classe de montagem do JSON e gravação dos dados nas tabelas intermediaria
de integração de arquivos de registros originados no Sales Force
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
class SFINLYBLD

    method new() CONSTRUCTOR
    method build()


endClass

//-------------------------------------------------------------------
/*/{Protheus.doc} new
Método construtor
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
/*/
//-------------------------------------------------------------------
method new() class SFINLYBLD
    

return 

//-------------------------------------------------------------------
/*/{Protheus.doc} build
Realiza a montagem do formato a ser importado para o Protheus e grava
nas tabelas de integração ZNR e ZNS para posterior cadastro via 
rotina.
@author  marcio.katsumata
@since   24/07/2019
@version 1.0
@param   cFileName, character, nome do arquivo
@param   aHeader  , array    , cabeçalho onde contem os nomes das colunas
@param   aDados   , array    , dados do arquivo SF
@return  nil, nil
/*/
//-------------------------------------------------------------------
method build(cFileName,aHeader, aDados,cXml,oXml) class SFINLYBLD


    local aDataSet  as array     //array de dados para ser gravado na tabela ZNS
    local nTamDados as numeric   //Variável que registra o tamanho do array aDados
    local oSfJson   as object    //Objeto da classe que manipula o JSON
    local aPosKey  as array      //Array com as posições das colunas chaves
    local cForm   as character   //Variável que armazena a função a ser macroexecutada para normalizar os dados
    local nTamZNQ as numeric     //Quantidade de linhas do model que armazena a tabela ZNQ
    local nInd as numeric        //Indice
    local cDisplay as character  //Conteudo chave para o usuário identificar o registro
    local nPosDisp as numeric    //Posição do conteúdo chave para o usuário identificar o registro
    local oSfIntWrt  as object   //Objeto para manipular a tabela ZNR/ZNS (tabela intermediária)
    local nIndLine  as numeric   
    private aHeadAux as array      //Array do cabeçalho de colunas utilizado de forma temporária
    private oModelLy as object     //Objeto da classe do model de layout de integração
    private cFile  as character  //Nome do arquivo 
    private cEntity as character //Nome da entidade
    private xValue               //Valor a ser gravado
    private cKey  as character   //Chave
    private nIndLine as numeric  //Indice para navegar entre as linhas da tabela ZNS
    private aDadAux  as array    //Array dos dados
    private cColumn  as character//Coluna atual
    private cRootXml as character     
    private cHeader  as character     
    private oXmlPrv  as object     
    private oCabec   as object     
    default aHeader := {}
    default aDados  := {} 
    default cXml    := ""
    
    cFile := cFileName
    cDisplay := ""
    //---------------------------------------------------------
    //Verifica se existe cadastro de layout para a entidade
    //---------------------------------------------------------
    dbSelectArea("ZNQ")
    DBEval({ || iif(alltrim(ZNQ->ZNQ_ENTITY) $ cFile .AND. ZNQ->ZNQ_ATIVO == 'S', cEntity := ZNQ->ZNQ_ENTITY,"")})



    if !empty(cEntity)
        //------------------------------
        //Posiciona no layout tabela ZNQ
        //------------------------------
        ZNQ->(dbSetOrder(1))
        ZNQ->(dbSeek(xFilial("ZNQ")+cEntity))

        //--------------------------------------------
        //Prepara o model da tabela ZNQ para consulta
        //--------------------------------------------
        oModelLy := FWLoadModel("SFINLYMOD")
        oModelLy:setOperation(MODEL_OPERATION_VIEW)
        oModelLy:activate()

        lXml := oModelLy:getValue("ZNQMASTER", "ZNQ_XML") == 'S'

        //------------------------------------------------
        //Verifica a quantidade de registros da tabela ZNQ 
        //referente à entidade posicionada
        //------------------------------------------------
        nTamZNQ := oModelLy:getModel("ZNQDETAIL"):Length()
        aDataSet  := {}

        //--------------------------------------------------
        //Prepara o model de gravação das tabelas ZNR e ZNS 
        //(tabela intermediária de integração)
        //--------------------------------------------------
        oSfIntWrt := SFINTWRT():new(ZNQ->ZNQ_ENTITY,cFileName,ZNQ->ZNQ_ALIAS)

        
        if lXml
            cRootXml     := alltrim(oModelLy:getValue("ZNQMASTER", "ZNQ_ROOT"))
            cHeader      := alltrim(oModelLy:getValue("ZNQMASTER", "ZNQ_HEAD"))
            oXmlPrv      := oXml
            oCabec       := XmlChildEx(&("oXmlPrv:"+cRootXml), cHeader) 

            for nInd := 1 to nTamZNQ 
                oModelLy:getModel('ZNQDETAIL'):goLine(nInd)
                if oModelLy:getValue("ZNQDETAIL", "ZNQ_TYPE") == 'H' 

                    if !empty(oModelLy:getValue("ZNQDETAIL", "ZNQ_CMPSF"))  .and.;
                        oModelLy:getValue("ZNQDETAIL", "ZNQ_DISPLY") == 'S'

                        xValue := &("oCabec:"+alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_CMPSF"))+":TEXT")
                        cForm   := alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_FORM1"))
                        cColumn := alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_CMPPRT"))
                        cValid  := alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_CONDIC")) 
        
                        //--------------------------------------------------
                        //Aplica a função que está dentro do campo ZNU_FORM1
                        //--------------------------------------------------
                        if !empty(cForm) 
                            xValue := &(cForm)
                        endif
    
                        cDisplay := xValue
                    endif

                ENDIF
            next


            aadd(aDataSet,  {{"ZNS_STATUS",  "1"           } ,;
                             {"ZNS_LINE  ",   1            } ,;
                             {"ZNS_JSON  ",   cXML         } ,;
                             {"ZNS_DISPLY",   cDisplay     } ,;
                             {"ZNS_CHAVE ",   ""           }} )

        else
            //---------------------
            //Inicializa variáveis
            ///--------------------
            nTamDados := len(aDados)
            aLine     := {}
            aPosKey   := {}
            nPosDisp  := 0
            cDisplay  := ""
            aDadAux   := aClone(aDados)
            cKey      := ""
            aHeadAux  := {}


            aSize(aDados,0)

            //---------------------------------------------
            //Separa apenas as colunas que serão importadas
            //para posteriormente montar o JSON
            //---------------------------------------------
            for nInd := 1 to nTamZNQ 
                oModelLy:getModel("ZNQDETAIL"):goLine(nInd)
                nPosH := aScan (aHeader,{|cColumn| alltrim(upper(cColumn)) == alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_CMPSF"))})

                iif (oModelLy:getValue("ZNQDETAIL", "ZNQ_DISPLY") == 'S', nPosDisp := nPosH, "")
                iif (oModelLy:getValue("ZNQDETAIL", "ZNQ_KEY") == 'S'   , aadd(aPosKey, nPosH), "")        

                aadd(aHeadAux, {alltrim(aHeader[nPosH]), nPosH, alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_CMPPRT"))})
            next nInd

            aSize(aHeader,0)




            //------------------------------------------------------
            //Gera o arquivo JSON de cada linha do arquivo integrado
            //e grava na tabela ZNS
            //------------------------------------------------------
            for nIndLine := 1 to nTamDados

                //-----------------------------------------------------------
                //Normaliza dados e executa formulas do layout antes da 
                //geração do JSON
                //------------------------------------------------------------
                for nInd := 1 to nTamZNQ
                    oModelLy:getModel("ZNQDETAIL"):goLine(nInd)
                    xValue :=  STRTRAN(aDadAux[nIndLine][aHeadAux[nInd][2]],'"','')
                    cForm := oModelLy:getValue("ZNQDETAIL", "ZNQ_FORM1")
                    cColumn := alltrim(oModelLy:getValue("ZNQDETAIL", "ZNQ_CMPPRT"))


                    if !empty(cForm)
                        xValue := &(cForm)
                    else
                        if valtype(xValue) == 'C'
                            xValue := PADR(xValue, tamSx3(cColumn)[1],"")
                        endif  
                    endif

                    if oModelLy:getValue("ZNQDETAIL", "ZNQ_KEY") == 'S' 
                        cKey +=  xValue
                    endif

                    aadd(aLine,xValue)

                next nInd

                //---------------------------------------
                //Geração o JSON dos dados normalizados
                //Os nomes dos atributos do JSON serão os
                //nomes das colunas Protheus
                //----------------------------------------
                oSfJson := SFJSONLY():new()
                oSfJson:build(aHeadAux, aLine)
                cJson := oSfJson:Stringify()
                oSfJson:destroy()
                freeObj(oSfJson)
                //------------------------------------
                //Gravação da tabela ZNS
                //------------------------------------
                if !empty(cJson)
                    iif (nPosDisp >0, cDisplay := strtran(aDadAux[nIndLine][nPosDisp],'"','') ,"")
                

                    aadd(aDataSet,  {{"ZNS_STATUS",  "1"           } ,;
                                     {"ZNS_LINE  ",   nIndLine     } ,;
                                     {"ZNS_JSON  ",   cJson        } ,;
                                     {"ZNS_DISPLY",   cDisplay     } ,;
                                     {"ZNS_CHAVE ",   cKey         }} )
                endif

                aSize(aLine,0)

            next nIndLine


            aSize(aDadAux,0)
            aSize(aHeadAux,0)


        endif
        //---------------------------------
        //Grava o model da tabela ZNR e ZNS
        //---------------------------------
        if !empty(aDataSet)
            oSfIntWrt:writeLine(aDataSet)
            oSfIntWrt:save()
            aSize(aDataSet,0)
        endif    
        //------------------
        //Limpeza de objetos
        //------------------
        freeObj(oSfIntWrt)
    endif


return cXML

user function sfinlybld()
return

