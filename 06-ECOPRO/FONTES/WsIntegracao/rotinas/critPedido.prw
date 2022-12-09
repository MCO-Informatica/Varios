#include 'protheus.ch'

user Function critPedido(oJson,cError,lcritIt)
	Local lRet := .t.
	Local cId  := strzero(oJson['id'],11)
	Local cCpf := oJson['cpf']
	Local nVlrCab := iif(oJson['valorCompra']!=nil,oJson['valorCompra'],0)
	Local aPedIt  := iif(oJson['itens']!=nil,oJson['itens'],{})
	Local aJson   := {}
	Local nTotVen := 0

	Local nI	:= 0
	Local nP	:= 0

	Default lcritIt := .t.

	if lcritIt
		for nI := 1 to aPedIt
			aJson := ClassDataArr(aPedIt[nI])
			nP	:= Ascan(aJson,{|x| x[1]=="valor"})
			nTotVen	+= aJson[nP,2]
		next

		if	nVlrCab != nTotVen
			cError := "O total de vendas informado no cabeçalho (JSON) não é igual ao somatórios dos itens do pedido ID "+cId+" !"
			lRet := .f.
		endif
	endif

	sc5->(dbSetOrder(10))
	if sc5->(MsSeek(xFilial()+cId))
		cError := "O ID "+cId+" já foi incluido !"
		lRet := .f.
	endif

	sa1->(dbSetOrder(3))
	if !sa1->(MsSeek(xFilial()+cCpf))
		cError := "Cliente com CPF/CNPJ: "+cCpf+", não encontrado !"
		lRet := .f.
	endif

return lRet
