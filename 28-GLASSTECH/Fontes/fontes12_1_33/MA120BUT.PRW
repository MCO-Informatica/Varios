
/*/{Protheus.doc} MA120BUT
//TODO Ponto de Entrada no inico da Fun??o, antes de montar a ToolBar do Pedido de Compras, deve ser usado para adicionar bot?es do usuario na toolbar do PC ou AE atrav?s do retorno de um Array com a estrutura do bot?o a adicionar.
@author Bruno
@since 07/08/2020
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function MA120BUT()
Local aButUsr := {}

//Se o usu?rio for do grupo de acesso total
If AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV")   
	Aadd( aButUsr,{"Aprov. Al?ada", {|| U_TWFUN02A() } , "Aprov. Al?ada" } )  
EndIf

Return aButUsr