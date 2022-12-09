//-----------------------------------------------------------------------
// Rotina | CN120EnMed | Autor | Robson Gon�alves     | Data | 14.04.2015
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no final da gravacao do encerrament
//        | da medi��o.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CN120EnMed()
	Local aDadosPC := {}
	
	// Rotina para atualizar o campo de acumulador de medi��o.
	U_CSFA590( CND->CND_CONTRA, CND-> CND_REVISA, 'ENCERRAR' )
	
	//-----------------------------------------------------------------
	// Rotina para calcular o valor do rateio quando o pedido de compra
	// gerado pela medi��o do contrato e este houver rateio.
	U_A610CaVR( CND->CND_PEDIDO )
	
	//---------------------------------------------
	// Recuperar os dados e executar a A610NGestor.
	//[1]-Op��o da aRotina.
	//[2]-N� Pedido compras.
	//[3]-1=OK; 0=Cancel.
	aDadosPC := U_A610RsPC()
	
	If Len( aDadosPC ) > 0
		ProcessaDoc( {|| U_A610NGestor( aDadosPC, IsBlind() ) }, 'Lan�amento de despesa' ,'Notificar o gestor.' )
	Endif

	STATICCALL( MT120FIM, GetDocReplica, CND->CND_PEDIDO, 'MED' )

Return