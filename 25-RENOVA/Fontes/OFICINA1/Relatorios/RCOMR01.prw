#INCLUDE "TOTVS.CH"
#INCLUDE "REPORT.CH"
#INCLUDE "PRTOPDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMR01   บAutor  ณFelipi Marques      บ Data ณ  05/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio gerencial responsavel por quantificar as notas    บฑฑ
ฑฑบ          ณimportadas de acordo com os parโmetros especificados.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                                       
User Function RCOMR01()

Local 	aBkpAllArea := GetAllArea()
Local 	oReport
                              
//Pergunta
Private cPerg   	:= Padr("PCOMR01",10)

ValidPerg()

Pergunte(cPerg , .F.)    

oReport := ReportDef()
oReport:PrintDialog()
	
GetAllArea(aBkpAllArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณFelipi Marques      บ Data ณ  08/19/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de defini็ใo do layout e formato do relat๓rio       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReportDef()

Local oReport		:= nil
Local oDocumentos	:= nil
Local cDesc			:= "Relat๓rio Gerencial de Inconsistencias/Xml Validados - NF's Vs XML"
Local cTitulo		:= "Relat๓rio Gerencial de Inconsistencias/Xml Validados - NF's Vs XML"                 

DEFINE REPORT oReport NAME "RCOMR01" TITLE cTitulo PARAMETER cPerg ACTION {|oReport| PrintReport(oReport)} DESCRIPTION cDesc

//Escolher o padrใo de Impressao como Paisagem
oReport:SetLandscape() 


DEFINE SECTION oNFe1	OF oReport 	TITLE OemToAnsi("Notas Escrituradas")

/* INFORMAว๕es referentes aos XML's Importados (Tabela Z02) */
DEFINE CELL NAME "ITEM"				OF oNFe1 TITLE OemToAnsi("Item")			SIZE 4
DEFINE CELL NAME "NUMNFE"			OF oNFe1 TITLE OemToAnsi("Numero NF") 		SIZE 10
DEFINE CELL NAME "SERIE" 			OF oNFe1 TITLE OemToAnsi("Serie NF")		SIZE 4
DEFINE CELL NAME "FORNECE"			OF oNFe1 TITLE OemToAnsi("Fornecedor") 		SIZE 9
DEFINE CELL NAME "LOJA"				OF oNFe1 TITLE OemToAnsi("Loja") 			SIZE 5
DEFINE CELL NAME "ESPECIE"   		OF oNFe1 TITLE OemToAnsi("Especie") 		AUTO SIZE
DEFINE CELL NAME "CHAVE"			OF oNFe1 TITLE OemToAnsi("Chave") 			SIZE 46
DEFINE CELL NAME "DTEMISSAO"		OF oNFe1 TITLE OemToAnsi("Data Emissao") 	AUTO SIZE   



Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReport บAutor  ณFelipi Marques      บ Data ณ  08/19/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para busca das informa็๕es que serใo impressas      บฑฑ
ฑฑบ          ณ   no relat๓rio                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function PrintReport(oReport)

Local aSF1Area		:= SF1->(GetArea())
Local aZ02Area		:= Z02->(GetArea())

Local oEscrituradas	:= oReport:Section(1)
Local oElegiveis	:= oReport:Section(2)
Local oCanceladas	:= oReport:Section(3)
Local oXMLImp		:= oReport:Section(4)
Local oXMLCanc		:= oReport:Section(5)
Local oXMLxNFe		:= oReport:Section(6)
Local oNFexXML		:= oReport:Section(7)
Local oTotais		:= oReport:Section(8)

Local cQuery1		:= ""


Local cAlias1		:= "" 

Local cDtInicial
Local cDtFinal
Local aAux
Local nX  
Local cEspecies		:= ''

Local lSerie		:= .F.

Local nTotNfe1		:= 0
Local nTotNfe2		:= 0
Local nTotNfe3		:= 0
Local nTotNfe4		:= 0
Local nTotNfe5		:= 0
Local nTotNfe6		:= 0
Local nTotNfe7		:= 0

Local nRow			:= oReport:Row()
Local nCol			:= oReport:Col()

/*Realiza o Print da primeira estrutura*/ 
nRow := oReport:Row()
nCol := oReport:Col()

cDtInicial := DtoS(MV_PAR04)
cDtFinal   := DtoS(MV_PAR05)                    
aAux	   := Separa( MV_PAR01,";" )
aAux2	   := {}

For nX := 1 To Len(aAux)
	If Empty(aAux[nX])
		aDel(aAux, nX)
	Else
		aAdd( aAux2, aAux[nX] )
	EndIf
Next nX

For nX := 1 To Len(aAux2)
	If nX == Len(aAux2)
		If !Empty(aAux2[nX])
			cEspecies  += "'"+AllTrim(aAux2[nX])+"'"
		EndIf
	Else
		If !Empty(aAux2[nX])
			cEspecies  += "'"+AllTrim(aAux2[nX])+"',"
		EndIf
	EndIf
Next nX

    
	/*Notas Escrituradas - INICIO*/
	If MV_PAR06 == 1
		oReport:SkipLine()
		nRow		:= oReport:Row()
		nCol		:= oReport:Col() 	
		oReport:PrintText("NF-e suspeitas",nRow)
		oEscrituradas:Init()
	EndIf

 	If MV_PAR06 == 1 //Sintetico   
		oEscrituradas:Finish()
		oReport:SkipLine()
		oReport:SkipLine()	
	EndIf
	/*Notas Escrituradas - FIM*/
		
	/*Notas Elegiveis   - INICIO*/
 	If MV_PAR06 == 1 //Sintetico   
		nRow		:= oReport:Row()
		nCol		:= oReport:Col() 	
		oReport:Say(nRow,nCol,"Notas Elegiveis",) 	
		oElegiveis:Init()
	EndIf
	
	cQuery2 := " SELECT F3_FILIAL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_CHVNFE,F3_EMISSAO,F3_TIPO,F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA " 
	cQuery2 += " FROM " +RetSqlName("SF3")+ " SF3 "
	cQuery2 += " LEFT JOIN "+RetSqlName("SF1")+ " SF1 ON "
	cQuery2 += " SF3.F3_FILIAL  	= SF1.F1_FILIAL 	AND "
	cQuery2 += " SF3.F3_NFISCAL 	= SF1.F1_DOC 		AND "
	cQuery2 += " SF3.F3_SERIE   	= SF1.F1_SERIE 		AND "
	cQuery2 += " SF3.F3_CLIEFOR 	= SF1.F1_FORNECE	AND "
	cQuery2 += " SF3.F3_LOJA 	= SF1.F1_LOJA		AND "
	cQuery2 += " SF3.F3_ESPECIE = SF1.F1_ESPECIE    AND "
	cQuery2 += " SF3.F3_FORMUL = SF1.F1_FORMUL AND "
	cQuery2 += " SF3.D_E_L_E_T_ = SF1.D_E_L_E_T_ "
	cQuery2 += " WHERE "
	cQuery2 += " SF3.F3_EMISSAO >= '"+cDtInicial+"' AND "
	cQuery2 += " SF3.F3_EMISSAO <= '"+cDtFinal+"' AND "	
	cQuery2 += " SF3.F3_NFISCAL >= '"+MV_PAR02+"' AND "
	cQuery2 += " SF3.F3_NFISCAL <= '"+MV_PAR03+"' AND "	
	cQuery2 += " SF3.F3_FORMUL  = '' AND "
	cQuery2 += " SF3.D_E_L_E_T_ = '' "
	cQuery2 += " GROUP BY F3_FILIAL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_CHVNFE,F3_EMISSAO,F3_TIPO,F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA"
	
	Conout( cQuery2 )	
		
	cAlias2 := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery2), cAlias2, .F., .T.)
	While (cAlias2)->(!Eof())        
	
		If !Empty((cAlias2)->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) )       
		
			nTotNfe2++
		 	If MV_PAR06 == 1 //Analitico
		 	
				oElegiveis:Cell("ITEM")  		:SetValue(	CvalToChar(nTotNfe2)	)
				oElegiveis:Cell("NUMNFE")		:SetValue(	(cAlias2)->F3_NFISCAL 	)
				oElegiveis:Cell("SERIE")		:SetValue(	(cAlias2)->F3_SERIE 	)
				oElegiveis:Cell("FORNECE")		:SetValue(	(cAlias2)->F3_CLIEFOR 	)
				oElegiveis:Cell("LOJA")			:SetValue(	(cAlias2)->F3_LOJA 		)
				oElegiveis:Cell("ESPECIE")		:SetValue(	(cAlias2)->F3_ESPECIE 	)
				oElegiveis:Cell("CHAVE")		:SetValue(	(cAlias2)->F3_CHVNFE 	)
				oElegiveis:Cell("DTEMISSAO")	:SetValue(	StoD((cAlias2)->F3_EMISSAO) 	)
				
		   		oElegiveis:PrintLine()
		   		
		   	EndIf			

		EndIf
	
		If (cAlias2)->F3_TIPO $ "B|D" //Devolu็ใo e Beneficiamento
		
			If ( (cAlias2)->F3_TIPO == "B" .Or. (cAlias2)->F3_TIPO == "D" ) .And. Posicione("SF3",5, (cAlias2)->(F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA), "F3_CFO") $ "123"
			
				SF2->(DbSetOrder(1))
				If SF2->(DbSeek( (cAlias2)->(F3_FILIAL+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA) ) )
				
					nTotNfe2++
					
				 	If MV_PAR06 == 1 //Analitico		
				 	
						oElegiveis:Cell("ITEM")  		:SetValue(	CvalToChar(nTotNfe2)		)
						oElegiveis:Cell("NUMNFE")		:SetValue(	(cAlias2)->F3_NFISCAL 		)
						oElegiveis:Cell("SERIE")		:SetValue(	(cAlias2)->F3_SERIE 		)
						oElegiveis:Cell("FORNECE")		:SetValue(	(cAlias2)->F3_CLIEFOR 		)
						oElegiveis:Cell("LOJA")			:SetValue(	(cAlias2)->F3_LOJA 			)
						oElegiveis:Cell("ESPECIE")		:SetValue(	(cAlias2)->F3_ESPECIE 		)
						oElegiveis:Cell("CHAVE")		:SetValue(	(cAlias2)->F3_CHVNFE 		)
						oElegiveis:Cell("DTEMISSAO")	:SetValue(	StoD((cAlias2)->F3_EMISSAO) )
						
				   		oElegiveis:PrintLine()
				   		
				  	EndIf
					
				EndIf
				
			EndIf
					
		EndIf
	
		(cAlias2)->(DbSkip())
		
	End	
	
 	If MV_PAR06 == 1 //Analitico
		oElegiveis:Finish()
		oReport:SkipLine()
		oReport:SkipLine()
	EndIf
	/*Notas Elegiveis   - FIM*/
	
	/*Notas Canceladas  - INICIO*/
 	If MV_PAR06 == 1 //Analitico              
		nRow		:= oReport:Row()
		nCol		:= oReport:Col() 	
		oReport:Say(nRow,nCol,"Notas Canceladas",) 		
		oCanceladas:Init()
	EndIf
	/*
	cQuery3 := "SELECT F3_FILIAL, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, F3_LOJA, F3_ESPECIE, F3_CHVNFE, F3_EMISSAO FROM " +RetSqlName("SF3")+ " SF3 "
	cQuery3 += " WHERE "
	cQuery3 += " F3_FILIAL = '"+xFilial("SF3")+"' AND "
	
	cQuery3 += " ( SubString(F3_CFO,1,1) IN ('1','2','3') OR "
	cQuery3 += " F3_TIPO IN ('B','D') ) AND "
	
		cQuery3 += " ( ( SubString(SF3.F3_CFO,1,1) IN ('1','2','3') ) OR "
	cQuery3 += " ( SF3.F3_TIPO = 'B' AND SubString(SF3.F3_CFO,1,1) IN ('1','2','3') ) OR "
	cQuery3 += " ( SF3.F3_TIPO = 'D' AND SubString(SF3.F3_CFO,1,1) IN ('1','2','3') ) ) AND "
	

	cQuery3 += " F3_EMISSAO >= '"	+cDtInicial+	"' AND "
	cQuery3 += " F3_EMISSAO <= '"	+cDtFinal+	"' AND "	
	cQuery3 += " F3_NFISCAL >= '"+MV_PAR02+"' AND "
	cQuery3 += " F3_NFISCAL <= '"+MV_PAR03+"' AND "
	cQuery3 += " F3_FORMUL  =  '' AND "	
	cQuery3 += " F3_DTCANC <> ''  AND "
	cQuery3 += " D_E_L_E_T_ = '' "
	cQuery3 += " GROUP BY SF3.F3_FILIAL, SF3.F3_NFISCAL, SF3.F3_SERIE, SF3.F3_CLIEFOR, SF3.F3_LOJA, SF3.F3_ESPECIE, SF3.F3_CHVNFE, SF3.F3_EMISSAO "
	
	
	cAlias3 := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery3), cAlias3, .F., .T.)
	While (cAlias3)->(!Eof())
		
		nTotNfe3++              
	 	If MV_PAR06 == 1 //Analitico
	 	
			oCanceladas:Cell("ITEM")  		:SetValue(	CvalToChar(nTotNfe3)	)
			oCanceladas:Cell("NUMNFE")		:SetValue(	(cAlias3)->F3_NFISCAL 	)
			oCanceladas:Cell("SERIE")		:SetValue(	(cAlias3)->F3_SERIE 	)
			oCanceladas:Cell("FORNECE")		:SetValue(	(cAlias3)->F3_CLIEFOR 	)
			oCanceladas:Cell("LOJA")		:SetValue(	(cAlias3)->F3_LOJA 		)
			oCanceladas:Cell("ESPECIE")		:SetValue(	(cAlias3)->F3_ESPECIE 	)
			oCanceladas:Cell("CHAVE")		:SetValue(	(cAlias3)->F3_CHVNFE 	)
			oCanceladas:Cell("DTEMISSAO")	:SetValue(	StoD((cAlias3)->F3_EMISSAO) 	)
		
	   		oCanceladas:PrintLine()
	 	
	 	EndIf
   		
   		(cAlias3)->(DbSkip())		
			
	End                 
    */
 	If MV_PAR06 == 1 //Analitico
 	
		oCanceladas:Finish()
		oReport:SkipLine()
		oReport:SkipLine()
	
	EndIf
	/*Notas Canceladas  - FIM*/
		
	/*XML Importados  - INICIO*/
 	If MV_PAR06 == 1 //Analitico	
		nRow		:= oReport:Row()
		nCol		:= oReport:Col() 	
		oReport:Say(nRow,nCol,"XML Importados",) 		
		oXMLImp:Init()
	EndIf
	
	cQuery4 := "SELECT * FROM " +RetSqlName("Z02")+ " Z02 "
	cQuery4 += " WHERE "
	cQuery4 += " Z02.Z02_DTNFE >= '"+cDtInicial+"' AND "
	cQuery4 += " Z02.Z02_DTNFE <= '"+cDtFinal+"' AND "
	cQuery4 += " Z02.Z02_NUMNF >= '"+MV_PAR02+"' AND "
	cQuery4 += " Z02.Z02_NUMNF <= '"+MV_PAR03+"' AND "
	cQuery4 += " Z02.D_E_L_E_T_ = '' "
	cQuery4 += " ORDER BY Z02.Z02_FILIAL, Z02.Z02_NUMNF, Z02.Z02_SERIE "
	
	cAlias4 := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery4), cAlias4, .F., .T.)
	While (cAlias4)->(!Eof())
		nTotNFe4++
		
		If MV_PAR06 == 1 //Analitico
		
			oXMLImp:Cell("ITEM")  		:SetValue(	CvalToChar(nTotNfe4)	)
			oXMLImp:Cell("NUMNFE")		:SetValue(	(cAlias4)->Z02_NUMNF 	)
			oXMLImp:Cell("SERIE")		:SetValue(		(cAlias4)->Z02_SERIE 	)
			oXMLImp:Cell("FORNECE")		:SetValue(	""	)
			oXMLImp:Cell("LOJA")		:SetValue(	"" 	)
			oXMLImp:Cell("ESPECIE")		:SetValue(	"" 						)
			oXMLImp:Cell("CHAVE")		:SetValue(	(cAlias4)->Z02_CHVNFE 	)
			oXMLImp:Cell("DTEMISSAO")	:SetValue(	StoD((cAlias4)->Z02_DTNFE) 	)
			
			oXMLImp:PrintLine()
			
		EndIf
		
		(cAlias4)->(DbSkip())
				
	End

 	If MV_PAR06 == 1 //Analitico		
		oXMLImp:Finish()
		oReport:SkipLine()
		oReport:SkipLine()
	EndIf
	/*XML Importados  - FIM*/ 
	
	/*XML Cancelados  - INICIO*/ 
 	If MV_PAR06 == 1 //Analitico             
		nRow		:= oReport:Row()
		nCol		:= oReport:Col() 	
 		oReport:Say(nRow,nCol,"XML Cancelados",)
		oXMLCanc:Init()
	EndIf
	
	cQuery5 := "SELECT * FROM " +RetSqlName("Z02")+ " Z02 "
	cQuery5 += " WHERE "
	cQuery5 += " Z02.Z02_DTNFE >= '"+cDtInicial+"' AND "
	cQuery5 += " Z02.Z02_DTNFE <= '"+cDtFinal+"' AND "
	cQuery5 += " Z02.Z02_NUMNF >= '"+MV_PAR02+"' AND "
	cQuery5 += " Z02.Z02_NUMNF <= '"+MV_PAR03+"' AND "
	cQuery5 += " Z02.D_E_L_E_T_ = '' "
	cQuery5 += " ORDER BY Z02.Z02_FILIAL, Z02.Z02_NUMNF, Z02.Z02_SERIE "

	cAlias5 := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery5), cAlias5, .F., .T.)
	While (cAlias5)->(!Eof())
	
		nTotNFe5++
	 	If MV_PAR06 == 1 //Analitico
	 	
			oXMLCanc:Cell("ITEM")  		:SetValue(	CvalToChar(nTotNfe5)	)
			oXMLCanc:Cell("NUMNFE")		:SetValue(	(cAlias5)->Z02_NUMNF 	)
			oXMLCanc:Cell("SERIE")		:SetValue(	"" 	)
			oXMLCanc:Cell("FORNECE")	:SetValue(	"" 	)
			oXMLCanc:Cell("LOJA")		:SetValue(	"" 	)
			oXMLCanc:Cell("ESPECIE")	:SetValue(	"" 						)
			oXMLCanc:Cell("CHAVE")		:SetValue(	(cAlias5)->Z02_CHVNFE 	)
			oXMLCanc:Cell("DTEMISSAO")	:SetValue(	StoD((cAlias5)->Z02_DTNFE) 	)
			
			oXMLCanc:PrintLine()
			
		EndIf
	
	
		(cAlias5)->(DbSkip())
		
	End
	
 	If MV_PAR06 == 1 //Analitico
 	
		oXMLCanc:Finish()
		oReport:SkipLine()
		oReport:SkipLine()	
	
	EndIf
	/*XML Cancelados  - FIM*/ 
	
	/*XML x NFE  - INICIO*/ 
	If MV_PAR06 == 1 //Analitico
		nRow		:= oReport:Row()
		nCol		:= oReport:Col()	
		oReport:Say(nRow,nCol,"XML x NFe",)
		oXMLxNFe:Init()              
	EndIf
	
	cQuery6 := " SELECT * FROM " +RetSqlName("Z02")+ " Z02 "
	cQuery6 += " LEFT JOIN " +RetSqlName("SF1")+ " SF1 ON "
	cQuery6 += " Z02.Z02_NUMNF = SF1.F1_DOC AND "
	cQuery6 += " Z02.Z02_SERIE = SF1.F1_SERIE AND "
