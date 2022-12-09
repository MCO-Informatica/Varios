#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function MA415BUT
    (long_description)
    @type  Function
    @author Douglas Rodrigues da Silva
    @since 27/09/2021
    @version 1.0
    @example
    Ponto entrada tem como objetivo incluir bot�es tela de inclus�o de or�amento de venda
    @see (links_or_references)
/*/

User Function M415COPIA()

    Local aArea := GetArea()
    Local lRet  := .t.

        //C�pia de pedido, deixa as v�riaveis em branco
        SCJ->CJ_XPEDIDO := SPACE(6)
        SCJ->CJ_XNUMRO  := SPACE(6)
        SCJ->CJ_XNUMRO  := SPACE(6)
        SCJ->CJ_XPRVENT := Date() + 5

    RestArea(aArea)

Return(lRet)
