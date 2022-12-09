//-----------------------------------------------------------------------
// Rotina | CSFA180    | Autor | Robson Gonçalves     | Data | 13.06.2013
//-----------------------------------------------------------------------
// Descr. | Relatórios Agenda Certisign e Atendimentos.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
#Include 'Protheus.ch'
#Include 'Report.ch'

User Function CSFA180()
	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private l180Query := .F. 
	Private cCadastro := 'Relat. Agenda Certisign/Atend'
	Private cDescriRel := 'Esta rotina apresenta os relatórios de Agendas Certisign e Atendimentos.'

	SetKey( VK_F12 , {|| l180Query := MsgYesNo('Exportar a string da query principal?',cCadastro ) } )

	AAdd( aSay, cDescriRel )
	AAdd( aSay, ' ' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	SetKey( VK_F12 , NIL )

	If nOpcao==1
		A180Param()
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A180Param  | Autor | Robson Gonçalves     | Data | 20.03.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de parâmetros para usuário informar.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Param()
	Local bOk
	
	Local aPar := {}
	Local aRet := {}
	Local aOpcVisao := {}	
	
	Local nI := 0
	
	Local cDado := ''
	Local cFunc := ''
	
	Private nFont := 0
	Private n180Nome := 0
	Private n180Visao := 0
	Private nColSpace := 0
	
	Private cFont := ''
	Private cOrient := ''
	Private c180Visao := ''
	Private c180ConsDe := ''
	Private c180ConsAte := ''
	Private c180Canal := ''
	Private d180PerDe := Ctod(Space(8))
	Private d180PerAte := Ctod(Space(8))
	Private n180Ordem := 0
	Private n180Base := 0
	Private n180Status := 0
	
	Private aCab := {}
	Private aDados := {}
	Private aAlign := {}
	Private aParam := {}
	Private aSizeCol := {}
	Private aPicture := {}
	
	Private aAsk := {}
	Private aReply := {}
	Private aOrdem := {}
	Private aBase := {}
	Private aStatus := {}
	
	aOpcVisao := {'Por Consultor',;
	              'Por Tipo de comunicação',;
	              'Por Produto',;
	              'Por Ranking de produtos',;
	              'Mapa diário',;
	              'Mapa Assunt X Ocorr X Ação',;
	              'Registro de atendimento'}
	
	AAdd( aPar, { 3, 'Qual visão'                              ,1 , aOpcVisao                     , 99, '', .T. } )
	AAdd( aPar, { 1, 'Consultor de' ,Space(Len(SU7->U7_COD))   ,'',''                    ,'SU7'   , '', 50, .F. } )
	AAdd( aPar, { 1, 'Consultor até',Space(Len(SU7->U7_COD))   ,'','(mv_par03>=mv_par02)','SU7'   , '', 50, .T. } )
	AAdd( aPar, { 1, 'Canal venda'  ,Space(Len(SA3->A3_XCANAL)),'','','SZ2'                       , '', 50, .T. } )
	AAdd( aPar, { 1, 'Período de'   ,Ctod(Space(8))            ,'',''                    ,''      , '', 50, .F. } )
	AAdd( aPar, { 1, 'Período até'  ,Ctod(Space(8))            ,'','(mv_par06>=mv_par05)',''      , '', 50, .T. } )
	
	bOK := {|| Iif(mv_par01<6,(Iif(mv_par01==1,A180Fil(),Iif(mv_par01==7,A180Status(),.T.))),Iif((mv_par01>=6),(MsgAlert('Relatório não disponível.'),.F.),.T.)) }

	If !ParamBox( aPar, 'Parâmetros de processamento', @aRet, bOk,,,,,,,.T.,.T.)
		Return
	Endif
   
	c180Visao   := aOpcVisao[ aRet[ 1 ] ]
	n180Visao   := aRet[1]
	c180ConsDe  := aRet[2]
	c180ConsAte := aRet[3]
	c180Canal   := aRet[4]
	d180PerDe   := aRet[5]
	d180PerAte  := aRet[6]

	AAdd( aParam, 'PARAMETROS INFORMADOS' )

	For nI := 1 To Len( aPar )
		If ValType( aRet[ nI ] ) == 'D'
			cDado := Dtoc( aRet[ nI ] )
		Elseif ValType( aRet[ nI ] ) == 'N'
			cDado := LTrim( Str( aRet[ nI ] ) )
		Else
			cDado := aRet[ nI ]
			// Canal de venda
			If nI==4 
				cDado += '-'+RTrim( Posicione( 'SZ2', 1, xFilial( 'SZ2' ) + aRet[ 4 ], 'Z2_CANAL' ) )
			Endif
		Endif
		// Tratar o texto do parâmetro de qual visão foi selecionada.
		If nI == 1
			cDado += '-' + c180Visao
		Endif
		AAdd( aParam, aPar[ nI, 2 ] + ': [' + cDado +']')
	Next nI
	
	If n180Visao == 1
		AAdd( aParam, aAsk[ 1, 2 ] +': [' + aOrdem[ aReply[ 1 ] ] + ']' )
		AAdd( aParam, aAsk[ 2, 2 ] +': [' + aBase[ aReply[ 2 ] ]  + ']' )
		cFunc := 'A180Cons()'
	Elseif n180Visao == 2
		cFunc := 'A180TpCom()'
	Elseif n180Visao == 3
		cFunc := 'A180Prod()'
	Elseif n180Visao == 4
		cFunc := 'A180Rankin()'
	Elseif n180Visao == 5
		cFunc := 'A180MpDia()'
	Elseif n180Visao == 6
		cFunc := 'A180MpTabu()'
	Elseif n180Visao == 7
		cFunc := 'A180RAtend()'
		AAdd( aParam, aAsk[ 1, 2 ] +': [' + aStatus[ aReply[ 1 ] ] + ']' )
	Else
		MsgAlert('Não há processamento para esta visão.',cCadastro)
	Endif
	
	Processa( {|| &(cFunc) }, cCadastro,"Aguarde, processando os dados...", .F. ) 
Return
		
//-----------------------------------------------------------------------
// Rotina | A180Cons   | Autor | Robson Gonçalves     | Data | 12.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento - visção por consultor.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Cons()
	Local cSQL := ''
	Local cTRB := ''
	
	Local nElem := 0
	Local nTotal := 0
	Local nSum := 0
	Local nPercOpen := 0
	
	Local nT_Open := 0
	Local nT_Close := 0
	Local nT_Reschedule := 0
	   	
	Private oReport
	
	aBase  := {'Renovação (SSL/ICP)', 'Leads', 'Clientes/Prospects/Suspects', 'Ambos' }

	cSQL := "SELECT U7_NOME, " + CRLF
	cSQL += "       U7_COD, " + CRLF
	cSQL += "       A3_COD, " + CRLF

	cSQL += "       (SELECT ISNULL(COUNT(*),0) AS nABERTO " + CRLF
	cSQL += "        FROM   "+RetSqlName("SU4")+" SU4 " + CRLF
	cSQL += "               INNER JOIN "+RetSqlName("SU6")+" SU6 " + CRLF
	cSQL += "                     ON U6_FILIAL = "+ValToSql( xFilial( "SU6" ) )+" " + CRLF
	cSQL += "                        AND U6_LISTA = U4_LISTA " + CRLF
	cSQL += "                        AND U6_DATA BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+" " + CRLF
	cSQL += "                        AND U6_STATUS = '1' " + CRLF
	
	If n180Base==1
		cSQL += "                        AND (U6_ENTIDA = 'SZT' OR U6_ENTIDA = 'SZX' )" + CRLF
	Elseif n180Base==2
		cSQL += "                        AND U6_ENTIDA = 'PAB' " + CRLF
	Elseif n180Base==3
		cSQL += "                        AND (U6_ENTIDA = 'SA1' OR U6_ENTIDA = 'SUS' OR U6_ENTIDA = 'ACH' )" + CRLF
	Endif
	
	cSQL += "                        AND SU6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "        WHERE  U4_FILIAL = "+ValToSql( xFilial( "SU4" ) )+" " + CRLF
	cSQL += "               AND U4_OPERAD = U7_COD " + CRLF
	cSQL += "               AND SU4.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "               AND U4_STATUS = '1' " + CRLF
	cSQL += "               AND U4_TELE = '1' " + CRLF
	cSQL += "               AND U4_CODLIG = ' ' " + CRLF
	cSQL += "               AND (U4_FORMA = '1' OR U4_FORMA = '5' OR U4_FORMA = '6')) AS nOPEN, " + CRLF
	
	cSQL += "       (SELECT ISNULL(COUNT(*),0) AS nREAGENDADO " + CRLF
	cSQL += "        FROM   "+RetSqlName("SU4")+" SU4 " + CRLF
	cSQL += "               INNER JOIN "+RetSqlName("SU6")+" SU6 " + CRLF
	cSQL += "                     ON U6_FILIAL = "+ValToSql( xFilial( "SU6" ) )+" " + CRLF
	cSQL += "                        AND U6_LISTA = U4_LISTA " + CRLF
	cSQL += "                        AND U6_DATA BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+" " + CRLF
	cSQL += "                        AND U6_STATUS = '1' " + CRLF
	
	If n180Base==1
		cSQL += "                        AND (U6_ENTIDA = 'SZT' OR U6_ENTIDA = 'SZX' )" + CRLF
	Elseif n180Base==2
		cSQL += "                        AND U6_ENTIDA = 'PAB' " + CRLF
	Elseif n180Base==3
		cSQL += "                        AND (U6_ENTIDA = 'SA1' OR U6_ENTIDA = 'SUS' OR U6_ENTIDA = 'ACH' )" + CRLF
	Endif
	
	cSQL += "                        AND SU6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "        WHERE  U4_FILIAL = "+ValToSql( xFilial( "SU4" ) )+" " + CRLF
	cSQL += "               AND U4_OPERAD = U7_COD " + CRLF
	cSQL += "               AND SU4.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "               AND U4_STATUS = '1' " + CRLF
	cSQL += "               AND U4_TELE = '1' " + CRLF
	cSQL += "               AND U4_CODLIG <> ' ' " + CRLF
	cSQL += "               AND (U4_FORMA = '1' OR U4_FORMA = '5' OR U4_FORMA = '6')) AS nRESCHEDULE, " + CRLF

	cSQL += "       (SELECT ISNULL(COUNT(*),0) AS nFECHADO " + CRLF
	cSQL += "        FROM   "+RetSqlName("SU4")+" SU4 " + CRLF
	cSQL += "               INNER JOIN "+RetSqlName("SU6")+" SU6 " + CRLF
	cSQL += "                     ON U6_FILIAL = "+ValToSql( xFilial( "SU6" ) )+" " + CRLF
	cSQL += "                        AND U6_LISTA = U4_LISTA " + CRLF
	cSQL += "                        AND U6_DTATEND BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+" " + CRLF
	cSQL += "                        AND U6_STATUS <> '1' " + CRLF
	
	If n180Base==1
		cSQL += "                        AND (U6_ENTIDA = 'SZT' OR U6_ENTIDA = 'SZX' )" + CRLF
	Elseif n180Base==2
		cSQL += "                        AND U6_ENTIDA = 'PAB' " + CRLF
	Elseif n180Base==3
		cSQL += "                        AND (U6_ENTIDA = 'SA1' OR U6_ENTIDA = 'SUS' OR U6_ENTIDA = 'ACH' )" + CRLF
	Endif	
	cSQL += "                        AND SU6.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "        WHERE  U4_FILIAL = "+ValToSql( xFilial( "SU4" ) )+" " + CRLF
	cSQL += "               AND U4_OPERAD = U7_COD " + CRLF
	cSQL += "               AND SU4.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "               AND (U4_STATUS = '1' OR U4_STATUS = '2') " + CRLF
	cSQL += "               AND U4_TELE = '1' " + CRLF
	cSQL += "               AND (U4_FORMA = '1' OR U4_FORMA = '5' OR U4_FORMA = '6')) AS nCLOSE " + CRLF
	
	cSQL += "FROM   "+RetSqlName("SU7")+" SU7 " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SA3")+" SA3 " + CRLF
	cSQL += "             ON A3_FILIAL = "+ValToSql( xFilial( "SA3" ) )+" " + CRLF
	cSQL += "                AND A3_COD = U7_CODVEN " + CRLF
	cSQL += "                AND A3_XCANAL = "+ValToSql( c180Canal )+" " + CRLF
	cSQL += "                AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                AND SA3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  U7_FILIAL = "+ValToSql( xFilial( "SU7" ) )+" " + CRLF
	cSQL += "       AND U7_COD BETWEEN "+ValToSql( c180ConsDe )+" AND "+ValToSql( c180ConsAte )+" " + CRLF
	cSQL += "       AND U7_VEND = '1' " + CRLF
	cSQL += "       AND U7_VALIDO = '1' " + CRLF
	cSQL += "       AND SU7.D_E_L_E_T_ = ' ' " + CRLF
	
	If n180Ordem==1
		cSQL += "ORDER  BY U7_NOME " + CRLF
	Else
		cSQL += "ORDER  BY nCLOSE DESC" + CRLF
	Endif
	
   If l180Query
		A180Script( cSQL )   
   Endif

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	FwMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 1
	cFont := 'Consolas'
	nFont := 9
	cOrient := 'PAISAGEM'
	n180Nome := 3
	aCab := {'NOME DO CONSULTOR','OPERADOR','VENDEDOR','ABERTO','REAGENDADO','ATENDIDO','TOTAL','%PENDENTE'}
	aAlign := {'LEFT','LEFT','LEFT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@!','@E 9,999','@E 99,999','@E 99,999','@E 99,999','@E 999.99'}
	aSizeCol := {50,08,08,06,10,08,05,07}
	//           |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  +-> %ABERTO
	//           |  |  |  |  |  |  +----> TOTAL
	//           |  |  |  |  |  +-------> ATENDIDO
	//           |  |  |  |  +----------> REAGENDADO
	//           |  |  |  +-------------> ABERTO
	//           |  |  +----------------> VENDEDOR
	//           |  +-------------------> OPERADOR
	//           +----------------------> NOME DO CONSULTOR
	
	ProcRegua(0)
	While ! (cTRB)->( EOF() )
		IncProc()
		
		nSum := (cTRB)->( nOPEN + nRESCHEDULE + nCLOSE )
		nPercOpen := Round(((cTRB)->(nOPEN+nRESCHEDULE)/nSum)*100,2)
		
		(cTRB)->( AAdd( aDados, { U7_NOME, U7_COD, A3_COD, nOPEN, nRESCHEDULE, nCLOSE, nSum, nPercOpen } ) )
		
		nT_Open       += (cTRB)->(nOPEN)
		nT_Reschedule += (cTRB)->(nRESCHEDULE)
		nT_Close      += (cTRB)->(nCLOSE)
		nTotal        += (cTRB)->(nOPEN+nRESCHEDULE+nCLOSE)

		(cTRB)->( dbSkip() )
	End	
	(cTRB)->(dbCloseArea())
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 4 ] := nT_Open
	aDados[ nElem, 5 ] := nT_Reschedule
	aDados[ nElem, 6 ] := nT_Close
	aDados[ nElem, 7 ] := nTotal
	aDados[ nElem, 8 ] := Round((((nT_Open+nT_Reschedule)/nTotal)*100),2)

	oReport := A180Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
