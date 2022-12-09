#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBR002  บAutor  ณLucas Fl๓ridi Leme  บ Data ณ  19/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rela็ใo das saํdas em excel                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11 Cittati                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑ Leandro Cardoso. 07.01.15 O Ajuste no sistema para considerar a filial  ฑฑ
ฑฑ da SB1                                                                  ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                              
User Function RCTBR002()

Local cPerg		:= PadR("SAIDASCTB",10)           

AjustaSx1(cPerg)
If Pergunte(cPerg,.T.)    

	Processa( {|| MexProcessa() },"Aguarde" ,"Processando...")
	Processa( {|| GeraExcel("TMP") },"Aguarde" ,"Gerando arquivo excel...")

EndIf

Return() 

          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMexProcessบAutor  ณMicrosiga           บ Data ณ  08/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MexProcessa()
Local cQuery := ''  
cQuery += "SELECT '"+cEmpAnt+"' EMPRESA,D2_FILIAL AS FILIAL," + Chr(13)
cQuery += " SUBSTRING(D2_EMISSAO,7,2) + '/' + SUBSTRING(D2_EMISSAO,5,2) + '/' + SUBSTRING(D2_EMISSAO,1,4) DATA, " +  Chr(13)
cQuery += "	D2_DOC NOTA, " + Chr(13)  
cQuery += "	D2_TIPO TIPO, " + Chr(13) 
//cQuery += "	A1_NOME CLIENTE, " + Chr(13)   
cQuery += "	CASE WHEN D2_TIPO <> 'B' AND D2_TIPO <> 'D' "
cQuery += "		THEN (SELECT A1_NOME FROM " + RetSqlName('SA1') + " WHERE D_E_L_E_T_ <> '*' AND A1_FILIAL = '" + xFilial('SA1') + "' AND A1_COD = SD2.D2_CLIENTE AND A1_LOJA = SD2.D2_LOJA) "
cQuery += "		ELSE (SELECT A2_NOME FROM " + RetSqlName('SA2') + " WHERE D_E_L_E_T_ <> '*' AND A2_FILIAL = '" + xFilial('SA2') + "' AND A2_COD = SD2.D2_CLIENTE AND A2_LOJA = SD2.D2_LOJA) END CLIENTE, " + Chr(13)   
cQuery += "	B1_TIPO TIPOPROD, " + Chr(13)
cQuery += "	D2_CLIENTE CLIEFOR, " + Chr(13)
cQuery += "	D2_LOJA LOJA, " + Chr(13)
cQuery += " (SELECT A1_CGC FROM SA1010 WHERE D_E_L_E_T_ <> '*' AND A1_COD = SD2.D2_CLIENTE AND A1_LOJA = SD2.D2_LOJA ) AS CNPJ, " + Chr(13)
cQuery += "	D2_COD CODIGO, " + Chr(13)
cQuery += "	B1_DESC PRODUTO, " + Chr(13)
cQuery += "	B1_POSIPI NCM, " + Chr(13)
cQuery += "	D2_QUANT QUANT, " + Chr(13)
cQuery += "	D2_PRUNIT VLR_UNIT, " + Chr(13)
cQuery += "	D2_TOTAL TOTAL, " + Chr(13)  
cQuery += "	D2_TES TES, " + Chr(13)
cQuery += "	D2_CF CFOP, " + Chr(13)
cQuery += "	D2_CLASFIS CLASFIS, " + Chr(13)
cQuery += "	D2_CONTA CONTACONTAB, " + Chr(13)    
cQuery += "	CASE WHEN D2_VALISS=0 THEN D2_PICM ELSE 0 END ALIQICMS, " + Chr(13)   
cQuery += "	CASE WHEN D2_VALISS=0 THEN D2_VALICM ELSE 0 END VLRICMS, " + Chr(13)
cQuery += "	F4_ICM CALCICM, " + Chr(13)
cQuery += "	D2_ICMSRET VLRICMSST, " + Chr(13)
cQuery += "	D2_IPI ALIQIPI, " + Chr(13)  
cQuery += "	D2_VALIPI VLRIPI, " + Chr(13)
cQuery += "	F4_IPI CALCIPI, " + Chr(13)
cQuery += "	D2_ALQIMP5 ALQCOFINS, " + Chr(13)  
cQuery += "	D2_BASIMP5 BCCOFINS, " + Chr(13)   
cQuery += "	D2_VALIMP5 VLRCOFINS, " + Chr(13) 
cQuery += "	D2_ALQIMP6 ALQPIS, " + Chr(13)  
cQuery += "	D2_BASIMP6 BCPIS, " + Chr(13)   
cQuery += "	D2_VALIMP6 VLRPIS, " + Chr(13) 
cQuery += "	CASE WHEN D2_VALISS>0 THEN D2_PICM ELSE 0 END ALQISS, " + Chr(13) 
cQuery += "	D2_VALISS VLRISS, " + Chr(13) 
//cQuery += "	D2_XISSOM ALIQISSOM, " + Chr(13) 
//cQuery += "	CASE WHEN D2_XISSOM>0 THEN D2_TOTAL*(D2_XISSOM/100) ELSE 0 END  VALISS_OM, " + Chr(13) 
cQuery += "	D2_VALFRE VLRFRETE, " + Chr(13)   
cQuery += "	D2_DESPESA VLRDESPES, " + Chr(13)   
cQuery += "	D2_DESC VLRDESCTO, " + Chr(13)                  
cQuery += "	D2_CUSTO1 CUSTO, " + Chr(13)       
cQuery += "	F4_ESTOQUE ESTOQUE, " + Chr(13)   
cQuery += "	F4_DUPLIC DUPLIC, " + Chr(13)  
cQuery += "	F2_EST ESTADO, " + Chr(13)  

