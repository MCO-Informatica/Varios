#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function KFIN23M()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CLOTEFIN,NTOTABAT,CCONTA,NHDLBCO,NHDLCONF")
SetPrvt("NSEQ,CMOTBX,NTOTAGER,NVALESTRANG,VALOR,NHDLPRV")
SetPrvt("NOTRGA,CMARCA,AROTINA,CCADASTRO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFIN23M  � Autor �                       � Data �27/07/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorno da Comunicacao Bancaria                            ���
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

MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,15))+" ,a rotina de Retorno Bancario sofreu algumas modificacoes. Favor verificar se o sistema esta atualizando as baixas corretamente e qualquer falha comunique imediatamente o Administrador do sistema.","A     V     I     S     O","STOP")

cPerg       := "AFI200    "
cLotefin    := "    "
nTotAbat    := 0
cConta      := " "
nHdlBco     := 0
nHdlConf    := 0
nSeq        := 0
cMotBx      := "NOR"
nTotAGer    := 0
nValEstrang := 0
Valor       := 0
nHdlPrv     := 0
nOtrGa      := 0
cMarca      := GetMark()
aRotina     := { {OemToAnsi("Parametros")      ,'ExecBlock("KFIN24M",.t.,.t.)', 0 , 1},;
                 {OemToAnsi("Visualizar")      ,"AxVisual" , 0 , 2},; 
                 {OemToAnsi("Receber Arquivo") ,'ExecBlock("KFIN25M",.t.,.t.)', 0 , 4} } 

cCadastro   := OemToAnsi("Comunicacao Bancaria - Retorno")

mBrowse( 6, 1,22,75,"SE1")

fClose(nHdlBco)
fClose(nHdlConf)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

