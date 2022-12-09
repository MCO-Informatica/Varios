#INCLUDE "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFAT01    ºAutor  ³Guilherme Giuliano  º Data ³  28/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criação de rotina para gerar e estornar movimentaçoes no estº±±
±±º          ³oque sem necessidade de faturar o pedido                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gold Hair                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*****************************************************************************
User Function AFAT01(cNum,cTipo)
*****************************************************************************
local aArea := GetArea()
local _aAutoSD3 := {}
private lMsHelpAuto := .F.
private lMsErroAuto := .F.
private lGerou := .F.

dbselectarea("SC5")
dbsetorder(1)
IF dbseek(xFilial("SC5")+cNum)
	IF cTipo == "G"
		IF Empty(SC5->C5_NOTA)
			Begin Transaction
			IF MsgYesNo("Deseja Realmente gerar os movimentos no estoque deste pedido?")
				dbselectarea("SC9")
				SC9->(DbSetOrder(1)) // Exclui Pedido
				IF SC9->(DbSeek(xFilial("SC9") + cNum))
					While !SC9->(EOf()) .And. xFilial('SC9') == SC9->C9_FILIAL .And. cNum == SC9->C9_PEDIDO
						SC9->(a460Estorna())
						SC9->(DbSkip())
						loop
					Enddo
				ENDIF
				
				dbselectarea("SC6")
				dbsetorder(1)
				IF dbseek(xFilial("SC6")+cNum)
					while !SC6->(EOF()) .and. SC6->C6_NUM == SC5->C5_NUM
						IF SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT > 0
							_aAutoSD3 = {}
							aadd (_aAutoSD3, {"D3_TM","501",NIL})
							aadd (_aAutoSD3, {"D3_COD",SC6->C6_PRODUTO,NIL})
							aadd (_aAutoSD3, {"D3_QUANT",SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,NIL})
							aadd (_aAutoSD3, {"D3_LOCAL",SC6->C6_LOCAL,NIL})
							aadd (_aAutoSD3, {"D3_EMISSAO",ddatabase,NIL})
							aadd (_aAutoSD3, {"D3_DOC",SC6->C6_NUM+"/"+SC6->C6_ITEM,NIL})
							
							lMSErroAuto = .F.
							MsExecAuto({|x,y,z|MATA240(x,y,z)}, _aAutoSD3, 3)
							If lMsErroAuto
								DisarmTransaction()
								mostraerro()
							ELSE
								RecLock("SC6",.F.)
								SC6->C6_BLQ := "R"
								MsUnlock()
								
								dbSelectArea("SB2")
								dbSetOrder(1)
								IF dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
									RecLock("SB2",.F.)
									SB2->B2_QPEDVEN -= Max(SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,0)
									SB2->B2_QPEDVE2 -= ConvUM(SB2->B2_COD, Max(SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,0), 0, 2)
									MsUnlock()
								ENDIF
								lGerou := .T.
							ENDIF
						ENDIF
						SC6->(dbskip())
						LOOP
					ENDDO
				ENDIF
			ENDIF
			End Transaction
		ELSE
			msgalert("Pedido já encerrado!")
		ENDIF
		IF lGerou
			MsgInfo("Movimento(s) gerado com sucesso!")
			RecLock("SC5",.F.)
			SC5->C5_NOTA := "XXXXXXXXX"
			MsUnlock()
		ENDIF
	ELSEIF cTipo == "E"
		IF alltrim(SC5->C5_NOTA) == "XXXXXXXXX"
			Begin Transaction
			IF MsgYesNo("Deseja Realmente Estornar os movimentos no estoque deste pedido?")
				dbselectarea("SC6")
				dbsetorder(1)
				IF dbseek(xFilial("SC6")+cNum)
					while !SC6->(EOF()) .and. SC6->C6_NUM == SC5->C5_NUM
						_aAutoSD3 = {}
						aadd (_aAutoSD3, {"D3_TM","501",NIL})
						aadd (_aAutoSD3, {"D3_COD",SC6->C6_PRODUTO,NIL})
						aadd (_aAutoSD3, {"D3_QUANT",SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,NIL})
						aadd (_aAutoSD3, {"D3_LOCAL",SC6->C6_LOCAL,NIL})
						aadd (_aAutoSD3, {"D3_EMISSAO",ddatabase,NIL})
						aadd (_aAutoSD3, {"D3_DOC",SC6->C6_NUM+"/"+SC6->C6_ITEM,NIL})
						
						lMSErroAuto = .F.
						MsExecAuto({|x,y,z|MATA240(x,y,z)}, _aAutoSD3, 5)
						If lMsErroAuto
							DisarmTransaction()
							mostraerro()
						ELSE
							RecLock("SC6",.F.)
							SC6->C6_BLQ := ""
							MsUnlock()
							
							dbSelectArea("SB2")
							dbSetOrder(1)
							IF dbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
								RecLock("SB2",.F.)
								SB2->B2_QPEDVEN += Max(SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,0)
								SB2->B2_QPEDVE2 += ConvUM(SB2->B2_COD, Max(SC6->C6_QTDVEN-SC6->C6_QTDEMP-SC6->C6_QTDENT,0), 0, 2)
								MsUnlock()
							ENDIF
							
							lGerou := .T.
						ENDIF
						SC6->(dbskip())
						loop
					ENDDO
				ENDIF
			ENDIF
			End Transaction
		ELSE
			msgalert("Pedido Sem movimentações no estoque!")
		ENDIF
		IF lGerou
			MsgInfo("Estorno Concluido com sucesso!")
			RecLock("SC5",.F.)
			SC5->C5_NOTA := ""
			MsUnlock()
		ENDIF
	ENDIF
ENDIF
RESTAREA(aArea)
Return