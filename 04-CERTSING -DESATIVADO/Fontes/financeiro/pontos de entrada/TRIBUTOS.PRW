/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TRIBUTOS º Autor ³			         ºData  ³  06/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criar a string com dados para pagamento de     º±±
±±º          ³ tributos sem código de barras                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KDL		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
USER FUNCTION TRIBUTOS()
	LOCAL cString1	:=""
	LOCAL cString2	:=""
	LOCAL cString3	:=""
	LOCAL cString4	:=""
	LOCAL cString5	:=""
	LOCAL cTributo1 := AllTrim( SE2->E2_XGPS01  )
	LOCAL cTributo2 := AllTrim( SE2->E2_XDARF01 )
	LOCAL cTributo3 := AllTrim( SE2->E2_XGARE01 ) 
	LOCAL cTributo4 := AllTrim( SE2->E2_XIPVA01 )
	LOCAL cTributo5 := AllTrim( SE2->E2_XFGTS01 )
	IF !Empty(cTributo1) .AND. cTributo1 =='01'
			cString1 :=  U_DADOSGPS()
			return(cString1)
	ELSEIF !Empty(cTributo2) .AND. cTributo2 =='02'
			cString2 := U_DADOSDARF()
			return(cString2)	
	ELSEIF !Empty(cTributo3) .AND. cTributo3 =='05'
			cString3 := U_DADOSGARE()
			return(cString3) 
	ELSEIF !Empty(cTributo4) .AND. cTributo4 =='07' .OR. cTributo4 =='08'
			cString4 := U_DADOSIPVA()
			return(cString4)
	ELSEIF !Empty(cTributo5) .AND. cTributo5 =='11'	
			cString5 := U_DADOSFGTS()
			return(cString5)
	ENDIF
Return(Space(178))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DADOSGPS º Autor ³                    ºData  ³  06/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criar a string com dados para pagamento de GPS º±±
±±º          ³ sem código de barras                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KDL		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION DADOSGPS()
	Local cRetGPS  := ""
	cRetGPS := SUBSTR(Alltrim(SE2->E2_XGPS01),1,2 )		// IDENTIFICACAO DO TRIBUTO (2)
	cRetGPS += SUBSTR(Alltrim(SE2->E2_XGPS02),1,4 )		// CODIGO DE PAGTO (4)
	cRetGPS += SUBSTR(Alltrim(SE2->E2_XGPS03),1,6 )		// COMPETENCIA (6)
	cRetGPS += SUBSTR(Alltrim(SE2->E2_XGPS04),1,14)		// INSCRICAO NUMERO - CNPJ OU CPF (14)
	cRetGPS += STRZERO((SE2->E2_XGPS05)*100,14)			// VALOR PREVISTO DO PAGAMENTO DO INSS (14)
	cRetGPS += STRZERO((SE2->E2_XGPS06)*100,14)		    //  VALOR DE OUTRAS ENTIDADES (14)
	cRetGPS += STRZERO((SE2->E2_MULTA + SE2->E2_JUROS )*100,14)		//VALOR DA MULTA + JUROS + ATM(14)
	cRetGPS += STRZERO(((SE2->E2_VALOR + SE2->E2_MULTA + SE2->E2_JUROS + SE2->E2_SDACRES )-(SE2->E2_DESCONT + SE2->E2_SDDECRE))*100,14)  //VALOR TOTAL (14)
	cRetGPS += GRAVADATA(SE2->E2_VENCREA,.F.,5)			//DATA PAGAMENTO (8)
	cRetGPS += SPACE(08)								//COMPLEMENTO DO REGISTRO
	cRetGPS += SPACE(50)								//INFORMAÇÕES COMPLEMENTARES (50)
	cRetGPS += SUBSTR(SM0->M0_NOME,1,30)				     //NOME DO CONTRIBUINTE (30)
