	#include "Rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT011   บAutor  ณJean Cavalcante     บ Data ณ  03/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบDesc.     ณ Este relatorio imprimi os valores faturados por represen-  บฑฑ
ฑฑบ          ณ tante de venda mes a mes.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico NYTRON  -   www.actualtrend.com.br              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFAT011()

Local cDesc1  	  := "Este relatorio ira imprimir os valores faturados"          
Local cDesc2  	  := "por segmento de venda m๊s a m๊s"                      
Local cDesc3  	  := ""
Local aMeses	:= {"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}	//"JAN"###"FEV"###"MAR"###"ABR"###"MAI"###"JUN"###"JUL"###"AGO"###"SET"###"OUT"###"NOV"###"DEZ"
Local nMesAux	:= 0
Local nAno		:= 0
Local nMes		:= 0 
Local nX		:= 0
Private cMes
Private cString  := "SH6"
Private Tamanho  := "G"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RFAT011"
Private NomeProg := "RFAT011"
Private nLastKey := 0
Private Limite   := 220
Private cPerg    := "RFATR011b"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {} 
Private cabec1   :="REPRESENTANTE       CODIG/LOJA NOME                 UF PRACA              " //JANEIRO  FEVEREIRO     MARCO       ABRIL       MAIO      JUNHO      JULHO     AGOSTO   SETEMBRO    OUTUBRO   NOVEMBRO   DEZEMBRO   TOTAL (ANO)"
Private Cabec2   :="DE VENDA            CLIENTE    REDUZIDO                CIDADE" 		 	 		 
Private nTotDias := 0
Private nNumInd  := 0
Private nMedia   := 0
Private nNecReal := 0
Private nNecPla  := 0 
Private nVlrNec  := 0
Private nSldNec  := 0
Private cDescOP  := " " 
Private cDescMot := " "
Private a_cmps   := {}
Private a_dados  := {}

//aAdd(aOrd, "Recurso")
//aAdd(aOrd, "C.Custo/OP")

#IFNDEF TOP
   MsgInfo("Nใo ้ possํvel executar este programa, estแ base de dados nใo ้ TopConnect")
   RETURN
#ENDIF

ValidPerg()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01              Data Vendas De    	                 ณ
//ณ mv_par02              Data Vendas At้       	             ณ
//ณ mv_par03              Cliente De ?                           ณ
//ณ mv_par04              Cliente Ate ?                          ณ
//ณ mv_par05              Representante	De ?      			     ณ
//ณ mv_par06              Representante Ate ?				     ณ
//ณ mv_par07              Estado De ?           	             ณ
//ณ mv_par08              Estado Ate ?	                         ณ
//ณ mv_par09              Apurar Valor ?	                     ณ
//ณ mv_par10              TES Movimenta Estoque ?                ณ [Mauro Nagata, Actual Trend, 26/10/2010]
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//+-------------------------------------------------------------------------------+
//| Solicita ao usuario a parametrizacao do relatorio.                            |
//+-------------------------------------------------------------------------------+
Pergunte(cPerg,.F.)

Private Titulo   := "Rela็ใo de Faturamento por representante no periodo de " +Dtoc(MV_PAR01)+ " a "+Dtoc(MV_PAR02)+" - Filial: " +cFilant+ ""
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,.F.,.F.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

nTipo := Iif(aReturn[4] == 1, 15, 18)

If nLastKey == 27
   Return
Endif

nAno := Year(MV_PAR01)
nMes := Month(MV_PAR01) //+1
If nMes = 13 
	nMes := 1
EndIf

cMes := StrZero(nMes,2)

For nX := 1 To 12
	If aMeses[nMes] == "JAN" .And. nX != 1	//"JAN"
		nAno++
	EndIf
	cabec1 += aMeses[nMes]+"/"+StrZero(nAno,4)+Space(03)
	nMes++
	If nMes > 12
		nMes := 1
	EndIf
Next nX

cabec1 += "TOTAL (ANO)"


//+-------------------------------------------------------------------------------
//| Chama funcao que processa os dados
//+-------------------------------------------------------------------------------
//RptStatus({|lEnd| RelPROCImp(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )  //linha substituida [Mauro Nagata, Actual Trend, 27/10/2010
RptStatus({|lEnd| RelPROCImp(@lEnd, wnrel, cString) }, "Faturamento por Representante M๊s a M๊s" )

Return

//+-------------------------------------------------------------------------------
//| funcao que processa os dados
//+-------------------------------------------------------------------------------
Static Function RelPROCImp(lEnd,wnrel,cString)
Local cFilSD4   	:= xFilial(cString)
Local cQuery    	:= ""
Local aCol      	:= {}
Local aSubTotal	 := {}
Local nTotalJan  := 0
Local nTotalFev  := 0
Local nTotalMar  := 0
Local nTotalAbr  := 0
Local nTotalMai  := 0
Local nTotalJun  := 0
Local nTotalJul  := 0
Local nTotalAgo  := 0
Local nTotalSet  := 0
Local nTotalOut  := 0
Local nTotalNov  := 0
Local nTotalDez  := 0   
Local nTotalMes  := 0  
Local nTotalGer  := 0   
Local nTotalS	 := 0      

Local nTotlJani  := 0
Local nTotlFevi  := 0
Local nTotlMari  := 0
Local nTotlAbri  := 0
Local nTotlMaii  := 0
Local nTotlJuni  := 0
Local nTotlJuli  := 0
Local nTotlAgoi  := 0
Local nTotlSeti  := 0
Local nTotlOuti  := 0
Local nTotlNovi  := 0
Local nTotlDezi  := 0   
Local nTotlMesI  := 0  
Local nTotlGerI  := 0   
Local nTotalC	 := 0      
Local cCodGrupo  := ""
Local cCodResp	 := ""
Local cQuebra,cCampo,cMens
Local cIndex
Local nqtdtotal		:= 0
Local aMesesb	:= {"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}	//"JAN"###"FEV"###"MAR"###"ABR"###"MAI"###"JUN"###"JUL"###"AGO"###"SET"###"OUT"###"NOV"###"DEZ"
Local nMesAuxb	:= 0
Local nAnob		:= 0
Local nMesb		:= 0 
Local nXb		:= 0
Private cMesb


Private _aSaldoIni:={}                                                                                                                                                                                                                                           
//Private Titulo   	:= "Relat๓rio de Faturamento por Representante no periodo de " +Dtoc(MV_PAR01)+ " a "+Dtoc(MV_PAR02)+" - Filial: " +cFilant+ " "  //linha substituida [Mauro Nagata, Actual Trend, 27/10/2010]
Private Titulo   	:= "Relat๓rio de Faturamento por Representante de " +Dtoc(MV_PAR01)+ " a "+Dtoc(MV_PAR02)+" - Filial: " +cFilant+ " ("+If(MV_PAR09==1," S/Imp. "," C/Imp. ")+"-"+If(MV_PAR10==1," C/M.E. ",If(MV_PAR10==2," S/M.E. "," C/ e S/M.E. "))+")"
//  +------------------------+
//  | Cria filtro temporario |
//  +------------------------+

//cQuery:= "SELECT  SA1.A1_VEND, SD2.D2_CLIENTE,SD2.D2_LOJA, SA1.A1_NREDUZ, SA1.A1_MUN, SA1.A1_EST, SubString(SD2.D2_EMISSAO,1,4) as ANO " //linha substituida [Mauro Nagata, Actual Trend, 27/10/2010]
cQuery:= "SELECT  SA1.A1_VEND, SD2.D2_CLIENTE,SD2.D2_LOJA, SA1.A1_NREDUZ, SA1.A1_MUN, SA1.A1_EST "
//incluida a linha abaixo [Mauro Nagata, Actual Trend, 18/01/2012]
cQuery+= "         , SB1.B1_GRUPO, SBM.BM_DESC "
cQuery+= "         , [JAN]	    = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=01 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [FEV]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=02 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [MAR]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=03 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [ABR]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=04 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [MAI]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=05 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [JUN]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=06 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [JUL]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=07 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [AGO]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=08 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [SET]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=09 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [OUT]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=10 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [NOV]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=11 then SD2.D2_TOTAL end),0) " 
cQuery+= "         , [DEZ]      = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=12 then SD2.D2_TOTAL end),0) "
cQuery+= "         , [JAN_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=01 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) " 
cQuery+= "         , [FEV_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=02 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [MAR_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=03 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [ABR_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=04 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [MAI_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=05 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [JUN_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=06 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [JUL_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=07 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [AGO_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=08 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [SET_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=09 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [OUT_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=10 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [NOV_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=11 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "         , [DEZ_IMP]  = Isnull(sum(case when SubString(SD2.D2_EMISSAO,5,2)=12 then (SD2.D2_TOTAL+SD2.D2_VALIPI+SD2.D2_ICMSRET)end),0) "
cQuery+= "FROM "+RetSqlName("SD2")+" AS SD2 " 
cQuery+= "     JOIN "+RetSqlName("SA1")+" AS SA1 " 
cQuery+= "          ON  SD2.D2_CLIENTE = SA1.A1_COD "
cQuery+= "              AND SD2.D2_LOJA	 = SA1.A1_LOJA "
cQuery+= "              AND SA1.D_E_L_E_T_ = '' "  //linha incluida [Mauro Nagata, Actual Trend, 26/10/2010]
cQuery+= "     JOIN "+RetSqlName("SF4")+" AS SF4 " 
cQuery+= "          ON SD2.D2_FILIAL = SF4.F4_FILIAL "
cQuery+= "             AND SD2.D2_TES = SF4.F4_CODIGO " 
cQuery+= "             AND SF4.F4_CODIGO <> '700' " 
cQuery+= "             AND SF4.F4_DUPLIC = 'S' " 
cQuery+= "             AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery+= "             AND SF4.D_E_L_E_T_ = '' "  //linha incluida [Mauro Nagata, Actual Trend, 26/10/2010]
//[inicio] Criado parametro para selecionar TES que movimenta estqoue 1-Sim/2-Nao/3-Ambos [Mauro Nagata, Actual Trend, 26/10/2010]
Do Case
   Case MV_PAR10 == 1
        cQuery+= "             AND SF4.F4_ESTOQUE = 'S' "
   Case MV_PAR10 == 2     
        cQuery+= "             AND SF4.F4_ESTOQUE = 'N' "
EndCase                   
//[fim] Criado parametro para selecionar TES que movimenta estqoue 1-Sim/2-Nao/3-Ambos [Mauro Nagata, Actual Trend, 26/10/2010]
cQuery+= "     JOIN "+RetSqlName("SB1")+" AS SB1 "
cQuery+= "          ON SD2.D2_COD = SB1.B1_COD "  
cQuery+= "          AND SD2.D2_FILIAL = SB1.B1_FILIAL " // ALTERADO POR FABIO ROGERIO EM 06/11, POIS OS CADASTROS DE PRODUTOS DAS FILIAIS SAO EXCLUSIVOS
cQuery+= "             AND SB1.D_E_L_E_T_ <> '*' " 
cQuery+= "     JOIN "+RetSqlName("SBM")+" AS SBM " 
cQuery+= "          ON SBM.BM_GRUPO = SB1.B1_GRUPO " 
cQuery+= "             AND SBM.D_E_L_E_T_ <> '*' " 
cQuery+= "WHERE SD2.D2_EMISSAO >= '"+DTOS(mv_par01)+"' "
cQuery+= "      AND SD2.D2_EMISSAO <= '"+DTOS(mv_par02)+"' " 
cQuery+= "      AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery+= "      AND SD2.D2_CLIENTE >= '"+mv_par03+"' "
cQuery+= "      AND SD2.D2_CLIENTE <= '"+mv_par04+"' " 
cQuery+= "      AND SA1.A1_VEND >= '"+mv_par05+"' "
cQuery+= "      AND SA1.A1_VEND <= '"+mv_par06+"' " 
cQuery+= "      AND SA1.A1_EST >= '"+mv_par07+"' "
cQuery+= "      AND SA1.A1_EST <= '"+mv_par08+"' " 
cQuery+= "      AND (SD2.D2_TIPO = 'N' OR SD2.D2_TIPO = 'C') "
//cQuery+= "      AND SA1.D_E_L_E_T_ <> '*' "   //linha excluida [Mauro Nagata, Actual Trend, 26/10/2010]
cQuery+= "      AND SD2.D_E_L_E_T_ <> '*' "
//cQuery+= "      AND SF4.D_E_L_E_T_ <> '*' "   //linha excluida [Mauro Nagata, Actual Trend, 26/10/2010]
//cQuery+= "GROUP BY SA1.A1_VEND, SD2.D2_CLIENTE,SD2.D2_LOJA, SA1.A1_NREDUZ, SA1.A1_MUN, SA1.A1_EST, SubString(SD2.D2_EMISSAO,1,4) " //linha substituida[Mauro Nagata, Actual Trend, 27/10/2010]

//cQuery+= "GROUP BY SA1.A1_VEND, SD2.D2_CLIENTE,SD2.D2_LOJA, SA1.A1_NREDUZ, SA1.A1_MUN, SA1.A1_EST " 
//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 18/01/2012]
cQuery+= "GROUP BY SA1.A1_VEND, SD2.D2_CLIENTE,SD2.D2_LOJA, SA1.A1_NREDUZ, SA1.A1_MUN, SA1.A1_EST,SB1.B1_GRUPO "
//incluida linha abaixo [Mauro Nagata, Actual Trend, 18/01/2012]
cQuery+= ", SBM.BM_DESC " 
cQuery+= "ORDER BY SD2.D2_CLIENTE, SD2.D2_LOJA "
 
//incluida linha abaixo [Mauro Nagata, Actual Trend, 18/01/2012]
MemoWrite("RFAT011.SQL",cQuery)
      
//+-----------------------
//| Cria indice temporario
//+-----------------------

// Com isso vc pode escolher a opcao do order by

//If	aReturn[8] == 1        // Centro de Custo / Produto
//   	cQuery 	+= "H6_RECURSO, H6_PRODUTO"
//	cCampo	:= "H6_FILIAL+H6_RECURSO"

//Elseif aReturn[8] == 2        // Centro de Custo / OP
//   	cQuery 	+= "H1_CCUSTO, H6_OP"
//		cCampo	:= "H6_FILIAL+H6_OP"

//Endif

//+------------------------+
//| Cria uma view no banco |
//+------------------------+

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
dbSelectArea("TRB")
dbGoTop()
SetRegua( RecCount() )


//"REPRESENTANTE       CODIG/LOJA NOME                 UF PRACA              JANEIRO  FEVEREIRO     MARCO       ABRIL       MAIO      JUNHO      JULHO     AGOSTO   SETEMBRO    OUTUBRO   NOVEMBRO   DEZEMBRO   TOTAL (ANO)"   


//"REPRESENTANTE       CODIG/LOJA NOME                 UF PRACA             JAN-XXXX   FEV-XXXX   MAR-XXXX   ABR-XXXX   MAI-XXXX   JUN-XXXX   JUL-XXXX   AGO-XXXX   SET-XXXX   OUT-XXXX   NOV-XXXX   DEZ-XXXX   TOTAL (ANO)"   
//"DE VENDA            CLIENTE    REDUZIDO                CIDADE 		 	 		 
// XXXXXXXXXXXXXXXXXXX XXXXXX/XX  XXXXXXXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXX 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99  9,999,999.99
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//           1         2         3         4         5         6         7         8         9        10        11         12        13        14        15        16        17        18        19        20        21        22
                  
//+---------------------+
//| Coluna de impressao |  
//+---------------------+
aAdd( aCol, 001 ) // Representante 19
aAdd( aCol, 020 ) // Codigo/Loja   09
aAdd( aCol, 031 ) // Nome Reduzido 20
aAdd( aCol, 052 ) // Estado        02
aAdd( aCol, 055 ) // Cidade        15
aAdd( aCol, 071 ) // Janeiro   082
aAdd( aCol, 082 ) // Fevereiro 093
aAdd( aCol, 093 ) // Marco     63
aAdd( aCol, 104 ) // Abril     79
aAdd( aCol, 115 ) // Maio      95
aAdd( aCol, 126 ) // Junho    113
aAdd( aCol, 137 ) // Julho    127
aAdd( aCol, 148 ) // Agosto   141
aAdd( aCol, 159 ) // Setembro  159
aAdd( aCol, 170 ) // Outubro  175
aAdd( aCol, 181 ) // Novembro 191
aAdd( aCol, 192 ) // Dezembro 207
aAdd( aCol, 204 ) // Total Anual

//[inicio] definindo a ordem que sera disponibilizada os meses na planilha conforme definido na variavel MV_PAR01 [Mauro Nagata, Actual Trend, 27/10/2010]     
cMesExtSI := "JANFEVMARABRMAIJUNJULAGOSETOUTNOVDEZ"  //mes por extenso sem imoostos
cMesExtCI := "JAN_IMPFEV_IMPMAR_IMPABR_IMPMAI_IMPJUN_IMPJUL_IMPAGO_IMPSET_IMPOUT_IMPNOV_IMPDEZ_IMP"  //mes por extenso com impostos

aAdd(a_cmps,{"RESPONSA"		,"C",40,0})    
aAdd(a_cmps,{"GRP_CLIENT"	,"C",40,0})    
aAdd(a_cmps,{"REPRESENTA"	,"C",30,0})    
aAdd(a_cmps,{"CODIGO"	   	,"C",06,0})    
aAdd(a_cmps,{"LOJA"		    ,"C",02,0})
aAdd(a_cmps,{"RAZAO_SOC"	,"C",50,0})
aAdd(a_cmps,{"NOMEREDUZ"	,"C",30,0})
aAdd(a_cmps,{"ESTADO"	    ,"C",02,0})
aAdd(a_cmps,{"CIDADE"	    ,"C",35,0})  
//incluido o bloco abaixo [Mauro Nagata, Actual Trend, 18/01/2012]
aAdd(a_cmps,{"GRUPO"	    ,"C",04,0})
aAdd(a_cmps,{"DESCRGRP"	    ,"C",30,0})
//fim bloco [Mauro Nagata, Actual Trend, 18/01/2012]
                                       
/*
aAdd(a_cmps,{"JAN"			,"N",15,2})
aAdd(a_cmps,{"FEV"			,"N",15,2})
aAdd(a_cmps,{"MAR"	  		,"N",15,2})
aAdd(a_cmps,{"ABR"	  		,"N",15,2})
aAdd(a_cmps,{"MAI" 		 	,"N",15,2})
aAdd(a_cmps,{"JUN"			,"N",15,2})
aAdd(a_cmps,{"JUL"			,"N",15,2})
aAdd(a_cmps,{"AGO"			,"N",15,2})
aAdd(a_cmps,{"SET"			,"N",15,2})
aAdd(a_cmps,{"OUT"			,"N",15,2})
aAdd(a_cmps,{"NOV"			,"N",15,2})
aAdd(a_cmps,{"DEZ"			,"N",15,2})

aAdd(a_cmps,{"TOTAL_MERC"	,"N",15,2}) 

aAdd(a_cmps,{"JAN_IMPO"		,"N",15,2})
aAdd(a_cmps,{"FEV_IMPO"		,"N",15,2})
aAdd(a_cmps,{"MAR_IMPO"	  	,"N",15,2})
aAdd(a_cmps,{"ABR_IMPO"	  	,"N",15,2})
aAdd(a_cmps,{"MAI_IMPO" 	,"N",15,2})
aAdd(a_cmps,{"JUN_IMPO"		,"N",15,2})
aAdd(a_cmps,{"JUL_IMPO"		,"N",15,2})
aAdd(a_cmps,{"AGO_IMPO"		,"N",15,2})
aAdd(a_cmps,{"SET_IMPO"		,"N",15,2})
aAdd(a_cmps,{"OUT_IMPO"		,"N",15,2})
aAdd(a_cmps,{"NOV_IMPO"		,"N",15,2})
aAdd(a_cmps,{"DEZ_IMPO"		,"N",15,2})

aAdd(a_cmps,{"TOTAL_IMPO"	,"N",15,2})
*/

nMesIni   := Month(MV_PAR01)
For nI := 1 To 12
    nMesAux := nMesIni+nI-1
    If  nMesAux> 12
        nMesAux := (nMesIni+nI-1)-12
    EndIf   
    aAdd(a_cmps,{Substr(cMesExtSI,(((nMesAux-1)*3)+1),3),"N",15,2})
 Next        
 aAdd(a_cmps,{"TOTAL_MERC"	,"N",15,2}) 
      
For nI := 1 To 12
    nMesAux := nMesIni+nI-1
    If  nMesAux> 12
        nMesAux := (nMesIni+nI-1)-12
    EndIf   
    aAdd(a_cmps,{Substr(cMesExtCI,(((nMesAux-1)*7)+1),7),"N",15,2})
Next                             
aAdd(a_cmps,{"TOTAL_IMPO"	,"N",15,2})
//[fim] definindo a ordem que sera disponibilizada os meses na planilha conforme definido na variavel MV_PAR01 [Mauro Nagata, Actual Trend, 27/10/2010]     


Do While !Eof() .And. !lEnd  
   nqtdprod := 0 
   nqtdperd := 0	

   If Li > 63
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   Endif

   DbSelectArea("TRB")
   
  // cQuebra:=&(cCampo)
   
  // lEnd - aborta o relat๓rio atraves da tecla ESC
   Do While !Eof() .And. !lEnd  //&(cCampo) == cQuebra .And. !lEnd 
      nTotalmes := 0
      nTotalmeI := 0

      IncRegua(SA3->A3_NOME)
      
      If Li > 63
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      Endif

	  @ Li, aCol[01] PSAY SUBSTR(GetAdvFval("SA3", "A3_NOME", xFilial("SA3")+TRB->A1_VEND,1,"NAO/LOCALIZADO"),1,17)
      cCodResp := GetAdvFval("SA3", "A3_XRESP", xFilial("SA3")+TRB->A1_VEND,1,"NAO/LOCALIZADO")
	  @ Li, aCol[02] PSAY TRB->D2_CLIENTE +"/"+TRB->D2_LOJA
	  cCodGrupo := GetAdvFval("SA1", "A1_XGRPCLI", xFilial("SA1")+TRB->D2_CLIENTE+TRB->D2_LOJA,1,"NAO/LOCALIZADO") 	
	  @ Li, aCol[03] PSAY SUBSTR(TRB->A1_NREDUZ,1,20)
	  @ Li, aCol[04] PSAY TRB->A1_EST
	  @ Li, aCol[05] PSAY SUBSTR(TRB->A1_MUN,1,15)               

      /*	  
      @ Li, aCol[06] PSAY IIF(MV_PAR09 = 1,Transform(TRB->JAN,		"@E 999,999.99"), Transform(TRB->JAN_IMP,	"@E 999,999.99"))
      @ Li, aCol[07] PSAY IIF(MV_PAR09 = 1,Transform(TRB->FEV, 	"@E 999,999.99"), Transform(TRB->FEV_IMP,	"@E 999,999.99"))
      @ Li, aCol[08] PSAY IIF(MV_PAR09 = 1,Transform(TRB->MAR, 	"@E 999,999.99"), Transform(TRB->MAR_IMP, 	"@E 999,999.99"))
      @ Li, aCol[09] PSAY IIF(MV_PAR09 = 1,Transform(TRB->ABR, 	"@E 999,999.99"), Transform(TRB->ABR_IMP, 	"@E 999,999.99"))
      @ Li, aCol[10] PSAY IIF(MV_PAR09 = 1,Transform(TRB->MAI, 	"@E 999,999.99"), Transform(TRB->MAI_IMP, 	"@E 999,999.99"))
      @ Li, aCol[11] PSAY IIF(MV_PAR09 = 1,Transform(TRB->JUN, 	"@E 999,999.99"), Transform(TRB->JUN_IMP, 	"@E 999,999.99"))
      @ Li, aCol[12] PSAY IIF(MV_PAR09 = 1,Transform(TRB->JUL, 	"@E 999,999.99"), Transform(TRB->JUL_IMP, 	"@E 999,999.99"))
      @ Li, aCol[13] PSAY IIF(MV_PAR09 = 1,Transform(TRB->AGO, 	"@E 999,999.99"), Transform(TRB->AGO_IMP, 	"@E 999,999.99"))
      @ Li, aCol[14] PSAY IIF(MV_PAR09 = 1,Transform(TRB->SET, 	"@E 999,999.99"), Transform(TRB->SET_IMP, 	"@E 999,999.99"))
      @ Li, aCol[15] PSAY IIF(MV_PAR09 = 1,Transform(TRB->OUT,	"@E 999,999.99"), Transform(TRB->OUT_IMP,	"@E 999,999.99"))
      @ Li, aCol[16] PSAY IIF(MV_PAR09 = 1,Transform(TRB->NOV, 	"@E 999,999.99"), Transform(TRB->NOV_IMP,	"@E 999,999.99"))
      @ Li, aCol[17] PSAY IIF(MV_PAR09 = 1,Transform(TRB->DEZ, 	"@E 999,999.99"), Transform(TRB->DEZ_IMP, 	"@E 999,999.99"))
      */      

      //[inicio] definindo a ordem que sera disponibilizada os meses na planilha conforme definido na variavel MV_PAR01 [Mauro Nagata, Actual Trend, 26/10/2010]     
      aMesSI    := {}
      aMesCI    := {}
      nMesIni   := Month(MV_PAR01)
      For nI := 1 To 12
          nMesAux := nMesIni+nI-1
          If  nMesAux> 12
             nMesAux := (nMesIni+nI-1)-12
          EndIf   
          Aadd(aMesSI,Substr(cMesExtSI,(((nMesAux-1)*3)+1),3))
          Aadd(aMesCI,Substr(cMesExtCI,(((nMesAux-1)*7)+1),7))                
      Next                      
        
      //incluido o bloco abaixo [Mauro Nagata, Actual Trend, 18/01/2012]
      nVlrJan     := nVlrFev  := nVlrMar  := nVlrAbr  := nVlrMai  := nVlrJun  := 0
      nVlrJul     := nVlrAgo  := nVlrSet  := nVlrOut  := nVlrNov  := nVlrDez  := 0
      nVlrJan_imp := nVlrFev_imp := nVlrMar_imp := nVlrAbr_imp := nVlrMai_imp := nVlrJun_imp := 0
      nVlrJul_imp := nVlrAgo_imp := nVlrSet_imp := nVlrOut_imp := nVlrNov_imp := nVlrDez_imp := 0
      cCliLoja := TRB->(D2_CLIENTE+D2_LOJA)         
      Do While !Eof().And. TRB->(D2_CLIENTE+D2_LOJA) = cCliLoja
	      nTotalJan += TRB->JAN  
	      nTotalFev += TRB->FEV  
	      nTotalMar += TRB->MAR   
	      nTotalAbr += TRB->ABR   
	      nTotalMai += TRB->MAI    
	      nTotalJun += TRB->JUN                
	      nTotalJul += TRB->JUL   
	      nTotalAgo += TRB->AGO   
	      nTotalSet += TRB->SET 
	      nTotalOut += TRB->OUT 
	      nTotalNov += TRB->NOV
	      nTotalDez += TRB->DEZ 
	      
	      nTotlJani += TRB->JAN_IMP  
	      nTotlFevi += TRB->FEV_IMP  
	      nTotlMari += TRB->MAR_IMP   
	      nTotlAbri += TRB->ABR_IMP   
	      nTotlMaii += TRB->MAI_IMP    
	      nTotlJuni += TRB->JUN_IMP    
	      nTotlJuli += TRB->JUL_IMP   
	      nTotlAgoi += TRB->AGO_IMP   
	      nTotlSeti += TRB->SET_IMP 
	      nTotlOuti += TRB->OUT_IMP 
	      nTotlNovi += TRB->NOV_IMP
	      nTotlDezi += TRB->DEZ_IMP
	      
	      //totalizacao das vendas por mes considerando cliente e grupo de produto (valor mercadoria)
	      nVlrJan += TRB->JAN  
	      nVlrFev += TRB->FEV  
	      nVlrMar += TRB->MAR   
	      nVlrAbr += TRB->ABR   
	      nVlrMai += TRB->MAI    
	      nVlrJun += TRB->JUN                
	      nVlrJul += TRB->JUL   
	      nVlrAgo += TRB->AGO   
	      nVlrSet += TRB->SET 
	      nVlrOut += TRB->OUT 
	      nVlrNov += TRB->NOV
	      nVlrDez += TRB->DEZ 

	      //totalizacao das vendas por mes considerando cliente e grupo de produto (valor mercadoria com impostos)	      
	      nVlrJan_Imp += TRB->JAN_IMP  
	      nVlrFev_Imp += TRB->FEV_IMP  
	      nVlrMar_Imp += TRB->MAR_IMP   
	      nVlrAbr_Imp += TRB->ABR_IMP   
	      nVlrMai_Imp += TRB->MAI_IMP    
	      nVlrJun_Imp += TRB->JUN_IMP    
	      nVlrJul_Imp += TRB->JUL_IMP   
	      nVlrAgo_Imp += TRB->AGO_IMP   
	      nVlrSet_Imp += TRB->SET_IMP 
	      nVlrOut_Imp += TRB->OUT_IMP 
	      nVlrNov_Imp += TRB->NOV_IMP
	      nVlrDez_Imp += TRB->DEZ_IMP 
                                                                                                                                           
          //total do mes sem impostos IPI / ICMS ST
          nTotalMes := (TRB->JAN+TRB->FEV+TRB->MAR+TRB->ABR+TRB->MAI+TRB->JUN+TRB->JUL+TRB->AGO+TRB->SET+TRB->OUT+TRB->NOV+TRB->DEZ)  
          nTotalGer += nTotalMes 
                                                   
          //total do mes com impostos IPI / ICMS ST
	      nTotlMesI := (TRB->JAN_IMP+TRB->FEV_IMP+TRB->MAR_IMP+TRB->ABR_IMP+TRB->MAI_IMP+TRB->JUN_IMP+TRB->JUL_IMP+TRB->AGO_IMP+TRB->SET_IMP+TRB->OUT_IMP+TRB->NOV_IMP+TRB->DEZ_IMP) //total do mes com impostos IPI / ICMS ST
          nTotlGerI += nTotlMesI                                              
                             
          //carregando matriz linha a linha para exportar para excel
   	      Aadd(a_dados, {GetAdvFval("SX5", "X5_DESCRI", xFilial("SX5")+"ZZ"+cCodResp,1,"NAO/LOCALIZADO"),;
   	                     GetAdvFval("ACY", "ACY_DESCRI", xFilial("ACY")+cCodGrupo,1,"NAO/LOCALIZADO"),;
   	                     GetAdvFval("SA3", "A3_NOME", xFilial("SA3")+TRB->A1_VEND,1,"NAO/LOCALIZADO"),;
   	  		             TRB->D2_CLIENTE,TRB->D2_LOJA, GetAdvFval("SA1", "A1_NOME", xFilial("SA1")+TRB->D2_CLIENTE+TRB->D2_LOJA,1,"NAO/LOCALIZADO"),;
   	  		             TRB->A1_NREDUZ, TRB->A1_EST,TRB->A1_MUN, TRB->B1_GRUPO, TRB->BM_DESC,;
			     		 TRB->&(aMesSI[01]), TRB->&(aMesSI[02]), TRB->&(aMesSI[03]), TRB->&(aMesSI[04]), TRB->&(aMesSI[05]), TRB->&(aMesSI[06]), ;
						 TRB->&(aMesSI[07]), TRB->&(aMesSI[08]), TRB->&(aMesSI[09]), TRB->&(aMesSI[10]), TRB->&(aMesSI[11]), TRB->&(aMesSI[12]), nTotalMes,;
			             TRB->&(aMesCI[01]), TRB->&(aMesCI[02]), TRB->&(aMesCI[03]), TRB->&(aMesCI[04]), TRB->&(aMesCI[05]), TRB->&(aMesCI[06]), ;
						 TRB->&(aMesCI[07]), TRB->&(aMesCI[08]), TRB->&(aMesCI[09]), TRB->&(aMesCI[10]), TRB->&(aMesCI[11]), TRB->&(aMesCI[12]), nTotlMesI})     
          TRB->(DbSkip())
	  EndDo    
	  nTMeses  := nVlrJan + nVlrFev + nVlrMar + nVlrAbr + nVlrMai + nVlrJun + nVlrJul + nVlrAgo + nVlrSet + nVlrOut + nVlrNov + nVlrDez
      nTMesesI := nVlrJan_imp + nVlrFev_imp + nVlrMar_imp + nVlrAbr_imp + nVlrMai_imp + nVlrJun_imp + nVlrJul_imp + nVlrAgo_imp + nVlrSet_imp + nVlrOut_imp + nVlrNov_imp + nVlrDez_imp 
	  
	  @ Li, aCol[06] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[01]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[01]),	"@E 999,999.99"))
      @ Li, aCol[07] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[02]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[02]),	"@E 999,999.99"))
      @ Li, aCol[08] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[03]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[03]), "@E 999,999.99"))
      @ Li, aCol[09] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[04]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[04]),	"@E 999,999.99"))
      @ Li, aCol[10] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[05]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[05]),	"@E 999,999.99"))
      @ Li, aCol[11] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[06]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[06]),	"@E 999,999.99"))
      @ Li, aCol[12] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[07]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[07]),	"@E 999,999.99"))
      @ Li, aCol[13] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[08]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[08]),	"@E 999,999.99"))
      @ Li, aCol[14] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[09]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[09]),	"@E 999,999.99"))
      @ Li, aCol[15] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[10]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[10]),	"@E 999,999.99"))
      @ Li, aCol[16] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[11]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[11]),	"@E 999,999.99"))
      @ Li, aCol[17] PSAY IIF(MV_PAR09 = 1,Transform(&("nVlr"+aMesSI[12]), "@E 999,999.99"), Transform(&("nVlr"+aMesCI[12]),	"@E 999,999.99"))
                                       
      @ Li, aCol[18] PSAY If(MV_PAR09==1,Transform(nTMeses, "@E 9,999,999.99"),Transform(nTMesesI, "@E 9,999,999.99"))	
      Li++  
	  //fim bloco [Mauro Nagata, Actual Trend, 18/01/2012] 
      
      //excluido bloco abaixo [Mauro Nagata, Actual Trend, 18/01/2012]
      /*
      @ Li, aCol[06] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[01]),	"@E 999,999.99"), Transform(TRB->&(aMesCI[01]),	"@E 999,999.99"))
      @ Li, aCol[07] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[02]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[02]),	"@E 999,999.99"))
      @ Li, aCol[08] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[03]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[03]), 	"@E 999,999.99"))
      @ Li, aCol[09] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[04]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[04]), 	"@E 999,999.99"))
      @ Li, aCol[10] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[05]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[05]), 	"@E 999,999.99"))
      @ Li, aCol[11] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[06]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[06]), 	"@E 999,999.99"))
      @ Li, aCol[12] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[07]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[07]), 	"@E 999,999.99"))
      @ Li, aCol[13] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[08]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[08]), 	"@E 999,999.99"))
      @ Li, aCol[14] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[09]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[09]), 	"@E 999,999.99"))
      @ Li, aCol[15] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[10]),	"@E 999,999.99"), Transform(TRB->&(aMesCI[10]),	"@E 999,999.99"))
      @ Li, aCol[16] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[11]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[11]),	"@E 999,999.99"))
      @ Li, aCol[17] PSAY IIF(MV_PAR09 = 1,Transform(TRB->&(aMesSI[12]), 	"@E 999,999.99"), Transform(TRB->&(aMesCI[12]), 	"@E 999,999.99"))
      //[fim] definindo a ordem que sera disponibilizada os meses na planilha conforme definido na variavel MV_PAR01 [Mauro Nagata, Actual Trend, 26/10/2010]     

      nTotalJan += TRB->JAN  
      nTotalFev += TRB->FEV  
      nTotalMar += TRB->MAR   
      nTotalAbr += TRB->ABR   
      nTotalMai += TRB->MAI    
      nTotalJun += TRB->JUN    
      nTotalJul += TRB->JUL   
      nTotalAgo += TRB->AGO   
      nTotalSet += TRB->SET 
      nTotalOut += TRB->OUT 
      nTotalNov += TRB->NOV
      nTotalDez += TRB->DEZ 
      
      nTotlJani += TRB->JAN_IMP  
      nTotlFevi += TRB->FEV_IMP  
      nTotlMari += TRB->MAR_IMP   
      nTotlAbri += TRB->ABR_IMP   
      nTotlMaii += TRB->MAI_IMP    
      nTotlJuni += TRB->JUN_IMP    
      nTotlJuli += TRB->JUL_IMP   
      nTotlAgoi += TRB->AGO_IMP   
      nTotlSeti += TRB->SET_IMP 
      nTotlOuti += TRB->OUT_IMP 
      nTotlNovi += TRB->NOV_IMP
      nTotlDezi += TRB->DEZ_IMP 
      */
      //fim do bloco excluido [Mauro Nagata, Actual Trend, 18/01/2012]

      /* 
	  nTotalmes := (TRB->JAN+TRB->FEV+TRB->MAR+TRB->ABR+TRB->MAI+TRB->JUN+TRB->JUL+TRB->AGO+TRB->SET+TRB->OUT+TRB->NOV+TRB->DEZ)
	  nTotalmesI := (TRB->JAN_IMP+TRB->FEV_IMP+TRB->MAR_IMP+TRB->ABR_IMP+TRB->MAI_IMP+TRB->JUN_IMP+TRB->JUL_IMP+TRB->AGO_IMP+TRB->SET_IMP+TRB->OUT_IMP+TRB->NOV_IMP+TRB->DEZ_IMP)	  
      nTotalGer += nTotalmes 
      
	  @ Li, aCol[18] PSAY Transform(nTotalmes, "@E 9,999,999.99")     
      Li++
   	  Aadd(a_dados, {GetAdvFval("SX5", "X5_DESCRI", xFilial("SX5")+"ZZ"+cCodResp,1,"NAO/LOCALIZADO"), GetAdvFval("ACY", "ACY_DESCRI", xFilial("ACY")+cCodGrupo,1,"NAO/LOCALIZADO"),GetAdvFval("SA3", "A3_NOME", xFilial("SA3")+TRB->A1_VEND,1,"NAO/LOCALIZADO"),;
   	  				TRB->D2_CLIENTE,TRB->D2_LOJA, GetAdvFval("SA1", "A1_NOME", xFilial("SA1")+TRB->D2_CLIENTE+TRB->D2_LOJA,1,"NAO/LOCALIZADO"),TRB->A1_NREDUZ, TRB->A1_EST,; 
					TRB->A1_MUN, TRB->JAN, TRB->FEV, TRB->MAR, TRB->ABR, TRB->MAI, TRB->JUN, TRB->JUL, TRB->AGO, TRB->SETE, TRB->OUT, TRB->NOV,TRB->DEZ,nTotalmes,;
               	    TRB->JAN_IMP, TRB->FEV_IMP, TRB->MAR_IMP, TRB->ABR_IMP, TRB->MAI_IMP, TRB->JUN_IMP, TRB->JUL_IMP, TRB->AGO_IMP,;
                	TRB->SET_IMP, TRB->OUT_IMP, TRB->NOV_IMP,TRB->DEZ_IMP,nTotalmesI})     
      */        
      
      //[inicio] definindo a ordem que sera disponibilizada os meses na planilha conforme definido na variavel MV_PAR01 [Mauro Nagata, Actual Trend, 26/10/2010]          
      /*          
      //excluido bloco abaixo [Mauro Nagata, Actual Trend, 18/01/2012]      
	  nTotalMes := (TRB->JAN+TRB->FEV+TRB->MAR+TRB->ABR+TRB->MAI+TRB->JUN+TRB->JUL+TRB->AGO+TRB->SET+TRB->OUT+TRB->NOV+TRB->DEZ)  //total do mes sem impostos IPI / ICMS ST
      nTotalGer += nTotalMes 

	  nTotlMesI := (TRB->JAN_IMP+TRB->FEV_IMP+TRB->MAR_IMP+TRB->ABR_IMP+TRB->MAI_IMP+TRB->JUN_IMP+TRB->JUL_IMP+TRB->AGO_IMP+TRB->SET_IMP+TRB->OUT_IMP+TRB->NOV_IMP+TRB->DEZ_IMP) //total do mes com impostos IPI / ICMS ST
      nTotlGerI += nTotlMesI                                                                                                                                                        
      	  //fim bloco [Mauro Nagata, Actual Trend, 18/01/2012]      			
      
      @ Li, aCol[18] PSAY If(MV_PAR09==1,Transform(nTotalMes, "@E 9,999,999.99"),Transform(nTotlMesI, "@E 9,999,999.99"))
      Li++                                                                                                            
              
   	  Aadd(a_dados, {GetAdvFval("SX5", "X5_DESCRI", xFilial("SX5")+"ZZ"+cCodResp,1,"NAO/LOCALIZADO"), GetAdvFval("ACY", "ACY_DESCRI", xFilial("ACY")+cCodGrupo,1,"NAO/LOCALIZADO"),GetAdvFval("SA3", "A3_NOME", xFilial("SA3")+TRB->A1_VEND,1,"NAO/LOCALIZADO"),;
   	  				TRB->D2_CLIENTE,TRB->D2_LOJA, GetAdvFval("SA1", "A1_NOME", xFilial("SA1")+TRB->D2_CLIENTE+TRB->D2_LOJA,1,"NAO/LOCALIZADO"),TRB->A1_NREDUZ, TRB->A1_EST,TRB->A1_MUN,; 
     				TRB->&(aMesSI[01]), TRB->&(aMesSI[02]), TRB->&(aMesSI[03]), TRB->&(aMesSI[04]), TRB->&(aMesSI[05]), TRB->&(aMesSI[06]), ;
					TRB->&(aMesSI[07]), TRB->&(aMesSI[08]), TRB->&(aMesSI[09]), TRB->&(aMesSI[10]), TRB->&(aMesSI[11]), TRB->&(aMesSI[12]), nTotalMes,;
               	    TRB->&(aMesCI[01]), TRB->&(aMesCI[02]), TRB->&(aMesCI[03]), TRB->&(aMesCI[04]), TRB->&(aMesCI[05]), TRB->&(aMesCI[06]), ;
					TRB->&(aMesCI[07]), TRB->&(aMesCI[08]), TRB->&(aMesCI[09]), TRB->&(aMesCI[10]), TRB->&(aMesCI[11]), TRB->&(aMesCI[12]), nTotlMesI})     
	  //fim bloco [Mauro Nagata, Actual Trend, 18/01/2012]      			
	  */
      
      //[fim] definindo a ordem que sera disponibilizada os meses na planilha conforme definido na variavel MV_PAR01 [Mauro Nagata, Actual Trend, 26/10/2010]     
      					
