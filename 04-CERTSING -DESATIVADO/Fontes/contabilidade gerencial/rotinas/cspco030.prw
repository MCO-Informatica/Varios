//--------------------------------------------------------------------
// Rotina | CSPCO030 | Autor | Robson Gonçalves    | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Rotina que possibilita manutenção na tabela de 
//        | movimentos realizados.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
#Include 'Protheus.ch'

User Function CSPCO030()
	Local aButton := {}
	Local aSay := {}
	Local nOpcao := 0
	
	Private cCadastro := 'Manutenção de movimentos realizados...'
	 
	AAdd( aSay, 'Rotina para efetuar manutenção nos registros de movimentos realizados.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		PCO030Par()
	Endif
Return

//--------------------------------------------------------------------
// Rotina | PCO030Par1 | Autor | Robson Gonçalves  | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Parâmetros do usuário.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Par()
	Local aParamBox := {}
	Local aRet := {}
	Local aTpDesp := {'Despesas','Receitas','Capex'}
	Local aTpMov := {'Realizado','Orçado'}
	
	Local nTpDesp := 0
	Local nTpProc := 0        
	Local nTpMov := 0
	
	Private aTpProc := {'Alteração unitária','Alteração em lote'}
	
	AAdd(aParamBox,{1,'Data inicial',Ctod(Space(8)),'','','','',50,.T.})//01
	AAdd(aParamBox,{1,'Data final'  ,Ctod(Space(8)),'','U_PCO030VA()','','',50,.T.})//02
	
	AAdd(aParamBox,{2,'Tipo de contas',1, aTpDesp , 50,, .T.})//03
	
	AAdd(aParamBox,{1,'Lote contábil inicial',Space(6),,,,,50,.F.})//04
	AAdd(aParamBox,{1,'Lote contábil final'  ,Space(6),,'(mv_par05>=mv_par04)',,,50,.T.})//05
	
	AAdd(aParamBox,{1,'Registro inicial',0,'@E 999,999,999,999',,,,50,.F.})//06
	AAdd(aParamBox,{1,'Registro final'  ,0,'@E 999,999,999,999','(mv_par07>=mv_par06)',,,50,.T.})//07

	AAdd(aParamBox,{1,'Conta contábil inicial',Space(20),,'Vazio() .OR. ExistCpo("CT1",,1)','CT1',,80,.F.})//08
	AAdd(aParamBox,{1,'Conta contábil final'  ,Space(20),,'ExistCpo("CT1",,1)','CT1',,80,.T.})//09

	AAdd(aParamBox,{1,'Fornecedor inicial',Space(6),,,'SA2',,50,.F.})//10
	AAdd(aParamBox,{1,'Fornecedor final'  ,Space(6),,'(mv_par11>=mv_par10)','SA2',,50,.T.})//11

	AAdd(aParamBox,{1,'Atividade inicial',Space(25),,,,,99,.F.})//12
	AAdd(aParamBox,{1,'Atividade final'  ,Space(25),,'(mv_par13>=mv_par12)',,,99,.T.})//13
	
	AAdd(aParamBox,{2,'Tipo de manutenção', 1, aTpProc, 90,, .T.})//14
	
	AAdd(aParamBox,{1,'Detalhe', Space(100), '@!', '', '', "Iif(ValType(MV_PAR14)=='N',MV_PAR14,AScan(aTpProc,{|e|e==MV_PAR14}))==2", 119, .F. } )//15

	AAdd(aParamBox,{2,'Tipo de movimento', 1, aTpMov, 50,, .T.})//16
	
	If ParamBox( aParamBox, 'Parâmetros',@aRet,,,,,,,,.F.,.F.)
		nTpDesp := Iif( ValType( aRet[ 3 ] ) == 'N', aRet[ 3 ], AScan( aTpDesp, {|e| e==aRet[ 3 ] } ) )
		nTpProc := Iif( ValType( aRet[ 14] ) == 'N', aRet[ 14], AScan( aTpProc, {|e| e==aRet[ 14] } ) )
		nTpMov  := Iif( ValType( aRet[ 16] ) == 'N', aRet[ 16], AScan( aTpMov,  {|e| e==aRet[ 16] } ) )
		
		aRet[ 3 ] := nTpDesp
		aRet[ 14] := nTpProc                                                                        
		aRet[ 16] := nTpMov
		
		PCO030Qry( aRet )
	Else
		MsgInfo('Rotina abandonada pelo usuário.',cCadastro)
	Endif
Return

//--------------------------------------------------------------------
// Rotina | PCO030VA | Autor | Robson Gonçalves    | Data | 29/08/2016
//--------------------------------------------------------------------
// Descr. | Rotina de validação do campo data inicial e final.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
User Function PCO030VA()
	If Year( mv_par01 ) <> Year( mv_par02 )
		MsgAlert( 'A data inicial e a data final informada precisam ser do mesmo ano.','Validação da data' )
		Return( .F. )
	Endif
	If mv_par01 > mv_par02
		MsgAlert( 'A data inicial precisa ser menor ou igual a data final.','Validação da data' )
		Return( .F. )
	Endif
Return( .T. )

//--------------------------------------------------------------------
// Rotina | PCO030Qry | Autor | Robson Gonçalves   | Data | 29/08/2016
//--------------------------------------------------------------------
// Descr. | Elaboração da query de busca de dados na tabela.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Qry( aRet )
	Local cCount := "SELECT COUNT(*) AS QTD_REG FROM "
	Local cOrder := ''
	Local cSQL := ''
	Local cTabGrv := ''
	Local cTMP := ''
	Local cTRB := ''	
	Local cUpdate := ''
	Local cWhere := ''
	
	Local lProblema := .F.
	Local lTemDados := .F.
	
	cTabGrv := 'CSPCO010_' + StrZero(Year(aRet[1]),4)

	cWhere  := " WHERE DATALCT >= " + ValToSql(Dtos(aRet[1])) + " "
	cWhere  += "       AND DATALCT <= " + ValToSql(Dtos(aRet[2])) + " "
	cWhere  += "       AND LOTE >= '" + aRet[4] + "'"
	cWhere  += "       AND LOTE <= '" + aRet[5] + "'"
	cWhere  += "       AND REC >= " + LTrim(Str(aRet[6])) + " "
	cWhere  += "       AND REC <= " + LTrim(Str(aRet[7])) + " "
	cWhere  += "       AND D_E_L_E_T_ = ' '"
	cWhere  += "       AND LOTE <> '" + Space(6) + "'"
	cWhere  += "       AND CONTA >= " + ValToSql(aRet[8]) + " "
	cWhere  += "       AND CONTA <= " + ValToSql(aRet[9]) + " "

	If aRet[3] <> 2
		cWhere  += "       AND CODIGO >= " + ValToSql(aRet[10]) + " "
		cWhere  += "       AND CODIGO <= " + ValToSql(aRet[11]) + " "
	Endif

	cWhere  += "       AND ATIVIDADE >= " + ValToSql(aRet[12]) + " "
	cWhere  += "       AND ATIVIDADE <= " + ValToSql(aRet[13]) + " "

	If aRet[3] == 1
		cWhere  += "       AND MODELO = 'Despesas' "
	Elseif aRet[3] == 2
		cWhere  += "       AND MODELO = 'Receitas' "
	Elseif aRet[3] == 3
		cWhere  += "       AND MODELO = 'Capex' "
	Endif               
	
	If aRet[16] == 1                               
		cWhere  += "       AND CLAS = 'Realizado' "
	Else
		cWhere  += "       AND CLAS = 'Orcado' "
	Endif
	
	If aRet[ 14 ] == 1
		cSQL  := " SELECT DATALCT, "
		cSQL  += "        CONTA, "     
		cSQL  += "        DESCCTA, "   
		cSQL  += "        DESCRATV, "  
		cSQL  += "        VALOR, "     
		cSQL  += "        NOME_FORNE, "
		cSQL  += "        HIST, "
		cSQL  += "        TPITEM, "
		cSQL  += "        CCUSTO, "
		cSQL  += "        DESCCC, "    
		cSQL  += "        CRESULT, "   
		cSQL  += "        DSCRES, "  
		cSQL  += "        PRJTO, "     
		cSQL  += "        DPRJ, "
		cSQL  += "        REC, "
		cSQL  += "        DETALHE, "
		cSQL  += "        R_E_C_N_O_ "
		cSQL  += " FROM  " + cTabGrv + " "
		
		cOrder  += " ORDER BY CONTA, DATALCT"

		cSQL := ChangeQuery( cSQL + cWhere + cOrder )	
		cTRB := GetNextAlias()
	
		FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, selecionando dados...')
	
		If (cTRB)->( .NOT. BOF() ) .AND. (cTRB)->( .NOT. EOF() )
			TcSetField( cTRB, 'DATALCT'   , 'D' )
			TcSetField( cTRB, 'VALOR'     , 'N', 15, 6 )
			TcSetField( cTRB, 'R_E_C_N_O_', 'N', 15, 0 )
			
			PCO030Proc( cTRB, cTabGrv )
			
			(cTRB)->( dbCloseArea() )
		Else
			MsgAlert('Dados não localizados com os parâmetros informados.',cCadastro)
		Endif
	Else		 
		FWMsgRun(,{||  cCount := cCount + cTabGrv + " " + cWhere,;
		cCount := ChangeQuery( cCount ),;
		cTRB := GetNextAlias(),;
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cCount),cTRB,.F.,.T.),;
		lTemDados := ((cTRB)->( QTD_REG ) > 0 ),;
		(cTRB)->( dbCloseArea() )	},,'Aguarde, verificando os parâmetros...')
		If lTemDados 
			cUpdate := "UPDATE " + cTabGrv + " SET DETALHE = " + ValToSql( aRet[ 15 ] ) + " " + cWhere		
			If MsgYesNo( 'Foi possível localizar dados com os parâmetros informados.'+CRLF+CRLF+;
			             'Confirma a execução do processamento?'+CRLF+;
			             'Este processamento fará a gravação do parâmetro detalhe na tabela.', cCadastro )
				FWMsgRun(,{|| lProblema := ( TCSQLExec( cUpdate ) < 0 ) },,'Aguarde, atualizando os dados...')
				If lProblema
					CONOUT("ROTINA CSPCO030 - TCSQLError() " + TCSQLError())
					MsgInfo( 'Problemas na atualização TCSQLError() ' + TCSQLError() + ' ', cCadastro )
				Else
					CONOUT("ROTINA CSPCO030 EXECUTADA COM SUCESSO - DATA " + Dtoc( MsDate() ) + "HORA " + Time() )
					MsgInfo( 'Atualização efetuada com sucesso.', cCadastro )
				Endif
			Else
				MsgInfo('Rotina abandonada pelo usuário.',cCadastro)
			Endif
		Else
			MsgInfo('Com os parâmetros informados, não foi possível localizar dados suficientes para a manutenção, por favor, reveja os parâmetros.',cCadastro)
		Endif
	Endif
