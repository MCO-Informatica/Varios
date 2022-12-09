#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function MGETMOED()

    If date() == dDataBase .and. Alltrim(cUserName)$"santana.roberto/Santana Roberto/eliana.vieira/Eliana Vieira de Souza/Administrador"
        If MsgBox(Alltrim(cUserName)+", é necessário atualizar o Risco de Crédito dos Clientes. Para isso você deve confirmar o processamento. Deseja processar agora ???","Atualização do Risco de Crédito","YesNo")
            ExecBlock("RFINA01",.F.,.F.)
        EndIf
    EndIf

Return
