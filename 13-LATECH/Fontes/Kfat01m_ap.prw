#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfat01m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CCAMPO,_CCPO,AROTINA,CCADASTRO,CMARCA,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFAT01M  � Autor �Ricardo Correa de Souza� Data �15/02/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Browse do Cadastro de Clientes Para Impressao de Etiquetas ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Texteis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ���
�������������������������������������������������������������������������Ĵ��
���   Analista   �  Data  �             Motivo da Alteracao               ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Criacao do MarkBrowse do Arquivo SA1 (Cadastro de Clientes)               *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cCampo  := "A1_OK"
_cCpo    := "SA1->A1_BCO5"

DbSelectArea("SA1")
DbSetOrder(1)

aRotina   := { { "Pesquisa"  ,"AxPesqui" ,0,1},;
               { "Imprime Etiqueta",'Execblock("KFAT02M",.F.,.F.)',0,4}  }           

cCadastro := "Geracao de Etiquetas Mala Direta Clientes"

cmarca    := getmark()

MarkBrow("SA1",_cCampo,_cCpo,,,cMarca)

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

