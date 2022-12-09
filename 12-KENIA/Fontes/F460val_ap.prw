#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function F460val()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AAREA,_NRECSE1,_CVEND,_NCOMIS,_CPEDIDO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � F460VAL  � Autor �Ricardo Correa de Souza� Data �29/03/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Trata os Titulos Cheques Gerados por Liquidacao            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Texteis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ���
�������������������������������������������������������������������������Ĵ��
���   Analista   �  Data  �             Motivo da Alteracao               ���
�������������������������������������������������������������������������Ĵ��
���Jefferson     �21/04/03�Atualiza dados do cheque para gerar comissao   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aArea  :=  GetArea()

DbSelectArea("SE1")
_nRecSe1    := Recno()

DbSetOrder(1)
If DbSeek(xFilial("SE1")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO),.F.)
    _cVend  :=  SE1->E1_VEND1
    _nComis :=  SE1->E1_COMIS1
    _cPedido:=  SE1->E1_PEDIDO
Else
    _cVend  :=  "" 
    _nComis :=  0
    _cPedido:=  ""
EndIf

DbGoTo(_nRecSe1)
RecLock("SE1",.f.)
  SE1->E1_VEND1     :=  _cVend
  SE1->E1_COMIS1    :=  _nComis
  SE1->E1_BASCOM1   :=  SE1->E1_VALOR
  SE1->E1_PEDIDO    :=  _cPedido
MsUnLock()

RestArea(_aArea)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
