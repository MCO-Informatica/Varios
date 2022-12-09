#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"   
#INCLUDE "Report.ch"  
#Include "FWMVCDEF.ch"

#DEFINE ENTER CHR(13)+CHR(10)     

//===========================================================================
// Programa.....: CFMDBTRANS
// Data.........: 04/05/21
// Autor........: Anderson Goncalves
// Descrição....: Relatorio de fretes TREPORT
// Uso..........: Verquimica
//===========================================================================

User Function CFMDBTRANS()

//=====================================================
// Variaveis da Rotina
//=====================================================
Local cPerg			:= "CFMDBTRANS"  
Local aRegs			:= {}
Local nOpcA			:= 0
Local aSays			:= {}
Local aButtons		:= {}
Private nTotReg		:= 0  
Private oImpressao	:= Nil
Private oTotalVend	:= Nil
Private oRelTrans	:= Nil 
Private oReport     := Nil  
Private cCadastro	:= "Relatorio de Fretes"

//======================================================
// Criacao do pergunte e interface do pergunte  
//======================================================
aAdd(aRegs,{cPerg,"01","Emissao de         "    ,"","","MV_CH1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Emissao ate        "    ,"","","MV_CH2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Vencimento de      "    ,"","","MV_CH3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Vencimento ate     "    ,"","","MV_CH4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Transportadora de  "    ,"","","MV_CH5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","SA4","","","",""})
aAdd(aRegs,{cPerg,"06","Transportadora ate "    ,"","","MV_CH6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","SA4","","","",""})
aAdd(aRegs,{cPerg,"07","Placa              "    ,"","","MV_CH7","C",07,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Com Notas/Em Aberto"    ,"","","MV_CH8","N",07,0,0,"C","","mv_par08","Com Notas","","","","","Em Aberto","","","","","","","","","","","","","","","","","","","","","","","","","",""})
    
U_CriaSX1(cPerg,aRegs)
Pergunte(cPerg,.F.)

//================================================
// Monta interface com o usuario
//================================================
aAdd(aSays,OemToAnsi("Impressão do Relatório de Fretes." ))
aAdd(aSays,OemToAnsi(""))
aAdd(aSays,OemToAnsi("Este programa tem como objetivo imprimir relatório de fretes de acordo com os parametros"))
aAdd(aSays,OemToAnsi("definidos pelo usuário.")) 
aAdd(aSays,OemToAnsi(""))

aAdd(aButtons, {11,.T.,{|o| (U_AXPA1(),o:oWnd:refresh())}	    })
aAdd(aButtons, { 6,.T.,{|o| nOpcA:= 1,o:oWnd:End() } 					})
aAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }								})

FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA == 1
	oReport := ReportDef()
	oReport:PrintDialog()	
EndIf

Return Nil

//===========================================================================
// Programa.....: ReportDef
// Data.........: 04/05/21
// Autor........: Anderson Goncalves
// Descrição....: Definicao do relatorio 
// Uso..........: Verquimica
//===========================================================================

Static Function ReportDef()

//===========================================
// Variaveis da Rotina 
//===========================================
Local cTitulo 	:= "RELATORIO DE FRETES CONTRATADOS"

Private dEmissao	:= ctod("  /  /  ")
Private dVencto		:= ctod("  /  /  ")	
Private cCte  		:= ""
Private cNf   		:= ""
Private cPedido    	:= "" 
Private cCliente  	:= ""
Private cObs  		:= ""	
Private nVlCont		:= 0
Private nVlPago  	:= 0	
Private nVlCimp  	:= 0	
Private nImposto  	:= 0  
Private cVendedor 	:= ""

Private cVendt		:= ""
Private cNomet		:= ""
Private cRegt		:= ""
Private nValort		:= 0

oReport := TReport():New("CFMDBTRANS",cTitulo,"CFMDBTRANS",{|oReport| PrintReport(oReport)},"IMPRIME "+cTitulo) 

oReport:SetLandscape()
oReport:PrintHeader(.T.,.T.)

//=======================================
// Definicao do relatorio  
//=======================================
//=======================================
// Impressao por vendedor 
//=======================================
DEFINE SECTION oImpressao OF oReport TABLES "SF2" TITLE "Por Vendedor " 

DEFINE CELL NAME "CCPO1" 	OF oImpressao ALIAS "SF2" SIZE 14 TITLE "Emissao" 	    	Block {|| dEmissao  	} ALIGN LEFT	
DEFINE CELL NAME "CCPO2"	OF oImpressao ALIAS "SF2" SIZE 14 TITLE "Vencimento" 		Block {|| dVencto		} ALIGN LEFT	
DEFINE CELL NAME "CCPO3" 	OF oImpressao ALIAS "SF2" SIZE 14 TITLE "NF. CTE"			Block {|| cCte  		} ALIGN LEFT	
DEFINE CELL NAME "CCPO4" 	OF oImpressao ALIAS "SF2" SIZE 14 TITLE "Nota Fiscal"		Block {|| cNf   		} ALIGN CENTER
DEFINE CELL NAME "CCPO5"	OF oImpressao ALIAS "SF2" SIZE 14 TITLE "Pedido"			Block {|| cPedido       } ALIGN CENTER
DEFINE CELL NAME "CCPO6" 	OF oImpressao ALIAS "SF2" SIZE 50 TITLE "Cliente"	    	Block {|| cCliente  	} ALIGN LEFT 
DEFINE CELL NAME "CCPO7" 	OF oImpressao ALIAS "SF2" SIZE 15 TITLE "Observacao" 		Block {|| cObs  		} ALIGN LEFT	
DEFINE CELL NAME "CCPO8"	OF oImpressao ALIAS "SF2" SIZE 20 TITLE "Vl.Contratado" 	Block {|| nVlCont		} ALIGN RIGHT	
DEFINE CELL NAME "CCPO9" 	OF oImpressao ALIAS "SF2" SIZE 20 TITLE "Vl.Pago"			Block {|| nVlPago  		} ALIGN RIGHT	
DEFINE CELL NAME "CCPOA" 	OF oImpressao ALIAS "SF2" SIZE 20 TITLE "Vl.C/Imposto"		Block {|| nVlCimp  		} ALIGN RIGHT	
DEFINE CELL NAME "CCPOB"	OF oImpressao ALIAS "SF2" SIZE 20 TITLE "Imposto"			Block {|| nImposto      } ALIGN RIGHT	
DEFINE CELL NAME "CCPOC" 	OF oImpressao ALIAS "SF2" SIZE 10 TITLE "Vendedor"	    	Block {|| cVendedor 	} ALIGN CENTER 

