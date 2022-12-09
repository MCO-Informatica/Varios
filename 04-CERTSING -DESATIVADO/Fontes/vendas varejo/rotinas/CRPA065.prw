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

User Function CRPA065(cEmpPar, cFilPar, dDataProc)


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
Local nModal	:= 0	// 1 = Arquivo, 2 = WebService Ativo, 3= WebService Passivo
Local cArqTxt	:= ""
Local nHdl		:= 0
Local cHrIni	:= ""
Local cHrFim	:= ""
Local aPedidos	:= {}
Local cChaveExe	:= "CRPA065" 

Private nReg	:= 0

DEFAULT cEmpPar		:= "01"
DEFAULT cFilPar		:= "02"
DEFAULT dDataProc	:= CTOD("//")

C065Conout("=========================================================================")
C065Conout("#==============      Rotina para importação de pedidos.    ==============")
C065Conout("=========================================================================")

C065Conout("Iniciando Processo")

cHrIni := Time()

If LoadEnv(cEmpPar, cFilPar)

	C065Conout("Carregando parâmetros")
	cDirIn := GetNewPar("MV_XCRP27D","\pedidosfaturados\GAR\")
	nModal := GetNewPar("MV_XCRP027",1)

	If Empty(dDataProc)
		dDataProc := dDataBase
	EndIf
	
	cChaveExe	+= DtoS(dDataProc)
	
	If LockByName(cChaveExe)
		C065Conout("Buscando Registros para Processamento")
		If BuscaRegs(dDataProc)
			C065Conout("Iniciando processamento dos registros")
			ProcRegs()	
		EndIf
		
		UnlockByName(cChaveExe)
	Else
		C065Conout("Já existe uma rotina em processamento. Aguarde seu término.")
	EndIf
		
Else
	
EndIf

cHrFim := Time()

C065Conout("Processo concluído! Hora início ["+cHrIni +"] Hora fim [" + cHrFim + "] Time Elapsed: [" + ElapTime(cHrIni,cHrFim) + "]")
C065Conout("Foram processados " + cValToCHar(nReg) + " registros.")

//RpcClearEnv()

Return

User Function CRP65Mail(cEmpPar, cFilPar, dDtProc)

Local nHdlLog	:= 0
Local cArqLog	:= ""
Local cDataSZ5	:= ""
Local aLog		:= {}
Local cHoraBase	:= GetMV("MV_XHRML65")
Local Ni		:= 0
Local Nx		:= 0
Local aRegistros:= {}

Default cEmpPar := "01"
Default cFilPar := "02"
Default dDtProc := CTOD("//")

If Time() <= cHoraBase
	C065Conout("[CRP065Mail] Rotina abortada. Programada para execução às 23:00:00")
	Return
EndIf

If LoadEnv(cEmpPar, cFilPar)
	
	If Empty(dDtProc)
		dDtProc := dDataBase
	Else
		dDtProc := Iif(Valtype(dDtProc) == "D" , dDtProc, Iif("/" $ dDtProc,CTOD(dDtProc),STOD(dDtProc)))
	EndIf
	
	cArqLog := "\pedidosfaturados\GAR\log"+DtoS(dDtProc)+StrTran(Time(),":","")+".csv"
	
	C065Conout("[CRP65Mail] Iniciando Query para disparo de E-mails")
	
	If Select("QCRPA027") > 0
		QCRPA027->(dbCloseArea())
	EndIf
	
	//Verifico tabela do log de importacao
	BeginSql Alias "QCRPA027"
	
		SELECT R_E_C_N_O_ NUMREG 		   
		FROM %Table:ZZ3% ZZ3
		WHERE
		ZZ3.D_E_L_E_T_ = ' '
		AND ZZ3_FILIAL = %xFilial:ZZ3%
		AND ZZ3_DTIMP = %Exp:DtoS(dDtProc)%
		AND ZZ3_MAIL = 'N'
		
	EndSql
	
	dbSelectArea("QCRPA027")
	
	dbSelectArea("SZ5")
	SZ5->(dbSetOrder(1))
	
	dbSelectArea("SC6")
	SC6->(dbOrderNickname("NUMPEDGAR"))
	
	dbSelectArea("SZF")
	SZF->(dbSetOrder(2))
	
	C065Conout("[CRP65Mail] Criando arquivo de Log")

	//Gravo dados no log
	While QCRPA027->(!EOF())
		
		ZZ3->(dbGoTo(QCRPA027->NUMREG))
		
		cPedido  := ""
		cProdGAR := ""
		cDtEmis	 := ""
		cDtVal	 := ""
		cDtVer	 := ""
		cCodVou	 := ""
		cDesVou	 := ""
		
		If SZ5->(dbSeek(xFilial("SZ5") + ZZ3->ZZ3_PEDGAR))
			cProdGAR := SZ5->Z5_PRODGAR
			dDtEmis	 := SZ5->Z5_DATEMIS
			dDtVal	 := SZ5->Z5_DATVAL
			dDtVer	 := SZ5->Z5_DATVER
			cCodVou	 := SZ5->Z5_CODVOU
			
			If SZF->(dbSeek(xFilial("SZF") + SZ5->Z5_CODVOU))
				If SZF->ZF_SALDO = 0
					cDesVou	 := SZF->ZF_DESTIPO
				EndIf
			EndIf
		EndIf
		
		If SC6->(dbSeek(xFilial("SC6") + ZZ3->ZZ3_PEDGAR))
			cPedido  := SC6->C6_NUM
		EndIF
			

		cLin := DtoC(ZZ3->ZZ3_DTIMP) 			+";"
		cLin += AllTrim(ZZ3->ZZ3_PEDGAR) 		+";"
		cLin += AllTrim(cPedido) 				+";"
		cLin += AllTrim(cProdGAR) 				+";"
		cLin += AllTrim(cCodVou) 				+";"
		cLin += AllTrim(cDesVou) 				+";"
		cLin += AllTrim(ZZ3->ZZ3_LOG)			+";"
		cLin += Iif(!Empty(dDtVal), "X", "")	+";"
		cLin += Iif(!Empty(dDtVer), "X", "")	+";"
		cLin += Iif(!Empty(dDtEmis), "X", "")	+";"
		cLin += cEOL
		
		aAdd(aLog, cLin)
		aAdd(aRegistros, QCRPA027->NUMREG)

		//C065Conout("[CRP65Mail] Skip de linha")
		QCRPA027->(dbSkip())
	EndDo

	If !File(cArqLog)
	
		nHdlLog  	:= fCreate(cArqLog)
		
		If nHdlLog != -1
			cLin := "Data Importação;Pedido Gar;Pedido Protheus;Produto Gar;Código Voucher;Tipo Voucher;Log Importação;Validado;Verificado;Emitido"+CHR(13)+CHR(10)
			fWrite(nHdlLog,cLin)
		Endif
		
	EndIf
	
	If nHdlLog != -1
		C065Conout("[CRP65Mail] Arquivo de Log criado. Iniciando iteracao para preenchimento.")
//		If QCRPA027->(!EoF())

		For Ni := 1 To Len(aLog)
			fWrite(nHdlLog,aLog[Ni])
			C065Conout("[CRP65Mail] Linha gravada no arquivo")
		Next 

		C065Conout("[CRP65Mail] Log criado corretamente.")
		
		//Fecho arquivo de log
		fClose(nHdlLog)
		
		C065Conout("[CRP65Mail] Disparando e-mail com registros processados.")
		
		//Mando e-mail de com o log para o usuario
		If MandEmail("Arquivo de Log de importações do dia " + DtoC(dDtProc),;
				   AllTrim(GetMV("MV_XLOGIMP")),;
				   "Log Importação Gar",;
				   cArqLog,"", "", "")
		
			C065Conout("[CRP65Mail] E-mail enviado com sucesso")
			
			For Nx := 1 To Len(aRegistros)
				ZZ3->(dbGoTo(aRegistros[Nx]))
				RecLock("ZZ3",.F.)
					ZZ3->ZZ3_MAIL := "S"
				ZZ3->(MsUnlock())
				
				QCRPA027->(dbSkip())
			Next
			
		Else
			C065Conout("[CRP65Mail] Houve uma falha no disparo do e-mail")
		EndIf
			
		C065Conout("[CRP65Mail] Encerrando rotina")

	Else
		C065Conout("[CRP65Mail] Não foi possível criar o arquivo de log para envio. Nenhum registro foi processado na data " + DTOC(dDtProc))
		MandEmail("Não foi possível criar o arquivo de log para envio. Nenhum registro foi processado na data " + DTOC(dDtProc),;
				   AllTrim(GetMV("MV_XLOGIMP")),;
				   "Log Importação Gar",,"", "", "")
	EndIf
	
	If !IsInCallStack("U_CRPA065Dt")
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
	C065Conout("Falha no envio de e-mail:" + cErro)
EndIf

Return(lRet)

/*/{Protheus.doc} LoadEnv
//TODO Descrição auto-gerada.
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

C065Conout("Carregando ambiente")

If Type("cFilAnt") == "U" .And. Type("cEmpAnt") == "U"
	RpcClearEnv()
	RpcSetType(3)
	lLoadOk := RpcSetEnv(cEmpPar,cFilPar)
Else
	lLoadOk := .T.	
EndIf

Return lLoadOk

/*/{Protheus.doc} BuscaRegs
Função estática responsável por localizar pedidos que ainda não foram integrados na tabela SZ5.
@author yuri.volpe
@since 20/12/2019
@version 1.0
@return lEOF, Indica se a query retornou resultados
@param dData, date, Data do arquivo em que os pedidos foram gerados
@type function
/*/
Static Function BuscaRegs(dData)

If Select("TBLPED") > 0
	TBLPED->(dbCloseArea())
EndIf

Beginsql Alias "TBLPED"

	SELECT MAX(ZZ3_PEDGAR) PEDIDO, R_E_C_N_O_ RECNO
	FROM %Table:ZZ3% ZZ3
	WHERE ZZ3.ZZ3_IMPOK = 'N'
	AND ZZ3.ZZ3_DATA = ' '
	AND ZZ3.ZZ3_DTIMP = %Exp:DTOS(dData)%
	AND ZZ3.ZZ3_DTIMP > '20200101'
	AND ZZ3.%Notdel% 
	GROUP BY ZZ3_PEDGAR, R_E_C_N_O_

Endsql

Return TBLPED->(!EOF()) 

/*/{Protheus.doc} ProcRegs
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 20/12/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function ProcRegs()

Local cPedido	:= ""
Local nRecnoZZ3	:= 0
Local lDebug	:= .F.

dbSelectArea("SZ5")
SZ5->(dbSetOrder(1))

dbSelectArea("ZZ3")
ZZ3->(dbSetOrder(2))

While TBLPED->(!EoF())

	cPedido 	:= TBLPED->PEDIDO
	nRecnoZZ3 	:= TBLPED->RECNO
	
	//If SZ5->(!dbSeek(xFilial("SZ5") + cPedido))

		C065Conout("Consultando pedido " + cPedido)
		
		nReg++
		
		If lDebug
			U_CRPA065W(cPedido, nRecnoZZ3)
		Else 
			If !U_Send2Proc(cPedido,"U_CRPA065W",cPedido, nRecnoZZ3)
				C065Conout("Send2Proc não foi executado corretamente.")
			EndIf		
		EndIf

		C065Conout("Sleeping 1sec")
		Sleep(250)
		
		C065Conout("Atualização do pedido " + cPedido + " finalizada.")
		
	//EndIf
	
	TBLPED->(dbSkip())
	
EndDo

C065Conout("Iteração encerrada.")

Return

User Function CRPA065W(cPedido, nRecnoZZ3)

Local cLog 		:= ""
Local nTam 		:= 500
Local lTemCamp	:= " "
Local lRecalc	:= .F.
Local oObj		:= Nil
Local cLogMemo	:= ""
Local cDescST	:= ""
Local cComiss	:= ""
Local cPedGAnt	:= ""
Local cProdGAR	:= ""
Local cProduto	:= ""
Local cDesProd	:= ""
Local cCNPJ		:= ""
Local cCNPJCer	:= ""
Local cCNPJVer	:= 0
Local cCodPar	:= ""
Local cStatus	:= ""
Local cBlqVen	:= ""
Local cNomPar	:= ""
Local cDescAC	:= ""
Local cDescARP	:= ""
Local cCodARP	:= ""
Local cDescAR	:= ""
Local cCodAR	:= ""
Local dDatPed	:= CTOD("//")
Local cGrupo	:= ""
Local cDesGru	:= ""
Local cDesPos	:= ""
Local cCodPos	:= ""
Local cPosVer	:= ""
Local dDtEmis	:= CTOD("//")
Local dDtVali	:= CTOD("//")
Local dDtVeri	:= CTOD("//")
Local cRede		:= ""
Local cCodVend	:= ""
Local cNomVend	:= ""
Local nComHW	:= 0
Local nComSW	:= 0
Local cDesRede	:= ""
Local cCPFAgente:= ""
Local cAgVer	:= ""
Local cCPFT		:= ""
Local cEmailT	:= ""
Local cNomAge	:= ""
Local cNomAgVer	:= ""
Local cNomTit	:= ""
Local cRSValid	:= ""
Local cFlag		:= ""
Local cComiss	:= ""
Local cTipo		:= ""
Local nPerCCR	:= 0
Local cCodRD	:= ""
Local lUpdZZ3	:= .T.
			
//Renato Ruy - 21/03/17
//Criacao de semaforo para evitar a duplicidade 
sleep(Randomize( 1, 1000 ))

If !LockByName("CRPA065W"+cPedido)
	C065Conout("[CRPA027B] - Pedido: "+ cCodPed +" ja esta em processamento!")
	return
Endif

C065Conout("Iniciando consulta no GAR pedido " + cPedido)

dbSelectArea("ZZ3")
ZZ3->(dbSetOrder(2))
If ZZ3->(dbSeek(xFilial("ZZ3") + cPedido))
	nPerCCR := ZZ3->ZZ3_PERCCR
	cCodRD	:= ZZ3->ZZ3_CODRD
EndIf

	// Busca os dados do pedido de GAR para atualizar o movimento
	C065Conout("Realizando conexão com WebService")
	oWSObj := WSIntegracaoGARERPImplService():New()
	IF oWSObj:findDadosPedido("erp","password123",Val(cPedido))
	
		C065Conout("WebService conectado")
		C065Conout("Atualizando dados a partir do WS")
		//Se o pedido é novo, gravo codigo do pedido gar
		//SZ5->Z5_PEDGAR := cPedido
		cLog := "| PEDIDO INCLUIDO "

		//Pedido GAR Anterior
		cPedGAnt := Iif(ValType(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO) <> "U",AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO)),"")

		//Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTO) <> "U"
			lRecalc := AllTrim(SZ5->Z5_PRODGAR) <> AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTO)
			cProdGAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTO)
			cProduto := Iif(Empty(SZ5->Z5_PRODUTO),GetAdvFval('PA8','PA8_CODMP8',XFILIAL('PA8')+ALLTRIM(SZ5->Z5_PRODGAR), 1,''), SZ5->Z5_PRODUTO)
		EndIf

		//DECRICAO do Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC) <> "U"
			cDesPro := AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC)
		EndIf

		//CNPJ do Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:NCNPJCERT) <> "U"
			cCNPJ 	 := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT))
			cCNPJCer := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT))
			cCNPJVer := oWSObj:OWSDADOSPEDIDO:NCNPJCERT
		EndIf

		//Codigo do Parceiro
		If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO) <> "U"
			lRecalc := SZ5->Z5_CODPAR <> AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO))
			cCodPar := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO))
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:cStatus) <> "U"
			cStatus := AllTrim(oWSObj:OWSDADOSPEDIDO:cStatus)
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:nstatusRevendedor) <> "U"
			cBlqVen := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:nstatusRevendedor))
		EndIf

		//Codigo do Parceiro
		If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO) <> "U"
			lRecalc := AllTrim(SZ5->Z5_NOMPAR) <> AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO)
			cNomPar := AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO)
		EndIf

		//Descricao AC do Pedido
		If ValType(oWSObj:OWSDADOSPEDIDO:CACDESC) <> "U"
			cDescAC	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CACDESC)
		EndIf

		//Descricao AR de Pedido
		If ValType(oWSObj:OWSDADOSPEDIDO:CARDESC) <> "U"
			cDescARP := AllTrim(oWSObj:OWSDADOSPEDIDO:CARDESC)
		EndIf

		//Codigo AR de Pedido
		If ValType(oWSObj:OWSDADOSPEDIDO:CARID) <> "U"
			cCodARP := AllTrim(oWSObj:OWSDADOSPEDIDO:CARID)
		EndIf

		//Deve ser a AR de VERIFICACAO
		//Descricao AR de Validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC) <> "U"
			cDescAR	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC)
		EndIf

		//Deve ser a AR de VERIFICACAO
		//Codigo AR de Validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO) <> "U"
			cCodAR := AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO)
		EndIf

		//Data de Emissao do Pedido GAR
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO) <> "U"
			lRecalc  := Empty(SZ5->Z5_DATPED)
			dDatPed := Iif(Empty(SZ5->Z5_DATPED),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO),1,10)),SZ5->Z5_DATPED)
		Else
			cLogMemo += "Pedido sem Data de Emissão no WebService" + cEOL
		EndIf

		//Grupo
		If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPO) <> "U"
			cGrupo := AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPO)
		EndIf

		//Descricao do Grupo
		If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO) <> "U"
			cDesGru := AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO)
		EndIf

		//Deve ser o Posto de VERIFICACAO
		//Descricao do Posto de Validaï¿½ï¿½o
		If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC) <> "U"
			cDesPos	:= Iif(Empty(SZ5->Z5_DESPOS),AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC),SZ5->Z5_DESPOS)
		EndIf

		//Deve ser o Posto de VERIFICACAO
		//Codigo do posto de validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID) <> "U"
			cCodPos	:= Iif(Empty(SZ5->Z5_CODPOS) .Or. Empty(SZ5->Z5_DATVER),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID)),SZ5->Z5_CODPOS)
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID) <> "U"
			cPosVer	:= Iif(Empty(SZ5->Z5_DATVER),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID)),SZ5->Z5_POSVER)
		EndIf
		
		//Data de Emissao do Pedido GAR
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO) <> "U"
			cLog += Iif(empty(SZ5->Z5_DATEMIS),"| EMISSAO ","")
			dDtEmis := CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO),1,10))
		EndIf
		
		//Data da Validacao
		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO) <> "U" .And. (Empty(SZ5->Z5_PEDGANT) .OR. !Empty(SZ5->Z5_DATEMIS))
			If !Empty(SZ5->Z5_DATEMIS) .OR. EMPTY(SZ5->Z5_PEDGANT)
				cLog += Iif(empty(SZ5->Z5_DATVAL),"| VALIDACAO ","")
				dDtVali := Iif(Empty(SZ5->Z5_DATVAL),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO),1,10)),SZ5->Z5_DATVAL)
			Endif
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO) <> "U" .And. (Empty(SZ5->Z5_PEDGANT) .OR. !Empty(SZ5->Z5_DATEMIS))
			If !Empty(SZ5->Z5_DATEMIS) .OR. EMPTY(SZ5->Z5_PEDGANT)
				cLog += Iif(empty(SZ5->Z5_DATVER),"| VERIFICACAO ","")
				dDtVeri := Iif(Empty(SZ5->Z5_DATVER),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO),1,10)),SZ5->Z5_DATVER)
			Endif
		EndIf

		//Rede
		If ValType(oWSObj:OWSDADOSPEDIDO:CREDE) <> "U"
			cRede	:= Iif(Empty(SZ5->Z5_REDE),AllTrim(oWSObj:OWSDADOSPEDIDO:CREDE),SZ5->Z5_REDE)
		EndIf

		//Codigo do Revendedor
		If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR) <> "U"
			lRecalc := AllTrim(SZ5->Z5_CODVEND) <> AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR))
			cCodVend := AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR))
		EndIf

		//Nome do revendedor
		If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR) <> "U" 
			lRecalc := AllTrim(SZ5->Z5_NOMVEND) <> AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR)
			cNomVend := AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR)
		EndIf

		//Comissão hardware do parceiro
		If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW) <> "U"
			nComHW := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW
		EndIf

		//Comissão software do parceiro
		If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> "U"
			If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> "N"
				lRecalc := Val(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> SZ5->Z5_COMSW .And. SZ5->Z5_PROCRET != "M"
			Else
				lRecalc := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW <> SZ5->Z5_COMSW .And. SZ5->Z5_PROCRET != "M"
			EndIf
			nComSW := Iif(SZ5->Z5_PROCRET != "M",oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW, SZ5->Z5_COMSW)
			nComSW := Iif(SZ5->Z5_COMSW==0 .And. nPerCCR > 0,nPerCCR,SZ5->Z5_COMSW)
		EndIf

		//Descrição da Rede do Parceiro e se faz parte de campanha.
		If ValType(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro) <> "U"
			lRecalc  := AllTrim(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro) <> AllTrim(SZ5->Z5_DESREDE)
			cDesRede := AllTrim(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro)
		Else
			cLogMemo += "Pedido sem Campanha no WebService." + cEOL
		EndIf

		//Definicao do tipo de movimento de remuneracao de parceiros

		//Mudara para agende de verificação
		//CPF do Agente de Validacao
		//Nome do Agente de Validaï¿½ï¿½o
		If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO) <> "U"
			cNomAge	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO)
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO) <> "U"
			cNomAgVer	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO)
		EndIf

		//Nome do Titular do Certificado
		If ValType(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR) <> "U"
			cNomTit	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR)
		EndIf

		If ValType(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT) <> "U"
			cRSValid	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT)
		EndIf

		If !Empty(dDtEmis)
			cFlag := "E"
		ElseIf !Empty(dDtVeri)
			cFlag := "A"
		EndIf
		
		cComiss := Iif(lRecalc, " ", SZ5->Z5_COMISS)

		If !Empty(dDtEmis) .And. !Empty(cPedGAnt)
			cTipo := "EMISSA"
		ElseIf !Empty(dDtVeri) .And. Empty(cPedGAnt)
			cTipo = "VERIFI"
		ElseIf Empty(cPedido)
			cTipo = "ENTHAR"
		Else
			cTipo = "VALIDA"
		EndIf
		
		//Renato Ruy - 19/08/16
		//Cria regra para zerar o controle de faixas
		If cBlqVen = '1' .And. nComSW > 0 .And. !Empty(cDescST) .And. ("CAMPANHA" $ Upper(cDesRede) .Or. "CLUBE" $ Upper(cDesRede))
			
			lTemCamp := CRPA027F()
			//ConOut("== Apaga controle de faixas -- > " + SZ5->Z5_PEDGAR + " ==")
			cLogMemo += "Apaga controle de faixas" + cEOL
			
			//Zera para não contar e solicita uma nova contagem.
			cDescST := Iif(lTemCamp, " ", SZ5->Z5_DESCST)
			cComiss := Iif(lTemCamp, " ", SZ5->Z5_DESCST)
		Endif

		C065Conout("Atualização do WS encerrada.")
		C065Conout("Gravando dados na SZ5")

		dbSelectArea("SZ5")
		SZ5->(dbSetOrder(1))
		lNovo := SZ5->(!dbSeek(xFilial("SZ5") + cPedido))
			
		RecLock("SZ5", lNovo)
			SZ5->Z5_PEDGAR	:= cPedido
			SZ5->Z5_DESCST	:= cDescST
			SZ5->Z5_COMISS	:= cComiss
			SZ5->Z5_ROTINA	:= "CRPA065"
			SZ5->Z5_PEDGANT	:= cPedGAnt
			SZ5->Z5_PRODGAR := cProdGAR
			SZ5->Z5_PRODUTO := cProduto
			SZ5->Z5_DESPRO 	:= cDesProd
			SZ5->Z5_CNPJ 	:= cCNPJ
			SZ5->Z5_CNPJCER := cCNPJCer
			SZ5->Z5_CNPJV	:= cCNPJVer
			SZ5->Z5_CODPAR 	:= cCodPar
			SZ5->Z5_STATUS 	:= cStatus
			SZ5->Z5_BLQVEN 	:= cBlqVen
			SZ5->Z5_NOMPAR 	:= cNomPar
			SZ5->Z5_DESCAC	:= cDescAC
			SZ5->Z5_DESCARP	:= cDescARP
			SZ5->Z5_CODARP 	:= cCodARP
			SZ5->Z5_DESCAR	:= cDescAR
			SZ5->Z5_CODAR 	:= cCodAR
			SZ5->Z5_DATPED 	:= dDatPed
			SZ5->Z5_GRUPO 	:= cGrupo
			SZ5->Z5_DESGRU 	:= cDesGru
			SZ5->Z5_DESPOS	:= cDesPos
			SZ5->Z5_CODPOS	:= cCodPos
			SZ5->Z5_POSVER	:= cPosVer
			SZ5->Z5_DATEMIS := dDtEmis
			SZ5->Z5_DATVAL 	:= dDtVali
			SZ5->Z5_DATVER 	:= dDtVeri
			SZ5->Z5_REDE	:= cRede
			SZ5->Z5_CODVEND := cCodVend
			SZ5->Z5_NOMVEND := cNomVend
			SZ5->Z5_COMHW 	:= nComHW
			SZ5->Z5_COMSW	:= nComSW
			SZ5->Z5_DESREDE := cDesRede
			SZ5->Z5_CPFAGE	:= cCPFAgente
			SZ5->Z5_AGVER	:= cAgVer
			SZ5->Z5_CPFT 	:= cCPFT
			SZ5->Z5_EMAIL 	:= cEmailT
			SZ5->Z5_NOMAGE	:= cNomAge
			SZ5->Z5_NOAGVER	:= cNomAgVer
			SZ5->Z5_NTITULA	:= cNomTit
			SZ5->Z5_RSVALID	:= cRSValid
			SZ5->Z5_FLAGA 	:= cFlag
			SZ5->Z5_COMISS 	:= cComiss
			SZ5->Z5_TIPO 	:= cTipo
			SZ5->Z5_CODRD 	:= AllTrim(cCodRD)
		SZ5->(MsUnlock())

		C065Conout("Encerrada atualização da SZ5")
	
		//Gravo Log
		//Parametros MSMM
		// 1 = Grava
		// 2 = Exclui
		// 3 = Faz leitura
	
		/*dbSelectArea("ZZ3")
		ZZ3->(DbSetOrder(2))
		lUpdZZ3 := !ZZ3->(DbSeek(xFilial("ZZ3")+cPedido))

		ZZ3->(dbGoTo(nRecnoZZ3))*/
		
		C065Conout("Localizado registro ZZ3: " + cValToChar(!lUpdZZ3) + " Recno: " + cValToChar(nRecnoZZ3))
		C065Conout("Atualizando registro na ZZ3")
		
		If Reclock("ZZ3",.F.)
			ZZ3->ZZ3_FILIAL 	:= xFilial("ZZ3")
			ZZ3->ZZ3_DTIMP 		:= dDataBase
			ZZ3->ZZ3_PEDGAR 	:= cPedido
			ZZ3->ZZ3_LOG    	:= AllTrim(ZZ3->ZZ3_LOG) + Iif(!Empty(cLog),SubStr(cLog,1,80),"") + "| WS Importado"
			ZZ3->ZZ3_XMLWS		:= FwJsonSerialize(oWSObj:OWSDADOSPEDIDO,.F.,.F.)
			ZZ3->ZZ3_IMPOK		:= "S"
			ZZ3->ZZ3_LOGMEM		:= ZZ3->ZZ3_LOGMEM + cEOL + "[" + DTOC(Date()) + " - " + Time() +"]: Dados Importados do WebService"
			ZZ3->ZZ3_DATA		:= dDataBase
			ZZ3->ZZ3_HORA		:= Time()
			ZZ3->ZZ3_PERCCR		:= nPerCCR
			ZZ3->ZZ3_CODRD		:= cCodRD
			ZZ3->(MsUnlock())
		EndIf
		
		C065Conout("Atualizando valores do pedido - ATUVALZ5")
		U_AtuValZ5(PADR(AllTrim(cPedido),10," "), "2")
		
	Else
		C065Conout("CRPA065W - Erro ao conectar com WS IntegracaoERP. Pedido GAR " + Alltrim(SZ5->Z5_PEDGAR) + " não atualizado")

		ZZ3->(DbSetOrder(2))
		lUpdZZ3 := !ZZ3->(DbSeek(xFilial("ZZ3")+cPedido))
		
		If ZZ3->(Reclock("ZZ3",lUpdZZ3))
			ZZ3->ZZ3_FILIAL 	:= xFilial("ZZ3")
			ZZ3->ZZ3_DTIMP 		:= dDataBase
			ZZ3->ZZ3_PEDGAR 	:= SZ5->Z5_PEDGAR
			ZZ3->ZZ3_LOG    	:= "CRPA027 - Erro ao conectar com WS IntegracaoERP."
			ZZ3->(MsUnlock())
		EndIf
	Endif
	
