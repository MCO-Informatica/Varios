//---------------------------------------------------------------------------
// Rotina | FeedBackDados      | Autor | Robson Gonçalves | Data | 19.04.2017
//---------------------------------------------------------------------------
// Descr. | WebService REST para integração com o sistema FeedBack.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------

#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

STATIC cQ3_DESCSUM := ''
STATIC cQB_DESCRIC := ''
STATIC cCTT_DESC01 := ''
STATIC cpfSuperior := ''
STATIC nomeSuperior := ''

WSRESTFUL FeedBackDados DESCRIPTION "Integração Protheus x Feedback"
	WSDATA cCPF     AS STRING OPTIONAL
	WSDATA cToken   AS STRING OPTIONAL
	WSDATA cType    AS STRING OPTIONAL
	WSDATA cUnidade AS STRING OPTIONAL
	 
	WSMETHOD GET DESCRIPTION "Integração dos dados de colaboradores com o sistema de Feedback" WSSYNTAX "/colaborador || /colaborador/{id}"
END WSRESTFUL
 
WSMETHOD GET WSRECEIVE cToken, cType, cUnidade, cCPF WSSERVICE FeedBackDados
	Local cGetToken := ''
	Local cJson := ''
	Local cMV_790_02 := 'MV_790_02'
	Local cPar1 := ''
	Local cPar2 := ''
	Local cPar3 := ''
	Local cParam := ''

	Local lLogin := .F.
	Local lRet := .T.
	Local lTimeOut := .T.
	Local lToken := .T.
	
	Local nPar1 := 0
	Local nPar2 := 0
	Local nPar3 := 0
	
	// Define o tipo de retorno do método
	::SetContentType("application/json")
	
	// Tem parâmetros?
	If Len( ::aURLParms ) == 0
		U_FBConout( 'FeedBackDados | Parametro invalido. Erro: aURLParms.' )
		SetRestFault(301, 'Parametro invalido.', .T.)
		lRet := .F.
	Endif
	
	// Tem o parâmetro cType?
	If Len( ::aURLParms ) > 1 .AND. lRet
		If .NOT. ::aURLParms[ 2 ] $ '1|2'
			U_FBConout( 'FeedBackDados | Type invalido.' )
			SetRestFault(302, 'Type invalido.', .T.)
			lRet := .F.
		Endif
	Endif 
	
	// O parâmetro cType é consulta unitária?
	If ::aURLParms[ 2 ] == '2' .AND. lRet
		If Len( ::aURLParms ) <> 4
			U_FBConout( 'FeedBackDados | Parametro insuficiente para Unidade/CPF.' )
			SetRestFault(303, 'Parametro insuficiente para Unidade/CPF.', .T.)
			lRet := .F.
		Else
			// Os parâmetros unidade ou CPF está vazio?
			If Empty( ::aURLParms[ 3 ] ) .OR. Empty( ::aURLParms[ 3 ] )
				U_FBConout( 'FeedBackDados | Parametro(s) sem dados Unidade e/ou CPF.' )
				SetRestFault(304, 'Parametro(s) sem dados para Unidade e/ou CPF.', .T.)
				lRet := .F.
			Endif
		Endif
	Endif
	
	// Se não houver critica, seguir...
	If lRet
		cParam := Decode64( ::aURLParms[1] )
		
		cGetToken := U_GetToken()
		
		cPar1 := SubStr( cParam, 1, 4 )
		cPar2 := SubStr( cGetToken, 1, 4 )
		cPar3 := SubStr( cParam, 11 )
		
		nPar1 := fConvHr( Val( SubStr( cParam, 5, 6 ) ), 'D' )
		nPar2 := fConvHr( Val( SubStr( cGetToken, 5, 6 ) ), 'D' )
		nPar3 := SubHoras( nPar2, nPar1 )
		
		PswOrder( 2 )
		lLogin := PswSeek( cPar3 )
		
		// Login autenticado?
		If .NOT. lLogin 
			U_FBConout( 'FeedBackDados | Login invalido. Erro: ' + cPar3 )
			SetRestFault(305, 'Login invalido.', .T.)
			lRet := .F.
		Else
			// Login está bloqueado?
			If PswRet()[ 1, 17 ]
				U_FBConout( 'FeedBackDados | Usuario com acesso bloqueado.' )
				SetRestFault(306, 'Usuario com acesso bloqueado.', .T.)
				lRet := .F.
			Endif
		Endif
		
		// Se não houver critica, seguir...
		If lRet
			If .NOT. GetMv( cMV_790_02, .T. )
				CriarSX6( cMV_790_02, 'N', 'TIME-OUT DO TOKEN NA INTEGRACAO SISTEMA FEEDBACK, VALOR EM DECIMAL 100 = 60 SEGUNDOS. ROTINA CSFA790.PRW', '100' )
			Endif
			
			lToken := cPar1 == cPar2
			
			lTimeOut := nPar3 <= GetMv( cMV_790_02, .F. )
			
			// Se o token e Time-Out são válidos. 
			If lToken .AND. lTimeOut
				If ::aURLParms[ 2 ] == '1'
					cJson := AllEmployees()
					U_FBConout( 'FeedBackDados | Retorno AllEmployee com sucesso.' )
					::SetResponse( cJson )
				Else
					cJson := OnlyEmployee( ::aURLParms[ 3 ], ::aURLParms[ 4 ] )
					If SubStr( cJson, 1, 3 ) $ '309/310/311/312'
						U_FBConout( 'FeedBackDados | Erro no retorno OnlyEmployee: ' + cJson )
						SetRestFault(Val( SubStr( cJson, 1, 3 ) ), SubStr( cJson, 4 ), .T.)
						lRet := .F.
					Else
						U_FBConout( 'FeedBackDados | Retorno OnlyEmployee com sucesso.' )
						::SetResponse( cJson )
					Endif
				Endif
			Else
				If .NOT. lToken
					U_FBConout( 'FeedBackDados | Token invalido. Erro: ' + cPar1 + cPar2 )
					SetRestFault(307, 'Token invalido.', .T.)
				Endif
				
				If .NOT. lTimeOut
					U_FBConout( 'FeedBackDados | Erro time out. ' )
					SetRestFault(308, 'Erro time out.', .T.)
				Endif
				
				lRet := .F.
			Endif
		Endif
	Endif
