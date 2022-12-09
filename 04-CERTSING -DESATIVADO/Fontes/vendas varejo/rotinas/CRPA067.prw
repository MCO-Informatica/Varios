#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA031C  º Autor ³ Renato Ruy	     º Data ³  20/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para do Fechamento.							      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Remuneração de Parceiros                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CRPA067()

Local aRet 		:= {}
Local bValid  	:= {|| .T. }

Private aPar 	:= {}

//Utilizo parambox para fazer as perguntas
aAdd( aPar,{ 1  ,"Periodo " 	 	,Space(6),"","","","",50,.F.})
aAdd( aPar,{ 1  ,"Entidade De"	 	,Space(6),"","","","",50,.F.})
aAdd( aPar,{ 1  ,"Entidade Ate"		,Space(6),"","","","",50,.F.})
aAdd( aPar,{ 2  ,"Tipo Ent." 	 	,"TODAS" ,{"TODAS","POSTO","AC/CANAL","REVENDEDOR"}, 100,'.T.',.T.})

ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CRPA031" , .T., .F. )
If Len(aRet) > 0
	MsAguarde( {|lEnd| CRPA67C(aRet,@lEnd) }, "Aguarde...", "Gerando Calculo de Encerramento...",.T.)
Else
	Alert("Rotina Cancelada!")
EndIf

Return 

Static Function CRPA67C(aRet, lEnd)

Local nFeder   := 0
Local nFederSW := 0
Local nFederHW := 0
Local nAR	   	 := 0
Local nARSW    := 0
Local nARHW	 := 0
Local cCodPar  := ""
Local cWhere   := "%  %"
Local nValVis	 := 0
Local nDesconto	 := 0
Local nExtra	 := 0
Local cQryDesc	 := ""
Local cCodParcs	 := ""
Local cStart
Local cEnd

If Empty(aRet[2])
	aRet[2] := "0"
Endif

If Select("QCRPR130") > 0
	DbSelectArea("QCRPR130")
	QCRPR130->(DbCloseArea())
Endif

MsProcTxt("Selecionando Dados dos Postos.")
ProcessMessage()    

cStart := Time()

