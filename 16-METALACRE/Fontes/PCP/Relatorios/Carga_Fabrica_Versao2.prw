#INCLUDE "rwmake.ch"                                                                                                                                     
#INCLUDE "protheus.ch"
#Define CRLF ( chr(13)+chr(10) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     º Autor ³ AP6 IDE            º Data ³  27/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CargaFabrica()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Relatório Carga Fabrica"
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

PRIVATE TMPSC6       := GETNEXTALIAS()
PRIVATE TMPSC2       := GETNEXTALIAS()      
PRIVATE AREGIS       := {}   
private prodini := ''
Private ProdFim := '' 

AjustaSX1()

If !Pergunte(cPerg,.t.)
	Return
Endif

Prodini := Mv_par01
Prodfim := Mv_par02
	
//If MV_PAR07 <> 1 // Exporta para Excel
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif
	   
	If MV_PAR04 == 1
		Cabec1         := "     PEDIDO       CLIENTE                                    O.P.      PEDIDO CLIENTE   ENTR.PEDIDO   QUANTIDADE        CAPACIDADE        TOTAL GRUPO       QT.LIMITE"
		Cabec2         := "                                                                                                      EM ABERTO          DIARIA             NO DIA           NO DIA "
	ElseIf MV_PAR04 == 2                                                                                                                                                                                                           
		Cabec1         := "                        CÓDIGO                 DESCRICAO                                              QUANTIDADE        CAPACIDADE        TOTAL GRUPO       QT.LIMITE"
		Cabec2         := "                                                                                                      EM ABERTO          DIARIA            NO DIA            NO DIA "
	ElseIf MV_PAR04 == 3                                                                                                                                                                                                            
		Cabec1         := "                        CÓDIGO                 DESCRICAO                                              QUANTIDADE        CAPACIDADE        QT.LIMITE"
		Cabec2         := "                                                                                                      EM ABERTO          DIARIA            NO DIA "
	EndIf
	                          
	SetDefault(aReturn,cString)
	                                                                                                                                                                                
	
	nTipo := If(aReturn[4]==1,15,18)
//Endif

PROCESSA({||GERAPV()},"Lendo os Pedidos de Venda","") 
//Processa( {|| PrtRel(oRpt) }, "Saldo em Estoque...", "Imprimindo...",.T.)}
PROCESSA({||GERAop()},"Lendo as Ordens de Produção")

if LEN(AREGIS) > 0
	// ordena por: Data de Entrega + OP + grupo + produto
//	_ANOTAFIS:=aSort(_ANOTAFIS,,,{ |_x,_y|_x[1]+_x[2]+_x[3]+_x[4] <=_y[1]+_y[2]+_y[3]+_y[4]})  
// PARA ORDENAR A MATRIZ, VC ESCOLHE A COLUNA N X [NO. COLUNA], SE VC QUIZER ASCENDENTE OU DESCENDENTE, TROCA O SINAL DE <
	aRegis := aSort(aRegis,,,{|_x,_y|_x[5]+_x[1]+_x[3]+_x[13]+_x[11] <=_y[5]+_y[1]+_y[1]+_y[13]+_y[11]})


//	If MV_PAR07 == 1 // Exporta para Excel
//		Processa({|| U_GerExcel(aRegis) })
//	Else
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
//	Endif
ENDIF

Return

static Function GeraPV()

AREGIS := {}

If Select(TMPSC6) <> 0
	(TMPSC6)->(dbCloseArea())
Endif

cQuery:= " SELECT C6_TES, C6_NUM, C6_NUMOP, C6_PEDCLI, C6_ENTREG, C6_QTDVEN,  BM_CAPDIA, BM_DESC, C6_QTDENT, C6_PRODUTO, " + CRLF
CQUERY+= "  B1_GRUPO, B1_TIPO, A1_NOME, A1_COD, B1_DESC, A1_LOJA, C6_ITEM, " + CRLF 
CQUERY+= "  ISNULL((SELECT TOP 1 GA_DESCOPC FROM " + RetSqlName("SGA") + " GA WHERE GA_GROPC = LEFT(C6_OPC,2) " + CRLF
CQUERY+= "  AND GA_OPC = SUBSTRING(C6_OPC,4,4) AND GA.D_E_L_E_T_<>'*'  ),'') OPCIONAL   " +CRLF
cQuery+= " FROM " + RetSqlName("SC6") +  " C6   " +CRLF
cQuery+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
cQuery+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
cQuery+= " , " + RetSqlName("SA1") +  " A1   " +CRLF 
cQuery+= " , " + RetSqlName("SC5") +  " C5   " +CRLF
cQuery+= " WHERE    "
CQUERY+= "          C6_FILIAL='"+XFilial("SC6")+"' AND C6.D_E_L_E_T_<>'*'  " +CRLF   
CQUERY+= " AND      C5_FILIAL='"+XFilial("SC5")+"' AND C5.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      B1.D_E_L_E_T_<>'*'  AND      B1_FILIAL='"+XFilial("SB1")+"' " +CRLF
cQuery+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      C6_QTDENT < C6_QTDVEN  AND C6_BLQ NOT IN('R')  AND C6_PRODUTO = B1_COD "+CRLF     
CQUERY+= " AND      C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND C5_TIPO = 'N'  " +CRLF
cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO) "+CRLF 
//cQuery+= " AND      B1_GRUPO = BM_GRUPO   "+CRLF 
cQuery+= " AND      C6_TES <> '516'   "+CRLF            
cQuery+= " AND      C6_CLI = A1_COD AND C6_LOJA = A1_LOJA " + CRLF 
// PARAMETROS
cQuery+= " AND C6_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+CRLF
If !Empty(MV_PAR03)
	cQuery+= " AND B1_GRUPO = '" + MV_PAR03 + "'   " +CRLF
