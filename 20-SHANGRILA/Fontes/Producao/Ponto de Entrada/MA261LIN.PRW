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
USER FUNCTION MA261LIN()
	Local aArea    := GetArea()
	Local aAreaSD3 := SD3->(GetArea())
	Local lRet     := .T.

	_cCodOrig := aCols[n,1]
	_cCodDest := aCols[n,6]

	cAproSB1 := POSICIONE("SB1",1,xFilial("SB1")+_cCodDest,"B1_X_MOVTO")


	If cAproSB1$"N"
		Alert("Atenção !!! Transferencia não Permitida Para Este Produto !!! "+_cCodDest)
		Return .F.
	EndIf
	cAproSB1 := POSICIONE("SB1",1,xFilial("SB1")+_cCodOrig,"B1_X_MOVTO")


	If cAproSB1$"N"
		Alert("Atenção !!! Transferencia não Permitida Para Este Produto !!! "+_cCodOrig)
		Return .F.
	EndIf


	If POSICIONE("SB1",1,xFilial("SB1")+_cCodDest,"B1_TIPO") != POSICIONE("SB1",1,xFilial("SB1")+_cCodOrig,"B1_TIPO")
		Alert("Tipo dos produtos devem ser iguais")
		Return .F.
	EndIf

	If Substr(_cCodOrig,1,1) == "Z" .and. Substr(_cCodDest,1,1) != "Z"
		Alert("Nao pode ser transferido um produto Z para gerar um produto Não Z")
		Return .F.
	ElseIf Substr(_cCodOrig,1,1) != "Z" .and. Substr(_cCodDest,1,1) == "Z"
		Alert("Nao pode ser transferido um produto Não Z para gerar um produto Z")
		Return .F.
	EndIf

	RestArea(aAreaSD3)
	RestArea(aArea)

RETURN lRet
