#include 'protheus.ch'


/*/{Protheus.doc} MT103TXPC
O Ponto de Entrada MT103TXPC � utilizado na rotina Documento de Entrada 
e permite alterar a moeda, taxa da moeda e marcar o check box de taxa 
negociada de acordo com o Pedido de Compras quando ele estiver em moeda 
diferente da moeda 1.
O retorno do ponto de entrada ser� o valor da taxa da moeda utilizada na 
nota. Se for igual a zero, o c�lculo da taxa da moeda ser� o resultado da 
divis�o do valor unit�rio do Documento de Entrada (D1_VUNIT) pelo valor 
unit�rio do Pedido de Compra (C7_PRECO).
LOCALIZA��O: fun��es a103procPC (Processa o carregamento do pedido de 
compras para a NFE) e A103ItemPC (tela de importa��o de Pedidos de 
Compra por Item).
EM QUE PONTO: ao vincular o Pedido de Compras com a nota.
@type function
@version 1.0
@author marcio.katsumata
@since 25/03/2020
@return numeric, taxa da moeda
@see    https://tdn.totvs.com/pages/releaseview.action?pageId=107383186
/*/
user function MT103TXPC()

    local nRetTaxa as numeric
    local cMoedaAtu as character

    nRetTaxa := 0

    //--------------------------------------
    //Tratativa para utilizar a moeda do dia
    //---------------------------------------
    if !empty(SC7->C7_MOEDA) 

        cMoedaAtu := alltrim(cValToChar(SC7->C7_MOEDA))

        dbSelectArea("SM2")
        SM2->(dbSetOrder(1))
        
        if SM2->(dbSeek(xFilial("SM2")+dtos(dDataBase)))
            nRetTaxa := SM2->&("M2_MOEDA"+cMoedaAtu)
        endif

    endif


return nRetTaxa