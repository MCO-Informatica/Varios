#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"      

//---------------------------------------------------------------
/*/{Protheus.doc} csTotIp
Customizacao para realizar integracao entre Protheus e TOTAL IP
						  
@param	cQuery		Query a ser realizado o processamento
@return	lProcessa		Retorna se foi processado com sucesso ou nao.						

@author	Douglas Parreja
@since	26/06/2015
@version	11.8
/*/
//---------------------------------------------------------------
user function csTotIp( aParam, aReproc )

	local aFile	,aRet	:= {}
	local lAutoMsg		:= .T. //UsaAutoMsg()	      
	local lGerDiaria	:= .F.
	local lOk,lReproc	:= .F.
	local nX	 		:=  0
	local cTipo			:=  ""
	
	private cMVImp, cMVExp, nMVDia, nHndDB 
	private lInsert	:= .F.
	private cPedGar	:= ""
	private cExec 	:= "TOTAL_IP JOB(CSTOTIP)"
	private cProcImp:= "IMPORTACAO LISTA"
	private cProcExp:= "GERACAO CAMPANHA" 
	
	default aReproc := {}
	
	if lAutoMsg	
		 		
		////u_autoMsg( cExec, , "Iniciando JOB" )
		//----------------------	
		// Prepara ambiente
		//----------------------
		csPrepAmb( aParam ) //OK
	
		//----------------------	
		// Valida Upd/Ambiente
		//----------------------
		lOk := csCheckUpd() //OK
				
		if lOk		
			//-------------------------------------------------
			// Verifico se trata de Reprocessamento
			//-----------------------------------------------
			if len( aReproc ) > 0
				aRet := csValidReproc( aReproc )	
				if len( aRet ) > 0
					lReproc := aRet[1]
					cTipo 	:= aRet[2]
				endif					
			endif	
						
			if .NOT. lReproc  				
				//-------------------------------------------------
				// Verifico se tem arquivo para ser processado.
				//-------------------------------------------------
				aFile := csCheckArq()
				
				//-------------------------------------------------
				// Somente sera processado quando estiver arquivo
				// na pasta conforme o parametro MV_TOTARQI.
				//-------------------------------------------------
				if len(aFile) > 0 
					csProcess( aFile )	
				endif
				
				//-------------------------------------------------
				// Funcao para gerar a lista.                      
				// Realiza duas vezes para garantir a geracao da
				// lista de Aglutinacao e Diaria.
				//-------------------------------------------------     
				for nX := 1 to 2      
					if nX == 1
						csLista()
					else
						csLista( lGerDiaria )
					endif
				next
				
			//-------------------------------------------------
			// Reprocessamento Manual
			// Neste caso eh para caso ocorreu algum imprevisto
			// e sera preciso realizar o reprocessamento.
			// Chamada da funcao csReprocTotIp()
			//-------------------------------------------------
			else
				//---------------------------------------------
				// GERAL - Tipo Reprocessamento (Import/Insert)
				//---------------------------------------------
				if cTipo == "1"
					aFile := csCheckArq()
					if len(aFile) > 0 
						csProcess( aFile )	
					endif
					for nX := 1 to 2      
						if nX == 1
							csLista( .F., aRet )
						else
							csLista( lGerDiaria, aRet )
						endif
					next
				//---------------------------------------------
				// Importacao Arquivo - Tipo Reprocessamento
				//---------------------------------------------
				elseif cTipo == "2" 
					aFile := csCheckArq()
					if len(aFile) > 0 
						csProcess( aFile )	
					endif
				//---------------------------------------------
				// Insert/Export Dados - Tipo Reprocessamento
				//---------------------------------------------
				elseif cTipo == "3"
					for nX := 1 to 2      
						if nX == 1
							csLista( .F., aRet )
						else
							csLista( lGerDiaria, aRet )
						endif
					next				
				endif					
			endif
			
			////u_autoMsg( cExec, , "Finalizando JOB" )	
		endif
	endif
	
	RESET ENVIRONMENT                                   
		
return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csPrepAmb()
Funcao para preparar o ambiente

@param	aParam		Parametros empresa e filial

@author	Douglas Parreja
@since	10/07/2015
@version	11.8
/*/
//-----------------------------------------------------------------------
static function csPrepAmb( aParam )
	
	local cEmp		:= ""
	local cFil		:= ""
	
	////u_autoMsg( cExec, , "Preparando Ambiente")
	
	cEmp := IIf( aParam == NIL, '01' /*FWGrpCompany() 	'01'*/, aParam[ 1 ] )
	cFil := IIf( aParam == NIL, '02' /*FWCodFil() 		'02'*/, aParam[ 2 ] )
	
	//if IsBlind()
		RpcSetType( 3 )
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'TMK' TABLES 'SX5','SX6','SIX','SA1','AC8','SC5','SU5','SZX','SZG','SZF','ZZQ'
		
		////u_autoMsg( cExec, , "Ambiente preparado para Empresa: " +cEmp+ " - Filial: " +cFil)
	//endif
		
return	
//-----------------------------------------------------------------------
/*/{Protheus.doc} csCheckUpd()
Funcao que verifica se o update do TOTAL IP foi aplicado.

@return	lUpdOK		Verdadeiro se estiver ok o Update.

@author	Douglas Parreja
@since	13/07/2015
@version	11.8
/*/
//-----------------------------------------------------------------------
static function csCheckUpd()
 
	local lUpdOK	:= .F. 
	
	////u_autoMsg(cExec, , "Inicio verificacao base")
	
	if AliasIndic("SZX")
	
		lUpdOk := csValidaBase()
		////u_autoMsg(cExec, , "Termino verificacao base")
	else
		////u_autoMsg(cExec, ,'Nao eh possível continuar. Não existe a tabela SZX.' ) 
	endif 
	

return lUpdOK

//-----------------------------------------------------------------------
/*/{Protheus.doc} csValidaBase
Funcao que verifica se consta/configurado parametros e tabela.

@return	lOk		Retorna se o ambiente esta preparado para prosseguir.

@author	Douglas Parreja
@since	13/07/2015
@version	11.8
/*/
//-----------------------------------------------------------------------
static function csValidaBase()

	local cBarra	:= IIf(IsSrvUnix(),'/','\')
	//local cDirPrinc 	:= 'backup' + cBarra + 'admdados' + cBarra + 'log_dir' + cBarra		// Ex: \backup\admdados\log_dir\
	local cSystem	:= cBarra + 'system' + cBarra
	local lOk		:= .T.
	local cMVArqImp	:= 'MV_TOTARQI'				
	local cMVArqExp	:= 'MV_TOTARQE'
	local cMVTotDia	:= 'MV_TOTDIA'
	local cMVTotProc:= 'MV_TOTPROC'
	local cMVBDBanco:= 'MV_TOTBANC'
	local cMVBDServ	:= 'MV_TOTSERV'
	local cMVBDPort	:= 'MV_TOTPORT' 
	local cMVTotCamp:= 'MV_TOTCAMP'
	local cMVProc	:= ""
	local cMVCamp	:= ""

	//-------------------------------------------------------------------------------------------
	// MV_TOTARQI - caminho do arquivo importado pelo adm dados 
	//-------------------------------------------------------------------------------------------
	if !GetMV( cMVArqImp, .T. )
		CriarSX6( cMVArqImp, 'C', 'Endereco do arquivo importado pelo Adm Dados', cSystem )
		////u_autoMsg(cExec, , "criado parametro MV_TOTARQI - Endereco do arquivo importado pelo Adm Dados")
	endif
	cMVImp := GetMV(cMVArqImp) 
	if Empty( cMVImp )
		////u_autoMsg(cExec, ,'Nao eh possivel continuar. Parametro '+cMVArqImp+' sem conteudo.' )
		lOk := .F.
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_TOTARQE - caminho do arquivo aonde sera exportado
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVArqExp, .T. )
		CriarSX6( cMVArqExp, 'C', 'Endereco do arquivo a ser exportado pelo Protheus', cSystem )
		////u_autoMsg(cExec, , "criado parametro MV_TOTARQE - Endereco do arquivo a ser exportado pelo Protheus")
	endif
	cMVExp := GetMV(cMVArqExp)
	if Empty( cMVExp )
		////u_autoMsg(cExec, , 'Parametro '+cMVArqExp+' sem conteudo.' )
		// Nao eh retornado false caso nao tenha informacao no parametro, devido que por default sera
		// gerado na pasta system.
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_TOTDIA - calcula a quantidade de dias para realizar intervalo de ligacoes (INSERT)
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVTotDia, .T. )
		CriarSX6( cMVTotDia, 'N', 'Quantidade dias para realizar intervalo ligacoes', '20' )
		////u_autoMsg(cExec, , "criado parametro MV_TOTDIA - Quantidade dias para realizar intervalo ligacoes")
	endif
	nMVDia := GetMV(cMVTotDia)
	if Empty( nMVDia )
		////u_autoMsg(cExec, , 'Parametro '+cMVTotDia+' sem conteudo.' )
		// Nao eh retornado false caso nao tenha informacao no parametro, por default sera 20 conforme definido no escopo do Projeto.
	endif
		
	//-------------------------------------------------------------------------------------------
	// MV_TOTPROC - define aonde sera gerado o processamento (1=Geracao Arquivo/2=Insert Banco)
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVTotProc, .T. )
		CriarSX6( cMVTotProc, 'C', 'Define o processamento. 1=Arquivo 2=Insert TOTALIP', "2" )
		////u_autoMsg(cExec, , "criado parametro MV_TOTPROC - Define o processamento. 1=Arquivo 2=Insert TOTALIP")
	endif
	cMVProc := GetMV(cMVTotProc)
	if cMVProc == "2"
		lInsert	:= .T.
	endif
	if Empty( cMVProc )
		////u_autoMsg(cExec, , 'Parametro '+cMVTotProc+' sem conteudo.' )
		// Nao eh retornado false caso nao tenha informacao no parametro, por default sera 20 conforme definido no escopo do Projeto.
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_TOTBANC - Indica a string de conexao do DBAcess, composta por um identificador do 
	// tipo da conexao mais o nome do alias/enviroment da conexao, configurada do TOPConnect
	// ou DBAcess.
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVBDBanco, .T. )
		CriarSX6( cMVBDBanco, 'C', 'Indica o database e nome banco(postgres/totalip)', "Postgresql" )
		////u_autoMsg(cExec, , "criado parametro MV_TOTBANC - Indica o nome do Banco - conexao DBAcess")
	endif

	//-------------------------------------------------------------------------------------------
	// MV_TOTSERV - Indica o nome ou endereco IP do servidor onde esta o TOPConnect ou DBAcess 
	// onde a conexao deve ser realizada.
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVBDServ, .T. )
		CriarSX6( cMVBDServ, 'C', 'Endereco IP do servidor onde esta TOP ou DBAcess', "localhost" )
		////u_autoMsg(cExec, , "criado parametro MV_TOTSERV - Endereco IP do servidor onde esta TOP ou DBAcess")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_TOTPORT - Indica a porta do servidor onde esta o TOPConnect ou DBAcess 
	// onde a conexao deve ser realizada.
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVBDPort, .T. )
		CriarSX6( cMVBDPort, 'N', 'Porta do servidor onde esta TOP ou DBAcess', '7890' )
		////u_autoMsg(cExec, , "criado parametro MV_TOTPORT - Porta do servidor onde esta TOP ou DBAcess")
	endif
	
	//-------------------------------------------------------------------------------------------
	// MV_TOTCAMP - Define o valor id campanha referente ao banco do TotalIP.
	// Neste parametro eh que definira qual ID_CAMPANHA a ser importado na tabela IMPORTAR_DISCADOR
	//-------------------------------------------------------------------------------------------	
	if !GetMV( cMVTotCamp, .T. )
		CriarSX6( cMVTotCamp, 'C', 'ID campanhaTOTIP(1-FACESP,2-ESTADO,3-NAOPG,4-BASE)', ' ' )
		////u_autoMsg(cExec, , "criado parametro MV_TOTCAMP - Numero da campanha que consta no TOTALIP")
	endif
	cMVCamp := GetMV(cMVTotCamp)
	if Empty( cMVCamp )
		////u_autoMsg(cExec, ,'Nao eh possivel continuar. Parametro '+cMVTotCamp+' sem conteudo.' )
		lOk := .F.
	endif
	//-------------------------------------------------------------------------------------------
	// TaBELA SZX 
	//-------------------------------------------------------------------------------------------
	if AliasIndic("SZX")  
		cNome:= SubStr(Posicione('SX2',1,'SZX','X2_ARQUIVO'),4,5)
		if !( posicione("SX2",1,"SZX","X2_ARQUIVO") == ("SZX" + cNome) )			
			////u_autoMsg(cExec, ,'Nao eh possivel continuar. Existe a tabela SZX, mas obteve falha na validacao.' )
			lOk := .F.	
		endif
		DbSelectArea("SX3")
		DbSetOrder(2)	//X3_CAMPO
		if !dbSeek("ZX_STATUS") .Or. !dbSeek("ZX_NOMARQ") 
			////u_autoMsg(cExec, , 'Nao eh possivel continuar. Favor executar o compatibilizador UPDCSFA050 para criacao dos campos ZX_STATUS e ZX_NOMARQ.')
			lOk := .F.
		endif
	else
		////u_autoMsg(cExec, , 'Nao eh possivel continuar. Não existe a tabela SZX. Favor executar o compatibilizador UPDCSFA050' )
		lOk := .F.
	endif	
	//-------------------------------------------------------------------------------------------
	// TaBELA ZZQ
	//-------------------------------------------------------------------------------------------
	if AliasIndic("ZZQ")  
		cNome:= SubStr(Posicione('SX2',1,'ZZQ','X2_ARQUIVO'),4,5)
		if !( posicione("SX2",1,"ZZQ","X2_ARQUIVO") == ("ZZQ" + cNome) )			
			////u_autoMsg(cExec, ,'Nao eh possivel continuar. Existe a tabela ZZQ, mas obteve falha na validacao.' )
			lOk := .F.	
		endif
		DbSelectArea("SX3")
		DbSetOrder(2)	//X3_CAMPO
		if !dbSeek("ZZQ_AGLUT") .Or. !dbSeek("ZZQ_TELEF") .Or. !dbSeek("ZZQ_INPUT") .Or. !dbSeek("ZZQ_LISTA") .Or. !dbSeek("ZZQ_ORIGEM") 
			////u_autoMsg(cExec, , 'Nao eh possivel continuar. Favor executar o compatibilizador UPDCSFA050 para criacao dos campos ZZQ_AGLUT,ZZQ_TELEF,ZZQ_INPUT,ZZQ_LISTA e ZZQ_ORIGEM.')
			lOk := .F.
		endif
	else
		////u_autoMsg(cExec, , 'Nao eh possivel continuar. Não existe a tabela ZZQ. Favor executar o compatibilizador UPDCSFA050' )
		lOk := .F.
	endif	

return lOk

//-----------------------------------------------------------------------
/*/{Protheus.doc} csCheckArq()
Funcao que verifica se tem arquivo a ser processado

@return	aFile		Array contendo arquivos a serem processados.

@author	Douglas Parreja
@since	14/07/2015
@version	11.8
/*/
//-----------------------------------------------------------------------
static function csCheckArq()
	local aFile 	:= {}
	local cArq 		:= ''
	local cSystem	:= ''
	
	
	////u_autoMsg(cExec,cProcImp, "Inicio verificacao arquivo")
	//------------------------------------------------------------------
	// Diretório onde será processado o arquivo.
	//------------------------------------------------------------------
	cSystem := GetSrvProfString( 'Startpath', '' )
	
	//------------------------------------------------------------------
	// Buscar o arquivo com a seguinte extensão no diretório indicado.
	//------------------------------------------------------------------
	aFile := Directory( cMVImp + '*.csv' )
	
	//------------------------------------------------------------------
	// Verificar se encontrou algum arquivo.
	//------------------------------------------------------------------
	if Len( aFile ) > 0
		////u_autoMsg(cExec,cProcImp, "Arquivos enconstrados com sucesso na pasta")
		//--------------------------------------------------------------
		// Converter a data em string.
		//--------------------------------------------------------------
		AEval( aFile, {|p| p[3] := Dtos( p[3] ) } )
	else
		////u_autoMsg(cExec,cProcImp,"Nao possui arquivos a serem importados na pasta " + cMVImp )
	endif

