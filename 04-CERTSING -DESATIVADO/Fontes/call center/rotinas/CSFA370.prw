//-------------------------------------------------------------------------
// Rotina | CSFA370      | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina de importação de renovação de certificados de ICP-Brasil 
//        | para as aéras do SAC e do Vendas Diretas. Executada em JOB.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------

#Include 'Protheus.ch'
#Include 'TbiConn.ch'

User Function CSFA370( aParam )
	Local nI := 0
	Local cEmp := ''
	Local cFil := ''
	Local cArqLog := ''
	Local aMsgIni := {}
	Local aMsgFim := {}

	Private nTimeIni    := Seconds()
	Private nLinha      := 0
	Private nProblem    := 0
	Private nMV370ANTS  := 0
	Private nMV370ANTT  := 0
	Private nMV370LIMS  := 0
	Private nMV370LIMT  := 0

	Private cBarra      := Iif( IsSrvUnix(), '/', '\' )
	Private cMV370PATA  := 'MV_370PATA'
	Private cMV370PATL  := 'MV_370PATL'
	Private cMV370PATP  := 'MV_370PATP'
	Private cMV370EXT   := 'MV_370EXT'
	Private cMV370OPSA  := 'MV_370OPSA'
	Private cMV370OPTL  := 'MV_370OPTL'
	Private cMV370GRPS  := 'MV_370GRPS'
	Private cMV370GRPT  := 'MV_370GRPT'
	Private cSDK_CODASS := 'SDK_CODASS'
	Private cSDK_OCORRE := 'SDK_OCORRE'
	Private cMV370ACAO  := 'MV_370ACAO'
	Private cMV370MAIL  := 'MV_370MAIL'
	Private cMV370SAC   := 'MV_370SAC'
	Private cMV370TLV   := 'MV_370TLV'
	Private cMV370TPVS  := 'MV_370TPVS'
	Private cMV370TPVT  := 'MV_370TPVT'
	
	Private cMV_FKMAIL  := 'MV_FKMAIL'
	
	Private aLogProc    := {}
	Private aLogRecord  := {}
	
	// Se a execução for via JOB.
	If IsBlind()
		cEmp := Iif( aParam == NIL, '01', aParam[ 1 ] )
		cFil := Iif( aParam == NIL, '02', aParam[ 2 ] )
	Else 
		// Se a execução não for via JOB.
		cEmp := '01'
		cFil := '02'
	Endif
	
	AAdd( aMsgIni, 'HPROCESSO: IMPORTAR DADOS DE RENOV. DE CERT. ICP-BRASIL SAC/TLV' )
	AAdd( aMsgIni, 'HROTINA..: CSFA370 - VIA JOB - LOG DE PROCESSAMENTO' )
	AAdd( aMsgIni, 'HDATA....: ' + Dtoc( MsDate() ) )
	AAdd( aMsgIni, 'HINICIO..: ' + Time() )

	// Montar o LOG inicial independente do funcionamento da rotina.
	For nI := 1 To Len( aMsgIni )
		A370Log( 0, aMsgIni[ nI ] )
	Next nI

	// Informar ao Server Protheus que a RPC não consumirá licença.
	RpcSetType( 3 )

	// Preparar o ambiente.
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'TMK' TABLES 'AC8','SX5','SX6','SU7','SU0','SUS','SU5','ADE','ADF','SZX','SU4','SU6'
		// Executar a função se a rotina pode ser usada. Criticar parâmetros, tabelas, campos e indíces.
		If A370PodeUsar()
			// Executar o processamento do arquivo de dados CSV.
			A370HasFile()
		Endif
		// Converter variável de LOG em arquivo CSV para posterior análise.
		cArqLog := A370ConvLog()
		// Enviar e-mail do processamento da rotina, independente do seu funcionamento ter sido com sucesso.
		A370EMail( cArqLog )
	// Desfazer o ambiente preparado.
	RESET ENVIRONMENT
Return
//-------------------------------------------------------------------------
// Rotina | A370HasFile  | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Verificar se existe arquivo para ser processado.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370HasFile()
	Local aFile := {}
	Local cArq := ''
	Local cSystem := ''
	Local cTime := ''
	// Diretório onde será processado o arquivo.
	cSystem := GetSrvProfString( 'Startpath', '' )
	// Buscar o arquivo com a seguinte extensão no diretório indicado.
	aFile := Directory( cMV370PATA + cMV370EXT )
	// Verificar se encontrou algum arquivo.
	If Len( aFile ) > 0
		// Se houver mais de um arquivo, processar somente o primeiro, que na ordem é o mais antigo.
		If Len( aFile ) > 1
			// Converter a data em string.
			AEval( aFile, {|p| p[3] := Dtos( p[3] ) } )
			// Indexar o arquivo por data + hora, caso exista mais de um arquivo capturar somente o último.
			ASort( aFile,,, {|a,b| a[3]+a[4] > b[3]+b[4] } )
		Endif
		// Copiar para o system o arquivo a ser processado.
		__CopyFile( cMV370PATA + aFile[ 1, 1 ], cSystem + aFile[ 1, 1 ] )
		Sleep( 500 )
		// Verificar se copiou.
		If File( aFile[ 1, 1 ] )
			// Processar o arquivo.
			A370Proc( aFile[ 1, 1 ] )
			// Montar o novo nome do arquivo.
			cTime := StrTran( Time(), ':', '' )
			cArq := cMV370PATP + cBarra + SubStr( aFile[ 1, 1 ], 1, At( '.', aFile[ 1, 1 ] )-1 ) + '_' + Dtos( MsDate() ) + '_' + cTime + SubStr( cMV370EXT, 2 )
			// Copiar o arquivo para a pasta de processados.
			__CopyFile( aFile[ 1, 1 ], cArq )
			Sleep( 500 )
			// Apagar o arquivo do system.
			FErase( aFile[ 1, 1 ] )
			Sleep( 500 )
			// Se não apagou, registrar no log.
			If File( aFile[ 1, 1 ] )
				nProblem++
				A370Log( 0, 'Arquivo '+aFile[ 1, 1 ]+' processado não foi movido para a pasta ' + cMV370PATP + ', verificar.' )
			Else
				// Se apagou, registrar no log.
				A370Log( 0, 'Arquivo '+aFile[ 1, 1 ]+' processado foi movido para a pasta ' + cMV370PATP + ' com sucesso.' )
			Endif
			// Apagar o arquivo onde foi armazenado pelo sistema legado.
			FErase( cMV370PATA + aFile[ 1, 1 ] )
			Sleep( 500 )
			// Se não conseguiu apagar o arquivo, registrar no log.
			If File( cMV370PATA + aFile[ 1, 1 ] )
				nProblem++
				A370Log( 0, 'Arquivo '+aFile[ 1, 1 ]+' processado não foi apagado da pasta ' + cMV370PATA + ', verificar.' )
			Else
				// Conseguiu apagar o arquivo, registrar no log.
				A370Log( 0, 'Arquivo '+aFile[ 1, 1 ]+' processado foi apagado da pasta ' + cMV370PATA + ' com sucesso.' )
			Endif
		Else
			nProblem++
			// Registrar no log que não conseguiu copiar o arquivo.
			A370Log( 0, 'Não foi possível copiar o arquivo ' + aFile[ 1, 1 ] + ' da origem ' + cMV370PATA + ' para o destino ' + cSystem + '.' )
		Endif
	Else
		nProblem++
		// Se não encontrou arquivo gerar log.
		A370Log( 0, 'Não foi localizado nenhum arquivo de dados para ser processado.' )
	Endif
Return
//-------------------------------------------------------------------------
// Rotina | A370ConvLog | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Converter a variável de LOG em arquivo de LOG.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370ConvLog()
	Local nI := 0
	Local nJ := 0
	Local nHdl := 0
	Local cDado := ''
	Local cArq := cMV370PATL + cBarra + CriaTrab(,.F.) + '.log'
	Local cArqLogRec := ''
	
	// Criar um elemento vazio na posição determinada.
	AAdd( aLogProc, NIL )
	AIns( aLogProc, 5 )
	// Criar uma dimensão no elemento.
	aLogProc[ 5 ] := Array( 2 )
	// Atribuir os valores.
	aLogProc[ 5, 1 ] := '0'
	aLogProc[ 5, 2 ] := 'HFIM.....: ' + Time()
	// Criar um elemento vazio na posição determinada.
	AAdd( aLogProc, NIL )
	AIns( aLogProc, 6 )
	// Criar uma dimensão no elemento.
	aLogProc[ 6 ] := Array( 2 )
	// Atribuir os valores.
	aLogProc[ 6, 1 ] := '0'
	aLogProc[ 6, 2 ] := 'HTEMPO...: ' + SecsToTime( Seconds() - nTimeIni )
	// Criar um elemento vazio na posição determinada.
	AAdd( aLogProc, NIL )
	AIns( aLogProc, 7 )
	// Criar uma dimensão no elemento.
	aLogProc[ 7 ] := Array( 2 )
	// Atribuir os valores.
	aLogProc[ 7, 1 ] := '0'
	aLogProc[ 7, 2 ] := 'HQTD.REG.: ' + LTrim( Str( nLinha, 0 ) )
	// Criar uma dimensão no elemento.
	aLogProc[ 8 ] := Array( 2 )
	// Atribuir os valores.
	aLogProc[ 8, 1 ] := '0'
	aLogProc[ 8, 2 ] := 'HPROBLEMA: ' + LTrim( Str( nProblem, 0 ) )
	// Criar o arquivo de log.
	nHdl := FCreate( cArq )
	// Descarregar o arquivo de log no arquivo de log.
	For nI := 1 To Len( aLogProc )
		// Se for H de Header.
		If Left( aLogProc[ nI, 2 ], 1 ) == 'H'
			cDado := 'Header    ' + ';' + SubStr( aLogProc[ nI, 2 ], 2 )
		Else
			cDado := 'Linha:    ' + aLogProc[ nI, 1 ] + ';' + aLogProc[ nI, 2 ]
		Endif
		FWrite( nHdl, cDado + CRLF )
	Next nI
	// Fechar o arquivo de log.
	FClose( nHdl )
	// Verificar se há dados no vetor de gravação de dados.
	If Len( aLogRecord ) > 0
		// Elaborar a nomenclatura do arquivo.
		cArqLogRec := cMV370PATL + cBarra + 'logupd' + Dtos( MsDate() ) + StrTran( Time(), ':', '' ) + '.log'
		// Criar o arquivo Handle.
		cDado := ''
		nHdl := 0
		nHdl := FCreate( cArqLogRec )
		// Ler todos os elementos do vetor.
		For nI := 1 To Len( aLogRecord )
			// Ler as colunas do vetor.
			For nJ := 1 To Len( aLogRecord[ nI ] )
				// Capturar os dados de cada coluna do elemento.
				cDado += PadR( aLogRecord[ nI, nJ ], 11, ' ' ) + ';'
			Next nJ
			// Tirar o ponto-e-vírgula e adicionar a quebra de linha.
			cDado := SubStr( cDado, 1, Len( cDado )-1 ) + CRLF
			// Gravar o dado no arquivo texto.
			FWrite( nHdl, cDado )
			cDado := ''
		Next nI
		// Fechar o arquivo.
		FClose( nHdl )
	Endif
Return( cArq )
//-------------------------------------------------------------------------
// Rotina | A370Email    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina de envio de e-mail no final do processamento.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370Email( cArqLog )
	Local nI := 0
	Local cHTML := ''
	Local nP := At( ':', aLogProc[ 3, 2 ] ) + 2

	cHTML := '<html>'
	cHTML += '	<head>'
	cHTML += '		<title>Editor HTML Online</title>'
	cHTML += '	</head>'
	cHTML += '	<body>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<sup><u><span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;">Log de processamento</span></span></u></sup></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;">Importa&ccedil;&atilde;o de dados de renova&ccedil;&atilde;o de certigicados ICP-Brasil.</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;">Verifique o arquivo de log de processamento em anexo.</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;">Abaixo os dados de resumo com o resultado do processamento.</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			&nbsp;</div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:11px;"><span style="font-family:courier new,courier,monospace;">&nbsp; &nbsp; &nbsp; Processo : Import. dados renov. de certif. ICP-Brasil SAC/TLV</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:11px;"><span style="font-family:courier new,courier,monospace;">&nbsp; &nbsp; &nbsp; &nbsp; Rotina : CSFA370 - Via JOB</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:11px;"><span style="font-family:courier new,courier,monospace;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Data : ' + SubStr( aLogProc[ 3, 2 ], nP ) + '</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:11px;"><span style="font-family:courier new,courier,monospace;">&nbsp; &nbsp; &nbsp; &nbsp; In&iacute;cio : ' + SubStr( aLogProc[ 4, 2 ], nP ) + '</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:11px;"><span style="font-family:courier new,courier,monospace;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Fim : ' + SubStr( aLogProc[ 5, 2 ], nP ) + '</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:11px;"><span style="font-family:courier new,courier,monospace;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Tempo : ' + SubStr( aLogProc[ 6, 2 ], nP ) + '</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:11px;"><span style="font-family:courier new,courier,monospace;">&nbsp;Qt.Regidstros : ' + SubStr( aLogProc[ 7, 2 ], nP ) + '</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:11px;"><span style="font-family:courier new,courier,monospace;">&nbsp; Qt.Problemas : ' + SubStr( aLogProc[ 8, 2 ], nP ) + '</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			&nbsp;</div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;">N&atilde;o responde este e-mail.</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			&nbsp;</div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;">CERTISIGN Certificadora Digital S.A.</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			<span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;">Sistemas Corporativos - Protheus</span></span></div>'
	cHTML += '		<div style="text-align: left;">'
	cHTML += '			&nbsp;</div>'
	cHTML += '	</body>'
	cHTML += '</html>'

	If .NOT. Empty( cMV_FKMAIL )
		cMV370MAIL := cMV_FKMAIL
	Endif
	
	MailFormatText( .T. )
	
	If .NOT. FSSendMail( cMV370MAIL, 'LOG - IMPORT ICP-BRASIL - CSFA370', cHTML , cArqLog )
		nProblem++
		A370Log( 0, 'Não foi possível enviar e-mail com o arquivo de LOG conforme e-mail registrado no parâmetro: ' + cMV370MAIL )
	Else
		A370Log( 0, 'E-mail enviado com sucesso conforme endereço registrado no parâmetro MV_370MAIL: ' + cMV370MAIL )
	Endif
	
	MailFormatText( .F. )
Return
//-------------------------------------------------------------------------
// Rotina | A370Proc     | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina de processamento do arquivo de dados.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370Proc( cArquivo )
   Local cArqDados := ''
   Local cHeader := ''
   Local cDados := ''
   Local cB1_COD := ''
   Local cDDD := ''
   Local cTEL := ''
   Local nI := 0
   Local nElem := 0
   Local nQtoDiaFalta := 0
   Local nSacWeek := 0
   Local nTlvWeek := 0
   Local dSacAgenda := Ctod('')
   Local dTlvAgenda := Ctod('')
   Local aHeader := {}
   Local aLinha := {}
   Local lSAC := .F.
   Local lTLV := .F.

   Private aDADOS := {}
   Private aARRAY := {}
	Private aDDD_EST := {}
	
	// abaixo tem 25 campos.
	Private nCD_PEDIDO              := 0
	Private nIC_RENOVACAO           := 0
	Private nNM_CLIENTE             := 0
	Private nDS_RAZAO_SOCIAL        := 0
	Private nDS_EMAIL               := 0
	Private nNR_TELEFONE            := 0
	Private nDS_MUNICIPIO           := 0
	Private nDS_UF                  := 0
	Private nDT_EMISSAO             := 0
	Private nDT_EXPIRACAO           := 0
	Private nQT_DURACAO_CERTIFICADO := 0
	Private nDS_CERTIFICADO         := 0
	Private nCL_CERTIFICADO         := 0
	Private nCL_PESSOA              := 0
	Private nDS_AR                  := 0
	Private nDS_PRODUTO             := 0
	Private nNM_AC                  := 0
	Private nCD_CPF                 := 0
	Private nCD_CNPJ                := 0
	Private nCD_PRODUTO             := 0
	Private nVL_PRECO               := 0
	Private nCD_USUARIO             := 0
	Private nDS_CARGO               := 0
	Private nNR_CEI                 := 0
	Private nCD_VOUCHER_ERP         := 0
	
	// acima tem 25 campos.
	Private nSacAgenda    := 26
	Private nTlvAgenda    := 27
	Private nU5_DDD       := 28
	Private nU5_FONE1     := 29
	Private nB1_COD       := 30
	Private nSAC          := 31
	Private nTLV          := 32
	Private nU5_CODCONT   := 33
	Private nMV370OPSA    := 34
	Private nMV370OPTL    := 35
	Private nNumLinha     := 36
	Private nKeySZX       := 37
	Private nMV370GRPS    := 38
	Private nMV370GRPP    := 39
	Private nMaisCedo     := 40
	Private nTIPO_VOUCHER := 41
	
	// Compatibilizar o nome do arquivo.
	cArqDados := cArquivo
	// Carregar os dados de DDD e UF.
	A370DddUf()
	// Abrir o arquivo.
	FT_FUSE( cArqDados )
	// Posicionar na primeira linha.
	FT_FGOTOP()
	// Capturar a primeira linha, espera-se que seja o header do arquivo.
	cHeader := U_A370LeLin()
	// Contador de linhas.
	nLinha++
	// Ir par ao próxima linha do arquivo.
	FT_FSKIP()
	// Montar o vetor aHeader.
	aHeader := A370Array( cHeader )
	// Capturar a posição das colunas.
	nCD_PEDIDO              := AScan( aHeader, 'CD_PEDIDO' )
	nIC_RENOVACAO           := AScan( aHeader, 'IC_RENOVACAO' )
	nNM_CLIENTE             := AScan( aHeader, 'NM_CLIENTE' )
	nDS_RAZAO_SOCIAL        := AScan( aHeader, 'DS_RAZAO_SOCIAL' )
	nDS_EMAIL               := AScan( aHeader, 'DS_EMAIL' )
	nNR_TELEFONE            := AScan( aHeader, 'NR_TELEFONE' )
	nDS_MUNICIPIO           := AScan( aHeader, 'DS_MUNICIPIO' )
	nDS_UF                  := AScan( aHeader, 'DS_UF' )
	nDT_EMISSAO             := AScan( aHeader, 'DT_EMISSAO' )
	nDT_EXPIRACAO           := AScan( aHeader, 'DT_EXPIRACAO' )
	nQT_DURACAO_CERTIFICADO := AScan( aHeader, 'QT_DURACAO_CERTIFICADO' )
	nDS_CERTIFICADO         := AScan( aHeader, 'DS_CERTIFICADO' )
	nCL_CERTIFICADO         := AScan( aHeader, 'CL_CERTIFICADO' )
	nCL_PESSOA              := AScan( aHeader, 'CL_PESSOA' )
	nDS_AR                  := AScan( aHeader, 'DS_AR' )
	nDS_PRODUTO             := AScan( aHeader, 'DS_PRODUTO' )
	nNM_AC                  := AScan( aHeader, 'NM_AC' )
	nCD_CPF                 := AScan( aHeader, 'CD_CPF' )
	nCD_CNPJ                := AScan( aHeader, 'CD_CNPJ' )
	nCD_PRODUTO             := AScan( aHeader, 'CD_PRODUTO' ) 
	nVL_PRECO               := AScan( aHeader, 'VL_PRECO' )
	nCD_USUARIO             := AScan( aHeader, 'CD_USUARIO' )
	nDS_CARGO               := AScan( aHeader, 'DS_CARGO' )
	nNR_CEI                 := AScan( aHeader, 'NR_CEI' )
	nCD_VOUCHER_ERP         := AScan( aHeader, 'CD_VOUCHER_ERP' )
	
	// Ajustar o número das colunas caso a quantidade de colunas no arquivo seja maior que a esperada no programa.
	If Len( aHeader ) > 25
		nI := Len( aHeader )
		nSacAgenda    := nI + 1
		nTlvAgenda    := nI + 2
		nU5_DDD       := nI + 3
		nU5_FONE1     := nI + 4
		nB1_COD       := nI + 5
		nSAC          := nI + 6
		nTLV          := nI + 7
		nU5_CODCONT   := nI + 8
		nMV370OPSA    := nI + 9
		nMV370OPTL    := nI + 10
		nNumLinha     := nI + 11
		nKeySZX       := nI + 12
		nMV370GRPS    := nI + 13
		nMV370GRPT    := nI + 14
		nMaisCedo     := nI + 15
		nTIPO_VOUCHER := nI + 16
   Endif
	
	// Le o arquivo até sua última linha de dados.
	While .NOT. FT_FEOF()
		// Captura a linha de dados.
		cDados := U_A370LeLin()
		
		// Contatdor de linhas do arquivo de dados.
		nLinha++
		
		// Monta o vetor conforme os dados na linha.
		aLinha := A370Array( cDados )
		
		// Fazer critica caso o certificado tenha sido explirado.
		If Ctod( aLinha[ nDT_EXPIRACAO ] ) <= MsDate()
			nProblem++
			A370Log( nLinha, 'Não será importado o registro, o certificado expirou. Data de expiração [' + aLinha[ nDT_EXPIRACAO ] + '].' )
			FT_FSKIP()
			Loop
		Endif
		
		// Se .T. não fazer nada para o SAC, pois o certificado é menor que a data limite.
		lSAC := ( Ctod( aLinha[ nDT_EXPIRACAO ] ) - MsDate() ) < nMV370LIMS
		
		// Se .T. não fazer nada para o TLV, pois o certificado é menor que a data limite.
		lTLV := ( Ctod( aLinha[ nDT_EXPIRACAO ] ) - MsDate() ) < nMV370LIMT
		
		// Se verdadeiro, não fazer nada para o SAC e TLV
		If lSAC .And. lTLV
			nProblem++
			A370Log( nLinha, 'Não será importado o registro, a data que expira o certificado é menor que a data limite para agenda do SAC e Vendas Diretas.' )
			FT_FSKIP()
			Loop
		Else
			If lSAC
				nProblem++
				A370Log( nLinha, 'Não será importado o registro, a data que expira o certificado é menor que a data limite para agenda do SAC.' )
			Endif
			If lTLV
				nProblem++
				A370Log( nLinha, 'Não será importado o registro, a data que expira o certificado é menor que a data limite para agenda do Vendas Diretas.' )
			Endif
		Endif
		
		// Se o registro não foi rejeitado.
		If .NOT. lSAC
			// Se .T. não fazer nada para o SAC, pois o registro já foi importado.
			lSAC := A370PedGAR( aLinha[ nCD_PEDIDO ] )
			If lSAC
				nProblem++
				A370Log( nLinha, 'Registro já processado para o SAC.' )
			Endif			
		Endif
		
		// Se o registro não foi registrado.
		If .NOT. lTLV
			// Se .T. não fazer nada para o TLV, pois o registro já foi importado.
			lTLV := A370SZX( aLinha[ nCD_PEDIDO ] )
			If lTLV
				nProblem++
				A370Log( nLinha, 'Registro já processado para Vendas Diretas.' )
			Endif
		Endif
		
		// Se verdadeiro, não fazer nada para o SAC e TLV
		If lSAC .And. lTLV
			nProblem++
			A370Log( nLinha, 'Registro já processado para áreas SAC e Vendas Diretas.' )
			FT_FSKIP()
			Loop
		Endif
		
		// Transformar em números o CPF.
		aLinha[ nCD_CPF ] := A370SoNum( aLinha[ nCD_CPF ] )
		
		// Validar o CPF.
		If .NOT. A370CNPJ( aLinha[ nCD_CPF ] )
			nProblem++
			A370Log( nLinha, 'Não será importado o registro, CPF com dígito inválido.' )
			FT_FSKIP()
			Loop
		Endif
		
		// Transformar em números o CNPJ.
		aLinha[ nCD_CNPJ ] := A370SoNum( aLinha[ nCD_CNPJ ] )
		
		// Validar o CNPJ.
		If .NOT. A370CNPJ( aLinha[ nCD_CNPJ ] )
			nProblem++
			A370Log( nLinha, 'Não será importado o registro, CNPJ com dígido inválido.' )
			FT_FSKIP()
			Loop
		Endif
		
		// Buscar o código do produto.
		cB1_COD := A370Produto( AllTrim( aLinha[ nCD_PRODUTO ] ) )
		If Empty( cB1_COD )
			nProblem++
			A370Log( nLinha, 'Código de produto não localizado na relação de proutos GAR x Protheus (PA8): ' + AllTrim( aLinha[ nCD_PRODUTO ] ) + '.')
			FT_FSKIP()
			Loop
		Endif
		
		// Converter as datas do registro CSV de caractere para string.
		aLinha[ nDT_EMISSAO ] := Dtos( Ctod( aLinha[ nDT_EMISSAO ] ) )
		aLinha[ nDT_EXPIRACAO ] := Dtos( Ctod( aLinha[ nDT_EXPIRACAO ] ) )
		
		// Calcular a data de antecedência da data de expirar SAC e TLV.
		nQtoDiaFalta := Stod( aLinha[ nDT_EXPIRACAO ] ) - MsDate()
		
		// A quantidade de dias é maior que a quantidade de dias com antecedência?
		If nQtoDiaFalta > nMV370ANTS
			// Calcular Hoje + ( quantidade_de_dias - quantidade_dias_com_antecedencia.
			dSacAgenda := MsDate() + ( nQtoDiaFalta - nMV370ANTS )
		Else
			dSacAgenda := MsDate() + 1
		Endif

		// Considerar sexta-feira caso a data da agenda seja no sábado ou domingo.
		nSacWeek := Dow( dSacAgenda )
		If nSacWeek == 1
			dSacAgenda := dSacAgenda - 2
		Elseif nSacWeek == 7
			dSacAgenda := dSacAgenda - 1
		Endif
		
		// Calcular a data da agenda para o Televendas.
		If nQtoDiaFalta > nMV370ANTT
			dTlvAgenda := MsDate() + ( nQtoDiaFalta - nMV370ANTT )
		Else
			dTlvAgenda := MsDate() + 1
		Endif

		// Considerar sexta-feira caso a data da agenda seja no sábado ou domingo.
		nTlvWeek := Dow( dTlvAgenda )
		If nTlvWeek == 1
			dTlvAgenda := dTlvAgenda - 2
		Elseif nTlvWeek == 7
			dTlvAgenda := dTlvAgenda - 1
		Endif
		
		// Tranformar em minusculo o e-mail.
		aLinha[ nDS_EMAIL ] := Lower( AllTrim( aLinha[ nDS_EMAIL ] ) )

		// Transformar em números o telefone.
		aLinha[ nNR_TELEFONE ] := A370SoNum( aLinha[ nNR_TELEFONE ] )

		// Capturar somente o DDD.
		cDDD := Left( aLinha[ nNR_TELEFONE ], 2 )

		// Capturar somente o telefone.
		cTEL := SubStr( aLinha[ nNR_TELEFONE ], 3 )

		// Buscar UF com o DDD.
		If Empty( aLinha[ nDS_UF ] ) .And. .NOT. Empty( cDDD )
			// Pesquisar com o DDD, na coluna 1 (DDD) e retornar o valor da coluna 2 (UF).
			aLinha[ nDS_UF ] := A370UF( cDDD, 1, 2 )
		Endif

		// Buscar o DDD com o UF.
		If .NOT. Empty( aLinha[ nDS_UF ] ) .And. Empty( cDDD )
			// Pesquisar com o UF, na coluna 2 (UF) e retornar o valor da coluna 1 (DDD).
			cDDD := A370UF( aLinha[ nDS_UF ], 2, 1 )
		Endif

		// Tirar possíveis acentos, espaços em branco e deixar tudo em maiúsculo.
		aLinha[ nNM_CLIENTE ]      := Upper( NoAcento( AnsiToOem( AllTrim( aLinha[ nNM_CLIENTE ] ) ) ) )
		aLinha[ nDS_RAZAO_SOCIAL ] := Upper( NoAcento( AnsiToOem( AllTrim( aLinha[ nDS_RAZAO_SOCIAL ] ) ) ) )
		aLinha[ nDS_MUNICIPIO ]    := Upper( NoAcento( AnsiToOem( AllTrim( aLinha[ nDS_MUNICIPIO ] ) ) ) )

		//--------------------------------------
		// Gerar vetor para processamento final.
		//--------------------------------------
		// data da agenda SAC.
		// data da agenda TLV.
		// DDD.
		// TEL.
		// B1_COD.
		// lSAC -> Se .F. importar dados para o SAC.
		// lTLV -> Se .F. importar dados para o TLV.
		// U5_CODCONT.
		// OPERADOR DO SAC.
		// OPERADOR DO TLV.
		// Número da linha do CSV.
		// Chave para ordenar o vetor para o TLV
		// Grupo de atendimento do SAC
		// Grupo de atendimento do TLV
		// Data mais cedo que vence o certificado quando houver voucher (lote).
		AAdd( aDADOS, Array( Len( aLinha ) + 16 ) )
		nElem := Len( aDADOS )
		For nI := 1 To Len( aLinha )
			aDADOS[ nElem, nI ] := aLinha[ nI ]
		Next nI

		// Inserir os dados adicionais.
		aDADOS[ nElem, nSacAgenda ]     := Dtos( dSacAgenda )
		aDADOS[ nElem, nTlvAgenda ]     := Dtos( dTlvAgenda )
		aDADOS[ nElem, nU5_DDD ]        := cDDD
		aDADOS[ nElem, nU5_FONE1 ]      := cTEL
		aDADOS[ nElem, nB1_COD ]        := cB1_COD
		aDADOS[ nElem, nSAC ]           := lSAC
		aDADOS[ nElem, nTLV ]           := lTLV
		aDADOS[ nElem, nU5_CODCONT ]    := ''
		aDADOS[ nElem, nMV370OPSA ]     := cMV370OPSA
		aDADOS[ nElem, nMV370OPTL ]     := cMV370OPTL
		aDADOS[ nElem, nNumLinha ]      := nLinha
		aDADOS[ nElem, nKeySZX ]        := aLinha[ nCD_CPF ] + cMV370OPTL + Dtos( dTlvAgenda ) // CPF do contato + Código do operador + Data da agenda calculada.
		aDADOS[ nElem, nMV370GRPS ]     := cMV370GRPS
		aDADOS[ nElem, nMV370GRPT ]     := cMV370GRPT
		aDADOS[ nElem, nMaisCedo ]      := ''
		
		// Se houver voucher, verificar qual é o seu tipo.
		If .NOT. Empty( aLinha[ nCD_VOUCHER_ERP ] )
			aDADOS[ nElem, nTIPO_VOUCHER ]  := A370TpVoucher( aLinha[ nCD_VOUCHER_ERP ] )
		Endif

		// Limpar a variável registro do CSV.
		aLinha := {}
		cDDD   := ''
		cTEL   := ''
		lSAC   := .F.
		lTLV   := .F.
		
		// Ir para o próxima linha de dados.
		FT_FSKIP()
	End
	
	// Fechar o arquivo de dados.
	FT_FUSE()
	If Len( aDADOS ) > 0
		Begin Transaction
			// Processar dados para o SAC.
			A370GrvSAC()
			// Processar dados para gerar o Televendas?
			If cMV370TLV == 'S' .And. Len( aARRAY ) > 0
				A370GrvTLV()
			Endif
		End Transaction
	Endif
Return

//-------------------------------------------------------------------------
// Rotina | A370TpVoucher | Autor | Robson Goncalves      Data | 11.09.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para verificar o tipo de voucher.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370TpVoucher( cVOUCHER )
	Local cRet := ''
	SZF->( dbSetOrder( 2 ) )
	If SZF->( dbSeek( xFilial( 'SZF' ) + cVOUCHER ) )
		cRet := SZF->ZF_TIPOVOU
	Endif
Return( cRet )

//-------------------------------------------------------------------------
// Rotina | A370GrvSAC   | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para gravar os dados do prospect, contato, relacionar
//        | um com o outro e executar a gravação do chamado.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370GrvSAC()
	Local nI := 0
	Local lSU5 := .T.
	Local lAppendSU5 := .T.
	Local lAppendSUS := .T.
	Local lAppendAC8 := .T.
	Local nSaveSX8 := 0
	Local cU5_CODCONT := ''
	Private cUS_COD := ''
	Private cUS_LOJA := ''
	Private cADF_OBS := 'Abertura de atendimento por Importação de Mailing - Renovação de certificado ICP-Brasil.'
	// Retorna a quantidade de números reservados que estão na pilha.
	nSaveSX8 := GetSX8Len()
	// Indexar o vetor por ondem de data da agenda para o SAC.
	ASort( aDADOS,,,{|a,b| a[ nSacAgenda ] < b[ nSacAgenda ] } )
	// Ler todos os elementos do vetor.
	For nI := 1 To Len( aDADOS )
		//-------------------
		// Gravar o prospect.
		//-------------------
		SUS->( dbSetOrder( 4 ) )
		If SUS->( dbSeek( xFilial( xFilial( 'SUS' ) + aDADOS[ nI, nCD_CNPJ ] ) ) )
			cUS_COD  := SUS->US_COD
			cUS_LOJA := SUS->US_LOJA
			lAppendSUS := .F.
		Else
			cUS_COD  := A370GetNum('SUS','US_COD')
			cUS_LOJA := '01'
			lAppendSUS := .T.
		Endif
		SUS->( RecLock( 'SUS', lAppendSUS ) )
		If lAppendSUS
			SUS->US_FILIAL := xFilial( 'SUS' )
			SUS->US_COD    := cUS_COD
			SUS->US_LOJA   := cUS_LOJA
			SUS->US_TIPO   := 'F'
			SUS->US_STATUS := '1'
			SUS->US_ORIGEM := '1'
			SUS->US_DATAIMP := MsDate()
		Endif
		SUS->US_NOME  := aDADOS[ nI, nDS_RAZAO_SOCIAL ]
		SUS->US_MUN   := aDADOS[ nI, nDS_MUNICIPIO ]
		SUS->US_EST   := aDADOS[ nI, nDS_UF ]
		SUS->US_DDD   := aDADOS[ nI, nU5_DDD ]
		SUS->US_TEL   := aDADOS[ nI, nU5_FONE1 ]
		SUS->US_EMAIL := aDADOS[ nI, nDS_EMAIL ]
		SUS->US_PESSO := SubStr( aDADOS[ nI, nCL_PESSOA ], 2, 1 )
		SUS->US_CGC   := aDADOS[ nI, nCD_CNPJ ]
		SUS->( MsUnLock() )
		A370LogRecord( 'A370GrvSAC', 'SUS', lAppendSUS, SUS->( RecNo() ) )
		// Caso seja registro novo.
		If lAppendSUS
			// Efetiva a gravação do registro reservado.
			While ( GetSx8Len() > nSaveSX8 )
				ConfirmSX8()
			End
		Endif		
		//------------------
		// Gravar o contato.
		//------------------
		// Pesquisar por CPF.
		SU5->( dbSetOrder( 8 ) )
		lSU5 := SU5->( dbSeek( xFilial( 'SU5' ) + aDADOS[ nI, nCD_CPF ] ) )
		// Caso não encontre, pesquisar por e-mail.		
		If .NOT. lSU5
			SU5->( dbSetOrder( 9 ) )
			lSU5 := SU5->( dbSeek( xFilial( 'SU5' ) + aDADOS[ nI, nDS_EMAIL ] ) )
		Endif
		// Se encontrar o contato capturar o código, do contrário criar um código novo.
		If lSU5
			cU5_CODCONT := SU5->U5_CODCONT
			lAppendSU5 := .F.
		Else
			cU5_CODCONT := A370GetNum('SU5','U5_CODCONT')
			lAppendSU5 := .T.
		Endif
		// Gravar/atualizar os dados do contato.
		SU5->( RecLock('SU5', lAppendSU5 ) )
		If lAppendSU5
			SU5->U5_FILIAL  := xFilial( 'SU5' )
			SU5->U5_CODCONT := cU5_CODCONT
			SU5->U5_DTIMPO  := MsDate()
			SU5->U5_STATUS  := '2'
			SU5->U5_ATIVO   := '1'
		Endif
		SU5->U5_CONTAT:= aDADOS[ nI, nNM_CLIENTE ]
		SU5->U5_CPF   := aDADOS[ nI, nCD_CPF ] 
		SU5->U5_EMAIL := aDADOS[ nI, nDS_EMAIL ]
		SU5->U5_DDD   := aDADOS[ nI, nU5_DDD ]
		SU5->U5_FCOM1 := aDADOS[ nI, nU5_FONE1 ]
		SU5->U5_EST   := aDADOS[ nI, nDS_UF ]
		SU5->( MsUnLock() )
		A370LogRecord( 'A370GrvSAC', 'SU5', lAppendSU5, SU5->( RecNo() ) )
		// Caso seja registro novo.
		If lAppendSU5
			// Efetiva a gravação do registro reservado.
			While ( GetSx8Len() > nSaveSX8 )
				ConfirmSX8()
			End
		Endif
		//------------------------------------------------------
		// Gravar o relacionamento entre o prospect e o contato.
		//------------------------------------------------------
		AC8->( dbSetOrder( 1 ) )
		lAC8 := AC8->( dbSeek( xFilial( 'AC8' ) + cU5_CODCONT + 'SUS' + xFilial( 'SUS' ) + PadR( cUS_COD + cUS_LOJA, 25, " " ) ) )
		If lAC8
			If AC8->AC8_ENTIDA == 'SUS' .And. AC8->AC8_CODENT == PadR( cUS_COD + cUS_LOJA, 25, " " ) .And. AC8->AC8_CODCON == cU5_CODCONT
				lAppendAC8 := .F.
			Else
				lAppendAC8 := .T.
			Endif
		Else
			If AC8->AC8_ENTIDA <> 'SUS' .And. AC8->AC8_CODENT <> PadR( cUS_COD + cUS_LOJA, 25, " " ) .And. AC8->AC8_CODCON <> cU5_CODCONT
				lAppendAC8 := .T.
			Else
				lAppendAC8 := .F.
			Endif
		Endif
		If lAppendAC8
			AC8->( RecLock( 'AC8', .T. ) )
			AC8->AC8_FILIAL := xFilial( 'AC8' )
			AC8->AC8_FILENT := xFilial( 'SUS' )
			AC8->AC8_ENTIDA := 'SUS'
			AC8->AC8_CODENT := cUS_COD + cUS_LOJA
			AC8->AC8_CODCON := cU5_CODCONT
			AC8->( MsUnLock() )
		Endif
		
		A370LogRecord( 'A370GrvSAC', 'AC8', lAppendAC8, AC8->( RecNo() ) )
		
		// Armazenar o código do contato para utilizar na entidade SZX.
		aDADOS[ nI, nU5_CODCONT ] := cU5_CODCONT
		
		// Gerar o atendimento no Service-Desk.
		If .NOT. aDADOS[ nI, nSAC ]
			// Se a chave de importação do SAC estiver ligada, gravar o atendimento e a agenda do operador.
			If cMV370SAC == 'S'
				// Se não houver voucher ou se for os vouchers dos parâmetros.
				If Empty( aDADOS[ nI, nCD_VOUCHER_ERP ] ) .OR. ( aDADOS[ nI, nTIPO_VOUCHER ] $ cMV370TPVS )
					A370Atend( nI )
				Endif
			Endif
		Endif
		
		// Processar dados para o Vendas Diretas - Televendas?
		If cMV370TLV == 'S'
			// Se o elemento atual não gerou Televendas, seguir...
			If .NOT. aDADOS[ nI, nTLV ]
				// Se não houver voucher ou se for os vouchers dos parâmetros.
				If aDADOS[ nI, nTIPO_VOUCHER ] $ cMV370TPVT
					AAdd( aARRAY, AClone( aDADOS[ nI ] ) )
				Endif
			Endif
		Endif
	Next nI
Return
//-------------------------------------------------------------------------
// Rotina | A370Atend    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para gravar os dados do chamado para o SAC e logo criar
//        | a agenda do operador relacionado com este chamado.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370Atend( nI )
	Local nLoop := 0
	Local nHandle := 0
	Local cErro := ''
	Local cADE_CODIGO := ''
	Local aErro := {}
	Local aCabec := {}
	Local aLinha := {}
	Local cIncidente := ''
	Local cNomeArq := ''
	Private aCOLS := {}
	Private aHeader := {}
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	// Montar o texto do incidente para o chamado.
	cIncidente := 'Ação: ' + aDADOS[ nI, nIC_RENOVACAO ] + ;
	              ' -- Certificado: ' + aDADOS[ nI, nDS_CERTIFICADO ] + CRLF + ;
	              'Data de Emissão: ' + Dtoc( Stod( aDADOS[ nI, nDT_EMISSAO ] ) ) + ;
	              ' -- Data Expitação: ' + Dtoc( Stod( aDADOS[ nI, nDT_EXPIRACAO ] ) ) + ;
	              ' -- Tempo: ' + aDADOS[ nI, nQT_DURACAO_CERTIFICADO ] + CRLF + ;
	              'AR: ' + aDADOS[ nI, nDS_AR ] + ;
	              ' -- Produto: ' + aDADOS[ nI, nDS_PRODUTO ] + CRLF + ;
	              aDADOS[ nI,nCL_CERTIFICADO ] + ;
	              ' -- ' + aDADOS[ nI, nCL_PESSOA ] + ;
	              'AC: ' + aDADOS[ nI, nNM_AC ] + CRLF
	// Montar o vetor Head.
	aAdd( aCabec, { 'ADE_FILIAL' , xFilial('ADE')           , NIL } )
	aAdd( aCabec, { 'ADE_INCIDE' , cIncidente               , NIL } )
	aAdd( aCabec, { 'ADE_STATUS' , '1'                      , NIL } )
	aAdd( aCabec, { 'ADE_OPERAD' , aDADOS[ nI, nMV370OPSA ] , NIL } )
	aAdd( aCabec, { 'ADE_GRUPO'  , aDADOS[ nI, nMV370GRPS ] , NIL } )
	aAdd( aCabec, { 'ADE_CODCON' , aDADOS[ nI, nU5_CODCONT ], NIL } )
	aAdd( aCabec, { 'ADE_ENTIDA' , 'SUS'                    , NIL } )
	aAdd( aCabec, { 'ADE_HORA'   , Time()                   , NIL } )
	aAdd( aCabec, { 'ADE_DDDRET' , aDADOS[ nI, nU5_DDD ]    , NIL } )
	aAdd( aCabec, { 'ADE_TELRET' , aDADOS[ nI, nU5_FONE1 ]  , NIL } )
	aAdd( aCabec, { 'ADE_SEVCOD' , '2'                      , NIL } )
	aAdd( aCabec, { 'ADE_TIPO'   , '000001'                 , NIL } )
	aAdd( aCabec, { 'ADE_OPERAC' , '2'                      , NIL } )
	aAdd( aCabec, { 'ADE_ASSUNT' , cSDK_CODASS              , NIL } )
	aAdd( aCabec, { 'ADE_CODSB1' , aDADOS[ nI, nB1_COD ]    , NIL } )
	aAdd( aCabec, { 'ADE_CHAVE'  , cUS_COD + cUS_LOJA       , NIL } )	
	aAdd( aCabec, { 'ADE_TO'     , aDADOS[ nI, nDS_EMAIL ]  , NIL } )
	aAdd( aCabec, { 'ADE_XVALID' , aDADOS[ nI, nQT_DURACAO_CERTIFICADO ], NIL } )
	aAdd( aCabec, { 'ADE_XDTEXP' , Stod( aDADOS[ nI, nDT_EXPIRACAO ] )  , NIL } )
	
	// Montar o vetor de item.
	aAdd( alinha, { 'ADF_FILIAL', xFilial('ADF'), NIL } )
	aAdd( aLinha, { 'ADF_ITEM'  , '001'         , NIL } )
	aAdd( aLinha, { 'ADF_CODSU9', cSDK_OCORRE   , NIL } )
	aAdd( aLinha, { 'ADF_CODSUQ', cMV370ACAO    , NIL } )
	aAdd( aLinha, { 'ADF_OBS'   , cADF_OBS      , NIL } )
	aAdd( aLinha, { 'ADF_DATA'  , MsDate()      , NIL } )
	aAdd( aLinha, { 'ADF_HORA'  , ''            , NIL } )
	aAdd( aLinha, { 'ADF_HORAF' , Time()        , NIL } )
	// Montagem do aHeader e do aCOLS para a funçãod o padrão.  
	FillGetDados( 3, 'ADF', NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, .T. )
   // Posicionar as tabelas na ordem 1.
	dbSelectArea('SU5')
	dbSetOrder( 1 )
	dbSelectArea('SUS')
	dbSetOrder( 1 )
	dbSelectArea('AC8')
	dbSetOrder( 1 )
	dbSelectArea('SU7')
	dbSetOrder( 1 )
	dbSelectArea('ADE')
	dbSetOrder(1)
	dbSelectArea('ADF')
	dbSetOrder(1)
	// Executar a função TMKA503A.
	ADE->( MsExecAuto( {|x,y,z| TMKA503A( x, y, z ) }, aCabec, { aLinha }, 3 ) )
	// Verificar se houve problema na geração do chamado.
	If lMsErroAuto
		// Buscar o relato da ocorrência do erro.
		aErro := GetAutoGrLog()
		For nLoop := 1 To Len( aErro )
			cErro += aErro[ nLoop ] + CRLF
		Next nLoop
		nProblem++
		// Gravar o erro no controle de LOG.
		A370Log( aDADOS[ nI, nNumLinha ], 'Erro MsExecAuto: ' + cErro )
	Else
		// Efetiva a gravação do registro reservado.
		ConfirmSX8()
		// Captura a chave do registro.
		cADE_CODIGO := ADE->ADE_CODIGO
		cADE_CHAVE  := ADE->ADE_CHAVE
		// Gravar o campo memo.
	   ADE->( RecLock( 'ADE', .F. ) )
	   ADE->( MSMM(,TamSx3('ADE_INCIDE')[1],,cIncidente,1,,,'ADE','ADE_CODINC' ) )
		ADE->ADE_PEDGAR := aDADOS[ nI, nCD_PEDIDO ]
	   ADE->( MsUnLock() )
		A370LogRecord( 'A370Atend', 'ADE', .T., ADE->( RecNo() ) )
		A370LogRecord( 'A370Atend', 'ADF', .T., ADF->( RecNo() ) )
		// Gerar agenda do operador vinculado com o atendimento.
		A370Agend( nI, cADE_CODIGO, cADE_CHAVE )
	Endif
Return
//-------------------------------------------------------------------------
// Rotina | A370Agend    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para gravar a agenda do operador relacionado com o 
//        | chamado.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370Agend( nI, cADE_CODIGO, cADE_CHAVE )
	Local nSaveSX8 := 0
	Local cU4_LISTA := ''
	// Buscar próximo número para o registro.
	cU4_LISTA := A370GetNum('SU4', 'U4_LISTA')  //GetSXENum( 'SU4', 'U4_LISTA' )
	// Retorna a quantidade de números reservados que estão na pilha.
	nSaveSX8 := GetSX8Len()
	// Gravar o registro.
	SU4->( RecLock( 'SU4', .T. ) )
	SU4->U4_FILIAL  := xFilial( 'SU4' )
	SU4->U4_LISTA   := cU4_LISTA
	SU4->U4_DESC    := 'Data Expiração: ' + aDADOS[ nI, nDT_EXPIRACAO ]
	SU4->U4_DATA    := MsDate() //Stod( aDADOS[ nI, nSacAgenda ] )
	SU4->U4_FORMA   := '5'  		// 1=Voz 2=Fax 3=Cross Posting 4=mala Direta 5=Pendencia 6=WebSite
	SU4->U4_TELE    := '5'
	SU4->U4_OPERAD  := aDADOS[ nI, nMV370OPSA ]
	SU4->U4_TIPOTEL := '4' // 1=Residencial 2=Fax 3=Celular 4=Comercial 1 5=Comercial 2
	SU4->U4_CODLIG  := cADE_CODIGO // Codigo do atendimento
	SU4->U4_STATUS  := '1' // Status da Lista 1=Pendente 2=Encerrada
	SU4->U4_TIPO    := '1' // Tipo da Lista 1=Marketing 2=Vendas 3=Cobranca
	SU4->U4_HORA1   := Time()
	SU4->U4_XDTVENC := Stod( aDADOS[ nI, nDT_EXPIRACAO ] ) - nMV370ANTS
	SU4->U4_XGRUPO  := aDADOS[ nI, nMV370GRPS ]
	SU4->( MsUnlock() )
	A370LogRecord( 'A370Agend', 'SU4', .T., SU4->( RecNo() ) )
	// Efetiva a gravação do registro reservado.
	While ( GetSx8Len() > nSaveSX8 )
		ConfirmSX8()
	End
	// Buscar próximo número para o registro.
	cU6_CODIGO := A370GetNum('SU6', 'U6_CODIGO') //GetSXENum( 'SU6', 'U6_CODIGO' )
	// Retorna a quantidade de números reservados que estão na pilha.
	nSaveSX8 := GetSX8Len()
	// Gravar o registro.
	SU6->( RecLock( 'SU6', .T. ) )
	SU6->U6_FILIAL  := xFilial( 'SU6' )
	SU6->U6_LISTA   := cU4_LISTA
	SU6->U6_CODIGO  := cU6_CODIGO
	SU6->U6_DTBASE  := MsDate()
	SU6->U6_FILENT  := xFilial( 'SUS' )
	SU6->U6_ENTIDA  := 'SUS'
	SU6->U6_CODENT  := cADE_CHAVE
	SU6->U6_ORIGEM  := '3' // 1=Lista 2=Manual 3=Atendimento
	SU6->U6_CONTATO := aDADOS[ nI, nU5_CODCONT ]
	SU6->U6_DATA    := MsDate() //Stod( aDADOS[ nI, nSacAgenda ] )
	SU6->U6_HRINI   := '06:00'
	SU6->U6_HRFIM   := '23:59'
	SU6->U6_STATUS  := '1' // 1=Nao Enviado 2=Enviado
	SU6->U6_CODLIG  := cADE_CODIGO
	SU6->( MsUnlock() )
	A370LogRecord( 'A370Agend', 'SU6', .T., SU6->( RecNo() ) )
	// Efetiva a gravação do registro reservado.
	While ( GetSx8Len() > nSaveSX8 )
		ConfirmSX8()
	End
Return
//-------------------------------------------------------------------------
// Rotina | A370GrvTLV   | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para gravar os dados da entidade ICP-Brasil relacionar
//        | com o contato e gerar a agenda do operador.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370GrvTLV()
	Local nI := 0
	Local nElemDe := 0
	Local nSaveSX8 := 0
	Local nZX_RECNO := 0
	Local cKey := ''
	Local cMaisCedo := ''
	Local cZX_CODIGO := ''
	Local cU4_LISTA := ''
	Local cU6_CODIGO := ''
	Local cZX_CONSULT := Posicione( 'SU7', 1, xFilial( 'SU7' ) + cMV370OPTL, 'U7_CODVEN' )
	Local cZX_ORIGEM := 'REG.IMP. ' + Dtoc( MsDate() ) + '-' + Left(Time(),5) + ' Via JOB - CSFA370.'
	Local cZX_INPUT := MsDate()
	// Indexar o vetor por ondem de CPF DO CONTATO + CODIGO DO OPERADOR + DATA DA AGENDA CALCULADA.
	ASort( aARRAY,,,{|a,b| a[ nKeySZX ] < b[ nKeySZX ] } )
	// Processar o vetor para identificar a data de expiração mais cedo do lote de certificados para o mesmo contato.
	// O objetivo é gerar várias agendas todas para o mesmo dia, assim o operador faz uma ligação e trata da renovação de todos os certificados.
	For nI := 1 To Len( aARRAY )
		// A chave atual do vetor é diferente da chave armazenada?
		If cKey <> aARRAY[ nI, nCD_CPF ] + aARRAY[ nI, nMV370OPTL ]
			// Se há chave e existe elemento e não há data.
			If .NOT. Empty( cKey ) .And. nElemDe > 0 .And. .NOT. Empty( cMaisCedo )
				// Colocar a mesma data para todos.
				AEval( aARRAY, {|p| p[ nMaisCedo ] := cMaisCedo }, nElemDe, ( nI - nElemDe ) )
			Endif
			// Atualizar a chave.
			cKey := aARRAY[ nI, nCD_CPF ] + aARRAY[ nI, nMV370OPTL ]
			// Atualizar o controle de números de elementos.
			nElemDe := nI
			// Capturar a data calculada anteriormente.
			cMaisCedo := aARRAY[ nI, nTlvAgenda ]
		Endif
		// Se a data da agenda calculada for menor que a data mais cedo, considerar a data da agenda calculada.
		If aARRAY[ nI, nTlvAgenda ] < cMaisCedo 
			cMaisCedo := aARRAY[ nI, nTlvAgenda ]
		Endif
		// Se não houver data, inserir.
		If Empty( aARRAY[ nI, nMaisCedo ] )
			aARRAY[ nI, nMaisCedo ] := aARRAY[ nI, nTlvAgenda ]
		Endif
	Next nI
	// Retorna a quantidade de números reservados que estão na pilha.
	nSaveSX8 := GetSX8Len()	
	// Processar o vetor para gerar a entidade, seu relacionamento com o contato e a agenda do operador.
	For nI := 1 To Len( aARRAY )
		// Verificar se o pedido GAR já foi processado para esta entidade, relacionamento e agenda do operador.
		SZX->( dbSetOrder( 4 ) )
		If .NOT. SZX->( dbSeek( aARRAY[ nI, nCD_PEDIDO ] ) )
			// Verificar já existe a entidade ICP-Brasil (SZX).
			cZX_CODIGO := A370GetNum('SZX', 'ZX_CODIGO') //GetSXENum( 'SZX', 'ZX_CODIGO' )
			SZX->( RecLock( 'SZX', .T. ) )
			SZX->ZX_FILIAL  := xFilial( 'SZX' )
			SZX->ZX_CODIGO  := cZX_CODIGO
			SZX->ZX_CDPEDID := aARRAY[ nI, nCD_PEDIDO ] 
			SZX->ZX_CDCPF   := aARRAY[ nI, nCD_CPF ] 
			SZX->ZX_NMCLIEN := aARRAY[ nI, nNM_CLIENTE] 
			SZX->ZX_DSEMAIL := aARRAY[ nI, nDS_EMAIL ] 
			SZX->ZX_NRTELEF := aARRAY[ nI, nNR_TELEFONE ] 
			SZX->ZX_CDPRODU := aARRAY[ nI, nCD_PRODUTO ] 
			SZX->ZX_DSPRODU := aARRAY[ nI, nDS_PRODUTO ] 
			SZX->ZX_VLPRECO := Val( aARRAY[ nI, nVL_PRECO ] )
			SZX->ZX_ICRENOV := aARRAY[ nI, nIC_RENOVACAO ] 
			SZX->ZX_DTEMISS := Stod( aARRAY[ nI, nDT_EMISSAO ] )
			SZX->ZX_DTEXPIR := Stod( aARRAY[ nI, nDT_EXPIRACAO ] )
			SZX->ZX_CDUSUAR := aARRAY[ nI, nCD_USUARIO ] 
			SZX->ZX_DSCARGO := aARRAY[ nI, nDS_CARGO ] 
			SZX->ZX_NRCNPJ  := aARRAY[ nI, nCD_CNPJ ] 
			SZX->ZX_DSRAZAO := aARRAY[ nI, nDS_RAZAO_SOCIAL ] 
			SZX->ZX_NRTELUS := aARRAY[ nI, nNR_TELEFONE ] 
			SZX->ZX_DSMUNIC := aARRAY[ nI, nDS_MUNICIPIO ]
			SZX->ZX_DSUF    := aARRAY[ nI, nDS_UF ] 
			SZX->ZX_CONSULT := cZX_CONSULT
			SZX->ZX_OPERAD  := aARRAY[ nI, nMV370OPTL ] 
			SZX->ZX_ORIGEM  := cZX_ORIGEM 
			SZX->ZX_INPUT   := cZX_INPUT
			SZX->( MsUnLock() )
			// Armazenar o Recno atual do registro.
			nZX_RECNO := SZX->( RecNo() )
			A370LogRecord( 'A370GrvTLV', 'SZX', .T., nZX_RECNO )
			// Efetiva a gravação do registro reservado.
			While ( GetSx8Len() > nSaveSX8 )
				ConfirmSX8()
			End
			// Gravar o relacionamento entre a entidade e o contato.
			AC8->( dbSetOrder( 1 ) )
			If .NOT. AC8->( dbSeek( xFilial( 'AC8' ) + aARRAY[ nI, nU5_CODCONT ] + 'SZX' + xFilial( 'SZX' ) + cZX_CODIGO ) )
				AC8->( RecLock( 'AC8', .T. ) )
				AC8->AC8_FILIAL := xFilial( 'AC8' )
				AC8->AC8_FILENT := xFilial( 'SZX' )
				AC8->AC8_ENTIDA := 'SZX'
				AC8->AC8_CODENT := cZX_CODIGO
				AC8->AC8_CODCON := aARRAY[ nI, nU5_CODCONT ]
				AC8->( MsUnLock() )
				A370LogRecord( 'A370GrvTLV', 'AC8', .T., AC8->( RecNo() ) )
			Endif
			// Gerar a agenda do operador.
			cU4_LISTA  := A370GetNum('SU4', 'U4_LISTA') //GetSXENum( 'SU4', 'U4_LISTA' )
			// Efetiva a gravação do registro reservado.
			While ( GetSx8Len() > nSaveSX8 )
				ConfirmSX8()
			End
			// Início da gravação.
			SU4->( RecLock( 'SU4', .T. ) )
			SU4->U4_FILIAL  := xFilial( 'SU4' )
			SU4->U4_TIPO    := '1' //1=Marketing;2=Cobrança;3=Vendas;4=Teleatendimento.
			SU4->U4_STATUS  := '1' //1=Ativa;2=Encerrada;3=Em Andamento
			SU4->U4_LISTA   := cU4_LISTA
			SU4->U4_DESC    := 'RENOV. ICP-BRASIL '
			SU4->U4_DTEXPIR := Stod( aARRAY[ nI, nDT_EXPIRACAO ] )
			SU4->U4_DATA    := Stod( aARRAY[ nI, nMaisCedo ] ) //Data da inclusão da agenda do consultor.
			SU4->U4_HORA1   := '06:00:00'
			SU4->U4_FORMA   := '6' //1=Voz;2=Fax;3=CrossPosting;4=Mala Direta;5=Pendencia;6=WebSite.
			SU4->U4_TELE    := '1' //1=Telemarkeing;2=Televendas;3=Telecobrança;4=Todos;5=Teleatendimento.
			SU4->U4_OPERAD  := cMV370OPTL
			SU4->U4_TIPOTEL := '4' //1=Residencial;2=Celular;3=Fax;4=Comercial 1;5=Comercial 2.
			SU4->U4_NIVEL   := '1' //1=Sim;2=Nao.
			If SU4->( FieldPos('U4_XDTVENC') ) > 0
				SU4->U4_XDTVENC := Stod( aARRAY[ nI, nDT_EXPIRACAO ] )
			Endif
			If SU4->( FieldPos('U4_XGRUPO') ) > 0
				SU4->U4_XGRUPO  := cMV370GRPT
			Endif
			SU4->( MsUnLock() )
			A370LogRecord( 'A370GrvTLV', 'SU4', .T., SU4->( RecNo() ) )
			cU6_CODIGO := A370GetNum('SU6', 'U6_CODIGO') //GetSXENum( 'SU6', 'U6_CODIGO' )
			// Efetiva a gravação do registro reservado.
			While ( GetSx8Len() > nSaveSX8 )
				ConfirmSX8()
			End
			SU6->( RecLock( 'SU6', .T. ) )
			SU6->U6_FILIAL  := xFilial( 'SU6' )
			SU6->U6_LISTA   := cU4_LISTA
			SU6->U6_CODIGO  := cU6_CODIGO
			SU6->U6_CONTATO := aARRAY[ nI, nU5_CODCONT ]
			SU6->U6_ENTIDA  := 'SZX'
			SU6->U6_CODENT  := cZX_CODIGO
			SU6->U6_ORIGEM  := '1' //1=Lista;2=Manual;3=Atendimento.
			SU6->U6_DATA    := Stod( aARRAY[ nI, nMaisCedo ] ) //Data da inclusão da agenda do consultor.
			SU6->U6_HRINI   := '06:00'
			SU6->U6_HRFIM   := '23:59'
			SU6->U6_STATUS  := '1' //1=Nao Enviado;2=Em uso;3=Enviado.
			SU6->U6_DTBASE  := cZX_INPUT
			SU6->( MsUnLock() )
			A370LogRecord( 'A370GrvTLV', 'SU6', .T., SU6->( RecNo() ) )
			// Atualizar a entidade com o número da agenda.
			If SZX->( RecNo() ) <> nZX_RECNO
				SZX->( dbGoTo( nZX_RECNO ) )
			Endif
			SZX->( RecLock( 'SZX', .F. ) )
			SZX->ZX_LISTA := cU4_LISTA
			SZX->( MsUnLock() )
		Else
			nProblem++
			A370Log( aArray[ nI, nNumLinha ], 'Registro já importando para o TELEVENDAS.' )
		Endif
	Next nI
Return
//-------------------------------------------------------------------------
// Rotina | A370Produto  | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Localiza o código do produto Protheus conforme o código de 
//        | produto GAR.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370Produto( cProduto )
	Local cRet := ''
	PA8->( dbSetOrder( 1 ) )
	If PA8->( dbSeek( xFilial( 'PA8' ) + cProduto ) )
		cRet := PA8->PA8_CODMP8
	Endif
Return( cRet )
//-------------------------------------------------------------------------
// Rotina | A370UF       | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Localiza o DDD da unidade federativa ou vice-versa.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370UF( cChave, nOrd, nRet )
	Local nP := 0
	Local cRet := ''
	nP := AScan( aDDD_EST, {|p| p[ nOrd ] == cChave } )
	If nP > 0
		cRet := aDDD_EST[ nP, nRet ]
	Endif
Return( cRet )
//-------------------------------------------------------------------------
// Rotina | A370Array    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Monta um vetor com os dados da linha que está sendo processado.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370Array( cLinha )
	Local nP := 0
	Local nD := 0	
	Local aArray := {}	
	Local cAux := ''
	Local cDelim := ';'
	Local nDELIM := 0
	cLinha := cLinha + cDelim
	While ( At( cDelim + cDelim, cLinha ) > 0 )
		cLinha := StrTran( cLinha, ( cDelim + cDelim ), ( cDelim + ' ' + cDelim ) )
	End
	While .NOT. Empty( cLinha )
		nP := At( cDelim, cLinha )
		If nP > 0
			AAdd( aArray, AllTrim( SubStr( cLinha, 1, nP-1 ) ) )
			cLinha := SubStr( cLinha, nP+1 )
		Endif
	End
Return( aArray )
//-------------------------------------------------------------------------
// Rotina | A370DddUf    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Monta vetor com os DDD do estado e sua sigla de unidade federa-
//        | tiva.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370DddUf()
	aAdd( aDDD_EST, {'11','SP','São Paulo'})
	aAdd( aDDD_EST, {'12','SP','São Paulo'})
	aAdd( aDDD_EST, {'13','SP','São Paulo'})
	aAdd( aDDD_EST, {'14','SP','São Paulo'})
	aAdd( aDDD_EST, {'15','SP','São Paulo'})
	aAdd( aDDD_EST, {'16','SP','São Paulo'})
	aAdd( aDDD_EST, {'17','SP','São Paulo'})
	aAdd( aDDD_EST, {'18','SP','São Paulo'})
	aAdd( aDDD_EST, {'19','SP','São Paulo'})
	aAdd( aDDD_EST, {'21','RJ','Rio de Janeiro'})
	aAdd( aDDD_EST, {'22','RJ','Rio de Janeiro'})
	aAdd( aDDD_EST, {'24','RJ','Rio de Janeiro'})
	aAdd( aDDD_EST, {'27','ES','Espírito Santo'})
	aAdd( aDDD_EST, {'28','ES','Espírito Santo'})
	aAdd( aDDD_EST, {'31','MG','Minas Gerais'})
	aAdd( aDDD_EST, {'32','MG','Minas Gerais'})
	aAdd( aDDD_EST, {'33','MG','Minas Gerais'})
	aAdd( aDDD_EST, {'34','MG','Minas Gerais'})
	aAdd( aDDD_EST, {'35','MG','Minas Gerais'})
	aAdd( aDDD_EST, {'37','MG','Minas Gerais'})
	aAdd( aDDD_EST, {'38','MG','Minas Gerais'})
	aAdd( aDDD_EST, {'41','PR','Paraná'})
	aAdd( aDDD_EST, {'42','PR','Paraná'})
	aAdd( aDDD_EST, {'43','PR','Paraná'})
	aAdd( aDDD_EST, {'44','PR','Paraná'})
	aAdd( aDDD_EST, {'45','PR','Paraná'})
	aAdd( aDDD_EST, {'46','PR','Paraná'})
	aAdd( aDDD_EST, {'47','SC','Santa Catarina'})
	aAdd( aDDD_EST, {'48','SC','Santa Catarina'})
	aAdd( aDDD_EST, {'49','SC','Santa Catarina'})
	aAdd( aDDD_EST, {'51','RS','Rio Grande do Sul'})
	aAdd( aDDD_EST, {'53','RS','Rio Grande do Sul'})
	aAdd( aDDD_EST, {'54','RS','Rio Grande do Sul'})
	aAdd( aDDD_EST, {'55','RS','Rio Grande do Sul'})
	aAdd( aDDD_EST, {'61','DF','Distrito Federal e Entorno'})
	aAdd( aDDD_EST, {'62','GO','Goiás'})
	aAdd( aDDD_EST, {'63','TO','Tocantins'})
	aAdd( aDDD_EST, {'64','GO','Goiás'})
	aAdd( aDDD_EST, {'65','MT','Mato Grosso'})
	aAdd( aDDD_EST, {'66','MT','Mato Grosso'})
	aAdd( aDDD_EST, {'67','MS','Mato Grosso do Sul'})
	aAdd( aDDD_EST, {'68','AC','Acre'})
	aAdd( aDDD_EST, {'69','RO','Rondônia'})
	aAdd( aDDD_EST, {'71','BA','Bahia'})
	aAdd( aDDD_EST, {'73','BA','Bahia'})
	aAdd( aDDD_EST, {'74','BA','Bahia'})
	aAdd( aDDD_EST, {'75','BA','Bahia'})
	aAdd( aDDD_EST, {'77','BA','Bahia'})
	aAdd( aDDD_EST, {'79','SE','Sergipe'})
	aAdd( aDDD_EST, {'81','PE','Pernambuco'})
	aAdd( aDDD_EST, {'82','AL','Alagoas'})
	aAdd( aDDD_EST, {'83','PB','Paraíba'})
	aAdd( aDDD_EST, {'84','RN','Rio Grande do Norte'})
	aAdd( aDDD_EST, {'85','CE','Ceará'})
	aAdd( aDDD_EST, {'86','PI','Piauí'})
	aAdd( aDDD_EST, {'87','PE','Pernambuco'})
	aAdd( aDDD_EST, {'88','CE','Ceará'})
	aAdd( aDDD_EST, {'89','PI','Piauí'})
	aAdd( aDDD_EST, {'91','PA','Pará'})
	aAdd( aDDD_EST, {'92','AM','Amazonas'})
	aAdd( aDDD_EST, {'93','PA','Pará'})
	aAdd( aDDD_EST, {'96','AP','Amapa'})
	aAdd( aDDD_EST, {'97','AM','Amazonas'})
	aAdd( aDDD_EST, {'98','MA','Maranhão'})
	aAdd( aDDD_EST, {'99','MA','Maranhão'})	
Return
//-------------------------------------------------------------------------
// Rotina | A370SoNum    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Retirar qualquer caractere diferente de números.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370SoNum( cVar )
	Local nI := 0
	Local cAux := ''
	Local cNumeros := '0123456789'
	For nI := 1 To Len( cVar )
		If SubStr( cVar, nI, 1 ) $ cNumeros
			cAux += SubStr( cVar, nI, 1 )
		Endif
	Next nI
Return( cAux )
//-------------------------------------------------------------------------
// Rotina | A370CNPJ     | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Critíca o dígito verificador para CNPJ e CPF se não é válido.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370CNPJ( cCGC )
	If ( cCGC == '00000000000000' ) .Or. ( cCGC <> '00000000000' )
		Return( .T. )
	Endif
Return( CGC( cCGC, , .F. ) )
//-------------------------------------------------------------------------
// Rotina | A370PedGAR   | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Consulta se a chave existe no chamado do ServiceDesk.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370PedGAR( cPedGAR )
	ADE->( dbOrderNickName( 'PEDIDOGAR' ) )
Return( ADE->( dbSeek( xFilial( 'ADE' ) + PadR( cPedGAR, 10 ) + Dtos( MsDate() ) ) ) )
//-------------------------------------------------------------------------
// Rotina | A370SZX      | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Consulta se a chave existe na entidade ICP-Brasil.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370SZX( cPedGAR)
	SZX->( dbSetOrder( 4 ) )
Return( SZX->( dbSeek( xFilial( 'SZX' ) + cPedGAR ) ) )
//-------------------------------------------------------------------------
// Rotina | A370Log      | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Atualiza o vetor de log de processamento.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370Log( nLinha, cLog )
	AAdd( aLogProc, { LTrim( Str( nLinha, 0 ) ), cLog } )
Return
//-------------------------------------------------------------------------
// Rotina | A370LogRecord | Autor | Robson Goncalves    | Data | 05.09.2014 
//-------------------------------------------------------------------------
// Descr. | Atualiza o vetor de log de atualização de registros.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370LogRecord( cRotina, cAliasTab, lAppend, nRecNo )
	If Len( aLogRecord ) == 0
		AAdd( aLogRecord, { 'LOG DE', 'GRAVAÇÃO', 'DE',       , 'REGISTROS' } )
		AAdd( aLogRecord, { 'ROTINA', 'TABELA'  , 'MANUTENÇÃO', 'RECORD'    } )
	Endif
	AAdd( aLogRecord, { cRotina, RetSqlName( cAliasTab ), Iif( lAppend, 'INSERT', 'UPDATE'), LTrim( Str( nRecNo ) ) } )
Return
//-------------------------------------------------------------------------
// Rotina | A370GetNum   | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Verificar se o número informado pela função realmente está
//        | disponível na tabela.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370GetNum( cAlias, cCampo, cCode )
	Local aArea    := GetArea()
	Local cNum     := GetSXENum( cAlias, cCampo )
	Local nSaveSx8 := GetSX8Len()
	Local cAux     := ''
	If cCode <> NIL .And. cAlias == 'SU6'
		cAux := cNum
		cNum := cCode + cNum
	Endif
	DbSelectArea( cAlias )
	DbSetOrder( 1 )
	While .T.
		If .NOT. DbSeek( xFilial( cAlias ) + cNum )
			If cCode <> NIL .And. cAlias == 'SU6'
				cNum := cAux 
			Endif
			Exit
		Endif
		While (GetSx8Len() > nSaveSx8)
			ConfirmSX8()
		End
		cNum := GetSXENum( cAlias, cCampo )
		If cCode <> NIL .And. cAlias == 'SU6'
			cAux := cNum
			cNum := cCode + cNum
		Endif
	End
	RestArea( aArea )
Return( cNum )

//-------------------------------------------------------------------------
// Rotina | A370LeLin    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para ler a linha em questão, porém há casos onde a linha
//        | é maior que 1023 caractere.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function A370LeLin()
	Local cLinAtual := ''
	Local cLinProx := ''
	Local cRetorno := ''
	//---------------------------------
	// Capturar a linha de dados atual.
	cLinAtual := FT_FREADLN()
	//-----------------------------------------------
	// Se a linha de dados não estiver vazia, seguir.
	If .NOT. Empty( cLinAtual )
		//-------------------------------------------------
		// Se a linha for menor que 1023 caractere, seguir.
		If Len( cLinAtual ) < 1023
			//---------------------------------
			// Atualizar a variável de retorno.
			cRetorno := cLinAtual
		Else
			//---------------------------------
			// Atualizar a variável de retorno.
			cRetorno += cLinAtual
			//-------------------------
			// Ir para a próxima linha.
			FT_FSKIP()
			//------------------------
			// Capturar a linha atual.
			cLinProx := FT_FREADLN()
			//------------------------------------------------
			// Se a linha for maior que 1023 caracter, seguir.
			If Len( cLinProx ) > 1023 
				//-------------------------------------------------------------------------------------------------
				// Fazer enquanto o tamanho da linha seja menor ou igual a 1023 caractere e não for fim do arquivo.
				While Len( cLinProx ) >= 1023 .AND. .NOT. FT_FEOF()
					//---------------------------------
					// Atualizar a variável de retorno.
					cRetorno += cLinProx
					//-------------------------
					// Ir para a próxima linha.
					FT_FSKIP()
					//------------------------
					// Capturar a linha atual.
					cLinProx := FT_FREADLN()
					//-------------------------------------------------
					// Se a linha for menor que 1023 caractere, seguir.
					If Len( cLinProx ) < 1023
						//---------------------------------
						// Atualizar a variável de retorno.
						cRetorno += cLinProx
					Endif
				End
			Else
				//---------------------------------
				// Atualizar a variável de retorno.
				cRetorno += cLinProx
			Endif
		Endif
	Endif
Return( RTrim( cRetorno ) )

//-------------------------------------------------------------------------
// Rotina | A370PodeUsar | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Verificar se a rotina pode ser executada, ou seja, se a sua
//        | estrutura está completa para o funcionamento.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370PodeUsar()
	Local lZX_CDPEDID := .F.
	Local cDirPrinc   := cBarra + 'csfa370' + cBarra
	Local cProcessed  := cDirPrinc + 'processed'
	Local cDirLog     := cDirPrinc + 'log'
	/*
	=========================================================================================================================
	GetMv(<parâmetro>,<lExiste>,<xDefault>)
	=======+===========+=========+=========
	       |           |         |
	       |           |         +-> Valor padrão caso o parâmetro não exista.
	       |           +-----------> .T. apenas verifica se parâmetro existe, .F. parâmetro não existe.
	       +-----------------------> Nome do parâmetro.
	Retorno: Qdo lExiste é .T. o retorno será .T. se o parâmetro existir e não retorna o conteúdo do parâmetro, do contrário retorna .F.
	         Qdo lExiste é .F. o retorno será o conteúdo do parâmetro se caso ele existir, do contrário emite Help() e retorna .F.
	=========================================================================================================================
	MV_370PATA	PATH DO ARQUIVO CSV A SER PROCESSADO. - \csfa370\
	MV_370EXT	EXTENSAO DO ARQUIVO A SER PROCESSADO, SOMENTE O NOME DA EXTENSAO. - *.csv
	MV_370PATL	PATH DO ARQUIVO DE LOG. - \csfa370\log
	MV_370PATP	PATH DOS ARQUIVOS PROCESSADOS. - \csfa370\processed
	MV_370OPSA	CODIGO DO OPERADOR DO SAC. - 001091
	MV_370OPTL	CODIGO DO OPERADOR DO TELEVENDAS. - 001137
	MV_370GRPS	CODIGO DO GRUPO DE ATENDIMENTO DO SAC. - 38
	MV_370GRPT	CODIGO DO GRUPO DE ATENDIMENTO DO TELEVENDAS. - 02
	MV_370ANTS	QUANTIDADE DE DIAS DE ANTECEDENCIA AO VENCIMENTO DA DATA QUE EXPIRA O CERTIFICADO PARA O SAC COMUNICAR. - 45
	MV_370LIMS	QUANTIDADE DE DIAS LIMITE DE ANTECEDENCIA PARA GERAR COM ANTECEDENCIA AO VENCIMENTO DA DATA QUE EXPIRA O CERTIFICADO PARA O SAC COMUNICAR. 15
	MV_370ANTT	QUANTIDADE DE DIAS DE ANTECEDENCIA AO VENCIMENTO DA DATA QUE EXPIRA O CERTIFICADO PARA O TELEVENDAS TENTAR VENDER. - 45
	MV_370LIMT	QUANTIDADE DE DIAS LIMITE DE ANTECEDENCIA AO VENCIMENTO DA DATA QUE EXPIRA O CERTIFICADO PARA O TELEVENDAS TENTAR VENDER. 15
	SDK_CODASS	CODIGO DO ASSUNTO PARA O ATENDIMENTO REGISTRADO NA IMPORTACAO CSFA370.prw. - ATR003
	SDK_OCORRE	CODIGO DA OCORRENCIA PARA O ATENDIMENTO REGISTRADO NA IMPORTACAO CSFA370.prw. - 003153
	MV_370ACAO	CODIGO DA ACAO CONFORME O ASSUNTO E OCORRENCIA CSFA370.prw. - (vazio) - não definido.
	MV_370MAIL	EMAILS PARA SER ENVIADO NO FINAL DO PROCESSAMENTO. - sistemascorporativos@certisign.com.br;comercial@certisign.com.br;jcjacob@certisign.com.br
	MV_370TLV	HABILITAR IMPORTACAO TAMBEM PARA O VENDAS DIRETAS (TELEVENDAS). S=Sim ou N=Nao. - S
	MV_370SAC	HABILITAR IMPORTACAO TAMBEM PARA O SAC. S=Sim ou N=Nao. - S
	MV_370TPVS	TIPOS DE VOUCHER QUE SERÃO CONSIDRADOS NA IMPORTAÇÃO SAC. Rotina CSFA370.prw. 2|A|B
	MV_370TPVT	TIPOS DE VOUCHER QUE SERÃO CONSIDERADOS NA IMPORTAÇÃO TELEVENDAS. Rotina CSFA370.prw. 3|5|B|D
	MV_FKMAIL	EMAIL PARA SUBSTITUIR ENDERECO DO CLIENTE E DO VENDEDOR. UTILIZADO PARA SIMULACAO/TESTE. (vazio).
	=========================================================================================================================
	*/
	If .NOT. GetMv( cMV370PATA, .T. )
		MakeDir( cDirPrinc )
		MakeDir( cProcessed )	
		MakeDir( cDirLog )
		CriarSX6( cMV370PATA, 'C', 'PATH DO ARQUIVO CSV A SER PROCESSADO.', cDirPrinc )
	Endif
	cMV370PATA := GetMv( cMV370PATA, .F. )
	If Empty( cMV370PATA )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370PATA sem conteúdo.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370EXT, .T. )
		CriarSX6( cMV370EXT, 'C', 'EXTENSAO DO ARQUIVO A SER PROCESSADO, SOMENTE O NOME DA EXTENSAO.', '*.csv' )
	Endif
	cMV370EXT := GetMv( cMV370EXT, .F. )
	If Empty( cMV370EXT )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370EXT sem conteúdo.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370PATL, .T. )
		CriarSX6( cMV370PATL, 'C', 'PATH DO ARQUIVO DE LOG.', cDirLog )
	Endif
	cMV370PATL := GetMv( cMV370PATL, .F. )
	If Empty( cMV370PATL )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370PATL sem conteúdo.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370PATP, .T. )
		CriarSX6( cMV370PATP, 'C', 'PATH DOS ARQUIVOS PROCESSADOS.', cProcessed )
	Endif
	cMV370PATP := GetMv( cMV370PATP, .F. )
	If Empty( cMV370PATP )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370PATP sem conteúdo.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370OPSA, .T. )
		CriarSX6( cMV370OPSA, 'C', 'CODIGO DO OPERADOR DO SAC.', '001091' ) //001091-Julio Jacob.
	Endif
	cMV370OPSA := GetMv( cMV370OPSA, .F. )
	If Empty( cMV370OPSA )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370OPSA sem conteúdo.' )
		Return( .F. )
	Endif
	SU7->( dbSetOrder( 1 ) )
	If .NOT. SU7->( dbSeek( xFilial( 'SU7' ) + cMV370OPSA ) )
		A370Log( 0, 'Impossível continuar. O código de operador informado no parâmetro MV_370OPSA não foi localizado em SU7.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370OPTL, .T. )
		CriarSX6( cMV370OPTL, 'C', 'CODIGO DO OPERADOR DO TELEVENDAS.', '001137' ) //001137-Gabriel Neves
	Endif
	cMV370OPTL := GetMv( cMV370OPTL, .F. )
	If Empty( cMV370OPTL )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370OPTL sem conteúdo.' )
		Return( .F. )
	Endif
	SU7->( dbSetOrder( 1 ) )
	If .NOT. SU7->( dbSeek( xFilial( 'SU7' ) + cMV370OPTL ) )
		A370Log( 0, 'Impossível continuar. O código de operador informado no parâmetro MV_370OPTL não foi localizado em SU7.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370GRPS, .T. )
		CriarSX6( cMV370GRPS, 'C', 'CODIGO DO GRUPO DE ATENDIMENTO DO SAC.', '38' ) //38-SAC suporte agenda pagamentos.
	Endif
	cMV370GRPS := GetMv( cMV370GRPS, .F. )
	If Empty( cMV370GRPS )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370GRPS sem conteúdo.' )
		Return( .F. )
	Endif
	SU0->( dbSetOrder( 1 ) )
	If .NOT. SU0->( dbSeek( xFilial( 'SU0' ) + cMV370GRPS ) ) 
		A370Log( 0, 'Impossível continuar. O código de grupo de atendimento para o SAC informado no parâmetro MV_370GRPS não foi localizado em SU0.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370GRPT, .T. )
		CriarSX6( cMV370GRPT, 'C', 'CODIGO DO GRUPO DE ATENDIMENTO DO TELEVENDAS.', '02' ) //02-Padrão
	Endif
	cMV370GRPT := GetMv( cMV370GRPT, .F. )
	If Empty( cMV370GRPT )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370GRPT sem conteúdo.' )
		Return( .F. )
	Endif
	SU0->( dbSetOrder( 1 ) )
	If .NOT. SU0->( dbSeek( xFilial( 'SU0' ) + cMV370GRPT ) ) 
		A370Log( 0, 'Impossível continuar. O código de grupo de atendimento para o Televendas informado no parâmetro MV_370GRPT não foi localizado em SU0.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( 'MV_370ANTS', .T. )
		CriarSX6( 'MV_370ANTS', 'N', 'QUANTIDADE DE DIAS DE ANTECEDENCIA AO VENCIMENTO DA DATA QUE EXPIRA O CERTIFICADO PARA O SAC COMUNICAR.', '45' )
	Endif
	nMV370ANTS := GetMv( 'MV_370ANTS', .F. )
	If Empty( nMV370ANTS )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370ANTS sem valor.' )
		Return( .F. )
	Endif
	// =========================================================================================================================	
	If .NOT. GetMv( 'MV_370LIMS', .T. )
		CriarSX6( 'MV_370LIMS', 'N', 'QUANTIDADE DE DIAS LIMITE DE ANTECEDENCIA PARA GERAR COM ANTECEDENCIA AO VENCIMENTO DA DATA QUE EXPIRA O CERTIFICADO PARA O SAC COMUNICAR.', '15' )
	Endif
	nMV370LIMS := GetMv( 'MV_370LIMS', .F. )
	If Empty( nMV370LIMS )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370LIMS sem valor.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( 'MV_370ANTT', .T. )
		CriarSX6( 'MV_370ANTT', 'N', 'QUANTIDADE DE DIAS DE ANTECEDENCIA AO VENCIMENTO DA DATA QUE EXPIRA O CERTIFICADO PARA O TELEVENDAS TENTAR VENDER.', '45' )
	Endif
	nMV370ANTT := GetMv( 'MV_370ANTT', .F. )
	If Empty( nMV370ANTT )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370ANTT sem valor.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( 'MV_370LIMT', .T. )
		CriarSX6( 'MV_370LIMT', 'N', 'QUANTIDADE DE DIAS LIMITE DE ANTECEDENCIA AO VENCIMENTO DA DATA QUE EXPIRA O CERTIFICADO PARA O TELEVENDAS TENTAR VENDER.', '15' )
	Endif
	nMV370LIMT := GetMv( 'MV_370LIMT', .F. )
	If Empty( nMV370LIMT )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370LIMT sem valor.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cSDK_CODASS, .T. )
		CriarSX6( cSDK_CODASS, 'C', 'CODIGO DO ASSUNTO PARA O ATENDIMENTO REGISTRADO NA IMPORTACAO CSFA370.prw.', '' )
	Endif
	cSDK_CODASS := GetMv( cSDK_CODASS, .F. )
	If Empty( cSDK_CODASS )
		A370Log( 0, 'Impossível continuar. Parâmetro SDK_CODASS sem conteúdo.' )
		Return( .F. )
	Endif
	SX5->( dbSetOrder( 1 ) )
	If .NOT. SX5->( dbSeek( xFilial( 'SX5' ) + 'T1' + cSDK_CODASS ) )
		A370Log( 0, 'Impossível continuar. O código de assunto para registrar o atendimento com a importação informado no parâmetro cSDK_CODASS não foi localizado em SX5.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cSDK_OCORRE, .T. )
		CriarSX6( cSDK_OCORRE, 'C', 'CODIGO DA OCORRENCIA PARA O ATENDIMENTO REGISTRADO NA IMPORTACAO CSFA370.prw.', '003153' )
	Endif
	cSDK_OCORRE := GetMv( cSDK_OCORRE, .F. )
	If Empty( cSDK_OCORRE )
		A370Log( 0, 'Impossível continuar. Parâmetro SDK_OCORRE sem conteúdo.' )
		Return( .F. )
	Endif
 	SU9->( dbSetOrder( 1 ) )
 	If .NOT. SU9->( dbSeek( xFilial( 'SU9' ) + cSDK_CODASS + cSDK_OCORRE ) )
		A370Log( 0, 'Impossível continuar. O código de ocorrência para registrar o atendimento com a importação informado no parâmetro cSDK_OCORRE  mais o assunto não foi localizado em SU9.' )
		Return( .F. )
 	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370ACAO, .T. )
		CriarSX6( cMV370ACAO, 'C', 'CODIGO DA ACAO CONFORME O ASSUNTO E OCORRENCIA CSFA370.prw.', '000251' )
	Endif
	cMV370ACAO := GetMv( cMV370ACAO, .F. )
	If Empty( cMV370ACAO )
		A370Log( 0, 'Impossível continuar. Parâmetro cMV370ACAO sem conteúdo.' )
		Return( .F. )
	Endif
 	SUQ->( dbSetOrder( 1 ) )
 	If .NOT. SUQ->( dbSeek( xFilial( 'SUQ' ) + cMV370ACAO ) )
		A370Log( 0, 'Impossível continuar. O código da ação para registrar o atendimento com a importação informado no parâmetro cMV370ACAO não foi localizado em SUQ.' )
		Return( .F. )
 	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370MAIL, .T. )
		CriarSX6( cMV370MAIL, 'C', 'EMAILS PARA SER ENVIADO NO FINAL DO PROCESSAMENTO.', 'sistemascorporativos@certisign.com.br; jcjacob@certisign.com.br; gabriel.neves@certisign.com.br' )
	Endif
	cMV370MAIL := GetMv( cMV370MAIL, .F. )
	If Empty( cMV370MAIL )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370MAIL vazio.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370SAC, .T. )
		CriarSX6( cMV370SAC, 'C', 'HABILITAR IMPORTACAO TAMBEM PARA O SAC. S=Sim ou N=Nao.', 'S' )
	Endif
	cMV370SAC := GetMv( cMV370SAC, .F. )
	If Empty( cMV370SAC )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370SAC vazio.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370TLV, .T. )
		CriarSX6( cMV370TLV, 'C', 'HABILITAR IMPORTACAO TAMBEM PARA O VENDAS DIRETAS (TELEVENDAS).S=Sim ou N=Nao.', 'S' )
	Endif
	cMV370TLV := GetMv( cMV370TLV, .F. )
	If Empty( cMV370TLV )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370TLV vazio.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370TPVS, .T. )
		CriarSX6( cMV370TPVS, 'C', 'TIPOS DE VOUCHER QUE SERÃO CONSIDRADOS NA IMPORTAÇÃO SAC. Rotina CSFA370.prw.', '2|A|B' )
	Endif
	cMV370TPVS := GetMv( cMV370TPVS, .F. )
	If Empty( cMV370TPVS )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370TPVS vazio.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV370TPVT, .T. )
		CriarSX6( cMV370TPVT, 'C', 'TIPOS DE VOUCHER QUE SERÃO CONSIDERADOS NA IMPORTAÇÃO TELEVENDAS. Rotina CSFA370.prw.', '3|B|D' )
	Endif
	cMV370TPVT := GetMv( cMV370TPVT, .F. )
	If Empty( cMV370TPVT )
		A370Log( 0, 'Impossível continuar. Parâmetro MV_370TPVT vazio.' )
		Return( .F. )
	Endif
	// =========================================================================================================================
	If .NOT. GetMv( cMV_FKMAIL, .T. )
		CriarSX6( cMV_FKMAIL, 'C', 'EMAIL PARA SUBSTITUIR EMAIL DO PARAMETRO MV_370MAIL. UTILIZADO PARA SIMULACAO/TESTE.', '' )
	Endif
	cMV_FKMAIL := GetMv( cMV_FKMAIL, .F. )
	// =========================================================================================================================
	SIX->( dbSetOrder( 1 ) )
	If SIX->( dbSeek( 'SZX' ) )
		While .NOT. SIX->( EOF() ) .And. SIX->INDICE == 'SZX'
			If RTrim( SIX->CHAVE ) == 'ZX_FILIAL+ZX_CDPEDID'
				lZX_CDPEDID := .T.
			Endif 
			SIX->( dbSkip() )
		End
		If .NOT. lZX_CDPEDID
			A370Log( 0, 'Impossível continuar. Não existe o índice ZX_FILIAL+ZX_CDPEDID, verifique a execução do update UPD370.' )
			Return( .F. )
		Endif
	Else
		nProblem++
		A370Log( 0, 'Impossível continuar. Não existe o índice para a tabela SZX.' )
		Return( .F. )
	Endif
Return(.T.)
//-------------------------------------------------------------------------
// Rotina | UPD370       | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina de update de dicionário e tabelas.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
User Function UPD370()
	Local cModulo := 'TMK'
	Local bPrepar := {|| U370Ini() }
	Local nVersao := 1
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return
//-------------------------------------------------------------------------
// Rotina | U370Ini      | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina de carga inicial dos vetores para a rotina de update.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function U370Ini()
	// [1] Indice
	// [2] Ordem
	// [3] Chave
	// [4] Descrição
	// [5] Descrição espanhol
	// [6] Descrição inglês
	// [7] Proprietário
	// [8] Show pesquisa
	// [9] NickName
	aSIX := {}
	AAdd( aSIX, { 'SZX', '4', 'ZX_FILIAL+ZX_CDPEDID', 'Pedido GAR', 'Pedido GAR', 'Pedido GAR', 'U', 'S', 'ZX_CDPEDID' } )
Return