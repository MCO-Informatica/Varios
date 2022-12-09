#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA080TIT  �Autor  �Henio Brasil        � Data �  10/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para tratar o codigo de banco a ser usado    ���
���          �na baixa de Titulos a Receber - Botao de Confirmacao        ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA080TIT() 

Local lReturn 	:= .t.   		
Local lOrigBco	:= If(Posicione("SA6", 1, xFilial("SA6")+cBanco+cAgencia+cConta, "A6_ORIGBCO")=='1', .t., .f.) 
/*
��������������������������������������������������������������Ŀ
�Consiste informacoes importantes no Cadastro do Cliente       �
����������������������������������������������������������������*/     
If cMotBx$"DEBITO CC/NORMAL" .And. (Left(cBanco,2) == 'CX' .Or. !lOrigBco)
   MsgStop(" Atencao... Este banco "+cBanco+" n�o pode ser utilizado para baixar Titulos a Receber! ") 
   lReturn := .f.
Endif 

Return(lReturn) 