Return

//-----------------------------------------------------------------------
// Rotina | A180TpCom  | Autor | Robson Gonçalves     | Data | 14.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento - visão por tipo de comunicação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180TpCom()
	Local cSQL := ''
	Local cTRB := ''
	Local cKey := ''
	
	Local nI := 0
	Local nP := 0
	Local nElem := 0
	Local nTotal := 0
	Local nTotGeral := 0
	
	Local aOPER := {}
	Local aApuracao := {}
	
	cSQL := "SELECT (SELECT U7_NOME " + CRLF
	cSQL += "        FROM   "+RetSqlName( "SU7" )+" SU7 " + CRLF
	cSQL += "        WHERE  U7_FILIAL = "+ValToSql( xFilial( "SU7" ) )+" " + CRLF
	cSQL += "               AND U7_COD = UC_OPERADO " + CRLF
	cSQL += "               AND SU7.D_E_L_E_T_ = ' ') AS U7_NOME, " + CRLF
	cSQL += "       (SELECT U7_CODVEN " + CRLF
	cSQL += "        FROM   "+RetSqlName( "SU7" )+" SU7 " + CRLF
	cSQL += "        WHERE  U7_FILIAL = "+ValToSql( xFilial( "SU7" ) )+" " + CRLF
	cSQL += "               AND U7_COD = UC_OPERADO " + CRLF
	cSQL += "               AND SU7.D_E_L_E_T_ = ' ') AS U7_CODVEN, " + CRLF
	cSQL += "       UC_OPERADO, " + CRLF
	cSQL += "       UC_OPERACA, " + CRLF
	cSQL += "       CASE " + CRLF
	cSQL += "         WHEN UC_TIPO = ' ' THEN '0     ' " + CRLF
	cSQL += "         WHEN UC_TIPO <> ' ' THEN UC_TIPO " + CRLF
	cSQL += "       END AS UC_TIPO, " + CRLF
	cSQL += "       NVL((SELECT UL_DESC " + CRLF
	cSQL += "            FROM   "+RetSqlName( "SUL" )+"  SUL " + CRLF
	cSQL += "            WHERE  UL_FILIAL = "+ValToSql( xFilial( "SUL" ) )+" " + CRLF
	cSQL += "                   AND UL_TPCOMUN = UC_TIPO " + CRLF
	cSQL += "                   AND UL_VALIDO = '1' " + CRLF
	cSQL += "                   AND SUL.D_E_L_E_T_ = ' '),'NAO INFORMADO') AS UL_DESC, " + CRLF
	cSQL += "       COUNT(UC_TIPO) AS nUCTIPO " + CRLF
	cSQL += "FROM   "+RetSqlName( "SUD" ) +" SUD " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName( "SUC" )+ " SUC " + CRLF
	cSQL += "               ON UC_FILIAL = "+ValToSql( xFilial( "SUC" ) )+" " + CRLF
	cSQL += "                  AND UC_CODIGO = UD_CODIGO " + CRLF
	cSQL += "                  AND SUC.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND UC_DATA BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+" " + CRLF
	cSQL += "                  AND UC_OPERADO IN ( SELECT U7_COD " + CRLF
	cSQL += "                                      FROM   "+RetSqlName( "SU7" )+" SU7 " + CRLF
	cSQL += "                                             INNER JOIN "+RetSqlName( "SA3" )+" SA3 " + CRLF
	cSQL += "                                                     ON A3_FILIAL = "+ValToSql( xFilial( "SA3" ) )+" " + CRLF
	cSQL += "                                                        AND A3_COD = U7_CODVEN " + CRLF
	cSQL += "                                                        AND A3_XCANAL = "+ValToSql( c180Canal )+" " + CRLF
	cSQL += "                                                        AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                                                        AND SA3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                                      WHERE  U7_FILIAL = "+ValToSql( xFilial( "SU7" ) )+" " + CRLF
	cSQL += "                                             AND U7_COD BETWEEN "+ValToSql( c180ConsDe )+" AND "+ValToSql( c180ConsAte )+" " + CRLF
	cSQL += "                                             AND U7_VEND = '1' " + CRLF
	cSQL += "                                             AND U7_VALIDO = '1' " + CRLF
	cSQL += "                                             AND SU7.D_E_L_E_T_ = ' ') " + CRLF
	cSQL += "WHERE  UD_FILIAL = "+ValToSql( xFilial( "SUD" ) )+" " + CRLF
	cSQL += "       AND SUD.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "GROUP  BY UC_OPERADO, UC_OPERACA, UC_TIPO " + CRLF
	cSQL += "ORDER  BY UC_OPERADO, UC_OPERACA, UC_TIPO " + CRLF

   If l180Query
		A180Script( cSQL )   
   Endif

	nColSpace := 2
	cFont := 'Consolas'
	nFont := 9
	cOrient := 'PAISAGEM'
	n180Nome := 3
	aCab := {'NOME DO CONSULTOR','OPERADOR','VENDEDOR','OPER.','COMUNICADO','ATENDIDO'}
	aAlign := {'LEFT','LEFT','LEFT','LEFT','LEFT','RIGHT'}
	aPicture := {'@!','@!','@!','@!','@!','@E 9,999'}
	aSizeCol := {35,10,10,05,39,08}
	//           |  |  |  |  |  |
	//           |  |  |  |  |  +-----> 6 ATENDIDO
	//           |  |  |  |  +--------> 5 COMUNICADO
	//           |  |  |  +-----------> 4 OPERAÇÃO
	//           |  |  +--------------> 3 VENDEDOR
	//           |  +-----------------> 2 OPERADOR
	//           +--------------------> 1 NOME DO CONSULTOR
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	FwMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	aOPER := StrToKarr( Posicione( 'SX3', 2, 'UC_OPERACA', 'X3CBox()' ), ';' )
	
	ProcRegua(0)
	
	cKey := (cTRB)->(UC_OPERADO)
	
	While ! (cTRB)->( EOF() )
		IncProc()
		
		(cTRB)->( AAdd( aDados, { U7_NOME, ;
		                          UC_OPERADO, ;
		                          U7_CODVEN, ;
		                          SubStr(aOPER[Val((cTRB)->(UC_OPERACA))],3,5), ;
		                          UC_TIPO+' - '+UL_DESC, ;
		                          nUCTIPO } ) )
		                          
		nTotal += (cTRB)->( nUCTIPO )
		nTotGeral += (cTRB)->( nUCTIPO )
		
		nP := AScan( aApuracao, {|p| p[1]==(cTRB)->(UC_TIPO) })
		
		If nP == 0
			(cTRB)->( AAdd( aApuracao, { UC_TIPO, UL_DESC, nUCTIPO } ) )
		Else
			aApuracao[ nP, 3 ] += (cTRB)->(nUCTIPO)
		Endif
		
		(cTRB)->( dbSkip() )
		
		If cKey <> (cTRB)->(UC_OPERADO)
			cKey := (cTRB)->(UC_OPERADO)
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := 'LINHA'
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := 'TOTAL'
			aDados[ nElem, 6 ] := nTotal
			
			nTotal := 0
		Endif
	End	
	(cTRB)->(dbCloseArea())
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 6 ] := nTotGeral

	If Len( aApuracao ) > 0
		nTotal := 0
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := 'LINHA'
		
		For nI := 1 To Len( aApuracao )
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			
			If nI == 1
				aDados[ nElem, 1 ] := 'RESUMO POR TIPO COMUNICACAO'
			Endif
			
			aDados[ nElem, 5 ] := aApuracao[ nI, 1 ] +' - '+ aApuracao[ nI, 2 ]
			aDados[ nElem, 6 ] := aApuracao[ nI, 3 ]
			
			nTotal += aApuracao[ nI, 3 ]
		Next nI
	Endif
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL DA APURACAO'
	aDados[ nElem, 6 ] := nTotal
	
	oReport := A180Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
