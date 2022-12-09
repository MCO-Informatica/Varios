#Include 'Protheus.ch'
#INCLUDE 'Topconn.ch'

//+-------------------------------------------------------------------+
//| Rotina | CSShowXML | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para apresentar o XML com os dados de venda
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function CSShowXML()
    Local aSAY  := {'Rotina para apresentar o XML com os dados de venda.','Pesquisa efetuada pelo número PEDIDO SITE','','Clique em OK para prosseguir...'}
    Local aBTN  := {}
    Local aPAR  := {}
    Local aRET  := {}
    Local nOpc  := 0

    Private cTitulo := '[CSShowXML] - XML de Vendas'
    Private cIDxml  := ''
    
    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch( cTitulo, aSAY, aBTN )

    IF nOpc == 1
        aAdd( aPAR, {9, "Informe o pedido Site",200,7,.T.})
	    aAdd( aPAR, {1, "Número"	 , Space(9), "","",""   ,"",0,.T.})

        IF ParamBox( aPAR, cTitulo, @aRET )
            FwMsgRun(, {|| cIDxml := A010Find( aRET[2] ), IIF( Empty(cIDxml), MsgALert('Pedido não localizado, por favor verifique'), A010Show(cIDxml) ) },;
                        cTitulo,;
                        'Aguarde, localizando XML para apresentar os dados...')
        Else
            MsgInfo('Processo cancelado',cTitulo)
        EndIF
    EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Find | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Identifica o ID na GtIn conforme o pedido
//+-------------------------------------------------------------------+
Static Function A010Find( cPedSite )
    Local cSQL  := ''
    Local cTRB  := ''
    Local cRet  := ''
   
    cSQL += "SELECT GT_ID, " + CRLF
    cSQL += "       GT_DATE, " + CRLF
    cSQL += "       GT_TIME, " + CRLF
    cSQL += "       R_E_C_N_O_ " + CRLF
    cSQL += "FROM   GTIN " + CRLF
    cSQL += "WHERE  GT_TYPE = 'F' " + CRLF
    cSQL += "       AND GT_XNPSITE = '" + cPedSite + "'" + CRLF

    cTRB := GetNextAlias()
    cSQL := ChangeQuery( cSQL )

    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

    IF .NOT. (cTRB)->( EOF() )
        cRet := (cTRB)->GT_ID        
    EndIF

    (cTRB)->( dbCloseArea() )
    FErase( cTRB + GetDBExtension() )

