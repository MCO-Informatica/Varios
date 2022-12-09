#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'   

/*/{Protheus.doc} CRPJ010
//Rotina responsável pela execução do Job que gera títulos PR no Contas a Pagar
//para remuneração de parceiros.
@author yuri.volpe
@since 28/03/2019
@version 1.0
@param aParam, array, Parametros necessários para execução da rotina {cEmpresa, cFilial}
@type function
/*/
User Function CRPJ010(aParam)

	Local aFile	,aRet	:= {}
	Local lAutoMsg		:= .T.	      
	Local lGerDiaria	:= .F.
	Local lOk,lReproc	:= .F.
	Local nX	 		:=  0
	Local cTipo			:=  ""
	Local cModoExec		:= 	""
	Local cAliasSZ5		:=  ""
	Local lQuery		:= .F.
	Local lContinua		:= .F.
	Local dDate			:= CTOD("//")
		
	Private lMVRemAnt	:= ""
	Private cMVPrefixo	:= ""
	Private cMVNatureza	:= ""
	Private cMVPerRem	:= ""
	Private cMVEmails	:= ""
	Private cMVTipoTit	:= ""
	Private nMVDiaVenc	:= 0
	Private nHdlLog		:= -1
	Private lInsert		:= .F.
	Private cPedGar		:= ""
	Private cExec 		:= "ANTECIPA_COMISSAO (CRPJ010)"
	Private cProcImp	:= "IMPORTACAO LISTA"
	Private cProcExp	:= "GERACAO DADOS SMS"
	Private cAliasQry	:= GetNextAlias()
	Private lJob		:= .T.
	Private cPerRemu 	:= ""
	Private cFullLog	:= ""

	If Len(aParam) < 1
		LogWrite(cExec,"PREPARANDO AMBIENTE","Não foram passados parâmetros para iniciar o processo.")
		Return
	EndIf
		 		
	LogWrite( cExec, "Start Job", "Iniciando JOB" )
	//----------------------	
	// Prepara ambiente
	//----------------------
	csPrepAmb( aParam ) 
	
	//----------------------	
	// Carrega Parâmetros
	//----------------------
	lOk := csCarregaParam()
	
	//----------------------	
	// Trata data de execução
	//----------------------
	dDate := Date()
	If LastDay(dDate,0) != dDate
		lOk := .F.
		LogWrite(cExec, "DATE CHECK","A função foi projetada para ser executada apenas no último dia do mês.")
	EndIf
	
	If lOk
	
		//----------------------------------------------------------------
		// Inicializo log de processamento do Job.
		//----------------------------------------------------------------
		logInit()
	  	
	  	//----------------------------------------------------------------
	  	// Executa Query e, caso haja valores no retorno, processa
	  	// geração dos títulos provisórios.
	  	//----------------------------------------------------------------
	  	If csRunQuery()
	  		If CRPJ010A()
	  			lExecOk := .T.
	  		Else
	  			LogWrite(cExec, "CRPJA010A","A função CRPJ010A não foi executada com sucesso. O processo foi abortado.")
	  		EndIf
	  	Else
	  		LogWrite(cExec, "Query Exec","Não há registros aptos para processamento. O processo foi abortado.")
	  	EndIf
		
		If lExecOk
			LogWrite(cExec, "End Run","A execução foi concluída com sucesso.")
		Else
			LogWrite(cExec, "End Run","Houve um erro na execução da rotina. O processo não foi realizado conforme o esperado.")
		EndIf
		
		LogWrite( cExec, "End Job", "Finalizando JOB" )
		
		(cAliasQry)->(dbCloseArea())
	EndIf
	
	LogEnd()	
		
	RESET ENVIRONMENT   
	
return

//-----------------------------------------------------------------------
/*/{Protheus.doc} CRPJ010Vis
//Rotina responsável pela execução do processamento
@author yuri.volpe
@since 28/03/2019
@version 1.0

@type function
/*/
//-----------------------------------------------------------------------
User Function CRPJ010Vis()

	Local lExecOk 		:= .F.
	Local aParam		:= {}
	Local cPerAtu		:= getPeriodo(GetMV("MV_REMMES"),1)
	
	Private lMVRemAnt	:= ""
	Private cMVPrefixo	:= ""
	Private cMVNatureza	:= ""
	Private cMVPerRem	:= ""
	Private cMVEmails	:= ""
	Private cMVTipoTit	:= ""
	Private nMVDiaVenc	:= 0
	Private nHdlLog		:= -1
	Private nCountRec	:= 0
	Private lInsert		:= .F.
	Private cPedGar		:= ""
	Private cExec 		:= "ANTECIPA_COMISSAO (CRPJ010)"
	Private cProcImp	:= "IMPORTACAO LISTA"
	Private cProcExp	:= "GERACAO DADOS SMS"
	Private lJob		:= .F.
	Private cAliasQry	:= GetNextAlias()
	Private aRet		:= {}
	Private cPerRemu 	:= ""
	Private cFullLog	:= ""
	
	//Parambox para alterar parâmetros, numa eventual execução manual
	aAdd(aParam, {1,"Período Referência", cPerAtu, "@!", "", "", "", 50, .F.})
	aAdd(aParam, {1,"Entidade", Space(6), "@!", "", "", "", 50, .F.})
	
	If ParamBox(aParam,"Antecipação de Comissão",@aRet,,,,,,,,.F.,.F.)
	
		LogInit()
	
		LogWrite(cExec,"Init Run","Inicializando processamento.")
		LogWrite(cExec,"Init Run","Carregando Parâmetros.")
		If csCarregaParam()
			LogWrite(cExec,"Query Exec","Iniciando processamento da query.")
			If csRunQuery()
				LogWrite(cExec,"Query Exec","Iniciando processamento dos registros.")
				Processa({|| lExecOk := CRPJ010A()}, "Processando", "Analisando títulos a serem gerados.", .T.)
			Else
				LogWrite(cExec, "Query Exec","Não há registros aptos para processamento. O processo foi abortado.")
			EndIf
		Else
			LogWrite(cExec, "Load Param","A função csCarregaParam não foi executada com sucesso. O processo foi abortado.")
		EndIf
		
		If lExecOk
			MsgInfo("O processo foi finalizado com sucesso.")
			(cAliasQry)->(dbCloseArea())
		Else
			MsgAlert("O processo foi finalizado, porém ocorreram erros no processamento." + CHR(13) + CHR(10) + "Consulte o log para verificar as possíveis mensagens de erro.")
		EndIf
			
		LogEnd()
	EndIf