Return

//-----------------------------------------------------------------------
// Rotina | A180Prod   | Autor | Robson Gonçalves     | Data | 14.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento - visão por produto.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Prod()
	Local cSQL := ''
	Local cTRB := ''
	Local cKey := ''
	
	Local nElem := 0
	Local nTotal := 0
	Local nTotGeral := 0
	
	Local aOPER := {}
	
	cSQL := "SELECT (SELECT U7_NOME " + CRLF
	cSQL += "        FROM   "+RetSqlName("SU7")+" SU7 " + CRLF
	cSQL += "        WHERE  U7_FILIAL = "+ValToSql( xFilial("SU7") )+" " + CRLF
	cSQL += "               AND U7_COD = UC_OPERADO " + CRLF
	cSQL += "               AND SU7.D_E_L_E_T_ = ' ') AS U7_NOME, " + CRLF
	cSQL += "       (SELECT U7_CODVEN " + CRLF
	cSQL += "        FROM   "+RetSqlName("SU7")+" SU7 " + CRLF
	cSQL += "        WHERE  U7_FILIAL = "+ValToSql( xFilial("SU7") )+" " + CRLF
	cSQL += "               AND U7_COD = UC_OPERADO " + CRLF
	cSQL += "               AND SU7.D_E_L_E_T_ = ' ') AS U7_CODVEN, " + CRLF
	cSQL += "       UC_OPERADO, " + CRLF
	cSQL += "       UC_OPERACA, " + CRLF
	cSQL += "       UD_PRODUTO, " + CRLF
	cSQL += "       NVL(B1_DESC,'PRODUTO NAO INFORMADO') AS B1_DESC, " + CRLF
	cSQL += "       COUNT(UD_PRODUTO) AS nATENDIDO " + CRLF
	cSQL += "FROM   "+RetSqlName("SUD")+" SUD " + CRLF
	cSQL += "       LEFT JOIN "+RetSqlName("SB1")+" SB1 " + CRLF
	cSQL += "              ON B1_FILIAL = "+ValToSql( xFilial("SB1") )+" " + CRLF
	cSQL += "                 AND B1_COD = UD_PRODUTO " + CRLF
	cSQL += "                 AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SUC")+" SUC " + CRLF
	cSQL += "               ON UC_FILIAL = "+ValToSql( xFilial("SUC") )+" " + CRLF
	cSQL += "                  AND UC_CODIGO = UD_CODIGO " + CRLF
	cSQL += "                  AND SUC.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND UC_DATA BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+" " + CRLF
	cSQL += "                  AND UC_OPERADO IN ( SELECT U7_COD " + CRLF
	cSQL += "                                      FROM   "+RetSqlName("SU7")+" SU7 " + CRLF
	cSQL += "                                             INNER JOIN "+RetSqlName("SA3")+" SA3 " + CRLF
	cSQL += "                                                     ON A3_FILIAL = "+ValToSql( xFilial("SA3") )+" " + CRLF
	cSQL += "                                                        AND A3_COD = U7_CODVEN " + CRLF
	cSQL += "                                                        AND A3_XCANAL = "+ValToSql( c180Canal )+" " + CRLF
	cSQL += "                                                        AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                                                        AND SA3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                                      WHERE  U7_FILIAL = "+ValToSql( xFilial("SU7") )+" " + CRLF
	cSQL += "                                             AND U7_COD BETWEEN "+ValToSql( c180ConsDe )+" AND "+ValToSql( c180ConsAte )+" " + CRLF
	cSQL += "                                             AND U7_VEND = '1' " + CRLF
	cSQL += "                                             AND U7_VALIDO = '1' " + CRLF
	cSQL += "                                             AND SU7.D_E_L_E_T_ = ' ') " + CRLF
	cSQL += "WHERE  UD_FILIAL = "+ValToSql( xFilial("SUD") )+" " + CRLF
	cSQL += "       AND SUD.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "GROUP  BY UC_OPERADO, UC_OPERACA, UD_PRODUTO, B1_DESC " + CRLF
	cSQL += "ORDER  BY UC_OPERADO, UC_OPERACA, UD_PRODUTO" + CRLF

   If l180Query
		A180Script( cSQL )   
   Endif

	nColSpace := 2
	cFont := 'Consolas'
	nFont := 9
	cOrient := 'PAISAGEM'
	n180Nome := 3
	aCab := {'NOME DO CONSULTOR','OPERADOR','VENDEDOR','OPER.','PRODUTO','DESCR.PRODUTO','ATENDIDO'}
	aAlign := {'LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','RIGHT'}
	aPicture := {'@!','@!','@!','@!','@!','@!','@E 9,999'}
	aSizeCol := {32,10,10,05,15,32,08}
	//           |  |  |  |  |  |  |
	//           |  |  |  |  |  |  +--> 7 ATENDIDO
	//           |  |  |  |  |  +-----> 6 DESCRIÇÃO
	//           |  |  |  |  +--------> 5 PRODUTO
	//           |  |  |  +-----------> 4 OPERAÇÃO (1=RECEPTIVO;2=ATIVO)
	//           |  |  +--------------> 3 VENDEDOR
	//           |  +-----------------> 2 OPERADOR
	//           +--------------------> 1 NOME DO CONSULTOR
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	FwMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	aOPER := StrToKarr( Posicione( 'SX3', 2, 'UC_OPERACA', 'X3CBox()' ), ';' )
	
	ProcRegua(0)
	
	cKey := (cTRB)->(UC_OPERADO)
	
	While ! (cTRB)->( EOF() )
		IncProc()
		
		(cTRB)->( AAdd( aDados, { U7_NOME, ;
		                          UC_OPERADO, ;
		                          U7_CODVEN, ;
		                          SubStr(aOPER[Val((cTRB)->(UC_OPERACA))],3,5), ;
		                          UD_PRODUTO, ;
		                          B1_DESC, ;
		                          nATENDIDO } ) )
		                          
		nTotal += (cTRB)->(nATENDIDO)
		nTotGeral += (cTRB)->(nATENDIDO)
		
		(cTRB)->( dbSkip() )
		
		If cKey <> (cTRB)->(UC_OPERADO)
			cKey := (cTRB)->(UC_OPERADO)
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := 'LINHA'
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := 'TOTAL'
			aDados[ nElem, 7 ] := nTotal
			
			nTotal := 0
		Endif
	End	
	(cTRB)->(dbCloseArea())
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'LINHA'

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 7 ] := nTotGeral

	oReport := A180Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
Return

