User Function F200VAR()
	Local aValores := PARAMIXB[01]
	Local aArea := GetArea()
	Local cIdCnab := ''//SubStr(aValores[16],38,10) /// Captura do ID Cnab
	Local cNNum := SubStr(aValores[16],47,10) /// Captura do Nosso Numero

//aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc,{} })

	If !Empty(cIdCnab) // Se o ID Cnab Estiver Preenchido então localiza o Titulo

		cNumTit := cIdCnab

// Posiciona no Registro do Titulo

		If !SE1->(dbSetOrder(19), dbSeek(cNumTit))
			Return
		Endif
		//ElseIf !Empty(cNNum)

// Posiciona no Registro do Titulo com Base no Nosso Numero
// Novo Indice Criado E1_FILIAL + E1_NUMBCO

// Colocar o Numero da Ordem do Indice Criado na Tabela SE1

// E1_FILIAL + E1_NUMBCO
/*If !SE1->(DbOrderNickName("NUMBCO"), dbSeek(xFilial("SE1")+'00'+cNNum))
If !SE1->(DbOrderNickName("NUMBCO"), dbSeek(xFilial("SE1")+cNNum))
cTipo := ''
cNumTit := ''
Return
Else*/

If Empty(cNumTit)
    cNumTit := SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
EndIf

//cTipo := "05 "
/*Endif
Else
cNumTit := SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
Endif*/

Endif
RestArea(aArea)
Return
