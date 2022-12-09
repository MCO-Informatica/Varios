#Include 'Protheus.ch'

/*/{Protheus.doc} User Function cscnt002a
description)
    @type  Functionuser
    @since 10/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
user function CSCNT003()

if SELECT("TMPSX5") > 0
    TMPSX5->(dbCloseArea())
endif

BeginSql Alias "TMPSX5"
    SELECT X5_FILIAL, X5_TABELA, LPAD(MAX(X5_CHAVE) + 1,6,0) CHAVE
    FROM %Table:SX5% SX5
    WHERE SX5.X5_TABELA = 'Z5'
      AND SX5.X5_FILIAL = %xFilial:SX5%
      AND SX5.%NOTDEL%
    GROUP BY X5_FILIAL, X5_TABELA
EndSql

DbSelectArea("TMPSX5")

Return TMPSX5->CHAVE
