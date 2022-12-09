#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
Static nREGISTROS := 0
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CPEDF002   ºAutor  ³ José Felipe   º Data ³ 03/11/2015      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão de Registros da Tabela GTLEGADO.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AcademiaERP                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSRGTL001()
	Local aSAY  := {'Rotina para gerar relatório em formato XML com registros da GTLEGADO.','','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
	Local aOPC	:= {"1.Produto","2.Serviço","3.Ambos"}
    Local nOpc  := 0
	
    Private aRET := {}
    Private cTRB := ''
    Private cTitulo := '[CSRGTL001] - Dados GT Legado'
	Private cTime := Time()

    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch(cTitulo, aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe o período da consulta",200,7,.T.})
	    aAdd( aPAR, {1, "Data de"	 , Ctod(Space(8)), "","",""   ,"",0,.F.})
	    aAdd( aPAR, {1, "Data ate"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
		aAdd( aPAR, {2,	"Opção"		 ,	1,	aOPC,50,"",.F.})

        IF ParamBox(aPAR,cTitulo,@aRET)
			
            A010Proc( aRET )
        Else
            MsgInfo('Processo cancelado',cTitulo)
        EndIF
    EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Proc | Autor | Rafael Beghini | Data | 21.09.2018 
//+-------------------------------------------------------------------+
//| Descr. | Apresenta a tela de processamento
//+-------------------------------------------------------------------+
Static Function A010Proc( aRET )
    Local oDlg   := Nil
    Local oSay   := Nil
    Local oMeter := Nil
    Local nMeter := 0

    Define Dialog oDlg Title cTitulo From 0,0 To 70,380 Pixel
        @05,05  Say oSay Prompt "Aguarde, montando a query conforme parâmetros informados." Of oDlg Pixel Colors CLR_RED,CLR_WHITE Size 185,20
        @15,05  Meter oMeter Var nMeter Pixel Size 160,10 Of oDlg
        @13,170 BITMAP Resource "PCOIMG32.PNG" SIZE 015,015 OF oDlg NOBORDER PIXEL
    Activate Dialog oDlg Centered On Init ( IIF( A010Qry( aRET ), A010Imp(oDlg, oSay, oMeter), NIL ), oDlg:End() )
    
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Qry | Autor | Rafael Beghini | Data | 21.09.2018 
//+-------------------------------------------------------------------+
//| Descr. | Monta a query conforme parâmetros
//+-------------------------------------------------------------------+
Static Function A010Qry( aRET )
    Local cSQL   := ''
	Local cCount := ''
    Local lRet   := .T.
	Local cOpc   := IIf( ValType( aRET[4] ) == 'C', Subs(aRET[4],1,1), LTrim( Str( aRET[4], 1, 0 ) ) )

   	cSQL += " SELECT DISTINCT "
	cSQL += "    GTLEGADO.GT_TYPE"
	cSQL += "    ,GTLEGADO.GT_PEDGAR"
	cSQL += "    ,GTLEGADO.GT_INPROC"
	cSQL += "    ,GTLEGADO.GT_PEDVENDA"
	cSQL += "    ,GTLEGADO.GT_DATA"
	cSQL += "    ,GTLEGADO.GT_DTREF"
	cSQL += "    ,GTLEGADO.GT_TPREF"
	cSQL += "    ,GTLEGADO.GT_LANCTBPRD"
	cSQL += "    ,GTLEGADO.GT_REVCTBPRD"
	cSQL += "    ,GTLEGADO.GT_PRDODUTO"
	cSQL += "    ,GTLEGADO.GT_VLRPRD"
	cSQL += "    ,GTLEGADO.GT_VLRPIS"
	cSQL += "    ,GTLEGADO.GT_VLRCOFINS"
	cSQL += "    ,GTLEGADO.GT_PRODUTO"
	cSQL += "    ,GTLEGADO.GT_DTBAIXA"
	cSQL += "    ,GTLEGADO.GT_DTESTBAIXA"
	
	cSQL += "  FROM GTLEGADO GTLEGADO "
	
	cSQL += " WHERE GTLEGADO.D_E_L_E_T_  = ' ' AND "
	
	IF cOpc == '1' //Produto
		//((GT_LANCTBPRD ou  GT_REVCTBPRD dentro do perido) e GT_TYPE = P)
		cSQL += "( ( GT_LANCTBPRD >= '" +  DtoS( aRET[2] ) + "' AND GT_LANCTBPRD <= '" +  DtoS( aRET[3] ) + "' AND GT_TYPE = 'P' ) "
 		cSQL += "OR ( GT_REVCTBPRD >= '" +  DtoS( aRET[2] ) + "' AND GT_REVCTBPRD <= '" +  DtoS( aRET[3] ) + "' AND GT_TYPE = 'P' ) ) "
	ElseIF cOpc == '2' //Serviço
		//(GT_DATA dentro do periodo e GT_TYPE = S)
		cSQL += "( GT_DATA >= '" +  DtoS( aRET[2] ) + "' AND GT_DATA <= '" +  DtoS( aRET[3] ) + "' AND GT_TYPE = 'S') "
	Else //Ambos
		//(( ( GT_LANCTBPRD ou  GT_REVCTBPRD dentro do perido) e GT_TYPE = P) ou (GT_DATA dentro do periodo e GT_TYPE = S))
		cSQL += "( ( GT_LANCTBPRD >= '" +  DtoS( aRET[2] ) + "' AND GT_LANCTBPRD <= '" +  DtoS( aRET[3] ) + "' AND GT_TYPE = 'P') "
		cSQL += "OR "
		cSQL += "( GT_REVCTBPRD >= '" +  DtoS( aRET[2] ) + "' AND GT_REVCTBPRD <= '" +  DtoS( aRET[3] ) + "' AND GT_TYPE = 'P') "
		cSQL += "OR "
		cSQL += "( GT_DATA >= '" +  DtoS( aRET[2] ) + "' AND GT_DATA <= '" +  DtoS( aRET[3] ) + "' AND GT_TYPE = 'S') )"
	EndiF

	cSQL += " ORDER BY GT_TYPE, GT_PEDGAR"

    cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
		
	cCount := ' SELECT COUNT(*) COUNT FROM ( ' + cSQL + ' ) QUERY '
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cCount),cTRB,.F.,.T.)
	nREGISTROS := (cTRB)->COUNT
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )
	
	cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

	TcSetField( cTRB, "GT_DATA"      , "D", 8 )
	TcSetField( cTRB, "GT_DTREF"     , "D", 8 )
	TcSetField( cTRB, "GT_LANCTBPRD" , "D", 8 )
	TcSetField( cTRB, "GT_REVCTBPRD" , "D", 8 )
	TcSetField( cTRB, "GT_DTBAIXA"	 , "D", 8 )
	TcSetField( cTRB, "GT_DTESTBAIXA", "D", 8 )

    IF (cTRB)->( EOF() )
        lRet := .F.    
        (cTRB)->( dbCloseArea() )
	    FErase( cTRB + GetDBExtension() )
        MsgInfo('Não há dados para extração conforme parâmetros informados.',cTitulo)
    EndIF
Return( lRet )
//+-------------------------------------------------------------------+
//| Rotina | CSFIN040 | Autor | Rafael Beghini | Data | 12.07.2018 
//+-------------------------------------------------------------------+
//| Descr. | Gera o relatório no formato .XML
//+-------------------------------------------------------------------+
Static Function A010Imp(oDlg, oSay, oMeter)
    Local nSeconds    := 0
    Local nCount      := 0
    Local nLastUpdate := 0
    Local cWorkSheet  := 'GT Legado'
	Local cTable      := 'Dados GT Legado - período [' + dTOC( aRET[ 2 ] ) + ' - ' + dTOC( aRET[ 3 ] ) + ']'
	Local cPath       := GetTempPath() //Função que retorna o caminho da pasta temp do usuário logado, exemplo: %temp%
	Local cNameFile   := cPath + 'GTLegado' + dTos(Date()) + ".XML"
	Local oExcel      := FWMSEXCEL():New() //Método para geração em XML
	Local cGRpRede	  := ''
	Local dDtPed	  := ''
	Local dDtVal	  := ''
	Local dDtVer	  := ''
	Local dDtEmi	  := ''
	Local cAR		  := ''
	Local cDescAR	  := ''
	Local cPOSTO	  := ''
	Local cDescPosto  := ''
	Local cPRDGAR	  := ''
	Local cDescPrd	  := ''
	Local cGRUPO	  := ''
	Local cDescGRP	  := ''
	Local cAC		  := ''
	Local cDescAC	  := ''
	Local cREDE		  := ''
	Local cDescREDE	  := ''
	Local cParceiro	  := ''
	Local cDescParc	  := ''
	Local cARPedido	  := ''
	Local cDescARPed  := ''
	Local cMsg		  := ''
	Local cCCR		  := ''
	Local cDescCCR	  := ''
	Local cZ3_FIL	  := xFilial('SZ3')
	Local cZ5_FIL	  := xFilial('SZ5')
	Local cPA8_FIL	  := xFilial('PA8')

    
    oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
	oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela
	
	//Adiciona uma coluna a tabela de uma Worksheet.
	//     AddColumn( cWorkSheet, cTable, < cColumn >           , nAlign, nFormat, lTotal)
	oExcel:AddColumn( cWorkSheet, cTable, "Tipo"		     , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Ped GAR"          , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Ped ERP"          , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data"             , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data ref"         , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Tipo"             , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Lançamento"       , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Reversão"         , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Produto"          , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor"            , 1     , 3      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor PIS"        , 1     , 3      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Valor COFINS"     , 1     , 3      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Baixa"            , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Estorno"          , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Grupo/Rede"       , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data pedido"      , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data validação"   , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data verificação" , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Data emissão"     , 1     , 4      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "AR"               , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "POSTO"            , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Produto GAR"      , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "GRUPO"            , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "AC"               , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "REDE"             , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Parceiro"         , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Código AR pedido" , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "CCR"              , 1     , 1      , .F. )
	oExcel:AddColumn( cWorkSheet, cTable, "Descrição"        , 1     , 1      , .F. )
	
    //nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	//lTotal  > Indica se a coluna deve ser totalizada

    oMeter:SetTotal(nREGISTROS)
    nSeconds := Seconds()

    oSay:SetText("Aguarde, montando o relatório. Total de registro(s): " + AllTrim( Str(nREGISTROS) ) )

    
    SZ3->( dbSetOrder(4) )
	SZ5->( dbSetOrder(1) )
    PA8->( dbSetOrder(1) )

    (cTRB)->( dbGotop() )
    While .NOT. (cTRB)->( EOF() )
        nCount++
        IF (Seconds() - nLastUpdate) > 1 // Se passou 1 segundo desde a última atualização da tela
            oMeter:Set(nCount)
            oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback

            nLastUpdate := Seconds()
        EndIf

        IF SZ5->( dbSeek( cZ5_FIL + (cTRB)->GT_PEDGAR ) )
            dDtPed	  	:= SZ5->Z5_DATPED
			dDtVal	  	:= SZ5->Z5_DATVAL
			dDtVer	  	:= SZ5->Z5_DATVER
			dDtEmi	  	:= SZ5->Z5_DATEMIS
			cAR		  	:= SZ5->Z5_CODAR
			cDescAR		:= SZ5->Z5_DESCAR
			cPOSTO	  	:= SZ5->Z5_CODPOS
			cDescPosto	:= SZ5->Z5_DESPOS
			cPRDGAR		:= SZ5->Z5_PRODGAR
			cDescPrd	:= SZ5->Z5_DESPRO
			cGRUPO	 	:= SZ5->Z5_GRUPO
			cDescGRP	:= SZ5->Z5_DESGRU
			cAC		  	:= SZ5->Z5_CODAC
			cDescAC		:= SZ5->Z5_DESCAC
			cREDE		:= SZ5->Z5_REDE
			cDescREDE	:= SZ5->Z5_DESREDE
			cParceiro	:= SZ5->Z5_CODPAR
			cDescParc	:= SZ5->Z5_NOMPAR
			cARPedido	:= SZ5->Z5_CODARP
			cDescARPed	:= SZ5->Z5_DESCARP

			PA8->( dbSeek( cPA8_FIL + SZ5->Z5_PRODGAR ) )
			cGRpRede	:= PA8->PA8_CLAPRO

			SZ3->( dbSeek( cZ3_FIL + cPOSTO ) )
			cCCR		:= SZ3->Z3_CODCCR
			cDescCCR	:= SZ3->Z3_CCRCOM
        Else
           	dDtPed	  	:= ' '
			dDtVal	  	:= ' '
			dDtVer	  	:= ' '
			dDtEmi	  	:= ' '
			cAR		  	:= ' '
			cDescAR		:= ' '
			cPOSTO	  	:= ' '
			cDescPosto	:= ' '
			cPRDGAR		:= ' '
			cDescPrd	:= ' '
			cGRUPO	 	:= ' '
			cDescGRP	:= ' '
			cAC		  	:= ' '
			cDescAC		:= ' '
			cREDE		:= ' '
			cDescREDE	:= ' '
			cParceiro	:= ' '
			cDescParc	:= ' '
			cARPedido	:= ' '
			cDescARPed	:= ' '
			cCCR		:= ' '
			cDescCCR	:= ' '
        EndIF

        oExcel:AddRow( cWorkSheet, cTable, { (cTRB)->GT_TYPE,;
                                                (cTRB)->GT_PEDGAR,;
                                                (cTRB)->GT_PEDVENDA,;
                                                (cTRB)->GT_DATA,;
                                                (cTRB)->GT_DTREF,;
                                                (cTRB)->GT_TPREF,;
                                                (cTRB)->GT_LANCTBPRD,;
                                                (cTRB)->GT_REVCTBPRD,;
                                                (cTRB)->GT_PRODUTO,;
                                                (cTRB)->GT_VLRPRD,;
                                                (cTRB)->GT_VLRPIS,;
                                                (cTRB)->GT_VLRCOFINS,;
                                                (cTRB)->GT_DTBAIXA,;
                                                (cTRB)->GT_DTESTBAIXA,;
                                                cGRpRede,;
												dDtPed	,;
												dDtVal	,;
												dDtVer	,;
												dDtEmi	,;
												cAR		,;
												cDescAR		,;
												cPOSTO	,;
												cDescPosto	,;
												cPRDGAR	,;
												cDescPrd,;
												cGRUPO	,;
												cDescGRP,;
												cAC,;
												cDescAC,;
												cREDE,;
												cDescREDE,;
												cParceiro,;
												cDescParc,;
												cARPedido,;
												cDescARPed,;
												cCCR,;
												cDescCCR} )
        (cTRB)->( dbSkip() )
    End

    (cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

    oMeter:Set(nCount) // Efetua uma atualização final para garantir que o usuário veja o resultado do processamento
    oDlg:CommitControls() // Para atualizar a tela e o usuário receber o feedback
    
    oExcel:Activate() //Executa o XML
	oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório
	
	ShellExecute( "Open", cNameFile , '', '', 1 ) //Abre o arquivo na tela após salvar

	cMsg := 'Hora inicial do processamento..: ' + cTime + CRLF
	cMsg += 'Hora final do processamento....: ' + Time()
	Aviso( cTitulo, cMsg , { 'Sair' }, 1 )
Return