EndIf                                              
cQuery+= " AND C6_ENTREG BETWEEN '" + DToS(MV_PAR05) + "' AND '" + DToS(MV_PAR06) + "'    " +CRLF   
cQuery+= " AND C6_NUMOP = ''    " +CRLF   
cquery+= " group by C6_NUM, C6_NUMOP, C6_PEDCLI, C6_ENTREG, C6_QTDVEN,  BM_CAPDIA, BM_DESC, C6_QTDENT, C6_PRODUTO, " + CRLF
CQUERY+= "  B1_GRUPO, B1_TIPO, A1_NOME, A1_COD, B1_DESC, A1_LOJA, C6_ITEM, C6_OPC, C6_TES                           " + CRLF
If MV_PAR04==3
	cQuery+= " ORDER BY C6_ENTREG, B1_GRUPO   " +CRLF
Else
	cQuery+= " ORDER BY C6_ENTREG, C6_PRODUTO   " +CRLF
EndIf

MemoWrite('C:\Qry\GERAPV.txt',cQuery)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), TMPSC6, .F., .T. )
  
DBSELECTAREA(TMPSC6)
(TMPSC6)->(dbGoTop())                 
DO WHILE !EOF()  
	IF !EMPTY((TMPSC6)->C6_NUMOP)
		QTDEPRODUZIR := U_PROCURA((TMPSC6)->C6_NUM,"(C2_QUANT-C2_QUJE-C2_PERDA)","SC2","C2_PEDIDO","C2_ITEMPV",(TMPSC6)->C6_ITEM)
		IF VALTYPE(QTDEPRODUZIR) == 'C'
			IF EMPTY(QTDEPRODUZIR)
				LCONTINUA := .F.
			ELSE
				LCONTINUA := .T.
			ENDIF
		ELSEIF QTDEPRODUZIR > 0
			LCONTINUA := .T.
		ELSE
			LCONTINUA := .F.
		ENDIF  
	ELSE
		LCONTINUA := .T.
	ENDIF
	
	IF LCONTINUA
			
		IF LEN(AREGIS) <> 0
			NN := ASCAN(AREGIS,{|_E|_E[1]== (TMPSC6)->C6_NUM .AND.  _E[11]== (TMPSC6)->C6_PRODUTO .AND. _E[5]== (TMPSC6)->C6_ENTREG .AND. _E[15]== (TMPSC6)->C6_ITEM})
			//ASCAN(_ANOTAFIS ,{|_E|_E[3]== TRBSAIDA->D2_SERIE .and. _E[4]== TRBSAIDA->D2_DOC .and. _E[8]== TRBSAIDA->D2_CLIENTE})
		ELSE
			NN := 0
		ENDIF
		
			IF NN <> 0
	                                                                                     
	
			ELSE
				AADD(AREGIS,{	(TMPSC6)->C6_NUM + (TMPSC6)->C6_ITEM,;
								(TMPSC6)->A1_NOME,;
								(TMPSC6)->C6_NUMOP,;
								iif(Empty((TMPSC6)->C6_PEDCLI),SPACE(6),alltrim((TMPSC6)->C6_PEDCLI)),;
								(TMPSC6)->C6_ENTREG,;
								'',;
								(TMPSC6)->C6_QTDVEN,;
								0 ,;
								(TMPSC6)->C6_QTDVEN - (TMPSC6)->C6_QTDENT,;
								(TMPSC6)->BM_CAPDIA,;
								(TMPSC6)->C6_PRODUTO,;
								(TMPSC6)->BM_DESC , (TMPSC6)->B1_GRUPO, ;
								iif(mv_par04==1,alltrim((TMPSC6)->B1_DESC)+ "-" + (TMPSC6)->OPCIONAL,alltrim((TMPSC6)->B1_DESC)), (TMPSC6)->C6_ITEM })
			ENDIF 
	ENDIF
	DBSELECTAREA(TMPSC6)
	(TMPSC6)->(DBSKIP())
