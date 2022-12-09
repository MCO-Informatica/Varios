
/*/{Protheus.doc} MT120BRW
//TODO Ponto de entrada para incluir nova opção no Outras Ações do pedido de Compras.
@author Pirolo
@since 07/08/2020
@return return, return_description
/*/
User Function MT120BRW()

//Se o usuário for do grupo de acesso total
If AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV")     
	aAdd(aRotina, {"Aprovação", "U_TWFUN02A", 0 , 4, 0,NIL} )
	aAdd(aRotina, {"*Tracker", "U_A120Track", 0 , 4, 0,NIL} )

EndIf

Return 
