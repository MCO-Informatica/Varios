//------------------------------------------------------------------------
// Rotina | MT120GRV | Robson Gon�alves                | Data | 21/07/2016
//------------------------------------------------------------------------
// Descr. | Ponto de entrada que determina continuar ou n�o a inclus�o,  
//        | altera��o ou exclus�o do pedido de compras. 
//------------------------------------------------------------------------
// Param  | Passagem: ParamIXB[1] - N�mero do pedido de compras.
//        |           ParamIXB[2] - Par�metro que define se � inclus�o.
//        |           ParamIXB[3] - Par�metro que define se � altera��o.
//        |           ParamIXB[4] - Par�metro que define se � exclus�o.
//        | Retorno.: L�gico - continua .T. ou n�o .F. com a grava��o.
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------
STATIC lNewCP610 := IIf( FindFunction( 'U_NewCP610' ) , U_NewCP610() , .F. )
User Function MT120GRV()
	Local aParam := {}
	aParam := AClone( ParamIXB )
	If lNewCP610
		//------------------------
		// O processo � altera��o?
		If aParam[ 3 ]
			//-------------------------------------------
			// Passar o n�mero do PC e n�o enviar e-mail.
			U_A610DelPC( aParam[ 1 ], .F. )
		Endif
		//------------------------------------------------------------------------------------------
		// Se altera��o ou exclus�o, revogar os registros na GTLOG -> integra��o com aplica��o Java.
		If aParam[ 3 ] .OR. aParam[ 4 ]
			U_A610Revog( aParam )
		Endif
	Endif
Return( .T. )