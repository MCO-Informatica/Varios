#Include "Protheus.ch"
#Include "TopConn.ch"
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'
#Include "aarray.ch"
#Include "json.ch"
#Include "FileIO.ch"

#Define Pula_Linha Chr(13) + Chr(10)

//+--------------+---------+-------+-----------------------+------+-------------+
//| Programa:    |CSCRMW01 |Autor: |David Alves dos Santos |Data: |15/10/2018   |
//|--------------+---------+-------+-----------------------+------+-------------|
//| Descricao:   |Webservice para integração CRM x Pipedrive.                   |
//|--------------+--------------------------------------------------------------|
//| Nomenclatura |CS   = Certisign.                                             |
//| do codigo    |CRM  = Modulo CRM.                                            |
//| fonte.       |W    = Webservice.                                            |
//|              |01   = Numero sequencial.                                     |
//|--------------+--------------------------------------------------------------|
//| Docto. API   |https://developers.pipedrive.com/docs/api/v1/                 |
//|--------------+--------------------------------------------------------------|
//| Uso:         |Certisign - Certificadora Digital.                            |
//+--------------+--------------------------------------------------------------+
User Function CSCRMW01(cXEmp,cXFil)
	
	Local aDeal   := {}
	Local lRetLck := .T.
	
	Private cURL   := ""
	Private cToken := ""
	Private cDtHr  := "'[ ' + DToc(Date()) + ' - ' + Time() + ' ] '"
	
	Default cXEmp := "01" //"99" //"01"
	Default cXFil := "02" //"01" //"02"
	
	//-> Informa o servidor que nao ira consumir licensas.
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cXEmp FILIAL cXFil MODULO 'FAT' TABLES 'AD1'
		
		lRetLck := LockByName("cscrmw01",.f.,.f.,.t.)
		
		If lRetLck
		
			//-> Definição da URL e Token.
			cURL   := SuperGetMV( "MV_ACRMW01", .F., "https://api.pipedrive.com/v1" )				//-> URL de integração.
			cToken := SuperGetMV( "MV_BCRMW01", .F., "029d0a57a116d1957b48f61083bc00c8d6697cce" )	//-> Token do usuário.
		
			//-> Chamada da função principal de processamento.
			mainProc()
			
			UnlockByName("cscrmw01",.f.,.f.,.t.)
		Else
			Conout('Esta rotina já está sendo executada.')
		EndIf
		
	RESET ENVIRONMENT
    
Return


