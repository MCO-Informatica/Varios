#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"

/*/{Protheus.doc} User Function RFAT099
	Relatorio de logs dos pedidos de vendas
	@type  Function
	@author Weskley Silva
	@since 04/12/2019
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
user function RFAT099()

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
	@author Weskley Silva
	@since 04/12/2019
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
	local cHelp := "Log Pedidos de Vendas"
	Local cPerg := "RFAT099"

	oReport := TReport():New("Logs Pedidos de vendas",'Log Pedidos de vendas',cPerg,{|oReport| ReportPrint( oReport ),'Logs Pedidos de vendas'},cHelp) 
	oReport:SetPortrait() //Define a orientacao default de pagina do relatorio como retrato.
	
	oSection1 := TRSection():New( oReport, 'Logs Pedido de Vendas', {'SZ4','TMP'})
			
	TRCell():New( oSection1, 'FILIAL'	   ,'TMP', 		'FILIAL',		"@!"       ,08)
	TRCell():New( oSection1, 'PEDIDO'      ,'TMP', 		'PEDIDO',		"@!"       ,06)
	TRCell():New( oSection1, 'ITEMPED'     ,'TMP', 		'ITEMPED',    	"@!"	   ,06)
	TRCell():New( oSection1, 'CLIENTE'     ,'TMP', 		'CLIENTE',      "@!"	   ,06)
	TRCell():New( oSection1, 'LOJA'        ,'TMP', 		'LOJA',         "@!"       ,04)
	TRCell():New( oSection1, 'DATAPED'     ,'TMP', 		'DATAPED',		"@!"       ,08)
	TRCell():New( oSection1, 'DATALIB' 	   ,'TMP', 		'DATALIB' ,	    "@!"       ,08)
	TRCell():New( oSection1, 'RESP' 	   ,'TMP', 		'RESP' ,	    "@!"       ,40)
	TRCell():New( oSection1, 'USUARIO'     ,'TMP', 		'USUARIO',	    "@!"       ,06)
	TRCell():New( oSection1, 'NOME_USER'   ,'TMP', 		'NOME_USER' ,	"@!"       ,40)
	TRCell():New( oSection1, 'DATA_'       ,'TMP', 		'DATA_' ,    	"@!"       ,08)
	TRCell():New( oSection1, 'HORA'        ,'TMP', 		'HORA' ,    	"@!"       ,20)
	TRCell():New( oSection1, 'EVENTO'      ,'TMP', 		'EVENTO' ,    	"@!"       ,50)
	TRCell():New( oSection1, 'MOTIVO'      ,'TMP', 		'MOTIVO' ,    	"@!"       ,50)
	TRCell():New( oSection1, 'CODALTE'     ,'TMP', 		'CODALTE' ,    	"@!"       ,10)
	TRCell():New( oSection1, 'DESCRICAO'   ,'TMP', 		'DESCRICAO',   	"@!"       ,150)

								
Return( oReport )

/*/{Protheus.doc} nomeStaticFunction ReportPrint
	(long_description)
	@type  Static Function
	@author Weskley Silva
	@since 04/12/2019
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
	Local cNome := ""
	Local cMemo := ""
	Local nX := 0
	Local aQueb := {}

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)	

	IF Select("TMP") > 0
		TMP->(dbCloseArea())
	Endif


	cQuery := " SELECT Z4_FILIAL AS FILIAL, Z4_PEDIDO AS PEDIDO, "  
	cQuery += " Z4_ITEPED AS ITEMPED,Z4_CLIENTE AS CLIENTE,Z4_LOJA AS LOJA, " 
	cQuery += " Z4_DATAPED AS DATAPED,Z4_DATALIB AS DATALIB,Z4_RESP AS RESP, "
	cQuery += " Z4_USUARIO AS USUARIO,Z4_DATA,"
	cQuery += " CASE WHEN TRIM(Z4_DATA) IS NULL THEN ' ' ELSE SUBSTR(Z4_DATA,7,2)||'/'||SUBSTR(Z4_DATA,5,2)||'/'||SUBSTR(Z4_DATA,1,4) END AS DATA_,"
	cQuery += " Z4_HORA AS HORA , Z4_EVENTO AS EVENTO,Z4_MOTIVO AS MOTIVO, Z4_CODALTE AS CODALTE "
	cQuery += " FROM "+RetSqlName("SZ4")+"  "
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND Z4_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "

	TCQUERY cQuery NEW ALIAS TMP

	While TMP->(!EOF())

		IF oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()

	DbSelectArea("SZ4")
	DbSetorder(3)

	cMemo := ""
	cDtent := ""
	aQueb := {}

	If dbseek(TMP->FILIAL+TMP->PEDIDO+TMP->Z4_DATA+TMP->HORA+TMP->ITEMPED) 
		cCod   := SZ4->Z4_CODALTE
		cMemo  := MSMM( cCod, 80 )
		cDtent := StrTran(cMemo,"Dt. Entrega:","Dt. Entrega:")
		If !EMPTY(cDtent)
			aQueb  := StrTokArr2(cMemo, CHR(13))
		endif
	Endif

	if len(aQueb) > 0
		for nX := 1 to len(aQueb) - 1 
			cNome := UsrRetName(TMP->USUARIO) 
 			
			oSection1:cell("FILIAL"):setValue(TMP->FILIAL)
			oSection1:Cell("FILIAL"):SetAlign("LEFT")

			oSection1:cell("PEDIDO"):setValue(TMP->PEDIDO)
			oSection1:Cell("PEDIDO"):SetAlign("LEFT")

			oSection1:cell("ITEMPED"):setValue(TMP->ITEMPED)
			oSection1:Cell("ITEMPED"):SetAlign("LEFT")

			oSection1:cell("CLIENTE"):setValue(TMP->CLIENTE)
			oSection1:Cell("CLIENTE"):SetAlign("LEFT")

			oSection1:cell("LOJA"):setValue(TMP->LOJA)
			oSection1:Cell("LOJA"):SetAlign("LEFT")

			oSection1:cell("DATAPED"):setValue(TMP->DATAPED)
			oSection1:Cell("DATAPED"):SetAlign("LEFT")

			oSection1:cell("DATALIB"):setValue(TMP->DATALIB)
			oSection1:Cell("DATALIB"):SetAlign("LEFT")

			oSection1:cell("RESP"):setValue(TMP->RESP)
			oSection1:Cell("RESP"):SetAlign("LEFT")

			oSection1:cell("USUARIO"):setValue(TMP->USUARIO)
			oSection1:Cell("USUARIO"):SetAlign("LEFT")

			oSection1:cell("NOME_USER"):setValue(cNome)
			oSection1:Cell("NOME_USER"):SetAlign("LEFT")

			oSection1:cell("DATA_"):setValue(TMP->DATA_)
			oSection1:Cell("DATA_"):SetAlign("LEFT")

			oSection1:cell("HORA"):setValue(TMP->HORA)
			oSection1:Cell("HORA"):SetAlign("LEFT")

			oSection1:cell("EVENTO"):setValue(TMP->EVENTO)
			oSection1:Cell("EVENTO"):SetAlign("LEFT")

			oSection1:cell("MOTIVO"):setValue(TMP->MOTIVO)
			oSection1:Cell("MOTIVO"):SetAlign("LEFT")

			oSection1:cell("CODALTE"):setValue(TMP->CODALTE)
			oSection1:Cell("CODALTE"):SetAlign("LEFT")

			oSection1:cell("DESCRICAO"):setValue(aQueb[nX])
			oSection1:Cell("DESCRICAO"):SetAlign("LEFT")	

				
		oSection1:PrintLine()	
		next 
		TMP->(DBSKIP()) 
	else 

			oSection1:cell("FILIAL"):setValue(TMP->FILIAL)
			oSection1:Cell("FILIAL"):SetAlign("LEFT")

			oSection1:cell("PEDIDO"):setValue(TMP->PEDIDO)
			oSection1:Cell("PEDIDO"):SetAlign("LEFT")

			oSection1:cell("ITEMPED"):setValue(TMP->ITEMPED)
			oSection1:Cell("ITEMPED"):SetAlign("LEFT")

			oSection1:cell("CLIENTE"):setValue(TMP->CLIENTE)
			oSection1:Cell("CLIENTE"):SetAlign("LEFT")

			oSection1:cell("LOJA"):setValue(TMP->LOJA)
			oSection1:Cell("LOJA"):SetAlign("LEFT")

			oSection1:cell("DATAPED"):setValue(TMP->DATAPED)
			oSection1:Cell("DATAPED"):SetAlign("LEFT")

			oSection1:cell("DATALIB"):setValue(TMP->DATALIB)
			oSection1:Cell("DATALIB"):SetAlign("LEFT")

			oSection1:cell("RESP"):setValue(TMP->RESP)
			oSection1:Cell("RESP"):SetAlign("LEFT")

			oSection1:cell("USUARIO"):setValue(TMP->USUARIO)
			oSection1:Cell("USUARIO"):SetAlign("LEFT")

			oSection1:cell("NOME_USER"):setValue(cNome)
			oSection1:Cell("NOME_USER"):SetAlign("LEFT")

			oSection1:cell("DATA_"):setValue(TMP->DATA_)
			oSection1:Cell("DATA_"):SetAlign("LEFT")

			oSection1:cell("HORA"):setValue(TMP->HORA)
			oSection1:Cell("HORA"):SetAlign("LEFT")

			oSection1:cell("EVENTO"):setValue(TMP->EVENTO)
			oSection1:Cell("EVENTO"):SetAlign("LEFT")

			oSection1:cell("MOTIVO"):setValue(TMP->MOTIVO)
			oSection1:Cell("MOTIVO"):SetAlign("LEFT")

			oSection1:cell("CODALTE"):setValue(TMP->CODALTE)
			oSection1:Cell("CODALTE"):SetAlign("LEFT")

			oSection1:cell("DESCRICAO"):setValue(cMemo)
			oSection1:Cell("DESCRICAO"):SetAlign("LEFT")

			oSection1:PrintLine()			
		TMP->(DBSKIP()) 
	endif
	enddo
	TMP->(DBCLOSEAREA())
Return( Nil )