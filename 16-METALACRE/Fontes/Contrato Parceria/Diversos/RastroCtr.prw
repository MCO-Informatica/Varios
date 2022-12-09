#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"  
#Include "Rwmake.ch"


//??????????????????????????????????????//
//                        Low Intensity colors
//??????????????????????????????????????//


#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY  CLR_HGRAY


//??????????????????????????????????????//
//                       High Intensity Colors
//??????????????????????????????????????//


#define CLR_GRAY        8421504               // RGB( 128, 128, 128 )
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 )
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 )
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 )
#define CLR_HRED            255               // RGB( 255,   0,   0 )
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 )
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 )
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 )

#DEFINE STACTR		001
#DEFINE CTRCTR		002
#DEFINE ITECTR		003
#DEFINE PRDCTR		004
#DEFINE DESCTR		005
#DEFINE UNDCTR		006
#DEFINE ALMCTR		007
#DEFINE LCRCTR		008
#DEFINE APLCTR		009
#DEFINE EMBCTR		010
#DEFINE OPCCTR		011
#DEFINE STDCTR		012
#DEFINE QTOCTR		013
#DEFINE VLUCTR		014
#DEFINE VLTCTR		015
#DEFINE QTECTR		016
#DEFINE QTPCTR		017
#DEFINE XQOCTR		018
                      
#DEFINE STAPED		001
#DEFINE PEDPED		002
#DEFINE ITEPED		003
#DEFINE PRDPED		004
#DEFINE DESPED		005
#DEFINE UNDPED		006
#DEFINE ALMPED		007
#DEFINE LCRPED		008
#DEFINE EMBPED		009
#DEFINE STDPED		010
#DEFINE LCIPED		011
#DEFINE LCFPED		012
#DEFINE APLPED		013
#DEFINE OPCPED		014
#DEFINE LOTPED		015
#DEFINE QTDPED		016
#DEFINE PRCPED		017
#DEFINE TOTPED		018
#DEFINE NOTPED		019
#DEFINE SERPED		020
#DEFINE DTFPED		021

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PedParc º Autora³ Luiz Alberto º Data ³ 09/09/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tratamento de Pedidos Parciais    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ gaveteiro                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                   
User Function RastroCtr()
Local nIt       := 0
Local aArea 	:= GetArea()
Local cContrato := ADA->ADA_NUMCTR
Private aItensCTR	:= {}
Private aPedCtr   := {}
Private oSinal1   := LoadBitmap(GetResources(),"BR_VERDE")
Private oSinal2   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private oSinal3   := LoadBitmap(GetResources(),"BR_LARANJA")
Private oSinal4   := LoadBitmap(GetResources(),"BR_AZUL")
Private oSinal5   := LoadBitmap(GetResources(),"BR_ROSA")
Private oSinal6   := LoadBitmap(GetResources(),"BR_CINZA")
Private oSinal7   := LoadBitmap(GetResources(),"BR_AMARELO")
Private oSinal8   := LoadBitmap(GetResources(),"BR_BRANCO")
Private oSinal9   := LoadBitmap(GetResources(),"BR_VERDE")

If !ADB->(dbSetOrder(1), dbSeek(xFilial("ADB")+cContrato))
	MsgStop("Não Localizados Itens do Contrato Posicionado !")
	RestArea(aArea)
	Return Nil
Else
	While ADB->(!Eof()) .And. ADB->ADB_FILIAL == xFilial("ADB") .And. ADB->ADB_NUMCTR == cContrato
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+ADB->ADB_CODPRO))

		AAdd(aItensCtr,{RetLeg(),;
						ADB->ADB_NUMCTR,;
						ADB->ADB_ITEM,;
						ADB->ADB_CODPRO,;                           
						SB1->B1_DESC,;
						SB1->B1_UM,;     
						ADB->ADB_LOCAL,;
						ADB->ADB_XLACRE,;
						ADB->ADB_XAPLIC,;
						ADB->ADB_XEMBAL,;
						ADB->ADB_OPC,;
						Iif(ADB->ADB_XSTAND=='1','Sim','Nao'),;
						TransForm(ADB->ADB_QUANT,'@E 9,999,999.9'),;
						TransForm(ADB->ADB_PRCVEN,'@E 9,999,999.99'),;
						TransForm(ADB->ADB_TOTAL,'@E 9,999,999.99'),;
						TransForm(ADB->ADB_QTDENT,'@E 9,999,999.9'),;
						TransForm(ADB->ADB_QTDEMP,'@E 9,999,999.9'),;
						ADB->ADB_QUANT})
		
		ADB->(dbSkip(1))
	Enddo
