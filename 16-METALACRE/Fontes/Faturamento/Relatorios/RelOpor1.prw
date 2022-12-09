#INCLUDE "protheus.ch"

#DEFINE VND_VEND	001
#DEFINE VND_NPRO	002
#DEFINE VND_CREV	003
#DEFINE VND_CDES	004
#DEFINE VND_DDAT	005
#DEFINE VND_DINI	006
#DEFINE VND_DFIM	007
#DEFINE VND_PROV	008
#DEFINE VND_STAG	009
#DEFINE VND_STAT	010
#DEFINE VND_CNOM	011
#DEFINE VND_MPRO	012
#DEFINE VND_PREC	013
#DEFINE VND_CPRO	014
#DEFINE VND_DPRO	015
#DEFINE VND_POTE	016
#DEFINE VND_PPED	017
#DEFINE VND_PCTR	018
#DEFINE VND_FIDE	019
#DEFINE VND_CLPR	020

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³ RelOpor1 ³ AUTOR ³ Luiz Alberto V Alves  ³ DATA ³ 01/02/16³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Relatorio de Oportunidade de Vendas						  ³±±
±±³          ³ 			                                                  ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PROGRAMADOR    ³ DATA   ³ MOTIVO DA ALTERACAO		                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³               ³        ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RelOpor1()
Local oReport
Private cPerg 	:= PADR('RELOPOR',10) 
	
	
AjustaSX1()
Pergunte(cPerg,.T.) 
oReport := ReportDef() 
oReport:PrintDialog() 
	
Return 
    
 
Static Function ReportDef() 
	Local oReport 
	Local oSection1 	 
 
	cParam := MV_PAR10
	cStatus := ''
	If '1'$cParam
		cStatus += 'Abertos '
	Endif
	If '2'$cParam
		cStatus += 'Perdidos '
	Endif
	If '3'$cParam
		cStatus += 	'Suspensos '
	Endif
	If '9'$cParam
		cStatus += 	'Revertidos '
	Endif
	
	cSubTit := ''
	If !Empty(MV_PAR15)
		cSubTit := ' F.C.I.: ' + Capital(Tabela("A6",MV_PAR15))
	Endif

	cTitulo := "Oportunidades -" + ' Status: ' + cStatus + cSubTit
	cTitulo += " - Per: " + DtoC(MV_PAR01) + " - " + DtoC(MV_PAR02) 
	
	oReport := TReport():New('RELOPOR',cTitulo,'',{|oReport| PrintReport(oReport)},"Esta Rotina irá imprimir o Relatório Fechamento de Negócios") 	
	oReport:SetTotalInLine(.T.) // Impressao do total geral das colunas somadas
	oReport:LPARAMPAGE := .T.	// Pagina de Parametros Impressao
//	oReport:ShowFooter()
	
	oSection1 := TRSection():New(oReport,cTitulo,{"AD1",'SA3','SB1','AC3'}) 
	oSection1:SetTotalInLine(.T.) // impressao do total por sessao das colunas somadas

	If MV_PAR05 == 1	// Quebra por Vendedor
		TRCell():New(oSection1,"_cVendNom"      ,"   ","Vendedor(a)"   		,PesqPict("SA3","A3_NREDUZ")	    , TamSX3("A3_NREDUZ")[1]) 
		TRCell():New(oSection1,"_cNroPor"   	,"   ","N.Proposta"			,PesqPict("AD1","AD1_NROPOR")	    , TamSX3("AD1_NROPOR")[1]) 
		TRCell():New(oSection1,"_cRevisao"  	,"   ","Revisao" 			,PesqPict("AD1","AD1_REVISA")	    , TamSX3("AD1_REVISA")[1]) 
		TRCell():New(oSection1,"_cCliPro"	  	,"   ","Cliente/Prosp"		,PesqPict("AD1","AD1_CODCLI")	    , 10) 
		TRCell():New(oSection1,"_cDescri"       ,"   ","Descrição"			,PesqPict("AD1","AD1_DESCRI")	    , TamSX3("AD1_DESCRI")[1]) 
		TRCell():New(oSection1,"_dData"		    ,"   ","Abertura/Encerr."	    ,PesqPict("AD1","AD1_DTENCE")		    , TamSX3("AD1_DTENCE")[1])
