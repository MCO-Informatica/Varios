//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | OTRS / JIRA               |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+
//| 26/06/2020 | Bruno Nunes   | - Erro ao consultar por CPF, CNPJ, pedido site, pedido GAR quando o atributo     | 1.00   | SIS-555, SIS-530, SIS-376 |
//|            |               | "itemProduto"                                                                    |	       | SIS-70                    |
//+------------+---------------+----------------------------------------------------------------------------------+--------+---------------------------+

// **************************************************************************
// ****                                                                  ****
// **** Rotina auxiliares para os serviços Protheus Webservice REST para ****
// **** integrar RightNow com GAR                                        ****
// ****                                                                  ****
// **************************************************************************

#include 'protheus.ch'

User Function rnGetNow()
	Local cVar := ''
	Local nHH := 0, nMM := 0, nSS := 0, nMS := Seconds() 
	
	nHH := Int(nMS/3600)
	nMS -= (nHH*3600)
	nMM := Int(nMS/60)
	nMS -= (nMM*60)
	nSS := Int(nMS)
	nMS := (nMs-nSS)*1000
	
	cVar := StrZero( nHH, 2 ) + ':' + StrZero( nMM, 2 ) + ':' + StrZero( nSS, 2 ) + '.' + StrZero( nMS, 3 )
Return( cVar )

User Function rnConout( cString )
	Conout( ' [ Data e hora]: ' + Dtoc(Date()) + ' ' + Time() + ;
			' [ Funcao ]: ' + ProcName(1) + ;
			' [ Protheus x RightNow ]: ' + cString )
Return

User Function rnVldTok( cToken, aRet, cStack, cThread )
	Local aSeed := {8,9,8,9,8,9}
	
	Local cAgora := ''
	Local cKey1 := ''
	Local cKey2 := ''
	Local cKey3 := ''
	Local cKey4 := ''
	Local cMV_880_01 := 'MV_880_01'
	Local cParam1 := ''
	
	Local lHoje := .F.
	Local lLogin := .F.
	Local lRet := .T.
	Local lTimeOut := .F.
	
	Local nAgora := 0
	Local nKey4 := 0
	Local nKey5 := 0
	Local nTamDig := 0
	
	cStack += 'rnVldTok()' + CRLF
	
	If .NOT. GetMv( cMV_880_01, .T. )
		CriarSX6( cMV_880_01, 'N', 'TIME-OUT DO TOKEN NA INTEGRACAO C/ RIGHTNOW, VALOR EM DECIMAL 100 = 60 SEGUNDOS. ROTINA CSFA880.PRW', '100' )
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
	
	lTimeOut := nKey5 <= GetMv( 'MV_880_01', .F. )
	
	// Avaliar a chave data.
	cKey1 := SubStr( cParam1, 1, nTamDig )
	lHoje := ( Ctod( '01/01/96', 'DDMMYYYY' ) + Val( cKey1 ) ) == Date()
	
	// Avaliar o login do usuário.
	cKey3 := RTrim( SubStr( cParam1, nTamDig+7 ) )
	PswOrder( 2 )
	lLogin := PswSeek( cKey3 )
	
	If .NOT. lTimeOut
		lRet := .F.
		aRet[ 1 ] := '311'
		aRet[ 2 ] := 'Erro timeout (time) ' + cKey2
		U_rnConout( aRet[ 2 ] + cThread )
	Endif
	
	U_rnConout('Passei pelo Time-out do validToken. '+cThread)
	
	If .NOT. lHoje .AND. lRet
		lRet := .F. 
		aRet[ 1 ] := '312'
		aRet[ 2 ] := 'Erro timeout (date) ' + cKey1 + '.'
		U_rnConout( aRet[ 2 ] + cThread )
	Endif
	
	U_rnConout('Passei pelo lHoje do validToken. '+cThread)
	
	If .NOT. lLogin .AND. lRet
		lRet := .F. 
		aRet[ 1 ] := '313'
		aRet[ 2 ] := 'Login invalido ' + cKey3 + '.'
		U_rnConout( aRet[ 2 ] + cThread )
	Endif
	
	If lRet .AND. lTimeOut .AND. lHoje .AND. lLogin
		aRet[ 1 ] := '310'
		aRet[ 2 ] := 'Token homologado - Login ' + cKey3 + ' Data ' + Dtoc( Date() ) + ' Time ' + cAgora + ' ' + LTrim( Str( nKey4 ) ) +'. '
		U_rnConout( aRet[ 2 ] + cThread )
	Endif
	
	U_rnConout('Passei pelo Login do validToken. ' + cThread)
Return( lRet )