Endif
						
If Len(aItensCtr) > 0
	lOk:=.f.

	cNomeCli := ''
	If !Empty(ADA_CLIMTS)
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+ADA->ADA_CLIMTS+ADA->ADA_LOJMTS))
		
		cNomeCli := '('+SA1->A1_COD+'/'+SA1->A1_LOJA + ') - ' + SA1->A1_NOME
		
	Else 
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI))
		
		cNomeCli := '('+SA1->A1_COD+'/'+SA1->A1_LOJA + ') - ' + SA1->A1_NOME
	Endif


	DEFINE MSDIALOG oDlgCtr TITLE "Itens do Contrato" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
//	oDlgCtr:lEscClose := .F. //Não permite sair ao usuario se precionar o ESC
	
	@ 003, 005 SAY oMsg1 PROMPT "ITENS DO CONTRATO No.: " + cContrato SIZE 500, 010 OF oDlgCtr COLORS CLR_GREEN,CLR_WHITE PIXEL
	oMsg1:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	
	@ 011, 005 SAY oMsgCli PROMPT "Cliente: " + cNomeCli SIZE 500, 010 OF oDlgCtr COLORS CLR_GREEN,CLR_WHITE PIXEL
	oMsgCli:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

	@ 003, 205 BITMAP oBmp1 RESNAME "BR_VERMELHO"    oF oDlgCtr SIZE 35,15 NOBORDER WHEN .F. PIXEL
	@ 003, 215 SAY oBmpSay1 PROMPT "Item Encerrado" PIXEL SIZE 90, 16 OF oDlgCtr

	@ 003, 255 BITMAP oBmp1 RESNAME "BR_LARANJA"    oF oDlgCtr SIZE 35,15 NOBORDER WHEN .F. PIXEL
	@ 003, 265 SAY oBmpSay1 PROMPT "Item Enc/Emp." PIXEL SIZE 90, 16 OF oDlgCtr
	
	@ 003, 305 BITMAP oBmp1 RESNAME "BR_VERDE"    oF oDlgCtr SIZE 35,15 NOBORDER WHEN .F. PIXEL
	@ 003, 315 SAY oBmpSay1 PROMPT "Item Aberto" PIXEL SIZE 90, 16 OF oDlgCtr
	
	@ 003, 355 BITMAP oBmp1 RESNAME "BR_AMARELO"    oF oDlgCtr SIZE 35,15 NOBORDER WHEN .F. PIXEL
	@ 003, 365 SAY oBmpSay1 PROMPT "Item Parc.Entregue" PIXEL SIZE 90, 16 OF oDlgCtr

	@ 003, 440 SAY oMsgIt PROMPT "Qtd.Itens: " + TransForm(Len(aItensCtr),'9,999') SIZE 500, 010 OF oDlgCtr COLORS CLR_MAGENTA,CLR_WHITE PIXEL
	oMsgit:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

    @ 018, 005 LISTBOX oItensCtr Fields HEADER 'Situacao','Item','Produto','Descrição',"Un",'Alm.',"Lacre","Aplicação",'Embalagem',"Opcional",'Stand By','Qtd.Original',;
    										'Vlr.Unitário','Vlr.Total','Qtd.Entregue','Qtd.Empenhada' SIZE 490, 070 OF oDlgCtr PIXEL ColSizes 50,50

    oItensCtr:SetArray(aItensCtr)
   	oItensCtr:bChange := {||Processa({||U_CtrPed(oItensCtr:nAt,@aPedCtr)})}
    oItensCtr:bLine := {|| {aItensCtr[oItensCtr:nAt,STACTR],;
    						aItensCtr[oItensCtr:nAt,ITECTR],;
      						aItensCtr[oItensCtr:nAt,PRDCTR],;
					      	aItensCtr[oItensCtr:nAt,DESCTR],;
      						aItensCtr[oItensCtr:nAt,UNDCTR],;
      						aItensCtr[oItensCtr:nAt,ALMCTR],;
					      	aItensCtr[oItensCtr:nAt,LCRCTR],;
					      	aItensCtr[oItensCtr:nAt,APLCTR],;
					      	aItensCtr[oItensCtr:nAt,EMBCTR],;
					      	aItensCtr[oItensCtr:nAt,OPCCTR],;
					      	aItensCtr[oItensCtr:nAt,STDCTR],;
      						aItensCtr[oItensCtr:nAt,QTOCTR],;
      						aItensCtr[oItensCtr:nAt,VLUCTR],;
					      	aItensCtr[oItensCtr:nAt,VLTCTR],;
					      	aItensCtr[oItensCtr:nAt,QTECTR],;
					      	aItensCtr[oItensCtr:nAt,QTPCTR]}}


	@ 100, 005 SAY oMsg2 PROMPT "Pedidos Gerados " SIZE 500, 010 OF oDlgCtr COLORS CLR_GREEN,CLR_WHITE PIXEL
	oMsg2:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	

	@ 100, 105 BITMAP oBmp1 RESNAME "BR_VERMELHO"    oF oDlgCtr SIZE 35,15 NOBORDER WHEN .F. PIXEL
	@ 100, 125 SAY oBmpSay1 PROMPT "Pedido/Item Faturado" PIXEL SIZE 90, 16 OF oDlgCtr

	@ 100, 205 BITMAP oBmp1 RESNAME "BR_AMARELO"    oF oDlgCtr SIZE 35,15 NOBORDER WHEN .F. PIXEL
	@ 100, 225 SAY oBmpSay1 PROMPT "Pedido/Item Não Faturado" PIXEL SIZE 90, 16 OF oDlgCtr

	@ 200, 005 SAY oMsg3 PROMPT "Item: " SIZE 500, 010 OF oDlgCtr COLORS CLR_GREEN,CLR_WHITE PIXEL
	oMsg3:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

	@ 200, 030 SAY oMsg4 PROMPT "Item: " SIZE 500, 010 OF oDlgCtr COLORS CLR_BLUE,CLR_WHITE PIXEL
	oMsg4:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)

	@ 200, 350 SAY oMsg5 PROMPT "Qtd.Original: " SIZE 500, 010 OF oDlgCtr COLORS CLR_BLUE,CLR_WHITE PIXEL
	oMsg5:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	@ 210, 350 SAY oMsg6 PROMPT "Qtd.Faturada: " SIZE 500, 010 OF oDlgCtr COLORS CLR_BLUE,CLR_WHITE PIXEL
	oMsg6:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	@ 220, 350 SAY oMsg7 PROMPT "Qtd.Empenhada: " SIZE 500, 010 OF oDlgCtr COLORS CLR_BLUE,CLR_WHITE PIXEL
	oMsg7:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	@ 230, 350 SAY oMsg8 PROMPT "Saldo: " SIZE 500, 010 OF oDlgCtr COLORS CLR_BLUE,CLR_WHITE PIXEL
	oMsg8:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)


    @ 110, 005 LISTBOX oPedCtr Fields HEADER 'Situacao','Pedido','Item','Produto','Descrição',"Un",'Alm.',"Lacre",'Embalagem','Stand By','Lacre Inicial','Lacre Final',;
    										"Aplicação","Opcional",'Lote','Qtd.Pedido',;
    										'Vlr.Unitário','Vlr.Total','Nota Fiscal','Série','Emissão Nota' SIZE 490, 080 OF oDlgCtr PIXEL ColSizes 50,50


	Processa({||U_CtrPed(1,@aPedCtr)})

    oPedCtr:SetArray(aPedCtr)
    oPedCtr:bLine := {|| {	aPedCtr[oPedCtr:nAt,STAPED],;
    						aPedCtr[oPedCtr:nAt,PEDPED],;
      						aPedCtr[oPedCtr:nAt,ITEPED],;
					      	aPedCtr[oPedCtr:nAt,PRDPED],;
      						aPedCtr[oPedCtr:nAt,DESPED],;
      						aPedCtr[oPedCtr:nAt,UNDPED],;
					      	aPedCtr[oPedCtr:nAt,ALMPED],;
					      	aPedCtr[oPedCtr:nAt,LCRPED],;
					      	aPedCtr[oPedCtr:nAt,EMBPED],;
					      	aPedCtr[oPedCtr:nAt,STDPED],;
					      	aPedCtr[oPedCtr:nAt,LCIPED],;
					      	aPedCtr[oPedCtr:nAt,LCFPED],;
					      	aPedCtr[oPedCtr:nAt,APLPED],;
					      	aPedCtr[oPedCtr:nAt,OPCPED],;
					      	aPedCtr[oPedCtr:nAt,LOTPED],;
					      	aPedCtr[oPedCtr:nAt,QTDPED],;
					      	aPedCtr[oPedCtr:nAt,PRCPED],;
					      	aPedCtr[oPedCtr:nAt,TOTPED],;
					      	aPedCtr[oPedCtr:nAt,NOTPED],;
					      	aPedCtr[oPedCtr:nAt,SERPED],;
					      	aPedCtr[oPedCtr:nAt,DTFPED]}}


    @ 230, 005 BUTTON oBotaoSai PROMPT "&Ver Pedido"		ACTION (lOk:=.f.,U_V_PedVed(aPedCtr[oPedCtr:nAt,PEDPED])) 	SIZE 080, 010 OF oDlgCtr PIXEL
    @ 230, 105 BUTTON oBotaoSai PROMPT "&Ver Nota" 			ACTION (lOk:=.f.,Processa({||U_CtrPed(oItensCtr:nAt,@aPedCtr)}),FS_CONSNF(aPedCtr[oPedCtr:nAt,NOTPED],aPedCtr[oPedCtr:nAt,SERPED],oPedCtr:nAt)) 	SIZE 080, 010 OF oDlgCtr PIXEL
    @ 230, 205 BUTTON oBotaoSai PROMPT "&Retornar" 			ACTION (lOk:=.f.,Close(oDlgCtr)) 	SIZE 080, 010 OF oDlgCtr PIXEL
	
	ACTIVATE MSDIALOG oDlgCtr CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
	If !lOk
		RestArea(aArea)
		Return(Nil)   
	Endif
