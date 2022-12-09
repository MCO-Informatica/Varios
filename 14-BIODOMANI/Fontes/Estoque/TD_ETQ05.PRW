#include "Protheus.ch"
#include "rptdef.ch"
#include "FWPrintSetup.ch"

User Function td_etq05()

	Local cFilter     := ""
	Local aCores      := {}

	Private cCadastro := 'Impressão de Etiquetas'
	Private cDelFunc  := '.t.'
	Private aRotina   := {}
	Private cAlias    := 'SF1'

	aAdd( aRotina, { 'Pesquisar'  , 'AxPesqui'     , 0, 1 } )
	aAdd( aRotina, { 'Incl.Volume', 'u_rcoma001(1)', 0, 3 } )
	aAdd( aRotina, { 'Impr.Etiqueta'   , 'u_etq05()'    , 0, 2 } )
	aAdd( aRotina, { 'Impr.Romaneio' , 'u_docgrf(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)'    , 0, 2 } )

	//cFilter := "F1_FORNECE = '001900' AND F1_LOJA = '01' AND F1_ESPECIE = 'NFE  ' AND F1_SERIE = 'F03' AND F1_TIPO = 'N' AND F1_STATUS = ' '"

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTop()
	mBrowse(10,10,60,120,cAlias,,,,,, aCores,,,,,,,,cFilter)

Return

User Function etq05()

	local cQuery := ""
	Local cNomFor:= ""

	Local cFilename         := 'Etq'+dtos(date())+replace(time(),':','')
	Local lAdjustToLegacy   := .t.   //.f.
	Local lDisableSetup     := .t.
	Local nDevice           := IMP_PDF  //IMP_SPOOL
	Local nResol            := 95

	local cPasta := "c:\temp\"

	Private oPrint

	sz4->(DbSetOrder(1))
	if !sz4->(dbseek( xfilial()+sf1->f1_doc+sf1->f1_serie+sf1->f1_fornece+sf1->f1_loja ) )
		msginfo('Favor incluir os volumes desta NF '+sf1->f1_doc+' !')
		Return
	endif

	cQuery := "select d1_filial,d1_doc,d1_serie,d1_fornece,d1_loja,d1_item,d1_cod,d1_descri,d1_local,d1_quant,"
	cQuery += "d1_dtvalid,d1_lotectl,d1_numlote,d1_x_lforn,"
	cQuery += "db_local,db_localiz,db_lotectl,db_numlote,db_quant "
	cQuery += "from "+RetSqlName("SD1")+" d1 "
	cQuery += "left join "+RetSqlName("SDB")+" db on db_filial = d1_filial and db_doc = d1_doc and db_serie = d1_serie "
	cQuery += "and db_clifor = d1_fornece and db_loja = d1_loja "
	cQuery += "and db_tiponf = d1_tipo and db_produto = d1_cod and db_local = d1_local and db_lotectl = d1_lotectl "
	cQuery += "and db.d_e_l_e_t_ = ' ' "
	cQuery += "where d1_filial = '"+sd1->(xfilial())+"' and d1_doc = '"+sf1->f1_doc+"' and d1_serie = '"+sf1->f1_serie+"' "
	cQuery += "and d1_fornece = '"+sf1->f1_fornece+"' and d1_loja = '"+sf1->f1_loja+"' and d1.d_e_l_e_t_ = ' ' "
	//cQuery += "and d1_local = '01A3' order by d1_item "
	cQuery += "order by d1_item "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"trb",.T.,.T.)
	if !trb->(eof()) .and. MsgYesNo("Confirma a Impressão das Etiquetas ?")

		sa2->(dbSetOrder(1))
		sa2->(dbSeek(xFilial()+sf1->f1_fornece+sf1->f1_loja))
		cNomFor := sa2->a2_nome

		oPrint:= FWMSPrinter():New(cFilename, nDevice, lAdjustToLegacy, , lDisableSetup)
		oPrint:SetResolution(nResol)
		oPrint:SetLandscape()   //paisagem
		//oPrint:SetPortrait()  //retrato
		//oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetPaperSize(0,50,100)	//100 x 50
		oPrint:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:cPathPDF := alltrim(cPasta) // Caso seja utilizada impressÃ£o em IMP_PDF

		while trb->(!eof())
			impEtq(cNomFor)
			trb->(dbskip())
		end

		oPrint:Preview() //Visualiza antes de imprimir
		FreeObj(oPrint)
		oPrint := Nil

		msginfo('Impressão Concluída')
	endif
	trb->(dbCloseArea())

Return


