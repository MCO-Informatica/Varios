#Include "Protheus.ch"
//---------------------------------------------------------------------
// Rotina | SD1100E | Autor | Mauro Sano            | Data | 12.12.2009
//---------------------------------------------------------------------
// Descr. | PE - Responsável pela exclusao de notas fiscai de entrada
//---------------------------------------------------------------------
// Release| Atualiza o saldo de medição na inclusão de NF de devolução.
//        | Rafael Beghini - 07.03.2016
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S/A
//---------------------------------------------------------------------
User Function SD1100E()
	Local aArea    := GetArea()
	Local cNumDoc  := SD1->D1_DOC
	Local cNumSer  := SD1->D1_SERIE
	Local cProdut  := SD1->D1_COD
	Local cFornece := SD1->D1_FORNECE + SD1->D1_LOJA
	Local cNumSeq  := SD1->D1_NUMSEQ
	Local nOpcao   := 5
	
	If !Empty(SD1->D1_IDENTB6)
		DbSelectArea("SZB")
		DbSetOrder(5)
		If DbSeek(xFilial("SZB") + "E" + SD1->D1_COD + SD1->D1_DOC + SD1->D1_SERIE)
			RecLock("SZB", .F.)
			SZB->ZB_SALDO := SZB->SALDO + SD1->D1_QUANT
			SZB->(MsUnlock()) 
		EndIf
	Endif
	
	IF SF1->F1_TIPO == 'D'
		//NF Devolução referente a Contratos
		U_A680NFDev( cNumDoc, cNumSer, cFornece, nOpcao, cNumSeq )
	EndIF
	
	RestArea(aArea)
Return