ENDDO					
				


Return                                               


static Function GeraOP()

If Select(TMPSC2) <> 0
	(TMPSC2)->(dbCloseArea())
Endif

cQuery:= " SELECT C2_PEDIDO, C2_ITEMPV, C2_PRODUTO, C2_NUM, C2_ITEM, C2_SEQUEN, A1_NOME, C2_DATAJF, "
CQUERY+= " B1_GRUPO, BM_DESC, BM_CAPDIA, C2_QUANT, C2_QUJE, C2_DATPRF, B1_DESC "
CQUERY+= " 
CQUERY+= "  , CASE WHEN C2_PEDIDO <> '' THEN ( "
CQUERY+= " 	ISNULL((SELECT TOP 1 GA_DESCOPC FROM " + RETSQLNAME("SGA") + " GA , " + RETSQLNAME("SC6") + " C6 WHERE GA_GROPC = LEFT(C6_OPC,2) "
CQUERY+= " 			AND GA_OPC = SUBSTRING(C6_OPC,4,4) AND GA.D_E_L_E_T_<>'*' and C6_NUM = C2_PEDIDO AND C6_ITEM = C2_ITEMPV  ),'') ) "
CQUERY+= " 		WHEN C2_PEDIDO = '' THEN '' "
CQUERY+= " END AS OPCIONAL "
CQUERY+= " FROM "   +CRLF
cQuery+= " " + RetSqlName("SC2") +  " C2   " +CRLF
cQuery+= " , " + RetSqlName("SB1") +  " B1   " +CRLF
cQuery+= " , " + RetSqlName("SA1") +  " A1   " +CRLF
cQuery+= " , " + RetSqlName("SBM") +  " BM   " +CRLF
cQuery+= " WHERE    "
CQUERY+= "          C2_FILIAL='"+XFilial("SC2")+"' AND C2.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      B1.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      BM_FILIAL='"+XFilial("SBM")+"' AND BM.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      A1_FILIAL='"+XFilial("SA1")+"' AND A1.D_E_L_E_T_<>'*'  " +CRLF   
cQuery+= " AND      B1_FILIAL='"+XFilial("SB1")+"' AND B1.D_E_L_E_T_<>'*'  " +CRLF
cQuery+= " AND      C2_PRODUTO = B1_COD  "+CRLF         
cQuery+= " AND      ((B1_GRUPO = BM_GRUPO AND B1_XGRUPO = '') OR B1_XGRUPO = BM_GRUPO) "+CRLF 
//cQuery+= " AND      B1_GRUPO = BM_GRUPO  AND C2_CLI = A1_COD AND C2_LOJA = A1_LOJA "
cQuery+= " AND      C2_CLI = A1_COD AND C2_LOJA = A1_LOJA "
CQUERY+= " AND (C2_QUANT-C2_QUJE-C2_PERDA) > 0 AND (C2_PEDIDO <> '' OR B1_TIPO IN ('PA','PC') ) " +CRLF
// PARAMETROS
cQuery+= " AND C2_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "+CRLF
If !Empty(MV_PAR03)
	cQuery+= " AND B1_GRUPO = '" + MV_PAR03 + "'   " +CRLF
EndIf                                              
cQuery+= " AND NOT (C2_TPOP = 'F' AND C2_DATRF <> '' AND (C2_QUJE < C2_QUANT OR C2_QUJE >= C2_QUANT)) " +CRLF                            
cQuery+= " AND C2_DATPRF BETWEEN '" + DToS(MV_PAR05) + "' AND '" + DToS(MV_PAR06) + "'    " +CRLF                            
If MV_PAR04==3
	cQuery+= " ORDER BY C2_DATPRF, B1_GRUPO   " +CRLF
Else
	cQuery+= " ORDER BY C2_DATPRF, C2_PRODUTO   " +CRLF
EndIf

MemoWrite('C:\Qry\TMPSC2.txt',cQuery)

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), TMPSC2, .F., .T. )

