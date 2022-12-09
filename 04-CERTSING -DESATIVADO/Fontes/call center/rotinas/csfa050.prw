//------------------------------------------------------------------
// Rotina | CSFA050 | Autor | Robson Luiz - Rleg | Data | 26/10/2012
//------------------------------------------------------------------
// Descr. | Rotina de manutenção na tabela de entidade ICP-Brasil.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
#Include "Protheus.ch"

User Function CSFA050()
	Local c050Rdd := __cRdd
	Local l050Vazio := .F.
	
	Private aParam := {}
	Private aRotina := {}
	Private cRotina := FunName()
	Private cCadastro := "ICP-Brasil"
	Private cMV_UDASSUN := "MV_UDASSUN"
	
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
	AAdd( aParam, {|| MsgYesNo( "Confirma a exclusão do registro?", cCadastro ) } ) 
	AAdd( aParam, {||  } ) 
	AAdd( aParam, {||  } ) 

	//----------------------------------------------------------------------------------------------------------------------
	// Comentei a opção de Incluir pq não faz sentido incluir um ICP-Brasil e não gerar demais dados nas tabelas (SU4/SU6).
	// A inclusão será sempre por importação de dados.
	// AAdd( aRotina, { "Incluir"   , "AxInclui" , 0, 3 } ) 
	//----------------------------------------------------------------------------------------------------------------------
	AAdd( aRotina, { "Pesquisar" , "AxPesqui" , 0, 1 } )
	AAdd( aRotina, { "Visualizar", "AxVisual" , 0, 2 } )
	AAdd( aRotina, { "Alterar"   , "AxAltera" , 0, 4 } )
	AAdd( aRotina, { "Contatos"  , 'FTContato( "SZX", SZX->( RecNo() ), 4, , 2 )', 0, 4 } )
	AAdd( aRotina, { "Excluir"   , 'AxDeleta( "SZX", SZX->( RecNo() ), 5, , , , aParam )', 0, 5 } )
	AAdd( aRotina, { "Importar"  , "U_FA50Imp", 0, 3 } )
	AAdd( aRotina, { "Follow-Up" , "U_FA50Fup", 0, 4 } )
	
	//----------------------------------------------------
	// Verifica a existencia "Fisica" de uma Tabela do SX2
	//----------------------------------------------------
	If Sx2ChkTable( "SZX" , c050Rdd, l050Vazio )
		//--------------------------------------------------------------------
		// Verificar se toda infra-estrutura para atender a rotina foi criado.
		//--------------------------------------------------------------------
		If FA50CanUse()
			dbSelectArea( "SZX" )
			dbSetOrder( 1 )
		
			MBrowse( , , , , "SZX" )
		Endif
	Else
		MsgAlert( "Tabela de Entidade ICP-Brasil (SZX) não foi criada. Execute o UpDate de dicionário de dados p/ utilizar esta rotina.", cRotina )
	Endif
Return

