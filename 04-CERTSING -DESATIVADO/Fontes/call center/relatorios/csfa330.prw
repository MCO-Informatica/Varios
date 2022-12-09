#Include 'Protheus.ch'
#Include 'Report.ch'


//-----------------------------------------------------------------------
// Rotina | CSFA330    | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de impressão do panorama de atendimentos pendentes 
//        | e encerrados.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSFA330( c330Canal, c330Consul )
	
	Local nI       := 0
	Local nP       := 0
	Local nX       := 0
	Local nOK      := 0
	Local nLen     := 0
	Local nSizeCol := 0
	Local nLargura := 0
	
	Local oCell
	Local oReport
	Local oSection 
	
	Local cRet     := ''
	Local cPerg    := 'CSFA330'
	Local cReport  := cPerg
	Local cTitulo  := 'Panorama de atendimentos'
	Local cDescri  := 'Relatório do panorama de atendimentos ativos e receptivos pendentes e encerrados.'
	
	Local aCPO     := {}
	Local aAlign   := {}
	Local aHeader  := {}
	Local aSizeCol := {}
	Local aPicture := {}
	
	Local lIsAdm   := .F.
	
	Private cU7_OPERAD := '', cU7_COD := '', cU7_TIPO := '', cU7_CODVEN := '', cA3_XCANAL := ''
	Private lReportQry := .F.
	
	A330CriaX1( cPerg )
	
	Pergunte( cPerg, .F. )
	
	//---------------------------------------------
	// Se a chamada do relatório não for pelo menu.
	//---------------------------------------------
	If c330Canal == NIL .And. c330Consul == NIL
				
		SetKey( VK_F12 , {|| lIsAdm := u_CSIsAdm(), IIf(lIsAdm, lReportQry := MsgYesNo('Exportar a string da query?', cTitulo ), lReportQry := .F. ), Pergunte( cPerg, .F. )} )
		
		FormBatch(	'Panorama de Atendimentos', ;
					{'Rotina para gerar o Panorama de Atendimentos, o objetivo é relatar os atendimentos',;
		 			'efetuados e apresentar sua tabulação em planilha. ',' ',;
					'Clique em OK para informar o canal de vendas e os parâmetros de busca.'},;
					{{01, .T., { || nOK := 1, FechaBatch() } },;
					{22, .T., { || FechaBatch() } } } )
		
		If nOK > 0
			//---------------------------------------------------------
			// Verificar o perfil do operador - Supervisor ou Operador.
			//---------------------------------------------------------
			If A330Perfil()
				If cU7_TIPO=='2'
					//-----------------------------------------------------------------
					// Sendo supervisor, solicitar que seja escolhido quais operadores.
					//-----------------------------------------------------------------
					cRet := A330SelOpe()
					If .NOT. Empty( cRet )
						cU7_OPERAD := "IN "+cRet+" "
					Endif
				Else
					cU7_OPERAD := "= '"+cU7_COD+"' "
				Endif
			Else
				Return
			Endif
		Endif
	Else
		cA3_XCANAL := c330Canal
		cU7_OPERAD := c330Consul
	Endif
	
	If .NOT. Empty( cU7_OPERAD )
		//----------------------------
		// Estanciar o objeto TReport.
		//----------------------------
		oReport := TReport():New( cReport, cTitulo, cPerg , { |oObj| A330RptPrt( oObj, aCPO ) }, cDescri )
		oReport:DisableOrientation()
		oReport:SetEnvironment(2)  // Ambiente selecionado. Opções: 1-Server e 2-Cliente.
		oReport:nLineHeight := 35  // Altura da linha.
		oReport:SetLandscape()
	
		//-----------------------------------------
		// Campos que serão tratados no relatórios.
		//-----------------------------------------
		aCPO := {'UC_DATA'      ,;
		         'UC_CODIGO'    ,;
		         'UD_ITEM'      ,;
		         'UD_DATA'      ,;
		         'UC_XEXPECT'   ,;
		         'UC_CHAVE'     ,;
		         'UC_ENTIDAD'   ,;
		         'UC_ENTIDADE'  ,;
		         'UD_OBS'       ,;
		         'UD_CODEXEC'   ,;
		         'UC_NOMENT'    ,;
		         'UC_NOMCONT'   ,;
		         'UC_CARGO'     ,;
		         'Z1_DESCSEG'   ,;
		         'B1_DESC'      ,;
		         'UD_QUANT'     ,;
		         'UD_VUNIT'     ,;
		         'UD_TOTAL'     ,;
		         'UD_ASSUNTO'   ,;
		         'X5_DESCRI'    ,;
		         'U9_DESC'      ,;
		         'UX_DESTOC'    ,;
		         'UQ_DESC'      ,;
		         'UN_DESC'      ,;
		         'U7_NOME'      ,;
		         'UC_CONCORR'   ,;
		         'UC_IDPEDIDO'  ,;
		         'UC_COMMONAME' ,;
		         'UC_CODOBS'    ,;
		         'UA_QTDPROP'   ,;
		         'UC_TELEVEN'   ,;
		         'UC_OPORTUN'   ,;
		         'UC_XCARGO'    ,;
		         'UC_XCONCOR'   ,;
		         'UC_XDIPROP'   ,;
		         'UC_XHIPROP'   ,;
		         'UC_XDFPROP'   ,;
		         'UC_XHFPROP'    }
		         		         
		
		//+----------------------------------------------------+
		//| Substituição de títulos das colunas do relatórios. |
		//+----------------------------------------------------+
		AAdd( aHeader, 'DT. Abertura Atend.'  )
		AAdd( aHeader, 'Nº Atendimento'       )
		AAdd( aHeader, 'Nº Seq. Atend.'       )
		AAdd( aHeader, 'DT. do atendimento'   )
		AAdd( aHeader, 'Valor da Expectativa' )
		AAdd( aHeader, 'Código cliente'       )
		AAdd( aHeader, 'Sigla entidade'       )
		AAdd( aHeader, 'Nome da lista'        )
		AAdd( aHeader, 'Assunto'		          )
		AAdd( aHeader, 'Complemento'          )
		AAdd( aHeader, 'Razão social'         )
		AAdd( aHeader, 'Nome contato'         )
		AAdd( aHeader, 'Cargo contato'        )
		AAdd( aHeader, 'Descr. Segmento'      )
		AAdd( aHeader, 'Descr. Produto'       )
		AAdd( aHeader, 'Quantidade'           )
		AAdd( aHeader, 'Unitário'             )
		AAdd( aHeader, 'Total'                )
		AAdd( aHeader, 'Código do Assunto'    )
		AAdd( aHeader, 'Descr. Assunto'       )
		AAdd( aHeader, 'Descr. Ocorrência'    )
		AAdd( aHeader, 'Complemento ocorr.'   )
		AAdd( aHeader, 'Descrição ação'       )
		AAdd( aHeader, 'Descri. Encerramento' )
		AAdd( aHeader, 'Nome operador'        )
		AAdd( aHeader, 'Concorrência'         )
		AAdd( aHeader, 'ID do Pedido'         )
		AAdd( aHeader, 'Common Name'          )
		AAdd( aHeader, 'Observação'           )
		AAdd( aHeader, 'Gerou Proposta'       )
		AAdd( aHeader, 'TLV'                  )
		AAdd( aHeader, 'Oportunidade'         )
		AAdd( aHeader, 'Cargo'                )
		AAdd( aHeader, 'Info. Concorrencia'   )
		AAdd( aHeader, 'Data Contato'         )
		AAdd( aHeader, 'Hora Contato'         )
		AAdd( aHeader, 'Data Proposta'        )
		AAdd( aHeader, 'Hora Proposta'        )
		
		//----------------------------------------------------------------------------------------
		// Definir título, alinhamento do dado, picture e tamanho, podendo ser o título ou o dado.
		//----------------------------------------------------------------------------------------
		SX3->( dbSetOrder( 2 ) )
		For nI := 1 To Len( aCPO )
			If SX3->( dbSeek( aCPO[ nI ] ) )
				AAdd( aAlign, Iif( SX3->X3_TIPO == 'N','RIGHT','LEFT' ) )
				AAdd( aPicture, RTrim( SX3->X3_PICTURE ) )
				AAdd( aSizeCol, Max( SX3->( X3_TAMANHO + X3_DECIMAL ), Len( aHeader[ nI ] ) ) )
			Else
				AAdd( aAlign, 'LEFT' )
				AAdd( aPicture, '@!' )
				AAdd( aSizeCol, 40   )
			Endif
		Next nI
		
		DEFINE SECTION oSection OF oReport TITLE cTitulo TOTAL IN COLUMN
		
		nLen     := Len( aHeader )
		nSizeCol := Len( aSizeCol )
		
		For nX := 1 To nLen
			If nSizeCol > 0
				If nX <= nSizeCol
					nLargura := aSizeCol[ nX ]
				Else
					nLargura := 20
				Endif
			Else
				nLargura := 20
			Endif
			
			DEFINE CELL oCell NAME "CEL" + RTrim( Str( nX-1 ) ) OF oSection SIZE nLargura TITLE aHeader[ nX ]
			
			// Tem alinhamento?
			If Len( aAlign ) > 0
				oCell:SetAlign( aAlign[ nX ] )
			Endif
		Next nX
		
		oSection:SetColSpace(1)         // Define o espaçamento entre as colunas.
		oSection:nLinesBefore := 2      // Quantidade de linhas a serem saltadas antes da impressão da seção.
		oSection:SetLineBreak(.T.)      // Define que a impressão poderá ocorrer emu ma ou mais linhas no caso das colunas exederem o tamanho da página.
	   
		// Somente planilha.
		oReport:nDevice := 4
		oReport:PrintDialog()
	Endif

