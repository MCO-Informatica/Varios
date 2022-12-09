#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kcom04m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NPOS,CPROD,NVUNIT,NULTPRC,NMARGEM,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KCOM04M  � Autor �Ricardo Correa de Souza� Data �18/10/2001���
�������������������������������������������������������������������������Ĵ��
���Descricao � Compara Preco do Pedido de Compra com Ultimo Preco Pago    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Texteis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���Observacao� Gatilho Disparado no Campo C7_PRECO                        ���
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

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Guarda as posicoes do item que esta sendo digitado e valores              *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nPos    := Ascan(aHEADER,{|x|Upper(Alltrim(x[2]))=="C7_PRODUTO"})
cProd   := aCols[n,nPos]

nPos    := Ascan(aHEADER,{|x|Upper(Alltrim(x[2]))=="C7_PRECO"})
nVunit  := aCols[n,nPos]

nPos    := Ascan(aHEADER,{|x|Upper(Alltrim(x[2]))=="C7_KULTPRC"})
nUltPrc := aCols[n,nPos]

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

If nVunit > nUltPrc      
    If nUltPrc == 0
        MsgBox("Este produto esta com o ultimo preco zerado. Talvez este item nao tenha sido comprado ate o presente momento","Preco Zerado","Info")
    Else
        nMargem := (( nVunit / nUltPrc ) -1 ) *100
        nUltPrc := Round(nUltPrc     ,4)
        nVunit  := Round(nVunit      ,4)

        If MsgBox("R$ "+Alltrim(Str(nVunit))+" esta acima do ultimo preco pago "+Alltrim(Str(nMargem,10,2))+" %. O ultimo preco pago foi R$ "+Alltrim(Str(nUltPrc)),"Continua ?","YesNo")
        Else
            nVunit := nUltPrc
        EndIf
    EndIf
EndIf

Return(nVunit)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

