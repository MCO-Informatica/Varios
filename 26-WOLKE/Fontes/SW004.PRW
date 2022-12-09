#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TOPCONN.CH"


User FUNCTION SW004()
	Local aAreaAtu 	:= GetArea()
	Local cPedido := ALLTRIM(SC7->C7_NUM)
	Local aColsDistrib 		:= {}
	Local aObjects:= {}
	Local cCadastro := "Consulta Preço Pedido de Venda"
	Local cPedidoDe
	Local cPedidoAte
	Local dDataIni 	:= dDatabase-30
	Local dDataFim	:= dDataBase
	Local bExecPesq		:= {|| SW004B(@aColsDistrib,@oBrowse,dDataIni,dDataFim,cCliente,cProduto)}
	Local cCliente 	:= CriaVar('A1_COD',.F.)
	Local cProduto 	:= CriaVar('B1_COD',.F.)
	
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 200, 200, .T., .T. } )
	
	
	Aadd(aColsDistrib,Array(10))
	aColsDistrib[Len(aColsDistrib),1] := ""
	aColsDistrib[Len(aColsDistrib),2] := ""
	aColsDistrib[Len(aColsDistrib),3] := ""
	aColsDistrib[Len(aColsDistrib),4] := ""
	aColsDistrib[Len(aColsDistrib),5] := ""
	aColsDistrib[Len(aColsDistrib),6] := ""
	aColsDistrib[Len(aColsDistrib),7] := ""
	aColsDistrib[Len(aColsDistrib),8] := ""
	aColsDistrib[Len(aColsDistrib),9] := ""
	aColsDistrib[Len(aColsDistrib),10] := ""
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 400,880 Of oMainWnd PIXEL
	
	oPanel:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,030, .T., .F. )
	oPanel:Align:= CONTROL_ALIGN_TOP
	
	@ 005,010 SAY "Emissão de"	OF oPanel PIXEL SIZE 040,010
	@ 005,110 SAY "até"			OF oPanel PIXEL SIZE 040,010
	@ 017,010 SAY "Cliente"	OF oPanel PIXEL SIZE 040,010
	@ 017,110 SAY "Produto"	OF oPanel PIXEL SIZE 040,010
	
	@ 005,230 BUTTON "&Carregar" 	SIZE 40,10 OF oPanel PIXEL ACTION LjMsgRun("Por favor, aguarde...",, bExecPesq )
	
	@ 004,052 MSGET dDataIni					PICTURE PesqPict('SC7','C7_EMISSAO') 	 						WHEN .T.	 	VALID NaoVazio(dDataIni)  							OF oPanel PIXEL SIZE 050,010 HASBUTTON
	@ 004,120 MSGET dDataFim					PICTURE PesqPict('SC7','C7_EMISSAO') 	 						WHEN .T.	 	VALID NaoVazio(dDataFim)  							OF oPanel PIXEL SIZE 050,010 HASBUTTON
	@ 017,052 MSGET cCliente		  																		 	WHEN .T. 		F3 "SA1"  VALID EMPTY(cCliente) .OR. ExistCpo('SA1',cCliente,1)  OF oPanel PIXEL SIZE 050,010 HASBUTTON
	@ 017,140 MSGET cProduto		  																		 	WHEN .T. 		F3 "SB1"  VALID EMPTY(cProduto) .OR. ExistCpo('SB1',cProduto,1)  OF oPanel PIXEL SIZE 050,010 HASBUTTON
	
	
	oPanel2:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0, 0, .T., .F. )
	oPanel2:Align:= CONTROL_ALIGN_ALLCLIENT
	
	DEFINE FWBROWSE oBrowse DATA ARRAY ARRAY aColsDistrib OF oPanel2
	
	//-------------------------------------------------------------------
	// Adiciona as colunas do Browse
	//-------------------------------------------------------------------
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][01]	} TITLE "Emp"				ALIGN CONTROL_ALIGN_LEFT SIZE 5 OF oBrowse
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][02]	} TITLE "Emissão"			ALIGN CONTROL_ALIGN_LEFT SIZE 5 OF oBrowse
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][03]	} TITLE "Pedido"	  		ALIGN CONTROL_ALIGN_LEFT SIZE 1 OF oBrowse
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][04] 	} TITLE "Cliente" 			ALIGN CONTROL_ALIGN_LEFT SIZE 20 OF oBrowse
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][05] 	} TITLE "Produto" 			ALIGN CONTROL_ALIGN_LEFT SIZE 1 OF oBrowse     
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][06] 	} TITLE "Descrição" 		ALIGN CONTROL_ALIGN_LEFT SIZE 1 OF oBrowse
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][07] 	} TITLE "Quantidade PV"		ALIGN CONTROL_ALIGN_LEFT SIZE 1 OF oBrowse
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][08] 	} TITLE "Vlr Unit."	 		ALIGN CONTROL_ALIGN_LEFT SIZE 1 OF oBrowse
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][09] 	} TITLE "TES"	 			ALIGN CONTROL_ALIGN_LEFT SIZE 1 OF oBrowse
	ADD COLUMN oColumn DATA { || aColsDistrib[oBrowse:nAt][10] 	} TITLE "CFOP"	 			ALIGN CONTROL_ALIGN_LEFT SIZE 1 OF oBrowse
	
	oBrowse:DisableConfig()
	oBrowse:DisableSeek()
	oBrowse:DisableFilter()
	oBrowse:Refresh()
	
	ACTIVATE FWBROWSE oBrowse
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , { || oDlg:End() } , { || oDlg:End() } ) CENTERED
	