//	  DbSelectArea("TRB")
//      DbSkip()	  
   EndDo

   Li++
   @ Li, 000 PSay Replicate("-",Limite)
   Li++

 /*
   @ Li, aCol[01] PSAY "Total Janeiro..: " + IIF(MV_PAR09 = 1, Transform(nTotalJan, "@E 9,999,999.99"), Transform(nTotlJanI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Fevereiro: " + IIF(MV_PAR09 = 1, Transform(nTotalFev, "@E 9,999,999.99"), Transform(nTotlFevI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Marco....: " + IIF(MV_PAR09 = 1, Transform(nTotalMar, "@E 9,999,999.99"), Transform(nTotlMarI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Abril....: " + IIF(MV_PAR09 = 1, Transform(nTotalAbr, "@E 9,999,999.99"), Transform(nTotlAbrI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Maio.....: " + IIF(MV_PAR09 = 1, Transform(nTotalMai, "@E 9,999,999.99"), Transform(nTotlMaiI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Junho....: " + IIF(MV_PAR09 = 1, Transform(nTotalJun, "@E 9,999,999.99"), Transform(nTotlJunI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Julho....: " + IIF(MV_PAR09 = 1, Transform(nTotalJul, "@E 9,999,999.99"), Transform(nTotlJulI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Agosto...: " + IIF(MV_PAR09 = 1, Transform(nTotalAgo, "@E 9,999,999.99"), Transform(nTotlAgoI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Setembro.: " + IIF(MV_PAR09 = 1, Transform(nTotalSet, "@E 9,999,999.99"), Transform(nTotlSetI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Outubro..: " + IIF(MV_PAR09 = 1, Transform(nTotalOut, "@E 9,999,999.99"), Transform(nTotlOutI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Novembro.: " + IIF(MV_PAR09 = 1, Transform(nTotalNov, "@E 9,999,999.99"), Transform(nTotlNovI, "@E 9,999,999.99"))
   Li++
   @ Li, aCol[01] PSAY "Total Dezembro.: " + IIF(MV_PAR09 = 1, Transform(nTotalDez, "@E 9,999,999.99"), Transform(nTotlDezI, "@E 9,999,999.99"))
*/
   //[inicio] ordenando os totais dos meses conforme parametro MV_PAR01 [Mauro Nagata, Actual Trend, 26/10/2010]    
   aTotal := {}
   Aadd(aTotal,"Total Janeiro..: " + IIF(MV_PAR09 = 1, Transform(nTotalJan, "@E 9,999,999.99"), Transform(nTotlJanI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Fevereiro: " + IIF(MV_PAR09 = 1, Transform(nTotalFev, "@E 9,999,999.99"), Transform(nTotlFevI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Marco....: " + IIF(MV_PAR09 = 1, Transform(nTotalMar, "@E 9,999,999.99"), Transform(nTotlMarI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Abril....: " + IIF(MV_PAR09 = 1, Transform(nTotalAbr, "@E 9,999,999.99"), Transform(nTotlAbrI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Maio.....: " + IIF(MV_PAR09 = 1, Transform(nTotalMai, "@E 9,999,999.99"), Transform(nTotlMaiI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Junho....: " + IIF(MV_PAR09 = 1, Transform(nTotalJun, "@E 9,999,999.99"), Transform(nTotlJunI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Julho....: " + IIF(MV_PAR09 = 1, Transform(nTotalJul, "@E 9,999,999.99"), Transform(nTotlJulI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Agosto...: " + IIF(MV_PAR09 = 1, Transform(nTotalAgo, "@E 9,999,999.99"), Transform(nTotlAgoI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Setembro.: " + IIF(MV_PAR09 = 1, Transform(nTotalSet, "@E 9,999,999.99"), Transform(nTotlSetI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Outubro..: " + IIF(MV_PAR09 = 1, Transform(nTotalOut, "@E 9,999,999.99"), Transform(nTotlOutI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Novembro.: " + IIF(MV_PAR09 = 1, Transform(nTotalNov, "@E 9,999,999.99"), Transform(nTotlNovI, "@E 9,999,999.99")))
   Aadd(aTotal,"Total Dezembro.: " + IIF(MV_PAR09 = 1, Transform(nTotalDez, "@E 9,999,999.99"), Transform(nTotlDezI, "@E 9,999,999.99")))

   If Li > 50
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   Endif
   nMesIni := Month(mv_par01)
   For nI := 1 To 12
       nMesAtual := nMesInI + nI - 1
       If nMesAtual > 12
          nMesAtual := nMesAtual - 12
       EndIf   
       @ Li,aCol[1] PSay aTotal[nMesAtual]
       Li++
   Next
   //[Fim] ordenando os totais dos meses conforme parametro MV_PAR01 [Mauro Nagata, Actual Trend, 26/10/2010]    

   Li++
   @ Li, 000 PSay Replicate("-",Limite)
   Li++

EndDo

If lEnd
   @ Li, aCol[1] PSay cCancel
   Return
Endif
   
If Li <> 80
   Roda(cbCont,cbTxt,Tamanho)
Endif

dbSelectArea("TRB")
dbCloseArea()

If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   Ourspool(wnrel)
EndIf

Ms_Flush()

If msgYesNo("Deseja exportar para o excel?")
	FGEN002(a_cmps, a_dados)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  25/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01              Data Vendas De    	                 ณ
//ณ mv_par02              Data Vendas At้       	             ณ
//ณ mv_par03              Cliente De ?                           ณ
//ณ mv_par04              Cliente Ate ?                          ณ
//ณ mv_par05              Representante	De ?      			     ณ
//ณ mv_par06              Representante Ate ?				     ณ
//ณ mv_par07              Estado De ?           	             ณ
//ณ mv_par08              Estado Ate ?	                         ณ
//ณ mv_par09              Apurar Valor ?	                     ณ
//ณ mv_par10              Movimenta Estoque ?                    ณ //incluido parametro [Mauro Nagata, Actual Trend, 26/10/2010]
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Data Vendas de      ? ","","","MV_CH1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Data Vendas Ate     ? ","","","MV_CH2","D",08,0,0,"G","U_Per12M(MV_PAR01,MV_PAR02)","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Cliente de          ? ","","","MV_CH3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	aAdd(aRegs,{cPerg,"04","Cliente Ate         ? ","","","MV_CH4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	aAdd(aRegs,{cPerg,"05","Representante De    ? ","","","MV_CH5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	aAdd(aRegs,{cPerg,"06","Representante Ate   ? ","","","MV_CH6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	aAdd(aRegs,{cPerg,"07","Estado De           ? ","","","MV_CH7","C",02,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","12"})
	aAdd(aRegs,{cPerg,"08","Estado Ate          ? ","","","MV_CH8","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","12"})
	aAdd(aRegs,{cPerg,"09","Apurar Valor        ? ","","","MV_CH9","N",01,0,1,"C","","MV_PAR09","Mercadoria","","","","","Impostos","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","TES Movimenta Estoq ? ","","","MV_CHA","N",01,0,1,"C","","MV_PAR10","Sim","","","","","Nao","","","","","Ambos","","","","","","","","","","","","","",""})  //incluido parametro [Mauro Nagata, Actual Trend, 26/10/2010]

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	DbSelectArea(_sAlias)
	
Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFGEN002   บAutor  ณAlexandre Martins   บ Data ณ  03/17/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao generica para exportacao de dados para o Excel.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico OmniLink.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FGEN002(a_Header, a_cols)

	Processa({||ExpExcel(a_Header, a_cols)}, "Exportando Dados")

Return

Static Function ExpExcel(a_Header, a_cols)

LOCAL cDirDocs   := MsDocPath() 
Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nX := 0

n_QtdReg := len(a_cols)
n_RegAtu := 0
ProcRegua(n_QtdReg)

For n_x := 1 to len(a_Header)
	Aadd(aStru, {a_Header[n_x,1]	, a_Header[n_x,2], a_Header[n_x, 3], a_Header[n_x, 4]})
Next


dbCreate(cDirDocs+"\"+cArquivo,aStru)
dbUseArea(.T.,,cDirDocs+"\"+cArquivo,cArquivo,.F.,.F.)

For nX := 1 to Len(a_cols)
	RecLock(cArquivo, .T.)
	IncProc("Concluindo ..."+AllTrim(Str((n_RegAtu/n_QtdReg)*100, 5))+" %")
	n_RegAtu++
	For n_y := 1 to len(a_Header)
		(cArquivo)->&(a_Header[n_y, 1])	:= a_cols[nX,n_y]
	Next
Next

dbSelectArea(cArquivo)
dbCloseArea()

CpyS2T( cDirDocs+"\"+cArquivo+".DBF" , cPath, .T. )

If ! ApOleClient( 'MsExcel' ) 
 MsgStop( 'MsExcel nao instalado' ) //
 Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return                                     
