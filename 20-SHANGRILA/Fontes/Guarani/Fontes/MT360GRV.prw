#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT360GRV  �Autor  �Lucas Fl�ridi Leme  � Data �  04/10/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entradas responsavel pelo calculo do numero de     ���
���          �parcelas da condi��o de pagamento para o guarani            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11 Uninjet                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT360GRV
Processa({||U_RGUAA001(),"Calculando..."})
Return