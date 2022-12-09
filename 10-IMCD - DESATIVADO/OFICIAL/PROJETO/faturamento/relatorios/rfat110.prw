#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFAT110  ³ Autor ³ Robson Sanchez        ³ Data ³12/05/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Parceiros        ³Contato ³ robson@advbrasil.com.br        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorios de Coletas                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ RFAT110                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico do SCA.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFAT110()
	Local oReport

	////oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT110" , __cUserID )

	//If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
	//Else
	//	msgStop("Esse relatório necessida do TReport")
	//Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFAT110  ³ Autor ³ Robson Sanchez        ³ Data ³12/05/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Parceiros        ³Contato ³ robson@advbrasil.com.br        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para definir o objeto TReport.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Objeto.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ RFAT110                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico do SCA.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
	Local oReport  
	Local oSection1
	Local oSection11
	Local cPerg := "RFAT110"


	oReport := TReport():New("RFAT110","Relação de Coleta","RFAT110",{|oReport| ReportPrint(oReport)},"Esse relatório tem como objetivo imprimir as Coletas")

	Pergunte("RFAT110", .F.)

	oReport:SetLandScape()

	oSection11 := TRSection():New(oReport,"Relação de Coletas",{"SC6"}) //{"Por Data","Por Banco","Por Natureza","Alfabetica","Nro. Titulo","Dt.Digitacao"," Por Lote","Por Data de Credito"})
	oSection11:SetTotalInLine(.F.)

	TRCell():New(oSection11,"C6_NUM"	    ,, "PED"              ,,TamSx3("C6_NUM")[1], .F.)
	TRCell():New(oSection11,"C6_PRODUTO"   	,, "Produto"          ,,TamSx3("C6_PRODUTO")[1],.F.)
	TRCell():New(oSection11,"NOME PRODUTO"	,, "Desc."            ,,TamSx3("B1_DESC")[1], .F.)
	TRCell():New(oSection11,"A1_NREDUZ"   	,, "Cliente"          ,,TamSx3("A1_NREDUZ")[1], .F.)
	TRCell():New(oSection11,"C6_QTDVEN"	    ,, "Qtd"              ,PesqPict("SC6","C6_QTDVEN"),TamSx3("C6_QTDVEN")[1], .F.)
	TRCell():New(oSection11,"C6_UM"	        ,, "UM"               ,,TamSx3("C6_UM")[1], .F.)
	TRCell():New(oSection11,"A4_NREDUZ"   	,, "Trans"            ,,TamSx3("A4_NREDUZ")[1], .F.)
	TRCell():New(oSection11,"C5_SOLCOL"	    ,, "Sol.Coleta"       ,"@D",TamSx3("C5_SOLCOL")[1], .F.)
	TRCell():New(oSection11,"C5_COLETA"	    ,, "Coleta"           ,"@!",TamSx3("C5_COLETA")[1], .F.)
	TRCell():New(oSection11,"C5_DTCOL"	    ,, "Inf.Coleta"       ,"@D",TamSx3("C5_DTCOL")[1], .F.)
	TRCell():New(oSection11,"C5_DTCOLR"	    ,, "Retirada em "     ,"@D",08, .F.)
	TRCell():New(oSection11,"C5_HRCOLR"	    ,, "Hora Ret"         ,"@R 99:99",06, .F.)
	TRCell():New(oSection11,"C5_PLACA"	    ,, "Placa"            ,"@R XXX9999",12, .F.)
	TRCell():New(oSection11,"SITUACAO"	    ,, "Status"           ,"@!",25, .F.)

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Robson Sanchez        ³ Data ³12/05/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Parceiros        ³Contato ³ robson@advbrasil.com.br        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina responsavel pela geracao do relatorio de titulos    ³±±
±±³          ³ recebimento e a apresentacao dos imposros sobre o titulo.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Informe o objeto TReport                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³ RFAT110                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico do SCA.                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)
	Local cQuery     := ""
	Local oSection11 := oReport:Section(1)
	Local nOrdem     := oReport:Section(1):GetOrder() 
	Local aStru      := SC6->(DbStruct())
	Local aRelat     := {}
	Local nCont      := 0
	Local nI         := 1
	Local nCond1     := 0
	Local oBreak1    := Nil
	Local lCancSC6   := .F.

	DbselectArea('SC6')
	dbsetorder(1)
	// Obtem os registros a serem processados

	cQuery := "SELECT SC6.C6_NUM,SC6.C6_PRODUTO,SC6.C6_QTDVEN, SC6.C6_CLI, SC6.C6_LOJA, SC5.C5_SOLCOL, SC6.C6_UM, SC5.C5_COLETA, SC5.C5_DTCOL, SC5.C5_TRANSP, SC5.C5_DTCOLR, SC5.C5_HRCOLR, SC5.C5_PLACA "
	cQuery += "FROM " + RetSqlName("SC6")+" SC6,  "+RetSqlName('SC5')+" SC5 "

	cQuery += "WHERE SC6.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC5.C5_NUM  = SC6.C6_NUM "
	cQuery += "   AND SC5.C5_TPFRETE  = 'F' "
	cQuery += "   AND SC5.C5_X_CANC  != 'C' "
	cQuery += "   AND SC5.C5_X_REP   != 'R' "
	cQuery += "   AND SC5.C5_LIBEROK != ' ' "
	cQuery += "   AND SC5.C5_NOTA     = ' ' "
	cQuery += "   AND SC5.C5_BLQ      = ' ' "
	cQuery += "   AND SC5.C5_XENTREG >= '20100301' "
	cQuery += "   AND SC5.D_E_L_E_T_  = ' ' "

	If ! Empty( mv_par01 ) .And. ! Empty( mv_par02 )
		cQuery += "  AND    SC6.C6_NUM  between '" + mv_par01 + "' AND '" + mv_par02       + "' "
	Endif

	If ! Empty( mv_par03 ) .And. ! Empty( mv_par04 )
		cQuery += "  AND    SC5.C5_XENTREG  between '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04)       + "'  "
	Endif

	If ! Empty( mv_par05 ) .And. ! Empty( mv_par06 )
		cQuery += "  AND    SC5.C5_DTCOLR  between '" + Dtos(mv_par05) + "' AND '" + Dtos(mv_par06)       + "'  "
	Endif

	If ! Empty( mv_par07 )
		cQuery += "  AND    SC5.C5_TRANSP = '"+mv_par07+"' "
	Endif

	If Select("TSC6") > 0
		TSC6->( dbCloseArea() )
	EndIf

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TSC6", .F., .T.)
	aEval( aStru, { |_e| Iif(_e[2] != "C", TCSetField("TSC6", _e[1], _e[2],_e[3],_e[4]),Nil) } )
	TCSetField("TSC6", "C6_QTDVEN", "N", TamSX3("C6_QTDVEN")[1], TamSX3("C6_QTDVEN")[2])
	TCSetField("TSC6", "C5_SOLCOL", "D",08,0 )
	TCSetField("TSC6", "C5_DTCOL", "D",08,0 )
	TCSetField("TSC6", "C5_DTCOLR", "D",08,0 )



	TSC6->( dbGoTop() )
	COUNT TO nCont
	TSC6->( dbGoTop() )

	oReport:SetMeter(nCont)
	oSection11:Init()

	TSC6->( dbGoTop() )
	Do While TSC6->( !EOF() )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o usuario cancelou ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If oReport:Cancel()
			nI++
			Exit
		EndIf

		oReport:IncMeter()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os dados selecionados ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aRelat, Array(14))

		aRelat[Len(aRelat)][01] := TSC6->C6_NUM
		aRelat[Len(aRelat)][02] := TSC6->C6_PRODUTO
		aRelat[Len(aRelat)][03] := Alltrim(Posicione("SB1", 1, xFilial("SB1")+TSC6->C6_PRODUTO,"B1_DESC"))
		aRelat[Len(aRelat)][04] := Alltrim(Posicione("SA1", 1, xFilial("SA1")+TSC6->(C6_CLI+C6_LOJA),"A1_NREDUZ"))
		aRelat[Len(aRelat)][05] := TSC6->C6_QTDVEN
		aRelat[Len(aRelat)][06] := TSC6->C6_UM
		aRelat[Len(aRelat)][07] := Alltrim(Posicione("SA4", 1, xFilial("SA4")+TSC6->(C5_TRANSP),"A4_NREDUZ"))
		aRelat[Len(aRelat)][08] := TSC6->C5_SOLCOL
		aRelat[Len(aRelat)][09] := TSC6->C5_COLETA
		aRelat[Len(aRelat)][10] := TSC6->C5_DTCOL
		aRelat[Len(aRelat)][11] := TSC6->C5_DTCOLR
		aRelat[Len(aRelat)][12] := TSC6->C5_HRCOLR
		aRelat[Len(aRelat)][13] := TSC6->C5_PLACA

		If Empty(TSC6->C5_SOLCOL) .and. Empty(TSC6->C5_DTCOL)
			cSituacao:="nao Solicitada"
		Endif                     

		If ! Empty(TSC6->C5_SOLCOL)
			cSituacao:="Solic.Coleta Efetuada"
		Endif

		If ! Empty(TSC6->C5_SOLCOL) .And. ! Empty( TSC6->C5_DTCOL )
			cSituacao:="Coleta ja Agendada"
		Endif


		If ! Empty(TSC6->C5_DTCOLR)
			cSituacao:="Coleta Retirada"
		Endif

		aRelat[Len(aRelat)][14] := cSituacao

		TSC6->( dbSkip() )
	EndDo

	TRPosition():New(oSection11,"SC6",1,{|| xFilial('SC6')+aRelat[nI,1]})

	oSection11:Cell("C6_NUM"):SetBlock( { ||   aRelat[nI,01] } )
	oSection11:Cell("C6_PRODUTO"):SetBlock( { ||    aRelat[nI,02] } )
	oSection11:Cell("NOME PRODUTO"):SetBlock( { ||    aRelat[nI,03] } )
	oSection11:Cell("A1_NREDUZ"):SetBlock( { ||    aRelat[nI,04] } )
	oSection11:Cell("C6_QTDVEN"):SetBlock( { ||   aRelat[nI,05] } )
	oSection11:Cell("C6_UM"):SetBlock( { ||   aRelat[nI,06] } )
	oSection11:Cell("A4_NREDUZ"):SetBlock( { ||   aRelat[nI,07] } )
	oSection11:Cell("C5_SOLCOL"):SetBlock( { ||   aRelat[nI,08] } )
	oSection11:Cell("C5_COLETA"):SetBlock( { ||   aRelat[nI,09] } )
	oSection11:Cell("C5_DTCOL"):SetBlock( { ||   aRelat[nI,10] } )
	oSection11:Cell("C5_DTCOLR"):SetBlock( { ||   aRelat[nI,11] } )
	oSection11:Cell("C5_HRCOLR"):SetBlock( { ||   aRelat[nI,12] } )
	oSection11:Cell("C5_PLACA"):SetBlock( { ||   aRelat[nI,13] } )
	oSection11:Cell("SITUACAO"):SetBlock( { ||   aRelat[nI,14] } )

	oReport:SetTitle("Relação de Coleta")

	oReport:SetMeter(Len(aRelat))
	oSection11:Init()

	nI := 1
	While nI <= Len(aRelat)

		If oReport:Cancel()
			nI++
			Exit
		EndIf

		oReport:IncMeter()
		oSection11:PrintLine()

		nI++
	EndDo
	nI--

	oSection11:Finish()

	TSC6->( dbCloseArea() )
Return