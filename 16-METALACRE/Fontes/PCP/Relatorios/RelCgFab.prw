#INCLUDE "rwmake.ch"                                                                                                                                     
#INCLUDE "protheus.ch"
#Define CRLF 		( chr(13)+chr(10) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelCgFab   บ Autor ณ Luiz Alberto    บ Data ณ  09/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Versใo Relatorio Carga Fabrica com Novo Esquema de Agrupamento
				de grupos de produtos e exporta็ใo para excel.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RelCgFab()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Relat๓rio Carga Fabrica"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "2newCarga" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "2NewCarga" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "RCarma"
Private cString      := "SB1"

PRIVATE aRegis       := {}   

AjustaSX1()

If !Pergunte(cPerg,.t.)
	Return
Endif


If MV_PAR07 <> 1 // Exporta para Excel
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	   
	If nLastKey == 27
		Return
	Endif

	If MV_PAR04 == 1
		Cabec1         := "     PEDIDO       CLIENTE                                    O.P.      PEDIDO CLIENTE   ENTR.PEDIDO   QUANTIDADE        CAPACIDADE        TOTAL GRUPO       QT.LIMITE"
		Cabec2         := "                                                                                                      EM ABERTO          DIARIA             NO DIA           NO DIA "
	ElseIf MV_PAR04 == 2                                                                                                                                                                                                           
		Cabec1         := "                        CำDIGO                 DESCRICAO                                              QUANTIDADE        CAPACIDADE        TOTAL GRUPO       QT.LIMITE"
		Cabec2         := "                                                                                                      EM ABERTO          DIARIA            NO DIA            NO DIA "
	ElseIf MV_PAR04 == 3                                                                                                                                                                                                            
		Cabec1         := "                        CำDIGO                 DESCRICAO                                              QUANTIDADE        CAPACIDADE        QT.LIMITE"
		Cabec2         := "                                                                                                      EM ABERTO          DIARIA            NO DIA "
	EndIf
	                          
	SetDefault(aReturn,cString)
	                                                                                                                                                                                
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
Endif

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

If MV_PAR07 == 1	// Exporta para Excel
	GerXls(aRegis)
Endif
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery    := ""
Local nQPProd   := 0 // Quantidade programada por produto/Dia
Local nQAProd   := 0 // Quantidade em aberto  por produto/Dia

Local nQPDia    := 0 // Quantidade programada por Dia
Local nQADia    := 0 // Quantidade em aberto  por Dia
Local nQADiaTot := 0
Local nCTotDia  := 0 // Capacidade Total Dia
Local nCTotGeral:= 0 // Capacidade Total Geral
Local nLimDia   := 0 // Total limite periodo
Local aGrupos	:= {}

// Cria Vetor com os Agrupamentos de Grupos de Produtos Para Quebra e Totaliza็ใo no Relat๓rio

PWJ->(dbGoTop())
While PWJ->(!Eof())
	cTemp := AllTrim(StrTran(PWJ->PWJ_GRUPOS,' ',''))
	If Right(cTemp,1)$'|'
		cTemp := Left(cTemp,Len(cTemp)-1)
	Endif
	
	AAdd(aGrupos,{  PWJ->PWJ_COD,;
					PWJ->PWJ_DESCR,;
					FormatIn(cTemp,"|"),;
					0.00,;
					0.00,;
					0.00})
	
	PWJ->(dbSkip(1))
Enddo


