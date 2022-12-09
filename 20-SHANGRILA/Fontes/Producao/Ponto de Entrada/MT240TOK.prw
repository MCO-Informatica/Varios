#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT240TOK  �Autor  �Alexandre Santos    � Data �  11/05/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validar se o centro de custo pode fi-���
���          �car em branco, somente se o campo da OP estiver em branco.  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST - MATA240 (Internos I)                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Alert("Aten��o!!! Preenchimento da Ordem de Produ��o � obrigat�rio.")
		lRet := .F.
	EndIf
	If cZZTM == "2" .AND. EMPTY(Alltrim(nPosCC))
		Alert("Aten��o!!! Preenchimento do Centro de Custo � obrigat�rio.")
		lRet := .F.
	Endif
	If cZZTM == "3"
		lRet := .T.
	Endif
	If cZZTM == "1" .AND. !EMPTY(Alltrim(nPosCC))
		Alert("Aten��o !!! Preenchimento da Centro de Custo n�o � obrigat�rio. Apenas Ordem de Produ��o !!!")
		lRet := .F.
	EndIf
	If cZZTM == "2" .AND. !EMPTY(Alltrim(nPosOP)) 
		Alert("Aten��o !!! Preenchimento da Ordem de Produ��o n�o � obrigat�rio. Apenas de Centro de Custo !!!")
		lRet := .F.
	Endif
	If cTPPROD $ cTipo .AND. Substr(Alltrim(nPosCC),1,1) == '5' 
		Alert("Aten��o !!! Preenchimento da Centro de Custo incorreto !!!")
		lRet := .F.
	Endif
	
	If cAproSF5$"N" .and. cAproSB1$"D"	
		Alert("Aten��o !!! Tipo de Movimento n�o Permitido Para Este Produto !!!")
		lRet := .F.
	EndIf
	
	RestArea(aAreaSD3)
	RestArea(aArea)

RETURN lRet