//------------------------------------------------------------------
// Rotina | FA50Imp | Autor | Robson Luiz - Rleg | Data | 26/10/2012
//------------------------------------------------------------------
// Descr. | Rotina de importação de dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA50Imp()	
	Local aSay := {}
	Local aButton := {}
	Local aRet := {}
	Local aArea := {}
	Local nOpcao := 0
	Local nRet := 0
	
	Private cFAOpSuper := "" //Código do Operador Supervisor
	Private cDirTemp := GetTempPath()
	Private cBarra := Iif( IsSrvUnix(), "/", "\" )
	Private cDirProcess := cBarra + "icpbrasil" + cBarra + "processed"
	Private cDirLog := cBarra + "icpbrasil" + cBarra + "log_event"
	Private lFA50Simula := .F.
	Private nFA50Dias := 0
	Private cU4_CODCAMP := ''
	
	//--------------------------------
	// Criar os diretórios de trabalho
	//--------------------------------
	MakeDir( "\icpbrasil\" )
	MakeDir( cDirProcess )	
	MakeDir( cDirLog )

	//------------------------------------
	// Monta tela de interacao com usuario
	//------------------------------------
	AAdd( aSay, "Este programa permite que o usuário importe os dados das entidades de ICP-Brasil." )
	AAdd( aSay, "As premissas para a leitura e processamento deste arquivo é que deve haver o cabeçalho" )
	AAdd( aSay, "conforme lay-out, nos dados não deve haver o caractere (;), pois este caractere está " )
	AAdd( aSay, "determinado como separador entre dados, a extensão do arquivo deverá ser CSV." )
	AAdd( aSay, "Também é possível ler arquivo de LOG de processamento." )
	
	AAdd( aButton, { 10, .T., { || FA50Premis() } } )
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
		If FA50Super()
			//------------------------------------------------
			// Perguntar ao usuário o que ele deseja importar.
			//------------------------------------------------
			nRet := FA50Want()
			//-------------------------------------
			// Solicitar parâmetros para o usuário.
			//-------------------------------------
			If FA50Ask( nRet, @aRet )
				//-------------------
				// Processar arquivo.
				//------------------- 
				aArea := SZX->( GetArea() )
				
				FA50Process( RTrim( aRet[1] ), nRet, Iif( Len( aRet ) > 1, aRet[ 2 ], "" ) )
				MsgInfo( "Processamento finalizado.", cCadastro )
				
				RestArea( aArea )
			Endif
		Endif
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA50Ask    | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Solicitar parâmetros para usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50Ask( nWant, aRet )
	Local lRet := .F.
	Local aPar := {}
	Local cDescricao := ""
	Local cTipoArq := ""
	Local cCaminho := ""
	Local bOk := {|| }
	Local cHelp := "Não existe registro relacionado a este código ou o grupo de atendimento não está relacionado a este operador/supervisor."
	Local cMsg := ""
			
	aRet := {}
	bOk := {|| Iif( File( mv_par01 ), ;
					MsgYesNo( "Confirma o início do processamento?", cCadastro ),;
					( MsgAlert("Arquivo não localizado, verifique.", cCadastro ), .F. ) ) }	
	
	cDescricao := "Capturar o arquivo de dados"
	
	If nWant == 1	
		cTipoArq := "CSV (separado por vírgulas) (*.csv) |*.csv"
		AAdd( aPar, { 6, cDescricao, Space(99), "", "", "", 80, .T., cTipoArq, cCaminho } )
		AAdd( aPar, { 1, "Grupo de Atendimento",Space(2),"","U_FA50GrpAt( mv_par02 )","SU0","",0,.T. } )
		AAdd( aPar, { 4, "Modo de simulação?",.F.,"Processar os dados simulando a importação.",115,"",.F.})
		AAdd( aPar, { 1, "Dias de antecedência",30,"99","mv_par04>0","","",15,.T.})
		AAdd( aPar, { 1, "Campanha",Space(6),"@!","Vazio().Or.ExistCpo('SUO')","SUO","",50,.F.})
	Else
		cTipoArq := "LOG (log de processamento) (*.log) |*.log"
		cCaminho := "SERVIDOR" + cBarra + "icpbrasil" + cBarra + "log_event" + cBarra
		AAdd( aPar, { 6, cDescricao, Space(99), "", "", "", 80, .T., cTipoArq, cCaminho } )
	Endif

	If ParamBox(aPar,"Parâmetros de captura de arquivo",@aRet,bOk,,,,,,,.F.,.F.)
		If nWant == 1
			If aRet[ 3 ] 
				lFA50Simula := .T.
			Endif
			nFA50Dias := aRet[ 4 ]
			cU4_CODCAMP := aRet[ 5 ]
		Endif
		lRet := .T.
	Endif
	
	If lRet .And. nWant==1
		cMsg := "Tem certeza que o arquivo indicado para ser importado para o " + CRLF
		cMsg += "Protheus está atendendo as seguintes condições: "              + CRLF
		cMsg += "a) Cada coluna deve conter a seguinte nomenclatura: "          + CRLF
		cMsg += "CD_PEDIDO,"     +Chr(9)+"CD_CPF,"      +Chr(9)+"NM_CLIENTE,"   +Chr(9)+"DS_EMAIL, "   + CRLF
		cMsg += "NR_TELEFONE,"   +Chr(9)+"CD_PRODUTO,"  +Chr(9)+"DS_PRODUTO,"   +Chr(9)+"VL_PRECO, "   + CRLF
		cMsg += "IC_RENOVACAO,"  +Chr(9)+"DT_EMISSAO,"  +Chr(9)+"DT_EXPIRACAO," +Chr(9)+"CD_USUARIO, " + CRLF
		cMsg += "DS_CARGO,"      +Chr(9)+"NR_CNPJ,"     +Chr(9)+"DS_RAZAO_SOCIAL," + CRLF
		cMsg += "NR_TEL_USUARIO,"+Chr(9)+"DS_MUNICIPIO,"+Chr(9)+"DS_UF,"        +Chr(9)+"CONSULTOR."   + CRLF + CRLF
		cMsg += "b) Para cara linha de dados é obrigatório dado nas seguintes colunas:" + CRLF
		cMsg += "DS_EMAIL,"+Chr(9)+"DT_EXPIRACAO,"+Chr(9)+"CONSULTOR. "                                + CRLF + CRLF
		cMsg += "Estando o arquivo e seus dados nestas condições clique no botão " + CRLF
		cMsg += "<Confirmar>, caso contrário clique em <Voltar>."
		If Aviso(cCadastro,cMsg,{"Confirmar","Voltar"},3,"Critério",/*nRotAutDefault*/,/*cBitMap*/,/*lEdit*/,) == 2
			lRet := .F.
		Endif
	Endif
Return( lRet )

//-------------------------------------------------------------------
// Rotina | FA50GrpAt  | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para criticar se o grupo de atendimento informado
//        | existe.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
User Function FA50GrpAt( cVar )
	Local lRet := .T.
	Local cHelp := "Código "+cVar+" não existe, ou este código de Grupo de Atendimento não está relacionado ao operador/supervisor "+cFAOpSuper+"."
	AG9->( dbSetOrder( 1 ) )
	If ! AG9->( MsSeek( xFilial( "AG9" ) + cFAOpSuper + cVar ) )
		Help(" ", 1, cRotina, , cHelp, 1, 1 )
		lRet := .F.
	Endif
Return( lRet )

//-------------------------------------------------------------------
// Rotina | FA50Want   | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para solicitar ao usuário o que será processado.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50Want()
	Local aPar := {}
	Local aRet := {}
	Local nRet := 0
	
	AAdd( aPar, { 3, "O que deseja executar", 1, { "Processar nova importação" , "Recuperar o LOG de processamento" }, 99, "", .T. } )
	If ParamBox( aPar, "Parâmetros de decisão", @aRet,,,,,,,,.F.,.F.)
		nRet := aRet[ 1 ]
	Endif
Return( nRet )

//-------------------------------------------------------------------
// Rotina | FA50Super  | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para criticar o usuário que executar a rotina.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50Super()
	Local lRet := .F.
	SU7->( dbSetOrder( 4 ) )
	If SU7->( MsSeek( xFilial( "SU7" ) + __cUserID ) )
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
// Rotina | FA50Proces | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina de direcionamento para processar arquivo de dados
//        | ou ler arquivo de LOG.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50Process( cArq, nArq, cGrp )
	If nArq == 1
		FA50CpyArq( cArq, cGrp )
	Else
	   Processa( {|| FA50LeLOG( cArq ) }, cCadastro, "Processando arquivo de LOG, aguarde...", .F. )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA50CpyArq | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para copiar o arquivo de dados do local origem p/
//        | o local destino informado pelo usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50CpyArq( cArq, cGrp )
	Local nB := 0
	Local cArqDados := ""
	Local cSystem := GetSrvProfString( "Startpath", "" )
	Local cProc := Iif(lFA50Simula,"Simulando","Processando")
	
	//--------------------------------------------------------------------
	// Capturar somente o nome do arquivo, desprezando o caminho completo.
	//--------------------------------------------------------------------
	nB := Rat( cBarra, cArq )
	cArqDados := SubStr( cArq, nB + 1 )
	
	//-----------------------------------------------------------------------
	// Copiar arquivo do local origem para o local destino, ou seja, \system\
	//-----------------------------------------------------------------------
	If __CopyFile( cArq, cSystem + cArqDados )
		Processa( {|| FA50PrcArq( cArqDados, cGrp ) }, cCadastro + " - " + cProc, cProc + " a importação, aguarde...", .F. )
	Else
		MsgInfo( "Falha na cópia do arquivo de dados, não foi possível copiar o arquivo da origem para o destino '" + cSystem + "'", cRotina )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA50PrcArq | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para processar o arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50PrcArq( cArqDados, cGrp )
	Local cDados := ""
	Local cHeader := ""
	
	Local nTamHead := 0
	Local nTimeIni := Seconds()
	
	Local aHeader := {}
	Local aLinha := {}
	
	Private aUF := {}
	Private aFA50Log := {}
	Private aLISTA := {}
	
	Private nLinha := 0
	Private nDADOS := 0
	
	Private nCD_PEDIDO := 0
	Private nCD_CPF := 0
	Private nNM_CLIENTE := 0
	Private nDS_EMAIL := 0
	Private nNR_TELEFONE := 0
	Private nCD_PRODUTO := 0
	Private nDS_PRODUTO := 0
	Private nVL_PRECO := 0
	Private nIC_RENOVACAO := 0
	Private nDT_EMISSAO := 0
	Private nDT_EXPIRACAO := 0
	Private nCD_USUARIO := 0
	Private nDS_CARGO := 0
	Private nNR_CNPJ := 0
	Private nDS_RAZAO_SOCIAL := 0
	Private nNR_TEL_USUARIO := 0
	Private nDS_MUNICIPIO := 0
	Private nDS_UF := 0
	Private nCONSULTOR := 0
	
	dbSelectArea("AC8")
	dbSelectArea("SU5")
	
	//----------------------------
	// Cabeçalho do log de eventos
	//----------------------------
	AAdd( aFA50Log, ";"+Replicate("-",200) )
	AAdd( aFA50Log, ";"+"DESCRIÇÃO DA ROTINA: IMPORTAÇÃO DE IPC-BRASIL" + Iif(lFA50Simula," *** SIMULAÇÃO HABILITADA ***",""))
	AAdd( aFA50Log, ";"+"NOME DA ROTINA: " + FunName() )
	AAdd( aFA50Log, ";"+"CÓDIGO E NOME DO USUÁRIO: " + __cUserID + " - " + cUserName )
	AAdd( aFA50Log, ";"+"DATA/HORA DA EXECUÇÃO DA ROTNA: " + Dtoc( MsDate() ) + " - " + Time() )
	AAdd( aFA50Log, ";"+"NOME DA MÁQUINA ONDE FOI EXECUTADO: " + GetComputerName() )
	AAdd( aFA50Log, ";"+"NOME DO ARQUIVO DE DADOS PROCESSADO: " + cArqDados )
	AAdd( aFA50Log, "" )
	AAdd( aFA50Log, ";"+Replicate("-",200) )
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
	//---------------------------------------
	// Contador de linhas do arquivo de dados
	//---------------------------------------
	nLinha++
	//---------------------------------
	// Ir para o próxima linha de dados
	//---------------------------------
	FT_FSKIP()
	//-----------------------------------------
	// Monta o vetor conforme os dados na linha
	//-----------------------------------------
	aHeader := FA50Array( cHeader )
	//-----------------------------------------------
	// Capturar a posição da coluna do Excel no vetor
	//-----------------------------------------------
	nCD_PEDIDO      := AScan( aHeader, {|p| p=="CD_PEDIDO" } )
	nCD_CPF         := AScan( aHeader, {|p| p=="CD_CPF" } )
	nNM_CLIENTE     := AScan( aHeader, {|p| p=="NM_CLIENTE" } )
	nDS_EMAIL       := AScan( aHeader, {|p| p=="DS_EMAIL" } )
	nNR_TELEFONE    := AScan( aHeader, {|p| p=="NR_TELEFONE" } )
	nCD_PRODUTO     := AScan( aHeader, {|p| p=="CD_PRODUTO" } )
	nDS_PRODUTO     := AScan( aHeader, {|p| p=="DS_PRODUTO" } )
	nVL_PRECO       := AScan( aHeader, {|p| p=="VL_PRECO" } )
	nIC_RENOVACAO   := AScan( aHeader, {|p| p=="IC_RENOVACAO" } )
	nDT_EMISSAO     := AScan( aHeader, {|p| p=="DT_EMISSAO" } )
	nDT_EXPIRACAO   := AScan( aHeader, {|p| p=="DT_EXPIRACAO" } )
	nCD_USUARIO     := AScan( aHeader, {|p| p=="CD_USUARIO" } )
	nDS_CARGO       := AScan( aHeader, {|p| p=="DS_CARGO" } )
	nNR_CNPJ        := AScan( aHeader, {|p| p=="NR_CNPJ" } )
	nDS_RAZAO_SOCIAL:= AScan( aHeader, {|p| p=="DS_RAZAO_SOCIAL" } )
	nNR_TEL_USUARIO := AScan( aHeader, {|p| p=="NR_TEL_USUARIO" } )
	nDS_MUNICIPIO   := AScan( aHeader, {|p| p=="DS_MUNICIPIO" } )
	nDS_UF          := AScan( aHeader, {|p| p=="DS_UF" } )
	nCONSULTOR      := AScan( aHeader, {|p| p=="CONSULTOR" } )
	//-----------------------------------------
	// Verificar se encontrou todas as posições
	//-----------------------------------------
	If nCD_PEDIDO > 0 		.And. nCD_CPF > 0					.And.;
		nNM_CLIENTE > 0		.And. nDS_EMAIL > 0				.And.;
		nNR_TELEFONE > 0		.And. nCD_PRODUTO > 0			.And.;
		nDS_PRODUTO > 0		.And. nVL_PRECO > 0				.And.;
		nIC_RENOVACAO > 0		.And. nDT_EMISSAO > 0			.And.;
		nDT_EXPIRACAO > 0		.And. nCD_USUARIO > 0			.And.;
		nDS_CARGO > 0			.And.	nNR_CNPJ > 0				.And.;
		nDS_RAZAO_SOCIAL > 0	.And.	nNR_TELEFONE_USUARIO > 0.And.;
		nDS_MUNICIPIO > 0		.And.	nDS_UF > 0					.And. nCONSULTOR > 0
		//----------------------------------------
		// Fazer o tratamento do Header do arquivo
		//----------------------------------------
		If FA50Header( aHeader )
			//------------------------------------
			// Controlar a transação dos registros
			//------------------------------------
			Begin Transaction
			//---------------------------------------------------------------------
			// Capturar as siglas e os nomes do estados brasileiro para conciliação
			//---------------------------------------------------------------------
			FA50UF()
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
				aLinha := FA50Array( cDados )
				If Len( aLinha ) == nTamHead
					//---------------------------------------
					// Grava os dados ou gerar inconsistência
					//---------------------------------------
					FA50Dados( aLinha )
				Else
					AAdd( aFA50Log,"Advertência;Não foi possível processar a linha "+LTrim(Str(nLinha,10,0))+", pois os dados não estão coerentes com o lay-out determinado.")
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
			//------------------------------------------
			// Fim do controle da transação de gravação.
			//------------------------------------------
			End Transaction	
		Endif
	Else
		AAdd( aFA50Log, "Advertência;Problema na estrutura do arquivo informado para ser importado os seus dados, o nome das colunas não confere." )
		FA50Header( aHeader )
	Endif
	//--------------------------------------------------------------------------
	// Gerar a lista de atendimento conforme os dados de ICP-Brasil cadastrados.
	//--------------------------------------------------------------------------
	If Len( aLISTA ) > 0
		MsgMeter( {|oMeter,oText,oDlg,lEnd| FA50GrvLis( oMeter, oText, oDlg, @lEnd, cGrp) },"Aguarde, gerando a lista de contatos...",cCadastro,.F.)
		LjMsgRun( "Aguarde, atualizando ICP-Brasil X Lista de Contatos",,{|| FA50AtuSZX() } )
	Else
		AAdd( aFA50Log, "Advertência;Não há lista de contatos para gerar." )
	Endif
	//--------------------------------------------------------------------------------------------------------------------
	// Se houver log de processamento, gerar o arquivo e mover uma cópia para o TEMP do usuário e para o diretório de LOG.
	//--------------------------------------------------------------------------------------------------------------------
	If Len( aFA50Log ) > 0
		LjMsgRun( "Aguarde, armazenado arquivos e gerando o LOG do processamento...", cCadastro, {|| FA50PrcLog( cArqDados, nTimeIni ) })
	Else
		MsgInfo( "Não houve log de processamento", cCadastro )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA50PrcLog | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina armazenar aquivos de dados e log e abrir log no 
//        | Ms-Excel para o usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50PrcLog( cArqDados, nTimeIni )
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
	aFA50Log[ 8 ] := ";DURAÇÃO DO PROCESSAMENTO: " + SecsToTime( Seconds() - nTimeIni )

	//---------------------------------------------
	// Gravar no arquivo CSV os elementos do vetor.
	//---------------------------------------------
	For nI := 1 To Len( aFA50Log )
		FWrite( nHdl, aFA50Log[ nI ] + CRLF )
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

//-------------------------------------------------------------------
// Rotina | FA50UF     | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para capturar os estados brasileiros.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50UF()
	SX5->( dbSetOrder( 1 ) )
	SX5->( MsSeek( xFilial( "SX5" ) + "12" ) )
	While ! SX5->( EOF() ) .And. SX5->( X5_FILIAL + X5_TABELA ) == xFilial( "SX5" ) + "12"
		SX5->( AAdd( aUF, { RTrim( X5_CHAVE ), Upper( RTrim( X5_DESCRI ) ) } ) )
		SX5->( dbSkip() )
	End
Return

//-------------------------------------------------------------------
// Rotina | FA50Dados | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina de montagem dos dados para gravação.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50Dados( aDados )
	Local cZX_ORIGEM := ""		
	Local aSZX := {}
	Local aSU5 := {}
	Local aAC8 := {}
	
	//-----------------------------------------------------------
	// Caso não exista o dado VALID_END_DATE, colocar a Database.
	//-----------------------------------------------------------
	If Empty( aDados[ nDT_EXPIRACAO ] )
		aDados[ nDT_EXPIRACAO ] := Dtoc( dDatabase )
	Endif

	//----------------------------------------
	// Se estiver sem e-mail registrar no log.
	//----------------------------------------
	If ! Empty( aDados[ nDS_EMAIL ] )
		//-----------------------------------------------------------------------------------
		// Verificar se a Unidade Federativa (UF) é válida, branco será aceito, porém avisar.
		//-----------------------------------------------------------------------------------
		If ! Empty( aDados[ nDS_UF ] )
			If AScan( aUF, {|p| p[1] == aDados[ nDS_UF ] } )== 0
				AAdd( aFA50Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ". Não foi possível identificar a Unidade Federativa para o estado ["+aDados[ nDS_UF ]+"]." )
				aDados[ nDS_UF ] := ""
			Endif
		Endif		
		//------------------------------------------------------------
		// Verificar se CNPJ e CPF são válidos, brancos serão aceitos.
		//------------------------------------------------------------
		aDados[ nNR_CNPJ ] := FA50Cnpj( "NR_CNPJ", aDados[ nNR_CNPJ ] )
		aDados[ nCD_CPF ]  := FA50Cnpj( "CD_CPF", aDados[ nCD_CPF ] )
	
		//------------------------------------------------------------
		// Retirar qualquer caractere diferente de número do telefone.
		//------------------------------------------------------------
		aDados[ nNR_TELEFONE ]    := FA50SoNum( aDados[ nNR_TELEFONE ] )
		aDados[ nNR_TEL_USUARIO ] := FA50SoNum( aDados[ nNR_TEL_USUARIO] )
		
		//----------------------------------------------------------------------
		// Verificar se o vendedor existe, se sim buscar seu código de operador.
		//----------------------------------------------------------------------
		SA3->( dbSetOrder( 1 ) )
		If SA3->( MsSeek( xFilial( "SA3" ) + aDados[ nCONSULTOR ] ) )
			//-----------------------------------------------------
			// Capturar o código de operador do vendedor/consultor.
			//-----------------------------------------------------
			SU7->( dbSetOrder( 4 ) )
			If SU7->( MsSeek( xFilial( "SU7" ) + SA3->A3_CODUSR ) )
			
				cZX_ORIGEM := "REG.IMP." + Dtoc( dDataBase ) + " " + Left(Time(),5) + " USER:" + __cUserID + "-" + RTrim(cUserName)

				AAdd( aSZX, { "ZX_FILIAL"  , xFilial("SZX") } )
				AAdd( aSZX, { "ZX_CODIGO"  , "" } )
				AAdd( aSZX, { "ZX_CDPEDID" , aDados[ nCD_PEDIDO ] } )
				AAdd( aSZX, { "ZX_CDCPF"   , aDados[ nCD_CPF ] } )
				AAdd( aSZX, { "ZX_NMCLIEN" ,  NoAcento( AllTrim( aDados[ nNM_CLIENTE ] ) ) } )
				AAdd( aSZX, { "ZX_DSEMAIL" , Lower( AllTrim( aDados[ nDS_EMAIL ] ) ) } )
				AAdd( aSZX, { "ZX_NRTELEF" , aDados[ nNR_TELEFONE ] } )
				AAdd( aSZX, { "ZX_CDPRODU" , AllTrim( aDados[ nCD_PRODUTO ] ) } )
				AAdd( aSZX, { "ZX_DSPRODU" , NoAcento( AllTrim( aDados[ nDS_PRODUTO ] ) ) } )
				AAdd( aSZX, { "ZX_VLPRECO" , Val( aDados[ nVL_PRECO ] ) / 100 } )
				AAdd( aSZX, { "ZX_ICRENOV" , NoAcento( aDados[ nIC_RENOVACAO ] ) } )
				AAdd( aSZX, { "ZX_DTEMISS" , Ctod( aDados[ nDT_EMISSAO ] ) } )
				AAdd( aSZX, { "ZX_DTEXPIR" , Ctod( aDados[ nDT_EXPIRACAO ] ) } )
				AAdd( aSZX, { "ZX_CDUSUAR" , aDados[ nCD_USUARIO ] } )
				AAdd( aSZX, { "ZX_DSCARGO" , NoAcento( AllTrim( aDados[ nDS_CARGO ] ) ) } )
				AAdd( aSZX, { "ZX_NRCNPJ"  , aDados[ nNR_CNPJ ] } )
				AAdd( aSZX, { "ZX_DSRAZAO" , NoAcento( AllTrim( aDados[ nDS_RAZAO_SOCIAL ] ) ) } )
				AAdd( aSZX, { "ZX_NRTELUS" , aDados[ nNR_TEL_USUARIO ] } )
				AAdd( aSZX, { "ZX_DSMUNIC" , NoAcento( AllTrim( aDados[ nDS_MUNICIPIO ] ) ) } )
				AAdd( aSZX, { "ZX_DSUF"    , aDados[ nDS_UF ] } )
				AAdd( aSZX, { "ZX_CONSULT" , aDados[ nCONSULTOR ] } )
				AAdd( aSZX, { "ZX_OPERAD"  , SU7->U7_COD } )
				AAdd( aSZX, { "ZX_ORIGEM"  , cZX_ORIGEM } )
				AAdd( aSZX, { "ZX_INPUT"   , MsDate() } )
				AAdd( aSZX, { "ZX_LISTA"   , "" } )
			
				AAdd( aSU5, { "U5_FILIAL" , xFilial("SU5") } )
				AAdd( aSU5, { "U5_CODCONT", "" } )
				AAdd( aSU5, { "U5_CONTAT" , AllTrim( aDados[ nNM_CLIENTE ] ) } )
				AAdd( aSU5, { "U5_FONE"   , aDados[ nNR_TELEFONE ] } )
				AAdd( aSU5, { "U5_FCOM1"  , aDados[ nNR_TEL_USUARIO ] } )
				AAdd( aSU5, { "U5_ATIVO"  , "1" } )
				AAdd( aSU5, { "U5_EMAIL"  , Lower( AllTrim( aDados[ nDS_EMAIL ] ) ) } )
				AAdd( aSU5, { "U5_EST"    , aDados[ nDS_UF ] } )
				AAdd( aSU5, { "U5_OBS"    , "SZX-"+cZX_ORIGEM } )
				
				AAdd( aAC8, { "AC8_FILIAL" , xFilial("AC8") } )
				AAdd( aAC8, { "AC8_FILENT" , xFilial("SZX") } )
				AAdd( aAC8, { "AC8_ENTIDA" , "SZX" } )
				AAdd( aAC8, { "AC8_CODENT" , "" } )
				AAdd( aAC8, { "AC8_CODCON" , "" } )
	
				//-------------------------------
				// Executar a função de gravação.
				//-------------------------------
				FA50GrvDad( aSZX, aSU5, aAC8 )
			Else
				AAdd( aFA50Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". Código ["+aDados[ nCONSULTOR ]+"] do consultor/vendedor não está cadastrado como operador no Cadastro de Operadores." )
			Endif
			Else
				AAdd( aFA50Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". Código ["+aDados[ nCONSULTOR ]+"] do consultor/vendedor não localizado no cadastro de vendedor." )
			Endif
	Else
		AAdd( aFA50Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". O contato está sem e-mail. Não será possível importar." )
	Endif
Return

//-------------------------------------------------------------------
// Rotina | FA50Cnpj   | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para validar o CNPJ ou CPF.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50Cnpj( cCpo, cDado )
	//--------------------------------
	// Se dado vazio, registrar no LOG
	//--------------------------------
	If Empty( cDado )
		AAdd( aFA50Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ". O dado informado na coluna "+cCpo+" está vazio, portanto será gravado vazio." )
	Else
		//---------------------------------
		// Verificar se somente há numeros.
		//---------------------------------
		cDado := FA50SoNum( cDado )
		//----------------
		// Validar o dado.
		//----------------
		If ! CGC( cDado, NIL, .F. )
			AAdd( aFA50Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ". O dado informado na coluna "+cCpo+" é inválido ["+cDado+"]." )
		Endif
	Endif
Return( cDado )

//-------------------------------------------------------------------
// Rotina | FA50SoNum  | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para extrair caracteres diferente de 0 a 9.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50SoNum( cVar )
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
// Rotina | FA50GrvDad | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina de gravação dos dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50GrvDad( aSZX, aSU5, aAC8 )
	Local cKeySZX := ""
	Local cKeySU5 := ""
	Local cKeyAC8 := ""	
	Local cU5_CODCONT := ""
	
	Local nDias := 0
	Local nSemana := 0
		
	Local lSZX := .T.
	Local lSU5 := .T.
	Local lAC8 := .T.
	
	Local dZX_DTEXPIR := Ctod("  /  /  ")
	Local dDTAgenda := Ctod("  /  /  ")
	
	//-----------------------------------------------------------------------------------------------
	// Chave: ZX_FILIAL + ZX_NRCNPJ + ZX_CDPRODU + Dtos( ZX_DTEMISS ) + Dtos( ZX_DTEXPIR )
	//-----------------------------------------------------------------------------------------------
	cKeySZX := 	xFilial("SZX") + ;
					aSZX[ AScan(aSZX,{|p| p[1]=="ZX_NRCNPJ"}), 2 ] + ;
					aSZX[ AScan(aSZX,{|p| p[1]=="ZX_CDPRODU"}), 2 ] + ;
					Dtos( aSZX[ AScan(aSZX,{|p| p[1]=="ZX_DTEMISS"}), 2 ] ) + ;
					Dtos( aSZX[ AScan(aSZX,{|p| p[1]=="ZX_DTEXPIR"}), 2 ] )

	//--------------------------------------------------------------------------------------------
	// Verificar se já existe o IPC-Brasil FILIAL + CNPJ + PRODUTO + DATA EMISSAO + DATA EXPIRACAO
	//--------------------------------------------------------------------------------------------
	SZX->( dbSetOrder( 2 ) )
	lSZX := SZX->( MsSeek( cKeySZX ) )
	
	If lSZX
		//----------------------------------------
		// Se existir pegar o código do ICP-Brasil
		//----------------------------------------
		cZX_CODIGO := SZX->ZX_CODIGO

		//----------------------------------------------------------------------
		// Em existir o ICP-Brasil, gerar o log de processamento apenas de aviso
		//----------------------------------------------------------------------
		AAdd( aFA50Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ;
		". Já existe cadastro para o ICP-Brasil com chave: NR_CNPJ + CD_PRODUTO + DT_EMISSAO + DT_EXPIRACAO -> "+;
		aSZX[ AScan(aSZX,{|p| p[1]=="ZX_NRCNPJ"}), 2 ] + " + " + ;
		aSZX[ AScan(aSZX,{|p| p[1]=="ZX_CDPRODU"}), 2 ] + " + " + ;
		Dtoc( aSZX[ AScan(aSZX,{|p| p[1]=="ZX_DTEMISS"}), 2 ] ) + " + " + ;
		Dtoc( aSZX[ AScan(aSZX,{|p| p[1]=="ZX_DTEXPIR"}), 2 ] ) + ", logo este registro não será gravado." )
	Else
		cZX_CODIGO := GetSXENum( "SZX", "ZX_CODIGO" )
		If ! lFA50Simula
			ConfirmSX8()
		Else
			RollBackSX8()
		Endif
	Endif
				
	aSZX[ AScan(aSZX,{|p| p[1]=="ZX_CODIGO"}), 2 ] := cZX_CODIGO
	aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODENT"}), 2 ] := cZX_CODIGO	
		
	//---------------------------------------------
	// Verificar se já existe o contato pelo e-mail
	//---------------------------------------------
	// Chave: U5_FILIAL + U5_EMAIL
	//---------------------------------------------
	cKeySU5 := aSU5[ AScan(aSU5,{|p| p[1]=="U5_FILIAL"}), 2 ] + RTrim( aSU5[ AScan( aSU5,{|p| p[1]=="U5_EMAIL"}), 2 ] )
	SU5->( dbSetOrder( 9 ) )
	lSU5 := SU5->( MsSeek( cKeySU5 ) )
		
	If lSU5
		cU5_CODCONT := SU5->U5_CODCONT
	Else
		cU5_CODCONT := GetSXENum( "SU5", "U5_CODCONT" )
		If ! lFA50Simula
			ConfirmSX8()
		Else
			RollBackSX8()
		Endif
	Endif
		
	aSU5[ AScan(aSU5,{|p| p[1]=="U5_CODCONT"}), 2 ] := cU5_CODCONT
	aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODCON"}), 2 ] := cU5_CODCONT
				
	//--------------------------------------------------------
	// Verificar se já existe o relacionamento com a entidade.
	//----------------------------------------------------------------------
	// Chave: AC8_FILIAL + AC8_CODCON + AC8_ENTIDA + AC8_FILENT + AC8_CODENT
	//----------------------------------------------------------------------
	cKeyAC8 := 	aAC8[ AScan(aAC8,{|p| p[1]=="AC8_FILIAL"}), 2 ] + ;
					aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODCON"}), 2 ] + ;
					aAC8[ AScan(aAC8,{|p| p[1]=="AC8_ENTIDA"}), 2 ] + ;
					aAC8[ AScan(aAC8,{|p| p[1]=="AC8_FILENT"}), 2 ] + ;
					aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODENT"}), 2 ]
	
	AC8->( dbSetOrder( 1 ) )
	lAC8 := AC8->( MsSeek( cKeyAC8 ) )
	
	If lAC8
		AAdd( aFA50Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ;
		". Já existe registro na tabela Relação de Contatos x Entidade (AC8) com a chave -> " + ;
		aAC8[ AScan(aAC8,{|p| p[1]=="AC8_FILIAL"}), 2 ] +" + "+ ;
		aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODCON"}), 2 ] +" + "+ ;
		aAC8[ AScan(aAC8,{|p| p[1]=="AC8_ENTIDA"}), 2 ] +" + "+ ;
		aAC8[ AScan(aAC8,{|p| p[1]=="AC8_FILENT"}), 2 ] +" + "+ ;
		aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODENT"}), 2 ] + ", logo este registro não será gravado." )
	Else
		//---------------------------
		// Gravar AC8 somente incluir
		//---------------------------
		If ! lFA50Simula
			AC8->( RecLock( "AC8", .T. ) )
			For nI := 1 To Len( aAC8 )
				AC8->( FieldPut( FieldPos( aAC8[ nI, 1 ] ), aAC8[ nI, 2 ] ) )
			Next nI
			AC8->( MsUnLock() )
		Endif
		AAdd( aFA50Log, "Processado OK;Gravado registro nº " + LTrim( Str( AC8->( RecNo() ), 10, 0 ) ) + " na tabela AC8." )
	Endif
		
	//----------------------------------
	// Gravar SU5 incluindo ou alterando
	//----------------------------------
	If ! lFA50Simula
		If lSU5
			SU5->( RecLock( "SU5", .F. ) )
		Else 
			SU5->( RecLock( "SU5", .T. ) )
		Endif
		For nI := 1 To Len( aSU5 )
			If ! Empty( aSU5[ nI, 2 ] )
				SU5->( FieldPut( FieldPos( aSU5[ nI, 1 ] ), aSU5[ nI, 2 ] ) )
			Endif
		Next nI
		SU5->( MsUnLock() )
	Endif
	AAdd( aFA50Log, "Processado OK;"+Iif(lSU5,"Gravado","Alterado")+" registro nº " + LTrim( Str( SU5->( RecNo() ), 10, 0 ) ) + " na tabela SU5." )
		
	//----------------------------------
	// Gravar SZX incluindo ou alterando
	//----------------------------------
	If ! lFA50Simula
		If lSZX
			SZX->( RecLock( "SZX", .F. ) )
		Else
			SZX->( RecLock( "SZX", .T. ) )
		Endif
		For nI := 1 To Len( aSZX )
			SZX->( FieldPut( FieldPos( aSZX[ nI, 1 ] ), aSZX[ nI, 2 ] ) )
		Next nI
		SZX->( MsUnLock() )
	Endif
	AAdd( aFA50Log, "Processado OK;"+Iif(lSZX,"Gravado","Alterado")+" registro nº " + LTrim( Str( SZX->( RecNo() ), 10, 0 ) ) + " na tabela SZX." )
	
	//---------------------------------------------
	// Capturar a data em que expira o certificado.
	//---------------------------------------------
	dZX_DTEXPIR := aSZX[ AScan( aSZX, {|a| a[ 1 ] == "ZX_DTEXPIR"  } ), 2 ]
	//---------------------------------------------------------------------
	// Calcular a diferenca entre a data que expira e a data da importação.
	//---------------------------------------------------------------------
	nDias := dZX_DTEXPIR - MsDate()
	//------------------------------------------------------------------
	// Se o resultado do cálculo foi maior que o parâmetro estabelecido.
	//------------------------------------------------------------------
	If nDias > nFA50Dias
		//--------------------------------------------------------------------
		// Calcular Data do dia + Diferença entre dias - o prazo para atender.
		//--------------------------------------------------------------------
		dDTAgenda := MsDate() + ( nDias - nFA50Dias )
	Else
		//-----------------------------------------------------------------------------------------------------
		// Caso contrário colocar a data no dia seguinte o da importação, pois deve ser atendido o mais rápido.
		//-----------------------------------------------------------------------------------------------------
		dDTAgenda := MsDate() + 1
	Endif
	
	//-------------------------------------------------------------------------------------------------------------
	// Verificar se o data é um domingo ou sábado, sendo, alterar a data para a sexta-feira que antecede estes dias
	//-------------------------------------------------------------------------------------------------------------
	nSemana := Dow( dDTAgenda  )
	If nSemana == 1
		dDTAgenda := dDTAgenda - 2
	Elseif nSemana == 7
		dDTAgenda := dDTAgenda - 1
	Endif

	//-------------------------------------------------------
	// Verificar se é preciso pesquisar novamento o operador.
	//-------------------------------------------------------
	If aSZX[ AScan( aSZX, {|p| p[ 1 ] == "ZX_OPERAD" } ), 2 ] <> SU7->U7_COD
		SU7->( dbSetOrder( 1 ) )
		SU7->( MsSeek( xFilial( "SU7" ) + aSZX[ AScan( aSZX, {|a| a[ 1 ] == "ZX_OPERAD"  } ), 2 ] ) )
	Endif
	
	//-------------------------------------------------
	// Armazenar dados para gravar a lista de contatos.
	//-------------------------------------------------
	AAdd( aLISTA, { SU7->U7_COD, ;
			dZX_DTEXPIR, ;
			aSU5[ AScan( aSU5, {|a| a[1]=="U5_CODCONT" } ), 2 ], ;
			aSZX[ AScan( aSZX, {|a| a[1]=="ZX_OPERAD" } ), 2 ], ;
			Iif( lAC8, AC8->AC8_CODENT, aAC8[ AScan( aAC8, {|a| a[1]=="AC8_CODENT" } ), 2 ] ),;
			SU7->U7_POSTO, ;
			SZX->( RecNo() ), ; //Recno da tabela SZX IPC-Brasil.
			"" ,; //Código da lista de contatos.
			Dtos( dDTAgenda ), ; //Data em que a agenda será gerada para o operador. Precisa estar no formato String <AAMMDD>.
			aSZX[ AScan( aSZX, {|a| a[1]=="ZX_CDCPF" } ), 2 ] ,;  // CPF do contato para ter todos eles num só chamado.
			""} ) //Registrar a data mais cedo para a lista de contatos
Return

//-------------------------------------------------------------------
// Rotina | FA50GrvLis | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina de gravação da lista de contatos.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50GrvLis( oMeter, oText, oDlg, lEnd, cGrp )
	Local nI := 0
	Local nCOUNT := 0
	Local nLastRec := 0
	Local cKey := ""
	Local cU4_LISTA := ""
	Local cU6_CODIGO := ""
	Local cAG9_CODSU0 := 0
	
	Local cMaisCedo := ""
	Local nElemDe := 0
	
	//------------------------------------------------------------------------------------
	// Ordernar a lista conforme o CPF do contato + operador + data de inclusão da agenda.
	// [10] - CPF DO CONTATO.
	//  [4] - CÓDIGO DO OPERADOR.
	//  [9] - DATA DA AGENDA DO OPERADOR (data calculada).
	//------------------------------------------------------------------------------------
	ASort( aLISTA,,,{|a,b| ( a[ 10 ] + a[ 4 ] + a[ 9 ] ) < ( b[ 10 ] + b[ 4 ] + b[ 9 ] ) } )
	
	//DlgToExcel( {{"ARRAY","TESTE",{},aLISTA}})
	
	For nI := 1 To Len( aLISTA )
		If ckey <> aLISTA[ nI, 10 ] + aLISTA[ nI, 4 ]
			If !Empty( cKey ) .And. nElemDe > 0 .And. !Empty( cMaisCedo )
				AEval( aLISTA, {|p| p[11] := cMaisCedo }, nElemDe, ( nI - nElemDe ) )
			Endif
			cKey := aLISTA[ nI, 10 ] + aLISTA[ nI, 4 ]
			nElemDe := nI
			cMaisCedo := aLISTA[ nI, 9 ]
		Endif
		
		If aLISTA[ nI, 9 ] < cMaisCedo 
			cMaisCedo := aLISTA[ nI, 9 ]
		Endif
	Next nI
	
	AEval( aLISTA, {|p| p[11] := cMaisCedo }, nElemDe, ( nI - nElemDe ) )
	
	cKey := ""
	nLastRec := Len( aLISTA )
	oMeter:nTotal := nLastRec
		
	For nI := 1 To Len( aLISTA )
		nCOUNT++
		IncMeter(oMeter,oText,nCOUNT,"Processando registro: "+LTrim(Str(nCOUNT))+" de "+LTrim(Str(nLastRec)))
		
		//------------------------------
		// Controle de cabeçalho e itens
		//------------------------------
		//If cKey <> aLISTA[ nI, 4 ] + aLISTA[ nI, 9 ]
			//cKey := aLISTA[ nI, 4 ] + aLISTA[ nI, 9 ]
						
			If ! lFA50Simula
				cU4_LISTA  := GetSXENum("SU4","U4_LISTA")
				ConfirmSX8()
				
				SU4->( RecLock( "SU4", .T. ) )
				SU4->U4_FILIAL  := xFilial("SU4")
				SU4->U4_TIPO    := "1" //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
				SU4->U4_STATUS  := "1" //1=Ativa;2=Encerrada;3=Em Andamento
				SU4->U4_LISTA   := cU4_LISTA
				SU4->U4_DESC    := 'RENOV. ICP-BRASIL ' //"CERT. IPC-BRASIL EXPIRACAO EM " + Dtoc( aLISTA[ nI, 2 ] ) + " SUPERVIS:"+cFaOpSuper
				SU4->U4_DTEXPIR := aLista[ nI, 2 ]
				SU4->U4_DATA    := Stod( aLISTA[ nI, 11 ] ) //Data da inclusão da agenda do consultor.
				SU4->U4_HORA1   := "06:00:00"
				SU4->U4_FORMA   := "6" //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
				SU4->U4_TELE    := "1" //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
				SU4->U4_OPERAD  := aLISTA[ nI, 4 ]
				SU4->U4_TIPOTEL := "4" //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
				SU4->U4_NIVEL   := "1" //1=Sim;2=Nao.
				If SU4->( FieldPos("U4_XDTVENC") ) > 0
					SU4->U4_XDTVENC := aLISTA[ nI, 2 ]
				Endif
				If SU4->( FieldPos("U4_XGRUPO") ) > 0
					SU4->U4_XGRUPO  := aLISTA[ nI, 6 ]
				Endif
				If !Empty(cU4_CODCAMP)
					SU4->U4_CODCAMP  := cU4_CODCAMP
				Endif
				SU4->( MsUnLock() )
			Endif
			AAdd( aFA50Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU4->( RecNo() ), 10, 0 ) ) + " na tabela SU4.  Nº da Lista: " + cU4_LISTA )
		//Endif
		
		If ! lFA50Simula
			cU6_CODIGO := GetSXENum("SU6","U6_CODIGO")
			If __lSX8
				ConfirmSX8()
			EndIf
			
			SU6->( RecLock( "SU6", .T. ) )
			SU6->U6_FILIAL  := xFilial("SU6")
			SU6->U6_LISTA   := cU4_LISTA
			SU6->U6_CODIGO  := cU6_CODIGO
			SU6->U6_CONTATO := aLISTA[ nI, 3 ]
			SU6->U6_ENTIDA  := "SZX"
			SU6->U6_CODENT  := aLISTA[ nI, 5 ]
			SU6->U6_ORIGEM  := "1" //1=Lista;2=Manual;3=Atendimento.
			SU6->U6_DATA    := Stod( aLISTA[ nI, 11 ] ) //Data da inclusão da agenda do consultor.
			SU6->U6_HRINI   := "06:00"
			SU6->U6_HRFIM   := "23:59"
			SU6->U6_STATUS  := "1" //1=Nao Enviado;2=Em uso;3=Enviado.
			SU6->U6_DTBASE  := MsDate()
			SU6->( MsUnLock() )
		Endif
		AAdd( aFA50Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU6->( RecNo() ), 10, 0 ) ) + " na tabela SU6.  Nº da Lista: " + cU4_LISTA )
		
		//------------------------------------------------------------------
		// Guardar o número da lista para atualizar o registro de IPC-Brasil
		//------------------------------------------------------------------
		aLISTA[ nI, 8 ] := cU4_LISTA
		
		//----------------------------------------------------------
		// Verificar se o operador faz parte do grupo de atendimento
		// Se não fizer parte apenas alertar
		//----------------------------------------------------------
		cAG9_CODSU0 := Posicione( "AG9", 1, xFilial( "AG9" ) + aLISTA[ nI, 4 ], "AG9_CODSU0" )		
		If cGrp <> cAG9_CODSU0
			AAdd( aFA50Log, "Aviso;O operador " + aLISTA[ nI, 4 ] + " não pertence ao grupo de operadores " + cGrp + " ele pertence ao grupo " + cAG9_CODSU0 )
		Endif
	Next nI
