#INCLUDE "rwmake.ch"       

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa   BLOCKNCC  � Autor � Ricardo Badawi     � Data �  05/03/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Este programa tem a fun��o de permitir somente que os      ���
���          � usuarios do parametro incluam NCC                          ���
�������������������������������������������������������������������������͹��
���Uso       � DAYHOME                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BLOCKNCC

Local cUsers   := SuperGetMV("MV_BLONCC", Nil, "ADMINISTRADOR")
Local lRetorna := .T.

IF cUserName $ cUsers .OR. M->E1_TIPO <> 'NCC'
		lRetorna := .T.
	Else
		Aviso("Aviso","Usu�rio sem permissao para inclusao de NCC, favor entrar em contato com departamento financeiro ou consulte o parametro MV_BLONCC",{"Abandona"})
	    lRetorna := .F.
    EndIf
  
Return lRetorna
