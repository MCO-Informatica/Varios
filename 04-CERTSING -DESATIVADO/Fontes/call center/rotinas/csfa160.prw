//------------------------------------------------------------------
// Rotina | CSFA160 | Autor | Robson Luiz - Rleg | Data | 16/05/2013
//------------------------------------------------------------------
// Descr. | Rotina de manutenção na tabela de importação de listas.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
#Include 'Protheus.ch'
#DEFINE cDOWNLOAD 'listcontat'

User Function CSFA160()	
	Private aParam := {}
	Private aRotina := {}
	Private cRotina := FunName()
	Private cCadastro := 'Importação de listas de Contato'
	
	//-------------------------------------------------------------------
	// A variável aParam deve ser criada com todos os 4 elementos, 
	// pois a função AxDeleta executar via Eval() cada elemento.
	//-------------------------------------------------------------------
	// aParam[1] - Processamento de codeblock de antes da interface
	// aParam[2] - Processamento de codeblock de validacao de confirmacao
	// aParam[3] - Processamento de codeblock dentro da transacao
	// aParam[4] - Processamento de codeblock fora da transacao
	//-------------------------------------------------------------------
	AAdd( aParam, {||  } ) 
	AAdd( aParam, {|| MsgYesNo( 'Confirma a exclusão do registro?', cCadastro ) } ) 
	AAdd( aParam, {||  } ) 
	AAdd( aParam, {||  } ) 

	//----------------------------------------------------------------------------------------------------------------------
	// Comentei a opção de Incluir pq não faz sentido incluir um mailing e não gerar demais dados nas tabelas (SU4/SU6).
	// A inclusão será sempre por importação de dados.
	// AAdd( aRotina, { 'Incluir'   , 'AxInclui' , 0, 3 } ) 
	//----------------------------------------------------------------------------------------------------------------------
	AAdd( aRotina, { 'Pesquisar' , 'AxPesqui' , 0, 1 } )
	AAdd( aRotina, { 'Visualizar', 'AxVisual' , 0, 2 } )
	AAdd( aRotina, { 'Alterar'   , 'AxAltera' , 0, 4 } )
	AAdd( aRotina, { 'Contatos'  , 'FTContato( "PAB", PAB->( RecNo() ), 4, , 2 )', 0, 4 } )
	AAdd( aRotina, { 'Excluir'   , 'AxDeleta( "PAB", PAB->( RecNo() ), 5, , , , aParam )', 0, 5 } )
	AAdd( aRotina, { 'Importar'  , 'U_FA160Imp', 0, 3 } )
	AAdd( aRotina, { 'Follow-Up' , 'U_FA160FUp', 0, 3 } )
	
	//----------------------------------------------------
	// Verifica a existencia "Fisica" de uma Tabela do SX2
	//----------------------------------------------------
	If Sx2ChkTable( 'PAB' , __cRdd, .F. )
		//--------------------------------------------------------------------
		// Verificar se toda infra-estrutura para atender a rotina foi criado.
		//--------------------------------------------------------------------
		If FA160CanUse()
			dbSelectArea( "PAB" )
			dbSetOrder( 1 )
		
			MBrowse( , , , , 'PAB' )
		Endif
	Else
		MsgAlert( 'Tabela de Importação de listas (PAB) não foi criada. Execute o UpDate de dicionário de dados p/ utilizar esta rotina.', cRotina )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA160CanUse | Autor | Robson Luiz - Rleg  | Dt | 16/05/12
//-------------------------------------------------------------------
// Descr. | Rotina para verificar se a infra-estrurura da rotina foi
//        | criada.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160CanUse()
	Local nI := 0
	Local aCpoSXB := {}
	Local aSXB := {}
	Local cTamSXB := 0
	Local cX6_VAR := 'MV_ORILST2'
	Local cX6_CONTEUD := "1=Leads|2=Mailing Campinas|3=Mailing Advogados|4=Saude"

	//----------------------------------------
	// Existe a chave para a tabela em questão
	//----------------------------------------
	SX5->( dbSetOrder( 1 ) )
	If ! SX5->( dbSeek( xFilial( 'SX5' ) + 'T5' + 'PAB' ) )
		SX5->(RecLock('SX5',.T.))
		SX5->X5_FILIAL  := xFilial('SX5')
		SX5->X5_TABELA  := 'T5'
		SX5->X5_CHAVE   := 'PAB'
		SX5->X5_DESCRI  := 'Import. Listas Contatos'
		SX5->X5_DESCSPA := 'Import. Listas Contatos'
		SX5->X5_DESCENG := 'Import. Listas Contatos'
		SX5->(MsUnLock())
	Endif

	//--------------------------------------------------------
	// Verificar se existe o parâmetro com os tipos de listas.
	//--------------------------------------------------------
	If !ExisteSX6( cX6_VAR )
		CriarSX6( cX6_VAR, 'C', 'Tipos de lista de contato para agenda do operador - CSFA160.prw', cX6_CONTEUD )
	Endif
	
	//-------------------------------
	// Verificar se existe o gatilho.
	//-------------------------------
	SX7->(dbSetOrder(1))
	If ! SX7->(dbSeek('PAB_CONSUL'+'001'))
		SX7->(RecLock('SX7',.T.))
		SX7->X7_CAMPO   := 'PAB_CONSUL'
		SX7->X7_SEQUENC := '001'
		SX7->X7_REGRA   := 'Posicione("SU7",4,xFilial("SU7")+SA3->A3_CODUSR,"U7_COD")'
		SX7->X7_CDOMIN  := 'PAB_OPERAD'
		SX7->X7_TIPO    := 'P'
		SX7->X7_SEEK    := 'S'
		SX7->X7_ALIAS   := 'SA3'
		SX7->X7_ORDEM   := 1
		SX7->X7_CHAVE   := 'xFilial("SA3")+M->PAB_CONSUL'
		SX7->X7_CONDIC  := ''
		SX7->X7_PROPRI  := 'U'
		SX7->(MsUnLock())
	Endif
	
	//--------------------------
	// Existe a consulta padrão.
	//--------------------------
	SXB->( dbSetOrder( 1 ) )
	If ! SXB->( dbSeek( 'PAB   ' ) )
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { "XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM","XB_WCONTEM" }
		
		AAdd(aSXB,{"PAB","1","01","DB","Import. Listas Cont.","Import. Listas Cont.","Import. Listas Cont.","PAB",""})
		
		AAdd(aSXB,{"PAB","2","01","01","Codigo","Codigo","Codigo","",""})
		AAdd(aSXB,{"PAB","2","02","02","Nome","Nome","Nome","",""})
		AAdd(aSXB,{"PAB","2","03","03","Empresa","Empresa","Empresa","",""})
		AAdd(aSXB,{"PAB","2","04","04","Cpf","Cpf","Cpf","",""})
		AAdd(aSXB,{"PAB","2","05","05","Cnpj","Cnpj","Cnpj","",""})
		AAdd(aSXB,{"PAB","2","06","06","E-mail","E-mail","E-mail","",""})
		AAdd(aSXB,{"PAB","2","07","07","Telefone","Telefone","Telefone","",""})
		
		AAdd(aSXB,{"PAB","4","01","01","Codigo","Codigo","Codigo","PAB_CODIGO",""})
		AAdd(aSXB,{"PAB","4","01","02","Nome","Nome","Nome","PAB_NOME",""})
		AAdd(aSXB,{"PAB","4","01","03","CPF","CPF","CPF","PAB_CPF",""})
		AAdd(aSXB,{"PAB","4","01","04","Empresa","Empresa","Empresa","PAB_EMPRES",""})
		AAdd(aSXB,{"PAB","4","01","05","CNPJ","CNPJ","CNPJ","PAB_CNPJ",""})
		AAdd(aSXB,{"PAB","4","01","06","E-Mail","E-Mail","E-Mail","PAB_EMAIL",""})
		AAdd(aSXB,{"PAB","4","01","07","Telefone","Telefone","Telefone","PAB_TELEFO",""})
		
		AAdd(aSXB,{"PAB","4","02","01","Nome","Nome","Nome","PAB_NOME",""})
		AAdd(aSXB,{"PAB","4","02","02","Codigo","Codigo","Codigo","PAB_CODIGO",""})
		AAdd(aSXB,{"PAB","4","02","03","Empresa","Empresa","Empresa","PAB_EMPRES",""})
		AAdd(aSXB,{"PAB","4","02","04","CPF","CPF","CPF","PAB_CPF",""})
		AAdd(aSXB,{"PAB","4","02","05","CNPJ","CNPJ","CNPJ","PAB_CNPJ",""})
		AAdd(aSXB,{"PAB","4","02","06","E-Mail","E-Mail","E-Mail","PAB_EMAIL",""})
		AAdd(aSXB,{"PAB","4","02","07","Telefone","Telefone","Telefone","PAB_TELEFO",""})
		
		AAdd(aSXB,{"PAB","4","03","01","Empresa","Empresa","Empresa","PAB_EMPRES",""})
		AAdd(aSXB,{"PAB","4","03","02","Codigo","Codigo","Codigo","PAB_CODIGO",""})
		AAdd(aSXB,{"PAB","4","03","03","Nome","Nome","Nome","PAB_NOME",""})
		AAdd(aSXB,{"PAB","4","03","04","CPF","CPF","CPF","PAB_CPF",""})
		AAdd(aSXB,{"PAB","4","03","05","CNPJ","CNPJ","CNPJ","PAB_CNPJ",""})
		AAdd(aSXB,{"PAB","4","03","06","E-Mail","E-Mail","E-Mail","PAB_EMAIL",""})
		AAdd(aSXB,{"PAB","4","03","07","Telefone","Telefone","Telefone","PAB_TELEFO",""})
		
		AAdd(aSXB,{"PAB","4","04","01","CPF","CPF","CPF","PAB_CPF",""})
		AAdd(aSXB,{"PAB","4","04","02","Codigo","Codigo","Codigo","PAB_CODIGO",""})
		AAdd(aSXB,{"PAB","4","04","03","Nome","Nome","Nome","PAB_NOME",""})
		AAdd(aSXB,{"PAB","4","04","04","Empresa","Empresa","Empresa","PAB_EMPRES",""})
		AAdd(aSXB,{"PAB","4","04","05","CNPJ","CNPJ","CNPJ","PAB_CNPJ",""})
		AAdd(aSXB,{"PAB","4","04","06","E-Mail","E-Mail","E-Mail","PAB_EMAIL",""})
		AAdd(aSXB,{"PAB","4","04","07","Telefone","Telefone","Telefone","PAB_TELEFO",""})
		
		AAdd(aSXB,{"PAB","4","05","01","CNPJ","CNPJ","CNPJ","PAB_CNPJ",""})
		AAdd(aSXB,{"PAB","4","05","02","Codigo","Codigo","Codigo","PAB_CODIGO",""})
		AAdd(aSXB,{"PAB","4","05","03","Nome","Nome","Nome","PAB_NOME",""})
		AAdd(aSXB,{"PAB","4","05","04","Empresa","Empresa","Empresa","PAB_EMPRES",""})
		AAdd(aSXB,{"PAB","4","05","05","CPF","CPF","CPF","PAB_CPF",""})
		AAdd(aSXB,{"PAB","4","05","06","E-Mail","E-Mail","E-Mail","PAB_EMAIL",""})
		AAdd(aSXB,{"PAB","4","05","07","Telefone","Telefone","Telefone","PAB_TELEFO",""})
		
		AAdd(aSXB,{"PAB","4","06","01","E-Mail","E-Mail","E-Mail","PAB_EMAIL",""})
		AAdd(aSXB,{"PAB","4","06","02","Codigo","Codigo","Codigo","PAB_CODIGO",""})
		AAdd(aSXB,{"PAB","4","06","03","Nome","Nome","Nome","PAB_NOME",""})
		AAdd(aSXB,{"PAB","4","06","04","Empresa","Empresa","Empresa","PAB_EMPRES",""})
		AAdd(aSXB,{"PAB","4","06","05","CPF","CPF","CPF","PAB_CPF",""})
		AAdd(aSXB,{"PAB","4","06","06","CNPJ","CNPJ","CNPJ","PAB_CNPJ",""})
		AAdd(aSXB,{"PAB","4","06","07","Telefone","Telefone","Telefone","PAB_TELEFO",""})
		
		AAdd(aSXB,{"PAB","4","07","01","Telefone","Telefone","Telefone","PAB_TELEFO",""})
		AAdd(aSXB,{"PAB","4","07","02","Codigo","Codigo","Codigo","PAB_CODIGO",""})
		AAdd(aSXB,{"PAB","4","07","03","Nome","Nome","Nome","PAB_NOME",""})
		AAdd(aSXB,{"PAB","4","07","04","Empresa","Empresa","Empresa","PAB_EMPRES",""})
		AAdd(aSXB,{"PAB","4","07","05","CPF","CPF","CPF","PAB_CPF",""})
		AAdd(aSXB,{"PAB","4","07","06","CNPJ","CNPJ","CNPJ","PAB_CNPJ",""})
		AAdd(aSXB,{"PAB","4","07","07","E-Mail","E-Mail","E-Mail","PAB_EMAIL",""})
		
		AAdd(aSXB,{"PAB","5","01","","","","","PAB->PAB_CODIGO",""})
		
		SXB->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSXB )
			If ! SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI
	Endif
