// Rotina | CSFA860  | Autor | Robson Gonçalves          | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina de cadastro de motivos para concessão de voucher. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'

// Array com dados sintéticos.
STATIC aDADPED := {} //Dados do pedido.
STATIC aTRILHA := {} //Trilha de auditoria.

// Array com dados completos.
STATIC aDadosP := {} //Dados do pedido.
STATIC aDadosT := {} //Trilha de auditoria.
STATIC c860IdPed := ''

STATIC a860Feriado := { { Ctod( '01/01/1980' ), Ctod( '01/01/1980' ) } }
STATIC a860Operad := {}

STATIC c860EMailT := ''
STATIC c860NomeT := ''

User Function CSFA860()
	Local aGrpUser := {}
	Local cCodUser := ''
	Local cMV_860_05 := 'MV_860_05'
	Local lGrpAdm := .F.
	
	Private aRotina := {}
	Private cCadastro := 'Motivos para concessão de voucher'
	
	A860Dic()
	
	dbSelectArea('Z00')
	dbSetOrder(1)
	
	cMV_860_05 := GetMv( cMV_860_05, .F. )
		
	cCodUser := RetCodUsr()
	aGrpUser := UsrRetGrp(,cCodUser)
	lGrpAdm := (AScan( aGrpUser, '000000' )>0)
	
	AAdd( aRotina, {'Pesquisar' ,'AxPesqui', 0, 1 } )
	AAdd( aRotina, {'Visualizar','AxVisual', 0, 2 } )
	
	//AAdd( aRotina, {'Incluir'   ,'AxInclui', 0, 3 } )
	//AAdd( aRotina, {'Alterar'   ,'AxAltera', 0, 4 } )
	
	AAdd( aRotina, {'Incluir'   ,'U_A860MANUT(1)', 0, 3 } )
	AAdd( aRotina, {'Alterar'   ,'U_A860MANUT(2)', 0, 4 } )

	If lGrpAdm
		AAdd( aRotina, {'Excluir' ,'AxDelete', 0, 5 } )
	Endif
	
	AAdd( aRotina, {'Bloquear',   'U_A860Blq( "'+cCodUser+'" )'  , 0, 6 } )
	AAdd( aRotina, {'Debloquear', 'U_A860DBlq( "'+cCodUser+'" )' , 0, 6 } )
	
	If ( __cUserId $ cMV_860_05 )
		AAdd( aRotina, {'Parâmetros' ,'U_A860SupV', 0, 6 } )
	Endif
	
	MBrowse(,,,,'Z00')
Return