cQuery += "	D2_CCUSTO CCUSTO, " + Chr(13)  
//cQuery += "	D2_ITEM_K ITEMCONTA, " + Chr(13)  
//cQuery += "	D2_SERV_CA SERVCALL, " + Chr(13)  
cQuery += "	D2_CLVL CLVALOR, " + Chr(13)  

cQuery += "	F4_XCONTAB GRPCONTAB, " + Chr(13)  
cQuery += "	ISNULL(F3_OBSERV,'') OBSERV " + Chr(13)  
cQuery += " FROM "+RetSqlName("SD2") + " SD2 " + Chr(13)
//cQuery += " 	INNER JOIN "+ RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_<>'*' AND B1_COD = D2_COD AND B1_FILIAL = "+IF(EMPTY(xFilial("SB1")),"''","D2_FILIAL")+" " + Chr(13)

//////////////////////////////////////
//*Leandro Cardoso. 07.01.15 Inicio//
////////////////////////////////////
IF Len(RTRIM(xFilial("SB1")))= 3
	cQuery += " 	INNER JOIN "+ RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_<>'*' AND B1_COD = D2_COD AND B1_FILIAL = SUBSTRING(D2_FILIAL,1,3)" + Chr(13)  
ElseIf Len(RTRIM(xFilial("SB1")))= 6 
    cQuery += " 	INNER JOIN "+ RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_<>'*' AND B1_COD = D2_COD AND B1_FILIAL = SUBSTRING(D2_FILIAL,1,6)" + Chr(13)
ElseIf Len(RTRIM(xFilial("SB1")))= 9
	cQuery += " 	INNER JOIN "+ RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_<>'*' AND B1_COD = D2_COD AND B1_FILIAL = SUBSTRING(D2_FILIAL,1,9)" + Chr(13)
Else
	cQuery += " 	INNER JOIN "+ RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_<>'*' AND B1_COD = D2_COD AND B1_FILIAL = "+IF(EMPTY(xFilial("SB1")),"''","D2_FILIAL")+" " + Chr(13)      
EndIf
///////////////////////////////////
//*Leandro Cardoso. 07.01.15 FIM//
/////////////////////////////////

cQuery += " 	INNER JOIN "+ RetSqlName("SF4") + " SF4 ON SF4.D_E_L_E_T_<>'*' AND D2_TES = F4_CODIGO AND F4_FILIAL = "+IF(EMPTY(xFilial("SF4")),"''","D2_FILIAL")+" " + Chr(13)  
cQuery += " 	INNER JOIN "+ RetSqlName("SF2") + " SF2 ON SF2.D_E_L_E_T_<>'*' AND F2_FILIAL = D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA  "  + Chr(13)  
//cQuery += " 	LEFT OUTER JOIN "+ RetSqlName("SED") + " SED ON SED.D_E_L_E_T_<>'*' AND ED_CODIGO=F2_NATUREZ "  + Chr(13)  

