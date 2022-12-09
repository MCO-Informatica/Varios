#Include "Protheus.ch" 


//+--------+---------+-------+-------------------+------+-----------------------------------+
//| Rotina | MTA410T | Autor | ERIK              | Data | 27/10/2010                        |
//+--------+---------+-------+-------------------+------+-----------------------------------+
//| Descr. | Ponto de entrada utilizado para trocar Selecionar a natureza correta de acordo |
//|        | com a bandeira de cartão de crédito. Caso não seja Venda com cartao e natureza | 
//|        | esteja vazia define grava natureza padrão.                                     |
//+--------+--------------------------------------------------------------------------------+
//| Uso    | Certisign                                                                      |
//+--------+--------------------------------------------------------------------------------+
User Function MTA410T()

	Local cNaturez	:= ""
	Local cCanalVen := ""
	
	cCanalVen := Posicione("SA3", 1, xFilial("SA3") + SC5->C5_VEND1, "A3_XCANAL")
	
	//-- 000001 = Vendas Direta
	//-- 000002 = Vendas Varejo
	//-- 000003 = Comercial Corporativo
	If cCanalVen <> "000002" .And. (cCanalVen == "000001" .Or. cCanalVen == "000003")
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		If MsSeek(xFilial("SA1") + SC5->C5_CLIENTE)
			If SA1->A1_VEND <> SC5->C5_VEND1
				RecLock("SA1", .F.)
					SA1->A1_VEND := SC5->C5_VEND1
				SA1->(MsUnLock())
			EndIf
		EndIf
		
	EndIf
	
	Do Case
	
		Case AllTrim(SC5->C5_XBANDEI) $ "VIS|VISA"
			cNaturez := GetNewPar("MV_XNATVIS", "FT010010")
		
		Case AllTrim(SC5->C5_XBANDEI) $ "RED|MASTERCARD"
			cNaturez := GetNewPar("MV_XNATRED", "FT010010")
		
		Case AllTrim(SC5->C5_XBANDEI) $ "AME|AMEX"
			cNaturez := GetNewPar("MV_XNATAME", "FT010010")
		
		Otherwise // Avaliar condições de pedidos Manuais
			IF Empty(SC5->C5_XNATURE) 
				cNaturez := GetNewPar("MV_XNATCLI", "FT010010")
			EndIf
				                                     
	Endcase

	IF !Empty(cNaturez) 
		RecLock("SC5")
			SC5->C5_XNATURE := alltrim(cNaturez)
		MsUnlock()
	EndIf

Return