return aFile
	
//-----------------------------------------------------------------------
/*/{Protheus.doc} csProcess()
Funcao para realizar o processamento

@param	aFile		Array contendo arquivos a serem processados.

@author	Douglas Parreja
@since	14/07/2015
@version	11.8
/*/
//-----------------------------------------------------------------------	
static function csProcess( aFile )

	local nX		 	:= 0 
	local lProcessou	:= .F.
	default aFile  		:= {}
	
	if len(aFile) > 0 
		////u_autoMsg(cExec,cProcImp, "Inicio Processamento do arquivo")
		
		for nX := 1 to len(aFile)
		
			//----------------------------------------------------------
			// Verificar se consta o arquivo na pasta informada
			//----------------------------------------------------------
			if File( cMVImp + aFile[ nX, 1 ] )
				////u_autoMsg(cExec,cProcImp, "Arquivo: " + aFile[ nX, 1 ] )	
				//------------------------------------------------------			
				// Processar o arquivo
				//------------------------------------------------------
				lProcessou := csProcArq( aFile[ nX, 1 ] )

				if lProcessou				
					//------------------------------------------------------
					// Apagar o arquivo do diretorio MV_TOTIMP
					//------------------------------------------------------
					FErase( cMVImp + aFile[ nX, 1 ] )
					Sleep( 500 )
					//------------------------------------------------------
					// Se nao apagou, registrar no log
					//------------------------------------------------------
					if File( cMVImp + aFile[ nX, 1 ] )
						////u_autoMsg(cExec,cProcImp,'Arquivo '+aFile[ nX, 1 ]+' processado NAO foi excluido da pasta ' + cMVImp )
						//A370Log( 0, 'Arquivo '+aFile[ 1, 1 ]+' processado não foi movido para a pasta ' + cMV370PATP + ', verificar.' )
					else
						// Se apagou, registrar no log.
						////u_autoMsg(cExec,cProcImp,'Arquivo '+aFile[ nX, 1 ]+' foi excluido da pasta ' + cMVImp + ' com sucesso. ' )
						//A370Log( 0, 'Arquivo '+aFile[ 1, 1 ]+' processado foi movido para a pasta ' + cMV370PATP + ' com sucesso.' )
					endif
				endif
			else
				//------------------------------------------------------
				// Registrar no log que não conseguiu copiar o arquivo.
				//------------------------------------------------------
				////u_autoMsg(cExec,cProcImp, 'Nao consta o arquivo ' + aFile[ 1, 1 ] + ' na pasta origem informada no parametro MV_TOTARQI ' + cMVImp )
			endif
		next
		
	else
		//------------------------------------------------------
		// Se não encontrou arquivo gerar log.
		//------------------------------------------------------
		////u_autoMsg(cExec,cProcImp,'Nao foi localizado nenhum arquivo de dados para ser processado.' )
	endif
	
return

//-----------------------------------------------------------------------
/*/{Protheus.doc} csProcArq()
Funcao para realizar o processamento do arquivo.

@param 	cArquivo		Arquivo 
@return	lGravou		Retorna se foi processado com sucesso ou nao.

@author	Douglas Parreja
@since	15/07/2015
@version	11.8
/*/
//-----------------------------------------------------------------------	
static function csProcArq( cArquivo )

	local cArqDados 		:= ''
	local cHeader 			:= ''
	local cDados 			:= ''
	local aHeader 			:= {}
	local aLinha 			:= {}
	local lGravou			:= .F.    
	local lProcessou		:= .F.

	private nLinha			:= 0
	private nCD_PEDIDO		:= 0
	private nNM_CLIENTE		:= 0
	private nDS_RAZAO_SOCIAL:= 0
	private nIC_RENOVACAO	:= 0
	private nNR_TELEFONE	:= 0
	private nDT_EXPIRACAO	:= 0
	private nCD_CNPJ        := 0
	private nCL_TP_PRODUTO	:= 0
	private nNR_CPF			:= 0	
	private nCD_CAMPANHA	:= 0
	
	
	// Compatibilizar o nome do arquivo.
	cArqDados := cMvImp + cArquivo
	// Abrir o arquivo.
	FT_FUSE( cArqDados )
	// Posicionar na primeira linha.
	FT_FGOTOP()
	// Capturar a primeira linha, espera-se que seja o header do arquivo.
	cHeader := A370LeLin()
	
	
	// Ir par ao próxima linha do arquivo.
	FT_FSKIP()
	// Montar o vetor aHeader.
	aHeader := A370Array( cHeader )
	
	// Capturar a posição das colunas.
	nCD_PEDIDO    	:= AScan( aHeader, 'CD_PEDIDO' 		)
	nNM_CLIENTE     := AScan( aHeader, 'NM_CLIENTE' 	)
	nDS_RAZAO_SOCIAL:= AScan( aHeader, 'DS_RAZAO_SOCIAL')
	nIC_RENOVACAO   := AScan( aHeader, 'IC_RENOVACAO' 	)
	nNR_TELEFONE    := AScan( aHeader, 'NR_TELEFONE' 	)
	nDT_EXPIRACAO   := AScan( aHeader, 'DT_EXPIRACAO' 	)
	nCD_CNPJ     	:= AScan( aHeader, 'CD_CNPJ' 		)
	nCL_TP_PRODUTO	:= AScan( aHeader, 'CL_TP_PRODUTO' 	)
	nNR_CPF			:= AScan( aHeader, 'NR_CPF' 		)
	nCD_CAMPANHA	:= AScan( aHeader, 'CD_CAMPANHA'	)
	nDS_EMAIL  		:= AScan( aHeader, 'DS_EMAIL'	    )
	

	// Le o arquivo ate sua ultima linha de dados.
	While .NOT. FT_FEOF()
		// Captura a linha de dados.
		cDados := A370LeLin()
		
		// Contatdor de linhas do arquivo de dados.
		nLinha++
		
		// Monta o vetor conforme os dados na linha.
		aLinha := A370Array( cDados )
		
		if Len(aLinha) > 0
		
			Begin Transaction
			
				lGravou := csGravaSZX(aLinha, .T., "" , "1" )
				lProcessou := .T.							
			End Transaction		
		
		else
			////u_autoMsg(cExec,cProcImp, "FALHA na gravacao do registro, nao consta dados")
		endif
		
		// Ir para o próxima linha de dados.
		FT_FSKIP()
	End
	if lGravou
		////u_autoMsg(cExec,cProcImp, "Realizado o processamento de Importacao de " + alltrim(STR(nLinha))+ " registros")      
	else
		////u_autoMsg(cExec,cProcImp, "FALHA no processamento de Importacao de " + alltrim(STR(nLinha))+ " registros")      
	endif
	
	// Fechar o arquivo de dados.
	FT_FUSE()

Return lProcessou

//---------------------------------------------------------------
/*/{Protheus.doc} csGravaSZX
Funcao responsavel para gravacao na tabela SZX (CERTIFICADO ICP-BRASIL).
						  
@param	aARRAY		Array contendo os dados do arquivo .CSV
		lReclock		Identifica se eh novo registro ou sera alterado.
		cFile		Nome do arquivo exportado.
		cStatus		1 = Arquivo importado 
					2 = Arquivo gerado/exportado
					3 = Realizado Insert direto no banco TOTALIP
					
@return	lProcessa		Retorna se foi processado com sucesso ou nao.						

@author	Douglas Parreja
@since	16/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csGravaSZX( aARRAY, lReclock, cFile, cStatus, aAglut )

	local cZX_ORIGEM:= 'REG.IMP.: ' + Dtos( Date() ) + '-' + Left(Time(),5) + ' Via JOB - csTOTIP'
	local lGrava	:= .F.
	local nX		:= 0
		
	default aARRAY 	:= {}
	default aAglut	:= {}
	default lReclock:= .T.
	default cFile	:= ""
	default cStatus	:= ""
	
	if len(aARRAY) > 0
				
		if lReclock
			dbSelectArea("SZX")
			SZX->( dbSetOrder( 4 ) )	// ZX_FILIAL + ZX_CDPEDID
			//-----------------------------------------------------------------
			// Verificar se o pedido GAR já foi processado para esta entidade
			//-----------------------------------------------------------------
			if  !SZX->( dbSeek( xFilial("SZX") + aARRAY[ nCD_PEDIDO ] ) )
				SZX->( RecLock( 'SZX', lReclock ) )
				SZX->ZX_FILIAL  := xFilial( 'SZX' )
				SZX->ZX_CODIGO  := csGetNum( 'SZX', 'ZX_CODIGO' )	
				SZX->ZX_CDPEDID := aARRAY[ nCD_PEDIDO ] 
				
				//-------------------------------------------------------------
				// Gravando na SZX
				//-------------------------------------------------------------						
				SZX->ZX_CDCPF		:= csValidNum( aARRAY[ nNR_CPF ] )
				SZX->ZX_NMCLIEN 	:= aARRAY[ nNM_CLIENTE] 
				SZX->ZX_NRTELEF 	:= aARRAY[ nNR_TELEFONE ] 
				SZX->ZX_DSPRODU 	:= aARRAY[ nCL_TP_PRODUTO ]  
				SZX->ZX_ICRENOV 	:= aARRAY[ nIC_RENOVACAO ] 
				SZX->ZX_DTEXPIR 	:= Stod(Dtos( Ctod( aARRAY[ nDT_EXPIRACAO ] ) ) )			
				SZX->ZX_NRCNPJ  	:= csValidNum( aARRAY[ nCD_CNPJ ] ) 
				SZX->ZX_DSRAZAO 	:= aARRAY[ nDS_RAZAO_SOCIAL ] 
				SZX->ZX_LISTA		:= Iif( TYPE("aARRAY[ nCD_CAMPANHA ]") <> "U", " ", aARRAY[ nCD_CAMPANHA ] ) 
				SZX->ZX_ORIGEM  	:= cZX_ORIGEM 
				SZX->ZX_INPUT   	:= Date()
				if SZX->(FieldPos("ZX_STATUS")) > 0
					SZX->ZX_STATUS	:= alltrim( cStatus ) 	//1=Importado
				endif
				SZX->ZX_DSEMAIL   	:= aARRAY[ nDS_EMAIL ]
				SZX->( MsUnLock() )
				lGrava := .T.
			endif		
		else
			dbSelectArea("SZX")
			SZX->( dbSetOrder( 1 ) )	// ZX_FILIAL + ZX_CODIGO
			//---------------------------------------------------------------------
			// Realiza a gravacao dos registros Arquivos Gerados ou INSERT
			//---------------------------------------------------------------------
			for nX := 1 to len(aARRAY)						
				//-----------------------------------------------------------------
				// Verificar se o pedido GAR já foi processado para esta entidade
				// ZX_STATUS  - 2=Exportado | 3=Insert TOTALIP
				// ZX_NOMARQ  - Processo que foi gerado (Arq. gerado/Insert)
				// ZX_TELCLIE - Telefone cliente (validado)
				// ZX_TELCONT - Telefone contato (validado) 
				// ZX_AGLUT	  - Codigo Aglutinacao (tabela ZZQ)
				//-----------------------------------------------------------------
				if  SZX->( dbSeek( xFilial("SZX") + alltrim( aARRAY[nX][1]) ) )															
					SZX->( RecLock( 'SZX', lReclock ) )
					SZX->ZX_STATUS	:= alltrim( cStatus ) 			  
					if ( SZX->(FieldPos("ZX_NOMARQ")) > 0 .and. SZX->(FieldPos("ZX_TELCLIE")) > 0 .and. SZX->(FieldPos("ZX_TELCONT")) > 0 .and. SZX->(FieldPos("ZX_AGLUT")) > 0 )
						SZX->ZX_NOMARQ	:= alltrim( cFile )	
						if len(aARRAY[nX]) > 2	
							SZX->ZX_TELCLIE	:= alltrim( aARRAY[nX,3] )
						endif
						if len(aARRAY[nX]) > 3
							SZX->ZX_TELCONT	:= alltrim( aARRAY[nX,4] )
						endif
						if len(aARRAY[nX]) > 4
							SZX->ZX_AGLUT		:= alltrim( aARRAY[nX,5,1] )
						else
							SZX->ZX_AGLUT		:= " "
						endif
					endif
					SZX->( MsUnlock() )
					lGrava := .T.
				endif
			Next
		endif
	endif	
	
	
return lGrava

//---------------------------------------------------------------
/*/{Protheus.doc} csLista
Funcao responsavel para geracao da Lista para TOTALIP

@param	lGerDiaria	
			1 vez -> .F. = Sera verificado funcao csValidUtil 
               se trata de Aglutinacao.
			2 vez -> .T. = Significa que ja passou a primeira vez,
               e com isso nao sera realizado query de aglutinacao.						  

						  
@return	lProcessa		Retorna se foi processado com sucesso ou nao.						

