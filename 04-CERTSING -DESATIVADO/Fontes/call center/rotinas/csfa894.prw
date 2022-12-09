//+------------+---------------+----------------------------------------------------------------------------------+--------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao |
//+------------+---------------+----------------------------------------------------------------------------------+--------+
//| 15/04/2020 | Bruno Nunes   | Retirada a regra de validacao de qual AR pode realizar a consulta na rotina      | 1.00   |
//|            |               | validAut.                                                                     |	       |
//+------------+---------------+----------------------------------------------------------------------------------+--------+
#Include 'Protheus.ch'

User Function arErro( nCode, aRet, cReturn )
	Local aErro := {}
	Local nP := 0
	//[1] - número do erro.
	//[2] - mensagem de erro para devolução e console.
	AAdd( aErro, { 101, 'Nao autenticado. Quantidade de parametros informados invalidos.' } )
	AAdd( aErro, { 102, 'Nao autenticado. Usuario nao localizado na base de dados.' } )
	AAdd( aErro, { 103, 'Nao autenticado. Usuario valiudo, porem bloqueado o seu acesso.' } )
	AAdd( aErro, { 104, 'Nao autenticado. Usuario valido, porem senha incorreta.' } )
	AAdd( aErro, { 105, 'Nao autenticado. Parametros invalidos.' } )
	AAdd( aErro, { 201, 'Requisicao negada. Quantidade de parametros informados invalidos.' } )
	AAdd( aErro, { 202, 'Token expirado (time-out).' } )
	AAdd( aErro, { 203, 'Token invalido.' } )
	AAdd( aErro, { 204, 'Documento CNPJ nao localizado na base de dados.' } )
	AAdd( aErro, { 205, 'Documento CNPJ nao autorizado para esta consulta.' } )
	AAdd( aErro, { 206, 'Documento CNPJ nao corresponde a esta consulta.' } )
	AAdd( aErro, { 207, 'Nao localizado entidade com os dados informados.' } )
	AAdd( aErro, { 208, 'Nao localizado agendas com os dados informados.' } )
	AAdd( aErro, { 209, 'Opcao de consulta do parametro MV_893_01 indisponivel.' } )
	AAdd( aErro, { 210, 'Texto do próprio retorno do consumo do WS-GAR.' } )
	AAdd( aErro, { 211, 'O CNPJ informado nao corresponde a solicitacao requisitada.' } )
	AAdd( aErro, { 212, 'O ID do posto de verificacao/validacao nao localizado com CNPJ informado.' } )
	AAdd( aErro, { 213, 'Nao localizado eventos com os dados informados.' } )
	AAdd( aErro, { 214, 'Pedido nao localizado par essa AR.' } )
	AAdd( aErro, { 215, 'CNPJ invalido para essa AR.' } )
	AAdd( aErro, { 216, 'Lista de posto vazio.' } )

	nP := Ascan( aErro, {|e| e[ 1 ] == nCode } )

	If Len( aRet ) == 0
		aRet := {'',''}
	Endif

	If nP > 0
		aRet[ 1 ] := aErro[ nP, 1 ]
		aRet[ 2 ] := aErro[ nP, 2 ]
		cReturn   := aErro[ nP, 2 ]
	Else
		aRet[ 1 ] := 999
		aRet[ 2 ] := 'Codigo de erro nao previsto.'
		cReturn   := 'Codigo de erro nao previsto.'
	Endif
Return

