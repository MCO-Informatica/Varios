#include 'totvs.ch'

//------------------------------------------------------------------------------------
// Rotina | F240ALMOD    | Autor | Rafael Beghini            | Data | 14/08/2015
//------------------------------------------------------------------------------------
// Descr. | PE - Rotina para alterar o modelo quando for GNRE para gerar o arquivo correto
//------------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------------------
User Function F240ALMOD()
	Local cModelo := ParamIxb[1]
	IF cModelo == '91' //GNRE
		cModelo := '28'
	EndIF
Return(cModelo)