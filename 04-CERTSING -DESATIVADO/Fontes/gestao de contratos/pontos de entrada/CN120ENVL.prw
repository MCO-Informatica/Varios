// Bibliotecas necess�rias
#Include "TOTVS.ch"

/*/{Protheus.doc} CN120ENVL
	Ponto de entrada para valida��o do encerramento da medi��o
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 26/07/2021
	@return Logical, Permiss�o de encerramento da medi��o
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=189306867
/*/
User Function CN120ENVL() As Logical
	Local lOK     := .T. As Logical // Controle de encerramento da medi��o
	Local lAdmin  := .T. As Logical // Controle de acesso administrador de contrato
	Local aArea   := {}  As Array   // �reas de trabalho � serem restauradas
	Local aGroups := {}  As Array   // Grupos ao qual o usu�rio est� inserido

	// Armazena a �rea corrente e a CN9
	AAdd(aArea, CN9->(GetArea()))
	AAdd(aArea, GetArea())

	// Verifica se o usu�rio faz parte do grupo CONTRATOS_JURIDICO (000291)
	aGroups := FwSFUsrGrps(RetCodUsr())
	lAdmin := AScan(aGroups, {|x| x == "000291"}) > 0

	// Pesquisa pelo contrato na tabela de cabe�alho
	DBSelectArea("CN9")
	DBSetOrder(1)
	DBSeek(CND->CND_FILCTR + CND->CND_CONTRA + CND->CND_REVISA)

	// Caso a data final do contrato seja inferior a data atual, n�o permite
	// o encerramento da mendi��o e exibe mensagem para o usu�rio

	If (!lAdmin .And. (!Found() .And. !Empty(CND->CND_DTFIM) .And. CND->CND_DTFIM < dDataBase) .Or.;
		(Found() .And. !Empty(CN9_DTFIM) .And. CN9_DTFIM < dDataBase))
		lOK := .F.
		Help(NIL, NIL, "CONTRACT_EXPIRED", NIL, "O contrato atual encontra-se vencido desde " + DToC(IIf(Found(), CN9_DTFIM, CND->CND_DTFIM)) + ".",;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique com o respons�vel pelo setor de contratos a possibilidade de renova��o."})
	EndIf

	// Restaura o estado anterior das �reas mantendo a CN9 como antes,
	// devolvendo o ponteiro ao arquivo anterior e limpando o array da mem�ria
	AEval(aArea, {|x| RestArea(x)})
	FwFreeArray(aArea)
Return (lOK)
