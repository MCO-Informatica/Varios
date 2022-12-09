// Ricardo Tavares
// Valida Movimentação, alertando sobre preço igual a 01,00
// 08/06/2015 

User Function MT100LOK()

    Local lExecuta := ParamIxb[1]

// Validações do usuário para inclusão ou alteração do item na NF de Despesas de Importação
    _cTipoMov := ""
    U_VerUltPrc( 1, _cTipoMov ) // Compras

Return (lExecuta)