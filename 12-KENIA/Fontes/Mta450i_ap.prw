#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mta450i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CALIAS,_CINDICE,_NRECNO,_CINDSC6,_NRECSC6,_CINDSB8")
SetPrvt("_NRECSB8,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? MTA450I  ? Autor ?                       ? Data ?13/06/2002낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Ajusta Empenho do Lote na Liberacao de Credito             낢?
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
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cAlias  := Alias()
_cIndice := IndexOrd()
_nRecno  := Recno()

DbSelectArea("SC6")
_cIndSC6 := IndexOrd()
_nRecSC6 := Recno()

DbSetOrder(1)
DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,.F.)

DbSelectArea("SB8")
_cIndSB8 := IndexOrd()
_nRecSB8 := Recno()

DbSetOrder(3)
If DbSeek(xFilial("SB8")+SC6->C6_PRODUTO+SC6->C6_LOCAL+SC6->C6_LOTECTL,.F.)
    RecLock("SB8",.f.)
      SB8->B8_EMPENHO   :=  Iif(SB8->B8_SALDO == SB8->B8_EMPENHO, SB8->B8_EMPENHO, (SB8->B8_EMPENHO - SC9->C9_QTDLIB))
    MsUnLock()
Else
    MsgBox("Problemas no ajuste do empenho. Anote os dados que serao apresentados na proxima mensagem e avise o administrador do sistema.","Atencao","Stop")
    MsgBox("Probuto "+SC6->C6_PRODUTO+" Pedido "+SC6->C6_NUM+" Item "+SC6->C6_ITEM+" Lote "+SC6->C6_LOTECTL,"Atencao","Alert")
EndIf

DbSelectArea("SB8")
DbSetOrder(_cIndSB8)
DbGoTo(_nRecSB8)

DbSelectArea("SC6")
DbSetOrder(_cIndSC6)
DbGoTo(_nRecSC6)

DbSelectArea(_cAlias)
DbSetOrder(_cIndice)
DbGoTo(_nRecno)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
