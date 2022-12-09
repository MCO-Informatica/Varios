#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao	 ≥ FN440COM ≥ Autor ≥ Adriano Leonardo    ≥ Data ≥ 04/11/2016 ≥±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Ponto de entrada no inÌcio do processamento do rec·lculo de∫±±
±±∫          ≥ comissıes, onde apresento tela para revis„o dos percentuais∫±±
±±∫          ≥ com base nos itens das notas fiscais.                      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ EspecÌfico para a empresa Prozyn               			  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function FN440COM()

Local _aSavArea := GetArea()
Private oFont1	:= TFont():New("Arial",,016,,.F.,,,,,.F.,.F.)
Private _cRotina:= "FN440COM"
Private _cEnter	:= CHR(13) + CHR(10)
Private _aSize	:= MsAdvSize()


If MV_PAR08 <> 3 //A opÁ„o de revis„o dos percentuais somente ser· apresentada quando o rec·lculo for pela emiss„o ou pela emiss„o e baixa ao mesmo tempo, nunca para somente baixa

	// dDataDe := MV_PAR01
	// dDataAte := MV_PAR02
	// cVendDe := MV_PAR03
	// cVendAte := MV_PAR04
	//Processa({|lEnd| AvalMeta(@lEnd)},_cRotina,"Avaliando break even point..."	,.T.) //Chamada de funÁ„o para avaliar se o vendedor atingiu o valor mÌnimo de venda para ter direito a comiss„o

	//If MsgYesNo("Deseja revisar os percentuais de comiss„o, antes do rec·lculo?",_cRotina+"_001")
		MontaTela()
	//EndIf


     
	//Processa({|lEnd| AvalMeta(@lEnd)},_cRotina,"Avaliando break even point..."	,.T.) //Chamada de funÁ„o para avaliar se o vendedor atingiu o valor mÌnimo de venda para ter direito a comiss„o

		
	//EndIf


EndIf


RestArea(_aSavArea)

Return()

Static Function MontaTela()

Private oPanel1
Static oDlg
Public oMSNewGe1

DEFINE MSDIALOG oDlg TITLE "Revis„o de comiss„o por produto" FROM _aSize[1], _aSize[1]  TO _aSize[6], _aSize[5] COLORS 0, 16777215 FONT oFont1  PIXEL

@ 000, 000 MSPANEL oPanel1 PROMPT "" SIZE (_aSize[5]/2), _aSize[4] OF oDlg COLORS 0, 16777215 RAISED
fMSNewGe1()

// Don't change the Align Order
oMSNewGe1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED

Return()

Static Function fMSNewGe1()

