#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mta450i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_CINDICE,_NRECNO,_CINDSC6,_NRECSC6,_CINDSB8")
SetPrvt("_NRECSB8,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MTA450I  � Autor �                       � Data �13/06/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ajusta Empenho do Lote na Liberacao de Credito             ���
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

_cAlias  := Alias()
_cIndice := IndexOrd()
_nRecno  := Recno()

DbSelectArea("SC6")
_cIndSC6 := IndexOrd()
_nRecSC6 := Recno()

DbSetOrder(1)
DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,.F.)

DbSelectArea("SB8")
_cIndSB8 := IndexOrd()
_nRecSB8 := Recno()

DbSetOrder(3)
If DbSeek(xFilial("SB8")+SC6->C6_PRODUTO+SC6->C6_LOCAL+SC6->C6_LOTECTL,.F.)
    RecLock("SB8",.f.)
      SB8->B8_EMPENHO   :=  Iif(SB8->B8_SALDO == SB8->B8_EMPENHO, SB8->B8_EMPENHO, (SB8->B8_EMPENHO - SC9->C9_QTDLIB))
    MsUnLock()
Else
    MsgBox("Problemas no ajuste do empenho. Anote os dados que serao apresentados na proxima mensagem e avise o administrador do sistema.","Atencao","Stop")
    MsgBox("Probuto "+SC6->C6_PRODUTO+" Pedido "+SC6->C6_NUM+" Item "+SC6->C6_ITEM+" Lote "+SC6->C6_LOTECTL,"Atencao","Alert")
EndIf

DbSelectArea("SB8")
DbSetOrder(_cIndSB8)
DbGoTo(_nRecSB8)

DbSelectArea("SC6")
DbSetOrder(_cIndSC6)
DbGoTo(_nRecSC6)

DbSelectArea(_cAlias)
DbSetOrder(_cIndice)
DbGoTo(_nRecno)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
