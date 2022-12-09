#Include 'Totvs.ch'
#Include 'Protheus.ch'


Static cCodFun := Space( Len(U00->U00_CODFUN) )

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:    �GSTCE001 �Autor: �David Alves dos Santos �Data: �23/08/2016 ���
����������������������������������������������������������������������������͹��
���Descricao:   �Tela de consulta especifica para tabela de Funcionarios.    ���
����������������������������������������������������������������������������͹��
���Nomenclatura �CS   = Certisign.                                           ���
���do codigo    �GSTI = Modulo especifico SIGAESP (Gestao de TI).            ���
���fonte.       �01   = Numero sequencial.                                   ���
����������������������������������������������������������������������������͹��
���Uso:         �Certisign - Certificadora Digital.                          ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function CSGSTI01()
	
	Local cSQL     := ''
	Local cTRB     := ''
	Local cCODENT  := ''
	Local cEntida  := ''
	Local cNomeEnt := ''
	Local cOrdem   := ''
	Local cRet     := ''
	Local cSeek    := Space(60)
	Local nOrd     := 2
	Local nOpc     := 0
	Local aDados   := {}
	Local aOrdem   := {}
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oSeek
	Local oPesq
	Local oPnlTop
	Local oPnlAll
	Local oPnlBot
	Local ONOMRK
	Local oMrk
	
	Private cCadastro := 'Contatos - Corporativo'
		
	AAdd( aOrdem, 'Matricula' )
	
	//-- Montagem da query.
	cSQL += "SELECT RA_FILIAL," 
	cSQL += "       RA_MAT, " 
	cSQL += "       RA_NOME,  " 
	cSQL += "       R_E_C_N_O_" 
	cSQL += "FROM  " + RetSqlName("SRA") + " "
	cSQL += "WHERE  D_E_L_E_T_ = ' ' "
	cSQL += "AND RA_SITUAC != 'D' "
	//cSQL += "   AND RA_FILIAL = '" + xFilial("SRA") + "' "
	cSQL += "ORDER  BY RA_MAT"
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
	If (cTRB)->( !Eof() )
		While (cTRB)->( !Eof() )
			(cTRB)->( AAdd( aDados, { (cTRB)->RA_FILIAL, (cTRB)->RA_MAT, (cTRB)->RA_NOME, (cTRB)->R_E_C_N_O_  } ) )
			(cTRB)->( dbSkip() )
		End
	Else
		MsgInfo('Aten��o, ' + CRLF + 'N�o consta contato cadastrado para este ' +;
			   '. Por favor inclua um contato do tipo Corporativo.','Contatos')
		AAdd( aDados, { '', '', '', ''  } )	
	EndIf
	(cTRB)->(dbCloseArea())
	
	//-- Montagem da tela que sera apresentado para o usuario no momento da acao da tecla F3.
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 308,770 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
	   
	   oDlg:lEscClose := .F.
		
	   oPnlTop       := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
	   oPnlTop:Align := CONTROL_ALIGN_TOP
		
	   @ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
	   @ 1,082 MSGET    oSeek  VAR cSeek          SIZE 160,9 PIXEL OF oPnlTop
	   @ 1,247 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 50,11 PIXEL OF oPnlTop ACTION (GST01Psq(nOrd,cSeek,@oLbx))
		
	   oPnlAll := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
	   oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
	   oPnlBot := TPanel():New( 0, 0, '', oDlg, Nil, .F.,,,, 0, 14, .F., .T. )
	   oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		
	   oLbx := TwBrowse():New( 0, 0, 1000, 1020,, {'Filial', 'Matricula', 'Nome'},, oPnlAll,,,,,,,,,,,, .F.,, .T.,, .F. )
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:SetArray( aDados )
	   oLbx:bLine := {|| { aDados[oLbx:nAt,1], aDados[oLbx:nAt,2], aDados[oLbx:nAt,3], '' } }

	   oLbx:bLDblClick := {|| Iif(GST01Cod(oLbx,@nOpc,@cRet,oLbx:nAt),oDlg:End(),Nil) }
	   
	   @ 1,001 BUTTON oConfirm PROMPT 'OK'   SIZE 40,11 PIXEL OF oPnlBot ACTION Iif( GST01Cod(oLbx,@nOpc,@cRet,oLbx:nAt), oDlg:End(), Nil )
	   @ 1,044 BUTTON oCancel  PROMPT 'Sair' SIZE 40,11 PIXEL OF oPnlBot ACTION ( cCodFun := '', oDlg:End() )
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpc == 1
		cCodFun := cRet
	EndIf
		
Return( .T. )


/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa:  �GST01Psq �Autor: �David Alves dos Santos �Data: �23/08/2016 ���
��������������������������������������������������������������������������͹��
���Descricao: �Rotina para pesquisar a informacao digitada e posicionar.   ���
��������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function GST01Psq( nOrd,cPesq,oLbx )
	
	Local bAScan := {|| .T. }
	Local nCol   := nOrd
	Local nBegin := nEnd := nP := 0
	
	cPesq := Upper( AllTrim( cPesq ) )
		
	If nCol > 0
		nBegin := Min( oLbx:nAt, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:aArray )
		
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		EndIf
		
		bAScan := {|p| Upper(AllTrim( cPesq ) ) $ AllTrim( p[nCol] ) } 
		
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
		
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		Else
			MsgStop('Registro n�o localizado.','Pesquisar')
		EndIf
	Else
		MsgStop('Op��o de pesquisa inv�lida.',cCadastro)
	EndIf
	
Return


/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa:  �GST01Cod �Autor: �David Alves dos Santos �Data: �23/08/2016 ���
��������������������������������������������������������������������������͹��
���Descricao: �Rotina para retornar o codigo do funcionario conforme       ���
���           �o posicionamento.                                           ���
��������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function GST01Cod( oLbx, nOpc, cRet, nLin )
	
	Local lRet := .T.
	
	cRet := AllTrim( oLbx:aArray[nLin,2] )
	nOpc := Iif( lRet, 1, 0 )
	M->U00_NOMFUN := AllTrim( oLbx:aArray[nLin,3] )
	
	SRA->(DbSetOrder(1))
	If SRA->(DbSeek(AllTrim( oLbx:aArray[nLin,1])+AllTrim(oLbx:aArray[nLin,2])))
		M->U00_MAILFU := SRA->RA_EMAIL
	Endif
	
Return( lRet )


/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa:  �GSTCERet �Autor: �David Alves dos Santos �Data: �23/08/2016 ���
��������������������������������������������������������������������������͹��
���Descricao: �Matricula do funcionario no retorno da consulta padrao.     ���
��������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function CSGSTIRet()
Return( cCodFun )