Endif
RestArea(aArea)
Return Nil


User Function CtrPed(nPos, aPedCtr)
Local aArea := GetArea()

If nPos > 0 
	aPedCtr := {}
	cNumCtr := aItensCtr[nPos,CTRCTR]
	cIteCtr := aItensCtr[nPos,ITECTR]
	cPrdCtr := aItensCtr[nPos,PRDCTR]     
	
	cQuery:= " SELECT C6_NUM, C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_LOCAL, C6_UM, C6_XLACRE, C6_XEMBALA, C6_XSTAND, C6_XINIC, C6_XFIM, C6_XAPLICA, C6_OPC, C6_LOTECTL, C6_QTDENT, C6_QTDVEN, C6_PRCVEN, C6_VALOR, C6_NOTA, C6_SERIE, C6_DATFAT "
	cQuery+= " FROM " + RetSqlName("SC6") + " C6 "
	cQuery+= " WHERE "
	cQuery+= " C6_FILIAL = '" + xFilial("SC6") + "' "
	cQuery+= " AND C6_CONTRAT = '" + cNumCtr + "' "
	cQuery+= " AND C6_ITEMCON = '" + cIteCtr + "' "
	cQuery+= " AND C6_PRODUTO = '" + cPrdCtr + "' "
	cQuery+= " AND C6.D_E_L_E_T_ = '' "
	cQuery+= " ORDER BY C6_NUM, C6_ITEM "
	
	TCQUERY cQuery NEW ALIAS "TPEDCTR"
	
	TCSETFIELD( "TPEDCTR","C6_DATFAT","D")

	nQtdOri	:= aItensCtr[nPos,XQOCTR]
	nQtdFat := 0
	nQtdEmp := 0
	nSaldo  := 0

	While TPEDCTR->(!Eof())
		AAdd(aPedCtr,{If(!Empty(TPEDCTR->C6_NOTA),oSinal2,oSinal7),;
						TPEDCTR->C6_NUM,;
						TPEDCTR->C6_ITEM,;
						TPEDCTR->C6_PRODUTO,;
						TPEDCTR->C6_DESCRI,;
						TPEDCTR->C6_UM,;
						TPEDCTR->C6_LOCAL,;      
						TPEDCTR->C6_XLACRE,;
						TPEDCTR->C6_XEMBALA,;
						TPEDCTR->C6_XSTAND,;
						TransForm(TPEDCTR->C6_XINIC,'9999999999'),;
						TransForm(TPEDCTR->C6_XFIM,'9999999999'),;
						TPEDCTR->C6_XAPLICA,;
						TPEDCTR->C6_OPC,;
						TPEDCTR->C6_LOTECTL,;
						TransForm(TPEDCTR->C6_QTDVEN, '@E 9,999,999.9'),;
						TransForm(TPEDCTR->C6_PRCVEN, '@E 9,999,999.99'),;
						TransForm(TPEDCTR->C6_VALOR, '@E 9,999,999.99'),;
						TPEDCTR->C6_NOTA,;
						TPEDCTR->C6_SERIE,;
						DtoC(TPEDCTR->C6_DATFAT)})
		
		If Empty(TPEDCTR->C6_NOTA)
			nQtdEmp += TPEDCTR->C6_QTDVEN
		Else       
			nQtdFat += TPEDCTR->C6_QTDENT
		Endif

		TPEDCTR->(dbSkip(1))
	Enddo
	
	nSaldo := nQtdOri-(nQtdEmp+nQtdFat)
	
	If ADB->(dbSetOrder(1), dbSeek(xFilial("ADB")+cNumCtr+cIteCtr)) .And. GetNewPar("MV_MTLAJCT",.t.)	// Parametro se Atualiza Saldos de Contratos
		// Quantidade Entregue
		If ADB->ADB_QTDENT <> nQtdFat
			If RecLock("ADB",.f.)
				ADB->ADB_QTDENT	:=	nQtdFat
				ADB->(MsUnlock())
			Endif
		Endif
		// Quantidade Empenhada
		If ADB->ADB_QTDEMP <> nQtdEmp
			If RecLock("ADB",.f.)
				ADB->ADB_QTDEMP	:=	nQtdEmp
				ADB->(MsUnlock())
			Endif
		Endif   

		aItensCtr[nPos,STACTR]	:=	RetLeg()
		aItensCtr[nPos,QTECTR]	:=	TransForm(ADB->ADB_QTDENT,'@E 9,999,999.9')
		aItensCtr[nPos,QTPCTR]	:=	TransForm(ADB->ADB_QTDEMP,'@E 9,999,999.9')
	Endif
	
	oMsg4:cCaption := AllTrim(aItensCtr[nPos,PRDCTR]) + ' - ' + AllTrim(aItensCtr[nPos,DESCTR])

	oMsg5:cCaption := 'Qtd.Original: ' + TransForm(nQtdOri,'@E 9,999,999.9')
	oMsg6:cCaption := 'Qtd.Faturada: ' + TransForm(nQtdFat,'@E 9,999,999.9')
	oMsg7:cCaption := 'Qtd.Empenhada: ' + TransForm(nQtdEmp,'@E 9,999,999.9')
	oMsg8:cCaption := 'Saldo: ' + TransForm(nSaldo,'@E 9,999,999.9')
	
	oMsg5:Refresh()
	oMsg6:Refresh()
	oMsg7:Refresh()
	oMsg8:Refresh()

	TPEDCTR->(dbCloseArea())
