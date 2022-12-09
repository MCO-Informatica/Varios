#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE CRLF CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ RFATJ002 บ Autor ณ Ellen Santiago       บ Data ณ 18/11/2018บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Margem que sera enviado por e-mail via Job    บฑฑ 
ฑฑบ			 ณ para os geterentes/Diretores                               บฑฑ 	
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn               			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RFATJ002(aDados)
	
	Default aDados := {"01","01"}
	
	//If IsBlind()
		RPCSetType(3)
		RpcSetEnv ( aDados[1], aDados[2],,,"FAT",, {"SA3"} )
		Processa( {||  RUNJ002(.T.) },"Aguarde...","" )
	//EndIf
	
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ RFATJ002 บ Autor ณ Ellen Santiago       บ Data ณ 18/11/2018บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Margem que sera enviado por e-mail via Job    บฑฑ 
ฑฑบ			 ณ para os geterentes/Diretores                               บฑฑ 	
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn               			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function RUNJ002(lJob)     

	Local cPerg		:= ""  
	Local cPath		:= "" 
	Local cArquivo 	:= "" 
	Local cAnexo	:= ""
	Local cRemet	:= ""
	Local cDest		:= ""
	Local cCc		:= ""               
	Local cAssunto	:= ""
	Local cMsgem 	:= ""
	Local cServer 	:= ""
	Local cAccount 	:= ""
	Local cPassword := ""
	Local cVlrcrt 	:= ""
	Local lEnviado	:= .F. 
	Local cDataini	:= Nil
	Local cDatafim	:= Nil
	Local cMsgErr	:= ""
	
	Default lJob 	:= .F.
	
	ProcRegua(0)
	
	cPerg		:= "RFATR00J"  
	cPath		:= "\_Relatorios\" 
	cArquivo 	:= "rfatr00j_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".pdf" 
	cAnexo		:= cPath + cArquivo 
	cRemet		:= getmv("MV_RELACNT") //Remetente
	cDest		:= getMV("MV_EMAILGE")
	cCc			:= ""
	cAssunto	:= 'Relatorio Acompanhamento Geral de Vendas'  
	cMsgem		:= "Prezados(as) Srs(as) "+CHR(13) + CHR(10)+CHR(13) + CHR(10)+ "Segue anexo Relatorio Geral de Acompanhamento das Vendas" +CHR(13) + CHR(10)+ "Perํodo de: " + Dtoc(FirstDate(dDataBase))+ " at้: " + dtoc(dDataBase) +CHR(13) + CHR(10) + CHR(13) + CHR(10)+  "Comercial - Prozyn"
	cServer 	:= getMV("MV_RELSERV") //endere็o SMTP
	cAccount 	:= getmv("MV_RELACNT") //conta
	cPassword 	:= getMV("MV_RELAPSW") //senha
	lEnviado	:= .F. 	
	cVlrcrt 	:= getMV("MV_VLRCRT") //VALOR DE CORTE	
	cDataini	:= FirstDate(dDataBase)
	cDatafim	:= LastDate(dDataBase)
	 		 	

	conOut ("inicio Acomp Vendas - Diretores")

	If File(cPath + cArquivo) 
		Ferase(cPath + cArquivo)       
		Ferase(StrTran(cPath + cArquivo,".pdf",".rel") )
	EndIf

	Pergunte(cPerg,.F.)

	SX1->(DbSelectArea("SX1"))
	SX1->(DbSetOrder(1))
	If SX1->(dbSeek(cPerg))
		While ALLTRIM(SX1->X1_GRUPO) == cPerg .AND. !SX1->(EOF())  
			If ALLTRIM(SX1->X1_VAR01) == "MV_PAR01"   		// Data De     
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := DtoS(cDataini) 
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR02"	// Data Ate 
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := DtoS(cDatafim) 
				MsUnlock()   
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR03"	// Cliente De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR04"	// Cliente Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZZZ"
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR05"	// Produto De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR06"	// Produto Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZZZZZZZZZZZZ"
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR07" // Segmento De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR08"	// Segmento Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZZZ"
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR09"	// Vendedor De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR10"	// Vendedor Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZZZ"
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR11"	// Grupo de Cliente De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR12"	// Grupo de Cliente Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZ"
				MsUnlock() 	 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR13"	// Modelo de Impressao (1-PDF | 2-Excel)
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "1"
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR14"	// Valor do Corte
				Reclock("SX1",.F.)   
				SX1->X1_CNT01 := cVlrcrt
				MsUnlock()
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR15"	// Ordenador por
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR16"	// Moeda 1- R$ ou 2-$
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "1"
				MsUnlock()  
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR17"	// Impostos 1- Net ou 2-Bruto
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "2"
				MsUnlock()
			Endif
			SX1->(dbSkip())
		EndDo  
	Endif

//Executa o Relatorio de acompanhamento de vendas
U_RFATR004(cArquivo, ,lJob) 
If !lJob
	CPYT2S(AllTrim(GetTempPath())+cArquivo,cPath,.F.)
EndIf

EnvMail(cDest,cAssunto,cMsgem,cCc, cAnexo, @cMsgErr)
If Empty(cMsgErr)
	lEnviado := .T.
