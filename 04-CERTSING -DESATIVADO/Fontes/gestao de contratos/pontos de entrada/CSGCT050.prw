#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'ApWizard.ch'

#DEFINE cFONT   '<b><font size="4" color="red"><b><u>'
#DEFINE cFONTOK '<font size="5" color="green">'
#DEFINE cNOFONT '</b></font></u></b> '
//-----------------------------------------------------------------------
// Rotina | CSGCT050  | Autor | Rafael Beghini    | Data | 01.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina para realizar o vínculo de contratos PAI x Filho
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSGCT050()
	Local cSQL    := ''
	Local cTRB    := ''
	Local lOk     := .F.
	Local lMark   := .F.
	Local lAcesso := .F.
	Local oDlg
	
	Local oPanelBot
	Local oPanelAll
	Local oWizard, oPanel, oPnl, oGetPesq, oPanelTop
	Local oCancel
	Local oConfirm
	Local aRet := {}
	Local aParamBox := {}
	Local cMV_670USER := 'MV_670USER'
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Private cCadastro := 'Vincular Contratos - Principal x Derivados'
	Private aDADOS    := {}
	
	Private aBKP      := {}
	Private cCodCTR := Space(15)
	Private cDescCTR := ''
	Private oLbx,oLst,oSeek,oPesq
	Private cSeek := Space(15)
	
	cMV_670USER := GetMv( cMV_670USER, .F. )
	
	lAcesso := RetCodUsr() $ cMV_670USER
	IF .NOT. lAcesso
		MsgInfo( cFONT+"ATENÇÃO" + cNOFONT + cFONTOK + "<br><br>Usuário sem direito para acessar esta rotina."+; 
				  "<br>Entre em contato com o gestor de contratos."+ cNOFONT,"CSGCT050 | Vincular Contratos" )
		Return
	EndIF
	
	cSQL += "SELECT CN9_NUMERO, CN9_REVISA, TRIM(CN9_DESCRI) CN9_DESCRI" + CRLF
	cSQL += "FROM "+RetSqlName("CN9")+" CN9 " + CRLF
	cSQL += "WHERE CN9.D_E_L_E_T_= ' '" + CRLF
	cSQL += "AND CN9_FILIAL = '" + xFilial("CN9") + "' " + CRLF
	//cSQL += "AND CN9_SITUAC = '05'" + CRLF
	cSQL += "AND CN9_NUMERO <> '" + cCodCTR + "' " + CRLF
	cSQL += "ORDER BY CN9_NUMERO, CN9_REVISA " + CRLF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	
	While .NOT. (cTRB)->( EOF() )
		aAdd( aDADOS, {lMark,(cTRB)->CN9_NUMERO,(cTRB)->CN9_REVISA,rTrim((cTRB)->CN9_DESCRI)} )
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	
	aBKP := aClone( aDADOS )
	
	DEFINE WIZARD oWizard TITLE cCadastro ;
		HEADER "Wizard para vínculo de Contratos - Certisign" ;
		MESSAGE "Rotina para realizar o vínculo de contrato principal e seus derivados." ;
		TEXT "Selecione o contrato que irá assumir o papel do principal, e após selecione seus derivados." ;
		NEXT {||.T.} ;
		FINISH {|| .T. } ;
		PANEL
    
	    // Primeira etapa
	CREATE PANEL oWizard ;
		HEADER "Selecione o contrato" ;
		MESSAGE "Selecione o contrato que irá assumir o papel do contrato principal" ;
		BACK {|| .T. } ;
		NEXT {|| A050VALID1( cCodCTR, @aDADOS ) } ;
		FINISH {|| .F. } PANEL
	oPanel := oWizard:GetPanel(2)
	   
	@ 10,05  SAY "Contrato" SIZE 20,7 PIXEL OF oPanel
	@ 20,05  MSGET cCodCTR F3 "CN9001" Valid A050SEEK( cCodCTR, @cDescCTR ) Picture "@!"  SIZE 96,9 PIXEL OF oPanel
	@ 20,105 MSGET cDescCTR When .F. SIZE 150,9 PIXEL OF oPanel
	   
	    // Segunda etapa
	CREATE PANEL oWizard ;
		HEADER "Seleção de contrato(s)" ;
		MESSAGE "Selecione um ou mais contrato que será derivado do contrato " ;
		BACK {|| A050VALID3( aDADOS ) } ;
		NEXT {|| .T. } ;
		FINISH {|| A050VALID2( aDADOS, oLbx ) } PANEL
	oPanel := oWizard:GetPanel(3)
	
	oPnl := oWizard:GetPanel(3)
	
	oPanelTop := TPanel():New(15,0,'',oPnl,NIL,.F.,,,,0,20,.F.,.T.)
	oPanelTop:Align := CONTROL_ALIGN_TOP
			
	@ 1,02 MSGET    oSeek  VAR cSeek SIZE 60,9 PIXEL OF oPanelTop
	@ 1,65 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 40,11 PIXEL OF oPanelTop ACTION (A050Pesq(cSeek,@oLbx))
	
	oPanelAll := TPanel():New(0,0,'',oPnl,NIL,.F.,,,,0,14,.F.,.T.)
	oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT
	
	@ 05,05 LISTBOX oLbx FIELDS HEADER 'x','Nr. Contrato','Revisão','Descrição' SIZE 200, 90 OF oPanelAll PIXEL ON ;
		dblClick(aDADOS[oLbx:nAt,1]:=!aDADOS[oLbx:nAt,1])
	oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	oLbx:SetArray(aDADOS)
	oLbx:bLine := { || {Iif(aDADOS[oLbx:nAt,1],oOk,oNo),aDADOS[oLbx:nAt,2],aDADOS[oLbx:nAt,3],aDADOS[oLbx:nAt,4]}}
	oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
		FWMsgRun(,{|| AEval(aDADOS, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os contratos...') }
	
	ACTIVATE WIZARD oWizard CENTERED
	
Return( .T. )

//-----------------------------------------------------------------------
// Rotina | A050SEEK  | Autor | Rafael Beghini    | Data | 01.07.2016
//-----------------------------------------------------------------------
// Descr. | Valida contrato informado.
//-----------------------------------------------------------------------
Static Function A050SEEK( cCodCTR, cDescCTR )
	CN9->( dbSetOrder(7) )
	IF .NOT. CN9->( dbSeek( xFilial('CN9') + cCodCTR + '05' ) )
		MsgAlert('Contrato não localizado. Por favor verifique.')
		Return(.F.)
	EndIF
	cDescCTR := rTrim( Posicione('CN9',7,xFilial('CN9') + cCodCTR + '05','CN9_DESCRI') )
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A050VALID1  | Autor | Rafael Beghini    | Data | 01.07.2016
//-----------------------------------------------------------------------
// Descr. | Valida se foi informado o contrato.
//-----------------------------------------------------------------------
Static Function A050VALID1( cCodCTR, aDADOS )
	Local nPos := 0
	
	IF Empty( cCodCTR )
		MsgAlert('Informe o número do contrato para prosseguir.','Vincular contratos |A050VALID1')
		Return(.F.)
	EndIF
	
	nPos := aScan( aDADOS, {|X| X[2] == cCodCTR} )
	ADel( aDADOS, nPos )
	ASize( aDADOS, Len( aDADOS ) - 1 )
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A050VALID2  | Autor | Rafael Beghini    | Data | 01.07.2016
//-----------------------------------------------------------------------
// Descr. | Valida se foi selecionado o contrato dependente.
//-----------------------------------------------------------------------
Static Function A050VALID2( aDADOS, oLbx )
	Local nL := 0
	Local aProc := {}
	
	IF aScan( aDADOS, {|R| R[1] == .T. } ) < 1
		MsgAlert('Selecione ao menos 01 contrato para prosseguir.','Vincular contratos |A050VALID2')
		Return(.F.)
	EndIF
	
	IF MsgYesNo('Deseja finalizar o processo?')
		For nL := 1 To Len( aDADOS )
			IF aDADOS[nL,1]
				aADD( aProc, aDados[nL] )
			EndIF
		Next nL
		A050GRV( aProc )
	Else
		Return(.F.)
	EndIF
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A050VALID3  | Autor | Rafael Beghini    | Data | 01.07.2016
//-----------------------------------------------------------------------
// Descr. | Restaura o array aDADOS
//-----------------------------------------------------------------------
Static Function A050VALID3( aDADOS )
	aDADOS := aClone( aBKP )
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | A050GRV  | Autor | Rafael Beghini    | Data | 01.07.2016
//-----------------------------------------------------------------------
// Descr. | Realiza a gravacao do contrato PAI no contrato Filho
//-----------------------------------------------------------------------
Static Function A050GRV( aProc )
	Local nL := 0
	
	CN9->( dbSetOrder(1) )
	For nL := 1 To Len( aProc )
		IF CN9->( dbSeek( xFilial('CN9') + aProc[nL,2] + aProc[nL,3] ) )
			CN9->( RecLock('CN9',.F.) )
			CN9->CN9_CTRPAI := cCodCTR
			CN9->( MsUnlock() )
		EndIF
	Next nL
	
	MsgInfo('Processo executado com sucesso, verifique no cadastro do contrato.')
Return(.T.)

//-----------------------------------------------------------------------
// Rotina | GCT50VLD  | Autor | Rafael Beghini    | Data | 30.06.2016
//-----------------------------------------------------------------------
// Descr. | Valida o numero informado no campo Contrato PAI  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function GCT50VLD()
	Local lRet := .T.
	Local cNUMCTR := IIF(INCLUI,M->CN9_NUMERO,CN9->CN9_NUMERO)
	Local cNUMPAI := IIF(INCLUI,M->CN9_CTRPAI,CN9->CN9_CTRPAI)
	
	//Verifica se o numero informado não é o mesmo do contrato atual
	IF cNUMCTR == cNUMPAI
		MsgAlert('Atenção, número inválido. Você está informando o mesmo número do contrato atual.')
		lRet := .F.
	EndIF
	
Return( lRet )

//-----------------------------------------------------------------------
// Rotina | A320Pesq  | Autor | Rafael Beghini    | Data | 22.07.2016
//-----------------------------------------------------------------------
// Descr. | Rotina de pesquisa na interface de seleção de contratos.  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function A050Pesq( cSeek, oLbx )
	Local bAScan := {|| .T. }
	Local nBegin := 1
	Local nEnd   := 0
	Local nP     := 0
	
	nEnd   := Len( oLbx:aArray )
	
	If oLbx:nAt == Len( oLbx:aArray )
		nBegin := 1
	Endif
	
	bAScan := {|p| p[2] == cSeek } 
	nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
	
	If nP > 0
		oLbx:nAt := nP
		oLbx:Refresh()
	Else
		MsgInfo('Contrato não localizado.','Pesquisar')
	Endif
Return

	/*
	+------------------+------------------------------------------------------------+
	!Modulo            ! Diversos                                                   !
	+------------------+------------------------------------------------------------+
	!Nome              ! FiltroF3                                                   !
	+------------------+------------------------------------------------------------+
	!Descricao         ! Função usada para criar uma Consulta Padrão  com SQL       !
	!			       !                                                            !
	!			       !                                                            !
	+------------------+------------------------------------------------------------+
	!Autor             ! Rodrigo Lacerda P Araujo                                   !
	+------------------+------------------------------------------------------------+
	!Data de Criacao   ! 03/01/2013                                                 !
	+------------------+-----------+------------------------------------------------+
	!Campo             ! Tipo	   ! Obrigatorio                                    !
	+------------------+-----------+------------------------------------------------+
	!cTitulo           ! Caracter  !                                                !
	!cQuery            ! Caracter  ! X                                              !
	!nTamCpo           ! Numerico  !                                                !
	!cAlias            ! Caracter  ! X                                              !
	!cCodigo           ! Caracter  !                                                !
	!cCpoChave         ! Caracter  ! X                                              !
	!cTitCampo         ! Caracter  ! X                                              !
	!cMascara          ! Caracter  !                                                !
	!cRetCpo           ! Caracter  ! X                                              !
	!nColuna           ! Numerico  !                                                !
	+------------------+-----------+------------------------------------------------+
	!Parametros:                                                                  !
	!==========		                                                        !
	!          																			   !
	!cTitulo = Titulo da janela da consulta                                         !
	!cQuery  = A consulta SQL que vem do parametro cQuery não pode retornar um outro!
	!nome para o campo pesquisado, pois a rotina valida o nome do campo real        !
	!          																			   !
	!Exemplo Incorreto                                                              !
	!cQuery := "SELECT A1_NOME 'NOME', A1_CGC 'CGC' FROM SA1010 WHERE D_E_L_E_T_='' !
	!          																			   !
	!Exemplo Certo                                                                  !
	!cQuery := "SELECT A1_NOME, A1_CGC FROM SA1010 WHERE D_E_L_E_T_=''              !
	!          																			   !
	!Deve-se manter o nome do campo apenas.                                         !
	!          																			   !
	!nTamCpo   = Tamanho do campo de pesquisar,se não informado assume 30 caracteres!
	!cAlias    = Alias da tabela, ex: SA1                                           !
	!cCodigo   = Conteudo do campo que chama o filtro                               !
	!cCpoChave = Nome do campo que será utilizado para pesquisa, ex: A1_CODIGO      ! 
	!cTitCampo = Titulo do label do campo                                           !
	!cMascara  = Mascara do campo, ex: "@!"                                         !
	!cRetCpo   = Campo que receberá o retorno do filtro                             !
	!nColuna   = Coluna que será retornada na pesquisa, padrão coluna 1             !
	+--------------------------------------------------------------------------------
	*/

User Function FiltroF3(cTitulo,cQuery,nTamCpo,cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)
	Local nLista  
	Local cCampos 	:= ""
	Local bCampo		:= {}
	Local nCont		:= 0
	Local bTitulos	:= {}
	Local aCampos 	:= {}
	Local cTabela 
	Local cCSSGet	:= "QLineEdit{ border: 1px solid gray;border-radius: 3px;background-color: #ffffff;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
	Local cCSSButton:= "QPushButton{background-repeat: none; margin: 2px;background-color: #ffffff;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 5px;border-color: #C0C0C0;font: bold 12px Arial;padding: 6px;QPushButton:pressed {background-color: #ffffff;border-style: inset;}"
	Local cCSSButF3	:= "QPushButton {background-color: #ffffff;margin: 2px;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 3px; border-color: #C0C0C0;font: Normal 10px Arial;padding: 3px;} QPushButton:pressed {background-color: #e6e6f9;border-style: inset;}"
	Local nX		:= 0
 
	Private _oLista	:= nil
	Private _oDlg 	:= nil
	Private _oCodigo
	Private _cCodigo 	
	Private _aDados 	:= {}
	Private _nColuna	:= 0
	
	Default cTitulo 	:= ""
	Default cCodigo 	:= ""
	Default nTamCpo 	:= 30
	Default _nColuna 	:= 1
	Default cTitCampo	:= RetTitle(cCpoChave)
	Default cMascara	:= PesqPict('"'+cAlias+'"',cCpoChave)
 
	_nColuna	:= nColuna
 
	If Empty(cAlias) .OR. Empty(cCpoChave) .OR. Empty(cRetCpo) .OR. Empty(cQuery)
		MsgStop("Os parametro cQuery, cCpoChave, cRetCpo e cAlias são obrigatórios!","Erro")
		Return
	Endif
 
	_cCodigo := Space(nTamCpo)
	_cCodigo := cCodigo
 
	cTabela:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cTabela, .F., .T.)
     
	(cTabela)->(DbGoTop())
	If (cTabela)->(Eof())
		MsgStop("Não há registros para serem exibidos!","Atenção")
		Return
	Endif
   
	Do While (cTabela)->(!Eof())
		/*Cria o array conforme a quantidade de campos existentes na consulta SQL*/
		cCampos	:= ""
		aCampos 	:= {}
		For nX := 1 TO FCount()
			bCampo := {|nX| Field(nX) }
			If ValType((cTabela)->&(EVAL(bCampo,nX)) ) <> "M" .OR. ValType((cTabela)->&(EVAL(bCampo,nX)) ) <> "U"	
				if ValType((cTabela)->&(EVAL(bCampo,nX)) )=="C"
					cCampos += "'" + (cTabela)->&(EVAL(bCampo,nX)) + "',"
				ElseIf ValType((cTabela)->&(EVAL(bCampo,nX)) )=="D"
					cCampos +=  DTOC((cTabela)->&(EVAL(bCampo,nX))) + ","
				Else
					cCampos +=  (cTabela)->&(EVAL(bCampo,nX)) + ","
				Endif
					
				aadd(aCampos,{EVAL(bCampo,nX),Alltrim(RetTitle(EVAL(bCampo,nX))),"LEFT",30})
			Endif
		Next
     
     	If !Empty(cCampos) 
     		cCampos 	:= Substr(cCampos,1,len(cCampos)-1)
     		aAdd( _aDados,&("{"+cCampos+"}"))
     	Endif
     	
		(cTabela)->(DbSkip())     
	Enddo
   
	(cTabela)->(DbCloseArea())
	
	If Len(_aDados) == 0
		MsgInfo("Não há dados para exibir!","Aviso")
		Return
	Endif
   
	nLista := aScan(_aDados, {|x| alltrim(x[1]) == alltrim(_cCodigo)})
     
	iif(nLista = 0,nLista := 1,nLista)
     
	Define MsDialog _oDlg Title "Consulta Padrão" + IIF(!Empty(cTitulo)," - " + cTitulo,"") From 0,0 To 280, 500 Of oMainWnd Pixel
	
	oCodigo:= TGet():New( 003, 005,{|u| if(PCount()>0,_cCodigo:=u,_cCodigo)},_oDlg,205, 010,cMascara,{|| /*Processa({|| FiltroF3P(M->_cCodigo)},"Aguarde...")*/ },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",_cCodigo,,,,,,,cTitCampo + ": ",1 )
	oCodigo:SetCss(cCSSGet)	
	oButton1 := TButton():New(010, 212," &Pesquisar ",_oDlg,{|| Processa({|| FiltroF3P(M->_cCodigo) },"Aguarde...") },037,013,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton1:SetCss(cCSSButton)	
	    
	_oLista:= TCBrowse():New(26,05,245,90,,,,_oDlg,,,,,{|| _oLista:Refresh()},,,,,,,.F.,,.T.,,.F.,,,.f.)
	nCont := 1
        //Para ficar dinâmico a criação das colunas, eu uso macro substituição "&"
	For nX := 1 to len(aCampos)
		cColuna := &('_oLista:AddColumn(TCColumn():New("'+aCampos[nX,2]+'", {|| _aDados[_oLista:nAt,'+StrZero(nCont,2)+']},PesqPict("'+cAlias+'","'+aCampos[nX,1]+'"),,,"'+aCampos[nX,3]+'", '+StrZero(aCampos[nX,4],3)+',.F.,.F.,,{|| .F. },,.F., ) )')
		nCont++
	Next
	_oLista:SetArray(_aDados)
	_oLista:bWhen 		 := { || Len(_aDados) > 0 }
	_oLista:bLDblClick  := { || FiltroF3R(_oLista:nAt, _aDados, cRetCpo)  }
	_oLista:Refresh()
 
	oButton2 := TButton():New(122, 005," OK "			,_oDlg,{|| Processa({|| FiltroF3R(_oLista:nAt, _aDados, cRetCpo) },"Aguarde...") },037,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton2:SetCss(cCSSButton)	
	oButton3 := TButton():New(122, 047," Cancelar "	,_oDlg,{|| _oDlg:End() },037,012,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton3:SetCss(cCSSButton)	
 
	Activate MSDialog _oDlg Centered	
Return(bRet)

//-----------------------------------------------------------------------
// Rotina | FiltroF3P()  | Autor | Leandro Nishihata   | Data | 28.11.2016
//-----------------------------------------------------------------------
// Descr. | – Função para procurar no grid o conteúdo desejado  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------

Static Function FiltroF3P(cBusca)
	Local i := 0
 
	if !Empty(cBusca)
		For i := 1 to len(_aDados)
			//Aqui busco o texto exato, mas pode utilizar a função AT() para pegar parte do texto
			if UPPER(Alltrim(_aDados[i,_nColuna]))==UPPER(Alltrim(cBusca))
				//Se encontrar me posiciono no grid e saio do "For"			
				_oLista:GoPosition(i)
				_oLista:Setfocus()
				exit
			Endif
		Next
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | cn9F3()  | Autor | Leandro Nishihata   | Data | 28.11.2016
//-----------------------------------------------------------------------
// Descr. | – para acionar a consulta padrão e está ser adicionada na tabela SXB – Consulta Padrão do Protheus.  
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------

User Function cn9F3()
	Local cTitulo		:= "Contrato"
	Local cQuery		:= "" 						//obrigatorio
	Local cAlias		:= "CN9"					//obrigatorio
	Local cCpoChave	:= "CN9_NUMERO"					//obrigatorio
	Local cTitCampo	:= RetTitle(cCpoChave)			//obrigatorio
	Local cMascara	:= PesqPict(cAlias,cCpoChave)	//obrigatorio
	Local nTamCpo		:= TamSx3(cCpoChave)[1]		
	Local cRetCpo		:= "M->CN9_CTRPAI"			//obrigatorio
	Local nColuna		:= 1	
	Local cCodigo		:= M->CN9_CTRPAI			//pego o conteudo e levo para minha consulta padrão			
 	Private bRet 		:= .F.
 
   	cQuery := " SELECT CN9.CN9_NUMERO, CN9.CN9_REVISA, replace(CN9.CN9_DESCRI, '''', '') CN9_DESCRI
   	cQuery += " FROM "+RetSQLName("CN9") + " CN9 "
   	cQuery += " WHERE CN9.D_E_L_E_T_ = ' ' 
   	cQuery += " 	  AND CN9.CN9_FILIAL = '" + xFilial("CN9") + "' "
   	cQuery += " 	      AND CN9_SITUAC IN ('01','05','07','08')" // 01=Cancelado;02=Elaboracao;03=Emitido;04=Aprovacao;05=Vigente;06=Paralisa.;07=Sol. Finalizacao;08=Finali.;09=Revisao;10=Revisado 
   	cQuery += " ORDER BY CN9.CN9_NUMERO "
   				
 	bRet := U_FiltroF3(  cTitulo,cQuery,nTamCpo,cAlias,cCodigo,cCpoChave,cTitCampo,cMascara,cRetCpo,nColuna)
 	                  //({'000000000001947','   ','D'IMAGEM DOCUMENTACAO DIGITAL LTDA – EPP                                                            '})
 	
Return(bRet)

//-----------------------------------------------------------------------
// Rotina | FiltroF3R()  | Autor | Leandro Nishihata   | Data | 28.11.2016
//-----------------------------------------------------------------------
// Descr. | – retorno do valor para o campo especificado.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------

Static Function FiltroF3R(nLinha,aDados,cRetCpo)
	cCodigo := aDados[nLinha,_nColuna]
	&(cRetCpo) := cCodigo //Uso desta forma para campos como tGet por exemplo.
	aCpoRet[1] := cCodigo //Não esquecer de alimentar essa variável quando for f3 pois ela e o retorno
	bRet := .T.
	_oDlg:End()    
Return