Return

//-------------------------------------------------------------------
// Rotina | FA50AtuSZX | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para atualizar o ICP-Brasil com a lista onde ele
//        | foi gerado.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50AtuSZX()
	Local nI := 0	
	For nI := 1 To Len( aLISTA )
		//-------------------------------------------------------
		// Atualizar o ICP-Brasil com a lista onde ele foi gerado
		//-------------------------------------------------------
		If ! lFA50Simula
			SZX->( dbGoTo( aLISTA[ nI, 7 ] ) ) // Localizar o IPC-Brasil.
			If SZX->( RecNo() ) == aLISTA[ nI, 7 ] 
				SZX->( RecLock( "SZX", .F. ) )
				SZX->ZX_LISTA := aLISTA[ nI, 8 ] // Gravar a lista onde ele foi gerado.
				SZX->( MsUnLock() )
			Endif
		Endif
	Next nI
Return

//-------------------------------------------------------------------
// Rotina | IncMeter   | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina de incremento da barra de progressão.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function IncMeter(oMeter,oText,nCount,cText)
	Local bBlock := {|| oMeter:Set( nCount ), SysRefresh() }
	oText:SetText( cText )
	EVAL( bBlock )
Return

//-------------------------------------------------------------------
// Rotina | FA50Header | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina de critíca do cabeçalho do arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50Header( aArray )
	Local nI := 0
	Local lRet := .T.
	Local aExcel := {}
	
	AAdd( aExcel, "CD_PEDIDO" )
	AAdd( aExcel, "CD_CPF" )
	AAdd( aExcel, "NM_CLIENTE" )
	AAdd( aExcel, "DS_EMAIL" )
	AAdd( aExcel, "NR_TELEFONE" )
	AAdd( aExcel, "CD_PRODUTO" )
	AAdd( aExcel, "DS_PRODUTO" )
	AAdd( aExcel, "VL_PRECO" )
	AAdd( aExcel, "IC_RENOVACAO" )
	AAdd( aExcel, "DT_EMISSAO" )
	AAdd( aExcel, "DT_EXPIRACAO" )
	AAdd( aExcel, "CD_USUARIO" )
	AAdd( aExcel, "DS_CARGO" )
	AAdd( aExcel, "NR_CNPJ" )
	AAdd( aExcel, "DS_RAZAO_SOCIAL" )
	AAdd( aExcel, "NR_TEL_USUARIO" )
	AAdd( aExcel, "DS_MUNICIPIO" )
	AAdd( aExcel, "DS_UF" )
	AAdd( aExcel, "CONSULTOR" )
	
	nDADOS := Len( aExcel )
	
	For nI := 1 To Len( aExcel )
		nP := AScan( aArray, {|a| a == aExcel[ nI ] } )
		If nP == 0
			lRet := .F.
			
			AAdd( aFA50Log, "Advertência;Linha: " + ;
			LTrim( Str( nLinha, 10, 0 ) ) + ". O campo " + aExcel[ nI ] + ;
			" não foi localizado nas colunas do arquivo de dados, impossível continuar, a rotina será abortada." )
		Endif
	Next nI	
