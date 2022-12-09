#Include 'Protheus.ch'

User Function F460SE1()

Local aParam  := PARAMIXB
Local aAux    := PARAMIXB[1]
Local lLiquid := FunName() == "FINA460"

apMsgInfo("Passei aqui","F040RAUTO")

//If lLiquid
If Select("FO2") > 0
	cMsg  := "Vendedor"+ FO2->FO2_VEND1 + CRLF
	cMsg  += "Pedido"+ FO2->FO2_PEDIDO + CRLF
	apMsgInfo(cMsg,"F460SE1")
	//Vendedor
	aAdd(aAux,{"E1_VEND1",FO2->FO2_VEND1, Nil})
	//Pedido
	aAdd(aAux,{"E1_VEND1",FO2->FO2_PEDIDO, Nil})
Endif

Return aAux
 