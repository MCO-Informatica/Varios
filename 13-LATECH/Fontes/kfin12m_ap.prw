#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#include "topconn.ch"

User Function kfin12m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

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
���Programa  � KFIN12M  � Autor �Ricardo Correa de Souza� Data �31/01/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Browse dos Titulos a Receber para Geracao Nota de Debito   ���
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
* Criacao do MarkBrowse do Arquivo SE1 (Titulos a Receber)                  *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cCampo  := "E1_OKD"
_cCpo    := "SE1->E1_NOTADEB"
_cFiltro := "E1_BAIXA > E1_VENCREA"

DbSelectArea("SE1")
DbSetOrder(2)

aRotina   := { { "Pesquisa"  ,"AxPesqui" ,0,1},;
               { "Nota de Debito",'Execblock("KFIN17M",.F.,.F.)',0,4},;
               { "Monta Arquivo ",'Execblock("KFIN19M",.F.,.F.)',0,5}  }           

cCadastro := "Impressao das Notas de Debito"

cmarca    := getmark()

set filter to &_cFiltro

MarkBrow("SE1",_cCampo,_cCpo,,,cMarca)

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

