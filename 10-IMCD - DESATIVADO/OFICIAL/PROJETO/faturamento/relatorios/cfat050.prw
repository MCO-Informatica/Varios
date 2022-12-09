#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"                     
#INCLUDE "PROTHEUS.CH"    
#include "MSGRAPHI.CH"    
#INCLUDE "MSOLE.CH"

/*/                         
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFAT050   บ Autor ณ Giane              บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Consultas de ranking de faturamento                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFAT050   

	Local aArea := GetArea()                
	Local aConf := {} 
	Local aButtons := {}		
	Local bExcel   := {||}  

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "CFAT050" , __cUserID )

	Private cPerg := "CFAT050   "  
	Private oDlg
	Private oPanel 
	Private oPanelR
	Private oGet	
	Private oScroll
	Private aCols    := {}
	Private aHeader  := {}   
	Private cGrpAcesso:= ""  
	Private lGerente  := .f.
	Private lVendedor := .f.   
	Private cCadastro := "Consulta Ranking de Faturamento"                            
	Private lRefresh  := .T.   
	Private nTotGer   := 0  //variavel para guardar valor total geral utilizada no calculo da % de cada cliente   
	Private nQtdLiq   := 0  //guarda qtde de pedidos liquidados ref total da consulta
	Private nQtdPen   := 0  // guarda qtde de pedidos pendentes ref total da consulta   
	Private nTotPen   := 0
	Private nTotLiq   := 0  
	Private nQtdCanc  := 0
	Private nTotCanc  := 0  
	Private nQtdDev   := 0
	Private nTotDev   := 0
	Private oBtnCli 
	Private oBtnProd
	Private oBtnGruV  
	Private oBtnSegV
	Private oBtnVend
	Private oBtnVendI
	Private oBtnUF
	Private oBtnCond
	Private oBtnFret 
	Private oBtnGruS		// CRIADO NOVO BOTAO PARA CONSULTA PELO GRUPO SUPERIOR DO CLIENTE, EM 23/01/2014 - ANALISTA MARCUS VINICIUS BARROS 
	Private cMVPAR01
	Private cMVPAR02
	Private cMVPAR03
	Private cMVPAR04
	Private cMVPAR05
	Private cMVPAR06
	Private cMVPAR07
	Private cMVPAR08
	Private cMVPAR09
	Private cMVPAR10
	Private cMVPAR11
	Private cMVPAR12
	Private cMVPAR13
	Private cMVPAR14
	Private cMVPAR15
	Private cMVPAR16
	Private cMVPAR17
	Private cMVPAR18
	Private cMVPAR19
	Private cMVPAR20
	Private cMVPAR21

	Pergunte(cPerg,.F.)  

	cMVPAR01 := MV_PAR01
	cMVPAR02 := MV_PAR02
	cMVPAR03 := MV_PAR03
	cMVPAR04 := MV_PAR04
	cMVPAR05 := MV_PAR05
	cMVPAR06 := MV_PAR06
	cMVPAR07 := MV_PAR07
	cMVPAR08 := MV_PAR08
	cMVPAR09 := MV_PAR09 
	cMVPAR10 := MV_PAR10
	cMVPAR11 := MV_PAR11
	cMVPAR12 := MV_PAR12
	cMVPAR13 := MV_PAR13
	cMVPAR14 := MV_PAR14
	cMVPAR15 := MV_PAR15
	cMVPAR16 := MV_PAR16
	cMVPAR17 := MV_PAR17
	cMVPAR18 := MV_PAR18
	cMVPAR19 := MV_PAR19 
	cMVPAR20 := MV_PAR20
	cMVPAR21 := MV_PAR21


	//=========== Regra de Confidencialidade =====================================  
	/*aConf := U_Chkcfg(__cUserId)
	cGrpAcesso:= aConf[1]   

	If Empty(cGrpAcesso)  
	MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Aten็ใo!") 
	RestArea( aArea )
	Return 
	Endif */

	//lGerente 	:= aConf[2] 
	//lVendedor 	:= aConf[4] 

	lGerente 	:= .F. 
	lVendedor 	:= .F. 

	//============================================================================	 

	DEFINE FONT oFntR Name "Arial" SIZE 0,16 

	//Definicao de Size da Tela
	aSize := MsAdvSize()

	bExcel := {||DlgToExcel( {{"ARRAY","",{},{{}}},{"GETDADOS","",oGet:aHeader,oGet:aCols} }) }

	AAdd(aButtons,{PmsBExcel()[1], bExcel, "Excel", "Excel" } ) 
	aadd(aButtons,{'SIMULACA',{||Processa( {|lEnd| Totaliza()}, "Aguarde...","Processando Totalizadores", .T. ) },"Totalizador"})  
	aadd(aButtons,{'GRAF3D',{||Processa( {|lEnd| Grafico()}, "Aguarde...","Montando Grแfico", .T. ) },"Grแfico"}) 
	aadd(aButtons,{ 'C9',{||Processa( {|lEnd| Iif(Pergunte(cPerg), fInicio(), )}, "","", .T. ) },"Parโmetros"}) 
	aadd(aButtons,{'POSCLI',{||Processa( {|lEnd| VCliente()} ) },"Cliente"}) 

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5]  of oMainWnd PIXEL

	oDlg:lMaximized := .T.

	@ 100,500 MSPANEL oPanel PROMPT "" SIZE 100,500 OF oDlg CENTERED RAISED    
	/*
	oBtnCli  :=tButton():New(003,003,"Cliente"       ,oPanel,{|| RkPCliente()},040,009,,,,.T.) 
	oBtnProd :=tButton():New(003,058,"Grupo Produto" ,oPanel,{|| RkPGruProd()},040,009,,,,.T.)
	oBtnGruV :=tButton():New(003,111,"Grupo Venda"   ,oPanel,{|| RkPVenda('Gru')},040,009,,,,.T.)
	oBtnSegV :=tButton():New(003,164,"Seg.Venda"     ,oPanel,{|| RkPVenda('Seg')},040,009,,,,.T.)
	oBtnVend :=tButton():New(003,217,"Vendedor"      ,oPanel,{|| RkPVendedor('V')},040,009,,,,.T.)
	oBtnVendI:=tButton():New(003,270,"Vendedor Int." ,oPanel,{|| RkPVendedor('I')},040,009,,,,.T.)
	oBtnUF   :=tButton():New(003,323,"Estado(UF)"    ,oPanel,{|| RkPDiversos("U")},040,009,,,,.T.)  
	oBtnCond :=tButton():New(003,376,"Cond. Pagto."  ,oPanel,{|| RkPDiversos("C")},040,009,,,,.T.)
	oBtnFret :=tButton():New(003,429,"Tipo Frete"    ,oPanel,{|| RkPDiversos("F")},040,009,,,,.T.)
	oBtnGruS :=tButton():New(003,484,"Grupo Sup."    ,oPanel,{|| RkPVenda('Sup')},040,009,,,,.T.)  */

	oBtnCli  :=tButton():New(003,003,"Cliente"       ,oPanel,{|| RkPCliente()},040,009,,,,.T.) 
	oBtnProd :=tButton():New(003,045,"Grupo Produto" ,oPanel,{|| RkPGruProd()},040,009,,,,.T.)
	oBtnGruV :=tButton():New(003,088,"Grupo Venda"   ,oPanel,{|| RkPVenda('Gru')},040,009,,,,.T.)
	oBtnSegV :=tButton():New(003,131,"Seg.Venda"     ,oPanel,{|| RkPVenda('Seg')},040,009,,,,.T.)
	oBtnVend :=tButton():New(003,174,"Vendedor"      ,oPanel,{|| RkPVendedor('V')},040,009,,,,.T.)
	oBtnVendI:=tButton():New(003,217,"Vendedor Int." ,oPanel,{|| RkPVendedor('I')},040,009,,,,.T.)
	oBtnUF   :=tButton():New(003,260,"Estado(UF)"    ,oPanel,{|| RkPDiversos("U")},040,009,,,,.T.)  
	oBtnCond :=tButton():New(003,306,"Cond. Pagto."  ,oPanel,{|| RkPDiversos("C")},040,009,,,,.T.)
	oBtnFret :=tButton():New(003,352,"Tipo Frete"    ,oPanel,{|| RkPDiversos("F")},040,009,,,,.T.)
	oBtnGruS :=tButton():New(003,397,"Grupo Sup."    ,oPanel,{|| RkPVenda('Sup')},040,009,,,,.T.)

	montaHeader("Cliente")

	oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

	@ 100,500 MSPANEL oPanelR PROMPT "" SIZE 100,500 OF oDlg RAISED  

	@ 005, 026 Say "Total Pendente: " Pixel of oPanelR FONT oFntR
	@ 003, 073 MSGET nQtdPen PICTURE "@E 999,999"  SIZE 25,10 WHEN .F. PIXEL OF oPanelR	  	
	@ 003, 105 MSGET nTotPen PICTURE "@E 999,999,999,999.99"  SIZE 90,10 WHEN .F. PIXEL OF oPanelR	  

	@ 005, 240 Say "Total Liquidado: " Pixel of oPanelR FONT oFntR
	@ 003, 287 MSGET nQtdLiq PICTURE "@E 999,999"  SIZE 25,10 WHEN .F. PIXEL OF oPanelR	  	
	@ 003, 319 MSGET nTotLiq PICTURE "@E 999,999,999,999.99"  SIZE 90,10 WHEN .F. PIXEL OF oPanelR	  

	AlignObject( oDlg, {oPanel,oGet:oBrowse,oPanelR}, 1, 2, {040,100,040} )   

	ACTIVATE MSDIALOG oDlg CENTER ON INIT (EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},,aButtons), fInicio(.t.)  )


	If Select("XCON") > 0
		XCON->(DbCloseArea("XCON"))
	Endif 

	If Select("XTOT") > 0
		XTOT->(DbCloseArea("XTOT"))
	Endif

	RestArea(aArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVCliente  บAutor  ณ Giane              บ Data ณ 08/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza dados cadastrais do cliente que estiver posicionaบฑฑ
ฑฑบ          ณ do (cursor). Somente para Ranking por cliente              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                           
Static Function VCliente()  

	Local aAreaAnt := GetArea()                                                                
	Local nPosCli
	Local nPosLoja
	Local nLinha	
	Local cCliente  
	Local cLoja   

	Private cCadastro := "Visualiza Cadastro do Cliente"   
	Private aMemos    := {{"A1_CODMARC","A1_VM_MARC"},{"A1_OBS","A1_VM_OBS"}}
	Private bFiltraBrw:= {|| Nil}
	Private aRotAuto := Nil
	Private aCpoAltSA1 := {} 

	Private aRotina	:= {}
	Private lIntLox	:= GetMv("MV_QALOGIX") == "1"     

	if !(oBtnCli:lActive)                          
		aPermissoes := {.T.,.T.,.T.,.T.}

		aRotina := { 	{"Pesquisar","PesqBrw"    , 0 , 1,0 ,.F.}}		// "Pesquisar"

		If aPermissoes[4]
			aAdd(aRotina,{"Visualizar","A030Visual" , 0 , 2,0 ,NIL})	// "Visualizar"
		EndIf

		aAdd(aRotina,{"Contatos","FtContato"	 , 0 , 4,0 ,NIL})		// "Contatos"

		nPosCli	 := GDFieldPos( "CLIENTE", oGet:aHeader )
		nPosLoja := GDFieldPos( "LOJA", oGet:aHeader )

		nLinha	  := oGet:oBrowse:nAt
		cCliente  := oGet:ACOLS[nLinha,nPosCli] 
		cLoja     := oGet:ACOLS[nLinha,nPosLoja] 

		DbSelectArea("SA1")
		DbSetOrder(1)

		if DbSeek(xFilial("SA1") + cCliente + cLoja )
			A030Visual("SA1",SA1->(Recno()),2) 
		Endif

	Endif

	RestArea(aAreaAnt)
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfInicio   บAutor  ณ Giane              บ Data ณ 06/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recalcula total geral de acordo com parametros digitados   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fInicio(lTipo)  
	Local lTot := .t.

	if lTipo == NIl
		lTipo := .f.
	Endif

	if lTipo 
		if !Pergunte(cPerg,.t.)
			lTot := .f.
		Endif
	Endif

	cMVPAR01 := MV_PAR01
	cMVPAR02 := MV_PAR02
	cMVPAR03 := MV_PAR03
	cMVPAR04 := MV_PAR04
	cMVPAR05 := MV_PAR05
	cMVPAR06 := MV_PAR06
	cMVPAR07 := MV_PAR07
	cMVPAR08 := MV_PAR08
	cMVPAR09 := MV_PAR09 
	cMVPAR10 := MV_PAR10
	cMVPAR11 := MV_PAR11
	cMVPAR12 := MV_PAR12
	cMVPAR13 := MV_PAR13
	cMVPAR14 := MV_PAR14
	cMVPAR15 := MV_PAR15
	cMVPAR16 := MV_PAR16
	cMVPAR17 := MV_PAR17
	cMVPAR18 := MV_PAR18
	cMVPAR19 := MV_PAR19
	cMVPAR20 := MV_PAR20
	cMVPAR21 := MV_PAR21

	if !lTipo
		aCols := {}

		oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

		AlignObject( oDlg, {oGet:oBrowse}, 1, 2, {040,100} )  

		oBtnCli:Enable()
		oBtnProd:Enable()
		oBtnGruV:Enable()
		oBtnSegV:Enable()
		oBtnVend:Enable()
		oBtnVendI:Enable()
		oBtnUF:Enable()
		oBtnCond:Enable()
		oBtnFret:Enable()
		oBtnGruS:Enable()

	Endif

	if lTot
		fSqlTot()     
	Endif   

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRkPClienteบAutor  ณ Giane              บ Data ณ 28/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta consulta de ranking por cliente                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RkPCliente() 
	Local cQuery := ""    
	Local cAlias := "XCON" 

	oBtnCli:Disable()

	oBtnProd:Enable()
	oBtnGruV:Enable()
	oBtnSegV:Enable()
	oBtnVend:Enable()
	oBtnVendI:Enable()
	oBtnUF:Enable()
	oBtnCond:Enable()
	oBtnFret:Enable()
	oBtnGruS:Enable()

	If nTotGer == 0
		fSqlTot()  //funcao que vai calcular o total geral em reais da consulta
	EndIf  

	cQuery := "SELECT " + CHR(13) + CHR(10)
	cQuery += "  XTMP.CLIENTE, XTMP.LOJA, XSA1.A1_NREDUZ, XTMP.TOTCLI, XTMP.NPERCENT, XTMP.QTDPED, XTMP.C5_VEND1, SA3.A3_NREDUZ, " + CHR(13) + CHR(10) 
	cQuery += "  XSA1.A1_VENDINT, XSA3.A3_NREDUZ AS NOMVENDI, XTMP.C5_GRPVEN, ACY.ACY_DESCRI " + CHR(13) + CHR(10)
	If cMVPAR19 <> 2
		cQuery += ", SX5.X5_DESCRI AS DESCRI " + CHR(13) + CHR(10)
	Endif   
	cQuery += "FROM " + CHR(13) + CHR(10)
	cQuery += " ( " + CHR(13) + CHR(10)
	If cMVPAR18 == 3 //fazer um union all, pois deve somar os faturados com os pendentes:  
		cQuery += "  SELECT " + CHR(13) + CHR(10)
		cQuery += "    XUNI.CLIENTE, XUNI.LOJA, XUNI.C5_GRPVEN, XUNI.C5_VEND1, SUM(XUNI.QTDPED) QTDPED, SUM(XUNI.TOTCLI) TOTCLI, " + CHR(13) + CHR(10)
		cQuery += "   ( SUM(XUNI.TOTCLI) * 100 ) / " + ALLTRIM(STR(nTotGer,16,2) )+ " AS NPERCENT " + CHR(13) + CHR(10)
		cQuery += "  FROM " + CHR(13) + CHR(10)
		cQuery += "   ( " + CHR(13) + CHR(10)
	Endif
	If cMVPAR18 <> 1 //pedidos nao faturados ainda  
		cQuery += "     SELECT DISTINCT "  + CHR(13) + CHR(10)
		cQuery += "       SC6.C6_CLI CLIENTE, SC6.C6_LOJA LOJA, SC5.C5_GRPVEN, SC5.C5_VEND1, " + CHR(13) + CHR(10)
		cQuery += "       COUNT(DISTINCT C6_NUM) QTDPED, " + CHR(13) + CHR(10)
		cQuery += "       SUM(SC6.C6_VALOR) AS TOTCLI " + CHR(13) + CHR(10)
		If cMVPAR18 == 2   
			cQuery += "       ,( SUM(SC6.C6_VALOR) * 100 ) / " + ALLTRIM(STR(nTotPen,16,2) )+ " AS NPERCENT "  + CHR(13) + CHR(10)
		Endif
		cQuery += "     FROM " 
		cQuery += "       " + RetSqlName("SC6") + " SC6 JOIN " + RetSqlName("SA1") + " SA1 ON " + CHR(13) + CHR(10)
		cQuery += "         SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  + CHR(13) + CHR(10)
		cQuery += "         SA1.A1_COD = SC6.C6_CLI AND " + CHR(13) + CHR(10)
		cQuery += "         SA1.A1_LOJA = SC6.C6_LOJA AND "+ CHR(13) + CHR(10)
		cQuery += "         SA1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10) 
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "		  JOIN " + RetSqlName("ACY") + " ACY ON "+ CHR(13) + CHR(10)
			cQuery += "		    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "+ CHR(13) + CHR(10)
			cQuery += "		    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "+ CHR(13) + CHR(10)
			cQuery += "		    ACY.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		ENDIF
		cQuery += "       JOIN "+RetSQLName("SB1")+" SB1 ON " + CHR(13) + CHR(10)
		cQuery += "         SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND " + CHR(13) + CHR(10)
		cQuery += "         SB1.B1_COD = SC6.C6_PRODUTO AND " + CHR(13) + CHR(10)
		cQuery += "         SB1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
		cQuery += "       JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
		cQuery += "         SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
		cQuery += "         SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
		cQuery += "         SC5.C5_NUM = SC6.C6_NUM " + CHR(13) + CHR(10)   
		cQuery += "       JOIN " + RetSqlName("SF4") + " SF4 ON "  
		cQuery += "         SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
		cQuery += "         SC6.C6_TES = SF4.F4_CODIGO AND "  
		cQuery += "         SF4.D_E_L_E_T_ = ' ' " 	 		
		cQuery += "     WHERE "+ CHR(13) + CHR(10)
		cQuery += "       SC6.C6_NOTA = '" + Space(Len(SC6->C6_NOTA)) + "' "+ CHR(13) + CHR(10)
		cQuery += "       AND SC6.C6_SERIE = '  '  AND " + CHR(13) + CHR(10)
		cQuery += "       SC5.C5_X_CANC = ' '  AND " + CHR(13) + CHR(10)
		cQuery += "       SC6.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
		cQuery += "       SC6.C6_ENTREG BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND " + CHR(13) + CHR(10)
		cQuery += "       SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "  + CHR(13) + CHR(10)
		cQuery += "       SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND " + CHR(13) + CHR(10)
		cQuery += "       SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " + CHR(13) + CHR(10)
		cQuery += "       SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  + CHR(13) + CHR(10)
		cQuery += "       SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "  + CHR(13) + CHR(10)
		cQuery += "       SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  + CHR(13) + CHR(10)
		cQuery += "       SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' "  + CHR(13) + CHR(10)
		cQuery += "       AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "+ CHR(13) + CHR(10)
		cQuery += "       AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  + CHR(13) + CHR(10)
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF	   
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "   AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif		
		cQuery += "     GROUP BY C6_CLI, C6_LOJA, C5_GRPVEN, C5_VEND1 "  + CHR(13) + CHR(10)    
	Endif
	If cMVPAR18  == 3
		cQuery += "     UNION ALL " + CHR(13) + CHR(10)
	Endif

	If cMVPAR18 <> 2 //pedidos ja faturados  
		cQuery += "     SELECT " + CHR(13) + CHR(10)
		cQuery += "       XFAT.CLIENTE, XFAT.LOJA, XFAT.C5_GRPVEN, XFAT.C5_VEND1, SUM(XFAT.QTDPED) QTDPED, SUM(XFAT.TOTCLI) TOTCLI " + CHR(13) + CHR(10)
		If cMVPAR18 == 1 
			cQuery += "       ,( SUM(XFAT.TOTCLI) * 100 ) / " + ALLTRIM(STR(nTotLiq,16,2) )+ " AS NPERCENT " + CHR(13) + CHR(10)
		Endif
		cQuery += "     FROM " + CHR(13) + CHR(10)
		cQuery += "      ( " + CHR(13) + CHR(10)

		cQuery += "       SELECT "  + CHR(13) + CHR(10)
		cQuery += "         SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, SC5.C5_GRPVEN, SC5.C5_VEND1, COUNT(DISTINCT D2_PEDIDO) QTDPED, "  + CHR(13) + CHR(10)
		cQuery += "         SUM(SD2.D2_VALBRUT) AS TOTCLI "  + CHR(13) + CHR(10)
		cQuery += "       FROM " 
		cQuery += "         " + RetSqlName("SD2") + " SD2 JOIN " + RetSqlName("SF2") + " SF2 ON "
		cQuery += "           SF2.F2_FILIAL  = SD2.D2_FILIAL AND "
		cQuery += "           SD2.D2_DOC     = SF2.F2_DOC AND "
		cQuery += "           SD2.D2_SERIE   = SF2.F2_SERIE AND "
		cQuery += "           SF2.D_E_L_E_T_ = ' ' "	
		cQuery += "         JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += "           SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
		cQuery += "           SA1.A1_COD = SD2.D2_CLIENTE AND "
		cQuery += "           SA1.A1_LOJA = SD2.D2_LOJA AND "
		cQuery += "           SA1.D_E_L_E_T_ = ' ' "
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += " 		JOIN " + RetSqlName("ACY") + " ACY ON "
			cQuery += "			  ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
			cQuery += "		      ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
			cQuery += "		      ACY.D_E_L_E_T_ = ' ' "
		ENDIF
		cQuery += "         JOIN "+RetSQLName("SB1") + " SB1 ON "       
		cQuery += "           SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "    
		cQuery += "           SB1.B1_COD = SD2.D2_COD AND "      	
		cQuery += "           SB1.D_E_L_E_T_ = ' ' "  	
		cQuery += "         JOIN " + RetSqlName("SF4") + " SF4 ON "  
		cQuery += "           SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
		cQuery += "           SD2.D2_TES = SF4.F4_CODIGO AND "  
		cQuery += "           SF4.D_E_L_E_T_ = ' ' " 	 
		cQuery += "         JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
		cQuery += "           SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
		cQuery += "           SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)	
		cQuery += "       WHERE "
		cQuery += "         SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND "
		cQuery += "         SD2.D_E_L_E_T_ = ' ' AND "   
		cQuery += "         SD2.D2_EMISSAO BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
		cQuery += "         SD2.D2_CLIENTE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
		cQuery += "         SD2.D2_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
		cQuery += "         SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	
		cQuery += "         SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "   	
		cQuery += "         SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
		cQuery += "         SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " 
		cQuery += "         SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "
		cQuery += "         AND SD2.D2_TIPO IN ('N','C','I','P') "
		cQuery += "         AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "     AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif  
		If !Empty(cMVPAR15)  
			cQuery += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += " AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif
		cQuery += "       GROUP BY D2_CLIENTE, D2_LOJA, C5_GRPVEN, C5_VEND1 " + CHR(13) + CHR(10)

		cQuery += "       UNION ALL " + CHR(13) + CHR(10)  

		//verifica as DEVOLUCOES e substrai os valores encontrados do select acima de notas faturadas.
		cQuery += "       SELECT "  + CHR(13) + CHR(10)
		cQuery += "         SD1.D1_FORNECE CLIENTE, SD1.D1_LOJA LOJA, SC5.C5_GRPVEN, SC5.C5_VEND1, 0 QTDPED, "  + CHR(13) + CHR(10)
		cQuery += "         SUM((SD1.D1_TOTAL + SD1.D1_VALIPI)* -1) AS TOTCLI "  + CHR(13) + CHR(10)
		cQuery += "       FROM " 
		cQuery += "         " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SD2") + " SD2 ON "
		cQuery += "           SD2.D2_FILIAL = SD1.D1_FILIAL AND "
		cQuery += "           SD1.D1_NFORI = SD2.D2_DOC AND "
		cQuery += "           SD1.D1_SERIORI = SD2.D2_SERIE AND "  
		cQuery += "           SD1.D1_ITEMORI = SD2.D2_ITEM AND "	 
		cQuery += "           SD2.D_E_L_E_T_ = ' ' "        
		cQuery += "         JOIN " + RetSqlName("SF2") + " SF2 ON "
		cQuery += "           SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND "
		cQuery += "           SD1.D1_NFORI = SF2.F2_DOC AND "
		cQuery += "           SD1.D1_SERIORI = SF2.F2_SERIE AND "   
		cQuery += "           SF2.D_E_L_E_T_ = ' ' "	
		cQuery += "   	    JOIN " + RetSqlName("SB1") + " SB1 ON "
		cQuery += "   	      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
		cQuery += "    	      SD1.D1_COD = SB1.B1_COD AND "
		cQuery += "    	      SB1.D_E_L_E_T_ = ' ' "
		cQuery += "         JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += "    	      SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
		cQuery += "           SD1.D1_FORNECE = SA1.A1_COD AND "
		cQuery += "           SD1.D1_LOJA = SA1.A1_LOJA AND "
		cQuery += "           SA1.D_E_L_E_T_ = ' ' "
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "		    JOIN " + RetSqlName("ACY") + " ACY ON "
			cQuery += "		      ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
			cQuery += "		      ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
			cQuery += "		      ACY.D_E_L_E_T_ = ' ' " 
		ENDIF
		cQuery += "         JOIN " + RetSqlName("SF4") + " SF4 ON "             
		cQuery += "           SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND " 
		cQuery += "           SF4.D_E_L_E_T_ = ' ' AND "
		cQuery += "           SD1.D1_TES = SF4.F4_CODIGO "  	 
		cQuery += "         JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
		cQuery += "           SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
		cQuery += "           SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)		
		cQuery += "       WHERE "
		cQuery += "         SD1.D1_DTDIGIT BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
		cQuery += "         SD1.D1_FORNECE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
		cQuery += "         SD1.D1_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
		cQuery += "         SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
		cQuery += "         SD1.D_E_L_E_T_ = ' ' AND "   
		cQuery += "         SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	  
		cQuery += "         SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "   	
		cQuery += "         SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
		cQuery += "         SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " 
		cQuery += "         SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' AND "
		cQuery += "         SD1.D1_TIPO = 'D'  "   
		cQuery += "         AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "     AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += " AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif	

		cQuery += "       GROUP BY D1_FORNECE, D1_LOJA, C5_GRPVEN, C5_VEND1 " + CHR(13) + CHR(10)
		cQuery += "      ) XFAT " + CHR(13) + CHR(10)
		cQuery += "     GROUP BY CLIENTE, LOJA, C5_GRPVEN, C5_VEND1  "  + CHR(13) + CHR(10)
	Endif
	If cMVPAR18 == 3     
		cQuery += "   ) XUNI " + CHR(13) + CHR(10)
		cQuery += "GROUP BY CLIENTE, LOJA, C5_GRPVEN, C5_VEND1 " + CHR(13) + CHR(10)
	Endif
	cQuery += " ) XTMP "  + CHR(13) + CHR(10)
	cQuery += "  JOIN " + RetSqlName("SA1")+ " XSA1 ON "+ CHR(13) + CHR(10)
	cQuery += "    XTMP.CLIENTE    = XSA1.A1_COD AND " + CHR(13) + CHR(10)
	cQuery += "    XTMP.LOJA       = XSA1.A1_LOJA AND " + CHR(13) + CHR(10)
	cQuery += "    XSA1.A1_FILIAL  = '" + xFilial("SA1") + "' AND " + CHR(13) + CHR(10)
	cQuery += "    XSA1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	cQuery += "  LEFT JOIN " + RetSqlName("SA3")+ " SA3 ON " + CHR(13) + CHR(10)
	cQuery += "    SA3.A3_FILIAL   = '" + xFilial("SA3") + "' AND " + CHR(13) + CHR(10)
	cQuery += "    SA3.D_E_L_E_T_  = ' ' AND " + CHR(13) + CHR(10)
	cQuery += "    SA3.A3_COD      = XTMP.C5_VEND1 " + CHR(13) + CHR(10)        
	cQuery += "  LEFT JOIN " + RetSqlName("SA3")+ " XSA3 ON " + CHR(13) + CHR(10)
	cQuery += "    XSA3.A3_FILIAL  = '" + xFilial("SA3") + "' AND " + CHR(13) + CHR(10)
	cQuery += "    XSA3.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
	cQuery += "    XSA3.A3_COD     = XSA1.A1_VENDINT "  + CHR(13) + CHR(10)
	cQuery += "  LEFT JOIN " + RetSqlName("ACY") + " ACY ON " + CHR(13) + CHR(10)
	cQuery += "    ACY.ACY_FILIAL = '" + xFilial("ACY") + "' AND " + CHR(13) + CHR(10)
	cQuery += "    ACY.ACY_GRPVEN = XTMP.C5_GRPVEN AND " + CHR(13) + CHR(10)
	cQuery += "    ACY.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
	cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " SX5 ON " + CHR(13) + CHR(10)
	cQuery += "    SX5.X5_FILIAL  = '" + xFilial("SX5") + "' AND " + CHR(13) + CHR(10)
	cQuery += "    SX5.X5_TABELA  = 'T3' AND " + CHR(13) + CHR(10)
	cQuery += "    SX5.X5_CHAVE   = XSA1.A1_SATIV1 AND " + CHR(13) + CHR(10)
	cQuery += "    SX5.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
	cQuery += "ORDER BY TOTCLI DESC " + CHR(13) + CHR(10)

	MEMOWRITE('C:\CFAT050.SQL',CQUERY)       

	If Select("XCON") > 0
		XCON->(DbCloseArea("XCON"))
	Endif                  

	TcQuery cQuery NEW ALIAS (cAlias) 

	TcSetField(cAlias,'QTDPED','N',4,0)
	TcSetField(cAlias,'TOTCLI','N',16,2)
	TcSetField(cAlias,'NPERCENT','N',7,2)	

	montaHeader("Cliente")

	If cMVPAR19 <> 2
		MsgRun("Processando Ranking por Cliente, aguarde...","Ranking Faturamento",{||	XCON->(DbEval({|| AADD(aCols,{ XCON->CLIENTE, XCON->LOJA, XCON->A1_NREDUZ, XCON->TOTCLI, XCON->NPERCENT, XCON->QTDPED,XCON->C5_VEND1, XCON->A3_NREDUZ, XCON->A1_VENDINT, XCON->NOMVENDI, XCON->ACY_DESCRI,XCON->DESCRI, .F.})  },,,,,.T.)) })  
	Else 
		MsgRun("Processando Ranking por Cliente, aguarde...","Ranking Faturamento",{||	XCON->(DbEval({|| AADD(aCols,{ XCON->CLIENTE, XCON->LOJA, XCON->A1_NREDUZ, XCON->TOTCLI, XCON->NPERCENT, XCON->QTDPED,XCON->C5_VEND1, XCON->A3_NREDUZ, XCON->A1_VENDINT, XCON->NOMVENDI, XCON->ACY_DESCRI, .F.})  },,,,,.T.)) })    
	Endif

	oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

	AlignObject( oDlg, {oGet:oBrowse}, 1, 2, {040,100} )  

	oGet:oBrowse:bLDblClick := {|| ItensCliente() }

	XCON->(DbCloseArea("XCON"))

Return 

/*Static Function RkPCliente() 
Local cQuery := ""    
Local cAlias := "XCON" 

oBtnCli:Disable()

oBtnProd:Enable()
oBtnGruV:Enable()
oBtnSegV:Enable()
oBtnVend:Enable()
oBtnVendI:Enable()
oBtnUF:Enable()
oBtnCond:Enable()
oBtnFret:Enable()

If nTotGer == 0
fSqlTot()  //funcao que vai calcular o total geral em reais da consulta
EndIf  

cQuery := "SELECT " + CHR(13) + CHR(10)
cQuery += "  XTMP.CLIENTE, XTMP.LOJA, XSA1.A1_NREDUZ, XTMP.TOTCLI, XTMP.NPERCENT, XTMP.QTDPED, XSA1.A1_VEND, SA3.A3_NREDUZ, " + CHR(13) + CHR(10) 
cQuery += "  XSA1.A1_VENDINT, XSA3.A3_NREDUZ AS NOMVENDI, XTMP.C5_GRPVEN, ACY.ACY_DESCRI " + CHR(13) + CHR(10)
If cMVPAR19 <> 2
cQuery += ", SX5.X5_DESCRI " + CHR(13) + CHR(10)
Endif   
cQuery += "FROM " + CHR(13) + CHR(10)
cQuery += " ( " + CHR(13) + CHR(10)
If cMVPAR18 == 3 //fazer um union all, pois deve somar os faturados com os pendentes:  
cQuery += "  SELECT " + CHR(13) + CHR(10)
cQuery += "    XUNI.CLIENTE, XUNI.LOJA, XUNI.C5_GRPVEN, SUM(XUNI.QTDPED) QTDPED, SUM(XUNI.TOTCLI) TOTCLI, " + CHR(13) + CHR(10)
cQuery += "   ( SUM(XUNI.TOTCLI) * 100 ) / " + ALLTRIM(STR(nTotGer,16,2) )+ " AS NPERCENT " + CHR(13) + CHR(10)
cQuery += "  FROM " + CHR(13) + CHR(10)
cQuery += "   ( " + CHR(13) + CHR(10)
Endif
If cMVPAR18 <> 1 //pedidos nao faturados ainda  
cQuery += "     SELECT DISTINCT "  + CHR(13) + CHR(10)
cQuery += "       SC6.C6_CLI CLIENTE, SC6.C6_LOJA LOJA, SC5.C5_GRPVEN, " + CHR(13) + CHR(10)
cQuery += "       COUNT(DISTINCT C6_NUM) QTDPED, " + CHR(13) + CHR(10)
cQuery += "       SUM(SC6.C6_VALOR) AS TOTCLI " + CHR(13) + CHR(10)
If cMVPAR18 == 2   
cQuery += "       ,( SUM(SC6.C6_VALOR) * 100 ) / " + ALLTRIM(STR(nTotPen,16,2) )+ " AS NPERCENT "  + CHR(13) + CHR(10)
Endif
cQuery += "     FROM " 
cQuery += "       " + RetSqlName("SC6") + " SC6 JOIN " + RetSqlName("SA1") + " SA1 ON " + CHR(13) + CHR(10)
cQuery += "         SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  + CHR(13) + CHR(10)
cQuery += "         SA1.A1_COD = SC6.C6_CLI AND " + CHR(13) + CHR(10)
cQuery += "         SA1.A1_LOJA = SC6.C6_LOJA AND "+ CHR(13) + CHR(10)
cQuery += "         SA1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
cQuery += "       JOIN "+RetSQLName("SB1")+" SB1 ON " + CHR(13) + CHR(10)
cQuery += "         SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND " + CHR(13) + CHR(10)
cQuery += "         SB1.B1_COD = SC6.C6_PRODUTO AND " + CHR(13) + CHR(10)
cQuery += "         SB1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
cQuery += "       JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
cQuery += "         SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
cQuery += "         SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
cQuery += "         SC5.C5_NUM = SC6.C6_NUM " + CHR(13) + CHR(10)   
cQuery += "       JOIN " + RetSqlName("SF4") + " SF4 ON "  
cQuery += "         SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
cQuery += "         SC6.C6_TES = SF4.F4_CODIGO AND "  
cQuery += "         SF4.D_E_L_E_T_ = ' ' " 	 		
cQuery += "     WHERE "+ CHR(13) + CHR(10)
cQuery += "       SC6.C6_NOTA = '" + Space(Len(SC6->C6_NOTA)) + "' "+ CHR(13) + CHR(10)
cQuery += "       AND SC6.C6_SERIE = '  '  AND " + CHR(13) + CHR(10)
cQuery += "       SC5.C5_X_CANC = ' '  AND " + CHR(13) + CHR(10)
cQuery += "       SC6.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
cQuery += "       SC6.C6_ENTREG BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND " + CHR(13) + CHR(10)
cQuery += "       SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "  + CHR(13) + CHR(10)
cQuery += "       SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND " + CHR(13) + CHR(10)
cQuery += "       SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " + CHR(13) + CHR(10)
cQuery += "       SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  + CHR(13) + CHR(10)
cQuery += "       SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "  + CHR(13) + CHR(10)
cQuery += "       SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  + CHR(13) + CHR(10)
cQuery += "       SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' "  + CHR(13) + CHR(10)
cQuery += "       AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "
cQuery += "       AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  + CHR(13) + CHR(10)
If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
cQuery += "     AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
Endif

If !Empty(cMVPAR15)  
cQuery += "  AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
If lGerente
cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
Endif
Endif		
cQuery += "     GROUP BY C6_CLI, C6_LOJA, C5_GRPVEN "  + CHR(13) + CHR(10)    
Endif
If cMVPAR18  == 3
cQuery += "     UNION ALL " + CHR(13) + CHR(10)
Endif

If cMVPAR18 <> 2 //pedidos ja faturados  
cQuery += "     SELECT " + CHR(13) + CHR(10)
cQuery += "       XFAT.CLIENTE, XFAT.LOJA, XFAT.C5_GRPVEN, SUM(XFAT.QTDPED) QTDPED, SUM(XFAT.TOTCLI) TOTCLI " + CHR(13) + CHR(10)
If cMVPAR18 == 1 
cQuery += "       ,( SUM(XFAT.TOTCLI) * 100 ) / " + ALLTRIM(STR(nTotLiq,16,2) )+ " AS NPERCENT " + CHR(13) + CHR(10)
Endif
cQuery += "     FROM " + CHR(13) + CHR(10)
cQuery += "      ( " + CHR(13) + CHR(10)

cQuery += "       SELECT "  + CHR(13) + CHR(10)
cQuery += "         SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, SC5.C5_GRPVEN, COUNT(DISTINCT D2_PEDIDO) QTDPED, "  + CHR(13) + CHR(10)
cQuery += "         SUM(SD2.D2_VALBRUT) AS TOTCLI "  + CHR(13) + CHR(10)
cQuery += "       FROM " 
cQuery += "         " + RetSqlName("SD2") + " SD2 JOIN " + RetSqlName("SF2") + " SF2 ON "
cQuery += "           SF2.F2_FILIAL  = SD2.D2_FILIAL AND "
cQuery += "           SD2.D2_DOC     = SF2.F2_DOC AND "
cQuery += "           SD2.D2_SERIE   = SF2.F2_SERIE AND "
cQuery += "           SF2.D_E_L_E_T_ = ' ' "	
cQuery += "         JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "           SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
cQuery += "           SA1.A1_COD = SD2.D2_CLIENTE AND "
cQuery += "           SA1.A1_LOJA = SD2.D2_LOJA AND "
cQuery += "           SA1.D_E_L_E_T_ = ' ' "    
cQuery += "         JOIN "+RetSQLName("SB1") + " SB1 ON "       
cQuery += "           SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "    
cQuery += "           SB1.B1_COD = SD2.D2_COD AND "      	
cQuery += "           SB1.D_E_L_E_T_ = ' ' "  	
cQuery += "         JOIN " + RetSqlName("SF4") + " SF4 ON "  
cQuery += "           SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
cQuery += "           SD2.D2_TES = SF4.F4_CODIGO AND "  
cQuery += "           SF4.D_E_L_E_T_ = ' ' " 	 
cQuery += "         JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
cQuery += "           SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
cQuery += "           SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
cQuery += "           SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)	
cQuery += "       WHERE "
cQuery += "         SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND "
cQuery += "         SD2.D_E_L_E_T_ = ' ' AND "   
cQuery += "         SD2.D2_EMISSAO BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
cQuery += "         SD2.D2_CLIENTE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
cQuery += "         SD2.D2_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
cQuery += "         SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	
cQuery += "         SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "   	
cQuery += "         SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
cQuery += "         SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " 
cQuery += "         SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "
cQuery += "         AND SD2.D2_TIPO IN ('N','C','I','P') "
cQuery += "         AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  + CHR(13) + CHR(10)
If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
cQuery += "       AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
Endif  
If !Empty(cMVPAR15)  
cQuery += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
If lGerente
cQuery += "     AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
Endif
Endif
cQuery += "       GROUP BY D2_CLIENTE, D2_LOJA, C5_GRPVEN " + CHR(13) + CHR(10)

cQuery += "       UNION ALL " + CHR(13) + CHR(10)  

//verifica as DEVOLUCOES e substrai os valores encontrados do select acima de notas faturadas.
cQuery += "       SELECT "  + CHR(13) + CHR(10)
cQuery += "         SD1.D1_FORNECE CLIENTE, SD1.D1_LOJA LOJA, SC5.C5_GRPVEN, 0 QTDPED, "  + CHR(13) + CHR(10)
cQuery += "         SUM((SD1.D1_TOTAL + SD1.D1_VALIPI)* -1) AS TOTCLI "  + CHR(13) + CHR(10)
cQuery += "       FROM " 
cQuery += "         " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SD2") + " SD2 ON "
cQuery += "           SD2.D2_FILIAL = SD1.D1_FILIAL AND "
cQuery += "           SD1.D1_NFORI = SD2.D2_DOC AND "
cQuery += "           SD1.D1_SERIORI = SD2.D2_SERIE AND "  
cQuery += "           SD1.D1_ITEMORI = SD2.D2_ITEM AND "	 
cQuery += "           SD2.D_E_L_E_T_ = ' ' "        
cQuery += "         JOIN " + RetSqlName("SF2") + " SF2 ON "
cQuery += "           SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND "
cQuery += "           SD1.D1_NFORI = SF2.F2_DOC AND "
cQuery += "           SD1.D1_SERIORI = SF2.F2_SERIE AND "   
cQuery += "           SF2.D_E_L_E_T_ = ' ' "	
cQuery += "   	    JOIN " + RetSqlName("SB1") + " SB1 ON "
cQuery += "   	      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
cQuery += "    	      SD1.D1_COD = SB1.B1_COD AND "
cQuery += "    	      SB1.D_E_L_E_T_ = ' ' "
cQuery += "         JOIN " + RetSqlName("SA1") + " SA1 ON "
cQuery += "    	      SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "           SD1.D1_FORNECE = SA1.A1_COD AND "
cQuery += "           SD1.D1_LOJA = SA1.A1_LOJA AND "
cQuery += "           SA1.D_E_L_E_T_ = ' ' "		 
cQuery += "         JOIN " + RetSqlName("SF4") + " SF4 ON "             
cQuery += "           SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND " 
cQuery += "           SF4.D_E_L_E_T_ = ' ' AND "
cQuery += "           SD1.D1_TES = SF4.F4_CODIGO "  	 
cQuery += "         JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
cQuery += "           SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
cQuery += "           SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
cQuery += "           SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)		
cQuery += "       WHERE "
cQuery += "         SD1.D1_DTDIGIT BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
cQuery += "         SD1.D1_FORNECE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
cQuery += "         SD1.D1_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
cQuery += "         SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
cQuery += "         SD1.D_E_L_E_T_ = ' ' AND "   
cQuery += "         SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	  
cQuery += "         SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "   	
cQuery += "         SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
cQuery += "         SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " 
cQuery += "         SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' AND "
cQuery += "         SD1.D1_TIPO = 'D'  "   
cQuery += "         AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  + CHR(13) + CHR(10)
If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
cQuery += "       AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
Endif

If !Empty(cMVPAR15)  
cQuery += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
If lGerente
cQuery += "     AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
Endif
Endif	

cQuery += "       GROUP BY D1_FORNECE, D1_LOJA, C5_GRPVEN " + CHR(13) + CHR(10)
cQuery += "      ) XFAT " + CHR(13) + CHR(10)
cQuery += "     GROUP BY CLIENTE, LOJA, C5_GRPVEN  "  + CHR(13) + CHR(10)
Endif
If cMVPAR18 == 3     
cQuery += "   ) XUNI " + CHR(13) + CHR(10)
cQuery += "GROUP BY CLIENTE, LOJA, C5_GRPVEN " + CHR(13) + CHR(10)
Endif
cQuery += " ) XTMP "  + CHR(13) + CHR(10)
cQuery += "  JOIN " + RetSqlName("SA1")+ " XSA1 ON "+ CHR(13) + CHR(10)
cQuery += "    XTMP.CLIENTE    = XSA1.A1_COD AND " + CHR(13) + CHR(10)
cQuery += "    XTMP.LOJA       = XSA1.A1_LOJA AND " + CHR(13) + CHR(10)
cQuery += "    XSA1.A1_FILIAL  = '" + xFilial("SA1") + "' AND " + CHR(13) + CHR(10)
cQuery += "    XSA1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
cQuery += "  LEFT JOIN " + RetSqlName("SA3")+ " SA3 ON " + CHR(13) + CHR(10)
cQuery += "    SA3.A3_FILIAL   = '" + xFilial("SA3") + "' AND " + CHR(13) + CHR(10)
cQuery += "    SA3.D_E_L_E_T_  = ' ' AND " + CHR(13) + CHR(10)
cQuery += "    SA3.A3_COD      = XSA1.A1_VEND " + CHR(13) + CHR(10)        
cQuery += "  LEFT JOIN " + RetSqlName("SA3")+ " XSA3 ON " + CHR(13) + CHR(10)
cQuery += "    XSA3.A3_FILIAL  = '" + xFilial("SA3") + "' AND " + CHR(13) + CHR(10)
cQuery += "    XSA3.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
cQuery += "    XSA3.A3_COD     = XSA1.A1_VENDINT "  + CHR(13) + CHR(10)
cQuery += "  LEFT JOIN " + RetSqlName("ACY") + " ACY ON " + CHR(13) + CHR(10)
cQuery += "    ACY.ACY_FILIAL = '" + xFilial("ACY") + "' AND " + CHR(13) + CHR(10)
cQuery += "    ACY.ACY_GRPVEN = XTMP.C5_GRPVEN AND " + CHR(13) + CHR(10)
cQuery += "    ACY.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " SX5 ON " + CHR(13) + CHR(10)
cQuery += "    SX5.X5_FILIAL  = '" + xFilial("SX5") + "' AND " + CHR(13) + CHR(10)
cQuery += "    SX5.X5_TABELA  = 'T3' AND " + CHR(13) + CHR(10)
cQuery += "    SX5.X5_CHAVE   = XSA1.A1_SATIV1 AND " + CHR(13) + CHR(10)
cQuery += "    SX5.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
cQuery += "ORDER BY TOTCLI DESC " + CHR(13) + CHR(10)

MEMOWRITE('C:\CFAT050.SQL',CQUERY)       

If Select("XCON") > 0
XCON->(DbCloseArea("XCON"))
Endif                  

TcQuery cQuery NEW ALIAS (cAlias) 

TcSetField(cAlias,'QTDPED','N',4,0)
TcSetField(cAlias,'TOTCLI','N',16,2)
TcSetField(cAlias,'NPERCENT','N',7,2)	

montaHeader("Cliente")

If cMVPAR19 <> 2
MsgRun("Processando Ranking por Cliente, aguarde...","Ranking Faturamento",{||	XCON->(DbEval({|| AADD(aCols,{ XCON->CLIENTE, XCON->LOJA, XCON->A1_NREDUZ, XCON->TOTCLI, XCON->NPERCENT, XCON->QTDPED,XCON->A1_VEND, XCON->A3_NREDUZ, XCON->A1_VENDINT, XCON->NOMVENDI, XCON->ACY_DESCRI,XCON->X5_DESCRI, .F.})  },,,,,.T.)) })  
Else 
MsgRun("Processando Ranking por Cliente, aguarde...","Ranking Faturamento",{||	XCON->(DbEval({|| AADD(aCols,{ XCON->CLIENTE, XCON->LOJA, XCON->A1_NREDUZ, XCON->TOTCLI, XCON->NPERCENT, XCON->QTDPED,XCON->A1_VEND, XCON->A3_NREDUZ, XCON->A1_VENDINT, XCON->NOMVENDI, XCON->ACY_DESCRI, .F.})  },,,,,.T.)) })    
Endif

oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

AlignObject( oDlg, {oGet:oBrowse}, 1, 2, {040,100} )  

oGet:oBrowse:bLDblClick := {|| ItensCliente() }

XCON->(DbCloseArea("XCON"))

Return 
*/
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlFat   บAutor  ณ Giane              บ Data ณ 10/11/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Sql pedidos ja faturados / parte que sera usada em varios  บฑฑ
ฑฑบ          ณ lugares                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fSqlFat(cTipo2)
	Local cSql := ""

	cSql += "       FROM " 
	cSql += "         " + RetSqlName("SD2") + " SD2 JOIN " + RetSqlName("SF2") + " SF2 ON "
	cSql += "           SF2.F2_FILIAL  = SD2.D2_FILIAL AND "
	cSql += "           SD2.D2_DOC     = SF2.F2_DOC AND "
	cSql += "           SD2.D2_SERIE   = SF2.F2_SERIE AND "
	cSql += "           SF2.D_E_L_E_T_ = ' ' "	
	cSql += "         JOIN " + RetSqlName("SA1") + " SA1 ON "
	cSql += "           SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
	cSql += "           SA1.A1_COD = SD2.D2_CLIENTE AND "
	cSql += "           SA1.A1_LOJA = SD2.D2_LOJA AND "
	cSql += "           SA1.D_E_L_E_T_ = ' ' "   
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ') .OR. cTipo2 == 'Sup'
		cSql += "		  JOIN " + RetSqlName("ACY") + " ACY ON "
		cSql += "		    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
		cSql += "		    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
		cSql += "		    ACY.D_E_L_E_T_ = ' ' " 
	ENDIF	
	cSql += "         JOIN "+RetSQLName("SB1") + " SB1 ON "       
	cSql += "           SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "    
	cSql += "           SB1.B1_COD = SD2.D2_COD AND "      	
	cSql += "           SB1.D_E_L_E_T_ = ' ' "  	
	cSql += "         JOIN " + RetSqlName("SF4") + " SF4 ON "  
	cSql += "           SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
	cSql += "           SD2.D2_TES = SF4.F4_CODIGO AND "  
	cSql += "           SF4.D_E_L_E_T_ = ' ' " 	 
	cSql += "         JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
	cSql += "           SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
	cSql += "           SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
	cSql += "           SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)	
	cSql += "       WHERE "
	cSql += "         SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND "
	cSql += "         SD2.D_E_L_E_T_ = ' ' AND "   
	cSql += "         SD2.D2_EMISSAO BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
	cSql += "         SD2.D2_CLIENTE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
	cSql += "         SD2.D2_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
	cSql += "         SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	
	cSql += "         SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "   	
	cSql += "         SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
	cSql += "         SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " 
	cSql += "         SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "
	cSql += "         AND SD2.D2_TIPO IN ('N','C','I','P') "
	cSql += "         AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
		cSql += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
	ENDIF
	If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
		cSql += "       AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	Endif

	If !Empty(cMVPAR15)  
		cSql += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
		If lGerente
			cSql += "     AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif
	Endif

Return cSql   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlDev   บAutor  ณ Giane              บ Data ณ 10/11/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Sql notas devolvidas     / parte que sera usada em varios  บฑฑ
ฑฑบ          ณ lugares                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fSqlDev(cTipo2)
	Local csql := ""

	csql += "       FROM " 
	csql += "         " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SD2") + " SD2 ON "
	csql += "           SD2.D2_FILIAL = SD1.D1_FILIAL AND "
	csql += "           SD1.D1_NFORI = SD2.D2_DOC AND "
	csql += "           SD1.D1_SERIORI = SD2.D2_SERIE AND "  
	csql += "           SD1.D1_ITEMORI = SD2.D2_ITEM AND "	 
	csql += "           SD2.D_E_L_E_T_ = ' ' "        
	csql += "         JOIN " + RetSqlName("SF2") + " SF2 ON "
	csql += "           SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND "
	csql += "           SD1.D1_NFORI = SF2.F2_DOC AND "
	csql += "           SD1.D1_SERIORI = SF2.F2_SERIE AND "   
	csql += "           SF2.D_E_L_E_T_ = ' ' "	
	csql += "   	    JOIN " + RetSqlName("SB1") + " SB1 ON "
	csql += "   	      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
	csql += "    	      SD1.D1_COD = SB1.B1_COD AND "
	csql += "    	      SB1.D_E_L_E_T_ = ' ' "
	csql += "         JOIN " + RetSqlName("SA1") + " SA1 ON "
	csql += "    	      SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
	csql += "           SD1.D1_FORNECE = SA1.A1_COD AND "
	csql += "           SD1.D1_LOJA = SA1.A1_LOJA AND "
	csql += "           SA1.D_E_L_E_T_ = ' ' "		 
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ') .OR. cTipo2 =='Sup'   
		csql += "		  JOIN " + RetSqlName("ACY") + " ACY ON "
		csql += "		    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
		csql += "		    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
		csql += "		    ACY.D_E_L_E_T_ = ' ' "
	ENDIF
	csql += "         JOIN " + RetSqlName("SF4") + " SF4 ON "             
	csql += "           SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND " 
	csql += "           SF4.D_E_L_E_T_ = ' ' AND "
	csql += "           SD1.D1_TES = SF4.F4_CODIGO "  	 
	cSql += "         JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
	cSql += "           SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
	cSql += "           SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
	cSql += "           SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)		
	csql += "       WHERE "
	csql += "         SD1.D1_DTDIGIT BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
	csql += "         SD1.D1_FORNECE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
	csql += "         SD1.D1_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
	csql += "         SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
	csql += "         SD1.D_E_L_E_T_ = ' ' AND "   
	csql += "         SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	  
	csql += "         SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "   	
	csql += "         SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
	csql += "         SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " 
	csql += "         SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' AND "
	csql += "         SD1.D1_TIPO = 'D'  "   
	cSql += "         AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
		cSql += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
	ENDIF
	If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
		cSql += "       AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	Endif

	If !Empty(cMVPAR15)  
		cSql += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
		If lGerente
			cSql += "     AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif
	Endif	

Return csql

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRkPGruProdบAutor  ณ Giane              บ Data ณ 04/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta consulta de ranking por grupo de produto             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RkPGruProd() 
	Local cQuery := ""    
	Local cAlias := "XCON"  

	oBtnCli:Enable()
	oBtnProd:Disable()
	oBtnGruV:Enable()
	oBtnSegV:Enable()
	oBtnVend:Enable()
	oBtnVendI:Enable()
	oBtnUF:Enable()
	oBtnCond:Enable()
	oBtnFret:Enable()
	oBtnGruS:Enable()

	If nTotGer == 0
		fSqlTot()  //funcao que vai calcular o total geral em reais da consulta
	EndIf  

	cQuery := "SELECT "
	cQuery += "  XTMP.GRUPROD, SBM.BM_DESC, XTMP.TOTGRU, XTMP.QTDPRO, XTMP.NPERCENT, XTMP.QTDPED "
	cQuery += "FROM "
	cQuery += "   ( "

	If cMVPAR18 == 3 //fazer um union all, pois deve somar os faturados com os pendentes:  
		cQuery += "SELECT "
		cQuery += "  XUNI.GRUPROD, SUM(XUNI.QTDPED) QTDPED, SUM(XUNI.TOTGRU) TOTGRU, SUM(XUNI.QTDPRO) QTDPRO, "
		cQuery += "  ( SUM(XUNI.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotGer,16,2) )+ " AS NPERCENT " 
		cQuery += "FROM "
		cQuery += "   ( "
	Endif

	If cMVPAR18 <> 1 //pedidos nao faturados ainda  
		cQuery += "   SELECT "  
		cQuery += "      SB1.B1_GRUPO GRUPROD, "
		cQuery += "      COUNT(DISTINCT C6_NUM) QTDPED, "
		cQuery += "      SUM(SC6.C6_QTDVEN) AS QTDPRO, "
		cQuery += "      SUM(SC6.C6_VALOR) AS TOTGRU " 
		if cMVPAR18 == 2   
			cQuery += "   ,( SUM(SC6.C6_VALOR) * 100 ) / " + ALLTRIM(STR(nTotPen,16,2) )+ " AS NPERCENT "  
		Endif
		cQuery += "    FROM " + RetSqlName("SC6") + " SC6 "  
		cQuery += "      JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += "        SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
		cQuery += "        SA1.A1_COD = SC6.C6_CLI AND "
		cQuery += "        SA1.A1_LOJA = SC6.C6_LOJA AND "
		cQuery += "        SA1.D_E_L_E_T_ = ' ' " 
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "		  JOIN " + RetSqlName("ACY") + " ACY ON "
			cQuery += "		    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
			cQuery += "		    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
			cQuery += "		    ACY.D_E_L_E_T_ = ' ' " 
		ENDIF
		cQuery += "      JOIN "+RetSQLName("SB1")+" SB1 ON "
		cQuery += "        SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "    
		cQuery += "        SB1.B1_COD = SC6.C6_PRODUTO AND "      	
		cQuery += "        SB1.D_E_L_E_T_ = ' ' "  	 
		cQuery += "      JOIN " + RetSqlName("SC5") + " SC5 ON "
		cQuery += "        SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "        SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " 
		cQuery += "        SC5.C5_NUM = SC6.C6_NUM "  
		cQuery += "      JOIN " + RetSqlName("SF4") + " SF4 ON "  
		cQuery += "        SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
		cQuery += "        SC6.C6_TES = SF4.F4_CODIGO AND "  
		cQuery += "        SF4.D_E_L_E_T_ = ' ' " 	 	  
		cQuery += "    WHERE "   
		cQuery += "   	 SC6.C6_NOTA = '         ' AND SC6.C6_SERIE = '  '  AND "
		cQuery += "      SC5.C5_X_CANC = ' '  AND "   
		cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "       
		cQuery += "      SC6.C6_ENTREG BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
		cQuery += "      SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
		cQuery += "      SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
		cQuery += "      SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
		cQuery += "      SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	
		cQuery += "      SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " 
		cQuery += "      SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
		cQuery += "      SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' "     
		cQuery += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S'  "	
		cQuery += "      AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "    AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "  AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif

		cQuery += "    GROUP BY B1_GRUPO "  

	Endif

	If cMVPAR18  == 3
		cQuery += "UNION  ALL "
	endif

	If cMVPAR18 <> 2 //pedidos ja faturados   

		cQuery += "   SELECT "
		cQuery += "     XFAT.GRUPROD, SUM(XFAT.QTDPED) QTDPED, SUM(XFAT.QTDPRO) QTDPRO, "   
		cQuery += "     SUM(XFAT.TOTGRU) TOTGRU "    
		If cMVPAR18 == 1 
			cQuery += "  ,( SUM(XFAT.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotLiq,16,2) )+ " AS NPERCENT "     	   
		Endif
		cQuery += "   FROM "

		cQuery += "   ( " 
		cQuery += "   SELECT "  
		cQuery += "      SB1.B1_GRUPO GRUPROD, COUNT(DISTINCT D2_PEDIDO) QTDPED, "   
		cQuery += "      SUM(SD2.D2_QUANT) AS QTDPRO, "                                            
		cQuery += "      SUM(SD2.D2_VALBRUT) AS TOTGRU " 	
		cQuery +=     fSqlFat()
		cQuery += "   GROUP BY B1_GRUPO "    

		cQuery += "   UNION ALL "   

		//verifica as DEVOLUCOES e substrai os valores encontrados do select acima de notas faturadas.
		cQuery += "   SELECT "  
		cQuery += "      SB1.B1_GRUPO GRUPROD, 0 QTDPED, "  
		cQuery += "      SUM(SD1.D1_QUANT * -1) AS QTDPRO,
		cQuery += "      SUM((SD1.D1_TOTAL + SD1.D1_VALIPI)* -1) AS TOTGRU "     
		cQuery +=     fSqlDev()	
		cQuery += "    GROUP BY B1_GRUPO "       
		cQuery += "    ) XFAT "
		cQuery += "   GROUP BY GRUPROD "               

	Endif                                  

	If cMVPAR18 == 3     
		cQuery += "  ) XUNI "
		cQuery += "GROUP BY GRUPROD "            
	Endif    

	cQuery += "  ) XTMP "
	cQuery += "  LEFT JOIN " + RetSqlName("SBM")+ " SBM ON "
	cQuery += "    XTMP.GRUPROD = SBM.BM_GRUPO AND "
	cQuery += "    SBM.BM_FILIAL = '" + xFilial("SBM") + "' AND "  
	cQuery += "    SBM.D_E_L_E_T_ = ' ' "     
	cQuery += "ORDER BY TOTGRU DESC "   


	If Select("XCON") > 0
		XCON->(DbCloseArea("XCON"))
	Endif                  

	//MEMOWRITE('C:\CFAT050.SQL',CQUERY)

	//cQuery := ChangeQuery(cQuery)   

	//TcQuery cQuery ALIAS "XCON" NEW   
	MsgRun("Montando consulta, aguarde...","Por Grupo Produto", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })   

	TcSetField(cAlias,'QTDPED','N',4,0)
	TcSetField(cAlias,'QTDPRO','N',16,2)
	TcSetField(cAlias,'TOTGRU','N',16,2)
	TcSetField(cAlias,'NPERCENT','N',7,2)       

	montaHeader("GruProd")  

	MsgRun("Processando Ranking por Grupo Produto, aguarde...","Ranking Faturamento",{|| XCON->(DbEval({|| AADD(aCols,{ XCON->GRUPROD, XCON->BM_DESC, XCON->TOTGRU, XCON->NPERCENT, XCON->QTDPRO, XCON->QTDPED, .F.})  },,,,,.T.)) })

	oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

	AlignObject( oDlg, {oGet:oBrowse}, 1, 2, {040,100} )  

	oGet:oBrowse:bLDblClick := {|| ItensProduto() }

	XCON->(DbCloseArea("XCON"))

