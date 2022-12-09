#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa º FA050DEL º Autor º Luiz Alberto     º Data º  MAR/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Funcao   º Ponto de entrada para Alçada Financeiro          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      º Personalizacao METALACRE                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA050DEL()
Local cChave	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)	// Chave Busca
Local nTamanho  := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + TamSX3("E2_TIPO")[1] + TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1]
Local _aArea 	:= GetArea()
Local _aAreaSE2	:= SE2->(GetArea())
Local _aAreaSED	:= SED->(GetArea())
Local _aAreaSA2	:= SA2->(GetArea())


If Empty(SE2->E2_TITPAI) .And. Alltrim(SE2->E2_ORIGEM) == 'FINA050' .And. !AllTrim(SE2->E2_TIPO) $ 'PA,PR,NDF'
	
	// Limpa o Cadastro de Controle de Alçadas Para Regravação Caso Já Exista
	
	If SCR->(dbSetOrder(1), dbSeek(xFilial("SCR")+'PG'+PadR(cChave,nTamanho)))
		While SCR->(!Eof()) .And. AllTrim(SCR->CR_NUM) == AllTrim(PadR(cChave,nTamanho)) .And. SCR->CR_FILIAL == xFilial("SCR")
			If SCR->CR_TIPO == 'PG'
				If RecLock("SCR",.f.)
					SCR->(dbDelete())
					SCR->(MSUnlock())
				Endif
			Endif
			
			SCR->(dbSkip(1))
		Enddo
	Endif

Endif



RestArea(_aAreaSA2)
RestArea(_aAreaSED)
RestArea(_aAreaSE2)

Return .T.