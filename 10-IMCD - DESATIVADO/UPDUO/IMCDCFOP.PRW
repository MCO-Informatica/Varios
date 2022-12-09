#include "Totvs.ch"
#include "Tbiconn.ch"
#INCLUDE "protheus.ch"


USER FUNCTION IMCDCFOP()

Local _cTes		:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_TES"   })]
Local _aDadosCfo:= {}
DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+_cTes,.f.)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.f.)

Aadd(_aDadosCfo,{"OPERNF","S"})
Aadd(_aDadosCfo,{"TPCLIFOR",SA1->A1_TIPO})
Aadd(_aDadosCfo,{"UFDEST",SA1->A1_EST})
Aadd(_aDadosCfo,{"INSCR", SA1->A1_INSCR})
MaFisCfo(,SF4->F4_CF,_aDadosCfo)
_cCfop := MaFisCfo(,SF4->F4_CF,_aDadosCfo)
 			
Return(_cCfop)	