Return( lRet )

//------------------------------------------------------------------
// Rotina | FA50Array | Autor | Robson Luiz - Rleg | Data | 26/10/12
//------------------------------------------------------------------
// Descr. | Rotina p/ fragmentar os dados da linha do arquivo de 
//        | dados em elementos de vetor.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA50Array( cLinha )
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

	//-------------------------------------------------------------------------------------------------------------
	// Verifique se há dois delimitadores juntos, se houver coloque um espaço em branco entre eles.
	// Dois delimitadores juntos significa que não há dados, por isso é preciso considerar algum espaço entre eles.
	//-------------------------------------------------------------------------------------------------------------
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
			AAdd( aArray, AllTrim( SubStr( cLinha, 1, nP-1 ) ) )
			cLinha := SubStr( cLinha, nP+1 )
		Endif
	End
Return( aArray )

//------------------------------------------------------------------
// Rotina | FA50LeLOG | Autor | Robson Luiz - Rleg | Data | 26/10/12
//------------------------------------------------------------------
// Descr. | Rotina de leitura do arquivo de LOG de processamento.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA50LeLOG( cArq )
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
// Rotina | FA50Premis | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina de apresentação das premissão para a rotina poder
//        | ler o arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50Premis()
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
	
	cPremissa += " º CD_PEDIDO;"      + CRLF
	cPremissa += " º CD_CPF;"         + CRLF
	cPremissa += " º NM_CLIENTE;"     + CRLF
	cPremissa += " º DS_EMAIL;"       + CRLF
	cPremissa += " º NR_TELEFONE;"    + CRLF
	cPremissa += " º CD_PRODUTO;"     + CRLF
	cPremissa += " º DS_PRODUTO;"     + CRLF
	cPremissa += " º VL_PRECO;"       + CRLF
	cPremissa += " º IC_RENOVACAO;"   + CRLF
	cPremissa += " º DT_EMISSAO;"     + CRLF
	cPremissa += " º DT_EXPIRACAO;"   + CRLF
	cPremissa += " º CD_USUARIO;"     + CRLF
	cPremissa += " º DS_CARGO;"       + CRLF
	cPremissa += " º NR_CNPJ;"        + CRLF
	cPremissa += " º DS_RAZAO_SOCIAL;"+ CRLF
	cPremissa += " º NR_TEL_USUARIO;" + CRLF
	cPremissa += " º DS_MUNICIPIO;"   + CRLF
	cPremissa += " º DS_UF;"          + CRLF
	cPremissa += " º CONSULTOR;"      + CRLF + CRLF

	cPremissa += "Repare que entre cada dado há o caracter ponto-vírgula separando-o entre os dados. " + CRLF
	cPremissa += "Caso uma das premissas não seja atendida o arquivo de dados será rejeitado."         + CRLF
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 325, 520 TITLE "Premissas para processar o arquivo de dados" PIXEL
		@ 05, 5 SAY oSay VAR "PREMISSAS" SIZE 205, 010 FONT oFontB OF oDlg PIXEL COLOR CLR_HRED
		@ 15, 5 GET oGet VAR cPremissa OF oDlg MEMO SIZE 252, 125 FONT oFont PIXEL READONLY
		DEFINE SBUTTON oBtOk FROM 145, 232 TYPE 22 ACTION oDlg:End () ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//-------------------------------------------------------------------
