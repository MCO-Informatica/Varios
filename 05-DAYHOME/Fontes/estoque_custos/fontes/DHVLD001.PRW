#Include 'protheus.ch'

//----------------------------------------------------------------//
/*/{Protheus.doc} DHVLD001
//TODO Valida??o do campo C6_QTDVEN, para n?o permitir quantidade
    maior do que 1, quando o produto tiver controle de n?mero de 
    s?rie.
@author Claudio Macedo
@since 14/02/2022
@version 1.0
/*/
//----------------------------------------------------------------//
User Function DHVLD001()

Local cProduto := aCols[n,GDFieldPos('C6_PRODUTO')]
Local nQtdVen  := aCols[n,GDFieldPos('C6_QTDVEN')]

Local lRet := .T.

SB5->(DbSetOrder(1))

If SB5->(DbSeek(xFilial('SB5') + cProduto)) .And. SB5->B5_XNUMSER = 'S' .And.nQtdVen > 1
    Alert('A quantidade deve ser igual a um, quando controle por n?mero de s?rie.')
    lRet := .F.
Endif

Return lRet
