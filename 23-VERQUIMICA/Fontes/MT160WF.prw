
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT160WF  �Autor� Danilo Alves Del Busso� Data �  27/01/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Exibir os n�meros de pedidos gerados durante a analise de  ���
��			 � cota��o.                                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


#include "rwmake.ch"
#include "protheus.ch"  

#DEFINE CRLF CHR(13)+CHR(10)

User Function MT160WF()

Local nCotacao 		:= PARAMIXB[1]
Local cMensag    	:= CRLF + "Anote o n�mero dos Pedidos" + CRLF
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