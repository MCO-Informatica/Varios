#include "protheus.ch" 
 
STATIC __ShowStatus := NIL 
STATIC __ProcError 	:= '' 
// RELEASE 20091222 
 
/* ================================================================ 
FUNCOES PARA DISTRIBUICAO DE PROCESSOS REMOTA 
Requisitos : 
================================================================ */ 
 
/* 
Funcao principal do agente de processamento 
cada thread de agente de processamento ù configurada em 
um servico diferente do protheus 
e todos fazem RPC para o webservice, para pegar uma tarefa 
atraves da funcao GetProcCall() 
 
Configuracao padrao 
 
[onstart] 
jobs=procagent 
refreshrate=60 
 
[procagent] 
enable=1 
main=u_procagent 
Instances=4 
AgentID=Slave_1 
wsserver=localhost 
wsport=6010 
environment=advpltests_top_mssql 
procemp=25 
procfil=01 
showstatus=1 
*/ 
 
User Function ProcAgent() 
 
Local cWSServer 
Local cWSPort 
Local oRpc 
Local xRet , aRet 
Local cFn, nParms 
Local nTimer := seconds() 
Local nMaxOnline := 3600 + randomize(-180,181) 
Local cProcEmp 
Local cProcFil 
Local nSpendCall 
Local cAgentId 
Local bOldBlock 
Local nCallCount := 0 
Local nCallTimer := 0 
Local nCallSlow  := 0 
Local cMsgOut := '' 
Local cGtId := '' 
Local nThrdTot := 0 
 
ProcStatus("Begin ProcAgent",.t.) 
 
// parametros para conexao RPC com webservice 
cWsServer := GetPVProfstring("PROCAGENT","WSSERVER","",GetAdv97()) 
cWsPort := GetPVProfstring("PROCAGENT","WSPORT","",GetAdv97()) 
cAgentId := GetPVProfstring("PROCAGENT","AGENTID","",GetAdv97()) 
cProcEmp := GetPVProfstring("PROCAGENT","PROCEMP","",GetAdv97()) 
cProcFil := GetPVProfstring("PROCAGENT","PROCFIL","",GetAdv97()) 
 
If empty(cAgentId) 
	cAgentId := "UNKNOW" 
Endif 
 
// Acrescenta numero da thread ao identificador do agente 
cAgentId += "_" 
cAgentId += alltrim(str(ThreadID())) 
 
// Primeiro ajusta comportamento do ambiente 
// SetLoopLock(.f.) 
SetAbendLock(.t.) 
SetOnExit("U_PROCFinal") 
Rpcsettype(3) 
 
// Agora monta o ambiente local de processamento 
bOldBlock := ErrorBlock({|e| U_ProcError(e) }) 
BEGIN SEQUENCE 
xRet := RpcSetEnv(cProcEmp,cProcfil) 
END SEQUENCE 
ErrorBlock(bOldBlock) 
 
If !empty(__ProcError) 
	ProcStatus("Procagent - Prepare environment "+cProcEmp+"/"+cProcFil+" ERROR : "+CRLF+__ProcError,.t.) 
	Return 
ElseIf !xRet 
	ProcStatus("Procagent - Failed to prepare environment "+cProcEmp+"/"+cProcFil,.t.) 
	Return 
Else 
	ProcStatus("Procagent - Prepare environment OK - "+cProcEmp+"/"+cProcFil,.t.) 
Endif 
 
// Cria objeto para RPC 
oRpc := TRPC():New(GetEnvServer()) 
 
ProcStatus("Procagent - Connect to "+cWsServer+":"+cWsPort,.t.) 
 
// Localiza o WenService 
If !oRpc:Connect(cWSServer,val(cWSPort)) 
	ProcStatus("Procagent - RPC connectio failed to "+cWsServer+":"+cWsPort,.t.) 
	Return 
Endif 
 
