#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'tbiconn.ch'
#include 'topconn.ch'

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
    
    Local aArea := GetArea() 
    Local cEmpJob := "01"
    Local cFilJob := "01"
    Local cNaturez
    Local cDias
    Local cQuery
   
    Default aParam := {cEmpJob,cFilJob}

    IF !EMPTY(cEmpJob) .AND. !EMPTY(cFilJob)
	  
		RpcSetEnv(cEmpJob, cFilJob)

        cNaturez := SuperGetMV("CP_NBSA1",.F.,"")
        cDias := DTOS(DataValida(Date() - GetNewPar("CP_NDSA1", 4), .T.))

        FwLogMsg("INFO", /*cTransactionId*/, "CSA1B001", FunName(), "", "01", "INICIO DA ROTINA DE BLOQUEIO DE CLIENTES INADIMPLENTES", 0, 10, {})

        If Select("Trb") > 0
            DbSelectArea("Trb")
            Trb->(dbCloseArea())
        Endif

        cQuery := " SELECT SA1.R_E_C_N_O_ A1_RECNO "+CRLF
        cQuery += " FROM "+RetSqlName("SA1")+" SA1 (NOLOCK) "+CRLF

        cQuery += " INNER JOIN "+RetSqlName("SE1")+" SE1 " 
        cQuery += " ON A1_COD = E1_CLIENTE " 
        cQuery += " AND A1_LOJA = E1_LOJA " 
        cQuery += " AND E1_SALDO > 0 " 
        cQuery += " AND E1_TIPO = 'NF ' " 
        cQuery += " AND E1_VENCREA < '"+ cDias +"' " 
        cQuery += " AND SE1.D_E_L_E_T_ <> '*' "+CRLF
        
        cQuery += " WHERE A1_FILIAL = '"+ xFilial("SA1") +"' "+CRLF
        cQuery += " AND A1_MSBLQL <> '1' "+CRLF
        cQuery += " AND E1_NATUREZ IN "+ FormatIn(cNaturez,",") +" "+CRLF
        cQuery += " AND SA1.D_E_L_E_T_ <> '*' "+CRLF
        cQuery += " GROUP BY SA1.R_E_C_N_O_ "+CRLF

        cQuery	:= ChangeQuery(cQuery)

        TCQuery cQuery New Alias "Trb" 

        DBSelectArea("SA1")
        Trb->(dbGoTop())

        WHILE !Trb->(EOF())  
            
            SA1->(DbGoTo(Trb->A1_RECNO))
            RECLOCK("SA1",.F.)
            SA1->A1_MSBLQL := "1"//Bloqueado
            SA1->A1_HPAGE := "PENDENCIA FINANCEIRA"
            FwLogMsg("INFO", /*cTransactionId*/, "CSA1B001", FunName(), "", "01", "CLIENTE "+SA1->A1_COD+"-"+SA1->A1_LOJA+"-"+ALLTRIM(SA1->A1_NOME)+" BLOQUEADO POR TER TÍTULOS VENCIDOS HA MAIS DE 2 DIAS.", 0, 10, {})
            SA1->(MSUNLOCK())
        
            Trb->(dbSkip())
        
        ENDDO
        Trb->(dbCloseArea())

        FwLogMsg("INFO", /*cTransactionId*/, "CSA1B001", FunName(), "", "01", "FIM DA ROTINA DE BLOQUEIO DE CLIENTES INADIMPLENTES", 0, 10, {})

    Endif
    
    RestArea(aArea)

Return Nil    
