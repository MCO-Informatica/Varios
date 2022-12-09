//----------------------------------------------------------------
// Rotina | CSFA400    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina de controle de uniformes. O invent�rio de pe�as
//        | distribu�das.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSFA400()
	Private cCadastro := 'Controle de Uniformes'
	Private aRotina := {}
	AAdd( aRotina, {"Pesquisar"        ,"AxPesqui"   , 0, 1 } )
	AAdd( aRotina, {"Visualizar"       ,"AxVisual"   , 0, 2 } )
	AAdd( aRotina, {"Ajustar"          ,"U_A400Ajus" , 0, 4 } )
	AAdd( aRotina, {"Transferir"       ,"U_A400Tran" , 0, 4 } )
	AAdd( aRotina, {"Anexar Documentos","MsDocument" , 0, 4 } )	
	AAdd( aRotina, {"Consultar Movto." ,"U_A400Cons" , 0, 4 } )
	AAdd( aRotina, {"Gerar termo"      ,"U_A400Term" , 0, 4 } )
	AAdd( aRotina, {"Legenda"          ,"U_A400Leg"  , 0, 4 } )
	dbSelectArea('PAI')
	dbSetOrder(1)
	MBrowse(,,,,'PAI',,,,,,U_A400Leg(.T.))
Return
//----------------------------------------------------------------
// Rotina | A400Leg    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para apresentar as legendas dos movimentos.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Leg( lBrowse )
	Local nI := 0
	Local aLeg := {}
	Local aLegenda := NIL
	Local aCondicao := {}
	// [1] - Ordem da condi��o para a MBrowse.
	// [2] - Figura da legenda.
	// [3] - T�tulo da legenda.
	// [4] - Condi��o l�gica para avalia��o da MBrowse.
	AAdd( aCondicao, { 2, 'BR_VERDE'    ,'RE=Requisi��o'           , 'PAI_ESTORN=="N".AND.PAI_TM=="RE"' } )
	AAdd( aCondicao, { 3, 'BR_AMARELO'  ,'DE=Devolu��o'            , 'PAI_ESTORN=="N".AND.PAI_TM=="DE"' } )
	AAdd( aCondicao, { 4, 'BR_AZUL'     ,'AR=Ajuste por requisi��o', 'PAI_ESTORN=="N".AND.PAI_TM=="AR"' } )
	AAdd( aCondicao, { 5, 'BR_BRANCO'   ,'AD=Ajuste por devolu��o' , 'PAI_ESTORN=="N".AND.PAI_TM=="AD"' } )
	AAdd( aCondicao, { 6, 'BR_VERMELHO' ,'TR=Transfer�ncia'        , 'PAI_ESTORN=="N".AND.PAI_TM=="TR"' } )
	AAdd( aCondicao, { 1, 'BR_PRETO'    ,'Movimento transferido'   , 'PAI_ESTORN=="N".AND.PAI_TM=="RE".AND.PAI_TRANSF=="S"' } )
	AAdd( aCondicao, { 7, 'BR_CANCEL'   ,'Movimento estornado'     , 'PAI_ESTORN=="S"' } )
	If ValType(lBrowse)=='L' .And. lBrowse
		aLegenda := {}
		ASort( aCondicao,,,{|a,b| a[ 1 ] < b[ 1 ] } )
		For nI := 1 To Len( aCondicao )
			AAdd( aLegenda, { aCondicao[ nI, 4 ], aCondicao[ nI, 2 ] } )
		Next nI
	Else
		For nI := 1 To Len( aCondicao )
			AAdd( aLeg, { aCondicao[ nI, 2 ], aCondicao[ nI, 3 ] } )
		Next nI
		BrwLegenda(cCadastro,'Legenda dos registros',aLeg)	
	Endif
Return(aLegenda)
//----------------------------------------------------------------
// Rotina | A400Ajus   | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para ajustar o movimento do invent�rio.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Ajus( cAlias, nRecNo, nOpc )
	Local nStack := 0
	Private cPAI_ID := ''
	Private cPAI_TM := ''
	Private cPAI_ALMOX := GetMv( 'MV_400ALMO', .F. )
	Private cPAI_TRANSF := 'N'
	If A400Aviso( @cPAI_TM )
		nStack  := GetSX8Len()
		cPAI_ID := GetSXENum( 'PAI', 'PAI_ID' )
		If AxInclui( cAlias, nRecNo, 3, , 'U_A400FunA' ) == 1
			While GetSX8Len() > nStack 
				ConfirmSX8()
			End
		Else
			RollBackSX8()
		Endif
	Endif
Return
//----------------------------------------------------------------
// Rotina | A400Aviso  | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para solicitar a a��o do usu�rio.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400Aviso( cPAI_TM )
	Local oBmp
	Local oDlg
	Local oDev
	Local oReq
	Local oSair 
	Local oFont 
	Local lRet := .F.
	Local cMensagem := ''
	DEFAULT cPAI_TM := ''
	cMensagem := 'Esta rotina permite que seja a justado o saldo do uniformes no invent�rio conforme o c�digo do produto/uniforme, '
	cMensagem += 'o c�digo do posto parceiro e o c�digo do participante. Para isto � preciso que seja selecionado uma op��o, sendo elas: ' + CRLF
	cMensagem += ' ' + CRLF
	cMensagem += 'DEVOLVER - Aumentar o saldo do uniforme no invent�rio ' + CRLF
	cMensagem += 'REQUISITAR - Diminuir o saldo do uniforme no invent�rio. ' + CRLF 
	cMensagem += ' ' + CRLF
	cMensagem += 'Importante ressaltar que estas a��es n�o refletem no movimento/saldo do estoque de produto/uniforme.'
	DEFINE FONT oFont NAME 'MS Sans Serif' SIZE 0, -9
	DEFINE MSDIALOG oDlg FROM  0,0 TO 220,500 TITLE 'Ajuste de invent�rio do uniforme' PIXEL
		@ 0,0 BITMAP oBmp RESNAME 'BSPESQUI.PNG' oF oDlg SIZE 70,200 NOBORDER WHEN .F. PIXEL
		@ 11,63 TO 12,250 LABEL '' OF oDlg PIXEL
		@ 16,65 SAY cMensagem OF oDlg PIXEL SIZE 180,180 FONT oFont
		@ 96,124 BUTTON oDev  PROMPT 'Devolver'   SIZE 40,11 PIXEL OF oDlg ACTION (cPAI_TM := 'AD', lRet := .T., oDlg:End())
		@ 96,167 BUTTON oReq  PROMPT 'Requisitar' SIZE 40,11 PIXEL OF oDlg ACTION (cPAI_TM := 'AR', lRet := .T., oDlg:End())
		@ 96,210 BUTTON oSair PROMPT 'Sair'       SIZE 40,11 PIXEL OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTER
Return( lRet )
//----------------------------------------------------------------
// Rotina | A400Part   | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina de valida��o do participante.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Part()
	Local lRet := .F.
	Local cReadVar := ''
	cReadVar := ReadVar()
	If ReadVar() == 'MV_PAR04'
		RD0->( dbSetOrder( 1 ) )
		If RD0->( dbSeek( xFilial( 'RD0' ) + &(cReadVar) ) )
			If RD0->RD0_CODIGO == PAI->PAI_PARTIC
				MsgAlert( 'N�o ser� poss�vel transferir para o mesmo participante.', cCadastro )
			Else
				lRet := .T.
				MV_PAR05 := RD0->RD0_NOME
			Endif
		Else
			MsgAlert(' C�digo de participante n�o localizado.', cCadastro )
		Endif
	Else
		MsgAlert( 'Algo incorreto com a utiliza��o da fun��o A400Part.', cCadastro )
	Endif
Return( lRet )
//----------------------------------------------------------------
// Rotina | A400FunA   | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina p/ alimentar os campos conforme o produto antes
//        | de montar a interface.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400FunA()
	M->PAI_ID     := cPAI_ID
	M->PAI_TM     := cPAI_TM
	M->PAI_ALMOX  := cPAI_ALMOX
	M->PAI_TRANSF := cPAI_TRANSF
Return
//----------------------------------------------------------------
// Rotina | A400Prod   | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina p/ alimentar campos conforme o produto.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Prod()
	SB1->( dbSetOrder( 1 ) )
	If SB1->( dbSeek( xFilial( 'SB1' ) + M->PAI_PRODUT ) )
		M->PAI_CONTA  := SB1->B1_CONTA
		M->PAI_CC     := SB1->B1_CC
		M->PAI_ITEMCT := SB1->B1_ITEMCC
		M->PAI_CLVL   := SB1->B1_CLVL
		SB2->( dbSetOrder( 1 ) )
		If .NOT. SB2->( dbSeek( xFilial( 'SB2' ) + M->PAI_PRODUT + M->PAI_ALMOX ) )
			CriaSB2( M->PAI_PRODUT, M->PAI_ALMOX )
		Endif
		M->PAI_CUSTO  := SB2->B2_CM1
	Endif
Return( .T. )
//----------------------------------------------------------------
// Rotina | A400Almox  | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina p/ validar o almoxarifado conforme o par�metro.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Almox()
	Local lRet := .T.
	If cPAI_ALMOX <> M->PAI_ALMOX
		lRet := .F.
		MsgAlert('O almoxarifado informado n�o est� configurado para este processo.',cCadastro)
	Endif
