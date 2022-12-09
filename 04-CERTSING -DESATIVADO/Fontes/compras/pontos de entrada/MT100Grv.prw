//--------------------------------------------------------------------------
// Rotina | MT100Grv   | Autor | Robson Gon�alves        | Data | 11.01.2017
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada anterior a gravacao do Documento de Entrada. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT100Grv()
	Local lRet := .T.
	If l103Class .AND. SF1->( FieldPos( 'F1_LOG' ) ) > 0
		//------------------------------------------------------------------------------------------
		// Rotina para analisar diverg�ncia entre PC e NFE no ato da confirma��o de classificar NFE.
		// Conforme a an�lise ser� criticado e n�o ser� classificada a NFE.
		//------------------------------------------------------------------------------------------
		lRet := U_CSFA780()	
	Endif
Return( lRet )