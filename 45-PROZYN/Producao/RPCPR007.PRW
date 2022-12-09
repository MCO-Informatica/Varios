#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPR007  บAutor  ณ                    บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime transferencia de sobras para lotes produzidos  com  บฑฑ
ฑฑบ          ณquantidade deduzida                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP11 -                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RPCPR007()

Local oReport

Private _cPerg := 'RPCPR007'

//If TRepInUse() //verifica se relatorios personalizaveis esta disponivel.
	
	AJUSTASX1(_cPerg)
	
	Pergunte(_cPerg, .F. )
	
	oReport := REPORTDEF()
	
	oReport:PRINTDIALOG()
	
//EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREPORTDEF บAutor  ณCiro Pedreira       บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta as colunas do relatorio.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP11 - prozyn                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function REPORTDEF()

Local oReport
Local oSection
//Local oSection2
//Local oSection3

oReport := TReport():New("RPCPR007", "Transfer๊ncia de Sobras PA ",_cPerg, { |oReport| PRINTREPORT(oReport) }, "Este relatorio ira imprimir a relacao das transferencias de sobras para PAs.")
oReport:nfontbody:=8
oReport:cfontbody:="Courier New"

oSection := TRSection():New(oReport, OemToAnsi("Origem e Destino"), {"RPCPR007"})

TRCell():New(oSection, "Transferencia", "RPCPR007")
TRCell():New(oSection, "D3_COD", "RPCPR007")
TRCell():New(oSection, "B1_DESC", "RPCPR007", 'Descricao',, 30)
TRCell():New(oSection, "D3_QUANT", "RPCPR007")
TRCell():New(oSection, "D3_LOTECTL", "RPCPR007")

//oSection2 := TRSection():New(oSection, "Destino", {"RPCPR007"}) 

//TRCell():New(oSection2, "ORDEM", "RPCPR007")
//TRCell():New(oSection2, "D3_COD", "RPCPR007")
//TRCell():New(oSection2, "B1_DESC", "RPCPR007", 'Descricao',, 30)
//TRCell():New(oSection2, "D3_QUANT", "RPCPR007")
//TRCell():New(oSection2, "D3_LOTECTL", "RPCPR007")


//oSection3 := TRSection():New(oSection2, "Resumo das Materias Primas", {"E_10_001"})

//TRCell():New(oSection3, "D4_COD", "E_10_001")
//TRCell():New(oSection3, "B1_DESCD4", "E_10_001", 'Descricao',, 30)
//TRCell():New(oSection3, "D4_QUANT", "E_10_001")   
//TRCell():New(oSection3, "D4_LOCAL", "E_10_001",'Armazem')   
//TRCell():New(oSection3, "D4_LOTECTL", "E_10_001",'Lote')
//TRCell():New(oSection3, "B1_QE", "E_10_001", 'Qtd. a Transferir', '@E 99,999,999.99', 13)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRINTREPORTบAutor  ณMicrosiga           บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a impressao do relatorio.                            บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP11 - ELANTAS                                              บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PRINTREPORT(oReport)

Local oSection  := oReport:Section(1)
//Local oSection2 := oReport:Section(1):Section(1)
//Local oSection3 := oReport:Section(1):Section(1):Section(1)
Local _cQry_1   := ''
//Local _cNum_1   := ''
//Local _cQry_2   := ''
//Local _nVl_Emb  := 0
//Local _nE       := 0
//Local _lOk      := .T.

_cQry_1 += "SELECT 'ORIGEM' AS Transferencia, D3_EMISSAO , D3_COD , B1_DESC , D3_QUANT , D3_LOTECTL FROM " + RetSqlName('SD3') + " SD3 "
_cQry_1 += "INNER JOIN " + RetSqlName('SB1') + " SB1  ON "
_cQry_1 += "SB1.B1_COD = SD3.D3_COD " 
_cQry_1 += "WHERE "
_cQry_1 += "SD3.D3_TM IN ('999') AND "
_cQry_1 += "SD3.D3_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' AND "
_cQry_1 += "SD3.D3_COD = '" + MV_PAR03 + "' "
_cQry_1 += "AND SD3.D3_LOTECTL = '" + MV_PAR04 + "' "           
_cQry_1 += "UNION ALL "
_cQry_1 += "SELECT 'DESTINO' AS Transferencia, D3_EMISSAO, D3_COD, B1_DESC, D3_QUANT, D3_LOTECTL  FROM " + RetSqlName('SD3') + " SD3 "
_cQry_1 += "INNER JOIN " + RetSqlName('SB1') + " SB1  ON "
_cQry_1 += "SB1.B1_COD = SD3.D3_COD " 
_cQry_1 += "WHERE "
_cQry_1 += "SD3.D3_TM IN ('499') AND "
_cQry_1 += "SD3.D3_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' AND "
_cQry_1 += "SD3.D3_COD = '" + MV_PAR03 + "' "
         
TcQuery _cQry_1 New Alias "RPCPR007"

RPCPR007->(DbGoTop())

oReport:SetMeter(RPCPR007->(RecCount()))

RPCPR007->(DbGoTop())
   
If !RPCPR007->(EOF())
	
	While RPCPR007->(!EOF())
		
		If oReport:Cancel()
			
			Exit
			
		EndIf
		
		oSection:Init()

		oSection:Cell("Transferencia"):Show()
		oSection:Cell("D3_COD"):Show()
		oSection:Cell("B1_DESC"):Show()
		oSection:Cell("D3_QUANT"):Show()
		oSection:Cell("D3_LOTECTL"):Show()

		
		oSection:PrintLine()
		
		oSection:Finish()
		RPCPR007->(DbSkip())
	EndDo
	
 //	oReport:SkipLine()
 //	oReport:IncMeter()
	
EndIf

RPCPR007->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1 บAutor  ณCiro Pedreira       บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria as perguntas para uso do relatorio.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP11 - ELANTAS                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AJUSTASX1(_cPerg)

PutSx1(_cPerg,"01","Dt.Transf De?","Dt.Transf De?","Dt.Transf De?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","")
PutSx1(_cPerg,"02","Dt.Transf Ate?","Dt.Transf Ate?","Dt.Transf Ate?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","")
PutSx1(_cPerg,"03","Produto:?","Produto?","Produto","mv_ch3","C",06,0,0,"G","","SB1","","","mv_par03","","","","","","","","","","")
PutSx1(_cPerg,"04","Lote Origem?","Lote Origem?","Lote Origem?","mv_ch4","C",15,0,0,"G","","","","","mv_par04","","","","","","","","","","")

Return
