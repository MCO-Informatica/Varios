#include "totvs.ch"
#include "rwmake.ch"
#Include "Protheus.Ch"
#include "topconn.ch"


User Function RFATA04()


    cQuery := "UPDATE V_AJUSTA_VENDA_EXT SET C5_VEND3 = A1_VENDE  WHERE C5_VENDE = '1'"
    TCSQLExec(cQuery)

    cQuery := "UPDATE V_AJUSTA_VENDA_EXT SET C5_VEND4 = A1_VENDE1 WHERE C5_VENDE = '2'"
    TCSQLExec(cQuery)

    cQuery := "UPDATE V_AJUSTA_VENDA_EXT SET F2_VEND3 = A1_VENDE  WHERE C5_VENDE = '1'"
    TCSQLExec(cQuery)

    cQuery := "UPDATE V_AJUSTA_VENDA_EXT SET F2_VEND4 = A1_VENDE1 WHERE C5_VENDE = '2'"
    TCSQLExec(cQuery)

    MsgAlert("Vendedores externos atualizado com sucesso!!!")

Return