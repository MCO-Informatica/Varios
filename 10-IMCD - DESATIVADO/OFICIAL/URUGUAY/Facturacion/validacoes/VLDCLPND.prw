#include 'protheus.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} VLDCLPND
Verifica pendência de pagamento de clientes, este fonte é acionado
pelo preenchimento do campo C5_CLIENTE/C5_LOJA através da validação
de usuário
@author  marcio.katsumata
@since   03/01/2020
@version 1.0
@return  logical, .T.

/*/
//-------------------------------------------------------------------
user function VLDCLPND ()


    local cAliasTit as character
    local cCliente  as character
    local cLoja     as character
    local nDiasSub  as numeric
    local cTextMsg  as character
    local nOpc      as numeric

    //---------------------------
    //Inicialização de variáveis
    //---------------------------
    cCliente := M->C5_CLIENTE
    cLoja    := M->C5_LOJACLI
    cTextMsg := ""
    nOpc     := 0
    cAliasTit := getNextAlias()

    beginSql alias cAliasTit

        SELECT SE1.E1_PREFIXO,SE1.E1_NUM, SE1.E1_VALOR, SE1.E1_VENCREA
        FROM %table:SE1% SE1
        WHERE SE1.E1_CLIENTE = %exp:cCliente%     AND
              SE1.E1_SALDO   > 0                  AND
              SE1.E1_VENCREA < %exp:dtos(date())% AND  
              SE1.E1_TIPO = 'NF'                  AND
              SE1.%notDel%
        ORDER BY SE1.E1_VENCREA

    endSql

    if (cAliasTit)->(!eof())
        nOpc := aviso("ALERTA","Este cliente tiene valores vencidos por pagar.";
                 +CRLF+'Pulse en el botón "Verificar titulos" para verificar los títulos', {"Verificar titulos", "Anular"}, 2)
    endif

    if nOpc == 1 
        WHILE (cAliasTit)->(!eof())

            cTextMsg += "Numero: "+PADR((cAliasTit)->E1_NUM, tamSx3("E1_NUM")[1])+;
                        ". Valor: "+alltrim(transform((cAliasTit)->E1_VALOR,GetSx3Cache("E1_VALOR", "X3_PICTURE")))+;
                        ". Vencimento: "+dtoc(stod((cAliasTit)->E1_VENCREA)) +CRLF
    
            (cAliasTit)->(dbSkip())
        enddo
        
    endif

    eecView(cTextMsg, "Valores vencidos por pagar")

    (cAliasTit)->(dbCloseArea())

return .T.