If AllTrim(aRet[4]) $ "TODAS/POSTO" //"TODAS","POSTO","AC","REVENDEDOR"

	If !Empty(aRet[2])
		cWhere := "% AND Z6_CODCCR Between '"+aRet[2]+"' AND '"+aRet[3]+"' %"
	Endif 
	
	
	BeginSql Alias "QCRPR130"
	
		%noparser%
		
		SELECT PERIODO,
		       MAX(REDE) REDE,
		       CODENT,
		       DESENT,
		       CGC,
		       SUM(CONPED) CONPED,
		       SUM(VALHW) VALHW,
		       SUM(COMHW) COMHW,
		       SUM(VALSW) VALSW,
		       SUM(COMSW) COMSW,
		       SUM(VLRABT) VLRABT,
		       SUM(VALPRD) VALPRD,
		       SUM(VALCOM) VALCOM,
		       SUM(VALFED) VALFED,
	           SUM(VALFEDSW) VALFEDSW,
	           SUM(VALFEDHW) VALFEDHW
		FROM
		  (SELECT Z6_PERIODO PERIODO,
		          CASE WHEN MAX(Z3_CODENT) = '071609' OR MAX(Z3_CODENT) = '054295' THEN 'CACB' WHEN MAX(Z3_CODENT) = '073322' THEN 'SIN' ELSE MAX(Z6_CODAC) END REDE,
		          CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED,
		          Z6_PEDGAR PEDGAR,
		          Z6_PEDSITE PEDSITE,
		          Z6_PRODUTO PRODUTO,
		          Z3_CODENT CODENT,
				  Z3_DESENT DESENT,
		          Z3_CGC CGC,
		          TRIM(Z3_CODPAR) ||','|| TRIM(Z3_CODPAR2) CODPAR,
		          SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
		          SUM(CASE WHEN Z6_CATPROD = '1' AND Z3_ATIVO != 'N' AND Z6_CODCCR != '054615' THEN Z6_VALCOM ELSE 0 END) COMHW,
		          SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
		          SUM(CASE WHEN Z6_CATPROD = '2' AND Z3_ATIVO != 'N' AND Z6_CODCCR != '054615' THEN Z6_VALCOM ELSE 0 END) COMSW,
		          SUM(Z6_VLRABT) VLRABT,
		          SUM(Z6_VLRPROD) VALPRD,
		          SUM(CASE WHEN Z3_ATIVO != 'N' AND Z6_CODCCR != '054615' THEN Z6_VALCOM ELSE 0 END) VALCOM,
		          CASE
		              WHEN MAX(Z6_PEDGAR) != ' ' THEN MAX(
		                                                    (SELECT SUM(Z6_VALCOM)
		                                                     FROM %Table:SZ6% SZ62
		                                                     JOIN SZ3010 SZ32 ON 	SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND 
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND 
		                                                     						SZ32.Z3_RETPOS != 'N' AND 
		                                                     						SZ32.D_E_L_E_T_ = ' ' 
		                                                     WHERE SZ62.D_E_L_E_T_ = ' '
		                                                       AND Z6_FILIAL = ' '
		                                                       AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                       AND Z6_PEDGAR = SZ6.Z6_PEDGAR
		                                                       AND Z6_PEDGAR > '0'
		                                                       AND Z6_TPENTID = '8'))
		              WHEN MAX(Z6_PEDSITE) != ' ' THEN MAX(
		                                                     (SELECT SUM(Z6_VALCOM)
		                                                      FROM %Table:SZ6% SZ62
		                                                      JOIN SZ3010 SZ32 ON 	SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND 
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND 
		                                                     						SZ32.Z3_RETPOS != 'N' AND 
		                                                     						SZ32.D_E_L_E_T_ = ' ' 
		                                                      WHERE SZ62.D_E_L_E_T_ = ' '
		                                                        AND Z6_FILIAL = ' '
		                                                        AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                        AND Z6_PEDSITE = SZ6.Z6_PEDSITE
		                                                        AND Z6_PRODUTO = SZ6.Z6_PRODUTO
		                                                        AND Z6_PEDSITE > '0'
		                                                        AND Z6_TPENTID = '8'))
		          END VALFED,
		          CASE
		              WHEN MAX(Z6_PEDGAR) != ' ' THEN MAX(
		                                                    (SELECT SUM(Z6_VALCOM)
		                                                     FROM %Table:SZ6% SZ62
		                                                     JOIN SZ3010 SZ32 ON 	SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND 
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND 
		                                                     						SZ32.Z3_RETPOS != 'N' AND 
		                                                     						SZ32.D_E_L_E_T_ = ' ' 
		                                                     WHERE SZ62.D_E_L_E_T_ = ' '
		                                                       AND Z6_FILIAL = ' '
		                                                       AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                       AND Z6_PEDGAR = SZ6.Z6_PEDGAR
		                                                       AND Z6_PEDGAR > '0'
                                                           AND Z6_CATPROD = '2'
		                                                       AND Z6_TPENTID = '8'))
		              WHEN MAX(Z6_PEDSITE) != ' ' THEN 0
		          END VALFEDSW,
 	              CASE
		              WHEN MAX(Z6_PEDGAR) != ' ' THEN MAX(
		                                                    (SELECT SUM(Z6_VALCOM)
		                                                     FROM %Table:SZ6% SZ62
		                                                     JOIN SZ3010 SZ32 ON 	SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND 
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND 
		                                                     						SZ32.Z3_RETPOS != 'N' AND 
		                                                     						SZ32.D_E_L_E_T_ = ' ' 
		                                                     WHERE SZ62.D_E_L_E_T_ = ' '
		                                                       AND Z6_FILIAL = ' '
		                                                       AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                       AND Z6_PEDGAR = SZ6.Z6_PEDGAR
		                                                       AND Z6_PEDGAR > '0'
                                                           AND Z6_CATPROD = '1'
		                                                       AND Z6_TPENTID = '8'))
		              WHEN MAX(Z6_PEDSITE) != ' ' THEN MAX(
		                                                     (SELECT SUM(Z6_VALCOM)
		                                                      FROM %Table:SZ6% SZ62
		                                                      JOIN SZ3010 SZ32 ON SZ32.Z3_FILIAL = SZ62.Z6_FILIAL AND 
		                                                     						SZ32.Z3_CODENT = SZ62.Z6_CODENT AND 
		                                                     						SZ32.Z3_RETPOS != 'N' AND 
		                                                     						SZ32.D_E_L_E_T_ = ' ' 
		                                                      WHERE SZ62.D_E_L_E_T_ = ' '
		                                                        AND Z6_FILIAL = ' '
		                                                        AND Z6_PERIODO = SZ6.Z6_PERIODO
		                                                        AND Z6_PEDSITE = SZ6.Z6_PEDSITE
		                                                        AND Z6_PRODUTO = SZ6.Z6_PRODUTO
		                                                        AND Z6_PEDSITE > '0'
                                                            AND Z6_CATPROD = '1'
		                                                        AND Z6_TPENTID = '8'))
		          END VALFEDHW
		   FROM %Table:SZ6% SZ6
		   JOIN %Table:SZ3% SZ3 ON Z3_FILIAL = ' '
		   AND Z3_CODENT = Z6_CODCCR
		   AND (Z3_TIPCOM = '1' OR Z3_TIPCOM = ' ')
		   AND SZ3.D_E_L_E_T_ = ' '
		   WHERE Z6_FILIAL = ' '
		     AND Z6_PERIODO = %Exp:aRet[1]%
		     AND Z6_TPENTID = '4'
		     //AND Z6_CODAC != 'NAOREM'
		     AND SZ6.D_E_L_E_T_ = ' '
		     %Exp:cWhere%
		   GROUP BY Z6_PERIODO,
		            Z6_PEDGAR,
		            Z6_PEDSITE,
		            Z6_PRODUTO,
		            Z3_CODENT,
		            Z3_DESENT,
		            Z3_CGC,
		            TRIM(Z3_CODPAR)||','||TRIM(Z3_CODPAR2)
		   ORDER BY Z6_PERIODO,
		            Z3_CODENT,
		            Z3_DESENT,
		            Z3_CGC)
		GROUP BY PERIODO,
		         CODENT,
		         DESENT,
		         CGC
		ORDER BY PERIODO,
		         DESENT
	EndSql

	QCRPR130->(dbGoTop())
	
	cEnd := Time()
	
	//MemoWrite("C:\DATA\CRPA067-POSTO.SQL",GetLastQuery()[2])
	
	//Alert("Tempo da Query: " + ElapTime(cStart, cEnd))
	
	While !QCRPR130->(EOF())
	
		MsProcTxt("Gerando Registros do CCR: " + QCRPR130->CODENT)
		ProcessMessage()    
		
		If lEnd
	      MsgStop("O processamento foi cancelado.")
	      Exit
	    Endif
		
		dbSelectArea("ZZ6")
		ZZ6->(dbSetOrder(1))
		If ZZ6->(dbSeek(xFilial("ZZ6") + QCRPR130->PERIODO + QCRPR130->CODENT))
			Processa({|| copiaZZ6()}, "Aguarde", "Aguarde", .T.)
			QCRPR130->(dbSkip())
			Loop
		EndIf
		
		nDescFed := 0
		cQryDesc := ""
		nDesconto := 0
		
		SZ3->(DbSetOrder(1))
		SZ3->(DbSeek( xFilial("SZ3") + QCRPR130->CODENT))
				
		If (!Empty(SZ3->Z3_CODPAR) .Or. !Empty(SZ3->Z3_CODPAR2)) .And. SZ3->Z3_ATIVO != 'N'
		
			cCodParcs := AllTrim(SZ3->Z3_CODPAR) + Iif(!Empty(SZ3->Z3_CODPAR2),","+AllTrim(SZ3->Z3_CODPAR),"")
		
			cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM, "
			cQuery2 += " 		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) CAMPHW, "
			cQuery2 += " 		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) CAMPSW "
			cQuery2 += " 								 FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_CODENT IN "+FormatIn(AllTrim(cCodParcs),",")+" AND z6_tpentid in ('7','10') "
				
			If Select("TMP2") > 0
				TMP2->(DbCloseArea())
			EndIf
			PLSQuery( cQuery2, "TMP2" )
		EndIf
		
		cQuery := " SELECT SUM(Z6_VALCOM) Z6_VALCOM FROM " + RetSQLName("SZ6") + " SZ6 WHERE SZ6.D_E_L_E_T_ = ' ' AND Z6_FILIAL = ' ' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_PRODUTO = 'VISITAEXTERNA' AND Z6_CODENT = '"+QCRPR130->CODENT+"' AND z6_tpentid = 'B' "
				
		If Select("TMP") > 0
			TMP->(DbCloseArea())
		EndIf
		PLSQuery( cQuery, "TMP" )
		
		//Yuri Volpe - 22/02/2019 
		//OTRS 2019021910001817 - Correção para inserir valores de Desconto ou Extra, conforme o caso
		/*cQryDesc := "SELECT SUM(Z6_VALCOM) DESCONTOS FROM " + RetSQLName("SZ6") + " SZ6 WHERE Z6_TIPO = 'DESCON' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_CODENT = '"+QCRPR130->CODENT+"' AND SZ6.D_E_L_E_T_ = ' '"
		
		If Select("TMPDESC") > 0
			TMPDESC->(dbCloseArea())
		EndIf
		PLSQuery( cQryDesc, "TMPDESC")
		
		nDesconto := 0
		If TMPDESC->DESCONTOS <> 0
			nDesconto := TMPDESC->DESCONTOS
		EndIf*/
		
		//Priscila Kuhn - 27/10/2015
	    //Aglutinador de federação.
		//054404	AR  CACB MA	=	054404	AR  CACB MA	+	054581	AR ACII
		//054807	AR FACISC	=	054807	AR FACISC	+	054730	AR ACIC			
		//054595	AR FACMAT	=	054595	AR FACMAT	+	054461	AR ACITS	+	054578	AR ACIR + 076182 AR ACC


		If AllTrim(QCRPR130->CODENT) $ "054404\054807\054595\054331\054419\054632\054307"
	    	
			cQuery := " SELECT SUM(Z6_VALCOM) VALFED2," 
			cQuery += " 	SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) VALFEDHW," 
			cQuery += "		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) VALFEDSW" 
			cQuery += " FROM SZ6010 SZ6 WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_TPENTID = '8' AND SZ6.D_E_L_E_T_ = ' '" 
			cQuery += " AND Z6_CODCCR IN ("
			cQuery += "		SELECT Z3_CODENT" 
			cQuery += "		FROM SZ3010" 
			cQuery += "		WHERE Z3_CODFED = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '"+QCRPR130->CODENT+"' AND D_E_L_E_T_ = ' ')"
			cQuery += "		AND Z3_TIPENT = '9'"
			cQuery += "		)"
	        
	    	If Select("TMP3") > 0
				TMP3->(DbCloseArea())
			EndIf
			PLSQuery( cQuery, "TMP3" )
			
			//Yuri Volpe - 22/02/2019 
			//OTRS 2019021910001817 - Correção para inserir valores de Desconto ou Extra, conforme o caso
			cQDescFed := "SELECT SUM(Z6_VALCOM) DESCFED FROM " + RetSQLName("SZ6") + " SZ6 WHERE Z6_FILIAL = '" + xFilial("SZ6") + "' AND (Z6_TIPO = 'DESCON' OR Z6_TIPO = 'EXTRA') AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_CODENT = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '"+QCRPR130->CODENT+"' AND D_E_L_E_T_ = ' ') AND SZ6.D_E_L_E_T_ = ' '"
			
			If Select("TMPDESCFED") > 0
				TMPDESCFED->(dbCloseArea())
			EndIf
			PLSQuery( cQDescFed, "TMPDESCFED")
			
			nDescFed := 0
			If TMPDESCFED->DESCFED <> 0
				nDescFed := TMPDESCFED->DESCFED
			EndIf
	    
	    	nFeder 	 := TMP3->VALFED2 + nDescFed + nExtra
	    	nFederSW := TMP3->VALFEDSW + nDescFed + nExtra
	    	nFederHW := TMP3->VALFEDHW
	    	
	    	TMPDESCFED->(dbCloseArea())
	    	
	    Elseif  QCRPR130->CODENT $ "054581/054730/054461/054578/075379"
	    	nFeder 	:= 0
	    	nFederSw:= 0
	    	nFederHw:= 0
	    Else
	    
	    	//Yuri Volpe - 22/02/2019 
			//OTRS 2019021910001817 - Correção para inserir valores de Desconto ou Extra, conforme o caso
			cQDescFed := "SELECT SUM(Z6_VALCOM) DESCFED FROM " + RetSQLName("SZ6") + " SZ6 WHERE Z6_FILIAL = '" + xFilial("SZ6") + "' AND Z6_TIPO = 'DESCON' AND Z6_PERIODO = '"+QCRPR130->PERIODO+"' AND Z6_CODENT = (SELECT Z3_CODFED FROM SZ3010 WHERE Z3_CODENT = '"+QCRPR130->CODENT+"' AND D_E_L_E_T_ = ' ') AND SZ6.D_E_L_E_T_ = ' '"
			
			If Select("TMPDESCFED") > 0
				TMPDESCFED->(dbCloseArea())
			EndIf
			PLSQuery( cQDescFed, "TMPDESCFED")
			
			nDescFed := 0
			If TMPDESCFED->DESCFED <> 0
				nDescFed := TMPDESCFED->DESCFED
			EndIf
	    	
	    	nFeder   := QCRPR130->VALFED + nDesconto + nExtra + nDescFed
	    	nFederSW := QCRPR130->VALFEDSW + nDesconto + nExtra + nDescFed
	    	nFederHW := QCRPR130->VALFEDHW   
	    	
	    	TMPDESCFED->(dbCloseArea())
	    	
	    Endif 
	    
	    //Renato Ruy - 11/09/2017
	    //Calculo da AR no mesmo CCR
	    Beginsql Alias "TMPAR"
	    	SELECT Z3_CODAR
			FROM %Table:SZ3% SZ3
			JOIN %Table:SZ4% SZ4
						ON Z4_FILIAL = ' '
						AND Z4_CODENT = Z3_CODAR
						AND SZ4.%NOTDEL%
			WHERE 	Z3_FILIAL = ' '
					AND Z3_CODCCR = %Exp:QCRPR130->CODENT%
					AND Z3_CODAR > ' '
					AND SZ3.%NOTDEL%
			GROUP BY Z3_CODAR
		Endsql
		
		//Deixa zerado para os demais CCRs
		nAR	   := 0
		nARSW  := 0
		nARHW  := 0
		
		If !Empty(TMPAR->Z3_CODAR)
		
			If Select("TMPADI") > 0
				DbSelectArea("TMPADI")
				TMPADI->(DbCloseArea())
			Endif
			
			//Busca os valores da AR
			Beginsql Alias "TMPADI"
			
				SELECT SUM(Z6_VALCOM) VALAR,
				       SUM(DECODE(Z6_CATPROD,1,0,Z6_VALCOM)) ARSW,
				       SUM(DECODE(Z6_CATPROD,2,0,Z6_VALCOM)) ARHW
				FROM SZ6010 
				WHERE 
				Z6_FILIAL = %xFilial:SZ6% AND
				Z6_PERIODO = %Exp:QCRPR130->PERIODO% AND
				Z6_TPENTID = '3' AND
				Z6_CODCCR = %Exp:QCRPR130->CODENT% AND
				D_E_L_E_T_ = ' '
				
			Endsql
			
			nAR	   := TMPADI->VALAR + nDesconto + nExtra
			nARSW  := TMPADI->ARSW + nDesconto + nExtra
			nARHW  := TMPADI->ARHW
			
		Endif
		TMPAR->(DbCloseArea())
		//Fim da alteracao AR
		
		PC2->(DbSetOrder(1))
		If !PC2->(DbSeek(xFilial("PC2")+QCRPR130->PERIODO+QCRPR130->CODENT))
			If PC2->(RecLock("PC2",.T.))
				PC2->PC2_FILIAL := xFilial("PC2")
				PC2->PC2_PERIOD := QCRPR130->PERIODO
				PC2->PC2_CODAC 	:= QCRPR130->REDE
				PC2->PC2_CODENT := QCRPR130->CODENT
				PC2->PC2_DESENT := QCRPR130->DESENT
				PC2->PC2_QTDPED := QCRPR130->CONPED
				PC2->PC2_VALSW  := QCRPR130->VALSW
				PC2->PC2_VALHW  := QCRPR130->VALHW
				PC2->PC2_VALFAT := QCRPR130->VALPRD
				PC2->PC2_COMSW  := QCRPR130->COMSW + Iif(!(SZ3->Z3_TIPENT $ "8/7/10"), nDesconto, 0)
				PC2->PC2_COMHW  := QCRPR130->COMHW
				PC2->PC2_COMTOT := QCRPR130->VALCOM + Iif(!(SZ3->Z3_TIPENT $ "8/7/10"), nDesconto, 0)
				PC2->PC2_FEDSW  := nFederSw
				PC2->PC2_FEDHW  := nFederHw
				PC2->PC2_VALFED := nFeder
				//Renato Ruy - 12/09/2017
				//Grava os novos campos com o valor de AR.
				PC2->PC2_VALAR	:= nAR
				PC2->PC2_ARSW	:= nARSW
				PC2->PC2_ARHW	:= nARHW
				PC2->PC2_CAMPSW := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->CAMPSW + nDesconto,0)
				PC2->PC2_CAMPHW := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->CAMPHW,0)
				PC2->PC2_VALCAM := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->Z6_VALCOM,0)
				PC2->PC2_VALVIS := TMP->Z6_VALCOM
				PC2->PC2_DATCAL := dDataBase
				PC2->PC2_ORIGEM := "A" //Geracao Automatica
				PC2->PC2_SALDO	:= PC2->PC2_COMTOT + PC2->PC2_VALFED + PC2->PC2_VALCAM + PC2->PC2_VALVIS + PC2->PC2_VALAR
				PC2->(MsUnlock())
			EndIf
		ElseIf Empty(PC2->PC2_PEDIDO)
			If PC2->(RecLock("PC2",.F.))
				PC2->PC2_CODAC 	:= QCRPR130->REDE
				PC2->PC2_QTDPED := QCRPR130->CONPED
				PC2->PC2_VALSW  := QCRPR130->VALSW
				PC2->PC2_VALHW  := QCRPR130->VALHW
				PC2->PC2_VALFAT := QCRPR130->VALPRD
				PC2->PC2_COMSW  := QCRPR130->COMSW + Iif(!(SZ3->Z3_TIPENT $ "8/7/10"), nDesconto, 0)
				PC2->PC2_COMHW  := QCRPR130->COMHW
				PC2->PC2_COMTOT := QCRPR130->VALCOM + Iif(!(SZ3->Z3_TIPENT $ "8/7/10"), nDesconto, 0)
				PC2->PC2_FEDSW  := nFederSw
				PC2->PC2_FEDHW  := nFederHw
				PC2->PC2_VALFED := nFeder
				//Renato Ruy - 12/09/2017
				//Grava os novos campos com o valor de AR.
				PC2->PC2_VALAR	:= nAR
				PC2->PC2_ARSW	:= nARSW
				PC2->PC2_ARHW	:= nARHW
				PC2->PC2_CAMPSW := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->CAMPSW + nDesconto,0)
				PC2->PC2_CAMPHW := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->CAMPHW,0)
				PC2->PC2_VALCAM := Iif(!Empty(SZ3->Z3_CODPAR) .And. SZ3->Z3_ATIVO != 'N',TMP2->Z6_VALCOM,0)
				PC2->PC2_VALVIS := TMP->Z6_VALCOM
				PC2->PC2_DATCAL := dDataBase
				PC2->PC2_ORIGEM := "A" //Geracao Automatica
				PC2->PC2_SALDO	:= PC2->PC2_COMTOT + PC2->PC2_VALFED + PC2->PC2_VALCAM + PC2->PC2_VALVIS + PC2->PC2_VALAR
				PC2->(MsUnlock())
			EndIf
		EndIf
		
		/*ZZ6->(DbSetOrder(1))
		If !ZZ6->(DbSeek(xFilial("ZZ6")+QCRPR130->PERIODO+QCRPR130->CODENT))
			If ZZ6->(RecLock("ZZ6",.T.))
				ZZ6->ZZ6_FILIAL := xFilial("ZZ6")
				ZZ6->ZZ6_PERIOD := QCRPR130->PERIODO
				ZZ6->ZZ6_CODAC 	:= QCRPR130->REDE
				ZZ6->ZZ6_CODENT := QCRPR130->CODENT
				ZZ6->ZZ6_DESENT := QCRPR130->DESENT
				ZZ6->(MsUnlock())
			EndIf
		EndIf*/		
		
		//Cria Base de Conhecimento
		//U_CRPA031G()
		//StartJob("U_CRPA031G",GetEnvServer(),.F.,PC2->(Recno()))
		
		QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
	
	//Renato Ruy - 24/02/17
	//Gerar a remuneracao para o CCR mesmo quando tem somente campanha.
	If Select("QCRPR130") > 0 
		DbSelectArea("QCRPR130")
		QCRPR130->(DbCloseArea())
	Endif
	
	BeginSql Alias "QCRPR130"

		SELECT 	Z3_CODENT,
				Z3_DESENT,
		  		Z3_CODPAR,
		  		Z3_CODPAR2 
		FROM %Table:SZ3% SZ3
		LEFT JOIN %Table:PC2% PC2
		ON PC2_FILIAL      = %xFilial:PC2%
		AND PC2_PERIOD     = %Exp:aRet[1]%
		AND PC2_CODENT     = Z3_CODENT
		AND PC2.%Notdel%
		WHERE Z3_FILIAL    = %xFilial:SZ3%
		AND Z3_CODENT Between %Exp:aRet[2]% AND %Exp:aRet[3]%
		AND Z3_CODPAR      > ' '
		AND Z3_ATIVO != 'N'
		AND PC2_CODENT    IS NULL
		AND SZ3.%Notdel%
		
	Endsql
	
	While !QCRPR130->(EOF()) 
	
		cCodParcs := AllTrim(QCRPR130->Z3_CODPAR) + Iif(!Empty(QCRPR130->Z3_CODPAR2),","+AllTrim(QCRPR130->Z3_CODPAR2),"")
	
		cQuery2 := " SELECT SUM(Z6_VALCOM) Z6_VALCOM, "
		cQuery2 += " 		SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM  ELSE 0 END) CAMPHW, "
		cQuery2 += " 		SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM  ELSE 0 END) CAMPSW, "
		cQuery2 += " 		MAX(Z6_CODAC) CODAC "
		cQuery2 += " FROM " + RetSQLName("SZ6") + " SZ6 "
		cQuery2 += " WHERE "
		cQuery2 += " Z6_FILIAL = ' ' AND "
		cQuery2 += " Z6_PERIODO = '"+aRet[1]+"' AND "
		cQuery2 += " z6_tpentid = '7' AND"
		cQuery2 += " Z6_CODENT IN "+FormatIn(AllTrim(cCodParcs),",")+" AND "
		cQuery2 += " SZ6.D_E_L_E_T_ = ' '"

			
		If Select("TMP2") > 0
			TMP2->(DbCloseArea())
		EndIf
		PLSQuery( cQuery2, "TMP2" )
	    
		PC2->(DbSetOrder(1))
		If !PC2->(DbSeek(xFilial("PC2")+aRet[1]+QCRPR130->Z3_CODENT)) .And. TMP2->Z6_VALCOM > 0
			If PC2->(RecLock("PC2",.T.))
				PC2->PC2_FILIAL := xFilial("PC2")
				PC2->PC2_PERIOD := aRet[1]
				PC2->PC2_CODAC 	:= TMP2->CODAC
				PC2->PC2_CODENT := QCRPR130->Z3_CODENT
				PC2->PC2_DESENT := QCRPR130->Z3_DESENT
				PC2->PC2_CAMPSW := TMP2->CAMPSW
				PC2->PC2_CAMPHW := TMP2->CAMPHW
				PC2->PC2_VALCAM := TMP2->Z6_VALCOM
				PC2->PC2_DATCAL := dDataBase
				PC2->PC2_ORIGEM := "A" //Geracao Automatica
				PC2->PC2_SALDO	:= TMP2->Z6_VALCOM
				PC2->(MsUnlock())
			EndIf
		ElseIf Empty(PC2->PC2_PEDIDO) .And. TMP2->Z6_VALCOM > 0
			If PC2->(RecLock("PC2",.F.))
				PC2->PC2_CODAC 	:= TMP2->CODAC
				PC2->PC2_CAMPSW := TMP2->CAMPSW
				PC2->PC2_CAMPHW := TMP2->CAMPHW
				PC2->PC2_VALCAM := TMP2->Z6_VALCOM
				PC2->PC2_DATCAL := dDataBase
				PC2->PC2_ORIGEM := "A" //Geracao Automatica
				PC2->PC2_SALDO	:= TMP2->Z6_VALCOM
				PC2->(MsUnlock())
			EndIf
		EndIf
	
		QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
	
