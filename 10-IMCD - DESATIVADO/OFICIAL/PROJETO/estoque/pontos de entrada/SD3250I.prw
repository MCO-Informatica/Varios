#include 'totvs.ch'


/*/{Protheus.doc} SD3250I
Atualiza��es das tabelas de apontamento de produ��o.
Executado na fun��o A250Atu(), rotina respons�vel 
pela atualiza��o das tabelas de apontamentos de produ��o 
simples.DESCRI��O : Ap�s atualiza��o dos arquivos na rotina 
de produ��es. Executa ap�s atualizar SD3, SB2, SB3 e SC2.
@type function
@version  1.0
@author marcio.katsumata
@since 19/04/2021
@return nil, nil
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6087850
/*/
user function SD3250I()

    local cNumOp as character
    local aAreas as array


    //-------------------------------------------------
    //Realiza o acerto da data de fabrica��o de lotes
    //originados do processo de produ��o
    //-------------------------------------------------
    aAreas := {SD3->(getArea()), SB8->(getArea()), getArea()}
    cNumOp := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)

    dbSelectArea("SD3")
    SD3->(dbSetOrder(1))

    dbSelectArea("SB8")
    SB8->(dbSetOrder(3))

    if SD3->(dbSeek(xFilial("SD3")+padr(cNumOp,tamSx3("D3_OP")[1])+SC2->C2_PRODUTO))

        if SB8->(dbSeek(xFilial("SB8")+SD3->(D3_COD+D3_LOCAL+D3_LOTECTL)))
            recLock("SB8", .F.)
            SB8->B8_DFABRIC := SC2->C2_DTFABRI
            SB8->B8_DTFABRI := SC2->C2_DTFABRI
            SB8->(msUnlock())
        endif

    endif
    
    //-------------------------
    //Restaura areas de tabelas
    //--------------------------
    aEval(aAreas, {|aArea|restArea(aArea)})
    aSize(aAreas,0)

return 
