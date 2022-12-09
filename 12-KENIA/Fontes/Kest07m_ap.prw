#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kest07m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CDIR,_CFILE,CPERG,AREGS,I,J")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KEST07M  ³ Autor ³Ricardo Correa de Souza³ Data ³01/11/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Arquivo de Etiquetas por Lote                         ³±±
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
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB8")         //----> Saldos por Lote
DbSetOrder(1)               //----> Produto

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg := "EST07M    "

ValidPerg()

If !Pergunte(cPerg,.t.)
    Return
EndIf

Processa({||RunProc()},"Gera Etiqueta")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Gera Etiqueta")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SB8")
DbGoTop()

ProcRegua(RecCount())
While !Eof() 

    IncProc("Selecionando Produto "+SB8->B8_PRODUTO+" Lote "+SB8->B8_LOTECTL)

    //----> filtrando somente a faixa de produtos determinado nos parametros
    If SB8->B8_PRODUTO < mv_par01 .Or. SB8->B8_PRODUTO > mv_par02
        DbSkip()
        Loop
    EndIf


    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1")+SB8->B8_PRODUTO,.F.)

    DbSelectArea("SZ3")
    RecLock("Z3",.t.)
          SZ3->Z3_DOC     := ""
          SZ3->Z3_LOTE    := "00"+SB8->B8_LOTECTL
          SZ3->Z3_QUANTID := SB8->B8_SALDO      
          SZ3->Z3_COMP    := SB1->B1_X_COMP
          SZ3->Z3_ORDEM   := Subs(SB8->B8_PRODUTO,1,3)+Subs(SB8->B8_PRODUTO,7)
          SZ3->Z3_ARTIGO  := Subs(SB8->B8_PRODUTO,1,3)+Subs(SB8->B8_PRODUTO,7)
          SZ3->Z3_SAIDA   := "S" 
          SZ3->Z3_IMP     := "N" 
          SZ3->Z3_PARTIDA := ""
          SZ3->Z3_COR     := Subs(SB8->B8_PRODUTO,4,3)
          SZ3->Z3_COPIAS  := 1
    MsUnLock()

    DbSelectArea("SB8")
    DbSkip()
EndDo

Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Do Produto     ? ','mv_ch1','C',15, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'02','Ate o Produto  ? ','mv_ch2','C',15, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SB1'})

    For i:=1 to Len(aRegs)
        Dbseek(cPerg+StrZero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
            For j:=1 to Fcount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

