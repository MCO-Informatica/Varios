#include 'totvs.ch'
#Include 'Protheus.ch'
#Include 'ApWizard.ch'

Static cAD9_CODCON := Space( Len(AD9->AD9_CODCON) )
//-------------------------------------------------------------------------
// Rotina | CSCRM020     | Autor | Rafael Beghini     | Data | 28.03.2016
//-------------------------------------------------------------------------
// Descr. | Realiza filtro na tabela de contatos somente do tipo Corporativo
//        | Utilizado na rotina de Oportunidades(Contatos)
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
User Function CSCRM020()
	Local cSQL     := ''
	Local cTRB     := ''
	
	Private cCODENT   := ''
	Private cEntida   := ''
	Private cNomeEnt  := ''
	Private cCadastro := 'Contatos - Corporativo'
	Private aDados    := {}
	Private oLbx
	Private oPnlAll
		
	IF .NOT. Empty( M->AD1_CODCLI )
		cEntida  := 'SA1'
		cNomeEnt := 'cliente'
		cCODENT  := M->AD1_CODCLI+M->AD1_LOJCLI
	ElseIF .NOT. Empty( M->AD1_PROSPE )
		cEntida  := 'SUS'
		cNomeEnt := 'prospect'
		cCODENT  := M->AD1_PROSPE+M->AD1_LOJPRO
	Else
		MsgAlert('Informe o cliente ou prospect para a consulta.')
		Return( .T. )
	EndIF
	
	cSQL += "SELECT U5_CODCONT,"
	cSQL += "       U5_CONTAT, "
	cSQL += "       U5_EMAIL,  "
	cSQL += "       U5_FCOM1,  "
	cSQL += "       U5_XCARGO, "
	cSQL += "       U5_XDEPTO, "
	cSQL += "       SU5.R_E_C_N_O_"
	cSQL += "FROM  "+RetSqlName("SU5")+" SU5 "
	cSQL += "       INNER JOIN "+RetSqlName("AC8")+" AC8 "
	cSQL += "               ON AC8_FILIAL = '  ' "
	cSQL += "                  AND AC8_FILENT = '  '"
	cSQL += "                  AND AC8_ENTIDA = '" + cEntida + "'
	cSQL += "                  AND AC8_CODENT = '" + cCODENT + "'
	cSQL += "                  AND AC8_CODCON = U5_CODCONT"
	cSQL += "                  AND AC8.D_E_L_E_T_ = ' ' "
	cSQL += "WHERE  SU5.D_E_L_E_T_ = ' ' "
	cSQL += "       AND U5_TIPOCON = '1' "
	cSQL += "ORDER  BY U5_CODCONT "
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY( , , cSQL ), cTRB, .F., .T. )
	
	oLbx := TwBrowse():New(0,0,1000,1020,,{'Código','Nome','E-mail','Telefone','Cargo','Departamento'},,oPnlAll,,,,,,,,,,,,.F.,,.T.,,.F.)
	
	IF .NOT. (cTRB)->( EOF() )
		While .NOT. (cTRB)->( EOF() )
			(cTRB)->( AAdd( aDados, { (cTRB)->U5_CODCONT,;
										rTrim((cTRB)->U5_CONTAT),;
										rTrim((cTRB)->U5_EMAIL),;
										rTrim((cTRB)->U5_FCOM1),;
										rTrim((cTRB)->U5_XCARGO),;
										rTrim((cTRB)->U5_XDEPTO),;
										(cTRB)->R_E_C_N_O_  } ) )
			(cTRB)->( dbSkip() )
		End
		
		A020Show()
	Else
		AAdd( aDados, { '', '', '', '', '', '', ''  } )
		
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDados )
		oLbx:bLine := {|| { aDados[oLbx:nAt,1], aDados[oLbx:nAt,2], aDados[oLbx:nAt,3], aDados[oLbx:nAt,4], aDados[oLbx:nAt,5], aDados[oLbx:nAt,6], '' } }
	   
		IF A020IncCto( cEntida, cCODENT, '1', oLbx )
			A020Show()
		EndIF
	EndIF
	(cTRB)->(dbCloseArea())
	
	
