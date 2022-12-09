#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Verb1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_CINDSB1,_CREGSB1,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Cliente   � Kenia Industrias Texteis Ltda.                             ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Programa:#� VERB1.prw                                                  ���
�������������������������������������������������������������������������Ĵ��
���Descricao:� Execblock que verifica se produto tem rastro.              ���
�������������������������������������������������������������������������Ĵ��
���Data:     � 31/08/00    � Implantacao: � 31/08/00                      ���
�������������������������������������������������������������������������Ĵ��
���Programad:� Sergio Oliveira                                            ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Objetivos:� Este execblock verifica se o produto que esta sendo devol- ���
���          � vido possui rastreabilidade(se for PA). Em caso afirmativo ���
���          � o usuario devera ser notificado quanto a necessidade de    ���
���          � incluir um lote manualmente com esta quantidade devolvida. ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ŀ��
���Arquivos :� SD1 e SB1.                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

_aArea := RestArea()

If SM0->M0_CODIGO != "80"
   RestArea(_aArea)
   Return()
EndIf

DbSelectArea("SB1")
_cIndSB1 := IndexOrd()
_cRegSB1 := Recno()

DbSetOrder(1)
If DbSeek(xFilial()+SD1->D1_COD,.F.)
   If SB1->B1_TIPO == "PA"
      If SB1->B1_RASTRO != "L"
         MsgBox("Nao se esqueca de incluir um lote manualmente"+Chr(13)+"na rotina de manutencao de lotes","Info","Atencao")
         RecLock("SB1",.F.)
         SB1->B1_RASTRO  := "L"
         SB1->B1_FORMLOT := "003"
         MsUnLock()
      EndIf
   EndIf
Else
   MsgBox("Produto nao cadastrado","Alert","Atencao")
EndIf
   
DbSelectArea("SB1")
DbSetOrder(_cIndSB1)
DbGoTo(_cRegSB1)

RestArea(_aArea)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

