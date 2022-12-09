#Include "TOPCONN.CH"                                                  
#Include "FINR350.CH"
#Include "PROTHEUS.CH"
#Include "fwcommand.CH"
#Include "RWMAKE.CH"   


#Define I_CORRECAO_MONETARIA     1
#Define I_DESCONTO               2
#Define I_JUROS                  3
#Define I_MULTA                  4
#Define I_VALOR_RECEBIDO         5
#Define I_VALOR_PAGO             6
#Define I_RECEB_ANT              7
#Define I_PAGAM_ANT              8
#Define I_MOTBX                  9
#Define I_RECPAG_REAIS         	10
#Define I_LEI10925              12

Static lFWCodFil := FindFunction("FWCodFil")

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinR350  ³ Autor ³ Adrianne Furtado      ³ Data ³ 27/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Fornecedores 					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR530(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LS_FR350()
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())

/*_cQuery := "SELECT MAX(R_E_C_N_O_) R_E_C_N_O_ FROM SIGAMAT (NOLOCK)"
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SM0', .F., .T.)

If SM0->(LastRec()) <> _SM0->R_E_C_N_O_
	DbCloseArea()
	DbSelectArea('SM0')
	_nRecno := Recno()
	DbGoTop()
	TcSqlExec('DROP TABLE SIGAMAT')
	copy to SIGAMAT VIA 'TOPCONN'
	DbGoto(_nRecno)
EndIf
DbCloseArea()
_cFilAnt := cFilAnt
  */
RestArea(aAreaSX1)
RestArea(aAreaAnt)

Private cPerg  :="RFIN350R  "    
CriaSx1()
If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.) //  // FIN350R350
	EndIf
	oReport:PrintDialog()
Else
	Return FinR350R3() // Executa versão anterior do fonte
Endif
cFilAnt := _cFilAnt                               

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Adrianne Furtado      ³ Data ³27.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oFornecedores
Local oTitsForn
Local oCell

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("FINR350",STR0005,"RFIN350R  ", {|oReport| ReportPrint(oReport)},STR0001+" "+STR0002) //"Movimento Financeiro Diario"##"Este programa ir  emitir o resumo da Movimenta‡„o"##"Bancaria de um determinado dia."
oReport:SetTotalInLine(.F.)
oReport:SetLandScape()

oFornecedores := TRSection():New(oReport,"Ordem",{"SA2"},{"Por Codigo","Por Nome" })   //Por Codigo - Por Nome
TRCell():New(oFornecedores,"" 	,"SA2",""	)
TRCell():New(oFornecedores,"A2_COD" 	,"SA2",STR0009	)
TRCell():New(oFornecedores,"A2_NOME"	,"SA2",			)		//Substr(A1_NOME,1,40)
TRCell():New(oFornecedores,"A2_NREDUZ"	,"SA2",			)

oTitsForn := TRSection():New(oFornecedores,STR0017,{"SE2","SED"})	//"Titulos
TRCell():New(oTitsForn,"M0_CODIGO" 		,"SE2","Empresa" ,,	) 		//empresa
TRCell():New(oTitsForn,"E2_PREFIXO" 	,"SE2",STR0018,/*Picture*/,20 + SE2->(LEN(E2_PREFIXO)+LEN('-')+LEN(E2_NUM))/*Tamanho*/,/*lPixel*/,{|| E2_PREFIXO+'-'+E2_NUM }) //"Prf Numero"
TRCell():New(oTitsForn,"E2_PARCELA"		,"SE2",STR0019 ,,	) 		//"PC"
TRCell():New(oTitsForn,"E2_TIPO"    	,"SE2",STR0020 ,,	) 		//"Tip"
TRCell():New(oTitsForn,STR0021      	, 	  ,STR0021	,,17) //"Valor Original"
TRCell():New(oTitsForn,STR0022  		,    ,STR0022   ,,10) //"Emissao"
TRCell():New(oTitsForn,'Recebimento'	,    ,'Recebimento'   ,,10) //recebimento
TRCell():New(oTitsForn,'Digitação'		,    ,'Digitação'   ,,10) //Digitacao
TRCell():New(oTitsForn,'Calendário'		,    ,'Calendário'   ,,10) //calendário
TRCell():New(oTitsForn,STR0023   		,"SE2",STR0023	,,09) //"Vencimento"
TRCell():New(oTitsForn,STR0024			,	  ,STR0024	,,09)	//"Baixa"
TRCell():New(oTitsForn,STR0025    		,	  ,STR0025	,,13) //"Lei 10925"
TRCell():New(oTitsForn,STR0026    		,	  ,STR0026  ,,13) //"Descontos"
TRCell():New(oTitsForn,STR0027      	,	  ,STR0027  ,,13)	//"Abatimentos"
TRCell():New(oTitsForn,STR0028			,	  ,STR0028	,,13)	//"Juros"
TRCell():New(oTitsForn,STR0029			,	  ,STR0029 	,,13)	//"Multa"
TRCell():New(oTitsForn,STR0030      	,	  ,STR0030  ,,13) //"Corr. Monet"
TRCell():New(oTitsForn,STR0031     		,	  ,STR0031  ,,17)	//"Valor Pago"
TRCell():New(oTitsForn,STR0032        	,	  ,STR0032  ,,13)	//"Pagto.Antecip"
TRCell():New(oTitsForn,STR0033      	,	  ,STR0033  ,,17)	//"Saldo Atual"
TRCell():New(oTitsForn,STR0034 			,	  ,STR0034	,,) //"Motivo"

oTitsForn:Cell('Empresa'):SetHeaderAlign("LEFT")
oTitsForn:Cell(STR0021):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0022):SetHeaderAlign("CENTER")
oTitsForn:Cell('Recebimento'):SetHeaderAlign("CENTER")
oTitsForn:Cell('Digitação'):SetHeaderAlign("CENTER")
oTitsForn:Cell('Calendário'):SetHeaderAlign("CENTER")
oTitsForn:Cell(STR0023):SetHeaderAlign("CENTER")
oTitsForn:Cell(STR0024):SetHeaderAlign("CENTER")
oTitsForn:Cell(STR0025):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0026):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0027):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0028):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0029):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0030):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0031):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0032):SetHeaderAlign("RIGHT")
oTitsForn:Cell(STR0033):SetHeaderAlign("RIGHT")

oTitsForn:Cell('Empresa'):SetAlign("LEFT")
oTitsForn:Cell(STR0021):SetAlign("RIGHT")
oTitsForn:Cell(STR0022):SetAlign("CENTER")
oTitsForn:Cell('Recebimento'):SetAlign("CENTER")
oTitsForn:Cell('Digitação'):SetAlign("CENTER")
oTitsForn:Cell('Calendário'):SetAlign("CENTER")
oTitsForn:Cell(STR0023):SetAlign("CENTER")
oTitsForn:Cell(STR0024):SetAlign("CENTER")
oTitsForn:Cell(STR0025):SetAlign("RIGHT")
oTitsForn:Cell(STR0026):SetAlign("RIGHT")
oTitsForn:Cell(STR0027):SetAlign("RIGHT")
oTitsForn:Cell(STR0028):SetAlign("RIGHT")
oTitsForn:Cell(STR0029):SetAlign("RIGHT")
oTitsForn:Cell(STR0030):SetAlign("RIGHT")
oTitsForn:Cell(STR0031):SetAlign("RIGHT")
oTitsForn:Cell(STR0032):SetAlign("RIGHT")
oTitsForn:Cell(STR0033):SetAlign("RIGHT")

oTotaisForn := TRSection():New(oTitsForn,STR0038,{"SE2","SED"})	//"Total Fornecedor
TRCell():New(oTotaisForn,"Empresa"      	, 	  ,"Empresa"	,,) //"PC"
TRCell():New(oTotaisForn,"TXTTOTAL"		,    ,STR0010	,,20 + TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]) //
TRCell():New(oTotaisForn,"PC"      	, 	  ,"PC"	,,) //"PC"
TRCell():New(oTotaisForn,"TIP"      	, 	  ,"TIP"	,,) //"tip"
TRCell():New(oTotaisForn,STR0021      	, 	  ,STR0021	,,17) //"Valor Original"
TRCell():New(oTotaisForn,STR0022  		,     ,STR0022  ,,10) //"Emissao"
TRCell():New(oTotaisForn,'Recebimento'  		,     ,'Recebimento'  ,,10) //"Emissao"
TRCell():New(oTotaisForn,'Digitação'  		,     ,'Digitação'  ,,10) //"Emissao"
TRCell():New(oTotaisForn,'Calendário'  		,     ,'Calendário'  ,,10) //"Emissao"
TRCell():New(oTotaisForn,STR0023    	,"SE2",STR0023	,,09) //"Vencimento"
TRCell():New(oTotaisForn,STR0024		,	  ,STR0024	,,09)	//"Baixa"
TRCell():New(oTotaisForn,STR0025    	,	  ,STR0025	,,13) //"Lei 10925"
TRCell():New(oTotaisForn,STR0026    	,	  ,STR0026  ,,13) //"Descontos"
TRCell():New(oTotaisForn,STR0027      	,	  ,STR0027  ,,13)	//"Abatimentos"
TRCell():New(oTotaisForn,STR0028		,	  ,STR0028	,,13)	//"Juros"
TRCell():New(oTotaisForn,STR0029		,	  ,STR0029 	,,13)	//"Multa"
TRCell():New(oTotaisForn,STR0030      	,	  ,STR0030  ,,13) //"Corr. Monet"
TRCell():New(oTotaisForn,STR0031     	,	  ,STR0031  ,,17)	//"Valor Pago"
TRCell():New(oTotaisForn,STR0032      	,	  ,STR0032  ,,13)	//"Pagto.Antecip"
TRCell():New(oTotaisForn,STR0033      	,	  ,STR0033  ,,17)	//"Saldo Atual"
TRCell():New(oTotaisForn,STR0034 		,	  ,STR0034	,,)     //"Motivo"
oTotaisForn:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

oTotaisForn:Cell(STR0022):Hide()
oTotaisForn:Cell(STR0023):Hide()
oTotaisForn:Cell(STR0024):Hide()

oTotaisFilial := TRSection():New(oReport,STR0037)	//"Titulos
TRCell():New(oTotaisFilial,"Empresa"      	, 	  ,"Empresa"	,,) //"PC"
TRCell():New(oTotaisFilial,"TXTTOTAL"	,    , STR0036	,,20 + TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]) //
TRCell():New(oTotaisFilial,"PC"      	, 	  ,"PC"	,,) //"PC"
TRCell():New(oTotaisFilial,"TIP"      	, 	  ,"TIP"	,,) //"tip"
TRCell():New(oTotaisFilial,STR0021    	, 	  ,STR0021	,,17) //"Valor Original"
TRCell():New(oTotaisFilial,STR0022  	,     ,STR0022  ,,10) //"Emissao"
TRCell():New(oTotaisFilial,'Recebimento'  		,     ,'Recebimento'  ,,10) //"Emissao"
TRCell():New(oTotaisFilial,'Digitação'  		,     ,'Digitação'  ,,10) //"Emissao"
TRCell():New(oTotaisFilial,'Calendário'  		,     ,'Calendário'  ,,10) //"Emissao"
TRCell():New(oTotaisFilial,STR0023     ,"SE2",STR0023	,,09) //"Vencimento"
TRCell():New(oTotaisFilial,STR0024		,	  ,STR0024	,,09)	//"Baixa"
TRCell():New(oTotaisFilial,STR0025    	,	  ,STR0025	,,13) //"Lei 10925"
TRCell():New(oTotaisFilial,STR0026    	,	  ,STR0026  ,,13) //"Descontos"
TRCell():New(oTotaisFilial,STR0027    	,	  ,STR0027  ,,13)	//"Abatimentos"
TRCell():New(oTotaisFilial,STR0028		,	  ,STR0028	,,13)	//"Juros"
TRCell():New(oTotaisFilial,STR0029		,	  ,STR0029 	,,13)	//"Multa"
TRCell():New(oTotaisFilial,STR0030    	,	  ,STR0030  ,,13) //"Corr. Monet"
TRCell():New(oTotaisFilial,STR0031    	,	  ,STR0031  ,,17)	//"Valor Pago"
TRCell():New(oTotaisFilial,STR0032    	,	  ,STR0032  ,,13)	//"Pagto.Antecip"
TRCell():New(oTotaisFilial,STR0033    	,	  ,STR0033  ,,17)	//"Saldo Atual"
TRCell():New(oTotaisFilial,STR0034 		,	  ,STR0034	,,)     //"Motivo"
oTotaisFilial:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