// Rotina | FA50CanUse | Autor | Robson Luiz - Rleg | Data | 26/10/12
//-------------------------------------------------------------------
// Descr. | Rotina para verificar se a infra-estrurura da rotina foi
//        | criada.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA50CanUse()
   Local lRet := .T.
   
	//---------------------------------------------------------
	// Existe a chave para a tabela em questão.
	// T5 - Tabela de Entidade X Contato.
	// Nesta tabela deve conter o alias da entidade específica.
	//---------------------------------------------------------
	SX5->( dbSetOrder( 1 ) )
	If ! SX5->( MsSeek( xFilial( "SX5" ) + "T5" + "SZX" ) )
		MsgAlert("Não foi localizado a chave 'SZX' para Contatos X Entidade (SX5-T5). Acessou a empresa/filial correta?", cCadastro )
		lRet := .F.
	Endif
	
	If lRet
		//------------------------------
		// Existe o parâmetro em questão
		//------------------------------
		If ! ExisteSX6( cMV_UDASSUN )
			MsgAlert("Não foi localizado o parâmetro "+cMV_UDASSUN+", impossível continuar, verifique.", cCadastro )
			lRet := .F.
		Else
			//------------------------------------
			// Parâmetro em questão não está vazio
			//------------------------------------
			If Empty( GetMv( cMV_UDASSUN,,"") )
				MsgAlert("O parâmetro "+cMV_UDASSUN+" está sem conteúdo, por favor, verifique.", cCadastro )
				lRet := .F.
			Endif
		Endif
	Endif
	
	If lRet
		SXB->( dbSetOrder( 1 ) )
		If ! SXB->( MsSeek( "SZX" ) )
			MsgAlert("Não existe a Consulta Padrão (SXB) configurada para a tabela de ICP-Brasil (SZX), verifique.", cCadastro )
			lRet := .F.
		Endif
	Endif