//	cQuery6 += " Z02.Z02_CODFOR = SF1.F1_FORNECE AND "
//	cQuery6 += " Z02.Z02_LOJFOR = SF1.F1_LOJA  AND "
	cQuery6 += " Z02.D_E_L_E_T_ = SF1.D_E_L_E_T_  "	
	cQuery6 += " LEFT JOIN " +RetSqlName("SF3")+ " SF3 ON "
	cQuery6 += " SF1.F1_FILIAL = SF3.F3_FILIAL AND "
	cQuery6 += " SF1.F1_DOC = SF3.F3_NFISCAL AND "
	cQuery6 += " SF1.F1_SERIE = SF3.F3_SERIE AND "
	cQuery6 += " SF1.F1_FORNECE = SF3.F3_CLIEFOR AND "
	cQuery6 += " SF1.F1_LOJA = SF3.F3_LOJA AND "
	cQuery6 += " SF1.D_E_L_E_T_ = SF3.D_E_L_E_T_  "		
	cQuery6 += " WHERE "
	cQuery6 += " Z02.Z02_FILIAL = '" +xFilial("Z02")+ "' AND "
	cQuery6 += " Z02.Z02_DTNFE >= '"+cDtInicial+"' AND "
	cQuery6 += " Z02.Z02_DTNFE <= '"+cDtInicial+"' AND "
	cQuery6 += " Z02.Z02_NUMNF >= '"+MV_PAR02+"' AND "
	cQuery6 += " Z02.Z02_NUMNF <= '"+MV_PAR03+"' AND "
	cQuery6 += " Z02.D_E_L_E_T_ = ''  "
   //	cQuery6 += " AND Z02.Z02_CANC = '' "
	cQuery6 += " ORDER BY Z02.Z02_FILIAL, Z02.Z02_NUMNF, Z02.Z02_SERIE"
	
	Conout(cQuery6)
    
	cAlias6	:= GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery6), cAlias6, .F., .T.)
 /*	While (cAlias6)->(!Eof())
	    
		//Se a funcao Val aplicada a ambos os valores (Z02_SERIE e F1_SERIE) forem iguais nใo imprime diferencas
	  	If (cAlias6)->(Z02_NUMNF+Z02_SERIE+Z02_CODFOR+Z02_LOJFOR) != (cAlias6)->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			
			SF1->(DbSetOrder(1))
			If SF1->(!DbSeek(xFilial("SF1")+(cAlias6)->Z02_NUMNF+StrZero(Val((cAlias6)->Z02_SERIE),TamSx3("F1_SERIE")[1])+(cAlias6)->Z02_CODFOR+(cAlias6)->Z02_LOJFOR))
			//If (cAlias6)->Z02_NUMNF+CvalToChar(Val((cAlias6)->Z02_SERIE))+(cAlias6)->Z02_CODFOR+(cAlias6)->Z02_LOJFOR != (cAlias6)->F1_DOC+CvalToChar(Val((cAlias6)->F1_SERIE))+(cAlias6)->F1_FORNECE+(cAlias6)->F1_LOJA
		    
				nTotNFe6++
						
			 	If MV_PAR06 == 1 //Analitico
			 	
					oXMLxNfe:Cell("ITEM")  		:SetValue(	CvalToChar(nTotNfe6)	)
					oXMLxNfe:Cell("NUMNFE")		:SetValue(	(cAlias6)->Z02_NUMNF 	)
					oXMLxNfe:Cell("SERIE")		:SetValue(	(cAlias6)->Z02_SERIE 	)
					oXMLxNfe:Cell("FORNECE")	:SetValue(	(cAlias6)->Z02_CODFOR 	)
					oXMLxNfe:Cell("LOJA")		:SetValue(	(cAlias6)->Z02_LOJFOR 	)
					oXMLxNfe:Cell("ESPECIE")	:SetValue(	"" 						)
					oXMLxNfe:Cell("CHAVE")		:SetValue(	(cAlias6)->Z02_CHVNFE 	)
					oXMLxNfe:Cell("DTEMISSAO")	:SetValue(	StoD((cAlias6)->Z02_DTNFE) 	)
				
					oXMLxNfe:PrintLine()
					
				EndIf
				
			EndIf
												
		EndIf
		(cAlias6)->(DbSkip())
		
	End */              
	             
	If MV_PAR06 == 1 //Analitico
		oXMLxNfe:Finish()
		oReport:SkipLine()
		oReport:SkipLine()
	EndIf
	
	/*XML x NFE  - FIM*/ 	
	
	/* NFE x XML - INICIO*/ 	
 	If MV_PAR06 == 1 //Analitico
		nRow		:= oReport:Row()
		nCol		:= oReport:Col() 	
 		oReport:Say(nRow,nCol,"NFe x XML",)
		oNFexXML:Init()
	EndIf  
	
	//cQuery7 := "SELECT * FROM "+RetSqlName("SF3") + " SF3 "  
	cQuery7 := "SELECT F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,Z02_NUMNF,Z02_SERIE,F3_ESPECIE,F3_CHVNFE,F3_EMISSAO FROM "+RetSqlName("SF3") + " SF3 "  
	cQuery7 += " LEFT JOIN "+RetSqlName("Z02")+ " Z02 ON "
	cQuery7 += " Z02.Z02_NUMNF = SF3.F3_NFISCAL AND  "
	cQuery7 += " Z02.Z02_SERIE   = SF3.F3_SERIE AND  "
