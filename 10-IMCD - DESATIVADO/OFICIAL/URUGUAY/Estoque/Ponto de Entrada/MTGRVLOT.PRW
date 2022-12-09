
user function MTGRVLOT

	If FunName() == "MATA103"
		RecLock("SB8",.F.)
		SB8->B8_DTFABRI := SD1->D1_DTFABRI
		msUnlock()
	Endif  

Return Nil