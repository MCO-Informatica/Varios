#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*****************************************************************************/
/* Este programa Emite um Relatório de Reposição de Estoque - Com Sobra
/*****************************************************************************/
User Function DHESTR01()

Private oReport := NIL
Private cPerg := "DHESTR01T"                                                                                            
Private cPrevi := ""

Private oExcel, oReport

Private cArquivo := "Relatorio.xls"
Private cAba  	 := "Previsoes"
Private cTabela	 := "Relatorio"
Private cPath 	 := "C:\TEMP\"

//AjustaSX1(cPerg)

Pergunte(cPerg,.T.)

If MV_PAR12 == 1
	oExcel := FWMSEXCEL():New()
	oExcel:AddworkSheet(cTabela)
	oExcel:AddTable(cTabela, cAba)
EndIf

oReport := ReportDef(oReport)
oReport:PrintDialog()

If MV_PAR12 == 1

If !Empty(oExcel:aWorkSheet)

    oExcel:Activate()
    oExcel:GetXMLFile(cArquivo)
 
    CpyS2T("\SYSTEM\"+cArquivo, cPath)

    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
    oExcelApp:SetVisible(.T.)

EndIf
	
EndIf

Return

/*****************************************************************************/
Static Function ReportDef(oReport)  

Local oSection := NIL

oReport  := TReport():New("DHESTR01","Reposição de Estoque",cPerg,{|oReport| PrintReport(oReport, oSection)},"Reposição de Estoque")

oSection := TRSection():New(oReport,"Estoque",{"SB1"},{"Codigo+Descricao","Descricao+Codigo"})

TRCell():New(oSection,"B1_COD","SB1")
TRCell():New(oSection,"B1_DESC","SB1") 

Pergunte(cPerg,.F.)

Return oReport

/*****************************************************************************/
Static Function PrintReport(oReport,oSection)

Local nCount   := 0
Local oTFont   := TFont():New('Courier new',,-12,.T.)
Local oTFont1  := TFont():New('Courier new',,-12,.T.,.T.)
Local oTFont2  := TFont():New('Courier new',,-14,.T.,.T.)	
Local nLin 	   := 000
Local nCol	   := 0020
Local nSaldo   := 0
Local nItem    := 0
Local cOk 	   := "Saldo Suficiente"   

If Select("TMPB1B2") > 0
	TMPSB1->( dbCloseArea() )
EndIf

cQry := "SELECT DISTINCT(B1_COD), B1_LOCPAD, B1_DESC, B1_EMIN, B1_DHCATEG, B1_UM, B1_DHABSM "+CRLF
cQry += "FROM "+RetSqlName("SB1")+" SB1 "+CRLF
cQry += "WHERE "+CRLF
cQry += "B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
cQry += "AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+CRLF
cQry += "AND B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+CRLF
//cQry += "AND B1_UCOM <> ''"+CRLF
If MV_PAR06 == 1 .Or. MV_PAR06 == 2
	cQry += "AND (B1_DHCATEG = '"+IIF(MV_PAR06 == 1, "1" , "2" )+"' OR B1_DHCATEG = '3') "+CRLF
Endif
If MV_PAR05 == 1 .Or. MV_PAR05 == 2
	cQry += "AND B1_DHABSM = '"+IIF(MV_PAR05 == 1 , "T" , "F")+"'  "+CRLF
Endif

cQry += "AND SB1.D_E_L_E_T_ = ' ' "+CRLF
cQry += "GROUP BY B1_COD, B1_LOCPAD, B1_DESC, B1_EMIN, B1_DHCATEG, B1_UM, B1_DHABSM "+CRLF

IF oReport:Section(1):nOrder == 1
	cQry += "ORDER BY B1_COD, B1_DESC "+CRLF
Else
	cQry += "ORDER BY B1_DESC, B1_COD "+CRLF
Endif                                 
cQry := ChangeQuery(cQry)
TcQuery cQry NEW ALIAS "TMPB1B2"

nCount := 0 

Count to nCount

If MV_PAR12 == 1
	oExcel:AddColumn(cTabela, cAba,"Codigo"		,1,1,.F.)
	oExcel:AddColumn(cTabela, cAba,"Unidade"	,1,1,.F.)
	oExcel:AddColumn(cTabela, cAba,"Produto"	,1,1,.F.)
	oExcel:AddColumn(cTabela, cAba,"Previsao"	,1,1,.F.)
EndIf

oReport:SetMeter(nCount)               

oReport:StartPage()
nLin := 260 
oReport:Say ( nLin-050 ,  nCol ,"__________________________________________________________________________________________________________________________________", oTFont , ,, )                                                       
oReport:Say ( nLin, nCol+0020,"Produto",oTFont1,,, )   // CODIDO+DESCRICAO
oReport:Say ( nLin, nCol+0415,"UN ",oTFont1,,, )
oReport:Say ( nLin, nCol+0635,"Descrição",oTFont1,,, )  // C6_QTDVEN
oReport:Say ( nLin, nCol+2100,"Previsão",oTFont1,,, )  // C6_PRUNIT
oReport:Say ( nLin+020 ,  nCol ,"__________________________________________________________________________________________________________________________________", oTFont , ,, )                                                       
nLin += 70
DbSelectArea("TMPB1B2")
dbGoTop()	
While TMPB1B2->(!Eof())
	oReport:IncMeter(1)
	
	If oReport:Cancel()
		Exit
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³So imprime o produto se ele ja tiver entrada ou saldo inicial ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SD1->(DbSetOrder(2))
	SB9->(DbSetOrder(1))
	If (SD1->(DbSeek(xFilial("SD1")+ TMPB1B2->B1_COD ))) .OR. (SB9->(DbSeek(xFilial("SB9")+ TMPB1B2->B1_COD )))
		nSldExtra 	:= 0
		nSaldo		:= 0	

		If nLin >= 3100
			oReport:Say ( 3215, nCol+1080, cUserName , oTFont1,,, )
		    //oReport:Say ( 3215, nCol+2100, "Pag.: "+transform(oReport:oPrint:nPage-1,"9999"), oTFont1,,, ) 
			oReport:EndPage()		                                        	

			nLin := 260 

			oReport:Say ( nLin-050 ,  nCol ,"_______________________________________________________________________________________________________________________________", oTFont , ,, )                                                       
			oReport:Say ( nLin, nCol+0020,"Produto",oTFont1,,, )   // CODIDO+DESCRICAO 
			oReport:Say ( nLin, nCol+0415,"UN ",oTFont1,,, )
			oReport:Say ( nLin, nCol+0635,"Descrição",oTFont1,,, )  // C6_QTDVEN
			oReport:Say ( nLin, nCol+2100,"Previsão",oTFont1,,, )  // C6_PRUNIT
			oReport:Say ( nLin+020 ,  nCol ,"_______________________________________________________________________________________________________________________________", oTFont , ,, )                                                       
			nLin += 070
		Endif
		
		cQrySb2 := "SELECT	SB2.B2_COD , SB2.B2_LOCAL " + Chr(13)
		cQrySb2 += "FROM 	" + RetSqlName("SB2") + " SB2 " + Chr(13)
		cQrySb2 += "WHERE	SB2.D_E_L_E_T_ = '' "
		cQrySb2 += "		AND SB2.B2_FILIAL = '" + xFilial("SB2") + "' "
		cQrySb2 += "		AND SB2.B2_COD = '" + TMPB1B2->B1_COD + "' "
		cQrySb2 += "		AND SB2.B2_LOCAL <> '" + TMPB1B2->B1_LOCPAD + "' "
		cQrySb2 += "		AND SB2.B2_LOCAL BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' "
		
		If Select("TMPSALDO") > 0
			TMPSALDO->(DbCloseArea())
		Endif
		
		Tcquery cQrySb2 New Alias "TMPSALDO"	
		
		nRegs 		:= 0
		nSldExtra 	:= 0
		
		Count to nRegs
		
		If nRegs > 0
			TMPSALDO->(DbGoTop())
			
			While !TMPSALDO->(Eof())
				DbSelectArea("SB2")
				DbSetOrder(1)
				If DbSeek(xFilial("SB2") + TMPSALDO->B2_COD + TMPSALDO->B2_LOCAL)
					nSldExtra += SaldoSb2() - SB2->B2_QPEDVEN		
				Endif
			
				TMPSALDO->(DbSkip())
			Enddo
			
			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2") + TMPB1B2->B1_COD + TMPB1B2->B1_LOCPAD)
				nSaldo += SaldoSb2() - SB2->B2_QPEDVEN		
			Endif
		Else
			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2") + TMPB1B2->B1_COD + TMPB1B2->B1_LOCPAD)
				nSaldo += SaldoSb2() - SB2->B2_QPEDVEN		
			Endif		
		Endif
		
		nSldTotal := nSaldo + nSldExtra
		
		If (nSaldo > TMPB1B2->B1_EMIN) .And. MV_PAR07 == 1

			If MV_PAR12 == 1
				oExcel:AddRow(cTabela, cAba,{TMPB1B2->B1_COD,Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES")),Alltrim(TMPB1B2->B1_DESC),"Saldo Suficiente no Armazem Padrao "})
			EndIf

	  		oReport:Say( nLin,nCol+0020,TMPB1B2->B1_COD+" - "+Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES"))+" - "+Alltrim(TMPB1B2->B1_DESC),oTFont,,, ) 
	  		oReport:Say( nLin,nCol+1600,"Saldo Suficiente no Armazem Padrao " + TMPB1B2->B1_LOCPAD,oTFont,,,)
		    nLin +=050
	  		nItem++
	  	Elseif (nSaldo < TMPB1B2->B1_EMIN) .And. (nSldTotal > TMPB1B2->B1_EMIN)

			If MV_PAR12 == 1
				oExcel:AddRow(cTabela, cAba,{TMPB1B2->B1_COD,Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES")),Alltrim(TMPB1B2->B1_DESC),"Saldo Suficiente Considerando outros Armazens"})
			EndIf

	  		oReport:Say( nLin,nCol+0020,TMPB1B2->B1_COD+" - "+Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES"))+" - "+Alltrim(TMPB1B2->B1_DESC),oTFont,,, ) 
	  		oReport:Say( nLin,nCol+1600,"Saldo Suficiente Considerando outros Armazens",oTFont,,,)
		    nLin +=050
	  		nItem++
	  	Elseif (nSaldo <= TMPB1B2->B1_EMIN) .And. (nSldTotal <= TMPB1B2->B1_EMIN)
	  		If MV_PAR10 == 1
		  		// Verifica se serao analisadas outras filiais
		  		aFiliais 	:= STRTOKARR(MV_PAR11,",")
				cOldEmp		:= cEmpAnt
				cOldFil		:= cFilAnt
				nSldExtra 	:= 0
				nSaldo		:= 0					
				
				For _N1 := 1 to Len(aFiliais)
					If cFilAnt <> Alltrim(aFiliais[_N1])
						cFilAnt := Alltrim(aFiliais[_N1])
						
						cQrySb2 := "SELECT	SB2.B2_COD , SB2.B2_LOCAL " + Chr(13)
						cQrySb2 += "FROM 	" + RetSqlName("SB2") + " SB2 " + Chr(13)
						cQrySb2 += "WHERE	SB2.D_E_L_E_T_ = '' "
						cQrySb2 += "		AND SB2.B2_FILIAL = '" + xFilial("SB2") + "' "
						cQrySb2 += "		AND SB2.B2_COD = '" + TMPB1B2->B1_COD + "' "
						cQrySb2 += "		AND SB2.B2_LOCAL <> '" + TMPB1B2->B1_LOCPAD + "' "
						cQrySb2 += "		AND SB2.B2_LOCAL BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' "
						
						If Select("TMPSALDO") > 0
							TMPSALDO->(DbCloseArea())
						Endif
						
						Tcquery cQrySb2 New Alias "TMPSALDO"	
						
						nRegs 		:= 0
						
						Count to nRegs
						
						If nRegs > 0
							TMPSALDO->(DbGoTop())
							
							While !TMPSALDO->(Eof())
								DbSelectArea("SB2")
								DbSetOrder(1)
								If DbSeek(xFilial("SB2") + TMPSALDO->B2_COD + TMPSALDO->B2_LOCAL)
									nSldExtra += SaldoSb2() - SB2->B2_QPEDVEN		
								Endif
							
								TMPSALDO->(DbSkip())
							Enddo
							
							DbSelectArea("SB2")
							DbSetOrder(1)
							If DbSeek(xFilial("SB2") + TMPB1B2->B1_COD + TMPB1B2->B1_LOCPAD)
								nSaldo += SaldoSb2() - SB2->B2_QPEDVEN		
							Endif
						Else
							DbSelectArea("SB2")
							DbSetOrder(1)
							If DbSeek(xFilial("SB2") + TMPB1B2->B1_COD + TMPB1B2->B1_LOCPAD)
								nSaldo += SaldoSb2() - SB2->B2_QPEDVEN		
							Endif		
						Endif

						cFilAnt := cOldFil
					Endif
				Next _N1 
				
				nSldTotal += (nSaldo + nSldExtra)

				If (nSaldo > TMPB1B2->B1_EMIN) .And. MV_PAR07 == 1

					If MV_PAR12 == 1
						oExcel:AddRow(cTabela, cAba,{TMPB1B2->B1_COD,Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES")),Alltrim(TMPB1B2->B1_DESC),"Saldo Suficiente no Armazem Padrao de outra Filial"})
					EndIf

			  		oReport:Say( nLin,nCol+0020,TMPB1B2->B1_COD+" - "+Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES"))+" - "+Alltrim(TMPB1B2->B1_DESC),oTFont,,, ) 
			  		oReport:Say( nLin,nCol+1600,"Saldo Suficiente no Armazem Padrao de outra Filial" ,oTFont,,,)
				    nLin +=050
			  		nItem++
			  	Elseif (nSaldo < TMPB1B2->B1_EMIN) .And. (nSldTotal > TMPB1B2->B1_EMIN) .And. MV_PAR07 == 1

					If MV_PAR12 == 1
						oExcel:AddRow(cTabela, cAba,{TMPB1B2->B1_COD,Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES")),Alltrim(TMPB1B2->B1_DESC),"Saldo Suficiente Considerando outras Filiais"})
					EndIf

			  		oReport:Say( nLin,nCol+0020,TMPB1B2->B1_COD+" - "+Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES"))+" - "+Alltrim(TMPB1B2->B1_DESC),oTFont,,, ) 
			  		oReport:Say( nLin,nCol+1600,"Saldo Suficiente Considerando outras Filiais",oTFont,,,)
				    nLin +=050
			  		nItem++
			  	Elseif 	(nSaldo > TMPB1B2->B1_EMIN) .And. MV_PAR07 == 2
			  		TMPB1B2->(DbSkip())
			  		Loop
			  	Elseif (nSaldo < TMPB1B2->B1_EMIN) .And. (nSldTotal > TMPB1B2->B1_EMIN) .And. MV_PAR07 == 2
			  		TMPB1B2->(DbSkip())
			  		Loop			  		
			  	Else
			  		// Verifica Pedidos de Compra em Outras Filiais	
			  		RetSal(TMPB1B2->B1_COD,TMPB1B2->B1_EMIN, TMPB1B2->B1_DESC,@nCount,.F.)	
					oReport:Say( nLin,nCol+0020,TMPB1B2->B1_COD+" - "+Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES"))+" - "+Alltrim(TMPB1B2->B1_DESC),oTFont,,, )   
					oReport:Say( nLin,nCol+1600,cPrevi,oTFont,,, ) 
			    	nLin +=050

					If MV_PAR12 == 1
						oExcel:AddRow(cTabela, cAba,{TMPB1B2->B1_COD,Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES")),Alltrim(TMPB1B2->B1_DESC),cPrevi})
					EndIf

			  	Endif				
			Else
		  		// Verifica Pedidos de Compra em Outras Filiais	
		  		RetSal(TMPB1B2->B1_COD,TMPB1B2->B1_EMIN, TMPB1B2->B1_DESC,@nCount,.T.)	
				oReport:Say( nLin,nCol+0020,TMPB1B2->B1_COD+" - "+Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES"))+" - "+Alltrim(TMPB1B2->B1_DESC),oTFont,,, )   
				oReport:Say( nLin,nCol+1600,cPrevi,oTFont,,, ) 
		    	nLin +=050			

				If MV_PAR12 == 1 .and. !Empty(TMPB1B2->B1_COD)
					oExcel:AddRow(cTabela, cAba,{TMPB1B2->B1_COD,Alltrim(POSICIONE("SAH",1,xFilial("SAH")+TMPB1B2->B1_UM,"AH_UMRES")),Alltrim(TMPB1B2->B1_DESC),iIF(!Empty(cPrevi),cPrevi,"Sem previsão")})
				EndIf

			Endif	
	  	Endif
	Endif
				
	TMPB1B2->(dbSkip())
Enddo

TMPB1B2->( dbCloseArea() )                      

oReport:Say ( 3215, nCol+1080, cUserName , oTFont1,,, )
//oReport:Say ( 3215, nCol+2100, "Pag. "+transform(oReport:oPrint:nPage-1,"9999"), oTFont1,,, ) 
oReport:EndPage()	

Return()
 
//-------------------------------------------------

Static Function RetSal(cProd, nSaldoMIN, cDesc, nCount,lFiltraFil)  

Local cQuery    := ""
nCount++
If Select("TMPSC7") > 0             
	TMPSC7->( dbCloseArea() )		
EndIf
            
cQuery := "SELECT TOP 1 C7_FILIAL , C7_DATPRF FROM "+RetSqlName("SC7")+" SC7 "+CRLF
cQuery += "WHERE "
cQuery += "C7_PRODUTO = '"+cProd+"' AND C7_ENCER <> 'E' AND SC7.D_E_L_E_T_ = ' ' "+CRLF    

If !lFiltraFil
	cQuery += " AND C7_FILIAL = '" + xFilial("SC7") + "' " + CRLF
Endif

cQuery += "ORDER BY C7_DATPRF ASC"+CRLF

cQuery := ChangeQuery(cQuery)
TcQuery cQuery NEW ALIAS "TMPSC7"
                                          
TCSETFIELD("TMPSC7", "C7_DATPRF", "D", 8, 0)

dbSelectArea("TMPSC7")
If !Empty(TMPSC7->C7_DATPRF)
	//cPrevi := DtoC(TMPSC7->C7_DATPRF) + " na Filial: " + TMPSC7->C7_FILIAL
	cPrevi := DtoC(TMPSC7->C7_DATPRF)
Else 
	cPrevi := "Sem Previsão"
Endif
	
TMPSC7->( dbCloseArea() )
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DHFATR02  ºAutor  ³Microsiga           º Data ³  12/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(cPerg)

	PutSx1(cPerg,"01","Produto de ?"			,"Produto de ?"				,"Produto de ?"				,"mv_ch1","C",15,0,0,"G","","SB1"	,"","","mv_par01",								,							,							,'',					,					,					,			,			,			,,,,'','','',{"Codigo Produto Inicial"		,"para considerar na"		,"geração do relatório."},{},{} )
	PutSx1(cPerg,"02","Produto Até ?"			,"Produto Até ?"			,"Produto Até ?"			,"mv_ch2","C",15,0,0,"G","","SB1"	,"","","mv_par02",								,							,							,'',					,					,					,,			,			,			,,,,'','','',{"Codigo Produto Final"		,"para considerar na"		,"geração do relatório."},{},{} )
	PutSx1(cPerg,"03","Grupo de ?"				,"Grupo de ?"				,"Grupo de ?"				,"mv_ch3","C",04,0,0,"G","","SBM"	,"","","mv_par03",								,							,							,'',					,					,					,			,			,			,,,,'','','',{"Grupo De"					,"para considerar na"		,"geração do relatório."},{},{} )
	PutSx1(cPerg,"04","Grupo Até ?"				,"Grupo Até ?"				,"Grupo Até ?"				,"mv_ch4","C",04,0,0,"G","","SBM"	,"","","mv_par04",								,							,							,'',					,					,					,			,			,			,,,,'','','',{"Grupo Ate"					,"para considerar na"		,"geração do relatório."},{},{} )
	PutSx1(cPerg,"05","Imprime Fora de Linha?"	,"Imprime Fora de Linha?"	,"Imprime Fora de Linha?"	,"mv_ch5","N",01,0,1,"C","",""		,"","","mv_par05","Sim"							,"Sim"						,"Sim"						,'',"Não"				,"Não"				,"Não"				,"Ambos"	,"Ambos"	,"Ambos"	,,,,'','','',{"Imprime Produtos"			,"Considerados Fora"		,"de Linha ?"			},{},{} )
	PutSx1(cPerg,"06","Categoria ?"				,"Categoria ?"				,"Categoria ?"				,"mv_ch6","N",01,0,1,"C","",""		,"","","mv_par06","UD-Utilidades Domesticas"	,"UD-Utilidades Domesticas"	,"UD-Utilidades Domesticas"	,'',"FS_Food Service"	,"FS_Food Service"	,"FS_Food Service"	,"Ambas"	,"Ambas"	,"Ambas"	,,,,'','','',{"Categoria"					,"para considerar na"		,"geração do relatório."},{},{} )
	PutSx1(cPerg,"07","Todos Prod. ?"			,"Todos Prod. ?"			,"Todos Prod. ?"			,"mv_ch7","N",01,0,1,"C","",""		,"","","mv_par07","Sim"							,"Sim"						,"Sim"						,'',"Não"				,"Não"				,"Não"				,			,			,			,,,,'','','',{"Considera todos produtos"	,"na geração do"			,"relatório."			},{},{} )
	PutSx1(cPerg,"08","Do Local"				,"Do Local?"				,"Do Local?"				,"mv_ch8","C",02,0,0,"G","",""		,"","","mv_par08",								,							,							,'',					,					,					,			,			,			,,,,'','','',{"Quais Filiais"				,"serão verificadas"		,"no relatorios"		},{},{} )
	PutSx1(cPerg,"09","Ate Local"				,"Ate Local"				,"Ate Local"				,"mv_ch9","C",02,0,0,"G","",""		,"","","mv_par09",								,							,							,'',					,					,					,			,			,			,,,,'','','',{"Quais Filiais"				,"serão verificadas"		,"no relatorios"		},{},{} )
	PutSx1(cPerg,"10","Verifica Filiais?"		,"Verifica Filiais?"		,"Verifica Filiais?"		,"mv_chA","N",01,0,1,"C","",""		,"","","mv_par10","Sim"							,"Sim"						,"Sim"						,'',"Não"				,"Não"				,"Não"				,			,			,			,,,,'','','',{"Considera saldos em outras"	,"Filiais"					,"so Sistema?"			},{},{} )
	PutSx1(cPerg,"11","Quais Filiais?"			,"Quais Filiais?"			,"Quais Filiais?"			,"mv_chB","C",15,0,0,"G","",""		,"","","mv_par11",								,							,							,'',					,					,					,			,			,			,,,,'','','',{"Quais Filiais"				,"serão verificadas"		,"no relatorios"		},{},{} )

Return .T.
