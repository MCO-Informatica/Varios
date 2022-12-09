#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'tbiconn.ch'

/*/{Protheus.doc} CSA1B001
    
    Rotina de bloqueio de clientes inadimplentes

    @type User Function
    @author Julio Teixeira
    @since 26/05/2021
    @version 12
    @param Nil
    @return Nil
/*/
User Function CSA1B001(aParam)
    
    Local aArea   
    Local cTrb    
    Local cNaturez

    Local lBloq := .t.
    Local nDias := 0
    Local dDtIni := date()
    Local dDtFin := date()
    Local dDtAtu := date()
    Local lSabado := .f.
    Local lDomingo := .f.
    Local lFeriado := .f.
    Local nDiasBlq := 0   // qtd dias após desbloqueio do cliente inadimplente que poderá ser bloqueado novamente.

    Default aParam := {"01","01"}

    IF !EMPTY(aParam[1]) .AND. !EMPTY(aParam[2])
	  
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

        FwLogMsg("INFO", /*cTransactionId*/, "CSA1B001", FunName(), "", "01", "INICIO DA ROTINA DE BLOQUEIO DE CLIENTES INADIMPLENTES", 0, 10, {})

        aArea   := GetArea()
        cTrb    := GetNextAlias()
        cNaturez := SuperGetMv("CP_NBSA1",.F.,"")

        nDiasBlq := GetNewPar("MV_XDIABLQ", 4)  // qtd dias após desbloqueio do cliente inadimplente que poderá ser bloqueado novamente.

        cQuery := " SELECT SA1.R_E_C_N_O_ A1_RECNO, A1_XDTDBLQ "+CRLF
        cQuery += " FROM "+RetSqlName("SA1")+" SA1 (NOLOCK) "+CRLF
        cQuery += " INNER JOIN "+RetSqlName("SE1")+" SE1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND E1_SALDO > 0 AND E1_TIPO = 'NF ' AND E1_VENCREA < '"+DTOS(Date()-2)+"' AND SE1.D_E_L_E_T_ <> '*' "+CRLF
        cQuery += " WHERE A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
        cQuery += " AND A1_MSBLQL <> '1' "+CRLF
        cQuery += " AND E1_NATUREZ IN "+FormatIn(cNaturez,",")+" "+CRLF
        cQuery += " AND SA1.D_E_L_E_T_ <> '*' "+CRLF
        cQuery += " GROUP BY SA1.R_E_C_N_O_ "+CRLF

        cQuery	:= ChangeQuery(cQuery)

        DBUseArea(.T., "TOPCONN", TcGenQry( , , cQuery), cTrb, .T., .T.) 
        DBSelectArea("SA1")
        (cTrb)->(dbGoTop())
        WHILE (cTrb)->(!EOF())  
            SA1->(DbGoTo((cTrb)->A1_RECNO))

            lBloq := .t.
            nDias := 0
            if !empty((cTrb)->A1_XDTDBLQ)
               dDtIni := Stod((cTrb)->A1_XDTDBLQ)
               dDtFin := dDataBase

               dDtAtu := dDtIni
               While dDtAtu <= dDtFin
                 //Se a data atual for uma data Válida
                 If dDtAtu == DataValida(dDtAtu) 
                    nDias++
                 EndIf
                 dDtAtu := DaySum(dDtAtu, 1)
               End

               nDias := DateWorkDay( dDtIni, dDtFin, lSabado, lDomingo, lFeriado )
               
               if nDias <= nDiasBlq
                  lBloq := .f.
               endif
            endif

            if lBloq
               RECLOCK("SA1",.F.)
                 SA1->A1_MSBLQL := "1"//Bloqueado
                 SA1->A1_HPAGE  := "PENDENCIA FINANCEIRA"
               SA1->(MSUNLOCK())
               FwLogMsg("INFO", /*cTransactionId*/, "CSA1B001", FunName(), "", "01", "CLIENTE "+SA1->A1_COD+"-"+SA1->A1_LOJA+"-"+ALLTRIM(SA1->A1_NOME)+" BLOQUEADO POR TER TÍTULOS VENCIDOS HA MAIS DE 2 DIAS.", 0, 10, {})
            endif
            (cTrb)->(dbSkip())
        END

        FwLogMsg("INFO", /*cTransactionId*/, "CSA1B001", FunName(), "", "01", "FIM DA ROTINA DE BLOQUEIO DE CLIENTES INADIMPLENTES", 0, 10, {})

        RESET ENVIRONMENT

    Endif

Return Nil    