User Function arValidToken( cToken, aRet, cStack, cReturn, cThread )
	Local aSeed := {8,9,8,9,8,9}

	Local cAgora := ''
	Local cKey1 := ''
	Local cKey2 := ''
	Local cKey3 := ''
	Local cKey4 := ''
	Local cMV_890_01 := 'MV_890_01'
	Local cParam1 := ''

	Local lHoje := .F.
	Local lLogin := .F.
	Local lRet := .T.
	Local lTimeOut := .F.

	Local nAgora := 0
	Local nKey4 := 0
	Local nKey5 := 0
	Local nTamDig := 0

	cStack += 'ARVALIDTOKEN()' + CRLF

	If .NOT. GetMv( cMV_890_01, .T. )
		CriarSX6( cMV_890_01, 'N', 'TIME-OUT DO TOKEN NA INTEGRACAO, VALOR EM DECIMAL 100 = 60 SEGUNDOS. ROTINA CSFA890.PRW', '100' )
	Endif

	// Decodificar o parâmetro recebido.
	cParam1 := Decode64( cToken )

	// Saber o tamanho do digito do resultado.
	nTamDig := Len( LTrim( Str( Date() - Ctod( '01/01/96', 'DDMMYYYY' ) ) ) ) 

	// Avaliar o Time-out.
	cKey2 := SubStr( cParam1, nTamDig+1, 6 )
	AEval( aSeed, { |v,i| cKey4 += LTrim( Str( v - Val( SubStr( cKey2, i, 1 ) ) ) ) } )
	cAgora := StrTran( Time(), ':', '' )

	nAgora := fConvHr( Val( cAgora ), 'D' )
	nKey4  := fConvHr( Val( cKey4  ), 'D' )
	nKey5  := SubHoras( nAgora, nKey4 )

	lTimeOut := nKey5 <= GetMv( 'MV_890_01', .F. )

	// Avaliar a chave data.
	cKey1 := SubStr( cParam1, 1, nTamDig )
	lHoje := ( Ctod( '01/01/96', 'DDMMYYYY' ) + Val( cKey1 ) ) == Date()

	// Avaliar o login do usuário.
	cKey3 := RTrim( SubStr( cParam1, nTamDig+7 ) )
	PswOrder( 2 )
	lLogin := PswSeek( cKey3 )

	If .NOT. lTimeOut
		lRet := .F.
		U_arErro( 202, @aRet, @cReturn )
	Endif

	If .NOT. lHoje .AND. lRet
		lRet := .F. 
		U_arErro( 203, @aRet, @cReturn )
	Endif

	If .NOT. lLogin .AND. lRet
		lRet := .F. 
		U_arErro( 203, @aRet, @cReturn )
	Endif

	If lRet .AND. lTimeOut .AND. lHoje .AND. lLogin
		aRet[ 1 ] := 100
		aRet[ 2 ] := '{"message":"Autenticacao bem sucedida."}'
		AAdd( aRet, 'Token homologado [Login: ' + cKey3 + '][Data: ' + Dtoc( Date() ) + '][Time:' + cAgora + '|' + LTrim( Str( nKey4 ) ) +']' )
		cWhoAreYou := cKey3
	Endif

	//---------------------------------------------------------------------------------------------------------//
	//                                                                                                         //
	// Se todo processo de validar o Token estiver OK não é necessátrio atribuir mensagem a variável cReturn.  //
	// Do contrário a função U_arErro atribuirá uma mensagem adequada para a variável cReturn.                 //
	//                                                                                                         //
	//---------------------------------------------------------------------------------------------------------//
	U_arConout( Iif( Empty( cReturn ), aRet[ 2 ] , cReturn ) + ' ' + cThread )
Return( lRet )

User Function validAut( aParam, cReturn, aRet, cStack, cThread, nQtdParam )
	local cKey
	local i := 0

	default aParam    := {}
	default cReturn   := ""
	default aRet 	  := {}
	default cStack 	  := ""
	default cThread   := ""
	default nQtdParam := 0

	cStack += 'validAut()' + CRLF

	// Validar os parâmetros.
	If Len( aParam ) != nQtdParam
		U_arErro( 201, @aRet, @cReturn )
		U_arConout( cReturn + ' ' + cThread )
		Return( .F. )
	Endif

	// Validar os parâmetros.
	for i := 1 to len( aParam )
		If ValType( aParam[ i ] ) <> 'C' 
			U_arErro( 105, @aRet, @cReturn )
			U_arConout( cReturn + ' ' + cThread )
			Return( .F. )
		Endif
	next i

	cKey := aParam[ 1 ]

	// Validar o Token.
	If .NOT. U_arValidToken( cKey, @aRet, @cStack, @cReturn, cThread )
		U_arConout( cReturn + ' ' + cThread )
		Return( .F. )
	Endif
Return( .T. )

