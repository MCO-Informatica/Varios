#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT440VLD  �Autor  �Opvs (David)        � Data �  26/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para filtrar os tipos de Produto no browse   ���
���          �de liberacao de Pedidos de Venda                            ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT440VLD() 


//Perguntas sobre o Filtro Personalizado
pergunte("CCP004", .T.)

//Pergunta Padr�o que deve ser carregada novamente para que n�o sejam perdidas a parametriza��o inicial
pergunte("MTALIB", .F.)

Return(.T.) 