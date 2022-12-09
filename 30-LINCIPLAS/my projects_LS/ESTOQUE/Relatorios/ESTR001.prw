#Include "RWMAKE.CH"

//=============================================================================================================//
// Programa : EXMOVTO1             Autor : Eduardo Felipe da Silva                          Data : 25/12/03    //
//=============================================================================================================//
// Objetivo : Apresentar o Saldo Inicial, Total de Entrada, Total de Saída e Saldo Final por produto e almoxa- //
//            rifado.                                                                                          //
//=============================================================================================================//
// Uso      : LASELVA LTDA.                                                                                    //
//=============================================================================================================//

User Function ESTR001()

//========================================================================//
//  Declaração de Variaveis                                               //
//========================================================================//

SetPrvt("LIMITE,TITULO,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("CSTRING,ARETURN,CPERG,NLASTKEY,NOMEPROG")
SetPrvt("CABEC1,CABEC2,NTIPO")
SetPrvt("WNREL,CPICT,IMPRIME,AORD,LEND,LABORTPRINT")
SetPrvt("NQUANT,NQUANTCLI,NTOTPROD,NTOTPRODZ,NTOTCLI,NTOTCLIZ")
SetPrvt("NSOMAPREC,NSOMAPREC1,CVENDEDOR,CCLIENTE,CLOJA,CPRODUTO,CQUERY,LAVAL,CFILI")
SetPrvt("_CFIL,_CNOM,_AFILIAIS,_CFILIAL")

cDesc1      := "Este programa tem como objetivo imprimir relatorio "
cDesc2      := "de acordo com os parametros informados pelo usuario."
cDesc3      := ""
cPict       := ""
Titulo      := "Relatório Movimentos por Produtos"
_nLin       := 80
imprime     := .T.
aOrd        := {}
lEnd        := .F.
lAbortPrint := .F.
limite      := 220
Tamanho     := "G"
nomeprog    := "EXMOVTO1" // Coloque aqui o nome do programa para impressao no cabecalho
nTipo       := 15
aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
nLastKey    := 0
wnrel       := "EXMOVTO1"// Coloque aqui o nome do arquivo usado para impressao em disco
cString     := "SB1"
cPerg       := Padr("EXMOV1",len(SX1->X1_GRUPO)," ")
cbCont      := 0
cbTxt       := ""
m_pag       := 1.1
nQTotIni    := 0
nVTotIni    := 0
nQTotEnt    := 0
nVTotEnt    := 0
nQTotSai    := 0
nVTotSai    := 0
nQTotFin    := 0
nVTotFin    := 0
nQTotIniT 	:= 0
nVTotIniT 	:= 0
nQTotEntT 	:= 0
nVTotEntT 	:= 0
nQTotSaiT 	:= 0
nVTotSaiT 	:= 0
nQTotFinT 	:= 0
nVTotFinT 	:= 0
cFili  		:= SPACE(2)
cProduto    := SPACE(13)
cLocal      := SPACE(2)

ValidPerg()
pergunte(cPerg,.F.)

//========================================================================//
//  Monta a interface padrao com o usuario...                             //
//========================================================================//

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27 .or. LastKey() == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27 .or. LastKey() == 27
	Set Filter to
   Return
Endif

                                                                           	
//========================================================================//
//  Processamento. RPTSTATUS monta janela com a regua de processamento.   //
//========================================================================//

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,_nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,_nLin)

Local aCampos	:= {}
Local aEstru	:= {}	
Local _cArq		:= "NEGLJ"+Substr(cNumEmp,3,2)+".DTC"
//Local _cArq		:= "TONI.DTC"
//Local _lGerArq	:= .F.

/*
If MsgYesNo("Deseja gerar arquivo de Movimentação?")

	_lGerArq	:= .T.	
	
	Ferase(_cArq)
	
	Aadd(aCampos, {"D3_FILIAL"	,		"C",	2,	0})
	Aadd(aCampos, {"D3_TM"		,		"C",	3,	0})
	Aadd(aCampos, {"D3_COD"		,		"C",	15,	0})
	Aadd(aCampos, {"D3_QUANT"	,		"N",	11,	2})
	Aadd(aCampos, {"D3_CUSTO1"	,		"N",	14,	2})
	Aadd(aCampos, {"D3_LOCAL"	,		"C",	2,	0})  
	Aadd(aCampos, {"D3_EMISSAO"	,		"D",	8,	0})    

	DbCreate(_cArq, aCampos)
	DbUseArea( .T.,, _cArq, "TMP", .F., .F. )
	
EndIf	
*/

SetRegua(Reccount())

//=============================================//
// QUERY PARA GERAR CADASTRO DE PRODUTOS       //
//=============================================//
	
dbSelectArea("SB1")
dbSelectArea("SB2")
cQuery := " SELECT B2_FILIAL, B2_COD, B2_LOCAL, B1_DESC "
cQuery += " FROM "
cQuery += RetSqlName("SB1")+" SB1 (NOLOCK),  "
cQuery += RetSqlName("SB2")+" SB2 (NOLOCK)   "
cQuery += " WHERE B2_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
	//cQuery += " WHERE B2_FILIAL  = '"+xFilial("SB2")+"'"
