#Include "Protheus.ch"


//+-----------+----------+-------+-----------------------+------+-------------+
//|Programa:  | FT310TOK |Autor: |David Alves dos Santos |Data: |03/01/2017   |
//|-----------+----------+-------+-----------------------+------+-------------|
//|Descricao: | Ponto de entrada para validacao do apontamento.               |
//|-----------+---------------------------------------------------------------|
//|Uso:       | Certisign - Certificadora Digital.                            |
//+-----------+---------------------------------------------------------------+
User Function FT310TOK()

	Local _lAuto  := .T.
	Local lRet    := .T.
	
	Private cGetCli := Space(06)
	Private oDlg
	
	If FWFldGet("AD5_EVENTO") $ "002PRE | 003PRE"
		
		//-- Se o evento for 002PRE ou 003PRE o campo Verba e Dt Fech. deve ser preenchido.
		If Empty( FWFldGet("AD5_VERBA") )
			MsgAlert("Erro ao realizar o apontamento. Favor preencher o campo:" + CRLF + "Verba","FT310TOK")
			lRet := .F.
		ElseIf Empty( FWFldGet("AD5_XDTFEC") )
			MsgAlert("Erro ao realizar o apontamento. Favor preencher o campo:"  + CRLF +  "Dt. Fecham.","FT310TOK")
			lRet := .F.	
		EndIf
	
	ElseIf FWFldGet("AD5_EVENTO") == "006GAN" //-- Verifica se o estagio eh 006 Ganho.
		
		//-- Se o estagio for 006GAN deve ser informado o motivo de sucesso.
		If Empty(FWFldGet("AD5_FCS")) .Or. Empty(FWFldGet("AD5_MTVENC"))
			MsgAlert("Favor preencher os campos: <b>Mot Sucesso</b> e  <b>Descr. Motiv</b>","FT310TOK")
			lRet := .F.
		EndIf
		
		//-- Verifica se o codigo do prospect esta preenchido.
		If !Empty( FWFldGet("AD5_PROSPE"))
			
			//-- Posiciona a tabela de prospect.
			SUS->(DbSeek(xFilial("SUS") + FWFldGet("AD5_PROSPE") + FWFldGet("AD5_LOJPRO") ))
			
			//-- Verifica status                                                                                     
    		If SUS->US_MSBLQL == '1'
    			MsgAlert("Não é possível torná-lo cliente pois se encontra inativo!","FT310TOK")
    			lRet := .F.	
    		EndIf
    		
    		//-- Verifica status atual                                                                                     
    		If SUS->US_STATUS $ '5/6'
    			MsgAlert("Não é possível torná-lo cliente com o status atual, por favor verifique!","FT310TOK")
    			lRet := .F.	
    		EndIf    
			
			//-- Verifica CNPJ
			If Empty(SUS->US_CGC)
				MsgAlert("Não é possível torná-lo cliente sem a informação do CNPJ!",,"FT310TOK")             
				lRet := .F.
			EndIf
			
			//-- Verifica se CNPJ já existe na SA1
			DbSelectArea("SA1")
			SA1->(DbSetOrder(3))
			If SA1->(DbSeek(SUS->(US_FILIAL+US_CGC)))
				MsgAlert("Este prospect já está cadastrado como cliente, verifique o seu status atual!","FT310TOK")
				lRet := .F.
			EndIf
			
			//+-------------------------------------+
			//| Se as validacoes estiverem OK faz a |
			//| conversao de prospect para cliente  |
			//+-------------------------------------+
			If lRet
				lRet := CsSusSa1() 
			EndIf
			
		EndIf
	
	ElseIf FWFldGet("AD5_EVENTO") == "006PER" .Or. FWFldGet("AD5_EVENTO") == "006NPA" //-- Verifica se o estagio eh 006 Perda.
		
		//-- Se o estagio for 006PER deve ser informado o motivo de perda.
		If Empty(FWFldGet("AD5_FCI")) .Or. Empty(FWFldGet("AD5_MTVENC"))
			MsgAlert("Favor preencher os campos: <b>Motivo Perda</b> e  <b>Descr. Motiv</b>","FT310TOK")
			lRet := .F.
		EndIf
		
	EndIf
	
	If lRet
		
		dbSelectArea("AD1")
		dbSetOrder(1)
		
		If !Empty( FWFldGet("AD5_VERBA") )
			If dbSeek( xFilial("AD1") + FWFldGet("AD5_NROPOR") )
				RecLock("AD1", .F.)
					AD1->AD1_VERBA  := FWFldGet("AD5_VERBA") 			
				AD1->(MsUnLock())
			EndIf
		EndIf
		
		If !Empty( FWFldGet("AD5_XDTFEC") )
			If dbSeek( xFilial("AD1") + FWFldGet("AD5_NROPOR") )
				RecLock("AD1", .F.)	
					AD1->AD1_DTPFIM := FWFldGet("AD5_XDTFEC") 			
				AD1->(MsUnLock())
			EndIf
		EndIf
		
		If !Empty( FWFldGet("AD5_FEELIN") )
			If dbSeek( xFilial("AD1") + FWFldGet("AD5_NROPOR") )
				RecLock("AD1", .F.)	
					AD1->AD1_FEELIN := FWFldGet("AD5_FEELIN") 			
				AD1->(MsUnLock())
			EndIf
		EndIf
		
		If !Empty( FWFldGet("AD5_FCS") )
			If dbSeek( xFilial("AD1") + FWFldGet("AD5_NROPOR") )
				RecLock("AD1", .F.)	
					AD1->AD1_FCS := FWFldGet("AD5_FCS") 			
				AD1->(MsUnLock())
			EndIf
		EndIf
		
		If !Empty( FWFldGet("AD5_FCI") )
			If dbSeek( xFilial("AD1") + FWFldGet("AD5_NROPOR") )
				RecLock("AD1", .F.)	
					AD1->AD1_FCI := FWFldGet("AD5_FCI") 			
				AD1->(MsUnLock())
			EndIf
		EndIf
		
		If !Empty( FWFldGet("AD5_MTVENC") )
			If dbSeek( xFilial("AD1") + FWFldGet("AD5_NROPOR") )
				RecLock("AD1", .F.)	
					AD1->AD1_MTVENC := FWFldGet("AD5_MTVENC") 			
				AD1->(MsUnLock())
			EndIf
		EndIf
		
		If !Empty( FWFldGet("AD5_MEMO") )
			If dbSeek( xFilial("AD1") + FWFldGet("AD5_NROPOR") )
				RecLock("AD1", .F.)	
					MSMM(,,,FWFldGet("AD5_MEMO") ,1,,,"AD1","AD1_CODMEM" )
				AD1->(MsUnLock())
			EndIf
		EndIf
		
	EndIf