EndIf

If Select("QCRPR130") > 0
	DbSelectArea("QCRPR130")
	QCRPR130->(DbCloseArea())
EndIf

If AllTrim(aRet[4]) $ "TODAS/REVENDEDOR" //"TODAS","POSTO","AC","REVENDEDOR"

	MsProcTxt( "Selecionando Dados dos Revendedores.")
	ProcessMessage() 
	
	
	
		BeginSql Alias "QCRPR130"
			SELECT PERIODO,
			   CODVEND,
			   Max(NOMVEND) NOMVEND,
			   SUM(VALHW) VALHW,
		       SUM(COMHW) COMHW,
		       SUM(VALSW) VALSW,
		       SUM(COMSW) COMSW,
			   SUM(VALPRD) VALPRD,
			   SUM(VALCOM) VALCOM,
			   SUM(CONPED) CONPED FROM (
										SELECT  Z6_PERIODO PERIODO,
												Z6_PEDSITE PEDSITE,
												Z6_PEDGAR PEDGAR,
												Z6_PRODUTO PRODUTO,
										        CASE WHEN Z6_CODENT = '98' THEN '75    ' ELSE Z6_CODENT END CODVEND,
										        CASE WHEN Z6_CODENT = '98' THEN 'Marpe Servicos Contabeis'
										             WHEN Z6_CODENT = '3242' THEN 'NUVEMSIS PARTICIPACOES LTDA'
										        ELSE TRIM(Z6_DESENT) END NOMVEND,
										        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
										        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) COMHW,
										        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
										        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) COMSW,
										        SUM(Z6_VLRPROD) VALPRD,
										        SUM(Z6_VALCOM) VALCOM,
										        CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED
										   FROM %Table:SZ6% SZ6
										      WHERE Z6_FILIAL = ' '
										     AND Z6_PERIODO = %Exp:aRet[1]% 
										     AND Z6_CODENT Between %Exp:AllTrim(aRet[2])% AND %Exp:AllTrim(aRet[3])%
										     AND Z6_TPENTID = '10'
										     AND SZ6.D_E_L_E_T_ = ' '
										   GROUP BY Z6_PERIODO,
										   			Z6_PEDSITE,
													Z6_PEDGAR,
													Z6_PRODUTO,
										            Z6_CODENT,
										            Z6_DESENT
										   UNION
										   SELECT  Z6_PERIODO PERIODO,
													Z6_PEDSITE PEDSITE,
													Z6_PEDGAR PEDGAR,
													Z6_PRODUTO PRODUTO,
		                      						'46' CODVEND,
											    	'CONTROLE DE VENDAS BORTOLIN' NOMVEND,
											    	SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
											        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) COMHW,
											        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
											        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) COMSW,
											    	SUM(Z6_VLRPROD) VALPRD,
											    	SUM(Z6_VALCOM) VALCOM,
											    	CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED
									   		FROM %Table:SZ6% SZ6
									      	WHERE Z6_FILIAL = ' '
									     	AND Z6_PERIODO = %Exp:aRet[1]%
	                       					AND Z6_CODENT IN ('156','2274','46')
									     	AND Z6_TPENTID = '7'
									     	AND SZ6.D_E_L_E_T_ = ' '
											GROUP BY Z6_PERIODO,
											         Z6_PEDSITE,
													 Z6_PEDGAR,
													 Z6_PRODUTO
											UNION
										   SELECT  Z6_PERIODO PERIODO,
													Z6_PEDSITE PEDSITE,
													Z6_PEDGAR PEDGAR,
													Z6_PRODUTO PRODUTO,
		                      						'1158' CODVEND,
											    	'REDE ICP-SEGUROS - MARKETPLACE' NOMVEND,
											    	SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
											        SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) COMHW,
											        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
											        SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) COMSW,
											    	SUM(Z6_VLRPROD) VALPRD,
											    	SUM(Z6_VALCOM) VALCOM,
											    	CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED
									   		FROM %Table:SZ6% SZ6
									      	WHERE Z6_FILIAL = ' '
									     	AND Z6_PERIODO = %Exp:aRet[1]%
	                       					AND Z6_CODAC = 'ICP'
									     	AND Z6_TPENTID = '7'
									     	AND SZ6.D_E_L_E_T_ = ' '
											GROUP BY Z6_PERIODO,
											         Z6_PEDSITE,
													 Z6_PEDGAR,
													 Z6_PRODUTO
			   ) GROUP BY PERIODO, CODVEND
			     ORDER BY PERIODO, CODVEND
			
		EndSql
	
	QCRPR130->(dbGoTop())
	
	While !QCRPR130->(EOF())
	
		MsProcTxt( "Gerando dados do Revendedor: " + QCRPR130->CODVEND)
		ProcessMessage()
		
		dbSelectArea("ZZ6")
		ZZ6->(dbSetOrder(1))
		If ZZ6->(dbSeek(xFilial("ZZ6") + QCRPR130->PERIODO + QCRPR130->CODVEND))
			Processa({|| copiaZZ6()}, "Aguarde", "Aguarde", .T.)
			QCRPR130->(dbSkip())
			Loop
		EndIf
		
		PC2->(DbSetOrder(1))
		If !PC2->(DbSeek(xFilial("PC2")+QCRPR130->PERIODO+QCRPR130->CODVEND))
			If PC2->(RecLock("PC2",.T.))
				PC2->PC2_FILIAL := xFilial("PC2")
				PC2->PC2_PERIOD := QCRPR130->PERIODO
				PC2->PC2_CODAC 	:= " "
				PC2->PC2_CODENT := QCRPR130->CODVEND
				PC2->PC2_DESENT := QCRPR130->NOMVEND
				PC2->PC2_QTDPED := QCRPR130->CONPED 
				PC2->PC2_VALSW  := QCRPR130->VALSW
				PC2->PC2_VALHW  := QCRPR130->VALHW
				PC2->PC2_VALFAT := QCRPR130->VALPRD
				PC2->PC2_COMSW  := 0
				PC2->PC2_COMHW  := 0
				PC2->PC2_COMTOT := 0
				PC2->PC2_CAMPSW := QCRPR130->COMSW
				PC2->PC2_CAMPHW := QCRPR130->COMHW
				PC2->PC2_VALCAM := QCRPR130->VALCOM
				PC2->PC2_DATCAL := dDataBase
				PC2->PC2_ORIGEM := "A" //Geracao Automatica 
				PC2->PC2_SALDO	:= PC2->PC2_COMTOT + PC2->PC2_VALFED + PC2->PC2_VALCAM + PC2->PC2_VALVIS
				PC2->(MsUnlock())
			EndIf
		ElseIf Empty(PC2->PC2_PEDIDO)
			If PC2->(RecLock("PC2",.F.))
				PC2->PC2_QTDPED := QCRPR130->CONPED 
				PC2->PC2_VALSW  := QCRPR130->VALSW
				PC2->PC2_VALHW  := QCRPR130->VALHW
				PC2->PC2_VALFAT := QCRPR130->VALPRD
				PC2->PC2_COMSW  := 0
				PC2->PC2_COMHW  := 0
				PC2->PC2_COMTOT := 0
				PC2->PC2_CAMPSW := QCRPR130->COMSW
				PC2->PC2_CAMPHW := QCRPR130->COMHW
				PC2->PC2_VALCAM := QCRPR130->VALCOM
				PC2->PC2_DATCAL := dDataBase
				PC2->PC2_ORIGEM := "A" //Geracao Automatica
				PC2->PC2_SALDO	:= PC2->PC2_COMTOT + PC2->PC2_VALFED + PC2->PC2_VALCAM + PC2->PC2_VALVIS
				PC2->(MsUnlock())
			EndIf
		EndIf
		
		//Cria Base de Conhecimento
		//U_CRPA031G()
							
		QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo

