#Include 'Protheus.ch'
/*
Tiago Pereira TOTVS
Este fonte tem por objetivo gerar uma planilha em Excel com os dados refentes à hora extra, definidos pelo usuário Kleber

*/


User Function Absente()
	Local cPerg     := "ABSENTEISMO" 
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
	³ mv_par07        //  Data De                                  ³
	³ mv_par08        //  Data Ate                                 ³ 
	³ mv_par09        //  Situação                                 ³ 
	³ mv_par10        //  Categoria                                ³ 
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
	aadd(aCabec, "Data")
	aadd(aCabec, "Evento")
	aadd(aCabec, "Desc Evento")
	aadd(aCabec, "Quantidade Calculada") 
	aadd(aCabec, "Abono")
	aadd(aCabec, "Desc Abono") 
	aadd(aCabec, "Quantidade Abonada") 

	Processa( {||GeraXLS(aCabec) }, OemToAnsi("Gerando Planilha"), "Geracao da Planilha" )

	Return

	*---------------------*
Static Function GeraXLS(aCabec)
	*---------------------* 
	Local cQuery    :=""  
	Local aDados    := {}
	Local cSituacao := MV_PAR09
	Local cCategoria:= MV_PAR10 

	//Consulta    
	cQuery :="Select RA_FILIAL, RA_MAT, RA_NOME, RA_CATFUNC,RA_SITFOLH,CTT_DESC01,"
	cQuery += "PH_DATA, PH_PD, P9_DESC, PH_QUANTC, PH_ABONO,P6_DESC, PH_QTABONO"

	cQuery += " From  " + RetSqlName("SRA") + " SRA"
	cQuery += " Inner Join " + RetSqlName("CTT") + " CTT"
	cQuery += " On RA_CC = CTT_CUSTO"
	cQuery += " Inner Join " + RetSqlName("SPH") + " SPH"
	cQuery += " On RA_MAT = PH_MAT"
	cQuery += " Inner Join " + RetSqlName("SP6") + " SP6"
	cQuery += " On PH_ABONO = P6_CODIGO"
	cQuery += " Inner Join " + RetSqlName("SP9") + " SP9"
	cQuery += " On PH_PD = P9_CODIGO"

	cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' And
	cQuery += " CTT.D_E_L_E_T_ <>'*' And"
	cQuery += " SPH.D_E_L_E_T_ <>'*' And"
	cQuery += " SP6.D_E_L_E_T_ <>'*' And"
	cQuery += " SP9.D_E_L_E_T_ <>'*' And ("
	cQuery += " PH_PD = 466 OR "
	cQuery += " PH_PD = 476 OR"
	cQuery += " PH_PD = 468 OR"
	cQuery += " PH_PD = 109 OR"
	cQuery += " PH_PD = 108 OR"
	cQuery += " PH_PD = 023) "

	cQuery += " ORDER BY RA_FILIAL, RA_MAT, PH_DATA, PH_PD"

	cQuery := ChangeQuery(cQuery) 

	QRY    := GetNextAlias()

	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), QRY, .T., .F.)

	While !(QRY)->( EOF() )
		If ((QRY)->RA_CATFUNC $ cCategoria)
			If((QRY)->RA_SITFOLH $ cSituacao) 

				aadd(aDados, {(QRY)->RA_FILIAL,(QRY)->RA_MAT,(QRY)->RA_NOME,(QRY)->CTT_DESC01,;  
				SToD((QRY)->PH_DATA), (QRY)->PH_PD, (QRY)->P9_DESC, (QRY)->PH_QUANTC,(QRY)->PH_ABONO,;
				(QRY)->P6_DESC,(QRY)->PH_QTABONO }) 

			Endif                                                                          
		Endif
		(QRY)->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
	EndDo

	(QRY)->(DbCloseArea())		    

	DlgToExcel({ {"ARRAY", "", aCabec, aDados} })

Return