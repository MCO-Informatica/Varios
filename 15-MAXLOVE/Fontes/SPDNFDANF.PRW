User Function SPDNFDANF()

	sf2doc := ParamIxb[1]
	sf2serie := ParamIxb[2]
	
    //MsgInfo("Passou no ponto de entrada 'SPDNFDANF'")
    
    DbSelectArea("SF2")
	SF2->(DbSetOrder(1))

	If SF2->(DbSeek(xFilial("SF2")+sf2doc+sf2serie ) )
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3)) //D2_FILIAL, D2_DOC, D2_SERIE
		If SD2->(DbSeek(xFilial("SD2")+sf2doc+sf2serie ) )

			DbSelectArea("SC5")
			SC5->(DbSetOrder(1)) //C5_FILIAL+C5_NUM
			If SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO ) )

				//Envio rastreabilidade de pedidos
				If FWHasEAI("MATA410B",.T.,,.T.)

					//Verifica se  um pedido gerado pelo Loja e atualiza status do pedido (C5_STATUS)
					If ExistFunc("LjxjAtStTr") .And. !Empty(SC5->C5_ORCRES)
						LjxjAtStTr()
					EndIf

					FwIntegDef("MATA410B")
				EndIf
			EndIf
		EndIf
	EndIf


Return