//		TRCell():New(oSection1,"_cProVen"		,"   ","Proc.Venda"   		,'@!'							    , )
//		TRCell():New(oSection1,"_cStagio"		,"   ","Estagio"	   		,'@!'							    , )
		TRCell():New(oSection1,"_cStatus"		,"   ","Status"		   		,''							    , )
		TRCell():New(oSection1,"_cFideli"		,"   ","Fidel."		   		,''							    , )
		TRCell():New(oSection1,"_cConNome" 		,"   ","Concorrente"		,PesqPict("AC3","AC3_NOME")		    , TamSX3("AC3_NOME")[1])
		TRCell():New(oSection1,"_cModProd" 		,"   ","Modelo"				,PesqPict("AD3","AD3_DESPRO")	    , TamSX3("AD3_DESPRO")[1])
		TRCell():New(oSection1,"_nPreco" 		,"   ","Preço"				,PesqPict("AD3","AD3_PRECO")	    , TamSX3("AD3_PRECO")[1])
		TRCell():New(oSection1,"_cCodPro" 		,"   ","Cód.Prod."			,PesqPict("AD1","AD1_CODPRO")	    , TamSX3("AD1_CODPRO")[1])
		TRCell():New(oSection1,"_nPoten" 		,"   ","Potencial"			,'@E 99,999,999'		    , 10)
		TRCell():New(oSection1,"_nPPedi" 		,"   ","P.Ped.Pont."		,'@E 99,999,999'		    , 10)
		TRCell():New(oSection1,"_nPCont" 		,"   ","P.Contrato"			,'@E 99,999,999'		    , 10)

		oBreak1 := TRBreak():New(oSection1,oSection1:Cell("_cVendNom"),"TOTAL Vendedor:",.F.,)

	ElseIf MV_PAR05 == 2	// Quebra por Modelos
		TRCell():New(oSection1,"_cModProd" 		,"   ","Modelo"				,PesqPict("AD3","AD3_DESPRO")	    , TamSX3("AD3_DESPRO")[1])
		TRCell():New(oSection1,"_cVendNom"      ,"   ","Vendedor(a)"   		,PesqPict("SA3","A3_NREDUZ")	    , TamSX3("A3_NREDUZ")[1]) 
		TRCell():New(oSection1,"_cNroPor"   	,"   ","N.Proposta"			,PesqPict("AD1","AD1_NROPOR")	    , TamSX3("AD1_NROPOR")[1]) 
		TRCell():New(oSection1,"_cRevisao"  	,"   ","Revisao" 			,PesqPict("AD1","AD1_REVISA")	    , TamSX3("AD1_REVISA")[1]) 
		TRCell():New(oSection1,"_cCliPro"	  	,"   ","Cliente/Prosp"		,PesqPict("AD1","AD1_CODCLI")	    , 10) 
		TRCell():New(oSection1,"_cDescri"       ,"   ","Descrição"			,PesqPict("AD1","AD1_DESCRI")	    , TamSX3("AD1_DESCRI")[1]) 
		TRCell():New(oSection1,"_dData"		    ,"   ","Abertura/Encerr."	    ,PesqPict("AD1","AD1_DTENCE")		    , TamSX3("AD1_DTENCE")[1])
//		TRCell():New(oSection1,"_cProVen"		,"   ","Proc.Venda"   		,'@!'							    , )
//		TRCell():New(oSection1,"_cStagio"		,"   ","Estagio"	   		,'@!'							    , )
		TRCell():New(oSection1,"_cStatus"		,"   ","Status"		   		,''							    , )
		TRCell():New(oSection1,"_cFideli"		,"   ","Fidel."		   		,''							    , )
		TRCell():New(oSection1,"_cConNome" 		,"   ","Concorrente"		,PesqPict("AC3","AC3_NOME")		    , TamSX3("AC3_NOME")[1])
		TRCell():New(oSection1,"_nPreco" 		,"   ","Preço"				,PesqPict("AD3","AD3_PRECO")	    , TamSX3("AD3_PRECO")[1])
		TRCell():New(oSection1,"_cCodPro" 		,"   ","Cód.Prod."			,PesqPict("AD1","AD1_CODPRO")	    , TamSX3("AD1_CODPRO")[1])
		TRCell():New(oSection1,"_nPoten" 		,"   ","Potencial"			,'@E 99,999,999'		    , 10)
		TRCell():New(oSection1,"_nPPedi" 		,"   ","P.Ped.Pont."		,'@E 99,999,999'		    , 10)
		TRCell():New(oSection1,"_nPCont" 		,"   ","P.Contrato"			,'@E 99,999,999'		    , 10)

		oBreak1 := TRBreak():New(oSection1,oSection1:Cell("_cModProd"),"TOTAL Modelo:",.F.,)
	
	ElseIf MV_PAR05 == 3	// Quebra por Concorrentes
		TRCell():New(oSection1,"_cConNome" 		,"   ","Concorrente"		,PesqPict("AC3","AC3_NOME")		    , TamSX3("AC3_NOME")[1])
		TRCell():New(oSection1,"_cModProd" 		,"   ","Modelo"				,PesqPict("AD3","AD3_DESPRO")	    , TamSX3("AD3_DESPRO")[1])
		TRCell():New(oSection1,"_cVendNom"      ,"   ","Vendedor(a)"   		,PesqPict("SA3","A3_NREDUZ")	    , TamSX3("A3_NREDUZ")[1]) 
		TRCell():New(oSection1,"_cNroPor"   	,"   ","N.Proposta"			,PesqPict("AD1","AD1_NROPOR")	    , TamSX3("AD1_NROPOR")[1]) 
		TRCell():New(oSection1,"_cRevisao"  	,"   ","Revisao" 			,PesqPict("AD1","AD1_REVISA")	    , TamSX3("AD1_REVISA")[1]) 
		TRCell():New(oSection1,"_cCliPro"	  	,"   ","Cliente/Prosp"		,PesqPict("AD1","AD1_CODCLI")	    , 10) 
		TRCell():New(oSection1,"_cDescri"       ,"   ","Descrição"			,PesqPict("AD1","AD1_DESCRI")	    , TamSX3("AD1_DESCRI")[1]) 
		TRCell():New(oSection1,"_dData"		    ,"   ","Abertura/Encerr."	    ,PesqPict("AD1","AD1_DTENCE")		    , TamSX3("AD1_DTENCE")[1])
