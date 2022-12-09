#include 'protheus.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} LP678
Fonte acionado pela LP678.
Parâmetro - "VALOR" - Retorna o custo da nota fiscal de origem da 
consignação e multiplica pela quantidade da NF para retornar o valor 
para a LP.
@author  marcio.katsumata
@since   25/09/2019
@version 1.0
@param   cParam, character, ponto  
@return  any, retorno 
/*/
//-------------------------------------------------------------------


user function LP678(cParam)
    local xValue
    local cChave    as character
    local aAreaSD2  as array
    local nVlrUnMed as numeric
    local nQtdAtu   as numeric
    local cChaveSD2 as character

    do case 
        //-----------------------------------
        //Acionado pelo campo de valor da LP
        //-----------------------------------
        case cParam == 'VALOR'

            //-------------------------------------
            //Salva o posicionamento do alias atual
            //-------------------------------------
            aAreaSD2 := SD2->(getArea())

            //----------------------
            //Quantidade
            //----------------------
            nQtdAtu := SD2->D2_QUANT

            //----------------------------
            //Montagem a chave da SD2 para
            //posicionar na nota fiscal de 
            //origem de consignação
            //----------------------------
            SD2->(dbSetOrder(3))

            cChaveSD2 := SD2->D2_FILIAL
            cChaveSD2 += PADR(SD2->D2_XNFORI,tamSx3("D2_DOC")[1])
            cChaveSD2 += PADR(SD2->D2_XSERORI,tamSx3("D2_SERIE")[1])
            cChaveSD2 += SD2->(D2_CLIENTE+D2_LOJA)        
            cChaveSD2 += SD2->D2_COD  

            //----------------------------------------------
            //Posiciona e realiza o calculo do custo médio
            //e retorna para a LP
            //----------------------------------------------
            if SD2->(dbSeek(cChaveSD2))
                nVlrUnMed := SD2->D2_CUSTO1/SD2->D2_QUANT
                xValue    := ROUND(nQtdAtu * nVlrUnMed, tamSx3("CT2_VALOR")[1])
            else
                xValue := 0
            endif
    endCase    
    //---------------------------------
    //Restaura o posicionamento da SD2
    //---------------------------------
    restArea(aAreaSD2)

return xValue