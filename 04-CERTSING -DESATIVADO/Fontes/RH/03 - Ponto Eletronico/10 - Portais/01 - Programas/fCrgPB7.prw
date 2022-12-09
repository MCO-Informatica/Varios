#INCLUDE "PROTHEUS.ch"
#INCLUDE "topconn.ch"

#DEFINE cPARAM_CAMINHO    "PARAM_CAMINHO"
#DEFINE cPARAM_MODO_DEBUG "PARAM_MODO_DEBUG"

#DEFINE cMSG1 "Prezado(a) analista, a carga para Portal do Ponto Eletrônico não foi feita para os colaboradores "+;
 			  "na lista abaixo pois não esta cadastrado o grupo de aprovação no cadastro "+;
 			  "de participantes."
#DEFINE cTITULO_EMAIL 	"Processo - Carga para o Portal do Ponto Eletrônico"
#DEFINE aTITULO_TABELA 	{'Filial','Colaborador','Centro de Custo','Departamento'}
#DEFINE aTYPE_COL 		{'T', 'T', 'T', 'T'}
#DEFINE aALIGN_COL 		{'left', 'left', 'left', 'left'}

#DEFINE cTIT_SEM_GRUPO_APROVACA0 "Atenção. Colaboradores sem grupo de aprovação"
#DEFINE cMSG_SEM_GRUPO_APROVACA0 "Alguns colaboradores estão sem grupo de aprovação, foi enviado um email "+;
								 "com a lista dos colaboradores que estão sem grupo de aprovação no "+;
								 "cadastro de participante."

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} fCRGPB7
Carrega PB7 caso ocorra problema na rotina automatica.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $29.11.2016}
/*/
//------------------------------------------------------------------------------------------
User Function fCRGPB7()

	local bProcesso := {|oSelf| CrgProc( oSelf )}

	Private cCadastro  := "Carga da PB7 manualmente."
	Private cDescricao := "Esta rotina efetuara a carga da PB7 baseado no parametro de data informado na rotina."

	tNewProcess():New( "CrgProc" , cCadastro , bProcesso , cDescricao , ,,,,,.T.,.F. )

Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CrgProc
Seleção de Funcionarios.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $29.11.2016}
/*/
//------------------------------------------------------------------------------------------
Static Function CrgProc(oSelf)

	local cQuery    := ""
	local cAlsRA    := GetNextAlias()
	local aParamBox := {}
	local bProcesso := {|oSelf| fCarga( oSelf ) }
	local cTitulo   := "Carga das tabelas de marcações do portal."
	local cObjetiv  := "Carrega a tabela PB7 (Marcações Portal) com as marcações já lidas dos relógios."
	local nRec		:= 0

	//-> Variaveis para Tela e Objetos do ListBox
	local oDlgBrw, oListBox
	local aSizeDlg := MsAdvSize()
	local aObjects := {}
	local aInfo    := {}
	local aPosObj  := {}
	local aBitMaps := { LoadBitmap(GetResources(), "LBOK"), LoadBitmap(GetResources(), "LBNO") }

	Private aRet     := {}
	Private cPerApo  := ""
	Private dDiaIni  := CToD("  /  /    ")
	Private dDiaFim  := CToD("  /  /    ")
	Private aListFun := {}

	aAdd(aParamBox,{1,"Período apontamento De :" ,CTOD("  /  /   ")  ,"" ,"" ,""      ,"",0   ,.T.}) //1
	aAdd(aParamBox,{1,"Período apontamento Até :",CTOD("  /  /   ")  ,"" ,"" ,""      ,"",0   ,.T.}) //2
	aAdd(aParamBox,{1,"Filial De :"              ,Space(2)           ,"" ,"" ,"XM0"   ,"02",0 ,.T.}) //3
	aAdd(aParamBox,{1,"Filial Até :"             ,Space(2)           ,"" ,"" ,"XM0"   ,"02",0 ,.T.}) //4
	aAdd(aParamBox,{1,"Matrícula De :"           ,Space(6)           ,"" ,"" ,"SRA"   ,"06",0 ,.T.}) //5
	aAdd(aParamBox,{1,"Matrícula Até :"          ,Space(6)           ,"" ,"" ,"SRA"   ,"06",0 ,.T.}) //6
	aAdd(aParamBox,{1,"C. Custo De :"            ,Space(9)           ,"" ,"" ,"CTT"   ,"09",0 ,.T.}) //7
	aAdd(aParamBox,{1,"C. Custo Até :"           ,Space(9)           ,"" ,"" ,"CTT"   ,"09",0 ,.T.}) //8
	aAdd(aParamBox,{4,"Carga Posto"              ,.F.                ,"" ,75 ,""      , .F.       }) //9

	If ParamBox(aParamBox,"Carga de Marcações no Portal",@aRet)
		//cPerApo   := u_fChkPer(aRet[1])
		cPerApo   := dtos( aRet[1] )+dtos( aRet[2] )
		dDiaIni   := aRet[1]
		dDiaFim   := aRet[2]

		cQuery := "SELECT  RA_FILIAL      AS MX_FILIAL "+CRLF
		cQuery += "       ,CTT_DESC01     AS MC_CC     "+CRLF
		cQuery += "       ,RA_MAT         AS MX_MAT    "+CRLF
		cQuery += "       ,RA_NOME        AS MX_NOME   "+CRLF
		cQuery += "       ,R6_TURNO       AS MX_CODTNO "+CRLF
		cQuery += "       ,R6_DESC        AS MX_DSCTNO "+CRLF
		cQuery += "FROM "+RetSqlName("SRA")+" SRA "+CRLF
		cQuery += "INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_CUSTO = RA_CC      "+CRLF
		cQuery += "INNER JOIN "+RetSqlName("SR6")+" SR6 ON R6_TURNO  = RA_TNOTRAB "+CRLF
		cQuery += "WHERE SRA.D_E_L_E_T_ <> '*'    "+CRLF
		cQuery += "  AND CTT.D_E_L_E_T_ <> '*'    "+CRLF
		cQuery += "  AND SR6.D_E_L_E_T_ <> '*'    "+CRLF
		cQuery += "  AND RA_FILIAL BETWEEN '"+AllTrim(aRet[3])+"' AND '"+AllTrim(aRet[4])+"' "+CRLF
		cQuery += "  AND RA_MAT    BETWEEN '"+AllTrim(aRet[5])+"' AND '"+AllTrim(aRet[6])+"' "+CRLF
		cQuery += "  AND RA_CC     BETWEEN '"+AllTrim(aRet[7])+"' AND '"+AllTrim(aRet[8])+"' "+CRLF
		cQuery += "  AND RA_REGRA <> '99'  "+CRLF
		cQuery += "  AND RA_TNOTRAB <> ' ' "+CRLF
		cQuery += "  AND RA_SITFOLH <> 'D' "+CRLF

		If aRet[9] //-> Se verdadeiro, carrega apenas marcações de postos.
			cQuery += "  AND NOT EXISTS(SELECT 1   "+CRLF
		Else
			cQuery += "  AND     EXISTS(SELECT 1   "+CRLF
		EndIf

		cQuery += "             FROM "+RetSqlName("SP8")+"  "+CRLF
		cQuery += "             WHERE D_E_L_E_T_ <> '*'     "+CRLF
		cQuery += "               AND P8_FILIAL = RA_FILIAL "+CRLF
		cQuery += "               AND P8_MAT    = RA_MAT    "+CRLF
		cQuery += "               AND P8_DATA BETWEEN '"+DToS(aRet[1])+"' AND '"+DToS(aRet[2])+"') "+CRLF
		cQuery += "ORDER BY RA_FILIAL, RA_MAT "+CRLF
		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlsRA)

		(cAlsRA)->(dbGoTop())

		//oSelf:SetRegua1( (cAlsRA)->(RecCount()) ) O RECCOUNT NÃO FUNCIONA NO VERSAO P12
		Count To nRec
		(cAlsRA)->(dbGoTop())
		oSelf:SetRegua1( nRec )

		While (cAlsRA)->(!Eof())

			oSelf:IncRegua1( "Selecionando colaboradores..."+(cAlsRA)->(MX_FILIAL+" - "+MX_MAT+" - "+MX_NOME)+" .Aguarde.")
			If oSelf:lEnd
				Break
			EndIf

			AADD(aListFun, {.F.,;              //-> Seleção da Lista.
			(cAlsRA)->MX_FILIAL,;
			(cAlsRA)->MC_CC,;
			(cAlsRA)->MX_MAT,;
			(cAlsRA)->MX_NOME,;
			(cAlsRA)->MX_CODTNO,;
			(cAlsRA)->MX_DSCTNO;
			})

			(cAlsRA)->( dbSkip() )

		EndDo

		If !Empty(aListFun)

			aObjects := {}

			AaDd( aObjects, { 100, 100, .T., .T. } )
			AaDd( aObjects, { 100, 015, .T., .F. } )

			aInfo   := { aSizeDlg[1], aSizeDlg[2], aSizeDlg[3], aSizeDlg[4], 3, 3 }
			aPosObj := MsObjSize( aInfo, aObjects )

			Define MsDialog oDlgBrw From aSizeDlg[7],0 To aSizeDlg[6], aSizeDlg[5] Title "Seleção de Colaboradores" Of oMainWnd Pixel
			@aPosObj[1,1], aPosObj[1,2] ListBox oListBox Fields HEADER "X", "Filial", "C.Custo", "Matricula", "Nome", "Cod.Turno", "Desc.Turno";
			Size aPosObj[1,4]-aPosObj[1,2], aPosObj[1,3]-aPosObj[1,1]  Pixel

			oListBox:SetArray( aListFun )
			oListBox:bLDbLClick := { || fChkAll(), oListBox:Refresh()}
			oListBox:bRClicked  := { || ( aListFun[oListBox:nAT,1] := !aListFun[oListBox:nAT,1], oListBox:Refresh() ) }
			oListBox:bLine      := { || { IIF( aListFun[oListBox:nAT,1], aBitMaps[1], aBitMaps[2] ),;
			aListFun[oListBox:nAT,2],;
			aListFun[oListBox:nAT,3],;
			aListFun[oListBox:nAT,4],;
			aListFun[oListBox:nAT,5],;
			aListFun[oListBox:nAT,6],;
			aListFun[oListBox:nAT,7] } }


			Define SButton From aPosObj[2,1], aPosObj[2,4]-140 Type 1 Action ( tNewProcess():New( "fCarga", cTitulo, bProcesso, cObjetiv,,,,,,.T.,.F. ), oDlgBrw:End() ) Enable Of oDlgBrw
			Define SButton From aPosObj[2,1], aPosObj[2,4]-070 Type 2 Action ( oDlgBrw:End() ) Enable Of oDlgBrw

			Activate MsDialog oDlgBrw
		EndIf

		(cAlsRA)->( dbCloseArea() )

	Endif


