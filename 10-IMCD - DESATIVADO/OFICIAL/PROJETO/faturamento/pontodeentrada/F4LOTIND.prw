#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} F4LOTIND
Ordenação de Lotes
Ponto de Entrada que altera a ordenação padrão apresentada na lista de 
lotes com saldo para o produto consultado.Ex.: Permite ordernar os 
lotes no carregamento da consulta pela data de validade
.Localização: Function F4LOTE - Função responsável pela consulta 
aos Saldos do Lotes da Rastreabilidade
Utilizado para adicionar o campo B8_XOBS
@author  marcio.katsumata
@since   04/02/2020
@version 1.0
@param   PARAMIXB[1], array, valores das colunas que serão apresentadas
                             em tela.

@return  array, valores das colunas que serão apresentadas em tela.
@see     https://tdn.totvs.com/pages/releaseview.action?pageId=6087889
/*/
//-------------------------------------------------------------------
user function F4LOTIND()

    local aVetorF4 as array

    aVetorF4 := PARAMIXB[1]

    
    aEval(aVetorF4, {|aLote|aadd(aLote, U_ordF4Lot(aLote))})

return aVetorF4

//-------------------------------------------------------------------
/*/{Protheus.doc} ordF4Lot
Função para resgatar o valor do campo B8_XOBS
@author  marcio.katsumata
@since   04/02/2020
@version 1.0
@param   aLote, array, informações dos campos que são apresentas em tela
@return character, valor do campo B8_XOBS
/*/
//-------------------------------------------------------------------
user function ordF4Lot(aLote)

    local cAliasTrb as character
    local cObserv   as character


    cAliasTrb := getNextAlias()
    cObserv   := ""

    beginSql alias cAliasTrb
        SELECT SB8.B8_XOBS 
        FROM %table:SB8% SB8
        WHERE SB8.B8_FILIAL  = %exp:xFilial("SB8")% AND
              SB8.B8_PRODUTO = %exp:aLote[2]%       AND
              SB8.B8_LOTECTL = %exp:aLote[1]%       AND
              TRIM(SB8.B8_XOBS) IS NOT NULL         AND
              SB8.%notDel% 
    endSql

    if (cAliasTrb)->(!eof())
        cObserv := alltrim((cAliasTrb)->B8_XOBS)
    endif

return cObserv