#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

USER FUNCTION MKLISCAR()
	Local oReport

	Private cPerg := "MKLISCAR"

	oReport := ReportDef()
	oReport:PrintDialog()
RETURN

STATIC FUNCTION ReportDef()
	Local oReport
	Local oSection1
	Local oSection2
	Local oSection3

	Pergunte( cPerg , .F. )

	oReport := TReport():New("MKLISCAR","Listagem de Cargas - "+SM0->M0_NOMECOM,cPerg, {|oReport| IMPDADOS( oReport )},"Listagem de Cargas - Makeni")
	oReport:SetLandscape()

	&& Section 1
	oSection1 := TRSection():New(oReport,"Carga",{"DAK","DA3","DA4"},{"Carga"})
	oSection1 :SetTotalInLine(.F.)
	&&oSection1 :SetHeaderPage(.T.)

	TRCell():New(oSection1 , "DAK_COD"    , "DAK" , "Carga"    , PesqPict("DAK","DAK_COD")   	, TamSx3("DAK_COD")[1]+1   	, /*lPixel*/ , /*{|| code-block de impressao }*/) //"Carga"
	TRCell():New(oSection1 , "DAK_SEQCAR" , "DAK" , "Seq."    , PesqPict("DAK","DAK_SEQCAR")	, TamSx3("DAK_SEQCAR")[1]+1	, /*lPixel*/ , /*{|| code-block de impressao }*/) //"Seq."
	TRCell():New(oSection1 , "DA3_CODFOR" , "DA3" , /*Titulo*/ , /*Picture*/					, TamSx3("DA3_CODFOR")[1]+1, /*lPixel*/ , /*{|| code-block de impressao }*/)
	TRCell():New(oSection1 , "A2_NOME"    , "SA2" , /*Titulo*/ , /*Picture*/					, TamSx3("A2_NOME")[1]+1	, /*lPixel*/ , /*{|| code-block de impressao }*/)
	TRCell():New(oSection1 , "DA3_PLACA"  , "DA3" , /*Titulo*/ , /*Picture*/					, TamSx3("DA3_PLACA")[1]+1	, /*lPixel*/ , /*{|| code-block de impressao }*/)
	TRCell():New(oSection1 , "DA3_DESC"   , "DA3" , /*Titulo*/ , /*Picture*/					, TamSx3("DA3_DESC")[1]+1	, /*lPixel*/ , /*{|| code-block de impressao }*/)
	TRCell():New(oSection1 , "DAK_PESO"   , "DAK" , /*Titulo*/ , /*Picture*/					, TamSx3("DAK_PESO")[1]+1	, /*lPixel*/ , /*{|| code-block de impressao }*/)
	TRCell():New(oSection1 , "DAK_DATA"   , "DAK" , /*Titulo*/ , /*Picture*/					, TamSx3("DAK_DATA")[1]+6	, /*lPixel*/ , /*{|| code-block de impressao }*/)
	TRCell():New(oSection1 , "DAK_HORA"   , "DAK" , /*Titulo*/ , /*Picture*/					, TamSx3("DAK_HORA")[1]+4	, /*lPixel*/ , /*{|| code-block de impressao }*/)

	&& Section 2
	oSection2 := TRSection():New(oSection1,"Item da Carga",{"DAI","SA1","SF2","SC5"},)
	oSection2 :SetTotalInLine(.F.)
	&&oSection2 :SetHeaderPage(.T.)

	TRCell():New(oSection2 , "DAI_SEQUEN" ,"DAI" , "Sequen"  , /*Picture*/ , TamSx3("DAI_SEQUEN")[1]+1 , /*3lPixel*/ , /*{|| code-block de impressao }*/)
	TRCell():New(oSection2 , "DAI_PEDIDO" ,"DAI" , /*Titulo*/ , /*Picture*/ , TamSx3("DAI_PEDIDO")[1]+1 , /*10lPixel*/ , /*{|| code-block de impressao }*/)
	TRCell():New(oSection2 , "A1_NREDUZ"  ,"SA1" , /*Titulo*/ , /*Picture*/ , TamSx3("A1_NREDUZ")[1]+1  , /*10lPixel*/ , )
	TRCell():New(oSection2 , "A1_END"     ,"SA1" , /*Titulo*/ , /*Picture*/ , TamSx3("A1_END")[1]+1 , /*lPixel*/ , )
	TRCell():New(oSection2 , "A1_BAIRRO"  ,"SAADV	1" , /*Titulo*/ , /*Picture*/ , 20  , /*TamSx3("A1_BAIRRO")[1]+1lPixel*/ , )
	TRCell():New(oSection2 , "A1_MUN"     ,"SA1" , /*Titulo*/ , /*Picture*/ , 20  , /*SUBSTR(TamSx3("A1_MUN"),1,20)[1]+1lPixel*/ , )
	TRCell():New(oSection2 , "A1_EST"     ,"SA1" , "UF"       , /*Picture*/ , TamSx3("A1_EST")[1]+1 , /*lPixel*/ , )
	TRCell():New(oSection2 , "C5_TPFRETE" ,"SC5" , "Frete"    , /*Picture*/ , 5, /*lPixel*/ , )
	TRCell():New(oSection2 , "A4_NREDUZ"    ,"SA4" , "Transportadora", /*Picture*/ , 20  , /*SUBSTR(TamSx3("A4_NOME"),1,20)[1]+1lPixel*/ , )
	TRCell():New(oSection2 , "A1_OBSLOG"  ,"SA1" , "Obs Cliente" , /*Picture*/ , 30 , /*lPixel*/ , )
	&&TRCell():New(oSection2 , "C5_OBSLOG"  ,"SC5" , "Obs Pedido" , /*Picture*/ , 30 , /*lPixel*/ , )
	TRCell():New(oSection2 , "C5_OBSUA"  ,"SC5" , "Obs Pedido" , /*Picture*/ , 30 , /*lPixel*/ , )

	&& Section 3
	oSection3 := TRSection():New(oSection2,"Item do documento de saída",{"SD2","SB1","SF2"},)
	oSection3 :SetTotalInLine(.F.)
	&&oSection3 :SetHeaderPage(.T.)

	TRCell():New(oSection3 , "C9_ITEM"    , "SC9" , /*Titulo*/ , /*Picture*/ , TamSx3("C9_ITEM")[1]+1 , /*lPixel*/  , /*{|| code-block de impressao }*/)
	TRCell():New(oSection3 , "C9_PRODUTO" , "SC9" , /*Titulo*/ , /*Picture*/ , TamSx3("C9_PRODUTO")[1]+10 , /*lPixel*/  , /*{|| code-block de impressao }*/)
	TRCell():New(oSection3 , "B1_DESC"    , "SB1" , /*Titulo*/ , /*Picture*/ , TamSx3("B1_DESC")[1]+5 , /*lPixel*/  , /*{|| code-block de impressao }*/) &&TamSx3("B1_DESC")[1]+1
	TRCell():New(oSection3 , "C9_LOTECTL" , "SC9" , /*Titulo*/ , /*Picture*/ , TamSx3("C9_LOTECTL")[1]+18 , /*lPixel*/  , /*{|| code-block de impressao }*/)
	TRCell():New(oSection3 , "C9_QTDLIB"  , "SC9" , /*Titulo*/ , /*Picture*/ , TamSx3("C9_QTDLIB")[1]+1 , /*lPixel*/  , /*{|| code-block de impressao }*/)
	TRCell():New(oSection3 , "B1_UM"      , "SB1" , /*Titulo*/ , /*Picture*/ , TamSx3("B1_UM")[1]+1 , /*lPixel*/  , /*{|| code-block de impressao }*/)
	TRCell():New(oSection3 , "D2_PESO"    , "SD2" , "Peso"     , PesqPict("SF2","F2_PBRUTO") , TamSx3("F2_PBRUTO")[1] , /*lPixel*/ , ) //"Peso"
	TRCell():New(oSection3 , "F2_VOLUME1" , "SF2" , "Volume"   , /*Picture*/ , TamSx3("F2_VOLUME1")[1]+1 , /*lPixel*/  , ) //"Volume"
	TRCell():New(oSection3 , "D2_PESBRU"  , "SD2" , "Peso Bruto"  , PesqPict("SF2","F2_PBRUTO") , TamSx3("F2_PBRUTO")[1] , /*lPixel*/  , ) //"Volume"
	TRCell():New(oSection3 , "B8_DTVALID" , "SB8" , "Dt Vali"  , /*Picture*/ , TamSx3("B8_DTVALID")[1]+4 , /*lPixel*/  , ) 
	TRCell():New(oSection3 , "B8_DFABRIC" , "SB8" , "Dt Fabr"  , /*Picture*/ , TamSx3("B8_DFABRIC")[1]+4 , /*lPixel*/  , ) 
	TRCell():New(oSection3 , "C6_EMBRET"  , "SC6" , "Emb. Re"  , /*Picture*/ , TamSx3("B8_DFABRIC")[1]+2 , /*lPixel*/  , ) 
