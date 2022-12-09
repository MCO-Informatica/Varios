#include "Protheus.ch"
#include "rptdef.ch"
#include "FWPrintSetup.ch"

/*/{Protheus.doc} td_etq06
Rotina para impressão de etiquetas de materia prima
@type function
@version 12.1.33
@author marcos gomes
@since 13/10/2022
/*/
User Function td_etq06()

	Local cFilter     := ""
	Local aCores      := {}

	Private cCadastro := 'Impressão de Etiquetas (Matéria-Prima)'
	Private cDelFunc  := '.t.'
	Private aRotina   := {}
	Private cAlias    := 'SF1'

	aAdd( aRotina, { 'Pesquisar'    , 'AxPesqui'  , 0, 1 } )
	aAdd( aRotina, { 'Impr.Etiqueta', 'u_etq06()' , 0, 2 } )

	//cFilter := "F1_FORNECE = '001900' AND F1_LOJA = '01' AND F1_ESPECIE = 'NFE  ' AND F1_SERIE = 'F03' AND F1_TIPO = 'N' AND F1_STATUS = ' '"

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTop()
	mBrowse(10,10,60,120,cAlias,,,,,, aCores,,,,,,,,cFilter)

Return

User Function etq06()

	local cQuery := ""
	Local cNomFor:= ""

	//Local nQuant := 0
	//local aPar	:= {}
	//local aRet	:= {}

	Local cFilename         := 'EtqMP'+dtos(date())+replace(time(),':','')
	Local lAdjustToLegacy   := .t.   //.f.
	Local lDisableSetup     := .t.
	Local nDevice           := IMP_PDF  //IMP_SPOOL
	Local nResol            := 95

	local cPasta := "c:\temp\"

	Private oPrint
	/*
	aAdd(aPar,{1,"Qtds Vezes",nQuant ,"@E 999" ,"","",".T.",20,.T.})
	if !MsgYesNo("Confirma a Impressão das Etiquetas ?")
		Return
	endif
	if !ParamBox(aPar,"Impressão de Etiquetas...",@aRet,,,,,,,,.t.,.t.)
		Return
	endif
	nQuant := aRet[1]
	*/

	cQuery := "select d1_filial,d1_doc,d1_serie,d1_fornece,d1_loja,d1_item,d1_cod,d1_descri,d1_local,d1_quant,d1_um,"
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
	if !trb->(eof())

		if MsgYesNo("Confirma a Impressão das Etiquetas ?")

			sa2->(dbSetOrder(1))
			sa2->(dbSeek(xFilial()+sf1->f1_fornece+sf1->f1_loja))
			cNomFor := sa2->a2_nome

			oPrint:= FWMSPrinter():New(cFilename, nDevice, lAdjustToLegacy, , lDisableSetup)
			oPrint:SetResolution(nResol)
			oPrint:SetLandscape()   //paisagem
			//oPrint:SetPortrait()  //retrato
			//oPrint:SetPaperSize(DMPAPER_A4)
			oPrint:SetPaperSize(0,50,140)	//140 x 50
			oPrint:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior
			oPrint:cPathPDF := alltrim(cPasta) // Caso seja utilizada impressÃ£o em IMP_PDF

			while trb->(!eof())
				//impEtq(nQuant)
				impEtq(cNomFor)
				trb->(dbskip())
			end

			oPrint:Preview() //Visualiza antes de imprimir
			FreeObj(oPrint)
			oPrint := Nil

			msginfo('Impressão Concluída')
		endif
	else
		msginfo('Não foi possível imprimir etiqueta')
	endif
	trb->(dbCloseArea())

	FreeObj(oPrint)
	oPrint := Nil

Return


Static Function ImpEtq(cNomFor)

	//Local cLogo := 'biodomani.bmp'
	//Local nI      := 1
	Local ncol    := 0
	Local nLin    := 0
	//local nWidth  := 1.5
	//local nHeight := 30
	//local nTotWidth := 140
	Local oArial18n	:= TFont():New("Arial"	,18,18,,.T.,,,,.F.,.F.)		// Negrito
	Local oArial20n	:= TFont():New("Arial"	,20,20,,.T.,,,,.F.,.F.)		// Negrito
	//Local oArial13  := TFont():New("Arial"    ,13,13,,.F.,,,,.F.,.F.)        // Negrito
	//Local oArial13N := TFont():New("Arial"    ,13,13,,.T.,,,,.F.,.F.)        // Negrito
	//Local oArial12N := TFont():New("Arial"    ,12,12,,.T.,,,,.F.,.F.)        // Negrito
	//Local oBrushBlack := TBrush():New( , CLR_BLACK)

	Local cCodProd :=  alltrim(trb->d1_cod)
	Local cValidade := iif(empty(trb->d1_dtvalid),"INDETERMINADO",dtoc(stod(trb->d1_dtvalid)))
	Local nQuant  := 0

	if empty(trb->db_local)
		nQuant := trb->d1_quant
	else
		nQuant := trb->db_quant
	endif

	//while !trb->( Eof() ) .and. nI <= nQuant

	oPrint:StartPage()
	oPrint:Say(nLin   , 70+ncol, "Nome: "+alltrim(trb->d1_descri), oArial20n)
	oPrint:Say(nLin+18, 70+ncol, "Código: "+alltrim(cCodProd) , oArial20n)
	oPrint:Say(nLin+36, 70+ncol, "Lote Int.: "+alltrim(trb->d1_lotectl) , oArial20n)
	oPrint:Say(nLin+54, 70+ncol, "Fornecedor: "+alltrim(cNomFor), oArial18n)
	oPrint:Say(nLin+72, 70+ncol, "Lote Fornecedor: "+alltrim(trb->d1_x_lforn), oArial20n)
	oPrint:Say(nLin+90, 70+ncol, "Validade: "+alltrim(cValidade), oArial20n)
	oPrint:Say(nLin+108,70+ncol, "Endereço: "+Alltrim(trb->db_localiz), oArial20n)
	oPrint:Say(nLin+126,70+ncol, "Qtd: "+alltrim(str(nQuant))+" "+lower(trb->d1_um), oArial20n)
	oPrint:Say(nLin+126,320+ncol, "NF: "+alltrim(trb->d1_doc), oArial20n)
	//oPrint:Code128(nLin+92/*nRow*/,275+ncol/*nCol*/,cCodProd/*cCodeBar*/,nWidth/*nWidth*/,nHeight/*<nHeight*/,.t./*lSay*/,oArial20n/*oFont*/,nTotWidth/*nTotalWidth*/)
	oPrint:EndPage()
	//	nI += 1
	//end

Return