cQuery	:= " SELECT ISNULL((SELECT TOP 1 'M'+PWJ_COD FROM " + RetSqlName("PWJ") + " WHERE CHARINDEX(B1_GRUPO,PWJ_GRUPOS) > 0 AND D_E_L_E_T_ = ''),'G'+B1_GRUPO) MIX, B1_GRUPO, BM_DESC, C6_TES, C6_NUM  , C6_NUMOP, C6_PEDCLI, C6_ENTREG   , C6_QTDVEN,  BM_CAPDIA, C6_QTDENT, C6_PRODUTO, B1_TIPO, A1_NOME, A1_COD, B1_DESC, A1_LOJA, C6_ITEM  , '' C2_ITEM, '' C2_SEQUEN, '' C2_DATAJF,  ISNULL((SELECT TOP 1 GA_DESCOPC FROM " + RetSqlName("SGA") + " GA WHERE GA_GROPC = LEFT(C6_OPC,2) AND GA_OPC = SUBSTRING(C6_OPC,4,4) AND GA.D_E_L_E_T_<>'*'  ),'') OPCIONAL   " +CRLF
cQuery	+= "   FROM " + RetSqlName("SC6") +  " C6   " +CRLF
cQuery	+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
cQuery	+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
cQuery	+= " , " + RetSqlName("SA1") +  " A1   " +CRLF
cQuery	+= " , " + RetSqlName("SC5") +  " C5   " +CRLF
cQuery	+= " , " + RetSqlName("SF4") +  " F4   " +CRLF
cQuery	+= " WHERE              C6_FILIAL='"+XFilial("SC6")+"' AND C6.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*' AND C5.C5_PEDWEB = '' " +CRLF
cQuery	+= " AND      B1.D_E_L_E_T_<>'*'  AND      B1_FILIAL='"+XFilial("SB1")+"' " +CRLF
cQuery	+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      F4_FILIAL='"+XFilial("SF4")+"' AND F4.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      C6_QTDENT < C6_QTDVEN  AND C6_PRODUTO = B1_COD " +CRLF
cQuery	+= " AND      C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5_TIPO = 'N'  " +CRLF
If !Empty(MV_PAR03)
	cQuery+= " AND B1_GRUPO = '" + MV_PAR03 + "'   " +CRLF
EndIf                                              
cQuery	+= " AND      B1_GRUPO = BM_GRUPO   " +CRLF
cQuery	+= " AND      C6_TES = F4.F4_CODIGO" +CRLF
cQuery	+= " AND      F4.F4_ESTOQUE = 'S' AND F4.F4_DUPLIC = 'S'" +CRLF
cQuery	+= " AND      C6_CLI = A1_COD AND C6_LOJA = A1_LOJA " +CRLF
cQuery	+= " AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+CRLF
cQuery	+= " AND C6_ENTREG BETWEEN '" + DToS(MV_PAR05) + "' AND '" + DToS(MV_PAR06) + "'    " +CRLF   
cQuery	+= " AND C6_NUMOP = ''    " +CRLF
cQuery	+= "UNION " +CRLF
cQuery	+= "SELECT ISNULL((SELECT TOP 1 'M'+PWJ_COD FROM " + RetSqlName("PWJ") + " WHERE CHARINDEX(B1_GRUPO,PWJ_GRUPOS) > 0 AND D_E_L_E_T_ = ''),'G'+B1_GRUPO) MIX, B1_GRUPO, BM_DESC, '' C6_TES ,C2_PEDIDO, C2_NUM  , '' C6_PEDCLI, C2_DATPRF, C2_QUANT,   BM_CAPDIA, C2_QUJE  , C2_PRODUTO, B1_TIPO, A1_NOME, A1_COD, B1_DESC, A1_LOJA, C2_ITEMPV,    C2_ITEM,    C2_SEQUEN,    C2_DATAJF,  CASE WHEN C2_PEDIDO <> '' THEN (  	ISNULL((SELECT TOP 1 GA_DESCOPC FROM " + RetSqlName("SGA") + " GA , " + RetSqlName("SC6") + " C6 WHERE GA_GROPC = LEFT(C6_OPC,2)  			AND GA_OPC = SUBSTRING(C6_OPC,4,4) AND GA.D_E_L_E_T_<>'*' and C6_NUM = C2_PEDIDO AND C6_ITEM = C2_ITEMPV  ),'') )  		WHEN C2_PEDIDO = '' THEN ''  END AS OPCIONAL  " +CRLF
cQuery	+= "FROM " + RetSqlName("SC2") +  " C2   " +CRLF
cQuery	+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
cQuery	+= " , " + RetSqlName("SA1") +  " A1   " +CRLF
cQuery	+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
cQuery	+= " WHERE              C2_FILIAL='"+XFilial("SC2")+"' AND C2.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      B1.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      B1_FILIAL='"+XFilial("SB1")+"' AND B1.D_E_L_E_T_<>'*'  " +CRLF
cQuery	+= " AND      C2_PRODUTO = B1_COD  " +CRLF
If !Empty(MV_PAR03)
	cQuery+= " AND B1_GRUPO = '" + MV_PAR03 + "'   " +CRLF
