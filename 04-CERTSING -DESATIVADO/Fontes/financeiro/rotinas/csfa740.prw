//--------------------------------------------------------------------------
// Rotina | CSFA740    | Autor | Robson Goncalves        | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para processar os dados dos arquivos das operadoras de
//        | cartão de crédito.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSFA740()
	Local aButton := {}
	Local aParam := {}
	Local aRet := {}
	Local aSay := {}
	
	Local nOpcao := 0
	
	Private cCadastro := 'Resumo de Operação de Cartões'
	Private oProc := NIL
	
	AAdd( aSay, 'Esta rotina tem por objetivo em processar os arquivos das  operadoras  de  cartão.' )
	AAdd( aSay, 'O Extrato Eletrônico  (EDI)  é  um  produto  disponibilizado  pelas  operadoras  à' )
	AAdd( aSay, 'Certisign que necessita de automatização no  processo  de  conciliação.  Nele,  as' )
	AAdd( aSay, 'informações são transmitidas de  forma  padronizada  sem  intervenção  manual  por' )
	AAdd( aSay, 'meio do canal EDI, proporcionando agilidade e segurança no tráfego das informações' )
	AAdd( aSay, 'Bandeiras disponíveis: AMEX, CIELO, REDECARD e VISA.' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		AAdd( aParam, { 6, 'Indique a pasta...', Space(256), '', '', '', 90, .T., '', '', 16+128 } )
		If ParamBox( aParam, 'Processar os arquivos da pasta?', @aRet )
			oProc := MsNewProcess():New( {|| A740Files( RTrim( aRet[ 1 ] ) ) }, 'Processando os arquivos, aguarde...', .F. )
			oProc:Activate()
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A740Files  | Autor | Robson Goncalves        | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para processar os arquivos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A740Files( cPasta )
	Local aFiles := {}
	Local aArqLog := {}
	
	Local nI := 0
	Local nFiles := 0
	Local nQtd := 0
	
	Local cArqProc := ''
	Local cDirOrig := ''
	Local cDirOrigLog := ''
	Local cDirOrigPrc := ''
	
	Local cDirDest:= ''
	Local cDirDestLog := ''
	Local cDirDestPrc := ''
	
	Local cMV_740BAND := 'MV_740BAND'
	Local cMV_740PAST := 'MV_740PAST'
	Local cMV_740_01 := 'MV_740_01'
	Local cHTML := ''
	
	Private aBandeiras := {}
	
	Private aProc := {}
	Private aVENDA := {}
	Private cArqLog := ''
	Private nHdlLog := 0
	Private nHdlProc:= 0
	
	//----------------------------------------------------------------------
	// Parâmatros para o arquivo de problemas.
	Private c470Arq  := 'LOG_PROBLEMA_' + Dtos( dDataBase ) + '_' + StrTran( Time(), ':', '' ) + '.csv' 
	Private c470Head := 'ARQ;LINHA;REFERENCIA;SITUACAO;CARTAO;NºAUT;RV;PARCELA;SALDO;DT BAIXA;DT COMPRA;PV ERP;DOC;TOTAL PV;EMISSAO PV ERP;ORIG PV ERP;PED GAR;TID;PEDSITE;OBSERV LOG'
	Private n470Hdl  := 0
	
	Private cMV_740_02 := 'MV_740_02'
	Private cMV_740_03 := 'MV_740_03'
	Private cMV_740_04 := 'MV_740_04'
	Private cMV_740_05 := 'MV_740_05'

	// Parâmetro com os e-mails para enviar aos responsáveis analisar os problemas de ChargeBack.
	If .NOT. GetMv( cMV_740_01, .T. )
		CriarSX6( cMV_740_01, 'C', 'EMAILS PARA ONDE SERA ENVIADO O LOG DE PROBLEMA CHARGEBACK','sistemascorporativos@certsign.com.br;marcio.carreira@certsign.com.br;contabilidade@certsign.com.br;boletofi@certsign.com.br;aparaujo@certsign.com.br' )
	Endif
	cMV_740_01 := GetMv( cMV_740_01, .F. )
	
	If .NOT. GetMv( cMV_740_02, .T. )
		CriarSX6( cMV_740_02, 'C', 'Banco,Agencia e conta utilizado no processo REDECARD para gerar a taxa','341;2901;04814-6' )
	Endif

	If .NOT. GetMv( cMV_740_03, .T. )
		CriarSX6( cMV_740_03, 'C', 'Natureza utilizada no processo REDECARD para gerar a taxa','SF520001' )
	Endif

	If .NOT. GetMv( cMV_740_04, .T. )
		CriarSX6( cMV_740_04, 'C', 'Utiliza Send2Proc - processo Rede? 1=Sim/2=Nao','1' )
	Endif

	If .NOT. GetMv( cMV_740_05, .T. )
		CriarSX6( cMV_740_05, 'C', 'Natureza utilizada no processo REDECARD para gerar mov CHA','FT030003' )
	Endif

	// Criar o arquivo que irá armazenar os log de problema de ChargeBack. 
	If File(c470Arq)
		FErase(c470Arq)		
	EndIf
	n470Hdl := FCreate( c470Arq, 1 )
	FWrite( n470Hdl, c470Head + CRLF )
	//----------------------------------------------------------------------
	
	cDirOrig    := cPasta 
	cDirOrigLog := cPasta + 'log'
	cDirOrigPrc := cPasta + 'proc'

	// Nome da pasta no ROOT PATH (Protheus_Data10).
	If .NOT. GetMv( cMV_740PAST, .T. )
		CriarSX6( cMV_740PAST, 'C', 'NOME DA PASTA NO ROOT PATH (PROTHEUS_DATA10) - FONTE CSFA740.PRW','\arq_op_cart\')
	Endif
	
	cDirDest := GetMv( cMV_740PAST, .F. )
	cDirDestLog := cDirDest + 'log'
	cDirDestPrc := cDirDest + 'proc'
	
	// Criar a estrutura de pasta na origem.
	If .NOT. A740Pastas( cDirOrig, cDirOrigPrc, cDirOrigLog, .T. )
		Return
	Endif
	
	// Criar a estrutura de pasta no destino.
	If .NOT. A740Pastas( cDirDest, cDirDestPrc, cDirDestLog, .F. )
		Return
	Endif
	
	// Bandeiras da operadora CIELO.
	If .NOT. GetMv( cMV_740BAND, .T. )
		CriarSX6( cMV_740BAND, 'C', ;
		'BANDEIRAS DE CARTOES ADERENTES PELA OPERADORA CIELO. UTILIZAR PONTO-E-VIRGULA PARA SEPARAR OS DADOS - FONTE CSFA740.PRW',;
		'001=VISA;002=MASTERCARD;006=SOROCRED;007=ELO;009=DINERS;011=AGIPLAN;015=BANESCARD;023=CABAL;029=CREDSYSTEM;035=ESPLANADA;064=CREDZ')
	Endif
	aBandeiras := StrTokArr( GetMv( cMV_740BAND, .F. ), ';' )

	// Estabelecer as barras nas variáveis.
	cDirOrigLog  := cDirOrigLog  + '\'
	cDirOrigPrc  := cDirOrigPrc  + '\'

	cDirDestLog  := cDirDestLog  + '\'
	cDirDestProc := cDirDestProc + '\'
	
	// Criar o arquivo de log de processamento.
	cArqLog := 'LOG_PROC_' + Dtos( dDataBase ) + '_' + StrTran( SubStr( Time(), 1, 5), ':', '' ) + '.csv'
	nHdlLog := FCreate( cArqLog, 1 )

	FWrite( nHdlLog, CRLF + '--< INÍCIO DO PROCESSAMENTO >--< ' + ;
	                 Dtoc( dDataBase ) + ' >--< ' + ;
	                 Time() + ' >--< ' + ;
	                 'User: ' + RTrim(UsrFullName(RetCodUsr())) + ' >--< ' + ;
	                 'Computer name: ' + GetComputerName() + ' >--< ' + ;
	                 'IP client: ' + GetClientIP() + ' >-- ' + CRLF + CRLF )
	
	cArqProc := 'PROCESS_' + Dtos( dDataBase ) + '_' + StrTran( SubStr( Time(), 1, 5), ':', '' ) + '.csv'
	nHdlProc := FCreate( cArqProc, 1 )
	aProc := {'NOME_DO_ARQUIVO;LAY-OUT;CONTA;DT_PREV_PAGTO;STATUS;PV;CARTAO;DT_COMPRA;BX_CB;VALOR;PARC;TOT_PARC;COD_AUTENT;TID;DOC;PEDSITE;PED_PROTHEUS;XDOCUMEN;PED_PROTHEUS;TID;PED_PROTHEUS;COD_AUTENTIC;DOCUMENTO;PED_PROTHEUS;COD_AUTENTIC;CARTAO;PED_PROTHEUS;DOCUMENTO;PED_PROTHEUS;CLIENTE;LOJA;RAZAO_SOCIAL;NOTA_FISCAL;SERIE_NFISCAL;REALIZACAO_PROCESSO'+CRLF}
	FWrite( nHdlProc, aProc[ 1 ] )
	aProc := {}

	// Capturar todos os arquivos disponíveis e saber a quantidade.
	aFiles := Directory( cDirOrig + '*.*' )
	nFiles := Len( aFiles )
	cFiles := LTrim( Str( nFiles ) )
	
	oProc:SetRegua1( nFiles )
	
	// Se tem arquivo para processar.
	If nFiles > 0
	
		// Processar todos os arquivos
		For nI := 1 To nFiles
			
			// O arquivo existe na origem?
			If File( cDirOrig + aFiles[ nI, 1 ] )
				// Copiar para a pasta destino.
				If __CopyFile( cDirOrig + aFiles[ nI, 1 ], cDirDest + aFiles[ nI, 1 ] )
					Sleep( Randomize( 1, 499 ) )
					
					// Verificar se realmente foi copiado.
					If File( cDirDest + aFiles[ nI, 1 ] )
						FWrite( nHdlLog, '+--------------------------------------------------------------------+' + CRLF )
						FWrite( nHdlLog, '| ' + PadC( ' PROCESSANDO ARQUIVO [' + aFiles[ nI, 1 ] + '] ', 66, ' ' ) + ' |' + CRLF )
						FWrite( nHdlLog, '+--------------------------------------------------------------------+' + CRLF )
						
						aProc := { aFiles[ nI, 1 ] }
						
						// Processar os dados do arquivo conforme o lay-out.
						oProc:IncRegua1( 'Arquivo [' + aFiles[ nI, 1 ] + '] ' + LTrim( Str( ++nQtd ) ) + '/' + cFiles + ''  )
						A740LayOut( cDirDest + aFiles[ nI, 1 ], @aArqLog )
						
						// Copiar o arquivo da pasta destino para a pasta de processados.
						A740Mover( cDirDest + aFiles[ nI, 1 ], cDirDestPrc + aFiles[ nI, 1 ], aFiles[ nI, 1 ], cDirDest, cDirDestPrc )
						
						// Copiar o arquivo da pasta origem para a pasta de processados.
						A740Mover( cDirOrig + aFiles[ nI, 1 ], cDirOrigPrc + aFiles[ nI, 1 ], aFiles[ nI, 1 ], cDirOrig, cDirOrigPrc )
					Else
						FWrite( nHdlLog, 'Não localizado no destino o arquivo: ' + cDirDest + aFiles[ nI, 1 ] + CRLF )
					Endif
				Else
					FWrite( nHdlLog, 'Não foi possível copiar o arquivo da pasta origem ' + cDirOrig + aFiles[ nI, 1 ] + ;
					' para a pasta destino ' + cDirDest + aFiles[ nI, 1 ] + CRLF )
				Endif
			Else
				FWrite( nHdlLog, 'Não foi possível copiar o arquivo da origem ' + cDirOrig + aFiles[ nI, 1 ] + ;
				' para a pasta destino ' + cDirDest + aFiles[ nI, 1 ] + CRLF )
			Endif
		Next nI
		
		// Registrar o fim do processamento.
		FWrite( nHdlLog, CRLF + '--< FIM DO PROCESSAMENTO >--< ' + Dtoc( dDataBase ) + ' >--< ' + Time() + ' >--' + CRLF + CRLF )
		FClose( nHdlLog )
		Sleep( Randomize( 1, 499 ) )
		
		FClose( nHdlProc )
		Sleep( Randomize( 1, 499 ) )
		
		// Copiar o arquivo de log de processamento da pasta StartPath para a pasta destino.
		If __CopyFile( cArqLog, cDirDestLog + cArqLog )
			Sleep( Randomize( 1, 499 ) )
			
			// Verificar se realmente copiou.
			If File( cDirDestLog + cArqLog )
				
				// Copiar o arquivo de log de processamento da pasta StartPath para a pasta origem.
				If __CopyFile( cArqLog, cDirOrigLog + cArqLog )
					Sleep( Randomize( 1, 499 ) )
					
					// Verificar se realmente copiou.
					If File( cDirOrigLog + cArqLog )
						FErase( cArqLog )
					Endif
					MsgAlert( '<b><font size="4" color="blue"><b>' + '* * *  P R O C E S S A M E N T O * F I N A L I Z A D O  * * *<br><br>' + ;
					'<b><font size="4" color="green"><b>'  + 'Por favor, abra o arquivo ' + cPasta + 'log\' + cArqLog + '<br>' + ;
					' para verificar se há algum tipo de incidente que você tenha que agir.' , cCadastro )
					If MsgYesNo( 'Posso abrir o arquivo de log de processamento para você?', cCadastro )
						WinExec( 'notepad ' + cPasta + 'log\' + cArqLog )
					Endif
				Else
					MsgAlert( 'Não foi possível mover o arquivo ' + cArqLog + ' da pasta Startpath para a pasta ' + cDirOrigLog, cCadastro )
				Endif
			Endif
		Else
			MsgAlert( 'Não foi possível mover o arquivo ' + cArqLog + ' da pasta Startpath para a pasta ' + cDirDestLog, cCadastro )
		Endif
		
		__CopyFile( cArqProc, cDirDestLog + cArqProc )
		__CopyFile( cArqProc, cDirOrigLog + cArqProc )
		
		If Len( aVENDA ) > 0
			FwMsgRun(,{|| DlgToExcel( { { "ARRAY", "RESUMO DE OPERÇÃO CIELO CONFIRMAÇÃO DE VENDAS", {;
			'DT.VENDA','DT.PREV.PAGTO.','QTD.PARC.','NºCARTÃO/TID','NSU/DOC','CÓD.AUT.','VL.BRUT VENDA',;
			'BANDEIRA','COLUNAS CONCATENADAS D+E+F','ORIGEM DA INFORMAÇÃO','PEDSITE'},;
			 aVENDA } } ) },,'Aguarde, gerando os dados da confirmação de vendas...')
		Endif
		
		If n470Hdl > -1
			If File( c470Arq ) .And. FClose( n470Hdl )
				cHTML := '<html><head><title></title></head><body>'
				cHTML += '<p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><span style="color: #0000ff;">Prezado(s),</span></span></span></p>'
				cHTML += '<p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><span style="color: #0000ff;">O arquivo anexo &eacute; relativo a registros de ChargeBack encontrado durante o processamento dos arquivos de retorno das operadoras de cart&otilde;es.</span></span></span></p>'
				cHTML += '<p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><span style="color: #0000ff;">Conforme o LOG verifique que houve registros informados pela operadora que n&atilde;o foi poss&iacute;vel efetuar a baixa no ERP Protheus.</span></span></span></p>'
				cHTML += '<p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><span style="color: #0000ff;">Atenciosamente,</span></span></span></p>'
				cHTML += '<hr />'
				cHTML += '<p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><span style="color:#a9a9a9;">Por favor, n&atilde;o responda este e-mail, pois ele &eacute; gerado autormaticamente pelo sistema ERP Protheus.</span></span></span></p>'
				cHTML += '</body></html>'
		
				//CSMailSend( cMV_740_01, 'Log de processamento ChargeBack', cHTML, GetSrvProfString('Startpath','') + c470Arq )
				FSSendMail( cMV_740_01, 'Log de processamento ChargeBack', cHTML, GetSrvProfString('Startpath','') + c470Arq )
			Endif
		EndIf
	Else
		MsgAlert('Não localizado arquivo(s) na pasta informada',cCadastro )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A740Pastas | Autor | Robson Goncalves        | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para criar as pastas.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A740Pastas( cDirMain, cDirProc, cDirLog, lOrigem )
	Local lRet := .T.
	If .NOT. lOrigem
		lRet := ExistDir( cDirMain )
		If .NOT. lRet
			lRet := FwMakeDir( cDirMain )
		Endif
	Endif
	If lRet
		If .NOT. ExistDir( cDirProc )
			lRet := FwMakeDir( cDirProc )
		Endif
	Endif
	If lRet
		If .NOT. ExistDir( cDirLog )
			lRet := FwMakeDir( cDirLog )
		Endif
	Endif
Return( lRet )

//--------------------------------------------------------------------------
// Rotina | A740Mover | Autor | Robson Goncalves        | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para mover os arquivos entre as pastas desta gestão.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A740Mover( cOrigem, cDestino, cFile, cPOrig, cPOrigPrc )
	If __CopyFile( cOrigem, cDestino )
		Sleep( Randomize( 1, 499 ) )
		
		// Apagar o arquivo da pasta destino.
		FErase( cOrigem )
		Sleep( Randomize( 1, 499 ) )
		
		// Verificar se realmente foi apagado.
		If File( cOrigem )
			FWrite( nHdlLog, 'Não foi possível apagar o arquivo ' + cFile + ' da pasta ' + cPOrig + '.' + CRLF )
		Endif
	Else
		FWrite( nHdlLog, 'Não foi possível copiar o arquivo ' + cFile + ' da pasta ' + cPOrig +;
		' para a pasta ' + cPOrigPrc + '.' + CRLF )
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A740LayOut | Autor | Robson Goncalves        | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para verificar qual lay-out a ser processado.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A740LayOut( cArquivo )
	Local cHeader := ''
	
	FT_FUSE( cArquivo )
	FT_FGOTOP()
	cHeader := FT_FREADLN()
	FT_FUSE()
	
	If 'AMEX' $ cHeader
		aProc[ 1 ] := aProc[ 1 ] + ';AMEX'
		A740Amex( cArquivo )
		
	Elseif 'VISANET' $ cHeader 
		aProc[ 1 ] := aProc[ 1 ] + ';VISANET'
		A740VisaNet( cArquivo )
		
	Elseif 'CIELO' $ cHeader 
		aProc[ 1 ] := aProc[ 1 ] + ';CIELO'
		A740Cielo( cArquivo )
	Elseif 'REDECARD' $ Upper( cHeader ) 
		aProc[ 1 ] := aProc[ 1 ] + ';REDECARD'
		A740Rede( cArquivo )
	Endif
Return                                                                        

//--------------------------------------------------------------------------
// Rotina | A740VisaNet | Autor | Robson Goncalves       | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para processar o lay-out Visa e RedeCard.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A740VisaNet( cArquivo )
	Local cAutC := ''
	Local cCart := ''
	Local cConta := ''
	Local cDoc := ''
	Local cDtBx := ''
	Local cDtCpr := ''
	Local cLine := ''
	Local cParc := ''
	Local cPedSite := ''
	Local cProxPrc := ''
	Local cPv := ''
	Local cSomLog := '0'
	Local cStatus := ''
	Local cTID := ''
	Local cTipReg := ''
	Local cTOTLIN := ''
	Local cVlrP := ''
	
	Local lRet := .F.
	
	Local nLine := 0
	Local nHandle := 0  
	Local nRecAtu := 0
	Local nSaldo := 0
	
	Local aParam := {}
	
	FT_FUSE( cArquivo )
	cTOTLIN := LTrim( Str( FT_FLASTREC()+1 ) )
	oProc:SetRegua2( Val( cTOTLIN ) )
	FT_FGOTOP()
		
	While .NOT. FT_FEOF()
		nLine++
		
		oProc:IncRegua2( 'Processando ' + LTrim( Str( nLine ) ) + ' linhas de ' + cTOTLIN + ' no total.' )
		
		cLine := FT_FREADLN()

		If SubStr(cLine,1,1) == '0'
			//Verifica a bandeira do cartao.
			If SubStr(cLine,150,3)=='   ' //3 espaços em branco, bandeira VISA
				FWrite( nHdlLog, 'A posição 150 da primeira linha do arquivo ' + cArquivo + ;
				'está vazia. Verifique se é um arquivo de baixa VisaNet. Nesta posição deve existir o código 001 para Visa ou 999 '+;
				'para outras bandeiras, portanto lay-out de arquivo inválido.' + CRLF)
				FT_FUSE()
				Return
			Endif
			cConta := Iif( SubStr( cLine, 150, 3 ) == '001', 'VISA','REDECARD' )
			aProc[ 1 ] := aProc[ 1 ] + ';' + cConta
			
		Elseif SubStr(cLine,1,1) == '1'
			cDtBx 	:= '20'+SubStr(cLine,45,6)	   //Data prevista de pagamento
			cStatus	:= SubStr(cLine,150,1)	       //Status de operação, "C" indica uma operação de cartão de crédito.
			aProc[ 1 ] := aProc[ 1 ] + ';' + cDtBx + ';' + cStatus
			
		Elseif SubStr(cLine,1,1) == '2'
			cPv		:= SubStr( cLine, 2, 10 )   //numero do estabelecimento de venda
			cCart 	:= SubStr( cLine, 19, 16 )  //numero do cartao, se for compra e-commerce é uma string de zeros.
			cDtCpr	:= SubStr( cLine, 38, 8 )   //data da compra
			cTipReg	:= Iif(SubStr( cLine, 46, 1 ) ==  '-' , 'C', 'B' )   //identificador do tipo de baixa. C (-) por cancelamento, B (+)
			cVlrP 	:= SubStr( cLine, 47, 13 )  //valor de compra, se parcelado, valor da parcela
			cParc 	:= SubStr( cLine, 60, 2 )   // o numero da parcela atual, zero é venda a vista
			cProxPrc := SubStr( cLine, 62, 2 )   // Total de parcelas, zero é venda a vista
			cAutC 	:= SubStr( cLine, 94, 6 )  	//Codigo de autenticacao
			cTID     := SubStr( cLine, 100, 20 ) //ID da transacao para compras e-commerce.
			cDoc     := Iif(SubStr( cLine, 46, 1 ) == '-' , ' ', SubStr( cLine, 140, 6 ) )//Numero do documento
			                                                                              //Não tem numero de documento para Cancelamentos. 
			                                                                              //Apenas codigo de autorização
			nSaldo	:= Val( cVlrP ) / 100
			
			aProc[ 1 ] := aProc[ 1 ] + ';' + cPV + ';' + cCart + ';' + cDtCpr + ';' + cTipReg + ';' + ;
			LTrim( Str( Val( cVlrP )/100, 12, 2 ) ) + ';' + cParc + ';' + cProxPrc + ';' + cAutC + ';' + cTid + ';' + cDoc
			
			If cStatus == 'C' .AND. cTipReg == 'C'
				nRecAtu := nLine 
				//lRet := U_CCBAIFIN(cCart,cAutC,cVlrP,cParc,cDtCpr,nSaldo,cDtBx,cTipReg,nHandle,nHdlLog,NIL,nRecAtu,cSomLog,cArquivo,cPv,cTID,;
				//NIL,cConta,cDoc,cPedSite,,aProc)

				aParam := {cCart,cAutC,cVlrP,cParc,cDtCpr,nSaldo,cDtBx,cTipReg,nHandle,cArqLog/*nHdlLog*/,NIL,nRecAtu,cSomLog,cArquivo,cPv,cTID,;
				NIL,cConta,cDoc,cPedSite,,aProc}
					
				U_GTPutIN(Iif(Empty(cTID),cDoc,cTID),"J",cDoc,.T.,{"CCBAIFIN",cTid,cAutC,cDoc,cArquivo,aProc},cDoc,,)
				
				nTime := Seconds()
				While .t.

					If U_Send2Proc(Iif(Empty(cTID),cDoc,cTID),"U_CCBAIFIN",aParam)

						Exit
					Else

						nWait := Seconds()-nTime
						If nWait < 0
							nWait += 86400
						Endif

						If nWait > 15
							// Passou de 2 minutos tentando ? Desiste !
							U_GTPutOUT(Iif(Empty(cTID),cDoc,cTID),"J",cDoc,{"CCBAIFIN","Inconsistência realizar distribuicao para CCBAIFIN",aProc[1]},cDoc)
							
							EXIT
						Endif

						// Espera um pouco ( 5 segundos ) para tentar novamente

						Sleep(5000)

					EndIf

				EndDo
			
			Else
				FWrite( nHdlLog, 'Linha '+PadL(LTrim(Str(nLine)),5,' ')+' do arquivo ' + cArquivo + ' não se refere a crédito.' + CRLF  )
				aProc[ 1 ] := aProc[ 1 ] + 'Linha ;'+PadL(LTrim(Str(nLine)),5,' ')+'; do arquivo ' + cArquivo + '; não se refere a crédito.'
			Endif
		Endif
		
		aProc[ 1 ] := aProc[ 1 ] + CRLF
		FWrite( nHdlProc, aProc[ 1 ] )
		aProc := { cArquivo }
		
		FT_FSKIP()
	End
	FT_FUSE()
Return

//--------------------------------------------------------------------------
// Rotina | A740Amex    | Autor | Robson Goncalves       | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para processar o lay-out AMEX (American Express).
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A740Amex( cArquivo )
	Local aLine 	:= {}
	Local aParam 	:= {}
	
	Local cAutC := ''
	Local cCart := ''
	Local cDoc := ''
	Local cDtBx := ''
	Local cDtCpr := ''
	Local cNumPar := ''
	Local cParc := ''
	Local cPedSite := ''
	Local cPv := ''
	Local cRv := ''
	Local cSomLog := '0'
	Local cStatus := ''
	Local cTipLin := ''
	Local cTipReg := ''
	Local cTOTLIN := ''
	Local cVlrP := ''
	Local xBuff := ''
	
	Local lRet := .F.
	Local lExecBaiFin := .F.
	
	Local nHandle := 1
	Local nLine := 1
	Local nRecAtu := 0
	Local nSaldo := 0
	
	FT_FUSE( cArquivo )
	cTOTLIN := LTrim( Str( FT_FLASTREC()+1 ) )
	oProc:SetRegua2( Val( cTOTLIN ) )
	FT_FGOTOP()
	
	While .NOT. FT_FEOF()
		nLine++
		
		oProc:IncRegua2( 'Processando ' + LTrim( Str( nLine ) ) + ' linhas de ' + cTOTLIN + ' no total.' )
				
		xBuff := FT_FREADLN()
		aLine := StrTokArr( xBuff, ',' )
		cTipLin := Iif( Len( aLine) >= 6, aLine[ 6 ], '' )

		lExecBaiFin := .F.

		If .NOT. Empty( xBuff ) .AND. cTipLin $ '1,3,4,5'
			cCart 	:= ''
			cAutC 	:= ''
			cVlrP 	:= ''
			cDtCpr	:= ''
			cDtBx		:= ''
			nSaldo	:= 0
			cTipReg	:= ''
			cPv		:= ''
			cDoc    	:= ''
			
			If cTipLin == '1'
				cStatus :=  Upper( aLine[ Len( aLine ) ] )
				FT_FSKIP()
				Loop
			Endif
			
			If cStatus == 'P'
				If cTipLin == '3' 
					cRv := aLine[ 9 ]
					cParc := aLine[ 19 ]
				EndIf
				
				If cTipLin == '4'
					cDtBx	   := aLine[ 2 ]
					cDtCpr	:= aLine[ 8 ]
					cDoc 	   := aLine[ 9 ]
					cAutC	   := aLine[ 10 ]
					cCart 	:= Left( aLine[ 11 ], 15 )
					cNumPar	:= aLine[ 15 ]
					cParc    := aLine[ 16 ] // ou NSU
					cPedSite := aLine[ 20 ]
					cVlrP    := Val( aLine[ 23 ] ) / 100
					
					If cVlrP == 0
						cVlrP := Val( aLine[ 14 ] ) / 100
						If cVlrP == 0
							cVlrP := Val( aLine[ 12 ] ) / 100
						Endif
					Endif
					
					nSaldo := cVlrP
							
					cTipReg	:= 'B'
				Endif
				
				If cTipLin == '5'
					cDtBx		:= aLine[ 2 ]
					cDtCpr	:= aLine[ 23 ]
					cDoc 		:= aLine[ 24 ]
					cAutC		:= ''
					cCart 	:= Left( aLine[ 14 ], 15 )
					cNumPar	:= aLine[ 16 ]
					cParc   	:= aLine[ 16 ]
					cPedSite	:= ''
					cVlrP 	:= Val( aLine[ 9 ] ) /100
					nSaldo	:= ( cVlrP / 100 )*-1
					cRv		:= '100' + Right( AllTrim( aLine[ 8 ] ), 5 )
					cTipReg	:= 'C'
				Endif
				
				If ValType( cVlrP ) <> 'N'
					cVlrP := 0
				Endif
				
				aProc[ 1 ] := aProc[ 1 ] + 'AMEX' +';'+ cDtBx +';'+ cStatus +';'+ cPV +';'+ cCart +';'+ cDtCpr +';'+ cTipReg +';'+ LTrim( Str( cVlrP, 12, 2 ) ) +';'+ cParc +';'+ cNumPar +';'+ cAutC +';'+ 'NAO_TID' +';'+ cDoc

				aParam := {cCart,cAutC,cVlrP,cParc,cDtCpr,nSaldo,cDtBx,cTipReg,nHandle,cArqLog/*nHdlLog*/,cRv,nRecAtu,cSomLog,cArquivo,cPv,;
					NIL,cTipLin,"AMEX",cDoc,cPedSite,nil,aProc}
				
				If cTipLin == '5' .AND. cTipReg == 'C'
					cPv := aLine[ 4 ]
					nRecAtu := nLine 
	   				aParam[15] := cPv
	   				aParam[12] := nRecAtu
	   				lExecBaiFin := .T.
		   			/*lRet := U_CCBAIFIN(cCart,cAutC,cVlrP,cParc,cDtCpr,nSaldo,cDtBx,cTipReg,nHandle,nHdlLog,cRv,nRecAtu,cSomLog,cArquivo,cPv,;
		   			NIL,cTipLin,'AMEX',cDoc,cPedSite,,aProc)*/
		   		
				Elseif cTipLin == '4' .AND. cTipReg == 'B'
					cPv := aLine[ 4 ]
					nRecAtu := nLine 
	   				aParam[15] := cPv
	   				aParam[12] := nRecAtu
	   				lExecBaiFin := .T.
		   			/*lRet := U_CCBAIFIN(cCart,cAutC,cVlrP,cParc,cDtCpr,nSaldo,cDtBx,cTipReg,nHandle,nHdlLog,cRv,nRecAtu,cSomLog,cArquivo,cPv,;
		   			NIL,cTipLin,'AMEX',cDoc,cPedSite,,aProc)*/	   					   			
				Endif
			Else
				If cStatus == 'F' .AND. cTipLin == '4'
				   AAdd( aVENDA, { Dtoc( Stod( aLine[ 8 ] ) ),;
				   Dtoc( Stod( aLine[ 2 ] ) ),;
					aLine[ 15 ],;
					Left( aLine[ 11 ], 15 ),;
					aLine[ 9 ],;
					aLine[ 10 ],;
					Val( aLine[ 23 ] ) / 100,;
					'AMEX', ;
					Left( aLine[ 11 ], 15 ) + aLine[ 9 ] + aLine[ 10 ],;
					'Arquivo: ' + RTrim( cArquivo ) + ' linha: ' + LTrim( Str( nLine ) ), cPedSite } )
				Endif
				
				FWrite( nHdlLog, 'Linha ' + PadL(LTrim(Str(nLine)),5,' ') + ' do arquivo ' + cArquivo + ' referente a pagamento futuro ' + ;
				cStatus + CRLF )
				aProc[ 1 ] := aProc[ 1 ] + 'Linha ;'+PadL(LTrim(Str(nLine)),5,' ')+'; do arquivo ' + cArquivo + '; referente a pagamento futuro '
			Endif
			
			If lExecBaiFin
			   	
			   	U_GTPutIN(cDoc+cAutC,"J",cPedSite,.T.,{"CCBAIFIN","",cAutC,cDoc, cArquivo,aProc},cPedSite,,)
				
				nTime := Seconds()
				While .t.

					If U_Send2Proc(cDoc+cAutC,"U_CCBAIFIN",aParam)

						Exit
					Else

						nWait := Seconds()-nTime
						If nWait < 0
							nWait += 86400
						Endif

						If nWait > 15
							// Passou de 2 minutos tentando ? Desiste !
							U_GTPutOUT(cDoc+cAutC,"J",cPedSite,{"CCBAIFIN","Inconsistência realizar distribuicao para CCBAIFIN",aProc[1]},cPedSite)
							
							EXIT
						Endif

						// Espera um pouco ( 5 segundos ) para tentar novamente

						Sleep(5000)

					EndIf

				EndDo
			
			EndIf
			
			
		Elseif Empty( xBuff )
			FWrite( nHdlLog, 'Linha ' + PadL(LTrim(Str(nLine)),5,' ') + ' do arquivo ' + cArquivo + ' desconsiderada.' + CRLF )
			aProc[ 1 ] := aProc[ 1 ] + 'Linha ;'+PadL(LTrim(Str(nLine)),5,' ')+'; do arquivo ' + cArquivo + '; desconsiderada'
		Endif
		
		aProc[ 1 ] := aProc[ 1 ] + CRLF
		FWrite( nHdlProc, aProc[ 1 ] )
		aProc := { cArquivo }

		FT_FSKIP()
	End
	FT_FUSE()
Return

//--------------------------------------------------------------------------
// Rotina | A740Cielo   | Autor | Robson Goncalves       | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para processar o lay-out Cielo.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A740Cielo( cArquivo )
	Local cAutC := ''
	Local cCart := ''
	Local cConta := ''
	Local cBandeira := ''
	Local cDoc := ''
	Local cDtBx := ''
	Local cDtCpr := ''
	Local cLine := ''
	Local cParc := ''
	Local cPedSite := ''
	Local cProxPrc := ''
	Local cPv := ''
	Local cSomLog := '0'
	Local cStatus := ''
	Local cTID := ''
	Local cTipReg := ''
	Local cTOTLIN := ''
	Local cVlrP := ''
	
	Local lRet := .F.
	Local lVendaCIELO := .F.
	
	Local nB := 0
	Local nLine := 0
	Local nHandle := 0  
	Local nRecAtu := 0
	Local nSaldo := 0
	
	Local aParam := {}
	Local cPedido	:= ''
	Local cNaturBand := ''
	
	//Local cValorBrutoV := ''
	
	FT_FUSE( cArquivo )
	cTOTLIN := LTrim( Str( FT_FLASTREC()+1 ) )
	oProc:SetRegua2( Val( cTOTLIN ) )
	FT_FGOTOP()
	
	While .NOT. FT_FEOF()
		nLine++
		
		oProc:IncRegua2( 'Processando ' + LTrim( Str( nLine ) ) + ' linhas de ' + cTOTLIN + ' no total.' )
				
		cLine := FT_FREADLN()
		
		// Tipo do registro: Header
		If SubStr(cLine,1,1) == '0'
			cConta := Iif( SubStr( cLine, 48, 2 ) $ '03|04', 'CIELO', '' )
			lVendaCIELO := ( SubStr( cLine, 48, 2 ) == '03' )
			
			If Empty( cConta )
				FWrite( nHdlLog, 'Tipo de arquivo [' + SubStr( cLine, 48, 2 ) + '] não aderente ao processo CIELO [' + cArquivo + '].' + CRLF )
				FT_FUSE()
				Return
			Endif
			aProc[ 1 ] := aProc[ 1 ] + ';' + Iif( Empty( cConta ), 'CTA_NÃO_IDENTIF', cConta )
			
		Elseif SubStr(cLine,1,1) == '1'
			cDtBx 	 := '20'+SubStr(cLine,32,6)	   //Data prevista de pagamento.
			cStatus	 := Iif( SubStr(cLine,86,1) == '-', 'C', 'B' ) //Se negativo é chargeback, do contrário é baixa.
			cBandeira := SubStr( cLine, 185, 3 ) 
			
			IF cBandeira == '001'
				cNaturBand := '01'
			ElseIF cBandeira == '002'
				cNaturBand := '02'
			ElseIF cBandeira == '003'
				cNaturBand := '03'
			Else
				cNaturBand := '00'
			EndIF

			IF cBandeira == '000' //Futuro código 040 - HIPERCARD (Julho/2018)
				nB := AScan( aBandeiras, {|cValue| SubStr( cValue, 1, 3 ) == '040' } )
				If nB > 0
					cBandeira := SubStr( aBandeiras[ nB ], 5 )
				Endif	
			ElseIF .NOT. Empty( cBandeira )
				nB := AScan( aBandeiras, {|cValue| SubStr( cValue, 1, 3 ) == cBandeira } )
				If nB > 0
					cBandeira := SubStr( aBandeiras[ nB ], 5 )
				Endif
			Endif

			 
			aProc[ 1 ] := aProc[ 1 ] + ';' + cDtBx + ';' + cStatus+' '+cBandeira
			
		Elseif SubStr(cLine,1,1) == '2'
			cPv		:= SubStr( cLine, 2, 10 )   //numero do estabelecimento de venda
			cCart 	:= iIF( !lVendaCIELO, SubStr( cLine, 19, 16 ), SubStr( cLine, 19, 19 ) )  //numero do cartao, se for compra e-commerce é uma string de zeros.
			cDtCpr	:= SubStr( cLine, 38, 8 )   //data da compra
			cTipReg	:= Iif(SubStr( cLine, 46, 1 ) ==  '-' , 'C', 'B' )   //identificador do tipo de baixa. C (-) por cancelamento, B (+)
			cVlrP 	:= SubStr( cLine, 47, 13 )  //valor de compra, se parcelado, valor da parcela
			cParc 	:= SubStr( cLine, 60, 2 )   // o numero da parcela atual, zero é venda a vista
			cProxPrc := SubStr( cLine, 62, 2 )   // Total de parcelas, zero é venda a vista
			cAutC 	 := SubStr( cLine, 67, 6 )  	//Codigo de autenticacao
			cTID     := SubStr( cLine, 73, 20 ) //ID da transacao para compras e-commerce.
			cDoc     := iIF( !lVendaCIELO, Iif(SubStr( cLine, 46, 1 ) == '-' , ' ', SubStr( cLine, 93, 6 ) ), SubStr( cLine, 93, 6 ) ) //Numero do documento.
			                                                                              //Não tem numero de documento para Cancelamentos. 
			                                                                              //Apenas codigo de autorização.
			cPedido	:= Alltrim( SubStr( cLine, 163, 20 ) ) // Pedido informado na transação

			// Se não houver parcela significa que o valor bruto é o valor da operação.
			If cParc == '00'
				cVlrBrutoV := cVlrP
			Else
				cVlrBrutoV := SubStr( cLine, 114, 13 ) // Valor Bruto da Venda.
			Endif
			
			nSaldo	:= Val( cVlrP ) / 100
			
			aProc[ 1 ] := aProc[ 1 ] + ';' + cPV + ';' + cCart + ';' + cDtCpr + ';' + cTipReg + ';' + ;
			LTrim( Str( Val( cVlrP )/100, 12, 2 ) ) + ';' + cParc + ';' + cProxPrc + ';' + cAutC + ';' + cTid + ';' + cDoc
						
			If ( (cStatus == 'C' .AND. cTipReg == 'C') .Or. (cStatus == 'B' .AND. cTipReg == 'B') ) .AND. !lVendaCIELO
				
				nRecAtu := nLine
				
				aParam := {cCart,cAutC,cVlrP,cParc,cDtCpr,nSaldo,cDtBx,cTipReg,nHandle,cArqLog/*nHdlLog*/,'',nRecAtu,cSomLog,cArquivo,cPv,cTID,;
					NIL,cConta,cDoc,cPedSite,cBandeira}
				
				If cStatus == "B" .And. cTipReg == "B" .And. !lVendaCIELO
					aadd(aParam,aProc)	//22
				Else
					aAdd(aParam,Nil)	//22
				EndIf

				U_GTPutIN(Iif(Empty(cTID),cDoc,cTID),"J",cDoc,.T.,{"CCBAIFIN",cTid,cAutC,cDoc, cArquivo,aProc},cDoc,,)

				//U_CCBAIFIN( cTID, aParam )
				
				nTime := Seconds()
				While .t.

					If U_Send2Proc(Iif(Empty(cTID),cDoc,cTID),"U_CCBAIFIN",aParam)

						Exit
					Else

						nWait := Seconds()-nTime
						If nWait < 0
							nWait += 86400
						Endif

						If nWait > 15
							// Passou de 3 minutos tentando ? Desiste !
							U_GTPutOUT(Iif(Empty(cTID),cDoc,cTID),"J",cDoc,{"CCBAIFIN","Inconsistência realizar distribuicao para CCBAIFIN",aProc[1]},cDoc)
							
							EXIT
						Endif

						// Espera um pouco ( 5 segundos ) para tentar novamente

						Sleep(5000)

					EndIf

				EndDo			
				
			Elseif lVendaCIELO
			
			   AAdd( aVENDA, {  cPedido,;
				   				cCart,;
				   				cTID,;
								cDoc,;
								cAutC,;
								cBandeira,;
								cProxPrc,;
								cNaturBand,;
								'Arquivo: ' + RTrim( cArquivo ) + ' linha: ' + LTrim( Str( nLine ) ) } )
				
			Else
				FWrite( nHdlLog, 'Linha '+PadL(LTrim(Str(nLine)),5,' ')+' do arquivo ' + cArquivo + 'não se refere a crédito' + CRLF  )
				aProc[ 1 ] := aProc[ 1 ] + 'Linha ;'+PadL(LTrim(Str(nLine)),5,' ')+'; do arquivo ' + cArquivo + '; não se refere a crédito.'
			Endif
		Endif
		
		aProc[ 1 ] := aProc[ 1 ] + CRLF
		FWrite( nHdlProc, aProc[ 1 ] )
		aProc := { cArquivo + ';' + 'CIELO' }

		FT_FSKIP()
	End
	FT_FUSE()

	IF Len( aVENDA ) > 0
		A740InfoCartao( aVENDA )
	EndIF
Return

//--------------------------------------------------------------------------
// Rotina | A740Rede   | Autor | Rafael Beghini       | Data | 22.11.2018
//--------------------------------------------------------------------------
// Descr. | Rotina para processar o lay-out RedeCard
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A740Rede( cArquivo )
	Local aRV		:= {}
	Local aMOV		:= {}
	Local aCHA		:= {}
	Local cTOTLIN	:= ''
	Local cLine		:= ''
	Local cVersao	:= ''
	Local cPV 		:= ''
	Local cPVMatriz	:= ''
	Local cRV 		:= ''
	Local cBanco	:= ''
	Local cAgen		:= ''
	Local cConta	:= ''
	Local cDtRV		:= ''
	Local cBandeira	:= ''
	Local cCartao	:= ''
	Local cStatus	:= ''
	Local cNSU		:= ''
	Local cAutC 	:= ''
	Local cParcela	:= ''
	Local cTID 		:= ''
	Local cPedSite	:= ''
	Local cTerminal	:= ''
	Local dDtRV 	:= CTOD('//')
	Local nLine		:= 0
	Local nPosCC	:= 0
	Local nPosRV	:= 0
	Local nPosCHA	:= 0
	Local nValor	:= 0
	Local nVNSU		:= 0
	Local nQtdNSU	:= 0
	Local nVLiqParc	:= 0	
	Local nVDemaisP	:= 0	
	
	FT_FUSE( cArquivo )
	cTOTLIN := LTrim( Str( FT_FLASTREC()+1 ) )
	oProc:SetRegua2( Val( cTOTLIN ) )
	FT_FGOTOP()
	
	While .NOT. FT_FEOF()
		nLine++
		
		oProc:IncRegua2( 'Processando ' + LTrim( Str( nLine ) ) + ' linhas de ' + cTOTLIN + ' no total.' )
				
		cLine := FT_FREADLN()

		IF Left(cLine,3) == '002' //-- Header
			cVersao		:= SubStr( cLine, 102, 20 )			

		ElseIF Left(cLine,3) == '004' .And. 'EEVC' $ cVersao //-- Matriz ponto de venda
			cPVMatriz	:= SubStr( cLine, 004, 09 )

		ElseIF Left(cLine,3) $ '006,008,034' .And. 'EEVC' $ cVersao//-- RV Rotativo
			IF Left(cLine,3) == '006'
				cPV 		:= SubStr( cLine, 004, 09 ) //-- Número do Ponto de Vendas
				cRV 		:= SubStr( cLine, 013, 09 ) //-- Número do Resumo de Vendas
				cBanco		:= SubStr( cLine, 022, 03 ) //-- Banco
				cAgen		:= SubStr( cLine, 025, 05 ) //-- Agência
				cConta		:= SubStr( cLine, 030, 11 ) //-- Conta corrente
				cDtRV		:= SubStr( cLine, 041, 08 ) //-- Data do Resumo (DDMMAAAA)
				dDtRV	 	:= STOD( Right(cDtRV,4) + SubStr(cDtRV,3,2) + SubStr(cDtRV,1,2) )
				nQtdNSU		:= Val( SubStr( cLine, 049, 05 ) ) //-- Quantidade de CV/NSUs 	** IMPORTANTE PARA ANALISAR O REGISTRO SEGUINTE 034 **
				nVBruto		:= Val( SubStr( cLine, 054, 15 ) ) / 100 //-- Valor Bruto 			
				nVRejeita	:= Val( SubStr( cLine, 084, 15 ) ) / 100 //-- Valor Rejeitado 			
				nVDesc		:= Val( SubStr( cLine, 099, 15 ) ) / 100 //-- Valor Desconto			
				nVLiq		:= Val( SubStr( cLine, 114, 15 ) ) / 100 //-- Valor Liquido 			
				cBandeira	:= SubStr( cLine, 137, 01 ) //-- Bandeira
				
				IF Len( aRV ) == 0 .OR. aRV[ Len( aRV ), 1 ] <> cPVMatriz .OR. aRV[ Len( aRV ), 2 ] <> cPV .OR. aRV[ Len( aRV ), 3 ] <> cRV
					aADD( aRV, { cPVMatriz, cPV, cRV, dDtRV, nQtdNSU, nVBruto, nVRejeita, nVDesc, nVLiq, cBandeira, '006', {} } )
				EndIF

			ElseIF Left(cLine,3) == '008'
				nVNSU 		:= Val( SubStr( cLine, 038, 15 ) ) / 100 //-- Valor do CV/NSU
				cCartao		:= SubStr( cLine, 068, 16 ) //-- Número do cartão
				cParcela	:= '01'
				cNSU		:= lTrim( Str( Val(SubStr( cLine, 087, 12 )) ) ) //-- Número do CV/NSU
				cAutC 		:= lTrim( Str( Val(SubStr( cLine, 127, 06 )) ) ) //-- Número de autorização
				nVLiqParc	:= Val( SubStr( cLine, 204, 15 ) ) / 100 //-- Valor Líquido
				nVDemaisP	:= nVLiqParc
				cTerminal	:= SubStr( cLine, 219, 08 )	//-- Número do terminal

				nPosRV := aScan( aRV, { |r| r[1] == cPVMatriz .And. r[2] == cPV .And. r[3] == cRV } )

				IF Len( aRV[nPosRV,12] ) == 0
					aADD( aRV[nPosRV,12], {nVNSU, cCartao, cNSU, cAutC, cParcela, nVLiqParc, nVDemaisP, cTerminal, '', ''} )
				Else
					IF nPosRV > 0
						aADD( aRV[nPosRV,12], {nVNSU, cCartao, cNSU, cAutC, cParcela, nVLiqParc, nVDemaisP, cTerminal, '', ''} )
					EndIF
				EndIF

			ElseIF Left(cLine,3) == '034'
				cCartao		:= SubStr( cLine, 045, 16 ) //-- Número do cartão
				cNSU		:= lTrim( Str( Val(SubStr( cLine, 061, 12 )) ) ) //-- Número do CV/NSU
				cTID 		:= SubStr( cLine, 079, 20 )	//-- TID
				cPedSite	:= SubStr( cLine, 099, 30 )	//-- Número do Pedido
				
				nPosRV := aScan( aRV, { |r| r[1] == cPVMatriz .And. r[2] == cPV .And. r[3] == cRV } )
				IF nPosRV > 0
					nPosCC := aScan( aRV[nPosRV,12], { |c| c[2] == cCartao .And. c[3] == cNSU } )
					IF nPosCC > 0
						aRV[nPosRV,12,nPosCC,09] := cTID
						aRV[nPosRV,12,nPosCC,10] := rTRim( cPedSite )
					Else
						aADD( aRV[nPosRV,12], {nVNSU, cCartao, cNSU, cAutC, cParcela, nVLiqParc, nVDemaisP, cTerminal, cTID, cPedSite} )
					EndIF
				EndIF
			EndIF

		ElseIF Left(cLine,3) $ '010,012,035' .And. 'EEVC' $ cVersao //-- RV Parcelado
			IF Left(cLine,3) == '010'
				cPV 		:= SubStr( cLine, 004, 09 ) //-- Número do Ponto de Vendas
				cRV 		:= SubStr( cLine, 013, 09 ) //-- Número do Resumo de Vendas
				cBanco		:= SubStr( cLine, 022, 03 ) //-- Banco
				cAgen		:= SubStr( cLine, 025, 05 ) //-- Agência
				cConta		:= SubStr( cLine, 030, 11 ) //-- Conta corrente
				cDtRV		:= SubStr( cLine, 041, 08 ) //-- Data do Resumo (DDMMAAAA)
				dDtRV	 	:= STOD( Right(cDtRV,4) + SubStr(cDtRV,3,2) + SubStr(cDtRV,1,2) )
				nQtdNSU		:= Val( SubStr( cLine, 049, 05 ) ) //-- Quantidade de CV/NSUs 	** IMPORTANTE PARA ANALISAR O REGISTRO SEGUINTE 034 **
				nVBruto		:= Val( SubStr( cLine, 054, 15 ) ) / 100 //-- Valor Bruto 			
				nVRejeita	:= Val( SubStr( cLine, 084, 15 ) ) / 100 //-- Valor Rejeitado 			
				nVDesc		:= Val( SubStr( cLine, 099, 15 ) ) / 100 //-- Valor Desconto			
				nVLiq		:= Val( SubStr( cLine, 114, 15 ) ) / 100 //-- Valor Liquido 			
				cBandeira	:= SubStr( cLine, 137, 01 ) //-- Bandeira
								
				IF Len( aRV ) == 0 .OR. aRV[ Len( aRV ), 1 ] <> cPVMatriz .OR. aRV[ Len( aRV ), 2 ] <> cPV .OR. aRV[ Len( aRV ), 3 ] <> cRV
					aADD( aRV, { cPVMatriz, cPV, cRV, dDtRV, nQtdNSU, nVBruto, nVRejeita, nVDesc, nVLiq, cBandeira, '010', {} } )
				EndIF

			ElseIF Left(cLine,3) == '012'
				nVNSU 		:= Val( SubStr( cLine, 038, 15 ) ) / 100 //-- Valor do CV/NSU
				cCartao		:= SubStr( cLine, 068, 16 ) //-- Número do cartão
				cParcela	:= SubStr( cLine, 087, 02 ) //-- Número de parcelas
				cNSU		:= lTrim( Str( Val(SubStr( cLine, 089, 12 )) ) ) //-- Número do CV/NSU
				cAutC 		:= lTrim( Str( Val(SubStr( cLine, 129, 06 )) ) ) //-- Número de autorização
				nVLiqParc	:= Val( SubStr( cLine, 221, 15 ) ) / 100 //-- Valor da primeira parcela
				nVDemaisP	:= Val( SubStr( cLine, 236, 15 ) ) / 100 //-- Valor das demais parcelas
				cTerminal	:= SubStr( cLine, 251, 08 )	//-- Número do terminal

				nPosRV := aScan( aRV, { |r| r[1] == cPVMatriz .And. r[2] == cPV .And. r[3] == cRV } )

				IF Len( aRV[nPosRV,12] ) == 0
					aADD( aRV[nPosRV,12], {nVNSU, cCartao, cNSU, cAutC, cParcela, nVLiqParc, nVDemaisP, cTerminal, '', ''} )
				Else
					IF nPosRV > 0
						aADD( aRV[nPosRV,12], {nVNSU, cCartao, cNSU, cAutC, cParcela, nVLiqParc, nVDemaisP, cTerminal, '', ''} )
					EndIF
				EndIF
			ElseIF Left(cLine,3) == '035'
				cCartao		:= SubStr( cLine, 045, 16 ) //-- Número do cartão
				cNSU		:= lTrim( Str( Val(SubStr( cLine, 061, 12 )) ) ) //-- Número do CV/NSU
				cTID 		:= SubStr( cLine, 079, 20 )	//-- TID
				cPedSite	:= SubStr( cLine, 099, 30 )	//-- Número do Pedido

				nPosRV := aScan( aRV, { |r| r[1] == cPVMatriz .And. r[2] == cPV .And. r[3] == cRV } )
				IF nPosRV > 0
					nPosCC := aScan( aRV[nPosRV,12], { |c| c[2] == cCartao .And. c[3] == cNSU } )
					IF nPosCC > 0
						aRV[nPosRV,12,nPosCC,09] := cTID
						aRV[nPosRV,12,nPosCC,10] := rTRim( cPedSite )
					Else
						aADD( aRV[nPosRV,12], {nVNSU, cCartao, cNSU, cAutC, cParcela, nVLiqParc, nVDemaisP, cTerminal, cTID, cPedSite} )
					EndIF
				EndIF
			EndIF
		ElseIF Left(cLine,3) $ '030,032,034,035' //-- Extrato de Movimentacao Financeira 053 - ChargeBack
			
			IF Left(cLine,3) == '030' //-- Header
				cVersao		:= SubStr( cLine, 106, 20 )
			
			ElseIF Left(cLine,3) == '032' .And. 'EEFI' $ cVersao //-- Matriz
				cPVMatriz	:= SubStr( cLine, 004, 09 )
			
			ElseIF Left(cLine,3) == '034' .And. 'EEFI' $ cVersao //-- Ordem de Crédito
				cPV			:= SubStr( cLine, 004, 09 ) //-- Número do Ponto de Vendas
				cRV 		:= SubStr( cLine, 076, 09 ) //-- Número do Resumo de Vendas
				cNumDoc		:= SubStr( cLine, 013, 11 ) //-- Número do documento (Ordem de pagamento)
				cData		:= SubStr( cLine, 024, 08 ) //-- Data do Lançamento (DDMMAAAA)
				dData		:= STOD( Right(cData,4) + SubStr(cData,3,2) + SubStr(cData,1,2) )
				nValor		:= Val( SubStr( cLine, 032, 15 ) ) / 100 //-- Valor do lançamento
				cTpReg		:= 'B' 						//-- Credito, para o CCBAIFIN passar como 'B' - Baixa/ Recebimento normal/Compensação
				cDtRV		:= SubStr( cLine, 085, 08 ) //-- Data do Resumo (DDMMAAAA)
				dDtRV		:= STOD( Right(cDtRV,4) + SubStr(cDtRV,3,2) + SubStr(cDtRV,1,2) )
				cBandeira	:= SubStr( cLine, 093, 01 ) //-- Bandeira
				cTransacao	:= SubStr( cLine, 094, 01 ) //-- Tipo de transação
				cParcela	:= SubStr( cLine, 125, 05 ) //-- Número parcela / total

				aADD( aMOV, { cPVMatriz, cPV, cRV, dData, nValor, cTpReg, cNumDoc, dDtRV, cBandeira, cTransacao, cParcela, '034', '', '', '', '', '', ''} )

			ElseIF Left(cLine,3) == '035' .And. 'EEFI' $ cVersao //-- Ajustes Net e Desagendamento
				cPV			:= SubStr( cLine, 138, 09 ) //-- Número do Ponto de Vendas
				cRV 		:= SubStr( cLine, 100, 09 ) //-- Número do Resumo de Vendas original
				cNumDoc		:= SubStr( cLine, 258, 11 ) //-- Número do documento (Ordem de débito)
				cData		:= SubStr( cLine, 022, 08 ) //-- Data do Lançamento (DDMMAAAA)
				dData		:= STOD( Right(cData,4) + SubStr(cData,3,2) + SubStr(cData,1,2) )
				nValor		:= Val( SubStr( cLine, 030, 15 ) ) / 100 //-- Valor do lançamento
				cTpReg		:= 'C' 						//-- Debito, para o CCBAIFIN passar como 'C' - Baixa ChargeBack
				cDtRV		:= SubStr( cLine, 171, 08 ) //-- Data do Resumo (DDMMAAAA)
				dDtRV		:= STOD( Right(cDtRV,4) + SubStr(cDtRV,3,2) + SubStr(cDtRV,1,2) )
				cBandeira	:= SubStr( cLine, 300, 01 ) //-- Bandeira
				cTpAjuste	:= SubStr( cLine, 046, 02 ) //-- Motivo do ajuste (cód. da tabela III)
				cDescAjuste	:= SubStr( cLine, 048, 28 ) //-- Motivo do ajuste (string - tabela III)
				cCartao		:= SubStr( cLine, 076, 16 ) //-- Número do cartão
				cNSU		:= lTrim( Str( Val(SubStr( cLine, 239, 12 )) ) ) //-- Número do CV/NSU
				cAutC 		:= lTrim( Str( Val(SubStr( cLine, 251, 06 )) ) ) //-- Número de autorização				
				cTpDebito	:= SubStr( cLine, 257, 01 ) //-- Tipo de débito Total ou Parcial

				aADD( aMOV, { cPVMatriz, cPV, cRV, dData, nValor, cTpReg, cNumDoc, dDtRV, cBandeira, '', '', '035', cTpAjuste, cDescAjuste, cTpDebito, cCartao, cNSU, cAutC } )
				
				//-- Armazenar somente quando for cancelamento cartão e não Taxa Administrativa
				//-- onde serão lançadas o valor de ChargeBack por bandeira, ordem e RV;
				IF .NOT. Empty( cCartao )
					nPosCHA := aScan( aCHA, { |r| r[1] == cPV .And. r[2] == cRV .And. r[3] == cNumDoc .And. r[4] == cBandeira } )
					IF nPosCHA > 0
						aCHA[ nPosCHA, 6 ] += nValor
					Else
						aADD( aCHA, { cPV, cRV, cNumDoc, cBandeira, dDtRV, nValor } )
					EndIF
				EndIF
			EndIF
		EndIF

		FT_FSKIP()
	End
	FT_FUSE()

	IF Len( aRV ) > 0
		A740RedeGrv( cVersao, cArquivo, aRV )
	EndIF

	IF Len( aMOV ) > 0
		A740RedeMov( cVersao, cArquivo, aMOV )
	EndIF

	IF Len( aCHA ) > 0
		A740RedeCHA( aCHA )		
	EndIF
	
Return

//---------------------------------------------------------------------------------
// Rotina | A740RedeGrv    | Autor | Rafael Beghini     | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Registra o resumo de venda
//---------------------------------------------------------------------------------
Static Function A740RedeGrv( cVersao, cArquivo, aRV )
	Local cTOTLIN	:= ''
	Local cTOTCC	:= ''
	Local cNameFile	:= SubStr( cArquivo, Rat('\',cArquivo) + 1, Len( cArquivo) )
	Local nP		:= 0
	Local nX		:= 0
	Local nY		:= 0
	Local nLine		:= 0
	Local nCartao	:= 0
	Local nLenCC	:= 0
	Local nParcelas	:= 0
	Local nVParc	:= 0
	Local nVLiqParc	:= 0

	cTOTLIN := LTrim( Str( Len( aRV ) ) )
	oProc:SetRegua1( Val( cTOTLIN ) )

	//-- PBR_FILIAL + PBR_PVMAT + PBR_PV + PBR_RV + DTOS(PBR_DATA)
	PBR->( dbSetOrder(1) )
	PBS->( dbSetOrder(1) )

	Begin Transaction
		For nX := 1	To Len( aRV )
			nLine++
			oProc:IncRegua1( 'Gravando resumo de venda ' + LTrim( Str( nLine ) ) + ' de ' + cTOTLIN + ' no total.' )	

			IF .NOT. PBR->( dbSeek( xFilial('PBR') + aRV[nX,1] + aRV[nX,2] + aRV[nX,3] + DTOS( aRV[nX,4] ) ) )
				PBR->( RecLock('PBR',.T.) )
					PBR->PBR_FILIAL := xFilial('PBR')
					PBR->PBR_PVMAT 	:= aRV[ nX, 01 ]
					PBR->PBR_PV		:= aRV[ nX, 02 ]
					PBR->PBR_RV		:= aRV[ nX, 03 ]
					PBR->PBR_DATA	:= aRV[ nX, 04 ]
					PBR->PBR_QTDCV	:= aRV[ nX, 05 ]
					PBR->PBR_VALBRT	:= aRV[ nX, 06 ]
					PBR->PBR_VALREJ	:= aRV[ nX, 07 ]
					PBR->PBR_VLDESC	:= aRV[ nX, 08 ]
					PBR->PBR_VALLIQ	:= aRV[ nX, 09 ]
					PBR->PBR_BANDEI	:= aRV[ nX, 10 ]
					PBR->PBR_TIPORE	:= aRV[ nX, 11 ]
					PBR->PBR_VERSAO := cVersao
					PBR->PBR_FILE	:= rTRim( cNameFile )
					PBR->PBR_ADIQUIR:= '1'
				PBR->( MsUnlock() )

				nLenCC := Len( aRV[ nX, 12 ] )
				cTOTCC := LTrim( Str( nLenCC ) )
				oProc:SetRegua2( nLenCC )

				For nY := 1 To nLenCC
					nCartao++
					oProc:IncRegua2( 'Processando cartão ' + LTrim( Str( nCartao ) ) + ' de ' + cTOTCC + ' para o resumo número: ' + LTrim( Str( nLine ) ) )

					nParcelas := Val( aRV[nX, 12, nY, 5] )
					For nP := 1 To nParcelas
						PBS->( RecLock('PBS',.T.) )
							PBS->PBS_FILIAL := xFilial('PBS')
							PBS->PBS_PVMAT	:= aRV[ nX, 1 ]
							PBS->PBS_PV	    := aRV[ nX, 2 ]
							PBS->PBS_RV	    := aRV[ nX, 3 ]
							PBS->PBS_DATA	:= aRV[ nX, 4 ]
							PBS->PBS_VLRNSU	:= aRV[nX, 12, nY, 01]
							PBS->PBS_NUMSEQ	:= nCartao
							PBS->PBS_CARTAO := aRV[nX, 12, nY, 02]
							PBS->PBS_NSU 	:= aRV[nX, 12, nY, 03]
							PBS->PBS_CODAUT := aRV[nX, 12, nY, 04]
							PBS->PBS_TID 	:= aRV[nX, 12, nY, 09]
							PBS->PBS_PSITE 	:= aRV[nX, 12, nY, 10]							
							PBS->PBS_PARCEL := nP
							PBS->PBS_QTPARC := nParcelas
							nVParc			:= aRV[nX, 12, nY, 01] / nParcelas
							IF nP > 1
								nVLiqParc	:= aRV[nX, 12, nY, 07]
							Else
								nVLiqParc	:= aRV[nX, 12, nY, 06]
							EndIF
							PBS->PBS_VALOR 	:= nVParc
							PBS->PBS_VALLIQ := nVLiqParc
							PBS->PBS_VLDESC := nVParc - nVLiqParc
							PBS->PBS_TAXA	:= NoRound( ( (nVParc - nVLiqParc) / nVParc ) * 100 )
							PBS->PBS_TERMIN	:= aRV[nX, 12, nY, 08]
						PBS->( MsUnlock() )
					Next nP					
				Next nY
			Else
				FWrite( nHdlLog, 'Resumo de venda: ' + aRV[nX,3] + ' existente na base.' )
				aProc[ 1 ] := aProc[ 1 ] + 'Resumo de venda: ' + aRV[nX,3] + ' existente na base.'
			EndIF
			nCartao		:= 0
			nParcelas	:= 0
		Next nX
	End Transaction

Return

//---------------------------------------------------------------------------------
// Rotina | A740RedeMov    | Autor | Rafael Beghini     | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Registra o retorno do arquivo ( Movimentação financeira )
//---------------------------------------------------------------------------------
Static Function A740RedeMov( cVersao, cArquivo, aMOV )
	Local cTOTLIN	:= ''
	Local cTOTCC	:= ''
	Local cSeek		:= ''
	Local cTipo		:= ''
	Local cNameFile	:= SubStr( cArquivo, Rat('\',cArquivo) + 1, Len( cArquivo) )
	Local lSeek		:= .F.
	Local nX		:= 0
	Local nY		:= 0
	Local nLine		:= 0
	Local nCartao	:= 0
	Local nLenCC	:= 0
	Local nParcelas	:= 0
	Local nVParc	:= 0
	Local nVLiqParc	:= 0
	Local aMOVFI	:= {}

	cTOTLIN := LTrim( Str( Len( aMOV ) ) )
	oProc:SetRegua1( Val( cTOTLIN ) )

	PBT->( dbSetOrder(3) )

	Begin Transaction
		For nX := 1 To Len( aMOV )
			nLine++
			oProc:IncRegua1( 'Gravando movimento financeiro ' + LTrim( Str( nLine ) ) + ' de ' + cTOTLIN + ' no total.' )	
			
			cTipo := iIF( aMOV[ nX, 06 ] == 'B', 'C', 'D' )
			//-- PBT_PVMAT+PBT_PV+PBT_RV+DTOS(PBT_DATA)+PBT_TIPO+PBT_TIPORE+PBT_TPAJUS+PBT_CARTAO+PBT_NSU+PBT_CODAUT
			cSeek := aMOV[nX,1] + aMOV[nX,2] + aMOV[nX,3] + DTOS( aMOV[nX,4] ) + cTipo + aMOV[nX,12] + aMOV[nX,13] + aMOV[nX,16] + aMOV[nX,17] + aMOV[nX,18]

			lSeek := .NOT. PBT->( dbSeek( xFilial('PBT') + cSeek ) )
			PBT->( RecLock('PBT',lSeek) )
				PBT->PBT_FILIAL := xFilial('PBT')
				PBT->PBT_PVMAT 	:= aMOV[ nX, 01 ]
				PBT->PBT_PV		:= aMOV[ nX, 02 ]
				PBT->PBT_RV		:= aMOV[ nX, 03 ]
				PBT->PBT_DATA	:= aMOV[ nX, 04 ]
				PBT->PBT_VALOR 	:= aMOV[ nX, 05 ]
				PBT->PBT_TIPO 	:= cTipo
				PBT->PBT_NUMDOC	:= aMOV[ nX, 07 ]
				PBT->PBT_DATARV	:= aMOV[ nX, 08 ]
				PBT->PBT_BANDEI	:= aMOV[ nX, 09 ]
				PBT->PBT_TIPOTR	:= aMOV[ nX, 10 ]
				PBT->PBT_PARCEL	:= aMOV[ nX, 11 ]
				PBT->PBT_TIPORE	:= aMOV[ nX, 12 ]
				PBT->PBT_TPAJUS	:= aMOV[ nX, 13 ]
				PBT->PBT_DESCAJ	:= aMOV[ nX, 14 ]
				PBT->PBT_TIPODB	:= aMOV[ nX, 15 ]
				PBT->PBT_CARTAO	:= aMOV[ nX, 16 ]
				PBT->PBT_NSU	:= aMOV[ nX, 17 ]
				PBT->PBT_CODAUT	:= aMOV[ nX, 18 ]
				PBT->PBT_VERSAO	:= cVersao
				PBT->PBT_FILE  	:= cNameFile
				PBT->PBT_ADIQUI	:= '1'
			PBT->( MsUnlock() )	

			aAdd( aMOVFI, aMOV[ nX ] )			
		Next nX
	End Transaction

	IF Len( aMOVFI ) > 0
		A740RedeNCC( aMOVFI, cNameFile )
	EndIF
Return

//---------------------------------------------------------------------------------
// Rotina | A740RedeNCC    | Autor | Rafael Beghini     | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Processa as títulos para geração da NCC (CCBaiFin)
//---------------------------------------------------------------------------------
Static Function A740RedeNCC( aTRB, cNameFile )
	Local nL		:= 0
	Local nTaxa		:= 0
	Local nTime		:= 0
	Local nWait		:= 0
	Local cSQL		:= ''
	Local cTRB		:= ''
	Local cParc		:= ''
	Local cBandeira	:= ''
	Local cE5_HIST	:= ''
	Local cNumTID	:= ''
	Local cPedSite	:= ''
	Local lSend2Proc:= GetMv( cMV_740_04, .F. ) == '1'	
	Local aParam	:= {}

	DbSelectArea('PBU')

	For nL := 1 To Len( aTRB )
		oProc:IncRegua1( 'Efetuando lançamentos a crédito' )
		
		//-- Lançamento de taxa Administrativa
	 	IF aTRB[ nL, 6 ] = 'C' .And. Empty( aTRB[ nL, 16 ] )
			A740RedeSE5( aTRB[nL,05], aTRB[nL,04], 'PV: ' + aTRB[ nL, 02 ] + ', Resumo: ' +  aTRB[ nL, 03 ], aTRB[nL,13] + ': ' + aTRB[nL,14], aTRB[nL,03], aTRB[nL,09] )
		Else
			cSQL := ''
			cSQL := "SELECT PBS.* " + CRLF
			cSQL += "FROM " + RetSqlName('PBR') + " PBR " + CRLF
			cSQL += "       INNER JOIN " + RetSqlName('PBS') + " PBS " + CRLF
			cSQL += "               ON PBS_FILIAL = PBR_FILIAL " + CRLF
			cSQL += "                  AND PBS_PVMAT = PBR_PVMAT " + CRLF
			cSQL += "                  AND PBS_PV = PBR_PV " + CRLF
			cSQL += "                  AND PBS_RV = PBR_RV " + CRLF
			
			IF aTRB[ nL, 6 ] = 'B'
				cSQL += "              AND PBS_PARCEL = '" + Left(aTRB[ nL, 11 ],2) + "' " + CRLF				
			Else
				cSQL += "              AND PBS_CARTAO 	= '" + aTRB[ nL, 16 ] + "' " + CRLF
				cSQL += "              AND PBS_NSU 		= '" + aTRB[ nL, 17 ] + "' " + CRLF
				cSQL += "              AND PBS_CODAUT 	= '" + aTRB[ nL, 18 ] + "' " + CRLF
			EndIF

			cSQL += "WHERE  PBR.D_E_L_E_T_ = ' ' " + CRLF
			cSQL += "       AND PBR_FILIAL = '" + xFilial('PBR') + "' " + CRLF
			cSQL += "       AND PBR_PVMAT 	= '" + aTRB[ nL, 01 ] + "' " + CRLF
			cSQL += "       AND PBR_PV 		= '" + aTRB[ nL, 02 ] + "' " + CRLF
			cSQL += "       AND PBR_RV 		= '" + aTRB[ nL, 03 ] + "' " + CRLF
			IF aTRB[ nL, 6 ] = 'B'
				cSQL += "       AND PBR_BANDEI 	= '" + aTRB[ nL, 09 ] + "' " + CRLF
			EndIF

			cTRB := GetNextAlias()
			cSQL := ChangeQuery( cSQL )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

			While .NOT. (cTRB)->( EOF() )
				PBS->( dbGoto( (cTRB)->R_E_C_N_O_ ) )
				
				PBS->( RecLock('PBS',.F.) )
					IF aTRB[ nL, 6 ] = 'B'
						PBS->PBS_NUMDOC := aTRB[ nL, 07 ]
						PBS->PBS_DTLCTO := aTRB[ nL, 04 ]
					Else
						PBS->PBS_NUMCAN := aTRB[ nL, 07 ]
						PBS->PBS_DTCANC := aTRB[ nL, 08 ]
					EndIF
				PBS->( MsUnlock() )
				
				IF aTRB[ nL, 6 ] = 'B' 
					nTaxa += (cTRB)->PBS_VLDESC
				EndIF
				cParc := IiF( (cTRB)->PBS_QTPARC > 1, (cTRB)->PBS_PARCEL, 00 ) 

				cNumTID	 := (cTRB)->PBS_TID
				cPedSite := (cTRB)->PBS_PSITE
				
				//aParam := {cCart,cAutC,cVlrP,cParc,cDtCpr,nSaldo,cDtBx,cTipReg,nHandle,nHdlLog,NIL,nRecAtu,cSomLog,cArquivo,cPv,cTID,;
				//	NIL,cConta,cDoc,cPedSite,cBandeira,aProc,nRecnoPBS}
				(cTRB)->( aParam := { PBS_CARTAO,PBS_CODAUT,PBS_VALOR,cParc,PBS_DATA,PBS_VALOR,aTRB[nL,04],aTRB[ nL, 6 ],0,cArqLog,PBS_RV,0,'0',cNameFile,;
										PBS_PV,PBS_TID,NIL,'REDE',aTRB[nL,07],PBS_PSITE,aTRB[nL,09],NIL,R_E_C_N_O_ } )							
				
				aParam[ 1 ] := StrTran( aParam[1], 'X', '*' )
				aParam[ 4 ] := cValToChar( aParam[4] )
				aParam[ 7 ] := dToS( aParam[7] )

				(cTRB)->( U_GTPutIN( PBS_TID, "J", PBS_PSITE, .T.,{"CCBAIFIN - Rede" + iIF( aTRB[ nL, 6 ] == 'B', '', ' cancelamento' ) ,PBS_TID,PBS_CODAUT,aTRB[nL,07], cNameFile},PBS_PSITE,,) )
				
				IF !lSend2Proc
					U_CCBAIFIN( (cTRB)->PBS_TID, aParam )
				Else
					nTime := Seconds()
					While .T.
						IF U_Send2Proc( (cTRB)->PBS_TID, "U_CCBAIFIN", aParam )
							Exit
						Else
							nWait := Seconds()-nTime
							If nWait < 0
								nWait += 86400
							Endif

							If nWait > 15
								// Passou de 3 minutos tentando ? Desiste !
								U_GTPutOUT( cNumTID, "J", cPedSite, {"CCBAIFIN","Inconsistência realizar distribuicao para CCBAIFIN - Rede"}, cPedSite )
								EXIT
							Endif
							Sleep(5000)
						EndIf
					EndDo
				EndIF
				
				(cTRB)->( dbSkip() )
				
				aParam	:= {}				
    		End
			(cTRB)->( dbCloseArea() )
			FErase( cTRB + GetDBExtension() )

			IF nTaxa > 0
				PBU->( dbSeek( xFilial('PBU') + aTRB[ nL, 09 ] ) )
				cBandeira 	:= rTrim(PBU->PBU_DESC)
				cE5_HIST	:= 'Tarifa REDE - ' + cBandeira
				A740RedeSE5( nTaxa, aTRB[nL,04], 'PV: ' + aTRB[ nL, 02 ] + ', Resumo: ' +  aTRB[ nL, 03 ], cE5_HIST, aTRB[nL,07], aTRB[nL,09] )
			EndIF
		EndIF
		
		nTaxa		:= 0
		cBandeira	:= ''
		cE5_HIST	:= ''
	Next nL
Return

//---------------------------------------------------------------------------------
// Rotina | A740RedeSE5    | Autor | Rafael Beghini     | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Gera movimento financeiro referente a Taxa
//---------------------------------------------------------------------------------
Static Function A740RedeSE5( nTaxa, dDataLcto, cDocumento, cHistorico, cOrdemPgto, cBandeira )
	Local aFINA100	:= {}
	Local aRet		:= {}
	Local aBco		:= StrTokArr( GetMv( cMV_740_02, .F. ), ';' )
	Local cBanco	:= aBco[ 1 ] //-- '000'
	Local cAgencia	:= aBco[ 2 ] //-- '00000'
	Local cConta	:= aBco[ 3 ] //-- 'REDECARD'
	Local cNatureza	:= GetMv( cMV_740_03, .F. ) //-- 'SF520001'
	Local cSQL		:= ''
	Local cTRB		:= ''
	Local lProc		:= .F.
	Private lMsErroAuto := .F.

	cSQL += "SELECT COUNT(*) AS REC" + CRLF
	cSQL += "FROM " + RetSqlName('SE5') + " SE5 " + CRLF
	cSQL += "WHERE SE5.D_E_L_E_T_= ' '" + CRLF
	cSQL += "AND E5_FILIAL 	= '" + xFilial('SE5') + "' " + CRLF
	cSQL += "AND E5_DATA 	= '" + DtoS(dDataLcto) + "' " + CRLF
	cSQL += "AND E5_TIPO 	= ' '" + CRLF
	cSQL += "AND E5_MOEDA 	= 'M1'" + CRLF
	cSQL += "AND E5_NATUREZ = '" + cNatureza + "' " + CRLF
	cSQL += "AND E5_BANCO 	= '" + cBanco + "' " + CRLF
	cSQL += "AND E5_AGENCIA = '" + cAgencia + "' " + CRLF
	cSQL += "AND E5_CONTA 	= '" + cConta + "' " + CRLF
	cSQL += "AND E5_DOCUMEN = '" + Alltrim(cDocumento) + "' " + CRLF
	cSQL += "AND E5_RECPAG 	= 'P'" + CRLF
	cSQL += "AND E5_HISTOR 	= '" + Alltrim(cHistorico) + "' " + CRLF
	cSQL += "AND E5_SITUACA = ' '" + CRLF

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	lProc := ( (cTRB)->REC == 0 )
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

	IF lProc
		aFINA100 := {	{"E5_DATA"		, dDataLcto     ,Nil},;
						{"E5_MOEDA"     , "M1"          ,Nil},;
						{"E5_VALOR"     , nTaxa         ,Nil},;
						{"E5_NATUREZ"	, cNatureza     ,Nil},;
						{"E5_BANCO"		, cBanco        ,Nil},;
						{"E5_AGENCIA"	, cAgencia      ,Nil},;
						{"E5_CONTA"		, cConta        ,Nil},;
						{"E5_DOCUMEN"	, cDocumento	,Nil},;
						{"E5_HISTOR"    , cHistorico    ,Nil} }
		
		MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
		
		If lMsErroAuto
			Aadd( aRet, .F.)
			Aadd( aRet, "E00026" )
			Aadd( aRet, cDocumento )
			Aadd( aRet, "Falha na inclusão movimento bancário")
			Aadd( aRet, cHistorico)
			Aadd( aRet, 'Bandeira (PBU): ' + cBandeira)
			U_GTPutOUT(cOrdemPgto,"J",cOrdemPgto,{"A740RedeSE5",aRet},cOrdemPgto)
		EndIf
	EndIF
Return

//---------------------------------------------------------------------------------
// Rotina | A740RedeCHA    | Autor | Rafael Beghini     | Data | 06.12.2018
//---------------------------------------------------------------------------------
// Descr. | Gera movimento financeiro referente a Chargeback
//---------------------------------------------------------------------------------
Static Function A740RedeCHA( aCHA )
	Local aFINA100	:= {}
	Local aRet		:= {}
	Local aBco		:= StrTokArr( GetMv( cMV_740_02, .F. ), ';' )
	Local cBanco	:= aBco[ 1 ] //-- '000'
	Local cAgencia	:= aBco[ 2 ] //-- '00000'
	Local cConta	:= aBco[ 3 ] //-- 'REDECARD'
	Local cNatureza	:= GetMv( cMV_740_05, .F. ) //-- 'FT030003'
	Local cBandeira	:= ''
	Local cE5_DOC	:= ''
	Local cE5_HIST	:= ''
	Local nI		:= 0
	Local cSQL		:= ''
	Local cTRB		:= ''
	Local lProc		:= .F.
	Private lMsErroAuto := .F.

	DbSelectArea('PBU')
	
	For nI := 1 To Len( aCHA )
		oProc:IncRegua1( 'Efetuando lançamentos a débito' )
		PBU->( dbSeek( xFilial('PBU') + aCHA[nI,4] ) )
		cBandeira := rTrim(PBU->PBU_DESC)
		cE5_DOC 	:= 'RV: ' + aCHA[nI,2] + ', Débito: ' + aCHA[nI,3]
		cE5_HIST	:= 'Tarifa REDE - ' + cBandeira

		cSQL := ""
		cSQL += "SELECT COUNT(*) AS REC" + CRLF
		cSQL += "FROM " + RetSqlName('SE5') + " SE5 " + CRLF
		cSQL += "WHERE SE5.D_E_L_E_T_= ' '" + CRLF
		cSQL += "AND E5_FILIAL 	= '" + xFilial('SE5') + "' " + CRLF
		cSQL += "AND E5_DATA 	= '" + DtoS( aCHA[ nI, 5 ] ) + "' " + CRLF
		cSQL += "AND E5_TIPO 	= ' '" + CRLF
		cSQL += "AND E5_MOEDA 	= 'M1'" + CRLF
		cSQL += "AND E5_NATUREZ = '" + cNatureza + "' " + CRLF
		cSQL += "AND E5_BANCO 	= '" + cBanco + "' " + CRLF
		cSQL += "AND E5_AGENCIA = '" + cAgencia + "' " + CRLF
		cSQL += "AND E5_CONTA 	= '" + cConta + "' " + CRLF
		cSQL += "AND E5_DOCUMEN = '" + Alltrim(cE5_DOC) + "' " + CRLF
		cSQL += "AND E5_RECPAG 	= 'P'" + CRLF
		cSQL += "AND E5_HISTOR 	= '" + Alltrim(cE5_HIST) + "' " + CRLF
		cSQL += "AND E5_SITUACA = ' '" + CRLF

		cTRB := GetNextAlias()
		cSQL := ChangeQuery( cSQL )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

		lProc := ( (cTRB)->REC == 0 )
		(cTRB)->( dbCloseArea() )
		FErase( cTRB + GetDBExtension() )
		IF lProc
			aFINA100 := {	{"E5_DATA"		, aCHA[ nI, 5 ] ,Nil},;
							{"E5_MOEDA"     , "M1"          ,Nil},;
							{"E5_VALOR"     , aCHA[ nI, 6 ] ,Nil},;
							{"E5_NATUREZ"	, cNatureza     ,Nil},;
							{"E5_BANCO"		, cBanco        ,Nil},;
							{"E5_AGENCIA"	, cAgencia      ,Nil},;
							{"E5_CONTA"		, cConta        ,Nil},;
							{"E5_DOCUMEN"	, cE5_DOC		,Nil},;
							{"E5_HISTOR"    , cE5_HIST    	,Nil} }
			MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
		
			If lMsErroAuto
				Aadd( aRet, .F.										)
				Aadd( aRet, "E00026" 								)
				Aadd( aRet, cE5_DOC 								)
				Aadd( aRet, "Falha na inclusão movimento bancário"	)
				Aadd( aRet, cE5_HIST								)
				U_GTPutOUT( aCHA[nI,3], "J", aCHA[nI,3], {"A740RedeCHA",aRet}, aCHA[nI,3] )
			EndIf
			lMsErroAuto := .F.
			aFINA100	:= {}
		EndIF
	Next nI

Return

//---------------------------------------------------------------------------------
// Rotina | A740XBOX    | Autor | Rafael Beghini     | Data | 22.11.2018
//---------------------------------------------------------------------------------
// Descr. | Rotina para retornar as opções da Bandeira cartão (PBR_BANDEIRA)
//        | Chamada está sendo feita no campo na coluna X3_CBOX 
//---------------------------------------------------------------------------------
User Function A740XBOX()
	Local cRET	:= ''
	Local cSQL	:= ''
	Local cTRB	:= ''
	Local aArea	:= GetArea()
	
	cSQL += "SELECT PBU_COD," + CRLF
	cSQL += "       PBU_DESC" + CRLF
	cSQL += "FROM " + RetSqlName('PBU') + " PBU " + CRLF
	cSQL += "WHERE  PBU.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "       AND PBU_FILIAL = ' ' " + CRLF
	cSQL += "ORDER  BY PBU_COD  " + CRLF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	
	IF .NOT. (cTRB)->( EOF() ) 
		While .NOT. (cTRB)->( EOF() )
			cRET += Alltrim( (cTRB)->PBU_COD ) + '=' + Alltrim( (cTRB)->PBU_DESC ) + ';'
			(cTRB)->( dbSkip() )
		End
		cRET := SubString( cRet, 1, Len(cRet) - 1 )
	EndIF
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	RestArea( aArea )
	
Return(cRET)

//-----------------------------------------------------------------------
// Rotina | A740REDE  | Autor | Rafael Beghini     | Data | 23.11.2018
//-----------------------------------------------------------------------
// Descr. | Rotina de update para criar as tabelas PBR,PBS,PBT
//-----------------------------------------------------------------------
User Function A740REDE()
	Local cModulo	:= 'FIN'
	Local bPrepar	:= {|| U_A740Table() }
	Local nVersao	:= 2
	Local bFinish	:= {|| MsgInfo('Processo Executado com sucesso.','A740REDE') }
	Local bVerEmp	:= {|| .T. }
	Local cObs		:= 'Update para criação das tabelas PBR,PBS,PBT - Resumo de Vendas - RedeCard'

	U_UpdProtheus(cModulo,bPrepar,nVersao,bFinish,bVerEmp,cObs)
Return

//-----------------------------------------------------------------------
// Rotina | UZ16Ini    | Autor | Rafael Beghini     | Data | 14.12.2017
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
User Function A740Table()
	aSX2 := {}
	aSX3 := {}
	aSIX := {}
    //SX2
	AAdd(aSX2,{"PBR","","Resumo de Venda - Cartão"	,"Resumo de Venda - Cartão"	,"Resumo de Venda - Cartão"	,"C","",""})
	AAdd(aSX2,{"PBS","","Base conciliacao"			,"Base conciliacao"			,"Base conciliacao"			,"C","",""})
	AAdd(aSX2,{"PBT","","Movimento Financeiro"		,"Movimento Financeiro"		,"Movimento Financeiro"		,"C","",""})
	
	AAdd( aSX3, {"PBR",NIL,"PBR_FILIAL"	,"C",02,0,"Filial"			,"Sucursal"		,"Branch"		,"Filial do Sistema"		,"Sucursal"					,"Branch of the System"		,"@!"						,""	,"€€€€€€€€€€€€€€€","","",1,"þÀ","","","U","N",""	,"","","","","","","","","","033","","","","","","","","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_PVMAT"	,"C",09,0,"PV Matriz"		,"PV Matriz"	,"PV Matriz"	,"Ponto Venda matriz"		,"Ponto Venda matriz"		,"Ponto Venda matriz"		,"@!"						,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_PV"		,"C",09,0,"Ponto Venda"		,"Ponto Venda"	,"Ponto Venda"	,"Ponto Venda"				,"Ponto Venda"				,"Ponto Venda"				,"@!"						,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_RV"		,"C",09,0,"Resumo Venda"	,"Resumo Venda"	,"Resumo Venda"	,"Resumo Venda"				,"Resumo Venda"				,"Resumo Venda"				,"@!"						,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_DATA"	,"D",08,0,"Data Arquivo"	,"Data Arquivo"	,"Data Arquivo"	,"Data Arquivo"				,"Data Arquivo"				,"Data Arquivo"				,""							,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_QTDCV"	,"N",06,0,"QuantidadeCV"	,"QuantidadeCV"	,"QuantidadeCV"	,"Qtd Comprovante Venda"	,"Qtd Comprovante Venda"	,"Qtd Comprovante Venda"	,"999999"					,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_VALBRT"	,"N",15,2,"Valor Bruto"		,"Valor Bruto"	,"Valor Bruto"	,"Valor Bruto"				,"Valor Bruto"				,"Valor Bruto"				,"@E 999,999,999,999.99"	,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_VALREJ"	,"N",15,2,"VlrRejeitado"	,"VlrRejeitado"	,"VlrRejeitado"	,"Valor Rejeitado"			,"Valor Rejeitado"			,"Valor Rejeitado"			,"@E 999,999,999,999.99"	,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_VLDESC"	,"N",15,2,"Vlr Desconto"	,"Vlr Desconto"	,"Vlr Desconto"	,"Valor Desconto"			,"Valor Desconto"			,"Valor Desconto"			,"@E 999,999,999,999.99"	,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_VALLIQ"	,"N",15,2,"Vlr. Liquido"	,"Vlr. Liquido"	,"Vlr. Liquido"	,"Valor Liquido"			,"Valor Liquido"			,"Valor Liquido"			,"@E 999,999,999,999.99"	,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_BANDEI"	,"C",01,0,"Bandeira"		,"Bandeira"		,"Bandeira"		,"Bandeira do cartão"		,"Bandeira do cartão"		,"Bandeira do cartão"		,"@!"						,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","#U_A740XBOX()","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_TIPORE"	,"C",03,0,"TipoRegistro"	,"TipoRegistro"	,"TipoRegistro"	,"Tipo Registro"			,"Tipo Registro"			,"Tipo Registro"			,"@!"						,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_VERSAO"	,"C",20,0,"Versão"			,"Versão"		,"Versão"		,"Versão do arquivo"		,"Versão do arquivo"		,"Versão do arquivo"		,"@!"						,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_FILE"	,"C",30,0,"Nome arquivo"	,"Nome arquivo"	,"Nome arquivo"	,"Nome arquivo processado"	,"Nome arquivo processado"	,"Nome arquivo processado"	,"@!"						,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V"	,"R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBR",NIL,"PBR_ADIQUI"	,"C",01,0,"Adquirente"		,"Adquirente"	,"Adquirente"	,"Adquirente do processo"	,"Adquirente do processo"	,"Adquirente do processo"	,"@!"						,""	,"€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V"	,"R","","","1=RedeCard;","","","","","","","","","","","","N","N","","","","",""} )
	
	AAdd( aSX3, {"PBS",NIL,"PBS_FILIAL"	,"C",02,0,"Filial"			,"Sucursal"		,"Branch"		,"Filial do Sistema"		,"Sucursal"					,"Branch of the System"		,"@!","","€€€€€€€€€€€€€€€","","",1,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_PVMAT"	,"C",09,0,"PV Matriz"		,"PV Matriz"	,"PV Matriz"	,"Ponto Venda matriz"		,"Ponto Venda matriz"		,"Ponto Venda matriz"		,"@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_PV"		,"C",09,0,"Ponto Venda"		,"Ponto Venda"	,"Ponto Venda"	,"Ponto Venda"				,"Ponto Venda"				,"Ponto Venda"				,"@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_RV"		,"C",09,0,"Resumo Venda"	,"Resumo Venda"	,"Resumo Venda"	,"Resumo Venda"				,"Resumo Venda"				,"Resumo Venda"				,"@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_DATA"	,"D",08,0,"Data RV"			,"Data RV"		,"Data RV"		,"Data RV"					,"Data RV"					,"Data RV"					,""							,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_VLRNSU"	,"N",15,2,"Valor CV/NSU"	,"Valor CV/NSU"	,"Valor CV/NSU"	,"Valor CV/NSU"				,"Valor CV/NSU"				,"Valor CV/NSU"				,"@E 999,999,999,999.99"	,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_NUMSEQ"	,"N",06,0,"QuantidadeCV"	,"QuantidadeCV"	,"QuantidadeCV"	,"Qtd Comprovante Venda"	,"Qtd Comprovante Venda"	,"Qtd Comprovante Venda"	,"999999"					,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_CARTAO"	,"C",16,0,"Num Cartão"		,"Num Cartão"	,"Num Cartão"	,"Numero cartão transação"	,"Numero cartão transação"	,"Numero cartão transação"	,"@!"						,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_NSU"	,"C",12,0,"CV/NSU"			,"CV/NSU"		,"CV/NSU"		,"CV/NSU"					,"CV/NSU"					,"CV/NSU"					,"@!"						,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_CODAUT"	,"C",06,0,"Nº Autorizac"	,"Nº Autorizac"	,"Nº Autorizac"	,"Nº Autorizacao"			,"Nº Autorizacao"			,"Nº Autorizacao"			,"@!"						,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_TID"	,"C",20,0,"Numero TID"		,"Numero TID"	,"Numero TID"	,"Numero TID"				,"Numero TID"				,"Numero TID"				,"@!"						,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_PSITE"	,"C",10,0,"Pedido SITE"		,"Pedido SITE"	,"Pedido SITE"	,"Pedido SITE"				,"Pedido SITE"				,"Pedido SITE"				,"@!"						,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_PARCEL"	,"N",02,0,"Num Parcela"		,"Num Parcela"	,"Num Parcela"	,"Num Parcela"				,"Num Parcela"				,"Num Parcela"				,"99"						,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_QTPARC"	,"N",02,0,"Qtd Parcela"		,"Qtd Parcela"	,"Qtd Parcela"	,"Qtd Parcela"				,"Qtd Parcela"				,"Qtd Parcela"				,"99"						,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_VALOR"	,"N",15,2,"Valor"			,"Valor"		,"Valor"		,"Valor"					,"Valor"					,"Valor"					,"@E 999,999,999,999.99"	,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_VLDESC"	,"N",15,2,"Vlr Desconto"	,"Vlr Desconto"	,"Vlr Desconto"	,"Vlr Desconto"				,"Vlr Desconto"				,"Vlr Desconto"				,"@E 999,999,999,999.99"	,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_VALLIQ"	,"N",15,2,"Vlr Liquido"		,"Vlr Liquido"	,"Vlr Liquido"	,"Vlr Liquido"				,"Vlr Liquido"				,"Vlr Liquido"				,"@E 999,999,999,999.99"	,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_TAXA"	,"N",05,2,"Taxa (%)"		,"Taxa"			,"Taxa"			,"Taxa"						,"Taxa"						,"Taxa"						,"@E 99.99"					,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_TERMIN"	,"C",08,0,"Num terminal"	,"Num terminal"	,"Num terminal"	,"Numero do terminal"		,"Numero do terminal"		,"Numero do terminal"		,""							,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_NUMDOC"	,"C",11,0,"Num Document"	,"Num Document"	,"Num Document"	,"Num Documento"			,"Num Documento"			,"Num Documento"			,"@!"						,"","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_DTLCTO"	,"D",08,0,"Data Lancto"		,"Data Lancto"	,"Data Lancto"	,"Data do Lancamento"		,"Data do Lancamento"		,"Data do Lancamento"		,"","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_NUMCAN"	,"C",11,0,"Num Charge"		,"Num Charge"	,"Num Charge"	,"Num Charge"				,"Num Charge"				,"Num Charge"				,"@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_DTCANC"	,"D",08,0,"Data Lancto"		,"Data Lancto"	,"Data Lancto"	,"Data do Lancamento cancel","Data do Lancamento cancel","Data do Lancamento cancel","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_RECSC5"	,"N",15,0,"Recno SC5"		,"Recno SC5"	,"Recno SC5"	,"Recno SC5"				,"Recno SC5"				,"Recno SC5"				,"999999999999999","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_RECSE1"	,"N",15,0,"Recno SE1"		,"Recno SE1"	,"Recno SE1"	,"Recno SE1"				,"Recno SE1"				,"Recno SE1"				,"999999999999999","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBS",NIL,"PBS_RECSE5"	,"N",15,0,"Recno SE5"		,"Recno SE5"	,"Recno SE5"	,"Recno SE5"				,"Recno SE5"				,"Recno SE5"				,"999999999999999","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	
	AAdd( aSX3, {"PBT",NIL,"PBT_FILIAL"	,"C",02,0,"Filial","Sucursal","Branch","Filial do Sistema","Sucursal","Branch of the System","@!","","€€€€€€€€€€€€€€€","","",1,"þÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_PVMAT"	,"C",09,0,"PV Matriz","PV Matriz","PV Matriz","Ponto Venda matriz","Ponto Venda matriz","Ponto Venda matriz","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_PV"		,"C",09,0,"Ponto Venda","Ponto Venda","Ponto Venda","Ponto Venda","Ponto Venda","Ponto Venda","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_RV"		,"C",09,0,"Resumo Venda","Resumo Venda","Resumo Venda","Resumo Venda","Resumo Venda","Resumo Venda","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_DATA"	,"D",08,0,"Data Lancto","Data Lancto","Data Lancto","Data Lançamento","Data Lançamento","Data Lançamento","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_NUMDOC"	,"C",11,0,"Num Document","Num Document","Num Document","Numero documento","Numero documento","Numero documento","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_VALOR"	,"N",15,2,"Valor","Valor","Valor","Valor do lançamento","Valor do lançamento","Valor do lançamento","@E 999,999,999,999.99","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_TIPO"	,"C",01,0,"Tipo (C/D)","Tipo (C/D)","Tipo (C/D)","Tipo (C/D)","Tipo (C/D)","Tipo (C/D)","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_DATARV"	,"D",08,0,"Data RV","Data RV","Data RV","Data RV","Data RV","Data RV","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_BANDEI"	,"C",01,0,"Bandeira","Bandeira","Bandeira","Bandeira do cartão","Bandeira do cartão","Bandeira do cartão","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","#U_A740XBOX()","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_TIPOTR"	,"C",01,0,"Transação","Transação","Transação","Tipo da transação","Tipo da transação","Tipo da transação","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","1=À vista;2=Parcelado s Juros;3=Parcelado IATA;4=Rotativo dólar;5=CDC;6=Pré-datada;7=Trishop;8=Construcard;","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_PARCEL"	,"C",05,0,"Num parcela","Num parcela","Num parcela","Numero da parcela","Numero da parcela","Numero da parcela","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_TIPORE"	,"C",03,0,"TipoRegistro","TipoRegistro","TipoRegistro","Tipo Registro","Tipo Registro","Tipo Registro","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_TPAJUS"	,"C",02,0,"Tipo Ajuste","Tipo Ajuste","Tipo Ajuste","Tipo Ajuste","Tipo Ajuste","Tipo Ajuste","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_DESCAJ"	,"C",28,0,"Desc. Ajuste","Desc. Ajuste","Desc. Ajuste","Descrição do Ajuste","Descrição do Ajuste","Descrição do Ajuste","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_CARTAO"	,"C",16,0,"Num Cartão","Num Cartão","Num Cartão","Numero cartão transação","Numero cartão transação","Numero cartão transação","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_NSU"	,"C",12,0,"CV/NSU","CV/NSU","CV/NSU","CV/NSU","CV/NSU","CV/NSU","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_CODAUT"	,"C",06,0,"Nº Autorizac","Nº Autorizac","Nº Autorizac","Nº Autorizacao","Nº Autorizacao","Nº Autorizacao","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_TIPODB"	,"C",01,0,"Tipo Débito","Tipo Débito","Tipo Débito","TDébito -Total ou Parcial","TDébito -Total ou Parcial","TDébito -Total ou Parcial","","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_VERSAO"	,"C",20,0,"Versão","Versão","Versão","Versão do arquivo","Versão do arquivo","Versão do arquivo","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_FILE"	,"C",30,0,"Nome arquivo","Nome arquivo","Nome arquivo","Nome arquivo processado","Nome arquivo processado","Nome arquivo processado","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","","",""} )
	AAdd( aSX3, {"PBT",NIL,"PBT_ADIQUI"	,"C",01,0,"Adquirente","Adquirente","Adquirente","Adquirente do processo","Adquirente do processo","Adquirente do processo","@!","","€€€€€€€€€€€€€€ ","","",0,"þÀ","","","U","N","V","R","","","1=RedeCard;","","","","","","","","","","","","N","N","","","","",""} )
	
	//SIX
	AAdd(aSIX,{"PBR","1","PBR_FILIAL+PBR_PVMAT+PBR_PV+PBR_RV+DTOS(PBR_DATA)","PV Matriz+Ponto Venda+Resumo Venda+Data arquivo","","","U","S"})

	AAdd(aSIX,{"PBS","1","PBS_FILIAL+PBS_PVMAT+PBS_PV+PBS_RV+DTOS(PBS_DATA)","PV Matriz+Ponto Venda+Resumo Venda+Data arquivo","","","U","S"})

	AAdd(aSIX,{"PBT","1","PBT_FILIAL+PBT_PVMAT+PBT_PV+PBT_RV+DTOS(PBT_DATA)","PV Matriz+Ponto Venda+Resumo Venda+Data Lancto","","","U","S"})
	AAdd(aSIX,{"PBT","2","PBT_FILIAL+PBT_PV+PBT_NUMDOC","Ponto Venda+Num Document","","","U","S"})
	AAdd(aSIX,{"PBT","3","PBT_FILIAL+PBT_PVMAT+PBT_PV+PBT_RV+DTOS(PBT_DATA)+PBT_TIPO+PBT_TIPORE+PBT_TPAJUS","PV Matriz+Ponto Venda+Resumo Venda+Data Lancto+Tipo (C/D)+TipoRegistro","","","U","S"})

Return

//-----------------------------------------------------------------------
// Rotina | A740InfoCartao | Autor | Rafael Beghini   | Data | 18.03.2019
//-----------------------------------------------------------------------
// Descr. | Rotina para gravar dados do cartão para casos em que o Hub
//		  | não envia corretamente as informações.
//-----------------------------------------------------------------------
Static Function A740InfoCartao( aTRB )
	Local aErro	 	:= {}
	Local aNaturez	:= {}
	Local cNaturez	:= GetMv( 'MV_XNATVST', .F. )
	Local cC5Fil 	:= xFilial('SC5')
	Local nTReg	 	:= Len( aTRB )
	Local nPosNt	:= 0
	Local nL	 	:= 0
	Local nLine	 	:= 1	

	aNaturez := StrTokArr(cNaturez,",")

	oProc:SetRegua2( nTReg )

	SC5->( DbOrderNickName("PEDSITE") )
	For nL := 1 To Len( aTRB )
		oProc:IncRegua2( 'Atualizando informações ' + LTrim( Str( nLine ) ) + ' de ' + LTrim( Str( nTReg ) ) + ' no total.' )

		IF SC5->( dbSeek( cC5Fil + aTRB[nL,1] ) )

			SC5->( RecLock( "SC5", .F. ) )
				SC5->C5_XCARTAO := Alltrim( aTRB[ nL,2 ] )
				SC5->C5_XNUMCAR := Alltrim( aTRB[ nL,2 ] )
				SC5->C5_XTIDCC  := aTRB[ nL,3 ]
				SC5->C5_XDOCUME := aTRB[ nL,4 ]
				SC5->C5_XCODAUT := aTRB[ nL,5 ]
				SC5->C5_XBANDEI	:= aTRB[ nL,6 ]
				SC5->C5_XNPARCE	:= iiF( aTRB[ nL,7 ] == '00', '1', aTRB[ nL,7 ] )

				If ValType(aNaturez)=="A" .and. Len(aNaturez) > 0
					nPosNt := ascan(aNaturez,{|x| SubStr(alltrim(x),1,2) == Alltrim(Strzero(Val( aTRB[ nL,8 ] ),2)) })
					If nPosNt > 0
						cNaturez := Right(alltrim(aNaturez[nPosNt]),8)
					Else	
						cNaturez := "FT010017"
					EndIf
				Else
					cNaturez := "FT010017"					
				EndIf

				SC5->C5_XNATURE	:= cNaturez
			SC5->( MsUnLock() )

		Else
			aAdd( aErro, aTRB[nL] )
			FWrite( nHdlLog, 'Pedido '+ aTRB[nL,1] + ' do arquivo ' + cArquivo + 'não localizado' + CRLF  )
			aProc[ 1 ] := aProc[ 1 ] + 'Pedido ;'+aTRB[nL,1]+'; do arquivo ' + cArquivo + '; não localizado.'
			
			FWrite( nHdlProc, aProc[ 1 ] )
			aProc := { cArquivo + ';' + 'CIELO' }
		Endif
	Next nL	

Return

/*
PROCESSO REDECARD

A) LEITURA PARA O TIPO ROTATIVO
006 - LOTE
	008 - COMPROVANTE DE VENDA
		034 - CV/NSU Rotativo -- Mesma quantidade de linhas para o item 008

006
	cPV 		:= SubStr( cLine, 004, 09 ) //-- Número do Ponto de Vendas
	cRV 		:= SubStr( cLine, 013, 09 ) //-- Número do Resumo de Vendas
	cBanco		:= SubStr( cLine, 022, 03 ) //-- Banco
	cAgen		:= SubStr( cLine, 025, 05 ) //-- Agência
	cConta		:= SubStr( cLine, 030, 11 ) //-- Conta corrente
	cDtRV		:= SubStr( cLine, 041, 08 ) //-- Data do Resumo (DDMMAAAA)
	cQtdNSU		:= SubStr( cLine, 049, 05 ) //-- Quantidade de CV/NSUs 	** IMPORTANTE PARA ANALISAR O REGISTRO SEGUINTE 034 **
	cVBruto		:= SubStr( cLine, 054, 15 ) //-- Valor Bruto 			
	cVDesc		:= SubStr( cLine, 099, 15 ) //-- Valor Desconto			
	cVLiq		:= SubStr( cLine, 114, 15 ) //-- Valor Liquido 			
	cBandeira	:= SubStr( cLine, 137, 01 ) //-- Bandeira
008
	cDtVenda	:= SubStr( cLine, 022, 08 ) //-- Data do CV/NSU
	cValor 		:= SubStr( cLine, 038, 15 ) //-- Valor do CV/NSU
	cCartao		:= SubStr( cLine, 068, 16 ) //-- Número do cartão
	cStatus		:= SubStr( cLine, 084, 03 ) //-- Status do cartão
	cNSU		:= SubStr( cLine, 087, 12 ) //-- Número do CV/NSU
	cAutC 		:= SubStr( cLine, 127, 06 )	//-- Número de autorização
034
	cTID 		:= SubStr( cLine, 079, 20 )	//-- TID
	cPedSite	:= SubStr( cLine, 099, 30 )	//-- Número do Pedido

B) LEITURA PARA O TIPO PARCELADO SEM JUROS
010 - LOTE (IGUAL 006)
	012 - COMPROVANTE DE VENDA
		035 - CV/NSU Parcelado -- Mesma quantidade de linhas para o item 012
			014 - Infomações da parcela - NÃO PRECISA


012
	cDtBx		:= SubStr( cLine, 022, 08 ) //-- Data do CV/NSU
	cValor 		:= SubStr( cLine, 038, 15 ) //-- Valor do CV/NSU
	cCartao		:= SubStr( cLine, 068, 16 ) //-- Número do cartão
	cStatus		:= SubStr( cLine, 084, 03 ) //-- Status do cartão
	cParcela	:= SubStr( cLine, 087, 02 ) //-- Número de parcelas
	cNSU		:= SubStr( cLine, 089, 12 ) //-- Número do CV/NSU
	cAutC 		:= SubStr( cLine, 129, 06 )	//-- Número de autorização
	cValParc	:= SubStr( cLine, 129, 06 )	//-- Valor da parcela
035
	cTID 		:= SubStr( cLine, 079, 20 )	//-- TID
	cPedSite	:= SubStr( cLine, 099, 30 )	//-- Número do Pedido
014
	cNumParc	:= SubStr( cLine, 038, 02 )	//-- Número da parcela

*/

Static Function CSMailSend(cDest, cAssunto, cHTML, cArquivo )

    Local cMail     := GetMv("MV_RELACNT")
    Local cPass     := GetMv("MV_RELPSW")
    Local cSMTP     := GetMV("MV_RELSERV")                                     // SMTP DO E-MAIL
    Local cLog      := Space(0)                                             // LOGS DE ERRO
    Local nPort     := 0                                                    // PORTA DE COMUNICAÇÃO
    Local nSecurity := 2                                                    // TIPO DE SEGURANÇA
    Local nTimeOut  := 60                                                   // TEMPO DE REQUISIÇÃO
    Local xRet      := .T.                                                  // RETORNO/VALIDADOR
    Local lSecurity	:= GetMV("MV_RELSSL") 
    Local oServer   := TMailManager():New()                                 // CLIENTE DO SERVIDOR DE E-MAIL
    Local oMessage  := TMailMessage():New()                                 // CONSTRUTOR DA MENSAGEM

    //Controle para definir tipo de segurança
    If lSecurity
    	nSecurity := 1
    ElseIf GetMV("MV_RELTLS")
    	nSecurity := 2
    Else
    	nSecurity := 0
    EndIf

    // DEFINE A SEGURANÇA DA COMUNICAÇÃO COM O SMTP
    If (nSecurity == 0)
        nPort := 25 // PORTA PADRÃO DE COMUNICAÇÃO DO SMTP
    ElseIf (nSecurity == 1)
        nPort := 465 // PORTA PARA COMUNICAÇÃO DO SMTP COM SSL
        oServer:SetUseSSL(.T.)
    Else
        nPort := 587 // PORTA PARA COMUNICAÇÃO DO SMTP COM TLS
        oServer:SetUseTLS(.T.)
    EndIf

    BEGIN SEQUENCE
        // INICIA A CONEXÃO COM O SERVIDOR SMTP
        xRet := oServer:Init(cSMTP, cSMTP, cMail, cPass, /*nPOP3Port*/, nPort)
        If (!xRet == 0)
            cLog := NoAcento("Não foi possível estabelecer a conexão com o servidor: ") + oServer:GetErrorString(xRet)
            BREAK
        EndIf

        // DEFINE O TEMPO MÁXIMO DA REQUISIÇÃO
        xRet := oServer:SetSMTPTimeOut(nTimeOut)
        If (!xRet == 0)
            cLog := NoAcento("Não foi possível definir o time-out de ") + CValToChar(nTimeOut) + " segundos"
            BREAK
        EndIf

        // ESTABELECE A CONEXÃO COM O SERVIDOR SMTP
        xRet := oServer:SMTPConnect()
        If (!xRet == 0)
            cLog := NoAcento("Não foi possível estabelecer conexao com o servidor de SMTP: ") + oServer:GetErrorString(xRet)
            BREAK
        EndIf

        // REALIZA A AUTENTICAÇÃO NO SERVIDOR
        xRet := oServer:SMTPAuth(cMail, cPass)
        If (!xRet == 0)
            cLog := NoAcento("Não foi possível se autenticar no servidor de SMTP: ") + oServer:GetErrorString(xRet)
            BREAK
        EndIf

        // FORMATA O CORPO DA NOVA MENSAGEM
        oMessage:Clear()
        oMessage:cDate    := CValToChar(Date())
        oMessage:cFrom    := GetMV("MV_RELFROM")
        oMessage:cTo      := cDest
        oMessage:cSubject := cAssunto
        oMessage:cBody    := cHTML
        
        xRet := oMessage:AttachFile( cFile )
        If xRet < 0
        	cMsg := "Could not attach file " + cFile
        	conout( cMsg )
        EndIf

        // REALIZA O ENVIO DO E-MAIL
        xRet := oMessage:Send(oServer)
        If (!xRet == 0)
            cLog := NoAcento("Não foi possível realizar o envio da mensagem: ") + oServer:GetErrorString(xRet)
            BREAK
        EndIf

        // DESCONECTA DO SERVIDOR SMTP
        xRet := oServer:SMTPDisconnect()
        If (!xRet == 0)
            cLog := NoAcento("Não foi possível realizar a desconexão do servidor SMTP: ") + oServer:GetErrorString( xRet )
            BREAK
        EndIf

        ConOut(NoAcento("E-mail enviado como sucesso!"))
    RECOVER
        Final(cLog) 
    END SEQUENCE




Return 