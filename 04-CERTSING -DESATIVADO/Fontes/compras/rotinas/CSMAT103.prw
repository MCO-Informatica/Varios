#Include 'Protheus.ch'
STATIC cMV_CSMT103 := ''
//---------------------------------------------------------------------
// Rotina | CSMAT103  | Autor | Rafael Beghini      | Data | 06.04.2018
//---------------------------------------------------------------------
// Descr. | Alterações específicas no Documento de Entrada
//---------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------
User Function CSMAT103(cOpc,nRECNO)
	IF cOpc == '1'
		A103AltSerie(@nRECNO)
	EndIF
Return
//---------------------------------------------------------------------
// Rotina | A103AltSerie  | Autor | Rafael Beghini  | Data | 06.04.2018
//---------------------------------------------------------------------
// Descr. | Altera a série na Classificação
//---------------------------------------------------------------------
Static Function A103AltSerie(nRECNO)
	Local aRet := {}
	Local aPar := {}
	Local cUsr := RetCodUsr()
	Local cNUM := ''
	Local cUPD := ''
		
	A103Param()
	
	SF1->( dbGoto( nRECNO ) )
	//nRECNO := SF1->( Recno() )
	
	IF .Not. Empty(SF1->F1_STATUS) .OR. .Not. (cUsr $ cMV_CSMT103)
		MsgAlert('Nota fiscal já classificada e/ou usuário não autorizado.','CSMAT103')
		Return
	EndIF
	
	aAdd(aPar,{9,"Informe a nova Série para a NF.",150,7,.T.})
	aAdd(aPar,{1,"Série",Space(03),"","","","",0,.F.}) // Tipo caractere
	
	If ParamBox(aPar,"Alterar Série...",@aRet)
		IF !SF1->( dbSeek( SF1->F1_FILIAL + SF1->F1_DOC + aRET[2] + SF1->( F1_FORNECE+F1_LOJA+F1_TIPO ) ) )
			Begin Transaction
				SF1->( dbGoto( nRECNO ) )
				//Verificar se existe banco do conhecimento e realizar a alteração também.
				AC9->( dbSetOrder(2) )
				IF AC9->( dbSeek( xFilial('AC9') + 'SF1' + SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) ) )
					FWMsgRun(,{|| A103AltBco( SF1->F1_DOC, aRET[2] ) },,'Aguarde, realizando alteração no banco de conhecimento...')
				EndIF

				//Verificar se existe rateio e realizar a alteração também.
				SDE->( dbSetOrder(1) )
				IF SDE->( dbSeek( xFilial('SF1') + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) ) )
					FWMsgRun(,{|| A103AltRat( SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA), aRET[2] ) },,'Aguarde, realizando alteração nos dados de Rateio...')
				EndIF
				
				SF1->( dbGoto( nRECNO ) )
				
				cUPD := "UPDATE "+RetSqlName("SD1")+" "
				cUPD += "SET    D1_SERIE = '" + aRET[ 2 ] + "' "
				cUPD += "WHERE  D1_FILIAL 	   = '" + SF1->F1_FILIAL + "' "
				cUPD += "       AND D1_DOC     = '" + SF1->F1_DOC + "' "
				cUPD += "       AND D1_SERIE   = '" + SF1->F1_SERIE + "' "
				cUPD += "       AND D1_FORNECE = '" + SF1->F1_FORNECE + "' "
				cUPD += "       AND D1_LOJA    = '" + SF1->F1_LOJA + "' " 
				
				If TCSqlExec( cUPD ) < 0
					MsgStop('Ocorreu o seguinte erro: '+Chr(10)+Chr(10)+AllTrim(TcSqlError()))
				Else
				
					SF1->( dbGoto( nRECNO ) )
					SF1->( RecLock('SF1',.F.) )
					SF1->F1_SERIE := aRET[ 2 ]
					SF1->( MsUnlock() )
					
					MsgInfo('Série alterada com sucesso','CSMAT103')
				EndIF
			End Transaction
		Else
			MsgAlert('A chave NF + Série + Fornecedor já existe, informe uma nova série para a NF','CSMAT103')
		EndIF
	Endif
