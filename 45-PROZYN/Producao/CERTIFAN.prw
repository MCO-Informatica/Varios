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

User Function CERTIFAN()
    Local aArea := getArea()
	Local cQuery := ""

	Private cPerg		:= PadR("CERTIFAN",10)

	AjustaSX1(cPerg)
	If !Pergunte(cPerg,.T.)
		return
	EndIf

	// Prepare Environment Empresa '01' filial '01'
	
	cQuery := " SELECT 
	cQuery += " ISNULL((SELECT C2_EMISSAO FROM SC2010 SC2 WHERE SC2.D_E_L_E_T_='' AND SC2.C2_FILIAL='"+xFilial("SC5")+"' AND SC2.C2_PRODUTO=SD2.D2_COD AND SC2.C2_LOTECTL=SD2.D2_LOTECTL),'') AS [C2_EMISSAO],
	cQuery += " G1_UNATVLD,G1_UNATIV,G1_ATIVIDA,G1_ATVLAUD,D2_COD,D2_LOTECTL,D2_LOCAL,D2_DOC,D2_SERIE" 
	cQuery += " FROM "+RetSqlName("SD2")+" SD2
	cQuery += " LEFT JOIN "+RetSqlName("SA7")+" SA7 ON SA7.D_E_L_E_T_ = '' AND SD2.D2_COD = SA7.A7_PRODUTO AND SD2.D2_CLIENTE =  SA7.A7_CLIENTE AND SD2.D2_LOJA =  SA7.A7_LOJA
	cQuery += " LEFT JOIN "+RetSqlName("SG1")+" SG1 ON SG1.D_E_L_E_T_ = '' AND SD2.D2_COD =  SG1.G1_COD AND SA7.A7_PRODUTO = SG1.G1_COD
	cQuery += " WHERE 
	cQuery += " SD2.D2_DOC >= '" + mv_par01 + "' AND
	cQuery += " SD2.D2_DOC <= '" + mv_par02 + "' AND
	cQuery += " SD2.D2_SERIE >= '" + mv_par03 + "' AND
	cQuery += " SD2.D2_SERIE <= '" + mv_par04 + "' AND
	cQuery += " SD2.D2_EMISSAO >= '" + DTOS(mv_par05) + "' AND
	cQuery += " SD2.D2_EMISSAO <= '" + DTOS(mv_par06) + "' AND
	cQuery += " SD2.D_E_L_E_T_ = '' AND
	cQuery += " SD2.D2_TIPO = 'N' AND
	cQuery += " SA7.A7_LAUDO = '0' AND
	cQuery += " SG1.G1_LAUDO = '1'
	cQuery += " ORDER BY SD2.D2_COD "
	cQuery := ChangeQuery(cQuery)
	
	If Select("TMPSD2") > 0
		TMPSD2->(DbCloseArea())
	EndIF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSD2",.F.,.T.)

	If TMPSD2->(EOF())
        MsgAlert("Nenhum produto localizado com estes parâmetros, por favor revise-os.","Atenção!")
        Return
	EndIF
	
	While TMPSD2->(!EOF())
		Processa( {|| gerLaudo() },"Aguarde" ,"Gerando Certificado de Análise...")
		TMPSD2->(DbSkip())
	EndDo

    RestArea(aArea)

    // Reset Environment
Return