User Function rnPutLog( aPar, lDebug )
	Local cLigaLog := 'MV_880_02'
	Local nHdl := 0
	
	DEFAULT lDebug := .T.
	
	If lDebug
		RpcSetType( 3 )
		RpcSetEnv( '01', '02' )
	Endif

	If .NOT. GetMv( cLigaLog, .T. )
		CriarSX6( cLigaLog, 'L', 'LIGAR/DESLIGAR GRAVACAO DE LOG DA INTEGRACAO. PROTHEUS X RIGHTNOW', '.F.' )
	Endif
	
	If .NOT. GetMv( cLigaLog, .F. )
		Return
	Endif

	If .NOT. File( 'gtrnow.log' )
		U_GTSetUp()
		nHdl := FCreate( 'gtrnow.log' )
		FClose( nHdl )
	Endif
	
	If Select('GTRNOW') <= 0
		U_UseRightNow()
	Endif
	
	dbSelectArea( 'GTRNOW' )
	dbAppend(.F.)
	GTRNOW->GT_DATA    := Date()
	GTRNOW->GT_HORA    := Time()
	GTRNOW->GT_ACAO    := aPar[ 1 ]
	GTRNOW->GT_SERVICE := aPar[ 2 ]
	GTRNOW->GT_PARAM   := aPar[ 3 ]
	GTRNOW->GT_RETURN  := aPar[ 4 ]
	GTRNOW->GT_TMPINI  := aPar[ 5 ]
	GTRNOW->GT_TMPFIM  := aPar[ 6 ]
	GTRNOW->GT_TMPDECO := aPar[ 7 ]
	DBCommit()
	DBRUnlock()
	
	GTRNOW->( RecLock( 'GTRNOW', .F. ) )
	GTRNOW->GT_ID := StrZero( GTRNOW->(RecNo()), 10, 0 )
	GTRNOW->( MsUnLock() )
	DBCommitAll()
	DBRUnlock()
	
	If lDebug
		RpcClearEnv()
	Endif
	
	KillApp(.T.)
Return

User Function validPar( aParms, aRet )
	Local cCPFCNPJ := ''
	Local lRet := .T.
	Local i := 0
	If Len( aParms ) <> 3
		lRet := .F.
		aRet[ 1 ] := '330'
		aRet[ 2 ] := 'Esperado 3 parametros.'
	Endif
	If Len( aParms ) > 0 .AND. lRet
		If ValType( aParms[ 1 ] ) <> 'C'
			lRet := .F.
			aRet[ 1 ] := '331'
			aRet[ 2 ] := 'Parametro 1 diferente do tipo caractere.'
		Endif
	Endif
	If Len( aParms ) > 1 .AND. lRet
		If ValType( aParms[ 2 ] ) <> 'C'
			lRet := .F.
			aRet[ 1 ] := '332'
			aRet[ 2 ] := 'Parametro 2 diferente do tipo caractere.'
		Endif
	Endif
	If Len( aParms ) > 2 .AND. lRet
		If ValType( aParms[ 3 ] ) <> 'C'
			lRet := .F.
			aRet[ 1 ] := '333'
			aRet[ 2 ] := 'Parametro 3 diferente do tipo caractere.'
		Endif
	Endif
	
	If lRet .AND. ( Empty( aParms[ 1 ] ) .OR. Empty( aParms[ 2 ] ) .OR. Empty( aParms[ 3 ] ) )
		lRet := .F.
		aRet[ 1 ] := '334'
		aRet[ 2 ] := 'Conteudo dos parametros invalido. Parametro 1 ' + aParms[ 1 ] + ' - Parametro 2 ' + aParms[ 2 ] + ' - Parametro 3 ' + aParms[ 3 ] + '.'
	Endif
	
	If lRet .AND. aParms[ 3 ] == '1' .AND. Len( aParms[ 2 ] ) < 12
		lRet := .F.
		aRet[ 1 ] := '335'
		aRet[ 2 ] := 'Conteudo do parametro 2 invalido. Esperrado T ou F mais o numero do CPF/CNPJ: ' + aParms[ 2 ]
	Endif
	
	If lRet .AND. aParms[ 3 ] == '1' .AND. .NOT. (SubStr( aParms[ 2 ], 1 , 1 ) $ 'T/F' )
		lRet := .F.
		aRet[ 1 ] := '335'
		aRet[ 2 ] := 'Conteudo do parametro 2 invalido. Esperrado T ou F mais o numero do CPF/CNPJ: ' + aParms[ 2 ]
	Endif
	
	If lRet .AND. ( aParms[ 3 ] == '1' .OR. aParms[ 3 ] == '3' )
		If aParms[ 3 ] == '1'
			cCPFCNPJ := SubStr( aParms[ 2 ], 2 )
		Elseif aParms[ 3 ] == '3'
			cCPFCNPJ := aParms[ 2 ]
		Endif
	
		// Verificar se possui somente números.
		For i := 1 To Len( cCPFCNPJ )
			If .NOT. (SubStr( cCPFCNPJ, i, 1 ) $ '0123456789')
				lRet := .F.
				Exit
			Endif
		Next i
		
		// Verificar se o tamanho corresponde ao CPF ou CNPJ
		If lRet
			If Len( cCPFCNPJ ) <> 11 .AND. Len( cCPFCNPJ ) <> 14
				lRet := .F.
			Endif
		Endif
		
		// Verificar se o CPF/CNPJ é válido.
		If lRet
			lRet := CGC( cCPFCNPJ, , .F. )
		Endif
		
		If .NOT. lRet
			aRet[ 1 ] := '336'
			aRet[ 2 ] := 'CPF/CNPJ incorreto.'
		Endif
	Endif
