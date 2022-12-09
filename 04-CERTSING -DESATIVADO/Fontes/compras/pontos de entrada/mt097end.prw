//--------------------------------------------------------------------------
// Rotina | MT097END | Autor | Robson Gonçalves          | Data | 18.05.2016
//--------------------------------------------------------------------------
// Descr. | O ponto de entrada se encontra no fim das funções A097LIBERA, 
//        | A097SUPERI e A097TRANSF , passa como parametros o Numero do 
//        | Documento, Tipo, Opção executada (nOpc) e a Filial do Documento 
//        | e não envia retorno, usado conforme necessidades do usuario 
//        | para diversos fins.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT097END()
	Local aParam := {}
	Private cPedCompras := ''
	//[ 1 ] - CR_NUM
	//[ 2 ] - CR_TIPO
	//[ 3 ] - nOpc
	//[ 4 ] - CR_FILIAL
	aParam := AClone( ParamIXB )
	
	// Somente pedido de compras.
	If aParam[ 2 ] == 'PC'
		If ProcName( 2 ) == 'A097LIBERA' .AND. aParam[ 3 ] >= 2 // 1=Cancela, 2=Libera, 3=Bloqueia.			
			SCR->( dbSetOrder( 1 ) )              
			SCR->( dbSeek( xFilial( 'SCR' ) + aParam[ 2 ] + aParam[ 1 ] ) )
			While SCR->( .NOT. EOF() ) .AND. ;
				SCR->CR_FILIAL == xFilial( 'SCR' ) .AND. ;
				SCR->CR_TIPO == aParam[ 2 ] .AND. ;
				RTrim( SCR->CR_NUM ) == RTrim( aParam[ 1 ] )
				// Existe alçada para enviar WF?
				If SCR->CR_STATUS == '02'
					cPedCompras := SCR->CR_FILIAL + RTrim( SCR->CR_NUM )
					// Enviar WF.
					U_A610WFPC()
				Endif
				SCR->( dbSkip() )
			End
			U_A610AvUs( aParam, Iif( aParam[ 3 ] == 2, 'Aprovado', 'Reprovado' ), Iif( aParam[ 3 ] == 2, 'APROVADO.', 'REPROVADO.' ) )
		Endif
	Endif
Return