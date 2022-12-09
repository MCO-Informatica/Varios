#INCLUDE "rwmake.ch"                                                                                                                                     
#INCLUDE "protheus.ch"
#Define CRLF ( chr(13)+chr(10) )

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

user Function CargaGrp(cGrupo, dDataIni, dDataFim,cProdini,cProdfim)

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

If cGrupo=="612" .or. cGrupo=="613"

	cqrycarga+= " 		AND (BM_GRUPO='612' OR BM_GRUPO='613') " +CRLF

ElseIf cGrupo=="605" .or. cGrupo=="617"

	cqrycarga+= " 		AND (BM_GRUPO='605' OR BM_GRUPO='617') " +CRLF

ElseIf cGrupo=="620" .or. cGrupo=="621"

	cqrycarga+= " 		AND (BM_GRUPO='620' OR BM_GRUPO='621') " +CRLF
Else

	cqrycarga+= " 		AND BM_GRUPO='"+cGrupo+"'  " +CRLF  

EndIf
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

If cGrupo=="612" .or. cGrupo=="613"

	cqrycarga+= " 		AND (BM_GRUPO='612' OR BM_GRUPO='613') " +CRLF

ElseIf cGrupo=="605" .or. cGrupo=="617"

	cqrycarga+= " 		AND (BM_GRUPO='605' OR BM_GRUPO='617') " +CRLF

ElseIf cGrupo=="620" .or. cGrupo=="621"

	cqrycarga+= " 		AND (BM_GRUPO='620' OR BM_GRUPO='621') " +CRLF

Else

	cqrycarga+= " 		AND BM_GRUPO='"+cGrupo+"'  " +CRLF  

EndIf
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

