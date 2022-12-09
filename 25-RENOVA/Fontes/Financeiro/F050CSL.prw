#INCLUDE "rwmake.ch"

User Function F050CSL()
Local nRegSE2 := M->PARAMIXB
Local _cTipPCC := Alltrim(GETMV("MV_BX10925")) //1-Baixa /\ 2-Emissão
Local _cAPROVA,_dDATALIB,_cSTATLIB,_cUSUALIB,_cCODAPRO,_cXRJ  // - variáveis para tratamento de RJ 

// - Parâmetro para indicar o Gestor para liberação do título
Local _cLiber := GetNewPar( "MV_FINALAP", "000001") 

U_RnGrHist(nRegSE2, "CSLL")  

// Atribuição para os campos referentes a Recuperação Judicial
// Se posterior a RJ (16/10/2019) grava o título Liberado
//if SE2->E2_EMISSAO > CtoD("16/10/2019")
	_cAPROVA  := ""
	_dDATALIB := dDataBase
	_cSTATLIB := "03"
	_cUSUALIB := "INC POSTERIOR REC JUDIC  "
	_cCODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse código de liberador
	_cXRJ     := ""
//comentado a pedido do Diego para que o imposto sempre fique liberado 26/02/2021 - André Couto
/*
else
	_cAPROVA  := ""
	_dDATALIB := CtoD("  /  /    ")
	_cSTATLIB := ""
	_cUSUALIB := ""
	_cCODAPRO := _cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para liberação
	_cXRJ     := "S"
endif
*/
If _cTipPCC = '1'  
	U_ATUSE2IMP(nRegSE2)
EndIf

Return
