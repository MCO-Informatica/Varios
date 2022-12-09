#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LP510C   � Autor � Sandra Nishida     � Data �  25/08/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � LP 510 - Retorna numero de conta                           ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LP510C(_cseq)


	Local _nRet := ' '    

	_aAreaSa2 := SA2->(GetArea())
	_aAreaSed := SED->(GetArea())
	_aAreaSe2 := SE2->(GetArea())
	_aAreaSa6 := SA6->(GetArea())

	ALERT(_cseq)
	alert(se2->e2_xforoper + ' ' + se2->e2_num)
	If _cseq == '020'.and. alltrim(se2->e2_naturez)$'222013/222014'

		DbSelectArea("SA2")
		If DbSeek(xFilial("SA2") + se2->e2_xforoper + se2->e2_xlojope)
			_nRet := sa2->a2_conta
		Endif

	Endif

	RestArea(_aAreaSa2)
	RestArea(_aAreaSed)
	RestArea(_aAreaSe2)
	RestArea(_aAreaSa6)


Return _nRet