@author	Douglas Parreja
@since	20/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csLista( lGerDiaria, aReproc )

	local cStatus	:= ""
	local cQuery	:= ""
	local cQueryRet	:= ""
	local nCount	:= 0
	local nTotal	:= 0
	local nX		:= 0
	local lOk		:= .F.
	local lAglutina	:= .F.
	local aProcess	:= {}
	local aDados	:= {}
	local aRetTel	:= {}
	local aRetData	:= {}
	local aCampanha	:= {"BASE"} //{"FACESP","ESTADO","NAOPG","BASE"}         
	local cCampanha	:= "BASE"
	//local aCampanha	:= {"NAOPG"}
	local aRetPosiciona := {}      

	default lGerDiaria	:= .F.
	default aReproc	:= {}
	
	cQuery 	 := csQuerySZX( cCampanha, aRetData  )
	
	if ( !Empty(cQuery) )
		//----------------------------
		// Realiza query na SZX
		//----------------------------
		csDBConexao(2)
		cQueryRet := executeQuery(cQuery)
		
		if ( !Empty(cQueryRet) )
			
			////u_autoMsg(cExec,cProcExp,"Iniciando processamento da geracao da campanha")
			nCount:= 0
			
			while !(cQueryRet)->(eof())
			
				nCount++
				nTotal++
				aDados := {}
				aRet := csProcUni(cQueryRet)
				
				if len(aRet) > 0 
					//-----------------------------------------------------
					// Se o STATUS estiver como 1 (Importada) podera ser 
					// gerada a lista. 
					// Obs.: Na query ja realizo o filtro do status, mas
					// mesmo assim, eu reforco aqui para ser gerado somente
					// quando estiver status igual a 1.		
					//-----------------------------------------------------
					if aRet[6] == "1"	
						//-----------------------------------------------------
						// Funcao que posicionara nas tabelas SC5, SA1 e SU5		
						//-----------------------------------------------------    
						aRetPosiciona := {}
						
						aRetPosiciona := csPosiciona( aRet )
																
						aAdd(aDados, alltrim( (cQueryRet)->ZX_CDPEDID ))			// 1- Codigo PEDGAR
						aAdd(aDados, alltrim( (cQueryRet)->ZX_NMCLIEN ))			// 2- Nome cliente
						aAdd(aDados, alltrim( (cQueryRet)->ZX_DSRAZAO ))			// 3- Razao social
						aAdd(aDados, alltrim( (cQueryRet)->ZX_DSPRODU ))			// 4- Descricao Produto
						aAdd(aDados, Dtoc(Stod( (cQueryRet)->ZX_DTEXPIR )))		    // 5- Data expiracao
						aAdd(aDados, alltrim( (cQueryRet)->ZX_ICRENOV ))			// 6- Renovacao
						
						//-----------------------------------------------------
						// Telefone Importado da LISTA Adm. Dados 
						//-----------------------------------------------------
						aRetTel := u_csValidTel ( alltrim( (cQueryRet)->ZX_NRTELEF ))		
						
						// Dados da Lista Importada pelo Adm. Dados	
						if len(aRetTel) > 0 
							aAdd(aDados, aRetTel[1] )							// 7- DDD Lista
							aAdd(aDados, aRetTel[2] )							// 8- Telefone Lista								
							aAdd(aDados, aRetTel[3] ) 					    	// 9- Tipo do numero telefonico GAR Fixo Celular							        								
						else
							//-----------------------------------------------------
							// Caso nao tenha telefone, ou nao retorne dados,
							// criar o array com a posicao 
							//-----------------------------------------------------
							aAdd(aDados, "" )									// 7-DDD lista 		
							aAdd(aDados, "" )									// 8-Telefone lista
							aAdd(aDados, "" )									// 9- Tipo do numero telefonico GAR Fixo Celular
						endif

						aAdd(aDados, alltrim( aRetPosiciona[1] ))			// 10-DDD Cliente 		SA1 
						aAdd(aDados, alltrim( aRetPosiciona[2] ))			// 11-Telefone Cliente 	SA1								
						aAdd(aDados, alltrim( aRetPosiciona[5] ))			// 12-Tipo Telefone Cliente SA1								
						
						aAdd(aDados, alltrim( aRetPosiciona[3] ))			// 13-DDD Contato		SU5
						aAdd(aDados, alltrim( aRetPosiciona[4] ))			// 14-Telefone Contato 	SU5								
						aAdd(aDados, alltrim( aRetPosiciona[6] ))			// 15-Tipo Telefone Contato SU5								
						
						aAdd(aDados, alltrim( (cQueryRet)->ZX_DSEMAIL ))	// 16- email titular
						aAdd(aDados, alltrim( aRetPosiciona[7] ))			// 17- email Cliente
						aAdd(aDados, alltrim( aRetPosiciona[8] ))			// 18- email Contato
						aAdd(aDados, alltrim( (cQueryRet)->ZX_CODIGO ))		// 19- ZX_CODIGO
						aAdd(aDados, alltrim( aRetPosiciona[9] ))			// 20- Endereço do cliente
						aAdd(aDados, alltrim( (cQueryRet)->ZX_CDCPF))		// 21- CPF do Titular do certificado
						aAdd(aDados, alltrim( (cQueryRet)->ZX_NRCNPJ ))		// 22- CNPJ do Certificado

					endif
				endif
				if len(aDados) > 0 
					aAdd(aProcess, aDados)
				endif
				
				(cQueryRet)->(dbSkip())
				
				if len(aProcess) > 99000
				
					if lInsert 
					// Realiza a conexao com o Banco de Dados
						//------------------------------------------                   	
					    lConexao := csDBConexao(1)	
					   	if lConexao 
					   		lOk	:= csDBInsert( aProcess, cCampanha, lAglutina )			
					   	else
							////u_autoMsg(cExec,cProcExp,"Devido a falha na conexao com o Banco POSTGRES a campanha "+ alltrim(cCampanha)+" sera gerado arquivo CSV.")
						endif
					else 
				
						//------------------------------------------
						// Criar arquivo de importação
						//------------------------------------------                   	
				
						lOk  := csCreateArq( aProcess, cCampanha )
				
					endif
				
					// apos o processamento zero o array para nova campanha
					aProcess := {} 		
					
					if lOk
						if lInsert
							////u_autoMsg(cExec,cProcExp,"Foi realizado INSERT da campanha "+ alltrim(cCampanha)+" no Banco TOTAL IP com sucesso.")
						else
							////u_autoMsg(cExec,cProcExp,"Foi gerado a lista da Campanha "+ alltrim(cCampanha)+" com sucesso.")
						endif
					else
						if lInsert
							////u_autoMsg(cExec,cProcExp,"FALHA - Nao foi possivel realizar o INSERT da campanha "+ alltrim(cCampanha)+" no Banco TOTAL IP.")
						else
							////u_autoMsg(cExec,cProcExp,"FALHA - Nao foi gerado a lista da Campanha.")
						endif
					endif
					////u_autoMsg(cExec,cProcExp,"***** TOTAL PROCESSAMENTO: " + alltrim(Str(nTotal))+ Iif(nTotal==1," registro. *****"," registros. *****") )
				endif


			EndDo
			////u_autoMsg(cExec,cProcExp,"Processado : " + alltrim(Str(nCount))+ Iif(nCount==1," registro."," registros.") )
			////u_autoMsg(cExec,cProcExp,"Finalizado o processamento da geracao da campanha "+cCampanha )
			&(cQueryRet)->(dbCloseArea())
		endif
	endif

	if len(aProcess) > 0
	
		if lInsert 
		// Realiza a conexao com o Banco de Dados
			//------------------------------------------                   	
		    lConexao := csDBConexao(1)	
		   	if lConexao 
		   		lOk	:= csDBInsert( aProcess, cCampanha, lAglutina )			
		   	else
				////u_autoMsg(cExec,cProcExp,"Devido a falha na conexao com o Banco POSTGRES a campanha "+ alltrim(cCampanha)+" sera gerado arquivo CSV.")
			endif
		else 
	
			//------------------------------------------
			// Criar arquivo de importação
			//------------------------------------------                   	
	
			lOk  := csCreateArq( aProcess, cCampanha )
	
		endif
	
		// apos o processamento zero o array para nova campanha
		aProcess := {} 		
		
		if lOk
			if lInsert
				////u_autoMsg(cExec,cProcExp,"Foi realizado INSERT da campanha "+ alltrim(cCampanha)+" no Banco TOTAL IP com sucesso.")
			else
				////u_autoMsg(cExec,cProcExp,"Foi gerado a lista da Campanha "+ alltrim(cCampanha)+" com sucesso.")
			endif
		else
			if lInsert
				////u_autoMsg(cExec,cProcExp,"FALHA - Nao foi possivel realizar o INSERT da campanha "+ alltrim(cCampanha)+" no Banco TOTAL IP.")
			else
				////u_autoMsg(cExec,cProcExp,"FALHA - Nao foi gerado a lista da Campanha.")
			endif
		endif
		////u_autoMsg(cExec,cProcExp,"***** TOTAL PROCESSAMENTO: " + alltrim(Str(nTotal))+ Iif(nTotal==1," registro. *****"," registros. *****") )
	endif
			
return

//---------------------------------------------------------------
/*/{Protheus.doc} csQuerySZX
Funcao responsavel para realizar a Query na tabela SZX.
						  
@param	cCampanha		Campanha que sera gerada a lista	
		aDados		[1]Data Hoje ou Posterior								
					[2]Data Posterior		
					[3]Aglutina								  
@return	cQuery		Retorna a String da Query a ser processada.						

@author	Douglas Parreja
@since	20/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csQuerySZX( cCampanha, aDados  )

	local cQuery 	:= ""
	local cCampos 	:= ""
	local cDataExp1	:= ""
	local cDataExp2	:= ""
	local lAglutina	:= .F.
	
	default cCampanha	:= ""
	default aDados		:= {}
		
	/*
	if len( aDados ) > 0    
		if cCampanha <> "NAOPG"
			cDataExp1	 := aDados[1]
			cDataExp2	 := aDados[2]
		endif
		lAglutina	 := aDados[3]
	endif
	
	
	cCampos := ",ZX_STATUS, ZX_NOMARQ, ZX_AGLUT "
	
	cQuery 	:= "SELECT ZX_CODIGO, "
	cQuery	+= "ZX_CDPEDID, "
	cQuery	+= "ZX_NMCLIEN, "
	cQuery	+= "ZX_DSRAZAO, "
	cQuery	+= "ZX_DSPRODU, "
	cQuery	+= "ZX_DTEXPIR, "
	cQuery	+= "ZX_ICRENOV, "
	cQuery	+= "ZX_NRTELEF, "
	cQuery	+= "ZX_CDCPF, "
	cQuery	+= "ZX_NRCNPJ, "
	cQuery	+= "ZX_DSEMAIL "
	
	if !Empty(cCampos)
		cQuery += cCampos
	endif
	cQuery 	+= "FROM "+RetSqlName("SZX")+ " SZX "
	
	cQuery 	+= "WHERE "
	cQuery 	+= "ZX_FILIAL ='"+xFilial("SZX")+"' AND "
	
	//----------------------------------------------------------
	// Valida data Expiracao                                
	//----------------------------------------------------------
	if !Empty(cDataExp2)
		cQuery += "ZX_DTEXPIR >= '" + cDataExp1 + "' "
		cQuery += "AND ZX_DTEXPIR <= '" + cDataExp2 + "' "
	elseif !Empty(cDataExp1) .and. Empty(cDataExp2)
		cQuery += "ZX_DTEXPIR = '" + cDataExp1 + "' "
	else     
		//----------------------------------------------------------
		// Como a campanha NAOPG nao possui data de expiracao,sera 
		//  exportado dados que foram importados na data de hoje.
		//----------------------------------------------------------
		if cCampanha == "NAOPG"
			cQuery += "ZX_INPUT = '" + Dtos(Date()) + "' AND "
		else
			cQuery += "" 
		endif
	endif

	//----------------------------------------------------------		
	// Valida Status e Nome Arquivo        
	//----------------------------------------------------------
	if !Empty(cCampos)
		cQuery += Iif( !Empty(cDataExp1), "AND ZX_STATUS = '1' ", "ZX_STATUS = '1' " )
		cQuery += "AND ZX_NOMARQ = ' '    " 
	endif

	//----------------------------------------------------------	
	// Valida Campanha e DELETE
	//----------------------------------------------------------
	if !Empty(cCampanha)
		cQuery += Iif( !Empty(cCampos), "AND ZX_LISTA = '" + cCampanha + "' ", "ZX_LISTA = '" + cCampanha + "' " )
		cQuery += "AND SZX.D_E_L_E_T_ = ' ' 
	elseif Empty(cCampanha) .and. !Empty(cCampos)
		cQuery += "AND SZX.D_E_L_E_T_ = ' '
	else	
		cQuery += "SZX.D_E_L_E_T_ = ' ' "
	endif
	
	if lAglutina
		cQuery += " AND SUBSTR(ZX_NRTELEF,1,11) IN "
		cQuery += "( SELECT SUBSTR(ZX_NRTELEF,1,11) 
		cQuery += "FROM "+RetSqlName("SZX")+ " SZX "
		cQuery += "WHERE "
		cQuery += "ZX_FILIAL ='"+xFilial("SZX")+"' AND "

		//----------------------------------------------------------		
		// Valida data Expiracao                                    
		//----------------------------------------------------------
		if !Empty(cDataExp2)
			cQuery += "ZX_DTEXPIR >= '" + cDataExp1 + "' "
			cQuery += "AND ZX_DTEXPIR <= '" + cDataExp2 + "' "
		elseif !Empty(cDataExp1) .and. Empty(cDataExp2)
			cQuery += "ZX_DTEXPIR = '" + cDataExp1 + "' "
		else
			//----------------------------------------------------------
			// Como a campanha NAOPG nao possui data de expiracao,sera 
			//  exportado dados que foram importados na data de hoje.
			//----------------------------------------------------------
			if cCampanha == "NAOPG"
				cQuery += "ZX_INPUT = '" + Dtos(Date()) + "' AND "
			else
				cQuery += "" 
			endif
		endif
		
		//----------------------------------------------------------
		// Valida Status e Nome Arquivo                             
		//----------------------------------------------------------
		if !Empty(cCampos)
			cQuery += Iif( !Empty(cDataExp1), "AND ZX_STATUS = '1' ", "ZX_STATUS = '1' " )
			cQuery += "AND ZX_NOMARQ = ' '    " 
		endif
		
		cQuery += "AND ZX_LISTA = '" + cCampanha + "' "
		cQuery += "GROUP BY SUBSTR(ZX_NRTELEF,1,11)
		cQuery += "HAVING COUNT(ZX_NRTELEF) > 1 ) "
		cQuery += "ORDER BY ZX_NRTELEF Asc 	"
	else
		//cQuery += "AND ROWNUM <= 1000 "		// Limitando o tamanho da query para evitar array Overflow
		cQuery += "ORDER BY ZX_CODIGO Asc 	"
	endif	
    */	

    
	cQuery 	:= "SELECT "
	 
	cQuery	+= "ZX_CODIGO, "
	cQuery	+= "ZX_CDPEDID, "
	cQuery	+= "ZX_NMCLIEN, "
	cQuery	+= "ZX_DSRAZAO, "
	cQuery	+= "ZX_DSPRODU, "
	cQuery	+= "ZX_DTEXPIR, "
	cQuery	+= "ZX_ICRENOV, "
	cQuery	+= "ZX_NRTELEF, "
	cQuery	+= "ZX_CDCPF, "
	cQuery	+= "ZX_NRCNPJ, "
	cQuery	+= "ZX_DSEMAIL, ZX_STATUS, ZX_NOMARQ, ZX_AGLUT "
	
	cQuery += "FROM "+RetSqlName("SZX")+ " SZX "
	
	cQuery += "WHERE "
	
	cQuery += "ZX_FILIAL ='"+xFilial("SZX")+"' "
	cQuery += "AND ZX_STATUS = '1' "
	cQuery += "AND ZX_NOMARQ = ' '    " 
	cQuery += "AND ZX_LISTA = '" + cCampanha + "' "
	cQuery += "AND SZX.D_E_L_E_T_ = ' ' " 
	cQuery += "ORDER BY ZX_CODIGO Asc 	"
	
	////u_autoMsg(cExec,cProcExp,Iif(lAglutina, "** Query Aglutinacao ** ---->   " + cQuery, cQuery) )


return cQuery

//---------------------------------------------------------------
/*/{Protheus.doc} csQueryAC8
Funcao responsavel para realizar a query da tabela AC8 para retornar a
quantidade de contatos na SU5.
						  
@param	cCodCliLoj	Codigo do Cliente/Loja						  
@return	cQuery		Retorna a String da Query a ser processada.						

@author	Douglas Parreja
@since	28/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csQueryAC8( cCodCliLoj )

	local cQuery 		:= ""
	local cTabela 		:= "SA1"
	default cCodCliLoj	:= ""
	
	//////u_autoMsg(cExec,cProcExp,"Realizando filtro na tabela AC8")
	
	cQuery := "SELECT AC8_FILIAL, "
	cQuery += "AC8_CODCON, "
	cQuery += "AC8_ENTIDA, "
	cQuery += "AC8_FILENT, "
	cQuery += "AC8_CODENT, "
	cQuery += "R_E_C_N_O_ "
	cQuery += "FROM "+RetSqlName("AC8")+ " AC8 "
	cQuery += "WHERE 
	cQuery += "AC8_FILIAL ='"+xFilial("AC8")+"' " 
	cQuery += "AND AC8_ENTIDA = '"+cTabela+"'  " 
	cQuery += "AND AC8_FILENT ='"+xFilial("SA1")+"' "
	cQuery += "AND AC8_CODENT = '"+cCodCliLoj+"'  "
	cQuery += "AND AC8.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY R_E_C_N_O_ DESC 	"
	
	//////u_autoMsg(cExec,cProcExp,cQuery)

return cQuery

//-------------------------------------------------------------------
/*/{Protheus.doc} executeQuery
Funcao executa a query.

@param	cQuery		Query que sera executada
@return 	cAlias		Alias da query executada

@author  Douglas Parreja
@since   26/06/2015
@version 11.8
/*/
//-------------------------------------------------------------------
static function ExecuteQuery( cQuery )

	Local cAlias	:= getNextAlias()
	Default cQuery	:= ""
	
	If ( !Empty(cQuery) )
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
			
		If ( (cAlias)->(eof()) )
		
			(cAlias)->(dbCloseArea())
			
			cAlias := ""
			////u_autoMsg(cExec,cProcExp,"Query nao retornou registros" )
		//Else
		//	////u_autoMsg(cExec,cProcExp, "Executando query" )
		Endif
	Else
		
		cAlias := ""
		////u_autoMsg(cExec,cProcExp, "Query nao retornou registros" )
	
	Endif

Return cAlias

//---------------------------------------------------------------
/*/{Protheus.doc} csValidNum
Funcao responsavel para retirar caracter diferente de numeros

@param	cVar			Dado a ser validado.			  
@return	cRet			Retorna numero.						

@author	Douglas Parreja
@since	15/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csValidNum( cVar )
	
	local nI 		:= 0
	local cRet 		:= ''
	local cNumeros 	:= '0123456789'
	
	for nI := 1 To Len( cVar )
		if SubStr( cVar, nI, 1 ) $ cNumeros
			cRet += SubStr( cVar, nI, 1 )
		endif
	next nI