//-----------------------------------------------------------------------
// Rotina | A180Rankin | Autor | Robson Gonçalves     | Data | 22.08.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento - visão por ranking de produto.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Rankin()
	Local cSQL := ''
	Local cTRB := ''
	Local cKey := ''
	
	Local nElem := 0
	Local nTotal := 0
	Local nTotReg := 0
	
	cSQL := "SELECT COUNT(*) AS nCOUNT " + CRLF 
	cSQL += "FROM   (SELECT UD_PRODUTO  " + CRLF 
	cSQL += "        FROM   "+RetSQLName("SUD")+" SUD  " + CRLF 
	cSQL += "               INNER JOIN "+RetSqlName("SUC")+" SUC " + CRLF 
	cSQL += "                       ON UC_FILIAL = "+ValToSql(xFilial("SUC"))+" " + CRLF 
	cSQL += "                          AND UC_CODIGO = UD_CODIGO " + CRLF 
	cSQL += "                          AND SUC.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "                          AND UC_DATA BETWEEN "+ValToSql(d180PerDe)+" AND "+ValToSql(d180PerAte)+" " + CRLF 
	cSQL += "                          AND UC_OPERADO IN (SELECT U7_COD " + CRLF 
	cSQL += "                                             FROM   "+RetSqlName("SU7")+" SU7 " + CRLF 
	cSQL += "                              INNER JOIN "+RetSqlName("SA3")+" SA3 " + CRLF 
	cSQL += "                                      ON A3_FILIAL = "+ValToSql(xFilial("SA3"))+" " + CRLF 
	cSQL += "                                         AND A3_COD = U7_CODVEN " + CRLF 
	cSQL += "                                         AND A3_XCANAL = "+ValToSql(c180Canal)+" " + CRLF 
	cSQL += "                                         AND A3_MSBLQL <> '1' " + CRLF 
	cSQL += "                                         AND SA3.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "                                             WHERE  U7_FILIAL = "+ValToSql(xFilial("SU7"))+" " + CRLF 
	cSQL += "                                                    AND U7_COD BETWEEN "+ValToSql(c180ConsDe)+" AND "+ValToSql(c180ConsAte)+" " + CRLF 
	cSQL += "                                                    AND U7_VEND = '1' " + CRLF 
	cSQL += "                                                    AND U7_VALIDO = '1' " + CRLF 
	cSQL += "                                                    AND SU7.D_E_L_E_T_ = ' ') " + CRLF 
	cSQL += "        WHERE  UD_FILIAL = "+ValToSql(xFilial("SUD"))+" " + CRLF 
	cSQL += "               AND SUD.D_E_L_E_T_ = ' ') QRY_TEMP " + CRLF 
	
   If l180Query
		A180Script( cSQL )   
   Endif
   
	DbUseArea( .T., "TOPCONN", TCGENQRY( , , cSQL ), "QRY_TEMP", .F., .T. )
	nTotReg := QRY_TEMP->nCOUNT
	QRY_TEMP->(DbCloseArea())
	
	cSQL := "SELECT UD_PRODUTO, " + CRLF 
	cSQL += "       NVL(B1_DESC, 'SEM PRODUTO') AS B1_DESC, " + CRLF 
	cSQL += "       COUNT(UD_PRODUTO)           AS nATENDIDO " + CRLF 
	cSQL += "FROM   "+RetSqlName("SUD")+" SUD " + CRLF 
	cSQL += "       LEFT JOIN "+RetSqlName("SB1")+" SB1 " + CRLF 
	cSQL += "              ON B1_FILIAL = "+ValToSql(xFilial("SB1"))+" " + CRLF 
	cSQL += "                 AND B1_COD = UD_PRODUTO " + CRLF 
	cSQL += "                 AND SB1.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SUC")+" SUC " + CRLF 
	cSQL += "               ON UC_FILIAL = "+ValToSql(xFilial("SUC"))+" " + CRLF 
	cSQL += "                  AND UC_CODIGO = UD_CODIGO " + CRLF 
	cSQL += "                  AND SUC.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "                  AND UC_DATA BETWEEN "+ValToSql(d180PerDe)+" AND "+ValToSql(d180PerAte)+" " + CRLF 
	cSQL += "                  AND UC_OPERADO IN (SELECT U7_COD " + CRLF 
	cSQL += "                                     FROM   "+RetSqlName("SU7")+" SU7 " + CRLF 
	cSQL += "                                            INNER JOIN "+RetSqlName("SA3")+" SA3 " + CRLF 
	cSQL += "                                                    ON A3_FILIAL = "+ValToSql(xFilial("SA3"))+" " + CRLF 
	cSQL += "                                                       AND A3_COD = U7_CODVEN " + CRLF 
	cSQL += "                                                       AND A3_XCANAL = "+ValToSql(c180Canal)+" " + CRLF 
	cSQL += "                                                       AND A3_MSBLQL <> '1' " + CRLF 
	cSQL += "                                                       AND SA3.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "                                     WHERE  U7_FILIAL = "+ValToSql(xFilial("SU7"))+" " + CRLF 
	cSQL += "                                            AND U7_COD BETWEEN "+ValToSql(c180ConsDe)+" AND "+ValToSql(c180ConsAte)+" " + CRLF 
	cSQL += "                                            AND U7_VEND = '1' " + CRLF 
	cSQL += "                                            AND U7_VALIDO = '1' " + CRLF 
	cSQL += "                                            AND SU7.D_E_L_E_T_ = ' ') " + CRLF 
	cSQL += "WHERE  UD_FILIAL = "+ValToSql(xFilial("SUD"))+" " + CRLF 
	cSQL += "       AND SUD.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "GROUP  BY UD_PRODUTO, B1_DESC  " + CRLF 
	cSQL += "ORDER  BY nATENDIDO DESC " + CRLF 

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	FwMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif

	nColSpace := 2
	cFont := 'Consolas'
	nFont := 9
	cOrient := 'RETRATO'
	n180Nome := 1
	aCab := {'PRODUTO','DESCRIÇÃO PRODUTO','ATENDIDO','% ATEND'}
	aAlign := {'LEFT','LEFT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@E 9,999','@E 999.99'}
	aSizeCol := {40,30,08,07}
	//           |  |  |  +--------> 4 % DA QUANTIDADE
	//           |  |  +-----------> 3 QUANTIDADE ATENDIDO
	//           |  +--------------> 2 DESCRIÇÃO DO PRODUTO
	//           +-----------------> 1 CODIGO DO PRODUTO
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	FwMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	ProcRegua(0)
	
	While ! (cTRB)->( EOF() )
		IncProc()
		
		(cTRB)->( AAdd( aDados, { UD_PRODUTO, B1_DESC, nATENDIDO, (nATENDIDO/nTotReg)*100 } ) )
		nTotal += (cTRB)->(nATENDIDO)
		
		(cTRB)->( dbSkip() )
	End	
	(cTRB)->(dbCloseArea())
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'LINHA'

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL'
	aDados[ nElem, 3 ] := nTotal

	oReport := A180Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
Return

//-----------------------------------------------------------------------
// Rotina | A180MpDia  | Autor | Robson Gonçalves     | Data | 18.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento - visão por mapa dia.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180MpDia()
	Local cSQL := ''
	Local cTRB := ''
	Local cKey := ''
	
	Local nElem := 0
	Local nAberto := 0
	Local nEncerr := 0
	Local nTAberto := 0
	Local nTEncerr := 0
	
	cSQL := "SELECT NOME, " + CRLF 
	cSQL += "       OPERADOR,  " + CRLF 
	cSQL += "       VENDEDOR,  " + CRLF 
	cSQL += "       PERIODO,  " + CRLF 
	cSQL += "       SUM(CASE  " + CRLF 
	cSQL += "             WHEN STATUS = 'ABERTO' THEN QUANT  " + CRLF 
	cSQL += "             ELSE 0  " + CRLF 
	cSQL += "           END) AS ABERTO,  " + CRLF 
	cSQL += "       SUM(CASE  " + CRLF 
	cSQL += "             WHEN STATUS = 'ENCERRADO' THEN QUANT  " + CRLF 
	cSQL += "             ELSE 0  " + CRLF 
	cSQL += "           END) AS ENCERRADO  " + CRLF 
	cSQL += "FROM   (SELECT 'ABERTO'               STATUS,  " + CRLF 
	cSQL += "               U7_NOME                NOME,  " + CRLF 
	cSQL += "               U4_OPERAD              OPERADOR,  " + CRLF 
	cSQL += "               U7_CODVEN              VENDEDOR,  " + CRLF 
	cSQL += "               U4_DATA                PERIODO,  " + CRLF 
	cSQL += "               NVL(COUNT(U4_DATA), 0) AS QUANT  " + CRLF 
	cSQL += "        FROM   "+RetSqlName("SU4")+" SU4  " + CRLF 
	cSQL += "               INNER JOIN "+RetSqlName("SU6")+" SU6  " + CRLF 
	cSQL += "                       ON U6_FILIAL = "+ValToSql( xFilial("SU6") )+"  " + CRLF 
	cSQL += "                          AND U6_LISTA = U4_LISTA  " + CRLF 
	cSQL += "                          AND U6_STATUS = '1'  " + CRLF 
	cSQL += "                          AND SU6.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "               INNER JOIN "+RetSqlName("SU7")+" SU7  " + CRLF 
	cSQL += "                       ON U7_FILIAL = "+ValToSql( xFilial("SU7") )+"  " + CRLF 
	cSQL += "                          AND U7_COD = U4_OPERAD  " + CRLF 
	cSQL += "                          AND SU7.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "               INNER JOIN "+RetSqlName("SA3")+" SA3  " + CRLF 
	cSQL += "                       ON A3_FILIAL = "+ValToSql( xFilial("SA3") )+"  " + CRLF 
	cSQL += "                          AND A3_COD = U7_CODVEN  " + CRLF 
	cSQL += "                          AND A3_XCANAL = "+ValToSql( c180Canal )+"  " + CRLF 
	cSQL += "                          AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                          AND SA3.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "        WHERE  U4_FILIAL = "+ValToSql( xFilial("SU4") )+"  " + CRLF 
	cSQL += "               AND U4_DATA BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+"  " + CRLF 
	cSQL += "               AND U4_STATUS = '1'  " + CRLF 
	cSQL += "               AND U4_TELE = '1'  " + CRLF 
	cSQL += "               AND ( U4_FORMA = '1'  " + CRLF 
	cSQL += "                      OR U4_FORMA = '5'  " + CRLF 
	cSQL += "                      OR U4_FORMA = '6' )  " + CRLF 
	cSQL += "               AND U4_OPERAD BETWEEN "+ValToSql( c180ConsDe )+" AND "+ValToSql( c180ConsAte )+"  " + CRLF 
	cSQL += "               AND SU4.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "        GROUP  BY U4_OPERAD,  " + CRLF 
	cSQL += "                  U4_DATA,  " + CRLF 
	cSQL += "                  U7_NOME,  " + CRLF 
	cSQL += "                  U7_CODVEN  " + CRLF 
	cSQL += "        UNION  " + CRLF 
	cSQL += "        SELECT 'ENCERRADO'               STATUS,  " + CRLF 
	cSQL += "               U7_NOME                   NOME,  " + CRLF 
	cSQL += "               U4_OPERAD                 OPERADOR,  " + CRLF 
	cSQL += "               U7_CODVEN                 VENDEDOR,  " + CRLF 
	cSQL += "               U6_DTATEND                PERIODO,  " + CRLF 
	cSQL += "               NVL(COUNT(U6_DTATEND), 0) AS QUANT  " + CRLF 
	cSQL += "        FROM   "+RetSqlName("SU4")+" SU4  " + CRLF 
	cSQL += "               INNER JOIN "+RetSqlName("SU6")+" SU6  " + CRLF 
	cSQL += "                       ON U6_FILIAL = "+ValToSql( xFilial("SU6") )+"  " + CRLF 
	cSQL += "                          AND U6_LISTA = U4_LISTA  " + CRLF 
	cSQL += "                          AND U6_STATUS <> '1'  " + CRLF 
	cSQL += "                          AND U6_DTATEND BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+"  " + CRLF 
	cSQL += "                          AND SU6.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "               INNER JOIN "+RetSqlName("SU7")+" SU7  " + CRLF 
	cSQL += "                       ON U7_FILIAL = "+ValToSql( xFilial("SU7") )+"  " + CRLF 
	cSQL += "                          AND U7_COD = U4_OPERAD  " + CRLF 
	cSQL += "                          AND SU7.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "               INNER JOIN "+RetSqlName("SA3")+" SA3  " + CRLF 
	cSQL += "                       ON A3_FILIAL = "+ValToSql( xFilial("SA3") )+"  " + CRLF 
	cSQL += "                          AND A3_COD = U7_CODVEN  " + CRLF 
	cSQL += "                          AND A3_XCANAL = "+ValToSql( c180Canal )+"  " + CRLF 
	cSQL += "                          AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                          AND SA3.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "        WHERE  U4_FILIAL = "+ValToSql( xFilial("SU4") )+"  " + CRLF 
	cSQL += "               AND ( U4_STATUS = '1'  " + CRLF 
	cSQL += "                      OR U4_STATUS = '2' )  " + CRLF 
	cSQL += "               AND U4_TELE = '1'  " + CRLF 
	cSQL += "               AND ( U4_FORMA = '1'  " + CRLF 
	cSQL += "                      OR U4_FORMA = '5'  " + CRLF 
	cSQL += "                      OR U4_FORMA = '6' )  " + CRLF 
	cSQL += "               AND U4_OPERAD BETWEEN "+ValToSql( c180ConsDe )+" AND "+ValToSql( c180ConsAte )+"  " + CRLF 
	cSQL += "               AND SU4.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "        GROUP  BY U4_OPERAD,  " + CRLF 
	cSQL += "                  U6_DTATEND,  " + CRLF 
	cSQL += "                  U7_NOME,  " + CRLF 
	cSQL += "                  U7_CODVEN) RESULTADO  " + CRLF 
	cSQL += "GROUP  BY NOME,  " + CRLF 
	cSQL += "          OPERADOR,  " + CRLF 
	cSQL += "          VENDEDOR,  " + CRLF 
	cSQL += "          PERIODO  " + CRLF 
	cSQL += "ORDER  BY OPERADOR,  " + CRLF 
	cSQL += "          PERIODO " + CRLF 
	
   If l180Query
		A180Script( cSQL )   
   Endif

	nColSpace := 2
	cFont := 'Consolas'
	nFont := 9
	cOrient := 'RETRATO'
	n180Nome := 3
	aCab := {'NOME DO CONSULTOR','OPERADOR','VENDEDOR','PERIODO','ABERTO','ATENDIDO','TOTAL'}
	aAlign := {'LEFT','LEFT','LEFT','LEFT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@!','@!','@E 9,999','@E 9,999','@E 9,999'}
	aSizeCol := {30,10,10,08,05,08,05}
	//           |  |  |  |  |  |  |
	//           |  |  |  |  |  |  +-> 7 TOTAL
	//           |  |  |  |  |  +----> 6 ATENDIDO
	//           |  |  |  |  +-------> 5 ABERTO
	//           |  |  |  +----------> 4 PERIODO
	//           |  |  +-------------> 3 VENDEDOR
	//           |  +----------------> 2 OPERADOR
	//           +-------------------> 1 NOME DO CONSULTOR
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	FwMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	TcSetField(cTRB,"PERIODO" ,"D",8,0)
	TcSetField(cTRB,"ABERTO"  ,"N",5,0)
	TcSetField(cTRB,"ATENDIDO","N",5,0)
	
	ProcRegua(0)
	
	cKey := (cTRB)->(OPERADOR)
	
	While ! (cTRB)->( EOF() )
		IncProc()
		
		(cTRB)->( AAdd( aDados, { NOME, OPERADOR, VENDEDOR, PERIODO, ABERTO, ENCERRADO, ABERTO + ENCERRADO } ) )
		nAberto += (cTRB)->(ABERTO)
		nEncerr += (cTRB)->(ENCERRADO)
		
		nTAberto += (cTRB)->(ABERTO)
		nTEncerr += (cTRB)->(ENCERRADO)
		
		(cTRB)->( dbSkip() )
		
		If cKey <> (cTRB)->(OPERADOR)
			cKey := (cTRB)->(OPERADOR)
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := 'LINHA'
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			
			aDados[ nElem, 1 ] := 'TOTAL'
			aDados[ nElem, 5 ] := nAberto
			aDados[ nElem, 6 ] := nEncerr
			aDados[ nElem, 7 ] := nAberto + nEncerr
			
			nAberto := 0
			nEncerr := 0
		Endif
	End	
	(cTRB)->(dbCloseArea())

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'LINHA'

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 5 ] := nTAberto
	aDados[ nElem, 6 ] := nTEncerr
	aDados[ nElem, 7 ] := nTAberto + nTEncerr

	oReport := A180Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