Return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} fCarga
Carrega PB7 caso ocorra problema na rotina automatica.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $29.11.2016}
/*/
//------------------------------------------------------------------------------------------
Static Function fCarga(oSelf)
	local nX := 0
	local aFuncSmGrp := {}

	oSelf:SetRegua1( Len(aListFun) )
	If !Empty(aListFun) .And. AScan(aListFun, {|X| x[1] = .T.}) > 0
		For nX := 1 To Len(aListFun)
			oSelf:IncRegua1( "Carregando Marcações.: "+aListFun[nX][02]+" - "+aListFun[nX][04]+" - "+aListFun[nX][05]+" ...aguarde." )
			If oSelf:lEnd
				Break
			EndIf
			If aListFun[nX][01]
				SRA->( dbSelectArea("SRA") )
				SRA->( dbSetOrder(1))
				if SRA->( dbSeek( aListFun[nX][02]+aListFun[nX][04] ) )
					if SRA->RA_REGRA <> '99'
						if validGrupo( SRA->RA_FILIAL, SRA->RA_MAT )
							//CSRH012(cFil,             cMatricula, cPonMes, cIdLog                                   , dDiaDe, dDiaAte )
							U_CSRH012( SRA->RA_FILIAL, SRA->RA_MAT, cPerApo, 'PONM010_'+SRA->RA_FILIAL+'_'+SRA->RA_MAT, dDiaIni, dDiaFim  )
						else
							aAdd( aFuncSmGrp, {SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_NOME, SRA->RA_CC, SRA->RA_DEPTO} )
						endif
					endif
				endif
			EndIf
		Next nX
		if !empty(aFuncSmGrp)
			geraEmail(aFuncSmGrp)
			msgInfo( cMSG_SEM_GRUPO_APROVACA0, cTIT_SEM_GRUPO_APROVACA0 )
		endif
	EndIf
Return

Static Function fChkAll()

	local nX := 0

	For nX := 1 To Len(aListFun)
		aListFun[nX][1] := If( aListFun[nX][1] = .T., .F. ,.T. )
	Next nX

Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} fChkPer
Reposiciona a visão do periodo em manutenção, conforme as datas de inicio e fim informadas nos perguntes da rotina.

@author    Alexandre Alves da Silva
@version   1.xx
@since     $03.05.2017}
/*/
//------------------------------------------------------------------------------------------
User Function fChkPer(dDiaIni)

	local nPosBar  := 0
	local cPeriodo := AllTrim( GetMv("MV_PONMES") )
	local dPerIni  := CToD("  /  /    ")
	local dPerFim  := CToD("  /  /    ")

	nPosBar := Rat("/",cPeriodo)
	If nPosBar > 0
		cPeriodo := AllTrim( Substr(cPeriodo,1,(nPosBar-1)) + Substr(cPeriodo,(nPosBar+1), Len(cPeriodo) - nPosBar  ) )
	EnDif

	dPerIni  := STOD(SubStr(cPeriodo,01,08))
	dPerFim  := STOD(SubStr(cPeriodo,09,08))

	If dDiaIni > dPerFim

		cDPIni := (   Day(dPerFim) + 1)
		cMPIni :=   Month(dPerFim)
		cAPIni :=    Year(dPerFim)

		If cMPIni = 12
			cDPFim := StrZero(Day(dPerFim),2)
			cMPFim := "01"
			cAPFim := StrZero((cAPIni + 1),4)
		Else
			cDPFim := StrZero(Day(dPerFim) ,2)
			cMPFim := StrZero((cMPIni + 1) ,2)
			cAPFim := StrZero(Year(dPerFim),4)
		EndIf

		cDPIni := StrZero(cDPIni,2)
		cMPIni := StrZero(cMPIni,2)
		cAPIni := StrZero(cAPIni,4)

		cPeriodo :=  (cAPIni + cMPIni + cDPIni) + (cAPFim + cMPFim + cDPFim)
	EndIf

