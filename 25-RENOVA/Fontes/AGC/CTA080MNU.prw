#INCLUDE 'TOTVS.CH'
#Include "rwmake.ch"
#Include 'FWMVCDef.ch'

/*==========================================================
= Adiciona rotina para atualiza��o do Indice no financeiro =
= COnforme regras definidas no fonte UPDCLASS              =
= Autor: Alcouto                                           =
*///========================================================
user function CTA080MNU ()



aAdd(aRotina, {"Atualizac�o de Indice", "U_UPDCLASS()", 0, 6, 0, nil}) 
aAdd(aRotina, {"Importar Indice", "U_fImpCsv()", 0, 6, 0, nil}) 
  

Return


