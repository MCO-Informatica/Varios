#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kcom01m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NORDER,_NRECNO,_NVUNIT,NPOS,_CPROD")
SetPrvt("_CPEDIDO,_CITEMPC,_CINDC7,_NPRPED,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KCOM03M  � Autor �Ricardo Correa de Souza� Data �09/08/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Compara Preco Unit da Nota X Preco Unit do Pedido de Compra���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Texteis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���Observacao� Gatilho Disparado no Campo D1_VUNIT                        ���
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
* Guardando a Area, Indice e Registro corrente antes das manipulacoes       *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cAlias := Alias()
_nOrder := IndexOrd()
_nRecno := Recno()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Processamento                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_nVunit := 0 //----> armazena a preco unit digitado

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_COD"})
_cProd:=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_PEDIDO"})
_cPedido:=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_ITEMPC"})
_cItemPc:=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_VUNIT"})
_nVunit:=aCols[n,npos]

DbSelectArea("SC7")
_cIndC7 := IndexOrd()

DbSetOrder(4)
If DbSeek(xFilial("SC7")+_cProd + _cPedido + _cItemPc)

    _nPrPed := SC7->C7_PRECO

    //----> se o preco da nota for maior que o preco do pedido nao deixar continuar com a entrada da nota
    If _nVunit > _nPrPed
        MsgBox("O preco unitario da nota esta maior do que o preco unitario do pedido de compra. Este item nao podera ser digitado pois o preco esta divergente do pedido de compra.","Divergencia de Preco","Stop")
        _nVunit := 0
    EndIf

Endif

//---->atualiza valor total
aCols[n,ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_TOTAL"})] := aCols[n,ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_QUANT"})] * _nVunit

DbSetOrder(_cIndC7)

DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
DbGoTo(_nRecno)

Return(_nVunit)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