oTotaisFilial:Cell(STR0022):Hide()
oTotaisFilial:Cell(STR0023):Hide()
oTotaisFilial:Cell(STR0024):Hide()

//Totalizador Geral
oTotalGeral := TRSection():New(oTitsForn,STR0038,{"SE2","SED"})	//"Total Geral
TRCell():New(oTotalGeral,"Empresa"      	, 	  ,"Empresa"	,,) //"PC"
TRCell():New(oTotalGeral,"TXTTOTAL"		,    ,STR0011	,,20 + TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]) //
TRCell():New(oTotalGeral,"PC"      	, 	  ,"PC"	,,) //"PC"
TRCell():New(oTotalGeral,"TIP"      	, 	  ,"TIP"	,,) //"PC"
TRCell():New(oTotalGeral,STR0021      	, 	  ,STR0021	,,) //"Valor Original"
TRCell():New(oTotalGeral,STR0022  		,     ,STR0022  ,,) //"Emissao"
TRCell():New(oTotalGeral,'Recebimento'  		,     ,'Recebimento'  ,,10) //"Emissao"
TRCell():New(oTotalGeral,'Digitação'  		,     ,'Digitação'  ,,10) //"Emissao"
TRCell():New(oTotalGeral,'Calendário'  		,     ,'Calendário'  ,,10) //"Emissao"
TRCell():New(oTotalGeral,STR0023    	,"SE2",STR0023	,,09) //"Vencimento"
TRCell():New(oTotalGeral,STR0024		,	  ,STR0024	,,09)	//"Baixa"
TRCell():New(oTotalGeral,STR0025    	,	  ,STR0025	,,13) //"Lei 10925"
TRCell():New(oTotalGeral,STR0026    	,	  ,STR0026  ,,13) //"Descontos"
TRCell():New(oTotalGeral,STR0027      	,	  ,STR0027  ,,13)	//"Abatimentos"
TRCell():New(oTotalGeral,STR0028		,	  ,STR0028	,,13)	//"Juros"
TRCell():New(oTotalGeral,STR0029		,	  ,STR0029 	,,13)	//"Multa"
TRCell():New(oTotalGeral,STR0030      	,	  ,STR0030  ,,13) //"Corr. Monet"
TRCell():New(oTotalGeral,STR0031     	,	  ,STR0031  ,,17)	//"Valor Pago"
TRCell():New(oTotalGeral,STR0032      	,	  ,STR0032  ,,13)	//"Pagto.Antecip"
TRCell():New(oTotalGeral,STR0033      	,	  ,STR0033  ,,17)	//"Saldo Atual"
TRCell():New(oTotalGeral,STR0034 		,	  ,STR0034	,,)     //"Motivo"
oTotalGeral:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

oTotalGeral:Cell(STR0022):Hide()
oTotalGeral:Cell(STR0023):Hide()
oTotalGeral:Cell(STR0024):Hide()

oFornecedores:SetColSpace(0)
oTitsForn:SetColSpace(0)
oTotaisForn:SetColSpace(0)
oTotaisFilial:SetColSpace(0)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Adrianne Furtado      ³ Data ³27.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)
Local oFornecedores	:= oReport:Section(1)
Local oTitsForn		:= oReport:Section(1):Section(1)
Local oTotaisForn	:= oReport:Section(1):Section(1):Section(1)
Local oTotalGeral	:= oReport:Section(1):Section(1):Section(1)
Local oTotaisFilial	:= oReport:Section(2)
Local cAlias
Local cAliasSE2		:= "SE2"
Local cAliasSA2 	:= "SA2"
Local cFornecedor
Local cSql0, cSql1, cSql2, cSql3 := ""
Local nDecs, nMoeda
Local aValor 		:= {}
Local nTotAbat
Local bPosTit		:= { || }		// Posiciona a impressao dos titulos do fornecedor
Local bWhile		:= { || }		// Condicao para impressao dos titulos do fornecedor
Local cFiltSED		:=	oFornecedores:GetAdvplExp('SED')
Local cFiltSE2		:=	oFornecedores:GetAdvplExp('SE2')
Local cFiltSA2		:=	oFornecedores:GetAdvplExp('SA2')
Local lInitForn	:=	.T.
Local	lPrintForn	:=	.T.
Local cFilDe,cFilAte, cFilDeSA2,cFilAteSA2
Local cFiliAnt:= cFiliAtu := ""
Local cFornAnt:= cFornAtu := ""
Local nTotFil0:= nTotForn0:= nTotGeral0:=0
Local nTotFil1:= nTotForn1:= nTotGeral1:=0
Local nTotFil2:= nTotForn2:= nTotGeral2:=0
Local nTotFil3:= nTotForn3:= nTotGeral3:=0
Local nTotFil4:= nTotForn4:= nTotGeral4:=0
Local nTotFil5:= nTotForn5:= nTotGeral5:=0
Local nTotFil6:= nTotForn6:= nTotGeral6:=0
Local nTotFil7:= nTotForn7:= nTotGeral7:=0
Local nTotFil8:= nTotForn8:= nTotGeral8:=0
Local nTotFil9:= nTotForn9:= nTotGeral9:=0
Local lProcSQL := .T.
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"
Local nValorOrig := 0
Local lPaBruto	:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local lImpTit	 := .T.		// Indica se imprime o titulo a pagar (SE2)
Local nInc		:= 0
Local aSM0		:= {}

//******************************************
// Utilizados pelo ponto de entrada F350MFIL
//******************************************
Local lMovFil	:= .T. //Default: Imprime todas as filiais
Local lImpMFil 	:= .T.
Local nReg
//******************************************

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())

		If	( !Pergunte("RFIN350R  ",.T.) )
			Return
		EndIf

aSM0	:= AdmAbreSM0()
nDecs 	:=Msdecimais(mv_par10)
nMoeda 	:= mv_par10