Return( cRET )
//+-------------------------------------------------------------------+
//| Rotina | A010Show | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para apresentar em tela os dados
//+-------------------------------------------------------------------+
Static Function A010Show(cIDxml)
    Local cArquivo  := ''
    Local cNameFile := ''
	Local cID       := cIDxml    
    Local cError    := ''
    Local cWarning  := ''
    
    Local aC        := FWGetDialogSize(oMainWnd)
    Local oDlg
	Local oFWLayer
    Local oWinPar, oWinRet
    Local oBtnP, oBtnL, oBtnS
    Local oTPanelPar, oTPanelRet
    Local oShowXML
    Local oFont := TFont():New('Consolas',,16,,.F.,,,,,.F.,.F.)
    
    Private oXml        := Nil
    Private cXML        := ''
    Private cPEDIDO     := ''
    Private cPEDGAR     := ''
    Private cPEDERP     := ''
    Private cRootPath	:= "\" + CurDir() + "vendas_site\"

    IF Len(cID) <= 18
        cNameFile    := "Pedidos_" + Left(cID,12) + ".XML"
    Else
        cNameFile    := "Pedidos_" + Left(cID,17) + ".XML"
    EndIF

    cArquivo    := cRootPath + cNameFile
    oXml        := XmlParserFile( cArquivo, "_", @cError, @cWarning )

    cXML := MemoRead( cArquivo )
    If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
		XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
	EndIf

    cPEDIDO := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[1]:_NUMERO:TEXT)

    SC5->( dbOrderNickName( 'PEDSITE' ) )
	IF SC5->( dbSeek( xFilial( 'SC5' ) + cPEDIDO ) )
        cPEDGAR := SC5->C5_CHVBPAG
        cPEDERP := SC5->C5_NUM
    Else
        cPEDERP := 'Pedido não localizado no ERP'
    EndIF

    IF .NOT. Empty( cXML )
        DEFINE MSDIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
            oFWLayer := FWLayer():New()	
            oFWLayer:Init( oDlg, .F. )
            
            oFWLayer:AddCollumn( "Col01", 100, .T. )
            
            oFWLayer:AddWindow( "Col01", "Win01", "Informações pedido"  , 19, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
            oFWLayer:AddWindow( "Col01", "Win02", "Conteúdo do XML - Tabela GTIN - GT_TYPE == 'F' "     , 81, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
            
            oWinPar  := oFWLayer:GetWinPanel('Col01','Win01')
            oWinRet  := oFWLayer:GetWinPanel('Col01','Win02')
            
            oTPanelPar := TPanel():New(0,0,"",oWinPar,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
            oTPanelPar:Align := CONTROL_ALIGN_ALLCLIENT
            
            oTPanelRet := TPanel():New(0,0,"",oWinRet,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
            oTPanelRet:Align := CONTROL_ALIGN_ALLCLIENT
            
            @ 01,003 SAY 'Pedido SITE..: '  + cPEDIDO SIZE 100,7 PIXEL OF oTPanelPar
            @ 10,003 SAY 'Pedido GAR..: '   + cPEDGAR SIZE 100,7 PIXEL OF oTPanelPar
            @ 20,003 SAY 'Pedido ERP....: ' + cPEDERP SIZE 200,7 PIXEL OF oTPanelPar

            oShowXML := TMultiGet():New(1,1,{|u| Iif( PCount()==0,cXML,cXML:=u)},oTPanelRet,140,33,oFont,/*lHScroll*/,/*nClrFore*/,/*nClrBack*/,/*oCursor*/,.T.,/*cMg*/,.T.,{||.F. },/*lCenter*/,/*lRight*/,.F.,{|| .T. },/*bChange*/,.T.,.F.)
		    oShowXML:Align := CONTROL_ALIGN_ALLCLIENT

            @ 9,258 	BUTTON oBtnL ;
					PROMPT "&Visualizar pedido" ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION  FwMsgRun(, {|| A010Visualiza( cPEDIDO ) }, cTitulo, 'Aguarde..' )

            @ 9,318 	BUTTON oBtnL ;
					PROMPT "&Ajustar XML" ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION A010Ajuste( cID, cPEDIDO ) 

            @ 9,378 	BUTTON oBtnL ;
					PROMPT "&Download XML" ;
					SIZE 50,14 ;
					DIALOG oTPanelPar ;
					PIXEL ACTION  A010Download( cRootPath, cNameFile )

            @ 9,438 	BUTTON oBtnS ;
                        PROMPT "Nova busca" ;
                        SIZE 50,14 ;
                        DIALOG oTPanelPar ;
                        PIXEL ACTION  A010New()

            @ 9,498 	BUTTON oBtnS ;
                        PROMPT "&Sair" ;
                        SIZE 50,14 ;
                        DIALOG oTPanelPar ;
                        PIXEL ACTION  oDlg:End()

	    ACTIVATE DIALOG oDlg CENTERED
    Else
        MsgAlert( 'Não foi possível abrir o XML, verifique.', cTitulo )
    EndIF
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Visualiza | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para visualizar o Pedido
//+-------------------------------------------------------------------+
Static Function A010Visualiza(cC5_XNPSITE)
	Local aArea		:= GetArea() //Irei gravar a area atual
	Private Inclui	:= .F. //defino que a inclusão é falsa
	Private Altera  := .T. //defino que a alteração é verdadeira
	Private nOpca	:= 1   //obrigatoriamente passo a variavel nOpca com o conteudo 1
	Private aRotina := {} //obrigatoriamente preciso definir a variavel aRotina como private
	Private cCadastro := "Pedido de Vendas" //obrigatoriamente preciso definir com private a variável cCadastro
	
	DbSelectArea("SC5") //Abro a tabela SC5
	SC5->( dbOrderNickName( 'PEDSITE' ) )
	SC5->( dbSeek( xFilial("SC5") + cC5_XNPSITE ) ) //Localizo o meu pedido
	If SC5->(!EOF()) //Se o pedido existe irei continuar
		SC5->(DbGoTo(Recno())) //Me posiciono no pedido
		MatA410(Nil, Nil, Nil, Nil, "A410Visual") //executo a função padrão MatA410
	Endif
	SC5->(DbCloseArea()) //quando eu sair da tela de visualizar pedido, fecho o meu alias
	RestArea(aArea) //restauro a area anterior.
Return
//+-------------------------------------------------------------------+
//| Rotina | A010Download | Autor | Rafael Beghini | Data | 31/07/2019 
//+-------------------------------------------------------------------+
//| Descr. | Realiza o download do XML
//+-------------------------------------------------------------------+
Static Function A010Download( cDir, cNameFile )
    Local cTempUser	:= GetTempPath()

    IF __CopyFile( cDir + cNameFile, cTempUser + cNameFile )
        ShellExecute( "Open", cTempUser + cNameFile , '', '', 1 )
    EndIF
Return

//+-------------------------------------------------------------------+
//| Rotina | A010Ajuste | Autor | Rafael Beghini | Data | 19.08/2019 
//+-------------------------------------------------------------------+
//| Descr. | Realiza o ajuste do XML pela rotina VNDA080
//+-------------------------------------------------------------------+
Static Function A010Ajuste( cID, cPEDIDO )
    Local cSQL  := ''
    Local cTRB  := ''
    Local nREC  := 0

    cSQL += "SELECT GT_ID, " + CRLF
    cSQL += "       Max(R_E_C_N_O_) RECIN " + CRLF 
    cSQL += "FROM   GTIN " + CRLF
    cSQL += "WHERE  GT_TYPE = 'F'  " + CRLF
    cSQL += "       AND GT_XNPSITE = '" + cPEDIDO + "' " + CRLF
    cSQL += "GROUP  BY GT_ID " + CRLF

    cTRB := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)

    nREC := (cTRB)->RECIN
    (cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

    U_VNDA080( cID, cPEDIDO, '', '', nREC )
Return

//+-------------------------------------------------------------------+
//| Rotina | A010New | Autor | Rafael Beghini | Data | 15.10.2019 
//+-------------------------------------------------------------------+
//| Descr. | Realiza uma nova consulta sem sair da rotina
//+-------------------------------------------------------------------+
Static Function A010New()
    Local aPAR      := {}
    Local aRET      := {}
    Local cNewId    := ''
    Local cArquivo  := ''
    Local cError    := ''
    Local cWarning  := ''
    Local cNameFile := ''
    
    aAdd( aPAR, {9, "Informe o pedido Site",200,7,.T.})
    aAdd( aPAR, {1, "Número"	 , Space(9), "","",""   ,"",0,.T.})
    
    IF ParamBox( aPAR, cTitulo, @aRET )
        cNewId := A010Find( aRET[2] )

        IF .NOT. Empty( cNewId )
            IF Len(cNewId) <= 18
                cNameFile   := "Pedidos_" + Left(cNewId,12) + ".XML"
            Else
                cNameFile   := "Pedidos_" + Left(cNewId,17) + ".XML"
            EndIF

            cArquivo := cRootPath + cNameFile
            oXml     := XmlParserFile( cArquivo, "_", @cError, @cWarning )
           
            cXML := MemoRead( cArquivo )

            If Valtype(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO) <> "A"
                XmlNode2Arr( oXml:_LISTPEDIDOFULLTYPE:_PEDIDO, "_PEDIDO" )
            EndIf

            cPEDIDO := AllTrim(oXml:_LISTPEDIDOFULLTYPE:_PEDIDO[1]:_NUMERO:TEXT)

            SC5->( dbOrderNickName( 'PEDSITE' ) )
            IF SC5->( dbSeek( xFilial( 'SC5' ) + cPEDIDO ) )
                cPEDGAR := SC5->C5_CHVBPAG
                cPEDERP := SC5->C5_NUM
            Else
                cPEDERP := 'Pedido não localizado no ERP'
            EndIF
        Else
            MsgALert('Pedido não localizado, por favor verifique')
        EndIF
    Else
        MsgInfo('Processo cancelado',cTitulo)
    EndIF    
Return