xret := oRpc:Callproc("findfunction","u_getproccall") 
 
If valtype(xret) != "L" 
	ProcStatus("RPC Check function failed - Return "+valtype(xRet),.t.) 
	varinfo("RET",xret) 
	oRpc:Disconnect() 
	Return .f. 
Endif 
 
// Deixa o code-block default de erro tratar erros de RPC 
// na conexao montada no servico de webservices 
oRpc:Callproc("MontaBlock","Errorblock( { |x| 'DEFAULTERRORPROC' } )") 
 
// mostra que esta online 
oRpc:CallProc("conout","[RPC] Remote agent ["+cAgentId+"] connected.") 
 
while !killapp() 
 
	ProcStatus("Waiting for Process Call") 
	 
	// Aguarda por 5 segundos para pegar uma solicitacao de processamento 
	aRet := oRpc:CallProc("u_getproccall",cAgentId) 
	 
	If valtype(aRet) != "A" 
		ProcStatus("RPC GetProcCall failed - Return "+valtype(aRet)) 
		varinfo("RET",aRet) 
		oRpc:Disconnect() 
		Return .f. 
	Endif 
	 
	If aRet[1] == 1  // Funcao chamada 
		// Agora monta o ambiente local de processamento 
		bOldBlock := ErrorBlock({|e| U_ProcError(e) }) 
		BEGIN SEQUENCE 
			 
			dDatabase := date() 
			 
			nCallCount++ 
			 
			cGtId 	:= aRet[2] 
			cFn 	:= aRet[3] 
			nParms 	:= aRet[4] 
			 
			nSpendCall := seconds() 
			 
			ProcStatus("Get Work Process - Call ["+cFn+"]") 
		 
			IF nParms == 1 
				xRet := &cFn.(cGtId,aRet[5]) 
			ElseIF nParms == 2 
				xRet := &cFn.(cGtId,aRet[5],aRet[6]) 
			ElseIF nParms == 3 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7]) 
			ElseIF nParms == 4 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8]) 
			ElseIF nParms == 5 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8],aRet[9]) 
			ElseIF nParms == 6 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8],aRet[9],aRet[10]) 
			ElseIF nParms == 7 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8],aRet[9],aRet[10],aRet[11]) 
			ElseIF nParms == 8 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8],aRet[9],aRet[10],aRet[11],aRet[12]) 
			ElseIF nParms == 9 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8],aRet[9],aRet[10],aRet[11],aRet[12],aRet[13]) 
			ElseIF nParms == 10 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8],aRet[9],aRet[10],aRet[11],aRet[12],aRet[13],aRet[14]) 
			ElseIF nParms == 11 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8],aRet[9],aRet[10],aRet[11],aRet[12],aRet[13],aRet[14],aRet[15]) 
			ElseIF nParms == 12 
				xRet := &cFn.(cGtId,aRet[5],aRet[6],aRet[7],aRet[8],aRet[9],aRet[10],aRet[11],aRet[12],aRet[13],aRet[14],aRet[15],aRet[16]) 
			Endif 
			nSpendCall := seconds() - nSpendCall 
			 
			If nSpendCall < 0 
				nSpendCall += 86400 
			Endif 
			 
			nCallTimer += nSpendCall 
			 
			If nSpendCall > nCallSlow 
				nCallSlow  := nSpendCall 
			Endif 
			 
			ProcStatus("Process run in "+str(nSpendCall,12,3)+" s.") 
			 
		END SEQUENCE 
		ErrorBlock(bOldBlock) 
		 
		If !empty(__ProcError) 
			ProcStatus("Erro de Processamento de Funcao via SEND2PROC ERROR : "+CRLF+__ProcError,.t.) 
		EndIf	 
	 
	ElseIf aRet[1] == 2  // Processo remoto derrubado 
		ProcStatus("Remote Process Terminated",.T.) 
		EXIT 
	 
	Endif 
	 
	nOnline := seconds()-ntimer 
	 
	If nOnline < 0 
		nOnline += 86400 
	Endif 
	 
	If nOnline > nMaxOnline 
		// Passou mais de uma hora no ar, tchau 
		ProcStatus("Process exit - Refresh Service",.T.) 
		EXIT 
	Endif 
	 
	IF !empty(__ProcError) 
		// Houve um erro Advpl, nao posso segurar 
		// este job no ar. Tem que sair 
		EXIT 
	Endif 
	 
