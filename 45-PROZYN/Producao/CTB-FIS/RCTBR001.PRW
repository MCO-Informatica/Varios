#Include "Protheus.ch"
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBR001  บAutor  ณLucas Fl๓ridi Leme  บ Data ณ  19/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rela็ใo das entradas em excel                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11 Cittati                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑ Leandro Cardoso. 07.01.15 O Ajuste no sistema para considerar a filial  ฑฑ
ฑฑ da SB1                                                                  ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                              
User Function RCTBR001()

Local cPerg		:= PadR("ENTRADCTB",10)          

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
cQuery += "SELECT '"+cEmpAnt+"' EMPRESA,D1_FILIAL AS FILIAL," + Chr(13)
cQuery += " SUBSTRING(D1_DTDIGIT,7,2) + '/' + SUBSTRING(D1_DTDIGIT,5,2) + '/' + SUBSTRING(D1_DTDIGIT,1,4) DT_DATA, " +  Chr(13)
cQuery += " SUBSTRING(D1_EMISSAO,7,2) + '/' + SUBSTRING(D1_EMISSAO,5,2) + '/' + SUBSTRING(D1_EMISSAO,1,4) DT_EMISSAO, " +  Chr(13)
cQuery += "	D1_DOC NOTA, " + Chr(13)            
cQuery += "	D1_TIPO TIPO, " + Chr(13) 
//cQuery += "	A2_NOME FORNEC, " + Chr(13)   
cQuery += "	CASE WHEN D1_TIPO <> 'B' AND D1_TIPO <> 'D' "
cQuery += "		THEN (SELECT A2_NOME FROM " + RetSqlName('SA2') + " WHERE D_E_L_E_T_ <> '*' AND A2_FILIAL = '" + xFilial('SA2') + "' AND A2_COD = SD1.D1_FORNECE AND A2_LOJA = SD1.D1_LOJA) "
cQuery += "		ELSE (SELECT A1_NOME FROM " + RetSqlName('SA1') + " WHERE D_E_L_E_T_ <> '*' AND A1_FILIAL = '" + xFilial('SA1') + "' AND A1_COD = SD1.D1_FORNECE AND A1_LOJA = SD1.D1_LOJA) END FORN_CLI, " + Chr(13)   
cQuery += "	D1_FORNECE CLIEFOR, " + Chr(13)
cQuery += "	D1_LOJA LOJA, " + Chr(13)
cQuery += "	B1_COD CODIGO, " + Chr(13)
cQuery += "	B1_DESC PRODUTO, " + Chr(13)
cQuery += "	D1_UM UNID, " + Chr(13)      
cQuery += "	B1_TIPO TIPOPROD, " + Chr(13)      
cQuery += "	D1_QUANT QUANT, " + Chr(13)
cQuery += "	D1_VUNIT VLR_UNIT, " + Chr(13)
cQuery += "	D1_TOTAL TOTAL, " + Chr(13)    
cQuery += "	D1_CONTA D1_CONTA, " + Chr(13)
cQuery += "	B1_CONTA B1_CONTA, " + Chr(13)
cQuery += "	D1_CC CCUSTO, " + Chr(13)
cQuery += "	D1_ITEMCTA ITEMCTA, " + Chr(13)
cQuery += "	D1_CC D1_CC, " + Chr(13)  
//cQuery += "	D1_SERV_CA SERV_CA, " + Chr(13)  
cQuery += "	D1_TES TES, " + Chr(13)  
cQuery += "	D1_CF CFOP, " + Chr(13) 
cQuery += "	D1_CLASFIS CLA_FISC, " + Chr(13)
cQuery += "	D1_PICM ALIQICMS, " + Chr(13)   
cQuery += "	D1_VALICM VLRICMS, " + Chr(13)
cQuery += "	F4_ICM CALCICM, " + Chr(13)
cQuery += "	D1_ICMSRET VLRICMSST, " + Chr(13)
cQuery += "	D1_IPI ALIQIPI, " + Chr(13)  
cQuery += "	D1_VALIPI VLRIPI, " + Chr(13)      
cQuery += "	F4_IPI CALCIPI, " + Chr(13)
cQuery += "	D1_BASIMP5 BAS_COF, " + Chr(13) 
cQuery += "	D1_ALQIMP5 ALQ_COF, " + Chr(13)
cQuery += "	D1_VALIMP5 VLR_COF, " + Chr(13)
cQuery += "	D1_BASIMP6 BAS_PIS, " + Chr(13) 
cQuery += "	D1_ALQIMP6 ALQ_PIS, " + Chr(13)
cQuery += "	D1_VALIMP6 VLR_PIS, " + Chr(13)
cQuery += "	D1_VALISS VLR_ISS, " + Chr(13)     
cQuery += "	D1_VALIRR VLRRET_IR, " + Chr(13) 
cQuery += "	D1_VALINS VLRRET_INS, " + Chr(13)
cQuery += "	D1_VALPIS VLRRET_PIS, " + Chr(13)
cQuery += "	D1_VALCOF VLRRET_COF, " + Chr(13)
cQuery += "	D1_VALCSL VLRRET_CSL, " + Chr(13)
cQuery += "	D1_VALFRE VLRFRETE, " + Chr(13)   
cQuery += "	D1_DESPESA VLRDESPES, " + Chr(13)   
cQuery += "	D1_VALDESC VLRDESC, " + Chr(13)   
cQuery += "	F4_ESTOQUE ESTOQUE, " + Chr(13)   
cQuery += "	F4_DUPLIC DUPLIC, " + Chr(13)  
cQuery += "	F4_XCONTAB GRPCONTAB, " + Chr(13)  
cQuery += "	D1_CUSTO CUSTO, " + Chr(13)  
cQuery += "	ISNULL(F3_OBSERV,'') OBSERV, " + Chr(13)  
cQuery += "	FT_ESTADO ESTADO " + Chr(13)  

