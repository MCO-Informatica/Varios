#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfat17m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_NQTDSALDO,_NCODVEND,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFAT17M  � Autor �                       � Data �23/11/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Troca o Codigo do Vendedor Nos Pedidos de Venda em Aberto  ���
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
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SC5")         //----> Cabecalho de Pedidos de Vendas
DbSetOrder(1)               //----> Pedido

DbSelectArea("SC6")         //----> Itens de Pedidos de Vendas
DbSetOrder(1)               //----> Pedido + Itens

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Muda Vendedor nos Pedidos de Venda em Aberto")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Muda Vendedor nos Pedidos de Venda em Aberto")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC6")
DbSetOrder(1)
DbGoTop()
ProcRegua(RecCount())

Do While !Eof()
                                          
    IncProc("Selecionando Dados do Pedido: "+SC6->C6_NUM)

    _nQtdSaldo := SC6->C6_QTDENT - SC6->C6_QTDVEN

    //----> filtrando somente pedidos que possuem saldo em aberto
    If _nQtdSaldo == 0 .Or. Alltrim(SC6->C6_BLQ) == "R"
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC5")
    DbSetOrder(1)
    If dbSeek(xFilial("SC5")+SC6->C6_NUM,.F.)

        _nCodVend   :=  Val(SC5->C5_VEND1)

        DbSelectArea("SC6")
        While SC6->C6_NUM   ==  SC5->C5_NUM
            RecLock("SC6",.F.)
              SC6->C6_VEND1 :=  StrZero(_nCodVend,6)
            MsUnLock()
            DbSkip()
        EndDo

        DbSelectArea("SC5")
        RecLock("SC5",.F.)
          SC5->C5_VEND1 :=  StrZero(_nCodVend,6)
        MsUnLock()
    EndIf
    DbSelectArea("SC6")
EndDo

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