Return 
/*       
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRkPVenda  บAutor  ณ Giane              บ Data ณ 05/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta consulta de ranking por grupo de vendas ou por       บฑฑ
ฑฑบ          ณ segmento de vendas                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RkPVenda(cTipo) 
	Local cQuery := ""    
	Local cAlias := "XCON"  

	oBtnCli:Enable()
	oBtnProd:Enable()  
	if cTipo == 'Gru'
		oBtnGruV:Disable()
		oBtnSegV:Enable()
		oBtnGruS:Enable()
	Elseif cTipo == 'Seg'
		oBtnSegV:Disable()
		oBtnGruV:Enable()
		oBtnGruS:Enable()
	Else
		oBtnSegV:Enable()
		oBtnGruV:Enable()
		oBtnGruS:Disable()
	Endif
	oBtnVend:Enable()
	oBtnVendI:Enable()
	oBtnUF:Enable()
	oBtnCond:Enable()
	oBtnFret:Enable()

	If nTotGer == 0
		fSqlTot(cTipo)  //funcao que vai calcular o total geral em reais da consulta
	EndIf  

	If cTipo == 'Gru'
		cQuery := "SELECT "
		cQuery += "  XTMP.VENDA, ACY.ACY_DESCRI, XTMP.TOTGRU, XTMP.NPERCENT, XTMP.QTDPED "
		cQuery += "FROM "
		cQuery += "   ( "
	Elseif cTipo == 'Seg'    
		cQuery := "SELECT "
		cQuery += "  XTMP.VENDA, SX5.X5_DESCRI AS DESCRI, XTMP.TOTGRU, XTMP.NPERCENT, XTMP.QTDPED "
		cQuery += "FROM "
		cQuery += "   ( "
	Else
		cQuery := "SELECT "
		cQuery += "  XTMP.VENDA, ACY.ACY_DESCRI, XTMP.TOTGRU, XTMP.NPERCENT, XTMP.QTDPED "
		cQuery += "FROM "
		cQuery += "   ( "
	Endif

	If cMVPAR18 == 3 //fazer um union all, pois deve somar os faturados com os pendentes:  
		cQuery += "SELECT "
		cQuery += "  XUNI.VENDA, SUM(XUNI.QTDPED) QTDPED, SUM(XUNI.TOTGRU) TOTGRU, "
		cQuery += "  ( SUM(XUNI.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotGer,16,2) )+ " AS NPERCENT " 
		cQuery += "FROM "
		cQuery += "   ( "
	Endif

	If cMVPAR18 <> 1 //pedidos nao faturados ainda  
		cQuery += "   SELECT "  
		If cTipo == 'Gru' //.OR. cTipo == 'Sup'
			cQuery += "      SC5.C5_GRPVEN VENDA, "
		ElseIf cTipo == 'Seg'
			cQuery += "      SA1.A1_SATIV1 VENDA, "
		Else
			cQuery += "      ACY.ACY_GRPSUP VENDA, "
		Endif
		cQuery += "      COUNT(DISTINCT C6_NUM) QTDPED, "
		cQuery += "      SUM(SC6.C6_VALOR) AS TOTGRU " 
		if cMVPAR18 == 2   
			cQuery += "   ,( SUM(SC6.C6_VALOR) * 100 ) / " + ALLTRIM(STR(nTotPen,16,2) )+ " AS NPERCENT "  
		Endif
		cQuery += "    FROM " + RetSqlName("SC6") + " SC6 "  
		cQuery += "      JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += "        SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
		cQuery += "        SA1.A1_COD = SC6.C6_CLI AND "
		cQuery += "        SA1.A1_LOJA = SC6.C6_LOJA AND "
		cQuery += "        SA1.D_E_L_E_T_ = ' ' " 
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ') .OR. cTipo == 'Sup'
			cQuery += "		  JOIN " + RetSqlName("ACY") + " ACY ON "
			cQuery += "		    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
			cQuery += "		    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
			cQuery += "		    ACY.D_E_L_E_T_ = ' ' " 
		ENDIF
		cQuery += "      JOIN "+RetSQLName("SB1")+" SB1 ON "
		cQuery += "        SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "    
		cQuery += "        SB1.B1_COD = SC6.C6_PRODUTO AND "      	
		cQuery += "        SB1.D_E_L_E_T_ = ' ' "  	 
		cQuery += "      JOIN " + RetSqlName("SC5") + " SC5 ON "
		cQuery += "        SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "        SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " 
		cQuery += "        SC5.C5_NUM = SC6.C6_NUM "     
		cQuery += "       JOIN " + RetSqlName("SF4") + " SF4 ON "  
		cQuery += "         SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
		cQuery += "         SC6.C6_TES = SF4.F4_CODIGO AND "  
		cQuery += "         SF4.D_E_L_E_T_ = ' ' " 	 	  
		cQuery += "    WHERE "   
		cQuery += "    	 SC6.C6_NOTA = '         ' AND SC6.C6_SERIE = '  '  AND "
		cQuery += "      SC5.C5_X_CANC = ' '  AND "   
		cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "       
		cQuery += "      SC6.C6_ENTREG BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
		cQuery += "      SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
		cQuery += "      SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
		cQuery += "      SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
		cQuery += "      SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	
		cQuery += "      SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " 
		cQuery += "      SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
		cQuery += "      SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' "   
		cQuery += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "		
		cQuery += "      AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "  AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "  AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif	  
		If cTipo == 'Gru' //.OR. cTipo == 'Sup'
			cQuery += "    GROUP BY C5_GRPVEN "  
		ElseIf cTipo == 'Seg' 
			cQuery += "    GROUP BY A1_SATIV1 "      
		Else
			cQuery += "    GROUP BY ACY_GRPSUP "          
		Endif

	Endif

	If cMVPAR18  == 3
		cQuery += "UNION ALL "
	endif

	If cMVPAR18 <> 2 //pedidos ja faturados 

		cQuery += "   SELECT "                          
		cQuery += "     XFAT.VENDA, SUM(XFAT.QTDPED) QTDPED, SUM(XFAT.TOTGRU) TOTGRU "   
		If cMVPAR18 == 1 
			cQuery += "  ,( SUM(XFAT.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotLiq,16,2) )+ " AS NPERCENT "     	   
		Endif
		cQuery += "   FROM "
		cQuery += "   ( "  

		cQuery += "    SELECT "    
		If cTipo == 'Gru' //.OR. cTipo == 'Sup'
			cQuery += "   SC5.C5_GRPVEN VENDA, COUNT(DISTINCT D2_PEDIDO) QTDPED, "
		ElseIf cTipo == 'Seg'
			cQuery += "   SA1.A1_SATIV1 VENDA, COUNT(DISTINCT D2_PEDIDO) QTDPED, "	
		Else
			cQuery += "   ACY.ACY_GRPSUP VENDA, COUNT(DISTINCT D2_PEDIDO) QTDPED, "		
		Endif	
		cQuery += "      SUM(SD2.D2_VALBRUT) AS TOTGRU "    
		cQuery +=  fSqlFat(cTipo)
		If cTipo == 'Gru' //.OR. cTipo == 'Sup'
			cQuery += " GROUP BY C5_GRPVEN "      
		ElseiF cTipo == 'Seg' 
			cQuery += " GROUP BY A1_SATIV1 "      
		Else
			cQuery += " GROUP BY ACY_GRPSUP "
		Endif	                                

		cQuery += "    UNION ALL " 

		//devolucoes:
		cQuery += "    SELECT "    
		If cTipo == 'Gru' //.OR. cTipo == 'Sup'
			cQuery += "   SC5.C5_GRPVEN VENDA, 0 QTDPED, "
		ElseIf cTipo == 'Seg'
			cQuery += "   SA1.A1_SATIV1 VENDA, 0 QTDPED, "	
		Else
			cQuery += "   ACY.ACY_GRPSUP VENDA, 0 QTDPED, "		
		Endif	
		cQuery += "      SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) AS TOTGRU "    
		cQuery +=  fSqlDev(cTipo)
		If cTipo == 'Gru' //.OR. cTipo == 'Sup'
			cQuery += " GROUP BY C5_GRPVEN "      
		ElseIf cTipo == 'Seg' 
			cQuery += " GROUP BY A1_SATIV1 "      
		Else
			cQuery += " GROUP BY ACY_GRPSUP "
		Endif    

		cQuery += "   ) XFAT "
		cQuery += "  GROUP BY VENDA  "         

	Endif                                  

	If cMVPAR18 == 3     
		cQuery += "  ) XUNI "
		cQuery += "GROUP BY VENDA "            
	Endif    

	cQuery += "  ) XTMP "   
	If cTipo == 'Gru'  .OR. cTipo == 'Sup'
		cQuery += "  LEFT JOIN " + RetSqlName("ACY")+ " ACY ON "
		cQuery += "    XTMP.VENDA = ACY.ACY_GRPVEN AND "
		cQuery += "    ACY.ACY_FILIAL = '" + xFilial("ACY") + "' AND "  
		cQuery += "    ACY.D_E_L_E_T_ = ' ' "     
	ElseIf cTipo == 'Seg' 
		cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " SX5 ON "
		cQuery += "    SX5.X5_FILIAL = '" + xFilial("SX5") + "' AND "    
		cQuery += "    SX5.X5_TABELA = 'T3' AND "
		cQuery += "    SX5.X5_CHAVE = XTMP.VENDA AND "
		cQuery += "    SX5.D_E_L_E_T_ = ' ' "    
		//Else
		//	cQuery += "  LEFT JOIN " + RetSqlName("ACY")+ " ACY ON "
		//	cQuery += "    XTMP.VENDA = ACY.ACY_GRPVEN AND "
		//	cQuery += "    ACY.ACY_FILIAL = '" + xFilial("ACY") + "' AND "  
		//	cQuery += "    ACY.D_E_L_E_T_ = ' ' "     
	Endif
	cQuery += "ORDER BY TOTGRU DESC "          

	If Select("XCON") > 0
		XCON->(DbCloseArea("XCON"))
	Endif                  

	//MEMOWRITE('C:\CFAT050.SQL',CQUERY)

	//cQuery := ChangeQuery(cQuery)   

	//TcQuery cQuery ALIAS "XCON" NEW              
	MsgRun("Montando consulta, aguarde...","Ranking Faturamento", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })   

	TcSetField(cAlias,'QTDPED','N',4,0)
	TcSetField(cAlias,'TOTGRU','N',16,2)
	TcSetField(cAlias,'NPERCENT','N',7,2)


	if cTipo == 'Gru'
		montaHeader("GruVenda")  
		MsgRun("Processando Ranking por Grupo Venda, aguarde...","Ranking Faturamento",{|| XCON->(DbEval({|| AADD(aCols,{ XCON->VENDA, XCON->ACY_DESCRI, XCON->TOTGRU, XCON->NPERCENT, XCON->QTDPED, .F.})  },,,,,.T.)) })
	ElseIf cTipo == 'Seg' 
		montaHeader("SegVenda") 
		MsgRun("Processando Ranking por Seg.Vendas, aguarde...","Ranking Faturamento",{||XCON->(DbEval({|| AADD(aCols,{ XCON->VENDA, XCON->DESCRI, XCON->TOTGRU, XCON->NPERCENT, XCON->QTDPED, .F.})  },,,,,.T.)) })
	Else
		montaHeader("GruSup")  
		MsgRun("Processando Ranking por Grupo Superior, aguarde...","Ranking Faturamento",{|| XCON->(DbEval({|| AADD(aCols,{ XCON->VENDA, XCON->ACY_DESCRI, XCON->TOTGRU, XCON->NPERCENT, XCON->QTDPED, .F.})  },,,,,.T.)) })
	Endif

	oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

	AlignObject( oDlg, {oGet:oBrowse}, 1, 2, {040,100} )  

	XCON->(DbCloseArea("XCON"))

Return 

/*       
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRkPVendedoบAutor  ณ Giane              บ Data ณ 05/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta consulta de ranking por vendedor ou vendedor interno บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RkPVendedor(cTipo) 
	Local cQuery := ""    
	Local cAlias := "XCON"  

	oBtnCli:Enable()
	oBtnProd:Enable()  
	oBtnSegV:Enable()
	oBtnGruV:Enable() 
	if cTipo == "V"
		oBtnVend:Disable()
		oBtnVendI:Enable()
	Else 
		oBtnVend:Enable()
		oBtnVendI:Disable()
	Endif
	oBtnUF:Enable()
	oBtnCond:Enable()
	oBtnFret:Enable()
	oBtnGruS:Enable()

	If nTotGer == 0
		fSqlTot()  //funcao que vai calcular o total geral em reais da consulta
	EndIf  

	cQuery := "SELECT "
	cQuery += "  XTMP.VENDEDOR, SA3.A3_NOME, XTMP.TOTGRU, XTMP.NPERCENT, XTMP.QTDPED "
	cQuery += "FROM "
	cQuery += "   ( "

	If cMVPAR18 == 3 //fazer um union all, pois deve somar os faturados com os pendentes:  
		cQuery += "SELECT "
		cQuery += "  XUNI.VENDEDOR, SUM(XUNI.QTDPED) QTDPED, SUM(XUNI.TOTGRU) TOTGRU, "
		cQuery += "  ( SUM(XUNI.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotGer,16,2) )+ " AS NPERCENT " 
		cQuery += "FROM "
		cQuery += "   ( "
	Endif

	If cMVPAR18 <> 1 //pedidos nao faturados ainda  
		cQuery += "   SELECT "  
		If cTipo == 'V'
			cQuery += "      SC5.C5_VEND1 VENDEDOR, "
		Else 
			cQuery += "      SA1.A1_VENDINT VENDEDOR, "
		Endif
		cQuery += "      COUNT(DISTINCT C6_NUM) QTDPED, "
		cQuery += "      SUM(SC6.C6_VALOR) AS TOTGRU " 
		if cMVPAR18 == 2   
			cQuery += "   ,( SUM(SC6.C6_VALOR) * 100 ) / " + ALLTRIM(STR(nTotPen,16,2) )+ " AS NPERCENT "  
		Endif
		cQuery += "    FROM " + RetSqlName("SC6") + " SC6 "  
		cQuery += "      JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += "        SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
		cQuery += "        SA1.A1_COD = SC6.C6_CLI AND "
		cQuery += "        SA1.A1_LOJA = SC6.C6_LOJA AND "
		cQuery += "        SA1.D_E_L_E_T_ = ' ' "
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "		  JOIN " + RetSqlName("ACY") + " ACY ON "
			cQuery += "		    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
			cQuery += "		    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
			cQuery += "		    ACY.D_E_L_E_T_ = ' ' " 
		ENDIF
		cQuery += "      JOIN "+RetSQLName("SB1")+" SB1 ON "
		cQuery += "        SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "    
		cQuery += "        SB1.B1_COD = SC6.C6_PRODUTO AND "      	
		cQuery += "        SB1.D_E_L_E_T_ = ' ' "  	 
		cQuery += "      JOIN " + RetSqlName("SC5") + " SC5 ON "
		cQuery += "        SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "        SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " 
		cQuery += "        SC5.C5_NUM = SC6.C6_NUM "
		cQuery += "      JOIN " + RetSqlName("SF4") + " SF4 ON "  
		cQuery += "         SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
		cQuery += "         SC6.C6_TES = SF4.F4_CODIGO AND "  
		cQuery += "         SF4.D_E_L_E_T_ = ' ' " 	 		  
		cQuery += "    WHERE "   
		cQuery += "  	   SC6.C6_NOTA = '         ' AND SC6.C6_SERIE = '  '  AND "
		cQuery += "      SC5.C5_X_CANC = ' '  AND "   
		cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "       
		cQuery += "      SC6.C6_ENTREG BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
		cQuery += "      SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
		cQuery += "      SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
		cQuery += "      SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
		cQuery += "      SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	
		cQuery += "      SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " 
		cQuery += "      SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
		cQuery += "      SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' " 
		cQuery += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "	  
		cQuery += "      AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' " 
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "    AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "  AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif

		If cTipo == 'V'
			cQuery += "    GROUP BY C5_VEND1 "  
		Else 
			cQuery += "    GROUP BY A1_VENDINT "      
		Endif

	Endif

	If cMVPAR18  == 3
		cQuery += "UNION ALL "
	endif

	If cMVPAR18 <> 2 //pedidos ja faturados    
		cQuery += "  SELECT "
		cQuery += "    XFAT.VENDEDOR, SUM(XFAT.QTDPED) QTDPED, SUM(XFAT.TOTGRU) TOTGRU "
		If cMVPAR18 == 1
			cQuery += "   ,( SUM(XFAT.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotLiq,16,2) )+ " AS NPERCENT " 
		Endif  
		cQuery += "  FROM "
		cQuery += "  (    

		cQuery += "   SELECT "    
		If cTipo == 'V'
			cQuery += "      SF2.F2_VEND1 VENDEDOR, COUNT(DISTINCT D2_PEDIDO) QTDPED, "
		Else
			cQuery += "      SA1.A1_VENDINT VENDEDOR, COUNT(DISTINCT D2_PEDIDO) QTDPED, "	
		Endif	
		cQuery += "      SUM(SD2.D2_VALBRUT) AS TOTGRU "   
		cQuery += fSqlFat()
		If cTipo == 'V'
			cQuery += "    GROUP BY F2_VEND1 "      
		Else 
			cQuery += "    GROUP BY A1_VENDINT "      
		Endif   	

		cQuery += "    UNION ALL " 

		//devolucoes:
		cQuery += "    SELECT "    
		If cTipo == 'V'
			cQuery += "      SF2.F2_VEND1 VENDEDOR, 0 QTDPED, "
		Else
			cQuery += "      SA1.A1_VENDINT VENDEDOR, 0 QTDPED, "	
		Endif	 
		cQuery += "      SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) AS TOTGRU "    
		cQuery +=  fSqlDev()
		If cTipo == 'V'
			cQuery += "    GROUP BY F2_VEND1 "      
		Else 
			cQuery += "    GROUP BY A1_VENDINT "      
		Endif  

		cQuery += "   ) XFAT "
		cQuery += "  GROUP BY VENDEDOR  "    	  	

	Endif                                  

	If cMVPAR18 == 3     
		cQuery += "  ) XUNI "
		cQuery += "GROUP BY VENDEDOR "            
	Endif    

	cQuery += "  ) XTMP "   
	cQuery += "  LEFT JOIN " + RetSqlName("SA3")+ " SA3 ON "
	cQuery += "    XTMP.VENDEDOR = SA3.A3_COD AND "
	cQuery += "    SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND "  
	cQuery += "    SA3.D_E_L_E_T_ = ' ' "     
	cQuery += "ORDER BY TOTGRU DESC "          

	If Select("XCON") > 0
		XCON->(DbCloseArea("XCON"))
	Endif                  

	MEMOWRITE('C:\CFAT050Vend.SQL',CQUERY)

	//cQuery := ChangeQuery(cQuery)   

	//TcQuery cQuery ALIAS "XCON" NEW  
	MsgRun("Montando consulta, aguarde...","Por Vendedor", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })    

	TcSetField(cAlias,'QTDPED','N',4,0)
	TcSetField(cAlias,'TOTGRU','N',16,2)
	TcSetField(cAlias,'NPERCENT','N',7,2)


	If cTipo == 'V'             
		montaHeader("Vendedor")  
	Else 
		montaHeader("VendInt")
	Endif 

	MsgRun("Processando Ranking por Vendedor, aguarde...","Ranking Faturamento",{|| XCON->(DbEval({|| AADD(aCols,{ XCON->VENDEDOR, XCON->A3_NOME, XCON->TOTGRU, XCON->NPERCENT, XCON->QTDPED, .F.})  },,,,,.T.)) })

	oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

	AlignObject( oDlg, {oGet:oBrowse}, 1, 2, {040,100} )  

	XCON->(DbCloseArea("XCON"))

Return 
/*       
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRkPDiversoบAutor  ณ Giane              บ Data ณ 05/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta consulta de ranking por UF, cond.pagto e FRETE       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RkPDiversos(cTipo) 
	Local cQuery := ""    
	Local cAlias := "XCON"  

	oBtnCli:Enable()
	oBtnProd:Enable()  
	oBtnSegV:Enable()
	oBtnGruV:Enable() 
	oBtnVendI:Enable()
	oBtnVend:Enable()

	if cTipo == "U"
		oBtnUF:Disable()
		oBtnCond:Enable()
		oBtnFret:Enable() 
	elseif cTipo == "C"
		oBtnUF:Enable()
		oBtnCond:Disable()
		oBtnFret:Enable() 
	elseif cTipo == "F"
		oBtnUF:Enable()
		oBtnCond:Enable()
		oBtnFret:Disable() 
	Endif 
	oBtnGruS:Enable()

	If nTotGer == 0
		fSqlTot()  //funcao que vai calcular o total geral em reais da consulta
	EndIf  

	cQuery := "SELECT "+ CHR(13) + CHR(10)
	cQuery += "  XTMP.TIPO, " + CHR(13) + CHR(10)  
	If cTipo == 'C' 
		cQuery += "  SE4.E4_DESCRI, " + CHR(13) + CHR(10)
	Endif
	cQuery += "  XTMP.TOTGRU, XTMP.NPERCENT, XTMP.QTDPED " + CHR(13) + CHR(10)
	cQuery += "FROM " + CHR(13) + CHR(10)
	cQuery += "  ( " + CHR(13) + CHR(10)

	If cMVPAR18 == 3 //fazer um union all, pois deve somar os faturados com os pendentes:  
		cQuery += "   SELECT " + CHR(13) + CHR(10)
		cQuery += "     XUNI.TIPO, SUM(XUNI.QTDPED) QTDPED, SUM(XUNI.TOTGRU) TOTGRU, " + CHR(13) + CHR(10)
		cQuery += "     ( SUM(XUNI.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotGer,16,2) )+ " AS NPERCENT " + CHR(13) + CHR(10)
		cQuery += "   FROM " + CHR(13) + CHR(10)
		cQuery += "     ( " + CHR(13) + CHR(10)
	Endif

	If cMVPAR18 <> 1 //pedidos nao faturados ainda  
		cQuery += "      SELECT " + CHR(13) + CHR(10)
		If cTipo == 'U'
			cQuery += "        SA1.A1_EST TIPO, " + CHR(13) + CHR(10)
		Elseif cTipo == 'C' 
			cQuery += "        SC5.C5_CONDPAG TIPO, " + CHR(13) + CHR(10)
		Elseif cTipo == 'F'        
			//cQuery += "        DECODE ( SC5.C5_TPFRETE, 'C','CIF','FOB') TIPO, " + CHR(13) + CHR(10)
			cQuery += "        SC5.C5_TPFRETE TIPO, " + CHR(13) + CHR(10)
		Endif
		cQuery += "        COUNT(DISTINCT C6_NUM) QTDPED, " + CHR(13) + CHR(10)
		cQuery += "        SUM(SC6.C6_VALOR) AS TOTGRU " + CHR(13) + CHR(10)
		if cMVPAR18 == 2   
			cQuery += "        ,( SUM(SC6.C6_VALOR) * 100 ) / " + ALLTRIM(STR(nTotPen,16,2) )+ " AS NPERCENT " + CHR(13) + CHR(10)
		Endif
		cQuery += "      FROM " + RetSqlName("SC6") + " SC6 " + CHR(13) + CHR(10)
		cQuery += "        JOIN " + RetSqlName("SA1") + " SA1 ON " + CHR(13) + CHR(10)
		cQuery += "          SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND " + CHR(13) + CHR(10)
		cQuery += "          SA1.A1_COD = SC6.C6_CLI AND " + CHR(13) + CHR(10)
		cQuery += "          SA1.A1_LOJA = SC6.C6_LOJA AND " + CHR(13) + CHR(10)
		cQuery += "          SA1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "		  JOIN " + RetSqlName("ACY") + " ACY ON "+ CHR(13) + CHR(10)
			cQuery += "		     ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "+ CHR(13) + CHR(10)
			cQuery += "		     ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "+ CHR(13) + CHR(10)
			cQuery += "		     ACY.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		ENDIF
		cQuery += "        JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
		cQuery += "          SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
		cQuery += "          SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
		cQuery += "          SC5.C5_NUM = SC6.C6_NUM " + CHR(13) + CHR(10)
		cQuery += "        JOIN "+RetSQLName("SB1")+" SB1 ON " + CHR(13) + CHR(10)
		cQuery += "          SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND " + CHR(13) + CHR(10)
		cQuery += "          SB1.B1_COD = SC6.C6_PRODUTO AND " + CHR(13) + CHR(10)
		cQuery += "          SB1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		cQuery += "       JOIN " + RetSqlName("SF4") + " SF4 ON "  
		cQuery += "         SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
		cQuery += "         SC6.C6_TES = SF4.F4_CODIGO AND "  
		cQuery += "         SF4.D_E_L_E_T_ = ' ' " 	 			
		cQuery += "      WHERE " + CHR(13) + CHR(10)
		cQuery += "     	 SC6.C6_NOTA = '         ' AND SC6.C6_SERIE = '  '  AND " + CHR(13) + CHR(10)
		cQuery += "        SC5.C5_X_CANC = ' '  AND " + CHR(13) + CHR(10)
		cQuery += "        SC6.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
		cQuery += "        SC6.C6_ENTREG BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND " + CHR(13) + CHR(10)  
		cQuery += "        SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND " + CHR(13) + CHR(10)
		cQuery += "        SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND " + CHR(13) + CHR(10)
		cQuery += "        SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " + CHR(13) + CHR(10)
		//	cQuery += "        SA1.A1_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' AND " + CHR(13) + CHR(10)
		cQuery += "        SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND " + CHR(13) + CHR(10)
		cQuery += "        SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " + CHR(13) + CHR(10)
		cQuery += "        SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND " + CHR(13) + CHR(10)
		cQuery += "        SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' " + CHR(13) + CHR(10) 
		cQuery += "        AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "	+ CHR(13) + CHR(10)
		cQuery += "        AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "+ CHR(13) + CHR(10)
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "      AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "    AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += "    AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif	

		If cTipo == 'U'   	   
			cQuery += "      GROUP BY A1_EST " + CHR(13) + CHR(10) 
		Elseif cTipo == "C" 
			cQuery += "      GROUP BY C5_CONDPAG " + CHR(13) + CHR(10)     
		Elseif cTipo == "F"  
			cQuery += "      GROUP BY C5_TPFRETE " + CHR(13) + CHR(10)
		Endif

	Endif

	If cMVPAR18  == 3
		cQuery += "      UNION ALL " + CHR(13) + CHR(10) 
	endif

	If cMVPAR18 <> 2 //pedidos ja faturados  
		cQuery += "      SELECT " + CHR(13) + CHR(10)
		cQuery += "        XFAT.TIPO, SUM(XFAT.QTDPED) QTDPED, SUM(XFAT.TOTGRU) TOTGRU " + CHR(13) + CHR(10)
		If cMVPAR18 == 1
			cQuery += "        ,( SUM(XFAT.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotLiq,16,2) )+ " AS NPERCENT " + CHR(13) + CHR(10)
		Endif 
		cQuery += "      FROM " + CHR(13) + CHR(10)
		cQuery += "        ( " + CHR(13) + CHR(10)
		cQuery += "         SELECT " + CHR(13) + CHR(10)
		If cTipo == 'U'
			cQuery += "           SA1.A1_EST TIPO, " + CHR(13) + CHR(10)
		Elseif cTipo == "C"
			cQuery += "           SF2.F2_COND TIPO, " + CHR(13) + CHR(10)
		Elseif cTipo == "F"
			//cQuery += "           DECODE( SC5.C5_TPFRETE, 'C','CIF', 'F','FOB',' ') TIPO, " + CHR(13) + CHR(10)
			cQuery += "           SC5.C5_TPFRETE TIPO, " + CHR(13) + CHR(10)
		Endif
		cQuery += "           COUNT(DISTINCT D2_PEDIDO) QTDPED, "	+ CHR(13) + CHR(10)
		cQuery += "           SUM(SD2.D2_VALBRUT) AS TOTGRU " + CHR(13) + CHR(10)
		cQuery += "         FROM " + RetSqlName("SD2") + " SD2 " + CHR(13) + CHR(10)
		cQuery += "           JOIN " + RetSqlName("SF2") + " SF2 ON "	 + CHR(13) + CHR(10)
		cQuery += "             SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND " + CHR(13) + CHR(10)
		cQuery += "             SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND "	+ CHR(13) + CHR(10)
		cQuery += "             SF2.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
		cQuery += "           JOIN " + RetSqlName("SA1") + " SA1 ON " + CHR(13) + CHR(10)
		cQuery += "             SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND " + CHR(13) + CHR(10)
		cQuery += "             SA1.A1_COD = SD2.D2_CLIENTE AND " + CHR(13) + CHR(10)
		cQuery += "             SA1.A1_LOJA = SD2.D2_LOJA AND " + CHR(13) + CHR(10)
		cQuery += "             SA1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "		      JOIN " + RetSqlName("ACY") + " ACY ON "+ CHR(13) + CHR(10)
			cQuery += "		        ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "+ CHR(13) + CHR(10)
			cQuery += "		        ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "+ CHR(13) + CHR(10)
			cQuery += "		        ACY.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		ENDIF
		cQuery += "           JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
		cQuery += "             SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
		cQuery += "             SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
		cQuery += "             SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)
		cQuery += "           JOIN " + RetSqlName("SF4") + " SF4 ON " + CHR(13) + CHR(10)
		cQuery += "             SD2.D2_TES = SF4.F4_CODIGO AND "  + CHR(13) + CHR(10)
		cQuery += "             SF4.D_E_L_E_T_ = ' ' AND "	+ CHR(13) + CHR(10)
		cQuery += "             SF4.F4_FILIAL = '"+xFilial("SF4")+"' "  + CHR(13) + CHR(10)
		cQuery += "           JOIN "+RetSQLName("SB1")+" SB1 ON " + CHR(13) + CHR(10)
		cQuery += "             SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND " + CHR(13) + CHR(10)
		cQuery += "             SB1.B1_COD = SD2.D2_COD AND " + CHR(13) + CHR(10)
		cQuery += "             SB1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
		cQuery += "         WHERE " + CHR(13) + CHR(10)
		cQuery += "           SD2.D2_EMISSAO BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SD2.D2_CLIENTE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SD2.D2_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SD2.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
		//	cQuery += "           SA1.A1_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " + CHR(13) + CHR(10)
		cQuery += "           SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' " + CHR(13) + CHR(10)
		cQuery += "           AND SD2.D2_TIPO IN ('N','C','I','P') " + CHR(13) + CHR(10)
		cQuery += "           AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "+ CHR(13) + CHR(10)
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "         AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "       AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += "       AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif			

		If cTipo == 'U'
			cQuery += "         GROUP BY A1_EST "  + CHR(13) + CHR(10)
		Elseif cTipo == "C"
			cQuery += "         GROUP BY F2_COND " + CHR(13) + CHR(10)
		Elseif cTipo == "F"                                  
			//cQuery += "     //AND SC5.C5_TPFRETE IN ('C','F') "
			cQuery += "         GROUP BY C5_TPFRETE " + CHR(13) + CHR(10)
		Endif

		cQuery += "         UNION ALL " + CHR(13) + CHR(10)

		//DEVOLUCOES 
		if cTipo == 'F'
			//fSqlFrete(@cQuery) 
			cQuery += "         SELECT " + CHR(13) + CHR(10)
			cQuery += "           XFRE.TIPO TIPO , XFRE.QTDPED, XFRE.TOTGRU " + CHR(13) + CHR(10)
			cQuery += "         FROM " + CHR(13) + CHR(10)
			cQuery += "          ( " + CHR(13) + CHR(10)
			cQuery += "           SELECT " + CHR(13) + CHR(10)
			cQuery += "             C5_TPFRETE TIPO, " + CHR(13) + CHR(10)
			cQuery += "             0 QTDPED, "	 + CHR(13) + CHR(10)
			cQuery += "             SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) AS TOTGRU " + CHR(13) + CHR(10)
			cQuery += "  	        FROM " + RetSqlName("SD1") + " SD1 " + CHR(13) + CHR(10)
			cQuery += "     	      JOIN " + RetSqlName("SD2") + " SD2 ON " + CHR(13) + CHR(10)
			cQuery += "     	        SD2.D2_FILIAL = SD1.D1_FILIAL AND " + CHR(13) + CHR(10)
			cQuery += "       	      SD1.D1_NFORI = SD2.D2_DOC AND " + CHR(13) + CHR(10)
			cQuery += "      	        SD1.D1_SERIORI = SD2.D2_SERIE AND " + CHR(13) + CHR(10)
			cQuery += "      	        SD1.D1_ITEMORI = SD2.D2_ITEM AND " + CHR(13) + CHR(10)
			cQuery += "               SD2.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
			cQuery += "             JOIN " + RetSqlName("SF2") + " SF2 ON " + CHR(13) + CHR(10)
			cQuery += "               SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND " + CHR(13) + CHR(10)
			cQuery += "               SD1.D1_NFORI = SF2.F2_DOC AND " + CHR(13) + CHR(10)
			cQuery += "               SD1.D1_SERIORI = SF2.F2_SERIE AND " + CHR(13) + CHR(10)
			cQuery += "               SF2.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
			cQuery += "   	        JOIN " + RetSqlName("SB1") + " SB1 ON " + CHR(13) + CHR(10)
			cQuery += "   	          SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND " + CHR(13) + CHR(10)
			cQuery += "    	          SD1.D1_COD = SB1.B1_COD AND " + CHR(13) + CHR(10)
			cQuery += "    	          SB1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
			cQuery += "             JOIN " + RetSqlName("SA1") + " SA1 ON " + CHR(13) + CHR(10)
			cQuery += "    	          SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND " + CHR(13) + CHR(10)
			cQuery += "               SD1.D1_FORNECE = SA1.A1_COD AND " + CHR(13) + CHR(10)
			cQuery += "               SD1.D1_LOJA = SA1.A1_LOJA AND " + CHR(13) + CHR(10)
			cQuery += "               SA1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
			IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
				cQuery += "		 	    JOIN " + RetSqlName("ACY") + " ACY ON "+ CHR(13) + CHR(10)
				cQuery += "		    	  ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "+ CHR(13) + CHR(10)
				cQuery += "		    	  ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "+ CHR(13) + CHR(10)
				cQuery += "		    	  ACY.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
			ENDIF
			cQuery += "             JOIN " + RetSqlName("SF4") + " SF4 ON " + CHR(13) + CHR(10)
			cQuery += "               SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND " + CHR(13) + CHR(10)
			cQuery += "               SF4.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
			cQuery += "               SD1.D1_TES = SF4.F4_CODIGO " + CHR(13) + CHR(10)
			cQuery += "             JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
			cQuery += "               SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
			cQuery += "               SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
			cQuery += "               SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)
			cQuery += "           WHERE " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_DTDIGIT BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_FORNECE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
			//	cQuery += "             SA1.A1_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_TIPO = 'D'  " + CHR(13) + CHR(10)     
			IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
				cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
			ENDIF
			cQuery += "             AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  + CHR(13) + CHR(10)
			If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
				cQuery += "           AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif

			If !Empty(cMVPAR15)  
				cQuery += "         AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
				If lGerente
					cQuery += "         AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
				Endif
			Endif
			cQuery += "           GROUP BY C5_TPFRETE " + CHR(13) + CHR(10)
			cQuery += "          ) XFRE " + CHR(13) + CHR(10)

		Else     

			cQuery += "         SELECT " + CHR(13) + CHR(10)
			If cTipo == 'U'
				cQuery += "           SA1.A1_EST TIPO, " + CHR(13) + CHR(10)
			Elseif cTipo == "C"
				cQuery += "           SF2.F2_COND TIPO, "	+ CHR(13) + CHR(10)
			Endif
			cQuery += "           0 QTDPED, "	 + CHR(13) + CHR(10)
			cQuery += "           SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) AS TOTGRU " + CHR(13) + CHR(10)
			cQuery += "         FROM " + RetSqlName("SD1") + " SD1 " + CHR(13) + CHR(10)
			cQuery += "           JOIN " + RetSqlName("SD2") + " SD2 ON " + CHR(13) + CHR(10)
			cQuery += "             SD2.D2_FILIAL = SD1.D1_FILIAL AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_NFORI = SD2.D2_DOC AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_SERIORI = SD2.D2_SERIE AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_ITEMORI = SD2.D2_ITEM AND " + CHR(13) + CHR(10)
			cQuery += "             SD2.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)    		
			cQuery += "           JOIN " + RetSqlName("SF2") + " SF2 ON " + CHR(13) + CHR(10)
			cQuery += "             SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_NFORI = SF2.F2_DOC AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_SERIORI = SF2.F2_SERIE AND " + CHR(13) + CHR(10)
			cQuery += "             SF2.D_E_L_E_T_ = ' ' "	+ CHR(13) + CHR(10)  
			cQuery += "           JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
			cQuery += "             SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
			cQuery += "             SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
			cQuery += "             SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)
			cQuery += "   	      JOIN " + RetSqlName("SB1") + " SB1 ON " + CHR(13) + CHR(10)
			cQuery += "   	        SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND " + CHR(13) + CHR(10)
			cQuery += "    	        SD1.D1_COD = SB1.B1_COD AND " + CHR(13) + CHR(10)
			cQuery += "    	        SB1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
			cQuery += "           JOIN " + RetSqlName("SA1") + " SA1 ON " + CHR(13) + CHR(10)
			cQuery += "    	        SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_FORNECE = SA1.A1_COD AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_LOJA = SA1.A1_LOJA AND " + CHR(13) + CHR(10)
			cQuery += "             SA1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
			IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
				cQuery += "			  JOIN " + RetSqlName("ACY") + " ACY ON "+ CHR(13) + CHR(10)
				cQuery += "		        ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "+ CHR(13) + CHR(10)
				cQuery += "		        ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "+ CHR(13) + CHR(10)
				cQuery += "		        ACY.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
			ENDIF
			cQuery += "           JOIN " + RetSqlName("SF4") + " SF4 ON " + CHR(13) + CHR(10)
			cQuery += "             SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND " + CHR(13) + CHR(10)
			cQuery += "             SF4.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
			cQuery += "             SD1.D1_TES = SF4.F4_CODIGO " + CHR(13) + CHR(10)
			cQuery += "         WHERE " + CHR(13) + CHR(10)
			cQuery += "           SD1.D1_DTDIGIT BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND " + CHR(13) + CHR(10)
			cQuery += "           SD1.D1_FORNECE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND " + CHR(13) + CHR(10)
			cQuery += "           SD1.D1_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND " + CHR(13) + CHR(10)
			cQuery += "           SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND " + CHR(13) + CHR(10)
			cQuery += "           SD1.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
			//	cQuery += "           SA1.A1_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' AND " + CHR(13) + CHR(10)
			cQuery += "           SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND " + CHR(13) + CHR(10)
			cQuery += "           SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " + CHR(13) + CHR(10)
			cQuery += "           SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "+ CHR(13) + CHR(10)
			cQuery += "           SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " + CHR(13) + CHR(10)
			cQuery += "           SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' AND " + CHR(13) + CHR(10)
			cQuery += "    	      SD1.D1_TIPO = 'D'  " + CHR(13) + CHR(10)   
			cQuery += "           AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  + CHR(13) + CHR(10)
			IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
				cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
			ENDIF
			If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
				cQuery += "         AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif

			If !Empty(cMVPAR15)  
				cQuery += "         AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
				If lGerente
					cQuery += "       AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
				Endif
			Endif

			If cTipo == 'U'
				cQuery += "         GROUP BY A1_EST " + CHR(13) + CHR(10) //DECODE ( SD2.D2_EST, '', SA1.A1_EST, SD2.D2_EST) "     
			Elseif cTipo == "C"
				cQuery += "         GROUP BY F2_COND " + CHR(13) + CHR(10)
			Endif   

		Endif

		cQuery += "        ) XFAT " + CHR(13) + CHR(10)
		cQuery += "      GROUP BY TIPO " + CHR(13) + CHR(10)

	Endif                                  

	If cMVPAR18 == 3     
		cQuery += "     ) XUNI " + CHR(13) + CHR(10)
		cQuery += "     GROUP BY TIPO " + CHR(13) + CHR(10)
	Endif    

	cQuery += "  ) XTMP " + CHR(13) + CHR(10)
	If cTipo == 'C'
		cQuery += "  JOIN " + RetSqlName("SE4") + " SE4 ON " + CHR(13) + CHR(10)
		cQuery += "    SE4.E4_FILIAL = '" + xFilial("SE4") + "' AND " + CHR(13) + CHR(10)
		cQuery += "    SE4.E4_CODIGO = XTMP.TIPO AND SE4.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
	endif
	cQuery += "ORDER BY TOTGRU DESC " + CHR(13) + CHR(10)

	If Select("XCON") > 0
		XCON->(DbCloseArea("XCON"))
	Endif                  

	//MEMOWRITE('C:\CFATfrete.SQL',CQUERY)

	//cQuery := ChangeQuery(cQuery)   

	//TcQuery cQuery ALIAS "XCON" NEW       
	MsgRun("Montando consulta, aguarde...","Ranking Faturamento", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })   

	TcSetField(cAlias,'QTDPED','N',4,0)
	TcSetField(cAlias,'TOTGRU','N',16,2)
	TcSetField(cAlias,'NPERCENT','N',7,2)


	If cTipo == 'U'             
		montaHeader("UF")  
		MsgRun("Processando Ranking por UF, aguarde...","Ranking Faturamento",{|| XCON->(DbEval({|| AADD(aCols,{ XCON->TIPO, XCON->TOTGRU, XCON->NPERCENT, XCON->QTDPED, .F.})  },,,,,.T.))  })
	Elseif cTipo == "C"
		montaHeader("CondPag") 
		MsgRun("Processando Ranking por Cond.Pagamento, aguarde...","Ranking Faturamento",{|| XCON->(DbEval({|| AADD(aCols,{ XCON->TIPO, XCON->E4_DESCRI, XCON->TOTGRU, XCON->NPERCENT, XCON->QTDPED, .F.})  },,,,,.T.))  })
	Elseif cTipo == "F"
		montaHeader("Frete")  
		MsgRun("Processando Ranking por Tipo Frete, aguarde...","Ranking Faturamento",{|| XCON->(DbEval({|| AADD(aCols,{ iif(XCON->TIPO=='C','CIF', iif(XCON->TIPO=='F','FOB','  ')) , XCON->TOTGRU, XCON->NPERCENT, XCON->QTDPED, .F.})  },,,,,.T.)) })
	Endif

	oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

	AlignObject( oDlg, {oGet:oBrowse}, 1, 2, {040,100} )  

	XCON->(DbCloseArea("XCON"))

Return 

/*       
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlFrete บAutor  ณ Giane              บ Data ณ 11/11/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Sql da consulta por tipo de frete no caso de devolucoes    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/      
Static Function fSqlFrete(cQuery) 

	//metodo lusitano, pois com o join do SC5 o decode nao funcionou:
	cQuery += "      SELECT "  
	cQuery += "        XFRE.TIPO TIPO , XFRE.QTDPED, XFRE.TOTGRU "
	cQuery += "      FROM "
	cQuery += "      ( "
	cQuery += "       SELECT "    
	cQuery += "         C5_TPFRETE TIPO, "	
	cQuery += "         0 QTDPED, "	
	cQuery += "         SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) AS TOTGRU "     
	cQuery += "  	    FROM " + RetSqlName("SD1") + " SD1 "     
	cQuery += "     	  JOIN " + RetSqlName("SD2") + " SD2 ON "
	cQuery += "     	   SD2.D2_FILIAL = SD1.D1_FILIAL AND "
	cQuery += "          SD1.D1_NFORI = SD2.D2_DOC AND "
	cQuery += "      	   SD1.D1_SERIORI = SD2.D2_SERIE AND "  
	cQuery += "      	   SD1.D1_ITEMORI = SD2.D2_ITEM AND "	 
	cQuery += "          SD2.D_E_L_E_T_ = ' ' "        
	cQuery += "         JOIN " + RetSqlName("SF2") + " SF2 ON "
	cQuery += "          SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND "
	cQuery += "          SD1.D1_NFORI = SF2.F2_DOC AND "
	cQuery += "          SD1.D1_SERIORI = SF2.F2_SERIE AND "   
	cQuery += "          SF2.D_E_L_E_T_ = ' ' "	
	cQuery += "   	    JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "   	      SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cQuery += "    	      SD1.D1_COD = SB1.B1_COD AND "
	cQuery += "    	      SB1.D_E_L_E_T_ = ' ' "
	cQuery += "         JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "    	      SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
	cQuery += "           SD1.D1_FORNECE = SA1.A1_COD AND "
	cQuery += "           SD1.D1_LOJA = SA1.A1_LOJA AND "
	cQuery += "           SA1.D_E_L_E_T_ = ' ' " 
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
		cQuery += "		    JOIN " + RetSqlName("ACY") + " ACY ON "
		cQuery += "		      ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
		cQuery += "		      ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
		cQuery += "		      ACY.D_E_L_E_T_ = ' ' " 
	ENDIF
	cQuery += "         JOIN " + RetSqlName("SF4") + " SF4 ON "             
	cQuery += "           SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND " 
	cQuery += "           SF4.D_E_L_E_T_ = ' ' AND "
	cQuery += "           SD1.D1_TES = SF4.F4_CODIGO "   	    	
	cQuery += "         JOIN " + RetSqlName("SC5") + " SC5 ON "
	cQuery += "           SC5.D_E_L_E_T_ = ' ' AND "
	cQuery += "           SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " 
	cQuery += "           SC5.C5_NUM = SD2.D2_PEDIDO "				
	cQuery += "       WHERE "
	cQuery += "         SD1.D1_DTDIGIT BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
	cQuery += "         SD1.D1_FORNECE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
	cQuery += "         SD1.D1_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "         SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery += "         SD1.D_E_L_E_T_ = ' ' AND "   
	//	cQuery += "         SA1.A1_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' AND "  
	cQuery += "         SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	  
	cQuery += "         SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "   	
	cQuery += "         SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
	cQuery += "         SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " 
	cQuery += "         SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' AND "
	cQuery += "         SD1.D1_TIPO = 'D'  "
	cQuery += "         AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
		cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
	ENDIF
	If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
		cQuery += "       AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	Endif

	If !Empty(cMVPAR15)  
		cQuery += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
		If lGerente
			cQuery += "     AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif
	Endif

	cQuery += "       GROUP BY C5_TPFRETE "    
	cQuery += "   ) XFRE "

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlTot   บAutor  ณ Giane              บ Data ณ 28/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Sql calcula valor total faturado para os parametros        บฑฑ
ฑฑบ          ณ digitados pelo usuario                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fSqlTot(cTipo2)    
	Local cQuery := ""     
	Local cAlias := "XTOT" 

	nTotGer := 0      
	nQtdLiq := 0
	nTotLiq := 0   
	nQtdPen := 0
	nTotPen := 0
	nQtdCanc:= 0
	nTotCanc:= 0
	nQtdDev := 0
	nTotDev := 0

	If Select("XTOT") > 0
		XTOT->(DbCloseArea("XTOT"))
	Endif

	//If cMVPAR18 <> 2  //calcula total geral faturado
	cQuery := "SELECT " + CHR(13) + CHR(10)		  
	cQuery += "  COUNT(DISTINCT SD2.D2_PEDIDO) AS TOTPED, " + CHR(13) + CHR(10)		  
	cQuery += "  SUM(SD2.D2_VALBRUT) AS TOTGER " + CHR(13) + CHR(10)		  
	cQuery += "FROM " + RetSqlName("SD2") + " SD2 "  + CHR(13) + CHR(10)		  
	cQuery += "  JOIN " + RetSqlName("SF2") + " SF2 ON " + CHR(13) + CHR(10)		  
	cQuery += "    SF2.F2_FILIAL = SD2.D2_FILIAL AND " + CHR(13) + CHR(10)		  
	cQuery += "    SD2.D2_DOC = SF2.F2_DOC AND " + CHR(13) + CHR(10)		  
	cQuery += "    SD2.D2_SERIE = SF2.F2_SERIE AND " + CHR(13) + CHR(10)		  
	cQuery += "    SF2.D_E_L_E_T_ = ' ' "	+ CHR(13) + CHR(10)		  
	cQuery += "  JOIN " + RetSqlName("SA1") + " SA1 ON " + CHR(13) + CHR(10)		  
	cQuery += "    SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND " + CHR(13) + CHR(10)		  
	cQuery += "    SA1.A1_COD = SD2.D2_CLIENTE AND " + CHR(13) + CHR(10)		  
	cQuery += "    SA1.A1_LOJA = SD2.D2_LOJA AND " + CHR(13) + CHR(10)		  
	cQuery += "    SA1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ') .OR. cTipo2 == 'Sup'
		cQuery += "  JOIN " + RetSqlName("ACY") + " ACY ON "+ CHR(13) + CHR(10)
		cQuery += "    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "+ CHR(13) + CHR(10)
		cQuery += "    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "+ CHR(13) + CHR(10)
		cQuery += "    ACY.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
	ENDIF
	cQuery += "  JOIN "+RetSQLName("SB1")+" SB1 ON " + CHR(13) + CHR(10)		  
	cQuery += "    SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND " + CHR(13) + CHR(10)		  
	cQuery += "    SB1.B1_COD = SD2.D2_COD AND " + CHR(13) + CHR(10)		  
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "  + CHR(13) + CHR(10)		  
	cQuery += "  JOIN " + RetSqlName("SF4") + " SF4 ON "  + CHR(13) + CHR(10)		  
	cQuery += "    SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND " + CHR(13) + CHR(10)		  
	cQuery += "    SD2.D2_TES = SF4.F4_CODIGO AND " + CHR(13) + CHR(10)		  
	cQuery += "    SF4.D_E_L_E_T_ = ' '  " + CHR(13) + CHR(10)		  
	cQuery += "  JOIN " + RetSqlName("SC5") + " SC5 ON " + CHR(13) + CHR(10)
	cQuery += "    SC5.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)
	cQuery += "    SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " + CHR(13) + CHR(10)
	cQuery += "    SC5.C5_NUM = SD2.D2_PEDIDO " + CHR(13) + CHR(10)
	cQuery += "WHERE " + CHR(13) + CHR(10)		  
	cQuery += "  SD2.D2_EMISSAO BETWEEN '" + dtos(cMVPAR01) + "' AND '" + dtos(cMVPAR02) + "' AND " + CHR(13) + CHR(10)		  
	cQuery += "  SD2.D2_CLIENTE BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND " + CHR(13) + CHR(10)		  
	cQuery += "  SD2.D2_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND " + CHR(13) + CHR(10)		  
	cQuery += "  SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND " + CHR(13) + CHR(10)		  
	cQuery += "  SD2.D_E_L_E_T_ = ' ' AND " + CHR(13) + CHR(10)		  
	cQuery += "  SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND " + CHR(13) + CHR(10)		  
	cQuery += "  SF2.F2_VEND1 BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " + CHR(13) + CHR(10)		  
	cQuery += "  SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  + CHR(13) + CHR(10)		  
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' AND " + CHR(13) + CHR(10)		  
	cQuery += "  SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' " + CHR(13) + CHR(10)		  
	cQuery += "  AND SD2.D2_TIPO IN ('N','C','I','P') "  + CHR(13) + CHR(10)		  
	cQuery += "  AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "  + CHR(13) + CHR(10)
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
		cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
	ENDIF
	If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
		cQuery += "  AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	Endif

	If !Empty(cMVPAR15)

		/* Parametro Seg.Responsavel preenchido: 
		1) Vendedor ==> nao tem direito a ver nenhuma venda ref.segmento responsavel, ou seja, ignorar o preenchimento deste parametro
		e filtrar apenas o grupo de vendas de/ate verificando quais grupos de vendas ele pode ver(regra de confidencialidade) 
		2) Gerente ==> filtrar o seg.responsavel que ele digitou no parametro e verificar se este segmento eh da responsabilidade dele,
		filtrando tambem o grupo de vendas de/ate(sem verificar a regra de confidencialidade do grupo de vendas)
		Exemplo 1 - seg.responsavel eh da responsabilidade do gerente, entao trazer todas as vendas cujo produto seja deste
		seg.responsavel e o grupo de vendas esteja entre os parametros de/ate (mesmo que grupo de vendas informado nao
		perten็a a sua equipe de vendas)
		Exemplo 2 - seg.responsavel nao eh da responsabilidade do gerente(gerente digitou errado), entao a consulta nao retornara
		nada.    
		3) Adm.Vendas ==> filtrar o seg.responsavel digitado e o grupo de vendas de/ate, sem nenhuma regra de confidencialidade
		*/    
		cQuery += "  AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
		If lGerente
			cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif
	Endif

	MsgRun("Processando parโmetros, aguarde...","Ranking de Faturamento", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })    

	dbSelectArea(cAlias)  


	nTotGer := (cAlias)->TOTGER		
	nQtdLiq := (cAlias)->TOTPED  
	nTotLiq := (cAlias)->TOTGER	

	dbCloseArea(cAlias)

	cQuery := "SELECT " 
	cQuery += "  COUNT(DISTINCT SC6.C6_NUM) AS TOTPED, "   
	cQuery += "  SUM(SC6.C6_VALOR) AS TOTGER " 
	cQuery += "FROM "
	cQuery +=    RetSqlName("SC6") + " SC6 "
	cQuery += "JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "  SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
	cQuery += "  SA1.A1_COD = SC6.C6_CLI AND "
	cQuery += "  SA1.A1_LOJA = SC6.C6_LOJA AND "
	cQuery += "  SA1.D_E_L_E_T_ = ' ' "  
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ') .OR. cTipo2 == 'Sup'
		cQuery += "JOIN " + RetSqlName("ACY") + " ACY ON "
		cQuery += "  ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
		cQuery += "  ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
		cQuery += "  ACY.D_E_L_E_T_ = ' ' " 
	ENDIF
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "  SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "  SB1.B1_COD = SC6.C6_PRODUTO AND "
	cQuery += "  SB1.D_E_L_E_T_ = ' ' "
	cQuery += "JOIN " + RetSqlName("SC5") + " SC5 ON "
	cQuery += "  SC5.D_E_L_E_T_ = ' ' AND "
	cQuery += "  SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND "
	cQuery += "  SC5.C5_NUM = SC6.C6_NUM "
	cQuery += "JOIN " + RetSqlName("SF4") + " SF4 ON "  
	cQuery += "  SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
	cQuery += "  SC6.C6_TES = SF4.F4_CODIGO AND "  
	cQuery += "  SF4.D_E_L_E_T_ = ' ' " 	 		   
	cQuery += "WHERE "
	cQuery += "  SC6.C6_NOTA = '         ' AND "
	cQuery += "  SC6.C6_SERIE = '  ' AND "
	cQuery += "  SC5.C5_X_CANC = ' ' AND "
	cQuery += "  SC6.C6_ENTREG BETWEEN '"+ dtos(cMVPAR01) + "' AND '" + dtos(cMVPAR02) + "' AND "   
	cQuery += "  SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "    
	cQuery += "  SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "  SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
	cQuery += "  SC6.D_E_L_E_T_ = ' ' AND "
	//cQuery += "  SA1.A1_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' AND "   
	cQuery += "  SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "     
	cQuery += "  SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " 
	cQuery += "  SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' "  
	cQuery += "  AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "	
	cQuery += "  AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
		cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
	ENDIF
	If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
		cQuery += "  AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	Endif

	If !Empty(cMVPAR15)  
		cQuery += "  AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
		If lGerente
			cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif
	Endif           

	MsgRun("Processando parโmetros, aguarde...","Ranking de Faturamento", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })    

	dbSelectArea(cAlias)  

	nTotGer += (cAlias)->TOTGER		
	nQtdPen := (cAlias)->TOTPED
	nTotPen := (cAlias)->TOTGER	

	dbCloseArea(cAlias)

	//Endif

	/*************************************************************************************************
	/ CALCULA TOTAIS DE PEDIDOS CANCELADOS:                                                           
	*************************************************************************************************/
	cQuery := "SELECT "
	cQuery += "  COUNT(DISTINCT SC6.C6_NUM) AS TOTPED, "
	cQuery += "  SUM(SC6.C6_VALOR) AS TOTCAN "
	cQuery += "FROM "
	cQuery +=    RetSqlName("SC6") + " SC6 "
	cQuery += "JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "  SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "
	cQuery += "  SA1.A1_COD = SC6.C6_CLI AND "
	cQuery += "  SA1.A1_LOJA = SC6.C6_LOJA AND "
	cQuery += "  SA1.D_E_L_E_T_ = ' ' "
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ') .OR. cTipo2 == 'Sup'
		cQuery += "JOIN " + RetSqlName("ACY") + " ACY ON "
		cQuery += "  ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
		cQuery += "  ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
		cQuery += "  ACY.D_E_L_E_T_ = ' ' "
	ENDIF
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "  SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "  SB1.B1_COD = SC6.C6_PRODUTO AND "
	cQuery += "  SB1.D_E_L_E_T_ = ' ' "
	cQuery += "JOIN " + RetSqlName("SC5") + " SC5 ON "
	cQuery += "  SC5.D_E_L_E_T_ = ' ' AND "
	cQuery += "  SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND "
	cQuery += "  SC5.C5_NUM = SC6.C6_NUM "
	cQuery += "JOIN " + RetSqlName("SF4") + " SF4 ON "  
	cQuery += "  SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
	cQuery += "  SC6.C6_TES = SF4.F4_CODIGO AND "  
	cQuery += "  SF4.D_E_L_E_T_ = ' ' " 	 		
	cQuery += "WHERE "
	cQuery += "  SC6.C6_NOTA = '         ' AND "
	cQuery += "  SC6.C6_SERIE = '  ' AND "
	cQuery += "  SC5.C5_X_CANC <> ' ' AND "
	cQuery += "  SC6.C6_ENTREG BETWEEN '"+ dtos(cMVPAR01) + "' AND '" + dtos(cMVPAR02) + "' AND "
	cQuery += "  SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "
	cQuery += "  SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "  SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
	cQuery += "  SC6.D_E_L_E_T_ = ' ' AND "  
	cQuery += "  SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  
	cQuery += "  SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND "
	cQuery += "  SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' "   
	cQuery += "  AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "	
	cQuery += "  AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' " 
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
		cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
	ENDIF
	If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
		cQuery += "  AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
	Endif

	If !Empty(cMVPAR15)  
		cQuery += "  AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
		If lGerente
			cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif
	Endif 


	MsgRun("Processando parโmetros, aguarde...","Ranking de Faturamento", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })

	dbSelectArea(cAlias)

	nTotGer += (cAlias)->TOTCAN		
	nQtdCanc := (cAlias)->TOTPED
	nTotCanc := (cAlias)->TOTCAN

	dbCloseArea(cAlias)


	/*************************************************************************************************
	/ CALCULA TOTAIS DE PEDIDOS DEVOLVIDOS:                                                           
	*************************************************************************************************/

	cQuery := "SELECT "
	cQuery += "  COUNT(DISTINCT SD2.D2_PEDIDO) AS TOTPED, "
	cQuery += "  SUM(SD1.D1_TOTAL+SD1.D1_VALIPI) AS TOTDEV "   
	cQuery += fSqlDev()

	//cQuery := ChangeQuery(cQuery)

	MsgRun("Processando parโmetros, aguarde...","Ranking de Faturamento", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })

	nTotGer += (cAlias)->TOTDEV		
	nQtdDev := (cAlias)->TOTPED
	nTotDev := (cAlias)->TOTDEV    
	nTotLiq -= (cAlias)->TOTDEV	

	dbCloseArea(cAlias)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณItensClienบAutor  ณ Giane              บ Data ณ 04/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta consulta dos itens do cliente posicionado no grid    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ItensCliente()

	Local cQuery := ""    
	Local nPosCli	  := GDFieldPos( "CLIENTE", oGet:aHeader )
	Local nPosLoja	:= GDFieldPos( "LOJA", oGet:aHeader )
	Local nPosNome	:= GDFieldPos( "A1_NREDUZ", oGet:aHeader )
	Local nLinha	  := oGet:oBrowse:nAt
	Local cCliente  := oGet:ACOLS[nLinha,nPosCli] 
	Local cLoja     := oGet:ACOLS[nLinha,nPosLoja] 
	Local cNome     := oGet:ACOLS[nLinha,nPosNome] 

	Local oDlg2
	Local oGet2  
	Local aHeader := {}
	Local aCols   := {}  
	Local bExcel  := {|| }
	Local aButtons := {}

	cQuery := "SELECT "
	cQuery += "  XTMP.GRUPROD, SBM.BM_DESC, XTMP.TOTGRU, XTMP.NPERCENT, XTMP.QTDPED "
	cQuery += "FROM "
	cQuery += "   ( "

	If cMVPAR18 == 3 //fazer um union all, pois deve somar os faturados com os pendentes:  
		cQuery += "SELECT "
		cQuery += "  XUNI.GRUPROD, SUM(XUNI.QTDPED) QTDPED, SUM(XUNI.TOTGRU) TOTGRU, "
		cQuery += "  ( SUM(XUNI.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotGer,16,2) )+ " AS NPERCENT " 
		cQuery += "FROM "
		cQuery += "   ( "
	Endif

	If cMVPAR18 <> 1 //pedidos nao faturados ainda  
		cQuery += "   SELECT "  
		cQuery += "      SB1.B1_GRUPO GRUPROD, "
		cQuery += "      COUNT(DISTINCT C6_NUM) QTDPED, "
		cQuery += "      SUM(SC6.C6_VALOR) AS TOTGRU " 
		if cMVPAR18 == 2   
			cQuery += "   ,( SUM(SC6.C6_VALOR) * 100 ) / " + ALLTRIM(STR(nTotPen,16,2) )+ " AS NPERCENT "  
		Endif
		cQuery += "    FROM " + RetSqlName("SC6") + " SC6 "  
		cQuery += "      JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += "        SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
		cQuery += "        SA1.A1_COD = SC6.C6_CLI AND "
		cQuery += "        SA1.A1_LOJA = SC6.C6_LOJA AND "
		cQuery += "        SA1.D_E_L_E_T_ = ' ' " 
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "		  JOIN " + RetSqlName("ACY") + " ACY ON "
			cQuery += "		    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
			cQuery += "		    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
			cQuery += "		    ACY.D_E_L_E_T_ = ' ' " 
		ENDIF
		cQuery += "      JOIN "+RetSQLName("SB1")+" SB1 ON "
		cQuery += "        SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "    
		cQuery += "        SB1.B1_COD = SC6.C6_PRODUTO AND "      	
		cQuery += "        SB1.D_E_L_E_T_ = ' ' "  	 
		cQuery += "      JOIN " + RetSqlName("SC5") + " SC5 ON "
		cQuery += "        SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "        SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " 
		cQuery += "        SC5.C5_NUM = SC6.C6_NUM "     
		cQuery += "      JOIN " + RetSqlName("SF4") + " SF4 ON "  
		cQuery += "         SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
		cQuery += "         SC6.C6_TES = SF4.F4_CODIGO AND "  
		cQuery += "         SF4.D_E_L_E_T_ = ' ' " 	 		  
		cQuery += "    WHERE "   
		cQuery += "    	 SC6.C6_NOTA = '         ' AND SC6.C6_SERIE = '  '  AND "
		cQuery += "      SC5.C5_X_CANC = ' '  AND "   
		cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "       
		cQuery += "      SC6.C6_ENTREG BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
		cQuery += "      SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
		cQuery += "      SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
		cQuery += "      SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
		//	cQuery += "      SA1.A1_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' AND "      
		cQuery += "      SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	
		cQuery += "      SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " 
		cQuery += "      SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
		cQuery += "      SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' "      
		cQuery += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "		
		cQuery += "      AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "     AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "     AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += "     AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif	

		cQuery += "      AND SC6.C6_CLI = '" + cCliente + "' AND SC6.C6_LOJA = '" + cLoja + "' "  
		cQuery += "    GROUP BY B1_GRUPO "  

	Endif

	If cMVPAR18  == 3
		cQuery += "UNION ALL "
	endif

	If cMVPAR18 <> 2 //pedidos ja faturados 

		cQuery += "   SELECT "
		cQuery += "     XFAT.GRUPROD, SUM(XFAT.QTDPED) QTDPED,  "   
		cQuery += "     SUM(XFAT.TOTGRU) TOTGRU "    
		If cMVPAR18 == 1 
			cQuery += "  ,( SUM(XFAT.TOTGRU) * 100 ) / " + ALLTRIM(STR(nTotLiq,16,2) )+ " AS NPERCENT "     	   
		Endif
		cQuery += "   FROM "	
		cQuery += "   ( "         

		cQuery += "   SELECT "  
		cQuery += "      SB1.B1_GRUPO GRUPROD, COUNT(DISTINCT D2_PEDIDO) QTDPED, "
		cQuery += "      SUM(SD2.D2_VALBRUT) AS TOTGRU " 
		cQuery +=  fSqlFat()     
		cQuery += "     AND SD2.D2_CLIENTE = '" + cCliente + "' AND SD2.D2_LOJA = '" + cLoja + "' "  		
		cQuery += "   GROUP BY B1_GRUPO "    

		//devolucoes:  
		cQuery += " UNION ALL "
		cQuery += "   SELECT "  
		cQuery += "      SB1.B1_GRUPO GRUPROD, 0 QTDPED, "
		cQuery += "      SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) AS TOTGRU " 
		cQuery +=  fSqlDev()     
		cQuery += "     AND SD1.D1_FORNECE = '" + cCliente + "' AND SD1.D1_LOJA = '" + cLoja + "' "  		
		cQuery += "   GROUP BY B1_GRUPO "  

		cQuery += "    ) XFAT "
		cQuery += "   GROUP BY GRUPROD  "       

	Endif                                  

	If cMVPAR18 == 3     
		cQuery += "  ) XUNI "
		cQuery += "GROUP BY GRUPROD "            
	Endif    

	cQuery += "  ) XTMP "
	cQuery += "  JOIN " + RetSqlName("SBM")+ " SBM ON "
	cQuery += "    XTMP.GRUPROD = SBM.BM_GRUPO AND "
	cQuery += "    SBM.BM_FILIAL = '" + xFilial("SBM") + "' AND "  
	cQuery += "    SBM.D_E_L_E_T_ = ' ' "     
	cQuery += "ORDER BY TOTGRU DESC "   

	AAdd(aHeader,{"Grupo Prod", "GRUPROD" ,"" ,TamSX3("B1_GRUPO")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Descri็ใo", "BM_DESC" ,"" ,TamSX3("BM_DESC")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Valor Total"  , "TOTGRU"     ,"@E 9,999,999,999.99" ,16,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"     %" , "NPERCENT"   ,"@E 999.99" ,05,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"Qtde.Pedidos" , "QTDPED"     ,"@E 9,999"  ,04,0,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 

	If Select("XITE") > 0
		XITE->(DbCloseArea("XITE"))
	Endif 

	//MEMOWRITE('C:\CITENSCLI.SQL',CQUERY)

	//cQuery := ChangeQuery(cQuery)   

	//TcQuery cQuery ALIAS "XITE" NEW   
	MsgRun("Montando consulta, aguarde...","Itens do Cliente", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"XITE",.T.,.f.) })   

	TcSetField("XITE",'QTDPED','N',4,0)
	TcSetField("XITE",'NPERCENT','N',5,2)
	TcSetField("XITE",'TOTGRU','N',16,2)

	MsgRun("Processando Itens Cliente, aguarde...","Ranking Por Cliente",;
	{|| XITE->(DbEval({|| AADD(aCols,{ XITE->GRUPROD, XITE->BM_DESC, XITE->TOTGRU, XITE->NPERCENT, XITE->QTDPED,.F.})  },,,,,.T.)) })  

	DEFINE MSDIALOG oDlg2 TITLE 'Itens do Cliente: ' + cCliente + ' Loja: ' + cLoja + '  ' + cNome From 20,01 to 300,700  of oDlg PIXEL 

	bExcel := {||DlgToExcel( {{"ARRAY","",{"Cliente","Loja","Nome Fantasia"},{{cCliente, cLoja, cNome}}},{"GETDADOS","Itens Cliente",oGet2:aHeader,oGet2:aCols} }) }  

	AAdd(aButtons,{PmsBExcel()[1], bExcel, "Excel", "Excel" } ) 

	oGet2 := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg2,@aHeader,@aCols)

	AlignObject( oDlg2, {oGet2:oBrowse}, 1, 2, {040,050} )  

	ACTIVATE MSDIALOG oDlg2 CENTER ON INIT (EnchoiceBar(oDlg2,{|| oDlg2:End()},{|| oDlg2:End()},,aButtons)  )  

	XITE->(DbCloseArea("XITE"))

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณItensProduบAutor  ณ Giane              บ Data ณ 06/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta consulta dos itens do grupo de produto posicionado   บฑฑ
ฑฑบ          ณ no grid                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ItensProduto()

	Local cQuery := ""    
	Local nPosGru	:= GDFieldPos( "GRUPROD", oGet:aHeader )
	Local nPosDesc:= GDFieldPos( "BM_DESC", oGet:aHeader )

	Local nLinha	:= oGet:oBrowse:nAt
	Local cGrupo  := oGet:ACOLS[nLinha,nPosGru] 
	Local cDescr  := oGet:ACOLS[nLinha,nPosDesc] 

	Local oDlg2
	Local oGet2  
	Local aHeader := {}
	Local aCols   := {}
	Local aButtons := {}
	Local bExcel   := {|| }

	cQuery := "SELECT "
	cQuery += "  XTMP.CLIENTE, XTMP.LOJA, XSA1.A1_NREDUZ, XTMP.TOTCLI, XTMP.NPERCENT, XTMP.QTDPRO, XTMP.QTDPED, XSA1.A1_VEND, SA3.A3_NREDUZ, "
	cQuery += "  XSA1.A1_VENDINT, XSA3.A3_NREDUZ AS NOMVENDI, XTMP.C5_GRPVEN, ACY.ACY_DESCRI "      

	If cMVPAR19 <> 2
		cQuery += ", SX5.X5_DESCRI AS DESCRI " 
	Endif   
	cQuery += "FROM "
	cQuery += "   ( "

	If cMVPAR18 == 3 //fazer um union all, pois deve somar os faturados com os pendentes:  
		cQuery += "SELECT "
		cQuery += "  XUNI.CLIENTE, XUNI.LOJA,  XUNI.C5_GRPVEN, SUM(XUNI.QTDPED) QTDPED, SUM(XUNI.TOTCLI) TOTCLI, SUM(XUNI.QTDPRO) QTDPRO, "
		cQuery += "  ( SUM(XUNI.TOTCLI) * 100 ) / " + ALLTRIM(STR(nTotGer,16,2) )+ " AS NPERCENT " 
		cQuery += "FROM "
		cQuery += "   ( "
	Endif

	If cMVPAR18 <> 1 //pedidos nao faturados ainda  
		cQuery += "   SELECT "  
		cQuery += "      SC6.C6_CLI CLIENTE, SC6.C6_LOJA LOJA, SC5.C5_GRPVEN, "
		cQuery += "      COUNT(DISTINCT C6_NUM) QTDPED, "
		cQuery += "      SUM(SC6.C6_QTDVEN) AS QTDPRO, "	
		cQuery += "      SUM(SC6.C6_VALOR) AS TOTCLI " 
		if cMVPAR18 == 2   
			cQuery += "   ,( SUM(SC6.C6_VALOR) * 100 ) / " + ALLTRIM(STR(nTotPen,16,2) )+ " AS NPERCENT "  
		Endif
		cQuery += "    FROM " + RetSqlName("SC6") + " SC6 "  
		cQuery += "      JOIN " + RetSqlName("SA1") + " SA1 ON "
		cQuery += "        SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
		cQuery += "        SA1.A1_COD = SC6.C6_CLI AND "
		cQuery += "        SA1.A1_LOJA = SC6.C6_LOJA AND "
		cQuery += "        SA1.D_E_L_E_T_ = ' ' " 
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "		  JOIN " + RetSqlName("ACY") + " ACY ON "
			cQuery += "		    ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
			cQuery += "		    ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND "
			cQuery += "		    ACY.D_E_L_E_T_ = ' ' "
		ENDIF
		cQuery += "      JOIN "+RetSQLName("SB1")+" SB1 ON "
		cQuery += "        SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "    
		cQuery += "        SB1.B1_COD = SC6.C6_PRODUTO AND "      	
		cQuery += "        SB1.D_E_L_E_T_ = ' ' "  	 
		cQuery += "      JOIN " + RetSqlName("SC5") + " SC5 ON "
		cQuery += "        SC5.D_E_L_E_T_ = ' ' AND "
		cQuery += "        SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND " 
		cQuery += "        SC5.C5_NUM = SC6.C6_NUM "
		cQuery += "      JOIN " + RetSqlName("SF4") + " SF4 ON "  
		cQuery += "         SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND "        
		cQuery += "         SC6.C6_TES = SF4.F4_CODIGO AND "  
		cQuery += "         SF4.D_E_L_E_T_ = ' ' " 	 		  
		cQuery += "    WHERE "   
		cQuery += "  	   SC6.C6_NOTA = '         ' AND SC6.C6_SERIE = '  '  AND "
		cQuery += "      SC5.C5_X_CANC = ' '  AND "   
		cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "       
		cQuery += "      SC6.C6_ENTREG BETWEEN '" + dtos(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "   
		cQuery += "      SC6.C6_CLI BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR05 + "' AND "   
		cQuery += "      SC6.C6_LOJA BETWEEN '" + cMVPAR04 + "' AND '" + cMVPAR06 + "' AND "
		cQuery += "      SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND "
		//	cQuery += "      SA1.A1_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' AND "    
		cQuery += "      SA1.A1_SATIV1 BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "  	
		cQuery += "      SA1.A1_VEND BETWEEN '" + cMVPAR11 + "' AND '" + cMVPAR12 + "' AND " 
		cQuery += "      SA1.A1_VENDINT BETWEEN '" + cMVPAR13 + "' AND '" + cMVPAR14 + "' AND "  
		cQuery += "      SB1.B1_GRUPO BETWEEN '" + cMVPAR16 + "' AND '" + cMVPAR17 + "' " 	
		cQuery += "      AND SB1.B1_GRUPO = '" + cGrupo + "' "   
		cQuery += "      AND SF4.F4_DUPLIC = 'S' AND SF4.F4_ISS <> 'S' "		
		cQuery += "      AND SC5.C5_GRPVEN BETWEEN '" + cMVPAR07 + "' AND '" + cMVPAR08 + "' "
		IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
			cQuery += "         AND ACY.ACY_GRPSUP >= '" + cMVPAR20 + "' AND ACY.ACY_GRPSUP <= '" + cMVPAR21 + "' "	 + CHR(13) + CHR(10)
		ENDIF
		If lVendedor .Or. (lGerente .And. Empty(cMVPAR15))
			cQuery += "    AND SC5.C5_GRPVEN IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
		Endif

		If !Empty(cMVPAR15)  
			cQuery += "  AND SB1.B1_SEGMENT = '" + cMVPAR15 + "' " + CHR(13) + CHR(10) 		
			If lGerente
				cQuery += "  AND SB1.B1_SEGMENT IN " + FormatIn(cGrpAcesso,"/") + CHR(13) + CHR(10)
			Endif
		Endif
		cQuery += "    GROUP BY C6_CLI, C6_LOJA, C5_GRPVEN "  

	Endif

	If cMVPAR18  == 3
		cQuery += "UNION ALL "
	endif

	If cMVPAR18 <> 2 //pedidos ja faturados   
		cQuery += "   SELECT "
		cQuery += "     XFAT.CLIENTE, XFAT.LOJA, XFAT.C5_GRPVEN, SUM(XFAT.QTDPED) QTDPED,  "   
		cQuery += "     SUM(XFAT.QTDPRO) QTDPRO, SUM(XFAT.TOTCLI) TOTCLI "    
		If cMVPAR18 == 1 
			cQuery += "  ,( SUM(XFAT.TOTCLI) * 100 ) / " + ALLTRIM(STR(nTotLiq,16,2) )+ " AS NPERCENT "     	   
		Endif
		cQuery += "   FROM "	
		cQuery += "   ( "         

		cQuery += "   SELECT "  
		cQuery += "      SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, SC5.C5_GRPVEN, COUNT(DISTINCT D2_PEDIDO) QTDPED, "
		cQuery += "      SUM(SD2.D2_QUANT) AS QTDPRO,
		cQuery += "      SUM(SD2.D2_VALBRUT) AS TOTCLI " 
		cQuery += fSqlFat()
		cQuery += "      AND SB1.B1_GRUPO = '" + cGrupo + "' "	
		cQuery += "    GROUP BY D2_CLIENTE, D2_LOJA, C5_GRPVEN "      

		cQuery += " UNION ALL "  
		cQuery += "   SELECT "  
		cQuery += "      SD1.D1_FORNECE CLIENTE, SD1.D1_LOJA LOJA, SC5.C5_GRPVEN, 0 QTDPED, "
		cQuery += "      SUM(SD1.D1_QUANT * -1) AS QTDPRO,
		cQuery += "      SUM((SD1.D1_TOTAL + SD1.D1_VALIPI) * -1) AS TOTCLI " 
		cQuery += fSqlDev()
		cQuery += "      AND SB1.B1_GRUPO = '" + cGrupo + "' "	
		cQuery += "    GROUP BY D1_FORNECE, D1_LOJA, C5_GRPVEN "  

		cQuery += "   ) XFAT "
		cQuery += "   GROUP BY CLIENTE, LOJA, C5_GRPVEN  " 	

	Endif                                  

	If cMVPAR18 == 3     
		cQuery += "  ) XUNI "
		cQuery += "GROUP BY CLIENTE, LOJA, C5_GRPVEN "            
	Endif    

	cQuery += "  ) XTMP "
	cQuery += "  JOIN " + RetSqlName("SA1")+ " XSA1 ON "
	cQuery += "    XTMP.CLIENTE = XSA1.A1_COD AND "
	cQuery += "    XTMP.LOJA = XSA1.A1_LOJA AND "
	cQuery += "    XSA1.A1_FILIAL = '" + xFilial("SA1") + "' AND "  
	cQuery += "    XSA1.D_E_L_E_T_ = ' ' " 
	IF (!EMPTY(cMVPAR20) .AND. cMVPAR21 == 'ZZZZZZ') .OR. (!EMPTY(cMVPAR20) .AND. cMVPAR21 <> 'ZZZZZZ')
		cQuery += "	 JOIN " + RetSqlName("ACY") + " ACY ON "
		cQuery += "	   ACY.ACY_FILIAL = '"+xFilial("ACY")+"' AND "
		cQuery += "	   ACY.ACY_GRPVEN = XSA1.A1_GRPVEN AND "
		cQuery += "	   ACY.D_E_L_E_T_ = ' ' " 
	ENDIF
	cQuery += "  LEFT JOIN " + RetSqlName("SA3")+ " SA3 ON "   
	cQuery += "    SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND " 
	cQuery += "    SA3.D_E_L_E_T_ = ' ' AND "   
	cQuery += "    SA3.A3_COD = XSA1.A1_VEND "        
	cQuery += "  LEFT JOIN " + RetSqlName("SA3")+ " XSA3 ON "   
	cQuery += "    XSA3.A3_FILIAL = '" + xFilial("SA3") + "' AND " 
	cQuery += "    XSA3.D_E_L_E_T_ = ' ' AND "   
	cQuery += "    XSA3.A3_COD = XSA1.A1_VENDINT "  
	cQuery += "  LEFT JOIN " + RetSqlName("ACY") + " ACY ON "  
	cQuery += "    ACY.ACY_FILIAL = '" + xFilial("ACY") + "' AND "
	cQuery += "    ACY.ACY_GRPVEN = XTMP.C5_GRPVEN AND "
	cQuery += "    ACY.D_E_L_E_T_ = ' ' "      
	cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " SX5 ON "
	cQuery += "    SX5.X5_FILIAL = '" + xFilial("SX5") + "' AND "    
	cQuery += "    SX5.X5_TABELA = 'T3' AND "
	cQuery += "    SX5.X5_CHAVE = XSA1.A1_SATIV1 AND "
	cQuery += "    SX5.D_E_L_E_T_ = ' ' "    
	cQuery += "ORDER BY TOTCLI DESC "         

	If Select("XITE") > 0
		XITE->(DbCloseArea("XITE"))
	Endif                 

	AAdd(aHeader,{"Cliente"      , "CLIENTE" ,"" ,TamSX3("D2_CLIENTE")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Loja"         , "LOJA"    ,"" ,TamSX3("D2_LOJA")[1]   ,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"Nome Fantasia", "A1_NREDUZ"  ,"" ,TamSX3("A1_NREDUZ")[1] ,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})  
	AAdd(aHeader,{"Valor Total"  , "TOTCLI"     ,"@E 9,999,999,999.99" ,16,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"          % " , "NPERCENT"   ,"@E 999.99" ,05,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"Qtde.Vendida" , "QTDPRO"     ,"@E 9,999,999,999.99" ,16,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"Qtde.Pedidos" , "QTDPED"     ,"@E 9,999"  ,04,0,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"Vendedor"     , "A1_VEND"    ,"" ,TamSX3("A1_VEND")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"Nome"         , "A3_NREDUZ"  ,"" ,TamSX3("A3_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Vendedor Int.", "A1_VENDINT" ,"" ,TamSX3("A1_VENDINT")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
	AAdd(aHeader,{"Nome"         , "NOMVENDI"   ,"" ,TamSX3("A3_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})  
	AAdd(aHeader,{"Grupo Vendas" , "ACY_DESCRI" ,"" ,TamSX3("ACY_DESCRI")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
	If cMVPAR19 <> 2
		AAdd(aHeader,{"Segmento Vendas" , "DESCRI"  ,"" ,TamSX3("ACY_DESCRI")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})  
	endif 

	//MEMOWRITE('C:\CITENSPRO.SQL',CQUERY)

	//cQuery := ChangeQuery(cQuery)   

	//TcQuery cQuery ALIAS "XITE" NEW      
	MsgRun("Montando consulta, aguarde...","Itens do Grupo Produto", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"XITE",.T.,.f.) })   

	TcSetField("XITE",'QTDPED','N',4,0)
	TcSetField("XITE",'NPERCENT','N',5,2)
	TcSetField("XITE",'TOTCLI','N',16,2)

	If cMVPAR19 <> 2
		MsgRun("Processando Ranking por Cliente, aguarde...","Ranking Faturamento",{||	XITE->(DbEval({|| AADD(aCols,{ XITE->CLIENTE, XITE->LOJA, XITE->A1_NREDUZ, XITE->TOTCLI, XITE->NPERCENT, XITE->QTDPRO, XITE->QTDPED,XITE->A1_VEND, XITE->A3_NREDUZ, XITE->A1_VENDINT, XITE->NOMVENDI, XITE->ACY_DESCRI,XITE->DESCRI, .F.})  },,,,,.T.)) })  
	Else 
		MsgRun("Processando Ranking por Cliente, aguarde...","Ranking Faturamento",{||	XITE->(DbEval({|| AADD(aCols,{ XITE->CLIENTE, XITE->LOJA, XITE->A1_NREDUZ, XITE->TOTCLI, XITE->NPERCENT, XITE->QTDPRO, XITE->QTDPED,XITE->A1_VEND, XITE->A3_NREDUZ, XITE->A1_VENDINT, XITE->NOMVENDI, XITE->ACY_DESCRI, .F.})  },,,,,.T.)) })    
	Endif

	DEFINE MSDIALOG oDlg2 TITLE 'Itens do Grupo Produto: ' + cGrupo + "  " + cDescr From 20,01 to 300,700  of oDlg PIXEL 

	bExcel := {||DlgToExcel( {{"ARRAY","",{"Grupo Produto","Descri็ใo"},{{cGrupo, cDescr}}},{"GETDADOS","Itens Grupo Produto",oGet2:aHeader,oGet2:aCols} }) }  

	AAdd(aButtons,{PmsBExcel()[1], bExcel, "Excel", "Excel" } ) 

	oGet2 := MsNewGetDados():New( 500, 500, 500, 500, 2, "AllwaysTrue",,,,,Len(aCols),,,,oDlg2,@aHeader,@aCols)

	AlignObject( oDlg2, {oGet2:oBrowse}, 1, 2, {040,050} )  

	ACTIVATE MSDIALOG oDlg2 CENTER ON INIT (EnchoiceBar(oDlg2,{|| oDlg2:End()},{|| oDlg2:End()},,aButtons)  )    

	XITE->(DbCloseArea("XITE"))

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณmontaHeaderบAutor ณ Giane              บ Data ณ 04/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta aheader e estrutura do arquivo temporario para a     บฑฑ
ฑฑบ          ณ consulta                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/ 
Static Function montaHeader(cTipo)

	aHeader := {}
	aCols := {}

	Do Case
		Case cTipo == 'Cliente' 
		AAdd(aHeader,{"Cliente"      , "CLIENTE" ,"" ,TamSX3("D2_CLIENTE")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
		AAdd(aHeader,{"Loja"         , "LOJA"    ,"" ,TamSX3("D2_LOJA")[1]   ,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Nome Fantasia", "A1_NREDUZ"  ,"" ,TamSX3("A1_NREDUZ")[1] ,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})  
		AAdd(aHeader,{"Valor Total"  , "TOTCLI"     ,"@E 9,999,999,999.99" ,16,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"          % " , "NPERCENT"   ,"@E 999.99" ,05,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Qtde.Pedidos" , "QTDPED"     ,"@E 9,999"  ,04,0,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Vendedor"     , "A1_VEND"    ,"" ,TamSX3("A1_VEND")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Nome"         , "A3_NREDUZ"  ,"" ,TamSX3("A3_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
		AAdd(aHeader,{"Vendedor Int.", "A1_VENDINT" ,"" ,TamSX3("A1_VENDINT")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Nome"         , "NOMVENDI"   ,"" ,TamSX3("A3_NREDUZ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})  
		AAdd(aHeader,{"Grupo Vendas" , "ACY_DESCRI" ,"" ,TamSX3("ACY_DESCRI")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		If cMVPAR19 <> 2
			AAdd(aHeader,{"Segmento Vendas" , "DESCRI"  ,"" ,TamSX3("ACY_DESCRI")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})  
		Endif 

		Case cTipo == 'GruProd'          
		AAdd(aHeader,{"Grupo Produto", "GRUPROD" ,"" ,TamSX3("B1_GRUPO")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Descri็ใo"    , "BM_DESC" ,"" ,TamSX3("BM_DESC")[1]+30,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})	

		Case cTipo == 'GruVenda'          
		AAdd(aHeader,{"Grupo Venda  ", "VENDA" ,"" ,TamSX3("A1_GRPVEN")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Descri็ใo"    , "ACY_DESCRI" ,"" ,TamSX3("ACY_DESCRI")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})	

		Case cTipo == 'SegVenda'          
		AAdd(aHeader,{"Segmento "    , "VENDA" ,"" ,TamSX3("A1_SATIV1")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Descri็ใo"    , "DESCRI" ,"" ,TamSX3("ACY_DESCRI")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})	

		Case cTipo == 'GruSup'          
		AAdd(aHeader,{"Grupo Venda  ", "VENDA" ,"" ,TamSX3("ACY_GRPSUP")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Descri็ใo"    , "ACY_XDESC" ,"" ,TamSX3("ACY_DESCRI")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})	

		Case cTipo == 'Vendedor'          
		AAdd(aHeader,{"Vendedor "    , "VENDEDOR" ,"" ,TamSX3("A3_COD")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Nome "        , "A3_NOME" ,"" ,TamSX3("A3_NOME")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})	

		Case cTipo == 'VendInt'
		AAdd(aHeader,{"Vendedor Interno" , "VENDEDOR" ,"" ,TamSX3("A3_COD")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Nome "        , "A3_NOME" ,"" ,TamSX3("A3_NOME")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})	

		Case cTipo == 'UF'
		AAdd(aHeader,{"UF   " , "TIPO" ,"" ,TamSX3("A1_EST")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 

		Case cTipo == 'CondPag'
		AAdd(aHeader,{"Cond.Pagamento" , "TIPO" ,"" ,TamSX3("E4_CODIGO")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"Descri็ใo "     , "E4_DESCRI" ,"" ,TamSX3("E4_DESCRI")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})	

		Case cTipo == 'Frete'
		AAdd(aHeader,{"Frete  " , "TIPO" ,"" ,3,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"}) 

	EndCase  

	If cTipo <> 'Cliente'                                                                                                                    
		AAdd(aHeader,{"Valor Total"  , "TOTGRU"     ,"@E 9,999,999,999.99" ,16,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
		AAdd(aHeader,{"          % " , "NPERCENT"   ,"@E 999.99" ,05,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})   
		If cTipo == 'GruProd'
			AAdd(aHeader,{"Quantidade Vendida", "QTDPRO"     ,"@E 9,999,999,999.99" ,16,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 	
		Endif
		AAdd(aHeader,{"Qtde.Pedidos" , "QTDPED"     ,"@EB 9,999"  ,04,0,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"}) 
	Endif	

Return           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTotaliza  บAutor  ณGiane               บ Data ณ  07/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela mostra totalizadores da consulta                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Makeni                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Totaliza()  
	Local oDlgt                   
	Local oPanel1
	Local oPanel2
	Local oPanel3 
	Local nPerPen := 0
	Local nPerLiq := 0   
	Local nPerCanc := 0
	Local nPerDev  := 0   
	Local nQtdImp := 0
	Local nTotImp := 0  
	Local nPerImp := 0

	DEFINE MSDIALOG oDlgt TITLE 'Totaliza็ใo do Perํodo' From 20,01 to 380,520  of oDlgt PIXEL 
	DEFINE FONT oFnt1 Name "Arial" SIZE 0,14 BOLD
	DEFINE FONT oFnt2 Name "Arial" SIZE 0,14 

	@ 015,003 MSPANEL oPanel1 PROMPT "" SIZE 257,050 OF oDlgT LOWERED    

	@ 068,003 MSPANEL oPanel2 PROMPT "" SIZE 257,050 OF oDlgT LOWERED 

	@ 121,003 MSPANEL oPanel3 PROMPT "" SIZE 257,050 OF oDlgT LOWERED 

	@ 002, 003 Say "Pedidos Vแlidos" Pixel of oPanel1 FONT oFnt1 

	nPerPen := ( nTotPen * 100 ) / nTotGer 
	@ 017, 018 Say "Valor Total Pendente" Pixel of oPanel1 FONT oFnt2
	@ 015, 073 MSGET nQtdPen PICTURE "@E 999,999"  SIZE 25,8 WHEN .F. PIXEL OF oPanel1	  	
	@ 015, 105 MSGET nTotPen PICTURE "@E 999,999,999,999.99"  SIZE 90,8 WHEN .F. PIXEL OF oPanel1	  
	@ 015, 200 MSGET nPerPen PICTURE "@E 999.99"  SIZE 25,8 WHEN .F. PIXEL OF oPanel1	  
	@ 017, 232 Say " % " Pixel of oPanel1 FONT oFnt1    

	nPerLiq := ( nTotLiq * 100 ) / nTotGer 
	@ 032, 018 Say "Valor Total Liquidado" Pixel of oPanel1 FONT oFnt2
	@ 030, 073 MSGET nQtdLiq PICTURE "@E 999,999"  SIZE 25,8 WHEN .F. PIXEL OF oPanel1	  	
	@ 030, 105 MSGET nTotLiq PICTURE "@E 999,999,999,999.99"  SIZE 90,8 WHEN .F. PIXEL OF oPanel1	  
	@ 030, 200 MSGET nPerLiq PICTURE "@E 999.99"  SIZE 25,8 WHEN .F. PIXEL OF oPanel1	  
	@ 032, 232 Say " % " Pixel of oPanel1 FONT oFnt1

	@ 002, 003 Say "Pedidos Invแlidos" Pixel of oPanel2 FONT oFnt1 

	nPerCanc := ( nTotCanc * 100 ) / nTotGer  
	@ 017, 017 Say "Valor Total Cancelado" Pixel of oPanel2 FONT oFnt2
	@ 015, 073 MSGET nQtdCanc PICTURE "@E 9,999"  SIZE 25,8 WHEN .F. PIXEL OF oPanel2
	@ 015, 105 MSGET nTotCanc PICTURE "@E 999,999,999,999.99"  SIZE 90,8 WHEN .F. PIXEL OF oPanel2	  
	@ 015, 200 MSGET nPerCanc PICTURE "@E 999.99"  SIZE 25,8 WHEN .F. PIXEL OF oPanel2	  
	@ 017, 232 Say " % " Pixel of oPanel2 FONT oFnt1

	nPerDev := ( nTotDev * 100 ) / nTotGer  
	@ 032, 018 Say "Valor Total Devolvido" Pixel of oPanel2 FONT oFnt2
	@ 030, 073 MSGET nQtdDev PICTURE "@E 9,999"  SIZE 25,8 WHEN .F. PIXEL OF oPanel2	  	
	@ 030, 105 MSGET nTotDev PICTURE "@E 999,999,999,999.99"  SIZE 90,8 WHEN .F. PIXEL OF oPanel2
	@ 030, 200 MSGET nPerDev PICTURE "@E 999.99"  SIZE 25,8 WHEN .F. PIXEL OF oPanel2
	@ 032, 232 Say " % " Pixel of oPanel2 FONT oFnt1


	@ 002, 003 Say "Total Geral" Pixel of oPanel3 FONT oFnt1 

	nQtdVal := nQtdPen + nQtdLiq
	nTotVal := nTotPen + nTotLiq    
	nPerVal := ( nTotVal * 100 ) / nTotGer 
	@ 017, 017 Say "Total Pedidos Vแlidos" Pixel of oPanel3 FONT oFnt2
	@ 015, 073 MSGET nQtdVal PICTURE "@E 9,999"  SIZE 25,8 WHEN .F. PIXEL OF oPanel3
	@ 015, 105 MSGET nTotVal PICTURE "@E 999,999,999,999.99"  SIZE 90,8 WHEN .F. PIXEL OF oPanel3	  
	@ 015, 200 MSGET nPerVal PICTURE "@E 999.99"  SIZE 25,8 WHEN .F. PIXEL OF oPanel3	  
	@ 017, 232 Say " % " Pixel of oPanel3 FONT oFnt1

	nQtdImp := nQtdVal + nQtdCanc + nQtdDev
	nTotImp := nTotVal + nTotCanc + nTotDev  
	nPerImp := 100.00 //( nTotLiq * 100 ) / nTotGer 
	@ 032, 007 Say "Total Pedidos Implantados" Pixel of oPanel3 FONT oFnt2
	@ 030, 073 MSGET nQtdImp PICTURE "@E 9,999"  SIZE 25,8 WHEN .F. PIXEL OF oPanel3	  	
	@ 030, 105 MSGET nTotImp PICTURE "@E 999,999,999,999.99"  SIZE 90,8 WHEN .F. PIXEL OF oPanel3
	@ 030, 200 MSGET nPerImp PICTURE "@E 999.99"  SIZE 25,8 WHEN .F. PIXEL OF oPanel3
	@ 032, 232 Say " % " Pixel of oPanel3 FONT oFnt1


	ACTIVATE MSDIALOG oDlgt CENTER ON INIT (EnchoiceBar(oDlgt,{|| oDlgt:End()},{|| oDlgt:End()} )  )  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrafico   บAutor  ณMicrosiga           บ Data ณ  07/29/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para usuario escolher o tipo de grafico que deseja    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Makeni                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/        
Static Function Grafico()
	Local nTotal := 0  
	Local i      := 0         
	Private cTitulo:="Grafico Ranking de Faturamento "
	Private aGraph := {}  


	if MV_PAR18 == 1 //LIQUIDADOS
		nTotal := nTotLiq
	elseif MV_PAR18 == 2 //pendentes
		nTotal := nTotPen
	else 
		nTotal := nTotGer
	Endif    	

	For i := 1 to len(aCols)
		If !(oBtnFret:lactive) .or. !(oBtnUF:lActive)
			aadd( aGraph,{aCols[i,1], acols[i,2], nTotal  } )   
		Elseif !(oBtnCli:lactive) 
			aadd( aGraph,{aCols[i,3], acols[i,4], nTotal  } )     
		Else  
			aadd( aGraph,{aCols[i,2], acols[i,3], nTotal  } )
		Endif
	Next

	if Len(aCols) > 0
		oGraph := MatGraph(cTitulo,.T.,.T.,.T.,2,4,aGraph)    
	Endif

Return