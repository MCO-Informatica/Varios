#Include "rwmake.ch"


//+---------------------------------------------------------------------+
//| Programa:  | CFATRP10 | Autor: | Douglas Mello | Data: | 03.02.2011 |
//+---------------------------------------------------------------------+
//| Descrição: | Planilha de Faturamento Budget X Realizado.            |
//+---------------------------------------------------------------------+
//| Uso:       | Especifico para o cliente Certisign.                   |
//+---------------------------------------------------------------------+
User Function CFATRP10()
//-- CFATR1new

//-- Declaracao de Variaveis.
Local cDesc1			:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2			:= "de acordo com os parametros informados pelo usuario."
Local cDesc3			:= "Faturamento Budget X Realizado"
Local cPict			:= ""
Local nLin				:= 80
Local imprime			:= .T.
Local aOrd				:= {}

Private titulo		:= "Faturamento Budget X Realizado"
Private Cabec1		:= "                                                                                                                                                       Valor Unit.   ------ Devolucoes -------"
Private Cabec2		:= " Mes      Canal                   Produto                          Classificaï¿½ï¿½o           Cliente                          Quantidade          Valor        Medio   Quantidade          Valor"
Private lEnd			:= .F.
Private lAbortPrint	:= .F.
Private CbTxt			:= ""
Private limite		:= 220
Private tamanho		:= "G"
Private nomeprog		:= "CFATRP10"
Private nTipo			:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey		:= 0
Private cPerg			:= "RFAT01_TST"
Private cbtxt			:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag			:= 01
Private wnrel			:= "CFATRP10"
Private cString		:= "SD2"

//-- Valida a existencia de perguntas e alimenta em memoria.
//ValidPerg(cPerg)
Pergunte(cPerg,.F.)


//-- Monta a interface padrao com o usuario...
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.,.F.,,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//-- Processamento. RPTSTATUS monta janela com a regua de processamento.
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


//+----------------------------------------------------------------------+
//| Programa:  | RunReport | Autor: | Douglas Mello | Data: | 03.02.2011 |
//+----------------------------------------------------------------------+
//| Descrição: | Função auxiliar chamada pela RPTSTATUS. A função monta  |
//|            | a janela com a regua de processamento.                  |
//+----------------------------------------------------------------------+
//| Uso:       | Especifico para o cliente Certisign.                    |
//+----------------------------------------------------------------------+
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//-- Declaracao de Variaveis.
Local cArqTmp 	:= ""
Local aEstr		:= {}
Local cInd1		:= CriaTrab(Nil,.F.)
Local cQuery		:= ""
Local cSelect		:= ""
Local cSeleCount	:= ""
Local cQry			:= ""
Local nTotRegs	:= 0
Local lRecLock	:= .T.
Local cVendAnt	:= ""
Local _Opc			:= mv_par11
Local _aCabec		:= {}
Local _nTotQtd	:= 0
Local _nTotQtdD	:= 0
Local _nTotVal	:= 0
Local _nTotValD	:= 0
Local nValUnit	:= 0
Local nPos			:= 0
Local cORIGPV		:= ''
Local aOrigPV		:= strtokarr( U_CSC5XBOX() ,';')
Local cNomVend2	:= ""

_aCampos		:= {}
_aTes			:= mv_par10


//-- Monta campo TES para serem utilizado na query.
_aTes := StrToArray(Alltrim(mv_par10),";")
_cTes := "("

For _nI := 1 To Len(_aTes)
	_cTes += "'" + _aTes[_nI] + "'"
	If _nI <> Len(_aTes)
		_cTes += ","
	EndIf
Next _nI

_cTes += ")"