Local _cQry 	:= ""
Local _cAlias	:= GetNextAlias()
Local _nCol		:= 1
Local nX		:= 1
// Local _lCriaObj	:= .F.	
aHeaderEx 		:= {}
aColsEx			:= {}    
aFieldFill		:= {}
aFields 		:= {"F2_EMISSAO","A3_NOME","F2_DOC","F2_SERIE","F2_TIPO","F2_CLIENTE","F2_LOJA","NOM_CLI","D2_COD","B1_DESC","D2_QUANT","D2_PRCVEN","D2_TOTAL","COMIS_NEW","REGRA","TP_VEND","MARGEM", "ALIAS", "D2_RECNO", "LOTE"}
aAlterFields	:= {"A3_COMIS"}
nFreeze			:= 0

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)

	If SX3->(DbSeek(Padr(aFields[nX],10)))
		Aadd(aHeaderEx, {AllTrim(SX3->X3_TITULO),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO	,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO	,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	ElseIf aFields[nX]=="NOM_CLI" .And. SX3->(DbSeek("A1_NREDUZ"))
		Aadd(aHeaderEx, {"Cliente/Forn."	,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO	,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO	,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	ElseIf aFields[nX]=="COMIS_NEW" .And. SX3->(DbSeek("A3_COMIS"))
		Aadd(aHeaderEx, {"Comiss„o (%)" ,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO	,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO	,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	ElseIf aFields[nX]=="REGRA" .And. SX3->(DbSeek("A3_CODREG"))
		Aadd(aHeaderEx, {"Regra Comiss"     ,SX3->X3_CAMPO,SX3->X3_PICTURE,1				,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO	,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	ElseIf aFields[nX]=="TP_VEND" .And. SX3->(DbSeek("F2_VEND1"))
		Aadd(aHeaderEx, {"Tp. Vendedor"		,SX3->X3_CAMPO,SX3->X3_PICTURE,1				,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO	,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	ElseIf aFields[nX]=="MARGEM" .And. SX3->(DbSeek("D2_TOTAL"))
		Aadd(aHeaderEx, {"Margem (%)"		,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO	,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO	,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	ElseIf aFields[nX]=="ALIAS" .And. SX3->(DbSeek("F2_VEND1"))
		Aadd(aHeaderEx, {"Alias"			,SX3->X3_CAMPO,SX3->X3_PICTURE,3				,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO	,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	ElseIf aFields[nX]=="D2_RECNO"
		Aadd(aHeaderEx, {"Recno"			,SX3->X3_CAMPO,SX3->X3_PICTURE,21				,0				,SX3->X3_VALID,SX3->X3_USADO,"N"			,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	ElseIf aFields[nX]=="D2_LOTECTL" .And. SX3->(DbSeek("D2_LOTECTL"))
	 	Aadd(aHeaderEx, {"Lote"				,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO	,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO	,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	EndIf
Next nX

//Consulta no banco de dados para retornar todos os itens que geraram financeiro, para revis„o dos percentuais de comiss„o
_cQry += "SELECT TMP.*, B1_DESC, A3_CODREG [REGRA], CASE WHEN D2_TES IN "+FormatIn(SuperGetMV("MV_PRDCOM0",,"627"),";")+" THEN 0 ELSE ISNULL(ZS_PCOMISS,0) END [COMIS_NEW], A3_NOME, A1_NREDUZ [NOM_CLI] FROM ( " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND1 [F2_VEND], D2_COMIS1 [D2_COMIS], 1 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND1<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM1='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND2 [F2_VEND], CASE WHEN D2_TES IN "+FormatIn(SuperGetMV("MV_PRDCOM0",,"627"),";")+" THEN 0 ELSE D2_COMIS2 END [D2_COMIS], 2 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM] " + _cEnter
_cQry += ",'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND2 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND2<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM2='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND3 [F2_VEND], CASE WHEN D2_TES IN "+FormatIn(SuperGetMV("MV_PRDCOM0",,"627"),";")+" THEN 0 ELSE D2_COMIS3 END [D2_COMIS], 3 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND3 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter	
_cQry += "AND SF2.F2_VEND3<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM3='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND4 [F2_VEND], CASE WHEN D2_TES IN "+FormatIn(SuperGetMV("MV_PRDCOM0",,"627"),";")+" THEN 0 ELSE D2_COMIS4 END [D2_COMIS], 4 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND4 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND4<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM4='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += "UNION ALL " + _cEnter
_cQry += "SELECT SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_TIPO, F2_CLIENTE, F2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, F2_VEND5 [F2_VEND], CASE WHEN D2_TES IN "+FormatIn(SuperGetMV("MV_PRDCOM0",,"627"),";")+" THEN 0 ELSE D2_COMIS5 END [D2_COMIS], 5 [TP_VEND], SD2.D2_LOCAL, SD2.D2_TES, SD2.R_E_C_N_O_ [D2_RECNO], SD2.D2_LOTECTL [LOTE], " + _cEnter 
_cQry += "ISNULL((CASE WHEN ((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter 
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100 > 25  " + _cEnter
_cQry += "THEN 25 ELSE ROUND ((((((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))-  " + _cEnter
_cQry += "((ZR_CUSTO1 + (ZR_TTFRT *((ZR_TOTAL + ZR_VALIPI)/ZR_TTITNF)) + ((ZR_TOTAL + ZR_VALIPI) * (ZR_ACRVEN1 / 100))))) /  " + _cEnter
_cQry += "(((ZR_TOTAL + ZR_VALIPI) - (ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))))*100),2)   END),0)   [MARGEM], " + _cEnter
_cQry += "'SD2' [ALIAS] " + _cEnter
_cQry += "FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SD2") + " SD2 WITH (NOLOCK) " + _cEnter
_cQry += "ON SF2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF2.F2_FILIAL='" +  xFilial("SF2") + "' " + _cEnter
_cQry += "AND SD2.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SD2.D2_FILIAL='" +  xFilial("SD2") + "' " + _cEnter
_cQry += "AND SF2.F2_DOC=SD2.D2_DOC " + _cEnter
_cQry += "AND SF2.F2_SERIE=SD2.D2_SERIE " + _cEnter
_cQry += "AND SF2.F2_TIPO=SD2.D2_TIPO " + _cEnter
_cQry += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE " + _cEnter
_cQry += "AND SF2.F2_LOJA=SD2.D2_LOJA " + _cEnter
_cQry += "AND SD2.D2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " " + _cEnter
_cQry += "AND SF2.F2_VEND5 BETWEEN '" + MV_PAR03 + "'	AND '" + MV_PAR04 + "' " + _cEnter
_cQry += "AND SF2.F2_VEND5<>'' " + _cEnter
//_cQry += "AND SD2.D2_BKPCOM5='0' " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZR") + " SZR WITH (NOLOCK) " + _cEnter 
_cQry += "ON SZR.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += "SF2.F2_DOC = SZR.ZR_DOC AND " + _cEnter
_cQry += "SD2.D2_COD = SZR.ZR_CODPROD AND " + _cEnter
_cQry += "SD2.D2_LOTECTL = SZR.ZR_LOTECTL " + _cEnter
_cQry += ") TMP " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) " + _cEnter
_cQry += "ON SB1.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SB1.B1_FILIAL='" +  xFilial("SB1") + "' " + _cEnter
_cQry += "AND TMP.D2_COD=SB1.B1_COD " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) " + _cEnter
_cQry += "ON SA3.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SA3.A3_FILIAL='" + xFilial("SA3") + "' " + _cEnter
_cQry += "AND TMP.F2_VEND=SA3.A3_COD " + _cEnter

//Verifico se o usu·rio escolheu processar somente vendedores ativos ou todos
If MV_PAR10==2
	_cQry += "AND SA3.A3_MSBLQL<>'1' " + _cEnter //Filtro vendedores bloqueados
EndIf

_cQry += "INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + _cEnter
_cQry += "ON SA1.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
_cQry += "AND SA1.A1_COD=TMP.F2_CLIENTE " + _cEnter
_cQry += "AND SA1.A1_LOJA=TMP.F2_LOJA " + _cEnter
_cQry += "AND TMP.F2_TIPO NOT IN ('D','B') " + _cEnter
_cQry += "LEFT JOIN " + RetSqlName("SZS") + " ZS WITH (NOLOCK) " + _cEnter
_cQry += "ON ZS.D_E_L_E_T_<> '*' AND " + _cEnter
_cQry += " TMP.MARGEM>= ZS_MRGMIN AND " + _cEnter
_cQry += " TMP.MARGEM <= ZS_MRGMAX AND " + _cEnter
_cQry += " A3_CODREG = ZS_CODREG " + _cEnter
_cQry += "INNER JOIN " + RetSqlName("SF4") + " SF4 " + _cEnter
_cQry += "ON SF4.D_E_L_E_T_='' " + _cEnter
_cQry += "AND SF4.F4_FILIAL='" + xFilial("SF4") + "' " + _cEnter
_cQry += "AND TMP.D2_TES=SF4.F4_CODIGO " + _cEnter
_cQry += "AND SF4.F4_DUPLIC='S' " + _cEnter
_cQry += "ORDER BY F2_VEND, F2_EMISSAO, F2_SERIE, F2_DOC "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAlias,.T.,.F.)

MemoWrite("RComis_full.txt",_cQry)

dbSelectArea(_cAlias)

While (_cAlias)->(!EOF())
	
	aFieldFill	:= {}	
	
	For _nCol := 1 To Len(aFields)
		If aFields[_nCol]=="F2_EMISSAO"
			_cCpoAux := "STOD(('" + _cAlias + "')->"+aFields[_nCol]+")"
		Else
			_cCpoAux := "('" + _cAlias + "')->"+aFields[_nCol]
		EndIf
		AAdd(aFieldFill, &(_cCpoAux))
	Next
	
	Aadd(aFieldFill, .F.)
	Aadd(aColsEx, aFieldFill)
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbSkip())
EndDo


If Select(_cAlias) > 0
	   dbSelectArea("SD2")
	   dbSetOrder(1)
	   (_cAlias)->( dbGoTop())
            
			While (_cAlias)->(!EOF())
					
					_cCpoBk := "SD2->D2_BKPCOM" + AllTrim(Str((_cAlias)->TP_VEND))
	
					_cCpo 	:= "SD2->D2_COMIS" + AllTrim(Str((_cAlias)->TP_VEND))
		
			    		SD2->(DbGoTo((_cAlias)->D2_RECNO))
						RecLock("SD2",.F.)
						&(_cCpoBk) := &(_cCpo)
					    &(_cCpo):= (_cAlias)->COMIS_NEW
					    SD2->D2_XRGCOMI := (_cAlias)->REGRA
						msunlock()
			

				(_cAlias)->(dbSkip())
			Enddo
			
Endif
	
(_cAlias)->(dbCloseArea())


oMSNewGe1 := MsNewGetDados():New( 000, 000, 033, (_aSize[5]/2)-008, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,nFreeze, Len(aColsEx), "U_RFN440()", "", "AllwaysTrue", oPanel1, aHeaderEx, aColsEx)
oMSNewGe1:oBrowse:lUseDefaultColors := .F.
oMSNewGe1:oBrowse:SetBlkBackColor({|| GETDCLR(oMSNewGe1:aCols,oMSNewGe1:nAt,oMSNewGe1:aHeader)})


Return()

User Function RFN440()

Local _lRet		:= .T.
// Local _nLin		:= oMSNewGe1:oBrowse:nAt
Local _cAlias	:= oMSNewGe1:aCols[oMSNewGe1:oBrowse:nAt,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[1])=="Alias"			})]
Local _nRecno	:= oMSNewGe1:aCols[oMSNewGe1:oBrowse:nAt,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[1])=="Recno"			})]
Local _nNumVend	:= oMSNewGe1:aCols[oMSNewGe1:oBrowse:nAt,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[1])=="Tp. Vendedor"	})]
// Local _ncomiss	:= oMSNewGe1:aCols[oMSNewGe1:oBrowse:nAt,aScan(oMSNewGe1:aHeader,{|x|Alltrim(x[1])=="Comiss„o (%)"	})]

dbSelectArea(_cAlias)
dbGoTo(_nRecno)

RecLock(_cAlias,.F.)
	
	_cCpoBk := "SD2->D2_BKPCOM" + AllTrim(Str(_nNumVend))
	
	_cCpo := "SD2->D2_COMIS" + AllTrim(Str(_nNumVend))     
	
	_cCporeg := "SD2->D2_XRGCOMI" 
	
	//If &(_cCpoBk)==0
		&(_cCpoBk) := &(_cCpo)
	//EndIf
		&(_cCpo) := &(ReadVar())
	    &(_cCporeg):= "9999"
(_cAlias)->(MsUnlock())

Return(_lRet)

Static Function GETDCLR(aLinha,nLinha,aHeader)

Local nCor1 := CLR_YELLOW	//Amarelo
Local nCor2 := CLR_WHITE	//Branco

//Se o percentual de comiss„o for zero, altero a cor da linha para destacar das demais comissıes
If oMSNewGe1:aCols[nLinha,aScan(aHeader,{|x|Alltrim(x[2])=="A3_COMIS"})] == 0
	nRet := nCor1
Else
	nRet := nCor2
EndIf

Return(nRet)

Static Function AvalMeta()

Local _cAliasSA3:= GetNextAlias()
Local _nVend	:= 1

//Restauro os percentuais originais de comiss„o para reavaliaÁ„o do break even point (ponto de equilibrio)
For _nVend := 1 To 5
	
	_cUpd := "UPDATE " + RetSqlName("SD2") + " SET D2_COMIS" + AllTrim(Str(_nVend)) + "=CASE WHEN D2_BKPCOM" + AllTrim(Str(_nVend)) + " > 0 THEN D2_BKPCOM" + AllTrim(Str(_nVend)) + " ELSE D2_COMIS" + AllTrim(Str(_nVend)) + " END, D2_BKPCOM" + AllTrim(Str(_nVend)) + "=0  FROM " + RetSqlName("SD2") + " SD2 "
	_cUpd += "INNER JOIN " + RetSqlName("SF2") + " SF2 "
	_cUpd += "ON SF2.D_E_L_E_T_='' "
	_cUpd += "AND SF2.F2_FILIAL='" + xFilial("SF2") + "' "
	_cUpd += "AND SD2.D_E_L_E_T_='' "
	_cUpd += "AND SD2.D2_FILIAL='" + xFilial("SD2") + "' "
	_cUpd += "AND SF2.F2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " "
	_cUpd += "AND SF2.F2_DOC=SD2.D2_DOC "
	_cUpd += "AND SF2.F2_SERIE=SD2.D2_SERIE "
	_cUpd += "AND SF2.F2_TIPO=SD2.D2_TIPO "
	_cUpd += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE "
	_cUpd += "AND SF2.F2_LOJA=SD2.D2_LOJA "
	_cUpd += "AND SF2.F2_VALFAT>0 "
	_cUpd += "AND SF2.F2_TIPO NOT IN ('D','B') "
	_cUpd += "AND SF2.F2_VEND" + AllTrim(Str(_nVend)) + " BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	_cUpd += "AND (SELECT COUNT(*) FROM " + RetSqlName("SE3") + " SE3 WHERE SE3.D_E_L_E_T_='' AND SE3.E3_FILIAL='" + xFilial("SE3") + "' AND SE3.E3_NUM=SF2.F2_DOC AND SE3.E3_SERIE=SF2.F2_SERIE AND SE3.E3_CODCLI=SF2.F2_CLIENTE AND SE3.E3_LOJA=SF2.F2_LOJA AND SE3.E3_DATA<>'' AND SE3.E3_PREFIXO=SE3.E3_SERIE AND SE3.E3_VEND=SF2.F2_VEND" + AllTrim(Str(_nVend)) + ")=0 "
	
	If TCSQLExec(_cUpd) < 0
		MsgStop("[TCSQLError] " + TCSQLError(),_cRotina+"_002")
	EndIf
Next
		
_cQry := "SELECT A3_COD, A3_BEP, "
_cQry += "	( "
_cQry += "		SELECT ISNULL(SUM(F2_VALFAT),0) FROM " + RetSqlName("SF2") + " SF2 WITH (NOLOCK) "
_cQry += "		WHERE SF2.D_E_L_E_T_='' "
_cQry += "		AND SF2.F2_FILIAL='" + xFilial("SF2") + "' "
_cQry += "		AND SF2.F2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " "
_cQry += "		AND SF2.F2_TIPO NOT IN ('D','B') "
_cQry += "		AND (SF2.F2_VEND1=SA3.A3_COD OR SF2.F2_VEND2=SA3.A3_COD OR SF2.F2_VEND3=SA3.A3_COD OR SF2.F2_VEND4=SA3.A3_COD OR SF2.F2_VEND5=SA3.A3_COD) "
_cQry += "	) [F2_VALFAT] "
_cQry += "FROM " + RetSqlName("SA3") + " SA3 WITH (NOLOCK) "
_cQry += "WHERE SA3.D_E_L_E_T_='' "
_cQry += "AND SA3.A3_FILIAL='" + xFilial("SA3") + "' "
_cQry += "AND SA3.A3_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasSA3,.T.,.F.)

dbSelectArea(_cAliasSA3)

While (_cAliasSA3)->(!EOF())
	
	If (_cAliasSA3)->F2_VALFAT < (_cAliasSA3)->A3_BEP .And. (_cAliasSA3)->F2_VALFAT>0
		For _nVend := 1 To 5
			
			_cUpd := "UPDATE " + RetSqlName("SD2") + " SET D2_BKPCOM" + AllTrim(Str(_nVend)) + "=(CASE WHEN D2_BKPCOM" + AllTrim(Str(_nVend)) + "=0 THEN D2_COMIS" + AllTrim(Str(_nVend)) + " ELSE D2_BKPCOM" + AllTrim(Str(_nVend)) + " END), D2_COMIS" + AllTrim(Str(_nVend)) + "=0  FROM " + RetSqlName("SD2") + " SD2 "
			_cUpd += "INNER JOIN " + RetSqlName("SF2") + " SF2 "
			_cUpd += "ON SF2.D_E_L_E_T_='' "
			_cUpd += "AND SF2.F2_FILIAL='" + xFilial("SF2") + "' "
			_cUpd += "AND SD2.D_E_L_E_T_='' "
			_cUpd += "AND SD2.D2_FILIAL='" + xFilial("SD2") + "' "
			_cUpd += "AND SF2.F2_EMISSAO BETWEEN " + DTOS(MV_PAR01) + " AND " + DTOS(MV_PAR02) + " "
			_cUpd += "AND SF2.F2_DOC=SD2.D2_DOC "
			_cUpd += "AND SF2.F2_SERIE=SD2.D2_SERIE "
			_cUpd += "AND SF2.F2_TIPO=SD2.D2_TIPO "
			_cUpd += "AND SF2.F2_CLIENTE=SD2.D2_CLIENTE "
			_cUpd += "AND SF2.F2_LOJA=SD2.D2_LOJA "
			_cUpd += "AND SF2.F2_VALFAT>0 "
			_cUpd += "AND SF2.F2_TIPO NOT IN ('D','B') "
			_cUpd += "AND SF2.F2_VEND" + AllTrim(Str(_nVend)) + "='" + (_cAliasSA3)->A3_COD + "' "
			_cUpd += "AND (SELECT COUNT(*) FROM " + RetSqlName("SE3") + " SE3 WHERE SE3.D_E_L_E_T_='' AND SE3.E3_FILIAL='" + xFilial("SE3") + "' AND SE3.E3_NUM=SF2.F2_DOC AND SE3.E3_SERIE=SF2.F2_SERIE AND SE3.E3_CODCLI=SF2.F2_CLIENTE AND SE3.E3_LOJA=SF2.F2_LOJA AND SE3.E3_DATA<>'' AND SE3.E3_PREFIXO=SE3.E3_SERIE AND SE3.E3_VEND=SF2.F2_VEND" + AllTrim(Str(_nVend)) + ")=0 "
			
			If TCSQLExec(_cUpd) < 0
				MsgStop("[TCSQLError] " + TCSQLError(),_cRotina+"_003")
			EndIf
		Next
	EndIf
	
	dbSelectArea(_cAliasSA3)
	dbSkip()
EndDo

Return()          