Enddo 
 
// Desconecta do RPC 
oRpc:Disconnect() 
 
// Limpa o objeto 
FreeObj(oRpc) 
 
// Seta status de saida 
If empty(__ProcError) 
	cMsgOut += "End ProcAgent OK " 
Else 
	cMsgOut += "End ProcAgent due ERROR CONDITION : " + __ProcError 
Endif 
 
ProcStatus(cMsgOut,.t.) 
 
Return 
 
/* 
Funcao de notificacao de status de processamento 
Monsta msg no log de console 
Atualiza informacoes da thread do Protheus Monitor 
*/ 
 
STATIC Function Procstatus(cMsg,lEcho) 
Local cStatus := "["+dtos(date())+" "+time()+"] " 
Local cEcho := cStatus + "[Thread "+alltrim(str(ThreadId(),10))+"] " 
 
If __ShowStatus == NIL 
	__ShowStatus := ( GetPVProfstring("PROCAGENT","SHOWSTATUS","",GetAdv97()) == '1' ) 
Endif 
 
DEFAULT lEcho := __ShowStatus 
 
PtInternal(1,cStatus+cMsg) 
 
If lEcho 
//	conout(cEcho+cMsg) 
Endif 
 
Return 
 
 
 
// Intercepta finalizacao ERP 
// alimenta Static de erro e manda um BREAK 
User Function PROCFinal(cStr1,cStr2) 
Local nStack 
DEFAULT cStr1 := "NIL" 
DEFAULT cStr2 := "NIL" 
__ProcError := 'ERP FINAL ROUTINE ('+cStr1+' - '+cStr2+')' + CRLF 
For nStack := 2 to 10 
	If !empty(procname(nStack)) 
		__ProcError += 'Called From '+padr(procname(nStack),30) + " "+str(procline(nStack),6,0)+CRLF 
	Endif 
Next 
//conout(__ProcError) 
If ( InTransact() ) 
	// SE ESTA NO MEIO DE TRANSACAO ERP, FAZ ROLLBACK NA UNHA !!! 
	// E ABANDONA A THREAD ATUAL !!! ELA NAO PODE FICAR NO AR NEM RETORNAR 
	conout("*** PROCFinal ERROR WHILE ACTIVE TRANSACTION - ROLLBACK AND QUIT *** ") 
	dbcommitall() 
	tccommit(3) 
	tccommit(4) 
	__QUIT() 
Endif 
BREAK 
 
 
 
// Recupera o erro e manda um BREAK 
User Function PROCError(e) 
__ProcError := e:errorstack 
//conout(CRLF+"*** PROCESS FATAL ERROR *** "+CRLF+__ProcError+CRLF) 
If ( InTransact() ) 
	// SE ESTA NO MEIO DE TRANSACAO ERP, FAZ ROLLBACK NA UNHA !!! 
	// E ABANDONA A THREAD ATUAL !!! ELA NAO PODE FICAR NO AR NEM RETORNAR 
	conout("*** PROCError ERROR WHILE ACTIVE TRANSACTION - ROLLBACK AND QUIT ***")    
	conout(CRLF+"*** PROCESS FATAL ERROR errorstack *** "+CRLF+__ProcError+CRLF) 
    conout(CRLF+"*** PROCESS FATAL ERROR operation *** "+CRLF+e:operation+CRLF) 
 
	dbcommitall() 
	tccommit(3) 
	tccommit(4) 
	__QUIT() 
