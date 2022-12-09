#include 'protheus.ch'
#include 'parmtype.ch'

/***
** ROTINA PARA PROCESSAMENTO DE COMPENSA��O DE TITULOS PARA REMUNERA��O DE PARCEIROS
** =================================================================================
** - No come�o de cada m�s � gerado um t�tulo PR com base na m�dia dos tr�s �ltimos meses remunerado ao Parceiro e um % � aplicado sobre a m�dia.
** - Estes PR s�o substitu�dos em PA por uma rotina dispon�vel para a equipe Financeira
** - Depois do fechamento, as NF de Entrada para pagamento aos Parceiros s�o geradas
** - Os t�tulos das NF s�o compensados, ent�o, com as PA dos Parceiros
**
** A rotina tem um modo visual CRPJ020VIS e um modo Autom�tico CRPJ020.
**/

/*
MaIntBxCP(nCaso, aSE2, aBaixa, aNDF_PA, aLiquidacao, aParam, bBlock, aEstorno, aNDFDados, nSaldoComp, dBaixaCMP, nTaxaCM, nHdl)
MaIntBxCP(ExpN1, ExpA2, ExpA3, ExpA4, ExpA5, ExpA6, ExpB7, ExpA8, ExpA9, ExpNA, ExpDB, nTaxaCM, nHdl)
MaIntBxCP(2, {RecnoSE2}, {"NOR",100.00,"237","0000","000000",dDataBase,dDataBase}, {RecnoSE2}, ExpA5, ExpA6, ExpB7, ExpA8, ExpA9, ExpNA, ExpDB, nTaxaCM, nHdl)

ExpN1: C�digo da opera��o a ser efetuada        

   [1] Baixa simples do financeiro                             

   [2] Compensa��o de t�tulos de mesma carteira (PA/NDF)

ExpA2: Array com os recnos dos t�tulos a serem baixados     

ExpA3: Array com os dados da baixa simples do financeiro           

   [1] Motivo da Baixa                                         

   [2] Valor Recebido                                            

   [3] Banco                                                     

   [4] Ag�ncia                                                 

   [5] Conta                                                 

   [6] Data de Cr�dito                                      

   [7] Data da Baixa                                    

ExpA4: Array com os recnos dos t�tulos a serem compensados  

ExpA5: Array com os dados da liquida��o do financeiro            

  [1] Prefixo                                               

  [2] Banco                                                     

  [3] Ag�ncia                                                 

  [4] Conta                                                   

  [5] N�mero do Cheque                                        

  [6] Data Boa                                                

  [7] Valor                                                     

  [8] Tipo                                                    

  [9] Natureza                                                

 [A] Moeda                                            

ExpA6: Array com os par�metros da rotina {.F.,.F.,.F.,0,0,.F.}                             

 [1] Contabiliza On-Line                                     

 [2] Aglutina Lan�amentos Cont�beis                            

 [3] Digita lan�amentos cont�beis                              

 [4] Juros para Comiss�o                                       

 [5] Desconto para Comiss�o                                    

 [6] Calcula Comiss s/NCC                               

ExpB7: Bloco de c�digo a ser executado ap�s o processamento da rotina, abaixo os par�metros passados                       

 [1] Recno do titulo baixado                                   

 [2] C�digo a ser informado para cancelamento futuro. 

ExpA8: Utilizado quando deve-se estornar uma das baixas efetuadas. Para tanto, deve-se informar o c�digo informado no codeBlock anterior.                          

ExpA9: Array contendo o valor de cada adiantamento a ser considerado na compensa��o. Caso n�o seja informado, o valor total do titulo ser� considerado.

ExpNA: Valor limite para a compensa��o

ExpDB: Data a ser considerada para compensa��o (Opcional)

Retorno  

ExpL1: Processo efetuado com sucesso (.T.) ou n�o (.F.) */
*/

