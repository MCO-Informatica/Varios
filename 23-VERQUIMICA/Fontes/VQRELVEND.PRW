#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "Protheus.ch"
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ VQRELVEND   Autor  ≥Felipe Pieroni    ∫ Data ≥  06/02/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ RelatÛrio que exporta direto para o Excel                   ±±
±±∫          ≥ 															  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP8                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function VQRELVEND()

Local a_area   := {}

//Local nLin          := 80

Private	cPerg := "VQ_MV_EST0"



PutSX1(cPerg,"01","Tipo"	  ,"","","MV_CH1","N",01,0,1,"C",""							 ,""   ,"","","MV_PAR01","Policia Federal","","","","Exercito","","","Policia Civil","","","Todos","","","","","","","","")
PutSX1(cPerg,"02","Grupo de"  ,"","","MV_CH2","C",5,0,0,"G","Vazio() .Or. ExistCpo('SBM')","SBM","","","MV_PAR02",""		   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"03","Grupo Ate" ,"","","MV_CH3","C",5,0,0,"G","Vazio() .Or. ExistCpo('SBM')","SBM","","","MV_PAR03",""	  	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"04","Periodo De","","","MV_CH4","D",08,0,0,"G",""							 ,""   ,"","","MV_PAR04",""   	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"05","Periodo Ate","","","MV_CH5","D",08,0,0,"G",""							 ,""   ,"","","MV_PAR05",""   	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")

PutSX1(cPerg,"06","Cliente De"  ,"","","MV_CH6","C",6,0,0,"G","Vazio() .Or. ExistCpo('SA1')","SA1","","","MV_PAR06",""		   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"07","Loja De" ,"","","MV_CH7","C",2,0,0,"G","","","","","MV_PAR07",""	  	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"08","Cliente Ate"  ,"","","MV_CH8","C",6,0,0,"G","Vazio() .Or. ExistCpo('SA1')","SA1","","","MV_PAR08",""		   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"09","Loja Ate" ,"","","MV_CH9","C",2,0,0,"G","","","","","MV_PAR09",""	  	   ,"","","",""	      ,"","",""  ,"","",""		,"","","","","","","","")
PutSX1(cPerg,"10","Movimento"	  ,"","","MV_CHA","N",01,0,1,"C",""							 ,""   ,"","","MV_PAR10","Entrada","","","","Saida","","","Dev. Compras","","","Dev Vendas","","","","","","","","")



If !Pergunte(cPerg,.T.)
	Return()
EndIF

//a_area := getarea()


//GeraPlanila()
Processa({|| PVQRELVD() }, "Relatorio em Excel", "Exportando Dados...",.T.)

//Restarea(a_area)

Return(Nil)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ GeraPlanila∫ Autor  ≥Felipe Pieroni    ∫ Data ≥  19/09/08  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function GeraPlanila(Cabec1,Cabec2,Titulo,nLin) //()

Local _aArea 	:= GetArea()      // salvo area atual
Local aStru     := {}
Local _lRet		:= .T.
Local nLinFim   := 65
Local oExcel

Private lAbortPrint := .F.

Private cPeriodoDe  := dtos(MV_PAR04)
Private cPeriodoAte := dtos(MV_PAR05)


cArqEDI	:= "LOTEBF"
                                        
AADD(aStru, {"EMISSAO"	,"D",008,00})
AADD(aStru, {"NOTA"	    ,"C",009,00})	
AADD(aStru, {"CNPJ_CLI" ,"C",014,00})	

AADD(aStru, {"CLI_FOR" ,"C",040,00})	
AADD(aStru, {"ENDERECO" ,"C",040,00})	
AADD(aStru, {"BAIRRO" ,"C",030,00})	
AADD(aStru, {"CIDADE" ,"C",030,00})	

AADD(aStru, {"TRANSPOR" ,"C",050,00})	
AADD(aStru, {"CNPJ_TRAN","C",014,00})	
AADD(aStru, {"CPF_TRAN" ,"C",014,00})	
AADD(aStru, {"CPF_PESS" ,"C",014,00})	
AADD(aStru, {"NCM"	     ,"C",015,00})	
AADD(aStru, {"CONCENT" ,"N",05,02})	
AADD(aStru, {"DENSID" ,"N",05,02})	
AADD(aStru, {"PRODUTO"	,"C",015,00})	
AADD(aStru, {"GRUPO"	,"C",015,00})	
AADD(aStru, {"DESCRICAO","C",020,00})	
AADD(aStru, {"QUANTIDAD","N",014,03})
AADD(aStru, {"UM"	    ,"C",002,00})	
AADD(aStru, {"CFOP"		,"C",004,00})	

cArqTemp := CriaTrab(aStru,.T.)
DbuseArea(.T.,,cArqTemp,"_TRX")

If MV_PAR10 = 1                            

	_cQry :=	" SELECT  D1_DTDIGIT AS EMISSAO, D1_DOC AS DOC, A2_CGC AS CNPJ, A2_NOME AS NOME, " 
	_cQry +=	" A2_END AS ENDER, A2_BAIRRO AS BAIRRO, A2_MUN AS CIDADE, F1_TRANSP AS TRANSP, B1_POSIPI, " 
	_cQry +=	" B5_CONCENT, B5_DENSID, D1_COD AS PROD, B1_DESC, D1_UM AS UM, B1_GRUPO AS GRUPO, B5_CEME, "
	_cQry +=	" BM_DESC, D1_QUANT AS QUANT, D1_CF AS CF, B1_POSIPI "
	_cQry +=	" from "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF1")+" SF1, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SB5")+" SB5, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SF4")+" SF4, "+RetSqlName("SA2")+" SA2 "
	_cQry +=	" WHERE SB1.D_E_L_E_T_ <> '*'  "
	_cQry +=	" AND SD1.D_E_L_E_T_  <> '*' "
	_cQry +=	" AND SF1.D_E_L_E_T_  <> '*' "
	_cQry +=	" AND SF4.D_E_L_E_T_  <> '*' "	
	_cQry +=	" AND SA2.D_E_L_E_T_  <> '*' "
	_cQry +=	" AND SB5.D_E_L_E_T_  <> '*' "
	_cQry +=	" AND SBM.D_E_L_E_T_  <> '*' " 
	
	_cQry +=	" AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	_cQry +=	" AND SD1.D1_FILIAL = '"+xFilial("SD1")+"' "
	_cQry +=	" AND SF1.F1_FILIAL = '"+xFilial("SF1")+"' "
	_cQry +=	" AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
	_cQry +=	" AND SA2.A2_FILIAL = '"+xFilial("SA2")+"' "
	_cQry +=	" AND SB5.B5_FILIAL = '"+xFilial("SB5")+"' "
	_cQry +=	" AND SBM.BM_FILIAL = '"+xFilial("SBM")+"' "
	
	
	

	_cQry +=	" AND D1_DOC = F1_DOC "
	_cQry +=	" AND D1_SERIE = F1_SERIE "
	_cQry +=	" AND D1_FORNECE = F1_FORNECE "
	_cQry +=	" AND D1_LOJA = F1_LOJA "
                                       
	_cQry +=	" AND D1_TES = F4_CODIGO "

	_cQry +=	" AND D1_FORNECE = A2_COD "
	_cQry +=	" AND D1_LOJA = A2_LOJA "

	_cQry +=	" AND D1_COD = B1_COD " 

	_cQry +=	" AND B1_COD = B5_COD "

	_cQry +=	" AND B1_GRUPO = BM_GRUPO "           
	
	_cQry +=	" AND F4_ESTOQUE = 'S' "	

	_cQry +=	" AND D1_TIPO = 'N' "
	_cQry +=	" AND D1_FORNECE BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR08+"' "
	_cQry +=	" AND D1_LOJA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR09+"' "	
	_cQry +=	" AND B1_GRUPO BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	_cQry +=	" AND D1_DTDIGIT BETWEEN '"+cPeriodoDe+"' AND '"+cPeriodoAte+"' " 
	
	If MV_PAR01 = 1 // Policia Federal
		_cQry +=	" AND B5_PRODPF = 'S' "
	ElseIf MV_PAR01 = 3 // Policia Civil
		_cQry +=	" AND B5_PRODPC = 'S' "
	ElseIf MV_PAR01 = 2 // Exercito
		_cQry +=	" AND B5_PRODEX = 'S' "
	EndIf
	
	_cQry +=	" ORDER BY D1_EMISSAO, D1_DOC, A2_CGC, B1_COD "

ElseIf  MV_PAR10 = 2

	_cQry :=	" SELECT  D2_EMISSAO AS EMISSAO, D2_DOC AS DOC, A1_CGC AS CNPJ, A1_NOME AS NOME, A1_END AS ENDER, "
	_cQry +=	" A1_BAIRRO AS BAIRRO, A1_MUN AS CIDADE, F2_TRANSP AS TRANSP, B1_POSIPI, B5_CONCENT, B5_DENSID,  "
	_cQry +=	" D2_COD AS PROD, B1_DESC, D2_UM AS UM, B1_GRUPO AS GRUPO, B5_CEME, BM_DESC, D2_QUANT AS QUANT, D2_CF AS CF, B1_POSIPI  "
	_cQry +=	" from "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SB5")+" SB5, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SF4")+" SF4, "+RetSqlName("SA1")+" SA1 "
	_cQry +=	" WHERE SB1.D_E_L_E_T_  <> '*' "
	_cQry +=	" AND SD2.D_E_L_E_T_  <> '*' "
	_cQry +=	" AND SF2.D_E_L_E_T_  <> '*' "  
	_cQry +=	" AND SF4.D_E_L_E_T_  <> '*' "		
	_cQry +=	" AND SA1.D_E_L_E_T_  <> '*' "
	_cQry +=	" AND SB5.D_E_L_E_T_  <> '*' "
	_cQry +=	" AND SBM.D_E_L_E_T_  <> '*' "   
	
	_cQry +=	" AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
	_cQry +=	" AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
	_cQry +=	" AND SF2.F2_FILIAL = '"+xFilial("SF2")+"' "
	_cQry +=	" AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
	_cQry +=	" AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
	_cQry +=	" AND SB5.B5_FILIAL = '"+xFilial("SB5")+"' "
	_cQry +=	" AND SBM.BM_FILIAL = '"+xFilial("SBM")+"' "
	
	
	_cQry +=	" AND D2_DOC = F2_DOC "
	_cQry +=	" AND D2_SERIE = F2_SERIE "

	_cQry +=	" AND D2_COD = B1_COD " 
                                          
	_cQry +=	" AND D2_TES = F4_CODIGO "

	_cQry +=	" AND D2_CLIENTE = A1_COD "
	_cQry +=	" AND D2_LOJA = A1_LOJA "

	_cQry +=	" AND B1_COD = B5_COD "

	_cQry +=	" AND B1_GRUPO = BM_GRUPO "           

	_cQry +=	" AND F4_ESTOQUE = 'S' "	
	
	_cQry +=	" AND D2_TIPO = 'N' "
	_cQry +=	" AND D2_CLIENTE BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR08+"' "
	_cQry +=	" AND D2_LOJA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR09+"' "	
	_cQry +=	" AND B1_GRUPO BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	_cQry +=	" AND D2_EMISSAO BETWEEN '"+cPeriodoDe+"' AND '"+cPeriodoAte+"' " 
	
	If MV_PAR01 = 1 // Policia Federal
		_cQry +=	" AND B5_PRODPF = 'S' "
	ElseIf MV_PAR01 = 3 // Policia Civil
		_cQry +=	" AND B5_PRODPC = 'S' "
	ElseIf MV_PAR01 = 2 // Exercito
		_cQry +=	" AND B5_PRODEX = 'S' "
	EndIf
	
	_cQry +=	" ORDER BY D2_EMISSAO, D2_DOC, A1_CGC, B1_COD "

ElseIf  MV_PAR10 = 3

	_cQry := " SELECT "
	_cQry += "    D2_EMISSAO AS EMISSAO, "
	_cQry += "    D2_DOC AS DOC, "
	_cQry += "    A2_CGC AS CNPJ, "

	_cQry += "    A2_NOME AS NOME, " 
	_cQry += "    A2_END AS ENDER, " 
	_cQry += "    A2_BAIRRO AS BAIRRO, " 
	_cQry += "    A2_MUN AS CIDADE, " 

	_cQry += "    F2_TRANSP AS TRANSP, "
	_cQry += "    B1_POSIPI, B5_CONCENT, "
	_cQry += "    B5_DENSID, "
	_cQry += "    D2_COD AS PROD, "
	_cQry += "    B1_DESC, "
	_cQry += "    D2_UM AS UM, "
	_cQry += "    B1_GRUPO AS GRUPO, "
	_cQry += "    B5_CEME, "
	_cQry += "    BM_DESC, "
	_cQry += "    D2_QUANT AS QUANT, "
	_cQry += "    D2_CF AS CF, "
	_cQry += "    B1_POSIPI "
	_cQry += " FROM " + RetSqlName("SD2")+" SD2, "

	_cQry += "    INNER JOIN " + RetSqlName("SF2")+" SF2 ON "
	_cQry += "       SF2.D_E_L_E_T_ <> '*' "
	_cQry += "       AND F2_FILIAL   = '"+xFilial("SF2")+"' "
	_cQry += "       AND F2_DOC      = D2_DOC "
	_cQry += "       AND F2_SERIE    = D2_SERIE "

	_cQry += "    INNER JOIN " + RetSqlName("SF4")+" SF4 ON "
	_cQry += "       SF4.D_E_L_E_T_ <> '*' "
	_cQry += "       AND F4_FILIAL   = '"+xFilial("SF4")+"' "
	_cQry += "       AND F4_CODIGO      = D2_TES "
	_cQry += "       AND F4_ESTOQUE = 'S' "

	_cQry += "    INNER JOIN " + RetSqlName("SB1")+" SB1 ON "
	_cQry += "       SB1.D_E_L_E_T_ <> '*' "
	_cQry += "       AND B1_FILIAL   = '"+xFilial("SB1")+"' "
	_cQry += "       AND B1_COD      = D2_COD  "
	_cQry += "       AND B1_GRUPO    BETWEEN '"+MV_PAR02+"'   AND '"+MV_PAR03+"' "

	_cQry += "    INNER JOIN " + RetSqlName("SB5")+" SB5 ON "
	_cQry += "       SB5.D_E_L_E_T_ <> '*' "
	_cQry += "       AND B5_FILIAL   = '"+xFilial("SB5")+"' "
	_cQry += "       AND B5_COD      = B1_COD  "

	If MV_PAR01 = 1 // Policia Federal
		_cQry += "       AND B5_PRODPF = 'S' "
	ElseIf MV_PAR01 = 3 // Policia Civil
		_cQry += "       AND B5_PRODPC = 'S' "
	ElseIf MV_PAR01 = 2 // Exercito
		_cQry += "       AND B5_PRODEX = 'S' "
	EndIf

	_cQry += "    INNER JOIN " + RetSqlName("SBM")+" SBM ON "
	_cQry += "       SBM.D_E_L_E_T_ <> '*' "
	_cQry += "       AND BM_FILIAL   = '"+xFilial("SBM")+"' "
	_cQry += "       AND BM_GRUPO    = B1_GRUPO "           

	_cQry += "    INNER JOIN " + RetSqlName("SA2")+" SA2 ON "
	_cQry += "       SA2.D_E_L_E_T_ <> '*' "
	_cQry += "       AND A2_FILIAL   = '"+xFilial("SA2")+"' "
	_cQry += "       AND A2_COD      = D2_CLIENTE "
	_cQry += "       AND A2_LOJA     = D2_LOJA    "

	_cQry += " WHERE "
	_cQry += "    SD2.D_E_L_E_T_  <> '*' "
	_cQry += "    AND D2_FILIAL   = '"+xFilial("SD2")+"' "
	_cQry += "    AND D2_TIPO = 'D' "
	_cQry += "    AND D2_CLIENTE BETWEEN '"+MV_PAR06+"'   AND '"+MV_PAR08+"' "
	_cQry += "    AND D2_LOJA    BETWEEN '"+MV_PAR07+"'   AND '"+MV_PAR09+"' "	
	_cQry += "    AND D2_EMISSAO BETWEEN '"+cPeriodoDe+"' AND '"+cPeriodoAte+"' " 
	
	_cQry +=	" ORDER BY D2_EMISSAO, D2_DOC, A2_CGC, B1_COD "


ElseIf MV_PAR10 = 4                           

	_cQry := " SELECT "
	_cQry += "    D1_DTDIGIT AS EMISSAO,  "
	_cQry += "    D1_DOC AS DOC,  "
	_cQry += "    A1_CGC AS CNPJ,  "

	_cQry += "    A1_NOME AS NOME, " 
	_cQry += "    A1_END AS ENDER, " 
	_cQry += "    A1_BAIRRO AS BAIRRO, " 
	_cQry += "    A1_MUN AS CIDADE, " 

	_cQry += "    F1_TRANSP AS TRANSP,  "
	_cQry += "    B1_POSIPI,  "
	_cQry += "    B5_CONCENT,  "
	_cQry += "    B5_DENSID,  "
	_cQry += "    D1_COD AS PROD,  "
	_cQry += "    B1_DESC,  "
	_cQry += "    D1_UM AS UM,  "
	_cQry += "    B1_GRUPO AS GRUPO,  "
	_cQry += "    B5_CEME,  "
	_cQry += "    BM_DESC,  "
	_cQry += "    D1_QUANT AS QUANT,  "
	_cQry += "    D1_CF AS CF,  "
	_cQry += "    B1_POSIPI  "
	_cQry += " FROM "+RetSqlName("SD1")+" SD1 "

	_cQry += "    INNER JOIN "+RetSqlName("SF1")+" SF1 ON "
	_cQry += "       SF1.D_E_L_E_T_ <> '*' "
	_cQry += "       AND F1_FILIAL   = '"+xFilial("SF1")+"' "

	_cQry += "       AND F1_DOC      = D1_DOC "
	_cQry += "       AND F1_SERIE    = D1_SERIE "
	_cQry += "       AND F1_FORNECE  = D1_FORNECE "
	_cQry += "       AND F1_LOJA     = D1_LOJA "

	_cQry += "    INNER JOIN " + RetSqlName("SF4")+" SF4 ON "
	_cQry += "       SF4.D_E_L_E_T_ <> '*' "
	_cQry += "       AND F4_FILIAL   = '"+xFilial("SF4")+"' "
	_cQry += "       AND F4_CODIGO      = D1_TES "
	_cQry += "       AND F4_ESTOQUE = 'S' "

	_cQry += "    INNER JOIN "+RetSqlName("SB1")+" SB1 ON "
	_cQry += "       SB1.D_E_L_E_T_ <> '*'  "
	_cQry += "       AND B1_FILIAL   = '"+xFilial("SB1")+"' "
	_cQry += "       AND B1_COD      = D1_COD " 
	_cQry += "       AND B1_GRUPO BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "

	_cQry += "    INNER JOIN "+RetSqlName("SB5")+" SB5 ON "
	_cQry += "       SB5.D_E_L_E_T_ <> '*' "
	_cQry += "       AND B5_FILIAL   = '"+xFilial("SB5")+"' "
	_cQry += "       AND B5_COD      = B1_COD "

	If MV_PAR01 = 1 // Policia Federal
		_cQry += "       AND B5_PRODPF = 'S' "
	ElseIf MV_PAR01 = 3 // Policia Civil
		_cQry += "       AND B5_PRODPC = 'S' "
	ElseIf MV_PAR01 = 2 // Exercito
		_cQry += "       AND B5_PRODEX = 'S' "
	EndIf

	_cQry += "    INNER JOIN "+RetSqlName("SBM")+" SBM ON "
	_cQry += "       SBM.D_E_L_E_T_ <> '*' "
	_cQry += "       AND BM_FILIAL   = '"+xFilial("SBM")+"' "
	_cQry += "       AND BM_GRUPO    = B1_GRUPO "           

	_cQry += "    INNER JOIN "+RetSqlName("SA1")+" SA1 ON "
	_cQry += "       SA1.D_E_L_E_T_ <> '*' "
	_cQry += "       AND A1_FILIAL   = '"+xFilial("SA1")+"' "
	_cQry += "       AND A1_COD      = D1_FORNECE  "
	_cQry += "       AND A1_LOJA     = D1_LOJA     "

	_cQry += " WHERE "                     
	_cQry += "    SD1.D_E_L_E_T_ <> '*' "
	_cQry += "    AND D1_FILIAL  = '"+xFilial("SD1")+"' "

	_cQry += "    AND D1_TIPO = 'D' "
	_cQry += "    AND D1_FORNECE BETWEEN '"+MV_PAR06+"'   AND '"+MV_PAR08+"' "
	_cQry += "    AND D1_LOJA    BETWEEN '"+MV_PAR07+"'   AND '"+MV_PAR09+"' "	
	_cQry += "    AND D1_DTDIGIT BETWEEN '"+cPeriodoDe+"' AND '"+cPeriodoAte+"' " 
		
	_cQry +=	" ORDER BY D1_EMISSAO, D1_DOC, A1_CGC, B1_COD "

EndIf

_cQry := ChangeQuery(_cQry)

TCQUERY _cQry NEW ALIAS "TRB"

oExcel := FWMSEXCEL():New()
oExcel:AddworkSheet("VQRELVEND")
oExcel:AddTable("VQRELVEND","MOVIMENTOS")
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","EMISSAO",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","NOTA",2,2)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","CNPJ_CLI",3,3)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","CLI_FOR",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","ENDERECO",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","BAIRRO",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","CIDADE",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","TRANSPORTADORA",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","CNPJ_TRAN",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","CPF_TRAN",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","CPF_PESS",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","NCM",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","CONCENT",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","DENSID",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","PRODUTO",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","GRUPO",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","DESCRICAO",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","QUANTIDADE",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","UM",1,1)
oExcel:AddColumn("VQRELVEND","MOVIMENTOS","CFOP",1,1)


