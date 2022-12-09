//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	

/*/{Protheus.doc} relsaaid
Relatorio de Nota Fiscal de Saida
@type function
@version 12.1.33
@author Anderson Martins
@since 9/12/2022
/*/	

User Function relnsaid()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Cria as defini??es do relat?rio
	oReport := fReportDef()
	
	//Ser? enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Sen?o, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Fun??o que monta a defini??o do relat?rio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Cria??o do componente de impress?o
	oReport := TReport():New(	"relnentr",;		//Nome do Relat?rio
								"Relatorio NF de Entrada",;		//T?tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser? impresso uma p?gina com os par?metros, conforme privil?gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c?digo que ser? executado na confirma??o da impress?o
								)		//Descri??o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a se??o de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a se??o pertence
									"Dados",;		//Descri??o da se??o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser? considerada como principal da se??o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser?o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat?rio
	TRCell():New(oSectDad, "ID_NOTA_FISCAL", "QRY_AUX", "Id_nota_fiscal", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_ITEM", "QRY_AUX", "Nr_item", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ENTRADA_SAIDA", "QRY_AUX", "Entrada_saida", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_DOCUMENTO", "QRY_AUX", "Nr_documento", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_SERIE_DOCUMENTO", "QRY_AUX", "Nr_serie_documento", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_NOTA_FISCAL", "QRY_AUX", "Vl_nota_fiscal", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_CNPJ_CPF", "QRY_AUX", "Nr_cnpj_cpf", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DT_EMISSAO_DOCUMENTO", "QRY_AUX", "Dt_emissao_documento", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NM_PESSOA", "QRY_AUX", "Nm_pessoa", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ID_UF", "QRY_AUX", "Id_uf", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ID_PRODUTO", "QRY_AUX", "Id_produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CD_PRODUTO", "QRY_AUX", "Cd_produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DS_PRODUTO", "QRY_AUX", "Ds_produto", /*Picture*/, 100, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CD_LOTE", "QRY_AUX", "Cd_lote", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ID_CD_FISCAL", "QRY_AUX", "Id_cd_fiscal", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CD_CEST", "QRY_AUX", "Cd_cest", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CD_NCM", "QRY_AUX", "Cd_ncm", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CD_CLASSIFICACAO_TRIB_ESTADUAL", "QRY_AUX", "Cd_classificacao_trib_estadual", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_TOTAL", "QRY_AUX", "Vl_total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_DESCONTO", "QRY_AUX", "Vl_desconto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_ICMS", "QRY_AUX", "Aliq_icms", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_BASE_CALCULO_ICMS", "QRY_AUX", "Vl_base_calculo_icms", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_ICMS", "QRY_AUX", "Vl_icms", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_BASE_CALCULO_ICMS_ST", "QRY_AUX", "Vl_base_calculo_icms_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_ICMS_ST", "QRY_AUX", "Vl_icms_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_BASE_CALC_ICMS_SUBST_RET", "QRY_AUX", "Vl_base_calc_icms_subst_ret", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_ICMS_SUBST_RET", "QRY_AUX", "Vl_icms_subst_ret", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_FRETE", "QRY_AUX", "Vl_frete", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_SEGURO", "QRY_AUX", "Vl_seguro", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_OUTRAS_DESP", "QRY_AUX", "Vl_outras_desp", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDE", "QRY_AUX", "Qtde", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_UNITARIO", "QRY_AUX", "Vl_unitario", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_IPI", "QRY_AUX", "Aliq_ipi", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_IPI", "QRY_AUX", "Vl_ipi", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ID_PEDIDO", "QRY_AUX", "Id_pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_PESO_LIQUIDO", "QRY_AUX", "Nr_peso_liquido", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_PESO_BRUTO", "QRY_AUX", "Nr_peso_bruto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_CHAVE_ACESSO", "QRY_AUX", "Nr_chave_acesso", /*Picture*/, 44, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OBS", "QRY_AUX", "Obs", /*Picture*/, 31, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_CANC", "QRY_AUX", "Data_canc", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CD_CST_PIS", "QRY_AUX", "Cd_cst_pis", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_BASE_CALCULO_PIS", "QRY_AUX", "Vl_base_calculo_pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_PIS", "QRY_AUX", "Aliq_pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDE_PIS", "QRY_AUX", "Qtde_pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_ALIQ_PIS", "QRY_AUX", "Vl_aliq_pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_PIS", "QRY_AUX", "Vl_pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CD_CST_COFINS", "QRY_AUX", "Cd_cst_cofins", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_BASE_CALCULO_COFINS", "QRY_AUX", "Vl_base_calculo_cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_COFINS", "QRY_AUX", "Aliq_cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDE_COFINS", "QRY_AUX", "Qtde_cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_ALIQ_COFINS", "QRY_AUX", "Vl_aliq_cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_COFINS", "QRY_AUX", "Vl_cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_BASE_CALCULO_PIS_ST", "QRY_AUX", "Vl_base_calculo_pis_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_PIS_PERC_ST", "QRY_AUX", "Aliq_pis_perc_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDE_VENDIDA_PIS_ST", "QRY_AUX", "Qtde_vendida_pis_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_PIS_REAIS_ST", "QRY_AUX", "Aliq_pis_reais_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_PIS_ST", "QRY_AUX", "Vl_pis_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_BASE_CALCULO_COFINS_ST", "QRY_AUX", "Vl_base_calculo_cofins_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_COFINS_PERC_ST", "QRY_AUX", "Aliq_cofins_perc_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VL_COFINS_ST", "QRY_AUX", "Vl_cofins_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDE_VENDIDA_CONFIS_ST", "QRY_AUX", "Qtde_vendida_confis_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ALIQ_COFINS_REAIS_ST", "QRY_AUX", "Aliq_cofins_reais_st", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DM_MODALIDADE_FRETE", "QRY_AUX", "Dm_modalidade_frete", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DS_ENDERECO_DESTINATARIO", "QRY_AUX", "Ds_endereco_destinatario", /*Picture*/, 80, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_ENDERECO_DESTINATARIO", "QRY_AUX", "Nr_endereco_destinatario", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DS_COMPL_END_DESTINATARIO", "QRY_AUX", "Ds_compl_end_destinatario", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DS_BAIRRO_DESTINATARIO", "QRY_AUX", "Ds_bairro_destinatario", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_CEP_DESTINATARIO", "QRY_AUX", "Nr_cep_destinatario", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DS_MUNICIPIO_DESTINATARIO", "QRY_AUX", "Ds_municipio_destinatario", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DS_PAIS_DESTINATARIO", "QRY_AUX", "Ds_pais_destinatario", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NR_TELEFONE_DESTINATARIO", "QRY_AUX", "Nr_telefone_destinatario", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun??o que imprime o relat?rio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as se??es do relat?rio
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT DISTINCT"		+ STR_PULA
	cQryAux += "D2_DOC 'ID_NOTA_FISCAL',"		+ STR_PULA
	cQryAux += "D2_ITEM 'NR_ITEM',"		+ STR_PULA
	cQryAux += "FT_TIPOMOV 'ENTRADA_SAIDA',"		+ STR_PULA
	cQryAux += "D2_DOC 'NR_DOCUMENTO',"		+ STR_PULA
	cQryAux += "D2_SERIE 'NR_SERIE_DOCUMENTO',"		+ STR_PULA
	cQryAux += "D2_TOTAL 'VL_NOTA_FISCAL',"		+ STR_PULA
	cQryAux += "A1_CGC 'NR_CNPJ_CPF',"		+ STR_PULA
	cQryAux += "SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) 'DT_EMISSAO_DOCUMENTO',"		+ STR_PULA
	cQryAux += "A1_NOME 'NM_PESSOA',"		+ STR_PULA
	cQryAux += "A1_EST 'ID_UF',"		+ STR_PULA
	cQryAux += "D2_COD 'ID_PRODUTO',"		+ STR_PULA
	cQryAux += "D2_COD 'CD_PRODUTO',"		+ STR_PULA
	cQryAux += "B1_DESC 'DS_PRODUTO',"		+ STR_PULA
	cQryAux += "D2_LOTECTL 'CD_LOTE',"		+ STR_PULA
	cQryAux += "D2_CF 'ID_CD_FISCAL',"		+ STR_PULA
	cQryAux += "B1_CEST 'CD_CEST',"		+ STR_PULA
	cQryAux += "B1_POSIPI 'CD_NCM',"		+ STR_PULA
	cQryAux += "D2_CLASFIS 'CD_CLASSIFICACAO_TRIB_ESTADUAL',"		+ STR_PULA
	cQryAux += "D2_TOTAL 'VL_TOTAL',"		+ STR_PULA
	cQryAux += "0 'VL_DESCONTO',"		+ STR_PULA
	cQryAux += "D2_PICM 'ALIQ_ICMS',"		+ STR_PULA
	cQryAux += "D2_BASEICM 'VL_BASE_CALCULO_ICMS',"		+ STR_PULA
	cQryAux += "D2_VALICM 'VL_ICMS',"		+ STR_PULA
	cQryAux += "D2_BRICMS 'VL_BASE_CALCULO_ICMS_ST',"		+ STR_PULA
	cQryAux += "D2_ICMSRET 'VL_ICMS_ST',"		+ STR_PULA
	cQryAux += "0 'VL_BASE_CALC_ICMS_SUBST_RET',"		+ STR_PULA
	cQryAux += "0 'VL_ICMS_SUBST_RET',"		+ STR_PULA
	cQryAux += "D2_VALFRE 'VL_FRETE',"		+ STR_PULA
	cQryAux += "D2_SEGURO 'VL_SEGURO',"		+ STR_PULA
	cQryAux += "D2_DESPESA 'VL_OUTRAS_DESP',"		+ STR_PULA
	cQryAux += "D2_QUANT 'QTDE',"		+ STR_PULA
	cQryAux += "D2_PRCVEN 'VL_UNITARIO',"		+ STR_PULA
	cQryAux += "D2_IPI 'ALIQ_IPI',"		+ STR_PULA
	cQryAux += "D2_VALIPI 'VL_IPI',"		+ STR_PULA
	cQryAux += "D2_PEDIDO 'ID_PEDIDO',"		+ STR_PULA
	cQryAux += "0 'NR_PESO_LIQUIDO',"		+ STR_PULA
	cQryAux += "0 'NR_PESO_BRUTO',"		+ STR_PULA
	cQryAux += "FT_CHVNFE 'NR_CHAVE_ACESSO',"		+ STR_PULA
	cQryAux += "FT_OBSERV 'OBS',"		+ STR_PULA
	cQryAux += "FT_DTCANC 'DATA_CANC',"		+ STR_PULA
	cQryAux += "FT_CSTPIS 'CD_CST_PIS',"		+ STR_PULA
	cQryAux += "FT_BASEPIS 'VL_BASE_CALCULO_PIS',"		+ STR_PULA
	cQryAux += "FT_ALIQPIS 'ALIQ_PIS',"		+ STR_PULA
	cQryAux += "0 'QTDE_PIS',"		+ STR_PULA
	cQryAux += "FT_ALIQPIS 'VL_ALIQ_PIS',"		+ STR_PULA
	cQryAux += "FT_VALPIS 'VL_PIS',"		+ STR_PULA
	cQryAux += "FT_CSTPIS 'CD_CST_COFINS',"		+ STR_PULA
	cQryAux += "FT_BASECOF 'VL_BASE_CALCULO_COFINS',"		+ STR_PULA
	cQryAux += "FT_ALIQCOF 'ALIQ_COFINS',"		+ STR_PULA
	cQryAux += "0 'QTDE_COFINS',"		+ STR_PULA
	cQryAux += "FT_ALIQCOF 'VL_ALIQ_COFINS',"		+ STR_PULA
	cQryAux += "FT_VALCOF 'VL_COFINS',"		+ STR_PULA
	cQryAux += "FT_BASEPIS 'VL_BASE_CALCULO_PIS_ST',"		+ STR_PULA
	cQryAux += "FT_ALIQPIS 'ALIQ_PIS_PERC_ST',"		+ STR_PULA
	cQryAux += "D2_QUANT 'QTDE_VENDIDA_PIS_ST',"		+ STR_PULA
	cQryAux += "FT_ALIQPIS 'ALIQ_PIS_REAIS_ST',"		+ STR_PULA
	cQryAux += "FT_VALPIS 'VL_PIS_ST',"		+ STR_PULA
	cQryAux += "FT_BASECOF 'VL_BASE_CALCULO_COFINS_ST',"		+ STR_PULA
	cQryAux += "FT_ALIQCOF 'ALIQ_COFINS_PERC_ST',"		+ STR_PULA
	cQryAux += "FT_VALCOF 'VL_COFINS_ST',"		+ STR_PULA
	cQryAux += "D2_QUANT 'QTDE_VENDIDA_CONFIS_ST',"		+ STR_PULA
	cQryAux += "FT_ALIQCOF 'ALIQ_COFINS_REAIS_ST',"		+ STR_PULA
	cQryAux += "'' 'DM_MODALIDADE_FRETE',"		+ STR_PULA
	cQryAux += "A1_END 'DS_ENDERECO_DESTINATARIO',"		+ STR_PULA
	cQryAux += "'' 'NR_ENDERECO_DESTINATARIO',"		+ STR_PULA
	cQryAux += "A1_COMPLEM 'DS_COMPL_END_DESTINATARIO',"		+ STR_PULA
	cQryAux += "A1_BAIRRO 'DS_BAIRRO_DESTINATARIO',"		+ STR_PULA
	cQryAux += "A1_CEP 'NR_CEP_DESTINATARIO',"		+ STR_PULA
	cQryAux += "A1_MUN 'DS_MUNICIPIO_DESTINATARIO',"		+ STR_PULA
	cQryAux += "A1_PAIS 'DS_PAIS_DESTINATARIO',"		+ STR_PULA
	cQryAux += "A1_TEL 'NR_TELEFONE_DESTINATARIO'"		+ STR_PULA
	cQryAux += "FROM SD2010"		+ STR_PULA
	cQryAux += "INNER JOIN SA1010 ON"		+ STR_PULA
	cQryAux += "SA1010.D_E_L_E_T_ =''"		+ STR_PULA
	cQryAux += "AND A1_COD = D2_CLIENTE"		+ STR_PULA
	cQryAux += "AND A1_LOJA = D2_LOJA "		+ STR_PULA
	cQryAux += "INNER JOIN SFT010 ON "		+ STR_PULA
	cQryAux += "SFT010.D_E_L_E_T_ =''"		+ STR_PULA
	cQryAux += "AND FT_FILIAL = D2_FILIAL "		+ STR_PULA
	cQryAux += "AND FT_NFISCAL = D2_DOC "		+ STR_PULA
	cQryAux += "AND FT_SERIE = D2_SERIE "		+ STR_PULA
	cQryAux += "AND FT_CLIEFOR = D2_CLIENTE "		+ STR_PULA
	cQryAux += "AND FT_LOJA = D2_LOJA "		+ STR_PULA
	cQryAux += "AND FT_PRODUTO = D2_COD"		+ STR_PULA
	cQryAux += "AND FT_ITEM = D2_ITEM"		+ STR_PULA
	cQryAux += "AND FT_DTCANC = ''"		+ STR_PULA
	cQryAux += "INNER JOIN SB1010 ON "		+ STR_PULA
	cQryAux += "SB1010.D_E_L_E_T_ = ' '"		+ STR_PULA
	cQryAux += "AND B1_COD = D2_COD "		+ STR_PULA
	cQryAux += "WHERE SD2010.D_E_L_E_T_ =' ' AND D2_EMISSAO BETWEEN '202200101' AND '20291231'"		+ STR_PULA
	cQryAux += "ORDER BY D2_DOC, D2_SERIE, D2_ITEM"		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da r?gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a r?gua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return