Endif

If Empty(Len(aPedCtr))
	aPedCtr := {{oSinal7,'','','','','','','','','','','','','','','','','','','',''}}
Endif

oPedCtr:SetArray(aPedCtr)
oPedCtr:bLine := {|| {	aPedCtr[oPedCtr:nAt,STAPED],;
    						aPedCtr[oPedCtr:nAt,PEDPED],;
      						aPedCtr[oPedCtr:nAt,ITEPED],;
					      	aPedCtr[oPedCtr:nAt,PRDPED],;
      						aPedCtr[oPedCtr:nAt,DESPED],;
      						aPedCtr[oPedCtr:nAt,UNDPED],;
					      	aPedCtr[oPedCtr:nAt,ALMPED],;
					      	aPedCtr[oPedCtr:nAt,LCRPED],;
					      	aPedCtr[oPedCtr:nAt,EMBPED],;
					      	aPedCtr[oPedCtr:nAt,STDPED],;
					      	aPedCtr[oPedCtr:nAt,LCIPED],;
					      	aPedCtr[oPedCtr:nAt,LCFPED],;
					      	aPedCtr[oPedCtr:nAt,APLPED],;
					      	aPedCtr[oPedCtr:nAt,OPCPED],;
					      	aPedCtr[oPedCtr:nAt,LOTPED],;
					      	aPedCtr[oPedCtr:nAt,QTDPED],;
					      	aPedCtr[oPedCtr:nAt,PRCPED],;
					      	aPedCtr[oPedCtr:nAt,TOTPED],;
					      	aPedCtr[oPedCtr:nAt,NOTPED],;
					      	aPedCtr[oPedCtr:nAt,SERPED],;
					      	aPedCtr[oPedCtr:nAt,DTFPED]}}