Return(cRetGPS)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DADOSDARF º Autor ³                   ºData  ³  06/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criar a string com dados para pagamento de DARFº±±
±±º          ³ sem código de barras                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KDL		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION DADOSDARF()
Local cRetDARF  := ""
	cRetDARF := SUBSTR(Alltrim(SE2->E2_XDARF01),1,2)		// IDENTIFICACAO DO TRIBUTO (02)
	cRetDARF += SUBSTR(Alltrim(SE2->E2_XDARF02),1,4)		// CODIGO DA RECEITA (04)
	cRetDARF += "2"											//TIPO DE INSCRICAO DO CONTRIBUINTE 1=CPF, 2=CNPJ  (1)
	cRetDARF += SUBSTR(SM0->M0_CGC,1,14)					//INSCRICAO NUMERO - CNPJ OU CPF (14)
	cRetDARF += GRAVADATA(SE2->E2_XDARF03,.F.,5)			//PERIODO DE APURACAO (8)       
	cRetDARF += IIF(Empty(SE2->E2_XDARF04),SPACE(17),(SUBST(Alltrim(SE2->E2_XDARF04),1,17)))//NUMERO DE REFERENCIA (17)
	cRetDARF += STRZERO((SE2->E2_VALOR)*100,14)				//VALOR PRINCIPAL (14)
	cRetDARF += STRZERO((SE2->E2_MULTA)*100,14)				//VALOR DA MULTA (14)
	cRetDARF += STRZERO((SE2->E2_JUROS + SE2->E2_SDACRES)*100,14)//VALOR DOS JUROS/ENCARGOS (14)
	cRetDARF += STRZERO(((SE2->E2_VALOR + SE2->E2_MULTA + SE2->E2_JUROS + SE2->E2_SDACRES )-(SE2->E2_DESCONT + SE2->E2_SDDECRE))*100,14)//VALOR TOTAL (14)
	cRetDARF += GRAVADATA(SE2->E2_VENCTO,.F.,5)				//DATA VENCIMENTO (8)
	cRetDARF += GRAVADATA(SE2->E2_VENCREA,.F.,5)		    //DATA PAGAMENTO (8)
	cRetDARF += SPACE(30)									//BRANCOS (30)
	cRetDARF += SUBSTR(SM0->M0_NOME,1,30)					//NOME DO CONTRIBUINTE (30)
Return(cRetDARF)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DADOSGARE º Autor ³                   ºData  ³  06/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criar a string com dados para pagamento de GAREº±±
±±º          ³ sem código de barras                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KDL		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION DADOSGARE()
	Local cRetGARE  := ""
	cRetGARE := SUBSTR(Alltrim(SE2->E2_XGARE01),1,2)	//IDENTIFICACAO DO TRIBUTO (02)
	cRetGARE += SUBSTR(Alltrim(SE2->E2_XGARE02),1,4)	//CODIGO DA RECEITA (04)
	cRetGARE += "1"					   			//TIPO DE INSCRICAO DO CONTRIBUINTE 1=CNPJ, 2=CEI  (01)
	cRetGARE += SUBSTR(SM0->M0_CGC,1,14)				//INSCRICAO NUMERO - CNPJ OU CPF (14)
	cRetGARE += SUBSTR(SM0->M0_INSC,1,12)			//INSCRICAO ESTADUAL - CNPJ OU CPF (12)
	cRetGARE += STRZERO(0,13)						//BRANCOS (13)
	cRetGARE += SUBSTR(Alltrim(SE2->E2_XGARE03),1,6)	//REFERENCIA (06)
	cRetGARE += STRZERO(0,13)						//BRANCOS (13)
	cRetGARE += STRZERO((SE2->E2_VALOR)*100,14)		//VALOR RECEITA (14)
	cRetGARE += STRZERO((SE2->E2_JUROS + SE2->E2_SDACRES)*100,14)//VALOR DOS JUROS/ENCARGOS (14)
	cRetGARE += STRZERO((SE2->E2_MULTA)*100,14)		//VALOR DA MULTA (14)
	cRetGARE += STRZERO(((SE2->E2_VALOR + SE2->E2_MULTA + SE2->E2_JUROS + SE2->E2_SDACRES )-(SE2->E2_DESCONT + SE2->E2_SDDECRE))*100,14)//VALOR DO PAGAMENTO (14)
	cRetGARE += GRAVADATA(SE2->E2_VENCTO,.F.,5)		//DATA VENCIMENTO (8)
	cRetGARE += GRAVADATA(SE2->E2_VENCREA,.F.,5)		//DATA PAGAMENTO (8)
	cRetGARE += SPACE(11)							//BRANCOS (11)
	cRetGARE += SUBSTR(SM0->M0_NOME,1,30)			//NOME DO CONTRIBUINTE (30)