Return( lRet )
//----------------------------------------------------------------
// Rotina | A400Tran   | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina de tranfer�ncia entre participantes.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Tran( cAlias, nRecNo, nOpc )
	Local aPar := {}
	Local aRet := {}
	Local nPAI_RECNO := 0
	Local cMsg := '� que pode ser transferido entre participantes.'
	Local bOk := {|| MsgYesNo( 'Confirma a transfer�ncia do uniforme entre participantes?'+CRLF+'Origem '+MV_PAR02+' destino '+MV_PAR04, 'Transfer�ncia de uniforme' ) }
	If PAI->PAI_TM == 'RE' .AND. PAI->PAI_ESTORN == 'N' .AND. PAI->PAI_TRANSF=="N"
		AAdd( aPar, { 9, 'Transfer�ncia de uniforme entre participantes', 150, 7, .T. } )
		AAdd( aPar, { 1, 'C�digo do articipante origem' , PAI->PAI_PARTIC, '', '', '', '.F.',  60, .T. } )
		AAdd( aPar, { 1, 'Nome do participante origem'  , PAI->PAI_NPARTI, '', '', '', '.F.', 119, .T. } )
		AAdd( aPar, { 1, 'C�digo do articipante destino', Space(Len(RD0->RD0_CODIGO)),'','U_A400Part()', 'RD0', ''   ,60 , .T. } )
		AAdd( aPar, { 1, 'Nome do participante destino' , Space(Len(RD0->RD0_NOME))  ,'',''            , ''   , '.F.',119, .T. } )
		If ParamBox( aPar, 'Par�metros',@aRet,bOk,,,,,,,.F.,.F.)
			nPAI_RECNO := PAI->( RecNo() )
			BEGIN TRANSACTION
				FwMsgRun(,{|| A400GoTran( aRet ) },,'Aguarde, efetuando transfer�ncia...')
			END TRANSACTION
			PAI->( dbGoTo( nPAI_RECNO ) )
		Endif
	Else
		If PAI->PAI_TM <> 'RE'
			MsgAlert( 'Somente registro de requisi��o '+cMsg, cCadastro)
		Elseif PAI->PAI_ESTORN <> 'N'
			MsgAlert( 'Somente registro n�o estornados '+cMsg, cCadastro)
		Elseif PAI->PAI_TRANSF <> 'N'
			MsgAlert( 'Somente registro n�o transferido '+cMsg, cCadastro)
		Endif
	Endif
Return
//----------------------------------------------------------------
// Rotina | A400GoTran | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina de processamento da tranfer�ncia.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400GoTran( aRet )
	Local aDados := {}
	Local cPAI_ID := ''
	Local cPAI_IDORIG := PAI->PAI_ID
	Local nI := 0
	Local nStak := 0
	Local nFCount := 0
	nFCount := PAI->( FCount() )
	For nI := 1 To nFCount
		AAdd( aDados, PAI->( FieldGet( nI ) ) )
	Next nI
	PAI->( RecLock( 'PAI', .F. ) )
	PAI->PAI_TRANSF := 'S'
	PAI->( MSUnLock() )
	nStack  := GetSX8Len()
	cPAI_ID := GetSXENum( 'PAI', 'PAI_ID' )
	While GetSX8Len() > nStack 
		ConfirmSX8()
	End
	PAI->( RecLock( 'PAI', .T. ) )
	For nI := 1 To nFCount
		cFieldName := FieldName( nI )
		If     cFieldName == 'PAI_ID'     ; PAI->PAI_ID     := cPAI_ID
		Elseif cFieldName == 'PAI_PARTIC' ; PAI->PAI_PARTIC := aRet[ 4 ]
		Elseif cFieldName == 'PAI_NPARTI' ; PAI->PAI_NPARTI := aRet[ 5 ]
		Elseif cFieldName == 'PAI_EMISSA' ; PAI->PAI_EMISSA := dDataBase
		Elseif cFieldName == 'PAI_HORA'   ; PAI->PAI_HORA   := Time()
		Elseif cFieldName == 'PAI_TM'     ; PAI->PAI_TM     := 'TR'
		Elseif cFieldName == 'PAI_IDORIG' ; PAI->PAI_IDORIG := cPAI_IDORIG
		Elseif cFieldName == 'PAI_TRANSF' ; PAI->PAI_TRANSF := 'N'
		Else
			PAI->( FieldPut( nI, aDados[ nI ] ) )
		Endif
	Next 
	PAI->( MSUnLock() )
Return
//----------------------------------------------------------------
// Rotina | A400TOk    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada MT241TOK, seu 
//        | objetivo � validar o movimento interno quando o tipo 
//        | de movimento for controle de uniforme e n�o tiver dado
//        | do posto e do participante.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400TOk()
	Local lRet := .T.
	Local nI := 0
	Local nDELETADO  := Len( aHeader )+1
	Local nD3_LOCAL  := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'D3_LOCAL' } )
	Local nD3_POSTO  := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'D3_POSTO' } )
	Local nD3_PARTIC := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'D3_PARTIC' } )
	Local cF5_UNIFORM := Posicione( 'SF5', 1, xFilial( 'SF5' ) + cTM, 'F5_UNIFORM' )
	Local cMV_400ALMO := GetMv( 'MV_400ALMO', .F. )
	Local cMV_400TPIN := GetMV( 'MV_400TPIN', .F. )
	Local cMV_400DEVO := GetMv( 'MV_400DEVO', .F. )
	Local cMV_400REQU := GetMv( 'MV_400REQU', .F. )
	For nI := 1 To Len( aCOLS )
		If aCOLS[ nI, nDELETADO ]
			Loop
		Endif
		If cF5_UNIFORM == 'S'
			If ( Empty( aCOLs[ nI, nD3_POSTO ] ) .Or. Empty( aCOLs[ nI, nD3_PARTIC ] ) )
				lRet := .F.
				MsgAlert('O Tipo de Movto (TM) utilizado � p/ controle de uniforme, '+;
				         'e h� produto informado que n�o possui c�digo do posto e c�digo do participante, verifique!',;
				         'Criticar posto/participante')
				Exit
			Endif
		Endif
		If cTM $ ( cMV_400TPIN + '|' + cMV_400DEVO + '|' + cMV_400REQU )
			If aCOLS[ nI, nD3_LOCAL ] <> cMV_400ALMO
				lRet := .F.
				MsgAlert('Armaz�m informado no movimento interno n�o pertence ao armaz�m de controle de uniforme.','Criticar armaz�m')
				Exit
			Endif
		Endif
	Next nI
Return( lRet )
//----------------------------------------------------------------
// Rotina | A400GrvMov | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada MT241Grv, seu 
//        | objetivo � gravar dados complementar no movimento 
//        | interno em quest�o e replicar seus dados na tabela de 
//        | controle de uniformes.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400GrvMov()
	Local cTRB := ''
	Local cPAI_HORA := ''
	Local cPAI_TM := ''
	Local cPAI_ID := ''
	Local cPAI_ALMOX := ''
	Local cD3_EMISSAO := ''
	Local cF5_UNIFORM := Posicione( 'SF5', 1, xFilial( 'SF5' ) + cTM, 'F5_UNIFORM' )
	Local nStack := 0
	If cF5_UNIFORM == 'S'
		cPAI_ALMOX := GetMv( 'MV_400ALMO', .F. )
		cD3_EMISSAO := Dtos( dA241Data )
		cTRB := GetNextAlias()
		BeginSQL Alias cTRB
			SELECT D3_COD,
			       B1_DESC,
			       D3_POSTO,
			       Z3_DESENT,
			       D3_PARTIC,
			       RD0_NOME,
			       D3_EMISSAO,
			       D3_DOC,
			       D3_NUMSEQ,
			       D3_TM,
			       D3_QUANT,
			       D3_CUSTO1,
			       D3_CONTA,
			       D3_CC,
			       D3_ITEMCTA,
			       D3_CLVL, 
			       D3_ESTORNO,
			       SD3.R_E_C_N_O_ AS SD3_RECNO
			FROM %table:SD3% SD3
			     LEFT JOIN %table:SB1% SB1 
			            ON SB1.B1_FILIAL = %xFilial:SB1%
			           AND SB1.B1_COD    = SD3.D3_COD
			           AND SB1.%notDel%
			     LEFT JOIN %table:SZ3% SZ3 
			            ON SZ3.Z3_FILIAL = %xFilial:SZ3%
			           AND SZ3.Z3_CODENT = SD3.D3_POSTO
			           AND SZ3.%notDel%
			     LEFT JOIN %table:RD0% RD0 
			            ON RD0.RD0_FILIAL = %xFilial:RD0%
			           AND RD0.RD0_CODIGO = SD3.D3_PARTIC 
			           AND RD0.%notDel%
			WHERE  SD3.D3_FILIAL      = %xFilial:SD3%
			       AND SD3.D3_DOC     = %exp:cDocumento%
			       AND SD3.D3_EMISSAO = %exp:cD3_EMISSAO%
			       AND SD3.D3_TM      = %exp:cTM%
			       AND SD3.D3_CC      = %exp:cCC%
			       AND SD3.%notDel%
		EndSQL
		If .NOT. (cTRB)->( BOF() ) .And. .NOT. (cTRB)->( EOF() )
			cPAI_HORA := Time()
			cPAI_TM   := Iif( cTM <= '500', 'DE', 'RE' )
			nStack    := GetSX8Len()
			cPAI_ID   := GetSXENum( 'PAI', 'PAI_ID' )
			While GetSX8Len() > nStack 
				ConfirmSX8()
			End
		Endif
		While .NOT. (cTRB)->( EOF() )
			PAI->( RecLock( 'PAI', .T. ) )
			PAI->PAI_FILIAL := xFilial( 'PAI' )
			PAI->PAI_ID     := cPAI_ID
			PAI->PAI_PRODUT := (cTRB)->D3_COD
			PAI->PAI_DESCRI := (cTRB)->B1_DESC
			PAI->PAI_POSTO  := (cTRB)->D3_POSTO
			PAI->PAI_DPOSTO := (cTRB)->Z3_DESENT
			PAI->PAI_PARTIC := (cTRB)->D3_PARTIC
			PAI->PAI_NPARTI := (cTRB)->RD0_NOME
			PAI->PAI_EMISSA := Stod((cTRB)->D3_EMISSAO)
			PAI->PAI_HORA   := cPAI_HORA
			PAI->PAI_DOC    := (cTRB)->D3_DOC
			PAI->PAI_NUMSEQ := (cTRB)->D3_NUMSEQ
			PAI->PAI_TM     := cPAI_TM
			PAI->PAI_QUANT  := (cTRB)->D3_QUANT
			PAI->PAI_CUSTO  := ((cTRB)->D3_CUSTO1/(cTRB)->D3_QUANT)
			PAI->PAI_TOTAL  := (cTRB)->D3_CUSTO1
			PAI->PAI_CONTA  := (cTRB)->D3_CONTA
			PAI->PAI_CC     := (cTRB)->D3_CC
			PAI->PAI_ITEMCT := (cTRB)->D3_ITEMCTA
			PAI->PAI_CLVL   := (cTRB)->D3_CLVL
			PAI->PAI_ALMOX  := cPAI_ALMOX
			PAI->PAI_ESTORN := 'N'		
			PAI->PAI_TRANSF := 'N'		
			PAI->( MsUnLock() )
			SD3->( dbGoTo( (cTRB)->SD3_RECNO ) )
			If SD3->( RecNo() ) == (cTRB)->SD3_RECNO
				SD3->( RecLock( 'SD3', .F. ) )
				SD3->D3_ID_UNIF := cPAI_ID
				SD3->( MsUnLock() )
			Endif
			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
	Endif