Return

//---------------------------------------------------------------
/*/{Protheus.doc} csPrepAmb
 Função para preparação do ambiente para processamento do Job
 @param aParam 

/*/
//---------------------------------------------------------------
static function csPrepAmb( aParam )
	
	local cEmp		:= ""
	local cFil		:= ""
	Local aTables	:= {'SX5','SX6','SIX','SA2','SC7','SE2','ZZ6','SZ6','SZ3','ZZ7','SZ5'}
	
	LogWrite( cExec, , "Preparando Ambiente")
	
	cEmp := IIf( aParam == NIL, '01', aParam[ 1 ] )
	cFil := IIf( aParam == NIL, '02', aParam[ 2 ] )
	
	If lJob
		RpcSetType( 3 )
		RpcSetEnv(cEmp, cFil,,,,, aTables)		
		
		LogWrite( cExec, , "Ambiente preparado para Empresa: " +cEmp+ " - Filial: " +cFil)
	EndIf
		
return	 
    
//---------------------------------------------------------------
/*/{Protheus.doc} LogWrite
Realiza a validacao dos Dados do Reprocessamento recebido, e 
retorna qual tipo a ser executado.

@param	cExec		Dados recebidos do Reprocessamento
		cProcesso	
		cMessage
@return	Nil	
/*/
//---------------------------------------------------------------
Static Function LogWrite(cExec, cProcesso, cMessage )
	
	Default cExec		:= 0		// De qual processo esta sendo executado (nome do Job, Rotina, etc)
	Default cProcesso	:= 0		// A qual processo refere-se (Ex: 1-Transmissao,2-Monitoramento)
	Default cMessage 	:= ""		// Mensagem enviada a ser exibida no Conout
	
	//---------------------------------------------------------------------------------
	// Realizado essa funcao para caso estiver outra userfunction, podera ser chamada 
	// essa funcao somente precisara acrescentar o nProcesso e Descricao.
	//---------------------------------------------------------------------------------
	If LogStatus()
		FWrite(nHdlLog, "[ CRPJ010 - " + Iif(!Empty(cProcesso),cProcesso+" - ","")  + Dtoc( date() ) + " - " + time() + " ] " + Iif(!Empty(cMessage),AllTrim(cMessage),"") + CRLF)
	EndIf
		
	CONOUT( "[ "+ Iif(!Empty(cExec),cExec,"") + " - " + Iif(!Empty(cProcesso),cProcesso+" - ","")  + Dtoc( date() ) + " - " + time() + " ] " + Iif(!Empty(cMessage),AllTrim(cMessage),"") )

	//--------------------------------------------------------------------------------------------
	//	Exemplo: 
	//	** NFSE
	//	[ AUTONFSE JOB(CSJB03) - TRANSMISSAO - 26/06/2015 - 17:47:00 ] - Iniciando o JOB
	//	** TOTALIP
	//	[ TOTALIP JOB(CSTOTIP) - IMPORTACAO LISTA - 07/08/2015 - 16:14:00 ] - Iniciando o JOB
	//--------------------------------------------------------------------------------------------
	
Return

//---------------------------------------------------------------
/*/{Protheus.doc} LogInit
Realiza a validacao dos Dados do Reprocessamento recebido, e 
retorna qual tipo a ser executado.

@param	aDados		Dados recebidos do Reprocessamento
@return	lLogOk		Retorno logico se trata de Reprocessamento.	
/*/
//---------------------------------------------------------------
Static Function LogInit()

	Local cLogName 	:= "crpj010_"+DToS(dDataBase)+StrTran(Time(),":","")+".log"
	Local cLogPath	:= "\remuneracao\antecipacao\"
	
	cFullLog	:= cLogPath + cLogName
	
	nHdlLog := FCreate(cFullLog)
	
	If nHdlLog == -1
		CONOUT("[ CRPJ010 - Log Creation - " + Dtoc( date() ) + " - " + time() + " ] Log file creation failure.")
	Else
		CONOUT("[ CRPJ010 - Log Creation - " + Dtoc( date() ) + " - " + time() + " ] Log file creation successful.")
	EndIf

Return nHdlLog > -1

//---------------------------------------------------------------
/*/{Protheus.doc} LogEnd
Realiza a validacao dos Dados do Reprocessamento recebido, e 
retorna qual tipo a ser executado.

@param	Nil
@return	Nil
/*/
//---------------------------------------------------------------
Static Function LogEnd()

	Local cCorpoMsg := ""
	
	If nHdlLog > -1
		FClose(nHdlLog)
		CONOUT("[ CRPJ010 - Log Closure - " + Dtoc( date() ) + " - " + time() + " ] Log file closed.")
	EndIf
	
	cCorpoMsg := MemoRead(cFullLog)
	
	MandEmail(cCorpoMsg, cMVEmails, "[CRPJ010] Log de Processamento - Geração de Títulos PR")

Return

//---------------------------------------------------------------
/*/{Protheus.doc} LogStatus
Realiza a validacao dos Dados do Reprocessamento recebido, e 
retorna qual tipo a ser executado.

@param	Nil			Dados recebidos do Reprocessamento
@return	lLogOk		Retorno logico se trata de Reprocessamento.
/*/
//---------------------------------------------------------------
Static Function LogStatus()
Return (nHdlLog > -1)