Return(.T.)

//------------------------------------------------------------------
// Rotina | FA160Imp | Autor | Robson Luiz - Rleg | DT |  16/05/2013
//------------------------------------------------------------------
// Descr. | Rotina de importação de dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA160Imp()	
	Local aSay := {}
	Local aButton := {}
	Local aRet := {}
	Local aArea := {}
	Local nOpcao := 0
	Local nRet := 0
	
	Private cFAOpSuper := "" //Operador Supervisor
	Private cDirTemp := GetTempPath()
	Private cBarra := Iif( IsSrvUnix(), "/", "\" )
	Private cDirProcess := cBarra + cDOWNLOAD + cBarra + cDOWNLOAD
	Private cDirLog := cBarra + cDOWNLOAD + cBarra + "log_event"
	Private cU4_CODCAMP := ''
	Private cU4_DESC := ''
	Private dU4_DATA := Ctod(Space(8))
	Private lPAB_DESC := PAB->(FieldPos("PAB_DESC"))>0
	
	//--------------------------------
	// Criar os diretórios de trabalho
	//--------------------------------
	MakeDir( "\"+cDOWNLOAD+"\" )
	MakeDir( cDirProcess )	
	MakeDir( cDirLog )

	//------------------------------------
	// Monta tela de interacao com usuario
	//------------------------------------
	AAdd( aSay, "Importação de listas de contato." )
	AAdd( aSay, "Os dados serão gravados na tabela de importação de lista, logo será gerado cadastro do contato " )
	AAdd( aSay, "e agenda do operador conforme o código de consultor informado em cada registro." )
	AAdd( aSay, "" )
	AAdd( aSay, "Clique em OK para prosseguir" )
	
	AAdd( aButton, { 10, .T., { || FA160Premis() } } )
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	//--------------------------------------
	// Se OK criticar, perguntar e processar
	//--------------------------------------
	If nOpcao == 1 
		//----------------------------------------
		// Criticar se não for usuário supervisor.
		//----------------------------------------
		If FA160Super()
			//------------------------------------------------
			// Perguntar ao usuário o que ele deseja importar.
			//------------------------------------------------
			nRet := FA160Want()
			//-------------------------------------
			// Solicitar parâmetros para o usuário.
			//-------------------------------------
			If FA160Ask( nRet, @aRet )
				//-------------------
				// Processar arquivo.
				//------------------- 
				aArea := PAB->( GetArea() )
				
				FA160Process( RTrim( aRet[1] ), nRet )
				MsgInfo( "Processamento finalizado.", cCadastro )
				
				RestArea( aArea )
			Endif
		Endif
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA160Premis | Autor | Robson Luiz - Rleg | DT | 16/05/013
//-------------------------------------------------------------------
// Descr. | Rotina de apresentação das premissão para a rotina poder
//        | ler o arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160Premis()
	Local	oDlg
	Local	oBtOk
	Local	oSay
	Local	oGet
	Local	oFont := TFont():New( "Arial", , 15, ,.F. )
	Local	oFontB := TFont():New( "Arial", , 15, ,.T. )
	
	Local cPremissa := ""
	
	cPremissa := "1º - O arquivo de dados deve ser gerado com a extensão CSV e os dados separados por ponto-vírgula. "       + CRLF + CRLF
	cPremissa += "2º - O arquivo deve conter um cabeçalho (header) com as seguintes nomenclaturas abaixo para cada coluna. " + CRLF + CRLF 
	cPremissa += "Em maiúsculo os nomes das colunas são: "                                                                   + CRLF + CRLF 
	cPremissa += " * NOME"       + CRLF
	cPremissa += "   CPF"          + CRLF
	cPremissa += "   EMPRESA"      + CRLF
	cPremissa += "   CNPJ"         + CRLF
	cPremissa += "   RAMO_ATIV"    + CRLF
	cPremissa += "   EMAIL"      + CRLF
	cPremissa += "   CARGO"        + CRLF
	cPremissa += "   PROFISSAO"    + CRLF
	cPremissa += "   DDD"          + CRLF
	cPremissa += " * TELEFONE"   + CRLF
	cPremissa += "   CELULAR"      + CRLF
	cPremissa += "   ENDERECO"     + CRLF
	cPremissa += "   NUMERO"       + CRLF
	cPremissa += "   COMPLEMENTO"  + CRLF
	cPremissa += "   BAIRRO"       + CRLF
	cPremissa += "   CEP"          + CRLF
	cPremissa += "   CIDADE"       + CRLF
	cPremissa += "   ESTADO"       + CRLF
	cPremissa += "   DESCRICAO"    + CRLF
	cPremissa += "   DT_ATUALIZ"   + CRLF
	cPremissa += " * CONSULTOR"   + CRLF
	cPremissa += " * PRIORIDADE"  + CRLF + CRLF
	cPremissa += "No mínimo devem ser informados os campos com (*)."                                                        + CRLF
	cPremissa += "Ao fazer a importação a rotina irá gerar o cadastro da importação (PAB), o cadastro do contato (SU5), "
	cPRemissa += "relacionar a importação com o contato (AC8) e por fim gerar a lista de contato (SU4/SU6) que é a Agenda do Operador." + CRLF
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 325, 520 TITLE "Premissas para processar o arquivo de dados" PIXEL
		@ 05, 5 SAY oSay VAR "P R E M I S S A S" SIZE 205, 010 FONT oFontB OF oDlg PIXEL COLOR CLR_HRED
		@ 15, 5 GET oGet VAR cPremissa OF oDlg MEMO SIZE 252, 125 FONT oFont PIXEL READONLY
		DEFINE SBUTTON oBtOk FROM 145, 232 TYPE 22 ACTION oDlg:End () ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//-------------------------------------------------------------------
// Rotina | FA160Super  | Autor | Robson Luiz - Rleg | DT |  16/05/13
//-------------------------------------------------------------------
// Descr. | Rotina para criticar o usuário que executar a rotina.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160Super()
	Local lRet := .F.
	SU7->( dbSetOrder( 4 ) )
	If SU7->( dbSeek( xFilial( "SU7" ) + __cUserID ) )
		If SU7->U7_TIPO == "2"
			cFAOpSuper := SU7->U7_COD
			lRet := .T.
		Else
			MsgInfo( "Usuário não é supervisor, por favor, verifique.", cCadastro )
		Endif
	Else
		MsgInfo( "Usuário não está cadastro como operador, por favor, verifique.", cCadastro )
	Endif	
Return( lRet )

//-------------------------------------------------------------------
// Rotina | FA160Want  | Autor | Robson Luiz - Rleg   | DT | 16/08/13
//-------------------------------------------------------------------
// Descr. | Rotina para solicitar ao usuário o que será processado.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160Want()
	Local aPar := {}
	Local aRet := {}
	Local nRet := 0
	
	AAdd( aPar, { 3, "O que deseja executar", 1, { "Processar nova importação" , "Recuperar o LOG de processamento" }, 99, "", .T. } )
	If ParamBox( aPar, "Parâmetros de decisão", @aRet,,,,,,,,.F.,.F.)
		nRet := aRet[ 1 ]
	Endif
Return( nRet )

//-------------------------------------------------------------------
// Rotina | FA160Ask   | Autor | Robson Luiz - Rleg | Data | 16/05/13
//-------------------------------------------------------------------
// Descr. | Solicitar parâmetros para usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160Ask( nWant, aRet )
	Local lRet := .F.
	Local aPar := {}
	Local cDescricao := ""
	Local cTipoArq := ""
	Local cCaminho := ""
	Local bOk := {|| }
	Local cHelp := "Não existe registro relacionado a este código ou o grupo de atendimento não está relacionado a este operador/supervisor."
	Local cMsg := ""
	Local aOriLst := {}
	Local nOriLst := 0
	Local nP:= 0
	Local aAlpha := {"1","2","3","4","5","6","7","8","9","0","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}

	Private cMV_ORILST := GetMv('MV_ORILST2')+'|'
	
	//---------------------------------------------------------
	// Colocar cada nome de tipo de lista no elemento do vetor.
	//---------------------------------------------------------
	While !Empty(cMV_ORILST)
		nP := At('|',cMV_ORILST)
		If nP > 0
			AAdd(aOriLst,SubStr(cMV_ORILST,1,nP-1))
			cMV_ORILST := SubStr(cMV_ORILST,nP+1)
		Endif
	End
	
	If Len(aOriLst) > 0	
		aRet := {}
	
		bOk := {|| 	Iif( File( mv_par01 ), ;
						MsgYesNo( "Confirma o início do processamento?", cCadastro ),;
						( MsgAlert("Arquivo não localizado, verifique.", cCadastro ), .F. ) ) }	
	
		cDescricao := "Capturar o arquivo de dados"
	
		If nWant == 1	
			cTipoArq := "CSV (separado por vírgulas) (*.csv) |*.csv"
			AAdd( aPar, { 6, cDescricao, Space(99), "", "", "", 80, .T., cTipoArq, cCaminho } )
			AAdd( aPar, { 1, "Data da agenda",MsDate(),"99/99/99","","","",15,.T.})
			AAdd( aPar, { 2, "Nome da lista",1,aOriLst,80,"",.T.})
			AAdd( aPar, { 1, "Complemento p/ nome lista",Space(99),"@!","","","",100,.F.})
			AAdd( aPar, { 1, "Campanha",Space(6),"@!","Vazio().Or.ExistCpo('SUO')","SUO","",50,.F.})
		Else
			cTipoArq := "LOG (log de processamento) (*.log) |*.log"
			cCaminho := "SERVIDOR" + cBarra + cDOWNLOAD + cBarra + "log_event" + cBarra
			AAdd( aPar, { 6, cDescricao, Space(99), "", "", "", 80, .T., cTipoArq, cCaminho } )
		Endif
	
		If ParamBox(aPar,"Parâmetros",@aRet,bOk,,,,,,,.F.,.F.)
			//---------------------------
			// Processar nova importação.
			//---------------------------
			//-----------------------------------------------------------------------------------------------
			// Verificar qual opção foi selecionada e converter, isso é uma deficiencia do retorno da função.
			//-----------------------------------------------------------------------------------------------
			If nWant == 1
				If !IsAlpha( aRet[3] )
					If ValType( aRet[ 3 ] ) == "C"
						nOriLst := Val( aRet[ 3 ] )
					Else 
						nOriLst := aRet[ 3 ]
					Endif
					nOriLst := Iif(nOriLst == 0, 10, nOriLst)
				Else
					nOriLst := aScan(aAlpha, aRet[3]) 
				EndIf
				dU4_DATA    := aRet[ 2 ]
				cU4_CODCAMP := aRet[ 5 ]
				cU4_DESC    := Upper( SubStr( aOriLst[ nOriLst ], 3 ) ) + ': ' + Iif(Empty(aRet[ 4 ]),'',RTrim(aRet[ 4 ]))
			Endif
			lRet := .T.
		Endif
	Else 
		MsgAlert('Não foi possível carregar as opções de lista de importação, por favor, verifique o parâmetro MV_ORILST2',cCadastro)
	Endif
Return( lRet )

//-------------------------------------------------------------------
// Rotina | FA160Proces | Autor | Robson Luiz - Rleg | DT | 16/05/13
//-------------------------------------------------------------------
// Descr. | Rotina de direcionamento para processar arquivo de dados
//        | ou ler arquivo de LOG.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160Process( cArq, nArq )
	If nArq == 1
		FA160CpyArq( cArq )
	Else
	   Processa( {|| FA160LeLOG( cArq ) }, cCadastro, "Processando arquivo de LOG, aguarde...", .F. )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA160CpyArq | Autor | Robson Luiz - Rleg | DT | 16/05/13
//-------------------------------------------------------------------
// Descr. | Rotina para copiar o arquivo de dados do local origem p/
//        | o local destino informado pelo usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160CpyArq( cArq )
	Local nB := 0
	Local cArqDados := ""
	Local cSystem := GetSrvProfString( "Startpath", "" )
	Local cProc := "Processando"
	
	//--------------------------------------------------------------------
	// Capturar somente o nome do arquivo, desprezando o caminho completo.
	//--------------------------------------------------------------------
	nB := Rat( cBarra, cArq )
	cArqDados := SubStr( cArq, nB + 1 )
	
	//-----------------------------------------------------------------------
	// Copiar arquivo do local origem para o local destino, ou seja, \system\
	//-----------------------------------------------------------------------
	If __CopyFile( cArq, cSystem + cArqDados )
		Processa( {|| FA160PrcArq( cArqDados ) }, cCadastro + " - " + cProc, cProc + " a importação, aguarde...", .F. )
	Else
		MsgInfo( "Falha na cópia do arquivo de dados, não foi possível copiar o arquivo da origem para o destino '" + cSystem + "'", cRotina )
	Endif
Return

//------------------------------------------------------------------
// Rotina | FA160LeLOG | Autor | Robson Luiz - Rleg  | DT | 16/05/13
//------------------------------------------------------------------
// Descr. | Rotina de leitura do arquivo de LOG de processamento.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA160LeLOG( cArq )
	Local cArqLog := ""
	Local nB := 0
	Local nP := 0
	
	ProcRegua(2)
	IncProc()
	
	//-------------------------------------------------
	// Capturar somente o nome do arquivo sem o caminho
	//-------------------------------------------------
	nB := Rat( cBarra, cArq )
	cArqLog := SubStr( cArq, nB+1 )
	
	//------------------------------------------------
	// Modificar a extensão do arquivo de LOG para CSV
	//------------------------------------------------
	nP := Rat( ".", cArqLog )
	cArqLog := SubStr( cArqLog, 1, nP ) + "csv"
	
	IncProc()
	
	//--------------------------------------------------------------------------
	// Copiar o arquivo do local indicado para o diretório temporário do usuário
	//--------------------------------------------------------------------------
	If ! __CopyFile( cArq, cDirTemp + cArqLog )
		MsgInfo( "Falha na cópia do arquivo de LOG, não foi possível copiar o arquivo do local origem para o local destino.", cRotina )
	Else
		MsgRun( "Arquivo sendo aberto...", cCadastro, {|| ShellExecute( "Open", cArqLog, '', cDirTemp, 1 ) } )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA160PrcArq | Autor | Robson Luiz - Rleg  | DT | 16/05/13
//-------------------------------------------------------------------
// Descr. | Rotina para processar o arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160PrcArq( cArqDados )
	Local cDados := ""
	Local cHeader := ""
	
	Local nTamHead := 0
	Local nTimeIni := Seconds()
		
	Local aHeader := {}
	Local aLinha := {}
	
	Private aUF := {}
	Private aFA160Log := {}
	
	Private nLinha := 0
	Private nDADOS := 0
	
	Private nNOME := 0
	Private nCPF := 0
	Private nEMPRESA := 0
	Private nCNPJ := 0
	Private nRAMO_ATIV := 0
	Private nEMAIL := 0
	Private nCARGO := 0
	Private nPROFISSAO := 0
	Private nDDD := 0
	Private nTELEFONE := 0
	Private nCELULAR := 0
	Private nENDERECO := 0
	Private nNUMERO := 0
	Private nCOMPLEMENTO := 0
	Private nBAIRRO := 0
	Private nCEP := 0
	Private nCIDADE := 0
	Private nESTADO := 0
	Private nDESCRICAO := 0
	Private nDT_ATUALIZ := 0
	Private nCONSULTOR := 0
	Private nPRIORIDADE:= 0

	dbSelectArea('PAB')
	dbSetOrder(1)

	dbSelectArea("AC8")
	dbSetOrder(1)
	
	dbSelectArea("SU5")
	dbSetOrder(1)
	
	//----------------------------
	// Cabeçalho do log de eventos
	//----------------------------
	AAdd( aFA160Log, ";"+Replicate("-",200) )
	AAdd( aFA160Log, ";"+"DESCRIÇÃO DA ROTINA: IMPORTAÇÃO DE LISTA DE CONTATOS")
	AAdd( aFA160Log, ";"+"NOME DA ROTINA: " + FunName() )
	AAdd( aFA160Log, ";"+"CÓDIGO E NOME DO USUÁRIO: " + __cUserID + " - " + Upper( RTrim( cUserName ) ) )
	AAdd( aFA160Log, ";"+"DATA/HORA DA EXECUÇÃO DA ROTNA: " + Dtoc( MsDate() ) + " - " + Time() )
	AAdd( aFA160Log, ";"+"NOME DA MÁQUINA ONDE FOI EXECUTADO: " + GetComputerName() )
	AAdd( aFA160Log, ";"+"NOME DO ARQUIVO DE DADOS PROCESSADO: " + cArqDados )
	AAdd( aFA160Log, "" )
	AAdd( aFA160Log, ";"+Replicate("-",200) )

	//----------------------------
	// Abrir o arquivo texto (CSV)
	//----------------------------
	FT_FUSE( cArqDados )
	//----------------------------------------
	// Posicionar na primeira linha do arquivo
	//----------------------------------------
	FT_FGOTOP()

	//--------------------------------------------------------
	// Estabelece e inicia o incremento da régua de progressão
	//--------------------------------------------------------
	ProcRegua( FT_FLASTREC() )
	IncProc()
	
	//----------------------------------------------------
	// Ler a 1ª linha que precisa ser o Header da planilha
	//----------------------------------------------------
	cHeader := FT_FREADLN()
	//----------------------------------------
	// Contatdor de linhas do arquivo de dados
	//----------------------------------------
	nLinha++
   //---------------------------------
   // Ir para o próxima linha de dados
   //---------------------------------
	FT_FSKIP()
	//-----------------------------------------
	// Monta o vetor conforme os dados na linha
	//-----------------------------------------
	aHeader := FA160Array( cHeader )
	
	//------------------------------------
	// Controlar a transação dos registros
	//------------------------------------
	Begin Transaction
	//----------------------------------------
	// Fazer o tratamento do Header do arquivo
	//----------------------------------------
	If FA160Header( aHeader )
		//---------------------------------------------------------------------
		// Capturar as siglas e os nomes do estados brasileiro para conciliação
		//---------------------------------------------------------------------
		FA160UF()
		//--------------------------------------------
		// Número de campos/coluna no arquivo de dados
		//--------------------------------------------
		nTamHead := Len( aHeader )
		//-------------------------------------------
		// Le o arquivo até sua última linha de dados
		//-------------------------------------------
		While ! FT_FEOF()
			//-------------------------
			// Captura a linha de dados
			//-------------------------
			cDados := FT_FREADLN()
			//----------------------------------------
			// Contatdor de linhas do arquivo de dados
			//----------------------------------------
			nLinha++
			//-----------------------------------------
			// Monta o vetor conforme os dados na linha
			//-----------------------------------------
	      aLinha := FA160Array( cDados )
	      If Len( aLinha ) == nTamHead
		      //---------------------------------------
		      // Grava os dados ou gerar inconsistência
		      //---------------------------------------
		      FA160Dados( aLinha )
			Else
				AAdd( aFA160Log,"Advertência;Não foi possível processar a linha "+LTrim(Str(nLinha,10,0))+", pois os dados não estão coerentes com o lay-out determinado.")
			Endif
	      //------------------
	      // Limpar a variável
	      //------------------
	      aLinha := {}
	      //---------------------------------
	      // Ir para o próxima linha de dados
	      //---------------------------------
			FT_FSKIP()
			IncProc()
		End
		//--------------------------
		// Fechar o arquivo de dados
		//--------------------------
		FT_FUSE()
	Endif
	//------------------------------------------
	// Fim do controle da transação de gravação.
	//------------------------------------------
	End Transaction
	//--------------------------------------------------------------------------------------------------------------------
	// Se houver log de processamento, gerar o arquivo e mover uma cópia para o TEMP do usuário e para o diretório de LOG.
	//--------------------------------------------------------------------------------------------------------------------
	If Len( aFA160Log ) > 0
		LjMsgRun( "Aguarde, armazenado arquivos e gerando o LOG do processamento...", cCadastro, {|| FA160PrcLog( cArqDados, nTimeIni ) })
	Else
		MsgInfo( "Não houve log de processamento", cCadastro )
	Endif
Return

//------------------------------------------------------------------
// Rotina | FA160Array | Autor | Robson Luiz - Rleg  | DT | 16/05/13
//------------------------------------------------------------------
// Descr. | Rotina p/ fragmentar os dados da linha do arquivo de 
//        | dados em elementos de vetor.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA160Array( cLinha )
	Local nP := 0
	Local nD := 0
	
	Local aArray := {}	
	
	Local cAux := ""
	Local cDelim := ";"
	Local nDELIM := 0
	
	//----------------------------------------------------------------
	// Verificar se há o delimitador no final da linha, senão incluir.
	//----------------------------------------------------------------
	If Right(cLinha,1) <> cDelim
		cLinha := cLinha + cDelim
	Endif

	//----------------------------------------------------------------------------------------------------------
	// Verifique se há dois delimitadores juntos, se houver coloque um espaço em branco entre eles.
	// Dois delimitadores juntos significa que não há dados, por isso é preciso considerar um espaço entre eles.
	//----------------------------------------------------------------------------------------------------------
	While ( At( cDelim + cDelim, cLinha ) > 0 )
		cLinha := StrTran( cLinha, ( cDelim + cDelim ), ( cDelim + " " + cDelim ) )
	End
	
	//--------------------------------------------------------------------------------
	// Fazer contagem, a quantidade de dados deve ser igual a quantidade delimidatores.
	//--------------------------------------------------------------------------------
	cAux := cLinha
	While ! Empty( cAux )
		nD := At( cDelim, cAux )
		If nD > 0
			nDELIM++
			cAux := SubStr( cAux, nD + 1 )
		Else
			cAux := ""
		Endif
	End
	
	//------------------------------------------------------------------------------------
	// Caso as quantidades não sejam iguais, complementar com espaço e mais o delimitador.
	//------------------------------------------------------------------------------------
	If ( nDADOS - nDELIM ) > 0
		cLinha := cLinha + Replicate( " " + cDelim, ( nDADOS - nDELIM ) )
	Endif
	
	//---------------------------------------------------------
	// Ler até o final da linha, ou seja, enquanto houver dado.
	//---------------------------------------------------------
	While ! Empty( cLinha )
		//-------------------------
		// Localizar o delimitador.
		//-------------------------
		nP := At( cDelim, cLinha )
		//---------------------------------------------------------------------------------
		// Se localizar, capturar o dado e refazer a linha somente com o restante de dados.
		//---------------------------------------------------------------------------------
		If nP > 0
			AAdd( aArray, SubStr( cLinha, 1, nP-1 ) )
			cLinha := SubStr( cLinha, nP+1 )
		Endif
	End
Return( aArray )

//-------------------------------------------------------------------
// Rotina | FA160Header | Autor | Robson Luiz - Rleg | DT |  16/05/13
//-------------------------------------------------------------------
// Descr. | Rotina de critíca do cabeçalho do arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160Header( aArray )
	Local cCpo := ''
	
	Local lRet := .T.
	
	Local nI := 0
	Local nCpo := 0
	Local nObrigat := 0
	
	Local aExcel := {}
	Local aObrigat := {}
	
	nDADOS := Len( aArray )

	//-----------------------------------------------------
	//[1] Nome da coluna.
	//[2] Indica se a coluna deve existir obrigatóriamente.
	//-----------------------------------------------------
	AAdd( aExcel, {'NOME'       ,.T.} )
	AAdd( aExcel, {'CPF'        ,.F.} )
	AAdd( aExcel, {'EMPRESA'    ,.F.} )
	AAdd( aExcel, {'CNPJ'       ,.F.} )
	AAdd( aExcel, {'RAMO_ATIV'  ,.F.} )
	AAdd( aExcel, {'EMAIL'      ,.F.} )
	AAdd( aExcel, {'CARGO'      ,.F.} )
	AAdd( aExcel, {'PROFISSAO'  ,.F.} )
	AAdd( aExcel, {'DDD'        ,.F.} )
	AAdd( aExcel, {'TELEFONE'   ,.T.} )
	AAdd( aExcel, {'CELULAR'    ,.F.} )
	AAdd( aExcel, {'ENDERECO'   ,.F.} )
	AAdd( aExcel, {'NUMERO'     ,.F.} )
	AAdd( aExcel, {'COMPLEMENTO',.F.} )
	AAdd( aExcel, {'BAIRRO'     ,.F.} )
	AAdd( aExcel, {'CEP'        ,.F.} )
	AAdd( aExcel, {'CIDADE'     ,.F.} )
	AAdd( aExcel, {'ESTADO'     ,.F.} )
	AAdd( aExcel, {'DESCRICAO'  ,.F.} )
	AAdd( aExcel, {'DT_ATUALIZ' ,.F.} )
	AAdd( aExcel, {'CONSULTOR'  ,.T.} )	
	AAdd( aExcel, {'PRIORIDADE' ,.T.} )	
	
	//------------------------------------------------------------------------------------
	// Processar o Header do arquivo informado para saber se possuem as colunas esperadas.
	//------------------------------------------------------------------------------------
	For nI := 1 To Len( aArray )
		//------------------------------------------------------
		// Procurar o nome da coluna em questão no vetor aExcel.
		//------------------------------------------------------
		nP := AScan( aExcel, {|a| a[1] == aArray[ nI ] })
		//-------
		// Achou?
		//-------
		If nP > 0
			//------------------------------------------
			// Atribuir o número da posição na variável.
			//------------------------------------------
			cCpo := 'n'+aArray[ nI ]
			&(cCpo) := nI
			nCpo++
			//------------------------------------------
			// Verificar se é preenchimento obrigatório.
			//------------------------------------------
			If aExcel[ nP, 2 ]
				nObrigat++
			Endif
		Endif
	Next nI 
	
	//---------------------------------------------------
	// Atribuir ao vetor somente as colunas obrigatórias.
	//---------------------------------------------------
	For nI := 1 To Len( aExcel )
		If aExcel[ nI, 2 ]
			AAdd( aObrigat, aExcel[ nI, 1 ] )
		Endif
	Next nI
	
   //----------------------------------------------
   // Conciliar se as colunas obrigatórias existem.
   //----------------------------------------------
   If nObrigat <> Len( aObrigat )
		lRet := .F.
		AAdd( aFA160Log, 'Advertência;Linha: '+LTrim( Str( nLinha, 10, 0 ) ) + ;
		'. Não foi localizado uma ou mais coluna obrigatória no arquivo de dados que está sendo importado, impossível continuar, a rotina será abortada.' )
   Endif
   
   //---------------------------------------
   // Verificar se há campos para processar.
   //---------------------------------------
   If nCpo == 0
		lRet := .F.
		AAdd( aFA160Log, 'Advertência;Linha: '+LTrim( Str( nLinha, 10, 0 ) ) + ;
		'. Os campos identificados não aderem ao processo da rotina, impossível continuar, a rotina será abortada.' )
   Endif
Return( lRet )

//-------------------------------------------------------------------
// Rotina | FA160UF    | Autor | Robson Luiz - Rleg   | DT | 16/05/13
//-------------------------------------------------------------------
// Descr. | Rotina para capturar os estados brasileiros.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160UF()
	SX5->( dbSetOrder( 1 ) )
	SX5->( dbSeek( xFilial( "SX5" ) + "12" ) )
	While ! SX5->( EOF() ) .And. SX5->( X5_FILIAL + X5_TABELA ) == xFilial( "SX5" ) + "12"
		SX5->( AAdd( aUF, { RTrim( X5_CHAVE ), Upper( RTrim( X5_DESCRI ) ) } ) )
		SX5->( dbSkip() )
	End
Return

//-------------------------------------------------------------------
// Rotina | FA160Dados | Autor | Robson Luiz - Rleg   | DT | 16/05/13
//-------------------------------------------------------------------
// Descr. | Rotina de montagem dos dados para gravação.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160Dados( aDados )
	Local nUF := 0
	Local aPAB := {}
	Local aSU5 := {}
	Local cCNPJ := ''
	Local cCPF := ''
	Local cTEL := ''
	Local cEMAIL := ''
	Local cEstado := ''
	Local cNOME := ''
	Local cU4_XPRIOR := ''
	
	Private cU7_POSTO := ''
	
	//-------------------------------------------------------------------------------
	// Criticar se o consultor/vendedor existe, e logo capturar o código de operador.
	//-------------------------------------------------------------------------------
	SA3->( dbSetOrder( 1 ) )
	If SA3->( dbSeek( xFilial( "SA3" ) + aDados[ nCONSULTOR ] ) )
		//-----------------------------------------------------
		// Capturar o código de operador do vendedor/consultor.
		//-----------------------------------------------------
		SU7->( dbSetOrder( 4 ) )
		If SU7->( dbSeek( xFilial( "SU7") + SA3->A3_CODUSR ) )
			cU7_POSTO := SU7->U7_POSTO
			//-----------------------------------------------------
			// Montar os vetores para serem gravados os seus dados.
			//-----------------------------------------------------
			If nNOME > 0
				cNOME := Upper( RTrim( NoAcento( AnsiToOem( aDados[ nNOME ] ) ) ) )
				AAdd( aPAB, { 'PAB_NOME', cNOME } )
				AAdd( aSU5, { "U5_CONTAT",cNOME } )
			Endif 
			
			If nEMAIL > 0
				cEMAIL := AllTrim( Lower( aDados[ nEMAIL ] ) )
				AAdd( aPAB, { 'PAB_EMAIL',cEMAIL } )
				AAdd( aSU5, { "U5_EMAIL", cEMAIL } )
			Endif 
			
			If nDDD > 0
				AAdd( aPAB, { 'PAB_DDD',aDados[ nDDD ] } )
				AAdd( aSU5, { "U5_DDD", aDados[ nDDD ] } )
			Endif 
			
			If nTELEFONE > 0
				cTEL := AllTrim( aDados[ nTELEFONE ] )
				cTEL := FA160SoNum( cTEL )
				AAdd( aPAB, { 'PAB_TELEFO',cTEL } )
				AAdd( aSU5, { "U5_FONE"   ,cTEL } )
				AAdd( aSU5, { "U5_FCOM1"  ,cTEL } )
			Endif 
			
			If nCELULAR > 0
				AAdd( aPAB, { 'PAB_CELULA',aDados[ nCELULAR ] } )
				AAdd( aSU5, { "U5_CELULAR",aDados[ nCELULAR ] } )
			Endif 
			
			If nCPF > 0
				cCPF := AllTrim( aDados[ nCPF ] )
				cCPF := FA160SoNum( cCPF )
				AAdd( aPAB, { 'PAB_CPF', cCPF } )
			Endif 
			
			If nCNPJ > 0
				cCNPJ := AllTrim( aDados[ nCNPJ ] )
				cCNPJ := FA160SoNum( cCNPJ )
				AAdd( aPAB, { 'PAB_CNPJ', cCNPJ } )
			Endif 
			
			If nPRIORIDADE > 0
				cU4_XPRIOR := aDados[ nPRIORIDADE ]
			Endif
			
			//-----------------------------------------------------------------------------------------------
			// Localizar o nome do estado brasileiro dentro do vetor dos estado capturado na tabela 12 do SX5
			//-----------------------------------------------------------------------------------------------
			If nESTADO > 0
				cEstado := Upper( RTrim( NoAcento( AnsiToOem( aDados[ nESTADO ] ) ) ) )
				If ! Empty( cEstado )
					nUF := AScan( aUF, {|a| a[1] == cEstado } )
					If nUF > 0
						cEstado := aUF[ nUF, 1 ]
					Else
						nUF := AScan( aUF, {|a| a[2] == cEstado } )
						If nUF > 0
							cEstado := aUF[ nUF, 1 ]
						Else
							AAdd( aFA160Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ". Não foi possível identificar a Unidade Federativa para o estado ["+cEstado+"]." )
						Endif
					Endif
				Endif
				AAdd( aPAB, { 'PAB_EST',cESTADO } )
				AAdd( aSU5, { "U5_EST", cESTADO } )
			Endif
			
			If nDESCRICAO > 0
				AAdd( aPAB, { Iif(lPAB_DESC,'PAB_DESC','PAB_DESCR'),   aDados[ nDESCRICAO ] } )
			Endif 

			If nEMPRESA > 0     ; AAdd( aPAB, { 'PAB_EMPRES',  aDados[ nEMPRESA ] } )     ; Endif 
			If nRAMO_ATIV > 0   ; AAdd( aPAB, { 'PAB_ATIVID',  aDados[ nRAMO_ATIV ] } )   ; Endif 
			If nCARGO > 0       ; AAdd( aPAB, { 'PAB_CARGO',   aDados[ nCARGO ] } )       ; Endif 
			If nPROFISSAO > 0   ; AAdd( aPAB, { 'PAB_PROFIS',  aDados[ nPROFISSAO ] } )   ; Endif 
			If nENDERECO > 0    ; AAdd( aPAB, { 'PAB_END',     aDados[ nENDERECO ] } )    ; Endif 
			If nNUMERO > 0      ; AAdd( aPAB, { 'PAB_NUMEND',  aDados[ nNUMERO ] } )      ; Endif 
			If nCOMPLEMENTO > 0 ; AAdd( aPAB, { 'PAB_COMPL',   aDados[ nCOMPLEMENTO ] } ) ; Endif 
			If nBAIRRO > 0      ; AAdd( aPAB, { 'PAB_BAIRRO',  aDados[ nBAIRRO ] } )      ; Endif 
			If nCEP > 0         ; AAdd( aPAB, { 'PAB_CEP',     aDados[ nCEP ] } )         ; Endif 
			If nCIDADE > 0      ; AAdd( aPAB, { 'PAB_CIDADE',  aDados[ nCIDADE ] } )      ; Endif 
			If nDT_ATUALIZ > 0  ; AAdd( aPAB, { 'PAB_DTATUAL', aDados[ nDT_ATUALIZ ] } )  ; Endif 
			If nCONSULTOR > 0   ; AAdd( aPAB, { 'PAB_CONSUL',  aDados[ nCONSULTOR ] } )   ; Endif 
			
			AAdd( aPAB, { 'PAB_OPERAD',  SU7->U7_COD } )
			AAdd( aSU5, { "U5_ATIVO"  , "1" } )
			
			//-------------------------------
			// Executar a função de gravação.
			//-------------------------------
			FA160GrvDad( aPAB, aSU5, cU4_XPRIOR) 
		Else
			AAdd( aFA160Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". Código ["+aDados[ nCONSULTOR ]+"] do consultor/vendedor não está cadastrado como operador no Cadastro de Operadores." )
		Endif
	Else
		AAdd( aFA160Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". Código ["+aDados[ nCONSULTOR ]+"] do consultor/vendedor não localizado no cadastro de vendedor." )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA160SoNum | Autor | Robson Luiz - Rleg | Data | 16/05/13
//-------------------------------------------------------------------
// Descr. | Rotina para extrair caracteres diferente de 0 a 9.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160SoNum( cVar )
	Local nI := 0
	Local cAux := ""
	Local cNumeros := "0123456789"
	//-------------------------------------------------------------------
	// Varrer toda a variável e considerar somente o conteúdo em cNumeros
	//-------------------------------------------------------------------
	For nI := 1 To Len( cVar )
		If SubStr( cVar, nI, 1 ) $ cNumeros
			cAux += SubStr( cVar, nI, 1 )
		Endif
	Next nI
Return( cAux )


//-------------------------------------------------------------------
// Rotina | FA160GrvDad | Autor | Robson Luiz - Rleg | DT |  17/05/13
//-------------------------------------------------------------------
// Descr. | Rotina de gravação dos dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160GrvDad( aPAB, aSU5, cU4_XPRIOR )
	
	Local nI          := 0
	Local lPAB        := .F.
	Local lSU5        := .F.	
	Local cPAB_CODIGO := ''
	Local cU5_CODCONT := ''
	Local cU4_LISTA   := ''
	Local cU6_CODIGO  := ''
	Local cU4_OPERAD  := aPAB[AScan(aPAB,{|p| p[1]=='PAB_OPERAD'}),2]
	Local cPAB_EMAIL  := ""

	Local cORIGEM := "REG.IMP." + Dtoc( dDataBase ) + "-" + Left(Time(),5) + "-USER:" + __cUserID + "-" + Upper(RTrim(cUserName))
	
	Local lSAV := IsInCallStack( "u_CSFTM010" ) 
	
	If lSAV
		cPAB_EMAIL := aPAB[AScan(aPAB,{|p| p[1]=='PAB_EMAIL'}),2]
	Else
		If nEMAIL > 0
			cPAB_EMAIL := aPAB[AScan(aPAB,{|p| p[1]=='PAB_EMAIL'}),2]
		EndIf
	EndIf
	
	//------------------
	// Gravar o contato.
	//------------------
	dbSelectArea('PAB')
	PAB->(dbSetOrder(6))
	lPAB := Iif(Empty(cPAB_EMAIL), .F.,PAB->(dbSeek(xFilial('PAB')+cPAB_EMAIL)))
	If lPAB
		cPAB_CODIGO := PAB->PAB_CODIGO
		PAB->(RecLock('PAB',.F.))
	Else
		cPAB_CODIGO := GetSXENum('PAB','PAB_CODIGO')
		ConfirmSX8()	
		PAB->(RecLock('PAB',.T.))
	Endif
	PAB->PAB_FILIAL := xFilial('PAB')
	PAB->PAB_CODIGO := cPAB_CODIGO
	PAB->PAB_ORIGEM := cORIGEM 
	PAB->PAB_DTIMP  := MsDate()
	For nI := 1 To Len( aPAB )
		PAB->( FieldPut( FieldPos( aPAB[ nI, 1 ] ), aPAB[ nI, 2 ] ) )
	Next nI
	PAB->(MsUnLock())
	
	If lSAV
		AAdd( aFTM010Log, "Processado OK;Gravado registro nº " + LTrim( Str( PAB->( RecNo() ), 10, 0 ) ) + " na tabela PAB." )
	Else
		AAdd( aFA160Log, "Processado OK;Gravado registro nº " + LTrim( Str( PAB->( RecNo() ), 10, 0 ) ) + " na tabela PAB." )
	EndIf

	
	//------------------
	// Gravar o contato.
	//------------------
	dbSelectArea('SU5')
	SU5->(dbSetOrder(9))
	lSU5 := Iif(Empty(cPAB_EMAIL), .F.,SU5->(dbSeek(xFilial('SU5')+cPAB_EMAIL)))
	IF lSU5
		cU5_CODCONT := SU5->U5_CODCONT
		SU5->(RecLock('SU5',.F.))
	Else
		cU5_CODCONT := GetSXENum('SU5','U5_CODCONT')
		ConfirmSX8()	
		SU5->(RecLock('SU5',.T.))
	Endif
	
	SU5->U5_FILIAL  := xFilial('SU5')
	SU5->U5_CODCONT := cU5_CODCONT
	SU5->U5_OBS     := cORIGEM 
	For nI := 1 To Len( aSU5 )
		SU5->( FieldPut( FieldPos( aSU5[ nI, 1 ] ), aSU5[ nI, 2 ] ) )
	Next nI
	SU5->(MsUnLock())
	If lSAV
		AAdd( aFTM010Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU5->( RecNo() ), 10, 0 ) ) + " na tabela SU5." )
	Else
		AAdd( aFA160Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU5->( RecNo() ), 10, 0 ) ) + " na tabela SU5." )
	EndIf
	
	//-------------------------------------
	// Relacionar o contato com a entidade.
	//-------------------------------------
	If !lPAB .And. !lSU5
		dbSelectArea('AC8')
		AC8->(RecLock('AC8',.T.))
		AC8->AC8_FILIAL := xFilial("AC8")
		AC8->AC8_FILENT := xFilial("PAB")
		AC8->AC8_ENTIDA := "PAB"
		AC8->AC8_CODENT := cPAB_CODIGO
		AC8->AC8_CODCON := cU5_CODCONT
		AC8->(MsUnLock())
		If lSAV
			AAdd( aFTM010Log, "Processado OK;Gravado registro nº " + LTrim( Str( AC8->( RecNo() ), 10, 0 ) ) + " na tabela AC8." )
		Else
			AAdd( aFA160Log, "Processado OK;Gravado registro nº " + LTrim( Str( AC8->( RecNo() ), 10, 0 ) ) + " na tabela AC8." )
		EndIf
   Endif
   
   //----------------------------
	// Gerar a agenda do operador.
   //----------------------------
	cU4_LISTA  := GetSXENum("SU4","U4_LISTA")
	ConfirmSX8()
	
	If lSAV
		dU4_DATA   := aRet[1]
		cU4_DESC   := cNomeLista
		cU4_CODCAM := ""
		cU4_XPRIOR := Iif( ValType(aRet[2]) == "N", cValToChar(aRet[2]), aRet[2] )
	EndIf
	
	dbSelectArea('SU4')
	SU4->( RecLock( "SU4", .T. ) )
	SU4->U4_FILIAL  := xFilial("SU4")
	SU4->U4_TIPO    := "1" //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
	SU4->U4_STATUS  := "1" //1=Ativa;2=Encerrada;3=Em Andamento
	SU4->U4_LISTA   := cU4_LISTA
	SU4->U4_DESC    := cU4_DESC
	SU4->U4_DTEXPIR := dU4_DATA
	SU4->U4_DATA    := dU4_DATA //Data da inclusão da agenda do consultor.
	SU4->U4_HORA1   := "06:00:00"
	SU4->U4_FORMA   := "6" //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
	SU4->U4_TELE    := "1" //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
	SU4->U4_OPERAD  := cU4_OPERAD
	SU4->U4_TIPOTEL := "4" //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
	SU4->U4_NIVEL   := "1" //1=Sim;2=Nao.
	SU4->U4_XDTVENC := dU4_DATA
	SU4->U4_XGRUPO  := cU7_POSTO
	SU4->U4_CODCAMP := cU4_CODCAMP
	SU4->U4_XPRIOR  := cU4_XPRIOR
	SU4->( MsUnLock() )
	If lSAV
		AAdd( aFTM010Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU4->( RecNo() ), 10, 0 ) ) + " na tabela SU4." )
	Else
		AAdd( aFA160Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU4->( RecNo() ), 10, 0 ) ) + " na tabela SU4." )
	EndIf

	cU6_CODIGO := GetSXENum("SU6","U6_CODIGO")
	ConfirmSX8()
	
	dbSelectArea('SU6')
	SU6->( RecLock( "SU6", .T. ) )
	SU6->U6_FILIAL  := xFilial("SU6")
	SU6->U6_LISTA   := cU4_LISTA
	SU6->U6_CODIGO  := cU6_CODIGO
	SU6->U6_CONTATO := cU5_CODCONT
	SU6->U6_ENTIDA  := "PAB"
	SU6->U6_CODENT  := cPAB_CODIGO
	SU6->U6_ORIGEM  := "1" //1=Lista;2=Manual;3=Atendimento.
	SU6->U6_DATA    := dU4_DATA //Data da inclusão da agenda do consultor.
	SU6->U6_HRINI   := "06:00"
	SU6->U6_HRFIM   := "23:59"
	SU6->U6_STATUS  := "1" //1=Nao Enviado;2=Em uso;3=Enviado.
	SU6->U6_DTBASE  := MsDate()
	SU6->( MsUnLock() )
	If lSAV
		AAdd( aFTM010Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU6->( RecNo() ), 10, 0 ) ) + " na tabela SU6." )
	Else
		AAdd( aFA160Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU6->( RecNo() ), 10, 0 ) ) + " na tabela SU6." )
	EndIf