Return lRet

//---------------------------------------------------------------------------
// Rotina | AllEmployees       | Autor | Robson Gonçalves | Data | 19.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para retornar todos os funcionários conforme parâmetros.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function AllEmployees()
	Local aSuperior := {}
	Local cJson := ''
	Local cMV_790_01 := 'MV_790_01'
	Local cMV_790_03 := 'MV_790_03'
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	
	If .NOT. GetMv( cMV_790_03, .T. )
		CriarSX6( cMV_790_03, 'C', 'LIMITAR O USO DE DADOS-DESENV, TST E HOMOLOG. INFORME SIM P/ LIMITAR. ROTINA CSFA790.PRW', '' )
	Endif
	
	cMV_790_03 := GetMv( cMV_790_03, .F. )

	If .NOT. GetMv( cMV_790_01, .T. )
		CriarSX6( cMV_790_01, 'C', 'FILIAL(IS) P/ INTEGRACAO C/ SISTEMA DE FEEDBACK. ROTINA CSFA790.PRW', '06/07/08' )
	Endif
	
	cMV_790_01 := GetMv( cMV_790_01, .F. )
	
	If cMV_790_03 == 'SIM'
		cMV_790_01 := '07'
	Endif
	
	cSQL += "SELECT RA_FILIAL, "
	cSQL += "       RA_MAT, "
	cSQL += "       RA_NOMECMP, "
	cSQL += "       RA_CIC, "
	cSQL += "       RA_SITFOLH, "
	cSQL += "       RA_RESCRAI, "
	cSQL += "       RA_EMAIL, "
	cSQL += "       NVL(Q3_DESCSUM,' ') AS Q3_DESCSUM,"
	cSQL += "       NVL(QB_DESCRIC,' ') AS QB_DESCRIC,"
	cSQL += "       RA_CC,"
	cSQL += "       RA_XCGEST,"
	cSQL += "       CTT_DESC01, "
	cSQL += "       RA_RAMAL "
	cSQL += "FROM   "+RetSqlName("SRA")+" SRA "
	cSQL += "       LEFT  JOIN "+RetSqlName("SQ3")+" SQ3 "
	cSQL += "               ON Q3_FILIAL = "+ValToSql(xFilial("SQ3"))+" "
	cSQL += "                  AND Q3_CARGO = RA_CARGO "
	cSQL += "                  AND SQ3.D_E_L_E_T_ = ' '  "
	cSQL += "       LEFT  JOIN "+RetSqlName("SQB")+" SQB "
	cSQL += "               ON QB_FILIAL = "+ValToSql(xFilial("SQB"))+" "
	cSQL += "                  AND QB_DEPTO = RA_DEPTO "
	cSQL += "                  AND SQB.D_E_L_E_T_ = ' ' "
	
	cSQL += "       INNER JOIN " + RetSqlName("CTT") + " CTT " 
	cSQL += "               ON CTT_FILIAL = " + ValToSql( xFilial( "CTT" ) ) + " " 
	cSQL += "              AND CTT_CUSTO = RA_CC "
	cSQL += "              AND CTT.D_E_L_E_T_ = ' ' "
	
	cSQL += "WHERE  RA_FILIAL IN " + FormatIN( cMV_790_01, '/' ) + " "
	cSQL += "       AND (RA_SITFOLH = ' ' OR RA_SITFOLH = 'A' OR RA_SITFOLH = 'F') "
	cSQL += "       AND SRA.D_E_L_E_T_ = ' ' "
	
	If cMV_790_03 == 'SIM'
		cSQL += "       AND RA_MAT BETWEEN '000001' AND '999999' "
	Endif
	
	cSQL += "ORDER  BY RA_FILIAL, "
	cSQL += "          RA_NOMECMP "

	cSQL := ChangeQuery( cSQL )
	
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	dbSelectArea( cTRB )
	
	If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
		cJson := '{ "Colaboradores" : [' 
		While .NOT. (cTRB)->( EOF() )
			If Empty( (cTRB)->RA_XCGEST )
				cpfSuperior  := ' '
				nomeSuperior := ' '
			Else
				aSuperior    := (cTRB)->(GetAdvFVal('SRA',{'RA_CIC','RA_NOME'},(cTRB)->RA_FILIAL+(cTRB)->RA_XCGEST,1))
				cpfSuperior  := aSuperior[1]
				nomeSuperior := RTrim(aSuperior[2])
			Endif
			
			cQ3_DESCSUM := Q3_DESCSUM
			cQB_DESCRIC := QB_DESCRIC
			cCTT_DESC01 := CTT_DESC01
			
			cJson += GetJson()
			
			(cTRB)->( dbSkip() )
		End
		cJson := SubStr( cJson, 1, Len( cJson )-1 )
		cJson += 	']'
		cJson += '}'
	Endif
	(cTRB)->( dbCloseArea() )
