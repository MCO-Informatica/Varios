#Include 'Protheus.ch'
/*
Tiago Pereira TOTVS
Este fonte tem por objetivo gerar uma planilha em Excel com os dados refentes à hora extra, definidos pelo usuário Kleber

*/

User Function HrExtra()
	Local cPerg     := "HORAEXTRA" 
	Local aCabec    :={}

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis utilizadas para parametros                         ³
	³ mv_par01        //  Filial  De                               ³
	³ mv_par02        //  Filial  Ate                              ³
	³ mv_par03        //  Centro de Custo De                       ³
	³ mv_par04        //  Centro de Custo Ate                      ³
	³ mv_par05        //  Matricula De                             ³
	³ mv_par06        //  Matricula Ate                            ³
	³ mv_par07        //  Superior Imediato De                     ³
	³ mv_par08        //  Superior Imediato Ate                    ³
	³ mv_par09        //  Data De                                  ³
	³ mv_par10        //  Data Ate                                 ³ 
	³ mv_par11        //  Situação                                 ³ 
	³ mv_par12        //  Categoria                                ³ 
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Pergunte(cPerg)         

	// Cabeçalho do Excel, contendo os campos
	aadd(aCabec, "Filial")
	aadd(aCabec, "Matricula")
	aadd(aCabec, "Nome")
	aadd(aCabec, "Centro de Custo")
	aadd(aCabec, "Superior Imediato")
	aadd(aCabec, "Data")
	aadd(aCabec, "Evento")
	aadd(aCabec, "Quantidade Calculada") 

	Processa( {||GeraXLS(aCabec) }, OemToAnsi("Gerando Planilha"), "Geracao da Planilha" )

	Return

	*---------------------*
Static Function GeraXLS(aCabec)
	*---------------------* 
	Local cQuery    :=""  
	Local aDados    := {}
	Local cSituacao := MV_PAR11
	Local cCategoria:= MV_PAR12 

	//Consulta
	cQuery := " Select RA_FILIAL, RA_MAT, RA_NOME, RA_CATFUNC, RA_SITFOLH, CTT_DESC01, RA_XSUPERI,ZC_NOME, PH_DATA, P9_DESC, PH_QUANTC"  
	cQuery += " FROM " + RetSqlName("SRA") + " SRA"
	cQuery += " INNER JOIN " + RetSqlName("CTT") + " CTT"  
	cQuery += " ON RA_CC = CTT_CUSTO"
	cQuery += " INNER JOIN " + RetSqlName("SPH") + " SPH"
	cQuery += " ON RA_MAT = PH_MAT"   
	cQuery += " INNER JOIN " + RetSqlName("SP9") + " SP9"
	cQuery += " ON P9_CODIGO = PH_PD" 
	cQuery += " INNER JOIN " + RetSqlName("SZC") + " SZC"
	cQuery += " ON RA_XSUPERI = ZC_MAT"  

	// condição
	cQuery += " WHERE SRA.D_E_L_E_T_ <>'*' AND"
	cQuery += " CTT.D_E_L_E_T_ <>'*' AND"
	cQuery += " SPH.D_E_L_E_T_ <>'*' AND"
	cQuery += " SP9.D_E_L_E_T_ <>'*' AND"
	cQuery += " (PH_PD = 108 Or PH_PD = 109) AND"
	cQuery += " SZC.D_E_L_E_T_ <>'*' AND"
	cQuery += " RA_FILIAL  >= '" + MV_PAR01      + "' and RA_FILIAL <= '" + MV_PAR02 + "' and"
	cQuery += " RA_CC      >= '" + MV_PAR03      + "' and RA_CC     <= '" + MV_PAR04 + "' and"
	cQuery += " RA_MAT     >= '" + MV_PAR05      + "' and RA_MAT    <= '" + MV_PAR06 + "' and"
	cQuery += " RA_XSUPERI >= '" + MV_PAR07      + "' and RA_XSUPERI <= '" + MV_PAR08 + "' and"
	cQuery += " PH_DATA    >= '" +DToc(MV_PAR09) + "' and PH_DATA    <= '" + DToc(MV_PAR10) + "' "


	// Ordenação FILIAL + SUPERIOR IMEDIATO + MATRICULA
	cQuery += " ORDER BY RA_FILIAL, ZC_NOME, RA_MAT"   

	QRY    := GetNextAlias()

	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), QRY, .T., .F.)

	While !(QRY)->( EOF() )
		If ((QRY)->RA_CATFUNC $ cCategoria)
			If((QRY)->RA_SITFOLH $ cSituacao) 
				aadd(aDados, {(QRY)->RA_FILIAL,(QRY)->RA_MAT,(QRY)->RA_NOME,(QRY)->CTT_DESC01,;
				(QRY)->ZC_NOME,SToD((QRY)->PH_DATA), (QRY)->P9_DESC, (QRY)->PH_QUANTC })                                                                            
			Endif                                                                          
		Endif
		(QRY)->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
	EndDo

	DbCloseArea(QRY)		    

	DlgToExcel({ {"ARRAY", "", aCabec, aDados} })

Return