#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE CRLF CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATJ001 º Autor ³ Ellen Santiago       º Data ³ 18/11/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Margem que sera enviado por e-mail via Job    º±± 
±±º			 ³ para cada um dos vendedores                                º±± 	
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RFATJ001()

	Local cQuery	:= ""   

	//If IsBlind()
	RPCSetType(3)
	RpcSetEnv ( "01", "01",,,"FAT",, {"SA3"} )
	//EndIf

	cDataini	:= FirstDate(MsDate())
	cDatafim	:= LastDate(MsDate())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca todos os vendedores para envio de e-mail  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT A2.A3_EMAIL AS EMAILSUP, SA3.A3_VLRCRT AS CORTE, * " + CRLF
	cQuery += " FROM  "+RetSqlName("SA3")+" SA3 "  + CRLF 
	cQuery += " LEFT JOIN  "+RetSqlName("SA3")+" A2 ON "  + CRLF 
	cQuery += " SA3.A3_SUPER = A2.A3_COD   "  + CRLF   
	cQuery += " WHERE SA3.D_E_L_E_T_ = '' " + CRLF
	cQuery += "	AND SA3.A3_MSBLQL = '2' " + CRLF
	cQuery += "	AND SA3.A3_RELMAIL = 'S' " + CRLF

	If Select("TEMP") > 0
		TEMP->(DbCloseArea())		
	EndIf

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TEMP",.F.,.T.)

	If TEMP->(EOF())
		Return
	EndIf	

	Processa( {||  RunRel(cDataini, cDatafim, .T.) },"Aguarde...","" )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATJ001 º Autor ³ Ellen Santiago       º Data ³ 18/11/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Margem que sera enviado por e-mail via Job    º±± 
±±º			 ³ para cada um dos vendedores                                º±± 	
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RunRel(cDataini,cDatafim, lJob)


	Default lJob := .F.
	
	ProcRegua(0)
	TEMP->(DbGoTop())
	While TEMP->(!EOF())  
		RFATR051( TEMP->A3_COD, ALLTRIM(TEMP->A3_NOME),ALLTRIM(TEMP->A3_EMAIL),ALLTRIM(TEMP->EMAILSUP),ALLTRIM(TEMP->CORTE),cDataini,cDatafim, lJob) 
		//SLEEP(30000)
		TEMP->(DbSkip())
	EndDo

Return