cQuery += "FROM " + RetSqlName("SD1") + " SD1 "+ Chr(13)
//cQuery += RetSqlName("SB1") + " SB1 , " + RetSqlName("SF4") + " SF4 , " + RetSqlName("SA2") + " SA2 , " + RetSqlName("SD1") + " SD1 " + Chr(13)

//////////////////////////////////////
//*Leandro Cardoso. 07.01.15 Inicio//
////////////////////////////////////

IF Len(RTRIM(xFilial("SB1")))= 3
	cQuery += "	INNER JOIN "+RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = SUBSTRING(D1_FILIAL,1,3) AND B1_COD = D1_COD " +Chr(13)
ElseIf Len(RTRIM(xFilial("SB1")))= 6
	cQuery += "	INNER JOIN "+RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = SUBSTRING(D1_FILIAL,1,6) AND B1_COD = D1_COD " +Chr(13)
ElseIf Len(RTRIM(xFilial("SB1")))= 9
	cQuery += "	INNER JOIN "+RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = SUBSTRING(D1_FILIAL,1,9) AND B1_COD = D1_COD " +Chr(13)
else	
	cQuery += "	INNER JOIN "+RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = "+IF(EMPTY(xFilial("SB1")),"''","D1_FILIAL")+" AND B1_COD = D1_COD " +Chr(13)
EndIf
//cQuery += "	INNER JOIN "+RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = "+IF(EMPTY(xFilial("SB1")),"''","D1_FILIAL")+" AND B1_COD = D1_COD " +Chr(13)

///////////////////////////////////
//*Leandro Cardoso. 07.01.15 Fim//
/////////////////////////////////

cQuery += " INNER JOIN "+RetSqlName("SF4") + " SF4 ON SF4.D_E_L_E_T_ = ' ' AND F4_FILIAL = "+IF(EMPTY(xFilial("SF4")),"''","D1_FILIAL")+" AND D1_TES = F4_CODIGO " + Chr(13)

cQuery += " 	LEFT OUTER JOIN "+ RetSqlName("SFT") + " SFT ON SFT.D_E_L_E_T_<>'*' " +Chr(13)
cQuery += " 	 		AND FT_FILIAL = D1_FILIAL AND FT_NFISCAL=D1_DOC AND FT_SERIE=D1_SERIE AND FT_CLIEFOR=D1_FORNECE AND FT_LOJA=D1_LOJA AND FT_ITEM=D1_ITEM " +Chr(13)
cQuery += " 	 	LEFT OUTER JOIN "+ RetSqlName("SF3") + " SF3 ON SF3.D_E_L_E_T_<>'*'  " +Chr(13)
cQuery += " 	 		AND F3_FILIAL = FT_FILIAL AND F3_NFISCAL=FT_NFISCAL AND F3_SERIE=FT_SERIE AND F3_CLIEFOR=FT_CLIEFOR AND F3_LOJA=FT_LOJA AND F3_IDENTFT=FT_IDENTF3  " +Chr(13)

