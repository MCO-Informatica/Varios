#INCLUDE "PROTHEUS.CH"

//--------------------------------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} PNA130GRV
Ponto de entrada executado antes da gravação dos apontamentos na tabela SPC, na rotina de Manutenção dos Apontamentos.

@Return Null
@author Bruno Nunes
@since 12/07/2016
@version 1.0
/*/
//--------------------------------------------------------------------------------------------------------------------------------------------

User Function PNA130GRV()
	dbSelectArea('SPC')
	u_RBPorPon()
Return()