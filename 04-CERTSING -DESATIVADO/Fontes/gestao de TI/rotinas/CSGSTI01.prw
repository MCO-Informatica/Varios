#Include 'Totvs.ch'
#Include 'Protheus.ch'


Static cCodFun := Space( Len(U00->U00_CODFUN) )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัอออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:    ณGSTCE001 บAutor: ณDavid Alves dos Santos บData: ณ23/08/2016 บฑฑ
ฑฑฬอออออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao:   ณTela de consulta especifica para tabela de Funcionarios.    บฑฑ
ฑฑฬอออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบNomenclatura ณCS   = Certisign.                                           บฑฑ
ฑฑบdo codigo    ณGSTI = Modulo especifico SIGAESP (Gestao de TI).            บฑฑ
ฑฑบfonte.       ณ01   = Numero sequencial.                                   บฑฑ
ฑฑฬอออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:         ณCertisign - Certificadora Digital.                          บฑฑ
ฑฑศอออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
		MsgInfo('Aten็ใo, ' + CRLF + 'Nใo consta contato cadastrado para este ' +;
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


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณGST01Psq บAutor: ณDavid Alves dos Santos บData: ณ23/08/2016 บฑฑ
ฑฑฬอออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRotina para pesquisar a informacao digitada e posicionar.   บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                          บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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
			MsgStop('Registro nใo localizado.','Pesquisar')
		EndIf
	Else
		MsgStop('Op็ใo de pesquisa invแlida.',cCadastro)
	EndIf
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณGST01Cod บAutor: ณDavid Alves dos Santos บData: ณ23/08/2016 บฑฑ
ฑฑฬอออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRotina para retornar o codigo do funcionario conforme       บฑฑ
ฑฑบ           ณo posicionamento.                                           บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                          บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัอออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณGSTCERet บAutor: ณDavid Alves dos Santos บData: ณ23/08/2016 บฑฑ
ฑฑฬอออออออออออุอออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณMatricula do funcionario no retorno da consulta padrao.     บฑฑ
ฑฑฬอออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                          บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function CSGSTIRet()
Return( cCodFun )