Return( .T. )

Static Function A020Show()
	Local cOrdem   := ''
	Local cRet     := ''
	Local cSeek    := Space(60)
	Local nOrd     := 1
	Local nOpc     := 0
	Local aOrdem   := {}
	Local oDlg
	//Local oLbx
	Local oOrdem
	Local oSeek
	Local oPesq
	Local oPnlTop
	//Local oPnlAll
	Local oPnlBot
	
	AAdd( aOrdem, 'Nome' )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 400,800 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
			
		oPnlTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlTop:Align := CONTROL_ALIGN_TOP
			
		@ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPnlTop
		@ 1,247 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 50,11 PIXEL OF oPnlTop ACTION (A020Pesq(nOrd,cSeek,@oLbx))
			
		oPnlAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
			
		oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM
			
		oLbx := TwBrowse():New(0,0,1000,1020,,{'Código','Nome','E-mail','Telefone','Cargo','Departamento'},,oPnlAll,,,,,,,,,,,,.F.,,.T.,,.F.)
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDados )
		oLbx:bLine := {|| { aDados[oLbx:nAt,1], aDados[oLbx:nAt,2], aDados[oLbx:nAt,3], aDados[oLbx:nAt,4], aDados[oLbx:nAt,5], aDados[oLbx:nAt,6], '' } }
	
		oLbx:bLDblClick := {|| Iif(A020Seek(oLbx,@nOpc,@cRet,oLbx:nAt),oDlg:End(),NIL) }
		   
		@ 1,001 BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPnlBot ACTION IIF( A020Seek(oLbx,@nOpc,@cRet,oLbx:nAt), oDlg:End(), NIL )
		@ 1,044 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPnlBot ACTION ( cAD9_CODCON := '', oDlg:End() )
		@ 1,300 BUTTON oCancel  PROMPT 'Incluir'   SIZE 40,11 PIXEL OF oPnlBot ACTION A020IncCto( cEntida, cCODENT, '2', oLbx )
		@ 1,343 BUTTON oCancel  PROMPT 'Editar'    SIZE 40,11 PIXEL OF oPnlBot ACTION A020AltCto( aDados[oLbx:nAt,7], oLbx )
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	IF nOpc == 1
		cAD9_CODCON := cRet
	EndIF
	
Return
//-------------------------------------------------------------------------
// Rotina | A010Pesq     | Autor | Rafael Beghini     | Data | 28.03.2016
//-------------------------------------------------------------------------
// Descr. | Rotina para pesquisar a informação Digitada e posicionar.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function A020Pesq( nOrd,cPesq,oLbx )
	Local bAScan := {|| .T. }
	Local nCol   := nOrd
	Local nBegin := nEnd := nP := 0
	
	cPesq := Upper( AllTrim( cPesq ) )
		
	If nCol > 0
		nBegin := Min( oLbx:nAt, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:aArray )
		
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		
		bAScan := {|p| Upper(AllTrim( cPesq ) ) $ AllTrim( p[nCol] ) }
		
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
		
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		Else
			MsgInfo('Informação não localizada.','Pesquisar')
		Endif
	Else
		MsgAlert('Opção de pesquisa inválida.',cCadastro)
	Endif
Return
//-------------------------------------------------------------------------
// Rotina | A010Seek     | Autor | Rafael Beghini     | Data | 28.03.2016
//-------------------------------------------------------------------------
// Descr. | Rotina para retornar o código do Produto conforme posicionado.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function A020Seek( oLbx, nOpc, cRet, nLin )
	Local lRet := .T.
	cRet := Alltrim( oLbx:aArray[nLin,1] )
	nOpc := Iif(lRet,1,0)
