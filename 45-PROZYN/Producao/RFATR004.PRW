#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR004    º Autor ³ Derik Santos     º Data ³ 29/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Acompanhamento de Vendas					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RFATR004(cNomeArq, cCodVend, lJob)

	Local cDataini	:= FirstDate(dDataBase)
	Local cDatafim	:= LastDate(dDataBase) 	
	Local aPergs   := {}
	Local lIsVend  := .F.
	

	Private _cRotina	:= "RFATR00J"
	Private oPrn
	Private cPerg		:= _cRotina
	Private oBrush		:= TBrush():New(,CLR_HGRAY)
	Private oFont01		:= TFont():New( "Arial",,20,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
	Private oFont02		:= TFont():New( "Arial",,12,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
	Private oFont03		:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
	Private oFont04		:= TFont():New( "Arial",,10,,.F.,,,,.F.,.F.) //Arial 09 - Normal
	Private oFont05		:= TFont():New( "Arial",,14,,.F.,,,,.F.,.F.) //Arial 09 - Normal
	Private _nLin		:= 080 //Linha inicial para impressão
	Private _nLinFin	:= 570 //Linha final para impressão
	Private _nEspPad	:= 020 //Espaçamento padrão entre linhas
	Private _cEnter		:= CHR(13) + CHR(10)
	Private aRelImp		:= MaFisRelImp("MT100",{"SF2","SD2"})
	Private _nMaxDesc	:= 32

	Default cNomeArq	:= ""
	Default cCodVend	:= ""
	Default lJob		:= .F.

	If lJob .Or. IsInCallStack("U_RFATJ001") .Or. IsInCallStack("U_RFATJ002") 	// Executa Rotina via Job     
		Pergunte(cPerg,.F.)
		MV_PAR01 := cDataini
		MV_PAR02 := cDatafim
		MV_PAR03 := ""
		MV_PAR04 := "zzzzzz"
		MV_PAR05 := ""
		MV_PAR06 := "zzzzzz"
		MV_PAR07 := ""
		MV_PAR08 := "zzzzzz"
		MV_PAR11 := ""
		MV_PAR12 := "zzzz"
		MV_PAR14 := 0
		MV_PAR15 := 4
		MV_PAR16 := 1 //Alterado em 19/01/2022 por solicitação do Robson
		MV_PAR17 := 2

		If isincallstack("U_RFATR006") .Or. IsInCallStack("U_RFATJ002")
			MV_PAR09 := ""
			MV_PAR10 := "ZZZZZZ"
		ElseIf IsInCallStack("U_RFATJ001")
			MV_PAR09 := cCodVend
			MV_PAR10 := cCodVend		
		EndIf

		MV_PAR13 := 1   
	Else
		aAdd(aPergs, {1, "Data De",  cDataini,  "",             ".T.",        "",    ".T.", 80,  .F.})
		aAdd(aPergs, {1, "Data Até", cDatafim,  "",             ".T.",        "",    ".T.", 80,  .T.})
		aAdd(aPergs, {1, "Cliente De",  space(6),  "",             ".T.",        "SA1DEN", ".T.", 80,  .F.})
		aAdd(aPergs, {1, "Cliente Até", "ZZZZZZ",  "",             ".T.",        "SA1DEN", ".T.", 80,  .T.})
		aAdd(aPergs, {1, "Produto De",  space(15),  "",             ".T.",        "SB1", ".T.", 80,  .F.})
		aAdd(aPergs, {1, "Produto Até", "ZZZZZZZZZZZZZZZ",  "",             ".T.",        "SB1", ".T.", 80,  .T.})
		aAdd(aPergs, {1, "Segmento De",  space(6),  "",             ".T.",        "AOV", ".T.", 80,  .F.})
		aAdd(aPergs, {1, "Segmento Até", "ZZZZZZ",  "",             ".T.",        "AOV", ".T.", 80,  .T.})
		
		cUsuario := RetCodUsr()
		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
			lIsVend := .T.
			aAdd(aPergs,{9,"Vendedor: "+SA3->A3_COD,150,5,.T.})
			aAdd(aPergs,{9,"Vendedor: "+SA3->A3_NOME,150,5,.T.})
		Else
			aAdd(aPergs, {1, "Vendedor De",  space(6),  "",             ".T.",        "SA3", ".T.", 80,  .F.})
			aAdd(aPergs, {1, "Vendedor Até", "ZZZZZZ",  "",             ".T.",        "SA3", ".T.", 80,  .T.})
		EndIf

		aAdd(aPergs, {1, "Unid Negocio De",  space(4),  "",             ".T.",        "SBM", ".T.", 80,  .F.})
		aAdd(aPergs, {1, "Unid Negocio Até", "ZZZZ",  "",             ".T.",        "SBM", ".T.", 80,  .T.})
		aAdd(aPergs, {2, "Modelo Impressão",           	1, {"1-PDF",              "2- Excel"},     122, ".T.", .F.})
		aAdd(aPergs, {1, "Valor de Corte",       		0,   "@E 99,999.99", "Positivo()", "",    ".T.", 80,  .F.})
		aAdd(aPergs, {2, "Ordenar Por",               	1, {"Clientes","Produtos","Divergencia","Padrao"},     122, ".T.", .F.})
		aAdd(aPergs, {2, "Moeda",               		1, {"1-Real","2-Dólar"},     122, ".T.", .F.})
		aAdd(aPergs, {2, "Impostos",               		1, {"1-Net","2-Bruto"},     122, ".T.", .F.})
		
		If !ParamBox(aPergs, "Informe os parâmetros")
			return
		EndIf

	Endif  

	If lIsVend
		MV_PAR09 := SA3->A3_COD
		MV_PAR10 := SA3->A3_COD
	EndIf


	//Chamada da função para geração do relatório 
	If lJob .Or. IsInCallStack("U_RFATJ001") .Or. IsInCallStack("U_RFATJ002") 
		GeraPDF(cNomeArq, lJob) 	
	Else
		MV_PAR13 = Iif(ValType(MV_PAR13)=='C',val(MV_PAR13),MV_PAR13)
		MV_PAR15 = Iif(ValType(MV_PAR15)=='C',val(MV_PAR15),MV_PAR15)
		MV_PAR16 = Iif(ValType(MV_PAR16)=='C',val(MV_PAR16),MV_PAR16)
		MV_PAR17 = Iif(ValType(MV_PAR17)=='C',val(MV_PAR17),MV_PAR17)
		If MV_PAR13 ==  1
			Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando relatório... Por favor aguarde!",.T.)   
		Else
			Processa({ |lEnd| GeraEXC(@lEnd) },_cRotina,"Gerando relatório... Por favor aguarde!",.T.)   
		EndIf
	Endif


Return()

User Function verifyVnd(cField,cUsuario,cVendedor)
	Local lRet := Iif(trim(cField)==trim(cUsuario),.T.,.F.)
	If !lRet
		MsgAlert("Este parâmetro não pode ser alterado."+Chr(10)+Chr(13)+"Informação correta: "+cVendedor,"Atenção!")
	EndIf
Return lRet


Static Function GeraPDF(cNomeArq, lJob)
	
	Local nK		:= 0
	Local _cFile	:= _cRotina
	Local _nTipoImp	:= IMP_PDF
	Local _lPropTMS	:= .F.
	Local _lDsbSetup:= .T.
	Local _lTReport	:= .F.
	Local _cPrinter	:= ""
	Local _lServer	:= .F.
	Local _lPDFAsPNG:= .T.
	Local _lRaw		:= .F.
	Local _lViewPDF	:= .T.
	Local _nQtdCopy	:= 1

	Local _cValFore := 0
	Local _cValFatu := 0
	Local _cValFata := 0
	Local _cQtdFore := 0
	Local _cQtdFatu := 0
	Local _cQtdFata := 0

	Local _cValFore2 := 0
	Local _cValFatu2 := 0
	Local _cValFata2 := 0
	Local _cQtdFore2 := 0
	Local _cQtdFatu2 := 0
	Local _cQtdFata2 := 0   

	Local _cQtdDev   := 0
	Local _cValDev   := 0

	Local _VLR_FCT  := 0 
	Local aValores := {}
	Local nJ := 0	

	Local _cAliasTmp	:= GetNextAlias()
	Local cPathTemp		:= ""
	Local nTentativa	:= 5
	Local nCont			:= 0

	Default cNomeArq 	:= "" 
	Default lJob		:= .F.

	
	cPathTemp := Iif(lJob .Or. IsInCallStack("U_RFATJ001") .Or. IsInCallStack("U_RFATJ002"), "_Relatorios\" , AllTrim(GetTempPath()))
	//cPathTemp := GetSrvProfString("STARTPATH","") + "PDFEMAIL\"
	
	MakeDir(cPathTemp) 

	//Nome do arquivo
	If !Empty(cNomeArq)
		_cFile := cNomeArq
	EndIf

	_nCotDmd := SuperGetMv('MV_DOLARMD',, 3.6 )       //cotação média do dolar para conversão
	_nCotEmd := SuperGetMv('MV_EUROMD',, 4.1 )       //cotação média do dolar para conversão                    

	If lJob .Or. IsInCallStack("U_RFATJ001") .Or. IsInCallStack("U_RFATJ002") 
		_lViewPDF	:= .F. 
		MV_PAR16:= 2  //FIXAR EXECUÇÃO EM r$  //Alterado em 19/01/2022 por solicitação do Robson
		MV_PAR17:= 2 //FIXAR EXECUÇÃO EM IMPOSTOS BRUTOS
	Endif



	cDtDe := DTOS(MV_PAR01)
	cDtAte := DTOS(MV_PAR02)

	//mudança da query para buscar da SZR
	_cQry := "  SELECT * FROM ( " + _cEnter 
	_cQry += "  SELECT A1_VEND AS GERENTE, A1_COD AS CODCLI ,A1_NREDUZ AS CLIENTE, A1_LOJA AS LOJA, B1_COD AS CODPROD, B1_DESC AS PRODUTO, " + _cEnter 

	_cQry += " (SELECT ISNULL(SUM(C6_QTDVEN),0) FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) " + _cEnter 
	_cQry += " 	INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
	_cQry += " 	C6_LOJA = C5_LOJACLI AND C6_PRODUTO=B1_COD AND C6_CLI=A1_COD AND " + _cEnter 
	_cQry += " 	C6_LOJA=A1_LOJA  AND " + _cEnter 
	_cQry += "  MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
	_cQry += "  YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and " + _cEnter 
	_cQry += " 	C6_QTDVEN - C6_QTDENT > 0 and C6.D_E_L_E_T_ = '' " + _cEnter
	_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
	_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
	_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
	_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
	_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
	_cQry += " ) AS QTD_FTA, " + _cEnter 

	IF MV_PAR17 == 2 // TRATATIVA PREÇO NET OU BRUTO
		_cQry += "  (SELECT  ISNULL(SUM(C6_VALOR),0)  FROM " + RetSqlName("SC6") + " C6  WITH (NOLOCK) " + _cEnter 
		_cQry += " 	INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
		_cQry += " 	C6_LOJA = C5_LOJACLI AND C6_PRODUTO = B1_COD AND C6_CLI = A1_COD AND " + _cEnter 
		_cQry += " 	C6_LOJA = A1_LOJA  AND " + _cEnter 
		_cQry += "  MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
		_cQry += "  YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and " + _cEnter 
		_cQry += " 	C6_QTDVEN - C6_QTDENT > 0  and C6.D_E_L_E_T_ = '' "+ _cEnter
		_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
		_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
		_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
		_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
		_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
		_cQry += " ) AS VLR_FTA, " + _cEnter 
	ELSE
		_cQry += "  (SELECT  ISNULL(SUM(C6_QTDVEN * DA1.DA1_PRNET),0) FROM " + RetSqlName("SC6") + "  C6  WITH (NOLOCK) " + _cEnter 
		_cQry += "	INNER JOIN " + RetSqlName("DA1") + " DA1 ON DA1_CODTAB = A1_TABELA AND C6.C6_PRODUTO = DA1_CODPRO AND DA1.D_E_L_E_T_<> '*'" + _cEnter 
		_cQry += " 	INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
		_cQry += " 	C6_LOJA = C5_LOJACLI AND C6_PRODUTO = B1_COD AND C6_CLI = A1_COD AND " + _cEnter 
		_cQry += " 	C6_LOJA = A1_LOJA  AND " + _cEnter 
		_cQry += "  MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
		_cQry += "  YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and " + _cEnter 
		_cQry += " 	C6_QTDVEN - C6_QTDENT > 0  and C6.D_E_L_E_T_ = '' "+ _cEnter 
		_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
		_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
		_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
		_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
		_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
		_cQry += " ) AS VLR_FTA, " + _cEnter 
	ENDIF


	_cQry += "  (SELECT TOP 1 C6_NUM FROM " + RetSqlName("SC6") + " C6  WITH (NOLOCK) " + _cEnter 
	_cQry += " 	INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
	_cQry += " 	C6_LOJA = C5_LOJACLI AND C6_PRODUTO = B1_COD AND C6_CLI = A1_COD AND " + _cEnter 
	_cQry += " 	C6_LOJA = A1_LOJA  AND " + _cEnter 
	_cQry += "  MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
	_cQry += "  YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and " + _cEnter 
	_cQry += " 	C6_QTDVEN - C6_QTDENT > 0 and C6.D_E_L_E_T_ = '' 
	_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
	_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
	_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
	_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
	_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
	_cQry += " GROUP BY C6_NUM ) AS NUM,  " + _cEnter 

	_cQry += "  (SELECT ISNULL(SUM(ZR_QUANT),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
	_cQry += " 	WHERE ZR_CODPROD=A7_PRODUTO AND  ZR_COD=A7_CLIENTE AND  " + _cEnter 
	_cQry += " 	ZR_LJCLIFO=A7_LOJA AND  ZR_TPOPER = 'V' AND " + _cEnter 
	_cQry += " 	MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND  " + _cEnter 
	_cQry += " 	YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )AS QTD_FTO,  " + _cEnter 


	If MV_PAR16 ==1      //  1 Real  2= Dolar 
		If MV_PAR17 == 1 //1-Net ou 2-Bruto 
			_cQry += "  (SELECT ISNULL(SUM((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM)) ,0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Else
			_cQry += "  (SELECT ISNULL(SUM(ZR_TOTAL+ZR_VALIPI),0)  FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Endif
	Else
		If MV_PAR17 == 1 //1-Net ou 2-Bruto 	   
			_cQry += "  (SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))/ZR_TXMOEDA),0)  FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Else
			_cQry += "  (SELECT ISNULL(SUM((ZR_TOTAL+ZR_VALIPI)/ZR_TXMOEDA),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter  
		Endif
	Endif

	_cQry += " 	WHERE ZR_CODPROD=A7_PRODUTO AND  ZR_COD=A7_CLIENTE AND  " + _cEnter 
	_cQry += " 	ZR_LJCLIFO=A7_LOJA AND  ZR_TPOPER = 'V' AND " + _cEnter 
	_cQry += " 	MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND  " + _cEnter 
	_cQry += " 	YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )AS VLR_FTO,  " + _cEnter 


	_cQry += "  (SELECT ISNULL(SUM(Z2_QTM"+Substr(cDtDe,5,2)+"),0) FROM " + RetSqlName("SZ2") + " WITH (NOLOCK) " + _cEnter 
	_cQry += " 	WHERE Z2_CLIENTE=A1_COD AND Z2_LOJA = A1_LOJA " + _cEnter 
	_cQry += " 	AND Z2_PRODUTO=B1_COD AND Z2_TOPICO = 'F' AND " + _cEnter 
	_cQry += " 	Z2_ANO  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and SZ2010.D_E_L_E_T_ = '') AS QTD_FCT, " + _cEnter 

	If MV_PAR16 ==1      //  1 Real  2= Dolar
		If MV_PAR17 == 1 //1-Net ou 2-Bruto 
			_cQry += "  (SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))*-1) ,0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Else
			_cQry += "  (SELECT ISNULL(SUM(ZR_TOTAL+ZR_VALIPI)*-1,0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Endif
	Else
		If MV_PAR17 == 1 //1-Net ou 2-Bruto 	   
			_cQry += "  (SELECT ISNULL(SUM((((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))/ZR_TXMOEDA)*-1),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Else
			_cQry += "  (SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)/ZR_TXMOEDA)*-1),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter  
		Endif
	Endif


	_cQry += " 	WHERE " + _cEnter 
	_cQry += " 	ZR_CODPROD=A7_PRODUTO AND " + _cEnter 
	_cQry += " 	ZR_COD=A7_CLIENTE AND " + _cEnter 
	_cQry += " 	ZR_LJCLIFO=A7_LOJA AND " + _cEnter 
	_cQry += " 	ZR_TPOPER = 'D' AND " + _cEnter 
	_cQry += " 	MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND " + _cEnter 
	_cQry += " 	YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+")AS VLR_DEV,  " + _cEnter 

	_cQry += "  (SELECT ISNULL(SUM((ZR_QUANT)*-1),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
	_cQry += " 	WHERE" + _cEnter 
	_cQry += " 	ZR_CODPROD=A7_PRODUTO AND " + _cEnter 
	_cQry += " 	ZR_COD=A7_CLIENTE AND " + _cEnter 
	_cQry += " 	ZR_LJCLIFO=A7_LOJA AND " + _cEnter 
	_cQry += " 	ZR_TPOPER = 'D' AND " + _cEnter 
	_cQry += " 	MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND " + _cEnter 
	_cQry += " 	YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+")AS QTD_DEV,  " + _cEnter 


	_cQry += "  ((SELECT ISNULL(SUM(C6_QTDVEN),0) FROM  " + RetSqlName("SC6") + " C6 WITH (NOLOCK) " + _cEnter 
	_cQry += " 		INNER JOIN SC5010 ON " + _cEnter 
	_cQry += " 		C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
	_cQry += " 		C6_LOJA = C5_LOJACLI AND C6_PRODUTO=A7_PRODUTO AND " + _cEnter 
	_cQry += " 		C6_CLI=A7_CLIENTE AND C6_LOJA=A7_LOJA and C5_EMISSAO ='' AND" + _cEnter 
	_cQry += " 		MONTH(C5_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" "+ _cEnter
	_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
	_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
	_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
	_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
	_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
	_cQry += " ) " + _cEnter     
	_cQry += " 		 + "
	_cQry += " 	(SELECT ISNULL(SUM(ZR_QUANT),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
	_cQry += " 		WHERE ZR_CODPROD=A7_PRODUTO AND  ZR_COD=A7_CLIENTE AND  " + _cEnter 
	_cQry += " 		ZR_LJCLIFO=A7_LOJA AND  ZR_TPOPER = 'V' AND " + _cEnter 
	_cQry += " 		MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND  " + _cEnter 
	_cQry += " 		YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )) " + _cEnter 
	_cQry += " 		- " + _cEnter 
	_cQry += " 	(SELECT ISNULL(SUM(Z2_QTM"+Substr(cDtDe,5,2)+"),0)  FROM " + RetSqlName("SZ2") + " WITH (NOLOCK) " + _cEnter 
	_cQry += " 		WHERE Z2_CLIENTE=A1_COD AND Z2_LOJA = A1_LOJA AND " + _cEnter 
	_cQry += " 		Z2_PRODUTO=B1_COD AND Z2_TOPICO = 'F' AND " + _cEnter 
	_cQry += " 		Z2_ANO between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and SZ2010.D_E_L_E_T_ = '')   as DIFE  ,   " + _cEnter 

	IF MV_PAR17==2 // 2 - BRUTO, 1 - NET					  
		_cQry += " 	((SELECT ISNULL(SUM(C6_VALOR),0) FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) " + _cEnter 
		_cQry += " 		INNER JOIN " + RetSqlName("SC5") + " ON " + _cEnter 
		_cQry += " 		C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
		_cQry += " 		C6_LOJA = C5_LOJACLI AND C6_PRODUTO=A7_PRODUTO AND " + _cEnter 
		_cQry += " 		C6_CLI=A7_CLIENTE AND C6_LOJA=A7_LOJA AND " + _cEnter 
		_cQry += "  	MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
		_cQry += "  	YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" "+ _cEnter
		_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
		_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
		_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
		_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
		_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter		
		_cQry += " ) " + _cEnter  
		_cQry += " 		+ " + _cEnter 
		IF MV_PAR16 == 2
			_cQry += " 		(SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)/ZR_TXMOEDA)),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter     
		ELSE
			_cQry += " 		(SELECT ISNULL(SUM((ZR_TOTAL+ZR_VALIPI)),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		ENDIF
		_cQry += " 			WHERE " + _cEnter 
		_cQry += " 			ZR_CODPROD=A7_PRODUTO AND " + _cEnter 
		_cQry += " 			ZR_COD=A7_CLIENTE AND " + _cEnter 
		_cQry += " 			ZR_LJCLIFO=A7_LOJA AND " + _cEnter 
		_cQry += " 			ZR_TPOPER = 'V' AND " + _cEnter 
		_cQry += " 			MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND " + _cEnter 
		_cQry += " 			YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )) " + _cEnter 
		_cQry += " 		- " + _cEnter 
		_cQry += " 		((SELECT ISNULL(SUM(Z2_QTM"+Substr(cDtDe,5,2)+"),0)  FROM " + RetSqlName("SZ2") + "  WITH (NOLOCK) " + _cEnter 
		_cQry += " 			WHERE Z2_CLIENTE=A1_COD AND Z2_LOJA = A1_LOJA AND " + _cEnter 
		_cQry += " 			Z2_PRODUTO=B1_COD AND Z2_TOPICO = 'F' AND " + _cEnter 
		_cQry += " 			Z2_ANO  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and SZ2010.D_E_L_E_T_ = '') " + _cEnter 
		_cQry += " 		* " + _cEnter 

		_cQry += " 		isnull((SELECT 

		IF MV_PAR16 == 2
			_cQry += " 			(case when DA1_MOEDA = 1 then  ISNULL(SUM((DA1_PRCVEN )/"+cValtoChar(_nCotDmd)+"),0)  " + _cEnter
			_cQry += " 	        when DA1_MOEDA = 4 then  ISNULL(SUM((DA1_PRCVEN )/"+cValtoChar(_nCotEmd)+"),0)  " + _cEnter  
			_cQry += " 			else ISNULL(SUM((DA1_PRCVEN) ),0)   end) " + _cEnter      
		ELSE
			_cQry += " 			(case when DA1_MOEDA = 1 then  ISNULL(SUM(DA1_PRCVEN ),0)  " + _cEnter 
			_cQry += " 			else ISNULL(SUM((DA1_PRCVEN *"+cValtoChar(_nCotDmd)+") ),0)   end) " + _cEnter  
		ENDIF

		_cQry += " 			FROM " + RetSqlName("DA1") + "  WITH (NOLOCK)    " + _cEnter 
		_cQry += " 			WHERE  DA1_CODTAB = A1_TABELA   and  " + _cEnter 
		_cQry += " 			DA1_CODPRO=B1_COD and  " + _cEnter 
		_cQry += " 			DA1_DATVIG < '"+DTOS(dDatabase)+"'  and " + _cEnter 
		_cQry += " 			D_E_L_E_T_ = '' group by DA1_MOEDA),0))    as DIFF " + _cEnter   


	ELSE // NET		
		_cQry += " 	((SELECT ISNULL(SUM(C6_QTDVEN * DA1.DA1_PRNET),0) FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) " + _cEnter 
		_cQry += "		INNER JOIN " + RetSqlName("DA1") + " DA1 ON DA1_CODTAB = A1_TABELA AND C6.C6_PRODUTO = DA1_CODPRO AND DA1.D_E_L_E_T_<> '*'" + _cEnter 
		_cQry += " 		INNER JOIN " + RetSqlName("SC5") + " ON " + _cEnter 
		_cQry += " 		C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
		_cQry += " 		C6_LOJA = C5_LOJACLI AND C6_PRODUTO=A7_PRODUTO AND " + _cEnter 
		_cQry += " 		C6_CLI=A7_CLIENTE AND C6_LOJA=A7_LOJA AND " + _cEnter 
		_cQry += "  	MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
		_cQry += "  	YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" "
		_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
		_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
		_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
		_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
		_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter			
		_cQry += " ) " + _cEnter 
		_cQry += " 		+ " + _cEnter 
		IF MV_PAR16 == 2
			_cQry += " 		(SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))/ZR_TXMOEDA),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter     
		ELSE
			_cQry += " 		(SELECT ISNULL(SUM((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM)),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		ENDIF
		_cQry += " 			WHERE " + _cEnter 
		_cQry += " 			ZR_CODPROD=A7_PRODUTO AND " + _cEnter 
		_cQry += " 			ZR_COD=A7_CLIENTE AND " + _cEnter 
		_cQry += " 			ZR_LJCLIFO=A7_LOJA AND " + _cEnter 
		_cQry += " 			ZR_TPOPER = 'V' AND " + _cEnter 
		_cQry += " 			MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND " + _cEnter 
		_cQry += " 			YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )) " + _cEnter 
		_cQry += " 		- " + _cEnter 
		_cQry += " 		((SELECT ISNULL(SUM(Z2_QTM"+Substr(cDtDe,5,2)+"),0)  FROM " + RetSqlName("SZ2") + "  WITH (NOLOCK) " + _cEnter 
		_cQry += " 			WHERE Z2_CLIENTE=A1_COD AND Z2_LOJA = A1_LOJA AND " + _cEnter 
		_cQry += " 			Z2_PRODUTO=B1_COD AND Z2_TOPICO = 'F' AND " + _cEnter 
		_cQry += " 			Z2_ANO  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and SZ2010.D_E_L_E_T_ = '') " + _cEnter 
		_cQry += " 		* " + _cEnter 

		_cQry += " 		isnull((SELECT 

		IF MV_PAR16 == 2
			_cQry += " 			(case when DA1_MOEDA = 1 then  ISNULL(SUM((DA1_PRNET )/"+cValtoChar(_nCotDmd)+"),0)  " + _cEnter
			_cQry += " 	        when DA1_MOEDA = 4 then  ISNULL(SUM((DA1_PRNET )/"+cValtoChar(_nCotEmd)+"),0)  " + _cEnter  
			_cQry += " 			else ISNULL(SUM((DA1_PRNET) ),0)   end) " + _cEnter      
		ELSE
			_cQry += " 			(case when DA1_MOEDA = 1 then  ISNULL(SUM(DA1_PRNET ),0)  " + _cEnter 
			_cQry += " 			else ISNULL(SUM((DA1_PRNET *"+cValtoChar(_nCotDmd)+") ),0)   end) " + _cEnter  
		ENDIF

		_cQry += " 			FROM " + RetSqlName("DA1") + "  WITH (NOLOCK)    " + _cEnter 
		_cQry += " 			WHERE  DA1_CODTAB = A1_TABELA   and  " + _cEnter 
		_cQry += " 			DA1_CODPRO=B1_COD and  " + _cEnter 
		_cQry += " 			DA1_DATVIG < '"+DTOS(dDatabase)+"'  and " + _cEnter 
		_cQry += " 			D_E_L_E_T_ = '' group by DA1_MOEDA),0))    as DIFF " + _cEnter 



	ENDIF		

	_cQry += "   FROM  " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) " + _cEnter 
	_cQry += "   LEFT JOIN  " + RetSqlName("SA7") + " SA7 WITH (NOLOCK) " + _cEnter 
	_cQry += "   ON B1_COD = A7_PRODUTO " + _cEnter 
	_cQry += "   AND SB1.D_E_L_E_T_ = '' " + _cEnter 
	_cQry += "   AND  SA7.D_E_L_E_T_ = '' " + _cEnter 
	_cQry += "   AND A7_XSEGMEN  BETWEEN '"+MV_PAR07+"' and '"+MV_PAR08+"' " + _cEnter 
	_cQry += "   AND A7_XSEGMEN  BETWEEN RTRIM('"+MV_PAR11+"00"+"') and RTRIM('"+MV_PAR12+"99"+"') " + _cEnter

	_cQry += "   INNER JOIN   " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + _cEnter 
	_cQry += "   ON A1_COD = A7_CLIENTE AND A1_LOJA = A7_LOJA  AND SA1.D_E_L_E_T_ = '' and SA1.A1_VEND Between '"+MV_PAR09+"' and '"+MV_PAR10+"' and SA1.A1_COD  Between '"+MV_PAR03+"' and '"+MV_PAR04+"' ) AUX " + _cEnter 

	_cQry += "   WHERE (AUX.QTD_FTA + AUX.VLR_FTA + AUX.QTD_FTO + AUX.VLR_FTO + AUX.QTD_FCT)>0 " + _cEnter 

	memowrite("TESTEE.txt",_cQry)
	//Cria tabela temporária com base no resultado da query 7
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)

	dbSelectArea(_cAliasTmp)

	If lJob .Or. IsInCallStack("U_RFATJ001") .Or. IsInCallStack("U_RFATJ002") 
		oPrn := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,cPathTemp,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)
		oPrn:cPathPDF := cPathTemp
	else
		oPrn := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)
	endif
	oPrn:SetResolution(72)
	oPrn:SetLandScape()	// Orientação do Papel (Paisagem)
	oPrn:SetPaperSize(9)
	oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior

	//Quebra(_cGerente)
	Quebra() 

	IF MV_PAR09==MV_PAR10 // para um unico gerente imprimir os dados do gerente no cabeçalho
		
		If (_cAliasTmp)->(!Eof()) .And. !Empty((_cAliasTmp)->GERENTE)
			oPrn:SayAlign( 0120 , 0540, "Gerente: " + POSICIONE("SA3",1,xFilial("SA3")+ (_cAliasTmp)->GERENTE,"A3_NREDUZ") , oFont02, 0800-0005,0060,,0,0)
		Else
			oPrn:SayAlign( 0120 , 0540, "Gerente: " + POSICIONE("SA3",1,xFilial("SA3")+ PADR(MV_PAR09,TAMSX3("A3_COD")[1]),"A3_NREDUZ") , oFont02, 0800-0005,0060,,0,0)
		EndIF

	Endif

	dbSelectArea(_cAliasTmp)
	DbGotop()


	While !EOF()	
		nJ++
		_cCodCli  := ALLTRIM((_cAliasTmp)->CODCLI)
		_cLojaCli := ALLTRIM((_cAliasTmp)->LOJA)
		_cCodProd := PADR((_cAliasTmp)->CODPROD,TAMSX3("Z2_PRODUTO")[01])
		_cAno     := Substr(Dtos(mv_par01),1,4)
		_nQTD_FCT := (_cAliasTmp)->QTD_FCT   
		_nQTD_DEV := (_cAliasTmp)->QTD_DEV

		if MV_PAR17 == 1
			_cNet:= "1"    
		else 
			_cNet:= "2"  
		endif

		IF MV_PAR16 == 1
			_nVLR_FCT := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		ELSE  
			_nVLR_FCT := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		ENDIF

		_VLR_FCT  := _nVLR_FCT * _nQTD_FCT  
		//Quadro com os dados       

		nMoed := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_MOEDA") 
		ntaxa := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_TXREF")
		If empty(nTaxa)
			//Alterado para obter a taxa PTAX do dia anterior à geração do relatório conforme solicitado pelo Robson em 19/01/2022
			nDia := 0
			While ntaxa == 0
				nDia++
				ntaxa := Posicione("SM2",1,DtoS(DaySub(Date(),nDia)),"M2_MOEDA2")
			EndDo
			// ntaxa := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_TXMOEDA")
		EndIf
		_cGerente := POSICIONE("SA3",1,xFilial("SA3")+ (_cAliasTmp)->GERENTE,"A3_NREDUZ")
		//	oPrn:SayAlign(_nLin,0010, _cGerente,oFont04, 0800-0005,0060,,0,2)//GERENTE
		AAdd( aValores, {SUBSTR((_cAliasTmp)->CLIENTE,1,30),;
		SUBSTR((_cAliasTmp)->PRODUTO,1,30),;
		Transform(ROUND(_VLR_FCT,0),"@E 999,999,999"),;
		IIF(MV_PAR16 == 1 ,Transform(ROUND(Iif(nMoed== 2 ,(_cAliasTmp)->VLR_FTA* Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA),0),"@E 999,999,999"),Transform(ROUND(Iif(nMoed== 1 ,(_cAliasTmp)->VLR_FTA / Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA),0),"@E 999,999,999")),;
		Transform(ROUND((_cAliasTmp)->VLR_FTO ,0) ,"@E 999,999,999"),;
		IIF(MV_PAR16 == 1 ,ROUND(((_cAliasTmp)->VLR_FTO + Iif(nMoed== 2 ,(_cAliasTmp)->VLR_FTA* Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA) - _VLR_FCT),0),ROUND(((_cAliasTmp)->VLR_FTO + Iif(nMoed== 1 ,(_cAliasTmp)->VLR_FTA /Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA) - _VLR_FCT),0)),;
		Transform(ROUND((_cAliasTmp)->VLR_DEV,0),"@E 999,999,999"),;
		Transform(ROUND(_nQTD_FCT,0),"@E 999,999,999"),;
		Transform(ROUND((_cAliasTmp)->QTD_FTA,0),"@E 999,999,999"),;
		Transform(ROUND((_cAliasTmp)->QTD_FTO,0),"@E 999,999,999"),;
		Transform(ROUND(((_cAliasTmp)->QTD_FTO + (_cAliasTmp)->QTD_FTA - _nQTD_FCT),0),"@E 999,999,999"),;
		Transform(ROUND((_cAliasTmp)->QTD_DEV,0),"@E 999,999,999"),;
		(_cAliasTmp)->CODPROD,;
		(_cAliasTmp)->CODCLI })


		IF MV_PAR16 == 1 
			_cValFore += ROUND(_VLR_FCT,0)
			_cValFatu += ROUND((_cAliasTmp)->VLR_FTO,0)
			_cValFata += ROUND(Iif(nMoed== 2 ,(_cAliasTmp)->VLR_FTA* Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA),0)		
			_cQtdFore += ROUND(_nQTD_FCT,0)
			_cQtdFatu += ROUND((_cAliasTmp)->QTD_FTO,0)
			_cQtdFata += ROUND((_cAliasTmp)->QTD_FTA,0)
			_cQtdDev   += _nQTD_DEV
			_cValDev  += ROUND((_cAliasTmp)->VLR_DEV,0)
		ELSE
			_cValFore += ROUND(_VLR_FCT,0)
			_cValFatu += ROUND((_cAliasTmp)->VLR_FTO,0)
			_cValFata += ROUND(Iif(nMoed== 1 ,(_cAliasTmp)->VLR_FTA/ Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA),0) 
			_cQtdFore += ROUND(_nQTD_FCT,0)
			_cQtdFatu += ROUND((_cAliasTmp)->QTD_FTO,0)
			_cQtdFata += ROUND((_cAliasTmp)->QTD_FTA,0)
			_cQtdDev   += ROUND(_nQTD_DEV,0)
			_cValDev  += ROUND((_cAliasTmp)->VLR_DEV,0)
		ENDIF     
		dbskip()
	EndDo	

	If MV_PAR15 == 2 
		oPrn:SayAlign( 0120 , 0650, "Ordem: Cliente"   , oFont02, 0800-0005,0060,,0,0)
		aSort(aValores,,,{|x,y| x[14] < y[14]})
	elseIf MV_PAR15 == 3     
		oPrn:SayAlign( 0120 , 0650, "Ordem: Cod Produto"  , oFont02, 0800-0005,0060,,0,0)
		aSort(aValores,,,{|x,y| x[13] < y[13]})
	elseIf MV_PAR15 == 5  
		oPrn:SayAlign( 0120 , 0650, "Ordem: Diferenca Quantidade"  , oFont02, 0800-0005,0060,,0,0)
		aSort(aValores,,,{|x,y| x[6] < y[6]})
	elseIf MV_PAR15 == 4
		oPrn:SayAlign( 0120 , 0650, "Ordem: Diferenca Valor "  , oFont02, 0800-0005,0060,,0,0)
		aSort(aValores,,,{|x,y| x[6] < y[6]})
	eLSE 
		oPrn:SayAlign( 0120 , 0650, "Ordem: Gerente"  , oFont02, 0800-0005,0060,,0,0) 
	Endif 

	For nK := 1 to len(aValores)

		//	If  ROUND(((_cAliasTmp)->VLR_FTO + (_cAliasTmp)->VLR_FTA - _VLR_FCT),0) >= MV_PAR14	 .or. ROUND(((_cAliasTmp)->VLR_FTO + (_cAliasTmp)->VLR_FTA - _VLR_FCT),0) <= (MV_PAR14*-1)	
		If ROUND(aValores [nk] [6],0) >= MV_PAR14 .or. ROUND(aValores [nk] [6],0) <= (MV_PAR14*-1)
			oPrn:Box(_nLin-5, 0000, _nLin+15, 0125, "-4")//Cliente	
			oPrn:Box(_nLin-5, 0125, _nLin+15, 0285, "-4")//Produto
			oPrn:Box(_nLin-5, 0285, _nLin+15, 0336, "-4")//Forecast Valor
			oPrn:Box(_nLin-5, 0336, _nLin+15, 0386, "-4")//Faturado Valor
			oPrn:Box(_nLin-5, 0386, _nLin+15, 0436, "-4")//A Faturar Valor
			oPrn:Box(_nLin-5, 0436, _nLin+15, 0490, "-4")//Diferença Valor
			oPrn:Box(_nLin-5, 0490, _nLin+15, 0540, "-4")//Forecast Quantidade 
			oPrn:Box(_nLin-5, 0540, _nLin+15, 0600, "-4")//Devolucao
			oPrn:Box(_nLin-5, 0600, _nLin+15, 0650, "-4")//Faturado Quantidade
			oPrn:Box(_nLin-5, 0650, _nLin+15, 0700, "-4")//A Faturar Quantidade		
			oPrn:Box(_nLin-5, 0700, _nLin+15, 0750, "-4")//Diferença Quantidade	
			oPrn:Box(_nLin-5, 0750, _nLin+15, 0815, "-4")//Diferença Quantidade	  

			oPrn:SayAlign(_nLin,0010, aValores[nK][1], 	oFont04, 0800-0005,0060,,0,2)//CLIENTE
			oPrn:SayAlign(_nLin,0130, aValores[nK][2],  oFont04, 0800-0005,0060,,0,2)//PRODUTO
			oPrn:SayAlign(_nLin,0290, aValores[nK][3],  oFont04, 0800-0005,0060,,0,2)//VALOR FORECAST
			oPrn:SayAlign(_nLin,0340, aValores[nK][4],	oFont04, 0800-0005,0060,,0,2)//VALOR FATURADO
			oPrn:SayAlign(_nLin,0390, aValores[nK][5],  oFont04, 0800-0005,0060,,0,2)//VALOR A FATURAR
			oPrn:SayAlign(_nLin,0440, Transform(aValores[nK][6],"@E 999,999,999"), 	oFont04, 0800-0005,0060,,0,2)//DIFERENÇA VALOR
			oPrn:SayAlign(_nLin,0495, aValores[nK][7],	oFont04, 0800-0005,0060,,0,2)//QUANTIDADE FORECAST 
			oPrn:SayAlign(_nLin,0545, aValores[nK][8],	oFont04, 0800-0005,0060,,0,2)//Devolucao 
			oPrn:SayAlign(_nLin,0595, aValores[nK][9], 	oFont04, 0800-0005,0060,,0,2)//QUANTIDADE FATURADO
			oPrn:SayAlign(_nLin,0645, aValores[nK][10], oFont04, 0800-0005,0060,,0,2)//QUANTIDADE A FATURAR
			oPrn:SayAlign(_nLin,0695, aValores[nK][11], oFont04, 0800-0005,0060,,0,2)//DIFERENÇA QUANTIDADE
			oPrn:SayAlign(_nLin,0755, aValores[nK][12],	oFont04, 0800-0005,0060,,0,2)//Devolucao 

			_nLin += _nEspPad

			If _nLin >= _nLinFin
				oPrn:EndPage()
				Quebra(_cGerente)
			Endif
		EndIF	
		//	EndIf	
	Next	

	_nLin +=10
	oPrn:Box(_nLin-5, 0125, _nLin+15, 0285, "-4")//Totais
	oPrn:Box(_nLin-5, 0285, _nLin+15, 0335, "-4")//Totais
	oPrn:Box(_nLin-5, 0335, _nLin+15, 0385, "-4")//Totais
	oPrn:Box(_nLin-5, 0385, _nLin+15, 0436, "-4")//Forecast Valor
	oPrn:Box(_nLin-5, 0436, _nLin+15, 0486, "-4")//Faturado Valor
	oPrn:Box(_nLin-5, 0486, _nLin+15, 0536, "-4")//A Faturar Valor
	oPrn:Box(_nLin-5, 0536, _nLin+15, 0600, "-4")//Diferença Valor
	oPrn:Box(_nLin-5, 0600, _nLin+15, 0650, "-4")//Forecast Quantidade
	oPrn:Box(_nLin-5, 0650, _nLin+15, 0700, "-4")//Faturado Quantidade
	oPrn:Box(_nLin-5, 0700, _nLin+15, 0750, "-4")//A Faturar Quantidade		
	oPrn:Box(_nLin-5, 0750, _nLin+15, 0815, "-4")//Diferença Quantidade  


	oPrn:SayAlign(_nLin,0130, "Totais:",   oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0286, Transform(_cValFore,"@E 999,999,999"),  oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0338, Transform(_cValFata,"@E 999,999,999"),  oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0390, Transform(_cValFatu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0440, Transform(_cValFAtu + _cValFata - _cValFore,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0495, Transform(_cValDev,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0545, Transform(_cQtdFore,"@E 999,999,999"),  oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0605, Transform(_cQtdFata,"@E 999,999,999"),  oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0655, Transform(_cQtdFatu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0705, Transform(_cQtdFatu + _cQtdFata - _cQtdFore,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0755, Transform(_cQtdDev,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)

	_nLin += _nEspPad + 10
	oPrn:Box(_nLin-5, 0095, _nLin+15, 0285, "-4")//Totais independente do valor do corte
	oPrn:Box(_nLin-5, 0285, _nLin+15, 0335, "-4")//Forecast Valor
	oPrn:Box(_nLin-5, 0335, _nLin+15, 0385, "-4")//Forecast Valor
	oPrn:Box(_nLin-5, 0385, _nLin+15, 0436, "-4")//Forecast Valor
	oPrn:Box(_nLin-5, 0436, _nLin+15, 0486, "-4")//Faturado Valor
	oPrn:Box(_nLin-5, 0486, _nLin+15, 0536, "-4")//A Faturar Valor
	oPrn:Box(_nLin-5, 0536, _nLin+15, 0600, "-4")//Diferença Valor
	oPrn:Box(_nLin-5, 0600, _nLin+15, 0650, "-4")//Forecast Quantidade
	oPrn:Box(_nLin-5, 0650, _nLin+15, 0700, "-4")//Faturado Quantidade
	oPrn:Box(_nLin-5, 0700, _nLin+15, 0750, "-4")//A Faturar Quantidade		
	oPrn:Box(_nLin-5, 0750, _nLin+15, 0815, "-4")//Diferença Quantidade	        

	dbSelectArea(_cAliasTmp)
	DbGotop()
	_cQtdDev2:=0
	_cValDev2:= 0    

	While !EOF()      

		_cCodCli  := ALLTRIM((_cAliasTmp)->CODCLI)
		_cLojaCli := ALLTRIM((_cAliasTmp)->LOJA)
		_cCodProd := PADR((_cAliasTmp)->CODPROD,TAMSX3("Z2_PRODUTO")[01])
		_cAno     := Substr(DTOS(mv_par01),1,4)
		_nQTD_FCT := (_cAliasTmp)->QTD_FCT     

		if MV_PAR17 == 1
			_cNet:= "1"    
		else 
			_cNet:= "2"  
		endif

		IF MV_PAR16 == 1
			_nVLR_FCT := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	 
		ELSE
			_nVLR_FCT := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		ENDIF

		_VLR_FCT  := _nVLR_FCT * _nQTD_FCT   
		nMoed := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_MOEDA") 
		ntaxa := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_TXREF")
		If empty(nTaxa)
			//Alterado para obter a taxa PTAX do dia anterior à geração do relatório conforme solicitado pelo Robson em 19/01/2022
			nDia := 0
			While ntaxa == 0
				nDia++
				ntaxa := Posicione("SM2",1,DtoS(DaySub(Date(),nDia)),"M2_MOEDA2")
			EndDo
			// ntaxa := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_TXMOEDA")
		EndIf

		_cValFore2 += ROUND(_VLR_FCT,0)
		_cValFatu2 += ROUND((_cAliasTmp)->VLR_FTO,0)  

		IF MV_PAR16 == 1
			_cValFata2 += ROUND(Iif(nMoed== 2 ,(_cAliasTmp)->VLR_FTA* Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA),0)
		ELSE
			_cValFata2 += ROUND(Iif(nMoed== 1 ,(_cAliasTmp)->VLR_FTA/ Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA),0)
		ENDIF

		_cQtdFore2 += ROUND((_cAliasTmp)->QTD_FCT,0)
		_cQtdFatu2 += ROUND((_cAliasTmp)->QTD_FTO,0)
		_cQtdFata2 += ROUND((_cAliasTmp)->QTD_FTA,0) 
		_cQtdDev2  += ROUND((_cAliasTmp)->QTD_DEV,0)
		_cValDev2  += ROUND((_cAliasTmp)->VLR_DEV,0)
		DbSkip()
	EndDo 
	oPrn:SayAlign(_nLin,0100, "Totais independente do valor do corte:",   oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0290, Transform(_cValFore2,"@E 999,999,999"),  oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0340, Transform(_cValFata2,"@E 999,999,999"),  oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0390, Transform(_cValFatu2,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0440, Transform(_cValFatu2 + _cValFata2 - _cValFore2,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0495, Transform(_cValDev2,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0545, Transform(_cQtdFore2,"@E 999,999,999"),  oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0605, Transform(_cQtdFata2,"@E 999,999,999"),  oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0655, Transform(_cQtdFatu2 ,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0705, Transform(_cQtdFatu2 + _cQtdFata2 - _cQtdFore2,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0755, Transform(_cQtdDev2,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
	oPrn:EndPage()
	
	oPrn:Preview() 
	
	//Verifica se o arquivo pdf foi criado com sucesso, caso contrario aguardará a finalização do mesmo. Esse processo será realizado em até 5 tentativas
	If !File(oPrn:cPathPDF+_cFile) .Or. File(Substring(oPrn:cPathPDF+_cFile,1,Len(oPrn:cPathPDF+_cFile)-1)+"_" ) 
		While nCont <= nTentativa 
			sleep(5000)
			++nCont
			If File(oPrn:cPathPDF+_cFile) .And. !File(Substring(oPrn:cPathPDF+_cFile,1,Len(oPrn:cPathPDF+_cFile)-1)+"_" )
				exit
			EndIf
		EndDo
	EndIf
	
Return()

Static Function Quebra(_cGerente)

	oPrn:StartPage()   

	_nLin := 080

	ImpLogo()

	IF MV_PAR09 == MV_PAR10  
		if Valtype(_cGerente) <> "U" 
			oPrn:SayAlign( 0120 , 0540, "Gerente: " + _cGerente , oFont02, 0800-0005,0060,,0,0)
		EndIf                   
	Endif

	If MV_PAR15 == 2 

		oPrn:SayAlign( 0120 , 0650, "Ordem: Cliente"   , oFont02, 0800-0005,0060,,0,0)

	elseIf MV_PAR15 == 3     

		oPrn:SayAlign( 0120 , 0650, "Ordem: Cod Produto"  , oFont02, 0800-0005,0060,,0,0)

	elseIf MV_PAR15 == 5  

		oPrn:SayAlign( 0120 , 0650, "Ordem: Diferenca Quantidade"  , oFont02, 0800-0005,0060,,0,0)

	elseIf MV_PAR15 == 4

		oPrn:SayAlign( 0120 , 0650, "Ordem: Diferenca Valor "  , oFont02, 0800-0005,0060,,0,0)

	eLSE

		oPrn:SayAlign( 0120 , 0650, "Ordem: Gerente"  , oFont02, 0800-0005,0060,,0,0) 

	Endif   
	oPrn:SayAlign(	0050 , 0080, "Moeda: " + IIF(MV_PAR16== 1,"Real - R$","Dolar - $"), oFont03, 0800-0005,0060,,2,0)
	oPrn:SayAlign(	0050 , 0160, "Impostos: " + IIF(MV_PAR17== 1,"Net","Bruto"), oFont03, 0800-0005,0060,,2,0)
	oPrn:SayAlign(  0050 , 0005, "Emissão: " + DTOC(DDataBase), oFont03, 0800-0005,0060,,1,0)
	oPrn:SayAlign( _nLin , 0005, "Acompanhamento de Vendas",    oFont01, 0800-0005,0060,,2,0)

	_nLin += 0040
	oPrn:SayAlign( _nLin , 0150, "Base: " + Substr(DTOS(mv_par01),5,2)+ "/" + Substr(DTOS(mv_par01),1,4)		 , oFont02, 0800-0005,0060,,0,0)
	oPrn:SayAlign( _nLin , 0240, "Valor de Corte: " + Transform(MV_PAR14,"@E 999,999,999.99"), oFont02, 0800-0005,0060,,0,0)
	oPrn:SayAlign( _nLin , 0390, "Unid Negócio: " + MV_PAR11 + " até " + MV_PAR12 , oFont02, 0800-0005,0060,,0,0)

	_nLin += 0050	
	oPrn:Box(_nLin-5, 0285, _nLin+15, 0540, "-4")
	oPrn:Box(_nLin-5, 0540, _nLin+15, 0815, "-4")
	oPrn:SayAlign( _nLin , 0370, "Valores                                                                                  Quantidades", oFont02, 0800-0005,0060,,0,0)

	_nLin += _nEspPad		
	//Quadro com os box's 
	//	oPrn:Box(_nLin-5, 0000, _nLin+15, 0065, "-4")//Gerente
	oPrn:Box(_nLin-5, 0000, _nLin+15, 0125, "-4")//Cliente	
	oPrn:Box(_nLin-5, 0125, _nLin+15, 0385, "-4")//Produto
	oPrn:Box(_nLin-5, 0285, _nLin+15, 0436, "-4")//Forecast Valor
	oPrn:Box(_nLin-5, 0336, _nLin+15, 0486, "-4")//Faturado Valor
	oPrn:Box(_nLin-5, 0386, _nLin+15, 0536, "-4")//A Faturar Valor
	oPrn:Box(_nLin-5, 0436, _nLin+15, 0590, "-4")//Diferença Valor
	oPrn:Box(_nLin-5, 0490, _nLin+15, 0540, "-4")//Forecast Quantidade 
	oPrn:Box(_nLin-5, 0540, _nLin+15, 0600, "-4")//Devolucao
	oPrn:Box(_nLin-5, 0600, _nLin+15, 0650, "-4")//Faturado Quantidade
	oPrn:Box(_nLin-5, 0650, _nLin+15, 0700, "-4")//A Faturar Quantidade		
	oPrn:Box(_nLin-5, 0700, _nLin+15, 0750, "-4")//Diferença Quantidade				
	oPrn:Box(_nLin-5, 0750, _nLin+15, 0815, "-4")//Diferença Quantidade	
	//Quadro com nome das colunas				
	//	oPrn:SayAlign(_nLin,0010, "Gerente",   oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0010, "Cliente",   oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0130, "Produto",   oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0290, "Forecast",  oFont02, 0800-0005,0060,,0,2) 
	oPrn:SayAlign(_nLin,0340, "A Faturar", oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0390, "Faturado",  oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0440, "Diferença", oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0495, "Devoluç.", oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0545, "Forecast",  oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0605, "A Faturar", oFont02, 0800-0005,0060,,0,2) 
	oPrn:SayAlign(_nLin,0655, "Faturado",  oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0705, "Diferença", oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0755, "Devoluç.", oFont02, 0800-0005,0060,,0,2)   

	_nLin += _nEspPad

Return()

Static Function ImpLogo()

	Local cLogo      	:= FisxLogo("1")
	Local cLogoD	    := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Logotipo                                     						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	lMv_Logod	:= .T.

	cLogoD := GetSrvProfString("Startpath","") + "lgrl" + cEmpAnt + cFilAnt + ".BMP"

	If !File(cLogoD)
		cLogoD	:= GetSrvProfString("Startpath","") + "lgrl" + "01" + ".BMP"
		If !File(cLogoD)
			lMv_Logod := .F.
		EndIf
	EndIf

	If lMv_Logod
		oPrn:SayBitmap(050,010,cLogoD,0110,100)
	Else               
		oPrn:SayBitmap(050,010,cLogo ,0110,100)
	EndIf

Return()

Static Function ValidPerg()

	Local _sAlias	:= GetArea()
	Local aRegs		:= {}
	Local _x		:= 1
	Local _y		:= 1
	cPerg			:= PADR(cPerg,10)



	AADD(aRegs,{cPerg,"01","Data De:"							,"","","mv_ch1","D",08,0,3,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data Ate:"							,"","","mv_ch2","D",08,0,3,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Cliente De:"						,"","","mv_ch3","C",06,0,3,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA1DEN","","","",""})
	AADD(aRegs,{cPerg,"04","Cliente Ate:"						,"","","mv_ch4","C",06,0,3,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA1DEN","","","",""})  
	AADD(aRegs,{cPerg,"05","Produto De:"						,"","","mv_ch5","C",15,0,3,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
	AADD(aRegs,{cPerg,"06","Produto Ate:"						,"","","mv_ch6","C",15,0,3,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
	AADD(aRegs,{cPerg,"07","Segmento De:"						,"","","mv_ch7","C",06,0,3,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","AOV","","","",""})
	AADD(aRegs,{cPerg,"08","Segmento Ate:"						,"","","mv_ch8","C",06,0,3,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","AOV","","","",""})
	AADD(aRegs,{cPerg,"09","Vendedor De:"						,"","","mv_ch9","C",06,0,3,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","",""})
	AADD(aRegs,{cPerg,"10","Vendedor Ate:"						,"","","mv_cha","C",06,0,3,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","",""})
	AADD(aRegs,{cPerg,"11","Unid Negocio De:"					,"","","mv_chb","C",04,0,3,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","",""})
	AADD(aRegs,{cPerg,"12","Unid Negocio Ate:"			 		,"","","mv_chc","C",04,0,3,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","",""})
	AADD(aRegs,{cPerg,"13","Modelo impressão:"			   		,"","","mv_chd","C",01,0,3,"G","","MV_PAR13","1-PDF","","","","2- Excel","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	AADD(aRegs,{cPerg,"14","Valor de Corte: "			   		,"","","mv_chE","N",08,02,3,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})   
	AADD(aRegs,{cPerg,"15","Ordenar Por  : "			   		,"","","mv_chF","C",08,02,3,"C","","MV_PAR15","Clientes","","","","","Produtos","","","","","Divergencia","","","","","Padrao","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"16","Moeda: "			   	 			,"","","mv_chG","C",01,0,3,"C","","MV_PAR16","1-Real","","","","","2-Dolar","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"17","Impostos: "			   	 			,"","","mv_chh","C",01,0,3,"C","","MV_PAR17","1-Net","","","","","2-Bruto","","","","","","","","","","","","","","","","","","","","","","",""})
	For _x := 1 To Len(aRegs)
		dbSelectArea("SX1")
		SX1->(dbSetOrder(1))
		If !SX1->(MsSeek(cPerg+aRegs[_x,2],.T.,.F.))
			RecLock("SX1",.T.)		
			For _y := 1 To FCount()                              
				If _y <= Len(aRegs[_x])                         
					FieldPut(_y,aRegs[_x,_y])        
				Else
					Exit
				EndIf
			Next
			SX1->(MsUnlock())
		EndIf
	Next

	RestArea(_sAlias)

Return()    

Static Function GeraEXC()  

	Local _cFile	:= _cRotina
	Local _nTipoImp	:= IMP_PDF
	Local _lPropTMS	:= .F.
	Local _lDsbSetup:= .T.
	Local _lTReport	:= .F.
	Local _cPrinter	:= ""
	Local _lServer	:= .F.
	Local _lPDFAsPNG:= .T.
	Local _lRaw		:= .F.
	Local _lViewPDF	:= .T.
	Local _nQtdCopy	:= 1
	Local _cFolder  := cGetFile( '*.xml' , 'Excel (XML)', 1, 'C:\', .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T.)

	Local _cValFore := 0
	Local _cValFatu := 0
	Local _cValFata := 0
	Local _cQtdFore := 0
	Local _cQtdFatu := 0
	Local _cQtdFata := 0	

	Local _cValFore2 := 0
	Local _cValFatu2 := 0
	Local _cValFata2 := 0
	Local _cQtdFore2 := 0
	Local _cQtdFatu2 := 0
	Local _cQtdFata2 := 0
	Local aValores := {}
	Local nJ 	:= 0	
	Local nK	:= 0
	Local _VLR_FCT  := 0 
	Local cNomeArq	:= "acompvend_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls"

	Local _cAliasTmp:= GetNextAlias() 
	lOCAL aVALRO:={}
	Private oExcel		:= FWMSEXCEL():New()

	Private _aPar		:= {}

	_nCotDmd := SuperGetMv('MV_DOLARMD',, 3.6 )       //cotação média do dolar para conversão
	_nCotEmd := SuperGetMv('MV_EUROMD',, 4.1 )       //cotação média do dolar para conversão                   

	cDtDe := Dtos(MV_PAR01)
	cDtAte := Dtos(MV_PAR02)

	//mudança da query para buscar da SZR

	_cQry := "  SELECT * FROM ( " + _cEnter 
	_cQry += "  SELECT A1_VEND AS GERENTE, A1_COD AS CODCLI ,A1_NREDUZ AS CLIENTE, A1_LOJA AS LOJA, B1_COD AS CODPROD, B1_DESC AS PRODUTO, " + _cEnter 

	_cQry += " (SELECT ISNULL(SUM(C6_QTDVEN),0) FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) " + _cEnter 
	_cQry += " 	INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
	_cQry += " 	C6_LOJA = C5_LOJACLI AND C6_PRODUTO=B1_COD AND C6_CLI=A1_COD AND " + _cEnter 
	_cQry += " 	C6_LOJA=A1_LOJA  AND " + _cEnter 
	_cQry += "  MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
	_cQry += "  YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and " + _cEnter 
	_cQry += " 	C6_QTDVEN - C6_QTDENT > 0 and C6.D_E_L_E_T_ = '' " + _cEnter
	_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
	_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
	_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
	_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
	_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
	_cQry += " ) AS QTD_FTA, " + _cEnter 

	IF MV_PAR17 == 2 // TRATATIVA PREÇO NET OU BRUTO
		_cQry += "  (SELECT  ISNULL(SUM(C6_VALOR),0)  FROM " + RetSqlName("SC6") + " C6  WITH (NOLOCK) " + _cEnter 
		_cQry += " 	INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
		_cQry += " 	C6_LOJA = C5_LOJACLI AND C6_PRODUTO = B1_COD AND C6_CLI = A1_COD AND " + _cEnter 
		_cQry += " 	C6_LOJA = A1_LOJA  AND " + _cEnter 
		_cQry += "  MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
		_cQry += "  YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and " + _cEnter 
		_cQry += " 	C6_QTDVEN - C6_QTDENT > 0  and C6.D_E_L_E_T_ = '' "+ _cEnter
		_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
		_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
		_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
		_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
		_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
		_cQry += " ) AS VLR_FTA, " + _cEnter 
	ELSE
		_cQry += "  (SELECT  ISNULL(SUM(C6_QTDVEN * DA1.DA1_PRNET),0) FROM " + RetSqlName("SC6") + "  C6  WITH (NOLOCK) " + _cEnter 
		_cQry += "	INNER JOIN " + RetSqlName("DA1") + " DA1 ON DA1_CODTAB = A1_TABELA AND C6.C6_PRODUTO = DA1_CODPRO AND DA1.D_E_L_E_T_<> '*'" + _cEnter 
		_cQry += " 	INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
		_cQry += " 	C6_LOJA = C5_LOJACLI AND C6_PRODUTO = B1_COD AND C6_CLI = A1_COD AND " + _cEnter 
		_cQry += " 	C6_LOJA = A1_LOJA  AND " + _cEnter 
		_cQry += "  MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
		_cQry += "  YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and " + _cEnter 
		_cQry += " 	C6_QTDVEN - C6_QTDENT > 0  and C6.D_E_L_E_T_ = '' "+ _cEnter 
		_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
		_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
		_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
		_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
		_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
		_cQry += " ) AS VLR_FTA, " + _cEnter 
	ENDIF


	_cQry += "  (SELECT TOP 1 C6_NUM FROM " + RetSqlName("SC6") + " C6  WITH (NOLOCK) " + _cEnter 
	_cQry += " 	INNER JOIN " + RetSqlName("SC5") + " C5 ON C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
	_cQry += " 	C6_LOJA = C5_LOJACLI AND C6_PRODUTO = B1_COD AND C6_CLI = A1_COD AND " + _cEnter 
	_cQry += " 	C6_LOJA = A1_LOJA  AND " + _cEnter 
	_cQry += "  MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
	_cQry += "  YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and " + _cEnter 
	_cQry += " 	C6_QTDVEN - C6_QTDENT > 0 and C6.D_E_L_E_T_ = '' 
	_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
	_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
	_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
	_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
	_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
	_cQry += " GROUP BY C6_NUM ) AS NUM,  " + _cEnter 

	_cQry += "  (SELECT ISNULL(SUM(ZR_QUANT),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
	_cQry += " 	WHERE ZR_CODPROD=A7_PRODUTO AND  ZR_COD=A7_CLIENTE AND  " + _cEnter 
	_cQry += " 	ZR_LJCLIFO=A7_LOJA AND  ZR_TPOPER = 'V' AND " + _cEnter 
	_cQry += " 	MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND  " + _cEnter 
	_cQry += " 	YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )AS QTD_FTO,  " + _cEnter 


	If MV_PAR16 ==1      //  1 Real  2= Dolar 
		If MV_PAR17 == 1 //1-Net ou 2-Bruto 
			_cQry += "  (SELECT ISNULL(SUM((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM)) ,0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Else
			_cQry += "  (SELECT ISNULL(SUM(ZR_TOTAL+ZR_VALIPI),0)  FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Endif
	Else
		If MV_PAR17 == 1 //1-Net ou 2-Bruto 	   
			_cQry += "  (SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))/ZR_TXMOEDA),0)  FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Else
			_cQry += "  (SELECT ISNULL(SUM((ZR_TOTAL+ZR_VALIPI)/ZR_TXMOEDA),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter  
		Endif
	Endif

	_cQry += " 	WHERE ZR_CODPROD=A7_PRODUTO AND  ZR_COD=A7_CLIENTE AND  " + _cEnter 
	_cQry += " 	ZR_LJCLIFO=A7_LOJA AND  ZR_TPOPER = 'V' AND " + _cEnter 
	_cQry += " 	MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND  " + _cEnter 
	_cQry += " 	YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )AS VLR_FTO,  " + _cEnter 


	_cQry += "  (SELECT ISNULL(SUM(Z2_QTM"+Substr(cDtDe,5,2)+"),0) FROM " + RetSqlName("SZ2") + " WITH (NOLOCK) " + _cEnter 
	_cQry += " 	WHERE Z2_CLIENTE=A1_COD AND Z2_LOJA = A1_LOJA " + _cEnter 
	_cQry += " 	AND Z2_PRODUTO=B1_COD AND Z2_TOPICO = 'F' AND " + _cEnter 
	_cQry += " 	Z2_ANO  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and SZ2010.D_E_L_E_T_ = '') AS QTD_FCT, " + _cEnter 

	If MV_PAR16 ==1      //  1 Real  2= Dolar
		If MV_PAR17 == 1 //1-Net ou 2-Bruto 
			_cQry += "  (SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))*-1) ,0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Else
			_cQry += "  (SELECT ISNULL(SUM(ZR_TOTAL+ZR_VALIPI)*-1,0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Endif
	Else
		If MV_PAR17 == 1 //1-Net ou 2-Bruto 	   
			_cQry += "  (SELECT ISNULL(SUM((((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))/ZR_TXMOEDA)*-1),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		Else
			_cQry += "  (SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)/ZR_TXMOEDA)*-1),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter  
		Endif
	Endif


	_cQry += " 	WHERE " + _cEnter 
	_cQry += " 	ZR_CODPROD=A7_PRODUTO AND " + _cEnter 
	_cQry += " 	ZR_COD=A7_CLIENTE AND " + _cEnter 
	_cQry += " 	ZR_LJCLIFO=A7_LOJA AND " + _cEnter 
	_cQry += " 	ZR_TPOPER = 'D' AND " + _cEnter 
	_cQry += " 	MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND " + _cEnter 
	_cQry += " 	YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+")AS VLR_DEV,  " + _cEnter 

	_cQry += "  (SELECT ISNULL(SUM((ZR_QUANT)*-1),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
	_cQry += " 	WHERE" + _cEnter 
	_cQry += " 	ZR_CODPROD=A7_PRODUTO AND " + _cEnter 
	_cQry += " 	ZR_COD=A7_CLIENTE AND " + _cEnter 
	_cQry += " 	ZR_LJCLIFO=A7_LOJA AND " + _cEnter 
	_cQry += " 	ZR_TPOPER = 'D' AND " + _cEnter 
	_cQry += " 	MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND " + _cEnter 
	_cQry += " 	YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+")AS QTD_DEV,  " + _cEnter 


	_cQry += "  ((SELECT ISNULL(SUM(C6_QTDVEN),0) FROM  " + RetSqlName("SC6") + " C6 WITH (NOLOCK) " + _cEnter 
	_cQry += " 		INNER JOIN SC5010 ON " + _cEnter 
	_cQry += " 		C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
	_cQry += " 		C6_LOJA = C5_LOJACLI AND C6_PRODUTO=A7_PRODUTO AND " + _cEnter 
	_cQry += " 		C6_CLI=A7_CLIENTE AND C6_LOJA=A7_LOJA and C5_EMISSAO ='' AND" + _cEnter 
	_cQry += " 		MONTH(C5_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" "+ _cEnter
	_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
	_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
	_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
	_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
	_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter
	_cQry += " ) " + _cEnter     
	_cQry += " 		 + "
	_cQry += " 	(SELECT ISNULL(SUM(ZR_QUANT),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
	_cQry += " 		WHERE ZR_CODPROD=A7_PRODUTO AND  ZR_COD=A7_CLIENTE AND  " + _cEnter 
	_cQry += " 		ZR_LJCLIFO=A7_LOJA AND  ZR_TPOPER = 'V' AND " + _cEnter 
	_cQry += " 		MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND  " + _cEnter 
	_cQry += " 		YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )) " + _cEnter 
	_cQry += " 		- " + _cEnter 
	_cQry += " 	(SELECT ISNULL(SUM(Z2_QTM"+Substr(cDtDe,5,2)+"),0)  FROM " + RetSqlName("SZ2") + " WITH (NOLOCK) " + _cEnter 
	_cQry += " 		WHERE Z2_CLIENTE=A1_COD AND Z2_LOJA = A1_LOJA AND " + _cEnter 
	_cQry += " 		Z2_PRODUTO=B1_COD AND Z2_TOPICO = 'F' AND " + _cEnter 
	_cQry += " 		Z2_ANO between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and SZ2010.D_E_L_E_T_ = '')   as DIFE  ,   " + _cEnter 

	IF MV_PAR17==2 // 2 - BRUTO, 1 - NET					  
		_cQry += " 	((SELECT ISNULL(SUM(C6_VALOR),0) FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) " + _cEnter 
		_cQry += " 		INNER JOIN " + RetSqlName("SC5") + " ON " + _cEnter 
		_cQry += " 		C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
		_cQry += " 		C6_LOJA = C5_LOJACLI AND C6_PRODUTO=A7_PRODUTO AND " + _cEnter 
		_cQry += " 		C6_CLI=A7_CLIENTE AND C6_LOJA=A7_LOJA AND " + _cEnter 
		_cQry += "  	MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
		_cQry += "  	YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" "+ _cEnter
		_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
		_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
		_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
		_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
		_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter		
		_cQry += " ) " + _cEnter  
		_cQry += " 		+ " + _cEnter 
		IF MV_PAR16 == 2
			_cQry += " 		(SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)/ZR_TXMOEDA)),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter     
		ELSE
			_cQry += " 		(SELECT ISNULL(SUM((ZR_TOTAL+ZR_VALIPI)),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		ENDIF
		_cQry += " 			WHERE " + _cEnter 
		_cQry += " 			ZR_CODPROD=A7_PRODUTO AND " + _cEnter 
		_cQry += " 			ZR_COD=A7_CLIENTE AND " + _cEnter 
		_cQry += " 			ZR_LJCLIFO=A7_LOJA AND " + _cEnter 
		_cQry += " 			ZR_TPOPER = 'V' AND " + _cEnter 
		_cQry += " 			MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND " + _cEnter 
		_cQry += " 			YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )) " + _cEnter 
		_cQry += " 		- " + _cEnter 
		_cQry += " 		((SELECT ISNULL(SUM(Z2_QTM"+Substr(cDtDe,5,2)+"),0)  FROM " + RetSqlName("SZ2") + "  WITH (NOLOCK) " + _cEnter 
		_cQry += " 			WHERE Z2_CLIENTE=A1_COD AND Z2_LOJA = A1_LOJA AND " + _cEnter 
		_cQry += " 			Z2_PRODUTO=B1_COD AND Z2_TOPICO = 'F' AND " + _cEnter 
		_cQry += " 			Z2_ANO  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and SZ2010.D_E_L_E_T_ = '') " + _cEnter 
		_cQry += " 		* " + _cEnter 

		_cQry += " 		isnull((SELECT 

		IF MV_PAR16 == 2
			_cQry += " 			(case when DA1_MOEDA = 1 then  ISNULL(SUM((DA1_PRCVEN )/"+cValtoChar(_nCotDmd)+"),0)  " + _cEnter
			_cQry += " 	        when DA1_MOEDA = 4 then  ISNULL(SUM((DA1_PRCVEN )/"+cValtoChar(_nCotEmd)+"),0)  " + _cEnter  
			_cQry += " 			else ISNULL(SUM((DA1_PRCVEN) ),0)   end) " + _cEnter      
		ELSE
			_cQry += " 			(case when DA1_MOEDA = 1 then  ISNULL(SUM(DA1_PRCVEN ),0)  " + _cEnter 
			_cQry += " 			else ISNULL(SUM((DA1_PRCVEN *"+cValtoChar(_nCotDmd)+") ),0)   end) " + _cEnter  
		ENDIF

		_cQry += " 			FROM " + RetSqlName("DA1") + "  WITH (NOLOCK)    " + _cEnter 
		_cQry += " 			WHERE  DA1_CODTAB = A1_TABELA   and  " + _cEnter 
		_cQry += " 			DA1_CODPRO=B1_COD and  " + _cEnter 
		_cQry += " 			DA1_DATVIG < '"+DTOS(dDatabase)+"'  and " + _cEnter 
		_cQry += " 			D_E_L_E_T_ = '' group by DA1_MOEDA),0))    as DIFF " + _cEnter   


	ELSE // NET		
		_cQry += " 	((SELECT ISNULL(SUM(C6_QTDVEN * DA1.DA1_PRNET),0) FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) " + _cEnter 
		_cQry += "		INNER JOIN " + RetSqlName("DA1") + " DA1 ON DA1_CODTAB = A1_TABELA AND C6.C6_PRODUTO = DA1_CODPRO AND DA1.D_E_L_E_T_<> '*'" + _cEnter 
		_cQry += " 		INNER JOIN " + RetSqlName("SC5") + " ON " + _cEnter 
		_cQry += " 		C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE AND " + _cEnter 
		_cQry += " 		C6_LOJA = C5_LOJACLI AND C6_PRODUTO=A7_PRODUTO AND " + _cEnter 
		_cQry += " 		C6_CLI=A7_CLIENTE AND C6_LOJA=A7_LOJA AND " + _cEnter 
		_cQry += "  	MONTH(C5_FECENT) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" and " + _cEnter 
		_cQry += "  	YEAR(C5_FECENT)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" "
		_cQry += "  INNER JOIN "+RetSqlName("SF4")+" SF4 "+ _cEnter
		_cQry += " 	  ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+ _cEnter
		_cQry += " 	  AND SF4.F4_CODIGO = C6.C6_TES "+ _cEnter
		_cQry += " 	  AND SF4.F4_DUPLIC = 'S' "+ _cEnter
		_cQry += " 	  AND SF4.D_E_L_E_T_ = ' ' "+ _cEnter			
		_cQry += " ) " + _cEnter 
		_cQry += " 		+ " + _cEnter 
		IF MV_PAR16 == 2
			_cQry += " 		(SELECT ISNULL(SUM(((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM))/ZR_TXMOEDA),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter     
		ELSE
			_cQry += " 		(SELECT ISNULL(SUM((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM)),0) FROM " + RetSqlName("SZR") + " ZR WITH (NOLOCK) " + _cEnter 
		ENDIF
		_cQry += " 			WHERE " + _cEnter 
		_cQry += " 			ZR_CODPROD=A7_PRODUTO AND " + _cEnter 
		_cQry += " 			ZR_COD=A7_CLIENTE AND " + _cEnter 
		_cQry += " 			ZR_LJCLIFO=A7_LOJA AND " + _cEnter 
		_cQry += " 			ZR_TPOPER = 'V' AND " + _cEnter 
		_cQry += " 			MONTH(ZR_EMISSAO) between "+Substr(cDtDe,5,2)+" and "+Substr(cDtAte,5,2)+" AND " + _cEnter 
		_cQry += " 			YEAR(ZR_EMISSAO)  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" )) " + _cEnter 
		_cQry += " 		- " + _cEnter 
		_cQry += " 		((SELECT ISNULL(SUM(Z2_QTM"+Substr(cDtDe,5,2)+"),0)  FROM " + RetSqlName("SZ2") + "  WITH (NOLOCK) " + _cEnter 
		_cQry += " 			WHERE Z2_CLIENTE=A1_COD AND Z2_LOJA = A1_LOJA AND " + _cEnter 
		_cQry += " 			Z2_PRODUTO=B1_COD AND Z2_TOPICO = 'F' AND " + _cEnter 
		_cQry += " 			Z2_ANO  between "+Substr(cDtDe,1,4)+" and "+Substr(cDtAte,1,4)+" and SZ2010.D_E_L_E_T_ = '') " + _cEnter 
		_cQry += " 		* " + _cEnter 

		_cQry += " 		isnull((SELECT 

		IF MV_PAR16 == 2
			_cQry += " 			(case when DA1_MOEDA = 1 then  ISNULL(SUM((DA1_PRNET )/"+cValtoChar(_nCotDmd)+"),0)  " + _cEnter
			_cQry += " 	        when DA1_MOEDA = 4 then  ISNULL(SUM((DA1_PRNET )/"+cValtoChar(_nCotEmd)+"),0)  " + _cEnter  
			_cQry += " 			else ISNULL(SUM((DA1_PRNET) ),0)   end) " + _cEnter      
		ELSE
			_cQry += " 			(case when DA1_MOEDA = 1 then  ISNULL(SUM(DA1_PRNET ),0)  " + _cEnter 
			_cQry += " 			else ISNULL(SUM((DA1_PRNET *"+cValtoChar(_nCotDmd)+") ),0)   end) " + _cEnter  
		ENDIF

		_cQry += " 			FROM " + RetSqlName("DA1") + "  WITH (NOLOCK)    " + _cEnter 
		_cQry += " 			WHERE  DA1_CODTAB = A1_TABELA   and  " + _cEnter 
		_cQry += " 			DA1_CODPRO=B1_COD and  " + _cEnter 
		_cQry += " 			DA1_DATVIG < '"+DTOS(dDatabase)+"'  and " + _cEnter 
		_cQry += " 			D_E_L_E_T_ = '' group by DA1_MOEDA),0))    as DIFF " + _cEnter 



	ENDIF		

	_cQry += "   FROM  " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) " + _cEnter 
	_cQry += "   LEFT JOIN  " + RetSqlName("SA7") + " SA7 WITH (NOLOCK) " + _cEnter 
	_cQry += "   ON B1_COD = A7_PRODUTO " + _cEnter 
	_cQry += "   AND SB1.D_E_L_E_T_ = '' " + _cEnter 
	_cQry += "   AND  SA7.D_E_L_E_T_ = '' " + _cEnter 
	_cQry += "   AND A7_XSEGMEN  BETWEEN '"+MV_PAR07+"' and '"+MV_PAR08+"' " + _cEnter 
	_cQry += "   AND A7_XSEGMEN  BETWEEN RTRIM('"+MV_PAR11+"00"+"') and RTRIM('"+MV_PAR12+"99"+"') " + _cEnter

	_cQry += "   INNER JOIN   " + RetSqlName("SA1") + " SA1 WITH (NOLOCK) " + _cEnter 
	_cQry += "   ON A1_COD = A7_CLIENTE AND A1_LOJA = A7_LOJA  AND SA1.D_E_L_E_T_ = '' and SA1.A1_VEND Between '"+MV_PAR09+"' and '"+MV_PAR10+"' and SA1.A1_COD  Between '"+MV_PAR03+"' and '"+MV_PAR04+"' ) AUX " + _cEnter 

	_cQry += "   WHERE (AUX.QTD_FTA + AUX.VLR_FTA + AUX.QTD_FTO + AUX.VLR_FTO + AUX.QTD_FCT)>0 " + _cEnter 
	
	memowrite("TESTEE.txt",_cQry)
	//Cria tabela temporária com base no resultado da query 7
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)


	dbSelectArea(_cAliasTmp)


	if MV_PAR17 == 1
		_cRnet:= " Preço Net"    
	else 
		_cRnet:= " Bruto"  
	endif  

	IF MV_PAR16 == 1
		_cMoed:= "Moeda: Real "
	Else
		_cMoed:= "Moeda: Dolar "
	endif

	//Sheet1 - Parâmetros
	oExcel:AddworkSheet("ACOMP VENDAS " +_cMoed + _cRnet)
	oExcel:AddTable("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet) 
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Gerente",1,1)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Cliente",1,1)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Produto",1,1)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Forecast Valor",1,2) 
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"A Faturar Valor",1,2)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Faturado Valor",1,2)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Diferença Valor",1,2)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Devolucao Valor",1,2)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Forecast Quantidade ",1,2)  
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"A Faturar Quantidade",1,2)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Faturado Quantidade",1,2)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Diferença Quantidade",1,2)
	oExcel:AddColumn("ACOMP VENDAS " +_cMoed + _cRnet,"ACOMP VENDAS " +_cMoed + _cRnet,"Devolucao Quantidade",1,2)



	dbSelectArea(_cAliasTmp)
	DbGotop()

	While !EOF()	

		_cCodCli  := ALLTRIM((_cAliasTmp)->CODCLI)
		_cLojaCli := ALLTRIM((_cAliasTmp)->LOJA)
		_cCodProd := PADR((_cAliasTmp)->CODPROD,TAMSX3("Z2_PRODUTO")[01])
		_cAno     := Substr(Dtos(mv_par01),1,4)
		_nQTD_FCT := (_cAliasTmp)->QTD_FCT   
		_nQTD_DEV := (_cAliasTmp)->QTD_DEV

		if MV_PAR17 == 1
			_cNet:= "1"    
		else 
			_cNet:= "2"  
		endif

		IF MV_PAR16 == 1
			_nVLR_FCT := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		ELSE  
			_nVLR_FCT := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		ENDIF

		_VLR_FCT  := _nVLR_FCT * _nQTD_FCT  

		nMoed := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_MOEDA") 
		ntaxa := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_TXREF")
		If empty(nTaxa)
			nDia := 0
			While ntaxa == 0
				nDia++
				ntaxa := Posicione("SM2",1,DtoS(DaySub(Date(),nDia)),"M2_MOEDA2")
			EndDo
			// ntaxa := POsicione("SC5",1,xFilial("SC5")+ (_cAliasTmp)->NUM ,"C5_TXMOEDA")
		EndIf


		AAdd( aValores, {POSICIONE("SA3",1,xFilial("SA3")+ (_cAliasTmp)->GERENTE,"A3_NREDUZ"),;
		SUBSTR((_cAliasTmp)->CLIENTE,1,30),;
		SUBSTR((_cAliasTmp)->PRODUTO,1,30),;
		Transform(ROUND(_VLR_FCT,0),"@E 999,999,999"),;
		IIF(MV_PAR16 == 1 ,Transform(ROUND(Iif(nMoed== 2 ,(_cAliasTmp)->VLR_FTA* Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA),0),"@E 999,999,999"),Transform(ROUND(Iif(nMoed== 1 ,(_cAliasTmp)->VLR_FTA / Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA),0),"@E 999,999,999")),;
		Transform(ROUND((_cAliasTmp)->VLR_FTO ,0) ,"@E 999,999,999"),;
		IIF(MV_PAR16 == 1 ,ROUND(((_cAliasTmp)->VLR_FTO + Iif(nMoed== 2 ,(_cAliasTmp)->VLR_FTA* Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA) - _VLR_FCT),0),ROUND(((_cAliasTmp)->VLR_FTO + Iif(nMoed== 1 ,(_cAliasTmp)->VLR_FTA /Iif( empty(ntaxa),_nCotDmd,ntaxa),(_cAliasTmp)->VLR_FTA) - _VLR_FCT),0)),;
		Transform(ROUND((_cAliasTmp)->VLR_DEV,0),"@E 999,999,999"),;
		Transform(ROUND(_nQTD_FCT,0),"@E 999,999,999"),;
		Transform(ROUND((_cAliasTmp)->QTD_FTA,0),"@E 999,999,999"),;
		Transform(ROUND((_cAliasTmp)->QTD_FTO,0),"@E 999,999,999"),;
		Transform(ROUND(((_cAliasTmp)->QTD_FTO + (_cAliasTmp)->QTD_FTA - _nQTD_FCT),0),"@E 999,999,999"),;
		Transform(ROUND((_cAliasTmp)->QTD_DEV,0),"@E 999,999,999")})



		DbSkip()

	EndDo	


	If MV_PAR15 == 2 
		aSort(aValores,,,{|x,y| x[2] < y[2]})
	elseIf MV_PAR15 == 3     
		aSort(aValores,,,{|x,y| x[3] < y[3]})
	elseIf MV_PAR15 == 5  
		aSort(aValores,,,{|x,y| x[7] < y[7]})
	elseIf MV_PAR15 == 4
		aSort(aValores,,,{|x,y| x[7] < y[7]})
	Endif 

	For nK := 1 to len(aValores)

		oExcel:AddRow("ACOMP VENDAS " +_cMoed + _cRnet, "ACOMP VENDAS " +_cMoed + _cRnet,{aValores[nK][1],;
		aValores[nK][2],;
		aValores[nK][3],;
		aValores[nK][4],;
		aValores[nK][5],;
		aValores[nK][6],;
		aValores[nK][7],;
		aValores[nK][8],;
		aValores[nK][9],;
		aValores[nK][10],;
		aValores[nK][11],;
		aValores[nK][12],;
		aValores[nK][13]}) 

	Next

	oExcel:Activate()
	oExcel:GetXMLFile(cNomeArq)

	__CopyFile(cNomeArq,_cFolder+cNomeArq)

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(_cFolder+cNomeArq) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf

Return()