//=======================================
// Impressao por vendedor 
//=======================================
DEFINE SECTION oTotalVend OF oReport TABLES "SF2" TITLE "Total Por Vendedor " 

DEFINE CELL NAME "CCP11" 	OF oTotalVend ALIAS "SF2" SIZE 30 TITLE "Vendedor" 	    	Block {|| cVendt  	} ALIGN LEFT	
DEFINE CELL NAME "CCP12"	OF oTotalVend ALIAS "SF2" SIZE 70 TITLE "Nome" 				Block {|| cNomet	} ALIGN LEFT	
DEFINE CELL NAME "CCP13" 	OF oTotalVend ALIAS "SF2" SIZE 25 TITLE "Regiao"			Block {|| cRegt  	} ALIGN LEFT	
DEFINE CELL NAME "CCP14" 	OF oTotalVend ALIAS "SF2" SIZE 25 TITLE "Valor Total"		Block {|| nValort  	} ALIGN RIGHT

oImpressao:Cell("CCPO1"):setHeaderAlign("LEFT")
oImpressao:Cell("CCPO2"):setHeaderAlign("LEFT")
oImpressao:Cell("CCPO3"):setHeaderAlign("LEFT")
oImpressao:Cell("CCPO4"):setHeaderAlign("CENTER")
oImpressao:Cell("CCPO5"):setHeaderAlign("CENTER")
oImpressao:Cell("CCPO6"):setHeaderAlign("LEFT")
oImpressao:Cell("CCPO7"):setHeaderAlign("LEFT")
oImpressao:Cell("CCPO8"):setHeaderAlign("RIGHT")
oImpressao:Cell("CCPO9"):setHeaderAlign("RIGHT")
oImpressao:Cell("CCPOA"):setHeaderAlign("RIGHT")
oImpressao:Cell("CCPOB"):setHeaderAlign("RIGHT")
oImpressao:Cell("CCPOC"):setHeaderAlign("CENTER")

oTotalVend:Cell("CCP11"):setHeaderAlign("LEFT")
oTotalVend:Cell("CCP12"):setHeaderAlign("LEFT")
oTotalVend:Cell("CCP13"):setHeaderAlign("LEFT")
oTotalVend:Cell("CCP14"):setHeaderAlign("RIGHT")

oImpressao:SetLeftMargin(5)
oTotalVend:SetLeftMargin(5)

Return(oReport)  

//===========================================================================
// Programa.....: PrintReport
// Data.........: 06/05/21
// Autor........: Anderson Goncalves
// Descrição....: Definicao do relatorio 
// Uso..........: Verquimica
//===========================================================================

Static Function PrintReport(oReport)

//===================================
// Variaveis da Rotina     
//===================================
Local cQuery		:= Nil
Local nTotReg		:= 0
Local cPlaca		:= ""
Local cQuebra1 		:= ""
Local cNotaAnt 		:= ""
Local aTotParc		:= {0,0,0,0}
Local aTotGera		:= {0,0,0,0}
Local aNumCte		:= {}
Local nValSobra		:= 0
Local nPos			:= 0
Local nX			:= 0
Local cTmNota		:= ""
Local cClifor		:= ""
Local cLojaCl		:= ""
Local nTotVend		:= 0

Private aSaldos		:= {}

//============================================
//Realiza a leitura dos saldos de vendedores
//============================================
dbSelectArea("PA1")
PA1->(dbSetOrder(2))
cQuery := "SELECT PA1_VEND, MAX(PA1_DTSALD) DATA FROM "+RetSqlName("PA1")+" (NOLOCK) "
cQuery += "WHERE PA1_FILIAL = '"+xFilial("PA1")+"' "
cQuery += "AND PA1_TM = 'S' " 
cQuery += "AND PA1_MSBLQL <> '1' " 
cQuery += "AND D_E_L_E_T_ = ' ' " 
cQuery += "GROUP BY PA1_VEND "

U_FinalArea("QUERY")
TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())
While QUERY->(!EOF())
	PA1->(dbSeek(xFilial("PA1")+"S"+QUERY->PA1_VEND+QUERY->DATA))
	aAdd(aSaldos,{	QUERY->PA1_VEND,;
					stod(QUERY->DATA),;
					PA1->PA1_REGIAO,;
					PA1->PA1_SALDO,;
					0	})
	QUERY->(dbSkip())
Enddo
U_FinalArea("QUERY")