//		TRCell():New(oSection1,"_cProVen"		,"   ","Proc.Venda"   		,'@!'							    , )
//		TRCell():New(oSection1,"_cStagio"		,"   ","Estagio"	   		,'@!'							    , )
		TRCell():New(oSection1,"_cStatus"		,"   ","Status"		   		,''							    , )
		TRCell():New(oSection1,"_cFideli"		,"   ","Fidel."		   		,''							    , )
		TRCell():New(oSection1,"_nPreco" 		,"   ","Preço"				,PesqPict("AD3","AD3_PRECO")	    , TamSX3("AD3_PRECO")[1])
		TRCell():New(oSection1,"_cCodPro" 		,"   ","Cód.Prod."			,PesqPict("AD1","AD1_CODPRO")	    , TamSX3("AD1_CODPRO")[1])
		TRCell():New(oSection1,"_nPoten" 		,"   ","Potencial"			,'@E 99,999,999'		    , 10)
		TRCell():New(oSection1,"_nPPedi" 		,"   ","P.Ped.Pont."		,'@E 99,999,999'		    , 10)
		TRCell():New(oSection1,"_nPCont" 		,"   ","P.Contrato"			,'@E 99,999,999'		    , 10)

		oBreak1 := TRBreak():New(oSection1,oSection1:Cell("_cConNome"),"TOTAL Concorrente:",.F.,)
	
	Endif	

	oSection1:Cell("_cDescri"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cConNome"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cVendNom"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cCliPro"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
//	oSection1:Cell("_cProVen"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
//	oSection1:Cell("_cStagio"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_nPoten"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cCodPro"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cModProd"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cNroPor"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cRevisao"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_dData"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cStatus"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cFideli"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_nPreco"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cCodPro"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_nPPedi"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_nPCont"):lAutoSize  := .F.	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres

	oSection1:Cell("_cDescri"):nSize := 35	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cConNome"):nSize := 25	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cVendNom"):nSize := 20	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cCliPro"):nSize := 10	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
//	oSection1:Cell("_cProVen"):nSize := 20	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
//	oSection1:Cell("_cStagio"):nSize := 15	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_nPoten"):nSize := 12	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	oSection1:Cell("_cCodPro"):nSize := 25	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres

	oSection1:Cell("_cCliPro"):lHeaderSize := .F.
	oSection1:Cell("_dData"):lHeaderSize := .F.
	oSection1:Cell("_nPoten"):lHeaderSize := .F.
	oSection1:Cell("_nPPedi"):lHeaderSize := .F.
	oSection1:Cell("_nPCont"):lHeaderSize := .F.

	oSection1:Cell("_dData"):nSize := 15	// Ajuste do Campo Numero Vendedor, Estava Quebrando em 5 caracteres
	
	TRFunction():New(oSection1:Cell("_cDescri")  ,NIL,"COUNT"   ,oBreak1 ,'Total Registros','9999',/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("_nPoten")  ,NIL  ,"SUM"    ,oBreak1 ,'Total Potencial','@E 9,999,999,999',/*uFormula*/,.F.        ,.T.)
	TRFunction():New(oSection1:Cell("_nPPedi")  ,NIL  ,"SUM"    ,oBreak1 ,'Total P.Ped.Pont.','@E 9,999,999,999',/*uFormula*/,.F.        ,.T.)
	TRFunction():New(oSection1:Cell("_nPCont")  ,NIL  ,"SUM"    ,oBreak1 ,'Total P.Contrato','@E 9,999,999,999',/*uFormula*/,.F.        ,.T.)
	
