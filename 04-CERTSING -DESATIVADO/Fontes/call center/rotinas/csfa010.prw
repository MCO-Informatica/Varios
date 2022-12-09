#Include "Protheus.ch"

//------------------------------------------------------------------
// Rotina | CSFA010 | Autor | Robson Luiz - Rleg | Data | 07/08/2012
//------------------------------------------------------------------
// Descr. | Rotina de manutenção na tabela de entidade Common Name.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function CSFA010()
	
	Local c010Rdd   := __cRdd
	Local l010Vazio := .F.
	
	Private aParam      := {}
	Private aRotina     := {}
	Private cRotina     := FunName()
	Private cCadastro   := "Renovação SSL (common-name)"
	Private cMV_UDASSUN := "MV_UDASSUN"
	
	SetKey( VK_F11 , {|| A010ChgSX6() } )
	
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
	// Comentei a opção de Incluir pq não faz sentido incluir um common name e não gerar demais dados nas tabelas (SU4/SU6).
	// A inclusão será sempre por importação de dados.
	// AAdd( aRotina, { "Incluir"   , "AxInclui" , 0, 3 } ) 
	//----------------------------------------------------------------------------------------------------------------------
	AAdd( aRotina, { "Pesquisar" , "AxPesqui" , 0, 1 } )
	AAdd( aRotina, { "Visualizar", "AxVisual" , 0, 2 } )
	AAdd( aRotina, { "Alterar"   , "AxAltera" , 0, 4 } )
	AAdd( aRotina, { "Contatos"  , 'FTContato( "SZT", SZT->( RecNo() ), 4, , 2 )', 0, 4 } )
	AAdd( aRotina, { "Excluir"   , 'AxDeleta( "SZT", SZT->( RecNo() ), 5, , , , aParam )', 0, 5 } )
	AAdd( aRotina, { "Importar"  , "U_FA10Imp", 0, 3 } )
	AAdd( aRotina, { "Follow-Up" , "U_FA10Fup", 0, 4 } )
	
	//----------------------------------------------------
	// Verifica a existencia "Fisica" de uma Tabela do SX2
	//----------------------------------------------------
	If Sx2ChkTable( "SZT" , c010Rdd, l010Vazio )
		//--------------------------------------------------------------------
		// Verificar se toda infra-estrutura para atender a rotina foi criado.
		//--------------------------------------------------------------------
		If FA10CanUse()
			dbSelectArea( "SZT" )
			dbSetOrder( 1 )
		
			MBrowse( , , , , "SZT" )
		Endif
	Else
		MsgAlert( "Tabela de Entidade Renovação SSL (common-name) (SZT) não foi criada. Execute o UpDate de dicionário de dados p/ utilizar esta rotina.", cRotina )
	Endif

Return


//------------------------------------------------------------------
// Rotina | FA10Imp | Autor | Robson Luiz - Rleg | Data | 07/08/2012
//------------------------------------------------------------------
// Descr. | Rotina de importação de dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA10Imp()	

	Local aSay    := {}
	Local aButton := {}
	Local aRet    := {}
	Local aArea   := {}
	Local nOpcao  := 0
	Local nRet    := 0
	
	Private cFAOpSuper  := "" //Operador Supervisor
	Private cDirTemp    := GetTempPath()
	Private cBarra      := Iif( IsSrvUnix(), "/", "\" )
	Private cDirProcess := cBarra + "commonname" + cBarra + "processed"
	Private cDirLog     := cBarra + "commonname" + cBarra + "log_event"
	Private lFA10Simula := .F.
	Private nFA10Dias   := 0
	Private cOriLst     := ""
	Private cU4_CODCAMP := ''
	Private cFA10Compl  := ''
	
	//--------------------------------
	// Criar os diretórios de trabalho
	//--------------------------------
	MakeDir( "\commonname\" )
	MakeDir( cDirProcess )	
	MakeDir( cDirLog )

	//------------------------------------
	// Monta tela de interacao com usuario
	//------------------------------------
	AAdd( aSay, "Este programa permite que o usuário importe dados p/ a entidade de Renov. SSL."         )
	AAdd( aSay, "As premissas para a leitura e processamento deste arquivo é que deve haver o cabeçalho" )
	AAdd( aSay, "conforme lay-out, nos dados não deve haver o caractere (;), pois este caractere está "  )
	AAdd( aSay, "determinado como separador entre dados, a extensão do arquivo deverá ser CSV."          )
	AAdd( aSay, "Também é possível ler arquivo de LOG de processamento."                                 )
	
	AAdd( aButton, { 10, .T., { || FA10Premis() } }              )
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } }              )
	
	FormBatch( cCadastro, aSay, aButton )
	
	//--------------------------------------
	// Se OK criticar, perguntar e processar
	//--------------------------------------
	If nOpcao == 1 
		//----------------------------------------
		// Criticar se não for usuário supervisor.
		//----------------------------------------
		If FA10Super()
			//------------------------------------------------
			// Perguntar ao usuário o que ele deseja importar.
			//------------------------------------------------
			nRet := FA10Want()
			//-------------------------------------
			// Solicitar parâmetros para o usuário.
			//-------------------------------------
			If FA10Ask( nRet, @aRet )
				//-------------------
				// Processar arquivo.
				//------------------- 
				aArea := SZT->( GetArea() )
				
				FA10Process( RTrim( aRet[1] ), nRet, Iif( Len( aRet ) > 1, aRet[ 2 ], "" ) )
				MsgInfo( "Processamento finalizado.", cCadastro )
				
				RestArea( aArea )
			Endif
		Endif
	Endif

Return


//-------------------------------------------------------------------
// Rotina | FA10Ask    | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Solicitar parâmetros para usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10Ask( nWant, aRet )

	Local lRet       := .F.
	Local aPar       := {}
	Local cDescricao := ""
	Local cTipoArq   := ""
	Local cCaminho   := ""
	Local bOk        := {|| }
	Local cHelp      := "Não existe registro relacionado a este código ou o grupo de atendimento não está relacionado a este operador/supervisor."
	Local cMsg       := ""
	Local aOriLst    := {}
	Local nOriLst    := 0
	Local cMV_ORILST := GetMv('MV_ORILST1')+'|'
	
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

	aRet := {}
	
	bOk  := {|| 	Iif( File( mv_par01 ), ;
					MsgYesNo( "Confirma o início do processamento?", cCadastro ),;
					( MsgAlert("Arquivo não localizado, verifique.", cCadastro ), .F. ) ) }	
	
	cDescricao := "Capturar o arquivo de dados"
	
	If nWant == 1	
		cTipoArq := "CSV (separado por vírgulas) (*.csv) |*.csv"
		AAdd( aPar, { 6, cDescricao, Space(99), "", "", "", 80, .T., cTipoArq, cCaminho }                  )
		AAdd( aPar, { 1, "Grupo de Atendimento",Space(2),"","U_FA10GrpAt( mv_par02 )","SU0","",0,.T. }     )
		AAdd( aPar, { 4, "Modo de simulação?",.F.,"Processar os dados simulando a importação.",118,"",.F.} )
		AAdd( aPar, { 1, "Dias de antecedência",30,"99","mv_par04>1","","",15,.T.}                         )
		AAdd( aPar, { 2, "Origem da Lista",1,aOriLst,80,"",.T.}                                            )
		AAdd( aPar, { 1, "Campanha",Space(6),"@!","Vazio().Or.ExistCpo('SUO')","SUO","",50,.F.}            )
		AAdd( aPar, { 1, "Complemento p/ nome lista",Space(99),"@!","","","",100,.F.}                      ) 
	Else
		cTipoArq := "LOG (log de processamento) (*.log) |*.log"
		cCaminho := "SERVIDOR" + cBarra + "commonname" + cBarra + "log_event" + cBarra
		AAdd( aPar, { 6, cDescricao, Space(99), "", "", "", 80, .T., cTipoArq, cCaminho } )
	Endif

	If ParamBox(aPar,"Parâmetros",@aRet,bOk,,,,,,,.F.,.F.)
		//---------------------------
		// Processar nova importação.
		//---------------------------
		If nWant == 1
			//-----------------------------------------
			// Analisar se é para simular a importação.
			//-----------------------------------------
			If aRet[3] 
				lFA10Simula := .T.
			Endif
			//------------------------------------------
			// Dias de antecedência para gerar a agenda.
			//------------------------------------------
			nFA10Dias := aRet[ 4 ]
			//-----------------------------------------------------------------------------------------------
			// Verificar qual opção foi selecionada e converter, isso é uma deficiencia do retorno da função.
			//-----------------------------------------------------------------------------------------------
			If ValType( aRet[ 5 ] ) == "C"
				nOriLst := Val( aRet[ 5 ] )
			Else 
				nOriLst := aRet[ 5 ]
			Endif
			//------------------------------------
			// Buscar o texto da lista selecionada
			//------------------------------------
			cOriLst := Upper( SubStr( aOriLst[ nOriLst ], 3 ) )
			//--------------------
			// Código da campanha.
			//--------------------
			cU4_CODCAMP := aRet[ 6 ]
			//--------------------------------
			// Complemento p/ o nome da lista.
			//--------------------------------
			cFA10Compl := RTrim( aRet[ 7 ] )
		Endif
		lRet := .T.
	Endif
	If lRet .And. nWant==1
		cMsg := "Tem certeza que o arquivo indicado para ser importado para o Protheus está atendendo as seguintes condições: " + CRLF
		cMsg += "(a) Cada coluna deve conter a seguinte nomenclatura: " + CRLF
		cMsg += Chr(9) + "EMPRESA"           + CRLF
		cMsg += Chr(9) + "CNPJ"              + CRLF
		cMsg += Chr(9) + "COMMON_NAME"       + CRLF
		cMsg += Chr(9) + "PRODUTO"           + CRLF
		cMsg += Chr(9) + "CONSULTOR"         + CRLF
		cMsg += Chr(9) + "TECHNICAL_CONTACT" + CRLF
		cMsg += Chr(9) + "ISSUED_DATE"       + CRLF
		cMsg += Chr(9) + "VALID_END_DATE"    + CRLF
		cMsg += Chr(9) + "FIRST_NAME"        + CRLF
		cMsg += Chr(9) + "LAST_NAME"         + CRLF
		cMsg += Chr(9) + "STATE"             + CRLF
		cMsg += Chr(9) + "PHONE"             + CRLF
		cMsg += Chr(9) + "ID_PEDIDO"         + CRLF
		cMsg += "(b) Cada linha de dados é obrigatório no mínimo dados nas seguintes colunas: " + CRLF 
		cMsg += Chr(9) + "CONSULTOR"         + CRLF
		cMsg += Chr(9) + "TECHNICAL_CONTACT" + CRLF
		cMsg += Chr(9) + "VALID_END_DATE"    + CRLF
		cMsg += Chr(9) + "ID_PEDIDO "        + CRLF
		cMsg += " Estando o arquivo e seus dados nestas condições clique no botão <Confirmar>, caso contrário clique em <Voltar>." + CRLF
		If Aviso(cCadastro,cMsg,{"Confirmar","Voltar"},3,"Critério") == 2
			lRet := .F.
		Endif
	Endif