Return

//-----------------------------------------------------------------------
// Rotina | A180MpTabu | Autor | Robson Gonçalves     | Data | 18.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento - visão por mapa por tabulação.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180MpTabu()
	Local cSQL := ''
	Local cTRB := ''
	Local cKey := ''
	
	Local nElem := 0
	Local nTotal := 0
	Local nGeral := 0
	
	Local aOPER := {}
	
	cSQL := "SELECT U7_NOME, " + CRLF 
	cSQL += "       UC_OPERADO, " + CRLF 
	cSQL += "       U7_CODVEN, " + CRLF
	cSQL += "       UC_OPERACA, " + CRLF
	cSQL += "       UD_ASSUNTO,  " + CRLF 
	cSQL += "       X5_DESCRI, " + CRLF 
	cSQL += "       UD_OCORREN,  " + CRLF 
	cSQL += "       U9_DESC, " + CRLF 
	cSQL += "       UX_CODTPO, " + CRLF 
	cSQL += "       UX_DESTOC, " + CRLF 
	cSQL += "       UD_SOLUCAO,  " + CRLF 
	cSQL += "       UQ_DESC, " + CRLF 
	cSQL += "       QUANT " + CRLF 
	cSQL += "       FROM (SELECT UC_OPERADO,  " + CRLF 
	cSQL += "                    UC_OPERACA,  " + CRLF
	cSQL += "                    UD_ASSUNTO,  " + CRLF 
	cSQL += "                    UD_OCORREN,  " + CRLF 
	cSQL += "                    UD_SOLUCAO, " + CRLF 
	cSQL += "                    COUNT(UC_OPERADO||UC_OPERACA||UD_ASSUNTO||UD_OCORREN||UD_SOLUCAO) AS QUANT " + CRLF 
	cSQL += "              FROM   "+RetSqlName("SUD")+" SUD " + CRLF 
	cSQL += "                     INNER JOIN "+RetSqlName("SUC")+" SUC " + CRLF 
	cSQL += "                             ON UC_FILIAL = "+ValToSql( xFilial( "SUC" ) )+" " + CRLF 
	cSQL += "                                AND SUC.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "                                AND UC_OPERADO IN ( " + CRLF 
	cSQL += "                                SELECT U7_COD " + CRLF 
	cSQL += "                                FROM   "+RetSqlName("SU7")+" SU7 " + CRLF 
	cSQL += "                                       INNER JOIN "+RetSqlName("SA3")+" SA3 " + CRLF 
	cSQL += "                                               ON A3_FILIAL = "+ValToSql( xFilial( "SA3" ) )+" " + CRLF 
	cSQL += "                                                  AND A3_COD = U7_CODVEN " + CRLF 
	cSQL += "                                                  AND A3_XCANAL = "+ValToSql( c180Canal )+" " + CRLF 
	cSQL += "                                                   AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                                                  AND SA3.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "                                WHERE  U7_FILIAL = '  ' " + CRLF 
	cSQL += "                                       AND U7_COD BETWEEN "+ValToSql( c180ConsDe )+" AND "+ValToSql( c180ConsAte )+" " + CRLF 
	cSQL += "                                       AND SU7.D_E_L_E_T_ = ' ' ) " + CRLF 
	cSQL += "              WHERE  UD_FILIAL = "+ValToSql( xFilial( "SUD" ) )+" " + CRLF 
	cSQL += "                     AND UD_DATA BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+" " + CRLF 
	cSQL += "                     AND UD_CODIGO = UC_CODIGO " + CRLF 
	cSQL += "                     AND SUD.D_E_L_E_T_ = ' '     " + CRLF 
	cSQL += "              GROUP BY UC_OPERADO, UC_OPERACA, UD_ASSUNTO, UD_OCORREN, UD_SOLUCAO ) RESULT1 " + CRLF 
	cSQL += "              INNER JOIN "+RetSqlName("SX5")+" SX5  " + CRLF 
	cSQL += "                      ON X5_FILIAL = "+ValToSql( xFilial( "SX5" ) )+" " + CRLF 
	cSQL += "                         AND X5_TABELA = 'T1' " + CRLF 
	cSQL += "                         AND X5_CHAVE = UD_ASSUNTO " + CRLF 
	cSQL += "                         AND SX5.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "              INNER JOIN "+RetSqlName("SU9")+" SU9  " + CRLF 
	cSQL += "                      ON U9_FILIAL = "+ValToSql( xFilial( "SU9" ) )+"  " + CRLF 
	cSQL += "                         AND U9_ASSUNTO = UD_ASSUNTO " + CRLF 
	cSQL += "                         AND U9_CODIGO = UD_OCORREN " + CRLF 
	cSQL += "                         AND SU9.D_E_L_E_T_ = ' ' " + CRLF 
	cSQL += "              INNER JOIN "+RetSqlName("SUX")+" SUX " + CRLF 
	cSQL += "                      ON UX_FILIAL = "+ValToSql( xFilial( "SUX" ) )+" " + CRLF 
	cSQL += "                         AND UX_CODTPO = U9_TIPOOCO " + CRLF 
	cSQL += "                         AND SUX.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "              INNER JOIN "+RetSqlName("SUQ")+" SUQ " + CRLF 
	cSQL += "                      ON UQ_FILIAL = "+ValToSql( xFilial( "SUQ" ) )+" " + CRLF 
	cSQL += "                         AND UQ_SOLUCAO = UD_SOLUCAO " + CRLF 
	cSQL += "                         AND SUQ.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "              INNER JOIN "+RetSqlName("SU7")+" U7 " + CRLF 
	cSQL += "                      ON U7_FILIAL = "+ValToSql( xFilial( "SU7" ) )+" " + CRLF 
	cSQL += "                         AND U7.U7_COD = UC_OPERADO " + CRLF 
	cSQL += "                         AND U7.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "ORDER BY U7_NOME, UC_OPERACA, UD_ASSUNTO, UD_OCORREN, UD_SOLUCAO " + CRLF 

   If l180Query
		A180Script( cSQL )   
   Endif

	nColSpace := 2
	cFont := 'Courier New'
	nFont := 6
	cOrient := 'PAISAGEM'
	n180Nome := 3
	aCab := {'NOME DO CONSULTOR','OPERADOR','VENDEDOR','OPER.','ASSUNTO','DESCR.ASSUNTO','OCORRENCIA','DESCR.OCORRENCIA','COMPL.','DESCR.COMPL.','AÇÃO','DESCR.AÇÃO','ATEND.'}
	aAlign := {'LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','RIGHT'}
	aPicture := {'@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@E 9,999'}
	aSizeCol := {35,08,08,05,07,26,10,26,06,26,06,29,05}
	//           |  |  |  |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  |  |  |  +-> 13 Nº ATENDIMENTOS
	//           |  |  |  |  |  |  |  |  |  |  |  +----> 12 DESCRIÇÃO DA AÇÃO
	//           |  |  |  |  |  |  |  |  |  |  +-------> 11 AÇÃO
	//           |  |  |  |  |  |  |  |  |  +----------> 10 DESCRIÇÃO DO COMPL.DA OCORR.
	//           |  |  |  |  |  |  |  |  +-------------> 09 COMPL.
	//           |  |  |  |  |  |  |  +----------------> 08 DESCRIÇÃO DA OCORRÊNCIA
	//           |  |  |  |  |  |  +-------------------> 07 OCORRÊNCIA
	//           |  |  |  |  |  +----------------------> 06 DESCRIÇÃO DO ASSUNTO
	//           |  |  |  |  +-------------------------> 05 ASSUNTO
	//           |  |  |  +----------------------------> 04 OPERAÇÃO (1=RECEPTIVO;2=ATIVO)
	//           |  |  +-------------------------------> 03 VENDEDOR
	//           |  +----------------------------------> 02 OPERADOR
	//           +-------------------------------------> 01 NOME DO CONSULTOR
		
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	FwMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	TcSetField(cTRB,'QUANT','N',5,0)
	
	aOPER := StrToKarr( Posicione( 'SX3', 2, 'UC_OPERACA', 'X3CBox()' ), ';' )

	ProcRegua(0)
	
	cKey := (cTRB)->(UC_OPERADO)
	
	While ! (cTRB)->( EOF() )
		IncProc()
		
		(cTRB)->( AAdd( aDados, {  U7_NOME, ;
		                           UC_OPERADO, ;
		                           U7_CODVEN, ;
		                           SubStr(aOPER[Val((cTRB)->(UC_OPERaca))],3,5), ;
		                           UD_ASSUNTO, ;
		                           X5_DESCRI, ;
		                           UD_OCORREN, ;
		                           U9_DESC, ;
		                           UX_CODTPO, ;
		                           UX_DESTOC, ;
		                           UD_SOLUCAO, ;
		                           UQ_DESC, ;
		                           QUANT } ) )
		nTotal += (cTRB)->(QUANT)
		nGeral += (cTRB)->(QUANT)
		
		(cTRB)->( dbSkip() )
		
		If cKey <> (cTRB)->(UC_OPERADO)
			cKey := (cTRB)->(UC_OPERADO)
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := 'LINHA'
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			
			aDados[ nElem,  1 ] := 'TOTAL'
			aDados[ nElem, 13 ] := nTotal
			
			nTotal := 0
		Endif
	End	
	(cTRB)->(dbCloseArea())

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'LINHA'

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem,  1 ] := 'TOTAL GERAL'
	aDados[ nElem, 13 ] := nGeral

	oReport := A180Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
