#Include 'Protheus.ch'

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	21/11/2014
* Descricao		:	
* Retorno		: 	
*/
User Function SHCTB001(cLP,cSeq,cCampo,cTipo)
	Local aArea 	:= GetArea()
	Local nValor  	:= 0
	
	If SD1->D1_VALIRR > 0 .OR. SD1->D1_VALISS > 0 .OR. SD1->D1_VALINS > 0 .OR. SD1->D1_VALICM > 0 .OR. SD1->D1_VALDESC > 0 .OR. SD1->D1_DESPESA > 0 .OR. SD1->D1_VALFRE > 0;
			.OR. SD1->D1_VALPIS > 0 .OR. SD1->D1_VALCOF > 0 .OR. SD1->D1_VALCSL > 0 .OR. SD1->D1_VALIPI > 0
		If cLP == "650" .And. cCampo == "CT5_VLR01"
		
			If 'IRR' $ cTipo .And. SF1->F1_IRRF >= 10
				nValor +=  SD1->D1_VALIRR
			EndIF
	
			If 'ISS' $ cTipo
				nValor +=  SD1->D1_VALISS
			EndIF

			If 'INS' $ cTipo
				nValor +=  SD1->D1_VALINS
			EndIF
	
			If 'ICM' $ cTipo
				nValor +=  SD1->D1_VALICM
			EndIF
	
			If 'DESC' $ cTipo
				nValor +=  SD1->D1_VALDESC
			EndIF
	
			If 'DESP' $ cTipo
				nValor +=  SD1->D1_DESPESA
			EndIF
	
			If 'FRE' $ cTipo
				nValor +=  SD1->D1_VALFRE
			EndIF
		
			If 'PIS' $ cTipo
				nValor +=  SD1->D1_VALPIS
			EndIF
			
			If 'COF' $ cTipo
				nValor +=  SD1->D1_VALCOF
			EndIF
			
			If 'CSL' $ cTipo
				nValor +=  SD1->D1_VALCSL
			EndIF
			
			If 'IPI' $ cTipo
				nValor +=  SD1->D1_VALIPI
			EndIF			
		
		EndIf
	EndIf

Return nValor

