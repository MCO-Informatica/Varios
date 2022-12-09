#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBR003  ºAutor  ³Lucas Flóridi Leme  º Data ³  05/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Razão contábil em excel                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                              
User Function RCTBR005()

Local cPerg		:= PadR("RAZAOCTB",10)           

AjustaSx1(cPerg)
If Pergunte(cPerg,.T.)    

	Processa( {|| MexProcessa() },"Aguarde" ,"Processando...")
	Processa( {|| GeraExcel("TMP") },"Aguarde" ,"Gerando arquivo excel...")

EndIf

Return() 

          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MexProcessºAutor  ³Microsiga           º Data ³  08/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MexProcessa()
cQry := "SELECT CT2_FILIAL,CT2_TPSALD TIPOSALDO  " +Chr(13)
cQry += ",CONVERT(CHAR(10),CONVERT(DATE,CT2_DATA),103) 'DATA'  " +Chr(13)
cQry += ",CT1_CONTA CONTA " +Chr(13)
cQry += ",RTRIM(CT2_HIST+ISNULL((SELECT CT2_HIST  " +Chr(13)
cQry += "					FROM "+RetSqlName("CT2")+" CT22  " +Chr(13)
cQry += "					WHERE CT22.D_E_L_E_T_ = ' ' AND CT2.CT2_FILIAL=CT22.CT2_FILIAL AND CT22.CT2_SEQUEN=CT2.CT2_SEQUEN AND CT22.CT2_SEQLAN=CT2.CT2_SEQLAN " +Chr(13)
cQry += "					AND CT22.CT2_DATA=CT2.CT2_DATA AND CT22.CT2_LOTE=CT2.CT2_LOTE AND CT22.CT2_SBLOTE=CT2.CT2_SBLOTE AND CT22.CT2_DOC=CT2.CT2_DOC " +Chr(13)
cQry += "					AND CT22.CT2_TPSALD=CT2.CT2_TPSALD AND CT2_SEQHIS='002' AND CT2_DC='4'),'') " +Chr(13)
cQry += "				+ISNULL((SELECT CT2_HIST  " +Chr(13)
cQry += "					FROM "+RetSqlName("CT2")+" CT22  " +Chr(13)
cQry += "					WHERE CT22.D_E_L_E_T_ = ' ' AND CT2.CT2_FILIAL=CT22.CT2_FILIAL AND CT22.CT2_SEQUEN=CT2.CT2_SEQUEN AND CT22.CT2_SEQLAN=CT2.CT2_SEQLAN " +Chr(13)
cQry += "					AND CT22.CT2_DATA=CT2.CT2_DATA AND CT22.CT2_LOTE=CT2.CT2_LOTE AND CT22.CT2_SBLOTE=CT2.CT2_SBLOTE AND CT22.CT2_DOC=CT2.CT2_DOC " +Chr(13)
cQry += "					AND CT22.CT2_TPSALD=CT2.CT2_TPSALD AND CT2_SEQHIS='003' AND CT2_DC='4'),'') " +Chr(13)
cQry += "				+ISNULL((SELECT CT2_HIST  " +Chr(13)
cQry += "					FROM "+RetSqlName("CT2")+" CT22  " +Chr(13)
cQry += "					WHERE CT22.D_E_L_E_T_ = ' ' AND CT2.CT2_FILIAL=CT22.CT2_FILIAL AND CT22.CT2_SEQUEN=CT2.CT2_SEQUEN AND CT22.CT2_SEQLAN=CT2.CT2_SEQLAN " +Chr(13)
cQry += "					AND CT22.CT2_DATA=CT2.CT2_DATA AND CT22.CT2_LOTE=CT2.CT2_LOTE AND CT22.CT2_SBLOTE=CT2.CT2_SBLOTE AND CT22.CT2_DOC=CT2.CT2_DOC " +Chr(13)
cQry += "					AND CT22.CT2_TPSALD=CT2.CT2_TPSALD AND CT2_SEQHIS='004' AND CT2_DC='4'),'') " +Chr(13)
cQry += "				+ISNULL((SELECT CT2_HIST  " +Chr(13)
cQry += "					FROM "+RetSqlName("CT2")+" CT22  " +Chr(13)
cQry += "					WHERE CT22.D_E_L_E_T_ = ' ' AND CT2.CT2_FILIAL=CT22.CT2_FILIAL AND CT22.CT2_SEQUEN=CT2.CT2_SEQUEN AND CT22.CT2_SEQLAN=CT2.CT2_SEQLAN " +Chr(13)
cQry += "					AND CT22.CT2_DATA=CT2.CT2_DATA AND CT22.CT2_LOTE=CT2.CT2_LOTE AND CT22.CT2_SBLOTE=CT2.CT2_SBLOTE AND CT22.CT2_DOC=CT2.CT2_DOC " +Chr(13)
cQry += "					AND CT22.CT2_TPSALD=CT2.CT2_TPSALD AND CT2_SEQHIS='005' AND CT2_DC='4'),'') " +Chr(13)
cQry += "				+ISNULL((SELECT CT2_HIST  " +Chr(13)
cQry += "					FROM "+RetSqlName("CT2")+" CT22  " +Chr(13)
cQry += "					WHERE CT22.D_E_L_E_T_ = ' ' AND CT2.CT2_FILIAL=CT22.CT2_FILIAL AND CT22.CT2_SEQUEN=CT2.CT2_SEQUEN AND CT22.CT2_SEQLAN=CT2.CT2_SEQLAN " +Chr(13)
cQry += "					AND CT22.CT2_DATA=CT2.CT2_DATA AND CT22.CT2_LOTE=CT2.CT2_LOTE AND CT22.CT2_SBLOTE=CT2.CT2_SBLOTE AND CT22.CT2_DOC=CT2.CT2_DOC " +Chr(13)
cQry += "					AND CT22.CT2_TPSALD=CT2.CT2_TPSALD AND CT2_SEQHIS='006' AND CT2_DC='4'),'')) HISTORICO " +Chr(13)
cQry += ",CASE CT1_CONTA WHEN CT2_DEBITO THEN CT2_CREDIT WHEN CT2_CREDIT THEN CT2_DEBITO ELSE '' END XPARTIDA " +Chr(13)
cQry += ",CASE CT1_CONTA WHEN CT2_DEBITO THEN CT2_VALOR ELSE 0 END DEBITO " +Chr(13)
cQry += ",CASE CT1_CONTA WHEN CT2_CREDIT THEN CT2_VALOR ELSE 0 END CREDITO " +Chr(13)
cQry += ",CASE CV3_TABORI WHEN 'SE5' THEN E5_CLIFOR WHEN 'SF1' THEN F1_FORNECE WHEN 'SD1' THEN D1_FORNECE WHEN 'SF2' THEN F2_CLIENTE WHEN 'SD2' THEN D2_CLIENTE WHEN 'SE1' THEN E1_CLIENTE WHEN 'SE2' THEN E2_FORNECE ELSE '' END CLIFOR " +Chr(13)
//cQry += ",CASE CV3_TABORI WHEN 'SE5' THEN E5_NUMERO WHEN 'SF1' THEN F1_DOC WHEN 'SF2' THEN F2_DOC WHEN 'SE1' THEN E1_NUM WHEN 'SE2' THEN E2_NUM ELSE '' END DOCUMENTO " +Chr(13)
//cQry += ",CASE CV3_TABORI WHEN 'SE5' THEN E5_NUMERO WHEN 'SF1' THEN F1_DOC WHEN 'SF2' THEN F2_DOC WHEN 'SE1' THEN E1_NUM WHEN 'SE2' THEN E2_NUM WHEN 'SD1' THEN (CASE D1_NUMPO WHEN '' THEN D1_DOC ELSE D1_NUMPO END)  ELSE '' END DOCUMENTO " +Chr(13) 
//cQry += ",CASE CV3_TABORI  WHEN 'SE5' THEN E5_NUMERO  WHEN 'SF1' THEN F1_DOC  WHEN 'SF2' THEN F2_DOC  WHEN 'SE1' THEN E1_NUM  WHEN 'SE2' THEN E2_NUM  WHEN 'SD1' THEN (CASE D1_NUMPO WHEN '' THEN D1_DOC ELSE D1_NUMPO END)  WHEN 'SE2' THEN E2_NUM  WHEN 'SD2' THEN D2_DOC ELSE '' END DOCUMENTO" +Chr(13) 
cQry += ",CASE CV3_TABORI  WHEN 'SE5' THEN E5_NUMERO  WHEN 'SF1' THEN F1_DOC  WHEN 'SF2' THEN F2_DOC  WHEN 'SE1' THEN E1_NUM  WHEN 'SE2' THEN E2_NUM  WHEN 'SD1' THEN (CASE D1_NUMPO WHEN '' THEN D1_DOC ELSE D1_DOC END)  WHEN 'SE2' THEN E2_NUM  WHEN 'SD2' THEN D2_DOC ELSE '' END DOCUMENTO" +Chr(13) 
cQry += ",CT2_LOTE LOTE " +Chr(13)
//cQry += ",CT2_SBLOTE SUBLOTE " +Chr(13)
cQry += ",CT2_DOC DOCCOBTA " +Chr(13)
cQry += ",CT2_LINHA LINHA " +Chr(13)
//cQry += ",CONVERT(CHAR(10),CONVERT(DATE,CT2_DATA),103)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA AS KEYBUSCA  " +Chr(13)
cQry += ",CV3_TABORI,CV3_RECORI "+Chr(13)

