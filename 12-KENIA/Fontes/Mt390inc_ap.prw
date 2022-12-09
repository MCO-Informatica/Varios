#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mt390inc()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_CDIR,_CFILE,_CINDICE,_CREGSD5,_CINDSD5")
SetPrvt("_CREGSB1,_CINDSB1,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT390INC � Autor � Sergio Oliveira       � Data �23/08/2000���
�������������������������������������������������������������������������Ĵ��
���Descricao � Gera Etiqueta Codigo Barras na Inclusao via Manut Lotes    ���
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

If SD5->D5_QUANT == 0
    RestArea(_aArea)
    Return   
EndIf

DbSelectArea("SD5")
_cRegSD5 := Recno()
_cIndSD5 := IndexOrd()

DbSelectArea("SB1")
_cRegSB1 := Recno()
_cIndSB1 := IndexOrd()

DbSetOrder(1)
DbSeek(xFilial("SB1")+SD5->D5_PRODUTO,.F.)


DbSelectArea("SZ3")
RecLock("SZ3",.T.)
  SZ3->Z3_LOTE    := "00"+SD5->D5_LOTECTL      
  SZ3->Z3_QUANTID := SD5->D5_QUANT
  SZ3->Z3_UM      := SB1->B1_UM
  SZ3->Z3_LARGURA := SB1->B1_X_LARG 
  SZ3->Z3_DESCRI  := SB1->B1_DESC
  SZ3->Z3_COMP    := SB1->B1_X_COMP
  SZ3->Z3_ORDEM   := Subs(SD5->D5_PRODUTO,1,3)
  SZ3->Z3_ARTIGO  := Subs(SD5->D5_PRODUTO,1,3)+Subs(SD5->D5_PRODUTO,7)
  SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
  SZ3->Z3_COR     := Subs(SD5->D5_PRODUTO,4,3)
  SZ3->Z3_PARTIDA := ""
  SZ3->Z3_SAIDA   := "E" // Quantidade de Entrada
  SZ3->Z3_COPIAS  := 1                                 
  SZ3->Z3_DOC     := SD5->D5_DOC
//  SZ3->Z3_NOME	:= Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_NOMCL")

MsUnLock()

DbSelectArea("SB1")
DbSetOrder(_cIndSB1)
DbGoTo(_cRegSB1)

DbSelectarea("SD5")
DbSetOrder(_cIndSD5)
DbGoTo(_cRegSD5)

RestArea(_aArea)

Return   

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
