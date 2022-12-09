#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050UPD  �Autor  �Henio Brasil        � Data �  18/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para Bloquear inclusoes de titulos com data  ���
���          �inferior a data de bloqueio de movimentacoes MV_DATAFIN     ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA050UPD() 

Local lContInclui := .T. 
Local dDataMovFin	:= GetMv("MV_DATAFIN") 

If dDataBase < dDataMovFin
	MsgStop(" Nao � permitida a Movimenta��o de Titulos nesta data! ") 
	lContInclui := .F. 
Endif 

Return(lContInclui) 