//-----------------------------------------------------------------------
/*/{Protheus.doc} csCarregaParam
Funcao que verifica se consta/configurado parametros e tabela.

@return	lOk		Retorna se o ambiente esta preparado para prosseguir.

@author	Douglas Parreja
@since	13/07/2015
@version	11.8
/*/
//-----------------------------------------------------------------------
static function csCarregaParam()

	Local lOk		:= .T.
	Local cMVPrefix	:= 'MV_XREMPFX'
	Local cMVRemNat	:= 'MV_XREMNAT'
	Local cMVEmail	:= 'MV_XREMAIL'
	Local cMVRemMes	:= "MV_REMMES"
	Local cMVRemAnt	:= "MV_XREMANT"
	Local cMVRemTip := "MV_XREMTIP"
	Local cMVRemDtV	:= "MV_XREMDTV"
	Local cMVProc	:= ""
	Local cMVCamp	:= ""
	Local cMVMail	:= ""

	//-------------------------------------------------------------------------------------------
	// MV_XREMANT - Flag de uso da Remuneração Antecipada
	//-------------------------------------------------------------------------------------------
	If !GetMV( cMVRemAnt, .T. )
		CriarSX6( cMVRemAnt, 'L', 'Flag para ativação da Remuneração Antecipada', ".F." )
		LogWrite(cExec, "Param Check", "Criado parâmetro para controle de execução da Remuneração Antecipada")
	EndIf
	lMVRemAnt := GetMV(cMVRemAnt)
	If Empty(lMVRemAnt)
		LogWrite(cExec, "Param Check",'Não é possivel continuar. Parametro '+cMVRemAnt+' indica que o processo está desativado.' )
		Return .F.
	EndIf


	//-------------------------------------------------------------------------------------------
	// MV_XREMDTV - numero de dias para vencimento do titulo PA, a partir da database
	//-------------------------------------------------------------------------------------------
	If !GetMV( cMVRemDtV, .T. )
		CriarSX6( cMVRemDtV, 'N', 'Número de dias a partir da emissão para vencimento do título ', "3" )
		LogWrite(cExec, "Param Check", "Número de dias a partir da emissão para vencimento do título")
	EndIf
	nMVDiaVenc := GetMV(cMVRemDtV) 
	If Empty( nMVDiaVenc )
		LogWrite(cExec, "Param Check",'Não é possivel continuar. Parametro '+cMVRemDtV+' sem conteudo.' )
		lOk := .F.
	EndIf

	//-------------------------------------------------------------------------------------------
	// MV_XREMTIP - tipo do titulo a ser criado (PR)
	//-------------------------------------------------------------------------------------------
	If !GetMV( cMVRemTip, .T. )
		CriarSX6( cMVRemTip, 'C', 'Tipo titulo a ser criado (PR) para Antecipacao de Comissao', "PR" )
		LogWrite(cExec, "Param Check", "Prefixo do titulo a ser criado (PR)")
	EndIf
	cMVTipoTit := AllTrim(GetMV(cMVRemTip)) 
	If Empty( cMVTipoTit )
		LogWrite(cExec, "Param Check",'Não é possivel continuar. Parametro '+cMVRemTip+' sem conteudo.' )
		lOk := .F.
	EndIf

	//-------------------------------------------------------------------------------------------
	// MV_XREMPFX - prefixo do título a ser criado no processamento
	//-------------------------------------------------------------------------------------------
	If !GetMV( cMVPrefix, .T. )
		CriarSX6( cMVPrefix, 'C', 'Prefixo do titulo a ser criado (PR) para Antecipacao de Comissao', "REM" )
		LogWrite(cExec, "Param Check", "Prefixo do titulo a ser criado (PR)")
	EndIf
	cMVPrefixo := GetMV(cMVPrefix) 
	If Empty( cMVPrefixo )
		LogWrite(cExec, "Param Check",'Não é possivel continuar. Parametro '+cMVPrefix+' sem conteudo.' )
		lOk := .F.
	EndIf

	//-------------------------------------------------------------------------------------------
	// MV_XREMNAT - Natureza a ser utilizada para Antecipacao de Comissao
	//-------------------------------------------------------------------------------------------
	If !GetMV( cMVRemNat, .T. )
		CriarSX6( cMVRemNat, 'C', 'Natureza a ser utilizada para Antecipacao de Comissao', "" )
		LogWrite(cExec, "Param Check", "Natureza a ser utilizada para Antecipacao de Comissao")
	EndIf
	cMVNatureza := GetMV(cMVRemNat) 
	If Empty( cMVNatureza )
		LogWrite(cExec, "Param Check",'Não é possivel continuar. Parametro '+cMVRemNat+' sem conteudo.' )
		lOk := .F.
	EndIf
	
	
	//-------------------------------------------------------------------------------------------
	// MV_REMMES - periodo de remuneracao
	//-------------------------------------------------------------------------------------------
	If !GetMV( cMVRemMes, .T. )
		LogWrite(cExec, "Param Check", "Período de Remuneração")
	EndIf
	cMVPerRem := AllTrim(GetMV(cMVRemMes))
	If Empty(cMVPerRem)
		cMVPerRem := Substr(DTOS(Date()),1,6)
	EndIf
	
	//-------------------------------------------------------------------------------------------
	// MV_XREMAIL - E-mails para eventuais comunicações
	//-------------------------------------------------------------------------------------------
	If !GetMV( cMVEmail, .T. )
		CriarSX6( cMVEmail, 'C', 'Destinatários para recebimento de notificacoes', 'sistemascorporativos@certisign.com.br' )
		LogWrite(cExec, "Param Check", "Criado parametro MV_TWWMAIL - Destinatários de E-mail")
	EndIf
	//cMVEmails := AllTrim(GetMV(cMVEmail))
	cMVEmails := "yuri.volpe@certisign.com.br"
	If Empty(cMVEmails)
		LogWrite(cExec, "Param Check",'Não é possivel continuar. Parametro '+cMVEmails+' sem conteudo.' )
		lOk := .F.
	EndIf
	
return lOk