cQuery += " WHERE SD1.D_E_L_E_T_ = ' ' AND "+ Chr(13)     
//cQuery += " D1_FILIAL = '" + xFilial("SD1") + "' AND " + Chr(13)
cQuery += " D1_TES <> '' AND " + Chr(13)     
cQuery += " D1_FORNECE BETWEEN '" + mv_par01 + "' AND '" + mv_par03 + "' AND " + Chr(13)
cQuery += " D1_LOJA BETWEEN '" + mv_par02 + "' AND '" + mv_par04 + "' AND " + Chr(13)
cQuery += "	D1_DTDIGIT BETWEEN '" + DToS(mv_par05) + "' AND '" + DTos(mv_par06) + "' AND " + Chr(13)
cQuery += " D1_COD BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " + Chr(13)
cQuery += " ORDER BY FILIAL,DT_DATA, NOTA "
Memowrite("RCTBR001.txt",cQuery)
TcQuery cQuery New Alias "TMP"                                       

TcSetField("TMP","QUANT","N",TamSx3("D1_QUANT")[1],2)        
TcSetField("TMP","CUSTO","N",TamSx3("D1_CUSTO")[1],TamSx3("D1_CUSTO")[2])        
TcSetField("TMP","VLR_UNIT","N",TamSx3("D1_VUNIT")[1],4)  
TcSetField("TMP","TOTAL","N",TamSx3("D1_TOTAL")[1],2)
TcSetField("TMP","ALIQICMS","N",TamSx3("D1_PICM")[1],2)
TcSetField("TMP","VLRICMS","N",TamSx3("D1_VALICM")[1],2) 
TcSetField("TMP","ALIQIPI","N",TamSx3("D1_IPI")[1],2)
TcSetField("TMP","VLRIPI","N",TamSx3("D1_VALIPI")[1],2) 
TcSetField("TMP","VLRFRETE","N",TamSx3("D2_VALFRE")[1],2)    
TcSetField("TMP","BAS_PIS","N",TamSx3("D1_BASIMP5")[1],2) 
TcSetField("TMP","ALQ_PIS","N",TamSx3("D1_ALQIMP5")[1],2)
TcSetField("TMP","VLR_PIS","N",TamSx3("D1_VALIMP5")[1],2)
TcSetField("TMP","BAS_COFINS","N",TamSx3("D1_BASIMP6")[1],2) 
TcSetField("TMP","ALQ_COFINS","N",TamSx3("D1_ALQIMP6")[1],2)
TcSetField("TMP","VLR_COFINS","N",TamSx3("D1_VALIMP6")[1],2) 
TcSetField("TMP","VLR_ISS","N",TamSx3("D1_VALISS")[1],2)
TcSetField("TMP","VLR_IR","N",TamSx3("D1_VALIRR")[1],2)
TcSetField("TMP","VLR_INSS","N",TamSx3("D1_VALINS")[1],2)

                      
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
AADD(	aSx1,{ cPerg,"01","Fornecedor de?"		,"mv_par01"	,"C",6,0,0,"G","",	"mv_par01","","","","","SA2" } )
AADD(	aSx1,{ cPerg,"02","Loja de?"			,"mv_par02"	,"C",2,0,0,"G","",	"mv_par02","","","","","","" } )
AADD(	aSx1,{ cPerg,"03","Fornecedor ate?"		,"mv_par03"	,"C",6,0,0,"G","",	"mv_par03","","","","","SA2" } ) 
AADD(	aSx1,{ cPerg,"04","Loja ate?"			,"mv_par04"	,"C",2,0,0,"G","",	"mv_par04","","","","","","" } ) 
AADD(	aSx1,{ cPerg,"05","Digitacao NF de?"	,"mv_par05"	,"D",8,0,0,"G","", 	"mv_par05","","","","","","" } )
AADD(	aSx1,{ cPerg,"06","Digitacao NF ate?"	,"mv_par06"	,"D",8,0,0,"G","",	"mv_par06","","","","","","" } ) 
AADD(	aSx1,{ cPerg,"07","Produto de?"	    	,"mv_par07"	,"C",15,0,0,"G","",	"mv_par07","","","","","SB1" } )
AADD(	aSx1,{ cPerg,"08","Produto Ate?"		,"mv_par08"	,"C",15,0,0,"G","",	"mv_par08","","","","","SB1" } )

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
	oExcel:AddworkSheet("ENTRADAS EM EXCEL")
	oExcel:AddTable ("ENTRADAS EM EXCEL","ENTRADAS EM EXCEL")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("ENTRADAS EM EXCEL","ENTRADAS EM EXCEL",_aStru[_x,1],3,2)
		ElseIf _aStru[_x,2] == "C"
			If "/" $ _aStru[_x,1]
				oExcel:AddColumn("ENTRADAS EM EXCEL","ENTRADAS EM EXCEL",_aStru[_x,1],1,4)
			Else
				oExcel:AddColumn("ENTRADAS EM EXCEL","ENTRADAS EM EXCEL",_aStru[_x,1],1,1)
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
		
		oExcel:AddRow("ENTRADAS EM EXCEL","ENTRADAS EM EXCEL",_aLinha)
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
