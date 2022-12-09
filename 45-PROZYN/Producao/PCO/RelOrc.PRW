#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*/{RELORC()} Relatorio da planilha orcamentaria
    (Imprimir por usuario o relatorio da planilha orcamentaria)
    @type  Function
    @Ricardo Massao Kodama
    @since 23/11/2021
/*/


Function U_RELORC()

    Local oReport

    Private _cPergun := 'RELORC'

    AJUSTASX1(_cPergun)

	Pergunte(_cPergun, .F. )

	oReport := REPORTDEF()

	oReport:PRINTDIALOG()

	    
Return 


/*/{REPORTDEF} REPORTDEF
    (Monta as colunas do relatorio.)
    @type  Static Function
    @Ricardo Massao Kodama
    @since 23/11/2021

/*/

Static Function REPORTDEF ()

	Local oReport                                                                             	
	Local oSection
	Local oSection2
	//Local oSection3

	oReport := TReport():New("RELORC", "Relatorio de Planilha Orçamentária", _cPergun, { |oReport| PRINTREPORT(oReport) }, "Imprimir a Planilha Orçamentária conforme os parametros solicitados.")
	oReport:nfontbody:=8
	oReport:cfontbody:="Courier New"

	oSection := TRSection():New(oReport, OemToAnsi("P.O"), {"RELORC"})

	TRCell():New(oSection, "AK2_ORCAME", "RELORC")
	TRCell():New(oSection, "AK2_VERSAO", "RELORC")
	/*/
	TRCell():New(oSection, "AKX_USER", "RELORC")
	TRCell():New(oSection, "AKX_NOME", "RELORC")
    TRCell():New(oSection, "AK2_MOEDA", "RELORC")
	/*/
  

	oSection2 := TRSection():New(oSection, "Valores Orçados", {"RELORC"})

	TRCell():New(oSection2, "AK2_CO", "RELORC", 'C.O.')
	TRCell():New(oSection2, "AK5_DESCRI", "RELORC", 'Conta Orcamentaria')
	TRCell():New(oSection2, "AK2_CC", "RELORC",'C.C.')   
	TRCell():New(oSection2, "CTT_DESC01", "RELORC",'Centro de custo')   
	TRCell():New(oSection2, "AK2_VALOR", "RELORC",'Valor')
	TRCell():New(oSection2, 'AK2_PERIOD', "RELORC", 'Periodo',PesqPict("AK2","AK2_PERIOD")	,10) 
    TRCell():New(oSection2, "AK2_DESCRI", "RELORC", 'Descricão')
	
	/*/
	oSection3 := TRSection():New(oSection2, "Resumo", {"RELORC"})

	TRCell():New(oSection3, "AK2_CO", "RELORC", 'Conta Orcamentaria')
	TRCell():New(oSection3, "AK5_DESCRI", "RELORC", 'Descricao')
	TRCell():New(oSection3, "AK2_CC", "RELORC")   
	TRCell():New(oSection3, "CTT_DESC01", "RELORC",'Centro de custo') 
	TRCell():New(oSection3, "VALOR", "RELORC",'Valor')
	/*/
    
Return oReport


/*/ PRINTREPORT(oReport)
    (Realiza a impressao do relatorio)
    @type  Static Function
    @author user
    @since 23/11/2021