//+--------------+---------+-------+-----------------------+------+-------------+
//| Função:      |mainProc |Autor: |David Alves dos Santos |Data: |22/10/2018   |
//|--------------+---------+-------+-----------------------+------+-------------|
//| Descricao:   |Função principal para processamento dos dados.                |
//|--------------+--------------------------------------------------------------|
//| Uso:         |Certisign - Certificadora Digital.                            |
//+--------------+--------------------------------------------------------------+
Static Function mainProc()
			
	Local aCustFld := {}
    Local aPDParam := {}
    Local aOportPD := {}
    Local aOptAux  := {}
    
    Local cContent := ""
    Local cDescOpt := ""
    Local cCliente := ""
    Local cVerbOpt := ""
    Local cDtIni   := ""
    Local cFldOpt  := ""
    Local cUsrMst  := ""
    Local cQuery   := ""
    Local cTmpAD1  := GetNextAlias()
    Local cTmpAD5  := GetNextAlias()
    Local cTmpPBW  := GetNextAlias()
    Local cFileLog := ""
    Local cLog     := ""
    
    Local lContinua := .T.
    
    Local nStgIni  := 0
    Local nDealID  := 0
    Local nX       := 0
    Local nY       := 0
    Local nHandle  := 0
    Local nApont   := 0
    
    Private cPpdDirLog := AllTrim(GetNewPar("MV_GCRMW01","data\pipedrive\"))	//-> Diretorio onde sera salvo o arquivo de log de integração.
    
    cFileLog := cPpdDirLog + "Log_CSCRMW01-" + dToS(Date()) + ".log"
    //-- Grava o arquivo de log.
	If MemoWrite(cFileLog,cLog)
		Conout("Arquivo Log_CSCRMW01 criado no diretorio: " + cPpdDirLog)
	EndIf
	
    Conout( &(cDtHr) + "Iniciando processo de integração...")
    cLog += &(cDtHr) + "Iniciando processo de integração..." + Pula_Linha
    
    //-> Parametros.
    cFldOpt := SuperGetMV( "MV_CCRMW01", .F., "20c70b1464d60b956faf69db49a12a650eb4b663" )	//-> Campo customizado: Numero Oportunidade.
    cUsrMst := SuperGetMV( "MV_DCRMW01", .F., "5048090" )									//-> Código do usuário mestre.
    cDtIni  := SuperGetMV( "MV_ECRMW01", .F., "20180101" )									//-> Data inicial para filtro no Protheus.
    nStgIni := SuperGetMV( "MV_FCRMW01", .F., "18" )										//-> Estagio inicial onde a oportunidade irá nascer.
    
    //-> Parametros do PipeDrive.
    AAdd( aPDParam, {'stage_id',""     } )
    AAdd( aPDParam, {'status'  ,"open" } )
    AAdd( aPDParam, {'start'   ,"0"    } )
    
    //-> Montagem da query.
    cQuery := " SELECT * " 
    cQuery += " FROM   " + RetSqlName("PBW") + " "
    cQuery += " WHERE  PBW_FILIAL = '" + xFilial("PBW") + "' " 
    cQuery += "        AND D_E_L_E_T_ = ' ' " 
    
    //-> Verifica se a tabela esta aberta.
    If Select(cTmpPBW) > 0
    	(cTmpPBW)->(DbCloseArea())				
    EndIf
   	
    //-> Execução da query.
    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmpPBW,.F.,.T.)
    Conout( &(cDtHr) + "Selecionando pipelines...")
    cLog += &(cDtHr) + "Selecionando pipelines..." + Pula_Linha
    
    While (cTmpPBW)->(!Eof())
    	
    	Conout( &(cDtHr) + "Carregando oportunidades do Pipedrive via webservice...")
    	cLog += &(cDtHr) + "Carregando oportunidades do Pipedrive via webservice..." + Pula_Linha
    	
    	aOportPD := getOport( (cTmpPBW)->PBW_COD, cFldOpt, aPDParam )
    	
    	If ValType( aOportPD ) == "A"
    		
    		//-> Montagem da query.
    		cQuery := " SELECT * " 
    		cQuery += " FROM   " + RetSqlName("AD1") + " "
    		cQuery += " WHERE  AD1_DTINI BETWEEN '" + AllTrim(cDtIni) + "' AND '" + DtoS(Date()) + "' " 
    		cQuery += "        AND ( AD1_STAGE = '002PRE' " 
    		cQuery += "           OR AD1_STAGE = '003PRE' ) "
    		cQuery += "        AND AD1_XINTPD <> 'S' " 
    		cQuery += "        AND D_E_L_E_T_ = ' ' "

    		//-> Verifica se a tabela esta aberta.
    		If Select(cTmpAD1) > 0
    			(cTmpAD1)->(DbCloseArea())				
    		EndIf
   	
	    	//-> Execucao da query.
	    	cQuery := ChangeQuery(cQuery)
	    	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTmpAD1,.F.,.T.)
	    	Conout( &(cDtHr) + "Selecionando oportunidades do Protheus...")
	    	cLog += &(cDtHr) + "Selecionando oportunidades do Protheus..." + Pula_Linha
   	
	    	//-> Processa as oportunidades do Protheus.
	    	Conout( &(cDtHr) + "Iniciando integração de oportunidades Protheus x PipeDrive...")
	    	cLog += &(cDtHr) + "Iniciando integração de oportunidades Protheus x PipeDrive..." + Pula_Linha
	    	
	    	dbSelectArea("SA3")
	    	SA3->(dbSetOrder(1))

	    	While (cTmpAD1)->(!Eof())
	    		
	    		lContinua := .T.
	    		For nX := 1 To Len(aOportPD)
	    			If aOportPD[nX,1] == (cTmpAD1)->AD1_NROPOR
	    				lContinua := .F.
	    				Exit
	    			EndIf
	    		Next nX
	    		
	    		If lContinua
	    			
	    			cLog += "====================================================================================================" + Pula_Linha
	    			Conout( &(cDtHr) + "Importando a oportunidade: " + (cTmpAD1)->AD1_NROPOR + "...")
	    			cLog += &(cDtHr) + "Importando a oportunidade: " + (cTmpAD1)->AD1_NROPOR + "..." + Pula_Linha
	    			
	    			aCustFld := {}
	    			
	    			cDescOpt  := rmvCarcEsp(AllTrim((cTmpAD1)->AD1_DESCRI))
	    			If !Empty((cTmpAD1)->AD1_CODCLI)
	    				cCliente := AllTrim(SA1->(GetAdvFVal('SA1', 'A1_NOME', xFilial("SA1") + AllTrim((cTmpAD1)->AD1_CODCLI), 1)))
	    			EndIf
	    			cVerbOpt  := cValToChar((cTmpAD1)->AD1_VERBA)
	    			cDtIni    := SubStr((cTmpAD1)->AD1_DTINI,1,4) + "-" + SubStr((cTmpAD1)->AD1_DTINI,5,2) + "-" + SubStr((cTmpAD1)->AD1_DTINI,7,2)
	    			nStgIni   := IIf(ValType(nStgIni) == "N", nStgIni, Val(AllTrim(nStgIni)))
	    			
	    			If SA3->(dbSeek(xFilial("SA3") + (cTmpAD1)->AD1_VEND))
	    				nPersonID := Val(SA3->A3_CODPPD)
	    			EndIf
	    			   			
	    			//+----------------------------------------------------------------+
	    			//| Como alimentar o array de campos customizados: aCustFld.       |
	    			//+----------------------------------------------------------------+
	    			//| AAdd(aCustFld,{"Chave do campo customizado","VALOR DO CAMPO"}) |
	    			//+----------------------------------------------------------------+
	    			AAdd( aCustFld ,{"39866b6eb900c108786c5abad32c771f51ca8ece" ,rmvCarcEsp(cDescOpt)			}) //-> Descrição Oportunidade.
	    			AAdd( aCustFld ,{"94da29c0f642fe47cc1f3d38277604bbeaa9da41" ,rmvCarcEsp(cCliente)			}) //-> Nome do Cliente.
	    			AAdd( aCustFld ,{"20c70b1464d60b956faf69db49a12a650eb4b663" ,Val((cTmpAD1)->AD1_NROPOR)		}) //-> Numero da Oportunidade.
	    			AAdd( aCustFld ,{"dcb36f5d4fac280c55d133dfc444c3fb56bc3a66" ,cDtIni 						}) //-> Data Inicio.
	    			AAdd( aCustFld ,{"faca30767d1d1bf6d127b99ef410aa43318de504" ,AllTrim((cTmpAD1)->AD1_CODPRO)	}) //-> Produto Principal.
	    	    			
	    			Conout( &(cDtHr) + "Incluindo a oportunidade " + AllTrim((cTmpAD1)->AD1_NROPOR) + " no Pipedrive...")
	    			//-> Método PipeDrive: Add a Deal
	    			//   CSPDWD01( lJob , cTitle   , cValue   , cCurrency , nUserID      , nPersonID , nOrgIG , nStageID , cStatus , nProbabili , cLostReaso , cAddTime , cVisibleTo , aCustField )
	    			If U_CSPDWD01( .T.  , cDescOpt , cVerbOpt ,           , Val(cUsrMst) , nPersonID ,        , nStgIni  , "open"  ,            ,            ,          ,            , aCustFld   )
	    				
	    				cLog += &(cDtHr) + "Oportunidade " + AllTrim((cTmpAD1)->AD1_NROPOR) + " incluida com sucesso no Pipedrive..." + Pula_Linha
	    				
	    				dbSelectArea("AD1")
	    				AD1->(dbSetOrder(1))
	    				
	    				If AD1->(dbSeek( xFilial("AD1") + (cTmpAD1)->AD1_NROPOR ))
	    					RecLock("AD1", .F.)
	    						AD1->AD1_XINTPD := 'S'
	    					AD1->(MsUnLock())
	    				EndIf
	    				
	    				Conout( &(cDtHr) + "Carregando oportunidades atualizadas do Pipedrive via webservice...")
	    				cLog += &(cDtHr) + "Carregando oportunidades atualizadas do Pipedrive via webservice..." + Pula_Linha
	    				aOportPD := getOport( (cTmpPBW)->PBW_COD, cFldOpt, aPDParam )
	    				
	    				For nX := 1 To Len(aOportPD)
	    					If aOportPD[nX,1] == (cTmpAD1)->AD1_NROPOR
	    						nDealID := aOportPD[nX,2]
	    						Exit
	    					Else
	    						Loop
	    					EndIf
	    				Next nX
	    				
	    				dbSelectArea("AD5")
	    				dbSetOrder(2)
	    				
	    				If AD5->( dbSeek( xFilial("AD5") + (cTmpAD1)->AD1_NROPOR) )
	    					cLog += "----------------------------------------------------------------------------------------------------" + Pula_Linha
	    					Conout( &(cDtHr) + "Incluindo apontamentos da oportunidade " + AllTrim((cTmpAD1)->AD1_NROPOR) + " no Pipedrive...")
	    					cLog += &(cDtHr) + "Incluindo apontamentos da oportunidade " + AllTrim((cTmpAD1)->AD1_NROPOR) + " no Pipedrive..." + Pula_Linha
	    					nApont := 0
	    					While AD5->(!Eof()) .And. AD5->AD5_NROPOR == (cTmpAD1)->AD1_NROPOR
	    						If !Empty(AD5->AD5_CODMEN)
	    							cContent := "<b>Vendedor:</b> " + SA3->(GetAdvFVal('SA3', 'A3_NOME', xFilial('SA3') + AD5->AD5_VEND, 1)) + "<br>"
	    							cContent += "<b>Data Apontamento:</b> " + DtoC(AD5->AD5_DATA) + "<br><br>"
	    							cContent += EncodeUTF8( StrTran( MSMM(AD5->AD5_CODMEN), Chr(13) + Chr(10), "<br>") )
	    							If Empty(cContent)
	    								cContent := EncodeUTF8( StrTran( AD5->AD5_MEMO, Chr(13) + Chr(10), "<br>") )
	    							EndIf
	    							If U_CSPDWD03( .T., cContent, nDealID )
	    								nApont = nApont + 1
	    								cLog  += &(cDtHr) + "Apontamento " + cValToChar(nApont) + " incluido com sucesso..." + Pula_Linha
	    							EndIf
	    						EndIf
	    						AD5->( DbSkip() )
	    					EndDo
	    				EndIf
	   			   	EndIf
	    		EndIf
	    		
	    		cLog += "====================================================================================================" + Pula_Linha		
	    		(cTmpAD1)->(DbSkip())
	   			
	    	EndDo
	    	Conout( &(cDtHr) + "Integração protheus x pipedrive concluida..." )
	    	cLog += &(cDtHr) + "Integração protheus x pipedrive concluida..." + Pula_Linha
	    EndIf
       
       (cTmpPBW)->(dbSkip())
    EndDo
    
    //-> Abre o arquivo
  	nHandle := fopen(cFileLog , FO_READWRITE + FO_SHARED )
  	If nHandle == -1
		Conout('Erro de abertura : FERROR ' + Str(fError(),4))
  	Else
    	FSeek(nHandle, 0, FS_END)		//-> Posiciona no fim do arquivo
    	FWrite(nHandle, cLog) 			//-> Insere texto no arquivo
    	fclose(nHandle)					//-> Fecha arquivo
	 	Conout('Processo concluído')
	 	nCountLog := 0
	 	cLog := ""
  	Endif