Static Function gerLaudo()
	Local nP			:= 0
	Local cUM 			:= ""
	Local cUM2	 		:= ""
	Local nAtivid 		:= 0
	Local nFator  		:= 0

	Private oPrn 		:= Nil
	Private cTime 		:= Time()
	Private cName		:= ""
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
	cName := "Certif_Analise_"+Trim(TMPSD2->D2_COD)+"_" + cHour + cMin + cSecs

	oPrn := FWMSPrinter():New(cName,IMP_PDF,.F.,"C:\TEMP\",.T.,,,,,.F.)
	oPrn:setDevice(IMP_PDF)
	oPrn:cPathPDF:="C:\TEMP\"
	oPrn:SetPortrait()//SetPortrait() //SetLandScape()
	oPrn:SetPaperSize(9) // <==== ajuste para papel A4

    oPrn:StartPage()
	ImpRodape()

	ImpLogo()

	nLine := 120
	oPrn:SayAlign(nLine,nW*20, "Certificado de Análise", 	oFont01, nW*960,0040,,2,1)
	oPrn:Line(nLine+32,nW*50,nLine+32,nW*950,CLR_BLACK,"-4")
	oPrn:Line(nLine+33,nW*50,nLine+33,nW*950,CLR_BLACK,"-4")

	If Empty(TMPSD2->G1_UNATVLD)  
		cUM     := POSICIONE("SAH",4,xFilial("SAH") + Substr(TMPSD2->G1_UNATIV+SPACE(40),1,40) ,"AH_UNIMED") //codigo da unidade de medida da atividade
		cUM2	 := TMPSD2->G1_UNATIV
		nAtivid := TMPSD2->G1_ATIVIDA
		nFator  := 1
	Else
		cUM     := POSICIONE("SAH",4,xFilial("SAH") + Substr(TMPSD2->G1_UNATVLD+SPACE(40),1,40) ,"AH_UNIMED") //codigo da unidade de medida da atividade	
		cUM2	 := TMPSD2->G1_UNATVLD
		nAtivid := TMPSD2->G1_ATVLAUD
		nFator  := 1
	EndIf		
	 
	If !Empty(POSICIONE("SAH",1,xFilial("SAH") + cUM,"AH_ATIV2"))
		nFator  := POSICIONE("SAH",1,xFilial("SAH") + cUM,"AH_FATOR")
		cUM2    := POSICIONE("SAH",1,xFilial("SAH") + cUM,"AH_ATIV2")  
	Endif

	cLaudo  := nAtivid * nFator

		
	DbSelectArea("SB8")
	DbSetOrder(3)

	dFabr := STOD(TMPSD2->C2_EMISSAO)
    dValid := CTOD("  /  /  ")
		
	If Empty(dFabr)
		If Dbseek(xFilial("SB8") + TMPSD2->D2_COD+"98"+TMPSD2->D2_LOTECTL)
			dFabr := SB8->B8_DATA
		ElseIf Dbseek(xFilial("SB8") + TMPSD2->D2_COD+TMPSD2->D2_LOCAL+TMPSD2->D2_LOTECTL)
			dFabr := SB8->B8_DATA
	    Else
	    	dFabr := CTOD("  /  /  ")
	    EndIf
    EndIf
	If Dbseek(xFilial("SB8") + TMPSD2->D2_COD+TMPSD2->D2_LOCAL+TMPSD2->D2_LOTECTL)
		dValid := SB8->B8_DTVALID
	EndIf

	nLine += 50

	oPrn:SayAlign(nLine,nW*75, "PRODUTO:",           		oFont03N, nW*180,0020,,0,2)
	oPrn:SayAlign(nLine+12,nW*75, "LOTE:",           		oFont03N, nW*180,0020,,0,2)
	oPrn:SayAlign(nLine+24,nW*75, "DATA DE FABRICAÇÃO:",	oFont03N, nW*180,0020,,0,2)
	oPrn:SayAlign(nLine+36,nW*75, "DATA DE VALIDADE:",     	oFont03N, nW*180,0020,,0,2)
	oPrn:SayAlign(nLine+48,nW*75, "NOTA FISCAL:",          	oFont03N, nW*180,0020,,0,2)

	oPrn:SayAlign(nLine,nW*260, trim(POSICIONE("SB1",1,xFilial("SB1") + TMPSD2->D2_COD,"B1_DESC")),           		oFont03, nW*260,0020,,0,2)
	oPrn:SayAlign(nLine+12,nW*260, trim(TMPSD2->D2_LOTECTL),           		oFont03, nW*260,0020,,0,2)
	oPrn:SayAlign(nLine+24,nW*260, DtoC(dFabr),	oFont03, nW*260,0020,,0,2)
	oPrn:SayAlign(nLine+36,nW*260, DtoC(dValid),     oFont03, nW*260,0020,,0,2)
	oPrn:SayAlign(nLine+48,nW*260, trim(TMPSD2->D2_DOC)+"-"+trim(TMPSD2->D2_SERIE),          oFont03, nW*260,0020,,0,2)


    nLine += 74

    oPrn:Fillrect({nLine,nW*75,nLine+20,nW*925},oBrush5,"-2")

	oPrn:Line(nLine,nW*75,nLine+20,nW*75,CLR_BLACK,"-2")
	oPrn:Line(nLine,nW*355,nLine+20,nW*355,CLR_BLACK,"-2")
	oPrn:Line(nLine,nW*640,nLine+20,nW*640,CLR_BLACK,"-2")
	oPrn:Line(nLine,nW*925,nLine+20,nW*925,CLR_BLACK,"-2")

	oPrn:Line(nLine,nW*75,nLine,nW*925,CLR_BLACK,"-2")
	oPrn:Line(nLine+20,nW*75,nLine+20,nW*925,CLR_BLACK,"-2")
	
	oPrn:SayAlign(nLine+5,nW*75, "PARÂMETROS",           		oFont03N, nW*280,0020,,2,2)
	oPrn:SayAlign(nLine+5,nW*355, "ESPECIFICAÇÕES",          	oFont03N, nW*280,0020,,2,2)
	oPrn:SayAlign(nLine+5,nW*640, "RESULTADOS",           	oFont03N, nW*285,0020,,2,2)

	nLine += 20

	aParameters := {{"Atividade enzimática",alltrim("Mín.: " + AllTrim(Transform(cLaudo,"@E 99,999,999")) + " " + cUM2),"Aprovado"},{"Chumbo","Máx.: 5 ppm","Aprovado*"},{"Coliformes Totais","Máx.: 30 UFC/g","Aprovado*"},{"Salmonella sp.","Ausência 25g","Ausência*"},{"E. coli","Ausência 25g","Ausência*"}}

	For nP := 1 to len(aParameters)

		oPrn:Line(nLine,nW*75,nLine+20,nW*75,CLR_BLACK,"-2")
		oPrn:Line(nLine,nW*355,nLine+20,nW*355,CLR_BLACK,"-2")
		oPrn:Line(nLine,nW*640,nLine+20,nW*640,CLR_BLACK,"-2")
		oPrn:Line(nLine,nW*925,nLine+20,nW*925,CLR_BLACK,"-2")

		oPrn:Line(nLine,nW*75,nLine,nW*925,CLR_BLACK,"-2")
		oPrn:Line(nLine+20,nW*75,nLine+20,nW*925,CLR_BLACK,"-2")
		
		oPrn:SayAlign(nLine+5,nW*75, aParameters[nP][1],           		oFont03, nW*280,0020,,2,2)
		oPrn:SayAlign(nLine+5,nW*355, aParameters[nP][2],          	oFont03, nW*280,0020,,2,2)
		oPrn:SayAlign(nLine+5,nW*640, aParameters[nP][3],           	oFont03, nW*285,0020,,2,2)

		nLine += 20
	Next nP

	oPrn:SayAlign(nLine+5,nW*75, "*Estas análises não são feitas lote a lote, mas sim de acordo com o plano de amostragem e monitoramento de contaminantes Prozyn.", oFont05, nW*850,0020,,2,2)

	nLine += 40

	ImpSign(nLine,nW*75)

	nLine += 65
	
	oPrn:SayAlign(nLine+5,nW*75, "Jadyr Mendes de Oliveira", oFont05N, nW*850,0020,,0,2)
	oPrn:SayAlign(nLine+15,nW*75, "Responsável Técnico", oFont05, nW*850,0020,,0,2)
	oPrn:SayAlign(nLine+25,nW*75, "CRQ Nº 04366891", oFont05, nW*850,0020,,0,2)
	

    oPrn:EndPage()

	oPrn:Preview()
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

	cLogo := GetSrvProfString("Startpath","") + "RODAPE_transp.png"

	oPrn:SayBitmap(720, 0,cLogo,nW*1000,110)
	oPrn:SayAlign(770,nW*710, "www.prozyn.com",          oFont07N, nW*250,0020,oBrush6,0,2)
	oPrn:SayAlign(780,nW*710, "prozyn@prozyn.com",       oFont07, nW*250,0020,oBrush6,0,2)
	oPrn:SayAlign(790,nW*710, "55.11.3732-0000",        oFont07, nW*250,0020,oBrush6,0,2)

Return()


Static Function ImpLogo()

	Local cLogo      	:= FisxLogo("1")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Logotipo                                     						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cLogo := GetSrvProfString("Startpath","") + "logotipo.png"

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

