#include 'protheus.ch'
#include 'parmtype.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RENPROJNAT �Autor  �Wellington Mendes Data �17/11/2017���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina paa apagar gatilho de projeto quando n�o houver necesi
dade do mesmo. ��
����������������������������������������������
����������������� Chamada Gatilho SE5                ������������������������
�����������������                                       ���������������������
�������������������������������������������������������������������������͹��
���Uso       � P11                                                       ����
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
��������������������������������������I���������������������������������������
*/

User Function RENPROJNAT(_cNat)

	Local _cAreaSED := GetArea("SED")
	Local _cAreaSZ3 := GetArea("SZ3")
	Local _cRetNat := ''
	Local _cRetproj := ''
	Local _lRet


	DbSelectArea("SZ3")
	DbSetOrder(1)
	IF SZ3->(DbSeek(xFilial("SZ3")+cEmpAnt+cFilAnt))
		_cRetproj:= SZ3->Z3_ITEM
	Endif

	DbSelectarea("SED")
	DbSetOrder(1)
	IF SED->(DbSeek(xFilial("SED")+_cNat))
		_cRetNat:= substr(alltrim(SED->ED_CONTA),1,3)// pega as 3 posi��es da conta contabil
	Endif
	Do Case
		Case substr(_cRetNat,1,1) == '6'
		_lRet:= .T.

		Case substr(_cRetNat,1,1) == '7'
		_lRet:= .T.

		Case _cRetNat == '123'
		_lRet:= .T.

		OTHERWISE
		
		_lRet:= .F.

	ENDCASE	

	If _lret == .F.
		_cRetproj:= ""	// Apaga projeto pois n�o ha necessidade
	Endif

	RestArea(_cAreaSED)
	RestArea(_cAreaSZ3)


Return (_cRetproj)	
