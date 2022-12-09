#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M030INC � Autor � Luiz Alberto     � Data � 30/11/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Responsavel na Replicacao do Cadastro do Cliente
				Entre Empresas.
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 
User Function TMK260OK()
Local aArea := GetArea()
Local nOpcao:= PARAMIXB[1]

If nOpcao == 3	// Inclusao
	If Empty(M->US_FILREL)	// Relacionamento entre Filiais
		If SA1->(dbSetOrder(3), dbSeek(xFilial("SA1")+Left(M->US_CGC,8))) .And. SA1->A1_TIPO <> 'X'
			MsgStop("Aten��o Existem Filial Cadastrada Neste Sistema Para Esse Prospect, Preencha o Campo Filial Relacionada com o Codigo: " + SA1->A1_COD)
			Return .f.
		Endif
	Endif
Endif

If M->US_MIDIA $ GetNewPar("MV_MIDIND",'000002*000052') .And. Empty(M->US_INDCLI) 
	MsgStop("Aten��o No Caso de Midias com Indica��o de Clientes, Favor Informar o C�digo de Cliente Indica��o ! ")
	Return .f.
Endif                                      

If nOpcao == 4 
	If M->US_MIDIA <> SUS->US_MIDIA .And. !Empty(SUS->US_MIDIA)
		MsgStop("Aten��o N�o � Permitida Altera��o de Midia ! - Conteudo Gravado: " + SUS->US_MIDIA + " - Conteudo Alterado: " + M->US_MIDIA)
		Return .F.
	Endif
Endif
RestArea(aArea)
Return .t.
	

