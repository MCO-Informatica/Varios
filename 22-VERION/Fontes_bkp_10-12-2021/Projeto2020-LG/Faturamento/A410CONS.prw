#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A410CONS  �Autor  �BS3			 � Data � 08/12/2007  ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E para adiconar novos Botoes na Tela de Pedido de Venda.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8.11.											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A410CONS()

Local aButtons	:= {}

//��������������������������������������������������������������Ŀ
//�Se nao for uma inclusao, mostra botao para visualizar Itens   �
//�de Devolucao e Contas a Receber.								 �
//����������������������������������������������������������������
If	!INCLUI
	aAdd( aButtons, { "NOTE" 	    , { || U_AFAT001() } ,"Incluir Devolu��o"  ,"Incluir Devolu��o"  })
	aAdd( aButtons, { "ANALITICO" 	, { || U_CFAT001() } ,"Consultar Devolu��o","Consultar Devolu��o"})
	//aAdd( aButtons, { "SDUIMPORT" 	, { || U_RFAT001() } ,"Imprimir Devolu��o" ,"Imprimir Devolu��o" })
EndIf
                                                                                          
If funname()=="MATA410"  .or. funname()=="VERFEPV"
   Aadd(aButtons,{"BUDGETY"  ,{||u_MATR731a()}   ,"Impressao Pedido de Vendas"})
EndIf

Return(aButtons)