Return

//-------------------------------------------------------------------
// Rotina | FA160PrcLog | Autor | Robson Luiz - Rleg | DT |  17/05/13
//-------------------------------------------------------------------
// Descr. | Rotina armazenar aquivos de dados e log e abrir log no 
//        | Ms-Excel para o usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA160PrcLog( cArqDados, nTimeIni )
	Local nI := 0
	Local nP := 0
	Local nHdl := 0
	
	Local cArqDest := ""
	Local cNomArq := CriaTrab( NIL, .F. )
	Local cArqTMPcsv := ""
	Local cArqTMPlog := ""
	
	//------------------------------------------------
	// Formatar o nome do arquivo para AAMMDD_SC??????
	//------------------------------------------------
	cArqTMPcsv := SubStr( Dtos( MsDate() ), 3 ) + "_" + cNomArq
	cArqTMPlog := cArqTMPcsv
	
	cArqTMPcsv := cArqTMPcsv + ".csv"
	cArqTMPlog := cArqTMPlog + ".log"

	//------------------------------------------
	// Capturar o nome do arquivo sem a extensão
	//------------------------------------------
	nP := Rat(".",cArqDados)
	cArqDest := SubStr( cArqDados, 1, nP-1 ) + "_" + SubStr( cArqTMPcsv, 3 ) + SubStr( cArqDados, nP )
		
	//-------------------------------------
	// Gerar o arquivo com o log de eventos
	//-------------------------------------
	nHdl := FCreate( cArqTMPcsv )
	
	//----------------------------------------------------------
	// Atualizar o vetor com o tempo decorrido do processamento.
	//----------------------------------------------------------	
	aFA160Log[ 8 ] := ";DURAÇÃO DO PROCESSAMENTO: " + SecsToTime( Seconds() - nTimeIni )

	//---------------------------------------------
	// Gravar no arquivo CSV os elementos do vetor.
	//---------------------------------------------
	For nI := 1 To Len( aFA160Log )
		FWrite( nHdl, aFA160Log[ nI ] + CRLF )
	Next nI
	
	//-----------------
	// Fechar o arquivo
	//-----------------
	FClose( nHdl )
	
	//---------------------------------------------------------
	// Copiar arquivo de LOG para o diretório de armazenamento.
	//---------------------------------------------------------
	If ! __CopyFile( cArqTMPcsv, cDirLog + cBarra + cArqTMPlog )
		MsgAlert( "Não foi possível mover o arquivo " + cArqTMPcsv + " para o diretório de armazenamento " + cDirLog, cCadastro )
	Endif
	
	//--------------------------------------------------------------
	// Copiar arquivo de LOG para o diretório temporário do usuário.
	//--------------------------------------------------------------
	If ! __CopyFile( cArqTMPcsv, cDirTemp + cArqTMPcsv )
		MsgAlert( "Não foi possível mover o arquivo " + cArqTMPcsv + " para o diretório temporário do usuário " + cDirTemp, cCadastro )
	Else
		//-----------------------------
		// Abrir o arquivo via Ms-Excel
		//-----------------------------
		ShellExecute( "Open", cArqTMPcsv, '', cDirTemp, 1 )			
	Endif
	
	//---------------------------------------------------------
	// Copiar arquivo de LOG para o diretório de armazenamento.
	//---------------------------------------------------------
	If ! __CopyFile( cArqDados, cDirProcess + cBarra + cArqDest )
		MsgAlert( "Não foi possível mover o arquivo " + cArqDados + " para o diretório de armazenamento " + cDirProcess, cCadastro )
	Else
		//------------------------------------------------
		// Apagar o arquivo de dados no diretório \system\
		//------------------------------------------------
		FErase( cArqDados )
	Endif