Return(cPeriodo)
//--< fim de arquivo >----------------------------------------------------------------------

static function geraEmail( aListaFunc )
	local aHeader	:= {}  	//Dados que irao compor o envio do email
	local nTempo    := 0
	local nTempoFim := 0
	local i         := 0
	local aArea     := GetArea()
	local aAux := {}
	local aLista := {}
	local cEmail := usrRetMail (RetCodUsr())


	private lModoDebug := .F.

	default aListaFunc := {}

	if empty(aListaFunc)
		return
	endif

	if empty(cEmail)
		alert("Usuário do Protheus sem email cadastro. Contate o departamento Sistemas Corporativo para cadastramento do email.")
		return
	endif

	//Configura caminho do portal GCH
	if empty( GetGlbValue( cPARAM_CAMINHO ) ) .or. empty( GetGlbValue( cPARAM_MODO_DEBUG ) )
		u_ParamPtE()
	endif

	if GetGlbValue(cPARAM_MODO_DEBUG) == "1"
		lModoDebug := .T.
	endif

	if lModoDebug
		nTempo := seconds()
		conout("	fCrgPB7 iniciado em: " + dtoc( msDate() ) + " as " + time() )
	endif

	for i := 1 to len( aListaFunc )
		aAux := {}
		aAdd( aAux, alltrim( aListaFunc[i][1] ) )
		aAdd( aAux, alltrim( aListaFunc[i][2] ) + " - " + alltrim( aListaFunc[i][3] ) )
		aAdd( aAux, alltrim( aListaFunc[i][4] ) + " - " + alltrim( posicione( "CTT", 1, xFilial("CTT") + aListaFunc[i][4], "CTT_DESC01" )))
		aAdd( aAux, alltrim( aListaFunc[i][5] ) + " - " + alltrim( posicione( "SQB", 1, xFilial("SQB") + aListaFunc[i][5], "QB_DESCRIC" )))
		aAdd( aLista, aAux )
	next i

	if !empty( aLista )
		aAdd( aHeader, cEmail  )
		aAdd( aHeader, cMSG1 )

		envEmail( aHeader, cTITULO_EMAIL, aLista )
	endif


	if lModoDebug
		nTempoFim := seconds()
		conout("	Tempo de execucao: " + cValToChar( nTempoFim - nTempo ) + " segundos" )
		conout("	fCrgPB7 encerrado em: " + dtoc( msDate() ) + " as " + time() )
	endif
	RestArea(aArea)
