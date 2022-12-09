/*/{Protheus.doc} MTA110MNU
//TODO Ponto de Entrada na Solicitação de Compras para permitir acréscimo de botões ao menu principal.
@author Pirolo
@since 25/06/2020
@return return, return_description
@see (https://tdn.totvs.com/pages/releaseview.action?pageId=6085755)
/*/
User Function MTA110MNU
Local nPos	:= aScan(aRotina,{|x| AllTrim(UPPER(x[2])) == "A110APROV"})
Local aRotUsr := {}

//Se o usuário logado não for aprovador bloqueia a rotina de Aprovação da SC.
If !AllTrim(RetCodUsr()) $ SuperGetMv("TW_SCAPROV") .AND. nPos > 0
	aRotina[nPos, 2] := "MsgInfo(OemToAnsi('Usuário sem permissão para aprovar solicitações de compras.'), 'Permissão')"
Else
	Aadd(aRotina,{'Trocar Comprador' ,'U_TWFUN01D()' , 0 , 1, 0, NIL})
	Aadd(aRotina,{'Aprovar todas SCs','U_TWFUN01E()', 0 , 1, 0, NIL})
EndIf

Aadd(aRotina,{'*Visualizar Pedido','U_TWFUN01G()', 0 , 1, 0, NIL})
aadd(aRotina,{OemToAnsi("IMP Cotação"),"U_TRCOMP(SC1->C1_NUM)",0,2,0,NIL})

Return 
