//--------------------------------------------------------------------------
// Rotina | MT120APV | Autor | Robson Goncalves          | Data | 28/09/2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada que permite manipular o código do grupo de 
//        | aprovação do pedido de compras. Este recurso deve estar em 
//        | conformidade com a rotina CSFA610.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#INCLUDE "TOTVS.CH"
STATIC lNewCP610 := IIf( FindFunction( 'U_NewCP610' ) , U_NewCP610() , .F. )

User Function MT120APV()
	Local aArea := {}
	If lNewCP610
		aArea := { GetArea(), CTT->( GetArea() )}
		//-----------------------------------------------
		// REGRA PARA EDIÇÃO DO CAMPO TIPO DE COMPRA NA 
		// CAPA DE DESPESA CONFORME O CONTRATO.
		//-----------------------------------------------
		// CONTRATO   | CAPA DESPESA | CENTRO DE CUSTO
		//-----------------------------------------------
		// 1=FIXO     | 1=FIXO       | 1=FIXO
		// 2=VARIAVEL | 2=VARIAVEL   | 2=RECORRENTE
		// 3=AMBOS    | 2=VARIAVEL   | 2=RECORRENTE
		// 3=AMBOS    | 3=PONTUAL    | 3=PONTUAL
		//-----------------------------------------------
		CTT->( dbSetOrder( 1 ) )
		If CTT->( dbSeek( xFilial( 'CTT' ) + SC7->C7_CCAPROV ) )
			If SC7->C7_XRECORR == '1'     ; cReturn := CTT->CTT_GARFIX
			Elseif SC7->C7_XRECORR == '2' ; cReturn := CTT->CTT_GARVAR
			Elseif SC7->C7_XRECORR == '3' ; cReturn := CTT->CTT_GAPONT
			Else
				cReturn := CTT->CTT_XAPROV
			Endif
			
			If Empty( cReturn )
				cReturn := SC7->C7_APROV
			Endif
		Else
			cReturn := SC7->C7_APROV
		Endif
	Else
		DbSelectArea("CTT")
		DbSetOrder(1)
		If DbSeek( xFilial("CTT") + SC7->C7_CC)
			cReturn := CTT->CTT_XAPROV
		EndIf
	Endif
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return( cReturn )