Return(cRetGARE)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DADOSIPVA º Autor ³                   ºData  ³  22/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criar a string com dados para pagamento de IPVAº±±
±±º          ³ sem código de barras                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KDL		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION DADOSIPVA()
Local cRetIPVA  := ""
	//POSICIONA NO FORNECEDOR
	//=======================
	SA2->(DBSETORDER(01))
	SA2->(DBSEEK(xFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA)))
	cRetIPVA := SUBSTR(Alltrim(SE2->E2_XIPVA01),1,2)											//IDENTIFICACAO DO TRIBUTO (02)
	cRetIPVA += SPACE(04)																		// BRANCOS
	cRetIPVA += IIF(SA2->A2_TIPO == "J", "2", "1")         										// TIPO DE INSCRIÇÃO DO CONTRIBUINTE (1-CPF / 2-CNPJ) 
	cRetIPVA += STRZERO(VAL(SA2->A2_CGC),14)                									// CPF OU CNPJ DO CONTRIBUINTE
	cRetIPVA += SUBSTR(DTOS(dDATABASE),1,4)	            										// ANO BASE
	cRetIPVA += PADR(SE2->E2_XIPVA02,09)//E2_XRENAVA                    						// CODIGO RENEVAN
	cRetIPVA += SE2->E2_XIPVA03 //E2_XUFRENA													// UF RENEVAN
	cRetIPVA += IIF(EMPTY(SE2->E2_XIPVA04),PADR(SA2->A2_COD_MUN,05),PADR(SE2->E2_XIPVA04,05))	// COD.MUNICIPIO RENEVAN  -SE2->E2_XMUNREN
	cRetIPVA += PADR(SE2->E2_XIPVA05,07)//SE2->E2_XPLACA				     					// PLACA DO VEICULO
	cRetIPVA += SE2->E2_XIPVA06	//E2_XOPCPAG													// OPCAO DE PAGAMENTO
	cRetIPVA += STRZERO(INT((SE2->E2_SALDO+SE2->E2_ACRESC)*100),14)     						// VALOR DO IPVA + MULTA + JUROS
	cRetIPVA += STRZERO(INT(SE2->E2_DECRESC*100),14)											// VALOR DO DESCONTO
	cRetIPVA += STRZERO(INT(((SE2->E2_SALDO+SE2->E2_ACRESC)-SE2->E2_DECRESC)*100),14)			// VALOR DO PAGAMENTO
	cRetIPVA += GRAVADATA(SE2->E2_VENCREA,.F.,5) 												// DATA DE VENCIMENTO
	cRetIPVA += GRAVADATA(SE2->E2_VENCREA,.F.,5) 												// DATA DE PAGAMENTO 
	cRetIPVA += SPACE(41) 								                       					// COMPLEMENTO DE REGISTRO                           
	cRetIPVA += SUBSTR(SA2->A2_NOME,1,30)								            			// NOME DO CONTRIBUINTE 	
 Return(cRetIPVA)                    	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DADOSFGTS º Autor ³                   ºData  ³  22/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criar a string com dados para pagamento de FGTSº±±
±±º          ³ sem código de barras                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KDL		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION DADOSFGTS()
Local  cRetFGST :=""                 	
	cRetFGST := SUBSTR(Alltrim(SE2->E2_XFGTS01),1,2)		// IDENTIFICACAO DO TRIBUTO (02)"11"            	                            
	cRetFGST += SubStr(SE2->E2_XFGTS02,1,4)				// Código da Receita
	cRetFGST += "1"									// TIPO DE INSCRIÇÃO DO CONTRIBUINTE (1-CNPJ / 2-CEI) 
	cRetFGST += StrZero(Val(SM0->M0_CGC),14)            	// CPF OU CNPJ DO CONTRIBUINTE 
	cRetFGST += PADR(AllTrim(SE2->E2_XFGTS03),48, ' ')     // CODIGO DE BARRAS (LINHA DIGITAVEL)	(*criar campo*) 
	cRetFGST += SUBSTR(SE2->E2_XFGTS04,1,16) 			// Identificador FGTS 
	cRetFGST += StrZero(Val(SE2->E2_XFGTS05),9)   		// Lacre de Conectividade Social 
	cRetFGST += StrZero(Val(SE2->E2_XFGTS06),2)  			// Digito do Lacre  
	cRetFGST += SubStr(SM0->M0_NOMECOM,1,30)               // NOME DO CONTRIBUINTE
	cRetFGST += GravaData(SE2->E2_VENCREA,.F.,5)           // DATA DO PAGAMENTO 
	cRetFGST += StrZero(SE2->E2_SALDO*100,14)             	// VALOR DO PAGAMENTO 
	cRetFGST += Space(30)                                  // COMPLEMENTO DE REGISTRO 
Return(cRetFGST)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SOMAJM    º Autor ³                   ºData  ³  22/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criar a string com dados de juros e multa      º±±
±±º          ³  					                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KDL		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION SOMAJM()
	Local cReturn  := "" 
	Local nValcamp  := 0
	nValcamp := (SE2->E2_MULTA + SE2->E2_JUROS + SE2->E2_SDACRES) 
	cReturn += STRZERO(nValCamp*100,14) 