Return

//--------------------------------------------------------------------
// Rotina | PCO030Proc | Autor | Robson Gonçalves  | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Parâmetros de processamento.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Proc( cTRB, cTabGrv )
	Local aButton := {}
	Local aCOLS := {}
	Local aHeader := {}
	
	Local nButton := 0
	Local nCount := 0
	Local nPosButIni := 0
	
	Local oDlg
	Local oLbx 
	Local oPanelAll
	Local oPanelBot
	
	aHeader := {'Data de lançamento',;
	'Conta contab.',;
	'Descrição conta',;
	'Descrição atividade',;
	'Valor',;
	'Nome fornecedor',;
	'Histórico',;
	'Descrição classif. despesa',;
	'Centro de custo',;
	'Descrição centro de custo',;
	'Centro de resultado',;
	'Descrição centro de resultado',;
	'Projeto',;
	'Descrição projeto',;
	'Número reg. contábil',;
	'Detalhe',;
	'RECNO'}
	
	aButton := Array( 5 )
	
	FWMsgRun(,{|| PCO030Load( cTRB, @aCOLS, @nCount )},,'Aguarde, carregando os dados...')
	
	DEFINE MSDIALOG oDlg FROM 0,0 To 400,900 TITLE cCadastro PIXEL OF oMainWnd STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 2,2 SAY 'Total de registros: ' + LTrim( Str( nCount ) ) OF oPanelBot PIXEL COLOR CLR_BLUE SIZE 100,10
		
		//---------------------------------------------------------------------------------------------------
		// Esta instrução é para achar a posição inicial do botão no TPanel no sentido direita para esquerda.
		nPosButIni := ((oPanelBot:oParent:nWidth/2)-4)-((40+3)*4)
		//             |                             |  |  |   |
		//             +---------------+-------------+  |  |   +-> quantidade de botões.
		//                             |                |  +-----> espaço entre os botões.
		//                             |                +--------> tamanho do botão.
		//                             +-------------------------> área onde será colocado o botão
		
		@ 1,nPosButIni        BUTTON aButton[++nButton] PROMPT 'Pesquisar'  SIZE 40,11 PIXEL OF oPanelBot ACTION (PCO030Pesq(@oLbx))
		@ 1,nPosButIni+43     BUTTON aButton[++nButton] PROMPT 'Visualizar' SIZE 40,11 PIXEL OF oPanelBot ACTION (PCO030Vis(oLbx,cTabGrv))
		@ 1,nPosButIni+(43*2) BUTTON aButton[++nButton] PROMPT 'Manutenção' SIZE 40,11 PIXEL OF oPanelBot ACTION (PCO030Mnt(@oLbx,cTabGrv))
		@ 1,nPosButIni+(43*3) BUTTON aButton[++nButton] PROMPT 'Sair'       SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
   	
   	oLbx := TwBrowse():New(1,1,1000,1000,,aHeader,,oPanelAll,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:SetArray(aCOLS)
	   oLbx:bLine := {|| AEval( aCOLS[oLbx:nAt],{|xValue,nIndex| aCOLS[oLbx:nAt,nIndex]})}
	ACTIVATE MSDIALOG oDlg CENTERED	
Return

//--------------------------------------------------------------------
// Rotina | PCO030Load | Autor | Robson Gonçalves  | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Carregar dados da tabela no vetor.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Load( cTRB, aCOLS, nCount )
	Local nElem := 0
	Local nFCount := 0
	Local nI := 0
	
	nFCount := (cTRB)->( FCount() )
	
	While (cTRB)->( .NOT. EOF() )
		AAdd( aCOLS, Array( nFCount ) )
		nElem++
		For nI := 1 To nFCount
			aCOLS[ nElem, nI ] := (cTRB)->( FieldGet( nI ) )
		Next nI
		(cTRB)->( dbSkip() )	
	End
	nCount := nElem
Return

//--------------------------------------------------------------------
// Rotina | PCO030Pesq | Autor | Robson Gonçalves  | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Pesquisar registro.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Pesq( oLbx )
	Local aPar := {}
	Local aRet := {}
	
	Local bAScan := {|| .T. }
	Local bCampo  := {|nCPO| Field(nCPO) }
	
	Local cSeek := ''
	
	Local nBegin := 0
	Local nColuna := 0
	Local nEnd := 0
	Local nP := 0
	
	AAdd( aPar, { 2, 'Pesquisar pela coluna', 1, oLbx:aHeaders , 99, '.T.', .T.})
	AAdd( aPar, { 1, 'Valor para pesquisar'  , Space( 99 ),'','','','',99,.T.})
	
	If ParamBox( aPar,'Pesquisar',@aRet,,,,,,,,.F.)
		cSeek := RTrim( aRet[ 2 ] )
		nColuna := Iif( ValType( aRet[ 1 ] ) == 'N', aRet[ 1 ], AScan( oLbx:aHeaders, {|e| e==aRet[ 1 ] } ) )
		nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
		nEnd := Len( oLbx:aArray )
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		bAScan := {|p| Upper( AllTrim( cSeek ) ) $ AllTrim( p[ nColuna ] ) } 
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
 			MsgAlert('Informação não localizada','Pesquisar')
		Endif
   Endif	
Return

//--------------------------------------------------------------------
// Rotina | PCO030Vis | Autor | Robson Gonçalves   | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Visualizar registro.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Vis( oLbx, cTabGrv )
	Local aCampo := {}
	Local aStru := {}
	Local aTitle := {}
	
	Local cCampo := ''
	Local cTRB := ''
	
	Local bCampo  := {|nCPO| Field(nCPO) }	
	
	Local i := 0
	Local nRecNo := 0 
	
	Local oDlg
	Local oScroll
	
	nRecNo := oLbx:aArray[ oLbx:nAt, Len( oLbx:aArray[ oLbx:nAt ] ) ]
	
	cTRB := GetNextAlias()
	cSQL := "SELECT * "
	cSQL += "FROM "+cTabGrv+" "
	cSQL += "WHERE R_E_C_N_O_ = "+LTrim(Str(nRecNo))+" "
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->( .NOT. BOF() ) .AND. (cTRB)->( .NOT. EOF() )
		TcSetField( cTRB, 'DATALCT'   , 'D' )
		TcSetField( cTRB, 'DATAGRV'   , 'D' )
		TcSetField( cTRB, 'VALOR'     , 'N', 15, 6 )
		TcSetField( cTRB, 'R_E_C_N_O_', 'N', 15, 0 )
		
		aStru := (cTRB)->( dbStruct() )
		
		For i := 1 TO (cTRB)->(FCount())
			cCampo := Eval( bCampo, i )
			
			If aStru[ i, 2 ] == 'L'
				M->&(cCampo) := Iif( (cTRB)->( FieldGet( i ) ), 'T', 'F' )
			Else
				M->&(cCampo) := (cTRB)->( FieldGet( i ) )
			Endif
		Next	i
		
		PCO030Title( @aTitle )
		
		ASize( aCampo, Len( aStru ) )
		AFill( aCampo, {,} ) 
		
		DEFINE MSDIALOG oDlg FROM 0,0 TO 600,700 TITLE 'Visualizar o registro de movimentos realizados' PIXEL
			@ 00,00 SCROLLBOX oScroll VERTICAL OF oDlg PIXEL
			oScroll:Align := CONTROL_ALIGN_ALLCLIENT
			PCO030Objs( aStru, aTitle, cTRB, @aCampo, oDlg, @oScroll )
		ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| oDlg:End() }, {|| oDlg:End() } ) 	
	Else
		MsgAlert( 'Registro não localizado.', cCadastro )
	Endif
	(cTRB)->( dbCloseArea())
