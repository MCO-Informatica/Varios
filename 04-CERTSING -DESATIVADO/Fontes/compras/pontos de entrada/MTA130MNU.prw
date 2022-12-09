#Include 'Protheus.ch'


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma:  ³MTA130MNU ºAutor: ³David Alves dos Santos ºData: ³05/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao: ³Ponto de entrada para adicionar opcoes no menu do MarkBrowse.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso:       ³Certisign - Certificadora Digital.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MTA130MNU()

	//-- Adiciona a opcao de rejeitar a SC.
	AAdd(aRotina, {"Rejeitar", "u_MT130Mot()",0,5,0,Nil})

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma:  ³MT130Rej  ºAutor: ³David Alves dos Santos ºData: ³06/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao: ³Funcao utilizada para fazer a rejeicao da SC.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso:       ³Certisign - Certificadora Digital.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT130Mot()

	Local oConfirm
	Local oCancel
	Local oGtMotiv
	Local cMotivo := ""
	Local oLblMot

	Static oDlg

	// +--------------------------------------------------------------------------------------+
	// | Monta janela para o usuario informar o motivo da rejeicao da solicitacao de compras. |
	// +--------------------------------------------------------------------------------------+
  	DEFINE MSDIALOG oDlg TITLE "Motivo da rejeição" FROM 000, 000  TO 200, 400 COLORS 0, 16777215 PIXEL
	
    	@ 015, 004 GET oGtMotiv VAR cMotivo MEMO SIZE 190,057 PIXEL OF oDlg
    	@ 080, 004 BUTTON oConfirm PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION {|| MT130Rej(cMotivo), oDlg:End()} PIXEL
    	@ 006, 004 SAY oLblMot PROMPT "Informe o motivo da rejeição:" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
    	@ 080, 053 BUTTON oCancel PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL
	
  	ACTIVATE MSDIALOG oDlg CENTERED
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma:  ³MT130Rej  ºAutor: ³David Alves dos Santos ºData: ³06/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao: ³Funcao utilizada para fazer a rejeicao da SC.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso:       ³Certisign - Certificadora Digital.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MT130Rej(cMotivo)

	Local aArea    := GetArea()
	Local cTmp     := GetNextAlias()
	Local cPara    := ""
	Local cAssunto := ""
	Local cCorpo   := ""
	Local cHtml    := ""
	
	//-- Verifica se o usuario deseja realmente rejeitar a solicitacao de compras.
	If MsgYesNo("Deseja rejeitar os itens selecionados?","ATENÇÃO","YESNO")
		
		//+------------------------------------------------+
		//| Verifica se a tabela esta sendo usada          |
		//| se sim sera fechada para nao occorer conflito. |
		//+------------------------------------------------+
		If Select(cTmp) > 0
			(cTmp)->(dbCloseArea())				
		EndIf

		//-- Execucao da query.
		BeginSql Alias cTmp
			Select Distinct
					C1_FILIAL,
					C1_NUM
			From %Table:SC1% SC1
			Where 	SC1.%NotDel% And
					SC1.C1_OK	= %Exp:cMarca% And
					SC1.C1_APROV <> 'R'
		EndSql

		//-- Caso o usuario nao selecione a solicitacao apresenta mensagem de erro.
		If (cTmp)->(Eof())
			MsgStop("Nenhum registro foi selecionado. Favor selecionar os registros que deseja rejeitar.")
		Else
			//-- Varrendo o resultado da query.
			(cTmp)->(dbGoTop())
			While (cTmp)->(!Eof())

				//-- Procura na SC1 conforme tabela temporaria.
				If SC1->(DbSeek(xFilial("SC1") + (cTmp)->(C1_NUM)))

					//-- Alimenta as variaveis que serao passadas por parametro.
					cCorpo   := ""
					cPara    := AllTrim(SC1->C1_SOLICIT) + "@certisign.com.br"
					cAssunto := "Solicitacao de Compras Rejeitada"

					//-- Atualiza o status de aprovacao para todos os itens da solicitacao.
					While SC1->(!Eof()) .And. SC1->C1_NUM == (cTmp)->(C1_NUM)
						If SC1->C1_APROV == "L" 
							RecLock("SC1", .F.)
								SC1->C1_APROV := "R"
							MsUnLock()
						EndIf
						SC1->(dbSkip())
					EndDo
					
					//-- Montagem do corpo do e-mail.
					cCorpo := "<br><p>"
					cCorpo += "	Segue abaixo informações detalhadas:<br>"
					cCorpo += "	A solicitação de compras: "    + (cTmp)->(C1_NUM)   + " foi rejeitada por: <br><br>"
					cCorpo += "	<strong>Usuario .:</strong> "  + AllTrim(cUserName) + "<br>"
					cCorpo += "	<strong>E-mail ...:</strong> " + AllTrim(cUserName) + "@certisign.com.br <br><br><br>"
					cCorpo += "	<strong>Motivo:</strong><br>"
					cCorpo += "	" + cMotivo + "<br><br><br>"					
					cCorpo += "</p>"
					
					//-- Retorna o HTML completo concatenando o corpo do e-mail.
					cHtml := u_CSModHtm(cCorpo)

					//-- Realiza o envio do e-mail.
					FSSendMail( cPara, cAssunto, cHtml )
					
				EndIf         	
				
				//-- Proximo registro.				
				(cTmp)->(dbSkip())
				
			EndDo
		EndIf

	EndIf

	RestArea(aArea)

Return