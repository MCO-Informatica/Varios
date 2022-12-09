#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Custo()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CDIR,_CFILE,_CINDEX,_CCHAVE,")

Processa({||RunProc()},"Processando Custos")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Processando Custos")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

_cDir     := "S:\SIGAADV\"
_cFile    := "CUSTO.DBF"
_cIndex   := CriaTrab(Nil,.f.)
_cChave   := "CUS->PROD"

DbUseArea(.T.,"DBFNTX",_cDir+_cFile,"CUS",.T.,.F.)

IndRegua("CUS",_cIndex,_cChave,,,"Indexando Custos")

DbSelectArea("SB1")
DbSetOrder(1)
DbGoTop()

ProcRegua(LastRec())

While Eof() == .f.

    IncProc("Selecionando Artigo "+SB1->B1_COD)

    If SB1->B1_TIPO #"PA"
        DbSkip()
        Loop
    EndIf

    DbSelectArea("CUS")
    If DbSeek(Subs(SB1->B1_COD,1,3)+Subs(SB1->B1_COD,7,1))
        DbSelectArea("SB1")
        RecLock("SB1",.f.)
          SB1->B1_CUSTD :=  CUS->CUSTO
        MsUnLock()
    Else
        DbSelectArea("SB1")
        RecLock("SB1",.f.)
          SB1->B1_CUSTD :=  0
        MsUnLock()

    EndIf

    DbSelectArea("SB1")
    DbSkip()
EndDo

Return