return cRet
 
//---------------------------------------------------------------
/*/{Protheus.doc} csProcUni
Funcao responsavel para receber o ALIAS e adicionar no array de retorno
por documento.

@param	cAliasSZX		Query que sera executada						  
@return	aRetSZX		Retorna com os documentos						

@author	Douglas Parreja
@since	22/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csProcUni( cAliasSZX )
	
	local lContinua	 	:= .F.
	local aRetSZX		:= {}
	default cAliasSZX 	:= ""

	
	if !Empty( cAliasSZX )
		
		if (cAliasSZX)->(FieldPos("ZX_STATUS")) > 0 .and. (cAliasSZX)->(FieldPos("ZX_NOMARQ")) > 0
			lContinua := .T.
		endif 	
		
		if lContinua
		
			aAdd(aRetSZX, alltrim((cAliasSZX)->ZX_CODIGO )) 		// 1-Codigo sequencial SZX
			aAdd(aRetSZX, alltrim((cAliasSZX)->ZX_CDPEDID)) 		// 2-Codigo PEDGAR
			aAdd(aRetSZX, alltrim((cAliasSZX)->ZX_CDCPF  )) 		// 3-CPF
			aAdd(aRetSZX, alltrim((cAliasSZX)->ZX_NRCNPJ )) 		// 4-CNPJ
			aAdd(aRetSZX, alltrim((cAliasSZX)->ZX_NRTELEF)) 		// 5-Numero telefone
			aAdd(aRetSZX, alltrim((cAliasSZX)->ZX_STATUS )) 		// 6-Status do arquivo 1-Importado / 2-Exportado
			aAdd(aRetSZX, alltrim((cAliasSZX)->ZX_NOMARQ )) 		// 7-Nome do arquivo caso ja foi exportado
			
		endif
	
	endif
	
return aRetSZX

//---------------------------------------------------------------
/*/{Protheus.doc} csPosiciona
Funcao responsavel para receber o array contendo os registros SZX, e com
o array, posicionar na tabela SC5, SA1, AC8 e SU5.
por documento.

@param	aPosiciona		Query que sera executada	
		lPosiciona		.T. retorna para funcao que chamou					  
@return	lProcessa			Retorna se foi processado com sucesso ou nao						

@author	Douglas Parreja
@since	24/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csPosiciona( aPosiciona )

	local cClienteSA1	:= ""
	local cCodContato	:= ""
	local cDDD_SU5		:= ""
	local cTEL_SU5		:= ""
	local cRetQuery		:= ""
	local cAliasAC8		:= ""
	local cEntidade		:= ""
	local cFilEnt		:= ""
	local cCodEntidade	:= ""
	local cTelPedGar	:= ""  
	local cCliSC5		:= ""
	local cCliSZF		:= ""
	local aDadSA1		:= {}
	local aDadSU5		:= {}
	local aDados		:= {}
	local aRetTel		:= {}
	local lContinua		:= .F.	
	local cEndereco     := ' '
	private cPedGar		:= ""
	
	default aPosiciona := {}
	
	
  	if len(aPosiciona) > 0 
	
		cPedGar		:= alltrim( aPosiciona[2] ) 									// Codigo PEDGAR (ZX_CDPEDID)
		cTelPedGar	:= Iif( len(aPosiciona[5])>0, alltrim(aPosiciona[5]), "") 	// Numero telefone PEDGAR (ZX_NRTELEF)
			   
		//----------------------------------------------------------------------------
		// VALIDACAO PARA POSICIONAR NA TABELA X PARA BUSCAR O CODIGO CLIENTE
		//
		// Podera ocorrer que nao tenha registro na SC5 com o codigo PEDGAR
		// devido ser VOUCHER, com isso, atraves do PEDGAR, posiciona na SZG,
		// e posiciona na SZF. 
		// 
		// Devido a validacao de codigo de VOUCHER, na SZF caso nao tenha o codigo 
		// do Pedido Venda, busco o codigo do cliente.
		//----------------------------------------------------------------------------	
		/*
		Ajustes de código para atender Migração versão P12
		Uso de DbOrderNickName
		OTRS:2017103110001774
		*/
		SC5->(DbOrderNickName("NUMPEDGAR")) // C5_FILIAL+C5_CHVBPAG
		if SC5->(dbSeek( xFilial("SC5") + cPedGar ))    
			cCliSC5 := alltrim(SC5->C5_CLIENTE)
			lContinua := .T.
		else
			SZG->( dbSetOrder(1) )	//ZG_FILIAL + ZG_NUMPED
			if SZG->(dbSeek( xFilial("SZG") + cPedGar ))
				SZF->( dbSetOrder(2) ) //ZF_FILIAL + ZF_COD
				if SZF->(dbSeek( xFilial("SZF") + alltrim(SZG->ZG_NUMVOUC) ))
					if !Empty(alltrim(SZF->ZF_PEDVEND))
						SC5->( dbSetOrder(1) ) //C5_FILIAL + C5_NUM
						if SC5->(dbSeek( xFilial("SC5") + alltrim(SZF->ZF_PEDVEND) ))	 
                            cCliSC5 := alltrim(SC5->C5_CLIENTE)
							lContinua := .T.				
						endif									
					elseif !Empty(alltrim(SZF->ZF_CODCLI))
						cCliSZF := alltrim(SZF->ZF_CODCLI)
						lContinua := .T.
					endif
				endif
			endif
		endif
		
		if lContinua
		
			cClienteSA1 := Iif( Empty(cCliSC5), cCliSZF, cCliSC5 )
							
			if !Empty(cClienteSA1)
			
				dbSelectArea("SA1")
				dbSetOrder(1)	// A1_FILIAL+A1_COD
				
				if SA1->(dbSeek( xFilial("SA1") + cClienteSA1 ))
					
					aAdd( aDadSA1, alltrim(SA1->A1_COD+SA1->A1_LOJA) ) //1 - dado do cliente	
									
										
					aRetTel := u_csValidTel( alltrim(SA1->A1_DDD+SA1->A1_TEL), cTelPedGar )
					
					if len(aRetTel) > 0
						aAdd( aDadSA1, aRetTel[1] ) //2 - DDD do cliente				
						aAdd( aDadSA1, aRetTel[2] ) //3 - Numero telefone do cliente
						aAdd( aDadSA1, aRetTel[3] ) //4 - Tipo do telefone do cliente
					else
						aAdd( aDadSA1, "" )				
						aAdd( aDadSA1, "" )
						aAdd( aDadSA1, "" )
					endif						
					
					aAdd( aDadSA1, Lower(SA1->A1_EMAIL) )  //5 - Email do cliente
					
					cEndereco := SA1->A1_END +' -  '+ SA1->A1_BAIRRO +' - '+ SA1->A1_MUN +' - '+ SA1->A1_EST +' - '+SA1->A1_CEP 
					
					aAdd( aDadSA1, cEndereco )             //6 - Endereco do telefone do cliente
					
					
					aRetTel := {}		// estou zerando porque este array eh somente no Contato
													
					if len(aDadSA1) > 0 
						
							//-----------------------------------------------
							// Query para buscar na AC8
							//-----------------------------------------------
							cRetQuery := csQueryAC8( aDadSA1[1] )
							
							//-----------------------------------------------
							// Criando tabela temporaria
							//-----------------------------------------------
							cAliasAC8 := executeQuery( cRetQuery )
							
							if !Empty(cAliasAC8)
								while  !(cAliasAC8)->(eof())  .And. Empty(cDDD_SU5) .And. Empty(cTEL_SU5)
									cCodContato		:= (cAliasAC8)->AC8_CODCON		// Condigo contato
									cEntidade		:= (cAliasAC8)->AC8_ENTIDAD		// Tabela
									cFilEnt			:= (cAliasAC8)->AC8_FILENT		// Filial Entidade
									cCodEntidade	:= (cAliasAC8)->AC8_CODENT		// Cliente + Loja											 
															
									AC8->( dbSetOrder(1) ) // AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT
									if AC8->(dbSeek( xFilial("AC8") + cCodContato + cEntidade + cFilEnt + cCodEntidade ))							
										if ( !Empty(cCodContato) )
											SU5->( dbSetOrder(1) ) // U5_FILIAL+U5_CODCONT
											
											if SU5->( dbSeek( xFilial("SU5") + cCodContato ))								
												
												while !SU5->(eof()) .AND.  ALLTRIM (SU5->U5_FILIAL+SU5->U5_CODCONT)== ALLTRIM(cCodContato) .and. ( Empty(cDDD_SU5) .And. Empty(cTEL_SU5))
												
												  		//-----------------------------------------------------------------	
												  		//Caso for igual a SIM ou em branco e os telefones nao estao vazio
												  		//-----------------------------------------------------------------
												  		if ( (SU5->U5_ATIVO == "1" .OR. Empty(SU5->U5_ATIVO) ) .And.;
												  			(!Empty(SU5->U5_FONE)) .OR.;
												  			(!Empty(SU5->U5_CELULAR)) .OR.;
												  			(!Empty(SU5->U5_FAX)) .OR.;
												  			(!Empty(SU5->U5_FCOM1)) .OR.;
												  			(!Empty(SU5->U5_FCOM2)) )
														  				
												  			//--------------------------------------------------------------
												  			// Verifica qual telefone que consta para alimentar a variavel
												  			//--------------------------------------------------------------  													
												  			cDDD_SU5 := alltrim(SU5->U5_DDD)
														  	
															if (!Empty(SU5->U5_CELULAR))
																cTEL_SU5 := alltrim(SU5->U5_CELULAR)
															elseIf (!Empty(SU5->U5_FONE))
																cTEL_SU5 := alltrim(SU5->U5_FONE)
															elseIf (!Empty(SU5->U5_FAX))
																cTEL_SU5 := alltrim(SU5->U5_FAX)
															elseIf (!Empty(SU5->U5_FCOM1))
																cTEL_SU5 := alltrim(SU5->U5_FCOM1)
															elseIf (!Empty(SU5->U5_FCOM2))
																cTEL_SU5 := alltrim(SU5->U5_FCOM2)
															endIf		
															aRetTel := u_csValidTel( cDDD_SU5+cTEL_SU5, cTelPedGar )
															
															aAdd( aDadSU5, cCodContato ) 		  //1- Contato
															aAdd( aDadSU5, aRetTel[1] )    		  //2- ddd
															aAdd( aDadSU5, aRetTel[2] )   		  //3- tel
															aAdd( aDadSU5, aRetTel[3] )   		  //4- tipo tel
															aAdd( aDadSU5, Lower(SU5->U5_EMAIL) ) //5- Email
															Exit
														endif
													
													
													SU5->(dbSkip())
												EndDo
											endif							
										endif							
									endif
									(cAliasAC8)->(dbSkip())
								EndDo
	
								&(cAliasAC8)->(dbCloseArea())
							else
								////u_autoMsg(cExec,cProcExp,"Nao consta contato para o cliente "+aDadSA1[1])
							endif
															 
					endif 
				endif
			endif 				
		else
			////u_autoMsg(cExec,cProcExp,"Nao foi possivel localizar na SC5, SZG e SZF para o Pedido Gar "+alltrim(cPedGar)+". Favor verificar")
		endif
		
		//--------------------------------------------------------------
		// Add no aDados a informacao dos telefones 
		//--------------------------------------------------------------  	
		if ( (len(aDadSA1) > 0) .And. (len(aDadSU5) > 0) ) 
			aAdd(aDados, aDadSA1[2] )		// Cliente SA1 - DDD 
			aAdd(aDados, aDadSA1[3] )		// Cliente SA1 - Telefone 
			aAdd(aDados, aDadSU5[2] )		// Contato SU5 - DDD 
			aAdd(aDados, aDadSU5[3] )		// Contato SU5 - Telefone
			aAdd(aDados, aDadSA1[4] )		// Cliente SA1 - tipo Telefone
			aAdd(aDados, aDadSU5[4] )		// Contato SU5 - tipo telefone
			aAdd(aDados, aDadSA1[5] )		// Cliente SA1 - Email
			aAdd(aDados, aDadSU5[5] )		// Contato SU5 - Email
			aAdd(aDados, aDadSA1[6] )		// Cliente SA1 - Endereco
		else
			// Apenas contem dados do Contato - SU5 
			if (len(aDadSU5) > 0)
				aAdd(aDados, "" )			 
				aAdd(aDados, "" )			
				aAdd(aDados, aDadSU5[2] )	
				aAdd(aDados, aDadSU5[3] )	
				aAdd(aDados, " " )	
				aAdd(aDados, aDadSU5[4] )
				aAdd(aDados, " " )	
				aAdd(aDados, aDadSU5[5] )
				aAdd(aDados, " " )	
					
			// Apenas contem dados do Cliente - SA1	
			elseif ( (len(aDadSA1) > 0) ) 
				aAdd(aDados, aDadSA1[2] )	 
				aAdd(aDados, aDadSA1[3] )	 
				aAdd(aDados, "" )			
				aAdd(aDados, "" )			
				aAdd(aDados, aDadSA1[4] )
				aAdd(aDados, "" )		
				aAdd(aDados, aDadSA1[5] )
				aAdd(aDados, "" )		
				aAdd(aDados, aDadSA1[6] )
			// Nao constam dados de Cliente e Contato, retorno vazio
			else
				aAdd(aDados, "" )			
				aAdd(aDados, "" )			
				aAdd(aDados, "" )			
				aAdd(aDados, "" )			
				aAdd(aDados, "" )
				aAdd(aDados, "" )			
				aAdd(aDados, "" )
				aAdd(aDados, "" )			
				aAdd(aDados, "" )			
			endif
		endif					
		cPedGar := ""
	endif

return aDados

//---------------------------------------------------------------
/*/{Protheus.doc} csCreateArq
Funcao responsavel para geracao do arquivo. 

@param	aDados		Array com todos os campos e suas informacoes 
		cCampanha		Nome da campanha 						 
@return	lGerado		Retorna se foi criado o arquivo						

@author	Douglas Parreja
@since	24/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csCreateArq( aDados, cCampanha )

	local cBarra	:= IIf(IsSrvUnix(),'/','\')
	local cSystem	:= cBarra + 'system' + cBarra
	local cArq 		:= ""
	local cDir 		:= ""
	local cFile		:= "" 
	local nX		:= 0
	local nY		:= 0
	local nHandle 	:= 0
	local lGerado	:= .F.
	local aArqGer	:= {}
	local aProcess	:= {}
	local lGravou	:= .F.
	
	default aDados 		:= {}
	default cCampanha	:= ""
	
	cFile := "CAMPANHA_"+cCampanha+"_"+DtoS(Date())+StrTran(Time(),":","")+".csv"
	
	//----------------------------------------------------------------------------------
	// Verifica se o parametro(MV_TOTARQE) esta preenchido para ser exportado o arquivo
	//----------------------------------------------------------------------------------			
	if Empty(cMVExp)
		cDir := cSystem
		////u_autoMsg(cExec,cProcExp,"A CAMPANHA "+cCampanha+" sera gerada no caminho "+cSystem+" devido que o parametro MV_TOTARQE nao esta preenchido")
	else
		cDir := cMVExp
	endIf		
	
	if ( !Empty(cDir) ) 
		nHandle := FCreate(cDir+cFile)
		if ( nHandle > 0 )
			//Cabecalho   1   ;2         ;3              ;4            ;5           ;6           ;7       ;8        ;9          ;10      ;11         ;12          ;13      ;14         ;15         ;16       ;17           ;18           ;19   ;20             ;21                     ;22    
			cArq := "CD_PEDIDO;NM_CLIENTE;DS_RAZAO_SOCIAL;CL_TP_PRODUTO;DT_EXPIRACAO;IC_RENOVACAO;NR_DDDLI;NR_TLISTA;TP_FONE_GAR;NR_DDDCL;NR_TCLIENTE;TP_FONE_CLI;NR_DDDCT;NR_TCONTATO;TP_FONE_CON;EMAIL_GAR;EMAIL_CLIENTE;EMAIL_CONTATO;ID_SZX;END_FAT_CLIENTE;CPF_TITULAR_CERTIFICADO;CNPJ_CERTIFICADO"
			cArq += Chr(13)		
			for nX := 1 to len( aDados )
 				for nY := 1 to len( aDados[nX] )
				
					if nY == len( aDados[nX] )
						cArq += aDados[nX][nY]
						aArqGer:={}
						aAdd( aArqGer, alltrim( aDados[nX][19] ) )		// Codigo SZX 	 (ZX_CODIGO)
						aAdd( aArqGer, ' ' )		
						aAdd( aArqGer, alltrim( aDados[nX][10] ) + alltrim( aDados[nX][11] ) ) //tel Cliente		
						aAdd( aArqGer, alltrim( aDados[nX][13] ) + alltrim( aDados[nX][14] ) ) //Tel Contato
						aAdd( aProcess, aArqGer )
					else
						cArq += aDados[nX][nY]+";"
					endif	
				
				next
				cArq += Chr(13)	
				if FWrite( nHandle, cArq ) > 0
					cArq := ""
				endif
			next	
			FClose(nHandle) 
			////u_autoMsg(cExec,cProcExp,"Gerado arquivo com sucesso! ")
			////u_autoMsg(cExec,cProcExp,"Arquivo: "+cFile)
			////u_autoMsg(cExec,cProcExp,"Pasta: "+cDir)
			if ( len(aProcess) > 0 )
				Begin Transaction
					lGravou := csGravaSZX( aProcess, .F., cFile , "2" )					
					if lGravou
						////u_autoMsg(cExec,cProcExp,"Atualizado status SZX com sucesso")
					else
						////u_autoMsg(cExec,cProcExp,"FALHA na atualizacao SZX.")
					endif
				
				End Transaction 			
			endif			
			lGerado := .T.
		endif
	else
		////u_autoMsg(cExec,cProcExp,"Deve ser informado um diretorio para ser salvo o arquivo da campanha.")	
	endif
	
return lGerado

//---------------------------------------------------------------
/*/{Protheus.doc} csTelValid
Funcao responsavel para validacao do Telefone 