cQuery += " AND B2_COD  = B1_COD "
cQuery += " AND B2_COD   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND B1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND B2_LOCAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += " AND B1_TIPO  BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += " AND SB1.D_E_L_E_T_ = '' "
cQuery += " AND SB2.D_E_L_E_T_ = '' "
cQuery += " GROUP BY B2_FILIAL, B2_COD, B2_LOCAL, B1_DESC" 
cQuery += " ORDER BY B2_FILIAL, B2_COD, B2_LOCAL, B1_DESC"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRYB2', .F., .T.)

//=============================================//
// QUERY PARA GERAR SALDOS INICIAIS            //
//=============================================//

dFeAnt   := mv_Par01 - 1

dbSelectArea("SB9")
cQuery := " SELECT B9_FILIAL, B9_COD, B9_LOCAL, SUM (B9_QINI) B9_QINI, SUM (B9_VINI1) B9_VINI1 "
cQuery += " FROM "
cQuery += RetSqlName("SB9")+" SB9 (NOLOCK), "
cQuery += RetSqlName("SB1")+" SB1 (NOLOCK)  "
//cQuery += " WHERE B9_FILIAL  = '"+xFilial("SB9")+"'"
cQuery += " WHERE B9_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
cQuery += " AND B1_COD   = B9_COD "
cQuery += " AND B9_DATA = '"+DTOS(dFeAnt)+"'"
cQuery += " AND B1_COD   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND B1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND B9_LOCAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += " AND B1_TIPO  BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += " AND SB1.D_E_L_E_T_ = ''"
cQuery += " AND SB9.D_E_L_E_T_ = ''"
cQuery += " GROUP BY B9_FILIAL, B9_COD, B9_LOCAL "
cQuery += " ORDER BY B9_FILIAL, B9_COD, B9_LOCAL "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRYB9', .F., .T.)

dbSelectArea("QRYB9")
dbSetOrder()

aQRYB9  := {}
aAdd( aQRYB9, { "B9_FIL"  ,"C", 002, 0 } )
aAdd( aQRYB9, { "B9_COD"  ,"C", 015, 0 } )
aAdd( aQRYB9, { "B9_LOCAL","C", 002, 0 } )
aAdd( aQRYB9, { "B9_QINI" ,"N", 014, 3 } )
aAdd( aQRYB9, { "B9_VINI1","N", 014, 2 } )

cArqB9   := CriaTrab( aQRYB9, .T. )
dbUseArea(.T.,"DBFCDX", cArqB9, "QB9", .F. )

dbSelectArea("QB9")
cIndQB9   := CriaTrab(nil,.F.)
cOrdQB9   := "B9_FIL+B9_COD+B9_LOCAL"
IndRegua("QB9",cIndQB9,cOrdQB9,,,"Criando Indice Temporario..." )

//SetRegua(RecCount())
ProcRegua(RecCount())

dbSelectArea("QRYB9")
dbGoTop()
While !EOF()
//IncRegua()
IncProc('Saldo Inicial ==> Produto : '+QRYB9->B9_COD)
	dbSelectArea("QB9")
	Reclock("QB9",.T.)
	QB9->B9_FIL     := QRYB9->B9_FILIAL    
	QB9->B9_COD     := QRYB9->B9_COD    
	QB9->B9_LOCAL	:= QRYB9->B9_LOCAL
	QB9->B9_QINI	:= QRYB9->B9_QINI
	QB9->B9_VINI1 	:= QRYB9->B9_VINI1
	MSUNLOCK("QB9")
	dbSelectArea("QRYB9")
	dbSkip()
EndDo

//=============================================//
// QUERY PARA GERAR NOTAS FISCAIS DE ENTRADA   //
//=============================================//

dbSelectArea("SD1")
dbSelectArea("SF4")
cQuery := " SELECT  D1_FILIAL, D1_COD, D1_LOCAL, SUM (D1_QUANT) D1_QUANT, SUM (D1_CUSTO) D1_CUSTO "
cQuery += " FROM "
cQuery += RetSqlName("SD1")+" SD1 (NOLOCK), "
cQuery += RetSqlName("SB1")+" SB1 (NOLOCK), "
cQuery += RetSqlName("SF4")+" SF4 (NOLOCK)  "
//cQuery += " WHERE D1_FILIAL = '"+xFilial("SD1")+"'"
cQuery += " WHERE D1_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
cQuery += " AND D1_COD = B1_COD "
cQuery += " AND D1_TES = F4_CODIGO "
cQuery += " AND F4_ESTOQUE  = 'S' "  
cQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += " AND D1_COD     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND B1_GRUPO   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND D1_LOCAL   BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += " AND B1_TIPO    BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += " AND SD1.D_E_L_E_T_ = ''"
cQuery += " AND SB1.D_E_L_E_T_ = ''"
cQuery += " AND SF4.D_E_L_E_T_ = ''"
cQuery += " GROUP BY D1_FILIAL, D1_COD, D1_LOCAL "
cQuery += " ORDER BY D1_FILIAL, D1_COD, D1_LOCAL "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRYD1', .F., .T.)

dbSelectArea("QRYD1")
dbSetOrder()

aQRYD1  := {}
aAdd( aQRYD1, { "D1_FIL"  ,"C", 002, 0 } )
aAdd( aQRYD1, { "D1_COD"  ,"C", 015, 0 } )
aAdd( aQRYD1, { "D1_LOCAL","C", 002, 0 } )
aAdd( aQRYD1, { "D1_QUANT","N", 014, 3 } )
aAdd( aQRYD1, { "D1_CUSTO","N", 014, 2 } )

