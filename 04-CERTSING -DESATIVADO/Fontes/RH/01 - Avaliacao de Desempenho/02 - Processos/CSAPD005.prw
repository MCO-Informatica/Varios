#Include 'Protheus.ch'
#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
STATIC cMV_APD05 := ''
STATIC cMV_APD06 := ''
STATIC cMV_APD07 := ''
//-----------------------------------------------------------------------
// Rotina | CSAPD005  | Autor | Rafael Beghini    | Data | 20.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina Participantes x Objetivos
//        | Função foi criada para os gestores realizarem a inclusão
//        | de metas para seus funcionários diretamente no ERP.
//        | Rotina padrão (APDA100)
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSAPD005()

Local oBrw       := FWmBrowse():New()
Local aArea      := GetArea()
Local aCores     := {}
Local cAliasA    := "RD0"
Local cFiltroBrw := APD10FIL()


oBrw  := FWmBrowse():New()
oBrw:SetAlias("RD0")
oBrw:SetDescription("Cadastro de Clientes")
oBrw:SetFilterDefault( cFiltroBrw )

	Private cCadastro  := "Participantes x Objetivos (Planos e Metas)"
	Private aRotina    := {}
	Private aIndexRD0  := {}
	Private bFiltraBrw := { || FilBrowse("RD0",@aIndexRD0,@cFiltra/*, .T.*/) }
	Private lCancel    := .F.
	
	AADD(aRotina,{"Pesquisar" ,"PesqBrw"   ,0,1})
	AADD(aRotina,{"Visualizar","AxVisual"  ,0,2})
	AADD(aRotina,{"Incluir"   ,"U_APD10Exe",0,3})
	AADD(aRotina,{"Alterar"   ,"U_APD10Exe",0,4})
	AADD(aRotina,{"Excluir"   ,"U_APD10Exe",0,5})
	AADD(aRotina,{"Legenda"   ,"U_APD10LEG",0,6})
	
	AADD(aCores,{"RD0_SITUAC == '1'","BR_VERDE"   })
	AADD(aCores,{"RD0_SITUAC == '4'","BR_VERMELHO"})
	
	IF lCancel
		MsgAlert('Rotina cancelada.',cCadastro)
		Return
	ElseIF Empty( cFiltra )
		MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>Rotina não autorizada, por favor verifique seu cadastro com o RH.',cCadastro)
		Return
	EndIF
	
	dbSelectArea("RD0")
	dbSetOrder(1)
	
	// Cria o filtro na MBrowse utilizando a função FilBrowse
	Eval(bFiltraBrw)

	dbSelectArea("RD0")
	dbGoTop()
	
	mBrowse(6,1,22,75,"RD0", , , , , , aCores)
	// Deleta o filtro utilizado na função FilBrowse
	EndFilBrw("RD0",aIndexRD0)
Return Nil

//+-------------------------------------------
//|Função: APD10Exe - Rotina de Manutenção
//+-------------------------------------------
User Function APD10Exe(cAliasA, nReg, nOpc)
	Local nMaxRec  := RDV->( LastRec() )
	Local nLastRec := 0
	Local cCODMSG  := ''
	Local cEmail   := ''
	Local cMSG     := ''
	Local cAlert   := ''
	
	A010PARAM()
	
	Apda100Mnt( cAliasA , nReg , nOpc , .F. )
	nLastRec := RDV->( LastRec() )
	
	IF cMV_APD07 == '1' //Parâmetro habilitado para envio de e-mail
		IF nLastRec > nMaxRec
			//Períodos
			RDU->( dbSetOrder(1) )
			RDU->( dbSeek( xFilial("RDU") + RDV->RDV_CODPER ) )
			cCODMSG := RDU->RDU_MSGPLA
			//Mensagens
			RDG->( dbSetOrder(1) )
			RDG->( dbSeek( xFilial("RDG") + cCODMSG ) )
			cMSG := ApdMsMm( RDG->RDG_CODMEM )
			//Participantes
			RD0->( dbSetOrder(1) )
			RD0->( dbSeek( xFilial("RD0") + RDV->RDV_CODPAR ) )
			cNOME  := rTrim( RD0->RD0_NOME )
			cEmail := rTrim( RD0->RD0_EMAIL )
			
			IF Empty( cEmail )
				cAlert := 'Não será possível enviar o e-mail para o participante/funcionário, pois em seu cadastro não foi informado o e-mail.'
				cAlert += '<br>Verifique o cadastro com o RH.'
				MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>' + cAlert,cCadastro)
			ElseIF Empty( cMSG )
				cAlert := 'Não será possível enviar o e-mail para o participante/funcionário, pois não foi encontrado a mensagem no cadastro de períodos.'
				cAlert += '<br>Verifique o cadastro com o RH.'
				MsgAlert(cFONT+'ATENÇÃO'+cNOFONT+'<br><br>' + cAlert,cCadastro)
			Else
				APD10MAIL( cEmail, cNOME, cMSG )
			EndIF
		EndIF
	EndIF
