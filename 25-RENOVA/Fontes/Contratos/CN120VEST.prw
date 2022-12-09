#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CN120VEST �Autor  �Gileno Pereira        Data �  Fev/2020   ���
�������������������������������������������������������������������������͹��
���Desc.     � N�o permite exclus�o de medi��o de arrendamento se o titulo���
���          � a pagar estiver em recupera��o Judicial                    ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CN120VEST()

Local _lRet  := := IIF(FunName() == 'CNTA120',PARAMIXB[1],.T.)//PARAMIXB[1] subsitituido pro andre
Local _aArea := GetArea()
Local cData  

If _lRet .And. !Empty(CND->CND_XTITPG) //Pego numero do titulo do cabe�alho da medi��o
	dbSelectArea("SE2")
	dbSetOrder(1)
	If dbSeek(xFilial("SE2") + CND->CND_XTITPG)
		While (xFilial("SE2") + CND->CND_XTITPG == SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA))
			cData:= dtos(SE2->E2_DATALIB)
			If !Empty(SE2->E2_DATALIB)   
				_lRet := .T.  //Data preenchida
			Else
				_lRet := .F.  //Data em Branco
			EndIF
					
			If !_lRet //se n�o foi liberado
				Aviso("Aten��o!!!","Esse t�tulo encontra-se em Recupera��o Judicial, portanto a medi��o n�o poder� ser estornada.",{"Ok"})
				Exit
			EndIf
			SE2->(dbSkip())
		EndDo
	EndIf
EndIf

RestArea(_aArea)
Return(_lRet)
