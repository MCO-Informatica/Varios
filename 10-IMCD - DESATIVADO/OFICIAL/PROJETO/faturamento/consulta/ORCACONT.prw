#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ORCACONT  � Autor � Junior Carvalho    � Data �  28/12/2017 ���
�������������������������������������������������������������������������͹��
��� Descricao� Mostra os Contatos do cliente selecinado CJ_CLEINTE+CJ_LOJA���
���          � Campo - CJ_XCODCON / Gatilho - CNTSCJ                      ���
���          � Campo - C5_XCONTAT / Gatilho - CNTSCJ                      ���
�������������������������������������������������������������������������͹��
��� Uso      � ORCAMENTOS MATA415  / PEDIDO DE VENDA MATA410              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function ORCACONT() //CONTATO NO ROCAMENTO SCJ
	Local oLbx							 					//Listbox com os nomes dos contatos
	Local aCont		:= {}									//Array com os contatos
	Local cDFuncao	:= CRIAVAR("U5_FUNCAO",.F.)				//Funcao do contato na empresa
	Local cCliente	:= ""									//Codigo do cliente
	Local cLoja		:= ""									//Loja do cliente
	Local cDesc		:= ""									//Decricao do cliente
	Local cEntidade	:= "SA1"									//Alias da entidade
	Local nOpcao	:= 0									//Opcao
	Local nContato	:= 0									//Posicao do contato dentro do array na selecao
	Local oDlg												//Tela
	Local lRet		:= .F.									//Retorno da tela

	IF IsInCallStack("MATA410")
		cCliente := M->C5_CLIENTE
		cLoja    := M->C5_LOJACLI
	ELSEIF IsInCallStack("MATA415")
		cCliente := M->CJ_CLIENTE
		cLoja    := M->CJ_LOJA
	ELSE
		Help(" ",1,"SEM CLIENT")
		Return(lRet)
	ENDIF

	cDesc    := Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_NREDUZ")

	If Empty(cCliente)
		Help(" ",1,"SEM CLIENT")
		Return(lRet)
	Endif

	DbSelectArea("AC8")
	DbSetOrder(2)		//AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
	If DbSeek(xFilial("AC8") + cEntidade + xFilial(cEntidade) + cCliente + cLoja)

		While (!Eof())										.AND.;
		(AC8->AC8_FILIAL == xFilial("AC8")) 			.AND.;
		(AC8->AC8_ENTIDA == cEntidade)			 	.AND.;
		(AC8->AC8_FILENT == xFilial(cEntidade)) 		.AND.;
		(AllTrim(AC8->AC8_CODENT) == AllTrim(cCliente + cLoja))

			DbSelectArea("SU5")
			DbSetOrder(1)
			If DbSeek(xFilial("SU5") + AC8->AC8_CODCON)

				cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")

				Aadd(aCont, {	SU5->U5_CODCONT,;		//C�digo
				SU5->U5_CONTAT,;		//Nome
				cDFuncao,;				//Fun��o
				SU5->U5_FONE,;			//Telefone
				SU5->U5_OBS;			//Observacao
				} )

			Else
				Aadd(aCont,{"","","","",""})
			Endif
			DbSelectArea("AC8")
			DbSkip()
		End

		If Len(aCont) == 0
			Aadd(aCont,{"","","","",""})
		EndIf

	Else

		If Len(aCont) == 0
			Aadd(aCont,{"","","","",""})
		EndIf
