#Include "Protheus.ch" 
#Include "TOPCONN.CH" 
//#Include "FINA330.ch" 

//+---------------------------------------------------------------+
//| Rotina | FA240PA | Autor | Rafael Beghini | Data | 10/04/2015 |
//+---------------------------------------------------------------+
//| Descr. | PE para permitir a seleção de PA (Mov. Bancário)     |
//|        |                                                      |
//+---------------------------------------------------------------+
//| Uso    | CertiSign - Financeiro                               |
//+---------------------------------------------------------------+
User Function FA240PA() 

	Local lRet := .T.  //.T., para o sistema permitir a seleção de PA (com mov. Bancário) 
					// na tela de borderô de pagamento e .F. para não permitir. 

Return lRet