//-- Monta clausulas da query a serem utilizadas no relatorio.
IF _Opc=1 //-- Sintetico
	cSelect := "SELECT 	"																		+Chr(13)+Chr(10)
	cSelect += "	SubStr(D2_EMISSAO,5,2)||'/'||substr(D2_EMISSAO,1,4) As Mes, "			+Chr(13)+Chr(10)
	cSelect += "	SZ2.Z2_CANAL As Canal, D2_COD As Produto,B1_DESC As Descricao, "		+Chr(13)+Chr(10)
	cSelect += "	SZ1.Z1_DESCSEG As Segmento, "												+Chr(13)+Chr(10)
	cSelect += "	TRIM(B1_COD)||Z1_CODSEG As Prd_venda, "									+Chr(13)+Chr(10)
	cSelect += "	SUM(D2_QUANT) As Quantidade, "												+Chr(13)+Chr(10)
	cSelect += "	SUM(D2_TOTAL) As Valor,       "												+Chr(13)+Chr(10)
	cSelect += "	SUM(D2_DESPESA) As Despesa,       "										+Chr(13)+Chr(10)
	cSelect += "	SUM(D2_VALFRE) As Frete,       "											+Chr(13)+Chr(10)
	cSelect += "	SUM(D1_QUANT) As QuantDev,     "											+Chr(13)+Chr(10)
	cSelect += "	SUM(D1_TOTAL) As ValorDev,      "											+Chr(13)+Chr(10)
	cSelect += "    SUM(D2_ICMSRET) As ICMSST		"											+Chr(13)+Chr(10) 
	cSelect += "	From                             "											+Chr(13)+Chr(10)
	cSelect += RetSqlName("SF2") + " SF2 "
	cSelect += "LEFT JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D_E_L_E_T_ = ' ' " +Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SF2.F2_CLIENTE = SA1.A1_COD And SF2.F2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "		+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_FILIAL=SB1.B1_FILIAL AND SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' " 		+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SA3") + " SA3 ON SF2.F2_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' " 											+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SZ2") + " SZ2 ON SA3.A3_XCANAL=SZ2.Z2_CODIGO AND SZ2.D_E_L_E_T_ = ' ' " 										+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SC5") + " SC5 ON SC5.C5_NUM = SD2.D2_PEDIDO AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' '  "	+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SZ1") + " SZ1 ON SZ1.Z1_CODSEG = SB1.B1_XSEG AND SZ1.D_E_L_E_T_ = ' ' " 										+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SD1") + " SD1 ON D2_FILIAL = D1_FILIAL AND D2_SERIE = D1_SERIORI And D2_ITEM = D1_ITEMORI And D2_DOC = D1_NFORI And D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ' ' " +Chr(13)+Chr(10)
	cSelect += "	Where                                           "											+Chr(13)+Chr(10)
	cSelect += "B1_COD     >= '"	+mv_par01+"' And B1_COD     <= '"			+mv_par02+"' And"				+Chr(13)+Chr(10)
	cSelect += "B1_XSEG    >= '"	+mv_par03+"' And B1_XSEG    <= '"			+mv_par04+"' And"				+Chr(13)+Chr(10)
	cSelect += "A3_XCANAL  >= '"	+mv_par05+"' And A3_XCANAL  <= '"			+mv_par06+"' And"				+Chr(13)+Chr(10)
	cSelect += "SD2.D2_EMISSAO >= '"+DtoS(mv_par07)+"' And SD2.D2_EMISSAO <= '"	+DtoS(mv_par08)+"' And"	+Chr(13)+Chr(10)
	cSelect += " SD2.D2_TES 	IN 		"+ _cTes + " 	AND "															+Chr(13)+Chr(10)
	cSelect += "SF2.D_E_L_E_T_ = ' ' "																				+Chr(13)+Chr(10)
	cSelect += "	Group By                "																		+Chr(13)+Chr(10)
	cSelect += "	(SubStr(D2_EMISSAO,5,2)||'/'||substr(D2_EMISSAO,1,4)),  "									+Chr(13)+Chr(10)
	cSelect += "	D2_COD,B1_DESC, Z1_DESCSEG, Z2_CANAL,    			    "										+Chr(13)+Chr(10)
	cSelect += "	(TRIM(B1_COD)||Z1_CODSEG)                               "									+Chr(13)+Chr(10)
	cSelect += "	ORDER By                                                "									+Chr(13)+Chr(10)
	cSelect += "	D2_COD,B1_DESC, Z1_DESCSEG, Z2_CANAL                    "									+Chr(13)+Chr(10)
endif