DBSELECTAREA(TMPSC2)
(TMPSC2)->(dbGoTop())
DO WHILE !EOF()  
	IF !EMPTY((TMPSC2)->C2_PEDIDO) 
		NOTA := U_PROCURA((TMPSC2)->C2_PEDIDO,"C6_NOTA","SC6","C6_NUM","C6_ITEM",(TMPSC2)->C2_ITEMPV)
		IF EMPTY(NOTA)         
			NN := ASCAN(AREGIS,{|_E|_E[3]== (TMPSC2)->C2_NUM .AND.  _E[11]== (TMPSC2)->C2_PRODUTO .AND.  _E[5]== (TMPSC2)->C2_DATPRF .AND. _E[15]== (TMPSC2)->C2_ITEM })
			//ASCAN(_ANOTAFIS ,{|_E|_E[3]== TRBSAIDA->D2_SERIE .and. _E[4]== TRBSAIDA->D2_DOC .and. _E[8]== TRBSAIDA->D2_CLIENTE})
			IF NN <> 0     
			   aregis[NN][5] := (TMPSC2)->C2_DATPRF
			   aregis[NN][8] := (TMPSC2)->C2_QUANT 
			   AREGIS[NN][9] := AREGIS[NN][9] - (TMPSC2)->C2_QUJE
			   // SE O TOTAL FOR ZERO, OU SEJA A QUANTIDADE PRODUZIDA JA FOR IGUAL A DO PEDIDO, ENTÃO NÃP PRECISA APARECER NO RELATORIO.
			ELSE
				AADD(AREGIS,{	(TMPSC2)->C2_PEDIDO + (TMPSC2)->C2_ITEMPV,;
								(TMPSC2)->A1_NOME,;
								(TMPSC2)->C2_NUM,;
								'      ',;
								(TMPSC2)->C2_DATPRF,;
								(TMPSC2)->C2_DATAJF,;
								0,;
								(TMPSC2)->C2_QUANT ,;
								(TMPSC2)->C2_QUANT - (TMPSC2)->C2_QUJE,;
								(TMPSC2)->BM_CAPDIA,;
								(TMPSC2)->C2_PRODUTO,;
								(TMPSC2)->BM_DESC , (TMPSC2)->B1_GRUPO, ;
								iif(MV_PAR04 == 1,alltrim((TMPSC2)->B1_DESC) + "-" + (TMPSC2)->OPCIONAL,alltrim((TMPSC2)->B1_DESC)),(TMPSC2)->C2_ITEM})
			ENDIF  
		ENDIF      
	ELSE                                            
			AADD(AREGIS,{	SPACE(6),;
							(TMPSC2)->A1_NOME,;
							(TMPSC2)->C2_NUM,;
							'     ',;
							(TMPSC2)->C2_DATPRF,;
							(TMPSC2)->C2_DATAJF,;
							0,;
							(TMPSC2)->C2_QUANT ,;
							(TMPSC2)->C2_QUANT - (TMPSC2)->C2_QUJE,;
							(TMPSC2)->BM_CAPDIA,;
							(TMPSC2)->C2_PRODUTO,;
							(TMPSC2)->BM_DESC, (TMPSC2)->B1_GRUPO,;
							iif(MV_PAR04 == 1,alltrim((TMPSC2)->B1_DESC) + "-" + (TMPSC2)->OPCIONAL,alltrim((TMPSC2)->B1_DESC))})
	ENDIF	
	DBSELECTAREA(TMPSC2)
	(TMPSC2)->(DBSKIP())
ENDDO					


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

