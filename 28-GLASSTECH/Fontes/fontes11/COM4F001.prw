#include 'protheus.ch'

static _cRecNum := ''

user function MT110ROT()

	// Substitui A110Impri em aRotina[5]
	aRotina[5] := { 'impRimir (gestoq)', 'U_IMPSOL01("SC1", SC1->C1_NUM)', 0, 4, 0, nil }
	//AAdd( aRotina, { 'impRimir', 'U_IMPSOL01("SC1", SC1->C1_NUM)', 0, 4, 0, nil } )

return 

user function IMPSOL01(_cTabela, _cRecNo)
	local oReport
	_cRecNum := _cRecNo
	//Alert('Tabela: ' + _cTabela + ' Número SC: ' + _cRecNo)

	if TRepInUse()
		Pergunte('THR4001', .F.)
		
		oReport := TH4R001()
		oReport:PrintDialog()
	endif
return 

static function TH4R001
	local oReport
	local oSection1
	local oSection2
	local oSection3
	
	local cTitulo := 'Solicitação de Compra  Nº ' + _cRecNum  
	local oFont16n:= TFont():New("TIMES",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	
	oReport := TReport():New('TH4R001', cTitulo,, {|oReport| PrintReport(oReport, oSection1, oSection2)},;
		'Este relatório irá imprimir a solicitação de compras.')
	oReport:SetPortrait()
	oReport:SetTotalInLine(.T.)
	oReport:ShowHeader()
	
	//oReport:Say(1, 1, 'Austin Felipe Teste', oFont16n, 21)
	//oReport:lHeaderVisible := .F.
	oReport:nFontBody := 10
	oReport:nLineHeight := 40
	
	//oSection3 := TRSection():New(oReport, '', {'SC1'})
	//TRCell():New(oSection3, 'C1_ITEM', 'SC1', 'Austin Teste', PesqPict('SC1', 'C1_ITEM'), TamSX3('C1_ITEM')[1]+1,,)
	//TRCell():New(oSection3, 'C1_ITEM2', 'SC1', 'Austin Teste 2', PesqPict('SC1', 'C1_ITEM'), TamSX3('C1_ITEM')[1]+1,,)
	
	oSection3 := TRSection():New(oReport, '', {'SC1', 'SBM'})
	TRCell():New(oSection3, 'C1_EMISSAO', 'SC1', 'Emissão', PesqPict('SC1', 'C1_EMISSAO'), TamSX3('C1_EMISSAO')[1]+4,,)
	TRCell():New(oSection3, 'BM_DESC', 'SBM', 'Grupo', PesqPict('SBM', 'BM_DESC'), TamSX3('BM_DESC')[1]+10,,)
	TRCell():New(oSection3, 'C1_SOLICIT', 'SC1', 'Emitente', PesqPict('SC1', 'C1_SOLICIT'), TamSX3('C1_SOLICIT')[1]+1,,)
	oSection3:SetHeaderPage(.T.)
	
	oSection2 := TRSection():New(oSection3, '', {'SC1'})
	oSection2:SetTotalInLine(.F.)
	oSection2:lLineStyle := .T.
	TRCell():New(oSection2, 'C1_OBS', 'SC1', 'Obs', PesqPict('SC1', 'C1_OBS'), TamSX3('C1_OBS')[1]+1,,)
	
	oSection1 := TRSection():New(oSection2, 'Compras', {'SC1', 'SB1'})
	oSection1:SetTotalInLine(.F.)
	
	//TRCell():New(oSection1, 'C1_NUM', 'SC1', 'Num. Solic.', PesqPict('SC1', 'C1_NUM'), TamSX3('C1_NUM')[1]+1,,)	
	TRCell():New(oSection1, 'C1_ITEM', 'SC1', 'It.', PesqPict('SC1', 'C1_ITEM'), TamSX3('C1_ITEM')[1]+1,,)
	TRCell():New(oSection1, 'B1_DESC', 'SB1', 'Descrição', PesqPict('SB1', 'B1_DESC'), TamSX3('B1_DESC')[1]+1,,)	
	TRCell():New(oSection1, 'C1_UM', 'SC1', 'UN', PesqPict('SC1', 'C1_UM'), TamSX3('C1_UM')[1]+1,,)
	TRCell():New(oSection1, 'C1_QUANT', 'SC1', 'Qtd', PesqPict('SC1', 'C1_QUANT'), TamSX3('C1_QUANT')[1]+1,,)
	TRCell():New(oSection1, 'C1_DATPRF', 'SC1', 'Previsão', PesqPict('SC1', 'C1_DATPRF'), TamSX3('C1_DATPRF')[1]+4,,)
	
	//TRCell():New(oSection3, 'C1_ITEM2', 'SC1', 'Austin Teste 2', PesqPict('SC1', 'C1_ITEM'), TamSX3('C1_ITEM')[1]+1,,)
	
	
	//oBreak := TRBreak():New(oSection1, oSection1:Cell("C1_NUM"),,.F.) 
	
	//TRFunction():New(oSection1:Cell("C1_ITEM"),"Total Itens","COUNT",oBreak,,"@E 999999",,.F.,.F.)
return oReport

static function PrintReport(oReport, oSection1, oSection2)
	local oSection3 := oReport:Section(1)
	//local oSection1 := oReport:Section(2)
	oSection3:Init()
	oSection3:SetHeaderSection(.T.)
	oSection1:Init()
	oSection2:Init()
	
	
	SC1->(dbSelectArea('SC1'))
	SC1->(dbsetorder(1))
	SC1->(DbClearFilter())
	SC1->(DbSetFilter({|| SC1->C1_NUM == _cRecNum .and. SC1->C1_FILIAL == xFilial('SC1')}, 'SC1->C1_NUM == _cRecNum'))
	SC1->(dbgotop())
	//dbseek(xFilial('SC1') + SC1->C1_NUM)
	oReport:SetMeter(SC1->(RecCount()))
	
	oReport:IncMeter()
	oSection3:Cell("C1_EMISSAO"):SetValue(SC1->C1_EMISSAO)
	oSection3:Cell("C1_EMISSAO"):SetAlign("LEFT")
	SBM->(dbSelectArea('SBM'))
	SBM->(dbsetorder(1))
	SBM->(dbseek(xFilial('SBM') + Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_GRUPO")))
	oSection3:Cell("BM_DESC"):SetValue(SBM->BM_DESC)
	oSection3:Cell("BM_DESC"):SetAlign("LEFT")
	oSection3:Cell("C1_SOLICIT"):SetValue(SC1->C1_SOLICIT)
	oSection3:Cell("C1_SOLICIT"):SetAlign("LEFT")
	//oSection3:Cell("C1_ITEM2"):SetValue(SC1->C1_ITEM)
	//oSection3:Cell("C1_ITEM2"):SetAlign("LEFT")
	oSection3:PrintLine()
	oSection3:Finish()
	
	while !(SC1->(Eof()))
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
		
		oSection1:Cell("C1_ITEM"):SetValue(SC1->C1_ITEM)
		oSection1:Cell("C1_ITEM"):SetAlign("LEFT")
		oSection1:Cell("B1_DESC"):SetValue(Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_DESC"))
		oSection1:Cell("B1_DESC"):SetAlign("LEFT")
		oSection1:Cell("C1_UM"):SetValue(SC1->C1_UM)
		oSection1:Cell("C1_UM"):SetAlign("LEFT")
		oSection1:Cell("C1_QUANT"):SetValue(SC1->C1_QUANT)
		oSection1:Cell("C1_QUANT"):SetAlign("RIGHT")
		oSection1:Cell("C1_DATPRF"):SetValue(dtoc(SC1->C1_DATPRF))
		oSection1:Cell("C1_DATPRF"):SetAlign("LEFT")

		oSection2:Cell("C1_OBS"):SetValue(SC1->C1_OBS)
		oSection2:Cell("C1_OBS"):SetAlign("LEFT")
		oSection1:PrintLine()
		oSection2:PrintLine()
		
		SC1->(dbskip())
	enddo
	
	SC1->(DbClearFilter())
	SC1->(dbseek(xFilial('SC1') + _cRecNum))
	
	oSection2:Finish()
	oSection1:Finish()
return