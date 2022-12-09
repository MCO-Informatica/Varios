#Include 'PROTHEUS.CH'

User function F240FIL()

Local _cFiltro := Nil

If cModPgto = '30' // Titulos Itaú

   _cFiltro := "((SUBSTR(E2_CODBAR,1,3) = '341') .Or. (SUBSTR(E2_LINDIG,1,3) = '341'))"

ElseIf cModPgto = '31' // Titulos Outros Bancos

   _cFiltro := "(((SUBSTR(E2_CODBAR,1,3) <> '341') .And. (SUBSTR(E2_CODBAR,1,1) <> ' ')) .Or. ((SUBSTR(E2_LINDIG,1,3) <> '341') .And. (SUBSTR(E2_LINDIG,1,1) <> ' ')))"

ElseIf cModPgto = '13' // Pagamento a Concessionárias

   _cFiltro := "( (LEN(ALLTRIM(E2_LINDIG)) = 48) .Or. (LEN(ALLTRIM(E2_CODBAR)) = 48))"

ElseIf cModPgto = '01' // Crédito em Conta Corrente

   _cFiltro := "(E2_FORMPAG = '01')"

ElseIf cModPgto = '05' // Crédito em Conta Corrente

   _cFiltro := "(E2_FORMPAG = '05')"

ElseIf cModPgto = '03' // DOC

   _cFiltro := "(E2_FORMPAG = '03')"

ElseIf cModPgto = '41' // TED Outro Titular

   _cFiltro :=  "(E2_FORMPAG = '41')"

ElseIf cModPgto = '43' // TED Mesmo Titular*/

   _cFiltro := "(E2_FORMPAG = '43')"

//ElseIf cModPgto = '01' // Crédito em conta corrente

ElseIf cModPgto = '16' // Darf Simples

   _cFiltro := "(E2_FORMPAG = '16')"

ElseIf cModPgto = '17' // GPS

   _cFiltro := "(E2_FORMPAG = '17')"

ElseIf cModPgto = '18' // Darf Simples

   _cFiltro := "(E2_FORMPAG = '18')"

ElseIf cModPgto = '21' // Darj

   _cFiltro := "(E2_FORMPAG = '21')"

ElseIf cModPgto = '35' // FGTS

   _cFiltro := "(E2_FORMPAG = '35')"


ElseIf cModPgto = '91' // gnre

   _cFiltro := "(E2_FORMPAG = '91')"

ElseIf cModPgto = '02' // Cheque

   _cFiltro := "(E2_FORMPAG = '02')"

End
 
Return _cFiltro