titulo        := "RELA«√O DE COMPRA DE PRODUTOS FISCALIZADOS PELA SECRETARIA DE SEGURAN«A PUBLICA     PERÕODO: " +DTOC(STOD(cPeriodoDe))+" A "+DTOC(STOD(cPeriodoAte))
nContPg := 1
nLin:= 80

DbSelectArea("TRB")
TRB->(DbGoTop())
While !TRB->(Eof())
	
	IncProc(" Processando Dados " )
	RecLock("_TRX",.T.)

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > nLinFim
//		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		@nLin:= 0
		@nLin,000 pSay Replicate("-",220)
		nLin++
	    @nLin,000 pSay "| IMPRESSO EM: "+DTOC(dDatabase)+"                  RELA«√O DE COMPRA DE PRODUTOS FISCALIZADOS PELA SECRETARIA DE SEGURAN«A PUBLICA               PERÕODO: " +DTOC(STOD(cPeriodoDe))+" A "+DTOC(STOD(cPeriodoAte))+"                    Folha:"+Transform(nContPg,"@E 9999")
	    @nLin,219 pSay "|"
		nLin++
	    @nLin,000 pSay "| EMPRESA: VERQUIMICA IND. COM. PROD. QUI.                        END.: AV. MARTINS JUNIOR, 2000                  GUARULHOS - SP - CEP: 07141-000          TEL: 2404-8800 FAX: 2404-8813 "
	    @nLin,219 pSay "|"
		nLin++
	    @nLin,000 pSay "| CGC: 43.588.060/0001-80           INSCRI«√O ESTADUAL: 336.125.845.118              CERTIFICADO DE VISTORIA: 079/13               DATADO DE 25/03/2013                   LICEN«A No.: 291/266/280 "
	    @nLin,219 pSay "|"	    
		nLin++	    
		@nLin,000 pSay Replicate("-",220)
		nLin++
	    @nLin,000 pSay "  EMISSAO      EMPRESA                                       ENDERE«O                                    BAIRRO                           CIDADE                           NF          PRODUTO                QUANTIDADE"
		nLin++	    
		@nLin,000 pSay Replicate("=",220)
		nLin++	    
		cQuebra := ""
		nContPg++
	EndIf
