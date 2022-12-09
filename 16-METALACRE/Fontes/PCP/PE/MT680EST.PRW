#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT680EST º Autor ³ Luiz Alberto       º Data ³  Abr/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada no Cancelamento do Lancamento de Prod Mo2  ±±
±±º          ³ Exclui Registro de Producao x Operadores      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT680EST()
Local nAcao := PARAMIXB[1]
Local lRet  := .T.
Local nReg  := SH6->(Recno())
Local aArea := SH6->(GetArea())
Local aAreaSD7 := SD7->(GetArea())
Local aAreaSC2 := SC2->(GetArea())

If nAcao == 2 
	// Checa Estorno na Qualidade	
	lRet := .F.
	If SD7->(dbSetOrder(4), DbSeek(xFilial('SD7')+SH6->H6_LOTECTL+SH6->H6_PRODUTO))
		While SD7->(!Eof()) .And. SD7->D7_FILIAL == xFilial("SD7") .And. SD7->D7_LOTECTL == SH6->H6_LOTECTL .And. SD7->D7_PRODUTO == SH6->H6_PRODUTO
			If SD7->D7_TIPO==1
				lRet := .F.
			Endif       
			If SD7->D7_TIPO==6 .Or. SD7->D7_TIPO==0
				lRet := .t.
			Endif       
			SD7->(dbSkip(1))
		Enddo
	Else
		lRet := .T.
	Endif 
	If !lRet
		MsgStop("Impossível Efetuar Estorno do Item " + AllTrim(SH6->H6_PRODUTO) + " do Lote " + AllTrim(SH6->H6_LOTECTL) + " Sem Estorno na Qualidade !")
		RestArea(aArea)
		RestArea(aAreaSD7)
		RestArea(aAreaSC2)				
		Return lRet
	Endif          
	
	// Checa se existe Operação Superior no Apontamento do Produto

	cProduto := SH6->H6_PRODUTO
	cOP		 := SH6->H6_OP
	cOperac  := SH6->H6_OPERAC
	lRet	 := .T.

	If SH6->(dbSetOrder(1), DbSeek(xFilial('SH6')+cOP+cProduto+cOperac))
		While SH6->(!Eof()) .And. SH6->H6_FILIAL == xFilial("SH6") .And. SH6->H6_OP == cOp .And. SH6->H6_PRODUTO == cProduto .And. SH6->H6_OPERAC >= cOPerac
			If SH6->H6_OPERAC > cOperac
				lRet := .F.
				Exit
			Endif
			SH6->(dbSkip(1))
		Enddo
	Endif
	
	SH6->(dbGoTo(nReg))
	
	If !lRet
		MsgStop("Impossível Efetuar Estorno do Item " + AllTrim(SH6->H6_PRODUTO) + " do Lote " + AllTrim(SH6->H6_LOTECTL) + " Operação " + AllTrim(SH6->H6_OPERAC) + " Pois Existe Apontamento com Operação Superior !")
		RestArea(aArea)
		RestArea(aAreaSD7)
		RestArea(aAreaSC2)				
		Return lRet
	Endif          

	// Verifica se Existe Sequencia 001 se Sim Não Permite o Estorno
	// 03997601002  

	If Right(AllTrim(SH6->H6_OP),3)<>'001'
		cProduto := SH6->H6_PRODUTO
		cOP		 := Left(SH6->H6_OP,8)+'001'
		cOperac  := SH6->H6_OPERAC
		lRet	 := .T.
	
		If SH6->(dbSetOrder(1), DbSeek(xFilial('SH6')+cOP))
			lRet := .f.
		Endif
		
		SH6->(dbGoTo(nReg))
		

		If !lRet
			MsgStop("Impossível Efetuar Estorno do Item " + AllTrim(SH6->H6_PRODUTO) + " do Lote " + AllTrim(SH6->H6_LOTECTL) + " Operação " + AllTrim(SH6->H6_OPERAC) + " Pois Existe Apontamento Sequência 001, é Necessário Estorna-la Primeiro !")
			RestArea(aArea)
			RestArea(aAreaSD7)
			RestArea(aAreaSC2)				
			Return lRet
		Endif          
	Endif          

	// Exclui Registros Gerados na Customizacao de Operadores
	
	cNumSeq := 	SH6->H6_IDENT
	cProduto:=  SH6->H6_PRODUTO  
	cNumOP	:=	SH6->H6_OP
		
	/// Localiza SD3

	cQry:= " SELECT R_E_C_N_O_ AS REGI " // QUERY QUE PEGA A ULTIMA OPERACAO PARA PODER ENDERECAR
	cQry+= " FROM "+RETSQLNAME("SD3")+" D3"
	cQry+= " WHERE D3_IDENT = '"+cNumSeq+"'"           
	cQry+= " AND D3.D_E_L_E_T_=''"  
	cQry+= " AND LEFT(D3.D3_COD,3) = 'MOD' "           
	cQry+= " AND D3.D3_OP = '" + cNumOp + "' " 
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	TCQUERY cQry New Alias "TRB"

	TRB->(dbGoTop())
	
	While TRB->(!EOF())
		SD3->(dbGoTo(TRB->REGI))

		If Left(SD3->D3_OBSERVA,4)	== '|Op|'	
			If RecLock("SD3",.F.)
				SD3->(dbDelete())
				SD3->(MsUnlock())
			Endif
		Endif
					
		TRB->(dbSkip(1))
	Enddo
	
	TRB->(dbCloseArea())
Endif          
RestArea(aArea)
RestArea(aAreaSD7)
RestArea(aAreaSC2)
Return lRet

