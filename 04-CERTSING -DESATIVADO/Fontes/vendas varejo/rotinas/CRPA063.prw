#INCLUDE "Totvs.ch"
#include "fileio.ch"
#INCLUDE "TBICONN.CH"

#DEFINE cEOL    CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRPA027   บ Autor ณ Renato Ruy	     บ Data ณ  21/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para importa็ใo de dados que serใo usado para     บฑฑ
ฑฑบ          ณ calculo do remunera็ใo de parceiros.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CRPA063(cEmpPar, cFilPar, dDataProc)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

DEFAULT cEmpPar		:= "01"
DEFAULT cFilPar		:= "02"
DEFAULT dDataProc	:= CTOD("//")

C063Conout("=========================================================================")
C063Conout("#==============      Rotina para importa็ใo de pedidos.    ==============")
C063Conout("=========================================================================")

//Carrega o ambiente
If LoadEnv(cEmpPar,cFilPar)

	cDirIn := GetNewPar("MV_XCRP27D","\pedidosfaturados\GAR\")
	nModal := GetNewPar("MV_XCRP027",1)

	If Empty(dDataProc)
		dDataProc := dDataBase
	Else
		If ValType(dDataProc) == "C"
			dDataProc := Iif("/" $ dDataProc, CTOD(dDataProc), STOD(dDataProc))
		EndIf
	EndIf

	//Define o arquivo a ser processado
	cFileIn += cDirIn + "Rel_Hist_Carga_ERP_Eventos"+DtoS(dDataProc)+".csv"
	
	//Verifica se o arquivo existe
	If File(cFileIn)
		
		C063Conout("Arquivo " + AllTrim(cFileIn) + " encontrado")
		
		//Verifica se ้ possํvel abrir o arquivo
		If OpenFile(cFileIn, @cArqTxt, @nHdl)
			
			C063Conout("Arquivo aberto")
			
			//Executa o processamento do arquivo
			RunCont(cArqTxt, dDataProc)
		EndIf
	Else
		MandEmail("O arquivo de pedidos do GAR nใo foi localizado para importa็ใo:" + cEOL +;
					"Arquivo: " + cArqTxt + cEOL +;
					"Data e Hora: " + DTOC(dDatabase) + " - " + Time(), "sistemascorporativos@certisign.com.br", "Log Importa็ใo GAR ")
	EndIf
Else
	
EndIf


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  12/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
7ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RUNCONT(cArqTxt, dDataProc)

Local nContador := 0
Local aPedidos  := {}
Local aPedido2 	:= {}
Local nTotRec	:= 0
Local nThread	:= 0
Local nPerCCR 	:= 0
Local cArqLog 	:= ""
Local nHdlLog  	:= 0
Local cPedido	:= ""
Local cCodRD	:= ""
Local lNovoZZ3 	:= .F.
Local cLog		:= ""
Local cLogMem	:= ""
Local nTamLin, cLin, cCpo

C063Conout("Iniciando rotina RUNCONT")

/*If !FLogCreate(cLogFile,nHdlLog,nTotRec,nModal)
	C063Conout("[CRPA027] Falha na cria็ใo do log")
EndIf*/

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Lay-Out do arquivo Texto gerado:                                บ
//ฬออออออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออน
//บCampo           ณ Inicio ณ Tamanho                               บ
//วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
//บ ??_FILIAL     ณ 01     ณ 02                                    บ
//ศออออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออผ

FT_FUSE(cArqTxt)

nTotRec := FT_FLASTREC()

FT_FGOTOP()

C063Conout("Iniciando itera็ใo do arquivo")

While !FT_FEOF()

	//Faz distribui็ใo e monitora a quantidade de thread em execu็ใo
/*	nThread := 0
	aUsers 	:= Getuserinfoarray(.F.)
	aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRPA027B",nThread++,nil )  })

	//Limita a quantidade de Threads.
	If nThread < 10*/

		nContador := 0
		aPedidos  := {}

		//Envio para processamento de 10 em 10 pedidos.
		//While !FT_FEOF() .And. nContador < 80
			//Leio a linha e gero array com os dados
			xBuff	:= StrTran(FT_FREADLN(),";","; ")
			aLin 	:= StrTokArr2(xBuff,";",.T.)
			
			If Len(aLin) == 2
				AADD(aLin," ")
			ElseIf Len(aLin) < 3
				FT_FSKIP()
				Loop
			Endif

			//Adiciono o conte๚do em uma variavel para enviar para o array
			cPedido := iif(RTrim(aLin[2])!="RVD",FormatPd(aLin[1]),"")
			nPerCCR := Iif(!Empty(aLin[3]),Val(aLin[3]),0)
			cCodRD	:= Iif(!Empty(aLin[4]),AllTrim(aLin[4]),"")
			
			//Gravo somente se nใo existir o registro na tabela
			dbSelectArea("ZZ3")
			ZZ3->(dbSetOrder(2))
			lNovoZZ3 := ZZ3->(!dbSeek(xFilial("ZZ3") + AllTrim(cPedido)))
			
			If !lNovoZZ3
				//cLog := AllTrim(ZZ3->ZZ3_LOG) + "|Atualiza็ใo"
				cLogMem := AllTrim(ZZ3->ZZ3_LOGMEM) + CHR(13) + CHR(10) + DToC(dDataBase) + " - Atualiza็ใo do Pedido"
			Else
				cLog := "Pedido importado do arquivo"
				cLogMem := DToC(dDataBase) + " - Pedido importado do arquivo CSV"
			EndIf
			
			RecLock("ZZ3",lNovoZZ3)
				ZZ3->ZZ3_FILIAL := xFilial("ZZ3")
				ZZ3->ZZ3_DTIMP	:= dDataProc
				ZZ3->ZZ3_PEDGAR := cPedido
				ZZ3->ZZ3_LOG	:= cLog
				ZZ3->ZZ3_XMLWS	:= ""
				ZZ3->ZZ3_IMPOK	:= "N"
				ZZ3->ZZ3_LOGMEM	:= cLogMem
				ZZ3->ZZ3_DATA	:= CTOD("//")
				ZZ3->ZZ3_HORA	:= ""
				ZZ3->ZZ3_PERCCR	:= nPerCCR
				ZZ3->ZZ3_CODRD	:= cCodRD
				ZZ3->ZZ3_MAIL	:= "N"
			ZZ3->(MsUnlock())				


			//Pulo para a pr๓xima linha.
			FT_FSKIP()
		//EndDo

	//EndIf

	//Gerou erro ao fazer varias vezes a consulta da thread - Getuserinfoarray.
/*	If nThread > 9
		Sleep( 50000 )
		DelClassIntf()
		nThread := 0
	EndIf*/

Enddo

FT_FUSE()

C063Conout("Arquivo fechado")

C063Conout("Atualizando flag de processamento na PC1")
dbSelectArea("PC1")
PC1->(dbSetOrder(1))
If PC1->(dbSeek(xFilial("PC1") + DTOS(dDataProc)))
	RecLock("PC1", .F.)
		PC1->PC1_PROC := .T.
	PC1->(MsUnlock())
EndIf

C063Conout("Antiga chamada do CRPA027W foi transportada para Job")
//Renato Ruy - 25/04/2016
//Processa calculo diario online e atualiza dados para o controle de faixas.
//U_CRPA027W()

C063Conout("Antiga chamada do CRPA027Y foi transportada para Job")
//Renato Ruy - 05/05/2016
//Remove os pedidos de renova็ใo rejeitados e sem voucher.
//U_CRPA027Y()

C063Conout("Encerrando rotina")

If !IsInCallStack("U_CRPA064")
	C063Conout("Limpando Ambiente")
	RpcClearEnv()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CRPA027A(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.TXT")

Return(.T.)

/*
Rotina para envio de email de notifica็ใo de status da libera็ใo do pedido de compras
*/
Static Function MandEmail(xCorpo, xDest, xAssunto, xAnexo, xCC, xBCC, xAcc)

Local   cAccount  := AllTrim(GetNewPar("MV_RELACNT"," "))
Local   cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
Local   cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
Local   cUserAut  := Alltrim(GetMv("MV_RELAUSR",,"")) //Usuแrio para Autentica็ใo no Servidor de Email
Local   cPassAut  := Alltrim(GetMv("MV_RELAPSW",,""))//Senha para Autentica็ใo no Servidor de Email
Local   nTimeOut    := GetMv("MV_RELTIME",,120) //Tempo de Espera antes de abortar a Conexใo
Local   lAutentica  := GetMv("MV_RELAUTH",,.F.) //Determina se o Servidor de Email necessita de Autentica็ใo
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
		cErro := "Erro durante o envio - destinatแrio: " + xDest + CRLF + CRLF + cErro
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
	C063Conout(4,"Falha no envio de e-mail:" + cErro)
EndIf

Return(lRet)

//Fun็ใo para retirar caracteres especiais dos pedidos gerados no txt.
Static Function FormatPd(cPedido)

Local cRet	:=	""
Local nI	:=	1

For nI:=1 To Len(cPedido)
	If Isdigit(Subs(cPedido,nI,1)) .Or. IsAlpha(Subs(cPedido,nI,1))
		cRet+=Substr(cPedido,nI,1)
	Endif
Next

cRet := AllTrim(cRet)

Return(cRet)


Static Function CRP027LOG(cPedido,cMsg,nLinha) 

Local lNewReg 	:= .F.
Local cLog		:= ""

cLog := DTOC(Date()) + " - " + Time() + " - " + cValToChar(nLinha) + ": " + cMsg

dbSelectArea("PBY")
PBY->(dbSetOrder(3))

If !PBY->(dbSeek(xFilial("PBY") + cPedido + AllTrim(Str(ThreadId()))))
	RecLock("PBY",.T.)
		PBY->PBY_FILIAL := xFilial("PBY")
		PBY->PBY_THREAD := ThreadId()
		PBY->PBY_FUNCAO := "CRPA027"
		PBY->PBY_USERID := cUserName
		PBY->PBY_DATA	:= dDataBase
		PBY->PBY_HORA	:= Time()
		PBY->PBY_PEDIDO	:= SZ5->Z5_PEDGAR
		PBY->PBY_PEDSIT := SZ5->Z5_PEDSITE
		PBY->PBY_LOG 	:= cLog
	PBY->(MsUnlock())
Else
	RecLock("PBY",.F.)
		PBY->PBY_LOG	:= PBY->PBY_LOG + CRLF + cLog
	PBY->(MsUnlock())
EndIf

Return


/*/{Protheus.doc} LoadEnv
//TODO Descri็ใo auto-gerada.
@author yuri.volpe
@since 19/12/2019
@version 1.0
@return ${return}, ${return_description}
@param cEmpPar, characters, descricao
@param cFilPar, characters, descricao
@type function
/*/
Static Function LoadEnv(cEmpPar, cFilPar)

Local lLoadOk := .F.

C063Conout("Carregando ambiente")

If Type("cFilAnt") == "U" .And. Type("cEmpAnt") == "U"
	RpcClearEnv()
	RpcSetType(3)
	lLoadOk := RpcSetEnv(cEmpPar,cFilPar)
Else
	lLoadOk := .T.	
EndIf

Return lLoadOk

/*/{Protheus.doc} OpenFile
//TODO Descri็ใo auto-gerada.
@author yuri.volpe
@since 19/12/2019
@version 1.0
@return ${return}, ${return_description}
@param cFileIn, characters, descricao
@param cArqTxt, characters, descricao
@param nHdl, numeric, descricao
@type function
/*/
Static Function OpenFile(cFileIn,cArqTxt,nTotRec,nHdl)

cArqTxt := cFileIn
nHdl    := fOpen(cArqTxt,68)

If !File(cArqTxt) .Or. nHdl == -1
	C063Conout("O Arquivo "+cArqTxt+" nใo pode ser aberto. O processamento nใo serแ executado.")
	Return .F.
Else
	FT_FUSE(cArqTxt)

	nTotRec := FT_FLASTREC()

	FT_FGOTOP()
EndIf

C063Conout("Iniciando processamento do arquivo.")

Return .T.



/*/{Protheus.doc} FLogCreate
//TODO Descri็ใo auto-gerada.
@author yuri.volpe
@since 20/12/2019
@version 1.0
@return ${return}, ${return_description}
@param cLogFile, characters, descricao
@param nHdlLog, numeric, descricao
@param nModal, numeric, descricao
@type function
/*/
Static Function FLogCreate(cLogFile,nHdlLog,nModal)

Local cLin		:= ""
DEFAULT nModal 	:= 0

Do Case
	Case nModal == 0
		cLogFile 	:= "\pedidosfaturados\GAR\log"+DtoS(dDataBase)+".csv"
		nHdlLog  	:= fCreate(cArqLog)
		If nHdlLog != -1
			cLin := "Data Importa็ใo;Pedido Gar;Pedido Protheus;Produto Gar;C๓digo Voucher;Tipo Voucher;Log Importa็ใo;Validado;Verificado;Emitido"+cEOL
			fWrite(nHdlLog,cLin)
		Endif
	Case nModal == 1
		cLogFile	:= "\pedidosfaturados\GAR\log\Import_GAR_" + DtoS(dDataBase) + StrTran(Time(),":","") + ".csv"
		nHdlLog 	:= fCreate(cLogFile)
EndCase

Return nHdlLog > -1


/*/{Protheus.doc} FLogWrite
//TODO Descri็ใo auto-gerada.
@author yuri.volpe
@since 20/12/2019
@version 1.0
@return ${return}, ${return_description}
@param nHdlLog, numeric, descricao
@param cTexto, characters, descricao
@type function
/*/
Static Function FLogWrite(nHdlLog,cTexto)

Local nBytes := 0
Local cMensagem := "[" + DTOS(Date()) + " - " + Time() + "]: " + cTexto

nBytes := FWrite(nHdlLog, cMensagem)
C063Conout("[CRPA027 - " + Substr(cMensagem,2))

Return nBytes > 0


/*/{Protheus.doc} FLogClose
//TODO Descri็ใo auto-gerada.
@author yuri.volpe
@since 20/12/2019
@version 1.0
@return ${return}, ${return_description}
@param nHdlLog, numeric, descricao
@type function
/*/
Static Function FLogClose(nHdlLog)
Return fClose(nHdlLog)

Static Function C063Conout(cMsg)

conout("[CRPA063 - "+DTOC(Date()) + " - " + Time() +"]: " + cMsg)

Return


User Function CRP063Mail(dDataProc)

Local nHdlLog 	:= -1
Local cLin		:= ""
Local cArqLog 	:= "\pedidosfaturados\GAR\log"+DtoS(dDataBase)+".csv" 

DEFAULT dDataProc := dDataBase

If !FLogCreate(cLogFile,@nHdlLog,0)
	C063Conout("Nใo foi possํvel criar o arquivo de log a ser enviado")
EndIf

If Select("QCRPA027") > 0
	QCRPA027->(dbCloseArea())
EndIf

C063Conout("Iniciando query para enviar e-mail")
//Verifico tabela do log de importacao
BeginSql Alias "QCRPA027"
	SELECT SUBSTR(ZZ3_DTIMP,7,2)||'/'||SUBSTR(ZZ3_DTIMP,5,2)||'/'||SUBSTR(ZZ3_DTIMP,1,4) ZZ3_DTIMP,
		   ZZ3_PEDGAR,
		   ZZ3_LOG,
		   C5_NUM,
		   Z5_PRODGAR,
		   Z5_CODVOU,
		   ZF_DESTIPO
	FROM %Table:ZZ3% ZZ3
	//GERAR INFORMAวรO DE VOUCHER E PRODUTO.
	LEFT JOIN %Table:SC5% SC5 ON C5_FILIAL = %xFilial:SC5% AND TRIM(C5_CHVBPAG) = TRIM(ZZ3_PEDGAR) AND SC5.D_E_L_E_T_ = ' '
	LEFT JOIN %Table:SZ5% SZ5 ON Z5_FILIAL = %xFilial:SZ5% AND Z5_PEDGAR = ZZ3_PEDGAR AND Z5_PEDGAR > ' ' AND SZ5.D_E_L_E_T_ = ' '
	LEFT JOIN %Table:SZF% SZF ON ZF_FILIAL = %xFilial:SZF% AND ZF_COD = Z5_CODVOU AND ZF_SALDO = 0 AND SZF.D_E_L_E_T_ = ' '
	WHERE
	ZZ3.D_E_L_E_T_ = ' '
	AND ZZ3_FILIAL = %xFilial:ZZ3%
	AND ZZ3_DTIMP = %Exp:DtoS(dDataProc)%
EndSql

DbSelectArea("QCRPA027")
QCRPA027->(DbGoTop())

C063Conout( "Query executada: " + GetLastQuery()[2])
C063Conout( "QCRPA027 EOF? " + cValToChar(QCRPA027->(EOF())))

//Gravo dados no log
While QCRPA027->(!EOF())
	If nHdlLog != -1
		cLin := QCRPA027->ZZ3_DTIMP +";"
		cLin += QCRPA027->ZZ3_PEDGAR+";"
		cLin += QCRPA027->C5_NUM+";"
		cLin += QCRPA027->Z5_PRODGAR+";"
		cLin += QCRPA027->Z5_CODVOU+";"
		cLin += QCRPA027->ZF_DESTIPO+";"
		cLin += QCRPA027->ZZ3_LOG+";"
		cLin += Iif("VALIDACAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += Iif("VERIFICACAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += Iif("EMISSAO" $ QCRPA027->ZZ3_LOG, "X", "")+";"
		cLin += cEOL

		fWrite(nHdlLog,cLin)
		
		C063Conout(2, cLin)
	Endif
	QCRPA027->(DbSkip())
EndDo

//Fecho arquivo de log
fClose(nHdlLog)

QCRPA027->(dbCloseArea())

C063Conout("Abrindo envio de e-mail")

//Mando e-mail de com o log para o usuario
/*If MandEmail("Arquivo de Log de importa็๕es do dia " + DtoC(dDataBase),;
		   AllTrim(GetMV("MV_XLOGIMP")),;
		   "Log Importa็ใo Gar",;
		   cArqLog,"", "", "")*/
If MandEmail("Arquivo de Log de importa็๕es do dia " + DtoC(dDataBase),;
		   "yuri.volpe@certisign.com.br",;
		   "[TESTE] Log Importa็ใo Gar",;
		   cArqLog,"", "", "")

		   C063Conout("E-mail enviado com sucesso")
Else
	C063Conout( "Houve uma falha no disparo do e-mail")
EndIf

Return