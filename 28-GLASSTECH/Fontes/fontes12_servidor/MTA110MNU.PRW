
/*/{Protheus.doc} MTA110MNU
//TODO Ponto de Entrada na Solicita??o de Compras para permitir acr?scimo de bot?es ao menu principal.
@author Pirolo
@since 25/06/2020
@return return, return_description
@see (https://tdn.totvs.com/pages/releaseview.action?pageId=6085755)
/*/
User Function MTA110MNU
Local nPos	:= aScan(aRotina,{|x| AllTrim(UPPER(x[2])) == "A110APROV"})
Local aRotUsr := {}

//Se o usu?rio logado n?o for aprovador bloqueia a rotina de Aprova??o da SC.
If !AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV") .AND. nPos > 0
	aRotina[nPos, 2] := "MsgInfo(OemToAnsi('Usu?rio sem permiss?o para aprovar solicita??es de compras.'), 'Permiss?o')"
Else
	Aadd(aRotina,{'Trocar Comprador' ,'U_TWFUN01D()' , 0 , 1, 0, NIL})
	Aadd(aRotina,{'Aprovar todas SCs','U_TWFUN01E()', 0 , 1, 0, NIL})
EndIf

Aadd(aRotina,{'*Visualizar Pedido','U_TWFUN01G()', 0 , 1, 0, NIL})

Return 

