#include 'protheus.ch'


/*/{Protheus.doc} MT120ISC
Ponto de entrada que manipula o acols 
do pedido de compras após a seleção da 
solicitação de compra
@type function
@version 1.0
@author marcio.katsumata
@since 08/04/2020
@return nil, nil
/*/
user function MT120ISC()

    local aAreaSE4  as array
    local nPosPreco as numeric
    local nPosTotal as numeric
    local nPosTab   as numeric

    //-------------------------------
    //Origem = Solicitação de compra
    //-------------------------------
    If nTipoPed !=	2
    
        aCols[n][gdFieldPos("C7_XITEMCT")] := SC1->C1_XITEMCT

        aAreaSE4 := SE4->(getArea())

        //---------------------------------------------------
        //Verifica o preço, total e código da tabela de preço
        //----------------------------------------------------
        nPosPreco := aScan(aHeader, {|aCampo|trim(aCampo[2]) == "C7_PRECO"})
        nPosTotal := aScan(aHeader, {|aCampo|trim(aCampo[2]) == "C7_TOTAL"})
        nPosTab   := aScan(aHeader, {|aCampo|trim(aCampo[2]) == "C7_CODTAB"})

        aCols[n][nPosPreco] := SC1->C1_PRECO
        aCols[n][nPosTotal] := SC1->C1_TOTAL
        aCols[n][nPosTab]   := SC1->C1_XTABPRC

        //-------------------------------------------------
        //Verfica a condição de pagamento e a sua descrição
        //--------------------------------------------------
        if !empty(SC1->C1_CONDPAG)
            dbSelectArea("SE4")
            SE4->(dbSetOrder(1))
            if SE4->(dbSeek(xFilial("SE4")+SC1->C1_CONDPAG))
                cCondicao := SC1->C1_CONDPAG
                cDescCond := SE4->E4_DESCRI
            endif
        endif

        //----------------------------------------
        //Verifica a moeda e sua descrição
        //----------------------------------------
	    if !empty(SC1->C1_MOEDA) 
            nMoedaPed := SC1->C1_MOEDA 
            A120DescMoed(nMoedaPed,nil,@cDescMoed,@nTxMoeda,nil)
        endif

        //----------------------------------------------
        //Verifica o fornecedor e o seu código de loja
        //-----------------------------------------------
        iif(!empty(SC1->C1_FORNECE), cA120Forn := SC1->C1_FORNECE, "" )
        iif(!empty(SC1->C1_LOJA)   , cA120Loj  := SC1->C1_LOJA   , "" )

        

        restArea(aAreaSE4)
        aSize(aAreaSE4,0)
    endif

return