oReport:SetMeter(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par19 == 2
	cFilDe  := xFilial("SE2")
	If !Empty( xFilial("SE2") )
		cFilAte := xFilial("SE2")
	Else
		cFilAte := Replicate( "Z", TamSX3("E2_FILIAL")[1] )
	EndIf
Else
	If Empty(xFilial("SE2"))
		cFilDe	:= ""
		cFilAte	:= Replicate( "Z", TamSX3("E2_FILIAL")[1] )
	Else
		cFilDe 	:= mv_par20	// Todas as filiais
		cFilAte	:= mv_par21
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par19 == 2 .or. xFilial("SA2") == ""
	cFilDeSA2  := xFilial("SA2")
	cFilAteSA2 := xFilial("SA2")
Else
	cFilDeSA2 := mv_par20	// Todas as filiais
	cFilAteSA2:= mv_par21
Endif

oFornecedores:Init()
oTitsForn:Init()

If ExistBlock("F350MFIL")
	lMovFil := ExecBlock("F350MFIL",.F.,.F.)
Endif

For nInc := 1 To Len( aSM0 )
	
	If !Empty(cFilAte) .AND. aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte)
		cFilAnt := aSM0[nInc][2]
		
		nReg := 0 //Zera a contagem de registros impressos.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Filtragem do relatório                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lProcSQL
			lProcSQL := .F.
			cAlias := GetNextAlias()
		EndIf
		
		bPosTit 	:= { || cFornecedor := (cAliasSA2)->( A2_COD + A2_LOJA ) }
		bCondTit	:= { || (cAliasSE2)->( E2_FORNECE + E2_LOJA ) == cFornecedor }
		
		If mv_par19 == 1 .and. !Empty(xFilial("SA2"))
			cSql0 := "A2_FILIAL = '"+ aSM0[nInc][2] +"' AND "
		Else
			cSql0 := "A2_FILIAL = '"+xFilial("SA2")+"' AND "
		Endif
		If mv_par19 == 1 .and. !Empty(xFilial("SE2"))
			cSql0 += "E2_FILIAL = '"+ aSM0[nInc][2] + "' AND"
		Else
			cSql0 += "E2_FILIAL = '"+xFilial("SE2")+"' AND"
		Endif
		cSql0 := "%"+cSql0+"%"
		
		cSql1 := iif(mv_par18 == 1,"E2_EMISSAO","E2_EMIS1") + " between '" + DTOS(mv_par05)+ "' AND '" + DTOS(mv_par06) + "' AND E2_TIPO NOT IN "+FormatIn(MVABATIM,"|")+" AND "
		cSql1 := "%"+cSql1+"%"
		
		cSql2 := iif(mv_par18 == 1,"E2_EMISSAO","E2_EMIS1") + "<= '"+DTOS(dDataBase)+"' AND "
		If mv_par09 == 2
			cSql2 += "E2_TIPO <> '"+MVPROVIS+"' AND "
		EndIf
		If mv_par16 == 2
			cSql2 += "E2_TIPO <> 'PA ' AND "
		EndIf
		If mv_par12 == 2
			cSql2 += "E2_FATURA IN('"+Space(Len(SE2->E2_FATURA))+"','NOTFAT') AND "
		Endif
		If mv_par13 == 2
			cSQL2 += " E2_MOEDA = " + STR(mv_par10) +" AND "
		Endif
		cSql3 := "E2_FILIAL = '' AND "
		If mv_par22 == 2
			cSql3 := "E2_SALDO <> 0 AND "
		ElseIf mv_par22 == 1
			cSql3 := "E2_SALDO = 0 AND "
		EndIf
		
		cSql4 := "E2_FILIAL = '' AND "
		If !Empty(mv_par23) // Deseja imprimir apenas os tipos do parametro 30
			cSql4 := " E2_TIPO IN "+FormatIn(mv_par23,";")  + " AND "
		ElseIf !Empty(Mv_par24) // Deseja excluir os tipos do parametro 31
			cSql4 := " E2_TIPO NOT IN "+FormatIn(mv_par24,";")  + " AND "
		EndIf
		
		cSql2 := "%" + cSql2 + cSql3 + cSql4 + "%"
		
		If oFornecedores:GetOrder() == 1
			cOrder := "A2_FILIAL,E2_FILIAL,A2_COD,A2_NOME,FATURA, E2_FATURA DESC,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
			SA2->( dbSetOrder( 1 ) )
		Else
			cOrder := "A2_FILIAL,E2_FILIAL,A2_NOME,A2_COD,FATURA, E2_FATURA DESC,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
			SA2->( dbSetOrder( 2 ) )
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Transforma parametros Range em expressao SQL                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MakeSqlExpr(oReport:uParam)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query do relatório      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFornecedores:BeginQuery()
		_cFiltro := ''
		/*
		If !Empty(cFilterUser)
		cFilterUser := upper(cFilterUser)
		_cFiltro := ' AND ' + strtran(strtran(strtran(strtran(cFilterUser,'DTOS',''),'.AND.',' AND '),'"',"'"),"==","=")
		EndIf
		*/
		
		BeginSql Alias cAlias
			%noparser%
			
			SELECT  
			CASE WHEN E2_FATURA <> %Exp:''% THEN CASE WHEN E2_FATURA = %Exp:'NOTFAT'% THEN E2_NUM ELSE E2_FATURA END ELSE %Exp:''% END FATURA, 
			M0_CODIGO, A2_FILIAL,A2_COD,
			A2_NOME,A2_NREDUZ,A2_LOJA,SE2.* , F1_DTDIGIT, F1_RECBMTO, F1_DATACLA
			FROM %table:SA2% SA2 (NOLOCK),%table:SE2% SE2 (NOLOCK)
			
			LEFT JOIN %table:SF1% SF1 (NOLOCK)
			ON	(	F1_FILIAL 	= 	E2_MSFIL AND
			F1_DOC 	=	E2_NUM AND
			F1_PREFIXO = E2_PREFIXO AND
			F1_FORNECE = E2_FORNECE AND
			F1_LOJA = E2_LOJA AND
			SF1.%NotDel% )
			
			INNER JOIN SIGAMAT SM0 (NOLOCK)
			ON ( M0_CODIGO = %Exp:CEMPANT%
			AND M0_CODFIL = E2_MSFIL
			AND SM0.%NotDel% )
			
			LEFT OUTER JOIN %table:SED% SED (NOLOCK)
			ON	(	ED_FILIAL 	= 	%xFilial:SED% AND
			ED_CODIGO 	=	E2_NATUREZ AND
			SED.%NotDel% )
			
			WHERE %exp:cSql0%
			E2_FORNECE 	= A2_COD AND
			E2_LOJA 	= A2_LOJA AND
			E2_FORNECE 	between %Exp:mv_par01% AND %Exp:mv_par02% AND
			E2_LOJA 	between %Exp:mv_par03% AND %Exp:mv_par04% AND
			%exp:cSql1%
			E2_VENCREA 	between %Exp:DTOS(mv_par07)% AND %Exp:DTOS(mv_par08)% AND
			(E2_BAIXA 	between %Exp:DTOS(mv_par25)% AND %Exp:DTOS(mv_par26)% OR E2_BAIXA = %Exp:''%) AND
			%exp:cSql2%
			SE2.%notDel% AND
			SA2.%notDel%
			ORDER BY A2_FILIAL,E2_FILIAL,A2_COD,A2_NOME,FATURA, E2_FATURA DESC,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO

		EndSql              
		//ORDER BY A2_FILIAL,E2_FILIAL,A2_COD,A2_NOME,FATURA, E2_FATURA DESC,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO %exp:cOrder%
		
		  aLastQuery    := GetLastQuery()
          cLastQuery    := aLastQuery[2]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Metodo EndQuery ( Classe TRSection )                                    ³
		//³Prepara o relatório para executar o Embedded SQL.                       ³
		//³ExpA1 : Array com os parametros do tipo Range                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oFornecedores:EndQuery(/*Array com os parametros do tipo Range*/)
		
		oTitsForn:SetParentQuery()
		oTitsForn:SetParentFilter({|cParam| (cAlias)->(E2_FORNECE+E2_LOJA) == cParam}, { || (cAlias)->(A2_COD+A2_LOJA) })
		
		cAliasSE2	:= cAlias
		cAliasSA2 	:= cAlias
		
		(cAlias)->( dbGoTop() )
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicio da impressao do fluxo do relatório                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:SetTitle(STR0005 + " - " + GetMv("MV_MOEDA"+Str(nMoeda,1)))
		
		oReport:SetMeter((cAliasSE2)->(LastRec()))
		
		If mv_par15 == 1
			oFornecedores:Cell("A2_NREDUZ"):Disable()
		Else
			oFornecedores:Cell("A2_NOME"):Disable()
		EndIf
		
		oFornecedores:SetTotalText("")
		oFornecedores:SetHeaderSection(.F.)
		oFornecedores:SetTotalInLine(.T.)
		oTitsForn:SetTotalInLine(.T.)
		oTitsForn:SetHeaderPage(.T.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicionamento do SE5 neste ponto que servira para   ³
		//³pesquisa de descarte de registros geradores de       ³
		//³desdobramento                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE5")
		SE5->(dbSetOrder(7))
		dbSelectArea("SE2")
		
		Do While !oReport:Cancel() .And. (cAliasSA2)->(!Eof())
			
			oReport:IncMeter()
			
			If oReport:Cancel()
				Exit
			EndIf
			
			lFirst := .T.
			
			Eval( bPosTit )
			
			Do While !oReport:Cancel() .And. !(cAliasSE2)->(Eof()) .And. Eval( bCondTit )
				
				If oReport:Cancel()
					Exit
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Pesquisa de descarte de registros geradores de       ³
				//³desdobramento                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFilAnt := SE2->E2_MATRIZ
				If SE5->(dbSeek((cAliasSE2)->(E2_MATRIZ+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
					If AllTrim(SE5->E5_TIPODOC) == "BA" .AND. AllTrim(SE5->E5_MOTBX) == "DSD"
						(cAliasSE2)->(dbSkip())
						Loop
					Endif
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ O alias SE2 eh utilizado nas funcoes Baixa() e SaldoTit() abaixo, por isso deve estar posicionado ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SE2->( dbSetOrder(1) )
				If mv_par19 == 1 .and. !Empty(xFilial("SE2"))
					lImpTit := SE2->( MsSeek( aSM0[nInc][2] +(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA ) ) )
				Else
					lImpTit := SE2->( MsSeek( xFilial("SE2")+(cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA ) ) )
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime o titulo a pagar do fornecedor se passou nas condicoes de filtros ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lImpTit
					
					aValor :=Baixas((cAliasSE2)->E2_NATUREZA,(cAliasSE2)->E2_PREFIXO,(cAliasSE2)->E2_NUM,(cAliasSE2)->E2_PARCELA,(cAliasSE2)->E2_TIPO,;
					nMoeda,"P",(cAliasSE2)->E2_FORNECE,dDataBase,(cAliasSE2)->E2_LOJA, ((cAliasSE2)->E2_MATRIZ))
					
					If mv_par14 == 1
						nSaldo :=SaldoTit((cAliasSE2)->E2_PREFIXO,(cAliasSE2)->E2_NUM,(cAliasSE2)->E2_PARCELA,(cAliasSE2)->E2_TIPO,;
						(cAliasSE2)->E2_NATUREZA,"P",(cAliasSE2)->E2_FORNECE,nMoeda,;
						iif(mv_par11==1,dDataBase,(cAliasSE2)->E2_VENCREA),,(cAliasSE2)->E2_LOJA,,iif(mv_par17 == 1 ,(cAliasSE2)->E2_TXMOEDA,0))
						
					Else
						nSaldo := xMoeda(((cAliasSE2)->E2_SALDO+(cAliasSE2)->E2_SDACRES-(cAliasSE2)->E2_SDDECRE),(cAliasSE2)->E2_MOEDA,mv_par10,;
						iif(mv_par17 == 1,iif(mv_par18 == 1,(cAliasSE2)->E2_EMISSAO,(cAliasSE2)->E2_EMIS1),dDataBase),,iif(mv_par17 == 1 .and. (cAliasSE2)->E2_TXMOEDA>0,(cAliasSE2)->E2_TXMOEDA, ))
					Endif
					
					aValor[I_DESCONTO]+= (cAliasSE2)->E2_SDDECRE
					aValor[I_JUROS]   += (cAliasSE2)->E2_SDACRES
					
					nTotAbat:=SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,mv_par10,"V",,SE2->E2_LOJA,iif(mv_par18==1,"1","2"),mv_par05,mv_par06,;
					iif(mv_par17 == 1,iif(mv_par18 == 1,SE2->E2_EMISSAO,SE2->E2_EMIS1),dDataBase),iif(mv_par17 == 1 .and. SE2->E2_TXMOEDA>0,SE2->E2_TXMOEDA,))
					
					
					If !((cAliasSE2)->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. !( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
						nSaldo -= nTotAbat
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se foi gerada fatura, colocar Motbx == Faturado				  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty((cAliasSE2)->E2_DTFATUR) .and. (cAliasSE2)->E2_DTFATUR <= dDataBase
						aValor[I_MOTBX] := 'FAT ' + (cAliasSE2)->FATURA  //STR0015  //"Faturado"
						aValor[I_VALOR_PAGO] -= nTotAbat
					Endif
					
					If cPaisLoc == "BRA" .And. !lPaBruto  .And. alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG
						nValorOrig:=(cAliasSE2)->E2_VALOR+(cAliasSE2)->E2_COFINS+(cAliasSE2)->E2_PIS+(cAliasSE2)->E2_CSLL
					Else
						nValorOrig:=(cAliasSE2)->E2_VALOR
					EndIf
					
					oTitsForn:Cell(STR0022	    ):SetBlock({|| iif(mv_par18==1, (cAliasSE2)->E2_EMISSAO,(cAliasSE2)->E2_EMIS1)}) //"Emissao"
					oTitsForn:Cell('Recebimento'):SetBlock({|| (cAliasSE2)->F1_RECBMTO})
					oTitsForn:Cell('Digitação'  ):SetBlock({|| (cAliasSE2)->F1_DTDIGIT})
					oTitsForn:Cell('Calendário' ):SetBlock({|| (cAliasSE2)->F1_DATACLA})
					oTitsForn:Cell(STR0021 	    ):SetBlock({|| xMoeda(nValorOrig,(cAliasSE2)->E2_MOEDA,nMoeda,iif(mv_par17 == 1,iif(mv_par18 == 1,(cAliasSE2)->E2_EMISSAO,(cAliasSE2)->E2_EMIS1),dDataBase),,iif(mv_par17 == 1 .and. (cAliasSE2)->E2_TXMOEDA>0,(cAliasSE2)->E2_TXMOEDA,))*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1)})
					oTitsForn:Cell(STR0023      ):SetBlock({|| (cAliasSE2)->E2_VENCREA}) //VENCIMENTO REAL
					oTitsForn:Cell(STR0024	    ):SetBlock({|| iif(dDataBase >= (cAliasSE2)->E2_BAIXA,iif(!Empty((cAliasSE2)->E2_BAIXA),(cAliasSE2)->E2_BAIXA," "),"")})		          //"Baixa"
					If lPCCBaixa
						oTitsForn:Cell(STR0025	):SetBlock({||aValor[I_LEI10925]})  				//"Lei 10925"
					Else
						aValor[I_LEI10925]:= (SE2->E2_COFINS+SE2->E2_PIS+SE2->E2_CSLL)
						oTitsForn:Cell(STR0025	):SetBlock({||aValor[I_LEI10925]})  				//"Lei 10925"
					Endif
					oTitsForn:Cell(STR0026	):SetBlock({||aValor[I_DESCONTO]})  				//"Descontos"
					oTitsForn:Cell(STR0027	):SetBlock({||nTotAbat})  							//"Abatimentos"
					oTitsForn:Cell(STR0028	):SetBlock({||aValor[I_JUROS]})  					//"Juros"
					oTitsForn:Cell(STR0029	):SetBlock({||aValor[I_MULTA]})  					//"Multa"
					oTitsForn:Cell(STR0030	):SetBlock({||aValor[I_CORRECAO_MONETARIA]})  		//"Corr. Monet"
					oTitsForn:Cell(STR0031	):SetBlock({||aValor[I_VALOR_PAGO]})//SetBlock({||xMoeda(aValor[I_VALOR_PAGO],(cAliasSE2)->E2_MOEDA,nMoeda,iif(mv_par18 == 1,(cAliasSE2)->E2_EMISSAO,(cAliasSE2)->E2_EMIS1),,iif(mv_par17 == 1,(cAliasSE2)->E2_TXMOEDA,0))*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1) })
					oTitsForn:Cell(STR0032	):SetBlock({||aValor[I_PAGAM_ANT]})  				//"Pagto.Antecip"
					oTitsForn:Cell(STR0033	):SetBlock({||nSaldo*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1)})  //"Saldo Atual"
					oTitsForn:Cell(STR0034	):SetBlock({||aValor[I_MOTBX]})  					//"Motivo"
					
					nTotForn0+=xMoeda(nValorOrig,(cAliasSE2)->E2_MOEDA,nMoeda,iif(mv_par17 == 1,iif(mv_par18 == 1,(cAliasSE2)->E2_EMISSAO,(cAliasSE2)->E2_EMIS1),dDataBase),,iif(mv_par17 == 1 .and. (cAliasSE2)->E2_TXMOEDA>0,(cAliasSE2)->E2_TXMOEDA,))*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1)
					nTotForn1+=aValor[I_LEI10925]
					nTotForn2+=aValor[I_DESCONTO]
					nTotForn3+=nTotAbat
					nTotForn4+=aValor[I_JUROS]
					nTotForn5+=aValor[I_MULTA]
					nTotForn6+=aValor[I_CORRECAO_MONETARIA]
					If ! ((cAliasSE2)->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG )
						nTotForn7+=aValor[I_VALOR_PAGO]
					Else
						nTotForn7-=aValor[I_VALOR_PAGO]
						nTotForn8+=aValor[I_PAGAM_ANT]
					Endif
					nTotForn9+=nSaldo*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1)
					
					//	nTotFil0+=xMoeda(nValorOrig,(cAliasSE2)->E2_MOEDA,nMoeda,iif(mv_par17 == 1,iif(mv_par18 == 1,(cAliasSE2)->E2_EMISSAO,(cAliasSE2)->E2_EMIS1),dDataBase),nDecs+1,iif(mv_par17 == 1 .and. (cAliasSE2)->E2_TXMOEDA>0,(cAliasSE2)->E2_TXMOEDA,))*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1)
					nTotFil0+=xMoeda(nValorOrig,(cAliasSE2)->E2_MOEDA,nMoeda,iif(mv_par17 == 1,iif(mv_par18 == 1,(cAliasSE2)->E2_EMISSAO,(cAliasSE2)->E2_EMIS1),dDataBase),nDecs+1,iif(mv_par17 == 1 .and. (cAliasSE2)->E2_TXMOEDA>0,(cAliasSE2)->E2_TXMOEDA,),iif(mv_par17 == 1 .and. (cAliasSE2)->E2_TXMOEDA>0,1,))*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1)
					nTotFil1+=aValor[I_LEI10925]
					nTotFil2+=aValor[I_DESCONTO]
					nTotFil3+=nTotAbat
					nTotFil4+=aValor[I_JUROS]
					nTotFil5+=aValor[I_MULTA]
					nTotFil6+=aValor[I_CORRECAO_MONETARIA]
					nTotFil7+=xMoeda(aValor[I_VALOR_PAGO],(cAliasSE2)->E2_MOEDA,nMoeda,iif(mv_par18 == 1,(cAliasSE2)->E2_EMISSAO,(cAliasSE2)->E2_EMIS1),,iif(mv_par17 == 1,(cAliasSE2)->E2_TXMOEDA,0))*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1)
					nTotFil8+=aValor[I_PAGAM_ANT]
					nTotFil9+=nSaldo*iif(alltrim((cAliasSE2)->E2_TIPO)$"PA ,"+MV_CPNEG,-1,1)
					
					
					oTitsForn:Cell(STR0021	):SetPicture(Tm(nValorOrig,oTitsForn:Cell(STR0021	):nSize,nDecs))  	//"Valor original"
					oTitsForn:Cell(STR0025	):SetPicture(Tm(aValor[I_LEI10925],oTitsForn:Cell(STR0025	):nSize,nDecs))  	//"Lei 10925"
					oTitsForn:Cell(STR0026	):SetPicture(Tm(aValor[I_DESCONTO],oTitsForn:Cell(STR0026	):nSize,nDecs)) 	//"Descontos"
					oTitsForn:Cell(STR0027	):SetPicture(Tm(nTotAbat,oTitsForn:Cell(STR0027	):nSize,nDecs))  	//"Abatimentos"
					oTitsForn:Cell(STR0028	):SetPicture(Tm(aValor[I_JUROS],oTitsForn:Cell(STR0028	):nSize,nDecs)) 	//"Juros"
					oTitsForn:Cell(STR0029	):SetPicture(Tm(aValor[I_MULTA],oTitsForn:Cell(STR0029	):nSize,nDecs)) 	//"Multa"
					oTitsForn:Cell(STR0030	):SetPicture(Tm(aValor[I_CORRECAO_MONETARIA],oTitsForn:Cell(STR0030	):nSize,nDecs))  //"Corr. Monet"
					oTitsForn:Cell(STR0031 	):SetPicture(Tm(aValor[I_VALOR_PAGO],oTitsForn:Cell(STR0031	):nSize,nDecs))  //"Valor Pago"
					oTitsForn:Cell(STR0032	):SetPicture(Tm(aValor[I_PAGAM_ANT],oTitsForn:Cell(STR0032	):nSize,nDecs))  //"Pagto.Antecip"
					oTitsForn:Cell(STR0033	):SetPicture(PictParent(Tm(nSaldo,oTitsForn:Cell(STR0033	):nSize,nDecs))) 	//"SAldo atual"
					
					If lPrintForn
						oFornecedores:PrintLine()
						lPrintForn	:=	.F.
					Endif
					oTitsForn:PrintLine()
					oReport:IncMeter()
					nReg++
					
				EndIf
				
				(cAliasSE2)->(dbSkip())
				If !Eval( bCondTit )
					oTotaisForn:Cell("TXTTOTAL"):SetBlock({||STR0010  }) //
					oTotaisForn:Cell(STR0021   ):SetBlock({||nTotForn0 }) 	//"Valor Original
					oTotaisForn:Cell(STR0025   ):SetBlock({||nTotForn1 })  	//"Lei 10925"
					oTotaisForn:Cell(STR0026   ):SetBlock({||nTotForn2 })  	//"Descontos"
					oTotaisForn:Cell(STR0027   ):SetBlock({||nTotForn3 })  	//"Abatimentos"
					oTotaisForn:Cell(STR0028   ):SetBlock({||nTotForn4 })  	//"Juros"
					oTotaisForn:Cell(STR0029   ):SetBlock({||nTotForn5 })  	//"Multa"
					oTotaisForn:Cell(STR0030   ):SetBlock({||nTotForn6 })  	//"Corr. Monet"
					oTotaisForn:Cell(STR0031   ):SetBlock({||nTotForn7 })  	//"Valor Pago"
					oTotaisForn:Cell(STR0032   ):SetBlock({||nTotForn8 })  	//"Pagto.Antecip"
					oTotaisForn:Cell(STR0033   ):SetBlock({||nTotForn9 })  	//"Saldo Atual"
					
					oTotaisForn:Cell(STR0021	):SetPicture(Tm(nTotForn0,oTitsForn:Cell(STR0021	):nSize,nDecs)) //"Valor original"
					oTotaisForn:Cell(STR0025	):SetPicture(Tm(nTotForn1,oTitsForn:Cell(STR0025	):nSize,nDecs)) //"Lei 10925"
					oTotaisForn:Cell(STR0026	):SetPicture(Tm(nTotForn2,oTitsForn:Cell(STR0026	):nSize,nDecs)) //"Descontos"
					oTotaisForn:Cell(STR0027	):SetPicture(Tm(nTotForn3,oTitsForn:Cell(STR0027	):nSize,nDecs)) //"Abatimentos"
					oTotaisForn:Cell(STR0028	):SetPicture(Tm(nTotForn4,oTitsForn:Cell(STR0028	):nSize,nDecs)) //"Juros"
					oTotaisForn:Cell(STR0029	):SetPicture(Tm(nTotForn5,oTitsForn:Cell(STR0029	):nSize,nDecs)) //"Multa"
					oTotaisForn:Cell(STR0030	):SetPicture(Tm(nTotForn6,oTitsForn:Cell(STR0030	):nSize,nDecs)) //"Corr. Monet"
					oTotaisForn:Cell(STR0031 	):SetPicture(Tm(nTotForn7,oTitsForn:Cell(STR0031	):nSize,nDecs)) //"Valor Pago"
					oTotaisForn:Cell(STR0032	):SetPicture(Tm(nTotForn8,oTitsForn:Cell(STR0032	):nSize,nDecs)) //"Pagto.Antecip"
					oTotaisForn:Cell(STR0033	):SetPicture(PictParent(Tm(nTotForn9,oTitsForn:Cell(STR0033	):nSize,nDecs))) //"SAldo atual"
					
					oTotaisForn:Init()
					oTotaisForn:PrintLine()
					oReport:ThinLine()
					oTotaisForn:Finish()
					
					nTotGeral0 += nTotForn0
					nTotGeral1 += nTotForn1
					nTotGeral2 += nTotForn2
					nTotGeral3 += nTotForn3
					nTotGeral4 += nTotForn4
					nTotGeral5 += nTotForn5
					nTotGeral6 += nTotForn6
					nTotGeral7 += nTotForn7
					nTotGeral8 += nTotForn8
					nTotGeral9 += nTotForn9
					
					nTotForn0:=	nTotForn1:=	nTotForn2:=	nTotForn3:=	nTotForn4:=	nTotForn5:=	nTotForn6:=	nTotForn7:=	nTotForn8:=	nTotForn9:=0
					
					lPrintForn	:=	.T.
				EndIf
			EndDo
			
			//imprime os totais por fornecedor
		EndDo
		
		//Imprime ou não as filiais sem movimento - P.E. F350MFIL
		If !lMovFil
			lImpMFil := iif(nReg != 0, .T., .F.)
		Endif
		
		If mv_par19 == 1 .and. Len( aSM0 ) > 1 .And. lImpMFil
			oTotaisFilial:Cell("TXTTOTAL"):SetBlock({||AllTrim(STR0036) + AllTrim( aSM0[nInc][2] ) + "-" + AllTrim(aSM0[nInc][7]) }) //
			oTotaisFilial:Cell(STR0021   ):SetBlock({||nTotFil0 }) 	//"Valor Original
			oTotaisFilial:Cell(STR0025   ):SetBlock({||nTotFil1 })  	//"Lei 10925"
			oTotaisFilial:Cell(STR0026   ):SetBlock({||nTotFil2 })  	//"Descontos"
			oTotaisFilial:Cell(STR0027   ):SetBlock({||nTotFil3 })  	//"Abatimentos"
			oTotaisFilial:Cell(STR0028   ):SetBlock({||nTotFil4 })  	//"Juros"
			oTotaisFilial:Cell(STR0029   ):SetBlock({||nTotFil5 })  	//"Multa"
			oTotaisFilial:Cell(STR0030   ):SetBlock({||nTotFil6 })  	//"Corr. Monet"
			oTotaisFilial:Cell(STR0031   ):SetBlock({||nTotFil7 })  	//"Valor Pago"
			oTotaisFilial:Cell(STR0032   ):SetBlock({||nTotFil8 })  	//"Pagto.Antecip"
			oTotaisFilial:Cell(STR0033   ):SetBlock({||nTotFil9 })  	//"Saldo Atual"
			
			oTotaisFilial:Cell(STR0021	):SetPicture(Tm(nTotFil0,oTitsForn:Cell(STR0021	):nSize,nDecs)) //"Valor original"
			oTotaisFilial:Cell(STR0025	):SetPicture(Tm(nTotFil1,oTitsForn:Cell(STR0025	):nSize,nDecs)) //"Lei 10925"
			oTotaisFilial:Cell(STR0026	):SetPicture(Tm(nTotFil2,oTitsForn:Cell(STR0026	):nSize,nDecs)) //"Descontos"
			oTotaisFilial:Cell(STR0027	):SetPicture(Tm(nTotFil3,oTitsForn:Cell(STR0027	):nSize,nDecs)) //"Abatimentos"
			oTotaisFilial:Cell(STR0028	):SetPicture(Tm(nTotFil4,oTitsForn:Cell(STR0028	):nSize,nDecs)) //"Juros"
			oTotaisFilial:Cell(STR0029	):SetPicture(Tm(nTotFil5,oTitsForn:Cell(STR0029	):nSize,nDecs)) //"Multa"
			oTotaisFilial:Cell(STR0030	):SetPicture(Tm(nTotFil6,oTitsForn:Cell(STR0030	):nSize,nDecs)) //"Corr. Monet"
			oTotaisFilial:Cell(STR0031	):SetPicture(Tm(nTotFil7,oTitsForn:Cell(STR0031	):nSize,nDecs)) //"Valor Pago"
			oTotaisFilial:Cell(STR0032	):SetPicture(Tm(nTotFil8,oTitsForn:Cell(STR0032	):nSize,nDecs)) //"Pagto.Antecip"
			oTotaisFilial:Cell(STR0033	):SetPicture(PictParent(Tm(nTotFil9,oTitsForn:Cell(STR0033	):nSize,nDecs))) //"SAldo atual"
			
			oTotaisFilial:Init()
			oTotaisFilial:PrintLine()
			oReport:ThinLine()
			oTotaisFilial:Finish()
			nTotFil0:= nTotFil1:= nTotFil2:= nTotFil3:= nTotFil4:= nTotFil5:= nTotFil6:= nTotFil7:= nTotFil8:= nTotFil9:=0
		EndIf
		lInitForn := .T.
		If Empty(xFilial("SE2"))
			Exit
		Endif
	EndIf
