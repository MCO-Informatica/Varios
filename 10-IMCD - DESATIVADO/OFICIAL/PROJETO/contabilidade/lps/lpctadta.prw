

/*/{Protheus.doc} LpCtAdta
Função para retornar conta contábil para as LPs de
adiatamento fornecedor LP 513-001 e LP 597-001
@type function
@version 1.0
@author marcio.katsumata
@since 19/08/2020
@return character, conta contábil
/*/
user function LpCtAdta()
    local cCtaRet as character

    cCtaRet := ""

    DO CASE 
        CASE alltrim(SE2->E2_FORNECE)$'000137/001547'
            cCtaRet := '114020011'
        CASE alltrim(SE2->E2_FORNECE)$'02441/002441'
            cCtaRet := '114020016'
        CASE alltrim(SE2->E2_FORNECE)$'02482'
            cCtaRet := '114020017'
        CASE alltrim(SE2->E2_FORNECE)$'003622'
            cCtaRet := '114020018'
        CASE alltrim(SE2->E2_FORNECE) $'UNIAO'
            cCtaRet := '114030011'
        OTHERWISE
            cCtaRet := '114020001'
    ENDCASE

return cCtaRet
