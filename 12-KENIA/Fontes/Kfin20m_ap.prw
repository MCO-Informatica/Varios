#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfin20m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFIN20M  � Autor �Ricardo Correa de Souza� Data �12/07/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Valida Campo Centro de Custo na Inclusao do Contas a Pagar ���
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

If M->E2_PREFIXO == "1  "
    MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,15))+", informe o Centro de Custo Gerencial para este titulo. Utilize a tecla <F3> para pesquisa.","Validacao Centro de Custo","Alert")
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(M->E2_PREFIXO)
Return(M->E2_PREFIXO)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