Return( lRet )


//-------------------------------------------------------------------
// Rotina | FA10GrpAt  | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para criticar se o grupo de atendimento informado
//        | existe.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
User Function FA10GrpAt( cVar )

	Local lRet  := .T.
	Local cHelp := "Código "+cVar+" não existe, ou este código de Grupo de Atendimento não está relacionado ao operador/supervisor "+cFAOpSuper+"."

	AG9->( dbSetOrder( 1 ) )
	If ! AG9->( dbSeek( xFilial( "AG9" ) + cFAOpSuper + cVar ) )
		Help(" ", 1, cRotina, , cHelp, 1, 1 )
		lRet := .F.
	Endif

Return( lRet )


//-------------------------------------------------------------------
// Rotina | FA10Want   | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para solicitar ao usuário o que será processado.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10Want()

	Local aPar := {}
	Local aRet := {}
	Local nRet := 0
	
	AAdd( aPar, { 3, "O que deseja executar", 1, { "Processar nova importação" , "Recuperar o LOG de processamento" }, 99, "", .T. } )
	If ParamBox( aPar, "Parâmetros de decisão", @aRet,,,,,,,,.F.,.F.)
		nRet := aRet[ 1 ]
	Endif

Return( nRet )


//-------------------------------------------------------------------
// Rotina | FA10Super  | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para criticar o usuário que executar a rotina.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10Super()

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
// Rotina | FA10Process| Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina de direcionamento para processar arquivo de dados
//        | ou ler arquivo de LOG.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10Process( cArq, nArq, cGrp )

	If nArq == 1
		FA10CpyArq( cArq, cGrp )
	Else
	   Processa( {|| FA10LeLOG( cArq ) }, cCadastro, "Processando arquivo de LOG, aguarde...", .F. )
	Endif

Return


//-------------------------------------------------------------------
// Rotina | FA10CpyArq | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para copiar o arquivo de dados do local origem p/
//        | o local destino informado pelo usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10CpyArq( cArq, cGrp )

	Local nB        := 0
	Local cArqDados := ""
	Local cSystem   := GetSrvProfString( "Startpath", "" )
	Local cProc     := Iif(lFA10Simula,"Simulando","Processando")
	
	//--------------------------------------------------------------------
	// Capturar somente o nome do arquivo, desprezando o caminho completo.
	//--------------------------------------------------------------------
	nB := Rat( cBarra, cArq )
	cArqDados := SubStr( cArq, nB + 1 )
	
	//-----------------------------------------------------------------------
	// Copiar arquivo do local origem para o local destino, ou seja, \system\
	//-----------------------------------------------------------------------
	If __CopyFile( cArq, cSystem + cArqDados )
		Processa( {|| FA10PrcArq( cArqDados, cGrp ) }, cCadastro + " - " + cProc, cProc + " a importação, aguarde...", .F. )
	Else
		MsgInfo( "Falha na cópia do arquivo de dados, não foi possível copiar o arquivo da origem para o destino '" + cSystem + "'", cRotina )
	Endif

Return


