#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT241TOK  ºAutor  ³Alexandre Santos    º Data ³  11/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar se o centro de custo pode fi-º±±
±±º          ³car em branco, somente se o campo da OP estiver em branco.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - MATA241 (Internos II)                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MT241TOK()
Local aArea    := GetArea()
Local aAreaSD3 := SD3->(GetArea())
Local nPosOP   := aScan( aHeader , { |x| Alltrim(x[2]) == "D3_OP"  } )
Local cTipo	   := GetMV("ZZ_MOVTIPO")
Local lRet     := .T.

cZZTM := POSICIONE("SF5",1,xFilial("SF5")+CTM,"F5_ZZOPCC")
cAproSF5 := POSICIONE("SF5",1,xFilial("SF5")+cTM,"F5_APROPR")


For _aux := 1 to Len(aCols)
	cTPPROD := POSICIONE("SB1",1,xFilial("SB1")+aCols[_aux,1],"B1_TIPO")
	cAproSB1:= POSICIONE("SB1",1,xFilial("SB1")+aCols[_aux,1],"B1_APROPRI")
	
	If !(aCols[ _aux , len(aHeader) + 1 ]) .AND. lRet
		If cZZTM == "1" .AND. EMPTY(aCols[ _aux , nPosOP ])
			Alert("Atenção!!! Preenchimento da Ordem de Produção é obrigatório.")
			lRet := .F.
		EndIf
		If cZZTM == "2" .AND. EMPTY(Alltrim(CCC))
			Alert("Atenção!!! Preenchimento do Centro de Custo é obrigatório.")
			lRet := .F.
		Endif
		If cZZTM == "3"
			lRet := .T.
		Endif
		If cZZTM == "1" .AND. !EMPTY(Alltrim(CCC))
			Alert("Atenção !!! Preenchimento da Centro de Custo não é obrigatório. Apenas Ordem de Produção !!!")
			lRet := .F.
		EndIf
		If cZZTM == "2" .AND. !EMPTY(aCols[ _aux , nPosOP ]) //.AND. EMPTY(aCols[ _aux , nPosCC ])
			Alert("Atenção !!! Preenchimento da Ordem de Produção não é obrigatório. Apenas de Centro de Custo !!!")
			lRet := .F.
		Endif
		If cTPPROD $ cTipo .AND. Substr(Alltrim(CCC),1,1) == '5'
			Alert("Atenção !!! Preenchimento da Centro de Custo incorreto !!!")
			lRet := .F.
		Endif
	
		If cAproSF5$"N" .and. cAproSB1$"D"
			Alert("Atenção !!! Tipo de Movimento não Permitido Para Este Produto !!!")
			lRet := .F.
			EndIf
	
	Endif
Next _aux

RestArea(aAreaSD3)
RestArea(aArea)

RETURN lRet
