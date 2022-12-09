#include 'totvs.ch'
//---------------------------------------------------------------
// Rotina | CN110GRV | Autor | Rafael Beghini | Data | 20/01/2016 
//---------------------------------------------------------------
// Descr. | Ponto de entrada executado ap�s a confirma��o e 
//        | grava��o do Cronograma Financeiro. CN110Grava 
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//---------------------------------------------------------------
User Function CN110GRV()
	Local nOpca   := PARAMIXB[1]
	Local aDados  := {}

	aAdd( aDados, {CNF->CNF_FILIAL,CNF->CNF_CONTRA,CNF->CNF_REVISA,CNF->CNF_NUMERO} ) 
	
	If FindFunction('U_CSGCT030') .And. nOpca == 3 //Inclusao 
		IF MsgYesNo( 'Deseja alterar a data de vencimento das parcelas?', 'CertiSign | Altera��o espec�fica' )
			U_CSGCT030(aDados)
		EndIF
	Endif
Return