//-------------------------------------------------------------------
// Rotina | FA10PrcArq | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para processar o arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10PrcArq( cArqDados, cGrp )
	
	Local cDados   := ""
	Local cHeader  := ""
	
	Local nTamHead := 0
	Local nTimeIni := Seconds()
		
	Local aHeader  := {}
	Local aLinha   := {}
	
	Private aUF                := {}
	Private aFA10Log           := {}
	Private aLISTA             := {}
	
	Private nLinha             := 0
	Private nDADOS             := 0
	
	Private nEMPRESA           := 0
	Private nCNPJ              := 0
	Private nCOMMON_NAME       := 0
	Private nPRODUTO           := 0
	Private nCONSULTOR         := 0
	Private nTECHNICAL_CONTACT := 0
	Private nISSUED_DATE       := 0
	Private nVALID_END_DATE    := 0
	Private nFIRST_NAME        := 0
	Private nLAST_NAME         := 0
	Private nSTATE             := 0
	Private nPHONE             := 0
	Private nID_PEDIDO         := 0

	dbSelectArea("AC8")
	dbSelectArea("SU5")
	
	//----------------------------
	// Cabeçalho do log de eventos
	//----------------------------
	AAdd( aFA10Log, ";"+Replicate("-",200) )
	AAdd( aFA10Log, ";"+"DESCRIÇÃO DA ROTINA: IMPORTAÇÃO DE RENOVAÇÃO SSL (common-name)" + Iif(lFA10Simula," *** SIMULAÇÃO HABILITADA ***",""))
	AAdd( aFA10Log, ";"+"NOME DA ROTINA: " + FunName() )
	AAdd( aFA10Log, ";"+"CÓDIGO E NOME DO USUÁRIO: " + __cUserID + " - " + cUserName )
	AAdd( aFA10Log, ";"+"DATA/HORA DA EXECUÇÃO DA ROTNA: " + Dtoc( MsDate() ) + " - " + Time() )
	AAdd( aFA10Log, ";"+"NOME DA MÁQUINA ONDE FOI EXECUTADO: " + GetComputerName() )
	AAdd( aFA10Log, ";"+"NOME DO ARQUIVO DE DADOS PROCESSADO: " + cArqDados )
	AAdd( aFA10Log, "" )
	AAdd( aFA10Log, ";"+Replicate("-",200) )

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
	aHeader := FA10Array( cHeader )
	//------------------------------------------------
	// Capturar a posição da coluna do Excel no vetor.
	//------------------------------------------------
	nEMPRESA           := AScan( aHeader, {|p| p=="EMPRESA" }           )
	nCNPJ              := AScan( aHeader, {|p| p=="CNPJ" }              )
	nCOMMON_NAME       := AScan( aHeader, {|p| p=="COMMON_NAME" }       )
	nPRODUTO           := AScan( aHeader, {|p| p=="PRODUTO" }           )
	nCONSULTOR         := AScan( aHeader, {|p| p=="CONSULTOR" }         )
	nTECHNICAL_CONTACT := AScan( aHeader, {|p| p=="TECHNICAL_CONTACT" } )
	nISSUED_DATE       := AScan( aHeader, {|p| p=="ISSUED_DATE" }       )
	nVALID_END_DATE    := AScan( aHeader, {|p| p=="VALID_END_DATE" }    )
	nFIRST_NAME        := AScan( aHeader, {|p| p=="FIRST_NAME" }        )
	nLAST_NAME         := AScan( aHeader, {|p| p=="LAST_NAME" }         )
	nSTATE             := AScan( aHeader, {|p| p=="STATE" }             )
	nPHONE             := AScan( aHeader, {|p| p=="PHONE" }             )
	nID_PEDIDO         := AScan( aHeader, {|p| p=="ID_PEDIDO" }         )
	
	//------------------------------------
	// Controlar a transação dos registros
	//------------------------------------
	Begin Transaction
	//----------------------------------------
	// Fazer o tratamento do Header do arquivo
	//----------------------------------------
	If FA10Header( aHeader )
		//---------------------------------------------------------------------
		// Capturar as siglas e os nomes do estados brasileiro para conciliação
		//---------------------------------------------------------------------
		FA10UF()
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
	      aLinha := FA10Array( cDados )
	      If Len( aLinha ) == nTamHead
		      //---------------------------------------
		      // Grava os dados ou gerar inconsistência
		      //---------------------------------------
		      FA10Dados( aLinha )
			Else
				AAdd( aFA10Log,"Advertência;Não foi possível processar a linha "+LTrim(Str(nLinha,10,0))+", pois os dados não estão coerentes com o lay-out determinado.")
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
	
	//---------------------------------------------------------------------------
	// Gerar a lista de atendimento conforme os dados de common name cadastrados.
	//---------------------------------------------------------------------------
	If Len( aLISTA ) > 0
		MsgMeter( {|oMeter,oText,oDlg,lEnd| FA10GrvLis( oMeter, oText, oDlg, @lEnd, cGrp) },"Aguarde, gerando a lista de contatos...",cCadastro,.F.)
		LjMsgRun( "Aguarde, atualizando Renovação SSL (common-name) X Lista de Contatos",,{|| FA10AtuSZT() } )
	Else
		AAdd( aFA10Log, "Advertência;Não há lista de contatos para gerar." )
	Endif
	
	//------------------------------------------
	// Fim do controle da transação de gravação.
	//------------------------------------------
	End Transaction
	
	//--------------------------------------------------------------------------------------------------------------------
	// Se houver log de processamento, gerar o arquivo e mover uma cópia para o TEMP do usuário e para o diretório de LOG.
	//--------------------------------------------------------------------------------------------------------------------
	If Len( aFA10Log ) > 0
		LjMsgRun( "Aguarde, armazenado arquivos e gerando o LOG do processamento...", cCadastro, {|| FA10PrcLog( cArqDados, nTimeIni ) })
	Else
		MsgInfo( "Não houve log de processamento", cCadastro )
	Endif

Return


//-------------------------------------------------------------------
// Rotina | FA10PrcLog | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina armazenar aquivos de dados e log e abrir log no 
//        | Ms-Excel para o usuário.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10PrcLog( cArqDados, nTimeIni )
	
	Local nI   := 0
	Local nP   := 0
	Local nHdl := 0
	
	Local cArqDest   := ""
	Local cNomArq    := CriaTrab( NIL, .F. )
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
	aFA10Log[ 8 ] := ";DURAÇÃO DO PROCESSAMENTO: " + SecsToTime( Seconds() - nTimeIni )

	//---------------------------------------------
	// Gravar no arquivo CSV os elementos do vetor.
	//---------------------------------------------
	For nI := 1 To Len( aFA10Log )
		FWrite( nHdl, aFA10Log[ nI ] + CRLF )
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
// Rotina | FA10UF     | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para capturar os estados brasileiros.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10UF()
	
	SX5->( dbSetOrder( 1 ) )
	SX5->( dbSeek( xFilial( "SX5" ) + "12" ) )
	While ! SX5->( EOF() ) .And. SX5->( X5_FILIAL + X5_TABELA ) == xFilial( "SX5" ) + "12"
		SX5->( AAdd( aUF, { RTrim( X5_CHAVE ), Upper( RTrim( X5_DESCRI ) ) } ) )
		SX5->( dbSkip() )
	End
	
Return