Next

//Imprime Total geral
oTotalGeral:Cell("TXTTOTAL"):SetBlock({||STR0011  }) //
oTotalGeral:Cell(STR0021   ):SetBlock({||nTotGeral0 }) 	//"Valor Original
oTotalGeral:Cell(STR0025   ):SetBlock({||nTotGeral1 })  	//"Lei 10925"
oTotalGeral:Cell(STR0026   ):SetBlock({||nTotGeral2 })  	//"Descontos"
oTotalGeral:Cell(STR0027   ):SetBlock({||nTotGeral3 })  	//"Abatimentos"
oTotalGeral:Cell(STR0028   ):SetBlock({||nTotGeral4 })  	//"Juros"
oTotalGeral:Cell(STR0029   ):SetBlock({||nTotGeral5 })  	//"Multa"
oTotalGeral:Cell(STR0030   ):SetBlock({||nTotGeral6 })  	//"Corr. Monet"
oTotalGeral:Cell(STR0031   ):SetBlock({||nTotGeral7 })  	//"Valor Pago"
oTotalGeral:Cell(STR0032   ):SetBlock({||nTotGeral8 })  	//"Pagto.Antecip"
oTotalGeral:Cell(STR0033   ):SetBlock({||nTotGeral9 })  	//"Saldo Atual"

