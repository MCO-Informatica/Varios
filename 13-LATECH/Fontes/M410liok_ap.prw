#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function M410liok()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NPOS,CCODIG,NPRCV,NDELET,DEL,LRETORNA")
SetPrvt("CTIPO,NPRCMIN,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � M410LIOK � Autor �                       � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Valida Preco Minimo e Produto Conforme Politica Vendas     ���
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

//----> busca o codigo do produto
nPOS   := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })
cCODIG := ACOLS[N,NPOS]                           

//----> busca o preco digitado
nPOS   := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_PRCVEN" })
nPRCV  := ACOLS[N,NPOS]                           

//----> verifica linha deletada
nDelet   := Len( aHeader )+1
Del      := aCols[n,nDelet]
lRetorna := .T.

//----> verifica politica de venda utilizada no pedido de venda 
cTIPO := M->C5_PAPELET

//----> verifica preco minimo do produto
nPRCMIN := SB1->B1_PRCMIN

If !Del
    If nPRCMIN > nPRCV .and. cTIPO <> "O"
        MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,15))+" , o preco de venda nao pode ser menor que o preco minimo","Validacao do Preco de Venda","Stop")
        lRetorna := .f.
    Else
        lRetorna := .t.
    EndIf
EndIf

Return(lRetorna)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
