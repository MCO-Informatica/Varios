#Include 'Protheus.ch'
//-----------------------------------------------------------------------
// Rotina | CN140BRV    | Autor | Rafael Beghini     | Data | 20.06.2016
//-----------------------------------------------------------------------
// Descr. | P.E utilizado na confirma��o da revisao.
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CN140BRV()
	Local cCTR  := PARAMIXB[1] //Cont�m o c�digo do contrato
	Local cREV  := PARAMIXB[2] //Cont�m o c�digo da Revis�o do Contrato
	Local aPLAN := PARAMIXB[10] //Cont�m Planilhas selecionadas
	Local nL    := 0
	Local dDTASSI := CTOD(Space(8))
	
	CN9->( dbSetOrder(1) )
	CN9->( dbSeek( xFilial('CN9') + cCTR + cREV ) )
	dDTASSI := CN9->CN9_DTASSI
	
	//Os campos Data aniversario e Preco origal devem ser preenchidos para n�o ocorrer erro na gera��o.
	For nL := 1 To Len( aPLAN )
		CNB->( dbSetOrder(1) )
		CNB->( dbSeek( xFilial('CNB') + cCTR + cREV ) )
		While .NOT. EOF() .And. CNB->( CNB_FILIAL + CNB_CONTRA + CNB_REVISA ) == xFilial('CNB') + cCTR + cREV
			IF CNB->CNB_NUMERO == aPLAN[nL,1] .And. ( Empty(CNB->CNB_DTANIV) .OR. CNB->CNB_PRCORI <= 0 )
				CNB->( RecLock('CNB',.F.) )
				CNB->CNB_PRCORI = CNB->CNB_VLUNIT
				CNB->CNB_DTANIV = dDTASSI	
				CNB->( MsUnlock() )
			EndIF
			CNB->( dbSkip() )
		End
	Next nL
Return(.T.)

