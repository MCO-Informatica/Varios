#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"

//+------------+---------------+------------------------------------------------------------------------+--------+---------+
//| Data       | Desenvolvedor | Descricao                                                              | Versao | JIRA    |
//+------------+---------------+------------------------------------------------------------------------+--------+---------+
//| 01/02/2017 | David Sobrin. | Alterado a pedido do Sr. Nasser, pois, ao realizar Rename esta         | 1.00   |         |
//|            |               | herdando diretrizes de segurança que não permitem ao PDF serem lidos   |        |         |
//|            |               | no portal do cliente (David)                                           |        |         |
//+------------+---------------+------------------------------------------------------------------------+--------+---------+
//| 25/08/2018 | Renato Ruy    | Gera o PDF, porem necessita da interacao do usuario 					| 1.01   |         |
//|            |               | O erro estava dentro do danfeII, deve ter alguma anteracao de parametro|        |         |
//+------------+---------------+------------------------------------------------------------------------+--------+---------+
//| 03/06/2020 | Bruno Nunes   | - Necessário a correção da rotina Garr010, que é responsável pela      | 1.02   | PROT-24 |
//|            |               | geração forçado do link da nota de produto.                            |        |         |
//|            |               | Hoje estamos com impacto no processo de envio de códigos de rastreio   |        |         |
//|            |               | para os clientes devido á notas que não geraram esse link.             |        |         |
//|            |               | -Outras rotinas envolvidas: U_NFDENG03, U_GARR010,U_GTPutRet           |        |         |
//|            |               | U_NFDENG02, U_NFDENG01, U_GARR010,U_GTPutRet                           |        |         |
//+------------+---------------+------------------------------------------------------------------------+--------+---------+
//| 07/07/2020 | Bruno Nunes   | Tratado a gravacao da NF no servidor, caso não gere o arquivo, não     | 1.03   | SIS-852 |
//|            |               | será passado o link para a tabela de pedido SC5 / SC6.                 |        |         |
//+------------+---------------+------------------------------------------------------------------------+--------+---------+

