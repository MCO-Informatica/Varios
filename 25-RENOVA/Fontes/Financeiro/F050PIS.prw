#INCLUDE "rwmake.ch"

User Function F050PIS
Local nRegSE2 := M->PARAMIXB  
Local _cTipPCC := Alltrim(GETMV("MV_BX10925")) //1-Baixa /\ 2-Emiss�o

U_RnGrHist(nRegSE2,"PIS")

If _cTipPCC = '1'  
	U_ATUSE2IMP(nRegSE2)
EndIf

Return

/*/
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para gravar Hist�rico                    o���
���          � de acordo com o t�tulo principal.                          ���
�����������������������������������������������������������������������������
/*/
User Function RnGrHist(nRegSE2, cImp)
Local nRegOri  := SE2->(Recno())
Local cHist    := Nil
Local nNomeFor := Nil
Local _cAPROVA,_dDATALIB,_cSTATLIB,_cUSUALIB,_cCODAPRO,_cXRJ  // - vari�veis para tratamento de RJ       

// - Par�metro para indicar o Gestor para libera��o do t�tulo
Local _cLiber := GetNewPar( "MV_FINALAP", "000001") 

SE2->(dbGoto(nRegSE2))  // Posiciono no titulo original

//If SE2->E2_ORIGEM ="FINA050" .Or. SE2->E2_ORIGEM ="FINA080"

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
nNomeFor := Posicione("SA2", 1, xFilial("SA2") + SE2->(E2_FORNECE+E2_LOJA), "A2_NREDUZ")
cHist    := Alltrim(cImp) + " S/NF " + Alltrim(SE2->E2_NUM) + " " + nNomeFor

SE2->(dbGoto(nRegOri))
Reclock("SE2", .F.)
SE2->E2_HIST   := cHist
SE2->E2_NOMFOR := nNomeFor
Msunlock()

//Endif

Return