//===================================
// Selecao dos registros   
//===================================
If mv_par08 == 1
	cQuery := " SELECT * FROM ( "+chr(13)+Chr(10)
	cQuery += "    SELECT Z11_DOCORI NFISSAI, Z11_SERORI SERISAI, Z11_EMIORI EMISSAI, Z11_CLFORI CLIENTE, Z11_LOJORI LOJACLI, " + Chr(13)+Chr(10)
	cQuery += "    CASE WHEN Z11_COMPLE = 'E' THEN A2_NOME ELSE A1_NOME END AS NOMECLI, "+chr(13)+Chr(10)
	cQuery += "    Z11_NUMPV PEDIDO, COALESCE(Z06_CODIGO,' ') AS CODZONA, COALESCE(Z06_DESCRI,' ') AS NOMZONA, "+chr(13)+Chr(10)
	cQuery += "    Z11_VALORI VLRBRUT, Z11_TRANSP CODTRANS, A4_NOME NOMETRAN, Z11_TRANSP COD2TRAN, A4_NOME NOME2TRA, "+chr(13)+Chr(10)
	cQuery += "    COALESCE(F2_VQ_FRET,' ') FRETE, COALESCE(F2_VQ_FVER,' ') FRETVER, COALESCE(F2_VQ_FCLI,' ') FRETCLI, " +chr(13)+Chr(10)
	cQuery += "    COALESCE(F2_VQ_FVAL,Z11_FRETE) FRETVAL, Z11_DOC NFISCTE, Z11_SERIE SERICTE, Z11_CLIFOR FORNECE, "+chr(13)+Chr(10)
	cQuery += "    Z11_LOJA LOJAFOR, E2_VENCREA VENCREA, Z11_VALOR VLBRCTE, Z11_ICMS VICMCTE, Z11_ISS VISSCTE, "+chr(13)+Chr(10)
	cQuery += "    Z11_PLACA PLACA, Z11_TIPO TIPO, Z11_COMPLE OBSCTE, F2_VEND1 VVEND "+chr(13)+Chr(10)
	cQuery += "    FROM "+RetSqlName("Z11")+" Z11 (NOLOCK) "+chr(13)+Chr(10)
	cQuery += "       LEFT JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON A1_FILIAL  = '"+xFilial("SA1")+"' "+chr(13)+Chr(10)
	cQuery += "          AND A1_COD = Z11_CLFORI "+chr(13)+Chr(10)
	cQuery += "          AND A1_LOJA = Z11_LOJORI "+chr(13)+Chr(10)
	cQuery += "          AND SA1.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       LEFT JOIN "+RetSqlName("SA2")+" SA2 (NOLOCK) ON A2_FILIAL  = '"+xFilial("SA1")+"' "+chr(13)+Chr(10)
	cQuery += "          AND A2_COD = Z11_CLFORI "+chr(13)+Chr(10)
	cQuery += "          AND A2_LOJA = Z11_LOJORI "+chr(13)+Chr(10)
	cQuery += "          AND SA2.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       LEFT JOIN "+RetSqlName("Z06")+" Z06 (NOLOCK) ON Z06_FILIAL  = '"+xFilial("Z06")+"' "+chr(13)+Chr(10)
	cQuery += "          AND Z06_CODIGO = A1_REGIAO "+chr(13)+Chr(10)
	cQuery += "          AND Z06.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       INNER JOIN "+RetSqlName("SA4")+" SA4 (NOLOCK) ON A4_FILIAL  = '"+xFilial("SA4")+"' "+chr(13)+Chr(10)
	cQuery += "          AND A4_COD = Z11_TRANSP "+chr(13)+Chr(10)
	cQuery += "          AND SA4.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       INNER JOIN "+RetSqlName("SE2")+" SE2 (NOLOCK) ON E2_FILIAL  = '"+xFilial("SE2")+"' "+chr(13)+Chr(10)
	cQuery += "          AND E2_NUM = Z11_DOC "+chr(13)+Chr(10)
	cQuery += "          AND E2_PREFIXO = Z11_SERIE "+chr(13)+Chr(10)
	cQuery += "          AND E2_FORNECE = Z11_CLIFOR "+chr(13)+Chr(10)
	cQuery += "          AND E2_LOJA = Z11_LOJA "+chr(13)+Chr(10)
	cQuery += "          AND E2_TIPO = 'NF'	"+chr(13)+Chr(10)
	cQuery += "          AND E2_VENCREA BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' "+chr(13)+Chr(10)
	cQuery += "          AND SE2.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       LEFT JOIN "+RetSqlName("SF2")+" SF2 (NOLOCK) ON  F2_FILIAL = '"+xFilial("SF2")+"' "+chr(13)+Chr(10)
	cQuery += "          AND F2_DOC = Z11_DOCORI "+chr(13)+Chr(10)
	cQuery += "          AND F2_SERIE = Z11_SERORI "+chr(13)+Chr(10)
	cQuery += "          AND F2_CLIENT = Z11_CLFORI "+chr(13)+Chr(10)
	cQuery += "          AND F2_LOJA = Z11_LOJORI "+chr(13)+Chr(10)
	cQuery += "			 AND F2_VEND1 BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += "          AND SF2.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "    WHERE Z11_FILIAL = '"+xFilial("Z11")+"' "+chr(13)+Chr(10)
	cQuery += "       AND Z11_EMIORI BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "+chr(13)+Chr(10)
	cQuery += "       AND Z11_TRANSP BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "+chr(13)+Chr(10)
	cQuery += "       AND Z11_CLFORI <> Z11_CLIFOR "+chr(13)+Chr(10)
	If !Empty(mv_par07)
		cQuery += "   AND Z11_PLACA  = '"+mv_par07+"' "+chr(13)+Chr(10)
	EndIf
	cQuery += "       AND Z11.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "UNION ALL "+chr(13)+Chr(10)
	cQuery += "    SELECT Z11_DOCORI NFISSAI, Z11_SERORI SERISAI, Z11_EMIORI EMISSAI, Z11_CLFORI CLIENTE, Z11_LOJORI LOJACLI, " +chr(13)+Chr(10)
	cQuery += "    	  CASE WHEN Z11_COMPLE = 'E' THEN A2_NOME ELSE A1_NOME END AS NOMECLI, "+chr(13)+Chr(10)
	cQuery += "       Z11_NUMPV PEDIDO, COALESCE(Z06_CODIGO,' ') CODZONA, COALESCE(Z06_DESCRI,' ') NOMZONA, Z11_VALORI VLRBRUT, "+chr(13)+Chr(10)
	cQuery += "       Z11_TRANSP CODTRANS, A4_NOME NOMETRAN, Z11_TRANSP COD2TRAN, A4_NOME NOME2TRA, COALESCE(F2_VQ_FRET,' ') FRETE, "+chr(13)+Chr(10)
	cQuery += "       COALESCE(F2_VQ_FVER,' ') FRETVER, COALESCE(F2_VQ_FCLI,' ') FRETCLI, COALESCE(F2_VQ_FVAL,Z11_FRETE) FRETVAL, "+chr(13)+Chr(10)
	cQuery += "       Z11_DOC NFISCTE, Z11_SERIE SERICTE, Z11_CLIFOR FORNECE, Z11_LOJA LOJAFOR, ' ' VENCREA,  Z11_VALOR VLBRCTE, "+chr(13)+Chr(10)
	cQuery += "       Z11_ICMS VICMCTE, Z11_ISS VISSCTE, Z11_PLACA PLACA, Z11_TIPO TIPO, Z11_COMPLE OBSCTE, F2_VEND1 VVEND "+chr(13)+Chr(10)
	cQuery += "    FROM "+RetSqlName("Z11")+" Z11 (NOLOCK) "+chr(13)+Chr(10)
	cQuery += "       LEFT JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON A1_FILIAL = '"+xFilial("SA1")+"' "+chr(13)+Chr(10)
	cQuery += "          AND A1_COD = Z11_CLFORI "+chr(13)+Chr(10)
	cQuery += "          AND A1_LOJA = Z11_LOJORI "+chr(13)+Chr(10)
	cQuery += "          AND SA1.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       LEFT JOIN "+RetSqlName("SA2")+" SA2 (NOLOCK) ON A2_FILIAL = '"+xFilial("SA1")+"' "+chr(13)+Chr(10)
	cQuery += "          AND A2_COD = Z11_CLFORI "+chr(13)+Chr(10)
	cQuery += "          AND A2_LOJA = Z11_LOJORI "+chr(13)+Chr(10)
	cQuery += "          AND SA2.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       LEFT JOIN "+RetSqlName("Z06")+" Z06 (NOLOCK) ON Z06_FILIAL = '"+xFilial("Z06")+"' "+chr(13)+Chr(10)
	cQuery += "          AND Z06_CODIGO = A1_REGIAO "+chr(13)+Chr(10)
	cQuery += "          AND Z06.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       INNER JOIN "+RetSqlName("SA4")+" SA4 (NOLOCK) ON A4_FILIAL = '"+xFilial("SA4")+"' "+chr(13)+Chr(10)
	cQuery += "          AND A4_COD = Z11_TRANSP "+chr(13)+Chr(10)
	cQuery += "          AND SA4.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "       LEFT JOIN "+RetSqlName("SF2")+" SF2 (NOLOCK) ON F2_FILIAL = '"+xFilial("SF2")+"' "+chr(13)+Chr(10)
	cQuery += "          AND F2_DOC = Z11_DOCORI "+chr(13)+Chr(10)
	cQuery += "          AND F2_SERIE = Z11_SERORI "+chr(13)+Chr(10)
	cQuery += "          AND F2_CLIENT = Z11_CLFORI "+chr(13)+Chr(10)
	cQuery += "          AND F2_LOJA = Z11_LOJORI "+chr(13)+Chr(10)
	cQuery += "			 AND F2_VEND1 BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += "          AND SF2.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "    WHERE Z11_FILIAL = '"+xFilial("Z11")+"' "+chr(13)+Chr(10)
	cQuery += "       AND Z11_DOC+Z11_SERIE+Z11_CLIFOR+Z11_LOJA IN ( SELECT " +chr(13)+Chr(10)
	cQuery += "            D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA FROM "+RetSqlName("Z11")+" Z11 (NOLOCK) "+chr(13)+Chr(10)
	cQuery += "            INNER JOIN "+RetSqlName("SA4")+" SA4 (NOLOCK) ON A4_FILIAL  = '"+xFilial("SA4")+"' "+chr(13)+Chr(10)
	cQuery += "               AND A4_COD = Z11_TRANSP "+chr(13)+Chr(10)
	cQuery += "               AND SA4.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "            INNER JOIN "+RetSqlName("SE2")+" SE2 (NOLOCK) ON E2_FILIAL  = '"+xFilial("SE2")+"' "+chr(13)+Chr(10)
	cQuery += "               AND E2_NUM = Z11_DOC "+chr(13)+Chr(10)
	cQuery += "               AND E2_PREFIXO = Z11_SERIE "+chr(13)+Chr(10)
	cQuery += "               AND E2_FORNECE = Z11_CLIFOR "+chr(13)+Chr(10)
	cQuery += "               AND E2_LOJA = Z11_LOJA "+chr(13)+Chr(10)
	cQuery += "               AND E2_VENCREA BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' "+chr(13)+Chr(10)
	cQuery += "               AND SE2.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "            INNER JOIN "+RetSqlName("SD1")+" SD1 (NOLOCK) ON D1_FILIAL = '"+xFilial("SD1")+"' "+chr(13)+Chr(10)
	cQuery += "               AND D1_NFORI = Z11_DOC "+chr(13)+Chr(10)
	cQuery += "               AND D1_SERIORI = Z11_SERIE "+chr(13)+Chr(10)
	cQuery += "               AND SD1.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "         WHERE Z11.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += "            AND Z11_FILIAL = '"+xFilial("Z11")+"' "+chr(13)+Chr(10)
	cQuery += "            AND Z11_EMIORI BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "+chr(13)+Chr(10)
	cQuery += "            AND Z11_TRANSP BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "+chr(13)+Chr(10)
	If !Empty(mv_par07)
		cQuery += "   AND Z11_PLACA  = '"+mv_par07+"' "+chr(13)+Chr(10)
	EndIf
	cQuery += "       AND Z11.D_E_L_E_T_ = ' ' "+chr(13)+Chr(10)
	cQuery += " ) ) TRB "+chr(13)+Chr(10)
	cQuery += " ORDER BY FORNECE, LOJAFOR, NFISSAI, SERISAI, NFISCTE, SERICTE "

