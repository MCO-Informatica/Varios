#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch" 
#INCLUDE "RPTDEF.CH"
#INCLUDE "SHELL.CH"
#include "totvs.ch"
#include "fwmvcdef.ch

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCPR006  บAutor  ณ                    บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime relatorio de materias primas faltantes para comple- บฑฑ
ฑฑบ          ณtar os empenhos.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP11 -                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RPCPR006() 

	Local oReport               

	Private _cPergu := 'RPCPR006'

	//If TRepInUse() //verifica se relatorios personalizaveis esta disponivel.

	AJUSTASX1(_cPergu)

	Pergunte(_cPergu, .F. )

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
	Local oSection2
	Local oSection3

	oReport := TReport():New("RPCPR006", "Necessidade de MP x OP", _cPergu, { |oReport| PRINTREPORT(oReport) }, "Este relatorio ira imprimir a relacao dos empenhos das ordens de producao conforme os parametros solicitados.")
	oReport:nfontbody:=8
	oReport:cfontbody:="Courier New"

	oSection := TRSection():New(oReport, OemToAnsi("O.P."), {"RPCPR006"})

	TRCell():New(oSection, "C2_NUM", "RPCPR006")
	TRCell():New(oSection, "C2_ITEM", "RPCPR006")
	TRCell():New(oSection, "C2_SEQUEN", "RPCPR006")
	TRCell():New(oSection, "B1_DESCC2", "RPCPR006", 'Descricao',, 30)
	TRCell():New(oSection, "C2_PRODUTO", "RPCPR006")
	TRCell():New(oSection, "C2_QUANT", "RPCPR006")

	oSection2 := TRSection():New(oSection, "Empenho da O.P.", {"RPCPR006"})

	TRCell():New(oSection2, "D4_COD", "RPCPR006")
	TRCell():New(oSection2, "B1_DESCD4", "RPCPR006", 'Descricao',, 30)
	TRCell():New(oSection2, "D4_QUANT", "RPCPR006")   
	TRCell():New(oSection2, "D4_LOCAL", "RPCPR006",'Armazem')   
	TRCell():New(oSection2, "D4_LOTECTL", "RPCPR006",'Lote')

	oSection3 := TRSection():New(oSection2, "Resumo das Materias Primas", {"RPCPR006"})

	TRCell():New(oSection3, "D4_COD", "RPCPR006")
	TRCell():New(oSection3, "B1_DESCD4", "RPCPR006"	, 'Descricao',, 30)
	TRCell():New(oSection3, "D4_QUANT", "RPCPR006"	,'Sal. Empenho'			,,20)   
	TRCell():New(oSection3, "D4_LOCAL", "RPCPR006"	,'Armazem'	,,10)   
	TRCell():New(oSection3, "D4_LOTECTL", "RPCPR006",'Lote')
    
	// Endereco
	TRCell():New(oSection3, "DC_LOCALIZ", "RPCPR006",'Endereco')

	If ValType(MV_PAR07)=='N' .And. MV_PAR07 == 1
		TRCell():New(oSection3, "MACRO2", "", 'Macro 2', '@E 99,999,999.9999', 15) 
	ElseIf ValType(MV_PAR07)=='N' .And. MV_PAR07 == 2
		TRCell():New(oSection3, "MICRO1", "", 'Micro', '@E 99,999,999.9999', 15)
		TRCell():New(oSection3, "MACRO1", "", 'Macro 1', '@E 99,999,999.9999', 15)
	Endif


	//TRCell():New(oSection3, "B1_QE", "RPCPR006", 'Qtd. a Transferir', '@E 99,999,999.99', 13)

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
ฑฑบUso       ณ AP11 - PROZYN                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PRINTREPORT(oReport)

	Local oSection  := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local oSection3 := oReport:Section(1):Section(1):Section(1)
	Local _cQry_1   := ''
	Local _cNum_1   := ''
	Local _cQry_2   := ''
	Local _nVl_Emb  := 0
	Local _nE       := 0
	Local _lOk      := .T.
	Local nMicro	:= 0
	Local nMacro1	:= 0
	Local nMacro2	:= 0
	Local cPicture	:= ""
	Local nQuantAux	:= 0                    
    /*
	_cQry_1 += "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, SB1SC2.B1_DESC B1_DESCC2, "+CRLF
	_cQry_1 += "C2_PRODUTO, C2_QUANT, SB1SD4.B1_QE, SD4.D4_QUANT, "+CRLF
	_cQry_1 += "SD4.D4_LOCAL, SD4.D4_LOTECTL, "+CRLF
	_cQry_1 += "SB1SD4.B1_DESC B1_DESCD4, SB1SD4.B1_TIPO, D4_COD, D4_QTDEORI "+CRLF
	_cQry_1 += "FROM " + RetSqlName('SD4') + " SD4 "+CRLF
	_cQry_1 += "INNER JOIN " + RetSqlName('SC2') + " SC2 ON "+CRLF
	_cQry_1 += "SC2.D_E_L_E_T_ <> '*' "+CRLF
	_cQry_1 += "AND SC2.C2_FILIAL = '" + xFilial('SC2') + "' "+CRLF
	_cQry_1 += "AND SC2.C2_NUM = SUBSTRING(SD4.D4_OP, 1, 6) "+CRLF
	_cQry_1 += "AND SC2.C2_ITEM = SUBSTRING(SD4.D4_OP, 7, 2) "+CRLF
	_cQry_1 += "AND SC2.C2_SEQUEN = SUBSTRING(SD4.D4_OP, 9, 3) "+CRLF
	_cQry_1 += "AND SC2.C2_LOCAL <> '10' "+CRLF
	_cQry_1 += "AND SC2.C2_PRODUTO >= '" + MV_PAR04 + "' "+CRLF
	_cQry_1 += "AND SC2.C2_PRODUTO <= '" + MV_PAR05 + "' "+CRLF
	_cQry_1 += "AND SC2.C2_DATPRI >= '" + DToS(MV_PAR01) + "' "+CRLF
	_cQry_1 += "AND SC2.C2_DATPRI <= '" + DToS(MV_PAR02) + "' "+CRLF
	_cQry_1 += "INNER JOIN " + RetSqlName('SB1') + " SB1SC2 ON "+CRLF
	_cQry_1 += "SB1SC2.D_E_L_E_T_ <> '*' "+CRLF
	_cQry_1 += "AND SB1SC2.B1_FILIAL = '" + xFilial('SB1') + "' "+CRLF
	_cQry_1 += "AND SB1SC2.B1_COD = SC2.C2_PRODUTO "+CRLF
	_cQry_1 += "INNER JOIN " + RetSqlName('SB1') + " SB1SD4 ON "+CRLF
	_cQry_1 += "SB1SD4.D_E_L_E_T_ <> '*' "+CRLF
	_cQry_1 += "AND SB1SD4.B1_FILIAL = '" + xFilial('SB1') + "' "+CRLF
	_cQry_1 += "AND SB1SD4.B1_COD = SD4.D4_COD "+CRLF
	_cQry_1 += "AND SB1SD4.B1_TIPO IN ('PA','MP','PI','SA','SS','EM') "+CRLF
	_cQry_1 += "WHERE SD4.D_E_L_E_T_ <> '*' "+CRLF
	_cQry_1 += "AND SD4.D4_FILIAL = '" + xFilial('SD4') + "' "+CRLF
	_cQry_1 += "AND SD4.D4_OP IN " + FormatIn(MV_PAR03,";") + " "+CRLF
	_cQry_1 += "AND SD4.D4_QUANT > 0 "+CRLF
    */

	//Ajustado para SDC - Zanni em 05/082020
    _cQry_1 += "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, SB1SC2.B1_DESC B1_DESCC2, "+CRLF
	_cQry_1 += "C2_PRODUTO, C2_QUANT, SB1SD4.B1_QE, SDC.DC_QUANT D4_QUANT, "+CRLF
	_cQry_1 += "SDC.DC_LOCAL D4_LOCAL, SDC.DC_LOTECTL D4_LOTECTL, "+CRLF
	_cQry_1 += "SB1SD4.B1_DESC B1_DESCD4, SB1SD4.B1_TIPO, DC_PRODUTO D4_COD, DC_QTDORIG D4_QTDEORI, DC_LOCALIZ"+CRLF
	_cQry_1 += "FROM " + RetSqlName('SDC') + " SDC "+CRLF
	_cQry_1 += "INNER JOIN " + RetSqlName('SC2') + " SC2 ON "+CRLF
	_cQry_1 += "SC2.D_E_L_E_T_ <> '*' "+CRLF
	_cQry_1 += "AND SC2.C2_FILIAL = '" + xFilial('SC2') + "' "+CRLF
	_cQry_1 += "AND SC2.C2_NUM = SUBSTRING(SDC.DC_OP, 1, 6) "+CRLF
	_cQry_1 += "AND SC2.C2_ITEM = SUBSTRING(SDC.DC_OP, 7, 2) "+CRLF
	_cQry_1 += "AND SC2.C2_SEQUEN = SUBSTRING(SDC.DC_OP, 9, 3) "+CRLF
	//_cQry_1 += "AND SC2.C2_LOCAL <> '10' "+CRLF // comentado linha por Bruno RIan - 02/06
	_cQry_1 += "AND SC2.C2_PRODUTO >= '" + MV_PAR04 + "' "+CRLF
	_cQry_1 += "AND SC2.C2_PRODUTO <= '" + MV_PAR05 + "' "+CRLF
	_cQry_1 += "AND SC2.C2_DATPRI >= '" + DToS(MV_PAR01) + "' "+CRLF
	_cQry_1 += "AND SC2.C2_DATPRI <= '" + DToS(MV_PAR02) + "' "+CRLF
	_cQry_1 += "INNER JOIN " + RetSqlName('SB1') + " SB1SC2 ON "+CRLF
	_cQry_1 += "SB1SC2.D_E_L_E_T_ <> '*' "+CRLF
	_cQry_1 += "AND SB1SC2.B1_FILIAL = '" + xFilial('SB1') + "' "+CRLF
	_cQry_1 += "AND SB1SC2.B1_COD = SC2.C2_PRODUTO "+CRLF
	_cQry_1 += "INNER JOIN " + RetSqlName('SB1') + " SB1SD4 ON "+CRLF
	_cQry_1 += "SB1SD4.D_E_L_E_T_ <> '*' "+CRLF
	_cQry_1 += "AND SB1SD4.B1_FILIAL = '" + xFilial('SB1') + "' "+CRLF
	_cQry_1 += "AND SB1SD4.B1_COD = SDC.DC_PRODUTO "+CRLF
	_cQry_1 += "AND SB1SD4.B1_TIPO IN ('PA','MP','PI','SA','SS','EM') "+CRLF
	_cQry_1 += "WHERE SDC.D_E_L_E_T_ <> '*' "+CRLF
	_cQry_1 += "AND SDC.DC_FILIAL = '" + xFilial('SDC') + "' "+CRLF
	_cQry_1 += "AND SDC.DC_OP IN " + FormatIn(MV_PAR03,";") + " "+CRLF
	_cQry_1 += "AND SDC.DC_QUANT > 0 "+CRLF
	TcQuery _cQry_1 New Alias 'RPCPR006'
    MemoWrite('RPCPR001.TXT',_cQry_1)
	RPCPR006->(DbGoTop())

	oReport:SetMeter(RPCPR006->(RecCount()))

	RPCPR006->(DbGoTop())

	If RPCPR006->(!EOF())

		While RPCPR006->(!EOF())

			If oReport:Cancel()

				Exit

			EndIf

			oSection:Init()

			//oSection:Cell("B1_DESC"):SetValue(SB1->B1_DESC)

			oSection:Cell("C2_NUM"):Show()
			oSection:Cell("C2_ITEM"):Show()
			oSection:Cell("C2_SEQUEN"):Show()
			oSection:Cell("B1_DESCC2"):Show()
			oSection:Cell("C2_PRODUTO"):Show()
			oSection:Cell("C2_QUANT"):Show()

			oSection:PrintLine()

			_cNum_1 := RPCPR006->C2_NUM + RPCPR006->C2_ITEM + RPCPR006->C2_SEQUEN

			oSection2:Init()

			//oSection2:Cell("B1_QE"):SetValue(E_10_001->B1_QE)

			oSection2:Cell("D4_COD"):Disable()
			oSection2:Cell("B1_DESCD4"):Disable()
			oSection2:Cell("D4_QUANT"):Disable()
			oSection2:Cell("D4_LOCAL"):Disable()
			oSection2:Cell("D4_LOTECTL"):Disable()

			//oSection2:Cell("B1_QE"):Disable() // Desabilitado por Ciro em 15/05/2014.

			While RPCPR006->(!EOF()) .And. _cNum_1 == RPCPR006->C2_NUM + RPCPR006->C2_ITEM + RPCPR006->C2_SEQUEN

				oSection2:PrintLine()

				RPCPR006->(DbSkip())

			EndDo

			oSection2:Finish()

			oSection:Finish()

		EndDo

		oReport:SkipLine()
		oReport:IncMeter()

	EndIf

	RPCPR006->(DbCloseArea())

	If MV_PAR06 == 1

		_cQry_2 := "SELECT D4_COD, B1_DESCD4, SUM(D4_QUANT) D4_QUANT, D4_LOCAL, D4_LOTECTL, SUM(D4_QTDEORI) D4_QTDEORI, B1_QE, B1_TIPO, DC_LOCALIZ "
		_cQry_2 += "FROM ( "
		_cQry_2 += _cQry_1
		_cQry_2 += Space(1)
		_cQry_2 += " ) AS EMPENHOS "
		_cQry_2 += "GROUP BY D4_COD, B1_DESCD4, D4_LOCAL, D4_LOTECTL, B1_QE, B1_TIPO, DC_LOCALIZ"

		TcQuery _cQry_2 New Alias 'RPCPR006'

		RPCPR006->(DbGoTop())

		oReport:SetMeter(RPCPR006->(RecCount()))

		RPCPR006->(DbGoTop())

		If RPCPR006->(!EOF())

			oReport:SkipLine()

			oReport:PrintText('Resumo das materias primas:')

			oReport:SkipLine()

			While RPCPR006->(!EOF())

				If oReport:Cancel()

					Exit

				EndIf

				nQuantAux	:= 0
				nMicro		:= 0 
				nMacro1		:= 0
				nMacro2		:= 0

				CalcMicMac(RPCPR006->D4_COD, RPCPR006->D4_LOTECTL, _cQry_1, @nMicro, @nMacro1, @nMacro2, RPCPR006->DC_LOCALIZ)

				oSection3:Init()

				_nVl_Emb := 0
				_nE      := 0
				_lOk     := .T.

				If RPCPR006->B1_QE > 0

					While _lOk

						_nE++

						If (_nE * RPCPR006->B1_QE) > RPCPR006->D4_QTDEORI

							_nVl_Emb := _nE * RPCPR006->B1_QE

							_lOk := .F.

						EndIf

					EndDo

				EndIf

				//			oSection3:Cell("B1_QE"):SetValue(_nVl_Emb)

				oSection3:Cell("D4_COD"):Show()
				oSection3:Cell("B1_DESCD4"):Show()
				oSection3:Cell("D4_QUANT"):Show()
				
				oSection3:Cell("D4_LOCAL"):SetAlign("CENTER")
				oSection3:Cell("D4_LOCAL"):Show()
				oSection3:Cell("D4_LOTECTL"):Show()

                oSection3:Cell('DC_LOCALIZ'):Show()
				/*If RPCPR006->D4_QUANT > 5
				cPicture := "@E 999,999.999"
				Else*/
				cPicture := "@E 999,999.9999"
				//EndIf

				nMicro	:= NoRound(nMicro,4)
				nMacro1	:= NoRound(nMacro1,4)
				nMacro2	:= NoRound(nMacro2,4)

				If ValType(MV_PAR07)=='N' .And. MV_PAR07 == 1
					nQuantAux	:= nMacro2

					oSection3:Cell("MACRO2"):Show()
					oSection3:Cell("MACRO2"):SetPicture(cPicture)
					oSection3:Cell("MACRO2"):SetValue(nMacro2)

					oSection3:Cell("D4_QUANT"):SetValue(nQuantAux)

				ElseIf ValType(MV_PAR07)=='N' .And. MV_PAR07 == 2
					nQuantAux	:= nMicro+nMacro1

					oSection3:Cell("MICRO1"):Show() 
					oSection3:Cell("MACRO1"):Show()
					oSection3:Cell("MICRO1"):SetPicture(cPicture)
					oSection3:Cell("MACRO1"):SetPicture(cPicture)

					oSection3:Cell("MICRO1"):SetValue(nMicro)
					oSection3:Cell("MACRO1"):SetValue(nMacro1)

					oSection3:Cell("D4_QUANT"):SetValue(nQuantAux)
				Endif
				//oSection3:Cell("B1_QE"):Show()

				oSection3:PrintLine()

				RPCPR006->(DbSkip())

			EndDo

			oSection3:Finish()

			oReport:SkipLine()
			oReport:IncMeter()

		EndIf

		RPCPR006->(DbCloseArea())

	EndIf

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
ฑฑบUso       ณ AP11 - prozyn                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AJUSTASX1(_cPergu)

	xPutSx1(_cPergu,"01","Dt. Inicio De?","Dt. Inicio De?","Dt. Inicio De?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","")
	xPutSx1(_cPergu,"02","Dt. Inicio Ate?","Dt. Inicio Ate?","Dt. Inicio Ate?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","")
	xPutSx1(_cPergu,"03","O.P. De?","O.P. De?","Range O.Ps?","mv_ch3","C",99,0,0,"C","","SC2","","","mv_par03","","","","","","","","","","")
	//xPutSx1(_cPergu,"04","O.P. Ate?","O.P. Ate?","O.P. Ate?","mv_ch4","C",13,0,0,"G","","SC2","","","mv_par04","","","","","","","","","","")
	xPutSx1(_cPergu,"04","Produto De?","Produto De?","Produto De?","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04","","","","","","","","","","")
	xPutSx1(_cPergu,"05","Produto Ate?","Produto Ate?","Produto Ate?","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05","","","","","","","","","","")
	xPutSx1(_cPergu,"06","Imprime Resumo?","Imprime Resumo?","Imprime Resumo?","mv_ch6","N",1,0,0,"C","","","","","mv_par06","Sim","Sim","Sim","","Nao","Nao","Nao","","","")
	xPutSx1(_cPergu,"07","Modo Impressใo?","Modo Impressใo?","Modo Impressใo?","mv_ch7","N",1,0,0,"N","","","","","mv_par07",;
	"Macro 2","Macro 2","Macro 2","","Micro e Macro 1","Micro e Macro 1","Micro e Macro 1","Atual","Atual","Atual")