Return
//----------------------------------------------------------------
// Rotina | A400Estorn | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada MT241Est, seu 
//        | objetivo � gravar dados complementar no estorno do 
//        | movimento interno em quest�o e replicar a altera��o 
//        | nos dados na tabela de controle de uniformes.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Estorn()
	Local aArea := {} 
	Local nD3_ID_UNIF := 0
	aArea := { SD3->( GetArea() ), PAI->( GetArea() ) }
	nD3_ID_UNIF := AScan( aHeader, {|p| RTrim( p[ 2 ] ) == 'D3_ID_UNIF' } )
	PAI->( dbSetOrder( 1 ) )
	For nI := 1 To Len( aCOLS )
		If PAI->( dbSeek( xFilial( 'PAI' ) + aCOLS[ nI, nD3_ID_UNIF ] ) )
			While .NOT. PAI->( EOF() ) .AND. PAI->PAI_ID == aCOLS[ nI, nD3_ID_UNIF ]
				If PAI->PAI_ESTORN <> 'S' .AND. Empty( PAI->PAI_DTESTO )
					PAI->( RecLock( 'PAI', .F. ) )
					PAI->PAI_ESTORN := 'S'
					PAI->PAI_DTESTO := dDataBase
					PAI->( MsUnLock() )
					//----------------------------------------------------------------
					// Se no registro em quest�o for identificado que foi transferido.
					// Localizar para quem foi transferido e estornar tamb�m.
					//----------------------------------------------------------------
					If PAI->PAI_TRANSF == 'S'
						PAI->( dbSetOrder( 10 ) )
						A400IdOrig( PAI->PAI_ID )
						PAI->( dbSetOrder( 1 ) )
					Endif
				Endif
				PAI->( dbSkip() )
			End
		Endif
	Next nI
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return
//----------------------------------------------------------------
// Rotina | A400IdOrig | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para estornar a transfer�ncia - Recursiva.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400IdOrig( cPAI_ID )
	If PAI->( dbSeek( xFilial( 'PAI' ) + cPAI_ID ) )
		PAI->( RecLock( 'PAI', .F. ) )
		PAI->PAI_ESTORN := 'S'
		PAI->PAI_DTESTO := dDataBase
		PAI->( MsUnLock() )
	Endif
	If PAI->PAI_TRANSF == 'S'
		A400IdOrig( PAI->PAI_ID )
	Endif
Return

//----------------------------------------------------------------
// Rotina | A400Cons   | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina de consulta movimento por produto.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Cons()
	Local cCpo := ''
	Local cPerg := ''
	Local cMV_400ALMO := ''
	Local cSQL := ''
	Local cTRB := ''
	
	Local aCpo := {}
	Local aX3_CAMPO := {}
	Local aX3_TITULO := {}
	Local aX3_TIPO := {}
	Local aX3_PICTURE := {}
	Local aDADOS := {}
	
	Local nI := 0
	Local nSaldo := 0
	Local nElem := 0
	
	Local oDlg 
	Local oLbx 
	Local oPanelTop
	Local nPanelBot
	Local oImp
	Local oSair 
	Local oFont
	
	cPerg := 'A400CONS'
	cMV_400ALMO := GetMv( 'MV_400ALMO', .F. )
	oFont := TFont():New( 'Courier New',, -12 )
	
	A400SX1( cPerg )
	
	SX1->( dbSetOrder( 1 ) )
	If SX1->( dbSeek( PadR( cPerg, Len( SX1->X1_GRUPO ) ) + '02' ) )
		If RTrim( SX1->X1_CNT01 ) <> cMV_400ALMO
			SX1->( RecLock( 'SX1', .F. ) )
			SX1->X1_CNT01 := cMV_400ALMO
			SX1->( MSUnLock() )
		Endif
	Endif
	
	If .NOT. Pergunte( cPerg, .T. )
		Return
	Endif
	
	AAdd( aCpo, { 'PAILEGENDA' } )
	AAdd( aCpo, { 'PAI_EMISSA' } )
	AAdd( aCpo, { 'PAI_HORA'   } )
	AAdd( aCpo, { 'PAI_TM'     } )
	AAdd( aCpo, { 'PAI_QUANT'  } )
	AAdd( aCpo, { 'PAISALDO'   } )
	AAdd( aCpo, { 'PAI_CUSTO'  } )
	AAdd( aCpo, { 'PAI_TOTAL'  } )
	AAdd( aCpo, { 'PAI_ID'     } )
	AAdd( aCpo, { 'PAI_PARTIC' } )
	AAdd( aCpo, { 'PAI_NPARTI' } )	
	AAdd( aCpo, { 'PAI_POSTO'  } )
	AAdd( aCpo, { 'PAI_DPOSTO' } )
	AAdd( aCpo, { 'PAI_ESTORN' } )
	AAdd( aCpo, { 'PAI_DTESTO' } )
	AAdd( aCpo, { 'PAI_TRANSF' } )
	AAdd( aCpo, { 'PAI_PRODUT' } )
	AAdd( aCpo, { 'PAI_DESCRI' } )
	AAdd( aCpo, { 'PAI_ALMOX'  } )
	
	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aCpo )
		If SX3->( dbSeek( aCpo[ nI, 1 ] ) )
			AAdd( aX3_CAMPO, RTrim( SX3->X3_CAMPO ) )
			AAdd( aX3_TITULO, RTrim( SX3->X3_TITULO ) )
			AAdd( aX3_TIPO, SX3->X3_TIPO )
			AAdd( aX3_PICTURE, RTrim( SX3->X3_PICTURE ) )
			cCpo += aCpo[ nI, 1 ] + ', '
		Else
			If aCpo[ nI, 1 ] == 'PAISALDO'
				AAdd( aX3_CAMPO, aCpo[ nI, 1 ] )
				AAdd( aX3_TITULO, 'Saldo' )
				AAdd( aX3_TIPO, 'N' )
				AAdd( aX3_PICTURE, aX3_PICTURE[ AScan( aX3_CAMPO, {|p| p == 'PAI_QUANT' } ) ] )
			Elseif aCpo[ nI, 1 ] == 'PAILEGENDA'
				AAdd( aX3_CAMPO, aCpo[ nI, 1 ] )
				AAdd( aX3_TITULO, ' ' )
				AAdd( aX3_TIPO, ' ' )
				AAdd( aX3_PICTURE, ' ' )
			Endif
		Endif
	Next nI
	
	cCpo := SubStr( cCpo, 1, Len( cCpo )-2 )

	cSQL := "SELECT " + cCpo + " "
	cSQL += "FROM " + RetSqlName( "PAI" ) + " PAI "
	cSQL += "WHERE PAI_FILIAL = " + ValToSql( xFilial( "PAI" ) ) + " "
	cSQL += "      AND PAI.D_E_L_E_T_ = ' ' "
	cSQL += "      AND PAI_PRODUT = " + ValToSql( mv_par01 ) + " "
	cSQL += "      AND PAI_ALMOX = " + ValToSql( mv_par02 )+ " "
	cSQL += "      AND PAI_EMISSA BETWEEN " + ValToSql( mv_par03 ) + " AND " + ValToSql( mv_par04 ) + " "
	cSQL += "ORDER BY PAI_PRODUT, PAI_EMISSA, PAI_HORA "
	
	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, preparando o in�cio da exporta��o...')
	
	While .NOT. (cTRB)->( EOF() )
		// Considerar registros n�o estornados.
		If (cTRB)->PAI_ESTORN == 'N' 
			// Considerar registros que n�o foram transferidos.
			If (cTRB)->PAI_TRANSF == 'N'
				// Se for requsi��o ou ajuste de requisi��o, somar.
				If (cTRB)->PAI_TM $ 'RE|AR'
					nSaldo -= (cTRB)->PAI_QUANT
				// Se for devolu��o ou ajuste de devolu��o. subtrair.
				Elseif (cTRB)->PAI_TM $ 'DE|AD'
					nSaldo += (cTRB)->PAI_QUANT
				Endif
			Endif
		Endif
		
		AAdd( aDADOS, Array( Len( aX3_CAMPO ) ) )
		nElem := Len( aDADOS )
		
		For nI := 1 To Len( aX3_CAMPO )
			If aX3_CAMPO[ nI ] == 'PAISALDO'
				aDADOS[ nElem, nI ] := TransForm( nSaldo, aX3_PICTURE[ nI ] )
			Elseif aX3_CAMPO[ nI ] == 'PAILEGENDA'
				If (cTRB)->PAI_ESTORN=="N".AND.(cTRB)->PAI_TM=="RE".AND.(cTRB)->PAI_TRANSF=="S"
					aDADOS[ nElem, nI ] := LoadBitmap(,"BR_PRETO")
				Elseif (cTRB)->PAI_ESTORN=="N".AND.(cTRB)->PAI_TM=="RE"
					aDADOS[ nElem, nI ] := LoadBitmap(,"BR_VERDE")
				Elseif (cTRB)->PAI_ESTORN=="N".AND.(cTRB)->PAI_TM=="DE"
					aDADOS[ nElem, nI ] := LoadBitmap(,"BR_AMARELO")
				Elseif (cTRB)->PAI_ESTORN=="N".AND.(cTRB)->PAI_TM=="AR"
					aDADOS[ nElem, nI ] := LoadBitmap(,"BR_AZUL")
				Elseif (cTRB)->PAI_ESTORN=="N".AND.(cTRB)->PAI_TM=="AD"
					aDADOS[ nElem, nI ] := LoadBitmap(,"BR_BRANCO")
				Elseif (cTRB)->PAI_ESTORN=="N".AND.(cTRB)->PAI_TM=="TR"
					aDADOS[ nElem, nI ] := LoadBitmap(,"BR_VERMELHO")
				Elseif (cTRB)->PAI_ESTORN=="S"
					aDADOS[ nElem, nI ] := LoadBitmap(,"BR_CANCEL")
				Endif
			Else
			   If aX3_TIPO[ nI ] == 'N'
					aDADOS[ nElem, nI ] := TransForm( (cTRB)->( FieldGet( FieldPos( aX3_CAMPO[ nI ] ) ) ), aX3_PICTURE[ nI ] )
				Else
					aDADOS[ nElem, nI ] := (cTRB)->( FieldGet( FieldPos( aX3_CAMPO[ nI ] ) ) )
				Endif
		   Endif
		Next 
		(cTRB)->( dbSkip() )
	End
	
	(cTRB)->( dbGoTop() )
	
	If Len( aDADOS ) == 0
		MSgAlert( 'N�o foi localizado dados com os par�metros informados', cCadastro )
	Else
		DEFINE MSDIALOG oDlg FROM  0,0 TO 600,800 TITLE 'Consultar Movimentos Controle de Uniformes' PIXEL
			oDlg:lMaximized := .t. 
			oDlg:lEscClose := .F.
			
			oPanelTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,30,.F.,.F.)
			oPanelTop:Align := CONTROL_ALIGN_TOP
			
			@ 2, 2 Say 'C�digo e Descri��o do Produto      : ' + ;
			(cTRB)->(RTrim(PAI_PRODUT)+' - '+RTrim(PAI_DESCRI)) SIZE 300,8 PIXEL OF oPanelTop FONT oFont
			
			@ 11,2 Say 'C�digo e Descri��o do Almoxarifado : ' + ;
			(cTRB)->PAI_ALMOX+' - '+RTrim(Posicione('SX5',1,xFilial('SX5')+'AL'+(cTRB)->PAI_ALMOX,'X5_DESCRI')) SIZE 300,8 PIXEL OF oPanelTop FONT oFont
			
			@ 20,2 Say 'Saldo Atual em Estoque             : ' + ;
			LTrim(TransForm(Posicione('SB2',1,xFilial('SB2')+(cTRB)->(PAI_PRODUT+PAI_ALMOX),'B2_QATU'),PesqPict("SB2","B2_QATU",18))) SIZE 300,8 PIXEL OF oPanelTop FONT oFont
			
		   oLbx := TwBrowse():New(0,0,0,0,,aX3_TITULO,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:SetArray( aDADOS )
		   oLbx:bLine := {|| AEval( aDADOS[ oLbx:nAt ],{|z,w| aDADOS[ oLbx:nAt, w ] } ) }
		
			oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.F.)
			oPanelBot:Align := CONTROL_ALIGN_BOTTOM
			
			@ 2,02 BUTTON oImp  PROMPT 'Legenda' SIZE 40,11 PIXEL OF oPanelBot ACTION U_A400Leg()
			@ 2,45 BUTTON oSair PROMPT 'Sair'    SIZE 40,11 PIXEL OF oPanelBot ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
	Endif
	(cTRB)->( dbCloseArea() )