Return( lRet )


//+-----------+----------+-------+-----------------------+------+-------------+
//|Programa:  | CsSusSa1 |Autor: |David Alves dos Santos |Data: |03/01/2017   |
//|-----------+----------+-------+-----------------------+------+-------------|
//|Descricao: | Converte Prospect para Cliente.                               |
//|-----------+---------------------------------------------------------------|
//|Uso:       | Certisign - Certificadora Digital.                            |
//+-----------+---------------------------------------------------------------+
Static Function CsSusSa1() 
    
    Local cTRB := GetNextAlias()
    Local lRet := .F.
    
	_cFilAux := cFilAnt
	cFilAnt  := SUS->US_FILIAL  
	_cCodCli := Iif(Empty(cGetCli), GetSx8Num("SA1","A1_COD"), cGetCli)
	
	//-- Faz o Reclock de inclusao.
	If RecLock("SA1", .T.)
		
		SA1->A1_FILIAL := SUS->US_FILIAL	
		SA1->A1_COD    := _cCodCli		
		
		//-- Busca maior loja      
		_cLoja := "01"
		cQuery := " SELECT MAX(A1_LOJA) AS ULTLOJA "
		cQuery += " FROM " + RetSqlName("SA1")
		cQuery += " WHERE D_E_L_E_T_ = '' "          
		cQuery += " AND A1_FILIAL = '" + SA1->A1_FILIAL + "' "
		cQuery += " AND A1_COD    = '" + SA1->A1_COD + "' "    
	   	
	   	//-- Verifica se a tabela esta aberta.
		If Select(cTRB) > 0
			cTRB->(DbCloseArea())				
		EndIf
	   	
	   	//-- Execucao da query.
	   	cQuery := ChangeQuery( cQuery )
	   	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cQuery ), cTRB, .F., .T. )              
	    
	    If !(cTRB)->(Eof())
	    	_cLoja := SOMA1((cTRB)->ULTLOJA)
	    EndIf
	    (cTRB)->(DbCloseArea())    
		
		//-- Inclusao das informacoes restantes.
		SA1->A1_LOJA   := _cLoja
		SA1->A1_PESSOA := SUS->US_PESSOA
		SA1->A1_NOME   := SUS->US_NOME
		SA1->A1_NREDUZ := SUS->US_NREDUZ
		SA1->A1_TIPO   := SUS->US_TIPO
		SA1->A1_CEP    := SUS->US_CEP
		SA1->A1_END    := SUS->US_END
		SA1->A1_BAIRRO := SUS->US_BAIRRO
		SA1->A1_EST    := SUS->US_EST
		SA1->A1_MUN    := SUS->US_MUN
		SA1->A1_PAIS   := SUS->US_PAIS
		SA1->A1_DDI    := SUS->US_DDI
		SA1->A1_DDD    := SUS->US_DDD	
		SA1->A1_TEL    := SUS->US_TEL
		SA1->A1_CGC    := SUS->US_CGC
		SA1->A1_INSCR  := SUS->US_INSCR
		SA1->A1_EMAIL  := SUS->US_EMAIL
		SA1->A1_GRPVEN := SUS->US_GRPVEN	
		
		SA1->(MsUnLock())    
		SA1->(ConfirmSX8())
		
	EndIf              
	cFilAnt := _cFilAux
    
	// Acerta status
	If RecLock("SUS", .F.)
		SUS->US_STATUS := "6"
		SUS->US_MSBLQL := "1"
		SUS->(MsUnLock())
		lRet := .T.
		MsgInfo("O Prospect: " + SUS->US_NOME + " foi convertido para cliente com sucesso!","FT310TOK")	
	EndIf
	
Return( lRet )