//                            1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
//                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                  DD/MM/AAAA     1234567890123456789012345678901234567890     1234567890123456789012345678901234567890     123456789012345678901234567890   123456789012345678901234567890   1234567890  12345678901234567890  999,999,999.99



	@nLin,002 pSay DTOC(STOD(TRB->EMISSAO))
	@nLin,015 pSay SubStr(TRB->NOME,1,40)
	@nLin,061 pSay SubStr(TRB->ENDER,1,40)
	@nLin,105 pSay SubStr(TRB->BAIRRO,1,30)
	@nLin,138 pSay SubStr(TRB->CIDADE,1,30)
  
	@nLin,171 pSay TRB->DOC
	@nLin,183 pSay SubStr(TRB->BM_DESC,1,20)
	@nLin,205 pSay TRB->QUANT PICTURE "@E 99,999,999.99"
	nLin ++					
	

	_TRX->EMISSAO   := STOD(TRB->EMISSAO)
	_TRX->NOTA      := TRB->DOC
	_TRX->CNPJ_CLI  := TRB->CNPJ
          
	_TRX->CLI_FOR   := TRB->NOME
	_TRX->ENDERECO  := TRB->ENDER
	_TRX->BAIRRO    := TRB->BAIRRO
	_TRX->CIDADE    := TRB->CIDADE
	
	_TRX->TRANSPOR  := POSICIONE("SA4",1,xFilial("SA4")+TRB->TRANSP,"A4_NOME")
	_TRX->CNPJ_TRAN := POSICIONE("SA4",1,xFilial("SA4")+TRB->TRANSP,"A4_CGC")
	_TRX->CPF_TRAN  := ""
	_TRX->CPF_PESS  := "" 
	_TRX->NCM       := TRB->B1_POSIPI       
	_TRX->CONCENT   := TRB->B5_CONCENT
	_TRX->DENSID    := TRB->B5_DENSID
	_TRX->PRODUTO   := TRB->PROD 
	_TRX->GRUPO     := TRB->BM_DESC 
	_TRX->DESCRICAO := ALLTRIM(TRB->B5_CEME)  
	_TRX->QUANTIDAD := TRB->QUANT
	_TRX->UM   		:= TRB->UM
	_TRX->CFOP   	:= TRB->CF

	oExcel:AddRow("VQRELVEND","MOVIMENTOS",{STOD(TRB->EMISSAO), TRB->DOC,TRB->CNPJ, TRB->NOME,TRB->ENDER, TRB->BAIRRO,TRB->CIDADE,POSICIONE("SA4",1,xFilial("SA4")+TRB->TRANSP,"A4_NOME"),POSICIONE("SA4",1,xFilial("SA4")+TRB->TRANSP,"A4_CGC"),"","",TRB->B1_POSIPI,TRB->B5_CONCENT,TRB->B5_DENSID,TRB->PROD,TRB->BM_DESC,ALLTRIM(TRB->B5_CEME),TRB->QUANT,TRB->UM,TRB->CF})
	msUnlock()	
	DbSelectArea("TRB")
	TRB->(DbSkip())
