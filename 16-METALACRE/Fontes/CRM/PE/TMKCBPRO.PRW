#INCLUDE 'PROTHEUS.CH' 
#INCLUDE "TBICONN.CH"
#INCLUDE "rwmake.ch"  
#INCLUDE "Totvs.ch"
#Include "TOPCONN.CH" 
                                                                                                                              
#Define CRLF ( chr(13)+chr(10) )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKCBPRO  บAutor  ณMateus Hengle       บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada pra adicionar botoes na barra superior     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre 				                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TMKCBPRO()

Local aButtons := {}   

AAdd(aButtons ,{ "Carga Fabrica"	,	{|| U_FABRICA()}, 'Carga Fabrica','Carga Fabrica'})	
AAdd(aButtons ,{ "Pers. Lacres"		,	{|| U_RFATA010()}, "Pers. Lacres","Pers. Lacres"})
AAdd(aButtons ,{ "Pers X Cliente"	,	{|| U_PERXCLIX()}, "Pers X Cliente","Pers X Cliente"})
AAdd(aButtons ,{ "Prod X Cliente"	,	{|| U_AXCADSA()}, "Prod X Cliente","Prod X Cliente"})
AAdd(aButtons ,{ "Liberar Pedido"	,	{|| MATA440()}, "Liberar Pedido","Liberar Pedido"})
AAdd(aButtons ,{ "Muda Status Atend",	{|| U_MDSTATAT()}, "Muda Status Atend","Muda Status Atend"})
aadd(aButtons ,{ 'Hist๓rico Cliente',   {|| U_HISTCLI(M->UA_CLIENTE,M->UA_LOJA)},"Hist๓rico Cliente","Hist๓rico Cliente"})
AAdd(aButtons ,{ "Contatos ***"		,	{|| U_FContato()}, "Lista de Contatos","Lista de Contatos"})
Return(aButtons)                                               

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

User Function Fabrica()

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

PRIVATE TMPSC6       := GETNEXTALIAS()
PRIVATE TMPSC2       := GETNEXTALIAS()      
PRIVATE AREGIS       := {}   
private prodini := ''
Private ProdFim := '' 

AjustaSX1()

