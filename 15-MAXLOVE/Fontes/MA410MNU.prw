#include "protheus.ch"

User Function MA410MNU()

Public BFILTRABRW := {}
Public cCondicao :=" "
cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
BFILTRABRW := {'SF2',cCondicao}

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UTILIZADO PARA RECEBER UM ARRAY NA HORA DE EXPORTAR DANFES.

OBS: SEM ESSA INFORMAÇÃO, VAI DAR ERRO AO TENTAR EXPORTAR DIZENDO QUE NÃO EXISTE VARIAVEL AFILBRW.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
Public AFILBRW := {}
Private cCondicao :=" "
cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
AFILBRW := {'SF2',cCondicao}

	AADD(aRotina, {'Impressão Pedido', "U_RFATR01()", 0, 0, 0, Nil} )
	AADD(aRotina, {'Limpa e-commerce', "U_LmpEPDV()", 0, 0, 0, Nil} )
	AADD(aRotina, {"Libera Pedido"	 , "U_xLibePDV(SC5->C5_NUM)", 2, 2})
	AADD(aRotina, {"Monitor NFE Mod.2","U_MonitNFE( SC5->C5_SERIE, SC5->C5_NOTA, SC5->C5_NOTA,'SC5')"	, 2 , 2 })
	AADD(aRotina, {"Gera Danfe"		 , "U_zGerDanfe('SC5')", 2 , 2 })


Return()



User Function LmpEPDV()
	Local cSql := ""

	If MsgYesNo("Esta rotina liberará o pedido E-commerce "+Chr(10)+Chr(13)+"para eliminação de resíduo. Deseja prosseguir?","Atenção")

		cSql := "UPDATE "+RetSqlName("SC5")+" SET C5_PEDECOM = ' ', C5_ORCRES = ' ' WHERE C5_NUM = '"+SC5->C5_NUM+"' AND C5_FILIAL = '"+SC5->C5_FILIAL+"' AND D_E_L_E_T_ = ' ' "
		TCSqlExec(cSql)

	EndIf

Return
