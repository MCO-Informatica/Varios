//Bibliotecas 
#Include "Totvs.ch"
 
/*/{Protheus.doc} User Function MT410CPY
Ponto de entrada ao copiar um pedido de venda, para zerar alguns valores
@type  Function
@author Vladimir
@since 14/07/2022
@version version
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784349
/*/
 
User Function mt410cpy()
    Local aArea    := GetArea()
    Local aAreaSC5 := SC5->(GetArea())
    Local lRet := .T.

    //Zerando os campos
    M->C5_XPEDSHP  := Space(TamSx3("C5_XPEDSHP")[1])
    M->C5_NMESHP   := Space(TamSx3("C5_NMESHP")[1])
    M->C5_XINTELI  := Space(TamSx3("C5_XINTELI")[1])
    M->C5_XHTTPCD  := Space(TamSx3("C5_XHTTPCD")[1])
    M->C5_XHTTPRE  := Space(TamSx3("C5_XHTTPRE")[1])
    M->C5_XCHVNFE  := Space(TamSx3("C5_XCHVNFE")[1])
    M->C5_XORDS    := Space(TamSx3("C5_XORDS")[1])
    M->C5_XNOTA    := Space(TamSx3("C5_XNOTA")[1])


    RestArea(aAreaSC5)
    RestArea(aArea)

Return lRet
