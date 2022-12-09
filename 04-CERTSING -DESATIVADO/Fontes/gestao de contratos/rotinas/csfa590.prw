//-----------------------------------------------------------------------
// Rotina | CSFA590    | Autor | Robson Gonçalves     | Data | 14.04.2015
//-----------------------------------------------------------------------
// Descr. | Rotina para atualizar o campo de acumulador de medição.
//        | Esta rotina está sendo acionada pelos pontos de entradas:
//        | CN120EnMed (encerramento) e CN120EsMed (estorno) de medição.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSFA590( cCN9_NUMERO, cCN9_REVISA, cAction )
	Local cSQL := ''
	Local cTRB := ''
	Local nCN9_MEDACU := 0
	Local aArea := {}
	// Existe o campo específico para acumular o valor medido?
	If CN9->( FieldPos( 'CN9_MEDACU' ) ) > 0
		// A chamada da rotina está sendo acionada por um dos pontos de entrada?
		If IsInCallStack('U_CN120ENMED') .OR. IsInCallStack('U_CN120ESMED')
			// Salvar as áreas das tabelas.
			aArea := { GetArea(), CN9->( GetArea() ), CND->( GetArea() ), CNE->( GetArea() ), AC9->( GetArea() ), ACB->( GetArea() ), ACC->( GetArea() ) }
			// Elaborar a string da query.
			/*
			cSQL := "SELECT NVL( SUM( CNE_VLTOT ), 0 ) CNE_VLTOT "
			cSQL += "FROM   "+RetSqlName("CNE")+" CNE "
			cSQL += "	       INNER JOIN "+RetSqlName("CND")+" CND "
			cSQL += "	               ON CND_FILIAL = "+ValToSql(xFilial("CND"))+" "
			cSQL += "	              AND CND_CONTRA = CNE_CONTRA "
			cSQL += "	              AND CND_NUMMED = CNE_NUMMED "
			cSQL += "	              AND CND_DTFIM <> ' ' "
			cSQL += "	              AND CND.D_E_L_E_T_ = ' ' "
			cSQL += "	WHERE  CNE_FILIAL = "+ValToSql(xFilial("CNE"))+" "
			cSQL += "	       AND CNE_CONTRA = "+ValToSql(cCN9_NUMERO)+" "
			cSQL += "          AND CNE_REVISA = "+ValToSql(cCN9_REVISA)+" "
			cSQL += "	       AND CNE.D_E_L_E_T_ = ' ' "
			*/
			cSQL += "SELECT ( NVL(Sum(CNE_VLTOT), 0) - NVL(Sum(CNQ_VALOR), 0) - NVL(Sum(CNR.CNR_VALOR), 0) ) + NVL(Sum(CNR1.CNR_VALOR), 0) CNE_VLTOT" + CRLF
			cSQL += "FROM   " + RetSqlName("CNE") + " CNE " + CRLF
			cSQL += "       INNER JOIN " + RetSqlName("CND") + " CND " + CRLF
			cSQL += "               ON CND_FILIAL = CNE_FILIAL " + CRLF
			cSQL += "                  AND CND_CONTRA = CNE_CONTRA " + CRLF
			cSQL += "                  AND CND_NUMMED = CNE_NUMMED " + CRLF
			cSQL += "                  AND CND_DTFIM <> ' '  " + CRLF
			cSQL += "                  AND CND.D_E_L_E_T_ = ' ' " + CRLF
			cSQL += "       LEFT JOIN " + RetSqlName("CNQ") + " CNQ " + CRLF
			cSQL += "              ON CNQ_FILIAL = CNE_FILIAL " + CRLF
			cSQL += "                 AND CNQ_CONTRA = CNE_CONTRA " + CRLF
			cSQL += "                 AND CNQ_NUMMED = CNE_NUMMED " + CRLF
			cSQL += "                 AND CNQ.D_E_L_E_T_ = ' ' " + CRLF
			cSQL += "       LEFT JOIN " + RetSqlName("CNR") + " CNR " + CRLF
			cSQL += "              ON CNR.CNR_FILIAL = CNE_FILIAL " + CRLF
			cSQL += "                 AND CNR.CNR_CONTRA = CNE_CONTRA " + CRLF
			cSQL += "                 AND CNR.CNR_NUMMED = CNE_NUMMED " + CRLF
			cSQL += "                 AND CNR.CNR_TIPO = '1' " + CRLF
			cSQL += "                 AND CNR.CNR_FLGPED = '1' " + CRLF
			cSQL += "                 AND CNR.D_E_L_E_T_ = ' ' " + CRLF
			cSQL += "       LEFT JOIN " + RetSqlName("CNR") + " CNR1 " + CRLF
			cSQL += "              ON CNR1.CNR_FILIAL = CNE_FILIAL " + CRLF
			cSQL += "                 AND CNR1.CNR_CONTRA = CNE_CONTRA " + CRLF
			cSQL += "                 AND CNR1.CNR_NUMMED = CNE_NUMMED " + CRLF
			cSQL += "                 AND CNR1.CNR_TIPO = '2' " + CRLF
			cSQL += "                 AND CNR1.CNR_FLGPED = '1' " + CRLF
			cSQL += "                 AND CNR1.D_E_L_E_T_ = ' ' " + CRLF
			cSQL += "WHERE  CNE_FILIAL = " + ValToSql(xFilial("CNE"))  + " " + CRLF
			cSQL += "       AND CNE_CONTRA = " + ValToSql(cCN9_NUMERO) + " " + CRLF
			cSQL += "       AND CNE_REVISA = " + ValToSql(cCN9_REVISA) + " " + CRLF
			cSQL += "       AND CNE.D_E_L_E_T_ = ' ' "
			// Capturar um Alias.
			cTRB := GetNextAlias()
			// Executar a query.
			dbUseArea( .T., 'TOPCONN', TcGenQry( , , cSQL ), cTRB, .T., .T. )
			// Capturar o retorno do somatório.
			nCN9_MEDACU := (cTRB)->( CNE_VLTOT )
			// Fechar o Alias temporário.
			(cTRB)->( dbCloseArea() )
			// Se a chave dos registros for diferente da chave do registro da medição.
			If CN9->CN9_NUMERO <> cCN9_NUMERO .AND. CN9->CN9_REVISA <> cCN9_REVISA
				// Reposicionar o registro do contrato.
				CN9->( dbSetOrder( 1 ) )
				CN9->( dbSeek( xFilial( 'CN9' ) + cCN9_NUMERO + cCN9_REVISA ) )
			Endif
			// Gravar o valor da medição acumulada.
			CN9->( RecLock( 'CN9', .F. ) )
			CN9->CN9_MEDACU := nCN9_MEDACU
			CN9->( MsUnLock() )
			
			// Excluir o banco de conhecimento quando houver capa de despesa, somente na ação de encerramento.
			If cAction == 'ESTORNAR'
				A590DelCP()
				A590AtuSaldo(cCN9_NUMERO,cCN9_REVISA,CND->CND_NUMMED,'1')
			Else
				A590AtuSaldo(cCN9_NUMERO,cCN9_REVISA,CND->CND_NUMMED,'0')
			Endif
			
			// Reestabelecer as áreas das tabelas.
			AEval( aArea, {|xArea| RestArea( xArea ) } )
		Endif
	Else
		MsgAlert('É necessário executar o update UPD590 para atualização do acumulador de medições.','CSFA590 - Acumulador de Medição')
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A590DelCP  | Autor | Robson Gonçalves     | Data | 28.10.2015
//-----------------------------------------------------------------------
// Descr. | Rotina p/ excluir o banco de conhecimento qdo capa de despesa
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A590DelCP()
	Local cAC9_CODENT := xFilial( 'CND' ) + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMMED
	// Localizar o código do objeto no banco de conhecimento.
	AC9->( dbSetOrder( 2 ) )
	AC9->( dbSeek( xFilial( 'AC9' ) + 'CND' + xFilial( 'CND' ) + cAC9_CODENT ) )
	// Ler todos os registros do banco de conhecimento relacionado a medição.
	While AC9->(.NOT.EOF()).AND.AC9->AC9_FILIAL==xFilial('AC9').AND.AC9->AC9_ENTIDA=='CND'.AND.AC9->AC9_FILENT==xFilial('CND').AND.RTrim(AC9->AC9_CODENT)==cAC9_CODENT
		ACB->( dbSetOrder( 1 ) )
		// Localizar o registro dependente.
		If ACB->( dbSeek( xFilial( 'ACB' ) + AC9->AC9_CODOBJ ) )
			// Se for capa de despesa.
			If SubStr( ACB->ACB_OBJETO, 1, 11 ) == 'CAPADESPESA'
				ACC->( dbSetOrder( 1 ) )
				// Localizar o registro dependente e excluir.
				If ACC->( dbSeek( xFilial( 'ACC' ) + AC9->AC9_CODOBJ ) )
					// Excluir somente o relacionamento, pois o arquivo físico existe no diretório.
					AC9->( RecLock( 'AC9', .F. ) ) 
					AC9->( dbDelete() )
					AC9->( MsUnLock() )
				Endif
			Endif
	   Endif
		AC9->( dbSkip() )
	End
