#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function libken()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("AROTINA,CCADASTRO,")

/*/
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LibKen   � Autor � Sergio Oliveira    � Data �  27/09/00   ���
�������������������������������������������������������������������������͹��
���Descri��o � Programa para MBrowse de escolha de item para liberacao    ���
�������������������������������������������������������������������������͹��
���Uso       � Sigafat - Kenia.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

aRotina   := {{"Pesquisar","AxPesqui",0,1},{"Visualizar","AxVisual",0,2},;
             {"Liberar",'ExecBlock("TelaLib1")',0,3}}

cCadastro := "Liberacao Kenia"

mbrowse(75,06,466,574,"SC6",,"C6_QTDENT")

Return()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

