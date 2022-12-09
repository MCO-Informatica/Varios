#Include "Protheus.ch"
#Include "RptDef.ch"
#Include "FWPrintSetup.ch"
#Include "Ap5mail.ch"

/*	
DESCRIÇÃO: ROTINA PARA GERAR NF AUTOMATICAMENTE EM PDF E ENVIAR EMAIL
OBS:	   PARA FUNCIONAR, A ROTINA ABAIXO DEVE ESTAR DENTRO DO FONTE DANFEII.PRW.

User Function Prt2NfeSef(cIdEnt, oDanfe, lExistNFe	)

	Local aArea     := GetArea()
	Local lRet		:= .t.
	
	//Variáveis obrigatórias da DANFE (pode colocar outras abaixo)
	Private oRetNF
	Private PixelX := odanfe:nLogPixelX()
	Private PixelY := odanfe:nLogPixelY()
	Private nConsNeg  := 0.4
	Private	nConsTex  := 0.5
	Private	nColAux   := 0

	RPTStatus( {|lEnd| DANFEProc(@oDanfe, @lEnd, cIDEnt, Nil, Nil, @lExistNFe, .f.)}, "Imprimindo DANFE..." )

	RestArea(aArea)

Return lRet
*/

User Function SPDNFDANF()

	Local aAreas := { sf1->(getArea()), sd1->(getArea()), sf2->(getArea()), sd2->(getArea()), sa1->(getArea()), getArea() }

	local cNota      := ParamIXB[1]
	local cSerie     := ParamIXB[2]
	//local cChaveNfe  := ParamIXB[3]
	local cIdEnt     := ParamIXB[4]
	local cClieFor   := ParamIXB[5]
	local cLoja      := ParamIXB[6]

	Local aNf		:= {}
	Local cPastaSrv := "\spool\nfpdf\"	//GetSrvProfString ("ROOTPATH","") // Retorna o RootPath definido no ini do server
	Local cPasta    := "c:\temp\nfpdf\"
	Local lMostra 	:= .t.
	Local lClient   := .f.			//determina se impressão da NF será no servido ou não
	Local nEntSai   := 0			//1 - NF entrada; 2 - NF Saida
	Local aAnexo    := {}

	if cFilAnt == '02'

		sf1->(DbSetOrder(1))
		if sf1->(DbSeek(xFilial()+cNota+cSerie+cClieFor+cLoja))
			nEntSai   := 1
		else
			sf2->(DbSetOrder(1))
			if sf2->(DbSeek(xFilial()+cNota+cSerie+cClieFor+cLoja))
				nEntSai   := 2
			endif
		EndIf

		aNf := verEnvRet(cNota,cSerie,cClieFor,cLoja,nEntSai)
		if len(aNf) > 0

			if !verPasta(cPastaSrv)
				return
			endif
			if lClient
				if !verPasta(cPasta)
					return
				endif
			else
				cPasta := cPastaSrv
			endif

			aAnexo := geraPdfNf(aNf,cIdEnt,nEntSai,cPasta,lClient,lMostra)
			if nEntSai == 1
				restArea(aAreas[1])  // reposiciona SF1 após fim do término da impressão da NF
			else
				restArea(aAreas[3])  // reposiciona SF2 após fim do término da impressão da NF
			endif

			if len(aAnexo) > 0
				envRetMail(aAnexo,nEntSai,cPasta,cPastaSrv,lClient,lMostra)		// Envia NF de produtos por email
			endif

		endif

		aEval(aAreas, {|x| RestArea(x) })
	endif

Return

