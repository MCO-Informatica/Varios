#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M030INC º Autor ³ Luiz Alberto     º Data ³ 30/11/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada Responsavel na Replicacao do Cadastro do Cliente
				Entre Empresas.
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
User Function TMK260OK()
Local aArea := GetArea()
Local nOpcao:= PARAMIXB[1]

If nOpcao == 3	// Inclusao
	If Empty(M->US_FILREL)	// Relacionamento entre Filiais
		If SA1->(dbSetOrder(3), dbSeek(xFilial("SA1")+Left(M->US_CGC,8))) .And. SA1->A1_TIPO <> 'X'
			MsgStop("Atenção Existem Filial Cadastrada Neste Sistema Para Esse Prospect, Preencha o Campo Filial Relacionada com o Codigo: " + SA1->A1_COD)
			Return .f.
		Endif
	Endif
Endif

If M->US_MIDIA $ GetNewPar("MV_MIDIND",'000002*000052') .And. Empty(M->US_INDCLI) 
	MsgStop("Atenção No Caso de Midias com Indicação de Clientes, Favor Informar o Código de Cliente Indicação ! ")
	Return .f.
Endif                                      

If nOpcao == 4 
	If M->US_MIDIA <> SUS->US_MIDIA .And. !Empty(SUS->US_MIDIA)
		MsgStop("Atenção Não é Permitida Alteração de Midia ! - Conteudo Gravado: " + SUS->US_MIDIA + " - Conteudo Alterado: " + M->US_MIDIA)
		Return .F.
	Endif
Endif
RestArea(aArea)
Return .t.
	

