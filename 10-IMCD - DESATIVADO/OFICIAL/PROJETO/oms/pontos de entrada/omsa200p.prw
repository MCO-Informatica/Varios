User Function OMSA200P()
	Local cCarga := PARAMIXB[1]
	Local cSeq   := PARAMIXB[2]
	Local lRet   := .T.//-- Retornar lRet := .T. para confirmar o estorno da Carga.  

	dbselectarea("DAI")
	dbSetOrder(1)
	dbGoTop()
	IF MsSeek(xFilial()+DAK->DAK_COD)
		vPedido := DAI->DAI_PEDIDO
		vCliente := DAI->DAI_CLIENT
		vLoja :=  DAI->DAI_LOJA
		U_GrvLogPd(vPedido,vCliente,vLoja,'Estorno de Carga / Roteirizacao', ,DAK->DAK_COD)
	ENDIF




Return lRet