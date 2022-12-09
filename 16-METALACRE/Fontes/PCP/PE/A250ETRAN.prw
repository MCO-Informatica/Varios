#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A250ETRAN ºAutor  ³Bruno Daniel Borges º Data ³  25/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos a confirmacao do apontamento da OP    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A250ETRAN()
Local aArea := GetArea()

If !Empty(SC2->C2_DATRF)
	//Atualiza o lacre como OP Apontada
	dbSelectArea("Z01")
	Z01->(dbSetOrder(2))
	If Z01->(dbSeek(xFilial("Z01")+SubStr(SC2->C2_NUM,1,6) ))
		Z01->(RecLock("Z01",.F.))
		Z01->Z01_STAT := "3"
		Z01->(MsUnlock())
	EndIf
EndIf

// Analisa a Inclusao da Ordem de Producao, se Gerou SD5 e SD3 Corretamente

If SD5->(dbSetOrder(2), dbSeek(xFilial("SD5")+SC2->C2_PRODUTO+SC2->C2_LOCAL+SC2->C2_NUM+SC2->C2_ITEM))
	cNumOP	:=	SD5->D5_OP
	cNumDoc	:=	SD5->D5_DOC
	cProduto:=	SD5->D5_PRODUTO
	cNumSeq	:=	SD5->D5_NUMSEQ          
	cCodTM	:=	SD5->D5_ORIGLAN
	
	If cCodTM == '010'	// Valida Inclusao de Producao Manual
		cQuery:= " SELECT R_E_C_N_O_ REGI " +CRLF
		cQuery+= " FROM " + RetSqlName("SD3") +  " D3   " +CRLF
		cQuery+= " WHERE D3_FILIAL = '"+XFilial("SD3")+"' AND D3.D_E_L_E_T_<>'*'  " +CRLF   
		cQuery+= " AND D3.D3_OP  = '"  + cNumOp + "' "+CRLF
		cQuery+= " AND D3.D3_DOC = '"  + cNumDoc + "' "+CRLF
		cQuery+= " AND D3.D3_COD = '"  + cProduto + "' "+CRLF
		cQuery+= " AND D3.D3_NUMSEQ = '"  + cNumSeq + "' "+CRLF
		cQuery+= " AND D3.D3_TM = '"  + cCodTm + "' "+CRLF
		
		DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TMPSD3", .F., .T. )
			  
		If Empty(TMPSD3->REGI)
			MsgStop("Atencao Problema no Lancamento desta Producao, Por Gentileza Informar o Depto de TI ! - Ordem de Producao: " + cNumOp)
		Endif
		
		TMPSD3->(dbCloseArea())
	Endif
Endif
RestArea(aArea)
Return Nil