/*/{Protheus.doc} GARR010
Rdmake de exemplo para impressão da DANFE no formato Retrato
@type function
@author Eduardo Riera
@since 16/11/2006
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
User Function GARR010( aProc, cRandom, lDenegPar )
	Local cIdEnt     := ""
	Local oFont20N   := TFont():New("Arial",20,20,,.T.,,,,.T.,.F.)
	Local cRootPath  := GetSrvProfString("RootPath","")
	Local cPath      := GetNewPar("MV_PATHNF","\espelhonf\")
	Local cCompart   := GetNewPar("MV_COMPNF","http://192.168.16.30/espelhonf/") + DtoS(Date()) + "/"
	Local cExtFile   := ".pdf"
	Local cFile      := ""
	Local oDanfe	 := NIL
	Local oSetup	 := NIL
	Local nFlags   	 := PD_ISTOTVSPRINTER + PD_DISABLEORIENTATION
	Local nI         := 0
	Local aRet       := {}
	Local aArea      := GetArea()
	Local cOperDeliv := GetNewPar("MV_XOPDELI", "01")
	Local cOperVenH  := GetNewPar("MV_XOPEVDH", "52")
	Local cOperEntH  := GetNewPar("MV_XOPENTH", "53")
	Local lDebug	 := .T.
	Local lGerouPDF	 := .F.
	Local nAttempt	 := 0

	Default aProc     := {}
	Default cRandom   := ""
	Default lDenegPar := .F.

	Private lDeneg	:= lDenegPar

	If !lDebug
		// Enibe a emissao da imagem quando for importacao
		If !IsBlind() ;
		.AND. FunName() <> "SPEDNFE"   ;
		.AND. FunName() <> "MATA410"   ;
		.AND. FunName() <> "CERFATALL" ;
		.AND. FunName() <> "CFGX019"   ;
		.AND. FunName() <> "MATA460B"  ;
		.AND. FunName() <> "CSGERNF"

			Aadd( aRet, .F. )
			Aadd( aRet, "000134" )
			Aadd( aRet, SC5->C5_XNPSITE )
			Aadd( aRet, "Validacao IsBlind" )
			Return(aRet)
		Endif
	EndIf

	While !ExistDir(cPath + DtoS(Date()) + "\") .And. nAttempt < 5
		If MakeDir( cPath + DtoS(Date()) + "\", 1 ) != 0
			Sleep(60 * 1000)
		EndIf
		nAttempt++
	EndDo

	If Empty(cRandom)
		For nI := 1 To 5
			cRandom += Str(Randomize(0,10),1)
		Next nI
	Endif

	// Posiciona no item da nota para identificar pedidogar
	SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
	lSeekC6 := SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )

	If lSeekC6 .and. !Empty(SC6->C6_XIDPED)
		cFile := "p" + AllTrim(SC5->C5_XNPSITE)+AllTrim(SC6->C6_XIDPED) + cRandom + cExtFile
	else
		cFile := "p" + AllTrim(SC5->C5_XNPSITE) + cRandom + cExtFile
	EndIf
	cFile := StrTran(cFile,":","")

	oDanfe:= FWMSPrinter():New(cFile   , IMP_PDF, .F.,''  ,.T.,  .F.,@oSetup, , .T., .T. ,    ,.F. )
	oDanfe:cPathPDF := '\spool\'
	oDanfe:lServer  := .T.
	oDanfe:lInJob   := .T.
	nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN

	If !aProc[1]
		oDanfe:StartPage()
		oDanfe:Say(055,098,"Pedido -> "+aProc[3],oFont20N)
		oDanfe:Say(065,050,"Codigo do erro : "+aProc[2],oFont20N)
		SZ7->( DbSetOrder(1) )
		If SZ7->( Msseek( xFilial("SZ7")+aProc[2] ) )
			oDanfe:Say(075,098,SZ7->Z7_DESMEN,oFont20N)
		Endif

		If len(aProc) >= 4
			oDanfe:Say(075,098,aProc[4],oFont20N)
		EndIf
		lRet := .T.
	Else
		aRet := {}

		cIdEnt	:= GetIdEnt()
		If Empty(cIdEnt)
			Aadd( aRet, .F. )
			Aadd( aRet, "000133" )
			Aadd( aRet, SC5->C5_XNPSITE)
			Aadd( aRet, "Inconsistência de validação da NF junto ao Orgao validador" )
			lRet := .F.
		Else
			//+--------------------------------------------------------------------------------+
			//| Rotina que realmente gera o .pdf da NF                                         |
			//+--------------------------------------------------------------------------------+
			lRet := u_PrtNfeSef(cIdEnt,"","",oDanfe,oSetup,cFile,,,cRootPath+"\spool\", lDeneg)
		Endif
	Endif
	oDanfe:EndPage()
	oDanfe:Print()
	Sleep(10000) // Aguarda 10s apos gerar PDF - Renato Ruy - 25/08/2018 - Versao 1.00

	Freeobj(oDanfe)

	cFile := Alltrim(cFile)

	aRet := {}
	Aadd( aRet, lRet )
	Aadd( aRet, IIF(lRet,"000135","000132") )
	Aadd( aRet, SC5->C5_XNPSITE )
	If lRet
		Aadd( aRet, cCompart+cFile )
	Else
		aParam 		:= {}
		aXml		:= {}
		cModalidade := ""
		aadd(aParam, SF2->F2_SERIE)
		aadd(aParam, SF2->F2_DOC)
		aadd(aParam, SF2->F2_DOC)

		aXml := ConsNFeCe(cIdEnt,1,aParam)
		If Len(aXml) > 0 .and. Len(aXml[1,6]) > 0
			Aadd( aRet, "Espelho em PDF gerado com codigo de erro - 02. Nota: "+Alltrim(SF2->F2_SERIE+SF2->F2_DOC)+": "+CRLF+aXml[1,6]+" Estado "+SF2->F2_EST )
		Else
			Aadd( aRet, "Espelho em PDF gerado com codigo de erro - 02. Nota: "+Alltrim(SF2->F2_SERIE+SF2->F2_DOC)+" Não foi possível identificar a Inconsistência. Consulte o Monitor de NFE Sefaz" )
		EndIf
	Endif

	// Grava na tabela SF2 o retorno do LOG para posterior reenvio caso seja solicitado.
	SF2->( RecLock("SF2",.F.) )
	SF2->F2_ARET :=	IIF(aRet[1],".T.",".F.") + "," +;
	PadR(aRet[2],06) + "," +;
	PadR(aRet[3],10) + "," +;
	AllTrim(aRet[4])
	SF2->( MsUnLock() )
	SF2->(DBCommit())

	If aRet[1]
		// Se o arquivo jah existe no destino, apaga antes de mover.
		If File(cRootPath+cPath+DtoS(Date())+"\"+cFile,1)
			Ferase(cRootPath+cPath+DtoS(Date())+"\"+cFile,1)
		Endif

		//Zera variaveis de controle
		lCopiou := .F.
		nAttempt := 0
		nCodErro := 0

		//Verifica se o documento pdf na pasta spool
		lGerouPDF := filePDF( cFile )

		//Tenta Copiar o Arquivo de SPOOL para EspelhoNF 10 vezes.
		//Se não conseguir, aborta e manda e-mail com erro do FError
		If lGerouPDF
			While !lCopiou .And. nAttempt < 10
				lCopiou := __CopyFile( "\spool\"+cFile, "\espelhonf\"+DtoS(Date())+"\"+cFile)
				nCodErro := FError()
				//sleep(15000)
				nAttempt++
			EndDo

			If lCopiou
				Ferase( "\spool\" + cFile )
				// Apaga o arquivo .REL
				cFile := SubStr(cFile,1,Len(cFile)-3)+"rel"
				Ferase(cRootPath+"\spool\"+cFile,1)
			Else

				xCorpo := ""

				//Array aRet é devolvido para server_hardwareavulso
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "ER0003" )
				Aadd( aRet, SC5->C5_XNPSITE)
				Aadd( aRet, "Nao consegue mover o PDF para a pasta de data --> 04" )

				//Envio e-mail para SisCorp informando falha na cópia do arquivo
				xCorpo := SC5->C5_XNPSITE + ": " + aRet[4] + CHR(13)+CHR(10) +" ERRO: " + u_CSFERRMSG(nCodErro) + CHR(13)+CHR(10) + "Arquivo: " + cFile
				U_VNDA290(xCorpo, "sistemascorporativos@certisign.com.br", "[VAREJO] Erro na cópia do Espelho da NF",,,,)
			Endif
		EndIf

		if lCopiou
			// Posiciona no item da nota para identificar tipo de danfe a ser impressa Venda ou entrega
			SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
			lSeekC6 := SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
	
			If lSeekC6 .and. (SC6->C6_XOPER $ '52,'+cOperVenH .or. SC6->C6_XOPER == cOperDeliv)
				RecLock("SC5", .F.)
				Replace SC5->C5_XNFHRD With aRet[4]
				Replace SC5->C5_XFLAGHW With Space(TamSX3("C5_XFLAGHW")[1])
				SC5->(MsUnLock())
	
				While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NOTA+C6_SERIE) == xFilial("SC6")+SF2->(F2_DOC+F2_SERIE)
					RecLock("SC6", .F.)
					Replace SC6->C6_XNFHRD With aRet[4]
					Replace SC6->C6_XFLAGHW With Space(TamSX3("C6_XFLAGHW")[1])
					SC6->(MsUnLock())
	
					SC6->(DbSkip())
				End
			EndIf

			SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
			lSeekC6 := SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
	
			If lSeekC6 .and. SC6->C6_XOPER == cOperEntH
				RecLock("SC5", .F.)
				Replace SC5->C5_XNFHRE With aRet[4]
				Replace SC5->C5_STENTR With "1"
				Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
				SC5->(MsUnLock())
	
				While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NOTA+C6_SERIE) == xFilial("SC6")+SF2->(F2_DOC+F2_SERIE)
					RecLock("SC6", .F.)
					Replace SC6->C6_XNFHRE With aRet[4]
					//Replace SC6->C6_STENTR With "1"
					Replace SC6->C6_XFLAGEN With Space(TamSX3("C6_XFLAGEN")[1])
					SC6->(MsUnLock())
	
					SC6->(DbSkip())
				End
			EndIf
			SC5->(DBCommit())
		EndIf
	Else
		// Apaga os arquivos .REL e .PDF
		Ferase( cRootPath+"\spool\"+cFile,1)
		cFile := SubStr(cFile,1,Len(cFile)-3)+"rel"
		Ferase( cRootPath+"\spool\"+cFile,1)
	EndIF
	RestArea(aArea)
Return(aRet)

/*/{Protheus.doc} GetXML
Rdmake de exemplo para impressão da DANFE no formato Retrato
@type function
@author Eduardo Riera
@since 16/11/2006
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function GetXML(cIdEnt,aIdNFe,cModalidade)
	Local cURL       := PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
	Local oWS
	Local cRetorno   := ""
	Local cProtocolo := ""
	Local nX         := 0
	Local nY         := 0
	Local aRetorno   := {}
	Local aResposta  := {}
	Local aFalta     := {}
	Local aExecute   := {}
	Local cDHRecbto  := ""
	Local cDtHrRec   := ""
	Local cDtHrRec1	 := ""
	Local nDtHrRec1  := 0

	Private oDHRecbto

	If Empty(cModalidade)
		oWS := WsSpedCfgNFe():New()
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		oWS:nModalidade:= 0
		oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		If oWS:CFGModalidade()
			cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
		Else
			cModalidade    := ""
		EndIf
	EndIf
	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN        := "TOTVS"
	oWS:cID_ENT           := cIdEnt
	oWS:oWSNFEID          := NFESBRA_NFES2():New()
	oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
	For nX := 1 To Len(aIdNFe)
		aadd(aRetorno,{"","",aIdNfe[nX][4]+aIdNfe[nX][5]})
		aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
		Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aIdNfe[nX][4]+aIdNfe[nX][5]
	Next nX
	oWS:nDIASPARAEXCLUSAO := 0
	oWS:_URL := AllTrim(cURL)+"/NFeSBRA.apw"
	IF cModalidade <> "5"
		If oWS:RETORNANOTAS()
			If Len(oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3) > 0
				For nX := 1 To Len(oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3)
					cRetorno        := oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3[nX]:oWSNFE:CXML
					cProtocolo      := oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3[nX]:oWSNFE:CPROTOCOLO
					cDHRecbto  		:= oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3[nX]:oWSNFE:CXMLPROT
					//Tratamento para gravar a hora da transmissao da NFe
					If !Empty(cProtocolo)
						oDHRecbto		:= XmlParser(cDHRecbto,"","","")
						cDtHrRec		:= oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT
						nDtHrRec1		:= RAT("T",cDtHrRec)

						If nDtHrRec1 <> 0
							cDtHrRec1 := SubStr(cDtHrRec,nDtHrRec1+1)
						EndIf
						dbSelectArea("SF2")
						dbSetOrder(1)
						If MsSeek(xFilial("SF2")+aIdNFe[nX][5]+aIdNFe[nX][4]+aIdNFe[nX][6]+aIdNFe[nX][7])
							RecLock("SF2")
							SF2->F2_HORA := cDtHrRec1
							MsUnlock()
						EndIf
					EndIf
					nY := aScan(aIdNfe,{|x| x[4]+x[5] == SubStr(oWs:oWsRetornaNotasResult:OWSNOTAS:OWSNFES3[nX]:CID,1,Len(x[4]+x[5]))})
					If nY > 0
						aRetorno[nY][1] := cProtocolo
						aRetorno[nY][2] := cRetorno

						aadd(aResposta,aIdNfe[nY])
					EndIf
				Next nX
				For nX := 1 To Len(aIdNfe)
					If aScan(aResposta,{|x| x[4] == aIdNfe[nX,04] .And. x[5] == aIdNfe[nX,05] })==0
						aadd(aFalta,aIdNfe[nX])
					EndIf
				Next nX
				If Len(aFalta)>0
					aExecute := GetXML(cIdEnt,aFalta,@cModalidade)
				Else
					aExecute := {}
				EndIf
				For nX := 1 To Len(aExecute)
					nY := aScan(aRetorno,{|x| x[3] == aExecute[nX][03]})
					If nY == 0
						aadd(aRetorno,{aExecute[nX][01],aExecute[nX][02],aExecute[nX][03]})
					Else
						aRetorno[nY][01] := aExecute[nX][01]
						aRetorno[nY][02] := aExecute[nX][02]
					EndIf
				Next nX
			EndIf
		EndIf
	Else
		If oWS:RETORNANOTASNX()
			If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
				For nX := 1 To Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5)
					cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXML
					cProtocolo      := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CPROTOCOLO
					cDHRecbto  		:= oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXMLPROT

					nY := aScan(aIdNfe,{|x| x[4]+x[5] == SubStr(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:CID,1,Len(x[4]+x[5]))})
					If nY > 0
						aRetorno[nY][1] := cProtocolo
						aRetorno[nY][2] := cRetorno

						aadd(aResposta,aIdNfe[nY])
					EndIf
				Next nX
				For nX := 1 To Len(aIdNfe)
					If aScan(aResposta,{|x| x[4] == aIdNfe[nX,04] .And. x[5] == aIdNfe[nX,05] })==0
						aadd(aFalta,aIdNfe[nX])
					EndIf
				Next nX
				If Len(aFalta)>0
					aExecute := GetXML(cIdEnt,aFalta,@cModalidade)
				Else
					aExecute := {}
				EndIf
				For nX := 1 To Len(aExecute)
					nY := aScan(aRetorno,{|x| x[3] == aExecute[nX][03]})
					If nY == 0
						aadd(aRetorno,{aExecute[nX][01],aExecute[nX][02],aExecute[nX][03]})
					Else
						aRetorno[nY][01] := aExecute[nX][01]
						aRetorno[nY][02] := aExecute[nX][02]
					EndIf
				Next nX
			EndIf
		EndIf
	EndIf
