#include "Totvs.ch"
#include "Tbiconn.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} CCIMOEDA
    Função utilizada para buscar a Cotação da moeda na API do Banco Central
    @type       function
    @author     Fabio Favaretto
    @since      30/07/2021
    @version    1.0
    @sample        U_CCIMOEDA()
    @url https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/documentacao

																	Criar parametro onde e armazenado a data base do envio da moeda e cadastro na SM2
	*Parametros devem seguir está ordem*							MV_XPRMAIL
	MV_MOEDA1 = REAL												tipo: caracter 
	MV_MOEDA2 = DOLAR
	MV_MOEDA3 = UFIR
	MV_MOEDA4 = EURO
	MV_MOEDA5 = DOLAR CANADENSE
	MV_MOEDA6 = LIBRA
	MV_MOEDA7 = FRANCO SUICO


	*Os parametros devem estar assim*
	MV_SIMB1 = R$
	MV_SIMB2 = US$                                                                                                                                                                                                                                                       
	MV_SIMB3 = UFIR
	MV_SIMB4 = EUR
	MV_SIMB5 = CAN
	MV_SIMB6 = GBP
	MV_SIMB7 = CHF



 /*/  

#Define STR_PULA		Chr(13)+Chr(10)

User function CCIMOEDA(lCompra)
	Local cBase     := 'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata'
	Local cUrl      := ''
	Local cGetParms := ''
	Local nTimeOut  := 200
	Local aHeadStr  := {'Content-Type: application/json'}
	Local cHeadGet  := ''
	Local cRet      := ''
	Local aIdMoeda  := getMoedas() //{'USD', 'CHF', 'EUR','YEN'} //ARRAY COM MOEDAS
	Local cDtCot    := '' //MM-DD-AAAA
	Local oJObj     := ''
	Local cJRet     := ''
	//Local cCotacao  := ''
	Local nY        := ''
	Local nX        := 0

	Private cEmailTo := ""
	Private cEmailCc := ""
	Private cMensagem := ""

	Default lCompra := .T.



	cDtCot := getReqDt(Date())


	FOR nY := 2 TO LEN(aIdMoeda)
		//[GET] Consulta Dados na Api Olinda
		oJObj   := JsonObject():New()
		cUrl := cBase
		cUrl += "/CotacaoMoedaPeriodoFechamento(codigoMoeda=@idMD,dataInicialCotacao=@dtIniCt,dataFinalCotacao=@dtFinCt)"
		cUrl += "?@idMD='"+aIdMoeda[nY][2]+"'&@dtIniCt='"+cDtCot+"'&@dtFinCt='"+cDtCot
		cUrl += "'&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim"

		cRet := HTTPGet( cUrl , cGetParms, nTimeOut, aHeadStr, @cHeadGet )

		cJRet := oJObj:FromJson(cRet)

		If ValType(cJRet) == 'U' //NIL
			//Valida se a Cotação esta liberada para o dia - oJObj:hasProperty("value")
			If Len(oJObj["value"]) > 0


				If lCompra
					aIdMoeda[nY][3] := (oJObj["value"][1]["cotacaoCompra"])
				Else
					aIdMoeda[nY][3] := (oJObj["value"][1]["cotacaoVenda"])

				EndIf

			

			EndIf
			FreeObj(oJObj)
		Else
			ConOut("Ocorreu erro no processamento do Json" + CRLF+CRLF + cJRet, ':: Cotação Moeda PTAX - BC API Olinda ::')
			//MsgAlert("Não possivel Estabelecer conexão com o Banco Central, Favor cadastrar moedas manualmente", "API PTAX BANCO CENTRAL")
			//If StoD(GetMv("MV_XPRMAIL")) <> dDataBase
			//cEmailTo := "fernando.fukuda@imcdbrasil.com.br;sandra.deoti@imcdbrasil.com.br;carla.albino@imcdbrasil.com.br;leonardo.shertzman@imcdbrasil.com.b;eliane.sampaio@imcdbrasil.com.br;ricardo.souza@imcdbrasil.com.br;fabio.favaretto@imcdbrasil.com.br;fiscal@imcdbrasil.com.br"
			cEmailTo := "fabio.favaretto@imcdbrasil.com.br"
			cMensagem += "<BR>Usuário: "+RetCodUsr()+'-'+UsrFullName(RetCodUsr())
			cMensagem += "<BR>Empresa: "+cEmpAnt
			cMensagem += "<BR>Data:    "+SubStr(DtoS(Date()),7,2)+"/"+SubStr(DtoS(Date()),5,2)+"/"+SubStr(DtoS(Date()),1,4)+' - '+Time()
			cMensagem += "<BR>Não possivel Estabelecer conexão com o Banco Central, Favor cadastrar moedas manualmente"
			cMensagem += "<BR><BR>"


			NewSMail(cEmailTo,cEmailCc,"","API PTAX BANCO CENTRAL",cMensagem,"",.T.,"","","","","","","", "")


		EndIf
	NEXT

	If cEmpAnt == "01"

		If Empty(aIdMoeda) == .F.
			DbSelectArea("SM2")
			If !SM2->( DbSeek( DtoS(DATE()) ) )
				MsgAlert("TAXAS PTAX ATUALIZADAS ", "API PTAX BANCO CENTRAL")
				RecLock("SM2",.T.)
				SM2->M2_DATA   := DATE() //DATA DA INCLUSÃO
				SM2->M2_MOEDA2 := (aIdMoeda[2][3]) //USD
				SM2->M2_MOEDA3 := (aIdMoeda[3][3]) //UFIR  //1.0641
				SM2->M2_MOEDA4 := (aIdMoeda[4][3]) //EUR
				SM2->M2_MOEDA5 := (aIdMoeda[5][3]) //CAD
				SM2->M2_MOEDA6 := (aIdMoeda[6][3]) //GBP
				SM2->M2_INFORM := "S"
				SM2->M2_MOEDA7 := (aIdMoeda[7][3]) //CHF

			Else
				RecLock("SM2",.F.)
			Endif
			If  SM2->M2_MOEDA2==0
				SM2->M2_MOEDA2 := (aIdMoeda[2][3]) //USD
			ENDIF
			If  SM2->M2_MOEDA3==0
				SM2->M2_MOEDA3 := (aIdMoeda[3][3]) //UFIR  //1.0641
			ENDIF
			If  SM2->M2_MOEDA4==0
				SM2->M2_MOEDA4 := (aIdMoeda[4][3]) //EUR
			ENDIF
			If  SM2->M2_MOEDA5==0
				SM2->M2_MOEDA5 := (aIdMoeda[5][3]) //CAD
			ENDIF
			If  SM2->M2_MOEDA6==0
				SM2->M2_MOEDA6 := (aIdMoeda[6][3]) //GBP
			ENDIF
			SM2->M2_INFORM := "S"
			If  SM2->M2_MOEDA7==0
				SM2->M2_MOEDA7 := (aIdMoeda[7][3]) //CHF
			ENDIF
			
			SM2->(MsUnlock())

			DbSelectArea("SYE")
			SYE->(DbSetOrder(1))
			For nX := 1 to Len(aIdMoeda)

				If aIdMoeda[nX][2] $ "USD,GBP,CAN,EUR,CAD,CHF"

					aIdMoeda[nX][2] := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])

					If !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+aIdMoeda[nX][2]))

						RecLock("SYE",.T.)
						YE_FILIAL   := xFilial("SYE")
						YE_DATA     := DATE()
						YE_MOE_FIN  := "2"
						YE_MOEDA    := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])
						YE_VLCON_C  := aIdMoeda[nX][3]
						YE_VLFISCA  := aIdMoeda[nX][3]
						YE_TX_COMP  := aIdMoeda[nX][3]

						SYE->(MsUnlock())


						If aIdMoeda[nX][2] == "USD" .AND. !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+"US$"))

							RecLock("SYE",.T.)
							YE_FILIAL   := xFilial("SYE")
							YE_DATA     := DATE()
							YE_MOE_FIN  := "2"
							YE_MOEDA    := "US$"
							YE_VLCON_C  := aIdMoeda[nX][3]
							YE_VLFISCA  := aIdMoeda[nX][3]
							YE_TX_COMP  := aIdMoeda[nX][3]

							SYE->(MsUnlock())

						EndIf

					EndIf

				EndIf

			Next

			ConOut("Tabela SM2 -> Moedas atulizado com sucesso.")
		EndIf

		If StoD(GetMv("MV_XPRMAIL")) < Date() //dDataBase
			//cEmailTo := "fernando.fukuda@imcdbrasil.com.br;sandra.deoti@imcdbrasil.com.br;carla.albino@imcdbrasil.com.br;leonardo.shertzman@imcdbrasil.com.b;eliane.sampaio@imcdbrasil.com.br;ricardo.souza@imcdbrasil.com.br;fabio.favaretto@imcdbrasil.com.br;fiscal@imcdbrasil.com.br"
			cEmailTo := "fabio.favaretto@imcdbrasil.com.br"
			cMensagem += "<BR>Usuário: "+RetCodUsr()+'-'+UsrFullName(RetCodUsr())
			cMensagem += "<BR>Empresa: "+cEmpAnt
			cMensagem += "<BR>TAXAS CADASTRADAS EM  :    "+SubStr(DtoS(Date()),7,2)+"/"+SubStr(DtoS(Date()),5,2)+"/"+SubStr(DtoS(Date()),1,4)+' - '+Time()
			cMensagem += "<BR>DOLAR - USD:     "+Str((aIdMoeda[2][3]))
			cMensagem += "<BR>EURO - EUR:     "+Str((aIdMoeda[4][3]))
			cMensagem += "<BR>DOLAR CANADENSE - CAD:     "+Str((aIdMoeda[5][3]))
			cMensagem += "<BR>LIBRA - GBP:     "+Str((aIdMoeda[6][3]))
			cMensagem += "<BR>FRANCO SUICO - CHF:     "+Str((aIdMoeda[7][3]))
			cMensagem += "<BR><BR>"


			NewSMail(cEmailTo,cEmailCc,"","Taxas de Moeda Atualizada",cMensagem,"",.T.,"","","","","","","", "")

			PutMv("MV_XPRMAIL",DtoS(Date()))
		EndIf

	Else
		VerMdEmp()
	EndIf

Return



Static Function DeParaMD(cMoedaErp)

	Default cMoedaErp := alltrim(cMoedaErp)

	DO CASE
	CASE cMoedaErp $ "US$/USD"
		cMoedaRet := "USD"
	CASE cMoedaErp == "CAN"
		cMoedaRet := "CAD"
	CASE cMoedaErp == "LBR"
		cMoedaRet := "GBP"
	CASE cMoedaErp == "IENE"
		cMoedaRet := "JPY"
	CASE cMoedaErp == "CHF"
		cMoedaRet := "CHF"
	CASE cMoedaErp == "EUR"
		cMoedaRet := "EUR"
	OTHERWISE
		cMoedaRet := ""
	ENDCASE

return cMoedaRet


Static Function getReqDt(dDataRef)

	local dDataNew := Date()
	local cDataRet := ""

	dDataNew := DataValida (dDataRef-1, .F.)
	cDataRet := strZero(month(dDataNew), 2) + "-"+ strZero(day(dDataNew),2)  + "-"+ strZero(year(dDataNew),4)


return cDataRet



Static Function getMoedas()

	local cPrefix as character
	local cSufix  as character
	local aMoedas as array

	aMoedas := {}
	cPrefix := "MV_SIMB"
	cSufix  := "1"
	cParam  := "cPrefix+cSufix"

	while FWSX6Util():ExistsParam( &(cParam) )

		cMoeda := getMv(&(cParam))
		aadd(aMoedas, {cSufix, DeParaMD(cMoeda), 1})
		cSufix := soma1(cSufix)
	enddo

return aMoedas


Static Function VerMdEmp()
	Local lRet := .F.
	Local cSql := ""
	Local nX := 0
	Local nTaxa  := 0

	If cEmpAnt <> "01"
		cSql := "SELECT * FROM SM2010 WHERE M2_DATA = '"+DtoS(Date())+"' AND D_E_L_E_T_= ' ' "
		If Select("QRYMD") > 0
			QRYMD->(Dbclosearea())
		EndIf

		TCQUERY cSql NEW ALIAS "QRYMD"

		If !Empty(QRYMD->M2_DATA) .AND. QRYMD->M2_MOEDA2 <> 1

			DbSelectArea("SM2")
			If !SM2->( DbSeek( DtoS(DATE()) ) )
				RecLock("SM2",.T.)

				SM2->M2_DATA    := DATE() 			 //DATA DA INCLUSÃO
				SM2->M2_MOEDA2 := QRYMD->(M2_MOEDA2) //USD
				SM2->M2_MOEDA3 := QRYMD->(M2_MOEDA3) //UFIR  //1.0641
				SM2->M2_MOEDA4 := QRYMD->(M2_MOEDA4) //EUR
				SM2->M2_MOEDA5 := QRYMD->(M2_MOEDA5) //CAD
				SM2->M2_MOEDA6 := QRYMD->(M2_MOEDA6) //GBP
				SM2->M2_MOEDA7 := QRYMD->(M2_MOEDA7) //CHF
				SM2->M2_INFORM := "S"

				SM2->(MsUnlock())

				If StoD(GetMv("MV_XPRMAIL")) < Date() //dDataBase
					cEmailTo := "fabio.favaretto@upduo.com.br; caire.vieira@upduo.com.br"

					cMensagem += "<BR>Usuário: "+RetCodUsr()+'-'+UsrFullName(RetCodUsr())
					cMensagem += "<BR>Empresa: "+cEmpAnt
					cMensagem += "<BR>Data:    "+SubStr(DtoS(Date()),7,2)+"/"+SubStr(DtoS(Date()),5,2)+"/"+SubStr(DtoS(Date()),1,4)+' - '+Time()
					cMensagem += "<BR>USD:     "+Str(QRYMD->(M2_MOEDA2))
					cMensagem += "<BR>EUR:     "+Str(QRYMD->(M2_MOEDA4))
					cMensagem += "<BR>CAD:     "+Str(QRYMD->(M2_MOEDA5))
					cMensagem += "<BR>GBP:     "+Str(QRYMD->(M2_MOEDA6))
					cMensagem += "<BR>CHF:     "+Str(QRYMD->(M2_MOEDA7))
					cMensagem += "<BR><BR>"

				

					NewSMail(cEmailTo,cEmailCc,"","Taxas de Moeda Atualizada",cMensagem,"",.T.,"","","","","","","", "")

					PutMv("MV_XPRMAIL",DtoS(Date()))

				EndIf


				DbSelectArea("SYE")
				SYE->(DbSetOrder(1))
				For nX := 1 to Len(aIdMoeda)

					If aIdMoeda[nX][2] $ "USD,GBP,CAN,EUR,CAD,CHF"

						aIdMoeda[nX][2] := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])

						If !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+aIdMoeda[nX][2]))

							Do Case
							Case aIdMoeda[nX][2] == "USD" .OR. aIdMoeda[nX][2] == "US$"
								nTaxa := QRYMD->(M2_MOEDA2)
							Case aIdMoeda[nX][2] == "UFIR"
								nTaxa := QRYMD->(M2_MOEDA3)
							Case aIdMoeda[nX][2] == "EUR"
								nTaxa := QRYMD->(M2_MOEDA4)
							Case aIdMoeda[nX][2] == "CAD" .OR. aIdMoeda[nX][2] == "CAN"
								nTaxa := QRYMD->(M2_MOEDA5)
							Case aIdMoeda[nX][2] == "GBP"
								nTaxa := QRYMD->(M2_MOEDA6)
							Case aIdMoeda[nX][2] == "CHF"
								nTaxa := QRYMD->(M2_MOEDA7)
							End Case

							RecLock("SYE",.T.)
							YE_FILIAL   := xFilial("SYE")
							YE_DATA     := DATE()
							YE_MOE_FIN  := "2"
							YE_MOEDA    := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])
							YE_VLCON_C  := nTaxa
							YE_VLFISCA  := nTaxa
							YE_TX_COMP  := nTaxa

							SYE->(MsUnlock())


							If aIdMoeda[nX][2] == "USD" .AND. !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+"US$"))

								RecLock("SYE",.T.)
								YE_FILIAL   := xFilial("SYE")
								YE_DATA     := DATE()
								YE_MOE_FIN  := "2"
								YE_MOEDA    := "US$"
								YE_VLCON_C  := nTaxa
								YE_VLFISCA  := nTaxa
								YE_TX_COMP  := nTaxa

								SYE->(MsUnlock())

							EndIf

						Else

							Do Case
							Case aIdMoeda[nX][2] == "USD" .OR. aIdMoeda[nX][2] == "US$"
								nTaxa := QRYMD->(M2_MOEDA2)
							Case aIdMoeda[nX][2] == "UFIR"
								nTaxa := QRYMD->(M2_MOEDA3)
							Case aIdMoeda[nX][2] == "EUR"
								nTaxa := QRYMD->(M2_MOEDA4)
							Case aIdMoeda[nX][2] == "CAD" .OR. aIdMoeda[nX][2] == "CAN"
								nTaxa := QRYMD->(M2_MOEDA5)
							Case aIdMoeda[nX][2] == "GBP"
								nTaxa := QRYMD->(M2_MOEDA6)
							Case aIdMoeda[nX][2] == "CHF"
								nTaxa := QRYMD->(M2_MOEDA7)
							End Case

							RecLock("SYE",.F.)
							YE_FILIAL   := xFilial("SYE")
							YE_DATA     := DATE()
							YE_MOE_FIN  := "2"
							YE_MOEDA    := IIf(aIdMoeda[nX][2] == "CAD","CAN",aIdMoeda[nX][2])
							YE_VLCON_C  := nTaxa
							YE_VLFISCA  := nTaxa
							YE_TX_COMP  := nTaxa

							SYE->(MsUnlock())


							If aIdMoeda[nX][2] == "USD" .AND. !SYE->(DbSeek(xFilial("SYE")+DtoS(DATE())+"US$"))

								RecLock("SYE",.F.)
								YE_FILIAL   := xFilial("SYE")
								YE_DATA     := DATE()
								YE_MOE_FIN  := "2"
								YE_MOEDA    := "US$"
								YE_VLCON_C  := nTaxa
								YE_VLFISCA  := nTaxa
								YE_TX_COMP  := nTaxa

								SYE->(MsUnlock())

							EndIf

						EndIf

					EndIf

				Next

				lRet := .T.

			EndIf

		EndIf

	EndIf

	If Select("QRYMD") > 0
		QRYMD->(Dbclosearea())
	EndIf

	DbSelectArea("SM2")
	If StoD(GetMv("MV_XPRMAIL")) < Date() //dDataBase

		If SM2->( DbSeek( DtoS(DATE()-1) ) )

			cEmailTo := "fabio.favaretto@upduo.com.br; caire.vieira@upduo.com.br" //COLOCA O E-MAIL DO FUKUDA

			cMensagem += "<BR>Usuário: "+RetCodUsr()+'-'+UsrFullName(RetCodUsr())
			cMensagem += "<BR>Empresa: "+cEmpAnt
			cMensagem += "<BR>Data:    "+SubStr(DtoS(Date()),7,2)+"/"+SubStr(DtoS(Date()),5,2)+"/"+SubStr(DtoS(Date()),1,4)+' - '+Time()
			cMensagem += "<BR>USD:     "+Str(SM2->(M2_MOEDA2))
			cMensagem += "<BR>EUR:     "+Str(SM2->(M2_MOEDA4))
			cMensagem += "<BR>CAD:     "+Str(SM2->(M2_MOEDA5))
			cMensagem += "<BR>GBP:     "+Str(SM2->(M2_MOEDA6))
			cMensagem += "<BR>CHF:     "+Str(SM2->(M2_MOEDA7))
			cMensagem += "<BR><BR>"

	

			NewSMail(cEmailTo,cEmailCc,"","Taxas de Moeda "+DtoC(DATE()-1),cMensagem,"",.T.,"","","","","","","", "")

			PutMv("MV_XPRMAIL",DtoS(Date()))

		EndIf

	EndIf


Return lRet





Static function NewSMail(cEmailTo,cEmailCc,cEmailBcc,cAssunto,cMensagem,cAnexos,lMsg,cAccount,cPass,cSMTPAddr,cPopAddr,cFrom,nPOPPort,nSMTPPort, cRemet)
	Local oServer  := Nil
	Local oMessage := Nil
	Local nErr     := 0
	Local cUser     := ""      // Usuario que ira realizar a autenticacao
	Local nSMTPTime := 60      // Timeout SMTP
	Local nI := 0

	ProcRegua(10)

	Default lMsg      := .T.
	Default cAnexos   := ""
	Default cEmailBcc := ""
	Default cMensagem := ""
	Default cPopAddr  := ""
	Default cRemet    := ""

	cAccount	:= IIF(Empty(cAccount), GetMV("MV_RELACNT"),cAccount)
	cUser     	:= "envionfe@imcdbrasil.com.br" //cAccount
	cPass    	:= "HXjoT_Nxe8WV.@V6.tF@UgyM" //IIF(Empty(cPass), GetMV("MV_RELPSW"), cPass)
	cSMTPAddr	:= "smtp.office365.com" //IIF(Empty(cSMTPAddr), SUBSTR(GetMV("MV_RELSERV"),1,AT(":", GetMV("MV_RELSERV"))-1), cSMTPAddr)
	nSMTPPort	:= 587 //VAL(SUBSTR(GetMV("MV_RELSERV"),AT(":", GetMV("MV_RELSERV"))+1,Len(GetMV("MV_RELSERV"))))
	cPopAddr 	:= cPopAddr
	cFrom	   	:= "envionfe@imcdbrasil.com.br"  //IIF(!Empty(cRemet), cRemet, cAccount)
	lSSL      	:= GetMV("MV_RELSSL")
	lTSL      	:= GetMV("MV_RELTLS")

	
	oServer := tMailManager():New()

	oServer:setUseSSL(lSSL)
	oServer:SetUseTLS(lTSL)

	oServer:init(cPopAddr, cSMTPAddr, cUser, cPass, /*nPOPPort*/, nSMTPPort)
	IncProc()
	If oServer:SetSMTPTimeout(nSMTPTime) != 0
		Alert("[ERROR]Falha ao definir timeout")
		If lMsg
			HS_MsgInf("Falha ao definir timeout","Atenção","Envio E-mail")
		EndIf

		Return .F.
	Endif

	nErr := oServer:smtpConnect()
	IncProc()

	If nErr <> 0
		Alert("[ERROR]Falha ao conectar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		If lMsg
			HS_MsgInf("Erro ao conectar: " + oServer:getErrorString(nErr) + ", "+ cAnexos,"ATENÃ‡ÃƒO", "Envio E-mail")
		EndIf

		return .F.
	Endif

	nErr := oServer:smtpAuth(cUser, cPass)
	IncProc()
	If nErr <> 0
		Alert("[ERROR]Falha ao autenticar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		If lMsg
			HS_MsgInf("Erro ao autenticar: " + oServer:getErrorString(nErr) + ", "+ cAnexos,"ATENÃ‡ÃƒO", "Envio E-mail")
		EndIf

		return .F.
	Endif

	// Cria uma nova mensagem (TMailMessage)
	oMessage := tMailMessage():new()
	oMessage:clear()
	oMessage:cFrom    := cFrom
	oMessage:cTo      := cEmailTo
	oMessage:cCC      := cEmailCc
	oMessage:cBCC     := cEmailBcc
	oMessage:cSubject := cAssunto
	oMessage:cBody    := cMensagem
	IncProc()

	For nI := 1 to Len(aAnexo := StrToKarr(cAnexos,';'))
		If (nErro := oMessage:AttachFile( aAnexo[nI] )) < 0
			Alert( "Erro ao anexar o arquivo "+aAnexo[nI]+": "+oServer:GetErrorString( nErro )  )
			If lMsg
				HS_MsgInf("Erro ao anexar o arquivo "+aAnexo[nI]+": "+oServer:GetErrorString( nErro ) + ", "+ cAnexos,"Atenção", "Envio E-mail")
			EndIf
			//Return .F.
		Else
			oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+aAnexo[nI])
		EndIf
	Next

	// Envia a mensagem
	nErr := oMessage:send(oServer)
	IncProc()

	If nErr <> 0
		Alert("[ERROR]Falha ao enviar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()

		IncProc()

	EndIf

return .F.
	//Endif

	// Disconecta do Servidor
	oServer:smtpDisconnect()
	IncProc()

Return .T.


User function ptaxCompra(cNumMoe)

	local cPrefix as character
	local aMoedas as array
	local lOk     as logical
	local cMsgError as character
	local nCotacao as numeric

	//readVar() == "C5_XTAXA"
	cMsgError := ""
	lOk     := .T.
	aMoedas := {}
	cPrefix := "MV_SIMB"
	cParam  := "MV_SIMB"+cNumMoe
	nCotacao := 0

	if  FWSX6Util():ExistsParam( cParam )

		cMoeda := getMv(cParam)

		oBcbPTax := wsBcPtax():new()

		nCotacao := 0
		if !(cMoeda $ 'R$/UFIR')
			//Realiza a consulta ao webservice do BC
			nCotacao := oBcbPTax:getCotacaoDiaAnterior(Date(), cMoeda, .T., @lOk, @cMsgError)
			if !lOk
				aviso("Atualização PTAX", "Erro na atualização PTAX : "+CRLF+cMsgError+CRLF+CRLF+"Informe a taxa ptax manualmente na tela a seguir.", {"CANCELAR"}, 2)
				MsgGet2("Ptax manual", "Taxa Ptax compra da moeda "+cMoeda+":", @nCotacao,, {||.T.},X3Picture("M2_MOEDA1"))
			endif
		endif


		freeObj(oBcbPTax)
	endif

return nCotacao