Return

/*/{Protheus.doc} EnvEmail
Envia email conforme parametros
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param aHeader, array, [1] - codigo do usario aprovador; [2] - email do usuario aprovador -- UsrRetMail(); [3] - nome do usuario aprovador; [4] - Mensagem titulo
@param aTypeCol, array, Tipo de coluna (T - Texto, N - Númerico, A - Link)
@param cTituloEmail, string, Título de email
@param aTabTitulo, array, Mensagem que sera montada no email

@return nulo
/*/
Static Function envEmail(aHeader, cTituloEmail, aListaFunc )
	local chtml 	  := '' //Strinf com html
	local cEmailAprov := '' //Email do aprovador
	local cMsgHTML 	  := '' //Mensagem do email
	local aLinha      := {}
	local nLinha      := 0
	local nColuna     := 0
	local cClassLin   := ""

	Default aHeader 	 := {}
	Default cTituloEmail := 'Email enviado pelo Protheus'
	default aListaFunc   := {}

	cEmailAprov := aHeader[1] //email do usuario aprovador
	cMsgHTML 	:= aHeader[2]

	//Inicia construcao do html
	chtml += '<!DOCTYPE HTML>'
	chtml += '<html>'
	chtml += '	<head>'
	chtml += '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> '
	chtml += '	</head>'
	chtml += '	<body style="font-family: Fontin Roman, Lucida Sans Unicode">'
	chtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630" >'
	chtml += '		<tr>'
	chtml += '			<td valign="top" align="center">'
	chtml += '				<table width="627">'
	chtml += '					<tr>'
	chtml += '						<td valign="middle" align="left" style="border-bottom:2px solid #FE5000;">'
	chtml += '							<h2>'
	chtml += '								<span style="color:#FE5000" ><strong>'+cTituloEmail+'</strong></span>'
	chtml += '								<br />'
	chtml += '								<span style="color:#003087" >Recursos Humanos</span>'
	chtml += '							</h2>'
	chtml += '						</td>'
	chtml += '						<td valign="top" align="left" style="border-bottom:2px solid #FE5000;">'
	chtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
	chtml += '						</td>'
	chtml += '					</tr>'
	chtml += '				</table>'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>'+cMsgHTML+'<br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'

	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>Lista de colaboradores sem grupo de aprovação: <br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'

	//Lista do grupo de aprovção
	if len(aListaFunc) > 0
		chtml += '		<tr>'
		chtml += '			<td valign="top"  align="center" >'
		chtml += '				<table border="0" cellpadding="0" cellspacing="0" style="width:90%;">'
		chtml += '					<thead  >'
		chtml += '						<tr>'
		for nLinha := 1 to len(aTITULO_TABELA)
			chtml += '						<th align="'+aALIGN_COL[nLinha]+'" style="border-bottom:1px solid ; margin-right:5px; " >'+alltrim(aTITULO_TABELA[nLinha])+'</th>' //Monta cabecalho da tabela
		next nLinha
		chtml += '						</tr>'
		chtml += '					</thead>'
		for nLinha := 1 to len(aListaFunc)
			aLinha := aListaFunc[nLinha]

			iif (cClassLin == 'bgcolor=#FFFFFF', cClassLin := 'bgcolor=#DCDCDC', cClassLin := 'bgcolor=#FFFFFF')
			chtml += '				<tbody>'
			chtml += '					<tr>'
			for nColuna := 1 to len(aLinha)
				if aTYPE_COL[nColuna] == 'T'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span>'+alltrim(left(Capital(aLinha[nColuna]),75))+'</span></div></td>' //insere coluna
				elseif aTYPE_COL[nColuna] == 'N'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span>'+cValToChar(aLinha[nColuna])+'</span></div></td>' //insere coluna
				elseif aTYPE_COL[nColuna] == 'A'
					chtml += '				<td valign="top" '+cClassLin+' align="'+aALIGN_COL[nColuna]+'"  ><div><span><a href="'+alltrim(aLinha[nColuna])+'">Aprovar / Reprovar</a></span></div></td>'  //insere coluna
				endif
			next nColuna
			chtml += '					</tr>'
		next nLinha
		chtml += '					</tbody>'
		chtml += '				</table>'
		chtml += '			</td>'
		chtml += '		</tr>'
	endif

	chtml += '		<tr>'
	chtml += '			<td valign="top" style="border-bottom:2px solid #003087; " >'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" colspan="2" style="padding:5px" width="0">'
	chtml += '				<p align="left">'
	chtml += '					<em style="color:#666666;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em>'
	chtml += '				</p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	chtml += '	</table>'
	chtml += '	</body>'
	chtml += '</html>'

	//Rotina de envio de email
	FsSendMail(cEmailAprov, cTituloEmail, chtml)

	if lModoDebug
		conout("	|")
		conout("	+---> Enviado para: "+cEmailAprov + " Titulo: "+cTituloEmail )
		conout("	|")
		conout("	+---> Processado em: "+dtoc(msDate()) + " Por: " + RetCodUsr() + " - "+ usrFullName(RetCodUsr()) )
		conout("")
	endif
Return

static function validGrupo( cFilMat, cMat )
	local lRetorno := .F.
	RDZ->(dbSetOrder(1))
	if RDZ->( dbSeek( xFilial('RDZ') + FWCodEmp() + cFilMat + 'SRA' + cFilMat + cMat ))
		RD0->(dbSetOrder(1))
		if RD0->( dbSeek( xFilial('RD0') + RDZ->RDZ_CODRD0 ))
			if !empty( RD0->RD0_GRPAPV )
				lRetorno := .T.
			endif
		endif
	endif
return lRetorno