Return(aRetorno)

/*/{Protheus.doc} GetIdEnt
Obtem o codigo da entidade apos enviar o post para o Totvs Service
@type function
@author Eduardo Riera
@since 16/06/2007
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function GetIdEnt()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"

	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	EndIf
Return(cIdEnt)

/*/{Protheus.doc} ConsNFeCe
Consulta status da Nota na Receita
@type function
@author Opvs - David
@since 20/08/2012
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
Static Function ConsNFeCe(cIdEnt,nModelo,aParam,lCTe,lMsg)
	Local aListBox := {}
	Local aMsg     := {}
	Local nX       := 0
	Local nY       := 0
	Local nSX3SF2  := TamSx3("F2_DOC")[1]
	Local nLastXml := 0
	Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local lOk      := .T.
	Local oOk      := LoadBitMap(GetResources(), "ENABLE")
	Local oNo      := LoadBitMap(GetResources(), "DISABLE")
	Local oWS
	Local oRetorno
	Local cTextInut:= GetNewPar("MV_TXTINUT","")
	Local aXML       := {}
	Local aNotas     := {}
	Local cModalidade:= ""

	Private oXml
	Private cError := ''
	Default lCTe   := .F.
	Default	lMsg   := .T.

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN    := "TOTVS"
	oWS:cID_ENT       := cIdEnt
	oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"
	If nModelo == 1
		oWS:cIdInicial    := aParam[01]+aParam[02]
		oWS:cIdFinal      := aParam[01]+aParam[03]
		lOk := oWS:MONITORFAIXA()
		oRetorno := oWS:oWsMonitorFaixaResult
	Else
		If VALTYPE(aParam[01]) == "N"
			oWS:nIntervalo := Max((aParam[01]),60)
		Else
			oWS:nIntervalo := Max(Val(aParam[01]),60)
		EndIf
		lOk := oWS:MONITORTEMPO()
		oRetorno := oWS:oWsMonitorTempoResult
	EndIf
	If lOk
		dbSelectArea("SF3")
		dbSetOrder(5)
		For nX := 1 To Len(oRetorno:oWSMONITORNFE)
			aMsg := {}
			oXml := oRetorno:oWSMONITORNFE[nX]
			If Type("oXml:OWSERRO:OWSLOTENFE")<>"U"
				nLastRet := Len(oXml:OWSERRO:OWSLOTENFE)
				For nY := 1 To Len(	oXml:OWSERRO:OWSLOTENFE)
					If oXml:OWSERRO:OWSLOTENFE[nY]:NLOTE<>0
						aadd(aMsg,{oXml:OWSERRO:OWSLOTENFE[nY]:NLOTE,oXml:OWSERRO:OWSLOTENFE[nY]:DDATALOTE,oXml:OWSERRO:OWSLOTENFE[nY]:CHORALOTE,;
						oXml:OWSERRO:OWSLOTENFE[nY]:NRECIBOSEFAZ,;
						oXml:OWSERRO:OWSLOTENFE[nY]:CCODENVLOTE,Alltrim(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGENVLOTE),;
						oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETRECIBO,Alltrim(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETRECIBO),;
						oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETNFE,Alltrim(oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE)})
					EndIf
					SF3->(dbSetOrder(5))
					If SF3->(MsSeek(xFilial("SF3")+oXml:Cid,.T.))
						While !SF3->(Eof()) .And. AllTrim(SF3->(F3_SERIE+F3_NFISCAL))==oXml:Cid
							If SF3->( (Left(F3_CFO,1)>="5" .Or. (Left(F3_CFO,1)<"5" .And. F3_FORMUL=="S")) .And. FieldPos("F3_CODRSEF")<>0)
								RecLock("SF3")
								SF3->F3_CODRSEF:= oXml:OWSERRO:OWSLOTENFE[nY]:CCODRETNFE
								//SE FOR INUTILIZAÇÃO ALTERA NOS LIVROS FISCAIS
								If !Empty(cTextInut)
									If Type("oXml:OWSERRO:OWSLOTENFE["+AllTrim(Str(nY))+"]:CMSGRETNFE")<>"U" .And. ("Inutilizacao de numero homologado" $ oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE .Or. "Inutilização de número homologado" $ oXml:OWSERRO:OWSLOTENFE[nY]:CMSGRETNFE)
										SF3->F3_OBSERV := ALLTRIM(cTextInut)
									EndIf
								EndIF
								MsUnlock()
							EndIf
							SF3->(dbSkip())
						End
					EndIf

					If ExistBlock("FISMNTNFE")
						ExecBlock("FISMNTNFE",.f.,.f.,{oXml:Cid,aMsg})
					Endif

				Next nY

				DbSelectArea("SF3")
				DbSetOrder(5)
				If SF3->(MsSeek(xFilial("SF3")+oXml:Cid,.T.))
					If (SubStr(SF3->F3_CFO,1,1)>="5" .Or. SF3->F3_FORMUL=="S")
						aNotas 	:= {}
						aXml2	:= {}
						aadd(aNotas,{})
						aadd(Atail(aNotas),.F.)
						aadd(Atail(aNotas),IIF(SF3->F3_CFO<"5","E","S"))
						aadd(Atail(aNotas),SF3->F3_ENTRADA)
						aadd(Atail(aNotas),SF3->F3_SERIE)
						aadd(Atail(aNotas),SF3->F3_NFISCAL)
						aadd(Atail(aNotas),SF3->F3_CLIEFOR)
						aadd(Atail(aNotas),SF3->F3_LOJA)
						aXml2 := GetXMLNFE(cIdEnt,aNotas,@cModalidade)

						If ( Len(aXml2) > 0 )
							aAdd(aXml,aXml2[1])
						EndIf

						nLastXml := Len(aXml)
					Else
						nLastXml:= Len(aXml)
					EndIf
				EndIf

				//Nota de saida
				dbSelectArea("SF2")
				dbSetOrder(1)
				If SF2->(MsSeek(xFilial("SF2")+PadR(SUBSTR(oXml:Cid,4,Len(oXml:Cid)),nSX3SF2)+SUBSTR(oXml:Cid,1,3),.T.)) .And. nLastXml > 0 .And. !Empty(aXml)
					If SF2->(FieldPos("F2_HORA"))<>0 .And. (Empty(SF2->F2_HORA) .OR. Empty(SF2->F2_NFELETR) .Or. Empty(SF2->F2_EMINFE) .Or.Empty(SF2->F2_HORNFE) .Or. Empty(SF2->F2_CODNFE) .Or. (SF2->(FieldPos("F2_CHVNFE"))>0 .And. Empty(SF2->F2_CHVNFE)))
						RecLock("SF2")
						//SF2->F2_HORA 	:= SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
						//SF2->F2_NFELETR := SUBSTR(oXml:Cid,4,9)
						//SF2->F2_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
						//SF2->F2_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
						//SF2->F2_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
						If !Empty(aXml[nLastXml][2])
							SF2->F2_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIf
						MsUnlock()
					EndIf

					//Atualizo SF3
					SF3->(dbSetOrder(4))
					cChave := xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE
					If SF3->(MsSeek(xFilial("SF3")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_DOC+SF2->F2_SERIE,.T.))
						Do While cChave == xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
							RecLock("SF3",.F.)
							//SF3->F3_NFELETR	:= SUBSTR(oXml:Cid,4,9)
							//SF3->F3_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
							//SF3->F3_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
							//SF3->F3_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
							If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]) .And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
								SF3->F3_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
							EndIf
							MsUnLock()
							SF3->(dbSkip())
						EndDo
					EndIf

					//Atualizo SFT
					SFT->(dbSetOrder(1))
					cChave := xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA
					If SFT->(MsSeek(xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
						Do While cChave == xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
							RecLock("SFT",.F.)
							//SFT->FT_NFELETR	:= SUBSTR(oXml:Cid,4,9)
							//SFT->FT_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
							//SFT->FT_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
							//SFT->FT_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
							If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
								SFT->FT_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
							EndIf
							MsUnLock()
							SFT->(dbSkip())
						EndDo
					EndIf
				ElseIf !Empty(SF3->F3_DTCANC) .and. SubStr(SF3->F3_CFO,1,1)>="5" //Alimenta Chave da NFe Cancelada na F3/FT ao consultar o monitorfaixa
					SF3->(dbSetOrder(4))
					cChaveF3 := xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
					cChaveFT := xFilial("SFT")+"S"+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
					SF3->(dbSeek(cChaveF3,.T.))
					While !SF3->(Eof()) .And. xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE == cChaveF3
						RecLock("SF3",.F.)
						If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]) .And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
							SF3->F3_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIf
						MsUnLock()
						SF3->(dbSkip())
					EndDo

					SFT->(dbSetOrder(1))
					SFT->(dbSeek(cChaveFT,.T.))
					While !SFT->(Eof()) .And. xFilial("SFT")+"S"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == cChaveFT
						RecLock("SFT",.F.)
						If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
							SFT->FT_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIf
						MsUnLock()
						SFT->(dbSkip())
					EndDo
				EndIf

				//Nota de entrada
				dbSelectArea("SF1")
				dbSetOrder(1)
				If SF1->(MsSeek(xFilial("SF1")+PadR(SUBSTR(oXml:Cid,4,Len(oXml:Cid)),nSX3SF2)+SUBSTR(oXml:Cid,1,3),.T.)) .And. nLastXml > 0 .And. !Empty(aXml)
					If SF1->(FieldPos("F1_HORA"))<>0 .And. (Empty(SF1->F1_HORA) .OR. Empty(SF1->F1_NFELETR) .Or. Empty(SF1->F1_EMINFE) .Or.Empty(SF1->F1_HORNFE) .Or. Empty(SF1->F1_CODNFE) .Or. (SF1->(FieldPos("F1_CHVNFE"))>0 .And. Empty(SF1->F1_CHVNFE)))
						RecLock("SF1")
						//SF1->F1_HORA	:= SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
						//SF1->F1_NFELETR := SUBSTR(oXml:Cid,4,9)
						//SF1->F1_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
						//SF1->F1_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
						//SF1->F1_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
						If !Empty(aXML) .And.!Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
							SF1->F1_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIf
						MsUnlock()
					EndIf

					//Atualizo SF3
					SF3->(dbSetOrder(4))
					cChave := xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE
					If SF3->(MsSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,.T.))
						Do While cChave == xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE .And. !SF3->(Eof())
							RecLock("SF3",.F.)
							//SF3->F3_NFELETR	:= SUBSTR(oXml:Cid,4,9)
							//SF3->F3_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
							//SF3->F3_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
							//SF3->F3_CODNFE	:= IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
							If !Empty(aXML) .And.!Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
								SF3->F3_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
							EndIf
							MsUnLock()
							SF3->(dbSkip())
						EndDo
					EndIf

					//Atualizo SFT
					SFT->(dbSetOrder(1))
					cChave := xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
					If SFT->(MsSeek(xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA,.T.))
						Do While cChave == xFilial("SFT")+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA .And. !SFT->(Eof())
							RecLock("SFT",.F.)
							//SFT->FT_NFELETR	:= SUBSTR(oXml:Cid,4,9)
							//SFT->FT_EMINFE	:= oXml:OWSERRO:OWSLOTENFE[nLastRet]:DDATALOTE
							//SFT->FT_HORNFE	:= STRTRAN(oXml:OWSERRO:OWSLOTENFE[nLastRet]:CHORALOTE,":","")//SUBSTR(oXml:OWSERRO:OWSLOTENFE[nLastRet]:cHORALOTE,1,5)
							//SFT->FT_CODNFE	:=IIF(!Empty(aXml[nLastXml][1]),aXml[nLastXml][1],"")
							If !Empty(aXML) .And.!Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
								SFT->FT_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
							EndIf
							MsUnLock()
							SFT->(dbSkip())
						EndDo
					EndIf
				ElseIf !Empty(SF3->F3_DTCANC) .and. SubStr(SF3->F3_CFO,1,1)<"5" //Alimenta Chave da NFe Cancelada na F3/FT  ao consultar o monitorfaixa
					SF3->(dbSetOrder(4))
					cChaveF3 := xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
					cChaveFT := xFilial("SFT")+"E"+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
					SF3->(dbSeek(cChaveF3,.T.))
					While !SF3->(Eof()) .And. xFilial("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE == cChaveF3
						RecLock("SF3",.F.)
						If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]) .And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
							SF3->F3_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIf
						MsUnLock()
						SF3->(dbSkip())
					EndDo

					SFT->(dbSetOrder(1))
					SFT->(dbSeek(cChaveFT,.T.))
					While !SFT->(Eof()) .And. xFilial("SFT")+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == cChaveFT
						RecLock("SFT",.F.)
						If !Empty(aXML) .And. !Empty(aXml[nLastXml][2]).And. !Empty(aXml[nLastXml][1]) // Inserida verificação do protocolo, antes de gravar a Chave.
							SFT->FT_CHVNFE  := SubStr(NfeIdSPED(aXML[nLastXml][2],"Id"),4)
						EndIf
						MsUnLock()
						SFT->(dbSkip())
					EndDo
				EndIf
			EndIf
			aadd(aListBox,{	IIf(Empty(oXml:cPROTOCOLO),oNo,oOk),;
			oXml:cID,;
			IIf(oXml:nAMBIENTE==1,"Produção","Homologação"),; //"Produção"###"Homologação"
			IIf(oXml:nMODALIDADE==1 .Or. oXml:nMODALIDADE==4 .Or. oXml:nModalidade==6,"Normal","Contingência"),; //"Normal"###"Contingência"
			oXml:cPROTOCOLO,;
			Alltrim(oXml:cRECOMENDACAO),;
			oXml:cTEMPODEESPERA,;
			oXml:nTEMPOMEDIOSEF,;
			aMsg})

			aXml 		:= {}
			nLastXml	:= 0
		Next nX
	Else
		aadd(aListBox,{ oNo,;
		"",;
		"",; //"Produção"###"Homologação"
		"",; //"Normal"###"Contingência"
		"",;
		"",;
		"",;
		"",;
		{"","","","","","","","","",cValToChar(GetWscError(1))+" "+cValToChar(GetWscError(3))}})
	EndIf