Return

//------------------------------------------------------------------
// Rotina | FA160TmkEnt | Autor | Robson Luiz - Rleg | DT | 17/05/13
//------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TMKENT.
//------------------------------------------------------------------
// Objet. | O objetivo é retornar o nome da entidade.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA160TmkEnt( cEntidade )
	Local cCpo := ""
	
   If cEntidade == "PAB"
   	cCpo := "PAB_NOME"
   Endif   
Return( cCpo )

//------------------------------------------------------------------
// Rotina | FA160FUp    | Autor | Robson Luiz - Rleg | DT | 20/05/13
//------------------------------------------------------------------
// Descr. | Rotina para rastrear quais dados a importação gerou.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA160FUp()
	Local nOpcao := 0
	
	Local aSay := {}
	Local aButton := {}
	
	Local aRet := {}
	Local aPar := {}
	
	AAdd( aSay, "Esta rotina apresenta as listas de contatos que a importação gerou, por favor, " )
	AAdd( aSay, "clique em OK para prosseguir com o processamento." )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton, , 160 )
	
	If nOpcao == 1 
		//-----------------------------------------
		// Se OK criticar o usuário se é supervisor
		//-----------------------------------------
		If FA160Super()
			AAdd( aPar, { 1, "A partir do código",Space(Len(PAB->PAB_CODIGO)),"",""                    ,"PAB"      , "", 50, .F. } )
			AAdd( aPar, { 1, "Até o código"      ,Space(Len(PAB->PAB_CODIGO)),"","(mv_par02>=mv_par01)","PAB"      , "", 50, .T. } )
			
			AAdd( aPar, { 1, "A partir da DT.Importação",Ctod("//"),"",""                    ,""      , "", 50, .F. } )
			AAdd( aPar, { 1, "Até a DT.importação"      ,Ctod("//"),"","(mv_par04>=mv_par03)",""      , "", 50, .T. } )
			If ParamBox( aPar, "Follow-up de lista de contatos", @aRet, , , , , , , ,.F. ,.F. )
				Processa( {| lEnd | FA160Quest( @lEnd, aRet ) }, cCadastro, "Aguarde, buscando dados...", .T. )
			Endif
		Endif
   Endif