Pergunte(cPerg,.t.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
   
Prodini := Mv_par01
Prodfim := Mv_par02

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
                          
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
                                                                                                                                                                                
If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

PROCESSA({||GERAPV()},"Lendo os Pedidos de Venda","") 
//Processa( {|| PrtRel(oRpt) }, "Saldo em Estoque...", "Imprimindo...",.T.)}
PROCESSA({||GERAop()},"Lendo as Ordens de Produ็ใo")

if LEN(AREGIS) > 0
	// ordena por: Data de Entrega + OP + grupo + produto
//	_ANOTAFIS:=aSort(_ANOTAFIS,,,{ |_x,_y|_x[1]+_x[2]+_x[3]+_x[4] <=_y[1]+_y[2]+_y[3]+_y[4]})  
// PARA ORDENAR A MATRIZ, VC ESCOLHE A COLUNA N X [NO. COLUNA], SE VC QUIZER ASCENDENTE OU DESCENDENTE, TROCA O SINAL DE <
	aRegis := aSort(aRegis,,,{|_x,_y|_x[5]+_x[1]+_x[3]+_x[13]+_x[11] <=_y[5]+_y[1]+_y[1]+_y[13]+_y[11]})

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
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
cQuery+= " AND      C6_QTDENT < C6_QTDVEN AND C6_PRODUTO = B1_COD "+CRLF     
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
				AADD(AREGIS,{	(TMPSC6)->C6_NUM + C6_ITEM,;
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
			   // SE O TOTAL FOR ZERO, OU SEJA A QUANTIDADE PRODUZIDA JA FOR IGUAL A DO PEDIDO, ENTรO NรP PRECISA APARECER NO RELATORIO.
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


If MV_PAR04 == 1 // Relat๓rio Detalhado

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
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. . .                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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
			
				If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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

	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. . .                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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

			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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
				
		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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
	        
	    
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. . .                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif  
			
			if cDatAtu <> aRegis[II][5]

				FOR GRU := 1 TO LEN(AGRU)       
	
					If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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

				If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
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

Return() 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFATA010 บ Autor ณBruno Daniel Borges บ Data ณ  25/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de personalizacoes de lacres                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RFATA01()
Private cCadastro := "Cadastro de Personalizacoes de Lacres"
Private aRotina := { 	{"Pesquisar"	,"AxPesqui",0,1} ,;
						{"Visualizar"	,"U_RFATA1",0,2} ,;
						{"Incluir"		,"U_RFATA1",0,3} ,;
						{"Alterar"		,"U_RFATA1",0,4} ,;
						{"Excluir"		,"U_RFATA1",0,5} ,;
						{"Senha"		,"U_TelaPS(.T.,.T.)",0,6}}

dbSelectArea("Z00")
Z00->(dbSetOrder(1))

mBrowse( 6,1,22,75,"Z00")

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFATA10A บAutor  ณBruno Daniel Borgessบ Data ณ  25/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de manutencao no cadastro de personalizacoes de lacres บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFATA1(x,y,nOpcBrw)
Local oDlgMain     := Nil
Local oEnchoice    := Nil
Local oGetDados    := Nil
Local aCoordenadas := MsAdvSize(.T.)
Local aCols        := {}
Local aHeader      := {}
Local nOpcClick    := 0
Local i,j     
Local lRet 
Local _lDeleta      := (!Altera .and. !Inclui .and. nOpcBrw == 5 ) // Deletar

Private cCodigo		:=""
Private aButtons	:={}
Private cParametro  := GetMV("MV_DIRPDF")//Parametro criado para que usuแrio defina onde armazenar os Arquivos PDF

Private aTela[0][0]
Private aGets[0]

&& Bruno Abrigo em 26-03-2012 controle de inclusao por senha

Private _lOk:=.T.

dbSelectArea("Z00")

&& Bruno Abrigo em 30-07-12 valida antes de deletar
If  _lDeleta
	lRet:=( findSc6(Z00->Z00_COD) )
	
	If !lRet
		Return lRet
	Endif
	
Endif

//If INCLUI .or. ALTERA
// Bruno Abrigo em 10/04/12
if nOpcBrw != 2 // tudo que for diferente de inclusao
	While _lOk
		U_TelaPSW(@_lOk,.F.)
		if !_lOk
			if MsgYesno("Tentar novamente ?")
				_lOk:=!_lOk
			Else
				Return .F.
			Endif
		Else
			_lOk:=!_lOk
		Endif
	Enddo
Endif
&& Bruno Abrigo em 26-03-2012 controle de inclusao por senha final

dbSelectArea("Z00")
Z00->(RegToMemory("Z00",nOpcBrw == 3))

//Monta o aHeader
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("Z01"))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "Z01"
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		Aadd(aHeader,	{	Trim(X3Titulo()),SX3->X3_CAMPO  ,SX3->X3_PICTURE,;
							SX3->X3_TAMANHO ,SX3->X3_DECIMAL,SX3->X3_VALID,;
							SX3->X3_USADO   ,SX3->X3_TIPO,	;
							SX3->X3_F3      ,SX3->X3_CONTEXT,SX3->X3_CBOX,,SX3->X3_WHEN,	;
							SX3->X3_VISUAL  ,SX3->X3_VLDUSER, SX3->X3_PICTVAR,SX3->X3_OBRIGAT	})
	EndIf
	
	SX3->(dbSkip())
EndDo

//Monta o aCols
dbSelectArea("Z01")
Z01->(dbSetOrder(1))
Z01->(dbSeek(xFilial("Z01")+M->Z00_COD ))
While Z01->(!Eof()) .And. Z01->Z01_FILIAL + Z01->Z01_COD == xFilial("Z01")+M->Z00_COD
	Aadd(aCols,Array(Len(aHeader)+1))
	For i := 1 To Len(aHeader)
		If aHeader[i,10] <> "V"
			aCols[Len(aCols)][i] := Z01->&(aHeader[i,2])
		Else
			aCols[Len(aCols)][i] := CriaVar(aHeader[i,2])
		EndIf
	Next i
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	Z01->(dbSkip())
EndDo

cCodigo:=Cvaltochar(Z00_COD)

If Len(aCols) <= 0
	Aadd(aCols,Array(Len(aHeader)+1))
	For i := 1 To Len(aHeader)
		aCols[Len(aCols)][i] := CriaVar(aHeader[i,2])
	Next i
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
EndIf

//Tela de apontamento Mensal
oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],OemToAnsi("Personaliza็ใo de Lacres"),,,,,,,,oMainWnd,.T.)
oEnchoice := MsMGet():New("Z00",Z00->(RecNo()),nOpcBrw,,,,,{030	,003,oDlgMain:nClientHeight/4,oDlgMain:nClientWidth/2-5},,3,,,,,,.T.)
oGetDados := MsNewGetDados():New(oDlgMain:nClientHeight/4+5,003          ,oDlgMain:nClientHeight/2-25 ,oDlgMain:nClientWidth/2-5,2    ,,,"",,,9999,,,,oDlgMain,aHeader,aCols)