Return(aListBox)

/*/{Protheus.doc} filePDF
Verifica se o arquivo pdf existe na pasta spool no servidor,
se não existir, tenta criar através da funcão File2Printer().
@type function
@author Bruno Nunes
@since 20/08/2012
@version P12  17.3.0.8
@build 7.00.170117A-20190627
/*/
static function filePDF( cFile )
	local lGerouPDF := .F.
	
	default cFile := ""
	
	//Se não passar parametro sai da rotina
	if empty( cFile )
		return .F.
	endif
	
	//Verifica se o arquivo existe
	lGerouPDF := file( "\spool\" + cFile )

	if !lGerouPDF
		//caso não existe o arquivo força a crição pela função File2Printer
		lGerouPDF :=  File2Printer("\spool\" + cFile, "PDF") == 0
	EndIf
return lGerouPDF

//função para testar o garr010 lembrar de alterar o danfeii para não tratar como existisse tela.
/*
USER FUNCTION CALLGR10( )
	LOCAL aProc := { .T., "000135", "11107449"  } 
	LOCAL cRandom := ""

	//u_CALLGR10()
	
	SC5->(DbOrderNickName("PEDSITE"))	
	if SC5->( dbSeek( xFilial("SC5") + "11107449" ) )
		SF2->(dbSetOrder(1))
		if SF2->( dbSeek( xFilial("SF2") + "005855475" ) )
			U_GARR010( aProc, @cRandom, .F. )
		endif
	endif
RETURN
*/