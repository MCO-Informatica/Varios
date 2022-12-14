#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function KFIN23M()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("CPERG,CLOTEFIN,NTOTABAT,CCONTA,NHDLBCO,NHDLCONF")
SetPrvt("NSEQ,CMOTBX,NTOTAGER,NVALESTRANG,VALOR,NHDLPRV")
SetPrvt("NOTRGA,CMARCA,AROTINA,CCADASTRO,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? KFIN23M  ? Autor ?                       ? Data ?27/07/2002낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Retorno da Comunicacao Bancaria                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Kenia Industrias Texteis Ltda                              낢?
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           낢?
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?   Analista   ?  Data  ?             Motivo da Alteracao               낢?
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?              ?        ?                                               낢?
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
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

