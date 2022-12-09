#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA070CA4  �Autor  �Henio Brasil        � Data �  10/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para tratar o Cancelamento de Baixa de modo  ���
���          �a tratar o E5_LA do 1o. titulo baixado.                     ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA070CA4() 

Local aAreaSE1 	:= GetArea() 
Local cTitSe1 	:= SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO 
/*
��������������������������������������������������������������Ŀ
�Consiste informacoes importantes no Cadastro do Cliente       �
����������������������������������������������������������������*/  
DbSelectArea("SE5") 
If SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO == cTitSe1
   	If RecLock("SE5", .F.) 
   	   SE5->E5_LA := "S" 
       MsUnlock() 
   	Endif 	  
Endif 

SC5->( dbSetOrder(1) )
IF SC5->( dbSeek(cFilAnt + SE1->E1_PEDIDO) )
	IF SC5->C5_XORIGPV == '6'
		//NF Devolu��o referente a Contratos para estornar quantidade faturada
		FwMsgRun(,{|| U_A680BXCan( SE1->E1_NUM, SE1->E1_SERIE, SE1->E1_CLIENTE+SE1->E1_LOJA, 5 ) },,'Aguarde, verificando se h� faturamento de medi��o...')
	EndIF
EndIF

RestArea(aAreaSE1)
Return(.t.) 