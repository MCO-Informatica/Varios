#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F040BLQ   �Autor  �Henio Brasil        � Data �  18/06/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para Bloquear inclusoes de titulos com data  ���
���          �inferior a data de bloqueio de movimentacoes MV_DATAFIN     ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F040BLQ() 

Local lContInclui := .T. 
Local dDataMovFin	:= GetMv("MV_DATAFIN") 

If dDataBase < dDataMovFin
	MsgStop(" Nao � permitida a Movimenta��o de Titulos nesta data! ") 
	lContInclui := .F. 
Endif 

Return(lContInclui) 