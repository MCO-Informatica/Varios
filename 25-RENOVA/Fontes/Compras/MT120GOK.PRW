#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MT120GOK  ºAutor  ³Pedro Augusto       º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na gravacao do pedido:no momento em que     ±±
±±º           o pedido de compra é gerado                                 º±±
±±ºUso       ³ Exclusivo CIP                                              º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120GOK
Local lRet := .t.
Local aArea		:= GetArea()
Local _cNumped  := SC7->C7_NUM

If !IsinCallStack("CNTA120")  // Só grava o grupo de aprovação para pedidos gerados diretos, sem ser por medição.
	If Inclui .or. altera
		DbSelectArea("SC7")
		DbSetOrder(1)
		DbSeek(xFilial("SC7")+_cNumped)
		
		DbSelectArea("SC1")
		DbSetOrder(1)
		DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC)
		
		DbSelectArea("SC7")
		
		While SC7->C7_FILIAL + SC7->C7_NUM == xFilial()+_cNumped .AND. !SC7->(Eof())
			Reclock("SC7",.F.)
			SC7->C7_WF			:= Space(1)   	                        // Status 1 - envio email
			SC7->C7_WFID		:= Space(10)   							// Rastreabilidade
			SC7->C7_APROV		:= SC1->C1_GRAPROV   					// Busca Gr. Aprov das SCs associadas
			MSUnlock()
			DbSkip()
		Enddo

		DbSelectArea("SCR")
		DbSetOrder(1)			
		If SCR->(DbSeek(xFilial("SCR") + "PC" + Padr(_cNumped, TamSX3("CR_NUM")[1])))  
			//PARA CADA USUARIO ELE IRÁ VERIFICAR SE ESTÁ DE FÉRIAS OU NÃO
			While SCR->(CR_FILIAL + CR_TIPO + CR_NUM) = xFilial("SCR") + "PC" + _cNumped  .AND.  !SCR->(Eof()) 
				DbSelectArea("SAK")
				DbSetOrder(1)
				//SE O USUÁRIO TIVER COM A DATA PREENCHIDA, ELE VERIFICA SE HOJE O INTERVALO ESTÁ ATIVO
				IF SAK->(DbSeek(xFilial("SAK")+SCR->CR_APROV)) .AND. (!Empty(SAK->AK_XDTFERI) .And. !Empty(SAK->AK_XDFERIA))
					IF (Date() >= SAK->AK_XDTFERI .And. Date() <= SAK->AK_XDFERIA)
						IF !Empty(SAK->AK_APROSUP)								
							Reclock("SCR",.F.) //Jogo aqui pra dentro o código do usuáiro do APROVADOR SUPERIOR
								SCR->CR_USER := Posicione("SAK",1,xFilial("SAK")+SAK->AK_APROSUP,"AK_USER")
								SCR->CR_WF		:= Space(01)
								SCR->CR_WFID   	:= Space(10) //CR_XWFID
								SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
								SCR->CR_HRLIMIT	:= Space(5)
							MSUnlock()
						ENDIF
					ELSE
							Reclock("SCR",.F.)//Retorna o aprovador padrão se periodo de ferias acabou
                            SCR->CR_USER    := Posicione("SAK",1,xFilial("SAK")+SAK->AK_COD,"AK_USER")//fim do periodo de ferias
							SCR->CR_WF		:= Space(01)
							SCR->CR_WFID   	:= Space(10) //CR_XWFID
							SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
							SCR->CR_HRLIMIT	:= Space(5)
						MSUnlock()																	
					ENDIF
				ELSE
					Reclock("SCR",.F.)
						SCR->CR_WF		:= Space(01)
						SCR->CR_WFID   	:= Space(10) //CR_XWFID
						SCR->CR_DTLIMIT	:= CtoD("  /  /  ")
						SCR->CR_HRLIMIT	:= Space(5)
					MSUnlock()											
				ENDIF
			SCR->(DbSkip())
			Enddo						
		Endif

	Endif
Endif
RestArea(aArea)
Return lRet