User Function A860Manut( nFunc )
	Local cTudOk := 'U_A860Valid()'
	If nFunc == 1
		AxInclui("Z00",Z00->(RecNo()),3,,,,cTudOk)
	Else
		AxAltera("Z00",Z00->(RecNo()),4,,,,,cTudOk)
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A860SupV   | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/alterar o conteúdo do parâmetro p/filtrar grp de atend.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860SupV()
	Local aPar := {}
	Local aRet := {}
	Local cGet := GetMv('MV_860_04')
	
	cGet := PadR( cGet, 99, ' ' )
	
	AAdd( aPar, { 1, 'Códigos dos grupos de atendimento', cGet, '@S90', '', '', '', 99, .F. } )
	
	If ParamBox( aPar, '', @aRet, , , , , , , , .F., .F. )
		PutMv( 'MV_860_04', aRet[ 1 ] )
		MessageBox('Operação realizada com sucesso.','Parâmetro gravado',0)		
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A860Blq  | Autor | Robson Gonçalves          | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para bloquear o registro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860Blq( cCodUser )
	Local aPar := {}
	Local aRet := {}
	
	Local cQuem := ''
	Local cMotivo := ''
	Local cTitulo := 'Motivo do bloqueio'
	
	dbSelectArea('Z00')
	dbSetOrder(1)

	If Z00->Z00_MSBLQL <> '1'
		AAdd(aPar,{11,'Motivo do bloqueio','','.T.','.T.',.T.})
	
		If ParamBox(aPar,'',@aRet,,,,,,,,.F.,.F.)
			cMotivo := AllTrim( aRet[ 1 ] )
			If cMotivo <> ''
				cQuem := Dtoc( MsDate() ) + ' ' + Time() + ' ' + RTrim( UsrFullName( cCodUser ) ) + ' - Bloqueou o registro com o motivo: '
				Z00->( RecLock( 'Z00', .F. ) )
				Z00->Z00_MSBLQL := '1'
				Z00->Z00_MOTIVO := Iif( Empty( Z00->Z00_MOTIVO ), '', ( AllTrim( Z00->Z00_MOTIVO ) + CRLF ) ) + cQuem + ' ' + cMotivo
				Z00->( MsUnLock() )
				MessageBox('Operação realizada com sucesso.',cTitulo,0)
			Endif
		Else
			MsgAlert('Operação NÃO realizada.',cTitulo)
		Endif
	Else
		MsgAlert('Registro encontra-se bloqueado.',cTitulo)
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A860DBlq | Autor | Robson Gonçalves          | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para desbloquear o registro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860DBlq( cCodUser )
	Local aPar := {}
	Local aRet := {}
	
	Local cQuem := ''
	Local cMotivo := ''
	Local cTitulo := 'Motivo do debloqueio'
	
	dbSelectArea('Z00')
	dbSetOrder(1)

	If Z00->Z00_MSBLQL == '1'
		AAdd(aPar,{11,'Motivo do desbloqueio','','.T.','.T.',.T.})
	
		If ParamBox(aPar,'',@aRet,,,,,,,,.F.,.F.)
			cMotivo := AllTrim( aRet[ 1 ] )
			If cMotivo <> ''
				cQuem := Dtoc( MsDate() ) + ' ' + Time() + ' ' + RTrim( UsrFullName( cCodUser ) ) + ' - Desbloqueou o registro com o motivo: '
				Z00->( RecLock( 'Z00', .F. ) )
				Z00->Z00_MSBLQL := '2'
				Z00->Z00_MOTIVO := Iif( Empty( Z00->Z00_MOTIVO ), '', ( AllTrim( Z00->Z00_MOTIVO ) + CRLF ) ) + cQuem + ' ' + cMotivo
				Z00->( MsUnLock() )
				MessageBox('Operação realizada com sucesso.',cTitulo,0)
			Endif
		Else
			MsgAlert('Operação NÃO realizada.',cTitulo)
		Endif
	Else
		MsgAlert( 'Registro encontra-se desbloqueado', cTitulo )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A860Valid  | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ validar o cadastro do tipo de voucher.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860Valid()
	If ( M->Z00_GARANT > 0 .AND. Empty( M->Z00_CONTAG ) ) .OR. ( M->Z00_GARANT == 0 .AND. .NOT. Empty( M->Z00_CONTAG ) ) 
		MsgAlert( 'Ao informar Garantia é necessário informar também qual é o tipo de contagem, o inverso também é verdadeiro.', cCadastro )
		Return( .F. )
	Endif
	If ( M->Z00_HRREV > 0 .AND. Empty( M->Z00_TPHRRE ) ) .OR. ( M->Z00_HRREV == 0 .AND. .NOT. Empty( M->Z00_TPHRRE ) ) 
		MsgAlert( 'Ao informar a quantidade de Horas para Revogar é necessário informar também qual é o tipo de Horas, o inverso também é verdadeiro.', cCadastro )
		Return( .F. )
	Endif
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A860GrAt   | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ selecionar o grupo de atendimento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860GrAt()
	Local aDados := {}
	Local aOrdem := {}
	
	Local cCodAte := ''
	Local cField := ReadVar()
	Local cMV_860_04 := 'MV_860_04'
	Local cOrd := ''
	Local cReadVar := RTrim(&(ReadVar()))
	Local cSeek := Space(100)
	Local cSQL := ''
	Local cRet := ''
	Local cTRB := ''
	
	Local lMark := .F.
	Local lOk := .F.
	
	Local nI := 0
	Local nL := 0
	Local nOrd := 1
	
	Local oCancel 
	Local oConfirm
	Local oDlg
	Local oLbx
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oOrdem
	Local oPesq 
	Local oSeek
	Local oPanelAll
	Local oPanelBot
	Local oPanelTop

	AAdd(aOrdem,'Código do grupo') 
	AAdd(aOrdem,'Descrição do grupo') 
	
	cMV_860_04 := GetMv( cMV_860_04, .F. )
	
	cSQL := "SELECT '0' AS MARK,"
	cSQL += "       U0_CODIGO,"
	cSQL += "       U0_NOME"
	cSQL += "FROM   "+RetSqlName("SU0")+" SU0 "
	cSQL += "WHERE  U0_FILIAL = "+ValToSql(xFilial("SU0"))+" "
	If .NOT. Empty( cMV_860_04 ) .AND. cMV_860_04 <> '*'
		cSQL += "       AND U0_CODIGO IN " + FormatIn( cMV_860_04, '/' ) + " "
	Endif
	cSQL += "       AND SU0.D_E_L_E_T_ = ' '"
	cSQL += "ORDER  BY U0_CODIGO, U0_NOME"
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)

	If (cTRB)->( .NOT. BOF() ) .And. (cTRB)->( .NOT. EOF() )
		While (cTRB)->( .NOT. EOF() )
			AAdd( aDados, Array((cTRB)->(FCount())))
			nL++
			For nI := 1 To Len( aDados[ nL ] )
				aDados[ nL, nI ] := (cTRB)->( FieldGet( nI ) )
			Next nI 
			lMark := ( aDados[ nL, 2 ] $ cReadVar )
			aDados[ nL, 1 ] := lMark
			(cTRB)->( dbSkip() )
		End
	Endif
   (cTRB)->( dbCloseArea() )
	
	lMark := .F.
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Escolha o(s) grupo(s) de atendimento(s)' PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
		@ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A860PsqGrp(nOrd,cSeek,@oLbx))

		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 40,05 LISTBOX oLbx FIELDS HEADER ' x ','Grupo','Descrição grupo'	SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(cCodAte := aDados[ oLbx:nAt, 2 ], AEval( aDados, {|e| Iif( cCodAte==e[2],(e[1]:=.NOT.e[1]), NIL )}),oLbx:Refresh())
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray(aDados)
		oLbx:bLine := { || {Iif(aDados[oLbx:nAt,1],oOk,oNo),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aDados, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os grupos de atendimento...') }
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A860VldGrp(aDados,@lOk),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lOk
		For nI := 1 To Len( aDados )
			If aDados[ nI, 1 ] .AND. (.NOT. aDados[ nI, 2 ] $ cRet)
				If (Len(cRet)+3) > 30
					MsgAlert('ATENÇÃO'+'<br><br>É possível a seleção de no máximo 10 grupos de atendimento.','Grupo de atendimento')
					Exit
				Endif
				cRet += aDados[ nI, 2 ] + '|'
			Endif
		Next nI
		cRet := PadR( SubStr( cRet, 1, Len( cRet )-1 ), Len( Z00->Z00_GRUPOS ), ' ' )
		&(cField) := cRet
	Endif
Return(.T.)

//--------------------------------------------------------------------------
// Rotina | A860PsqGrp | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ pesquisar o grupo de atendimento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860PsqGrp( nOrd, cSeek, oLbx )
	Local bScan := {|| }
	Local nBegin := 0
	Local nColPesq := 0
	Local nEnd := 0
	Local nP := 0
		
	If nOrd==1
		nColPesq := 2
		
	Elseif nOrd == 2
		nColPesq := 3
		
	Else
		MsgAlert('ATENÇÃO'+'<br><br>Opção não disponível para pesquisa.','Pesquisar')
		Return( .F. )
		
	Endif
	
	If nColPesq > 0
		nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:AArray )
		
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		
		bScan := {|e| Upper( AllTrim( cSeek ) ) $ AllTrim( e[ nColPesq ] ) }
		
		nP := AScan( oLbx:aArray, bScan, nBegin, nEnd )
		
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo('ATENÇÃO'+'<br><br>Informação não localizada.','Pesquisar')
		Endif
	Endif
Return(.T.)

//--------------------------------------------------------------------------
// Rotina | A860VldGrp | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ validar se foi selecionado ao menos um grupo de atend.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860VldGrp( aDados, lOk )
	Local nP := 0
	Local lRet := .T.
	nP := AScan( aDados, {|p| p[ 1 ] } )
	lOk := ( nP > 0 )
	If .NOT. lOk
		lRet := .F.
		MsgAlert('ATENÇÃO'+'<br><br>Não foi selecionado nenhum grupo de atendimento.', 'Validação da seleção de grupo' )
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A860VGA    | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ validar se o código do grupo de atendimento existe.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860VGA()
	Local nI := 0
	Local aGrp := {}
	Local cGrp := ''
	If .NOT. Empty( M->Z00_GRUPOS )	
	   	aGrp := StrToKarr( M->Z00_GRUPOS, '|' )
	   	For nI := 1 To Len( aGrp )
	   		cGrp := RTrim( aGrp[ nI ] )
	   		If .NOT. ExistCpo( 'SU0', cGrp, NIL, NIL, .F. )
	   			MsgAlert('ATENÇÃO'+'<br><br>Não existe grupo de atendimento com o código: '+cGrp+'.','Grupo de atendimento inválido')
	   			Return( .F. )
	   		Endif
	   	Next nI
	Endif
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A860Dic    | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ criar os dicionários de dados SXB e SX5.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860Dic()
	Local aSXB := {}
	
	AAdd( aSXB, { '860GRA', '1', '01', 'RE', 'Grupos de atendimento' , 'Grupos de atendimento' , 'Grupos de atendimento', 'SX5'          } )
	AAdd( aSXB, { '860GRA', '2', '01', '01', ''                      , ''                      , ''                     , '.T.'          } )
	AAdd( aSXB, { '860GRA', '5', '01', ''  , ''                      , ''                      , ''                     , 'U_A860GrAt()' } )	

	AAdd( aSXB, { '860GAR', '1', '01', 'RE', 'Pesquisa GAR', 'Pesquisa GAR', 'Pesquisa GAR', 'SZ5'        , ''    } )
	AAdd( aSXB, { '860GAR', '2', '01', '01', ''            , ''            , ''            , 'U_A860GAR()',''     } )
	AAdd( aSXB, { '860GAR', '5', '01', ''  , ''            , ''            , ''            , 'SZ5->Z5_PEDGAR', '' } )
	
	A860SXB( aSXB )
	A860SX5()
	A860SX6()
Return

//--------------------------------------------------------------------------
// Rotina | A860SXB | Autor | Robson Gonçalves           | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para criar a consulta SXB e atribuir o alias ao X3_F3.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860SXB( aSXB )
	Local aCpoXB := {}
	
	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
	
	SXB-> (dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aSXB )
		If .NOT. SXB->( dbSeek( aSXB[ nI, 1 ] + aSXB[ nI, 2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
			SXB->( RecLock( 'SXB', .T. ) )
			For nJ := 1 To Len( aSXB[ nI ] )
				SXB->( FieldPut( FieldPos( aCpoXB[ nJ ] ), aSXB[ nI, nJ ] ) )
			Next nJ
			SXB->( MsUnLock() )
		Endif
	Next nI
	
	SX3->( dbSetOrder( 2 ) )
	If SX3->( dbSeek( 'ADE_PEDGAR' ) )
		If SX3->X3_F3 <> '860GAR'
			SX3->( RecLock( 'SXB', .F. ) )
			SX3->X3_F3 := cXB_ALIAS
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A860SX5    | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ criar tabela genérica no SX5.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860SX5()
	Local aFilial := {}
	Local aPai := {}
	Local aFilho := {}
	Local nI := 0
	Local nJ := 0
	
	AAdd( aPai,  { '00', 're', 'REGRAS PARA CONCESSAO DE VOUCHER-SAC' } )
	
	AAdd( aFilho,{ 're', '01', 'CONFRONTAR SE O PEDIDO PERTENCE A PRODUTO A1' } )
	AAdd( aFilho,{ 're', '02', 'CONFRONTAR SE O PEDIDO PERTENCE A PRODUTO A3' } )
	AAdd( aFilho,{ 're', '03', 'CONSULTAR TRILHA SOMENTE EMISSÃO AR IGUAL SIM' } )
	AAdd( aFilho,{ 're', '04', 'CONSULTAR TRILHA SOMENTE EMISSAO FORA DA AR' } )
	AAdd( aFilho,{ 're', '05', 'ESTE VOUCHER JA EXISTE NO SISTEMA DEVE SER ENCAMINHADO O MESMO' } )
	AAdd( aFilho,{ 're', '06', 'SOMENTE N2' } )
	AAdd( aFilho,{ 're', '07', 'VERIFICAR O PRODUTO OAB-MG/RJ AGENDA RESTRITA' } )
	AAdd( aFilho,{ 're', '08', 'VERIFICAR SE O PEDIDO E DE RENOVACAO' } )
	AAdd( aFilho,{ 're', '09', 'VERIFICAR SE O PRODUTO E e-CPF' } )
	AAdd( aFilho,{ 're', '10', 'VERIFICAR SE O PRODUTO E e-PF' } )
	
	AAdd( aPai, { '00', 'tr', 'SIGLA - STATUS DA TRILHA DE AUDITORIA' } )
	
	AAdd( aFilho,{ 'tr', 'AFI','ANALISE DE FRAUDE INICIADA' } )
	AAdd( aFilho,{ 'tr', 'AFC','ANALISE DE FRAUDE CONCLUIDA' } )
	AAdd( aFilho,{ 'tr', 'AUT','REGISTRO DE AUTORIZACAO' } )
	AAdd( aFilho,{ 'tr', 'BLQ','PEDIDO BLOQUEADO - FRAUDE' } )
	AAdd( aFilho,{ 'tr', 'CEA','CLIQUE ENVIA ANALISE' } )
	AAdd( aFilho,{ 'tr', 'CIR','CONSULTA ITI REALIZADA' } )
	AAdd( aFilho,{ 'tr', 'DBL','DESBLOQUEAR' } )
	AAdd( aFilho,{ 'tr', 'DBQ','PEDIDO DESBLOQUEADO - FRAUDE' } )
	AAdd( aFilho,{ 'tr', 'EMI','EMISSAO' } )
	AAdd( aFilho,{ 'tr', 'EXT','EXIBIR TERMO' } )
	AAdd( aFilho,{ 'tr', 'IAT','INICIAR ATENDIMENTO' } )
	AAdd( aFilho,{ 'tr', 'INS','INSCRICAO' } )
	AAdd( aFilho,{ 'tr', 'IPV','LIBERAR VALIDACAO' } )
	AAdd( aFilho,{ 'tr', 'OBS','OBSERVACAO' } )
	AAdd( aFilho,{ 'tr', 'PAT','INTERROMPER ATENDIMENTO' } )
	AAdd( aFilho,{ 'tr', 'RCI','REGISTRAR COMO INTEGRADO' } )
	AAdd( aFilho,{ 'tr', 'REM','APROVAR' } )
	AAdd( aFilho,{ 'tr', 'REP','ENVIO PAGAMENTO' } )
	AAdd( aFilho,{ 'tr', 'RJT','REJEITAR PEDIDO' } )
	AAdd( aFilho,{ 'tr', 'RPG','REGISTRO PAGAMENTO' } )
	AAdd( aFilho,{ 'tr', 'RRG','VALIDAR' } )
	AAdd( aFilho,{ 'tr', 'RRN','PEDIDO DE RENOVACAO' } )
	AAdd( aFilho,{ 'tr', 'RRV','REVOGACAO' } )
	AAdd( aFilho,{ 'tr', 'RVD','REVALIDAR PEDIDO' } )
	AAdd( aFilho,{ 'tr', 'TRS','ALTERAR SENHA' } )
	AAdd( aFilho,{ 'tr', 'UPD','ALTERACAO CADASTRO' } )
	AAdd( aFilho,{ 'tr', 'WLA','ACESSO A VERIFICACAO WORKFLOW' } )
	AAdd( aFilho,{ 'tr', 'WLV','ACESSO A VALIDACAO WORKFLOW' } )
		
	aFilial := FWAllFilial(,,,.T.)
	
	SX5->( dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aFilial )
		If .NOT. SX5->( dbSeek( aFilial[ nI ] + aPai[ 1, 1 ] + aPai[ 1, 2 ] ) )
			SX5->( RecLock( 'SX5', .T. ) )
			SX5->X5_FILIAL  := aFilial[ nI ] 
			SX5->X5_TABELA  := aPai[ 1, 1 ]
			SX5->X5_CHAVE   := aPai[ 1, 2 ]
			SX5->X5_DESCRI  := aPai[ 1, 3 ]
			SX5->X5_DESCSPA := aPai[ 1, 3 ]
			SX5->X5_DESCENG := aPai[ 1, 3 ]
			SX5->( MsUnLock() )
		Endif
		
		For nJ := 1 To Len( aFilho )
			If .NOT. SX5->( dbSeek( aFilial[ nI ] + aFilho[ nJ, 1 ] + aFilho[ nJ, 2 ] ) ) 
				SX5->( RecLock( 'SX5', .T. ) )
				SX5->X5_FILIAL  := aFilial[ nI ] 
				SX5->X5_TABELA  := aFilho[ nJ, 1 ]
				SX5->X5_CHAVE   := aFilho[ nJ, 2 ]
				SX5->X5_DESCRI  := aFilho[ nJ, 3 ]
				SX5->X5_DESCSPA := aFilho[ nJ, 3 ]
				SX5->X5_DESCENG := aFilho[ nJ, 3 ]
				SX5->( MsUnLock() )
			Endif
		Next nJ
	Next nI
Return

//--------------------------------------------------------------------------
// Rotina | A860SX6    | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ criar os parâmetros sistêmicos SX6.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860SX6()
	Local aParam := {}
	Local nI := 0
	
	AAdd( aParam, { 'MV_860_01', 'C', 'LOGIN DE INTEGRACAO GAR, METODO findDadosPedido. ROTINA CSFA860.prw.', 'erp' } )
	AAdd( aParam, { 'MV_860_02', 'C', 'PASSWORD DE INTEGRACAO GAR, METODO findDadosPedido. ROTINA CSFA860.prw.', 'password123' } )
	AAdd( aParam, { 'MV_860_03', 'C', 'NOME DO ARQUIVO COM AS AÇÕES DO GAR NA TRILHA DE AUDITORIA. ROTINA CSFA860.prw.', 'csfa860.ini' } )
	AAdd( aParam, { 'MV_860_04', 'C', 'DETERMINAR OS GRUPOS DE ATENDIMENTO P/ O MOTIVO DE VOUCHER. (*) P/ TODOS. ROTINA CSFA860.prw.', '*' } )
	AAdd( aParam, { 'MV_860_05', 'C', 'ID DOS USUARIOS QUE PODEM MODIFICAR O MV_860_04. ROTINA CSFA860.prw.', '001101/000252/000445' } ) //001101-Roberval/000252-Patricia Ortega/000445-Consult2
	AAdd( aParam, { 'MV_860_06', 'C', 'STATUS TRILHA DE AUDITORIA - AGUARDANDO VALIDACAO. ROTINA CSFA860.prw.', 'CIR|EXT|IAT|INS|IPV|OBS|PAT|REP|REJ|RPG|EEG|UPD' } )
	AAdd( aParam, { 'MV_860_07', 'C', 'STATUS TRILHA DE AUDITORIA - AGUARDANDO VERIFICACAO. ROTINA CSFA860.prw.', 'REM|RJT|RVD' } )
	AAdd( aParam, { 'MV_860_08', 'C', 'STATUS TRILHA DE AUDITORIA - APROVADO E EMITIDO. ROTINA CSFA860.prw.', 'DBL|RVD' } )
	AAdd( aParam, { 'MV_860_09', 'C', 'STATUS TRILHA DE AUDITORIA - APROVADO E NAO EMITIDO. ROTINA CSFA860.prw.', 'EMI|RRV' } )
	AAdd( aParam, { 'MV_860_10', 'C', 'STATUS TRILHA DE AUDITORIA - EXCECAO. ROTINA CSFA860.prw.', 'AFI|AFC|AUT|BLQ|CEA|DBQ|RCI|TRS|WLA|WLV' } )
	AAdd( aParam, { 'MV_860_11', 'C', 'LINK PARA REENVIO DE SENHA PARA REVOGAR PEDIDO. ROTINA CSFA860.prw.', 'https://gestaoar-teste.certisign.com.br/reenvioSenhaRevogacao/' } )
	
	For nI := 1 To Len( aParam )
		If .NOT. GetMv( aParam[ nI, 1 ], .T. )
			CriarSX6( aParam[ nI, 1 ], aParam[ nI, 2 ], aParam[ nI, 3 ],  aParam[ nI, 4 ] )
		Endif
	Next nI
Return

//--------------------------------------------------------------------------
// Rotina | A860GPTA   | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina acionado pelo gatilho do campo Z00_STAPED para atribuir
//        | valor ao campo Z00_PARTRI.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860GPTA() // Gatilho Parâmetros Trilha de Auditoria.
	Local cRet := Space( Len( Z00->Z00_PARTRI ) )
	If M->Z00_STAPED == '1'
		cRet := "MV_860_06"
	Elseif M->Z00_STAPED == '2'
		cRet := "MV_860_07"
	Elseif M->Z00_STAPED == '3'
		cRet := "MV_860_08"
	Elseif M->Z00_STAPED == '4'
		cRet := "MV_860_09"
	Else
		MsgAlert('Opção de status de pedido indisponível.', 'Inconsistência' )
	Endif	
Return( cRet )

//--------------------------------------------------------------------------
// Rotina | A860MPTA   | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina de manutenção nos parâmetros que vinculam a sigla da 
//        | trilha de auditoria com o motivo de concessão de voucher.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860MPTA() // Manutenção nos Parâmetros da Trilha de Auditoria.
	Local aPar := {}
	
	Local aSX5 := {}
	
	Local cFile := ''
	Local cPar := ''
	Local cMV_PAR := ''
	
	Local nI := 0
	Local nHdl := 0
	Local nPar := 1
	
	Local oAlt
	Local oBold
	Local oDlg
	Local oInc
	Local oMrk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNoMrk := LoadBitmap(,'NGCHECKNO.PNG')
	Local oPanelAll
	Local oPanelBot
	Local oPanelTop
	Local oPar
	Local oSai
	Local oVin
	
	Private aLogParam := {}
	
	Private cCadastro := 'Parâmetros de vinculo do Status do Pedido GAR x Siglas da Trilha de Auditoria' 
	
	DEFINE FONT oBold NAME 'Arial' SIZE 0, -12 BOLD
	
	AAdd( aLogParam, 'USUÁRIO: ' + __cUserId + ' ' + RTrim( UsrRetName( __cUserId ) ) + ' DATA: ' + Dtoc( MsDate() ) + ' HORA: ' + Time() )
	AAdd( aLogParam, 'ANTES DA ALTERAÇÃO' + Replicate( '-', 82 ) )
	
	aPar := StrTokArr( SX3->( Posicione( 'SX3', 2, 'Z00_STAPED'  , 'X3CBox()' ) ), ';' )
	
	AAdd( aPar, 'X=Exceção' )
	
	cMV_PAR := GetMv( 'MV_860_06' )
	
	A860LoadTr( @aSX5, cMV_PAR )
	
	For nI := 1 To Len( aSX5 )
		AAdd( aLogParam, Iif( aSX5[ nI, 1 ],'X',' ') + '-' + RTrim( aSX5[ nI, 2 ] ) + '-' + RTrim( aSX5[ nI, 3 ] ) )
	Next nI
	
	DEFINE MSDIALOG oDlg FROM  0,0 TO 350,700 TITLE cCadastro PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,20,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
		@ 4,003 SAY 'Status do Pedido GAR' SIZE 110,10 PIXEL OF oPanelTop FONT oBold
		@ 3,070 COMBOBOX oPar VAR cPar ITEMS aPar SIZE 100,36 ON CHANGE (nPar:=oPar:nAt, A860MrkSig( @oLbx, nPar, oMrk, oNoMrk )) PIXEL OF oPanelTop
		
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		oLbx := TwBrowse():New(1,1,1000,1000,,{'','Sigla','Descrição'},,oPanelAll,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbx:SetArray( aSX5 )
		oLbx:bLine := {|| { Iif( aSX5[ oLbx:nAt, 1 ], oMrk, oNoMrk ), aSX5[ oLbx:nAt, 2 ], aSX5[ oLbx:nAt ,3 ] } }
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:bLDblClick := {|| oLbx:aArray[ oLbx:nAt, 1 ] :=  .NOT. oLbx:aArray[ oLbx:nAt, 1 ] }

		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 1,  1 BUTTON oInc PROMPT 'Incluir Sigla';
		        SIZE 60,11;
		        PIXEL OF oPanelBot; 
		        ACTION (A860IncPar(),A860Reload( @oLbx, nPar, oMrk, oNoMrk ))
		        
		@ 1, 64 BUTTON oAlt;
		        PROMPT 'Alterar Sigla';
		        SIZE 60,11;
		        PIXEL OF oPanelBot; 
		        ACTION (A860AltPar(oLbx),A860Reload( @oLbx, nPar, oMrk, oNoMrk ))
		        
		@ 1,127 BUTTON oVin;
		        PROMPT 'Gravar Vínculo do Status X Siglas';
		        SIZE 90,11;
		        PIXEL OF oPanelBot; 
		        ACTION (A860GrvPar(oLbx,nPar),A860Reload( @oLbx, nPar, oMrk, oNoMrk ))
		        
		@ 1,220 BUTTON oSai;
		        PROMPT 'Sair';
		        SIZE 20,11;
		        PIXEL OF oPanelBot; 
		        ACTION (A860AddPar( aSX5 ),oDlg:End())
		        
	ACTIVATE MSDIALOG oDlg CENTER
	
	cFile := 'log_status_ped_sigla_trilha_aud_' + Dtos( MsDate() ) + LTrim( Str( Int( Seconds() ) ) ) + '.log'
	nHdl := FCreate( cFile )
	AEval( aLogParam, {|e| FWrite( nHdl, e + CRLF ) } )
	FClose( nHdl )
Return

Static Function A860AddPar( aSX5 )
	Local nI := 0
	
	AAdd( aLogParam, 'DEPOIS DA ALTERAÇÃO' + Replicate( '-', 81 ) )
	
	For nI := 1 To Len( aSX5 )
		AAdd( aLogParam, Iif( aSX5[ nI, 1 ],'X',' ') + '-' + RTrim( aSX5[ nI, 2 ] ) + '-' + RTrim( aSX5[ nI, 3 ] ) )
	Next nI
	
	AAdd( aLogParam, Replicate( '-', 100 ) )
Return

//--------------------------------------------------------------------------
// Rotina | A860LoadTr | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para carregar os dados no vetor conforme parâmetro. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860LoadTr( aSX5, cMV_PAR )
	dbSelectArea( 'SX5' )
	dbSetOrder( 1 )
	dbSeek( xFilial( 'SX5' ) + 'tr' )
	While  SX5->( .NOT. EOF() ) .AND. SX5->X5_FILIAL == xFilial( 'SX5' ) .AND. X5_TABELA == 'tr'
		AAdd( aSX5,{ ( RTrim( SX5->X5_CHAVE ) $ cMV_PAR ), SX5->X5_CHAVE, SX5->X5_DESCRI } )
		SX5->( dbSkip() )
	End
Return

//--------------------------------------------------------------------------
// Rotina | A860IncPar | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que permite a inclusão de siglas. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860IncPar()
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 1, 'Qual a sigla p/ incluir', Space(3), '@!', 'ExistChav("SX5","tr" + MV_PAR01, 1 )', '', '', 20, .T. } )
	AAdd( aPar, { 1, 'Descrição da sigla', Space(Len(SX5->X5_DESCRI)), '@S90', '', '', '', 99, .T. } )
	
	If ParamBox( aPar, 'Incluir Sigla', @aRet, , , , , , , , .F., .F. )
		SX5->( RecLock( 'SX5', .T. ) )
		SX5->X5_FILIAL  := xFilial( 'SX5' )
		SX5->X5_TABELA  := 'tr'
		SX5->X5_CHAVE   := aRet[ 1 ] 
		SX5->X5_DESCRI  := aRet[ 2 ]
		SX5->X5_DESCSPA := aRet[ 2 ]
		SX5->X5_DESCENG := aRet[ 2 ]
		SX5->( MsUnLock() )
		MessageBox('Operação de incluir sigla realizada com sucesso.','Parâmetro gravado',0)		
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A860IncPar | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que permite a alteração de siglas. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860AltPar( oLbx )
	Local aPar := {}
	Local aRet := {}
	
	AAdd( aPar, { 1, 'Sigla atual', oLbx:aArray[ oLbx:nAt, 2 ], '@!', '', '', '.F.', 20, .F. } )
	AAdd( aPar, { 1, 'Qual a sigla quer alterar', Space(3), '@!', 'ExistChav("SX5","tr" + MV_PAR02, 1 )', '', '', 20, .T. } )
	AAdd( aPar, { 1, 'Descrição da sigla', oLbx:aArray[ oLbx:nAt, 3 ], '@S90', '', '', '', 99, .T. } )
	
	If ParamBox( aPar, 'Alterar Sigla', @aRet, , , , , , , , .F., .F. )
		SX5->( dbSetOrder( 1 ) )
		If SX5->( dbSeek( xFilial( 'SX5' ) + 'tr' + oLbx:aArray[ oLbx:nAt, 2 ] ) )
			SX5->( RecLock( 'SX5', .F. ) )
			SX5->X5_FILIAL  := xFilial( 'SX5' )
			SX5->X5_TABELA  := 'tr'
			SX5->X5_CHAVE   := aRet[ 2 ] 
			SX5->X5_DESCRI  := aRet[ 3 ]
			SX5->X5_DESCSPA := aRet[ 3 ]
			SX5->X5_DESCENG := aRet[ 3 ]
			SX5->( MsUnLock() )
			MessageBox('Operação de alterar sigla realizada com sucesso.','Parâmetro gravado',0)
		Else
			MsgAlert('Não localizei a silga no momento de gravar.','Parâmetro')
		Endif		
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A860GrvPar | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que víncula as siglas da trilha de auditoria com o param. 
//        | do campo do status do pedido. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860GrvPar( oLbx, nPar )
	Local aMV_PAR := {}
	Local cConteudo := ''
	Local cMV_PAR := ''
	Local nI := 0
	
	For nI := 1 To Len( oLbx:aArray )
		If oLbx:aArray[ nI, 1 ] 
			cConteudo += RTrim( oLbx:aArray[ nI, 2 ] ) + '|'
		Endif
	Next nI
	
	cConteudo := SubStr( cConteudo, 1, Len( cConteudo )-1 )
	
	aMV_PAR := {'MV_860_06','MV_860_07','MV_860_08','MV_860_09','MV_860_10'}
	
	cMV_PAR := aMV_PAR[ nPar ]
	
	PutMv( cMV_PAR, cConteudo )
	
	MessageBox('A operação de vincular as siglas selecionadas com o parâmetro do status do pedido GAR informado foi realizada com sucesso.',cCadastro,0)
Return

//--------------------------------------------------------------------------
// Rotina | A860MrkSig | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que permite marcar/desmarcar a sigla que será gravada no
//        | parâmetro. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860MrkSig( oLbx, nPar, oMrk, oNoMrk )
	Local aMV_PAR := {}
	Local cMV_PAR := ''
	Local nI := 0
	
	aMV_PAR := {'MV_860_06','MV_860_07','MV_860_08','MV_860_09','MV_860_10'}
	
	cMV_PAR := GetMv( aMV_PAR[ nPar ], .F. )
	
	For nI := 1 To Len( oLbx:aArray )
		If RTrim( oLbx:aArray[ nI, 2 ] ) $ cMV_PAR
			oLbx:aArray[ nI, 1 ] := .T.
		Else
			oLbx:aArray[ nI, 1 ] := .F.
		Endif
	Next nI
	oLbx:Refresh()
Return

//--------------------------------------------------------------------------
// Rotina | A860Reload | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina que recarrega os dados para atualizar o TwBrowse.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860Reload( oLbx, nPar, oMrk, oNoMrk )
	Local aMV_PAR := {}
	Local aSX5 := {}
	Local cMV_PAR := ''
	
	aMV_PAR := {'MV_860_06','MV_860_07','MV_860_08','MV_860_09','MV_860_10'}
	cMV_PAR := GetMv( aMV_PAR[ nPar ] )
	
	A860LoadTr( @aSX5, cMV_PAR )
	
	oLbx:SetArray( aSX5 )
	oLbx:bLine := {|| { Iif( aSX5[ oLbx:nAt, 1 ], oMrk, oNoMrk ), aSX5[ oLbx:nAt, 2 ], aSX5[ oLbx:nAt ,3 ] } }
	oLbx:Refresh()
Return

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// ************************************************************************************************ //
// ***                                                                                          *** //
// *** *** *** ABAIXO SÃO AS ROTINAS QUE IRÁ AUXILIAR O OPERADOR LOCALIZAR O PEDIDO GAR *** *** *** //
// *** *** *** E TAMBÉM APLICAR REGRAS PARA AVALIAR A CONCESSÃO DE VOUCHER              *** *** *** //
// ***                                                                                          *** //
// ************************************************************************************************ //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////

//--------------------------------------------------------------------------
// Rotina | A860GAR | Autor | Robson Gonçalves           | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ buscar o Pedido GAR na base de dados Protheus ou GAR.
//        | Nesta consulta é possível visualizar a trilha de auditoria.
//--------------------------------------------------------------------------
// 1.ESTA ROTINA ESTA SENDO ACIONADA PELO F3 DO CAMPO ADE_PEDGAR POR MEIO DA
//   CONSULTA PADRAO "860GAR". A CRIACAO DA CONSULTA SXB E O ALIAS X3_F3 
//   PODEM SER CRIADO AUTOMATICAMENTE POR MEIO DA ROTINA U_A860SXB. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function A860GAR()
	Local aOpcPesq := { 'CPF', 'CNPJ', 'Pedido' }
	Local aPedidos := {}
	
	Local bExecPesq
	Local bKeyC := SetKey( 3 )
	Local cPesq
	Local cPicture
	
	Local lReturn := .T.
	
	Local nList1 := 0
	Local nLIst2 := 0
	
	Local nMrk := 0
	Local nOpcPesq := 1
	Local nTamCpoPesq := 20
	
	Local oBtnOK
	Local oBtnPesq
	Local oBtnSair
	Local oDlg
	Local oFntTList  := TFont():New('Consolas',,16,,.F.,,,,,.F.,.F.)
	Local oLbxT
	Local oPnlAll
	Local oPnlBot
	Local oPnlH1
	Local oPnlH2
	Local oPnlTop
	Local oPnlV1
	Local oPnlV2
	Local oRadMenu 
	Local oSpltH
	Local oSpltV
	Local oTLbx1
	Local oTLbx2
	
	Private cMV_860_01 := 'MV_860_01'
	Private cMV_860_02 := 'MV_860_02'
	Private cMV_860_03 := 'MV_860_03'
	
	Private cTitulo := 'Pesquisar Pedido GAR'
	
	Private oMrk := LoadBitmap(,'NGCHECKOK.PNG')
	Private oNoMrk := LoadBitmap(,'NGCHECKNO.PNG')
	
	cPesq := Space( nTamCpoPesq )
	cPicture := Replicate( '9', nTamCpoPesq )
	
	SetKey(  3, NIL )
	
	cMV_860_01 := GetMv( cMV_860_01, .F. )
	cMV_860_02 := GetMv( cMV_860_02, .F. )
	cMV_860_03 := GetMv( cMV_860_03, .F. )	
	
	bExecPesq := {|| Iif(Empty(cPesq),(MsgAlert('Informe algo para pesquisa',cTitulo),NIL),;
	                 (A860PesqGAR( nOpcPesq, cPesq, @oLbxT, @oTLbx1, @oTLbx2, @aPedidos ))) }
	
	DEFINE MSDIALOG oDlg TITLE cTitulo OF oMainWnd FROM 0,0 TO 413,904 PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oPnlTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,RGB(204,229,255),0,20,.F.,.T.)
		oPnlTop:Align := CONTROL_ALIGN_TOP
		
		@ 6,3 SAY 'Pesquisar por' SIZE 60,10 PIXEL OF oPnlTop
		
		oRadMenu := TRadMenu():New(5,43,aOpcPesq,,oPnlTop,,;
		{|| cPesq := Space( nTamCpoPesq ), oGetPesq:Buffer := Space( nTamCpoPesq ),;
		oGetPesq:cText := Space( nTamCpoPesq ), oGetPesq:Refresh() },,,,,,79,10,,,,.T.,.T.)
		oRadMenu:bSetGet := {|u| Iif( PCount()==0, nOpcPesq, nOpcPesq:=u ) }
		
		oGetPesq := TGet():New(4,128,{|u| If(PCount() > 0, cPesq := u, cPesq ) },;
		            oPnlTop,100,10,cPicture,/*bValid*/,,,,,,.T.,,,/*bWhen*/,,,/*bExecPesq*/,;
		            /*lReadOnly*/,,,cPesq,,,,,,,,,,,'Informe o CPF, ou CNPJ ou Pedido')
		
		@ 5,232 BUTTON oBtnPesq;
				PROMPT 'Pesquisar';
				SIZE 40,10;
				PIXEL OF oPnlTop; 
				ACTION EVal( bExecPesq )
				oBtnPesq:SetCss( CSSButton( .T. ) )
		
		oPnlAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oSpltH := TSplitter():New( 1, 1, oPnlAll, 1000, 1000, 1 )
		oSpltH:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlH1:= TPanel():New(1,1,'',oSpltH,,,,,RGB(204,229,255),1000,36)
		oPnlH1:Align := CONTROL_ALIGN_TOP
		
		oPnlH2 := TPanel():New(1,1,'',oSpltH,,,,,RGB(204,229,255),1000,64)
		oPnlH2:Align := CONTROL_ALIGN_BOTTOM
		
		aPedidos := {{.F.,' ',' ',' ',' ',' ',0}}
		oLbxT := TwBrowse():New(1,1,1000,1000,,{'','Pedido GAR','Validade','Status','Produto','Certificado'},,oPnlH1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbxT:SetArray( aPedidos )
		oLbxT:bLine := {|| { Iif( aPedidos[ oLbxT:nAt, 1 ], oMrk, oNoMrk ),;
		aPedidos[ oLbxT:nAt, 2 ], aPedidos[ oLbxT:nAt ,3 ], aPedidos[ oLbxT:nAt, 4 ],;
		aPedidos[ oLbxT:nAt, 5 ], aPedidos[ oLbxT:nAt, 6 ] } }
		oLbxT:Align := CONTROL_ALIGN_ALLCLIENT
		oLbxT:bLDblClick := {|| FWMsgRun( , {|| A860MrkPed( @oLbxT, @oTLbx1, oTLbx2 ) }, , 'Consultando GAR...' ) }
		oLbxT:Hide()
		
		oSpltV := TSplitter():New( 1, 1, oPnlH2, 1000, 1000, 2 )
		oSpltV:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlV1:= TPanel():New(1,1,'',oSpltV,,,,,RGB(204,229,255),1000,75)
		oPnlV1:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlV2:= TPanel():New(1,1,'',oSpltV,,,,,RGB(204,229,255),1000,75)
		oPnlV2:Align := CONTROL_ALIGN_ALLCLIENT
		
		oTLbx1 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList1:=u,nList1)},{},100,46,,oPnlV1,,,,.T.,,,oFntTList)
		oTLbx1:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx1:Hide()
		
		oTLbx2 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList2:=u,nList2)},{},100,46,,oPnlV2,,,,.T.,,,oFntTList)
		oTLbx2:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx2:Hide()
		
		oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,RGB(204,229,255),0,14,.F.,.T.)
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 2,367 BUTTON oBtnOK;
				PROMPT 'Confirmar';
				SIZE 40,10;
				PIXEL OF oPnlBot; 
				ACTION ( lReturn := A860Confirm( nOpcPesq, AllTrim( cPesq ), oLbxT, @nMrk ), Iif( lReturn, oDlg:End(), NIL ) )
				oBtnOK:SetCss( CSSButton( .T. ) )
		
		@ 2,411 BUTTON oBtnSair;
				PROMPT 'Sair';
				SIZE 40,10;
				PIXEL OF oPnlBot; 
				ACTION Iif( MsgYesNo('Realmente você quer sair da pesquisa?', cTitulo ), (lReturn:=.F.,oDlg:End()), NIL ) 
	ACTIVATE MSDIALOG oDlg CENTERED
	
	SetKey(  3, bKeyC )
	
	If lReturn
		If nMrk > 0
			SZ5->( dbGoTo( aPedidos[ nMrk, 7 ] ) )
			M->ADE_PEDGAR := SZ5->Z5_PEDGAR
			
			If Len( a860Operad ) == 0
				A860Operad()
			Endif
			
			A860UpdAtend()
		Endif
	Else
		M->ADE_PEDGAR := Space( Len( ADE->ADE_PEDGAR ) )
	Endif