/*/{Protheus.doc} CRPJ020
//TODO Descri��o auto-gerada.
@author yuri.volpe
@since 27/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function CRPJ020(aParam)
	
	Local lOk	:= .F.
	Local dDate	:= CTOD("//")
	
	Private cAliasTmp	:= GetNextAlias()
	Private cAliasSE2	:= GetNextAlias()
	Private cFullLog	:= ""
	Private nHdlLog	 	:= -1
	Private lJob	 	:= .T.
	Private cExec		:= "MainFunction"	
	
	//Iniciando log
	LogInit()
	
	//Trata recebimento de par�metros pelo JOB
	If Len(aParam) < 1
		LogWrite(cExec, "Verifica Param", "N�o foram passados par�metros o suficiente para execu��o da rotina. Verifique os par�metros na chamada da fun��o e tente novamente.")
		Return
	EndIf 
	
	//----------------------	
	// Prepara ambiente
	//----------------------	
	lOk := csPrepAmb( aParam )
	CRPJ20Tables() 

//	//----------------------	
//	// Trata data de execu��o
//	//----------------------
//	dDate := Date()
//	If LastDay(dDate,0) != dDate
//		lOk := .F.
//		LogWrite(cExec, "DATE CHECK","A fun��o foi projetada para ser executada apenas no �ltimo dia do m�s.")
//	EndIf
	
	//Localizar parametros
	If lOk
		If lOk := CRPJ20LoadParam()
			If lOk := CRPJ20Query()
				lOk := CRPJ20RunProc()
			Else
				LogWrite(cExec, "RunQuery", "N�o h� dados dispon�veis para execu��o da Compensa��o.")
			EndIf
		EndIf
		
		If !lOk
			LogWrite(cExec, "Process", "O programa foi finalizado, por�m com inconsist�ncias na execu��o.")
		EndIf
	EndIf
	
	LogEnd()
	
Return

/*/{Protheus.doc} CRPJ020Vis
//TODO Descri��o auto-gerada.
@author yuri.volpe
@since 27/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function CRPJ020Vis()

	Local lRet := .F.
	Local aParam := {}

	Private cAliasTmp	:= GetNextAlias()
	Private cAliasSE2	:= GetNextAlias()
	Private cFullLog	:= ""
	Private lJob 		:= .F.
	Private nHdlLog		:= 0
	Private aRet		:= {}
	
	//Iniciando log
	LogInit()
	LogWrite("Init","VisualMode","Iniciando processo em modo visual.")

	Processa({|| lRet := CRPJ20LoadParam()},"Carregando par�metros","Aguarde",.F.)
	If lRet
		
		aAdd(aParam,{1, "C�digo CCR"	  , Space(6)	, "@E 999999", "", ""   , "" , 50, .F.})
		
		If Parambox(aParam, "Par�metros do Relat�rio", @aRet)
		
			Processa({|| lRet := CRPJ20Query()},"Carregando dados","Aguarde",.F.)
			
			If lRet
				
				Processa({|| lRet := CRPJ20RunProc()}, "Processando Compensa��o","Aguarde",.F.)
				
				If !lRet
					MsgStop("O processo foi conclu�do com erros. Por gentileza, verifique o log para detalhes.")
				Else
					MsgInfo("O processo foi conclu�do corretamente.")
				EndIf
				
			Else
				MsgStop("Houve um problema na carga dos dados. Verifique o log para detalhes.")
			EndIf
		Else
			MsgStop("O processo foi cancelado.")
		EndIf
	Else
		MsgStop("Houve um problema na carga dos par�metros. Verifique o log para detalhes.")
	EndIf

	LogEnd()
	MostraLog()

Return

