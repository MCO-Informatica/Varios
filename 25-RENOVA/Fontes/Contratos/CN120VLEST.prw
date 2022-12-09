#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CN120VLEST�Autor  �Wellington Mendes  � Data �  Jun/2016    ���
�������������������������������������������������������������������������͹��
���Desc.�Ponto de entrada que valida se permite ou n�o estorno medicao.   ���
�������������������������������������������������������������������������͹��
���Uso       � RENOVA                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CN120VLEST()

Local _CndMed := CND->CND_NUMERO
Local _cDtIncMed := CND->CND_DTINIC
Local _lret
Local _TipoDup := '' //Gravar quando o tipo do contrato for para gerar titulo
Local aArea		:= GetArea()


dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9") + CND->CND_CONTRA + CND->CND_REVISA)

dbSelectArea("CN1")
dbSetOrder(1)
dbSeek(xFilial("CN1") + CN9->CN9_TPCTO)
_TipoDup := CN1->CN1_CTRMED

IF DTOS(_cDtIncMed) <= '20160523'  // Data da globalizacao - compartilhamento da CN9 e tabelas relacionadas.
	MsgStop("A medi��o: "+_CndMed+" foi inclu�da antes (Data de Corte 23/05/2016) do processo de globaliza��o dos contratos, a mesma n�o poder� ser estornada.")
	_lret:=.F.
Elseif DTOS(_cDtIncMed) <= '20180318' .AND. _TipoDup == '2'
	MsgStop("A medi��o: "+_CndMed+" foi inclu�da antes de 18/03/2018, Medi��es de contratos do tipo PC N�O anterior a essa data n�o poder�o ser estornadas.")
	_lret:=.F.
Else
	_lret:= .T.
Endif

RestArea(aArea)

RETURN(_lret)