EndIf                                              
cQuery	+= " AND      B1_GRUPO = BM_GRUPO  AND C2_CLI = A1_COD AND C2_LOJA = A1_LOJA  AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') ) " +CRLF
cQuery	+= " AND C2_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+CRLF
cQuery	+= " AND NOT (C2_TPOP = 'F' AND C2_DATRF <> '' AND (C2_QUJE < C2_QUANT OR C2_QUJE >= C2_QUANT)) " +CRLF                            
cQuery	+= " AND C2_DATPRF BETWEEN '" + DToS(MV_PAR05) + "' AND '" + DToS(MV_PAR06) + "'    " +CRLF   
cQuery	+= " ORDER BY C6_ENTREG, MIX, C6_PRODUTO " +CRLF

MemoWrite('C:\Qry\GERACG2.txt',cQuery)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TmpCg', .F., .T. )

TCSETFIELD( "TmpCg","C6_ENTREG","D")
TCSETFIELD( "TmpCg","C2_DATAJF","D")

dbSelectArea('TmpCg')
Count To nReg

TmpCg->(dbGoTop())                 

aTotais:= {	{0,0,0},; // Total Mix/Grupo
			{0,0,0},; // Total Data
			{0,0,0},; // Total Produto
			{0,0,0}}  // Total Geral

cMix := TmpCg->MIX
dDat := TmpCg->C6_ENTREG
cPrd := TmpCg->C6_PRODUTO

