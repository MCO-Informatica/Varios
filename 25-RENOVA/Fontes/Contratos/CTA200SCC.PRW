#INCLUDE "PROTHEUS.ch"

User function CTA200SCC()

Local aFields := {}
	aAdd(aFields,{'CNB_CC'    ,'SC1->C1_CC'})
	aAdd(aFields,{'CNB_CONTA' ,'SC1->C1_CONTA'})
	aAdd(aFields,{'CNB_ITEMCT'  ,'SC1->C1_ITEMCTA'})
	aAdd(aFields,{'CNB_CLVL' ,'SC1->C1_CLVL'})
	//Inlcuido Ronaldo Bicudo - 27/11/2015
	aAdd(aFields,{'CNB_EC05DB' ,'SC1->C1_EC05DB'})
	aAdd(aFields,{'CNB_XIMCUR','SC1->C1_XIMCURS'})
	aAdd(aFields,{'CNB_XPROJI','SC1->C1_XPROJIM'})
	//Final da Inclusão
return aFields
