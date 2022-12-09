#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mta410i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NSALDO,_AAREA,_CDIR,_CFILE,_CINDICE,_CREGSC9")
SetPrvt("_CINDSC9,_CREGSC6,_CINDSC6,_CREGSB8,_CINDSB8,_CREGSB1")
SetPrvt("_CINDSB1,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTA410I  ³ Autor ³ Marcos Gomes          ³ Data ³09/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Etiqueta Codigo Barras na Liberacao do Pedido de Venda³±±
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

If Empty(Acols[PARAMIXB,ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB" })]) //EMPTY(SC6->C6_LOTECTL)
    RestArea(_aArea)
    Return   
EndIf

DbSelectArea("SC9")
_cRegSC9 := Recno()
_cIndSC9 := IndexOrd()

DbSelectArea("SC6")
_cRegSC6 := Recno()
_cIndSC6 := IndexOrd()

DbSelectArea("SB8")
_cRegSB8 := Recno()
_cIndSB8 := IndexOrd()

DbSelectArea("SB1")
_cRegSB1 := Recno()
_cIndSB1 := IndexOrd()

DbSetOrder(1)
DbSeek(xFilial("SB1")+SC6->C6_PRODUTO,.F.)
If SB1->B1_RASTRO != "L"

      DbSelectArea("SB8")
      DbSetOrder(_cIndSB8)
      DbGoTo(_cRegSB8)

      DbSelectArea("SC9")
      DbSetOrder(_cIndSC9)
      DbGoTo(_cRegSC9)

      DbSelectArea("SC6")
      DbSetOrder(_cIndSC6)
      DbGoTo(_cRegSC6)

      DbSelectArea("SB1")
      DbSetOrder(_cIndSB1)
      DbGoTo(_cRegSB1)

      RestArea(_aArea)

      Return
EndIf

DbSelectArea("SB8")
DbSetOrder(3)                  
DbSeek(xFilial()+SC6->C6_PRODUTO+SC6->C6_LOCAL+SC6->C6_LOTECTL,.T.)
While !Eof() .and. SB8->B8_FILIAL == xFilial() .and.;
            SB8->B8_PRODUTO == SC6->C6_PRODUTO .and.;
            SB8->B8_LOCAL   == SC6->C6_LOCAL   .and.;                      
            SB8->B8_LOTECTL == SC6->C6_LOTECTL    

    _nSaldo := _nSaldo + SB8->B8_SALDO

    DbSkip()
EndDo


If _nSaldo - Acols[PARAMIXB,ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB" })] > 0 


    DbSelectArea("SZ3")
    RecLock("SZ3",.T.)
      SZ3->Z3_LOTE    := "00"+SC6->C6_LOTECTL      
      SZ3->Z3_QUANTID := Acols[PARAMIXB,ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB" })]
      SZ3->Z3_UM      := SC6->C6_UM
      SZ3->Z3_LARGURA := SB1->B1_X_LARG 
      SZ3->Z3_DESCRI  := SB1->B1_DESC
      SZ3->Z3_COMP    := SB1->B1_X_COMP
      SZ3->Z3_ORDEM   := Subs(SC6->C6_PRODUTO,1,3)
      SZ3->Z3_ARTIGO  := Subs(SC6->C6_PRODUTO,1,3)+Subs(SC6->C6_PRODUTO,7)
      SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
      SZ3->Z3_COR     := Subs(SC6->C6_PRODUTO,4,3)
      SZ3->Z3_PARTIDA := ""
      SZ3->Z3_SAIDA   := "S" // Quantidade de Saida  
      SZ3->Z3_COPIAS  := 1                                 
      SZ3->Z3_DOC     := SC6->C6_NUM   
	  SZ3->Z3_CLIENTE := IIF(SB1->B1_TIPO$"TT",SC6->C6_CLI,"")
	  SZ3->Z3_NOME	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NREDUZ"),"")
	  SZ3->Z3_CNPJ	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_CGC"),"")
    MsUnLock()

    DbSelectArea("SZ3")
    RecLock("SZ3",.T.)
      SZ3->Z3_LOTE    := "00"+SC6->C6_LOTECTL      
      SZ3->Z3_QUANTID := _nSaldo - Acols[PARAMIXB,ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB" })]
      SZ3->Z3_UM      := SC6->C6_UM
      SZ3->Z3_LARGURA := SB1->B1_X_LARG 
      SZ3->Z3_DESCRI  := SB1->B1_DESC
      SZ3->Z3_COMP    := SB1->B1_X_COMP
      SZ3->Z3_ORDEM   := Subs(SC6->C6_PRODUTO,1,3)
      SZ3->Z3_ARTIGO  := Subs(SC6->C6_PRODUTO,1,3)+Subs(SC6->C6_PRODUTO,7)
      SZ3->Z3_IMP     := "N" // Etiqueta nao foi impressa.
      SZ3->Z3_COR     := Subs(SC6->C6_PRODUTO,4,3)
      SZ3->Z3_PARTIDA := ""
      SZ3->Z3_SAIDA   := "S" // Quantidade de Saida  
      SZ3->Z3_COPIAS  := 1                                 
      SZ3->Z3_DOC     := SC6->C6_NUM   
	  SZ3->Z3_CLIENTE := IIF(SB1->B1_TIPO$"TT",SC6->C6_CLI,"")
	  SZ3->Z3_NOME	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NREDUZ"),"")
	  SZ3->Z3_CNPJ	  := IIF(SB1->B1_TIPO$"TT",Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_CGC"),"")

    MsUnLock()

    DbSelectArea("SZB")
    RecLock("SZB",.t.)
      SZB->ZB_FILIAL  :=  xFilial("SZB")   
      SZB->ZB_DATA    :=  dDataBase        
      SZB->ZB_LOTECTL :=  SC6->C6_LOTECTL    
      SZB->ZB_PRODUTO :=  SC6->C6_PRODUTO            
      SZB->ZB_QUANT   :=  _nSaldo
    MsUnLock()

    MsgBox("Sera gerado etiqueta para o produto "+SC6->C6_PRODUTO,"Atencao","Info")
EndIf   

DbSelectArea("SB1")
DbGoTo(_cRegSB1)
DbSetOrder(_cIndSB1)

DbSelectarea("SC9")
DbSetOrder(_cIndSC9)
DbGoTo(_cRegSC9)

DbSelectArea("SC6")
DbSetOrder(_cIndSC6)
DbGoTo(_cRegSC6)

DbSelectarea("SB8")
DbSetOrder(_cIndSB8)
DbGoTo(_cRegSB8)

RestArea(_aArea)

Return   

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

