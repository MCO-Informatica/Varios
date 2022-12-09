//-----------------------------------------------------------------------
// Rotina | FT300VLD   | Autor | Robson Gonçalves     | Data | 26.05.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada executado no TudoOk da Oportunidade.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function FT300VLD()
	
	//Local cQuery := ""
	//Local cTmp   := GetNextAlias()
	
	Local lRet := .T.
	
	If FindFunction("U_A250SUMVLR")
		U_A250SumVlr()
	Endif
	
	If !Empty( FWFldGet("AD1_MEMO") )
		
		dbSelectArea("AD5")
		dbSetOrder(2)
		If AD5->(dbSeek( xFilial("AD5") + FWFldGet("AD1_NROPOR") ))
	
			While AD5->( !Eof() ) .And. AD5->AD5_NROPOR == FWFldGet("AD1_NROPOR")
			
				RecLock("AD5", .F.)	
					AD5->AD5_MEMO := FWFldGet("AD1_MEMO") 			
				AD5->(MsUnLock())
			
				AD5->(dbSkip())		
			EndDo
		EndIf
		
	EndIf
	
	//-> Montagem da query.
    /*cQuery := " SELECT * " 
    cQuery += " FROM   " + RetSqlName("AD5") + " "
    cQuery += " WHERE  AD5_NROPOR = '" + M->AD1_NROPOR + "' AND " 
    cQuery += "        D_E_L_E_T_ = ' ' "

    //-> Verifica se a tabela esta aberta.
    If Select(cTmp) > 0
    	(cTmp)->(DbCloseArea())				
    EndIf
   	
    //-> Execucao da query.
    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmp,.F.,.T.)
       	
    //-> Processa as oportunidades do Protheus.
    dbSelectArea("AD5")
    dbSetOrder(2)
    While (cTmp)->(!Eof())
    	
    	If AD5->( dbSeek( xFilial("AD5") + (cTmp)->AD5_NROPOR ) )
    	
    	EndIf
    
    EndDo*/
	
Return( .T. )