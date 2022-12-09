#INCLUDE "PROTHEUS.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA100   ºAutor  ³Microsiga           º Data ³  05/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao criada para fazer a amarracao de contato e cliente   º±±
±±º          ³cadastrados no site, via pedido.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OPVS Consultores Associados                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA100(cTabela, cCliente, cLjCli, cContato)

Local lRet			:= .T.
Local cMsg			:= ""

Private lMsErroAuto := .F.   

DbSelectArea("AC8")
AC8->(DbSetOrder(1))
If AC8->(!DbSeek(xFilial("AC8") + cContato + cTabela + xFilial("SA1") + cCliente + cLjCli))		// Caso o sistema nao ache a amarracao entre contato e cliente, cria a mesma
	//Faco a alteracao na mao, pois a execauto na alteracao desposiciona do registro da tabela SU5
	RecLock("AC8", .T.)
		AC8->AC8_FILIAL	:= xFilial("AC8")		// Filial da amarracao
		AC8->AC8_FILENT	:= xFilial("SA1")  		// Filial do cadastro de cliente
		AC8->AC8_ENTIDA	:= cTabela    			// Tabela que se refere a amarracao
		AC8->AC8_CODENT	:= cCliente + cLjCli 	// Codigo da entidade cCliente + cLjCli (codigo + loja do cliente)
		AC8->AC8_CODCON	:= cContato    			// Estado do contato
	AC8->(MsUnLock())
EndIf

If lMsErroAuto
	MOSTRAERRO("\system\", "erro_contato.txt")
	DisarmTransaction()
	lRet := .F.
	cMsg := 'Contato não pôde ser incluído.'
Else
	cMsg := 'Contato incluído com sucesso'
EndIf

Return