SetRegua(nReg)
While TmpCg->(!Eof())
	IncRegua()
	

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif


	nQtdPrd	:= 0.00

	If !Empty(TmpCg->C6_NUMOP)	// Caso Contrario trata-se de Opดs Jแ Geradas
		If SC2->(dbSetOrder(1), dbSeek(xFilial("SC2")+TmpCg->C6_NUMOP+TmpCg->C2_ITEM+TmpCg->C2_SEQUEN))
			While SC2->(!Eof()) .And. SC2->C2_FILIAL == xFilial("SC2") .And. SC2->C2_NUM == TmpCg->C6_NUMOP
				If TmpCg->C6_PRODUTO == SC2->C2_PRODUTO
					If Empty(SC2->C2_DATRF)
						nQtdPrd += aSC2Sld()
					Endif
				Endif
				SC2->(dbSkip(1))
			EndDo
		EndIf
		
		// Se Nใo Tiver Saldo a Produzir Entใo Pula
		
		If Empty(nQtdPrd)
			TmpCg->(dbSkip(1));Loop
		Endif
	Endif


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
	If nLin > 55 .And. MV_PAR07 <> 1 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
			
	cGrupo := ''
	nAchou := Ascan(aGrupos,{|x| TmpCg->B1_GRUPO $ x[3] })
	If Empty(nAchou)
		cGrupo := "('"+TmpCg->B1_GRUPO+"')"
	Else
		cGrupo := aGrupos[nAchou,3]
	Endif          
		
	nTotGrp := CgGrp(cGrupo, TmpCg->C6_ENTREG, TmpCg->C6_ENTREG,MV_PAR01,MV_PAR02)

	If MV_PAR04 == 1 // Relatorio Detalhado
		If MV_PAR07 <> 1
			@nLin,005 PSAY TmpCg->C6_NUM
			@nLin,014 PSAY TmpCg->A1_NOME
			@nLin,060 PSAY TmpCg->C6_NUMOP
			@nLin,075 PSAY Left(TmpCg->C6_PEDCLI,6)
			@nLin,085 PSAY DToC(TmpCg->C6_ENTREG)
			@nLin,100 PSAY (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)  Picture "@E 999,999,999" // TRB->C6_QTDVEN - TRB->C6_QTDENT
			@nLin,120 PSAY TmpCg->BM_CAPDIA Picture "@E 999,999,999"  // TRB->BM_CAPDIA 
			@nLin,140 PSAY nTotGrp Picture "@E 999,999,999" // TOTAL GRuPO DIA 
			@nLin,160 PSAY (TmpCg->BM_CAPDIA - nTotGrp) Picture "@E 999,999,999"   // QTDE LIMIT DIA = CAPACIDADE DIARIA 
			nLin++
			@nLin,016 PSAY AllTrim(TmpCg->C6_PRODUTO)+' - '+Alltrim(TmpCg->B1_DESC) + ' ' + AllTrim(TmpCg->OPCIONAL)
        Endif
        AAdd(aRegis,{Chr(160)+TmpCg->C6_NUM,; 
        				TmpCg->A1_NOME,;
        				Chr(160)+TmpCg->C6_NUMOP,;
        				Left(TmpCg->C6_PEDCLI,6),;
        				DToC(TmpCg->C6_ENTREG),;            
        				(TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT),;
        				TmpCg->BM_CAPDIA,;
        				nTotGrp,;                  
        				(TmpCg->BM_CAPDIA - nTotGrp)})

        AAdd(aRegis,{'',; 
        				Chr(160)+AllTrim(TmpCg->C6_PRODUTO)+' - '+Alltrim(TmpCg->B1_DESC) + ' ' + AllTrim(TmpCg->OPCIONAL),;
        				'',;
        				'',;
        				'',;            
        				0,;
        				0,;
        				0,;                  
        				0})
	ElseIf MV_PAR04 == 2	// Sintetico 
		If MV_PAR07 <> 1
			@nLin,016 PSAY AllTrim(TmpCg->C6_PRODUTO)+' - '+Alltrim(TmpCg->B1_DESC) + ' ' + AllTrim(TmpCg->OPCIONAL)
			@nLin,100 PSAY (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)  Picture "@E 999,999,999" // TmpCg->C6_QTDVEN - TRB->C6_QTDENT
			@nLin,120 PSAY TmpCg->BM_CAPDIA Picture "@E 999,999,999"  // TRB->BM_CAPDIA 
			@nLin,140 PSAY nTotGrp Picture "@E 999,999,999" // TOTAL GRuPO DIA 
			@nLin,160 PSAY TmpCg->BM_CAPDIA - nTotGrp Picture "@E 999,999,999"   // QTDE LIMIT DIA = CAPACIDADE DIARIA 
		Endif
        AAdd(aRegis,{	Chr(160)+AllTrim(TmpCg->C6_PRODUTO),;
        				Alltrim(TmpCg->B1_DESC) + ' ' + AllTrim(TmpCg->OPCIONAL),;            
        				(TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT),;
        				TmpCg->BM_CAPDIA,;
        				nTotGrp,;                  
        				(TmpCg->BM_CAPDIA - nTotGrp),;
        				'',; 
        				'',;
        				''})

	ElseIf MV_PAR04 == 3	// Sintetico Grupo
		If MV_PAR07 <> 1
			@nLin,018 PSAY TmpCg->B1_GRUPO
			@nLin,040 PSAY TmpCg->BM_DESC
			@nLin,100 PSAY (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)  Picture "@E 999,999,999" // TRB->C6_QTDVEN - TRB->C6_QTDENT
			@nLin,120 PSAY TmpCg->BM_CAPDIA Picture "@E 999,999,999"  // TRB->BM_CAPDIA 
			@nLin,140 PSAY nTotGrp Picture "@E 999,999,999" // TOTAL GRuPO DIA 
			@nLin,160 PSAY TmpCg->BM_CAPDIA - nTotGrp Picture "@E 999,999,999"   // QTDE LIMIT DIA = CAPACIDADE DIARIA 
		Endif
        AAdd(aRegis,{	Chr(160)+TmpCg->B1_GRUPO,;
        				TmpCg->BM_DESC,;            
        				(TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT),;
        				TmpCg->BM_CAPDIA,;
        				(TmpCg->BM_CAPDIA - nTotGrp),;
        				'',; 
        				'',; 
        				'',;
        				''})
	Endif

	// Total Mix

	aTotais[1,1] += (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)
	aTotais[1,2] += (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)
	aTotais[1,3]++

	// Total Data
	aTotais[2,1] += (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)		
	aTotais[2,2] += (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)
	aTotais[2,3]++
	
	// Total Produto	
	aTotais[3,1] += (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT) 	
	aTotais[3,2] += (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)
	aTotais[3,3]++
	
	// Total Geral
	aTotais[4,1] += (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)		// Total Geral
	aTotais[4,2] += (TmpCg->C6_QTDVEN - TmpCg->C6_QTDENT)
	aTotais[4,3]++

    TmpCg->(dbSkip(1))
    
    If cMix <> TmpCg->MIX

    	If Left(cMix,1) == 'G'
	    	SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+SubStr(cMix,2)))
	    	cDesGrp := SBM->BM_DESC
	    ElseIf Left(cMix,1) == 'M'
			If PWJ->(dbSetOrder(1), dbSeek(xFilial("PWJ")+SubStr(cMix,2)))
				cDesGrp	:=  AllTrim(PWJ->PWJ_DESCR) + ' - Grupos: (' + AllTrim(PWJ->PWJ_GRUPOS) + ') '
			Endif
		Endif

        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'',;            
        				'',;
        				'',;
        				'',;                  
        				''})
    	nLin+=2
    	
		If MV_PAR07 <> 1
			@nLin,017 PSAY 'Total Grupo: ' + SubStr(cMix,2) + ' - ' + cDesGrp
			@nLin,140 PSAY aTotais[1,1] Picture "@E 999,999,999" 
			@nLin,160 PSAY aTotais[1,2] Picture "@E 999,999,999" 
		Endif		
        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'Total Grupo: ' + SubStr(cMix,2) + ' - ' + cDesGrp,;            
        				'',;
        				'',;
        				aTotais[1,1],;                  
        				aTotais[1,2]})

        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'',;            
        				'',;
        				'',;
        				'',;                  
        				''})
		nLin++
		
		aTotais[1,1] := 0
		aTotais[1,2] := 0
		aTotais[1,3] := 0
		cMix	:= TmpCg->MIX
	Endif

    If dDat	<> TmpCg->C6_ENTREG
    	nLin+=2

        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'',;            
        				'',;
        				'',;
        				'',;                  
        				''})

		If MV_PAR07 <> 1
			@nLin,017 PSAY 'Total Dia (' + DtoC(dDat) + '): '
			@nLin,140 PSAY aTotais[2,1] Picture "@E 999,999,999" 
			@nLin,160 PSAY aTotais[2,2] Picture "@E 999,999,999" 
		Endif		
        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'Total Dia (' + DtoC(dDat) + '): ',;            
        				'',;
        				'',;
        				aTotais[2,1],;                  
        				aTotais[2,2]})

        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'',;            
        				'',;
        				'',;
        				'',;                  
        				''})
		nLin++
		
		aTotais[2,1] := 0
		aTotais[2,2] := 0
		aTotais[2,3] := 0
		dDat := TmpCg->C6_ENTREG
	Endif
    	
    If cPrd	<> TmpCg->C6_PRODUTO .And. 1 > 1
    	nLin+=2

        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'',;            
        				'',;
        				'',;
        				'',;                  
        				''})

		If MV_PAR07 <> 1
			@nLin,017 PSAY 'Total Produto (' + cPrd + '): '
			@nLin,140 PSAY aTotais[3,1] Picture "@E 999,999,999" 
			@nLin,160 PSAY aTotais[3,2] Picture "@E 999,999,999" 
		Endif		
        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'Total Produto (' + cPrd + '): ',;            
        				'',;
        				'',;
        				aTotais[3,1],;                  
        				aTotais[3,2]})

        AAdd(aRegis,{	'',; 
        				'',;
        				'',;
        				'',;
        				'',;            
        				'',;
        				'',;
        				'',;                  
        				''})
		nLin++
		
		aTotais[3,1] := 0
		aTotais[3,2] := 0
		aTotais[3,3] := 0
		cPrd := TmpCg->C6_PRODUTO
	Endif
    	
	nLin++