Endif 
BREAK 
 
 
 
// Permite resgatar a msg de erro 
User Function GetProcError() 
Return __ProcError 
 
 
/* 
Funcao Send2Proc() 
 
Envia uma requisicao de processamento aos agentes de processamento 
Funcao chamada pelos WebSErvices 
Os agentes de processamento estao conectados por rpc no webservice 
Pode falhar em 2 condicoes : 
1) Nao hù agentes conectados 
2) Todos os agentes estao ocupados 
 
Esta funcao nao faz retry ou sleep 
 
*/ 
 
USER Function Send2Proc(cGtId,cFn,xPar1,xPar2,xPar3,xPar4,xPar5,xPar6,xPar7,xPar8,xPar9,xPar10,xPar11,xPar12) 
Local lGo 
 
IF pcount() < 1 
	UserException("Send2Proc Failed - Missing function name") 
ElseIf pcount() > 14 
	UserException("Send2Proc Failed - Unsupported call over 14 parameters.") 
Endif 
 
lGo  := IpcGo("PROCAGENT",cGtId,cFn,pcount()-2,xPar1,xPar2,xPar3,xPar4,xPar5,xPar6,xPar7,xPar8,xPar9,xPar10,xPar11,xPar12) 
 
Return lGo 
 
/* 
Funcao chamada por rpc de um agente de processamento 
conectado no servido de webservices para pegar uma requisicao 
enviada pela send2proc() 
recupera uma requisicao de processamento e parametros 
Espera por uma requisicao por 10 segundos 
*/ 
User Function GetProcCall(cAgentID) 
Local cGtId 
Local cFn 
Local nParms := 0 
Local xPar1 
Local xPar2 
Local xPar3 
Local xPar4 
Local xPar5 
Local xPar6 
Local xPar7 
Local xPar8 
Local xPar9 
Local xPar10 
Local xPar11 
Local xPar12 
Local lReceived 
Local nRet := 0 
 
procstatus("RPC Agent ["+cAgentID+"] waiting for call ...") 
 
lReceived := IpcWaitEx("PROCAGENT",10000,@cGtId,@cFn,@nParms,@xPar1,@xPar2,@xPar3,@xPar4,@xPar5,@xPar6,@xPar7,@xPar8,@xPar9,@xPar10,@xPar11,@xPar12) 
 
IF lReceived 
	procstatus("RPC Agent Receive call to ["+cFn+"] ID ["+cGtId+"]") 
	nRet := 1 
ElseIF KillApp() 
	procstatus("RPC Agent TERMINATED") 
	nREt := 2 
Endif 
 
nWsThrd := IpcCount("PROCAGENT") 
 
procstatus("[RPC] Threads Disponiveis ["+Alltrim(Str(nWsThrd+1))+"] ") 
 
Return {nRet,cGtId,cFn,nParms,xPar1,xPar2,xPar3,xPar4,xPar5,xPar6,xPar7,xPar8,xPar9,xPar10,xPar11,xPar12} 
 
 
 
/* 
Encapsulamento para execucao dos fontes especificos de pedido e nota 
em servicos dedidados distribuidos. 
*/ 
 
// Encapsulamento para chamar GARA110 em modo assincrono 
// Com tratamento de erro e retorno para o gerenciador transacional 
// via webservices 
// Funcao nao tem retorno ... retorna sempre NIL 
// O retorno de processamento ù enviado ao GAR 
// Mesmo em caso de falha. Caso ocorra falha no envio do retorno 
// a pendencia de retorno ù registrada em base correspondente. 
 
User Function GARA110J(cGtId,cChvBPag,aInfoSA1,aInfoSC5,aInfoSC6,aInfoSE1) 
Local aRet := {} 
Local bOldBlock 
Local cErrorMsg := '' 
Local cTipoProc 
Local aRetornos 
Local aRetThread:= GetUserInfoArray() 
Local nThread 	:= ThreadId() 
Local cSPID		:= "" 
 