/*/


Static Function PRINTREPORT(oReport)
    
    Local oSection  := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	//Local oSection3 := oReport:Section(1):Section(1):Section(1)
	Local _cQry_1   := ''
	Local _cQry_2   := ''

 

	_cQry_1 += "SELECT  AK2_ORCAME, AK2_VERSAO, AK2_CO, AK5_DESCRI, AK2_CC, CTT_DESC01, dbo.fConverteData(AK2_PERIOD) AK2_PERIOD, AK2_CLASSE, AK2_VALOR, AK2_DESCRI, AKX_USER, AK2_XUSUAR "
	_cQry_1 += "FROM " + RetSqlName('AK2') + " K2 "
	_cQry_1 += "INNER JOIN " + RetSqlName('AK5') + " K5 "
	_cQry_1 += "ON K5.D_E_L_E_T_ = '' "
	_cQry_1 += "AND K5.AK5_FILIAL = '" + xFilial('AK5') + "' "
	_cQry_1 += "AND K5.AK5_CODIGO	= K2.AK2_CO "
	_cQry_1 += "INNER JOIN " + RetSqlName('CTT') + " TT "
	_cQry_1 += "ON TT.D_E_L_E_T_ = '' " ///_cQry_1 += "AND TT.CTT_FILIAL = ' " + xFilial('CTT') + "' "
	_cQry_1 += "AND TT.CTT_CUSTO = K2.AK2_CC "
	_cQry_1 += "INNER JOIN " + RetSqlName('AKX') + " KX "
	_cQry_1 += "ON KX.D_E_L_E_T_ <> '*' "
	_cQry_1 += "AND KX.AKX_FILIAL = '" + xFilial('AKX') + "' "
	_cQry_1 += "AND K2.AK2_CC BETWEEN KX.AKX_CC_INI AND KX.AKX_CC_FIN "
	_cQry_1 += "WHERE K2.D_E_L_E_T_ = '' "
	_cQry_1 += "AND K2.AK2_FILIAL = '" + xFilial('AK2') + "' "
    _cQry_1 += "AND K2.AK2_ORCAME = '" + MV_PAR01 + "' " 
    _cQry_1 += "AND K2.AK2_VERSAO = '" + MV_PAR02 + "' "
    _cQry_1 += "AND K2.AK2_CO >= '"    + MV_PAR03 + "' "
    _cQry_1 += "AND K2.AK2_CO <= '"    + MV_PAR04 + "' "
	_cQry_1 += "AND K2.AK2_PERIOD >= '" + DTOS(MV_PAR05) + "' "
	_cQry_1 += "AND K2.AK2_PERIOD <= '" + DTOS(MV_PAR06) + "' "
	_cQry_1 += "AND K2.AK2_VALOR <> '0'"
	_cQry_1 += "AND KX.AKX_USER = '" + RetCodUsr() + "' "
	
 	_cQryOrder := " ORDER BY AK2_CO, AK2_CC, AK2_PERIOD " 

	TcQuery _cQry_1 + _cQryOrder New Alias 'RELORC' 
	MemoWrite('RELORC_01.txt',_cQry_1)
	
	RELORC->(DbGoTop())

	oReport:SetMeter(RELORC->(RecCount()))

	If RELORC->(!EOF())

		While RELORC->(!EOF())

			If oReport:Cancel()

				Exit

			EndIf

			oSection:Init()

			oSection:Cell("AK2_ORCAME"):Show()
			oSection:Cell("AK2_VERSAO"):Show()
			/*/
			oSection:Cell("AKX_USER"):Show()
			oSection:Cell("AKX_NOME"):Show()
			oSection:Cell("AK2_MOEDA"):Show()
			/*/
			oSection:PrintLine()

			
			oSection2:Init()

			oSection2:Cell("AK2_CO"):Show()
			oSection2:Cell("AK5_DESCRI"):Show()
			oSection2:Cell("AK2_CC"):Show()
			oSection2:Cell("CTT_DESC01"):Show()
			oSection2:Cell("AK2_VALOR"):Show()
			oSection2:Cell("AK2_PERIOD"):Show()
			oSection2:Cell("AK2_DESCRI"):Show() 
		
			While RELORC->(!EOF()) 

				oSection2:PrintLine()

				RELORC->(DbSkip())

			EndDo


			oSection2:Finish()

			oSection:Finish()

		EndDo

		oReport:SkipLine()
		oReport:IncMeter()

	EndIf



	RELORC->(DbCloseArea())


		_cQry_2 := "SELECT AK2_CO, AK5_DESCRI, AK2_CC, CTT_DESC01, SUM(AK2_VALOR) VALOR "
		_cQry_2 += "FROM ( "
		_cQry_2 += _cQry_1
		_cQry_2 += Space(1)
		_cQry_2 += " ) AS TOTAIS "
		_cQry_2 += "GROUP BY AK2_CO, AK5_DESCRI, AK2_CC, CTT_DESC01 "


		TcQuery _cQry_2 New Alias 'RELORC'

		MemoWrite('RELORC_02.txt',_cQry_2)

		RELORC->(DbGoTop())

		oReport:SetMeter(RELORC->(RecCount()))

		RELORC->(DbGoTop())

		/*/

		If RELORC->(!EOF())

			oReport:SkipLine()

			oReport:PrintText('Totais:')

			oReport:SkipLine()

		While RELORC->(!EOF())

				If oReport:Cancel()

					Exit

				EndIf

				
				oSection3:Init()

				oSection3:Cell("AK2_CO"):Show()
				oSection3:Cell("AK5_DESCRI"):Show()
				oSection3:Cell("AK2_CC"):Show()
				oSection3:Cell("CTT_DESC01"):Show()
				oSection3:Cell("VALOR"):Show()

				oSection3:PrintLine()
				
				
				RELORC->(DbSkip())

			EndDo

			oSection3:Finish()

			oReport:SkipLine()
			oReport:IncMeter()

		EndIf
		/*/
		
		RELORC->(DbCloseArea())


	
Return 

/*/ AJUSTASX1
    (Cria as perguntas para uso do relatorio)
    @type  Static Function
    @Ricardo Massao Kodama
    @since 23/11/2021
/*/


Static Function AJUSTASX1(_cPergun)

    PutSx1(_cPergun,"01","Planilha?","Planilha?","Planilha?","mv_ch1","C",15,0,0,"G","","AK1","","","mv_par01","","","","","","","","","","")
	PutSx1(_cPergun,"02","Versão?","Versão?","Versão?","mv_ch2","C",4,0,0,"G","","AKE1","","","mv_par02","","","","","","","","","","")
	PutSx1(_cPergun,"03","C.O. de ?","C.O. de ?","C.O. de ?","mv_ch3","C",15,0,0,"G","","AK2","","","mv_par03","","","","","","","","","","")
	PutSx1(_cPergun,"04","C.O. ate ? ","C.O. ate ? ","C.O. ate ? ","mv_ch4","C",15,0,0,"G","","AK2","","","mv_par04","","","","","","","","","","")
	PutSx1(_cPergun,"05","Periodo de ?","Periodo de ?","Periodo de ?","mv_ch5","D",8,0,0,"G","","","","","mv_par05","","","","","","","","","","")
	PutSx1(_cPergun,"06","Periodo ate ?","Periodo ate ?","Periodo ate ?","mv_ch6","D",8,0,0,"G","","","","","mv_par06","","","","","","","","","","")

    
Return 

