#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function MA415BUT
    (long_description)
    @type  Function
    @author Douglas Rodrigues da Silva
    @since 27/09/2021
    @version 1.0
    @example
    Ponto entrada tem como objetivo incluir botões tela de inclusão de orçamento de venda
    @see (links_or_references)
/*/

User Function M415COPIA()

    Local aArea := GetArea()
    Local lRet  := .t.

        //Cópia de pedido, deixa as váriaveis em branco
        SCJ->CJ_XPEDIDO := SPACE(6)
        SCJ->CJ_XNUMRO  := SPACE(6)
        SCJ->CJ_XNUMRO  := SPACE(6)
        SCJ->CJ_XPRVENT := Date() + 5

    RestArea(aArea)

Return(lRet)