Return

//-----------------------------------------------------------------------
// Rotina | A180RAtend | Autor | Robson Gonçalves     | Data | 21.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento - visão registro de atendimento.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180RAtend()
	Local cSQL := ''
	Local cTRB := ''
	Local cKey := ''
	Local cUC_CODCONT := ''
	Local cU5_CONTAT := ''
	
	Local nI := 0
	Local nElem := 0
	
	Local aAssunto := {}
	Local aOcorren := {}
	Local aCompl := {}
	Local aAcao := {}

	cSQL += "SELECT UC_CODIGO,  " + CRLF 
	cSQL += "       UD_ITEM,  " + CRLF 
	cSQL += "       CASE  " + CRLF 
	cSQL += "         WHEN UC_OPERACA = '1' THEN 'RECEP'  " + CRLF 
	cSQL += "         WHEN UC_OPERACA = '2' THEN 'ATIVO'  " + CRLF 
	cSQL += "       END             AS UC_OPERACA,  " + CRLF 
	cSQL += "       CASE  " + CRLF 
	cSQL += "         WHEN UC_STATUS = '1' THEN 'PLANEJ'  " + CRLF 
	cSQL += "         WHEN UC_STATUS = '2' THEN 'PENDEN'  " + CRLF 
	cSQL += "         WHEN UC_STATUS = '3' THEN 'ENCERR'  " + CRLF 
	cSQL += "       END             AS UC_STATUS,  " + CRLF 
	cSQL += "       UC_CODCONT,  " + CRLF 
	cSQL += "       U5_CONTAT,  " + CRLF 
	cSQL += "       UC_ENTIDAD AS UC_SIGLA,  " + CRLF 
	cSQL += "       CASE  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'SZT' THEN 'RENOV. SSL COMMON NAME'  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'SZX' THEN 'RENOV. ICP-BRASIL'  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'PAB' THEN 'LISTAS DE CONTATOS'  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'SA1' THEN 'CLIENTES'  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'SUS' THEN 'PROSPECTS'  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'ACH' THEN 'SUSPECTS'  " + CRLF 
	cSQL += "       END             AS UC_ENTIDAD,  " + CRLF 
	cSQL += "       RTRIM(UC_CHAVE) AS UC_CHAVE,  " + CRLF 
	cSQL += "       CASE  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'SZT' THEN (SELECT ZT_EMPRESA  " + CRLF 
	cSQL += "                                       FROM   "+RetSqlName("SZT")+" SZT  " + CRLF 
	cSQL += "                                       WHERE  ZT_FILIAL = "+ValToSql( xFilial( "SZT" ) )+"  " + CRLF 
	cSQL += "                                              AND ZT_CODIGO = RTRIM(UC_CHAVE)  " + CRLF 
	cSQL += "                                              AND SZT.D_E_L_E_T_ = ' ')  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'SZX' THEN (SELECT ZX_DSRAZAO  " + CRLF 
	cSQL += "                                       FROM   "+RetSqlName("SZX")+" SZX  " + CRLF 
	cSQL += "                                       WHERE  ZX_FILIAL = "+ValToSql( xFilial( "SZX" ) )+"  " + CRLF 
	cSQL += "                                              AND ZX_CODIGO = RTRIM(UC_CHAVE)  " + CRLF 
	cSQL += "                                              AND SZX.D_E_L_E_T_ = ' ')  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'SA1' THEN (SELECT A1_NOME  " + CRLF 
	cSQL += "                                       FROM   "+RetSqlName("SA1")+" SA1  " + CRLF 
	cSQL += "                                       WHERE  A1_FILIAL = "+ValToSql( xFilial( "SA1" ) )+"  " + CRLF 
	cSQL += "                                              AND A1_COD  " + CRLF 
	cSQL += "                                                  || A1_LOJA = RTRIM(UC_CHAVE)  " + CRLF 
	cSQL += "                                              AND SA1.D_E_L_E_T_ = ' ')  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'PAB' THEN (SELECT PAB_NOME  " + CRLF 
	cSQL += "                                       FROM   "+RetSqlName("PAB")+" PAB  " + CRLF 
	cSQL += "                                       WHERE  PAB_FILIAL = "+ValToSql( xFilial( "PAB" ) )+"  " + CRLF 
	cSQL += "                                              AND PAB_CODIGO = RTRIM(UC_CHAVE)  " + CRLF 
	cSQL += "                                              AND PAB.D_E_L_E_T_ = ' ')  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'SUS' THEN (SELECT US_NOME  " + CRLF 
	cSQL += "                                       FROM   "+RetSqlName("SUS")+" SUS  " + CRLF 
	cSQL += "                                       WHERE  US_FILIAL = "+ValToSql( xFilial( "SUS" ) )+"  " + CRLF 
	cSQL += "                                              AND US_COD  " + CRLF 
	cSQL += "                                                  || US_LOJA = RTRIM(UC_CHAVE)  " + CRLF 
	cSQL += "                                              AND SUS.D_E_L_E_T_ = ' ')  " + CRLF 
	cSQL += "         WHEN UC_ENTIDAD = 'ACH' THEN (SELECT ACH_RAZAO  " + CRLF 
	cSQL += "                                       FROM   "+RetSqlName("ACH")+" ACH  " + CRLF 
	cSQL += "                                       WHERE  ACH_FILIAL = "+ValToSql( xFilial( "ACH" ) )+"  " + CRLF 
	cSQL += "                                              AND ACH_CODIGO  " + CRLF 
	cSQL += "                                                  || ACH_LOJA = RTRIM(UC_CHAVE)  " + CRLF 
	cSQL += "                                              AND ACH.D_E_L_E_T_ = ' ')  " + CRLF 
	cSQL += "       END             AS UC_NOMENT,  " + CRLF 
	cSQL += "       UC_OPERADO,  " + CRLF 
	cSQL += "       U7_NOME,  " + CRLF 
	cSQL += "       UC_DATA,  " + CRLF 
	cSQL += "       UC_FIM,  " + CRLF 
	cSQL += "       UD_ASSUNTO,  " + CRLF 
	cSQL += "       UD_OCORREN,  " + CRLF 
	cSQL += "       U9_TIPOOCO,  " + CRLF 
	cSQL += "       UD_SOLUCAO,  " + CRLF 
	cSQL += "       CASE  " + CRLF 
	cSQL += "         WHEN UD_STATUS = '1' THEN 'PENDEN'  " + CRLF 
	cSQL += "         WHEN UD_STATUS = '2' THEN 'ENCERR'  " + CRLF 
	cSQL += "         ELSE ' '  " + CRLF 
	cSQL += "       END             AS UD_STATUS,  " + CRLF 
	cSQL += "       X5_DESCRI, " + CRLF 
	cSQL += "       U9_DESC, " + CRLF 
	cSQL += "       UX_CODTPO, " + CRLF 
	cSQL += "       UX_DESTOC, " + CRLF 
	cSQL += "       UQ_DESC, " + CRLF 
	cSQL += "       UD_PRODUTO, " + CRLF 
	cSQL += "       B1_DESC " + CRLF 
	cSQL += "FROM   (SELECT UC_CODIGO, " + CRLF 
	cSQL += "               UD_ITEM, " + CRLF 
	cSQL += "               UC_OPERACA,  " + CRLF 
	cSQL += "               UC_STATUS,  " + CRLF 
	cSQL += "               UC_CODCONT,  " + CRLF 
	cSQL += "               UC_ENTIDAD,  " + CRLF 
	cSQL += "               UC_CHAVE,  " + CRLF 
	cSQL += "               UC_OPERADO,  " + CRLF 
	cSQL += "               UC_DATA,  " + CRLF 
	cSQL += "               UC_FIM,  " + CRLF 
	cSQL += "               UD_ASSUNTO,  " + CRLF 
	cSQL += "               UD_OCORREN,  " + CRLF 
	cSQL += "               UD_SOLUCAO,  " + CRLF 
	cSQL += "               UD_STATUS,  " + CRLF 
	cSQL += "               UD_PRODUTO  " + CRLF 
	cSQL += "        FROM   "+RetSqlName("SUC")+" SUC  " + CRLF 
	cSQL += "               INNER JOIN "+RetSqlName("SUD")+" SUD  " + CRLF 
	cSQL += "                       ON UD_FILIAL = "+ValToSql( xFilial( "SUD" ) )+"  " + CRLF 
	cSQL += "                          AND UD_CODIGO = UC_CODIGO  " + CRLF 
	cSQL += "                          AND SUD.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "        WHERE  UC_FILIAL = "+ValToSql( xFilial( "SUC" ) )+"  " + CRLF 
	cSQL += "               AND UC_DATA BETWEEN "+ValToSql( d180PerDe )+" AND "+ValToSql( d180PerAte )+"  " + CRLF 
	cSQL += "               AND SUC.D_E_L_E_T_ = ' '  " + CRLF 
	If n180Status==1
		cSQL += "               AND UC_STATUS = '2'  " + CRLF 
	Elseif n180Status==2
		cSQL += "               AND UC_STATUS = '3'  " + CRLF 
	Endif
	cSQL += "               AND UC_OPERADO IN (SELECT U7_COD  " + CRLF 
	cSQL += "                                  FROM   "+RetSqlName("SU7")+" SU7  " + CRLF 
	cSQL += "                                         INNER JOIN "+RetSqlName("SA3")+" SA3  " + CRLF 
	cSQL += "                                                 ON A3_FILIAL = "+ValToSql( xFilial( "SA3" ) )+"  " + CRLF 
	cSQL += "                                                    AND A3_COD = U7_CODVEN  " + CRLF 
	cSQL += "                                                    AND A3_XCANAL = "+ValToSql( c180Canal )+"  " + CRLF 
	cSQL += "                                                    AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                                                    AND SA3.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "                                  WHERE  U7_FILIAL = "+ValToSql( xFilial( "SU7" ) )+"  " + CRLF 
	cSQL += "                                         AND U7_COD BETWEEN  " + CRLF 
	cSQL += "                                             "+ValToSql( c180ConsDe )+" AND "+ValToSql( c180ConsAte )+"  " + CRLF 
	cSQL += "                                         AND SU7.D_E_L_E_T_ = ' ')) TEMP_QRY  " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SU5")+" SU5  " + CRLF 
	cSQL += "               ON U5_FILIAL = "+ValToSql( xFilial( "SU5" ) )+"  " + CRLF 
	cSQL += "                  AND U5_CODCONT = UC_CODCONT  " + CRLF 
	cSQL += "                  AND SU5.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SU7")+" SU7  " + CRLF 
	cSQL += "               ON U7_FILIAL = "+ValToSql( xFilial( "SU7" ) )+"  " + CRLF 
	cSQL += "                  AND U7_COD = UC_OPERADO  " + CRLF 
	cSQL += "                  AND SU7.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SU9")+" SU9  " + CRLF 
	cSQL += "               ON U9_FILIAL = "+ValToSql( xFilial( "SU9" ) )+"  " + CRLF 
	cSQL += "                  AND U9_ASSUNTO = UD_ASSUNTO " + CRLF 
	cSQL += "                  AND U9_CODIGO = UD_OCORREN " + CRLF 
	cSQL += "                  AND SU7.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SX5")+" SX5  " + CRLF 
	cSQL += "               ON X5_FILIAL = "+ValToSql( xFilial( "SX5" ) )+" " + CRLF 
	cSQL += "                  AND X5_TABELA = 'T1' " + CRLF 
	cSQL += "                  AND X5_CHAVE = UD_ASSUNTO " + CRLF 
	cSQL += "                  AND SX5.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SUX")+" SUX " + CRLF 
	cSQL += "               ON UX_FILIAL = "+ValToSql( xFilial( "SUX" ) )+" " + CRLF 
	cSQL += "                  AND UX_CODTPO = U9_TIPOOCO " + CRLF 
	cSQL += "                  AND SUX.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "       INNER JOIN "+RetSqlName("SUQ")+" SUQ " + CRLF 
	cSQL += "               ON UQ_FILIAL = "+ValToSql( xFilial( "SUQ" ) )+" " + CRLF 
	cSQL += "                  AND UQ_SOLUCAO = UD_SOLUCAO " + CRLF 
	cSQL += "                  AND SUQ.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "       LEFT  JOIN "+RetSqlName("SB1")+" SB1 " + CRLF 
	cSQL += "               ON B1_FILIAL = "+ValToSql( xFilial( "SB1" ) )+" " + CRLF 
	cSQL += "                  AND B1_COD = UD_PRODUTO " + CRLF 
	cSQL += "                  AND SB1.D_E_L_E_T_ = ' '  " + CRLF 
	cSQL += "ORDER BY UC_OPERADO, UC_CODIGO, UD_ITEM " + CRLF 
	
   If l180Query
		A180Script( cSQL )   
   Endif

	nColSpace := 1
	cFont := 'Courier New'
	nFont := 6
	cOrient := 'PAISAGEM'
	n180Nome := 2
	
	aCab := {'NOME DO OPERADOR',;
				'OPERAD',;
				'DATA',;
				'ATEND.',;
				'IT',;
				'OPER.',;
				'STATUS',;
				'COD.ENT.',;
				'NOME ENTIDADE',;
				'CONTAT',;
				'NOME CONTATO',;
				'PRODUTO',;
				'DESCR.PRODUTO',;
				'ASSUNT',;
				'OCORR',;
				'COMPL',;
				'SOLUCAO'}
		         
	aAlign := {'LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT'}
	aPicture := {'@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!','@!'}
	
	aSizeCol := {40,06,08,06,02,06,06,06,30,06,25,15,25,06,06,06,06}
	//           |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +----> 17 SOLUCAO
	//           |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  +-------> 16 COMPL.
	//           |  |  |  |  |  |  |  |  |  |  |  |  |  |  +----------> 15 OCORR.
	//           |  |  |  |  |  |  |  |  |  |  |  |  |  +-------------> 14 ASSUNT
	//           |  |  |  |  |  |  |  |  |  |  |  |  +----------------> 13 DESCRICAO PRODUTO
	//           |  |  |  |  |  |  |  |  |  |  |  +-------------------> 12 PRODUTO
	//           |  |  |  |  |  |  |  |  |  |  +----------------------> 11 NOME CONTATO (30)
	//           |  |  |  |  |  |  |  |  |  +-------------------------> 10 CONTAT
	//           |  |  |  |  |  |  |  |  +----------------------------> 09 NOME ENTIDADE (40)
	//           |  |  |  |  |  |  |  +-------------------------------> 08 COD.ENT
	//           |  |  |  |  |  |  +----------------------------------> 07 STATUS
	//           |  |  |  |  |  +-------------------------------------> 06 OPER.
	//           |  |  |  |  +----------------------------------------> 05 IT
	//           |  |  |  +-------------------------------------------> 04 ATEND. 
	//           |  |  +----------------------------------------------> 03 DATA
	//           |  +-------------------------------------------------> 02 OPERAD 
	//           +----------------------------------------------------> 01 NOME OPERADOR (30) 
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	FwMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Não foi possível encontrar registros com os parâmetros informados.', cCadastro)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif

	ProcRegua(0)
	
	cKey := (cTRB)->(UC_OPERADO)
	
	While ! (cTRB)->( EOF() )
		IncProc()
		
		If (cTRB)->UC_NOMENT == (cTRB)->U5_CONTAT
			cUC_CODCONT := ''
			cU5_CONTAT  := ''
		Else
			cUC_CODCONT := (cTRB)->UC_CODCONT
			cU5_CONTAT  := (cTRB)->U5_CONTAT
		Endif
		
		(cTRB)->( AAdd( aDados, { 	U7_NOME, ;
											UC_OPERADO, ;
											UC_DATA, ;
											UC_CODIGO, ;
											UD_ITEM, ;
											UC_OPERACA, ;
											UC_STATUS, ;
											UC_CHAVE, ;
											UC_NOMENT, ;
											cUC_CODCONT, ;
											cU5_CONTAT, ;
											UD_PRODUTO, ;
											B1_DESC, ;
											UD_ASSUNTO, ;
											UD_OCORREN, ;
											U9_TIPOOCO, ;
											UD_SOLUCAO  } ) )
		
		nP := AScan( aAssunto,{|p| p[1]==(cTRB)->(UD_ASSUNTO) } )
		If nP == 0
			(cTRB)->( AAdd( aAssunto,{ UD_ASSUNTO, X5_DESCRI } ) )
		Endif
		
		nP := AScan( aOcorren, {|p| p[1] == (cTRB)->(UD_OCORREN) } )
		If nP == 0
			(cTRB)->( AAdd( aOcorren, { UD_OCORREN, U9_DESC } ) )
		Endif
		
		nP := AScan( aCompl, {|p| p[1] == (cTRB)->(U9_TIPOOCO) } )
		If nP == 0
			(cTRB)->( AAdd( aCompl, { U9_TIPOOCO, UX_DESTOC } ) )
		Endif
		
		nP := AScan( aAcao, {|p| p[1]==(cTRB)->(UD_SOLUCAO) } )
		If nP == 0
			(cTRB)->( AAdd( aAcao,{ UD_SOLUCAO, UQ_DESC } ) )
		Endif
	
		(cTRB)->( dbSkip() )
		
		If cKey <> (cTRB)->(UC_OPERADO)
			cKey := (cTRB)->(UC_OPERADO)
			
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := 'LINHA'
		Endif
	End	
	(cTRB)->(dbCloseArea())

	If Len( aAssunto ) > 0
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := 'LINHA'
		
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := '*** ASSUNTO ***'
		
		ASort( aAssunto,,,{|a,b| a[1] < b[1] } )
		
		For nI := 1 To Len( aAssunto )
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := aAssunto[ nI, 1 ] + ' ' + aAssunto[ nI, 2 ]
		Next nI
	Endif
	
	If Len( aOcorren ) > 0
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := 'LINHA'
		
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := '*** OCORRENCIA ****'
		
		ASort( aOcorren,,,{|a,b| a[1] < b[1] } )
		
		For nI := 1 To Len( aOcorren )
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := aOcorren[ nI, 1 ] + ' ' + aOcorren[ nI, 2 ]
		Next nI
	Endif

	If Len( aCompl ) > 0
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := 'LINHA'
		
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := '*** COMPLEMENTO ****'
		
		ASort( aCompl,,,{|a,b| a[1] < b[1] } )
		
		For nI := 1 To Len( aCompl )
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := aCompl[ nI, 1 ] +  ' ' +aCompl[ nI, 2 ]
		Next nI
	Endif

	If Len( aAcao ) > 0
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := 'LINHA'
		
		AAdd( aDados, Array( Len( aCab ) ) )
		nElem := Len( aDados )
		aDados[ nElem, 1 ] := '*** AÇÃO ***'
		
		ASort( aAcao,,,{|a,b| a[1] < b[1] } )
		
		For nI := 1 To Len( aAcao )
			AAdd( aDados, Array( Len( aCab ) ) )
			nElem := Len( aDados )
			aDados[ nElem, 1 ] := aAcao[ nI, 1 ] + ' ' +aAcao[ nI, 2 ]
		Next nI
	Endif

	oReport := A180Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
