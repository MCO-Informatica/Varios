//--------------------------------------------------------------------------
// Rotina | CSFA730    | Autor | Robson Goncalves        | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para consultar clientes com voucher (F) consumidos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'
User Function CSFA730()
	Local aButton := {}
	Local aCOLS := {}
	Local aSay := {}
	
	Local cTRB := ''
	
	Local nOpcao := 0
	
	Private cCadastro := 'Consulta clientes Voucher (F)'
	
	AAdd( aSay, 'Consultar os clientes com Voucher (F) em aberto e saldo igual a zero. A partir dos registros' )
	AAdd( aSay, 'localizados será possível saber quais são os títulos de quais clientes da' )
	AAdd( aSay, 'entidade parceira que deverá ser cobrado.' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, '' )
	AAdd( aSay, 'Clique em OK para prosseguir...' )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cCadastro, aSay, aButton )
	
	If nOpcao == 1
		FWMsgRun( , {|| A730ProcQry( @aCOLS, @cTRB ) }, ,'Buscando os clientes com pendência...' )
		If Len( aCOLS ) > 0
			A730Show( aCOLS, cTRB )
		Endif
	Endif
Return

//--------------------------------------------------------------------------
// Rotina | A730ProcQry | Autor | Robson Goncalves       | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para executar a query principal.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A730ProcQry( aCOLS, cTRB )
	Local cSQL := ''
	
	cTRB := GetNextAlias()
	
	cSQL := "SELECT ZF_CODCLI, "
	cSQL += "		ZF_LOJCLI, "
	cSQL += "       A1_NOME "
	cSQL += "FROM   "+RetSqlName("SZF")+" SZF "
	cSQL += "       INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cSQL += "               ON A1_FILIAL = " +ValToSql( xFilial( "SA1" ) )+ " "
	cSQL += "              AND A1_COD =  ZF_CODCLI "
	cSQL += "              AND A1_LOJA =  ZF_LOJCLI "
	cSQL += "              AND SA1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  ZF_FILIAL = " +ValToSql( xFilial( "SZF" ) )+ " "
	cSQL += "       AND ZF_TIPOVOU = 'F'  "
	cSQL += "       AND ZF_CODFLU <> '0000001' "
	cSQL += "       AND ZF_SALDO = 0 "
	cSQL += "       AND SZF.D_E_L_E_T_ = ' ' "
	cSQL += "GROUP  BY ZF_CODCLI, "
	cSQL += "          ZF_LOJCLI, "
	cSQL += "          A1_NOME "
	cSQL += "ORDER  BY ZF_CODCLI"
	
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )	
		While .NOT. (cTRB)->( EOF() )
			(cTRB)->( AAdd( aCOLS, { 'N', ZF_CODCLI, ZF_LOJCLI, A1_NOME, '' } ) )
			(cTRB)->( dbSkip() )
		End
	Else
		MsgAlert( 'Não há pendências para consultar.', cCadastro )
	Endif
	(cTRB)->(dbCloseArea())
Return

