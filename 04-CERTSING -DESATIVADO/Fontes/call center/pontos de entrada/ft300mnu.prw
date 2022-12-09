#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
//-----------------------------------------------------------------------
// Rotina | FT300MNU | Autor | Robson Gon�alves       | Data | 01.01.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada para adicionar op��es no menu da MBrowse da
//        | rotina de Oportunidades.
//-----------------------------------------------------------------------
// Update | Adequa��o do PE para nova vers�o em MVC
//		  | Rafael Beghini TSM - 02.10.2018
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function FT300MNU()
	aRotina := PARAMIXB[1]
	
	ADD OPTION aRotina TITLE "Gerar proposta" 		ACTION "U_A320IPro()" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Import. Oportunidade" ACTION "U_CSFATA02()" OPERATION 2 ACCESS 0	
Return( aRotina )