#Include "Protheus.ch" 
#Include "TOPCONN.CH" 
//#Include "FINA330.ch" 

//+---------------------------------------------------------------+
//| Rotina | FA240PA | Autor | Rafael Beghini | Data | 10/04/2015 |
//+---------------------------------------------------------------+
//| Descr. | PE para permitir a sele��o de PA (Mov. Banc�rio)     |
//|        |                                                      |
//+---------------------------------------------------------------+
//| Uso    | CertiSign - Financeiro                               |
//+---------------------------------------------------------------+
User Function FA240PA() 

	Local lRet := .T.  //.T., para o sistema permitir a sele��o de PA (com mov. Banc�rio) 
					// na tela de border� de pagamento e .F. para n�o permitir. 

Return lRet