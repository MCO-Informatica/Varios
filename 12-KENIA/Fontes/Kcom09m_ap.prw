#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kcom09m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,APERG,NLACO,ADBF,CARQTRB,CCODIGO")
SetPrvt("CNOME,CARQENT,CARQSAI,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KCOM09M  ³ Autor ³                       ³ Data ³29/07/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Cadastro de Fornecedores para Sistema de Agenda       ³±±
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
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01               Nome do Arquivo Dbf                                *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


cPerg    := "COM09M    "
aPerg    := {}

AADD(aPerg,{cPerg,"01","Nome Arquivo Agenda? " ,"mv_ch1","C",08,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","",})

DbSelectArea("SX1")
For nLaco:=1 to Len(aPerg)
   If !DbSeek(aPerg[nLaco,1]+aPerg[nLaco,2])
	 RecLock("SX1",.T.)
     SX1->X1_GRUPO     := aPerg[nLaco,01]
     SX1->X1_ORDEM     := aPerg[nLaco,02]
     SX1->X1_PERGUNT   := aPerg[nLaco,03]
     SX1->X1_VARIAVL   := aPerg[nLaco,04]
     SX1->X1_TIPO      := aPerg[nLaco,05]
     SX1->X1_TAMANHO   := aPerg[nLaco,06]
     SX1->X1_DECIMAL   := aPerg[nLaco,07]
     SX1->X1_PRESEL    := aPerg[nLaco,08]
     SX1->X1_GSC       := aPerg[nLaco,09]
     SX1->X1_VALID     := aPerg[nLaco,10]
     SX1->X1_VAR01     := aPerg[nLaco,11]
     SX1->X1_DEF01     := aPerg[nLaco,12]
     SX1->X1_CNT01     := aPerg[nLaco,13]
     SX1->X1_VAR02     := aPerg[nLaco,14]
     SX1->X1_DEF02     := aPerg[nLaco,15]
     SX1->X1_CNT02     := aPerg[nLaco,16]
     SX1->X1_VAR03     := aPerg[nLaco,17]
     SX1->X1_DEF03     := aPerg[nLaco,18]
     SX1->X1_CNT03     := aPerg[nLaco,19]
     SX1->X1_VAR04     := aPerg[nLaco,20]
     SX1->X1_DEF04     := aPerg[nLaco,21]
     SX1->X1_CNT04     := aPerg[nLaco,22]
     SX1->X1_VAR05     := aPerg[nLaco,23]
     SX1->X1_DEF05     := aPerg[nLaco,24]
     SX1->X1_CNT05     := aPerg[nLaco,25]
     SX1->X1_F3        := aPerg[nLaco,26]
	 MsUnLock()
   EndIf
Next

If !Pergunte(cPerg,.T.)
    Return
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||GeraDbf()},"Exportacao de Dados para Sistema Agenda")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(GeraDbf)},"Exportacao de Dados para Sistema Agenda")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function GeraDbf
Static Function GeraDbf()

aDbf:={}

AADD(aDbf,{"A2_NOME   ","C",60,0})
AADD(aDbf,{"A2_NREDUZ ","C",20,0})
AADD(aDbf,{"A2_END    ","C",70,0})
AADD(aDbf,{"A2_MUN    ","C",25,0})
AADD(aDbf,{"A2_TEL    ","C",15,0})
AADD(aDbf,{"A2_FAX    ","C",15,0})
AADD(aDbf,{"A2_CONTATO","C",15,0})

cArqTrb :=  CriaTrab(aDbf,.T.)

DbUseArea( .T.,, cArqTrb, "TRB",.F.,.F.)

DbSelectArea("SA2")
DbSetOrder(2)
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.

    IncProc("Exportando Cliente "+SA2->A2_COD+"/"+SA2->A2_LOJA)

        cCodigo := SA2->A2_COD
        cNome   := SA2->A2_NOME    

        If Empty(SA2->A2_NOME)
            DbSkip()
            Loop
        EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->A2_NOME      :=      SA2->A2_NOME
          TRB->A2_NREDUZ    :=      SA2->A2_NREDUZ
          TRB->A2_END       :=      SA2->A2_END 
          TRB->A2_MUN       :=      SA2->A2_MUN
          TRB->A2_TEL       :=      SA2->A2_TEL
          TRB->A2_FAX       :=      SA2->A2_FAX
          TRB->A2_CONTATO   :=      SA2->A2_CONTATO
        MsUnLock()

        DbSelectArea("SA2")
        DbSkip()

        /*
        While cCodigo == SA2->A2_COD
            IncProc("Codigo Igual "+cCodigo)
            DbSkip()
        EndDo
        */

        While cNome == SA2->A2_NOME
            IncProc("Nome Igual "+cNome)
            DbSkip()
        EndDo
EndDo

DbSelectArea("TRB")
DbCloseArea("TRB")

cArqEnt  := cArqTrb+".DBF"
cArqSai  := "S:\AGENDA\"+mv_par01+".DBF"

Copy File (cArqEnt) to (cArqSai)

Ferase(cArqEnt)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