Return Nil

//+-------------------------------------------
//|Função: APD10LEG - Rotina de Legenda
//+-------------------------------------------
User Function APD10LEG()
	Local aLegenda := {}
	
	AADD(aLegenda,{"BR_VERDE"   ,"Normal"  })
	AADD(aLegenda,{"BR_VERMELHO","Demitido"})
	
	BrwLegenda(cCadastro, "Legenda", aLegenda)
Return Nil

//+-------------------------------------------
//|Função: APD10FIL - Rotina de Filtro
//+-------------------------------------------
Static Function APD10FIL()
	Local cRet := ''
	Local aRet := {}
	Local aParamBox := {}
	
	aAdd(aParamBox,{1,"Cód. Visão" ,Space(06),"","","RDK","",0,.T.}) // Tipo caractere
	//aAdd(aParamBox,{1,"Cód. Gestor",Space(06),"","","RD0","",0,.F.}) // Tipo caractere
	If ParamBox(aParamBox,"Parâmetros - Planos e Metas",@aRet)
		cRet := APD10QRY(aRET)
	Else
		lCancel := .T.
	EndIF
Return( cRet )

//+-------------------------------------------
//|Função: APD10QRY - Rotina de Query
//+-------------------------------------------
Static Function APD10QRY( aRET )
	Local cRet     := ''
	Local cCod     := '"'
	Local cTRB     := ''
	Local cSQL     := ''
	Local cCodPart := ''
	Local cCODUSR  := RetCodUSr()
	
	RD0->( dbSetOrder(11) )
	IF RD0->( dbSeek( xFilial('RD0') + cCODUSR ) )
		cCodPart := RD0->RD0_CODIGO
	EndIF
	
    If !Empty(cCodPart)

       /*    
	   cSQL += "SELECT DISTINCT rde.rde_codvis AS VISAO, " + CRLF
       cSQL += "                rd0.rd0_codigo AS PARTICIPANTE, " + CRLF
	   cSQL += "                rd0.rd0_nome   AS NOME " + CRLF
	   cSQL += "FROM   (SELECT rde_itevis, " + CRLF
	   cSQL += "               rde_codvis " + CRLF
	   cSQL += "        FROM   " + RetSqlName("RDE") + " rdea " + CRLF
	   cSQL += "        WHERE  rdea.d_e_l_e_t_ = ' ' " + CRLF
	   cSQL += "               AND rdea.rde_status = '1' " + CRLF
	   cSQL += "               AND rdea.rde_codvis = '" + aRET[1] + "' " + CRLF
	   cSQL += "               AND rdea.rde_codpar = '" + cCodPart + "') superior, " + CRLF
	   cSQL += "       " + RetSqlName("RD4") + " rd4 " + CRLF
	   cSQL += "       INNER JOIN " + RetSqlName("RDE") + " rde " + CRLF
	   cSQL += "               ON rde.d_e_l_e_t_ = ' ' " + CRLF
	   cSQL += "                  AND rde.rde_codvis = rd4.rd4_codigo " + CRLF
	   cSQL += "                  AND rde.rde_itevis = rd4.rd4_item " + CRLF
	   cSQL += "       INNER JOIN " + RetSqlName("RD0") + " rd0 " + CRLF
	   cSQL += "               ON rd0.d_e_l_e_t_ = ' ' " + CRLF
	   cSQL += "                  AND rd0.rd0_codigo = rde.rde_codpar " + CRLF
	   cSQL += "                  AND rd0.rd0_situac = '1' " + CRLF
	   cSQL += "WHERE  superior.rde_itevis = rd4.rd4_tree " + CRLF
	   cSQL += "       AND superior.rde_codvis = rd4_codigo " + CRLF
	   cSQL += "ORDER  BY rd0.rd0_nome" + CRLF
       */

       cSQL := "SELECT  ABC.RDE_CODPAR     AS CODPAR "+CRLF //--Codigo participante conforme seu relacionamento com a VISÃO.
       cSQL += "       ,PAR.RD0_NOME       AS NOMPAR "+CRLF //--Nome do participante conforme o Cadastro de Participantes
       cSQL += "       ,ABC.RDE_CODVIS     AS CODVIS "+CRLF //--Codigo da VISÃO, a partir do relacionamento do particpante com a VISÃO.
       cSQL += "       ,VIS.RDK_DESC       AS DESVIS "+CRLF //--Descrição da VISÃO, conforme o Cadastro de Cabeçalho de Visões.
       cSQL += "       ,ABC.RDE_ITEVIS     AS POSVIS "+CRLF //--Posição dentro da VISAO ocupada pelo Participante.
       cSQL += "       ,NIV.RD4_DESC       AS DPSVIS "+CRLF //--Descrição da posição do NIVEL da VISAO ocupada pelo participante.
       cSQL += "       ,SUB.RDE_CODPAR     AS PARSUB "+CRLF //--Codigo do participante subordinado.
       cSQL += "       ,SUB.RD0_NOME       AS SUBNOM "+CRLF //--Nome do participante subordinado.
       cSQL += "FROM "+RetSqlName("RDE")+"  ABC, "+CRLF       //--RDE - ITENS PARTICIPANTES X VISOES
       cSQL += "(SELECT * FROM "+RetSqlName("RD0")+" WHERE D_E_L_E_T_ <> '*') PAR, "+CRLF //--RDE - ITENS PARTICIPANTES X VISOES
       cSQL += "(SELECT * FROM "+RetSqlName("RDK")+" WHERE D_E_L_E_T_ <> '*') VIS, "+CRLF //--RDK - CABEÇALHO DE VISOES
       cSQL += "(SELECT * FROM "+RetSqlName("RD4")+" WHERE D_E_L_E_T_ <> '*') NIV, "+CRLF //--RD4 - ITENS VISÕES
       
       //-> Subquery para resgatra os subordinados do participante em execução.
       cSQL += "( "+CRLF
       cSQL += "  SELECT RDE_CODPAR "+CRLF //--RDE - ITENS PARTICIPANTES X VISOES
       cSQL += "        ,RD0_NOME   "+CRLF //--RD0 - PARTICIPANTES
       cSQL += "        ,RDE_CODVIS "+CRLF
       cSQL += "        ,RDE_ITEVIS "+CRLF
       cSQL += "        ,RD4_CODIGO "+CRLF //--RD4 - ITENS VISÕES
       cSQL += "        ,RD4_ITEM   "+CRLF
       cSQL += "        ,RD4_DESC   "+CRLF
       cSQL += "        ,RD4_TREE   "+CRLF
       cSQL += "  FROM "+RetSqlName("RDE")+" RDE "+CRLF
       cSQL += "  INNER JOIN "+RetSqlName("RD0")+" RD0 ON RD0_CODIGO = RDE_CODPAR "+CRLF
       cSQL += "  INNER JOIN "+RetSqlName("RD4")+" RD4 ON RD4_CODIGO = RDE_CODVIS AND RD4_ITEM = RDE_ITEVIS "+CRLF
       cSQL += "  WHERE RDE.D_E_L_E_T_ <> '*' "+CRLF
       cSQL += "    AND RD0.D_E_L_E_T_ <> '*' "+CRLF
       cSQL += "    AND RD4.D_E_L_E_T_ <> '*' "+CRLF
       cSQL += "    AND RDE.RDE_STATUS = '1'  "+CRLF
       cSQL += ") SUB "+CRLF

       cSQL += "WHERE ABC.D_E_L_E_T_ <> '*' "+CRLF
       cSQL += "  AND ABC.RDE_STATUS  = '1' "+CRLF                //--RDE_STATUS  = '1' -> Somente alocações ativas.
       cSQL += "  AND ABC.RDE_CODPAR  = '"+AllTrim(cCodPart)+"' "+CRLF
       cSQL += "  AND PAR.RD0_CODIGO  = ABC.RDE_CODPAR "+CRLF
       cSQL += "  AND VIS.RDK_CODIGO  = ABC.RDE_CODVIS "+CRLF
       cSQL += "  AND VIS.RDK_MSBLQL  = '2' "+CRLF                //--RDK_MSBLQL  = '2' -> Somente VISOES ativas.
       cSQL += "  AND NIV.RD4_CODIGO  = VIS.RDK_CODIGO "+CRLF
       cSQL += "  AND NIV.RD4_ITEM    = ABC.RDE_ITEVIS "+CRLF
       cSQL += "  AND SUB.RD4_CODIGO  = NIV.RD4_CODIGO "+CRLF
       cSQL += "  AND SUB.RD4_TREE    = NIV.RD4_ITEM   "+CRLF
       
       cTRB := GetNextAlias()
       cSQL := ChangeQuery( cSQL )
	   PLSQuery( cSQL, cTRB )

       If .NOT. (cTRB)->( EOF() )
          While .NOT. (cTRB)->( EOF() )
                cCod += (cTRB)->PARSUB + '*'
                (cTRB)->( dbSkip() )
          EndDo
         (cTRB)->( dbCloseArea() )
		
         cCod := Substr( cCod, 1, Len(cCod) - 1 )
		 cRet := "RD0_CODIGO $ " + cCod + '"'
	   EndIF
    EndIf