Enddo
                                    
If nContPg > 1
    
    If nLin > 60
    
    	nLin := 0
		@nLin,000 pSay Replicate("-",220)
		nLin++
	    @nLin,000 pSay "| IMPRESSO EM: "+DTOC(dDatabase)+"                  RELA«√O DE COMPRA DE PRODUTOS FISCALIZADOS PELA SECRETARIA DE SEGURAN«A PUBLICA               PERÕODO: " +DTOC(STOD(cPeriodoDe))+" A "+DTOC(STOD(cPeriodoAte))+"                    Folha:"+Transform(nContPg,"@E 9999")
	    @nLin,219 pSay "|"
		nLin++
	    @nLin,000 pSay "| EMPRESA: VERQUIMICA IND. COM. PROD. QUI.                        END.: AV. MARTINS JUNIOR, 2000                  GUARULHOS - SP - CEP: 07141-000          TEL: 2404-8800 FAX: 2404-8813 "
	    @nLin,219 pSay "|"
		nLin++
	    @nLin,000 pSay "| CGC: 43.588.060/0001-80           INSCRI«√O ESTADUAL: 336.125.845.118              CERTIFICADO DE VISTORIA: 079/13               DATADO DE 25/03/2013                   LICEN«A No.: 291/266/280 "
	    @nLin,219 pSay "|"	    
		nLin++	    
		@nLin,000 pSay Replicate("-",220)
		nLin++
	    @nLin,000 pSay "  EMISSAO      EMPRESA                                       ENDERE«O                                    BAIRRO                           CIDADE                           NF          PRODUTO                QUANTIDADE"
		nLin++	    
		@nLin,000 pSay Replicate("=",220)
		nLin++	      
		  	
    EndIf           
    
    nLin := 60
	@nLin,0160 pSay "O que declaro È a verdade, sob as penas da lei." 
	nLin ++	
	@nLin,0160 pSay "Guarulhos,  "  + DTOC(dDatabase)
	nLin ++		
	@nLin,0160 pSay "Ass.: _________________________________________" 
	nLin ++		
	@nLin,0160 pSay "Respons·vel: Vera Lucia de Oliveira Franco "
	nLin ++		
	@nLin,0160 pSay "Cargo: Diretora "
	nLin ++		
	@nLin,0160 pSay "RG N∫ 10.309.352-7 " 