cArqD1   := CriaTrab( aQRYD1, .T. )
dbUseArea(.T.,"DBFCDX", cArqD1, "QD1", .F. )

dbSelectArea("QD1")
cIndQD1   := CriaTrab(nil,.F.)
cOrdQD1   := "D1_FIL+D1_COD+D1_LOCAL"
IndRegua("QD1",cIndQD1,cOrdQD1,,,"Criando Indice Temporario..." )

//SetRegua(RecCount())
ProcRegua(RecCount())
dbSelectArea("QRYD1")
dbGoTop()
While !EOF()
//IncRegua()
IncProc('Notas Fiscais Entradas ==> Produto : '+QRYD1->D1_COD)
	dbSelectArea("QD1")
	Reclock("QD1",.T.)
	QD1->D1_FIL     := QRYD1->D1_FILIAL    
	QD1->D1_COD     := QRYD1->D1_COD    
	QD1->D1_LOCAL	:= QRYD1->D1_LOCAL
	QD1->D1_QUANT   := QRYD1->D1_QUANT
	QD1->D1_CUSTO 	:= QRYD1->D1_CUSTO
	MSUNLOCK("QD1")
	dbSelectArea("QRYD1")
	dbSkip()
EndDo

//=============================================//
// QUERY PARA GERAR NOTAS FISCAIS DE SAIDA     //
//=============================================//

dbSelectArea("SD2")
cQuery := " SELECT  D2_FILIAL, D2_COD, D2_LOCAL, SUM (D2_QUANT) D2_QUANT, SUM (D2_CUSTO1) D2_CUSTO1 "
cQuery += " FROM "
cQuery += RetSqlName("SD2")+" SD2 (NOLOCK), "
cQuery += RetSqlName("SB1")+" SB1 (NOLOCK), "
cQuery += RetSqlName("SF4")+" SF4 (NOLOCK)  "
//cQuery += " WHERE D2_FILIAL = '"+xFilial("SD2")+"'"
cQuery += " WHERE D2_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
cQuery += " AND D2_COD  =  B1_COD "
cQuery += " AND D2_TES  =  F4_CODIGO "
cQuery += " AND F4_ESTOQUE  = 'S' "  
cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += " AND D2_COD     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND B1_GRUPO   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND D2_LOCAL   BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += " AND B1_TIPO    BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += " AND SD2.D_E_L_E_T_ = ''"
cQuery += " AND SB1.D_E_L_E_T_ = ''"
cQuery += " AND SF4.D_E_L_E_T_ = ''"
cQuery += " GROUP BY D2_FILIAL, D2_COD, D2_LOCAL "
cQuery += " ORDER BY D2_FILIAL, D2_COD, D2_LOCAL "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRYD2', .F., .T.)

dbSelectArea("QRYD2")
dbSetOrder()

aQRYD2  := {}
aAdd( aQRYD2, { "D2_FIL"   ,"C", 002, 0 } )
aAdd( aQRYD2, { "D2_COD"   ,"C", 015, 0 } )
aAdd( aQRYD2, { "D2_LOCAL ","C", 002, 0 } )
aAdd( aQRYD2, { "D2_QUANT ","N", 014, 3 } )
aAdd( aQRYD2, { "D2_CUSTO1","N", 014, 2 } )

cArqD2   := CriaTrab( aQRYD2, .T. )
dbUseArea(.T.,"DBFCDX", cArqD2, "QD2", .F. )

dbSelectArea("QD2")
cIndQD2   := CriaTrab(nil,.F.)
cOrdQD2   := "D2_FIL+D2_COD+D2_LOCAL"
IndRegua("QD2",cIndQD2,cOrdQD2,,,"Criando Indice Temporario..." )

ProcRegua(RecCount())
//SetRegua(RecCount())

dbSelectArea("QRYD2")
dbGoTop()
While !EOF()
//IncRegua()
IncProc('Notas Fiscais Saidas ==> Produto : '+QRYD2->D2_COD)
	dbSelectArea("QD2")
	Reclock("QD2",.T.)
	QD2->D2_FIL     := QRYD2->D2_FILIAL    
	QD2->D2_COD     := QRYD2->D2_COD    
	QD2->D2_LOCAL	:= QRYD2->D2_LOCAL
	QD2->D2_QUANT   := QRYD2->D2_QUANT
	QD2->D2_CUSTO1	:= QRYD2->D2_CUSTO1
	MSUNLOCK("QD2")
	dbSelectArea("QRYD2")
	dbSkip()
EndDo


//=============================================//
// QUERY PARA GERAR MOVIMENTOS INTERNOS        //
//=============================================//

