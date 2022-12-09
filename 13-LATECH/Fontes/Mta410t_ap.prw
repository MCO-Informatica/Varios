#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mta410t()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_CPROGRAM,_LPAPEL,_CP,_CINDSC9,_CREGSC9")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTA410T  � Autor � Luciano Lorenzetti    � Data �25/10/2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Atualiza Papeleta na Liberacao do Pedido de Venda          ���
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
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aArea    := GetArea()
_cPROGRAM := FUNNAME()
_lPAPEL   := M->C5_PAPELET
_cP       := M->C5_NUM

DbSelectarea("SC9")
_cIndSC9 := IndexOrd()
_cRegSC9 := Recno()      

DbSelectArea("SC9")
DbSetOrder(1)
DbSeek( xFilial("SC9") + _cP )

While SC9->C9_FILIAL == xFilial("SC9") .and. ;
      SC9->C9_PEDIDO == _cP .and. !Eof()
    
    RecLock("SC9", .f.)
      SC9->C9_PAPELET := _lPAPEL
    MsUnlock()

    DbSkip()
   
EndDo

DbSelectarea("SC9")
DbSetOrder(_cIndSC9)
DbGoTo(_cRegSC9)      

RestArea(_aArea)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

