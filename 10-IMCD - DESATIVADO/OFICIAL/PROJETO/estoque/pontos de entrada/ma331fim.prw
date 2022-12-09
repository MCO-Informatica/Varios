#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MA331FIM
Contabilização do Recálculo do Custo Médio
MA331FIM - Este ponto de entrada é utilizado para validação da conclusão,
no processamento deContabilização do Recálculo do Custo Médio MA331Process.
@author  marcio.katsumata
@since   30/09/2019
@version 1.0
@return  boolean, ok?
@see     https://tdn.totvs.com/pages/releaseview.action?pageId=172300301
/*/
//-------------------------------------------------------------------
user function MA331FIM ()
    local lRet as logical
    local cD2Tes as character

    cD2Tes := superGetMv("ES_TESCONS", .F., "504/684")


    lRet := .T.

    //------------------------------------------------------------------
    //Limpeza da sequência de cálculo da tabela SD2 para realizar 
    //a contabilização dos documentos de entrada com a TES 504/684 que
    //não movimentam estoque.
    //------------------------------------------------------------------
    cStatement := " UPDATE " + RetSqlName("SD2")
    cStatement += " SET D2_SEQCALC = '"+space(tamSx3("D2_SEQCALC")[1])+"' "
    cStatement += " WHERE "
    cStatement += " D2_EMISSAO >= '" + DTOS(dInicio) + "' AND D2_EMISSAO <= '" + DTOS(a330ParamZX[01]) + "' AND "
    cStatement += " D2_TES IN " + formatIn(cD2Tes,"/")+ " AND "
    cStatement += " TRIM(D2_SEQCALC) IS NOT NULL AND "
    cStatement += " TRIM(D_E_L_E_T_) IS NULL "


    if tcSqlExec(cStatement) < 0
        aviso("MA331FIM", tcSqlError(), {"Cancelar"}, 3)
    endif

return lRet