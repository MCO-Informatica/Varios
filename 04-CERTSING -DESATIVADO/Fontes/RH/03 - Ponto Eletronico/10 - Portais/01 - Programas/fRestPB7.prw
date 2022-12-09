#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#include 'parmtype.ch'
#INCLUDE 'FILEIO.CH'
#INCLUDE 'TbiConn.ch'

#DEFINE cPARAM_CAMINHO    'PARAM_CAMINHO'
#DEFINE cPARAM_MODO_DEBUG 'PARAM_MODO_DEBUG'

#DEFINE cMSG1 'Prezado(a) [xx], seus apontamentos foram revertidos pelo analista [yy]. '
#DEFINE cMSG1_APROVADOR 'Prezado(a) [xx], seus apontamentos foram revertidos pelo aprovador(a) [yy]. '
#DEFINE cMSG1_MINHA_REVERSAO 'Prezado(a) [xx], você reverteu sua folha de ponto. '
#DEFINE cMSG2 'Solicitamos que acesse Portal do Ponto e efetue o envio para aprovação novamente.'
#DEFINE cMSG3 'Ao finalizar a manutenção dos apontamentos, pressione o botão enviar apontamento.'
#DEFINE cTITULO_EMAIL 	'Reversão dos Apontamentos Pendentes.'

User Function fRestPB7(lRemote, cGrupo, cFilMat, cMat, cPeriodo, cAprovador, cTpUsuario )
	/*+---------------------+-------------------------------------------------------------------------------------------------------------+
	| Rotina.: fRestPB7() | Restaura os Status das justificativas do portal do Ponto Eletronico.                                        |
	+---------------------+-------------------------------------------------------------------------------------------------------------+
	| Objetivo.: Restaura os Status das justificativas do portal do Ponto Eletronico.                                                   |
	+-----------------------------------------------------------------------------------------------------------------------------------+
	| Observacao.: Uso restrito a equie de TI, com acesso de Administrador.                                                             |
	+-----------------------------------------------------------------------------------------------------------------------------------+
	*/
	Local bProcesso := {|| .T.}

	Private cCadastro  := "Restaura Justificativas de Marcações ao Status Inicial."
	Private cDescricao := "Restaura Status 6 da PB7."

	default lRemote    := .F.
	default cGrupo     := ''
	default cFilMat    := ''
	default cMat	   := ''
	default cPeriodo   := ''
	default cAprovador := ""
	default cTpUsuario := ""

	if lRemote
		if !empty(cFilMat) .and. !empty(cMat) .and. !empty(cPeriodo) ;
		.or.  !empty(cGrupo)
			fProcPB7( bProcesso, lRemote, cGrupo, cFilMat, cMat, cPeriodo, cAprovador, cTpUsuario )
		endif
	else
		bProcesso := {|oSelf| fProcPB7( oSelf )}
		tNewProcess():New( "fRestPB7" , cCadastro , bProcesso , cDescricao ,,,,,,.T.,.F. )
	endif

Return

