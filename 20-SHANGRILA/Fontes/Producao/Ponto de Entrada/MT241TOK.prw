#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT241TOK  �Autor  �Alexandre Santos    � Data �  11/05/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validar se o centro de custo pode fi-���
���          �car em branco, somente se o campo da OP estiver em branco.  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - MATA241 (Internos II)                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			Alert("Aten��o!!! Preenchimento da Ordem de Produ��o � obrigat�rio.")
			lRet := .F.
		EndIf
		If cZZTM == "2" .AND. EMPTY(Alltrim(CCC))
			Alert("Aten��o!!! Preenchimento do Centro de Custo � obrigat�rio.")
			lRet := .F.
		Endif
		If cZZTM == "3"
			lRet := .T.
		Endif
		If cZZTM == "1" .AND. !EMPTY(Alltrim(CCC))
			Alert("Aten��o !!! Preenchimento da Centro de Custo n�o � obrigat�rio. Apenas Ordem de Produ��o !!!")
			lRet := .F.
		EndIf
		If cZZTM == "2" .AND. !EMPTY(aCols[ _aux , nPosOP ]) //.AND. EMPTY(aCols[ _aux , nPosCC ])
			Alert("Aten��o !!! Preenchimento da Ordem de Produ��o n�o � obrigat�rio. Apenas de Centro de Custo !!!")
			lRet := .F.
		Endif
		If cTPPROD $ cTipo .AND. Substr(Alltrim(CCC),1,1) == '5'
			Alert("Aten��o !!! Preenchimento da Centro de Custo incorreto !!!")
			lRet := .F.
		Endif
	
		If cAproSF5$"N" .and. cAproSB1$"D"
			Alert("Aten��o !!! Tipo de Movimento n�o Permitido Para Este Produto !!!")
			lRet := .F.
			EndIf
	
	Endif
Next _aux

RestArea(aAreaSD3)
RestArea(aArea)

RETURN lRet
