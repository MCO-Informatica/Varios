#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FwPrintSetup.CH"

#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF 6

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CERTIFAN    º Autor ³ Denis Varella  Data ³ 15/02/2021     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Certificado de Análise                  	   			      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn     		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function OCERTIF2()
    Local aPergs   := {}
	Local cSerie := ""
	Local cDoc := ""
	Local cOP := ""
	Local cProduto := ""
	Local cLote := ""
	Local nIdioma := 1
    
	aAdd(aPergs, {1, "Série",  "1  ",  "", ".T.", "", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Nota Fiscal",  space(9),  "", ".T.", "SF2", ".T.", 80,  .F.})

	aAdd(aPergs, {1, "Ordem de Produção",  space(14),  "", ".T.", "SC2", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Produto",  space(15),  "", ".T.", "SB1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Lote",  space(26),  "", ".T.", "CB8", ".T.", 80,  .F.})
	aAdd(aPergs, {2, "Idioma",  nIdioma, {"1=Português","2=Inglês","3=Espanhol"},     80, ".T.", .F.})


    If ParamBox(aPergs, "Informe os parâmetros")
		cSerie := MV_PAR01
		cDoc := MV_PAR02
		cOP := MV_PAR03
		cProduto := MV_PAR04
		cLote := MV_PAR05
		nIdioma := MV_PAR06
		U_CERTIF2(cOP,cProduto,cLote,nIdioma,cDoc,cSerie)
	EndIf
Return

User Function CERTIF2(cOP,cProduto,cLote,nIdioma,cDoc,cSerie)
    Local aArea := getArea()
	Local aArray := {}

	Private cName := ""
	Private lQQ7 := .F.

	Default nIdioma := 1
	Default cDoc := ""
	Default cSerie := ""
	Default cProduto := ""
	Default cOP := ""
	Default cLote := ""

	// PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'

	aArray := GetInfos(cOP,cProduto,cLote,nIdioma,cDoc,cSerie)

	If Trim(FunName()) == 'OCERTIF2' .and. Empty(aArray)
		MsgAlert("Não foram encontrados resultados.","Atenção!")
		RestArea(aArea)
		Return
	EndIf

	gerLaudo(aArray,nIdioma,cDoc,cSerie)

	RestArea(aArea)

	// RESET ENVIRONMENT
Return cName

Static Function GetInfos(cOP,cProduto,cLote,nIdioma,cDoc,cSerie)
	Local cQry := ""
	Local cB1Desc := " B1_DESC "
	Local cAHDesc := " AH_DESCPO "
	Local cQP1Desc := " QP1_DESCPO "
	Private aInfos := {}
	Private cAnterior := ""
	Private aEnsaio := {}
	cQry += " SELECT distinct QPK_PRODUT CODPRODUTO, "
	cQry += " QPK_LOTE LOTE, "

	If nIdioma == 2
		cB1Desc := " B1_DESCIN "
		cAHDesc := " AH_DESCIN "
		cQP1Desc := " QP1_DESCIN "
	ElseIf nIdioma == 3
		cB1Desc := " B1_DESCES "
		cAHDesc := " AH_DESCES "
		cQP1Desc := " QP1_DESCES "
	EndIf
	cQry += " "+cB1Desc+" PRODUTO, "
	cQry += " B8_DFABRIC FABRICAC, "
	cQry += " B8_DTVALID VALIDADE, "
	cQry += " '' RECEBIME, "
	cQry += " QPR_XMETOD, "
	cQry += " QP7_UNIMED, "
	cQry += " QP7_MINMAX, "
	cQry += " QP7_LIC, "
	cQry += " QP7_LIC as LICNUM, "
	cQry += " QP7_LSC, " 
	cQry += " QP7_LSC AS LSCNUM, "
	cQry += " "+cAHDesc+", "
	cQry += " QPS_MEDICA, "
	cQry += " QPS_MEDICA as MEDICANUM, "
	cQry += " CASE WHEN QPQ_MEDICA IS NOT NULL THEN QPQ_MEDICA ELSE CASE WHEN QPS_MEDICA IS NULL  THEN CASE WHEN QPR_RESULT IS NULL THEN '' WHEN QPR_RESULT = 'A' THEN 'APROVADO' ELSE 'REPROVADO' END ELSE  LTRIM(RTRIM(QPS_MEDICA))+ ' '+ "+cAHDesc+"  END END RESULTAD, "
	cQry += " QP1_XMETOD ENSAIO, "
	cQry += " "+cQP1Desc+" CARACTER, "
	cQry += " CASE WHEN QP8_TEXTO IS NULL  THEN CASE WHEN QP7_MINMAX = 1  THEN RTRIM(LTRIM(QP7_LIC))+' a '+RTRIM(LTRIM(QP7_LSC)) + ' '+ "+cAHDesc+"  WHEN QP7_MINMAX = 2  THEN RTRIM(LTRIM(QP7_LIC)) + ' '+ "+cAHDesc+"  ELSE  RTRIM(LTRIM(QP7_LSC)) + ' '+ "+cAHDesc+" END  ELSE  QP8_TEXTO  END ESPECIF, "
	cQry += " QPL_JUSTLA OBSERVAC,
	cQry += " isnull(QQ7_ENSAIO,'') QQ7_ENSAIO

	cQry += " FROM QPK010 QPK   "
	cQry += " INNER JOIN SB1010 B1 ON B1_COD = QPK_PRODUT AND B1.D_E_L_E_T_ = ''   "
	cQry += " INNER JOIN SB8010 B8 ON B8_PRODUTO = QPK_PRODUT AND B8_LOTECTL = QPK_LOTE AND B8.D_E_L_E_T_ = ''   "
	cQry += " LEFT JOIN QPR010 QPR ON QPR_OP = QPK_OP AND QPK_PRODUT = QPR_PRODUT AND QPR_LOTE = QPK_LOTE AND QPR.D_E_L_E_T_ = ''   "
	cQry += " LEFT JOIN QP1010 QP1 ON QP1_ENSAIO = QPR_ENSAIO AND QP1.D_E_L_E_T_ = ''   "
	cQry += " LEFT JOIN QP7010 QP7 ON QP7_PRODUT = QPK_PRODUT AND QP7_ENSAIO = QPR_ENSAIO AND QPK_REVI = QP7_REVI AND QP7_CODREC = QPR_ROTEIR AND  QP7.D_E_L_E_T_ = ''    
 	cQry += " LEFT JOIN QP8010 QP8 ON QP8_PRODUT = QPK_PRODUT AND QP8_ENSAIO = QPR_ENSAIO AND QPK_REVI = QP8_REVI AND QP8_CODREC = QPR_ROTEIR AND QP8.D_E_L_E_T_ = ''  
	cQry += " LEFT JOIN QPQ010 QPQ ON QPQ_CODMED = QPR_CHAVE AND QPQ.D_E_L_E_T_ = '' "
	cQry += " LEFT JOIN QPS010 QPS ON QPS_CODMED = QPR_CHAVE AND QPS.D_E_L_E_T_ = ''   "
	cQry += " LEFT JOIN QPL010 QPL ON QPL_PRODUT = QPK_PRODUT AND QPL_OP = QPK_OP AND QPL_LOTE = QPK_LOTE AND QPL_LABOR = '' AND QPL.D_E_L_E_T_ = '' "
	cQry += " LEFT JOIN SAH010 SAH ON AH_UNIMED = QP7_UNIMED AND SAH.D_E_L_E_T_ = '' 

	if !empty(trim(cDoc))
		cQry += " INNER JOIN SD2010 D2 ON D2_COD = QPK_PRODUT AND D2_LOTECTL = QPK_LOTE AND D2.D_E_L_E_T_ = ''
		cQry += " LEFT JOIN QQ7010 QQ7 ON QQ7_PRODUT = QPK_PRODUT AND QQ7_CLIENT = D2_CLIENTE AND QQ7_LOJA = D2_LOJA AND QQ7_ENSAIO = QPR_ENSAIO AND QQ7.D_E_L_E_T_ = ''
	else
		cQry += " LEFT JOIN QQ7010 QQ7 ON QQ7_PRODUT = QPK_PRODUT AND QQ7_ENSAIO = QPR_ENSAIO AND QQ7.D_E_L_E_T_ = ''
	EndIf

	cQry += " WHERE QPK.D_E_L_E_T_ = ''  "

		If !empty(cOP)
			cQry += " AND QPK_OP = '"+cOP+"' "
		ElseIf !empty(cProduto)
			cQry += " AND QPK_PRODUT = '"+cProduto+"'
			If !empty(cLote)
				cQry += " AND QPK_LOTE = '"+cLote+"'
			EndIf
		ElseIf !empty(trim(cDoc))
			cQry += " AND D2_DOC = '"+cDoc+"'
		EndIf


	cQry += " ORDER BY QPK_PRODUT,QPK_LOTE,"+cQP1Desc

	MemoWrite('Qry_NBCertif2.txt',cQry)

	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQry),'CERTIF2',.T.,.T.)

	CERTIF2->(DbGoTop())
	While CERTIF2->(!EOF())

		If (CERTIF2->CODPRODUTO+CERTIF2->LOTE != cAnterior .and. !empty(cAnterior))
			if len(aEnsaio) > 0 .and. !empty(trim(aEnsaio[1][9]))
				aAdd(aInfos,{})
				aInfos[len(aInfos)] := aEnsaio
			EndIf
			aEnsaio := {}
			cAnterior := ""
		EndIf
		cESPECIF := CERTIF2->ESPECIF 
		cResult := CERTIF2->RESULTAD
		aAdd(aEnsaio, {CERTIF2->CODPRODUTO,;
		CERTIF2->PRODUTO,;
		CERTIF2->LOTE,;
		CERTIF2->FABRICAC,;
		CERTIF2->VALIDADE,;
		CERTIF2->RECEBIME,;
		cResult,;
		CERTIF2->ENSAIO,;
		CERTIF2->CARACTER,;
		cESPECIF,;
		CERTIF2->OBSERVAC,;
		"",;
		CERTIF2->FABRICAC,;
		CERTIF2->QQ7_ENSAIO})

		If !lQQ7 .and. !empty(trim(CERTIF2->QQ7_ENSAIO)) .and. !empty(trim(cDoc))
			lQQ7 := .T.
		EndIf

		cAnterior := CERTIF2->CODPRODUTO+CERTIF2->LOTE
		CERTIF2->(DbSkip())
	EndDo

	if len(aEnsaio) > 0 .and. !empty(trim(aEnsaio[1][9]))
		aAdd(aInfos,{})
		aInfos[len(aInfos)] := aEnsaio
	EndIf
	aEnsaio := {}
	cAnterior := ""

	CERTIF2->(DbCloseArea())
Return aInfos

Static Function gerLaudo(aArray,nIdioma,cDoc,cSerie)
	Local nA			:= 0
	Local nAr			:= 0
	Private oPrn 		:= Nil
	Private cTime 		:= Time()
	Private oBrush1 	:= TBrush():New( , CLR_BLACK)
	Private oBrush2 	:= TBrush():New( , CLR_WHITE)
	Private oBrush3 	:= TBrush():New( , CLR_GRAY)
	Private oBrush4 	:= TBrush():New( , CLR_HGRAY)
	Private oBrush5 	:= TBrush():New( , RGB( 240,240,240 ))
	Private oBrush6 	:= TBrush():New( , RGB( 120,120,120 ))
	Private oFont01		:= TFont():New( "Arial",,28,,.T.,,,,.T.,.F.) //Arial 18 - Negrito
	Private oFont02N	:= TFont():New( "Arial",,12,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
	Private oFont02		:= TFont():New( "Arial",,12,,.F.,,,,.F.,.F.) //Arial 11 - Negrito
	Private oFont03N	:= TFont():New( "Arial",,11,,.T.,,,,.F.,.F.) //Arial 12 - Normal
	Private oFont03		:= TFont():New( "Arial",,11,,.F.,,,,.F.,.F.) //Arial 12 - Normal
	Private oFont04		:= TFont():New( "Arial",,10,,.F.,,,,.F.,.F.) //Arial 09 - Normal
	Private oFont04N	:= TFont():New( "Arial",,10,,.T.,,,,.F.,.F.) //Arial 09 - Normal
	Private oFont05		:= TFont():New( "Arial",,09,,.F.,,,,.F.,.F.)
	Private oFont06		:= TFont():New( "Arial",,08,,.F.,,,,.F.,.F.)
	Private oFont05I	:= TFont():New( "Arial",,09,,.F.,,,,.F.,.T.)
	Private oFont05N	:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F.)
	Private oFont07		:= TFont():New( "Arial",,07,,.F.,,,,.F.,.F.)
	Private oFont07N	:= TFont():New( "Arial",,07,,.T.,,,,.F.,.F.)
	Private nLine 		:= 0
	Private nPag 		:= 0
	Private nW 			:= 600/1000

	cHour := SubStr( cTime, 1, 2 )
	cMin  := SubStr( cTime, 4, 2 )
	cSecs := SubStr( cTime, 7, 2 )
	cName := "Certif_Analise_"+Trim(cDoc)+"_" + cHour + cMin + cSecs

	oPrn := FWMSPrinter():New(cName,IMP_PDF,.F.,"C:\TEMP\",.T.,,,,,.F.)
	oPrn:setDevice(IMP_PDF)
	oPrn:cPathPDF:="C:\TEMP\"
	oPrn:SetPortrait()//SetPortrait() //SetLandScape()
	oPrn:SetPaperSize(9) // <==== ajuste para papel A4

	For nAr := 1 to len(aArray)
		oPrn:StartPage()
		ImpRodape()

		ImpLogo()

		nLine := 120
		If nIdioma == 2
			oPrn:SayAlign(nLine,nW*20, "Certificate of Analysis", 	oFont01, nW*960,0040,,2,1)
		ElseIf nIdioma == 3
			oPrn:SayAlign(nLine,nW*20, "Certificado de Análisis DE ANÁLISIS", 	oFont01, nW*960,0040,,2,1)
		Else
			oPrn:SayAlign(nLine,nW*20, "Certificado de Análise", 	oFont01, nW*960,0040,,2,1)
		EndIf

		oPrn:Line(nLine+32,nW*50,nLine+32,nW*950,CLR_BLACK,"-4")
		oPrn:Line(nLine+33,nW*50,nLine+33,nW*950,CLR_BLACK,"-4")

		nLine += 50

		oPrn:SayAlign(nLine,nW*75, Iif(nIdioma == 1,"PRODUTO:",Iif(nIdioma == 2,'PRODUCT:','PRODUCTO:')),           		oFont03N, nW*180,0020,,0,2)
		oPrn:SayAlign(nLine+12,nW*75, Iif(nIdioma == 1,"LOTE:",Iif(nIdioma == 2,'BATCH:','LOTE:')),           		oFont03N, nW*180,0020,,0,2)
		oPrn:SayAlign(nLine+24,nW*75, Iif(nIdioma == 1,"DATA DE FABRICAÇÃO:",Iif(nIdioma == 2,'MFG DATE:','FECHA DE ELABORACIÓN:')),	oFont03N, nW*180,0020,,0,2)
		oPrn:SayAlign(nLine+36,nW*75, Iif(nIdioma == 1,"DATA DE VALIDADE:",Iif(nIdioma == 2,'EXPIRE DATE:','FECHA DE VENCIMENTO:')),     	oFont03N, nW*180,0020,,0,2)
		If !empty(trim(cDoc))
			oPrn:SayAlign(nLine+48,nW*75, Iif(nIdioma == 1,"NOTA FISCAL:",Iif(nIdioma == 2,'INVOICE:','NOTA FISCAL:')),          	oFont03N, nW*180,0020,,0,2)
		EndIf

		oPrn:SayAlign(nLine,nW*260, trim(aArray[nAr][1][2]),oFont03, nW*260,0020,,0,2)
		oPrn:SayAlign(nLine+12,nW*260, trim(aArray[nAr][1][3]),oFont03, nW*260,0020,,0,2)
		oPrn:SayAlign(nLine+24,nW*260, DtoC(StoD(aArray[nAr][1][4])),oFont03, nW*260,0020,,0,2)
		oPrn:SayAlign(nLine+36,nW*260, DtoC(StoD(aArray[nAr][1][5])),oFont03, nW*260,0020,,0,2)
		If !empty(trim(cDoc))
			oPrn:SayAlign(nLine+48,nW*260, trim(cDoc)+"-"+trim(cSerie),oFont03, nW*260,0020,,0,2)
		EndIf


		nLine += 74

		oPrn:Fillrect({nLine,nW*75,nLine+20,nW*925},oBrush5,"-2")

		oPrn:Line(nLine,nW*75,nLine+20,nW*75,CLR_BLACK,"-2")
		oPrn:Line(nLine,nW*355,nLine+20,nW*355,CLR_BLACK,"-2")
		oPrn:Line(nLine,nW*640,nLine+20,nW*640,CLR_BLACK,"-2")
		oPrn:Line(nLine,nW*925,nLine+20,nW*925,CLR_BLACK,"-2")

		oPrn:Line(nLine,nW*75,nLine,nW*925,CLR_BLACK,"-2")
		oPrn:Line(nLine+20,nW*75,nLine+20,nW*925,CLR_BLACK,"-2")
		
		oPrn:SayAlign(nLine+5,nW*75, Iif(nIdioma == 1,"PARÂMETROS:",Iif(nIdioma == 2,'ANALYSIS:','ANÁLISIS:')),oFont03N, nW*280,0020,,2,2)
		oPrn:SayAlign(nLine+5,nW*355, Iif(nIdioma == 1,"ESPECIFICAÇÕES:",Iif(nIdioma == 2,'ESPECIFICATIONS:','SPECIFICATIÓNES:')),oFont03N, nW*280,0020,,2,2)
		oPrn:SayAlign(nLine+5,nW*640, Iif(nIdioma == 1,"RESULTADOS:",Iif(nIdioma == 2,'RESULTS:','RESULTADOS:')),oFont03N, nW*285,0020,,2,2)

		nLine += 20

		For nA := 1 to len(aArray[nAR])
			If (lQQ7 .and. !empty(aArray[nAr][nA][len(aArray[nAr][nA])])) .or. !lQQ7
				oPrn:Line(nLine,nW*75,nLine+20,nW*75,CLR_BLACK,"-2")
				oPrn:Line(nLine,nW*355,nLine+20,nW*355,CLR_BLACK,"-2")
				oPrn:Line(nLine,nW*640,nLine+20,nW*640,CLR_BLACK,"-2")
				oPrn:Line(nLine,nW*925,nLine+20,nW*925,CLR_BLACK,"-2")

				oPrn:Line(nLine,nW*75,nLine,nW*925,CLR_BLACK,"-2")
				oPrn:Line(nLine+20,nW*75,nLine+20,nW*925,CLR_BLACK,"-2")
				
				oPrn:SayAlign(nLine+5,nW*75, alltrim(aArray[nAr][nA][9]),           		oFont03, nW*280,0020,,2,2)
				oPrn:SayAlign(nLine+5,nW*355, alltrim(aArray[nAr][nA][10]),          	oFont03, nW*280,0020,,2,2)
				oPrn:SayAlign(nLine+5,nW*640, alltrim(aArray[nAr][nA][7]),           	oFont03, nW*285,0020,,2,2)

				nLine += 20
			EndIf
		Next nA

		If nIdioma == 1
			oPrn:SayAlign(nLine+5,nW*75, "*Estas análises não são feitas lote a lote, mas sim de acordo com o plano de amostragem e monitoramento de contaminantes Prozyn.", oFont05, nW*850,0020,,2,2)
		ElseIf nIdioma == 2
			oPrn:SayAlign(nLine+5,nW*75, "*These analyzes are not performed batch by batch, but according to the Prozyn Contaminant Monitoring and Sampling Plan.", oFont05, nW*850,0020,,2,2)
		ElseIf nIdioma == 3
			oPrn:SayAlign(nLine+5,nW*75, "*Estos análisis no se realizan lote por lote, sino de acuerdo con el Plan de Monitoreo y Muestreo de Contaminantes de Prozyn.", oFont05, nW*850,0020,,2,2)
		EndIf

		nLine += 40

		ImpSign(nLine,nW*75)

		nLine += 65
		
		oPrn:SayAlign(nLine+5,nW*75, "Jadyr Mendes de Oliveira", oFont02N, nW*850,0020,,0,2)

		If nIdioma == 1
			oPrn:SayAlign(nLine+15,nW*75, "Responsável Técnico", oFont03, nW*850,0020,,0,2)
		ElseIf nIdioma == 2
			oPrn:SayAlign(nLine+15,nW*75, "Technical Manager", oFont03, nW*850,0020,,0,2)
		ElseIf nIdioma == 3
			oPrn:SayAlign(nLine+15,nW*75, "Responsable Técnico", oFont03, nW*850,0020,,0,2)
		EndIf

		oPrn:SayAlign(nLine+25,nW*75, "CRQ Nº 04366891", oFont03N, nW*850,0020,,0,2)
		

		oPrn:EndPage()
	Next nAr

	// oPrn:Preview()
	oPrn:Print()
    __CopyFile(oPrn:cPathPDF+cName+'.pdf', "\Certificados de Analise\"+cName+'.pdf')
    FreeObj(oPrn)
	

Return()

Static Function ImpSign(nLine,nW)

	Local cLogo      	:= FisxLogo("1")

	cLogo := GetSrvProfString("Startpath","") + "AssLaudoTec.png"

	oPrn:SayBitmap(nLine,nW,cLogo,90,63)

Return()

Static Function ImpRodape()

	Local cLogo      	:= FisxLogo("1")

	cLogo := GetSrvProfString("Startpath","") + "RODAPE.png"

	oPrn:SayBitmap(720, 0,cLogo,nW*1000,110)
	oPrn:SayAlign(770,nW*710, "55.11.3732-0000",oFont02, nW*250,0020,RGB( 160,160,160 ),0,2)
	oPrn:SayAlign(780,nW*710, "qualidade@prozyn.com.br",oFont02, nW*250,0020,RGB( 160,160,160 ),0,2)
	oPrn:SayAlign(795,nW*710, "R Dr Paulo L. de Oliveira, 199",oFont02, nW*250,0020,RGB( 160,160,160 ),0,2)
	oPrn:SayAlign(805,nW*710, "05551-020 | Butantã | Sao Paulo | Brasil",oFont02, nW*250,0020,RGB( 160,160,160 ),0,2)

Return()

Static Function ImpLogo()

	Local cLogo      	:= FisxLogo("1")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Logotipo                                     						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cLogo := GetSrvProfString("Startpath","") + "logotipo.bmp"

	oPrn:SayBitmap(20, nw*710,cLogo,nW*175,79)

Return()

Static Function AjustaSX1(cPerg)
	Local j
	Local i
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg   := PADR(cPerg,10)
	aSx1   := {}

	AADD(aSx1,{ cPerg,"01","Da Nota Fiscal   ?","","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SF2",""})
	AADD(aSx1,{ cPerg,"02","Ate Nota Fiscal  ?","","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SF2",""})
	AADD(aSx1,{ cPerg,"03","Da Serie         ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aSx1,{ cPerg,"04","Ate Serie        ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aSx1,{ cPerg,"05","Da Data          ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aSx1,{ cPerg,"06","Ate Data         ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	// AADD(aSx1,{ cPerg,"07","Imprime resumo outros laudos (S/N):      ?","","","mv_ch7","N",01,0,0,"C","","MV_PAR07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})


	For i := 1 to Len(aSx1)
		If !dbSeek(cPerg+aSx1[i,2])
			RecLock("SX1",.T.)
			For j := 1 To FCount()
				If j <= Len(aSx1[i])
					FieldPut(j,aSx1[i,j])
				Else
					Exit
				EndIf
			Next
			MsUnlock()
		EndIf
	Next

	dbSelectArea(_sAlias)

Return(cPerg)

