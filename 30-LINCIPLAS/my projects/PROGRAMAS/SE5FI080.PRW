#include "rwmake.ch"
#Include "Protheus.ch"
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ SE5FI080 ¦Autor ¦Rodrigo Demetrios Correa¦ Data ¦ 23/12/04 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada executado apos a gravacao do SE5          ¦¦¦
¦¦¦          ¦ Utilizado para a Gravacao de dados complementares          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
User Function SE5FI080()
Local _aArea    := GetArea()
Local cCamposE5 := PARAMIXB[1]
Local oSubModel := PARAMIXB[2]

//_cGrupo     := SE2->E2_GRUPO
//_cDescGrupo := SE2->E2_DESCGRU

//If oSubModel:cID == "FK2DETAIL"
//   If "VL" $  oSubModel:GetValue("FK2_TPDOC")
//          cCamposE5 += ",{"
//          cCamposE5 += " 'E5_GRUPO', &(_cGrupo), 'E5_DESCGRU', &(_cDescGrupo) "
//          cCamposE5 += "} "
//   EndIf
//ElseIf oSubModel:cID == "FK6DETAIL"
//   If "DC" $  oSubModel:GetValue("FK6_TPDOC")
//          cCamposE5 += ",{"
//          cCamposE5 += " 'E5_GRUPO', &(_cGrupo), 'E5_DESCGRU', &(_cDescGrupo) "
//          cCamposE5 += "} "
//   EndIf
//EndIf
//
RestArea(_aArea)
Return cCamposE5

/*/
User Function SE5FI080()
_aArea := GetArea()

_cGrupo := SE2->E2_GRUPO
_cDescGrupo := SE2->E2_DESCGRU

RecLock("SE5",.F.)
   SE5->E5_GRUPO     := _cGrupo
   SE5->E5_DESCGRU   := _cDescGrupo
MsUnLock()

RestArea(_aArea)
Return
/*/