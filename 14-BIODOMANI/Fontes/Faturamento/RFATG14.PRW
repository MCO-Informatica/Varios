#Include "Protheus.ch"

User Function RFATG14()

// 26/06/2020 - RICARDO SOUZA
//   Travar faturamento da empresa 0109 BIO BEAUTY - Ticket #001389 - Fernanda Sanches 

    Local _cDF := M->C5_DF

    if M->C5_DF$"S" .and. M->C5_X_EMPFA$"0109"
        MsgStop("A empresa BIO BEAUTY está bloqueada para emissão de nota fiscal. Favor verificar com a Diretoria.")
        _cDF := "N"
    endif

Return(_cDF)
