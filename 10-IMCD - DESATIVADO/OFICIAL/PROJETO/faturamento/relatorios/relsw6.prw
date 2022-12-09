#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR01   ºAutor  ³ Luiz Alberto   º Data ³ 03/10/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão de Processos IMCD     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ IMCD Brasil                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCOMR01()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nUsers := GETMV("MV_XUSRPRC")
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg    := "RCOMR01"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If RetCodUsr() $ nUsers 

Else
	Alert("usuario não autorizado!")
	Return()
endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes/preparacao para impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ReportDef()
oReport:PrintDialog()

Return Nil 


Static Function ReportDef()

oReport := TReport():New("RCOMR01","Consulta de Processo de Importação",cPerg,{|oReport| PrintReport(oReport)},"Impressão de cadastro de Processo de importação em TReport")
oReport:SetLandscape(.T.)

oSecCab := TRSection():New( oReport , "Processo", {"QRY"} )

TRCell():New( oSecCab, "W6_HAWB"     , "QRY")
TRCell():New( oSecCab, "W2_PO_DT"    , "QRY")
TRCell():New( oSecCab, "W6_DT_HAWB"    , "QRY")
TRCell():New( oSecCab, "W6_PO_NUM"      , "QRY")
TRCell():New( oSecCab, "W6_DESP"     , "QRY")
TRCell():New( oSecCab, "Y5_NOME"    , "QRY")
TRCell():New( oSecCab, "A2_COD"    , "QRY")
TRCell():New( oSecCab, "A2_NOME"      , "QRY")  
TRCell():New( oSecCab, "A2_LOJA"      , "QRY")
TRCell():New( oSecCab, "W6_DT_ETD"     , "QRY")
TRCell():New( oSecCab, "W6_DT_ETA"    , "QRY")
TRCell():New( oSecCab, "W6_LOCAL"    , "QRY")
TRCell():New( oSecCab, "W6_LOCALN"      , "QRY")
TRCell():New( oSecCab, "W6_TIPODES"     , "QRY")    
TRCell():New( oSecCab, "W6_IMPORT"     , "QRY")    
TRCell():New( oSecCab, "W6_PRVDESE"    , "QRY")
TRCell():New( oSecCab, "W6_DT_ENCE"     , "QRY")
TRCell():New( oSecCab, "W6_DT_EMB"    , "QRY")
TRCell():New( oSecCab, "W6_VIA_TRA"    , "QRY")
TRCell():New( oSecCab, "W6_ORIGEM"      , "QRY")
TRCell():New( oSecCab, "W6_DEST"     , "QRY")
TRCell():New( oSecCab, "W6_PAISPRO"    , "QRY")
TRCell():New( oSecCab, "W6_DT_AVE"    , "QRY")
TRCell():New( oSecCab, "W6_TIPOCON"      , "QRY")
TRCell():New( oSecCab, "W6_HOUSE"      , "QRY")
TRCell():New( oSecCab, "W6_MAWB"    , "QRY")
TRCell():New( oSecCab, "W6_PRCARGA"      , "QRY")
TRCell():New( oSecCab, "W6_IDENTVE"    , "QRY")
TRCell():New( oSecCab, "W6_CHEG"      , "QRY")
TRCell():New( oSecCab, "W6_AGENTE"    , "QRY")
TRCell():New( oSecCab, "W6_PESO_BR"      , "QRY")
TRCell():New( oSecCab, "W6_PESOL"    , "QRY")
TRCell():New( oSecCab, "W6_TX_US_D"      , "QRY")
TRCell():New( oSecCab, "W6_VLMLEMN"    , "QRY")
TRCell():New( oSecCab, "W6_FOB_TOT"      , "QRY")
TRCell():New( oSecCab, "W6_FOB_GER"    , "QRY")
TRCell():New( oSecCab, "W6_NF_ENT"      , "QRY")
TRCell():New( oSecCab, "W6_SE_NF"      , "QRY")
TRCell():New( oSecCab, "W6_DT_NF"    , "QRY")
TRCell():New( oSecCab, "W6_VL_NF"      , "QRY")
TRCell():New( oSecCab, "D1_DTDIGIT"      , "QRY")
TRCell():New( oSecCab, "W6_PRVENTR"    , "QRY")
TRCell():New( oSecCab, "W6_DTREG_D"      , "QRY")
TRCell():New( oSecCab, "W6_DI_NUM"      , "QRY")
TRCell():New( oSecCab, "W6_DT"      , "QRY")
TRCell():New( oSecCab, "W6_DT_DESE"      , "QRY")
TRCell():New( oSecCab, "W6_DT_DTA"      , "QRY")


