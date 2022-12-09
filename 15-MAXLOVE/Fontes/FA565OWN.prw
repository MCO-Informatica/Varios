#INCLUDE 'PROTHEUS.CH'
 
User Function FA565OWN()
 
Local cQuery        := ""
Local cTmpSe2Fil    := ""
Local aTam          := TamSX3("E2_VALOR")
Local lEmpComp      := FWModeAccess("SE2", 1) == "C"
 
If !lEmpComp
    lEmpComp := !Empty(aSelFil) .And. FWModeAccess("SE2", 3) == "C"
EndIf
     
cQuery := "SELECT R_E_C_N_O_ FROM " + RetSQLName("SE2") + " "       //Deve sempre retornar o RECNO pois o processo depende dessa informação para seu perfeito funcionamento.
     
If (lEmpComp .Or. Empty(aSelFil))
    cQuery += "WHERE " + " E2_FILORIG <> ' ' " //FinSelFil(aSelFil, "SE2")
Else
    cQuery += "WHERE " + " E2_FILORIG <> ' ' " //+ "E2_FILIAL " + GetRngFil( aSelFil, "SE2", .T., @cTmpSE2Fil)
    cArqFil := cTmpSE2Fil
EndIf  
     
cQuery += " and E2_FORNECE >= '" + cFornDe + "'"
cQuery += " and E2_FORNECE <= '" + cFornAte + "'"
cQuery += " and E2_LOJA >= '"    + cLojaDe + "'"
cQuery += " and E2_LOJA <= '"    + cLojaAte + "'"
cQuery += " and E2_PREFIXO >= '" + cPrefDe + "'"
cQuery += " and E2_PREFIXO <= '" + cPrefAte + "'"
cQuery += " and E2_NUM >= '"     + cNumDe + "'"
cQuery += " and E2_NUM <= '"     + cNumAte + "'"
 
If nIntervalo == 1
    cQuery += " and E2_EMIS1 >= '" + DTOS(dData565I) + "'"
    cQuery += " and E2_EMIS1 <= '" + DTOS(dData565F) + "'"
Else
    cQuery += " and E2_VENCTO >= '" + DTOS(dData565I) + "'"
    cQuery += " and E2_VENCTO <= '" + DTOS(dData565F) + "'"
EndIf
     
If nChoice == 2 //Nao converte outras moedas
    cQuery += " and E2_MOEDA = " + AllTrim(Str(nMoeda))
Endif
     
// AAF - Titulos originados no SIGAEFF não devem ser alterados
cQuery += " and E2_ORIGEM NOT IN('SIGAEFF ', 'FINI055 ')"
cQuery += " and E2_SALDO > 0"
cQuery += " and E2_VALOR >= " + AllTrim(Str(nValorDe,aTam[1]+aTam[2]+1,aTam[2]))
cQuery += " and E2_VALOR <= " + AllTrim(Str(nValorAte,aTam[1]+aTam[2]+1,aTam[2]))   
     
If !lReliquida  //Liquida titulos não liquidados anteriormente
    cQuery += " and E2_NUMLIQ = '" + Space(TamSX3("E2_NUMLIQ")[1]) + "'"
ElseIf lReliquida       // Reliquidação
    cQuery  += " and E2_NUMLIQ <> '" + Space(TamSX3("E2_NUMLIQ")[1]) + "'"
Endif
     
cQuery += " AND NOT (E2_TIPO IN " + FormatIn(MVPROVIS + "|" + MVPAGANT + "|" + MV_CPNEG + "|" + MVABATIM,"|") + ")"
     
cQuery += " and D_E_L_E_T_ = ' '"
 
Return(cQuery)