DelClassIntF()

C065Conout("Encerramento da rotina CRPA065W - UnlockByName")
UnLockByName("CRPA065W"+cPedido)

Return

Static Function C065Conout(cMsg, cAdicional)

DEFAULT cAdicional := ""

conout("[CRPA065 ["+cValToChar(ThreadId())+"] - "+DTOC(Date()) + " - " + Time() +"]: " + cAdicional + cMsg)

Return

User Function CRPA065Dt(cDataDe, cDataAte)

Local oDlg
Local oSDataDe
Local oSDataAte
Local oGDataDe
Local oGDataAte
Local oCbCalcula
Local oBtCancel
Local oFont
Local oBtOK
Local dDataDe 		:= CTOD("//")
Local dDataAte 		:= CTOD("//")
Local lHasButton 	:= .T.
Local bValida		:= Nil
Local lCancela		:= .F.
Local lCalcula		:= .F.

Default cDataDe := ""
Default cDataAte := ""

oFont := TFont():New('Courier new',,-18,.T.)

Set(_SET_DATEFORMAT, 'dd/mm/yyyy')

If Empty(cDataDe)
	oDlg := TDialog():New(180,180,325,400,"Exemplo TDialog",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSDataDe:= TSay():New(12,05,{||'Data De:'},oDlg,,,,,,.T.,,,200,20)
	oSDataAte:= TSay():New(32,05,{||'Data Até:'},oDlg,,,,,,.T.,,,200,20)
	
	oGDataDe := TGet():New( 10, 40, { | u | If( PCount() == 0, dDataDe, dDataDe := u ) },oDlg,060, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,{|| Iif(Empty(dDataAte),dDataAte:=dDataDe,Nil),oGDataAte:CtrlRefresh()},.F.,.F. ,,"dDataDe",,,,lHasButton  )
	oGDataAte := TGet():New( 30, 40, { | u | If( PCount() == 0, dDataAte, dDataAte := u ) },oDlg,060, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDataAte",,,,lHasButton  )
			
	oBtOK := TButton():New( 60, 10, "Ok",oDlg,{|| oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	oBtCancel := TButton():New( 60, 60, "Cancela",oDlg,{|| lCancela:=.T., oDlg:End()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	
	oCBCalcula := TCheckBox():New(45,15,'Calcula ao final?',{| u | If( PCount() == 0, lCalcula, lCalcula := !lCalcula )},oDlg,100,210,,,,,,,,.T.,,,)
	
	bValida := {|| C65DlgVld(oDlg:nResult, @lCancela, @dDataDe, @dDataAte)}
	oDlg:Activate(,,,.T.,bValida,,{|| /*msgstop("Iniciando") */})
	
	cDataDe := DTOC(dDataDe)
	cDataAte := Iif(Empty(dDataAte),cDataDe,DToC(dDataAte))
	 
EndIf

If lCancela 
	Alert("Rotina cancelada.")
	Return
EndIf

dDataDe := Iif(("/" $ cDataDe), CTOD(cDataDe), STOD(cDataDe))
dDataAte := Iif(("/" $ cDataAte), CTOD(cDataAte), STOD(cDataAte))

Processa({|| C65Loop(dDataDe, dDataAte, lCalcula)},"Processando","Processando as datas informadas",.F.)

Return

Static function C65Loop(dDataDe, dDataAte, lCalcula)

Local nDifData := 0

nDifData := DateDiffDay(dDataDe, dDataAte)
ProcRegua(nDifData)

While dDataDe <= dDataAte
	
	IncProc(DTOC(dDataDe))
	ProcessMessage()

	U_CRPA065("01", "02", dDataDe, lCalcula)
	
	U_CRP65Mail("01", "02", dDataDe)
	
	If lCalcula
		U_CRP065CALC("01", "02", dDataDe)
	EndIf
	
	dDataDe := dDataDe + 1
EndDo

Return

Static Function C65DlgVld(nResult, lCancela, dDataDe, dDataAte)

Local lRet := .T.

If nResult == 2
	lCancela := .T.
	lRet := .T.
EndIf

Return lRet

User Function CRP065CALC(cEmpPar, cFilPar, dDtProc)

Local dDataIni	:= CTOD("//") 
Local dDataFim	:= CTOD("//")
Local cHrIni	:= ""
Local cHrFim	:= ""
Local aPedidos	:= {}
Local aUsers	:= {}
Local nContador := 0
Local nThread	:= 0

Default cEmpPar := "01"
Default cFilPar := "02"
Default dDtProc := CTOD("//")

//Executar query para verificar quais pedidos calcular. A partir da SZ5 e na data do Processamento?
//Laço While EOF para chamar Send2Proc do calculo

C065Conout("=========================================================================")
C065Conout("#==============      Rotina para cálculo de pedidos.       ==============")
C065Conout("=========================================================================")

C065Conout("Iniciando Processo","[CALCULO] ")

cHrIni := Time()

If LoadEnv(cEmpPar, cFilPar)

	If Empty(dDtProc)
		dDtProc := dDataBase
	EndIf
	
	dDataIni := CTOD("01/" + StrZero(Month(dDtProc),2) + "/" + cValToChar(Year(dDtProc)))
	dDataFim := CTOD(StrZero(Day(LastDay(dDtProc)),2) + "/" + StrZero(Month(dDtProc),2) + "/" + cValToChar(Year(dDtProc)))
	
	If Select("TMPCAL") > 0
		TMPCAL->(dbCloseArea())
	EndIf

	C065Conout("Iniciando Query para pedidos que devem ser calculados","[CALCULO] ")
	BeginSql Alias "TMPCAL"	
	
		SELECT * FROM (
		SELECT 	SZ5.R_E_C_N_O_, 
				SZ5.Z5_PEDSITE PEDIDO_SITE, 
				SZ5.Z5_PEDGAR PEDIDO_GAR, 
				SZ5.Z5_PRODGAR PROD_GAR, 
				CASE WHEN Z5_PEDSITE > ' ' THEN Z5_EMISSAO WHEN Z5_PEDGANT = ' ' THEN Z5_DATVER ELSE Z5_DATEMIS END DATA_PEDIDO , 
				'ENTHAR'  AS TIPO
		FROM %Table:SZ5% SZ5 
		LEFT JOIN %Table:SZ3% SZ3 
		ON SZ3.Z3_FILIAL = %xFilial:SZ3% AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel%
		WHERE  
		SZ5.Z5_FILIAL = %xFilial:SZ5%  
		AND SZ5.Z5_EMISSAO BETWEEN %Exp:dDataIni% AND %Exp:dDataFim% 
		AND Z5_TIPO='ENTHAR'  
		AND SZ5.Z5_COMISS != '2' 
		AND SZ5.%NotDel%
		UNION 
		SELECT 	SZ5.R_E_C_N_O_, 
				SZ5.Z5_PEDSITE PEDIDO_SITE, 
				SZ5.Z5_PEDGAR PEDIDO_GAR,
				SZ5.Z5_PRODGAR PROD_GAR, 
				CASE WHEN Z5_PEDSITE > ' ' THEN Z5_EMISSAO WHEN Z5_PEDGANT = ' ' THEN Z5_DATVER ELSE Z5_DATEMIS END DATA_PEDIDO , 
				'VERIFI'  AS TIPO
		FROM %Table:SZ5% SZ5                                     
		LEFT JOIN %Table:SZ3% SZ3 
		ON SZ3.Z3_FILIAL = %xFilial:SZ3% AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel%
		WHERE 
		SZ5.Z5_FILIAL = %xFilial:SZ5%
		AND SZ5.Z5_DATVER  BETWEEN %Exp:dDataIni% AND %Exp:dDataFim%  
		AND SZ5.z5_tipo in (' ','VALIDA','VERIFI','EMISSA')
		AND SZ5.Z5_COMISS != '2'  
		AND SZ5.Z5_PEDGANT=' '  
		AND SZ5.%NotDel% 
		UNION 
		SELECT 	SZ5.R_E_C_N_O_, 
				SZ5.Z5_PEDSITE PEDIDO_SITE, 
				SZ5.Z5_PEDGAR PEDIDO_GAR, 
				SZ5.Z5_PRODGAR PROD_GAR,
				CASE WHEN Z5_PEDSITE > ' ' THEN Z5_EMISSAO WHEN Z5_PEDGANT = ' ' THEN Z5_DATVER ELSE Z5_DATEMIS END DATA_PEDIDO , 
				'RENOVA'  AS TIPO
		FROM %Table:SZ5% SZ5 
		LEFT JOIN %Table:SZ3% SZ3 
		ON SZ3.Z3_FILIAL = %xFilial:SZ3% AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel% 
		WHERE 
		SZ5.Z5_FILIAL = %xFilial:SZ5% 
		AND SZ5.Z5_DATEMIS  BETWEEN %Exp:dDataIni% AND %Exp:dDataFim% 
		AND SZ5.Z5_TIPO = 'EMISSA' 
		AND SZ5.Z5_COMISS != '2' 
		AND SZ5.Z5_PEDGANT>'0' 
		AND SZ5.%NotDel%
		) ORDER BY DATA_PEDIDO
	EndSql
	
	TMPCAL->(DbGoTop())
	
	C065Conout("Query Executada","[CALCULO] ")
	//envia para processamento
	If TMPCAL->(!EOF())
	
		C065Conout("Iniciando processamento dos pedidos selecionados","[CALCULO] ")
	 
		/*While TMPCAL->( !Eof() )
				
			If !Empty(TMPCAL->R_E_C_N_O_) .And. TMPCAL->DATA_PEDIDO > getmv("MV_REMMES")
				
				C065Conout("Iniciando calculo do pedido no Recno " + cValToChar(TMPCAL->R_E_C_N_O_),"[CALCULO] ")				
				
				Aadd(aPedidos,{TMPCAL->R_E_C_N_O_,SubStr(TMPCAL->DATA_PEDIDO,1,6)})
				nContador += 1
			Else
				C065Conout("Pedido no Recno " + cValToChar(TMPCAL->R_E_C_N_O_) + " ignorado por não atender às condições de cálculo.","[CALCULO] ")
			EndIf
				
			//Pulo para a próxima linha.
			TMPCAL->(DbSkip())
			
		EndDo
			
		If !U_Send2Proc("CRPA065" + DTOS(Date()) + StrTran(Time(),":",""), "U_CRPA020B", "", aPedidos,"CRPA065","CRPA065-JOB")																			
			C065Conout("Não foi possível calcular o pedido no Recno " + cValToChar(TMPCAL->R_E_C_N_O_),"[CALCULO] ")
		EndIf*/
		
		While TMPCAL->( !Eof() )
		
			//Faz distribuição e monitora a quantidade de thread em execução
			nThread := 0
			aUsers 	:= Getuserinfoarray()
			aEval(aUsers,{|x| IIF( ALLTRIM(UPPER(x[5])) == "U_CRP065CALC",nThread++,nil )  })
			
			//Limita a quantidade de Threads.
			If nThread < 10
			 	
			 	nContador := 0
				aPedidos  := {}
				
				While TMPCAL->( !Eof() ) .And. nContador <= 100
						
					If !Empty(TMPCAL->R_E_C_N_O_) .And. Substr(TMPCAL->DATA_PEDIDO,1,6) > getmv("MV_REMMES")
						
						C065Conout("Incluindo pedido no array. Recno: " + cValToChar(TMPCAL->R_E_C_N_O_),"[CALCULO] ")					
						
						Aadd(aPedidos,{TMPCAL->R_E_C_N_O_,SubStr(TMPCAL->DATA_PEDIDO,1,6)})
						nContador += 1
					Else
						C065Conout("Pedido no Recno " + cValToChar(TMPCAL->R_E_C_N_O_) + " ignorado por não atender às condições de cálculo.","[CALCULO] ")
					EndIf
						
					//Pulo para a próxima linha.
					TMPCAL->(DbSkip())
					
				EndDo
							
				//Envio o conteúdo para Thread se o array for maior que um
				If Len(aPedidos) > 0
					C065Conout("Enviando lote de "+cValToChar(nContador)+" pedidos para calculo","[CALCULO] ")
					If !U_Send2Proc("CRPA065" + DTOS(Date()) + StrTran(Time(),":",""), "U_CRPA020B", "", aPedidos,"CRPA065","CRPA065-JOB")																			
						C065Conout("Não foi possível calcular o pedido no Recno " + cValToChar(TMPCAL->R_E_C_N_O_),"[CALCULO] ")
					EndIf
				EndIf
				
			EndIf 
			
			//Gerou erro ao fazer varias vezes a consulta da thread - Getuserinfoarray.
			If nThread >= 10
				Sleep( 5000 )	
			EndIf
			
		EndDo		
			
	Else
		C065Conout("Não há registros disponiveis para calculo.","[CALCULO] ")
	EndIf
	
	TMPCAL->( DbCloseArea() )

EndIf

Return

User Function CRP065Fx(cEmpPar, cFilPar, cPeriodo)

Local lNovo 	:= .F.
Local cCampo	:= ""
Local cCodFx	:= ""
Local nTotal	:= 0
Local nContBR 	:= 0
Local nConNOT 	:= 0
Local nConSIN 	:= 0
Local nConSINR 	:= 0
Local dDataFim	:= CTOD("//")

DEFAULT cEmpPar 	:= "01"
DEFAULT cFilPar		:= "02"
DEFAULT cPeriodo 	:= Substr(DTOS(LASTDAY(DDATABASE,1) - 30),1,6) //Primeiro dia útil do mês corrente, menos 30 dias para obter o período anterior

If LoadEnv(cEmpPar, cFilPar)

	dDataFim := LASTDAY(DDATABASE,1) - 30

	If Select("TMPFX") > 0
		DbSelectArea("TMPFX")
		TMPFX->(DbCloseArea())
	EndIf
	
	//Renato Ruy - 04/10/16
	//Atualiza contador de faixa.
	//Separa pedidos da AC para geração da faixa.
	BeginSql Alias "TMPFX"
	
		SELECT * FROM
		(SELECT  Z5_PEDGAR PEDGAR,
		        Z5_DATVER DATA,
		        Z5_PRODGAR PRODUTO,
		        Z5_COMSW,
		        Z5_BLQVEN,
		        Z5_DESREDE,
		        CASE
		        WHEN Z5_PRODGAR LIKE '%REG%' THEN 'BR'
		        WHEN Z5_PRODGAR LIKE '%SINRJ%' THEN 'SINRJ'
		        WHEN Z5_PRODGAR LIKE '%SIN%' THEN 'SIN'
		        WHEN Z5_PRODGAR LIKE '%FENACOR%' THEN 'FENCR'
		        END REDE,
		        R_E_C_N_O_ RECNOZ5
		 FROM %Table:SZ5% SZ5 
		 WHERE 
		 Z5_FILIAL = %xFilial:SZ5% 
		 AND Z5_DATVER BETWEEN %Exp:cPeriodo+"01"% AND %Exp:dDataFim% 
		 AND (Z5_PRODGAR LIKE '%REG%' OR Z5_PRODGAR LIKE '%SIN%' OR Z5_PRODGAR LIKE '%FENANCOR%') 
		 AND Z5_PRODGAR NOT LIKE '%18%'
		 AND Z5_PRODGAR NOT LIKE '%SERVER%'
		 AND (Z5_COMSW <= 0 Or Z5_BLQVEN = '0' Or 
		 	  (UPPER(Z5_DESREDE) NOT LIKE '%BR%' AND 
		 	   UPPER(Z5_DESREDE) NOT LIKE '%NOT%' AND 
		  	   UPPER(Z5_DESREDE) NOT LIKE '%BR CRED%') 
		 	  OR Z5_DESREDE LIKE '%CLUBE DO REVENDEDOR%')
		 AND Z5_PEDGANT = ' '
		 AND SZ5.%NotDel%
		 UNION
		 SELECT  Z5_PEDGAR PEDGAR,
		        Z5_DATEMIS DATA,
		        Z5_PRODGAR PRODUTO,
		        Z5_COMSW,
		        Z5_BLQVEN,
		        Z5_DESREDE,
		        CASE
		        WHEN Z5_PRODGAR LIKE '%REG%' THEN 'BR'
		        WHEN Z5_PRODGAR LIKE '%SINRJ%' THEN 'SINRJ'
		        WHEN Z5_PRODGAR LIKE '%SIN%' THEN 'SIN'
		        WHEN Z5_PRODGAR LIKE '%FENACOR%' THEN 'FENCR'
		        END REDE,
		        R_E_C_N_O_ RECNOZ5
		 FROM %Table:SZ5% SZ5 
		 WHERE 
		 Z5_FILIAL = %xFilial:SZ5% 
		 AND Z5_DATEMIS BETWEEN %Exp:cPeriodo+"01"% AND %Exp:dDataFim% 
		 AND Z5_COMISS != '2' 
		 AND (Z5_PRODGAR LIKE '%REG%' OR Z5_PRODGAR LIKE '%SIN%' OR Z5_PRODGAR LIKE '%FENANCOR%') 
		 AND Z5_PRODGAR NOT LIKE '%18%'
		 AND Z5_PRODGAR NOT LIKE '%SERVER%'
		 AND (Z5_COMSW <= 0 Or Z5_BLQVEN = '0' Or 
		 	  (UPPER(Z5_DESREDE) NOT LIKE '%BR%' AND 
		 	   UPPER(Z5_DESREDE) NOT LIKE '%NOT%' AND 
		  	   UPPER(Z5_DESREDE) NOT LIKE '%BR CRED%') 
		 	  OR Z5_DESREDE LIKE '%CLUBE DO REVENDEDOR%')
		 AND Z5_PEDGANT > ' '
		 AND SZ5.%NotDel%
		 UNION
		 SELECT  Z5_PEDGAR PEDGAR,
		        Z5_DATVER DATA,
		        Z5_PRODGAR PRODUTO,
		        Z5_COMSW,
		        Z5_BLQVEN,
		        Z5_DESREDE,
		        CASE
		        WHEN Z5_PRODGAR LIKE '%NOT%' THEN 'NOT'
	          WHEN Z3_CODAC = 'NOT' THEN 'NOT'
		        END REDE,
		        SZ5.R_E_C_N_O_ RECNOZ5
		 FROM %Table:SZ5% SZ5
		 LEFT JOIN %Table:SZ3%  SZ3 ON SZ3.Z3_FILIAL = ' ' AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel%
		 WHERE 
		 Z5_FILIAL = %xFilial:SZ5% 
		 AND Z5_DATVER BETWEEN %Exp:cPeriodo+"01"% AND %Exp:dDataFim% 
		 AND Z5_COMISS != '2' 
		 AND (Z5_PRODGAR LIKE '%NOT%' OR Z3_CODAC = 'NOT')
		 AND Z5_PRODGAR NOT LIKE '%18%'
		 AND Z5_PRODGAR NOT LIKE '%SERVER%'
		 AND (Z5_COMSW <= 0 Or Z5_BLQVEN = '0')
		 AND (Z5_DESREDE NOT LIKE '%NOT%' OR Z5_DESREDE LIKE '%CLUBE DO REVENDEDOR%')
		 AND Z5_PEDGANT = ' '
		 AND SZ5.%NotDel%
		 UNION
		 SELECT  Z5_PEDGAR PEDGAR,
		        Z5_DATEMIS DATA,
		        Z5_PRODGAR PRODUTO,
		        Z5_COMSW,
		        Z5_BLQVEN,
		        Z5_DESREDE,
		        CASE
		        WHEN Z5_PRODGAR LIKE '%NOT%' THEN 'NOT'
	          WHEN Z3_CODAC = 'NOT' THEN 'NOT'
		        END REDE,
		        SZ5.R_E_C_N_O_ RECNOZ5
		FROM %Table:SZ5% SZ5 
		LEFT JOIN %Table:SZ3%  SZ3 ON SZ3.Z3_FILIAL = ' ' AND SZ5.Z5_CODPOS = SZ3.Z3_CODGAR  AND Z3_TIPENT='4' AND SZ3.%NotDel%
		WHERE 
		Z5_FILIAL = %xFilial:SZ5% 
		AND Z5_DATEMIS BETWEEN %Exp:cPeriodo+"01"% AND %Exp:dDataFim% 
		AND Z5_COMISS != '2' 
		AND (Z5_PRODGAR LIKE '%NOT%' OR Z3_CODAC = 'NOT')
		AND Z5_PRODGAR NOT LIKE '%18%'
		AND Z5_PRODGAR NOT LIKE '%SERVER%'
		AND (Z5_COMSW <= 0 Or Z5_BLQVEN = '0')
		AND (Z5_DESREDE NOT LIKE '%NOT%' OR Z5_DESREDE LIKE '%CLUBE DO REVENDEDOR%')
		AND Z5_PEDGANT > ' '
		AND SZ5.%NotDel%
	   	)
		 ORDER BY DATA, PEDGAR
		 
	 EndSql
	 
	DbSelectArea("TMPFX")
	TMPFX->(DbGoTop())
	
	While !TMPFX->(EOF())
		
		DbSelectArea("SZ5")
		SZ5->(DbGoTo(TMPFX->RECNOZ5))
		
		//Reinicia a variavel.
		cFaixa := ""
		
		//Verifica se ja tem cadastro de faixa.
		SZV->(DbSetOrder(1))
		If !SZV->(DbSeek( xFilial("SZV")+ PadR(TMPFX->REDE,6," ") + SubStr(TMPFX->DATA,1,4) ))
			//Gravo a faixa para iniciar geração de dados.
			SZV->(RecLock("SZV",.T.))
			SZV->ZV_CODENT := PadR(TMPFX->REDE,6," ")
			SZV->ZV_SALANO := SubStr(TMPFX->DATA,1,4)
			SZV->(MsUnlock())
		EndIf
		
		//Alimento a faixa durante o calculo se ainda não foi calculado.
		If Empty(SZ5->Z5_DESCST)
			SZV->( RecLock("SZV",.F.) )
			SZV->ZV_SALACU += 1
			//Faço validação do mês que será alimentado.
			If SubStr(TMPFX->DATA,5,2)     == "01"
				SZV->ZV_QTDJAN += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "02"
				SZV->ZV_QTDFEV += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "03"
				SZV->ZV_QTDMAR += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "04"
				SZV->ZV_QTDABR += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "05"
				SZV->ZV_QTDMAI += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "06"
				SZV->ZV_QTDJUN += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "07"
				SZV->ZV_QTDJUL += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "08"
				SZV->ZV_QTDAGO += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "09"
				SZV->ZV_QTDSET += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "10"
				SZV->ZV_QTDOUT += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "11"
				SZV->ZV_QTDNOV += 1
			Elseif SubStr(TMPFX->DATA,5,2) == "12"
				SZV->ZV_QTDDEZ += 1
			EndIf
			ConOut("Gravou no contador: " + SZ5->Z5_PEDGAR )
			SZV->( MsUnLock() )
			
			//Busca nos percentuais da entidades
			SZ4->( DbSetOrder(1) )
			If SZ4->( MsSeek( xFilial("SZ4")+PadR(TMPFX->REDE,6," ") ) )
				
				While SZ4->( !Eof() ) .AND. (PadR(TMPFX->REDE,6," ") == SZ4->Z4_CODENT)
					If SZ4->Z4_CATPROD $ "F1F2F3F4F5F6" .And. ("REG" $ SZ5->Z5_PRODGAR .Or. "NOT" $ SZ5->Z5_PRODGAR .Or. "SIN" $ SZ5->Z5_PRODGAR)
						If SZV->ZV_SALACU >= SZ4->Z4_QTDMIN .AND. SZV->ZV_SALACU <= SZ4->Z4_QTDMAX
							
							//Gravo para utilizar novamente em caso de recalculo.
							SZ5->( RecLock("SZ5",.F.) )
								SZ5->Z5_DESCST := SZ4->Z4_CATPROD
							SZ5->( MsUnLock() )
							
							cFaixa := SZ4->Z4_CATPROD
							
						Endif
					Endif
					SZ4->( DbSkip() )
				End
			Endif
			
			If Empty(SZ5->Z5_DESCST) .Or. Empty(cFaixa)
				//Gravo para utilizar novamente em caso de recalculo.
				SZ5->( RecLock("SZ5",.F.) )
					SZ5->Z5_DESCST := "F0" //Quando ainda não entra para calculo nas faixas.
				SZ5->( MsUnLock() ) 
				
				cFaixa := ""
			EndIf
		EndIf
		
		TMPFX->(DbSkip())
	EndDo
	
	
	RpcSetType(3)
	RpcSetEnv("01","02")
	
	If Select("TMPDAT") > 0
		DbSelectArea("TMPDAT")
		TMPDAT->(DbCloseArea())
	EndIf
	
	//Busca Pedidos sem data
	Beginsql Alias "TMPDAT"
	
		SELECT Z6_PEDGAR FROM SZ6010
		WHERE
		Z6_FILIAL = ' ' AND
		Z6_PERIODO = %Exp:cPeriodo% AND
		Z6_TPENTID IN ('2','5') AND
		Z6_PEDGAR > ' ' AND
		Z6_DTPEDI = ' ' AND
		%NotDel%
		GROUP BY Z6_PEDGAR
	
	EndSql
	
	SZ5->(DbSetOrder(1))
	
	While !TMPDAT->(EOF())
	
		CRPA027B(TMPDAT->Z6_PEDGAR,.F.)
		
		SZ5->(DbSetOrder(1))
		If SZ5->(DbSeek(xFilial("SZ5")+TMPDAT->Z6_PEDGAR))
		 
			SZ5->(Reclock("SZ5",.F.))
				SZ5->Z5_COMISS := " "
			SZ5->(MsUnlock())
				
		Endif
	
		TMPDAT->(Dbskip())
	Enddo
	
	If Select("TMPREC") > 0
		DbSelectArea("TMPREC")
		TMPREC->(DbCloseArea())
	EndIf
	
	BeginSql Alias "TMPREC"
	
		SELECT * FROM
		(SELECT  Z5_DATPED,
		        Z5_PEDGAR,
		        Z5_PRODGAR,
		        Z5_DESCST,
		        CASE
		                      WHEN Z5_PRODGAR LIKE '%REG%' THEN 'BR'
		                      WHEN Z5_PRODGAR LIKE '%SINRJ%' THEN 'SINRJ'
		                      WHEN Z5_PRODGAR LIKE '%SIN%' THEN 'SIN'
		                      WHEN Z5_PRODGAR LIKE '%FENACOR%' THEN 'FENCR'
		        ELSE 'NOT'
		                      END REDE
		FROM SZ5010
		WHERE
		Z5_FILIAL = ' ' AND
		Z5_DATVER BETWEEN %Exp:cPeriodo+"01"% AND %Exp:cPeriodo+"31"% AND
		Z5_PEDGANT = ' ' AND
		Z5_DESCST IN ('F0','F1','F2','F3','F4','F5','F6') AND
		D_E_L_E_T_ = ' '
		UNION
		SELECT  Z5_DATPED,
		        Z5_PEDGAR, 
		        Z5_PRODGAR,
		        Z5_DESCST,
		        CASE
		                      WHEN Z5_PRODGAR LIKE '%REG%' THEN 'BR'
		                      WHEN Z5_PRODGAR LIKE '%SINRJ%' THEN 'SINRJ'
		                      WHEN Z5_PRODGAR LIKE '%SIN%' THEN 'SIN'
		                      WHEN Z5_PRODGAR LIKE '%FENACOR%' THEN 'FENCR'
		        ELSE 'NOT'
		                      END REDE 
		FROM SZ5010
		WHERE
		Z5_FILIAL = ' ' AND
		Z5_DATEMIS BETWEEN %Exp:cPeriodo+"01"% AND %Exp:cPeriodo+"31"% AND
		Z5_PEDGANT > ' ' AND
		Z5_DESCST IN ('F0','F1','F2','F3','F4','F5','F6') AND
		D_E_L_E_T_ = ' ')
		ORDER BY REDE,Z5_DATPED
	
	Endsql
	
	//Obtem saldo das ACs
	If Substr(cPeriodo,5,2) == "01"
		cCampo := "ZV_QTDJAN"
	Elseif Substr(cPeriodo,5,2) == "02"
		cCampo := "ZV_QTDFEV"
	Elseif Substr(cPeriodo,5,2) == "03"
		cCampo := "ZV_QTDMAR"
	Elseif Substr(cPeriodo,5,2) == "04"
		cCampo := "ZV_QTDABR"
	Elseif Substr(cPeriodo,5,2) == "05"
		cCampo := "ZV_QTDMAI"
	Elseif Substr(cPeriodo,5,2) == "06"
		cCampo := "ZV_QTDJUN"
	Elseif Substr(cPeriodo,5,2) == "07"
		cCampo := "ZV_QTDJUL"
	Elseif Substr(cPeriodo,5,2) == "08"
		cCampo := "ZV_QTDAGO"
	Elseif Substr(cPeriodo,5,2) == "09"
		cCampo := "ZV_QTDSET"
	Elseif Substr(cPeriodo,5,2) == "10"
		cCampo := "ZV_QTDOUT"
	Elseif Substr(cPeriodo,5,2) == "11"
		cCampo := "ZV_QTDNOV"
	Elseif Substr(cPeriodo,5,2) == "12"
		cCampo := "ZV_QTDDEZ"
	Endif
	
	nContBR 	:= Posicione("SZV",1,xFilial("SZV")+"BR    "+Substr(cPeriodo,1,4),"ZV_SALACU") - Posicione("SZV",1,xFilial("SZV")+"BR    "+Substr(cPeriodo,1,4),cCampo)
	nConNOT 	:= Posicione("SZV",1,xFilial("SZV")+"NOT   "+Substr(cPeriodo,1,4),"ZV_SALACU") - Posicione("SZV",1,xFilial("SZV")+"NOT   "+Substr(cPeriodo,1,4),cCampo)
	nConSIN 	:= Posicione("SZV",1,xFilial("SZV")+"SIN   "+Substr(cPeriodo,1,4),"ZV_SALACU") - Posicione("SZV",1,xFilial("SZV")+"SIN   "+Substr(cPeriodo,1,4),cCampo)
	nConSINR 	:= Posicione("SZV",1,xFilial("SZV")+"SINRJ "+Substr(cPeriodo,1,4),"ZV_SALACU") - Posicione("SZV",1,xFilial("SZV")+"SINRJ "+Substr(cPeriodo,1,4),cCampo)
	
	While !TMPREC->(EOF())
	
		nContBR 	+= Iif("BR"$TMPREC->REDE,1,0)
		nConNOT 	+= Iif("NOT"$TMPREC->REDE,1,0)
		nConSIN 	+= Iif("SIN"$TMPREC->REDE,1,0)
		nConSINR 	+= Iif("SINRJ"$TMPREC->REDE,1,0)
		
		//Retorna acumulado atual
		If "BR"$TMPREC->REDE
			nTotal	:= nContBR
		ElseIf "NOT"$TMPREC->REDE
			nTotal	:= nConNOT
		ElseIf "SIN"$TMPREC->REDE
			nTotal	:= nConSIN
		ElseIf "SINRJ"$TMPREC->REDE
			nTotal	:= nConSINR
		Endif
		
		//Retorna Faixa atual para gravacao
		cCodFx := SetFaixa(TMPREC->REDE,nTotal,TMPREC->Z5_PRODGAR)
		
		If AllTrim(TMPREC->Z5_DESCST) != cCodFx
		
			SZ5->(DbSetOrder(1))
			If SZ5->(DbSeek(xFilial("SZ5")+TMPREC->Z5_PEDGAR))
			 
				SZ5->(Reclock("SZ5",.F.))
					SZ5->Z5_DESCST := cCodFx
					SZ5->Z5_COMISS := " "
				SZ5->(MsUnlock())
					
			Endif
		
		Endif
		
		TMPREC->(DbSkip())
	Enddo
EndIf

Return

//Buscar faixa atual
Static Function SetFaixa(cEntidade,nTotal,cProduto)

Local cCodFx := ""

//Busca nos percentuais da entidades
SZ4->( DbSetOrder(1) )
If SZ4->( MsSeek( xFilial("SZ4")+cEntidade ) )
	While SZ4->( !Eof() ) .AND. Padr(cEntidade,6," ") == SZ4->Z4_CODENT
		If SZ4->Z4_CATPROD $ "F1F2F3" .And. ("REG" $ cProduto .Or. "NOT" $ cProduto .Or. "SIN" $ cProduto)
			If nTotal >= SZ4->Z4_QTDMIN .AND. nTotal <= SZ4->Z4_QTDMAX
				
				cCodFx := SZ4->Z4_CATPROD
				
			Endif
		Endif
		SZ4->( DbSkip() )
	Enddo
Endif

cCodFx := Iif(Empty(cCodFx),"F0",cCodFx)


Return cCodFx




