EndIf

SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()


TRB->(DbCloseArea())
DbSelectArea("_TRX") ; DbCloseArea()

oExcel:Activate()
oExcel:GetXMLFile("C:\TEMP\VQRELVEND_"+DTOS(DATE())+".xml")

// Abre no Excel
If !ApOleClient("MsExcel")
	MsgStop("VocÍ n„o possui o excel instalado, entretanto, o arquivo gerado encontra-se em C:\TEMP\VQRELVEND_"+DTOS(DATE())+".xml")
	Return
EndIf

//cArq     := cArqTemp+".DBF"
//__CopyFIle(cArq , AllTrim(GetTempPath())+cArqTemp+".XLS")
oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open("C:\TEMP\VQRELVEND_"+DTOS(DATE())+".XML")
oExcelApp:SetVisible(.T.)

Restarea(_aArea)

Return()



Static Function PVQRELVD()

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio de Entregas"
Local cPict         := ""
Local titulo        := "RelaÁ„o de Compra de Produtos Fiscalizados pela Secretaria de SeguranÁa Publica     PerÌodo: " //+cPeriodoDe+" a "+cPeriodoAte
Local nLin          := 80
Local Cabec1        := "Empresa: Vequimica Ind. Com. Prod. Qui             End.: Av. Martins Junior, 2000 jd.     Guarulhos - SP - Cep: 07141-000    Tel: 2404-8800 Fax: 2404-8813 "
Local Cabec2        := "CGC: 43.588.060/0001-80          InscriÁ„o Estadual: 336.125.845.118       Certificado de Vistoria: 079/13       Datado de 25/03/2013      Licenca No.: 291/266/280 "
Local imprime       := .T.
Local aOrd          := {}
Local lPergTk       := .F.
Local aRegs         := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"



Private nomeprog    := cPerg //"CFMRROMA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
//Private cPerg       := cPerg
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := cPerg
Private cString     := "SF2"
//Default lAutoZ13    := .F.



Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

//Private cPeriodoDe  := left(dtos(MV_PAR04),6)+"01"
//Private cPeriodoAte := dtos(lastday(MV_PAR04))


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| GeraPlanila(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return