oPedCtr:Refresh()
RestArea(aArea)
Return .t.




//----------------------------------------------------------------------------
//| Restaura a integridade da rotina                                         |
//----------------------------------------------------------------------------
cFilAnt := cSavFil
RestArea(aAreaSC5)
RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aArea)

Return(.T.)
//**************************************************************************************************


/////////////////////////////
User Function V_PedVed(cPedNum)	//--> Rotina de interface da visualizacao do Pedido de Venda
/////////////////////////////

Local aArea     := GetArea()
Local cSavFil   := cFilAnt

//----------------------------------------------------------------------------
//| Montagem da interface                                                    |
//----------------------------------------------------------------------------
dbSelectArea("SC5")
dbSetOrder(1)
If MsSeek(xFilial("SC5")+cPedNum)
	A410Visual("SC5",Recno(),2)
EndIf

//----------------------------------------------------------------------------
//| Restaura a integridade da rotina                                         |
//----------------------------------------------------------------------------
cFilAnt := cSavFil
RestArea(aArea)

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FS_CONSNF  ³ Autor  ³ Thiago    	     	  ³ Data ³15/07/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Consulta nota fiscal.		                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_CONSNF(cNF,cSerie,nPos)
Local nTamNro := TamSX3("F2_DOC")[1]
Local nTamSer := TamSX3("F2_SERIE")[1]