oTotalGeral:Cell(STR0021	):SetPicture(PictParent(Tm(nTotGeral0,oTitsForn:Cell(STR0021	):nSize,nDecs))) //"Valor original"
oTotalGeral:Cell(STR0025	):SetPicture(Tm(nTotGeral1,oTitsForn:Cell(STR0025	):nSize,nDecs)) //"Lei 10925"
oTotalGeral:Cell(STR0026	):SetPicture(Tm(nTotGeral2,oTitsForn:Cell(STR0026	):nSize,nDecs)) //"Descontos"
oTotalGeral:Cell(STR0027	):SetPicture(Tm(nTotGeral3,oTitsForn:Cell(STR0027	):nSize,nDecs)) //"Abatimentos"
oTotalGeral:Cell(STR0028	):SetPicture(Tm(nTotGeral4,oTitsForn:Cell(STR0028	):nSize,nDecs)) //"Juros"
oTotalGeral:Cell(STR0029	):SetPicture(Tm(nTotGeral5,oTitsForn:Cell(STR0029	):nSize,nDecs)) //"Multa"
oTotalGeral:Cell(STR0030	):SetPicture(Tm(nTotGeral6,oTitsForn:Cell(STR0030	):nSize,nDecs)) //"Corr. Monet"
oTotalGeral:Cell(STR0031 	):SetPicture(Tm(nTotGeral7,oTitsForn:Cell(STR0031	):nSize,nDecs)) //"Valor Pago"
oTotalGeral:Cell(STR0032	):SetPicture(Tm(nTotGeral8,oTitsForn:Cell(STR0032	):nSize,nDecs)) //"Pagto.Antecip"
oTotalGeral:Cell(STR0033	):SetPicture(PictParent(Tm(nTotGeral9,oTitsForn:Cell(STR0033	):nSize,nDecs))) //"SAldo atual"

oTotalGeral:Init()
oTotalGeral:PrintLine()
oReport:ThinLine()
oTotalGeral:Finish()

oTitsForn:Finish()
oFornecedores:Finish()

