#Include "TOPCONN.Ch"
//
// Programa		MT250EST
// Autor		Carlos N. Puerta
// Data			02/02/2018
// Descri??o	Ponto de Entrada: MT250EST - Valida (campo espec?fico do usu?rio) antes do estorno da OP.
// Localiza??o	Executado na fun??o A250Estorn( ), responsavel pelo estorno de produ??o.
// Descri??o	Chamado apos confirma??o de estorno de produ??es.
//              Este ponto de entrada permite validar algum campo especifico do usuario antes de se realizar o Estorno.
// Retorno      Retorna variavel logica sendo: .T. permite estornar ou .F. cancela estorno.
//
// TDN          http://tdn.totvs.com/pages/releaseview.action?pageId=6087751
//
User Function MT250EST()
Local _aArea      := GetArea()
Local _cNumOP     := SD3->D3_OP
Local _cProduto   := SD3->D3_COD
Local _cXLt01     := SD3->D3_RAST01
Local _cXLt02     := SD3->D3_RAST02
Local _cXLt03     := SD3->D3_RAST03
Local _cXLt04     := SD3->D3_RAST04
//Local _cXLt05     := SD3->D3_RAST05
Local _cXTurno    := SD3->D3_XTURNO
Local _cXOperador := SD3->D3_XOPERAD
Local _nQuant     := SD3->D3_QUANT
Local _lRet       := .T.
//
//********************************************************
//
If !Empty(_cXLt01)
	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt01)
		If !Empty(SZC->ZC_NUMPV) .Or. SZC->ZC_STATUS <> "05" .And. ( AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador) )
		    Alert("Apontamento Ja Amarrado a um Pedido de Venda Liberado com Lote para Etiqueta...")
            _lREt := .F.
		EndIf
	EndIf
EndIf

If !Empty(_cXLt02)
	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt02)
		If !Empty(SZC->ZC_NUMPV) .Or. SZC->ZC_STATUS <> "05" .And. ( AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador) )
		    Alert("Apontamento Ja Amarrado a um Pedido de Venda Liberado com Lote para Etiqueta...")
            _lREt := .F.
		EndIf
	EndIf
EndIf

If !Empty(_cXLt03)
	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt03)
		If !Empty(SZC->ZC_NUMPV) .Or. SZC->ZC_STATUS <> "05" .And. ( AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador) )
		    Alert("Apontamento Ja Amarrado a um Pedido de Venda Liberado com Lote para Etiqueta...")
            _lREt := .F.
		EndIf
	EndIf
EndIf

If !Empty(_cXLt04)
	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt04)
		If !Empty(SZC->ZC_NUMPV) .Or. SZC->ZC_STATUS <> "05" .And. ( AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador) )
		    Alert("Apontamento Ja Amarrado a um Pedido de Venda Liberado com Lote para Etiqueta...")
            _lREt := .F.
		EndIf
	EndIf
EndIf
//
/*/
If !Empty(_cXLt05)
	dbSelectArea("SZC")
	dbSetOrder(5)             // ZC_FILIAL+ZC_OP+ZC_LOTEOP
	If dbSeek(xFilial("SZC")+_cNumOP+_cXLt05)
		If !Empty(SZC->ZC_NUMPV) .Or. SZC->ZC_STATUS <> "05" .And. ( AllTrim(SZC->ZC_OP) == AllTrim (_cNumOP) .And. AllTrim(SZC->ZC_TURNO) == AllTrim(_cXTurno) .And. AllTrim(SZC->ZC_OPERADO) == AllTrim(_cXOperador) )
		    Alert("Apontamento Ja Amarrado a um Pedido de Venda Liberado com Lote para Etiqueta...")
            _lREt := .F.
		EndIf
	EndIf
EndIf
/*/
//
RestArea(_aArea)
Return(_lRet)