Enddo
If !Empty(aTotais[4,1])
	nLin+=2

    AAdd(aRegis,{	'',; 
       				'',;
       				'',;
       				'',;
       				'',;            
       				'',;
       				'',;
       				'',;                  
       				''})

	If MV_PAR07 <> 1
		@nLin,014 PSAY 'TOTAL GERAL: '
		@nLin,140 PSAY aTotais[4,1] Picture "@E 999,999,999" 
		@nLin,160 PSAY aTotais[4,2] Picture "@E 999,999,999" 
	Endif
    AAdd(aRegis,{	'',; 
       				'',;
       				'',;
       				'',;
       				'TOTAL GERAL: ',;            
       				'',;
       				'',;
       				aTotais[4,1],;                  
       				aTotais[4,2]})
Endif
SET DEVICE TO SCREEN

TmpCg->(dbCloseArea())

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function AjustaSX1()

PutSx1(cPerg, "01","Item De      ?","","","mv_ch1" ,"C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02","Item Ate     ?","","","mv_ch2" ,"C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03","Grupo        ?","","","mv_ch3" ,"C",04,0,0,"G","","SBM","","","mv_par03","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04","Tipo         ?","","","mv_ch4", "N",01,0,0,"C","","   ","","","mv_par04","Detalhado",""      ,""      ,""    ,"Sintetico"    ,""     ,""      ,"Sintetico Grupo",""      ,""      ,""            ,""      ,""     ,""        ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg, "05","Entrega De   ?","","","mv_ch5" ,"D",08,0,0,"G","","   ","","","mv_par05","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06","Entrega Ate  ?","","","mv_ch6" ,"D",08,0,0,"G","","   ","","","mv_par06","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "07","Gera Excel   ?","","","mv_ch7", "N",01,0,0,"C","","   ","","","mv_par07","Sim",""      ,""      ,""    ,"Nao"    ,""     ,""      ,"",""      ,""      ,""            ,""      ,""     ,""        ,""      ,""      ,""      ,""      ,""      ,"")

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ GerExcel()ณ Autor ณ Luiz Alberto  ณ Data ณ 09.05.14 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera Exportacao para Excel do Relatorio                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GerXls(aRegis)
Local aCabec := {}
Local aDados := {}

/*If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel nใo instalado!")
   Return .f.
EndIf
  */
If MV_PAR04 == 1
	aCabec		   := {'Pedido','Cliente','O.P.','Pedido Cliente','Entr.Pedido','Qtd em Aberto','Capac Diaria',	'Total Grp Dia','Qt.Limite Dia'}
ElseIf MV_PAR04 == 2 
	aCabec		   := {'Codigo','Descricao','Qtd em Aberto','Capac Diaria',	'Total Grp Dia','Qt.Limite Dia','','',''}
ElseIf MV_PAR04 == 3                                                                                                                                                                                                            
	aCabec		   := {'Codigo','Descricao','Qtd em Aberto','Capac Diaria','Qt.Limite Dia','','','',''}
EndIf


ProcRegua(Len(aRegis))
For nItem := 1 To Len(aRegis)
	IncProc('Gerando Planilha Excel - Aguarde...')
	
	cConteudo := aRegis[nItem,6]
	If Type("cConteudo") == 'C'
		If MV_PAR04 == 2
			AAdd(aDados,{	aRegis[nItem,4],;
							aRegis[nItem,5],;
							aRegis[nItem,6],;
							aRegis[nItem,7],;
							TransForm(aRegis[nItem,8],"999999"),;
							TransForm(aRegis[nItem,9],"999999"),;
							'',;
							'',;
							''})
		ElseIf MV_PAR04 == 3
			AAdd(aDados,{	aRegis[nItem,5],;
							aRegis[nItem,6],;
							aRegis[nItem,7],;
							TransForm(aRegis[nItem,8],"999999"),;
							TransForm(aRegis[nItem,9],"999999"),;
							'',;
							'',;
							'',;
							''})
		Else
			AAdd(aDados,{aRegis[nItem,1],;
							aRegis[nItem,2],;
							aRegis[nItem,3],;
							aRegis[nItem,4],;
							aRegis[nItem,5],;
							aRegis[nItem,6],;
							aRegis[nItem,7],;
							TransForm(aRegis[nItem,8],"999999"),;
							TransForm(aRegis[nItem,9],"999999")})
		Endif
	Else                
		If MV_PAR04 == 1
			AAdd(aDados,{aRegis[nItem,1],;
							aRegis[nItem,2],;
							aRegis[nItem,3],;
							aRegis[nItem,4],;
							aRegis[nItem,5],;
							TransForm(aRegis[nItem,6],"999999"),;
							TransForm(aRegis[nItem,7],"999999"),;
							TransForm(aRegis[nItem,8],"999999"),;
							TransForm(aRegis[nItem,9],"999999")})
		ElseIf MV_PAR04 == 2
			AAdd(aDados,{aRegis[nItem,1],;
							aRegis[nItem,2],;
							TransForm(aRegis[nItem,3],"999999"),;
							TransForm(aRegis[nItem,4],"999999"),;
							TransForm(aRegis[nItem,5],"999999"),;
							TransForm(aRegis[nItem,6],"999999"),;
							'',;
							'',;
							''})
		ElseIf MV_PAR04 == 3
			AAdd(aDados,{aRegis[nItem,1],;
							aRegis[nItem,2],;
							TransForm(aRegis[nItem,3],"999999"),;
							TransForm(aRegis[nItem,4],"999999"),;
							TransForm(aRegis[nItem,5],"999999"),;
							'',;
							'',;
							'',;
							''})
		Endif
	Endif
Next
If Len(aDados) > 0
	DlgToExcel({ {"ARRAY", "Relat๓rio Carga Fabrica - Periodo de " + DTOC(MV_PAR05) + " Ate " + DTOC(MV_PAR06), aCabec, aDados} })
Endif
Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ AP6 IDE            บ Data ณ  27/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CgGrp(cGrupo, dDataIni, dDataFim,cProdini,cProdfim)

LOCAL NQTOCUP := 0  
local cqrycarga := ''

cGrupo:= AllTrim(cGrupo)


//cqrycarga:= " SELECT ISNULL((SUM(C6_QTDVEN)-SUM(C6_QTDENT)),0) QTD_OCUP  " +CRLF  
cqrycarga:= " SELECT C6_NUM, C6_ITEM, C6_PRODUTO, C6_ENTREG,C6_QTDVEN, C6_QTDENT,  (C6_QTDVEN-C6_QTDENT) AS QTD_OCUP  " +CRLF
cqrycarga+= " FROM "+RetSqlName("SBM")+" BM  " +CRLF  
cqrycarga+= " ,    "+RetSqlName("SC6")+" C6  " +CRLF
cqrycarga+= " ,    "+RetSqlName("SB1")+" B1 " +CRLF
cqrycarga+= " WHERE	BM_FILIAL='"+XFilial("SBM")+"'  " +CRLF    
cqrycarga+= " AND  	B1_FILIAL='"+XFilial("SB1")+"'  " +CRLF  
cqrycarga+= " AND  	C6_FILIAL='"+XFilial("SC6")+"'  " +CRLF 
cqrycarga+= " AND  	B1_GRUPO=BM_GRUPO AND B1.D_E_L_E_T_<>'*' AND B1_TIPO IN('PA') " +CRLF  
cqrycarga+= " AND      C6_PRODUTO=B1_COD AND C6.D_E_L_E_T_<>'*' AND C6_PRODUTO BETWEEN '" + cProdIni + "' AND '" + cProdfim + "'  " +CRLF  
If !Empty(cGrupo)
	cqrycarga+= " 		AND BM_GRUPO IN " + cGrupo +CRLF	
Endif
/*If cGrupo=="612" .or. cGrupo=="613"
	cqrycarga+= " 		AND (BM_GRUPO='612' OR BM_GRUPO='613') " +CRLF
ElseIf cGrupo=="605" .or. cGrupo=="617"
	cqrycarga+= " 		AND (BM_GRUPO='605' OR BM_GRUPO='617') " +CRLF
Else
	cqrycarga+= " 		AND BM_GRUPO='"+cGrupo+"'  " +CRLF  
EndIf */
cqrycarga+= " 		AND BM.D_E_L_E_T_<>'*'  " +CRLF
cqrycarga+= " 		AND C6_ENTREG BETWEEN '" + DToS(dDataIni) + "' AND '" + DToS(dDataFim) + "'    " +CRLF
cqrycarga+= " AND C6_NUMOP = '' "		
MemoWrite('C:\qry\CARGASC6' + cGrupo + '.txt',cqrycarga)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cqrycarga), "GRP", .F., .T. )     

