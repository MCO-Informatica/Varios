#Include 'Protheus.ch'
#Include 'Report.ch'


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณCSFA321   บAutor: ณDavid.Santos           บData: ณ14/10/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRelatorio de propostas.                                      บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CSFA321()
	
	Local nI       := 0
	Local nX       := 0
	Local nOK      := 0
	Local nLen     := 0
	Local nSizeCol := 0
	Local nLargura := 0
	
	Local oCell
	Local oReport
	Local oSection 
	
	Local cPerg    := 'CSFA321'
	Local cReport  := cPerg
	Local cTitulo  := 'Agenda x Propostas'
	Local cDescri  := 'Relatorio de agendas que contem propostas.'
	
	Local aCPO     := {}
	Local aAlign   := {}
	Local aHeader  := {}
	Local aSizeCol := {}
	Local aPicture := {}
	
	Private lReportQry := .F.
	
	A321CriaX1( cPerg )
	
	Pergunte( cPerg, .F. )
	
	SetKey( VK_F12 , {|| lReportQry := MsgYesNo('Exportar a string da query?', cTitulo ) } )
	
	FormBatch(	'Agenda x Propostas',;
				{'Rotina para gerar a Agenda x Propostas, o objetivo ้ relatar a quantidade',;
	 			'de agendas, propostas, TLVs e Oportunidades agrupadas por consultor. ',' ',;
				'Clique em OK para informar os parโmetros de busca.'},;
				{{01, .T., { || nOK := 1, FechaBatch() } },;
				{22, .T., { || FechaBatch() } } } )
	
	//+-----------------------------+
	//| Estanciar o objeto TReport. |
	//+-----------------------------+
	oReport := TReport():New( cReport, cTitulo, cPerg , { |oObj| A321RptPrt( oObj, aCPO ) }, cDescri )
	oReport:DisableOrientation()
	oReport:SetEnvironment(2)  //-- Ambiente selecionado. Opcoes: 1-Server e 2-Cliente.
	oReport:nLineHeight := 35  //-- Altura da linha.
	oReport:SetLandscape()
	
	//+-----------------------------------------+
	//| Campos que serao tratados no relatorio. |
	//+-----------------------------------------+
	aCPO := {	'UC_OPERADO',;
				'U7_NOME',;
				'AGENDA',;
				'TELEVEN',;
				'OPORTUN',;
				'PROPOSTA' }
		
	//+----------------------------------------------------+
	//| Substituicao de titulos das colunas do relatorios. |
	//+----------------------------------------------------+
	AAdd( aHeader, 'Codigo Consultor'  )
	AAdd( aHeader, 'Nome Consultor'    )
	AAdd( aHeader, 'Agendas Atendidas' )
	AAdd( aHeader, 'TLVs'              )
	AAdd( aHeader, 'Oportunidades'     )
	AAdd( aHeader, 'Propostas'         )
			
	//+-----------------------------------------------------------------------------------------+
	//| Definir tํtulo, alinhamento do dado, picture e tamanho, podendo ser o tํtulo ou o dado. |
	//+-----------------------------------------------------------------------------------------+
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
		
		//-- Tem alinhamento ?
		If Len( aAlign ) > 0
			oCell:SetAlign( aAlign[ nX ] )
		Endif
	Next nX
	
	oSection:SetColSpace(1)		//-- Define o espacamento entre as colunas.
	oSection:nLinesBefore := 2	//-- Quantidade de linhas a serem saltadas antes da impressao da secao.
	oSection:SetLineBreak(.T.)	//-- Define que a impressao podera ocorrer em uma ou mais linhas no caso das colunas exederem o tamanho da pagina.
	  
	//-- Somente planilha.
	oReport:nDevice := 4
	oReport:PrintDialog()
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณA321RptPrt บAutor: ณDavid.Santos          บData: ณ14/10/2016 บฑฑ
ฑฑฬอออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRotina de processamento para impressao.                      บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametros:ณoReport..: Objeto de impressao.                              บฑฑ
ฑฑบ           ณaCPO.....: Colunas do relatorio.                             บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function A321RptPrt( oReport, aCPO )
	
	Local nI       := 0
	Local nCOUNT   := 0
	
	Local cSQL     := ''
	Local cTRB     := ''
	Local cCOUNT   := ''
	Local cTeleVen := ''
	
	Local oSection := oReport:Section( 1 )
	
	If oReport:nDevice <> 4
		MsgAlert('Este relatorio somente poderแ ser gerado em modo planilha.','Agenda x Propostas')
		Return
	Endif
	
	//+--------------------+
	//| Montagem da query. |
	//+--------------------+
	cSQL := " SELECT DISTINCT UC.UC_OPERADO, "																+ CRLF
	cSQL += "                 AGENDA, "																		+ CRLF
	cSQL += "                 TELEVEN, "																		+ CRLF
	cSQL += "                 OPORTUN, "																		+ CRLF
	cSQL += "                 PROPOSTA "																		+ CRLF
	cSQL += " FROM " + RetSqlName("SUC") + " UC "																+ CRLF
	cSQL += " LEFT JOIN "																						+ CRLF
	cSQL += " 		( SELECT COUNT(UC_CODIGO) agenda, "														+ CRLF
	cSQL += "        		  UC_OPERADO "																		+ CRLF
	cSQL += "       FROM " + RetSqlName("SUC") + " "															+ CRLF
	cSQL += "       WHERE UC_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "		+ CRLF
	cSQL += "       GROUP BY UC_OPERADO ) agend "																+ CRLF
	cSQL += " ON UC.UC_OPERADO = agend.UC_OPERADO "															+ CRLF
	cSQL += " LEFT JOIN "																						+ CRLF
	cSQL += " 		( SELECT COUNT(UC_TELEVEN) televen, "														+ CRLF
	cSQL += "        		  UC_OPERADO "																		+ CRLF
	cSQL += "       FROM SUC010 "																				+ CRLF
	cSQL += "       WHERE UC_TELEVEN <> ' ' AND D_E_L_E_T_ = ' ' AND "										+ CRLF
	cSQL += "             UC_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "		+ CRLF
	cSQL += "       GROUP BY UC_OPERADO) tele "																+ CRLF
	cSQL += " ON UC.UC_OPERADO = tele.UC_OPERADO "															+ CRLF
	cSQL += " LEFT JOIN "																						+ CRLF
	cSQL += " 		( SELECT COUNT(UC_OPORTUN) OPORTUN, "														+ CRLF
	cSQL += "        		  UC_OPERADO "																		+ CRLF
	cSQL += "       FROM SUC010 "																				+ CRLF
	cSQL += "       WHERE UC_OPORTUN <> ' ' AND D_E_L_E_T_ = ' ' AND "										+ CRLF
	cSQL += "             UC_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "		+ CRLF
	cSQL += "       GROUP BY UC_OPERADO) OPORTUN "															+ CRLF
	cSQL += " ON UC.UC_OPERADO = OPORTUN.UC_OPERADO "														+ CRLF
	cSQL += " LEFT JOIN "																						+ CRLF
	cSQL += " 		( SELECT COUNT(UC_CODIGO) PROPOSTA, "														+ CRLF
	cSQL += "        		  UC_OPERADO FROM "																	+ CRLF
	cSQL += "     	( SELECT COUNT(UC_CODIGO),UC_CODIGO,UC_OPERADO "										+ CRLF
	cSQL += "        	  FROM SUC010, AC9010 "																	+ CRLF
	cSQL += "    		  WHERE AC9_CODENT = UC_FILIAL || UC_CODIGO AND AC9_ENTIDA = 'SUC' AND "			+ CRLF
	cSQL += "    		        UC_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "	+ CRLF
	cSQL += "        	  GROUP BY UC_OPERADO,UC_CODIGO ) "													+ CRLF
	cSQL += "       GROUP BY UC_OPERADO ) PROPOSTA "															+ CRLF
	cSQL += " ON UC.UC_OPERADO = PROPOSTA.UC_OPERADO "														+ CRLF
	cSQL += " WHERE UC_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "				+ CRLF
	cSQL += " ORDER BY UC.UC_OPERADO "																			+ CRLF

	//+-----------------------------------------------------------------+
	//| Se teclou F11 no inicio da rotina, apresenta a query executada. |
	//+-----------------------------------------------------------------+
	If lReportQry
		//-- Chamada da funcao statica CSFA110.
		STATICCALL( CSFA110, A110SCRIPT, cSQL )
	Endif

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )

	Conout('CSFA321 > ' + cSQL)
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Aguarde, buscando dados...')

	If (cTRB)->( BOF() ) .And. (cTRB)->( EOF() )
		MsgInfo( 'Nใo hแ dados para ser extraํdo.', 'Agenda x Propostas' )
		(cTRB)->(dbCloseArea())
		Return
	Endif
	
	oReport:SetMsgPrint('Aguarde, imprimindo os dados...')	
	oSection:Init()

	While .NOT. (cTRB)->( EOF() )
		If oReport:Cancel()
			Exit
		Endif
		For nI := 1 To Len( aCPO )
			cType := ValType( (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ) )
			If cType == 'D' 
				cDado := Dtoc( (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ) )
			ElseIf cType == 'N' 
				cDado := LTrim( TransForm( (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ), '@E 999999' ) )
			ElseIf cType == 'C' 
				cDado := (cTRB)->( FieldGet( FieldPos( aCPO[ nI ] ) ) ) 
				cDado := StrTran( cDado, "'", "" )
			EndIf

			Do Case
				Case aCPO[ nI ] == 'U7_NOME'
					dbSelectArea('SU7')
					dbSetOrder(1)
					If SU7->(dbSeek(xFilial("SU7") + (cTRB)->(UC_OPERADO)))
						cDado := AllTrim(SU7->U7_NOME)
					EndIf
			EndCase	

			oSection:Cell( "CEL" + RTrim( Str( nI-1 ) ) ):SetBlock( &( "{ || '" + cDado + "'}" ) )

		Next nI
		oSection:PrintLine()
		oReport:IncMeter()
		(cTRB)->(dbSkip())
	End

	oSection:Finish()
	(cTRB)->(dbCloseArea())

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณA321CriaX1 บAutor: ณDavid Alves dos Santos บData: ณ24/10/2016 บฑฑ
ฑฑฬอออออออออออุอออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRelatorio de propostas.                                       บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametros:ณcPerg..: Grupo de pergunas do SX1.                            บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                            บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function A321CriaX1( cPerg )

	Local aP     := {}
	Local i      := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp  := {}
	
	/******
	Parametros da funcao padrao
	---------------------------
	PutSX1 (	cGrupo,;
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
	
	Caracterํstica do vetor p/ utiliza็ใo da fun็ใo SX1
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

	aAdd( aP, { "Data de?"  ,"D" ,8 ,0 ,"G" ,""                       ,"" ,"" ,"" ,"" ,"" ,"" } )
	aAdd( aP, { "Data ate?" ,"D" ,8 ,0 ,"G" ,"(mv_par02 >= mv_par01)" ,"" ,"" ,"" ,"" ,"" ,"" } )

	aAdd( aHelp, { "Informe a partir de qual data de aten-" ,"dimento quer processar." } )
	aAdd( aHelp, { "Informe at้ qual data de atendimento "  ,"quer processar."         } )

	For i := 1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par" + cSeq
		cMvCh  := "mv_ch" + Iif(i<=9,Chr(i+48),Chr(i+87))

		PutSx1( cPerg							,;
		        cSeq							,;
		        aP[i,1],aP[i,1],aP[i,1]		,;
		        cMvCh							,;
		        aP[i,2]						,;
		        aP[i,3]						,;
		        aP[i,4]						,;
		        0								,;
		        aP[i,5]						,;
		        aP[i,6]						,;
		        aP[i,7]						,;
		        ""								,;
		        ""								,;
		        cMvPar						,;
		        aP[i,8],aP[i,8],aP[i,8]		,;
		        ""								,;
		        aP[i,9],aP[i,9],aP[i,9]		,;
		        aP[i,10],aP[i,10],aP[i,10]	,;
		        aP[i,11],aP[i,11],aP[i,11]	,;
		        aP[i,12],aP[i,12],aP[i,12]	,;
		        aHelp[i]						,;
		        {}								,;
		        {}								,;
		        "" )
	Next i

Return