Return( lReturn )

//--------------------------------------------------------------------------
// Rotina | A860Confirm | Autor | Robson Gonçalves       | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ validar se pode confirmar a pesquisa.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860Confirm( nOpc, cPesq, oLbxT, nMrk )
	Local nPos := 0
	
	If .NOT. A860Pedido( nOpc, cPesq, NIL )
		Return( .F. )
	Endif
	
	nPos := AScan( oLbxT:aArray, {|e| e[ 1 ] == .T. } )
	
	If nPos == 0
		MsgAlert('É necessário selecionar um pedido para seguir.', cTitulo )	
		Return( .F. )
	Endif
	
	nMrk := nPos
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A860PesqGAR | Autor | Robson Gonçalves       | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ preparar a pesquisa por CPF, CNPJ, Pedido GAR.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860PesqGAR( nOpc, cPesq, oLbxT, oTLbx1, oTLbx2, aPedidos )
	Local lRet := .F.
	
	Local nId := 0
	
	Local oWsGAR
	
	cPesq := Alltrim( cPesq )
	
	If .NOT. IsNum( cPesq )
		MsgAlert( 'Por favor, informe somente números.', cTitulo )
		Return( lRet )
	Endif
	
	If Len( oLbxT:aArray ) > 0
		oLbxT:Hide()
	Endif
	
	If Len( oTLbx1:aItems ) > 0
		oTLbx1:Hide()
	Endif
	
	If Len( oTLbx2:aItems ) > 0
		oTLbx2:Hide()
	Endif
	
	lRet := A860Pedido( nOpc, cPesq, @aPedidos )
	
	If lRet .AND. Len( aPedidos ) > 0
		oLbxT:SetArray( aPedidos )
		oLbxT:bLine := {|| { Iif( aPedidos[ oLbxT:nAt, 1 ], oMrk, oNoMrk ),;
		aPedidos[ oLbxT:nAt, 2 ], aPedidos[ oLbxT:nAt ,3 ], aPedidos[ oLbxT:nAt, 4 ],;
		aPedidos[ oLbxT:nAt, 5 ], aPedidos[ oLbxT:nAt ,6 ] } }
		oLbxT:Show()
		oLbxT:Refresh()
		
		If nOpc == 3
			oLbxT:aArray[ oLbxT:nAt, 1 ] := .T.
			nId := Val( AllTrim( oLbxT:aArray[ oLbxT:nAt, 2 ] ) ) 
			A860GetGar( nId, @oTLbx1, @oTLbx2 )
		Endif
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A860MrkPed | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ marcar/desmarcar o pedido e acionar a consulta da 
//        | trilha e auditoria e dados do pedido GAR. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860MrkPed( oLbxT, oTLbx1, oTLbx2 )
	Local lTroca := .F.
	Local nId := 0
	Local nP := 0
	
	If Empty( oLbxT:aArray[ oLbxT:nAt, 2 ] )
		MsgAlert('Não há pedido para marcar.', cCadastro )
	Else
		// Ao selecionar o Pedido GAR imediatamente verificar se este foi comprado na Certisign.
		If A860OndeComprou( oLbxT:aArray[ oLbxT:nAt, 2 ] )
			nP := AScan( oLbxT:aArray, {|e| e[ 1 ] == .T. } )
			
			If nP == 0
				lTroca := .T.
				oLbxT:aArray[ oLbxT:nAt, 1 ] := .T.
			Else
				lTroca := nP <> oLbxT:nAt 
				If ltroca
					oLbxT:aArray[ nP, 1 ] := .F.
					oLbxT:aArray[ oLbxT:nAt, 1 ] := .T.
				Endif
			Endif
			
			If lTroca 
				oLbxT:Refresh()
				nId := Val( AllTrim( oLbxT:aArray[ oLbxT:nAt, 2 ] ) )
				A860GetGar( nId, @oTLbx1, @oTLbx2 )
			Endif
		Endif
	Endif