cQuery += " 	LEFT OUTER JOIN "+ RetSqlName("SFT") + " SFT ON SFT.D_E_L_E_T_<>'*' " +Chr(13)
cQuery += " 	 		AND FT_FILIAL = D2_FILIAL AND FT_NFISCAL=D2_DOC AND FT_SERIE=D2_SERIE AND FT_CLIEFOR=D2_CLIENTE AND FT_LOJA=D2_LOJA AND FT_ITEM=D2_ITEM " +Chr(13)
cQuery += " 	 	LEFT OUTER JOIN "+ RetSqlName("SF3") + " SF3 ON SF3.D_E_L_E_T_<>'*'  " +Chr(13)
cQuery += " 	 		AND F3_FILIAL = FT_FILIAL AND F3_NFISCAL=FT_NFISCAL AND F3_SERIE=FT_SERIE  " +Chr(13)
cQuery += "				AND F3_TIPO=F2_TIPO AND F3_CLIEFOR=FT_CLIEFOR AND F3_LOJA=FT_LOJA AND F3_IDENTFT=FT_IDENTF3  " +Chr(13)
cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' " + Chr(13) 
//cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' " + Chr(13)
cQuery += " AND D2_CLIENTE BETWEEN '" + mv_par01 + "' AND '" + mv_par03 + "' " + Chr(13)
cQuery += " AND D2_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 + "' " + Chr(13)
cQuery += "	AND D2_EMISSAO BETWEEN '" + DToS(mv_par05) + "' AND '" + DTos(mv_par06) + "' " + Chr(13)
cQuery += " AND D2_COD BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + Chr(13)
cQuery += "ORDER BY FILIAL,DATA, NOTA "
Memowrite("RCTBR002.txt",cQuery)
TcQuery cQuery New Alias "TMP"                                       

TcSetField("TMP","CUSTO","N",TamSx3("D2_CUSTO1")[1],TamSx3("D2_CUSTO1")[2])        
TcSetField("TMP","QUANT","N",TamSx3("D2_QUANT")[1],2)        
TcSetField("TMP","VLR_UNIT","N",TamSx3("D2_PRUNIT")[1],4)  
TcSetField("TMP","TOTAL","N",TamSx3("D2_TOTAL")[1],2)
TcSetField("TMP","ALIQICMS","N",TamSx3("D2_PICM")[1],2)
TcSetField("TMP","VLRICMS","N",TamSx3("D2_VALICM")[1],2) 
TcSetField("TMP","ALIQIPI","N",TamSx3("D2_IPI")[1],2)
TcSetField("TMP","VLRIPI","N",TamSx3("D2_VALIPI")[1],2) 
TcSetField("TMP","ALQCOFINS","N",TamSx3("D2_ALQIMP5")[1],2) 
TcSetField("TMP","BCCOFINS","N",TamSx3("D2_BASIMP5")[1],2) 
TcSetField("TMP","VLRCOFINS","N",TamSx3("D2_VALIMP5")[1],2) 
TcSetField("TMP","ALQPIS","N",TamSx3("D2_ALQIMP6")[1],2) 
TcSetField("TMP","BCPIS","N",TamSx3("D2_BASIMP6")[1],2) 
TcSetField("TMP","VLRPIS","N",TamSx3("D2_VALIMP6")[1],2) 
TcSetField("TMP","VLRFRETE","N",TamSx3("D2_VALFRE")[1],2) 
TcSetField("TMP","VLRDESCTO","N",TamSx3("D2_DESC")[1],2) 

                      
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ                    บ Data ณ  02/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

Local aRea	:= GetArea()
Local aSx1	:= {}

DBSelectArea("SX1")
SX1->(DBSetOrder(1))
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
SX1->(DBSeek(cPerg+"01"))       
AADD(	aSx1,{ cPerg,"01","Cliente de?"		,"mv_par01"	,"C",6,0,0,"G","",	"mv_par01","","","","","SA1" } )
AADD(	aSx1,{ cPerg,"02","Loja de?"		,"mv_par02"	,"C",2,0,0,"G","",	"mv_par02","","","","","","" } )
AADD(	aSx1,{ cPerg,"03","Cliente ate?"	,"mv_par03"	,"C",6,0,0,"G","",	"mv_par03","","","","","SA1" } ) 
AADD(	aSx1,{ cPerg,"04","Loja ate?"		,"mv_par04"	,"C",2,0,0,"G","",	"mv_par04","","","","","","" } ) 
AADD(	aSx1,{ cPerg,"05","Emissao NF de?"	,"mv_par05"	,"D",8,0,0,"G","", 	"mv_par05","","","","","","" } )
AADD(	aSx1,{ cPerg,"06","Emissao NF ate?"	,"mv_par06"	,"D",8,0,0,"G","",	"mv_par06","","","","","","" } ) 
AADD(	aSx1,{ cPerg,"07","Produto de?"	    ,"mv_par07"	,"C",15,0,0,"G","",	"mv_par07","","","","","SB1" } )
AADD(	aSx1,{ cPerg,"08","Produto Ate?"	,"mv_par08"	,"C",15,0,0,"G","",	"mv_par08","","","","","SB1" } )