//	TRFunction():New(oSection1:Cell("_cDescri")  ,NIL,"COUNT",oBreak2 ,/*Titulo*/,'9999',/*uFormula*/,.F.,.F.)
//	TRFunction():New(oSection1:Cell("_nPoten")  ,NIL,"SUM",oBreak2 ,/*Titulo*/,'@E 9,999,999,999',/*uFormula*/,.F.,.F.)

//	TRFunction():New(oSection1:Cell("_cDescri")  ,NIL,"COUNT",oBreak3 ,/*Titulo*/,'9999',/*uFormula*/,.F.,.F.)
//	TRFunction():New(oSection1:Cell("_nPoten")  ,NIL,"SUM",oBreak3 ,/*Titulo*/,'@E 9,999,999,999',/*uFormula*/,.F.,.F.)

//	TRFunction():New(oSection1:Cell("_cDescri")  ,NIL,"COUNT",oBreak4 ,/*Titulo*/,'9999',/*uFormula*/,.F.,.F.)
//	TRFunction():New(oSection1:Cell("_nPoten")  ,NIL,"SUM",oBreak4 ,/*Titulo*/,'@E 9,999,999,999',/*uFormula*/,.F.,.F.)
Return oReport 

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
 
Static Function PrintReport(oReport)
Local cQuery	    := ""
Local oSection1 := oReport:Section(1)

MV_PAR10 := Alltrim(StrTran(MV_PAR10,"*",""))
cParam := ''
For nI := 1 To Len(AllTrim(MV_PAR10))
	If !Empty(SubStr(MV_PAR10,nI,1))
		cParam += SubStr(MV_PAR10,nI,1)+';'
	Endif
Next     

If Right(AllTrim(cParam),1) == ';'
	cParam := Left(cParam,Len(AllTrim(cParam))-1)
Endif

If MV_PAR05 == 1	// Por Vendedor
	cQuery :=" SELECT AD1_VEND, AD1_NROPOR, AD1_REVISA, "
	cQuery +=" 	AD1_DTENCE =  "
	cQuery +=" 		CASE "
	cQuery +=" 		WHEN AD1_DTENCE = '' THEN AD1_DATA "
	cQuery +=" 		WHEN AD1_DTENCE <> '' THEN AD1_DTENCE "
	cQuery +=" 		END, "
	cQuery +=" AD1_CODCLI, AD1_LOJCLI, AD1_PROSPE, AD1_LOJPRO, AD1_DESCRI, AD1_DTENCE, AD1_DTINI, AD1_DTFIM, AD1_PROVEN, AD1_STAGE, AD1_STATUS,	AD1_FIDEL , AD3_CODCON, AC3_NOME, AD3_DESPRO, AD3_PRECO, AD1_CODPRO, B1_DESC , AD1_POTEN QTD_ANO, AD1_POTPED QTD_PED, AD1_POTCTR QTD_CTR "
	cQuery +=" FROM " + RetSqlName("AD1") + " AD1, " + RetSqlName("AD3") + " AD3, " + RetSqlName("AC3") + " AC3, " + RetSqlName("SA3") + " A3, " + RetSqlName("SB1") + " B1 "
	cQuery +=" WHERE AD1_FILIAL = '" + xFilial("AD1") + "' "
	cQuery +=" AND AD3_FILIAL = '" + xFilial("AD3") + "' "
	cQuery +=" AND AC3_FILIAL = '" + xFilial("AC3") + "' "
	cQuery +=" AND A3_FILIAL = '" + xFilial("SA3") + "' "
	cQuery +=" AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery +=" AND AD3_NROPOR = AD1_NROPOR "
	cQuery +=" AND AD3_REVISA = AD1_REVISA "
	cQuery +=" AND AD3_CODCON = AC3_CODCON "
	cQuery +=" AND AD1_VEND = A3_COD "
	cQuery +=" AND AD1.D_E_L_E_T_ = '' "
	cQuery +=" AND AD3.D_E_L_E_T_ = '' "
	cQuery +=" AND AC3.D_E_L_E_T_ = '' "
	cQuery +=" AND A3.D_E_L_E_T_ = '' "
	cQuery +=" AND B1.D_E_L_E_T_ = '' "
	cQuery +=" AND B1.B1_COD = AD1.AD1_CODPRO "
	cQuery +=" AND AD3_DESPRO <> '' "
	cQuery +=" AND ((AD1_STATUS <> '1' AND AD1_DTENCE BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "') OR (AD1_STATUS = '1' AND AD1_DATA BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' )) "
	cQuery +=" AND AD1_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND B1.B1_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' "
	cQuery +=" AND B1.B1_GRUPO BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' "
	If MV_PAR14==1	// Filtra Fidelidade
		cQuery +=" AND AD1.AD1_FIDEL  = '" + Str(MV_PAR14,1) + "' "
	ElseIf MV_PAR14==2	// Filtra Fidelidade
		cQuery +=" AND AD1.AD1_FIDEL  = '" + Str(MV_PAR14,1) + "' "
	Endif
	If !Empty(MV_PAR13)	// Filtra Concorrentes
		cQuery +=" AND AC3.AC3_CODCON = '" + MV_PAR13 + "' "
	Endif
	If !Empty(MV_PAR11)	// Filtra Processo de Venda
		cQuery +=" AND AD1.AD1_PROVEN = '" + MV_PAR11 + "' "
		cQuery +=" AND AD1.AD1_STAGE = '" + MV_PAR12 + "' "
	Endif
	If !Empty(MV_PAR15)
		cQuery +=" AND AD1.AD1_FCI = '" + MV_PAR15 + "' "
	Endif	
	cQuery +=" AND AD1.AD1_STATUS IN " + FormatIn(cParam,";")
	cQuery +=" ORDER BY AD1_VEND, AC3_NOME, AD3_DESPRO, 4"
