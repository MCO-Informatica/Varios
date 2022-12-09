#include "protheus.ch"
#include "rwmake.ch"
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M410STTS ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 06/01/2010 ³±±
±±³          ³          ³       ³     MVG Consultoria     ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Corrige o Preco de Venda de Acordo com a Prioridade            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ LOTEC, LOTED, #                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ricaelle Industria e Comercio Ltda                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410STTS()

	Local _aArea	:= GetArea()
	Local nPrcVen	:= GDFieldGet("C6_PRCVEN",n)
	Local nValDif	:= nPrcVen
	Local lTransf	:= .F.
	Local _aAreaSC6
	Local cSvFil := cFilAnt


	If INCLUI .AND. !(AllTrim(FunName()) $ "TMKA271,MATA410")
	
		Reclock("SC5",.F.)
		SC5->C5_X_USERS := "e-commerce"
		SC5->C5_X_PROGR :=  "N"
		SC5->C5_NOMCLI  :=  Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
		SC5->C5_X_EMPFA :=  "0105"
		SC5->C5_XPRIORI  :=  "A"

		If Subs(SC5->C5_PEDECOM,1,3)$"PLT"
			SC5->C5_VOLUME1 :=  1
			SC5->C5_ESPECI1 :=  "VOLUME"
			SC5->C5_TRANSP  :=  "000178"
		EndIf

		SC5->(MsUnLock())

		DbSelectArea("SC9")
		DbSetOrder(1)
		If dbSeek(xfilial("SC9")+SC5->C5_NUM,.F.)
			While !Eof() .and. SC9->C9_PEDIDO == SC5->C5_NUM
				Reclock("SC9",.f.)
				SC9->C9_DATENT  := dDataBase
				SC9->C9_PEDECOM := SC5->C5_PEDECOM
				SC9->(MsUnLock())
				SC9->(dbSkip())
			EndDo
		EndIf

	EndIf
/*
	dbSelectArea("SC6")
	_aAreaSC6 := GetArea()
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+SC5->C5_NUM,.f.)

		While !Eof() .and. SC6->C6_FILIAL = SC5->C5_FILIAL .and. SC6->C6_NUM = SC5->C5_NUM
			If !SC5->C5_TIPO$"IPC"
				Do Case
				Case SC5->C5_XPRIORI == "A"
					If Inclui
						nPrcVen	:= SC6->C6_PRCTAB
						nValDif := SC6->C6_PRCVEN - nPrcVen
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB
						nValDif := SC6->C6_PRCTAB - nPrcVen
					Endif
				Case SC5->C5_XPRIORI == "B"
					If Inclui
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC1") //50%
						nValDif := SC6->C6_PRCVEN - nPrcVen
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC1") //50%
						nValDif := SC6->C6_PRCTAB - nPrcVen
					Endif
				Case SC5->C5_XPRIORI == "C"
					If Inclui
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC2") //40%
						nValDif := SC6->C6_PRCVEN - nPrcVen
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC2") //40%
						nValDif := SC6->C6_PRCTAB - nPrcVen
					Endif
				Case SC5->C5_XPRIORI == "D"
					If Inclui
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC3")//20%
						nValDif := SC6->C6_PRCVEN - nPrcVen
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC3") //20%
						nValDif := SC6->C6_PRCTAB - nPrcVen
					Endif
				Case SC5->C5_XPRIORI == "E"
					If Inclui
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC4")//70%
						nValDif := SC6->C6_PRCVEN - nPrcVen
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC4") //70%
						nValDif := SC6->C6_PRCTAB - nPrcVen
					Endif
				Case SC5->C5_XPRIORI == "F"
					If Inclui
						nPrcVen	:= SC6->C6_PRCVEN * GETMV("MV_X_PERC5")//70%
						nValDif := SC6->C6_PRCVEN - nPrcVen
					ElseIf Altera
						nPrcVen	:= SC6->C6_PRCTAB * GETMV("MV_X_PERC5") //70%
						nValDif := SC6->C6_PRCTAB - nPrcVen
					Endif

				Otherwise
					nPrcVen	:= SC6->C6_PRCVEN
					nValDif := 0
				EndCase

				dbSelectArea("SC6")
				Reclock("SC6",.F.)

				//			If Inclui
				//				SC6->C6_PRCTAB	:= nPrcven
				//			Endif

				SC6->C6_PRCVEN  := nPrcVen
				SC6->C6_PRUNIT	:= nPrcVen
				SC6->C6_PRCVEN2 := nValDif
				SC6->C6_VALOR 	:= nPrcVen * SC6->C6_QTDVEN
				MsUnlock()

				dbSelectArea("SC9")
				dbSetOrder(1)
				If dbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM,.F.)
					RecLock("SC9",.f.)
					SC9->C9_PRCVEN  := nPrcVen
					MsUnLock()
				EndIf

			EndIf

			dbSelectArea("SC6")
			dbSkip()

		EndDo
	EndIf
*/
	//RestArea(_aAreaSC6)
	RestArea(_aArea)

Return()
