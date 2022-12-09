//-----------------------------------------------------------------------
// Rotina | MT410TOK   | Autor | Robson Gonçalves     | Data | 26.02.2014
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado ao clicar OK no pedido de venda.
//        | O retorno esperado é lógico, sendo .T. continua, e .F. não.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function MT410TOK()
	
	Local lRet := .T.
	
	// Verificar se existe a função no repositório.
	If FindFunction('U_CSFA360')
		// Somente se for alteração.
		If ParamIXB[ 1 ] == 4
			//Somente se for pedido gerado pelo Telvendas.
			//1=Manual;2=Venda Varejo;3=Venda Hardware Avulso;4=Televendas;5=Atendimento Externo;6=Contratos;7=Portal Assinaturas
			If M->C5_XORIGPV == '4'
				// Executar a rotina e receber seu retorno.
				lRet := U_CSFA360()
			Endif
		Endif
	Endif
	
	//Renato Ruy - 06/09/2016
	//Validação de pedidos para poder de terceiros.
	If M->C5_TIPO == "B" .And. lRet
		lRet := U_CSFAT007()
	Endif
	
Return( lRet )