aEval(aRetThread,{|x| Iif(x[3]==nThread,cSPID:=x[13],nil ) }) 
 
// Chama a funcao com protecao de execucao 
// em caso de erro, o erro tem que ser interceptado 
 
// Reseta status do(s) retorno(s) 
U_ResetStat() 
 
//conout("GARA110J - Processando requisicao: Pedido GAR  ["+cChvBPag+"] ID ["+cGtId+"] ID TOP ["+cSPID+"]... ") 
 
If !U_GarLock(cChvBPag) 
 
	// Antes de processar , verifica se ja nao tem processo  
	// em execucao com este numero de pedido do GAR  
	 
	U_GTPutPRO(cGtId) 
	 
	Return 
	 
Endif 
bOldBlock := ErrorBlock({|e| U_ProcError(e) }) 
BEGIN SEQUENCE 
U_GARA110(aInfoSA1,aInfoSC5,aInfoSC6,aInfoSE1) 
END SEQUENCE 
 
If InTransact() 
	// Esqueceram transacao aberta ... Fecha fazendo commit ... 
//	Conout("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***") 
	EndTran() 
Endif 
 
ErrorBlock(bOldBlock) 
 
cErrorMsg := U_GetProcError() 
 
If !empty(cErrorMsg) 
 
	aRet := {} 
	aadd(aRet , .F. ) 
	aadd(aRet , "000137") 	// Codigo de Erro Fatal 
	aadd(aRet , cChvBPag) 	// Numero do pedido 
	aadd(aRet , "GARA110J ASSYNC FATAL ERROR : "+cErrorMsg) 
	U_AddProcStat("P",aRet) 
 
Endif 
 
// Agora, envia os retornos 
// Uma mesma rotina pode gerar mais de um evento de retorno 
aRetornos := U_GetProcStat() 
 
// grava o log na camada no log de saida de processo 
U_GTPutOUT(cGTId,"P",cChvBPag,aRetornos) 
 
// E envia os retornos correspondentes 
U_GtSendRet(cGtId,aRetornos) 
 
// Solta o lock do processo deste item 
U_GarUnlock(cChvBPag) 
 
Return 
 
 
// Encapsulamento para chamar GARA130 em modo assincrono 
// Com tratamento de erro e retorno com callback 
 
User Function GARA130J(cGtId,cChvBPag,aInfoSZ5,lhub,cEvento) 
Local aRet := {} 
Local bOldBlock 
Local cErrorMsg := '' 
Local aRetThread:= GetUserInfoArray() 
Local nThread 	:= ThreadId() 
Local cSPID		:= "" 
 
Default lhub := .F. 
Default cEvento := "VALIDA" 
 
 
// Chama a funcao com protecao de execucao 
// em caso de erro, o erro tem que ser interceptado 
 
// Reseta status do(s) retorno(s) 
U_ResetStat() 
 
//conout("GARA130J - Processando requisicao: Pedido GAR  ["+cChvBPag+"] ID ["+cGtId+"] ID TOP ["+cSPID+"]... ") 
 
If !U_GarLock(cChvBPag) 
 
	// Antes de processar , verifica se ja nao tem processo  
	// em execucao com este numero de pedido do GAR  
	 
	U_GTPutPRO(cGtId) 
	 
	Return 
	 
Endif 
 
 
bOldBlock := ErrorBlock({|e| U_ProcError(e) }) 
BEGIN SEQUENCE 
U_GARA130(aInfoSZ5,lhub,cEvento) 
END SEQUENCE 
 
If InTransact() 
	// Esqueceram transacao aberta ... Fecha fazendo commit ...  
//	Conout("*** AUTOMATIC CLOSE OF ACTIVE TRANSACTION IN "+procname(0)+":"+str(procline(0),6)+"***") 
	EndTran() 
