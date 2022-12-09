#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kpcp12m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CNUMEROOP,_CCCUSTO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KPCP12M  � Autor �                       � Data �08/02/2003���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gera a Numeracao da Op Automatica (Tecelagem / Tinturaria) ���
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

_cNumeroOp  :=  M->C2_NUM
_cCcusto    :=  M->C2_CC

If MsgBox("Deseja Numerar a Ordem de Producao Automaticamente ?","Numeracao Automatica","YesNo")

    If Alltrim(_cCcusto) $"20000" .And. !Subs(M->C2_PRODUTO,4,3) $ "000"
        _cNumeroOp  :=  GetSx8Num("TIN")
        ConfirmSx8()
    ElseIf Alltrim(_cCcusto) $"30000" .And. Subs(M->C2_PRODUTO,4,3) $ "000"
        _cNumeroOp  :=  GetSx8Num("TEC")
        ConfirmSx8()
    Else
        _cNumeroOp  :=  GetSx8Num("TIN")
        ConfirmSx8()
    EndIf
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_cNumeroOp)
Return(_cNumeroOp)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
