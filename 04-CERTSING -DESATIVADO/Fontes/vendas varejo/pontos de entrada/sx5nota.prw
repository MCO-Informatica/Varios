#include 'totvs.ch'

/*/{Protheus.doc} SX5NOTA

Ponto de Entrada para controle de séries de notas fiscais que poderão ser usadas na rotina de faturamento de cargas  

@author Totvs SM - David
@since 25/03/2014
@version P11

/*/

User Function sx5nota()
	Local lRet:= .F.

	If	FunName() <> "MATA460B" .or.;
		Alltrim(SX5->X5_CHAVE) $ "2/3"
		 
	    lRet := .T.
	    
	Endif

Return lRet