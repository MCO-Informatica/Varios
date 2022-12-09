#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function A390sef()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_CINDEX,_NRECNO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � A390SEF  � Autor �                       � Data �02/11/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Grava o Numero do Cheque Pre-Datado no Titulo a Pagar      ���
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

_cAlias :=  Alias()
_cIndex :=  IndexOrd()
_nRecno :=  Recno()

//----> GRAVANDO O NUMERO DO CHEQUE PRE NO HISTORICO DO TITULO 
DbSelectArea("SE2")

RecLock("SE2",.f.)
SE2->E2_HIST    :=  "CH "+SEF->EF_BANCO+"-"+Alltrim(SEF->EF_NUM)+" P/"+DTOC(dDataBase)
If MsgBox("Sr(a) "+Alltrim(Subs(cUsuario,7,14))+" deseja alterar o vencimento do titulo para a data do cheque pre-datado ?","Altera Vencimento","YesNo")
    SE2->E2_VENCORI :=  SE2->E2_VENCTO
    SE2->E2_VENCTO  :=  dDataBase
    SE2->E2_VENCREA :=  DataValida(SE2->E2_VENCTO)
EndIf
MsUnLock()

//----> RESTAURANDO INTEGRIDADE DAS TABELAS
DbSelectArea(_cAlias)
DbSetOrder(_cIndex)
DbGoTo(_nRecno)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