Return( lRet )

//------------------------------------------------------------------
// Rotina | FA50TmkEnt | Autor | Robson Luiz - Rleg | Data |26/10/12
//------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TMKENT.
//------------------------------------------------------------------
// Objet. | O objetivo é retornar o nome da entidade.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA50TmkEnt( cEntidade )
	Local cCpo := ""
	
   If cEntidade == "SZX"
   	cCpo := "ZX_DSRAZAO"
   Endif   
Return( cCpo )

//------------------------------------------------------------------
// Rotina | FA50TmkAct | Autor | Robson Luiz - Rleg | Data |26/10/12
//------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TMKACTIVE.
//------------------------------------------------------------------
// Objet. | O objetivo é retornar o do contato e da entidade.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA50TmkAct()
	Local cAC8_CODENT := ""
	Local cZX_DSRAZAO := ""
	Local cMV_UDASSUN := "MV_UDASSUN"
	Local cUD_ASSUNTO := ""
	
	If FunName() == "TMKA380"
		cUD_ASSUNTO := GetMv( cMV_UDASSUN, , "ATR001" )

		//------------------------
		// Se as memvar existirem.
		//------------------------
		If Type( "M->UC_DESCENT" ) == "C" .And. Type( "M->UC_DESCCHA" ) == "C"
			//------------------------------
			// Se o campo não estiver vazio.
			//------------------------------
			If ! Empty( M->UC_CODCONT )
				//-----------------------------
				// Buscar o código da entidade.
				//-----------------------------
				cAC8_CODENT := RTrim( Posicione( "AC8", 1, xFilial( "AC8" ) + M->UC_CODCONT + "SZX" + xFilial( "SZX" ), "AC8_CODENT" ) )
				//-------------------------------------------
				// Se não estiver vazio o código da entidade.
				//-------------------------------------------
				If ! Empty( cAC8_CODENT )
					//--------------------------------------
					// Buscar o nome da entidade ICP-Brasil.
					//--------------------------------------
					SZX->( dbSetOrder( 1 ) )
					If SZX->( MsSeek( xFilial( "SZX" ) + cAC8_CODENT ) )
						cZX_DSRAZAO := SZX->ZX_DSRAZAO
					Endif
					//----------------------------------------------------
					// Se não estiver vazio o nome da entidade ICP-Brasil.
					//----------------------------------------------------
					If ! Empty( cZX_DSRAZAO )
						//--------------------------------------
						// Atribuir valor aos campos da Enchoice
						//--------------------------------------
						M->UC_DESCENT := Tabela("T5","SZX",.F.)
						M->UC_DESCCHA := cZX_DSRAZAO
						M->UC_ENTIDAD := "SZX"
						M->UC_CHAVE   := cAC8_CODENT
						M->UC_OPERACA := "2" //1=Receptivo;2=Ativo
						M->UC_STATUS  := ""  //1=Planejado;2=Pendente;3=Encerrada
						M->UC_OBS     := "ICP-Brasil: "      + RTrim( SZX->ZX_DSRAZAO ) + CRLF + ;
						                 "Produto: "         + RTrim( SZX->ZX_CDPRODU ) + CRLF + ;
						                 "Contato técnico: " + RTrim( SZX->ZX_DSEMAIL ) + CRLF + ;
						                 "Data inclusão: "   + Dtoc( SZX->ZX_DTEMISS )  + CRLF + ;
						                 "Data validade: "   + Dtoc( SZX->ZX_DTEXPIR )
						//--------------------------------------
						// Atribuir valor as variáveis do rodapé
						//--------------------------------------
						cNomeHist := cZX_DSRAZAO
						oNomeHist:Refresh()
						cContHist := Posicione( "SU5", 1, xFilial( "SU5" ) + M->UC_CODCONT, "U5_CONTAT" )
						oContHist:Refresh()
						//------------------------------------------
						// Atribuir valores aos campos da MsGetDados
						//------------------------------------------
						aCOLS[ 1, GdFieldPos( "UD_ASSUNTO" ) ] := cUD_ASSUNTO
						aCOLS[ 1, GdFieldPos( "UD_DESCASS" ) ] := Tabela( "T1", cUD_ASSUNTO )
						aCOLS[ 1, GdFieldPos( "UD_STATUS" ) ]  := "" //1=Pendente;2=Encerrado -> deixar vazio para usuário preencher.
						oGetTmk:oBrowse:Refresh(.T.)
					Endif
				Endif
			Endif
		Endif
	Endif
