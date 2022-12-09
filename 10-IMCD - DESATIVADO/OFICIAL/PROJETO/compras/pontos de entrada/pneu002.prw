#include 'protheus.ch'


/*/{Protheus.doc} PNEU002
LOCALIZAÇÃO : Function A103NFORI() - Responsável por fazer 
a chamada da Tela de Consulta a NF original.
EM QUE PONTO : O ponto de entrada PNEU002 e utilizado após 
a chamada da Tela de Consulta a NF.
@type function
@version 1.0
@author marcio.katsumata
@since 02/07/2020
@return nil, nil
@see    https://tdn.totvs.com/display/public/PROT/PNEU002
/*/
user function PNEU002()

    local aAreas as array
    local nPosNfO as numeric
    local nPosSerO as numeric
    local nPosItmO as numeric
    local nPosProd as numeric
    local nPosDtFab as numeric
    local nPosDFab as numeric
    local cNf as character
    local cSerie as character
    local cItem as character
    local cProd as character

    aAreas := {SD2->(getArea()), getArea()}

    nPosNfO  := aScan(aHeader, {|aHead|alltrim(aHead[2])=="D1_NFORI"})
    nPosSerO := aScan(aHeader, {|aHead|alltrim(aHead[2])=="D1_SERIORI"})
    nPosItmO := aScan(aHeader, {|aHead|alltrim(aHead[2])=="D1_ITEMORI"})
    nPosProd := aScan(aHeader, {|aHead|alltrim(aHead[2])=="D1_COD"})
    nPosDFab := aScan(aHeader, {|aHead|alltrim(aHead[2])=="D1_DFABRIC"})


    if nPosNfO > 0 .and. nPosSerO > 0 .and. nPosItmO > 0 .and. nPosProd > 0 .and.;
       type("cA100For") <> "U" .and. type("cLoja") <> "U"

        cNf    := aCols[n][nPosNfO]
        cSerie := aCols[n][nPosSerO]
        cItem  := aCols[n][nPosItmO]
        cProd  := aCols[n][nPosProd]

        //------------------------------------------------------
        //Posiciona na nota origem para regstar informações da
        //data de fabricação do lote
        //-------------------------------------------------------
        SD2->(dbSetOrder(3))
        if SD2->(dbSeek(xFilial("SD2")+cNf+cSerie+cA100For+cLoja+cProd+cItem))

            if nPosDFab > 0  .and. !empty(SD2->D2_DFABRIC)
                aCols[n][nPosDFab]  := SD2->D2_DFABRIC
            elseif nPosDFab > 0 
                dbSelectArea("SB8")
                SB8->(dbSetOrder(3))
                if SB8->(dbSeek(xFilial("SB8")+SD2->(D2_COD+D2_LOCAL+D2_LOTECTL)))
                    aCols[n][nPosDFab]  := SB8->B8_DFABRIC
                endif
            endif

        endif
    endif
    
    aEval(aAreas, {|aArea| restArea(aArea)})
    aSize(aAreas,0)

return