//cQry += ",CASE CV3_TABORI WHEN 'SE5' THEN E5_CLIFOR WHEN 'SF1' THEN F1_FORNECE WHEN 'SF2' THEN F2_CLIENTE WHEN 'SE1' THEN E1_CLIENTE WHEN 'SE2' THEN E2_FORNECE ELSE '' END CLIFOR " +Chr(13)
//cQry += ",CASE CV3_TABORI WHEN 'SE5' THEN E5_NUMERO WHEN 'SF1' THEN F1_DOC WHEN 'SF2' THEN F2_DOC WHEN 'SE1' THEN E1_NUM WHEN 'SE2' THEN E2_NUM ELSE '' END DOCUMENTO " +Chr(13)

//cQry += ",CASE CV3_TABORI WHEN 'SE5' THEN E5_PARCELA WHEN 'SF1' THEN '' WHEN 'SF2' THEN '' WHEN 'SE1' THEN E1_PARCELA WHEN 'SE2' THEN E2_PARCELA ELSE '' END DOC_PARC " +Chr(13)
//cQry += ",CASE CV3_TABORI WHEN 'SE5' THEN E5_TIPO WHEN 'SF1' THEN F1_ESPECIE WHEN 'SF2' THEN F2_ESPECIE WHEN 'SE1' THEN E1_TIPO WHEN 'SE2' THEN E2_TIPO ELSE '' END TIPODOC " +Chr(13)
//cQry += ",CASE CV3_TABORI WHEN 'SE5' THEN E5_DOCUMEN ELSE '' END DOC_COMP " +Chr(13)
//cQry += ",CASE CT2_MANUAL WHEN '1' THEN 'MANUAL' ELSE 'AUTO' END 'MANUAL' " +Chr(13)
//cQry += ",CT2_FILORI FILORI " +Chr(13)
cQry += ",CT2_ORIGEM ORIGEM,CT2_ROTINA ROTINA,CT2_LP LP,CT2.R_E_C_N_O_ REG_CT2 " +Chr(13)
cQry += "FROM "+RetSqlName("CT1")+" CT1 " +Chr(13)
cQry += "	INNER JOIN "+RetSqlName("CT2")+" CT2 ON CT2.D_E_L_E_T_= ' ' " +Chr(13)
cQry += "		AND CT2_DC IN ('1','2','3') " +Chr(13)
cQry += "		AND CT2_TPSALD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " +Chr(13)
cQry += "		AND CT2_DATA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' " +Chr(13)
cQry += "		AND CT2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " +Chr(13)
//cQry += "		AND CT2_FILORI BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' " +Chr(13) 
cQry += "		AND CT2_MOEDLC = '01' " +Chr(13)
cQry += "		AND (CT2_DEBITO=CT1_CONTA OR CT2_CREDIT =CT1_CONTA) " +Chr(13)            
cQry += "	LEFT OUTER JOIN "+RetSqlName("CV3")+" CV3 ON CV3.D_E_L_E_T_ = ' ' AND CV3_FILIAL=CT2_FILIAL AND CV3_RECDES=CONVERT(VARCHAR,CT2.R_E_C_N_O_) AND CV3.CV3_DTSEQ BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' " +Chr(13)            
cQry += "		AND CV3.R_E_C_N_O_=(SELECT MAX(R_E_C_N_O_) FROM "+RetSqlName("CV3")+" CV3X WHERE CV3_RECDES=CONVERT(VARCHAR,CT2.R_E_C_N_O_) AND  CV3.D_E_L_E_T_ = ' ' AND CV3.CV3_DTSEQ BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' ) " +Chr(13)            
cQry += "	LEFT OUTER JOIN "+RetSqlName("SF1")+" SF1 ON SF1.F1_FILIAL = CV3_FILIAL AND SF1.D_E_L_E_T_ = ' ' AND SF1.R_E_C_N_O_=CV3_RECORI " +Chr(13)            
cQry += "	LEFT OUTER JOIN "+RetSqlName("SF2")+" SF2 ON SF2.F2_FILIAL = CV3_FILIAL AND SF2.D_E_L_E_T_ = ' ' AND SF2.R_E_C_N_O_=CV3_RECORI " +Chr(13)
cQry += "	LEFT OUTER JOIN "+RetSqlName("SE1")+" SE1 ON SE1.E1_FILIAL = CV3_FILIAL AND SE1.D_E_L_E_T_ = ' ' AND SE1.R_E_C_N_O_=CV3_RECORI " +Chr(13)
cQry += "	LEFT OUTER JOIN "+RetSqlName("SE2")+" SE2 ON SE2.E2_FILIAL = CV3_FILIAL AND SE2.D_E_L_E_T_ = ' ' AND SE2.R_E_C_N_O_=CV3_RECORI " +Chr(13)
cQry += "	LEFT OUTER JOIN "+RetSqlName("SE5")+" SE5 ON SE5.E5_FILIAL = CV3_FILIAL AND SE5.D_E_L_E_T_ = ' ' AND SE5.R_E_C_N_O_=CV3_RECORI " +Chr(13)
cQry += "	LEFT OUTER JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_FILIAL = CV3_FILIAL AND SD1.D_E_L_E_T_ = ' ' AND SD1.R_E_C_N_O_=CV3_RECORI " +Chr(13)
cQry += "	LEFT OUTER JOIN "+RetSqlName("SD2")+" SD2 ON SD2.D2_FILIAL = CV3_FILIAL AND SD2.D_E_L_E_T_ = ' ' AND SD2.R_E_C_N_O_=CV3_RECORI " +Chr(13)
cQry += "WHERE CT1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " +Chr(13)
cQry += "AND CT1.D_E_L_E_T_ = ' ' "
cQry += "ORDER BY CT2_TPSALD,CT2_DATA,CT1_CONTA " +Chr(13)