Return


//+--------------+---------+-------+-----------------------+------+-------------+
//| Função:      |getOport |Autor: |David Alves dos Santos |Data: |19/06/2019   |
//|--------------+---------+-------+-----------------------+------+-------------|
//| Descricao:   |Função para capturar as oportunidade do Pipedrive.            |
//|--------------+--------------------------------------------------------------|
//| Uso:         |Certisign - Certificadora Digital.                            |
//+--------------+--------------------------------------------------------------+
Static Function getOport( cCod, cFldOpt, aPDParam )
	
	Local aOptAux  := {}
	Local aOportPD := {}
	Local nY       := 0
	
	dbSelectArea("PBX")
    dbSetOrder(1)
	If PBX->(dbSeek(xFilial("PBX") + cCod ))
    	While PBX->(!Eof()) .And. cCod == PBX->PBX_COD
    		aPDParam[1,2] := AllTrim(PBX->PBX_IDSTG)
    		aOptAux := U_CSPDWD02( .T., aPDParam, cFldOpt )
    	
    		//-> Carrega array com todas as oportunidades do PipeDrive.
    		For nY := 1 To Len(aOptAux)
    			AAdd(aOportPD, {aOptAux[nY,1],aOptAux[nY,2]})
    		Next nY
    		
    		PBX->(dbSkip())
    	EndDo
    EndIf
    
Return( aOportPD )


//+--------------+-----------+-------+-----------------------+------+-----------+
//| Função:      |rmvCarcEsp |Autor: |David Alves dos Santos |Data: |19/06/2019 |
//|--------------+-----------+-------+-----------------------+------+-----------|
//| Descricao:   |Função para remover caracteres especiais.                     |
//|--------------+--------------------------------------------------------------|
//| Uso:         |Certisign - Certificadora Digital.                            |
//+--------------+--------------------------------------------------------------+
Static Function rmvCarcEsp( cString )
	
	cString := StrTran(cString,"–","-")
    
Return( cString )