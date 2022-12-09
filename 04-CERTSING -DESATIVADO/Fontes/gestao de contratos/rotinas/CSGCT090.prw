#Include 'Protheus.ch'
#DEFINE cFONT   '<b><font size="5" color="red"></b><u>'
#DEFINE cFONTOK '<b><font size="4" color="black">'
#DEFINE cNOFONT '</b></font></u></b> '
//+-------------------------------------------------------------------+
//| Rotina | CSGCT090 | Autor | Rafael Beghini | Data | 09.03.2018 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para alterar o usuário no processo de Notificação
//|        | de e-Mails nos processos de Contratos
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSGCT090()
	Local aSay	 := {}
	Local aBtn	 := {}
	Local aRET	 := {}
	Local aPAR	 := {}
	Local aUsr   := {}
	Local cMsg	 := ''
	Local cUsrDe := ''
	Local cUsrPr := ''
	Local nOpc	 := 0
	Local cWhen1 := "IIf( ValType( Mv_par01 ) == 'C', Subs(Mv_par01,1,1), LTrim( Str( Mv_par01, 1, 0 ) ) ) == '2'"
	Local cWhen2 := "IIf( ValType( Mv_par01 ) == 'C', Subs(Mv_par01,1,1), LTrim( Str( Mv_par01, 1, 0 ) ) ) == '1'"
	Local cXopc	 := ''
	Local cTexto := ''
	
	Private cCadastro := 'Alteração de usuário - Notificações [CSGCT090]'
	
	AAdd( aSay, 'O objetivo desta rotina é incluir/alterar o usuário das Notificações de contratos.' )
	AAdd( aSay, 'Será verificado em todos os contratos vigentes o código do usuário informado,' )
	AAdd( aSay, 'e alterado para o novo código do usuário.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	AAdd( aBtn, { 1,.T.,{|| nOpc := 1,FechaBatch() }} )
	AAdd( aBtn, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cCadastro, aSay, aBtn )
	
	IF nOpc == 1
		aAdd(aPAR,{2,"Operação",2,{"1.Inclusão","2.Alteração","3.Exclusão"},60,"", .F.})
		aAdd(aPAR,{1,"Usuário de"	,Space(06),"","","GCT040",""		,50,.T.}) // Tipo caractere
		aAdd(aPAR,{1,"Usuário para"	,Space(06),"","","GCT040",cWhen1	,50,.F.}) // Tipo caractere
		aAdd(aPAR,{1,"Área"			,Space(06),"","","X5_Z05",cWhen2	,40,.F.}) // Tipo caractere
		
		IF ParamBox(aPAR,"",@aRET)
			cXopc := IIf( ValType( aRET[1] ) == 'C', Subs(aRET[1],1,1), LTrim( Str( aRET[1], 1, 0 ) ) )
			
			PswOrder( 1 )
			IF PswSeek( aRET[2], .T. )
				aUsr := PswRet()
				cUsrDe := RTrim(aUsr[1,4])
			Else
				MsgStop('Usuário "de" não localizado', cCadastro)
				Return
			EndIF
			
			IF cXopc=='2'
				PswOrder( 1 )
				IF PswSeek( aRET[3], .T. )
					aUsr := PswRet()
					cUsrPr := RTrim(aUsr[1,4])
				Else
					MsgStop('Usuário "para" não localizado', cCadastro)
					Return
				EndIF
			EndIF
			
			IF cXopc == '1'
				cText := 'inclusão'
			ElseIF cXopc == '1'
				cText := 'alteração'
			Else
				cText := 'exclusão'
			EndIF
			
			cMsg += '	<body>' + CRLF
			cMsg += '			<span style="font-size:12px;"><span style="font-family: courier\ new, courier, monospace;"><font color="red">Atenção,<br />' + CRLF
			cMsg += '			<font color="black">Você confirma a ' + cText + ' do usuário: </font></font><br />' + CRLF
			cMsg += '			<span style="color:#0000ff;"><b>' + cUsrDe + '</b></span><br />' + CRLF
			IF cXopc=='2'
				cMsg += '			<font color="red"><font color="black">para o usuário:</font></font><br />' + CRLF
				cMsg += '			<span style="color:#0000ff;"><b>' + cUsrPr + '</b></span><br />' + CRLF
			EndIF
			cMsg += '			<font color="red"><font color="black"><b><font color="black"><em>'
			cMsg += 'Após a confirmação, não será possível cancelar.</em></font></b></font></font></span></span>' + CRLF
			cMsg += '	</body>' + CRLF
			
			IF MsgYesNo(cMsg,cCadastro)
				Processa( {|| A090Proc( aRET, cXopc ) }, cCadastro, 'Processando os dados, aguarde...', .F. )
			EndIF
			
		Else
			MsgInfo('Processo cancelado pelo usuário', cCadastro)
		EndIF
	EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A090Proc | Autor | Rafael Beghini | Data | 09.03.2018 
//+-------------------------------------------------------------------+
//| Descr. | Realiza a alteração
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A090Proc(aRET, cOpc)
	Local cSQL	:= ''
	Local cTRB	:= ''
	Local cDado := ''
	Local cHistory := ''
	Local cUser	:= ''
	Local cNoteVen := ''
	Local lOK	:= .T.
	Local aOPC	:= {}
	
	ProcRegua(0)
	
	IF cOpc <> '3'
		aOPC := A090Choice()
	
		IF Empty( aOPC )
			ApMsgInfo('Não foi selecionado o tipo de Notificação, o processo será cancelado.',cCadastro)
			Return
		EndIF
	EndIF
	
	cSQL += "SELECT " + CRLF
	cSQL += "       CN9.R_E_C_N_O_ AS CN9_RECNO," + CRLF
	cSQL += "       UTL_RAW.CAST_TO_VARCHAR2(CN9_NOTVEN) AS CN9_NOTVEN" + CRLF
	cSQL += "FROM " + RetSqlName('CN9') + " CN9 " + CRLF
	cSQL += "WHERE  CN9.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "       AND CN9_SITUAC = '05'" + CRLF
	IF cOpc == '1' //Inclusão
		cSQL += " AND CN9_XAREA = '" + aRET[4] + "'" + CRLF
	Else
		cSQL += " AND UTL_RAW.CAST_TO_VARCHAR2(CN9_NOTVEN) LIKE '%" + aRET[2] + "%' " + CRLF
	EndIF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		ApMsgInfo('Não foram encontrados contratos na situação vigente para este usuário.',cCadastro)
		Return
	Endif
	
	
	While .NOT. (cTRB)->( EOF() )
		IncProc()
		
		IF cOpc == '1'
			For nL := 1 To Len( aOPC )
				IF aOPC[nL,1]
					cDado += aOPC[nL,2] + '=' + aRET[2] + ';;'
				EndIF
			Next nL
			cHistory := 'Mensagem informativa: Incluído o usuário [' + aRET[2] + '], por '
		ElseIF cOpc == '2'
			cHistory := 'Mensagem informativa: Alterado o usuário [' + aRET[2] + '] para [' + aRET[3] + '], por '
		Else
			cHistory := 'Mensagem informativa: Excluído o usuário [' + aRET[2] + '], por '
		EndIF
		
		cUser := RTrim( UsrFullName( __cUserID ) )+' em '+Dtoc( MsDate() )+' as '+Time()+' [CSGCT090].'
		cHistory := cHistory + cUser
		
		CN9->( dbGoto( (cTRB)->CN9_RECNO ) )
		CN9->( RecLock('CN9',.F.) )
		IF cOpc == '1'
			CN9->CN9_NOTVEN := CN9->CN9_NOTVEN + cDado
		ElseIF cOpc == '2'
			CN9->CN9_NOTVEN := StrTran( CN9->CN9_NOTVEN, aRET[2], aRET[3] )
		Else
			CN9->CN9_NOTVEN := StrTran( CN9->CN9_NOTVEN, aRET[2], '' )
			cNoteVen := CN9->CN9_NOTVEN
			
			For n1 := 1 To 7
				cNoteVen := StrTran( cNoteVen, cValToChar(n1)+'=;;', '' )	
			Next n1
			cNoteVen := StrTran( cNoteVen, 'X=;;', '' )
			CN9->CN9_NOTVEN := cNoteVen
		EndIF
		
		CN9->CN9_MOTALT := IIF( Empty(CN9->CN9_MOTALT), cHistory, AllTrim( CN9->CN9_MOTALT ) + CRLF + CRLF + cHistory )
		CN9->( MsUnLock() )	
		
		(cTRB)->( dbSkip() )
		cDado := ''	
	End
	
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	IF lOK
		ApMsgInfo('Processo finalizado com sucesso.',cCadastro)
	EndIF
Return

//---------------------------------------------------------------------------------
// Rotina | A090Choice | Autor | Rafael Beghini               | Data | 20/03/2018
//---------------------------------------------------------------------------------
// Descr. | Rotina para selecionar o tipo de Notificação
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A090Choice()
	Local oDlg
	Local oLbx
	Local oPanelTop
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Local cCodApr := ''
	Local aDados := {}
	
	Local lOk := .F.
	Local lMark := .F.
	
	AAdd( aDados, {.F.,'1','Caução'    } )
	AAdd( aDados, {.F.,'2','Medição'   } )
	AAdd( aDados, {.F.,'3','Planilha'  } )
	AAdd( aDados, {.F.,'4','Reajuste'  } )
	AAdd( aDados, {.F.,'5','Revisão'   } )
	AAdd( aDados, {.F.,'6','Situação'  } )
	AAdd( aDados, {.F.,'7','Vencimento'} )
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Escolha o tipo de notificação' PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,19,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
	   	oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 20,05 LISTBOX oLbx FIELDS HEADER ;
		' x ','Código','Descrição' ;
		SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(cCodApr := aDados[ oLbx:nAt, 2 ], AEval( aDados, {|e| Iif( cCodApr==e[2],(e[1]:=.NOT.e[1]), NIL )}),oLbx:Refresh())
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray(aDados)
		oLbx:bLine := { || {Iif(aDados[oLbx:nAt,1],oOk,oNo),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aDados, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os registros...') }
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A090VldArea(aDados,@lOk),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (aDados := {},oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER

Return( aDados )

//---------------------------------------------------------------------------------
// Rotina | A090VldArea | Autor | Rafael Beghini               | Data | 20/03/2018
//---------------------------------------------------------------------------------
// Descr. | Rotina para validar se escolheu algum registro.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A090VldArea( aDados, lOk )
	Local nP := 0
	Local lRet := .T.
	nP := AScan( aDados, {|p| p[ 1 ] } )
	lOk := ( nP > 0 )
	If .NOT. lOk
		lRet := .F.
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Não foi selecionado nenhum código.', '[A090VldArea]' )
	Endif
Return( lRet )