Memowrite("RCTBR005.txt",cQry)
TcQuery cQry New Alias "TMP"                                       

TcSetField("TMP","DEBITO","N",TamSx3("CT2_VALOR")[1],2)        
TcSetField("TMP","CREDITO","N",TamSx3("CT2_VALOR")[1],2)  
TcSetField("TMP","REG_CT2","N",14,0)  

                      
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³                    º Data ³  02/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)

Local aRea	:= GetArea()
Local aSx1	:= {}
Local I as numeric

DBSelectArea("SX1")
SX1->(DBSetOrder(1))
cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
SX1->(DBSeek(cPerg+"01"))       
AADD(	aSx1,{ cPerg,"01","De Filial?"		,"mv_par01"	,"C",TAMSX3("CT1_FILIAL")[1],0,0,"G","",	"mv_par01","","","","","SM0_01","" } )
AADD(	aSx1,{ cPerg,"02","Ate Filial?"		,"mv_par02"	,"C",TAMSX3("CT1_FILIAL")[1],0,0,"G","",	"mv_par02","","","","","SM0_01","" } )

AADD(	aSx1,{ cPerg,"03","De Data?"			,"mv_par03"	,"D",8,0,0,"G","", 	"mv_par03","","","","","","" } )
AADD(	aSx1,{ cPerg,"04","Ate Data?"			,"mv_par04"	,"D",8,0,0,"G","",	"mv_par04","","","","","","" } ) 

