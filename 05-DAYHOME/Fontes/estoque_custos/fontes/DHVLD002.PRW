#Include 'protheus.ch'

//----------------------------------------------------------------//
/*/{Protheus.doc} DHVLD002
//TODO Valida??o do campo Z1_NUMSER, na rotina de chamados.
@author Claudio Macedo
@since 15/02/2022
@version 1.0
/*/
//----------------------------------------------------------------//
User Function DHVLD002()

Local lRet := .T.

If Empty(M->Z1_PRODUTO)
    Alert('Informe o c?digo do produto quando utilizar n?mero de s?rie.')
    lRet := .F.
Else
    SZ4->(DbSetOrder(1))

    If !SZ4->(DbSeek(xFilial('SZ4') + M->Z1_NUMSER + M->Z1_PRODUTO))
        If !MsgYesNo('N?mero de s?rie n?o localizado ou vinculado ao produto. Deseja Prosseguir ?')
            lRet := .F.
        Endif
    Endif

Endif

Return lRet