Else
	
	cQuery := " SELECT F2_DOC NFISSAI, F2_SERIE SERISAI, F2_EMISSAO EMISSAI, F2_CLIENTE CLIENTE, F2_LOJA LOJACLI, "
	cQuery += "    A1_NOME NOMECLI, '' PEDIDO, (CASE WHEN Z06_CODIGO IS NULL THEN '' ELSE Z06_CODIGO END) AS CODZONA ,"
	cQuery += " (CASE WHEN Z06_DESCRI IS NULL THEN '' ELSE Z06_DESCRI END) AS NOMZONA ,F2_VALBRUT VLRBRUT, "
	cQuery += "    Z13_TRANSP CODTRANS, SA41.A4_NOME NOMETRAN, F2_TRANSP COD2TRAN, SA42.A4_NOME NOME2TRA, F2_VQ_FRET FRETE, "
	cQuery += "    F2_VQ_FVER FRETVER, F2_VQ_FCLI  FRETCLI, F2_VQ_FVAL FRETVAL, '' NFISCTE, '' SERICTE, '' FORNECE, "
	cQuery += "    '' LOJAFOR, '' VENCREA, 0 VLBRCTE, 0 VICMCTE, 0 VISSCTE, Z13_PLACA PLACA, 'N' TIPO, 'N' OBSCTE, F2_VEND1	VVEND "
	cQuery += " FROM "+RetSqlName("Z13")+" Z13 (NOLOCK) "
	cQuery += "    INNER JOIN "+RetSqlName("Z14")+" Z14 (NOLOCK) ON Z14_FILIAL = '"+xFilial("Z14")+"' "
	cQuery += "       AND Z14_NUMERO = Z13_NUMERO " 
	cQuery += "       AND Z14.D_E_L_E_T_ = ' ' "
	cQuery += "    LEFT JOIN "+RetSqlName("SF2")+" SF2 (NOLOCK) ON F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += "       AND F2_DOC = Z14_NOTA "
	cQuery += "       AND F2_SERIE = Z14_SERIE "
	cQuery += "		  AND F2_VEND1 BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += "       AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += "    INNER JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON A1_FILIAL  = '"+xFilial("SA1")+"' "
	cQuery += "       AND A1_COD = Z14_CLIENT "
	cQuery += "       AND A1_LOJA = Z14_LOJA "
	cQuery += "       AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "    LEFT JOIN "+RetSqlName("Z06")+" Z06 (NOLOCK) ON Z06_FILIAL  = '"+xFilial("Z06")+"' "
	cQuery += "       AND Z06_CODIGO = A1_REGIAO "
	cQuery += "       AND Z06.D_E_L_E_T_ = ' ' "
	cQuery += "    INNER JOIN "+RetSqlName("SA4")+" SA41 (NOLOCK) ON SA41.A4_FILIAL  = '"+xFilial("SA4")+"' "
	cQuery += "       AND SA41.A4_COD     = Z13_TRANSP "
	cQuery += "       AND SA41.D_E_L_E_T_ = ' ' "
	cQuery += "    INNER JOIN "+RetSqlName("SA4")+" SA42 (NOLOCK) ON SA42.A4_FILIAL  = '"+xFilial("SA4")+"' "
	cQuery += "       AND SA42.A4_COD = F2_TRANSP "
	cQuery += "       AND SA42.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE Z13_FILIAL = '"+xFilial("Z13")+"' "
	cQuery += "    AND Z13_DATA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
	cQuery += "    AND Z13_TRANSP BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	If !Empty(MV_PAR07)
		cQuery += "    AND Z13_PLACA = '"+mv_par07+"' "
	EndIf
	cQuery += "    AND Z13.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY Z13_TRANSP, F2_DOC, F2_SERIE, F2_EMISSAO "
		