If MV_PAR04 == 1 // Relatório Detalhado

	cProd := aregis[1][11] //TRB->C6_PRODUTO
	cData := aRegis[1][5] 
	cDatAnt := CDATA
	cProAnt := CPROD
	cDesAnt := aRegis[1][12]
	cGrpAnt := aRegis[1][13]

	for II := 1 to len(aregis)	                                            

	   if AREGIS[II][9] == 0    // QTDE PRODUZIDA - QTDE ESTA ZERADO. JA ENTREGOU TUDO.

		ELSE
				
			IF (II+1) <= LEN(AREGIS)
				cDatdep := aRegis[ii+1][5]
			ELSE
				cDatdep := ''
			ENDIF
	
			cDatAnt := aRegis[II][5] // ENTREGA //TRB->C6_ENTREG	
				
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			@nLin,005 PSAY AREGIS[II][1] //TRB->C6_NUM  
			@nLin,014 PSAY AREGIS[II][2] //TRB->A1_NOME
			@nLin,060 PSAY AREGIS[II][3] // OP
			@nLin,075 PSAY substr(AREGIS[II][4],1,6)  //TRB->C6_PEDCLI
			@nLin,085 PSAY DToC(SToD(AREGIS[II][5]))
			@nLin,100 PSAY AREGIS[II][9]  Picture "@E 999,999,999" // TRB->C6_QTDVEN - TRB->C6_QTDENT
			@nLin,120 PSAY AREGIS[II][10] Picture "@E 999,999,999"  // TRB->BM_CAPDIA 
			@nLin,140 PSAY U_CargaGrp(AREGIS[II][13], SToD(cDatant), SToD(cDatant),prodini,prodfim) Picture "@E 999,999,999" // TOTAL GRuPO DIA 
			@nLin,160 PSAY AREGIS[II][10] - u_CargaGrp(AREGIS[II][13], SToD(cDatant), SToD(cDatant),prodini,prodfim) Picture "@E 999,999,999"   // QTDE LIMIT DIA = CAPACIDADE DIARIA 
			                                                                                                                  // - TOTAL GRUPO DIA
			nLin++
	
			nQPProd += IIF(AREGIS[II][8] == 0, AREGIS[II][7],AREGIS[II][8])
			nQAProd += AREGIS[II][9]
			
			nQPDia += IIF(AREGIS[II][8] == 0, AREGIS[II][7],AREGIS[II][8])
			nQADia += AREGIS[II][9]
			
	//		nLin++
			
			cDatAnt := aRegis[II][5] // ENTREGA //TRB->C6_ENTREG
			cProAnt := AREGIS[II][11]
			cDesAnt := Alltrim(AREGIS[II][14]) /* + ' ' + AllTrim(TRB->OPCIONAL) */
			cGrpAnt := AREGIS[II][13] //TRB->B1_GRUPO
			
			cData := aRegis[II][5]
			if (II+1) <= len(aregis)
				cProd := AREGIS[II+1][11]
			else
				cProd := ''
			endif
	
			//If cproAnt <> cProd  .or. cDatdep <> cData     
			
				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif

				
				@nLin,000 PSAY Replicate("_",200)
				@nLin,005 PSAY "TOTAL DIA/PRODUTO:     " +  cGrpAnt +  "  " + cDesAnt
				@nLin,140 PSAY nQPProd  Picture "@E 999,999,999"
				@nLin,160 PSAY nQAProd  Picture "@E 999,999,999"
				
	 //			@nLin,000 PSAY Replicate("_",125)
				nLin++
				nLin++
				
				nQPProd := 0
				nQAProd := 0
				
			//EndIf
			If cDatdep <> cData
				@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(CDATA))
				@nLin,140 PSAY nQPDia  Picture "@E 999,999,999"
				@nLin,160 PSAY nQADia Picture "@E 999,999,999"
				nLin++
	//			@nLin,000 PSAY Replicate("_",220)
				nLin++ 
				nQADiaTot:= nQADiaTot + nQADia
				nQPDia := 0
				nQADia := 0       
			EndIf
	
		ENDIF		
    NEXT II

	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
		
	nLin++
	@nLin,040 PSAY "TOTAL GERAL PERIODO: " +  DToC(MV_PAR05) +" ATE "+DToC(MV_PAR06)
	@nLin,140 PSAY nQADiaTot 	   Picture "@E 999,999,999,999,999" 
	nLin++
	@nLin,000 PSAY Replicate("_",220)
	
	
ElseIf MV_PAR04 == 2    // sintetico. agrupa por produto

					//ordenar por data e grupo
//	aRegis  := aSort(aRegis,,,{|_x,_y|_x[5]+_x[11] <=_y[5]+_y[11]})
	aGru    := {}    
	cPROatu := aRegis[1][11]	
	cDatAtu := aRegis[1][5]
	
	nQADia:= 0
	nCTotGeral:=0
	nLimGeral :=0
	nQADiaTot :=0
	
	FOR II := 1 TO LEN(AREGIS)  
	
	   if AREGIS[II][9] == 0

		ELSE

				
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			// ENQUANTO FOR A MESMA DATA      
//			if cDatAtu == aRegis[II][5]
			
				NN:= ASCAN(AGRU  ,{|_E|_E[1]== AREGIS[II][11]   .and.  _E[6]== AREGIS[II][5]})      
				   //ASCAN(AREGIS,{|_E|_E[3]== (TMPSC2)->C2_NUM .AND.  _E[11]== (TMPSC2)->C2_PRODUTO})
				IF NN == 0 
					aadd(aGru,{AREGIS[II][11], AREGIS[II][14], AREGIS[II][9],AREGIS[II][10],aregis[II][13],aRegis[II][5]})
				ELSE
					AGRU[NN][3] := AGRU[NN][3] + AREGIS[II][9]
					AGRU[NN][4] := AREGIS[II][10]
				ENDIF 
  		endif
	NEXT II      

	cDatAtu := aGru[1][6]
	aGru    := aSort(aGru,,,{|_x,_y|_x[6]+_x[1] <=_y[6]+_y[1]})			
	FOR GRU := 1 TO LEN(AGRU)
				
		if cDatAtu <> aGru[GRU][6]      

			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif

			nLin++
			@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(cDatatu))
			@nLin,100 PSAY nQADia    Picture "@E 999,999,999"
 //			@nLin,120 PSAY nCTotGeral Picture "@E 999,999,999"
