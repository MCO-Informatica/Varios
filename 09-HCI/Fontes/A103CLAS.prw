#INCLUDE 'PROTHEUS.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} A103CLAS
Rotina para limpar o campo D1_TES quando a inclus�o do documento de entrada
for atrav�s do m�dulo EIC.

@author 	
@since 		
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function A103CLAS()

	Local cSerieEIC	:= AllTrim(SF1->F1_SERIE)
	Local cFormProp	:= Alltrim(SF1->F1_FORMUL)
	Local nPxTES	:= ASCAN(aHeader, {|x|AllTrim(x[2])=="D1_TES"})
	Local _cSerFil	:= AllTrim(GetMV("ES_ESPEIC",,"03A")) //Altera��o BZO 29/06/2015 - Inclus�o de analise pelo par�metro para funcionar para todas as empresas.
	
	IF cSerieEIC $ _cSerFil .AND. cFormProp == "S"
		IF nPxTES > 0
			aCols[Len(aCols),nPxTES] := SPACE(TamSX3("D1_TES")[1])
		EndIF	
	EndIF
	
Return()			                              