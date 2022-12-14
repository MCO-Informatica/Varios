#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Sd3240i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_NSALDO,_CDIR,_CFILE,_CINDICE,_AAREA,_CREGSB8")
SetPrvt("_CINDSB8,_CREGSD3,_CINDSD3,_CREGSB1,_CINDSB1,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? SD3240I  ? Autor ? Sergio Oliveira       ? Data ?02/08/2000낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Gera Etiqueta de Codigo de Barras na Movimentacao Interna  낢?
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

_nSaldo   := 0
_aArea    := GetArea()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


DbSelectArea("SB8")
_cRegSB8 := Recno()
_cIndSB8 := IndexOrd()

DbSelectArea("SD3")
_cRegSD3 := Recno()
_cIndSD3 := IndexOrd()

DbSelectArea("SB1")
_cRegSB1 := Recno()
_cIndSB1 := IndexOrd()

DbSeek(xFilial("SB1")+SD3->D3_COD,.F.)
If SB1->B1_RASTRO != "L"
      MsgBox("O produto nao possui rastro. Nao sera gerado etiqueta")

      DbSelectArea("SB1")
      DbGoTo(_cRegSB1)
      DbSetOrder(_cIndSB1)

      DbSelectarea("SD3")
      DbSetOrder(_cIndSD3)
      DbGoTo(_cRegSD3)

      RestArea(_aArea)

      Return
EndIf


DbSelectArea("SB8")
DbSetOrder(3)
DbSeek(xFilial()+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL,.T.)

While !Eof() .and. SB8->B8_FILIAL  == xFilial()   .and.;
                   SB8->B8_PRODUTO == SD3->D3_COD .and.;
                   SB8->B8_LOTECTL == SD3->D3_LOTECTL

    _nSaldo := _nSaldo + SB8->B8_SALDO

    DbSkip()
End
   
If _nSaldo > 0
    RecLock("SZ3",.T.)
      SZ3->Z3_LOTE    := "00"+SD3->D3_LOTECTL
      SZ3->Z3_QUANTID := _nSaldo        
      SZ3->Z3_UM      := SD3->D3_UM
      SZ3->Z3_LARGURA := SB1->B1_X_LARG 
      SZ3->Z3_DESCRI  := SB1->B1_DESC
      SZ3->Z3_COMP    := SB1->B1_X_COMP 
      SZ3->Z3_ORDEM   := Subs(SD3->D3_COD,1,3)
      SZ3->Z3_ARTIGO  := Subs(SD3->D3_COD,1,3)+Subs(SD3->D3_COD,7)
      SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
      SZ3->Z3_COR     := Subs(SD3->D3_COD,4,3)
      SZ3->Z3_PARTIDA := ""
      SZ3->Z3_SAIDA   := "E" // Quantidade de Entrada
      SZ3->Z3_COPIAS  := 1                                 
      SZ3->Z3_DOC     := SD3->D3_DOC
//      SZ3->Z3_NOME	:= Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_NOMCL")

    MsUnLock()
EndIf

DbSelectArea("SB8")
DbGoTo(_cRegSB8)
DbSetOrder(_cIndSB8)

DbSelectArea("SB1")
DbGoTo(_cRegSB1)
DbSetOrder(_cIndSB1)

DbSelectarea("SD3")
DbSetOrder(_cIndSD3)
DbGoTo(_cRegSD3)

RestArea(_aArea)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