//			@nLin,140 PSAY nLimGeral Picture "@E 999,999,999"
					
			nLin++
			@nLin,000 PSAY Replicate("_",220)                
			nLin++                                           
					
			nQADiaTot+= nQADia
			nQADia     := 0
			nCTotGeral := 0
			nLimGeral  := 0	    
		ENDIF		
				 
		cargadia := u_CargaGrp(AGRU[GRU][5], SToD(AGRU[GRU][6]), SToD(AGRU[GRU][6]),prodini,prodfim)      
				
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
				
				
		@nLin,005 PSAY "TOTAL DIA/PRODUTO: "
		@nLin,025 PSAY AGRU[GRU][1]
		@nLin,045 PSAY AGRU[GRU][2]
					
		@nLin,100 PSAY AGRU[GRU][3] Picture "@E 999,999,999"
		@nLin,120 PSAY AGRU[GRU][4] Picture "@E 999,999,999"
		@nLin,140 PSAY cargadia     Picture "@E 999,999,999"
		@nLin,160 PSAY AGRU[GRU][4]- cargadia Picture "@E 999,999,999" 
//		@nLin,160 PSAY AGRU[GRU][4]- AGRU[GRU][3] Picture "@E 999,999,999"
			
		nQADia    += AGRU[GRU][3]
		nCTotGeral+= AGRU[GRU][4]
		nLimGeral += AGRU[GRU][4] - AGRU[GRU][3]
						
		nLin++	              
				
		cDatAtu := aGru[gru][6]
	 NEXT GRU
	        
	    
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

	nLin++
	@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(cDatatu))
	@nLin,100 PSAY nQADia    Picture "@E 999,999,999"
//	@nLin,140 PSAY nCTotGeral Picture "@E 999,999,999"
//	@nLin,160 PSAY nLimGeral Picture "@E 999,999,999"
					
	nLin++
	@nLin,000 PSAY Replicate("_",220)                
	nLin++                                           
					
	nQADiaTot+= nQADia
	nQADia     := 0
	nCTotGeral := 0
	nLimGeral  := 0	    		
	    	
	nLin++
	@nLin,040 PSAY "TOTAL GERAL PERIODO: " +  DToC(MV_PAR05) +" ATE "+DToC(MV_PAR06)
	@nLin,100 PSAY nQADiaTot 	   Picture "@E 999,999,999,999,999"
	nLin++
	@nLin,000 PSAY Replicate("_",220)
	
ElseIf MV_PAR04 == 3   //sintetico grupo
    
	//ordenar por data e grupo
	aRegis  := aSort(aRegis,,,{|_x,_y|_x[5]+_x[13] <=_y[5]+_y[13]})
	aGru    := {}    
	cgrpatu := aRegis[1][13]	
	cDatAtu := aRegis[1][5]
	
	nQADia:= 0
	nCTotGeral:=0
	nLimGeral :=0
	nQADiaTot :=0
	nQAP80 	  :=0
	nCTotD80  :=0
	cDesc80	  :=""
	nQAP22 	  :=0
	nCTotD22  :=0
	cDesc22	  :=""   
	
	FOR II := 1 TO LEN(AREGIS)
		
	   if AREGIS[II][9] == 0

		ELSE
	
			cDesAnt := AREGIS[II][12] //TRB->BM_DESC
			cGrpAnt := AREGIS[II][13] //TRB->B1_GRUPO
			
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif  
			
			if cDatAtu <> aRegis[II][5]

				FOR GRU := 1 TO LEN(AGRU)       
	
					If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif
				    
					cargadia := u_CargaGrp(AGRU[GRU][1], SToD(cDatAtu), SToD(cDatAtu),prodini,prodfim)
					@nLin,005 PSAY "TOTAL DIA/GRUPO: "
					@nLin,025 PSAY AGRU[GRU][1]
					@nLin,045 PSAY AGRU[GRU][2]
					
					@nLin,100 PSAY AGRU[GRU][3] Picture "@E 999,999,999"      // qtde a produzie
					@nLin,120 PSAY AGRU[GRU][4] Picture "@E 999,999,999"      // capacidade diaria