Return

//------------------------------------------------------------------
// Rotina | FA50Fup | Autor | Robson Luiz - Rleg | Data | 26/10/2012
//------------------------------------------------------------------
// Descr. | Rotina para apresentar as lista de contatos gerados a
//        | partir de um ICP-Brasil.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA50Fup()
	Local aSay := {}
	Local aButton := {}
	
	Local aPar := {}
	Local aRet := {}
	
	Local nOpcao := 0
	
	Private aOrdem := {}
	
	AAdd( aOrdem, "1-Operador + Data da agenda + Lista")
	AAdd( aOrdem, "2-Código de lista de atendimento")
	AAdd( aOrdem, "3-Data da agenda do operador")

	AAdd( aSay, "Esta rotina apresenta as listas de contatos que a importação de ICP-Brasil gerou, " )
	AAdd( aSay, "por favor, clique em OK para informar os parâmetros de busca." )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton, , 160 )
	
	//-----------------------------------------
	// Se OK criticar o usuário se é supervisor
	//-----------------------------------------
	If nOpcao == 1 
		If FA50Super()
			AAdd( aPar, { 1, "A partir da importação",Ctod(Space(8)),"",""                    ,""      , "", 50, .F. } )
			AAdd( aPar, { 1, "Até a importação",      Ctod(Space(8)),"","(mv_par02>=mv_par01)",""      , "", 50, .T. } )
			AAdd( aPar, { 2, "Ordernar por:", 1, aOrdem, 105, "", .F. } )			
			If ParamBox( aPar, "Follow-up de lista de contatos", @aRet, , , , , , , ,.F. ,.F. )
				Processa( {| lEnd | FA50Cont( @lEnd, aRet ) }, cCadastro, "Aguarde, buscando dados...", .T. )
			Endif
		Endif
   Endif
Return