SM0->(dbGoTo(nRegSM0))
cFilAnt := iif( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR350  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Fornecedores                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR350(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FinR350R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi(STR0001)  //"Este programa ir  emitir a posi‡„o dos fornecedores"
Local cDesc2 :=OemToAnsi(STR0002)  //"referente a data base do sistema."
Local cDesc3 :=""
Local cString:="SE2"
Local nMoeda

Private aLinha :={}
Private aReturn:={OemToAnsi(STR0003),1,OemToAnsi(STR0004),1,2,1,"",1}  //"Zebrado"###"Administracao"
Private cPerg  :="RFIN350R  " 
//CriaSx1()
Private cabec1,cabec2,nLastKey:=0,titulo,wnrel,tamanho:="G"
Private nomeprog :="LS_FR350"
Private aOrd :={OemToAnsi(STR0012),OemToAnsi(STR0013) }  //"Por Codigo"###"Por Nome"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo:= OemToAnsi(STR0005)  //"Posicao dos Fornecedores "

cabec1:= "Prf Numero       PC Tip Valor Original Emissao    Recebim.   Digitacao  Calendario Vencto     Baixa                          P  A  G  A  M  E  N  T  O  S                                                                                     "
//                                               11/11/1111 11/11/1111 11/11/1111 11/11/1111 11/11/1111 11/11/1111 11/11/1111

cabec2:= OemToAnsi(STR0007)	//"                                                                           Lei 10925    Descontos   Abatimentos         Juros         Multa   Corr. Monet      Valor Pago  Pagto.Antecip.        Saldo Atual  Motivo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	( !Pergunte("RFIN350R  ",.T.) )
			Return
		EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01    // Do Fornecedor                     		 ³
//³ mv_par02    // Ate o Fornecedor                  		 ³
//³ mv_par03    // Da Loja                           		 ³
//³ mv_par04    // Ate a Loja                        		 ³
//³ mv_par05    // Da Emissao                        		 ³
//³ mv_par06    // Ate a Emissao                     		 ³
//³ mv_par07    // Do Vencimento                     		 ³
//³ mv_par08    // Ate o Vencimento                  		 ³
//³ mv_par09    // Imprime os t¡tulos provis¢rios    		 ³
//³ mv_par10    // Qual a moeda                      		 ³
//³ mv_par11    // Reajusta pela DataBase ou Vencto  		 ³
//³ mv_par12    // Considera Faturados               		 ³
//³ mv_par13    // Imprime Outras Moedas             		 ³
//³ mv_par14    // Considera Data Base               		 ³
//³ mv_par15    // Imprime Nome?(Raz.Social/N.Reduz.)		 ³
//³ mv_par16    // Imprime PA? Sim ou Não            		 ³
//³ mv_par17    // Conv. val. pela Data de? Hoje ou Mov 	 ³
//| mv_par18	// Considera Data de Emissao:"Do Documento" ou "Do Sistema"
//³ mv_par19	// Consid Filiais  ?  						 ³
//³ mv_par20	// da filial								 ³
//³ mv_par21	// a flial 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="LS_FINR350"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif
fErase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nMoeda := mv_par10
Titulo += " - " + GetMv("MV_MOEDA"+Str(nMoeda,1))

RptStatus({|lEnd| Fa350Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA350Imp ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Fornecedores                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA350Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA350Imp(lEnd,wnRel,cString)

Local CbTxt,cbCont
Local nOrdem,nTotAbat:=0
Local nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0,nTit6:=0,nTit7:=0,nTit8:=0,nTit9:=0,nTit10:=0
Local nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTot5:=0,nTot6:=0,nTot7:=0,nTot8:=0,nTot9:=0,nTot10:=0
Local lContinua:=.T.,cForAnt:=Space(6),nSaldo:=0
Local aValor	:={0,0,0,0,0,0}
Local nMoeda	:=0
Local dDataMoeda
Local cCond1,cCond2,cChave,cIndex
Local cOrder
Local aStru := SE2->(dbStruct()), ni
Local cFilterUser := aReturn[7]
Local ndecs		:=Msdecimais(mv_par10)
Local cAliasSA2 := "SA2"
Local lImpPAPag	:= iif(MV_PAR16=2, .T. ,.F.)  //Imprime PA Gerada pela Ordem de Pago.
Local nConv		:= mv_par17
Local cCpoEmis 	:= iif(mv_par18 == 1,"E2_EMISSAO","E2_EMIS1")
Local nTotFil1:=0
Local nTotFil2:=0
Local nTotFil3:=0
Local nTotFil4:=0
Local nTotFil5:=0
Local nTotFil6:=0
Local nTotFil7:=0
Local nTotFil8:=0
Local nTotFil9:=0
Local nTotFil10:=0
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"
Local nAj := 0
Local nValorOrig := 0
Local lPaBruto	:= GetNewPar("MV_PABRUTO","2") == "1"  //Indica se o PA terá o valor dos impostos descontados do seu valor
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()
Local nVlOriMoed := 0

//******************************************
// Utilizados pelo ponto de entrada F350MFIL
//******************************************
Local lMovFil	:= .T. //Default: Imprime todas as filiais
Local lImpMFil 	:= .T.
Local nReg
//******************************************
Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
Private cFilNome	:= ""
PRIVATE cFilDe,cFilAte

dDataMoeda:=dDataBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt :=Space(10)
cbcont:=00
li    :=80
m_pag :=01
nOrdem := aReturn[8]

nMoeda := mv_par10

SomaAbat("","","","P")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par19 == 2
	cFilDe  := iif( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte := iif( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
ELSE
	cFilDe := mv_par20	// Todas as filiais
	cFilAte:= mv_par21
Endif

If ExistBlock("F350MFIL")
	lMovFil := ExecBlock("F350MFIL",.F.,.F.)
Endif

For nInc := 1 To Len( aSM0 )
	If aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte)
		nReg := 0 //Zera a contagem de registros impressos.
		
		cFilAnt := aSM0[nInc][2]
		cFilNome := aSM0[nInc][7]
		
		If nOrdem == 1
			cCond1 :='SE2->E2_FORNECE+SE2->E2_LOJA <= mv_par02+mv_par04 .and. SE2->E2_FILIAL == xFilial("SE2")'
			cCond2 := "SE2->E2_FORNECE+SE2->E2_LOJA"
			cOrder := "A2_FILIAL,E2_FILIAL,A2_COD,A2_NOME,FATURA, E2_FATURA DESC,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
		Else
			cOrder := "A2_FILIAL,E2_FILIAL,A2_NOME,A2_COD,FATURA, E2_FATURA DESC,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
			cCond1 := ".T."
			cCond2 := "SE2->E2_FORNECE+SE2->E2_LOJA"
		EndIf
		
		aStru := dbStruct()

		cQuery := "	SELECT CASE WHEN E2_FATURA <> %Exp:''% THEN CASE WHEN E2_FATURA = %Exp:'NOTFAT'% THEN E2_NUM ELSE E2_FATURA END ELSE %Exp:''% END FATURA,"
		cQuery += " M0_CODIGO, A2_FILIAL,A2_COD,A2_NOME,A2_NREDUZ,A2_LOJA,SE2.* , F1_DTDIGIT, F1_RECBMTO, F1_DATACLA
		cQuery += " FROM " + RetSqlName("SE2") +" SE2 (NOLOCK)"
		cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 (NOLOCK)"
		cQuery += " ON SA2.A2_FILIAL = '" + xFilial("SA2") + "'"
		cQuery += " AND SE2.E2_FORNECE = SA2.A2_COD "
		cQuery += " AND SE2.E2_LOJA = SA2.A2_LOJA "
		cQuery += " AND SA2.D_E_L_E_T_ = '' "
		
		
		cQuery += " INNER JOIN SIGAMAT SM0 (NOLOCK)"
		cQuery += " ON ( M0_CODFIL = E2_MSFIL"
		//cQuery += " AND ZJ_ATIVO = 'S'"
		cQuery += " AND M0_CODIGO = '" + cEmpAnt + "'"
		cQuery += " AND SM0.D_E_L_E_T_ = '' )
		
		cQuery += " LEFT JOIN " + RetSqlName("SF1") + " SF1 (NOLOCK)"
		cQuery += " ON F1_FILIAL = E2_MSFIL"
		cQuery += " AND F1_DOC = E2_NUM"
		cQuery += " AND F1_PREFIXO = E2_PREFIXO"
		cQuery += " AND F1_FORNECE = E2_FORNECE"
		cQuery += " AND F1_LOJA = E2_LOJA"
		cQuery += " AND SF1.D_E_L_E_T_ = '' "
		
		cQuery += " WHERE SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
		cQuery += " AND SE2.E2_FORNECE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
		cQuery += " AND SE2.E2_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
		cQuery += " AND SE2."+cCpoEmis+"  between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
		cQuery += " AND SE2.E2_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
		cQuery += " AND (SE2.E2_BAIXA between '" + DTOS(mv_par25)  + "' AND '" + DTOS(mv_par26) + "' OR E2_BAIXA = '')"
		cQuery += " AND SE2.E2_TIPO NOT IN " + FormatIn(MVABATIM,"|")
		cQuery += " AND SE2."+cCpoEmis+"  <=  '"     + DTOS(dDataBase) + "'"

		If mv_par16 == 2
			cQuery += " AND E2_TIPO <> 'PA '"
		EndIf
		
		If mv_par12 == 2
			cQuery += " AND E2_FATURA IN('"+Space(Len(SE2->E2_FATURA))+"','NOTFAT')"
		Endif
		
		If mv_par13 == 2
			cQuery += " AND E2_MOEDA = " + STR(mv_par10) +""
		Endif                           
		
		If mv_par22 == 2
			cQuery += " AND E2_SALDO <> 0"
		ElseIf mv_par22 == 1
			cQuery += " AND E2_SALDO = 0"
		EndIf

		If !Empty(cFilterUser)
			cQuery += ' AND ' + strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(cFilterUser,'DTOS',''),'.AND.',' AND ')),'.and.',' AND '),'"',"'"),"==","="),".or."," OR "),".OR."," OR ")
		EndIf
		
		If mv_par09 == 2
			cQuery += " AND SE2.E2_TIPO <> '"+MVPROVIS+"'"
		EndIf
		cQuery += " AND SE2.D_E_L_E_T_ = '' "
		cQuery += " ORDER BY " + cOrder
		
		dbSelectArea("SE2")
		dbCloseArea()
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .T., .T.)
		count to _nLastRec
		SetRegua(_nLastRec)

		DbGoTop()
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C' .and. FieldPos(aStru[ni,1]) > 0
				TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
		TCSetField('SE2', 'F1_EMISSAO','D')
		TCSetField('SE2', 'F1_DTDIGIT','D')
		TCSetField('SE2', 'F1_RECBMTO','D')
		TCSetField('SE2', 'F1_DATACLA','D')
		
		cAliasSA2 := "SE2"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicionamento do SE5 neste ponto que servira para   ³
		//³pesquisa de descarte de registros geradores de       ³
		//³desdobramento                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE5")
		SE5->(dbSetOrder(7))	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		dbSelectArea("SE2")
		
		While !Eof() .And. lContinua .And. &cCond1
			
			dbSelectArea("SE2")
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
				Exit
			EndIF
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSelectArea("SE2")
				dbSkip()
				Loop
			Endif
			
			nCont:=1
			nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=nTit10:=0
			cForAnt:= &cCond2
			
			Do While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()
				IF (ALLTRIM(SE2->E2_TIPO)$MV_CPNEG+","+MVPAGANT .Or. SUBSTR(SE2->E2_TIPO,3,1)=="-").and. "FINA085" $ Upper( AllTrim( SE2->E2_ORIGEM)) .And. lImpPAPag // Nao imprime o PA qdo ele for gerado pela Ordem de Pago
					dbSelectArea("SE2")
					dbSkip()
					Loop
				Else
					IF lEnd
						@PROW()+1,001 PSAY OemToAnsi(STR0008)  //"CANCELADO PELO OPERADOR"
						lContinua := .F.
						Exit
					EndIF
					
					IncRegua()
					
					/*
					If !Fr350Skip()
						dbSelectArea("SE2")
						dbSkip()
						Loop
					EndIf
					*/
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Pesquisa de descarte de registros geradores de       ³
					//³desdobramento                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cFilAnt := SE2->E2_MATRIZ
					If SE5->(dbSeek(SE2->(E2_MATRIZ+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
						If AllTrim(SE5->E5_TIPODOC) == "BA" .AND. AllTrim(SE5->E5_MOTBX) == "DSD"
							SE2->(dbSkip())
							Loop
						Endif
					Endif
					
				Endif
				
				IF li > 58
					nAtuSM0 := SM0->(Recno())
					SM0->(dbGoto(nRegSM0))
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					SM0->(dbGoTo(nAtuSM0))
				EndIF
				
				If nCont = 1
					@li,0 PSAY OemToAnsi(STR0009)+(cAliasSA2)->A2_COD+" "+iif(mv_par15 == 1,(cAliasSA2)->A2_NOME,(cAliasSA2)->A2_NREDUZ)  //"FORNECEDOR : "
					li+=2
					nCont++
				Endif
				
				dbSelectArea("SE2")
				
				IF mv_par11 == 1
					dDataMoeda	:=	dDataBase
				Else
					dDataMoeda	:=	SE2->E2_VENCREA
				Endif
				
				aValor:=Baixas( SE2->E2_NATUREZA,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,nMoeda,"P",SE2->E2_FORNECE,dDataBase,SE2->E2_LOJA, SE2->E2_MATRIZ)
				
				If mv_par14 == 1
					nSaldo:=SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZA,"P",E2_FORNECE,nMoeda,dDataMoeda,,SE2->E2_LOJA,,iif(nConv == 1 ,SE2->E2_TXMOEDA,0))
					If SE2->E2_TIPO $ MVPAGANT
						nSaldo -= aValor[I_VALOR_PAGO]
					EndIf
				Else
					nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par10,iif(mv_par17 == 1,iif(mv_par18 == 1,SE2->E2_EMISSAO,SE2->E2_EMIS1),dDataBase),nDecs+1,iif(mv_par17 == 1 .and. SE2->E2_TXMOEDA>0,SE2->E2_TXMOEDA,))
				Endif
				
				nTotAbat:=SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,mv_par10,"V",,SE2->E2_LOJA,iif(mv_par18==1,"1","2"),mv_par05,mv_par06,;
				iif(mv_par17 == 1,iif(mv_par18 == 1,SE2->E2_EMISSAO,SE2->E2_EMIS1),dDataBase),iif(mv_par17 == 1 .and. SE2->E2_TXMOEDA>0,SE2->E2_TXMOEDA,),iif(mv_par17 == 1 .and. SE2->E2_TXMOEDA>0,1,))
				
				aValor[I_JUROS] += SE2->E2_SDACRES
				aValor[I_DESCONTO] += SE2->E2_SDDECRE
				
				If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
					! ( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
					nSaldo -= nTotAbat
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se foi gerada fatura, colocar Motbx == Faturado				  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(SE2->E2_DTFATUR) .and. SE2->E2_DTFATUR <= dDataBase
					aValor[I_MOTBX] := STR0015  //"Faturado"
					aValor[I_VALOR_PAGO] -= nTotAbat
				Endif
				
				If !lPaBruto  .And. alltrim(SE2->E2_TIPO)$"PA ,"+MV_CPNEG
					nValorOrig:=SE2->E2_VALOR+SE2->E2_COFINS+SE2->E2_PIS+SE2->E2_CSLL
				Else
					nValorOrig:=SE2->E2_VALOR
				EndIf
				
				@li,00     PSAY SE2->E2_PREFIXO+"-"+SE2->E2_NUM
				@li,17+nAj PSAY SE2->E2_PARCELA
				@li,20+nAj PSAY SE2->E2_TIPO
				
				nVlOriMoed := xMoeda(nValorOrig,SE2->E2_MOEDA,nMoeda,;
				iif(mv_par17 == 1,iif(mv_par18 == 1,SE2->E2_EMISSAO,SE2->E2_EMIS1),dDataBase),;
				nDecs+1,iif(mv_par17 == 1 .and. SE2->E2_TXMOEDA>0,SE2->E2_TXMOEDA,))
				@li,24+nAj PSAY SayValor( nVlOriMoed, 15, ( SE2->E2_TIPO == "PA " ), nDecs )
				
				@li,41+nAj PSAY dtoc(iif(mv_par18 == 1,SE2->E2_EMISSAO,SE2->E2_EMIS1)) + ' ' + dtoc(SE2->F1_RECBMTO) + ' ' + dtoc(SE2->F1_DTDIGIT) + ' ' + dtoc(SE2->F1_DATACLA) + ' ' + dtoc(SE2->E2_VENCREA) + ' '
				
				IF dDataBase >= SE2->E2_BAIXA
					@li,100+nAj PSAY iif(!Empty(SE2->E2_BAIXA),SE2->E2_BAIXA," ")
				EndIf
				
				@li,112 PSAY aValor[I_JUROS]    	      Picture Tm(aValor[I_JUROS],13,nDecs)
				@li,126 PSAY aValor[I_MULTA]              Picture Tm(aValor[I_MULTA],13,nDecs)
				@li,140 PSAY aValor[I_CORRECAO_MONETARIA] Picture Tm(aValor[I_CORRECAO_MONETARIA],13,nDecs)                                                  
				_nValorPago := iif(!empty(SE2->E2_FATURA) .and. SE2->E2_FATURA <> 'NOTFAT',0, aValor[I_VALOR_PAGO])
				@li,154 PSAY iif(SE2->E2_TIPO == "PA " .And. _nValorPago > 0, SayValor(_nValorPago,15,.T.,nDecs),SayValor(_nValorPago,15,.F.,nDecs))
				@li,170 PSAY aValor[I_PAGAM_ANT]          Picture Tm(aValor[I_PAGAM_ANT],15,nDecs)
				
				@li,188 PSAY SayValor(nSaldo,16,alltrim(SE2->E2_TIPO)$"PA ,"+MV_CPNEG,nDecs)
				@li,206 PSAY aValor[I_MOTBX]
				If ! ( SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG )
					nTit1+= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoeda,iif(mv_par17 == 1,iif(mv_par18 == 1,SE2->E2_EMISSAO,SE2->E2_EMIS1),dDataBase),nDecs+1,iif(mv_par17 == 1 .and. SE2->E2_TXMOEDA>0,SE2->E2_TXMOEDA,))
					nTit7+=_nValorPago
					nTit9+=nSaldo
				Else
					nTit1-= xMoeda(nValorOrig,SE2->E2_MOEDA,nMoeda,iif(mv_par17 == 1,iif(mv_par18 == 1,SE2->E2_EMISSAO,SE2->E2_EMIS1),dDataBase),nDecs+1,iif(mv_par17 == 1 .and. SE2->E2_TXMOEDA>0,SE2->E2_TXMOEDA,))
					nTit9-=nSaldo
				Endif
				
				//nTit7+=aValor[I_VALOR_PAGO]
				
				nTit2+=aValor[I_DESCONTO]
				nTit3+=nTotAbat
				nTit4+=aValor[I_JUROS]
				nTit5+=aValor[I_MULTA]
				nTit6+=aValor[I_CORRECAO_MONETARIA]
				nTit8+=aValor[I_PAGAM_ANT]
				nTit10+=aValor[I_LEI10925]
				dbSelectArea("SE2")
				dbSkip()
				li++
				nReg++
				//Endif
			Enddo
			If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9)+ABS(nTit10) > 0 )
				ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,nTit10,nDecs)
				li++
			Endif
			nTot1+=nTit1
			nTot2+=nTit2
			nTot3+=nTit3
			nTot4+=nTit4
			nTot5+=nTit5
			nTot6+=nTit6
			nTot7+=nTit7
			nTot8+=nTit8
			nTot9+=nTit9
			nTot10+=nTit10
			
			nTotFil1 += nTit1
			nTotFil2 += nTit2
			nTotFil3 += nTit3
			nTotFil4 += nTit4
			nTotFil5 += nTit5
			nTotFil6 += nTit6
			nTotFil7 += nTit7
			nTotFil8 += nTit8
			nTotFil9 += nTit9
			nTotFil10+= nTit10
		EndDO
		
		SE2->(DbCloseArea())
		
		//Imprime ou não as filiais sem movimento - P.E. F350MFIL
		If !lMovFil
			lImpMFil := iif(nReg != 0, .T., .F.)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimir TOTAL por filial somente quan-³
		//³ do houver mais do que 1 filial.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if mv_par19 == 1 .and. SM0->(Reccount()) > 1 .And. lImpMFil
			ImpFil350(nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10,nDecs)
		Endif
		Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9
		If Empty(xFilial("SE1"))
			Exit
		Endif
	EndIf
Next

cFilAnt := iif( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

IF li > 55 .and. li != 80
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
EndIF

IF li != 80
	ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,nTot10,nDecs)
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen

if TcSrvType() != "AS/400"
	dbSelectArea("SE2")
	dbCloseArea()
	ChkFile("SE2")
	dbSelectArea("SE2")
	dbSetOrder(1)