DBSELECTAREA("GRP")
GRP->(DBGOTOP())
DO WHILE !GRP->(EOF())
	NQTOCUP:= GRP->QTD_OCUP  + NQTOCUP
	DBSELECTAREA("GRP")
	GRP->(DBSKIP())
ENDDO
	

GRP->(DbCloseArea())


// OPS 

cqrycarga:= " SELECT  C2_NUM, C2_PRODUTO, C2_DATPRI, C2_DATPRF, C2_QUANT, C2_QUJE, (C2_QUANT - C2_QUJE) AS QTD_OCUP  " +CRLF
cqrycarga+= " FROM "+RetSqlName("SBM")+" BM  " +CRLF
cqrycarga+= " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_GRUPO=BM_GRUPO AND B1.D_E_L_E_T_<>'*' AND B1_TIPO IN('PA')  " +CRLF
cqrycarga+= " INNER JOIN "+RetSqlName("SC2")+" C2 ON C2_FILIAL='"+XFilial("SC2")+"' AND C2_PRODUTO=B1_COD AND C2.D_E_L_E_T_<>'*' " + CRLF 
cqrycarga+= " AND C2_PRODUTO BETWEEN '" + cProdini + "' AND '" + cProdfim + "'      " +CRLF
cqrycarga+= " WHERE	BM_FILIAL='"+XFilial("SBM")+"'  " +CRLF    
cqrycarga+= " AND  	B1_FILIAL='"+XFilial("SB1")+"'  " +CRLF 
If !Empty(cGrupo)
	cqrycarga+= " 		AND BM_GRUPO IN " + cGrupo +CRLF	
