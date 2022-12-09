#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"


/*/{Protheus.doc} User Function RFIN002
	Relatorio de logs dos pedidos de vendas
	@type  Function
	@author Vitor Kalomencoukovas
	@since 05/03/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
user function RFIN002()

	local oReport as object
		
	if TRepInUse()
		oReport := ReportDef()
		If oReport == Nil
			Return( Nil )
		EndIf
			
		oReport:PrintDialog()
	EndIf
Return( Nil )

/*/{Protheus.doc} nomeStaticFunction ReportDef
	(long_description)
	@type  Static Function
	@author Vitor Kalomencoukovas
	@since 05/03/2020
	@version version
	@param 
	@return oReport
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function ReportDef()

	Local oReport
	Local oSection1
	local cHelp := "Rel. Análise de Crédito"
	Local cPerg := "RFIN002"

	oReport := TReport():New("Rel. Análise de Crédito",'Rel. Análise de Crédito',cPerg,{|oReport| ReportPrint( oReport ),'Rel. Análise de Crédito'},cHelp) 
	oReport:SetPortrait() //Define a orientacao default de pagina do relatorio como retrato.
	
	oSection1 := TRSection():New( oReport, 'Rel. Análise de Crédito', {'SA1','TMP'})

			
	TRCell():New( oSection1, 'CODIGO'	   ,'TMP', 		'CODIGO',		"@!"       ,06)
	TRCell():New( oSection1, 'LOJA'        ,'TMP', 		'LOJA',		    "@!"       ,02)
	TRCell():New( oSection1, 'CLIENTE'     ,'TMP', 		'CLIENTE',      "@!"	   ,06)
	TRCell():New( oSection1, 'CNPJ_CPF'    ,'TMP', 		'CNPJ_CPF',	    "@!"       ,15)
	TRCell():New( oSection1, 'LIM_CRED'    ,'TMP', 		'LIM_CRED',		PesqPict("SA1","A1_LC"),20)
	TRCell():New( oSection1, 'VENC_CRED'   ,'TMP', 		'VENC_CRED',	"@!"       ,20)
	TRCell():New( oSection1, 'MOEDA_CREDITO','TMP',     'MOEDA_CREDITO',"@!"       ,04)
	TRCell():New( oSection1, 'SLD_ABER'    ,'TMP', 		'SLD_ABER' ,    PesqPict("SA1","A1_SALDUP"),20)
	TRCell():New( oSection1, 'COND_PAG'    ,'TMP', 		'COND_PAG' ,    "@!"       ,03)
	TRCell():New( oSection1, 'DESCRI_PAG'  ,'TMP', 		'DESCRI_PAG',   "@!"       ,50)
	TRCell():New( oSection1, 'ULT_COMPRA'  ,'TMP', 		'ULT_COMPRA',   "@!"       ,10)
	TRCell():New( oSection1, 'MAI_COMPRA'  ,'TMP', 		'MAI_COMPRA',   PesqPict("SA1","A1_MCOMPRA"),20)
	TRCell():New( oSection1, 'ULT_VALOR'  ,'TMP', 		'ULT_VALOR',    PesqPict("SF2","F2_VALBRUT"),20)
	TRCell():New( oSection1, 'STATUS'     ,'TMP', 		'STATUS',       "@!",10)

								
Return( oReport )