//-----------------------------------------------------------------------
/*/{Protheus.doc} csRunQuery
//Rotina responsável pela execução do processamento
@author yuri.volpe
@since 28/03/2019
@version 1.0

@type function
/*/
//-----------------------------------------------------------------------
Static Function csRunQuery()

	Local cMesRemu 	 := Substr(cMVPerRem,5,2)
	Local cAnoRemu 	 := Substr(cMVPerRem,1,4)
	Local nLastRem 	 := Val(cMesRemu) - 1
	Local cCondExtra := ""
	Local cQuery	 := ""
	Local cEntidade	 := aRet[2]
	Local cQuery	 := ""
	
	/*//Captura o último periodo fechado para calcular a antecipacao 
	//Se Fevereiro, o valor é zero, se Janeiro, -1.
	//Em Janeiro, considera Novembro do ano anterior como ultimo calculo valido
	If nLastRem == 0
		cPerRemu := cValToChar((Val(Substr(cMVPerRem,1,4))) - 1) + "12"
	ElseIf nLastRem == -1
		cPerRemu := cValToChar((Val(Substr(cMVPerRem,1,4))) - 1) + "11"
	Else
		cPerRemu := Substr(cMVPerRem,1,4) + StrZero(Val(Substr(cMVPerRem,5,2)) - 1, 2)
	EndIf*/
	
	cPerRemu := cMVPerRem
	
	If !lJob .And. !Empty(aRet[1]) 
		cPerRemu := aRet[1]
	EndIf
	
	//Tratamento para 
	If !lJob
		cCondExtra := "% %"
	Else
		cCondExtra := "% %"
	EndIf
	
	If Select(cAliasQry) > 0
		cAliasQry->(dbCloseArea())
	EndIf
	
	cQuery += "SELECT ZZ6_CODAC AS CODIGO_AC," + CRLF
	cQuery += "		Z3_TIPENT AS TIPO_ENTIDADE," + CRLF
	cQuery += "		Z3_CODFOR AS FORNECEDOR," + CRLF
	cQuery += "		Z3_LOJA AS LOJA," + CRLF
	cQuery += "		ZZ6_CODENT AS ENTIDADE," + CRLF
	cQuery += "		Z3_DESENT AS NOME_ENTIDADE," + CRLF
	//cQuery += "		ZZ6_COMTOT + ZZ6_VALFED + ZZ6_VALCAM + ZZ6_VALVIS AS VAL_PER1," + CRLF
	cQuery += "		(SELECT MAX(ZZ6A.ZZ6_COMTOT) + MAX(ZZ6A.ZZ6_VALFED) + MAX(ZZ6A.ZZ6_VALCAM) + MAX(ZZ6A.ZZ6_VALVIS) FROM ZZ6010 ZZ6A WHERE" + CRLF 
	cQuery += "			ZZ6A.ZZ6_CODENT = ZZ6.ZZ6_CODENT AND" + CRLF 
	cQuery += "			ZZ6A.ZZ6_PERIOD = '" + cPerRemu + "' AND ZZ6A.D_E_L_E_T_ = ' ') as VAL_PER1," + CRLF
	cQuery += "		(SELECT MAX(ZZ6A.ZZ6_COMTOT) + MAX(ZZ6A.ZZ6_VALFED) + MAX(ZZ6A.ZZ6_VALCAM) + MAX(ZZ6A.ZZ6_VALVIS) FROM ZZ6010 ZZ6A WHERE" + CRLF 
	cQuery += "			ZZ6A.ZZ6_CODENT = ZZ6.ZZ6_CODENT AND" + CRLF 
	cQuery += "			ZZ6A.ZZ6_PERIOD = '" + getPeriodo(cPerRemu,1) + "' AND ZZ6A.D_E_L_E_T_ = ' ') as VAL_PER2," + CRLF
	cQuery += "		(SELECT MAX(ZZ6A.ZZ6_COMTOT) + MAX(ZZ6A.ZZ6_VALFED) + MAX(ZZ6A.ZZ6_VALCAM) + MAX(ZZ6A.ZZ6_VALVIS) FROM ZZ6010 ZZ6A WHERE" + CRLF 
	cQuery += "			ZZ6A.ZZ6_CODENT = ZZ6.ZZ6_CODENT AND" + CRLF 
	cQuery += "			ZZ6A.ZZ6_PERIOD = '" + getPeriodo(cPerRemu,2) + "' AND ZZ6A.D_E_L_E_T_ = ' ') as VAL_PER3," + CRLF				
	cQuery += "		Z3_PERADTO AS PERCENTUAL," + CRLF
	cQuery += "		ZZ6.R_E_C_N_O_ RECNO_ZZ6," + CRLF
	cQuery += "		SZ3.R_E_C_N_O_ RECNO_SZ3" + CRLF
	cQuery += "	FROM ZZ6010 ZZ6" + CRLF
	cQuery += "		INNER JOIN SZ3010 SZ3" + CRLF
	cQuery += "		ON  Z3_CODENT = ZZ6_CODENT" + CRLF
	cQuery += "		AND Z3_FILIAL = ZZ6_FILIAL" + CRLF
	cQuery += "	WHERE" + CRLF 
	cQuery += "		ZZ6_PERIOD = '" + cPerRemu +"' " + CRLF
	cQuery += "		AND ZZ6_FILIAL = '  '" + CRLF
	cQuery += "		AND ZZ6_PREFIX = '   '" + CRLF
	cQuery += "		AND ZZ6_NUM = '         '" + CRLF
	cQuery += "		AND ZZ6.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "		AND SZ3.D_E_L_E_T_ = ' '" + CRLF
	
	If !Empty(cEntidade)
		cQuery += "		AND ZZ6.ZZ6_CODENT = '" + cEntidade + "'" 
	EndIf
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQry, .F., .T.)
	MemoWrite("C:\DATA\ANTECIPA\CRPJ010.SQL", cQuery)
	
	If !lJob
	
		If Select("TMPCNT") > 0
			TMPCNT->(dbCloseArea())
		EndIf
		
		BeginSql Alias "TMPCNT"
			SELECT COUNT(*) CONTADOR FROM (
				SELECT ZZ6_CODAC AS CODIGO_AC,
					       Z3_TIPENT AS TIPO_ENTIDADE,
					       Z3_CODFOR AS FORNECEDOR,
					       Z3_LOJA AS LOJA,
					       ZZ6_CODENT AS ENTIDADE,
					       Z3_DESENT AS NOME_ENTIDADE,
					       ZZ6_COMTOT + ZZ6_VALFED + ZZ6_VALCAM + ZZ6_VALVIS AS VAL_PER1,
						   (SELECT MAX(ZZ6A.ZZ6_COMTOT) + MAX(ZZ6A.ZZ6_VALFED) + MAX(ZZ6A.ZZ6_VALCAM) + MAX(ZZ6A.ZZ6_VALVIS) FROM ZZ6010 ZZ6A WHERE 
								ZZ6A.ZZ6_CODENT = ZZ6.ZZ6_CODENT AND 
								ZZ6A.ZZ6_PERIOD = %Exp:getPeriodo(cPerRemu,1)% AND ZZ6A.D_E_L_E_T_ = ' ') as VAL_PER2,
						   (SELECT MAX(ZZ6A.ZZ6_COMTOT) + MAX(ZZ6A.ZZ6_VALFED) + MAX(ZZ6A.ZZ6_VALCAM) + MAX(ZZ6A.ZZ6_VALVIS) FROM ZZ6010 ZZ6A WHERE 
								ZZ6A.ZZ6_CODENT = ZZ6.ZZ6_CODENT AND 
								ZZ6A.ZZ6_PERIOD = %Exp:getPeriodo(cPerRemu,2)% AND ZZ6A.D_E_L_E_T_ = ' ') as VAL_PER3,				
					       Z3_PERADTO AS PERCENTUAL,
					       ZZ6.R_E_C_N_O_ RECNO_ZZ6,
					       SZ3.R_E_C_N_O_ RECNO_SZ3
					FROM ZZ6010 ZZ6
					INNER JOIN SZ3010 SZ3
					    ON  Z3_CODENT = ZZ6_CODENT
					    AND Z3_FILIAL = ZZ6_FILIAL
					WHERE 
					        ZZ6_PERIOD = %Exp:getPeriodo(cPerRemu)%
					    AND ZZ6_FILIAL = '  '
					    AND ZZ6_PREFIX = '   '
					    AND ZZ6_NUM = '         '
					    AND ZZ6.D_E_L_E_T_ = ' '
					    AND SZ3.D_E_L_E_T_ = ' '
				)
		EndSql
	
		nCountRec := TMPCNT->CONTADOR
		
		If Select("TMPCNT") > 0
			TMPCNT->(dbCloseArea())
		EndIf
	EndIf