IF _Opc=2	//-- Analitico
	cSelect := "Select "																																+Chr(13)+Chr(10)
	cSelect += "SubStr(D2_EMISSAO,5,2)||'/'||substr(D2_EMISSAO,1,4) As Mes, "																	+Chr(13)+Chr(10)
	cSelect += "SubStr(SF2.F2_EMISSAO,7,2)||'/'||SubStr(SF2.F2_EMISSAO,5,2)||'/'||SubStr(SF2.F2_EMISSAO,1,4) AS Data_Faturamento,"	+Chr(13)+Chr(10)
	cSelect += "SZ2.Z2_CANAL As Canal, "																											+Chr(13)+Chr(10)
	cSelect += "SD2.D2_COD As Produto, "																											+Chr(13)+Chr(10)
	cSelect += "TRIM(B1_COD)||Z1_CODSEG As Prd_venda, "																							+Chr(13)+Chr(10)
	cSelect += "SB1.B1_DESC As Descricao,"																											+Chr(13)+Chr(10)
	cSelect += "SZ1.Z1_DESCSEG As Segmento, "																										+Chr(13)+Chr(10)
	cSelect += "SD2.D2_CLIENTE As Cliente, "																										+Chr(13)+Chr(10)
	cSelect += "SD2.D2_LOJA As Loja, "																												+Chr(13)+Chr(10)
	cSelect += "SA1.A1_NOME	AS Nome,"																												+Chr(13)+Chr(10)
	cSelect += "SA1.A1_CGC	AS CNPJ_CGC,"																											+Chr(13)+Chr(10)
	cSelect += "SD2.D2_QUANT As Quantidade, "																										+Chr(13)+Chr(10)
	cSelect += "SD2.D2_TOTAL As Valor, "																											+Chr(13)+Chr(10)
	//cSelect += "SD2.D2_TOTAL/D2_QUANT As Unit,"																									+Chr(13)+Chr(10)
	cSelect += "SD1.D1_QUANT As QuantDev,"																											+Chr(13)+Chr(10)
	cSelect += "SD1.D1_TOTAL As ValorDev,"																											+Chr(13)+Chr(10)
	cSelect += "SF2.F2_SERIE AS Serie,"																											+Chr(13)+Chr(10)
	cSelect += "SF2.F2_DOC AS NotaFiscal,"																											+Chr(13)+Chr(10)
	cSelect += "SD2.D2_ITEM AS ItemNota,"																											+Chr(13)+Chr(10)
	cSelect += "SF2.F2_VEND1 AS Vendedor1,"																										+Chr(13)+Chr(10)	
	cSelect += "SA3.A3_NOME AS NomeVend1,"																											+Chr(13)+Chr(10)
	cSelect += "SF2.F2_VEND2 AS Vendedor2,"																										+Chr(13)+Chr(10)
	cSelect += "SC5.C5_DESPESA AS Despesas,"																										+Chr(13)+Chr(10)
	cSelect += "SD2.D2_VALFRE AS Frete,"																											+Chr(13)+Chr(10)
	cSelect += "SD2.D2_PEDIDO AS Pedido,"																											+Chr(13)+Chr(10)
	cSelect += "SD2.D2_ITEMPV AS ITEM_PED,"																										+Chr(13)+Chr(10)
	cSelect += "SC5.C5_XORIGPV AS Origem,"																											+Chr(13)+Chr(10)
	cSelect += "SC5.C5_CHVBPAG AS Pedido_Gar,"																										+Chr(13)+Chr(10)
	cSelect += "SD2.D2_ICMSRET AS ICMSST,"																										+Chr(13)+Chr(10)
	cSelect += "SD2.D2_TES AS TES"																										+Chr(13)+Chr(10)	
	cSelect += "FROM "																																+Chr(13)+Chr(10)
	cSelect += RetSqlName("SF2") + " SF2 "
	cSelect += "LEFT JOIN " + RetSqlName("SD2") + " SD2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D_E_L_E_T_ = ' ' " +Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SF2.F2_CLIENTE = SA1.A1_COD And SF2.F2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " 	+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_FILIAL=SB1.B1_FILIAL AND SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' " 		+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SA3") + " SA3 ON SF2.F2_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' " 											+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SZ2") + " SZ2 ON SA3.A3_XCANAL=SZ2.Z2_CODIGO AND SZ2.D_E_L_E_T_ = ' ' " 										+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SC5") + " SC5 ON SC5.C5_NUM = SD2.D2_PEDIDO AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_ = ' ' " 	+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SZ1") + " SZ1 ON SZ1.Z1_CODSEG = SB1.B1_XSEG AND SZ1.D_E_L_E_T_ = ' ' " 										+Chr(13)+Chr(10)
	cSelect += "LEFT JOIN " + RetSqlName("SD1") + " SD1 ON D2_FILIAL = D1_FILIAL AND D2_SERIE = D1_SERIORI And D2_ITEM = D1_ITEMORI And D2_DOC = D1_NFORI And D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ' ' " +Chr(13)+Chr(10)
	cSelect += "WHERE"																		+Chr(13)+Chr(10)
	cSelect += "SF2.D_E_L_E_T_ = ' ' And "       											+Chr(13)+Chr(10)
	cSelect += "B1_COD     >= '"+mv_par01+"' And B1_COD     <= '"+mv_par02+"' And"	+Chr(13)+Chr(10)
	cSelect += "B1_XSEG    >= '"+mv_par03+"' And B1_XSEG    <= '"+mv_par04+"' And"	+Chr(13)+Chr(10)
	cSelect += "A3_XCANAL  >= '"+mv_par05+"' And A3_XCANAL  <= '"+mv_par06+"' And"	+Chr(13)+Chr(10)
	cSelect += "SD2.D2_EMISSAO >= '"+DtoS(mv_par07)+"' And "							+Chr(13)+Chr(10)
	cSelect += "SD2.D2_EMISSAO <= '"+DtoS(mv_par08)+"' And"								+Chr(13)+Chr(10)
	cSelect += "SD2.D2_TOTAL > 0 AND"														+Chr(13)+Chr(10)
	cSelect += " SD2.D2_TES IN	"+ _cTes + "  "											+Chr(13)+Chr(10)
	
	cSelect += "Order By Mes, Segmento, Canal"											+Chr(13)+Chr(10)
