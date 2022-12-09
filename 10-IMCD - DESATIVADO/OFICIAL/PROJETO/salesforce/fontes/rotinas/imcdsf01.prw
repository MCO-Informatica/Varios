#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMCDSF01  �Autor  �Junior Carvalho     �Data  � 10/09/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para Cadastro de Principal                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���                            MANUTENCAO                                 ���
�������������������������������������������������������������������������͹��
��� SEQ  � DATA       | DESCRICAO                                         ���
�������������������������������������������������������������������������͹��
��� 001  �            |                                                   ���
���      �            |                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IMCDSF01()

	Local aCores := {}

	Private cTitulo := "Cadastro de Principal - SalesForce"
	Private cCadastro := "SalesForce - Principal"
	Private aRotina := MenuDef()

	Private aSize := MsAdvSize( .T., SetMDIChild() )

	MBrowse(,,,,"ZA0" ,,,,,, aCores)

Return

Static Function MenuDef()          

	Local aRotina    := {}

	Aadd(aRotina,{"Pesquisar"	,"AxPesqui"	,0,1 })
	Aadd(aRotina,{"Visualizar"	,"AxVisual"	,0,2 })
	Aadd(aRotina,{"Incluir"		,"AxInclui"	,0,3 })
	Aadd(aRotina,{"Alterar"		,"AxAltera"	,0,4 }) 
	Aadd(aRotina,{"Excluir"		,"AxDeleta"	,0,5 })   

Return aClone(aRotina)   