Else
	lEnviado := .F.
EndIf

If !lJob
	If !lEnviado
		Alert("ALERTA: Nใo foi possivel enviar a mensagem") 
		Return .f.
	Else 
		Aviso("AVISO", "E-mail transmitido com sucesso!", {"Ok"}, 1)
	Endif 
Else
	If !lEnviado
		ConOut("ALERTA: Nใo foi possivel enviar a mensagem") 
		Return .F.
	Else 
		ConOut("E-mail transmitido com sucesso!")
	Endif 
Endif

//Exclui o arquivo 
ExclArq(cAnexo,1, "")
ExclArq(StrTran(cAnexo,".pdf",".rel"),1, "")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExclArq  บAutor  ณMicrosiga	         บ Data ณ  19/03/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui os arquivo ap๓s finalizar o processo                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                               	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExclArq(cDir, nOpc, cMsgErr)

	Local aArea		:= GetArea()
	Local aArqs		:= Array(Adir(Alltrim(cDir)+"*.*"))
	Local nX		:= 1
	Local nRetExc   := 0
	Local lRet		:= .T. 

	Default cDir	:= ""
	Default nOpc 	:= 2
	Default cMsgErr	:= ""

	//Se for direferente de 1, exclui todos os arquivos da pasta informada
	If nOpc != 1
		//Busca todos os arquivos do diretorio informado e passa para um array
		Adir(Alltrim(cDir)+"*.*",aArqs)

		//Exclui todos os arquivos utilizados no diret๓rio informado
		For nX := 1 To Len(aArqs)

			nRetExc := FERASE(Alltrim(cDir)+aArqs[nX])
			If nRetExc !=  0
				cMsgErr += "Erro ao excluir arquivo ->"+aArqs[nX]+ CRLF
				lRet := .F.
			EndIf

		Next
	Else

		nRetExc := FERASE(Alltrim(cDir))
		If nRetExc !=  0
			cMsgErr += "Erro ao excluir arquivo ->"+Alltrim(cDir)+ CRLF
			lRet := .F.
		EndIf

	EndIf

	If !Empty(cMsgErr)
		conout(cMsgErr)
	EndIf

	RestArea(aArea)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail  บAutor  ณMicrosiga	          บ Data ณ  25/03/2017บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 	                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail(cEmailTo,cAssunto,cMensagem,cEmailCc, cAnexos, cMsgErr)

	Local aArea 		:= GetArea()
	Local cServer   	:= Alltrim(Separa(GetMV("MV_RELSERV",,""),":")[1])
	Local nPort			:= Val(Separa(GetMV("MV_RELSERV",,""),":")[2])
	Local cAccount		:= Alltrim(GetMV("MV_RELACNT",,""))
	Local cPwd			:= Alltrim(GetMV("MV_RELPSW",,""))
	Local lAutentic		:= GetNewPar("MV_RELAUTH",.F.)
	Local lSSL			:= .T.
	Local lTLS			:= .T.

	Local oServer       := Nil
	Local oMessage		:= Nil 
	Local aAnexos		:= Iif(!Empty(cAnexos), Separa(cAnexos,";"), "")
	Local nX			:= 1
	Local nErro			:= 0

	Default cMsgErr 	:= ""

	//Crio a conexใo com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()

	If lSSL
		oServer:SetUseSSL(lSSL)
	EndIf

	If lTLS
		oServer:SetUseTLS(lTLS)
	EndIf

	oServer:Init( "", cServer, cAccount,cPwd,0,nPort)

	//realizo a conexใo SMTP
	nErro := oServer:SmtpConnect() 
	If nErro != 0  
		cMsgErr := "Falha na conexใo SMTP. "
		Return .F.
	EndIf

	//seto um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		cMsgErr := "Falha ao setar o time out com o servidor. "
		Return .F.
	EndIf

	// Autentica็ใo
	If lAutentic
		If oServer:SMTPAuth ( cAccount,cPwd ) != 0
			cMsgErr := "Falha ao autenticar. "
			Return .F.
		EndIf
	EndIf

	//Apos a conexใo, crio o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpo o objeto
	oMessage:Clear()

	//Populo com os dados de envio
	oMessage:cFrom		:= 	cAccount
	oMessage:cTo		:=	cEmailTo
	oMessage:cSubject	:= 	cAssunto
	oMessage:cBody		:= 	cMensagem
	oMessage:MsgBodyType( "text/html" )

	For nX := 1 To Len(aAnexos)
		If File(aAnexos[nX])

			//Adiciono um attach
			If oMessage:AttachFile( aAnexos[nX] ) < 0
				cMsgErr := "Erro ao anexar o arquivo. "
				Return .F.
			EndIf
		EndIf     
	Next

	//Envio o e-mail
	If oMessage:Send( oServer ) != 0
		cMsgErr := "Erro ao enviar o e-mail. "
		Return .F.
	EndIf

	//Disconecto do servidor
	If oServer:SmtpDisconnect() != 0
		cMsgErr := "Erro ao disconectar do servidor SMTP. "
		Return .F.
	EndIf

	RestArea(aArea)
Return