Return( cJson )

//---------------------------------------------------------------------------
// Rotina | OnlyEmployee       | Autor | Robson Gonçalves | Data | 19.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina p/ retornar dados de um funcionários conforme parâmetros.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function OnlyEmployee( cUnidade, cCPF )
	Local aSuperior := {}
	Local cJson := ''
	Local lRet := .T.
	
	dbSelectArea( 'SRA' )
	SRA->( dbSetOrder( 5 ) )
	lRet := SRA->( dbSeek( cUnidade + cCPF ) )
	
	If lRet
		// Situação vazio é normal, A é afastado, F é férias.
		If SRA->RA_SITFOLH == ' ' .OR. SRA->RA_SITFOLH == 'A' .OR. SRA->RA_SITFOLH == 'F'	
			If Empty( SRA->RA_XCGEST )
				cpfSuperior  := Space( Len( SRA->RA_CIC ) )
				nomeSuperior := Space( Len( SRA->RA_NOMECMP ) )
			Else
				aSuperior    := SRA->(GetAdvFVal('SRA',{'RA_CIC','RA_NOME'},SRA->RA_FILIAL+SRA->RA_XCGEST,1))
				cpfSuperior  := aSuperior[1]
				nomeSuperior := RTrim(aSuperior[2])
			Endif
			
			SQ3->( dbSetOrder( 1 ) )
			
			If SQ3->( dbSeek( xFilial( 'SQ3' ) + SRA->RA_CARGO ) )
				cQ3_DESCSUM := SQ3->Q3_DESCSUM
			Else 
				cQ3_DESCSUM := Space( Len( SQ3->Q3_DESCSUM ) ) 
			Endif
			
			SQB->( dbSetOrder( 1 ) )
			
			If SQB->( dbSeek( xFilial( 'SQB' ) + SRA->RA_DEPTO ) )
				cQB_DESCRIC := SQB->QB_DESCRIC
			Else 
				cQB_DESCRIC := Space( Len( SQB->QB_DESCRIC ) ) 
			Endif
			
			CTT->( dbSetORder( 1 ) )
			CTT->( dbSeek( xFilial( 'CTT' + SRA->RA_CC ) ) )
			cCTT_DESC01 := RTrim( CTT->CTT_DESC01 )
			
			cJson := '{ "Colaboradores" : ['
			
			cJson += GetJson()
			cJson := SubStr( cJson, 1, Len( cJson )-1 ) 
			
			cJson += 	']'
			cJson += '}'
		Else
			If SRA->RA_SITFOLH $ '30/31'
				cJson := '309Colaborador transferido.'
			Elseif SRA->RA_SITFOLH == 'D'
				cJson := '310Colaborador demitido.'
			Else
				cJson := '311Colaborador em situação diferenciado. Verificar com Sistemas Corporativos.'
			Endif
		Endif
	Else
		cJson := '312Unidade e/ou cCPF não localizado na base de dados.'
	Endif
