#include 'protheus.ch'


/*/{Protheus.doc} F4LOTIND
Ponto de Entrada que altera a ordenação padrão apresentada na 
lista de lotes com saldo para o produto consultado.Ex.: Permite 
ordernar os lotes no carregamento da consulta pela data de validade.
Localização: Function F4LOTE - Função responsável pela consulta aos 
Saldos do Lotes da Rastreabilidade.
Eventos
Após o carregamento dos lotes com saldo para o produto consultado, 
antes de apresentar as informações da consulta na tela.
@type function
@version 1.0
@author marcio.katsumata
@since 13/04/2020
@return array, lotes
/*/
user function F4LOTIND()

    local aF4Lot as array
    local lPedido as logical
    local lLiberacao as logical
    local nIndLot as numeric
    local nItemPos as numeric
    local nProdPos as numeric
    local nLocalPos as numeric
    local nQtdPos as numeric
    local nIndCmp as numeric

    lPedido := isInCallStack("MATA410")



    aF4Lot := PARAMIXB[1]

    if lPedido
        //-----------------------------------
        //Verifica a posição de cada campo
        //-----------------------------------
        nItemPos := aScan(aHeader, {|aCampo| alltrim(aCampo[2]) == "C6_ITEM"})
        nProdPos := aScan(aHeader, {|aCampo| alltrim(aCampo[2]) == "C6_PRODUTO"})
        nLocalPos := aScan(aHeader, {|aCampo| alltrim(aCampo[2]) == "C6_LOCAL"})
        nQtdPos := aScan(aHeader, {|aCampo| alltrim(aCampo[2]) == "C6_QTDVEN"})

        for nIndLot := 1 to len(aF4Lot)
            //------------------------------------------
            //Realiza a validação de shelf life do lote 
            //------------------------------------------
            if !U_ValidaShelfLife(M->C5_CLIENTE, M->C5_LOJACLI,M->C5_NUM, aCols[n][nItemPos],aCols[n][nProdPos],aCols[n][nLocalPos], aF4Lot[nIndLot][1], aCols[n][nQtdPos],.T.)
                //--------------------------------------
                //Caso exista mais de um lote no array
                //realizar a remoção desse lote dentro
                //do array
                //--------------------------------------
                if len(aF4Lot) > 1
                    aDel(aF4Lot,nIndLot)
                    aSize(aF4Lot, len(aF4Lot)-1)
                else
                    //--------------------------------------------
                    //Caso exista apenas esse lote no array
                    //realizar apenas a limpeza das informações
                    //referente ao lote
                    //--------------------------------------------
                    for nIndCmp := 1 to len(aF4Lot[nIndLot])
                        DO CASE
                            CASE valType(aF4Lot[nIndLot][nIndCmp]) == 'C'
                                aF4Lot[nIndLot][nIndCmp] := ""
                            CASE valType(aF4Lot[nIndLot][nIndCmp]) == 'D'
                                aF4Lot[nIndLot][nIndCmp] := stod("")
                            CASE valType(aF4Lot[nIndLot][nIndCmp]) == 'N'
                                aF4Lot[nIndLot][nIndCmp] := 0
                        ENDCASE

                    next nIndCmp

                endif
            endif

        next nIndLot

    endif

return aF4Lot