dbSelectArea("SD3")
cQuery := " SELECT D3_FILIAL, D3_COD, D3_LOCAL, D3_TM, SUBSTRING(D3_CF,1,1) D3_CF, SUM (D3_QUANT) D3_QUANT, SUM (D3_CUSTO1) D3_CUSTO1 "
cQuery += " FROM "
cQuery += RetSqlName("SD3")+" SD3 (NOLOCK), "
cQuery += RetSqlName("SB1")+" SB1 (NOLOCK)  "
//cQuery += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'"
cQuery += " WHERE D3_FILIAL BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
cQuery += " AND D3_COD  =  B1_COD "
cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery += " AND D3_COD     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += " AND B1_GRUPO   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += " AND D3_LOCAL   BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += " AND B1_TIPO    BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
cQuery += " AND D3_ESTORNO <> 'S'"
cQuery += " AND SD3.D_E_L_E_T_ = ''"
cQuery += " AND SB1.D_E_L_E_T_ = ''"
cQuery += " GROUP BY D3_FILIAL, D3_COD, D3_LOCAL, D3_TM, D3_CF "
cQuery += " ORDER BY D3_FILIAL, D3_COD, D3_LOCAL, D3_TM, D3_CF "
// Adicionado o campo D3_TM para validar tipo da movimentacao (Wagner Cherubelli - 31/03/05)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QRYD3', .F., .T.)
dbSelectArea("QRYD3")
dbSetOrder()

aQRYD3  := {}
aAdd( aQRYD3, { "D3_FIL"	,"C", 002, 0 } )
aAdd( aQRYD3, { "D3_COD"	,"C", 015, 0 } )
aAdd( aQRYD3, { "D3_LOCAL" 	,"C", 002, 0 } )
aAdd( aQRYD3, { "D3_TM" 	,"C", 003, 0 } )
aAdd( aQRYD3, { "D3_CF" 	,"C", 001, 0 } )
aAdd( aQRYD3, { "D3_QUANT" 	,"N", 014, 3 } )
aAdd( aQRYD3, { "D3_CUSTO1"	,"N", 014, 2 } )

cArqD3  := CriaTrab( aQRYD3, .T. )
dbUseArea(.T.,"DBFCDX", cArqD3, "QD3", .F. )

dbSelectArea("QD3")
cIndQD3   := CriaTrab(nil,.F.)
cOrdQD3   := "D3_FIL+D3_COD+D3_LOCAL+D3_TM+D3_CF"
IndRegua("QD3",cIndQD3,cOrdQD3,,,"Criando Indice Temporario..." )

ProcRegua(RecCount())
//SetRegua(RecCount())

dbSelectArea("QRYD3")
dbGoTop()
While !EOF()
//IncRegua()
IncProc('Movimentos Internos ==> Produto : '+QRYD3->D3_COD)
	dbSelectArea("QD3")
	dbSetOrder(1)                 
    	If dbSeek(QRYD3->D3_FILIAL+QRYD3->D3_COD+QRYD3->D3_LOCAL+QRYD3->D3_TM+QRYD3->D3_CF)
   		Reclock("QD3",.F.)
		QD3->D3_QUANT   := QD3->D3_QUANT  + QRYD3->D3_QUANT
		QD3->D3_CUSTO1	:= QD3->D3_CUSTO1 + QRYD3->D3_CUSTO1
		MSUNLOCK("QD3") 	
   	Else	
   		Reclock("QD3",.T.)
   		QD3->D3_FIL     := QRYD3->D3_FILIAL    		
		QD3->D3_COD     := QRYD3->D3_COD    
		QD3->D3_LOCAL	:= QRYD3->D3_LOCAL
		QD3->D3_TM	:= QRYD3->D3_TM
		QD3->D3_CF	:= QRYD3->D3_CF
		QD3->D3_QUANT   := QRYD3->D3_QUANT
		QD3->D3_CUSTO1	:= QRYD3->D3_CUSTO1
		MSUNLOCK("QD3")
	EndIf	
	dbSelectArea("QRYD3")
	dbSkip()
EndDo 

Aadd(aCampos, {"D3_FILIAL"	,		"C",	2,	0})
Aadd(aCampos, {"D3_TM"		,		"C",	3,	0})
Aadd(aCampos, {"D3_COD"		,		"C",	15,	0})
Aadd(aCampos, {"D3_QUANT"	,		"N",	11,	2})
Aadd(aCampos, {"D3_CUSTO1"	,		"N",	14,	2})
Aadd(aCampos, {"D3_LOCAL"	,		"C",	2,	0})  
Aadd(aCampos, {"D3_EMISSAO"	,		"D",	8,	0})    
	
cArqT  := CriaTrab( aCampos, .T. )
dbUseArea(.T.,"DBFCDX", cArqT, "TRB", .F. )


DbSelectArea("QRYB2")
DbGoTop()  

While !Eof()

