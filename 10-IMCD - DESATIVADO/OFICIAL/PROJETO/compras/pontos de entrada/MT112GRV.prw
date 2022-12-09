#include 'protheus.ch'


/*/{Protheus.doc} MT112GRV
Responsável por gerar os arquivos p/ importacoes conforme os itens.
EM QUE PONTO : Apos a gravacao de cada item da Solicitacao de Importacao.
Executado apenas para o primeiro item de cada SC1 processada.
@type function
@version 1.0
@author marcio.katsumata
@since 19/03/2020
@return nil, nil
@see    https://tdn.totvs.com/display/public/PROT/MT112GRV
/*/
user function MT112GRV()
    local cAliasSYF as character
    local cCondPag as character


    cAliasSYF := getNextAlias()
    cCondPag  := ""

    beginSql alias cAliasSYF
        SELECT YF_MOEDA FROM %table:SYF% WHERE YF_MOEFAT = %exp:SC1->C1_MOEDA% AND %notDel%
    endSql

    
    reclock("SW0", .F.)
    if (cAliasSYF)->(!eof())
        SW0->W0_MOEDA := (cAliasSYF)->YF_MOEDA
    endif
    SW0->W0_XINCOTE := SC1->C1_XINCOTE
    SW0->W0_XVIAEMB := SC1->C1_XVIAEMB

    //----------------------------------------------
    //Verifica o código da condição de pagamento EIC
    //-----------------------------------------------
    cCondPag := SC1->C1_XCONPAG

    if !empty(cCondPag)
        SW0->W0_XCONDPG := cCondPag
    endif

    SW0->(msUnlock())

    (cAliasSYF)->(dbCloseArea())

return