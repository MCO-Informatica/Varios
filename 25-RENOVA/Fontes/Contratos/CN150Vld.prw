#INCLUDE "PROTDEF.CH"
/*
===========================================================================
Programa.: 	CN150VLD
Autor....:	Pedro Augusto
Data.....: 	14/05/2015
Descricao: 	PE utilizado para gerar alçadas de aprovação de rev de contrato
Uso......: 	RENOVA
===========================================================================
*/
User Function CN150Vld
Local cTitulo    := "Aprovação Revisão"
Local aSavAre    := GetArea()
Local _lRet      := .F.
Local cWfAprov := GetMV("MV_XAPROV")
Local _CtrCliVen := CN9->CN9_CLIENT // SE PREENCHIDO É CONTRATO DE VENDA.

If !Empty(_CtrCliVen)// se preenchido contrato de venda, retorna .T. e sai do PE.
	Return(.T.)
Endif

/*
Status Aprovação Revisão -> 1=Não Necessária;2=Aguardando Aprovação;3=Aprovado
*/
/////// PEDRO CRIOU PE PARA COLOCAR O CAMPO CN9->CN9_XSTREV COMO ' ' NO MOMENTO DA GERACAO DA REVISAO
If     CN9->CN9_XSTREV $ "1;3" // 1=Não Necessária ou 3=Aprovado ===> Pedro tem que, ao processar o retorno, colocar este campo como 3
	Return(.T.)
ElseIf CN9->CN9_XSTREV == "2"    // 2=Aguardando Aprovação
	Aviso(cTitulo, "Revisão Aguardando Aprovação por WorkFlow", {" Ok "})
	Return(.F.)
Endif

If "REVCON" + CN9->CN9_TIPREV $ cWfAprov  // 1=NÃO requer aprovacao
	RecLock("CN9", .F.)
	CN9->CN9_XSTREV := "1"
	MsUnlock()
	RestArea(aSavAre)
	Return(.T.)
Endif

nOpt := Aviso("Aprovação Revisão", "Deseja enviar revisão para aprovação?", {" Não ", " Sim "})

If nOpt == 2
	Aviso("Aprovação Revisão", "Alçadas de aprovação geradas, esta revisão será enviada para Aprovação", {" Ok "})
	// Aqui gero a SCR
	
	// Estorna alcada de aprovacao, se existir
	DbSelectArea("SCR")
	SCR->(DbGoTop())
	SCR->(DbSetOrder(1))  &&CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
	If SCR->(DbSeek(xFilial("SCR")+"CT"+CN9->CN9_FILIAL+CN9->CN9_NUMERO+CN9->CN9_REVISA))
		Do While SCR->(!EoF()) .And. SCR->(CR_FILIAL+CR_TIPO+AllTrim(CR_NUM)) == xFilial("SCR")+"CT"+CN9->CN9_FILIAL+CN9->CN9_NUMERO+CN9->CN9_REVISA
			RecLock("SCR", .F.)
			SCR->(DbDelete())
			MsUnlock()
			SCR->(DbSkip())
		EndDo
	EndIf
	
	// Inclui alcada de aprovacao
	cDoc     := CN9->CN9_NUMERO + CN9->CN9_REVISA
	nTxMoeda := recMoeda(dDataBase,CN9->CN9_MOEDA) // Taxa da moeda
	
	MaAlcDoc({;
	CN9->CN9_NUMERO+CN9->CN9_REVISA,			;	//[1] Numero do documento
	"CT",			;   //[2] Tipo de Documento
	CN9->CN9_VLATU,	;   //[3] Valor do Documento
	"",				; 	//[4] Codigo do Aprovador
	CN9->CN9_XCODUS,;   //[5] Codigo do Usuario
	CN9->CN9_APROV ,;	//[6] Grupo do Aprovador
	"",				;   //[7] Aprovador Superior
	CN9->CN9_MOEDA,	;   //[8] Moeda do Documento
	nTxMoeda,		;   //[9] Taxa da Moeda
	dDataBase,		;   //[10] Data de Emis.Doc.
	""}				;	//[11] Grupo de Compras
	,dDataBase,1,"",.F.)
	
	
	// Pedro inseriu o bloco abaixo para colocoar a revisao com status de "Em aprovacao"
	RecLock("CN9", .F.)
	CN9->CN9_XSTREV := "2"
	CN9->CN9_XCODUS := __cUserID
	MsUnlock()
	RestArea(aSavAre)
	Return(.F.)
Else
	Aviso("Aprovação Revisão", "Revisão não enviada para Aprovação", {" Ok "})
	Return(.F.)
Endif

Return


	