Return

Static Function A860OndeComprou( cPedidoGAR )
	Local cFNTALERT := '<b><font size="4" color="red"><b>'
	Local cNOFONT   :=  '</b></font></b></u>'
	// Se achar em pedidos de venda pode seguir.
	SC5->( dbSetOrder( 5 ) ) 
	If .NOT. SC5->( dbSeek( xFilial( 'SC5' ) + cPedidoGAR ) )
		// Se achar em voucher consumido pode seguir.
		SZG->( dbSetOrder( 1 ) )
		If .NOT. SZG->( dbSeek( xFilial( 'SZG' ) + cPedidoGAR ) )
			// Caso contrário bloquear a concessão de voucher.
			MsgAlert( cFNTALERT + 'A compra deste cliente não foi realizada na Certisign,<br>'+;
			                      'portanto não será possível analisar a concessão de voucher.' + cNOFONT, cTitulo )
			Return( .F. )
		Endif
	Endif
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A860GetGAR | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ acionar as consultas GAR e atribuir os objetos TList.  
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860GetGAR( nId, oTLbx1, oTLbx2 )
	Local oWsGAR
	
	oWsGAR  := A860ConGAR()
	
	aDADPED := {}
	aDADPED := A860FDPed( oWsGAR, nId )
	
	aTRILHA := {}
	aTRILHA := A860Trilha( oWsGAR, nId )
	
	oTLbx1:SetArray( aDADPED )
	oTLbx1:Show()
	oTLbx1:Refresh()
	
	oTLbx2:SetArray( aTRILHA )
	oTLbx2:Show()
	oTLbx2:Refresh()
Return

//--------------------------------------------------------------------------
// Rotina | A860Pedido | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ consultar por CPF, CNPJ ou Pedido GAR na SZ5.  
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860Pedido( nOpc, cDoc, aPedidos )
	Local cMsg := ''
	Local cSQL := ''
	Local cStatus := ''
	Local cTRB := ''
	
	If nOpc == 1 .OR. nOpc == 2
		If Len( cDoc ) == 11
			cMsg := 'CPF'
		Elseif Len( cDoc ) == 14
			cMsg := 'CNPJ'
		Else
			cMsg := 'documento'
		Endif
		
		If .NOT. CGC( cDoc,,.F. )
			MsgAlert( 'O ' + cMsg + ' informado é inválido, verifique!', cTitulo )
			Return( .F. )
		Endif
	Endif
	
	cSQL := "SELECT Z5_PEDGAR, "
	cSQL += "       Z5_VLDCERT, "
	cSQL += "       Z5_DATVER, "
	cSQL += "       Z5_DATVAL, "
	cSQL += "       Z5_DATEMIS, "
	cSQL += "       Z5_PRODGAR, "
	cSQL += "       Z5_DESPRO, "
	cSQL += "       Z5_CPFT, "
	cSQL += "       Z5_CNPJCER, "
	cSQL += "       R_E_C_N_O_ AS Z5_RECNO "
	cSQL += "FROM   "+RetSqlName("SZ5")+" SZ5 "
	cSQL += "WHERE  Z5_FILIAL = ' ' "
	
	If nOpc == 1
		cSQL += "       AND Z5_CPFT = "+ValToSql(cDoc)+" "
	Elseif nOpc == 2
		cSQL += "       AND Z5_CNPJCER = "+ValToSql(cDoc)+" "
	Elseif nOpc == 3
		cSQL += "       AND Z5_PEDGAR = "+ValToSql(cDoc)+" "
	Endif
	
	cSQL += "       AND SZ5.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY R_E_C_N_O_ "
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->(BOF()) .AND. (cTRB)->(EOF())
		MsgAlert( 'Não localizado o ' + cMsg + ' informado.', cTitulo )
		(cTRB)->( dbCloseArea() )
		Return( .F. )
	Endif
	
	If aPedidos <> NIL
		
		aPedidos := {}
		
		While (cTRB)->( .NOT. EOF() )
			If Empty( (cTRB)->Z5_DATVER ) .AND. Empty( (cTRB)->Z5_DATVAL ) .AND. Empty( (cTRB)->Z5_DATEMIS )
				cStatus := 'SOLICITADO'
			Elseif .NOT. Empty( (cTRB)->Z5_DATVER ) .AND. Empty( (cTRB)->Z5_DATVAL ) .AND. Empty( (cTRB)->Z5_DATEMIS )
				cStatus := 'VERIFICADO'
			Elseif .NOT. Empty( (cTRB)->Z5_DATVER ) .AND. .NOT. Empty( (cTRB)->Z5_DATVAL ) .AND. Empty( (cTRB)->Z5_DATEMIS )
				cStatus := 'VALIDADO'
			Elseif .NOT. Empty( (cTRB)->Z5_DATVER ) .AND. .NOT. Empty( (cTRB)->Z5_DATVAL ) .AND. .NOT. Empty( (cTRB)->Z5_DATEMIS )
				cStatus := 'EMITIDO'
			Else
				cStatus := ''
			Endif
			
			(cTRB)->( AAdd( aPedidos, { .F., Z5_PEDGAR, Z5_VLDCERT, cStatus, Z5_PRODGAR, Z5_DESPRO, Z5_RECNO } ) )
		
			(cTRB)->( dbSkip() )
		End
	Endif
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A860ConGAR | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para conectar no webservice GAR.  
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860ConGAR()
	Local oWsGAR
	oWsGAR := WSIntegracaoGARERPImplService():New()
Return( oWsGAR )

//--------------------------------------------------------------------------
// Rotina | A860FDPed | Autor | Robson Gonçalves         | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ acionar o método findDadosPedido do GAR e atribuir o   
//        | array do objeto TList de dados do pedido.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860FDPed( oWsGAR, nId )
	Local aDados := {}
	Local aList := {}
	
	Local cSpace := Chr( 160 ) +  Chr( 160 )
	
	Local oDados
	Local oObj
	
	Local bVldCtd := {|a,b| Iif( a == NIL, '', Iif( b == 'N', Alltrim( Str( a ) ), a ) ) } 
	
	oWsGAR:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
							eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
							nId )
					
	oDados := oWsGAR:oWsDadosPedido
	
	AAdd( aDados, Eval( bVldCtd, oDados:cAcDesc,'C' ) )
	AAdd( aDados, Eval( bVldCtd, oDados:cArDesc,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cArId,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cArValidacao,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cArValidacaoDesc,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cDataEmissao,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cDataValidacao,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cDataVerificacao,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cDescricaoParceiro,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cDescricaoRevendedor,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cEmailTitular,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cGrupo,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cGrupoDescricao,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cNomeAgenteValidacao,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cNomeAgenteVerificacao,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cNomeTitular,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cPostoValidacaoDesc,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cPostoVerificacaoDesc,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cProduto,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cProdutoDesc,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cRazaoSocialCert,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cRede,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cStatus,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:cStatusDesc,'C') )
	AAdd( aDados, Eval( bVldCtd, oDados:nCnpjCert,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nCodigoParceiro,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nCodigoRevendedor,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nComissaoParceiroHw,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nComissaoParceiroSw,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nCpfAgenteValidacao,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nCpfAgenteVerificacao,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nCpfTitular,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nPedido,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nPedidoAntigo,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nPostoValidacaoId,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nPostoVerificacaoId,'N') )
	AAdd( aDados, Eval( bVldCtd, oDados:nTipoParceiro,'N') )
	
	If Empty( aDados[ 11 ] )
		AAdd( aList, '*** PEDIDO NÃO LOCALIZADO ***' )
	Else
		c860NomeT  := AllTrim( aDados[16] )
		c860EmailT := AllTrim( aDados[11] )
		
		aDadosP := {}
		aDadosP := AClone( aDados )
		
		AAdd( aList, '[ DADOS GERAIS DO PEDIDO GAR ]' )
		AAdd( aList, cSpace + ' AC..............: ' + AllTrim( aDados[1] ) )
		AAdd( aList, cSpace + ' AR..............: ' + AllTrim( aDados[3] ) + ' - ' + AllTrim( aDados[2] ) )
		AAdd( aList, cSpace + ' Emissão.........: ' + AllTrim( aDados[6] ) )
		AAdd( aList, cSpace + ' CPF Titular.....: ' + AllTrim( aDados[32] ) )
		AAdd( aList, cSpace + ' email Titular...: ' + AllTrim( aDados[11] ) )
		AAdd( aList, cSpace + ' Nome titular....: ' + AllTrim( aDados[16] ) )
		AAdd( aList, cSpace + ' Produto.........: ' + AllTrim( aDados[19] ) + ' - ' + AllTrim( aDados[20] ) )
		AAdd( aList, cSpace + ' Razão social....: ' + AllTrim( aDados[21] ) )
		AAdd( aList, cSpace + ' Status..........: ' + AllTrim( aDados[23] ) + ' - ' + AllTrim( aDados[24] ) )
		AAdd( aList, cSpace + ' CNPJ certificado: ' + AllTrim( aDados[25] ) )
		AAdd( aList, cSpace + ' Pedido antigo...: ' + AllTrim( aDados[34] ) )
		
		AAdd( aList, ' ' )
		
		AAdd( aList, '[ DADOS DE VALIDAÇÃO ]' )
		AAdd( aList, cSpace + ' AR..............: ' + AllTrim( aDados[4] ) + ' - ' + AllTrim( aDados[5] ) )
		AAdd( aList, cSpace + ' Data............: ' + AllTrim( aDados[7] ) )
		AAdd( aList, cSpace + ' Agente..........: ' + AllTrim( aDados[30] ) + ' - ' + AllTrim( aDados[14] ) )
		AAdd( aList, cSpace + ' Posto...........: ' + AllTrim( aDados[35] ) + ' - ' + AllTrim( aDados[17] ) )
		
		AAdd( aList, ' ' )
		
		AAdd( aList, '[ DADOS DE VERIFICAÇÃO ]' )
		AAdd( aList, cSpace + ' Data............: ' + AllTrim( aDados[8] ) )
		AAdd( aList, cSpace + ' Agente..........: ' + AllTrim( aDados[31] ) + ' - ' + AllTrim( aDados[15] ) )
		AAdd( aList, cSpace + ' Posto...........: ' + AllTrim( aDados[36] ) + ' - ' + AllTrim( aDados[18] ) )
	Endif
Return( aList )

//--------------------------------------------------------------------------
// Rotina | A860Trilha | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ acionar o método listarTrilhasDeAuditoriaParaIdPedido  
//        | do GAR e atribuir dados no array do TList trilha de auditoria.  
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860Trilha( oWsGAR, nId )
	Local aDados := {}
	Local aList := {}
	Local cSpace := Chr( 160 ) +  Chr( 160 )
	Local nElem := 0
	Local nI := 0
	Local nJ := 0
	Local oWsAud
	Local oObj

	oWsGAR:listarTrilhasDeAuditoriaParaIdPedido( eVal({|| oObj:=loginUserPassword():get(cMV_860_01), oObj:cReturn }),;
												 eVal({|| oObj:=loginUserPassword():get(cMV_860_02), oObj:cReturn }),;
												 nId )
	oWsAud := oWsGAR:oWsAuditoriaInfo
	
	If Len( oWsAud ) > 0
		AAdd( aList, '[ TRILHA DE AUDITORIA ]' )
		AAdd( aList, cSpace + ' PEDIDO....: ' + LTrim( Str( nId ) ) )
		
		c860IdPed := LTrim( Str( nId ) )
		
		// Ler o objeto em ordem decrescente.
		For nI := Len( oWsAud ) To 1 STEP -1
			// Este array é para armazenar no chamado.
			AAdd( aDados, { LTrim( Str( nId ) ),;//1
			oWsAud[ nI ]:cAcao,;//2
			oWsAud[ nI ]:cComentario,;//3
			oWsAud[ nI ]:cData,;//4
			oWsAud[ nI ]:cDescricaoAcao,;//5
			oWsAud[ nI ]:cNomeUsuario,;//6
			oWsAud[ nI ]:cPosto,;//7
			oWsAud[ nI ]:lClienteAcao,;//8
			oWsAud[ nI ]:nCPFUsuario } )//9
			
			nElem := Len( aDados )
			
			For nJ := 1 To Len( aDados[ nElem ] )
				If aDados[ nElem, nJ ] == NIL
					aDados[ nElem, nJ ] := ''
				Elseif ValType( aDados[ nElem, nJ ] ) == 'N'
					aDados[ nElem, nJ ] := LTrim( Str( aDados[ nElem, nJ ] ) )
				Elseif ValType( aDados[ nElem, nJ ] ) == 'L'
					aDados[ nElem, nJ ] := Iif( aDados[ nElem, nJ ], 'True', 'False' )
				Endif
			Next nJ
			
			AAdd( aList, cSpace + ' AÇÃO......: ' + aDados[ nElem, 5 ] ) 
			AAdd( aList, cSpace + ' EMISSÃO...: ' + aDados[ nElem, 4 ] )
			AAdd( aList, cSpace + ' NOME......: ' + aDados[ nElem, 6 ] )
			AAdd( aList, cSpace + ' CPF.......: ' + aDados[ nElem, 9 ] )
			AAdd( aList, cSpace + ' POSTO.....: ' + aDados[ nElem, 7 ] )
			AAdd( aList, cSpace + ' COMENTÁRIO: ' + aDados[ nElem, 3 ] )
			AAdd( aList, '' )
		Next nI
		
		aDadosT := {}
		aDadosT := AClone( aDados )
	Else
		AAdd( aList, '*** TRILHA DE AUDITORIA NÃO LOCALIZADA ***' )
	Endif
