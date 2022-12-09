#INCLUDE 'PROTHEUS.CH'                 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RECTBA01  �Autor  �Microsiga           � Data �  22/05/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �          ���
���          �              ���
�������������������������������������������������������������������������͹��
���Uso       � Renova                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RECTBA01()

Local cAlias := "SZ3"

Private cCadastro := "Empresas X Entidade Contabil Projeto"
Private aRotina := {}
       
AADD(aRotina,{"Pesquisar"  ,"PesqBrw"  ,0,1})
AADD(aRotina,{"Visualizar" ,"AxVisual" ,0,2})
AADD(aRotina,{"Incluir"    ,"AxInclui" ,0,3})
AADD(aRotina,{"Alterar"    ,"AxAltera" ,0,4})
AADD(aRotina,{"Excluir"    ,"AxDeleta" ,0,5})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias,,,,,,)

Return Nil