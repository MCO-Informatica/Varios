#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PZCVA001 ºAutor  ³Microsiga 	          º Data ³ 05/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina utilizada para atualizar quantidade do lote		  º±±
±±º          ³bloqueado										    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PZCVA001(cProdDe, cProdAte, cLocalDe, cLocalAte, cLoteDe, cLoteAte, cSubLDe, cSubLAte )

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local nCnt		:= 0

Default cProdDe		:= "" 
Default cProdAte	:= "" 
Default cLocalDe	:= "" 
Default cLocalAte	:= "" 
Default cLoteDe		:= "" 
Default cLoteAte	:= "" 
Default cSubLDe		:= "" 
Default cSubLAte	:= ""	

cQuery	:= " SELECT DD_PRODUTO, DD_LOCAL, DD_LOTECTL, DD_NUMLOTE, SUM(DD_SALDO) DD_SALDO FROM "+RetSqlName("SDD")+" SDD "
cQuery	+= " WHERE SDD.DD_FILIAL = '"+xFilial("SDD")+"' "
cQuery	+= " AND SDD.DD_PRODUTO BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "
cQuery	+= " AND SDD.DD_LOCAL BETWEEN '"+cLocalDe+"' AND '"+cLocalAte+"' "
cQuery	+= " AND SDD.DD_LOTECTL BETWEEN '"+cLoteDe+"' AND '"+cLoteAte+"' "
cQuery	+= " AND SDD.DD_NUMLOTE  BETWEEN '"+cSubLDe+"' AND '"+cSubLAte+"' "
cQuery	+= " AND SDD.D_E_L_E_T_ = ' ' "
cQuery	+= " GROUP BY DD_PRODUTO, DD_LOCAL, DD_LOTECTL, DD_NUMLOTE "

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

(cArqTmp)->( DbGoTop() )
(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
(cArqTmp)->( DbGoTop() )

ProcRegua(nCnt)

While (cArqTmp)->(!Eof())
	
	IncProc("Processando...")
	
	//Atualização do saldo bloqueado por lote
	AtuBlqSb8((cArqTmp)->DD_PRODUTO, (cArqTmp)->DD_LOCAL, (cArqTmp)->DD_LOTECTL, (cArqTmp)->DD_NUMLOTE, (cArqTmp)->DD_SALDO )
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuBlqSb8 ºAutor  ³Microsiga 	          º Data ³ 05/12/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza bloqueio na tabela SB8							  º±±
±±º          ³												    		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function AtuBlqSb8(cProd, cLocal, cLote, cSubL, nSldBlq )

Local aArea 	:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()

Default cProd	:= "" 
Default cLocal	:= "" 
Default cLote	:= "" 
Default cSubL	:= ""
Default nSldBlq	:= 0

cQuery	:= " SELECT R_E_C_N_O_ RECSB8 FROM "+RetSqlName("SB8")+" SB8 "
cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "
cQuery	+= " AND SB8.B8_PRODUTO = '"+cProd+"' "
cQuery	+= " AND SB8.B8_LOCAL = '"+cLocal+"' "
cQuery	+= " AND SB8.B8_LOTECTL = '"+cLote+"' "
cQuery	+= " AND SB8.B8_NUMLOTE = '"+cSubL+"' " 
cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

DbSelectArea("SB8")
DbSetOrder(1)
While (cArqTmp)->(!Eof()) 
	
	SB8->(DbGoTo((cArqTmp)->RECSB8))
	
	RecLock("SB8",.F.)
	SB8->B8_YQBLQLT := nSldBlq
	SB8->B8_YEMPOP	:= SB8->B8_EMPENHO - nSldBlq
	SB8->(MsUnLock())
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return
