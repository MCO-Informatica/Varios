// Ricardo Tavares
// Valida Movimenta��o, alertando sobre pre�o igual a 01,00
// 02/06/2015 

User Function MT241LOK()

    Local n := ParamIxb[1]
    Local lRet := .T.

    If  ( lRet ) // Condi��o de n�o valida��o da linha pelo usu�rio
        _cTipoMov := "M" // Movimentacao Multipla
        U_VerUltPrc( 3,  _cTipoMov )  // Movimentacao de Produtos
    Else
        lRet := .F.
    EndIf

Return(lRet)