Return

//-----------------------------------------------------------------------
// Rotina | UPD590     | Autor | Robson Gonçalves     | Data | 14.04.2015
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD590()
	Local cModulo := 'TEC'
	Local bPrepar := {|| U_U590Ini() }
	Local nVersao := 1
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//-----------------------------------------------------------------------
// Rotina | U590Ini    | Autor | Robson Gonçalves     | Data | 14.04.2015
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U590Ini()
	aSX3 := {}
	AAdd(aSX3,{"CN9",NIL,"CN9_MEDACU","N",18,2,"Med.Acumulad","Med.Acumulad","Med.Acumulad","Medicao acumulada","Medicao acumulada","Medicao acumulada","@E 999,999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",1,"þÀ","","","U","S","V","R","","","","","","","","","","","" ,"","","" ,"N","N","",""})
	AAdd(aHelp,{"CN9_MEDACU","Valor de medição acumulado."})
Return

//-----------------------------------------------------------------------
// Rotina | A590Acum   | Autor | Robson Gonçalves     | Data | 23.04.2015
//-----------------------------------------------------------------------
// Descr. | Rotina para atualizar o campo de acumulador de medição para 
//        | todos os contratos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A590Acum()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private cCadastro := 'Refazer o acumulo de medição de contratos'

	AAdd( aSay, 'Esta rotina tem o objetivo de atualizar o valor acumulado de medição por contrato.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para proseguir...' )
	
	AAdd( aButton, { 01, .T., { || Iif( MsgYesNo('Confirma realmente o início do processamento?'+CRLF+'Este processo não tem reversão.',cCadastro),(nOpcao:=1,FechaBatch()),NIL)}})
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		Processa( { || A590ProcAcu() }, cCadastro,"Aguarde, processando...", .F. )
		MsgInfo('A rotina chegou no seu final de processamento.',cCadastro)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A590ProcAcu| Autor | Robson Gonçalves     | Data | 23.04.2015
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento para atualizar o campo de acumulador 
//        | de medição de todos os contratos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A590ProcAcu()
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local cCN9_FILIAL := xFilial( 'CN9' )

	cSQL := "SELECT CNE_CONTRA, CNE_REVISA, NVL( SUM( CNE_VLTOT ), 0 ) CNE_VLTOT "
	cSQL += "FROM   "+RetSqlName("CNE")+" CNE "
	cSQL += "       INNER JOIN "+RetSqlName("CND")+" CND "
	cSQL += "              ON CND_FILIAL = "+ValToSql(xFilial("CND"))+" "
	cSQL += "             AND CND_CONTRA = CNE_CONTRA "
	cSQL += "             AND CND_NUMMED = CNE_NUMMED "
	cSQL += "             AND CND_DTFIM <> ' ' "
	cSQL += "             AND CND.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  CNE_FILIAL = "+ValToSql(xFilial("CNE"))+" "
	cSQL += "       AND CNE_CONTRA BETWEEN '                   ' AND '999999999999999' "
	cSQL += "       AND CNE_REVISA BETWEEN '   ' AND '999' "
	cSQL += "       AND CNE.D_E_L_E_T_ = ' ' "
	cSQL += "GROUP BY CNE_CONTRA, CNE_REVISA "
	cSQL += "ORDER BY CNE_CONTRA, CNE_REVISA "
	
	dbUseArea( .T., 'TOPCONN', TcGenQry( , , cSQL ), cTRB, .T., .T. )
	ProcRegua( 0 )
	While (cTRB)->( .NOT. EOF() )
		IncProc()
		If (cTRB)->CNE_VLTOT > 0
			CN9->( dbSetOrder( 1 ) )
			If CN9->( dbSeek( cCN9_FILIAL + (cTRB)->CNE_CONTRA + (cTRB)->CNE_REVISA ) )
				CN9->( RecLock( 'CN9', .F. ) )
				CN9->CN9_MEDACU := (cTRB)->CNE_VLTOT
				CN9->( MsUnLock() )
			Endif
		Endif
		(cTRB)->( dbSkip() )
	End
