#INCLUDE "PROTHEUS.CH"     

Class CTSDK13 From HelpDeskHist
Data tipHistory

Method New() Constructor 
Method Find(oRelBrowse, aFields) 
EndClass 
         

Method new() Class CTSDK13 
_Super:New()

Return Self  

Method Find(oRelBrowse, aFields) Class CTSDK13 
Local cQuery := ""  
Local aArea := GetArea()
Local cWhere		:= ""
Local cCodContact	:= ""						//Codigo do contato
Local cEntityName	:= ""  						//Nome da Entidade 
										
Default aFields := {}

Self:cKeyWords := AllTrim(Self:cKeyWords)

If Self:tipHistory == 1
	cCodContact	:= M->ADE_CODCON											
	cEntityName	:= M->ADE_ENTIDA	
EndIf

If Empty(cCodContact) .AND. Self:tipHistory == 1
	MsgAlert("Por favor","Selecione um Contato") //"Por favor, selecione um contato"###"Atencao"
	Return(.F.)
Else

	Self:lFinding 	:= .T.
	DbSelectArea("ADE")
	DbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pergunte - TMK510H                                                            ³
	//³MV_PAR01 - De                                                        		 ³
	//³MV_PAR02 - Ate                                                                ³
	//³MV_PAR03 - Do Chamado                                                         ³
	//³MV_PAR04 - Ate o chamado                                                      ³
	//³MV_PAR05 - Status do chamado                                                  ³
	//³MV_PAR06 - Exibir histórico de ?                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pergunte - TMK510HI                                                           ³
	//³MV_PAR01 - De                                                        		 ³
	//³MV_PAR02 - Ate                                                                ³
	//³MV_PAR03 - Do Chamado                                                         ³
	//³MV_PAR04 - Ate o chamado                                                      ³
	//³MV_PAR05 - Status do chamado                                                  ³
	//³MV_PAR06 - Do Cliente                                                         ³
	//³MV_PAR07 - Da Loja                                                            ³	
	//³MV_PAR08 - Ate o Cliente                                                      ³
	//³MV_PAR09 - Ate a Loja                                                         ³
	//³MV_PAR11 - Incidente 	                                                     ³
	//³MV_PAR11 - Cpf Titular (Personalizado Certisign)                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		

	If ValType(MV_PAR05) == "N"
		MV_PAR05 := cValToChar(MV_PAR05)
	EndIf
	If ValType(MV_PAR06) == "N"
		MV_PAR06 := cValToChar(MV_PAR06)
	EndIf
	
	#IFDEF TOP		
		cQuery := "	SELECT "		
		cQuery += "	ADE.ADE_FILIAL,	ADE.ADE_CODSB1,	ADE.ADE_ENTIDA,		ADE.ADE_CHAVE, "
		cQuery += "	ADE.ADE_CODIGO,	ADE.ADE_DATA,	ADE.ADE_SEVCOD,		ADE.ADE_CODINC, "
		cQuery += "	ADE.ADE_DATA,	ADE.ADE_STATUS,	ADE.ADE_DTEXPI,		ADE.ADE_OPERAD  "
		cQuery += "	FROM " + RetSQLName("ADE") + " ADE"
		
		If !Empty(Self:cKeyWords)
			cQuery += " INNER JOIN " + RetSQLName("SYP") + " SYP ON ADE.ADE_CODINC = SYP.YP_CHAVE AND SYP.D_E_L_E_T_ = ''"
		EndIf		
		
		cWhere += "	WHERE ADE.ADE_FILIAL = '" + xFilial("ADE") + "' AND" 

		cWhere += "	ADE.ADE_DATA BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' AND"		
		cWhere += " ADE.ADE_CODIGO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND"				
		
		If Val(MV_PAR05) < 4                                              
			cWhere += " ADE.ADE_STATUS = '" + AllTrim(MV_PAR05) + "' AND"					
		EndIf
		
		If !Empty(Self:cProduto)
			cWhere += "	ADE.ADE_CODSB1 = '" + Self:cProduto + "' AND"
		EndIf

		If !Empty(Self:cGroup)
			cWhere += "	ADE.ADE_GRUPO = '" + Self:cGroup + "' AND"
		EndIf	

		If Self:tipHistory == 1
			If Val(MV_PAR06) == 1 //Contato
				cWhere += " ADE.ADE_CODCON = '" + M->ADE_CODCON + "' AND"
			ElseIf Val(MV_PAR06) == 2	//Entidade                       
				cWhere += " ADE.ADE_ENTIDA = '" + M->ADE_ENTIDA + "' AND"		
				cWhere += " ADE.ADE_CHAVE  = '" + M->ADE_CHAVE + "' AND"			
			EndIf   
		Else
			cWhere += " ADE.ADE_CHAVE  BETWEEN '" + MV_PAR06+MV_PAR07 + "' AND '" + MV_PAR08+MV_PAR09 + "' AND"			
			If !Empty(MV_PAR11)
				cWhere += " ADE.ADE_XCPFTI = '" + Alltrim(MV_PAR11) + "' AND "			
			EndIf
		EndIf
		
		If !Empty(Self:cKeyWords)
			cWhere += " SYP.YP_FILIAL = '"+xFilial("SYP")+"' AND (UPPER(SYP.YP_TEXTO) LIKE '%" + Upper(Self:cKeyWords) + "%' OR UPPER(ADE.ADE_PLVCHV) LIKE '%" + Upper(Self:cKeyWords) + "%') AND"
		EndIf
	
		cWhere += "	ADE.D_E_L_E_T_<>'*'"  
		cQuery += cWhere		
		cQuery += "	ORDER BY " + SqlOrder(IndexKey())
		
		cQuery := ChangeQuery(cQuery)
	
		DbSelectArea("ADE")
		DbCloseArea()
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "ADE", .F., .T.)			
		
		TCSetField("ADE", "ADE_DTEXPI"	, "D")
		TCSetField("ADE", "ADE_DATA"	, "D")				
	#ELSE       
		DbSelectArea("ADE")
		DbSetOrder(3) //ADE_FILIAL+ ADE_GRUPO		
		DbSeek(xFilial("ADE")+Self:cPosto)	
		nTot := RecCount()
	#ENDIF
	                 
	IncProc("Criando lista de Chamados") // "Criando lista de chamados..."	        
	Self:FillData("ADE", @aFields, @oRelBrowse)
			                            	
	DbSelectArea("ADE")
	DbCloseArea()	
	
	Self:lFinding 	:= .F.
	Self:lStop		:= .F.                      
	
	RestArea(aArea)
EndIf
Return Nil          

User Function CTSDK13H(lViewOnly)
 
Local oObj := Nil

SaveInter()

oObj := CTSDK13():New()
                      
If Type("aCols")=="U"
	Private aCols := {}
EndIf

If Type("aHeader")=="U"
	Private aHeader := {}
EndIf

Default lViewOnly := .T.

oObj:lViewOnly := lViewOnly 
oObj:tipHistory	:= 2
oObj:showDialog()
                
RestInter()

Return .F.  