Return

User Function DlgAtu()
	cValor := U_DlgAtuOP()
return .T.

user function DlgAtuOP()
	
	Local u	:= 0
	
	Private  oDlg2  
	Private  oList4
	Private  aClientes := {}
	Private  oOkm  := LoadBitMap(GetResources(),"LBOK")
	Private  oNom  := LoadBitMap(GetResources(),"NADA")
	Private  aLabel:= {" ","Ordem Produ็ใo","Produto"}             
	Private  cOps  := ""  

	DEFINE MSDIALOG oDlg2 TITLE "Filtros OP" FROM 000, 000  TO 300, 400 COLORS 0, 16777215 PIXEL

	@ 001,180 BUTTON oButton1 PROMPT "Salvar"  SIZE 020, 010 OF oDlg2 ACTION oDlg2:end() PIXEL
	@ 015,002 LISTBOX oList4 VAR cList4 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
	aLabel[1],;
	aLabel[2],;
	aLabel[3];
	SIZE 200,150   PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio 


	cQry := " SELECT * FROM "+RetSqlName("SC2")+CRLF 
	cQry += " WHERE C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF 
	cQry += " AND C2_QUJE = 0 "+CRLF
	cQry += " AND C2_DATRF = '' "+CRLF
	cQry += " AND C2_DATPRI >= '" + DToS(MV_PAR01) + "' "+CRLF
	cQry += " AND C2_DATPRI <= '" + DToS(MV_PAR02) + "' "+CRLF   
	cQry += " AND D_E_L_E_T_ = ' ' "+CRLF

	if Select("TMJ") > 0
		TMJ->(DbCloseArea())
	EndIf
	TcQuery cQry New Alias 'TMJ'

	While TMJ->(!EOF())
		Aadd(aClientes,{.F.,;
		TMJ->C2_NUM+TMJ->C2_ITEM+TMJ->C2_SEQUEN,;
		TMJ->C2_PRODUTO})		
		TMJ->(DBSKIP())
	EndDo	

	oList4:SetArray(aClientes)
	oList4:cToolTip		:= "Duplo clique para marcar/desmarcar o produto"
	oList4:bLine	:= {|| {	If(aClientes[oList4:nAt,1], oOkm, oNom),; 	
	aClientes[oList4:nAt,2],;
	aClientes[oList4:nAt,3]}}
	oList4:blDblClick 	:= {|| aClientes[oList4:nAt,1] := !aClientes[oList4:nAt,1], oList4:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
	oList4:bHeaderClick := {|| fSelectAll(aClientes,oList4)}
	oList4:Refresh()  


	ACTIVATE MSDIALOG oDlg2 CENTERED 
	For u := 1 to len(aClientes)

		If aClientes[u,1]
			cOps +=  alltrim(aClientes[u,2]) + ';' 
		endif 

	next
	MV_PAR03 := cOps
	
Return cOps      

Static Function fSelectAll(aTitulos,oList1)
	Local i := 0

	For i:=1 to Len(aTitulos)
		aTitulos[i,1] := !aTitulos[i,1]
	Next i
	oList1:Refresh()
Return



Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcMicMac  บAutor  ณMicrosiga         บ Data ณ  10/04/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do micro e macro					                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                       	              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcMicMac(cCodProd, cLote, cQuery1, nMicro, nMacro1, nMacro2, _cEndereco)

	Local aArea 	:= GetArea()
	Local cArqTmp	:= GetNextAlias()
	Local cQuery	:= ""

	Default nMicro	:= 0 
	Default nMacro1	:= 0 
	Default nMacro2	:= 0
	Default cLote	:= ""

	cQuery := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, D4_COD, D4_LOTECTL, B1_DESCD4, SUM(D4_QUANT) D4_QUANT, D4_LOCAL, D4_LOTECTL, SUM(D4_QTDEORI) D4_QTDEORI, B1_QE, B1_TIPO, DC_LOCALIZ "
	cQuery += "FROM ( "
	cQuery += cQuery1
	cQuery += Space(1)
	cQuery += " ) AS EMPENHOS "
	cQuery += " WHERE D4_COD = '"+cCodProd+"' "
	cQuery += " AND D4_LOTECTL = '"+cLote+"'  AND DC_LOCALIZ = '"+_cEndereco+"'"
	cQuery += " GROUP BY C2_NUM, C2_ITEM, C2_SEQUEN, D4_COD, D4_LOTECTL, B1_DESCD4, D4_LOCAL, D4_LOTECTL, B1_QE, B1_TIPO, DC_LOCALIZ"
	cQuery += " ORDER BY D4_COD "

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())
		If UPPER(Alltrim((cArqTmp)->B1_TIPO)) $ "MP|PI"
			If ValType(MV_PAR07)=='N' .And. MV_PAR07 == 1
				If (cArqTmp)->B1_QE == Int((cArqTmp)->D4_QTDEORI)
					nMicro	:= (cArqTmp)->D4_QTDEORI-Int((cArqTmp)->D4_QTDEORI)
					nMacro1	:= 0
					nMacro2	+= int((cArqTmp)->D4_QTDEORI) - nMacro1 
				ElseIf (cArqTmp)->B1_QE < (cArqTmp)->D4_QTDEORI 
					nMicro	:= (cArqTmp)->D4_QTDEORI-Int((cArqTmp)->D4_QTDEORI)
					nMacro1	:= Int((cArqTmp)->D4_QTDEORI) -  (Int(Int((cArqTmp)->D4_QTDEORI)/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE)
					nMacro2	+= int((cArqTmp)->D4_QTDEORI) - nMacro1 
				Else
					nMicro	:= (cArqTmp)->D4_QTDEORI-Int((cArqTmp)->D4_QTDEORI)
					nMacro1	:= Int((cArqTmp)->D4_QTDEORI)
					nMacro2	+= 0
				EndIf

			Else
				If (cArqTmp)->B1_QE == Int((cArqTmp)->D4_QTDEORI)
					nMicro	+= (cArqTmp)->D4_QTDEORI-Int((cArqTmp)->D4_QTDEORI)
					nMacro1	+= 0
				ElseIf (cArqTmp)->B1_QE < (cArqTmp)->D4_QTDEORI 
					nMicro	+= (cArqTmp)->D4_QTDEORI-Int((cArqTmp)->D4_QTDEORI)
					nMacro1	+= Int((cArqTmp)->D4_QTDEORI) -  (Int(Int((cArqTmp)->D4_QTDEORI)/(cArqTmp)->B1_QE)*(cArqTmp)->B1_QE)
				Else
					nMicro	+= (cArqTmp)->D4_QTDEORI-Int((cArqTmp)->D4_QTDEORI)
					nMacro1	+= Int((cArqTmp)->D4_QTDEORI)
				EndIf

			EndIf
		ElseIf UPPER(Alltrim((cArqTmp)->B1_TIPO)) == "EM" .And. ValType(MV_PAR07)=='N' .And. MV_PAR07 == 1
			nMacro2	+= int((cArqTmp)->D4_QTDEORI)
		Else
			nMicro	:= 0
			nMacro1	:= 0
			nMacro2	:= 0
		EndIf


		(cArqTmp)->(DbSkip())
	EndDo 

	If Select(cArqTmp)>0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return