//TRFunction():New(/*Cell*/             ,/*cId*/,/*Function*/,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/,/*Section*/)
TRFunction():New(oSecCab:Cell("W6_HAWB"),/*cId*/,"COUNT"     ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSecCab)

Return Nil


Static Function PrintReport(oReport)

Local cQuery     := ""

Pergunte(cPerg,.F.)

cQuery += " SELECT " + CRLF
cQuery += " W6_HAWB,W2_PO_DT,W6_DT_HAWB,W6_PO_NUM,W6_DESP,Y5_NOME,A2_COD, A2_NOME, A2_LOJA, W6_DT_ETD,W6_DT_ETA,W6_LOCAL,W6_LOCALN,W6_TIPODES,W6_IMPORT,W6_PRVDESE,W6_DT_ENCE,W6_DT_EMB,W6_VIA_TRA,W6_ORIGEM,W6_DEST,W6_PAISPRO,W6_DT_AVE,W6_TIPOCON,W6_HOUSE,W6_MAWB,W6_PRCARGA,W6_IDENTVE,W6_CHEG,W6_AGENTE,W6_PESO_BR,W6_PESOL,W6_TX_US_D,W6_VLMLEMN,W6_FOB_TOT,W6_FOB_GER,W6_NF_ENT,W6_SE_NF,W6_DT_NF,W6_VL_NF,D1_DTDIGIT,W6_PRVENTR,W6_DTREG_D,W6_DI_NUM,W6_DT,W6_DT_DESE,W6_DT_DTA  " + CRLF
cQuery += "  FROM " + RetSqlName("SW6") + " SW6 " + CRLF
cQuery += "  INNER JOIN  " + RetSqlName("SW2") + " SW2 " + CRLF
cQuery += "  ON  W6_PO_NUM = W2_PO_NUM AND W6_FILIAL = '" + xFilial ("SW6") + "' AND  W2_FILIAL = '" + xFilial ("SW2") + "' " + CRLF
cQuery += "  INNER JOIN  " + RetSqlName("SA2") + " SA2 " + CRLF
cQuery += "  ON  A2_COD  = W2_FORN AND A2_LOJA = W2_FORLOJ AND A2_FILIAL = '" + xFilial ("SA2") + "' " + CRLF
cQuery += "  INNER JOIN  " + RetSqlName("SD1") + " SD1 " + CRLF
cQuery += "  ON  D1_CONHEC  = W2_PO_NUM AND W2_FORN = D1_FORNECE AND W2_FORLOJ  = D1_LOJA AND D1_FILIAL = '" + xFilial ("SD1") + "' " + CRLF
cQuery += "  INNER JOIN  " + RetSqlName("SY5") + " SY5 " + CRLF
cQuery += "  ON  W6_DESP  = Y5_COD AND Y5_FILIAL = '" + xFilial ("SY5") + "' " + CRLF

cQuery += " WHERE " + CRLF
cQuery += "   W6_DT_EMB    BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' " + CRLF
cQuery += "   AND W6_PO_NUM    BETWEEN '" + mv_par03+ "' AND '" + mv_par04 + "' " + CRLF
cQuery += "   AND SW6.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "   AND SW2.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "   AND SD1.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "   AND SA2.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "   AND SY5.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "   GROUP BY W6_HAWB,W2_PO_DT,W6_DT_HAWB,W6_PO_NUM,W6_DESP,Y5_NOME,A2_COD, A2_NOME, A2_LOJA, W6_DT_ETD,W6_DT_ETA,W6_LOCAL,W6_LOCALN,W6_TIPODES,W6_IMPORT,W6_PRVDESE,W6_DT_ENCE,W6_DT_EMB,W6_VIA_TRA,W6_ORIGEM,W6_DEST,W6_PAISPRO,W6_DT_AVE,W6_TIPOCON,W6_HOUSE,W6_MAWB,W6_PRCARGA,W6_IDENTVE,W6_CHEG,W6_AGENTE,W6_PESO_BR,W6_PESOL,W6_TX_US_D,W6_VLMLEMN,W6_FOB_TOT,W6_FOB_GER,W6_NF_ENT,W6_SE_NF,W6_DT_NF,W6_VL_NF,D1_DTDIGIT,W6_PRVENTR,W6_DTREG_D,W6_DI_NUM,W6_DT,W6_DT_DESE,W6_DT_DTA "

cQuery := ChangeQuery(cQuery)          





If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQuery New Alias "QRY"

oSecCab:BeginQuery()
oSecCab:EndQuery({{"QRY"},cQuery})
oSecCab:Print()

Return Nil