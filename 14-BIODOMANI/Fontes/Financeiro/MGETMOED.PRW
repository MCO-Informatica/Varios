#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function MGETMOED()

    If date() == dDataBase .and. Alltrim(cUserName)$"santana.roberto/Santana Roberto/eliana.vieira/Eliana Vieira de Souza/Administrador"
        If MsgBox(Alltrim(cUserName)+", ? necess?rio atualizar o Risco de Cr?dito dos Clientes. Para isso voc? deve confirmar o processamento. Deseja processar agora ???","Atualiza??o do Risco de Cr?dito","YesNo")
            ExecBlock("RFINA01",.F.,.F.)
        EndIf
    EndIf

Return
