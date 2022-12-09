// Ricardo Tavares
// Valida Movimentação, alertando sobre preço igual a 01,00
// 02/06/2015 

User Function MT241LOK()

    Local n := ParamIxb[1]
    Local lRet := .T.

    If  ( lRet ) // Condição de não validação da linha pelo usuário
        _cTipoMov := "M" // Movimentacao Multipla
        U_VerUltPrc( 3,  _cTipoMov )  // Movimentacao de Produtos
    Else
        lRet := .F.
    EndIf

Return(lRet)