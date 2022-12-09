#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kpcp08m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CPRODUTO,_NQTDKILOS,_NQTDSALDO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KPCP08M  � Autor �Ricardo Correa de Souza� Data �29/11/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Transfere Perda de Retalhos para Estoque do Artigo 110     ���
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

_cProduto    := "110099"
_nQtdKilos   := M->D3_QTDKG
_nQtdSaldo   := 0

If MsgBox("Para atualizacao do estoque de retalho em quilos, clique << SIM >>.","Atualizacao Estoque Retalho","YesNo")
    DbSelectArea("SD3")
    RecLock("SD3",.T.)
      SD3->D3_FILIAL  :=  xFilial("SD3")
      SD3->D3_COD     :=  _cProduto
      SD3->D3_TM      :=  "004"
      SD3->D3_UM      :=  "KG"
      SD3->D3_QUANT   :=  _nQtdKilos
      SD3->D3_LOCAL   :=  "01"
      SD3->D3_DOC     :=  "PERDAS"
      SD3->D3_EMISSAO :=  dDataBase
      SD3->D3_CF      :=  "DE0"
      SD3->D3_NUMSEQ  := GETMV("MV_DOCSEQ")  
    MsUnLock()
    
    DbSelectArea("SB2")
    DbSetOrder(1)
    DbSeek(xFilial("SB2")+_cProduto)
    
    _nQtdSaldo := SB2->B2_QATU
    
    RecLock("SB2",.f.)
      SB2->B2_QATU  := _nQtdSaldo + _nQtdKilos
      SB2->B2_VATU1 := Round(SB2->B2_QATU * SB2->B2_CM1,2)
    MsUnLock()

    MsgBox("Estoque de Retalho em Quilos atualizado com sucesso !!","Confirma Atualizacao","Info")
EndIf

Return(_nQtdKilos)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

