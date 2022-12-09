#INCLUDE "PROTHEUS.CH"

User Function A410CONS()

Local _aBotao := {}

Aadd(_aBotao,{"AUTOM" ,{||U_FATP006()},"Romaneio"})     
Aadd(_aBotao,{"AUTOM" ,{||U_COMP001(GdFieldGet('C6_PRODUTO',n))},"Consulta Laselva"})     

Return(_aBotao)