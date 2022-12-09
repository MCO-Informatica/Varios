#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kpcp02m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CNUMOP,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KPCP02M  � Autor �Ricardo Correa de Souza� Data �19/07/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Trava Apontamento de Producao para Produtos Novos          ���
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

_cNumOp :=  M->D3_OP

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+M->D3_COD)

//----> verifica se o produto e novo
If SB1->B1_STATUS == "N" .And. SB1->B1_TIPO $ "KT/TT"
    MsgBox("Atencao Sr(a). "+Alltrim(Subs(cUsuario,7,14))+" o produto "+Alltrim(SB1->B1_COD)+" � novo. Favor avisar os respons�veis para que os mesmos revisem o tecido","Validacao Apontamento Producao","Stop")
    _cNumOP := ""
EnDif

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_cNumOP)
Return(_cNumOP)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