/*/{Protheus.doc} nomeStaticFunction ReportPrint
	(long_description)
	@type  Static Function
	@author Vitor Kalomencoukovas
	@since 05/03/2020
	@version version
	@param oReport
	@return
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function ReportPrint( oReport )

	Local oSection1 := oReport:Section(1)
	Local cQuery := ""
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)	

	IF Select("TMP") > 0
		TMP->(dbCloseArea())
	Endif


cQuery:= "SELECT A1_COD CODIGO, "
cQuery+= "A1_LOJA LOJA, "
cQuery+= "A1_NOME CLIENTE, "
cQuery+= "A1_CGC AS CNPJ_CPF, "
cQuery+= "A1_LC LIM_CRED, "
cQuery+= " CASE "
cQuery+= "   WHEN TRIM(A1_VENCLC) IS NULL THEN ' ' "
cQuery+= "   ELSE SUBSTR(A1_VENCLC, 7, 2)||'/'||SUBSTR(A1_VENCLC, 5, 2)||'/'||SUBSTR(A1_VENCLC, 1, 4) "
cQuery+= " END AS VENC_CRED, "
cQuery+= " A1_MOEDALC AS MOEDA_CREDITO, "
cQuery+= "A1_SALDUP SLD_ABER, "
cQuery+= "A1_COND COND_PAG, "
cQuery+= "NVL(E4_DESCRI,' ') as DESCRI_PAG, "
cQuery+= "CASE WHEN TRIM(A1_ULTCOM) IS NULL THEN ' ' ELSE SUBSTR(A1_ULTCOM,7,2)||'/'||SUBSTR(A1_ULTCOM,5,2)||'/'||SUBSTR(A1_ULTCOM,1,4) END AS ULT_COMPRA, "
cQuery+= "A1_MCOMPRA AS MAI_COMPRA, "
cQuery+= "NVL((SELECT F2_VALBRUT FROM "+RetSqlName("SF2")+" SF2 WHERE F2_CLIENT = A1_COD AND F2_LOJA = A1_LOJA AND F2_EMISSAO = A1_ULTCOM AND SF2.D_E_L_E_T_ <> '*' AND rownum = 1 ),0) AS ULT_VALOR, "
cQuery+= "CASE A1_MSBLQL WHEN '2' THEN 'ATIVO' WHEN '1' THEN 'INATIVO' END AS STATUS "
cQuery+= "FROM "+RETSQLNAME('SA1')+" SA1 "
cQuery+= "LEFT JOIN "+RETSQLNAME('SE4')+" SE4 ON (SA1.A1_COND = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ <> '*') "
cQuery+= "WHERE SA1.D_E_L_E_T_ <> '*' " 

IF EMPTY(MV_PAR03)
	cQuery+= " "
ELSEIF MV_PAR03 = 2 
	cQuery+= " AND  A1_MSBLQL = '1' "
ELSEIF MV_PAR03 = 1
	cQuery+= " AND A1_MSBLQL <> '1' "
ENDIF

If Empty(MV_PAR01).OR.Empty(MV_PAR02)
	cQuery+= ""
Else
	cQuery+= "AND A1_COD >= '"+MV_PAR01+"' AND A1_COD <= '"+MV_PAR02+"'"
EndIf

TCQUERY cQuery NEW ALIAS TMP

	While TMP->(!EOF())

		IF oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()


			oSection1:cell("CODIGO"):setValue(TMP->CODIGO)
			oSection1:Cell("CODIGO"):SetAlign("LEFT")

			oSection1:cell("LOJA"):setValue(TMP->LOJA)
			oSection1:Cell("LOJA"):SetAlign("LEFT")

			oSection1:cell("CLIENTE"):setValue(TMP->CLIENTE)
			oSection1:Cell("CLIENTE"):SetAlign("LEFT")

			oSection1:cell("CNPJ_CPF"):setValue(TMP->CNPJ_CPF)
			oSection1:Cell("CNPJ_CPF"):SetAlign("LEFT")

			oSection1:cell("LIM_CRED"):setValue(TMP->LIM_CRED)
			oSection1:Cell("LIM_CRED"):SetAlign("LEFT")

			oSection1:cell("VENC_CRED"):setValue(TMP->VENC_CRED)
			oSection1:Cell("VENC_CRED"):SetAlign("LEFT")

			oSection1:cell("MOEDA_CREDITO"):setValue(TMP->MOEDA_CREDITO)
			oSection1:Cell("MOEDA_CREDITO"):SetAlign("LEFT")

			oSection1:cell("SLD_ABER"):setValue(TMP->SLD_ABER)
			oSection1:Cell("SLD_ABER"):SetAlign("LEFT")
 
			oSection1:cell("COND_PAG"):setValue(TMP->COND_PAG)
			oSection1:Cell("COND_PAG"):SetAlign("LEFT")

			oSection1:cell("DESCRI_PAG"):setValue(TMP->DESCRI_PAG)
			oSection1:Cell("DESCRI_PAG"):SetAlign("LEFT")

			oSection1:cell("ULT_COMPRA"):setValue(TMP->ULT_COMPRA)
			oSection1:Cell("ULT_COMPRA"):SetAlign("LEFT")

			oSection1:cell("MAI_COMPRA"):setValue(TMP->MAI_COMPRA)
			oSection1:Cell("MAI_COMPRA"):SetAlign("LEFT")

			oSection1:cell("ULT_VALOR"):setValue(TMP->ULT_VALOR)
			oSection1:Cell("ULT_VALOR"):SetAlign("LEFT")

			oSection1:cell("STATUS"):setValue(TMP->STATUS)
			oSection1:Cell("STATUS"):SetAlign("LEFT")

			oSection1:PrintLine()
			TMP->(DBSKIP( ))

	enddo
	TMP->(DBCLOSEAREA())
Return( Nil )