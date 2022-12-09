#INCLUDE "Protheus.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "IMPFER.CH"
#INCLUDE "Colors.Ch"
#INCLUDE "RptDef.Ch"
#INCLUDE "FwPrintSetup.Ch"

#DEFINE cEMPRESA "01"

/*/{Protheus.doc} ESPA010
Rotina de controle de envio de recibo de férias via portal de assinaturas Certisign.
@type function
@author Bruno Nunes
@since 28/08/2018
@version P12 1.12.17
@return null, Nulo
/*/
user function ESPA010()
	local nHeightBtn   := 15

	private aBrwCabec  := { 'Pedido Site', 'Pedido Venda','Produto','Desc. Prod.', 'NF','Série NF', 'Data do Faturamento', 'Link Hardware', 'Link Entrega', 'Recno SC5' }
	private aBrowse    := {}
	private aCodFol    := {}     // Matriz com Codigo da folha
	private anLinha    := {}
	private oBrowse    := nil
	private oButton1   := nil
	private oButton2   := nil
	private oDlgP      := nil
	private oLayer 	   := FWLayer():new()
	private oPanel1    := nil
	private oPanel2    := nil
	private oPanel3    := nil

	if pergunte( "ESPA010", .T.)

		oDlgP := tDialog():New(180,180,750,1366, "Faturando pedidos de produtos",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
		oPanel1:= tPanel():New(0,0,"",oDlgP,,,,,,240,13)
		oPanel1:setCSS("QLabel{background-color:rgb(239,243,247)}")
	
		oPanel1:Align:= CONTROL_ALIGN_BOTTOM
	
		oButton2 := tButton():New( 002, 002, "Fechar",oPanel1,{||oDlgP:End()}, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
		oButton2:SetCSS("QPushButton{}")
		oButton2:Align:= CONTROL_ALIGN_RIGHT
	
		oLayer:init(oDlgP,.F.)
	
		oLayer:addCollumn('Col01',20,.F.)
		oLayer:addCollumn('Col02',80,.F.)
	
		oLayer:addWindow('Col01','C1_Win01','Ações'			,100,.F.,.F.,{|| },,{|| })
		oLayer:addWindow('Col02','C1_Win02','Lista de pedidos'	,100,.F.,.F.,{|| },,{|| })
	
		oPanel2:= tPanel():New(0,0,"",oLayer:getWinPanel('Col01','C1_Win01'),,,,,,240,13)
		oPanel2:Align:= CONTROL_ALIGN_ALLCLIENT
	
		oButton1 := tButton():New( 002, 002, "Faturando pedidos de produtos", oPanel2,{|| Processa( {|| procFat() }, "Aguarde", "Faturando pedidos de produtos.",.F.) }, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
		oButton1:SetCSS( "QPushButton{}" )
		oButton1:Align:= CONTROL_ALIGN_TOP
	
		oPanel3 := tPanel():New(0,0,"",oLayer:getWinPanel( 'Col02', 'C1_Win02' ),,,,,,240,13)
		oPanel3:Align:= CONTROL_ALIGN_ALLCLIENT
		oBrowse := TWBrowse():New( 001 , 001, 160,106,,aBrwCabec,{40,40,40,40,40},oPanel3,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	
		loadList()
		oDlgP:Activate(,,,.T.)
	endif
return

/*/{Protheus.doc} loadList
Carrega lista de processo do recibo de férias
@type function
@author Bruno Nunes
@since 28/08/2018
@version P12 1.12.17
@return null, Nulo
/*/
static function loadList()
	aBrowse := getSC6()
	oBrowse:Resetlen()
	if len(aBrowse) == 0
		aAdd(aBrowse, aFill(array(8), "") )
	endif

	oBrowse:SetArray( aBrowse )
	oBrowse:bLine := {||{ aBrowse[oBrowse:nAt,01],aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05],aBrowse[oBrowse:nAt,06],aBrowse[oBrowse:nAt,07],aBrowse[oBrowse:nAt,08] } }
	oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oBrowse:DrawSelect()
return

/*/{Protheus.doc} getSC6
Rertorna lista de item de pedido que esta em branco
@type function
@author Bruno Nunes
@since 07/08/2020
@version P12 1.12.17
@return null, Nulo
/*/
Static Function getSC6()
	local aLista   := {}
	local aItem    := {}
	local cQuery   := ""
	local cAlias   := ""
	local cEmissao := ""
	local oQuery   := nil
	
	if MV_PAR02 == ctod("//") .or. MV_PAR03 == ctod("//") 
		alert("As datas estão vazias, preencha a data 'de' e 'até' para continuar o processamento ")
		return {}
	endif
	
	cQuery := " SELECT " 
	cQuery += " 	C5_XNPSITE, "
	cQuery += " 	C6_NUM, "
	cQuery += " 	C6_PRODUTO, "
	cQuery += " 	C6_DESCRI,  "
	cQuery += " 	C6_NOTA, "
	cQuery += " 	C6_SERIE, "
	cQuery += " 	C5_EMISSAO, "
	cQuery += " 	C6_XNFHRD, "
	cQuery += " 	C6_XNFHRE, "
	cQuery += " 	SC5.R_E_C_N_O_ REC "
	cQuery += " FROM  "
	cQuery += "  	SC6010 SC6 "
	cQuery += " INNER JOIN SC5010 SC5 ON "
	cQuery += " 	SC5.D_E_L_E_T_ = ' ' "
	cQuery += "  	AND C5_FILIAL  = C6_FILIAL "
	cQuery += "  	AND C5_NUM     = C6_NUM "
	cQuery += " AND C5_EMISSAO BETWEEN '" + dtos( MV_PAR02 ) + "' AND '" + dtos( MV_PAR03 ) + "' "
	if !empty(MV_PAR01)
		cQuery += " AND C5_XNPSITE = '" + MV_PAR01 + "' "
	endif 
	cQuery += " WHERE "
	cQuery += " 	SC6.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND C6_FILIAL  = '  ' "
	cQuery += " 	AND C6_NOTA    = ' ' "
	cQuery += " ORDER BY C5_XNPSITE " 	

	oQuery := CSQuerySQL():New()
	if oQuery:Consultar( cQuery )
		cAlias  := oQuery:GetAlias() //Alias da tabela temporaria
		while (cAlias)->(!EoF())
			cEmissao := (cAlias)->( dtoc( stod( C5_EMISSAO ) ) )
			 
			aItem  := {}
			aAdd( aItem , (cAlias)->C5_XNPSITE ) //01
			aAdd( aItem , (cAlias)->C6_NUM	   ) //02
			aAdd( aItem , (cAlias)->C6_PRODUTO ) //03
			aAdd( aItem , (cAlias)->C6_DESCRI  ) //04
			aAdd( aItem , (cAlias)->C6_NOTA    ) //05
			aAdd( aItem , (cAlias)->C6_SERIE   ) //06
			aAdd( aItem , cEmissao             ) //07
			aAdd( aItem , (cAlias)->C6_XNFHRD  ) //08
			aAdd( aItem , (cAlias)->C6_XNFHRE  ) //09
			aAdd( aItem , (cAlias)->REC        ) //10

			aAdd( aLista, aItem )
			(cAlias)->(dbSkip())
		end
		( cAlias )->( dbCloseArea() )  		
	endif
return aLista

/*/{Protheus.doc} procFat
Rertorna lista de item de pedido que esta em branco
@type function
@author Bruno Nunes
@since 07/08/2020
@version P12 1.12.17
@return null, Nulo
/*/
static function procFat()
	local cTipTitRec := ""
	local i          := 1
	local nRecPed    := 0
	local lFat       := .T.
	local lProd      := .T. 
	local lServ      := .F. 
	local lEnt       := .F. 
	local lRecPgto   := .F.
	local lGerTitRec := .F.
	local oLog 	     := nil	

	oLog := CSLog():New()
	oLog:SetAssunto( "[ ESPA010 ] Processamento de faturamento - U_VNDA190P" )
	oLog:AddLog( "Processando faturamento" )

	ProcRegua( len( aBrowse ) )
 	for i := 1 to len( aBrowse )
 		IncProc("Reprocessando pedido: "+aBrowse[i][1]+" "+strzero( i, 6 )+"/"+strzero( len( aBrowse ), 6 ) )
		nRecPed := aBrowse[i][10]
		oLog:AddLog( { "Pedido Site.......: " + aBrowse[i][01],;
					   "Pedido Protheus...: " + aBrowse[i][02],;
					   "Pedido Produto....: " + aBrowse[i][03],;
					   "Pedido Descrição..: " + aBrowse[i][04],;
					   "Nota Fiscal.......: " + aBrowse[i][05],;
					   "Nota Série........: " + aBrowse[i][06],;
					   "Nota Data Emissão.: " + aBrowse[i][07],;
					   "Nota Link Hardware: " + aBrowse[i][08],;
					   "Nota Link Entrega.: " + aBrowse[i][09],;
					   "Recno SC5.........: " + aBrowse[i][10] ;
					  } )
		
		//U_VNDA190P( cEMPRESA, cFilAnt , nRecPed, lFat, lProd, lServ, lEnt, lRecPgto, lGerTitRec, cTipTitRec ) //Fatura Produto
		StartJob("U_VNDA190P", GetEnvServer(), .F., cEMPRESA, cFilAnt, nRecPed, lFat,lProd, lServ, lEnt,lRecPgto,lGerTitRec,cTipTitRec)  //Apenas nota de entrega
	next i
	oLog:EnviarLog()
return