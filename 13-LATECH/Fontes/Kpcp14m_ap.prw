#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kpcp14m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CCONDPAG,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KPCP14M  � Autor � Jefferson Marques     � Data �17/04/2004���
�������������������������������������������������������������������������Ĵ��
���Descricao � Busca a Cond Pagto na Tabela de Precos de Terceiros        ���
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
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cCondPag   :=  Space(003)

//----> VERIFICA SE ORDEM DE PRODUCAO E DE TERCEIROS
If M->C2_TERCEI == "S"
    dbSelectArea("SZC")
    dbSetOrder(2)
    If dbSeek(xFilial("SZC")+M->C2_PRODUTO+M->C2_TIPO,.F.)
        _cCondPag   :=  SZC->ZC_CONDPAG
    Else
        MsgBox("Atencao, o produto "+Alltrim(M->C2_PRODUTO)+" nao tem preco de mao-de-obra cadastrado. Cadastre o preco da mao-de-obra para que o Pedido de Venda seja gerado automaticamente no Apontamento de Producao.","Tabela de Precos Mao-de-Obra","Alert")
    EndIf
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_cCondPag)
Return(_cCondPag)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
