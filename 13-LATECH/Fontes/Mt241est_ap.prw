#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mt241est()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_CDIR,_CFILE,_CINDICE,_CREGSD3,_CINDSD3")
SetPrvt("_CREGSB1,_CINDSB1,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT241EST � Autor � Sergio Oliveira       � Data �05/08/2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Exclui Etiqueta Codigo de Barras no Estorno da Mov Interna ���
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

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SD3")
_cRegSD3 := Recno()
_cIndSD3 := IndexOrd()

DbSelectArea("SB1")
_cRegSB1 := Recno()
_cIndSB1 := IndexOrd()

DbSeek(xFilial("SB1")+SD3->D3_COD,.F.)

If SB1->B1_RASTRO != "L"  

    DbSetOrder(_cIndSB1)
    DbGoTo(_cRegSB1)

    DbSelectarea("SD3")
    DbSetOrder(_cIndSD3)
    DbGoTo(_cRegSD3)

    RestArea(_aArea)

    Return

EndIf

DbSelectArea("SZ3")
dbSetOrder(1)
If DbSeek("00"+SD3->D3_LOTECTL,.T.)
    While !Eof() .and. SZ3->Z3_LOTE == "00"+SD3->D3_LOTECTL 
        If SZ3->Z3_DOC == SD3->D3_DOC
            RecLock("SZ3",.F.)
              DbDelete()
            MsUnLock()  

            DbSelectArea("SZ3")
            DbSkip()
        Else 
            DbSelectArea("SZ3")
            DbSkip()
        EndIf
    End
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Restaurando a Integridade dos Arquivos                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")
DbGoTo(_cRegSB1)
DbSetOrder(_cIndSB1)

DbSelectarea("SD3")
DbSetOrder(_cIndSD3)
DbGoTo(_cRegSD3)

RestArea(_aArea)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
