#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} MTA120G3
LOCALIZAÇÃO : Function A120GRAVA - Função responsável pela gravação
do Pedido de Compras e Autorização de Entrega.
EM QUE PONTO : Na função A120GRAVA executado após a gravação de cada
item do pedido de compras recebe como parametro o Array manipulado 
pelo ponto de entrada MTA120G1 e pode ser usado para gravar as 
informações deste array no item do pedido posicionado.
@uso     Este ponto de entrada foi criado para controlar a recriação 
         da alçada de aprovações em alterações de determinados campos
         parametrizáveis pelo parâmetro ES_MT120G1
@author  marcio.katsumata
@since   29/07/2019
@version 1.0
@param   PARAMIXB, array,Array contendo como estrutura: 
                        {aArrayG1 , lGeraSCR } aArrayG1 := Parametro retornado 
                        pelo ponto de entrada MTA120G1 executado antes 
                        de comecar a gravar os itens do Pedido de Compra.
                        / lGeraSCR := Variavel logica que indica se foi 
                        gerado arquivo de alçadas tabela SCR.
@return  boolean, .T. => Será gerado o bloqueio (SCR)
                  .F. => Não será gerado o bloqueio (SCR)
@see     http://tdn.totvs.com/pages/releaseview.action?pageId=6085573
/*/
//-------------------------------------------------------------------
user function MTA120G3()
    local   cCodFor     as character //Código fornecedor       
    local   cCodLoja    as character //Loja fornecedor       
    local   aAreaSC7    as array     //Posicionamento do alias SC7     
    local   cChvSC7     as character //Chave SC7       
    local   lSCRGera    as logical   //Flag de geração da SCR vinda do padrão     
    local   nTamPre     as numeric   //Tamanho do array aRetG1, array retornado do PE MTA120G1    
    local   lValida     as logical   //Realiza a validação 
    local   nAtivos     as numeric   //Contador de linhas ativas na GRID
    local   nTamCols    as numeric 
    local   lTolEic     as logical   //Fator de tolerância alteração de quantidade PO.
    local   nInd        as numeric   //Indice     
    local   nIndAlt     as numeric   //Indice     
    private aPreValue   as array     //Array retorno do PE MTA120G1, aRetG1   
    private lRet        as logical   //Retorno da função    
    private aFieldsAlt  as array     //Vetor com os campos que devem ser checados

    default lMTA120G1 := .f.

    //----------------------------
    //Inicializando variáveis
    //----------------------------
    aPreValue   := PARAMIXB[1]   
    lSCRGera    := PARAMIXB[2]      
    cCodFor     := cA120Forn
    cCodLoja    := cA120Loj
    aFieldsAlt  := StrTokArr2(supergetMv("ES_MT120G1", .F., "C7_PRODUTO/C7_QUANT/C7_PRECO/C7_TOTAL"),"/", .F.)
    nTolerance  := supergetMv("ES_MT120TL", .F., 10)
    aAreaSC7    := SC7->(getArea())
    cChvSC7     := ""
    nInd        := 1
    lRet        := .F.
    nTamCols    := len(aCols)
    lValida     := .T.
    nAtivos     := 0
    lTolEic     := .F.
    //---------------------------------------------------------
    //Realiza validação se algum item foi removido,
    //se foi removido, não realiza validação de geração da SCR
    //---------------------------------------------------------
    if Altera .and.  !lMTA120G1
        for nInd := 1 to nTamCols
            if aCols[nInd][len(aCols[nInd])] 
                lValida := .F.
            endif
        next nInd
        if isInCallStack("EICPO400")
            dbSelectArea("SB1")
            SB1->(DbSetOrder(1))
            if SB1->(dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)) .and. (SB1->B1_EMB $ "ISO/G01")
                lTolEic := .T. 
            endif
        endif
    else
        if type("inclui") == 'L' .and. Inclui 
            lValida     := .F.
        endif
    endif


    //------------------------------------------------------------------
    //Checagem do tamanho do array retornado do PE MTA120G1
    //------------------------------------------------------------------
    if len(aPreValue) == 3 .and. lValida .and. !lMTA120G1

        if lSCRGera 
            //-----------------------------------------------------------------
            //Tamanho da terceira posição do array referente aos itens da grid
            //-----------------------------------------------------------------
             nTamPre := len(aPreValue[3])
            //--------------------------------------------------------------
            //Realiza checagem de alteração do código e loja do fornecedor
            //--------------------------------------------------------------
            lRet := (aPreValue[1] <> SC7->C7_FORNECE .OR. aPreValue[2] <> SC7->C7_LOJA )

            //-------------------------------------------------------------------------------
            //Verifica se houve alterações nos campos determinados pelo parâmetro ES_MT120G1
            //-------------------------------------------------------------------------------

            nInd := aScan (aPreValue[3], {|aItens| aItens[1] == SC7->(recno())})
            if nInd > 0
                for nIndAlt := 1 to len(aFieldsAlt)
                    if aFieldsAlt[nIndAlt] $ "C7_QUANT/C7_TOTAL" .and. lTolEic 
                        if SC7->&(aFieldsAlt[nIndAlt]) <> aPreValue[3][nInd][nIndAlt+2] 
                            nPercAlt := abs(((SC7->&(aFieldsAlt[nIndAlt])  * 100) /aPreValue[3][nInd][nIndAlt+2] ) - 100)
                            lRet     := nTolerance < nPercAlt
                        endif
                    else
                        iif(aPreValue[3][nInd][nIndAlt+2] <> SC7->&(aFieldsAlt[nIndAlt]) .and. lSCRGera, lRet := .T., "")
                    endif
                next nIndAlt
            else
                lRet := .T.
            endif
        else
            lRet := .F.
        endif


        if lRet
            lMTA120G1 := lRet
        endif
    
        if lSCRGera
            SC7->(dbSetOrder(1))
            SC7->(dbSeek(xFilial("SC7")+SC7->C7_NUM))
            cChvSC7 := xFilial("SC7")+SC7->C7_NUM
            while SC7->(C7_FILIAL+C7_NUM) == cChvSC7
                nInd := aScan (aPreValue[3], {|aItens| aItens[1] == SC7->(recno())})
                if nInd > 0
                    reclock("SC7", .F.)
                    SC7->C7_CONAPRO := iif(!lMTA120G1, aPreValue[3][nInd][2], "B")
                    SC7->(msUnlock())
                endif
                SC7->(dbSkip())
            enddo
        endif
    else
        lMTA120G1 := lSCRGera
    endif
    
    //-------------------
    //Restaurando area
    //-------------------
    restArea(aAreaSC7)
    //------------------
    //Limpeza de arrays
    //------------------
    aSize(aFieldsAlt,0)
    aSize(aAreaSC7,0)
return  lMTA120G1