AADD(	aSx1,{ cPerg,"05","De Conta?"	    	,"mv_par05"	,"C",20,0,0,"G","",	"mv_par05","","","","","CT1" } )
AADD(	aSx1,{ cPerg,"06","Ate Conta?"		,"mv_par06"	,"C",20,0,0,"G","",	"mv_par06","","","","","CT1" } )

AADD(	aSx1,{ cPerg,"07","De Tipo Saldo?" 	,"mv_par07"	,"C",01,0,0,"G","",	"mv_par07","","","","","SLW" } )
AADD(	aSx1,{ cPerg,"08","Ate Tipo Saldo?" ,"mv_par08"	,"C",01,0,0,"G","",	"mv_par08","","","","","SLW" } )

AADD(	aSx1,{ cPerg,"09","De Fil Origem?"	,"mv_par09"	,"C",TAMSX3("CT1_FILIAL")[1],0,0,"G","",	"mv_par09","","","","","SM0_01","" } )
AADD(	aSx1,{ cPerg,"10","Ate Fil Origem?"	,"mv_par10"	,"C",TAMSX3("CT1_FILIAL")[1],0,0,"G","",	"mv_par10","","","","","SM0_01","" } )

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
			SX1->X1_PRESEL		:= aSx1[i][8] //Pre seleção do combo
			SX1->X1_GSC		:= aSx1[i][9] //Tipo de componente
			SX1->X1_VAR01		:= aSx1[i][10]//Variavel que carrega resposta
			SX1->X1_DEF01		:= aSx1[i][11]//Definições do combo-box
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GeraExcel ºAutor  ³                    º Data ³  05/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geracao de arquivo excel 						              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraExcel(cAlias)
// Local _cPathExcel:="C:\MICROSIGA\"
Local _x as numeric

DbSelectArea("TMP")
DbGotop()
ProcRegua(TMP->(RecCount()))
If !TMP->(Eof())
	_aStru := TMP->(DbStruct())
	oExcel    := FWMSEXCEL():New()
	oExcel:AddworkSheet("RAZAO CONTABIL")
	oExcel:AddTable ("RAZAO CONTABIL","RAZAO CONTABIL")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("RAZAO CONTABIL","RAZAO CONTABIL",_aStru[_x,1],3,2)
		ElseIf _aStru[_x,2] == "C"
			If "/" $ _aStru[_x,1]
				oExcel:AddColumn("RAZAO CONTABIL","RAZAO CONTABIL",_aStru[_x,1],1,4)
			Else
				oExcel:AddColumn("RAZAO CONTABIL","RAZAO CONTABIL",_aStru[_x,1],1,1)
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
		
		oExcel:AddRow("RAZAO CONTABIL","RAZAO CONTABIL",_aLinha)
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