Return


//-----------------------------------------------------------------------
// Rotina | A330RptPrt | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina de processamento para impressão.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A330RptPrt( oReport, aCPO )
	
	Local nI       := 0
	Local nCOUNT   := 0
	
	Local cSQL     := ''
	Local cTRB     := ''
	Local cCOUNT   := ''
	Local cTeleVen := ''
	
	Local oSection := oReport:Section( 1 )
	
	If oReport:nDevice<>4
		MsgAlert('O panorama de atendimentos somente poderá ser gerado em planilha.','Panorama de atendimentos')
		Return
	Endif
	
	cSQL := " SELECT UC_DATA, " + CRLF
	cSQL += "        UC_XEXPECT,  " + CRLF
	cSQL += "        UC_CODIGO,  " + CRLF
	cSQL += "        UD_CODEXEC,  " + CRLF
	cSQL += "        UD_LSTCONT,  " + CRLF
	cSQL += "        UD_ITEM,  " + CRLF
	cSQL += "        UC_ENTIDAD,  " + CRLF
	cSQL += "        CASE  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZT' THEN 'RENOV. SSL'  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZX' THEN 'RENOV. ICP-BRASIL'  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'PAB' THEN 'LISTAS MAIL-MKT'  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SA1' THEN 'CLIENTES'  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SUS' THEN 'PROSPECTS'  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'ACH' THEN 'SUSPECTS'  " + CRLF
	cSQL += "        END AS UC_ENTIDADE,  " + CRLF
	cSQL += "        NVL(Z1_DESCSEG,' ') AS Z1_DESCSEG," + CRLF
	cSQL += "        UD_PRODUTO, " + CRLF
	cSQL += "        NVL(B1_DESC,' ') AS B1_DESC, " + CRLF
	cSQL += "        NVL(UN_DESC,' ') AS UN_DESC, " + CRLF
	cSQL += "        UD_QUANT," + CRLF
	cSQL += "        UD_VUNIT," + CRLF
	cSQL += "        UD_TOTAL," + CRLF
	cSQL += "        RTRIM(UC_CHAVE) AS UC_CHAVE,  " + CRLF
	cSQL += "        CASE  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZT' THEN (SELECT ZT_EMPRESA  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZT")+" SZT " + CRLF
	cSQL += "                                        WHERE  ZT_FILIAL = "+ValToSql(xFilial("SZT"))+"  " + CRLF
	cSQL += "                                               AND ZT_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZT.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZX' THEN (SELECT ZX_DSRAZAO  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZX")+" SZX  " + CRLF
	cSQL += "                                        WHERE  ZX_FILIAL = "+ValToSql(xFilial("SZX"))+"  " + CRLF
	cSQL += "                                               AND ZX_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZX.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SA1' THEN (SELECT A1_NOME  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SA1")+" SA1  " + CRLF
	cSQL += "                                        WHERE  A1_FILIAL = "+ValToSql(xFilial("SA1"))+"  " + CRLF
	cSQL += "                                               AND A1_COD  " + CRLF
	cSQL += "                                                   || A1_LOJA = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SA1.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'PAB' THEN (SELECT PAB_EMPRES  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("PAB")+" PAB  " + CRLF
	cSQL += "                                        WHERE  PAB_FILIAL = "+ValToSql(xFilial("PAB"))+"  " + CRLF
	cSQL += "                                               AND PAB_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND PAB.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SUS' THEN (SELECT US_NOME  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SUS")+" SUS  " + CRLF
	cSQL += "                                        WHERE  US_FILIAL = "+ValToSql(xFilial("SUS"))+"  " + CRLF
	cSQL += "                                               AND US_COD  " + CRLF
	cSQL += "                                                   || US_LOJA = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SUS.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'ACH' THEN (SELECT ACH_RAZAO  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("ACH")+" ACH  " + CRLF
	cSQL += "                                        WHERE  ACH_FILIAL = "+ValToSql(xFilial("ACH"))+"  " + CRLF
	cSQL += "                                               AND ACH_CODIGO  " + CRLF
	cSQL += "                                                   || ACH_LOJA = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND ACH.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "        END AS UC_NOMENT,  " + CRLF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	cSQL += "        CASE  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZT' THEN (SELECT ZT_NOME  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZT")+" SZT " + CRLF
	cSQL += "                                        WHERE  ZT_FILIAL = "+ValToSql(xFilial("SZT"))+"  " + CRLF
	cSQL += "                                               AND ZT_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZT.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZX' THEN (SELECT ZX_NMCLIEN  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZX")+" SZX  " + CRLF
	cSQL += "                                        WHERE  ZX_FILIAL = "+ValToSql(xFilial("SZX"))+"  " + CRLF
	cSQL += "                                               AND ZX_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZX.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'PAB' THEN (SELECT PAB_NOME  " + CRLF	
	cSQL += "                                        FROM   "+RetSqlName("PAB")+" PAB  " + CRLF
	cSQL += "                                        WHERE  PAB_FILIAL = "+ValToSql(xFilial("PAB"))+"  " + CRLF
	cSQL += "                                               AND PAB_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND PAB.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'ACH' THEN (SELECT ACH_RAZAO  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("ACH")+" ACH  " + CRLF
	cSQL += "                                        WHERE  ACH_FILIAL = "+ValToSql(xFilial("ACH"))+"  " + CRLF
	cSQL += "                                               AND ACH_CODIGO  " + CRLF
	cSQL += "                                                   || ACH_LOJA = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND ACH.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SA1' THEN (SELECT A1_NOME  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SA1")+" SA1  " + CRLF
	cSQL += "                                        WHERE  A1_FILIAL = "+ValToSql(xFilial("SA1"))+"  " + CRLF
	cSQL += "                                               AND A1_COD  " + CRLF
	cSQL += "                                                   || A1_LOJA = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SA1.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SUS' THEN (SELECT US_NOME  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SUS")+" SUS  " + CRLF
	cSQL += "                                        WHERE  US_FILIAL = "+ValToSql(xFilial("SUS"))+"  " + CRLF
	cSQL += "                                               AND US_COD  " + CRLF
	cSQL += "                                                   || US_LOJA = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SUS.D_E_L_E_T_ = ' ')  " + CRLF	
	cSQL += "        END AS UC_NOMCONT,  " + CRLF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	cSQL += "        CASE  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'PAB' THEN (SELECT PAB_CARGO  " + CRLF	
	cSQL += "                                        FROM   "+RetSqlName("PAB")+" PAB1  " + CRLF
	cSQL += "                                        WHERE  PAB_FILIAL = "+ValToSql(xFilial("PAB"))+"  " + CRLF
	cSQL += "                                               AND PAB_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND PAB1.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZX' THEN (SELECT ZX_DSCARGO  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZX")+" SZX1  " + CRLF
	cSQL += "                                        WHERE  ZX_FILIAL = "+ValToSql(xFilial("SZX"))+"  " + CRLF
	cSQL += "                                               AND ZX_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZX1.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "        END AS UC_CARGO,  " + CRLF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	cSQL += "        X5_DESCRI, " + CRLF
	cSQL += "        U9_DESC, " + CRLF
	cSQL += "        UX_DESTOC,  " + CRLF
	cSQL += "        UQ_DESC," + CRLF
	cSQL += "        U7_NOME,  " + CRLF
	cSQL += "        UD_ASSUNTO,  " + CRLF
	cSQL += "        UD_OBS,  " + CRLF
	cSQL += "        UD_DATA, " + CRLF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	cSQL += "        CASE  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZT' THEN (SELECT ZT_CONCORR  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZT")+" SZT " + CRLF
	cSQL += "                                        WHERE  ZT_FILIAL = "+ValToSql(xFilial("SZT"))+"  " + CRLF
	cSQL += "                                               AND ZT_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZT.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZX' THEN (SELECT ZX_CONCORR  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZX")+" SZX  " + CRLF
	cSQL += "                                        WHERE  ZX_FILIAL = "+ValToSql(xFilial("SZX"))+"  " + CRLF
	cSQL += "                                               AND ZX_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZX.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'PAB' THEN (SELECT PAB_CONCOR  " + CRLF	
	cSQL += "                                        FROM   "+RetSqlName("PAB")+" PAB  " + CRLF
	cSQL += "                                        WHERE  PAB_FILIAL = "+ValToSql(xFilial("PAB"))+"  " + CRLF
	cSQL += "                                               AND PAB_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND PAB.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "        END AS UC_CONCORR,  " + CRLF
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	cSQL += "        UC_CODOBS,  " + CRLF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	cSQL += "        CASE  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZT' THEN (SELECT ZT_IDPEDID  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZT")+" SZT " + CRLF
	cSQL += "                                        WHERE  ZT_FILIAL = "+ValToSql(xFilial("SZT"))+"  " + CRLF
	cSQL += "                                               AND ZT_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZT.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "        END AS UC_IDPEDIDO,  " + CRLF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	cSQL += "        CASE  " + CRLF
	cSQL += "          WHEN UC_ENTIDAD = 'SZT' THEN (SELECT ZT_COMMON  " + CRLF
	cSQL += "                                        FROM   "+RetSqlName("SZT")+" SZT " + CRLF
	cSQL += "                                        WHERE  ZT_FILIAL = "+ValToSql(xFilial("SZT"))+"  " + CRLF
	cSQL += "                                               AND ZT_CODIGO = RTRIM(UC_CHAVE)  " + CRLF
	cSQL += "                                               AND SZT.D_E_L_E_T_ = ' ')  " + CRLF
	cSQL += "        END AS UC_COMMONAME  " + CRLF
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	cSQL += " FROM   (SELECT UC_CODIGO, " + CRLF
	cSQL += "        		 UD_CODEXEC,  " + CRLF
	cSQL += "        		 UD_LSTCONT,  " + CRLF
	cSQL += "                (SELECT MIN(UD_ITEM) FROM PROTHEUS.SUD010 WHERE UD_FILIAL = SUC.UC_FILIAL AND UD_CODIGO = SUC.UC_CODIGO AND UD_LSTCONT = SUD.UD_LSTCONT AND D_E_L_E_T_ = ' ') UD_ITEM, " + CRLF
	cSQL += "                UC_OPERACA,  " + CRLF
	cSQL += "                UC_STATUS,  " + CRLF
	cSQL += "                UC_CODCONT,  " + CRLF
	cSQL += "                UC_ENTIDAD,  " + CRLF
	cSQL += "                UC_CHAVE,  " + CRLF
	cSQL += "                UC_OPERADO,  " + CRLF
	cSQL += "                UC_DATA,  " + CRLF
	cSQL += "                UC_XEXPECT,  " + CRLF
	cSQL += "                UC_FIM,  " + CRLF
	cSQL += "                UC_CODENCE, " + CRLF
	cSQL += "                UD_ASSUNTO,  " + CRLF
	cSQL += "                UD_OCORREN,  " + CRLF
	cSQL += "                UD_SOLUCAO,  " + CRLF
	cSQL += "                UD_STATUS,  " + CRLF
	cSQL += "                UD_PRODUTO, " + CRLF
	cSQL += "                UD_QUANT," + CRLF
	cSQL += "                UD_VUNIT," + CRLF
	cSQL += "                UD_TOTAL," + CRLF
	cSQL += "                UD_OBS," + CRLF
	cSQL += "                UD_DATA," + CRLF
	cSQL += "                UC_CODOBS" + CRLF
	cSQL += "         FROM   "+RetSqlName("SUC")+" SUC  " + CRLF
	cSQL += "                INNER JOIN "+RetSqlName("SUD")+" SUD  " + CRLF
	cSQL += "                        ON UD_FILIAL = "+ValToSql(xFilial("SUD"))+"  " + CRLF
	cSQL += "                           AND UD_CODIGO = UC_CODIGO  " + CRLF
	cSQL += "                           AND SUD.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "         WHERE  UC_FILIAL = "+ValToSql(xFilial("SUC"))+"  " + CRLF
	cSQL += "                AND UC_DATA BETWEEN "+ValToSQL(mv_par01)+" AND "+ValToSQL(mv_par02)+" " + CRLF
	
	// Pendente
	If mv_par03 == 1
		cSQL += "                AND UC_STATUS = '2' " + CRLF
		cSQL += "                AND UD_STATUS = '1' " + CRLF
	// Encerrado
	Elseif mv_par03 == 2
		cSQL += "                AND UC_STATUS = '3' " + CRLF
		cSQL += "                AND UD_STATUS IN('2','3') " + CRLF
	// Ambos
	Else
		cSQL += "                AND UC_STATUS IN('2','3') " + CRLF
		cSQL += "                AND UD_STATUS IN('1','2','3') " + CRLF	
	Endif
	
	If mv_par04 <> 3
		If mv_par04==1
			cSQL += "                AND UC_OPERACA = '1' " + CRLF
		Elseif mv_par04==2
			cSQL += "                AND UC_OPERACA = '2' " + CRLF
		Endif
	Endif
	
	cSQL += "                AND SUC.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "                AND UC_OPERADO IN (SELECT U7_COD  " + CRLF
	cSQL += "                                   FROM   "+RetSqlName("SU7")+" SU7  " + CRLF
	cSQL += "                                          INNER JOIN "+RetSqlName("SA3")+" SA3  " + CRLF
	cSQL += "                                                  ON A3_FILIAL = "+ValToSql(xFilial("SA3"))+"  " + CRLF
	cSQL += "                                                     AND A3_COD = U7_CODVEN  " + CRLF
	cSQL += "                                                     AND A3_XCANAL = "+ValToSQL(cA3_XCANAL)+"  " + CRLF
	cSQL += "                                                     AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                                                     AND SA3.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "                                   WHERE  U7_FILIAL = "+ValToSql(xFilial("SU7"))+"  " + CRLF
	cSQL += "                                          AND U7_COD " + cU7_OPERAD + " " + CRLF
	cSQL += "                                          AND SU7.D_E_L_E_T_ = ' ')) TEMP_QRY  " + CRLF
	cSQL += "        INNER JOIN "+RetSqlName("SU5")+" SU5  " + CRLF
	cSQL += "                ON U5_FILIAL = "+ValToSql(xFilial("SU5"))+"  " + CRLF
	cSQL += "                   AND U5_CODCONT = UC_CODCONT  " + CRLF
	cSQL += "                   AND SU5.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "        INNER JOIN "+RetSqlName("SU7")+" SU7  " + CRLF
	cSQL += "                ON U7_FILIAL = "+ValToSql(xFilial("SU7"))+"  " + CRLF
	cSQL += "                   AND U7_COD = UC_OPERADO  " + CRLF
	cSQL += "                   AND SU7.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "        INNER JOIN "+RetSqlName("SU9")+" SU9  " + CRLF
	cSQL += "                ON U9_FILIAL = "+ValToSql(xFilial("SU9"))+"  " + CRLF
	cSQL += "                   AND U9_ASSUNTO = UD_ASSUNTO " + CRLF
	cSQL += "                   AND U9_CODIGO = UD_OCORREN " + CRLF
	cSQL += "                   AND SU9.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SUX")+" SUX " + CRLF
	cSQL += "               ON UX_FILIAL = "+ValtoSql(xFilial("SUX"))+" " + CRLF
	cSQL += "                  AND UX_CODTPO = U9_TIPOOCO " + CRLF
	cSQL += "                  AND SUX.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "        INNER JOIN "+RetSqlName("SX5")+" SX5  " + CRLF
	cSQL += "                ON X5_FILIAL = "+ValToSql(xFilial("SX5"))+" " + CRLF
	cSQL += "                   AND X5_TABELA = 'T1' " + CRLF
	cSQL += "                   AND X5_CHAVE = UD_ASSUNTO " + CRLF
	cSQL += "                   AND SX5.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "        INNER JOIN "+RetSqlName("SUQ")+" SUQ " + CRLF
	cSQL += "                ON UQ_FILIAL = "+ValToSql(xFilial("SUQ"))+" " + CRLF
	cSQL += "                   AND UQ_SOLUCAO = UD_SOLUCAO " + CRLF
	cSQL += "                   AND SUQ.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "        LEFT  JOIN "+RetSqlName("SB1")+" SB1 " + CRLF
	cSQL += "                ON B1_FILIAL = "+ValToSql(xFilial("SB1"))+" " + CRLF
	cSQL += "                   AND B1_COD = UD_PRODUTO " + CRLF
	cSQL += "                   AND SB1.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "        LEFT  JOIN "+RetSqlName("SUN")+" SUN " + CRLF
	cSQL += "                ON UN_FILIAL = "+ValToSql(xFilial("SUN"))+" " + CRLF
	cSQL += "                   AND UN_ENCERR = UC_CODENCE " + CRLF
	cSQL += "                   AND SUN.D_E_L_E_T_ = ' '  " + CRLF
	cSQL += "        LEFT  JOIN "+RetSqlName("SZ1")+" SZ1" + CRLF
	cSQL += "                ON Z1_FILIAL = "+ValToSql(xFilial("SZ1"))+" " + CRLF
	cSQL += "                   AND Z1_CODSEG = B1_XSEG" + CRLF
	cSQL += "                   AND SZ1.D_E_L_E_T_ = ' '" + CRLF
	cSQL += " ORDER BY UC_OPERADO, UC_CODIGO, UD_ITEM " + CRLF
	
	If lReportQry
		//-- Chamada da funcao statica CSFA110.
		STATICCALL( CSFA110, A110SCRIPT, cSQL )
	Endif
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	Conout('CSFA330 > ' + cSQL)
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')
	
	If (cTRB)->( BOF() ) .And. (cTRB)->( EOF() )
		MsgInfo( 'Não há dados para ser extraído.', 'Panorama de atendimentos' )
		(cTRB)->(dbCloseArea())
		Return
	Endif
	
	//cCOUNT := "SELECT COUNT(*) AS TRB_COUNT FROM ( " + cSQL + " ) TRBCOUNT "
	//If At( "ORDER BY", Upper( cCOUNT ) ) > 0
	//	cCOUNT := SubStr( cCOUNT, 1, At( "ORDER BY", cCOUNT ) -1 ) + SubStr( cCOUNT, RAt( ")", cCOUNT ) )
	//Endif
	cCOUNT := "SELECT COUNT(*) AS TRB_COUNT FROM (Select UC_DATA, UC_CODIGO, UD_LSTCONT from ( " + cSQL + " ) Group by UC_DATA, UC_CODIGO, UD_LSTCONT) "
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cCOUNT ), "TRBCOUNT", .F., .T. )
	nCOUNT := TRBCOUNT->TRB_COUNT
	TRBCOUNT->(dbCloseArea())
	
	oReport:SetMsgPrint('Aguarde, imprimindo os dados...')
	oReport:SetMeter( nCOUNT )	
	oSection:Init()
	
	While .NOT. (cTRB)->( EOF() )
		If oReport:Cancel()
			Exit
		Endif
		For nI := 1 To Len( aCPO )
			cType := ValType( (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ) )
			If     cType == 'D' ; cDado := Dtoc( (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ) )
			Elseif cType == 'N' ; cDado := LTrim( TransForm( (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ), '@E 9,999,999.99' ) )
			Elseif cType == 'C' ; cDado := (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ) ; cDado := StrTran( cDado, "'", "" )
			Endif
	
			//-- David.Santos | 20/10/2016
			Do Case
			
				Case aCPO[ nI ] == 'UC_CODOBS'
					dbSelectArea("SUC")
					SUC->(DbSeek(xFilial("SUC") + (cTRB)->(UC_CODIGO)))
					cDado    := Msmm( SUC->UC_CODOBS )
					cDado    := StrTran( cDado, chr(13) + chr(10), ";" )
				
				Case aCPO[ nI ] == 'UD_CODEXEC'
					dbSelectArea("SUD")
					SUD->(DbSeek(xFilial("SUD") + (cTRB)->(UC_CODIGO)))
					cDado    := Msmm( SUD->UD_CODEXEC )
					cDado    := StrTran(StrTran( cDado, chr(13) + chr(10), ";" ),"'","")
				
				Case aCPO[ nI ] == 'UA_QTDPROP'
					dbSelectArea("AC9")
					dbSetOrder(2) //-- AC9_FILIAL + AC9_ENTIDA + AC9_FILENT + AC9_CODENT + AC9_CODOBJ
					If DbSeek(xFilial("AC9") + "SUC" + cFilAnt + cFilAnt + (cTRB)->UC_CODIGO)
						cDado := "SIM"
					Else
						cDado := "NÃO"
					EndIf

				Case aCPO[ nI ] == 'UC_TELEVEN'
					cDado    := ""
					dbSelectArea("SUA")
					SUA->(dbOrderNickName("ATENDORIG")) //-- UA_FILIAL + UA_CORIG
					SUA->(dbSeek(xFilial("SUA") + (cTRB)->UC_CODIGO))
					While !Eof() .And. (cTRB)->UC_CODIGO == SUA->UA_XORIG
						cDado += SUA->UA_NUM + "; "
						SUA->(dbSkip())
					EndDo
		   			If Empty(cDado)
		   				cDado := "0"
		   			EndIf

		   		Case aCPO[ nI ] == 'UC_OPORTUN'
		   			cDado := SUC->(GetAdvFVal('SUC', 'UC_OPORTUN', xFilial('SUC') + (cTRB)->UC_CODIGO, 1))
		   			cDado := Iif(!Empty(cDado), cDado, '0')

		   		Case aCPO[ nI ] == 'UC_XCARGO'
		   			cDado := SUC->(GetAdvFVal('SUC', 'UC_XCARGO', xFilial('SUC') + (cTRB)->UC_CODIGO, 1))

				Case aCPO[ nI ] == 'UC_XCONCOR'
					cDado := SUC->(GetAdvFVal('SUC', 'UC_XCONCOR', xFilial('SUC') + (cTRB)->UC_CODIGO, 1))
				
				Case aCPO[ nI ] == 'UC_XDIPROP'
					cDado := DTOC(SUC->(GetAdvFVal('SUC', 'UC_XDIPROP', xFilial('SUC') + (cTRB)->UC_CODIGO, 1)))
				
				Case aCPO[ nI ] == 'UC_XHIPROP'
					cDado := SUC->(GetAdvFVal('SUC', 'UC_XHIPROP', xFilial('SUC') + (cTRB)->UC_CODIGO, 1))
				
				Case aCPO[ nI ] == 'UC_XDFPROP'
					cDado := DTOC(SUC->(GetAdvFVal('SUC', 'UC_XDFPROP', xFilial('SUC') + (cTRB)->UC_CODIGO, 1)))
				
				Case aCPO[ nI ] == 'UC_XHFPROP'
					cDado := SUC->(GetAdvFVal('SUC', 'UC_XHFPROP', xFilial('SUC') + (cTRB)->UC_CODIGO, 1))
			
			EndCase		

			oSection:Cell( "CEL" + RTrim( Str( nI-1 ) ) ):SetBlock( &( "{ || '" + cDado + "'}" ) )

		Next nI
		oSection:PrintLine()
		oReport:IncMeter()
		(cTRB)->( dbSkip() )
	End
	oReport:PrintText('TOTAL DE ATENDIMENTOS: ' + LTrim( Str( nCOUNT ) ) )
	oSection:Finish()
	(cTRB)->(dbCloseArea())

