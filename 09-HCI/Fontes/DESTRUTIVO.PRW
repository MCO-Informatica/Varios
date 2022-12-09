#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DestrutivoºAutor  ³Marcio Dias         º Data ³  17/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica a necessidade de compra extra do produto de acordo º±±
±±º          ³com ensaios destrutivos cadastrados.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico HCI - Disparado no pedido de compras (SC7)       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Destrutivo()

Local cProdIni	:= ""                                              
Local cProduto	:= "" 
Local cRevisao	:= "" 
Local cEnsaios	:= ""            
Local cAlias	:= Alias()

DbSelectArea("QE6")
QE6->(DbSetOrder(1))
QE6->(DbGoTop())

DbSelectArea("QE7")
QE7->(DbSetOrder(1))
QE7->(DbGoTop())

DbSelectArea("QE8")
QE8->(DbSetOrder(1))
QE8->(DbGoTop())

// Valida de onde esta sendo disparado a rotina

If SX3->X3_CAMPO == "C7_PRODUTO"
	cProdIni:= M->C7_PRODUTO			// Pedido de compra
Else
	If SX3->X3_CAMPO == "C1_PRODUTO"
		cProdIni:= M->C1_PRODUTO       // Solicitacao de compra
	EndIf
EndIf

If QE6->(DbSeek(xFilial("QE6")+cProdIni))	
	
	cProduto := QE6->QE6_PRODUT
	cRevisao := QE6->QE6_REVI
	
	If QE7->(DbSeek(xFilial("QE7")+cProduto+cRevisao))		// Verifica QE7 para ensaios destrutivos.                             
		While QE7->QE7_PRODUT == cProduto .AND. QE7->QE7_REVI == cRevisao 
			If QE7->QE7_ENSDES == "1"
				cEnsaios +=	AllTrim(QE7->QE7_ENSAIO) + ", "   	// Concatena String de ensaios destrutivos.
				QE7->(DbSkip())
			EndIf
		QE7->(DbSkip())
		EndDo
	EndIf
	If QE8->(DbSeek(xFilial("QE8")+cProduto+cRevisao))  	// Verifica QE8 para ensaios destrutivos.
		While QE8->QE8_PRODUT == cProduto .AND. QE8->QE8_REVI == cRevisao
			If QE8->QE8_ENSDES == "1"
				cEnsaios +=	AllTrim(QE8->QE8_ENSAIO) + ", "    // Concatena String de ensaios destrutivos.
				QE8->(DbSkip())
			EndIf
		QE8->(DbSkip())
		EndDo
	EndIf
	If cEnsaios != ""
		Alert("Existe(m) ensaio(s) destrutivo(s) para este produto. Verifique a quantidade a ser comprada")  // Apresenta os ensaios.
		Return .T.
	EndIf	
Else
	Return .T.
EndIf
	 
DbSelectArea(cAlias)

Return .T.