Return( cJson )

//---------------------------------------------------------------------------
// Rotina | GetJson            | Autor | Robson Gonçalves | Data | 19.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para elabora a estrutura Json.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function GetJson()
	Local cJson := ''
	Local cSit := ''
	
	Conout(' * SITFOLH = ' + Iif( Empty( RA_SITFOLH ), 'VAZIO', RA_SITFOLH ) )
	
	If Empty( RA_SITFOLH )
		cSit := 'N' // Normal.
	Elseif RA_SITFOLH == 'D' .AND. RA_SITFOLH $ '30/31'
		cSit := 'T' // Transferido.
	Else
		cSit := RA_SITFOLH
	Endif
	
	// Verificar se está no período de férias/afastamento.
	If cSit == 'F'
		If .NOT. A791Ferias( RA_FILIAL, RA_MAT )
			cSit := 'N'
		Endif
	Endif
	
	Conout(' * Informar SITFOLH = ' + cSit )
	
	cJson := '{ "filial": "'            + RA_FILIAL + '",'
	cJson +=   '"matricula": "'         + RA_MAT    + '",'
	cJson +=   '"nome": "'              + RTrim( RA_NOMECMP ) + '",'
	cJson +=   '"cpf": "'               + RA_CIC + '",'
	cJson +=   '"situacao": "'          + cSit   + '",' 
	cJson +=   '"cargo": "'             + RTrim( cQ3_DESCSUM ) + '",'
	cJson +=   '"departamento": "'      + RTrim( cQB_DESCRIC ) + '",'
	cJson +=   '"email": "'             + RTrim( RA_EMAIL ) + '",'
	cJson +=   '"centro_custo": "'      + RA_CC + '",'
	cJson +=   '"descr_centro_custo": "'+ RTrim( cCTT_DESC01 ) + '",'
	cJson +=   '"ramal": "'             + RA_RAMAL    + '",'
	cJson +=   '"cpfSuperior": "'       + cpfSuperior + '",'
	cJson +=   '"nomeSuperior": "'      + nomeSuperior + '"},'
	
Return( cJson )

/******
 *
 * Rotina para avaliar se na data de hoje o funcionário está no período de férias.
 *
 ***/
Static Function A791Ferias( cRA_FILIAL, cRA_MAT )
	Local aArea := {}
	Local cSQL := ''
	Local cTRB := ''
	Local lAfastado := .F.
	Local dDataHoje := MsDate()
	
	aArea := GetArea()
	
	cSQL := "SELECT COUNT(*) AS SR8RECNO "
	cSQL += "FROM "+RetSqlName("SR8")+" SR8 "
	cSQL += "WHERE R8_FILIAL = "+ValToSql( cRA_FILIAL )+" "
	cSQL += "      AND R8_MAT = "+ValToSql( cRA_MAT )+" "
	cSQL += "      AND D_E_L_E_T_ = ' ' "
	cSQL += "      AND ( "+ValToSql( dDataHoje )+" >= R8_DATAINI AND "+ValToSql( dDataHoje )+" <= R8_DATAFIM ) "
	cSQL += "       OR ( R8_DATAINI >= "+ValToSql( dDataHoje )+" AND R8_DATAFIM <= "+ValToSql( dDataHoje )+" ) "
	
	cSQL := ChangeQuery( cSQL )
	
	Conout(' * ' + cSQL )
	
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),cTRB,.F.,.T.)
	lAfastado := ((cTRB)->( SR8RECNO ) > 0 )
	
	Conout(' * ' + Iif( lAfastado , 'Sim, ', 'Nao, ') + 'tem afastamento.' )
	
	(cTRB)->( dbCloseArea() )
	RestArea( aArea )
