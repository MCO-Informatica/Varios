// Ricardo Tavares
// Valida Movimenta��o, alertando sobre pre�o igual a 01,00
// 08/06/2015 

User Function MT100LOK()

    Local lExecuta := ParamIxb[1]

// Valida��es do usu�rio para inclus�o ou altera��o do item na NF de Despesas de Importa��o
    _cTipoMov := ""
    U_VerUltPrc( 1, _cTipoMov ) // Compras

Return (lExecuta)