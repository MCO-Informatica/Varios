#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT240TOK  ºAutor  ³Alexandre Santos    º Data ³  11/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar se o centro de custo pode fi-º±±
±±º          ³car em branco, somente se o campo da OP estiver em branco.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - MATA240 (Internos I)                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MT240TOK()
	Local aArea    := GetArea()
	Local aAreaSD3 := SD3->(GetArea())
	Local nPosOP   := M->D3_OP
	Local nPosCC   := M->D3_CC
	Local nPosTM   := M->D3_TM
	Local nPosCOD  := M->D3_COD
	Local cTipo	   := GetMV("ZZ_MOVTIPO")
	Local lRet     := .T.
 
	cZZTM    := POSICIONE("SF5",1,xFilial("SF5")+nPosTM,"F5_ZZOPCC")
	cTPPROD  := POSICIONE("SB1",1,xFilial("SB1")+nPosCOD,"B1_TIPO")
	cAproSF5 := POSICIONE("SF5",1,xFilial("SF5")+nPosTM,"F5_APROPR")
	cAproSB1 := POSICIONE("SB1",1,xFilial("SB1")+nPosCOD,"B1_APROPRI")

	If cZZTM == "1" .AND. EMPTY(Alltrim(nPosOP))
		Alert("Atenção!!! Preenchimento da Ordem de Produção é obrigatório.")
		lRet := .F.
	EndIf
	If cZZTM == "2" .AND. EMPTY(Alltrim(nPosCC))
		Alert("Atenção!!! Preenchimento do Centro de Custo é obrigatório.")
		lRet := .F.
	Endif
	If cZZTM == "3"
		lRet := .T.
	Endif
	If cZZTM == "1" .AND. !EMPTY(Alltrim(nPosCC))
		Alert("Atenção !!! Preenchimento da Centro de Custo não é obrigatório. Apenas Ordem de Produção !!!")
		lRet := .F.
	EndIf
	If cZZTM == "2" .AND. !EMPTY(Alltrim(nPosOP)) 
		Alert("Atenção !!! Preenchimento da Ordem de Produção não é obrigatório. Apenas de Centro de Custo !!!")
		lRet := .F.
	Endif
	If cTPPROD $ cTipo .AND. Substr(Alltrim(nPosCC),1,1) == '5' 
		Alert("Atenção !!! Preenchimento da Centro de Custo incorreto !!!")
		lRet := .F.
	Endif
	
	If cAproSF5$"N" .and. cAproSB1$"D"	
		Alert("Atenção !!! Tipo de Movimento não Permitido Para Este Produto !!!")
		lRet := .F.
	EndIf
	
	RestArea(aAreaSD3)
	RestArea(aArea)

RETURN lRet