Return( aList )

//--------------------------------------------------------------------------
// Rotina | IsNum      | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ verificar se foi digitado somente números.  
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function IsNum( cCheck )
	Local nI
	For nI := 1 To Len( cCheck )
		If .NOT. SubStr( cCheck, nI, 1 ) $ '0123456789'
			Return( .F. )
		Endif
	Next nI
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | CSSButton  | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina para fornecer características CSS ao botão.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function CSSButton( lFocal )
	Local cButton := ''
	
	Default lFocal := .F.
	
	lImg := Len(GetResArray('fwstd_btn_focal.png')) > 0
	
	cButton := 'QPushButton { font: bold }'
	
	If lImg
		If lFocal
			cButton += 'QPushButton { border-image: url(rpo:fwstd_btn_focal.png) 3 3 3 3 stretch }'
			cButton += 'QPushButton { color: #FFFFFF } '
		Else
			cButton += 'QPushButton { border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch }'
			cButton += 'QPushButton { color: #024670 } '
		EndIf
	Else
		cButton += 'QPushButton { color: #024670 } '
	EndIf
	
	cButton += 'QPushButton { border-top-width: 3px }'
	cButton += 'QPushButton { border-left-width: 3px }'
	cButton += 'QPushButton { border-right-width: 3px }'
	cButton += 'QPushButton { border-bottom-width: 3px }'
	
	If lImg
		cButton += 'QPushButton:pressed { color: #FFFFFF } '
		If lFocal
			cButton += 'QPushButton:pressed { border-image: url(rpo:fwstd_btn_focal_dld.png) 3 3 3 3 stretch }'
		Else
			cButton += 'QPushButton:pressed { border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch }'
		EndIf
	EndIf
	
	cButton += 'QPushButton:pressed { border-top-width: 3px }'
	cButton += 'QPushButton:pressed { border-left-width: 3px }'
	cButton += 'QPushButton:pressed { border-right-width: 3px }'
	cButton += 'QPushButton:pressed { border-bottom-width: 3px }'
Return( cButton )

//--------------------------------------------------------------------------
// Rotina | CSFA861    | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ analisar e aplicar a regra para conceder voucher.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CSFA861()
	Local aAntes := {}
	Local aFolder := {}
	Local aZ00_DADOS := {}
	
	Local bKeyC := SetKey( 3 )
	
	Local cDDDCont  := M->ADE_DDDRET
	Local cMailCont := M->ADE_EMAIL2
	Local cMotRej   := ''
	Local cNomeCont := M->ADE_NMCONT
	Local cTelCont  := M->ADE_TELRET
	
	Local lAvaliar := .F.
	Local lReturn := .T.
	
	Local nI := 0
	Local nList1 := 0
	Local nList2 := 0 
	
	Local oBtnGrvAlt
	Local oBtnOK
	Local oBtnSair
	Local oBut1
	Local oBut2
	Local oBut3
	Local oDlg
	Local oFld
	Local oFntTList  := TFont():New('Consolas',,16,,.F.,,,,,.F.,.F.)
	Local oFntSay := TFont():New('Arial',,16,,.T.,,,,,.F.,.F.)
	Local oGrp1
	Local oGrp2
	Local oLbx
	Local oMrk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNoMrk := LoadBitmap(,'NGCHECKNO.PNG')
	Local oPnlAll
	Local oPnlBot
	Local oPnlH1
	Local oPnlH2
	Local oPnlV1
	Local oPnlV2
	Local oScr1
	Local oSpltH
	Local oSpltV
	Local oTLbx1
	Local oTLbx2
	
	Private aReturn := {}
	Private cTitulo := 'Concessão de Voucher'
	
	If Empty( M->ADE_PEDGAR )
		MsgInfo( 'Não foi informado o número do Pedido GAR. Volte no respectivo campo e localize a informação.', cTitulo )
		Return( .F. )
	Endif
	
	SetKey(  3, {|| NIL })
	
	A860GetZ00( @aZ00_DADOS )
	
	DEFINE MSDIALOG oDlg TITLE cTitulo OF oMainWnd FROM 0,0 TO 423,904 PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		aFolder := {'Avaliar a possibilidade de conceder voucher','Dados do pedido e Trilha de auditoria'}
		
		oFld := TFolder():New(0,0,aFolder,,oDlg,,,,.T.,,1000,1000 )
		oFld:Align := CONTROL_ALIGN_ALLCLIENT
		
		//+---------------------------------------------------------------+
		//| *** DADOS DO PEDIDO E TRILHA DE AUDITORIA *** *** *** *** *** |
		//+---------------------------------------------------------------+
		oSpltV := TSplitter():New( 1, 1, oFld:aDialogs[ 2 ], 1000, 1000, 2 )
		oSpltV:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlV1:= TPanel():New(1,1,'',oSpltV,,,,,RGB(204,229,255),1000,75)
		oPnlV1:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlV2:= TPanel():New(1,1,'',oSpltV,,,,,RGB(204,229,255),1000,75)
		oPnlV2:Align := CONTROL_ALIGN_ALLCLIENT
		
		oTLbx1 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList1:=u,nList1)},{},100,46,,oPnlV1,,,,.T.,,,oFntTList)
		oTLbx1:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx1:SetArray( aDADPED )
		
		oTLbx2 := TListBox():New(0,0,{|u| Iif(PCount()>0,nList2:=u,nList2)},{},100,46,,oPnlV2,,,,.T.,,,oFntTList)
		oTLbx2:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx2:SetArray( aTRILHA )
		
		//+---------------------------------------------------------------+
		//| *** CONCESSÃO DE VOUCHER *** *** *** *** *** *** *** *** *** *|
		//+---------------------------------------------------------------+
		oPnlAll := TPanel():New(0,0,'',oFld:aDialogs[ 1 ],NIL,.F.,,,,0,14,.F.,.T.)
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oSpltH := TSplitter():New( 1, 1, oPnlAll, 1000, 1000, 1 )
		oSpltH:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlH1:= TPanel():New(1,1,'',oSpltH,,,,,RGB(204,229,255),1000,48)
		oPnlH1:Align := CONTROL_ALIGN_TOP
		
		oPnlH2 := TPanel():New(1,1,'',oSpltH,,,,,RGB(204,229,255),1000,52)
		oPnlH2:Align := CONTROL_ALIGN_BOTTOM
		
		oScrl := TScrollBox():New(oPnlH1,1,1,100,100,.T.,.F.,.T.)
		oScrl:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlBot := TPanel():New(0,0,'',oPnlH2,NIL,.F.,,,RGB(204,229,255),0,14,.F.,.T.)
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 2,3 SAY 'Dados do títular' SIZE 100,10 PIXEL OF oScrl FONT oFntSay COLOR CLR_BLUE
		oGrp1:= TGroup():New(  10, 2, 11, 400, '', oScrl,,, .T.)

		@ 14, 5 SAY 'Nome:'   SIZE 50,10 RIGHT PIXEL OF oScrl COLOR CLR_BLUE
		@ 25, 5 SAY 'E-Mail:' SIZE 50,10 RIGHT PIXEL OF oScrl COLOR CLR_BLUE
		
		@ 13,60 MSGET c860NomeT  SIZE 200,8 PIXEL OF oScrl WHEN .F.
		@ 24,60 MSGET c860EMailT SIZE 200,8 PIXEL OF oScrl WHEN .F.
		
		@ 40,3 SAY 'Dados do contato' SIZE 100,10 PIXEL OF oScrl FONT oFntSay COLOR CLR_BLUE
		oGrp2:= TGroup():New( 48, 2, 49, 400, '', oScrl,,, .T.)
		
		@ 52, 5 SAY 'Nome:'         SIZE 50,10 RIGHT PIXEL OF oScrl COLOR CLR_BLUE
		@ 63, 5 SAY 'DDD/Telefone:' SIZE 50,10 RIGHT PIXEL OF oScrl COLOR CLR_BLUE
		@ 74, 5 SAY 'E-Mail:'       SIZE 50,10 RIGHT PIXEL OF oScrl COLOR CLR_BLUE
		
		@ 51,60 MSGET cNomeCont SIZE 200,8 PIXEL OF oScrl WHEN .F.
		@ 62,60 MSGET cDDDCont  SIZE  12,8 PICTURE '99'        PIXEL OF oScrl VALID NaoVazio( cDDDCont )
		@ 62,85 MSGET cTelCont  SIZE 175,8 PICTURE '999999999' PIXEL OF oScrl VALID NaoVazio( cTelCont )
		@ 73,60 MSGET cMailCont SIZE 200,8 PIXEL OF oScrl VALID NaoVazio( cMailCont )

		@ 73,340 BUTTON oBtnGrvAlt;
		          PROMPT 'Gravar alteração'; 
		          SIZE 60,10 PIXEL OF oScrl; 
		          ACTION A860GrvTel( cDDDCont, cTelCont, cMailCont, @aAntes )
		
		oLbx := TwBrowse():New(1,1,1000,1000,,{'','Código','Descrição do motivo'},,oPnlH2,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbx:SetArray( aZ00_DADOS )
		oLbx:bLine := {|| { Iif( aZ00_DADOS[ oLbx:nAt, 1 ], oMrk, oNoMrk ), aZ00_DADOS[ oLbx:nAt, 2 ], aZ00_DADOS[ oLbx:nAt ,3 ] } }
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:bLDblClick := {||  A860MrkMot( @oLbx ) }
		
		oBut1 := THButton():New(1,1,'Avaliar concessão'          ,oPnlBot,{|| lAvaliar := A860Avaliar(@oLbx) },60,8,,'Avaliar a possibilidade de conceder voucher...')
		oBut2 := THButton():New(1,1,'Reenviar senha de revogação',oPnlBot,{|| A860ReSendPsw() },90,8,,'Reenviar a senha para o títular revogar seu certificado...')
		oBut3 := THButton():New(1,1,'Rejeitar o pedido'          ,oPnlBot,{|| A860MotRej(@cMotRej) },65,8,,'Rejeitar o pedido GAR...')
/*		
		---------------
		REJEITAR PEDIDO
		-> ABRIR UM FORMBATCH
		-> O USUÁRIO TERÁ A OPÇÃO DE REJEITAR PEDIDO
		-> O USUÁRIO PODERÁ CONSULTAR PARA SABER SE REALMENTE O PEDIDO FOI REJEITADO.
		-> SE SIM, SEGUIR. DO CONTRÁRIO O USUÁRIO DEVERÁ TENTAR REJEITAR PEDIDO NOVAMENTE.
		---------------------------
		REENVIAR SENHA DE REVOGAÇÃO
		-> ABRIR UM FORMBATCH
		-> O USUÁRIO ACIONA O REENVIO DE SENHA DE REVOGAÇÃO DO CERTIFICADO PELO E-MAIL.
		-> O USUÁRIO PODERÁ CONSULTAR PARA SABER SE REALMENTE O CERTIFICADO FOI REVOGADO.
		-> SE SIM, SEGUIR. DO CONTRÁRIO O USUÁRIO DEVERÁ TENTAR REENVIAR SE SENHA NOVAMENTE.
		------------------------------------------------------------------------------------------------------
		* TANTO A REJEIÇÃO DO PEDIDO COMO A REVOGAÇÃO DO CERTIFICADO ESTARÁ REGISTRADO NA TRILHA DE AUDITORIA,
		  PARA TANTO É NECESSÁRIO QUE HAJA O HISTÓRICO DA PRIMEIRA LISTA DA TRILHA DE AUDITORIA E DAS POSTERIORES.
		----------------------------------------------------------------------------------------------------------
		* O BOTÃO CONFIRMA DEVE SER SUBSTITUÍDO PELO AVALIAR CONCESSÃO E ESTE DEVE FAZER UM CHECK-UP, ESTANDO TUDO
		  OK GRAVAR OS DADOS NOS RESPECTIVOS CAMPOS E O USUÁRIO DEVE SEGUIR COM O ATENDIMENTO.
		--------------------------------------------------------------------------------------
*/
		oBut1:Align := CONTROL_ALIGN_LEFT
		oBut2:Align := CONTROL_ALIGN_LEFT
		oBut3:Align := CONTROL_ALIGN_LEFT
		
		//quando confirmar precisa está selecionado um motivo.
		//precisa haver a anuência da avaliação.
		@ 2,367 BUTTON oBtnOK;
				PROMPT 'Confirmar';
				SIZE 40,10;
				PIXEL OF oPnlBot; 
				ACTION Iif(lAvaliar,(lReturn:=.T.),MsgAlert('Precisa AVALIAR A CONCESSÃO antes de confirmar.',cTitulo))
				oBtnOK:SetCss( CSSButton( .T. ) )
		
		@ 2,411 BUTTON oBtnSair;
				PROMPT 'Sair';
				SIZE 40,10;
				PIXEL OF oPnlBot; 
				ACTION Iif( MsgYesNo('Realmente você quer sair da rotina?', cTitulo ), (lReturn:=.F.,oDlg:End()), NIL )
		 
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT oLbx:Refresh()
	
	/***
	 *
	 * Caso o usuário clique no botão cancelar e tenha feito alteração nos dados, fazer rollback.
	 *
	 */
	If .NOT. lReturn
		For nI := 1 To Len( aAntes )
			If SubStr( aAntes[ nI ], 1, 4 ) == 'DDD:'
				M->ADE_DDDRET := SubStr( aAntes[ nI ], 5 )
			Elseif SubStr( aAntes[ nI ], 1, 4 ) == 'TEL:'
				M->ADE_TELRET := SubStr( aAntes[ nI ], 5 )
			Elseif SubStr( aAntes[ nI ], 1, 6 ) == 'EMAIL:'
				M->ADE_EMAIL2 := SubStr( aAntes[ nI ], 6 )
			Endif
		Next nI
		aCOLS[ N, GdFieldPos( 'ADF_DPCONT' ) ] := Space( Len( ADF->ADF_DPCONT ) )
	Endif
	
	SetKey(  3, bKeyC )
	
	aDADPED := {}
	aTRILHA := {}
	aDadosT := {}
	aDadosP := {}
	
	c860IdPed := ''
	
Return( lReturn )

/*RLEG
certificado está na garantia. 								ISTO JÁ FOI VERIFICADO NO MARK DO MOTIVO DO VOUCHER.
tipo de voucher condiz com a regra.							ISTO JÁ FOI FEITO NO ATO DE APRESENTAR OS MOTIVOS.
houve reenvio senha de revogação.							ISTO JÁ FOI TRATADO NOS RETORNO E ARMAZENADO EM CAMPOS ESPECIFÍCOS PARA TAL.
houve rejeitou o pedido                                     ISTO JÁ FOI TRATADO NOS RETORNO E ARMAZENADO EM CAMPOS ESPECIFÍCOS PARA TAL.
Gravar os dados no item do atendimento.                     .

ok Verificar se foi selecionado um motivo.
ok Informar que foi ou não reenviado senha de revogação.
ok Informar que foi ou não rejeitado o pedido.
ok Informar que o processo está apto para gerar voucher. 
Informar que será um voucher do tipo ...
ok Informar que para o voucher ser gerado é necessário gravar o atendimento como encerrado.
Se confirmar se avaliar, criticar, pedir para primeiro avaliar para depois confirmar.

	BR_CANCEL.PNG
	IC_VERIFICAR.GIF
	NGBIOALERTA_01.PNG
	NGBIOALERTA_02.PNG
	NGBIOALERTA_03.PNG
	NG_ICO_SS_SATISFACAO.PNG
	QMT_NO.PNG
	QMT_OK.PNG

rleg
IMPRETERIVELMENTE O USUÁRIO DEVE REENVIAR A SENHA DE REVOGAÇÃO E CONSEQUENTEMENTE CONSULTAR A TRILHA PARA SABER SE FOI REVOGADO OU...
ELE DEVE REJEITAR O PEDIDO.
PARA AMBOS OS CASOS DEVE ANALISAR PARA SABER SE OK UMA DAS DUAS CONDIÇÕES.
*/

Static Function A860Avaliar( oLbx )
	Local aObj := {}
	Local aLog := {}
	
	Local bSay
	
	Local lRet := .F.	
	
	Local nI := 0
	Local nLin := 5
	Local nNivel1 := 0
	Local nNivel2 := 0 
	Local nP := 0
	
	Local oButton
	Local oDlg
	Local oPanel
	Local oScroll
	
	nP := AScan( oLbx:aArray, {|e| e[ 1 ] == .T. } )
	
	If nP == 0
		MsgAlert('É necessário selecionar um motivo de voucher para seguir.', cTitulo )
		Return( .F. )
	Endif
	
	If Len( aReturn )==0
		AAdd( aLog, { 'NGBIOALERTA_01.PNG', 'NÃO HOUVE A NECESSIDADE DE REENVIAR SENHA DE REVOGÇÃO E NEM REJEITAR O PEDIDO?' } )
	Else
		For nI := 1 To Len( aReturn )
			If aRet[ nI, 1 ] == 'REJ'
				If SubStr( aRe[ nI, 2 ], 1, 1 ) == '1'
					nNivel1 := 1
					AAdd( aLog, { 'NGBIOALERTA_02.PNG', Upper( aRet[ nI, 2 ] ) } )
				Else
					nNivel1 := 2
					AAdd( aLog, { 'NGBIOALERTA_03.PNG', Upper( aRet[ nI, 2 ] ) } )
				Endif
			Endif
			If aRet[ nI, 1 ] == 'REE'
				If SubStr( aRe[ nI, 2 ], 1, 1 ) == '1'
					nNivel2 := 1
					AAdd( aLog, { 'NGBIOALERTA_02.PNG', Upper( aRet[ nI, 2 ] ) } )
				Else
					nNivel2 := 2
					AAdd( aLog, { 'NGBIOALERTA_03.PNG', Upper( aRet[ nI, 2 ] ) } )
				Endif
			Endif
		Next nI 
	Endif
	
	If ( ( nNivel1 == 2 ) .OR. ( nNivel2 == 2 ) )
		AAdd( aLog, { 'QMT_NO.PNG', 'Não é possível conceder voucher.' } )
	Else
		lRet := .T.
		AAdd( aLog, { 'QMT_OK.PNG', 'Será possível conceder voucher, portanto é necessário clicar em "Confirmar" para prosseguir e informar o cliente.' } )
	Endif
	
	If lRet
		aObj := Array( Len( aLog ), 2 )
		
		DEFINE MSDIALOG oDlg TITLE 'Resultado da operação' OF oMainWnd FROM 0,0 TO 300,700 PIXEL STYLE DS_MODALFRAME STATUS
			oDlg:lEscClose := .F.
			
			oScroll := TScrollBox():New(oDlg,1,1,100,100,.T.,.F.,.T.)
			oScroll:Align := CONTROL_ALIGN_ALLCLIENT
			
			oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,RGB(204,229,255),0,14,.F.,.T.)
			oPanel:Align := CONTROL_ALIGN_BOTTOM
			
			@ 2,308 BUTTON oButton PROMPT 'Sair' SIZE 40,10 PIXEL OF oPanel ACTION oDlg:End()			
			
			For nI := 1 To Len( aLog )
				aObj[ nI, 1 ] := TBitmap():New(nLin,5,12,12,aLog[ nI, 1 ],,,oScroll,,,,,,,,,.T.,,)
				bSay := &("{|| '" + aLog[ nI, 2 ] + "'}")
				aObj[ nI, 2 ] := TSay():New(nLin+3,20,bSay,oScroll,,,,,,.T.,CLR_HBLUE)
				nLin += 12
			Next nI
		ACTIVATE MSDIALOG oDlg CENTERED
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A860MotRej | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ solicitar o motivo da rejeição do voucher.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860MotRej( cMotRej )
	Local aPar := {}
	Local aRet := {}
	Local cRet := ''
	Local lGoOn := .T.
	
	If cMotRej <> ''
		lGoOn := MsgYesNo( 'Já foi informado o motivo da rejeição, você quer prosseguir para alterar ou complementar este motivo?', cTitulo )
	Endif
	
	If lGoOn
		AAdd( aPar, { 11, 'Motivo da rejeição', cMotRej, '.T.', '.T.', .T. } )
		If ParamBox( aPar, 'Motivo da rejeição', @aRet,,,,,,,, .F., .F. )
			cMotRej := AllTrim( aRet[ 1 ] )
			If MsgYesNo('A partir deste momento o sistema está pronto para rejeitar o pedido GAR, devo prosseguir com esta ação?', cTitulo )
				MsAguarde({|| cRet := A860RejPed( cMotRej )}, cTitulo, 'Prosseguindo com a rejeição do pedido...', .F.)
				
				AAdd( aReturn, { 'REJ', 'MOTIVO: ' + cMotRej + ' Retorno GAR:' + cRet } )
			Endif
		Endif
	Endif