Endif


//-- Executa query para selecao dos registros a serem processados no rel.
If Select("TMPQ") > 0
	TMPQ->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cSelect), "TMPQ", .F., .T.)
TcSetField( "TMPQ", "Quantidade", "N", 15, 2 )
TcSetField( "TMPQ", "Valor"     , "N", 15, 2 )
TcSetField( "TMPQ", "QuantDev"  , "N", 15, 2 )
TcSetField( "TMPQ", "ValorDev"  , "N", 15, 2 )

//-- SETREGUA -> Indica quantos registros serao processados para a regua.
ProcRegua( TMPQ->( RecCount() ) )

//-- Criacado do cabecalho da planilha.
If mv_par09 == 1 //-- Planilha Excel = Sim

	If _opc = 1 //-- Sintetico
		AAdd( _aCampos,{	"MES",;
							"CANAL",;
							"PRODUTO",;
							"DESCRIC",;
							"SEGMENTO",;
							"QUANTVEN",;
							"VALORVEN",;
							"VALORDESP",;
							"VALORFRET",;
							"ICMS-ST",;
							"VALOR",;
							"VALTOTAL",;
							"QUANTDEV",;
							"VALORDEV",;
							"COD. U.N.",;
							"UNID. NEG."} )
							
	ElseIf _opc = 2 //-- Analitico
		AAdd( _aCampos,{	"MES",;
							"DATA_FATURAMENTO",;
							"CANAL",;
							"PRODUTO",;
							"DESCRIC",;
							"SEGMENTO",;
							"CLIENTE",;
							"LOJA",;
							"NOME",;
							"CNPJ_CGC",;
							"QUANTVEN",;
							"VALORVEN",;
							"VALUNIT",;
							"QUANTDEV",;
							"VALORDEV",;
							"Serie",;
							"NotaFiscal/Item",;
							"Vendedor1",;
							"NomeVend1",;
							"Vendedor2",;
							"NomeVend2",;
							"Despesas",;
							"Frete",;
							"Valor_Total(Valor+Despesas+Frete+ICMS-ST)",;
							"Pedido",;
							"Pedido_Gar",;
							"Origem",;
							"Produto Origem",;
							"COD. U.N.",;
							"UNID. NEG."} )
	EndIf
	