_cFilial := QRYB2->B2_FILIAL

	While !Eof() .And. _cFilial == QRYB2->B2_FILIAL
   
		IncRegua()      // Termometro de Impressao

		If lAbortPrint
			@_nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
	
   		If _nLin > 63 // Salto de Página. Neste caso o formulario tem 55 linhas...
			fCabecalho()//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			_nLin:= 9
		EndIf

		nQtdIni  := 0
		nVlrIni  := 0
		nQtdEnt  := 0
		nVlrEnt  := 0
		nQtdSai  := 0
		nVlrSai  := 0
		nQtdFin  := 0
		nVlrFin  := 0
	   	nQtdSB9  := 0
	   	nVlrSB9  := 0
   		nQtdSD1  := 0
	   	nVlrSD1  := 0 
   		nQtdSD2  := 0 
	   	nVlrSD2  := 0 
	   	nQtdED3  := 0 
   		nVlrED3  := 0
	   	nQtdSD3  := 0 
	   	nVlrSD3  := 0  
	   	
		DbSelectArea("QB9")
		DbSetOrder(1)                 
    		If DbSeek(QRYB2->B2_FILIAL+QRYB2->B2_COD+QRYB2->B2_LOCAL)
    			nQtdSB9  :=  QB9->B9_QINI
    			nVlrSB9  :=  QB9->B9_VINI1
		EndIf
	
		DbSelectArea("QD1")
		DbSetOrder(1)                 
    	If DbSeek(QRYB2->B2_FILIAL+QRYB2->B2_COD+QRYB2->B2_LOCAL)
    		nQtdSD1  :=  QD1->D1_QUANT
	    	nVlrSD1  :=  QD1->D1_CUSTO
    	EndIf

		DbSelectArea("QD2")
		DbSetOrder(1)                 
	    If DbSeek(QRYB2->B2_FILIAL+QRYB2->B2_COD+QRYB2->B2_LOCAL)
    		nQtdSD2  :=  QD2->D2_QUANT
    		nVlrSD2  :=  QD2->D2_CUSTO1
	    EndIf
	                 
		DbSelectArea("QD3")
		DbSetOrder(1)                 
		If DbSeek(QRYB2->B2_FILIAL+QRYB2->B2_COD+QRYB2->B2_LOCAL)
			While !Eof() .AND. QRYB2->B2_FILIAL == QD3->D3_FIL .AND. QRYB2->B2_COD = QD3->D3_COD .AND. QRYB2->B2_LOCAL = QD3->D3_LOCAL
				// Validacao da TM - Se for maior que "500", TIRA do estoque, se for menor DEVOLVE(SOMA) no estoque.
				If QD3->D3_TM < "500"
    			    // If QD3->D3_CF <> "R" // Validacao pela TM
    				nQtdED3 :=  nQtdED3 + QD3->D3_QUANT
    				nVlrED3 :=  nVlrED3 + QD3->D3_CUSTO1
    			Else
    	 			nQtdSD3 :=  nQtdSD3 + QD3->D3_QUANT
    				nVlrSD3 :=  nVlrSD3 + QD3->D3_CUSTO1
    			EndIf	
    			DbSkip()
    			Loop                                         
    		EndDo	
    	EndIf 
	
		cFili    :=  QRYB2->B2_FILIAL  		 	
		cProduto :=  QRYB2->B2_COD
    	cLocal   :=  QRYB2->B2_LOCAL
	    cDescr   :=  QRYB2->B1_DESC

    
    	nQtdIni  :=  Round (nQtdSB9,3)
	    nVlrIni  :=  Round (nVlrSB9,2)
    	nCusIni  :=  Round (nVlrSB9 / nQtdSB9 ,4)

		nQtdEnt	 :=  Round (nQtdSD1 + nQtdED3,3)
    	nVlrEnt	 :=  Round (nVlrSD1 + nVlrED3,2)
	    nCusEnt  :=  Round (nVlrEnt / nQtdEnt ,4)
 
		nQtdSai	 :=  Round (nQtdSD2 + nQtdSD3,3) 
	    nVlrSai	 :=  Round (nVlrSD2 + nVlrSD3,2)
	    nCusSai  :=  Round (nVlrSai / nQtdSai ,4)

		nQtdFin	:=  Round (nQtdIni + nQtdEnt - If(nQtdSai<0,nQtdSai*(-1),nQtdSai),3)
	    nVlrFin	:=  Round (nVlrIni + nVlrEnt - If(nVlrSai<0,nVlrSai*(-1),nVlrSai),2)
    	nCusFin  :=  Round (nVlrFin / nQtdFin, 4)  
		
  	    //=============================================//
	    // Imprimir apenas negativos ? ( SIM / NÃO )         //
	    //===================================================//
		If MV_PAR11 == 1 .and. nQtdFin >= 0  
	 		DbSelectArea("QRYB2")
			DbSkip()
	    	Loop                                         
		EndIf
 
	   	//===================================================//
	   	// Imprimir apenas os produtos q/ foram movimentados.//
	   	//===================================================//  
		If MV_PAR11 == 2 .and. nQtdIni = 0 .and. nVlrIni = 0 .and. nQtdEnt = 0 .and. nVlrEnt = 0 .and. nQtdSai = 0 .and. nVlrSai = 0 .and. nQtdFin = 0  
 			DbSelectArea("QRYB2")
			DbSkip()
	    	Loop                                         
		EndIf
		
		//===================================================//
		// Impressão dos Produtos conforme parametrização.   //
		//===================================================//
		@ _nLin,001 PSAY cFili		                            // Código do Produto		
		@ _nLin,004 PSAY cProduto                               // Código do Produto
	 	@ _nLin,018 PSAY AllTrim(cLocal)                        // Almoxarifado
 		@ _nLin,021 PSAY SUBSTR(cDescr,1,30)                    // Descrição do Produto
    	
    	//====================================//    
	    // Saldo Inicial                      //
	    //====================================//
  		@ _nLin,052 PSAY nQtdIni PICTURE "@E 99,999,999.999"  // Quantidade  
	  	@ _nLin,067 PSAY nCusIni PICTURE "@E    999,999.9999" // Custo médio 
	  	@ _nLin,080 PSAY nVlrIni PICTURE "@E 99,999,999.99"   // Valor       
    	//====================================//    
		// Entradas por Nota Fiscal ou Ajuste //
	    //====================================//    	
	  	@ _nLin,094 PSAY nQtdEnt PICTURE "@E 99,999,999.999"  // Quantidade  
	  	@ _nLin,109 PSAY nCusEnt PICTURE "@E    999,999.9999" // Custo médio 
	  	@ _nLin,122 PSAY nVlrEnt PICTURE "@E 99,999,999.99"   // Valor       
    	//====================================//    
		// Saídas por Nota Fiscal ou Ajuste   //
	    //====================================//    	
	  	@ _nLin,136 PSAY If(nQtdSai<0,nQtdSai*(-1),nQtdSai) PICTURE "@E 99,999,999.999"  // Quantidade  
	  	@ _nLin,151 PSAY If(nCusSai<0,nCusSai*(-1),nCusSai) PICTURE "@E    999,999.9999" // Custo médio 
	  	@ _nLin,164 PSAY If(nVlrSai<0,nVlrSai*(-1),nVlrSai) PICTURE "@E 99,999,999.99"   // Valor       
	    //====================================//    
	    // Saldo Final                        //
	    //====================================//
	  	@ _nLin,178 PSAY nQtdFin PICTURE "@E 99,999,999.999"  // Quantidade  
	  	@ _nLin,193 PSAY nCusFin PICTURE "@E 999,999.9999" // Custo médio 	
  		@ _nLin,206 PSAY nVlrFin PICTURE "@E 99,999,999.99"   // Valor       
	           
		nQTotIni := nQTotIni + nQtdIni
		nVTotIni := nVTotIni + nVlrIni
		nQTotEnt := nQTotEnt + nQtdEnt
		nVTotEnt := nVTotEnt + nVlrEnt
		nQTotSai := nQTotSai + If(nQtdSai<0,nQtdSai*(-1),nQtdSai)
		nVTotSai := nVTotSai + If(nVlrSai<0,nVlrSai*(-1),nVlrSai)
		nQTotFin := nQTotFin + nQtdFin 
		nVTotFin :=	nVTotFin + nVlrFin 
		
