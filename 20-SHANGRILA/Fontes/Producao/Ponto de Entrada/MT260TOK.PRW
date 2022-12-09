#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT260TOK  ºAutor  ³Alexandre Santos    º Data ³  24/09/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar se a transferencia do produtoº±±
±±º          ³ com base no campo B1_X_MOVTO                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - MATA260 (Transferencia I)                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MT260TOK()
	Local aArea    := GetArea()
	Local aAreaSD3 := SD3->(GetArea())
	Local lRet     := .T.


	cAproSB1 := POSICIONE("SB1",1,xFilial("SB1")+CCODDEST,"B1_X_MOVTO")


	If cAproSB1$"N"
		Alert("Atenção !!! Transferencia não Permitida Para Este Produto !!!")
		lRet := .F.
	EndIf
	cAproSB1 := POSICIONE("SB1",1,xFilial("SB1")+cCodOrig,"B1_X_MOVTO")


	If cAproSB1$"N"
		Alert("Atenção !!! Transferencia não Permitida Para Este Produto !!!")
		lRet := .F.
	EndIf

	If POSICIONE("SB1",1,xFilial("SB1")+CCODDEST,"B1_TIPO") != POSICIONE("SB1",1,xFilial("SB1")+cCodOrig,"B1_TIPO")
		Alert("Tipo dos produtos devem ser iguais")
		Return .F.
	EndIf
	If Substr(cCodOrig,1,1) == "Z" .and. Substr(CCODDEST,1,1) != "Z"
		Alert("Nao pode ser transferido um produto Z para gerar um produto Não Z")
		Return .F.
	ElseIf Substr(cCodOrig,1,1) != "Z" .and. Substr(CCODDEST,1,1) == "Z"
		Alert("Nao pode ser transferido um produto Não Z para gerar um produto Z")
		Return .F.
	EndIf

	RestArea(aAreaSD3)
	RestArea(aArea)

RETURN lRet
