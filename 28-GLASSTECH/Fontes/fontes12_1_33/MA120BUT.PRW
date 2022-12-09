
/*/{Protheus.doc} MA120BUT
//TODO Ponto de Entrada no inico da Função, antes de montar a ToolBar do Pedido de Compras, deve ser usado para adicionar botões do usuario na toolbar do PC ou AE através do retorno de um Array com a estrutura do botão a adicionar.
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

//Se o usuário for do grupo de acesso total
If AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV")   
	Aadd( aButUsr,{"Aprov. Alçada", {|| U_TWFUN02A() } , "Aprov. Alçada" } )  
EndIf

Return aButUsr