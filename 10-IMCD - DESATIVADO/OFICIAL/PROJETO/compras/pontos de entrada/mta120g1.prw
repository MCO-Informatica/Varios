#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} MTA120G1
Tem o objetivo de manipular um Array contendo variáveis de qualquer 
tipo para passar como parâmetro para os pontos de entrada MTA120G2 
e MTA120G3,que se encontram no laço de gravação dos itens do pedido
de compras e pode ser usado para gravar as informações contidas nas 
variáveis deste array nos itens do pedido.
@uso     Este ponto de entrada foi criado para controlar a recriação 
         da alçada de aprovações em alterações de determinados campos
         parametrizáveis pelo parâmetro ES_MT120G1
@author  marcio.katsumata
@since   29/07/2019
@version 1.0
@param   PARAMIXB, array,{cA120Num , l120Inclui, l120Altera, l120Deleta }
@return  array, informações a serem consumidas pelos pontos de entrada
                MTA120G2, MTA120G3.
@see     http://tdn.totvs.com/pages/viewpage.action?pageId=6085571
/*/
//-------------------------------------------------------------------
user function MTA120G1()
    local   cCodFor     as character //Código do fornecedor        
    local   cCodLoja    as character //Código da loja        
    local   aFieldsAlt  as array     //Vetor com os campos que devem ser checados    
    local   aAreaSC7    as array     //Posicionamento do alias SC7    
    local   cChvSC7     as character //Chave SC7        
    local   nInd        as numeric   //Indice      
    private aRet        as array     //Retorno 
    
    if type('lMTA120G1') == 'U'
        public lMTA120G1 := .F.
        public aMTA120G1 := array(2)
        aMTA120G1[1] := {}
        aMTA120G1[2] := {}
    else
        lMTA120G1 := .F.
        aMTA120G1 := array(2)
        aMTA120G1[1] := {}
        aMTA120G1[2] := {}
    endif

    //------------------------------------------------------------------
    //Armazena todos os recnos da SCR referente ao pedido posicionado
    //para posteriormente não considerar no recall de registros.
    //------------------------------------------------------------------
    if !Inclui

        getScrRecs()

    endif
    //----------------------------
    //Inicializando variáveis
    //----------------------------
    cCodFor     := cA120Forn
    cCodLoja    := cA120Loj
    aFieldsAlt  := StrTokArr2(supergetMv("ES_MT120G1", .F., "C7_PRODUTO/C7_QUANT/C7_PRECO/C7_TOTAL"),"/", .F.)
    aAreaSC7    := SC7->(getArea())
    cChvSC7     := ""
    nInd        := 1
    aRet        := {}

    SC7->(DbSetOrder(1))
    if SC7->(DbSeek(xFilial('SC7')+cA120Num))
        cChvSC7 := xFilial('SC7')+cA120Num


        //Estrutura do array de retorno
        //[1] - Codigo Fornecedor
        //[2] - Loja do fornecedor
        //[3] - Itens  a serem verificados
        //  [...] - Valores do aFieldsAlt
        aadd(aRet, SC7->C7_FORNECE)
        aadd(aRet, SC7->C7_LOJA)

        aadd(aRet, {})

        while SC7->(C7_FILIAL+C7_NUM) == cChvSC7
            aadd(aRet[3], {})
            aadd(aRet[3][nInd], SC7->(recno()))
            aadd(aRet[3][nInd], SC7->C7_CONAPRO)
            aEval(aFieldsAlt, {|cField| aadd(aRet[3][nInd], SC7->&(cField))})
            SC7->(dbSkip())
            nInd++
        enddo
    endif
    //-------------------
    //Restaurando area
    //-------------------
    restArea(aAreaSC7)

    //-------------------
    //Limpeza de arrays
    //-------------------
    aSize(aFieldsAlt,0)
    aSize(aAreaSC7,0)

return  aRet

/*/{Protheus.doc} getScrRecs
Função para retornar recnos da SCR de um determinado
pedido.
@type function
@version 1.0
@author marcio.katsumata
@since 27/10/2020
@return nil, nil
/*/
static function getScrRecs()
    local cQuery as character
    local cAliasTrb as character

    cAliasTrb = getNextAlias()
    
    cQuery := " SELECT SCR.R_E_C_N_O_ AS REGISTROS , SCR.D_E_L_E_T_ AS DELETED FROM " +RetSqlName("SCR")+ " SCR "
    cQuery += " INNER JOIN "+retSqlName("SC7")+" SC7 ON(SC7.C7_NUM ='"+SC7->C7_NUM+"' "
    cQuery += " AND SC7.C7_FILIAL ='"+xFilial("SC7")+"'AND SC7.D_E_L_E_T_ = ' ' AND SC7.C7_CONAPRO = 'B' )"
    cQuery += " WHERE SCR.CR_NUM  = '"+SC7->C7_NUM+"' AND SCR.CR_FILIAL= '"+xFilial("SCR")+"' "

    DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery ),cAliasTrb,.T.,.F.)

    
    while (cAliasTrb)->(!eof())
        //--------------------------------------------------------------
        //Separa os registros removidos logicamente , dos não removidos.
        //--------------------------------------------------------------
        if (cAliasTrb)->DELETED <> "*"
            aadd(aMTA120G1[1], cValToChar((cAliasTrb)->REGISTROS))
        else
             aadd(aMTA120G1[2], cValToChar((cAliasTrb)->REGISTROS))
        endif

        (cAliasTrb)->(dbSkip())
    enddo


    (cAliasTrb)->(dbCloseArea())
return