Return(lRet)
//-------------------------------------------------------------------------
// Rotina | A020IncCto   | Autor | Rafael Beghini     | Data | 28.03.2016
//-------------------------------------------------------------------------
// Descr. | Rotina para retornar o código do Produto conforme posicionado.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function A020IncCto( cEntidade,cCodEnt,cTpMsg, oLstBx )
	Local aAreaSU5 := SU5->(GetArea())
	Local aAreaAC8 := AC8->(GetArea())
	Local cCodCont := ""
	Local cContato := ""
	Local aContato := {}
	Local aRetCo := Array(2)
	Local oWizard
	Local oPanel
	Local cNOME		:= Space(30)
	Local cEMAIL	:= Space(50)
	Local cDDD		:= Space(2)
	Local cTEL		:= Space(09)
	Local cCARGO	:= Space(60)
	Local cDEPTO	:= Space(40)
	Local lRet		:= .F.
	
	Local cMessage := "Não encontramos contatos vinculados à este cliente, clique em avançar para realizar o cadastro e vínculo agora mesmo..."
	
	Private lStop := .T.
	Private aSU5 := {}
	
	aRetCo[1] := .F.
	aRetCo[2] := ''
	
	DEFINE WIZARD oWizard TITLE "Wizard - Criação Contatos" ;
		HEADER "Atualização de contato" ;
		MESSAGE "Assistente para inclusão de Contato" ;
		TEXT IIF( cTpMsg=='1', cMessage, "clique em avançar para realizar o cadastro e vínculo agora mesmo..." ) ;
		NEXT {||.T.} ;
		FINISH {|| .F. } ;
		PANEL
   
    //-- Primeira etapa
	CREATE 	PANEL oWizard ;
		HEADER "Atualização de contato" ;
		MESSAGE "Informe os dados que deseja atualizar." ;
		BACK {|| .F. } ;
		NEXT {|| .F. } ;
		FINISH {|| A020Valid({cNOME, cEMAIL, cDDD, cTEL}) } ;
		PANEL
	oPanel := oWizard:GetPanel(2)
	@ 0 ,15 SAY "* Nome" SIZE 45,8 PIXEL OF oPanel
	@ 10,15 MSGET cNOME PICTURE "@!" SIZE 160,10 PIXEL OF oPanel
   
	@ 30,15 SAY "* e-Mail" SIZE 45,8 PIXEL OF oPanel
	@ 40,15 MSGET cEMAIL PICTURE "" Valid vldEmail(cEMAIL) SIZE 160,10 PIXEL OF oPanel
   
	@ 60,15 SAY "* DDD" SIZE 45,8 PIXEL OF oPanel
	@ 70,15 MSGET cDDD PICTURE "@!" SIZE 030,10 PIXEL OF oPanel
  
	@ 60,50 SAY "* Telefone" SIZE 35,8 PIXEL OF oPanel
	@ 70,50 MSGET cTEL PICTURE "@!" SIZE 100,10 PIXEL OF oPanel
	
	@ 90,15 SAY "Cargo" SIZE 45,8 PIXEL OF oPanel
	@ 100,15 MSGET cCARGO PICTURE "@!" SIZE 160,10 PIXEL OF oPanel
   
	@ 115,15 SAY "Departamento" SIZE 45,8 PIXEL OF oPanel
	@ 125,15 MSGET cDEPTO PICTURE "@!" SIZE 160,10 PIXEL OF oPanel
              
	ACTIVATE WIZARD oWizard CENTERED
	
	IF !lStop
		FWMsgRun(,{|| aRetCo := A020CriaCto( {cNOME, cEMAIL, cDDD, cTEL, cCARGO, cDEPTO} )},,'Aguarde, criando o contato...')
	EndIF
	
	IF aRetCo[1]
		cCodCont := SU5->U5_CODCONT
		cContato := Alltrim(SU5->U5_CONTAT)
		cEMAIL   := SU5->U5_EMAIL
		cRecNo   := SU5->(RECNO())
		cTEL	 := SU5->U5_FCOM1
		
		DbSelectArea("AC8")
		DbSetOrder(1)
		//AC8_FILIAL+AC8_CODCON+AC8_ENTIDA+AC8_FILENT+AC8_CODENT
		If !DbSeek(xFilial("AC8")+cCodCont+cEntidade+xFilial(cEntidade)+cCodEnt)
			RecLock("AC8",.T.)
			REPLACE AC8_FILIAL With xFilial("AC8")
			REPLACE AC8_FILENT With xFilial(cEntidade)
			REPLACE AC8_ENTIDA With cEntidade
			REPLACE AC8_CODENT With cCodEnt
			REPLACE AC8_CODCON With cCodCont
			MsUnLock()
			
			lRet := .T.
		EndIf
		
		
		If Empty(oLstBx:aArray[1,1])
			aDel(oLstBx:aArray,1)
			aSize(oLstBx:aArray,0)
		EndIf
		
		//aAdd(oLstBx:aArray,{cCodCont,cContato,cEMAIL,cCARGO,cDEPTO,cRecNo})
		AAdd( aDados, { cCodCont, cContato, rTrim( cEMAIL ), cTEL, rTrim(SU5->U5_XCARGO), rTrim(SU5->U5_XDEPTO), SU5->(RECNO()) } )
		oLstBx:Refresh()
		lRet := .T.
	ElseIF .Not. Empty( aRetCo[ 2 ] )
		MsgAlert( aRetCo[2] )
		lRet := .F.
	EndIF
	
	RestArea(aAreaSU5)
	RestArea(aAreaAC8)
	
