#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  RN00040  �Autor  �                				16/10/2015���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica na digita��o da classe de valor a exist�ncia do    ���
��           �projeto								                      ���
�������������������������������������������������������������������������͹��
���Uso       � Renova                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/
User Function RN00040
Local _lRet := .T.
Local _cAreaSe5 := GetArea("SE5")
Local _cItemD := Alltrim(M->E5_ITEMD)
Local _cItemC := Alltrim(M->E5_ITEMC)
Local _cClasD := Alltrim(M->E5_EC05DB)
Local _cClasC := Alltrim(M->E5_EC05CR)
Local _cMens := ''
If Empty(_cClasD) .and. Empty(_cClasC)
	_lRet := .T.
Else
	If Empty(_cItemD) .or. Empty(_cItemC)
		if Empty(_cItemD) .and. Empty(_cItemC)
			_cMens := "Projetos Debito ou Cr�dito"
		Else
			if ! Empty(_cClasC) .and. Empty(_cItemC)
				_cMens := "Projeto Cr�dito"
			Endif
			
			if ! Empty(_cClasD) .and. Empty(_cItemD)
				_cMens := "Projeto D�bito"
			Endif
			//
			//	_cMens := "Projeto D�bito"
			//Endif
		Endif
		if _cMens <> ''
			ShowHelpDlg("RN00040",{"Sequencia de digita��o na classifica��o cont�bil dever ser respeitada.",""},3,;
			{"Informe "+iif(Empty(_cItemD) .and. Empty(_cItemC),"os campos ","o campo ")+_cMens,""},3)
			_lRet := .F.
		Endif
	Endif
Endif
RestArea(_cAreaSe5)
Return(_lRet)