Return( lAfastado )

//---------------------------------------------------------------------------
// Rotina | A791Ramal          | Autor | Robson Gonçalves | Data | 24.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para efetuar alteração do ramal do colaborador.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
User Function A791Ramal()
	Local aButton := {}
	Local aSay := {}
	
	Local nOpcao := 0
	
	Private cCadastro := 'Ramal do colaborador'
	
	AAdd( aSay, 'Rotina que possibilita informar o ramal para o colaborador.' )
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
		If SRA->( FieldPos( 'RA_RAMAL' ) ) > 0
			A790Main()
		Else
			MsgAlert('Não é possível executar esta rotina, pois não existe o campo RAMAL, por favor, execute o update U_UPD791()', cCadastro )
		Endif
	Endif
Return

STATIC aRAMAIS     := {{'','','',''}}
STATIC cMV_790_04  := 'MV_790_04'
STATIC cPESQ
STATIC cRA_FILIAL  := Space( Len( SRA->RA_FILIAL ) )
STATIC cRA_MAT     := Space( Len( SRA->RA_MAT ) ) 
STATIC cRA_NOMECMP := Space( Len( SRA->RA_NOMECMP ) ) 
STATIC cRA_RAMAL   := Space( 100 )

#DEFINE nMATRICULA 1
#DEFINE nRAMAL     2
#DEFINE nNOME      3
#DEFINE nCOLUNA    4