Static Function fProcPB7( oSelf, lRemote, cGrupo, cFilMat, cMat, cPeriodo, cAprovador, cTpUsuario )
	local aFunc        := {}
	Local aParamBox    := {} //-> Parambox para peguntas da rotina.
	Local aRet         := {} //-> Uso no PARAMBOX.
	Local cQuery       := ""
	Local cPonMes      := ""
	Local cPB7Tb       := GetNextAlias()
	Local lProcess     := .F.

	Private  cUsr      := ""

	default lRemote    := .F.
	default cGrupo     := ""
	default cFilMat    := ""
	default cMat	   := ""
	default cPeriodo   := ""
	default cAprovador := ""
	default cTpUsuario := ""

	if lRemote
		//-> Varrendo registros passiveis de restauração.
		cQuery := "SELECT PB7_FILIAL AS FIL,                       "+CRLF
		cQuery += "       PB7_MAT    AS MAT,                       "+CRLF
		cQuery += "       R_E_C_N_O_ AS REC,                       "+CRLF
		cQuery += "       PB7_VERSAO AS VERS                       "+CRLF
		cQuery += "FROM "+RetSqlName("PB7")+" PB7                  "+CRLF
		cQuery += "INNER JOIN (SELECT PB7B.PB7_FILIAL      AS FIL  "+CRLF
		cQuery += "                  ,PB7B.PB7_MAT         AS MAT  "+CRLF
		cQuery += "                  ,PB7B.PB7_DATA        AS DTA  "+CRLF
		cQuery += "                  ,MAX(PB7B.PB7_VERSAO) AS VRS  "+CRLF
		cQuery += "            FROM "+RetSqlName("PB7")+"  PB7B    "+CRLF
		cQuery += "            WHERE  PB7B.D_E_L_E_T_ <> '*'       "+CRLF
		if !empty(cGrupo)
			cQuery += "  AND PB7B.PB7_GRPAPV = '"+cGrupo+"' "+CRLF
		endif

		if !empty(cFilMat) .and. !empty(cMat) .and. !empty(cPeriodo)
			cQuery += "  AND PB7B.PB7_FILIAL 	= '"+cFilMat	+"' "+CRLF
			cQuery += "  AND PB7B.PB7_MAT 		= '"+cMat		+"' "+CRLF
			cQuery += "  AND PB7B.PB7_PAPONT 	= '"+cPeriodo	+"' "+CRLF
		endif

		cQuery += "            GROUP BY PB7B.PB7_FILIAL            "+CRLF
		cQuery += "                    ,PB7B.PB7_MAT               "+CRLF
		cQuery += "                    ,PB7B.PB7_DATA)             "+CRLF
		cQuery += "PB7B ON PB7B.FIL = PB7_FILIAL                   "+CRLF
		cQuery += "    AND PB7B.MAT = PB7_MAT                      "+CRLF
		cQuery += "    AND PB7B.DTA = PB7_DATA                     "+CRLF
		cQuery += "    AND PB7B.VRS = PB7_VERSAO                   "+CRLF
		cQuery += "WHERE PB7.D_E_L_E_T_ <> '*'                     "+CRLF

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cPB7Tb, .F., .T.)

		( cPB7Tb )->( dbGoTop() )
		While ( cPB7Tb )->( !EOF() )
			PB7->( dbGoTo( (cPB7Tb)->REC ) )

			//-> Restaurando os Status.
			If PB7->( RecNo() ) == ( cPB7Tb )->REC
				PB7->( RecLock( "PB7", .F. ) )
				If fChkSPC( PB7->( PB7_FILIAL + PB7_MAT ) )
					PB7->PB7_STAATR := "5"
					PB7->PB7_ALTERH := cUsr
				Else
					PB7->PB7_STAATR := If(PB7->PB7_HRNEGV > 0, "1", "0")
					PB7->PB7_ALTERH := " "
				EndIf

				PB7->PB7_STAHE  := If(PB7->PB7_HRPOSV > 0, "1", "0")
				PB7->PB7_STATUS := If(PB7->PB7_STAATR = "1" .Or. PB7->PB7_STAHE = "1", "1", "0")
				//PB7->PB7_LOG     := "Remoto fProcPB7 Usuario Protheus: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
				lProcess  := .T.
				emailFunc( @aFunc, PB7->PB7_FILIAL, PB7->PB7_MAT )
				PB7->( MsUnLock() )
			EndIf

			//-> RollBack nas Aprovações.
			PBB->( dbSetOrder( 2 ) ) //PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+PBB_NIVEL+PBB_GRUPO+PBB_APROV
			If PBB->( dbSeek( xFilial("PBB") + PB7->( PB7_FILIAL + PB7_MAT + dToS( PB7_DATA ) ) ) ) .And. lProcess
				While PBB->( !EOF() ) .And. PBB->( PBB_FILMAT + PBB_MAT + DToS( PBB_DTAPON ) ) == PB7->( PB7_FILIAL + PB7_MAT + dToS( PB7_DATA ) )
					emailFunc( @aFunc, PBB->PBB_FILMAT, PBB->PBB_MAT )
					PBB->( RecLock("PBB",.F.) )
					//PBB->PBB_LOG := "Revertido pelo usuario: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
					PBB->( dbDelete() )
					PBB->( MsUnLock() )
					PBB->( dbSkip()   )
				EndDo
			EndIf

			lProcess  := .F.
			(cPB7Tb)->( dbSkip() )
		EndDo

		(cPB7Tb)->(dbCloseArea())
	else
		//              1 - MsGet  [2] : Descrição  [3]    : String contendo o inicializador do campo  [4] : String contendo a Picture do campo  [5] : String contendo a validação  [6] : Consulta F3  [7] : String contendo a validação When   [8] : Tamanho do MsGet   [9] : Flag .T./.F. Parâmetro Obrigatório ?
		aAdd(aParamBox,{1              ,"Periodo Inicial"  ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Inicial
		aAdd(aParamBox,{1              ,"Periodo Final"    ,CToD("  /  /    ")                             ,""                                       ,"NaoVazio()"                      ,""                ,""                                      ,8                       ,.T.}) // Periodo Final
		aAdd(aParamBox,{1              ,"Filial Inicial"   ,Space(02)                                      ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.F.}) // Filial Inicial
		aAdd(aParamBox,{1              ,"Filial Final"     ,Replicate("Z",02)                              ,"@!"                                     ,""                                ,"XM0"             ,""                                      ,2                       ,.T.}) // Filial Inicial
		aAdd(aParamBox,{1              ,"Matricula Inicial",Space(        TAMSX3("RA_MAT")[1])             ,"@!"                                     ,""                                ,"SRA"             ,""                                      ,TAMSX3("RA_MAT")[1]     ,.F.}) // Matricula Inicial
		aAdd(aParamBox,{1              ,"Matricula Final"  ,Replicate("Z",TAMSX3("RA_MAT")[1])             ,"@!"                                     ,""                                ,"SRA"             ,""                                      ,TAMSX3("RA_MAT")[1]     ,.T.}) // Matricula Final
		aAdd(aParamBox,{1              ,"C. Custo inicial" ,Space(        TAMSX3("CTT_CUSTO")[1])          ,"@!"                                     ,""                                ,"CTT"             ,""                                      ,TAMSX3("CTT_CUSTO")[1]  ,.F.}) // C. de Custo Inicial
		aAdd(aParamBox,{1              ,"C. Custo Final"   ,Replicate("Z",TAMSX3("CTT_CUSTO")[1])          ,"@!"                                     ,""                                ,"CTT"             ,""                                      ,TAMSX3("CTT_CUSTO")[1]  ,.T.}) // C. de Custo Final

		//              4 - CheckBox ( Com Say )  [2] : Descrição      [3] : Indicador Lógico contendo o inicial do Check  [4] : Texto do CheckBox       [5] : Tamanho do Radio  [6] : Validação  [7] : Flag .T./.F. Parâmetro Obrigatório ?
		//aAdd(aParamBox,{4              ,"Tipo de Estorno"  ,.F.                                            ,"Todos os Status ?"                      , 75                               ,""                , .F.})
		If Parambox(aParambox,"Parametros de Processamento",@aRet)
			cPonMes   := AllTrim( DToS(aRet[1]) + DToS(aRet[2]) )

			//-> Varrendo registros passiveis de restauração.
			cQuery := "SELECT PB7_FILIAL AS FIL,                       "+CRLF
			cQuery += "       PB7_MAT    AS MAT,                       "+CRLF
			cQuery += "       R_E_C_N_O_ AS REC,                       "+CRLF
			cQuery += "       PB7_VERSAO AS VERS                       "+CRLF
			cQuery += "FROM "+RetSqlName("PB7")+" PB7                  "+CRLF
			cQuery += "INNER JOIN (SELECT PB7B.PB7_FILIAL      AS FIL  "+CRLF
			cQuery += "                  ,PB7B.PB7_MAT         AS MAT  "+CRLF
			cQuery += "                  ,PB7B.PB7_DATA        AS DTA  "+CRLF
			cQuery += "                  ,MAX(PB7B.PB7_VERSAO) AS VRS  "+CRLF
			cQuery += "            FROM "+RetSqlName("PB7")+"  PB7B    "+CRLF
			cQuery += "            WHERE  PB7B.D_E_L_E_T_ <> '*'       "+CRLF
			cQuery += "            GROUP BY PB7B.PB7_FILIAL            "+CRLF
			cQuery += "                    ,PB7B.PB7_MAT               "+CRLF
			cQuery += "                    ,PB7B.PB7_DATA)             "+CRLF
			cQuery += "PB7B ON PB7B.FIL = PB7_FILIAL                   "+CRLF
			cQuery += "    AND PB7B.MAT = PB7_MAT                      "+CRLF
			cQuery += "    AND PB7B.DTA = PB7_DATA                     "+CRLF
			cQuery += "    AND PB7B.VRS = PB7_VERSAO                   "+CRLF
			cQuery += "WHERE PB7.D_E_L_E_T_ <> '*'                     "+CRLF
			cQuery += "  AND PB7_DATA   BETWEEN '"+DToS(aRet[1])+"' AND '"+DToS(aRet[2])+"' "+CRLF
			cQuery += "  AND PB7_FILIAL BETWEEN '"+     aRet[3] +"' AND '"+     aRet[4] +"' "+CRLF
			cQuery += "  AND PB7_MAT    BETWEEN '"+     aRet[5] +"' AND '"+     aRet[6] +"' "+CRLF
			cQuery += "  AND PB7_CC     BETWEEN '"+     aRet[7] +"' AND '"+     aRet[8] +"' "+CRLF

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cPB7Tb, .F., .T.)

			(cPB7Tb)->( dbGoTop() )

			oSelf:SetRegua1( (cPB7Tb)->(RecCount()) )

			(cPB7Tb)->(dbGoTop())
			While (cPB7Tb)->(!EOF()   )

				oSelf:IncRegua1( "Restaurando Registro.: "+(cPB7Tb)->(FIL+" - "+MAT+" - Recno.: "+AllTrim(Str(REC)) ) )
				If oSelf:lEnd
					Break
				EndIf

				PB7->( dbGoTo( (cPB7Tb)->(REC) ) )

				//-> Restaurando os Status.
				If PB7->( RecNo() ) = (cPB7Tb)->(REC)

					PB7->( RecLock("PB7",.F.) )
					If fChkSPC( PB7->(PB7_FILIAL+PB7_MAT) )
						PB7->PB7_STAATR := "5"
						PB7->PB7_ALTERH := cUsr
					Else
						PB7->PB7_STAATR := If(PB7->PB7_HRNEGV > 0, "1", "0")
						PB7->PB7_ALTERH := " "
					EndIf

					PB7->PB7_STAHE  := If(PB7->PB7_HRPOSV > 0, "1", "0")
					PB7->PB7_STATUS := If(PB7->PB7_STAATR = "1" .Or. PB7->PB7_STAHE = "1", "1", "0")
					//PB7->PB7_LOG     := "Nao remoto fProcPB7 Usuario Protheus: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())

					lProcess  := .T.
					emailFunc( @aFunc, PB7->PB7_FILIAL, PB7->PB7_MAT )
					PB7->( MsUnLock() )

				EndIf

				//-> RollBack nas Aprovações.
				PBB->( dbSetOrder(2) ) //PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+PBB_NIVEL+PBB_GRUPO+PBB_APROV
				If PBB->( dbSeek( xFilial("PBB")+PB7->(PB7_FILIAL+PB7_MAT+DToS(PB7_DATA))) ) .And. lProcess
					While PBB->( !EOF() ) .And. PBB->(PBB_FILMAT+PBB_MAT+DToS(PBB_DTAPON)) = PB7->(PB7_FILIAL+PB7_MAT+DToS(PB7_DATA))
						emailFunc( @aFunc, PBB->PBB_FILMAT, PBB->PBB_MAT )
						PBB->( RecLock("PBB",.F.) )
						//PBB->PBB_LOG := "Revertido pelo usuario: "+RetCodUsr()+" - "+usrFullName(RetCodUsr())
						PBB->( dbDelete() )
						PBB->( MsUnLock() )
						PBB->( dbSkip()   )
					EndDo
				EndIf
				lProcess  := .F.
				(cPB7Tb)->( dbSkip() )
			EndDo
			(cPB7Tb)->(dbCloseArea())
		EndIf
	endif
	geraEmail(aFunc, cAprovador, cTpUsuario )
Return

Static Function fChkSPC(cChave) //PB7->(PB7_FILIAL+PB7_MAT+DTOS(PB7_DATA))
	Local lRet := .F.

	SPC->( dbSetOrder( 1 ) )//PC_FILIAL+PC_MAT+PC_PD+DTOS(PC_DATA)+PC_TPMARCA+PC_CC+PC_DEPTO+PC_POSTO+PC_CODFUNC
	SPC->( dbSeek( cChave ) )
	If SPC->( PC_FILIAL + PC_MAT + PC_PD ) == cChave
		While SPC->( !EOF()) .And. SPC->( PC_FILIAL + PC_MAT + PC_PD + DTOS( PC_DATA ) ) == cChave
			If SPC->( !Empty( PC_ABONO ) ) .And. SPC->PC_DATA == PB7->PB7_DATA
				cUsr := SPC->PC_USUARIO
				lRet := .T.
				cUsr := If( Empty( cUsr ), "000000", cUsr )
			EndIf
			SPC->( dbSkip() )
		EndDo
	EndIf

Return lRet






















/*/{Protheus.doc} geraEmail
Envia lista de aprovação de justificativas para os aprovadores que estão com aprovações pendentes.
@type function

@author Bruno Nunes
@since 23/02/2016
@version P11.5

@param aParam, array, Posição 1 - Código da empresa Posição 2 - Código da Filial

@return nulo
/*/
static function geraEmail(aFunc, cAprovador, cTpUsuario )
	Local aHeader	:= {}  	//Dados que irao compor o envio do email
	Local nTempo    := 0
	local nTempoFim := 0
	local i         := 0

	private lModoDebug := .F.

	default cAprovador := ""
	default cTpUsuario := "1"

	//Configura caminho do portal GCH
	if empty( GetGlbValue( cPARAM_CAMINHO ) ) .or. empty( GetGlbValue( cPARAM_MODO_DEBUG ) )
		u_ParamPtE()
	endif
	cLinkPortal := GetGlbValue(cPARAM_CAMINHO)
	if GetGlbValue(cPARAM_MODO_DEBUG) == "1"
		lModoDebug := .T.
	endif

	if lModoDebug
		nTempo := seconds()
		conout("	fRestPB7 iniciado em: " + dtoc( msDate() ) + " as " + time() )
	endif

	if !empty( aFunc )
		for i := 1 to len( aFunc )
			aHeader := {}
			aAdd( aHeader, aFunc[i][3] )
			aAdd( aHeader, aFunc[i][4] )

			if cTpUsuario == "1"
				aAdd( aHeader, cMSG1 + cMSG2 + cMSG3 )
			else
				if upper(allTrim(aFunc[i][4])) == upper(allTrim(cAprovador))
					aAdd( aHeader, cMSG1_MINHA_REVERSAO + cMSG2 + cMSG3 )
				else
					aAdd( aHeader, cMSG1_APROVADOR + cMSG2 + cMSG3 )
				endif
			endif
			envEmail( aHeader, cTITULO_EMAIL, cAprovador, cTpUsuario )
		next i

		if lModoDebug
			nTempoFim := seconds()
			conout("	Tempo de execucao: " + cValToChar( nTempoFim - nTempo ) + " segundos" )
			conout("	fRestPB7 encerrado em: " + dtoc( msDate() ) + " as " + time() )
		endif
	endif

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
Static Function envEmail(aHeader, cTituloEmail, cAprovador, cTpUsuario )
	Local chtml 	  := '' //Strinf com html
	Local cEmailAprov := '' //Email do aprovador
	Local cMsgHTML 	  := '' //Mensagem do email

	Default aHeader 	 := {}
	Default cTituloEmail := 'Email enviado pelo Protheus'
	Default cAprovador   := usrFullName(RetCodUsr())
	Default cTpUsuario   := "1"

	cEmailAprov := aHeader[1] //email do usuario aprovador
	cMsgHTML 	:= replace(aHeader[3], '[xx]', aHeader[2] ) //Mensagem titulo
	cMsgHTML 	:= replace(cMsgHTML  , '[yy]', cAprovador ) //Mensagem titulo

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

Return()


static function emailFunc( aFunc, cFilMat, cMat )
	local aAux 		:= {}
	local nPos 		:= 0
	local lRetorno  := .F.

	default aFunc	:= {}
	default cFilMat	:= ""
	default cMat	:= ""

	if !empty( aFunc )
		nPos := aScan( aFunc, { |x| x[ 1 ] == cFilMat .and. x[ 2 ] == cMat } )
	endif

	if nPos == 0
		aAdd( aAux, cFilMat)
		aAdd( aAux, cMat)
		aAdd( aAux, POSICIONE( "SRA", 1, cFilMat+cMat, "RA_EMAIL" ) )
		aAdd( aAux, capital( POSICIONE( "SRA", 1, cFilMat+cMat, "RA_NOME"  ) ) )

		aAdd( aFunc, aAux )

		lRetorno := .T.
	endif

return lRetorno