Return

RestArea(aAreaAtu)
RETURN

Static Function SW004B(aColsDistrib,oBrowse,dDataIni,dDataFim,cCliente,cProduto)//teste
	Local cQuery := ""
	Local cQuery1 := ""
	Local nIdx := 0
	Local aEmpW	:= {'01','02'}  //Funcionamento para empresa 01 - SW COMERCIO e 02 - WOLKE COMERCIO
	Local cAlias := GetNextAlias()
	Local cAlias1 := GetNextAlias()
	
	aColsDistrib := {}
	
	for nIdx := 1 to len(aEmpW)
	    if nIdx > 1
	       cQuery1 += " UNION ALL "
	    endif
		cQuery1 += " SELECT SF2.F2_EMISSAO EMISSAO,"
		cQuery1 += " SC5.C5_NUM PEDIDO,"
		cQuery1 += " SA1.A1_COD CLIENTE,"
		cQuery1 += " SA1.A1_NOME NOME,"
		cQuery1 += " SC6.C6_PRODUTO PRODUTO,"
		cQuery1 += " SC6.C6_TES TES,"
		cQuery1 += " SC6.C6_CF CFOP,"
		cQuery1 += " SC6.C6_QTDVEN QUANTIDADE,"
		cQuery1 += " SC6.C6_PRCVEN VALOR,"
		cQuery1 += " '"+aEmpW[nIdx]+"' Empresa "
		cQuery1 += " FROM "
		if cEmpAnt == aEmpW[nIdx]
		   cQuery1 += RetSqlName("SC5")
		else
		   cQuery1 += iif(cEmpAnt=='01',"sc5020","sc5010")
		endif
		cQuery1 += " SC5 INNER JOIN "
		if cEmpAnt == aEmpW[nIdx]
		   cQuery1 += RetSqlName("SF2")
		else
		   cQuery1 += iif(cEmpAnt=='01',"sf2020","sf2010")
		endif
		cQuery1 += " SF2 ON SF2.D_E_L_E_T_<>'*' AND "
		cQuery1 += " F2_FILIAL = '"+xFilial("SF2")+"' AND F2_DOC = C5_NOTA AND "
		cQuery1 += " F2_EMISSAO BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFim)+"' "
		cQuery1 += " LEFT JOIN "
		if cEmpAnt == aEmpW[nIdx]
		   cQuery1 += RetSqlName("SA1")
		else
		   cQuery1 += iif(cEmpAnt=='01',"sa1010","sa1010")
		endif
		cQuery1 += " SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
		cQuery1 += " SA1.D_E_L_E_T_<>'*' AND "
		cQuery1 += " SA1.A1_COD = SC5.C5_CLIENT "
		cQuery1 += " INNER JOIN "
		if cEmpAnt == aEmpW[nIdx]
		   cQuery1 += RetSqlName("SC6")
		else
		   cQuery1 += iif(cEmpAnt=='01',"sc6020","sc6010")
		endif
		cQuery1 += " SC6 ON SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
		cQuery1 += " SC6.D_E_L_E_T_<>'*' AND "
		cQuery1 += " SC6.C6_NUM = SC5.C5_NUM "
		IF !EMPTY(cProduto)
			cQuery1 += " AND SC6.C6_PRODUTO = '"+cProduto+"' "
		endif
		IF !EMPTY(cCliente)
			cQuery1 += " WHERE SC5.C5_CLIENT = '"+cCliente+"' "
		endif
	next
	cQuery1 += " ORDER BY SF2.F2_EMISSAO "
	TCQUERY cQuery1 NEW ALIAS (cAlias1)
	
	WHILE (cAlias1)->(!EOF())
		aadd(aColsDistrib,{;
		    (cAlias1)->empresa,;
			DTOC(STOD((cAlias1)->EMISSAO)),;
			alltrim((cAlias1)->PEDIDO),;
			ALLTRIM((cAlias1)->CLIENTE)+" - "+ALLTRIM((cAlias1)->NOME),;
			alltrim((cAlias1)->PRODUTO),;
			POSICIONE("SB1",1,xFilial("SB1")+alltrim((cAlias1)->PRODUTO),"B1_DESC"),;
			ALLTRIM(Transform((cAlias1)->QUANTIDADE,PESQPICT("SC6","C6_QTDVEN"))),;
			ALLTRIM(Transform((cAlias1)->VALOR,PESQPICT("SC6","C6_PRCVEN"))),;
			ALLTRIM(Transform((cAlias1)->TES,PESQPICT("SC6","C6_TES"))),;
			ALLTRIM(Transform((cAlias1)->CFOP,PESQPICT("SC6","C6_CF"))) })		
		(cAlias1)->(DbSkip())
	enddo
	
	oBrowse:SetArray(aColsDistrib)
	oBrowse:Refresh()
	
	(cAlias1)->(dbCloseArea())
	
return(.T.)