Return

//------------------------------------------------------------------
// Rotina | FA160Quest  | Autor | Robson Luiz - Rleg | DT | 20/05/13
//------------------------------------------------------------------
// Descr. | Rotina de processamento.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA160Quest( lEnd, aRet )
	Local cSQL := ''
	Local cTRB := ''
	Local cCount := ''
	Local nCount := 0
	Local nCpos := 0
	Local nI := 0
	Local nElem := 0
	Local aDADOS := {}
	Local aCAB := {}
	Local aStruc := {}
	Local cTab := Chr(160)
	//------------------------------------
	// Montar a query para obter uma view.
	//------------------------------------
	cSQL := "SELECT PAB_CODIGO, "
	cSQL += "       PAB_CONSUL, "
	cSQL += "       PAB_OPERAD, "
	cSQL += "       A3_NOME, "
	cSQL += "       PAB_NOME, "
	cSQL += "       PAB_EMAIL, "
	cSQL += "       PAB_TELEFO, "
	cSQL += "       PAB_ORIGEM, "
	cSQL += "       PAB_DTIMP, "
	cSQL += "       U6_LISTA, "
	cSQL += "       U6_CODIGO, "
	cSQL += "       U6_DATA "
	cSQL += "FROM   "+RetSqlName("PAB")+" PAB "
	cSQL += "       INNER JOIN "+RetSqlName("AC8")+" AC8 "
	cSQL += "               ON AC8_FILIAL = "+ValToSql(xFilial("AC8")) +" "
	cSQL += "                  AND AC8_FILENT = "+ValToSql(xFilial("PAB"))+" "
	cSQL += "                  AND AC8_ENTIDA = 'PAB' "
	cSQL += "                  AND AC8_CODENT = PAB_CODIGO "
	cSQL += "                  AND PAB.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SU5")+" SU5 "
	cSQL += "               ON U5_FILIAL = "+ValToSql(xFilial("SU5"))+" "
	cSQL += "                  AND U5_CODCONT = AC8_CODCON "
	cSQL += "                  AND SU5.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SA3")+" SA3 "
	cSQL += "               ON A3_FILIAL = "+ValToSql(xFilial("SA3"))+" "
	cSQL += "                  AND A3_COD = PAB_CONSUL "
	cSQL += "                  AND SA3.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SU6")+" SU6 "
	cSQL += "               ON U6_FILIAL = "+ValToSql(xFilial("SU6"))+" "
	cSQL += "                  AND U6_ENTIDA = 'PAB' "
	cSQL += "                  AND RTrim(U6_CODENT) = PAB_CODIGO "
	cSQL += "                  AND SU6.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  PAB_FILIAL = "+ValToSql(xFilial("PAB"))+" "
	cSQL += "       AND PAB_CODIGO BETWEEN "+ValToSql(aRet[1])+" AND "+ValToSql(aRet[2])+" "
	cSQL += "       AND PAB_DTIMP BETWEEN "+ValToSql(aRet[3])+" AND "+ValToSql(aRet[4])+" "
	cSQL += "       AND PAB.D_E_L_E_T_ = ' ' 
	cSQL += "ORDER BY PAB_CODIGO "
	//-------------------------------------------
	// Fazer parse na query caso seja necessário.
	//-------------------------------------------
	cSQL := ChangeQuery(cSQL)
	//----------------------------------
	// Obter uma nomenclatura para view.
	//----------------------------------
	cTRB := GetNextAlias() 
	//-------------------------------------------
	// Montar um query count na string existente.
	//-------------------------------------------
	cCount := " SELECT COUNT(*) nCOUNT_RECNO FROM ( " + cSQL + " ) QUERY "
	//--------------------------------------
	// Caso haja a instrução abaixo, tratar.
	//--------------------------------------
	If At("ORDER BY", Upper(cCount)) > 0
		cCount := SubStr(cCount,1,At("ORDER BY",cCount)-1) + SubStr(cCount,RAt(")",cCount))
	Endif	
	//----------------------------------------------------
	// Executar no banco de dados a instrução com o count.
	//----------------------------------------------------
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cCount),cTRB,.F.,.T.)	
	//----------------------------------
	// Obter o valor de retorno da view.
	//----------------------------------
	If !(cTRB)->(EOF()) .And. !(cTRB)->(BOF())
		nCount := (cTRB)->(nCOUNT_RECNO)
		//---------------
		// Fechar a view.
		//---------------
		(cTRB)->(dbCloseArea())	
		//----------------------------------
		// Obter uma nomenclatura para view.
		//----------------------------------
		cTRB := GetNextAlias() 
		//----------------------------------------------------
		// Executar no banco de dados a instrução com o count.
		//----------------------------------------------------
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cSQL),cTRB,.F.,.T.)
		//------------------------------------------------------------------------------
		// Avalia as colunas da view diferentes de caractere, fazer o tratamento devido.
		//------------------------------------------------------------------------------
		aStruc := (cTRB)->(dbStruct())
		SX3->(dbSetOrder(2))
		For nI := 1 To Len(aStruc)    
			If SX3->(MsSeek(aStruc[nI,1])) .And. SX3->X3_TIPO <> "C"
				TcSetField(cTRB,SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL)
			Endif
		Next
		//--------------------------------------
		// Obter quantas colunas possuem a view.
		//--------------------------------------
		nCpos := (cTRB)->(FCount())
		//-----------------------------------------------------------------
		// Passar a quantidade de linhas que a view retornou para a função.
		//-----------------------------------------------------------------
		ProcRegua(nCount)
		//----------------------------------------------
		// Ler todas as linhas da view enquanto existir.
		//----------------------------------------------
		While ! (cTRB)->( EOF() )		
			//---------------------------------------------
			// Caso o usuário tecle em cancelar, abandonar.
			//---------------------------------------------
			If lEnd
				MsgAlert(cCancel)
				Exit
			Endif
			//---------------------------------
			// Criar um elemento com N colunas.
			//---------------------------------
			AAdd( aDADOS, Array( nCpos ) )
			//---------------------------------------------------
			// Atribuir o número do elemento do array em questão.
			//---------------------------------------------------
			nElem := Len( aDADOS )
			//--------------------------------------------------------------------------------------
			// Atribuir o dado da coluna da linha da view em questão na coluna do elemento do array.
			//--------------------------------------------------------------------------------------
			For nI := 1 To nCpos
				If ValType(&((cTRB)->(FieldName(nI)))) <> 'C'
					aDADOS[ nElem, nI ] := (cTRB)->(FieldGet(nI))
				Else
					aDADOS[ nElem, nI ] := cTab + (cTRB)->(FieldGet(nI))
				Endif
			Next nI
			//---------------------------------------
			// Incrementar o objeto de processamento.
			//---------------------------------------
			IncProc()
			//------------------------------------
			// Pular para a próxima linha da view.
			//------------------------------------
			(cTRB)->( dbSkip() )
		End
		//----------------------------------------------------------------------------
		// Se não tiver sido cancelado o processamento exportar o dados para planilha.
		//----------------------------------------------------------------------------
		If !lEnd
			MsgRun("Aguarde, gerando dados...","Follow-up",;
			{|| DlgToExcel( {{"ARRAY","Follow-Up Importação de Listas",;
			                {"Cód.Import.","Consultor","Operador","Nome Consultor/Vendedor","Nome do Contato","E-Mail",;
			                "Telefone","Origem","Data Importação","Agenda","Seq.Agenda","DT.Agenda"},;
			                aDADOS } } ) } )
		Endif
	Else
		MsgAlert("Não consegui localizar dados com estes parâmetros.",cCadastro)
	Endif
	//--------------------------
	// Fechar a view em questão.
	//--------------------------
	(cTRB)->(dbCloseArea())
