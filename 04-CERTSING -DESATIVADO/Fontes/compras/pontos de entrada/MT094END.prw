#Include 'Protheus.ch'
//--------------------------------------------------------------------------
// Rotina | MT094END | Autor | Robson Gonçalves          | Data | 21.09.2018
//--------------------------------------------------------------------------
// Descr. | PE substituindo o MT097END
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT094END()
	Local aParam := {}
	Local aDados := {}
	Private cPedCompras := ''
	//[ 1 ] - CR_NUM
	//[ 2 ] - CR_TIPO
	//[ 3 ] - nOpc Operação a ser executada (1-Aprovar, 2-Estornar, 3-Aprovar pelo Superior, 4-Transferir para Superior, 5-Rejeitar, 6-Bloquear).
	//[ 4 ] - CR_FILIAL
	aParam := AClone( ParamIXB )
	
	// Somente pedido de compras.
	If aParam[ 2 ] == 'PC'
		aDados := { RTrim( UsrFullName( SC7->C7_USER ) ), RTrim( UsrRetMail( SC7->C7_USER ) ) }
		If ProcName( 2 ) == 'A094COMMIT' .AND. cValToChar( aParam[ 3 ] ) $ '1|3'			
			SCR->( dbSetOrder( 1 ) )              
			IF SCR->( dbSeek( xFilial( 'SCR' ) + aParam[ 2 ] + aParam[ 1 ] ) )
				cPedCompras := SCR->CR_FILIAL + RTrim( SCR->CR_NUM )
				// Enviar WF.
				U_A610WFPC()
			EndIF
			U_A610AvUs( aParam, Iif( cValToChar( aParam[ 3 ] ) $ '1|3', 'Aprovado', 'Reprovado' ), Iif( cValToChar( aParam[ 3 ] ) $ '1|3', 'APROVADO.', 'REPROVADO.' ))
			U_A610Noti( aParam, aDados )
		ElseIF ProcName( 2 ) == 'A094COMMIT' .AND. cValToChar( aParam[ 3 ] ) $ '5|6'
			U_A610Noti( aParam, aDados )
		Endif
	Endif
Return