If Empty(cNF)
	Return .t.
Endif

dbSelectArea("SF2")
dbSetOrder(1)
If dbSeek(xFilial("SF2")+cNF+cSerie)
	cTipoNF := "T"
	cAlias := "SF2"
	nReg   := SF2->(Recno())
	nOpc   := 2
	Mc090Visual(cAlias,nReg,nOpc)
EndIf
Return(.t.)


Static Function RetLeg()
Private oSinal1   := LoadBitmap(GetResources(),"BR_VERDE")
Private oSinal2   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private oSinal3   := LoadBitmap(GetResources(),"BR_LARANJA")
Private oSinal4   := LoadBitmap(GetResources(),"BR_AZUL")
Private oSinal5   := LoadBitmap(GetResources(),"BR_ROSA")
Private oSinal6   := LoadBitmap(GetResources(),"BR_CINZA")
Private oSinal7   := LoadBitmap(GetResources(),"BR_AMARELO")
Private oSinal8   := LoadBitmap(GetResources(),"BR_BRANCO")
Private oSinal9   := LoadBitmap(GetResources(),"BR_VERDE")

If Empty(ADB->ADB_QUANT-(ADB->ADB_QTDENT)) .And. Empty(ADB->ADB_QTDEMP) // Encerrado sem Empenho
	Return oSinal2
ElseIf Empty(ADB->ADB_QUANT-(ADB->ADB_QTDENT+ADB->ADB_QTDEMP)) .And. !Empty(ADB->ADB_QTDEMP)	// Encerrado mas Com Empenho Ainda
	Return oSinal3                                                                                                                
ElseIf !Empty(ADB->ADB_QUANT-(ADB->ADB_QTDENT+ADB->ADB_QTDEMP)) .And. Empty(ADB->ADB_QTDENT) // Ainda em Aberto Nunca Entregue
	Return oSinal1
ElseIf !Empty(ADB->ADB_QUANT-(ADB->ADB_QTDENT+ADB->ADB_QTDEMP)) .And. !Empty(ADB->ADB_QTDENT) // Ainda em Aberto Mas ja Entregue
	Return oSinal7
Else              
	Return oSinal1
Endif

	