RETURN oReport


STATIC FUNCTION IMPDADOS( oReport )
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local oSection3 := oReport:Section(1):Section(1):Section(1)
	Local cQuery  	:= ""
	Local nReg      := 0
	Local cPESOCAR          := SuperGetmv("MV_PESOCAR")

	cQuery := " SELECT "
	cQuery += "   DAK_COD , DAK_SEQCAR , DA3_CODFOR , A2_NOME , DA3_PLACA , DA3_DESC , DAK_PESO , DAK_DATA , DAK_HORA "
	cQuery += " FROM "
	cQuery += "   "+ DAK->(RetSQLName("DAK")) +" DAK "
	cQuery += "   LEFT JOIN "+ DA3->(RetSQLName("DA3")) +" DA3 ON "
	cQuery += "     DA3_FILIAL = '"+ DA3->(xFILIAL("DA3")) +"' AND DA3_COD = DAK_CAMINH "
	cQuery += "     AND DA3.D_E_L_E_T_ = ' ' "
	cQuery += "   LEFT JOIN "+ SA2->(RetSQLName("SA2")) +" SA2 ON "
	cQuery += "     A2_FILIAL = '"+ SA2->(xFILIAL("SA2")) +"' AND A2_COD = DA3_CODFOR "
	cQuery += "     AND A2_LOJA = DA3_LOJFOR AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE "
	cQuery += "   DAK_FILIAL = '"+ DAK->(xFILIAL("DAK")) +"' "
	cQuery += "   AND DAK_COD >= '"+ MV_PAR01 +"' AND DAK_COD <= '"+ MV_PAR02 +"' "
	cQuery += "   AND DAK_SEQCAR >= '"+ MV_PAR03 +"' AND DAK_SEQCAR <= '"+ MV_PAR04 +"' "
	cQuery += "   AND DAK_CAMINH >= '"+ MV_PAR05 +"' AND DAK_CAMINH <= '"+ MV_PAR06 +"' "
	cQuery += "   AND DAK_MOTORI >= '"+ MV_PAR07 +"' AND DAK_MOTORI <= '"+ MV_PAR08 +"' "
	cQuery += "   AND DAK_DATA >= '"+ DTOS(MV_PAR09) +"' AND DAK_DATA <= '"+ DTOS(MV_PAR10) +"' "
	cQuery += "   AND DAK.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY "
	cQuery += "   DAK_COD , DAK_SEQCAR "
	TcQuery cQuery Alias TDAK New

	TDAK->(dbGoTop())
	While !TDAK->(EOF())
		nReg++
		TDAK->(dbSkip())
	Enddo
	oReport:SetMeter(nReg)
	oReport:OFONTBODY:NHEIGHT := 09
	oReport:OFONTBODY:NAME := "ARIAL"

	&& Processamento
	oReport:SetTitle( oReport:Title() )
	oSection1:Init()
	TDAK->(dbGoTop())
	While !TDAK->(EOF())
		oReport:IncMeter()

		oSection1:Cell("DAK_COD"):SetValue(TDAK->DAK_COD)
		oSection1:Cell("DAK_SEQCAR"):SetValue(TDAK->DAK_SEQCAR)
		oSection1:Cell("DA3_CODFOR"):SetValue(TDAK->DA3_CODFOR)
		oSection1:Cell("A2_NOME"):SetValue(TDAK->A2_NOME)
		oSection1:Cell("DA3_PLACA"):SetValue(TDAK->DA3_PLACA)
		oSection1:Cell("DA3_DESC"):SetValue(TDAK->DA3_DESC)
		oSection1:Cell("DAK_PESO"):SetValue(TDAK->DAK_PESO)
		oSection1:Cell("DAK_DATA"):SetValue(STOD(TDAK->DAK_DATA))
		oSection1:Cell("DAK_HORA"):SetValue(TDAK->DAK_HORA)
		oSection1:PrintLine()

		&& Section 2.
		SA1->(dbSetOrder(1))	

		cQuery := " SELECT "
		cQuery += "   DAI_SEQUEN , DAI_PEDIDO , DAI_CLIENT , DAI_LOJA , C5_OBSLOG,C5_TRANSP, C5_TPFRETE"
		cQuery += " FROM "
		cQuery += "   "+ DAI->(RetSQLName("DAI")) +" DAI "
		cQuery += "   LEFT JOIN "+ SC5->(RetSQLName("SC5")) +" C5 ON "
		cQuery += "     C5_FILIAL = '"+ SC5->(xFILIAL("SC5")) +"' AND C5_NUM = DAI_PEDIDO "
		cQuery += "     AND C5.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE "
		cQuery += "   DAI_FILIAL = '"+ DAI->(xFILIAL("DAI")) +"' AND DAI_COD = '"+ TDAK->DAK_COD +"' "
		cQuery += "   AND DAI_SEQCAR = '"+ TDAK->DAK_SEQCAR +"' AND DAI.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY "
		cQuery += "   DAI_SEQUEN , DAI_PEDIDO "
		TcQuery cQuery Alias TDAI New
		TDAI->(dbGoTop())
		While !TDAI->(EOF())
			oSection2:Init()

			SA4->(dbSeek(xFILIAL("SA4")+TDAI->C5_TRANSP))                
			SA1->(dbSeek(xFILIAL("SA1")+TDAI->DAI_CLIENT+TDAI->DAI_LOJA))                
			
			oSection2:Cell("DAI_SEQUEN"):SetValue(TDAI->DAI_SEQUEN)	
			oSection2:Cell("DAI_PEDIDO"):SetValue(TDAI->DAI_PEDIDO)	
			oSection2:Cell("A1_NREDUZ"):SetValue(SA1->A1_NREDUZ)	
			oSection2:Cell("A1_END"):SetValue(SA1->A1_END)	
			oSection2:Cell("A1_BAIRRO"):SetValue(SA1->A1_BAIRRO)
			oSection2:Cell("A1_MUN"):SetValue(SA1->A1_MUN)	
			oSection2:Cell("A1_EST"):SetValue(SA1->A1_EST)	
			oSection2:Cell("C5_TPFRETE"):SetValue(TDAI->C5_TPFRETE)	
			oSection2:Cell("A4_NREDUZ"):SetValue(SA4->A4_NOME)	
			oSection2:Cell("A1_OBSLOG"):SetValue(SA1->A1_OBSLOG)
			&&		oSection2:Cell("C5_OBSLOG"):SetValue(TDAI->C5_OBSLOG)	
			oSection2:Cell("C5_OBSUA"):SetValue(TDAI->C5_OBSLOG)
			oSection2:PrintLine()

			&& Section 3
			oSection3:Init()

			cQuery := " SELECT "
			cQuery += "   C9_ITEM , C9_PRODUTO , B1_DESC , C9_LOTECTL , C9_QTDLIB , B1_UM , B1_PESO , B1_PESBRU , F2_VOLUME1 , B8_DTVALID , B8_DFABRIC , C6_EMBRET , B1_LOTEMUL "
			cQuery += " FROM "
			cQuery += "   "+ SC9->(RetSQLName("SC9")) +" C9 "
			cQuery += "   LEFT JOIN "+ SB1->(RetSQLName("SB1")) +" B1 ON "
			cQuery += "     B1_FILIAL = '"+ SB1->(xFILIAL("SB1")) +"' AND B1_COD = C9_PRODUTO "
			cQuery += "     AND B1.D_E_L_E_T_ = ' ' "
			cQuery += "   LEFT JOIN "+ SF2->(RetSQLName("SF2")) +" F2 ON "
			cQuery += "     F2_FILIAL = '"+ SF2->(xFILIAL("SF2")) +"' AND F2_DOC = C9_NFISCAL "
			cQuery += "     AND F2_SERIE = C9_SERIENF AND F2.D_E_L_E_T_ = ' ' "
			cQuery += "   LEFT JOIN "+ SB8->(RetSQLName("SB8")) +" B8 ON "
			cQuery += "     B8_FILIAL = '"+ SB8->(xFILIAL("SB8")) +"' AND B8_LOTECTL = C9_LOTECTL "
			cQuery += "     AND B8_PRODUTO = C9_PRODUTO AND B8_LOCAL = C9_LOCAL "
			cQuery += "     AND B8.D_E_L_E_T_ = ' ' "
			cQuery += "   LEFT JOIN "+ SB8->(RetSQLName("SC6")) +" C6 ON "
			cQuery += "     C6_FILIAL = '"+ SC6->(xFILIAL("SC6")) +"' AND C6_NUM = C9_PEDIDO "
			cQuery += "     AND C6_ITEM = C9_ITEM AND C6.D_E_L_E_T_ = ' ' "
			cQuery += " WHERE "
			cQuery += "   C9_FILIAL = '"+ SC9->(xFilial("SC9")) +"' AND C9_CARGA = '"+ TDAK->DAK_COD +"' "
			cQuery += "   AND C9_SEQCAR = '"+ TDAK->DAK_SEQCAR +"' AND C9_SEQENT = '"+ TDAI->DAI_SEQUEN +"' "
			cQuery += "   AND C9.D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY "
			cQuery += "   C9_ITEM "
			TcQuery cQuery Alias TSC9 New
			TSC9->(dbGoTop())
			While !TSC9->(EOF())

				oSection3:Cell("C9_ITEM"):SetValue(TSC9->C9_ITEM)
				oSection3:Cell("C9_PRODUTO"):SetValue(TSC9->C9_PRODUTO)
				oSection3:Cell("B1_DESC"):SetValue(TSC9->B1_DESC)
				oSection3:Cell("C9_LOTECTL"):SetValue(TSC9->C9_LOTECTL)
				oSection3:Cell("C9_QTDLIB"):SetValue(TSC9->C9_QTDLIB)
				oSection3:Cell("B1_UM"):SetValue(TSC9->B1_UM)
				oSection3:Cell("D2_PESO"):SetValue(IIf(cPESOCAR=="L",TSC9->B1_PESO,TSC9->B1_PESBRU)*TSC9->C9_QTDLIB)
				oSection3:Cell("D2_PESBRU"):SetValue(TSC9->B1_PESBRU * TSC9->C9_QTDLIB)
				oSection3:Cell("F2_VOLUME1"):SetValue(TSC9->C9_QTDLIB / TSC9->B1_LOTEMUL)
				oSection3:Cell("B8_DTVALID"):SetValue(STOD(TSC9->B8_DTVALID))
				oSection3:Cell("B8_DFABRIC"):SetValue(STOD(TSC9->B8_DFABRIC))
				oSection3:Cell("C6_EMBRET"):SetValue(IF(TSC9->C6_EMBRET=="1","Sim","Não"))
				oSection3:PrintLine()

				TSC9->(dbSkip())
			Enddo
			TSC9->(dbCloseArea())
			oSection3:Finish()
			oSection2:Finish()

			TDAI->(dbSkip())
		Enddo
		TDAI->(dbCloseArea())


		oReport:ENDPAGE()
		TDAK->(dbSkip())
	Enddo
	TDAK->(dbCloseArea())

	oSection1:Finish()
RETURN()
