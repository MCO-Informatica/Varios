
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XFAT004   �Autor  | William Gurzoni    � Data �  08/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de licitacoes, criado para atender a necessidade  ���
���          � especifica da Cozil.							              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*BEGINDOC
//���������������������������������������������������������a�
//�Nesta tela serao cadastradas todas as licitacoes        �
//�que a empresa participara. A este cadastro sera amarrado�
//�posteriormente o sistema de workflow, onde notificara   �
//�os participantes com antecedencia.                      �
//���������������������������������������������������������a�
ENDDOC*/

#INCLUDE "PROTHEUS.CH"

User Function XFAT004()      
            
	Local cAlias	:=	"SZ5"	
	Private cCadastro	:= "Cadastro de Licita��es"
	Private aRotina	:= {}
	
	Aadd(aRotina, {"Pesquisar",	"AxPesqui",	0,	1}) 
	Aadd(aRotina, {"Visualizar",	"AxVisual",	0,	2})
	Aadd(aRotina, {"Incluir",			"AxInclui",		0,	3})	
	Aadd(aRotina, {"Alterar",			"AxAltera",	0,	4})
	Aadd(aRotina, {"Excluir",		"AxDeleta",	0,	5})		
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	mBrowse(6,1,22,75,cAlias)
                                       
Return()