Static Function ImpEtq(cNomFor)

	//Local cLogo := 'biodomani.bmp'
	Local nI      := 1
	Local ncol    := 0
	//Local ncoll   := 0
	Local nLin    := 0
	//Local nLinl   := 0
	local nWidth  := 1.5
	local nHeight := 30
	local nTotWidth := 140
	Local oArial14N	:= TFont():New("Arial"	,14,14,,.T.,,,,.F.,.F.)		// Negrito

	Local cCodProd :=  alltrim(trb->d1_cod)
	Local cValidade := iif(empty(trb->d1_dtvalid),"INDETERMINADO",dtoc(stod(trb->d1_dtvalid)))

	local cSql := ""

	//cCodProd :=  cCodProd+replicate("0",12-len(cCodProd))

	cSql := "select * from "+RetSQLName("sz4")+" z4 where z4_filial = '"+xFilial("sz4")+"' "
	cSql += "and z4_doc = '"+trb->d1_doc+"' and z4_serie = '"+trb->d1_serie+"' and z4_fornece = '"+trb->d1_fornece+"' "
	cSql += "and z4_loja = '"+trb->d1_loja+"' and z4_item = '"+trb->d1_item+"'and z4_local = '"+trb->d1_local+"' "
	cSql += "and z4_localiz = '"+trb->db_localiz+"' and z4.d_e_l_e_t_ = ' ' "
	cSql += "order by z4_itvol"
	cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb1",.F.,.T.)
	while !trb1->( Eof() )
		nI := 1
		while nI <= trb1->z4_qtdvol

			oPrint:StartPage()
			oPrint:Say(nLin   , 52+ncol, "Nome: "+alltrim(trb->d1_descri), oArial14N)
			oPrint:Say(nLin+18, 52+ncol, "Código: "+alltrim(cCodProd) , oArial14N)
			oPrint:Say(nLin+36, 52+ncol, "Lote Int.: "+alltrim(trb->d1_lotectl) , oArial14N)
			oPrint:Say(nLin+54, 52+ncol, "Fornecedor: "+alltrim(cNomFor), oArial14N)
			oPrint:Say(nLin+72, 52+ncol, "Lote Fornecedor: "+alltrim(trb->d1_x_lforn), oArial14N)
			oPrint:Say(nLin+90, 52+ncol, "Validade: "+alltrim(cValidade), oArial14N)
			oPrint:Say(nLin+108,52+ncol, "Endereço: "+Alltrim(trb1->z4_localiz), oArial14N)
			oPrint:Say(nLin+126,52+ncol, "Vol.: "+alltrim(str(nI))+"/"+alltrim(str(trb1->z4_qtdvol)), oArial14N)
			oPrint:Say(nLin+126,135+ncol, "Qtd: "+alltrim(str(trb1->z4_qtdIte)), oArial14N)
			//oPrint:FwMsBar("EAN13"/*cTypeBar*/  ,5+nLinl/*nRow-Topo*/,6+ncoll/*Esquerda*/,cCodProd/*cCode*/,oPrint/*oPrint*/,/*lCheck*/   ,/*Color*/,/*lHorz*/   ,0.017/*nWidth-largura*/,0.40/*nHeight-Altura*/,/*lBanner*/   ,/*cFont*/       ,/*cMode*/   ,.f./*lPrint*/,/*nPFWidth*/ ,/*nPFHeigth*/ ,/*lCmtr2Pix*/)
			//oPrint:FwMsBar("CODE128"/*cTypeBar*/,8+nLinl/*nRow-Topo*/,16+ncoll/*Esquerda*/,cCodProd/*cCode*/,oPrint/*oPrint*/,.f./*lCheck*/,/*Color*/,.t./*lHorz*/,nWidth/*nWidth-largura*/,nHeight/*nHeight-Altura*/,.f./*lBanner*/,"Arial"/*cFont*/,nil/*cMode*/,.f./*lPrint*/,2/*nPFWidth*/,1/*nPFHeigth*/,.f./*lCmtr2Pix*/)
			//oPrint:Say(nLin+138, 266+ncol, cCodProd          , oArial14N)
			oPrint:Code128(nLin+92/*nRow*/,275+ncol/*nCol*/,cCodProd/*cCodeBar*/,nWidth/*nWidth*/,nHeight/*<nHeight*/,.t./*lSay*/,oArial14N/*oFont*/,nTotWidth/*nTotalWidth*/)
			oPrint:EndPage()

			nI += 1
		end
		trb1->( DbSkip() )
	end
	trb1->( DbCloseArea() )

Return