Return( lRet )


//-------------------------------------------------------------------------
// Rotina | vldEmail | Autor | David Alves dos Santos | Data | 29.03.2016
//-------------------------------------------------------------------------
// Descr. | Valida o campo e-mail no cadastro do contato.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function vldEmail(cEMAIL)

	Local lRet := .T.
	
	//-> Verifica se o usuário digitou um e-mail válido.
	If !EmpTy(cEMAIL)
		If !IsEmail(AllTrim(cEMAIL))
			MsgStop("Conteudo inválido. Favor informar um e-mail válido", cCadastro)
			lRet := .F.
		EndIf
	EndIf
	
Return( lRet )


//-------------------------------------------------------------------------
// Rotina | A020AltCto     | Autor | Rafael Beghini     | Data | 29.03.2016
//-------------------------------------------------------------------------
// Descr. | Código do produto no retorno da consulta padrão (ADJ01)
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function A020AltCto( nRECNO, oLstBx )
	
	Private cCadastro	:= 'Contato Corporativo - ALTERAÇÃO'
	
	INCLUI := .F.
	ALTERA := .T.
	
	SU5->( DBGOTO(nRECNO) )
	A70Altera('SU5', SU5->( nRECNO ), 4)
	
	For nX := 1 To Len(oLstBx:aArray)
		
		If nRECNO == oLstBx:aArray[nX,7]
			oLstBx:aArray[nX,2] := AllTrim(SU5->U5_CONTAT)
			oLstBx:aArray[nX,3] := AllTrim(SU5->U5_EMAIL)
			oLstBx:aArray[nX,4] := AllTrim(SU5->U5_FCOM1)
			oLstBx:aArray[nX,5] := AllTrim(SU5->U5_XCARGO)
			oLstBx:aArray[nX,6] := AllTrim(SU5->U5_XDEPTO)
			Exit
		EndIf
		
	Next nX
	
	oLstBx:Refresh()
	
Return( .T. )


//-------------------------------------------------------------------------
// Rotina | CSCrm10Ret     | Autor | Rafael Beghini     | Data | 28.03.2016
//-------------------------------------------------------------------------
// Descr. | Código do produto no retorno da consulta padrão (ADJ01)
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
User Function CSCrm20Ret()
Return(cAD9_CODCON)


