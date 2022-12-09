#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kcom02m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KCOM02M  � Autor �Ricardo Correa de Souza� Data �09/08/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Verifica se o Pedido de Compra foi Informado na Nota Fiscal���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Texteis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���Observacao� Gatilho Disparado no Campo D1_COD                          ���
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

_cPedido:= Space(06)
_cItemPc:= Space(02)
_cProd  := Space(20)
_cTes   := Space(03)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_COD"})
_cProd:=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_PEDIDO"})
_cPedido :=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_ITEMPC"})
_cItemPC :=aCols[n,npos]

NPOS:=ASCAN(aHEADER,{|x|upper(alltrim(x[2]))=="D1_TES"})
_cTes :=aCols[n,npos]

//----> verifica se o tipo da nota e igual a normal
If cTipo == "N"
    DbSelectArea("SX1")
    DbSetOrder(1)
    DbSeek("MTA103    20")
    _cNaoTes := Alltrim(mv_par20)

    DbSelectArea("SF4")
    DbSetOrder(1)
    DbSeek(xFilial("SF4")+_cTes)

    //----> verifica se o tes gera duplicata
    If SF4->F4_DUPLIC == "S" .AND. ! SF4->F4_CODIGO $_cNaoTes

        //----> verifica se nao foi informado o pedido de compra
        If Empty(_cPedido)
            MsgBox("O pedido de compra nao foi informado. Nao sera permitido dar entrada nesta nota fiscal sem que haja pedido de compra.","Pedido de Compra nao Cadastrado","Stop")
            _cProd := Space(06)
        Else
            DbSelectArea("SC7")
            DbSetOrder(1)
            DbSeek(xFilial("SC7")+_cPedido+_cItemPc)
    
            //----> verifica se o pedido de compra nao passou pela aprovacao da diretoria
            If Empty(SC7->C7_KAPROVA)
                MsgBox("O pedido de compra "+_cPedido+" nao passou pela rotina de aprovacao da Diretoria. Nao sera permitido dar entrada nesta nota fiscal sem que haja aprovacao.","Aprovacao da Diretoria","Stop")
                _cProd := Space(06)
    
            //----> verifica se o pedido de compra passou pela aprovacao da diretoria e foi bloqueado
            ElseIf SC7->C7_KAPROVA == "B"
                MsgBox("O pedido de compra "+_cPedido+" nao passou pela aprovacao da Diretoria. Nao sera permitido dar entrada nesta nota fiscal enquanto houver bloqueio.","Bloqueio da Diretoria","Stop")
                _cProd := Space(06)
            EndIf
        EndIf
    EndIf
EndIf

DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
DbGoTo(_nRecno)

Return(_cProd)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

