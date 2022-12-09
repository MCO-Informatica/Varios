#Include "Protheus.ch"

User Function CSSIS020()
    Local aPesq     := {}
    Local cOpcPesq  := ''
    Local cMensagem := ''
	Local cPesq     := Space(50)

    Local oDlg
    Local oFont

    aPesq := {'Pedido Site','Pedido GAR','Pedido eCommerce','Pedido ERP'}

    cMensagem := 'Esta rotina permite visualizar as informações do pedido, sendo: '
	cMensagem += 'dados de faturamento, produto(s), nota fiscal e dados do CheckOut'

    DEFINE FONT oFont NAME 'Verdana' SIZE 0, -10
    DEFINE MSDIALOG oDlg FROM  0,0 TO 220,500 TITLE 'Tracker de Pedidos' PIXEL
		@ 5,0 BITMAP oBmp RESNAME 'BSPESQUI.PNG' oF oDlg SIZE 70,200 NOBORDER WHEN .F. PIXEL
		@ 03,65 SAY cMensagem OF oDlg PIXEL SIZE 180,20 FONT oFont
        @ 25,63 TO 26,245 LABEL '' OF oDlg PIXEL
		
        @ 30,65 SAY 'Opção de pesquisa:' SIZE 100,7 PIXEL OF oDlg
		@ 40,65 COMBOBOX oOpcPesq VAR cOpcPesq ITEMS aPesq SIZE 100,15 PIXEL OF oDlg
		
		@ 60,65 SAY 'Informação a ser pesquisada:' SIZE 150,7 PIXEL OF oDlg
		@ 70,65 MSGET cPesq PICTURE "@!" SIZE 150,12 PIXEL OF oDlg

		@ 96,167 BUTTON oReq  PROMPT 'Pesquisar'    SIZE 40,11 PIXEL OF oDlg ACTION IIF( Valida(oOpcPesq,cPesq), Pesquisar(oOpcPesq,cPesq,aPesq), NIL )
		@ 96,210 BUTTON oSair PROMPT 'Sair'         SIZE 40,11 PIXEL OF oDlg ACTION oDlg:End()
        
	ACTIVATE MSDIALOG oDlg CENTER
    
Return

Static Function Valida( oOpcPesq,cPesq )
    Local cNum := AllTrim( cPesq )
	Local i := 0
    Local lRet  := .T.

    IF Empty( cPesq )
        MsgAlert('Por favor, informe o dado a pesquisar.', 'TOTVS')
		lRet := .F.
    Else
        IF oOpcPesq:nAt <> 3 //--Pedido Ecommerce possui numeros, sendo assim não critica
            For i := 1 To Len( cNum )
                If .NOT. (SubStr( cNum, i, 1 ) $ '0123456789')
                    MsgAlert('Por favor, informe somente números.', 'TOTVS')
                    lRet := .F.
                    Exit
                Endif
            Next i
        EndIF    
    EndIF    
Return( lRet )

Static Function Pesquisar(oOpcPesq,cPesq,aPesq)
    FWMsgRun(,{|| doResearch( oOpcPesq, Alltrim(cPesq), aPesq ) },,'Por favor aguarde, efetuando a pesquisa...')
Return

Static Function doResearch( oOpcPesq, cPEDIDO, aPesq )
    Local lFound := .F.

    dbSelectArea( 'SC5' )
    IF oOpcPesq:nAt == 1        //--Pedido Site
        SC5->( dbOrderNickName( 'PEDSITE' ) )
        lFound := SC5->( dbSeek( xFilial( 'SC5' ) + cPEDIDO ) )
    ElseIF oOpcPesq:nAt == 2    //--Pedido GAR
        SC5->( dbOrderNickName( 'PEDGAR' ) )
        lFound := SC5->( dbSeek( xFilial( 'SC5' ) + cPEDIDO ) )
    ElseIF oOpcPesq:nAt == 3    //--Pedido eComm
        SC5->( dbOrderNickName( 'PEDECOMM' ) )
        lFound := SC5->( dbSeek( xFilial( 'SC5' ) + cPEDIDO ) )
    Else                        //--Pedido ERP
        SC5->( dbSetOrder(1) )
        lFound := SC5->( dbSeek( xFilial( 'SC5' ) + cPEDIDO ) )
    EndIF

    IF lFound //-- Procurar na GTIN, caso não encontre, informar o usuário para verificar com Integrações Varejo
        ViewPED( SC5->( Recno() ) )
    Else
        MsgAlert('O ' + aPesq[oOpcPesq:nAt] + ' [' + cPEDIDO + '] informado não foi localizado, por favor verifique.')
    EndIF
Return

Static Function ViewPED( nC5_RECNO )
    Local aC    := FWGetDialogSize(oMainWnd)

    Local oFWLayer
    Local oWinPar
    Local oTPanelPar
    Local oOpcPesq
    Local oBtnP
    Local oBtnS
    Local oDlg

    DEFINE MSDIALOG oDlg TITLE '' OF oMainWnd FROM aC[1],aC[2] TO aC[3], aC[4] PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
		oFWLayer := FWLayer():New()	
		oFWLayer:Init( oDlg, .F. )

        oFWLayer:AddCollumn( "Col01", 100, .T. )
		
		oFWLayer:AddWindow( "Col01", "Win01", "Dados de faturamento", 60, .F., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		oFWLayer:AddWindow( "Col01", "Win02", "Produtos" , 30, .T., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
        oFWLayer:AddWindow( "Col01", "Win03", "Nota Fiscal" , 10, .T., .F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
		
		oWinPar  := oFWLayer:GetWinPanel('Col01','Win01')
		oWinRet  := oFWLayer:GetWinPanel('Col01','Win02')
		
		oTPanelPar := TPanel():New(0,0,"",oWinPar,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
		oTPanelPar:Align := CONTROL_ALIGN_ALLCLIENT
		
		oTPanelRet := TPanel():New(0,0,"",oWinRet,NIL,.F.,.F.,NIL,NIL,0,13,.F.,.F.)
		oTPanelRet:Align := CONTROL_ALIGN_ALLCLIENT
		
	ACTIVATE DIALOG oDlg CENTERED
Return