ElseIf MV_PAR05 == 2  // Por Modelo
	cQuery :=" SELECT AD1_VEND, AD1_NROPOR, AD1_REVISA, "
	cQuery +=" 	AD1_DTENCE =  "
	cQuery +=" 		CASE "
	cQuery +=" 		WHEN AD1_DTENCE = '' THEN AD1_DATA "
	cQuery +=" 		WHEN AD1_DTENCE <> '' THEN AD1_DTENCE "
	cQuery +=" 		END, "
	cQuery +=" AD1_CODCLI, AD1_LOJCLI, AD1_PROSPE, AD1_LOJPRO, AD1_DESCRI, AD1_DTENCE, AD1_DTINI, AD1_DTFIM, AD1_PROVEN, AD1_STAGE, AD1_STATUS,	AD1_FIDEL , AD3_CODCON, AC3_NOME, AD3_DESPRO, AD3_PRECO, AD1_CODPRO, B1_DESC , AD1_POTEN QTD_ANO, AD1_POTPED QTD_PED, AD1_POTCTR QTD_CTR "
	cQuery +=" FROM " + RetSqlName("AD1") + " AD1, " + RetSqlName("AD3") + " AD3, " + RetSqlName("AC3") + " AC3, " + RetSqlName("SA3") + " A3, " + RetSqlName("SB1") + " B1 "
	cQuery +=" WHERE AD1_FILIAL = '" + xFilial("AD1") + "' "
	cQuery +=" AND AD3_FILIAL = '" + xFilial("AD3") + "' "
	cQuery +=" AND AC3_FILIAL = '" + xFilial("AC3") + "' "
	cQuery +=" AND A3_FILIAL = '" + xFilial("SA3") + "' "
	cQuery +=" AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery +=" AND AD3_NROPOR = AD1_NROPOR "
	cQuery +=" AND AD3_REVISA = AD1_REVISA "
	cQuery +=" AND AD3_CODCON = AC3_CODCON "
	cQuery +=" AND AD1_VEND = A3_COD "
	cQuery +=" AND AD1.D_E_L_E_T_ = '' "
	cQuery +=" AND AD3.D_E_L_E_T_ = '' "
	cQuery +=" AND AC3.D_E_L_E_T_ = '' "
	cQuery +=" AND A3.D_E_L_E_T_ = '' "
	cQuery +=" AND B1.D_E_L_E_T_ = '' "
	cQuery +=" AND B1.B1_COD = AD1.AD1_CODPRO "
	cQuery +=" AND AD3_DESPRO <> '' "
	cQuery +=" AND ((AD1_STATUS <> '1' AND AD1_DTENCE BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "') OR (AD1_STATUS = '1' AND AD1_DATA BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' )) "
	cQuery +=" AND AD1_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND B1.B1_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' "
	cQuery +=" AND B1.B1_GRUPO BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' "
	cQuery +=" AND AD1.AD1_STATUS IN " + FormatIn(cParam,";")
	If MV_PAR14==1	// Filtra Fidelidade
		cQuery +=" AND AD1.AD1_FIDEL  = '" + Str(MV_PAR14,1) + "' "
	ElseIf MV_PAR14==2	// Filtra Fidelidade
		cQuery +=" AND AD1.AD1_FIDEL  = '" + Str(MV_PAR14,1) + "' "
	Endif
	If !Empty(MV_PAR13)	// Filtra Concorrentes
		cQuery +=" AND AC3.AC3_CODCON = '" + MV_PAR13 + "' "
	Endif
	If !Empty(MV_PAR11)	// Filtra Processo de Venda
		cQuery +=" AND AD1.AD1_PROVEN = '" + MV_PAR11 + "' "
		cQuery +=" AND AD1.AD1_STAGE = '" + MV_PAR12 + "' "
	Endif
	If !Empty(MV_PAR15)
		cQuery +=" AND AD1.AD1_FCI = '" + MV_PAR15 + "' "
	Endif	