Return

//--------------------------------------------------------------------
// Rotina | PCO030Objs  | Autor | Robson Gonçalves | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Elaborar a interface de visualização.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Objs( aStru, aTitle, cTRB, aCampo, oDlg, oScroll )
	Local aPict := {'999999999999999','@E 999,999,999,999,999.999999','@E 999,999,999,999,999'}
	Local bGet
	Local bSay

	Local cCampo := ''
	Local cPict := ''

	Local nLinha := 5
	Local nTamanho := 0
	Local x := 0
	
	For x := 1 To Len(aStru)
		cPict := ''
		bSay := &("{|| '" + aTitle[ AScan( aTitle, {|e| e[ 2 ] == aStru[ x, 1 ] } ), 1 ] + "'}")
		cCampo := aStru[x,1]
		aCampo[x,1] := TSay():New( nLinha, 2 , bSay,oScroll,,,,,,.T.)
		bGet := &('{ |u| Iif( (cTRB)->(PCount()) == 0, m->'+cCampo+','+'m->'+cCampo+' := u)}')
	
		If aStru[x,2] == 'N'
			cPict := Iif( cCampo == 'R_E_C_N_O_', aPict[ 1 ], Iif( aStru[ x, 4 ] > 0, aPict[ 2 ], aPict[ 3 ] ) )
		Elseif aStru[x,2] == 'D'
			cPict := '@D'
		Endif
		
		nTamanho := CalcFieldSize( aStru[x,2], aStru[x,3], aStru[x,4], cPict, '') + 9
		
		If ( aStru[x,2] == 'D' )
			nTamanho += 2
		Endif
		
		nTamanho := Iif((nTamanho>(((oDlg:nRight)-(oDlg:nLeft))/2)-66) .OR. aStru[x,2] == 'M' ,(((oDlg:nRight)-(oDlg:nLeft))/2)-66,nTamanho)
		
		If aStru[x,2] == 'M'
			aCampo[x,2] := TMultiGet():New( nLinha,55, bGet,oScroll,nTamanho-1,100,,,,,,.T.,,,,,,.T.,,,,,,)
		Else
			aCampo[x,2] := TGet():New( nLinha,55, bGet,oScroll,nTamanho, ,cPict ,,,,,.F.,,.T.,'',.F.,,.F.,.F.,,.T.,.F.,,aStru[x,1],aStru[x,1],.F.,0,.T.)
		Endif
		nLinha := nLinha + If(aStru[x,2]=='M',102,14)
	Next x