User Function arVldDoc( cCNPJ, aRet, cStack, cReturn )	
	Local cTRB := 'Z3CGC'
	Local cSQL := ''

	cStack += 'ARVLDDOC()' + CRLF

	cSQL := "SELECT Z3_CGC, "
	cSQL += "       Z3_AENET, "
	cSQL += "       Z3_NMFANT "
	cSQL += "FROM   "+RetSqlName("SZ3")+" SZ3 "
	cSQL += "WHERE  Z3_FILIAL          = ' ' "
	cSQL += "       AND Z3_CGC         = " + ValToSql( cCNPJ )  + " "
	cSQL += "       AND Z3_TIPENT      = '3' "
	cSQL += "		AND SZ3.D_E_L_E_T_ = ' ' "

	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSQL ), cTRB, .F., .T. ) 

	If (cTRB)->( EOF() ) .AND. (cTRB)->( BOF() )
		U_arErro( 204, @aRet, @cReturn )
		(cTRB)->( dbCloseArea() )
		Return( .F. )	
	Else
		If (cTRB)->Z3_AENET <> 'S'
			U_arErro( 205, @aRet, @cReturn )
			(cTRB)->( dbCloseArea() )
			Return( .F. )
		Endif
	Endif

	(cTRB)->( dbCloseArea() )
Return( .T. )

User Function arConout( cString )
	Conout( '[INFO-' + Dtoc(Date()) + ' ' + Time() + '] PROTHEUS x AENET: ' + cString )
Return

User Function arPutLog( aPar, lDebug )
	Local cLigaLog := 'MV_890_02'
	Local nHdl := 0

	default aPar := {}
	DEFAULT lDebug := .T.

	If lDebug
		RpcSetType( 3 )
		RpcSetEnv( '01', '02' )
	Endif

	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X AENET', '.F.' )
	Endif

	If .NOT. GetMv( cLigaLog, .F. )
		Return
	Endif

	If !File( 'gtaenet.log' )
		U_GTSetUp()
		nHdl := FCreate( 'gtaenet.log' )
		FClose( nHdl )
	Endif

	If Select('GTAENET') <= 0
		U_UseAENet()
	Endif

	DbSelectArea( 'GTAENET' )
	DbAppend(.F.)
	GTAENET->GT_DATA    := Date()
	GTAENET->GT_HORA    := Time()
	GTAENET->GT_ACAO    := aPar[ 1 ]
	GTAENET->GT_SERVICE := aPar[ 2 ]
	GTAENET->GT_PARAM   := aPar[ 3 ]
	//GTAENET->GT_RETURN  := aPar[ 4 ]
	GTAENET->GT_TMPINI  := aPar[ 5 ]
	GTAENET->GT_TMPFIM  := aPar[ 6 ]
	GTAENET->GT_TMPDECO := aPar[ 7 ]
	DbCommit()
	DbRUnlock()

	GTAENET->( RecLock( 'GTAENET', .F. ) )
	GTAENET->GT_ID := StrZero( GTAENET->(RecNo()), 10, 0 )
	GTAENET->( MsUnLock() )
Return