If SX1->X1_GRUPO != cPerg
	For I := 1 To Len( aSx1 )
		If !SX1->( DBSeek( aSx1[I][1] + aSx1[I][2] ) )
			Reclock( "SX1", .T. )
			SX1->X1_GRUPO		:= aSx1[i][1] //Grupo
			SX1->X1_ORDEM		:= aSx1[i][2] //Ordem do campo
			SX1->X1_PERGUNT		:= aSx1[i][3] //Pergunta
			SX1->X1_PERSPA		:= aSx1[i][3] //Pergunta Espanhol
	   		SX1->X1_PERENG		:= aSx1[i][3] //Pergunta Ingles
			SX1->X1_VARIAVL		:= aSx1[i][4] //Variavel do campo
			SX1->X1_TIPO		:= aSx1[i][5] //Tipo de valor
			SX1->X1_TAMANHO		:= aSx1[i][6] //Tamanho do campo
			SX1->X1_DECIMAL		:= aSx1[i][7] //Formato numerico
			SX1->X1_PRESEL		:= aSx1[i][8] //Pre sele็ใo do combo
			SX1->X1_GSC			:= aSx1[i][9] //Tipo de componente
			SX1->X1_VAR01		:= aSx1[i][10]//Variavel que carrega resposta
			SX1->X1_DEF01		:= aSx1[i][11]//Defini็๕es do combo-box
			SX1->X1_DEF02		:= aSx1[i][12]
			SX1->X1_DEF03		:= aSx1[i][13]
			SX1->X1_DEF04		:= aSx1[i][14]
			SX1->X1_VALID		:= aSx1[i][15]
			SX1->X1_F3			:= aSx1[i][16]
			MsUnlock()
		Endif
	Next
Endif

RestArea(aRea)

Return(cPerg)		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGeraExcel บAutor  ณ                    บ Data ณ  05/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao de arquivo excel 						              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraExcel(cAlias)

DbSelectArea("TMP")
DbGotop()
ProcRegua(TMP->(RecCount()))
If !TMP->(Eof())
	_aStru := TMP->(DbStruct())
	oExcel    := FWMSEXCEL():New()
	oExcel:AddworkSheet("SAIDAS EM EXCEL")
	oExcel:AddTable ("SAIDAS EM EXCEL","SAIDAS EM EXCEL")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("SAIDAS EM EXCEL","SAIDAS EM EXCEL",_aStru[_x,1],3,2)
		ElseIf _aStru[_x,2] == "C"
			If "/" $ _aStru[_x,1]
				oExcel:AddColumn("SAIDAS EM EXCEL","SAIDAS EM EXCEL",_aStru[_x,1],1,4)
			Else
				oExcel:AddColumn("SAIDAS EM EXCEL","SAIDAS EM EXCEL",_aStru[_x,1],1,1)
			EndIf
		EndIf
	Next
	
	While !TMP->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			_aLinha[_x] := TMP->&(_cCpo)
		Next
		
		oExcel:AddRow("SAIDAS EM EXCEL","SAIDAS EM EXCEL",_aLinha)
		TMP->(DbSkip())
	EndDo
	
	
	oExcel:Activate()
	_cFile := (CriaTrab(NIL, .F.) + ".xml")
	While File(_cFile)
		_cFile := (CriaTrab(NIL, .F.) + ".xml")
	EndDo
	oExcel:GetXMLFile(_cFile)
	oExcel:DeActivate()
	If !(File(_cFile))
		_cFile := ""
		TMP->(DbCloseArea())
		Break
	EndIf
	_cFileTMP := (GetTempPath() + _cFile)
	If !(__CopyFile(_cFile , _cFileTMP))
		fErase( _cFile )
		_cFile := ""
		TMP->(DbCloseArea())
		Break
	EndIf
	fErase(_cFile)
	_cFile := _cFileTMP
	If !(File(_cFile))
		_cFile := ""
		TMP->(DbCloseArea())
		Break
	EndIf
	oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open(_cFile)
	oMsExcel:SetVisible(.T.)
	oMsExcel := oMsExcel:Destroy()
	
	FreeObj(oExcel)
	oExcel := NIL
	
EndIf
TMP->(DbCloseArea())

Return Nil           