// r.felipelli
// verifica se o produto é um dos que necessitam ajuste no saldo e executa
// store procedure.
		if mv_par14 == 1 //pode gravar a procedure
 			if nQtdFin == 0        
				if nVlrFin <> 0
					If TCSPExist("SP_ARROMBA_ESTOQUE") // Nome da procedure gentilmente criado pelo sr.jonas
					   aRet := TCSPExec("SP_ARROMBA_ESTOQUE",cFili,cProduto,dtos(mv_par02),nVlrFin,nQtdFin)
					EndIf
				endif
			endif
			if nQtdFin > 0        
				if nVlrFin < 0
					If TCSPExist("SP_ARROMBA_ESTOQUE") // Nome da procedure gentilmente criado pelo sr.jonas
					   aRet := TCSPExec("SP_ARROMBA_ESTOQUE",cFili,cProduto,dtos(mv_par02),nVlrFin,nQtdFin)
					EndIf
				endif
			endif
		endif

				
		/*
		If _lGerArq	
		*/
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			Replace TRB->D3_FILIAL	With xFilial("SB2")
			Replace TRB->D3_TM      With "300"
			Replace TRB->D3_COD     With cProduto
			Replace TRB->D3_QUANT	With nQtdFin
			Replace TRB->D3_CUSTO1	With nVlrFin 
			Replace TRB->D3_LOCAL   With "01"
			Replace TRB->D3_EMISSAO With dDatabase
			MsUnLock()
		/*
		EndIf	
		*/
		    	
		_nLin := _nLin + 1  // Pula Linha
	
		DbSelectArea("QRYB2")
		DbSkip()		
	EndDo
	
	//If _lGerArq
		//MsgInfo("Arquivo de Negativos: "+_cArq)
	//EndIf

	_nLin := _nLin + 1 // Pula Linha

	//===================================================//
	// Impressão da Linha c/ Total Geral dos Produtos    //
	//===================================================//
	@ _nLin,001 PSAY "TOTAL FILIAL: "+PFilial(_cFilial)  
	//====================================//    
	// Saldo Inicial                      //
	//====================================//    	
	@ _nLin,053 PSAY nQTotIni PICTURE "@E 99,999,999.999" // Total da Quantidade
	@ _nLin,081 PSAY nVTotIni PICTURE "@E 99,999,999.99"  // Total do Valor	
	//====================================//    
	// Entradas por Nota Fiscal ou Ajuste //
	//====================================//    	
	@ _nLin,095 PSAY nQTotEnt PICTURE "@E 99,999,999.999" // Total da Quantidade
	@ _nLin,123 PSAY nVTotEnt PICTURE "@E 99,999,999.99"  // Total do Valor
	//====================================//    
	// Saídas por Nota Fiscal ou Ajuste   //
	//====================================//    	
	@ _nLin,137 PSAY nQTotSai PICTURE "@E 99,999,999.999" // Total da Quantidade
	@ _nLin,165 PSAY nVTotSai PICTURE "@E 99,999,999.99"  // Total do Valor
	//====================================//    
	// Saldo Final                        //
	//====================================//    	
	@ _nLin,179 PSAY nQTotFin PICTURE "@E 99,999,999.999" // Total da Quantidade
	@ _nLin,207 PSAY nVTotFin PICTURE "@E 99,999,999.99"  // Total do Valor
	
	nQTotIniT := nQTotIniT + nQTotIni
	nVTotIniT := nVTotIniT + nVTotIni
	nQTotEntT := nQTotEntT + nQTotEnt
	nVTotEntT := nVTotEntT + nVTotEnt
	nQTotSaiT := nQTotSaiT + nQTotSai
	nVTotSaiT := nVTotSaiT + nVTotSai
	nQTotFinT := nQTotFinT + nQTotFin
	nVTotFinT := nVTotFinT + nVTotFin
	
	nQTotIni := 0
	nVTotIni := 0
	nQTotEnt := 0
	nVTotEnt := 0
	nQTotSai := 0
	nVTotSai := 0
	nQTotFin := 0
	nVTotFin :=	0
	
	_nLin := _nLin + 1
	@ _nLin,001 PSay Replicate("-",Limite)
	_nLin := _nLin + 1