//-------------------------------------------------------------------
// Rotina | FA10Dados | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina de montagem dos dados para gravação.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10Dados( aDados )
	
	Local nUF     := 0
	Local nTamTel := 0
	
	Local cZT_CONSULT := ""
	Local cZT_OPERAD  := ""
	Local cZT_ORIGEM  := ""
	
	Local cU5_CONTAT := ""
	
	Local aSZT := {}
	Local aSU5 := {}
	Local aAC8 := {}
	
	Local cDOC    := AllTrim( aDados[ nCNPJ ] )
	Local lCNPJ   := Empty( cDOC )
	Local cTEL    := AllTrim( aDados[ nPHONE ] )
	Local cUF     := Upper( NoAcento( RTrim( aDados[ nSTATE ] ) ) )
	Local cEstado := Upper( NoAcento( RTrim( aDados[ nSTATE ] ) ) )
	
	//-----------------------------------------------------------
	// Caso não exista o dado VALID_END_DATE, colocar a Database.
	//-----------------------------------------------------------
	If Empty( aDados[ nVALID_END_DATE ] )
		aDados[ nVALID_END_DATE ] := Dtoc( dDatabase )
	Endif
	
	//-----------------------------------------------------------------------------------------------
	// Localizar o nome do estado brasileiro dentro do vetor dos estado capturado na tabela 12 do SX5
	//-----------------------------------------------------------------------------------------------
	If ! Empty( cUF )
		nUF := AScan( aUF, {|a| a[2] == cUF } )
		If nUF > 0
			cUF := aUF[ nUF, 1 ]
		Else
			cUF := ""
		Endif
	Endif	
	
	//----------------------------------
	// Avisar que UF não foi localizado.
	//----------------------------------
	If Empty( cUF )
		AAdd( aFA10Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ". Não foi possível identificar a Unidade Federativa para o estado ["+cEstado+"]." )
	Endif
		
	//------------------
	// Existe o CNPJ/CPF
	//------------------
	If !lCNPJ
		//------------------------------------------------------------------------------------
		// Tirar todo e qualquer caractere diferente de zero a nove para poder validar o dado.
		//------------------------------------------------------------------------------------
		cDOC := FA10SoNum( cDOC )
	   //------------------------------------------
	   // Criticar o documento inserido no registro
	   //------------------------------------------
		lCNPJ := CGC( cDOC, Space( 14 ), .F. )
		If ! lCNPJ
			AAdd( aFA10Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ". CNPJ/CPF inválido [" + AllTrim( aDados[ nCNPJ ] ) + "]." )
		Endif
   Else
		AAdd( aFA10Log, "Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ". CNPJ/CPF não informado." )
   Endif
   
	//----------------------------------------------------------
	// Tirar todo e qualquer caractere diferente de zero a nove.
	//----------------------------------------------------------
	cTEL := FA10SoNum( cTEL )
	
	//-------------------------------------------------------------------------------
	// Criticar se o consultor/vendedor existe, e logo capturar o código de operador.
	//-------------------------------------------------------------------------------
	cZT_CONSULT := aDados[ nCONSULTOR ]
	SA3->( dbSetOrder( 1 ) )
	If SA3->( dbSeek( xFilial( "SA3" ) + cZT_CONSULT ) )
		//-----------------------------------------------------
		// Capturar o código de operador do vendedor/consultor.
		//-----------------------------------------------------
		SU7->( dbSetOrder( 4 ) )
		If SU7->( dbSeek( xFilial( "SU7") + SA3->A3_CODUSR ) )
			//-----------------------------------------------------
			// Montar os vetores para serem gravados os seus dados.
			//-----------------------------------------------------
			cZT_ORIGEM := "REG.IMP." + Dtoc( dDataBase ) + " " + Left(Time(),5) + " USER:" + __cUserID + "-" + RTrim(cUserName)
			cU5_CONTAT := Upper( NoAcento( RTrim( aDados[ nFIRST_NAME ] ) + " " + RTrim( aDados[ nLAST_NAME ] ) ) )
			
			AAdd( aSZT, { "ZT_FILIAL" , xFilial("SZT") } )
			AAdd( aSZT, { "ZT_CODIGO" , "" } )
			
			If ! Empty( aDados[ nEMPRESA ] )
				AAdd( aSZT, { "ZT_EMPRESA", Upper( NoAcento( aDados[ nEMPRESA ] ) ) } )
			Else
				AAdd( aSZT, { "ZT_EMPRESA", cU5_CONTAT } )
			Endif
			
			AAdd( aSZT, { "ZT_CNPJ"   , cDOC } )
			AAdd( aSZT, { "ZT_COMMON" , Lower( aDados[ nCOMMON_NAME ] ) } )
			AAdd( aSZT, { "ZT_PRODUTO", aDados[ nPRODUTO ] } )
			AAdd( aSZT, { "ZT_CONSULT", cZT_CONSULT } )
			AAdd( aSZT, { "ZT_OPERAD" , SU7->U7_COD } )
			AAdd( aSZT, { "ZT_CONTTEC", AllTrim( Lower( aDados[ nTECHNICAL_CONTACT ] ) ) } )
			AAdd( aSZT, { "ZT_DT_INC" , Ctod( aDados[ nISSUED_DATE ] ) } )
			AAdd( aSZT, { "ZT_DT_VLD" , Ctod( aDados[ nVALID_END_DATE ] ) } )
			AAdd( aSZT, { "ZT_ORIGEM" , cZT_ORIGEM } )
			AAdd( aSZT, { "ZT_LISTA"  , "" } )
			AAdd( aSZT, { "ZT_EMISSAO", MsDate() } )
			AAdd( aSZT, { "ZT_NOME"   , cU5_CONTAT } )
			AAdd( aSZT, { "ZT_UF"     , cUF } )
			AAdd( aSZT, { "ZT_ESTADO" , cEstado } )
			AAdd( aSZT, { "ZT_FONE"   , aDados[ nPHONE ] } )
			AAdd( aSZT, { "ZT_IDPEDID", aDados[ nID_PEDIDO ] } )
			
			AAdd( aSU5, { "U5_FILIAL" , xFilial("SU5") } )
			AAdd( aSU5, { "U5_CODCONT", "" } )
			AAdd( aSU5, { "U5_CONTAT" , cU5_CONTAT } )
			AAdd( aSU5, { "U5_FONE"   , cTEL } )
			AAdd( aSU5, { "U5_FCOM1"  , cTEL } )
			AAdd( aSU5, { "U5_ATIVO"  , "1" } )
			AAdd( aSU5, { "U5_EMAIL"  , AllTrim( Lower( aDados[ nTECHNICAL_CONTACT ] ) ) } )
			AAdd( aSU5, { "U5_EST"    , cUF } )
			AAdd( aSU5, { "U5_OBS"    , cZT_ORIGEM } )
			
			AAdd( aAC8, { "AC8_FILIAL" , xFilial("AC8") } )
			AAdd( aAC8, { "AC8_FILENT" , xFilial("SZT") } )
			AAdd( aAC8, { "AC8_ENTIDA" , "SZT" } )
			AAdd( aAC8, { "AC8_CODENT" , "" } )
			AAdd( aAC8, { "AC8_CODCON" , "" } )
			
			//-------------------------------
			// Executar a função de gravação.
			//-------------------------------
			FA10GrvDad( aSZT, aSU5, aAC8 )
		Else
			AAdd( aFA10Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". Código ["+cZT_CONSULT+"] do consultor/vendedor não está cadastrado como operador no Cadastro de Operadores." )
		Endif
	Else
		AAdd( aFA10Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". Código ["+cZT_CONSULT+"] do consultor/vendedor não localizado no cadastro de vendedor." )
	Endif
	
Return


//-------------------------------------------------------------------
// Rotina | FA10SoNum  | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para extrair caracteres diferente de 0 a 9.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10SoNum( cVar )
	
	Local nI       := 0
	Local cAux     := ""
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
// Rotina | FA10GrvDad | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina de gravação dos dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10GrvDad( aSZT, aSU5, aAC8 )

	Local nI          := 0
	
	Local lSZT        := .T.
	Local lSU5        := .T.
	Local lAC8        := .T.
	Local lXImpSsl    := GetMv("MV_XIMPSSL", .F.)
	
	Local nDias       := 0
	Local nSemana     := 0
	
	Local cZT_CODIGO  := ""
	Local cU5_CODCONT := ""
	Local cKeySZT     := ""
	Local cKeySU5     := ""
	Local cKeyAC8     := ""
	Local cID_PEDIDO  := ""
	
	Local dZT_DT_VLD  := Ctod("  /  /  ")
	Local dDTAgenda   := Ctod("  /  /  ")
	
	//------------------------------------------
	// Chave com o número do pedido do Verisign.
	//------------------------------------------
	cID_PEDIDO := aSZT[ AScan(aSZT,{|p| p[1] == "ZT_IDPEDID" } ), 2 ]
	//-----------------------------------------------
	// Rejeitar o registro caso não haja o ID_PEDIDO.
	//-----------------------------------------------
	If .NOT. Empty( cID_PEDIDO )
		//-----------------------------------------------------------------------------------------
		// Caso encontre o ID_PEDIDO, não fazer absolutamente nada nas tabelas SZT/SU5/AC8/SU4/SU6.
		//-----------------------------------------------------------------------------------------
		SZT->( dbSetOrder( 6 ) )
		If .NOT. SZT->( dbSeek( xFilial( "SZT" ) + cID_PEDIDO ) ) .Or. lXImpSsl
			If ! Empty( aSZT[ AScan(aSZT,{|p| p[1] == "ZT_CONTTEC" } ), 2] ) .Or. lXImpSsl
				//-------------------------------------------------
				// Se a data de expiração estiver vazio não gravar.
				//-------------------------------------------------
				If ! Empty( aSZT[ AScan(aSZT,{|p| p[1] == "ZT_DT_VLD" } ), 2] ) .Or. lXImpSsl
					//-----------------------------------------------------------------------------------------------
					// Chave do Common Name -> ZT_FILIAL + ZT_COMMON + ZT_PRODUTO + DTOS(ZT_DT_INC) + DTOS(ZT_DT_VLD)
					//-----------------------------------------------------------------------------------------------
					cKeySZT :=	;
								aSZT[ AScan(aSZT,{|p| p[1]=="ZT_FILIAL"}), 2 ] + ;
								PadR( AllTrim( aSZT[ AScan(aSZT,{|p| p[1] == "ZT_COMMON"}), 2 ] ), Len( SZT->ZT_COMMON ), " " ) + ;
								PadR( AllTrim( aSZT[ AScan(aSZT,{|p| p[1] == "ZT_PRODUTO"}), 2 ] ), Len( SZT->ZT_PRODUTO ), " " ) + ;
								Dtos( aSZT[ AScan(aSZT,{|p| p[1] == "ZT_DT_INC"}), 2] ) + ;
								Dtos( aSZT[ AScan(aSZT,{|p| p[1] == "ZT_DT_VLD"}), 2] )
								
					//------------------------------------------------------------------------------
					// Verificar se já existe o common name + produto + data de inclusão e validade.
					//------------------------------------------------------------------------------
					SZT->( dbSetOrder( 2 ) )
					lSZT := SZT->( MsSeek( cKeySZT ) )
					
					If lSZT
						//------------------------------------------
						// Se existir pegar o código do common name.
						//------------------------------------------
						cZT_CODIGO := SZT->ZT_CODIGO
						
						//-----------------------------------------------------------------------
						// Em existir o common name, gerar o log de processamento apenas de aviso
						//-----------------------------------------------------------------------
						AAdd( aFA10Log, 	"Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ;
											". Já existe cadastro para o COMMON_NAME + PRODUTO + ISSUED_DATE + VALID_END_DATE -> "+;
											aSZT[ AScan(aSZT,{|p| p[1]=="ZT_COMMON"}), 2 ] +" + "+ ;
											aSZT[ AScan(aSZT,{|p| p[1]=="ZT_PRODUTO"}), 2 ] +" + "+ ;
											Dtoc( aSZT[ AScan(aSZT,{|p| p[1]=="ZT_DT_INC"}), 2] ) +" + "+ ;
											Dtoc( aSZT[ AScan(aSZT,{|p| p[1]=="ZT_DT_VLD"}), 2] ) +"." )			
					Else
						//-----------------------
						// Caso não exista, criar
						//-----------------------
						cZT_CODIGO := GetSXENum( "SZT", "ZT_CODIGO" )
						If ! lFA10Simula
							ConfirmSX8()
						Else
							RollBackSX8()
						Endif			
					Endif
					
					aSZT[ AScan(aSZT,{|p| p[1]=="ZT_CODIGO"}), 2 ] := cZT_CODIGO
					aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODENT"}), 2 ] := cZT_CODIGO
					
					//---------------------------------------------
					// Verificar se já existe o contato pelo e-mail
					//---------------------------------------------
					// Chave: U5_FILIAL + U5_EMAIL
					//---------------------------------------------
					cKeySU5 := aSU5[ AScan(aSU5,{|p| p[1]=="U5_FILIAL"}), 2 ] + RTrim( aSU5[ AScan( aSU5,{|p| p[1]=="U5_EMAIL"}), 2 ] )
					
					SU5->( dbSetOrder( 9 ) )
					lSU5 := SU5->( dbSeek( cKeySU5 ) )
					
					If lSU5
						cU5_CODCONT := SU5->U5_CODCONT
					Else
						cU5_CODCONT := GetSXENum( "SU5", "U5_CODCONT" )
						If ! lFA10Simula
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
					cKeyAC8 :=	aAC8[ AScan(aAC8,{|p| p[1]=="AC8_FILIAL"}), 2 ] + ;
								aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODCON"}), 2 ] + ;
								aAC8[ AScan(aAC8,{|p| p[1]=="AC8_ENTIDA"}), 2 ] + ;
								aAC8[ AScan(aAC8,{|p| p[1]=="AC8_FILENT"}), 2 ] + ;
								aAC8[ AScan(aAC8,{|p| p[1]=="AC8_CODENT"}), 2 ]
					
					AC8->( dbSetOrder( 1 ) )
					lAC8 := AC8->( dbSeek( cKeyAC8 ) )
					If lAC8
						AAdd( aFA10Log, 	"Aviso;Linha: " + LTrim(Str(nLinha,10,0)) + ;
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
						If ! lFA10Simula
							AC8->( RecLock( "AC8", .T. ) )
							For nI := 1 To Len( aAC8 )
								AC8->( FieldPut( FieldPos( aAC8[ nI, 1 ] ), aAC8[ nI, 2 ] ) )
							Next nI
							AC8->( MsUnLock() )
						Endif
						AAdd( aFA10Log, "Processado OK;Gravado registro nº " + LTrim( Str( AC8->( RecNo() ), 10, 0 ) ) + " na tabela AC8." )
					Endif
					
					//----------------------------------
					// Gravar SU5 incluindo ou alterando
					//----------------------------------
					If ! lFA10Simula
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
					AAdd( aFA10Log, "Processado OK;"+Iif(lSU5,"Gravado","Alterado")+" registro nº " + LTrim( Str( SU5->( RecNo() ), 10, 0 ) ) + " na tabela SU5." )
					
					//----------------------------------
					// Gravar SZT incluindo ou alterando
					//----------------------------------
					If ! lFA10Simula
						If lSZT
							SZT->( RecLock( "SZT", .F. ) )
						Else
							SZT->( RecLock( "SZT", .T. ) )
						Endif
						For nI := 1 To Len( aSZT )
							SZT->( FieldPut( FieldPos( aSZT[ nI, 1 ] ), aSZT[ nI, 2 ] ) )
						Next nI
						SZT->( MsUnLock() )
					Endif
					AAdd( aFA10Log, "Processado OK;"+Iif(lSZT,"Gravado","Alterado")+" registro nº " + LTrim( Str( SZT->( RecNo() ), 10, 0 ) ) + " na tabela SZT." )
					
					//---------------------------------------------
					// Capturar a data em que expira o certificado.
					//---------------------------------------------
					dZT_DT_VLD := aSZT[ AScan( aSZT, {|a| a[ 1 ] == "ZT_DT_VLD"  } ), 2 ]
					//---------------------------------------------------------------------
					// Calcular a diferenca entre a data que expira e a data da importação.
					//---------------------------------------------------------------------
					nDias := dZT_DT_VLD - MsDate()
					//------------------------------------------------------------------
					// Se o resultado do cálculo foi maior que o parâmetro estabelecido.
					//------------------------------------------------------------------
					If nDias > nFA10Dias
						//--------------------------------------------------------------------
						// Calcular Data do dia + Diferença entre dias - o prazo para atender.
						//--------------------------------------------------------------------
						dDTAgenda := MsDate() + ( nDias - nFA10Dias )
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
					// Verificar se é preciso pesquisar novamente o operador.
					//-------------------------------------------------------
					If aSZT[ AScan( aSZT, {|p| p[ 1 ] == "ZT_OPERAD" } ), 2 ] <> SU7->U7_COD
						SU7->( dbSetOrder( 1 ) )
						SU7->( MsSeek( xFilial( "SU7" ) + aSZT[ AScan( aSZT, {|a| a[ 1 ] == "ZT_OPERAD"  } ), 2 ] ) )
					Endif
					
					//-------------------------------------------------
					// Armazenar dados para gravar a lista de contatos.
					//-------------------------------------------------
					AAdd( aLISTA, { 	SU7->U7_COD, ;
										dZT_DT_VLD, ;
										aSU5[ AScan( aSU5, {|a| a[1]=="U5_CODCONT"  } ), 2 ], ;
										aSZT[ AScan( aSZT, {|a| a[1]=="ZT_OPERAD"  } ), 2 ], ;
										Iif( lAC8, AC8->AC8_CODENT, aAC8[ AScan( aAC8, {|a| a[1]=="AC8_CODENT" } ), 2 ] ),;
										SU7->U7_POSTO, ;
										SZT->( RecNo() ), ; //Recno da tabela SZT Common Name.
										"", ; //Código da lista de contatos.
										Dtos( dDTAgenda ), ; //Data em que a agenda será gerada para o operador. Precisa estar no formato String <AAMMDD>.
										aSZT[ AScan( aSZT, {|a| a[1]=="ZT_EMPRESA" } ), 2] } ) //Nome da empresa para constar na lista.
				Else
					AAdd( aFA10Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". Renovação SSL (common-name) sem data de expiração, logo este registro não será gravado." )
				Endif
			Else
				AAdd( aFA10Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". O contato está sem e-mail. Não será possível importar." )
			Endif
		Else
			AAdd( aFA10Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". O ID_PEDIDO foi localizado com o código ["+SZT->ZT_CODIGO+"], por isso não será importado." )
		Endif
	Else
		AAdd( aFA10Log, "Advertência;Linha: " + LTrim(Str(nLinha,10,0)) + ". O registro está sem ID_PEDIDO, por isso não será importado." )
	Endif

Return


//-------------------------------------------------------------------
// Rotina | FA10GrvLis | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina de gravação da lista de contatos.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10GrvLis( oMeter, oText, oDlg, lEnd, cGrp )

	Local nI          := 0
	Local nCOUNT      := 0
	Local nLastRec    := 0
	Local cU4_LISTA   := ""
	Local cU4_DESC    := ""
	Local cU6_CODIGO  := ""
	Local cAG9_CODSU0 := 0
	Local nSize       := 0
	
	//-------------------------------------------------------
	// Ordernar a lista conforme operador + data de validade.
	//-------------------------------------------------------
	ASort( aLISTA,,,{|a,b| ( a[ 4 ] + a[ 9 ] ) < ( b[ 4 ] + b[ 9 ] ) } )
	
	nLastRec := Len( aLISTA )
	oMeter:nTotal := nLastRec
		
	For nI := 1 To Len( aLISTA )
		nCOUNT++
		IncMeter(oMeter,oText,nCOUNT,"Processando registro: "+LTrim(Str(nCOUNT))+" de "+LTrim(Str(nLastRec)))
		
		//--------------------------------
		// Grava cabeçalho e um único item
		//--------------------------------
		If ! lFA10Simula
			//---------------------------------
			// Se a variável não estiver vazia.
			//---------------------------------
			If !Empty( cFA10Compl )
				//---------------------------------------------------------------
				// Atribuir a variável o nome da lista e o complemento informado.
				//---------------------------------------------------------------
				cU4_DESC := cOriLst + ' ' + cFA10Compl
				//--------------------------------------------------------------------------------------------------
				// Se houver um espaço maior ou igual que o texto 'EXPIRA EM 99/99/999', atribuir este texto também.
				//--------------------------------------------------------------------------------------------------
				nSize := Len( SU4->U4_DESC ) - Len( cU4_DESC )
				If nSize >= 20
					cU4_DESC := cU4_DESC //+ " EXPIRA EM " + Dtoc( aLISTA[ nI, 2 ] )
				Endif
			//-----------------------------
			// Se a variável estiver vazia.
			//-----------------------------
		   Else
				//-----------------------------------------------------------
				// Montar a primeira parte da descrição da lista de contatos.
				//-----------------------------------------------------------
				cU4_DESC := cOriLst //+ " EXPIRA EM " + Dtoc( aLISTA[ nI, 2 ] ) + " "
				//-------------------------------------------------------------------------------------------------------------------------
				// Montar a segunda parte da descrição, porém agora com o complemento até 60 caracteres contemplando com o nome do cliente.
				//-------------------------------------------------------------------------------------------------------------------------
				cU4_DESC := cU4_DESC + Left( aLista[ nI, 10 ], 60 - Len( cU4_DESC ) )
			Endif
			//------------------------------------------------
			// Capturar o próximo número da lista de contatos.
			//------------------------------------------------
			cU4_LISTA  := GetSXENum("SU4","U4_LISTA")
			//---------------------------------------
			// Confirmar a captura do próximo número.
			//---------------------------------------
			ConfirmSX8()
			//---------------------------------	
			// Iniciar a gravação do cabeçalho.
			//---------------------------------	
			SU4->( RecLock( "SU4", .T. ) )
				SU4->U4_FILIAL  := xFilial("SU4")
				SU4->U4_TIPO    := "1" //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
				SU4->U4_STATUS  := "1" //1=Ativa;2=Encerrada;3=Em Andamento
				SU4->U4_LISTA   := cU4_LISTA
				SU4->U4_DESC    := cU4_DESC
				SU4->U4_DTEXPIR := aLista[ nI, 2 ]
				SU4->U4_DATA    := Stod( aLista[ nI, 9 ] ) //Data da inclusão da agenda do consultor.
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
		
		If ! lFA10Simula
			cU6_CODIGO := GetSXENum("SU6","U6_CODIGO")
			If __lSX8
				ConfirmSX8()
			EndIf
			
			SU6->( RecLock( "SU6", .T. ) )
				SU6->U6_FILIAL  := xFilial("SU6")
				SU6->U6_LISTA   := cU4_LISTA
				SU6->U6_CODIGO  := cU6_CODIGO
				SU6->U6_CONTATO := aLISTA[ nI, 3 ]
				SU6->U6_ENTIDA  := "SZT"
				SU6->U6_CODENT  := aLISTA[ nI, 5 ]
				SU6->U6_ORIGEM  := "1" //1=Lista;2=Manual;3=Atendimento.
				SU6->U6_DATA    := Stod( aLISTA[ nI, 9 ] ) //Data da inclusão da agenda do consultor.
				SU6->U6_HRINI   := "06:00"
				SU6->U6_HRFIM   := "23:59"
				SU6->U6_STATUS  := "1" //1=Nao Enviado;2=Em uso;3=Enviado.
				SU6->U6_DTBASE  := MsDate()
			SU6->( MsUnLock() )
		Endif

		AAdd( aFA10Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU4->( RecNo() ), 10, 0 ) ) + " na tabela SU4.  Nº da Lista: " + cU4_LISTA )
		AAdd( aFA10Log, "Processado OK;Gravado registro nº " + LTrim( Str( SU6->( RecNo() ), 10, 0 ) ) + " na tabela SU6.  Nº da Lista: " + cU4_LISTA )
		
		//-------------------------------------------------------------------
		// Guardar o número da lista para atualizar o registro de Common Name
		//-------------------------------------------------------------------
		aLISTA[ nI, 8 ] := cU4_LISTA
		
		//----------------------------------------------------------
		// Verificar se o operador faz parte do grupo de atendimento
		// Se não fizer parte apenas alertar
		//----------------------------------------------------------
		cAG9_CODSU0 := Posicione( "AG9", 1, xFilial( "AG9" ) + aLISTA[ nI, 4 ], "AG9_CODSU0" )		
		If cGrp <> cAG9_CODSU0
			AAdd( aFA10Log, "Aviso;O operador " + aLISTA[ nI, 4 ] + " não pertence ao grupo de operadores " + cGrp + " ele pertence ao grupo " + cAG9_CODSU0 )
		Endif
	Next nI