User Function cnpjMatch( cCNPJ, cPedido, cReturn, aRet, cStack, cThread )
	Local cIdPostVal := ''
	Local cIdPostVer := '' 
	Local cSQL := ''
	Local cTRB := 'SZ3CODGAR'

	Local nInvalido := 0
	Local nQtdReg := 0

	Local oDados
	Local oWsGAR

	/*
	cStack += 'cnpjMatch()' + CRLF

	oWsGAR := WSIntegracaoGARERPImplService():New()
	oWsGAR:findDadosPedido( 'erp', 'password123', Val( cPedido ) )
	oDados := oWsGAR:oWsDadosPedido

	If oDados == NIL .OR. oDados:nPedido == NIL
	// Pode retornar true, pois a rotina de dados trata o pedido não localizado.
	// O objetivo aqui é apenas saber se o CNPJ informado corresponde ao pedido requisitado.
	Return( .T. ) 
	Endif

	cIdPostVal := cValToChar( oDados:npostoValidacaoId )
	cIdPostVer := cValToChar( oDados:npostoVerificacaoId )

	cSQL := "SELECT Z3_CGC "
	cSQL += "FROM   " + RetSqlName( "SZ3" ) + " SZ3 "
	cSQL += "WHERE  Z3_FILIAL = " + ValToSql( xFilial( "SZ3" ) ) + " " 
	cSQL += "       AND ( Z3_CODGAR = " + ValToSql( cIdPostVal ) + " "
	cSQL += "             OR Z3_CODGAR = " + ValToSql( cIdPostVer ) + " ) "
	cSQL += "       AND SZ3.D_E_L_E_T_ = ' ' "

	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSQL ), cTRB, .F., .T. ) 

	If (cTRB)->( EOF() ) .AND. (cTRB)->( BOF() )
	U_arErro( 212, @aRet, @cReturn )
	(cTRB)->( dbCloseArea() )
	Return( .F. )	
	Else
	// É possível que retorne mais de 1 CNPJ, 
	// por exemplo: Z3_CODGAR IN ('4716','44238','44253') retorna CNPJs 56282924000182, 56282924000425 e 56282924000506.
	// Neste caso todos são válidos. Se um ou outro for válido ok também.
	// A restrição é quando nenhum dos resultados é válidos, daí é preciso criticar.

	While (cTRB)->( .NOT. EOF() )
	nQtdReg++
	If SubStr( (cTRB)->Z3_CGC, 1, 8 ) <> SubStr( cCNPJ, 1, 8 )
	nInvalido++
	Endif
	(cTRB)->( dbSkip() )
	End

	If nQtdReg == nInvalido
	U_arErro( 211, @aRet, @cReturn )
	consultNeg( cCNPJ, (cTRB)->Z3_CGC, cPedido, aRet[ 1 ] + '-' + aRet[ 2 ], cStack )
	(cTRB)->( dbCloseArea() )
	Return( .F. )
	Endif

	Endif
	(cTRB)->( dbCloseArea() )
	*/
Return( .T. )

Static Function consultNeg( cCNPJ_Acess, cCNPJ_Req, cPedidoGAR, cMsgRet, cStack )
	Local aLog := {}
	Local cBarra := Iif( IsSrvUnix(), '/', '\' )
	Local cFile := ''
	Local cMsg := ''
	Local cPasta := cBarra + 'aenet' + cBarra
	Local i := 0
	Local nHdl := 0

	AAdd( aLog, '******************************* CONSULTA NEGADA *******************************' )
	AAdd( aLog, 'Data e hora........: ' + Dtoc( Date() ) + ' - ' + Time() )
	AAdd( aLog, 'Usuário de acesso..: ' + cWhoAreYou ) 
	AAdd( aLog, 'CNPJ de acesso.....: ' + cCNPJ_Acess )
	AAdd( aLog, 'Pedido GAR.........: ' + cPedidoGAR )
	AAdd( aLog, 'CNPJ do pedido GAR.: ' + cCNPJ_Req )
	AAdd( aLog, 'Mensagem de retorno: ' + cMsgRet )
	AAdd( aLog, 'Pilha de rotinas...: ' + cStack )
	AAdd( aLog, ' ' )
	AAdd( aLog, 'Usuário que acessou o WebService conforme a pilha de rotinas, informou um CNPJ' ) 
	AAdd( aLog, 'de consulta diferente do CNPJ do Posto de verificação ou validação do pedido.' )
	AAdd( aLog, '*******************************************************************************' )

	If FwMakeDir( cPasta, .F. )
		cFile := cPasta + CriaTrab( , .F. ) + '.log'
		nHdl := FCreate( cFile, 1 )
		For i := 1 To Len( aLog )
			FWrite( nHdl, aLog[ i ] + CRLF )
		Next i
		FClose( nHdl )
	Else
		cMsg := 'NÃO FOI POSSÍVEL CRIAR ARQUIVO DE LOG DE CONSULTA NEGADA FONTE CSFA894 ROTINA CONSULTNEG'
		FSSendMail( 'sistemascorporativos@certisign.com.br', 'LOG CONSULTA NEGADA', cMsg, /*cAnexo*/ )	
	Endif
Return