#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RENCLORC/RENTIPC �Autor  �Wellington Mendes Data �22/05/2017���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina paa carregar Classe Or�amentaria na contabiliza��o de ��
multa/Juros e No realizado PCO ����������������������������������������������
����������������� Chamada Contabil LPs = 530/531/532 ������������������������
����������������� Chamada PCO Processos = 000005/000006 ���������������������
�������������������������������������������������������������������������͹��
���Uso       � P11                                                       ����
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
��������������������������������������I���������������������������������������
*/

User Function RENCLORC(_cConta,_cFil)

Local _cAreaZ3 := GetArea("SZ3")
Local _cAreaCV0 := GetArea("CV0")
Local _cRetParteCL := ''
Local _cRetClasse := ''
Local _cCamada := ''


DbSelectArea("SZ3")
IF SZ3->(DbSeek(xFilial("SZ3")+'00'+_cFil))
	_cCamada:= substr(SZ3->Z3_ITEM,1,2)
Endif

DbSelectarea("CV0")
CV0->( DbOrderNickName("XCONTA"))
IF CV0->(DbSeek(xFilial("CV0")+Alltrim(_cConta))) .AND. CV0->CV0_BLOQUE == '2'
	_cRetParteCL:= substr(CV0_CODIGO,3,9)
	_cRetClasse := _cCamada+_cRetParteCL
	
Endif

RestArea(_cAreaZ3)
RestArea(_cAreaCV0)

Return (_cRetClasse)


/*
//////////////////////////////////////////////////////////////////////
BUSCA TIPO DE CUSTO ATRAV�S DA CONTA INFORMADA VIA PARAMETRO DA ROTINA
//////////////////////////////////////////////////////////////////////
*/
User Function RENTIPC(_cConta2)

Local _cAreaCV02 := GetArea("CV0")
Local _cRetTipc := ''

DbSelectarea("CV0")
CV0->( DbOrderNickName("XCONTA"))
IF CV0->(DbSeek(xFilial("CV0")+Alltrim(_cConta2))) .AND. CV0->CV0_BLOQUE == '2'
	_cRetTipc:= substr(CV0_CODIGO,3,5)
	
Endif

RestArea(_cAreaCV02)

Return (_cRetTipc)

