//------------------------------------------------------------------
// Rotina | TMKACTIVE | Autor | Robson Luiz - Rleg | Data | 07/08/12
//------------------------------------------------------------------
// Descr. | Ponto de entrada acionado na ativação da MsDialog da tela
//        | de atendimento do telemarketing.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function TmkActive()
	//----------------------------------------------------------------------------
	// Rotina elaborada da funcionalidade de importação de Common Name CSFA010.prw
	//----------------------------------------------------------------------------
	U_FA10TmkAct()	

	//---------------------------------------------------------------------------
	// Rotina elaborada da funcionalidade de importação de ICP-Brasil CSFA050.prw
	//---------------------------------------------------------------------------
	U_FA50TmkAct()
Return(.T.)