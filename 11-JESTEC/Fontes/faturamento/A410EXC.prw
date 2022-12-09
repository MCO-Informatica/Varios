#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410EXC    ºAutor  ³Roberto Marques  º Data ³  01/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Para gravar o saldo da tarefa ref  ao     º±±
±±º          ³ pedido EXCLUIDO.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A410EXC()
/*		Local mSQL 	
		
		Local nValor	:= 0
		
    If Select( "TMP" ) > 0
			TMP->( DbCloseArea() )
    EndIf
		
    If Select( "TMP1" ) > 0
			TMP1->( DbCloseArea() )
    EndIf

		mSQL := " SELECT SUM(C6_VALOR)VALOR,C6_PROJPMS,C6_REVISA,C6_EDTPMS "
		mSQL += " FROM "+ RetSQLName("SC6") 
		mSQL += " WHERE C6_NUM='"+SC5->C5_NUM+"' AND C6_FILIAL='"+ xFilial ("SC6") +"'"
		mSQL += " GROUP BY C6_PROJPMS,C6_REVISA,C6_EDTPMS "
		
		
		DbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL),"TMP", .F., .T.)
		TMP->( DbGoTop() )
		
		mSQL := " SELECT AFC_FATPV FROM "+ RetSQLName("AFC")
		mSQL += " WHERE AFC_FILIAL = '"+xFilial ("AFC")+"'"
		mSQL += " AND D_E_L_E_T_ <>'*' "
		mSQL += " AND AFC_PROJET ='"+TMP->C6_PROJPMS+"'"
		mSQL += " AND AFC_REVISA ='"+TMP->C6_REVISA+"'"
		mSQL += " AND AFC_EDT ='"+TMP->C6_EDTPMS+"'"
		
		DbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL),"TMP1", .F., .T.)
		TMP1->( DbGoTop() )  
		
		nValor := TMP1->AFC_FATPV - TMP->VALOR
		
		mSQL := "UPDATE "+ RetSQLName("AFC") +" SET AFC_FATPV ="+Str(nValor)
		mSQL += " WHERE AFC_FILIAL = '"+xFilial ("AFC")+"'"
		mSQL += " AND D_E_L_E_T_ <>'*' "
		mSQL += " AND AFC_PROJET ='"+TMP->C6_PROJPMS+"'"
		mSQL += " AND AFC_REVISA ='"+TMP->C6_REVISA+"'"
		mSQL += " AND AFC_EDT ='"+TMP->C6_EDTPMS+"'"
		    
		TCSQLEXEC(MSQL)	
		
		// ATUALIZAR PROJETO
		
    If Select( "TMP1" ) > 0
			TMP1->( DbCloseArea() )
    EndIf
		
		mSQL := " SELECT AFC_FATPV FROM "+ RetSQLName("AFC")
		mSQL += " WHERE AFC_FILIAL = '"+xFilial ("AFC")+"'"
		mSQL += " AND D_E_L_E_T_ <>'*' "
		mSQL += " AND AFC_PROJET ='"+TMP->C6_PROJPMS+"'"
		mSQL += " AND AFC_REVISA ='"+TMP->C6_REVISA+"'"
		mSQL += " AND AFC_EDT ='"+TMP->C6_PROJPMS+"'"
		
		DbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL),"TMP1", .F., .T.)
		TMP1->( DbGoTop() )  
		
		nValor := TMP1->AFC_FATPV - TMP->VALOR
		
		mSQL := "UPDATE "+ RetSQLName("AFC") +" SET AFC_FATPV ="+Str(nValor)
		mSQL += " WHERE AFC_FILIAL = '"+xFilial ("AFC")+"'"
		mSQL += " AND D_E_L_E_T_ <>'*' "
		mSQL += " AND AFC_PROJET ='"+TMP->C6_PROJPMS+"'"
		mSQL += " AND AFC_REVISA ='"+TMP->C6_REVISA+"'"
		mSQL += " AND AFC_EDT ='"+TMP->C6_PROJPMS+"'"
		    
		TCSQLEXEC(MSQL)	    

		    
*/		
Return