Return

Static Function A860RejPed( cObservation )
	Local cIdPedido := c860IdPed
	Local cRet := ''
	Local cReturn := ''
	Local cObs := cObservation
	Local lIsPermanent := .T.
	
	Local oWsObj
	
	MsProcTxt('Conectando...')
	ProcessMessage()
	
	oWsObj := WSGARPaymentServiceImplService():New()
	
	MsProcTxt('Rejeitando pedido...')
	ProcessMessage()
	
	cReturn := oWSObj:rejectOrder( cIdPedido, cObs, .T. )
	
	If cReturn == 'true'
		cRet := '1 - Pedido GAR ' + cIdPedido + ' rejeitado com sucesso. Data/Hora: ' + Dtoc( dDataBase ) + ' ' + Time() 
	Else
		cRet := '0 - Pedido GAR ' + cIdPedido + ' não foi rejeitado. Data/Hora: ' + Dtoc( dDataBase ) + ' ' + Time()
	Endif
Return( cRet )

Static Function A860ReSendPsw()
	Local aRet := {}
	Local cRet := ''
	
	MsAguarde({|| aRet := A860Reenviar}, cTitulo, 'Reenviando e-mail de senha de revogação...', .F.)
	
	If aRet[ 1 ]
		cRet := '1 - Reenviado senha de revogação com sucesso. ' + aRet[ 2 ]  
	Else
		cRet := '0 - Problemas ao reenviar senha de revogação. ' + aRet[ 2 ]
	Endif
	
	AAdd( aReturn, { 'REE', cRet } )
Return

Static Function A860Reenviar()
	Local aHeadRest := { 'Content-Type: application/json', 'Accept: application/json'}
	Local aRet := { .F., '' }
	Local cHost := GetMv( 'MV_860_11', .F. )
	Local lExecRest := .F.
	Local oRest
	
	MsProcTxt('Reenviando pedido...')
	ProcessMessage()

	oRest := FWRest():New( cHost + c860IdPed )
	
	lExecRest := oRest:Post( aHeadRest )
	
	If lExecRest
		aRet[1]	:= .T.
	Else
		aRet[1]	:= .F.
	Endif
	
	aRet[ 2 ] := oRest:getResult()
Return( aRet )

//--------------------------------------------------------------------------
// Rotina | A860Return | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ retornar o pedido GAR - Acionado por CTSDK05.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860Return( cKey )
	Local cReturn := ''
	If cKey == 'PEDIDOGAR'
		If Len( aDadosP ) >= 33
			cReturn := aDadosP[ 33 ]
		Endif
	Endif
Return( cReturn )

//--------------------------------------------------------------------------
// Rotina | A860UpdAtend | Autor | Robson Gonçalves      | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860UpdAtend()
	M->ADE_XAC    := aDadosP[ 1 ] 
	M->ADE_XAR    := aDadosP[ 3 ] + '-' + aDadosP[ 2 ]  
	M->ADE_XDEMIS := CtoD( SubStr( aDadosP[ 6 ], 1, 10 ) )
	M->ADE_XHEMIS := Right( aDadosP[ 6 ], 8 )
	M->ADE_XCPFTI := aDadosP[ 32 ]
	M->ADE_XMAILT := aDadosP[ 11 ]
	M->ADE_XNOMTI := aDadosP[ 16 ]
	M->ADE_XPRODG := aDadosP[ 19 ] + '- ' + aDadosP[ 20 ]
	M->ADE_XRZSOC := aDadosP[ 21 ]
	M->ADE_XSTATG := aDadosP[ 23 ]+ '-' + aDadosP[ 24 ]
	M->ADE_XCNPJC := aDadosP[ 25 ] 
	M->ADE_PEDANT := aDadosP[ 34 ]
	M->ADE_XARVLD := aDadosP[ 4 ] + '- ' + aDadosP[ 5 ]
	M->ADE_XDVLD  := CtoD( SubStr( aDadosP[ 7 ], 1, 10 ) )
	M->ADE_XHVLD  := Right( aDadosP[ 7 ], 8 )
	M->ADE_XAGTVL := aDadosP[ 30 ] + '- ' + aDadosP[ 14 ]
	M->ADE_XPSTVL := aDadosP[ 35 ] +'- ' + aDadosP[ 17 ]
	M->ADE_XDTVRF := CtoD( SubStr( aDadosP[ 8 ], 1, 10 ) )
	M->ADE_XHRVRF := Right( aDadosP[ 8 ], 8 )
	M->ADE_XAGTVR := aDadosP[ 31 ] + '- ' + aDadosP[ 15 ]
	M->ADE_XPSTVR := aDadosP[ 36 ] + '- ' + aDadosP[ 18 ]
	M->ADE_CODSB1 := Posicione( 'PA8', 1, xFILIAL( 'PA8' ) + AllTrim( aDadosP[ 19 ] ), 'PA8_CODMP8' ) 
	M->ADE_NMPROD := Posicione( 'PA8', 1, xFILIAL( 'PA8' ) + AllTrim( aDadosP[ 19 ] ), 'PA8_DESMP8' ) 
	M->ADE_CODPA8 := AllTrim( aDadosP[ 19 ] )
Return

//--------------------------------------------------------------------------
// Rotina | A860GetZ00 | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ carregar os motivos de voucher.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860GetZ00( aZ00_DADOS )
	Local aZ00_ACAO := {}
	Local aZ00_PROD := {}
	Local aZ00_TPVOUC := {}
	
	Local cZ00_ACAO := ''
	Local cZ00_TPVOUC := ''
	
	Local nP := 0
	
	aZ00_ACAO   := StrTokArr( SX3->( Posicione( 'SX3', 2, 'Z00_ACAO'  , 'X3CBox()' ) ), ';' )
	aZ00_TPVOUC := StrTokArr( SX3->( Posicione( 'SX3', 2, 'Z00_TPVOUC', 'X3CBox()' ) ), ';' )
	aZ00_PROD   := StrTokArr( SX3->( Posicione( 'SX3', 2, 'Z00_PROD'  , 'X3CBox()' ) ), ';' )
	
	Z00->( dbSetOrder( 1 ) )
	Z00->( dbSeek( xFilial( 'Z00' ) ) )
	
	While Z00->( .NOT. EOF() )
		// Registros bloqueados não interessa.
		If Z00->Z00_MSBLQL == '1'
			Z00->( dbSkip() )
			Loop
		Endif
		
		// Se não houver grupo não interessa.
		If Empty( Z00->Z00_GRUPOS )
			Z00->( dbSkip() )
			Loop
		Endif
		
		// Registro que não pertence ao grupo de atendimento do operador não interessa.
		If AScan( a860Operad, {|e| e[ 6 ] $ Z00->Z00_GRUPOS } ) == 0
			Z00->( dbSkip() )
			Loop
		Endif
		
		nP := AScan( aZ00_TPVOUC, {|cValue| SubStr( cValue, 1, 1 ) == Z00->Z00_TPVOUC } )
		
		If nP > 0
			cZ00_TPVOUC := Z00->Z00_TPVOUC + '-' + RTrim( SubStr( aZ00_TPVOUC[ nP ], 3 ) )
		Else
			cZ00_TPVOUC := '*** Tipo de voucher inválido ***'
		Endif
		
		nP := AScan( aZ00_ACAO, {|cValue| SubStr( cValue, 1, 1 ) == Z00->Z00_ACAO } )
		
		If nP > 0
			cZ00_ACAO := Z00->Z00_ACAO + '-' + RTrim( SubStr( aZ00_ACAO[ nP ], 3 ) )
		Else
			cZ00_ACAO := '*** Ação no GAR inválida ***'
		Endif
		
		Z00->( AAdd( aZ00_DADOS, { .F., Z00_CODIGO, Z00_DESCR, cZ00_TPVOUC, LTrim( Str( Z00_GARANT ) ), SubStr( aZ00_PROD[ Val( Z00_PROD ) ], 3 ), cZ00_ACAO, '' } ) )
		
		Z00->( dbSkip() )
	End
Return