Static Function verEnvRet(cdoc,cserie,cfornece,cloja,nEntSai)
	Local aRet		:= {}
	Local clTesRet  := ""   // Conterá os TES serão consideradas para enviar o email

	if nEntSai == 1
		clTesRet := getNewPar("MV_XTESRET","144;146;147;148")
		sd1->(dbSetorder(1))
		sd1->(dbSeek(xFilial() + cdoc + cserie + cfornece + cloja))
		While !sd1->(Eof()) .and. cdoc == sd1->d1_doc .and. cserie == sd1->d1_serie .and. ;
				cfornece == sd1->d1_fornece .and. cloja == sd1->d1_loja
			if sd1->d1_tes $ clTesRet .and. !empty(sd1->d1_nfori)
				if aScan(aRet,{|x| x[1]+x[2] == sd1->d1_doc+sd1->d1_serie }) == 0
					aAdd(aRet, {sd1->d1_doc,sd1->d1_serie} )
				endif
			endif
			sd1->(dbSkip())
		end
	else
		clTesRet := getNewPar("MV_XTESREM","560;559;561;562")
		sd2->(dbSetorder(3))
		sd2->(dbSeek(xFilial() + cdoc + cserie + cfornece + cloja))
		While !sd2->(Eof()) .and. cdoc == sd2->d2_doc .and. cserie == sd2->d2_serie .and. ;
				cfornece == sd2->d2_cliente .and. cloja == sd2->d2_loja
			if sd2->d2_tes $ clTesRet
				if aScan(aRet,{|x| x[1]+x[2] == sd2->d2_doc+sd2->d2_serie }) == 0
					aAdd(aRet, {sd2->d2_doc,sd2->d2_serie} )
				endif
			endif
			sd2->(dbSkip())
		end
	endif

Return(aRet)

