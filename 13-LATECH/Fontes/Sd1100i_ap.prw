#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Sd1100i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREA,_CDIR,_CFILE,_CINDICE,_NSALDO,_CREGSB1")
SetPrvt("_CINDSB1,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SD1100I  ³ Autor ³ Sergio Oliveira       ³ Data ³28/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Etiqueta Codigo de Barras na Entrada da Nota Fiscal   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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

