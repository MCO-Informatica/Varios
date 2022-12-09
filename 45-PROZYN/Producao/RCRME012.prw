#Include "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO6     �Autor  �Microsiga           � Data �  12/28/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RCRME012()

DbSelectArea("AD2")
dbSetOrder(1) //Oportunidade + Revis�o + Processo de Venda + Estagio
If dbSeek(xFilial("AD2") + _cOport + _cRevis + _cProce + "000004")
	If _cEstag == "000004" .AND. _cTipo == "1" .AND. !Empty(_Deciso) .AND. !Empty(_cInflu) .AND. !Empty(_cUsuar) .AND. !Empty(_cDescr)
		reclock ("AD2",.T.)
		AIJ->AIJ_DTINIC := M->AD1_DTINI4
	 	AIJ->AIJ_HRINIC := M->AD1_HRINI4
		AIJ->AIJ_DTENCE := M->AD1_DTFIM4
		AIJ->AIJ_HRENCE := M->AD1_HRFIM4
		AIJ->(MsUnlock())
	EndIf
EndIf

Return