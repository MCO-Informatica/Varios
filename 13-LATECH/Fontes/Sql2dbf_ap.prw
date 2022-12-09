#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Sql2dbf()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("XINI,XFIM,CARQSQL,CARQDBF,CINDSQL,")

xIni := space(03)
xFim := space(03)
@ 0,0 TO 060,320 DIALOG oDlg1 TITLE "Confirma a Exportacao  "
@ 10,20 GET xIni PICTURE "@!"   
@ 20,20 GET xFim PICTURE "@!"   
@ 09,105 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 09,105 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 09,070 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function OkProc
Static Function OkProc()
   Close(oDlg1)
   Processa( {|| RunProc() }, "FAZENDO EXPORTACAO" ,OemToAnsi("Copiando os Registros..."),.F.) // Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>    Processa( {|| Execute(RunProc) }, "FAZENDO EXPORTACAO" ,OemToAnsi("Copiando os Registros..."),.F.) 
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SX5")
dbCloseArea()

dbselectArea("SX2")
dbClearFilter()
dbSetOrder(1)
dbGotop()


ProcRegua(RECCOUNT())
DBSEEK(xIni,.T.)
WHILE !EOF() .AND. X2_CHAVE <= xFim
      IncProc("Processando..."+SUBSTR(X2_ARQUIVO,1,3))

      // Inicia variaveis
      cArqSQL := AllTrim(SX2->X2_ARQUIVO)
      cArqDBF := AllTrim(SX2->X2_PATH) + cArqSQL
      cIndSQL := cArqSQL + "1"

      // Testa existencia do arquivo no SQL
      If TCCANOPEN(cArqSQL)
         Use &(cArqSQL) Alias SQL New Shared Via "TOPCONN"

         // Verifica existencia no SQL. Veja instrucoes abaixo
         If TCCANOPEN(cArqSQL,cIndSQL)
            dbSetIndex(cIndSQL)
         End
         dbSetOrder(1)
         dbGoTop()

         // Copia para DBF
         Copy to &(cArqDBF)

         dbSelectArea("SQL")
         dbCloseArea()
      End

      dbSelectArea("SX2")
      dbSkip()


END



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

