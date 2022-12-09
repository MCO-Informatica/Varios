#include 'protheus.ch'


/*/{Protheus.doc} MTGRVLOT
Altera Informações do Lote
LOCALIZAÇÃO : Function CriaLote() - Cria lote para um produto.
Function CriaLote2() - Cria Lote/Sub-lote para um produto.
EM QUE PONTO : Utilizado após a gravação do lote ('Tabela SB8') para alterar informações do lote criado.
@type function
@version 1.0
@author marcio.katsumata
@since 18/09/2020
@return nil, nil
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=6089438
/*/
user function MTGRVLOT()


    local aAreas as array

    aAreas := {getArea(), SB8->(getArea())}

    //Atualiza o campo B8_XOBS
    atualizaObs()

    aEval(aAreas, {|aArea| restArea(aArea)})
    aSize(aAreas,0)


return


/*/{Protheus.doc} atualizaObs
Atualiza o campo B8_XOBS se existir registros com este
campo preenchido.
@type function
@version 1.0
@author marcio.katsumata
@since 18/09/2020
@return nil, nil
/*/
static function atualizaObs()
    local cAliasTrb as character


    cAliasTrb := getNextAlias()

    beginSql alias cAliasTrb
        SELECT  SB8.B8_XOBS
        FROM %table:SB8% SB8
        WHERE SB8.B8_PRODUTO = %exp:SB8->B8_PRODUTO% AND
              SB8.B8_LOTECTL = %exp:SB8->B8_LOTECTL% AND
              trim(SB8.B8_XOBS) IS NOT NULL          AND 
              SB8.%notDel%
    endSql


    if (cAliasTrb)->(!eof())

        reclock("SB8", .F.)
        SB8->B8_XOBS := (cAliasTrb)->B8_XOBS
        SB8->(msUnlock())

    endif

    (cAliasTrb)->(dbCloseArea())

return 