EndIf

U_FinalArea("QUERY")
TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())
QUERY->(dbEval({ || nTotReg++ },,{ ||!EOF()}))
QUERY->(dbGoTop())  

//===============================
//  Regua de impressao     
//===============================
oReport:SetMeter(nTotReg)

cQuebra1 := ""
cNotaAnt := ""
cPlaca   := ""
If !Empty(mv_par07)
	cPlaca := " - PLACA - "+mv_par07
EndIf

While QUERY->(!EOF()) 
    
	//=============================================
	// Incrementa a regua de impressao 
	//=============================================
	oReport:IncMeter()
    
	If oReport:Cancel()
		Exit         
	EndIf 
	
	If cQuebra1 <> QUERY->CODTRANS

		//=========================================
		// Verifica se é nova transportadora
		//=========================================
		If !Empty(cQuebra1)
			oReport:PrintText("")
			cCliente	:= "Total da secao TRANSPORTADORA"
			nVlCont		:= TransForm(aTotParc[1],"@E 999,999.99")
			nVlPago  	:= TransForm(aTotParc[2],"@E 999,999.99")
			nVlCimp  	:= TransForm(aTotParc[3],"@E 999,999.99")
			nImposto   	:= TransForm(aTotParc[4],"@E 999,999.99")
			dEmissao	:= ""
			dVencto		:= ""
			cCte  		:= ""
			cNf   		:= ""
			cPedido    	:= "" 
			cObs  		:= ""	
			cVendedor 	:= ""
			oImpressao:Init()
			oImpressao:PrintLine()  

			oReport:ThinLine()
			oReport:EndPage()
			oReport:StartPage()

			oReport:PrintText("Transportadora: "+AllTrim(QUERY->CODTRANS)+" - "+AllTrim(QUERY->NOMETRAN)+" "+cPlaca)
			oReport:PrintText("")

			aTotParc := {}
			aTotParc := {0,0,0,0}
			nVlCont		:= 0
			nVlPago  	:= 0
			nVlCimp  	:= 0
			nImposto   	:= 0

		Else

			oReport:PrintText("Transportadora: "+AllTrim(QUERY->CODTRANS)+" - "+AllTrim(QUERY->NOMETRAN)+" "+cPlaca)
			oReport:PrintText("")
		EndIf

		cQuebra1 := QUERY->CODTRANS

	Endif

	If mv_par08 == 1
		nPos := aScan(aNumCte,{|x|x == QUERY->(NFISCTE+SERICTE+FORNECE+LOJAFOR) })
  		If nPos == 0		
			aAdd(aNumCte,QUERY->(NFISCTE+SERICTE+FORNECE+LOJAFOR))
			cNotaAnt := QUERY->(NFISCTE+SERICTE+FORNECE+LOJAFOR)
			If QUERY->TIPO == "I"
				nVlPago := TransForm(QUERY->(VLBRCTE-VISSCTE),"@E 999,999.99")
		   		nVlCimp := TransForm(QUERY->(VLBRCTE-VISSCTE+VICMCTE),"@E 999,999.99")
				aTotGera[2] += QUERY->(VLBRCTE-VISSCTE)
				aTotGera[3] += QUERY->(VLBRCTE-VISSCTE+VICMCTE)
				aTotParc[2] += QUERY->(VLBRCTE-VISSCTE)
				aTotParc[3] += QUERY->(VLBRCTE-VISSCTE+VICMCTE)

			Else
				nVlPago := TransForm(QUERY->(VLBRCTE-VICMCTE-VISSCTE),"@E 999,999.99")
				nVlCimp := TransForm(QUERY->(VLBRCTE-VISSCTE),"@E 999,999.99")
				aTotGera[2] += QUERY->(VLBRCTE-VICMCTE-VISSCTE)
				aTotGera[3] += QUERY->(VLBRCTE-VISSCTE)
				aTotParc[2] += QUERY->(VLBRCTE-VICMCTE-VISSCTE)
				aTotParc[3] += QUERY->(VLBRCTE-VISSCTE)
			EndIf
			nImposto := TransForm(QUERY->(VICMCTE)+(QUERY->(VLBRCTE-VISSCTE)*0.0925),"@E 999,999.99")
			nValSobra -= QUERY->(VLBRCTE-VICMCTE-VISSCTE)
			aTotParc[4] += QUERY->(VICMCTE)+(QUERY->(VLBRCTE-VISSCTE)*0.0925)
			aTotGera[4] += QUERY->(VICMCTE)+(QUERY->(VLBRCTE-VISSCTE)*0.0925)
		Else
			nVlPago 	:= TransForm(0,"@E 999,999.99")
			nVlCimp 	:= TransForm(0,"@E 999,999.99")
			nImposto 	:= TransForm(0,"@E 999,999.99")
		EndIf
	Else
		nVlPago 	:= TransForm(QUERY->(VLBRCTE-VICMCTE-VISSCTE),"@E 999,999.99")
		nVlCimp 	:= TransForm(QUERY->(VICMCTE)+(QUERY->(VLBRCTE-VISSCTE)*0.0925),"@E 999,999.99")
		nImposto 	:= TransForm(QUERY->(VLBRCTE-VISSCTE),"@E 999,999.99")
		nValSobra 	-= QUERY->(VLBRCTE-VICMCTE-VISSCTE)
	EndIf
	
	cZonaZ06 := ""
	If !Empty(QUERY->CODZONA)
		cZonaZ06 := QUERY->CODZONA+"-"+QUERY->NOMZONA
	EndIf
	
	cCte		:= QUERY->NFISCTE
	dEmissao 	:= TransForm(stod(QUERY->EMISSAI),"@D")
	cNf 		:= QUERY->NFISSAI
	dVencto		:= TransForm(stod(QUERY->VENCREA),"@D")
	cCliente	:= QUERY->NOMECLI
	cPedido		:= QUERY->PEDIDO
	cObs		:= If(QUERY->OBSCTE$"N/ ","Normal",If(QUERY->TIPO=="I","Compl.ICMS",If(QUERY->OBSCTE=="E","Entrada","Complemento")))
	cTmNota		:= If(QUERY->OBSCTE <> "E","S","E")

	If !QUERY->OBSCTE $ "C|E|S" .And. QUERY->TIPO != "C|I"
		If AllTrim(Upper(cObs)) == "COMPLEMENTO"
			nVlCont := 0
		Else
			If !Empty(QUERY->PEDIDO)
				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5")+QUERY->PEDIDO ))
				If SC5->C5_TPFRETE == "F"
					nVlCont := 0
				Else
					nVlCont := TransForm(SC5->C5_VQ_FVAL,"@E 999,999.99")
					nValSobra += SC5->C5_VQ_FVAL
					aTotGera[1] += SC5->C5_VQ_FVAL
					aTotParc[1] += SC5->C5_VQ_FVAL
				EndIf
			Else
				nVlCont := TransForm(QUERY->FRETVAL,"@E 999,999.99")
				nValSobra += QUERY->FRETVAL
				aTotGera[1] += QUERY->FRETVAL
				aTotParc[1] += QUERY->FRETVAL
			EndIf
		EndIf
		cVendedor := QUERY->VVEND
	Else
		nVlCont := 0
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbSeek(xFilial("SC5")+QUERY->PEDIDO))
		cVendedor := SC5->C5_VEND1
	EndIf

	If Empty(cVendedor)
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbSeek(xFilial("SC5")+QUERY->PEDIDO))
		cVendedor := SC5->C5_VEND1
	EndIf

	//===================================================
	// Atualiza a movimentação de saldos
	//===================================================
	nPos := Ascan(aSaldos,{|x| x[1] == cVendedor })
	If nPos > 0
		If stod(QUERY->EMISSAI) >= aSaldos[nPos,2]

			If cTmNota == "E" 
				cClifor		:= QUERY->FORNECE
				cLojaCl		:= QUERY->LOJAFOR
			ElseIf cTmNota == "S" 
				cClifor		:= QUERY->CLIENTE
				cLojaCl		:= QUERY->LOJACLI
			EndIf

			cQuery := "SELECT COUNT(*) TOTAL FROM "+RetSqlname("PA1")+" (NOLOCK) "
			cQuery += "WHERE PA1_FILIAL = '" + xFilial("PA1") + "' "
			cQuery += "AND PA1_TM = 'M' "
			cQuery += "AND PA1_TIPO = '" +cTmNota+"' "
			cQuery += "AND PA1_NUMCTE = '" + cNf + "' "
			cQuery += "AND PA1_SERCTE = '" + QUERY->SERICTE + "' "
			If cTmNota == "E"
				cQuery += "AND PA1_CLIFOR+PA1_LOJA = '" + QUERY->FORNECE+QUERY->LOJAFOR + "' "
			else
				cQuery += "AND PA1_CLIFOR+PA1_LOJA = '" + QUERY->CLIENTE+QUERY->LOJACLI + "' "	
			EndIf
			cQuery += "AND D_E_L_E_T_ = ' ' "
			U_FinalArea("PA1_PRD")
			TcQuery cQuery New Alias "PA1_PRD"
			dbSelectArea("PA1_PRD")
			PA1_PRD->(dbGoTop())

			lGrava := .T.

			If PA1_PRD->TOTAL == 0
				If QUERY->CODTRANS == "000002" 
					If Month(firstDay(stod(QUERY->VENCREA))) > Month(date())
						lGrava := .F.
					ENDIF
				EndIf

				If lGrava
					RecLock("PA1",.T.)
					PA1->PA1_FILIAL	:= xFilial("PA1")
					PA1->PA1_TM		:= "M"
					PA1->PA1_DTSALD	:= stod(QUERY->EMISSAI)
					PA1->PA1_TIPO	:= cTmNota
					PA1->PA1_NUMCTE	:= cNf
					PA1->PA1_SERCTE	:= QUERY->SERICTE
					PA1->PA1_CLIFOR	:= If(cTmNota=="E",QUERY->FORNECE,QUERY->CLIENTE)
					PA1->PA1_LOJA	:= If(cTmNota=="E",QUERY->LOJAFOR,QUERY->LOJACLI)
					PA1->PA1_VEND	:= cVendedor
					PA1->PA1_VLCONT	:= If(ValType(nVlCont)=="C",Val(StrTran(StrTran(nVlCont,".",""),",",".")),nVlCont)
					PA1->PA1_VLPAGO	:= If(ValType(nVlPago)=="C",Val(StrTran(StrTran(nVlPago,".",""),",",".")),nVlPago)
					PA1->PA1_NOME	:= Posicione("SA3",1,xFilial("PA3")+cVendedor,"A3_NOME")
					PA1->PA1_REGIAO	:= Posicione("SA3",1,xFilial("PA3")+cVendedor,"A3_REGIAO")
					PA1->PA1_SALDO	:= If(ValType(nVlCont)=="C",Val(StrTran(StrTran(nVlCont,".",""),",",".")),nVlCont)-If(ValType(nVlPago)=="C",Val(StrTran(StrTran(nVlPago,".",""),",",".")),nVlPago)
					PA1->PA1_MSBLQL	:= "2"
					PA1->(msUnlock())
				Endif
			EndIf

			U_FinalArea("PA1_PRD")

		EndIf
	EndIf		
	oImpressao:Init()
	oImpressao:PrintLine()  

	QUERY->(dbSkip())

