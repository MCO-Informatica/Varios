#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFATR010 บAutor  ณBruno Daniel Borges บ Data ณ  18/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Personalizacoes de lacres por cliente          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFATR010()

PutSx1("RFATR010","01","Cliente"		,"Cliente"		,"Cliente"		, "mv_ch1","C",06,0,0,"G","","SA1","","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
PutSx1("RFATR010","02","Loja"			,"Loja"			,"Loja"			, "mv_ch2","C",02,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","","","","")
PutSx1("RFATR010","03","Pedido De"		,"Pedido De"	,"Pedido De"	, "mv_ch3","C",06,0,0,"G","","SC5","","","MV_PAR03","","","","","","","","","","","","","","","","","","","")
PutSx1("RFATR010","04","Pedido Ate"		,"Pedido Ate"	,"Pedido Ate"	, "mv_ch4","C",06,0,0,"G","","SC5","","","MV_PAR04","","","","","","","","","","","","","","","","","","","")
PutSx1("RFATR010","05","Entrega De"		,"Entrega De"	,"Entrega De"	, "mv_ch5","D",08,0,0,"G","","","","","MV_PAR05","","","","","","","","","","","","","","","","","","","")
PutSx1("RFATR010","06","Entrega Ate"	,"Entrega Ate"	,"Entrega Ate"	, "mv_ch6","D",08,0,0,"G","","","","","MV_PAR06","","","","","","","","","","","","","","","","","","","")
PutSx1("RFATR010","07","Qtd.Max.Selos"	,"Qtd.Max.Selos","Qtd.Max.Selos", "mv_ch7","C",03,0,0,"C","","","","","MV_PAR07","100","100","100",,"50","50","50","","","","","","","","","","","","")

If !Pergunte("RFATR010",.T.)
     Return(Nil)
EndIf

Processa({|| RFATR010Prc() })

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR010Prc บAutor  ณBruno Daniel Borges บ Data ณ  18/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento do relatorio                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RFATR010Prc()
Local cQuery  := ""
Local bQuery  := {|| Iif(Select("TMP_LACRE") > 0, TMP_LACRE->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_LACRE",.F.,.T.) , dbSelectArea("TMP_LACRE"), TMP_LACRE->(dbGoTop()), TMP_LACRE->(dbEval({|| nQtdReg++ })) , TMP_LACRE->(dbGoTop()) }
Local nQtdReg := 0 
Local oPrint  := Nil 
Local nSeq    := 0  
Local oFonte1 := TFont():New("Arial",08,08,,.F.,,,,.F.,.F.)  
Local nLinha  := 0         
Local nColuna := 1
Local aColunas:= {}//{{105,362,621},{1653,1911,2169}}  
//Local aColunas:= {{105,362,621},{879,1137,1395},{1653,1911,2169},{2427,2685,2943}}  
Local i                                                                

Private cNomeCli := Posicione("SA1",1,xFilial("SA1")+mv_par01+mv_par02,"SA1->A1_NOME")      

If MV_PAR07 == 2
	aColunas:= {{105,362,621},{1653,1911,2169}}  
Else
	aColunas:= {{105,362,621},{879,1137,1395},{1653,1911,2169},{2427,2685,2943}} 
Endif

//Query do Relatorio                                                                                 
cQuery := " SELECT C6_XLACRE, Z00_CODCEM, Z01_INIC, Z01_FIM, Z00_TMLACR, Z01_PV, Z01_ITEMPV "+Chr(13)+Chr(10)
cQuery += " FROM " + RetSQLName("SC6") + " SC6, " + RetSQLName("Z00") + " Z00, " + RetSQLName("Z01") + " Z01 "+Chr(13)+Chr(10)
cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "+Chr(13)+Chr(10)
cQuery += "       C6_CLI = '" + mv_par01 + "' AND C6_LOJA = '" + mv_par02 + "' AND "+Chr(13)+Chr(10)
cQuery += "       SC6.D_E_L_E_T_ = ' ' AND "+Chr(13)+Chr(10)
cQuery += "       Z00_FILIAL = '" + xFilial("Z00") + "' AND Z00_COD = C6_XLACRE AND Z00.D_E_L_E_T_ = ' ' AND "+Chr(13)+Chr(10)
cQuery += "       Z01_FILIAL = '" + xFilial("Z01") + "' AND Z01_COD = Z00_COD AND Z01_PV = C6_NUM AND Z01_ITEMPV = C6_ITEM AND Z01.D_E_L_E_T_ = ' ' "+Chr(13)+Chr(10)
cQuery += " ORDER BY C6_XLACRE, Z01_PV, Z01_ITEMPV "
LJMsgRun("Consultando Lacres...","Aguarde...",bQuery)

If TMP_LACRE->(Eof())
	MsgAlert("Nenhuma informa็ใo de LACRE x PEDIDO foi localizada com os parโmetros indicados.")
	Return(Nil)
EndIf  

//Inicia o objeto grafico do relatorio
oPrint:= TMSPrinter():New("Relacao de Lacres - CEMIG")
oPrint:SetLandScape()

ProcRegua(nQtdReg)
Moldura(@oPrint) 

While TMP_LACRE->(!Eof())
	IncProc()        
	For i := TMP_LACRE->Z01_INIC To TMP_LACRE->Z01_FIM  	            
		nSeq++ 
		nLinha++
		        
		//Quebra de Pagina
		If MV_PAR07 == 1
			If nSeq > 100
				nSeq    := 1
				nColuna := 1
				nLinha  := 1
				Moldura(@oPrint)
			EndIf  
		Else
			If nSeq > 50
				nSeq    := 1
				nColuna := 1
				nLinha  := 1
				Moldura(@oPrint)
			EndIf  
		Endif           
		
		//Reinicio da Linha
		If nLinha > 25
			nLinha := 1 
			nColuna++
		EndIf        
		
		If MV_PAR07 == 1
			oPrint:Say(nLinha*45+520+3,aColunas[nColuna,1], "  " + TMP_LACRE->Z00_CODCEM, oFonte1)
			oPrint:Say(nLinha*45+520+3,aColunas[nColuna,2],"    " + StrZero(i,TMP_LACRE->Z00_TMLACR),oFonte1)
		Else                        
			//nColuna++
			oPrint:Say(nLinha*45+520+3,aColunas[nColuna,1], "  " + TMP_LACRE->Z00_CODCEM, oFonte1)
			oPrint:Say(nLinha*45+520+3,aColunas[nColuna,2],"    " + StrZero(i,TMP_LACRE->Z00_TMLACR),oFonte1)		
		Endif
	Next i        
	If MV_PAR07 == 1
		nSeq :=100      
	Else
		nSeq :=50
	Endif
		
	TMP_LACRE->(dbSkip())
EndDo  

oPrint:EndPage()
oPrint:Preview()

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Moldura  บAutor  ณBruno Daniel Borges บ Data ณ  18/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDesenha a moldura do relatorio                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Moldura(oPrint)
Local oFonte1 := TFont():New("Arial",10,10,,.T.,,,,.F.,.F.)  
Local oFonte2 := TFont():New("Arial",07.5,07.5,,.T.,,,,.F.,.F.)  
Local oFonte3 := TFont():New("Arial",08,08,,.F.,,,,.F.,.F.) 
Local oFonte4 := TFont():New("Arial",08,08,,.T.,,,,.F.,.F.)   
Local i

oPrint:EndPage()
oPrint:StartPage()

oPrint:Box(100,100,1680,3200)

oPrint:Say(0110,0110,"EMPRESA: " + cNomeCli,oFonte1)
	oPrint:Line(0155,100,0155,3200)
oPrint:Say(0160,0110,"EMPREGADO",oFonte1)
oPrint:Say(0160,2000,"MATRอCULA",oFonte1)
	oPrint:Line(0205,100,0205,3200)
oPrint:Say(0210,0110,"DATA",oFonte1)

	oPrint:Line(0255,100,0255,3200)
oPrint:Say(0260,0110,"1 - Conferir a numera็ใo e a quantidade que estแ sendo entregue",oFonte3)
	oPrint:Line(0305,100,0305,3200)
oPrint:Say(0310,0110,"2 - Anotar, com letra legํvel, n๚mero de servi็o onde o selo foi utilizado conforme tabela abaixo.",oFonte3)
	oPrint:Line(0355,100,0355,3200)
oPrint:Say(0360,0110,"3 - Nใo deixar os selos em locais de fแcil acesso.",oFonte3)
	oPrint:Line(0405,100,0405,3200)
oPrint:Say(0410,0110,"4 - EM CASO DE ROUBO, FURTO OU EXTRAVIO, ษ OBRIGATำRIO APRESENTAวรO DO REGISTRO POLICIAL",oFonte3)
	oPrint:Line(0455,100,0455,3200)
oPrint:Say(0460,0110,"5 - Somente serแ liberado novo lote com a devolu็ใo da planilha preenchida e assinada",oFonte3)
                                
oPrint:Say(0515,0105,"PERSONALIZAวรO",oFonte2)         
oPrint:Say(0515,0362,"No. DO SELO",oFonte2)         
oPrint:Say(0515,0621,"ORDEM DE SERVIวO",oFonte2) 

If MV_PAR07 == 1
	oPrint:Say(0515,0879,"PERSONALIZAวรO",oFonte2)         
	oPrint:Say(0515,1137,"No. DO SELO",oFonte2)         
	oPrint:Say(0515,1395,"ORDEM DE SERVIวO",oFonte2)         
Endif

oPrint:Say(0515,1653,"PERSONALIZAวรO",oFonte2)         
oPrint:Say(0515,1911,"No. DO SELO",oFonte2)         
oPrint:Say(0515,2169,"ORDEM DE SERVIวO",oFonte2)         

If MV_PAR07 == 1
	oPrint:Say(0515,2427,"PERSONALIZAวรO",oFonte2)         
	oPrint:Say(0515,2685,"No. DO SELO",oFonte2)         
	oPrint:Say(0515,2943,"ORDEM DE SERVIวO",oFonte2)         
Endif
         
oPrint:Line(0510,100,0510,3200)
oPrint:Line(0510,0358,1680,0358)
oPrint:Line(0510,0616,1680,0616)
oPrint:Line(0510,0874,1680,0874)

If MV_PAR07 == 1
	oPrint:Line(0510,1132,1680,1132)
	oPrint:Line(0510,1390,1680,1390)
Endif

oPrint:Line(0510,1648,1680,1648)

oPrint:Line(0510,1906,1680,1906)
oPrint:Line(0510,2164,1680,2164)
oPrint:Line(0510,2422,1680,2422)

If MV_PAR07 == 1
	oPrint:Line(0510,2680,1680,2680)
	oPrint:Line(0510,2938,1680,2938)
	oPrint:Line(0555,100,0555,3200)
Endif

nLinha := 555
For i := 1 To 25 
	oPrint:Line(nLinha,100,nLinha,3200)
	nLinha += 45
Next i     

oPrint:Box(1690,100,1750,1500)
	oPrint:Say(1695,105,"ษ RESPONSABILIDADE DE CADA ELETRECISTA ZELAR POR SEUS SELOS. ANOTAR OBSERVAวีES NO VERSO.",oFonte2)
oPrint:Box(1690,1550,1750,3200)
	oPrint:Say(1695,1555,"ษ RESPONSABILIDADE DE CADA ELETRECISTA ZELAR POR SEUS SELOS. ANOTAR OBSERVAวีES NO VERSO.",oFonte2)
oPrint:Box(1690,100,1750,1500)

oPrint:Box(1760,100,1870,700) 
	oPrint:Say(1765,105,"ASSINATURA",oFonte4)
oPrint:Box(1760,710,1870,1500)
	oPrint:Say(1765,715,"DATA",oFonte4)
oPrint:Box(1760,1550,1870,2450)
	oPrint:Say(1765,1555,"ASSINATURA",oFonte4)
oPrint:Box(1760,2460,1870,3200)
	oPrint:Say(1765,2465,"DATA",oFonte4)

Return(Nil)