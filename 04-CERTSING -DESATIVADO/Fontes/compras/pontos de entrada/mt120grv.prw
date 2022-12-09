//------------------------------------------------------------------------
// Rotina | MT120GRV | Robson Gonçalves                | Data | 21/07/2016
//------------------------------------------------------------------------
// Descr. | Ponto de entrada que determina continuar ou não a inclusão,  
//        | alteração ou exclusão do pedido de compras. 
//------------------------------------------------------------------------
// Param  | Passagem: ParamIXB[1] - Número do pedido de compras.
//        |           ParamIXB[2] - Parâmetro que define se é inclusão.
//        |           ParamIXB[3] - Parâmetro que define se é alteração.
//        |           ParamIXB[4] - Parâmetro que define se é exclusão.
//        | Retorno.: Lógico - continua .T. ou não .F. com a gravação.
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------
STATIC lNewCP610 := IIf( FindFunction( 'U_NewCP610' ) , U_NewCP610() , .F. )
User Function MT120GRV()
	Local aParam := {}
	aParam := AClone( ParamIXB )
	If lNewCP610
		//------------------------
		// O processo é alteração?
		If aParam[ 3 ]
			//-------------------------------------------
			// Passar o número do PC e não enviar e-mail.
			U_A610DelPC( aParam[ 1 ], .F. )
		Endif
		//------------------------------------------------------------------------------------------
		// Se alteração ou exclusão, revogar os registros na GTLOG -> integração com aplicação Java.
		If aParam[ 3 ] .OR. aParam[ 4 ]
			U_A610Revog( aParam )
		Endif
	Endif
Return( .T. )