@ -15,-15 BUTTON oBtn PROMPT "..." SIZE 1,1 PIXEL OF oDlgMain
Aadd( aButtons,{"Visualizar", {|| VISPDF(cCodigo,cParametro)}, "Visualizar...", "Visualizar PDF" })
//Aadd( aButtons,{"Alterar", {|| ALTPDF(cCodigo,cParametro)}, "Alterar...", "Alterar PDF" })

//oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| Iif(Obrigatorio(aGets,aTela), Iif (RFATTOK(), Iif(UPPDF(cCodigo,cParametro), (nOpcClick := 1, oDlgMain:End()),Nil),Nil ),(MsgAlert("Campos obrigatorios nใo preenchidos!","Aten็ใo: "+cUserName),.F. )/*(oDlgMain:End(),Nil)*/)  },{|| nOpcClick := 0,oDlgMain:End()},,@aButtons)})
oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| Iif(Obrigatorio(aGets,aTela), Iif (RFATTOK(), Iif(1==1, (nOpcClick := 1, oDlgMain:End()),Nil),Nil ),(MsgAlert("Campos obrigatorios nใo preenchidos!","Aten็ใo: "+cUserName),.F. )/*(oDlgMain:End(),Nil)*/)  },{|| nOpcClick := 0,oDlgMain:End()},,@aButtons)})

If nOpcClick == 1 .And. nOpcBrw <> 2
	dbSelectArea("Z00")
	dbSetOrder(1)
	iif(nOpcBrw<>3,Z00->(dbSeek(xFilial("Z00")+M->Z00_COD)),.T.)    // Bruno Abrigo em 16.05.12 erro de rollback
	Z00->(RecLock("Z00",nOpcBrw == 3))
	
	If nOpcBrw == 3
		ConfirmSX8("Z00","Z00_COD")  // Bruno ABrigo em 25/04/12
	EndIf
	
	If nOpcBrw <> 5
		Z00->Z00_FILIAL := xFilial("Z00")
		For j := 1 To Len(oEnchoice:aGets)
			If Posicione("SX3",2,AllTrim(SubStr(oEnchoice:aGets[j],9,10)),"SX3->X3_CONTEXT") <> "V"
				Z00->&(SubStr(oEnchoice:aGets[j],9,10)) := M->&(SubStr(oEnchoice:aGets[j],9,10))
			EndIf
		Next j
		Z00->(MsUnlock())
	Else
		dbSelectArea("Z01")
		Z01->(dbSetOrder(1))
		Z01->(dbSeek(xFilial("Z01")+Z00->Z00_COD ))
		While Z01->(!Eof()) .And. Z01->Z01_FILIAL + Z01->Z01_COD == xFilial("Z01")+Z00->Z00_COD
			Z01->(RecLock("Z01",.F.))
			Z01->(dbDelete())
			Z01->(MsUnlock())
			Z01->(dbSkip())
		EndDo
		
		Z00->(RecLock("Z00",.F.))
		Z00->(dbDelete())
		Z00->(MsUnlock())
	EndIf