Return (cAliasQry)->(!EOF())

//-----------------------------------------------------------------------
/*/{Protheus.doc} csRunQuery
//Rotina responsável pela execução do processamento
@author yuri.volpe
@since 28/03/2019
@version 1.0

@type function
/*/
//-----------------------------------------------------------------------
Static Function CRPJ010A()

	Local aTitulo 		:= {}
	Local cE2_Prefixo 	:= cMVPrefixo
	Local cE2_Num 		:= ""
	Local cE2_Tipo 		:= cMVTipoTit
	Local cE2_Naturez 	:= cMVNatureza
	Local cE2_Fornece 	:= ""
	Local cE2_Loja	 	:= ""
	Local dE2_Emissao 	:= dDataBase
	Local dE2_Vencto 	:= dDataBase + nMVDiaVenc 
	Local dE2_VencRea	:= DataValida(dE2_Vencto)
	Local nE2_Valor		:= 0 
	Local nPerAdianta	:= 0
	Local nTotalComis	:= 0
	Local nRecnoZZ6		:= 0
	Local nValorMedio	:= 0
	Local nDivisor		:= 0
	Local lFoundSZ7		:= .F.
	Local nCntRP		:= 0
	Local nCount		:= 0
	Local cPedido		:= ""
	Local lContinua		:= .F.
	Local Ni, Nj
	 
	Private lMsErroAuto := .F.
	
		dbSelectArea("SZ3")
		dbSelectArea("ZZ6")
		dbSelectArea("ZZ7")
		dbSelectArea("SE2")
		SE2->(dbSetOrder(1))
			
		If !lJob
			ProcRegua(nCountRec)
		EndIf
	
		//Begin Transaction
	
			While (cAliasQry)->(!EoF())
			
				nDivisor 	:= 0
				lContinua	:= .F.
			
				If !lJob
					IncProc("Processando registro " + cValToChar(nCount) + "/" + cValToChar(nCountRec))
					ProcessMessage()
				EndIf
			
				//Se flag na tabela SZ3 estiver vazia, não calcula adiantamento
				SZ3->(dbGoTo((cAliasQry)->RECNO_SZ3))
				If SZ3->Z3_ADIANTA != "S"
					LogWrite(cExec, "PR Writing", "[Z3_ADIANTA: " + Iif(Empty(SZ3->Z3_ADIANTA),"Vazio", SZ3->Z3_ADIANTA) +"] Não gera adiantamento para a Entidade: " + AllTrim((cAliasQry)->ENTIDADE) + " - " + AllTrim((cAliasQry)->NOME_ENTIDADE))
					(cAliasQry)->(dbSkip())
					Loop
				EndIf
				
				If Empty(SZ3->Z3_CODFOR)
					LogWrite(cExec, "PR Writing", "Fornecedor vazio na Entidade: " + AllTrim((cAliasQry)->ENTIDADE) + " - " + AllTrim((cAliasQry)->NOME_ENTIDADE))
					(cAliasQry)->(dbSkip())
					Loop
				EndIf
				
				//Removido pois o filtro ficará na exibição dos registros
				/*dbSelectArea("ZZ6")
				dbSelectArea("SC7")
				dbSelectArea("CND")
				dbSelectArea("SD1")
	
				SD1->(dbOrderNickname("PEDIDO"))
				SC7->(dbSetOrder(1))
				CND->(dbSetOrder(4))
				
				ZZ6->(dbGoTo((cAliasQry)->RECNO_ZZ6))
				
				If ZZ6->(!EOF())
					If ZZ6->ZZ6_TIPPED == "M"
						If CND->(dbSeek(xFilial("CND") + ZZ6->ZZ6_PEDIDO))
							cPedido := CND->CND_PEDIDO
						EndIf
					ElseIf ZZ6->ZZ6_TIPPED == "P"
						cPedido := ZZ6->ZZ6_PEDIDO
					EndIf
				EndIf
				
				If !Empty(cPedido)
					If SC7->(dbSeek(xFilial("SC7") + cPedido))
						If SD1->(dbSeek(xFilial("SD1") + SC7->C7_NUM))
							lContinua := .T.
						EndIf
					EndIf
				Else
					LogWrite(cExec, "PR Writing", "Fornecedor vazio na Entidade: " + AllTrim((cAliasQry)->ENTIDADE) + " - " + AllTrim((cAliasQry)->NOME_ENTIDADE))
					(cAliasQry)->(dbSkip())
					Loop
				EndIf
				
				If lContinua*/
				
					If Select("TMPCNTTIT") > 0
						TMPCNTTIT->(dbCloseArea())
					EndIf
					
					BeginSql Alias "TMPCNTTIT"
						SELECT MAX(E2_NUM) ULTIMO_TITULO
						FROM SE2010
							WHERE E2_FILIAL = ' '
							AND E2_TIPO = 'PR'
							AND E2_PREFIXO = 'REM'
							AND D_E_L_E_T_ = ' '
					EndSql
					
					//Inicia variaveis
					cE2_Num		:= Soma1(TMPCNTTIT->ULTIMO_TITULO)
					cE2_Fornece := (cAliasQry)->FORNECEDOR
					cE2_Loja	:= (cAliasQry)->LOJA
					nPerAdianta := (cAliasQry)->PERCENTUAL
					//nTotalComis := (cAliasQry)->TOTAL_COMISSAO
					nRecnoZZ6	:= (cAliasQry)->RECNO_ZZ6
					cE2_Hist	:= "Antecipação Comissão Ref " + cPerRemu + "-" + cValToChar(SZ3->Z3_PERADTO) + "%"
					
					If SA2->(dbSeek(xFilial("SA2") + cE2_Fornece + cE2_Loja))
						cE2_BcoForn	:= SA2->A2_BANCO
						cE2_AgeForn	:= SA2->A2_AGENCIA
						cE2_CtaForn	:= SA2->A2_NUMCON
					EndIf
					
					If (cAliasQry)->VAL_PER1 <> 0
						nDivisor++
					EndIf
					
					If (cAliasQry)->VAL_PER2 <> 0 
						nDivisor++
					EndIf
					
					If (cAliasQry)->VAL_PER3 <> 0
						nDivisor++
					EndIf
					
					If nDivisor == 0
						nDivisor := 1
					EndIf
					
					nDivisor := 3
				
					//Calculo de media
					nTotalComiss := ((cAliasQry)->VAL_PER1 + (cAliasQry)->VAL_PER2 + (cAliasQry)->VAL_PER3) / nDivisor
				
					LogWrite(cExec,"Comissionamento","Comissão calculada com base em: " + cValToChar((cAliasQry)->VAL_PER1) + " + " +; 
						cValToChar((cAliasQry)->VAL_PER2) + " + " + cValToChar((cAliasQry)->VAL_PER3) + " / " + cValToChar(nDivisor) + ". Resultado: " + cValToChar(nTotalComiss))
					
					//Calculo do valor a ser pago como adiantamento
					nE2_Valor	:= nTotalComiss * (nPerAdianta / 100)
					
					If nE2_Valor <= 0
						LogWrite(cExec, "PR Writing", "O valor do título não pode ser zerado para a Entidade: " + AllTrim((cAliasQry)->ENTIDADE) + " - " + AllTrim((cAliasQry)->NOME_ENTIDADE))
						(cAliasQry)->(dbSkip())
						Loop
					EndIf
								
					//Array do Titulo Provisório
					aArray := { { "E2_PREFIXO"  , cE2_Prefixo	, NIL },;
					            { "E2_NUM"      , cE2_Num		, NIL },;
					            { "E2_TIPO"     , cE2_Tipo		, NIL },;
					            { "E2_NATUREZ"  , cE2_Naturez	, NIL },;
					            { "E2_FORNECE"  , cE2_Fornece	, NIL },;
					            { "E2_LOJA" 	, cE2_Loja		, NIL },;
					            { "E2_EMISSAO"  , dE2_Emissao	, NIL },;
					            { "E2_VENCTO"   , dE2_Vencto	, NIL },;
					            { "E2_VENCREA"  , dE2_VencRea	, NIL },;
					            { "E2_HIST"	    , cE2_Hist		, NIL },;
					            { "E2_FORBCO"	, cE2_BcoForn	, NIL },;
					            { "E2_FORAGE"	, cE2_AgeForn	, NIL },;
					            { "E2_FORCTA"	, cE2_CtaForn	, NIL },;
					            { "E2_VALOR"    , nE2_Valor		, NIL } }
					            			
					LogWrite(cExec, "ExecAuto", "Iniciando processamento do ExecAuto para Entidade: " + AllTrim((cAliasQry)->ENTIDADE) + " - " + AllTrim((cAliasQry)->NOME_ENTIDADE) + " [Título: " + AllTrim(cE2_Num) + "]")
					 
					MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)
					
					LogWrite(cExec, "ExecAuto", "Processamento do ExecAuto finalizado para Entidade: " + AllTrim((cAliasQry)->ENTIDADE) + " - " + AllTrim((cAliasQry)->NOME_ENTIDADE) + " [Título: " + AllTrim(cE2_Num) + "]")
					 
					If lMsErroAuto
						//RollBackSXE()
						
						If !lJob
							MostraErro()
						EndIf
						
					    aErroAuto := GetAutoGRLog()
					    LogWrite(cExec, "PR Writing", "Erro na inclusão do Título: ")
					    
					    For Nj := 1 To Len(aErroAuto)
					    	LogWrite(cExec, "PR Writing", aErroAuto[Nj]  + CRLF)
					    Next
					    
					    lMsErroAuto := .F.
					Else
						//Se ExecAuto funcionar, grava ZZ6 com dados do título e ZZ7 com saldo
					    ZZ6->(dbGoTo(nRecnoZZ6))
					    RecLock("ZZ6", .F.)
							ZZ6->ZZ6_PREFIX	:= SE2->E2_PREFIXO 
							ZZ6->ZZ6_NUM	:= SE2->E2_NUM
							ZZ6->ZZ6_PARCEL	:= "" //Iif(IsAlpha(SE2->E2_PARCELA),SE2->E2_PARCELA,StrZero(Val(SE2->E2_PARCELA),2))
							ZZ6->ZZ6_TIPO	:= SE2->E2_TIPO
							ZZ6->ZZ6_FORNEC	:= SE2->E2_FORNECE
							ZZ6->ZZ6_LOJA	:= SE2->E2_LOJA
							ZZ6->ZZ6_PER1	:= (cAliasQry)->VAL_PER1
							ZZ6->ZZ6_PER2	:= (cAliasQry)->VAL_PER2
							ZZ6->ZZ6_PER3	:= (cAliasQry)->VAL_PER3
							ZZ6->ZZ6_SOMA	:= (cAliasQry)->VAL_PER1 + (cAliasQry)->VAL_PER2 + (cAliasQry)->VAL_PER3
					    ZZ6->(MsUnlock())
					    LogWrite(cExec, "PR Writing", "Tabela SZ6 atualizada. Recno: " + cValToChar(ZZ6->(Recno())))
					    
					    ZZ7->(dbSetOrder(1))
					    lFoundZZ7 := ZZ7->(!dbSeek(xFilial("ZZ7") + (cAliasQry)->ENTIDADE  + cMVPerRem ))
					    
					    RecLock("ZZ7", lFoundZZ7)
					    	ZZ7->ZZ7_FILIAL := xFilial("ZZ7")
					    	ZZ7->ZZ7_CODPAR := (cAliasQry)->ENTIDADE 
					    	ZZ7->ZZ7_PARCEL := ""
					    	ZZ7->ZZ7_VALOR  := SE2->E2_VALOR
					    	ZZ7->ZZ7_SALDO	:= SE2->E2_VALOR
					    	ZZ7->ZZ7_PRETIT := SE2->E2_PREFIXO
					    	ZZ7->ZZ7_TITULO := SE2->E2_NUM
					    	ZZ7->ZZ7_PERIOD := ZZ6->ZZ6_PERIOD
					    ZZ7->(MsUnlock())
					    LogWrite(cExec, "PR Writing", "Tabela SZ7 atualizada. Recno: " + cValToChar(ZZ7->(Recno())))   
					    
					    nCntRP++
					    //For debug
					    /*If nCntRP > 0
					    	Exit
					    EndIf*/
					Endif
				/*Else
				 	LogWrite(cExec, "PR Writing", "Tabela SZ7 atualizada. Recno: " + cValToChar(ZZ7->(Recno())))
				EndIf*/
				 
				nCount++
				(cAliasQry)->(dbSkip())
			EndDo
			
		//End Transaction
		
		LogWrite(cExec, "RP Writing End", "Laço para geração de Títulos RP finalizado. Foram incluídos " + cValToChar(nCntRP) + " títulos provisórios.")
	
