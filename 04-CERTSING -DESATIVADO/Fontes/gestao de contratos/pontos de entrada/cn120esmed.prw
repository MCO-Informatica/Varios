//-----------------------------------------------------------------------
// Rotina | CN120EsMed | Autor | Robson Gonçalves     | Data | 14.04.2015
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no final da gravação do estorno do
//        | encerramento da medição.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CN120EsMed()
	Local cNumPedido := ''
	
	U_CSFA590( CND->CND_CONTRA, CND-> CND_REVISA, 'ESTORNAR' )
	
	If .NOT.Empty(CND->CND_FORNEC) .AND. .NOT.Empty(CND->CND_LJFORN)
		cNumPedido := ParamIXB[ 1 ]
		U_A610EAlc( cNumPedido )
	Endif
Return