Return

//-----------------------------------------------------------------------
// Rotina | A180Script | Autor | Robson Gonçalves     | Data | 12.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para apresentar o script de instrução SQL na tela.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Script( cSQL )
	Local cNomeArq := ''
	Local nHandle := 0
	Local lEmpty := .F.
	AutoGrLog('ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty := Empty( cNomeArq )
	If !lEmpty
		nHandle := FOpen( cNomeArq, 2 )
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
	AutoGrLog( cSQL )
	MostraErro()
	If !lEmpty
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | A180Report | Autor | Robson Gonçalves     | Data | 12.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de preparação para imprimir usando TReport.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Report( aCOLS, aHeader )
	Local oCell := NIL
	Local oReport
	Local oSection 
	
	Local nLen := Len(aHeader)
	Local nX := 0
	Local nCol := 0
	Local nElem := 0	
	Local nLargura := 0
	Local nSizeCol := Len( aSizeCol )
	
	cCadastro := cCadastro + ' - De ' + Dtoc(d180PerDe)+' até ' + Dtoc(d180PerAte) + ' - ' + c180Visao
	
	//-------------------------------------------
	// Adicionar os parâmetros no vetor de dados.
	//-------------------------------------------
	AAdd( aCOLS, Array( nLen ) )
	nElem := Len( aCOLS )
	aCOLS[ nElem, 1 ] := 'LINHA'
	
	For nX := 1 To Len( aParam )
		AAdd( aCOLS, Array( nLen ) )
		nElem := Len( aCOLS )
		aCOLS[ nElem, 1 ] := aParam[ nX ]
	Next nX
	
	AAdd( aCOLS, Array( nLen ) )
	nElem := Len( aDados )
	aCOLS[ nElem, 1 ] := 'LINHA'	
	
	oReport := TReport():New( FunName(),;
	                          cCadastro, , ;
	                          {|oReport| A180Impr( oReport, aCOLS )}, ;
	                          cDescriRel + ' Visão ' + c180Visao + '.' )
	
	oReport:DisableOrientation() // Desabilita a seleção da orientação (Retrato/Paisagem).
	oReport:SetEnvironment(2)    // Ambiente selecionado. Opções: 1-Server e 2-Cliente.
	oReport:cFontBody := cFont   // Fonte definida para impressão do relatório (Consolas/Courier New)
	oReport:nFontBody	:= nFont   // Tamanho da fonte definida para impressão do relatório.
	oReport:nLineHeight := 30    // Altura da linha.
	
	If cOrient == 'RETRATO'
		oReport:SetPortrait()
	Elseif cOrient == 'PAISAGEM'
		oReport:SetLandscape()
	Else
		oReport:SetLandscape()
	Endif
	
	DEFINE SECTION oSection OF oReport TITLE cCadastro TOTAL IN COLUMN
	
	For nX := 1 To nLen
		If nSizeCol > 0
			If nX <= nSizeCol
				nLargura := aSizeCol[ nX ]
			Else
				nLargura := 20
			Endif
		Else
			nLargura := 20
		Endif
		
		DEFINE CELL oCell NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE nLargura TITLE aHeader[ nX ]
		// Tem alinhamento?
		If Len( aAlign ) > 0
			// O elemento do vetor do alinhamento é suficiente em relação ao vetor principal?
			If nX <= Len( aAlign )
				oCell:SetAlign( aAlign[ nX ] )
			Endif
		Endif
	Next nX
	
	oSection:SetColSpace(nColSpace) // Define o espaçamento entre as colunas.
	oSection:nLinesBefore := 2      // Quantidade de linhas a serem saltadas antes da impressão da seção.
	oSection:SetLineBreak(.T.)      // Define que a impressão poderá ocorrer emu ma ou mais linhas no caso das colunas exederem o tamanho da página.
Return( oReport )

//-----------------------------------------------------------------------
// Rotina | A180Impr   | Autor | Robson Gonçalves     | Data | 13.06.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de impressão das células TReport.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Impr( oReport, aCOLS )
	Local oSection := oReport:Section(1)
	Local nX := 0
	Local nY := 0
	
	oReport:SetMsgPrint('Aguarde, imprimindo...')
	oReport:SetMeter( Len( aCOLS ) )	
	oSection:Init()
	
	For nX := 1 To Len( aCOLS )
		If oReport:Cancel()
			Exit
		Endif
		If aCOLS[ nX, 1 ] == 'LINHA'
			oReport:ThinLine()
		Else
			For nY := 1 To Len(aCOLS[ nX ])
			   If ValType( aCOLS[ nX, nY ] ) == 'D'
			   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + Dtoc( aCOLS[ nX, nY ] ) + "'}") )
			   Elseif ValType( aCOLS[ nX, nY ] ) == 'N'
			   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + LTrim( TransForm( aCOLS[ nX, nY ], aPicture[ nY ] ) ) + "'}") )
			   Elseif ValType( aCOLS[ nX, nY ] ) == 'C'
			   	aCOLS[ nX, nY ] := StrTran( aCOLS[ nX, nY ], "'", "" )
					//---------------------------------------------------------
			   	// Avaliar somente se estiver no segundo elemento do array.
					//---------------------------------------------------------
			   	If nX > 1
			   		//-----------------------------------------------------------------------------------
			   		// Se o dado do elemento anterior for igual ao elemento atual E 
			   		// está no intervalo da coluna a ser avaliada, não imprimir o dado, pois é repetição.
			   		//-----------------------------------------------------------------------------------
			   		If aCOLS[ nX-1, nY ] == aCOLS[ nX, nY ] .And. nY <= n180Nome
			   			oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &( "{ || ''}" ) )
			   		Else
			   			//------------------------------
			   			// Do contrário imprimir o dado.
			   			//------------------------------
			   			oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &( "{ || '" + aCOLS[ nX, nY ] + "'}" ) )
			   		Endif
			   	Else
			   		oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &( "{ || '" + aCOLS[ nX, nY ] + "'}" ) )
			   	Endif
			   Else
			   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &( "{ || ' '}" ) )
			   Endif
			Next nY
			oSection:PrintLine()
		Endif
		oReport:IncMeter()
	Next nX
	oSection:Finish()	