Return !lMsErroAuto


Static Function MandEmail(xCorpo, xDest, xAssunto, xAnexo, xCC, xBCC, xAcc)
	
	Local   cAccount  := AllTrim(GetNewPar("MV_RELACNT"," "))
	Local   cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
	Local   cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
	Local   cUserAut  := Alltrim(GetMv("MV_RELAUSR",,"")) //Usuário para Autenticação no Servidor de Email
	Local   cPassAut  := Alltrim(GetMv("MV_RELAPSW",,""))//Senha para Autenticação no Servidor de Email
	Local   nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexão
	Local   lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autenticação
	Local   lRet      := .T.
	
	Default xDest     := ""
	Default xCC		  := ""
	Default xBCC      := ""
	Default xCorpo	  := ""
	Default xAnexo    := ""
	Default xAssunto  := xAssunto
	
	If Empty(xDest+xCC+xBCC)
		Return(lRet)
	EndIf
	
	_cMsg := "Conectando a " + cServer + CRLF +;
	"Conta: " + cAccount + CRLF +;
	"Senha: " + cPassword
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk
	
	If ( lOk )
	
	    // Realiza autenticacao caso o servidor seja autenticado.
		If lAutentica
			If !MailAuth(cUserAut,cPassAut)
				DISCONNECT SMTP SERVER RESULT lOk
				IF !lOk
					GET MAIL ERROR cErrorMsg
				ENDIF
				Return .F.
			EndIf
		EndIf
	
		SEND MAIL FROM cAccount TO xDest CC xCC BCC xBCC SUBJECT xAssunto BODY xCorpo ATTACHMENT xAnexo RESULT lOk
	
		If !lOk
			GET MAIL ERROR cErro
			cErro := "Erro durante o envio - destinatário: " + xDest + CRLF + CRLF + cErro
			lRet:= .F.
		Endif
	
		DISCONNECT SMTP SERVER RESULT lOk
		If !lOk
			GET MAIL ERROR cErro
		Endif
	Else
		GET MAIL ERROR cErro
		lRet:= .F.
	EndIf