Enddo

U_FinalArea("QUERY")

oReport:PrintText("")
cCliente	:= "Total da secao TRANSPORTADORA"
nVlCont		:= TransForm(aTotParc[1],"@E 999,999.99")
nVlPago  	:= TransForm(aTotParc[2],"@E 999,999.99")
nVlCimp  	:= TransForm(aTotParc[3],"@E 999,999.99")
nImposto   	:= TransForm(aTotParc[4],"@E 999,999.99")
dVencto		:= ""
dEmissao	:= ""
cCte  		:= ""
cNf   		:= ""
cPedido    	:= "" 
cObs  		:= ""	
cVendedor 	:= ""
oImpressao:Init()
oImpressao:PrintLine()
oReport:ThinLine()

oReport:PrintText("")
cCliente	:= "FALTA/SOBRA"
nVlPago  	:= ""
nVlCimp  	:= ""
nImposto   	:= ""
nVlCont		:= TransForm(nValSobra,"@E 999,999.99")
oImpressao:Init()
oImpressao:PrintLine()
oReport:ThinLine()

oReport:PrintText("")
cCliente	:= "Total Geral"
nVlCont		:= TransForm(aTotGera[1],"@E 999,999.99")
nVlPago  	:= TransForm(aTotGera[2],"@E 999,999.99")
nVlCimp  	:= TransForm(aTotGera[3],"@E 999,999.99")
nImposto   	:= TransForm(aTotGera[4],"@E 999,999.99")
dVencto		:= ""
dEmissao	:= ""
cCte  		:= ""
cNf   		:= ""
cPedido    	:= "" 
cObs  		:= ""	
cVendedor 	:= ""
oImpressao:Init()
oImpressao:PrintLine()
oReport:ThinLine()