Return

//-----------------------------------------------------------------------
// Rotina | A180Fil    | Autor | Robson Gonçalves     | Data | 09.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar de parâmetros e filtros.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Fil()
	Local lRet := .T.	
	Local nMv := 0
	Local aMvPar := {}
	
	aAsk := {}
	aReply := {}
	
	aOrdem := {'Por nome consultor','Por ranking pendente'}
	aBase  := {'Renovação (SSL/ICP)', 'Leads', 'Clientes/Prospects/Suspects', 'Todos' }
	
	AAdd( aAsk, { 3, 'Ordem de impressão',1 , aOrdem, 99, '', .T. } )
	AAdd( aAsk, { 3, 'Base de agenda'    ,1 , aBase,  99, '', .T. } )
	
	For nMv := 1 To 40
		AAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv
	
	lRet := ParamBox( aAsk, 'Selecione ordem e filtro', @aReply,,,,,,,,.T.,.T.)
	
	If lRet
		n180Ordem := aReply[ 1 ] 
		n180Base  := aReply[ 2 ]
	Endif
	
	For nMv := 1 To Len( aMvPar )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A180Status | Autor | Robson Gonçalves     | Data | 09.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar de parâmetros e filtros.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A180Status()
	Local lRet := .T.	
	Local nMv := 0
	Local aMvPar := {}
	
	aAsk := {}
	aReply := {}

	aStatus := {'Pendente','Encerrado','Ambos'}
	
	AAdd( aAsk, { 3, 'Status do atendimento',1 , aStatus, 99, '', .T. } )
	
	For nMv := 1 To 40
		AAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv
	
	lRet := ParamBox( aAsk, 'Selecione o filtro para status', @aReply,,,,,,,,.T.,.T.)
	
	If lRet
		n180Status := aReply[ 1 ] 
	Endif
	
	For nMv := 1 To Len( aMvPar )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv
Return( lRet )