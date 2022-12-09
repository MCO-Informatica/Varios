#include "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SISPAG    ºAutor  ³Andreza Favero      º Data ³  27/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem as informacoes necessarias a montagem do arquivo SisPag                                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SisPag(cOpcao)

    Local cReturn   := ""
    Local nReturn   := 0
    Local cAgencia  := " "
    Local cNumCC    :=" "
    Local cDVAgencia:= " "
    Local cDVNumCC  := " "


    If cOpcao == "1"    // obter numero de conta e agencia

        cAgencia :=  Alltrim(SA2->A2_AGENCIA)

        If AT("-",cAgencia) > 0
            cAgencia := Substr(cAgencia,1,AT("-",cAgencia)-1)
        Endif

        cAgencia := STRTRAN(cAgencia,".","")

// Obtem o digito da agencia

        cDVAgencia :=  Alltrim(SA2->A2_AGENCIA)
        If AT("-",cDVAgencia) > 0
            cDVAgencia := Substr(cDVAgencia,AT("-",cDVAgencia)+1,1)
        Else
            cDVAgencia := Space(1)
        Endif

// Obtem o numero da conta corrente

        cNumCC :=  Alltrim(SA2->A2_NUMCON)

        If AT("-",cNumCC) > 0
            cNumCC := Substr(cNumCC,1,AT("-",cNumCC)-1)
        Endif


// obtem o digito da conta corrente

        cDVNumCC :=  Alltrim(SA2->A2_NUMCON)
        If AT("-",cDVNumCC) > 0
            cDVNumCC := Substr(cDVNumCC,AT("-",cDVNumCC)+1,2)
        Else
            cDVNumCC := Space(1)
        Endif



        If SA2->A2_BANCO == "341"  // se for o próprio Itaú - credito em C/C

            nReturn:= "0"+cAgencia+space(1)+Replicate("0",7)+cNumCC+space(1)+cDVNumCC

        Else  // para os outros bancos - DOC

            If Len(Alltrim(cDvNumCC)) > 1
                nReturn:= StrZero(Val(cAgencia),5)+space(1)+StrZero(val(cNumCC),12)+cDvNumCC
            Else
                nReturn:= StrZero(Val(cAgencia),5)+space(1)+StrZero(val(cNumCC),12)+space(1)+cDvNumCC
            EndIf

        EndIf

    ElseIf cOpcao == "2"  // valor a pagar

        _nVlTit:= SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC

        nReturn := Strzero((_nVlTit * 100),15)

    ElseIf  cOpcao == "3"  // Verifica o DV Geral

        If Len(Alltrim(SE2->E2_CODBAR)) > 44
            nReturn := Substr(SE2->E2_CODBAR,33,1)
        Else
            nReturn:= Substr(SE2->E2_CODBAR,5,1)
        EndIf

    ElseIf  cOpcao == "4"       // FATOR DE VENCIMENTO

        If Len(Alltrim(SE2->E2_CODBAR)) > 44
            nReturn := Substr(SE2->E2_CODBAR,34,4)
        Else
            nReturn:= Substr(SE2->E2_CODBAR,6,4)
        EndIf

    ElseIf  cOpcao == "5"       // Valor constante do codigo de barras

        If Len(Alltrim(SE2->E2_CODBAR)) > 44
            nValor := Substr(SE2->E2_CODBAR,38,10)
        Else
            nValor := Substr(SE2->E2_CODBAR,10,10)
        EndIf

        nReturn := Strzero(Val(nValor),10)

    ElseIf  cOpcao == "6"       // Campo Livre

        If Len(Alltrim(SE2->E2_CODBAR)) > 44
            nReturn := Substr(SE2->E2_CODBAR,5,5)+Substr(SE2->E2_CODBAR,11,10)+;
                Substr(SE2->E2_CODBAR,22,10)
        Else
            nReturn := Substr(SE2->E2_CODBAR,20,25)
        EndIf

    ElseIf cOpcao == "7"  // pagamento de tributos

        cTributo:= SubsTr(SEA->EA_MODELO,1,2)
        cCodRec:= SE2->E2_CODREC
        cTpInscr := "2"  // cnpj
        cCNPJ:= StrZero(Val(SM0->M0_CGC),14)
        dPeriodo:= GravaData(SE2->E2_EMISSAO,.F.,5)
        cReferen:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)
        nValor:= StrZero((SE2->E2_SALDO*100),14)
        nValorMult:=  "00000000000000"
        nValorJuros:= "00000000000000"
        dVencto:= GravaData(SE2->E2_VENCTO,.F.,5)
        dDtPagto:= GravaData(SE2->E2_VENCREA,.F.,5)
        cBrancos:= space(30)
        cContrib:= Substr(SM0->M0_NOMECOM,1,30)


        nReturn:= cTributo + cCodRec +  cTpInscr + (cCNPJ) + dPeriodo + Padr(cReferen,17)+(nValor)+(nValorMult)+(nValorJuros)+;
            (nValor) + dVencto + dDtPagto+space(60)


    ElseIf  cOpcao == "8"       // Valor nominal

        If Len(Alltrim(SE2->E2_CODBAR)) > 44
            nValor := Substr(SE2->E2_CODBAR,38,10)
        Else
            nValor := Substr(SE2->E2_CODBAR,10,10)
        EndIf

        If Val(nValor) > 0
            nReturn := Strzero(Val(nValor*100),15)
        Else
            nReturn:= Strzero(SE2->E2_SALDO*100,15)
        EndIf

    EndIf

Return(nReturn)