EndIf

//AAdd(_aCampos, {})

dbSelectArea("ACV")
dbSetOrder(5)

//-- Loop no arquivo de trabalho para impressao dos registros.
DbSelectArea('TMPQ')
DbGoTop()
Do While !TMPQ->(EOF())

	If _opc=2
		Incproc( "Registro: "+TMPQ->Serie+"-"+TMPQ->NotaFiscal )
		ProcessMessage()
	EndIf
	
	//-- Verifica o cancelamento pelo usuario...
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//-- Impressao do cabecalho do relatorio. . .
	If nLin > 55 //-- Salto de Pagina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	//-- Unidade de Negocio.
	If ACV->( DbSeek( xFilial("ACV") + TMPQ->PRODUTO ) )
		cCodUnNeg := ACV->ACV_CATEGO
		cDesUnNeg := Posicione("ACU", 1, xFilial("ACU") + cCodUnNeg, "ACU_DESC")
	Else
		cCodUnNeg := ""
		cDesUnNeg := ""
	Endif

	//-- Imprime detalhes do relatorio.
	/*
	if _opc=1
		@nLin,001 pSay TMPQ->Mes
		@nLin,010 pSay Left(TMPQ->CANAL,22)
		@nLin,034 pSay Left(AllTrim(TMPQ->PRODUTO),15)
		@nLin,050 pSay Left(AllTrim(TMPQ->Descricao),10)
		@nLin,084 pSay Left(TMPQ->SEGMENTO,22)
		@nLin,124 pSay TMPQ->QUANTIDADE	Picture "@E 99,999,999.99"
		@nLin,136 pSay TMPQ->VALOR	    Picture "@E 99,999,999.99"
		@nLin,148 pSay TMPQ->QUANTDEV	Picture "@E 99,999,999.99"
		@nLin,160 pSay TMPQ->VALORDEV    Picture "@E 99,999,999.99"
		nLin++
	endif
	if _opc=2
		@nLin,001 pSay TMPQ->Mes
		@nLin,010 pSay Left(TMPQ->CANAL,22)
		@nLin,034 pSay Left(AllTrim(TMPQ->PRODUTO),15)
		@nLin,050 pSay Left(AllTrim(TMPQ->Descricao),10)
		@nLin,067 pSay Left(TMPQ->SEGMENTO,22)
		@nLin,091 pSay TMPQ->CLIENTE+'.'+TMPQ->LOJA+'-'+Left(Posicione('SA1', 1, xFilial('SA1')+TMPQ->(CLIENTE+LOJA), 'A1_NOME'),20)
		@nLin,124 pSay TMPQ->QUANTIDADE	Picture "@E 99,999,999.99"
		@nLin,136 pSay TMPQ->VALOR	    Picture "@E 99,999,999.99"
		@nLin,152 pSay TMPQ->UNIT	    Picture "@E 999,999.99"
		@nLin,164 pSay TMPQ->QUANTDEV	Picture "@E 99,999,999.99"
		@nLin,176 pSay TMPQ->VALORDEV    Picture "@E 99,999,999.99"
		nLin++
	endif
	*/
	
	//-- Totaliza valores por vendedor.
	_nTotQtd  += TMPQ->QUANTIDADE
	_nTotQtdD += TMPQ->QUANTDEV
	_nTotVal  += TMPQ->VALOR
	_nTotValD += TMPQ->VALORDEV

	//-- Grava os dados para a planilha.
	If mv_par09 == 1 //-- Gera planilha Excel.
		If _opc = 1
		   AAdd( _aCampos, {	TMPQ->Mes,;
		   						TMPQ->CANAL,;
								AllTrim(TMPQ->PRODUTO),;
								AllTrim(TMPQ->Descricao),;
								TMPQ->SEGMENTO,;
								Transform(TMPQ->QUANTIDADE, '@E 99999999'),;
								Transform(TMPQ->VALOR,  '@E 999,999,999.99'),;
								Transform(TMPQ->Despesa,  '@E 999,999,999.99'),;
								Transform(TMPQ->Frete,  '@E 999,999,999.99'),;
								Transform(TMPQ->ICMSST,  '@E 999,999,999.99'),;
								Transform(TMPQ->VALOR+TMPQ->Despesa+TMPQ->Frete,  '@E 999,999,999.99'),;
								Transform( (TMPQ->VALOR+TMPQ->Despesa+TMPQ->Frete) + TMPQ->ICMSST ,  '@E 999,999,999.99'),;
								Transform(TMPQ->QUANTDEV, '@E 99999999'),;
								Transform(TMPQ->VALORDEV,  '@E 999,999,999.99'),;
								cCodUnNeg,;
								cDesUnNeg})								
		ElseIf _opc = 2
		
			nValUnit := TMPQ->VALOR / TMPQ->QUANTIDADE
			nPos    := AScan( aOrigPV, {|x| Left(x,1) == TMPQ->Origem } )
			cORIGPV := IIF( nPos > 0, aOrigPV[nPos], '')
			
			DbSelectArea("SA3")
			DbSetOrder(1)
			cNomVend2 := ""
			If DbSeek(xFilial("SA3") + TMPQ->Vendedor2)
				cNomVend2 := AllTrim(SA3->A3_NOME)
			EndIf
			
			AAdd( _aCampos, {	TMPQ->Mes,;
								TMPQ->Data_Faturamento,;
								TMPQ->CANAL,;
								AllTrim(TMPQ->PRODUTO),;
								AllTrim(TMPQ->Descricao),;
								TMPQ->SEGMENTO,;
								TMPQ->CLIENTE,;
								TMPQ->LOJA,;
								Left(Posicione('SA1', 1, xFilial('SA1')+TMPQ->(CLIENTE+LOJA), 'A1_NOME'),60),;
								CHR(160)+TMPQ->CNPJ_CGC,;
								Transform(TMPQ->QUANTIDADE, '@E 99999999'),;
								Transform(TMPQ->VALOR, '@E 999,999,999.99'),;
								Transform(nValUnit, '@E 999,999,999.99'),;
								Transform(TMPQ->QUANTDEV, '@E 99999999'),;
								Transform(TMPQ->VALORDEV, '@E 999,999,999.99'),;
								TMPQ->Serie,;
								TMPQ->NotaFiscal + "/" + TMPQ->ItemNota,;
								TMPQ->Vendedor1,;
								TMPQ->NomeVend1,;
								TMPQ->Vendedor2,;
								cNomVend2,;
								Transform(TMPQ->Despesas,'@E 999,999,999.99'),;
								Transform(TMPQ->Frete,'@E 999,999,999.99'),;
								Iif(TMPQ->TES $ GetMv("MV_XF440IM"),;
									Transform(TMPQ->VALOR+TMPQ->Despesas+TMPQ->Frete+TMPQ->ICMSST,'@E 999,999,999.99'),;
									Transform(TMPQ->VALOR+TMPQ->Despesas+TMPQ->Frete,'@E 999,999,999.99')),;
								TMPQ->Pedido,;
								TMPQ->Pedido_Gar,;
								cORIGPV,;//1=Manual;2=Varejo;3=Hardware Avulso;4=Televendas;5=Atend.Externo;6=Contratos;7=Port.Assinaturas;8=Cursos;9=Port.SSL;0=Pto.Movel
								Posicione('SC6',1,xFilial("SC6")+TMPQ->Pedido+TMPQ->ITEM_PED+TMPQ->PRODUTO,'SC6->C6_PROGAR'),;
								cCodUnNeg,;
								cDesUnNeg})
		EndIf
	EndIf

	nLin++
	TMPQ->(dbSkip())
	//	_Count	:= _Count + 1
	
	//-- Movimenta Regua Processamento.
   	//IncRegua()

EndDo

//-- Gera a planilha para a maquina do usuario.
If mv_par09 == 1
	DlgToExcel( { {"ARRAY","Budget X Realizado", _aCabec, _aCampos} })
EndIf

SET DEVICE TO SCREEN

MS_FLUSH()

Return