else
	dbSelectArea("SE2")
	dbClearFil()
	If Select("__SE2") <> 0
		__SE2->(dbCloseArea())
	Endif
	RetIndex( "SE2" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
endif

If aReturn[5] = 1
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpSubTot ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprimir linha de SubTotal do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ImpSubTot()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,nTit10,nDecs)
li++
@li,000 PSAY OemToAnsi(STR0010)  //"Totais : "
@li,022 PSAY nTit1  Picture Tm(nTit1,17,nDecs)
@li,071 PSAY nTit10 PicTure Tm(nTit10,13,nDecs)
@li,084 PSAY nTit2  PicTure Tm(nTit2,13,nDecs)
@li,098 PSAY nTit3  PicTure Tm(nTit3,13,nDecs)
@li,112 PSAY nTit4  PicTure Tm(nTit4,13,nDecs)
@li,126 PSAY nTit5  PicTure Tm(nTit5,13,nDecs)
@li,140 PSAY nTit6  PicTure Tm(nTit6,13,nDecs)
@li,154 PSAY nTit7  PicTure Tm(nTit7,15,nDecs)
@li,170 PSAY nTit8  PicTure Tm(nTit8,15,nDecs)
@li,187 PSAY nTit9  PicTure Tm(nTit9,17,nDecs)
li++
@li,  0 PSAY REPLICATE("-",220)
li++
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotG  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir linha de Total do Relatorio                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTotG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTotg(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,nTot10,nDecs)
li++
@li,000 PSAY OemToAnsi(STR0011)  //"TOTAL GERAL ---->"
@li,022 PSAY nTot1  Picture Tm(nTot1,17,nDecs)
@li,071 PSAY nTot10 PicTure Tm(nTot10,13,nDecs)
@li,084 PSAY nTot2  PicTure Tm(nTot2,13,nDecs)
@li,098 PSAY nTot3  PicTure Tm(nTot3,13,nDecs)
@li,112 PSAY nTot4  PicTure Tm(nTot4,13,nDecs)
@li,126 PSAY nTot5  PicTure Tm(nTot5,13,nDecs)
@li,140 PSAY nTot6  PicTure Tm(nTot6,13,nDecs)
@li,154 PSAY nTot7  PicTure Tm(nTot7,15,nDecs)
@li,170 PSAY nTot8  PicTure Tm(nTot8,15,nDecs)
@li,187 PSAY nTot9  PicTure Tm(nTot9,17,nDecs)
li++
Return(.t.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FR350FIL  ³ Autor ³ Andreia          	    ³ Data ³ 12.01.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FR350FIL()
Local cString
Local cCpoEmis 	:= iif(mv_par18 == 1,"E2_EMISSAO","E2_EMIS1")

cString := 'E2_FILIAL="'+xFilial("SE2")+'".And.'
cString += 'dtos('+cCpoEmis+'  )>="'+dtos(mv_par05)+'".and.dtos('+cCpoEmis+'  )<="'+dtos(mv_par06)+'".And.'
cString += 'dtos(E2_VENCREA)>="'+dtos(mv_par07)+'".and.dtos(E2_VENCREA)<="'+dtos(mv_par08)+'".And.'
cString += 'E2_FORNECE>="'+mv_par01+'".and.E2_FORNECE<="'+mv_par02+'".And.'
cString += 'E2_LOJA>="'+mv_par03+'".and.E2_LOJA<="'+mv_par04+'"'

Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ AndaTRB	³ Autor ³ Emerson / Sandro      ³ Data ³ 20.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Movimenta area temporaria e reposiciona SE1 ou SE2 ou SE5  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³         																	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function  AndaTRB(xMyAlias)
Local cAlias:= Alias()
dbSelectArea(XMyAlias)
dbSkip()
(cAlias)->(dbGoTo((xMyAlias)->Recno))
dbSelectArea(cAlias)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr350Skip ³ Autor ³ Pilar S. Albaladejo   |Data  ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR350.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr350Skip(cAlias)
Local lRet := .T.
Local cEmissao
Default cAlias := "SE2"

cEmissao := iif(mv_par18 == 1, (cAlias)->E2_EMISSAO, (cAlias)->E2_EMIS1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta dentro dos parametros                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF (cAlias)->E2_FORNECE < mv_par01 .OR. (cAlias)->E2_FORNECE > mv_par02 .OR. ;
	(cAlias)->E2_LOJA    < mv_par03 .OR. (cAlias)->E2_LOJA    > mv_par04 .OR. ;
	cEmissao   < mv_par05 .OR. cEmissao   > mv_par06 .OR. ;
	(cAlias)->E2_VENCREA < mv_par07 .OR. (cAlias)->E2_VENCREA > mv_par08 .OR. ;
	(cAlias)->E2_TIPO $ MVABATIM
	lRet :=  .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo ‚ provis¢rio                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf ((cAlias)->E2_TIPO $ MVPROVIS .and. mv_par09==2)
	lRet := .F.
	
ElseIF cEmissao   > dDataBase
	lRet := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve imprimir outras moedas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Elseif mv_par13 == 2 .And. (cAlias)->E2_MOEDA != mv_par10 //verifica moeda do campo=moeda parametro
	lret := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo foi aglutinado em uma fatura            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Empty((cAlias)->E2_FATURA) .and. Substr((cAlias)->E2_FATURA,1,6)!="NOTFAT" .and. !Empty( (cAlias)->E2_DTFATUR ) .and. DtoS( (cAlias)->E2_DTFATUR ) <= DtoS( mv_par06 ).And.;
	mv_par12 <> 1
	lRet :=  .F. 	// Considera Faturados = mv_par12
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve imprimir outras moedas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Elseif mv_par13 == 2 // nao imprime
	If (cAlias)->E2_MOEDA != mv_par10 //verifica moeda do campo=moeda parametro
		lret := .F.
	Endif
Endif
Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SayValor  ³ Autor ³ J£lio Wittwer    	  ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna String de valor entre () caso Valor < 0 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR350.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SayValor(nNum,nTam,lInvert,nDecs)
Local cPicture,cRetorno
nDecs := iif(nDecs == NIL, 2, nDecs)

cPicture := tm(nNum,nTam,nDecs)
cRetorno := Transform(nNum,cPicture)
IF nNum<0 .or. lInvert
	cRetorno := "("+substr(cRetorno,2)+")"
Endif
Return cRetorno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³PictNeg	³ Autor ³ Adrianne Furtado  	³ Data ³ 03.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³TRansforme uma Picture em Picture com "()"parenteses para   ³±±
±±³          ³valores negativos. 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR350.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PictParent(cPict)
Local cRet
Local nAt := At("9",cPict)
cRet := SubStr(cPict,1,nAt-2)+")"+SubStr(cPict,nAt-1,Len(cPict))
Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ImpFil350³ Autor ³ Adrianne Furtado 	  	³ Data ³ 27.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpFil130()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	    ³ Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpFil350(nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li--
IF li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
EndIF

@li,000 PSAY AllTrim(OemToAnsi(STR0035))+" "+iif(mv_par19==1,cFilAnt+" - " + AllTrim(cFilNome),"")  //"T O T A L   F I L I A L ----> "
@li,050 PSAY nTotFil1        Picture TM(nTotFil1,14,nDecs)
@li,074 PSAY nTotFil10       Picture TM(nTotFil10,10,nDecs)
@li,087 PSAY nTotFil2        Picture TM(nTotFil2,10,nDecs)
@li,101 PSAY nTotFil3        Picture TM(nTotFil3,10,nDecs)
@li,115 PSAY nTotFil4		  Picture TM(nTotFil4,10,nDecs)
@li,129 PSAY nTotFil5 		  Picture TM(nTotFil5,10,nDecs)
@li,143 PSAY nTotFil6        Picture TM(nTotFil6,10,nDecs)
@li,159 PSAY nTotFil7		  Picture TM(nTotFil7,10,nDecs)
@li,175 PSAY nTotFil8 		  Picture TM(nTotFil8,10,nDecs)
@li,194 PSAY nTotFil9 		  Picture TM(nTotFil9,10,nDecs)

li++
@li,000 PSAY Replicate("-",220)
li+=2
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AdmAbreSM0()
Local aArea			:= SM0->( GetArea() )
Local aAux			:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

If lFWLoadSM0
	aRetSM0	:= FWLoadSM0()
Else
	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		aAux := { 	SM0->M0_CODIGO,;
		iif( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
		"",;
		"",;
		"",;
		SM0->M0_NOME,;
		SM0->M0_FILIAL }
		
		aAdd( aRetSM0, aClone( aAux ) )
		SM0->( DbSkip() )
	End
EndIf

RestArea( aArea )
Return aRetSM0


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Baixas      ³ Autor ³ Lu¡s C. Cunha      ³ Data ³ 17.08.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna uma matriz com os valores pagos ou recebidos de um ³±±
±±³          ³ t¡tulo.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ aMatriz := Baixas ( ... )                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ú cNatureza ¿                                              ³±±
±±³          ³ ú cPrefixo  ´                                              ³±±
±±³          ³ ú cNumero   ÅÄ ğ Identifica‡„o do t¡tulo.                  ³±±
±±³          ³ ú cParcela  ´                                              ³±±
±±³          ³ ú cTipo     Ù                                              ³±±
±±³          ³ ú nMoeda    Moeda em que os valores ser„o processados.     ³±±
±±³          ³ ú cModo ú   R - Receber , P - Pagar                        ³±±
±±³          ³ ú cFornec   Codigo do Fornecedor (Se Contas a Pagar )      ³±±
±±³          ³ ú dData     Data para conversao da moeda                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Espec¡fico para os relat¢rios FinR340 e FinR350.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ls_Baixas(cNatureza,cPrefixo,cNumero,cParcela,cTipo,nMoeda,cModo,cFornec,dData,cLoja,cFilTit,dDtIni,dDtFin,lConsDtBas)

Static aMotBaixas 

Local aRetorno:={0,0,0,0,0,0,0,0," ",0,0,0,0,0,0,0,0,0,0,0}
Local cArea   :=Alias()
Local nOrdem  :=0
Local nMoedaTit
Local lNaoConv
Local aMotBx := {}
Local nI := 0
Local nT := 0
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )       

Local lImpComp := SuperGetMv("MV_IMPCMP",,"2") == "1"

Local nTamTit	:= TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1]+1

//Rastreamento
Local lRastro 		:= If(FindFunction("FVerRstFin"),FVerRstFin(),.F.) .and. SuperGetMV("MV_NRASDSD",.T.,.F.)

Local nMoedaCalc	:= 0

Default cFilTit:= xFilial("SE5")
Default lConsDtBas := .T.

If aMotBaixas == NIL
	// Monto array com codigo e descricao do motivo de baixa
	aMotBx := ReadMotBx()	
	aMotBaixas := {}
	For NI := 1 to Len(aMotBx)
		AADD( aMotBaixas,{substr(aMotBx[nI],01,03),substr(aMotBx[nI],07,10)})
	Next
Endif

// Quando eh chamada do Excel, estas variaveis estao em branco
IF Empty(MVABATIM) .Or.;
	Empty(MV_CRNEG) .Or.;
	Empty(MVRECANT) .Or.;
	Empty(MV_CPNEG) .Or.;
	Empty(MVPAGANT) .Or.;
	Empty(MVPROVIS)
	CriaTipos()
Endif

cFornec:=IIF( cFornec == NIL, "", cFornec )
cLoja := IIF( cLoja == NIL, "" , cLoja )
nMoeda:=IIf(nMoeda==NIL,1,nMoeda)
dData:=IIf(dData==NIL,dDataBase,dData)
dDtIni:=IIf(dDtIni==NIL,CTOD("//"),dDtIni)
dDtFin:=IIf(dDtFin==NIL,CTOD("//"),dDtFin)

dbSelectArea("SE5")
nOrdem:=IndexOrd()
dbSetOrder(7)
If MsSeek(cFilTit+cPrefixo+cNumero+cParcela+cTipo)
	
	nMoedaTit := Iif( cModo == "R", SE1-> E1_MOEDA , SE2 -> E2_MOEDA )
	
	While cFilTit+cPrefixo+cNumero+cParcela+cTipo==SE5->E5_FILIAL+;
			SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO
	
		//Nas localizacoes e usada a movimentacao bancaria em mais de uma moeda
		//por isso, quando a baixa for contra um banco, devo pegar a E5_VLMOED2,
		//pois na E5_VALOR, estara grvado o movimento na moeda do banco.
		//Bruno. Paraguay 23/08/00 
		lNaoConv	:=	(nMoeda == 1 .And.(cPaisLoc=="BRA".Or.Empty(E5_BANCO)).or.( nMoeda==Val(SE5->E5_MOEDA) .And. cPaisLoc<>"BRA" .And. !Empty(E5_BANCO)) )
		Do Case
		Case SE5->E5_SITUACA = "C" .or. ;
				SE5->E5_TIPODOC = "ES"
			dbSkip()
			Loop
		// Despresa as movimenta‡oes diferentes do tipo solicitado somente se
		// o tipo for != de RA e PA, pois neste caso o RECPAG sera invertido.		
		Case SE5->E5_RECPAG != cModo .AND. !(SE5->E5_TIPO$MVRECANT+"/"+MVPAGANT+"/"+MV_CRNEG+"/"+MV_CPNEG)
			dbSkip()
			Loop		
		Case TemBxCanc()
			dbSkip()
			Loop
		Case SE5->E5_CLIFOR+SE5->E5_LOJA != cFornec + cLoja
			dbSkip( )
			Loop
		Case (SE5->E5_DATA > dDataBase .or. SE5->E5_DATA > dData) .And. lConsDtBas
			dbSkip()
			Loop
		Case !Empty(dDtIni) .and. SE5->E5_DATA < dDtIni .and. SE5->E5_DATA > dDtFin
			dbSkip()
			Loop	
		Case SE5->E5_TIPODOC $ "VLüBA/V2/CP"
			IF cModo == "R"
				aRetorno[5]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,)))
				If SE5->E5_MOTBX == "CMP" .and. SUBSTR(SE5->E5_DOCUMEN,nTamTit,3) == MV_CRNEG  //NCC
					aRetorno[13]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VALOR,nMoedaTit,nMoeda,SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,)))
					If lImpComp
						//Retorno valores de Pis e Cofins para as compensacoes
						aRetorno[14]+= SE5->E5_VRETPIS
						aRetorno[15]+= SE5->E5_VRETCOF
						aRetorno[18]+= SE5->E5_VRETCSL					
					Endif
				Endif
				//Retorno valor baixado via liquidacao
				If SE5->E5_MOTBX == "LIQ"
					aRetorno[19]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VALOR,nMoedaTit,nMoeda,SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,)))
				Endif
				
				//Retorno valor baixado via Desdobramento com rastro
				If SE5->E5_MOTBX == "DSD" .and. lRastro
					aRetorno[20]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VALOR,nMoedaTit,nMoeda,SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,)))
				Endif
			Else
				//Baixa PA nao deve ser considerada
				If !(SE5->E5_TIPODOC == "BA" .and. SE5->E5_TIPO == "PA " .and. SE5->E5_RECPAG == "P" .and. SE5->E5_MOTBX <> "CMP")

					//Se nao converte 
					If lNaoConv
						aRetorno[6]+=	If(SE5->E5_TIPODOC == "BA" .and. SE5->E5_TIPO == "PA " .and. SE5->E5_RECPAG == "P" .and. SE5->E5_MOTBX <> "CMP",0,Iif(lNaoConv,SE5->E5_VALOR,xMoeda(Iif(cpaisLoc=="BRA" .Or. (!Empty(Se5->E5_MOEDA).And. cPaisLoc<>"BRA"),SE5->E5_VLMOED2,SE5->E5_VALOR),Iif(!Empty(Se5->E5_MOEDA).And. cPaisLoc<>"BRA",Val(SE5->E5_MOEDA),nMoedaTit),nMoeda,SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,))))
					Else 
						//Se pais for Brasil ou 
						// (Se a moeda do movimento estiver preenchida em outros paises ou 
						//	 Se o registro for de compensacao 
						//		(neste caso a moeda nao eh gravada e o valor na moeda do titulo esta no E5_VLMOED2)	)				
						If cPaisLoc=="BRA" .Or. ;
							(( !Empty(Se5->E5_MOEDA) .OR. SE5->E5_MOTBX == 'CMP') .And. cPaisLoc<>"BRA" ) 
							nValor := SE5->E5_VLMOED2
						Else
							nValor := SE5->E5_VALOR
						Endif
						nMoedaCalc := IF(!Empty(Se5->E5_MOEDA).And. cPaisLoc<>"BRA",Val(SE5->E5_MOEDA),nMoedaTit)
						aRetorno[6]+= xMoeda(nValor,nMoedaCalc,nMoeda,SE5->E5_DATA)
      			Endif
            Endif
            
				If lContrRet .And. lPCCBaixa .And. (SE5->E5_PRETPIS $ " #3")
					aRetorno[12]+= SE5->(E5_VRETPIS+E5_VRETCOF+E5_VRETCSL)
				Endif
			Endif
			aRetorno[10]+= SE5->E5_VALOR
			aRetorno[11]+= 1   // Numero de baixas
			
			If	SE5->(FieldPos("E5_VLACRES")) >0  .and. SE5->(FieldPos("E5_VLDECRE")) >0
				aRetorno[16] += SE5->E5_VLACRES
				aRetorno[17] += SE5->E5_VLDECRE
			Endif
			
		Case SE5->E5_TIPODOC $ "DC/D2"
				aRetorno[2]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,)))
		Case SE5->E5_TIPODOC $ "JR/J2"
				aRetorno[3]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(Iif(cpaisLoc=="BRA",SE5->E5_VLMOED2,SE5->E5_VALOR),Iif(!Empty(Se5->E5_MOEDA).And. cPaisLoc<>"BRA",Val(SE5->E5_MOEDA),nMoedaTit),nMoeda,SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,)))
		Case SE5->E5_TIPODOC $ "MT/M2"
				aRetorno[4]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
		Case SE5->E5_TIPODOC $ "CM/C2/CX"
				aRetorno[1]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(Iif(cpaisLoc=="BRA",SE5->E5_VLMOED2,SE5->E5_VALOR),Iif(!Empty(Se5->E5_MOEDA) .And. cPaisLoc<>"BRA",Val(SE5->E5_MOEDA),nMoedaTit),nMoeda,SE5->E5_DATA,,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,)))
		Case SE5->E5_TIPODOC $ "RA /"+MV_CRNEG
				aRetorno[7]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA))
		Case (SE5->E5_TIPODOC = "PA" .Or. SE5->E5_TIPO = "PA") .or. SE5->E5_TIPODOC $ MV_CPNEG
				aRetorno[8]+=Iif(lNaoConv,SE5->E5_VALOR,xMoeda(Iif(cpaisLoc=="BRA",SE5->E5_VLMOED2,SE5->E5_VALOR),Iif(!Empty(Se5->E5_MOEDA) .And. cPaisLoc<>"BRA",Val(SE5->E5_MOEDA),nMoedaTit),nMoeda,E5_DATA,,Iif(SE5->E5_TXMOEDA > 0,SE5->E5_TXMOEDA,)))
		EndCase
		If ! Empty(SE5->E5_MOTBX )
			If SE5->E5_MOTBX == "NOR"
				aRetorno[9] := OemToAnsi( STR0001 ) //"Normal"
			Elseif SE5->E5_MOTBX == "DEV"
				aRetorno[9] := OemToAnsi( STR0002 ) //"Devolucao"
			Elseif SE5->E5_MOTBX == "DAC"
				aRetorno[9] := OemToAnsi( STR0003 ) //"DACAO"
			Elseif SE5->E5_MOTBX == "VEN"
				aRetorno[9] := OemToAnsi( STR0004 ) //"VENDOR"
			Elseif SE5->E5_MOTBX == "CMP"
				aRetorno[9] := OemToAnsi( STR0005 ) //"Compensacao"
			Elseif SE5->E5_MOTBX == "CEC"
				aRetorno[9] := OemToAnsi( STR0006 ) //"Comp Carteiras"
			Elseif SE5->E5_MOTBX == "DEB"
				aRetorno[9] := OemToAnsi( STR0013 ) //"D‚bito C/C"
			Elseif SE5->E5_MOTBX == "LIQ"
				aRetorno[9] := OemToAnsi( STR0014 ) //"Liquida‡„o"
			Elseif SE5->E5_MOTBX == "FAT"
				aRetorno[9] := OemToAnsi( STR0028 ) //"Faturado"
			Else
				IF (nT := ascan(aMotBaixas,{|x| x[1]= SE5->E5_MOTBX })) > 0		
					aRetorno[9] := aMotBaixas [nT][2]
				Endif			
			Endif
		Endif
		dbSkip()
	Enddo
