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
User Function IMCDSZ2()

	Local aCores := {}

	Private cTitulo := "Cadastro de Embalagens"
	Private cCadastro := "Embalagens"
	Private aRotina := MenuDef()

	Private aSize := MsAdvSize( .T., SetMDIChild() )

	MBrowse(,,,,"SZ2" ,,,,,, aCores)

Return

Static Function MenuDef()          

	Local aRotina    := {}

	Aadd(aRotina,{"Pesquisar"	,"AxPesqui"	,0,1 })
	Aadd(aRotina,{"Visualizar"	,"AxVisual"	,0,2 })
	Aadd(aRotina,{"Incluir"		,"AxInclui"	,0,3 })
	Aadd(aRotina,{"Alterar"		,"AxAltera"	,0,4 }) 
//	Aadd(aRotina,{"Excluir"		,"AxDeleta"	,0,5 })   

Return aClone(aRotina)   


