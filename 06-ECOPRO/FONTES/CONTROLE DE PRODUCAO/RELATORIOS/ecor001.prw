#Include "Protheus.ch"
#include "rptdef.ch"

User Function ecor001()
	Local oReport := nil
	Local cPerg:= Padr("ECOR001",10)

	//RpcClearEnv()
	//RpcSetType( 3 )
	//RpcSetEnv( '01', '0101',,,'PCP','ECOR001')

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.f.)

	oReport:=RptDef(cPerg)
	oReport:PrintDialog()

	//RpcClearEnv()

Return

Static Function RptDef(cPerg)
	Local oReport := Nil
	//Local oSection1:= Nil
	Local oSection2:= Nil
	//Local oBreak
	//Local oFunction

	Local cNome	:= funname()
	Local cTitulo := "APONTAMENTO DE RETRABALHO"
	Local cPerguntas := cPerg
	Local bBlocoCodigo := {|oReport| ReportPrint(oReport)}
	Local cDescricao := "APONTAMENTO DE RETRABALHO"
	Local lLandscape := .f.  //.t. Aponta a orientação de página do relatório como paisagem

	oReport:= TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao,lLandscape)
	oReport:SetEnvironment(2)  		//1 -Server / 2- Cliente
	//oReport:SetPortrait()   		//Define orientação de página do relatório como retrato
	oReport:SetLandscapet() 		//Define a orientação de página do relatório como Paisagem
	oReport:oPage:nPaperSize:= 9  	//9 ou 10 são A4
	oReport:cfontbody :="Arial"		//nome do fonte
	oReport:nfontbody := 8			//tamanho fonte
	oReport:SetDevice(IMP_PDF)      //oReport:nDevice:=IMP_PDF //Opções: 1-Arquivo,2-Impressora,3-email,4-Planilha,5-Html,6-PDF.
	//oReport:setFile(cNome)
	//oReport:SetTotalInLine(.f.)
	oReport:SetColSpace(1,.f.)		//Define o espaçamento entre as colunas

	//oSection1:= TRSection():New(oReport, "ORDEM DE PRODUCAO", {"TRB"}, /*aOrder*/ , .f. /*lLoadCells*/, .t. /*lLoadOrder*/ , /*uTotalText*/ , /*lTotalInLine*/ , /*lHeaderPage*/ , /*lHeaderBreak*/ , /*lPageBreak*/ , /*lLineBreak*/ , /*nLeftMargin*/ , /*lLineStyle*/ , /*nColSpace*/ , /*lAutoSize*/ , /*cCharSeparator*/ , /*nLinesBefore*/ , /*nCols*/ , /*nClrBack*/ , /*nClrFore*/ , /*nPercentage*/ )
	//TRCell():New(oSection1,"Z1_NUMOP"  ,"TRB","ORDEM DE PRODUÇÃO","@!",06,,,"LEFT",,)
	//oSection1:SetPageBreak(.t.)						//quebra por seção
	//oSection1:SetLineStyle( .t./*lLineStyle*/)
	//oSection1:ForceLineStyle()
	//oSection1:SetTotalText(" ")

	oSection2:= TRSection():New(oReport, "RETRABALHO"      , {"TRB"}, /*aOrder*/ , .f. /*lLoadCells*/, .t. /*lLoadOrder*/ , /*uTotalText*/ , /*lTotalInLine*/ , /*lHeaderPage*/ , /*lHeaderBreak*/ , /*lPageBreak*/ , /*lLineBreak*/ , /*nLeftMargin*/ , /*lLineStyle*/ , /*nColSpace*/ , /*lAutoSize*/ , /*cCharSeparator*/ , /*nLinesBefore*/ , /*nCols*/ , /*nClrBack*/ , /*nClrFore*/ , /*nPercentage*/ )

	TRCell():New(oSection2,"Z1_NUMOP"  ,"TRB","OP"		   ,"@!",06)

	TRCell():New(oSection2,"Z1_NUMSER" ,"TRB","Nº SÉRIE"   ,"@!",13, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, .f./*lAutoSize*/)
	TRCell():New(oSection2,"C2_PRODUTO","TRB","PRODUTO"    ,"@!",15)
	TRCell():New(oSection2,"B1_DESC"   ,"TRB","DESCRICAO"  ,"@!",40, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, .t./*lAutoSize*/)
	TRCell():New(oSection2,"Z1_CODRET" ,"TRB","CÓD"		   ,"@!",02)
	TRCell():New(oSection2,"X5_DESCRI" ,"TRB","DESC.RETRAB","@!",40, /*lPixel*/, /*bBlock*/, /*cAlign*/, /*lLineBreak*/, /*cHeaderAlign*/, /*lCellBreak*/, /*nColSpace*/, .t./*lAutoSize*/)
	TRCell():New(oSection2,"Z1_DTREG"  ,"TRB","DT REG."    ,"@D",10)
	TRCell():New(oSection2,"C2_EMISSAO","TRB","DT PROD"    ,"@D",10)
	TRCell():New(oSection2,"C2_DATPRI" ,"TRB","DT INÍCIO"  ,"@D",10)
	TRCell():New(oSection2,"C2_DATPRF" ,"TRB","DT ENTREG"  ,"@D",10)
	TRCell():New(oSection2,"D3_EMISSAO","TRB","DT APONTA"  ,"@D",10)

Return(oReport)