Endif 
 
ErrorBlock(bOldBlock) 
 
cErrorMsg := U_GetProcError() 
 
If !empty(cErrorMsg) 
	 
	aRet := {} 
	aadd(aRet , .F. ) 
	aadd(aRet , "000137") 	// Codigo de erro fatal 
	aadd(aRet , cChvBPag) 	// Numero do pedido 
	aadd(aRet , "GARA130J ASSYNC FATAL ERROR : "+cErrorMsg) 
	U_AddProcStat("E",aRet) 
	 
Endif 
 
// Agora, envia os retornos 
// Uma mesma rotina pode gerar mais de um evento de retorno 
aRetornos := U_GetProcStat() 
 
// grava o log na camada no log de saida de processo 
if len( aRetornos ) > 0 
	U_GTPutOUT(cGTId,"E",cChvBPag,aRetornos) 
endif 
 
// E envia os retornos correspondentes 
If !lhub 
	U_GtSendRet(cGtId,aRetornos) 
EndIf 
 
// Solta o lock do processo deste item 
U_GarUnlock(cChvBPag) 
 
Return .T. 
 
 
 
// Grava um arquivo de LOG com a resposta da acao 
// SEja ela certa ou errada .... 
// cType : "P" PEdido ou "N" Nota 
STATIC Function SavePROCLOG(cGTId,cType,aRet) 
Local nHandle 
Local cFileOut 
Local lGravaLog		:= GetNewPar("MV_GARLOG", "1") == "1" 
 
If lGravaLog 
	 
	If len(aRet) < 3 
		varinfo("ARET",aRET) 
		UserException("*** ARET INVALID FORMAT ***") 
	endif 
	cFileOut := "\PROCLOG\GAR_"+cType+"_"+StrZero(Val(aRet[3]),10)+".LOG" 
	nHandle := FCREATE(cFileOut) 
	If nHandle != -1 
		FWrite(nHandle,"ERQUEST ID : " + cGTId +  CRLF ) 
		FWrite(nHandle,"MESSAGE : " + GetByCode(aRet[2]) +  CRLF ) 
		FWrite(nHandle,varinfo("LOGRET",aRet,,.f.,.f.) + CRLF ) 
		fclose(nHandle) 
	Else 
//		CONOUT("ERROR - FAILED TO CREATE "+cFileOut+" - FERROR "+str(ferror())) 
	Endif 
	 
Endif 
 
Return 
// Recebe um codigo de mensagem 
// Retorna descricao da mensagem na tabela SZ7 
 
STATIC Function GetByCode(cErrCode) 
SZ7->( DbSetOrder(1) ) 
IF SZ7->( MsSeek( xFilial("SZ7")+cErrCode ) ) 
	Return SZ7->Z7_DESMEN 
Endif 
Return "MESSAGE ["+cErrCode+"] DESCRIPTION NOT FOUND" 
 
 
 
/* 
Funcao de Envio de retornos e status de processamentos do ERP 
Envia um ou mais tipos de retorno, com tratamento para re-envio 
*/ 
 
User Function GtSendRet(cGtId,aRetornos) 
 
Local cTipoProc	:= "" 
Local aRet		:= {} 
Local aRetAux	:= {} 
 
// Protegendo o fonte quanto aos arrays... 
If ValType(aRetornos) <> "A" 
	aRetornos := {} 
	 
	Aadd( aRet, .F. ) 
	Aadd( aRet, "999999" ) 
	Aadd( aRet, "9999999999" ) 
	Aadd( aRet, "ERROR CRITICO 001 - Nao foi possùvel montar o array de retorno" ) 
	 
	Aadd( aRetornos , "X" ) 
	Aadd( aRetornos , aRet ) 
 
Endif 
 