Return


//-------------------------------------------------------------------
// Rotina | FA10AtuSZT | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para atualizar o Common Name com a lista onde ele
//        | foi gerado.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10AtuSZT()

	Local nI := 0	

	For nI := 1 To Len( aLISTA )
		//--------------------------------------------------------
		// Atualizar o Common Name com a lista onde ele foi gerado
		//--------------------------------------------------------
		If ! lFA10Simula
			SZT->( dbGoTo( aLISTA[ nI, 7 ] ) ) // Localizar o Common Name.
			If SZT->( RecNo() ) == aLISTA[ nI, 7 ] 
				SZT->( RecLock( "SZT", .F. ) )
				SZT->ZT_LISTA := aLISTA[ nI, 8 ] // Gravar a lista onde ele foi gerado.
				SZT->( MsUnLock() )
			Endif
		Endif
	Next nI

Return


//-------------------------------------------------------------------
// Rotina | IncMeter   | Autor | Robson Luiz - Rleg | Data | 07/08/12
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
// Rotina | FA10Header | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina de critíca do cabeçalho do arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10Header( aArray )

	Local nI     := 0
	Local lRet   := .T.
	Local aExcel := {}
	
	AAdd( aExcel, "EMPRESA"           )
	AAdd( aExcel, "CNPJ"              )
	AAdd( aExcel, "COMMON_NAME"       )
	AAdd( aExcel, "PRODUTO"           )
	AAdd( aExcel, "CONSULTOR"         )
	AAdd( aExcel, "TECHNICAL_CONTACT" )
	AAdd( aExcel, "ISSUED_DATE"       )
	AAdd( aExcel, "VALID_END_DATE"    )
	AAdd( aExcel, "FIRST_NAME"        )
	AAdd( aExcel, "LAST_NAME"         )
	AAdd( aExcel, "STATE"             )
	AAdd( aExcel, "PHONE"             )
	AAdd( aExcel, "ID_PEDIDO"         )
	
	nDADOS := Len( aExcel )
	
	For nI := 1 To Len( aExcel )
		nP := AScan( aArray, {|a| a == aExcel[ nI ] } )
		If nP == 0
			lRet := .F.
			
			AAdd( aFA10Log, "Advertência;Linha: " + ;
					LTrim( Str( nLinha, 10, 0 ) ) + ". O campo " + aExcel[ nI ] + ;
					" não foi localizado nas colunas do arquivo de dados, impossível continuar, a rotina será abortada." )
		Endif
	Next nI	