static function verPasta(cPasta)
	Local lRet := .t.
	Local nI   := 0
	Local cParte := ""

	for nI := 1 to len(cPasta)
		if substr(cPasta,nI,1) == "\" .and. nI > 1
			if !ExistDir(cParte)
				if MakeDir(cParte) != 0
					lRet := .f.
					conout( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
					If lMostra
						msginfo("Não foi possível criar o diretório. Erro: " + cValToChar( FError() ),"Advertência")
					EndIf
				endif
			endif
		endif
		cParte += substr(cPasta,nI,1)
	next

return(lRet)

Static Function geraPdfNf(aNf,cIdEnt,nEntSai,cPasta,lServer,lMostra)
	Local nI 		:= 0
	Local cNota  	:= ""
	Local cSerie 	:= ""
	Local cArquivo  := ""
	Local aArqPdf   := {}
	Local lExistNFe := .f.
	Local oDanfe

	Default lServer := .f.	//Indica impressão via Server (.REL Não será copiado para o Client). Default é .F.
	Default lMostra := .t.

	For nI := 1 to len(aNf)

		cNota := aNf[nI,1]
		cSerie:= aNf[nI,2]
		If !Empty(cNota)
            
            cArquivo := alltrim(cNota)+"_"+alltrim(cSerie)+"_"+DtoS(Date())+"_"+StrTran(Time(),":","")

			Pergunte("NFSIGW",.f.)
			MV_PAR01 := PadR(cNota,  TamSX3('F2_DOC')[1])       //Nota Inicial
			MV_PAR02 := PadR(cNota,  TamSX3('F2_DOC')[1])       //Nota Final
			MV_PAR03 := PadR(cSerie, TamSX3('F2_SERIE')[1])     //Série da Nota
			MV_PAR04 := nEntSai                                 //1 - NF entrada; 2 - NF Saida
			MV_PAR05 := 2                                       //Frente e Verso
			MV_PAR06 := 2                                       //DANFE simplificado
			MV_PAR07 := StoD('20000101')
			MV_PAR08 := Date()

			//Cria a Danfe
			oDanfe := FwMSPrinter():New(cArquivo, IMP_PDF, .f., cPasta, .t., , , , , .f., ,.f. )
			//Propriedades da DANFE
			oDanfe:SetResolution(78)
			oDanfe:SetPortrait()
			oDanfe:SetPaperSize(DMPAPER_A4)
			oDanfe:SetMargin(60, 60, 60, 60)
			oDanfe:lServer  := lServer
			//Força a impressão em PDF
			oDanfe:nDevice  := 6
			oDanfe:lViewPDF := .f.
			oDanfe:cPathPDF := cPasta

			//Chamando a impressão da danfe no RDMAKE
			RptStatus( {| lEnd | u_Prt2NfeSef(cIdEnt, @oDanfe, @lExistNFe) }, "Imprimindo Danfe...")
			If lExistNFe
				//oDanfe:Preview()	//Visualiza antes de imprimir
				oDanfe:Print()
			endif
			if file(cPasta+cArquivo+".pdf")
				aAdd(aArqPdf, {cArquivo,cNota,cSerie})
			endif
		else	//Caso não encontre as notas, mostra mensagem
			ConOut("Advertência > Documento e série não encontrados ("+cNota+"/"+cSerie+")...")
			If lMostra
				msginfo("Documento e série não encontrados ("+cNota+"/"+cSerie+")...","Advertência")
			EndIf

		endif

	next

return(aArqPdf)

Static Function	envRetMail(aAnexo,nEntSai,cPasta,cPastaSrv,lClient,lMostra)	// Envia NF de produtos por email
	Local cEmailTo  := ""
	Local cAssunto  := ""
	Local cMensagem := ""
	Local nI 		:= 0
	Local aTmp		:= {}

	for nI := 1 to len(aAnexo)
		if lClient .and. !CpyT2S( cPasta+aAnexo[nI,1]+".pdf",cPastaSrv,/*lCompress*/,/*lChangeCase*/)
			conout("Não foi possível copiar a NF para o servidor. Email não encaminhado!")
			If lMostra
				msginfo("Não foi possível copiar a NF para o servidor. Email não encaminhado!","Advertência")
			EndIf
			Return
		else
			if lClient
				FErase(cPasta+aAnexo[nI,1]+".pdf")
			endif
			aAnexo[nI,1] := cPastaSrv+"\"+aAnexo[nI,1]+".pdf"
		endif
	next

    if nEntSai == 1
        cOperacao := "Retorno"
    else
        cOperacao := "Remessa"
    endif

	cEmailTo := getNewPar("MV_XEMARET","thiago@playpiso.com.br")
	cAssunto := "Documento de "+cOperacao
	cMensagem := "Emitido(s) o(s) Documento(s) de "+cOperacao+": " + Chr(13) + Chr(10)
	aTmp := {}
	for nI := 1 to len(aAnexo)
		if nI > 1
			cMensagem += ", "
		endif
		cMensagem += "NF: "+aAnexo[nI,2]+" Série: "+alltrim(aAnexo[nI,3]) + Chr(13) + Chr(10)
		aadd(aTmp, aAnexo[nI,1])
	next
	cMensagem += "Favor verificar"
	aAnexo := aTmp

	if envMail(cEmailTo ,cAssunto ,cMensagem ,aAnexo)
		for nI := 1 to len(aAnexo)
			FErase(aAnexo[nI])
		next
	endif

Return

Static Function envMail(cEmailTo ,cAssunto ,cMensagem ,aAnexo)
	Local nI       := 0
	Local cAnexos  := ""
	Local cServidor := GetMV("MV_RELSERV")
	Local cConta    := GetMV("MV_RELACNT")
	Local cSenha    := GetMV("MV_RELPSW")
	Local lAuth     := GetMv("MV_RELAUTH") // Parametro que indica se existe autenticacao no e-mail
	Local lConectou := .f.

	CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cSenha Result lConectou
	// Se a conexao com o SMPT esta ok
	If lConectou
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If !lAuth .or. Mailauth(cConta,cSenha)

			For nI:=1 to Len(aAnexo)
				cAnexos+=aAnexo[nI]+";"
			Next
			cAnexos:=Left(cAnexos,Len(cAnexos)-1)

			if empty(cAnexos)
				SEND MAIL FROM cConta ;
					TO cEmailTo;
					SUBJECT cAssunto;
					BODY cMensagem;
					RESULT lConectou
			else

				SEND MAIL FROM cConta ;
					TO cEmailTo;
					SUBJECT cAssunto;
					BODY cMensagem;
					ATTACHMENT cAnexos ;
					RESULT lConectou
			endif
			If !lConectou
				//Erro no envio do email
				GET MAIL ERROR cError
				Help(" ",1,'Erro no Envio do Email',,cError+ " " + cEmailTo,4,5) //Atenção
			Endif
		Else
			GET MAIL ERROR cError
			Help(" ",1,'Autenticação',,cError,4,5) //"Autenticacao"
			MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') //"Erro de autenticação","Verifique a conta e a senha para envio"
		Endif

		DISCONNECT SMTP SERVER

	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,'Erro no Envio do Email',,cError,4,5) //Atencao
	Endif

Return(lConectou)
