#include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MA331OK
Contabiliza��o do Rec�lculo do Custo M�dio
Ponto de Entrada executado no in�cio da fun��o MTA331TOk(), utilizado 
para validar a execu��o da Contabiliza��o do rec�lculo do custo m�dio. 
Est� localizado na fun��o de valida��o da Contabiliza��o do Custo M�dio.
@author  marcio.katsumata
@since   30/09/2019
@version 1.0
@return  boolean, .T. = Executa a contabiliza��o do custo m�dio.
                  .F. = N�o executa a contabiliza��o do custo m�dio.
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
    //Atualiza��o da sequ�ncia de c�lculo da tabela SD2 para realizar 
    //a contabiliza��o dos documentos de entrada com a TES 504/684 que
    //n�o movimentam estoque.
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