#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MTA103OK
Confirmação da NF. TudoOK
Documento Entrada. MATA103

@author		Fernando Bombardi
@since 		03/03/2016
/*/
User Function MTA103OK()
Local aArea   	 := GetArea()
Local lRet		 := .T.
Private nD1TES	 := GdFieldPos('D1_TES')
Private nD1CONTA := GdFieldPos('D1_CONTA')

Begin Sequence

	//Valida Conta Contabil x TES para produtos que sao ativo fixo
	oRECOMC01 := RECOMC01():NEW()
	lRet := oRECOMC01:ValidaContaTESAtivo(lRet)

End Sequence

RestArea(aArea)                    
Return(lRet)