Return

//------------------------------------------------------------------
// Rotina | UPD160()   | Autor | Robson Luiz -Rleg | Data | 20/05/13
//------------------------------------------------------------------
// Descr. | Rotina de update para criar as estruturas no dicionário
//        | de dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function UPD160()
	Local cModulo := "TMK"
	Local bPrepar := {|| U_U160Ini() }
	Local nVersao := 01

	NGCriaUpd(cModulo,bPrepar,nVersao)
Return

//------------------------------------------------------------------
// Rotina | U160Ini    | Autor | Robson Luiz -Rleg | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//        | 
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function U160Ini()
	/*
	[1] Chave
	[2] Path
	[3] Arquivo
	[4] Nome
	[5] Nome espanhol
	[6] Nome inglês
	[7] Modo
	[8] Chave único
	[9] Número do módulo
	[a] Modo unidade
	[b] Modo empresa
	*/
	aSX2 := {}
	AAdd(aSX2,{"PAB",NIL,"IMPORTACAO DE LISTAS","IMPORTACAO DE LISTAS","IMPORTACAO DE LISTAS","C",""})
	
	/*
	[1]  X3_ARQUIVO
	[2]  X3_ORDEM  
	[3]  X3_CAMPO  
	[4]  X3_TIPO   
	[5]  X3_TAMANHO
	[6]  X3_DECIMAL
	[7]  X3_TITULO 
	[8]  X3_TITSPA 
	[9]  X3_TITENG 
	[10] X3_DESCRIC
	[11] X3_DESCSPA
	[12] X3_DESCENG
	[13] X3_PICTURE
	[14] X3_VALID  
	[15] X3_USADO  
	[16] X3_RELACAO
	[17] X3_F3     
	[17] X3_NIVEL  
	[19] X3_RESERV 
	[20] X3_CHECK  
	[21] X3_TRIGGER
	[22] X3_PROPRI 
	[23] X3_BROWSE 
	[24] X3_VISUAL 
	[25] X3_CONTEXT
	[26] X3_OBRIGAT
	[27] X3_VLDUSER
	[28] X3_CBOX   
	[29] X3_CBOXSPA
	[30] X3_CBOXENG
	[31] X3_PICTVAR
	[32] X3_WHEN   
	[33] X3_INIBRW 
	[34] X3_GRPSXG 
	[35] X3_FOLDER 
	[36] X3_PYME   
	[37] X3_CONDSQL
	[38] X3_CHKSQL 
	[39] X3_IDXSRV
	[40] X3_IDXFLD
	[41] X3_ORTOGA
	*/
	aSX3 := {}
	AAdd(aSX3,{"PAB","01","PAB_FILIAL","C",2,,"Filial","Sucursal","Branch","Filial do Sistema","Sucursal","Branch of the System","@!",,"€€€€€€€€€€€€€€€",,,1,"þÀ",,,"U","N",,,,,,,,,,,"033",,,,,,,,""})
	AAdd(aSX3,{"PAB","02","PAB_CODIGO","C",6,,"Codigo","Codigo","Codigo","Codigo do cadastro","Codigo do cadastro","Codigo do cadastro","@!",,"€€€€€€€€€€€€€€ ","GETSXENUM('PAB')",,,"þÀ",,,"U","S","V","R","€",,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","03","PAB_NOME","C",60,,"Nome","Nome","Nome","Nome","Nome","Nome","@!",,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R","€",,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","04","PAB_CPF","C",11,,"CPF","CPF","CPF","Numero do CPF","Numero do CPF","Numero do CPF","@R 999.999.999-99",,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","05","PAB_EMPRES","C",60,,"Empresa","Empresa","Empresa","Nome da empresa","Nome da empresa","Nome da empresa","@!",,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","06","PAB_CNPJ","C",14,,"CNPJ","CNPJ","CNPJ","Numero do CNPJ","Numero do CNPJ","Numero do CNPJ","@R 99.999.999/9999-99",,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","07","PAB_ATIVID","C",60,,"Ramo Ativid.","Ramo Ativid.","Ramo Ativid.","Ramo de atividade","Ramo de atividade","Ramo de atividade","@!",,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","08","PAB_EMAIL","C",60,,"E-Mail","E-Mail","E-Mail","Endereco de e-mail","Endereco de e-mail","Endereco de e-mail",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R","€",,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","09","PAB_CARGO","C",30,,"Cargo","Cargo","Cargo","Nome do cargo","Nome do cargo","Nome do cargo","@!",,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","10","PAB_PROFIS","C",30,,"Profissao","Profissao","Profissao","Nome da profissao","Nome da profissao","Nome da profissao","@!",,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","11","PAB_DDD","C",3,,"DDD","DDD","DDD","DDD do telefone","DDD do telefone","DDD do telefone",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","12","PAB_TELEFO","C",20,,"Telefone","Telefone","Telefone","Numero do telefone","Numero do telefone","Numero do telefone",,,"€€€€€€€€€€€€€€ ",,,,"þA",,,"U","S","A","R","€",,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","13","PAB_CELULA","C",20,,"Celular","Celular","Celular","Numero do celular","Numero do celular","Numero do celular",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","14","PAB_END","C",60,,"Endereco","Endereco","Endereco","Endereco","Endereco","Endereco",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","15","PAB_NUMEND","C",10,,"Numero","Numero","Numero","Numero do endereco","Numero do endereco","Numero do endereco",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","16","PAB_COMPL","C",20,,"Complemento","Complemento","Complemento","Complemento do endereco","Complemento do endereco","Complemento do endereco",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","17","PAB_BAIRRO","C",30,,"Bairro","Bairro","Bairro","Bairro","Bairro","Bairro",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","18","PAB_CEP","C",8,,"CEP","CEP","CEP","CEP do endereco","CEP do endereco","CEP do endereco","@R 99999-999",,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","19","PAB_CIDADE","C",30,,"Cidade","Cidade","Cidade","Cidade do endereco","Cidade do endereco","Cidade do endereco",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","20","PAB_EST","C",2,,"Estado","Estado","Estado","Unidade federativa","Unidade federativa","Unidade federativa",,,"€€€€€€€€€€€€€€ ",,"12",,"þÀ",,,"U","S","A","R",,"ExistCpo('SX5','12'+M->PAB_EST)",,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","21","PAB_DESCR","C",150,,"Descritivo","Descritivo","Descritivo","Descritivo","Descritivo","Descritivo",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","N","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","22","PAB_DTATUA","D",8,,"DT. Atualiz.","DT. Atualiz.","DT. Atualiz.","Data de atualizacao","Data de atualizacao","Data de atualizacao",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","23","PAB_CONSUL","C",6,,"Consultor","Consultor","Consultor","Codigo do consultor","Codigo do consultor","Codigo do consultor",,,"€€€€€€€€€€€€€€ ",,"SA3",,"þÀ",,"S","U","S","A","R","€","ExistCpo('SA3')",,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","24","PAB_OPERAD","C",6,,"Operador","Operador","Operador","Codigo de operador","Codigo de operador","Codigo de operador",,,"€€€€€€€€€€€€€€ ",,"SU7",,"þÀ",,,"U","S","A","R","€","ExistCpo('SU7',M->PAB_OPERAD,1)",,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","25","PAB_ORIGEM","C",60,,"Origem reg.","Origem reg.","Origem reg.","Origem do registro","Origem do registro","Origem do registro",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","N","V","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","26","PAB_DTIMP","D",8,,"DT. Import.","DT. Import.","DT. Import.","Data da importacao","Data da importacao","Data da importacao",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","N","V","R",,,,,,,,,,,,,,,"N","N",""})
	AAdd(aSX3,{"PAB","27","PAB_DESC","M",10,,"Descritivo","Descritivo","Descritivo","Descritivo","Descritivo","Descritivo",,,"€€€€€€€€€€€€€€ ",,,,"þÀ",,,"U","S","A","R",,,,,,,,,,,,,,,"N","N",""})

	aHelp := {}
	AAdd(aHelp,{"PAB_FILIAL","Filial do sistema."})
	AAdd(aHelp,{"PAB_CODIGO","Código do cadastro."})
	AAdd(aHelp,{"PAB_NOME"  ,"Nome do contato e/ou pessoa."})
	AAdd(aHelp,{"PAB_CPF"   ,"Número do CPF do contato/pessoa."})
	AAdd(aHelp,{"PAB_EMPRES","Razão social da empresa."})
	AAdd(aHelp,{"PAB_CNPJ"  ,"CNPJ da empresa."})
	AAdd(aHelp,{"PAB_ATIVID","Ramo de atividade da empresa."})
	AAdd(aHelp,{"PAB_EMAIL" ,"E-mail de contato/pessoa."})
	AAdd(aHelp,{"PAB_CARGO" ,"Cargo do contato/pessoa."})
	AAdd(aHelp,{"PAB_PROFIS","Profissão do contato/pessoa."})
	AAdd(aHelp,{"PAB_DDD"   ,"DDD do telefone de contato."})
	AAdd(aHelp,{"PAB_TELEFO","Número do telefone para contato."})
	AAdd(aHelp,{"PAB_CELULA","Número do telefone celular."})
	AAdd(aHelp,{"PAB_END"   ,"Nome do endereço."})
	AAdd(aHelp,{"PAB_NUMEND","Número do endereço."})
	AAdd(aHelp,{"PAB_COMPL" ,"Complemento do endereço."})
	AAdd(aHelp,{"PAB_BAIRRO","Bairro do endereço."})
	AAdd(aHelp,{"PAB_CEP"   ,"Código do CEP."})
	AAdd(aHelp,{"PAB_CIDADE","Cidade do endereço."})
	AAdd(aHelp,{"PAB_EST"   ,"Estado do endereço."})
	AAdd(aHelp,{"PAB_DESCR" ,"Descrição aleatório sobre o cadastro."})
	AAdd(aHelp,{"PAB_DTATUA","Data de atualização."})
	AAdd(aHelp,{"PAB_CONSUL","Código do consultor/vendedor."})
	AAdd(aHelp,{"PAB_OPERAD","Código do operador vinculado ao vendedor."})
	AAdd(aHelp,{"PAB_ORIGEM","Origem do registro."})
	AAdd(aHelp,{"PAB_DTIMP" ,"Data de importação."})
	AAdd(aHelp,{"PAB_DESC"  ,"Descrição aleatório sobre o cadastro."})
	
	/*
	[1] Indice
	[2] Ordem
	[3] Chave
	[4] Descrição
	[5] Descrição espanhol
	[6] Descrição inglês
	[7] Proprietário
	[8] Show pesquisa
	*/
	aSIX := {}
	AAdd(aSIX,{"PAB","1","PAB_FILIAL+PAB_CODIGO","Codigo"  ,"Codigo"  ,"Codigo"  ,"U","","","S"})
	AAdd(aSIX,{"PAB","2","PAB_FILIAL+PAB_NOME"  ,"Nome"    ,"Nome"    ,"Nome"    ,"U","","","S"})
	AAdd(aSIX,{"PAB","3","PAB_FILIAL+PAB_EMPRES","Empresa" ,"Empresa" ,"Empresa" ,"U","","","S"})
	AAdd(aSIX,{"PAB","4","PAB_FILIAL+PAB_CPF"   ,"CPF"     ,"CPF"     ,"CPF"     ,"U","","","S"})
	AAdd(aSIX,{"PAB","5","PAB_FILIAL+PAB_CNPJ"  ,"CNPJ"    ,"CNPJ"    ,"CNPJ"    ,"U","","","S"})
	AAdd(aSIX,{"PAB","6","PAB_FILIAL+PAB_EMAIL" ,"E-Mail"  ,"E-Mail"  ,"E-Mail"  ,"U","","","S"})
	AAdd(aSIX,{"PAB","7","PAB_FILIAL+PAB_TELEFO","Telefone","Telefone","Telefone","U","","","S"})
Return