@param	cNumTel		Numero telefone Cliente/Contato
		cTelPedGar	Numero telefone Lista Adm Dados  
@return	lGerado		Retorna se foi criado o arquivo						

@author	Douglas Parreja
@since	31/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
user function csValidTel( cNumTel, cTelPedGar )

	local cNum			:= ""
	local cRetDDD  		:= ""
	local cDDD	   		:= ""
	local cRetNum  		:= ""
	Local cTipoNum      := 'FIXO'
	local lTelValido	:= .F.
	Local aValidCel     := {}
	local aRet	   		:= {}
	local aRetTel  		:= {}
	local aDados   		:= {}
		
	default cNum 		:= ""
	default cTelPedGar	:= ""
	
	//-----------------------------------------------------
	// 1. Retiro caracters especiais, deixo apenas numeros
	//-----------------------------------------------------
	cNum := csValidNum( cNumTel )
	
	if !Empty( cNum )
		//-------------------------------------------------
		// 2. Verifico o tamanho do numero Telefone
		//-------------------------------------------------
		aRet := csValidTam( cNum )
		
		lTelValido	:= aRet[1]
		nTam		:= aRet[2]
			
		if lTelValido
			//-------------------------------------------------
			// 3. Chama funcao que contem todas UF do Brasil 
			//-------------------------------------------------	
			aDDD := A370DddUf()
			//-------------------------------------------------
			// 4. Caso o DDD vem com zero eu retiro
			//-------------------------------------------------	
			if SubStr(cNum, 1, 1) == "0"
				cDDD := SubStr(cNum,2,2)
				cNum := SubStr(cNum,4,9)
			else
				//-------------------------------------------------
				// 4.1 Se variavel for igual ou maior que o tamanho
				// de 10.
				// Exemplo: DDD+8digitos ou DDD+9digitos (celular)
				//-------------------------------------------------			
				if nTam >= 10 
					cDDD := SubStr(cNum,1,2)
					cNum := SubStr(cNum,3,9)
				//-------------------------------------------------
				// 4.2 Contem apenas o numero fixo ou celular e nao
				// consta DDD.
				// Exemplo: 8digitos ou 9digitos (celular)
				//-------------------------------------------------		
				elseIf nTam >= 8 .And. nTam <= 9					
					if len(cTelPedGar) >= 10 
						if SubStr(cTelPedGar,1,1) == "0"
							cDDD := SubStr(cTelPedGar,2,2)
						else
							cDDD := SubStr(cTelPedGar,1,2)
						endif
					endif							   								
				endif
			endif
			if !Empty( cDDD ) .And. !Empty( cNum )
				//-------------------------------------------------
				// 5. Chama funcao que contem todas UF do Brasil 
				//-------------------------------------------------	
				aDDD := A370DddUf()
				//-------------------------------------------------
				// 6. Envio array com UF e o DDD validado acima 
				//-------------------------------------------------		
				cRetDDD := csValidDDD( aDDD, cDDD )
				
				aValidCel:= csValidCel( cNum, cRetDDD )	
				
				cRetNum  := aValidCel[1]
				cTipoNum := aValidCel[2]
				
			endif
		else
			////u_autoMsg(cExec,cProcExp,"Telefone que consta no cadastro "+cNum+" esta invalido. Favor verificar")
		endif
		
		if !Empty(cRetNum) .And. !Empty(cRetDDD)
			aAdd(aRetTel, cRetDDD)	
			aAdd(aRetTel, cRetNum)  
			aAdd(aRetTel, cTipoNum)  
		else	
			aAdd(aRetTel, cDDD)	
			aAdd(aRetTel, cNum)
			aAdd(aRetTel, cTipoNum)  
			////u_autoMsg(cExec,cProcExp,"Como nao foi possivel localizar os dados do cliente (SC5,SZG,SZF) o numero "+cNum+" nao constara o DDD. Favor verificar")
		endif
			
	endIf
	
return aRetTel

//---------------------------------------------------------------
/*/{Protheus.doc} csValidTam
Funcao responsavel para validacao do Telefone 

@param	cTel			Numero Telefone				 
@return	lGerado		Retorna se foi criado o arquivo						

@author	Douglas Parreja
@since	31/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csValidTam( cTel )
	local nTam		:= 0
	local lValido 	:= .F.
	default cTel	:= ""
	
	if !Empty( cTel ) 
		nTam := Len(cTel)
		if (nTam >= 8) .And. (nTam <= 12)
			lValido := .T.			
		endIf
	endIf

return { lValido, nTam } 

//---------------------------------------------------------------
/*/{Protheus.doc} csValidDDD
Funcao responsavel para validacao do Telefone 
				  
@param	aDDD			UF
		cDDD			DDD a ser validado				  
@return	lGerado		Retorna se foi criado o arquivo						

@author	Douglas Parreja
@since	31/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csValidDDD( aDDD, cDDD )
	local cValDDD	:= ""
	local nX 		:= 0 
	default aDDD 	:= {}
	default cDDD 	:= ""
	
	if len(aDDD) > 0 
		for nX := 1 to len(aDDD)
			if !Empty(cDDD)
				if aDDD[nX][1] == cDDD 
					cValDDD := aDDD[nX][1]
					Exit
				endif
			endif
		next		
	endif	
	
return cValDDD

//-------------------------------------------------------------------------
// Rotina | A370LeLin    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Rotina para ler a linha em questão, porém há casos onde a linha
//        | é maior que 1023 caractere.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
static Function A370LeLin()
	Local cLinAtual := ''
	Local cLinProx	:= ''
	Local cRetorno 	:= ''
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
// Rotina | A370Array    | Autor | Robson Goncalves     | Data | 06.03.2014 
//-------------------------------------------------------------------------
// Descr. | Monta um vetor com os dados da linha que está sendo processado.
//        | 
//-------------------------------------------------------------------------
// Uso    | Certisign Certificados Digitais.
//-------------------------------------------------------------------------
Static Function A370Array( cLinha )
	Local nP := 0
	Local aArray := {}	
	Local cDelim := ';'
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

	local aDDD_EST := {}
	
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
	aAdd( aDDD_EST, {'94','PA','Pará'})
	aAdd( aDDD_EST, {'95','RR','Roraima'})
	aAdd( aDDD_EST, {'96','AP','Amapa'})
	aAdd( aDDD_EST, {'97','AM','Amazonas'})
	aAdd( aDDD_EST, {'98','MA','Maranhão'})
	aAdd( aDDD_EST, {'99','MA','Maranhão'})	

Return ( aDDD_EST )

//---------------------------------------------------------------
/*/{Protheus.doc} csGetNum
Funcao responsavel para retornar numero da SXE
				  
@param	cAlias		Alias da tabela 
		cCampo		Campo a ser validado para numeracao				  
@return	cNum			Retorna o numero valido para ser gerado na tabela.						

@author	Douglas Parreja
@since	31/07/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csGetNum( cAlias, cCampo )
	local aArea    	:= GetArea()
	local cNum		:= GetSXENum( cAlias, cCampo )
	local cNumOk	:= ""	
	local cNumProx	:= ""	
	local nSaveSx8 	:= GetSX8Len()
	local nI		:= 0	
	
	default cAlias	:= ""
	default cCampo 	:= ""
	
	DbSelectArea( cAlias )
	DbSetOrder( 1 )
	
	if !dbSeek( xFilial( cAlias ) + cNum )
		if !Empty(cNum) .and. nSaveSx8 > 0
			ConfirmSX8()
		endif
	else
		while empty(cNumOk)
			n1 := Iif( nI == 0, val(cNum), val(cNumProx) )
			n2 := n1 + 1
			cNumProx := StrZero( n2,6,0 )
			while !DbSeek( xFilial( cAlias ) + cNumProx )
				cNumOk 	:= cNumProx
				cNum 	:= cNumOk	
				ConfirmSX8()
				exit
			end
			nI ++ 
		end
	endif
	RestArea( aArea )
	
Return( cNum )

//---------------------------------------------------------------
/*/{Protheus.doc} UsaAutoMsg
Funcao responsavel para verificar se consta o fonte AutoMsg no RPO
para utilizar o conout.
				  
@return	lGerado		Retorna se foi criado o arquivo						

@author	Douglas Parreja
@since	07/08/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function UsaAutoMsg()
	local lUsa := .F.
	
	if FindFunction("////u_autoMsg")
		lUsa := .T.
	else
		conout("[ ATENCAO!!! -  Nao consta o fonte AUTOMSG.prw no RPO. Favor compilar. ] ")
	endif
	
return ( lUsa )

//---------------------------------------------------------------
/*/{Protheus.doc} csValidCel
Funcao responsavel para validar o nono digito do celular.
Verifica de qual estado corresponde e adiciona.


IMPORTANTE: A lista de consulta eh atraves do link da ANATEL
http://sistemas.anatel.gov.br/areaarea/N_Download/Tela.asp
Em "TIPO ARQUIVO" selecionar: "Central CNL"
Em "TIPO CENTRAL" selecionar: "Movel"
Apos selecionado, "Confirmar".
		
		
@param	cNum			Numero do telefone
		cDDD			DDD do telefone
		aDDD			Array com todas UF
						  
@return	lGerado		Retorna se foi criado o arquivo						

@author	Douglas Parreja
@since	13/08/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csValidCel( cNum, cDDD )

	local cRet	 := ""
	Local cTipo	 := "Fixo"
	Local aRet   := {'',''}
		
	default cNum := ""
	default cDDD := ""
	
	if ( !Empty( cNum ) .and. !Empty( cDDD ) )		
		//------------------------------------------------------------------------
		// Somente sera adicionado caso a quantidade de caracteres for igual a 8,
		// ou seja, se estiver com 9 ja entende-se que esta com o nono digito.		
		//------------------------------------------------------------------------
		
		if len( cNum ) == 8			
			//----------------------------------------------------------------
			// A partir de 29/05/2016
			//
			// Obs.: Atualizacao conforme pdf ANATEL 27/05/2016
			//
			// VALIDACAO:
			// Caso o primeiro caracter venha com o numero X, eh verificado
			// o estado, e somente apos isso eh adicionado o nono digito.
			// 
			// DDD: 61					UF:DF	Distrito Federal
			// DDD: 63					UF:TO	Tocantins
			// DDD: 62|64				UF:GO	Goias
			// DDD: 65|66				UF:MT	Mato Grosso
			// DDD: 67					UF:MS	Mato Grosso do Sul
			// DDD: 68					UF:AC	Acre
			// DDD: 69					UF:RO	Rondonia
			//----------------------------------------------------------------
			if DTOS(Date()) >= "20160529"
				if cDDD $ "61|62|63|64|65|66|67|68|69"
					if SubStr( cNum,1,1) $ "7|8|9"
						cRet := "9"+cNum
						cTipo:= "Celular"				
					endif
				endif	
			endif
			//----------------------------------------------------------------
			// A partir de 06/11/2016
			//
			// Obs.: Atualizacao conforme pdf ANATEL 27/05/2016
			//
			// VALIDACAO:
			// Caso o primeiro caracter venha com o numero X, eh verificado
			// o estado, e somente apos isso eh adicionado o nono digito.
			// 
			// DDD: 41|42|43|44|45|46	UF:PR 	Parana
			// DDD: 47|48|49			UF:SC	Santa Catarina
			// DDD: 51|53|54|55			UF:RS	Rio Grande do Sul			
			//----------------------------------------------------------------
			if DTOS(Date()) >= "20161106"
				if cDDD $ "41|42|43|44|45|46|47|48|49|51|53|54|55"
					if SubStr( cNum,1,1) $ "7|8|9"
						cRet := "9"+cNum				
						cTipo:= "Celular"				
					endif
				endif	
			endif
			//----------------------------------------------------------------
			// A partir de 11/10/2015
			//
			// DDD: 31|32|33|34|35|37|38	UF:MG 	Minas Gerais
			// DDD: 71|73|74|75|77			UF:BA	Bahia
			// DDD: 79						UF:SE	Sergipe			
			//----------------------------------------------------------------
			if Empty( cRet )
				if DTOS(Date()) >= "20151011"
					if cDDD $ "31|32|33|34|35|37|38|71|73|74|75|77|79"
						if SubStr( cNum,1,1) $ "7|8|9"
							cRet := "9"+cNum				
							cTipo="Celular"
						endif
						/*if SubStr( cNum,1,1) $ "8|9"
							cRet := "9"+cNum				
							cTipo="Celular"
						endif*/
					endif
				endif
			endif
			//----------------------------------------------------------------
			// Acrescenta o nono digito imediatamente
			//
			// DDD: 11|12|13|14|15|16|17|18|19	UF:SP	Sao Paulo
			// DDD: 21|22|24					UF:RJ	Rio de Janeiro
			// DDD: 27|28						UF:ES	Espirito Santo
			// DDD: 81|87						UF:PE	Pernambuco
			// DDD: 82							UF:AL	Alagoas
			// DDD: 83							UF:PB	Paraiba
			// DDD: 84							UF:RN	Rio Grande do Norte
			// DDD: 85|88						UF:CE	Ceara
			// DDD: 86|89						UF:PI	Piaui
			// DDD: 91|93|94					UF:PA	Para
			// DDD: 92|97						UF:AM	Amazonas
			// DDD: 95							UF:RR	Roraima
			// DDD: 96							UF:AP	Amapa
			// DDD: 98|99						UF:MA	Maranhao				
			//----------------------------------------------------------------			
			if Empty( cRet ) 				
				if cDDD $ "12|13|14|15|16|17|18|19|22|24|27|28|81|83|85|91|92|93|94|95|96|97|98|99"		
					if SubStr( cNum,1,1) $ "7|8|9"
						cRet := "9"+cNum				
						cTipo="Celular"
					endif
				elseif cDDD $ "82|84|86|87|88|89"
					if SubStr( cNum,1,1) $ "8|9"
						cRet := "9"+cNum
						cTipo="Celular"
					endif
				elseif cDDD $ "11|21"
					if SubStr( cNum,1,1) $ "5|6|7|8|9"
						cRet := "9"+cNum				
						cTipo="Celular"
					endif
				endif			
			endif 
		else 
			if len( cNum ) >= 9 .and. SubStr( cNum,1,1) $ "5|6|7|8|9"
				cTipo="Celular"
			Endif
		endif
	endif
	if Empty( cRet )
		cRet := cNum
	endif
	aRet:={cRet,cTipo}
