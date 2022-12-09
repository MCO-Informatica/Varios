#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function mt241tok()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NSALDO,_AAREA,_CDIR,_CFILE,_CINDICE,_CREGSD3")
SetPrvt("_CINDSD3,_CREGSB8,_CINDSB8,_CREGSB1,_CINDSB1,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT241TOK ³ Autor ³ Sergio Oliveira       ³ Data ³05/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Etiqueta Codigo de Barras na Inclusao Mov Interna     ³±±
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

DbSelectArea("SD3")
_cRegSD3 := Recno()
_cIndSD3 := IndexOrd()

DbSelectArea("SB8")
_cRegSB8 := Recno()
_cIndSB8 := IndexOrd()

DbSelectArea("SB1")
_cRegSB1 := Recno()
_cIndSB1 := IndexOrd()

DbSeek(xFilial("SB1")+SD3->D3_COD,.F.)

If SB1->B1_RASTRO != "L" 

      //MsgBox("Produto sem rastro. Nao sera gerado etiqueta")

      DbSetOrder(_cIndSB1)
      DbGoTo(_cRegSB1)

      DbSelectarea("SD3")
      DbSetOrder(_cIndSD3)
      DbGoTo(_cRegSD3)

      RestArea(_aArea)

      Return
EndIf


DbSelectArea("SB8")
DbSetOrder(3)
DbSeek(xFilial("SB8")+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL,.F.)

While !Eof() .and. SB8->B8_FILIAL  == xFilial()       .and.;
                   SB8->B8_PRODUTO == SD3->D3_COD     .and.;
                   SB8->B8_LOTECTL == SD3->D3_LOTECTL

    _nSaldo := _nSaldo + SB8->B8_SALDO

    DbSkip()
EndDo
   
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
      SZ3->Z3_SAIDA   := "R" // Quantidade de Saldo  
      SZ3->Z3_COPIAS  := 1                                 
      SZ3->Z3_DOC     := cDocumento
      //SZ3->Z3_NOME	  := Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_NOMCL")
 
    MsUnLock()

Else

    RecLock("SZ3",.T.)
      SZ3->Z3_LOTE    := "00"+SD3->D3_LOTECTL      
      SZ3->Z3_QUANTID := SD3->D3_QUANT
      SZ3->Z3_UM      := SD3->D3_UM            
      SZ3->Z3_LARGURA := SB1->B1_X_LARG 
      SZ3->Z3_DESCRI  := SB1->B1_DESC          
      SZ3->Z3_COMP    := SB1->B1_X_COMP 
      SZ3->Z3_ORDEM   := Subs(SD3->D3_COD,1,3)
      SZ3->Z3_ARTIGO  := Subs(SD3->D3_COD,1,3)+Subs(SD3->D3_COD,7)
      SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
      SZ3->Z3_COR     := Subs(SD3->D3_COD,4,3)
      SZ3->Z3_PARTIDA := ""
      SZ3->Z3_SAIDA   := "R" // Quantidade de Saldo  
      SZ3->Z3_COPIAS  := 1                                 
      SZ3->Z3_DOC     := cDocumento
	  //SZ3->Z3_NOME	  := Posicione("SC2",1,xFilial("SC2")+SD3->D3_OP,"C2_X_NOMCL")
    MsUnLock()
EndIf

DbSelectArea("SB1")
DbSetOrder(_cIndSB1)
DbGoTo(_cRegSB1)

DbSelectarea("SD3")
DbSetOrder(_cIndSD3)
DbGoTo(_cRegSD3)

DbSelectArea("SB8")
DbSetOrder(_cIndSB8)
DbGoTo(_cRegSB8)

RestArea(_aArea)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

