// Ricardo Tavares
// Valida Movimentação, alertando sobre preço igual a 01,00
// 09/06/2015 

User Function MT240TOk()
    _cTipoMov := "S" // Movimentacao Simples
    U_VerUltPrc( 3, _cTipoMov ) // Movimentacao de Produtos

Return(.T.)