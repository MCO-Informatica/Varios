# include 'protheus.ch'

User Function MT120FIM()
Local aAreaAtu	:= GetArea()  
Local cNumPC	:= ""
Local aAreaSC7	:= SC7->(GetArea()) 
Local aAreaCNX	:= CNX->(GetArea())
Local aNumTit	:= {}
Local cNumContr	:= ""
Local cRevisao	:= ""
Local nVlrPerc	:= 0
Local nVlrTit	:= 0
Local nVlrAdi	:= 0     
Local aDadosCNX	:= {} 
Local lGeraCNX	:= .F.
Local nSaldoCNX	:= 0  
Local cNumMed	:= ""
Local cNovoNumero := ""        
Local aRegAtu	:= {}
                                 
If IsInCallStack("CNTA120") .And. !IsInCallStack('CN120MedEst')

 	if CND->CND_TOTADT > 0 

		DbSelectArea('SC7')
		SC7->(DbSetOrder(1))
 
		cNumPC		:= PARAMIXB[2] 
	
		cNumContr 	:= CND->CND_CONTRA
		cRevisao	:= CND->CND_REVISA
		cNumMed		:= CND->CND_NUMMED

		dbSelectArea("CZY")
		dbSetOrder(1)
		dbSeek(xFilial("CZY")+cNumContr+cRevisao+cNumMed)

    	While CZY->CZY_CONTRA = cNumContr .and. CZY->CZY_REVISA = cRevisao .and. CZY->CZY_NUMMED = cNumMed

			DbSelectArea('CNX')
			CNX->(DbSetOrder(1))
			CNX->(DbSeek(xFilial('CNX') + cNumContr + CZY->CZY_NUMERO))

			aNumTit	:= GetTitulo(cNumContr,cRevisao,CNX->CNX_NUMTIT,CNX->CNX_PREFIX)
			nVlrAdi := nVlrAdi + CZY->CZY_VALOR
		  		
			If Len(aNumTit) > 0 .And. SC7->( DbSeek(xFilial("SC7") + cNumPC ) )
					
			    RecLock("FIE",.T.)
			   	FIE_FILIAL := xFilial('FIE')
			    FIE_CART   := "P"
			    FIE_PEDIDO := SC7->C7_NUM
			    FIE_PREFIX := aNumTit[1,1]
			    FIE_NUM    := aNumTit[1,2]
			    FIE_PARCEL := aNumTit[1,3]
			    FIE_TIPO   := "PA"
			    FIE_CLIENT := ""
			    FIE_FORNEC := SC7->C7_FORNECE
			    FIE_LOJA   := SC7->C7_LOJA
			    FIE_VALOR  := CZY->CZY_VALOR 		// Valor do Adiantamento
			    FIE_SALDO  := CZY->CZY_VALOR		
				FIE->(MSUnLock())	
					
			EndIf		  		

			DBSelectArea("CZY")
			DBSetOrder(1)
			DBSkip()

		EndDo  		  		  

	EndIf 
	 
EndIf

RestArea( aAreaCNX )
RestArea( aAreaSC7 )

Return()                               



Static Function GetTitulo(cNumContr,cRevisao,cNumTit,cPrefTit)
Local cQuery	:= ""
Local cAliasQry := GetNextAlias()
Local aAreaAtu	:= GetArea()
Local aRetorno	:= {}    

cQuery := "SELECT E2_PREFIXO, E2_NUM, E2_PARCELA "
cQuery += "FROM "+RetSqlName("SE2")
cQuery += " WHERE E2_FILIAL  = '"+xFilial("SE2")+"'"
cQuery += "   AND E2_NUM = '"+cNumTit+ "'"+ " AND E2_PREFIXO = '"+cPrefTit+"'"
cQuery += "   AND E2_MDCONTR = '"+cNumContr+ "'"
//cQuery += "   AND E2_MDREVIS = '"+cRevisao+ "'" // Não pode considerar a revisão para os titulos PA
cQuery += "   AND D_E_L_E_T_  = ' ' "
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. )
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())

While (cAliasQry)->(!Eof())
    Aadd(aRetorno,{ (cAliasQry)->E2_PREFIXO, (cAliasQry)->E2_NUM, (cAliasQry)->E2_PARCELA })
    (cAliasQry)->(dbSkip())
EndDo

(cAliasQry)->(DbCloseArea())

Return( aRetorno )  
