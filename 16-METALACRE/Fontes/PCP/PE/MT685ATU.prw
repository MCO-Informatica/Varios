//FONTE COM PROBLEMA....
#include 'Protheus.ch'
#INCLUDE "TopConn.ch"  
#INCLUDE "RWMAKE.CH" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT685ATU  บ Autor ณMateus Hengle       บ Data ณ 19/02/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณPE que grava o saldo atualizado na tabela SD7 - CQ		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAjuste    ณ 													          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT685ATU() 

Local nPosProd := AScan(aHeader,{|x| AllTrim(x[2]) == "BC_PRODUTO" })
Local nPosLote := AScan(aHeader,{|x| AllTrim(x[2]) == "BC_LOTECTL" })
Local cProd    := aCols[n,nPosProd]
Local cLote    := aCols[n,nPosLote]

cQry:= " SELECT DISTINCT B8_SALDO"
cQry+= " FROM "+RETSQLNAME("SB8")+" SB8"
cQry+= " WHERE B8_PRODUTO = '"+cProd+"' "  // PEGA O SALDO CORRETO ATUALIZADO NA SB8
cQry+= " AND B8_LOTECTL = '"+cLote+"' "
cQry+= " AND B8_SALDO <> '0' "
cQry+= " AND SB8.D_E_L_E_T_='' " 

If Select("TRZ") > 0
	TRZ->(dbCloseArea())
EndIf

TCQUERY cQry New Alias "TRZ"    
cQuant := TRZ->B8_SALDO

DBSELECTAREA("SD7")
DBSETORDER(4)
IF DBSEEK(XFILIAL("SD7") + cLote + cProd)	// GRAVA O SALDO CORRETO NA TABELA SD7 
	RecLock("SD7",.F.)
	SD7->D7_SALDO   := cQuant
	SD7->(MsUnlock())        						
ENDIF  

RETURN	