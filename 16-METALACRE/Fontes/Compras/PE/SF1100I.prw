#INCLUDE "TOPCONN.CH"
#include 'Ap5Mail.ch'
#include "rwmake.ch"
/*
PONTO.......: SF1100I           PROGRAMA....: MATA103
DESCRIÇÄO...: APOS GRAVACAO DO SF1
UTILIZAÇÄO..: Executado apos gravacao do SF1
PARAMETROS..: Nenhum
RETORNO.....: Nenhum
*/
User Function SF1100I()
aAreaSF1    := SF1->(GetArea())         // salva área do arquio atual
aAreaSD1	:= SD1->(GetArea())

If SF1->(FieldPos("F1_NOMFOR")) > 0 //cEmpAnt == '01' .And. Empty(SF1->F1_NOMFOR)
	If SF1->F1_TIPO == 'N'
		Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"")
		If RecLock("SF1",.f.)
			SF1->F1_NOMFOR	:= SA2->A2_NOME
			SF1->(MsUnlock())
		Endif
	Else
		Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"")
		If RecLock("SF1",.f.)
			SF1->F1_NOMFOR	:= SA1->A1_NOME
			SF1->(MsUnlock())
		Endif                         
	Endif
Endif                    

// Atualiza Nota Fiscal na Tabela de Inspeção de Processos para OP´s de Beneficiamento

If SD1->(dbSetOrder(1), dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)) .And. QPK->(FieldPos("QPK_XNF")) > 0
	While SD1->(!Eof()) .And. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) .And. SD1->D1_FILIAL == xFilial("SD1")
		If Left(SD1->D1_OP,1)$'X'	// Op de Beneficiamento
			If QPK->(dbSetOrder(1), dbSeek(xFilial("QPK")+SD1->D1_OP)) 
				If !Empty(QPK->QPK_XNF) .And. !AllTrim(SF1->F1_DOC)$QPK->QPK_XNF		// Se Já Estiver Preenchido, Porém Outra Nota
					If RecLock("QPK",.f.)
						QPK->QPK_XNF	:=	AllTrim(QPK->QPK_XNF)+'/'+SF1->F1_DOC
						QPK->(MsUnlock())
					Endif
				ElseIf Empty(QPK->QPK_XNF)											// Apenas se Estiver Vazio
					If RecLock("QPK",.f.)
						QPK->QPK_XNF	:=	SF1->F1_DOC
						QPK->(MsUnlock())
					Endif
				Endif
			Endif
			
			// Se Tiver Titulo provisorio na OP então Baixa
			
			// Ordem de Produção Beneficiamento, gera previas no contas a pagar
			
			cFornece	:=	SD1->D1_FORNECE
			cLoja		:=	SD1->D1_LOJA
			cDocto		:=	PadL(Left(SD1->D1_OP,8),9,'0')
			
			// Exclui Todos os Titulos Provisorios do Pedido
		
			If SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+'PRE'+cDocto))
				While SE2->(!Eof()) .And. SE2->E2_FILIAL == xFilial("SE2") .And. SE2->E2_NUM == cDocto
					If Alltrim(SE2->E2_TIPO) $ 'PR*PRE' .And. SE2->E2_FORNECE == cFornece .And. SE2->E2_LOJA == cLoja
						If RecLock("SE2",.f.)
							SE2->(dbDelete())
							SE2->(MsUnlock())
						Endif
					Endif
						
					SE2->(dbSkip(1))
				Enddo
			Endif
		Endif
		
		SD1->(dbSkip(1))
	Enddo
Endif			
RestArea(aAreaSF1)            // restaura área do arquivo atual
RestArea(aAreaSD1)            // restaura área do arquivo atual
Return