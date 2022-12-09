// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} CN120ENVL
	Ponto de entrada para validação do encerramento da medição
	@type Function
	@version 12.1.25
	@author Guilherme Bigois
	@since 26/07/2021
	@return Logical, Permissão de encerramento da medição
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=189306867
/*/
User Function CN120ENVL() As Logical
	Local lOK     := .T. As Logical // Controle de encerramento da medição
	Local lAdmin  := .T. As Logical // Controle de acesso administrador de contrato
	Local aArea   := {}  As Array   // Áreas de trabalho à serem restauradas
	Local aGroups := {}  As Array   // Grupos ao qual o usuário está inserido

	// Armazena a área corrente e a CN9
	AAdd(aArea, CN9->(GetArea()))
	AAdd(aArea, GetArea())

	// Verifica se o usuário faz parte do grupo CONTRATOS_JURIDICO (000291)
	aGroups := FwSFUsrGrps(RetCodUsr())
	lAdmin := AScan(aGroups, {|x| x == "000291"}) > 0

	// Pesquisa pelo contrato na tabela de cabeçalho
	DBSelectArea("CN9")
	DBSetOrder(1)
	DBSeek(CND->CND_FILCTR + CND->CND_CONTRA + CND->CND_REVISA)

	// Caso a data final do contrato seja inferior a data atual, não permite
	// o encerramento da mendição e exibe mensagem para o usuário

	If (!lAdmin .And. (!Found() .And. !Empty(CND->CND_DTFIM) .And. CND->CND_DTFIM < dDataBase) .Or.;
		(Found() .And. !Empty(CN9_DTFIM) .And. CN9_DTFIM < dDataBase))
		lOK := .F.
		Help(NIL, NIL, "CONTRACT_EXPIRED", NIL, "O contrato atual encontra-se vencido desde " + DToC(IIf(Found(), CN9_DTFIM, CND->CND_DTFIM)) + ".",;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique com o responsável pelo setor de contratos a possibilidade de renovação."})
	EndIf

	// Restaura o estado anterior das áreas mantendo a CN9 como antes,
	// devolvendo o ponteiro ao arquivo anterior e limpando o array da memória
	AEval(aArea, {|x| RestArea(x)})
	FwFreeArray(aArea)
Return (lOK)