Return(cReturn)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SOMATOTAL º Autor ³                   ºData  ³  22/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criar a string com dados de valor total        º±±
±±º          ³  					                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ KDL		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION SOMATOTAL()
	Local cReturn := ""
	Local nTotal  := SomaValor() 
	//cReturn := STRZERO(((SE2->E2_VALOR + SE2->E2_MULTA + SE2->E2_JUROS + SE2->E2_SDACRES )-(SE2->E2_DESCONT + SE2->E2_SDDECRE))*100,14)
	cReturn := StrZero( nTotal, 14 )  
Return(cReturn)
//---------------------------------------------------------------------------------
// Rotina | AGCONTA    | Autor | Rafael Beghini            | Data | 30/07/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para a string com dados da Agencia e Conta do Favorecido.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function AGCONTA()
	Local cRetConta := ''
	Local cBanco    := Alltrim(SA2->A2_BANCO)
	
	IF cBanco == '341' //Itau
		cRetConta := '0'
		cRetConta += Alltrim(Substr(SA2->A2_AGENCIA,1,4))
		cRetConta += ' '
		cRetConta += '000000'
		cRetConta += PADL(Alltrim(SA2->A2_NUMCON), 6, '0')
		cRetConta += ' '
		cRetConta += Substr(SA2->A2_DGCTAC,1,1)    
	Else
		cRetConta += PADL(Alltrim(SA2->A2_AGENCIA), 5, '0')
		cRetConta += ' '
		cRetConta += PADL(Alltrim(SA2->A2_NUMCON), 12, '0')
		cRetConta += ' '
		cRetConta += Substr(SA2->A2_DGCTAC,1,1)
	EndIF
Return(cRetConta)

//---------------------------------------------------------------------------------
// Rotina | CODBARRA    | Autor | Rafael Beghini            | Data | 12/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para alterar o código de barras quando digitado.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CODBARRA()
	Local cStr := LTRIM( RTRIM( M->E2_CODBAR ) )

	IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
		// Se o Campo está em Branco não Converte nada.
		cStr := ""
	ELSE
		//Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
		//necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
		cStr := IF( LEN(cStr)<44 , cStr + REPL( "0", 47 - LEN(cStr) ), cStr )
	ENDIF
	
	IF Len(cStr) == 47
		cStr := SUBSTR(cStr,1,4) + SUBSTR(cStr,33,15) + SUBSTR(cStr,5,5) + SUBSTR(cStr,11,10) + SUBSTR(cStr,22,10)
	ElseIF LEN(cStr) == 48
		cStr := SUBSTR(cStr,1,11) + SUBSTR(cStr,13,11) + SUBSTR(cStr,25,11) + SUBSTR(cStr,37,11)
	Else
		cStr := cStr + SPACE( 48 - Len(cStr) )
	EndIF
Return(cStr)

//---------------------------------------------------------------------------------
// Rotina | CBARRAFG    | Autor | Rafael Beghini            | Data | 12/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para alterar o código de barras quando digitado.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CBARRAFG()
	Local cStr := LTRIM( RTRIM( M->E2_XFGTS03 ) )

	IF VALTYPE(M->E2_XFGTS03) == NIL .OR. EMPTY(M->E2_XFGTS03)
		// Se o Campo está em Branco não Converte nada.
		cStr := ""
	ELSE
		//Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
		//necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
		cStr := IF( LEN(cStr)<44 , cStr + REPL( "0", 47 - LEN(cStr) ), cStr )
	ENDIF
	
	IF Len(cStr) == 47
		cStr := SUBSTR(cStr,1,4) + SUBSTR(cStr,33,15) + SUBSTR(cStr,5,5) + SUBSTR(cStr,11,10) + SUBSTR(cStr,22,10)
	ElseIF LEN(cStr) == 48
		cStr := SUBSTR(cStr,1,11) + SUBSTR(cStr,13,11) + SUBSTR(cStr,25,11) + SUBSTR(cStr,37,11)
	Else
		cStr := cStr + SPACE( 48 - Len(cStr) )
	EndIF
Return(cStr)

//---------------------------------------------------------------------------------
// Rotina | CODGNRE    | Autor | Rafael Beghini            | Data | 13/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para a string Nota fiscal GNRE
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CODGNRE()
	Local cNum := Alltrim( SE2->E2_NUM )
	Local cStr := ''

	IF .NOT. EMPTY( SE2->E2_XGNRE01 ) .AND. SE2->E2_XGNRE01 == '100099'
		cStr := PADL(cNum, 9, '0')
	Else
		cStr = '000000000'
	EndIF
Return(cStr)
