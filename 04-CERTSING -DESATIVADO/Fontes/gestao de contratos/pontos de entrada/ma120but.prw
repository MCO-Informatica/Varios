//------------------------------------------------------------------
// Rotina | MA120BUT | Autor | Robson Goncalves    | Data | 13.05.15
//------------------------------------------------------------------
// Descr. | Ponto de Entrada para adicionar bot�es no pedido de 
//        | compras em a��es relacionadas.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function MA120BUT()
	Local aBotao := {}
	AAdd( aBotao, { 'PEDIDO.PNG', {|| U_A610CapDesp( 'MATA120' ) },"Visualizar capa de despesa...","Capa de despesa"})
Return( aBotao )