//--------------------------------------------------------------------------
// Rotina | A860GrvTel | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ gravar o e-mail e telefone no atendimento.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860GrvTel( cDDD_Cad, cTEL_Cad, cEMAIL_Cad, aAntes )
	Local cConteudo := ''
	Local cMsg := ''
	Local F_BLUE := '<b><font size="4" color="blue"><b>'
	Local F_GREEN := '<b><font size="4" color="green"><b>'
	Local F_DEFAULT := '</b></font></b></u>'
	Local lAntes := (Len( aAntes ) == 0) 
	
	If .NOT. IsEMail( cEMAIL_Cad )
		MsgAlert('E-Mail inválido, verifique!', cTitulo )
		Return( .F. )
	Endif
	
	If .NOT. Empty( cDDD_Cad )
		If .NOT. Empty( M->ADE_DDDRET ) .AND. lAntes
			AAdd( aAntes, 'DDD:' + RTrim( M->ADE_DDDRET ) )
		Endif
		M->ADE_DDDRET := cDDD_Cad
		cMsg += F_GREEN + '* DDD gravado' + '<br />'
	Endif
	
	If .NOT. Empty( cTEL_Cad )
		If .NOT. Empty( M->ADE_TELRET ) .AND. lAntes
			AAdd( aAntes, 'TEL:' + RTrim( M->ADE_TELRET ) )
		Endif
		M->ADE_TELRET := cTEL_Cad
		cMsg += F_GREEN + '* Telefone gravado' + '<br />'
	Endif
	
	If .NOT. Empty( cEMAIL_Cad )
		If .NOT. Empty( M->ADE_EMAIL2 ) .AND. lAntes
			AAdd( aAntes, 'EMAIL:' + RTrim( M->ADE_EMAIL2 ) )
		Endif
		M->ADE_EMAIL2 := cEMAIL_Cad
		cMsg += F_GREEN + '* e-mail gravado' + '<br />'
	Endif
	
	If cMsg <> '' .AND. Len( aAntes )>0 .AND. lAntes
		For nI := 1 To Len( aAntes )
			cConteudo += aAntes[ nI ] + ' '
		Next nI
		
		cConteudo := 'DADOS DO CONTATO ANTES DA ALT. ' + SubStr( cConteudo, 1, Len( cConteudo )-1 )
		
		aCOLS[ N, GdFieldPos( 'ADF_DPCONT' ) ] := cConteudo
		
		MsgInfo( F_BLUE + 'Operação de gravar os dados (telefone e e-mail) efetuado com sucesso!' + '<br />' + cMsg + F_DEFAULT, cTitulo )
	Endif
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A860MrkMot | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ possibilitar a seleção marcando o motivo de voucher.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860MrkMot( oLbx )
	Local nP := 0
	If Empty( oLbx:aArray[ oLbx:nAt, 2 ] )
		MsgAlert( 'Não há motivo para selecionar.', cTitulo )
		Return
	Endif
	
	If A860PodMrk( oLbx )
		nP := AScan( oLbx:aArray, {|e| e[ 1 ] == .T. } )
		If nP == 0
			oLbx:aArray[ oLbx:nAt, 1 ] := .T.
		Else
			oLbx:aArray[ nP, 1 ] := .F.
			oLbx:aArray[ oLbx:nAt, 1 ] := .T.
		Endif
		oLbx:Refresh()
	Endif
Return

Static Function A860PodMrk( oLbx )
	Local aZ00_STAPED := {}
	
	Local cB1_COD := ''
	Local cPA8_CODMP8 := ''
	Local cParam := ''
	Local cProdGAR := ''
	Local cTrb := ''
	Local cUltStatus := ''
	
	Local lUtil := .F.
	
	Local nI := 1
	Local nQtdDias := 0
	Local nSemana := 0
	
	Local dDiaDia := Ctod('')
	Local dDtCompra := Ctod('')
	Local dDtFimVig := Ctod('')
	Local dFimAno := Ctod('')
	
	aZ00_STAPED := StrTokArr( SX3->( Posicione( 'SX3', 2, 'Z00_STAPED'  , 'X3CBox()' ) ), ';' )
	
	AEval( aZ00_STAPED, {|v,i| aZ00_STAPED[ i ] := SubStr( aZ00_STAPED[ i ], 3 ) } ) 
	
	// Localizar o primeiro registro de pagamento.
	// Fazer a localização do último elemento para o primeiro.
	For nI := Len( aDadosT ) To 1 STEP -1
		If aDadosT[ nI, 2 ] == 'EMI' // EMI = Emissão do certificado.
			dDtCompra := Ctod( SubStr( aDadosT[ nI, 4 ], 1, 10 ) )
		Endif
		cUltStatus := aDadosT[ nI, 2 ] 
	Next nI
	
	If Empty( dDtCompra )
		MsgAlert('Não consegui localizar a data de compra do certificado.', cTitulo )
		Return( .F. )
	Endif
	
	// Calcular um último dia de um ano após a compra.
	dFimAno := ( dDtCompra + 365 )
	
	// Montar array com os feriados.
	A860Feriado( dDtCompra, dFimAno )
	
	// Conferir a garantia.
	Z00->( dbSetOrder( 1 ) )
	Z00->( dbSeek( xFilial( 'Z00' ) + oLbx:aArray[ oLbx:nAt, 2 ] ) )
	
	If Z00->Z00_GARANT > 0
		lUtil := Z00->Z00_CONTAG == '2' // 1=Dias corridos; 2=Útil.
		If lUtil
			dDiaDia := aDtCompra + 1
			While nQtdDias < Z00->Z00_GARANT
				nSemana := Dow( dDiaDia )
				If nSemana > 1 .AND. nSemana < 7
					If Ascan( a860Feriado, {|e| e[ 1 ] == dDiaDia }, 2 ) == 0
						nQtdDias++
						dDtFimVig := dDiaDia
					Endif
				Endif
				dDiaDia := dDiaDia + 1 
			End
		Else
			dDtFimVig := dDtCompra + Z00->Z00_GARANT
			nQtdDias := dDtFimVig - dDtCompra
		Endif
		If MsDate() > dDtFimVig
			MsgAlert('O certificado está com a data de garantia vencida:' + CRLF + ;
			'Foi comprado em ' + Dtoc( dDtCompra ) + ' ' + CRLF + ;
			'A data da vigência da garantia de ' + LTrim( Str( nQtdDias ) ) + ' dias ' + ;
			Iif( lUtil, 'úteis', 'corridos' ) + ' foi em ' + Dtoc( dDtFimVig ) + '.' + CRLF + ;
			'Portanto não será possível continuar.')
			
			alert('aqui precisa ajustar')
			Return( .T. )
			/////Return( .F. )
		Endif
	Endif
	
	// Qual é o último status do pedido gar neste momento?
	If Len( aDadosT ) > 0
		cParam := Z00->Z00_PARTRI
		cParam := GetMv( cParam, .F. )
		If .NOT. ( cUltStatus $ cParam )
			MsgAlert(;
			'O status do pedido é ' + cUltStatus + ' - ' + RTrim( Tabela( 'tr', cUltStatus ) ) + '<br>' + ;
			'O motivo selecionado foi o ' + aZ00_STAPED[ Val( Z00->Z00_STAPED ) ] + '<br>' + ;
			'O motivo não está contemplando o status deste pedido para conceder voucher.' + '<br>' + ;
			'Portanto não será possível continuar.', cTitulo )
			Return( .F. )
		Endif
	Else
		MsgAlert('Problemas ao analisar a trilha de auditoria deste pedido GAR.',cTitulo)
		alert('aqui precisa ajustar')
		Return( .T. )
		/////Return( .F. )
	Endif
	
	// Qual o produto?
	// Capturar o produto GAR.
	// Localizar em PA8.
	// Localizar em SG1.
	cProdGAR := RTrim( aDadosP[ 19 ] )
	
	cTrb := GetNextAlias()
	
	beginSQL Alias cTrb
		SELECT PA8_CODMP8 
		FROM   %table:PA8% PA8 
		WHERE  PA8_FILIAL = %xFilial:PA8% 
		       AND PA8_CODBPG = %exp:cProdGAR% 
		       PA8.%notDel%
	endSQL
	cPA8_CODMP8 := (cTrb)->PA8_CODMP8
	(cTrb)->( dbCloseArea() )
	
	If SubStr( cPA8_CODMP8, 1, 2 ) == 'KT'
		beginSQL Alias cTrb
			SELECT G1_COMP 
			FROM   %table:SG1% SG1 
			WHERE  G1_FILIAL = %xFilial:SG1% 
			       AND G1_COD = %exp:cPA8_CODMP8% 
			       SG1.%notDel%
		endSQL
		cB1_COD := (cTrb)->G1_COMP
		(cTrb)->( dbCloseArea() )
	Else
		cB1_COD := cPA8_CODMP8
	Endif       
Return( .T. )

//--------------------------------------------------------------------------
// Rotina | A860Operad | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ carregar os dados do operador.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A860Operad()
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	
	A860Operad := {}
	
	cSQL := "SELECT U7_COD,
	cSQL += "       U7_NOME,
	cSQL += "       U7_POSTO,
	cSQL += "       U7_TIPOATE,
	cSQL += "       U7_CODUSU,
	cSQL += "       U7_NREDUZ,
	cSQL += "       AG9_CODSU0
	cSQL += "FROM   "+RetSqlName("SU7")+" SU7 "
	cSQL += "       INNER JOIN "+RetSqlName("AG9")+" AG9 "
	cSQL += "               ON AG9_FILIAL = "+ValToSql(xFilial("AG9")) + " "
	cSQL += "                  AND AG9_CODSU7 = U7_COD "
	cSQL += "                  AND AG9.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  U7_FILIAL = "+ValToSql(xFilial("SU7")) + " " 
	cSQL += "       AND U7_CODUSU = "+ValToSql( __cUserId ) + " "
	cSQL += "       AND SU7.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
	
	While (cTRB)->( .NOT. EOF() )
		(cTRB)->( AAdd( a860Operad, { U7_COD, U7_NOME, U7_POSTO, U7_TIPOATE, U7_CODUSU, AG9_CODSU0 } ) )
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
Return

/*
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
<<<-------------------------------------------------------------->>>
<<<--- ROTINA TESTE - NÃO FAZ PARTE DO FUNCIONAMENTO DO TODO. --->>>
<<<-------------------------------------------------------------->>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*/
User Function TesteData()
	Local aPar := {}
	Local aRet := {}
	
	Local dDiaDia := Ctod('')
	Local dDtFimVig := Ctod('')
	Local lUtil := .T.
	Local nQtdDias := 0
	Local nSemana := 0
	
	AAdd( aPar, { 1, 'Data compra',Ctod(""),"","","","",50,.F.}) 
	AAdd( aPar, { 1, 'Garantia (dias)',0,"@E 999","","","",50,.F.})
	AAdd( aPar, { 3, 'Contagem',1,{'corridos','úteis'},50,'',.F.})
	
	If .NOT. ParamBox( aPar,"Parâmetros...",@aRet)
		Return
	Endif
	
	A860Feriado( aRet[ 1 ], dDataBase )
	
	lUtil := ( aRet[ 3 ] == 2 )
	
	If lUtil
		dDiaDia := aRet[ 1 ] + 1
		While nQtdDias < aRet[ 2 ]
			//É dia útil?
			nSemana := Dow( dDiaDia )
			If nSemana > 1 .AND. nSemana < 7
				//É feriado?
				If AScan( a860Feriado, {|e| e[ 1 ] == dDiaDia }, 2 ) == 0
					nQtdDias++
					dDtFimVig := dDiaDia
				Endif
			Endif
			dDiaDia := dDiaDia + 1
		End
	Else
		//Qual é a data fim da vigência da garantia?
		dDtFimVig := aRet[ 1 ] + aRet[ 2 ]
		//Quantos dias correram até a garantia?
		nQtdDias := dDtFimVig - aRet[ 1 ]
	Endif
	Alert(  'O certificado está com a data de garantia vencida, pois:'+CRLF+;
			'Foi comprado em ' + Dtoc(aRet[1])+' '+CRLF+;
			'A data da vigência da garantia de '+LTrim(Str(nQtdDias))+' dias '+Iif(lUtil,'útil','corrido')+' foi em '+Dtoc(dDtFimVig)+' ')
Return

Static Function A860Feriado( dDtIni, dDtFim )
	Local cTrb
	Local dataInicial
	Local dataFinal
	
	If a860Feriado[ 1, 1 ] <> dDtIni .OR. a860Feriado[ 1, 2 ] <> dDtFim
		a860Feriado := {}
		
		AAdd( a860Feriado, { dDtIni, dDtFim } )
		
		dataInicial := Dtos( dDtIni )
		dataFinal   := Dtos( dDtFim )
	
		cTrb := GetNextAlias()
		
		// A query abaixo está fixo a filial por conta da característica da Certisign.
		beginSQL Alias cTrb
			select P3_DATA, 
			       P3_DESC
			from   %table:SP3% SP3
			where  P3_FILIAL = '07'
			       and P3_DATA >= %exp:dataInicial% 
			       and P3_DATA <= %exp:dataFinal%
			       and SP3.%notDel% 
			order  by P3_DATA
		endSQL
		
		While (cTrb)->( .NOT. EOF() )
			(cTrb)->( AAdd( a860Feriado, { Stod( P3_DATA ), P3_DESC } ) )
			
			(cTrb)->( dbSkip() )
		End
		
		(cTrb)->( dbCloseArea() )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A860       | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function zA860GerVou( cTpVoucher, cPedVoucher, cProdVoucher )
	Local cCodVoucher := ''
	Local cMsgRet := ''
	Local lOk := .T.
	Local oModel
	
	oModel := FWLoadModel( 'VNDA060' )
	oModel:SetOperation( 3 )
	oModel:Activate()
	
	oModel:SetValue( 'SZFMASTER', 'ZF_USRSOL'	, 'AUTOMATICO' )
	oModel:SetValue( 'SZFMASTER', 'ZF_TIPOVOU'	, cTpVoucher )
	oModel:SetValue( 'SZFMASTER', 'ZF_PEDIDO'	, cPedVoucher )
	oModel:SetValue( 'SZFMASTER', 'ZF_PDESGAR'	, cProdVoucher )
	
	lOk := oModel:VldData()
	 
	If lOk
		oModel:CommitData()
		cMsgRet	:= '**EFETIVADO**' + CRLF + 'Voucher código ' + oModel:GetValue( 'SZFMASTER', 'ZF_COD' ) + ' gerado com sucesso para Pedido ' + cPedVoucher + '!'
		cCodVoucher := oModel:GetValue( 'SZFMASTER', 'ZF_COD' )
		U_GTPutOUT(cPedVoucher,'R',cPedVoucher,{'VNDA620',{.T.,'M00001',cPedVoucher,cMsgRet}},cPedVoucher)
	Else
		aErro := oModel:GetErrorMessage()
		
		cMsgRet := '**NÃO EFETIVADO**'           + CRLF
		cMsgRet += 'Id do formulário de origem:' + ' [' + AllToChar( aErro[ 1 ] ) + ']' + CRLF 
		cMsgRet += 'Id do campo de origem: '     + ' [' + AllToChar( aErro[ 2 ] ) + ']' + CRLF 
		cMsgRet += 'Id do formulário de erro: '  + ' [' + AllToChar( aErro[ 3 ] ) + ']' + CRLF 
		cMsgRet += 'Id do campo de erro: '       + ' [' + AllToChar( aErro[ 4 ] ) + ']' + CRLF 
		cMsgRet += 'Id do erro: '                + ' [' + AllToChar( aErro[ 5 ] ) + ']' + CRLF 
		cMsgRet += 'Mensagem do erro: '          + ' [' + AllToChar( aErro[ 6 ] ) + ']' + CRLF 
		cMsgRet += 'Mensagem da solução: '       + ' [' + AllToChar( aErro[ 7 ] ) + ']' + CRLF 
		cMsgRet += 'Valor atribuído: '           + ' [' + AllToChar( aErro[ 8 ] ) + ']' + CRLF 
		cMsgRet += 'Valor anterior: '            + ' [' + AllToChar( aErro[ 9 ] ) + ']' + CRLF
		
		U_GTPutOUT(cPedVoucher,'R',cPedVoucher,{'VNDA620',{.F.,'E00002',cPedVoucher,'Falha ao Incluir Voucher '+cMsgRet}},cPedVoucher) 
	Endif
	
	oModel:DeActivate()
