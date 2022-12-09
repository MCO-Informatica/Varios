#include 'protheus.ch'
#Include "FwMvcDef.CH"
#include "APWIZARD.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} FIADMPNL
Painel de integração Fiorde.
@author  marcio.katsumata
@since   18/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
User Function FIADMPNL()
    local aCoors        as array   
    local oFWLayer      as object 
    local oBrowseRight  as object 
    local oTButton1     as object
    local oTButton2     as object
    local oTButton3     as object
    local oTButton4     as object
    local oTButton5     as object
    local oTButton6     as object
    local oTButton7     as object
    local oTButton8     as object
    local oTButton9     as object
    local oTButton10    as object
    local oTButton11    as object
    local oTButton12    as object
    local cAdmUser      as character
    Local aParamBox     as array
    local oImgIMCD      as object
    local oButOkPar     as object
    local oPnlParam     as object
    private aRetPar     as array
    private oFold       as object
    private oBrowseLeft as object 
    Private oDlgPrinc   as object
    private cCadastro   as character
    private oSayFtp     as object
    private oSayTot     as object
    private oSayPend    as object
    private oSayOk      as object
    private oSayError   as object
    private oChart      as object

    //-------------------------------------
    //Inicialização de variáveis
    //-------------------------------------
    cCadastro := ""
    cAdmUser  := superGetMv("ES_FIADUSR", .F., "000000/000315/000390")
    aParamBox := {}
    aRetPar := {firstDay(date()), date()}

    Define MsDialog oDlgPrinc Title 'Painel Integração Fiorde' From 0, 5 To 598, 1352 Pixel

    //--------------------------------------------------
    // Cria o conteiner onde serão colocados os browses
    //--------------------------------------------------
    oFWLayer := FWLayer():New()
    oFWLayer:Init( oDlgPrinc, .F., .T. )

    //-----------------------------------------------
    //Definição do Painel 
    //-----------------------------------------------
    oFWLayer:AddLine( 'PANEL', 100, .F. )                 //Cria uma "linha" com 100% da tela
    oFwLayer:AddCollumn('MENU', 15, .T.,'PANEL')          //Painel do menu
    oFWLayer:AddCollumn( 'ALL', 85, .T., 'PANEL' )        //Painel central
    oPanelMenu := oFWLayer:GetColPanel( 'MENU', 'PANEL' )
    oPanel     := oFWLayer:GetColPanel( 'ALL', 'PANEL'  ) 

    //-----------------------------------------------------
    //Criação das abas
    //-----------------------------------------------------
    oFold := TFolder():New(0,0,{},,oPanel,,,,.T.,.F.,0,1000)
    oFold:Align := CONTROL_ALIGN_ALLCLIENT
    oFold:Hide()
    oFold:Show()
    oFold:AddItem("Dashboard")
    oFold:AddItem("Log Integração")
    oFold:AddItem("Config. Layout")


    oAba01 := oFold:aDialogs[1]
    oAba02 := oFold:aDialogs[2]
    oAba03 := oFold:aDialogs[3]

    //------------------------
    //Criação do logotipo IMCD
    //------------------------
    oImgIMCD := TBitmap():New(002,002,90,92,,"\fiorde\imcd.png",.T.,oPanelMenu, {||},,.F.,.F.,,,.F.,,.T.,,.F.)
    
    //----------------------------------------
    //Criação dos botões de integração manual 
    //----------------------------------------
    oTButton1 := TButton():New( 052, 002, "Enviar Arquivos"        ,oPanelMenu,{||U_FIEXPCTL()}     , 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
    oTButton2 := TButton():New( 072, 002, "Receber Arquivos"       ,oPanelMenu,{||U_FIGETCTL()}     , 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
    oTButton3 := TButton():New( 092, 002, "Integração Retorno"     ,oPanelMenu,{||U_FIIMPROT('RESULT',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
    oTButton4 := TButton():New( 112, 002, "Integração LI"          ,oPanelMenu,{||U_FIIMPROT('rli',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
    oTButton6 := TButton():New( 132, 002, "Integração Fatura"      ,oPanelMenu,{||U_FIIMPROT('rft',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton7 := TButton():New( 152, 002, "Integração Lote"        ,oPanelMenu,{||U_FIIMPROT('rlt',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton5 := TButton():New( 172, 002, "Integração Booking"     ,oPanelMenu,{||U_FIIMPROT('rbo',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton8 := TButton():New( 192, 002, "Integração Numerario"   ,oPanelMenu,{||U_FIIMPROT('rnm',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton9 := TButton():New( 212, 002, "Integração Despesas"    ,oPanelMenu,{||U_FIIMPROT('rdi',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton10 := TButton():New( 232, 002, "Integração Liq. Cambio",oPanelMenu,{||U_FIIMPROT('rcb',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton11 := TButton():New( 252, 002, "Integração ND"         ,oPanelMenu,{||U_FIIMPROT('rnd',{oSayTot,oSayPend,oSayOk,oSayError})}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    //oTButton12 := TButton():New( 272, 002, "Estorno"               ,oPanelMenu,{||U_RDIEXCLU()}, 90,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    //---------------------------
    // Browse da aba da esquerda
    //---------------------------
    oBrowseLeft:=U_FILOGROT() 
    oBrowseLeft:SetOwner( oAba02 )
    oBrowseLeft:SetProfileID( '1' )


    //---------------------
    // Ativa o Browse 
    //---------------------
    oBrowseLeft:Activate()

    //------------------------------------
    // Browse da aba da direita
    //------------------------------------
    oBrowseRight:=U_FILAYCAD()
    oBrowseRight:SetOwner( oAba03 )
    oBrowseRight:SetProfileID( '2' )

    //--------------------
    // Ativa o Browse
    //--------------------
    oBrowseRight:Activate()


    //---------------------------
    //Criação da aba dashboard
    //---------------------------
    oLayer := FWLayer():New()
    oLayer:Init( oAba01, .T. )

    //---------------------------------------------------
    //Criação das duas colunas principais para dividir 
    //a tela do dashboard no meio verticalmente.
    //---------------------------------------------------
    oLayer:addLine("MAIN", 100)
    oLayer:AddCollumn( "COLMAIN1", 50, , "MAIN"  )
    oLayer:AddCollumn( "COLMAIN2", 50, , "MAIN"  )


    //Determinando a estrutura da primeira coluna (coluna à esquerda)
    oLayerLeft := FWLayer():New()
    oLayerLeft:Init( oLayer:getColPanel("COLMAIN1", "MAIN"), .T. )
    oLayerLeft:AddLine   ( "LinTop", 34 )
	oLayerLeft:AddLine   ( "LinUp", 33 )
    oLayerLeft:AddLine   ( "LinDown", 33 )

    //Determinando a estrutura da segunda coluna (coluna à direita)
    oLayerRight := FWLayer():New()
    oLayerRight:Init( oLayer:getColPanel("COLMAIN2", "MAIN"), .T. )
    oLayerRight:AddLine   ( "LinUp", 50 )
    oLayerRight:AddLine   ( "LinDown", 50 )

    //Montando a tela de parâmetros do dashboard
    oLayerLeft:AddCollumn( "Col01", 100, , "LinTop"  )
    oLayerLeft:AddWindow ( "Col01", "Window01", "Parâmetros do dashboard", 100, .F., , , "LinTop" )
    oPnlParam := oLayerLeft:GetWinPanel( "Col01", "Window01", "LinTop" )
    aAdd(aParamBox,{1,"Data de"  ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
    aAdd(aParamBox,{1,"Data até"  ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
    ParamBox(aParamBox,"Parâmetros...",@aRetPar,,,,,,oPnlParam)
    oButOkPar := TButton():New( 050, 015, "Filtrar",oPnlParam,   {||loadZnt()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 

    //Janela indicador total de registros 
    oLayerLeft:AddCollumn( "Col01", 50, , "LinUp"  )
    oLayerLeft:AddWindow ( "Col01", "Window01", "Transações realizadas", 100, .F., , , "LinUp" )
    oSayTot := qtdZNT( oLayerLeft:GetWinPanel( "Col01", "Window01", "LinUp" ),'1/2/3')

    //Janela indicador de registros pendentes de processamento
    oLayerLeft:AddCollumn( "Col02", 50, , "LinUp"  )
    oLayerLeft:AddWindow ( "Col02", "Window02", "Pendentes de processamento", 100, .F., , , "LinUp" )
    oSayPend :=  qtdZNT( oLayerLeft:GetWinPanel( "Col02", "Window02", "LinUp" ),'1')
     
    //Janela indicador de registros processados com sucesso
    oLayerLeft:AddCollumn( "Col03", 50, , "LinDown"  )
    oLayerLeft:AddWindow ( "Col03", "Window03", "Processadas com sucesso", 100, .F., , , "LinDown" )
    oSayOk := qtdZNT( oLayerLeft:GetWinPanel( "Col03", "Window03", "LinDown" ),'2')

    //Janela indicador de registros processados com erro
    oLayerLeft:AddCollumn( "Col04", 50, , "LinDown"  )
    oLayerLeft:AddWindow ( "Col04", "Window04", "Processadas com erro", 100, .F., , , "LinDown" )
    oSayError := qtdZNT( oLayerLeft:GetWinPanel( "Col04", "Window04", "LinDown" ),'3')

    //Janela do gráfico
    oLayerRight:AddCollumn( "Col01", 100, , "LinUp"  )
    oLayerRight:AddWindow ( "Col01", "Window01", "Gráfico", 100, .F., , , "LinUp" )
    mntChart(oLayerRight:GetWinPanel( "Col01", "Window01", "LinUp" ))

    //Janela teste de conexão FTP
    oLayerRight:AddCollumn( "Col02", 100, , "LinDown"  )
    oLayerRight:AddWindow ( "Col02", "Window02", "Teste conexão FTP", 100, .F., , , "LinDown" )
    oPanelFTP := oLayerRight:GetWinPanel( "Col02", "Window02", "LinDown" )
    montaPnlFTP(oPanelFTP)
    

    //---------------------------
    //Posiciona na primeira aba
    //---------------------------
    oFold:ShowPage(1)

    //--------------------------------------
    //Verifica se o usuário é administrador 
    //do painel  
    //--------------------------------------
    if !(__cUserId $ cAdmUser)
        oFold:HidePage(3)
    endif


    Activate MsDialog oDlgPrinc Center

Return NIL

//-------------------------------------------------------------------
/*/{Protheus.doc} qtdZNT
Função que retorna a quantidade de registros na tabela ZNT do status 
informado.
@author  marcio.katsumata
@since   19/09/2019
@version 1.0
@param   oPanel, object, objeto da janela em que se encontra a informação
@param   cStatus, character, status que deve ser consultado.
@return  object, objeto TSay da informação
/*/
//-------------------------------------------------------------------
Static Function qtdZNT( oPanel,cStatus,dDataDe, dDataAte)


	Local aSizeDialog as array
	Local oFontNeg    as object
    local oSayZNT     as object

    default dDataDe := firstDay(date())
    default dDataAte := date()
    //--------------------------------------
    //Inicialização de variáveis
    //--------------------------------------
	oFontNeg  := TFont():New( 'Arial', , -60, , .T. )
    oSayZNT   := ""
	aSizeDialog	:=	FWGetDialogSize( oPanel )

    oSayZNT := TSay():New( aSizeDialog[1]+15, aSizeDialog[2] +37 , { || queryZNT(cStatus, dDataDe, dDataAte)   }, oPanel,,oFontNeg,,,, .T.,CLR_BLACK,, 300, 300 )     
	
Return oSayZNT

//-------------------------------------------------------------------
/*/{Protheus.doc} queryZNT
Realiza a query para resgatar a quantidade de registros da tabela
ZNT por status.
@author  marcio.katsumata
@since   19/09/2019
@version 1.0
@param   cStatus, character, status a ser consultado
@return  character, quantidade de registros em formato caracter
/*/
//-------------------------------------------------------------------
static function queryZNT(cStatus, dDataDe, dDataAte)
    local cAliasZNT := getNextAlias()

    cStatus := '%'+formatIn(cStatus,"/")+'%'

    beginSql alias cAliasZNT
        SELECT COUNT(*) TOTAL FROM %table:ZNT% ZNT
        WHERE ZNT.ZNT_STATUS IN %exp:cStatus% AND
              ((ZNT.ZNT_RCDATE BETWEEN %exp:dtos(dDataDe)% AND %exp:dtos(dDataAte)%) OR
              (ZNT.ZNT_STDATE BETWEEN %exp:dtos(dDataDe)% AND %exp:dtos(dDataAte)%)) AND
              ZNT.%notDel%
    endSql 

    nQtd := (cAliasZNT)->TOTAL
    (cAliasZNT)->(dbCloseArea())

return alltrim(cValToChar(nQtd))

//-------------------------------------------------------------------
/*/{Protheus.doc} testeFTP
Função responsável pelo teste de conectividade com o FTP Fiorde
@author  marcio.katsumata
@since   19/09/2019
@version 1.0
@param   oSay, object, objeto TSay do FWMsgRun
@return  character, texto com o resultado do teste.
/*/
//-------------------------------------------------------------------
Static Function testeFTP( oSay )

    local cText  as character
    local cMsgErro as character

    default oSay := nil
    
    cMsgErro := ""
    lBarra := !empty(oSay)

    if lBarra
        Sleep(2000)
    endif

    oSftpUtil := SYSFIOFTP():new()
    //Verifica a URL do SFTP
    oSftpUtil:getUrl()

    //Verifica a credenciais de autenticação
    lOkConnect:=oSftpUtil:getAuth(@cMsgErro)
    if lBarra
        if lOkConnect
            oSayFtp:setText("CONEXÃO OK")
        else
            oSayFtp:setText("FALHA CONEXÃO")
        endif
    else
        if lOkConnect
            cText := "CONEXÃO OK"
        else
            cText := "FALHA CONEXÃO"
        endif
    endif

    oSftpUtil:destroy()

    if lBarra
        Sleep(1000)
    endif
    
    freeObj(oSftpUtil)
	

Return cText

//-------------------------------------------------------------------
/*/{Protheus.doc} montaPnlFTP
Função responsável pela montagem dos elementos da janela de teste
de conexão FTP Fiorde.
@author  marcio.katsumata
@since   19/08/2019
@version 1.0
@param   oPanel, object, janela de teste FTP Fiorde.
@return  nil, nil
/*/
//-------------------------------------------------------------------
static function montaPnlFTP(oPanel)
	Local aDiag	   	    as array  
	Local aSizeDialog   as array 
	Local aRetorno      as array 
    Local oFontNeg      as object  
    Local oFont18       as object 
    local oImgConn      as object
    local oImgFTP       as object
    local oImgFiorde    as object
    local oSayUrl       as object
    local oSayPorta     as object


    oFontNeg  := TFont():New( 'Arial', , -18, , .T. )
    oFont18   := TFont():New( 'Arial', , -12, , .F. )
    aSizeDialog	:=	FWGetDialogSize( oPanelFTP )

    //Imagem logo fiorde
    oImgFiorde := TBitmap():New(aSizeDialog[1]+4,aSizeDialog[2]+4,90,92,,"\fiorde\fiorde.png",.T.,oPanel,,,.F.,.F.,,,.F.,,.T.,,.F.)

    //Imagem botão de conexão FTP
    oImgConn := TBitmap():New(aSizeDialog[1]+34,aSizeDialog[2]+200,90,92,,"\fiorde\connectbutton.jpg",.T.,oPanel,;
                                  {||FWMsgRun(oPanelFTP, {|oSay| testeFTP( oSay ) ,'FTP Fiorde','Conectando ao FTP Fiorde'})},;
                                  ,.F.,.F.,,,.F.,,.T.,,.F.)
    oImgConn:lAutoSize := .T.
    oImgConn:lStretch := .T.
    
    //Imagem FTP
    oImgFTP := TBitmap():New(aSizeDialog[2]+34,aSizeDialog[2]+2,90,83,,"\fiorde\ftpicon.jpg",.T.,oPanel,,,.F.,.F.,,,.F.,,.T.,,.F.)
    oImgFTP:lAutoSize := .T.
    oImgFTP:lStretch := .T.
    
    //Texto resultado conexão
    oSayFtp := TSay():New( aSizeDialog[1]+50, aSizeDialog[2] +60 , { || testeFTP( )}, oPanelFTP,,oFontNeg,,,, .T.,CLR_BLACK,, 100, 10 )    
    //Texto endereço FTP
    oSayUrl := TSay():New( aSizeDialog[1]+63, aSizeDialog[2] +60 , { || 'Endereço:'+superGetMv("ES_XFIURL", .F.,"")}, oPanelFTP,,oFont18,,,, .T.,CLR_BLACK,, 100, 10 )   
    //Texto porta FTP
    oSayPorta := TSay():New( aSizeDialog[1]+73, aSizeDialog[2] +60 , { || 'Porta:'+cValToChar(superGetMv("ES_XFIPRT", .F.,21))}, oPanelFTP,,oFont18,,,, .T.,CLR_BLACK,, 100, 10 )   
 
    aSize(aSizeDialog,0)
return


//-------------------------------------------------------------------
/*/{Protheus.doc} mntChart
Monta o gráfico dos indicadores
@author  marcio.katsumata
@since   23/09/2019
@version 1.0
@param   oPanel, object, painel onde deve ser montado o gráfico.
@return nil, nil
/*/
//-------------------------------------------------------------------
static function mntChart(oPanel)
    local dDataDe  as date
    local dDataAte as date 
    if!empty(aRetPar)
        dDataDe := aRetPar[1]
        dDataAte := aRetPar[2]
    else
        dDataDe := firstDay(date())
        dDataAte := date()    
    endif


    oChart := FWChartFactory():New()
    oChart:SetOwner(oPanel)
     
    
    //Para graficos de serie unica utilizar conforme abaixo
    oChart:addSerie('Total',    val(staticcall( FIADMPNL, queryZNT, '1/2/3',dDataDe, dDataAte) ))
    oChart:addSerie('Pendente', val(staticcall( FIADMPNL, queryZNT, '1',dDataDe, dDataAte) ))
    oChart:addSerie('Sucesso',  val(staticcall( FIADMPNL, queryZNT, '2',dDataDe, dDataAte) ))
    oChart:addSerie('Erro',     val(staticcall( FIADMPNL, queryZNT, '3',dDataDe, dDataAte) ))
     

    
    //----------------------------------------------
    //Adiciona Legenda
    //opções de alinhamento da legenda:
    //CONTROL_ALIGN_RIGHT | CONTROL_ALIGN_LEFT |
    //CONTROL_ALIGN_TOP | CONTROL_ALIGN_BOTTOM
    //----------------------------------------------
    oChart:SetLegend(CONTROL_ALIGN_LEFT)
     
    //----------------------------------------------
    //Titulo
    //opções de alinhamento do titulo:
    //CONTROL_ALIGN_RIGHT | CONTROL_ALIGN_LEFT | CONTROL_ALIGN_CENTER
    //----------------------------------------------
    oChart:setTitle("Transações realizadas", CONTROL_ALIGN_CENTER) //"Oportunidades por fase"
     
         
    //----------------------------------------------
    //Opções de alinhamento dos labels(disponível somente no gráfico de funil):
    //CONTROL_ALIGN_RIGHT | CONTROL_ALIGN_LEFT | CONTROL_ALIGN_CENTER
    //----------------------------------------------
    oChart:SetAlignSerieLabel(CONTROL_ALIGN_RIGHT)
     
    //Desativa menu que permite troca do tipo de gráfico pelo usuário
    oChart:EnableMenu(.F.)
             
    //Define o tipo do gráfico
    oChart:SetChartDefault(COLUMNCHART)
    //-----------------------------------------
    // Opções disponiveis
    // RADARCHART  
    // FUNNELCHART 
    // COLUMNCHART 
    // NEWPIECHART 
    // NEWLINECHART
    //-----------------------------------------
 
    oChart:Activate()
return
//-------------------------------------------------------------------
/*/{Protheus.doc} atuVlZNT
Função responsável pela atualização dos indicadores do dashboard do
painel de integração fiorde.
@author  marcio.katsumata
@since   19/09/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function loadZNT()
    local cQtd as character

    oChart:DeActivate()
         
    if!empty(aRetPar)
        dDataDe := aRetPar[1]
        dDataAte := aRetPar[2]
    else
        dDataDe := firstDay(date())
        dDataAte := date()    
    endif

    cQtd := staticcall( FIADMPNL, queryZNT, '1/2/3',dDataDe, dDataAte)
    oChart:addSerie('Total'   ,   val(cQtd) )
    oSayTot:setText(cQtd)

    cQtd := staticcall( FIADMPNL, queryZNT, '1',dDataDe, dDataAte)
    oChart:addSerie('Pendente',   val(cQtd) )    
    oSayPend:setText(cQtd)

    cQtd := staticcall( FIADMPNL, queryZNT, '2',dDataDe, dDataAte)
    oChart:addSerie('Sucesso' ,   val(cQtd) )
    oSayOk:setText(cQtd)

    cQtd := staticcall( FIADMPNL, queryZNT, '3',dDataDe, dDataAte)
    oChart:addSerie('Erro'    ,  val(cQtd) )
    oSayError:setText(cQtd)

         
    oChart:Activate()
         
     
return .T.