Return( lRet )

User Function rnLeftZe( cDoc, cType )
	Local cPar := ''
	Local cRet := ''
	
	DEFAULT cDoc := ''
	DEFAULT cType := ''
	
	cPar := AllTrim( cDoc )
	
	If .NOT. Empty( cPar )
		If cType == 'CPF'
			If Len( cPar ) < 11
				cRet := PadL( cPar, 11, '0' ) 
			Else
				cRet := cPar
			Endif
		Else
			If cType == 'CNPJ'
				If Len( cPar ) < 14
					cRet := PadL( cPar, 14, '0' )
				Else
					cRet := cPar
				Endif
			Endif
		Endif
	Endif
Return( cRet )

User Function RnNoAcen( cString )
	Local cAux := cString
	
	cAux := NoAcento(  cAux )
	
	cAux := StrTran( cAux, "'" , '' )
	cAux := StrTran( cAux, '"' , '' )
	cAux := StrTran( cAux, '´' , '' )
	cAux := StrTran( cAux, '`' , '' )
	cAux := StrTran( cAux, '^' , '' )
	cAux := StrTran( cAux, '~' , '' )
	cAux := StrTran( cAux, '¨' , '' )
	cAux := StrTran( cAux, '\' , '' ) //barra invertida.
	cAux := StrTran( cAux, '\"', '' ) //barra invertida mais aspas.
	cAux := StrTran( cAux, chr(9), '' ) //tab
	
	cAux := Alltrim( SpedNoAcento( cAux ) )

Return( cAux )

/******
 *
 * Classe para buscar os parâmetros de conexão do sistema Check-Out.
 *
 */
CLASS checkoutParam
	DATA url
	DATA endPoint
	DATA userCode
	DATA password
	
	METHOD get()
END CLASS

/******
 *
 * Método de captura dos parâmetros para conexão.
 *
 */
METHOD get() CLASS checkoutParam
	Local cMV_881_01 := 'MV_881_01'
	Local cMV_881_02 := 'MV_881_02'
	Local cMV_881_03 := 'MV_881_03'
	Local cMV_881_04 := 'MV_881_04'
	
	If .NOT. GetMv( cMV_881_01, .T. )
		CriarSX6( cMV_881_01, 'C', 'HOST P/ COMUNICACAO COM SERV REST DO CHECK-OUT. CSFA881.',;
		'https://checkout.certisign.com.br' )
	Endif
	
	If .NOT. GetMv( cMV_881_02, .T. )
		CriarSX6( cMV_881_02, 'C', 'ENDPOINT DE COMUNICACAO SERV REST CHECK-OUT. CSFA881.',;
		'/rest/api/pedidos' )
	Endif
	
	If .NOT. GetMv( cMV_881_03, .T. )
		CriarSX6( cMV_881_03, 'C', 'USUARIO DE AUTENTICACAO SERV REST CHECK-OUT. CSFA881.',;
		'7516d708-b733-4f5a-aae5-fbb2955c0c45' )
	Endif
	
	If .NOT. GetMv( cMV_881_04, .T. )
		CriarSX6( cMV_881_04, 'C', 'PASSWORD DE AUTENTICACAO SERV REST CHECK-OUT. CSFA881.',;
		'SOwY3RCA9sOSgtM68MxmQQ==' )
	Endif
	
	self:url      := GetMv( cMV_881_01, .F. )
	self:endPoint := GetMv( cMV_881_02, .F. )
	self:userCode := GetMv( cMV_881_03, .F. )
	self:password := GetMv( cMV_881_04, .F. )
Return