Return


//-----------------------------------------------------------------------
// Rotina | A330Perfil | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para saber o perfil do operador.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A330Perfil()
	
	Local lRet := .F.
	SU7->( dbSetOrder( 4 ) )
	If SU7->( dbSeek( xFilial( 'SU7' ) + RetCodUsr() ) )
		lRet := .T.
		cU7_COD    := SU7->U7_COD
		cU7_TIPO   := SU7->U7_TIPO
		cU7_CODVEN := SU7->U7_CODVEN
		cA3_XCANAL := Posicione('SA3',1,xFilial('SA3')+SU7->U7_CODVEN,'A3_XCANAL')
	Else
		MsgInfo( 'Usuário não está cadastro como operador, por favor, verifique.', cCadastro )
	Endif
		
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A330SelOpe | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para selecionar qual operador deseja.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A330SelOpe()

	Local oDlg 
	Local oLbx
	
	Local oPnlTop
	Local oPnlBot
	Local oPnlAll
	
	Local oSeek
	Local oPesq
	Local oOrdem 
	Local oCancel
	Local oConfirm
	Local oMrk     := LoadBitmap(,"NGCHECKOK.PNG")
	Local oNoMrk   := LoadBitmap(,"NGCHECKNO.PNG")
	
	Local lMark    := .F.
	
	Local aBkp     := {}
	Local aPar     := {}
	Local aRet     := {}
	Local aOper    := {}
	Local aMvPar   := {}
	Local aOrdem   := {}
	Local aCanal   := {} 
	
	Local nMv      := 0
	Local nOrd     := 0
	Local nOpc     := 0
	
	Local cRet     := ''
	Local cSQL     := ''
	Local cTRB     := ''
	Local cOrdem   := ''
	Local cSeek    := Space(50)
	
	AAdd( aOrdem, 'Nome' )
	AAdd( aOrdem, 'Código' )
	
	For nMv := 1 To 3
		AAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv
	
	AAdd( aPar, {1,'Código do canal de vendas',Space(Len(SZ2->Z2_CODIGO)),'@!',"ExistCpo('SZ2')",'SZ2','',50,.T.} )
	
	If .NOT. ParamBox(aPar,'Informe o canal de vendas',@aCanal,,,,,,,,.F.,.F.)
		Return( cRet )
	Endif
	
	For nMv := 1 To Len( aMvPar )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv
	
	cA3_XCANAL := aCanal[ 1 ]
	
	cSQL := "SELECT U7_NOME, " + CRLF
	cSQL += "       U7_COD, " + CRLF
	cSQL += "       U7_CODVEN, " + CRLF
	cSQL += "       A3_CODUSR, " + CRLF
	cSQL += "       U7_NREDUZ " + CRLF
	cSQL += "FROM   "+RetSqlName("SU7")+" SU7 " + CRLF
	cSQL += "       INNER JOIN "+RetSqlName("SA3")+" SA3 " + CRLF
	cSQL += "               ON A3_FILIAL = "+ValToSql(xFilial("SA3"))+" " + CRLF
	cSQL += "                  AND A3_COD = U7_CODVEN " + CRLF
	cSQL += "                  AND A3_XCANAL = "+ValToSql(cA3_XCANAL)+" " + CRLF
	cSQL += "                  AND A3_MSBLQL <> '1' " + CRLF
	cSQL += "                  AND SA3.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  U7_FILIAL = "+ValToSql(xFilial("SU7"))+" " + CRLF
	cSQL += "       AND SU7.U7_VALIDO <> '2' " + CRLF
	cSQL += "       AND SU7.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "ORDER  BY U7_NOME " + CRLF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Buscando operadores, aguarde...')
	
	If (cTRB)->( BOF() .And. EOF() )
		MsgInfo('Não foi possível encontrar registros de operadores.', cCadastro)
		Return( cRet )
	Else
		While .NOT. (cTRB)->( EOF() )
			(cTRB)->( AAdd( aOper, { lMark, U7_NOME, U7_COD, U7_CODVEN, A3_CODUSR, U7_NREDUZ,'' } ) )
			(cTRB)->( dbSkip() )
		End
		(cTRB)->(dbCloseArea())
	Endif
	
	DEFINE MSDIALOG oDlg TITLE 'Seleção de Operadores' FROM 0,0 TO 308,715 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oPnlTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlTop:Align := CONTROL_ALIGN_TOP
		
	   @ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPnlTop
		@ 1,243 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPnlTop ACTION (A330PesqOp(nOrd,cSeek,@oLbx))
		
		oPnlAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		
	   oLbx := TwBrowse():New(0,0,1000,1000,,{'','Nome Operador','Código','Vendedor','Código de usuário','Nome usuário',''},,oPnlAll,,,,,,,,,,,,.F.,,.T.,,.F.)
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:SetArray( aOper )
		oLbx:bLine := {|| {Iif(aOper[oLbx:nAt,1],oMrk,oNoMrk),;
		aOper[oLbx:nAt,2],aOper[oLbx:nAt,3],aOper[oLbx:nAt,4],aOper[oLbx:nAt,5],aOper[oLbx:nAt,6],aOper[oLbx:nAt,7]}}
		oLbx:bLDblClick := {|| aOper[oLbx:nAt,1]:=!aOper[oLbx:nAt,1] }
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aOper, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os documentos...') }
		
		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPnlBot ACTION Iif(A330Valid(oLbx,@nOpc),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'  SIZE 40,11 PIXEL OF oPnlBot ACTION (oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTER		

	If nOpc == 1
		A330Contem(@cRet,aOper)
	Endif

Return( cRet )


//-----------------------------------------------------------------------
// Rotina | A330Valid | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para validar se houver a seleção de registro.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A330Valid(oLbx,nOpc)

	Local nP := 0
	Local lRet := .T.
	nP := AScan( oLbx:aArray, {|p| p[1]==.T. } )
	If nP==0
		lRet := .F.
		MsgAlert('Não foi selecionado nenhum operador, por favor, marque pelo menos um operador.',cTitulo)
	Endif
	nOpc := Iif(lRet,1,0)

Return(lRet)


//-----------------------------------------------------------------------
// Rotina | A330Contem | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para montar a expressão contém para instrução SQL.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A330Contem(cRet,aOper)

	Local nI := 0
	cRet := "('"
	For nI := 1 To Len( aOper )
		If aOper[nI,1]
			cRet += aOper[nI,3] + "','"
		Endif
	Next nI
	cRet := SubStr(cRet,1,Len(cRet)-2)+")"

Return


//-----------------------------------------------------------------------
// Rotina | A330PesqOp | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para pesquisar o código ou nome do operador.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A330PesqOp(oLbx,nCbx,cPesq)

	Local nP := 0
	Local nCol := Iif(nCbx==1,2,Iif(nCbx==2,3,0))

	If nCol > 0
		cPesq := Upper( AllTrim( cPesq ) )
		nP := AScan( oLbx:aArray, {|p| cPesq $ Upper( AllTrim( p[ nCol ] ) ) } )
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		Else
			MsgAlert('Não foi possível encontrar o registro.',cCadastro)
		Endif
	Else
		MsgAlert('Opção de pesquisa inválida.',cCadastro)
	Endif

Return


//-----------------------------------------------------------------------
// Rotina | A330CriaX1 | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina para criar o grupo de perguntas no SX1.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A330CriaX1( cPerg )

	Local aP     := {}
	Local i      := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp  := {}
	
	/******
	Parametros da funcao padrao
	---------------------------
	PutSX1(cGrupo,;
	cOrdem,;
	cPergunt,cPerSpa,cPerEng,;
	cVar,;
	cTipo,;
	nTamanho,;
	nDecimal,;
	nPresel,;
	cGSC,;
	cValid,;
	cF3,;
	cGrpSxg,;
	cPyme,;
	cVar01,;
	cDef01,cDefSpa1,cDefEng1,;
	cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,;
	cHelp)
	
	Característica do vetor p/ utilização da função SX1
	---------------------------------------------------
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	***/
	
	aAdd(aP,{"Dt.Atendimento de?"  ,"D",8,0,"G",""                    ,"","","","","",""})
	aAdd(aP,{"Dt.Atendimento ate?" ,"D",8,0,"G","(mv_par02>=mv_par01)","","","","","",""})
	aAdd(aP,{"Qual situacao?"      ,"N",1,0,"C",""                    ,"","Pendente","Encerrado","Ambos","",""})
	aAdd(aP,{"Qual canal?"         ,"N",1,0,"C",""                    ,"","Receptivo","Ativo","Ambos","",""})
	
	aAdd(aHelp,{"Informe a partir de qual data de aten-","dimento quer processar."})
	aAdd(aHelp,{"Informe até qual data de atendimento ","quer processar."})
	aAdd(aHelp,{"Qual a situação do atendimento? Penden-","te, encerrado ou os dois."})
	aAdd(aHelp,{"Qual canal de atendimento? Receptivo,","Ativo ou os dois."})
	
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		"",;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i

Return


//-----------------------------------------------------------------------
// Rotina | A330UDStat | Autor | Robson Gonçalves     | Data | 27.12.2013
//-----------------------------------------------------------------------
// Descr. | Rotina ajustar o status do campo.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function A330UDStat()

	Local cSQL := ''

	If MsgYesNo('Confirma o update na tabela SUD para o campo UD_STATUS?')
		cSQL := "UPDATE "+RetSqlName("SUD")+" SUD "
		cSQL += "SET UD_STATUS = '2' "
		cSQL += "WHERE  UD_FILIAL = "+ValToSql(xFilial("SUD"))+" "
		cSQL += "       AND UD_STATUS = '3' "
		TcSqlExec( cSQL )
		MsgAlert('Update executado.')
	Else
		MsgAlert('Update não executado.')
	Endif

Return