//					@nLin,160 PSAY AGRU[GRU][4]- cargadia Picture "@E 999,999,999"   
					@nLin,140 PSAY AGRU[GRU][4]- AGRU[GRU][3] Picture "@E 999,999,999"
				
					nQADia    += AGRU[GRU][3]
					nCTotGeral+= AGRU[GRU][4]
					nLimGeral += AGRU[GRU][4] - AGRU[GRU][3]
							
					nLin++	              
		        NEXT GRU
		        
		        aGRU := {}   
		        
			If nQAP80>0
				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY "612/613"
				@nLin,045 PSAY "Familia REF.80 / Familia REF.81 / Familia REF.83" //cDesc80
				
				@nLin,100 PSAY nQAP80 Picture "@E 999,999,999"
				@nLin,120 PSAY nCTotD80 Picture "@E 999,999,999"
				@nLin,140 PSAY nCTotD80-nQAP80 Picture "@E 999,999,999"
				nLin++
				nQAP80 	  :=0
				nCTotD80  :=0
				cDesc80	  :=""
			EndIF

			If nQAP22>0
				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY "605/617"
				@nLin,045 PSAY "Familia REF.22"//cDesc22
				
				@nLin,100 PSAY nQAP22 Picture "@E 999,999,999"
				@nLin,120 PSAY nCTotD22 Picture "@E 999,999,999"
				@nLin,140 PSAY nCTotD22 - nQAP22 Picture "@E 999,999,999"
				nLin++
				nQAP22 	  :=0
				nCTotD22  :=0
				cDesc22	  :=""
			EndIF		        
		    
				nLin++
				@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(cDatatu))
				@nLin,100 PSAY nQADia    Picture "@E 999,999,999"
				@nLin,120 PSAY nCTotGeral Picture "@E 999,999,999"
				@nLin,140 PSAY nLimGeral Picture "@E 999,999,999"
				
				nLin++
				@nLin,000 PSAY Replicate("_",220)                
				nLin++                                           
				
				nQADiaTot+= nQADia
				nQADia     := 0
				nCTotGeral := 0
				nLimGeral  := 0	 
				
				cDatAtu := aRegis[II][5]   
		    
		    ENDIF	    
			
			
			// ENQUANTO FOR A MESMA DATA      
//			if cDatAtu == aRegis[II][5]
			
				If AllTrim(AREGIS[II][13]) $ "612/613"    //Familia 80 e 81 e 83
					nQAP80   += AREGIS[II][9]
					nCTotD80 := AREGIS[II][10]
					cDesc80  += If (AllTrim(AREGIS[II][12]) $ cDesc80, "", AllTrim(AREGIS[II][12]) + " / ") 
				ELSEIF AllTrim(AREGIS[II][13]) $ "605/617" //cGrpAnt == AREGIS[GRU][13]
					nQAP22   += AREGIS[II][9]
					nCTotD22 := AREGIS[II][10]
					cDesc22  += If (AllTrim(AREGIS[II][12]) $ cDesc22, "", AllTrim(AREGIS[II][12]) + " / ")      
				ENDIF 				
	
				NN:= ASCAN(AGRU,{|_E|_E[1]== AREGIS[II][13]})
				IF NN == 0 
					aadd(aGru,{AREGIS[II][13], AREGIS[II][12], AREGIS[II][9],AREGIS[II][10]})
				ELSE
					AGRU[NN][3] := AGRU[NN][3] + AREGIS[II][9]         //    qtde produzir
//					AGRU[NN][4] := AREGIS[II][10]                      // capac diaria
				ENDIF
  //		    Endif
		    	// AI IMPRIME OS GRUPOS Q ACHOU NA DATA E ZERA O ARRAY DOS GRUPOS.
				// faz a impressao dos dados.				
			cDatAtu := aRegis[II][5]
    	ENDIF
	NEXT II      
	   
	// imprime o ultimo
			FOR GRU := 1 TO LEN(AGRU)    

				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
			
				cargadia := u_CargaGrp(AGRU[GRU][1], SToD(cDatAtu), SToD(cDatAtu),prodini,prodfim)
				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY AGRU[GRU][1]
				@nLin,045 PSAY AGRU[GRU][2]
					
				@nLin,100 PSAY AGRU[GRU][3] Picture "@E 999,999,999"
				@nLin,120 PSAY AGRU[GRU][4] Picture "@E 999,999,999"
