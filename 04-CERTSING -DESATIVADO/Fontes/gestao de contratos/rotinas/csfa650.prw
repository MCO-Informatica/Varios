//--------------------------------------------------------------------------------
//Funções específicas para cada ação....
//--------------------------------------------------------------------------------
//A650Cau 	- Rotina que envia e-mail sobre inclusão de caução.
//A650SCau	- Rotina que envia e-mail sobre solicitação de caução.
//A650Med 	- Rotina que envia e-mail sobre inclusão de medição manual/automática.
//A650Plan	- Rotina que envia e-mail sobre inclusão de planilha.
//A650Reaj	- Rotina via JOB que avisa sobre reajuste.
//A650Rev 	- Rotiba que envia e-mail sobre inclusão de revisão.
//A650Sit 	- Rotina que envia e-mail sobre situação de caução.
//A650Ven 	- Função que verifica se há contrato para vencer.
//A650WFAp	- Rotina para enviar o WF de aprovação do contrato.
//A650Vcto 	- Rotina via JOB que avisa sobre vencimento de Planilha.
//--------------------------------------------------------------------------------
//Funções auxiliares para todos.
//--------------------------------------------------------------------------------
//A650User 	 - Buscar todos os usuários na base de usuários Protheus.
//A650Acesso - Buscar os acessos dos usuários/grupo de usuários.
//A650Param  - Criar e/ou atribuir valores aos parâmetros da rotina.
//A650Entid  - Buscar as entidades dos fornecedores.
//A650HTML 	 - Rotina para elaborar o arquivo HTML a ser enviado no e-mail.
//UPD650	 - Função update para criar a tabela de eventos.
//--------------------------------------------------------------------------------

#Include 'Protheus.ch'
#Include 'TbiConn.ch'
#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
#DEFINE cTP_DOC '#1' // Tipo de documento em SCR para aprovação de contratos.

STATIC aIsRead := {}
STATIC cMV_650DIR  := ''
STATIC cMV_EXCECAO := ''
STATIC cMV_650KEY  := ''
STATIC cMV_650SCAU := ''
STATIC cMV_650CAU  := ''
STATIC cMV_650NCAU := ''
STATIC cMV_650MED  := ''
STATIC cMV_650PLAN := ''
STATIC cMV_650REAJ := ''
STATIC cMV_650REV  := ''
STATIC cMV_650SIT  := ''
STATIC cMV_650CAN  := ''
STATIC cMV_650VEN  := ''
STATIC cMV_650PROC := ''
STATIC cMV_650VCTO := ''
STATIC cMV_IPSRV   := ''
STATIC cMV_650USER := ''
//--------------------------------------------------------------------------------
// Rotina | A650Ven      | Autor | Robson Gonçalves              | Data | 17.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina envio de e-mail quando contrato em fase de vencimento.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
User Function A650Ven( lJob )
	Local nOpc      := 0
	Local aSay      := {}
	Local aButton   := {}
	Local lModoUser := (lJob==NIL)
	Local dDataRef  := MsDate()
	Local cNUMCTR   := ''
	Private cCadastro := 'Aviso de vencimento de contratos'
	
	If lJob == NIL
		SetKey( VK_F12, {|| A650DataRef( @dDataRef, @cNUMCTR ) } )
		
		AAdd( aSay, 'O objetivo desta rotina é verificar os vencimentos dos contratos.' )
		AAdd( aSay, 'Contratos nas condições de vencimento, será enviado e-mail aos usuários' )
		AAdd( aSay, 'que possuem acesso ao referido contrato.' )
		AAdd( aSay, '' )
		AAdd( aSay, '' )
		AAdd( aSay, 'Clique F12 para configurar os parâmetros e depois em OK para prosseguir...' )
		AAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch() }} )
		AAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
		FormBatch( 'Aviso de vencimento de contratos', aSay, aButton )
		
		If nOpc == 1
			Processa( {|| A650ProcVen(lModoUser,dDataRef,cNUMCTR) }, 'Aviso de vencimento de contrato', 'Processando os dados, aguarde...', .F. )
		Endif
		SetKey( VK_F12, NIL )
	Else
		Conout('CSFA650-INÍCIO DO PROCESSAMENTO DE AVISOS DE VENCIMENTO/TÉRMINO/VENCIMENTO PERIÓDICO DE CONTRATOS.')
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02' MODULO 'GCT'
			Conout('CSFA650-ROTINA ESTÁ SENDO EXECUTADA EM MODO JOB.')
			A650ProcVen(lModoUser,NIL,NIL)
		RESET ENVIRONMENT
		Conout('CSFA650-FIM DO PROCESSAMENTO DE AVISOS DE VENCIMENTO/TÉRMINO/VENCIMENTO PERIÓDICO DE CONTRATOS.')
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A650DataRef  | Autor | Robson Gonçalves              | Data | 11.09.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para possibilitar usuário informar a data na query de busca.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A650DataRef( dDataRef,cNUMCTR )
	Local aPar := {}
	Local aRet := {}
	Local bOk := {|| .T. }
	Local cBkp := cCadastro
	cCadastro := 'Parâmetro'
	Set( 4, 'dd/mm/yyyy' )
	AAdd( aPar,{ 1, 'Data referência' , dDataRef , '99/99/9999', '', ''  , '', 50, .T. })
	AAdd( aPar,{ 1, 'Filtrar contrato', Space(15), '@!'        , '',"CN9", '',100, .F. })
	If ParamBox( aPar, 'Data referência', @aRet, bOK, , , , , , , .F., .F. )
		dDataRef := MV_PAR01
		cNUMCTR  := MV_PAR02
	Endif
	cCadastro := cBkp
Return

//--------------------------------------------------------------------------------
// Rotina | A650ProcVen  | Autor | Robson Gonçalves              | Data | 17.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para processar os contratos em fase de vencimento.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A650ProcVen(lModoUser,dDataRef,cNUMCTR)
	Local cSQL := ''
	Local cTRB := ''
	//Local lGetUser := .F.
	//Local lAcesso := .T.
	//Local aUser := {}
	Local cEntidade := ''
	Local aEntidade := {}
	Local aSendTo := {}
	Local cEmail := ''
	Local cTemplate := ''
	Local cFileHTML := ''
	Local aCN9 := {}
	Local cForCli := ''
	Local aCN9_TPRENO := {}
	Local aCN9_UNVIGE := {}
	Local aEXCECAO := {}
	Local ni :=1
	Local lServerTst := .F.
	Local cAssunto	 := ''
	
	DEFAULT dDataRef := MsDate()
	DEFAULT cNUMCTR := ''
	
	lModoUser := .F. 
	aCN9_TPRENO := StrToKarr( Posicione( 'SX3', 2, 'CN9_TPRENO', 'X3CBox()' ), ';' )
	aCN9_UNVIGE := StrToKarr( Posicione( 'SX3', 2, 'CN9_UNVIGE', 'X3CBox()' ), ';' )
   
	If lModoUser
		ProcRegua(0)
	Endif
	
	A650Param()
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" )
	
	aEXCECAO := StrToKarr( cMV_EXCECAO, ';' )
	
	cSQL := "SELECT '1-VENCTO' AS TIPO,"
	cSQL += "		 CN9_FILIAL,"
	cSQL += "		 CN9_NUMERO,"
	cSQL += "		 CN9_REVISA,"
	cSQL += "		 CN9_DESCRI,"
	cSQL += "		 CN9_DTINIC,"
	cSQL += "		 CN9_DTFIM,"
	cSQL += "		 CN9_TPCTO,"
	cSQL += "		 CN1_ESPCTR,"
	cSQL += "      CN9_CLIENT, "
	cSQL += "      CN9_LOJACL, "
	cSQL += "		 CN9_VLATU,"
	cSQL += "      CN9_TPRENO, "
	cSQL += "		 CN9_AVITER,"
	cSQL += "		 CN9_AVIPER,"
	cSQL += "      CN9_VIGE, "
	cSQL += "      CN9_UNVIGE, "
	cSQL += "      CN9_XOPORT, "
	
	cSQL += "	   TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD') AS DIAS,"
	cSQL += "	   (CN9_AVIPER + (TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD'))) AS RESULTADO, "
    cSQL += "	   CN9_CODOBJ "
	cSQL += "FROM  "+RetSqlName("CN9")+" CN9 "
	cSQL += "		 INNER JOIN "+RetSqlName("CN1")+" CN1 "
	cSQL += "					ON CN1_FILIAL = CN9_FILIAL"
	cSQL += "						AND CN1_CODIGO = CN9_TPCTO"
	cSQL += "						AND CN1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE "
	IF Empty(cNUMCTR)
		cSQL += "      CN9_FILIAL BETWEEN ' ' AND 'ZZ'"
		cSQL += "		 AND CN9_NUMERO BETWEEN ' ' AND 'ZZZZZZZZZZZZZZZ'"
	Else
		cSQL += "      CN9_FILIAL = '"+ xFilial('CN9') +"'"
		cSQL += "		 AND CN9_NUMERO = '"+ cNUMCTR +"'"
	EndIF
	cSQL += "		 AND CN9_SITUAC = '05'"
	cSQL += "		 AND CN9_REVATU = '   '"
	cSQL += "		 AND CN9_AVITER > 0"
	cSQL += "		 AND ( TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD' ) = CN9_AVITER )"
	cSQL += "		 AND CN9.D_E_L_E_T_ =  ' ' "
	
	cSQL += " UNION "
	
	cSQL += "SELECT '2-TERMIN' AS TIPO,"
	cSQL += "		 CN9_FILIAL,"
	cSQL += "		 CN9_NUMERO,"
	cSQL += "		 CN9_REVISA,"
	cSQL += "		 CN9_DESCRI,"
	cSQL += "		 CN9_DTINIC,"
	cSQL += "		 CN9_DTFIM,"
	cSQL += "		 CN9_TPCTO,"
	cSQL += "		 CN1_ESPCTR,"
	cSQL += "      CN9_CLIENT, "
	cSQL += "      CN9_LOJACL, "
	cSQL += "		 CN9_VLATU,"
	cSQL += "      CN9_TPRENO, "
	cSQL += "		 CN9_AVITER,"
	cSQL += "		 CN9_AVIPER,"
	cSQL += "      CN9_VIGE, "
	cSQL += "      CN9_UNVIGE, "
	cSQL += "      CN9_XOPORT, "
	
	cSQL += "	   TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD') AS DIAS,"
	cSQL += "	   (CN9_AVIPER + (TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD'))) AS RESULTADO, "
    cSQL += "	   CN9_CODOBJ "
	cSQL += "FROM  "+RetSqlName("CN9")+" CN9 "
	cSQL += "		 INNER JOIN "+RetSqlName("CN1")+" CN1 "
	cSQL += "					ON CN1_FILIAL = CN9_FILIAL"
	cSQL += "						AND CN1_CODIGO = CN9_TPCTO"
	cSQL += "						AND CN1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE "
	IF Empty(cNUMCTR)
		cSQL += "      CN9_FILIAL BETWEEN ' ' AND 'ZZ'"
		cSQL += "		 AND CN9_NUMERO BETWEEN ' ' AND 'ZZZZZZZZZZZZZZZ'"
	Else
		cSQL += "      CN9_FILIAL = '"+ xFilial('CN9') +"'"
		cSQL += "		 AND CN9_NUMERO = '"+ cNUMCTR +"'"
	EndIF
	cSQL += "		 AND CN9_SITUAC = '05'"
	cSQL += "		 AND CN9_REVATU = '   '"
	cSQL += "		 AND ( TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD' ) = 0 )"
	cSQL += "		 AND CN9.D_E_L_E_T_ =  ' ' "
	
	cSQL += " UNION "
	
	cSQL += "SELECT '3-PERIOD' AS TIPO,"
	cSQL += "		 CN9_FILIAL,"
	cSQL += "		 CN9_NUMERO,"
	cSQL += "		 CN9_REVISA,"
	cSQL += "		 CN9_DESCRI,"
	cSQL += "		 CN9_DTINIC,"
	cSQL += "		 CN9_DTFIM,"
	cSQL += "		 CN9_TPCTO,"
	cSQL += "		 CN1_ESPCTR,"
	cSQL += "      CN9_CLIENT, "
	cSQL += "      CN9_LOJACL, "
	cSQL += "		 CN9_VLATU,"
	cSQL += "      CN9_TPRENO, "
	cSQL += "		 CN9_AVITER,"
	cSQL += "		 CN9_AVIPER,"
	cSQL += "      CN9_VIGE, "
	cSQL += "      CN9_UNVIGE, "
	cSQL += "      CN9_XOPORT, "
	
	cSQL += "	   TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD') AS DIAS,"
	cSQL += "	   (CN9_AVIPER + (TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD'))) AS RESULTADO, "
	cSQL += "	   CN9_CODOBJ "
	cSQL += "FROM  "+RetSqlName("CN9")+" CN9 "
	cSQL += "		 INNER JOIN "+RetSqlName("CN1")+" CN1 "
	cSQL += "					ON CN1_FILIAL = CN9_FILIAL"
	cSQL += "						AND CN1_CODIGO = CN9_TPCTO"
	cSQL += "						AND CN1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE "
	IF Empty(cNUMCTR)
		cSQL += "      CN9_FILIAL BETWEEN ' ' AND 'ZZ'"
		cSQL += "		 AND CN9_NUMERO BETWEEN ' ' AND 'ZZZZZZZZZZZZZZZ'"
	Else
		cSQL += "      CN9_FILIAL = '"+ xFilial('CN9') +"'"
		cSQL += "		 AND CN9_NUMERO = '"+ cNUMCTR +"'"
	EndIF
	cSQL += "		 AND CN9_SITUAC = '05'"
	cSQL += "		 AND CN9_REVATU = '   '"
	cSQL += "		 AND CN9_AVITER > 0"
	cSQL += "		 AND CN9_AVIPER > 0"
	cSQL += "		 AND TO_DATE(CN9_DTFIM,'YYYYMMDD') >= TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD' )"
	cSQL += "		 AND ( TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD' ) < CN9_AVITER )"
	cSQL += "      AND ( MOD( (TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD' ) - (TO_DATE(CN9_DTFIM,'YYYYMMDD') - CN9_AVITER)) , CN9_AVIPER ) = 0 ) "
	cSQL += "		 AND CN9.D_E_L_E_T_ =  ' '"
	cSQL += "ORDER  BY TIPO, CN9_FILIAL, CN9_NUMERO, CN9_REVISA	"
	
