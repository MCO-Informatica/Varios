#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CTA120MNU  � Autor � Tatiana Pontes 	   � Data � 11/04/13  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para adicionar botoes ao menu principal   ���
���          � da rotina (CNTA120).										  ���
���          � Criado para liberar pedidos de venda gerado por contratos  ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTA120MNU()
	
	Local _cPvContr	:= Alltrim(GetMv("MV_PVCONTR")) // Gera pedido de venda atraves do modulo de gestao de contratos (S/N)
	
	If	_cPvContr == "S" 
		AAdd( aRotina, { 'Lib. Pedidos' , 'U_GCTA010' , 0, 2 } )
		//AAdd( aRotina, { 'Sol.Aprovacao', 'U_CSGCT002', 0, 3 } )
    Endif
    
Return(aRotina)