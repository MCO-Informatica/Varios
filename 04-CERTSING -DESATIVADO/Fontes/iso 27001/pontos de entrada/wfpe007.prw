//--------------------------------------------------------------------------------
// Rotina | WFPE007      | Autor | Robson Gonçalves              | Data | 04.06.15
//--------------------------------------------------------------------------------
// Descr. | Ponto de entrada que permite customizar a mensagem de processamento do 
//        | workflow por link. Após o usuário clicar no botão Enviar do WF será 
//        | apresentanda a mensagem em HTML programada abaixo.
//--------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------
User Function WFPE007()
	Local cReturn := ''
	Local aReturn := {}
	Local aParam := Array( 3 )
	
	aParam[ 1 ] := ParamIXB[ 1 ] // lSuccess
	aParam[ 2 ] := ParamIXB[ 2 ] // cMessage
	aParam[ 3 ] := ParamIXB[ 3 ] // cProcessID
	
	// [1] - Númerdo do ID do processo do WF.
	// [2] - String com o nome da origem do processamento.
	aReturn := U_A603Restore()
	
	If aParam[ 3 ] == aReturn[ 1 ]
		If     aReturn[ 2 ] == 'CSFA603'    ; cReturn := GetNewPar('MV_603WF3' , '\WORKFLOW\EVENTO\CSFA603c.HTM')    // WF de aprovação de contrato.
		Elseif aReturn[ 2 ] == 'CSFA610cp'  ; cReturn := GetNewPar('MV_610WF3' , '\WORKFLOW\EVENTO\CSFA610c.HTM')    // WF de aprovação da capa de despesa.
		Elseif aReturn[ 2 ] == 'CSFA610pc'  ; cReturn := GetNewPar('MV_610WFPC', '\WORKFLOW\EVENTO\CSFA610pc3.HTM')  // WF de aprovação do pedido de compras.
		Elseif aReturn[ 2 ] == 'CSFA610Err' ; cReturn := GetNewPar('MV_610WFER', '\WORKFLOW\EVENTO\CSFA610Err.HTM')  // WF de aprov. do PC que não conseguiu avaliar.
		Elseif aReturn[ 2 ] == 'CSFA610NoPC'; cReturn := GetNewPar('MV_610WFER', '\WORKFLOW\EVENTO\CSFA610NoPC.HTM') // WF de aprov. do PC que não localizou o PC.
		Elseif aReturn[ 2 ] == 'CSFA260'    ; cReturn := GetNewPar('MV_260WF3' , '\WORKFLOW\EVENTO\CSFA260c.HTM')    // WF de aprovação da solicitação de despesas.
		Elseif aReturn[ 2 ] == 'CSFA280'    ; cReturn := GetNewPar('MV_280WF3' , '\WORKFLOW\EVENTO\CSFA280c.HTM')    // WF de aprovação da relação de despesas.
		Elseif aReturn[ 2 ] == 'CSFA710'    ; cReturn := GetNewPar('MV_710WF3' , '\WORKFLOW\EVENTO\CSFA710c.HTM')    // WF de solicitação de compras.
		Endif
		U_A603Clear()
	Else
		cReturn := Iif( aParam[ 1 ], '\wfreturn.htm', '\wfreterr.htm' )
	Endif
	
	If ( File( cReturn ) )
		cReturn := WFLoadFile( cReturn )
	Else
		cReturn := WFHTMLTemplate('TOTVS | Workflow', aParam[ 2 ], Iif( aParam[ 1 ], 'Mensagem','Erro' ) )
	Endif
	
Return( cReturn )