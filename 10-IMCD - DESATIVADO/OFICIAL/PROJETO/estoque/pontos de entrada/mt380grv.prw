#include "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT380GRV  ºAutor  ³  Daniel   Gondran  º Data ³  18/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. para transferir o lote do insumo escolhido para a     º±±
±±º          ³ "capa" da OP (SC2) e daí posteriormente para a produção    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT380ALT()        

	Local cAlias 	:= Alias()
	Local aArea  	:= GetArea()             
	Local cProd		:= ""    
	Local cOp 		:= SD4->D4_OP
	Local cLote     := ""
	Local dDataFab  := CTOD("  /  /  ")
	Local dDataVal  := CTOD("  /  /  ")

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT380ALT" , __cUserID )

	dbSelectArea("SD4")
	dbSetOrder(2)                                                
	dbSeek(xFilial("SD4") + cOp)
	do While !Eof() .and. SD4->D4_FILIAL == xFilial("SD4") .and. SD4->D4_OP == cOp
		If !Empty(SD4->D4_LOTECTL)
			cLote := SD4->D4_LOTECTL
			cProd := SD4->D4_COD
		Endif
		dbSkip()
	Enddo     

	dbSelectArea("SB8")
	dbSetOrder(5)
	dbSeek(xFilial("SB8") + cProd + cLote)
	do While !Eof() .and. SB8->B8_FILIAL == xFilial("SB8") .and. SB8->B8_PRODUTO == cProd .and. SB8->B8_LOTECTL == cLote
		If Empty(dDataFab)
			dDataFab := SB8->B8_DFABRIC
		Endif
		If Empty(dDataVal)
			dDataVal := SB8->B8_DTVALID
		Endif
		dbSkip()
	Enddo          

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial("SC2") + cOp)
		RecLock("SC2",.F.)
		SC2->C2_LOTECTL := cLote
		SC2->C2_DTFABRI := dDataFab
		SC2->C2_DTVALID := dDataVal
		msUnlock()
	Endif

	RestArea( aArea )
	DbSelectArea( cAlias )
Return