Return(lRet)

Static Function getPeriodo(cPerAtu,nAnt)

	Local cPeriodo 	:= ""
	Local cMesRemu 	:= Substr(cPerAtu,5,2)
	Local cAnoRemu 	:= Substr(cPerAtu,1,4)
	Local nLastRem 	:= 0
	
	Default nAnt   	:= 0
	
	nLastRem := Val(cMesRemu) - nAnt
	
	//Captura o último periodo fechado para calcular a antecipacao 
	//Se Fevereiro, o valor é zero, se Janeiro, -1.
	//Em Janeiro, considera Novembro do ano anterior como ultimo calculo valido
	If nLastRem == 0
		cPeriodo := cValToChar((Val(Substr(cPerAtu,1,4))) - 1) + "12"
	ElseIf nLastRem == -1
		cPeriodo := cValToChar((Val(Substr(cPerAtu,1,4))) - 1) + "11"
	Else
		cPeriodo := Substr(cPerAtu,1,4) + StrZero(Val(Substr(cPerAtu,5,2)) - nAnt, 2)
	EndIf

Return cPeriodo

Static Function CRPJ010DEL()

	Local cQuery	:= ""
	Local cAliasDel	:= GetNextAlias()
	Local aSelTit	:= {}
	Local cParcela	:= Space(TamSX3("E2_PARCELA")[1])
	Local Ne, Nx, Nj, Ni
	
	Private lMsErroAuto	:= .F.
	
	LogWrite(cExec,"PRE_QUERY","Iniciando exclusão de títulos via Job")	
	
	If Select(cAliasDel) > 0
		(cAliasDel)->(dbCloseArea())
	EndIf
	
	cQuery := "SELECT ZZ6_PERIOD," 
	cQuery += "       ZZ6_CODENT," 
	cQuery += "       ZZ6_DESENT, "
	cQuery += "       ZZ6_PREFIX, "
	cQuery += "       ZZ6_NUM, "
	cQuery += "       ZZ6_PARCEL," 
	cQuery += "       ZZ6_TIPO, "
	cQuery += "		  ZZ6_PEDIDO,"
	cQuery += "		  ZZ6_TIPPED,"
	cQuery += "       ZZ7_VALOR, "
	cQuery += "       E2_VALOR, "
	cQuery += "       E2_SALDO, "
	cQuery += "       E2_BAIXA, "
	cQuery += "       ZZ6.R_E_C_N_O_ RECNOZZ6,"
	cQuery += "       SE2.R_E_C_N_O_ RECNOSE2,"
	cQuery += "       ZZ7.R_E_C_N_O_ RECNOZZ7, "
	cQuery += "       ZZ6.ZZ6_PER1 PERIODO1, "
	cQuery += "       ZZ6.ZZ6_PER2 PERIODO2, "					
	cQuery += "       ZZ6.ZZ6_PER3 PERIODO3, "
	cQuery += "       ZZ6.ZZ6_SOMA SOMA, "
	cQuery += "		  Round((ZZ6.ZZ6_SOMA / 3),2) AS MEDIA,"
	cQuery += "		  SZ3.Z3_PERADTO AS PERCENTUAL"
	cQuery += "FROM " + RetSqlName("ZZ6") + " ZZ6 "
	cQuery += ""	
	cQuery += "       INNER JOIN " + RetSqlName("ZZ7") + " ZZ7 "
	cQuery += "               ON ZZ7_FILIAL = ZZ6_FILIAL "
	cQuery += "                  AND ZZ7_PRETIT = ZZ6_PREFIX "
	cQuery += "                  AND ZZ7_TITULO = ZZ6_NUM "
	cQuery += "                  AND ZZ7_CODPAR = ZZ6_CODENT "
	cQuery += "       INNER JOIN " + RetSqlName("SE2") + " SE2 "
	cQuery += "               ON E2_NUM = ZZ6_NUM "
	cQuery += "                  AND E2_PREFIXO = ZZ6_PREFIX "
	cQuery += "                  AND E2_TIPO = ZZ6_TIPO "
	cQuery += "                  AND E2_FORNECE = ZZ6_FORNEC "
	cQuery += "		  INNER JOIN " + RetSqlName("SZ3") + " SZ3 "
	cQuery += "				  ON Z3_FILIAL = ' ' "
	cQuery += "					 AND Z3_CODENT = ZZ6_CODENT "
	cQuery += "WHERE  ZZ6_NUM > ' ' "
	cQuery += "		  AND ZZ7_VALOR > 0 "	
	cQuery += "       AND E2_BAIXA = ' ' "
	cQuery += "		  AND ZZ6_TIPO = 'PR' "
	cQuery += "       AND ZZ6.D_E_L_E_T_ = ' ' "
	cQuery += "       AND ZZ7.D_E_L_E_T_ = ' ' "
	cQuery += "       AND SE2.D_E_L_E_T_ = ' ' "
	cQuery += "		  AND SZ3.D_E_L_E_T_ = ' ' "
	cQuery += " AND ZZ6_PERIOD = '" + cPerRemu + "'"
	cQuery += "	ORDER BY ZZ6_CODENT, ZZ6_PERIOD"
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasDel, .F., .T.)
	
	LogWrite(cExec,"QUERY",cQuery)
	
	While (cAliasDel)->(!EoF())
		
		dbSelectArea("SZ3")
		SZ3->(dbSetOrder(1))
		SZ3->(dbSeek(xFilial("SZ3") + (cAliasDel)->ZZ6_CODENT ))
		
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
	
		dbSelectArea("SE2")
		If SE2->(dbSeek(xFilial("SE2") + (cAliasDel)->ZZ6_PREFIX + (cAliasDel)->ZZ6_NUM + cParcela + (cAliasDel)->ZZ6_TIPO + SZ3->Z3_CODFOR + SZ3->Z3_LOJA))
		
			If SA2->(dbSeek(xFilial("SA2") + SZ3->Z3_CODFOR + SZ3->Z3_LOJA))
			
				aAdd(aSelTit, {{"E2_FILIAL"  , SE2->E2_FILIAL , NIL },;
						{"E2_PREFIXO" , SE2->E2_PREFIXO, NIL },;
						{"E2_NUM"     , SE2->E2_NUM    , NIL },;
						{"E2_PARCELA" , SE2->E2_PARCELA, NIL },;
						{"E2_TIPO"    , SE2->E2_TIPO   , NIL },;
						{"E2_NATUREZ" , SE2->E2_NATUREZ, NIL },;
						{"E2_FORNECE" , SE2->E2_FORNECE, NIL },;
						{"E2_LOJA"    , SE2->E2_LOJA   , NIL },;
						{"E2_EMISSAO" , SE2->E2_EMISSAO, NIL },;
						{"E2_VENCTO"  , SE2->E2_VENCTO , NIL },;
						{"E2_VALOR"   , SE2->E2_VALOR  , NIL },;
						{"E2_HIST"    , SE2->E2_HIST  , NIL },;
						{"E2_MOEDA"   , SE2->E2_MOEDA  , NIL }})
						
				aAdd(aRecnoZZ7, (cAliasDel)->RECNOZZ7)
				aAdd(aRecnoZZ6, (cAliasDel)->RECNOZZ6)
				aAdd(aRecnoSE2, SE2->(Recno()))
			Else
				LogWrite(cExec,"Fornecedor","Fornecedor " + SZ3->Z3_CODFOR + "/" + SZ3->Z3_LOJA + " não encontrado.")
			EndIf
		EndIf
	
	EndDo
		
	If Len(aSelTit) > 0
				
		For Ni := 1 To Len(aSelTit)
		
			// Executar a exclusão dos títulos.
			MsExecAuto( { |a,b,c| FINA050( a, b, c ) } , aSelTit[Ni], ,5)
			
			// Se houver erro capturar a mensagem.
			If lMsErroAuto
				lRet := .F.
				MostraErro()
				cMsg := 'Inconsistência para excluir título' + CRLF + CRLF
				aAutoErr := GetAutoGRLog()
				For ne := 1 To Len( aAutoErr )
					cMsg += aAutoErr[ ne ] + CRLF
				Next ne
				LogWrite(cExec,"AutoExec",cMsg)
				lMsErroAuto := .F.
			Else
				// Se não houver erro vincular o título principal com as baixas dos títulos provisórios.
				For Nx := 1 To Len(aRecnoZZ6)
					ZZ6->(dbGoTo(aRecnoZZ6[Nx]))
					
					RecLock("ZZ6",.F.)
						ZZ6->ZZ6_PREFIX	:= ""
						ZZ6->ZZ6_NUM	:= ""
						ZZ6->ZZ6_PARCEL	:= ""
						ZZ6->ZZ6_TIPO	:= ""
						ZZ6->ZZ6_FORNEC	:= ""
						ZZ6->ZZ6_LOJA	:= ""
					ZZ6->(MsUnlock())
				Next
				
				For Nj := 1 To Len(aRecnoZZ7)
					ZZ7->(dbGoTo(aRecnoZZ7[Nj]))
					
					RecLock("ZZ7",.F.)
						dbDelete()
					ZZ7->(MsUnlock())
				Next
	
				LogWrite("[Exclusão] Título " + SE2->E2_PREFIXO + SE2->E2_NUM +;
				 	". Fornecedor: " + SE2->E2_FORNECE + "/" + SE2->E2_LOJA + ". Valor R$ " + AllTrim(Transform(SE2->E2_VALOR,"@E 999,999,999.99")))
				LogWrite(Replicate("-",95))
				nCounter++
				
			Endif
			
		Next
		
		LogWrite("Foram excluídos " + cValToChar(nCounter) + " títulos com sucesso.")
		LogWrite(Time() + " | Fim da rotina.")
		LogEnd()
		
	EndIf
	

Return