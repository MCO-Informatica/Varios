#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F330FLTC  �Autor  �Henio Brasil        � Data �  28/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para travar o cancelamento de Compensacao    ���
���          �quando a data estiver menor que o parametro MV_DATAFIN      ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F330FLTC() 

Local lReturn 	:= .f.   		
Local dDataBlq	:= GetMV("MV_DATAFIN") 
/*
��������������������������������������������������������������Ŀ
�Consiste informacoes do Titulo NF que foi compensado no RA    �
����������������������������������������������������������������*/     
If SE5->E5_TIPO=='NF ' .And. SE5->E5_DATA <= dDataBlq 			// dDataBase >= dDataBlq 
   MsgStop(" Atencao... Este Estorno n�o poder� ser executado por bloqueio de data! ") 
   lReturn := .t.
Endif 

Return(lReturn) 