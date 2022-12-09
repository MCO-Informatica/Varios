#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfin21j()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN21J  ³ Autor ³Jefferson Marques      ³ Data ³19/09/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna risco "A" para clientes risco "D"                  ³±±
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
* Parametros Utilizados                                                     *
* mv_par01      //----> Dias Vencidos  ?                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg := "FIN21M    "

ValidPerg()     //----> verifica se existe grupo de perguntas no SX1

Pergunte( cPerg, .T. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1")         //----> Cadastro de Clientes
DbSetOrder(1)               //----> Codigo + Loja

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||Clientes()},"Selecionando Dados Titulos Vencidos")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(Clientes)},"Selecionando Dados Titulos Vencidos")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Clientes
Static Function Clientes()

DbSelectArea("SA1")
DbGoTop()
ProcRegua(LastRec())

While Eof() == .f. 

    IncProc("Processando Dados Cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" "+Alltrim(SA1->A1_NREDUZ))

    //----> verifica se clientes ja estao bloqueados
        RecLock("SA1",.f.)
        SA1->A1_RISCO     :=  "A"
        MsUnLock()

    DbSelectArea("SA1")
    DbSkip()
EndDo

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
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

    aadd(aRegs,{cPerg,'01','Nr. Dias Vencidos? ','mv_ch1','N',03, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})

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

Return()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