//	cQuery +=" GROUP BY AD3_DESPRO, AD1_NROPOR, AD1_REVISA, AD1_DESCRI, AD1_DTENCE, AD1_DTINI, AD1_DTFIM, AD1_PROVEN, AD1_STAGE, AD1_STATUS,	AD3_CODCON, AC3_NOME, AD1_VEND, AD3_PRECO, AD1_CODPRO, B1_DESC "
	cQuery +=" ORDER BY AD3_DESPRO, AD1_VEND, AC3_NOME, 4"
ElseIf MV_PAR05 == 3  // Por Concorrente
	cQuery :=" SELECT AD1_VEND, AD1_NROPOR, AD1_REVISA, "
	cQuery +=" 	AD1_DTENCE =  "
	cQuery +=" 		CASE "
	cQuery +=" 		WHEN AD1_DTENCE = '' THEN AD1_DATA "
	cQuery +=" 		WHEN AD1_DTENCE <> '' THEN AD1_DTENCE "
	cQuery +=" 		END, "
	cQuery +=" AD1_CODCLI, AD1_LOJCLI, AD1_PROSPE, AD1_LOJPRO, AD1_DESCRI, AD1_DTENCE, AD1_DTINI, AD1_DTFIM, AD1_PROVEN, AD1_STAGE, AD1_STATUS,	AD1_FIDEL , AD3_CODCON, AC3_NOME, AD3_DESPRO, AD3_PRECO, AD1_CODPRO, B1_DESC , AD1_POTEN QTD_ANO, AD1_POTPED QTD_PED, AD1_POTCTR QTD_CTR "
	cQuery +=" FROM " + RetSqlName("AD1") + " AD1, " + RetSqlName("AD3") + " AD3, " + RetSqlName("AC3") + " AC3, " + RetSqlName("SA3") + " A3, " + RetSqlName("SB1") + " B1 "
	cQuery +=" WHERE AD1_FILIAL = '" + xFilial("AD1") + "' "
	cQuery +=" AND AD3_FILIAL = '" + xFilial("AD3") + "' "
	cQuery +=" AND AC3_FILIAL = '" + xFilial("AC3") + "' "
	cQuery +=" AND A3_FILIAL = '" + xFilial("SA3") + "' "
	cQuery +=" AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery +=" AND AD3_NROPOR = AD1_NROPOR "
	cQuery +=" AND AD3_REVISA = AD1_REVISA "
	cQuery +=" AND AD3_CODCON = AC3_CODCON "
	cQuery +=" AND AD1_VEND = A3_COD "
	cQuery +=" AND AD1.D_E_L_E_T_ = '' "
	cQuery +=" AND AD3.D_E_L_E_T_ = '' "
	cQuery +=" AND AC3.D_E_L_E_T_ = '' "
	cQuery +=" AND A3.D_E_L_E_T_ = '' "
	cQuery +=" AND B1.D_E_L_E_T_ = '' "
	cQuery +=" AND B1.B1_COD = AD1.AD1_CODPRO "
	cQuery +=" AND AD3_DESPRO <> '' "
	cQuery +=" AND ((AD1_STATUS <> '1' AND AD1_DTENCE BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "') OR (AD1_STATUS = '1' AND AD1_DATA BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' )) "
	cQuery +=" AND AD1_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery +=" AND B1.B1_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' "
	cQuery +=" AND B1.B1_GRUPO BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "' "
	cQuery +=" AND AD1.AD1_STATUS IN " + FormatIn(cParam,";")
	If MV_PAR14==1	// Filtra Fidelidade
		cQuery +=" AND AD1.AD1_FIDEL  = '" + Str(MV_PAR14,1) + "' "
	ElseIf MV_PAR14==2	// Filtra Fidelidade
		cQuery +=" AND AD1.AD1_FIDEL  = '" + Str(MV_PAR14,1) + "' "
	Endif
	If !Empty(MV_PAR13)	// Filtra Concorrentes
		cQuery +=" AND AC3.AC3_CODCON = '" + MV_PAR13 + "' "
	Endif
	If !Empty(MV_PAR11)	// Filtra Processo de Venda
		cQuery +=" AND AD1.AD1_PROVEN = '" + MV_PAR11 + "' "
		cQuery +=" AND AD1.AD1_STAGE = '" + MV_PAR12 + "' "
	Endif
	If !Empty(MV_PAR15)
		cQuery +=" AND AD1.AD1_FCI = '" + MV_PAR15 + "' "
	Endif	
	cQuery +=" ORDER BY AC3_NOME, AD3_DESPRO, AD1_VEND, 4"