Return

//-----------------------------------------------------------------------
// Rotina | A590AtuSaldo| Autor | Rafael Beghini     | Data | 12.09.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para atualizar o saldo do contrato conforme medição 
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A590AtuSaldo(cCN9_NUMERO,cCN9_REVISA,cNUMMED,cSum)
	Local nCN9_SALDO := 0
	Local cSQL  := ''
	Local cOPER := ''
	Local cTRB := GetNextAlias()
	
	//cSQL += "SELECT ( NVL(Sum(CNQ_VALOR), 0) - NVL(Sum(CNR.CNR_VALOR), 0) ) + NVL(Sum(CNR1.CNR_VALOR), 0) CNE_VLTOT" + CRLF
	//cSQL += "SELECT ( NVL(Sum(CNE_VLTOT), 0) - ( NVL(Sum(CNQ_VALOR), 0) - NVL(Sum(CNR.CNR_VALOR), 0) ) ) + NVL(Sum(CNR1.CNR_VALOR), 0) - NVL(Sum(CNE_VLTOT), 0) CNE_VLTOT" + CRLF
	
	cSQL += "SELECT case when NVL(Sum(CNQ_VALOR), 0) > 0" + CRLF
	cSQL += "then 'SUB'" + CRLF
	cSQL += "when NVL(Sum(CNR.CNR_VALOR), 0) > 0" + CRLF
	cSQL += "then 'SUB'" + CRLF
	cSQL += "when NVL(Sum(CNR1.CNR_VALOR), 0) > 0" + CRLF
	cSQL += "then 'ADD'" + CRLF
	cSQL += "END OPERACAO," + CRLF
	cSQL += "case when NVL(Sum(CNQ_VALOR), 0) > 0" + CRLF
	cSQL += "THEN NVL(Sum(CNQ_VALOR), 0) " + CRLF
	cSQL += "ELSE" + CRLF
	cSQL += "( NVL(Sum(CNE_VLTOT), 0) - ( NVL(Sum(CNQ_VALOR), 0) - NVL(Sum(CNR.CNR_VALOR), 0) ) ) + NVL(Sum(CNR1.CNR_VALOR), 0) - NVL(Sum(CNE_VLTOT), 0)" + CRLF
	cSQL += "END VALOR" + CRLF
	cSQL += "FROM   " + RetSqlName("CNE") + " CNE " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("CND") + " CND " + CRLF
	cSQL += "               ON CND_FILIAL = CNE_FILIAL " + CRLF
	cSQL += "                  AND CND_CONTRA = CNE_CONTRA " + CRLF
	cSQL += "                  AND CND_NUMMED = CNE_NUMMED " + CRLF
	IF cSum == '0'
		cSQL += "                  AND CND_DTFIM <> ' '  " + CRLF
	EndIF
	cSQL += "                  AND CND.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT JOIN " + RetSqlName("CNQ") + " CNQ " + CRLF
	cSQL += "              ON CNQ_FILIAL = CNE_FILIAL " + CRLF
	cSQL += "                 AND CNQ_CONTRA = CNE_CONTRA " + CRLF
	cSQL += "                 AND CNQ_NUMMED = CNE_NUMMED " + CRLF
	cSQL += "                 AND CNQ.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT JOIN " + RetSqlName("CNR") + " CNR " + CRLF
	cSQL += "              ON CNR.CNR_FILIAL = CNE_FILIAL " + CRLF
	cSQL += "                 AND CNR.CNR_CONTRA = CNE_CONTRA " + CRLF
	cSQL += "                 AND CNR.CNR_NUMMED = CNE_NUMMED " + CRLF
	cSQL += "                 AND CNR.CNR_TIPO = '1' " + CRLF
	cSQL += "                 AND CNR.CNR_FLGPED = '1' " + CRLF
	cSQL += "                 AND CNR.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       LEFT JOIN " + RetSqlName("CNR") + " CNR1 " + CRLF
	cSQL += "              ON CNR1.CNR_FILIAL = CNE_FILIAL " + CRLF
	cSQL += "                 AND CNR1.CNR_CONTRA = CNE_CONTRA " + CRLF
	cSQL += "                 AND CNR1.CNR_NUMMED = CNE_NUMMED " + CRLF
	cSQL += "                 AND CNR1.CNR_TIPO = '2' " + CRLF
	cSQL += "                 AND CNR1.CNR_FLGPED = '1' " + CRLF
	cSQL += "                 AND CNR1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  CNE_FILIAL = " + ValToSql(xFilial("CNE"))  + " " + CRLF
	cSQL += "       AND CNE_CONTRA = " + ValToSql(cCN9_NUMERO) + " " + CRLF
	cSQL += "       AND CNE_REVISA = " + ValToSql(cCN9_REVISA) + " " + CRLF
	cSQL += "       AND CNE_NUMMED = " + ValToSql(cNUMMED)     + " " + CRLF
	cSQL += "       AND CNE.D_E_L_E_T_ = ' ' "
	
	// Executar a query.
	dbUseArea( .T., 'TOPCONN', TcGenQry( , , cSQL ), cTRB, .T., .T. )
	// Capturar o retorno do somatório.
	nCN9_SALDO := (cTRB)->VALOR
	cOPER      := (cTRB)->OPERACAO
	// Fechar o Alias temporário.
	(cTRB)->( dbCloseArea() )
	// Se a chave dos registros for diferente da chave do registro da medição.
	If CN9->CN9_NUMERO <> cCN9_NUMERO .AND. CN9->CN9_REVISA <> cCN9_REVISA
		// Reposicionar o registro do contrato.
		CN9->( dbSetOrder( 1 ) )
		CN9->( dbSeek( xFilial( 'CN9' ) + cCN9_NUMERO + cCN9_REVISA ) )
	Endif
	// Gravar o valor da medição acumulada.
	CN9->( RecLock( 'CN9', .F. ) )
	IF cSum == '0'
		IF cOPER == 'ADD'
			CN9->CN9_SALDO -= nCN9_SALDO
		Else
			CN9->CN9_SALDO += nCN9_SALDO
		EndIF
	Else
		IF cOPER == 'ADD'
			CN9->CN9_SALDO += nCN9_SALDO
		Else
			CN9->CN9_SALDO -= nCN9_SALDO
		EndIF
	EndIF
	CN9->( MsUnLock() )
Return