Return

//--------------------------------------------------------------------
// Rotina | PCO030Title | Autor | Robson Gonçalves | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Carregar títulos dos campos.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Title( aTitle )
	AAdd( aTitle, { 'Data lançamento'        , 'DATALCT' })
	AAdd( aTitle, { 'Lote contábil'          , 'LOTE' })
	AAdd( aTitle, { 'Conta contábil'         , 'CONTA' })
	AAdd( aTitle, { 'Descrição conta'        , 'DESCCTA' })
	AAdd( aTitle, { 'Atividade'              , 'ATIVIDADE' })
	AAdd( aTitle, { 'Descrição atividade'    , 'DESCRATV' })
	AAdd( aTitle, { 'Valor'                  , 'VALOR' })
	AAdd( aTitle, { 'Nome fornecedor'        , 'NOME_FORNE' })
	AAdd( aTitle, { 'Código fornecedor'      , 'CODIGO' })
	AAdd( aTitle, { 'CNPJ'                   , 'CNPJ' })
	AAdd( aTitle, { 'Histórico'              , 'HIST' })
	AAdd( aTitle, { 'Classif.Despesa'        , 'CLASSDSP' })
	AAdd( aTitle, { 'Descr.Classif. Desp.'   , 'TPITEM' })
	AAdd( aTitle, { 'Centro de custo'        , 'CCUSTO' })
	AAdd( aTitle, { 'Descr.C.Custo'          , 'DESCCC' })
	AAdd( aTitle, { 'Centro de resultado'    , 'CRESULT' })
	AAdd( aTitle, { 'Descrição C.Result.'    , 'DSCRES' })
	AAdd( aTitle, { 'Projeto'                , 'PRJTO' })
	AAdd( aTitle, { 'Descrição projeto'      , 'DPRJ' })
	AAdd( aTitle, { 'Tipo de movimento'		  , 'CLAS' })
	AAdd( aTitle, { 'Tipo de resultado'		  , 'MODELO' })
	AAdd( aTitle, { 'Núm.Reg.Contábil'       , 'REC' })
	AAdd( aTitle, { 'Seq.Contabilização'     , 'SEQUEN' })
	AAdd( aTitle, { 'Função orig.Contabiliz.', 'ORIGEM' })
	AAdd( aTitle, { 'Filial + Seg + Produto' , 'CPROD' })
	AAdd( aTitle, { 'Descr.Segmento'         , 'DPROD' })
	AAdd( aTitle, { 'Descrição do canal'     , 'CCANAL' })
	AAdd( aTitle, { 'Código do canal'        , 'DCANAL' })
	AAdd( aTitle, { 'Núm.Ped.Compras'        , 'PEDIDO' })
	AAdd( aTitle, { 'Item Ped. Compras'      , 'ITEMPED' })
	AAdd( aTitle, { 'Número de contrato'     , 'CONTRATO' })
	AAdd( aTitle, { 'Revisão do contrato'    , 'REVCONTR' })
	AAdd( aTitle, { 'Filial da medição'      , 'FILMEDICAO' })
	AAdd( aTitle, { 'Número da medição'      , 'MEDICAO' })
	AAdd( aTitle, { 'Item da medição'        , 'ITEMED' })
	AAdd( aTitle, { 'Planilha do contrato'   , 'PLANILHA' })
	AAdd( aTitle, { 'Data de gravação'       , 'DATAGRV' })
	AAdd( aTitle, { 'Detalhe'                , 'DETALHE' })
	AAdd( aTitle, { 'Revisão do orç.'        , 'REVISAO' })
	AAdd( aTitle, { 'Flag alt.Contábil'      , 'FLAG_CONTA' })
	AAdd( aTitle, { 'Nnúmero do registro'    , 'R_E_C_N_O_' })