Endif
cQuery := ChangeQuery(cQuery) 	// otimiza a query de acordo c/ o banco 	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CHKV",.T.,.T.)

TcSetField('CHKV','AD1_DTENCE','D')
TcSetField('CHKV','AD1_DTFIM','D')
TcSetField('CHKV','AD1_DTINI','D')

aVendas	:= {}

dbSelectArea("CHKV")
Count To nReg
dbGoTop()
ProcRegua(nReg)
While CHKV->(!Eof())
	IncProc("Aguarde Processando os Dados")
	
		Posicione("SA3",1,xFilial("SA3")+CHKV->AD1_VEND,"")
		AC1->(dbSetOrder(1), dbSeek(xFilial("AC1")+CHKV->AD1_PROVEN))
		AC2->(dbSetOrder(1), dbSeek(xFilial("AC2")+CHKV->AD1_PROVEN+CHKV->AD1_STAGE))
		
		cStatus := ''
		If CHKV->AD1_STATUS == '1'
			cStatus := 'Aber'
		ElseIf CHKV->AD1_STATUS == '2'
			cStatus := 'Perd'
		ElseIf CHKV->AD1_STATUS == '3'
			cStatus := 'Susp'
		ElseIf CHKV->AD1_STATUS == '9'
			cStatus := 'Rever'
		Endif             
		
		cFidel	:=	''
		If CHKV->AD1_FIDEL == '1'
			cFidel	:=	'R.Pontual'
		ElseIf CHKV->AD1_FIDEL == '2'
			cFidel  :=  'Ctr.Parceria'
		Endif

	AAdd(aVendas,{SA3->A3_NREDUZ,;
					CHKV->AD1_NROPOR,;
					CHKV->AD1_REVISA,;
					Left(CHKV->AD1_DESCRI,30),;
					CHKV->AD1_DTENCE,;
					CHKV->AD1_DTINI,;
					CHKV->AD1_DTFIM,;
					AC1->AC1_DESCRI,;
					AC2->AC2_DESCRI,;
					cStatus,;
					Left(CHKV->AC3_NOME,10),;
					CHKV->AD3_DESPRO,;
					CHKV->AD3_PRECO,;
					CHKV->AD1_CODPRO,;
					CHKV->B1_DESC,;
					CHKV->QTD_ANO,;
					CHKV->QTD_PED,;
					CHKV->QTD_CTR,;
					cFidel,;
					Iif(!Empty(CHKV->AD1_CODCLI),CHKV->AD1_CODCLI+'/'+CHKV->AD1_LOJCLI,CHKV->AD1_PROSPE+'/'+CHKV->AD1_LOJPRO)})

	CHKV->(dbSkip(1))
Enddo
CHKV->(dbCloseArea())

oReport:SetMeter(Len(aVendas))
For nVenda := 1 To Len(aVendas)
	oReport:IncMeter() 

	If oReport:Cancel() 
		Exit 
	EndIf 
			   
	oSection1:Init()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do cabecalho das NFs                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ         	
   		
	oSection1:Cell("_cVendNom"):SetValue(aVendas[nVenda,VND_VEND])	
	oSection1:Cell("_cNroPor"):SetValue(aVendas[nVenda,VND_NPRO])	
	oSection1:Cell("_cRevisao"):SetValue(aVendas[nVenda,VND_CREV])	
	oSection1:Cell("_cCliPro"):SetValue(aVendas[nVenda,VND_CLPR])	
	oSection1:Cell("_cDescri"):SetValue(aVendas[nVenda,VND_CDES])	
	oSection1:Cell("_dData"):SetValue(aVendas[nVenda,VND_DDAT])	
//	oSection1:Cell("_dDataIni"):SetValue(aVendas[nVenda,VND_DINI])	
//	oSection1:Cell("_dDataFim"):SetValue(aVendas[nVenda,VND_DFIM])	
//	oSection1:Cell("_cProVen"):SetValue(aVendas[nVenda,VND_PROV])	
//	oSection1:Cell("_cStagio"):SetValue(aVendas[nVenda,VND_STAG])	
	oSection1:Cell("_cStatus"):SetValue(aVendas[nVenda,VND_STAT])	
	oSection1:Cell("_cFideli"):SetValue(aVendas[nVenda,VND_FIDE])	
	oSection1:Cell("_cConNome"):SetValue(aVendas[nVenda,VND_CNOM])	
	oSection1:Cell("_cModProd"):SetValue(aVendas[nVenda,VND_MPRO])	
	oSection1:Cell("_nPreco"):SetValue(aVendas[nVenda,VND_PREC])	
	oSection1:Cell("_cCodPro"):SetValue(aVendas[nVenda,VND_CPRO])	