While Len(aRetornos) > 0 
	 
	// Pega tipo de retorno / etapa 
	// e conteudo retornado 
	cTipoProc := aRetornos[1][1] 
	aRet := aclone(aRetornos[1][2]) 
	 
	// Protege o fonte quanto aos arrays... 
	If ValType(aRet) <> "A" 
		aRet := {} 
		Aadd( aRet, .F. ) 
		Aadd( aRet, "999999" ) 
		Aadd( aRet, "9999999999" ) 
		Aadd( aRet, "ERROR CRITICO 002 - Nao foi possùvel montar o array de retorno" ) 
	ElseIf Len(aRet) <> 4 
		Do Case 
			Case Len(aRet) == 0 
				Aadd( aRet, .F. ) 
				Aadd( aRet, "999999" ) 
				Aadd( aRet, "9999999999" ) 
				Aadd( aRet, "ERROR CRITICO 003 - Nao foi possùvel montar o array de retorno" ) 
			Case Len(aRet) == 1 
				Aadd( aRet, "999999" ) 
				Aadd( aRet, "9999999999" ) 
				Aadd( aRet, "ERROR CRITICO 004 - Nao foi possùvel montar o array de retorno" ) 
			Case Len(aRet) == 2 
				Aadd( aRet, "9999999999" ) 
				Aadd( aRet, "ERROR CRITICO 005 - Nao foi possùvel montar o array de retorno" ) 
			Case Len(aRet) == 3 
				Aadd( aRet, "ERROR CRITICO 006 - Nao foi possùvel montar o array de retorno" ) 
			OtherWise 
				aRetAux := Aclone( aRet ) 
				aRet := {} 
				Aadd( aRet, aRetAux[1] ) 
				Aadd( aRet, aRetAux[2] ) 
				Aadd( aRet, aRetAux[3] ) 
				Aadd( aRet, aRetAux[4] ) 
		Endcase 
	Endif 
	 
	// elimina do array de retornos 
	adel(aRetornos,1) 
	asize(aRetornos,len(aRetornos)-1) 
	 
	// Grava uma etapa no log de retorno de um processamento 
	SavePROCLOG(cGTId,cTipoProc,aRet) 
	 
	IF cTipoProc == "P" 
		 
		// Retorno de Inclusao de Pedido 
		 
		If U_GTRetPed(cGTId,aRet) 
			// Se mandou o retorno direto, beleza ! 
//			conout("Retorno de inclusao de pedido enviado com sucesso.") 
		Else 
			// Se falhou a chamada do Gerencioador Transacional, 
			// grava o retorno na tabela de retornos pendentes 
			U_GTPutRet(cGtId,"P",aRet) 
//			conout("Retorno Falso de inclusao de pedido enviado com sucesso.") 
		Endif 
		 
	ElseIF cTipoProc == "F" 
		 
		// Nota de Entrega Futura / Prefeitura 
		 
		If U_GTRetNFF(cGTId,aRet) 
			// Se mandou o retorno direto, beleza ! 
//			conout("Retorno de geracao de nota futura enviado com sucesso.") 
		Else 
			// Se falhou a chamada do Gerencioador Transacional, 
			// grava o retorno na tabela de retornos pendentes 
			U_GTPutRet(cGtId,"F",aRet) 
//			conout("Retorno Falso de geracao de nota futura enviado com sucesso.") 
		Endif 
		 
	ElseIF cTipoProc == "E" 
		 
		// Nota de Entrega Efetiva 
		 
		If U_GTRetNFE(cGTId,aRet) 
			// Se mandou o retorno direto, beleza ! 
//			conout("Retorno de geracao de nota de entrega efetiva enviado com sucesso.") 
		Else 
			// Se falhou a chamada do Gerencioador Transacional, 
			// grava o retorno na tabela de retornos pendentes 
			U_GTPutRet(cGtId,"E",aRet) 
//			conout("Retorno Falso de geracao de nota de entrega efetiva enviado com sucesso.") 
		Endif 
		 
	Endif 
	 
Enddo 
 
Return
