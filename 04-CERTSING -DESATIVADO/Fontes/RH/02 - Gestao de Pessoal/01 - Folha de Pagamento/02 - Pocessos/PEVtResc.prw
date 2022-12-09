#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"   

#Define CRLF Chr(13)+Chr(10)
                                                                                                                                                             
//+------------------------------------------------------------------+
//| Rotina | PEVtResc | Autor | Rafael Beghini | Data | 25/06/2014   |
//+------------------------------------------------------------------+
//| Descr. | No cálculo da Rescisão, verifica se existe VT           |
//|        | para o funcionário e gera a verba no momento do cálculo.|
//+------------------------------------------------------------------+
//| Uso    | Recursos Humanos 			                             |
//+------------------------------------------------------------------+
User Function PEVtResc(cVerba)
                                                                 
	Local cFil     := SRA->RA_FILIAL
	Local cMat     := SRA->RA_MAT  
	Local cCCusto  := SRA->RA_CC
	Local nValor   := 0
	Local nVlrTot  := 0
	Local nVlrTot1 := 0
	Local nTotal   := 0
	Local nDiasVt  := 0
	Local cMes     := Strzero(Month(dDataDem1),2)
	Local cAno     := Strzero(Year(dDataDem1),4)
	
	nValor := fCalValor(cMat)
  
    nDias  := fCalDias(cAno,cMes,dDataDem1)
      	
    nVlrTot := nValor * nDias 
        
    If DAY(dDataDem1) <= 20
        If nVlrTot > 0
    		fGeraVerba(cVerba,nVlrTot,,,cCCusto,'V', ,0,, dDataBase,.T.)
    	EndIf
    Else
    	cAno := IIF(cMes=='12',cAno:=Strzero(Val(cAno)+1,4),cAno)
    	cMes := IIF(cMes=='12',cMes:='01',Strzero(Val(cMes)+1,2))
    	
    	dbSelectArea('RCF')
	    dbSetOrder(1)     
	    dbSeek( xFilial('RCF')+cAno+cMes )
    		nDiasVt := RCF->RCF_DUTILT 
    		
    	nVlrTot1 := nValor * nDiasVt 
    	nTotal := nVlrTot + nVlrTot1 
    	
    	If nTotal > 0
    		fGeraVerba(cVerba,nTotal,,,cCCusto,'V', ,0,, dDataBase,.T.)
    	EndIf
    EndIf
    
Return .T. 

//+------------------------------------------------------------------+
//| Rotina | fCalValor | Autor | Rafael Beghini | Data | 25/06/2014  |
//+------------------------------------------------------------------+
//| Descr. | Calcula o valor diário do funcionário                   |
//|        | 														 |
//+------------------------------------------------------------------+
//| Uso    | Recursos Humanos 			                             |
//+------------------------------------------------------------------+
Static Function fCalValor(cMat)

	Local cQuery := "" 
	Local nValor := 0
	
	cQuery += " SELECT " + CRLF 
	cQuery += "     R0_FILIAL " + CRLF 
	cQuery += "    ,R0_MAT " + CRLF 
	cQuery += "    ,R0_MEIO " + CRLF 
	cQuery += "    ,R0_QDIAINF " + CRLF 
	cQuery += "    ,RN_VUNIATU " + CRLF 
	cQuery += "    ,R0_QDIAINF*RN_VUNIATU AS VALOR " + CRLF 
	cQuery += " FROM " + RetSqlName("SR0") + " R0 " + CRLF 
	cQuery += "  	INNER JOIN " + RetSqlName("SRN") + " RN " + CRLF 
	cQuery += "     ON RN_FILIAL = R0_FILIAL
	cQuery += "     AND RN_COD = R0_MEIO " + CRLF
	cQuery += "   	AND RN.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " WHERE R0_MAT = '" + cMat + "' " + CRLF 
	cQuery += "   AND R0.D_E_L_E_T_ = ' ' " + CRLF             
	cQuery += " ORDER BY R0_MEIO ASC " + CRLF 
	cQuery := ChangeQuery(cQuery)
	
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cQuery New Alias "QRY"
	
	If QRY->( !Eof() ) 
		While QRY->( !Eof() )
			nValor += QRY->VALOR
		QRY->( dbSkip() )
		End
	EndIf
	QRY->(DbClosearea())
	
Return nValor

//+------------------------------------------------------------------+
//| Rotina | fCalDias | Autor | Rafael Beghini | Data | 07/07/2014   |
//+------------------------------------------------------------------+
//| Descr. | Calcula o número de dias para desconto do VT            |
//|        | 														 |
//+------------------------------------------------------------------+
//| Uso    | Recursos Humanos 			                             |
//+------------------------------------------------------------------+
Static Function fCalDias(cAno,cMes,dDataDem1)

	Local cQuery := "" 
	Local nDias  := 0
	Local dData  := dDataDem1+1
		
	cQuery += " SELECT " + CRLF 
	cQuery += "     COUNT(*)Dias " + CRLF 
	cQuery += " FROM " + RetSqlName("RCG") + " RCG " + CRLF 
	cQuery += " WHERE RCG_ANO = '" + cAno + "' " + CRLF 
	cQuery += "   AND RCG_MES = '" + cMes + "' " + CRLF 
	cQuery += "   AND RCG_TIPDIA = 1 " + CRLF 
	cQuery += "   AND RCG_DIAMES BETWEEN " + ValToSql(dData) 
    cQuery += "   AND                    " + ValToSql(LastDay(dDataDem1)) + CRLF 
	cQuery += "   AND RCG.D_E_L_E_T_ = ' ' " + CRLF             

	cQuery := ChangeQuery(cQuery)
	
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cQuery New Alias "QRY"
	
	If QRY->( !Eof() ) 
		nDias := QRY->Dias
	EndIf 
	QRY->(DbClosearea())
	
Return nDias