#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410I    ºAutor  ³Roberto Marques  º Data ³  01/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Para gravar o saldo da tarefa ref  ao     º±±
±±º          ³ pedido faturado.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA410I()
/*		Local nValor	:= 0
		Local nTotalPed := 0
		Local mSQL 	:= ""

		
		
		nTotalPed	+=  SC6->C6_VALOR

		nValor := AFC->AFC_FATPV + nTotalPed
		RecLock( "AFC", .F. )
		AFC->AFC_FATPV := nValor
		AFC->( MsUnlock() )
		
		RecLock( "SC5", .F. )
		SC5->C5_PROJ 	:= AFC->AFC_PROJET
		SC5->C5_REVISA  := AFC->AFC_REVISA
		SC5->C5_EDT		:= AFC->AFC_EDT
		//SC5->C5_MENNOTA := 
		SC5->( MsUnlock() )
		
    If Select( "TAF9" ) > 0
			TAF9->( DbCloseArea() )
    EndIf
		
		mSQL := " SELECT * FROM "+ RetSQLName("AF9")
		mSQL += " WHERE AF9_FILIAL = '"+xFilial ("AF9")+"'"
		mSQL += " AND D_E_L_E_T_ <>'*' "
		mSQL += " AND AF9_PROJET ='"+AFC->AFC_PROJET+"'"
		mSQL += " AND AF9_REVISA ='"+AFC->AFC_REVISA+"'"
		mSQL += " AND AF9_TAREFA ='"+SC6->C6_TASKPMS+"'"
		
		DbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL),"TAF9", .F., .T.)
		TAF9->( DbGoTop() )  
		
		RecLock( "SC6", .F. )
		SC6->C6_PROJPMS := AFC->AFC_PROJET
		SC6->C6_REVISA  := AFC->AFC_REVISA
		SC6->C6_EDTPMS	:= AFC->AFC_EDT
		SC6->C6_QTDLIB	:= SC6->C6_QTDVEN
		SC6->C6_CODISS	:= TAF9->AF9_CODISS
		SC6->( MsUnlock() )
		
		TAF9->( DbCloseArea() )
		
    If Select( "TMP1" ) > 0
			TMP1->( DbCloseArea() )
    EndIf
		
		mSQL := " SELECT AFC_FATPV FROM "+ RetSQLName("AFC")
		mSQL += " WHERE AFC_FILIAL = '"+xFilial ("AFC")+"'"
		mSQL += " AND D_E_L_E_T_ <>'*' "
		mSQL += " AND AFC_PROJET ='"+AFC->AFC_PROJET+"'"
		mSQL += " AND AFC_REVISA ='"+AFC->AFC_REVISA+"'"
		mSQL += " AND AFC_EDT ='"+AFC->AFC_PROJET+"'"
		
		DbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL),"TMP1", .F., .T.)
		TMP1->( DbGoTop() )  
		
		
		nValor := TMP1->AFC_FATPV + SC6->C6_VALOR 
		 
	
		mSQL := "UPDATE "+ RetSQLName("AFC") +" SET AFC_FATPV ="+Str(nValor)
		mSQL += " WHERE AFC_FILIAL = '"+xFilial ("AFC")+"'"
		mSQL += " AND D_E_L_E_T_ <>'*' "
		mSQL += " AND AFC_PROJET ='"+AFC->AFC_PROJET+"'"
		mSQL += " AND AFC_REVISA ='"+AFC->AFC_REVISA+"'"
		mSQL += " AND AFC_EDT ='"+AFC->AFC_PROJET+"'"
		    
		TCSQLEXEC(MSQL)	                         
		

	Return
    
USER FUNCTION RevAtual(cProj)
    	Local mSQL 	:= ""
    	Local cRet	:= ""
    	
    	mSQL := " SELECT AFC_PROJET,MAX(AFC_REVISA)AFC_REVISA,AFC_EDT 
    	mSQL += " FROM "+RetSQLName("AFC") 
    	mSQL += " WHERE AFC_PROJET='"+cProj+"' AND D_E_L_E_T_<>'*' AND AFC_FILIAL='"+xFilial ("AFC")+"'"
    	mSQL += " GROUP BY AFC_PROJET,AFC_EDT " 
		
    If Select( "TREV" ) > 0
			TREV->( DbCloseArea() )
    EndIf
        
		TREV->( DbGoTop() )  
		
		
		cRet := TREV->AFC_REVISA 

		TREV->( DbCloseArea() )
*/
Return
