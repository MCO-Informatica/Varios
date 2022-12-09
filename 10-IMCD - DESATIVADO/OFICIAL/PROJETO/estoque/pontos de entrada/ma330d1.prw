#include "PROTHEUS.CH"
//P.E para ATUALIZAR CUSTO DE ENTRADA DE NOTAS DO EIC COM AS TES INFORMADAS 
//ESPECIFICO IMCD 

User Function MA330D1( )//-- Manipulação customizada do arquivo de trabalho
	if TRB->TRB_TES $ "056/001"
		RECLOCK("SD1",.F.)
		SD1->D1_CUSTO := SD1->D1_TOTAL+SD1->D1_DESPESA
		msunlock()	
	ENDIF

Return Nil