/*/{Protheus.doc} CRPJ20LoadParam
//TODO Descri��o auto-gerada.
@author yuri.volpe
@since 27/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function CRPJ20LoadParam()

	Local lRet := .F.
	
	LogWrite("SubExec","LoadParam","Carregando os par�metros para execu��o do programa.")
	
	lRet := .T.

Return lRet

/*/{Protheus.doc} CRPJ20Query
//TODO Descri��o auto-gerada.
@author yuri.volpe
@since 27/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function CRPJ20Query()

	Local cQuery 	:= ""
	
	If Select(cAliasTmp) > 0
		(cAliasTmp)->(dbCloseArea())
	EndIf
	
	LogWrite("SubExec","RunQuery","Iniciando execu��o da query.")
	
	cQuery := "SELECT ZZ7_CODPAR AS PARCEIRO," + CRLF
	cQuery += "		  ZZ7_PERIOD AS PERIODO," + CRLF
	cQuery += "		  ZZ6_FORNEC AS FORNECEDOR," + CRLF
	cQuery += "		  ZZ6_LOJA AS LOJA," + CRLF
	cQuery += "		  ZZ6_PREFIX AS PREFIXO," + CRLF
	cQuery += "		  ZZ6_NUM AS TITULO," + CRLF
	cQuery += "		  ZZ6_PARCEL AS PARCELA," + CRLF
	cQuery += "		  ZZ6_TIPO AS TIPO," + CRLF
	cQuery += "		  ZZ7_SALDO AS SALDO, " + CRLF
	cQuery += "		  ZZ6.R_E_C_N_O_ RECNOZZ6, " + CRLF
	cQuery += "		  ZZ7.R_E_C_N_O_ RECNOZZ7 " + CRLF
	cQuery += "	FROM "+RetSqlName("ZZ7")+" ZZ7" + CRLF
	cQuery += "	INNER JOIN "+RetSqlName("ZZ6")+" ZZ6" + CRLF
	cQuery += "		ON ZZ6_CODENT = ZZ7_CODPAR" + CRLF
	cQuery += "		AND ZZ6_PERIOD = ZZ7_PERIOD" + CRLF
	cQuery += "	WHERE ZZ7_SALDO > 0 " + CRLF
	cQuery += "		AND ZZ7_PRETIT = 'REM' " + CRLF
	cQuery += "		AND ZZ6_TIPO = 'PA'" + CRLF
	If !lJob .And. Len(aRet) == 1
		cQuery += "		AND ZZ6_CODENT = '" + aRet[1] + "'" + CRLF
	EndIf
	cQuery += "		AND ZZ7.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "		AND ZZ6.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "		ORDER BY ZZ7_CODPAR,ZZ7_PERIOD" + CRLF
	
	LogWrite("SubExec","RunQuery","Query: [ " + cQuery + " ].")
	
	If !lJob
		MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)},"Consultando registros","Realizando consulta de dados",.F.)
		//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)
	Else
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTmp, .T., .T.)
	EndIf
	
	dbSelectArea(cAliasTmp)
	(cAliasTmp)->(dbGoTop())
	
	LogWrite("SubExec","RunQuery","Execu��o da Query encerrada.")

Return (cAliasTmp)->(!EoF())

