#include "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "msgraphi.ch"
#INCLUDE "APWIZARD.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACPDPR001  บAutor  ณMicrosiga           บ Data ณ  11/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACPPR001()
	Local aAreaAtu	   :=GetArea()
	Local cQryAlias 	:=GetNextAlias()
	Local oReport
	Local cPerg := "EIC01"
	Private aDescri	:={}

	Pergunte(cPerg, .F.)     


	oReport := ReportDef(cQryAlias, cPerg)
	oReport:PrintDialog()

	If Select(cQryAlias)>0
		(cQryAlias)->(DbCloseArea())
	EndIf

	RestArea(aAreaAtu)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACPDPR001  บAutor  ณMicrosiga           บ Data ณ  11/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef(cQryAlias, cPerg)
	Local cTitle  := "Relat๓rio Mapeamento de Navios"
	Local cHelp   := "Permite gerar dados consolidados do POs em aberto."
	Local oReport
	Local oSection1
	Local aOrdem    := {}

	//TRCell():New( oSectionR, "cDescValor" ,/*Alias*/	,OemToAnsi(STR0031)	,/*Picture*/, 01,/*lPixel*/,/*{|| code-block de impressao }*/)			// Vlr Residual
	//oSectionR:Cell("cDescValor"):SetAlign("LEFT")

	oReport := TReport():New('ACPDPR001',cTitle,cPerg,{|oReport| ReportPrint(oReport,cQryAlias,aOrdem)},cHelp)
	//oReport:SetPortrait()
	oReport:SetLandScape()
	oReport:DisableOrientation()
	oSection1 := TRSection():New(oReport,"Mapeamento de Navios",{"SW2","SW3"},aOrdem)

	TRCell():New(oSection1,"W2_PO_NUM"		, cQryAlias, "Nr. P.O.")
	TRCell():New(oSection1,"W6_HAWB"		, cQryAlias, "Hawb")
	TRCell():New(oSection1,"W2_FORN"		, cQryAlias, "Exportador"	,/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"W2_ORIGEM"		, cQryAlias, "Origem")

	TRCell():New(oSection1,"DESCRI" 		,/*Alias*/	,"Descricao"	,/*Picture*/, Len(SB1->B1_DESC),/*lPixel*/,{|| PR001DESCRI(cQryAlias) })	
	TRCell():New(oSection1,"W3_QTDE"		, "SW3", "Quantidade"	,/*Picture*/, 18,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"W2_MOEDA"		, cQryAlias, "Moeda"	,/*Picture*/, 05,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"W3_PRECO"  		, "SW3", "Vlr. Total"	,"@E 99,999,999,999.99", /*tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	TRCell():New(oSection1,"W2_INCOTER"		, cQryAlias, "Incoterm")
	TRCell():New(oSection1,"W2_COND_PA"		, cQryAlias, "Cond.Pag")
	TRCell():New(oSection1,"W6_DT_ETD"		, cQryAlias, "Dt.Prev.Emb.",/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/) 
	TRCell():New(oSection1,"W6_DT_EMB"		, cQryAlias, "Dt.Emb.",/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/) 
	TRCell():New(oSection1,"W6_DT_ETA"		, cQryAlias, "Dt.Prev.Atra.",/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"W6_CHEG"	  	, cQryAlias, "Dt.Efet.Atra.",/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"W6_PRVDESE"	   	, cQryAlias, "Prv.DI.",/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"W6_CONEVE1"		, cQryAlias, "Navio")
	TRCell():New(oSection1,"WB_CA_DT"		, cQryAlias, "Dt.Fech.Cambio",/*Picture*/, 10,/*lPixel*/,/*{|| code-block de impressao }*/)

	oSection1:Cell("W3_QTDE"):SetAlign("RIGHT")
	oSection1:Cell("W3_PRECO"):SetAlign("RIGHT")

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACPDPR001  บAutor  ณMicrosiga           บ Data ณ  11/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport,cQryAlias,aOrdem)
	Local oSecao1 := oReport:Section(1)
	Local nOrdem  := oSecao1:GetOrder()

	//Local cOrderBy

	/*
	oReport:SetTitle(oReport:Title()+' (' + AllTrim(aOrdem[nOrdem]) + ')')


	cOrderBy := "%"
	If nOrdem == 1 //
	cOrderBy += 
	ElseIf nOrdem == 2 //
	cOrderBy += 
	EndIf
	cOrderBy += "%"
	*/                            


	oSecao1:BeginQuery()

	/*
	Para ler SW2 + SW3:
	SELECT * FROM SW2 INNER JOIN SW3 ON W2_FILIAL = W3_FILIAL AND W2_PO_NUM = W3_PO_NUM AND  AND SW3.D_E_L_E_T_ = ' ' 
	WHERE
	SW2.D_E_L_E_T_ = ' '

	Para ler SW6 (Pode ter varios)
	SELECT * FROM SW7 INNER JOIN SW6 ON W6_FILIAL = W7_FILIAL AND W6_HAWB = W7_HAWB AND W7_PO_NUM = @NUMPO AND W7_SEQ = 0

	Para ler SWB (Pode ter varios)
	SELECT * FROM SWB INNER JOIN SW6 ON W6_FILIAL = WB_FILIAL AND W6_HAWB = WB_HAWB 
	WHERE WB_CA_DT <> ' ' 
	*/

	//W2_FILIAL+   

	cData := Ctod(' ') 

	If Mv_Par01 == 1 // AMBOS          
		cMV_PAR01 := '      '
		cMV_PAR02 := '20991231'
	ElseIf Mv_Par01 == 2 // Somente com data embarque         
		cMV_PAR01 := '20000101'
		cMV_PAR02 := '20991231'	
	ElseIf Mv_Par01 == 3 // Sem data embarque         
		cMV_PAR01 := '      '
		cMV_PAR02 := '      '

	Endif	




	BeginSQL Alias cQryAlias

		Select W2_PO_NUM, W6_HAWB, W2_FORN, W2_ORIGEM,W2_MOEDA,W2_INCOTER,W2_COND_PA,W6_DT_ETD, W6_DT_EMB,W6_DT_ETA,W6_CHEG,W6_CONEVE1,WB_CA_DT,Sum(W3_QTDE) W3_QTDE,SUM(W3_QTDE*W3_PRECO) W3_PRECO, W6_PRVDESE
		From %Table:SW2% SW2,%Table:SW3% SW3,%Table:SW6% SW6,%Table:SWB% SWB,%Table:SW7% SW7
		Where W2_FILIAL = %xfilial:SW2%
		And SW2.W2_PO_NUM Between '      ' And 'ZZZZZZ'
		And SW2.%notDel%	
		And SW3.W3_FILIAL = %xfilial:SW3%
		And SW3.W3_PO_NUM = SW2.W2_PO_NUM
		And SW3.W3_SEQ = 0
		And SW3.%notDel%			
		And SW6.W6_FILIAL = %xfilial:SW6%
		And SW6.W6_HAWB Between '      ' And 'ZZZZZZ'
		And SW6.W6_DT_EMB Between %Exp:cMV_PAR01% And %Exp:cMV_PAR02%
		And SW6.%notDel%		
		And SW7.W7_FILIAL = %xfilial:SW7%
		And SW7.W7_HAWB=SW6.W6_HAWB
		And SW7.W7_SEQ = 0
		And SW7.W7_PO_NUM=SW2.W2_PO_NUM
		And SW7.%notDel%		
		And SWB.WB_FILIAL = %xfilial:SWB%	
		And SWB.WB_HAWB=SW6.W6_HAWB	
		And SWB.%notDel%	
		And SW6.W6_DT_ENCE = %Exp:cData%
		Group By W2_PO_NUM, W6_HAWB, W2_FORN,W2_ORIGEM,W2_MOEDA,W2_INCOTER,W2_COND_PA,W6_DT_ETD, W6_DT_EMB,W6_DT_ETA,W6_CHEG,W6_CONEVE1,WB_CA_DT, W6_PRVDESE
		Order By W2_PO_NUM
		//ORDER BY %Exp:cOrderBy%

	EndSQL
	oSecao1:EndQuery()
	oReport:SetMeter(0)
	oSecao1:Print()