//------------------------------------------------------------------
// Rotina | FA50Cont | Autor | Robson Luiz - Rleg | Data | 26/10/12
//------------------------------------------------------------------
// Descr. | Rotina para processar os dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA50Cont( lEnd, aRet )
	Local cSQL := ""
	Local cTRB := GetNextAlias()
	
	Local cCount := ""
	Local nCount := 0
	
	Local nI := 0
	Local nHdl := 0
	Local nU6_STATUS := 0
	
	Local cLocalPath := ""
	Local cStartPath := ""
	Local cArqTMP := ""
	Local cSpace := ""
	Local cDados := ""
	Local cCpo := ""
	
	Local aU6_STATUS := {}
	Local aHeader := {}
	
	Local cOrdem := ""
	Local nOrdem := ""
		
	If ValType( aRet[ 3 ] ) == "N"
		cOrdem := LTrim( Str( aRet[ 3 ], 1, 0 ) )
	Else
		cOrdem := SubStr( aRet[ 3 ], 1, 1 )
	Endif

	AAdd( aHeader, { "U4_OPERAD" , "" } )
	AAdd( aHeader, { "U7_NOME"   , "" } )
	AAdd( aHeader, { "U6_DATA"   , "" } )
	AAdd( aHeader, { "U4_LISTA"  , "" } )
	AAdd( aHeader, { "U4_DESC"   , "" } )
	AAdd( aHeader, { "U6_CODIGO" , "" } )
	AAdd( aHeader, { "U6_CONTATO", "" } )
	AAdd( aHeader, { "U6_ENTIDA" , "" } )
	AAdd( aHeader, { "U6_CODENT" , "" } )
	AAdd( aHeader, { "U6_STATUS" , "" } )
	AAdd( aHeader, { "U6_DTBASE" , "" } )
	AAdd( aHeader, { "ZX_CODIGO" , "" } )
	AAdd( aHeader, { "ZX_NMCLIEN", "" } )
	AAdd( aHeader, { "ZX_CDCPF"  , "" } )
	AAdd( aHeader, { "ZX_CDPRODU", "" } )
	AAdd( aHeader, { "ZX_ICRENOV", "" } )
	AAdd( aHeader, { "ZX_DTEMISS", "" } )
	AAdd( aHeader, { "ZX_DTEXPIR", "" } )
	AAdd( aHeader, { "ZX_NRCNPJ" , "" } )
	AAdd( aHeader, { "ZX_DSRAZAO", "" } )
	AAdd( aHeader, { "ZX_CONSULT", "" } )
	AAdd( aHeader, { "ZX_OPERAD" , "" } )
	AAdd( aHeader, { "ZX_INPUT"  , "" } )

	SX3->( dbSetOrder( 2 ) )
	For nI := 1 To Len( aHeader )
		If SX3->( dbSeek( aHeader[ nI, 1 ] ) )
			cCpo += aHeader[ nI, 1 ] + ", "
			aHeader[ nI, 2 ] := RetTitle( aHeader[ nI, 1 ] )
		Endif
	Next nI
	cCpo := SubStr( cCpo, 1, Len( cCpo ) - 2 )

	//-----------------------------------
	// Elaborar a query de busca de dados
	//-----------------------------------
	cSQL := "SELECT " + cCpo + " "
	cSQL += "  FROM "+RetSqlName("SU6")+" SU6 "
	cSQL += " INNER JOIN "+RetSqlName("SU4")+" SU4 "
	cSQL += "    ON U4_FILIAL = '"+xFilial("SU4")+"' "
	cSQL += "   AND U4_LISTA = U6_LISTA "
	cSQL += "   AND SU4.D_E_L_E_T_ = ' ' "
	cSQL += " INNER JOIN "+RetSqlName("SU7")+" SU7 "
	cSQL += "    ON U7_FILIAL = '"+xFilial("SU7")+"' "
	cSQL += "   AND U7_COD = U4_OPERAD "
	cSQL += "   AND SU7.D_E_L_E_T_ = ' ' "
	cSQL += " INNER JOIN "+RetSqlName("SZX")+" SZX "
	cSQL += "    ON ZX_CODIGO = U6_CODENT "
	cSQL += "   AND ZX_FILIAL = '"+xFilial("SZX")+"' "
	cSQL += "   AND ZX_INPUT BETWEEN '"+Dtos(aRet[1])+"' AND '"+Dtos(aRet[2])+"' "
	cSQL += "   AND SZX.D_E_L_E_T_ = ' ' "
	cSQL += " INNER JOIN "+RetSqlName("SU5")+" SU5 "
	cSQL += "    ON U5_FILIAL = '"+xFilial("SU5")+"' "
	cSQL += "   AND U5_CODCONT = U6_CONTATO "
	cSQL += "   AND SU6.D_E_L_E_T_ = ' ' "
	cSQL += " WHERE U6_DTBASE BETWEEN '"+Dtos(aRet[1])+"' AND '"+Dtos(aRet[2])+"' "
	cSQL += "   AND U6_FILIAL = '"+xFilial("SU6")+"' "
	cSQL += "   AND SU6.D_E_L_E_T_ = ' ' "
	cSQL += "   AND U6_ENTIDA = 'SZX' "
	cSQL += " ORDER BY "
	If cOrdem == "1"
		cSQL += "U4_OPERAD, U6_DATA, U4_LISTA, U6_CODIGO"
	Elseif cOrdem == "2"
		cSQL += "U4_LISTA"
	Elseif cOrdem == "3"
		cSQL += "U6_DATA"
	Endif
	
	//--------------------------
	// Efetuar um COUNT no banco
	//--------------------------
	cCount := " SELECT COUNT(*) COUNT FROM ( " + cSQL + " ) QUERY "
	
	If At( "ORDER BY", Upper( cCount ) ) > 0
		cCount := SubStr( cCount, 1, At( "ORDER BY", cCount ) -1 ) + SubStr( cCount, RAt( ")", cCount ) )
	Endif
	
	DbUseArea( .T., "TOPCONN", TCGENQRY( , , cCount ), "SQLCOUNT", .F., .T. )
	nCount := SQLCOUNT->COUNT
	SQLCOUNT->(DbCloseArea())
	
	//--------------------------
	// Executa a query principal
	//--------------------------
	LjMsgRun("Selecionando dados, aguarde...",cCadastro,{|| PLSQuery(cSQL,cTRB) })
	
	ProcRegua( nCount )
	
	//------------------------------------
	// Se há dados, processar os registros
	//------------------------------------
	If ! (cTRB)->( BOF() ) .And. ! (cTRB)->( EOF() )
		aU6_STATUS := TkSX3Box("U6_STATUS")
		cSpace     := Chr( 160 )
		cLocalPath := GetTempPath()
		cStartPath := GetSrvProfString( "Startpath", "" )             
		cArqTMP    := CriaTrab( NIL, .F. ) + ".csv"
		nHdl       := FCreate( cArqTMP )

		//------------------------------------
		// Criar o Cabeçalho do arquivo Excel.
		//------------------------------------
		cDados := "Follow-up Importação [ Common Name X Lista de Contatos ]" + CRLF
		FWrite( nHdl, cDados )
		cDados := ""		
		
		cDados := "Ordenador por: " + RTrim( aOrdem[ Val( cOrdem ) ] ) + " - Quantidade de registros processados: " + LTrim( Str( nCount, 10, 0 ) ) + CRLF + CRLF
		FWrite( nHdl, cDados )
		cDados := ""		

		For nI := 1 To Len( aHeader ) 
			cDados += aHeader[ nI, 2 ] + ";"
		Next nI 
		cDados := cDados + CRLF
		
		//----------------------------
		// Gravar o título das colunas
		//----------------------------
		FWrite( nHdl, cDados )
		cDados := ""		

		//--------------------------------------------------------
		// Efetuar a leitura de todas as linhas que a query buscou
		//--------------------------------------------------------
		While ! (cTRB)->( EOF() )
			IncProc()
			
			//------------------------------------------
			// Se usuário cancelou o processamento, sair
			//------------------------------------------
			If lEnd
				MsgAlert( cCancel, cCadastro )
				Exit
			Endif
         
			//-------------------------
			// Montar a linhas de dados
			//-------------------------
			For nI := 1 To Len( aHeader )
				cType := ValType( (cTRB)->&( aHeader[ nI, 1 ] ) )
				If cType == "C"
					If aHeader[ nI, 1 ] == "U6_STATUS"
						nU6_STATUS := Val( (cTRB)->U6_STATUS )
						cDados += aU6_STATUS[ nU6_STATUS ] + ";"
					Else
						cDados += cSpace + RTrim( (cTRB)->&( aHeader[ nI, 1 ] ) ) + ";"
					Endif
				ElseIf cType == "D"
					cDados += Dtoc( (cTRB)->&( aHeader[ nI, 1 ] ) ) + ";"
				Elseif cType == "N"
					cDados += LTrim( TransForm( (cTRB)->&( aHeader[ nI, 1 ] ), "@E 999,999,999.99" ) )
				Endif
			Next nI
			cDados := cDados + CRLF

			//----------------
			// Gravar os dados
			//----------------
			FWrite( nHdl, cDados )
			cDados := ""
			
			(cTRB)->( dbSkip() )
		End		

		//---------------
		// Fechar arquivo
		//---------------
		FClose( nHdl )

		//----------------------------------------------------------
		// Copiar o arquivo do \system\ para o temporário do usuário
		//----------------------------------------------------------
		If ! __CopyFile( cArqTMP, cLocalPath + cArqTMP )
			MsgAlert( "Não foi possível copiar o arquivo " + cArqTMP + " para o diretório temporário do usuário " + cLocalPath, cCadastro )
		Else
			//---------------------------------------------------------------------------------------
			// Abrir o aplicativo MS-Excel com o arquivo gerado e armazenado no temporário do usuário
			//---------------------------------------------------------------------------------------
			ShellExecute( "Open", cArqTMP, '', cLocalPath, 1 )			
		Endif
	Else
		MsgInfo( "Não existem dados com os parâmetros informados", cCadastro )
	Endif
		
	(cTRB)->( dbCloseArea() )
Return