//	MemoWrite("C:\Protheus\tmp\A650ProcVen.SQL",cSQL)
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGenQry(,,cSQL), cTRB, .T., .T. )
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		ApMsgInfo('QUERY PRINCIPAL NÃO LOCALIZOU NENHUM REGISTRO.','A650ProcVen')
	Endif
	
	While (cTRB)->( .NOT. EOF() )
		If lModoUser
			IncProc()
		Endif
		
		cEmail := U_GCT40USR( '7=', 'X=7', (cTRB)->CN9_FILIAL, (cTRB)->CN9_NUMERO, (cTRB)->CN9_REVISA )	
		
		aCN9 := Array(16)
			
		If (cTRB)->CN1_ESPCTR == '1'
			cForCli := 'Dados do fornecedor'
			A650Entid( (cTRB)->CN9_FILIAL, (cTRB)->CN9_NUMERO, @cEntidade, 'HTML' )
		Else
			cForCli := 'Dados do cliente'
			aEntidade := SA1->( GetAdvFVal( 'SA1', { 'A1_NOME', 'A1_CGC' }, xFilial('SA1') + (cTRB)->( CN9_CLIENT + CN9_LOJACL ), 1 ) )
			cEntidade := aEntidade[ 1 ] + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			aCN9[ 15] := (cTRB)->CN9_XOPORT
		Endif
	
		cTemplate := cMV_650DIR + cMV_650VEN
		cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'
	
		aCN9[ 13] := cForCli
		aCN9[ 1 ] := (cTRB)->CN9_FILIAL + '-' + RTrim( ( SM0->( GetAdvFVal( 'SM0', 'M0_FILIAL', cEmpAnt + (cTRB)->CN9_FILIAL , 1 ,'' ) ) ) )
		aCN9[ 2 ] := (cTRB)->CN9_NUMERO
		If Empty( (cTRB)->CN9_REVISA )
			aCN9[ 3 ] := 'SEM REVISÃO'
		Else
			aCN9[ 3 ] := (cTRB)->CN9_REVISA
		Endif
		aCN9[ 4 ] := (cTRB)->CN9_DESCRI
		aCN9[ 5 ] := cEntidade
		aCN9[ 6 ] := LTrim( Str( (cTRB)->CN9_VIGE, 6, 0 ) ) + ' ' + RTrim( SubStr( aCN9_UNVIGE[ Val( (cTRB)->CN9_UNVIGE ) ], 3 ) )
		aCN9[ 7 ] := Dtoc(Stod((cTRB)->CN9_DTFIM))
		aCN9[ 8 ] := LTrim(Str((cTRB)->DIAS,6))+' dias.'
		If Empty( (cTRB)->CN9_TPRENO )
			aCN9[ 14] := 'SEM TIPO DE RENOVAÇÃO'
		Else
			aCN9[ 14] := RTrim( SubStr( aCN9_TPRENO[ Val( (cTRB)->CN9_TPRENO ) ], 3 ) )
		Endif
			
		// Retirar os e-mails registrados no parâmetro MV_EXCECAO.
		For nI := 1 To Len( aEXCECAO )
			If aEXCECAO[ nI ] $ cEmail
				cEmail := StrTran( cEmail, aEXCECAO[ nI ], '' )
			Endif
		Next nI
			
		If (cTRB)->TIPO == '1-VENCTO'
			aCN9[ 9 ] := 'vencimento'
			aCN9[ 10] := 'Este e-mail é informativo para o aviso de vencimento de contrato conforme dados a seguir. <br>'
			aCN9[ 10] += 'Procure a área de compras para iniciar o processo de renovação.'
			aCN9[ 11] := cAssunto + 'Aviso de vencimento do contrato - ' + alltrim((cTRB)->CN9_DESCRI)
			If (cTRB)->CN1_ESPCTR == '1'
				If (cTRB)->CN9_TPRENO == '1'
					cEmail := cEmail + ';' + cMV_EXCECAO
				Endif
			Endif
		ElseIf (cTRB)->TIPO == '2-TERMIN'
			aCN9[ 9 ] := 'encerramento'
			aCN9[ 10] := 'Este e-mail é informativo para o aviso de encerramento do contrato conforme dados a seguir.'
			aCN9[ 11] := 'Aviso de encerramento do contrato - ' + alltrim((cTRB)->CN9_DESCRI)
		Elseif (cTRB)->TIPO == '3-PERIOD'
			aCN9[ 9 ] := 'vencimento periódico'
			aCN9[ 10] := 'Este e-mail é informativo para o aviso de vencimento periódico de contrato conforme dados a seguir. <br>'
			aCN9[ 10] += 'Procure a área de compras para iniciar o processo de renovação.'
			aCN9[ 11] := cAssunto + 'Aviso de vencimento periódico do contrato - ' + alltrim((cTRB)->CN9_DESCRI)
		Endif

		aCN9[16] := RetOBjSYP((cTRB)->CN9_CODOBJ)
			
		If Empty( cEmail )
			cEmail := cMV_650KEY
			aCN9[ 12] := 'O contrato acima está sem e-mail de usuário para notificação de vencimento de contrato. Acesse a rotina Notifiação de Vencimentos para ajustar.'
		Else
			cEmail += ';' + cMV_650KEY	
		EndIF
		
		cEmail := StrTran( cEmail, ';;', ';' )

		A650HTML( cFileHTML, cTemplate, cEmail, aCN9 )
			
		aCN9 := {}
		aSendTo := {}
		aEntidade := {}
			
		cEmail := ''
		cEntidade := ''
			
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------------
// Rotina | R650Ven      | Autor | Robson Gonçalves            | Data | 04/09/2015
//--------------------------------------------------------------------------------
// Descr. | Rotina para imprimir os contratos a vencer ou em vencimento periódico.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
User Function R650Ven()
	Local aSay := {}
	Local aButton := {}
	Local nOpc := 0
	Local aPar := {}
	Local aRet := {}
	Local dDataRef := Ctod(Space(8))
	Private cCadastro := 'Relatório vencimento de contrato'
	
	AAdd( aSay, 'O objetivo desta rotina é verificar os vencimentos dos contratos. Ao final do' )
	AAdd( aSay, 'do processamento será apresentada uma planilha com os registros localizados nas' )
	AAdd( aSay, 'condições de vencimento' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch() }} )
	AAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( 'Aviso de vencimento de contratos', aSay, aButton )
	
	If nOpc == 1
		AAdd(aPar,{1,'Data de referência'    ,dDataBase,'','','','',50,.T.})
		Set( 4, 'dd/mm/yyyy' )
		If ParamBox(aPar,'Parâmetros',aRet,,,,,,,,.F.,.F.)
			dDataRef := aRet[ 1 ] 
			Processa( {|| R650ProcVen(dDataRef) }, 'Aviso de vencimento de contrato', 'Processando os dados, aguarde...', .F. )
		Else
			MsgInfo('Rotina abandonada pelo usuário')
		Endif
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | R650ProcVen  | Autor | Robson Gonçalves            | Data | 04/09/2015
//--------------------------------------------------------------------------------
// Descr. | Rotina de processamento do relatório.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function R650ProcVen(dDataRef)
	Local cSQL := ''
	Local cTRB := ''
	//Local lGetUser := .F.
	Local lAcesso := .T.
	//Local aUser := {}
	Local cEntidade := ''
	Local aEntidade := {}
	Local aSendTo := {}
	Local cEmail := ''
	Local aCN9 := {}
	Local cForCli := ''
   Local aCN9_TPRENO := {}
   Local aDADOS := {}
   Local nI := 0
   Local aEXCECAO := {}
   Local aCN9_UNVIGE := {}
   
   aCN9_TPRENO := StrToKarr( Posicione( 'SX3', 2, 'CN9_TPRENO', 'X3CBox()' ), ';' )
	aCN9_UNVIGE := StrToKarr( Posicione( 'SX3', 2, 'CN9_UNVIGE', 'X3CBox()' ), ';' )   
	
	ProcRegua(0)
	
	A650Param()
	aEXCECAO := StrToKarr( cMV_EXCECAO, ';' )
	
	cSQL := "SELECT '1-VENCTO' AS TIPO,"
	cSQL += "		 CN9_FILIAL,"
	cSQL += "		 CN9_NUMERO,"
	cSQL += "		 CN9_REVISA,"
	cSQL += "		 CN9_DESCRI,"
	cSQL += "		 CN9_DTINIC,"
	cSQL += "		 CN9_DTFIM,"
	cSQL += "		 CN9_TPCTO,"
	cSQL += "		 CN1_ESPCTR,"
	cSQL += "       CN9_CLIENT, "
	cSQL += "       CN9_LOJACL, "
	cSQL += "		 CN9_VLATU,"
	cSQL += "       CN9_TPRENO, "
	cSQL += "		 CN9_AVITER,"
	cSQL += "		 CN9_AVIPER,"
	cSQL += "       CN9_VIGE, "
	cSQL += "       CN9_UNVIGE, "
	cSQL += "       NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(CN9_NOTVEN,4000,1)),' ') AS CN9_NOTVEN, "
	cSQL += "		 TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD') AS DIAS,"
	cSQL += "		 (CN9_AVIPER + (TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD'))) AS RESULTADO "
	cSQL += "FROM   "+RetSqlName("CN9")+" CN9 "
	cSQL += "		 INNER JOIN "+RetSqlName("CN1")+" CN1 "
	cSQL += "					ON CN1_FILIAL = CN9_FILIAL"
	cSQL += "						AND CN1_CODIGO = CN9_TPCTO"
	cSQL += "						AND CN1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  CN9_FILIAL BETWEEN ' ' AND 'ZZ'"
	cSQL += "		 AND CN9_NUMERO BETWEEN ' ' AND 'ZZZZZZZZZZZZZZZ'"
	cSQL += "		 AND CN9_SITUAC = '05'"
	cSQL += "		 AND CN9_REVATU = '   '"
	cSQL += "		 AND CN9_AVITER > 0"
	cSQL += "		 AND ( TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD' ) = CN9_AVITER )"
	cSQL += "		 AND CN9.D_E_L_E_T_ =  ' ' "
	
	cSQL += " UNION "
	
	cSQL += "SELECT '2-TERMIN' AS TIPO,"
	cSQL += "		 CN9_FILIAL,"
	cSQL += "		 CN9_NUMERO,"
	cSQL += "		 CN9_REVISA,"
	cSQL += "		 CN9_DESCRI,"
	cSQL += "		 CN9_DTINIC,"
	cSQL += "		 CN9_DTFIM,"
	cSQL += "		 CN9_TPCTO,"
	cSQL += "		 CN1_ESPCTR,"
	cSQL += "       CN9_CLIENT, "
	cSQL += "       CN9_LOJACL, "
	cSQL += "		 CN9_VLATU,"
	cSQL += "       CN9_TPRENO, "
	cSQL += "		 CN9_AVITER,"
	cSQL += "		 CN9_AVIPER,"
	cSQL += "       CN9_VIGE, "
	cSQL += "       CN9_UNVIGE, "
	cSQL += "       NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(CN9_NOTVEN,4000,1)),' ') AS CN9_NOTVEN, "
	cSQL += "		 TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD') AS DIAS,"
	cSQL += "		 (CN9_AVIPER + (TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD'))) AS RESULTADO "
	cSQL += "FROM   "+RetSqlName("CN9")+" CN9 "
	cSQL += "		 INNER JOIN "+RetSqlName("CN1")+" CN1 "
	cSQL += "					ON CN1_FILIAL = CN9_FILIAL"
	cSQL += "						AND CN1_CODIGO = CN9_TPCTO"
	cSQL += "						AND CN1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  CN9_FILIAL BETWEEN ' ' AND 'ZZ'"
	cSQL += "		 AND CN9_NUMERO BETWEEN ' ' AND 'ZZZZZZZZZZZZZZZ'"
	cSQL += "		 AND CN9_SITUAC = '05'"
	cSQL += "		 AND CN9_REVATU = '   '"
	cSQL += "		 AND ( TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD' ) = 0 )"
	cSQL += "		 AND CN9.D_E_L_E_T_ =  ' ' "
	
	cSQL += " UNION "
	
	cSQL += "SELECT '3-PERIOD' AS TIPO,"
	cSQL += "		 CN9_FILIAL,"
	cSQL += "		 CN9_NUMERO,"
	cSQL += "		 CN9_REVISA,"
	cSQL += "		 CN9_DESCRI,"
	cSQL += "		 CN9_DTINIC,"
	cSQL += "		 CN9_DTFIM,"
	cSQL += "		 CN9_TPCTO,"
	cSQL += "		 CN1_ESPCTR,"
	cSQL += "       CN9_CLIENT, "
	cSQL += "       CN9_LOJACL, "	
	cSQL += "		 CN9_VLATU,"
	cSQL += "       CN9_TPRENO, "
	cSQL += "		 CN9_AVITER,"
	cSQL += "		 CN9_AVIPER,"
	cSQL += "       CN9_VIGE, "
	cSQL += "       CN9_UNVIGE, "
	cSQL += "       NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(CN9_NOTVEN,4000,1)),' ') AS CN9_NOTVEN, "
	cSQL += "		 TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD') AS DIAS,"
	cSQL += "		 (CN9_AVIPER + (TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD'))) AS RESULTADO "
	cSQL += "FROM   "+RetSqlName("CN9")+" CN9 "
	cSQL += "		 INNER JOIN "+RetSqlName("CN1")+" CN1 "
	cSQL += "					ON CN1_FILIAL = CN9_FILIAL"
	cSQL += "						AND CN1_CODIGO = CN9_TPCTO"
	cSQL += "						AND CN1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  CN9_FILIAL BETWEEN ' ' AND 'ZZ'"
	cSQL += "		 AND CN9_NUMERO BETWEEN ' ' AND 'ZZZZZZZZZZZZZZZ'"
	cSQL += "		 AND CN9_SITUAC = '05'"
	cSQL += "		 AND CN9_REVATU = '   '"
	cSQL += "		 AND CN9_AVITER > 0"
	cSQL += "		 AND CN9_AVIPER > 0"
	cSQL += "		 AND ( TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD' ) < CN9_AVITER )"
	cSQL += "		 AND (CN9_AVIPER + (TO_DATE(CN9_DTFIM,'YYYYMMDD') - TO_DATE("+ValToSql(Dtos(dDataRef))+",'YYYYMMDD')) = CN9_AVITER )"
	cSQL += "		 AND CN9.D_E_L_E_T_ =  ' '"
	cSQL += "ORDER  BY TIPO, CN9_FILIAL, CN9_NUMERO, CN9_REVISA	"
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGenQry(,,cSQL), cTRB, .T., .T. )
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		ApMsgInfo('QUERY PRINCIPAL NÃO LOCALIZOU NENHUM REGISTRO.','A650ProcVen')
		Return
	Endif
	
	While (cTRB)->( .NOT. EOF() )
		IncProc()
		
		/*
		If .NOT. lGetUser
			lGetUser := .T.
			aIsRead := {}
			A650User( @aUser )
		Endif
		*/
		
		If Empty( (cTRB)->CN9_NOTVEN )
			lAcesso := .F.
			AAdd( aSendTo, cMV_650KEY )
		Else
			If ';' $ (cTRB)->CN9_NOTVEN
				aSendTo := StrToKarr( (cTRB)->CN9_NOTVEN, ';' )
			Else
				AAdd( aSendTo, AllTrim( (cTRB)->CN9_NOTVEN ) )
			Endif
		Endif

		If (cTRB)->CN1_ESPCTR == '1'
			cForCli := 'Dados do fornecedor'
			A650Entid( (cTRB)->CN9_FILIAL, (cTRB)->CN9_NUMERO, @cEntidade, 'EXCEL' )
		Else
			cForCli := 'Dados do cliente'
			aEntidade := SA1->( GetAdvFVal( 'SA1', { 'A1_NOME', 'A1_CGC' }, xFilial('SA1') + (cTRB)->( CN9_CLIENT + CN9_LOJACL ), 1 ) )
			cEntidade := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
		Endif

		//lAcesso := A650Acesso( (cTRB)->CN9_FILIAL, (cTRB)->CN9_NUMERO, "IN ('001','037')", aUser, @aSendTo )
		
		/*
		If .NOT. lAcesso
			AAdd( aSendTo, cMV_650KEY )
		Endif		
		*/
		
		AEval( aSendTo, {|e| cEmail += e + ';' } )
		cEmail := SubStr( cEmail, 1, Len( cEmail )-1 )
		
		aCN9 := Array(14)
		
		aCN9[ 13] := cForCli
		aCN9[ 1 ] := (cTRB)->CN9_FILIAL + '-' + RTrim( ( SM0->( GetAdvFVal( 'SM0', 'M0_FILIAL', cEmpAnt + (cTRB)->CN9_FILIAL , 1 ,'' ) ) ) )
		aCN9[ 2 ] := (cTRB)->CN9_NUMERO
		If Empty( (cTRB)->CN9_REVISA )
			aCN9[ 3 ] := 'SEM REVISÃO'
		Else
			aCN9[ 3 ] := (cTRB)->CN9_REVISA
		Endif
		aCN9[ 4 ] := (cTRB)->CN9_DESCRI
		aCN9[ 5 ] := cEntidade
		aCN9[ 6 ] := LTrim( Str( (cTRB)->CN9_VIGE, 6, 0 ) ) + ' ' + RTrim( SubStr( aCN9_UNVIGE[ Val( (cTRB)->CN9_UNVIGE ) ], 3 ) )
		aCN9[ 7 ] := Dtoc(Stod((cTRB)->CN9_DTFIM))
		aCN9[ 8 ] := LTrim(Str((cTRB)->DIAS,6))+' dias.'
		
		If Empty( (cTRB)->CN9_TPRENO )
			aCN9[ 14] := 'SEM TIPO DE RENOVAÇÃO'
		Else
			aCN9[ 14] := RTrim( SubStr( aCN9_TPRENO[ Val( (cTRB)->CN9_TPRENO ) ], 3 ) )
		Endif
				
		// Retirar os e-mails registrados no parâmetro MV_EXCECAO.
		For nI := 1 To Len( aEXCECAO )
			If aEXCECAO[ nI ] $ cEmail
				cEmail := StrTran( cEmail, aEXCECAO[ nI ], '' )
			Endif
		Next nI

		If (cTRB)->TIPO == '1-VENCTO'
			aCN9[ 9 ] := 'vencimento'
			aCN9[ 10] := 'Este e-mail é informativo para o aviso de vencimento de contrato conforme dados a seguir, fique atento!'
			aCN9[ 11] := 'Aviso de vencimento do contrato - ' + alltrim(aCN9[ 4 ])
			If (cTRB)->CN1_ESPCTR == '1'
				If (cTRB)->CN9_TPRENO == '1'
					cEmail := cEmail + ';' + cMV_EXCECAO
				Endif
			Endif
		ElseIf (cTRB)->TIPO == '2-TERMIN'
			aCN9[ 9 ] := 'encerramento'
			aCN9[ 10] := 'Este e-mail é informativo para o aviso de enecerramento do contrato conforme dados a seguir.'
			aCN9[ 11] := 'Aviso de encerramento do contrato  - ' + alltrim(aCN9[ 4 ])
		Elseif (cTRB)->TIPO == '3-PERIOD'
			aCN9[ 9 ] := 'vencimento periódico'
			aCN9[ 10] := 'Este e-mail é informativo para o aviso de vencimento periódico de contrato conforme dados a seguir, fique atento!'
			aCN9[ 11] := 'Aviso de vencimento periódico do contrato  - ' + alltrim(aCN9[ 4 ])
		Endif
		
		If .NOT. lAcesso
			//aCN9[ 12] := 'O contrato acima está sem acessos de usuários definido. Configure usuários para ter acesso ao contrato.'
			aCN9[ 12] := 'O contrato acima está sem e-mail de usuário para notificaão de vencimento de contrato. Informe e-mail no campo Notifiação de Vencimento.'
		Endif

		AAdd( aDADOS, Array( Len( aCN9 )+1 ) )
		nElem := Len( aDADOS )
		For nI := 1 To Len( aCN9 )
			aDADOS[ nElem, nI ] := aCN9[ nI ]
		Next nI
		aDADOS[ nElem, Len( aCN9 )+1 ] := cEmail
		
		aCN9 := {}
		aSendTo := {}
		aEntidade := {}
		
		cEmail := ''
		cEntidade := ''
		
		(cTRB)->( dbSkip() )
	End	
	(cTRB)->( dbCloseArea() )
	
	FwMsgRun(,{|| DlgToExcel( { { "ARRAY", "",;
	{'FILIAL','CONTRATO','REVISÃO','DESCRIÇÃO DO CONTRATO','ENTIDADE','VALOR ATUAL','DATA FINAL','DIAS A VENCER','TIPO DE VENCIMENTO','TEXTO PARA USUÁRIO','TÍTULO DO TEXTO','ALERTA','CLIENTE/FORNECEDOR','TIPO DE RENOVAÇÃO','EMAILS'},;
	aDADOS } } ) };
	,,'Aguarde, gerando os dados...')	
Return