Return( lRet )


//------------------------------------------------------------------
// Rotina | FA10Array | Autor | Robson Luiz - Rleg | Data | 07/08/12
//------------------------------------------------------------------
// Descr. | Rotina p/ fragmentar os dados da linha do arquivo de 
//        | dados em elementos de vetor.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA10Array( cLinha )

	Local nP := 0
	Local nD := 0
	
	Local aArray := {}	
	
	Local cAux   := ""
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
			AAdd( aArray, SubStr( cLinha, 1, nP-1 ) )
			cLinha := SubStr( cLinha, nP+1 )
		Endif
	End

Return( aArray )


//------------------------------------------------------------------
// Rotina | FA10LeLOG | Autor | Robson Luiz - Rleg | Data | 07/08/12
//------------------------------------------------------------------
// Descr. | Rotina de leitura do arquivo de LOG de processamento.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA10LeLOG( cArq )

	Local cArqLog := ""
	Local nB      := 0
	Local nP      := 0
	
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
// Rotina | FA10Premis | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina de apresentação das premissão para a rotina poder
//        | ler o arquivo de dados.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10Premis()

	Local	oDlg
	Local	oBtOk
	Local	oSay
	Local	oGet
	Local	oFont  := TFont():New( "Arial", , 15, ,.F. )
	Local	oFontB := TFont():New( "Arial", , 15, ,.T. )
	
	Local cPremissa := ""
	
	cPremissa := "1º - O arquivo de dados deve ser gerado com a extensão CSV e os dados separados por ponto-vírgula. "       + CRLF + CRLF
	cPremissa += "2º - O arquivo deve conter um cabeçalho (header) com as seguintes nomenclaturas abaixo para cada coluna. " + CRLF + CRLF 
	cPremissa += "Em maiúsculo os nomes das colunas são: "                                                                   + CRLF + CRLF 
	cPremissa += "   EMPRESA;"           + CRLF
	cPremissa += "   CNPJ;"              + CRLF
	cPremissa += "   COMMON_NAME;"       + CRLF
	cPremissa += "   PRODUTO;"           + CRLF
	cPremissa += " * CONSULTOR;"         + CRLF
	cPremissa += " * TECHNICAL_CONTACT;" + CRLF
	cPremissa += "   ISSUED_DATE;"       + CRLF
	cPremissa += " * VALID_END_DATE;"    + CRLF
	cPremissa += "   FIRST_NAME;"        + CRLF
	cPremissa += "   LAST_NAME;"         + CRLF
	cPremissa += "   STATE;"             + CRLF
	cPremissa += "   PHONE;"             + CRLF
	cPremissa += " * ID_PEDIDO;"         + CRLF + CRLF
	cPremissa += "No mínimo devem ser informados os campos com (*). " + CRLF
	cPremissa += "Repare que entre cada dado há o caracter ponto-vírgula separando-o entre os dados. " + CRLF
	cPremissa += "Caso uma das premissas não seja atendida o arquivo de dados será rejeitado."         + CRLF
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO 325, 520 TITLE "Premissas para processar o arquivo de dados" PIXEL
		@ 05, 5 SAY oSay VAR "PREMISSAS" SIZE 205, 010 FONT oFontB OF oDlg PIXEL COLOR CLR_HRED
		@ 15, 5 GET oGet VAR cPremissa OF oDlg MEMO SIZE 252, 125 FONT oFont PIXEL READONLY
		DEFINE SBUTTON oBtOk FROM 145, 232 TYPE 22 ACTION oDlg:End () ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED

