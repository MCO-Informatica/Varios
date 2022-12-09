#Include 'Protheus.ch'
#include 'REPORT.ch'
/*
Tiago Pereira

Este fonte tem por objetivo, imprimir o relatório de data base de Férias
*/
User Function RFerias()
	local oReport 
	Local oSection 
	Local cNomeRel := "DtBasFérias" 
	Local cTitulo := "Relatório Data Base Férias" 
	Local cDescri := "Este relatório imprime a relacao de Funcionarios" 
	Local cPergSX1 := "" 
	Local bAcao := {| oReport | T03Impressao(oReport)} 

	Private cString := "SRA"
	dbSelectArea(cString)
	(cString)->(Dbsetorder(1))
	(cString)->(DbGotop())

	cPergSX1       := "DTBFERIAS"
	If TRepInUse() 
		DEFINE REPORT oReport NAME cNomeRel TITLE cTitulo PARAMETER ; 
		cPergSX1 ACTION bAcao DESCRIPTION cDescri 

		DEFINE SECTION oSection OF oReport TITLE cTitulo TABLE "SRA","CTT","SRJ"

		DEFINE CELL oCelula NAME "RA_FILIAL"  OF oSection                        ALIAS "SRA"
		DEFINE CELL oCelula NAME "RA_MAT"     OF oSection                        ALIAS "SRA" 
		DEFINE CELL oCelula NAME "RA_NOME"    OF oSection                        ALIAS "SRA" 
		DEFINE CELL oCelula NAME "CTT_DESC01" OF oSection Title "Centro Custo"   ALIAS "CTT"
		DEFINE CELL oCelula NAME "RJ_DESC"    OF oSection Title "Funcao"         ALIAS "SRJ"
		DEFINE CELL oCelula NAME "RA_ADMISSA" OF oSection                        ALIAS "SRA"
		DEFINE CELL oCelula NAME "RF_DATABAS" OF oSection Title                  ALIAS "SRF"
		DEFINE CELL oCelula NAME "RF_DATABAS" OF oSection Title "Per Aquisitivo" ALIAS "SRF"

		oReport:PrintDialog() 
	EndIf 

Return

Static Function T03Impressao(oReport) 
	Local oSection := oReport:Section(1)
	local cQuery   :="" 
	Local cSituacao := MV_PAR07 // Situação do Funcionário
	Local cCategoria:= MV_PAR08


	DbSelectArea("CTT") 
	CTT->(DbSetOrder(1))
	CTT->(DbGoTop())

	DbSelectArea("SRJ") 
	SRJ->(DbSetOrder(1))	
	SRJ->(DbGoTop())		

	DbSelectArea("SRA") 
	SRA->(dbSetOrder(1))
	SRA->(DbGoTop())

	cQuery:= "Select Count(*) as Total"
	cQuery +=" from " + RetSqlName("SRA") + " SRA"
	cQuery +=" Inner join " + RetSqlName("CTT") + " CTT"
	cQuery +=" on RA_CC = CTT_CUSTO"
	cQuery +=" Inner join " + RetSqlName("SRJ") + " SRJ"
	cQuery +=" on RA_CODFUNC = RJ_FUNCAO"
	cQuery +=" Inner join " + RetSqlName("SRF") + " SRF"
	cQuery +=" on RA_MAT = RF_MAT"
	cQuery +=" Where RA_FILIAL >= '" + MV_PAR01 + "' and RA_FILIAL <= '" + MV_PAR02 + "' and"
	cQuery +=" RA_CC >= '" + MV_PAR03 + "' and RA_CC <= '" + MV_PAR04 + "' and"
	cQuery +=" RA_MAT >= '" + MV_PAR05 + "' and RA_MAT <= '" + MV_PAR06 + "' and"
	cQuery +=" SRA.D_E_L_E_T_ <> '*' and CTT.D_E_L_E_T_ <> '*' And "
	cQuery +=" SRF.D_E_L_E_T_ <> '*' and SRJ.D_E_L_E_T_ <> '*' "

	QRY := GetNextAlias()

	cQuery := ChangeQuery(cQuery)                                     

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), QRY , .F., .T.)

	oReport:SetMeter((QRY)->TOTAL)


	oSection:Init() 

	oReport:nFontBody :=7
	While !SRA->( Eof() ) 

		If oReport:Cancel() 
			Exit 
		EndIf
		If (SRA->RA_CATFUNC $ cCategoria)
			If(SRA->RA_SITFOLH $ cSituacao)

				If SRA->RA_FILIAL >= MV_PAR01 .And. SRA->RA_FILIAL <= MV_PAR02
					If SRA->RA_CC >= MV_PAR03 .And. SRA->RA_FILIAL <= MV_PAR04 
						if SRA->RA_MAT >= MV_PAR05 .And. SRA->RA_FILIAL <= MV_PAR06 
							CTT->( DbSeek(xFilial("CTT") + 	SRA->RA_CC) ) 
							SRJ->( DbSeek(xFilial("SRJ") + 	SRA->RA_CODFUNC))  
							SRF->( DbSeek(xFilial("SRF") + 	SRA->RA_MAT))  

							// adiciona 366 dias à data base férias

							//	oReport:SkipLine()	
							oSection:PrintLine() 
							oSection:Cell("RF_DATABAS"):SetValue(SRF->RF_DATABAS + 366)
						Endif  
					Endif
				Endif
			Endif
		Endif	
		SRA->( DbSkip() ) 	 
		oReport:IncMeter() 
	End 
	oSection:Finish() 
	SRA->(dbClosearea())
	SRJ->(dbClosearea())
	CTT->(dbClosearea())
	(QRY)->(dbclosearea())

Return