
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATC010  �Autor  �Rogerio Nagy        � Data �  08/03/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Mostra Amarracao Socio x Clientes                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATC010()

PRIVATE aRotina   := { {"Pesquisa","AxPesqui"  , 0 , 1},;	
					   {"Visualiza","AxVisual", 0 , 2} }	
Private cCadastro := "Amarra��o S�cios x Cliente"

DbSelectArea("SZ2")

mBrowse(6,1,22,75,"SZ2",,,,,)          

Return .t.