Return( lOk )

//--------------------------------------------------------------------------
// Rotina | UPD860     | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ update de dicionário.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function UPD860()
	Local cModulo := 'TMK'
	Local bPrepar := {|| U_U860Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//--------------------------------------------------------------------------
// Rotina | U860Ini    | Autor | Robson Gonçalves        | Data | 20/09/2017
//--------------------------------------------------------------------------
// Descr. | Rotina p/ atribuir os dados para a execução do update.   
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function U860Ini()
	aSX2 := {}
	aSX3 := {}
	aSIX := {}
	aSX7 := {}
	aSXB := {}
	aHelp := {}
	
	AAdd( aSX2, { "Z00","","Motivos de Voucher","Motivos de Voucher","Motivos de Voucher","C",""})
	
	AAdd( aSX3, { 'Z00',NIL,'Z00_FILIAL','C', 2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','','€€€€€€€€€€€€€€€','','',1,'þÀ','','','U','N','','','','','','','','','','','033','','','','','','','','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_CODIGO','C', 3,0,'Codigo','Codigo','Codigo','Codigo do motivo','Codigo do motivo','Codigo do motivo','@!','','€€€€€€€€€€€€€€ ','GetSXENum("Z00","Z00_CODIGO")','',0,'þÀ','','','U','S','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_DESCR' ,'C',60,0,'Descricao','Descricao','Descricao','Descricao do motivo','Descricao do motivo','Descricao do motivo','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','S','A','R','€','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_GRUPOS','C',30,0,'Grupos','Grupos','Grupos','Grupos de atendimento','Grupos de atendimento','Grupos de atendimento','@!','','€€€€€€€€€€€€€€ ','','860GRA',1,'þÀ','','','U','S','','R','','Vazio() .OR. U_A860VGA()','','','','','','','','1','N','','','N','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_TPVOUC','C', 1,0,'Tipo Voucher','Tipo Voucher','Tipo Voucher','Tipo de voucher','Tipo de voucher','Tipo de voucher','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','S','A','R','€','Vazio() .OR. Pertence("GRS")','G=Garantia;R=Renovacao;S=Substituicao','G=Garantia; R=Renovacao; S=Substituicao','G=Garantia; R=Renovacao; S=Substituicao','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_CTVOUC','C', 1,0,'Cod.Tp.Vouch','Cod.Tp.Vouch','Cod.Tp.Vouch','Codigo do tipo de voucher','Codigo do tipo de voucher','Codigo do tipo de voucher','@!','','€€€€€€€€€€€€€€ ','','SZH',0,'þÀ','','S','U','S','A','R','€','ExistCpo("SZH",M->Z00_CTVOUC)','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_DTPVOU','C',30,0,'Desc.Tp.Vouc','Desc.Tp.Vouc','Desc.Tp.Vouc','Descricao tipo de voucher','Descricao tipo de voucher','Descricao tipo de voucher','@!','','€€€€€€€€€€€€€€ ','Iif(INCLUI,Space(30),Posicione("SZH",1,xFilial("SZH")+M->Z00_CTVOUC,"ZH_DESCRI"))','',0,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_STAPED','C', 1,0,'Status Ped.','Status Ped.','Status Ped.','Status do pedido','Status do pedido','Status do pedido','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','S','U','S','A','R','€','Pertence("1234")','1=Aguard.Validacao;2=Aguard.Validacao/Verificacao;3=Aprov.e Emitido;4=Aprov. e nao Emitido','1=Aguard.Validacao;2=Aguard.Validacao/Verificacao;3=Aprov.e Emitido;4=Aprov. e nao Emitido','1=Aguard.Validacao;2=Aguard.Validacao/Verificacao;3=Aprov.e Emitido;4=Aprov. e nao Emitido','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_PARTRI','C', 9,0,'Param.Trilha','Param.Trilha','Param.Trilha','Parametro da trilha audit','Parametro da trilha audit','Parametro da trilha audit','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','S','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_ACAO'  ,'C', 1,0,'Acao no GAR','Acao no GAR','Acao no GAR','Acao no GAR','Acao no GAR','Acao no GAR','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','S','A','R','€','Vazio().OR.Pertence("12")','1=Revogar;2=Rejeitar','1=Revogar;2=Rejeitar','1=Revogar;2=Rejeitar','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_GARANT','N', 4,0,'Garantia','Garantia','Garantia','Garantia em dias','Garantia em dias','Garantia em dias','@R 9999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','S','A','R','','Positivo()','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_CONTAG','C', 1,0,'Contagem','Contagem','Contagem','Tipo de contagem','Tipo de contagem','Tipo de contagem','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','S','A','R','','Pertence("12") .OR. Vazio()','1=Dias corridos;2=Dias Uteis','1=Dias corridos;2=Dias Uteis','1=Dias corridos;2=Dias Uteis','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_QPROD' ,'C', 1,0,'Qual prod.?','Qual prod.?','Qual prod.?','Qual produto a considerar','Qual produto a considerar','Qual produto a considerar','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','S','A','R','€','Pertence("123") .OR. Vazio()','1=Mesmo produto pedido;2=Mesmo produto varejo;3=Somente certificado','1=Mesmo produto pedido;2=Mesmo produto varejo;3=Somente certificado','1=Mesmo produto pedido;2=Mesmo produto varejo;3=Somente certificado','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_PROD'  ,'C', 1,0,'Produto','Produto','Produto','Produto GAR','Produto GAR','Produto GAR','@!','','€€€€€€€€€€€€€€€','','',0,'þÀ','','','U','S','A','R','','','1=Certificado+Midia;2=Somente Certificado;3=Somente Certificado ou Certificado+Midia','1=Certificado+Midia;2=Somente Certificado;3=Somente Certificado ou Certificado+Midia','1=Certificado+Midia;2=Somente Certificado;3=Somente Certificado ou Certificado+Midia','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_HRREV' ,'N', 3,0,'Hr.p/Revogar','Hr.p/Revogar','Hr.p/Revogar','Prazo em horas p/ revogar','Prazo em horas p/ revogar','Prazo em horas p/ revogar','999','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','S','A','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_TPHRRE','C', 1,0,'Tp.Hr.p/Rev.','Tp.Hr.p/Rev.','Tp.Hr.p/Rev.','Tipo de horas p/ revogar','Tipo de horas p/ revogar','Tipo de horas p/ revogar','@!','','€€€€€€€€€€€€€€ ','','',0,'þA','','','U','S','A','R','','Pertence("12") .OR. Vazio()','1=Horas corridas;2=Horas comerciais','1=Horas corridas;2=Horas comerciais','1=Horas corridas;2=Horas comerciais','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_REGRA' ,'C', 2,0,'Cod. Regra','Cod. Regra','Cod. Regra','Codigo da regra','Codigo da regra','Codigo da regra','@!','','€€€€€€€€€€€€€€ ','','re',0,'þÀ','','S','U','S','A','R','','ExistCpo("SX5","re"+M->Z00_REGRA)','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_DREGRA','C',55,0,'Descr. Regra','Descr. Regra','Descr. Regra','Descricao da regra','Descricao da regra','Descricao da regra','@!S15','','€€€€€€€€€€€€€€ ','Iif(INCLUI,Space(55),Posicione("SX5",1,xFilial("SX5")+"re"+Z00->Z00_REGRA,"X5Descri()"))','',0,'þÀ','','','U','S','V','V','','','','','','','','Posicione("SX5",1,xFilial("SX5")+"re"+Z00->Z00_REGRA,"X5Descri()")','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_MOTIVO','M',10,0,'Motivo','Motivo','Motivo','Motivo de bloqueio','Motivo de bloqueio','Motivo de bloqueio','','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_MSBLQL','C', 1,0,'Bloqueado?','Bloqueado?','Bloqueado?','Registro bloqueado','Registro bloqueado','Registro bloqueado','','','€€€€€€€€€€€€€€ ','"2"','',9,'‚€','','','L','S','V','R','€','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_USERGI','C',17,0,'Log de Inclu','Log de Inclu','Log de Inclu','Log de Inclusao','Log de Inclusao','Log de Inclusao','','','€€€€€€€€€€€€€€€','','',9,'þÀ','','','L','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'Z00',NIL,'Z00_USERGA','C',17,0,'Log de Alter','Log de Alter','Log de Alter','Log de Alteracao','Log de Alteracao','Log de Alteracao','','','€€€€€€€€€€€€€€€','','',9,'þÀ','','','L','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	
	AAdd( aSX3, { 'SUO',NIL,'UO_AUTVOU' ,'C', 1,0,'Aut.Voucher?','Aut.Voucher?','Aut.Voucher?','Automacao de voucher?','Automacao de voucher?','Automacao de voucher?','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'SU9',NIL,'U9_AUTVOU' ,'C', 1,0,'Aut.Voucher?','Aut.Voucher?','Aut.Voucher?','Automacao de voucher?','Automacao de voucher?','Automacao de voucher?','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','','N','N','','','','' } )
	
	AAdd( aSX3, { 'ADF',NIL,'ADF_TRILHA','M', 10,0,'Trilha Audit','Trilha Audit','Trilha Audit','Trilha de auditoria','Trilha de auditoria','Trilha de auditoria','','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'ADF',NIL,'ADF_DADPED','M', 10,0,'Dados Pedido','Dados Pedido','Dados Pedido','Dados do pedido GAR','Dados do pedido GAR','Dados do pedido GAR','','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'ADF',NIL,'ADF_MOTVOU','C',  3,0,'Cod.Mot.Vouc','Cod.Mot.Vouc','Cod.Mot.Vouc','Codigo do motivo de vouch','Codigo do motivo de vouch','Codigo do motivo de vouch','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'ADF',NIL,'ADF_DPCONT','C',250,0,'De/para Cont','De/para Cont','De/para Cont','De/para Contato','De/para Contato','De/para Contato','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'ADF',NIL,'ADF_REENV' ,'C',100,0,'Reenv. Email','Reenv. Email','Reenv. Email','Reenvio de email c/ senha','Reenvio de email c/ senha','Reenvio de email c/ senha','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	AAdd( aSX3, { 'ADF',NIL,'ADF_REJPED','C',100,0,'Rejeitad.Ped','Rejeitad.Ped','Rejeitad.Ped','Rejeitado pedido GAR','Rejeitado pedido GAR','Rejeitado pedido GAR','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','','N','N','','','','' } )
	
	AAdd( aSIX, { 'Z00','1','Z00_FILIAL+Z00_CODIGO','Codigo'             ,'Codigo'             ,'Codigo'             ,'U','S',''       } )
	AAdd( aSIX, { 'Z00','2','Z00_FILIAL+Z00_DESCR' ,'Descricao'          ,'Descricao'          ,'Descricao'          ,'U','S',''       } )
	AAdd( aSIX, { 'SZ5','A','Z5_FILIAL+Z5_CPFT'    ,'CPF do titular'     ,'CPF do titular'     ,'CPF do titular'     ,'U','S','SZ5_10' } )
	AAdd( aSIX, { 'SZ5','B','Z5_FILIAL+Z5_CNPJCER' ,'CNPJ do certificado','CNPJ do certificado','CNPJ do certificado','U','S','SZ5_11' } )
	
	AAdd( aHelp, { 'Z00_CODIGO','Código do registro sequencial gerado automaticamente pelo sistema.' } )
	AAdd( aHelp, { 'Z00_DESCR' ,'Descrição do motivo do voucher a ser concedido.' } )
	AAdd( aHelp, { 'Z00_GRUPOS','Grupos de atendimento que irão enxergar este motivo de voucher.' } )
	AAdd( aHelp, { 'Z00_TPVOUC','Tipo de voucher G=garantia; R=renovação; S=substituição.' } )
	AAdd( aHelp, { 'Z00_CTVOUC','Código do tipo de voucher a ser gerado.' } )
	AAdd( aHelp, { 'Z00_DTPVOU','Descrição do tipo do voucher.' } )
	AAdd( aHelp, { 'Z00_STAPED','Status do pedido GAR. 1=aguardando validação; 2=aguardando validação/verificação; 3=aprovado e emitido; 4=aprovado e não emitido.' } )
	AAdd( aHelp, { 'Z00_PARTRI','Parâmetro sistêmico com as siglas da trilha de auditoria.' } )
	AAdd( aHelp, { 'Z00_ACAO'  ,'Ação a ser consultada no sistema GAR. 1=revogar certificado; 2=rejeitar pedido.' } )
	AAdd( aHelp, { 'Z00_GARANT','Prazo para garantia.' } )
	AAdd( aHelp, { 'Z00_CONTAG','Contagem do prazo de garantia. 1=dias corridos; 2=dias úteis.' } )
	AAdd( aHelp, { 'Z00_QPROD' ,'Qual produto a ser ressarcido. 1=mesmo produto pedido; 2=mesmo produto varejo; 3=somente certificado.' } )
	AAdd( aHelp, { 'Z00_HRREV' ,'Prazo em horas para revogar certificado.' } )
	AAdd( aHelp, { 'Z00_TPHRRE','Tipo de contagem do prazo de horas. 1=horas corridas; 2=horas comercia.' } )
	AAdd( aHelp, { 'Z00_REGRA' ,'Código da regra para o motivo do voucher.' } )
	AAdd( aHelp, { 'Z00_DREGRA','Descrição do código da regra do motivo do voucher.' } )
	AAdd( aHelp, { 'Z00_MOTIVO','Motivo do bloqueio ou do desbloqueio do registro. Aqui também estará a data/hora e nome de quem fez ação.' } )
	
	AAdd( aHelp, { 'ADF_TRILHA','Dados da trilha de auditoria do pedido GAR.' } )
	AAdd( aHelp, { 'ADF_DADPED','Dados do pedido GAR.' } )
	AAdd( aHelp, { 'ADF_MOTVOU','Tipo do motivo do voucher escolhido na concessão de voucher.' } )
	AAdd( aHelp, { 'ADF_DPCONT','Registro de/para na alteração do contato' } )
	AAdd( aHelp, { 'ADF_REENV' ,'Retorno da execução do reenvio de senha para revogação do certificado.' } )
	AAdd( aHelp, { 'ADF_REJPED','Retorno da execução da ação de rejeição do pedido GAR.' } )

	AAdd( aHelp, { 'UO_AUTVOU', 'Este registro fará parte do processo de automação de voucher?' } )
	AAdd( aHelp, { 'U9_AUTVOU', 'Este registro fará parte do processo de automação de voucher?' } )
	
	AAdd( aSX7, { 'Z00_REGRA' ,'001','X5Descri()'    ,'Z00_DREGRA','P','S','SX5',1,'xFilial("SX5")+"re"+M->Z00_REGRA','','U' } )
	AAdd( aSX7, { 'Z00_STAPED','001','U_A860GPTA()'  ,'Z00_PARTRI','P','N',''   ,0,''                                ,'','U' } )
	AAdd( aSX7, { 'Z00_CTVOUC','001','SZH->ZH_DESCRI','Z00_DTPVOU','P','S','SZH',1,'xFilial("SZH")+M->Z00_CTVOUC'    ,'','U' } )
Return