Return

//----------------------------------------------------------------
// Rotina | A400Term | Autor | Robson Gon�alve  s     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para gerar o termo de recebimento/devolu��o dos
//        | uniformes.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400Term( cAlias, nRecNo, nOpcX )
	Local oBmp
	Local oDlg
	Local oOk
	Local oSair 
	Local oFont 
	Local lRet := .F.
	Local cMensagem := ''
	cMensagem := 'Esta rotina gera o termo de recebimento ou de devolu��o de uniformes conforme o registro posicionado.' + CRLF
	cMensagem := 'Somente ser� poss�vel gerar termo para os movimentos de Requisi��o e Devolu��o.' + CRLF + CRLF
	cMensagem += 'Por favor, clique no bot�o Gerar Termo para prosseguir...'
	DEFINE FONT oFont NAME 'MS Sans Serif' SIZE 0, -9
	DEFINE MSDIALOG oDlg FROM  0,0 TO 220,500 TITLE 'Gerar termo de recebimento/devolu��o de uniforme' PIXEL
		@ -15,-3 BITMAP oBmp RESNAME 'IMPORT.PNG' oF oDlg SIZE 75,130 NOBORDER WHEN .F. PIXEL
		@ 11,63 TO 12,250 LABEL '' OF oDlg PIXEL
		@ 16 ,65 SAY cMensagem OF oDlg PIXEL SIZE 180,180 FONT oFont
		@ 96,166 BUTTON oDev  PROMPT 'Gerar termo' SIZE 40,11 PIXEL OF oDlg ACTION (lRet := .T., oDlg:End())
		@ 96,210 BUTTON oReq  PROMPT 'Sair'        SIZE 40,11 PIXEL OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTER
	If lRet
		// Somente para requisi��o e devolu��o que n�o foi estornado e n�o foi transferido
		If PAI->PAI_TM $ 'RE|DE' .AND. PAI_ESTORN == 'N' .AND. PAI_TRANSF == 'N'
			FwMsgRun(,{|| A400GerTerm() },,'Aguarde, gerando o termo...')
		Else
			MsgAlert('Somente movimentos de Requisi��o e Devolu��o s�o poss�veis de gerar o termo.', cCadastro)
		Endif
	Endif
Return