return aRet

//---------------------------------------------------------------
/*/{Protheus.doc} csValidUtil
Funcao responsavel para validar a data se eh um dia util.
				  
@param	dData		Data atual 	   
		lGerDiaria	.F. -> Gerar conforme validacao da funcao e 
							e variavel lAglutina.
					.T. -> Como se trata de geracao diaria, nao
							sera gerado Aglutinacao.
							 			  
@return	aDados		[1]Dia util ou nao
					[2]Data Hoje ou Posterior								
					[3]Data Posterior

@author	Douglas Parreja
@since	24/08/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csValidUtil( dDataHj, lGerDiaria )
	
	local aDados		:= {}
	local lAglutina		:= .F.
	
	default dDataHj 	:= Date()              
	default lGerDiaria	:= .F.
	
	if !Empty( dDataHj )
	
		if ( dDataHj == DataValida( dDataHj, .F. ))
		
			// Validando se eh dia para realizar Aglutinado
			aDados := csAglutina( dDataHj, lGerDiaria )
			
			// Caso retorne zero eh pq nao eh data para aglutinar
			if ( len(aDados) == 0 )		
						
				// Validando para caso for sabado ou feriado
				if ( dDataHj == DataValida( dDataHj + 1, .F. ))  
					
					// Validando se eh dia para realizar Aglutinado
					aDados := csAglutina( dDataHj + 1, lGerDiaria )		// Sabado
					if ( len(aDados) == 0 )
						aDados := csAglutina( dDataHj + 2, lGerDiaria )	// Domingo
					endif
					if ( len(aDados) == 0 )
						aDados := csAglutina( dDataHj + 3, lGerDiaria )	// Feriado
					endif
					
					// Caso retorne zero eh pq nao eh data para aglutinar
					if ( len(aDados) == 0 )
						aAdd(aDados, .T. )
						aAdd(aDados, dDataHj + 1 )						
						
						// Validando para caso for domingo, ou seja, sexta-feira mais 2 dias, total domingo. 
						// Caso for feriado na semana, ele vai retornar data diferente, nesse caso nao vou levar data.
						// Ex: Hoje eh terca-feira, quarta eh feriado, entao dDataHj + 2 dias sera quinta-feira, 
						// e com isso a data sera diferente.
						if ( dDataHj == DataValida( dDataHj + 2, .F. ))
							// D+3, caso o feriado seja na segunda-feira, ou seja, Sabado(D+1) | Domingo(D+2) | Segunda Feriado(D+3)
							if ( dDataHj == DataValida( dDataHj + 3, .F. ))
								aAdd(aDados, dDataHj + 3 )
								aAdd(aDados, lAglutina )
							else	
								aAdd(aDados, dDataHj + 2 )
								aAdd(aDados, lAglutina )
							endif
						else
							aAdd(aDados, "" )
							aAdd(aDados, lAglutina )
						endif
					endif
				
				// Validando caso a Data de Hoje for diferente da data+1, ou seja, quer dizer que se trata de uma data util.
				// Ex: Hoje eh terca-feira e quarta NAO eh feriado, portanto eh dia util. 
				elseif ( dDataHj <> DataValida( dDataHj + 1, .F. ))
					aDados := csAglutina( dDataHj, lGerDiaria )
					// Caso retorne zero eh pq nao eh data para aglutinar
					if ( len(aDados) == 0 )
						aAdd(aDados, .T. )
						aAdd(aDados, dDataHj )
						aAdd(aDados, "" )
						aAdd(aDados, lAglutina )
					endif
				endif
			endif
		else
			aAdd(aDados, .F. )
			aAdd(aDados, dDataHj )
			aAdd(aDados, "" )   
			aAdd(aDados, lAglutina )
		endif
	endif

return aDados

//---------------------------------------------------------------
/*/{Protheus.doc} csValidRetData
Funcao responsavel para validar o retorno da Data, e efetuar todo
o tratamento e validacao se tera a segunda data ou nao.
				  
@param	aDados		[1]Dia util ou nao
					[2]Data Hoje ou Posterior								
					[3]Data Posterior
								  
@return	aRet		[1]Data Hoje ou Posterior								
					[2]Data Posterior

@author	Douglas Parreja
@since	24/08/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csValidRetData ( aDados )

	local cDataExp1	:= ""
	local cDataExp2	:= ""
	local dData1	:= Ctod('')
	local dData2	:= Ctod('')
	local aRet		:= {}
	local nCalculo	:= IIf (!Empty(nMVDia), nMVDia, 20 ) 	
	local lAglutina	:= .F.	
	
	default aDados := {}

	// Valida data para realizar a ligacao D+20, o que estiver definido no parametro MV_TOTDIA
	if nCalculo > 0 .and. len( aDados ) > 0
		dData1 	 := Iif( !Empty( aDados[2] ), aDados[2], Date() 	)
		dData2   := Iif( !Empty( aDados[3] ), aDados[3], "" 	  	)	
		nCalculo := Iif( valtype(nCalculo) == "N", nCalculo, val(nCalculo) )		
		cDataExp1:= Dtos(dData1  + nCalculo)
		cDataExp2:= Iif( !Empty(dData2), Dtos(dData2 + nCalculo), "" 	)
		lAglutina:= Iif( !Empty( aDados[4] ), aDados[4], lAglutina 	)  
	endif
	
	aAdd( aRet, cDataExp1 )
	aAdd( aRet, cDataExp2 )
	aAdd( aRet, lAglutina )
	
return aRet

//---------------------------------------------------------------
/*/{Protheus.doc} csDBConexao
Funcao responsavel para realizar a conexao com o Banco de Dados.
(Data Base Conexao)
				    
@param 	nBanco		Define qual banco voce deseja conectar
					1=POSTGRES | 2=MSSQL/ORACLE 				    
@return	lReturn		Informa se conseguiu conectar no Banco de Dados

@author	Douglas Parreja
@since	03/09/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csDBConexao( nBanco )

	local cProc		:= "BANCO DE DADOS  "		
	local cBanco	:= alltrim( getMv("MV_TOTBANC") )		//"postgres/TOTALIP"		 
	local cServico	:= alltrim( getMV("MV_TOTSERV") )		//"localhost" 			 
	local nPorta	:= getMV("MV_TOTPORT") 				//7890					 
	local nX		:= 0
	local lReturn	:= .T.
	local nHErp		:= AdvConnection()
	
	default nBanco	:= 2		// 1=POSTGRES | 2=MSSQL/ORACLE (conexao atual)
	
	//----------------------------------------
	// Conexao com o banco de dados TOTALIP
	//----------------------------------------
	TCConType("TCPIP")
	
	//----------------------------------------
	// Banco de Dados POSTGRES
	//----------------------------------------
	if nBanco == 1 
		nHndDB := TCLink(cBanco, cServico, nPorta)
		
		if nHndDB > 0
			////u_autoMsg(cExec,cProc," Banco "+TcGetDB()+" com o servico "+cServico+ " conectado. " )
		else
			for nX := 1 to 5
				if TcUnLink(nHndDB)
					nHndDB := TCLink(cBanco, cServico, nPorta)
				else 
					////u_autoMsg(cExec,cProc," Erro ("+Str(nHndDB,4)+") ao conectar com "+cBanco+" em "+cServico )
					lReturn := .F.
				endif
				if nHndDB < 0
					lReturn := .F.
					////u_autoMsg(cExec,cProc," FALHA ("+Str(nHndDB,4)+") ao conectar com "+cBanco+" em "+cServico+"...Tentativa: "+Str(nX) )
					sleep(2000)
				else
					exit
				endif
				// Validacao para caso nao consiga conectar no banco POSTGRES apos as 5 tentativas
				if nX == 5 .and. nHndDB < 0
					lReturn := .F.
					////u_autoMsg(cExec,cProc," FALHA ("+Str(nHndDB,4)+") ao conectar com "+cBanco+" em "+cServico+"...Sera gerado arquivo" )
				endif
			next
		endif
	//----------------------------------------
	// Banco de Dados ATUAL (MSSQL/ORACLE)
	//----------------------------------------		
	elseif nBanco == 2
			
		// Volta para conexao ERP
		tcSetConn(nHErp)
		////u_autoMsg(cExec,cProc," Banco "+TcGetDB()+" conectado. " )
					
	endif
	
	//----------------------------------------
	// Mostra a conexao ativa
	//----------------------------------------
	

return lReturn

//---------------------------------------------------------------
/*/{Protheus.doc} csDBInsert
Funcao responsavel para realizar o INSERT no Banco de Dados TOTALIP.
(Data Base Insert)
				  
@param		aDados		Dados a ser processado da campanha importada			 				  
			cCampanha		Nome da campanha
@return		lReturn		Foi concluido com sucesso o INSERT	

@author	Douglas Parreja
@since	04/09/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csDBInsert( aDados, cCampanha, lAglutina )

	local cQuery	:= ""
	local cFile		:= "Insert TOTALIP - "  + Dtoc( Date() ) + ' - ' + Time() 
	local cOrigem	:= ' Importado: ' + Dtoc( Date() ) + ' - ' + Time() 
	local cProc		:= "INSERT CAMPANHA "
	local cTel		:= ""
	local nX		:= 0
	local lReturn	:= .T.
	local aProcUni	:= {}
	local aProcess	:= {}
	local aRet		:= {}
	
	local aTmpProc	:= {}
	local nTamDados	:= 0
	local nLimite	:= 0
	local nY		:= 0
	local nCount	:= 0
	
	default aDados		:= {}
	default cCampanha	:= ""
	default lAglutina	:= .F.
	
	nTamDados := Len(aDados)
	
	if nTamDados > 0	.and. !Empty( cCampanha )	
		
		for nX := 1 to nTamDados
		
			nCampanha := csDBCampanha(cCampanha)
			cQuery := ""
			cTel := ""		
			
			cQuery := "INSERT INTO importar_discador ( "
	        cQuery += "   id_campanha,"			// 1
	        cQuery += "	identificador1," 		// 2
	        cQuery += "	identificador2,"		// 3
	        cQuery += "	identificador3,"		// 4
	        cQuery += "	identificador4,"		// 5
	        cQuery += "	identificador5,"		// 6
	        cQuery += "	identificador6,"		// 7
	        //cQuery += "  identificador7,"		// 8
	        cQuery += "	ddd1,"				// 9
	        cQuery += "	ddd2," 				// 10	
	        cQuery += "	ddd3," 				// 11
	        cQuery += "	telefone1,"			// 12
	        cQuery += "	telefone2," 			// 13
	        cQuery += "	telefone3)"			// 14
	        
	        cQuery += " VALUES " 
     	       	
			aTmpProc := {}
			aProcess := {}
			
			If (nTamDados - nX) < 400
				nLimite := nX + (nTamDados - nX)
			Else
				nLimite := (nX + 400)
			EndIf	  
			
			For nY := nX to nLimite
				AAdd( aTmpProc, aDados[ nY ] )		
			Next 

			nX := nY-1	
									
			For nY := 1 To Len( aTmpProc )

	       		aProcUni := {}    	    		   		
	       		if !lAglutina .or. ( lAglutina .and. ( (alltrim(aTmpProc[nY,7]) + alltrim(aTmpProc[nY,8])) <> cTel)  )       			
	       			cQuery += Iif ( nY > 1, "," , "" )        		
		       		cQuery += " ( "+ alltrim(Str(nCampanha))+ ", "			// 1- CODIGO CAMPANHA		(ZX_LISTA)
			        cQuery += " '" + aTmpProc[nY,1] + "', "					// 2- COD PEDGAR			(ZX_CDPEDID)
			        cQuery += " '" + aTmpProc[nY,2] + "', "					// 3- NOME DO CLIENTE 		(ZX_NMCLIEN) 
			       	cQuery += " '" + aTmpProc[nY,5] + "', "					// 4- DATA EXPIRACAO		(ZX_DTEXPIR)			        
			        cQuery += " '" + aTmpProc[nY,3] + "', "					// 5- RAZAO SOCIAL			(ZX_DSRAZAO)
			        cQuery += " '" + aTmpProc[nY,4] + "', "					// 6- DESCRICAO PRODUTO		(ZX_DSPRODU)
			        cQuery += " '" + aTmpProc[nY,6] + "/" + cOrigem + "', "			// 7- IC RENOVACAO			(ZX_ICRENOV) + ORIGEM DA INCLUSAO
			        //cQuery += " '" + aTmpProc[nY,6] + "', "			// 8- IC RENOVACAO			(ZX_ICRENOV)	        	           
			        cQuery += " '" + aTmpProc[nY,7] + "', "					// 9- DDD LISTA ADM DADOS 	(ZX_NRTELEF)
			        cQuery += " '" + aTmpProc[nY,9] + "', "					// 10-DDD CLIENTE	
			        cQuery += " '" + aTmpProc[nY,11]+ "', "					// 11-DDD CONTATO 
			        cQuery += " '" + aTmpProc[nY,8] + "', "					// 12-TELEFONE ADM DADOS 	(ZX_NRTELEF)
			        cQuery += " '" + aTmpProc[nY,10]+ "', "					// 13-TELEFONE CLIENTE	
			        cQuery += " '" + aTmpProc[nY,12]+ "')"					// 14-TELEFONE CONTATO 
					
					//if nY == len( aTmpProc )
					//	cQuery += ";"
					//else
					//	cQuery += ","
					//else
					//	cQuery += " "
					//endif
										   	        								        	
			        aAdd( aProcUni, alltrim( aTmpProc[nY,13] ) )							//1 CODIGO (ID) TABELA SZX (ZX_CODIGO)	
					aAdd( aProcUni, alltrim( aTmpProc[nY,7] )  + alltrim( aTmpProc[nY,8] ) )	//2 DDD LISTA ADM DADOS+TELEFONE ADM DADOS
					aAdd( aProcUni, alltrim( aTmpProc[nY,9] )  + alltrim( aTmpProc[nY,10] ) )	//3	DDD CLIENTE+TELEFONE CLIENTE
					aAdd( aProcUni, alltrim( aTmpProc[nY,11] ) + alltrim( aTmpProc[nY,12] ) )	//4 DDD CONTATO+TELEFONE CONTATO
				
					if len(aProcUni) > 0
						aAdd( aProcess, aProcUni )
					endif	
					cTel := Iif( lAglutina, alltrim(aTmpProc[nY,7]) + alltrim(aTmpProc[nY,8]), "" )
				else
				    aAdd( aProcUni, alltrim( aTmpProc[nY,13] ) )							//1 CODIGO (ID) TABELA SZX (ZX_CODIGO)	
					aAdd( aProcUni, alltrim( aTmpProc[nY,7] )  + alltrim( aTmpProc[nY,8] ) )	//2 DDD LISTA ADM DADOS+TELEFONE ADM DADOS
					aAdd( aProcUni, alltrim( aTmpProc[nY,9] )  + alltrim( aTmpProc[nY,10] ) )	//3	DDD CLIENTE+TELEFONE CLIENTE
					aAdd( aProcUni, alltrim( aTmpProc[nY,11] ) + alltrim( aTmpProc[nY,12] ) )	//4 DDD CONTATO+TELEFONE CONTATO
				
					if len(aProcUni) > 0
						aAdd( aProcess, aProcUni )
					endif	
				endif
			next nY	
						
			//------------------------------------------
			// GRAVA no Banco de dados TOTALIP
			//------------------------------------------
			if !Empty(cQuery)	.and. (len(aProcess) > 0)	
				cQuery += ";"	
				//------------------------------------------
				// Realiza a conexao com o Banco de Dados
				//------------------------------------------
				TcUnLink(nHndDB)
				lConexao := csDBConexao(1)	
				if lConexao
					nRet := TcSQLExec(cQuery)	
					if nRet >= 0
						////u_autoMsg(cExec,cProc,"Realizado INSERT (TOTALIP) com sucesso de " + alltrim(Str(len(aTmpProc))) + " registros"  )		
						if len( aProcess ) > 0
							if lAglutina				
								csGravaZZQ( @aProcess, cCampanha, cOrigem )
							endif
							csGravaSZX( aProcess, .F. , cFile , "3", aRet )						
						endif
					else 
						////u_autoMsg(cExec,cProc," FALHA na gravacao do INSERT : Erro ("+Str(nRet,4)+") --> " + TCSQLError() )
						lReturn := .F.
					endif
				endif
			else
				////u_autoMsg(cExec,cProc," Erro  - Nao possui dados na variavel para realizar o INSERT no Banco" )
				////u_autoMsg(cExec,cProcExp,cQuery)
				lReturn := .F.
			endif
		
		next nX		      
		
	endif
	
