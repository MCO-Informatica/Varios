#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LP510H   � Autor � Sandra Nishida     � Data �  25/08/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � LP 510 - Retorna parte do historico                        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico MAKENI                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LP510H(_cseq)


	Local _nRet := sa2->a2_nreduz    

	_aAreaSa2 := SA2->(GetArea())
	_aAreaSed := SED->(GetArea())
	_aAreaSe2 := SE2->(GetArea())
	_aAreaSa6 := SA6->(GetArea())

	If _cseq == '020' .and. alltrim(se2->e2_naturez)$'222013/222014'

		DbSelectArea("SA2")
		If DbSeek(xFilial("SA2") + se2->e2_xforoper + se2->e2_xlojope)
			_nRet := sa2->a2_nreduz
		Endif

	Endif

	RestArea(_aAreaSa2)
	RestArea(_aAreaSed)
	RestArea(_aAreaSe2)
	RestArea(_aAreaSa6)


Return _nRet