//----------------------------------------------------------------
// Rotina | A400GerTerm | Autor | Robson Gon�alves    | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina de processamento que gera o termo de recebimento
//        | devolu��o dos uniformes.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400GerTerm()
	Local lCopy     := .F.
	Local lReadOnly := .F.
	
	Local nCheck := 0
	Local nFalta := 0
	Local nI     := 0
	
	Local cFormat     := ''
	Local cOrigem     := ''
	Local cPAI_DOC    := ''
	Local cPAI_EMISSA := ''
	Local cPAI_HORA   := ''
	Local cPAI_ID     := ''
	Local cPAI_NPARTI := ''
	Local cPAI_NUMSEQ := ''
	Local cPAI_TM     := ''
	Local cSaidaDOC   := ''
	Local cSaidaPDF   := ''
	Local cSUPERVISOR := ''
	Local cTemplate   := ''
	Local cTempPath   := ''
	Local cTipMovto   := ''
	Local cValue      := ''
	Local oleWdFormatPDF := ''
	Local oleWdVisible   := ''
	
	Local oWord 
	
	Local aDADOS := {}
	Local aRet := {}
	
	cPAI_ID := PAI->PAI_ID
	oleWdVisible := '206'
	cValue := '0'
	oleWdFormatPDF := '17'
	cTempPath := GetTempPath()
	
	// Local onde est� o arquivo template no servidor.
	cOrigem := GetMV( Iif(PAI->PAI_TM == 'RE','MV_400WREQ','MV_400WDEV' ) , .F. )
	
	// Verificar se o arquivo existe na origem.
	If .NOT. File( cOrigem )
		MsgInfo('N�o encontrado o arquivo template de termo, verifique se o endere�o no par�metro MV_400WREQ e MV_400WDEV est� correto.', cCadastro )
		Return
	Endif
	
	// Copiar o arquivo do servidor para o tempor�rio do usu�rio do windows.
	CpyS2T( cOrigem, cTempPath, .T.)
	Sleep(250)
	
	// Formar o endere�o para onde foi copiado template word no tempor�rio do usu�rio.
	cTemplate := cTempPath + SubStr( cOrigem, RAt( '\',cOrigem )+1 )
	
	// Verifcar at� cinco vezes se o template foi copiado.
	While ((.NOT. lCopy) .And. (nCheck <= 5))
		If File( cTemplate )
			lCopy := .T.
		Else
			nCheck++
			CpyS2T( cOrigem, cTempPath, .T. )
			Sleep(250)
		Endif
	End
	
	If lCopy
		// Buscar os dados.
		PAI->( dbSetOrder( 1 ) )
		PAI->( dbSeek( xFilial( 'PAI' ) + PAI->PAI_ID ) )
		
		cPAI_DOC    := PAI->PAI_DOC
		cPAI_NUMSEQ := PAI->PAI_NUMSEQ
		cPAI_ID     := PAI->PAI_ID
		cPAI_EMISSA := Dtoc( PAI->PAI_EMISSA )
		cPAI_HORA   := PAI->PAI_HORA
		cPAI_TM     := Iif( PAI->PAI_TM=='RE','REQUISI��O','DEVOLU��O' )
		cTipMovto   := Iif( PAI->PAI_TM=='RE','req','dev' )
		cPAI_NPARTI := RTrim( PAI->PAI_NPARTI )
		If RD0->( FieldPos( 'RD0_NOMLID' ) ) > 0
			cSUPERVISOR := Posicione( 'RD0', 1, xFilial( 'RD0' ) + PAI->PAI_PARTIC, 'RD0_NOMLID' )
		Endif
		If Empty( cSUPERVISOR )
			If ParamBox({{1,"Nome do supervisor",Space(40),"@!","","","",92,.F.}},'Force�a o nome do supervisor',@aRet)
				cSUPERVISOR := aRet[ 1 ] 
			Endif
			If Empty( cSUPERVISOR )
				cSUPERVISOR := 'SUPERVISOR'
			Endif
		Endif
		
		While .NOT. PAI->( EOF() ) .AND. PAI->PAI_ID == cPAI_ID
			If PAI->PAI_TM $ 'RE|DE' .AND. PAI_ESTORN == 'N' .AND. PAI_TRANSF == 'N'
				AAdd( aDADOS, { PAI->PAI_PRODUT, PAI->PAI_DESCRI, RTrim( TransForm( PAI->PAI_QUANT, '@R 999,999,999' ) ) } )
			Endif
			PAI->( dbSkip() )
		End
		
		If Len( aDADOS ) < 7
			nFalta := 7 - Len( aDADOS )
			For nI := 1 To nFalta
				AAdd( aDADOS, { '', '', '' } )
			Next nI
		Endif
		
		// Elaborar o nome completo do arquivo.
		cArqTemp := CriaTrab( NIL, .F. )
		cSaidaDOC := SubStr( cTemplate, 1, RAt( '\', cTemplate ) ) + cArqTemp + '_' + cTipMovto + '.doc'
		cSaidaPDF := SubStr( cTemplate, 1, RAt( '\', cTemplate ) ) + cArqTemp + '_' + cTipMovto + '.pdf'
		
		// Criar o link com o apliativo.
		oWord	:= OLE_CreateLink()
		
      // Inibir o aplicativo em execu��o.
		OLE_SetProperty( oWord, oleWdVisible, cValue )
		
		// Abrir um novo arquivo.
		OLE_NewFile( oWord , cTemplate )
		
		// Atualizar as vari�veis.
		OLE_SetDocumentVar( oWord, 'WRD_PAI_DOC'   , cPAI_DOC )
		OLE_SetDocumentVar( oWord, 'WRD_PAI_NUMSEQ', cPAI_NUMSEQ )
		OLE_SetDocumentVar( oWord, 'WRD_PAI_ID'    , cPAI_ID )
		OLE_SetDocumentVar( oWord, 'WRD_PAI_EMISSA', cPAI_EMISSA )
		OLE_SetDocumentVar( oWord, 'WRD_PAI_HORA'  , cPAI_HORA )
		OLE_SetDocumentVar( oWord, 'WRD_PAI_TM'    , cPAI_TM )
		OLE_SetDocumentVar( oWord, 'WRD_PAI_NPARTI', cPAI_NPARTI )
		OLE_SetDocumentVar( oWord, 'WRD_SUPERVISOR', cSUPERVISOR )
		OLE_SetDocumentVar( oWord, 'WRD_QTD_ITENS' , LTrim( Str( Len( aDADOS ) ) ) )
		
		For nI := 1 To Len( aDADOS )
			OLE_SetDocumentVar( oWord, 'WRD_PAI_PRODUT' + LTrim( Str( nI ) ), aDADOS[ nI, 1 ] )
			OLE_SetDocumentVar( oWord, 'WRD_PAI_DESCRI' + LTrim( Str( nI ) ), aDADOS[ nI, 2 ] )
			OLE_SetDocumentVar( oWord, 'WRD_PAI_QUANT'  + LTrim( Str( nI ) ), aDADOS[ nI, 3 ] )
		Next nI
		
		// Executar a macro.
		OLE_ExecuteMacro( oWord, 'WRD_UNIF_REQ_1' )
		OLE_ExecuteMacro( oWord, 'WRD_UNIF_REQ_2' )
		
   	// Atualizar campos.
      OLE_UpDateFields( oWord )
      
		// Salvar o arquivo no formato DOC.
		OLE_SaveAsFile( oWord, cSaidaDOC )
		Sleep(250)
		
		// Abrir o arquivo no formato DOC.
		OLE_OpenFile( oWord, cSaidaDOC )
		Sleep(250)
		
		// Salvar o arquivo no formato PDF.
		OLE_SaveAsFile( oWord, cSaidaPDF, /*cPassword*/, /*cWritePassword*/, lReadOnly, oleWdFormatPDF )
		Sleep(250)
		
		// Fechar a conex�o com o arquivo.
		OLE_CloseFile( oWord )
		
		// Desfazer o link.
		OLE_CloseLink( oWord )
		
		// Apagar o arquivo template.
		FErase( cTemplate )
		
		// Apagar o arquivo word que foi aqui gerado.
		FErase( cSaidaDOC )
		Sleep(250)
		
		ShellExecute( 'Open', cSaidaPDF, '', cTempPath, 1 )
	Else
		MsgAlert('N�o foi poss�vel copiar o arquivo template do servidor para a esta��o, por isso n�o ser� poss�vel gerar o termo.', cCadastro )
	Endif
Return

//----------------------------------------------------------------
// Rotina | A400SX1    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para verificar se existe o grupo de perguntas.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400SX1( cPerg )
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}
	
	/*
	Caracter�stica do vetor p/ utiliza��o da fun��o SX1
	---------------------------------------------------
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	[n,13] -> CNT01 - Campo que ser� atribu�do a claussula BETWWEN ou IN() para SQL.
	*/
	AAdd( aP, { "Qual produto?","C",15,0,"G","","SB1","","","","","",""})
	AAdd( aP, { "Qual armaz�m?","C",02,0,"G","","AL","","","","","",""})
	AAdd( aP, { "Per�odo de?"  ,"D",08,0,"G","","","","","","","",""})
	AAdd( aP, { "Per�odo ate?" ,"D",08,0,"G","(MV_PAR04>=MV_PAR03)","","","","","","",""})
	
	AAdd( aHelp, { "Informe o c�digo do produto.", "" } )
	AAdd( aHelp, { "Informe o c�digo do armaz�m.", "" } )
	AAdd( aHelp, { "Informe a partir de qual data" , "" } )
	AAdd( aHelp, { "Informe at� qual data" , "" } )
	
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		aP[i,13],;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i
Return

//----------------------------------------------------------------
// Rotina | A400Upd    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina de update de dicion�rios e dados.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function A400UPD()
	If MsgYesNo('Confirma o update de dicion�rio e estruturas?','A400UPD')
		FwMsgRun(,{|oSay| A400Go( oSay ) },,'Aguarde alterando a ordem dos campos do SD3.')
	Endif
Return
//----------------------------------------------------------------
// Rotina | A400Go     | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina de execu��o dos updates.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400Go( oSay )
	Local cMsg := ''
	// Executar o processo de ordenar o campos do SD3.
	A400Say( oSay, 'Refazendo a ordem dos campos da tabela SD3' )
	A400OrdCpo( @cMsg )
	// Executar o processo de criar os registros de tipos de movimentos.
	A400Say( oSay, 'Criando registros para Tipo de Movimento (SF5)' )
	A400SF5Cria( @cMsg )
	// Criar os par�metros sist�micos.
	A400Say( oSay, 'Criando os par�metros sist�micos (SX6)' )
	A400SX6( @cMsg )
	// Criar o c�digo de almoxarifado.
	A400Say( oSay, 'Criando o armaz�m de controle de uniformes (SX5)' )
	A400SX5( @cMsg )
	// Emitir o resultado do processamento.
	MsgInfo( cMsg, 'A400Upd' )
Return
//----------------------------------------------------------------
// Rotina | A400Say    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina p/ emiss�o das mensagens conforme processamento
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400Say( oObj, cMensagem )
	oObj:cCaption := cMensagem
	ProcessMessages()
	Sleep( 2000 )
Return
//----------------------------------------------------------------
// Rotina | A400OrdCpo | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para refazer a ordem dos campos da tabela SD3.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400OrdCpo( cMsg )
	Local nI := 0
	Local aOrdem := {}
	AAdd( aOrdem, { 'D3_FILIAL' , '01' } )
	AAdd( aOrdem, { 'D3_TM'     , '02' } )
	AAdd( aOrdem, { 'D3_COD'    , '03' } )
	AAdd( aOrdem, { 'D3_DESCRI' , '04' } )
	AAdd( aOrdem, { 'D3_UM'     , '05' } )
	AAdd( aOrdem, { 'D3_QUANT'  , '06' } )
	AAdd( aOrdem, { 'D3_LOCAL'  , '07' } )
	AAdd( aOrdem, { 'D3_POSTO'  , '08' } )
	AAdd( aOrdem, { 'D3_PARTIC' , '09' } )
	AAdd( aOrdem, { 'D3_CF'     , '10' } )
	AAdd( aOrdem, { 'D3_CONTA'  , '11' } )
	AAdd( aOrdem, { 'D3_OP'     , '12' } )
	AAdd( aOrdem, { 'D3_DOC'    , '13' } )
	AAdd( aOrdem, { 'D3_EMISSAO', '14' } )
	AAdd( aOrdem, { 'D3_GRUPO'  , '15' } )
	AAdd( aOrdem, { 'D3_CUSTO1' , '16' } )
	AAdd( aOrdem, { 'D3_CUSTO2' , '17' } )
	AAdd( aOrdem, { 'D3_CUSTO3' , '18' } )
	AAdd( aOrdem, { 'D3_CUSTO4' , '19' } )
	AAdd( aOrdem, { 'D3_CUSTO5' , '20' } )
	AAdd( aOrdem, { 'D3_CC'     , '21' } )
	AAdd( aOrdem, { 'D3_PARCTOT', '22' } )
	AAdd( aOrdem, { 'D3_ESTORNO', '23' } )
	AAdd( aOrdem, { 'D3_NUMSEQ' , '24' } )
	AAdd( aOrdem, { 'D3_SEGUM'  , '25' } )
	AAdd( aOrdem, { 'D3_QTSEGUM', '26' } )
	AAdd( aOrdem, { 'D3_TIPO'   , '27' } )
	AAdd( aOrdem, { 'D3_NIVEL'  , '28' } )
	AAdd( aOrdem, { 'D3_USUARIO', '29' } )
	AAdd( aOrdem, { 'D3_REGWMS' , '30' } )
	AAdd( aOrdem, { 'D3_PERDA'  , '31' } )
	AAdd( aOrdem, { 'D3_DTLANC' , '32' } )
	AAdd( aOrdem, { 'D3_TRT'    , '33' } )
	AAdd( aOrdem, { 'D3_CHAVE'  , '34' } )
	AAdd( aOrdem, { 'D3_IDENT'  , '35' } )
	AAdd( aOrdem, { 'D3_SEQCALC', '36' } )
	AAdd( aOrdem, { 'D3_RATEIO' , '37' } )
	AAdd( aOrdem, { 'D3_LOTECTL', '38' } )
	AAdd( aOrdem, { 'D3_NUMLOTE', '39' } )
	AAdd( aOrdem, { 'D3_DTVALID', '40' } )
	AAdd( aOrdem, { 'D3_LOCALIZ', '41' } )
	AAdd( aOrdem, { 'D3_NUMSERI', '42' } )
	AAdd( aOrdem, { 'D3_CUSFF1' , '43' } )
	AAdd( aOrdem, { 'D3_CUSFF2' , '44' } )
	AAdd( aOrdem, { 'D3_CUSFF3' , '45' } )
	AAdd( aOrdem, { 'D3_CUSFF4' , '46' } )
	AAdd( aOrdem, { 'D3_CUSFF5' , '47' } )
	AAdd( aOrdem, { 'D3_ITEM'   , '48' } )
	AAdd( aOrdem, { 'D3_OK'     , '49' } )
	AAdd( aOrdem, { 'D3_ITEMCTA', '50' } )
	AAdd( aOrdem, { 'D3_CLVL'   , '51' } )
	AAdd( aOrdem, { 'D3_PROJPMS', '52' } )
	AAdd( aOrdem, { 'D3_TASKPMS', '53' } )
	AAdd( aOrdem, { 'D3_ORDEM'  , '54' } )
	AAdd( aOrdem, { 'D3_CODGRP' , '55' } )
	AAdd( aOrdem, { 'D3_CODITE' , '56' } )
	AAdd( aOrdem, { 'D3_SERVIC' , '57' } )
	AAdd( aOrdem, { 'D3_STSERV' , '58' } )
	AAdd( aOrdem, { 'D3_OSTEC'  , '59' } )
	AAdd( aOrdem, { 'D3_POTENCI', '60' } )
	AAdd( aOrdem, { 'D3_TPESTR' , '61' } )
	AAdd( aOrdem, { 'D3_REGATEN', '62' } )
	AAdd( aOrdem, { 'D3_ITEMSWN', '63' } )
	AAdd( aOrdem, { 'D3_DOCSWN' , '64' } )
	AAdd( aOrdem, { 'D3_ITEMGRD', '65' } )
	AAdd( aOrdem, { 'D3_STATUS' , '66' } )
	AAdd( aOrdem, { 'D3_CUSRP1' , '67' } )
	AAdd( aOrdem, { 'D3_CUSRP2' , '68' } )
	AAdd( aOrdem, { 'D3_CUSRP3' , '69' } )
	AAdd( aOrdem, { 'D3_CUSRP4' , '70' } )
	AAdd( aOrdem, { 'D3_CUSRP5' , '71' } )
	AAdd( aOrdem, { 'D3_CMRP'   , '72' } )
	AAdd( aOrdem, { 'D3_MOEDRP' , '73' } )
	AAdd( aOrdem, { 'D3_MOEDA'  , '74' } )
	AAdd( aOrdem, { 'D3_EMPOP'  , '75' } )
	AAdd( aOrdem, { 'D3_DIACTB' , '76' } )
	AAdd( aOrdem, { 'D3_GARANTI', '77' } )
	AAdd( aOrdem, { 'D3_PMICNUT', '78' } )
	AAdd( aOrdem, { 'D3_CMFIXO' , '79' } )
	AAdd( aOrdem, { 'D3_NODIA'  , '80' } )
	AAdd( aOrdem, { 'D3_PMACNUT', '81' } )
	AAdd( aOrdem, { 'D3_NRBPIMS', '82' } )
	AAdd( aOrdem, { 'D3_CODLAN' , '83' } )
	AAdd( aOrdem, { 'D3_ID_UNIF', '84' } )
	For nI := 1 To Len( aOrdem )
		NGALTCONTEU( 'SX3', aOrdem[ nI, 1 ], 2, 'X3_ORDEM', aOrdem[ nI, 2 ] )
	Next nI
	cMsg += 'Altera��o da ordem dos campos da tabela SD3 efetuadas com sucesso' + CRLF
Return
//----------------------------------------------------------------
// Rotina | A400SF5Cria | Autor | Robson Gon�alves    | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para refazer a ordem dos campos da tabela SD3.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400SF5Cria( cMsg )
	Local nI := 0
	Local nJ := 0
	Local aReg := {}
	Local aDados := {}
	AAdd( aReg, { 'F5_FILIAL' , xFilial( 'SF5' ) } )
	AAdd( aReg, { 'F5_CODIGO' , '110' } )
	AAdd( aReg, { 'F5_TIPO'   , 'D' } )
	AAdd( aReg, { 'F5_TEXTO'  , 'DEVOL. CARGA INICIAL' } )
	AAdd( aReg, { 'F5_APROPR' , 'N' } )
	AAdd( aReg, { 'F5_ATUEMP' , 'N' } )
	AAdd( aReg, { 'F5_TRANMOD', 'N' } )
	AAdd( aReg, { 'F5_VAL'    , 'S' } ) // <----- PRECISA SER VALORIZADO PARA O USU�RIO INFORMAR O CUSTO ***
	AAdd( aReg, { 'F5_ENVCQPR', 'N' } )
	AAdd( aReg, { 'F5_LIBPVPR', 'N' } )
	AAdd( aReg, { 'F5_QTDZERO', '2' } )
	AAdd( aReg, { 'F5_AGREGCU', '2' } )
	AAdd( aReg, { 'F5_MSBLQL' , '2' } )
	AAdd( aReg, { 'F5_UNIFORM', 'N' } )
	AAdd( aDados, aReg )
	aReg := {}
	AAdd( aReg, { 'F5_FILIAL' , xFilial( 'SF5' ) } )
	AAdd( aReg, { 'F5_CODIGO' , '210' } )
	AAdd( aReg, { 'F5_TIPO'   , 'D' } )
	AAdd( aReg, { 'F5_TEXTO'  , 'UNIF. DEVOL.C/ CONTR' } )
	AAdd( aReg, { 'F5_APROPR' , 'N' } )
	AAdd( aReg, { 'F5_ATUEMP' , 'N' } )
	AAdd( aReg, { 'F5_TRANMOD', 'N' } )
	AAdd( aReg, { 'F5_VAL'    , 'N' } )
	AAdd( aReg, { 'F5_ENVCQPR', 'N' } )
	AAdd( aReg, { 'F5_LIBPVPR', 'N' } )
	AAdd( aReg, { 'F5_QTDZERO', '2' } )
	AAdd( aReg, { 'F5_AGREGCU', '2' } )
	AAdd( aReg, { 'F5_MSBLQL' , '2' } )
	AAdd( aReg, { 'F5_UNIFORM', 'S' } )
	AAdd( aDados, aReg )
	aReg := {}
	AAdd( aReg, { 'F5_FILIAL' , xFilial( 'SF5' ) } )
	AAdd( aReg, { 'F5_CODIGO' , '710' } )
	AAdd( aReg, { 'F5_TIPO'   , 'R' } )
	AAdd( aReg, { 'F5_TEXTO'  , 'UNIF. REQ. C/ CONTR.' } )
	AAdd( aReg, { 'F5_APROPR' , 'N' } )
	AAdd( aReg, { 'F5_ATUEMP' , 'N' } )
	AAdd( aReg, { 'F5_TRANMOD', 'N' } )
	AAdd( aReg, { 'F5_VAL'    , 'N' } )
	AAdd( aReg, { 'F5_ENVCQPR', 'N' } )
	AAdd( aReg, { 'F5_LIBPVPR', 'N' } )
	AAdd( aReg, { 'F5_QTDZERO', '2' } )
	AAdd( aReg, { 'F5_AGREGCU', '2' } )
	AAdd( aReg, { 'F5_MSBLQL' , '2' } )
	AAdd( aReg, { 'F5_UNIFORM', 'S' } )
	AAdd( aDados, aReg )
	SF5->( dbSetOrder( 1 ) )
	BEGIN TRANSACTION
		For nI := 1 To Len( aDados )
			If SF5->( dbSeek( aDados[ nI, 1, 2 ] + aDados[ nI, 2, 2 ] ) )
				cMsg += 'Tipo de Movto ' + aDados[ nI, 2, 2 ] + ', j� existe cadastro com este c�digo.' + CRLF
				Loop
			Else
				SF5->( RecLock( 'SF5', .T. ) )
				For nJ := 1 To Len( aDados[ nI ] )
					SF5->( FieldPut( FieldPos( aDados[ nI, nJ, 1 ] ), aDados[ nI, nJ, 2 ] ) )
				Next nJ
				SF5->( MsUnLock() )
				cMsg += 'Tipo de Movto ' + aDados[ nI, 2, 2 ] + ', cadastrado com sucesso.' + CRLF
			Endif
		Next nI
	END TRANSACTION
Return
//----------------------------------------------------------------
// Rotina | A400SX6    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para criar os par�metros sist�micos.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400SX6( cMsg )
	Local cMV_400ALMO := 'MV_400ALMO' // Almoxarifado padr�o para uniformes 20.
	Local cMV_400TPIN := 'MV_400TPIN' // Tipo de movimento 110 - devolu��o para carga inicial de produtos no estoque.
	Local cMV_400DEVO := 'MV_400DEVO' // Tipo de movimento 210 - devolu��o ao estoque com controle de posto/participante.
	Local cMV_400REQU := 'MV_400REQU' // Tipo de movimento 710 - requisi��o ao estoque com controle de posto/participante.
	Local cMV_400WREQ := 'MV_400WREQ' // Endere�o e nome do arquivo template word para gerar o termo de recebimento.
	Local cMV_400WDEV := 'MV_400WDEV' // Endere�o e nome do arquivo template word para gerar o termo de devolu��o.
	If .NOT. GetMV( cMV_400ALMO, .T. )
		CriarSX6( cMV_400ALMO, 'C', 'ALMOXARIFADO PARA O CONTROLE DE UNIFORMES', '20' )
		cMsg += 'Par�metro ' + cMV_400ALMO + ' criado com sucesso.' + CRLF
	Else
		cMsg += 'Par�metro ' + cMV_400ALMO + ' j� criado.' + CRLF
	Endif
	If .NOT. GetMV( cMV_400TPIN, .T. )
		CriarSX6( cMV_400TPIN, 'C', 'TIPO DE MOVIMENTO P/ CONTROLE DE UNIFORMES CARGA INICIAL SEM CONTROLE POSTO/PARTICIPANTE.', '110' )
		cMsg += 'Par�metro ' + cMV_400TPIN + ' criado com sucesso.' + CRLF
	Else
		cMsg += 'Par�metro ' + cMV_400TPIN + ' j� criado.' + CRLF
	Endif
	If .NOT. GetMV( cMV_400DEVO, .T. )
		CriarSX6( cMV_400DEVO, 'C', 'TIPO DE MOVIMENTO P/ CONTROLE DE UNIFORMES DEVOLU��O AO ESTOQUE COM CONTROLE POSTO/PARTICIPANTE.', '210' )
		cMsg += 'Par�metro ' + cMV_400DEVO + ' criado com sucesso.' + CRLF 
	Else
		cMsg += 'Par�metro ' + cMV_400DEVO + ' j� criado.' + CRLF 
	Endif
	If .NOT. GetMV( cMV_400REQU, .T. )
		CriarSX6( cMV_400REQU, 'C', 'TIPO DE MOVIMENTO P/ CONTROLE DE UNIFORMES REQUISICAO AO ESTOQUE COM CONTROLE POSTO/PARTICIPANTE.', '710' )
		cMsg += 'Par�metro ' + cMV_400REQU + ' criado com sucesso.' + CRLF
	Else
		cMsg += 'Par�metro ' + cMV_400REQU + ' j� criado.' + CRLF
	Endif
	If GetMv( 'MV_VLDALMO', .F. ) <> 'N'
		PutMv( 'MV_VLDALMO', 'N' )
		cMsg += 'Foi necess�rio modificar o conte�do do par�metro MV_VLDALMO para N' + CRLF
	Else
		cMsg += 'N�o foi necess�rio modificar o conte�do do par�metro MV_VLDALMO para N.' + CRLF
	Endif
	If .NOT. GetMV( cMV_400WREQ, .T. )
		CriarSX6( cMV_400WREQ, 'C', 'ENDERECO E NOME DO ARQUIVO TEMPLATE WORD PARA GERAR O TERMO DE RECEBIMENTO', '\dirdoc\csfa400req.dot' )
		cMsg += 'Par�metro ' + cMV_400WREQ + ' criado com sucesso.' + CRLF
	Else
		cMsg += 'Par�metro ' + cMV_400WREQ + ' j� criado.' + CRLF
	Endif
	If .NOT. GetMV( cMV_400WDEV, .T. )
		CriarSX6( cMV_400WDEV, 'C', 'ENDERECO E NOME DO ARQUIVO TEMPLATE WORD PARA GERAR O TERMO DE DEVOLUCAO', '\dirdoc\csfa400dev.dot' )
		cMsg += 'Par�metro ' + cMV_400WDEV + ' criado com sucesso.' + CRLF
	Else
		cMsg += 'Par�metro ' + cMV_400WDEV + ' j� criado.' + CRLF
	Endif	
Return
//----------------------------------------------------------------
// Rotina | A400SX5    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina para criar o armaz�m de controle de unifomes.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
Static Function A400SX5( cMsg )
	Local cMV_400ALMO := GetMv( 'MV_400ALMO', .F. )
	SX5->( dbSetOrder( 1 ) )
	If SX5->( dbSeek( xFilial( 'SX5' ) + 'AL' + cMV_400ALMO ) )
		cMsg += 'Armaz�m padr�o para o controle de uniformes j� existe.'
	Else
		SX5->( RecLock( 'SX5', .T. ) )
		SX5->X5_FILIAL  := xFilial( 'SX5' )
		SX5->X5_TABELA  := 'AL'
		SX5->X5_CHAVE   := cMV_400ALMO
		SX5->X5_DESCRI  := 'ARMAZEM PARA CONTROLE DE UNIFORMES'
		SX5->X5_DESCSPA := 'ARMAZEM PARA CONTROLE DE UNIFORMES'
		SX5->X5_DESCENG := 'ARMAZEM PARA CONTROLE DE UNIFORMES'
		SX5->( MsUnLock() )
		cMsg += 'Armaz�m padr�o para o controle de uniformes criado com sucesso.'
	Endif
Return
//----------------------------------------------------------------
// Rotina | UPD400     | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina update para criar tabela, campos, �ndices e 
//        | gatilhos.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function UPD400()
	Local cModulo := 'EST'
	Local bPrepar := {|| U_U400Ini() }
	Local nVersao := 01	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return
//----------------------------------------------------------------
// Rotina | U400Ini    | Autor | Robson Gon�alves     | 08.07.2014
//----------------------------------------------------------------
// Descr. | Rotina auxiliar de update para criar tabela, campos, 
//        | �ndices e gatilhos.
//----------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------
User Function U400Ini()
	Local cX3_VLDUSER := ''
	Local cX3_CBOX := 'RE=Requsicao;DE=Devolucao;AR=Ajuste Requisicao;AD=Ajuste Devolucao;TR=Transferencia'
	aSX2 := {}
	aSX3 := {}
	aSIX := {}
	aSX7 := {}
	aHelp := {}
	// Criar a tabela.
	AAdd(aSX2,{'PAI','','Inventario de Uniformes','Inventario de Uniformes','Inventario de Uniformes','E','',})
	// Criar campo e help.
	AAdd(aSX3,{'PAI','01','PAI_FILIAL','C', 2,0 ,'Filial'       ,'Filial'       ,'Filial'       ,'Filial do Sistema'       ,'Filial do Sistema'       ,'Filial do Sistema'       ,'@!'                 ,'','���������������',''         ,''   ,1,'��','','' ,'U','N','A','R','' ,''                       ,''           ,''           ,''           ,'','','','033','','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','02','PAI_ID'    ,'C', 6,0 ,'Ident'        ,'Ident'        ,'Ident'        ,'Identificador'           ,'Identificador'           ,'Identificador'           ,'@!'                 ,'','���������������',''         ,''   ,1,'��','','' ,'U','S','V','R','�',''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	cX3_VLDuSER := 'EXISTCPO("SB1").AND.U_A400PROD()'
	AAdd(aSX3,{'PAI','03','PAI_PRODUT','C',15,0 ,'Produto'      ,'Produto'      ,'Produto'      ,'Codigo do produto'       ,'Codigo do produto'       ,'Codigo do produto'       ,'@!'                 ,'','���������������',''         ,'SB1',1,'��','','S','U','S','A','R','�',cX3_VLDUSER              ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','04','PAI_DESCRI','C',30,0 ,'Descr.Prod.'  ,'Descr.Prod.'  ,'Descr.Prod.'  ,'Descri��o do produto'    ,'Descri��o do produto'    ,'Descri��o do produto'    ,'@!'                 ,'','�������������� ',''         ,''   ,1,'��','','' ,'U','S','V','R','' ,'ExistCpo("SZ3")'        ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','05','PAI_POSTO' ,'C', 6,0 ,'Posto'        ,'Posto'        ,'Posto'        ,'Codigo do posto'         ,'Codigo do posto'         ,'Codigo do posto'         ,'@!'                 ,'','�������������� ',''         ,'SZ3',1,'��','','S','U','S','A','R','�',''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','06','PAI_DPOSTO','C',99,0 ,'Descr.Posto'  ,'Descr.Posto'  ,'Descr.Posto'  ,'Descricao do posto'      ,'Descricao do posto'      ,'Descricao do posto'      ,'@!'                 ,'','�������������� ',''         ,''   ,1,'��','','' ,'U','S','V','R','' ,'ExistCpo("RD0")'        ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','07','PAI_PARTIC','C', 6,0 ,'Participante' ,'Participante' ,'Participante' ,'Codigo do participante'  ,'Codigo do participante'  ,'Codigo do participante'  ,'@!'                 ,'','�������������� ',''         ,'RD0',1,'��','','S','U','S','A','R','�',''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','08','PAI_NPARTI','C',30,0 ,'Nome Partic.' ,'Nome Partic.' ,'Nome Partic.' ,'Nome do participante'    ,'Nome do participante'    ,'Nome do participante'    ,'@!'                 ,'','�������������� ',''         ,''   ,1,'��','','' ,'U','S','V','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','09','PAI_EMISSA','D', 8,0 ,'Emissao'      ,'Emissao'      ,'Emissao'      ,'Data de emissao'         ,'Data de emissao'         ,'Data de emissao'         ,'  '                 ,'','�������������� ','DDATABASE',''   ,1,'��','','' ,'U','S','V','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','10','PAI_HORA'  ,'C', 8,0 ,'Hora'         ,'Hora'         ,'Hora'         ,'Hora da emissao'         ,'Hora da emissao'         ,'Hora da emissao'         ,'  '                 ,'','�������������� ','TIME()'   ,''   ,1,'��','','' ,'U','S','V','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','11','PAI_DOC'   ,'C', 9,0 ,'Documento'    ,'Documento'    ,'Documento'    ,'Numero do documento'     ,'Numero do documento'     ,'Numero do documento'     ,'@!'                 ,'','�������������� ',''         ,''   ,1,'��','','' ,'U','S','V','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','12','PAI_NUMSEQ','C', 6,0 ,'Sequencial'   ,'Sequencial'   ,'Sequencial'   ,'Sequencia do movimento'  ,'Sequencia do movimento'  ,'Sequencia do movimento'  ,'@!'                 ,'','�������������� ',''         ,''   ,1,'��','','' ,'U','S','V','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','13','PAI_TM'    ,'C', 2,0 ,'Tipo Movto.'  ,'Tipo Movto.'  ,'Tipo Movto.'  ,'Tipo do movimento'       ,'Tipo do movimento'       ,'Tipo do movimento'       ,'@!'                 ,'','�������������� ',''         ,''   ,1,'��','','' ,'U','S','V','R','�',''                       ,cX3_CBOX     ,cX3_CBOX     ,cX3_CBOX     ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','14','PAI_QUANT' ,'N', 9,0 ,'Quantidade'   ,'Quantidade'   ,'Quantidade'   ,'Quantidade movimentada'  ,'Quantidade movimentada'  ,'Quantidade movimentada'  ,'@E 999,999,999'     ,'','�������������� ',''         ,''   ,1,'��','','S','U','S','A','R','�','Positivo()'             ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','15','PAI_CUSTO' ,'N',14,4 ,'Custo Unit.'  ,'Custo Unit.'  ,'Custo Unit.'  ,'Custo unitario movimento','Custo unitario movimento','Custo unitario movimento','@E 999,999,999.9999','','�������������� ',''         ,''   ,1,'��','','S','U','S','V','R','�',''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','16','PAI_TOTAL' ,'N',14,4 ,'Custo Total'  ,'Custo Total'  ,'Custo Total'  ,'Custo total do movimento','Custo total do movimento','Custo total do movimento','@E 999,999,999.9999','','�������������� ',''         ,''   ,1,'��','','' ,'U','S','V','R','�',''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','17','PAI_CONTA' ,'C',20,0 ,'Conta Contab' ,'Conta Contab' ,'Conta Contab' ,'Conta contabil'          ,'Conta contabil'          ,'Conta contabil'          ,'@!'                 ,'','�������������� ',''         ,'CT1',1,'��','','' ,'U','S','A','R','' ,'Vazio().Or.Ctb105Cta()' ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','18','PAI_CC'    ,'C', 9,0 ,'Cento Custo'  ,'Cento Custo'  ,'Cento Custo'  ,'Centro de custo'         ,'Centro de custo'         ,'Centro de custo'         ,'@!'                 ,'','�������������� ',''         ,'CTT',1,'��','','' ,'U','S','A','R','' ,'Vazio().Or.CTB105CC()'  ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','19','PAI_ITEMCT','C', 9,0 ,'Item Contab'  ,'Item Contab'  ,'Item Contab'  ,'Item contabil'           ,'Item contabil'           ,'Item contabil'           ,'@!'                 ,'','�������������� ',''         ,'CTD',1,'��','','' ,'U','S','A','R','' ,'Vazio().Or.Ctb105Item()',''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','20','PAI_CLVL'  ,'C', 9,0 ,'Classe Valor' ,'Classe Valor' ,'Classe Valor' ,'Classe de valor'         ,'Classe de valor'         ,'Classe de valor'         ,'@!'                 ,'','�������������� ',''         ,'CTH',1,'��','','' ,'U','S','A','R','' ,'Vazio().Or.Ctb105ClVl()',''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','21','PAI_ESTORN','C', 1,0 ,'Estornado'    ,'Estornado'    ,'Estornado'    ,'Registro estornado'      ,'Registro estornado'      ,'Registro estornado'      ,'@!'                 ,'','�������������� ','"N"'      ,''   ,1,'��','','' ,'U','S','V','R','' ,'Pertence("SN")'         ,'N=Nao;S=Sim','N=Nao;S=Sim','N=Nao;S=Sim','','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','22','PAI_DTESTO','D', 8,0 ,'Dt.Estornado' ,'Dt.Estornado' ,'Dt.Estornado' ,'Data do estorno'         ,'Data do estorno'         ,'Data do estorno'         ,'99/99/99'           ,'','�������������� ',''         ,''   ,1,'��','','' ,'U','S','V','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','23','PAI_IDORIG','C', 6,0 ,'Ident.Orig.'  ,'Ident.Orig.'  ,'Ident.Orig.'  ,'Identificador origem'    ,'Identificador origen'    ,'Identificador origem'    ,'@!'                 ,'','���������������',''         ,''   ,1,'��','','' ,'U','S','V','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	cX3_VLDUSER := 'EXISTCPO("SX5","AL"+M->PAI_ALMOX).AND.U_A400ALMOX()'
	AAdd(aSX3,{'PAI','24','PAI_ALMOX' ,'C', 2,0 ,'Almoxarifado' ,'Almoxarifado' ,'Almoxarifado' ,'Almoxarifado do produto' ,'Almoxarifado do produto' ,'Almoxarifado do produto' ,'@!'                 ,'','���������������',''         ,'AL' ,1,'��','','' ,'U','S','A','R','' ,cX3_VLDUSER              ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'PAI','25','PAI_TRANSF','C', 1,0 ,'Movto.Transf' ,'Movto.Transf' ,'Movto.Transf' ,'Movimento transferido'   ,'Movimento transferido'   ,'Movimento transferido'   ,'@!'                 ,'','���������������',''         ,''   ,1,'��','','' ,'U','S','V','R','' ,''                       ,'N=Nao;S=Sim','N=Nao;S=Sim','N=Nao;S=Sim','','','',''   ,'','','','','S','S','S','',''})	
	AAdd(aHelp,{'PAI_FILIAL','C�digo da filial no sistema.'})
	AAdd(aHelp,{'PAI_ID'    ,'Codigo identificador do registro.'})
	AAdd(aHelp,{'PAI_PRODUT','Codigo do produto.'})
	AAdd(aHelp,{'PAI_DESCRI','Descri��o do produto.'})
	AAdd(aHelp,{'PAI_POSTO' ,'C�digo do posto/entidade parceira.'})
	AAdd(aHelp,{'PAI_DPOSTO','Descri��o do posto/entidade parceira.'})
	AAdd(aHelp,{'PAI_PARTIC','C�digo do participante.'})
	AAdd(aHelp,{'PAI_NPARTI','Nome do participante.'})
	AAdd(aHelp,{'PAI_EMISSA','Data de emiss�o do movimento.'})
	AAdd(aHelp,{'PAI_HORA'  ,'Hora do movimento.'})
	AAdd(aHelp,{'PAI_DOC'   ,'N�mero do documento do movimento interno (SD3).'})
	AAdd(aHelp,{'PAI_NUMSEQ','N�mero sequencia do movimento interno (SD3)'})
	AAdd(aHelp,{'PAI_TM'    ,'Tipo do movimento (REQ=Requisi��o/DEV=Devolu��o/ARE=Ajuste de requisi��o/ADE=Ajuste de devolu��o.)'})
	AAdd(aHelp,{'PAI_QUANT' ,'Quantidade do movimento.'})
	AAdd(aHelp,{'PAI_CUSTO' ,'Custo do movimento.'})
	AAdd(aHelp,{'PAI_TOTAL' ,'Custo total do movimento.'})
	AAdd(aHelp,{'PAI_CONTA' ,'C�digo da conta cont�bil.'})
	AAdd(aHelp,{'PAI_CC'    ,'C�digo do centro de custo.'})
	AAdd(aHelp,{'PAI_ITEMCT','C�digo do item cont�bil.'})
	AAdd(aHelp,{'PAI_CLVL'  ,'C�digo da classe de valor.'})
	AAdd(aHelp,{'PAI_ESTORN','Registro estornado S=Sim.'})
	AAdd(aHelp,{'PAI_DTESTO','Data em que ocorreu o estorno do movimento'})
	AAdd(aHelp,{'PAI_IDORIG','Codigo identificador do registro origem.'})
	AAdd(aHelp,{'PAI_ALMOX' ,'Almoxarifado de movimento do produto.'})
	AAdd(aHelp,{'PAI_TRANSF','Se preenchido com S=Sim identifica que o movimento foi transferido.'})
	// Criar campo e help.
	AAdd(aSX3,{'SD3',NIL,'D3_POSTO'  ,'C', 6,0 ,'Posto'        ,'Posto'        ,'Posto'        ,'Codigo do posto'         ,'Codigo do posto'         ,'Codigo do posto'         ,'@!'                 ,'','�������������� ',''                         ,'SZ3',1,'��','',''  ,'U','S','A','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'SD3',NIL,'D3_PARTIC' ,'C', 6,0 ,'Participante' ,'Participante' ,'Participante' ,'Codigo do participante'  ,'Codigo do participante'  ,'Codigo do participante'  ,'@!'                 ,'','�������������� ',''                         ,'RD0',1,'��','',''  ,'U','S','A','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aSX3,{'SD3',NIL,'D3_ID_UNIF','C', 6,0 ,'Id.Uniforme'  ,'Id.Uniforme'  ,'Id.Uniforme'  ,'Identificador uniforme'  ,'Identificador uniforme'  ,'Identificador uniforme'  ,'@!'                 ,'','���������������',''                         ,''   ,1,'��','',''  ,'U','S','V','R','' ,''                       ,''           ,''           ,''           ,'','','',''   ,'','','','','S','S','S','',''})
	AAdd(aHelp,{'D3_POSTO'  ,'C�digo do posto parceiro da Certisign para onde est� sendo fornecido ou recebido o uniforme.'})
	AAdd(aHelp,{'D3_PARTIC' ,'C�digo do participante que ir� receber ou est� devolvendo o uniforme.'})
	AAdd(aHelp,{'D3_ID_UNIF','C�digo de identifica��o do registro do invent�rio para o controle de uniforme.'})
	// Criar campo e help.
	AAdd(aSX3,{'SF5',NIL,'F5_UNIFORM' ,'C', 1,0 ,'Ctr.Uniforme' ,'Ctr.Uniforme' ,'Ctr.Uniforme' ,'Controle de uniforme'    ,'Controle de uniforme'    ,'Controle de uniforme'    ,'@!'                 ,'','�������������� ',''                         ,''   ,1,'��','','' ,'U','S','A','R','' ,'Vazio().Or.Pertence("SN")','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','',''   ,'','','','','S','S','S','',''})
	AAdd(aHelp,{'F5_UNIFORM','Determinar se o movimento interno far� controle no invent�rio de uniforme.'})
	// Criar �ndices.
	AAdd(aSIX,{'PAI','1','PAI_FILIAL+PAI_ID'                   ,'Ident'  ,'Ident'  ,'Ident'                                            ,'U','S'})
	AAdd(aSIX,{'PAI','2','PAI_FILIAL+DTOS(PAI_EMISSA)+PAI_HORA','Emissao + Hora','Emissao + Hora','Emissao + Hora'                     ,'U','S'})
	AAdd(aSIX,{'PAI','3','PAI_FILIAL+PAI_PRODUT'               ,'Produto','Produto','Produto'                                          ,'U','S'})
	AAdd(aSIX,{'PAI','4','PAI_FILIAL+PAI_DESCRI'               ,'Descr.Prod.','Descr.Prod.','Descr.Prod.'                              ,'U','S'})
	AAdd(aSIX,{'PAI','5','PAI_FILIAL+PAI_POSTO'                ,'Posto','Posto','Posto'                                                ,'U','S'})
	AAdd(aSIX,{'PAI','6','PAI_FILIAL+PAI_DPOSTO'               ,'Descr.Posto.','Descr.Posto.','Descr.Posto'                            ,'U','S'})
	AAdd(aSIX,{'PAI','7','PAI_FILIAL+PAI_PARTIC'               ,'Participante','Participante','Participante'                           ,'U','S'})
	AAdd(aSIX,{'PAI','8','PAI_FILIAL+PAI_NPARTI'               ,'Nome Partic.','Nome Partic.','Nome Partic.'                           ,'U','S'})
	AAdd(aSIX,{'PAI','9','PAI_FILIAL+PAI_DOC+PAI_NUMSEQ'       ,'Documento + Sequencia','Documento + Sequencia','Documento + Sequencia','U','S'})
	AAdd(aSIX,{'PAI','A','PAI_FILIAL+PAI_IDORIG'               ,'Ident.Orig.','Ident.Orig.','Ident.Orig.'                              ,'U','S'})
	// Criar gatilho.
	AAdd(aSX7,{'PAI_PRODUT','001','SB1->B1_DESC'             ,'PAI_DESCRI','P','S','SB1',1,'XFILIAL("SB1")+M->PAI_PRODUT','','U'})
	AAdd(aSX7,{'PAI_POSTO' ,'001','SZ3->Z3_DESENT'           ,'PAI_DPOSTO','P','S','SZ3',1,'XFILIAL("SZ3")+M->PAI_POSTO' ,'','U'})
	AAdd(aSX7,{'PAI_PARTIC','001','RD0->RD0_NOME'            ,'PAI_NPARTI','P','S','RD0',1,'XFILIAL("RD0")+M->PAI_PARTIC','','U'})
	AAdd(aSX7,{'PAI_QUANT' ,'001','M->PAI_QUANT*M->PAI_CUSTO','PAI_TOTAL' ,'P','N',''   ,0,''                            ,'','U'})
	AAdd(aSX7,{'PAI_CUSTO' ,'001','M->PAI_CUSTO*M->PAI_QUANT','PAI_TOTAL ','P','N',''   ,0,''                            ,'','U'})
Return