//		lRet := .T.
//		Return(lRet)
	Endif

	//��������������������������������������������������������������Ŀ
	//� Mostra dados dos Contatos 								     �
	//����������������������������������������������������������������
	DEFINE MSDIALOG oDlg FROM  48,171 TO 230,800 TITLE "Cadastro de Contatos" + " - " + cDesc PIXEL

	@  3,2 TO  73, 310 LABEL "Cadastro de Contatos :" OF oDlg  PIXEL

	@ 10,5	LISTBOX oLbx FIELDS ;
	HEADER ;
	"C�digo",;
	"Nome",;
	"Fun��o",;
	"Telefone",;
	"Observa��o";
	SIZE 303,60  NOSCROLL OF oDlg PIXEL ON DBLCLICK( nOpcao:= 1,nContato := oLbx:nAt,oDlg:End() )

	oLbx:SetArray(aCont)
	oLbx:bLine:={ || {	aCont[oLbx:nAt,1],;	//C�digo
	aCont[oLbx:nAt,2],;	//Nome
	aCont[oLbx:nAt,3],;	//Fun��o
	aCont[oLbx:nAt,4],;	//Telefone
	aCont[oLbx:nAt,5];	//Observacao
	}}

	DEFINE SBUTTON FROM 74,162 TYPE 4	ENABLE OF oDlg ACTION TkIncCt(	@oLbx, @aCont, .F.	, cEntidade, cCliente, cLoja, cDesc )

	DEFINE SBUTTON FROM 74,192 TYPE 11	ENABLE OF oDlg ACTION TkAltCt(@oLbx,1,@aCont,cCliente,cLoja)
	DEFINE SBUTTON FROM 74,222 TYPE 15	ENABLE OF oDlg ACTION TkVisCt(oLbx,1,@aCont,cCliente,cLoja)

	DEFINE SBUTTON FROM 74,252 TYPE 1	ENABLE OF oDlg ACTION (nOpcao:= 1,nContato:= oLbx:nAt,oDlg:End())
	DEFINE SBUTTON FROM 74,282 TYPE 2	ENABLE OF oDlg ACTION (nOpcao:= 0,oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED

	//�������������������������������������������������������������������������������Ŀ
	//�Posiciona no registro correto para ser atualizado o campo de codigo do contato.�
	//���������������������������������������������������������������������������������
	DbSelectArea("SU5")
	DbSetOrder(1)
	If (nOpcao == 1)
		lRet := .T.
		DbSeek(xFilial("SU5") + aCont[nContato,1])
	Endif

Return(lRet)

Static Function TkIncCt(oLbx	, aCont	, lNovo	, cEntidade	,cCliente, cLoja	, cDesc)

	Local aArea   		:= GetArea()							// Salva a area atual
	Local nOpca     	:= 0									// Opcao de OK ou CANCELA
	Local cDFuncao  	:= CRIAVAR("U5_FUNCAO",.F.)		  		// Cargo da funcao do contato
	Local cAlias    	:= "SA1"	// Alias
	Local lIncluiAnt	:= INCLUI                          		// Guarda o conteudo da variavel para restaurar apos a inclusao do contato
	Local lFilSU5		:= .T.

	Private cCadastro 	:=  "Inclus�o de Contatos"

	//�������������������������������������������������������������������������������������Ŀ
	//�Na Inclusao, a variavel INCLUI devera estar como .T.  para executar  o inicializador �
	//�padrao de alguns campos que sao preenchidos somente se a variavel estiver .T. 		�
	//���������������������������������������������������������������������������������������
	INCLUI:= .T.

	DbSelectArea("SU5")
	nOpcA := A70INCLUI("SU5",0,3)

	//�������������������������������������������Ŀ
	//�Restauva a variavel com o conteudo original�
	//���������������������������������������������
	INCLUI:= lIncluiAnt

	If (nOpca == 1)
		DbSelectArea("AC8")
		RecLock("AC8",.T.)
		REPLACE AC8_FILIAL With xFilial("AC8")
		REPLACE AC8_FILENT With xFilial(cEntidade)
		REPLACE AC8_ENTIDA With cEntidade
		REPLACE AC8_CODENT With cCliente + cLoja
		REPLACE AC8_CODCON With SU5->U5_CODCONT
		MsUnLock()
		DbCommit()
	Endif

	// Se houve inclusao do registro atualizo o listbox de contatos
	If nOpcA == 1

		//������������������������������������������������������Ŀ
		//�Se esse � o primeiro contato a ser cadastrado fecho a �
		//�tela e abro novamente para a cria��o do objeto listbox�
		//��������������������������������������������������������
		If lNovo
			ORCACONT()
			Return(nOpcA)
		Endif

		aCont := {}

		DbSelectArea("AC8")
		DbSetOrder(2)
		If DbSeek(xFilial("AC8") + cAlias + xFilial(cAlias) + cCliente + cLoja,.T.)

			While (!Eof()) 								.AND. ;
			(AC8->AC8_FILIAL == xFilial("AC8")) 	.AND.;
			(AC8->AC8_ENTIDA == cAlias) 			.AND.;
			(AC8->AC8_FILENT == xFilial(cAlias)) .AND. ;
			(AllTrim(AC8->AC8_CODENT) == AllTrim(cCliente + cLoja))

				DbSelectArea("SU5")
				DbSetOrder(1)
				If DbSeek(xFilial("SU5") + AC8->AC8_CODCON)
					If lFilSU5
						cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")

						Aadd(aCont,{SU5->U5_CODCONT,;		//C�digo
						SU5->U5_CONTAT,;		//Nome
						cDFuncao,;				//Fun��o
						SU5->U5_FONE,;			//Telefone
						SU5->U5_OBS} )			//Observacao
					EndIf
				Else
					Aadd(aCont,{"","","","",""})
				Endif

				DbSelectArea("AC8")
				DbSkip()
			End
		Endif

		oLbx:SetArray(aCont)
		oLbx:nAt:= Len(aCont)
		oLbx:bLine:={||{aCont[oLbx:nAt,1],;  //C�digo
		aCont[oLbx:nAt,2],;  //Nome
		aCont[oLbx:nAt,3],;	 //Fun��o
		aCont[oLbx:nAt,4],;	 //Telefone
		aCont[oLbx:nAt,5] }} //Observacao
		oLbx:Refresh()
	Endif

	RestArea(aArea)
Return(nOpcA)



Static Function TkAltCt(oLbx, nPos	, aCont, cCliente, cLoja )

	Local aArea		  := GetArea()						// Salva a area atual
	Local cCod	      := ""								// Codigo do contato
	Local cDFuncao    := ""								// Cargo do contato
	Local cAlias	  := "SA1"					// Alias
	Local nOpcA       := 0						// Opcao de retorno OK ou CANCELA
	Local aRots       := aClone(aRotina)        // Copia do array aRotina
	Local lRet		  := .T.					// Retorno da funcao
	Local lFilSU5	  := .T.

	Private cCadastro := "Altera��o de Contatos" 	//Private para compatibilizacao com a funcao AXaltera
	Private lRefresh  := .T.

	//������������������������������������������������������������������������������Ŀ
	//� A ocorrencia 82 (ACS), verifica se o usu�rio poder� ou n�o alterar cadastros �
	//��������������������������������������������������������������������������������
	If !ChkPsw(82)
		HELP(" ",1,"TMKACECAD")
		lRet := .F.
		Return(lRet)
	Endif

	cCod := Eval(oLbx:bLine)[nPos]

	DbSelectArea("SU5")
	DbSetOrder(1)
	If DbSeek(xFilial("SU5")+ cCod)

		BEGIN TRANSACTION

			aRotina:={}
			aRotina		:= MenuDef()

			If lRet
				nOpcA:=A70ALTERA("SU5",RECNO(),4)
			Endif

			aRotina:= aClone(aRots)

		END TRANSACTION

		//�������������������������������������������������������������Ŀ
		//�Se houve altera�ao do registro atualizo o listbox de contatos�
		//���������������������������������������������������������������
		If nOpcA == 1
			lRet  := .T.
			aCont := {}
			DbSelectArea("AC8")
			DbSetOrder(2)
			If DbSeek(xFilial("AC8") + cAlias + xFilial(cAlias) + cCliente + cLoja,.T.)
				While (!Eof()) 							  	.AND.;
				(AC8->AC8_FILIAL == xFilial("AC8")) 	.AND.;
				(AC8->AC8_ENTIDA == cAlias) 		  	.AND.;
				(AC8->AC8_FILENT == xFilial(cAlias))	.AND.;
				(AllTrim(AC8->AC8_CODENT) == AllTrim(cCliente + cLoja))

					DbSelectArea("SU5")
					DbSetOrder(1)
					If DbSeek(xFilial("SU5") + AC8->AC8_CODCON)

						If lFilSU5
							cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")
							Aadd(aCont,{SU5->U5_CODCONT,;		//C�digo
							SU5->U5_CONTAT,;		//Nome
							cDFuncao,;				//Fun��o
							SU5->U5_FONE,;			//Telefone
							SU5->U5_OBS} )			//Observacao
						EndIf
					Else
						Aadd(aCont,{"","","","",""})
					Endif

					DbSelectArea("AC8")
					DbSkip()
				End
			Endif

			oLbx:SetArray(aCont)
			oLbx:bLine:={||{aCont[oLbx:nAt,1],;  //C�digo
			aCont[oLbx:nAt,2],;  //Nome
			aCont[oLbx:nAt,3],;	 //Fun��o
			aCont[oLbx:nAt,4],;	 //Telefone
			aCont[oLbx:nAt,5] }} //Observacao
			oLbx:Refresh()

		Endif
	Endif

	RestArea(aArea)

Return(lRet)


Static Function TkVisCt(oLbx	, nPos	, aCont	, cCliente	,;
	cLoja	)

	Local cAliasOld   := Alias()
	Local cCod		  := ""
	Private cCadastro := "Visualiza��o de Contatos"

	cCod := Eval(oLbx:bLine)[nPos]
	DbSelectArea("SU5")
	DbSetOrder(1)

	If DbSeek(xFilial("SU5")+ cCod)
		//��������������������������������������������Ŀ
		//� Envia para processamento dos Gets          �
		//����������������������������������������������
		A70Visual("SU5",RECNO(), 2)
	Endif

	DbSelectArea(cAliasOld)
Return(.T.)

Static Function MenuDef()

	Local aRotina:= {		{ "Pesquisar"  ,"AxPesqui"        ,0 ,1 , , .F. },;
	{ "Visualizar"  ,"TK271CallCenter" ,0 ,2 , , .T. },;
	{ "Incluir"  ,"TK271CallCenter" ,0 ,3 , , .T. },;
	{ "Alterar"  ,"TK271CallCenter" ,0 ,4 , , .T. }}

Return(ARotina)
