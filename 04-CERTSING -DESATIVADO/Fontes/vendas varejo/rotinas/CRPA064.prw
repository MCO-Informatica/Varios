#INCLUDE "Totvs.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"

#DEFINE cEOL    CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA027   º Autor ³ Renato Ruy	     º Data ³  21/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para importação de dados que serão usado para     º±±
±±º          ³ calculo do remuneração de parceiros.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA064(cEmpPar, cFilPar, dDataProc, lRunOld)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oDlg
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= ""  
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.
Local nModal	:= ""	// 1 = Arquivo, 2 = WebService Ativo, 3= WebService Passivo
Local cArqTxt	:= ""
Local nHdl		:= 0
Local cChaveExe	:= "CRPA064"

Private nLogProc	:= 0

DEFAULT cEmpPar	:= "01"
DEFAULT cFilPar	:= "02"
DEFAULT dDataProc := CTOD("//")
DEFAULT lRunOld	:= .T.

C064Conout("=========================================================================")
C064Conout("#==============      Rotina para importação de pedidos.    ==============")
C064Conout("=========================================================================")

//Carrega o ambiente
If LoadEnv(cEmpPar, cFilPar)

	C064Conout("Ambiente carregado")

	cDirIn := AllTrim(GetNewPar("MV_XCRP27D","\pedidosfaturados\GAR\"))
	nModal := GetNewPar("MV_XCRP027",1)
	
	C064Conout("Verificando arquivo do dia corrente " + DTOC(dDataProc))
	//Verifica se existe o arquivo para processamento
	
	If Empty(dDataProc)
		dDataProc := dDataBase
	Else
		dDataProc := Iif(ValType(dDataProc) != "D", Iif("/" $ dDataProc,CTOD(dDataProc),SToD(dDataProc)), dDataProc)
	EndIf
	
	cFileIn := cDirIn + "Rel_Hist_Carga_ERP_Eventos"+DtoS(dDataProc)+".csv"
	lExistFile := File(cFileIn)
	
	cChaveExe += DtoS(dDataProc) 
	
	C064Conout("Verificando PC1")
	//Abre a tabela de controle para processamento do arquivo
	dbSelectArea("PC1")
	PC1->(dbSetOrder(1))
	lFoundPC1 := PC1->(!dbSeek(xFilial("PC1") + DTOS(dDataProc)))
	
	//Grava dados sobre o arquivo
	RecLock("PC1",lFoundPC1)
		PC1->PC1_FILIAL	:= xFilial("PC1")
		PC1->PC1_DATA 	:= dDataProc
		PC1->PC1_ARQUIV	:= AllTrim(cFileIn)
		PC1->PC1_PROC	:= .F.
		PC1->PC1_ISFILE	:= lExistFile
	PC1->(MsUnlock())
	
	C064Conout("Registro gravado na tabela PC1")

	//Processa Arquivos Antigos
	C064Conout("Verificando arquivos antigos ainda não processados.")
	If LockByName(cChaveExe)
		If RunQuery(lRunOld, dDataProc)
			C064Conout("Processando arquivos antigos.")
			ProcArq()
			TMPARQ->(dbCloseArea())
		EndIf
		
		UnlockByName(cChaveExe)
	Else
		C064Conout("Já existe um processamento em execução. Por gentileza, aguarde seu término.")
	EndIf
	
	C064Conout("Limpando Ambiente")
	If !IsInCallStack("U_CRPA064Dt")
		RpcClearEnv()
	EndIf
EndIf


Return
 
/*
Rotina para envio de email de notificação de status da liberação do pedido de compras
*/
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

If !lRet
	logProc(4,"Falha no envio de e-mail:" + cErro)
EndIf

Return(lRet)

/*/{Protheus.doc} RunQuery
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 23/12/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function RunQuery(lRunOld, dDtProc)

Local cExpOld := ""

If lRunOld
	cExpOld := "% AND PC1.PC1_DATA <= '" + DTOS(dDataBase) + "' %"
Else
	cExpOld := "% AND PC1.PC1_DATA = '" + DTOS(dDtProc) + "' %"
EndIf

If Select("TMPARQ") > 0
	TMPARQ->(dbCloseArea())
EndIf

//Verifica se há registros sem processamento ou com arquivos inexistentes
Beginsql Alias "TMPARQ"

	SELECT PC1_DATA DATA, PC1_ARQUIV ARQUIVO, PC1_ISFILE ARQEXIST, PC1_PROC PROCESSADO, R_E_C_N_O_ RECNO
	FROM %Table:PC1% PC1
	WHERE (PC1.PC1_PROC = 'F' OR PC1.PC1_ISFILE = 'F')
	%Exp:cExpOld%
	AND PC1.%Notdel% 

Endsql

Return TMPARQ->(!EOF())

/*/{Protheus.doc} ProcArq
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 23/12/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function ProcArq()

Local aFile404 	 := {}
Local cMsgFail 	 := ""
Local lFileExist := .F.
Local lProcArq 	 := .F.
Local Ni		 := 0
Local dLastMail	 := Iif(Empty(GetMV("MV_XLTMAIL")),CTOD("//"),GetMV("MV_XLTMAIL"))

While TMPARQ->(!EoF())
	
	lFileExist 	:= TMPARQ->ARQEXIST == "T"
	lProcArq 	:= TMPARQ->PROCESSADO == "T"
	
	If !lFileExist
		If File(AllTrim(TMPARQ->ARQUIVO))
			PC1->(dbGoTo(TMPARQ->RECNO))
		
			lFileExist := .T.
			RecLock("PC1", .F.)
				PC1->PC1_ISFILE := .T.
			PC1->(MsUnlock())
		EndIf
	EndIf
	
	If !lProcArq .And. lFileExist
		// CRPA063(cEmpPar, cFilPar, dDataProc)
		//Send2Proc seria melhor opção?
		//StartJob("U_CRPA063",GetEnvServer(),.F.,'01','02',TMPARQ->DATA)
		U_CRPA063(cFilAnt,cFilAnt,TMPARQ->DATA)
	Else
		aAdd(aFile404, AllTrim(TMPARQ->ARQUIVO))
	EndIf
	
	TMPARQ->(dbSkip())
EndDo

If Len(aFile404) > 0 .And. dLastMail <> dDataBase

	cMsgFail := "O arquivo de pedidos do GAR não foi localizado para importação:" + cEOL 
	
	For Ni := 1 To Len(aFile404)
		cMsgFail += "Arquivo: " + aFile404[Ni] + cEOL 
	Next

	cMsgFail += "Data e Hora: " + DTOC(dDatabase) + " - " + Time()

	If MandEmail(cMsgFail, "sistemascorporativos@certisign.com.br", "[CRPA064] Log Importação GAR - TESTE")
		PutMV("MV_XLTMAIL", dDataBase)
	EndIf
EndIf

Return

Static Function LoadEnv(cEmpPar, cFilPar)

Local lLoadOk := .F.

C064Conout("Carregando ambiente")

If Type("cFilAnt") == "U" .And. Type("cEmpAnt") == "U"
	RpcClearEnv()
	RpcSetType(3)
	lLoadOk := RpcSetEnv(cEmpPar,cFilPar)
Else
	lLoadOk := .T.	
EndIf

Return lLoadOk


User Function CRPA064Dt(cDataDe, cDataAte, lMesCheio)

Local oDlg
Local oSDataDe
Local oSDataAte
Local oGDataDe
Local oGDataAte
Local oCbMesCheio
Local oBtCancel
Local oFont
Local oBtOK
Local dDataDe 		:= CTOD("//")
Local dDataAte 		:= CTOD("//")
Local lHasButton 	:= .T.
Local bValida		:= Nil
Local lCancela		:= .F.

Default cDataDe := ""
Default cDataAte := ""
Default lMesCheio := .T.

oFont := TFont():New('Courier new',,-18,.T.)

Set(_SET_DATEFORMAT, 'dd/mm/yyyy')

If Empty(cDataDe)
	oDlg := TDialog():New(180,180,325,400,"Exemplo TDialog",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSDataDe:= TSay():New(12,05,{||'Data De:'},oDlg,,,,,,.T.,,,200,20)
	oSDataAte:= TSay():New(32,05,{||'Data Até:'},oDlg,,,,,,.T.,,,200,20)
	
	oGDataDe := TGet():New( 10, 40, { | u | If( PCount() == 0, dDataDe, dDataDe := u ) },oDlg,060, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,{|| Iif(!lMesCheio .And. Empty(dDataAte),dDataAte:=dDataDe,Nil),oGDataAte:CtrlRefresh()},.F.,.F. ,,"dDataDe",,,,lHasButton  )
	oGDataAte := TGet():New( 30, 40, { | u | If( PCount() == 0, dDataAte, dDataAte := u ) },oDlg,060, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDataAte",,,,lHasButton  )
		
	oCBMesCheio := TCheckBox():New(45,15,'Processa Mês inteiro?',{| u | If( PCount() == 0, lMesCheio, lMesCheio := !lMesCheio )},oDlg,100,210,,,,,,,,.T.,,,)
	
	oBtOK := TButton():New( 60, 10, "Ok",oDlg,{|| oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	oBtCancel := TButton():New( 60, 60, "Cancela",oDlg,{|| lCancela:=.T., oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	
	
	bValida := {|| C64DlgVld(oDlg:nResult, @lCancela, @dDataDe, @dDataAte, lMesCheio)}
	oDlg:Activate(,,,.T.,bValida,,{|| /*msgstop("Iniciando") */})
	
	cDataDe := DTOC(dDataDe)
	cDataAte := Iif(lMesCheio, DTOC(LastDay(Date())), Iif(Empty(dDataAte),"//",DToC(dDataAte)))
	
	//cDataDe 	:= cValToChar(Year(Date())) +  StrZero(Month(Date(),2)) + "01" 
	//cDataAte 	:= Iif(lMesCheio, DTOS(LastDay(Date())), "//") 
EndIf

If lCancela 
	Alert("Rotina cancelada.")
	Return
EndIf

dDataDe := Iif(("/" $ cDataDe), CTOD(cDataDe), STOD(cDataDe))
dDataAte := Iif(("/" $ cDataAte), CTOD(cDataAte), STOD(cDataAte))


Processa({|| C64Loop(dDataDe, dDataAte)},"Processando","Processando as datas informadas",.F.)

RpcClearEnv()

Return

Static function C64Loop(dDataDe, dDataAte)

Local nDifData := 0

nDifData := DateDiffDay(dDataDe, dDataAte)
ProcRegua(nDifData)

While dDataDe <= dDataAte
	
	IncProc(DTOC(dDataDe))

	U_CRPA064("01", "02", dDataDe, .F.)
	
	dDataDe := dDataDe + 1
EndDo

Return

Static Function C64DlgVld(nResult, lCancela, dDataDe, dDataAte, lMesCheio)

Local lRet := .T.

//Iif(oDlg:nResult == 2, lCancela:=.T., Nil), Iif(((Empty(dDataAte) .And. !lMesCheio) .Or. Empty(dDataDe) .And. !lCancela),(Alert("Há parâmetros inconsistentes, verifique."),.F.),.T.)

If nResult == 2
	lCancela := .T.
	lRet := .T.
EndIf

If Empty(dDataAte) .And. !lMesCheio .And. !lCancela
	Alert("Verifique a Data Até.")
	Return .F.
EndIf

Return lRet

Static Function C064Conout(cMsg)

conout("[CRPA064 - "+DTOC(Date()) + " - " + Time() +"]: " + cMsg)

Return