//-------------------------------------------------------------------------
// Rotina | A020CriaCto    | Autor | Rafael Beghini     | Data | 16.04.2018
//-------------------------------------------------------------------------
// Descr. | Crias/Atualiza Contato e realiza o vínculo
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function A020CriaCto( aTRB )

	Local aContato		:= {}
	Local nOpc			:= 3
	Local cNomeCtto		:= ""
	Local cEmail		:= ""
	Local cDDD			:= ""
	Local cFone			:= ""
	Local cCargo		:= ""
	Local cDepto		:= ""
	Local cMsg			:= ""
	Local lRet			:= .T.
	
	Private lMsErroAuto 	:= .F.
	Private lAutoErrNoFile	:= .T.

	cNomeCtto	:= AllTrim( aTRB[1] )
	cEmail		:= AllTrim( Lower(aTRB[2]) )
	cDDD		:= aTRB[3]
	cFone		:= aTRB[4]
	cCargo		:= AllTrim( aTRB[5] )
	cDepto		:= AllTrim( aTRB[6] )
	
	DbSelectArea("SU5")
	SU5->(DbSetOrder(9))	
	IF SU5->(DbSeek(xFilial("SU5") + cEmail))
		//Faco a alteracao na mao, pois a execauto na alteracao desposiciona do registro da tabela SU5
		RecLock("SU5", .F.)
		SU5->U5_CONTAT	:= cNomeCtto	// Nome do contato
		SU5->U5_DDD		:= cDDD       	// DDD do contato
		SU5->U5_FCOM1	:= cFone      	// Telefone do contato
		SU5->U5_XCARGO	:= cCargo      	// Cargo do contato
		SU5->U5_XDEPTO	:= cDepto      	// Departamento do contato
		SU5->U5_TIPOCON	:= '1'			// Corporativo
		SU5->(MsUnLock())
	Else
		nOpc := 3
	
		cNumCont := GetSxeNum("SU5", "U5_CODCONT")		// Pega o proximo numero de contato valido
		ConfirmSX8()									// Confirma o uso do codigo de contato
	
		aContato:={ 	{"U5_CODCONT"	,cNumCont		,Nil},; // Codigo do contato
		{"U5_CONTAT"    ,cNomeCtto		,Nil},; // Nome do contato
		{"U5_TIPOCON"   ,'1' 	      	,Nil},; // CPF do contato.
		{"U5_DDD"       ,cDDD       	,Nil},; // DDD do contato
		{"U5_FCOM1"     ,cFone      	,Nil},; // Telefone residencial do contato
		{"U5_EMAIL"     ,cEmail     	,Nil},;  // E-mail do Contato
		{"U5_XCARGO"    ,cCargo     	,Nil},;  // Cargo do Contato
		{"U5_XDEPTO"    ,cDepto     	,Nil}}  // Departamento do Contato
		MSExecAuto({|x,y| TmkA070(x,y)},aContato,nOpc)
	EndIf

	If lMsErroAuto
		MOSTRAERRO()
		lRet := .F.
		cMsg := 'Contato não pôde ser incluído.'

		cAutoErr := "SU5 --> Erro de inclusão de contato no sistema Protheus MSExecAuto({|x,y| TmkA070(x,y)},aContato,nOpc)" + CRLF + CRLF
		cAutoErr += VarInfo("",aContato,,.f.,.f.) + CRLF + CRLF
		aAutoErr := GetAutoGRLog()
		For nI := 1 To Len(aAutoErr)
			cAutoErr += aAutoErr[nI] + CRLF
		Next nI
		cMsg += cAutoErr
		DisarmTransaction()
	Else
		lRet := .T.
		cMsg := 'Contato incluído com sucesso'
	EndIf

Return({lRet, cMsg})

Static Function A020Valid(aTRB)
	Local lRet := .T.
	IF Empty( aTRB[1] ) .Or. Empty( aTRB[2] ) .Or. Empty( aTRB[3] ) .Or. Empty( aTRB[4] ) 
		MsgAlert('Atenção, os campos de Nome, e-Mail, DDD e telefone são obrigatórios.')
		lRet := .F.
	Else
		lStop := .F.
	EndIF	
Return( lRet )