return lReturn

//---------------------------------------------------------------
/*/{Protheus.doc} csDBConsulta
Funcao responsavel para realizar a consulta no Banco de Dados TOTALIP.
(Data Base Insert)
				  
@return	cCodPedGar		Retorna codigo PEDGAR			

@author	Douglas Parreja
@since	04/09/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csDBConsulta()

	local cQuery		:= ""
	local cCodPedGar	:= ""
	
	cQuery := "SELECT "
	cQuery += "	id_campanha, "
	cQuery += "	identificador1,"
	cQuery += "	identificador2,"
	cQuery += "	identificador3,"
	cQuery += "	identificador4,"
	cQuery += "	identificador5,"
	cQuery += "	identificador6,"
	cQuery += "	ddd1,"
	cQuery += "	telefone1,"
	cQuery += "	ddd2,"
	cQuery += "	telefone2,"
	cQuery += "	ddd3,"
	cQuery += "	telefone3,"
	cQuery += "FROM importar_discador"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "QRYTOTIP", .F., .T.)
	
	DbSelectArea("QRYTOTIP")
	DbGoTop()
	
	//Realizar tratamento para quando precisar fazer a consulta
	while !Eof()
		cCodPedGar := QRYTOTIP->identificador1		
	enddo
	
return cCodPedGar	


//---------------------------------------------------------------
/*/{Protheus.doc} csDBCampanha
Funcao responsavel para realizar um DE-PARA no código da campanha para
ser inputado no TOTALIP.
				  
@param	cCampanha			Campanha que esta sendo tratado no momento	 				  
@return	nCod				Retorna o codigo da campanha para o INSERT		

@author	Douglas Parreja
@since	04/09/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csDBCampanha( cCampanha )

	local nCod		:= 0
	local aCamp		:= {}
	local cMVCamp	:= getMV( "MV_TOTCAMP" )
	
	default cCampanha:= ""
	
	aCamp := StrTokArr( cMVCamp , ';' ) 
	
	if (!Empty( cCampanha )) .and. (len(aCamp) > 0)
		if alltrim(cCampanha) == "FACESP"
			//nCod := 54
			nCod := val(aCamp[1])
		elseif alltrim(cCampanha) == "ESTADO"
			//nCod := 53
			if len(aCamp) > 1
				nCod := val(aCamp[2])
			endif
		elseif alltrim(cCampanha) == "NAOPG"
			//nCod := 55
			if len(aCamp) > 2
				nCod := val(aCamp[3])
			endif	
		elseif alltrim(cCampanha) == "BASE"
			//nCod := 49
			if len(aCamp) > 3
				nCod := val(aCamp[4])
			endif
		endif
	endif

return nCod


//---------------------------------------------------------------
/*/{Protheus.doc} csExpArq
Funcao responsavel para exibir ao usuario uma tela para que selecione 
o diretorio para exportar o arquivo (campanha) gerado.		

Ao usuario clicar no menu, eh chamado essa funcao na qual verifica 
se o parametro MV_TOTEXP esta True (T), pois caso esteja falso (F) 
o usuario nao tera acesso.		 	
Isso foi definido porque a rotina principal ja realizara o INSERT
no TOTALIP, essa rotina de exportacao eh uma contingencia e com isso
ficara desabilitada.

@author	Douglas Parreja
@since	26/09/2015
@version	11.8
/*/
//---------------------------------------------------------------
user function csExpArq()
	
	local cTitulo  := "TOTAL IP - Exportação de CAMPANHAS"
	
	if !GetMv( "MV_TOTDAT", .T. )
		CriarSX6( "MV_TOTDAT", 'L' , '(T)Sera exibido do dia (F)Todos arquivos', '.T.' )
	endif
	if !GetMv( "MV_TOTEXP", .T. )
		CriarSX6( "MV_TOTEXP", 'L' , '(T)Usuario pode acessar a rotina (F)Nao acessa', '.F.' )
	endif
	
	if getMV( "MV_TOTEXP" )
		csExpTela()
	else
		Aviso( cTitulo, "Não é possível acessar a rotina para exportação devido a mesma estar desabilitada. Favor acionar a equipe Sistemas Corporativos.", {"Ok"} )
	endif

return
//---------------------------------------------------------------
/*/{Protheus.doc} csExpTela
Funcao responsavel para a montagem da Tela.				 	

@author	Douglas Parreja
@since	29/09/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csExpTela()	
	local oDlg
	local cVar     := ""
	local cTitulo  := "TOTAL IP - Exportação de CAMPANHAS"

	local oOk      := LoadBitmap( GetResources(), "CHECKED" )   
	local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) 
	local oChk1
	local lChk1 	:= .F.
	local lChk2 	:= .F.
	local oLbx
	local nX		:= 0
	
	local CMVEXP	:= getMV( "MV_TOTARQE" ) 
	local aArqDir 	:= {}
	local aArq 		:= DIRECTORY( cMVExp + "*.CSV", "D")
	local lDataDia 	:= .F.
	local cBarra	:= IIf(IsSrvUnix(),'/','\')	
	
	lDataDia := GetMv( "MV_TOTDAT" )
		
	//-------------------------------------------------
	// Monta a tela para usuario realizar a exportacao 
	//-------------------------------------------------
	if len( aArq ) > 0
		for nX := 1 to len( aArq )
			if lDataDia
				if aArq[nX][3] == DATE()
					aAdd( aArqDir, {.F. , alltrim(aArq[nX][1]) , aArq[nX][3] } )
				endif
			else
				aAdd( aArqDir, {.F. , alltrim(aArq[nX][1]) , aArq[nX][3] } )
			endif
		next	
	endif
	if len( aArqDir ) == 0	   	
	   Aviso( cTitulo, "Nao existe arquivos a serem exportados na data de hoje", {"Ok"} )
	   aAdd( aArqDir, {.F. , "" , "" } )
	endif
	
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 440,740 PIXEL
	   
	@ 10,10 SAY "Selecione os arquivos das campanhas TOTAL IP para serem exportados" SIZE 300,100 OF oDlg PIXEL 	
	   
	@ 30,10 LISTBOX oLbx FIELDS HEADER " ", "Data Arquivo", "Nome Arquivo" SIZE 350,130 OF oDlg ;
		PIXEL ON dblClick(aArqDir[oLbx:nAt,1] := !aArqDir[oLbx:nAt,1])
	
	oLbx:SetArray( aArqDir )'
	oLbx:bLine := {|| {Iif(aArqDir[oLbx:nAt,1],oOk,oNo),;
	                       aArqDir[oLbx:nAt,3],;
	                       aArqDir[oLbx:nAt,2] }}	
	
	// Marca | Desmarca Todos
	@ 170,10 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca Todos" SIZE 70,7 PIXEL OF oDlg ;
		ON CLICK( aEval( aArqDir, {|x| x[1] := lChk1 } ),oLbx:Refresh() )

	DEFINE SBUTTON FROM 190,330 TYPE 1 ACTION ( csExpValid(aArqDir,CMVEXP) ) ENABLE OF oDlg   
	DEFINE SBUTTON FROM 190,300 TYPE 2 ACTION ( IIf( MsgYesNo("Deseja sair do sistema ?", "TOTAL IP - Exportação Arquivo" ),oDlg:End(),"" ))  /*oDlg:End()*/ ENABLE OF oDlg      
	ACTIVATE MSDIALOG oDlg CENTER

Return

//---------------------------------------------------------------
/*/{Protheus.doc} csExpValid
Funcao responsavel para validar a Exportacao do arquivo. 
Nesta funcao eh exibido a Tela e realizado a copia do arquivo.

			  
@param	aArq		Arquivo a ser copiado
		cMVEXP	Endereco do parametro MV_TOTARQE, aonde constam os 
				arquivos a serem copiados.						

@author	Douglas Parreja
@since	27/09/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csExpValid( aArq, CMVEXP )
	
	local cTitulo  	:= "TOTAL IP - Exportação de CAMPANHAS"
	local nX	 	:= 0
	local aLog 		:= {}
	default aArq 	:= {}
	default CMVEXP 	:= ""
	
	if len( aArq ) > 0 .and. !Empty(CMVEXP)	
		
		// Abre a tela para usuario selecionar o diretorio aonde sera exportado
		cFile := cGetFile('TOTAL IP','TOTAL IP',0,'C:\',.T.,GETF_LOCALHARD+GETF_RETDIRECTORY+GETF_NETWORKDRIVE,.F.)		
		
		if !Empty(cFile)
			for nX := 1 to len( aArq )
				if aArq[nX][1] .and. !Empty(aArq[nX][2]) .and. !Empty(aArq[nX][3])
				
					// Realiza a copia do arquivo	
					lCopied := __CopyFile( CMVEXP + alltrim(aArq[nX][2]), cFile + alltrim(aArq[nX][2]) ) 
					
					// Adiciona para ser exibido no log
					if lCopied
						aAdd(aLog, alltrim(aArq[nX][2]) )
					endif		
				endif
			next
		else
			Aviso( cTitulo, "Favor selecionar um diretório para ser exportado", {"Ok"} )
		endif
		if len(aLog) > 0
			csLog(aLog)
		else	   	
			if !Empty(cFile)
				Aviso( cTitulo, "Nao existe arquivos a serem exportados na data de hoje", {"Ok"} )
			endif
		endif 	
	endif 
	
return

//---------------------------------------------------------------
/*/{Protheus.doc} csLog
Funcao responsavel para exibir o Log dos arquivos exportados.
			  
@param	aLog		Dados dos arquivos copiados.
							
@author	Douglas Parreja
@since	27/09/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csLog( aLog )

	local nX		:= 0
	default aLog	:= {}
	
	AutoGrLog("LOG - EXPORTAÇÃO TOTAL IP")
	AutoGrLog("---------------------------------------------------")
	AutoGrLog("DATA......................: "+Dtoc(MsDate()))
	AutoGrLog("HORA......................: "+Time())
	AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
	AutoGrLog("MÓDULO.................: "+"SIGA"+cModulo)
	AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
	AutoGrLog("NOME EMPRESA.....: "+Capital(Trim(SM0->M0_NOME)))
	AutoGrLog("NOME FILIAL............: "+Capital(Trim(SM0->M0_FILIAL)))
	AutoGrLog("USUÁRIO..................: "+SubStr(cUsuario,7,15))
	AutoGrLog("---------------------------------------------------")
	if len(aLog) > 0
		for nX := 1 to len(aLog)
			AutoGrLog("Arquivos copiados ( "+alltrim(Str(nX))+ " ) ...: "+aLog[nX])
		next
	endif
	
	// Exibe a tela de log	
	MostraErro()

return

//---------------------------------------------------------------
/*/{Protheus.doc} csAglutina
Funcao responsavel para verificar se trata D+15 para realizar a Aglutinacao
			  
@param	dDataValid		Data a ser validada
		lGerDiaria		.F. -> Gerar aglutinado.
						.T. -> Como se trata de geracao diaria, nao
							sera gerado Aglutinacao.
							
@author	Douglas Parreja
@since	13/10/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csAglutina( dDataValid, lGerDiaria )

	local nDias			:= 0
	local aDados		:= {}
	local lPrimeiraCon	:= .F.
	local aRet			:= {}
	
	default dDataValid 	:= Date()
	default lGerDiaria	:= .F.
	
	dbSelectArea("ZZQ")
	ZZQ->( dbSetOrder(2) )		// ZZQ_FILIAL+ZZQ_INPUT
	DBGoBottom()				//vai para ultimo registro
	
	if !Empty(ZZQ->(ZZQ_INPUT) )	
		aRet := csProcZZQ(ZZQ->(ZZQ_TELEF))
		nDias := Iif( len(aRet)>1, aRet[2] , 0 ) 
		lPrimeiraCon := Iif( len(aRet)>2, aRet[3], .F. )
		//---------------------------------------------------------------
		// Estou somando + 1, devido quando realiza a subtracao estah 
		// tirando o dia que consta.
		// Exemplo : 10 - 1 = 9, porem eh necessario constar os 10 dias.
		//---------------------------------------------------------------	
	else
		lPrimeiraCon := .T.
	endif
	
	//---------------------------------------------------------------
	// Caso for igual a 16 significa que ja passou do D+15, portanto 
	// eh para realizar a Aglutinacao.
	// Estou colocando 14, pq dDataValid ja considera 1 dia(1+14=15).
	//---------------------------------------------------------------
	if (nDias >= 16 .or. lPrimeiraCon)  
		aAdd( aDados, .T. )
		aAdd( aDados, dDataValid )
		aAdd( aDados, dDataValid + 14) 
		//---------------------------------------------------------------
		// Se a variavel lGerDiaria estiver como .T. significa que eh a 
		// segunda vez que esta validando e com isso, eh preciso gerar
		// a Query da geracao Diaria, caso contrario gerara Aglutinado.
		//---------------------------------------------------------------
		if lGerDiaria           
			aAdd(aDados, .F. )
		else
			aAdd( aDados, .T. ) 
		endif	
	endif   

return aDados	

//---------------------------------------------------------------
/*/{Protheus.doc} csGravaZZQ
Funcao realiza o processamento para tabela ZZQ(Aglutinacao)
						  
@param	aGrava		Array contendo os dados do processamento SZX
					[1]Codigo Pedido				(ZX_CODIGO)
					[2]Telefone Lista Adm Dados   	(ZX_NRTELEF)
					[3]Telefone SA1				(ZX_TELCLIE)
					[4]Telefone SU5 				(ZX_TELCONT)
											
@author	Douglas Parreja
@since	06/11/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csGravaZZQ( aDados, cCampanha, cOrigem ) 

	local cCodAgl	:= ""
	local cTel		:= ""	
	local nX		:= 0	
	local aRet		:= {}
	
	default aDados 		:= {}
	default cCampanha	:= ""
	default cOrigem		:= "JOB Certisign"
	
	if len( aDados ) > 0 		                                           
		cTel := alltrim( aDados[1,2] )    							
		for nX := 1 to len( aDados )              
			if cTel == alltrim( aDados[nX,2] )
				if len( aRet ) == 0
					cCodAgl := csGrvZZQ( cTel, cCampanha, cOrigem )
					aAdd( aRet, cCodAgl )
				endif
			else
				if len( aRet ) > 0
					aRet 	:= {}
					cTel 	:= alltrim( aDados[nX,2] )
					cCodAgl := csGrvZZQ( cTel, cCampanha, cOrigem )
					aAdd( aRet, cCodAgl )
				endif
			
			endif
			
			if len(aRet) > 0
				aAdd( aDados[nX], aRet )
				cTel := alltrim( aDados[nX,2] )
			endif
						                                          			
		next   
	endif           
	
return 