DbSelectArea("QRYB2")
//DbSkip()
EndDo


If MsgYesNo("Deseja gerar arquivo de Movimentação?")
    
    Ferase(_cArq)
	
	Aadd(aEstru, {"D3_FILIAL"	,		"C",	2,	0})
	Aadd(aEstru, {"D3_TM"		,		"C",	3,	0})
	Aadd(aEstru, {"D3_COD"		,		"C",	15,	0})
	Aadd(aEstru, {"D3_QUANT"	,		"N",	11,	2})
	Aadd(aEstru, {"D3_CUSTO1"	,		"N",	14,	2})
	Aadd(aEstru, {"D3_LOCAL"	,		"C",	2,	0})  
	Aadd(aEstru, {"D3_EMISSAO"	,		"D",	8,	0}) 

	DbCreate(_cArq, aEstru)
	DbUseArea( .T.,, _cArq, "TMP", .F., .F. )
	
	DbSelectArea("TRB")	
	TRB->( DbGoTop() )
	While TRB->( !Eof() )
	
	    DbSelectArea("TMP")
	    RecLock("TMP",.T.)
		Replace TMP->D3_FILIAL	With TRB->D3_FILIAL
		Replace TMP->D3_TM      With TRB->D3_TM
		Replace TMP->D3_COD     With TRB->D3_COD
		Replace TMP->D3_QUANT	With TRB->D3_QUANT*-1
		Replace TMP->D3_CUSTO1	With TRB->D3_CUSTO1*-1
		Replace TMP->D3_LOCAL   With TRB->D3_LOCAL
		Replace TMP->D3_EMISSAO With TRB->D3_EMISSAO
		TMP->( MsUnLock() )
		
		TRB->( DbSkip() )
		
	EndDo
	
	MsgInfo("Arquivo de Negativos: "+_cArq)
	
	DbSelectArea("TMP")
	DbCloseArea()
	
EndIf

DbSelectArea("TRB")
DbCloseArea()

_nLin := _nLin + 1

//===================================================//
// Impressão da Linha c/ Total Geral dos Produtos    //
//===================================================//
@ _nLin,001 PSAY " T O T A L  G E R A L ------->"
//====================================//    
// Saldo Inicial                      //
//====================================//    	
@ _nLin,053 PSAY nQTotIniT PICTURE "@E 99,999,999.999" // Total da Quantidade
@ _nLin,081 PSAY nVTotIniT PICTURE "@E 99,999,999.99"  // Total do Valor	
//====================================//    
// Entradas por Nota Fiscal ou Ajuste //
//====================================//    	
@ _nLin,095 PSAY nQTotEntT PICTURE "@E 99,999,999.999" // Total da Quantidade
@ _nLin,123 PSAY nVTotEntT PICTURE "@E 99,999,999.99"  // Total do Valor
//====================================//    
// Saídas por Nota Fiscal ou Ajuste   //
//====================================//    	
@ _nLin,137 PSAY nQTotSaiT PICTURE "@E 99,999,999.999" // Total da Quantidade
@ _nLin,165 PSAY nVTotSaiT PICTURE "@E 99,999,999.99"  // Total do Valor
//====================================//    
// Saldo Final                        //
//====================================//    	
@ _nLin,179 PSAY nQTotFinT PICTURE "@E 99,999,999.999" // Total da Quantidade
@ _nLin,207 PSAY nVTotFinT PICTURE "@E 99,999,999.99"  // Total do Valor


Set Device to Screen

//=============================================================================//
//  Se impressao em Disco, chama Spool                                         //
//=============================================================================//

If aReturn[5] == 1
   Set Printer To
   DBCommitAll()
   ourspool(wnrel)
Endif

//=============================================================================//
//  Libera relatorio para Spool da Rede                                        //
//=============================================================================//


dbSelectArea("QRYB2")
dbCloseArea()
dbSelectArea("QRYB9")
dbCloseArea()
dbSelectArea("QB9")
dbCloseArea()
dbSelectArea("QRYD1")
dbCloseArea()
dbSelectArea("QD1")
dbCloseArea()
dbSelectArea("QRYD2")
dbCloseArea()
dbSelectArea("QD2")
dbCloseArea()    
dbSelectArea("QRYD3")
dbCloseArea()
dbSelectArea("QD3")
dbCloseArea()  


MS_FLUSH()

Return


//=============================================================================================================//
// Função   : fCabecalho           Autor : Eduardo Felipe da Silva                          Data : 25/12/03    //
//=============================================================================================================//
// Objetivo : Imprimir cabeçalho                                                                               //
//=============================================================================================================//
// Uso      : LASELVA LTDA.                                                                                    //
//=============================================================================================================//

Static Function fCabecalho()

