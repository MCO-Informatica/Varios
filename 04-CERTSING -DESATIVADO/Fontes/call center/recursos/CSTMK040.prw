#Include 'Protheus.ch'
//-----------------------------------------------------------------------
// Rotina | CSTMK040    | Autor | Rafael Beghini     | Data | 09.06.2016
//-----------------------------------------------------------------------
// Descr. | Função que habilita utilizar o campo CPF do participante
//        | para grupo de atendimento conforme parametro no SDK
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSTMK040()
	Local lRet := .F.
	Local cGRUPO := ''
	Local cMV_CSTKM40 := 'MV_CSTKM40'
		
	If .NOT. SX6->( ExisteSX6( cMV_CSTKM40 ) )
		CriarSX6( cMV_CSTKM40, 'C', 'Grupos que utilizam o campo CPF do Participante. CSTMK040.prw', "'90'" )
	Endif
		
	cGRUPO := GetMv( cMV_CSTKM40 )
	
	IF M->ADE_GRUPO $ cGRUPO
		lRet := .T.
	EndIF
Return( lRet )
//-----------------------------------------------------------------------
// Rotina | TMK40CPF    | Autor | Rafael Beghini     | Data | 09.06.2016
//-----------------------------------------------------------------------
// Descr. | Gatilho utilizado no campo ADE_CPFRD0 para gravar dados
//        | de entidade, código e nome do participante.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function TMK40CPF()
	Local cRet := ''
	RD0->( dbSetOrder(6) )
	IF RD0->( dbSeek( xFilial('RD0') + M->ADE_CPFRD0 ) )
		cRet := RD0->RD0_CIC
		M->ADE_ENTIDA := 'RD0'
		M->ADE_NMENT  := 'Participantes'
		M->ADE_CHAVE  := RD0->RD0_CODIGO
		M->ADE_DESCCH := RD0->RD0_NOME
		M->ADE_EMAIL2  := RD0->RD0_EMAIL
	Else
		Alert('Participante não encontrado')
	EndIF	
Return( cRet )