#INCLUDE "PROTHEUS.CH"

/* Valida o campo natureza que esta contido na consulta
se for selecionado uma natureza diferente o sistema exibe
um alerta*/

User Function ValPa()

Local cNat  := ""
Local _lRet :=.T.
Local aArea := GetArea()

cNat:=Posicione("SED",1,xFilial("SED")+M->Z7_NATUREZ,"ED_XADITO")

if cNat <> "2"
   _lRet := .T.
Else
    Alert("Natureza incorreta.!!Informe uma natureza de adiantamento através da consulta")
    _lRet := .F.
EndIf

RestArea(aArea)
Return _lRet
