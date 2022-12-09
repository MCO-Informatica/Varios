#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA450PED º Autor ³ Giane - ADV Brasil º Data ³  26/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para gravar o log de liberacao estoque    º±±
±±º          ³ na liberacao automatica                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / faturamento/liberacao estoque automat. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA450PED()
Local _aArea   := GetArea()
Local lEstoque := .f.
Local lCredESt := .f.
Local cPedido
Local _lLibCred := .f.
Local _lLibEst  := .f.
Local cEvento   := ""
Local nReg1     := SC9->(Recno())
//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MA450PED" , __cUserID )

//apenas liberacao automatica
	if (isincallstack("MATA455"))
		lEstoque := .t.
	Endif
	if (isincallstack("MATA456")) 
		lCredEst := .t.
	Endif

cPedido := Paramixb[1]

//como libera por pedido, tem que gravar log de todos os itens??
DbSelectArea("SC9")
DbSetorder(1)
DbSeek(xfilial("SC9")+cPedido)
Do while !eof() .and. SC9->C9_FILIAL + SC9->C9_PEDIDO == xfilial("SC9")+cPedido
	cEvento := 'Liberacao Estoque - AUTOMATICA - MA450PED"
	If lEstoque .AND. empty(SC9->C9_BLEST)
		U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,cEvento, ,SC9->C9_ITEM)
	endif
	
	//se a chamada foi da lib.cred/estoque
	if lCredEst
		
		DbSelectArea("SZ7")
		DbSetorder(1)
		If DbSeek(SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM + SC9->C9_CLIENTE+SC9->C9_LOJA+SC9->C9_PRODUTO)
			
			If !empty(SZ7->Z7_BLCRED) .and. empty(SC9->C9_BLCRED)
				_lLibCred := .t.
			endif
			
			if !empty(SZ7->Z7_BLEST) .and. empty(SC9->C9_BLEST)
				_lLibEst := .t.
			endif
			
			if _lLibCred .and. _lLibEst
				cEvento := 'Liberacao Cred/Est'
			elseif _lLibCred
				cEvento := 'Liberacao Credito'
			elseif _lLibEst
				cEvento := 'Liberacao Estoque'
			endif
			
			if !empty(cEvento)
				U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,cEvento, ,SC9->C9_ITEM)
			endif
			
			DbSelectArea("SZ7")
			Reclock("SZ7")
			SZ7->(DbDelete())
			MsUnlock()
			
		Endif
		
		DbSelectArea("SC9")
	endif
	
	DbSkip()
Enddo

SC9->(DbGoto(nReg1))

RestArea(_aArea)
Return


#Include  'Protheus.ch'

User Function M310PPED()

alert  ('Acionamento do ponto de entrada M310PPED')

Return