Return( cRet )

//+-------------------------------------------
//|Função: APD10MAIL - Envio de e-mail
//+-------------------------------------------
Static Function APD10MAIL( cEmail, cNOME, cMSG )
	Local oHTML
	Local cBody      := ''
	Local cTemplate  := ''
	Local cFileHTML  := ''
	Local lRet       := .F.
	
	cTemplate := cMV_APD05 + cMV_APD06
	cFileHTML := cMV_APD05 + CriaTrab( NIL, .F. ) + '.htm'	
	
	oHTML := TWFHtml():New( cTemplate )
	
	oHTML:ValByName( 'cNOME', cNOME ) 
	oHTML:ValByName( 'cMSG' , cMSG  )
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	If File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		lRet := FSSendMail( cEmail, 'Portal RH - Planos e Metas', cBody, /*cAnexo*/ )
		IF lRet
			MsgInfo(cFONTOK+'E-mail enviado com sucesso para o participante.',cCadastro)
			Conout( 'FSSendMail > [CSAPD005] | E-mail: ' + cEmail + ' Assunto: Inclusão de plano/metas' )
		EndIF
		Ferase( cFileHTML )
	Else
		ApMsgInfo( 'Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	Endif
Return

//+----------------------------------------
//|Função: A010PARAM - Cria os parâmetros
//+----------------------------------------
Static Function A010PARAM()
	cMV_APD05 := 'MV_CSAPD05'
	cMV_APD06 := 'MV_CSAPD06'
	cMV_APD07 := 'MV_CSAPD07'
	
	If .NOT. GetMv( cMV_APD05, .T. )
		CriarSX6( cMV_APD05, 'C', 'DIRETORIO ONDE SERAO ARMAZENADOS OS ARQUIVOS HTML DO CORPO DE E-MAIL. CSAPD005.prw', '\htmlapd\' )
	Endif		
	cMV_APD05 := GetMv( cMV_APD05, .F. )
	
	If .NOT. GetMv( cMV_APD06, .T. )
		CriarSX6( cMV_APD06, 'C', 'NOME DO ARQ. HTML PADRÃO PARA INFORMAR SOBRE PLANOS E METAS. CSAPD005.prw', 'CSAPD005.htm' )
	Endif		
	cMV_APD06 := GetMv( cMV_APD06, .F. )
	
	If .NOT. GetMv( cMV_APD07, .T. )
		CriarSX6( cMV_APD07, 'C', 'HABILITA O PROCESSO DE ENVIO DE E-MAIL? 0-DESLIGADO 1-LIGADO. CSAPD005.prw', '1' )
	Endif		
	cMV_APD07 := GetMv( cMV_APD07, .F. )
Return