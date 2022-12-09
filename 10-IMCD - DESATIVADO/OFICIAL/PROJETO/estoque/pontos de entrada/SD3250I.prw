#include 'totvs.ch'


/*/{Protheus.doc} SD3250I
Atualizações das tabelas de apontamento de produção.
Executado na função A250Atu(), rotina responsável 
pela atualização das tabelas de apontamentos de produção 
simples.DESCRIÇÃO : Após atualização dos arquivos na rotina 
de produções. Executa após atualizar SD3, SB2, SB3 e SC2.
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
    //Realiza o acerto da data de fabricação de lotes
    //originados do processo de produção
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
