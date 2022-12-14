#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Sd1100i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_AAREA,_CDIR,_CFILE,_CINDICE,_NSALDO,_CREGSB1")
SetPrvt("_CINDSB1,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? SD1100I  ? Autor ? Sergio Oliveira       ? Data ?28/08/2000낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Gera Etiqueta Codigo de Barras na Entrada da Nota Fiscal   낢?
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
* Definicao de Variaveis                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aArea    := GetArea()
_nSaldo   := 0


*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")
_cRegSB1 := Recno()
_cIndSB1 := IndexOrd()

DbSetOrder(1)
DbSeek(xFilial("SB1")+SD1->D1_COD,.F.)

//----> filtrando apenas produtos acabados que controlam o lote
If SB1->B1_RASTRO != "L" //.Or. SB1->B1_TIPO != "PA"
    If SD1->D1_TIPO != "D" .And. !Subs(SD1->D1_COD,1,3) $ "140/141"
        DbSetOrder(_cIndSB1)
        DbGoTo(_cRegSB1)

        RestArea(_aArea)
    
        Return
    EndIf
EndIf

DbSelectArea("SZ3")
RecLock("SZ3",.T.)
  SZ3->Z3_LOTE    := "00"+SD1->D1_LOTECTL      
  SZ3->Z3_QUANTID := SD1->D1_QUANT          
  SZ3->Z3_UM      := SD1->D1_UM
  SZ3->Z3_LARGURA := SB1->B1_X_LARG 
  SZ3->Z3_DESCRI  := SB1->B1_DESC
  SZ3->Z3_COMP    := SB1->B1_X_COMP 
  SZ3->Z3_ORDEM   := Subs(SD1->D1_COD,1,3)
  SZ3->Z3_ARTIGO  := Subs(SD1->D1_COD,1,3)+Subs(SD1->D1_COD,7)
  SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
  SZ3->Z3_COR     := Subs(SD1->D1_COD,4,3)
  SZ3->Z3_PARTIDA := ""
  SZ3->Z3_SAIDA   := "E" // Quantidade de Entrada
  SZ3->Z3_COPIAS  := 1                                 
  SZ3->Z3_DOC     := SD1->D1_DOC
  SZ3->Z3_CLIENTE := IIF(SB1->B1_TIPO$"TT",SD1->D1_FORNECE,"")
  SZ3->Z3_NOME	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_NREDUZ"),"")
  SZ3->Z3_CNPJ	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"A1_CGC"),"")

MsUnLock()

If SD1->D1_TIPO == "D"

    DbSelectArea("SZB")
    RecLock("SZB",.t.)
      SZB->ZB_FILIAL  :=  xFilial("SZB")   
      SZB->ZB_DATA    :=  dDataBase        
      SZB->ZB_LOTECTL :=  SD1->D1_LOTECTL      
      SZB->ZB_PRODUTO :=  SD1->D1_COD        
      SZB->ZB_QUANT   :=  SD1->D1_QUANT        
    MsUnLock()

EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retornando a Integridade das Tabelas                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")
DbSetOrder(_cIndSB1)
DbGoTo(_cRegSB1)


RestArea(_aArea)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