Endif
dbSetOrder(nOrdem)
dbSelectArea(cArea)

Return(aRetorno)             

//___________________________________________
Static Function CriaSx1()
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

return


aAdd(aReg,{cPerg,"01","Do Fornecedor ?               ","mv_ch1",  "C",06,0,0,"G","","mv_par01","               ","","","               ","","","               ","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"02","Ate o Fornecedor ?            ","mv_ch2",  "C",06,0,0,"G","","mv_par02","               ","","","               ","","","               ","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"03","Da loja ?                     ","mv_ch3",  "C",02,0,0,"G","","mv_par03","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"04","Ate a Loja ?                  ","mv_ch4",  "C",02,0,0,"G","","mv_par04","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"05","Da Emissao ?                  ","mv_ch5",  "D",08,0,0,"G","","mv_par05","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"06","Ate a Emissao ?               ","mv_ch6",  "D",08,0,0,"G","","mv_par06","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"07","Do Vencimento ?               ","mv_ch7",  "D",08,0,0,"G","","mv_par07","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"08","Ate o Vencimento ?            ","mv_ch8",  "D",08,0,0,"G","","mv_par08","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"09","Imprime provisorios ?         ","mv_ch9",  "N",01,0,1,"C","","mv_par09","Sim            ","","","Nao            ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"10","Qual a moeda ?                ","mv_cha",  "N",02,0,0,"G","","mv_par10","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"11","Reajusta Venc.pela ?          ","mv_chb",  "N",01,0,2,"C","","mv_par11","Data Base      ","","","Data de Vencto ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"12","Considera Faturados ?         ","mv_chc",  "N",01,0,1,"C","","mv_par12","Sim            ","","","Nao            ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"13","Outras Moedas ?               ","mv_chd",  "N",01,0,2,"C","","mv_par13","Converter      ","","","Nao Imprimir   ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"14","Compoe Saldo Retroativo ?     ","mv_che",  "N",01,0,2,"C","","mv_par14","Sim            ","","","Nao            ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"15","Imprime Nome ?                ","mv_chf",  "N",01,0,1,"C","","mv_par15","Razao Social   ","","","Nome Reduzido  ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"16","Imprimir Pa ?                 ","mv_chg",  "N",01,0,1,"C","","mv_par16","Sim            ","","","Nao            ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"17","Conv.mov. na moeda sel. pela ?","mv_chh",  "N",01,0,2,"C","","mv_par17","Data Movimento ","","","Data de Hoje   ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"18","Considera Data de Emissao ?   ","mv_chi",  "N",01,0,1,"C","","mv_par18","Do Documento   ","","","Do Sistema     ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"19","Cons.Filiais abaixo ?         ","mv_chj",  "N",01,0,1,"C","","mv_par19","Sim            ","","","Nao            ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"20","Da Filial ?                   ","mv_chk",  "C",02,0,0,"G","","mv_par20","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"21","Ate a Filial ?                ","mv_chl",  "C",02,0,0,"G","","mv_par21","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"22","Saldo zerado                  ","mv_chm",  "N",01,0,1,"C","","mv_par22","Sim            ","","","Nao            ","","","Todos          ","","","","","","","","   "})
aAdd(aReg,{cPerg,"23","Imprimir Tipos ?              ","mv_chn",  "C",40,0,0,"G","","mv_par23","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"24","Nao Imprimir Tipos ?          ","mv_cho",  "C",40,0,0,"G","","mv_par24","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"25","Baixa de                      ","mv_chp",  "D",08,0,0,"G","","mv_par25","               ","","","               ","","","               ","","","","","","","","   "})
aAdd(aReg,{cPerg,"26","Baixa ate                     ","mv_chq",  "D",08,0,0,"G","","mv_par26","               ","","","               ","","","               ","","","","","","","","   "})

aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil



