#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA440VLD ºAutor  ³ Adriano Leonardo    º Data ³  10/06/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado na confirmação da liberação de  º±±
±±º          ³ um pedido de vendas e será utilizado para realizar valida- º±±
±±º          ³ ções antes de efetuar a autorização da liberação.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA440VLD()

Local _aSavArea := GetArea()
Local _aSavSA1	:= SA1->(GetArea())
Local _cRotina	:= "MA440VLD"
Local _lRet		:= .T. //Default .T.
Local _nDiasTol := SuperGetMV("MV_DIASTOL",,15) //Dias para tolerância de atraso médio para liberação do pedido

If SC5->C5_TIPO=="N"
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1")+SC5->C5_CLIENT+SC5->C5_LOJACLI)
		
		//Chamada dos parâmetros da rotina FINA410 (Refaz dados do cliente/fornecedor)
		Pergunte("AFI410",.F.)
		
		MV_PAR01 := 2 //Recalcular: Ambos|Cliente|Fornecedor (Clientes)
		MV_PAR02 := 1 //Refaz dados históricos: Sim|Nao (Sim)
		MV_PAR03 := SC5->C5_CLIENT //De cliente (Cliente do pedido de venda)
		MV_PAR04 := SC5->C5_CLIENT //Até cliente (Cliente do pedido de venda)
		MV_PAR05 := Space(TamSX3("A2_COD")[01]) //De fornecedor (Nenhum)
		MV_PAR06 := Space(TamSX3("A2_COD")[01]) //Até fornecedor (Nenhum)
		
		Processa({|lEnd| fa410Processa()}) // Chamada da funcao de recalculos de dados do cliente/fornecedor (FINA410 - Padrão)
		
		If SA1->A1_METR > _nDiasTol .And. SA1->A1_ATR>0
			MsgStop("Cliente com título(s) em atraso, a liberação do pedido não será permitida nesse momento!",_cRotina+"_001")
			return .f.
		EndIf
	
		If SC5->C5_XBLQFIN == 'B'
			MsgAlert("Pedido com bloqueio financeiro!","Atenção!")
			return .f.
		EndIf

		If SC5->C5_XBLQMRG == 'S'
			MsgAlert("Pedido com bloqueio de margem!","Atenção!")
			return .f.
		EndIf

    	// If SC5->C5_XBLQMIN == 'S'
		// 	MsgAlert("Pedido com bloqueio de preço mínimo!","Atenção!")
		// 	return .f.
    	// EndIf

	Else
		MsgStop("Falha na identificação do cliente, informe ao Administrador!",_cRotina+"_002")
		return .f.
	EndIf

EndIf

RestArea(_aSavSA1)
RestArea(_aSavArea)

Return(_lRet)