Return


//-------------------------------------------------------------------
// Rotina | FA10CanUse | Autor | Robson Luiz - Rleg | Data | 07/08/12
//-------------------------------------------------------------------
// Descr. | Rotina para verificar se a infra-estrurura da rotina foi
//        | criada.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA10CanUse()

   	Local lRet        := .T.
	Local cX6_VAR     := 'MV_ORILST1'
	Local cX6_CONTEUD := "1=Renov.Cert.SSL|2=Leads|3=Listas|4=E-Mail Mkt|5=Eventos|6=Campanhas|7=Outras Listas" 

	//--------------------------------------------------------
	// Verificar se existe o parâmetro com os tipos de listas.
	//--------------------------------------------------------
	If !ExisteSX6( cX6_VAR )
		CriarSX6( cX6_VAR, 'C', 'Tipos de lista de contato para agenda do operador - CSFA010.prw', cX6_CONTEUD )
	Endif

	//----------------------------------------
	// Existe a chave para a tabela em questão
	//----------------------------------------
	SX5->( dbSetOrder( 1 ) )
	If ! SX5->( dbSeek( xFilial( "SX5" ) + "T5" + "SZT" ) )
		MsgAlert("Não foi localizado a chave 'SZT' para Contatos X Entidade (SX5-T5). Acessou a empresa/filial correta?", cCadastro )
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
		If ! SXB->( dbSeek( "SZT" ) )
			MsgAlert("Não existe a Consulta Padrão (SXB) configurada para a tabela de Renovação SSL (common-name) (SZT), verifique.", cCadastro )
			lRet := .F.
		Endif
	Endif

Return( lRet )


//------------------------------------------------------------------
// Rotina | FA10TmkEnt | Autor | Robson Luiz - Rleg | Data | 07/08/2012
//------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TMKENT.
//------------------------------------------------------------------
// Objet. | O objetivo é retornar o nome da entidade.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA10TmkEnt( cEntidade )

	Local cCpo := ""
	
   If cEntidade == "SZT"
   	cCpo := "ZT_EMPRESA"
   Endif   

Return( cCpo )


//------------------------------------------------------------------
// Rotina | FA10TmkAct | Autor | Robson Luiz - Rleg | Data | 07/08/2012
//------------------------------------------------------------------
// Descr. | Rotina acionada pelo ponto de entrada TMKACTIVE.
//------------------------------------------------------------------
// Objet. | O objetivo é retornar o do contato e da entidade.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA10TmkAct()

	Local cAC8_CODENT := ""
	Local cZT_EMPRESA := ""
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
				cAC8_CODENT := RTrim( Posicione( "AC8", 1, xFilial( "AC8" ) + M->UC_CODCONT + "SZT" + xFilial( "SZT" ), "AC8_CODENT" ) )
				//-------------------------------------------
				// Se não estiver vazio o código da entidade.
				//-------------------------------------------
				If ! Empty( cAC8_CODENT )
					//---------------------------------------
					// Buscar o nome da entidade common name.
					//---------------------------------------
					SZT->( dbSetOrder( 1 ) )
					If SZT->( MsSeek( xFilial( "SZT" ) + cAC8_CODENT ) )
						cZT_EMPRESA := SZT->ZT_EMPRESA
					Endif
					//-----------------------------------------------------
					// Se não estiver vazio o nome da entidade common name.
					//-----------------------------------------------------
					If ! Empty( cZT_EMPRESA )
						//--------------------------------------
						// Atribuir valor aos campos da Enchoice
						//--------------------------------------
						M->UC_DESCENT := Tabela("T5","SZT",.F.)
						M->UC_DESCCHA := cZT_EMPRESA
						M->UC_ENTIDAD := "SZT"
						M->UC_CHAVE   := cAC8_CODENT
						M->UC_OPERACA := "2" //1=Receptivo;2=Ativo
						M->UC_STATUS  := ""  //1=Planejado;2=Pendente;3=Encerrada
						M->UC_OBS     := "Common name: "     + RTrim( SZT->ZT_COMMON )  + CRLF + ;
						                 "Produto: "         + RTrim( SZT->ZT_PRODUTO ) + CRLF + ;
						                 "Contato técnico: " + RTrim( SZT->ZT_CONTTEC ) + CRLF + ;
						                 "Data inclusão: "   + Dtoc( SZT->ZT_DT_INC )   + CRLF + ;
						                 "Data validade: "   + Dtoc( SZT->ZT_DT_VLD )
						//--------------------------------------
						// Atribuir valor as variáveis do rodapé
						//--------------------------------------
						cNomeHist := cZT_EMPRESA
						oNomeHist:Refresh()
						cContHist := Posicione( "SU5", 1, xFilial( "SU5" ) + M->UC_CODCONT, "U5_CONTAT" )
						oContHist:Refresh()
						//------------------------------------------
						// Atribuir valores aos campos da MsGetDados
						//------------------------------------------
						aCOLS[ 1, GdFieldPos( "UD_ASSUNTO" ) ] := cUD_ASSUNTO
						aCOLS[ 1, GdFieldPos( "UD_DESCASS" ) ] := Tabela( "T1", cUD_ASSUNTO )
						aCOLS[ 1, GdFieldPos( "UD_STATUS" ) ]  := "" //1=Pendente;2=Encerrado
						oGetTmk:oBrowse:Refresh(.T.)
					Endif
				Endif
			Endif
		Endif
	Endif

Return


//------------------------------------------------------------------
// Rotina | FA10Fup | Autor | Robson Luiz - Rleg | Data | 07/08/2012
//------------------------------------------------------------------
// Descr. | Rotina para apresentar as lista de contatos gerados a
//        | partir de um Common Name.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function FA10Fup()

	Local aSay     := {}
	Local aButton  := {}
	
	Local aPar     := {}
	Local aRet     := {}
		
	Local nOpcao   := 0
	
	Private aOrdem := {}

	AAdd( aOrdem, "1-Operador + Data da agenda + Lista")
	AAdd( aOrdem, "2-Código de lista de atendimento")
	AAdd( aOrdem, "3-Data da agenda do operador")

	AAdd( aSay, "Esta rotina apresenta as listas de contatos que a importação de Renovação SSL gerou, " )
	AAdd( aSay, "por favor, clique em OK para informar os parâmetros de busca." )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton, , 160 )
	
	//-----------------------------------------
	// Se OK criticar o usuário se é supervisor
	//-----------------------------------------
	If nOpcao == 1 
		If FA10Super()
			AAdd( aPar, { 1, "A partir da importação",Ctod(Space(8)),"",""                    ,""      , "", 50, .F. } )
			AAdd( aPar, { 1, "Até a importação",      Ctod(Space(8)),"","(mv_par02>=mv_par01)",""      , "", 50, .T. } )
			AAdd( aPar, { 2, "Ordernar por:", 1, aOrdem, 105, "", .F. } )
			If ParamBox( aPar, "Follow-up de lista de contatos", @aRet, , , , , , , ,.F. ,.F. )
				Processa( {| lEnd | FA10Cont( @lEnd, aRet ) }, cCadastro, "Aguarde, buscando dados...", .T. )
			Endif
		Endif
   Endif

Return


