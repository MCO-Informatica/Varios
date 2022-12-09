#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function estrut()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CDIR,_CFILE,_CINDICE,AESTRUT,_CTEMP1,_CINDFIO")
SetPrvt("_CCHAFIO,_CINDFAT,_CCHAFAT,CARQENT,CARQSAI,")

processa({||RunProc()},"Fios")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> processa({||Execute(RunProc)},"Fios")
return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> function runproc
Static function runproc()

_cDir     := "S:\SIGAADV\"
_cFile    := "FATUR.DBF"
_cIndice  := _cDir+"FATUR"

aEstrut :={}
AADD(aEstrut,{"CODFIO"  ,"C",15,0})
AADD(aEstrut,{"QTDFIO"  ,"N",11,2})
AADD(aEstrut,{"VLRFIO"  ,"N",14,2})

_cTemp1 := CriaTrab( aEstrut, .T. )  
DbUseArea(.T.,,_cTemp1,"FIO",.F.,.F.)

DbSelectArea("FIO")
_cIndFio := CriaTrab(Nil,.f.)
_cChaFio := "CODFIO"
IndRegua("FIO",_cIndFio,_cChaFio,,,"Indexando Arquivo")

DbUseArea(.T.,,_cDir+_cFile,"FAT",.F.,.F.)

DbSelectArea("FAT")
_cIndFat := CriaTrab(Nil,.f.)
_cChaFat := "D2_ART"
IndRegua("FAT",_cIndFat,_cChaFat,,,"Indexando Arquivo")

ProcRegua(LastRec())

Do While !Eof()

    IncProc("Processando Estrutura do Artigo "+FAT->D2_ART)

    DbSelectArea("SG1")         
    DbSetOrder(1)               
    If DbSeek(xFilial("SG1")+FAT->D2_ART+"000",.F.)
        While Alltrim(SG1->G1_COD) == FAT->D2_ART+"000"

            ALERT(SG1->G1_COD+" "+SG1->G1_COMP)

            DbSelectArea("SB1")
            DbSetOrder(1)
            DbSeek(xFilial("SB1")+SG1->G1_COMP,.F.)

            DbSelectArea("FIO")
            If DbSeek(SG1->G1_COMP,.F.)
                RecLock("FIO",.F.)
                  FIO->QTDFIO   :=  FIO->QTDFIO + (FAT->D2_QUANT * SG1->G1_QUANT)
                  FIO->VLRFIO   :=  FIO->QTDFIO * SB1->B1_CUSTD
                MsUnLock()
            Else
                RecLock("FIO",.T.)
                  FIO->CODFIO   :=  SG1->G1_COMP
                  FIO->QTDFIO   :=  FAT->D2_QUANT * SG1->G1_QUANT
                  FIO->VLRFIO   :=  FIO->QTDFIO * SB1->B1_CUSTD
                MsUnLock()
            EndIf

            DbSelectArea("SG1")
            DbSkip()
        EndDo
    EndIf

    DbSelectArea("FAT")
    DbSkip()
EndDo

DbSelectArea("FIO")
DbCloseArea("FIO")

DbSelectArea("FAT")
DbCloseArea("FAT")

cArqEnt  := _cTemp1+".DBF"
cArqSai  := "S:\SIGAADV\"+"FIOS"+".DBF"

Copy File (cArqEnt) to (cArqSai)

Ferase(cArqEnt)


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

