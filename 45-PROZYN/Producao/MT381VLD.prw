#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
����������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � MT381VLD   � Autor � Denis Varella     � Data � 12/08/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada que atualiza o lote de produtos ainda     ���
���Desc.     � n�o separados.                                             ���
���Desc.     �                                                            ���
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT381VLD
Local aArea := GetArea()
Local aOrdSep := {}
Local lRet	:= .T.

/*
If Altera
	//Fa�o um loop nos produtos da OP
	For nA := 1 to len(aCols)
		//Posiciono na SD4 do produto
		SD4->(DbGoTo(aCols[nA][len(aHeader)]))
		
		//Busco as ordens de separa��o amarradas a esta OP
		DbSelectArea("SZT")
		SZT->(DbSetOrder(3))
		SZT->(DbGoTop())
		If SZT->(DbSeek(xFilial("SZT")+cOP))
			aAdd(aOrdSep,SZT->ZT_ORDSEP)  //Separa��o Inteira
			aAdd(aOrdSep,SZT->ZT_ORDSEP2) //Separa��o Fracionada
			aAdd(aOrdSep,SZT->ZT_ORDSEP3) //Aglutina��o de Fracionada
			aAdd(aOrdSep,SZT->ZT_ORDSEP4) 
			
			//Fa�o a altera��o na SZT caso encontre o mesmo produto, com o mesmo lote anterior por�m novo lote diferente
			While SZT->(!EOF()) .and. SZT->ZT_OP == cOP
				If SZT->ZT_PROD == SD4->D4_COD .AND. SZT->ZT_LOTECTL == SD4->D4_LOTECTL; 
					.and. ((SD4->D4_LOTECTL != aCols[nA][GDFieldPos("D4_LOTECTL")]) .Or. (SD4->D4_QTDEORI != aCols[nA][GDFieldPos("D4_QTDEORI")])) 
					SZT->(RecLock("SZT",.F.))
					SZT->ZT_LOTECTL := aCols[nA][GDFieldPos("D4_LOTECTL")]
					SZT->ZT_QTDMUL	:= aCols[nA][GDFieldPos("D4_QTDEORI")] 
					SZT->ZT_QTDORI	:= aCols[nA][GDFieldPos("D4_QTDEORI")] 
					SZT->(MsUnlock())
				EndIF
				SZT->(DbSkip())
			EndDo
		EndIf
		
		For nOS := 1 to len(aOrdSep)
			CB8->(DbSetOrder(1))
			CB8->(DbGoTop())
			If CB8->(DbSeek(xFilial("CB8")+aOrdSep[nOS]))
				//Encontro todas as ordens de separa��o desta OP
				While CB8->(!EOF()) .AND. CB8->CB8_ORDSEP == aOrdSep[nOS] .AND. CB8->CB8_FILIAL == xFilial("CB8")
					
					//Fa�o a altera��o na CB8 caso encontre o mesmo produto, com o mesmo lote anterior por�m novo lote diferente
					If CB8->CB8_PROD == SD4->D4_COD .AND. CB8->CB8_LOTECTL == SD4->D4_LOTECTL; 
					.and. ((SD4->D4_LOTECTL != aCols[nA][GDFieldPos("D4_LOTECTL")]) .Or. (SD4->D4_QTDEORI != aCols[nA][GDFieldPos("D4_QTDEORI")]))
					
						CB8->(RecLock("CB8",.F.))
						CB8->CB8_LOTECT := aCols[nA][GDFieldPos("D4_LOTECTL")]
						CB8->CB8_QTDORI := aCols[nA][GDFieldPos("D4_QTDEORI")]
						CB8->CB8_SALDOS := aCols[nA][GDFieldPos("D4_QTDEORI")]
						CB8->(MsUnlock())
					EndIf
					CB8->(DbSkip())
				EndDo
			EndIf
			
			
		Next nOS
		
	Next nA
EndIf
*/
Return lRet
