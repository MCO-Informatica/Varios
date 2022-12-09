#include "rwmake.ch"  
#include "TopConn.ch"     


User Function M030PALT()
Local nOpcao	:= PARAMIXB[1]
Local lRet	 	:= .T. 
Local _cVends   := ""

If nOpcao == 1	
	_cVends := U_vAtuCliZ12(SA1->A1_COD,SA1->A1_LOJA,SA1->A1_REGIAO, SA1->A1_GRPVEN) 
	DbSelectArea("SA1");DbSetOrder(1)
	If SA1->(DbSeek(xFilial("SA1")+SA1->(A1_COD+A1_LOJA)))
		RecLock("SA1",.F.)
			SA1->A1_VQ_VEND := _cVends
		MsUnlock()
	End
EndIf

Return lRet    


User Function vAtuCliZ12(_cCodCli, _cCodLoj, _cCodReg, _cCodGrp)
Local _cRet 	:= ""
Local _cQuery 	:= ""      

_cQuery 	:= " SELECT "
_cQuery 	+= " 	Z12.Z12_COD "
_cQuery 	+= " FROM " + RetSqlName("SA1") + " SA1 " 
_cQuery 	+= " 	INNER JOIN " + RetSqlName("Z12") + " Z12 "
_cQuery 	+= " 		ON (Z12.Z12_REGIAO+Z12.Z12_GRUPO = SA1.A1_REGIAO+SA1.A1_GRPVEN)"
_cQuery 	+= " WHERE	"   
_cQuery 	+= " 	Z12.D_E_L_E_T_ <> '*' "
_cQuery 	+= " 	AND Z12.Z12_REGIAO+Z12.Z12_GRUPO = '"+AllTrim(_cCodReg)+AllTrim(_cCodGrp)+"'"
_cQuery 	+= " 	AND SA1.A1_COD+SA1.A1_LOJA = '"+AllTrim(_cCodCli)+AllTrim(_cCodLoj)+"'"

If Select("TMPSA1A") > 0
	TMPSA1A->(DbCloseArea())
EndIf
TcQuery _cQuery New Alias "TMPSA1A"
Dbselectarea("TMPSA1A")  
	
While !TMPSA1A->(Eof())  
	_cRet += AllTrim(TMPSA1A->Z12_COD) + "/"
	TMPSA1A->(DbSkip())    
EndDo			                                                                                                         
TMPSA1A->(MsUnlock())   

Return(_cRet)
