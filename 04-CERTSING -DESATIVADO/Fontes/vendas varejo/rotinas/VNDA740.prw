#Include 'Protheus.ch'
#Include 'TopConn.ch'


//+-------------------------------------------------------------------+
//| Rotina | VNDA740 | Autor | Rafael Beghini | Data | 21.12.2018 
//+-------------------------------------------------------------------+
//| Descr. | RemoteID - E-mail de instrução pré-validação
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function VNDA740(cPedGAR, cNpSite)

    Local oDados    := NIL
    Local oWsGAR    := NIL
    Local cPRODUTO  := ''
    Local cB1_DESC  := ''
    Local cNOME     := ''
    Local cEMAIL    := ''
    Local cTemplate := ''
    Local cDIR      := '\htmls\'
    Local cFileHTML := ''
    Local cSQL      := ''
    Local cTRB      := ''
    Local lRet      := .F.
    Local oObj
    
    //-- Consulta o pedido GAR no método FindPedidos
    oWsGAR := WSIntegracaoGARERPImplService():New()
    oWsGAR:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
                            eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
                            Val( cPedGar ) )
    
	oDados := oWsGAR:oWsDadosPedido
	
    IF oDados == NIL .OR. oDados:nPedido == NIL
        Return
    EndIF
    
    cPRODUTO := cValToChar( oDados:cProduto      )
    cB1_DESC := cValToChar( oDados:cprodutoDesc  )
    cNOME    := cValToChar( oDados:cNomeTitular  )
    cEMAIL   := cValToChar( oDados:cEmailTitular )
    
    //-> Montagem da query.
    cSQL := " SELECT PBV_COD, "
	cSQL += "       PBV_REGRA, "
	cSQL += "       PBV_HTML01, "
	cSQL += "       PBV_HTML02 "
	cSQL += " FROM   " + RetSqlName("PBV") + " "
	cSQL += " WHERE  PBV_REGRA LIKE '%" + cPRODUTO + "%' "
	cSQL += "        AND D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
		
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TcGenQry(,, cSQL ), cTRB, .T., .T. )
	dbSelectArea( cTRB )
	
	While (cTRB)->( !Eof() )
		cTemplate := AllTrim(Iif( oDados:nCnpjCert > 0, (cTRB)->PBV_HTML02, (cTRB)->PBV_HTML01 ))
		lRet := .T.
		(cTRB)->(dbSkip())
	EndDo

    (cTRB)->(dbCloseArea())

    IF .NOT. lRet
        Return    
    EndIF

    IF .NOT. File( cTemplate )
		ApMsgInfo( '[VNDA740] - Não localizado o arquivo template HTML no seguinte caminho: ' + cTemplate, '01 - Template não localizado')
        Return
	EndIF

	cFileHTML := cDIR + CriaTrab( NIL, .F. ) + '.htm'

    U_GTPutIN (cPedGAR,"S",cPedGAR,.T.,{"VNDA740",cPedGAR,"ENVIA-PEDIDO-GAR", "RemoteID - Instrução pré-validação"}, iIF(Empty(cNpSite),cPedGAR,cNpSite) )
    A740HTML( cFileHTML, cTemplate, cEMAIL, cNOME, cPedGAR, rTrim(cB1_DESC) )

Return


//--------------------------------------------------------------------------------
// Rotina | A740HTML     | Autor | Rafael Beghini             | Data | 26.12.2018
//--------------------------------------------------------------------------------
// Descr. | Elabora o HTML e envia o e-mail para o Titular do certificado
//--------------------------------------------------------------------------------
Static Function A740HTML( cFileHTML, cTemplate, cEmail, cNome, cPedido, cProduto )

    Local oHTML
	Local cBody     := ''
    Local cAssunto  := ''
	Local cMV_IPSRV := GetMv( 'MV_610_IP', .F. )
    Local lSrvTst   := GetServerIP() $ cMV_IPSRV

    cAssunto := IIF( lSrvTst, "[TESTE] ", "" ) + 'Confirmação de Pedido RemoteID Certisign'
    
    oHTML := TWFHtml():New( cTemplate )
	
	IF oHTML:ExistField( 1, 'cNOME')    ; oHTML:ValByName( 'cNOME', cNome )         ; EndIF
	IF oHTML:ExistField( 1, 'cPEDIDO')  ; oHTML:ValByName( 'cPEDIDO', cPedido )     ; EndIF
	IF oHTML:ExistField( 1, 'cPRODUTO') ; oHTML:ValByName( 'cPRODUTO', cProduto )   ; EndIF
	
	oHTML:SaveFile( cFileHTML )
	Sleep(500)
	
	IF File( cFileHTML )
		cBody := ''
		FT_FUSE( cFileHTML )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			cBody += FT_FREADLN()
			FT_FSKIP()
		End
		FT_FUSE()
		
		FSSendMail( cEmail, cAssunto, cBody, /*cAnexo*/ )
		Conout( 'FSSendMail > [A740HTML] | E-mail: ' + cEmail + ' Assunto: ' + cAssunto )
	Else
		ApMsgInfo( '[VNDA740] - Não localizado o arquivo HTML para o corpo de e-mail caminho: ' + cFileHTML, 'Arquivo HTML corpo de e-mail')
	EndIF
	
Return