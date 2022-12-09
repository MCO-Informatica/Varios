User Function M200SUB()
Local aRegSG1 := PARAMIXB
// Local cOrigem := aDadosOrig[1]
// Local cDestino := aDadosDest[1]
Local nP as numeric
Local aPergs   := {}
Local nPerc   := 0
 
aAdd(aPergs, {1, "% diff.",  nPerc,  "@E 999.9999",     "Positivo()", "", ".T.", 80,  .F.})
 
If ParamBox(aPergs, "Informe os parâmetros")
    nPerc := MV_PAR01
    For nP := 1 to len(aRegSG1)
        SG1->(DbGoTo(aRegSG1[nP]))
        SG1->(RecLock("SG1",.F.))
        SG1->G1_QUANT := SG1->G1_QUANT * nPerc / 100
        SG1->(MsUnlock())

        Processa({|| U_altMT200(SG1->G1_COD,nP,len(aRegSG1))}, "Atualizando...")

    Next nP
EndIf

Return Nil