dEmissao 	:= "VENDEDOR"
dVencto 	:= "REGIÃO"
cCte	 	:= "TOTAL"
cNf      	:= ""
cPedido    	:= ""
cCliente  	:= ""
cObs  		:= ""
nVlCont		:= ""	
nVlPago  	:= ""	
nVlCimp  	:= ""
nImposto    := ""
cVendedor 	:= ""
oImpressao:Init()
oImpressao:PrintLine()
oReport:PrintText("")

U_FinalArea("QUERY")

//===================================
// Selecao dos registros (TOTAIS) 
//===================================
oReport:EndPage()
oReport:StartPage()
oReport:PrintText("     Totais por Vendedor")
oReport:PrintText("")
For nX := 1 To Len(aSaldos)
	cQuery := "SELECT PA1_VEND,SUM(PA1_SALDO) TOTAL FROM "+RetSqlName("PA1")+" (NOLOCK) "
	cQuery += "WHERE PA1_FILIAL = '" + xFilial("PA1")+ "' "
	cQuery += "AND PA1_VEND = '" + aSaldos[nX,1] + "' "
	cQuery += "AND PA1_DTSALD >= '" + dtos(aSaldos[nX,2]) + "' "
	cQuery += "AND PA1_TM = 'M' "
	cQuery += "AND D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY PA1_VEND "
	U_FinalArea("QUERY")
	TcQuery cQuery New Alias "QUERY"
	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

	aSaldos[nX,5] := aSaldos[nX,4]+QUERY->TOTAL

	cVendt 	:= aSaldos[nX,1]
	cNomet 	:= Posicione("SA3",1,xFilial("SA3")+aSaldos[nX,1],"A3_NOME")	
	cRegt 	:= aSaldos[nX,3]
	nValort := TransForm(aSaldos[nX,5],"@E 999,999,999.99")
	nTotVend += aSaldos[nX,5]
	oTotalVend:Init()
	oTotalVendo:PrintLine()  

Next nX

U_FinalArea("QUERY")

cVendt 	:= ""
cNomet 	:= ""
cRegt 	:= ""
nValort := "--------------------"
oTotalVend:Init()
oTotalVendo:PrintLine() 

cVendt 	:= ""
cNomet 	:= ""
cRegt 	:= ""
nValort := TransForm(nTotVend,"@E 999,999,999.99")
oTotalVend:Init()
oTotalVendo:PrintLine() 

Return Nil
 		
//===========================================================================
// Programa.....: AxPA1
// Data.........: 04/05/21
// Autor........: Anderson Goncalves
// Descrição....: Criação de Saldos 
// Uso..........: Verquimica
//===========================================================================

User Function AXPA1()

//================================================
// Variaveis da Rotina
//================================================
Private cFiltro		:= "PA1_FILIAL = '"+xFilial("PA1") +"' AND PA1_TM = 'S' AND D_E_L_E_T_ = ' ' "
Private cCadastro 	:= "Cadastro de Saldos"
Private aRotina 	:= MenuDef()
Private cUsersTl	:= GetMV("VQ_USFRETE",,"000000/000025/000151/000238")

If !(__cUserId $ cUsersTl)
	msgInfo("Usuário sem permissão para executar esta rotina!","Atenção")
	Return Nil
EndIf

dbSelectArea("PA1")
PA1->(dbSetOrder(1))

mBrowse( 6,1,22,75,"PA1",,,,,,,,,,,,,,cFiltro)

Return Nil

//===========================================================================
// Programa.....: MenuDef
// Autor........: Anderson Goncalves
// Data.........: 04/06/21
// Descrição....: Menu Funcional
// Uso..........: Verquimica
//===========================================================================

Static Function MenuDef()