Static Function ReportPrint(oReport)
	//Local oSection1 := oReport:Section(1)
	//Local oSection2 := oReport:Section(2)
	Local oSection2 := oReport:Section(1)

	Local cQuery    := ""
	Local nIx := 0
	//Local cOrdem := ""

	cQuery := "select * from "+RetSQLName("SZ1")+" z1 "
	cQuery += "inner join "+RetSQLName("SX5")+" x5 on x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TR' and x5_chave = z1_codret and x5.d_e_l_e_t_ = ' ' "
	cQuery += "inner join "+RetSQLName("SC2")+" c2 on c2_filial = z1_filial and c2_num = z1_numop and c2_item = z1_itemop and c2_sequen = '001' and c2.d_e_l_e_t_ = ' ' "
	cQuery += "inner join "+RetSQLName("SB1")+" b1 on b1_filial = '"+xFilial("SB1")+"' and b1_cod = c2_produto and b1.d_e_l_e_t_ = ' ' "
	cQuery += "inner join "+RetSQLName("SD3")+" d3 on d3_filial = c2_filial and d3_op = c2_num||c2_item||c2_sequen and d3_cod = c2_produto and d3.d_e_l_e_t_ = ' ' and d3_estorno != 'S' "
	cQuery += "where z1_filial = '"+xFilial("SZ1")+"' and z1_numop >= '"+mv_par01+"' and z1_numop <= '"+mv_par02+"' and z1.d_e_l_e_t_ = ' ' "
	cQuery += "and c2_emissao >= '"+dtos(mv_par03)+"' and c2_emissao <= '"+dtos(mv_par04)+"' "
	cQuery += "order by z1_numser,z1_itretr"
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.f.,.t.)

	oReport:SetMeter(trb->(LastRec()))

	DbSelectArea('TRB')
	trb->(DbGoTop())

	oReport:StartPage()

	oReport:IncMeter()

	oSection2:init()

	While trb->(!Eof())

		If oReport:Cancel()
			Exit
		EndIf
		
		if nIx > 85
			oReport:EndPage()
			oReport:StartPage()
			nIx := 0
		endif

		//oReport:IncMeter()

		//oSection1:Init()
		//IncProc("Imprimindo Ordem de Produção: "+alltrim(trb->z1_numop))

		//oSection1:Cell("Z1_NUMOP"):SetValue(trb->z1_numop)
		//oSection1:Printline()	//imprimo a primeira seção

		//oSection2:init()
		//cOrdem := trb->z1_numop
		//While trb->z1_numop == cOrdem

			IncProc("Imprimindo Apontamento Retrabalho: "+alltrim(trb->z1_numser))

			oSection2:Cell("Z1_NUMOP"):SetValue(trb->z1_numop)

			oSection2:Cell("Z1_NUMSER"):SetValue( trb->z1_numser )
			oSection2:Cell("C2_PRODUTO"):SetValue( trb->c2_produto )
			oSection2:Cell("B1_DESC"):SetValue( trb->b1_desc )
			oSection2:Cell("Z1_CODRET"):SetValue(trb->z1_codret)
			oSection2:Cell("X5_DESCRI"):SetValue( trb->x5_descri )
			oSection2:Cell("Z1_DTREG"):SetValue( stod(trb->z1_dtreg) )
			oSection2:Cell("C2_EMISSAO"):SetValue( stod(trb->c2_emissao) )
			oSection2:Cell("C2_DATPRI"):SetValue( stod(trb->c2_datpri) )
			oSection2:Cell("C2_DATPRF"):SetValue( stod(trb->c2_datprf) )
			oSection2:Cell("D3_EMISSAO"):SetValue( stod(trb->d3_emissao) )
			oSection2:Printline()

			nIx += 1

			trb->(dbSkip())
		//End

		//oSection2:Finish()	//finalizo a segunda seção para que seja reiniciada para o proximo registro
		//oReport:ThinLine()	//imprimo uma linha para separar uma OP de outra
		//oSection1:Finish()	//finalizo a primeira seção
	End
	
	oSection2:Finish()	//finalizo a segunda seção para que seja reiniciada para o proximo registro
	oReport:EndPage()

	trb->( DbCloseArea() )
Return

Static Function AjustaSX1(cPerg)
	Local aArea := GetArea()//Retorna Ã¡rea de trabalho
	Local aRegs := {}
	Local ni := 0

	cPerg:= Padr("ECOR001",10)

	aAdd(aRegs,{"01","Da Ordem Produção......?", "mv_ch1","C",06,0,0,"G","mv_par01",""     ,""       ,"","SC2",""})
	aAdd(aRegs,{"02","Até a Ordem Produção...?", "mv_ch2","C",06,0,0,"G","mv_par02",""     ,""       ,"","SC2",""})
	aAdd(aRegs,{"03","Da Data................?", "mv_ch3","D",08,0,0,"G","mv_par03",""     ,""       ,"",""   ,""})
	aAdd(aRegs,{"04","Até a Data.............?", "mv_ch4","D",08,0,0,"G","mv_par04",""     ,""       ,"",""   ,""})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For ni := 1 to Len(aRegs)
		dbSeek(cPerg+aRegs[ni,1])
		RecLock("SX1",!Found())
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := aRegs[ni,01]
		SX1->X1_PERGUNT := aRegs[ni,02]
		SX1->X1_VARIAVL := aRegs[ni,03]
		SX1->X1_TIPO    := aRegs[ni,04]
		SX1->X1_TAMANHO := aRegs[ni,05]
		SX1->X1_DECIMAL := aRegs[ni,06]
		SX1->X1_PRESEL  := aRegs[ni,07]
		SX1->X1_GSC     := aRegs[ni,08]
		SX1->X1_VAR01   := aRegs[ni,09]
		SX1->X1_DEF01   := aRegs[ni,10]
		SX1->X1_DEF02   := aRegs[ni,11]
		SX1->X1_DEF03   := aRegs[ni,12]
		SX1->X1_F3      := aRegs[ni,13]
		SX1->X1_VALID   := aRegs[ni,14]
		MsUnlock()
	Next

	RestArea(aArea)
Return