Endif
/*If cGrupo=="612" .or. cGrupo=="613"
	cqrycarga+= " 		AND (BM_GRUPO='612' OR BM_GRUPO='613') " +CRLF
ElseIf cGrupo=="605" .or. cGrupo=="617"
	cqrycarga+= " 		AND (BM_GRUPO='605' OR BM_GRUPO='617') " +CRLF
Else
	cqrycarga+= " 		AND BM_GRUPO='"+cGrupo+"'  " +CRLF  
EndIf */
cqrycarga+= " 		AND BM.D_E_L_E_T_<>'*'  and (C2_QUANT-C2_QUJE-C2_PERDA) > 0 " +CRLF
cqrycarga+= " 		AND C2_DATPRI>='"+DToS(dDataIni)+"'  " +CRLF        
cqrycarga+= " 		AND C2_DATPRF<='"+DToS(dDataFim)+"'  " +CRLF  
		
MemoWrite('C:\qry\CARGASC2' + cGrupo + '.txt',cqrycarga)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cqrycarga), "GRP1", .F., .T. )     

DBSELECTAREA("GRP1") 
GRP1->(DBGOTOP())
DO WHILE !GRP1->(EOF())
	NQTOCUP:= NQTOCUP + GRP1->QTD_OCUP  
	DBSELECTAREA("GRP1")
	GRP1->(DBSKIP())
ENDDO
GRP1->(DbCloseArea())


Return (nQtOcup)