/*/{Protheus.doc} CRPJ20RunProc
//TODO Descri��o auto-gerada.
@author yuri.volpe
@since 27/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function CRPJ20RunProc()

	Local cQuery 	:= ""
	Local aRecPA 	:= {}
	Local aRecSE2	:= {}
	Local aParam	:= {.F.,.F.,.F.,.F.,.F.} //{lContabiliza,lAglutina,lDigita,lJuros,lDesconto,lComissao}
	Local dBaixaCMP := dDataBase //CTOD("//")
	Local lRet		:= .F.
	Local cChave	:= ""
	Local aSE5Grv	:= {}
	Local aAreaSE5	:= {}

	LogWrite("MainProc","Iterate","Iniciando itera��o de registros")
	
	While (cAliasTmp)->(!EoF())
		
		aRecSE2 := {}
		lRet := .F.
		
		If Select(cAliasSE2) > 0
			(cAliasSE2)->(dbCloseArea())
		EndIf
		
		LogWrite("MainProc","PosSE2","Buscando registro da SE2: " + (cAliasTmp)->PREFIXO + (cAliasTmp)->TITULO + (cAliasTmp)->PARCELA + (cAliasTmp)->TIPO)
		
		cChave := xFilial("SE2") + (cAliasTmp)->PREFIXO + (cAliasTmp)->TITULO + (cAliasTmp)->PARCELA + (cAliasTmp)->TIPO + (cAliasTmp)->FORNECEDOR + (cAliasTmp)->LOJA
		
		//Posiciona SE2 do titulo PA
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek(cChave))
		
			//If Empty(SE2->E2_NUMBOR)
		
				LogWrite("MainProc","SubQuery","Localizando t�tulos de NF para Fornecedor: " + (cAliasTmp)->FORNECEDOR + (cAliasTmp)->LOJA)
				//Localiza titulos gerados a partir da NF para Compensacao.
				cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("SE2") + " WHERE E2_FORNECE = '"+(cAliasTmp)->FORNECEDOR+"' AND E2_LOJA = '" + (cAliasTmp)->LOJA + "' "
				cQuery += " AND E2_TIPO = 'NF' AND E2_SALDO <> 0 AND E2_NUMBOR = ' ' AND D_E_L_E_T_ = ' '"
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSE2, .T., .T.)
				
				LogWrite("MainProc","SubQuery","Adicionando Recnos no Array")
				While (cAliasSE2)->(!EOF())
					aAdd(aRecSE2, (cAliasSE2)->R_E_C_N_O_)
					(cAliasSE2)->(dbSkip())
				EndDo
				
				// Estabelecer o nome da rotina de t�tulo a receber.
				SetFunName('FINA750')
				
				LogWrite("MainProc","Compensa��o","Iniciando processo de Compensa��o")
		//		MaIntBxCP(nCaso, aSE2, aBaixa, aNDF_PA, aLiquidacao, aParam, bBlock, aEstorno, aNDFDados, nSaldoComp, dBaixaCMP, nTaxaCM, nHdl)
				If Len(aRecSE2) > 0
					Begin Transaction
						lRet := MaIntBxCP(2, aRecSE2,, {SE2->(Recno())},, aParam,,,,, dBaixaCMP)
					
						//A rotina da API do Financeiro retorna True ou False depois da execu��o
						If !lRet
							LogWrite("MainProc","Compensa��o","N�o foi poss�vel realizar a Compensa��o para o Parceiro " + AllTrim(GetAdvFVal("SZ3", "Z3_DESENT", xFilial("SZ3") + (cAliasTmp)->PARCEIRO, 1)) + ".")
						Else
						
							ZZ7->(dbGoTo((cAliasTmp)->RECNOZZ7))
							RecLock("ZZ7",.F.)
								ZZ7->ZZ7_SALDO := 0
							ZZ7->(MsUnlock())
							
							aSE5Grv := FIM020RSE5()
							
							aAreaSE5 := SE5->(GetArea())
							For Np := 1 To Len(aSE5Grv)
								SE5->(dbGoTo(aSE5Grv[Np]))
								
								If !SE5->(EOF()) .And. !Empty(SE5->E5_MOVCX)
									RecLock("SE5", .F.)
										SE5->E5_MOVCX := " "
									SE5->(MsUnlock())
								EndIf
								
							Next Np
							RestArea(aAreaSE5)
							
							LogWrite("MainProc","Compensa��o","Compensado: ["+ SE2->E2_PREFIXO + SE2->E2_NUM +"]")
						EndIf
					End Transaction 
				Else
					LogWrite("MainProc","Compensacao","N�o h� titulos para realizar a Compensa��o para o Parceiro " + AllTrim(GetAdvFVal("SZ3", "Z3_DESENT", xFilial("SZ3") + (cAliasTmp)->PARCEIRO, 1)) + ".")
				EndIf
			
			(cAliasSE2)->(dbCloseArea())
		Else
			LogWrite("MainProc","Compensacao","T�tulo n�o encontrado: " + (cAliasTmp)->PREFIXO + (cAliasTmp)->TITULO + (cAliasTmp)->PARCELA + (cAliasTmp)->TIPO)
		EndIf
		
		(cAliasTmp)->(dbSkip())
	EndDo
	
	(cAliasTmp)->(dbCloseArea())
	
Return lRet

Static Function CRPJ20Tables()

	Local aTables := {"SA2","SE2","ZZ6","ZZ7","SZ3","SZ3","SE5"}
	
	LogWrite("SubExec", "OpenTables", "Abrindo tabelas necessarias para o processamento")
	
	For Ni := 1 To Len(aTables)
		dbSelectArea(aTables[Ni])
	Next

	LogWrite("SubExec", "OpenTables", "Carga de tabelas encerrado")
	
Return

//---------------------------------------------------------------
/*/{Protheus.doc} csPrepAmb
 Fun��o para prepara��o do ambiente para processamento do Job
 @param aParam 

