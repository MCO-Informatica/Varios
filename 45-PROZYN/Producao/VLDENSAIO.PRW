#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

User Function VldEnsaio()
    cEnsaio     := aEnsaios[NFLDLAB][NFLDENS][6]
    cMedicao    := ACOLS[1][7]
    If cEnsaio == '00000003' //Atividade Enzimática
        cUnMed		:= POSICIONE('QE7',3,XFILIAL('QE7')+cEnsaio+M->QEK_PRODUT,'QE7_UNIMED')
        cDescUnMed	:= Alltrim(POSICIONE('SAH',1,XFILIAL('SAH')+cUnMed,'AH_UMRES'))
        If MsgYesNo("Houve atividade enzimática e o resultado foi: " + Chr(13) + Chr(10) + Chr(13) + Chr(10) + ;
                cMedicao + " " + cDescUnMed + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
                "Deseja prosseguir com esse valor?", "Confirmação de Atividade Enzimática")
            Return(cMedicao)
        else
            ACOLS[1][7] := ""
            ACOLS[1][8] := ""
            ACOLS[1][9] := ""
            Return("")
        EndIf
    EndIf

Return(cMedicao)