Return
//---------------------------------------------------------------------
// Rotina | A103Param  | Autor | Rafael Beghini  | Data | 06.04.2018
//---------------------------------------------------------------------
// Descr. | Cria os parêmetros utilizados na rotina
//---------------------------------------------------------------------
Static Function A103Param()
	cMV_CSMT103 := 'MV_CSMT103'
	
	If .NOT. GetMv( cMV_CSMT103, .T. )
		CriarSX6( cMV_CSMT103, 'C', 'Usuários liberados para alterar a serie da NF. CSMAT103.prw', '000275|000718|002532|002517' )
	Endif		
	cMV_CSMT103 := GetMv( cMV_CSMT103, .F. )	
Return
//---------------------------------------------------------------------
// Rotina | A103AltBco  | Autor | Rafael Beghini  | Data | 06.04.2018
//---------------------------------------------------------------------
// Descr. | Altera a série no ID da AC9 (Banco de conhecimento)
//---------------------------------------------------------------------
Static Function A103AltBco(cDOC,cNewSerie)
	Local aArea := GetArea()
	Local cSQL	:= ''
	Local cTRB	:= ''
	
	SLEEP(500)
	
	cSQL += "SELECT R_E_C_N_O_" + CRLF
	cSQL += "FROM " + RetSqlName('AC9') + " " + CRLF
	cSQL += "WHERE D_E_L_E_T_= ' '" + CRLF
	cSQL += "AND AC9_FILIAL = " + ValToSql(xFilial("AC9")) + " " + CRLF
	cSQL += "AND AC9_FILENT = " + ValToSql(xFilial("SF1")) + " " + CRLF
	cSQL += "AND AC9_ENTIDA = 'SF1'" + CRLF
	cSQL += "AND SUBSTR(AC9_CODENT,1,9) = '" + cDOC + "' " + CRLF

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
	
	IF (cTRB)->( .NOT. BOF() ) .And. (cTRB)->( .NOT. EOF() )
		While (cTRB)->( .NOT. EOF() )
			AC9->( dbGoto( (cTRB)->R_E_C_N_O_ ) )
			AC9->( RecLock('AC9',.F.) )
			AC9->AC9_CODENT := Stuff( AC9->AC9_CODENT, 10, 3, cNewSerie )
			AC9->( MsUnlock() )
			
		(cTRB)->( dbSkip() )
		End
	EndIF
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return

//---------------------------------------------------------------------
// Rotina | A103AltRat  | Autor | Rafael Beghini  | Data | 09.10.2019
//---------------------------------------------------------------------
// Descr. | Altera a série nos itens de Rateio
//---------------------------------------------------------------------
Static Function A103AltRat(cDOC,cNewSerie)
	Local aArea := GetArea()
	Local cSQL	:= ''
	Local cTRB	:= ''
	
	SLEEP(500)
	
	cSQL += "SELECT R_E_C_N_O_" + CRLF
	cSQL += "FROM " + RetSqlName('SDE') + " " + CRLF
	cSQL += "WHERE D_E_L_E_T_= ' '" + CRLF
	cSQL += "AND DE_FILIAL = " + ValToSql(xFilial("SDE")) + " " + CRLF
	cSQL += "AND DE_DOC||DE_SERIE||DE_FORNECE||DE_LOJA = '" + cDOC + "' " + CRLF

	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
	
	IF (cTRB)->( .NOT. BOF() ) .And. (cTRB)->( .NOT. EOF() )
		While (cTRB)->( .NOT. EOF() )
			SDE->( dbGoto( (cTRB)->R_E_C_N_O_ ) )
			SDE->( RecLock('SDE',.F.) )
			SDE->DE_SERIE := cNewSerie
			SDE->( MsUnlock() )
			
		(cTRB)->( dbSkip() )
		End
	EndIF
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
Return