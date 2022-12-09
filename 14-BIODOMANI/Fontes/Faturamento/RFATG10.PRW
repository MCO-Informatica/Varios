#Include "Protheus.ch"

User Function RFATG10()

// 12/03/2020 - LUIZ SUGUIURA
// Aplicação das regras enviadas pela Janaína no Ticket #580 
//   SOMENTE SE ARMAZÉM 01A1 altera as quantidades de vias
//   Motoboy = 000006 ** NF = 2 / Não = 3
//   Cliente Retira = 000090/000099 ** NF = 1 / Nã0 = 3
//   Correio/Sedex/PAC = 000097/000004/000007/000029/001001/000009/001000 ** NF = 1 / NÃO = 2
//   Nosso Tranporte = 000100 ** NF = 2 / Não = 3
//   Restante = 1 (NF ou Não) 

    Local _nVias := 1

    if M->C5_X_ARMAZ $ "01A1"
        if M->C5_DF$"N"
            if M->C5_TRANSP $ "000097/000007/000029/000009"
                _nVias := 2
            elseif M->C5_TRANSP $ "000006/000100/000090/000099"
                _nVias := 3
            endif
        endif
    ElseIf M->C5_X_ARMAZ $ "07A1"
        if M->C5_DF$"N"
            if M->C5_TRANSP $ "000006"
                _nVias := 3
            elseif M->C5_TRANSP $ "000100"
                _nVias := 2
            endif
        else
            if M->C5_TRANSP $ "000006"
                _nVias := 2
            elseif M->C5_TRANSP $ "000100"
                _nVias := 1
            endif
        endif
    Endif

Return(_nVias)
