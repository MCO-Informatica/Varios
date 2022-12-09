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

User Function MA415BUT()
    
    Local aBotoes:={}
    AAdd(aBotoes,{ "NOTE", {|| Processa({|| U_DULPORNI()},"Dados do Pedido","Processando...") }, "Duplicatas - Fin" } )

Return(aBotoes)