//---------------------------------------------------------------
/*/{Protheus.doc} csGrvZZQ
Funcao responsavel para gravacao na tabela ZZQ (AGLUTINACAO).
						  
@param	cTel			Telefone cliente
					
@return	Codigo		Codigo da aglutinacao gerado na tabela ZZQ	
							
@author	Douglas Parreja
@since	13/10/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csGrvZZQ( cTel, cCampanha, cOrigem )
	
	local lGrava	:= .F.
	local aRet		:= {}
	local cNum		:= ""

	default cTel 		:= ""
	default cCampanha	:= ""
	default cOrigem		:= ""
	
	dbSelectArea("ZZQ")       
	ZZQ->( dbSetOrder(2)) 	//ZZQ_FILIAL+ZZQ_INPUT
	//DBGoBottom()			//vai para ultimo registro
	if ( ZZQ->(FieldPos("ZZQ_FILIAL")) > 0 .and. ZZQ->(FieldPos("ZZQ_AGLUT")) > 0 .and. ZZQ->(FieldPos("ZZQ_TELEF")) > 0 ;
		.and. ZZQ->(FieldPos("ZZQ_INPUT")) > 0 .and. ZZQ->(FieldPos("ZZQ_ORIGEM")) > 0 .and. ZZQ->(FieldPos("ZZQ_LISTA")) > 0 )
		if !Empty( cTel )
			aRet := csProcZZQ( cTel )
			lGrava := Iif( len(aRet)>0, aRet[1], .F. )
			dbSelectArea("ZZQ")
			if lGrava
				ZZQ->( RecLock("ZZQ",.T.) )
				cNum := csGetNum( 'ZZQ', 'ZZQ_AGLUT' )
				ZZQ->ZZQ_FILIAL	:= xFilial( 'ZZQ' )
				ZZQ->ZZQ_AGLUT 	:= alltrim(cNum)	 
				ZZQ->ZZQ_TELEF	:= cTel
				ZZQ->ZZQ_INPUT	:= Date() 
				ZZQ->ZZQ_ORIGEM	:= alltrim(cOrigem)
				ZZQ->ZZQ_LISTA	:= alltrim(cCampanha)
				ZZQ->(MsUnlock())
			endif
		else
			////u_autoMsg(cExec, ," ## Falha ao inserir registro de Aglutinacao para o Telefone "+cTel+ " .")
		endif	
	endif

return (alltrim(cNum))

//---------------------------------------------------------------
/*/{Protheus.doc} csProcZZQ
Funcao responsavel para realizar a query da tabela ZZQ para retornar a 
ultima data que consta para realizar calculo de Aglutinacao.
						  
						  		  
@return	cQuery		Retorna a String da Query a ser processada.						

@author	Douglas Parreja
@since	17/11/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csProcZZQ( cTel )

	local cRetQuery		:= ""
	local cAliasZZQ		:= ""
	local lOk			:= .T.
	local lPrimeiraCon 	:= .F.
	local nDias			:= 0
	local aRet			:= {}
	
	default cTel		:= ""

	//-----------------------------------------------
	// Query para buscar na ZZQ
	//-----------------------------------------------
	cRetQuery := csQueryZZQ()
	
	//-----------------------------------------------
	// Criando tabela temporaria
	//-----------------------------------------------
	csDBConexao(2)
	cAliasZZQ := executeQuery( cRetQuery )
								
	if !Empty(cAliasZZQ)
		while  !(cAliasZZQ)->(eof()) 
			//---------------------------------------------------------------------------------------
			// Teste de mesa abaixo, neste caso, soh nao poderei realizar a gravacao
			//   quando a: Data, Telefone e Campanha forem iguais, ou seja, ja foi gravado.	
			//	
			//	if dDataHoje <> ZZQ_INPUT (entao é a primeira vez, deixo fazer)
			//		.T.
			//	elseif dDataHoje == ZZQ_INPUT .And. cCampanha <> ZZQ_LISTA
			//		.T.
			//	elseif dDataHoje == ZZQ_INPUT .And. cCampanha == ZZQ_LISTA .And. cTel <> ZZQ_TELEF
			//		.T.
			//	elseif dDataHoje == ZZQ_INPUT .And. cTel == ZZQ_TELEF .And. cCampanha == ZZQ_LISTA
			//		.F.
			//---------------------------------------------------------------------------------------
			if ( Date() == Stod( (cAliasZZQ)->(ZZQ_INPUT) ) .and. alltrim(cTel) == alltrim((cAliasZZQ)->(ZZQ_TELEF)) .and. alltrim(cCampanha) == alltrim((cAliasZZQ)->(ZZQ_LISTA)) )
				lOk := .F.
			endif	
			nDias := ( Date() - Stod((cAliasZZQ)->(ZZQ_INPUT)) ) + 1
			(cAliasZZQ)->(dbSkip())			
		endDo
		&(cAliasZZQ)->(dbCloseArea())
	else
		lPrimeiraCon := .T.	// caso retorne em branco, quer dizer que eh a primeira gravacao
	endif
	
	aAdd(aRet, lOk)
	aAdd(aRet, nDias)
	aAdd(aRet, lPrimeiraCon)
		
return aRet

//---------------------------------------------------------------
/*/{Protheus.doc} csQueryZZQ
Funcao responsavel para realizar a query da tabela ZZQ para retornar a 
ultima data que consta para realizar calculo de Aglutinacao.
						  
						  		  
@return	cQuery		Retorna a String da Query a ser processada.						

@author	Douglas Parreja
@since	17/11/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csQueryZZQ()

	local cQuery := ""
			
	cQuery := "SELECT ZZQ_AGLUT, "
	cQuery += "ZZQ_TELEF, "
	cQuery += "ZZQ_LISTA, "
	cQuery += "ZZQ_INPUT " 
	cQuery += "FROM "+RetSqlName("ZZQ")+ " ZZQ " 
	cQuery += "WHERE "
	cQuery += "ZZQ_FILIAL ='"+xFilial("ZZQ")+"' AND "
	cQuery += "ZZQ_INPUT = (SELECT MAX(ZZQ_INPUT) FROM "+RetSqlName("ZZQ") 
	cQuery += " WHERE "
	cQuery += "ZZQ_LISTA = '"+alltrim(cCampanha)+"' ) AND "          
	cQuery += " D_E_L_E_T_ = ' ' "	          
	
return cQuery


//---------------------------------------------------------------
/*/{Protheus.doc} csTelaTot
Funcao responsavel para gerar a query/processamento, para enviar dados
a funcao csLogTela para que exiba o LOG ao usuario informando os 
ultimos dados processados na base. 
				  					

@author	Douglas Parreja
@since	17/12/2015
@version	11.8
/*/
//---------------------------------------------------------------
user function csTelaTot()

	local oDlg, oSay       
	local oChk
	local lChk1 	:= .F. 
	local lChk2	:= .F.
	local aRet	:= {}
	local oFont 	:= TFont():New("Arial Black",,-14,.T.)
	
	DEFINE MSDIALOG oDlg TITLE "TOTALIP" FROM 0,0 TO 230,552 OF oDlg PIXEL     
	
	@ 06,90 SAY oSay PROMPT "INTEGRAÇÃO ERP x TOTALIP" FONT oFont COLOR CLR_RED OF oDlg PIXEL	
	@ 26,06 TO 110,210 LABEL "Selecione abaixo o Tipo de rotina que deseja acessar:" OF oDlg PIXEL	
	@ 45, 20 CHECKBOX oChk VAR lChk1 PROMPT "Rotina Exportação das campanhas (arquivos .csv)" SIZE 135,8 PIXEL OF oDlg ;		// 1
			ON CLICK(Iif(lChk1,aAdd(aRet,"1"),"" ))               
	@ 80, 20 CHECKBOX oChk VAR lChk2 PROMPT "Log para verificar ultimo processamento na base (Exportado/Insert)" SIZE 180,8 PIXEL OF oDlg ;		// 2			
	         ON CLICK(Iif(lChk2,aAdd(aRet,"2"),"" ))                                      
	@ 40,230 BUTTON "&Ok"       		SIZE 36,16 PIXEL ACTION (cOpcao:="2",oDlg:End())
	@ 60,230 BUTTON "&Cancelar" 		SIZE 36,16 PIXEL ACTION (cOpcao:="3",IIf(msgyesno("Deseja sair da Rotina ?","TOTALIP"),oDlg:End(),(cOpcao:="4",oDlg:End())))   

	ACTIVATE MSDIALOG oDlg CENTER
	
	if len(aRet) > 0
		if len(aRet) > 1
			msgInfo("Atenção: Não pode executar 2 rotinas ao mesmo tempo, favor selecionar apenas 1 e clicar no botão Ok.", "TOTALIP") 
			u_csTelaTot()
		else
			if aRet[1] == "1"
				u_csExpArq()
			elseif aRet[1] == "2"
				csLogProc()
			endif
		endif
	endif
return

//---------------------------------------------------------------
/*/{Protheus.doc} csLogProc
Funcao responsavel para gerar a query/processamento, para enviar dados
a funcao csLogTela para que exiba o LOG ao usuario informando os 
ultimos dados processados na base. 
				  					

@author	Douglas Parreja
@since	17/12/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csLogProc()
	
	local cQuery  	:= ""
	local cQueryRet := ""
	local cCampanha	:= "" 
	local nX		:= 0   
	local aDados	:= {}        
	local aProcess	:= {}
			
	/* DESTA MANEIRA A QUERY NAO TRAZ CORRETAMENTE, UTILIZAR A MANEIRA ABAIXO
	cQuery += "SELECT  ZX_LISTA, ZX_INPUT, ZX_STATUS,ZX_NOMARQ, MAX(ZX_ORIGEM) AS ORIGEM, COUNT(*) AS QTDE "
	cQuery += "FROM "+RetSqlName("SZX") 
	cQuery += " WHERE " 
	cQuery += "ZX_FILIAL ='"+xFilial("SZX")+"' AND "
	cQuery += "ZX_STATUS IN ('2','3')	AND "
	cQuery += "ZX_NOMARQ <> ' '		AND " 
	cQuery += "ZX_INPUT = (SELECT MAX(ZX_INPUT) FROM "+RetSqlName("SZX")+" )"
	cQuery += " AND D_E_L_E_T_ = ' ' " 
	cQuery += "GROUP BY ZX_LISTA, ZX_INPUT, ZX_STATUS,ZX_NOMARQ "  
	cQuery += "ORDER BY ZX_LISTA ASC"

	cQueryRet := ExecuteQuery( cQuery )
		
	if !Empty( cQueryRet )
		while !(cQueryRet)->(eof())
			aAdd( aDados, alltrim( (cQueryRet)->ZX_LISTA ) )		// 1-CAMPANHA
			aAdd( aDados, Dtoc( Stod( (cQueryRet)->ZX_INPUT )) )	// 2-DATA INCLUSAO 
			aAdd( aDados, Str( (cQueryRet)->QTDE) )	   			// 3-QUANTIDADE DE REGISTROS IMPORTADOS 		
			aAdd( aDados, alltrim( (cQueryRet)->ZX_STATUS) )		// 4-STATUS PROCESSAMENTO	
			aAdd( aDados, alltrim( (cQueryRet)->ZX_NOMARQ) )		// 5-DADOS DA EXPORTACAO/IMPORTACAO NO BANCO
			aAdd( aDados, alltrim( (cQueryRet)->ORIGEM) )			// 6-DADOS IMPORTACAO

			if len(aDados) > 0
				aAdd( aProcess, aDados )
				aDados := {}
			endif        
			(cQueryRet)->(dbSkip())
		end		
	endif*/
	
	cQuery += "SELECT ZX_LISTA, MAX(ZX_INPUT) ZX_INPUT, COUNT(*) AS QTDE "
	cQuery += "FROM "+RetSqlName("SZX") 
	cQuery += " WHERE " 
	cQuery += "ZX_FILIAL ='"+xFilial("SZX")+"' AND "
	cQuery += "ZX_STATUS IN ('2','3')	AND "
	cQuery += "ZX_NOMARQ <> ' '		AND " 
	cQuery += "D_E_L_E_T_ = ' ' " 
	cQuery += "GROUP BY ZX_LISTA "   
	cQuery += "ORDER BY ZX_INPUT DESC "
	
	cQueryRet := ExecuteQuery( cQuery )
	
	if !Empty( cQueryRet )
		while !(cQueryRet)->(eof())
			aAdd( aDados, alltrim( (cQueryRet)->ZX_LISTA ) )		// 1-CAMPANHA
			aAdd( aDados, Dtoc( Stod( (cQueryRet)->ZX_INPUT )) )	// 2-DATA INCLUSAO 
		   	//aAdd( aDados, Str( (cQueryRet)->QTDE) )	   			// 3-QUANTIDADE DE REGISTROS IMPORTADOS 		
			//aAdd( aDados, alltrim( (cQueryRet)->ZX_STATUS) )		// 4-STATUS PROCESSAMENTO	
			//aAdd( aDados, alltrim( (cQueryRet)->ZX_NOMARQ) )		// 5-DADOS DA EXPORTACAO/IMPORTACAO NO BANCO
			//aAdd( aDados, alltrim( (cQueryRet)->ORIGEM) )			// 6-DADOS IMPORTACAO

			if len(aDados) > 0
				aAdd( aProcess, aDados )
				aDados := {}
			endif        
			(cQueryRet)->(dbSkip())
		end		
	endif
	
	if len(aProcess) > 0
		csLogTela( aProcess )
	endif

return

//---------------------------------------------------------------
/*/{Protheus.doc} csLogTela
Funcao que exibe um LOG para usuario informando os dados do ultimo 
processamento na base. 
				  					

@author	Douglas Parreja
@since	17/12/2015
@version	11.8
/*/
//---------------------------------------------------------------
static function csLogTela( aLog )

	local nX		:= 0
	default aLog	:= {}
	
	AutoGrLog("LOG - ULTIMO(S) REGISTRO(S) EXPORTADO/IMPORTADO -- TOTAL IP")
	AutoGrLog("------------------------------------------------------------------------------------")
	AutoGrLog("Segue abaixo dados do log: ")
	AutoGrLog("DATA......................: "+Dtoc(MsDate()))
	AutoGrLog("HORA......................: "+Time())
	AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
	AutoGrLog("MÓDULO.................: "+"SIGA"+cModulo)
	AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
	AutoGrLog("NOME EMPRESA.....: "+Capital(Trim(SM0->M0_NOME)))
	AutoGrLog("NOME FILIAL............: "+Capital(Trim(SM0->M0_FILIAL)))
	AutoGrLog("USUÁRIO..................: "+SubStr(cUsuario,7,15))

	if len(aLog) > 0
		for nX := 1 to len(aLog)    
			AutoGrLog("------------------------------------------------------------")
			AutoGrLog("Campanha ........: " +alltrim(aLog[nX][1]) )      
			if len(aLog[nX]) > 1
				AutoGrLog("Data geração ...: "+aLog[nX][2]  )      
			endif      
			if len(aLog[nX]) > 2
				AutoGrLog("Qtde Registro ...: "+ alltrim(aLog[nX][3]) )             
			endif            
			if len(aLog[nX]) > 3    
				if alltrim(aLog[nX][4]) == "2"
					AutoGrLog("Status ...............: Gerado arquivo e Exportado" )  
				endif
				if alltrim(aLog[nX][4]) == "3"
					AutoGrLog("Status ...............: Realizado Insert no Banco TOTALIP" )   
				endif
			endif	  
			if len(aLog[nX]) > 4
				AutoGrLog("Origem Export ..: "+alltrim(aLog[nX][5]) )    
			endif  
			if len(aLog[nX]) > 5
				AutoGrLog("Origem Import ...: "+alltrim(aLog[nX][6]) )  
			endif	 
		next
	else
		AutoGrLog("------------------------------------------------------------")
		AutoGrLog("ATENÇÃO: NÃO POSSUI DADOS A SEREM EXIBIDOS."  )
	endif
	
	// Exibe a tela de log	
	MostraErro()

return

//---------------------------------------------------------------
/*/{Protheus.doc} csValidReproc
Realiza a validacao dos Dados do Reprocessamento recebido, e 
retorna qual tipo a ser executado.

@param	aDados		Dados recebidos do Reprocessamento
@return	lReproc		Retorno logico se trata de Reprocessamento.
		cTipo		Retorna o Tipo do Reprocessamento.
		cDataDe		Retorna a Data informada.
		cDataAte	Retorna a Data informada.		
				  					

@author	Douglas Parreja
@since	11/07/2016
@version 11.8
/*/
//---------------------------------------------------------------
static function csValidReproc( aDados )

	local lReproc	:= .F.
	local cTipo		:= ""
	local cDataDe	:= ""
	local cDataAte	:= ""	
	
	default aDados	:= {}
	
	if len( aDados ) > 0
		lReproc := aDados[1][1]
		if len( aDados[1] ) > 1
			cTipo := aDados[1][2]
			if len( aDados[1] ) > 2
				cDataDe := aDados[1][3]
				if len( aDados[1] ) > 3
					cDataAte := aDados[1][4]
				endif
			endif
		endif					
	endif		

return { lReproc, cTipo, cDataDe, cDataAte }