cabec1 := " Periodo : "+Dtoc(mv_Par01)+" a "+Dtoc(mv_Par02)+"                                       I N I C I A L                            E N T R A D A S                             S A I D A S                                F I N A L        "
//cabec2 := " PRODUTO     LOCAL  DESCRICAO                                 QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL"
cabec2 := " FIL PRODUTO       LC DESCRICAO                               QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL"
nLin   := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin   := nLin + 1

//==============================================================//
// Cabec(cTitulo, cTexto1, cTexto2, cProg, cLargura, cControle) //
//==============================================================//
// Parametros :                                                 //
// cT¡tulo   - Titulo do Relatorio                              //
// cTexto1   - Extenso da primeira linha do cabe‡alho           //
// cTexto2   - Extenso da segunda linha do cabe‡alho            //
// cProg     - Nome do Programa                                 //
// cLargura  - Largura do relatorio (P/ M/ G)                   //
// cControle - Caractere de controle da impressora (numerico)   //
//==============================================================//

/*
        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Periodo : 01/10/2003 a 31/10/2003                                    I N I C I A L                            E N T R A D A S                             S A I D A S                                F I N A L            "
PRODUTO    LOCAL   DESCRICAO                                 QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
XXXXXXXXXXXXX XX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99,999,999.999 999,999.9999 99,999,999.99 99,999,999.999 999,999.9999 99,999,999.99 99,999,999.999 999,999.9999 99,999,999.99 99,999,999.999 999,999.9999 99,999,999.99 

1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
*/


/*
        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Periodo : 01/10/2003 a 31/10/2003                                    I N I C I A L                            E N T R A D A S                             S A I D A S                                F I N A L            "
FIL PRODUTO       LC DESCRICAO                               QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL           QTDE        C.UNI         TOTAL"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
XX XXXXXXXXXXXXX XX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99,999,999.999 999,999.9999 99,999,999.99 99,999,999.999 999,999.9999 99,999,999.99 99,999,999.999 999,999.9999 99,999,999.99 99,999,999.999 999,999.9999 99,999,999.99 

1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
*/


Return Nil  

/*
+======================+================+
|Autor: Antonio Carlos | Data: 12/01/05 |
+=======================================+
|Descricao: Busca o nome da filial      |
+=======================================+
*/

Static Function PFilial(_cFil) 


cAlias := Alias()
cIndex := IndexOrd()
nRecno := RecNo()
_aFiliais := {}

DbSelectArea("SM0")
DbGoTop()
While !Eof()
	Aadd(_aFiliais,{SM0->M0_CODIGO,;
					SM0->M0_CODFIL,;
					SM0->M0_FILIAL,;
					SM0->M0_NOMECOM})
	DbSelectArea("SM0")
	DbSkip()
EndDo			

For ni := 1 To Len(_aFiliais)
	If _cFil == _aFiliais[ni,2]
		_cNom := _aFiliais[ni,3]
		Exit
	Else
		_cNom := " "	
	EndIf
Next ni		

DbSelectArea(cAlias)
DbSetOrder(cIndex)
DbGoTo(nRecno)

Return(_cNom)

//=============================================================================================================//
// Função   : ValidPerg            Autor : Eduardo Felipe da Silva                          Data : 25/12/03    //
//=============================================================================================================//
// Objetivo : Verificar as perguntas incluindo-as caso não existam                                             //
//=============================================================================================================//
// Uso      : LASELVA LTDA.                                                                                    //
//=============================================================================================================//

Static Function ValidPerg()
_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)

aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da Data            ?","Da Data            ?","Da Data            ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Data         ?","Ate a Data         ?","Ate a Data         ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Produto         ?","Do Produto         ?","Do Produto         ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
AADD(aRegs,{cPerg,"04","Ate o Produto      ?","Ate o Produto      ?","Ate o Produto      ?","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
AADD(aRegs,{cPerg,"05","Do Grupo           ?","Do Grupo           ?","Do Grupo           ?","mv_ch5","C",04,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
AADD(aRegs,{cPerg,"06","Ate o Grupo        ?","Ate o Grupo        ?","Ate o Grupo        ?","mv_ch6","C",04,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
AADD(aRegs,{cPerg,"07","Do Local           ?","Do Local           ?","Do Local           ?","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Local          ?","Ate Local          ?","Ate Local          ?","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Do Tipo            ?","Do Tipo            ?","Do Tipo            ?","mv_ch9","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","02  ","",""})
AADD(aRegs,{cPerg,"10","Ate o Tipo         ?","Ate o Tipo         ?","Ate o Tipo         ?","mv_chA","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","02  ","",""})
AADD(aRegs,{cPerg,"11","Saldos Negativos   ?","Saldos Negativos   ?","Saldos Negativos   ?","mv_chB","N", 1,0,1,"C","","mv_par11","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Da Filial          ?","Da Filial          ?","Da Filial          ?","mv_chC","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Ate Filial         ?","Ate Filial         ?","Ate Filial         ?","mv_chD","C",02,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Alimenta Procedure ?","Alimenta Procedure ?","Alimenta Procedure ?","mv_chE","N", 1,0,1,"C","","mv_par14","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","",""})

For I:=1 to Len(aRegs)
   If !DBSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      //For j:=1 to Max(FCount(), Len(aRegs[i]))
      For j:=1 to Len(aRegs[i])
         FieldPut(j,aRegs[i,j])
      Next
      MsUnlock()
   Endif
Next

DBSelectArea(_sAlias)

Return  
