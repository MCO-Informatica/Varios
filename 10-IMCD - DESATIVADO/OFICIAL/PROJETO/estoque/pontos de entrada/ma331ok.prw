#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MA331OK
Contabilização do Recálculo do Custo Médio
Ponto de Entrada executado no início da função MTA331TOk(), utilizado 
para validar a execução da Contabilização do recálculo do custo médio. 
Está localizado na função de validação da Contabilização do Custo Médio.
@author  marcio.katsumata
@since   30/09/2019
@version 1.0
@return  boolean, .T. = Executa a contabilização do custo médio.
                  .F. = Não executa a contabilização do custo médio.
@see     https://tdn.totvs.com/pages/releaseview.action?pageId=6087894
/*/
//-------------------------------------------------------------------
user function MA331OK()
    local lRet as logical
    local cD2Seq as character
    local cD2Tes as character

    cD2Tes := superGetMv("ES_TESCONS", .F., "504/684")
    cD2Seq := dTos(dInicio)+cFilAnt

    lRet := .T.

    //------------------------------------------------------------------
    //Atualização da sequência de cálculo da tabela SD2 para realizar 
    //a contabilização dos documentos de entrada com a TES 504/684 que
    //não movimentam estoque.
    //------------------------------------------------------------------
    cStatement := " UPDATE " + RetSqlName("SD2")
    cStatement += " SET D2_SEQCALC = '"+cD2Seq+"' "
    cStatement += " WHERE "
    cStatement += " D2_EMISSAO >= '" + DTOS(dInicio) + "' AND D2_EMISSAO <= '" + DTOS(a330ParamZX[01]) + "' AND "
    cStatement += " D2_TES IN " + formatIn(cD2Tes,"/")+ " AND "
    cStatement += " TRIM(D2_SEQCALC) IS NULL AND "
    cStatement += " TRIM(D_E_L_E_T_) IS NULL "


    if tcSqlExec(cStatement) < 0
        aviso("MA331OK", tcSqlError(), {"Cancelar"}, 3)
        lRet := .F.
    endif

return lRet