//------------------------------------------------------------------
// Rotina | FA10Cont | Autor | Robson Luiz - Rleg | Data | 07/08/12
//------------------------------------------------------------------
// Descr. | Rotina para processar os dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function FA10Cont( lEnd, aRet )

	Local cSQL := ""
	Local cTRB := GetNextAlias()
	
	Local cCount := ""
	Local nCount := 0
	
	Local nI         := 0
	Local nHdl       := 0
	Local nU6_STATUS := 0
	
	Local cLocalPath := ""
	Local cStartPath := ""
	Local cArqTMP    := ""
	Local cSpace     := ""
	Local cDados     := ""
	Local cCpo       := ""
	
	Local aU6_STATUS := {}
	Local aHeader    := {}
	
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
	AAdd( aHeader, { "ZT_CODIGO" , "" } )
	AAdd( aHeader, { "ZT_EMPRESA", "" } )
	AAdd( aHeader, { "ZT_COMMON" , "" } )
	AAdd( aHeader, { "ZT_PRODUTO", "" } )
	AAdd( aHeader, { "ZT_CONSULT", "" } )
	AAdd( aHeader, { "ZT_OPERAD" , "" } )
	AAdd( aHeader, { "ZT_DT_INC" , "" } )
	AAdd( aHeader, { "ZT_DT_VLD" , "" } )
	AAdd( aHeader, { "ZT_NOME"   , "" } )
	AAdd( aHeader, { "ZT_EMISSAO", "" } )
	
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
	cSQL += " INNER JOIN "+RetSqlName("SZT")+" SZT "
	cSQL += "    ON ZT_CODIGO = U6_CODENT "
	cSQL += "   AND ZT_FILIAL = '"+xFilial("SZT")+"' "
	cSQL += "   AND ZT_EMISSAO BETWEEN '"+Dtos(aRet[1])+"' AND '"+Dtos(aRet[2])+"' "
	cSQL += "   AND SZT.D_E_L_E_T_ = ' ' "
	cSQL += " INNER JOIN "+RetSqlName("SU5")+" SU5 "
	cSQL += "    ON U5_FILIAL = '"+xFilial("SU5")+"' "
	cSQL += "   AND U5_CODCONT = U6_CONTATO "
	cSQL += "   AND SU6.D_E_L_E_T_ = ' ' "
	cSQL += " WHERE U6_DTBASE BETWEEN '"+Dtos(aRet[1])+"' AND '"+Dtos(aRet[2])+"' "
	cSQL += "   AND U6_FILIAL = '"+xFilial("SU6")+"' "
	cSQL += "   AND SU6.D_E_L_E_T_ = ' ' "
	cSQL += "   AND U6_ENTIDA = 'SZT' "
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
		cDados := "Follow-up de Importação [ ICP-Brasil X Lista de Contatos ] " + CRLF
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


//-----------------------------------------------------------------------
// Rotina | UPD010     | Autor | Robson Gonçalves     | Data | 24.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD010()
	
	Local cModulo := 'TMK'
	Local bPrepar := {|| U_U10Ini() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
	
Return

//-----------------------------------------------------------------------
// Rotina | U010Ini    | Autor | Robson Gonçalves     | Data | 24.09.2013
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U10Ini()
	
	aSIX  := {}
	aSX3  := {}
	aHelp := {}

	AAdd( aSX3 ,{	'SZT',NIL,'ZT_IDPEDID','C',10,0,;			// Alias,NIL,Campo,Tipo,Tamanho,Decimais
					'ID Pedido','ID Pedido','ID Pedido',;		// Tit. Port.,Tit.Esp.,Tit.Ing.
					'ID Pedido','ID Pedido','ID Pedido',;		// Desc. Port.,Desc.Esp.,Desc.Ing.
					'@!',;											// Picture
					'',;											// Valid
					X3_EMUSO_USADO,;								// Usado
					'',;											// Relacao
					'',1,X3_USADO_RESERV,'','',;				// F3,Nivel,Reserv,Check,Trigger
					'U','N','V','R',' ',;						// Propri,Browse,Visual,Context,Obrigat
					'',;											// VldUser
					'','','',;										// Box Port.,Box Esp.,Box Ing.
					'','','','','',;								// PictVar,When,Ini BRW,GRP SXG,Folder
					'N','',''})									// Pyme,CondSQL,ChkSQL

	AAdd( aHelp, {'ZT_IDPEDID', 'Identificador do pedido Verisign.' } )
	
	AAdd( aSIX, { 'SZT', '6', 'ZT_FILIAL+ZT_IDPEDID', 'Identificador Pedido Verisign', 'Identificador Pedido Verisign', 'Identificador Pedido Verisign', 'S', 'S' } )

Return


//+-------------------------------------------------------------------+
//| Rotina    | A010ChgSX6 | Autor | David.Santos | Data | 17/10/2016 |
//+-------------------------------------------------------------------+
//| Descricao | Rotina para permitir alterar os parâmetros SX6 da     |
//|           | rotina Renov. Ssl                                     |
//+-------------------------------------------------------------------+
//| Uso       | Certisign - Certificadora Digital.                    |
//+-------------------------------------------------------------------+
Static Function A010ChgSX6()
	
	Local oDlg
	Local oLbx
	Local oPanel 
	Local nI     := 0
	Local aSX6   := {}
	
	Private aDadosSX6 := {}
	
	aSX6 := {'MV_XIMPSSL'}
	SX6->( dbSetOrder( 1 ) )
	For nI := 1 To Len( aSX6 )
		If SX6->( dbSeek( xFilial( 'SX6' ) + aSX6[ nI ] ) )
			SX6->( AAdd( aDadosSX6, { X6_VAR, X6_TIPO, X6_CONTEUD, Capital(RTrim(X6_DESCRIC)+' '+RTrim(X6_DESC1)+' '+RTrim(X6_DESC2)) } ) )
		Endif
	Next nI
	
	If Len( aDadosSX6 ) > 0
		ASort( aDadosSX6, , , {|a,b| a[ 1 ] < b[ 1 ] } )
		DEFINE MSDIALOG oDlg TITLE 'Parâmetros Renov. SSL' FROM 0,0 TO 200,800 PIXEL
			oLbx            := TwBrowse():New(0,0,0,0,,{'Parâmetro','Tipo','Conteúdo','Descrição'},,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oLbx:Align      := CONTROL_ALIGN_ALLCLIENT
			oLbx:SetArray( aDadosSX6 )
			oLbx:bLine      := {|| aEval( aDadosSX6[oLbx:nAt],{|z,w| aDadosSX6[oLbx:nAt,w]})}
			oLbx:BlDblClick := {|| A010EdtSX6( @oLbx ) }
			
			oPanel       := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
			oPanel:Align := CONTROL_ALIGN_BOTTOM
		
			@ 04,04 BUTTON "&Editar" SIZE 36,10 OF oPanel PIXEL ACTION A010EdtSX6( @oLbx )
			@ 04,44 BUTTON "&Sair"   SIZE 36,10 OF oPanel PIXEL ACTION oDlg:End()
		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgAlert( 'Parâmetro não localizado.', cCadastro )
	Endif
	
Return


//+-------------------------------------------------------------------+
//| Rotina    | A010EdtSX6 | Autor | David.Santos | Data | 17/10/2016 |
//+-------------------------------------------------------------------+
//| Descricao | Rotina para editar e gravar o conteudo dos            |
//|           | parametros SX6.                                       |
//+-------------------------------------------------------------------+
//| Uso       | Certisign - Certificadora Digital.                    |
//+-------------------------------------------------------------------+
Static Function A010EdtSX6( oLbx )
	
	Local aPar        := {}
	Local aRet        := {}
	Local cX6_VAR     := aDadosSX6[ oLbx:nAt, 1 ]
	Local cX6_CONTEUD := RTrim( aDadosSX6[ oLbx:nAt, 3 ] )
	
	AAdd( aPar,{ 1, 'Conteúdo do parâmetro',(cX6_CONTEUD + Space( 250 - Len( cX6_CONTEUD ) )),'','','','',120,.F.})
	
	If ParamBox( aPar,'Parâmetros Agenda Certisign', @aRet )
		
		If Upper( cX6_CONTEUD ) <> Upper( RTrim( aRet[ 1 ] ) )
			PutMv( cX6_VAR, aRet[ 1 ] )
			aDadosSX6[ oLbx:nAt, 3 ] := aRet[ 1 ]
			oLbx:Refresh()
			MsgInfo('Parâmetro modificado com sucesso', cCadastro )
		Endif
		
	Endif
	
Return