/*
+-----------------------------------------------------------------------------+
| PROGRAMA: RFATR051       | AUTOR: Ellen Santiago       | DATA: 18/06/2018   |
+-----------------------------------------------------------------------------+
| DESCRICAO:  Gera Relatorio e anexa no e-mail a ser enviado para o vendedor  |
+-----------------------------------------------------------------------------+
| USO: Especifico Prozyn													  |
+-----------------------------------------------------------------------------+   
*/
Static Function RFATR051 (cCodVend,cVendedor,cEmail,cCcsup,cCorte,cDataini, cDatafim, lJob) 

	Local cPerg		:= "RFATR00J"  
	Local cPath		:= "\_Relatorios\" 
	Local cArquivo 	:= "rfatr00j_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".pdf" 
	Local cAnexo	:= cPath + cArquivo 
	Local cRemet	:= getmv("MV_RELACNT") //Remetente 
	Local cDest		:= cEmail
	Local cEmailCC	:= getmv("MV_R051CC") //Copia 
	Local cCc		:= cCcsup+';'+cEmailCC
	Local cAssunto	:= 'Relatorio Acompanhamento de Vendas'  
	Local cMsgem	:= "Sr(a). " + cVendedor  +"."+ CRLF + CRLF + "Segue anexo o Relatorio de Acompanhamento das Vendas" + CRLF + CRLF +   "Período de: " + Dtoc(FirstDate(dDataBase))+ " até: " + dtoc(dDataBase) + CRLF + CRLF + "Comercial - Prozyn"
	Local cServer 	:= getMV("MV_RELSERV") //endereço SMTP
	Local cAccount 	:= getmv("MV_RELACNT") //conta
	Local cPassword := getMV("MV_RELAPSW") //senha
	Local lConectou := .F.
	Local lEnviado	:= .F. 	

	Default lJob	:= .F.
	ConOut("Início Acompanhamento Vendas - Vendedores "+cVendedor)

	Pergunte(cPerg,.F.) 

	SX1->(DbSelectArea("SX1"))
	SX1->(DbSetOrder(1))
	If SX1->(dbSeek(cPerg))
		While ALLTRIM(SX1->X1_GRUPO) == cPerg .AND. !SX1->(EOF())  
			If ALLTRIM(SX1->X1_VAR01) == "MV_PAR01"   		// Data De     
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := DtoS(cDataini) 
				SX1->(MsUnlock()) 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR02"	// Data Ate 
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := DtoS(cDatafim) 
				SX1->(MsUnlock())  
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR03"	// Cliente De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				SX1->(MsUnlock())
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR04"	// Cliente Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZZZ"
				SX1->(MsUnlock())
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR05"	// Produto De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				SX1->(MsUnlock())
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR06"	// Produto Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZZZZZZZZZZZZ"
				SX1->(MsUnlock())
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR07" // Segmento De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				SX1->(MsUnlock()) 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR08"	// Segmento Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZZZ"
				MsUnlock() 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR09"	// Vendedor De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := cCodVend
				SX1->(MsUnlock())
				MV_PAR09 := cCodVend
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR10"	// Vendedor Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := cCodVend
				SX1->(MsUnlock())
				MV_PAR10 := cCodVend 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR11"	// Grupo de Cliente De
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "
				SX1->(MsUnlock()) 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR12"	// Grupo de Cliente Ate
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "ZZZZ"
				SX1->(MsUnlock()) 	 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR13"	// Modelo de Impressao (1-PDF | 2-Excel)
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "1"
				SX1->(MsUnlock()) 
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR14"	// Valor do Corte
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := cCorte
				SX1->(MsUnlock())
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR15"	// Ordenador por
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := " "  
				SX1->(MsUnlock()) 	
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR16"	// Moeda 1=R$ ou 2=$
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "1"
				SX1->(MsUnlock())
			Elseif ALLTRIM(SX1->X1_VAR01) == "MV_PAR17"	// Impostos 1=Net ou 2=Bruto
				Reclock("SX1",.F.)
				SX1->X1_CNT01 := "2"
				SX1->(MsUnlock())
			Endif
			SX1->(dbSkip())
		EndDo  
	Endif

	//Executa o Relatorio de acompanhamento de vendas
	U_RFATR004(cArquivo, cCodVend, lJob) 
	If !lJob
		CPYT2S(AllTrim(GetTempPath())+cArquivo,cPath,.F.)
	EndIf

	// Conecta com o servidor de e-mail
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

	// Autentica
	MailAuth(cAccount, cPassword)

	// Envia e-mail
	SEND MAIL From cRemet To cDest CC cCc SUBJECT cAssunto BODY cMsgem ATTACHMENT cAnexo RESULT lEnviado 

	/*If !IsBlind()
	If !lEnviado
	Alert("ALERTA: Não foi possivel enviar a mensagem") 
	Return .f.
	Else 
	Aviso("AVISO", "E-mail transmitido com sucesso!", {"Ok"}, 1)
	Endif 
	Else
	If !lEnviado
	ConOut("ALERTA: Não foi possivel enviar a mensagem") 
	Return .F.
	Else 
	ConOut("E-mail transmitido com sucesso!")
	Endif 
	Endif*/

	DISCONNECT SMTP SERVER Result lDisConectou

	//Exclui o arquivo 
	ExclArq(cAnexo,1, "")
	ExclArq(StrTran(cAnexo,".pdf",".rel"),1, "")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExclArq  ºAutor  ³Microsiga	         º Data ³  19/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclui os arquivo após finalizar o processo                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                               	                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

		//Exclui todos os arquivos utilizados no diretório informado
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