//				@nLin,140 PSAY cargadia     Picture "@E 999,999,999"
//				@nLin,160 PSAY AGRU[GRU][4]- cargadia Picture "@E 999,999,999"   
				@nLin,140 PSAY AGRU[GRU][4]- AGRU[GRU][3] Picture "@E 999,999,999"
			
				nQADia    += AGRU[GRU][3]
				nCTotGeral+= AGRU[GRU][4]
				nLimGeral += AGRU[GRU][4] - AGRU[GRU][3]
						
				nLin++	              
	        NEXT GRU
	        
	        aGRU := {} 

			If nQAP80>0
				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY "612/613"
				@nLin,045 PSAY "Familia REF.80 / Familia REF.81 / Familia REF.83" //cDesc80
				
				@nLin,100 PSAY nQAP80 Picture "@E 999,999,999"
				@nLin,120 PSAY nCTotD80 Picture "@E 999,999,999"
				@nLin,140 PSAY nCTotD80-nQAP80 Picture "@E 999,999,999"
				nLin++
				nQAP80 	  :=0
				nCTotD80  :=0
				cDesc80	  :=""
			EndIF

			If nQAP22>0
				@nLin,005 PSAY "TOTAL DIA/GRUPO: "
				@nLin,025 PSAY "605/617"
				@nLin,045 PSAY "Familia REF.22"//cDesc22
				
				@nLin,100 PSAY nQAP22 Picture "@E 999,999,999"
				@nLin,120 PSAY nCTotD22 Picture "@E 999,999,999"
				@nLin,140 PSAY nCTotD22 - nQAP22 Picture "@E 999,999,999"
				nLin++
				nQAP22 	  :=0
				nCTotD22  :=0
				cDesc22	  :=""
			EndIF	        
	    
			nLin++
			@nLin,040 PSAY "TOTAL GERAL DIA: " +  DToC(SToD(cDatatu))
			@nLin,100 PSAY nQADia    Picture "@E 999,999,999"
			@nLin,120 PSAY nCTotGeral Picture "@E 999,999,999"
			@nLin,140 PSAY nLimGeral Picture "@E 999,999,999"
			
			nLin++
			@nLin,000 PSAY Replicate("_",220)                
			nLin++                                           
			
			nQADiaTot+= nQADia
			nQADia     := 0
			nCTotGeral := 0
			nLimGeral  := 0	    
	    	
	nLin++
	@nLin,040 PSAY "TOTAL GERAL PERIODO: " +  DToC(MV_PAR05) +" ATE "+DToC(MV_PAR06)
	@nLin,100 PSAY nQADiaTot 	   Picture "@E 999,999,999,999,999"
	nLin++
	@nLin,000 PSAY Replicate("_",220)
	
EndIf



SET DEVICE TO SCREEN


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
//PutSx1(cPerg, "07","Gera Excel   ?","","","mv_ch7", "N",01,0,0,"C","","   ","","","mv_par07","Sim",""      ,""      ,""    ,"Nao"    ,""     ,""      ,"",""      ,""      ,""            ,""      ,""     ,""        ,""      ,""      ,""      ,""      ,""      ,"")

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GerExcel()³ Autor ³ Luiz Alberto  ³ Data ³ 09.05.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Exportacao para Excel do Relatorio                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GerExcel(aItens)
Local aCabec := {}
Local aDados := {}

If !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
   Return .f.
EndIf

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
	
	If MV_PAR04 == 1
		AAdd(aDados,{aRegis[nItem,1],;
						aRegis[nItem,2],;
						aRegis[nItem,3],;
						aRegis[nItem,4],;
						StoD(aRegis[nItem,5]),;
						TransForm(aRegis[nItem,9],"999999"),;
						TransForm(aRegis[nItem,10],"999999"),;
						TransForm(U_CargaGrp(AREGIS[nItem][13], SToD(AREGIS[nItem][5]), SToD(AREGIS[nItem][5]),Mv_par01,Mv_par02),"999999"),;
						TransForm(AREGIS[nItem][10] - u_CargaGrp(AREGIS[nItem][13], SToD(AREGIS[nItem][5]), SToD(AREGIS[nItem][5]),Mv_par01,Mv_par02) ,"999999")})
	ElseIf MV_PAR04 == 2		
		AAdd(aDados,{	aRegis[nItem,11],;
						aRegis[nItem,14],;
						TransForm(aRegis[nItem,9],"999999"),;
						TransForm(aRegis[nItem,10],"999999"),;
						TransForm(U_CargaGrp(AREGIS[nItem][13], SToD(AREGIS[nItem][5]), SToD(AREGIS[nItem][5]),Mv_par01,Mv_par02),"999999"),;
						TransForm(AREGIS[nItem][10] - u_CargaGrp(AREGIS[nItem][13], SToD(AREGIS[nItem][5]), SToD(AREGIS[nItem][5]),Mv_par01,Mv_par02) ,"999999"),;
						'',;
						'',;
						''})
	ElseIf MV_PAR04 == 3
		AAdd(aDados,{	aRegis[nItem,11],;
						aRegis[nItem,14],;
						TransForm(aRegis[nItem,9],"999999"),;
						TransForm(aRegis[nItem,10],"999999"),;
						TransForm(AREGIS[nItem][10] - u_CargaGrp(AREGIS[nItem][13], SToD(AREGIS[nItem][5]), SToD(AREGIS[nItem][5]),Mv_par01,Mv_par02) ,"999999"),;
						TransForm(0,"999999"),;
						'',;
						'',;
						''})
	Endif
Next
If Len(aDados) > 0
	DlgToExcel({ {"ARRAY", "Relatório Carga Fabrica - Periodo de " + DTOC(MV_PAR05) + " Ate " + DTOC(MV_PAR06), aCabec, aDados} })
Endif
Return()