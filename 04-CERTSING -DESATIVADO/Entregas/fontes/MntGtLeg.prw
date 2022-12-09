#Include "Protheus.ch"

/*/{Protheus.doc} AtuGtLeg
Rotina para Ajustar os dados da GTLegado (Itens)
@author Marcos Gomes - mgomes.upduo
@since 24/03/2021
/*/
User Function MntGtLeg()

	Local cTitulo := "Acerto da tabela Política de Garantia (GTLEGADO) "

	Local aCabec 	:= {}
	Local aCabecalho:= {}
	Local aColsEx   := {}
	Local aACampos  := {}
	Local aBotoes 	:= {}

	Local oAzul  	:= LoadBitmap( GetResources(), "BR_AZUL")
	Local oVermelho := LoadBitmap( GetResources(), "BR_VERMELHO")

	Local aRET  := {}
	Local aPAR  := {}
	Local cSQL  := ''
	Local lJob	:= (Select('SX6')==0)
	Local lCont := .t.

	Local dInicio := Date()-15
	Local dFim    := Date()

	Private cTRB  := ''

	IF lJob
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv( '01', '02', , , "FAT" )
	EndIF

	aAdd(aPAR,{9,"Informe parâmetros para correção da Política de Garantia",200,7,.T.})
	aAdd(aPAR,{1,"Emissão de :",dInicio,"","","",".T.",0,.T.})
	aAdd(aPAR,{1,"Emissão até:",dFim,"","" ,"",".T.",0,.T.})
	aAdd(aPAR,{1,"Pedido     :",Space(06),"","","",".T.",0,.F.})

	While lCont

		aCabec := {}
		aCabecalho:= {}
		aColsEx := {}
		aBotoes := {}

		if ParamBox(aPAR,"Ajuste GTLegado...",@aRET)

			if aRET[3] - aRET[2] > 15
				MsgInfo("Este programa somente executará um limite de 15 dias por período definido !")
				Loop
			elseif aRET[3] - aRET[2] < 0
				MsgInfo("Verifique os parâmetros de data !")
				Loop
			endif

			dInicio := aPAR[2,3] := aRET[2]
			dFim    := aPAR[3,3] := aRET[3]

			cSQL := "SELECT /*+ INDEX(C5 SC50102) */ C5_NUM, C5_EMISSAO, C5_CHVBPAG, C5_XNPSITE, C6_ITEM, C6_DATFAT, C6_XOPER, C6_XPEDORI, C6_PRODUTO, GT.GT_DATA, GT.GT_PRODUTO, C6_PEDGAR, GT.GT_PEDGAR, C6_VALOR, GT.GT_VLRPRD, C6_NOTA, GT.GT_INPROC, GT.R_E_C_N_O_ RECGT, " + CRLF
			//cSQL += "coalesce( ( SELECT count(*) FROM GTLEGADO GT1 WHERE GT1.GT_TYPE = (CASE WHEN C6_XOPER IN ('51','61') THEN 'S' ELSE 'P' END) AND GT1.GT_PEDSITE = C6_XPEDORI AND GT1.GT_PEDVENDA = C6_NUM AND GT1.GT_PRODUTO = C6_PRODUTO AND GT1.D_E_L_E_T_=' ' ) , 0) totlin " + CRLF
			cSQL += "coalesce( ( SELECT count(*) FROM GTLEGADO GT1 WHERE GT1.GT_TYPE = (CASE WHEN C6_XOPER IN ('51','61') THEN 'S' ELSE 'P' END) AND GT1.GT_PEDVENDA = C6_NUM AND GT1.GT_PRODUTO = C6_PRODUTO AND GT1.D_E_L_E_T_=' ' ) , 0) totlin " + CRLF
			cSQL += "FROM SC5010 C5 " + CRLF
			cSQL += "INNER JOIN SC6010 C6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = ' ' " + CRLF
			//cSQL += "LEFT JOIN GTLEGADO GT ON GT.GT_TYPE = (CASE WHEN C6_XOPER IN ('51','61') THEN 'S' ELSE 'P' END) AND GT.GT_PEDSITE = C6_XPEDORI AND GT.GT_PEDVENDA = C6_NUM AND GT.GT_PRODUTO = C6_PRODUTO AND GT.GT_PEDGAR = C6_PEDGAR AND GT.D_E_L_E_T_=' ' " + CRLF
			cSQL += "LEFT JOIN GTLEGADO GT ON GT.GT_TYPE = (CASE WHEN C6_XOPER IN ('51','61') THEN 'S' ELSE 'P' END) AND GT.GT_PEDVENDA = C6_NUM AND GT.GT_PRODUTO = C6_PRODUTO AND GT.D_E_L_E_T_=' ' " + CRLF
			cSQL += "WHERE  C5.D_E_L_E_T_ = ' ' " + CRLF
			cSQL += "       AND C5_FILIAL = ' ' " + CRLF
			cSQL += "       AND C5_EMISSAO >= '"+DtoS(aRET[2])+"' " + CRLF
			cSQL += "       AND C5_EMISSAO <= '"+DtoS(aRET[3])+"' " + CRLF
			if !empty(aRET[ 4 ])
				cSQL += "       AND C5_NUM = '"+aRET[4]+"' " + CRLF
			endif
			cSQL += "       AND C5_XMENSUG = '024' " + CRLF
			cSQL += "ORDER BY C5_NUM,C6_ITEM " + CRLF
			cTRB := GetNextAlias()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
			IF .NOT. (cTRB)->( EOF() )

				DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 400, 1200  PIXEL
				//------------------
				// Tipo de Pesquisa
				//------------------
				//cCombo1:= aItems[1]
				//oCombo1 := TComboBox():New(37,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,50,14,oDlg,,{||},,,,.T.,,,,,,,,,'cCombo1')
				//------------------
				// Texto de pesquisa
				//------------------
				//@ 37,62 MSGET oPesq VAR cPesq SIZE 120,11 COLOR CLR_BLACK PIXEL OF oDlg PICTURE "@!"
				//
				//cNPed := (cTRB)->C5_NUM
				//dEmis := STOD((cTRB)->C5_EMISSAO)
				//cPedS := (cTRB)->C5_XNPSITE
				//@ 37,020 SAY oNPed VAR "PEDIDO: "+cNPed SIZE 120,11 PIXEL OF oDlg PICTURE "@!"
				//@ 37,080 SAY oEmis VAR "EMISSÃO:"+dtoc(dEmis) SIZE 120,11 COLOR CLR_BLACK PIXEL OF oDlg PICTURE "@D"
				//@ 37,155 SAY oPedS VAR "PEDIDO SITE: "+cPedS SIZE 120,11 COLOR CLR_BLACK PIXEL OF oDlg PICTURE "@!"
				//------------------------------------------
				// Interface para selecao de indice e filtro
				//------------------------------------------
				//@ 37,188 BUTTON "Filtrar" SIZE 37,12 PIXEL OF oDlg ACTION(xlocaliza(cPesq))
				//---------------------------------------------------------
				//chamar a função que cria a estrutura do aHeader
				//---------------------------------------------------------
				//X3Titulo()	X3_CAMPO		X3_PICTURE	X3_TAMANHO	X3_DECIMAL	X3_VALID	X3_USADO    X3_TIPO		X3_F3	X3_CONTEXT	X3_CBOX	X3_RELACAO	X3_WHEN
				Aadd(aCabec, {"",			"IMAGEM",		"@BMP",		03,			0,			".F.",		"",			"C",		"",		"V",		"",		"",			"",		"V"})
				Aadd(aCabec, {"Pedido",		"C5_NUM",		"@!",		06,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Emissão",	"C5_EMISSAO",	"@D",		08,         0,	        "",			"",	        "D",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Item",		"C6_ITEM",		"@!",		02,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Operação",	"C6_XOPER",		"@!",		02,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Prod.Erp",	"C6_PRODUTO",	"@!",		15,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Prod.Leg",	"GT_PRODUTO",	"@!",		15,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Ped.Gar Erp","C6_PEDGAR",	"@!",		10,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Ped.Gar Leg","GT_PEDGAR",	"@!",		10,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Valor Erp",	"C6_VALOR",	"@E 99,999,999.99",13,      2,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Valor Leg",	"GT_VLRPRD","@E 99,999,999.99",13,      2,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Dt Nf Erp"  ,"C6_DATFAT",	"@D",		08,         0,	        "",			"",	        "D",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Dt Nf Leg"  ,"GT_DATA",		"@D",		08,         0,	        "",			"",	        "D",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Nota Fiscal","C6_NOTA",		"@!",		09,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"Processado",	"GT_INPROC",	"@!",		01,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"RECGT",		"RECGT",	"9999999999",	10,         0,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
				Aadd(aCabec, {"totlin",		"totlin",	"9999999999",	10,         0,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
				aCabecalho := aCabec
				//---------------------------------------------------------
				//Monta o browser com inclusão, remoção e atualização
				//---------------------------------------------------------
				oLista := MsNewGetDados():New( 045, 001, 190, 600, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)
				//---------------------------------------------------------
				//Carregar os itens que irão compor o conteudo do grid
				//---------------------------------------------------------
				While .NOT. (cTRB)->( EOF() )

					if (cTRB)->totlin != 1 .and. !empty((cTRB)->C6_DATFAT)
						oObjCor := oVermelho
					else
						//oObjCor := Iif( !empty((cTRB)->C6_DATFAT) .and. ( (cTRB)->C6_PRODUTO != (cTRB)->GT_PRODUTO .or. (cTRB)->C6_PEDGAR != (cTRB)->GT_PEDGAR .or. (cTRB)->C6_DATFAT != (cTRB)->GT_DATA .or. (cTRB)->C6_VALOR != (cTRB)->GT_VLRPRD .or. (Empty((cTRB)->C6_NOTA) .and. (cTRB)->GT_INPROC == "T") .or. (!Empty((cTRB)->C6_NOTA) .and. (cTRB)->GT_INPROC == "F") ),  oVermelho, oAzul )
						oObjCor := Iif( !empty((cTRB)->C6_DATFAT) .and. ( (cTRB)->C6_PRODUTO != (cTRB)->GT_PRODUTO .or. (cTRB)->C6_PEDGAR != (cTRB)->GT_PEDGAR .or. empty((cTRB)->GT_DATA) .or. (cTRB)->C6_VALOR != (cTRB)->GT_VLRPRD .or. (Empty((cTRB)->C6_NOTA) .and. (cTRB)->GT_INPROC == "T") .or. (!Empty((cTRB)->C6_NOTA) .and. (cTRB)->GT_INPROC == "F") ),  oVermelho, oAzul )
					endif

					aadd(aColsEx, { oObjCor, ;
						(cTRB)->C5_NUM,;
						STOD((cTRB)->C5_EMISSAO),;
						(cTRB)->C6_ITEM,;
						(cTRB)->C6_XOPER,;
						(cTRB)->C6_PRODUTO,;
						(cTRB)->GT_PRODUTO,;
						(cTRB)->C6_PEDGAR,;
						(cTRB)->GT_PEDGAR,;
						(cTRB)->C6_VALOR,;
						(cTRB)->GT_VLRPRD,;
						STOD((cTRB)->C6_DATFAT),;
						STOD((cTRB)->GT_DATA),;
						(cTRB)->C6_NOTA,;
						(cTRB)->GT_INPROC,;
						(cTRB)->RECGT,;
						(cTRB)->totlin,;
						.f. })
					(cTRB)->( dbSkip() )
				End

				//----------------------------------------
				//Atualizo as informacoes no grid
				//----------------------------------------
				oLista:SetArray(aColsEx,.T.)
				oLista:Refresh()
				//---------------------------------------------------------
				//Alinho o grid para ocupar todo o meu formulário
				//---------------------------------------------------------
				//oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

				//---------------------------------------------------------
				//Ao abrir a janela o cursor está posicionado no meu objeto
				//---------------------------------------------------------
				oLista:oBrowse:SetFocus()
				//---------------------------------------------------------
				//Crio o menu que irá aparece no botão Ações relacionadas
				//---------------------------------------------------------
				aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})
				EnchoiceBar(oDlg, {|| ( csTelaProcess(dInicio,dFim,len(aColsEx)), oDlg:End() ) }, {|| oDlg:End() },,aBotoes)

				ACTIVATE MSDIALOG oDlg CENTERED
			else

				MsgInfo("Sem Politica de Garantia neste período !")

			EndIF
			(cTRB)->( dbCloseArea() )
			FErase( cTRB + GetDBExtension() )

		Else
			MsgInfo('Processo cancelado pelo usuário','[AtuGtLeg] - Ajuste GTLegado')
			lCont := .f.
		EndIF
	end
Return

static function Legenda()

	local aLegenda := {}

	aAdd( aLegenda,{"BR_VERMELHO"  	,"   Produto COM problemas tabela GTLEGADO."	})
	aAdd( aLegenda,{"BR_AZUL"    	,"   Produto SEM problemas tabela GTLEGADO." 	})
	BrwLegenda("Legenda", "Legenda", aLegenda)

Return Nil

/*/{Protheus.doc} csTelaProcess
Rotina para acertar a tabela GTLEGADO
@author Marcos Gomes - mgomes.upduo - 24/03/2021
@since 23/03/2021
/*/
Static function csTelaProcess(dInicio,dFim,nTot)
	Local aImp := {}
	MsAguarde( {|| csProcess(dInicio,dFim,nTot,@aImp) },"Processando Acertos...")
	if len(aImp) > 0
		ImpAcertos(aImp,dInicio,dFim)
	endif
Return

Static function csProcess(dInicio,dFim,nTot,aImp)
	Local aret := {}
//Local aImp := {}
	Local nI   := 0

	ProcRegua(nTot)
	(cTRB)->( dbGotop() )
	While .NOT. (cTRB)->( EOF() )

		IncProc("Aguarde Fazendo acertos...")

		If (cTRB)->C6_XOPER $ '51,61' .and. (cTRB)->recgt > 0 		//GT_DTESTBAIXA
			aret := atuLegProd( (cTRB)->recgt, (cTRB)->GT_PEDGAR, (cTRB)->C6_PRODUTO, (cTRB)->C5_XNPSITE, (cTRB)->C5_NUM, (cTRB)->C5_EMISSAO, (cTRB)->C6_VALOR, (cTRB)->C6_NOTA, (cTRB)->totlin, (cTRB)->C6_DATFAT, (cTRB)->C6_PEDGAR )
		Endif
		if len(aret) > 0
			for nI := 1 to len(aret)
				aadd(aImp, aret[nI] )
			next
		endif
		(cTRB)->( dbSkip() )
	End

	ProcRegua(nTot)
	(cTRB)->( dbGotop() )
	While .NOT. (cTRB)->( EOF() )

		IncProc("Aguarde Fazendo acertos...")

		if !Empty((cTRB)->C6_DATFAT)
			IF (cTRB)->C6_XOPER $ '51,61'
				aret := fGrvLeg( (cTRB)->C5_NUM, 'S', (cTRB)->C6_PRODUTO,(cTRB)->C6_VALOR, 0, 0, dDataBase, StoD((cTRB)->C5_EMISSAO), 'NCC', (cTRB)->C6_PEDGAR, (cTRB)->C5_XNPSITE, (cTRB)->C6_NOTA, (cTRB)->C6_DATFAT  )  // SUBSTITUIR C5_CHVBPAG POR C6_PEDGAR - mgomes.upduo - 24/03/2021
			ElseIF (cTRB)->C6_XOPER $ '52,62'
				aret := fGrvLeg( (cTRB)->C5_NUM, 'P', (cTRB)->C6_PRODUTO,(cTRB)->C6_VALOR, (cTRB)->C6_VALOR*1.65/100, (cTRB)->C6_VALOR*7.60/100, dDataBase, StoD((cTRB)->C5_EMISSAO), 'NCC', (cTRB)->C6_PEDGAR, (cTRB)->C5_XNPSITE, (cTRB)->C6_NOTA, (cTRB)->C6_DATFAT  )  // SUBSTITUIR C5_CHVBPAG POR C6_PEDGAR - mgomes.upduo - 24/03/2021
			Endif
			if len(aret) > 0
				for nI := 1 to len(aret)
					aadd(aImp, aret[nI] )
				next
			endif
		endif
		(cTRB)->( dbSkip() )
	End

Return

//
/*/{Protheus.doc} atuLegProd
Atualiza o produto da GTLEGADO quando o código Pedido GAR é diferente da SC6
@author Bruno Nunes
@since 17/09/2020
@alteração: 24/03/2021 - Também ira alterar o Valor no campo GT_VLRPRD - por mgomes.upduo
/*/ 
static function atuLegProd( cRecLeg, cPedGar, cProduto, cPedSite, cPedVenda, cEmissao, nVlrServS, cDocFis, ntotlin, cDatFat, cGarSc6 )
	local aRet :={}
	//local oLog := nil

	default cRecLeg   := ""
	default cPedGar   := space(10)
	default cProduto  := ""
	default cPedSite  := ""
	default cPedVenda := ""
	default cEmissao  := ""

	USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	if NetErr()
		UserException( "Falha ao abrir tabela GTLEGADO - SHARED" )
		return aRet
	endif

	dbSetIndex( "GTLEGADO05" )
	dbSelectArea( "GTLEGADO" )
	dbSetOrder( 1 )
	if empty(cPedGar)
		GTLEGADO->(DbGoTo(cRecLeg))
	else
	   dbSeek( cPedGar + cValToChar( cRecLeg ) )
	endif

	while !GTLEGADO->( EOF() ) .and. GTLEGADO->GT_PEDGAR  == cPedGar .and. ;
			(!empty(GTLEGADO->GT_PEDGAR) .or. cValToChar( GTLEGADO->(recno()) ) == cValToChar( cRecLeg ) )

		if GTLEGADO->GT_PEDVENDA == cPedVenda

			if ntotlin == 1 .and. cGarSc6 == GTLEGADO->GT_PEDGAR  //.and. GTLEGADO->GT_PRODUTO == cProduto
				//if GTLEGADO->GT_PRODUTO != cProduto .or. ;
				if GTLEGADO->GT_PRODUTO == cProduto .and. (;
						GTLEGADO->GT_VLRPRD  != nVlrServS .or. ;
						(GTLEGADO->GT_INPROC .and. Empty(cDocFis)) .or. ;
						(!GTLEGADO->GT_INPROC .and. !Empty(cDocFis))  )
					//DtoS(GTLEGADO->GT_DATA)  != cDatFat .or. ;

					GTLEGADO->( RecLock( "GTLEGADO", .F. ) )
					GTLEGADO->GT_PRODUTO := cProduto
					GTLEGADO->GT_VLRPRD  := nVlrServS
					//GTLEGADO->GT_DATA := StoD(cDatFat)
					if Empty(cDocFis)
						GTLEGADO->GT_INPROC  := .F.
					else
						GTLEGADO->GT_INPROC  := .T.
					endif
					GTLEGADO->( MsUnlock() )
					/*
					oLog := CSLog():New()
					oLog:SetAssunto( "[ atuLegProd ] - Produto da GTLEGADO atualizado" )
					oLog:AddLog( {"Pedido GAR....: " + cPedGar  ,;
								"Pedido Venda..: " + cPedVenda,;
								"Pedido Site...: " + cPedSite ,;
								"Codigo Produto: " + cProduto ,;
								"valor Produto.: " + str(nVlrServS) ,;
								"Emissao.......: " + cEmissao } )
					oLog:EnviarLog()
					*/
					aadd(aRet ,{"GTLEGADO Alterado",cPedVenda,dtoc(stod(cEmissao)),cProduto,cPedGar,cPedSite,nVlrServS} )

				endif
			else
				GTLEGADO->( RecLock( "GTLEGADO", .F. ) )
				GTLEGADO->( DbDelete() )
				GTLEGADO->( MsUnlock() )
				/*
				oLog := CSLog():New()
				oLog:SetAssunto( "[ atuLegProd ] - Produto da GTLEGADO Deletado" )
				oLog:AddLog( {"Pedido GAR....: " + cPedGar  ,;
							"Pedido Venda..: " + cPedVenda,;
							"Pedido Site...: " + cPedSite ,;
							"Codigo Produto: " + cProduto ,;
							"valor Produto.: " + str(nVlrServS) ,;
							"Emissao.......: " + dtoc(stod(cEmissao)) } )
				oLog:EnviarLog()
				*/
				aadd(aRet ,{"GTLEGADO Deletado",cPedVenda,dtoc(stod(cEmissao)),cProduto,cPedGar,cPedSite,nVlrServS} )

			endif

		endif

		GTLEGADO->(DBSKIP())
	end

	GTLEGADO->( DbCloseArea() )
return aRet

/*/{Protheus.doc} fGrvLeg
Grava legado
@author Giovanni
@since 29/09/2015
/*/
Static Function fGrvLeg(cPedVenda, cType, cProduto,	nVlrPrd, nVlrPis, nVlrCofins, dDataProc, dDtRef, cTpRef, cPedGar, cXnpSite, cnota, cDatFat )
	Local aRet := {}
	Local lExistGar := .NOT. Empty( cPedGar )
	Local cSeek := IIF( lExistGar, cPedGar + cType + cProduto, cXnpSite + cType + cProduto )

	USE GTLEGADO ALIAS GTLEGADO SHARED NEW VIA "TOPCONN"
	If NetErr()
		UserException( "Falha ao abrir tabela GTLEGADO - SHARED" )
		Return(lRet)
	Endif
	IF lExistGar
		//Seta pela ordem PEDIDO GAR
		DbSetIndex("GTLEGADO02")
	Else
		//Seta pela ordem PEDIDO SITE
		DbSetIndex("GTLEGADO04")
	EndIF
	dbSelectArea("GTLEGADO")
	dbSetOrder(1)

	If !DbSeek( cSeek )
		GTLEGADO->( RecLock("GTLEGADO",.T.) )
		GTLEGADO->GT_PEDVENDA	:= cPedVenda
		GTLEGADO->GT_PEDGAR 	:= cPedGar
		GTLEGADO->GT_PEDSITE 	:= cXnpSite
		GTLEGADO->GT_TYPE   	:= cType
		if empty(cNota)
			GTLEGADO->GT_INPROC 	:= .F.
		else
			GTLEGADO->GT_INPROC 	:= .T.
		endif
		//GTLEGADO->GT_DATA		:= dDataProc
		GTLEGADO->GT_DATA		:= StoD(cDatFat)
		GTLEGADO->GT_DTREF		:= dDtRef
		GTLEGADO->GT_TPREF		:= cTpRef
		GTLEGADO->GT_PRODUTO	:= cProduto
		GTLEGADO->GT_VLRPRD		:= nVlrPrd
		GTLEGADO->GT_VLRPIS		:= nVlrPis
		GTLEGADO->GT_VLRCOFINS	:= nVlrCofins
		GTLEGADO->( MsUnlock() )
		lRet := .T.
		/*
		oLog := CSLog():New()
		oLog:SetAssunto( "[ atuLegProd ] - Produto da GTLEGADO Incluido" )
		oLog:AddLog( {"Pedido GAR....: " + cPedGar  ,;
						"Pedido Venda..: " + cPedVenda,;
						"Pedido Site...: " + cXnpSite ,;
						"Codigo Produto: " + cProduto ,;
						"valor Produto.: " + str(nVlrPrd) ,;
						"Emissao.......: " + dtoc(dDtRef) } )
		oLog:EnviarLog()
		*/
		aadd(aRet ,{"GTLEGADO Incluido",cPedVenda,dtoc(dDtRef),cProduto,cPedGar,cXnpSite,nVlrPrd} )

	Endif
	GTLEGADO->( DbCloseArea() )
Return aRet

/*******************Impressão dos acertos gerados no programa ************************/
Static Function ImpAcertos(aCols,dInicio,dFim)

	Local oReport
	Local aCab

	oReport:= xDefArray( aCols,aCab,dInicio,dFim)
	oReport:PrintDialog()

Return

Static Function xDefArray( aCols,aCab,dInicio,dFim)

	Local oReport as Object
	Local oSection as Object

	oReport := TReport():New('GTLEGADO',"Acertos GTLEGADO no período de "+DtoC(dInicio)+" até "+DtoC(dFim),/*cPerg*/,{|oReport|xImprArray( oReport, aCols )}, "Acertos GTLEGADO" )

	oSection := TRSection():New(oReport,'GTLEGADO')

	TRCell():New(oSection, "cDescri"  , "" ,"Descrição","!@"                        ,30                     ,/*lPixel*/,{|| cDescri	})
	TRCell():New(oSection, "cPedido"  , "" ,"Pedido"   ,PesqPict("SC5","C5_NUM")    ,TamSx3("C5_NUM")[1]    ,/*lPixel*/,{|| cPedido	})
	TRCell():New(oSection, "cEmissao" , "" ,"Emissão"  ,PesqPict("SC5","C5_EMISSAO"),TamSx3("C5_EMISSAO")[1],/*lPixel*/,{|| cEmissao})
	TRCell():New(oSection, "cProduto" , "" ,"Produto"  ,PesqPict("SC6","C6_PRODUTO"),TamSx3("C6_PRODUTO")[1],/*lPixel*/,{|| cProduto})
	TRCell():New(oSection, "cPedGar"  , "" ,"PedGar"   ,PesqPict("SC6","C6_PEDGAR") ,TamSx3("C6_PEDGAR")[1] ,/*lPixel*/,{|| cPedgar	})
	TRCell():New(oSection, "cPedSite" , "" ,"PedSite"  ,PesqPict("SC6","C6_XPEDORI"),TamSx3("C6_XPEDORI")[1],/*lPixel*/,{|| cPedSite})
	TRCell():New(oSection, "nVlrServ" , "" ,"Valor"    ,PesqPict("SC6","C6_VALOR")  ,TamSx3("C6_VALOR")[1]  ,/*lPixel*/,{|| nVlrServ})

	oSection:SetColSpace(2)
	oSection:nLinesBefore := 2
	oSection:SetLineBreak(.t.)

Return oReport


Static Function xImprArray( oReport, aCols )

	Local oSection := oReport:Section(1)
	Local cDescri := ""
	Local cPedido := ""
	Local cEmissao:= ""
	Local cProduto:= ""
	Local cPedGar := ""
	Local cPedSite:= ""
	Local nVlrServ:= ""
	Local nI := 0

	oReport:SetMeter( Len( aCols ) )

	oSection:Init()

	For nI := 1 To Len( aCols )

		If oReport:Cancel()
			Exit
		EndIf

		cDescri := aCols[nI, 1]
		cPedido := aCols[nI, 2]
		cEmissao:= aCols[nI, 3]
		cProduto:= aCols[nI, 4]
		cPedGar := aCols[nI, 5]
		cPedSite:= aCols[nI, 6]
		nVlrServ:= aCols[nI, 7]
		oReport:Section(1):Cell("cDescri"):SetBlock({|| cDescri})
		oReport:Section(1):Cell("cPedido"):SetBlock({|| cPedido})
		oReport:Section(1):Cell("cEmissao"):SetBlock({|| cEmissao})
		oReport:Section(1):Cell("cProduto"):SetBlock({|| cProduto})
		oReport:Section(1):Cell("cPedgar"):SetBlock({|| cPedgar})
		oReport:Section(1):Cell("cPedSite"):SetBlock({|| cPedSite})
		oReport:Section(1):Cell("nVlrServ"):SetBlock({|| nVlrServ})

		oReport:IncMeter()
		oReport:Section(1):PrintLine()
	next

	oSection:Finish()

Return