EndIf

If Select("QCRPR130") > 0
	DbSelectArea("QCRPR130")
	QCRPR130->(DbCloseArea())
EndIf

If AllTrim(aRet[4]) $ "TODAS/AC/CANAL" //"TODAS","POSTO","AC","REVENDEDOR"
	MsProcTxt( "Selecionando Dados das ACs.")
	ProcessMessage() 
	
	//Controle de valores para pedido de origem da campanha.
	//AC BR: Campanha BR e Campanha MarketPlace
	//AC Notarial: Campanha Notarial
	//AC SINCOR: Campanha Sincor
	//AC Sincor Rio: Campanha Sincor RIO
	//Via Internet: Campanha Sincor e Sincor RIO  
	//PP Consultoria: Campanha BR, Notarial e MarketPlace
	
	/*
	CASE
		WHEN SZ6.Z6_CODENT = 'BR' THEN Z6_CODAC IN ('ICP','BR')
		WHEN SZ6.Z6_CODENT = 'NOT' THEN Z6_CODAC = 'NOT'
		WHEN SZ6.Z6_CODENT = 'SIN' THEN Z6_CODAC = 'SIN'
		WHEN SZ6.Z6_CODENT = 'SINRJ' THEN Z6_CODAC = 'SINRJ'
		WHEN SZ6.Z6_CODENT = 'CA0001' THEN Z6_CODAC IN ('SIN','SINRJ')
		WHEN SZ6.Z6_CODENT = 'CA0002' THEN Z6_CODAC IN ('ICP','BR','NOT')
	END */
	
		BeginSql Alias "QCRPR130"
			SELECT PERIODO,
			       Case When TIPENT = '5' Then '2' Else TIPENT End TIPENT,
			       REDE,
			       CODENT,
			       DESENT,
			       CGC,
			       SUM(CONPED) CONPED,
			       SUM(VALHW) VALHW,
			       SUM(COMHW) COMHW,
			       SUM(VALSW) VALSW,
			       SUM(COMSW) COMSW,
			       SUM(VLRABT) VLRABT,
			       SUM(VALPRD) VALPRD,
			       SUM(VALCOM) VALCOM,
             SUM(VALCAMPHW) VALCAMPHW,
             SUM(VALCAMPSW) VALCAMPSW,
			       SUM(VALCAMP) VALCAMP
			FROM
			  (SELECT Z6_PERIODO PERIODO,
			  		  CASE WHEN Z6_TPENTID IN ('2','5') THEN '2' ELSE '1' END TIPENT,
			          ' ' REDE,
			          CASE WHEN (SUM(Z6_VLRPROD) > 0 OR SUM(Z6_VALCOM) > 0) AND MAX(Z6_TIPO) NOT IN ('EXTRA','DESCON') THEN 1 WHEN SUM(Z6_VLRPROD) < 0 THEN -1 ELSE 0 END CONPED,
			          Z6_PEDGAR PEDGAR,
			          Z6_PEDSITE PEDSITE,
			          Z6_PRODUTO PRODUTO,
			          Z3_CODENT CODENT,
			          Z3_DESENT DESENT,
			          Z3_CGC CGC,
			          Z3_CODPAR CODPAR,
			          Z3_CODPAR2 CODPAR2,
			          SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) VALHW,
			          SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' AND Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							WHEN Z6_CATPROD = '2' THEN 0
                      ELSE NULL END) IS NULL THEN Z6_VALCOM ELSE 0 END) COMHW,
			          SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) VALSW,
			          SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' AND Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							WHEN Z6_CATPROD = '1' THEN 0
       						ELSE NULL END) IS NULL THEN Z6_VALCOM ELSE 0 END) COMSW,
			          SUM(Z6_VLRABT) VLRABT,
			          SUM(Z6_VLRPROD) VALPRD,
			          SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							ELSE NULL END) IS NULL THEN Z6_VALCOM ELSE 0 END) VALCOM,
				      SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' AND SZ6.Z6_CATPROD = '2' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							ELSE NULL END) IS NOT NULL THEN Z6_VALCOM ELSE 0 END) VALCAMPSW,
		              SUM(CASE
						  WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' AND SZ6.Z6_CATPROD = '1' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							ELSE NULL END) IS NOT NULL THEN Z6_VALCOM ELSE 0 END) VALCAMPHW,
		              SUM(CASE
			              WHEN
			              (CASE
							WHEN SZ6.Z6_CODENT = 'BR' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'NOT' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'NOT' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SIN' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SIN' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'SINRJ' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC = 'SINRJ' AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0001' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('SIN','SINRJ') AND D_E_L_E_T_ = ' ')
							WHEN SZ6.Z6_CODENT = 'CA0002' THEN (SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PEDGAR = SZ6.Z6_PEDGAR AND Z6_TPENTID = '7' AND Z6_CODAC IN ('ICP','BR','NOT') AND D_E_L_E_T_ = ' ')
							ELSE NULL END) IS NOT NULL THEN Z6_VALCOM ELSE 0 END) VALCAMP
			   FROM SZ6010 SZ6
			   LEFT JOIN SZ3010 SZ3 ON Z3_FILIAL = ' '
			   AND Z3_TIPENT = Z6_TPENTID
			   AND Z3_CODENT = Z6_CODENT
			   AND SZ3.D_E_L_E_T_ = ' '
			   WHERE Z6_FILIAL = ' '
			   	 AND Z3_TIPCOM != '2'
			     AND Z6_CODENT != 'NAOREM' 
			     AND Z6_CODENT != 'TDARED' 
			     AND Z6_CODENT != 'CRD'
			     AND Substr(Z6_CODENT,1,4) != 'FECO'
			     AND Z6_CODENT != 'CER'
			     AND Z6_PERIODO = %Exp:aRet[1]%
			     AND Z6_CODENT Between %Exp:aRet[2]% AND %Exp:aRet[3]%
			     AND Z6_TPENTID IN ('1','2','5')
			     AND SZ6.D_E_L_E_T_ = ' '
			   GROUP BY Z6_PERIODO,
			   			Z6_TPENTID,
			            Z6_CODAC,
			            Z6_PEDGAR,
			            Z6_PEDSITE,
			            Z6_PRODUTO,
			            Z3_CODENT,
			            Z3_DESENT,
			            Z3_CGC,
			            Z3_CODPAR,
			            Z3_CODPAR2
			   ORDER BY Z6_PERIODO,
						Z6_TPENTID,
			            Z3_CODENT,
			            Z3_DESENT,
			            Z3_CGC)
			GROUP BY PERIODO,
			         TIPENT,
			         REDE,
			         CODENT,
			         DESENT,
			         CGC
			ORDER BY PERIODO,
			         TIPENT,
			         CODENT,
			         DESENT
		EndSql
	
	QCRPR130->(dbGoTop())
	
	While !QCRPR130->(EOF())
	
		nValVis	 := 0
		
		dbSelectArea("ZZ6")
		ZZ6->(dbSetOrder(1))
		If ZZ6->(dbSeek(xFilial("ZZ6") + QCRPR130->PERIODO + QCRPR130->CODENT))
			Processa({|| copiaZZ6()}, "Aguarde", "Aguarde", .T.)
			QCRPR130->(dbSkip())
			Loop
		EndIf
	
		If AllTrim(QCRPR130->CODENT) $ "SINRJ/SIN/NOT/BR"
		    
			//AJUSTA CODIGO DE PARCEIROS PARA BUSCAR NA SZ6
			If Select("QCRPR132") > 0
				QCRPR132->(DbCloseArea())
			EndIf
			
			BeginSql Alias "QCRPR132"
			SELECT  Z3_CODPAR,Z3_CODPAR2
				FROM %Table:SZ3% SZ3 
				WHERE
				Z3_FILIAL = ' ' AND
				Z3_TIPENT = '9' AND
				Z3_CODAC = %Exp:AllTrim(QCRPR130->CODENT)% AND
				Z3_ATIVO = 'N' AND
				SZ3.D_E_L_E_T_ = ' '
				GROUP BY Z3_CODPAR,Z3_CODPAR2
			EndSql
			
			//ZERA CONTEUDO DA VARIAVEL
			cCodPar := ""
			
			While !QCRPR132->(EOF())
				
				If !Empty(QCRPR132->Z3_CODPAR)
					cCodPar := Iif(!Empty(cCodPar),cCodPar+","+AllTrim(QCRPR132->Z3_CODPAR),AllTrim(QCRPR132->Z3_CODPAR)) +;
					 		   Iif(!Empty(QCRPR132->Z3_CODPAR2),","+AllTrim(QCRPR132->Z3_CODPAR2),"") 
				EndIf
				
				QCRPR132->(DbSkip())
			EndDo
			
			//Formata Para query
			cCodPar := "% " + FormatIn(cCodPar,",") + " %"
			
		    //Busca valor das AR's descredenciadas.
			If Select("QCRPR131") > 0
				QCRPR131->(DbCloseArea())
			EndIf
			
			BeginSql Alias "QCRPR131"
							
				SELECT 	SUM(VALDESC)  VALDESC,
						SUM(VALDESCS)  VALDESCS,
						SUM(VALDESCH)  VALDESCH,
						MAX(CAMPANHASW) CAMPANHASW,
						MAX(CAMPANHAHW) CAMPANHAHW,
	              		MAX(CAMPANHA) CAMPANHA FROM (
										      SELECT  Z3_CODENT CODENT,
										              SUM(Z6_VALCOM) VALDESC,
										              SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) VALDESCS,
										              SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) VALDESCH,
										              MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:aRet[1]% AND D_E_L_E_T_ = ' ' AND Z6_TPENTID = '7'  AND Z6_CATPROD = '2' AND Z6_CODENT IN %Exp:cCodPar% )) CAMPANHASW,
										              MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:aRet[1]% AND D_E_L_E_T_ = ' ' AND Z6_TPENTID = '7'  AND Z6_CATPROD = '1' AND Z6_CODENT IN %Exp:cCodPar% )) CAMPANHAHW,
													  MAX((SELECT SUM(Z6_VALCOM) FROM %Table:SZ6% WHERE Z6_FILIAL = ' ' AND Z6_PERIODO = %Exp:aRet[1]% AND D_E_L_E_T_ = ' ' AND Z6_TPENTID = '7' AND Z6_CODENT  IN %Exp:cCodPar% )) CAMPANHA
													FROM %Table:SZ3% SZ3 
													JOIN %Table:SZ6% SZ6
													ON Z6_FILIAL = ' '
													AND Z6_PERIODO = %Exp:QCRPR130->PERIODO%
													AND Z6_TPENTID = '4'
													AND Z6_CODAC = %Exp:AllTrim(QCRPR130->CODENT)%
													AND Z3_CODENT = Z6_CODCCR
													AND SZ6.D_E_L_E_T_ = ' '
													WHERE
													Z3_FILIAL = ' ' AND
													Z3_TIPENT = '9' AND
													Z3_ATIVO = 'N' AND
													SZ3.D_E_L_E_T_ = ' '
										      GROUP BY Z3_CODENT)	
				
			EndSql
			
			DbSelectArea("QCRPR131")
			QCRPR131->(DbGoTop())
		ElseIf AllTrim(QCRPR130->CODENT) $ "FEN"
		
			//Busca valores dos postos fenacon
		
			If Select("QCRPR131") > 0
				QCRPR131->(DbCloseArea())
			EndIf
			
			BeginSql Alias "QCRPR131"
				SELECT 	SUM(Z6_VALCOM) VALDESC, 
						SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VALCOM ELSE 0 END) VALDESCS,
 		                SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VALCOM ELSE 0 END) VALDESCH
				FROM %Table:SZ6% SZ6
				WHERE Z6_FILIAL = ' '
				AND Z6_PERIODO = %Exp:QCRPR130->PERIODO%
				AND Z6_TPENTID = '4'
				AND Z6_CODCCR = '054615'
				AND SZ6.D_E_L_E_T_ = ' '	
			EndSql
			
			DbSelectArea("QCRPR131")
			QCRPR131->(DbGoTop())
			
			//Renato Ruy - 20/03/2018
			//Buscar visita externa para remunerar na AC
			BeginSql Alias "TMPVIS"
				SELECT 	SUM(Z6_VALCOM) VALVIS
				FROM %Table:SZ6% SZ6
				WHERE Z6_FILIAL = ' '
				AND Z6_PERIODO = %Exp:QCRPR130->PERIODO%
				AND Z6_TPENTID = 'B'
				AND Z6_CODCCR = '054615'
				AND SZ6.D_E_L_E_T_ = ' '	
			EndSql
			nValVis := TMPVIS->VALVIS
			TMPVIS->(DbCloseArea())
		EndIf
	
		MsProcTxt( "Gerando Registros da Entidade: " + QCRPR130->CODENT)
		ProcessMessage()
		
		PC2->(DbSetOrder(1))
		If !PC2->(DbSeek(xFilial("PC2")+QCRPR130->PERIODO+QCRPR130->CODENT))
			If PC2->(RecLock("PC2",.T.))
				PC2->PC2_FILIAL := xFilial("PC2")
				PC2->PC2_PERIOD := QCRPR130->PERIODO
				PC2->PC2_CODAC 	:= QCRPR130->REDE
				PC2->PC2_CODENT := QCRPR130->CODENT
				PC2->PC2_DESENT := QCRPR130->DESENT
				PC2->PC2_QTDPED := QCRPR130->CONPED
				PC2->PC2_VALSW  := QCRPR130->VALSW
				PC2->PC2_VALHW  := QCRPR130->VALHW
				PC2->PC2_VALFAT := QCRPR130->VALPRD
				PC2->PC2_COMSW  := QCRPR130->COMSW
				PC2->PC2_COMHW  := QCRPR130->COMHW
				PC2->PC2_COMTOT := QCRPR130->VALCOM 
				PC2->PC2_CAMPSW := QCRPR130->VALCAMPSW + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHASW,0)
				PC2->PC2_CAMPHW := QCRPR130->VALCAMPHW + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHAHW,0)
				PC2->PC2_VALCAM := QCRPR130->VALCAMP + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHA,0) 
				PC2->PC2_POSSW 	:= Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESCS,0)
				PC2->PC2_POSHW 	:= Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESCH,0)
				PC2->PC2_VALPOS := Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESC,0)
				PC2->PC2_VALVIS := nValVis
				PC2->PC2_DATCAL := dDataBase
				PC2->PC2_ORIGEM := "A" //Geracao Automatica
				PC2->PC2_SALDO	:= PC2->PC2_COMTOT + PC2->PC2_VALFED + PC2->PC2_VALCAM + PC2->PC2_VALVIS+PC2->PC2_VALPOS
				PC2->(MsUnlock())
			EndIf
		ElseIf Empty(PC2->PC2_PEDIDO)
			If PC2->(RecLock("PC2",.F.))
				PC2->PC2_QTDPED := QCRPR130->CONPED
				PC2->PC2_VALSW  := QCRPR130->VALSW
				PC2->PC2_VALHW  := QCRPR130->VALHW
				PC2->PC2_VALFAT := QCRPR130->VALPRD
				PC2->PC2_COMSW  := QCRPR130->COMSW
				PC2->PC2_COMHW  := QCRPR130->COMHW
				PC2->PC2_COMTOT := QCRPR130->VALCOM 
				PC2->PC2_CAMPSW := QCRPR130->VALCAMPSW + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHASW,0)
				PC2->PC2_CAMPHW := QCRPR130->VALCAMPHW + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHAHW,0)
				PC2->PC2_VALCAM := QCRPR130->VALCAMP + Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR",QCRPR131->CAMPANHA,0) 
				PC2->PC2_POSSW 	:= Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESCS,0)
				PC2->PC2_POSHW 	:= Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESCH,0)
				PC2->PC2_VALPOS := Iif(AllTrim(QCRPR130->CODENT) $ "SIN/NOT/BR/FEN",QCRPR131->VALDESC,0)
				PC2->PC2_DATCAL := dDataBase
				PC2->PC2_VALVIS := nValVis
				PC2->PC2_ORIGEM := "A" //Geracao Automatica
				PC2->PC2_SALDO	:= PC2->PC2_COMTOT + PC2->PC2_VALFED + PC2->PC2_VALCAM + PC2->PC2_VALVIS+PC2->PC2_VALPOS
				PC2->(MsUnlock())
			EndIf
		EndIf
		
		//Cria Base de Conhecimento
		//U_CRPA031G()
							
		QCRPR130->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	EndDo
EndIf
	
Return


Static Function copiaZZ6()

Local nCount := ZZ6->(FCount())
Local Ni 	 := 0
Local cCampo := "" 

ProcRegua(nCount)

RecLock("PC2",.T.)
	For Ni := 1 To nCount
		IncProc("Gravando Registro " + ZZ6->ZZ6_CODENT + " - " + ZZ6->ZZ6_DESENT)
		ProcessMessage()
		
		cCampo := ZZ6->(FieldName(Ni))
		cCampo := AllTrim(Substr(cCampo,at("_",cCampo) + 1))
		
		&("PC2->PC2_" + cCampo) := ZZ6->(FieldGet(Ni))  
		//PC2->(FieldPut(Ni, ZZ6->(FieldGet(Ni))))
	Next
PC2->(MsUnlock())

Return