EndIf

If nOpcClick == 0 .And. nOpcBrw == 3
   	Z00->(RollBackSX8())
EndIf


Return(Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA010  บAutor  Jonas Gouveia          Data ณ  17/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar permitir validar os dados antes de      บฑฑ
ฑฑบ          ณincluir ou alterar dados                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RFATTOK()

Local lRet:= .T.
//Validacao da qtd de caracteres do numero inicial do lacre
If LEN(cValtoChar(M->Z00_LACINI)) >  M->Z00_TMLACR
	MsgStop("A quantidade mแxima de caracteres para o lacre incial estแ invแlida, por favor verifique." )
	lRet:= .F.
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPPDF     บAutor  OscaR Alderete         Data ณ  18/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada, para validar as informa็๕es de tela referentesบฑฑ
ฑฑบ          ณao upload de arquivo e chamar as fun็๕es auxiliares         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function UPPDF(cCodigo,cParametro)

Local lRet:=.T.
&&if INCLUI .or. ALTERA   && Bruno Abrigo em 19\03\2012

if M->Z00_TPPERS == "3" && Bruno Abrigo em 19\02\2012
	lRet:= .T.
	Return lRet
Endif
If M->Z00_TPPERS$('1').or.M->Z00_TPPERS$('2')
	lRet:=File(cParametro+"\"+cCodigo+".pdf")
	If lRet==.T.
		IF msgyesno("Desenho T้cnico jแ Existe, Deseja Visualizar?","Desenho T้cnico")
			VISPDF(cCodigo,cParametro)
		Else&& Bruno Abrigo em 19\02\2012
			lRet:= .T.
			Return lRet
		EndIf
	Else
		while lRet==.F.
			msgstop("Favor incluir o Desenho T้cnico","Desenho T้cnico")
			U_UPPPD(cCodigo,cParametro)
			lRet:=File(cParametro+"\"+cCodigo+".pdf")
		End
	EndIF
Else
	File(cParametro+"\"+cCodigo+".pdf", 1 ,.T.)
	If lRet==.T.
		If msgyesno("Desenho T้cnico jแ Existe, Deseja Visualizar?","Desenho T้cnico")
			VISPDF(cCodigo,cParametro)
		Else&& Bruno Abrigo em 19\02\2012
			lRet:= .T.
			Return lRet
		EndIf
	Else
		if msgyesno("Deseja Incluir o Desenho T้cnico","Desenho T้cnico")
			U_UPPPD(cCodigo,cParametro)
		Else&& Bruno Abrigo em 19\02\2012
			lRet:= .T.
			Return lRet
		Endif
	EndIf
Endif
&&Endif
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPPPDF   บAutor  OscaR Alderete         Data ณ  18/01/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada, para realizar o upload de arquivos para o    บฑฑ
ฑฑบ          ณservidor, nele ้ chamada a fun็ใo auxiliar de visuliza็ใo   บฑฑ
ฑฑบ			 ณdo arquivo	   											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UPPPD(cCodigo,cParametro)

Local cArq:= ""
Local cArq1:= ""
Local cArq2:= ""
Local cGetFile
Local lRet:=.T.


cArq:= cGetFile ( 'PDF|*.pdf|' , 'Desenho t้cnico', 1, 'C:\', .F., GETF_LOCALHARD + GETF_LOCALFLOPPY, .T.)

//Altera o nome do arquivo original pelo codigo de personaliza็ใo
cArq1:=Left(cArq,Len(cArq)-4)+cCodigo+".pdf"
//cArq2:="c:\"+cCodigo
__COPYFILE(cArq,cArq1)//faz copia do arquivo, para que o original permane็a no local de origem
//Frename(cArq1,cArq2+".pdf")
//Grava o arquivo no Servidor
CpyT2S( cArq1, cParametro, .T. )
//Deleta o arquivo gerado temporariamente para mudan็a de nome
//Ferase(cArq2+".pdf")
Ferase(cArq1)

If Msgyesno("Deseja visualizar Arquivo anexado?")
	VisPDF(CCodigo,cParametro)//Fun็ใo de Visualiza็๕
Else && Bruno Abrigo em 19\03\2012
	lRet:=.T.
	Return lRet
Endif

lRet:=File(cParametro+"\"+cCodigo+".pdf")

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVISPDF   บAutor  OscaR Alderete         Data ณ  19/01/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada, para visualiza็ใo do arquivo anexado e salvo บฑฑ
ฑฑบ          ณno servidor   									          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisPDF(CCodigo,cParametro)

Local cArq :=""
Local cArq1:=""
Local lRet:=.T.

cArq := AllTrim(M->Z00_DESC1)
lRet:=FILE(cArq) // Verifica no diret๓rio Desenhos T้cnicos do servidor se existe o arquivo buscado.pdf
If lRet==.T.
	shellExecute( "Open", cArq, " /k dir", "C:\", 1 ) //executa o programa para leitura do arquivo copiado
Else
	Alert("Arquivo " + cArq + " Nใo Localizado !!!")
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVISPDF   บAutor  OscaR Alderete         Data ณ  19/01/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada, para altera็ใo do arquivo anexado e salvo    บฑฑ
ฑฑบ          ณno servidor   									          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltPDF(CCodigo,cParametro)

Local cArq:= ""
Local cArq1:= ""
Local cArq2:= ""
Local cGetFile
Local lRet:= .T.

//FErase(cParametro+"\"+cCodigo+".pdf")

cArq:= cGetFile ( 'PDF|*.pdf|' , 'Desenho t้cnico', 1, 'C:\', .F., GETF_LOCALHARD + GETF_LOCALFLOPPY, .T.)

//Altera o nome do arquivo original pelo codigo de personaliza็ใo
cArq1:=Left(cArq,Len(cArq)-4)+cCodigo+".pdf"
//cArq2:="c:\temp\"+cCodigo
__COPYFILE(cArq,cArq1)//faz copia do arquivo, para que o original permane็a no local de origem
//Frename(cArq1,cArq2+".pdf")
//Grava o arquivo no Servidor
CpyT2S( cArq1, cParametro, .T. )
//Deleta o arquivo gerado temporariamente para mudan็a de nome
Ferase(cArq1)

If Msgyesno("Deseja visualizar Arquivo anexado?")
	VisPDF(CCodigo,cParametro)
Else  && Bruno Abrigo em 19\03\2012
	Return
Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CriaSX6  บAutor  ณBruno Abrigo        บ Data ณ  03/26/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Cria parametro de senha                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _CriaSX6()

DbSelectArea("SX6")
SX6->(dbsetOrder(1))
If !SX6->(DbSeek("  MV_METPSSW"))
	RecLock("SX6",.T.)
	SX6->X6_VAR     := "MV_METPSSW"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Senha p\ grupo de usuarios autorizdos."
	SX6->X6_DESC1   := "Serao considerados para efeito de incluir\alterar 	 "
	SX6->X6_DESC2   := "somente c\ a senha abaixo serใo incluidos\alterados Lacre"
	SX6->X6_CONTEUD := "admin"
	SX6->X6_CONTSPA := "admin"
	SX6->X6_CONTENG := "admin"
	SX6->(MsUnLock())
Endif


If !SX6->(DbSeek("  MV_METUSER"))
	RecLock("SX6",.T.)
	SX6->X6_VAR     := "MV_METUSER"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "User p\ autorizados."
	SX6->X6_DESC1   := "Serao considerados para efeito de incluir\alterar"
	SX6->X6_DESC2   := "somente c\ o user abaixo serใo incluidos\alterados Lacre"
	SX6->X6_CONTEUD := "Administrador;mariana;totalsiga"
	SX6->X6_CONTSPA := "admin"
	SX6->X6_CONTENG := "admin"
	SX6->(MsUnLock())
Endif

Return


// Dialog Principal


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaSenha บAutor  ณBruno Abrigo        บ Data ณ  26/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria tela para digitar senha                                บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TelaPS(_lOk,lEdit)

Local _cUsuario	 := cUserName
Local _cSenha 	 := Space(6)
Local cGet3 	 := Space(6)
Local oGet1
Local oGet2
Local oGet3
//local lsair:=.F.// Bruno Abrigo em 10/04/12
// Variaveis Private da Funcao
Local oDlg

&& Cria\Valida Parametros
_CriaSX6()

_lOk:=.F.

if lEdit
	DEFINE MSDIALOG oDlg TITLE "Logon" FROM 178,181 TO 350,410 PIXEL
Else
	DEFINE MSDIALOG oDlg TITLE "Logon" FROM 178,181 TO 285,410 PIXEL
Endif
oDlg:lEscClose := .F. //Nใo permite sair ao usuario se precionar o ESC

//	@80,10 MsGet oSen Var cSen Picture "@S40" Valid .T.  PASSWORD Pixel of oDlg
// Cria Componentes Padroes do Sistema
@  001, 002 Say "Nome:" Size  018, 008 COLOR CLR_BLACK PIXEL OF oDlg
@  010, 002 MsGet oGet1 Var _cUsuario when .f. Size  084, 009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

if lEdit
	@  025, 002 Say "Senha Atual:" Size 060	, 030 COLOR CLR_BLACK PIXEL OF oDlg
	@  032, 002 MsGet oGet2 Var _cSenha Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  055, 002 Say "Nova Senha:" Size  060, 030 COLOR CLR_BLACK PIXEL OF oDlg
	@  062, 002 MsGet oGet3 Var cGet3 Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  010, 091 Button "OK" Size  023, 012 PIXEL OF oDlg;
	Action(ValidaSenha(_cUsuario,_cSenha,@_lOk,lEdit,cGet3),oDlg:End())
	
	@  032, 091 Button "Cancelar" Size  023, 012 PIXEL OF oDlg;
	Action( Alert("Cancelado pelo administrador!","Aten็ใo"),oDlg:End())
	
Else
	
	@  025, 002 Say "Senha:" Size  018, 007 COLOR CLR_BLACK PIXEL OF oDlg
	@  032, 002 MsGet oGet2 Var _cSenha Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  010, 091 Button "OK" Size  023, 012 PIXEL OF oDlg;
	Action(ValidaSenha(_cUsuario,_cSenha,@_lOk,lEdit),oDlg:End())
	
	@  032, 091 Button "Cancelar" Size  023, 012 PIXEL OF oDlg;
	Action( Alert("Cancelado pelo administrador!","Aten็ใo"),_lOk:=.F.,oDlg:End())
	
	
Endif


ACTIVATE MSDIALOG oDlg CENTERED

// Bruno abrigo em 10/04/12
Return(_lOk)

//	lSair:=.F.
//	Return(u_TelaPSW(_lOk,lEdit))
//Endif

/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บDesc      ณ Valida senha e Usuario   Bruno Abrigo em 26-03-2012        บ
ศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidaSenha( xcUsuario, xcSenha,_lOk,lEdit ,cGet3)

Local cSenhax_ := GetMv("MV_METPSSW")
Local cUserx_  :=GetMv("MV_METUSER")
Local _axUser:={}

if lEdit
	_axUser:=Separa( cUserx_,";",.T.)
	
	For i:=1 to Len(_axUser)
		If _axUser[i] == xcUsuario .and.  Alltrim(xcSenha)  == Alltrim(cSenhax_)
			
			DbSelectArea("SX6")
			SX6->(dbsetOrder(1))
			If SX6->(DbSeek("  MV_METPSSW"))
				RecLock("SX6",.F.)
				SX6->X6_VAR     := "MV_METPSSW"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "Senha p\ grupo de usuarios autorizdos."
				SX6->X6_DESC1   := "Serao considerados para efeito de incluir\alterar 	 "
				SX6->X6_DESC2   := "somente c\ a senha abaixo serใo incluidos\alterados Lacre"
				SX6->X6_CONTEUD := cGet3
				SX6->X6_CONTSPA := cGet3
				SX6->X6_CONTENG := cGet3
				SX6->(MsUnLock())
			Endif
			
			MsgInfo("Senha alterada com sucesso!")
			_lOk:=.T.
			Return _lOk
		Endif
	Next i
	
	Alert("Senha atual invแlida! ou Usuario sem permissใo para altera็ใo!","Aten็ใo")
	_lOk:=.F.
	Return _lOk
	
Else
	
	IF Alltrim(xcSenha)  == Alltrim(cSenhax_)
		_lOk:=.T.
		Return _lOk
	Else
		&&	Final( cMensag1, cMensag2 )
		Alert("Senha invแlida!","Aten็ใo")
		_lOk:=.F.
		Return _lOk
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfindSc6  บAutor  ณBruno Abrigo         บ Data ณ  07/30/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se existe algum registro no item do Pedido        บฑฑ
ฑฑบ          ณ antes de deletar                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function findSc6(cCodDel)
Local cQry := ""
Local lRet

cQry := " SELECT C6_NUM 'DOC',C6_ENTREG 'DTA',C6_PRODUTO,C6_ITEM 'ITEM' FROM " + RetSqlName("SC6") + " WITH(NOLOCK) "+CRLF
cQry += "  WHERE D_E_L_E_T_ <> '*' AND C6_XLACRE = '"+cCodDel+"'" +CRLF
cQry += "  GROUP BY C6_NUM ,C6_ENTREG ,C6_PRODUTO,C6_ITEM "+CRLF

TcQuery cQry New Alias "DEL"

dbSelectArea("DEL")
DEL->(DbGotop())

If !DEL->(Eof())
	
	If MsgYesno("Existe(em) Pedido(s) ativo(s) relacionado(s) a esta Personaliza็ใo, serแ necessแrio excluir o(s) Pedido(s) antes de prosseguir! Deseja visualizar o log ?")
		
		DEFINE DIALOG oDlg TITLE "Log Itens Pedidos" FROM 180,180 TO 550,700 PIXEL
		
		oBrowse := MsSelBr():New( 1,1,260,184,,,,oDlg,,,,,,,,,,,'Log de Erros',.F.,"DEL",.T.,,.T.,,, )
		                                
		oBrowse:AddColumn(TCColumn():New('Nบ Pedido',{|| DEL->DOC },,,,'LEFT',,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New('Data Pedido'  ,{|| cValtochar(Date(DEL->DTA)) },,,,'LEFT',,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New('Item Pedido'  ,{|| DEL->ITEM},,,,'LEFT',,.F.,.F.,,,,.F.,))
		
		oBrowse:lHasMark := .T.    
		oBrowse:bAllMark := {|| alert('Para sair aperte Esc'), oBrowse:Refresh() }
		
		ACTIVATE DIALOG oDlg CENTERED
	Endif
	lRet:=.F.
Else
	lRet:=.T.
Endif

DEL->(DbCloseArea())
Return lRet 


//--------------------------------------------------------------
/*/{Protheus.doc} PerxCli
Description

@Tela criada para permitir ao usuแrio relaizar a amarra็ใo 
	entre Personaliza็ใo e Cliente
@return xRet Return Description
@author Oscar - oscar@totalsiga.com.br
@since 20/01/2012
/*/
//--------------------------------------------------------------

User Function PerxCliX()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z02"

dbSelectArea("Z02")
dbSetOrder(1)

AxCadastro(cString,"Amarra็ใo de Person. x Cliente",cVldExc,cVldAlt)

Return lRet:= .T. 
 

User Function AXCADSA()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cPerg   := "1"
Private cCadastro := "Tabela Produtos & Cliente"
Private aRotina := { {"Pesquisar" ,"AxPesqui",0,1} ,;
		             {"Visualizar","AxVisual",0,2} ,;
        		     {"Incluir"   ,"AxInclui",0,3} ,;
		             {"Alterar"   ,"AxAltera",0,4} ,;
        		     {"Excluir"   ,"AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SA7"

dbSelectArea("SA7")
dbSetOrder(1)

cPerg   := "1"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return



//--------------------------------------------------------------
/*/{Protheus.doc} MdStatAt
Description

@Tela criada para permitir ao usuแrio mudar status de or็amentos
cancelados para outro tipo de ocorrencia
apenas or็amentos cancelados que nใo geraram pedido de vendas
@return xRet Return Description
@author Luiz Alberto
@since 02/06/2015
/*/
//--------------------------------------------------------------

User Function MDSTATAT()
Local aArea := GetArea()
Local cMotivo	:= 	MSMM(SUA->UA_CODCANC,TamSx3("UA_OBSCANC")[1])
Local cCodMot	:=	Space(06)
Local lSai		:=  .f.
Local oDlg
Local cLibUser  :=	GetNewPar('MV_USLBCTR','000000*000001*000020*000033*000194*000012')
Private cDesMot	:= ''

If !__cUserId$cLibUser
	MsgStop("Aten็ใo Usuแrio Nใo Autorizado a Efetuar Mudan็a de Status de Atendimento !")
	RestArea(aArea)
	Return .f.     
Endif                  

SUA->(dbSetOrder(1), dbSeek(xFilial("SUA")+M->UA_NUM))
If SUA->UA_NUM <> M->UA_NUM
	Return .f.
Endif       

If SUA->UA_OPER <> '2'
	MsgStop("Aten็ใo Apenas Or็amentos Poderใo ter Seu Status Modificado !")
	Return .f.
Endif

If SUA->UA_STATUS <> 'CAN'
	MsgStop("Aten็ใo Apenas Or็amentos Cancelados Poderใo ter Seu Status Modificado !")
	Return .f.
Endif

While !lSai

	@ 270,100 To 414,650 Dialog oDlg Title OemToAnsi("MOTIVO DO CANCELAMENTO")
	@ 005,005 Say OemToAnsi("Motivo:") Size 050,030 PIXEL Of oDlg
	@ 005,050 Get cMotivo MEMO Size 200,025 PIXEL Of oDlg
	@ 033,005 Say OemToAnsi("Ocorr๊ncia:") Size 050,030 PIXEL Of oDlg
	@ 033,050 MsGet oCodMot Var cCodMot F3 "SU9F" Valid(Empty(cCodMot) .Or. fMot(cCodMot,@cDesMot)) Size 030,010 PIXEL Of oDlg
	@ 033,100 MsGet oDesMot Var cDesMot When .f. Size 100,010 PIXEL Of oDlg

	@ 050,015 Button Oemtoansi("Confirma") Size 036,016 Action (lSai:=.t.,Close(oDlg)) PIXEL Of oDlg
	@ 050,075 Button OemToAnsi("Sair")   Size 036,016 Action (lSai:=.t.,oDlg:End(),Close(oDlg)) PIXEL Of oDlg
						
	ACTIVATE DIALOG oDlg CENTERED
Enddo
	
If !Empty(cMotivo) .And. !Empty(cCodMot)
	If SUA->(dbSetOrder(1), dbSeek(xFilial("SUA")+M->UA_NUM))
		If RecLock("SUA",.F.)
//			SUA->UA_CANC	:= "S"
//			SUA->UA_STATUS 	:= "CAN"
			SUA->UA_CODLIG	:= cCodMot
//			SUA->UA_DTCANC	:= dDataBase
			MSMM(,TamSx3("UA_OBSCANC")[1],,cMotivo,1,,,"SUA","UA_CODCANC")
			MsUnlock()
		Endif
	Endif
	RestArea(aArea)
	Return .t.
Else                                   
	Alert("Para Mudan็a de Status ้ Necessแrio Informar, Motivo e C๓digo da Ocorr๊ncia !")
	RestArea(aArea)
	Return .f.
Endif
RestArea(aArea)
Return(.t.)



Static Function fMot(cCodMot)
If !SU9->(dbSetOrder(2), dbSeek(xFilial("SU9")+cCodMot))
	Alert("Aten็ใo C๓digo de Motivo Nใo Localizado !!!")
	Return .f.
Else
	If !(SU9->U9_VALIDO=='1' .And. SU9->U9_TIPOATE $'2*4')
		Alert("Aten็ใo C๓digo de Motivo Invแlido !")
		Return .f.
	Endif
	cDesMot	:= SU9->U9_DESC
	oDesMot:Refresh()
Endif
Return .t.
	