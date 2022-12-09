#Include "Totvs.ch"

User Function CSTMK01()

If M->ADE_MSMCLT == "S"
	If !Empty(M->ADE_PEDGAR)
	
		/*
		Ajustes de código para atender Migração versão P12
		Uso de DbOrderNickName
		OTRS:2017103110001774
		*/
	
		DbSelectArea("SC5")
		DbOrderNickName("NUMPEDGAR")
		
		If DbSeek(xFilial("SC5")+M->ADE_PEDGAR)
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
			
			M->ADE_NOME 	:= SA1->A1_NOME
			M->ADE_CEP  	:= SA1->A1_CEP	
			M->ADE_END  	:= SA1->A1_END
			M->ADE_BAIRRO   := SA1->A1_BAIRRO
			M->ADE_EST	    := SA1->A1_EST
			M->ADE_CODMUN   := SA1->A1_CODMUN
			M->ADE_MUN	    := SA1->A1_MUN
			M->ADE_PESSOA   := SA1->A1_PESSOA
			M->ADE_CGC		:= SA1->A1_CGC
			M->ADE_INSCR	:= SA1->A1_INSCR
			
							
		Else
			MsgInfo("O Pedido de Venda não foi encontrado!")
		EndIf
		
	ElseIf !Empty(M->ADE_XPSITE)
		
		/*
		Ajustes de código para atender Migração versão P12
		Uso de DbOrderNickName
		OTRS:2017103110001774
		*/
		
		DbSelectArea("SC5")
		DbOrderNickName("PEDSITE")
		
		If DbSeek(xFilial("SC5")+M->ADE_XPSITE)
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
	
			M->ADE_NOME 	:= SA1->A1_NOME
			M->ADE_CEP  	:= SA1->A1_CEP	
			M->ADE_END  	:= SA1->A1_END
			M->ADE_BAIRRO   := SA1->A1_BAIRRO
			M->ADE_EST	    := SA1->A1_EST
			M->ADE_CODMUN   := SA1->A1_CODMUN
			M->ADE_MUN	    := SA1->A1_MUN
			M->ADE_PESSOA   := SA1->A1_PESSOA
			M->ADE_CGC		:= SA1->A1_CGC
			M->ADE_INSCR	:= SA1->A1_INSCR
			
		Else
			MsgInfo("O Pedido de Venda não foi encontrado!")
		EndIf
	Else
		MsgInfo("Os campos de Pedido Site e Pedido Gar estão em branco!")
	EndIf
Else
	M->ADE_NOME 	:= "                                                            "
	M->ADE_CEP  	:= "        "	
	M->ADE_END  	:= "                                                                                                    "
	M->ADE_BAIRRO   := "                                   "
	M->ADE_EST	    := "  "
	M->ADE_CODMUN   := "      "
	M->ADE_MUN	    := "                                   "
	M->ADE_PESSOA   := " "
	M->ADE_CGC		:= "              "
	M->ADE_INSCR	:= "                  "
EndIf

Return(.T.)