//--------------------------------------------------------------------------------
// Rotina | A650User     | Autor | Robson Gonçalves              | Data | 17.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para buscar todos os usuários do Protheus.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
/*Static Function A650User( aUser )
	Local aAllUsers := {}
	Local aGrpUser := {}
	Local cUsCode := ''
	Local cUsMail := ''
	aAllUsers := FWSFAllUsers()	
	PswOrder( 1 )
	AEval( aAllUsers, {|xUser| Iif( Empty( xUser[ 5 ] ), NIL, ;
	                  ( cUsCode := xUser[ 2 ], cUsMail := xUser[ 5 ], PswSeek( cUsCode ), ;
	                  Iif( PswRet()[ 1, 17 ], NIL, ;
	                  ( aGrpUser := FWSFUsrGrps( cUsCode ), ;
	                  Iif( Len( aGrpUser )==0, NIL, ;
	                  ( AEval( aGrpUser, {|xGroup| AAdd( aUser, { xGroup, cUsCode, cUsMail })})))))))})
	ASort( aUser,,,{|a,b| a[ 1 ] + a[ 2 ] < b[ 1 ] + b[ 2 ] } )
Return
*/
//--------------------------------------------------------------------------------
// Rotina | A650Acesso   | Autor | Robson Gonçalves              | Data | 17.06.15
//--------------------------------------------------------------------------------
// Descr. | Buscar usuários e/ou grupos com permissão de acesso ao contrato.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
/*Static Function A650Acesso( cCN9_FILIAL, cCN9_NUMERO, cCNN_TRACOD, aUser, aSendTo )
	Local nI := 0
	Local nP := 0
	Local cQry := ''
	Local cCNN := GetNextAlias()
	
	cQry := "SELECT CNN_USRCOD, "
	cQry += "       CNN_GRPCOD, "
	cQry += "       CNN_TRACOD "
	cQry += "FROM   "+RetSqlName("CNN")+" CNN "
	cQry += "WHERE  CNN_FILIAL = "+ValToSql( cCN9_FILIAL )+" "
	cQry += "       AND CNN_CONTRA = "+ValToSql( cCN9_NUMERO )+" "
	If .NOT. Empty( cCNN_TRACOD )
		cQry += "       AND CNN_TRACOD "+cCNN_TRACOD+" "
	Endif
	cQry += "       AND CNN.D_E_L_E_T_ = ' ' "
	
	cQry := ChangeQuery( cQry )
	dbUseArea( .T., 'TOPCONN', TCGenQry(,,cQry), cCNN, .T., .T. )
	
	While (cCNN)->( .NOT. EOF() )
		If Empty( (cCNN)->CNN_GRPCOD )
			nP := AScan( aIsRead, {|p| p[ 2 ] == (cCNN)->CNN_USRCOD } )
			If nP > 0
				AAdd( aSendTo, aIsRead[ nP, 3 ] )
			Else
				nP := AScan( aUser, {|p| p[ 2 ] == (cCNN)->CNN_USRCOD } )
				If nP > 0
					AAdd( aSendTo, aUser[ nP, 3 ] )
					AAdd( aIsRead, { aUser[ nP, 1 ], aUser[ nP, 2], aUser[ nP, 3 ] } )
				Endif
			Endif
		Else
			nP := AScan( aIsRead, {|p| p[ 1 ] == (cCNN)->CNN_GRPCOD } )
			If nP > 0
				For nI := nP To Len( aIsRead )
					If aIsRead[ nI, 1 ] == (cCNN)->CNN_GRPCOD
						AAdd( aSendTo, aIsRead[ nI, 3 ] )
					Else
						Exit
					Endif
				Next nI
			Else
				nP := AScan( aUser, {|p| p[ 1 ] == (cCNN)->CNN_GRPCOD } )
				If nP > 0
					For nI := nP To Len( aUser )
						If aUser[ nI, 1 ] == (cCNN)->CNN_GRPCOD
							If .NOT. Empty( aUser[ nI, 3 ] )
								AAdd( aSendTo, aUser[ nI, 3 ] )
								AAdd( aIsRead, { aUser[ nI, 1 ], aUser[ nI, 2], aUser[ nI, 3 ] } )
							Endif
						Else
							Exit
						Endif
					Next nI
				Endif
			Endif
		Endif
		(cCNN)->( dbSkip() )
	End	
	(cCNN)->( dbCloseArea() )
Return(Len(aSendTo)>0)
*/
//--------------------------------------------------------------------------------
// Rotina | A650Param    | Autor | Robson Gonçalves              | Data | 17.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para criar e atribuir valor aos parâmetros.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A650Param()	
	cMV_650DIR  := 'MV_650DIR'
	cMV_EXCECAO := 'MV_EXCECAO'
	cMV_650KEY  := 'MV_650KEY'
	cMV_650PROC := 'MV_650PROC'
	cMV_650DIAS := 'MV_650DIAS'
		
	cMV_650SCAU := 'MV_650SCAU'
	cMV_650CAU  := 'MV_650CAU'
	cMV_650NCAU := 'MV_650NCAU'
	
	cMV_650MED  := 'MV_650MED'
	cMV_650PLAN := 'MV_650PLAN'
	cMV_650REAJ := 'MV_650REAJ'
	cMV_650REV  := 'MV_650REV'
	cMV_650SIT  := 'MV_650SIT'
	cMV_650CAN  := 'MV_650CAN'
	cMV_650VEN  := 'MV_650VEN'
	cMV_650VCTO := 'MV_650VCTO'
	cMV_IPSRV   := 'MV_610_IP'
	cMV_650USER := 'MV_650USER'
		
	If .NOT. GetMv( cMV_650DIR, .T. )
		CriarSX6( cMV_650DIR, 'C', 'DIRETORIO ONDE SERAO ARMAZENADOS OS ARQUIVOS HTML DO CORPO DE E-MAIL. CSFA650.prw', '\htmlctr\' )
	Endif		
	cMV_650DIR := GetMv( cMV_650DIR, .F. )
	MakeDir( cMV_650DIR )

	If .NOT. GetMv( cMV_650VEN, .T. )
		CriarSX6( cMV_650VEN, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR O VENCIMENTO, O TÉRMINO E O AVISO PERIODICO DO VENCIMENTO DO CONTRATOS. CSFA650.prw', 'csfa650ven.htm' )
	Endif
	cMV_650VEN := GetMv( cMV_650VEN, .F. )
	
	If .NOT. File( cMV_650DIR + cMV_650VEN )
		ApMsgInfo( 'Não localizado o arquivo template HTML no seguinte caminho: ' + cMV_650DIR + cMV_650VEN, '01 - Template não localizado')
	Endif

	If .NOT. GetMv( cMV_650KEY, .T. )
		CriarSX6( cMV_650KEY, 'C', 'EMAIL DO KEY-USER DE GESTAO DE CONTRATOS. CSFA650.prw', 'bcosta@certisign.com.br' )
	Endif		
	cMV_650KEY := GetMv( cMV_650KEY, .F. )

	If .NOT. GetMv( cMV_EXCECAO, .T. )
		CriarSX6( cMV_EXCECAO, 'C', 'EMAIL DE USUARIOS EM EXECAO PARA O AVISO DE VENCTO/ENCERRAMENTO/PERIODICO DE CONTRATOS. CSFA650.prw', 'jcosentino@certising.com.br;ikhafif@certising.com.br' )
	Endif		
	cMV_EXCECAO := GetMv( cMV_EXCECAO, .F. )

	If .NOT. GetMv( cMV_650SIT, .T. )
		CriarSX6( cMV_650SIT, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR A MUDANCA DE SITUACAO. CSFA650.prw', 'csfa650sit.htm' )
	Endif		
	cMV_650SIT := GetMv( cMV_650SIT, .F. )
	
	If .NOT. GetMv( cMV_650CAU, .T. )
		CriarSX6( cMV_650CAU, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR INCLUSAO DE CAUCAO. CSFA650.prw', 'csfa650caucao.htm' )
	Endif		
	cMV_650CAU := GetMv( cMV_650CAU, .F. )
	
	If .NOT. GetMv( cMV_650SCAU, .T. )
		CriarSX6( cMV_650SCAU, 'C', 'NOME DO ARQ. HTML PADRÃO PARA SOLICITAR A APROVACAO DE CAUCAO. CSFA650.prw', 'csfa650solcaucao.htm' )
	Endif		
	cMV_650SCAU := GetMv( cMV_650SCAU, .F. )
	
	If .NOT. GetMv( cMV_650NCAU, .T. )
		CriarSX6( cMV_650NCAU, 'C', 'EMAIL DOS RESPONSAVEIS PARA CADASTRAR CAUCAO. CSFA650.prw', 'etsukamoto@certisign.com.br; sav@certisign.com.br; licit@certisign.com.br; bcosta@certisign.com.br' )
	Endif		
	cMV_650NCAU := GetMv( cMV_650NCAU, .F. )
	
	If .NOT. GetMv( cMV_650PLAN, .T. )
		CriarSX6( cMV_650PLAN, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR INCLUSAO DE PLANILHA. CSFA650.prw', 'csfa650plan.htm' )
	Endif		
	cMV_650PLAN := GetMv( cMV_650PLAN, .F. )
	
	If .NOT. GetMv( cMV_650MED, .T. )
		CriarSX6( cMV_650MED, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR MEDICAO. CSFA650.prw', 'csfa650medicao.htm' )
	Endif		
	cMV_650MED := GetMv( cMV_650MED, .F. )
	
	If .NOT. GetMv( cMV_650REV, .T. )
		CriarSX6( cMV_650REV, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR REVISAO. CSFA650.prw', 'csfa650rev.htm' )
	Endif		
	cMV_650REV := GetMv( cMV_650REV, .F. )
	
	If .NOT. GetMv( cMV_650REAJ, .T. )
		CriarSX6( cMV_650REAJ, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR REAJUSTE. CSFA650.prw', 'csfa650reaj.htm' )
	Endif		
	cMV_650REAJ := GetMv( cMV_650REAJ, .F. )
	
	If .NOT. GetMv( cMV_650PROC, .T. )
		CriarSX6( cMV_650PROC, 'C', 'HABILITA O PROCESSO DE ENVIO DE E-MAIL? 0-DESLIGADO 1-LIGADO. CSFA650.prw', '1' )
	Endif		
	cMV_650PROC := GetMv( cMV_650PROC, .F. )
	
	If .NOT. GetMv( cMV_650CAN, .T. )
		CriarSX6( cMV_650CAN, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR A MUDANCA DE SITUACAO FINALIZADO/CANCELADO. CSFA650.prw', 'csfa650can.htm' )
	Endif		
	cMV_650CAN := GetMv( cMV_650CAN, .F. )
	
	If .NOT. GetMv( cMV_650VCTO, .T. )
		CriarSX6( cMV_650VCTO, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR VENCIMENTO PLANILHA. CSFA650.prw', 'csfa650vctoplan.htm' )
	Endif		
	cMV_650VCTO := GetMv( cMV_650VCTO, .F. )
	
	If .NOT. GetMv( cMV_IPSRV, .T. )
		CriarSX6( cMV_IPSRV, 'C', 'IP dos servidores Teste/Homolog para identificar e sair a informação no assunto do e-mail. Rotina: CSFA610.prw', '10.130.0.117' )
	Endif
	cMV_IPSRV := GetMv( cMV_IPSRV, .F. )
	
	If .NOT. GetMv( cMV_650USER, .T. )
		CriarSX6( cMV_650USER, 'C', 'E-mail para aviso de vencimento da planilha. CSFA650.prw', 'contratos@certisign.com.br' )
	Endif		
	cMV_650USER := GetMv( cMV_650USER, .F. )
Return

//--------------------------------------------------------------------------------
// Rotina | A650Entid    | Autor | Robson Gonçalves              | Data | 17.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para buscar os fornecedores.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A650Entid( cCN9_FILIAL, cCN9_NUMERO, cEntidade, cApp )
	Local cQry := ''
	Local cCNC := GetNextAlias()
	
	cQry := "SELECT A2_NOME, "
	cQry += "       A2_CGC, "
	cQry += "MAX(CNC_REVISA) REVIS "
	cQry += "FROM   "+RetSqlName("CNC")+" CNC "
	cQry += "       LEFT JOIN "+RetSqlName("SA2")+" SA2 "
	cQry += "              ON A2_FILIAL = "+ValToSql(xFilial("SA2"))+" "
	cQry += "                 AND A2_COD = CNC_CODIGO "
	cQry += "                 AND A2_LOJA = CNC_LOJA "
	cQry += "                 AND SA2.D_E_L_E_T_ = ' ' "
	cQry += "WHERE  CNC_FILIAL = "+ValToSql(cCN9_FILIAL)+" "
	cQry += "       AND CNC_NUMERO = "+ValToSql(cCN9_NUMERO)+" "
	cQry += "       AND CNC.D_E_L_E_T_ = ' ' "
	cQry += "GROUP BY A2_NOME, A2_CGC "
	
	cQry := ChangeQuery( cQry )
	dbUseArea( .T., 'TOPCONN', TCGenQry(,,cQry), cCNC, .T., .T. )
	
	If (cCNC)->(BOF()) .And. (cCNC)->(EOF())
		cEntidade := 'Contrato sem fornecedor informado.'
	Endif

	While (cCNC)->( .NOT. EOF() )
		If cEntidade <> ''
			If cApp == 'HTML'
				cEntidade := cEntidade + '<br>'
			Else
				cEntidade := cEntidade + CRLF 
			Endif
		Endif
		cEntidade += RTrim( (cCNC)->A2_NOME ) + ' - CNPJ ' + TransForm((cCNC)->A2_CGC,'@R 99.999.999/9999-99')
		(cCNC)->( dbSkip() )
	End
	(cCNC)->( dbCloseArea() )
Return

//--------------------------------------------------------------------------------
// Rotina | A650HTML     | Autor | Robson Gonçalves              | Data | 17.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina para elaborar o HTML e enviar o e-mail para os usuários.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A650HTML( cFileHTML, cTemplate, cEmail, aCN9 )
	Local oHTML
	Local cBody := ''
	Local lEnviou := .F.
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local cNewMsg := ''
	
	cMV_FKMAIL := GetMv( cMV_FKMAIL )
	
	oHTML := TWFHtml():New( cTemplate )
	
	If oHTML:ExistField( 1, 'cCN9_FILIAL')     ; oHTML:ValByName( 'cCN9_FILIAL'    , aCN9[ 1 ] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_FILIAL' )    ; oHTML:ValByName( 'cCN9_NUMERO'    , aCN9[ 2 ] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_REVISAO' )   ; oHTML:ValByName( 'cCN9_REVISAO'   , aCN9[ 3 ] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_DESCRICAO' ) ; oHTML:ValByName( 'cCN9_DESCRICAO' , aCN9[ 4 ] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_ENTIDADE' )  ; oHTML:ValByName( 'cCN9_ENTIDADE'  , aCN9[ 5 ] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_VIGENCIA' )  ; oHTML:ValByName( 'cCN9_VIGENCIA'  , aCN9[ 6 ] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_DTFIM' )     ; oHTML:ValByName( 'cCN9_DTFIM'     , aCN9[ 7 ] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_DIAS' )      ; oHTML:ValByName( 'cCN9_DIAS'      , aCN9[ 8 ] ) ; Endif
	If oHTML:ExistField( 1, 'cTpAviso' )       ; oHTML:ValByName( 'cTpAviso'       , aCN9[ 9 ] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_AVISO' )     ; oHTML:ValByName( 'cCN9_AVISO'     , aCN9[ 10] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_MENSAGEM' )  ; oHTML:ValByName( 'cCN9_MENSAGEM'  , aCN9[ 12] ) ; Endif
	If oHTML:ExistField( 1, 'cTpEntidade' )    ; oHTML:ValByName( 'cTpEntidade'    , aCN9[ 13] ) ; Endif
	//If oHTML:ExistField( 1, 'cCN9_ST_ANT' )    ; oHTML:ValByName( 'cCN9_ST_ANT'    , 'aCN9[?]' ) ; Endif
	//If oHTML:ExistField( 1, 'cCN9_ST_ATU' )    ; oHTML:ValByName( 'cCN9_ST_ATU'    , 'aCN9[?]' ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_TPRENO' )    ; oHTML:ValByName( 'cCN9_TPRENO'    , aCN9[ 14] ) ; Endif
	If oHTML:ExistField( 1, 'cCN9_OBJETO' )    ; oHTML:ValByName( 'cCN9_OBJETO'    , aCN9[ 16] ) ; Endif
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		//Adiciona no e-mail o número da oportunidade
		IF aCN9[ 15 ] <> NIL
			cNewMsg += '								<tr style="border: 1px solid #F4811D;">' + CRLF
			cNewMsg += '									<td bgcolor="#FEDBAB" valign="top">' + CRLF
			cNewMsg += '										<font color="#333333" face="Arial, Helvetica, sans-serif" size="2"><b>Nº Oportunidade</b></font></td>' + CRLF
			cNewMsg += '									<td bgcolor="#FEDBAB" valign="top">' + CRLF
			cNewMsg += '										<span style="color: rgb(51, 51, 51); font-family: Arial, Helvetica, sans-serif; font-size: small;">' + aCN9[ 15 ] + '</span></td>' + CRLF
			cNewMsg += '								</tr>' + CRLF
			cBody := Stuff( cBody, At('</tbody>',cBody), 0, cNewMsg )
		EndIF

		If .NOT. Empty( cMV_FKMAIL )
			cEmail := cMV_FKMAIL
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
			         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
			         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
		Endif

		lEnviou := FSSendMail( cEmail, aCN9[ 11 ], cBody, /*cAnexo*/ )
		Conout( 'FSSendMail > [A650HTML] | E-mail: ' + cEmail + ' Assunto: ' + aCN9[ 11 ] )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif	
Return( lEnviou )

//--------------------------------------------------------------------------------
// Rotina | A650ICtr     | Autor | Robson Gonçalves              | Data | 23.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina que informa qual usuário inclui o contrato.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
User Function A650ICtr()
	Local nOpc := 0
	Local aSay := {}
	Local aButton := {}
	Local aPar := {}
	Local aRet := {}
	Local bOK := {|| .T. }
	Local cTitulo := 'Relação de usuários que incluiu contratos'
	Local aFiltro := {'Só quem incluiu','Controle total'}
	
	AAdd( aSay, 'O objetivo desta rotina é apresentar os contratos e o nome do usuário que efetuou' )
	AAdd( aSay, 'a inclusão no sistema.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch() }} )
	AAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( 'Aviso de vencimento de contratos', aSay, aButton )

   If nOpc == 1
		AAdd( aPar, { 1, 'Filial de'   , Space( Len( CN9->CN9_FILIAL ) ), '', '', 'SM0_01', '', 40, .F. } )
		AAdd( aPar, { 1, 'Filial até'  , Space( Len( CN9->CN9_FILIAL ) ), '', '(MV_PAR02>=MV_PAR01)', 'SM0_01', '', 40, .T. } )
		AAdd( aPar, { 1, 'Contrato de' , Space( Len( CN9->CN9_NUMERO ) ), '', '', 'CN9', '', 99, .F. } )
		AAdd( aPar, { 1, 'Contrato até', Space( Len( CN9->CN9_NUMERO ) ), '', '(MV_PAR04>=MV_PAR03)', 'CN9', '', 99, .T. } )
		AAdd( aPar, { 1, 'Usuário de'  , Space( 6 ), '', 'Vazio().OR.UsrExist(MV_PAR05)', 'USR', '', 50, .F. } )
		AAdd( aPar, { 1, 'Usuário até' , Space( 6 ), '', '((MV_PAR06$"999999|zzzzzz|ZZZZZZ".OR.UsrExist(MV_PAR06)).AND.(MV_PAR06>=MV_PAR05))', 'USR', '', 50, .T. } )
		AAdd( aPar, { 3, 'Filtrar'     ,1 , aFiltro, 99, '', .T. } )
		If ParamBox( aPar,cTitulo,@aRet,bOk,,,,,,,.T.,.T.)   	
			Processa( {|| A650LstUsr( cTitulo, aRet, aFiltro ) }, cTitulo,'Buscando os dados', .F. )
		Endif
	Endif
Return

//--------------------------------------------------------------------------------
// Rotina | A650LstUsr   | Autor | Robson Gonçalves              | Data | 23.06.15
//--------------------------------------------------------------------------------
// Descr. | Rotina que gera uma planilha com os registros localizados para
//        | apresentar o usuário que incluiu os contratos.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
Static Function A650LstUsr( cTitulo, aRet, aFiltro )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	Local cTable := cTitulo + ' - Filtro por: ' + aFiltro[ aRet[ 7 ] ]
	Local cWorkSheet := 'Usuários'
	Local oFwMsEx
	Local oExcelApp
	Local cDirTmp := ''
	Local cDir := ''
	Local cFile := CriaTrab(NIL,.F.)+'.xml'
	
	If aRet[ 7 ] == 1
		cSQL := "SELECT B.CNN_FILIAL, "
		cSQL += "       B.CNN_CONTRA, "
		cSQL += "       B.CNN_USRCOD, "
		cSQL += "       B.CNN_TRACOD, "
		cSQL += "       CNO.CNO_DESCRI "
		cSQL += "FROM   "+RetSqlName("CNN")+" B "
      cSQL += "       INNER JOIN "+RetSqlName("CNO")+" CNO "
      cSQL += "               ON CNO_FILIAL = "+ValToSql(xFilial("CNO"))+" "
      cSQL += "              AND CNO_CODTRA = B.CNN_TRACOD "
      cSQL += "              AND CNO.D_E_L_E_T_ = ' ' "
		cSQL += "WHERE  B.R_E_C_N_O_ IN (SELECT MIN(A.R_E_C_N_O_) CNN_RECNO "
		cSQL += "                         FROM   "+RetSqlName("CNN")+" A "
		cSQL += "                         WHERE  A.CNN_FILIAL BETWEEN "+ValToSql(aRet[1])+" AND "+ValToSql(aRet[2])+" "
		cSQL += "                                AND A.CNN_CONTRA BETWEEN "+ValToSql(aRet[3])+" AND "+ValToSql(aRet[4])+" "
		cSQL += "                                AND A.CNN_USRCOD BETWEEN "+ValToSql(aRet[5])+" AND "+ValToSql(aRet[6])+" "
		cSQL += "                                AND A.CNN_TRACOD = '001' "
		cSQL += "                                AND A.CNN_GRPCOD = ' ' "
		cSQL += "                                AND A.D_E_L_E_T_ = ' ' "
		cSQL += "                         GROUP  BY CNN_FILIAL, "
		cSQL += "                                   CNN_CONTRA) "
		cSQL += "ORDER  BY B.CNN_FILIAL, "
		cSQL += "          B.CNN_CONTRA "
	Elseif aRet[ 7 ] == 2
		cSQL := "SELECT B.CNN_FILIAL, "
		cSQL += "       B.CNN_CONTRA, "
		cSQL += "       B.CNN_USRCOD, "
		cSQL += "       B.CNN_TRACOD, "
		cSQL += "       CNO.CNO_DESCRI "
		cSQL += "FROM   "+RetSqlName("CNN")+" B "
      cSQL += "       INNER JOIN "+RetSqlName("CNO")+" CNO "
      cSQL += "               ON CNO_FILIAL = "+ValToSql(xFilial("CNO"))+" "
      cSQL += "              AND CNO_CODTRA = B.CNN_TRACOD "
      cSQL += "              AND CNO.D_E_L_E_T_ = ' ' "
		cSQL += "WHERE  B.CNN_FILIAL BETWEEN "+ValToSql(aRet[1])+" AND "+ValToSql(aRet[2])+" "
		cSQL += "       AND B.CNN_CONTRA BETWEEN "+ValToSql(aRet[3])+" AND "+ValToSql(aRet[4])+" "
		cSQL += "       AND B.CNN_USRCOD BETWEEN "+ValToSql(aRet[5])+" AND "+ValToSql(aRet[6])+" "
		cSQL += "       AND B.CNN_TRACOD = '001' "
		cSQL += "       AND B.CNN_GRPCOD = ' ' "
		cSQL += "       AND B.D_E_L_E_T_ = ' ' "
		cSQL += "ORDER  BY B.CNN_FILIAL, "
		cSQL += "          B.CNN_CONTRA "	
	Endif
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.T.,.T.)

	ProcRegua( 0 )
	
	If (cTRB)->( BOF() .And. EOF() )
		MsgInfo(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Não foi possível localizar dados com os parâmetros informados.',cTitulo)
		(cTRB)->( dbCloseArea() )
	Else	
		oFwMsEx := FWMsExcel():New()
		
	   oFwMsEx:AddWorkSheet( cWorkSheet )
	   oFwMsEx:AddTable( cWorkSheet, cTable )	
	   
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'FILIAL'     , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'CONTRATO'   , 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'COD_USUARIO', 1, 1 )
		oFwMsEx:AddColumn( cWorkSheet, cTable, 'USUARIO'    , 1, 1 )
		
		While (cTRB)->( .NOT. EOF() )
			IncProc()
			oFwMsEx:AddRow( cWorkSheet, cTable,  { (cTRB)->CNN_FILIAL, (cTRB)->CNN_CONTRATO, (cTRB)->CNN_USRCOD, UsrFullName( (cTRB)->CNN_USRCOD ) } )
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
		
		oFwMsEx:Activate()
		
		cDirTmp := GetTempPath()
		cDir := GetSrvProfString('Startpath','')
	
		LjMsgRun( 'Gerando o arquivo, aguarde...', cTitulo, {|| oFwMsEx:GetXMLFile( cFile ), Sleep( 500 ) } )
	
		If __CopyFile( cFile, cDirTmp + cFile )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cFile )
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
			Sleep(500)
		Else
			MsgInfo(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>+Não foi possível copiar o arquivo para o diretório temporário do usuário.',cTitulo )
		Endif
   Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A650VLPL   | Autor | Robson Gonçalves               | Data | 29/06/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se há produto GAR, se houver verificar se há 
//        | valor para software ou hardware. Havendo um dos dois valores verificar
//        | se ele bate com o valor total do item. Rotina acionada pelo ponto de 
//        | entrada CN200VLPLA.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650VLPL( aHeader, aCOLS )
	Local lRet := .T.	
	
	Local nI := 0
	Local nCNB_PROGAR := 0
	Local nCNB_VLTOT  := 0
	Local nCNB_VLSOFT := 0
	Local nCNB_VLHARD := 0
	Local nDELET := Len( aCOLS[ 1 ] )
	
	nCNB_ITEM   := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'CNB_ITEM' } )
	nCNB_PROGAR := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'CNB_PROGAR' } )
	nCNB_VLTOT  := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'CNB_VLTOT' } )
	nCNB_VLSOFT := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'CNB_VLSOFT' } )
	nCNB_VLHARD := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'CNB_VLHARD' } )
	
	For nI := 1 To Len( aCOLS )
		If .NOT. aCOLS[ nI, nDELET ]
			If .NOT. Empty( aCOLS[ nI, nCNB_PROGAR ] )
				If (aCOLS[ nI, nCNB_VLSOFT ] > 0) .OR. (aCOLS[ nI, nCNB_VLHARD ] > 0)
					If ( aCOLS[ nI, nCNB_VLSOFT ] + aCOLS[ nI, nCNB_VLHARD ] ) <> aCOLS[ nI, nCNB_VLTOT ]
						lRet := .F.
						MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>O item nº '+aCOLS[nI,nCNB_ITEM]+' desta planilha possui valor para software e/ou hardware'+;
					   '<br>e este(s) valor(es) não bate(m) com o valor total do item.','A650VLPL - Validação de Planilha')
						Exit
					Endif
				Endif
			Endif
		Endif
	Next nI
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A650Motivo | Autor | Robson Gonçalves               | Data | 03.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para solicitar o motivo do cancelamento ou finalização do
//        | contrato para o usuário. Esta rotina é acionada pelo ponto de entrada
//        | CN100SIT.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650Motivo()
	Local aPar := {}
	Local aRet := {}
	Local cWho := ''
	Local cTexto := ''
	Local lRet := .F.
	Local lContinua := .T.
	Local cRet := ''
	
	AAdd( aRet, '' )
	AAdd(aPar,{11,'Obrigatório informar o motivo','','.T.','.T.',.T.})
	
	While lContinua
		lRet := ParamBox(aPar,'Informe o motivo',@aRet,,,,,,,,.F.,.F.)
		cRet := AllTrim( aRet[ 1 ] )
		If Empty( cRet )
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>É obrigatório informar o motivo','A650Motivo | Exigir o motivo' )
		Else
			lContinua := .F.
		Endif
	End
	
	If lRet .AND. .NOT. Empty( cRet )
		cWho := 'Motivo informado por: '+RTrim( UsrFullName( RetCodUsr() ) )+' em '+Dtoc( MsDate() )+' as '+Time()+'.'
		
		If .NOT. Empty( CN9->CN9_MOTCAN )
			cTexto := cWho + CRLF + aRet[ 1 ] + CRLF + AllTrim( CN9->CN9_MOTCAN )
		Else
			cTexto := cWho + CRLF + aRet[ 1 ]
		Endif
				
		CN9->( RecLock( 'CN9', .F. ) )
		CN9->CN9_MOTCAN := cTexto
		CN9->( MsUnLock() )
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A650GrApr  | Autor | Robson Gonçalves               | Data | 07.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina responsável por apresentar os grupos de aprovadores.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650GrApr()
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oPanelTop
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Local aOrdem := {}
	Local cOrd := ''
	Local cRet := ''
	Local cFile := GetTempPath() + 'alllevel.ini'
	Local cSeek := Space(100)
	Local cField := ReadVar()
	Local cReadVar := RTrim(&(ReadVar()))
	Local cCodApr := ''

	Local aDados := {}
	
	Local nI := 0
	Local nL := 0
	Local nOrd := 1

	Local lOk := .F.
	Local lMark := .F.
	Local lNiveis := .F.
	
	A650Niveis( cFile, @lNiveis, .F. )

	AAdd(aOrdem,'Código do grupo') 
	AAdd(aOrdem,'Descrição do grupo') 
	AAdd(aOrdem,'Código do aprovador') 
	AAdd(aOrdem,'Código do usuário')
	AAdd(aOrdem,'Nome do usuário')
	
	cSQL := "SELECT '0' AS MARK,"
	cSQL += "       AL_COD,"
	cSQL += "       AL_DESC,"
	cSQL += "       AL_APROV,"
	cSQL += "       AL_USER,"
	cSQL += "       AL_NOME,"
	cSQL += "       AL_NIVEL"
	cSQL += "FROM   "+RetSqlName("SAL")+" SAL "
	cSQL += "WHERE  AL_FILIAL = "+ValToSql(xFilial("SAL"))+" "
	cSQL += "       AND (AL_MSBLQL = ' '" 
	cSQL += "           OR AL_MSBLQL = '2')"
	If .NOT. lNiveis
		cSQL += "       AND AL_NIVEL = '01' "
	Endif
	cSQL += "       AND SAL.D_E_L_E_T_ = ' '"
	cSQL += "ORDER  BY AL_COD, AL_USER"
	
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
	Else
	
	Endif
   (cTRB)->( dbCloseArea() )
	
	lMark := .F.
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Escolha o(s) grupo(s) de aprovação(ões)' PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
	   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A650PsqGrp(nOrd,cSeek,@oLbx))

		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 40,05 LISTBOX oLbx FIELDS HEADER ;
		' x ','Grupo Apr.','Descrição grupo','Aprovador','Usuário','Nome aprovador/usuário','Nível de aprovação' ;
		SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(cCodApr := aDados[ oLbx:nAt, 2 ], AEval( aDados, {|e| Iif( cCodApr==e[2],(e[1]:=.NOT.e[1]), NIL )}),oLbx:Refresh())
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray(aDados)
		oLbx:bLine := { || {Iif(aDados[oLbx:nAt,1],oOk,oNo),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3],aDados[oLbx:nAt,4],aDados[oLbx:nAt,5],aDados[oLbx:nAt,6],aDados[oLbx:nAt,7]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aDados, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os grupos de aprovação...') }
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A650VldGrp(aDados,@lOk),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
		@ 3,250 CHECKBOX oNiveis VAR lNiveis PROMPT 'Considere todos os níveis de aprovação.' SIZE 150,7 PIXEL OF oPanelBot ON CLICK( A650Niveis( cFile, @lNiveis, .T. ))
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lOk
		For nI := 1 To Len( aDados )
			If aDados[ nI, 1 ] .AND. (.NOT. aDados[ nI, 2 ] $ cRet)
				If (Len(cRet)+7) > 71
					MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>É possível a seleção de no máximo 10 grupos de aprovações.','Grupo de aprovações')
					Exit
				Endif
				cRet += aDados[ nI, 2 ] + '|'
			Endif
		Next nI
		cRet := PadR( SubStr( cRet, 1, Len( cRet )-1 ), Len( CN9->CN9_GRPAPR ), ' ' )
		&(cField) := cRet
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A650Niveis | Autor | Robson Gonçalves               | Data | 07.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para controlar se apresenta todos os níveis na query de alçada.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650Niveis( cFile, lNiveis, lWrite )
	Local nHdl := 0
	Local nModo := 0
	Local cBuffer := ''
	Local cParametro := ''
	If lWrite
		nModo := 1
		If lNiveis
			cParametro := 'NIVEIS=1'
		Else
			cParametro := 'NIVEIS=0'
		Endif
	Else
		nModo := 0
		cParametro := 'NIVEIS=0'
	Endif
	If .NOT. File( cFile )
		nHdl := FCreate( cFile )
		FWrite( nHdl, cParametro )
		lNiveis := .F.
	Else
		nHdl := FOpen( cFile, nModo )
		If lWrite
			FSeek( nHdl, 0 )
			FWrite( nHdl, cParametro )
			cBuffer := cParametro
		Else
			FRead( nHdl, @cBuffer, 128 )
		Endif
	Endif
	If cBuffer == 'NIVEIS=1'
		lNiveis := .T.
	Else
		lNiveis := .F.
	Endif
	FClose( nHdl )	
Return

//---------------------------------------------------------------------------------
// Rotina | A650PsqGrp | Autor | Robson Gonçalves               | Data | 07.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para efetuar pesquisa no vetor.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650PsqGrp( nOrd, cSeek, oLbx )
	Local nP := 0
	Local nColPesq := 0
		
	If nOrd==1       ; nColPesq := 2
	Elseif nOrd == 2 ; nColPesq := 3
	Elseif nOrd == 3 ; nColPesq := 4
	Elseif nOrd == 4 ; nColPesq := 5
	Elseif nOrd == 5 ; nColPesq := 6
	Else
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Opção não disponível para pesquisa.','Pesquisar')
	Endif
	
	If nColPesq > 0
		nP := AScan( oLbx:aArray, {|p| Upper( AllTrim( cSeek ) ) $ Upper( AllTrim( p[ nColPesq ] ) ) } )	
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
		Else
			MsgInfo(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Informação não localizada.','Pesquisar')
		Endif
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A650VldGrp | Autor | Robson Gonçalves               | Data | 07.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para validar se escolheu algum registro.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650VldGrp( aDados, lOk )
	Local nP := 0
	Local lRet := .T.
	nP := AScan( aDados, {|p| p[ 1 ] } )
	lOk := ( nP > 0 )
	If .NOT. lOk
		lRet := .F.
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Não foi selecionado nenhum grupo de aprovador.', 'Validação da seleção de grupo' )
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A650VGAp    | Autor | Robson Gonçalves              | Data | 10/07/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar o grupo de aprovação.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650VGAp()
	Local nI := 0
	Local aGrp := {}
	Local cGrp := ''
	If .NOT. Empty( M->CN9_GRPAPR )	
   	aGrp := StrToKarr( M->CN9_GRPAPR, '|' )
   	For nI := 1 To Len( aGrp )
   		cGrp := RTrim( aGrp[ nI ] )
   		If .NOT. ExistCpo( 'SAL', cGrp, NIL, NIL, .F. )
   			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Não existe grupo de aprovação com o código: '+cGrp+'.','Grupo de aprovação inválido')
   			Return( .F. )
   		Endif
   	Next nI
	Endif
Return( .T. )

//---------------------------------------------------------------------------------
// Rotina | A650WFAp    | Autor | Robson Gonçalves              | Data | 17.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para enviar o WF de aprovação do contrato.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650WFAp( cDestino, lReenvio )
	Local lCompra := Empty( CN9->CN9_CLIENT )
	Local cMV_650_01 := 'MV_650_01'
	Local cMV_650_02 := 'MV_650_02'
	Local aCONTRATO := Array( 4 )
	Local cUsuarios := ''
	Local nCN9_RECNO := CN9->( RecNo() )
	
	DEFAULT lReenvio := .F.
		
	// Quando o campo CN9_OKAY estiver com 2 ou 3 não precisa mais ser submetido a aprovação, pois já foi aprovado/rejeitado.
	// O campo CN9_OKAY pode ser: 0=Legado; 1=Em aprovacao; 2=Aprovado; 3=Rejeitado.
	If CN9->CN9_OKAY == '2'
		MsgInfo(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>O contrato não será submetido a aprovação, pois ele já foi aprovado.','Aprovação de contrato')
		Return
	Endif
	
	A650AprParam( @cMV_650_01, @cMV_650_02 )

	// O destino é para vigente, se for manipular.
	If cDestino == '05'
		// O mecanismo de aprovação automática de contratos está habilitada?
		If cMV_650_01 == 1
			// Se for contrato de compra e o parâmetro está configurado como compra ou ambos ou...
			// Se for contrato de venda e o parâmetro está configurado como venda ou ambos, fazer.
			If ( lCompra .AND. ( cMV_650_02 == 1 .OR. cMV_650_02 == 3 ) ) .OR. ( .NOT. lCompra .AND. ( cMV_650_02 == 2 .OR. cMV_650_02 == 3 ) )
				If .NOT. Empty( CN9->CN9_GRPAPR )
				
					cUsuarios := A650AlcDoc( RTrim( CN9->CN9_GRPAPR ), lReenvio )
					
					If .NOT. Empty( cUsuarios )
						aCONTRATO[ 1 ] := CN9->CN9_FILIAL
						aCONTRATO[ 2 ] := CN9->CN9_NUMERO
						aCONTRATO[ 3 ] := cUsuarios
						aCONTRATO[ 4 ] := cDestino
						
						U_CSFA603( 2, NIL, aCONTRATO )
						
						If CN9->( RecNo() ) <> nCN9_RECNO
							CN9->( dbGoTo( nCN9_RECNO ) )
						Endif
						
						CN9->( RecLock( 'CN9', .F. ) )
						CN9->CN9_SITUAC := '04'
						CN9->( MsUnLock() )
						
						MsgInfo(cFONT+'LEIA COM ATENÇÃO'+cNOFONT+'<br><br>O contrato precisa de aprovação para mudar sua situação para vigente, por isso, <br>'+;
						        'foi enviado workflow para o(s) usuário(s) do(s) grupo(s) de aprovação(ões) informado. <br><br>Por favor, aguarde a análise '+;
						        'e aprovação do(s) usuário(s) indicado(s).','Aprovação automática de contrato')
					Else
						MsgAlert('Não localizei usuários para o grupo de aprovadores informado.','Aprovação automática de contrato') 
					Endif
				Endif
			Endif
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A650AprParam | Autor | Robson Gonçalves             | Data | 17.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para verificar se existe os parâmetros.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650AprParam( cMV_650_01, cMV_650_02 )
	If .NOT. GetMv( cMV_650_01, .T. )
		CriarSX6( cMV_650_01, 'N', 'CONTROLE DE APROVACAO AUTOMATICO DE CONTRATO. 0=DESLIGADO E 1=LIGADO. CSFA650.prw', '1' )
	Endif
	cMV_650_01 := GetMv('MV_650_01',.F.)
	
	If .NOT. GetMv( cMV_650_02, .T. )
		CriarSX6( cMV_650_02, 'N', 'TIPOS DE CONTRATOS QUE DEVEM PASSAR PELO PROCESSO DE APROVACAO. 1=COMPRA, 2=VENDA, 3=AMBOS. CSFA650.prw', '1' )
	Endif
	cMV_650_02 := GetMv('MV_650_02',.F.)	
Return

//---------------------------------------------------------------------------------
// Rotina | A650AlcDoc  | Autor | Robson Gonçalves              | Data | 17.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para avaliar os usuários conforme o grupo de aprovadores e gerar
//        | o controle de aprovação na tabela SCR.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650AlcDoc( cCN9_GRPAPR, lReenvio )
	Local cRet := ''
	Local cWhere := ''
	Local cTRB := GetNextAlias()
	Local cSQL := ''	
	//Local aUser := {}
	Local aGroup := {}
	Local NI	:=1
	
	aGroup := StrToKarr( cCN9_GRPAPR, '|' )
	cWhere := '('
	For nI := 1 To Len( aGroup )
		cWhere += " AK_COD = " + ValToSql( aGroup[ nI ] ) + " OR "
	Next nI
	cWhere := SubStr( cWhere, 1, Len( cWhere )-4 )
	cWhere := cWhere + ')'
	
	cSQL := "SELECT AK_COD, AK_USER "
	cSQL += "FROM   "+RetSqlName("SAK")+" SAK "
	cSQL += "WHERE  AK_FILIAL = "+ValToSql( xFilial( "SAK" ) )+" "
	cSQL += "       AND AK_MSBLQL <> '1' "
	cSQL += "       AND SAK.D_E_L_E_T_ = ' ' "
	cSQL += "       AND " + cWhere + " "
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGenQry(,,cSQL), cTRB, .T., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		cRet += (cTRB)->AK_USER + '|'
		A650GrvSCR( cTRB, lReenvio )
		(cTRB)->( dbSkip() )
	End
	cRet := SubStr( cRet, 1, Len( cRet )-1 )
	(cTRB)->( dbCloseArea() )
Return( cRet )

//---------------------------------------------------------------------------------
// Rotina | A650UsrGrp  | Autor | Robson Gonçalves              | Data | 17.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar os usuários do grupo de aprovação.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650UsrGrp( cCN9_GRPAPR )
	Local cRet := ''
	Local cWhere := ''
	Local cTRB := GetNextAlias()
	Local cSQL := ''	
	Local aGroup := {}
	Local ni	:=1
	
	aGroup := StrToKarr( cCN9_GRPAPR, '|' )
	cWhere := '('
	For nI := 1 To Len( aGroup )
		cWhere += " AL_COD = " + ValToSql( aGroup[ nI ] ) + " OR "
	Next nI
	cWhere := SubStr( cWhere, 1, Len( cWhere )-4 )
	cWhere := cWhere + ')'
	
	cSQL := "SELECT AL_APROV, AL_USER, AL_NIVEL "
	cSQL += "FROM   "+RetSqlName("SAL")+" SAL "
	cSQL += "WHERE  AL_FILIAL = "+ValToSql( xFilial( "SAL" ) )+" "
	cSQL += "       AND AL_NIVEL = '01' "
	cSQL += "       AND SAL.D_E_L_E_T_ = ' ' "
	cSQL += "       AND " + cWhere + " "
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGenQry(,,cSQL), cTRB, .T., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		cRet += (cTRB)->AL_USER + '|'
		(cTRB)->( dbSkip() )
	End
	cRet := SubStr( cRet, 1, Len( cRet )-1 )
	(cTRB)->( dbCloseArea() )
Return( cRet )

//---------------------------------------------------------------------------------
// Rotina | A650GrvSCR  | Autor | Robson Gonçalves              | Data | 17.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para gravar os registros de controle de aprovação.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
//+--------------------------------------------------------+
//| Controle de Aprovacao: CR_STATUS                       |
//| ------------------------------------------------------ |
//| 01 - Bloqueado pelo sistema (aguardando outros niveis) |
//| 02 - Aguardando Liberacao do usuario                   |
//| 03 - Liberado pelo usuario                    	        |
//| 04 - Bloqueado pelo usuario                   		     |
//| 05 - Liberado por outro usuario              		     |
//+--------------------------------------------------------+
Static Function A650GrvSCR( cTRB, lReenvio )
	Local cSQL := ''
	Local cTABLE := ''
	
	//-------------------------------------------------------------
	// Quando for reenvio é preciso excluir os registros pendentes.
	//-------------------------------------------------------------
	If lReenvio
		cSQL := "SELECT R_E_C_N_O_ CR_RECNO "
		cSQL += "FROM   "+RetSqlName("SCR") + " SCR "
		cSQL += "WHERE  CR_FILIAL = "+ValToSql( xFilial( "SCR" ) ) + " "
		cSQL += "       AND CR_NUM = "+ValToSql( CN9->CN9_NUMERO + CN9->CN9_REVISA ) + " "
		cSQL += "       AND CR_TIPO = "+ValToSql( cTP_DOC ) + " "
		cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
		cSQL := ChangeQuery( cSQL )
		cTABLE := GetNextAlias()
		dbUseArea( .T., 'TOPCONN', TCGenQry(,,cSQL), cTABLE, .T., .T. )

		SCR->( dbSetOrder( 1 ) )
		While (cTABLE)->( .NOT. EOF() )
			SCR->( dbGoTo( (cTABLE)->( CR_RECNO ) ) )
			If SCR->( RecNo() ) == (cTABLE)->( CR_RECNO )
				SCR->( RecLock( 'SCR', .F. ) )
				SCR->( dbDelete() )
				SCR->( MsUnLock() )
		   Endif
			(cTABLE)->( dbSkip() )
		End
		(cTABLE)->( dbCloseArea() )
	Endif

	//--------------------------------------------------
	// Fazer o novo registro para controle de aprovação.
	//--------------------------------------------------
	SCR->( dbSetOrder( 1 ) )
	SCR->( RecLock( 'SCR', .T. ) )
	SCR->CR_FILIAL  := xFilial( 'SCR' )
	SCR->CR_NUM     := CN9->CN9_NUMERO + CN9->CN9_REVISA
	SCR->CR_TIPO    := cTP_DOC //Aprovação automática de contrato (CSFA650).
	SCR->CR_USER    := (cTRB)->AK_USER
	SCR->CR_APROV   := (cTRB)->AK_COD
	SCR->CR_NIVEL   := '01'
	SCR->CR_STATUS  := '01' //Bloqueado pelo sistema (aguardando outros niveis).
	SCR->CR_OBS     := 'APROV. DE CONTRATO CSFA650'
	SCR->CR_TOTAL   := CN9->CN9_VLATU
	SCR->CR_EMISSAO := dDataBase
	SCR->CR_MOEDA   := CN9->CN9_MOEDA
	SCR->CR_TXMOEDA := 1
	SCR->( MsUnLock() )
Return

//---------------------------------------------------------------------------------
// Rotina | A650StAp    | Autor | Robson Gonçalves              | Data | 17.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para consultar os status de aprovação dos usuários para o 
//        | contrato.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650StAp()
   Local oDlg
   Local oLbx
   Local oBold 
   
   Local cSQL := ''
   Local cTRB := GetNextAlias()
   Local cStatus := ''
   Local cNameUser := ''
   Local cSituacao := ''
   Local cRevisao := ''
   Local nPos := 0
   Local cCN9_REVISA := 'Não há revisão'
   
   Local aDADOS := {}
   Local aStruSCR := {}
   
   If CN9->CN9_OKAY == '0'
   	MsgAlert('A aprovação deste contrato faz parte do legado de contratos.','Aprovação de contratos')
   	Return
   Endif
   
   If CN9->CN9_REVISA <> CN9->CN9_REVATU
   	CN9->( dbSetOrder( 1 ) )
   	CN9->( dbSeek( xFilial( 'CN9' ) + CN9->CN9_NUMERO + CN9->CN9_REVATU ) )
   Endif
   
   cSQL := "SELECT CR_USER, "
   cSQL += "       CR_NIVEL, "
   cSQL += "       CR_STATUS, "
   cSQL += "       CR_DATALIB "
   cSQL += "FROM   "+RetSqlName("SCR")+" SCR "
   cSQL += "WHERE  CR_FILIAL = "+ValToSql( xFilial( "SCR" ) )+" "
   cSQL += "       AND CR_NUM = "+ValToSql( CN9->CN9_NUMERO + CN9->CN9_REVISA ) + " "
   cSQL += "       AND CR_TIPO = "+ValToSql(cTP_DOC)+" "
   cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
   cSQL += "ORDER  BY CR_USER "
   
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->(.NOT. BOF()) .AND. (cTRB)->(.NOT.EOF())
		aStruSCR  := SCR->( dbStruct() )
		AEval( aStruSCR, {|e| Iif( e[ 2 ] <> 'C', TCSetField( cTRB, e[ 1 ], e[ 2 ], e[ 3 ], e[ 4 ] ), NIL ) } )
		While (cTRB)->(.NOT. EOF() )
			cNameUser := RTrim( UsrFullName( (cTRB)->CR_USER ) )
			nPos := At(' ',cNameUser)
			cNameUser := SubStr(cNameUser,1,nPos-1)
			If (cTRB)->CR_STATUS == '01'
				cSituacao := 'Aguardando...'
			Elseif (cTRB)->CR_STATUS == '03'
				cSituacao := 'Liberado.'
			Elseif (cTRB)->CR_STATUS == '04'
				cSituacao := 'Bloqueado.'
			Endif
			(cTRB)->( AAdd( aDADOS, { CR_NIVEL, CR_USER, cSituacao, cNameUser, CR_DATALIB, ' ' } ) )
			(cTRB)->( dbSkip() )
		End
	   
	   If .NOT. Empty( CN9->CN9_REVISA )
	   	cCN9_REVISA := CN9->CN9_REVISA
	   Endif
	   
	   cStatus := Iif(CN9->CN9_SITUAC == '04', 'Contrato em processo de aprovação.', 'Contrato aprovado.' )
	   
	   DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg TITLE 'Aprovação do Contrato' From 109,095 To 400,600 OF oMainWnd PIXEL
			@ 5,3 TO 32,250 LABEL "" OF oDlg PIXEL
	
			@ 15,7   SAY 'Contrato:' OF oDlg FONT oBold PIXEL SIZE 46,9
			@ 14,037 MSGET CN9->CN9_NUMERO  PICTURE "" WHEN .F. PIXEL SIZE 120,9 OF oDlg FONT oBold
			@ 15,168 SAY 'Revisão:' OF oDlg PIXEL SIZE 45,9 FONT oBold
			@ 14,195 MSGET cCN9_REVISA PICTURE "" WHEN .F. of oDlg PIXEL SIZE 50,9 FONT oBold
			
		   oLbx := TwBrowse():New(38,3,250,80,,{'Nível','Usuário','Situação','Aprovado por','Data liberação',''},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:SetArray( aDADOS )
		   oLbx:bLine := {|| AEval( aDADOS[oLbx:nAt],{|z,w| aDADOS[oLbx:nAt,w]})}
		
			@ 126,002 TO 127,250 LABEL '' OF oDlg PIXEL
			@ 132,008 SAY 'Situação:' OF oDlg PIXEL SIZE 52,9
			@ 131,038 SAY cStatus OF oDlg PIXEL SIZE 120,9 FONT oBold
			@ 132,215 BUTTON 'Fechar' SIZE 035 ,010  FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		MsgInfo('Não há controle de aprovação para este contrato','Aprovação de contrato')
	Endif
	(cTRB)->( dbCloseArea() )
Return

//---------------------------------------------------------------------------------
// Rotina | A650ApMnu   | Autor | Robson Gonçalves              | Data | 17.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para reenviar o workflow de aprovação do contrato em questão.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650ApMnu()
	Local aSay := {}
	Local aButton := {}
	Local cTitulo := 'Aprovação de contrato'
	Local nOpcao := 0
	Local cMV_650_03 := 'MV_650_03'
	Local lAcesso := .F.
	Local lReenvio := .T.
	
	If .NOT. GetMv( cMV_650_03, .T. )
		CriarSX6( cMV_650_03, 'C', 'USUARIOS AUTORIZADOS A REENVIAR WORKFLOW DE APROVACAO DE CONTRATO. CSFA650.prw', '000908' )
	Endif		
	cMV_650_03 := GetMv( cMV_650_03, .F. )
	
	lAcesso := (RetCodUsr()$cMV_650_03)
	
	AAdd( aSay, 'Esta rotina permite que seja reenviado WorkFlow de aprovação de contrato. O e-mail de' )
	AAdd( aSay, 'aviso e o WorkFlow será enviado para os usuários do grupo de aprovador indicado' )
	AAdd( aSay, 'no contrato.' )
	AAdd( aSay, ' ' )
	If .NOT.lAcesso
		AAdd( aSay, 'VOCÊ NÃO POSSUI ACESSO PARA OPERAR ESTA ROTINA. VERIFIQUE O MV_650_03' )
	Endif
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpcao == 1
		If .NOT. Empty( CN9->CN9_GRPAPR ) 	// Há grupo de aprovação?
			If CN9->CN9_OKAY == '1' 			// Em aprovação.
				If CN9->CN9_SITUAC == '04'  	// Em aprovação.
					Begin Transaction 
						U_A650WFAp( '05', lReenvio )      // O parâmetro é para colocar em vigência.
					End Transaction
				Else
					MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Somente contrato em aprovação é que<br>poderão ser enviados WorkFlow para aprovação.', cTitulo )
				Endif
			Else
				MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Somente contrato em aprovação é que<br>poderão ser enviados WorkFlow para aprovação.', cTitulo )
			Endif
		Else
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>O contrato está sem grupo de aprovação, portanto,<br>não será possível executar esta operação.', cTitulo )
		Endif
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A650Aprov   | Autor | Robson Gonçalves              | Data | 17.07.2015
//---------------------------------------------------------------------------------
// Descr. | Rotina para o usuário aprovar/rejeitar o contrato em questão conforme
//        | o grupo de aprovação informado.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650Aprov()
	Local cTitulo := 'Aprovação contrato'
	Local cUsuarios := ''
	//Local aUser := {}
	Local cCodUser := ''
	Local cDocto := ''
	Local nOpc := 0
	Local cMotivo := ''
	Local aRet := {}
	Local aPar := {}
	Local lContinua := .T.
	Local lCompra := Empty( CN9->CN9_CLIENT )
	Local cMV_650_01 := 'MV_650_01'
	Local cMV_650_02 := 'MV_650_02'
		
	If CN9->CN9_OKAY == '0'
		MsgAlert('A aprovação deste contrato faz parte do legado de contratos.',cTitulo)
		Return
	Endif
	
	If CN9->CN9_OKAY == '2'
		MsgAlert(cFONTOK+'Contrato já aprovado.'+cNOFONT,'Aprovação de contratos',cTitulo)
		Return
	Endif
	
	If CN9->CN9_OKAY == '3'
		MsgAlert(cFONT+'Contrato reprovado.'+cNOFONT,'Aprovação de contratos',cTitulo)
		Return
	Endif
	
	//-------------------------------------------------------------------------------------------------------------
	// Rotina para saber se a aprovação de contrato está ligado e se o tipo de contrato é compras, vendas ou ambos.
	//-------------------------------------------------------------------------------------------------------------	
	A650AprParam( @cMV_650_01, @cMV_650_02 )

	// O mecanismo de aprovação automática de contratos está habilitada?
	If cMV_650_01 == 1
		// Se for contrato de compra e o parâmetro está configurado como compra ou ambos ou...
		// Se for contrato de venda e o parâmetro está configurado como venda ou ambos, fazer.
		If ( lCompra .AND. ( cMV_650_02 == 1 .OR. cMV_650_02 == 3 ) ) .OR. ( .NOT. lCompra .AND. ( cMV_650_02 == 2 .OR. cMV_650_02 == 3 ) )
		   If CN9->CN9_SITUAC <> '04' //Em aprovação.
		   	MsgInfo( cFONT + 'ATENÇÃO' + cNOFONT + '<br><br>Somente contrato que está aguardando aprovação é<br>que poderá ser executado por esta rotina.', cTitulo )
		   	Return
		   Endif
		   
		   If Empty( CN9->CN9_GRPAPR )
				MsgInfo( cFONT + 'ATENÇÃO' + cNOFONT + '<br><br>.Este contrato não possui grupo de aprovação<br>para ser eleger os aprovadores.', cTitulo )
				Return
		   Endif
		   
		   If CN9->CN9_REVISA <> CN9->CN9_REVATU
				CN9->( dbSetOrder( 1 ) )
			   CN9->( dbSeek( xFilial( 'CN9' ) + CN9->CN9_NUMERO + CN9->CN9_REVATU ) )
			Endif
			//--------------------------------------------------------------------------------------
			// Manutenção: Robson Gonçalves.
			//--------------------------------------------------------------------------------------
			// Retirei esta chamada em 23/11/2017 porque a aprovação é por aprovador
			// e não mais por grupo de aprovação, a mudança de conceito foi feita por
			// outro desenvolvedor, não sei informar quem e nem quando, precisa analisar no SVC.
			//cUsuarios := A650UsrGrp( RTrim( CN9->CN9_GRPAPR ) ) 
			//--------------------------------------------------------------------------------------
			//cUsuarios := RTrim( CN9->CN9_GRPAPR )
			
			//RBeghini [31.01.2018]  - Deve buscar o código de usuario conforme o código do aprovador.
			cUsuarios := A650UsrApr( RTrim( CN9->CN9_GRPAPR ) )
			cCodUser := RetCodUsr()
			If cCodUser $ cUsuarios
				nOpc := Aviso(cTitulo,'Em relação ao contrato '+CN9->CN9_NUMERO+'. O que deseja fazer?',{'Aprovar','Rejeitar','Sair'},2,'Aprovar/Rejeitar')
				If nOpc == 1
					cAprovacao := 'S'
				Elseif nOpc == 2
					cAprovacao := 'N'
					AAdd(aPar,{11,'Qual o motivo da rejeição','','.T.','.T.',.T.})
					While lContinua
						If ParamBox(aPar,'Registrar motivo da rejeição',@aRet,,,,,,,,.F.,.F.)
							lContinua := .F.
							cMotivo := AllTrim( aRet[ 1 ] )
						Endif
					End
				Endif
				
				cAprovador := UsrFullName( cCodUser )
				
				cDocto := CN9->CN9_NUMERO + CN9->CN9_REVISA
				cDocto := cDocto + Space( Len( SCR->CR_NUM )-Len( cDocto ) )
				
				U_A603LibRej( cDocto, CN9->CN9_FILIAL, CN9->CN9_NUMERO, CN9->CN9_REVISA, cAprovacao, cAprovador, cMotivo, cCodUser )
			Else
				MsgInfo( cFONT + 'ATENÇÃO' + cNOFONT + '<br><br>.Seu usuário não está eleito para aprovar este contrato.', cTitulo )
			Endif
		Else
			MsgAlert('O mecanismo de aprovação automática está desligado.',cTitulo)
		Endif
	Else
		MsgAlert('O mecanismo de aprovação automática está desligado.',cTitulo)
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | CSFA650    | Autor | Robson Gonçalves     | Data | 24.07.2015
//-----------------------------------------------------------------------
// Descr. | Rotina para importar dados do contrato.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA650()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	Private cCadastro := 'Importação dados contrato'
	
	AAdd( aSay, 'Esta rotina tem por objetivo em importar dados do contrato conforme planilha de dados' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
   
	If nOpcao==1
		A650GetArq()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A650GetArq | Autor | Robson Gonçalves     | Data | 24.07.2015
//-----------------------------------------------------------------------
// Descr. | Rotina para solicitar parâmetro de busca para o usuário.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A650GetArq()
	Local nB := 0
	Local aPar := {}
	Local aRet := {}
	Local bOk 
	Local cArq := ""
	Local cArqDados := ""
	Local cSystem := GetSrvProfString( "Startpath", "" )
	Local cBarra := Iif( IsSrvUnix(), "/", "\" )
	
	bOk := {|| 	Iif( File( mv_par01 ), ;
					MsgYesNo( "Confirma o início do processamento?", cCadastro ),;
					( MsgAlert("Arquivo não localizado, verifique.", cCadastro ), .F. ) ) }	

	AAdd( aPar, { 6, "Capturar o arquivo de dados", Space(99), "", "", "", 80, .T., "CSV (separado por vírgulas) (*.csv) |*.csv", "" } )
	If ParamBox(aPar,"Parâmetros",@aRet,bOk,,,,,,,.F.,.F.)
		cArq := RTrim( aRet[ 1 ] )
		nB := Rat( cBarra, cArq )
		cArqDados := SubStr( cArq, nB + 1 )
		If __CopyFile( cArq, cSystem + cArqDados )	
	   	Processa( {|| A650LeGrv( cArqDados ) }, cCadastro , "Aguarde...", .F. )
		Else
			MsgAlert( 'Não foi possível copiar o arquivo do local origem para o destino.', cCadastro)
		Endif
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A650LeGrv  | Autor | Robson Gonçalves     | Data | 24.07.2015
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento do arquivo de dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A650LeGrv( cArqDados )
	Local cDados := ''
	Local aDados := {}
	
	Private nLinha := 1
	Private nP_NUM_FILIAL      := 0
	Private nP_CONTRATO        := 0
	Private nP_AVI_VENCIMENTO  := 0
	Private nP_AVI_PERIODICO   := 0
	Private nP_NUM_RECORRENCIA := 0
	Private nP_NUM_RENOVACAO   := 0
	Private nP_GRUPO_APROVADOR := 0
	Private a650Log := {}
	
	FT_FUSE( cArqDados )	
	FT_FGOTOP()
	ProcRegua( FT_FLASTREC() )
	
	cDados := FT_FREADLN() + ';'
	nLinha++	
	FT_FSKIP()
	
	A650LeLin( cDados, @aDados )
	
	nP_NUM_FILIAL      := AScan( aDados, {|p| p == "NUM_FILIAL"  } )
	nP_CONTRATO        := AScan( aDados, {|p| p == "CONTRATO"  } )
	nP_AVI_VENCIMENTO  := AScan( aDados, {|p| p == "AVI_VENCIMENTO"  } )
	nP_AVI_PERIODICO   := AScan( aDados, {|p| p == "AVI_PERIODICO"  } )
	nP_NUM_RECORRENCIA := AScan( aDados, {|p| p == "NUM_RECORRENCIA"  } )
	nP_NUM_RENOVACAO   := AScan( aDados, {|p| p == "NUM_RENOVACAO"  } )
	nP_GRUPO_APROVADOR := AScan( aDados, {|p| p == "GRUPO_APROVADOR"  } )

	While .NOT. FT_FEOF()
		IncProc()
		cDados := FT_FREADLN() + ';'
		A650LeLin( cDados, @aDados )
		A650Gravar( aDados )
		nLinha++
		FT_FSKIP()
	End
	FT_FUSE()
	
	AAdd( a650Log, { 'DT.PROCESS.:'+Dtoc( dDataBase ), 'HR.PROCESS.:'+Time(), '', '', '', '', '', '', '', '' } )
	FwMsgRun(,{|| DlgToExcel( { { "ARRAY", "", {'STATUS','NUM_LINHA','NUM_FILIAL','CONTRATO','AVI_VENCIMENTO','AVI_PERIODICO','NUM_RECORRENCIA','NUM_RENOVACAO','GRUPO_APROVADOR'},;
	a650Log } } ) };
	,,'Aguarde, gerando log de processamento...')
Return

//-----------------------------------------------------------------------
// Rotina | A650LeLin  | Autor | Robson Gonçalves     | Data | 24.07.2015
//-----------------------------------------------------------------------
// Descr. | Rotina de leitura e decomposicao da linha.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A650LeLin( cReg, aArray )
	Local nP := 0
	aArray := {}
	While ( At( ';' + ';', cReg ) > 0 )
		cReg := StrTran( cReg, ( ';' + ';' ), ( ';' + ' ' + ';' ) )
	End
	While .NOT. Empty( cReg )
		nP := At( ';', cReg )
		AAdd( aArray, AllTrim( SubStr( cReg, 1, nP-1 ) ) )
		cReg := SubStr( cReg, nP+1 )
	End
Return

//-----------------------------------------------------------------------
// Rotina | A650Gravar | Autor | Robson Gonçalves     | Data | 24.07.2015
//-----------------------------------------------------------------------
// Descr. | Rotina de gravacao dos dados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A650Gravar( aDados )
	Local cCN9_FILIAL := aDados[ nP_NUM_FILIAL ]
	Local cCN9_NUMERO := aDados[ nP_CONTRATO ]
	Local nCN9_AVITER := Val( aDados[ nP_AVI_VENCIMENTO ] )
	Local nCN9_AVIPER := Val( aDados[ nP_AVI_PERIODICO ] )
	Local cCN9_RECORR := aDados[ nP_NUM_RECORRENCIA ]
	Local cCN9_TPRENO := aDados[ nP_NUM_RENOVACAO ]
	Local cCN9_GRPAPR := aDados[ nP_GRUPO_APROVADOR ]

	CN9->( dbSetOrder( 1 ) )
	If CN9->( dbSeek( cCN9_FILIAL + cCN9_NUMERO ) )
	   If CN9->CN9_REVISA <> CN9->CN9_REVATU
	   	CN9->( dbSeek( cCN9_FILIAL + CN9->CN9_NUMERO + CN9->CN9_REVATU ) )
	   Endif
		CN9->( RecLock( 'CN9', .F. ) )
	   CN9->CN9_AVITER := nCN9_AVITER
	   CN9->CN9_AVIPER := nCN9_AVIPER
	   CN9->CN9_RECORR := cCN9_RECORR
	   CN9->CN9_TPRENO := cCN9_TPRENO
	   CN9->CN9_GRPAPR := cCN9_GRPAPR
		CN9->( MsUnLock() )
		AAdd( a650Log, { 'OK FEITO', ;
		                 LTrim( Str( nLinha, 6, 0 ) ), ;
		                 cCN9_FILIAL, ;
		                 cCN9_NUMERO, ;
		                 nCN9_AVITER, ;
		                 nCN9_AVIPER, ;
		                 cCN9_RECORR, ;
		                 cCN9_TPRENO, ;
		                 cCN9_GRPAPR })
	Else
		AAdd( a650Log, { 'NÃO LOCALIZADO CONTRATO', ;
		                 LTrim( Str( nLinha, 6, 0 ) ), ;
		                 cCN9_FILIAL, ;
		                 cCN9_NUMERO, ;
		                 nCN9_AVITER, ;
		                 nCN9_AVIPER, ;
		                 cCN9_RECORR, ;
		                 cCN9_TPRENO, ;
		                 cCN9_GRPAPR })
	Endif
Return
//---------------------------------------------------------------------------------
// Rotina | UPD650     | Autor | Robson Gonçalves               | Data | 24/06/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina de update p/ criar as estruturas no dicionário dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function UPD650()
	Local cModulo := 'GCT'
	Local bPrepar := {|| U_U650Ini() }
	Local nVersao := 1
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//---------------------------------------------------------------------------------
// Rotina | U650Ini    | Autor | Robson Luiz - Rleg             | Data | 24/06/2015
//---------------------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function U650Ini()
	aSIX := {}
	aSX3 := {}
	aSXB := {}
	aHelp := {}
	
	AAdd(aSX2,{'PAP',;                             //Alias
	           '',;                                //Path
	           'Processar eventos de cnontratos',; //Nome
	           'Processar eventos de cnontratos',; //Nome esp.
	           'Processar eventos de cnontratos',; //Nome inglês
	           'E',;                               //Modo
	           '',;                                //Único
	           '',;                                //Modo unidade.
	           'E'})	                             //Modo empresa.
	
	AAdd(aSX3,  {'PAP',NIL,'PAP_FILIAL','C',2,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Filial','Filial','Filial',;    																			//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Filial do sistema.','Filial do sistema.','Filial do sistema.',;								//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','N','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_FILIAL', 'Filial do sistema.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_CONTRA','C',15,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Nº Contrato','Nº Contrato','Nº Filial',;    														//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Nº do contrato.','Nº do contrato.','Nº do contrato.',;											//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_CONTRA', 'Numero do contrato.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_REVISA','C',3,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Revisao','Revisao','Revisao',;    																		//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Revisao do contrato.','Revisao do contrato.','Revisao do contrato.',;						//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_REVISA', 'Revisao do contrato.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_USER','C',6,0,;                     												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Usuario','Usuario','Usuario',;    																		//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Usuario gerou o evento.','Usuario gerou o evento.','Usuario gerou o evento.',;			//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_USER', 'Usuário que gerou o evento do contrato.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_DTMOV','D',8,0,;                     												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'DT.Movto.','DT.Movto.','DT.Movto.',;    																//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Data do movimento.','Data do movimento.','Data do movimento.',;								//Desc. Port.,Desc.Esp.,Desc.Ing.
					'99/99/99',;                                         												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_DTMOV', 'Data do movimento do evento.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_HRMOV','C',8,0,;                     												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'HR.Movto.','HR.Movto.','HR.Movto.',;    																//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Hora do movimento.','Hora do movimento.','Hora do movimento.',;								//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                         														//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_HRMOV', 'Hora do movimento do evento.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_SITDE','C',18,0,;                    												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Situacao de','Siuacao de','Situacao de',;    														//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Situacao em que estava.','Situacao em que estava.','Situacao em que estava.',;			//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                         										 				//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_SITDE', 'Situacao em que estava o contrato.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_SITPAR','C',18,0,;                   												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Situac. para','Situac. para','Situac. para',; 														//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Situacao que foi modif.','Situacao que foi modif.','Situacao que foi modif.',;			//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                         										 				//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_SITPAR', 'Situacao que foi modificado o contrato.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_ARQHTM','C',50,0,;                  												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Template HTM','Template HTM','Template HTM',; 														//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Template HTML.','Template HTML.','Template HTML.',;												//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                         										 				//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_ARQHTM', 'Nome do template HTML utilizado para envio do e-mail.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_DTPROC','D',8,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'DT.Proc.','DT.Proc.','DT.Proc.',;    												 					//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Data do processamento.','Data do processamento.','Data do processamento.',;				//Desc. Port.,Desc.Esp.,Desc.Ing.
					'99/99/99',;                                         												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_DTPROC', 'Data do processanento do evento.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_HRPROC','C',8,0,;                    												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'HR.Proc.','HR.Proc.','HR.Proc.',;    																	//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Hora do processamento.','Hora do processamento.','Hora do processamento.',;				//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                         														//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;                                           												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_HRPROC', 'Hora do processamento do evento.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_MODO','C',1,0,;                  													//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Modo Exec.','Modo Exec.','Modo Exec.',; 							 									//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Modo de execucao.','Modo de execucao.','Modo de execucao.',;									//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                         										 				//Picture
					'Pertence("JU")',;                                   												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'J=Job;U=Usuario','J=Job;U=Usuario','J=Job;U=Usuario',;											//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_MODO', 'Modo em que foi executada a rotina para processar os eventos.'})

	AAdd(aSX3,  {'PAP',NIL,'PAP_OBS','C',250,0,;                  													//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Observacao','Observacao','Observacao',; 							 									//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Observacao','Observacao','Observacao',;																//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                         										 				//Picture
					'',;					                                   												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;	                                               												//VldUser
					'','','',;																										//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'PAP_OBS', 'Registro de alguma observação relevante.'})
		
	AAdd(aSIX,{"PAP","1","PAP_FILIAL+DTOS(PAP_DTMOV)+PAP_HRMOV"  ,"Data + Hora do movimento"    ,"Data + Hora do movimento"    ,"Data + Hora do movimento"    ,"U","S"})
	AAdd(aSIX,{"PAP","2","PAP_FILIAL+DTOS(PAP_DTPROC)+PAP_HRPROC","Data + Hora do processamento","Data + Hora do processamento","Data + Hora do processamento","U","S"})
	AAdd(aSIX,{"PAP","3","PAP_FILIAL+PAP_CONTRA+PAP_REVISA"      ,"Contarto + Revisao"          ,"Contarto + Revisao"          ,"Contarto + Revisao"          ,"U","S"})
		
	AAdd(aSX3,  {'CNB',NIL,'CNB_RENOVA','C',1,0,;                  												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Renovacao?','Renovacao?','Renovacao?',; 								 								//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Renovacao?','Renovacao?','Renovacao?',;																//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',; 					                                        					 				//Picture
					'',;					                                   												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'"2"',;                                              												//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'Vazio().OR.Pertence("12")',;	                       												//VldUser
					'1=Sim;2=Nao','1=Sim;2=Nao','1=Sim;2=Nao',;															//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CNB_RENOVA', 'Renovação do produto? 1=Sim;2=Não.'})
	
	AAdd(aSX3,  {'CNB',NIL,'CNB_VLSOFT','N',12,2,;                  											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Vl.Software','Vl.Software','Vl.Software',; 								 							//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Valor de software','Valor de software','Valor de software',;									//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@E 999,999,999.99',; 					                                    	 				//Picture
					'',;					                                   												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                              													//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'Positivo()',;	                       																	//VldUser
					'',;																												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CNB_VLSOFT', 'Valor de software.'})

	AAdd(aSX3,  {'CNB',NIL,'CNB_VLHARD','N',12,2,;                  											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Vl.Hardware','Vl.Hardware','Vl.Hardware',; 								 							//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Valor de hardware','Valor de hardware','Valor de hardware',;									//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@E 999,999,999.99',; 					                                    	 				//Picture
					'',;					                                   												//Valid
					X3_EMUSO_USADO,;                                     												//Usado
					'',;                                              													//Relacao
					'',1,X3_USADO_RESERV,'','',;                         												//F3,Nivel,Reserv,Check,Trigger
					'U','S','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'Positivo()',;	                       																	//VldUser
					'',;																												//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'','','','','',;                                     												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CNB_VLHARD', 'Valor de hardware.'})

	AAdd(aSX3,  {'CN9',NIL,'CN9_RECORR','C',1,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Recorrencia','Recorrencia','Recorrencia',;	    													//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Recorrencia do contrato','Recorrencia do contrato','Recorrencia do contrato',;			//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                  													//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;  				           												//F3,Nivel,Reserv,Check,Trigger
					'U','N','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'Vazio().OR.Pertence("123")',;                       												//VldUser
					'1=Fixo;2=Variável;3=Ambos','1=Fixo;2=Variável;3=Ambos','1=Fixo;2=Variável;3=Ambos',;	//Box Port.,Box Esp.,Box Ing.
					'','','','','1',;                                   												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_RECORR', 'Campo informativo para determinar como será a recorrência do contrato.'})

	AAdd(aSX3,  {'CN9',NIL,'CN9_TPRENO','C',1,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Tp.Renovacao','Tp.Renovacao','Tp.Renovacao',;    													//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Tipo de Renovacao','Tipo de Renovacao','Tipo de Renovacao',;					 				//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                                	  												//Usado
					'',;                                                 												//Relacao
					'',1,X3_USADO_RESERV,'','',;				              												//F3,Nivel,Reserv,Check,Trigger
					'U','N','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'Vazio().OR.Pertence("123")',;                       												//VldUser
					'1=Aditivo/Proposta;2=Automatico;3=Indeterminado','1=Aditivo/Proposta;2=Automatico;3=Indeterminado','1=Aditivo/Proposta;2=Automatico;3=Indeterminado',; //Box Port.,Box Esp.,Box Ing.
					'','','','','1',;                                    												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_TPRENO', 'Campo informativo para determinar se o tipo de renovação do contrato será por aditivo ou automático.'})
	
	AAdd(aSX3,  {'CN9',NIL,'CN9_GRPAPR','C',71,0,;                     											//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Grupo Aprov.','Grupo Aprov.','Grupo Aprov.',;    													//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Grupo de aprov.do contrat','Grupo de aprov.do contrat','Grupo de aprov.do contrat',;	//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                               	   												//Usado
					'',;                                                 												//Relacao
					'A650AL',1,X3_USADO_RESERV,'','',;			           												//F3,Nivel,Reserv,Check,Trigger
					'U','N','','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'Vazio() .OR. U_A650VGAp()',;		  																		//VldUser
					'','','',;																										//Box Port.,Box Esp.,Box Ing.
					'','','','','1',;                                   												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_GRPAPR', 'Grupo de aprovação para tornar o contrato vigente.'})

	AAdd(aSX3,  {'CN9',NIL,'CN9_OKAY','C',1,0,;                     												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Aprovado?','Aprovado?','Aprovado?',;    																//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Contrato aprovado?','Contrato aprovado?','Contrato aprovado?',;								//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                               	   												//Usado
					'"1"',;                                              												//Relacao
					'',1,X3_USADO_RESERV,'','',;					           												//F3,Nivel,Reserv,Check,Trigger
					'U','S','V','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'Pertence("0123")',;					  																		//VldUser
					'0=Legado;1=Em aprovacao;2=Aprovado;3=Rejeitado','0=Legado;1=Em aprovacao;2=Aprovado;3=Rejeitado','0=Legado;1=Em aprovacao;2=Aprovado;3=Rejeitado',;//Box Port.,Box Esp.,Box Ing.
					'','','','','01',;                                   												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_OKAY', 'Controle de aprovação do contrato por workflow/sistema.'})

	AAdd(aSX3,  {'CN9',NIL,'CN9_NOTVEN','M',10,0,;                  												//Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'Notif.Vencto','Notif.Vencto','Notif.Vencto',;    													//Tit. Port.,Tit.Esp.,Tit.Ing.
					'Notificacao vencimentos','Notificacao vencimentos','Notificacao vencimentos',;			//Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;                                               												//Picture
					'',;                                                 												//Valid
					X3_EMUSO_USADO,;                               	   												//Usado
					'',;	                                              												//Relacao
					'',1,X3_USADO_RESERV,'','',;					           												//F3,Nivel,Reserv,Check,Trigger
					'U','N','A','R',' ',;                                												//Propri,Browse,Visual,Context,Obrigat
					'',;										  																		//VldUser
					'','','',;																										//Box Port.,Box Esp.,Box Ing.
					'','','','','',;                                   												//PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})                                          												//Pyme,CondSQL,ChkSQL
	AAdd(aHelp,{'CN9_NOTVEN', 'Usuários que receberão e-mail de notificação de término, vencimento e vencimento periódico de contratos.'})

	AAdd( aSXB, { 'A650AL', '1', '01', 'RE', 'Grupo Aprovacao' , 'Grupo Aprovacao' , 'Grupo Aprovacao', 'SX5'           } )
	AAdd( aSXB, { 'A650AL', '2', '01', '01', ''                , ''                , ''                , '.T.'          } )
	AAdd( aSXB, { 'A650AL', '5', '01', ''  , ''                , ''                , ''                , 'U_A650GrApr()'} )	
Return

//-----------------------------------------------------------------------
// Rotina | A650Plan  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina que envia e-mail sobre geração de Planilha  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A650Plan( aCABEC, aITEM )
	Local oHTML
	Local cBody      := ''
	Local cEmail     := ''
	Local cTemplate  := ''
	Local cFileHTML  := ''
	Local cDescCTR   := ''
	Local cCONTRA    := ''
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local nVlrTotal  := 0
	Local nL	:=1
	Local lServerTst := .F.
	Local cAssunto	 := ''
	
	A650Param()
	
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" ) + 'Contratos - Inclusão de planilha: '
	
	CN9->( dbSetOrder(1) )
	CN9->( dbSeek( XFILIAL("CN9") + aCABEC[2] + aCABEC[3] ) )
	cDescCTR := rTrim( CN9->CN9_DESCRI )
	
	cEmail := U_GCT40USR( '3=', 'X=3', CN9->CN9_FILIAL, CN9->CN9_NUMERO, CN9->CN9_REVISA )
	IF Empty( cEmail )
		Return
	EndIF
	
	cCONTRA := aCABEC[1] + '-' + aCABEC[2]
	
	cTemplate := cMV_650DIR + cMV_650PLAN
	cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'	
		
	cMV_FKMAIL := GetMv( cMV_FKMAIL )
	
	oHTML := TWFHtml():New( cTemplate )
	
	oHTML:ValByName( 'cCN9_NUMERO'   , cCONTRA   ) 
	oHTML:ValByName( 'cCN9_REVISAO'  , IIF( Empty(aCABEC[3]),'Não há', aCABEC[3] ) ) 
	oHTML:ValByName( 'cCN9_DESCRI'   , cDescCTR  ) 
	oHTML:ValByName( 'cCNA_PLAN'     , aCABEC[4] ) 
	oHTML:ValByName( 'cCNA_DESCRI'   , aCABEC[5] ) 
	oHTML:ValByName( 'cDATA'         , aCABEC[6] ) 
	
	For nL := 1 To Len(aITEM)
	   aAdd(oHTML:ValByName( "a.cITEM"     ) , aITEM[nL,1]        )
	   aAdd(oHTML:ValByName( "a.cPROD"     ) , rTrim(aITEM[nL,4]) )
	   aAdd(oHTML:ValByName( "a.cDESCPROD" ) , rTrim(aITEM[nL,5]) )
	   aAdd(oHTML:ValByName( "a.cQTDE"     ) , LTrim( TransForm( aITEM[nL,7]  , "@E 999,999,999.99" ) ) )
	   aAdd(oHTML:ValByName( "a.cVLUNIT"   ) , LTrim( TransForm( aITEM[nL,8]  , "@E 999,999,999.99" ) ) )
	   aAdd(oHTML:ValByName( "a.cTOTAL"    ) , LTrim( TransForm( aITEM[nL,9]  , "@E 999,999,999.99" ) ) )
	   nVlrTotal += aITEM[nL,9]
	Next i
	
	oHTML:ValByName( "nVlrTotalT"  , LTrim( TransForm( nVlrTotal  , "@E 999,999,999.99" ) ) )
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		If .NOT. Empty( cMV_FKMAIL )
			cEmail := cMV_FKMAIL
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
			         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
			         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
		Endif
		IF .NOT. Empty( cEmail )
			FSSendMail( cEmail, cAssunto + cDescCTR , cBody, /*cAnexo*/ )
			Conout( 'FSSendMail > [A650Plan] | E-mail: ' + cEmail + ' Assunto: Inclusão de planilha' )
		EndIF
		Ferase( cFileHTML )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif	
Return

//-----------------------------------------------------------------------
// Rotina | A650Med  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina que envia e-mail sobre medições 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A650Med( aCABEC, aITEM, lAuto )
	Local oHTML
	Local cBody      := ''
	Local cEmail     := ''
	Local cTemplate  := ''
	Local cFileHTML  := ''
	Local cDescCTR   := ''
	Local cMSG       := ''
	Local cCONTRA    := ''
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local nVlrTotal  := 0
	Local nL 		 := 1	
	Local Trb	 := GetNextAlias()	
	Local lServerTst := .F.
	Local cAssunto	 := ''

	cQuery := " SELECT  CNR_DESCRI, CNR_VALOR, CNR_VALOR "
	cQuery += " FROM  " + RetSQLName("CNR") + " CNR "  
	cQuery += " WHERE D_E_L_E_T_ = ' ' AND " 
	cQuery += " 	  CNR_NUMMED = '"+aCABEC[4]+"' AND "
	cQuery += " 	  CNR_FILIAL = '"+XFILIAL("CNR")+"'"
				
	DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), Trb	, .F., .F.)
	
	DBGOTOP()		
	
	while (Trb)->( !EOF() )
	
		aADD( aITEM, {"", "", (Trb)->CNR_DESCRI, "1.00", (Trb)->CNR_VALOR, (Trb)->CNR_VALOR} )
		
		(Trb)->(dbSkip())
	
	EndDo
	(Trb)->(dbCloseArea())
	
		
	A650Param()
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" ) + 'Contratos - Inclusão de medição: '
	
	CN9->( dbSetOrder(1) )
	CN9->( dbSeek( aCABEC[1] + aCABEC[2] + aCABEC[3] ) )
	cDescCTR := rTrim( CN9->CN9_DESCRI )
	
	cEmail := U_GCT40USR( '2=', 'X=2', aCABEC[1], aCABEC[2], aCABEC[3] )
	IF Empty( cEmail )
		Return
	EndIF
	
	IF lAuto
		cMSG := 'medição automática'
	Else
		cMSG := 'medição'
	EndIF
	
	cTemplate := cMV_650DIR + cMV_650MED
	cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'	
	
	cCONTRA := aCABEC[1] + '-' + aCABEC[2]	
	
	cMV_FKMAIL := GetMv( cMV_FKMAIL )
	
	oHTML := TWFHtml():New( cTemplate )
	
	oHTML:ValByName( 'cCN9_NUMERO' , cCONTRA   ) 
	oHTML:ValByName( 'cCN9_REVISAO', IIF( Empty(aCABEC[3]),'Não há', aCABEC[3] ) ) 
	oHTML:ValByName( 'cCN9_DESCRI' , cDescCTR  ) 
	oHTML:ValByName( 'cCND_NUMMED' , aCABEC[4] ) 
	oHTML:ValByName( 'cCND_COMPET' , aCABEC[5] ) 
	oHTML:ValByName( 'cDATA'       , aCABEC[6] ) 
	oHTML:ValByName( 'cMSG'        , cMSG ) 
	
	For nL := 1 To Len(aITEM)
	   aAdd(oHTML:ValByName( "a.cITEM"     ) , aITEM[nL,1]        )
	   aAdd(oHTML:ValByName( "a.cPROD"     ) , rTrim(aITEM[nL,2]) )
	   aAdd(oHTML:ValByName( "a.cDESCPROD" ) , rTrim(aITEM[nL,3]) )
	   aAdd(oHTML:ValByName( "a.cQTDE"     ) , LTrim( TransForm( aITEM[nL,4]  , "@E 999,999,999.99" ) ) )
	   aAdd(oHTML:ValByName( "a.cVLUNIT"   ) , LTrim( TransForm( aITEM[nL,5]  , "@E 999,999,999.99" ) ) )
	   aAdd(oHTML:ValByName( "a.cTOTAL"    ) , LTrim( TransForm( aITEM[nL,6]  , "@E 999,999,999.99" ) ) )
	   nVlrTotal += aITEM[nL,6]
	Next i
	
	oHTML:ValByName( "nVlrTotalT"  , LTrim( TransForm( nVlrTotal  , "@E 999,999,999.99" ) ) )
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		If .NOT. Empty( cMV_FKMAIL )
			cEmail := cMV_FKMAIL
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
			         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
			         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
		Endif
		IF .NOT. Empty( cEmail )
			FSSendMail( cEmail, cAssunto + cDescCTR , cBody, /*cAnexo*/ )
			Conout( 'FSSendMail > [A650Med] | E-mail: ' + cEmail + ' Assunto: Inclusão de medição' )
		EndIF
		Ferase( cFileHTML )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif	
Return

//-----------------------------------------------------------------------
// Rotina | A650Sit  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina que envia e-mail sobre situação do contrato  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A650Sit( cStatAnt, cStatAtu )
	Local cEspContr     := Iif( Empty( CN9->CN9_CLIENT ), '1', '2' )
	Local cCN9_NUMERO   := CN9->CN9_FILIAL + '-' + CN9->CN9_NUMERO
	Local cCN9_REVISA   := Iif( Empty( CN9->CN9_REVISA ),'NÃO HÁ REVISÃO', CN9->CN9_REVISA )
	Local cCN9_DESCRI   := RTrim( CN9->CN9_DESCRI ) 
	Local cCN9_VIGENCIA := ''
	Local cNomeEnt      := ''
	Local cCN9_DTINIC   := Dtoc( CN9->CN9_DTINIC )
	Local cCN9_DTFIM    := Dtoc( CN9->CN9_DTFIM )
	Local cCN9_CODOBJ   := CN9->CN9_CODOBJ
	Local cTpEntidade   := Iif( cEspContr == '1', 'Fornecedor', 'Cliente' )
	Local cCN9_ENTIDADE := ''
	//Local cCN9_ST_ANT := cStatAnt
	//Local cCN9_ST_ATU := cStatAtu
	Local aEntidade     := {}
	Local aCN9_UNVIGE   := {}
	Local oHTML
	Local cBody      := ''
	Local cEmail     := ''
	Local cTemplate  := ''
	Local cFileHTML  := ''
	//Local cDescCTR := ''
	Local cMSG       := ''
	Local cMOTIVO    := Alltrim(CN9->CN9_MOTCAN)
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local lServerTst := .F.
	Local cAssunto	 := ''
	Local mObjeto    := ""
	
	A650Param()
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" ) + 'Contratos - Alteração de situação - '
	
	cEmail := U_GCT40USR( '6=', 'X=6', CN9->CN9_FILIAL, CN9->CN9_NUMERO, CN9->CN9_REVISA )
	IF Empty( cEmail )
		Return
	EndIF
	
	aCN9_UNVIGE := StrToKarr( Posicione( 'SX3', 2, 'CN9_UNVIGE', 'X3CBox()' ), ';' )
	cCN9_VIGENCIA := LTrim( Str( CN9->CN9_VIGE, 6, 0 ) ) + ' ' + RTrim( SubStr( aCN9_UNVIGE[ Val( CN9->CN9_UNVIGE ) ], 3 ) )
	
	If cEspContr == '1'
		CNC->( dbSetOrder( 1 ) )
		CNC->( dbSeek( xFilial( 'CNC' ) + CN9->( CN9_NUMERO + CN9_REVISA ) ) )
		While CNC->( .NOT. EOF() ) .AND. CNC->CNC_NUMERO == CN9->CN9_NUMERO .AND. CNC->CNC_REVISA == CN9->CN9_REVISA
			aEntidade := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_CGC', 'A2_NREDUZ' }, xFilial('SA2') + CNC->( CNC_CODIGO + CNC_LOJA ), 1 ) )
			If cNomeEnt == ''
				cNomeEnt := RTrim( aEntidade[ 1 ] ) + ' ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			eNDIF
			If cCN9_ENTIDADE <> ''
				cCN9_ENTIDADE := cCN9_ENTIDADE
			Endif
			cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			CNC->( dbSkip() )
		End
		If Empty( cCN9_ENTIDADE )
			cCN9_ENTIDADE := 'Contrato sem fornecedor informado.'
			cNomeEnt := 'Sem fornecedor.'
		Endif
		cMSG += 'a) Para visualizar o contrato, acesse o banco de conhecimento.'
	Else
		aEntidade := SA1->( GetAdvFVal( 'SA1', { 'A1_NOME', 'A1_CGC', 'A1_NREDUZ' }, xFilial('SA1') + CN9->( CN9_CLIENT + CN9_LOJACL ), 1 ) )
		cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
		cNomeEnt := RTrim( aEntidade[ 1 ] ) + ' ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
		cMSG += 'a) Para visualizar o contrato, acesse o banco de conhecimento.'
	Endif
	
	IF cStatAtu == 'Cancelado' .OR. cStatAtu == 'Sol.Finalização' .OR. cStatAtu == 'Finalizado'
		cTemplate := cMV_650DIR + cMV_650CAN
	Else
		cTemplate := cMV_650DIR + cMV_650SIT
	EndIF
	cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'	
		
	cMV_FKMAIL := GetMv( cMV_FKMAIL )

	mObjeto := RetOBjSYP(cCN9_CODOBJ)
	
	oHTML := TWFHtml():New( cTemplate )
	
	oHTML:ValByName( 'cCN9_NUMERO'  , cCN9_NUMERO   ) 
	oHTML:ValByName( 'cCN9_REVISA'  , cCN9_REVISA   ) 
	oHTML:ValByName( 'cCN9_DESCRI'  , cCN9_DESCRI   ) 
	oHTML:ValByName( 'cCN9_VIGENCIA', cCN9_VIGENCIA ) 
	oHTML:ValByName( 'cCN9_DTINIC'  , cCN9_DTINIC   ) 
	oHTML:ValByName( 'cCN9_DTFIM'   , cCN9_DTFIM    ) 
	oHTML:ValByName( 'cTpEntidade'  , cTpEntidade   ) 
	oHTML:ValByName( 'cCN9_ENTIDADE', cCN9_ENTIDADE ) 
	oHTML:ValByName( 'cCN9_ST_ANT'  , cStatAnt      ) 
	oHTML:ValByName( 'cCN9_ST_ATU'  , cStatAtu      ) 
	oHTML:ValByName( 'cMSG'         , cMSG          )
	oHTML:ValByName( 'cCN9_OBJETO'  , mObjeto       )
	
	If oHTML:ExistField( 1, 'cCN9_MOTIVO')
		oHTML:ValByName( 'cCN9_MOTIVO'  , cMOTIVO )
	Endif 
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		If .NOT. Empty( cMV_FKMAIL )
			cEmail := cMV_FKMAIL
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
			         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
			         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
		Endif
		IF .NOT. Empty( cEmail )
			FSSendMail( cEmail, cAssunto + Alltrim(cCN9_DESCRI), cBody, /*cAnexo*/ )
			Conout( 'FSSendMail > [A650Sit] | E-mail: ' + cEmail + ' Assunto: Alteração de situação: '+alltrim(cCN9_DESCRI) )
		EndIF
		Ferase( cFileHTML )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif	
Return

//-----------------------------------------------------------------------
// Rotina | A650Rev  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina que envia e-mail sobre revisão de contratos.  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A650Rev( aDADOS )
	Local cEspContr     := Iif( Empty( CN9->CN9_CLIENT ), '1', '2' )
	Local cCN9_NUMERO   := CN9->CN9_FILIAL + '-' + CN9->CN9_NUMERO
	Local cCN9_REVISA	:= CN9->CN9_REVISA
	Local cCN9_CODOBJ	:= CN9->CN9_CODOBJ
	Local cCN9_DESCRI   := RTrim( CN9->CN9_DESCRI )
	Local cCN9_VIGENCIA := ''
	Local cNomeEnt      := ''
	Local cCN9_DTINIC   := Dtoc( CN9->CN9_DTINIC )
	Local cCN9_DTFIM    := Dtoc( CN9->CN9_DTFIM )
	Local cTpEntidade   := Iif( cEspContr == '1', 'Fornecedor', 'Cliente' )
	Local cCN9_ENTIDADE := ''
	Local cDESCREV      := ''
	Local aEntidade     := {}
	Local aCN9_UNVIGE   := {}
	Local oHTML
	Local cBody      := ''
	Local cEmail     := ''
	Local cTemplate  := ''
	Local cFileHTML  := ''
	//Local cDescCTR   := ''
	//Local cMSG       := ''
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local lServerTst := .F.
	Local cAssunto	 := ''
	
	A650Param()
	
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" ) + 'Contratos - Revisão: '
	
	cEmail := U_GCT40USR( '5=', 'X=5', CN9->CN9_FILIAL, CN9->CN9_NUMERO, CN9->CN9_REVISA )
	IF Empty( cEmail )
		Return
	EndIF
	
	aCN9_UNVIGE := StrToKarr( Posicione( 'SX3', 2, 'CN9_UNVIGE', 'X3CBox()' ), ';' )
	cCN9_VIGENCIA := LTrim( Str( CN9->CN9_VIGE, 6, 0 ) ) + ' ' + RTrim( SubStr( aCN9_UNVIGE[ Val( CN9->CN9_UNVIGE ) ], 3 ) )
	
	CN0->( dbSetOrder(1) )
	CN0->( dbSeek( xFilial('CN9') + aDADOS[1] ) )
	cDESCREV := rTrim( CN0->CN0_DESCRI )
	
	If cEspContr == '1'
		CNC->( dbSetOrder( 1 ) )
		CNC->( dbSeek( xFilial( 'CNC' ) + CN9->( CN9_NUMERO + CN9_REVISA ) ) )
		While CNC->( .NOT. EOF() ) .AND. CNC->CNC_NUMERO == CN9->CN9_NUMERO .AND. CNC->CNC_REVISA == CN9->CN9_REVISA
			aEntidade := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_CGC', 'A2_NREDUZ' }, xFilial('SA2') + CNC->( CNC_CODIGO + CNC_LOJA ), 1 ) )
			If cNomeEnt == ''
				cNomeEnt := RTrim( aEntidade[ 1 ] ) + ' ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			eNDIF
			If cCN9_ENTIDADE <> ''
				cCN9_ENTIDADE := cCN9_ENTIDADE
			Endif
			cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			CNC->( dbSkip() )
		End
		If Empty( cCN9_ENTIDADE )
			cCN9_ENTIDADE := 'Contrato sem fornecedor informado.'
			cNomeEnt := 'Sem fornecedor.'
		Endif
	Else
		aEntidade := SA1->( GetAdvFVal( 'SA1', { 'A1_NOME', 'A1_CGC', 'A1_NREDUZ' }, xFilial('SA1') + CN9->( CN9_CLIENT + CN9_LOJACL ), 1 ) )
		cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
		cNomeEnt := RTrim( aEntidade[ 1 ] ) + ' ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
	Endif
	
	cTemplate := cMV_650DIR + cMV_650REV
	cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'	
		
	cMV_FKMAIL := GetMv( cMV_FKMAIL )

	mObjeto := RetOBjSYP(cCN9_CODOBJ)
	        
	oHTML := TWFHtml():New( cTemplate )
	
	oHTML:ValByName( 'cCN9_NUMERO'  , cCN9_NUMERO   ) 
	oHTML:ValByName( 'cCN9_REVISA'  , cCN9_REVISA   ) 
	oHTML:ValByName( 'cCN9_DESCRI'  , cCN9_DESCRI   ) 
	oHTML:ValByName( 'cCN9_VIGENCIA', cCN9_VIGENCIA ) 
	oHTML:ValByName( 'cCN9_DTINIC'  , cCN9_DTINIC   ) 
	oHTML:ValByName( 'cCN9_DTFIM'   , cCN9_DTFIM    ) 
	oHTML:ValByName( 'cTpEntidade'  , cTpEntidade   ) 
	oHTML:ValByName( 'cCN9_ENTIDADE', cCN9_ENTIDADE ) 
	oHTML:ValByName( 'cTIPOREV'     , cDESCREV      ) 
	oHTML:ValByName( 'cJUSTIFIC'    , aDADOS[2]     ) 
	oHTML:ValByName( 'cCN9_OBJETO'  , mObjeto       )  
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		If .NOT. Empty( cMV_FKMAIL )
			cEmail := cMV_FKMAIL
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
			         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
			         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
		Endif
		IF .NOT. Empty( cEmail )
			FSSendMail( cEmail, cAssunto + cCN9_DESCRI, cBody, /*cAnexo*/ )
			Conout( 'FSSendMail > [A650Rev] | E-mail: ' + cEmail + ' Assunto: Revisão' )
		EndIF
		Ferase( cFileHTML )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A650Reaj  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina via JOB para notificar reajuste de contrato.  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A650Reaj( aParam )
	Local cEmp    := ''
	Local cFil    := ''
	Local cMV_650PROC := 'MV_650PROC'
	
	cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] )
	cFil := Iif( aParam == NIL, '02', aParam[ 2 ] )
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES "CN9"
		IF GetMv( cMV_650PROC, .F. ) == '1' //Parâmetro habilitado para envio de e-mail
			A650Exec(cFil)
		EndIF
	RESET ENVIRONMENT
Return

//-----------------------------------------------------------------------
// Rotina | A650Exec  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Processa o JOB A650Reaj 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A650Exec(cXFilial)
	Local cSQL  := ''
	Local cTRB  := ''
	Local nL    := 0
	Local nDias := GetNewPar( "MV_650DIAS", 0 )//Parametro que armazena a quantidade de dias de busca
	Local dDate := MsDate() - nDias
	Local dData := CTOD('  /  /  ')
	Local dDtRj := CTOD('  /  /  ')
	Local aTRB  := {}
	Local cMV_650DiaR := 'MV_650DIAR'
	Local c650Dias := GetMv( cMV_650DiaR, .F. )
	Local aDIAS := StrToKArr( GetMv( cMV_650DiaR, .F. ), ";" )
	Local cDias := ''
	
	cSQL += "SELECT cn9_filial, " + CRLF
	cSQL += "       cn9_numero, " + CRLF
	cSQL += "       cn9_revisa, " + CRLF
	cSQL += "       cn9_descri, " + CRLF
	cSQL += "       cn9_dtinic, " + CRLF
	cSQL += "       cn9_dtfim, " + CRLF
	cSQL += "       cn9_dtaniv, " + CRLF
	cSQL += "       cn9_tpcto, " + CRLF
	cSQL += "       CN9_CLIENT, " + CRLF
	cSQL += "       CN9_LOJACL, " + CRLF
	cSQL += "       CN9_VIGE, " + CRLF
	cSQL += "       CN9_UNVIGE, " + CRLF
	cSQL += "       CN9_CODOBJ, " + CRLF
	cSQL += "       cn1_espctr " + CRLF
	cSQL += "FROM   "+ RetSqlName("CN9") + " CN9 " + CRLF
	cSQL += "       INNER JOIN "+ RetSqlName("CN1") + " CN1 " + CRLF
	cSQL += "               ON cn1_filial = cn9_filial " + CRLF
	cSQL += "                  AND cn1_codigo = cn9_tpcto " + CRLF
	cSQL += "                  AND CN1.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "WHERE  " + CRLF
	cSQL += "       cn9_situac = '05' " + CRLF
	cSQL += "       AND CN9_FLGREJ = '1' " + CRLF
	cSQL += "       AND cn9_revatu = '   ' " + CRLF
	cSQL += "       AND CN9.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "       AND TO_DATE(cn9_dtfim,'YYYYMMDD') >= TO_DATE(" + ValToSql(Dtos(dDate)) +",'YYYYMMDD' )" + CRLF
	cSQL += " 		AND MONTHS_BETWEEN( TO_DATE(cn9_dtfim,'YYYYMMDD'), TO_DATE(CN9_DTINIC,'YYYYMMDD') ) >= 12 "
	cSQL += "ORDER BY CN9_FILIAL, CN9_NUMERO " + CRLF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSQL ), cTRB, .F., .T. )
		
	TcSetField( cTRB, "CN9_DTINIC", "D", 8 )
	TcSetField( cTRB, "CN9_DTFIM" , "D", 8 )
	TcSetField( cTRB, "CN9_DTANIV", "D", 8 )
	
	While .NOT. (cTRB)->( EOF() )
		IF Empty( (cTRB)->CN9_DTANIV )
			For nL := 1 To Len( aDIAS )
				dData := (cTRB)->CN9_DTFIM - Val( aDIAS[nL] )
				dDtRj := StoD( lTrim(STR(Year(dDate))) + Right( dToS( (cTRB)->CN9_DTFIM ),4 ) )
				IF dDtRj < MsDate()
					dDtRj := YearSum(dDtRj,1)
				EndIF
				
				IF Right( dToS( dData ),4 ) == Right( dToS( dDate ),4 ) 
					aADD( aTRB, { (cTRB)->cn9_filial, (cTRB)->cn9_numero, (cTRB)->cn9_revisa, rTrim( (cTRB)->cn9_descri ), (cTRB)->cn1_espctr,;
						(cTRB)->(CN9_CLIENT+CN9_LOJACL), (cTRB)->CN9_VIGE, (cTRB)->CN9_UNVIGE, (cTRB)->CN9_DTINIC, (cTRB)->CN9_DTFIM, dDtRj, aDIAS[nL], (cTRB)->CN9_CODOBJ } )
				EndIF
			Next nL
		Else
			cDias := cValToChar( DateDiffDay( MsDate(), (cTRB)->CN9_DTANIV ) )
			IF ( c650Dias $ cDias )
				aADD( aTRB, { (cTRB)->cn9_filial, (cTRB)->cn9_numero, (cTRB)->cn9_revisa, rTrim( (cTRB)->cn9_descri ), (cTRB)->cn1_espctr,;
					(cTRB)->(CN9_CLIENT+CN9_LOJACL), (cTRB)->CN9_VIGE, (cTRB)->CN9_UNVIGE, (cTRB)->CN9_DTINIC, (cTRB)->CN9_DTFIM, dDtRj, cDias, (cTRB)->CN9_CODOBJ } )
			EndIF
		EndIF
		(cTRB)->( dbSkip() )	
	End
	
	IF Len( aTRB ) > 0
		A650Param()
		A650SendReaj( aTRB )
	EndIF	
	
Return

//-----------------------------------------------------------------------
// Rotina | A650SendReaj  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Envia a notificação para contratos sobre o reajuste  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A650SendReaj( aDADOS )
	Local cEspContr     := ''
	Local cCN9_REVISA   := ''
	Local cCN9_VIGENCIA := ''
	Local cNomeEnt      := ''
	Local cCN9_DTINIC   := ''
	Local cCN9_DTFIM    := ''
	Local cCN9_CODOBJ   := ''
	Local cDTREAJUSTE   := ''
	Local cTpEntidade   := ''
	Local cCN9_ENTIDADE := ''
	Local cBody         := ''
	Local cEmail        := ''
	Local cTemplate     := ''
	Local cFileHTML     := ''
	Local cMSG          := ''
	Local cCONTRA       := ''
	Local nL := 0 
	Local aEntidade     := {}
	Local aCN9_UNVIGE   := {}
	Local oHTML
	
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local lServerTst := GetServerIP() $ cMV_IPSRV
	Local cAssunto	 := IIF( lServerTst, "[TESTE] ", "" ) + 'Notificação reajuste: '

	Local mObjeto := ""
	
	cMV_FKMAIL := GetMv( cMV_FKMAIL, .F. )
	
	For nL := 1 To Len( aDADOS )
		cEmail := U_GCT40USR( '4=', 'X=4', aDADOS[nL,1], aDADOS[nL,2], aDADOS[nL,3]  )
		
		IF Empty( cEmail )
			Loop
		EndIF
		
		cCN9_REVISA := Iif( Empty( aDADOS[nL,3] ),'NÃO HÁ REVISÃO', aDADOS[nL,3] )
		cCN9_DTINIC := Dtoc( aDADOS[nL,09] )
		cCN9_DTFIM  := Dtoc( aDADOS[nL,10] )
		cDTREAJUSTE := Dtoc( aDADOS[nL,11] )
		cCN9_CODOBJ := aDADOS[nL,13]
		
		aCN9_UNVIGE := StrToKarr( Posicione( 'SX3', 2, 'CN9_UNVIGE', 'X3CBox()' ), ';' )
		cCN9_VIGENCIA := LTrim( Str( aDADOS[nL,7], 6, 0 ) ) + ' ' + RTrim( SubStr( aCN9_UNVIGE[ Val( aDADOS[nL,8] ) ], 3 ) )
		
		cEspContr   := Iif( Empty( aDADOS[nL,6] ), '1', '2' )
		cTpEntidade := Iif( cEspContr == '1', 'Fornecedor', 'Cliente' )
		
		IF aDADOS[nL,12] == '0'
			cMSG := 'É necessário o reajuste do contrato na data em questão. Procure a área de '
		Else
			cMSG := 'Em ' + aDADOS[nL,12] + ' dias ocorrerá o reajuste do contrato em questão. Procure a área de '
		EndIF
		
		If cEspContr == '1'
			CNC->( dbSetOrder( 1 ) )
			CNC->( dbSeek( aDADOS[nL,1] + aDADOS[nL,2] + aDADOS[nL,3] ) )
			While CNC->( .NOT. EOF() ) .AND. CNC->(CNC_FILIAL + CNC_NUMERO + CNC_REVISAO) == aDADOS[nL,1] + aDADOS[nL,2] + aDADOS[nL,3]
				aEntidade := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_CGC', 'A2_NREDUZ' }, xFilial('SA2') + CNC->( CNC_CODIGO + CNC_LOJA ), 1 ) )
				If cNomeEnt == ''
					cNomeEnt := RTrim( aEntidade[ 1 ] ) + ' ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
				eNDIF
				If cCN9_ENTIDADE <> ''
					cCN9_ENTIDADE := cCN9_ENTIDADE
				Endif
				cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
				CNC->( dbSkip() )
			End
			If Empty( cCN9_ENTIDADE )
				cCN9_ENTIDADE := 'Contrato sem fornecedor informado.'
				cNomeEnt := 'Sem fornecedor.'
			Endif
			cMSG += 'compras para iniciar o processo de negociação.'
		Else
			aEntidade := SA1->( GetAdvFVal( 'SA1', { 'A1_NOME', 'A1_CGC', 'A1_NREDUZ' }, xFilial('SA1') + aDADOS[nL,6], 1 ) )
			cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			cNomeEnt := RTrim( aEntidade[ 1 ] ) + ' ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			cMSG += 'suporte a vendas (SAV) para iniciar o processo de negociação.'
		Endif
		
		cCONTRA := aDADOS[nL,1] + '-' + aDADOS[nL,2]

		mObjeto := RetOBjSYP(cCN9_CODOBJ)

		cTemplate := cMV_650DIR + cMV_650REAJ
		cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'	
		Sleep(500)	
		
		oHTML := TWFHtml():New( cTemplate )
		
		oHTML:ValByName( 'cCN9_NUMERO'  , cCONTRA       )
		oHTML:ValByName( 'cCN9_REVISA'  , cCN9_REVISA   )
		oHTML:ValByName( 'cCN9_DESCRI'  , aDADOS[nL,4]  )
		oHTML:ValByName( 'cCN9_VIGENCIA', cCN9_VIGENCIA )
		oHTML:ValByName( 'cCN9_DTINIC'  , cCN9_DTINIC   )
		oHTML:ValByName( 'cCN9_DTFIM'   , cCN9_DTFIM    )
		oHTML:ValByName( 'cTpEntidade'  , cTpEntidade   )
		oHTML:ValByName( 'cCN9_ENTIDADE', cCN9_ENTIDADE )
		oHTML:ValByName( 'cMSG'         , cMSG          )
		oHTML:ValByName( 'cDIAS'        , aDADOS[nL,12] )
		oHTML:ValByName( 'cDTREAJUSTE'  , cDTREAJUSTE   )
		oHTML:ValByName( 'cCN9_OBJETO'  , mObjeto       )
		
		oHTML:SaveFile( cFileHTML )
		Sleep(500)
		
		If File( cFileHTML )
			cBody := ''
			FT_FUSE( cFileHTML )
			FT_FGOTOP()
			While .NOT. FT_FEOF()
				cBody += FT_FREADLN()
				FT_FSKIP()
			End
			FT_FUSE()
			
			IF .NOT. Empty( cMV_FKMAIL )
				cEmail := cMV_FKMAIL
				MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
				         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
				         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
				         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
			Endif
			IF .NOT. Empty( cEmail )
				FSSendMail( cEmail, cAssunto + alltrim(aDADOS[nL,4]), cBody, /*cAnexo*/ )
				Conout( 'FSSendMail > [A650Reaj] | E-mail: ' + cEmail + ' Assunto: Contrato [' + cCONTRA + '] - Notificação reajuste' )
			EndIF
			Ferase( cFileHTML )
		Else
			ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
		Endif
	Next nL
Return

//-----------------------------------------------------------------------
// Rotina | A650SCau  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina que envia e-mail sobre solicitação de caução 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A650SCau()
	Local cEspContr     := Iif( Empty( CN9->CN9_CLIENT ), '1', '2' )
	Local cCN9_NUMERO   := CN9->CN9_FILIAL + '-' + CN9->CN9_NUMERO
	Local cCN9_REVISA   := Iif( Empty( CN9->CN9_REVISA ),'NÃO HÁ REVISÃO', CN9->CN9_REVISA )
	Local cCN9_DESCRI   := RTrim( CN9->CN9_DESCRI )
	Local cCN9_VIGENCIA := ''
	Local cCN9_DTINIC   := Dtoc( CN9->CN9_DTINIC )
	Local cCN9_DTFIM    := Dtoc( CN9->CN9_DTFIM )
	Local cTpEntidade   := Iif( cEspContr == '1', 'Fornecedor', 'Cliente' )
	Local cCN9_ENTIDADE := ''
	Local cCN9_VALORCTR := LTrim( TransForm( CN9->CN9_VLATU, "@E 999,999,999.99" ) )
	Local cCN9_CAUCAO   := LTrim( TransForm( CN9->CN9_MINCAU, "@E 99999.99" ) )
	Local cCN9_CODOBJ   := CN9->CN9_CODOBJ
	Local aEntidade     := {}
	Local aCN9_UNVIGE   := {}
	Local oHTML
	Local cBody      := ''
	Local cEmail     := ''
	Local cTemplate  := ''
	Local cFileHTML  := ''
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local lServerTst := .F. //GetServerIP() $ cMV_IPSRV
	Local cAssunto	 := ''
	Local mObjeto 	 := ""
	
	A650Param()
	
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" ) + 'Contratos - Solicitação de Caução'
	
	cEmail := cMV_650NCAU
	
	aCN9_UNVIGE := StrToKarr( Posicione( 'SX3', 2, 'CN9_UNVIGE', 'X3CBox()' ), ';' )
	cCN9_VIGENCIA := LTrim( Str( CN9->CN9_VIGE, 6, 0 ) ) + ' ' + RTrim( SubStr( aCN9_UNVIGE[ Val( CN9->CN9_UNVIGE ) ], 3 ) )
	
	If cEspContr == '1'
		CNC->( dbSetOrder( 1 ) )
		CNC->( dbSeek( xFilial( 'CNC' ) + CN9->( CN9_NUMERO + CN9_REVISA ) ) )
		While CNC->( .NOT. EOF() ) .AND. CNC->CNC_NUMERO == CN9->CN9_NUMERO .AND. CNC->CNC_REVISA == CN9->CN9_REVISA
			aEntidade := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_CGC', 'A2_NREDUZ' }, xFilial('SA2') + CNC->( CNC_CODIGO + CNC_LOJA ), 1 ) )
			If cCN9_ENTIDADE <> ''
				cCN9_ENTIDADE := cCN9_ENTIDADE
			Endif
			cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			CNC->( dbSkip() )
		End
		If Empty( cCN9_ENTIDADE )
			cCN9_ENTIDADE := 'Contrato sem fornecedor informado.'
		Endif
	Else
		aEntidade := SA1->( GetAdvFVal( 'SA1', { 'A1_NOME', 'A1_CGC', 'A1_NREDUZ' }, xFilial('SA1') + CN9->( CN9_CLIENT + CN9_LOJACL ), 1 ) )
		cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
	Endif
	
	cTemplate := cMV_650DIR + cMV_650SCAU
	cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'	
		
	cMV_FKMAIL := GetMv( cMV_FKMAIL )

    mObjeto := RetOBjSYP(cCN9_CODOBJ)

	oHTML := TWFHtml():New( cTemplate )
	
	oHTML:ValByName( 'cCN9_NUMERO'  , cCN9_NUMERO   ) 
	oHTML:ValByName( 'cCN9_REVISA'  , cCN9_REVISA   ) 
	oHTML:ValByName( 'cCN9_DESCRI'  , cCN9_DESCRI   ) 
	oHTML:ValByName( 'cCN9_VIGENCIA', cCN9_VIGENCIA ) 
	oHTML:ValByName( 'cCN9_DTINIC'  , cCN9_DTINIC   ) 
	oHTML:ValByName( 'cCN9_DTFIM'   , cCN9_DTFIM    ) 
	oHTML:ValByName( 'cTpEntidade'  , cTpEntidade   ) 
	oHTML:ValByName( 'cCN9_ENTIDADE', cCN9_ENTIDADE ) 
	oHTML:ValByName( 'cVALORCTR'    , cCN9_VALORCTR ) 
	oHTML:ValByName( 'cPercent'     , cCN9_CAUCAO   ) 
	oHTML:ValByName( 'cCN9_OBJETO'  , mObjeto	    ) 
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		If .NOT. Empty( cMV_FKMAIL )
			cEmail := cMV_FKMAIL
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
			         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
			         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
		Endif
		IF .NOT. Empty( cEmail )
			FSSendMail( cEmail, cAssunto, cBody, /*cAnexo*/ )
			Conout( 'FSSendMail > [A650SCau] | E-mail: ' + cEmail + ' Assunto: Solicitação de Caução' )
		EndIF
		Ferase( cFileHTML )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A650CAU  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina que envia e-mail sobre inclusão de caução.  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A650CAU( aDADOS )
	Local cEspContr     := Iif( Empty( CN9->CN9_CLIENT ), '1', '2' )
	Local cCN9_NUMERO   := CN9->CN9_FILIAL + '-' + CN9->CN9_NUMERO
	Local cCN9_REVISA   := Iif( Empty( CN9->CN9_REVISA ),'NÃO HÁ REVISÃO', CN9->CN9_REVISA )
	Local cCN9_DESCRI   := RTrim( CN9->CN9_DESCRI )
	Local cCN9_VIGENCIA := ''
	Local cCN9_DTINIC   := Dtoc( CN9->CN9_DTINIC )
	Local cCN9_DTFIM    := Dtoc( CN9->CN9_DTFIM )
	Local cTpEntidade   := Iif( cEspContr == '1', 'Fornecedor', 'Cliente' )
	Local cCN9_ENTIDADE := ''
	Local cTPCAUCAO     := ''
	Local cNUMCAUCAO    := rTrim( aDADOS[2] )
	Local cVLRCAUCAO    := LTrim( TransForm( aDADOS[3], "@E 999,999,999.99" ) )
	Local cCN9_CODOBJ   := CN9->CN9_CODOBJ
	Local cCN9_OBJETO   := ""
	Local aEntidade     := {}
	Local aCN9_UNVIGE   := {}
	Local oHTML
	Local cBody      := ''
	Local cEmail     := ''
	Local cTemplate  := ''
	Local cFileHTML  := ''
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local lServerTst := .F. //GetServerIP() $ cMV_IPSRV
	Local cAssunto	 := ''
	Local mObjeto    := ''
	
	A650Param()
	
	lServerTst := GetServerIP() $ cMV_IPSRV
	cAssunto   := IIF( lServerTst, "[TESTE] ", "" ) + 'Contratos - Inclusão de caução: '
	
	cEmail := U_GCT40USR( '1=', 'X=1', CN9->CN9_FILIAL, CN9->CN9_NUMERO, CN9->CN9_REVISA )
	IF Empty( cEmail )
		Return
	EndIF
	
	aCN9_UNVIGE := StrToKarr( Posicione( 'SX3', 2, 'CN9_UNVIGE', 'X3CBox()' ), ';' )
	cCN9_VIGENCIA := LTrim( Str( CN9->CN9_VIGE, 6, 0 ) ) + ' ' + RTrim( SubStr( aCN9_UNVIGE[ Val( CN9->CN9_UNVIGE ) ], 3 ) )
	
	cTPCAUCAO := rTrim( Posicione('CN3', 1, xFilial('CN3') + aDADOS[1], 'CN3_DESCRI' ) )
	
	If cEspContr == '1'
		CNC->( dbSetOrder( 1 ) )
		CNC->( dbSeek( xFilial( 'CNC' ) + CN9->( CN9_NUMERO + CN9_REVISA ) ) )
		While CNC->( .NOT. EOF() ) .AND. CNC->CNC_NUMERO == CN9->CN9_NUMERO .AND. CNC->CNC_REVISA == CN9->CN9_REVISA
			aEntidade := SA2->( GetAdvFVal( 'SA2', { 'A2_NOME', 'A2_CGC', 'A2_NREDUZ' }, xFilial('SA2') + CNC->( CNC_CODIGO + CNC_LOJA ), 1 ) )
			If cCN9_ENTIDADE <> ''
				cCN9_ENTIDADE := cCN9_ENTIDADE
			Endif
			cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
			CNC->( dbSkip() )
		End
		If Empty( cCN9_ENTIDADE )
			cCN9_ENTIDADE := 'Contrato sem fornecedor informado.'
		Endif
	Else
		aEntidade := SA1->( GetAdvFVal( 'SA1', { 'A1_NOME', 'A1_CGC', 'A1_NREDUZ' }, xFilial('SA1') + CN9->( CN9_CLIENT + CN9_LOJACL ), 1 ) )
		cCN9_ENTIDADE := RTrim( aEntidade[ 1 ] ) + ' - CNPJ ' + TransForm( aEntidade[ 2 ], '@R 99.999.999/9999-99' )
	Endif
	
	cTemplate := cMV_650DIR + cMV_650CAU
	cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'	
		
	cMV_FKMAIL := GetMv( cMV_FKMAIL )

	mObjeto := RetOBjSYP(cCN9_CODOBJ)
	
	oHTML := TWFHtml():New( cTemplate )
	
	oHTML:ValByName( 'cCN9_NUMERO'  , cCN9_NUMERO   ) 
	oHTML:ValByName( 'cCN9_REVISA'  , cCN9_REVISA   ) 
	oHTML:ValByName( 'cCN9_DESCRI'  , cCN9_DESCRI   ) 
	oHTML:ValByName( 'cCN9_VIGENCIA', cCN9_VIGENCIA ) 
	oHTML:ValByName( 'cCN9_DTINIC'  , cCN9_DTINIC   ) 
	oHTML:ValByName( 'cCN9_DTFIM'   , cCN9_DTFIM    ) 
	oHTML:ValByName( 'cTpEntidade'  , cTpEntidade   ) 
	oHTML:ValByName( 'cCN9_ENTIDADE', cCN9_ENTIDADE ) 
	oHTML:ValByName( 'cTPCAUCAO'    , cTPCAUCAO     ) 
	oHTML:ValByName( 'cNUMCAUCAO'   , cNUMCAUCAO    ) 
	oHTML:ValByName( 'cVLRCAUCAO'   , cVLRCAUCAO    ) 
	oHTML:ValByName( 'cCN9_OBJETO'  , mObjeto       ) 
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		If .NOT. Empty( cMV_FKMAIL )
			cEmail := cMV_FKMAIL
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
			         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
			         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
		Endif
		IF .NOT. Empty( cEmail )
			FSSendMail( cEmail, cAssunto + cCN9_DESCRI, cBody, /*cAnexo*/ )
			Conout( 'FSSendMail > [A650CAU] | E-mail: ' + cEmail + ' Assunto: Inclusão de caução' )
		EndIF
		Ferase( cFileHTML )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif
Return

//---------------------------------------------------------------------------------
// Rotina | A650Aprv  | Autor | Rafael Beghini               | Data | 15.09.2016
//---------------------------------------------------------------------------------
// Descr. | Rotina responsável por apresentar os aprovadores.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
STATIC cA650Aprv := ''

User Function A650Aprv()
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oPanelTop
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Local aOrdem := {}
	Local cOrd := ''
	Local cRet := ''
	//Local cFile := GetTempPath() + 'alllevel.ini'
	Local cSeek := Space(100)
	Local cField := ReadVar()
	Local cReadVar := RTrim(&(ReadVar()))
	Local cCodApr := ''

	Local aDados := {}
	
	Local nI := 0
	Local nL := 0
	Local nOrd := 1

	Local lOk := .F.
	Local lMark := .F.
	Local lNiveis := .F.
	
	//A650Niveis( cFile, @lNiveis, .F. )

	AAdd(aOrdem,'Código do aprovador') 
	AAdd(aOrdem,'Código do usuário')
	AAdd(aOrdem,'Nome do usuário')
	
	cSQL := "SELECT '0' AS MARK,"
	cSQL += "       MIN(AK_COD) AK_COD,"
	cSQL += "       AK_USER,"
	cSQL += "       AK_NOME"
	cSQL += "FROM   "+RetSqlName("SAK")+" SAK "
	cSQL += "WHERE  AK_FILIAL = "+ValToSql(xFilial("SAK"))+" "
	cSQL += "       AND (AK_MSBLQL = ' '" 
	cSQL += "           OR AK_MSBLQL = '2')"
	cSQL += "       AND SAK.D_E_L_E_T_ = ' '"
	cSQL += "GROUP  BY AK_USER, AK_NOME"
	cSQL += "ORDER  BY AK_NOME"
	
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
	Else
	
	Endif
   (cTRB)->( dbCloseArea() )
	
	lMark := .F.
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Escolha o(s) aprovador(es)' PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,19,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
	   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A650PsqGrp(nOrd,cSeek,@oLbx))

		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 40,05 LISTBOX oLbx FIELDS HEADER ;
		' x ','Aprovador','Usuário','Nome aprovador/usuário' ;
		SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(cCodApr := aDados[ oLbx:nAt, 2 ], AEval( aDados, {|e| Iif( cCodApr==e[2],(e[1]:=.NOT.e[1]), NIL )}),oLbx:Refresh())
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray(aDados)
		oLbx:bLine := { || {Iif(aDados[oLbx:nAt,1],oOk,oNo),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3],aDados[oLbx:nAt,4]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aDados, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os aprovadores...') }
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A650VldGrp(aDados,@lOk),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lOk
		For nI := 1 To Len( aDados )
			If aDados[ nI, 1 ] .AND. (.NOT. aDados[ nI, 2 ] $ cRet)
				If (Len(cRet)+7) > 71
					MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>É possível a seleção de no máximo 10 aprovadores.','Grupo de aprovações')
					Exit
				Endif
				cRet += aDados[ nI, 2 ] + '|'
			Endif
		Next nI
		cRet := PadR( SubStr( cRet, 1, Len( cRet )-1 ), Len( CN9->CN9_GRPAPR ), ' ' )
		&(cField) := cRet
		cA650Aprv := cRet
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A650RtAprv    | Autor | Robson Gonçalves              | Data | 10/11/17
//---------------------------------------------------------------------------------
// Descr. | Rotina de retorna da consulta SXB - A650AL.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650RtAprv()
Return(cA650Aprv)

//---------------------------------------------------------------------------------
// Rotina | A650VAprv    | Autor | Robson Gonçalves              | Data | 10/11/17
//---------------------------------------------------------------------------------
// Descr. | Rotina para criticar o código do aprovador.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650VAprv()
	Local nI := 0
	Local aAprv := {}
	Local cAprv := ''
	If .NOT. Empty( M->CN9_GRPAPR )	
		aAprv := StrToKarr( M->CN9_GRPAPR, '|' )
		For nI := 1 To Len( aAprv )
			cAprv := RTrim( aAprv[ nI ] )
			If .NOT. ExistCpo( 'SAK', cAprv, NIL, NIL, .F. )
				MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Não existe aprovador com o código: '+cAprv+'.','Código de aprovador inválido')
				Return( .F. )
			Endif
		Next nI
	Endif
Return( .T. )

//---------------------------------------------------------------------------------
// Rotina | A650UsrApr  | Autor | Rafael Beghini              | Data | 31.01.2018
//---------------------------------------------------------------------------------
// Descr. | Rotina para buscar os usuários para aprovação.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650UsrApr( cCN9_GRPAPR )
	Local cRet := ''
	Local cWhere := ''
	Local cTRB := GetNextAlias()
	Local cSQL := ''	
	Local aGroup := {}
	Local ni	:=1
	
	aGroup := StrToKarr( cCN9_GRPAPR, '|' )
	cWhere := '('
	For nI := 1 To Len( aGroup )
		cWhere += " AK_COD = " + ValToSql( aGroup[ nI ] ) + " OR "
	Next nI
	cWhere := SubStr( cWhere, 1, Len( cWhere )-4 )
	cWhere := cWhere + ')'
	
	cSQL := "SELECT AK_USER "
	cSQL += "FROM   "+RetSqlName("SAK")+" SAK "
	cSQL += "WHERE  AK_FILIAL = "+ValToSql( xFilial( "SAK" ) )+" "
	cSQL += "       AND SAK.D_E_L_E_T_ = ' ' "
	cSQL += "       AND " + cWhere + " "
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGenQry(,,cSQL), cTRB, .T., .T. )
	
	While (cTRB)->( .NOT. EOF() )
		cRet += (cTRB)->AK_USER + '|'
		(cTRB)->( dbSkip() )
	End
	cRet := SubStr( cRet, 1, Len( cRet )-1 )
	(cTRB)->( dbCloseArea() )
Return( cRet )

//-----------------------------------------------------------------------
// Rotina | A650Vcto  | Autor | Rafael Beghini    | Data | 06.03.2018
//-----------------------------------------------------------------------
// Descr. | Rotina via JOB para notificar vencimento de Planilha.  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A650Vcto( aParam )
	Local cEmp    := ''
	Local cFil    := ''
	Local cMV_650PROC := 'MV_650PROC'
	
	cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] )
	cFil := Iif( aParam == NIL, '02', aParam[ 2 ] )
	
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES "CN9"
		IF GetMv( cMV_650PROC, .F. ) == '1' //Parâmetro habilitado para envio de e-mail
			A650ExecVcto()
		EndIF
	RESET ENVIRONMENT
Return

//-----------------------------------------------------------------------
// Rotina | A650ExecVcto  | Autor | Rafael Beghini    | Data | 06.03.2018
//-----------------------------------------------------------------------
// Descr. | Processa o JOB A650Vcto 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A650ExecVcto()
	Local cSQL   := ''
	Local cTRB   := ''
	Local cCHAVE := ''
	Local dDate1 := MsDate() 
	Local dDate2 := MsDate() + 30
	Local aTRB   := {}
	Local aITEM	 := {}
	Local nP	 := 0
	Local nElemP := 0
	
	cSQL += "SELECT CNA_FILIAL," + CRLF
	cSQL += "       CNA_CONTRA," + CRLF
	cSQL += "       CNA_REVISA," + CRLF
	cSQL += "       CN9_DESCRI," + CRLF
	cSQL += "       CNA_NUMERO," + CRLF
	cSQL += "       CNA_DTFIM," + CRLF
	cSQL += "       CASE" + CRLF
	cSQL += "         WHEN CNA_DTFIM = TO_CHAR(SYSDATE, 'YYYYMMDD') THEN 'Vencimento hoje'" + CRLF
	cSQL += "         ELSE 'Vencimento em 30 dias'" + CRLF
	cSQL += "       END              STATUS" + CRLF
	cSQL += "FROM   " + RetSqlName("CNA") + " CNA " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("CN9") + " CN9 " + CRLF
	cSQL += "               ON CN9_FILIAL = CNA_FILIAL" + CRLF
	cSQL += "                  AND CN9_NUMERO = CNA_CONTRA" + CRLF
	cSQL += "                  AND CN9_REVISA = CNA_REVISA" + CRLF
	cSQL += "                  AND CN9_SITUAC = '05'" + CRLF
	cSQL += "                  AND CN9.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "WHERE  CNA.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "       AND ( CNA_DTFIM = " + ValToSql(Dtos(dDate1)) + " " + CRLF
	cSQL += "              OR CNA_DTFIM = " + ValToSql(Dtos(dDate2)) + " )" + CRLF
	cSQL += "ORDER  BY 1," + CRLF
	cSQL += "          2," + CRLF
	cSQL += "          3," + CRLF
	cSQL += "          5  " + CRLF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSQL ), cTRB, .F., .T. )
		
	TcSetField( cTRB, "CNA_DTFIM", "D", 8 )
	
	While .NOT. (cTRB)->( EOF() )
		AAdd( aTRB, { (cTRB)->CNA_FILIAL,;
							(cTRB)->CNA_CONTRA,;
							(cTRB)->CNA_REVISA,;
							Alltrim((cTRB)->CN9_DESCRI),;
							(cTRB)->CNA_NUMERO,;
							(cTRB)->CNA_DTFIM,;
							(cTRB)->STATUS } )
	
		(cTRB)->( dbSkip() )	
	End
	
	IF Len( aTRB ) > 0
		A650Param()
		A650SendVcto( aTRB )
	EndIF	
	
Return

//-----------------------------------------------------------------------
// Rotina | A650SendVcto  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | Envia a notificação para contratos sobre o reajuste  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A650SendVcto( aDADOS )
	Local cBody		:= ''
	Local cEmail	:= cMV_650USER
	Local cTemplate	:= ''
	Local cFileHTML	:= ''
	Local cCONTRA	:= ''
	Local lServerTst := GetServerIP() $ cMV_IPSRV
	Local cAssunto	 := IIF( lServerTst, "[TESTE] ", "" ) + 'Contratos - Vencimento de planilha'
	Local cMV_FKMAIL := 'MV_FKMAIL'
	Local nL := 0
	Local oHTML
	
	cTemplate := cMV_650DIR + cMV_650VCTO
	cFileHTML := cMV_650DIR + CriaTrab( NIL, .F. ) + '.htm'	
			
	cMV_FKMAIL := GetMv( cMV_FKMAIL )
		
	oHTML := TWFHtml():New( cTemplate )
			
	For nL := 1 To Len( aDADOS )
		cCONTRA := aDADOS[nL,1] + '-' + aDADOS[nL,2]	
		aAdd(oHTML:ValByName( "a.cCONTRA" ) , cCONTRA	   )
		aAdd(oHTML:ValByName( "a.cREVISA" ) , IIF( Empty(aDADOS[nL,3]),'Não há', aDADOS[nL,3] ) )
		aAdd(oHTML:ValByName( "a.cNUMERO" ) , aDADOS[nL,5] )
		aAdd(oHTML:ValByName( "a.cVCTO"   ) , cValToChar(aDADOS[nL,6]) )
		aAdd(oHTML:ValByName( "a.cSTATUS" ) , aDADOS[nL,7] )
	Next nL
		
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
		
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		If .NOT. Empty( cMV_FKMAIL )
			cEmail := cMV_FKMAIL
			MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+;
			         '<br><br>PARÂMETRO PARA SUBSTITUIR E-MAIL DOS USUÁRIOS COM ACESSO AO CONTRATO HABILITADO.'+;
			         '<br>UTILIZADO PARA SIMULACAO/TESTE. EMAIL(S): '+cMV_FKMAIL,;
			         'CSFA650 - E-mails de contratos'+' - MV_FKMAIL' )
		Endif
		IF .NOT. Empty( cEmail )
			FSSendMail( cEmail, cAssunto , cBody, /*cAnexo*/ )
			Conout( 'FSSendMail > [A650Vcto] | E-mail: ' + cEmail + cAssunto )
		EndIF
		Ferase( cFileHTML )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif
	
Return				
						
//---------------------------------------------------------------------------------
// Rotina | A650Assi  | Autor | Rafael Beghini               | Data | 19.03.2018
//---------------------------------------------------------------------------------
// Descr. | Rotina responsável por apresentar os assinantes.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
STATIC cA650Assi := ''

User Function A650Assi()
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oPanelTop
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Local aOrdem := {}
	Local cOrd := ''
	Local cRet := ''
	Local cSeek := Space(100)
	Local cField := ReadVar()
	Local cReadVar := RTrim(&(ReadVar()))
	Local cCodApr := ''

	Local aDados := {}
	
	Local nI := 0
	Local nL := 0
	Local nOrd := 1

	Local lOk := .F.
	Local lMark := .F.
	Local lNiveis := .F.
	
	AAdd(aOrdem,'Código do participante') 
	AAdd(aOrdem,'Matrícula do participante')
	AAdd(aOrdem,'Nome do participante')
	
	cSQL := "SELECT '0' AS MARK,"
	cSQL += "       RD0_CODIGO,"
	cSQL += "       RD0_MAT,"
	cSQL += "       RD0_NOME,"
	cSQL += "       RD0_MSBLQL "
	cSQL += "FROM   "+RetSqlName("RD0")+" RD0 "
	cSQL += "WHERE  RD0_FILIAL = "+ValToSql(xFilial("RD0"))+" "
	cSQL += "       AND RD0.D_E_L_E_T_ = ' '"
	cSQL += "ORDER  BY RD0_NOME"
	
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

			IF aDados[ nL, 5 ] == '1'
				aDados[ nL, 5 ] := 'Desligado'
			Else
				aDados[ nL, 5 ] := 'Ativo'
			EndIF

			(cTRB)->( dbSkip() )
		End
	Else
	
	Endif
   (cTRB)->( dbCloseArea() )
	
	lMark := .F.
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Escolha o(s) assinante(s) conforme cadastro de Participantes' PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,19,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
	   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A650PsqGrp(nOrd,cSeek,@oLbx))

		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 40,05 LISTBOX oLbx FIELDS HEADER ;
		' x ','Código','Matrícula','Nome do participante','Situação' ;
		SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(cCodApr := aDados[ oLbx:nAt, 2 ], AEval( aDados, {|e| Iif( cCodApr==e[2],(e[1]:=.NOT.e[1]), NIL )}),oLbx:Refresh())
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray(aDados)
		oLbx:bLine := { || {Iif(aDados[oLbx:nAt,1],oOk,oNo),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3],aDados[oLbx:nAt,4],aDados[oLbx:nAt,5]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aDados, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os participantes...') }
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A650VldAssi(aDados,@lOk),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lOk
		For nI := 1 To Len( aDados )
			If aDados[ nI, 1 ] .AND. (.NOT. aDados[ nI, 2 ] $ cRet)
				/*If (Len(cRet)+7) > 71
					MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>É possível a seleção de no máximo 10 aprovadores.','Grupo de aprovações')
					Exit
				Endif*/
				cRet += aDados[ nI, 2 ] + '|'
			Endif
		Next nI
		cRet := PadR( SubStr( cRet, 1, Len( cRet )-1 ), Len( CN9->CN9_XASSIN ), ' ' )
		&(cField) := cRet
		cA650Assi := cRet
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A650VldAssi | Autor | Rafael Beghini               | Data | 19/03/2018
//---------------------------------------------------------------------------------
// Descr. | Rotina para validar se escolheu algum registro.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650VldAssi( aDados, lOk )
	Local nP := 0
	Local lRet := .T.
	nP := AScan( aDados, {|p| p[ 1 ] } )
	lOk := ( nP > 0 )
	If .NOT. lOk
		lRet := .F.
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Não foi selecionado nenhum assinante.', '[A650VldAssi] - Validação da seleção do assinante' )
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A650RtAssi    | Autor | Rafael Beghini              | Data | 19/03/2018
//---------------------------------------------------------------------------------
// Descr. | Rotina de retorna da consulta SXB - A650AS.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650RtAssi()
Return(cA650Assi)

//---------------------------------------------------------------------------------
// Rotina | A650Area  | Autor | Rafael Beghini               | Data | 19.03.2018
//---------------------------------------------------------------------------------
// Descr. | Rotina responsável por apresentar as areas do contrato
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
STATIC cA650Area := ''

User Function A650Area()
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oPanelTop
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Local aOrdem := {}
	Local cOrd := ''
	Local cRet := ''
	Local cSeek := Space(100)
	Local cField := ReadVar()
	Local cReadVar := RTrim(&(ReadVar()))
	Local cCodApr := ''

	Local aDados := {}
	
	Local nI := 0
	Local nL := 0
	Local nOrd := 1

	Local lOk := .F.
	Local lMark := .F.
	Local lNiveis := .F.
	
	AAdd(aOrdem,'Código da área') 
	AAdd(aOrdem,'Descrição')
	
	cSQL := "SELECT '0' AS MARK,"
	cSQL += "       X5_CHAVE,"
	cSQL += "       X5_DESCRI"
	cSQL += "FROM   "+RetSqlName("SX5")+" SX5 "
	cSQL += "WHERE  X5_FILIAL = '" + xFilial('SX5') + "' "
	cSQL += "       AND X5_TABELA = 'Z5'	"
	cSQL += "       AND SX5.D_E_L_E_T_ = ' '"
	cSQL += "ORDER  BY X5_CHAVE"
	
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
	Else
		MsgAlert('Não foram encontrados registros na tabela SX5 (Z5), verifique.')
		Return(.F.)
	Endif
   (cTRB)->( dbCloseArea() )
	
	lMark := .F.
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,777 TITLE 'Escolha a(s) área(s) do Contrato' PIXEL
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,19,.F.,.T.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
	   @ 1,001 COMBOBOX oOrdem VAR cOrd ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPanelTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPanelTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A650PsqGrp(nOrd,cSeek,@oLbx))

		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

		@ 40,05 LISTBOX oLbx FIELDS HEADER ;
		' x ','Código','Descrição' ;
		SIZE 350, 90 OF oPanelAll PIXEL ON ;
		dblClick(cCodApr := aDados[ oLbx:nAt, 2 ], AEval( aDados, {|e| Iif( cCodApr==e[2],(e[1]:=.NOT.e[1]), NIL )}),oLbx:Refresh())
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray(aDados)
		oLbx:bLine := { || {Iif(aDados[oLbx:nAt,1],oOk,oNo),aDados[oLbx:nAt,2],aDados[oLbx:nAt,3]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aDados, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos as áres...') }
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(A650VldArea(aDados,@lOk),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
	If lOk
		For nI := 1 To Len( aDados )
			If aDados[ nI, 1 ] .AND. (.NOT. aDados[ nI, 2 ] $ cRet)
				If Len(Alltrim(cRet)) > 27
					MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>É possível a seleção de no máximo 04 áreas.','Área Responsável')
					Exit
				Endif
				cRet += aDados[ nI, 2 ] + '|'
			Endif
		Next nI
		cRet := PadR( SubStr( cRet, 1, Len( cRet )-1 ), Len( CN9->CN9_XAREA ), ' ' )
		&(cField) := cRet
		cA650Area := cRet
	Endif
Return(.T.)

//---------------------------------------------------------------------------------
// Rotina | A650VldArea | Autor | Rafael Beghini               | Data | 19/03/2018
//---------------------------------------------------------------------------------
// Descr. | Rotina para validar se escolheu algum registro.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A650VldArea( aDados, lOk )
	Local nP := 0
	Local lRet := .T.
	nP := AScan( aDados, {|p| p[ 1 ] } )
	lOk := ( nP > 0 )
	If .NOT. lOk
		lRet := .F.
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Não foi selecionado nenhuma área.', '[A650VldArea] - Validação da seleção da Área' )
	Endif
Return( lRet )

//---------------------------------------------------------------------------------
// Rotina | A650RtArea    | Autor | Rafael Beghini              | Data | 19/03/2018
//---------------------------------------------------------------------------------
// Descr. | Rotina de retorna da consulta SXB - A650AR.
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A650RtArea()
Return(cA650Area)


Static Function RetOBjSYP(cChave)
Local cRet := ""
Local cSql := ""
Local cTrbSql := GetNextAlias()
//Local cEof  := chr(13)+chr(10)
Local cEof  := "<br>"

cSql := "SELECT YP_TEXTO FROM "+RetSqlName("SYP")+" YP WHERE YP_FILIAL = '"+SYP->(xfilial())+"' AND YP_CHAVE = '"+cChave+"' AND YP_CAMPO = 'CN9_CODOBJ' AND D_E_L_E_T_ = ' ' ORDER BY YP_SEQ"
PLSQuery( cSql, CTrbSql )
while !(cTrbSql)->(Eof())
    cRet += alltrim(replace((cTrbSql)->YP_TEXTO,"\13\10",cEof))
	(cTrbSql)->(dbSkip())
end
(cTrbSql)->(DbCloseArea())

Return cRet
