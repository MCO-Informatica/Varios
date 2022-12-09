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
    //-------------------------------
    //Origem = Solicitação de compra
    //-------------------------------
    If nTipoPed !=	2
    
        aCols[n][gdField                                                                                                                             Pos("C7_OP")] := SC1->C1_OP

    ENDIF

Return             