Return

//--------------------------------------------------------------------
// Rotina | PCO030Mnt | Autor | Robson Gonçalves   | Data | 18/08/2016
//--------------------------------------------------------------------
// Descr. | Possibilitar manutenção no campo detalhe.
//--------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//--------------------------------------------------------------------
Static Function PCO030Mnt( oLbx, cTabGrv )
	Local aPar := {}
	Local aRet := {}
	
	Local bOk := {|| MsgYesNo( 'Confirma a gravação da informação?', cCadastro ) }
	
	Local cDetalhe := Space(100)
	Local cSQL := ''
	
	Local lContinua := .T.
	
	Local nP_DETALHE := 0
	Local nP_RECNO := 0
	
	nP_DETALHE := AScan( oLbx:aHeaders, {|e| e=='Detalhe' } )
	cDetalhe := oLbx:aArray[ oLbx:nAt, nP_DETALHE ]
	  
	AAdd( aPar,{ 1, 'Detalhe', cDetalhe, '@!', '', '', '', 119, .F. } )
	
	If ParamBox( aPar, 'Manutenção', @aRet, bOK,,,,,,, .F. )
		If Empty( aRet[ 1 ] )
			lContinua := MsgYesNo('Identifiquei que o campo está vazio, é para gravar assim mesmo?', cCadastro )
		Endif
		If lContinua
			nP_RECNO   := AScan( oLbx:aHeaders, {|e| e=='RECNO' } )  
			oLbx:aArray[ oLbx:nAt, nP_DETALHE ] := aRet[ 1 ]
			oLbx:Refresh()
			
			cSQL := "UPDATE "+cTabGrv+" SET DETALHE = '"+aRet[ 1 ]+"' WHERE R_E_C_N_O_ = "+LTrim( Str( oLbx:aArray[ oLbx:nAt, nP_RECNO ] ) )
			
			If TCSqlExec( cSQL ) < 0
				MsgStop('Ocorreu o seguinte erro ao tentar atualizar a tabela de dados: '+Chr(10)+Chr(10)+AllTrim(TcSqlError()),cCadastro)
			Else
				MsgInfo('Atualização efetuada com sucesso.',cCadastro)
			Endif
		Endif		
	Endif
Return