//---------------------------------------------------------------------------
// Rotina | A790Main           | Autor | Robson Gonçalves | Data | 24.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina principal de execução.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function A790Main()
	Local aHeader := {'Matrícula'+CRLF,'Ramal','Nome',''}
	Local aTam := {}
	Local aOpc := {'nome ou','e-mail'}
	
	Local bExecute := {|| .T. }
	
	Local cPlaceHold:= ''

	Local nOpc := 1
	
	Local oAdd 
	Local oCancel
	Local oConfirm
	Local oDlg 
	Local oLbx 
	Local oGet1
	Local oGet2
	Local oGroup 
	Local oOpc
	Local oPanelAll
	Local oPanelBot
	Local oPanelTop
	Local oPesq
	
	If .NOT. GetMv( cMV_790_04, .T. )
		CriarSX6( cMV_790_04, 'C', 'FILIAIS QUE SERAO TRATADAS NA ROTINA CSFA790.PRW', '06/07' )
	Endif
	
	cMV_790_04 := GetMv( cMV_790_04, .F. ) 
	
	cPESQ     := Space( 100 )
	cRA_RAMAL := Space( 100 )
	
	AAdd( aTam, CalcFieldSize( 'C', Len(SRA->(RA_FILIAL+RA_MAT)), 0, '@!', 'Matrícula' ) )
	AAdd( aTam, CalcFieldSize( 'C', Len(SRA->RA_RAMAL)          , 0, '@!', 'Ramal' ) )
	AAdd( aTam, CalcFieldSize( 'C', Len(SRA->RA_NOMECMP)        , 0, '@!', 'Nome colaborador' ) )
	AAdd( aTam, CalcFieldSize( 'C', Len(' ')                    , 0, '@!', 'A' ) )
	
	bExecute := {|| A791Buscar( @oLbx, nOpc ) }
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 500,500 TITLE cCadastro PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,52,.F.,.F.)
		oPanelTop:Align := CONTROL_ALIGN_TOP
		
		oGroup:= TGroup():New(2,2,49,251,'',oPanelTop,,,.T.)
		
		@ 5,6 SAY 'Pesquisar por' SIZE 200,7 PIXEL OF oPanelTop
		
		oOpc := TRadMenu():New (5,46,aOpc,,oPanelTop,,,,,,,,70,10,,,,.T.,.T.)
		oOpc:bSetGet := {|u|Iif (PCount()==0,nOpc,nOpc:=u)}
		
		cPlaceHold := 'Pesquisar...'
		oGet1 := TGet():New(17,6,{|u| If(PCount() > 0, cPESQ := u, cPESQ ) },oPanelTop,195,10,/*cPict ]*/,/*bValid*/,,,,,,.T.,,,/*bWhen*/,,,bExecute,/*lReadOnly*/,,,cPESQ,,,,,,,,,,,cPlaceHold)
		
		@ 17,204 BUTTON oPesq ; 
		         PROMPT 'Pesquisar' ; 
		         SIZE 43,11 PIXEL OF oPanelBot ;
		         ACTION Eval( bExecute )
		         
		cPlaceHold := 'Ramal do colaborador...'
		oGet2 := TGet():New(33,6,{|u| If(PCount() > 0, cRA_RAMAL := u, cRA_RAMAL ) },oPanelTop,195,10,/*cPict ]*/,/*bValid*/,,,,,,.T.,,,/*bWhen*/,,,/*bChange*/,/*lReadOnly*/,,,cRA_RAMAL,,,,,,,,,,,cPlaceHold)
		
		@ 33,204 BUTTON oAdd ; 
		         PROMPT 'Adicionar' ; 
		         SIZE 43,11 PIXEL OF oPanelBot ;
		         ACTION ( A791Add( @oLbx ) )
		
		oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.F.)
		oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oLbx := TwBrowse():New(1,1,1000,1000,,aHeader,,oPanelAll,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aRAMAIS )
		oLbx:aColSizes := aTam
		oLbx:bLine := {|| AEval( aRAMAIS[ oLbx:nAt ], { | value, index | aRAMAIS[ oLbx:nAt, index ] } ) }
		oLbx:bLDblClick := {|| 	cPESQ := oLbx:aArray[ oLbx:nAt, nNOME ],;
											cRA_RAMAL := oLbx:aArray[ oLbx:nAt, nRAMAL ],;
											oGet1:Refresh(),;
											oGet2:Refresh(),;
											cRA_NOMECMP := cPESQ,;
											cRA_FILIAL := SubStr( oLbx:aArray[ oLbx:nAt, nMATRICULA ], 1, 2 ),;
											cRA_MAT := SubStr( oLbx:aArray[ oLbx:nAt, nMATRICULA ], 3 )}
		
		oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.F.)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM
		
		@ 1,1  BUTTON oConfirm ;
		       PROMPT '&Confirmar' ;
		       SIZE 40,11 PIXEL OF oPanelBot ;
		       ACTION (Iif(MsgYesNo('Confirma a gravação dos dados?',cCadastro),(A791Grv(oLbx),oDlg:End()),NIL))
		
		@ 1,44 BUTTON oCancel ;
		       PROMPT '&Sair' ;
		       SIZE 40,11 PIXEL OF oPanelBot ;
		       ACTION (Iif(MsgYesNo('Realmente quer sair da rotina?',cCadastro),(oDlg:End()),NIL))
		       
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//---------------------------------------------------------------------------
// Rotina | A791Buscar         | Autor | Robson Gonçalves | Data | 24.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para efetuar a pesquisa e listar o resultado.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function A791Buscar( oLbx, nOpc )
	Local aHeader := {}
	Local aList := {}
	
	Local cMV_790_05 := 'MV_790_05'
	Local cPesquisar := RTrim( cPESQ ) 	
	Local cSQL := ''
	Local cTRB := ''
	Local cWhere := ''

	Local oDlg
	Local oLbxPesq 
	
	If .NOT. GetMv( cMV_790_05, .T. )
		CriarSX6( cMV_790_05, 'N', 'QUANTIDADE LIMITE DE REGISTRO PARA CONSULTA. ROTINA CSFA790.PRW', '50' )
	Endif
	
	cMV_790_05 := GetMv( cMV_790_05, .F. ) 

	If nOpc == 1
		cWhere := "RA_NOMECMP LIKE '%" + Upper( cPesquisar ) + "%' "
	Else
		cWhere := "RA_EMAIL LIKE '%" + Lower( cPesquisar ) + "%' "
	Endif
	
	cSQL := "SELECT RA_FILIAL, "
	cSQL += "       RA_MAT, "
	cSQL += "       RA_NOMECMP, "
	cSQL += "       RA_EMAIL, "
	cSQL += "       RA_RAMAL "
	cSQL += "FROM   " + RetSqlName( 'SRA' ) + " SRA "
	cSQL += "WHERE  " + cWhere
	cSQL += "       AND SRA.RA_FILIAL IN " + FormatIn( cMV_790_04, "/" ) + " "
	cSQL += "       AND SRA.RA_SITFOLH IN (' ','F','A') "
	cSQL += "       AND SRA.D_E_L_E_T_ = ' ' "
	cSQL += "ORDER  BY RA_FILIAL, " 
	cSQL += "       RA_NOMECMP " 
	
	cSQL := ChangeQuery( cSQL )
	
	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	
	If At( 'ORDER BY', Upper( cCount ) ) > 0
		cCount := SubStr( cCount, 1, At( 'ORDER BY', cCount )-1 ) + SubStr( cCount, RAt( ')', cCount ) )
	Endif	
	
	DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cCount ),'SQLCOUNT', .F., .T. )
	nCount := SQLCOUNT->COUNT
	SQLCOUNT->(DbCloseArea())
	
	If nCount > cMV_790_05
		MsgAlert( 'A quantidade de registros é superior ao limite definido para abertura da consulta. Melhore o filtro.', cCadastro )
	Else
		cTRB := GetNextAlias()
		dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTRB, .T., .T. )
		dbSelectArea( cTRB )
		
		If .NOT. BOF() .AND. .NOT. EOF()	
			While (cTRB)->( .NOT. EOF() )
				AAdd( aList, {	Iif( nOpc==1, RA_NOMECMP, RA_EMAIL ),;
								Iif( nOpc==1, RA_EMAIL, RA_NOMECMP ),;
								Iif( RA_FILIAL == '01', 'RJ', 'SP') + '-' + RA_FILIAL,;
								RA_MAT,;
								RA_RAMAL } )
				(cTRB)->( dbSkip() )
			End
			
			If nOpc == 1
				aHeader := {'Nome','e-mail','Unidade','Matrícula','Ramal'}
			Else
				aHeader := {'e-mail','Nome','Unidade','Matrícula','Ramal'}
			Endif
			
			DEFINE MSDIALOG oDlg FROM 27,6 TO 296,478 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL
				oLbxPesq := TwBrowse():New(1,1,1000,1000,,aHeader,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
				oLbxPesq:Align := CONTROL_ALIGN_ALLCLIENT
				oLbxPesq:lUseDefaultColors:=.F.
				oLbxPesq:SetArray( aList )
				oLbxPesq:bLine := {|| AEval( aList[ oLbxPesq:nAt ], { | value, index | aList[ oLbxPesq:nAt, index ] } ) }
				oLbxPesq:bLDblClick := {|| A791Atrib( nOpc, oLbx, oLbxPesq, @oDlg ) }
			ACTIVATE MSDIALOG oDlg CENTERED
		Else
			MsgAlert('Sua pesquisa não retornou resultado.', cCadastro )
		Endif
		(cTRB)->( dbCloseArea() )
	Endif
Return( .T. )

//---------------------------------------------------------------------------
// Rotina | A791Atrib          | Autor | Robson Gonçalves | Data | 24.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para atribuir os dados na lista a ser gravada.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function A791Atrib( nOpc, oLbxMain, oLbxSeek, oDlg )
	cRA_FILIAL := SubStr( oLbxSeek:aArray[ oLbxSeek:nAt, 3 ], 4 )
	cRA_MAT := oLbxSeek:aArray[ oLbxSeek:nAt, 4 ]
	
	If AScan( oLbxMain:aArray, {|e| e[ 1 ] == cRA_FILIAL + cRA_MAT } ) == 0
		cPESQ       := oLbxSeek:aArray[ oLbxSeek:nAt, Iif( nOpc == 1, 1, 2 ) ]
		cRA_NOMECMP := cPESQ
		cRA_FILIAL  := SubStr( oLbxSeek:aArray[ oLbxSeek:nAt, 3 ], 4 )
		cRA_MAT     := oLbxSeek:aArray[ oLbxSeek:nAt, 4 ]
		cRA_RAMAL   := oLbxSeek:aArray[ oLbxSeek:nAt, 5 ]
		oDlg:End()
	Else
		MsgAlert( 'O resultado da pesquisa está adicionado na lista abaixo.', cCadastro )
		cRA_FILIAL := Space( Len( SRA->RA_FILIAL ) )
		cRA_MAT    := Space( Len( SRA->RA_MAT ) )
	Endif
Return( .T. )

//---------------------------------------------------------------------------
// Rotina | A791Add            | Autor | Robson Gonçalves | Data | 24.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina para adicionar na lista de alteração.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function A791Add( oLbx )
	Local nElem := 0
	Local nP := 0
	
	SRA->( dbSetOrder( 1 ) )
	If SRA->( dbSeek( cRA_FILIAL + cRA_MAT ) )
		If Empty( aRAMAIS[ 1, nMATRICULA ] )
			oLbx:aArray[ 1, nMATRICULA ] := cRA_FILIAL + cRA_MAT
			oLbx:aArray[ 1, nRAMAL ]     := RTrim( cRA_RAMAL )
			oLbx:aArray[ 1, nNOME ]      := RTrim( cRA_NOMECMP )
			oLbx:aArray[ 1, nCOLUNA ]    := ''
		Else
			nP := AScan( oLbx:aArray, {|e| e[ 1 ] == cRA_FILIAL + cRA_MAT } )
			If nP == 0
				AAdd( oLbx:aArray, { cRA_FILIAL + cRA_MAT, cRA_RAMAL, cRA_NOMECMP, '' } )
			Else
				If	oLbx:aArray[ nP, nRAMAL ] <> cRA_RAMAL
					oLbx:aArray[ nP, nRAMAL ] := cRA_RAMAL
				Endif
			Endif
		Endif
		
		nElem := Len( oLbx:aArray )
		
		oLbx:nAt := nElem
		
		oLbx:Refresh()
		
		cRA_MAT     := Space( Len( SRA->RA_MAT ) ) 
		cRA_NOMECMP := Space( Len( SRA->RA_NOMECMP ) )
		cRA_RAMAL   := Space( 100 )
		cPESQ       := Space( 100 )
	Else
		MsgAlert( 'Colaborador não localizado, por favor, refaça sua pesquisa.', cCadastro )
	Endif
Return

//---------------------------------------------------------------------------
// Rotina | A791Grv            | Autor | Robson Gonçalves | Data | 24.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina de gravação dos dados.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
Static Function A791Grv( oLbx )
	Local nI := 0
	SRA->( dbSetOrder( 1 ) )
	For nI := 1 To Len( oLbx:aArray )
		If SRA->( dbSeek( oLbx:aArray[ nI, nMATRICULA ] ) )
			SRA->( RecLock( 'SRA', .F. ) )
			SRA->RA_RAMAL := oLbx:aArray[ nI, nRAMAL ]
			SRA->( MsUnLock() )
		Endif
	Next nI
Return

//---------------------------------------------------------------------------
// Rotina | UPD791             | Autor | Robson Gonçalves | Data | 24.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina de update para criar o campo.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
User Function UPD791()
	Local bPrepar := {||.T.}
	Local cModulo := 'GPE'
	Local nVersao := 1
	
	If nVersao == 1
		bPrepar := {|| U_U791Ini() }
	Endif
	
	If nVersao > 0
		NGCriaUpd( cModulo, bPrepar, nVersao )
	Endif
Return

//---------------------------------------------------------------------------
// Rotina | U791Ini            | Autor | Robson Gonçalves | Data | 24.04.2017
//---------------------------------------------------------------------------
// Descr. | Rotina de preparação do vetor para a execução do update.
//---------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------
User Function U791Ini()
	/*****
	 *
	 * versão 1
	 *
	 */
	aSX3 := {}
	aHelp := {}

	AAdd( aSX3, { 'SRA',NIL,'RA_RAMAL','C',5,0,'Ramal','Ramal','Ramal','Ramal','Ramal','Ramal','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','1','','','','','N','N','','' } )
	
	AAdd( aHelp, { 'RA_RAMAL', 'Ramal da estação de trabalho do colaborador.' } )
Return


//***************************************************************************************
//***                                                                                 ***
//*** A ROTINA ABAIXO É PARA EFEUTAR TESTES NAS ROTINAS DO WEB SERVICE                ***
//***                                                                                 ***
//***************************************************************************************
User Function My790()
	Local aPar := {}
	Local aRet := {}
	Local cJson := ''
	
	AAdd( aPar, { 3, "Processar", 1, { "Somente 1", "Todos"}, 80, "", .T. } )
	
	While .T.
		If ParamBox( aPar, 'Parâmetros', @aRet,,,,,,,, .F., .F. )
			If aRet[1] > 0 .AND. aRet[1] <= 2
				If aRet[1] == 1
					cJson := OnlyEmployee( '07', '31868412830' ) //cpf do empregado Celso Tarabori.
				Elseif aRet[1] == 2
					cJson := AllEmployees()
				Endif
				MsgAlert( cJson, 'Teste' )
			Else
				If MsgYesNo('Opção indisponível. Deseja sair?','Teste')
					Exit
				Endif			
			Endif
		Else
			Exit
		Endif
	End
Return