//--------------------------------------------------------------------------
// Rotina | A730Show | Autor | Robson Goncalves          | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para apresentar o resultado da query para o usuário.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A730Show( aCOLS, cTRB )
	Local aHeader := {}
	
	Local bClick := {|| }
	Local bRet := {|| }

	Local nCol := 0	
	
	Local oCan
	Local oDlg
	Local oImp
	Local oLbx
	Local oMrk
	Local oNoMrk
	Local oPanel
	Local oMarca
	Local lMark := .F.

	aHeader := {'OK','Código','Loja','Nome da entidade',''}
	oMrk := LoadBitmap(,'NGCHECKOK.PNG')
	oNoMrk := LoadBitmap(,'NGCHECKNO.PNG')
	bClick := {|| Iif(oLbx:nColPos==1,(aCOLS[oLbx:nAt,1]:=Iif(aCOLS[oLbx:nAt,1]=='S','N','S')),;
					A730UmCliente(oLbx:aArray[oLbx:nAt,2],oLbx:aArray[oLbx:nAt,3]))}
	
	bRet := {|| Iif( AScan( aCOLS, {|cValue| cValue[ 1 ] == 'S' } )>0,;
	            FWMsgRun( , {|| A730Imp( aCOLS ) }, ,'Aguarde, analisando se há dados para gerar em Ms-Excel' ),;
	            MsgAlert('Selecione algum registro para processar...',cCadastro)) }
			
	DEFINE MSDIALOG oDlg TITLE 'Selecione a entidade parceira' FROM 0,0 TO 400,800 OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
	   oLbx := TwBrowse():New(38,3,250,80,,aHeader,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	   oLbx:SetArray( aCOLS )
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:bLine := {|| { Iif( aCOLS[ oLbx:nAt, 1 ]=='S', oMrk, oNoMrk ), aCOLS[ oLbx:nAt, 2 ], aCOLS[ oLbx:nAt, 3 ], aCOLS[ oLbx:nAt, 4 ] } }
	   oLbx:BlDblClick := bClick
	   oLbx:bHeaderClick := {|| lMark := aCOLS[ 1, 1 ]=='N',;
		FWMsgRun(,{|| AEval(aCOLS, {|p|  p[1] := IIF( lMark, 'S', 'N' ), oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os registros...') }

		
		oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPanel:Align := CONTROL_ALIGN_BOTTOM
		nCol := ((oPanel:oParent:nWidth/2)-4)-(40+3+40)
		//       |                          |  |  | |
		//       +-------------+------------+  |  | +---> tamanho do botão 1.
		//                     |               |  +-----> espaço entre os botões 1 e 2.
		//                     |               +--------> tamanho do botão 2.
		//                     +------------------------> área onde será colocado o botão
		
		@ 1,nCol    BUTTON oImp PROMPT 'Imprimir' SIZE 40,11 PIXEL OF oPanel ACTION Eval( bRet )
		@ 1,nCol+43 BUTTON oCan PROMPT 'Sair'     SIZE 40,11 PIXEL OF oPanel ACTION Iif(MsgYesNo('Tem certeza que deseja sair?',cCadastro),(oDlg:End()),NIL)
	ACTIVATE MSDIALOG oDlg CENTERED
Return

//--------------------------------------------------------------------------
// Rotina | A730UmCliente | Autor | Robson Goncalves     | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para apresentar o títulos de um único parceiro.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A730UmCliente( cCodCli, cLjCli )
	Local aCOLS := {}
	Local aHeader := {}
	
	Local bRet := {|| }

	Local cPICT := ''
	Local cSQL := ''
	Local cTRB := ''

	Local nCol := 0

	Local oCan
	Local oDlg
	Local oLbx
	Local oPanel 
	
	cTRB := GetNextAlias()	
	cSQL := A730Qry( cCodCli, cLjCli )
	cSQL := ChangeQuery( cSQL )
	cTRB := GetNextAlias()
	MsAguarde({|| dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. ) }, cCadastro, 'Buscando detalhes, aguarde...',.F.)
	
	If (cTRB)->(.NOT. BOF() ) .AND. (cTRB)->(.NOT. EOF() )
		cPICT := '@E 999,999,999.99'
		aHeader := {'Cód.Parceiro','Lj. Parceiro','Nome Parceiro','Cód.Cliente','Nome Cliente','Nº Título','Tipo','Emissão','Vencto.','Valor','Voucher','Fluxo', '' }
		While .NOT. (cTRB)->( EOF() )
			(cTRB)->( AAdd( aCOLS, { ZF_CODCLI, ZF_LOJCLI, A1_NREDUZ, E1_CLIENTE, E1_NOMCLI, E1_NUM, E1_TIPO, Dtoc(Stod(E1_EMISSAO)),;
			                         Dtoc(Stod(E1_VENCTO)), LTrim(TransForm(E1_VALOR,cPICT)), E1_XNUMVOUM, E1_XFLUVOU, '' } ) )
			(cTRB)->( dbSkip() )
		End
		
		bRet := {|| FWMsgRun( , {|| DlgToExcel( { { 'ARRAY', cCadastro, aHeader, aCOLS } } ) }, ,'Exportando para Ms-Excel' ) }
		
		DEFINE MSDIALOG oDlg TITLE 'Título cedidos pela entidade parceira' FROM 0,0 TO 250,750 OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
			oDlg:lEscClose := .F.
			
		   oLbx := TwBrowse():New(38,3,250,80,,aHeader,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		   oLbx:SetArray( aCOLS )
		   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		   oLbx:bLine := {|| AEval( aCOLS[ oLbx:nAt ],{|cValue,nIndex| aCOLS[ oLbx:nAt,nIndex ] } ) }
			
			oPanel := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanel:Align := CONTROL_ALIGN_BOTTOM
			nCol := ((oPanel:oParent:nWidth/2)-4)-(40+3+40)
			//       |                          |  |  | |
			//       +-------------+------------+  |  | +---> tamanho do botão 1.
			//                     |               |  +-----> espaço entre os botões 1 e 2.
			//                     |               +--------> tamanho do botão 2.
			//                     +------------------------> área onde será colocado o botão
			
			@ 1,nCol    BUTTON oImp PROMPT 'Imprimir' SIZE 40,11 PIXEL OF oPanel ACTION Eval( bRet )
			@ 1,nCol+43 BUTTON oCan PROMPT 'Sair'     SIZE 40,11 PIXEL OF oPanel ACTION Iif(MsgYesNo('Tem certeza que deseja sair?',cCadastro),(oDlg:End()),NIL)
		ACTIVATE MSDIALOG oDlg CENTERED		
		
	Else
		MsgAlert( 'Não há título/voucher consumidos para esta entidade parceira.', cCadastro )
	Endif
	(cTRB)->(dbCloseArea())
Return

//--------------------------------------------------------------------------
// Rotina | A730Qry | Autor | Robson Goncalves           | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina p/elaborar a query dos títulos dos voucher F consumidos.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A730Qry( cCodCli, cLjCli )
	Local cSQL := ''
	cSQL := "SELECT ZF_CODCLI, "
	cSQL += "       ZF_LOJCLI, "
	cSQL += "       A1_NREDUZ, "
	cSQL += "       E1_CLIENTE, "
	cSQL += "       E1_NOMCLI, "
	cSQL += "       E1_NUM, "
	cSQL += "       E1_TIPO, "
	cSQL += "       E1_EMISSAO, "
	cSQL += "       E1_VENCTO, "
	cSQL += "       E1_VALOR, "
	cSQL += "       E1_XNUMVOU,"
	cSQL += "       E1_XFLUVOU "
	cSQL += "FROM   "+RetSqlName("SZF")+" SZF "
	cSQL += "       INNER JOIN "+RetSqlName("SE1")+" SE1 "
	cSQL += "               ON E1_FILIAL = "+ValToSql(xFilial("SE1"))+" "
	cSQL += "              AND E1_XNUMVOU = ZF_COD "
	cSQL += "              AND E1_SALDO > 0 "
	cSQL += "              AND SE1.D_E_L_E_T_ = ' ' "
	cSQL += "       INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cSQL += "               ON A1_FILIAL = "+ValToSql(xFilial("SA1"))+" "
	cSQL += "              AND A1_COD = ZF_CODCLI "
	cSQL += "              AND A1_LOJA = ZF_LOJCLI "
	cSQL += "              AND SA1.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  ZF_FILIAL = "+ValToSql(xFilial("SZF"))+" "
	cSQL += "       AND ZF_CODCLI = "+ValToSql( cCodCli )+" "
	cSQL += "       AND ZF_LOJCLI = "+ValToSql( cLjCli )+" "
	cSQL += "       AND ZF_SALDO = 0 "
	cSQL += "       AND ZF_TIPOVOU = 'F' "
	cSQL += "       AND SZF.D_E_L_E_T_ = ' ' "	
Return( cSQL )

//--------------------------------------------------------------------------
// Rotina | A730Imp | Autor | Robson Goncalves           | Data | 28.04.2016
//--------------------------------------------------------------------------
// Descr. | Rotina para exportar os dados para planilha excel.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function A730Imp( aCOLS )
	Local aDADOS := {}
	Local aHeader := {}
	
	Local cPICT := ''
	Local cSQL := ''
	Local cTRB := ''
	
	Local nI := 0
	
	cPICT := '@E 999,999,999.99'
	aHeader := {'Cód.Parceiro','Lj. Parceiro','Nome Parceiro','Cód.Cliente','Nome Cliente','Nº Título','Tipo','Emissão','Vencto.','Valor','Voucher','Fluxo',''}
	
	For nI := 1 To Len( aCOLS )
		If aCOLS[ nI, 1 ] == 'S'
			cTRB := GetNextAlias()
			cSQL := A730Qry( aCOLS[ nI, 2 ], aCOLS[ nI, 3 ] )
			cSQL := ChangeQuery( cSQL )
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
			While .NOT. (cTRB)->( EOF() )
				(cTRB)->( AAdd( aDADOS, { ZF_CODCLI, ZF_LOJCLI, A1_NREDUZ, E1_CLIENTE, E1_NOMCLI, E1_NUM, E1_TIPO, Dtoc(Stod(E1_EMISSAO)),;
            Dtoc(Stod(E1_VENCTO)), LTrim(TransForm(E1_VALOR,cPICT)), E1_XNUMVOUM, E1_XFLUVOU, '' } ) )
				(cTRB)->( dbSkip() )
			End
			(cTRB)->(dbCloseArea())
		Endif
	Next nI
	If Len( aDADOS ) > 0
		DlgToExcel( { { 'ARRAY', cCadastro, aHeader, aDADOS } } )
	Else
		MsgAlert( 'Não há título/voucher consumidos para a(s) entidade(s) parceira(s) selecionada(s).', cCadastro )
	Endif
Return

/*
SELECT ZF_CODFLU, COUNT(*), ZF_USRSOL, ZF_DATCRI, ZF_PRODESC, ZF_PDESGAR, ZF_OBS, ZF_OPORTUN, ZF_USERNAM, ZF_CODCLI, ZF_LOJCLI,  A1_NOME
FROM PROTHEUS.SZF010 SZF
LEFT JOIN PROTHEUS.SA1010 SA1 ON A1_FILIAL = ' ' AND A1_COD = ZF_CODCLI AND A1_LOJA = ZF_LOJCLI
WHERE ZF_FILIAL = ' ' AND SZF.D_E_L_E_T_ = ' ' AND ZF_TIPOVOU = 'F' 
GROUP BY ZF_CODFLU, ZF_USRSOL, ZF_DATCRI, ZF_PRODESC, ZF_PDESGAR, ZF_OBS, ZF_OPORTUN, ZF_USERNAM, ZF_CODCLI, ZF_LOJCLI,  A1_NOME

SELECT ZF_CODFLU, COUNT(*), ZF_USRSOL, ZF_DATCRI, ZF_PRODESC, ZF_PDESGAR, ZF_OBS, ZF_OPORTUN, ZF_USERNAM, ZF_CODCLI, ZF_LOJCLI,  A1_NOME
FROM PROTHEUS.SZF010 SZF
LEFT JOIN PROTHEUS.SA1010 SA1 ON A1_FILIAL = ' ' AND A1_COD = ZF_CODCLI AND A1_LOJA = ZF_LOJCLI
WHERE ZF_FILIAL = ' ' AND SZF.D_E_L_E_T_ = ' ' AND ZF_TIPOVOU = 'F' AND A1_NOME IS NULL
GROUP BY ZF_CODFLU, ZF_USRSOL, ZF_DATCRI, ZF_PRODESC, ZF_PDESGAR, ZF_OBS, ZF_OPORTUN, ZF_USERNAM, ZF_CODCLI, ZF_LOJCLI,  A1_NOME

SELECT R_E_C_N_O_, ZF_COD, ZF_CODFLU, ZF_CODCLI FROM PROTHEUS.SZF010 WHERE ZF_FILIAL = ' ' AND ZF_TIPOVOU = 'F' AND ZF_LOJCLI <> '01'


--ACHAR O TÍTULO
SELECT  E1_PREFIXO, E1_NUM, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO,
        E1_VENCTO, E1_VALOR, E1_BAIXA, E1_SALDO, E1_XNUMVOU, E1_XFLUVOU,
        E1_PEDGAR, E1_XNPSITE, E1_TIPOLIQ, E1_PEDIDO
FROM    PROTHEUS.SE1010 
WHERE   E1_FILIAL = ' ' 
        AND E1_NUM = '005063996'
        AND D_E_L_E_T_ =  ' '

--ACHAR O CLIENTE CORPORATIVO
SELECT  ZF_COD,
        ZF_CODFLU,
        ZF_CODCLI,
        A1_NOME
FROM    PROTHEUS.SZF010 SZF
        INNER JOIN PROTHEUS.SA1010 SA1 
                ON A1_FILIAL = ' ' 
               AND A1_COD = ZF_CODCLI 
WHERE   ZF_COD = '511080560005'
        AND SZF.D_E_L_E_T_ = ' ' 
*/