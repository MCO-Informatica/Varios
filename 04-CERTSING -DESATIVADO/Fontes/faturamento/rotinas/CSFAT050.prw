#include 'Totvs.ch'
//---------------------------------------------------------------
// Rotina | CSFAT050 | Autor | Rafael Beghini | Data | 08/01/2016 
//---------------------------------------------------------------
// Descr. | Rotina que habilita o campo ZF_DTSOLIC  
//        | conforme determinados tipos de Voucher.
//---------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//---------------------------------------------------------------
User Function CSFAT050()
	Local cCodVou  := ''
	Local cMV_CodV := 'MV_CSFAT50'
	Local lRet     := .F.
	
	IF .Not. GetMv( cMV_CodV, .T. )
		CriarSX6( cMV_CodV,'C','Códigos Voucher que permitem utilizar o campo Data Solicitação na geração do voucher. CSFAT050.prw', '3,4,5,8,9,B,D,E,F,G,7')
	EndIF
	
	cCodVou := GetMv( cMV_CodV )
	
	IF M->ZF_TIPOVOU $ cCodVou
		lRet := .T.
	EndIF
Return( lRet )