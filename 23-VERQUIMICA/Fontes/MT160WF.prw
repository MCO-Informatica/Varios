
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160WF  ºAutorº Danilo Alves Del Bussoº Data ³  27/01/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibir os números de pedidos gerados durante a analise de  º±±
±±			 ³ cotação.                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


#include "rwmake.ch"
#include "protheus.ch"  

#DEFINE CRLF CHR(13)+CHR(10)

User Function MT160WF()

Local nCotacao 		:= PARAMIXB[1]
Local cMensag    	:= CRLF + "Anote o número dos Pedidos" + CRLF
Local cTitulo 		:= "Pedidos Gerados: " + CRLF
Local lTemPedidos 	:= .F.       
Local cIdUser 		:= RetCodUsr()
Local cUserCot 		:= AllTrim(UsrFullName(RetCodUsr()))
                             
cQuery :=" SELECT DISTINCT C8_NUMPED"
cQuery +=" FROM "+RetSqlName("SC8")+" A, "+RetSqlName("SC7")+" B WHERE A.C8_NUMPED = B.C7_NUM AND C8_NUM='"+nCotacao+"'"
cQuery +=" GROUP BY C8_NUMPED"
cQuery +=" ORDER BY C8_NUMPED ASC"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP",.T.,.F.)

	While TMP->(!Eof())
    	If (Trim(TMP->C8_NUMPED) <> 'XXXXXX')
        	cMensag := cMensag + TMP->C8_NUMPED + CRLF
     	EndIf
        lTemPedidos := .T.
        TMP->(dbSkip())
 	Enddo

DbCloseArea()

If lTemPedidos
	MsgInfo(cMensag, cTitulo)
EndIf           


Return()