/*/
//---------------------------------------------------------------
static function csPrepAmb( aParam )
	
	local cEmp		:= ""
	local cFil		:= ""
	Local aTables	:= {'SX5','SX6','SIX','SA2','SC7','SE2','ZZ6','SZ6','SZ3','ZZ7','SZ5'}
	
	LogWrite( cExec, "PrepAmb" , "Preparando Ambiente")
	
	cEmp := IIf( aParam == NIL, '01', aParam[ 1 ] )
	cFil := IIf( aParam == NIL, '02', aParam[ 2 ] )
	
	If lJob
		RpcSetType( 3 )
		RpcSetEnv(cEmp, cFil,,,,, aTables)		
		
		LogWrite( cExec, "PrepAmb" , "Ambiente preparado para Empresa: " +cEmp+ " - Filial: " +cFil)
	EndIf
		
return (cFilAnt == aParam[2])
    
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
		FWrite(nHdlLog, "[ CRPJ020 - " + Iif(!Empty(cProcesso),cProcesso+" - ","")  + Dtoc( date() ) + " - " + time() + " ] " + Iif(!Empty(cMessage),AllTrim(cMessage),"") + CRLF)
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

Local cLogName 	:= "crpj020_"+ DToS( Date() ) + StrTran( Time(),":","")+".log"
Local cLogPath	:= "\remuneracao\antecipacao\"

cFullLog	:= cLogPath + cLogName

nHdlLog := FCreate(cFullLog)

If nHdlLog == -1
	CONOUT("[ CRPJ020 - Log Creation - " + Dtoc( date() ) + " - " + time() + " ] Log file creation failure.")
Else
	CONOUT("[ CRPJ020 - Log Creation - " + Dtoc( date() ) + " - " + time() + " ] Log file creation successful.")
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

Local cCorpoMsg

If nHdlLog > -1
	FClose(nHdlLog)
	CONOUT("[ CRPJ020 - Log Closure - " + Dtoc( date() ) + " - " + time() + " ] Log file closed.")
EndIf

cCorpoMsg := MemoRead(cFullLog)

//MandEmail(cCorpoMsg, cMVEmails, "[CRPJ020] Log de Processamento - Gera��o de T�tulos PR")

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

Static Function MostraLog()
Local oDlg
Local cMemo := MemoRead(cFullLog)
Local cFile
Local oFont 

	DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15

	DEFINE MSDIALOG oDlg TITLE cFullLog From 3,0 to 340,417 PIXEL

	@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 200,145 OF oDlg PIXEL 
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont

	DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	//DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar")),If(cFile="",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) ENABLE OF oDlg PIXEL 
	//DEFINE SBUTTON  FROM 153,115 TYPE 6 ACTION (PrintAErr(cFullLog),oDlg:End()) ENABLE OF oDlg PIXEL //Imprime e Apaga

	ACTIVATE MSDIALOG oDlg CENTER

Return