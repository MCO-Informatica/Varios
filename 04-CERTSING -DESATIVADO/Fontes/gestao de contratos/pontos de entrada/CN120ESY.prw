#Include 'Protheus.ch'

#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '

//-----------------------------------------------------------------------
// Rotina | CN120ESY  | Autor | Rafael Beghini    | Data | 27.06.2016
//-----------------------------------------------------------------------
// Descr. | P.E para customizar a query da consulta especifica do 
//        | contrato à Medição . 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CN120ESY()
	Local cSQL  := ''
	Local cTRB  := ''
	Local cGrps := ''
	Local cCod  := RetCodUsr()
	Local nX    := 0
	Local aGrp  := {}
	
	
	aGrp := UsrRetGrp(UsrRetName(cCod))
					
	For nX:=1 to len(aGrp)
		cGrps += "'"+aGrp[nX]+"',"
	Next
	cGrps := SubStr(cGrps,1,len(cGrps)-1)
	
	/*
	//----> USUARIOS QUE NAO FAZEM PARTE DO GRUPO JURIDICO/CONTRATO GCT
	If !cGrps$"000291"
		cSQL += " SELECT CN9_NUMERO, MAX(CN9_REVISA) AS CN9_REVISA "
		cSQL += "   FROM " + RetSqlName("CN9") + " CN9 , "+ RetSqlName("CNN") + " CNN, "+ RetSqlName("CNA") + " CNA, "+ RetSqlName("CNL") + " CNL " 
		cSQL += "  WHERE CN9_FILIAL   = '" + xFilial("CN9") + "' "
		cSQL += "    AND CN9_SITUAC   = '05' AND "
		cSQL += " CNN_FILIAL       = '" + xFilial("CNN") + "' AND "
		cSQL += " CNN_CONTRA       = CN9_NUMERO AND "
		cSQL += " CNA_FILIAL       = '" + xFilial("CNA") + "' AND "
		cSQL += " CNA_CONTRA       = CN9_NUMERO AND "
		cSQL += " CNL_FILIAL       = '" + xFilial("CNL") + "' AND "
		cSQL += " CNA_TIPPLA       = CNL_CODIGO AND "
		cSQL += " CNL_DESCRI       NOT LIKE '%FIXA%' AND "
		cSQL += " CN9_VLDCTR IN(' ','1') AND (CNN.CNN_USRCOD   = '"+ cCod +"'" 
		If len(aGrp) > 0
			cSQL += " OR CNN.CNN_GRPCOD IN ("+ cGrps +"))"
		Else
			cSQL += ")"
		EndIf 
		cSQL += " AND CNN.D_E_L_E_T_   = '' "
		cSQL += " AND CN9.D_E_L_E_T_   = '' " 
		cSQL += " AND CNA.D_E_L_E_T_   = '' " 
		cSQL += " AND CNL.D_E_L_E_T_   = '' " 
		cSQL += " GROUP BY CN9_NUMERO "
		cSQL += " ORDER BY CN9_NUMERO,CN9_REVISA "

	//----> USUARIOS QUE FAZEM PARTE DO GRUPO JURIDICO/CONTRATO GCT
	Else*/
		cSQL += " SELECT CN9_NUMERO, MAX(CN9_REVISA) AS CN9_REVISA "
		cSQL += "   FROM " + RetSqlName("CN9") + " CN9 , "+ RetSqlName("CNN") + " CNN " 
		cSQL += "  WHERE CN9_FILIAL   = '" + xFilial("CN9") + "' "
		cSQL += "    AND CN9_SITUAC   = '05' AND "
		cSQL += " CNN_FILIAL       = '" + xFilial("CNN") + "' AND "
		cSQL += " CNN_CONTRA       = CN9_NUMERO AND "
		cSQL += " CN9_VLDCTR IN(' ','1') AND (CNN.CNN_USRCOD   = '"+ cCod +"'" 
		If len(aGrp) > 0
			cSQL += " OR CNN.CNN_GRPCOD IN ("+ cGrps +"))"
		Else
			cSQL += ")"
		EndIf 
		cSQL += " AND CNN.D_E_L_E_T_   = '' AND "
		cSQL += " CN9.D_E_L_E_T_   = '' " 
		cSQL += " GROUP BY CN9_NUMERO "
		cSQL += " ORDER BY CN9_NUMERO,CN9_REVISA "
	//EndIf

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	             
	//Alert(cSQL)

	IF (cTRB)->( EOF() ) .And. !cGrps$"000291"
		MsgInfo( cFONT+"ATENÇÃO" + cNOFONT + cFONTOK + "<br><br>Usuário sem direito a transação selecionada ou a planilha é fixa."+; 
				  "<br>Entre em contato com o gestor de contratos."+ cNOFONT,"PE-CN120ESY | Consulta Medição" )
	Else
		(cTRB)->( dbCloseArea() )
	EndIF
Return( cSQL )

