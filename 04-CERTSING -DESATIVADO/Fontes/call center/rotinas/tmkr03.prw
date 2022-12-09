#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKR03    ºAutor  ³Opvs (David)        º Data ³  24/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKR03A(cNumAtend)

	If SUB->(FieldPos('UB_COD_GAR'))>0
		R03PedGAR(cNumAtend)
	Endif
	MsgInfo("Pedido Gerado com Sucesso!")
	
Return


//------------------------------------------------------------------
// Rotina | R03PedGAR | Autor | Robson Luiz - Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Rotina para alimentar o campo CODIGO GAR conforme 
//        | informado no atendimento que gerou o pedido de venda.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function R03PedGAR(cNumAtend)
	Local aArea := {}
	Local aAreaSUB := {}
	Local aAreaSC6 := {}
	//-------------------------------------------
	// Salvar area, index e ponteiro das tabelas.
	//-------------------------------------------
	aArea := GetArea()
	aAreaSUB := SUB->(GetArea())
	aAreaSC6 := SC6->(GetArea())
	//-----------------------------------
	// Posicionar no item do atendimento.
	//-----------------------------------
	SUB->(dbSetOrder(1))
	If SUB->(dbSeek(xFilial('SUB')+cNumAtend))
		//---------------------------------------------------------
		// Ler o registro e posicionar no item do pedido de vendas.
		//---------------------------------------------------------
		While !SUB->(EOF()) .And. SUB->UB_NUM == cNumAtend
			SC6->(dbSetOrder(1))
			If SC6->(dbSeek(xFilial('SC6')+SUB->(UB_NUMPV+UB_ITEMPV+UB_PRODUTO)))
				//-----------------------------------------------------------------------
				// Gravar o código do produto GAR no item do pedido de venda relacionado.
				//-----------------------------------------------------------------------
				SC6->(RecLock('SC6',.F.))
				SC6->C6_PROGAR := SUB->UB_COD_GAR
				SC6->(MsUnLock())
			Endif
			SUB->(dbSkip())
		End
	Endif
	//----------------------------------------------
	// Restaurar area, index e ponteiro das tabelas.
	//----------------------------------------------
	SC6->(RestArea(aAreaSC6))
	SUB->(RestArea(aAreaSUB))
	RestArea(aArea)
Return