/*	cQuery7 += " Z02.Z02_CODFOR = SF3.F3_CLIEFOR AND "
	cQuery7 += " Z02.Z02_LOJFOR = SF3.F3_LOJA  "*/
	cQuery7 += " WHERE "
	cQuery7 += " ( ( SubString(SF3.F3_CFO,1,1) IN ('1','2','3') ) OR "
	cQuery7 += " ( SF3.F3_TIPO = 'B' AND SubString(SF3.F3_CFO,1,1) IN ('1','2','3') ) OR "
	cQuery7 += " ( SF3.F3_TIPO = 'D' AND SubString(SF3.F3_CFO,1,1) IN ('1','2','3') ) ) AND "
	cQuery7 += " SF3.F3_EMISSAO >= '"+cDtInicial+"' AND "
	cQuery7 += " SF3.F3_EMISSAO <= '"+cDtFinal+"' AND "	
	cQuery7 += " SF3.F3_ESPECIE IN ("+cEspecies+") AND "
	cQuery7 += " SF3.F3_NFISCAL >= '"+MV_PAR02+"' AND "
	cQuery7 += " SF3.F3_NFISCAL <= '"+MV_PAR03+"' AND "		
	cQuery7 += " SF3.F3_FORMUL  = '' AND "
   //	cQuery7 += " SF3.F3_DTCANC  = '' AND "	
	cQuery7 += " SF3.D_E_L_E_T_ = '' "
	//cQuery7 += " ORDER BY Z02.Z02_FILIAL, Z02.Z02_NUMNF, Z02.Z02_SERIE, Z02.Z02_CODFOR, Z02.Z02_LOJFOR "              
	cQuery7 += " GROUP BY 	F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,Z02_NUMNF,Z02_SERIE,F3_ESPECIE,F3_CHVNFE,F3_EMISSAO "
	    
	cAlias7 := GetNextAlias()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery7), cAlias7, .F., .T.)
	/*
	While (cAlias7)->(!Eof())	    
	
		//Avalio se ้ uma serie numerica
		//If Val((cAlias7)->F3_SERIE) == 0
			//Conout("Serie nao ้ numerica")
		//Else
			//Conout("Serie numerica")
		//EndIf
		
		If (cAlias7)->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA) != (cAlias7)->(Z02_NUMNF+Z02_SERIE+Z02_CODFOR+Z02_LOJFOR)
		    
			Z02->(DbSetOrder(2))
			If Z02->(!DbSeek(xFilial("Z02")+(cAlias7)->F3_NFISCAL+CvalToChar(Val((cAlias7)->F3_SERIE))+Space(02)+(cAlias7)->F3_CLIEFOR+(cAlias7)->F3_LOJA))		
			
				nTotNfe7++
				
			 	If MV_PAR06 == 1 //Analitico
				
					oNFexXML:Cell("ITEM")  		:SetValue(	CvalToChar(nTotNfe7)	)
					oNFexXML:Cell("NUMNFE")		:SetValue(	(cAlias7)->F3_NFISCAL 	)
					oNFexXML:Cell("SERIE")		:SetValue(	(cAlias7)->F3_SERIE 	)
					oNFexXML:Cell("FORNECE")	:SetValue(	(cAlias7)->F3_CLIEFOR 	)
					oNFexXML:Cell("LOJA")		:SetValue(	(cAlias7)->F3_LOJA 		)
					oNFexXML:Cell("ESPECIE")	:SetValue(	(cAlias7)->F3_ESPECIE 	)
					oNFexXML:Cell("CHAVE")		:SetValue(	(cAlias7)->F3_CHVNFE 	)
					oNFexXML:Cell("DTEMISSAO")	:SetValue(	StoD((cAlias7)->F3_EMISSAO) 	)
					
					oNFexXML:PrintLine()
					
				EndIf
				
			EndIf
			
		EndIf
		(cAlias7)->(DbSkip())
	End                 	  
	*/
 	If MV_PAR06 == 1 //Analitico
 	
		oNFexXML:Finish()
		oReport:SkipLine()
		oReport:SkipLine()
		
	EndIf
	/* NFE x XML - FIM*/
	
	/*Totalizador - INICIO*/
	oTotais:Init()
	
	oTotais:Cell("TOT1")  		:SetValue(	CvalToChar(nTotNfe1)	)
	oTotais:Cell("TOT2")  		:SetValue(	CvalToChar(nTotNfe2)	)	
	oTotais:Cell("TOT3")  		:SetValue(	CvalToChar(nTotNfe3)	)
	oTotais:Cell("TOT4")  		:SetValue(	CvalToChar(nTotNfe4)	)
	oTotais:Cell("TOT5")  		:SetValue(	CvalToChar(nTotNfe5)	)
	oTotais:Cell("TOT6")  		:SetValue(	CvalToChar(nTotNfe6)	)
	oTotais:Cell("TOT7")  		:SetValue(	CvalToChar(nTotNfe7)	)	
	
	oTotais:PrintLine()
	oTotais:Finish()
	/*Totalizador - FIM*/
		
//Else	                     

//EndIf

RestArea(aSF1Area)
RestArea(aZ02Area)

Return

  
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG   บAutor  ณFelipi Marques      บ Data ณ  08/19/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica perguntas, incluindo-as caso nao existam.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VALIDPERG()

ssAlias  := Alias()
cPerg := PADR(cPerg,10)  //CORRIGIDO DIA 11/06 - EUGENIO
aRegs    := {}

dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Especie(s) a serem consideradas	 ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","NF De     	    ?","","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","NF At้	 	 	?","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Emissao De   	?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Emissao At้ 	?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Tipo Relatorio 	?","","","mv_ch6","C",01,0,2,"C","","mv_par06","Analitico","Analitico","Analitico","","Sintetico","Sintetico","Sintetico","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(ssAlias)

Return