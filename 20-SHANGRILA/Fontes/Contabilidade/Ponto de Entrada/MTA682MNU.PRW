#Include "totvs.ch"

User Function MTA682MNU
	aadd( aRotina,{"Alterar"     ,"U_ALT682",0,0} )
Return

User Function ALT682
Local aACHO := {"H6_DATAINI","H6_HORAINI","H6_DATAFIN","H6_HORAFIN","H6_DTAPONT","H6_RECURSO","H6_TEMPO","H6_MOTIVO","H6_XRECDES","H6_OBSERVA","H6_OPERADO","NOUSER"}
Local aCpos := {"H6_RECURSO","H6_TEMPO","H6_MOTIVO","H6_XRECDES","H6_OBSERVA","H6_OPERADO"}
AxAltera("SH6",SH6->(Recno()),3,aACHO,aCpos)

Return
