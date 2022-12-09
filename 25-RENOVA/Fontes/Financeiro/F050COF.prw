#INCLUDE "rwmake.ch"

User Function F050COF()
Local nRegSE2 := M->PARAMIXB
Local _cTipPCC := Alltrim(GETMV("MV_BX10925")) //1-Baixa /\ 2-Emiss�o
Local _cAPROVA,_dDATALIB,_cSTATLIB,_cUSUALIB,_cCODAPRO,_cXRJ  // - vari�veis para tratamento de RJ       

// - Par�metro para indicar o Gestor para libera��o do t�tulo
Local _cLiber := GetNewPar( "MV_FINALAP", "000001") 

U_RnGrHist(nRegSE2, "COF")

If _cTipPCC = '1'  
	U_ATUSE2IMP(nRegSE2)
EndIf

// Atribui��o para os campos referentes a Recupera��o Judicial
// Se posterior a RJ (16/10/2019) grava o t�tulo Liberado
//if SE2->E2_EMISSAO > CtoD("16/10/2019")
	_cAPROVA  := ""
	_dDATALIB := dDataBase
	_cSTATLIB := "03"
	_cUSUALIB := "INC POSTERIOR REC JUDIC  "
	_cCODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse c�digo de liberador
	_cXRJ     := ""
//comentado a pedido do Diego para que o imposto sempre fique liberado 26/02/2021 - Andr� Couto
/*
else
	_cAPROVA  := ""
	_dDATALIB := CtoD("  /  /    ")
	_cSTATLIB := ""
	_cUSUALIB := ""
	_cCODAPRO := _cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para libera��o
	_cXRJ     := "S"
endif
*/
Return nil