//	oSection1:Cell("_cDesPro"):SetValue(aVendas[nVenda,VND_DPRO])	
	oSection1:Cell("_nPoten"):SetValue(aVendas[nVenda,VND_POTE])	
	oSection1:Cell("_nPPedi"):SetValue(aVendas[nVenda,VND_PPED])	
	oSection1:Cell("_nPCont"):SetValue(aVendas[nVenda,VND_PCTR])	

	//Imprime registros na secao 1 
	oSection1:PrintLine()		       
			
Next
oSection1:Finish()			
Return    


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AjustaSX1()                                                                                                                                       
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local aHelpPor01 := {}
Local aHelpPor02 := {}
Local aHelpPor03 := {}
Local aHelpPor04 := {}
Local aHelpPor05 := {}
Local aHelpPor06 := {}
Local aHelpPor07 := {}

PutSx1(cPerg,'01','Data De        ?','','','mv_ch1','D',08, 0, 0,'G','',''   ,'','','mv_par01'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor01,aHelpPor01,aHelpPor01)
PutSx1(cPerg,'02','Data Ate       ?','','','mv_ch2','D',08, 0, 0,'G','',''   ,'','','mv_par02'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor02,aHelpPor02,aHelpPor02)
PutSx1(cPerg,'03','Vendedor de    ?','','','mv_ch3','C', 6, 0, 0,'G','','SA3','','','mv_par03'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'04','Vendedor Ate   ?','','','mv_ch4','C', 6, 0, 0,'G','','SA3','','','mv_par04'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'05','Quebra Por     ?','','','mv_ch5','N', 1, 0, 1,'C','',''   ,'','','mv_par05'           ,'Vendedor','','',''     ,'Modelo','','','Concorrente','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)
PutSx1(cPerg,'06','Produto de     ?','','','mv_ch6','C',30, 0, 0,'G','','SB1','','','mv_par06'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'07','Produto Ate    ?','','','mv_ch7','C',30, 0, 0,'G','','SB1','','','mv_par07'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'08','Grupo de       ?','','','mv_ch8','C',04, 0, 0,'G','','SBM','','','mv_par08'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'09','Grupo Ate      ?','','','mv_ch9','C',04, 0, 0,'G','','SBM','','','mv_par09'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor04,aHelpPor04,aHelpPor04)                               
PutSx1(cPerg,'10','Status         ?','','','mv_chA','C',20, 0, 0,'G','',''   ,'','','mv_par10'           ,'','','','','','','','','','','','','','','','',aHelpPor07,aHelpPor07,aHelpPor07)
PutSx1(cPerg,'11','Processo Venda ?','','','mv_chB','C',06, 0, 0,'G','','AC2','','','mv_par11'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'12','Estagio        ?','','','mv_chC','C',06, 0, 0,'G','',''   ,'','','mv_par12'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'13','Concorrente    ?','','','mv_chD','C',06, 0, 0,'G','','AC3','','','mv_par13'			 ,   '','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'14','Fidelidade     ?','','','mv_chE','N',01, 0, 1,'C','',''   ,'','','mv_par14'			 ,'Reversao Pont.','','',''		  ,'Fechou Contrato'   ,'','','Ambas','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
PutSx1(cPerg,'15','F.C.I.         ?','','','mv_chF','C',06, 0, 1,'G','','A6' ,'','','mv_par15'			 ,'','','',''		  ,''   ,'','','','','','','','','','','',aHelpPor03,aHelpPor03,aHelpPor03)                               
Return NIL
                                                                                              
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fReqEPI   ³ Autor ³ Marcelo Silveira      ³ Data ³13/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar Requisitos do EPI                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fReqEPI()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function fStat2()

Local cTitulo:=""
Local MvPar
Local MvParDef:="" 
Local i := 1

Private aReq:={}

cAlias := Alias()               // Salva Alias Anterior
MvPar:=&(Alltrim(ReadVar()))   // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())      // Iguala Nome da Variavel ao Nome variavel de Retorno

aReq := {	'1 - Abertas' ,; 
			'2 - Perdidas' ,; 
			'3 - Suspensas' ,;
			'9 - Revertido'} 

MvParDef:= "1239"
cTitulo := 'Selecione os Status Desejados para o Filtro' //"Atendimento aos requisitos pelos EPIS informados"

IF f_Opcoes(@MvPar,cTitulo,aReq,MvParDef,12,49,.F.)  // Chama funcao f_Opcoes
	&MvRet := mvpar
EndIF                           

dbSelectArea(cAlias) // Retorna Alias

Return( .T. )
