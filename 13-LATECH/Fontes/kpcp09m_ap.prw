#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kpcp09m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CPRODUTO,_NQTDMETROS,_NQTDSALDO,_NCONVERSAO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KPCP09M  � Autor �                       � Data �11/02/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Transfere Metros de Tecido Tinto para Quilos 110098        ���
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

_cProduto    := "110098"
_nQtdMetros  := M->D3_QUANT  
_nQtdSaldo   := 0

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+M->D3_COD)

_nConversao := SB1->B1_PESO

If MsgBox("Para atualizacao do estoque em quilos do produto 110098, clique << SIM >>.","Atualizacao Estoque 110098","YesNo")

    _nQtdMetros := M->D3_QUANT * _nConversao

    DbSelectArea("SD3")
    RecLock("SD3",.T.)
      SD3->D3_FILIAL  :=  xFilial("SD3")
      SD3->D3_COD     :=  _cProduto
      SD3->D3_TM      :=  "004"
      SD3->D3_UM      :=  "KG"
      SD3->D3_QUANT   :=  _nQtdMetros
      SD3->D3_LOCAL   :=  "01"
      SD3->D3_DOC     :=  "MTSKGS"
      SD3->D3_EMISSAO :=  dDataBase
      SD3->D3_CF      :=  "DE0"
      SD3->D3_NUMSEQ  := GETMV("MV_DOCSEQ")  
    MsUnLock()
    
    DbSelectArea("SB2")
    DbSetOrder(1)
    DbSeek(xFilial("SB2")+_cProduto)
    
    _nQtdSaldo := SB2->B2_QATU
    
    RecLock("SB2",.f.)
      SB2->B2_QATU  := _nQtdSaldo + _nQtdMetros 
      SB2->B2_VATU1 := Round(SB2->B2_QATU * SB2->B2_CM1,2)
    MsUnLock()

    MsgBox("Estoque 110098 atualizado com sucesso !!","Confirma Atualizacao","Info")
EndIf

Return(_nQtdMetros)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