//===============================================
// Variaveis da Rotina
//===============================================
Local aRet	:= {{"Pesquisar"	    ,"AxPesqui",0,1} ,;
             	{"Visualizar"	    ,"U_AxPA1M('PA1',PA1->(Recno()),2)" ,0,2} ,;
                {"Inclui"	        ,"U_AxPA1M('PA1',PA1->(Recno()),3)" ,0,3} ,;
             	{"Alterar"		    ,"U_AxPA1M('PA1',PA1->(Recno()),4)" ,0,4} ,;
                {"Excluir"		    ,"U_AxPA1M('PA1',PA1->(Recno()),5)" ,0,5} }

Return(aRet)

//===========================================================================
// Programa.....: AxPA1M
// Autor........: Anderson Goncalves
// Data.........: 04/06/21
// Descrição....: Manutenção dos registros
// Uso..........: Verquimica
//===========================================================================

User Function AxPA1M(cAlias,nReg,nOpc)

//================================================
// Variaveis da Rotina
//================================================
Local oEnchoice		:= Nil
Local nOpcA			:= 0
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local nModelo	  	:= 3     
Local lF3 		  	:= .F.	
Local lMemoria  	:= .T.	
Local lColumn	  	:= .F.	
Local caTela 	  	:= "" 	
Local lNoFolder 	:= .F.	
Local aButtons		:= {}
Local oDlgMain		:= Nil
 
Local INCLUI		:= If(nOpc==3,.T.,.F.) 
Local ALTERA		:= If(nOpc==4,.T.,.F.) 
Local EXCLUI		:= If(nOpc==5,.T.,.F.) 

Local aArea			:= GetArea()

dbSelectArea("PA1")
PA1->(dbSetOrder(2))
PA1->(dbGoTo(nReg))
RegToMemory("PA1",INCLUI, .F.) 

//==================================================================
// Calcula as dimensoes do objeto                                
//==================================================================
aSize := MsAdvSize()
aAdd( aObjects, { 100, 100, .T., .T. } )       
aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)   

//==================================================================
// Monta interface com o usuario                                  
//==================================================================
DEFINE MSDIALOG oDlgMain TITLE OemtoAnsi(cCadastro) From aSize[7],0 To aSize[6],aSize[5] of oMainWnd Pixel  
oEnchoice:= MsmGet():New(cAlias,nReg,nOpc,,,,,aPosObj[1],,nModelo,,,,oDlgMain,lF3,lMemoria,lColumn,caTela,lNoFolder,)
ACTIVATE MSDIALOG oDlgMain ON INIT EnchoiceBar(oDlgMain,{|| If(TudoOk(),(nOpcA:=1, oDlgMain:End()),)},{|| oDlgMain:End()},,aButtons) 

If nOpcA == 1 
	//Inclusao
	If INCLUI
		RecLock("PA1",.T.)
		dbSelectArea("SX3")
		SX3->(dbSetOrder(1))
		SX3->(dbSeek("PA1"))
		While SX3->(!EOF()) .and. SX3->X3_ARQUIVO == "PA1"
			If X3Uso(SX3->X3_USADO) .and. SX3->X3_CONTEXT <> "V"
				&("PA1->"+AllTrim(SX3->X3_CAMPO)) := &("M->"+AllTrim(SX3->X3_CAMPO))
			EndIf
			SX3->(dbSkip())
		Enddo
		PA1->PA1_FILIAL := xFilial("PA1")
		PA1->(msUnlock())
	// Alteração	
	ElseIf ALTERA
		RecLock("PA1",.F.)
		dbSelectArea("SX3")
		SX3->(dbSetOrder(1))
		SX3->(dbSeek("PA1"))
		While SX3->(!EOF()) .and. SX3->X3_ARQUIVO == "PA1"
			If X3Uso(SX3->X3_USADO) .and. SX3->X3_CONTEXT <> "V"
				&("PA1->"+AllTrim(SX3->X3_CAMPO)) := &("M->"+AllTrim(SX3->X3_CAMPO))
			EndIf
			SX3->(dbSkip())
		Enddo
		PA1->PA1_DTSALDO := Date()
		PA1->(msUnlock())
		cQuery := "UPFATE "+RetSqlName("PA1")+" SET PA1_MSBLQL = '"+M->PA1_MSBLQL+"' "
		cQuery += "WHERE PA1_FILIAL = '" + xFilial("PA1")+"' "
		cQuery += "AND PA1_TM = 'S' "
		cQuery += "AND PA1_VEND = '" + M->PA1_VEND + "' "
		cQuery += "AND D_E_L_E_T_ = ' ' "
		TcSqlExec(cQuery)

	// Exclusao
	ElseIf EXCLUI
		If msgYesNo("Deseja mesmo excluir este registro?","Atenção")
			RecLock("PA1",.F.)
			PA1->(dbDelete())
			PA1->(msUnlock())
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return Nil

//===========================================================================
// Programa.....: TudoOk
// Autor........: Anderson Goncalves
// Data.........: 04/06/21
// Descrição....: Manutenção dos registros
// Uso..........: Verquimica
//===========================================================================

Static Function TudoOk()

Local lRet	:= .T.
Local lObr	:= .F.

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("PA1"))
While SX3->(!EOF()) .and. SX3->X3_ARQUIVO == "PA1"
	lObr := X3Obrigat( AllTrim(SX3->X3_CAMPO) )
	If lObr
		If SX3->X3_TIPO == "N"
			If &("M->"+AllTrim(SX3->X3_CAMPO)) == 0
				Help(" ",1,"OBRIGAT",,RetTitle(SX3->X3_CAMPO),3)
				lRet := .F.
				Exit
			EndIf
		ElseIf SX3->X3_TIPO == "D"
			If &("M->"+AllTrim(SX3->X3_CAMPO)) == ctod("  /  /  ")
				Help(" ",1,"OBRIGAT",,RetTitle(SX3->X3_CAMPO),3)
				lRet := .F.
				Exit
			EndIf
		ElseIf SX3->X3_TIPO == "C"
			If Empty(&("M->"+AllTrim(SX3->X3_CAMPO)))
				Help(" ",1,"OBRIGAT",,RetTitle(SX3->X3_CAMPO),3)
				lRet := .F.
				Exit
			EndIf
		EndIf
	EndIf
	SX3->(dbSkip())
Enddo

Return(lRet)

 