Return

//GetLastQuery()[2] 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACPPR001  บAutor  ณMicrosiga           บ Data ณ  02/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PR001DESCRI(cQryAlias)
	Local aAreaAtu:=GetArea()
	Local aAreaSB1
	Local aAreaSW3
	Local nAscan
	Local cRetorno:=Space(Len(SB1->B1_DESC))


	If (nAscan:=Ascan(aDescri,{|a|a[1]==(cQryAlias)->W2_PO_NUM   }))      >0
		cRetorno:=aDescri[nAscan,2]
	Else
		aAreaSB1:=SB1->(GetArea())
		aAreaSW3:=SW3->(GetArea())
		SB1->(DbSetOrder(1))
		SW3->(DbSetOrder(1))
		SW3->(MsSeek(xFilial("SW3")+(cQryAlias)->W2_PO_NUM )) 
		Do While SW3->(!Eof()) .And. SW3->(W3_FILIAL+W3_PO_NUM)==xFilial("SW3")+(cQryAlias)->W2_PO_NUM .And. Empty(cRetorno)
			If SB1->(MsSeek(xFilial("SB1")+SW3->W3_COD_I))
				cRetorno:=SB1->B1_DESC
			EndIf
			SW3->(DbSkip())
		EndDo

		AADD(aDescri,{(cQryAlias)->W2_PO_NUM ,cRetorno})

		RestArea(aAreaSW3)
		RestArea(aAreaSB1)

	EndIf	


	RestArea(aAreaAtu)

Return cRetorno     